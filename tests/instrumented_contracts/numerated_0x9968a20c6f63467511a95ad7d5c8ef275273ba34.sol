1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: operator-filter-registry/src/lib/Constants.sol
232 
233 
234 pragma solidity ^0.8.13;
235 
236 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
237 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
238 
239 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
240 
241 
242 pragma solidity ^0.8.13;
243 
244 interface IOperatorFilterRegistry {
245     /**
246      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
247      *         true if supplied registrant address is not registered.
248      */
249     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
250 
251     /**
252      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
253      */
254     function register(address registrant) external;
255 
256     /**
257      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
258      */
259     function registerAndSubscribe(address registrant, address subscription) external;
260 
261     /**
262      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
263      *         address without subscribing.
264      */
265     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
266 
267     /**
268      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
269      *         Note that this does not remove any filtered addresses or codeHashes.
270      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
271      */
272     function unregister(address addr) external;
273 
274     /**
275      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
276      */
277     function updateOperator(address registrant, address operator, bool filtered) external;
278 
279     /**
280      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
281      */
282     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
283 
284     /**
285      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
286      */
287     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
288 
289     /**
290      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
291      */
292     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
293 
294     /**
295      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
296      *         subscription if present.
297      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
298      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
299      *         used.
300      */
301     function subscribe(address registrant, address registrantToSubscribe) external;
302 
303     /**
304      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
305      */
306     function unsubscribe(address registrant, bool copyExistingEntries) external;
307 
308     /**
309      * @notice Get the subscription address of a given registrant, if any.
310      */
311     function subscriptionOf(address addr) external returns (address registrant);
312 
313     /**
314      * @notice Get the set of addresses subscribed to a given registrant.
315      *         Note that order is not guaranteed as updates are made.
316      */
317     function subscribers(address registrant) external returns (address[] memory);
318 
319     /**
320      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
321      *         Note that order is not guaranteed as updates are made.
322      */
323     function subscriberAt(address registrant, uint256 index) external returns (address);
324 
325     /**
326      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
327      */
328     function copyEntriesOf(address registrant, address registrantToCopy) external;
329 
330     /**
331      * @notice Returns true if operator is filtered by a given address or its subscription.
332      */
333     function isOperatorFiltered(address registrant, address operator) external returns (bool);
334 
335     /**
336      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
337      */
338     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
339 
340     /**
341      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
342      */
343     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
344 
345     /**
346      * @notice Returns a list of filtered operators for a given address or its subscription.
347      */
348     function filteredOperators(address addr) external returns (address[] memory);
349 
350     /**
351      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
352      *         Note that order is not guaranteed as updates are made.
353      */
354     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
355 
356     /**
357      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
358      *         its subscription.
359      *         Note that order is not guaranteed as updates are made.
360      */
361     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
362 
363     /**
364      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
365      *         its subscription.
366      *         Note that order is not guaranteed as updates are made.
367      */
368     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
369 
370     /**
371      * @notice Returns true if an address has registered
372      */
373     function isRegistered(address addr) external returns (bool);
374 
375     /**
376      * @dev Convenience method to compute the code hash of an arbitrary contract
377      */
378     function codeHashOf(address addr) external returns (bytes32);
379 }
380 
381 // File: operator-filter-registry/src/OperatorFilterer.sol
382 
383 
384 pragma solidity ^0.8.13;
385 
386 
387 /**
388  * @title  OperatorFilterer
389  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
390  *         registrant's entries in the OperatorFilterRegistry.
391  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
392  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
393  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
394  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
395  *         administration methods on the contract itself to interact with the registry otherwise the subscription
396  *         will be locked to the options set during construction.
397  */
398 
399 abstract contract OperatorFilterer {
400     /// @dev Emitted when an operator is not allowed.
401     error OperatorNotAllowed(address operator);
402 
403     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
404         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
405 
406     /// @dev The constructor that is called when the contract is being deployed.
407     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
408         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
409         // will not revert, but the contract will need to be registered with the registry once it is deployed in
410         // order for the modifier to filter addresses.
411         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
412             if (subscribe) {
413                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
414             } else {
415                 if (subscriptionOrRegistrantToCopy != address(0)) {
416                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
417                 } else {
418                     OPERATOR_FILTER_REGISTRY.register(address(this));
419                 }
420             }
421         }
422     }
423 
424     /**
425      * @dev A helper function to check if an operator is allowed.
426      */
427     modifier onlyAllowedOperator(address from) virtual {
428         // Allow spending tokens from addresses with balance
429         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
430         // from an EOA.
431         if (from != msg.sender) {
432             _checkFilterOperator(msg.sender);
433         }
434         _;
435     }
436 
437     /**
438      * @dev A helper function to check if an operator approval is allowed.
439      */
440     modifier onlyAllowedOperatorApproval(address operator) virtual {
441         _checkFilterOperator(operator);
442         _;
443     }
444 
445     /**
446      * @dev A helper function to check if an operator is allowed.
447      */
448     function _checkFilterOperator(address operator) internal view virtual {
449         // Check registry code length to facilitate testing in environments without a deployed registry.
450         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
451             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
452             // may specify their own OperatorFilterRegistry implementations, which may behave differently
453             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
454                 revert OperatorNotAllowed(operator);
455             }
456         }
457     }
458 }
459 
460 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
461 
462 
463 pragma solidity ^0.8.13;
464 
465 
466 /**
467  * @title  DefaultOperatorFilterer
468  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
469  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
470  *         administration methods on the contract itself to interact with the registry otherwise the subscription
471  *         will be locked to the options set during construction.
472  */
473 
474 abstract contract DefaultOperatorFilterer is OperatorFilterer {
475     /// @dev The constructor that is called when the contract is being deployed.
476     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
477 }
478 
479 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
480 
481 
482 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Interface of the ERC165 standard, as defined in the
488  * https://eips.ethereum.org/EIPS/eip-165[EIP].
489  *
490  * Implementers can declare support of contract interfaces, which can then be
491  * queried by others ({ERC165Checker}).
492  *
493  * For an implementation, see {ERC165}.
494  */
495 interface IERC165 {
496     /**
497      * @dev Returns true if this contract implements the interface defined by
498      * `interfaceId`. See the corresponding
499      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
500      * to learn more about how these ids are created.
501      *
502      * This function call must use less than 30 000 gas.
503      */
504     function supportsInterface(bytes4 interfaceId) external view returns (bool);
505 }
506 
507 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev Interface for the NFT Royalty Standard.
517  *
518  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
519  * support for royalty payments across all NFT marketplaces and ecosystem participants.
520  *
521  * _Available since v4.5._
522  */
523 interface IERC2981 is IERC165 {
524     /**
525      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
526      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
527      */
528     function royaltyInfo(uint256 tokenId, uint256 salePrice)
529         external
530         view
531         returns (address receiver, uint256 royaltyAmount);
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
535 
536 
537 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Required interface of an ERC721 compliant contract.
544  */
545 interface IERC721 is IERC165 {
546     /**
547      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
548      */
549     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
550 
551     /**
552      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
553      */
554     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
558      */
559     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
560 
561     /**
562      * @dev Returns the number of tokens in ``owner``'s account.
563      */
564     function balanceOf(address owner) external view returns (uint256 balance);
565 
566     /**
567      * @dev Returns the owner of the `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function ownerOf(uint256 tokenId) external view returns (address owner);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId,
592         bytes calldata data
593     ) external;
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Transfers `tokenId` token from `from` to `to`.
617      *
618      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
619      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
620      * understand this adds an external call which potentially creates a reentrancy vulnerability.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
639      * The approval is cleared when the token is transferred.
640      *
641      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
642      *
643      * Requirements:
644      *
645      * - The caller must own the token or be an approved operator.
646      * - `tokenId` must exist.
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address to, uint256 tokenId) external;
651 
652     /**
653      * @dev Approve or remove `operator` as an operator for the caller.
654      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
655      *
656      * Requirements:
657      *
658      * - The `operator` cannot be the caller.
659      *
660      * Emits an {ApprovalForAll} event.
661      */
662     function setApprovalForAll(address operator, bool _approved) external;
663 
664     /**
665      * @dev Returns the account approved for `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
675      *
676      * See {setApprovalForAll}
677      */
678     function isApprovedForAll(address owner, address operator) external view returns (bool);
679 }
680 
681 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
682 
683 
684 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @dev These functions deal with verification of Merkle Tree proofs.
690  *
691  * The tree and the proofs can be generated using our
692  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
693  * You will find a quickstart guide in the readme.
694  *
695  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
696  * hashing, or use a hash function other than keccak256 for hashing leaves.
697  * This is because the concatenation of a sorted pair of internal nodes in
698  * the merkle tree could be reinterpreted as a leaf value.
699  * OpenZeppelin's JavaScript library generates merkle trees that are safe
700  * against this attack out of the box.
701  */
702 library MerkleProof {
703     /**
704      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
705      * defined by `root`. For this, a `proof` must be provided, containing
706      * sibling hashes on the branch from the leaf to the root of the tree. Each
707      * pair of leaves and each pair of pre-images are assumed to be sorted.
708      */
709     function verify(
710         bytes32[] memory proof,
711         bytes32 root,
712         bytes32 leaf
713     ) internal pure returns (bool) {
714         return processProof(proof, leaf) == root;
715     }
716 
717     /**
718      * @dev Calldata version of {verify}
719      *
720      * _Available since v4.7._
721      */
722     function verifyCalldata(
723         bytes32[] calldata proof,
724         bytes32 root,
725         bytes32 leaf
726     ) internal pure returns (bool) {
727         return processProofCalldata(proof, leaf) == root;
728     }
729 
730     /**
731      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
732      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
733      * hash matches the root of the tree. When processing the proof, the pairs
734      * of leafs & pre-images are assumed to be sorted.
735      *
736      * _Available since v4.4._
737      */
738     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
739         bytes32 computedHash = leaf;
740         for (uint256 i = 0; i < proof.length; i++) {
741             computedHash = _hashPair(computedHash, proof[i]);
742         }
743         return computedHash;
744     }
745 
746     /**
747      * @dev Calldata version of {processProof}
748      *
749      * _Available since v4.7._
750      */
751     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
752         bytes32 computedHash = leaf;
753         for (uint256 i = 0; i < proof.length; i++) {
754             computedHash = _hashPair(computedHash, proof[i]);
755         }
756         return computedHash;
757     }
758 
759     /**
760      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
761      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
762      *
763      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
764      *
765      * _Available since v4.7._
766      */
767     function multiProofVerify(
768         bytes32[] memory proof,
769         bool[] memory proofFlags,
770         bytes32 root,
771         bytes32[] memory leaves
772     ) internal pure returns (bool) {
773         return processMultiProof(proof, proofFlags, leaves) == root;
774     }
775 
776     /**
777      * @dev Calldata version of {multiProofVerify}
778      *
779      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
780      *
781      * _Available since v4.7._
782      */
783     function multiProofVerifyCalldata(
784         bytes32[] calldata proof,
785         bool[] calldata proofFlags,
786         bytes32 root,
787         bytes32[] memory leaves
788     ) internal pure returns (bool) {
789         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
790     }
791 
792     /**
793      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
794      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
795      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
796      * respectively.
797      *
798      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
799      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
800      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
801      *
802      * _Available since v4.7._
803      */
804     function processMultiProof(
805         bytes32[] memory proof,
806         bool[] memory proofFlags,
807         bytes32[] memory leaves
808     ) internal pure returns (bytes32 merkleRoot) {
809         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
810         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
811         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
812         // the merkle tree.
813         uint256 leavesLen = leaves.length;
814         uint256 totalHashes = proofFlags.length;
815 
816         // Check proof validity.
817         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
818 
819         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
820         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
821         bytes32[] memory hashes = new bytes32[](totalHashes);
822         uint256 leafPos = 0;
823         uint256 hashPos = 0;
824         uint256 proofPos = 0;
825         // At each step, we compute the next hash using two values:
826         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
827         //   get the next hash.
828         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
829         //   `proof` array.
830         for (uint256 i = 0; i < totalHashes; i++) {
831             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
832             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
833             hashes[i] = _hashPair(a, b);
834         }
835 
836         if (totalHashes > 0) {
837             return hashes[totalHashes - 1];
838         } else if (leavesLen > 0) {
839             return leaves[0];
840         } else {
841             return proof[0];
842         }
843     }
844 
845     /**
846      * @dev Calldata version of {processMultiProof}.
847      *
848      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
849      *
850      * _Available since v4.7._
851      */
852     function processMultiProofCalldata(
853         bytes32[] calldata proof,
854         bool[] calldata proofFlags,
855         bytes32[] memory leaves
856     ) internal pure returns (bytes32 merkleRoot) {
857         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
858         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
859         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
860         // the merkle tree.
861         uint256 leavesLen = leaves.length;
862         uint256 totalHashes = proofFlags.length;
863 
864         // Check proof validity.
865         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
866 
867         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
868         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
869         bytes32[] memory hashes = new bytes32[](totalHashes);
870         uint256 leafPos = 0;
871         uint256 hashPos = 0;
872         uint256 proofPos = 0;
873         // At each step, we compute the next hash using two values:
874         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
875         //   get the next hash.
876         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
877         //   `proof` array.
878         for (uint256 i = 0; i < totalHashes; i++) {
879             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
880             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
881             hashes[i] = _hashPair(a, b);
882         }
883 
884         if (totalHashes > 0) {
885             return hashes[totalHashes - 1];
886         } else if (leavesLen > 0) {
887             return leaves[0];
888         } else {
889             return proof[0];
890         }
891     }
892 
893     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
894         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
895     }
896 
897     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
898         /// @solidity memory-safe-assembly
899         assembly {
900             mstore(0x00, a)
901             mstore(0x20, b)
902             value := keccak256(0x00, 0x40)
903         }
904     }
905 }
906 
907 // File: @openzeppelin/contracts/utils/Context.sol
908 
909 
910 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 /**
915  * @dev Provides information about the current execution context, including the
916  * sender of the transaction and its data. While these are generally available
917  * via msg.sender and msg.data, they should not be accessed in such a direct
918  * manner, since when dealing with meta-transactions the account sending and
919  * paying for execution may not be the actual sender (as far as an application
920  * is concerned).
921  *
922  * This contract is only required for intermediate, library-like contracts.
923  */
924 abstract contract Context {
925     function _msgSender() internal view virtual returns (address) {
926         return msg.sender;
927     }
928 
929     function _msgData() internal view virtual returns (bytes calldata) {
930         return msg.data;
931     }
932 }
933 
934 // File: @openzeppelin/contracts/access/Ownable.sol
935 
936 
937 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 
942 /**
943  * @dev Contract module which provides a basic access control mechanism, where
944  * there is an account (an owner) that can be granted exclusive access to
945  * specific functions.
946  *
947  * By default, the owner account will be the one that deploys the contract. This
948  * can later be changed with {transferOwnership}.
949  *
950  * This module is used through inheritance. It will make available the modifier
951  * `onlyOwner`, which can be applied to your functions to restrict their use to
952  * the owner.
953  */
954 abstract contract Ownable is Context {
955     address private _owner;
956 
957     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
958 
959     /**
960      * @dev Initializes the contract setting the deployer as the initial owner.
961      */
962     constructor() {
963         _transferOwnership(_msgSender());
964     }
965 
966     /**
967      * @dev Throws if called by any account other than the owner.
968      */
969     modifier onlyOwner() {
970         _checkOwner();
971         _;
972     }
973 
974     /**
975      * @dev Returns the address of the current owner.
976      */
977     function owner() public view virtual returns (address) {
978         return _owner;
979     }
980 
981     /**
982      * @dev Throws if the sender is not the owner.
983      */
984     function _checkOwner() internal view virtual {
985         require(owner() == _msgSender(), "Ownable: caller is not the owner");
986     }
987 
988     /**
989      * @dev Leaves the contract without owner. It will not be possible to call
990      * `onlyOwner` functions anymore. Can only be called by the current owner.
991      *
992      * NOTE: Renouncing ownership will leave the contract without an owner,
993      * thereby removing any functionality that is only available to the owner.
994      */
995     function renounceOwnership() public virtual onlyOwner {
996         _transferOwnership(address(0));
997     }
998 
999     /**
1000      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1001      * Can only be called by the current owner.
1002      */
1003     function transferOwnership(address newOwner) public virtual onlyOwner {
1004         require(newOwner != address(0), "Ownable: new owner is the zero address");
1005         _transferOwnership(newOwner);
1006     }
1007 
1008     /**
1009      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1010      * Internal function without access restriction.
1011      */
1012     function _transferOwnership(address newOwner) internal virtual {
1013         address oldOwner = _owner;
1014         _owner = newOwner;
1015         emit OwnershipTransferred(oldOwner, newOwner);
1016     }
1017 }
1018 
1019 // File: @openzeppelin/contracts/utils/math/Math.sol
1020 
1021 
1022 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 /**
1027  * @dev Standard math utilities missing in the Solidity language.
1028  */
1029 library Math {
1030     enum Rounding {
1031         Down, // Toward negative infinity
1032         Up, // Toward infinity
1033         Zero // Toward zero
1034     }
1035 
1036     /**
1037      * @dev Returns the largest of two numbers.
1038      */
1039     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1040         return a > b ? a : b;
1041     }
1042 
1043     /**
1044      * @dev Returns the smallest of two numbers.
1045      */
1046     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1047         return a < b ? a : b;
1048     }
1049 
1050     /**
1051      * @dev Returns the average of two numbers. The result is rounded towards
1052      * zero.
1053      */
1054     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1055         // (a + b) / 2 can overflow.
1056         return (a & b) + (a ^ b) / 2;
1057     }
1058 
1059     /**
1060      * @dev Returns the ceiling of the division of two numbers.
1061      *
1062      * This differs from standard division with `/` in that it rounds up instead
1063      * of rounding down.
1064      */
1065     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1066         // (a + b - 1) / b can overflow on addition, so we distribute.
1067         return a == 0 ? 0 : (a - 1) / b + 1;
1068     }
1069 
1070     /**
1071      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1072      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1073      * with further edits by Uniswap Labs also under MIT license.
1074      */
1075     function mulDiv(
1076         uint256 x,
1077         uint256 y,
1078         uint256 denominator
1079     ) internal pure returns (uint256 result) {
1080         unchecked {
1081             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1082             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1083             // variables such that product = prod1 * 2^256 + prod0.
1084             uint256 prod0; // Least significant 256 bits of the product
1085             uint256 prod1; // Most significant 256 bits of the product
1086             assembly {
1087                 let mm := mulmod(x, y, not(0))
1088                 prod0 := mul(x, y)
1089                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1090             }
1091 
1092             // Handle non-overflow cases, 256 by 256 division.
1093             if (prod1 == 0) {
1094                 return prod0 / denominator;
1095             }
1096 
1097             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1098             require(denominator > prod1);
1099 
1100             ///////////////////////////////////////////////
1101             // 512 by 256 division.
1102             ///////////////////////////////////////////////
1103 
1104             // Make division exact by subtracting the remainder from [prod1 prod0].
1105             uint256 remainder;
1106             assembly {
1107                 // Compute remainder using mulmod.
1108                 remainder := mulmod(x, y, denominator)
1109 
1110                 // Subtract 256 bit number from 512 bit number.
1111                 prod1 := sub(prod1, gt(remainder, prod0))
1112                 prod0 := sub(prod0, remainder)
1113             }
1114 
1115             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1116             // See https://cs.stackexchange.com/q/138556/92363.
1117 
1118             // Does not overflow because the denominator cannot be zero at this stage in the function.
1119             uint256 twos = denominator & (~denominator + 1);
1120             assembly {
1121                 // Divide denominator by twos.
1122                 denominator := div(denominator, twos)
1123 
1124                 // Divide [prod1 prod0] by twos.
1125                 prod0 := div(prod0, twos)
1126 
1127                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1128                 twos := add(div(sub(0, twos), twos), 1)
1129             }
1130 
1131             // Shift in bits from prod1 into prod0.
1132             prod0 |= prod1 * twos;
1133 
1134             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1135             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1136             // four bits. That is, denominator * inv = 1 mod 2^4.
1137             uint256 inverse = (3 * denominator) ^ 2;
1138 
1139             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1140             // in modular arithmetic, doubling the correct bits in each step.
1141             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1142             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1143             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1144             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1145             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1146             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1147 
1148             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1149             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1150             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1151             // is no longer required.
1152             result = prod0 * inverse;
1153             return result;
1154         }
1155     }
1156 
1157     /**
1158      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1159      */
1160     function mulDiv(
1161         uint256 x,
1162         uint256 y,
1163         uint256 denominator,
1164         Rounding rounding
1165     ) internal pure returns (uint256) {
1166         uint256 result = mulDiv(x, y, denominator);
1167         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1168             result += 1;
1169         }
1170         return result;
1171     }
1172 
1173     /**
1174      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1175      *
1176      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1177      */
1178     function sqrt(uint256 a) internal pure returns (uint256) {
1179         if (a == 0) {
1180             return 0;
1181         }
1182 
1183         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1184         //
1185         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1186         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1187         //
1188         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1189         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1190         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1191         //
1192         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1193         uint256 result = 1 << (log2(a) >> 1);
1194 
1195         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1196         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1197         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1198         // into the expected uint128 result.
1199         unchecked {
1200             result = (result + a / result) >> 1;
1201             result = (result + a / result) >> 1;
1202             result = (result + a / result) >> 1;
1203             result = (result + a / result) >> 1;
1204             result = (result + a / result) >> 1;
1205             result = (result + a / result) >> 1;
1206             result = (result + a / result) >> 1;
1207             return min(result, a / result);
1208         }
1209     }
1210 
1211     /**
1212      * @notice Calculates sqrt(a), following the selected rounding direction.
1213      */
1214     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1215         unchecked {
1216             uint256 result = sqrt(a);
1217             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1218         }
1219     }
1220 
1221     /**
1222      * @dev Return the log in base 2, rounded down, of a positive value.
1223      * Returns 0 if given 0.
1224      */
1225     function log2(uint256 value) internal pure returns (uint256) {
1226         uint256 result = 0;
1227         unchecked {
1228             if (value >> 128 > 0) {
1229                 value >>= 128;
1230                 result += 128;
1231             }
1232             if (value >> 64 > 0) {
1233                 value >>= 64;
1234                 result += 64;
1235             }
1236             if (value >> 32 > 0) {
1237                 value >>= 32;
1238                 result += 32;
1239             }
1240             if (value >> 16 > 0) {
1241                 value >>= 16;
1242                 result += 16;
1243             }
1244             if (value >> 8 > 0) {
1245                 value >>= 8;
1246                 result += 8;
1247             }
1248             if (value >> 4 > 0) {
1249                 value >>= 4;
1250                 result += 4;
1251             }
1252             if (value >> 2 > 0) {
1253                 value >>= 2;
1254                 result += 2;
1255             }
1256             if (value >> 1 > 0) {
1257                 result += 1;
1258             }
1259         }
1260         return result;
1261     }
1262 
1263     /**
1264      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1265      * Returns 0 if given 0.
1266      */
1267     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1268         unchecked {
1269             uint256 result = log2(value);
1270             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1271         }
1272     }
1273 
1274     /**
1275      * @dev Return the log in base 10, rounded down, of a positive value.
1276      * Returns 0 if given 0.
1277      */
1278     function log10(uint256 value) internal pure returns (uint256) {
1279         uint256 result = 0;
1280         unchecked {
1281             if (value >= 10**64) {
1282                 value /= 10**64;
1283                 result += 64;
1284             }
1285             if (value >= 10**32) {
1286                 value /= 10**32;
1287                 result += 32;
1288             }
1289             if (value >= 10**16) {
1290                 value /= 10**16;
1291                 result += 16;
1292             }
1293             if (value >= 10**8) {
1294                 value /= 10**8;
1295                 result += 8;
1296             }
1297             if (value >= 10**4) {
1298                 value /= 10**4;
1299                 result += 4;
1300             }
1301             if (value >= 10**2) {
1302                 value /= 10**2;
1303                 result += 2;
1304             }
1305             if (value >= 10**1) {
1306                 result += 1;
1307             }
1308         }
1309         return result;
1310     }
1311 
1312     /**
1313      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1314      * Returns 0 if given 0.
1315      */
1316     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1317         unchecked {
1318             uint256 result = log10(value);
1319             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1320         }
1321     }
1322 
1323     /**
1324      * @dev Return the log in base 256, rounded down, of a positive value.
1325      * Returns 0 if given 0.
1326      *
1327      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1328      */
1329     function log256(uint256 value) internal pure returns (uint256) {
1330         uint256 result = 0;
1331         unchecked {
1332             if (value >> 128 > 0) {
1333                 value >>= 128;
1334                 result += 16;
1335             }
1336             if (value >> 64 > 0) {
1337                 value >>= 64;
1338                 result += 8;
1339             }
1340             if (value >> 32 > 0) {
1341                 value >>= 32;
1342                 result += 4;
1343             }
1344             if (value >> 16 > 0) {
1345                 value >>= 16;
1346                 result += 2;
1347             }
1348             if (value >> 8 > 0) {
1349                 result += 1;
1350             }
1351         }
1352         return result;
1353     }
1354 
1355     /**
1356      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1357      * Returns 0 if given 0.
1358      */
1359     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1360         unchecked {
1361             uint256 result = log256(value);
1362             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1363         }
1364     }
1365 }
1366 
1367 // File: @openzeppelin/contracts/utils/Strings.sol
1368 
1369 
1370 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1371 
1372 pragma solidity ^0.8.0;
1373 
1374 
1375 /**
1376  * @dev String operations.
1377  */
1378 library Strings {
1379     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1380     uint8 private constant _ADDRESS_LENGTH = 20;
1381 
1382     /**
1383      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1384      */
1385     function toString(uint256 value) internal pure returns (string memory) {
1386         unchecked {
1387             uint256 length = Math.log10(value) + 1;
1388             string memory buffer = new string(length);
1389             uint256 ptr;
1390             /// @solidity memory-safe-assembly
1391             assembly {
1392                 ptr := add(buffer, add(32, length))
1393             }
1394             while (true) {
1395                 ptr--;
1396                 /// @solidity memory-safe-assembly
1397                 assembly {
1398                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1399                 }
1400                 value /= 10;
1401                 if (value == 0) break;
1402             }
1403             return buffer;
1404         }
1405     }
1406 
1407     /**
1408      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1409      */
1410     function toHexString(uint256 value) internal pure returns (string memory) {
1411         unchecked {
1412             return toHexString(value, Math.log256(value) + 1);
1413         }
1414     }
1415 
1416     /**
1417      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1418      */
1419     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1420         bytes memory buffer = new bytes(2 * length + 2);
1421         buffer[0] = "0";
1422         buffer[1] = "x";
1423         for (uint256 i = 2 * length + 1; i > 1; --i) {
1424             buffer[i] = _SYMBOLS[value & 0xf];
1425             value >>= 4;
1426         }
1427         require(value == 0, "Strings: hex length insufficient");
1428         return string(buffer);
1429     }
1430 
1431     /**
1432      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1433      */
1434     function toHexString(address addr) internal pure returns (string memory) {
1435         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1436     }
1437 }
1438 
1439 // File: erc721a/contracts/IERC721A.sol
1440 
1441 
1442 // ERC721A Contracts v4.2.3
1443 // Creator: Chiru Labs
1444 
1445 pragma solidity ^0.8.4;
1446 
1447 /**
1448  * @dev Interface of ERC721A.
1449  */
1450 interface IERC721A {
1451     /**
1452      * The caller must own the token or be an approved operator.
1453      */
1454     error ApprovalCallerNotOwnerNorApproved();
1455 
1456     /**
1457      * The token does not exist.
1458      */
1459     error ApprovalQueryForNonexistentToken();
1460 
1461     /**
1462      * Cannot query the balance for the zero address.
1463      */
1464     error BalanceQueryForZeroAddress();
1465 
1466     /**
1467      * Cannot mint to the zero address.
1468      */
1469     error MintToZeroAddress();
1470 
1471     /**
1472      * The quantity of tokens minted must be more than zero.
1473      */
1474     error MintZeroQuantity();
1475 
1476     /**
1477      * The token does not exist.
1478      */
1479     error OwnerQueryForNonexistentToken();
1480 
1481     /**
1482      * The caller must own the token or be an approved operator.
1483      */
1484     error TransferCallerNotOwnerNorApproved();
1485 
1486     /**
1487      * The token must be owned by `from`.
1488      */
1489     error TransferFromIncorrectOwner();
1490 
1491     /**
1492      * Cannot safely transfer to a contract that does not implement the
1493      * ERC721Receiver interface.
1494      */
1495     error TransferToNonERC721ReceiverImplementer();
1496 
1497     /**
1498      * Cannot transfer to the zero address.
1499      */
1500     error TransferToZeroAddress();
1501 
1502     /**
1503      * The token does not exist.
1504      */
1505     error URIQueryForNonexistentToken();
1506 
1507     /**
1508      * The `quantity` minted with ERC2309 exceeds the safety limit.
1509      */
1510     error MintERC2309QuantityExceedsLimit();
1511 
1512     /**
1513      * The `extraData` cannot be set on an unintialized ownership slot.
1514      */
1515     error OwnershipNotInitializedForExtraData();
1516 
1517     // =============================================================
1518     //                            STRUCTS
1519     // =============================================================
1520 
1521     struct TokenOwnership {
1522         // The address of the owner.
1523         address addr;
1524         // Stores the start time of ownership with minimal overhead for tokenomics.
1525         uint64 startTimestamp;
1526         // Whether the token has been burned.
1527         bool burned;
1528         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1529         uint24 extraData;
1530     }
1531 
1532     // =============================================================
1533     //                         TOKEN COUNTERS
1534     // =============================================================
1535 
1536     /**
1537      * @dev Returns the total number of tokens in existence.
1538      * Burned tokens will reduce the count.
1539      * To get the total number of tokens minted, please see {_totalMinted}.
1540      */
1541     function totalSupply() external view returns (uint256);
1542 
1543     // =============================================================
1544     //                            IERC165
1545     // =============================================================
1546 
1547     /**
1548      * @dev Returns true if this contract implements the interface defined by
1549      * `interfaceId`. See the corresponding
1550      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1551      * to learn more about how these ids are created.
1552      *
1553      * This function call must use less than 30000 gas.
1554      */
1555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1556 
1557     // =============================================================
1558     //                            IERC721
1559     // =============================================================
1560 
1561     /**
1562      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1563      */
1564     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1565 
1566     /**
1567      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1568      */
1569     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1570 
1571     /**
1572      * @dev Emitted when `owner` enables or disables
1573      * (`approved`) `operator` to manage all of its assets.
1574      */
1575     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1576 
1577     /**
1578      * @dev Returns the number of tokens in `owner`'s account.
1579      */
1580     function balanceOf(address owner) external view returns (uint256 balance);
1581 
1582     /**
1583      * @dev Returns the owner of the `tokenId` token.
1584      *
1585      * Requirements:
1586      *
1587      * - `tokenId` must exist.
1588      */
1589     function ownerOf(uint256 tokenId) external view returns (address owner);
1590 
1591     /**
1592      * @dev Safely transfers `tokenId` token from `from` to `to`,
1593      * checking first that contract recipients are aware of the ERC721 protocol
1594      * to prevent tokens from being forever locked.
1595      *
1596      * Requirements:
1597      *
1598      * - `from` cannot be the zero address.
1599      * - `to` cannot be the zero address.
1600      * - `tokenId` token must exist and be owned by `from`.
1601      * - If the caller is not `from`, it must be have been allowed to move
1602      * this token by either {approve} or {setApprovalForAll}.
1603      * - If `to` refers to a smart contract, it must implement
1604      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function safeTransferFrom(
1609         address from,
1610         address to,
1611         uint256 tokenId,
1612         bytes calldata data
1613     ) external payable;
1614 
1615     /**
1616      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1617      */
1618     function safeTransferFrom(
1619         address from,
1620         address to,
1621         uint256 tokenId
1622     ) external payable;
1623 
1624     /**
1625      * @dev Transfers `tokenId` from `from` to `to`.
1626      *
1627      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1628      * whenever possible.
1629      *
1630      * Requirements:
1631      *
1632      * - `from` cannot be the zero address.
1633      * - `to` cannot be the zero address.
1634      * - `tokenId` token must be owned by `from`.
1635      * - If the caller is not `from`, it must be approved to move this token
1636      * by either {approve} or {setApprovalForAll}.
1637      *
1638      * Emits a {Transfer} event.
1639      */
1640     function transferFrom(
1641         address from,
1642         address to,
1643         uint256 tokenId
1644     ) external payable;
1645 
1646     /**
1647      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1648      * The approval is cleared when the token is transferred.
1649      *
1650      * Only a single account can be approved at a time, so approving the
1651      * zero address clears previous approvals.
1652      *
1653      * Requirements:
1654      *
1655      * - The caller must own the token or be an approved operator.
1656      * - `tokenId` must exist.
1657      *
1658      * Emits an {Approval} event.
1659      */
1660     function approve(address to, uint256 tokenId) external payable;
1661 
1662     /**
1663      * @dev Approve or remove `operator` as an operator for the caller.
1664      * Operators can call {transferFrom} or {safeTransferFrom}
1665      * for any token owned by the caller.
1666      *
1667      * Requirements:
1668      *
1669      * - The `operator` cannot be the caller.
1670      *
1671      * Emits an {ApprovalForAll} event.
1672      */
1673     function setApprovalForAll(address operator, bool _approved) external;
1674 
1675     /**
1676      * @dev Returns the account approved for `tokenId` token.
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must exist.
1681      */
1682     function getApproved(uint256 tokenId) external view returns (address operator);
1683 
1684     /**
1685      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1686      *
1687      * See {setApprovalForAll}.
1688      */
1689     function isApprovedForAll(address owner, address operator) external view returns (bool);
1690 
1691     // =============================================================
1692     //                        IERC721Metadata
1693     // =============================================================
1694 
1695     /**
1696      * @dev Returns the token collection name.
1697      */
1698     function name() external view returns (string memory);
1699 
1700     /**
1701      * @dev Returns the token collection symbol.
1702      */
1703     function symbol() external view returns (string memory);
1704 
1705     /**
1706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1707      */
1708     function tokenURI(uint256 tokenId) external view returns (string memory);
1709 
1710     // =============================================================
1711     //                           IERC2309
1712     // =============================================================
1713 
1714     /**
1715      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1716      * (inclusive) is transferred from `from` to `to`, as defined in the
1717      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1718      *
1719      * See {_mintERC2309} for more details.
1720      */
1721     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1722 }
1723 
1724 // File: erc721a/contracts/ERC721A.sol
1725 
1726 
1727 // ERC721A Contracts v4.2.3
1728 // Creator: Chiru Labs
1729 
1730 pragma solidity ^0.8.4;
1731 
1732 
1733 /**
1734  * @dev Interface of ERC721 token receiver.
1735  */
1736 interface ERC721A__IERC721Receiver {
1737     function onERC721Received(
1738         address operator,
1739         address from,
1740         uint256 tokenId,
1741         bytes calldata data
1742     ) external returns (bytes4);
1743 }
1744 
1745 /**
1746  * @title ERC721A
1747  *
1748  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1749  * Non-Fungible Token Standard, including the Metadata extension.
1750  * Optimized for lower gas during batch mints.
1751  *
1752  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1753  * starting from `_startTokenId()`.
1754  *
1755  * Assumptions:
1756  *
1757  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1758  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1759  */
1760 contract ERC721A is IERC721A {
1761     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1762     struct TokenApprovalRef {
1763         address value;
1764     }
1765 
1766     // =============================================================
1767     //                           CONSTANTS
1768     // =============================================================
1769 
1770     // Mask of an entry in packed address data.
1771     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1772 
1773     // The bit position of `numberMinted` in packed address data.
1774     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1775 
1776     // The bit position of `numberBurned` in packed address data.
1777     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1778 
1779     // The bit position of `aux` in packed address data.
1780     uint256 private constant _BITPOS_AUX = 192;
1781 
1782     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1783     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1784 
1785     // The bit position of `startTimestamp` in packed ownership.
1786     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1787 
1788     // The bit mask of the `burned` bit in packed ownership.
1789     uint256 private constant _BITMASK_BURNED = 1 << 224;
1790 
1791     // The bit position of the `nextInitialized` bit in packed ownership.
1792     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1793 
1794     // The bit mask of the `nextInitialized` bit in packed ownership.
1795     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1796 
1797     // The bit position of `extraData` in packed ownership.
1798     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1799 
1800     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1801     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1802 
1803     // The mask of the lower 160 bits for addresses.
1804     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1805 
1806     // The maximum `quantity` that can be minted with {_mintERC2309}.
1807     // This limit is to prevent overflows on the address data entries.
1808     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1809     // is required to cause an overflow, which is unrealistic.
1810     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1811 
1812     // The `Transfer` event signature is given by:
1813     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1814     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1815         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1816 
1817     // =============================================================
1818     //                            STORAGE
1819     // =============================================================
1820 
1821     // The next token ID to be minted.
1822     uint256 private _currentIndex;
1823 
1824     // The number of tokens burned.
1825     uint256 private _burnCounter;
1826 
1827     // Token name
1828     string private _name;
1829 
1830     // Token symbol
1831     string private _symbol;
1832 
1833     // Mapping from token ID to ownership details
1834     // An empty struct value does not necessarily mean the token is unowned.
1835     // See {_packedOwnershipOf} implementation for details.
1836     //
1837     // Bits Layout:
1838     // - [0..159]   `addr`
1839     // - [160..223] `startTimestamp`
1840     // - [224]      `burned`
1841     // - [225]      `nextInitialized`
1842     // - [232..255] `extraData`
1843     mapping(uint256 => uint256) private _packedOwnerships;
1844 
1845     // Mapping owner address to address data.
1846     //
1847     // Bits Layout:
1848     // - [0..63]    `balance`
1849     // - [64..127]  `numberMinted`
1850     // - [128..191] `numberBurned`
1851     // - [192..255] `aux`
1852     mapping(address => uint256) private _packedAddressData;
1853 
1854     // Mapping from token ID to approved address.
1855     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1856 
1857     // Mapping from owner to operator approvals
1858     mapping(address => mapping(address => bool)) private _operatorApprovals;
1859 
1860     // =============================================================
1861     //                          CONSTRUCTOR
1862     // =============================================================
1863 
1864     constructor(string memory name_, string memory symbol_) {
1865         _name = name_;
1866         _symbol = symbol_;
1867         _currentIndex = _startTokenId();
1868     }
1869 
1870     // =============================================================
1871     //                   TOKEN COUNTING OPERATIONS
1872     // =============================================================
1873 
1874     /**
1875      * @dev Returns the starting token ID.
1876      * To change the starting token ID, please override this function.
1877      */
1878     function _startTokenId() internal view virtual returns (uint256) {
1879         return 0;
1880     }
1881 
1882     /**
1883      * @dev Returns the next token ID to be minted.
1884      */
1885     function _nextTokenId() internal view virtual returns (uint256) {
1886         return _currentIndex;
1887     }
1888 
1889     /**
1890      * @dev Returns the total number of tokens in existence.
1891      * Burned tokens will reduce the count.
1892      * To get the total number of tokens minted, please see {_totalMinted}.
1893      */
1894     function totalSupply() public view virtual override returns (uint256) {
1895         // Counter underflow is impossible as _burnCounter cannot be incremented
1896         // more than `_currentIndex - _startTokenId()` times.
1897         unchecked {
1898             return _currentIndex - _burnCounter - _startTokenId();
1899         }
1900     }
1901 
1902     /**
1903      * @dev Returns the total amount of tokens minted in the contract.
1904      */
1905     function _totalMinted() internal view virtual returns (uint256) {
1906         // Counter underflow is impossible as `_currentIndex` does not decrement,
1907         // and it is initialized to `_startTokenId()`.
1908         unchecked {
1909             return _currentIndex - _startTokenId();
1910         }
1911     }
1912 
1913     /**
1914      * @dev Returns the total number of tokens burned.
1915      */
1916     function _totalBurned() internal view virtual returns (uint256) {
1917         return _burnCounter;
1918     }
1919 
1920     // =============================================================
1921     //                    ADDRESS DATA OPERATIONS
1922     // =============================================================
1923 
1924     /**
1925      * @dev Returns the number of tokens in `owner`'s account.
1926      */
1927     function balanceOf(address owner) public view virtual override returns (uint256) {
1928         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1929         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1930     }
1931 
1932     /**
1933      * Returns the number of tokens minted by `owner`.
1934      */
1935     function _numberMinted(address owner) internal view returns (uint256) {
1936         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1937     }
1938 
1939     /**
1940      * Returns the number of tokens burned by or on behalf of `owner`.
1941      */
1942     function _numberBurned(address owner) internal view returns (uint256) {
1943         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1944     }
1945 
1946     /**
1947      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1948      */
1949     function _getAux(address owner) internal view returns (uint64) {
1950         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1951     }
1952 
1953     /**
1954      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1955      * If there are multiple variables, please pack them into a uint64.
1956      */
1957     function _setAux(address owner, uint64 aux) internal virtual {
1958         uint256 packed = _packedAddressData[owner];
1959         uint256 auxCasted;
1960         // Cast `aux` with assembly to avoid redundant masking.
1961         assembly {
1962             auxCasted := aux
1963         }
1964         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1965         _packedAddressData[owner] = packed;
1966     }
1967 
1968     // =============================================================
1969     //                            IERC165
1970     // =============================================================
1971 
1972     /**
1973      * @dev Returns true if this contract implements the interface defined by
1974      * `interfaceId`. See the corresponding
1975      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1976      * to learn more about how these ids are created.
1977      *
1978      * This function call must use less than 30000 gas.
1979      */
1980     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1981         // The interface IDs are constants representing the first 4 bytes
1982         // of the XOR of all function selectors in the interface.
1983         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1984         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1985         return
1986             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1987             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1988             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1989     }
1990 
1991     // =============================================================
1992     //                        IERC721Metadata
1993     // =============================================================
1994 
1995     /**
1996      * @dev Returns the token collection name.
1997      */
1998     function name() public view virtual override returns (string memory) {
1999         return _name;
2000     }
2001 
2002     /**
2003      * @dev Returns the token collection symbol.
2004      */
2005     function symbol() public view virtual override returns (string memory) {
2006         return _symbol;
2007     }
2008 
2009     /**
2010      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2011      */
2012     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2013         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2014 
2015         string memory baseURI = _baseURI();
2016         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2017     }
2018 
2019     /**
2020      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2021      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2022      * by default, it can be overridden in child contracts.
2023      */
2024     function _baseURI() internal view virtual returns (string memory) {
2025         return '';
2026     }
2027 
2028     // =============================================================
2029     //                     OWNERSHIPS OPERATIONS
2030     // =============================================================
2031 
2032     /**
2033      * @dev Returns the owner of the `tokenId` token.
2034      *
2035      * Requirements:
2036      *
2037      * - `tokenId` must exist.
2038      */
2039     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2040         return address(uint160(_packedOwnershipOf(tokenId)));
2041     }
2042 
2043     /**
2044      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2045      * It gradually moves to O(1) as tokens get transferred around over time.
2046      */
2047     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2048         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2049     }
2050 
2051     /**
2052      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2053      */
2054     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2055         return _unpackedOwnership(_packedOwnerships[index]);
2056     }
2057 
2058     /**
2059      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2060      */
2061     function _initializeOwnershipAt(uint256 index) internal virtual {
2062         if (_packedOwnerships[index] == 0) {
2063             _packedOwnerships[index] = _packedOwnershipOf(index);
2064         }
2065     }
2066 
2067     /**
2068      * Returns the packed ownership data of `tokenId`.
2069      */
2070     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2071         uint256 curr = tokenId;
2072 
2073         unchecked {
2074             if (_startTokenId() <= curr)
2075                 if (curr < _currentIndex) {
2076                     uint256 packed = _packedOwnerships[curr];
2077                     // If not burned.
2078                     if (packed & _BITMASK_BURNED == 0) {
2079                         // Invariant:
2080                         // There will always be an initialized ownership slot
2081                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2082                         // before an unintialized ownership slot
2083                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2084                         // Hence, `curr` will not underflow.
2085                         //
2086                         // We can directly compare the packed value.
2087                         // If the address is zero, packed will be zero.
2088                         while (packed == 0) {
2089                             packed = _packedOwnerships[--curr];
2090                         }
2091                         return packed;
2092                     }
2093                 }
2094         }
2095         revert OwnerQueryForNonexistentToken();
2096     }
2097 
2098     /**
2099      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2100      */
2101     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2102         ownership.addr = address(uint160(packed));
2103         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2104         ownership.burned = packed & _BITMASK_BURNED != 0;
2105         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2106     }
2107 
2108     /**
2109      * @dev Packs ownership data into a single uint256.
2110      */
2111     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2112         assembly {
2113             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2114             owner := and(owner, _BITMASK_ADDRESS)
2115             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2116             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2117         }
2118     }
2119 
2120     /**
2121      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2122      */
2123     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2124         // For branchless setting of the `nextInitialized` flag.
2125         assembly {
2126             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2127             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2128         }
2129     }
2130 
2131     // =============================================================
2132     //                      APPROVAL OPERATIONS
2133     // =============================================================
2134 
2135     /**
2136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2137      * The approval is cleared when the token is transferred.
2138      *
2139      * Only a single account can be approved at a time, so approving the
2140      * zero address clears previous approvals.
2141      *
2142      * Requirements:
2143      *
2144      * - The caller must own the token or be an approved operator.
2145      * - `tokenId` must exist.
2146      *
2147      * Emits an {Approval} event.
2148      */
2149     function approve(address to, uint256 tokenId) public payable virtual override {
2150         address owner = ownerOf(tokenId);
2151 
2152         if (_msgSenderERC721A() != owner)
2153             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2154                 revert ApprovalCallerNotOwnerNorApproved();
2155             }
2156 
2157         _tokenApprovals[tokenId].value = to;
2158         emit Approval(owner, to, tokenId);
2159     }
2160 
2161     /**
2162      * @dev Returns the account approved for `tokenId` token.
2163      *
2164      * Requirements:
2165      *
2166      * - `tokenId` must exist.
2167      */
2168     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2169         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2170 
2171         return _tokenApprovals[tokenId].value;
2172     }
2173 
2174     /**
2175      * @dev Approve or remove `operator` as an operator for the caller.
2176      * Operators can call {transferFrom} or {safeTransferFrom}
2177      * for any token owned by the caller.
2178      *
2179      * Requirements:
2180      *
2181      * - The `operator` cannot be the caller.
2182      *
2183      * Emits an {ApprovalForAll} event.
2184      */
2185     function setApprovalForAll(address operator, bool approved) public virtual override {
2186         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2187         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2188     }
2189 
2190     /**
2191      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2192      *
2193      * See {setApprovalForAll}.
2194      */
2195     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2196         return _operatorApprovals[owner][operator];
2197     }
2198 
2199     /**
2200      * @dev Returns whether `tokenId` exists.
2201      *
2202      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2203      *
2204      * Tokens start existing when they are minted. See {_mint}.
2205      */
2206     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2207         return
2208             _startTokenId() <= tokenId &&
2209             tokenId < _currentIndex && // If within bounds,
2210             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2211     }
2212 
2213     /**
2214      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2215      */
2216     function _isSenderApprovedOrOwner(
2217         address approvedAddress,
2218         address owner,
2219         address msgSender
2220     ) private pure returns (bool result) {
2221         assembly {
2222             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2223             owner := and(owner, _BITMASK_ADDRESS)
2224             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2225             msgSender := and(msgSender, _BITMASK_ADDRESS)
2226             // `msgSender == owner || msgSender == approvedAddress`.
2227             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2228         }
2229     }
2230 
2231     /**
2232      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2233      */
2234     function _getApprovedSlotAndAddress(uint256 tokenId)
2235         private
2236         view
2237         returns (uint256 approvedAddressSlot, address approvedAddress)
2238     {
2239         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2240         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2241         assembly {
2242             approvedAddressSlot := tokenApproval.slot
2243             approvedAddress := sload(approvedAddressSlot)
2244         }
2245     }
2246 
2247     // =============================================================
2248     //                      TRANSFER OPERATIONS
2249     // =============================================================
2250 
2251     /**
2252      * @dev Transfers `tokenId` from `from` to `to`.
2253      *
2254      * Requirements:
2255      *
2256      * - `from` cannot be the zero address.
2257      * - `to` cannot be the zero address.
2258      * - `tokenId` token must be owned by `from`.
2259      * - If the caller is not `from`, it must be approved to move this token
2260      * by either {approve} or {setApprovalForAll}.
2261      *
2262      * Emits a {Transfer} event.
2263      */
2264     function transferFrom(
2265         address from,
2266         address to,
2267         uint256 tokenId
2268     ) public payable virtual override {
2269         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2270 
2271         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2272 
2273         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2274 
2275         // The nested ifs save around 20+ gas over a compound boolean condition.
2276         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2277             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2278 
2279         if (to == address(0)) revert TransferToZeroAddress();
2280 
2281         _beforeTokenTransfers(from, to, tokenId, 1);
2282 
2283         // Clear approvals from the previous owner.
2284         assembly {
2285             if approvedAddress {
2286                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2287                 sstore(approvedAddressSlot, 0)
2288             }
2289         }
2290 
2291         // Underflow of the sender's balance is impossible because we check for
2292         // ownership above and the recipient's balance can't realistically overflow.
2293         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2294         unchecked {
2295             // We can directly increment and decrement the balances.
2296             --_packedAddressData[from]; // Updates: `balance -= 1`.
2297             ++_packedAddressData[to]; // Updates: `balance += 1`.
2298 
2299             // Updates:
2300             // - `address` to the next owner.
2301             // - `startTimestamp` to the timestamp of transfering.
2302             // - `burned` to `false`.
2303             // - `nextInitialized` to `true`.
2304             _packedOwnerships[tokenId] = _packOwnershipData(
2305                 to,
2306                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2307             );
2308 
2309             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2310             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2311                 uint256 nextTokenId = tokenId + 1;
2312                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2313                 if (_packedOwnerships[nextTokenId] == 0) {
2314                     // If the next slot is within bounds.
2315                     if (nextTokenId != _currentIndex) {
2316                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2317                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2318                     }
2319                 }
2320             }
2321         }
2322 
2323         emit Transfer(from, to, tokenId);
2324         _afterTokenTransfers(from, to, tokenId, 1);
2325     }
2326 
2327     /**
2328      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2329      */
2330     function safeTransferFrom(
2331         address from,
2332         address to,
2333         uint256 tokenId
2334     ) public payable virtual override {
2335         safeTransferFrom(from, to, tokenId, '');
2336     }
2337 
2338     /**
2339      * @dev Safely transfers `tokenId` token from `from` to `to`.
2340      *
2341      * Requirements:
2342      *
2343      * - `from` cannot be the zero address.
2344      * - `to` cannot be the zero address.
2345      * - `tokenId` token must exist and be owned by `from`.
2346      * - If the caller is not `from`, it must be approved to move this token
2347      * by either {approve} or {setApprovalForAll}.
2348      * - If `to` refers to a smart contract, it must implement
2349      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2350      *
2351      * Emits a {Transfer} event.
2352      */
2353     function safeTransferFrom(
2354         address from,
2355         address to,
2356         uint256 tokenId,
2357         bytes memory _data
2358     ) public payable virtual override {
2359         transferFrom(from, to, tokenId);
2360         if (to.code.length != 0)
2361             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2362                 revert TransferToNonERC721ReceiverImplementer();
2363             }
2364     }
2365 
2366     /**
2367      * @dev Hook that is called before a set of serially-ordered token IDs
2368      * are about to be transferred. This includes minting.
2369      * And also called before burning one token.
2370      *
2371      * `startTokenId` - the first token ID to be transferred.
2372      * `quantity` - the amount to be transferred.
2373      *
2374      * Calling conditions:
2375      *
2376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2377      * transferred to `to`.
2378      * - When `from` is zero, `tokenId` will be minted for `to`.
2379      * - When `to` is zero, `tokenId` will be burned by `from`.
2380      * - `from` and `to` are never both zero.
2381      */
2382     function _beforeTokenTransfers(
2383         address from,
2384         address to,
2385         uint256 startTokenId,
2386         uint256 quantity
2387     ) internal virtual {}
2388 
2389     /**
2390      * @dev Hook that is called after a set of serially-ordered token IDs
2391      * have been transferred. This includes minting.
2392      * And also called after one token has been burned.
2393      *
2394      * `startTokenId` - the first token ID to be transferred.
2395      * `quantity` - the amount to be transferred.
2396      *
2397      * Calling conditions:
2398      *
2399      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2400      * transferred to `to`.
2401      * - When `from` is zero, `tokenId` has been minted for `to`.
2402      * - When `to` is zero, `tokenId` has been burned by `from`.
2403      * - `from` and `to` are never both zero.
2404      */
2405     function _afterTokenTransfers(
2406         address from,
2407         address to,
2408         uint256 startTokenId,
2409         uint256 quantity
2410     ) internal virtual {}
2411 
2412     /**
2413      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2414      *
2415      * `from` - Previous owner of the given token ID.
2416      * `to` - Target address that will receive the token.
2417      * `tokenId` - Token ID to be transferred.
2418      * `_data` - Optional data to send along with the call.
2419      *
2420      * Returns whether the call correctly returned the expected magic value.
2421      */
2422     function _checkContractOnERC721Received(
2423         address from,
2424         address to,
2425         uint256 tokenId,
2426         bytes memory _data
2427     ) private returns (bool) {
2428         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2429             bytes4 retval
2430         ) {
2431             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2432         } catch (bytes memory reason) {
2433             if (reason.length == 0) {
2434                 revert TransferToNonERC721ReceiverImplementer();
2435             } else {
2436                 assembly {
2437                     revert(add(32, reason), mload(reason))
2438                 }
2439             }
2440         }
2441     }
2442 
2443     // =============================================================
2444     //                        MINT OPERATIONS
2445     // =============================================================
2446 
2447     /**
2448      * @dev Mints `quantity` tokens and transfers them to `to`.
2449      *
2450      * Requirements:
2451      *
2452      * - `to` cannot be the zero address.
2453      * - `quantity` must be greater than 0.
2454      *
2455      * Emits a {Transfer} event for each mint.
2456      */
2457     function _mint(address to, uint256 quantity) internal virtual {
2458         uint256 startTokenId = _currentIndex;
2459         if (quantity == 0) revert MintZeroQuantity();
2460 
2461         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2462 
2463         // Overflows are incredibly unrealistic.
2464         // `balance` and `numberMinted` have a maximum limit of 2**64.
2465         // `tokenId` has a maximum limit of 2**256.
2466         unchecked {
2467             // Updates:
2468             // - `balance += quantity`.
2469             // - `numberMinted += quantity`.
2470             //
2471             // We can directly add to the `balance` and `numberMinted`.
2472             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2473 
2474             // Updates:
2475             // - `address` to the owner.
2476             // - `startTimestamp` to the timestamp of minting.
2477             // - `burned` to `false`.
2478             // - `nextInitialized` to `quantity == 1`.
2479             _packedOwnerships[startTokenId] = _packOwnershipData(
2480                 to,
2481                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2482             );
2483 
2484             uint256 toMasked;
2485             uint256 end = startTokenId + quantity;
2486 
2487             // Use assembly to loop and emit the `Transfer` event for gas savings.
2488             // The duplicated `log4` removes an extra check and reduces stack juggling.
2489             // The assembly, together with the surrounding Solidity code, have been
2490             // delicately arranged to nudge the compiler into producing optimized opcodes.
2491             assembly {
2492                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2493                 toMasked := and(to, _BITMASK_ADDRESS)
2494                 // Emit the `Transfer` event.
2495                 log4(
2496                     0, // Start of data (0, since no data).
2497                     0, // End of data (0, since no data).
2498                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2499                     0, // `address(0)`.
2500                     toMasked, // `to`.
2501                     startTokenId // `tokenId`.
2502                 )
2503 
2504                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2505                 // that overflows uint256 will make the loop run out of gas.
2506                 // The compiler will optimize the `iszero` away for performance.
2507                 for {
2508                     let tokenId := add(startTokenId, 1)
2509                 } iszero(eq(tokenId, end)) {
2510                     tokenId := add(tokenId, 1)
2511                 } {
2512                     // Emit the `Transfer` event. Similar to above.
2513                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2514                 }
2515             }
2516             if (toMasked == 0) revert MintToZeroAddress();
2517 
2518             _currentIndex = end;
2519         }
2520         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2521     }
2522 
2523     /**
2524      * @dev Mints `quantity` tokens and transfers them to `to`.
2525      *
2526      * This function is intended for efficient minting only during contract creation.
2527      *
2528      * It emits only one {ConsecutiveTransfer} as defined in
2529      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2530      * instead of a sequence of {Transfer} event(s).
2531      *
2532      * Calling this function outside of contract creation WILL make your contract
2533      * non-compliant with the ERC721 standard.
2534      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2535      * {ConsecutiveTransfer} event is only permissible during contract creation.
2536      *
2537      * Requirements:
2538      *
2539      * - `to` cannot be the zero address.
2540      * - `quantity` must be greater than 0.
2541      *
2542      * Emits a {ConsecutiveTransfer} event.
2543      */
2544     function _mintERC2309(address to, uint256 quantity) internal virtual {
2545         uint256 startTokenId = _currentIndex;
2546         if (to == address(0)) revert MintToZeroAddress();
2547         if (quantity == 0) revert MintZeroQuantity();
2548         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2549 
2550         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2551 
2552         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2553         unchecked {
2554             // Updates:
2555             // - `balance += quantity`.
2556             // - `numberMinted += quantity`.
2557             //
2558             // We can directly add to the `balance` and `numberMinted`.
2559             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2560 
2561             // Updates:
2562             // - `address` to the owner.
2563             // - `startTimestamp` to the timestamp of minting.
2564             // - `burned` to `false`.
2565             // - `nextInitialized` to `quantity == 1`.
2566             _packedOwnerships[startTokenId] = _packOwnershipData(
2567                 to,
2568                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2569             );
2570 
2571             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2572 
2573             _currentIndex = startTokenId + quantity;
2574         }
2575         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2576     }
2577 
2578     /**
2579      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2580      *
2581      * Requirements:
2582      *
2583      * - If `to` refers to a smart contract, it must implement
2584      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2585      * - `quantity` must be greater than 0.
2586      *
2587      * See {_mint}.
2588      *
2589      * Emits a {Transfer} event for each mint.
2590      */
2591     function _safeMint(
2592         address to,
2593         uint256 quantity,
2594         bytes memory _data
2595     ) internal virtual {
2596         _mint(to, quantity);
2597 
2598         unchecked {
2599             if (to.code.length != 0) {
2600                 uint256 end = _currentIndex;
2601                 uint256 index = end - quantity;
2602                 do {
2603                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2604                         revert TransferToNonERC721ReceiverImplementer();
2605                     }
2606                 } while (index < end);
2607                 // Reentrancy protection.
2608                 if (_currentIndex != end) revert();
2609             }
2610         }
2611     }
2612 
2613     /**
2614      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2615      */
2616     function _safeMint(address to, uint256 quantity) internal virtual {
2617         _safeMint(to, quantity, '');
2618     }
2619 
2620     // =============================================================
2621     //                        BURN OPERATIONS
2622     // =============================================================
2623 
2624     /**
2625      * @dev Equivalent to `_burn(tokenId, false)`.
2626      */
2627     function _burn(uint256 tokenId) internal virtual {
2628         _burn(tokenId, false);
2629     }
2630 
2631     /**
2632      * @dev Destroys `tokenId`.
2633      * The approval is cleared when the token is burned.
2634      *
2635      * Requirements:
2636      *
2637      * - `tokenId` must exist.
2638      *
2639      * Emits a {Transfer} event.
2640      */
2641     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2642         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2643 
2644         address from = address(uint160(prevOwnershipPacked));
2645 
2646         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2647 
2648         if (approvalCheck) {
2649             // The nested ifs save around 20+ gas over a compound boolean condition.
2650             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2651                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2652         }
2653 
2654         _beforeTokenTransfers(from, address(0), tokenId, 1);
2655 
2656         // Clear approvals from the previous owner.
2657         assembly {
2658             if approvedAddress {
2659                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2660                 sstore(approvedAddressSlot, 0)
2661             }
2662         }
2663 
2664         // Underflow of the sender's balance is impossible because we check for
2665         // ownership above and the recipient's balance can't realistically overflow.
2666         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2667         unchecked {
2668             // Updates:
2669             // - `balance -= 1`.
2670             // - `numberBurned += 1`.
2671             //
2672             // We can directly decrement the balance, and increment the number burned.
2673             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2674             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2675 
2676             // Updates:
2677             // - `address` to the last owner.
2678             // - `startTimestamp` to the timestamp of burning.
2679             // - `burned` to `true`.
2680             // - `nextInitialized` to `true`.
2681             _packedOwnerships[tokenId] = _packOwnershipData(
2682                 from,
2683                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2684             );
2685 
2686             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2687             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2688                 uint256 nextTokenId = tokenId + 1;
2689                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2690                 if (_packedOwnerships[nextTokenId] == 0) {
2691                     // If the next slot is within bounds.
2692                     if (nextTokenId != _currentIndex) {
2693                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2694                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2695                     }
2696                 }
2697             }
2698         }
2699 
2700         emit Transfer(from, address(0), tokenId);
2701         _afterTokenTransfers(from, address(0), tokenId, 1);
2702 
2703         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2704         unchecked {
2705             _burnCounter++;
2706         }
2707     }
2708 
2709     // =============================================================
2710     //                     EXTRA DATA OPERATIONS
2711     // =============================================================
2712 
2713     /**
2714      * @dev Directly sets the extra data for the ownership data `index`.
2715      */
2716     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2717         uint256 packed = _packedOwnerships[index];
2718         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2719         uint256 extraDataCasted;
2720         // Cast `extraData` with assembly to avoid redundant masking.
2721         assembly {
2722             extraDataCasted := extraData
2723         }
2724         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2725         _packedOwnerships[index] = packed;
2726     }
2727 
2728     /**
2729      * @dev Called during each token transfer to set the 24bit `extraData` field.
2730      * Intended to be overridden by the cosumer contract.
2731      *
2732      * `previousExtraData` - the value of `extraData` before transfer.
2733      *
2734      * Calling conditions:
2735      *
2736      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2737      * transferred to `to`.
2738      * - When `from` is zero, `tokenId` will be minted for `to`.
2739      * - When `to` is zero, `tokenId` will be burned by `from`.
2740      * - `from` and `to` are never both zero.
2741      */
2742     function _extraData(
2743         address from,
2744         address to,
2745         uint24 previousExtraData
2746     ) internal view virtual returns (uint24) {}
2747 
2748     /**
2749      * @dev Returns the next extra data for the packed ownership data.
2750      * The returned result is shifted into position.
2751      */
2752     function _nextExtraData(
2753         address from,
2754         address to,
2755         uint256 prevOwnershipPacked
2756     ) private view returns (uint256) {
2757         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2758         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2759     }
2760 
2761     // =============================================================
2762     //                       OTHER OPERATIONS
2763     // =============================================================
2764 
2765     /**
2766      * @dev Returns the message sender (defaults to `msg.sender`).
2767      *
2768      * If you are writing GSN compatible contracts, you need to override this function.
2769      */
2770     function _msgSenderERC721A() internal view virtual returns (address) {
2771         return msg.sender;
2772     }
2773 
2774     /**
2775      * @dev Converts a uint256 to its ASCII string decimal representation.
2776      */
2777     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2778         assembly {
2779             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2780             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2781             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2782             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2783             let m := add(mload(0x40), 0xa0)
2784             // Update the free memory pointer to allocate.
2785             mstore(0x40, m)
2786             // Assign the `str` to the end.
2787             str := sub(m, 0x20)
2788             // Zeroize the slot after the string.
2789             mstore(str, 0)
2790 
2791             // Cache the end of the memory to calculate the length later.
2792             let end := str
2793 
2794             // We write the string from rightmost digit to leftmost digit.
2795             // The following is essentially a do-while loop that also handles the zero case.
2796             // prettier-ignore
2797             for { let temp := value } 1 {} {
2798                 str := sub(str, 1)
2799                 // Write the character to the pointer.
2800                 // The ASCII index of the '0' character is 48.
2801                 mstore8(str, add(48, mod(temp, 10)))
2802                 // Keep dividing `temp` until zero.
2803                 temp := div(temp, 10)
2804                 // prettier-ignore
2805                 if iszero(temp) { break }
2806             }
2807 
2808             let length := sub(end, str)
2809             // Move the pointer 32 bytes leftwards to make room for the length.
2810             str := sub(str, 0x20)
2811             // Store the length.
2812             mstore(str, length)
2813         }
2814     }
2815 }
2816 
2817 // File: contracts/Pooplicators.sol
2818 
2819 
2820 pragma solidity ^0.8.4;
2821 
2822 
2823 
2824 
2825 
2826 
2827 
2828 
2829 
2830 
2831 
2832 
2833 contract Pooplicators is ERC721A, IERC2981, Ownable, DefaultOperatorFilterer{
2834     using Strings for uint256;
2835 
2836     error TokenDoesNotExist(uint256 id);
2837 
2838     uint256 public MAX_SUPPLY = 6969;
2839     uint256 public MAX_MINT = 10;
2840     uint256 public PUBLIC_SALE_PRICE = .004 ether;
2841 
2842     string private baseTokenUri;
2843     string public  placeholderTokenUri;
2844 
2845     mapping(address => bool) public hasClaimed;
2846 
2847     bool public isRevealed;
2848     bool public publicSale;
2849     bool public claimSale;
2850     bool public pause;
2851     IERC721 public _otherCollection = IERC721(0x0394B9121bD481260258E6Eb93a0bA47580B86ef);
2852 
2853     mapping(address => uint256) public totalPublicMint;
2854 
2855     constructor() ERC721A("Pooplicators", "POOPLI"){}
2856 
2857     modifier callerIsUser() {
2858         require(tx.origin == msg.sender, "POOPLI :: Cannot be called by a contract");
2859         _;
2860     }
2861 
2862     function claim() external callerIsUser{
2863         require(!hasClaimed[msg.sender], "POOPLI :: You Already Claimed");
2864         require(claimSale, "POOPLI :: Not Yet ClaimActive.");
2865         uint256 numTokensToMint = _otherCollection.balanceOf(msg.sender);
2866         require(numTokensToMint > 0, "You don't hold any NFTs from the other collection.");
2867         require((_totalMinted() + numTokensToMint) <= MAX_SUPPLY, "POOPLI :: Beyond Max Supply");
2868 
2869         totalPublicMint[msg.sender] += numTokensToMint;
2870         hasClaimed[msg.sender] = true;
2871         _mint(msg.sender, numTokensToMint);
2872     }
2873 
2874     function mint(uint256 _quantity) external payable callerIsUser{
2875         require(publicSale, "POOPLI :: Not Yet Active.");
2876         require((_totalMinted() + _quantity) <= MAX_SUPPLY, "POOPLI :: Beyond Max Supply");
2877         require((totalPublicMint[msg.sender] + _quantity) <= MAX_MINT, "POOPLI ::  That is more than Your Max");
2878         require(msg.value >= (PUBLIC_SALE_PRICE * _quantity), "POOPLI :: Below Ether Value");
2879 
2880         totalPublicMint[msg.sender] += _quantity;
2881         _mint(msg.sender, _quantity);
2882     }
2883 
2884     function _baseURI() internal view virtual override returns (string memory) {
2885         return baseTokenUri;
2886     }
2887 
2888     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2889         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2890 
2891         uint256 trueId = tokenId + 1;
2892 
2893         if(!isRevealed){
2894             return placeholderTokenUri;
2895         }
2896         
2897         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
2898     }
2899 
2900     function setTokenUri(string calldata _baseTokenUri) external onlyOwner{
2901         baseTokenUri = _baseTokenUri;
2902     }
2903 
2904     function setPlaceHolderUri(string calldata _placeholderTokenUri) external onlyOwner{
2905         placeholderTokenUri = _placeholderTokenUri;
2906     }
2907     
2908     function setMintPrice(uint256 newMintPrice)external onlyOwner{
2909         PUBLIC_SALE_PRICE = newMintPrice;
2910     }
2911 
2912     function setFreeNftAddress(address newA)external onlyOwner{
2913         _otherCollection = IERC721(newA);
2914     }
2915 
2916     function togglePause() external onlyOwner{
2917         pause = !pause;
2918     }
2919 
2920     function togglePublicSale() external onlyOwner{
2921         publicSale = !publicSale;
2922     }
2923 
2924     function toggleClaimSale() external onlyOwner{
2925         claimSale = !claimSale;
2926     }
2927 
2928     function toggleReveal() external onlyOwner{
2929         isRevealed = !isRevealed;
2930     }
2931 
2932     function withdraw() external onlyOwner{
2933         payable(msg.sender).transfer(address(this).balance);
2934     }
2935 
2936         /* ERC 2891 */
2937     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2938         external
2939         view
2940         override
2941         returns (address receiver, uint256 royaltyAmount)
2942     {
2943         if (!_exists(tokenId)) {
2944             revert TokenDoesNotExist(tokenId);
2945         }
2946 
2947         return (address(0x1609d619154682733FEa13BADE3283b811C7b4E3), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
2948     }
2949 
2950     function supportsInterface(bytes4 interfaceId) public view override(ERC721A, IERC165) returns (bool) {
2951         return _supportsInterface(interfaceId);
2952     }
2953 
2954     function _supportsInterface(bytes4 interfaceId) private view returns (bool) {
2955         return
2956             interfaceId == type(IERC721).interfaceId ||
2957             interfaceId == type(IERC2981).interfaceId ||
2958             interfaceId == type(Ownable).interfaceId ||
2959             super.supportsInterface(interfaceId);
2960     }
2961 
2962     //opensea registry
2963         function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2964         super.setApprovalForAll(operator, approved);
2965     }
2966 
2967     function approve(address operator, uint256 tokenId) public override payable onlyAllowedOperatorApproval(operator) {
2968         super.approve(operator, tokenId);
2969     }
2970 
2971     function transferFrom(address from, address to, uint256 tokenId) public override payable onlyAllowedOperator(from) {
2972         super.transferFrom(from, to, tokenId);
2973     }
2974 
2975     function safeTransferFrom(address from, address to, uint256 tokenId) public override payable onlyAllowedOperator(from) {
2976         super.safeTransferFrom(from, to, tokenId);
2977     }
2978 
2979     function safeTransferFrom (address from, address to, uint256 tokenId, bytes memory data)
2980         public payable
2981         override
2982         onlyAllowedOperator(from)
2983     {
2984         super.safeTransferFrom(from, to, tokenId, data);
2985     }
2986 }