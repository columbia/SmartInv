1 // File: contracts/IOperatorFilterRegistry.sol
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
33 // File: contracts/OperatorFilterer.sol
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
95 // File: contracts/DefaultOperatorFilterer.sol
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
111 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to {approve}. `value` is the new allowance.
133      */
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 
136     /**
137      * @dev Returns the amount of tokens in existence.
138      */
139     function totalSupply() external view returns (uint256);
140 
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145 
146     /**
147      * @dev Moves `amount` tokens from the caller's account to `to`.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transfer(address to, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Returns the remaining number of tokens that `spender` will be
157      * allowed to spend on behalf of `owner` through {transferFrom}. This is
158      * zero by default.
159      *
160      * This value changes when {approve} or {transferFrom} are called.
161      */
162     function allowance(address owner, address spender) external view returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `from` to `to` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(
190         address from,
191         address to,
192         uint256 amount
193     ) external returns (bool);
194 }
195 
196 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
197 
198 
199 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev These functions deal with verification of Merkle Tree proofs.
205  *
206  * The tree and the proofs can be generated using our
207  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
208  * You will find a quickstart guide in the readme.
209  *
210  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
211  * hashing, or use a hash function other than keccak256 for hashing leaves.
212  * This is because the concatenation of a sorted pair of internal nodes in
213  * the merkle tree could be reinterpreted as a leaf value.
214  * OpenZeppelin's JavaScript library generates merkle trees that are safe
215  * against this attack out of the box.
216  */
217 library MerkleProof {
218     /**
219      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
220      * defined by `root`. For this, a `proof` must be provided, containing
221      * sibling hashes on the branch from the leaf to the root of the tree. Each
222      * pair of leaves and each pair of pre-images are assumed to be sorted.
223      */
224     function verify(
225         bytes32[] memory proof,
226         bytes32 root,
227         bytes32 leaf
228     ) internal pure returns (bool) {
229         return processProof(proof, leaf) == root;
230     }
231 
232     /**
233      * @dev Calldata version of {verify}
234      *
235      * _Available since v4.7._
236      */
237     function verifyCalldata(
238         bytes32[] calldata proof,
239         bytes32 root,
240         bytes32 leaf
241     ) internal pure returns (bool) {
242         return processProofCalldata(proof, leaf) == root;
243     }
244 
245     /**
246      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
247      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
248      * hash matches the root of the tree. When processing the proof, the pairs
249      * of leafs & pre-images are assumed to be sorted.
250      *
251      * _Available since v4.4._
252      */
253     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
254         bytes32 computedHash = leaf;
255         for (uint256 i = 0; i < proof.length; i++) {
256             computedHash = _hashPair(computedHash, proof[i]);
257         }
258         return computedHash;
259     }
260 
261     /**
262      * @dev Calldata version of {processProof}
263      *
264      * _Available since v4.7._
265      */
266     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
267         bytes32 computedHash = leaf;
268         for (uint256 i = 0; i < proof.length; i++) {
269             computedHash = _hashPair(computedHash, proof[i]);
270         }
271         return computedHash;
272     }
273 
274     /**
275      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
276      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
277      *
278      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
279      *
280      * _Available since v4.7._
281      */
282     function multiProofVerify(
283         bytes32[] memory proof,
284         bool[] memory proofFlags,
285         bytes32 root,
286         bytes32[] memory leaves
287     ) internal pure returns (bool) {
288         return processMultiProof(proof, proofFlags, leaves) == root;
289     }
290 
291     /**
292      * @dev Calldata version of {multiProofVerify}
293      *
294      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
295      *
296      * _Available since v4.7._
297      */
298     function multiProofVerifyCalldata(
299         bytes32[] calldata proof,
300         bool[] calldata proofFlags,
301         bytes32 root,
302         bytes32[] memory leaves
303     ) internal pure returns (bool) {
304         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
305     }
306 
307     /**
308      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
309      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
310      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
311      * respectively.
312      *
313      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
314      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
315      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
316      *
317      * _Available since v4.7._
318      */
319     function processMultiProof(
320         bytes32[] memory proof,
321         bool[] memory proofFlags,
322         bytes32[] memory leaves
323     ) internal pure returns (bytes32 merkleRoot) {
324         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
325         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
326         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
327         // the merkle tree.
328         uint256 leavesLen = leaves.length;
329         uint256 totalHashes = proofFlags.length;
330 
331         // Check proof validity.
332         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
333 
334         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
335         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
336         bytes32[] memory hashes = new bytes32[](totalHashes);
337         uint256 leafPos = 0;
338         uint256 hashPos = 0;
339         uint256 proofPos = 0;
340         // At each step, we compute the next hash using two values:
341         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
342         //   get the next hash.
343         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
344         //   `proof` array.
345         for (uint256 i = 0; i < totalHashes; i++) {
346             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
347             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
348             hashes[i] = _hashPair(a, b);
349         }
350 
351         if (totalHashes > 0) {
352             return hashes[totalHashes - 1];
353         } else if (leavesLen > 0) {
354             return leaves[0];
355         } else {
356             return proof[0];
357         }
358     }
359 
360     /**
361      * @dev Calldata version of {processMultiProof}.
362      *
363      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
364      *
365      * _Available since v4.7._
366      */
367     function processMultiProofCalldata(
368         bytes32[] calldata proof,
369         bool[] calldata proofFlags,
370         bytes32[] memory leaves
371     ) internal pure returns (bytes32 merkleRoot) {
372         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
373         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
374         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
375         // the merkle tree.
376         uint256 leavesLen = leaves.length;
377         uint256 totalHashes = proofFlags.length;
378 
379         // Check proof validity.
380         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
381 
382         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
383         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
384         bytes32[] memory hashes = new bytes32[](totalHashes);
385         uint256 leafPos = 0;
386         uint256 hashPos = 0;
387         uint256 proofPos = 0;
388         // At each step, we compute the next hash using two values:
389         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
390         //   get the next hash.
391         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
392         //   `proof` array.
393         for (uint256 i = 0; i < totalHashes; i++) {
394             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
395             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
396             hashes[i] = _hashPair(a, b);
397         }
398 
399         if (totalHashes > 0) {
400             return hashes[totalHashes - 1];
401         } else if (leavesLen > 0) {
402             return leaves[0];
403         } else {
404             return proof[0];
405         }
406     }
407 
408     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
409         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
410     }
411 
412     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
413         /// @solidity memory-safe-assembly
414         assembly {
415             mstore(0x00, a)
416             mstore(0x20, b)
417             value := keccak256(0x00, 0x40)
418         }
419     }
420 }
421 
422 // File: contracts/IERC721A.sol
423 
424 
425 // ERC721A Contracts v4.2.3
426 // Creator: Chiru Labs
427 
428 pragma solidity ^0.8.4;
429 
430 /**
431  * @dev Interface of ERC721A.
432  */
433 interface IERC721A {
434     /**
435      * The caller must own the token or be an approved operator.
436      */
437     error ApprovalCallerNotOwnerNorApproved();
438 
439     /**
440      * The token does not exist.
441      */
442     error ApprovalQueryForNonexistentToken();
443 
444     /**
445      * Cannot query the balance for the zero address.
446      */
447     error BalanceQueryForZeroAddress();
448 
449     /**
450      * Cannot mint to the zero address.
451      */
452     error MintToZeroAddress();
453 
454     /**
455      * The quantity of tokens minted must be more than zero.
456      */
457     error MintZeroQuantity();
458 
459     /**
460      * The token does not exist.
461      */
462     error OwnerQueryForNonexistentToken();
463 
464     /**
465      * The caller must own the token or be an approved operator.
466      */
467     error TransferCallerNotOwnerNorApproved();
468 
469     /**
470      * The token must be owned by `from`.
471      */
472     error TransferFromIncorrectOwner();
473 
474     /**
475      * Cannot safely transfer to a contract that does not implement the
476      * ERC721Receiver interface.
477      */
478     error TransferToNonERC721ReceiverImplementer();
479 
480     /**
481      * Cannot transfer to the zero address.
482      */
483     error TransferToZeroAddress();
484 
485     /**
486      * The token does not exist.
487      */
488     error URIQueryForNonexistentToken();
489 
490     /**
491      * The `quantity` minted with ERC2309 exceeds the safety limit.
492      */
493     error MintERC2309QuantityExceedsLimit();
494 
495     /**
496      * The `extraData` cannot be set on an unintialized ownership slot.
497      */
498     error OwnershipNotInitializedForExtraData();
499 
500     // =============================================================
501     //                            STRUCTS
502     // =============================================================
503 
504     struct TokenOwnership {
505         // The address of the owner.
506         address addr;
507         // Stores the start time of ownership with minimal overhead for tokenomics.
508         uint64 startTimestamp;
509         // Whether the token has been burned.
510         bool burned;
511         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
512         uint24 extraData;
513     }
514 
515     // =============================================================
516     //                         TOKEN COUNTERS
517     // =============================================================
518 
519     /**
520      * @dev Returns the total number of tokens in existence.
521      * Burned tokens will reduce the count.
522      * To get the total number of tokens minted, please see {_totalMinted}.
523      */
524     function totalSupply() external view returns (uint256);
525 
526     // =============================================================
527     //                            IERC165
528     // =============================================================
529 
530     /**
531      * @dev Returns true if this contract implements the interface defined by
532      * `interfaceId`. See the corresponding
533      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
534      * to learn more about how these ids are created.
535      *
536      * This function call must use less than 30000 gas.
537      */
538     function supportsInterface(bytes4 interfaceId) external view returns (bool);
539 
540     // =============================================================
541     //                            IERC721
542     // =============================================================
543 
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables
556      * (`approved`) `operator` to manage all of its assets.
557      */
558     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
559 
560     /**
561      * @dev Returns the number of tokens in `owner`'s account.
562      */
563     function balanceOf(address owner) external view returns (uint256 balance);
564 
565     /**
566      * @dev Returns the owner of the `tokenId` token.
567      *
568      * Requirements:
569      *
570      * - `tokenId` must exist.
571      */
572     function ownerOf(uint256 tokenId) external view returns (address owner);
573 
574     /**
575      * @dev Safely transfers `tokenId` token from `from` to `to`,
576      * checking first that contract recipients are aware of the ERC721 protocol
577      * to prevent tokens from being forever locked.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must be have been allowed to move
585      * this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement
587      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId,
595         bytes calldata data
596     ) external payable;
597 
598     /**
599      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
600      */
601     function safeTransferFrom(
602         address from,
603         address to,
604         uint256 tokenId
605     ) external payable;
606 
607     /**
608      * @dev Transfers `tokenId` from `from` to `to`.
609      *
610      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
611      * whenever possible.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must be owned by `from`.
618      * - If the caller is not `from`, it must be approved to move this token
619      * by either {approve} or {setApprovalForAll}.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external payable;
628 
629     /**
630      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
631      * The approval is cleared when the token is transferred.
632      *
633      * Only a single account can be approved at a time, so approving the
634      * zero address clears previous approvals.
635      *
636      * Requirements:
637      *
638      * - The caller must own the token or be an approved operator.
639      * - `tokenId` must exist.
640      *
641      * Emits an {Approval} event.
642      */
643     function approve(address to, uint256 tokenId) external payable;
644 
645     /**
646      * @dev Approve or remove `operator` as an operator for the caller.
647      * Operators can call {transferFrom} or {safeTransferFrom}
648      * for any token owned by the caller.
649      *
650      * Requirements:
651      *
652      * - The `operator` cannot be the caller.
653      *
654      * Emits an {ApprovalForAll} event.
655      */
656     function setApprovalForAll(address operator, bool _approved) external;
657 
658     /**
659      * @dev Returns the account approved for `tokenId` token.
660      *
661      * Requirements:
662      *
663      * - `tokenId` must exist.
664      */
665     function getApproved(uint256 tokenId) external view returns (address operator);
666 
667     /**
668      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
669      *
670      * See {setApprovalForAll}.
671      */
672     function isApprovedForAll(address owner, address operator) external view returns (bool);
673 
674     // =============================================================
675     //                        IERC721Metadata
676     // =============================================================
677 
678     /**
679      * @dev Returns the token collection name.
680      */
681     function name() external view returns (string memory);
682 
683     /**
684      * @dev Returns the token collection symbol.
685      */
686     function symbol() external view returns (string memory);
687 
688     /**
689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
690      */
691     function tokenURI(uint256 tokenId) external view returns (string memory);
692 
693     // =============================================================
694     //                           IERC2309
695     // =============================================================
696 
697     /**
698      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
699      * (inclusive) is transferred from `from` to `to`, as defined in the
700      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
701      *
702      * See {_mintERC2309} for more details.
703      */
704     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
705 }
706 // File: contracts/ERC721A.sol
707 
708 
709 // ERC721A Contracts v4.2.3
710 // Creator: Chiru Labs
711 
712 pragma solidity ^0.8.4;
713 
714 
715 /**
716  * @dev Interface of ERC721 token receiver.
717  */
718 interface ERC721A__IERC721Receiver {
719     function onERC721Received(
720         address operator,
721         address from,
722         uint256 tokenId,
723         bytes calldata data
724     ) external returns (bytes4);
725 }
726 
727 /**
728  * @title ERC721A
729  *
730  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
731  * Non-Fungible Token Standard, including the Metadata extension.
732  * Optimized for lower gas during batch mints.
733  *
734  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
735  * starting from `_startTokenId()`.
736  *
737  * Assumptions:
738  *
739  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
740  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
741  */
742 contract ERC721A is IERC721A {
743     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
744     struct TokenApprovalRef {
745         address value;
746     }
747 
748     // =============================================================
749     //                           CONSTANTS
750     // =============================================================
751 
752     // Mask of an entry in packed address data.
753     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
754 
755     // The bit position of `numberMinted` in packed address data.
756     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
757 
758     // The bit position of `numberBurned` in packed address data.
759     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
760 
761     // The bit position of `aux` in packed address data.
762     uint256 private constant _BITPOS_AUX = 192;
763 
764     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
765     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
766 
767     // The bit position of `startTimestamp` in packed ownership.
768     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
769 
770     // The bit mask of the `burned` bit in packed ownership.
771     uint256 private constant _BITMASK_BURNED = 1 << 224;
772 
773     // The bit position of the `nextInitialized` bit in packed ownership.
774     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
775 
776     // The bit mask of the `nextInitialized` bit in packed ownership.
777     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
778 
779     // The bit position of `extraData` in packed ownership.
780     uint256 private constant _BITPOS_EXTRA_DATA = 232;
781 
782     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
783     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
784 
785     // The mask of the lower 160 bits for addresses.
786     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
787 
788     // The maximum `quantity` that can be minted with {_mintERC2309}.
789     // This limit is to prevent overflows on the address data entries.
790     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
791     // is required to cause an overflow, which is unrealistic.
792     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
793 
794     // The `Transfer` event signature is given by:
795     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
796     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
797         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
798 
799     // =============================================================
800     //                            STORAGE
801     // =============================================================
802 
803     // The next token ID to be minted.
804     uint256 private _currentIndex;
805 
806     // The number of tokens burned.
807     uint256 private _burnCounter;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned.
817     // See {_packedOwnershipOf} implementation for details.
818     //
819     // Bits Layout:
820     // - [0..159]   `addr`
821     // - [160..223] `startTimestamp`
822     // - [224]      `burned`
823     // - [225]      `nextInitialized`
824     // - [232..255] `extraData`
825     mapping(uint256 => uint256) private _packedOwnerships;
826 
827     // Mapping owner address to address data.
828     //
829     // Bits Layout:
830     // - [0..63]    `balance`
831     // - [64..127]  `numberMinted`
832     // - [128..191] `numberBurned`
833     // - [192..255] `aux`
834     mapping(address => uint256) private _packedAddressData;
835 
836     // Mapping from token ID to approved address.
837     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
838 
839     // Mapping from owner to operator approvals
840     mapping(address => mapping(address => bool)) private _operatorApprovals;
841 
842     // =============================================================
843     //                          CONSTRUCTOR
844     // =============================================================
845 
846     constructor(string memory name_, string memory symbol_) {
847         _name = name_;
848         _symbol = symbol_;
849         _currentIndex = _startTokenId();
850     }
851 
852     // =============================================================
853     //                   TOKEN COUNTING OPERATIONS
854     // =============================================================
855 
856     /**
857      * @dev Returns the starting token ID.
858      * To change the starting token ID, please override this function.
859      */
860     function _startTokenId() internal view virtual returns (uint256) {
861         return 0;
862     }
863 
864     /**
865      * @dev Returns the next token ID to be minted.
866      */
867     function _nextTokenId() internal view virtual returns (uint256) {
868         return _currentIndex;
869     }
870 
871     /**
872      * @dev Returns the total number of tokens in existence.
873      * Burned tokens will reduce the count.
874      * To get the total number of tokens minted, please see {_totalMinted}.
875      */
876     function totalSupply() public view virtual override returns (uint256) {
877         // Counter underflow is impossible as _burnCounter cannot be incremented
878         // more than `_currentIndex - _startTokenId()` times.
879         unchecked {
880             return _currentIndex - _burnCounter - _startTokenId();
881         }
882     }
883 
884     /**
885      * @dev Returns the total amount of tokens minted in the contract.
886      */
887     function _totalMinted() internal view virtual returns (uint256) {
888         // Counter underflow is impossible as `_currentIndex` does not decrement,
889         // and it is initialized to `_startTokenId()`.
890         unchecked {
891             return _currentIndex - _startTokenId();
892         }
893     }
894 
895     /**
896      * @dev Returns the total number of tokens burned.
897      */
898     function _totalBurned() internal view virtual returns (uint256) {
899         return _burnCounter;
900     }
901 
902     // =============================================================
903     //                    ADDRESS DATA OPERATIONS
904     // =============================================================
905 
906     /**
907      * @dev Returns the number of tokens in `owner`'s account.
908      */
909     function balanceOf(address owner) public view virtual override returns (uint256) {
910         if (owner == address(0)) revert BalanceQueryForZeroAddress();
911         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
912     }
913 
914     /**
915      * Returns the number of tokens minted by `owner`.
916      */
917     function _numberMinted(address owner) internal view returns (uint256) {
918         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
919     }
920 
921     /**
922      * Returns the number of tokens burned by or on behalf of `owner`.
923      */
924     function _numberBurned(address owner) internal view returns (uint256) {
925         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
926     }
927 
928     /**
929      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
930      */
931     function _getAux(address owner) internal view returns (uint64) {
932         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
933     }
934 
935     /**
936      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
937      * If there are multiple variables, please pack them into a uint64.
938      */
939     function _setAux(address owner, uint64 aux) internal virtual {
940         uint256 packed = _packedAddressData[owner];
941         uint256 auxCasted;
942         // Cast `aux` with assembly to avoid redundant masking.
943         assembly {
944             auxCasted := aux
945         }
946         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
947         _packedAddressData[owner] = packed;
948     }
949 
950     // =============================================================
951     //                            IERC165
952     // =============================================================
953 
954     /**
955      * @dev Returns true if this contract implements the interface defined by
956      * `interfaceId`. See the corresponding
957      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
958      * to learn more about how these ids are created.
959      *
960      * This function call must use less than 30000 gas.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
963         // The interface IDs are constants representing the first 4 bytes
964         // of the XOR of all function selectors in the interface.
965         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
966         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
967         return
968             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
969             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
970             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
971     }
972 
973     // =============================================================
974     //                        IERC721Metadata
975     // =============================================================
976 
977     /**
978      * @dev Returns the token collection name.
979      */
980     function name() public view virtual override returns (string memory) {
981         return _name;
982     }
983 
984     /**
985      * @dev Returns the token collection symbol.
986      */
987     function symbol() public view virtual override returns (string memory) {
988         return _symbol;
989     }
990 
991     /**
992      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
993      */
994     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
995         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
996 
997         string memory baseURI = _baseURI();
998         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
999     }
1000 
1001     /**
1002      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1003      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1004      * by default, it can be overridden in child contracts.
1005      */
1006     function _baseURI() internal view virtual returns (string memory) {
1007         return '';
1008     }
1009 
1010     // =============================================================
1011     //                     OWNERSHIPS OPERATIONS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Returns the owner of the `tokenId` token.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must exist.
1020      */
1021     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1022         return address(uint160(_packedOwnershipOf(tokenId)));
1023     }
1024 
1025     /**
1026      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1027      * It gradually moves to O(1) as tokens get transferred around over time.
1028      */
1029     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1030         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1031     }
1032 
1033     /**
1034      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1035      */
1036     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1037         return _unpackedOwnership(_packedOwnerships[index]);
1038     }
1039 
1040     /**
1041      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1042      */
1043     function _initializeOwnershipAt(uint256 index) internal virtual {
1044         if (_packedOwnerships[index] == 0) {
1045             _packedOwnerships[index] = _packedOwnershipOf(index);
1046         }
1047     }
1048 
1049     /**
1050      * Returns the packed ownership data of `tokenId`.
1051      */
1052     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1053         uint256 curr = tokenId;
1054 
1055         unchecked {
1056             if (_startTokenId() <= curr)
1057                 if (curr < _currentIndex) {
1058                     uint256 packed = _packedOwnerships[curr];
1059                     // If not burned.
1060                     if (packed & _BITMASK_BURNED == 0) {
1061                         // Invariant:
1062                         // There will always be an initialized ownership slot
1063                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1064                         // before an unintialized ownership slot
1065                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1066                         // Hence, `curr` will not underflow.
1067                         //
1068                         // We can directly compare the packed value.
1069                         // If the address is zero, packed will be zero.
1070                         while (packed == 0) {
1071                             packed = _packedOwnerships[--curr];
1072                         }
1073                         return packed;
1074                     }
1075                 }
1076         }
1077         revert OwnerQueryForNonexistentToken();
1078     }
1079 
1080     /**
1081      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1082      */
1083     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1084         ownership.addr = address(uint160(packed));
1085         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1086         ownership.burned = packed & _BITMASK_BURNED != 0;
1087         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1088     }
1089 
1090     /**
1091      * @dev Packs ownership data into a single uint256.
1092      */
1093     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1094         assembly {
1095             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1096             owner := and(owner, _BITMASK_ADDRESS)
1097             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1098             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1099         }
1100     }
1101 
1102     /**
1103      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1104      */
1105     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1106         // For branchless setting of the `nextInitialized` flag.
1107         assembly {
1108             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1109             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1110         }
1111     }
1112 
1113     // =============================================================
1114     //                      APPROVAL OPERATIONS
1115     // =============================================================
1116 
1117     /**
1118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1119      * The approval is cleared when the token is transferred.
1120      *
1121      * Only a single account can be approved at a time, so approving the
1122      * zero address clears previous approvals.
1123      *
1124      * Requirements:
1125      *
1126      * - The caller must own the token or be an approved operator.
1127      * - `tokenId` must exist.
1128      *
1129      * Emits an {Approval} event.
1130      */
1131     function approve(address to, uint256 tokenId) public payable virtual override {
1132         address owner = ownerOf(tokenId);
1133 
1134         if (_msgSenderERC721A() != owner)
1135             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1136                 revert ApprovalCallerNotOwnerNorApproved();
1137             }
1138 
1139         _tokenApprovals[tokenId].value = to;
1140         emit Approval(owner, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Returns the account approved for `tokenId` token.
1145      *
1146      * Requirements:
1147      *
1148      * - `tokenId` must exist.
1149      */
1150     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1151         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1152 
1153         return _tokenApprovals[tokenId].value;
1154     }
1155 
1156     /**
1157      * @dev Approve or remove `operator` as an operator for the caller.
1158      * Operators can call {transferFrom} or {safeTransferFrom}
1159      * for any token owned by the caller.
1160      *
1161      * Requirements:
1162      *
1163      * - The `operator` cannot be the caller.
1164      *
1165      * Emits an {ApprovalForAll} event.
1166      */
1167     function setApprovalForAll(address operator, bool approved) public virtual override {
1168         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1169         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1170     }
1171 
1172     /**
1173      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1174      *
1175      * See {setApprovalForAll}.
1176      */
1177     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1178         return _operatorApprovals[owner][operator];
1179     }
1180 
1181     /**
1182      * @dev Returns whether `tokenId` exists.
1183      *
1184      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1185      *
1186      * Tokens start existing when they are minted. See {_mint}.
1187      */
1188     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1189         return
1190             _startTokenId() <= tokenId &&
1191             tokenId < _currentIndex && // If within bounds,
1192             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1193     }
1194 
1195     /**
1196      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1197      */
1198     function _isSenderApprovedOrOwner(
1199         address approvedAddress,
1200         address owner,
1201         address msgSender
1202     ) private pure returns (bool result) {
1203         assembly {
1204             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1205             owner := and(owner, _BITMASK_ADDRESS)
1206             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1207             msgSender := and(msgSender, _BITMASK_ADDRESS)
1208             // `msgSender == owner || msgSender == approvedAddress`.
1209             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1210         }
1211     }
1212 
1213     /**
1214      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1215      */
1216     function _getApprovedSlotAndAddress(uint256 tokenId)
1217         private
1218         view
1219         returns (uint256 approvedAddressSlot, address approvedAddress)
1220     {
1221         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1222         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1223         assembly {
1224             approvedAddressSlot := tokenApproval.slot
1225             approvedAddress := sload(approvedAddressSlot)
1226         }
1227     }
1228 
1229     // =============================================================
1230     //                      TRANSFER OPERATIONS
1231     // =============================================================
1232 
1233     /**
1234      * @dev Transfers `tokenId` from `from` to `to`.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must be owned by `from`.
1241      * - If the caller is not `from`, it must be approved to move this token
1242      * by either {approve} or {setApprovalForAll}.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function transferFrom(
1247         address from,
1248         address to,
1249         uint256 tokenId
1250     ) public payable virtual override {
1251         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1252 
1253         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1254 
1255         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1256 
1257         // The nested ifs save around 20+ gas over a compound boolean condition.
1258         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1259             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1260 
1261         if (to == address(0)) revert TransferToZeroAddress();
1262 
1263         _beforeTokenTransfers(from, to, tokenId, 1);
1264 
1265         // Clear approvals from the previous owner.
1266         assembly {
1267             if approvedAddress {
1268                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1269                 sstore(approvedAddressSlot, 0)
1270             }
1271         }
1272 
1273         // Underflow of the sender's balance is impossible because we check for
1274         // ownership above and the recipient's balance can't realistically overflow.
1275         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1276         unchecked {
1277             // We can directly increment and decrement the balances.
1278             --_packedAddressData[from]; // Updates: `balance -= 1`.
1279             ++_packedAddressData[to]; // Updates: `balance += 1`.
1280 
1281             // Updates:
1282             // - `address` to the next owner.
1283             // - `startTimestamp` to the timestamp of transfering.
1284             // - `burned` to `false`.
1285             // - `nextInitialized` to `true`.
1286             _packedOwnerships[tokenId] = _packOwnershipData(
1287                 to,
1288                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1289             );
1290 
1291             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1292             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1293                 uint256 nextTokenId = tokenId + 1;
1294                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1295                 if (_packedOwnerships[nextTokenId] == 0) {
1296                     // If the next slot is within bounds.
1297                     if (nextTokenId != _currentIndex) {
1298                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1299                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1300                     }
1301                 }
1302             }
1303         }
1304 
1305         emit Transfer(from, to, tokenId);
1306         _afterTokenTransfers(from, to, tokenId, 1);
1307     }
1308 
1309     /**
1310      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1311      */
1312     function safeTransferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public payable virtual override {
1317         safeTransferFrom(from, to, tokenId, '');
1318     }
1319 
1320     /**
1321      * @dev Safely transfers `tokenId` token from `from` to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `from` cannot be the zero address.
1326      * - `to` cannot be the zero address.
1327      * - `tokenId` token must exist and be owned by `from`.
1328      * - If the caller is not `from`, it must be approved to move this token
1329      * by either {approve} or {setApprovalForAll}.
1330      * - If `to` refers to a smart contract, it must implement
1331      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1332      *
1333      * Emits a {Transfer} event.
1334      */
1335     function safeTransferFrom(
1336         address from,
1337         address to,
1338         uint256 tokenId,
1339         bytes memory _data
1340     ) public payable virtual override {
1341         transferFrom(from, to, tokenId);
1342         if (to.code.length != 0)
1343             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1344                 revert TransferToNonERC721ReceiverImplementer();
1345             }
1346     }
1347 
1348     /**
1349      * @dev Hook that is called before a set of serially-ordered token IDs
1350      * are about to be transferred. This includes minting.
1351      * And also called before burning one token.
1352      *
1353      * `startTokenId` - the first token ID to be transferred.
1354      * `quantity` - the amount to be transferred.
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` will be minted for `to`.
1361      * - When `to` is zero, `tokenId` will be burned by `from`.
1362      * - `from` and `to` are never both zero.
1363      */
1364     function _beforeTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual {}
1370 
1371     /**
1372      * @dev Hook that is called after a set of serially-ordered token IDs
1373      * have been transferred. This includes minting.
1374      * And also called after one token has been burned.
1375      *
1376      * `startTokenId` - the first token ID to be transferred.
1377      * `quantity` - the amount to be transferred.
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` has been minted for `to`.
1384      * - When `to` is zero, `tokenId` has been burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _afterTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 
1394     /**
1395      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1396      *
1397      * `from` - Previous owner of the given token ID.
1398      * `to` - Target address that will receive the token.
1399      * `tokenId` - Token ID to be transferred.
1400      * `_data` - Optional data to send along with the call.
1401      *
1402      * Returns whether the call correctly returned the expected magic value.
1403      */
1404     function _checkContractOnERC721Received(
1405         address from,
1406         address to,
1407         uint256 tokenId,
1408         bytes memory _data
1409     ) private returns (bool) {
1410         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1411             bytes4 retval
1412         ) {
1413             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1414         } catch (bytes memory reason) {
1415             if (reason.length == 0) {
1416                 revert TransferToNonERC721ReceiverImplementer();
1417             } else {
1418                 assembly {
1419                     revert(add(32, reason), mload(reason))
1420                 }
1421             }
1422         }
1423     }
1424 
1425     // =============================================================
1426     //                        MINT OPERATIONS
1427     // =============================================================
1428 
1429     /**
1430      * @dev Mints `quantity` tokens and transfers them to `to`.
1431      *
1432      * Requirements:
1433      *
1434      * - `to` cannot be the zero address.
1435      * - `quantity` must be greater than 0.
1436      *
1437      * Emits a {Transfer} event for each mint.
1438      */
1439     function _mint(address to, uint256 quantity) internal virtual {
1440         uint256 startTokenId = _currentIndex;
1441         if (quantity == 0) revert MintZeroQuantity();
1442 
1443         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1444 
1445         // Overflows are incredibly unrealistic.
1446         // `balance` and `numberMinted` have a maximum limit of 2**64.
1447         // `tokenId` has a maximum limit of 2**256.
1448         unchecked {
1449             // Updates:
1450             // - `balance += quantity`.
1451             // - `numberMinted += quantity`.
1452             //
1453             // We can directly add to the `balance` and `numberMinted`.
1454             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1455 
1456             // Updates:
1457             // - `address` to the owner.
1458             // - `startTimestamp` to the timestamp of minting.
1459             // - `burned` to `false`.
1460             // - `nextInitialized` to `quantity == 1`.
1461             _packedOwnerships[startTokenId] = _packOwnershipData(
1462                 to,
1463                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1464             );
1465 
1466             uint256 toMasked;
1467             uint256 end = startTokenId + quantity;
1468 
1469             // Use assembly to loop and emit the `Transfer` event for gas savings.
1470             // The duplicated `log4` removes an extra check and reduces stack juggling.
1471             // The assembly, together with the surrounding Solidity code, have been
1472             // delicately arranged to nudge the compiler into producing optimized opcodes.
1473             assembly {
1474                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1475                 toMasked := and(to, _BITMASK_ADDRESS)
1476                 // Emit the `Transfer` event.
1477                 log4(
1478                     0, // Start of data (0, since no data).
1479                     0, // End of data (0, since no data).
1480                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1481                     0, // `address(0)`.
1482                     toMasked, // `to`.
1483                     startTokenId // `tokenId`.
1484                 )
1485 
1486                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1487                 // that overflows uint256 will make the loop run out of gas.
1488                 // The compiler will optimize the `iszero` away for performance.
1489                 for {
1490                     let tokenId := add(startTokenId, 1)
1491                 } iszero(eq(tokenId, end)) {
1492                     tokenId := add(tokenId, 1)
1493                 } {
1494                     // Emit the `Transfer` event. Similar to above.
1495                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1496                 }
1497             }
1498             if (toMasked == 0) revert MintToZeroAddress();
1499 
1500             _currentIndex = end;
1501         }
1502         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1503     }
1504 
1505     /**
1506      * @dev Mints `quantity` tokens and transfers them to `to`.
1507      *
1508      * This function is intended for efficient minting only during contract creation.
1509      *
1510      * It emits only one {ConsecutiveTransfer} as defined in
1511      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1512      * instead of a sequence of {Transfer} event(s).
1513      *
1514      * Calling this function outside of contract creation WILL make your contract
1515      * non-compliant with the ERC721 standard.
1516      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1517      * {ConsecutiveTransfer} event is only permissible during contract creation.
1518      *
1519      * Requirements:
1520      *
1521      * - `to` cannot be the zero address.
1522      * - `quantity` must be greater than 0.
1523      *
1524      * Emits a {ConsecutiveTransfer} event.
1525      */
1526     function _mintERC2309(address to, uint256 quantity) internal virtual {
1527         uint256 startTokenId = _currentIndex;
1528         if (to == address(0)) revert MintToZeroAddress();
1529         if (quantity == 0) revert MintZeroQuantity();
1530         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1531 
1532         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1533 
1534         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1535         unchecked {
1536             // Updates:
1537             // - `balance += quantity`.
1538             // - `numberMinted += quantity`.
1539             //
1540             // We can directly add to the `balance` and `numberMinted`.
1541             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1542 
1543             // Updates:
1544             // - `address` to the owner.
1545             // - `startTimestamp` to the timestamp of minting.
1546             // - `burned` to `false`.
1547             // - `nextInitialized` to `quantity == 1`.
1548             _packedOwnerships[startTokenId] = _packOwnershipData(
1549                 to,
1550                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1551             );
1552 
1553             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1554 
1555             _currentIndex = startTokenId + quantity;
1556         }
1557         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1558     }
1559 
1560     /**
1561      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1562      *
1563      * Requirements:
1564      *
1565      * - If `to` refers to a smart contract, it must implement
1566      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1567      * - `quantity` must be greater than 0.
1568      *
1569      * See {_mint}.
1570      *
1571      * Emits a {Transfer} event for each mint.
1572      */
1573     function _safeMint(
1574         address to,
1575         uint256 quantity,
1576         bytes memory _data
1577     ) internal virtual {
1578         _mint(to, quantity);
1579 
1580         unchecked {
1581             if (to.code.length != 0) {
1582                 uint256 end = _currentIndex;
1583                 uint256 index = end - quantity;
1584                 do {
1585                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1586                         revert TransferToNonERC721ReceiverImplementer();
1587                     }
1588                 } while (index < end);
1589                 // Reentrancy protection.
1590                 if (_currentIndex != end) revert();
1591             }
1592         }
1593     }
1594 
1595     /**
1596      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1597      */
1598     function _safeMint(address to, uint256 quantity) internal virtual {
1599         _safeMint(to, quantity, '');
1600     }
1601 
1602     // =============================================================
1603     //                        BURN OPERATIONS
1604     // =============================================================
1605 
1606     /**
1607      * @dev Equivalent to `_burn(tokenId, false)`.
1608      */
1609     function _burn(uint256 tokenId) internal virtual {
1610         _burn(tokenId, false);
1611     }
1612 
1613     /**
1614      * @dev Destroys `tokenId`.
1615      * The approval is cleared when the token is burned.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must exist.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1624         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1625 
1626         address from = address(uint160(prevOwnershipPacked));
1627 
1628         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1629 
1630         if (approvalCheck) {
1631             // The nested ifs save around 20+ gas over a compound boolean condition.
1632             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1633                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1634         }
1635 
1636         _beforeTokenTransfers(from, address(0), tokenId, 1);
1637 
1638         // Clear approvals from the previous owner.
1639         assembly {
1640             if approvedAddress {
1641                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1642                 sstore(approvedAddressSlot, 0)
1643             }
1644         }
1645 
1646         // Underflow of the sender's balance is impossible because we check for
1647         // ownership above and the recipient's balance can't realistically overflow.
1648         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1649         unchecked {
1650             // Updates:
1651             // - `balance -= 1`.
1652             // - `numberBurned += 1`.
1653             //
1654             // We can directly decrement the balance, and increment the number burned.
1655             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1656             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1657 
1658             // Updates:
1659             // - `address` to the last owner.
1660             // - `startTimestamp` to the timestamp of burning.
1661             // - `burned` to `true`.
1662             // - `nextInitialized` to `true`.
1663             _packedOwnerships[tokenId] = _packOwnershipData(
1664                 from,
1665                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1666             );
1667 
1668             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1669             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1670                 uint256 nextTokenId = tokenId + 1;
1671                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1672                 if (_packedOwnerships[nextTokenId] == 0) {
1673                     // If the next slot is within bounds.
1674                     if (nextTokenId != _currentIndex) {
1675                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1676                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1677                     }
1678                 }
1679             }
1680         }
1681 
1682         emit Transfer(from, address(0), tokenId);
1683         _afterTokenTransfers(from, address(0), tokenId, 1);
1684 
1685         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1686         unchecked {
1687             _burnCounter++;
1688         }
1689     }
1690 
1691     // =============================================================
1692     //                     EXTRA DATA OPERATIONS
1693     // =============================================================
1694 
1695     /**
1696      * @dev Directly sets the extra data for the ownership data `index`.
1697      */
1698     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1699         uint256 packed = _packedOwnerships[index];
1700         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1701         uint256 extraDataCasted;
1702         // Cast `extraData` with assembly to avoid redundant masking.
1703         assembly {
1704             extraDataCasted := extraData
1705         }
1706         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1707         _packedOwnerships[index] = packed;
1708     }
1709 
1710     /**
1711      * @dev Called during each token transfer to set the 24bit `extraData` field.
1712      * Intended to be overridden by the cosumer contract.
1713      *
1714      * `previousExtraData` - the value of `extraData` before transfer.
1715      *
1716      * Calling conditions:
1717      *
1718      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1719      * transferred to `to`.
1720      * - When `from` is zero, `tokenId` will be minted for `to`.
1721      * - When `to` is zero, `tokenId` will be burned by `from`.
1722      * - `from` and `to` are never both zero.
1723      */
1724     function _extraData(
1725         address from,
1726         address to,
1727         uint24 previousExtraData
1728     ) internal view virtual returns (uint24) {}
1729 
1730     /**
1731      * @dev Returns the next extra data for the packed ownership data.
1732      * The returned result is shifted into position.
1733      */
1734     function _nextExtraData(
1735         address from,
1736         address to,
1737         uint256 prevOwnershipPacked
1738     ) private view returns (uint256) {
1739         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1740         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1741     }
1742 
1743     // =============================================================
1744     //                       OTHER OPERATIONS
1745     // =============================================================
1746 
1747     /**
1748      * @dev Returns the message sender (defaults to `msg.sender`).
1749      *
1750      * If you are writing GSN compatible contracts, you need to override this function.
1751      */
1752     function _msgSenderERC721A() internal view virtual returns (address) {
1753         return msg.sender;
1754     }
1755 
1756     /**
1757      * @dev Converts a uint256 to its ASCII string decimal representation.
1758      */
1759     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1760         assembly {
1761             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1762             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1763             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1764             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1765             let m := add(mload(0x40), 0xa0)
1766             // Update the free memory pointer to allocate.
1767             mstore(0x40, m)
1768             // Assign the `str` to the end.
1769             str := sub(m, 0x20)
1770             // Zeroize the slot after the string.
1771             mstore(str, 0)
1772 
1773             // Cache the end of the memory to calculate the length later.
1774             let end := str
1775 
1776             // We write the string from rightmost digit to leftmost digit.
1777             // The following is essentially a do-while loop that also handles the zero case.
1778             // prettier-ignore
1779             for { let temp := value } 1 {} {
1780                 str := sub(str, 1)
1781                 // Write the character to the pointer.
1782                 // The ASCII index of the '0' character is 48.
1783                 mstore8(str, add(48, mod(temp, 10)))
1784                 // Keep dividing `temp` until zero.
1785                 temp := div(temp, 10)
1786                 // prettier-ignore
1787                 if iszero(temp) { break }
1788             }
1789 
1790             let length := sub(end, str)
1791             // Move the pointer 32 bytes leftwards to make room for the length.
1792             str := sub(str, 0x20)
1793             // Store the length.
1794             mstore(str, length)
1795         }
1796     }
1797 }
1798 // File: @openzeppelin/contracts/utils/Context.sol
1799 
1800 
1801 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1802 
1803 pragma solidity ^0.8.0;
1804 
1805 /**
1806  * @dev Provides information about the current execution context, including the
1807  * sender of the transaction and its data. While these are generally available
1808  * via msg.sender and msg.data, they should not be accessed in such a direct
1809  * manner, since when dealing with meta-transactions the account sending and
1810  * paying for execution may not be the actual sender (as far as an application
1811  * is concerned).
1812  *
1813  * This contract is only required for intermediate, library-like contracts.
1814  */
1815 abstract contract Context {
1816     function _msgSender() internal view virtual returns (address) {
1817         return msg.sender;
1818     }
1819 
1820     function _msgData() internal view virtual returns (bytes calldata) {
1821         return msg.data;
1822     }
1823 }
1824 
1825 // File: @openzeppelin/contracts/access/Ownable.sol
1826 
1827 
1828 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1829 
1830 pragma solidity ^0.8.0;
1831 
1832 
1833 /**
1834  * @dev Contract module which provides a basic access control mechanism, where
1835  * there is an account (an owner) that can be granted exclusive access to
1836  * specific functions.
1837  *
1838  * By default, the owner account will be the one that deploys the contract. This
1839  * can later be changed with {transferOwnership}.
1840  *
1841  * This module is used through inheritance. It will make available the modifier
1842  * `onlyOwner`, which can be applied to your functions to restrict their use to
1843  * the owner.
1844  */
1845 abstract contract Ownable is Context {
1846     address private _owner;
1847 
1848     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1849 
1850     /**
1851      * @dev Initializes the contract setting the deployer as the initial owner.
1852      */
1853     constructor() {
1854         _transferOwnership(_msgSender());
1855     }
1856 
1857     /**
1858      * @dev Throws if called by any account other than the owner.
1859      */
1860     modifier onlyOwner() {
1861         _checkOwner();
1862         _;
1863     }
1864 
1865     /**
1866      * @dev Returns the address of the current owner.
1867      */
1868     function owner() public view virtual returns (address) {
1869         return _owner;
1870     }
1871 
1872     /**
1873      * @dev Throws if the sender is not the owner.
1874      */
1875     function _checkOwner() internal view virtual {
1876         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1877     }
1878 
1879     /**
1880      * @dev Leaves the contract without owner. It will not be possible to call
1881      * `onlyOwner` functions anymore. Can only be called by the current owner.
1882      *
1883      * NOTE: Renouncing ownership will leave the contract without an owner,
1884      * thereby removing any functionality that is only available to the owner.
1885      */
1886     function renounceOwnership() public virtual onlyOwner {
1887         _transferOwnership(address(0));
1888     }
1889 
1890     /**
1891      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1892      * Can only be called by the current owner.
1893      */
1894     function transferOwnership(address newOwner) public virtual onlyOwner {
1895         require(newOwner != address(0), "Ownable: new owner is the zero address");
1896         _transferOwnership(newOwner);
1897     }
1898 
1899     /**
1900      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1901      * Internal function without access restriction.
1902      */
1903     function _transferOwnership(address newOwner) internal virtual {
1904         address oldOwner = _owner;
1905         _owner = newOwner;
1906         emit OwnershipTransferred(oldOwner, newOwner);
1907     }
1908 }
1909 
1910 // File: contracts/UglyFacesNFT.sol
1911 
1912 
1913 pragma solidity ^0.8.12;
1914 
1915 
1916 
1917 
1918 
1919 
1920 interface UglyFacesMetadataManager {
1921     function tokenURI(uint256 tokenId) external view returns (string memory);
1922 }
1923 
1924 contract UglyFacesNFT is ERC721A("Ugly Faces", "UGFA"), Ownable, DefaultOperatorFilterer {
1925     uint256 public maxSupply = 3000;
1926     
1927     bool public saleStarted;
1928     bytes32 public merkleRoot;
1929 
1930     mapping(uint256 => bytes32) public tokenDNA;
1931     mapping(uint256 => bytes) public pausedTokenGenes;
1932 
1933     UglyFacesMetadataManager metadataManager = UglyFacesMetadataManager(0xe2e6bE06f968BE0d6D6967e5d64505E70889a1C2); 
1934 
1935     function setSaleStarted(bool _saleStarted) external onlyOwner {
1936         saleStarted = _saleStarted;
1937     }
1938 
1939     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1940         require(_maxSupply < maxSupply, "Can't increase max supply");
1941         require(totalSupply() <= _maxSupply, "Can't decrease max supply below current supply");
1942         maxSupply = _maxSupply;
1943     }
1944 
1945     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1946         merkleRoot = _merkleRoot;
1947     }
1948 
1949     function setMetadataManager(address _metadataManager) external onlyOwner {
1950         metadataManager = UglyFacesMetadataManager(_metadataManager);
1951     }
1952 
1953     function isWhitelisted(address user, uint256 amount, bytes32[] calldata _merkleProof) public view returns (bool) {
1954         bytes32 leaf = keccak256(abi.encodePacked(user, amount));
1955         return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1956     }
1957 
1958     function getTokenGenes(uint256 tokenId) public view returns (bytes memory) {
1959         if (pausedTokenGenes[tokenId].length == 0) {
1960             return abi.encodePacked(tokenDNA[tokenId], (block.timestamp + 25200)/86400);
1961         } else {
1962             return pausedTokenGenes[tokenId];
1963         }
1964     }
1965 
1966     function isPaused(uint256 tokenId) public view returns (bool) {
1967         return pausedTokenGenes[tokenId].length != 0;
1968     }
1969 
1970     function pauseDNAGeneration(uint256 tokenId) external {
1971         require(ownerOf(tokenId) == msg.sender, "Only the token owner can pause token DNA");
1972         require(pausedTokenGenes[tokenId].length == 0, "Token DNA is already paused");
1973         pausedTokenGenes[tokenId] = abi.encodePacked(tokenDNA[tokenId], (block.timestamp + 25200)/86400);
1974     }
1975 
1976     function unpauseDNAGeneration(uint256 tokenId) external {
1977         require(ownerOf(tokenId) == msg.sender, "Only the token owner can unpause token DNA");
1978         require(pausedTokenGenes[tokenId].length > 0, "Token DNA is already unpaused");
1979         delete pausedTokenGenes[tokenId];
1980     }
1981 
1982     function mint(uint256 amount, uint256 maxAmount, bytes32[] calldata _merkleProof) external {
1983         require(saleStarted, "Sale has not started yet");
1984         require(_totalMinted() + amount <= maxSupply, "Max Supply Exceeded");
1985         require(isWhitelisted(msg.sender, maxAmount, _merkleProof), "Address not whitelisted");
1986         require(_numberMinted(msg.sender) + amount <= maxAmount, "Address cannot mint more tokens");
1987         unchecked {
1988             uint256 startToken = _nextTokenId();
1989             for (uint256 i = 0; i < amount; i++) {
1990                 tokenDNA[startToken + i] = keccak256(abi.encodePacked(msg.sender, startToken + i));
1991             }
1992         }
1993         _safeMint(msg.sender, amount);
1994     }
1995 
1996     function numberMinted(address user) public view returns (uint256) {
1997         return _numberMinted(user);
1998     } 
1999 
2000     function adminMint(address to, uint256 amount) external onlyOwner {
2001         require(_totalMinted() + amount <= maxSupply, "Max Supply Exceeded");
2002         //require(amount <= 30, "Max mint per transaction exceeded");
2003         unchecked {
2004             uint256 startToken = _nextTokenId();
2005             for (uint256 i = 0; i < amount; i++) {
2006                 tokenDNA[startToken + i] = keccak256(abi.encodePacked(msg.sender, startToken + i));
2007             }
2008         }
2009         _safeMint(to, amount);
2010     }
2011 
2012     function rescueFunds(address to) external onlyOwner {
2013         uint256 balance = address(this).balance;
2014         (bool callSuccess, ) = payable(to).call{value: balance}("");
2015         require(callSuccess, "Call failed");
2016     }
2017 
2018     function rescueToken(address token) external onlyOwner {
2019         IERC20 tokenContract = IERC20(token);
2020         uint256 balance = tokenContract.balanceOf(address(this));
2021         tokenContract.transfer(msg.sender, balance);
2022     }
2023 
2024     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2025         return metadataManager.tokenURI(tokenId);
2026     }
2027 
2028     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2029         super.setApprovalForAll(operator, approved);
2030     }
2031 
2032     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2033         super.approve(operator, tokenId);
2034     }
2035 
2036     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2037         super.transferFrom(from, to, tokenId);
2038     }
2039 
2040     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2041         super.safeTransferFrom(from, to, tokenId);
2042     }
2043 
2044     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2045         public
2046         payable
2047         override
2048         onlyAllowedOperator(from)
2049     {
2050         super.safeTransferFrom(from, to, tokenId, data);
2051     }
2052 }