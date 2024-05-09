1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 // File: operator-filter-registry/src/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
45  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
46  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
47  */
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
59             if (subscribe) {
60                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     OPERATOR_FILTER_REGISTRY.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Allow spending tokens from addresses with balance
73         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74         // from an EOA.
75         if (from != msg.sender) {
76             _checkFilterOperator(msg.sender);
77         }
78         _;
79     }
80 
81     modifier onlyAllowedOperatorApproval(address operator) virtual {
82         _checkFilterOperator(operator);
83         _;
84     }
85 
86     function _checkFilterOperator(address operator) internal view virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93     }
94 }
95 
96 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
97 
98 
99 pragma solidity ^0.8.13;
100 
101 
102 /**
103  * @title  DefaultOperatorFilterer
104  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
105  */
106 abstract contract DefaultOperatorFilterer is OperatorFilterer {
107     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
108 
109     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
110 }
111 
112 // File: contracts/chicks.sol
113 
114 //7599910339349013
115 
116 
117 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
118 
119 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Contract module that helps prevent reentrant calls to a function.
125  *
126  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
127  * available, which can be applied to functions to make sure there are no nested
128  * (reentrant) calls to them.
129  *
130  * Note that because there is a single `nonReentrant` guard, functions marked as
131  * `nonReentrant` may not call one another. This can be worked around by making
132  * those functions `private`, and then adding `external` `nonReentrant` entry
133  * points to them.
134  *
135  * TIP: If you would like to learn more about reentrancy and alternative ways
136  * to protect against it, check out our blog post
137  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
138  */
139 abstract contract ReentrancyGuard {
140     // Booleans are more expensive than uint256 or any type that takes up a full
141     // word because each write operation emits an extra SLOAD to first read the
142     // slot's contents, replace the bits taken up by the boolean, and then write
143     // back. This is the compiler's defense against contract upgrades and
144     // pointer aliasing, and it cannot be disabled.
145 
146     // The values being non-zero value makes deployment a bit more expensive,
147     // but in exchange the refund on every call to nonReentrant will be lower in
148     // amount. Since refunds are capped to a percentage of the total
149     // transaction's gas, it is best to keep them low in cases like this one, to
150     // increase the likelihood of the full refund coming into effect.
151     uint256 private constant _NOT_ENTERED = 1;
152     uint256 private constant _ENTERED = 2;
153 
154     uint256 private _status;
155 
156     constructor() {
157         _status = _NOT_ENTERED;
158     }
159 
160     /**
161      * @dev Prevents a contract from calling itself, directly or indirectly.
162      * Calling a `nonReentrant` function from another `nonReentrant`
163      * function is not supported. It is possible to prevent this from happening
164      * by making the `nonReentrant` function external, and making it call a
165      * `private` function that does the actual work.
166      */
167     modifier nonReentrant() {
168         // On the first call to nonReentrant, _notEntered will be true
169         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
170 
171         // Any calls to nonReentrant after this point will fail
172         _status = _ENTERED;
173 
174         _;
175 
176         // By storing the original value once again, a refund is triggered (see
177         // https://eips.ethereum.org/EIPS/eip-2200)
178         _status = _NOT_ENTERED;
179     }
180 }
181 
182 // File: contracts/witch.sol
183 
184 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
185 
186 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev These functions deal with verification of Merkle Tree proofs.
192  *
193  * The proofs can be generated using the JavaScript library
194  * https://github.com/miguelmota/merkletreejs[merkletreejs].
195  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
196  *
197  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
198  *
199  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
200  * hashing, or use a hash function other than keccak256 for hashing leaves.
201  * This is because the concatenation of a sorted pair of internal nodes in
202  * the merkle tree could be reinterpreted as a leaf value.
203  */
204 library MerkleProof {
205     /**
206      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
207      * defined by `root`. For this, a `proof` must be provided, containing
208      * sibling hashes on the branch from the leaf to the root of the tree. Each
209      * pair of leaves and each pair of pre-images are assumed to be sorted.
210      */
211     function verify(
212         bytes32[] memory proof,
213         bytes32 root,
214         bytes32 leaf
215     ) internal pure returns (bool) {
216         return processProof(proof, leaf) == root;
217     }
218 
219     /**
220      * @dev Calldata version of {verify}
221      *
222      * _Available since v4.7._
223      */
224     function verifyCalldata(
225         bytes32[] calldata proof,
226         bytes32 root,
227         bytes32 leaf
228     ) internal pure returns (bool) {
229         return processProofCalldata(proof, leaf) == root;
230     }
231 
232     /**
233      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
234      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
235      * hash matches the root of the tree. When processing the proof, the pairs
236      * of leafs & pre-images are assumed to be sorted.
237      *
238      * _Available since v4.4._
239      */
240     function processProof(bytes32[] memory proof, bytes32 leaf)
241         internal
242         pure
243         returns (bytes32)
244     {
245         bytes32 computedHash = leaf;
246         for (uint256 i = 0; i < proof.length; i++) {
247             computedHash = _hashPair(computedHash, proof[i]);
248         }
249         return computedHash;
250     }
251 
252     /**
253      * @dev Calldata version of {processProof}
254      *
255      * _Available since v4.7._
256      */
257     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
258         internal
259         pure
260         returns (bytes32)
261     {
262         bytes32 computedHash = leaf;
263         for (uint256 i = 0; i < proof.length; i++) {
264             computedHash = _hashPair(computedHash, proof[i]);
265         }
266         return computedHash;
267     }
268 
269     /**
270      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
271      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
272      *
273      * _Available since v4.7._
274      */
275     function multiProofVerify(
276         bytes32[] memory proof,
277         bool[] memory proofFlags,
278         bytes32 root,
279         bytes32[] memory leaves
280     ) internal pure returns (bool) {
281         return processMultiProof(proof, proofFlags, leaves) == root;
282     }
283 
284     /**
285      * @dev Calldata version of {multiProofVerify}
286      *
287      * _Available since v4.7._
288      */
289     function multiProofVerifyCalldata(
290         bytes32[] calldata proof,
291         bool[] calldata proofFlags,
292         bytes32 root,
293         bytes32[] memory leaves
294     ) internal pure returns (bool) {
295         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
296     }
297 
298     /**
299      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
300      * consuming from one or the other at each step according to the instructions given by
301      * `proofFlags`.
302      *
303      * _Available since v4.7._
304      */
305     function processMultiProof(
306         bytes32[] memory proof,
307         bool[] memory proofFlags,
308         bytes32[] memory leaves
309     ) internal pure returns (bytes32 merkleRoot) {
310         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
311         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
312         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
313         // the merkle tree.
314         uint256 leavesLen = leaves.length;
315         uint256 totalHashes = proofFlags.length;
316 
317         // Check proof validity.
318         require(
319             leavesLen + proof.length - 1 == totalHashes,
320             "MerkleProof: invalid multiproof"
321         );
322 
323         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
324         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
325         bytes32[] memory hashes = new bytes32[](totalHashes);
326         uint256 leafPos = 0;
327         uint256 hashPos = 0;
328         uint256 proofPos = 0;
329         // At each step, we compute the next hash using two values:
330         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
331         //   get the next hash.
332         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
333         //   `proof` array.
334         for (uint256 i = 0; i < totalHashes; i++) {
335             bytes32 a = leafPos < leavesLen
336                 ? leaves[leafPos++]
337                 : hashes[hashPos++];
338             bytes32 b = proofFlags[i]
339                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
340                 : proof[proofPos++];
341             hashes[i] = _hashPair(a, b);
342         }
343 
344         if (totalHashes > 0) {
345             return hashes[totalHashes - 1];
346         } else if (leavesLen > 0) {
347             return leaves[0];
348         } else {
349             return proof[0];
350         }
351     }
352 
353     /**
354      * @dev Calldata version of {processMultiProof}
355      *
356      * _Available since v4.7._
357      */
358     function processMultiProofCalldata(
359         bytes32[] calldata proof,
360         bool[] calldata proofFlags,
361         bytes32[] memory leaves
362     ) internal pure returns (bytes32 merkleRoot) {
363         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
364         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
365         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
366         // the merkle tree.
367         uint256 leavesLen = leaves.length;
368         uint256 totalHashes = proofFlags.length;
369 
370         // Check proof validity.
371         require(
372             leavesLen + proof.length - 1 == totalHashes,
373             "MerkleProof: invalid multiproof"
374         );
375 
376         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
377         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
378         bytes32[] memory hashes = new bytes32[](totalHashes);
379         uint256 leafPos = 0;
380         uint256 hashPos = 0;
381         uint256 proofPos = 0;
382         // At each step, we compute the next hash using two values:
383         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
384         //   get the next hash.
385         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
386         //   `proof` array.
387         for (uint256 i = 0; i < totalHashes; i++) {
388             bytes32 a = leafPos < leavesLen
389                 ? leaves[leafPos++]
390                 : hashes[hashPos++];
391             bytes32 b = proofFlags[i]
392                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
393                 : proof[proofPos++];
394             hashes[i] = _hashPair(a, b);
395         }
396 
397         if (totalHashes > 0) {
398             return hashes[totalHashes - 1];
399         } else if (leavesLen > 0) {
400             return leaves[0];
401         } else {
402             return proof[0];
403         }
404     }
405 
406     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
407         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
408     }
409 
410     function _efficientHash(bytes32 a, bytes32 b)
411         private
412         pure
413         returns (bytes32 value)
414     {
415         /// @solidity memory-safe-assembly
416         assembly {
417             mstore(0x00, a)
418             mstore(0x20, b)
419             value := keccak256(0x00, 0x40)
420         }
421     }
422 }
423 
424 // File: contracts/witch.sol
425 
426 pragma solidity ^0.8.4;
427 
428 /**
429  * @dev Interface of an ERC721A compliant contract.
430  */
431 interface IERC721A {
432     /**
433      * The caller must own the token or be an approved operator.
434      */
435     error ApprovalCallerNotOwnerNorApproved();
436 
437     /**
438      * The token does not exist.
439      */
440     error ApprovalQueryForNonexistentToken();
441 
442     /**
443      * The caller cannot approve to their own address.
444      */
445     error ApproveToCaller();
446 
447     /**
448      * The caller cannot approve to the current owner.
449      */
450     error ApprovalToCurrentOwner();
451 
452     /**
453      * Cannot query the balance for the zero address.
454      */
455     error BalanceQueryForZeroAddress();
456 
457     /**
458      * Cannot mint to the zero address.
459      */
460     error MintToZeroAddress();
461 
462     /**
463      * The quantity of tokens minted must be more than zero.
464      */
465     error MintZeroQuantity();
466 
467     /**
468      * The token does not exist.
469      */
470     error OwnerQueryForNonexistentToken();
471 
472     /**
473      * The caller must own the token or be an approved operator.
474      */
475     error TransferCallerNotOwnerNorApproved();
476 
477     /**
478      * The token must be owned by `from`.
479      */
480     error TransferFromIncorrectOwner();
481 
482     /**
483      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
484      */
485     error TransferToNonERC721ReceiverImplementer();
486 
487     /**
488      * Cannot transfer to the zero address.
489      */
490     error TransferToZeroAddress();
491 
492     /**
493      * The token does not exist.
494      */
495     error URIQueryForNonexistentToken();
496 
497     struct TokenOwnership {
498         // The address of the owner.
499         address addr;
500         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
501         uint64 startTimestamp;
502         // Whether the token has been burned.
503         bool burned;
504     }
505 
506     /**
507      * @dev Returns the total amount of tokens stored by the contract.
508      *
509      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
510      */
511     function totalSupply() external view returns (uint256);
512 
513     // ==============================
514     //            IERC165
515     // ==============================
516 
517     /**
518      * @dev Returns true if this contract implements the interface defined by
519      * `interfaceId`. See the corresponding
520      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
521      * to learn more about how these ids are created.
522      *
523      * This function call must use less than 30 000 gas.
524      */
525     function supportsInterface(bytes4 interfaceId) external view returns (bool);
526 
527     // ==============================
528     //            IERC721
529     // ==============================
530 
531     /**
532      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
533      */
534     event Transfer(
535         address indexed from,
536         address indexed to,
537         uint256 indexed tokenId
538     );
539 
540     /**
541      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
542      */
543     event Approval(
544         address indexed owner,
545         address indexed approved,
546         uint256 indexed tokenId
547     );
548 
549     /**
550      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
551      */
552     event ApprovalForAll(
553         address indexed owner,
554         address indexed operator,
555         bool approved
556     );
557 
558     /**
559      * @dev Returns the number of tokens in ``owner``'s account.
560      */
561     function balanceOf(address owner) external view returns (uint256 balance);
562 
563     /**
564      * @dev Returns the owner of the `tokenId` token.
565      *
566      * Requirements:
567      *
568      * - `tokenId` must exist.
569      */
570     function ownerOf(uint256 tokenId) external view returns (address owner);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 
592     /**
593      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
594      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
595      *
596      * Requirements:
597      *
598      * - `from` cannot be the zero address.
599      * - `to` cannot be the zero address.
600      * - `tokenId` token must exist and be owned by `from`.
601      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
602      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
603      *
604      * Emits a {Transfer} event.
605      */
606     function safeTransferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) external;
611 
612     /**
613      * @dev Transfers `tokenId` token from `from` to `to`.
614      *
615      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      *
624      * Emits a {Transfer} event.
625      */
626     function transferFrom(
627         address from,
628         address to,
629         uint256 tokenId
630     ) external;
631 
632     /**
633      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
634      * The approval is cleared when the token is transferred.
635      *
636      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
637      *
638      * Requirements:
639      *
640      * - The caller must own the token or be an approved operator.
641      * - `tokenId` must exist.
642      *
643      * Emits an {Approval} event.
644      */
645     function approve(address to, uint256 tokenId) external;
646 
647     /**
648      * @dev Approve or remove `operator` as an operator for the caller.
649      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
650      *
651      * Requirements:
652      *
653      * - The `operator` cannot be the caller.
654      *
655      * Emits an {ApprovalForAll} event.
656      */
657     function setApprovalForAll(address operator, bool _approved) external;
658 
659     /**
660      * @dev Returns the account approved for `tokenId` token.
661      *
662      * Requirements:
663      *
664      * - `tokenId` must exist.
665      */
666     function getApproved(uint256 tokenId)
667         external
668         view
669         returns (address operator);
670 
671     /**
672      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
673      *
674      * See {setApprovalForAll}
675      */
676     function isApprovedForAll(address owner, address operator)
677         external
678         view
679         returns (bool);
680 
681     // ==============================
682     //        IERC721Metadata
683     // ==============================
684 
685     /**
686      * @dev Returns the token collection name.
687      */
688     function name() external view returns (string memory);
689 
690     /**
691      * @dev Returns the token collection symbol.
692      */
693     function symbol() external view returns (string memory);
694 
695     /**
696      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
697      */
698     function tokenURI(uint256 tokenId) external view returns (string memory);
699 }
700 
701 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
702 
703 // ERC721A Contracts v3.3.0
704 // Creator: Chiru Labs
705 
706 pragma solidity ^0.8.4;
707 
708 /**
709  * @dev ERC721 token receiver interface.
710  */
711 interface ERC721A__IERC721Receiver {
712     function onERC721Received(
713         address operator,
714         address from,
715         uint256 tokenId,
716         bytes calldata data
717     ) external returns (bytes4);
718 }
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata extension. Built to optimize for lower gas during batch mints.
723  *
724  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
725  *
726  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
727  *
728  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
729  */
730 contract ERC721A is IERC721A {
731     // Mask of an entry in packed address data.
732     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
733 
734     // The bit position of `numberMinted` in packed address data.
735     uint256 private constant BITPOS_NUMBER_MINTED = 64;
736 
737     // The bit position of `numberBurned` in packed address data.
738     uint256 private constant BITPOS_NUMBER_BURNED = 128;
739 
740     // The bit position of `aux` in packed address data.
741     uint256 private constant BITPOS_AUX = 192;
742 
743     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
744     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
745 
746     // The bit position of `startTimestamp` in packed ownership.
747     uint256 private constant BITPOS_START_TIMESTAMP = 160;
748 
749     // The bit mask of the `burned` bit in packed ownership.
750     uint256 private constant BITMASK_BURNED = 1 << 224;
751 
752     // The bit position of the `nextInitialized` bit in packed ownership.
753     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
754 
755     // The bit mask of the `nextInitialized` bit in packed ownership.
756     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
757 
758     // The tokenId of the next token to be minted.
759     uint256 private _currentIndex;
760 
761     // The number of tokens burned.
762     uint256 private _burnCounter;
763 
764     // Token name
765     string private _name;
766 
767     // Token symbol
768     string private _symbol;
769 
770     // Mapping from token ID to ownership details
771     // An empty struct value does not necessarily mean the token is unowned.
772     // See `_packedOwnershipOf` implementation for details.
773     //
774     // Bits Layout:
775     // - [0..159]   `addr`
776     // - [160..223] `startTimestamp`
777     // - [224]      `burned`
778     // - [225]      `nextInitialized`
779     mapping(uint256 => uint256) private _packedOwnerships;
780 
781     // Mapping owner address to address data.
782     //
783     // Bits Layout:
784     // - [0..63]    `balance`
785     // - [64..127]  `numberMinted`
786     // - [128..191] `numberBurned`
787     // - [192..255] `aux`
788     mapping(address => uint256) private _packedAddressData;
789 
790     // Mapping from token ID to approved address.
791     mapping(uint256 => address) private _tokenApprovals;
792 
793     // Mapping from owner to operator approvals
794     mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799         _currentIndex = _startTokenId();
800     }
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
813     function _nextTokenId() internal view returns (uint256) {
814         return _currentIndex;
815     }
816 
817     /**
818      * @dev Returns the total number of tokens in existence.
819      * Burned tokens will reduce the count.
820      * To get the total number of tokens minted, please see `_totalMinted`.
821      */
822     function totalSupply() public view override returns (uint256) {
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
833     function _totalMinted() internal view returns (uint256) {
834         // Counter underflow is impossible as _currentIndex does not decrement,
835         // and it is initialized to `_startTokenId()`
836         unchecked {
837             return _currentIndex - _startTokenId();
838         }
839     }
840 
841     /**
842      * @dev Returns the total number of tokens burned.
843      */
844     function _totalBurned() internal view returns (uint256) {
845         return _burnCounter;
846     }
847 
848     /**
849      * @dev See {IERC165-supportsInterface}.
850      */
851     function supportsInterface(bytes4 interfaceId)
852         public
853         view
854         virtual
855         override
856         returns (bool)
857     {
858         // The interface IDs are constants representing the first 4 bytes of the XOR of
859         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
860         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
861         return
862             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
863             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
864             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
865     }
866 
867     /**
868      * @dev See {IERC721-balanceOf}.
869      */
870     function balanceOf(address owner) public view override returns (uint256) {
871         if (owner == address(0)) revert BalanceQueryForZeroAddress();
872         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
873     }
874 
875     /**
876      * Returns the number of tokens minted by `owner`.
877      */
878     function _numberMinted(address owner) internal view returns (uint256) {
879         return
880             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
881             BITMASK_ADDRESS_DATA_ENTRY;
882     }
883 
884     /**
885      * Returns the number of tokens burned by or on behalf of `owner`.
886      */
887     function _numberBurned(address owner) internal view returns (uint256) {
888         return
889             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
890             BITMASK_ADDRESS_DATA_ENTRY;
891     }
892 
893     /**
894      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      */
896     function _getAux(address owner) internal view returns (uint64) {
897         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
898     }
899 
900     /**
901      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
902      * If there are multiple variables, please pack them into a uint64.
903      */
904     function _setAux(address owner, uint64 aux) internal {
905         uint256 packed = _packedAddressData[owner];
906         uint256 auxCasted;
907         assembly {
908             // Cast aux without masking.
909             auxCasted := aux
910         }
911         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
912         _packedAddressData[owner] = packed;
913     }
914 
915     /**
916      * Returns the packed ownership data of `tokenId`.
917      */
918     function _packedOwnershipOf(uint256 tokenId)
919         private
920         view
921         returns (uint256)
922     {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (_startTokenId() <= curr)
927                 if (curr < _currentIndex) {
928                     uint256 packed = _packedOwnerships[curr];
929                     // If not burned.
930                     if (packed & BITMASK_BURNED == 0) {
931                         // Invariant:
932                         // There will always be an ownership that has an address and is not burned
933                         // before an ownership that does not have an address and is not burned.
934                         // Hence, curr will not underflow.
935                         //
936                         // We can directly compare the packed value.
937                         // If the address is zero, packed is zero.
938                         while (packed == 0) {
939                             packed = _packedOwnerships[--curr];
940                         }
941                         return packed;
942                     }
943                 }
944         }
945         revert OwnerQueryForNonexistentToken();
946     }
947 
948     /**
949      * Returns the unpacked `TokenOwnership` struct from `packed`.
950      */
951     function _unpackedOwnership(uint256 packed)
952         private
953         pure
954         returns (TokenOwnership memory ownership)
955     {
956         ownership.addr = address(uint160(packed));
957         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
958         ownership.burned = packed & BITMASK_BURNED != 0;
959     }
960 
961     /**
962      * Returns the unpacked `TokenOwnership` struct at `index`.
963      */
964     function _ownershipAt(uint256 index)
965         internal
966         view
967         returns (TokenOwnership memory)
968     {
969         return _unpackedOwnership(_packedOwnerships[index]);
970     }
971 
972     /**
973      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
974      */
975     function _initializeOwnershipAt(uint256 index) internal {
976         if (_packedOwnerships[index] == 0) {
977             _packedOwnerships[index] = _packedOwnershipOf(index);
978         }
979     }
980 
981     /**
982      * Gas spent here starts off proportional to the maximum mint batch size.
983      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
984      */
985     function _ownershipOf(uint256 tokenId)
986         internal
987         view
988         returns (TokenOwnership memory)
989     {
990         return _unpackedOwnership(_packedOwnershipOf(tokenId));
991     }
992 
993     /**
994      * @dev See {IERC721-ownerOf}.
995      */
996     function ownerOf(uint256 tokenId) public view override returns (address) {
997         return address(uint160(_packedOwnershipOf(tokenId)));
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-name}.
1002      */
1003     function name() public view virtual override returns (string memory) {
1004         return _name;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-symbol}.
1009      */
1010     function symbol() public view virtual override returns (string memory) {
1011         return _symbol;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-tokenURI}.
1016      */
1017     function tokenURI(uint256 tokenId)
1018         public
1019         view
1020         virtual
1021         override
1022         returns (string memory)
1023     {
1024         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1025 
1026         string memory baseURI = _baseURI();
1027         return
1028             bytes(baseURI).length != 0
1029                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1030                 : "";
1031     }
1032 
1033     /**
1034      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1035      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1036      * by default, can be overriden in child contracts.
1037      */
1038     function _baseURI() internal view virtual returns (string memory) {
1039         return "";
1040     }
1041 
1042     /**
1043      * @dev Casts the address to uint256 without masking.
1044      */
1045     function _addressToUint256(address value)
1046         private
1047         pure
1048         returns (uint256 result)
1049     {
1050         assembly {
1051             result := value
1052         }
1053     }
1054 
1055     /**
1056      * @dev Casts the boolean to uint256 without branching.
1057      */
1058     function _boolToUint256(bool value) private pure returns (uint256 result) {
1059         assembly {
1060             result := value
1061         }
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-approve}.
1066      */
1067     function approve(address to, uint256 tokenId) virtual public override {
1068         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1069         if (to == owner) revert ApprovalToCurrentOwner();
1070 
1071         if (_msgSenderERC721A() != owner)
1072             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1073                 revert ApprovalCallerNotOwnerNorApproved();
1074             }
1075 
1076         _tokenApprovals[tokenId] = to;
1077         emit Approval(owner, to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-getApproved}.
1082      */
1083     function getApproved(uint256 tokenId)
1084         public
1085         view
1086         override
1087         returns (address)
1088     {
1089         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1090 
1091         return _tokenApprovals[tokenId];
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-setApprovalForAll}.
1096      */
1097     function setApprovalForAll(address operator, bool approved)
1098         public
1099         virtual
1100         override
1101     {
1102         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1103 
1104         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1105         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-isApprovedForAll}.
1110      */
1111     function isApprovedForAll(address owner, address operator)
1112         public
1113         view
1114         virtual
1115         override
1116         returns (bool)
1117     {
1118         return _operatorApprovals[owner][operator];
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-transferFrom}.
1123      */
1124     function transferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) public virtual override {
1129         _transfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) public virtual override {
1140         safeTransferFrom(from, to, tokenId, "");
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-safeTransferFrom}.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) public virtual override {
1152         _transfer(from, to, tokenId);
1153         if (to.code.length != 0)
1154             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1155                 revert TransferToNonERC721ReceiverImplementer();
1156             }
1157     }
1158 
1159     /**
1160      * @dev Returns whether `tokenId` exists.
1161      *
1162      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1163      *
1164      * Tokens start existing when they are minted (`_mint`),
1165      */
1166     function _exists(uint256 tokenId) internal view returns (bool) {
1167         return
1168             _startTokenId() <= tokenId &&
1169             tokenId < _currentIndex && // If within bounds,
1170             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1171     }
1172 
1173     /**
1174      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1175      */
1176     function _safeMint(address to, uint256 quantity) internal {
1177         _safeMint(to, quantity, "");
1178     }
1179 
1180     /**
1181      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - If `to` refers to a smart contract, it must implement
1186      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1187      * - `quantity` must be greater than 0.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _safeMint(
1192         address to,
1193         uint256 quantity,
1194         bytes memory _data
1195     ) internal {
1196         uint256 startTokenId = _currentIndex;
1197         if (to == address(0)) revert MintToZeroAddress();
1198         if (quantity == 0) revert MintZeroQuantity();
1199 
1200         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1201 
1202         // Overflows are incredibly unrealistic.
1203         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1204         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1205         unchecked {
1206             // Updates:
1207             // - `balance += quantity`.
1208             // - `numberMinted += quantity`.
1209             //
1210             // We can directly add to the balance and number minted.
1211             _packedAddressData[to] +=
1212                 quantity *
1213                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1214 
1215             // Updates:
1216             // - `address` to the owner.
1217             // - `startTimestamp` to the timestamp of minting.
1218             // - `burned` to `false`.
1219             // - `nextInitialized` to `quantity == 1`.
1220             _packedOwnerships[startTokenId] =
1221                 _addressToUint256(to) |
1222                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1223                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1224 
1225             uint256 updatedIndex = startTokenId;
1226             uint256 end = updatedIndex + quantity;
1227 
1228             if (to.code.length != 0) {
1229                 do {
1230                     emit Transfer(address(0), to, updatedIndex);
1231                     if (
1232                         !_checkContractOnERC721Received(
1233                             address(0),
1234                             to,
1235                             updatedIndex++,
1236                             _data
1237                         )
1238                     ) {
1239                         revert TransferToNonERC721ReceiverImplementer();
1240                     }
1241                 } while (updatedIndex < end);
1242                 // Reentrancy protection
1243                 if (_currentIndex != startTokenId) revert();
1244             } else {
1245                 do {
1246                     emit Transfer(address(0), to, updatedIndex++);
1247                 } while (updatedIndex < end);
1248             }
1249             _currentIndex = updatedIndex;
1250         }
1251         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1252     }
1253 
1254     /**
1255      * @dev Mints `quantity` tokens and transfers them to `to`.
1256      *
1257      * Requirements:
1258      *
1259      * - `to` cannot be the zero address.
1260      * - `quantity` must be greater than 0.
1261      *
1262      * Emits a {Transfer} event.
1263      */
1264     function _mint(address to, uint256 quantity) internal {
1265         uint256 startTokenId = _currentIndex;
1266         if (to == address(0)) revert MintToZeroAddress();
1267         if (quantity == 0) revert MintZeroQuantity();
1268 
1269         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1270 
1271         // Overflows are incredibly unrealistic.
1272         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1273         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1274         unchecked {
1275             // Updates:
1276             // - `balance += quantity`.
1277             // - `numberMinted += quantity`.
1278             //
1279             // We can directly add to the balance and number minted.
1280             _packedAddressData[to] +=
1281                 quantity *
1282                 ((1 << BITPOS_NUMBER_MINTED) | 1);
1283 
1284             // Updates:
1285             // - `address` to the owner.
1286             // - `startTimestamp` to the timestamp of minting.
1287             // - `burned` to `false`.
1288             // - `nextInitialized` to `quantity == 1`.
1289             _packedOwnerships[startTokenId] =
1290                 _addressToUint256(to) |
1291                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1292                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1293 
1294             uint256 updatedIndex = startTokenId;
1295             uint256 end = updatedIndex + quantity;
1296 
1297             do {
1298                 emit Transfer(address(0), to, updatedIndex++);
1299             } while (updatedIndex < end);
1300 
1301             _currentIndex = updatedIndex;
1302         }
1303         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1304     }
1305 
1306     /**
1307      * @dev Transfers `tokenId` from `from` to `to`.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must be owned by `from`.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _transfer(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) private {
1321         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1322 
1323         if (address(uint160(prevOwnershipPacked)) != from)
1324             revert TransferFromIncorrectOwner();
1325 
1326         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1327             isApprovedForAll(from, _msgSenderERC721A()) ||
1328             getApproved(tokenId) == _msgSenderERC721A());
1329 
1330         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1331         if (to == address(0)) revert TransferToZeroAddress();
1332 
1333         _beforeTokenTransfers(from, to, tokenId, 1);
1334 
1335         // Clear approvals from the previous owner.
1336         delete _tokenApprovals[tokenId];
1337 
1338         // Underflow of the sender's balance is impossible because we check for
1339         // ownership above and the recipient's balance can't realistically overflow.
1340         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1341         unchecked {
1342             // We can directly increment and decrement the balances.
1343             --_packedAddressData[from]; // Updates: `balance -= 1`.
1344             ++_packedAddressData[to]; // Updates: `balance += 1`.
1345 
1346             // Updates:
1347             // - `address` to the next owner.
1348             // - `startTimestamp` to the timestamp of transfering.
1349             // - `burned` to `false`.
1350             // - `nextInitialized` to `true`.
1351             _packedOwnerships[tokenId] =
1352                 _addressToUint256(to) |
1353                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1354                 BITMASK_NEXT_INITIALIZED;
1355 
1356             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1357             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1358                 uint256 nextTokenId = tokenId + 1;
1359                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1360                 if (_packedOwnerships[nextTokenId] == 0) {
1361                     // If the next slot is within bounds.
1362                     if (nextTokenId != _currentIndex) {
1363                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1364                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1365                     }
1366                 }
1367             }
1368         }
1369 
1370         emit Transfer(from, to, tokenId);
1371         _afterTokenTransfers(from, to, tokenId, 1);
1372     }
1373 
1374     /**
1375      * @dev Equivalent to `_burn(tokenId, false)`.
1376      */
1377     function _burn(uint256 tokenId) internal virtual {
1378         _burn(tokenId, false);
1379     }
1380 
1381     /**
1382      * @dev Destroys `tokenId`.
1383      * The approval is cleared when the token is burned.
1384      *
1385      * Requirements:
1386      *
1387      * - `tokenId` must exist.
1388      *
1389      * Emits a {Transfer} event.
1390      */
1391     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1392         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1393 
1394         address from = address(uint160(prevOwnershipPacked));
1395 
1396         if (approvalCheck) {
1397             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1398                 isApprovedForAll(from, _msgSenderERC721A()) ||
1399                 getApproved(tokenId) == _msgSenderERC721A());
1400 
1401             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1402         }
1403 
1404         _beforeTokenTransfers(from, address(0), tokenId, 1);
1405 
1406         // Clear approvals from the previous owner.
1407         delete _tokenApprovals[tokenId];
1408 
1409         // Underflow of the sender's balance is impossible because we check for
1410         // ownership above and the recipient's balance can't realistically overflow.
1411         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1412         unchecked {
1413             // Updates:
1414             // - `balance -= 1`.
1415             // - `numberBurned += 1`.
1416             //
1417             // We can directly decrement the balance, and increment the number burned.
1418             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1419             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1420 
1421             // Updates:
1422             // - `address` to the last owner.
1423             // - `startTimestamp` to the timestamp of burning.
1424             // - `burned` to `true`.
1425             // - `nextInitialized` to `true`.
1426             _packedOwnerships[tokenId] =
1427                 _addressToUint256(from) |
1428                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1429                 BITMASK_BURNED |
1430                 BITMASK_NEXT_INITIALIZED;
1431 
1432             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1433             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1434                 uint256 nextTokenId = tokenId + 1;
1435                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1436                 if (_packedOwnerships[nextTokenId] == 0) {
1437                     // If the next slot is within bounds.
1438                     if (nextTokenId != _currentIndex) {
1439                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1440                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1441                     }
1442                 }
1443             }
1444         }
1445 
1446         emit Transfer(from, address(0), tokenId);
1447         _afterTokenTransfers(from, address(0), tokenId, 1);
1448 
1449         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1450         unchecked {
1451             _burnCounter++;
1452         }
1453     }
1454 
1455     /**
1456      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1457      *
1458      * @param from address representing the previous owner of the given token ID
1459      * @param to target address that will receive the tokens
1460      * @param tokenId uint256 ID of the token to be transferred
1461      * @param _data bytes optional data to send along with the call
1462      * @return bool whether the call correctly returned the expected magic value
1463      */
1464     function _checkContractOnERC721Received(
1465         address from,
1466         address to,
1467         uint256 tokenId,
1468         bytes memory _data
1469     ) private returns (bool) {
1470         try
1471             ERC721A__IERC721Receiver(to).onERC721Received(
1472                 _msgSenderERC721A(),
1473                 from,
1474                 tokenId,
1475                 _data
1476             )
1477         returns (bytes4 retval) {
1478             return
1479                 retval ==
1480                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1481         } catch (bytes memory reason) {
1482             if (reason.length == 0) {
1483                 revert TransferToNonERC721ReceiverImplementer();
1484             } else {
1485                 assembly {
1486                     revert(add(32, reason), mload(reason))
1487                 }
1488             }
1489         }
1490     }
1491 
1492     /**
1493      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1494      * And also called before burning one token.
1495      *
1496      * startTokenId - the first token id to be transferred
1497      * quantity - the amount to be transferred
1498      *
1499      * Calling conditions:
1500      *
1501      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1502      * transferred to `to`.
1503      * - When `from` is zero, `tokenId` will be minted for `to`.
1504      * - When `to` is zero, `tokenId` will be burned by `from`.
1505      * - `from` and `to` are never both zero.
1506      */
1507     function _beforeTokenTransfers(
1508         address from,
1509         address to,
1510         uint256 startTokenId,
1511         uint256 quantity
1512     ) internal virtual {}
1513 
1514     /**
1515      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1516      * minting.
1517      * And also called after one token has been burned.
1518      *
1519      * startTokenId - the first token id to be transferred
1520      * quantity - the amount to be transferred
1521      *
1522      * Calling conditions:
1523      *
1524      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1525      * transferred to `to`.
1526      * - When `from` is zero, `tokenId` has been minted for `to`.
1527      * - When `to` is zero, `tokenId` has been burned by `from`.
1528      * - `from` and `to` are never both zero.
1529      */
1530     function _afterTokenTransfers(
1531         address from,
1532         address to,
1533         uint256 startTokenId,
1534         uint256 quantity
1535     ) internal virtual {}
1536 
1537     /**
1538      * @dev Returns the message sender (defaults to `msg.sender`).
1539      *
1540      * If you are writing GSN compatible contracts, you need to override this function.
1541      */
1542     function _msgSenderERC721A() internal view virtual returns (address) {
1543         return msg.sender;
1544     }
1545 
1546     /**
1547      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1548      */
1549     function _toString(uint256 value)
1550         internal
1551         pure
1552         returns (string memory ptr)
1553     {
1554         assembly {
1555             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1556             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1557             // We will need 1 32-byte word to store the length,
1558             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1559             ptr := add(mload(0x40), 128)
1560             // Update the free memory pointer to allocate.
1561             mstore(0x40, ptr)
1562 
1563             // Cache the end of the memory to calculate the length later.
1564             let end := ptr
1565 
1566             // We write the string from the rightmost digit to the leftmost digit.
1567             // The following is essentially a do-while loop that also handles the zero case.
1568             // Costs a bit more than early returning for the zero case,
1569             // but cheaper in terms of deployment and overall runtime costs.
1570             for {
1571                 // Initialize and perform the first pass without check.
1572                 let temp := value
1573                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1574                 ptr := sub(ptr, 1)
1575                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1576                 mstore8(ptr, add(48, mod(temp, 10)))
1577                 temp := div(temp, 10)
1578             } temp {
1579                 // Keep dividing `temp` until zero.
1580                 temp := div(temp, 10)
1581             } {
1582                 // Body of the for loop.
1583                 ptr := sub(ptr, 1)
1584                 mstore8(ptr, add(48, mod(temp, 10)))
1585             }
1586 
1587             let length := sub(end, ptr)
1588             // Move the pointer 32 bytes leftwards to make room for the length.
1589             ptr := sub(ptr, 32)
1590             // Store the length.
1591             mstore(ptr, length)
1592         }
1593     }
1594 }
1595 
1596 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1597 
1598 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1599 
1600 pragma solidity ^0.8.0;
1601 
1602 /**
1603  * @dev String operations.
1604  */
1605 library Strings {
1606     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1607     uint8 private constant _ADDRESS_LENGTH = 20;
1608 
1609     /**
1610      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1611      */
1612     function toString(uint256 value) internal pure returns (string memory) {
1613         // Inspired by OraclizeAPI's implementation - MIT licence
1614         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1615 
1616         if (value == 0) {
1617             return "0";
1618         }
1619         uint256 temp = value;
1620         uint256 digits;
1621         while (temp != 0) {
1622             digits++;
1623             temp /= 10;
1624         }
1625         bytes memory buffer = new bytes(digits);
1626         while (value != 0) {
1627             digits -= 1;
1628             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1629             value /= 10;
1630         }
1631         return string(buffer);
1632     }
1633 
1634     /**
1635      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1636      */
1637     function toHexString(uint256 value) internal pure returns (string memory) {
1638         if (value == 0) {
1639             return "0x00";
1640         }
1641         uint256 temp = value;
1642         uint256 length = 0;
1643         while (temp != 0) {
1644             length++;
1645             temp >>= 8;
1646         }
1647         return toHexString(value, length);
1648     }
1649 
1650     /**
1651      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1652      */
1653     function toHexString(uint256 value, uint256 length)
1654         internal
1655         pure
1656         returns (string memory)
1657     {
1658         bytes memory buffer = new bytes(2 * length + 2);
1659         buffer[0] = "0";
1660         buffer[1] = "x";
1661         for (uint256 i = 2 * length + 1; i > 1; --i) {
1662             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1663             value >>= 4;
1664         }
1665         require(value == 0, "Strings: hex length insufficient");
1666         return string(buffer);
1667     }
1668 
1669     /**
1670      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1671      */
1672     function toHexString(address addr) internal pure returns (string memory) {
1673         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1674     }
1675 }
1676 
1677 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1678 
1679 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1680 
1681 pragma solidity ^0.8.0;
1682 
1683 /**
1684  * @dev Provides information about the current execution context, including the
1685  * sender of the transaction and its data. While these are generally available
1686  * via msg.sender and msg.data, they should not be accessed in such a direct
1687  * manner, since when dealing with meta-transactions the account sending and
1688  * paying for execution may not be the actual sender (as far as an application
1689  * is concerned).
1690  *
1691  * This contract is only required for intermediate, library-like contracts.
1692  */
1693 abstract contract Context {
1694     function _msgSender() internal view virtual returns (address) {
1695         return msg.sender;
1696     }
1697 
1698     function _msgData() internal view virtual returns (bytes calldata) {
1699         return msg.data;
1700     }
1701 }
1702 
1703 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1704 
1705 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1706 
1707 pragma solidity ^0.8.0;
1708 
1709 /**
1710  * @dev Contract module which provides a basic access control mechanism, where
1711  * there is an account (an owner) that can be granted exclusive access to
1712  * specific functions.
1713  *
1714  * By default, the owner account will be the one that deploys the contract. This
1715  * can later be changed with {transferOwnership}.
1716  *
1717  * This module is used through inheritance. It will make available the modifier
1718  * `onlyOwner`, which can be applied to your functions to restrict their use to
1719  * the owner.
1720  */
1721 abstract contract Ownable is Context {
1722     address private _owner;
1723 
1724     event OwnershipTransferred(
1725         address indexed previousOwner,
1726         address indexed newOwner
1727     );
1728 
1729     /**
1730      * @dev Initializes the contract setting the deployer as the initial owner.
1731      */
1732     constructor() {
1733         _transferOwnership(_msgSender());
1734     }
1735 
1736     /**
1737      * @dev Returns the address of the current owner.
1738      */
1739     function owner() public view virtual returns (address) {
1740         return _owner;
1741     }
1742 
1743     /**
1744      * @dev Throws if called by any account other than the owner.
1745      */
1746     modifier onlyOwner() {
1747         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1748         _;
1749     }
1750 
1751     /**
1752      * @dev Leaves the contract without owner. It will not be possible to call
1753      * `onlyOwner` functions anymore. Can only be called by the current owner.
1754      *
1755      * NOTE: Renouncing ownership will leave the contract without an owner,
1756      * thereby removing any functionality that is only available to the owner.
1757      */
1758     function renounceOwnership() public virtual onlyOwner {
1759         _transferOwnership(address(0));
1760     }
1761 
1762     /**
1763      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1764      * Can only be called by the current owner.
1765      */
1766     function transferOwnership(address newOwner) public virtual onlyOwner {
1767         require(
1768             newOwner != address(0),
1769             "Ownable: new owner is the zero address"
1770         );
1771         _transferOwnership(newOwner);
1772     }
1773 
1774     /**
1775      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1776      * Internal function without access restriction.
1777      */
1778     function _transferOwnership(address newOwner) internal virtual {
1779         address oldOwner = _owner;
1780         _owner = newOwner;
1781         emit OwnershipTransferred(oldOwner, newOwner);
1782     }
1783 }
1784 
1785 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1786 
1787 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1788 
1789 pragma solidity ^0.8.1;
1790 
1791 /**
1792  * @dev Collection of functions related to the address type
1793  */
1794 library Address {
1795     /**
1796      * @dev Returns true if `account` is a contract.
1797      *
1798      * [IMPORTANT]
1799      * ====
1800      * It is unsafe to assume that an address for which this function returns
1801      * false is an externally-owned account (EOA) and not a contract.
1802      *
1803      * Among others, `isContract` will return false for the following
1804      * types of addresses:
1805      *
1806      *  - an externally-owned account
1807      *  - a contract in construction
1808      *  - an address where a contract will be created
1809      *  - an address where a contract lived, but was destroyed
1810      * ====
1811      *
1812      * [IMPORTANT]
1813      * ====
1814      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1815      *
1816      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1817      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1818      * constructor.
1819      * ====
1820      */
1821     function isContract(address account) internal view returns (bool) {
1822         // This method relies on extcodesize/address.code.length, which returns 0
1823         // for contracts in construction, since the code is only stored at the end
1824         // of the constructor execution.
1825 
1826         return account.code.length > 0;
1827     }
1828 
1829     /**
1830      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1831      * `recipient`, forwarding all available gas and reverting on errors.
1832      *
1833      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1834      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1835      * imposed by `transfer`, making them unable to receive funds via
1836      * `transfer`. {sendValue} removes this limitation.
1837      *
1838      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1839      *
1840      * IMPORTANT: because control is transferred to `recipient`, care must be
1841      * taken to not create reentrancy vulnerabilities. Consider using
1842      * {ReentrancyGuard} or the
1843      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1844      */
1845     function sendValue(address payable recipient, uint256 amount) internal {
1846         require(
1847             address(this).balance >= amount,
1848             "Address: insufficient balance"
1849         );
1850 
1851         (bool success, ) = recipient.call{value: amount}("");
1852         require(
1853             success,
1854             "Address: unable to send value, recipient may have reverted"
1855         );
1856     }
1857 
1858     /**
1859      * @dev Performs a Solidity function call using a low level `call`. A
1860      * plain `call` is an unsafe replacement for a function call: use this
1861      * function instead.
1862      *
1863      * If `target` reverts with a revert reason, it is bubbled up by this
1864      * function (like regular Solidity function calls).
1865      *
1866      * Returns the raw returned data. To convert to the expected return value,
1867      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1868      *
1869      * Requirements:
1870      *
1871      * - `target` must be a contract.
1872      * - calling `target` with `data` must not revert.
1873      *
1874      * _Available since v3.1._
1875      */
1876     function functionCall(address target, bytes memory data)
1877         internal
1878         returns (bytes memory)
1879     {
1880         return functionCall(target, data, "Address: low-level call failed");
1881     }
1882 
1883     /**
1884      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1885      * `errorMessage` as a fallback revert reason when `target` reverts.
1886      *
1887      * _Available since v3.1._
1888      */
1889     function functionCall(
1890         address target,
1891         bytes memory data,
1892         string memory errorMessage
1893     ) internal returns (bytes memory) {
1894         return functionCallWithValue(target, data, 0, errorMessage);
1895     }
1896 
1897     /**
1898      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1899      * but also transferring `value` wei to `target`.
1900      *
1901      * Requirements:
1902      *
1903      * - the calling contract must have an ETH balance of at least `value`.
1904      * - the called Solidity function must be `payable`.
1905      *
1906      * _Available since v3.1._
1907      */
1908     function functionCallWithValue(
1909         address target,
1910         bytes memory data,
1911         uint256 value
1912     ) internal returns (bytes memory) {
1913         return
1914             functionCallWithValue(
1915                 target,
1916                 data,
1917                 value,
1918                 "Address: low-level call with value failed"
1919             );
1920     }
1921 
1922     /**
1923      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1924      * with `errorMessage` as a fallback revert reason when `target` reverts.
1925      *
1926      * _Available since v3.1._
1927      */
1928     function functionCallWithValue(
1929         address target,
1930         bytes memory data,
1931         uint256 value,
1932         string memory errorMessage
1933     ) internal returns (bytes memory) {
1934         require(
1935             address(this).balance >= value,
1936             "Address: insufficient balance for call"
1937         );
1938         require(isContract(target), "Address: call to non-contract");
1939 
1940         (bool success, bytes memory returndata) = target.call{value: value}(
1941             data
1942         );
1943         return verifyCallResult(success, returndata, errorMessage);
1944     }
1945 
1946     /**
1947      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1948      * but performing a static call.
1949      *
1950      * _Available since v3.3._
1951      */
1952     function functionStaticCall(address target, bytes memory data)
1953         internal
1954         view
1955         returns (bytes memory)
1956     {
1957         return
1958             functionStaticCall(
1959                 target,
1960                 data,
1961                 "Address: low-level static call failed"
1962             );
1963     }
1964 
1965     /**
1966      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1967      * but performing a static call.
1968      *
1969      * _Available since v3.3._
1970      */
1971     function functionStaticCall(
1972         address target,
1973         bytes memory data,
1974         string memory errorMessage
1975     ) internal view returns (bytes memory) {
1976         require(isContract(target), "Address: static call to non-contract");
1977 
1978         (bool success, bytes memory returndata) = target.staticcall(data);
1979         return verifyCallResult(success, returndata, errorMessage);
1980     }
1981 
1982     /**
1983      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1984      * but performing a delegate call.
1985      *
1986      * _Available since v3.4._
1987      */
1988     function functionDelegateCall(address target, bytes memory data)
1989         internal
1990         returns (bytes memory)
1991     {
1992         return
1993             functionDelegateCall(
1994                 target,
1995                 data,
1996                 "Address: low-level delegate call failed"
1997             );
1998     }
1999 
2000     //1b0014041a0a15
2001     /**
2002      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2003      * but performing a delegate call.
2004      *
2005      * _Available since v3.4._
2006      */
2007     function functionDelegateCall(
2008         address target,
2009         bytes memory data,
2010         string memory errorMessage
2011     ) internal returns (bytes memory) {
2012         require(isContract(target), "Address: delegate call to non-contract");
2013 
2014         (bool success, bytes memory returndata) = target.delegatecall(data);
2015         return verifyCallResult(success, returndata, errorMessage);
2016     }
2017 
2018     /**
2019      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2020      * revert reason using the provided one.
2021      *
2022      * _Available since v4.3._
2023      */
2024     function verifyCallResult(
2025         bool success,
2026         bytes memory returndata,
2027         string memory errorMessage
2028     ) internal pure returns (bytes memory) {
2029         if (success) {
2030             return returndata;
2031         } else {
2032             // Look for revert reason and bubble it up if present
2033             if (returndata.length > 0) {
2034                 // The easiest way to bubble the revert reason is using memory via assembly
2035 
2036                 assembly {
2037                     let returndata_size := mload(returndata)
2038                     revert(add(32, returndata), returndata_size)
2039                 }
2040             } else {
2041                 revert(errorMessage);
2042             }
2043         }
2044     }
2045 }
2046 
2047 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
2048 
2049 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2050 
2051 pragma solidity ^0.8.0;
2052 
2053 /**
2054  * @title ERC721 token receiver interface
2055  * @dev Interface for any contract that wants to support safeTransfers
2056  * from ERC721 asset contracts.
2057  */
2058 interface IERC721Receiver {
2059     /**
2060      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2061      * by `operator` from `from`, this function is called.
2062      *
2063      * It must return its Solidity selector to confirm the token transfer.
2064      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2065      *
2066      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2067      */
2068     function onERC721Received(
2069         address operator,
2070         address from,
2071         uint256 tokenId,
2072         bytes calldata data
2073     ) external returns (bytes4);
2074 }
2075 
2076 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
2077 
2078 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2079 
2080 pragma solidity ^0.8.0;
2081 
2082 /**
2083  * @dev Interface of the ERC165 standard, as defined in the
2084  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2085  *
2086  * Implementers can declare support of contract interfaces, which can then be
2087  * queried by others ({ERC165Checker}).
2088  *
2089  * For an implementation, see {ERC165}.
2090  */
2091 interface IERC165 {
2092     /**
2093      * @dev Returns true if this contract implements the interface defined by
2094      * `interfaceId`. See the corresponding
2095      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2096      * to learn more about how these ids are created.
2097      *
2098      * This function call must use less than 30 000 gas.
2099      */
2100     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2101 }
2102 
2103 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
2104 
2105 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2106 
2107 pragma solidity ^0.8.0;
2108 
2109 /**
2110  * @dev Implementation of the {IERC165} interface.
2111  *
2112  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2113  * for the additional interface id that will be supported. For example:
2114  *
2115  * ```solidity
2116  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2117  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2118  * }
2119  * ```
2120  *
2121  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2122  */
2123 abstract contract ERC165 is IERC165 {
2124     /**
2125      * @dev See {IERC165-supportsInterface}.
2126      */
2127     function supportsInterface(bytes4 interfaceId)
2128         public
2129         view
2130         virtual
2131         override
2132         returns (bool)
2133     {
2134         return interfaceId == type(IERC165).interfaceId;
2135     }
2136 }
2137 
2138 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
2139 
2140 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
2141 
2142 pragma solidity ^0.8.0;
2143 
2144 /**
2145  * @dev Required interface of an ERC721 compliant contract.
2146  */
2147 interface IERC721 is IERC165 {
2148     /**
2149      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2150      */
2151     event Transfer(
2152         address indexed from,
2153         address indexed to,
2154         uint256 indexed tokenId
2155     );
2156 
2157     /**
2158      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2159      */
2160     event Approval(
2161         address indexed owner,
2162         address indexed approved,
2163         uint256 indexed tokenId
2164     );
2165 
2166     /**
2167      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2168      */
2169     event ApprovalForAll(
2170         address indexed owner,
2171         address indexed operator,
2172         bool approved
2173     );
2174 
2175     /**
2176      * @dev Returns the number of tokens in ``owner``'s account.
2177      */
2178     function balanceOf(address owner) external view returns (uint256 balance);
2179 
2180     /**
2181      * @dev Returns the owner of the `tokenId` token.
2182      *
2183      * Requirements:
2184      *
2185      * - `tokenId` must exist.
2186      */
2187     function ownerOf(uint256 tokenId) external view returns (address owner);
2188 
2189     /**
2190      * @dev Safely transfers `tokenId` token from `from` to `to`.
2191      *
2192      * Requirements:
2193      *
2194      * - `from` cannot be the zero address.
2195      * - `to` cannot be the zero address.
2196      * - `tokenId` token must exist and be owned by `from`.
2197      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2198      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2199      *
2200      * Emits a {Transfer} event.
2201      */
2202     function safeTransferFrom(
2203         address from,
2204         address to,
2205         uint256 tokenId,
2206         bytes calldata data
2207     ) external;
2208 
2209     /**
2210      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2211      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2212      *
2213      * Requirements:
2214      *
2215      * - `from` cannot be the zero address.
2216      * - `to` cannot be the zero address.
2217      * - `tokenId` token must exist and be owned by `from`.
2218      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2219      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2220      *
2221      * Emits a {Transfer} event.
2222      */
2223     function safeTransferFrom(
2224         address from,
2225         address to,
2226         uint256 tokenId
2227     ) external;
2228 
2229     /**
2230      * @dev Transfers `tokenId` token from `from` to `to`.
2231      *
2232      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2233      *
2234      * Requirements:
2235      *
2236      * - `from` cannot be the zero address.
2237      * - `to` cannot be the zero address.
2238      * - `tokenId` token must be owned by `from`.
2239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2240      *
2241      * Emits a {Transfer} event.
2242      */
2243     function transferFrom(
2244         address from,
2245         address to,
2246         uint256 tokenId
2247     ) external;
2248 
2249     /**
2250      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2251      * The approval is cleared when the token is transferred.
2252      *
2253      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2254      *
2255      * Requirements:
2256      *
2257      * - The caller must own the token or be an approved operator.
2258      * - `tokenId` must exist.
2259      *
2260      * Emits an {Approval} event.
2261      */
2262     function approve(address to, uint256 tokenId) external;
2263 
2264     /**
2265      * @dev Approve or remove `operator` as an operator for the caller.
2266      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2267      *
2268      * Requirements:
2269      *
2270      * - The `operator` cannot be the caller.
2271      *
2272      * Emits an {ApprovalForAll} event.
2273      */
2274     function setApprovalForAll(address operator, bool _approved) external;
2275 
2276     /**
2277      * @dev Returns the account approved for `tokenId` token.
2278      *
2279      * Requirements:
2280      *
2281      * - `tokenId` must exist.
2282      */
2283     function getApproved(uint256 tokenId)
2284         external
2285         view
2286         returns (address operator);
2287 
2288     /**
2289      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2290      *
2291      * See {setApprovalForAll}
2292      */
2293     function isApprovedForAll(address owner, address operator)
2294         external
2295         view
2296         returns (bool);
2297 }
2298 
2299 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
2300 
2301 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2302 
2303 pragma solidity ^0.8.0;
2304 
2305 /**
2306  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2307  * @dev See https://eips.ethereum.org/EIPS/eip-721
2308  */
2309 interface IERC721Metadata is IERC721 {
2310     /**
2311      * @dev Returns the token collection name.
2312      */
2313     function name() external view returns (string memory);
2314 
2315     /**
2316      * @dev Returns the token collection symbol.
2317      */
2318     function symbol() external view returns (string memory);
2319 
2320     /**
2321      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2322      */
2323     function tokenURI(uint256 tokenId) external view returns (string memory);
2324 }
2325 
2326 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
2327 
2328 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
2329 
2330 pragma solidity ^0.8.0;
2331 
2332 /**
2333  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2334  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2335  * {ERC721Enumerable}.
2336  */
2337 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2338     using Address for address;
2339     using Strings for uint256;
2340 
2341     // Token name
2342     string private _name;
2343 
2344     // Token symbol
2345     string private _symbol;
2346 
2347     // Mapping from token ID to owner address
2348     mapping(uint256 => address) private _owners;
2349 
2350     // Mapping owner address to token count
2351     mapping(address => uint256) private _balances;
2352 
2353     // Mapping from token ID to approved address
2354     mapping(uint256 => address) private _tokenApprovals;
2355 
2356     // Mapping from owner to operator approvals
2357     mapping(address => mapping(address => bool)) private _operatorApprovals;
2358 
2359     /**
2360      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2361      */
2362     constructor(string memory name_, string memory symbol_) {
2363         _name = name_;
2364         _symbol = symbol_;
2365     }
2366 
2367     /**
2368      * @dev See {IERC165-supportsInterface}.
2369      */
2370     function supportsInterface(bytes4 interfaceId)
2371         public
2372         view
2373         virtual
2374         override(ERC165, IERC165)
2375         returns (bool)
2376     {
2377         return
2378             interfaceId == type(IERC721).interfaceId ||
2379             interfaceId == type(IERC721Metadata).interfaceId ||
2380             super.supportsInterface(interfaceId);
2381     }
2382 
2383     /**
2384      * @dev See {IERC721-balanceOf}.
2385      */
2386     function balanceOf(address owner)
2387         public
2388         view
2389         virtual
2390         override
2391         returns (uint256)
2392     {
2393         require(
2394             owner != address(0),
2395             "ERC721: address zero is not a valid owner"
2396         );
2397         return _balances[owner];
2398     }
2399 
2400     /**
2401      * @dev See {IERC721-ownerOf}.
2402      */
2403     function ownerOf(uint256 tokenId)
2404         public
2405         view
2406         virtual
2407         override
2408         returns (address)
2409     {
2410         address owner = _owners[tokenId];
2411         require(
2412             owner != address(0),
2413             "ERC721: owner query for nonexistent token"
2414         );
2415         return owner;
2416     }
2417 
2418     /**
2419      * @dev See {IERC721Metadata-name}.
2420      */
2421     function name() public view virtual override returns (string memory) {
2422         return _name;
2423     }
2424 
2425     /**
2426      * @dev See {IERC721Metadata-symbol}.
2427      */
2428     function symbol() public view virtual override returns (string memory) {
2429         return _symbol;
2430     }
2431 
2432     /**
2433      * @dev See {IERC721Metadata-tokenURI}.
2434      */
2435     function tokenURI(uint256 tokenId)
2436         public
2437         view
2438         virtual
2439         override
2440         returns (string memory)
2441     {
2442         require(
2443             _exists(tokenId),
2444             "ERC721Metadata: URI query for nonexistent token"
2445         );
2446 
2447         string memory baseURI = _baseURI();
2448         return
2449             bytes(baseURI).length > 0
2450                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2451                 : "";
2452     }
2453 
2454     /**
2455      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2456      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2457      * by default, can be overridden in child contracts.
2458      */
2459     function _baseURI() internal view virtual returns (string memory) {
2460         return "";
2461     }
2462 
2463     /**
2464      * @dev See {IERC721-approve}.
2465      */
2466     function approve(address to, uint256 tokenId) public virtual override {
2467         address owner = ERC721.ownerOf(tokenId);
2468         require(to != owner, "ERC721: approval to current owner");
2469 
2470         require(
2471             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2472             "ERC721: approve caller is not owner nor approved for all"
2473         );
2474 
2475         _approve(to, tokenId);
2476     }
2477 
2478     /**
2479      * @dev See {IERC721-getApproved}.
2480      */
2481     function getApproved(uint256 tokenId)
2482         public
2483         view
2484         virtual
2485         override
2486         returns (address)
2487     {
2488         require(
2489             _exists(tokenId),
2490             "ERC721: approved query for nonexistent token"
2491         );
2492 
2493         return _tokenApprovals[tokenId];
2494     }
2495 
2496     /**
2497      * @dev See {IERC721-setApprovalForAll}.
2498      */
2499     function setApprovalForAll(address operator, bool approved)
2500         public
2501         virtual
2502         override
2503     {
2504         _setApprovalForAll(_msgSender(), operator, approved);
2505     }
2506 
2507     /**
2508      * @dev See {IERC721-isApprovedForAll}.
2509      */
2510     function isApprovedForAll(address owner, address operator)
2511         public
2512         view
2513         virtual
2514         override
2515         returns (bool)
2516     {
2517         return _operatorApprovals[owner][operator];
2518     }
2519 
2520     /**
2521      * @dev See {IERC721-transferFrom}.
2522      */
2523     function transferFrom(
2524         address from,
2525         address to,
2526         uint256 tokenId
2527     ) public virtual override {
2528         //solhint-disable-next-line max-line-length
2529         require(
2530             _isApprovedOrOwner(_msgSender(), tokenId),
2531             "ERC721: transfer caller is not owner nor approved"
2532         );
2533 
2534         _transfer(from, to, tokenId);
2535     }
2536 
2537     /**
2538      * @dev See {IERC721-safeTransferFrom}.
2539      */
2540     function safeTransferFrom(
2541         address from,
2542         address to,
2543         uint256 tokenId
2544     ) public virtual override {
2545         safeTransferFrom(from, to, tokenId, "");
2546     }
2547 
2548     /**
2549      * @dev See {IERC721-safeTransferFrom}.
2550      */
2551     function safeTransferFrom(
2552         address from,
2553         address to,
2554         uint256 tokenId,
2555         bytes memory data
2556     ) public virtual override {
2557         require(
2558             _isApprovedOrOwner(_msgSender(), tokenId),
2559             "ERC721: transfer caller is not owner nor approved"
2560         );
2561         _safeTransfer(from, to, tokenId, data);
2562     }
2563 
2564     /**
2565      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2566      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2567      *
2568      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2569      *
2570      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2571      * implement alternative mechanisms to perform token transfer, such as signature-based.
2572      *
2573      * Requirements:
2574      *
2575      * - `from` cannot be the zero address.
2576      * - `to` cannot be the zero address.
2577      * - `tokenId` token must exist and be owned by `from`.
2578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2579      *
2580      * Emits a {Transfer} event.
2581      */
2582     function _safeTransfer(
2583         address from,
2584         address to,
2585         uint256 tokenId,
2586         bytes memory data
2587     ) internal virtual {
2588         _transfer(from, to, tokenId);
2589         require(
2590             _checkOnERC721Received(from, to, tokenId, data),
2591             "ERC721: transfer to non ERC721Receiver implementer"
2592         );
2593     }
2594 
2595     /**
2596      * @dev Returns whether `tokenId` exists.
2597      *
2598      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2599      *
2600      * Tokens start existing when they are minted (`_mint`),
2601      * and stop existing when they are burned (`_burn`).
2602      */
2603     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2604         return _owners[tokenId] != address(0);
2605     }
2606 
2607     /**
2608      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2609      *
2610      * Requirements:
2611      *
2612      * - `tokenId` must exist.
2613      */
2614     function _isApprovedOrOwner(address spender, uint256 tokenId)
2615         internal
2616         view
2617         virtual
2618         returns (bool)
2619     {
2620         require(
2621             _exists(tokenId),
2622             "ERC721: operator query for nonexistent token"
2623         );
2624         address owner = ERC721.ownerOf(tokenId);
2625         return (spender == owner ||
2626             isApprovedForAll(owner, spender) ||
2627             getApproved(tokenId) == spender);
2628     }
2629 
2630     /**
2631      * @dev Safely mints `tokenId` and transfers it to `to`.
2632      *
2633      * Requirements:
2634      *
2635      * - `tokenId` must not exist.
2636      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2637      *
2638      * Emits a {Transfer} event.
2639      */
2640     function _safeMint(address to, uint256 tokenId) internal virtual {
2641         _safeMint(to, tokenId, "");
2642     }
2643 
2644     /**
2645      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2646      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2647      */
2648     function _safeMint(
2649         address to,
2650         uint256 tokenId,
2651         bytes memory data
2652     ) internal virtual {
2653         _mint(to, tokenId);
2654         require(
2655             _checkOnERC721Received(address(0), to, tokenId, data),
2656             "ERC721: transfer to non ERC721Receiver implementer"
2657         );
2658     }
2659 
2660     /**
2661      * @dev Mints `tokenId` and transfers it to `to`.
2662      *
2663      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2664      *
2665      * Requirements:
2666      *
2667      * - `tokenId` must not exist.
2668      * - `to` cannot be the zero address.
2669      *
2670      * Emits a {Transfer} event.
2671      */
2672     function _mint(address to, uint256 tokenId) internal virtual {
2673         require(to != address(0), "ERC721: mint to the zero address");
2674         require(!_exists(tokenId), "ERC721: token already minted");
2675 
2676         _beforeTokenTransfer(address(0), to, tokenId);
2677 
2678         _balances[to] += 1;
2679         _owners[tokenId] = to;
2680 
2681         emit Transfer(address(0), to, tokenId);
2682 
2683         _afterTokenTransfer(address(0), to, tokenId);
2684     }
2685 
2686     /**
2687      * @dev Destroys `tokenId`.
2688      * The approval is cleared when the token is burned.
2689      *
2690      * Requirements:
2691      *
2692      * - `tokenId` must exist.
2693      *
2694      * Emits a {Transfer} event.
2695      */
2696     function _burn(uint256 tokenId) internal virtual {
2697         address owner = ERC721.ownerOf(tokenId);
2698 
2699         _beforeTokenTransfer(owner, address(0), tokenId);
2700 
2701         // Clear approvals
2702         _approve(address(0), tokenId);
2703 
2704         _balances[owner] -= 1;
2705         delete _owners[tokenId];
2706 
2707         emit Transfer(owner, address(0), tokenId);
2708 
2709         _afterTokenTransfer(owner, address(0), tokenId);
2710     }
2711 
2712     /**
2713      * @dev Transfers `tokenId` from `from` to `to`.
2714      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2715      *
2716      * Requirements:
2717      *
2718      * - `to` cannot be the zero address.
2719      * - `tokenId` token must be owned by `from`.
2720      *
2721      * Emits a {Transfer} event.
2722      */
2723     function _transfer(
2724         address from,
2725         address to,
2726         uint256 tokenId
2727     ) internal virtual {
2728         require(
2729             ERC721.ownerOf(tokenId) == from,
2730             "ERC721: transfer from incorrect owner"
2731         );
2732         require(to != address(0), "ERC721: transfer to the zero address");
2733 
2734         _beforeTokenTransfer(from, to, tokenId);
2735 
2736         // Clear approvals from the previous owner
2737         _approve(address(0), tokenId);
2738 
2739         _balances[from] -= 1;
2740         _balances[to] += 1;
2741         _owners[tokenId] = to;
2742 
2743         emit Transfer(from, to, tokenId);
2744 
2745         _afterTokenTransfer(from, to, tokenId);
2746     }
2747 
2748     /**
2749      * @dev Approve `to` to operate on `tokenId`
2750      *
2751      * Emits an {Approval} event.
2752      */
2753     function _approve(address to, uint256 tokenId) internal virtual {
2754         _tokenApprovals[tokenId] = to;
2755         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2756     }
2757 
2758     /**
2759      * @dev Approve `operator` to operate on all of `owner` tokens
2760      *
2761      * Emits an {ApprovalForAll} event.
2762      */
2763     function _setApprovalForAll(
2764         address owner,
2765         address operator,
2766         bool approved
2767     ) internal virtual {
2768         require(owner != operator, "ERC721: approve to caller");
2769         _operatorApprovals[owner][operator] = approved;
2770         emit ApprovalForAll(owner, operator, approved);
2771     }
2772 
2773     /**
2774      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2775      * The call is not executed if the target address is not a contract.
2776      *
2777      * @param from address representing the previous owner of the given token ID
2778      * @param to target address that will receive the tokens
2779      * @param tokenId uint256 ID of the token to be transferred
2780      * @param data bytes optional data to send along with the call
2781      * @return bool whether the call correctly returned the expected magic value
2782      */
2783     function _checkOnERC721Received(
2784         address from,
2785         address to,
2786         uint256 tokenId,
2787         bytes memory data
2788     ) private returns (bool) {
2789         if (to.isContract()) {
2790             try
2791                 IERC721Receiver(to).onERC721Received(
2792                     _msgSender(),
2793                     from,
2794                     tokenId,
2795                     data
2796                 )
2797             returns (bytes4 retval) {
2798                 return retval == IERC721Receiver.onERC721Received.selector;
2799             } catch (bytes memory reason) {
2800                 if (reason.length == 0) {
2801                     revert(
2802                         "ERC721: transfer to non ERC721Receiver implementer"
2803                     );
2804                 } else {
2805                     assembly {
2806                         revert(add(32, reason), mload(reason))
2807                     }
2808                 }
2809             }
2810         } else {
2811             return true;
2812         }
2813     }
2814 
2815     /**
2816      * @dev Hook that is called before any token transfer. This includes minting
2817      * and burning.
2818      *
2819      * Calling conditions:
2820      *
2821      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2822      * transferred to `to`.
2823      * - When `from` is zero, `tokenId` will be minted for `to`.
2824      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2825      * - `from` and `to` are never both zero.
2826      *
2827      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2828      */
2829     function _beforeTokenTransfer(
2830         address from,
2831         address to,
2832         uint256 tokenId
2833     ) internal virtual {}
2834 
2835     /**
2836      * @dev Hook that is called after any transfer of tokens. This includes
2837      * minting and burning.
2838      *
2839      * Calling conditions:
2840      *
2841      * - when `from` and `to` are both non-zero.
2842      * - `from` and `to` are never both zero.
2843      *
2844      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2845      */
2846     function _afterTokenTransfer(
2847         address from,
2848         address to,
2849         uint256 tokenId
2850     ) internal virtual {}
2851 }
2852 
2853 
2854 pragma solidity ^0.8.0;
2855 
2856 contract KillerChicks is ERC721A, Ownable, ReentrancyGuard ,DefaultOperatorFilterer{
2857     using Strings for uint256;
2858 
2859     string private baseURI;
2860 
2861     uint256 public maxPerWallet = 4;
2862     uint256 public price = 0.0068 ether;
2863 
2864     uint256 public maxFreePerWallet = 1;
2865 
2866     uint256 public maxSupply = 2222; 
2867     bool public mintEnabled = false;
2868     bool public publicEnabled = false;
2869 
2870     bytes32 ogRoot;
2871     bytes32 whitelistRoot;
2872 
2873     string public hiddenURI = "ipfs://bafybeihgbi72njlfhnzpaoqjjfj4agcd7bkfnfb5mab2bz7dyklso7efte/hidden.json";
2874 
2875     bool public revealed = false;
2876 
2877     mapping(address => bool) private _mintedFree;
2878 
2879     constructor() ERC721A("KillerChicks", "KC") {}
2880 
2881     function ogMint(bytes32[] calldata _merkleProof, uint256 count)
2882         external
2883         payable
2884         nonReentrant
2885     {
2886         bool isFreeLeft = !(_mintedFree[msg.sender]);
2887         bool isEqual = count == maxFreePerWallet;
2888 
2889         uint256 cost = price;
2890 
2891         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2892 
2893         if (isFreeLeft && isEqual) {
2894             cost = 0;
2895         }
2896 
2897         if (isFreeLeft && !isEqual) {
2898             require(
2899                 msg.value >= (count - maxFreePerWallet) * cost,
2900                 "Please send the exact amount."
2901             );
2902         } else {
2903             require(msg.value >= count * cost, "Please send the exact amount.");
2904         }
2905         require(
2906             MerkleProof.verify(_merkleProof, ogRoot, leaf),
2907             "Incorrect Whitelist Proof"
2908         );
2909         require(totalSupply() + count <= maxSupply, "No more");
2910         require(count > 0, "Please enter a number");
2911         require(mintEnabled, "Minting is not live yet");
2912         require(
2913             _numberMinted(msg.sender) + count <= maxPerWallet,
2914             "Can not mint more than 4"
2915         );
2916 
2917         _mintedFree[msg.sender] = true;
2918 
2919         _safeMint(msg.sender, count);
2920     }
2921 
2922     function whitelistMint(bytes32[] calldata _merkleProof, uint256 count)
2923         external
2924         payable
2925     {
2926         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2927 
2928         require(
2929             MerkleProof.verify(_merkleProof, whitelistRoot, leaf),
2930             "Incorrect Whitelist Proof"
2931         );
2932         require(msg.value >= price * count, "Please send the exact amount.");
2933         require(
2934             _numberMinted(msg.sender) + count <= maxPerWallet,
2935             "You cant mint anymore"
2936         );
2937         require(totalSupply() + count <= maxSupply, "No more");
2938         require(mintEnabled, "Minting is not live yet");
2939 
2940         _safeMint(msg.sender, count);
2941     }
2942 
2943     function publicMint(uint256 count) external payable {
2944         require(msg.value >= count * price, "Please send the exact amount.");
2945         require(totalSupply() + count <= maxSupply, "No more NFT left");
2946         require(
2947             _numberMinted(msg.sender) + count <= maxPerWallet,
2948             "Can not mint more than 4"
2949         );
2950         require(count > 0, "Please enter a number");
2951         require(publicEnabled, "Minting is not live yet");
2952 
2953         _safeMint(msg.sender, count);
2954     }
2955 
2956     function _baseURI() internal view virtual override returns (string memory) {
2957         return baseURI;
2958     }
2959 
2960     function _isMintedFree(address minter) external view returns (bool) {
2961         return _mintedFree[minter];
2962     }
2963 
2964     function _mintedAmount(address account) external view returns (uint256) {
2965         return _numberMinted(account);
2966     }
2967 
2968     function tokenURI(uint256 tokenId)
2969         public
2970         view
2971         virtual
2972         override
2973         returns (string memory)
2974     {
2975         require(
2976             _exists(tokenId),
2977             "ERC721AMetadata: URI query for nonexistent token"
2978         );
2979         if (revealed == false) {
2980             return hiddenURI;
2981         }
2982 
2983         string memory currentBaseURI = _baseURI();
2984         return
2985             bytes(currentBaseURI).length > 0
2986                 ? string(
2987                     abi.encodePacked(
2988                         currentBaseURI,
2989                         tokenId.toString(),
2990                         ".json"
2991                     )
2992                 )
2993                 : "";
2994     }
2995 
2996     function setPreSaleRoot(bytes32 _presaleRoot_1, bytes32 _presaleRoot_2)
2997         external
2998         onlyOwner
2999     {
3000         ogRoot = _presaleRoot_1;
3001         whitelistRoot = _presaleRoot_2;
3002     }
3003 
3004     // Only Owner Functions-----------
3005     function setBaseURI(string memory uri) public onlyOwner {
3006         baseURI = uri;
3007     }
3008 
3009     function setMaxPerWallet(uint256 amount) external onlyOwner {
3010         maxPerWallet = amount;
3011     }
3012 
3013     function setPrice(uint256 _newPrice) external onlyOwner {
3014         price = _newPrice;
3015     }
3016 
3017     function setMaxSupply(uint256 _newSupply) external onlyOwner {
3018         maxSupply = _newSupply;
3019     }
3020 
3021     function flipWhitelist(bool status) external onlyOwner {
3022         mintEnabled = status;
3023     }
3024 
3025     function flipPublic(bool status) external onlyOwner {
3026         publicEnabled = status;
3027     }
3028 
3029     function reveal() external onlyOwner {
3030         revealed = !revealed;
3031     }
3032 
3033     function batchMint(uint256 _mintAmount, address destination)
3034         public
3035         onlyOwner
3036     {
3037         require(_mintAmount > 0, "need to mint at least 1 NFT");
3038         uint256 supply = totalSupply();
3039         require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
3040 
3041         _safeMint(destination, _mintAmount);
3042     }
3043 
3044     function withdraw() external onlyOwner {
3045         (bool success, ) = payable(msg.sender).call{
3046             value: address(this).balance
3047         }("");
3048         require(success, "Transfer failed.");
3049     }
3050       function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3051         super.setApprovalForAll(operator, approved);
3052     }
3053 
3054     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
3055         super.approve(operator, tokenId);
3056     }
3057 
3058     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3059         super.transferFrom(from, to, tokenId);
3060     }
3061 
3062     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
3063         super.safeTransferFrom(from, to, tokenId);
3064     }
3065 
3066     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3067         public
3068         override
3069         onlyAllowedOperator(from)
3070     {
3071         super.safeTransferFrom(from, to, tokenId, data);
3072     }
3073 }