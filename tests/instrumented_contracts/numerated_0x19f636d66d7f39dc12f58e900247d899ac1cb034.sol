1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.0
117 
118 
119 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev These functions deal with verification of Merkle Tree proofs.
125  *
126  * The tree and the proofs can be generated using our
127  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
128  * You will find a quickstart guide in the readme.
129  *
130  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
131  * hashing, or use a hash function other than keccak256 for hashing leaves.
132  * This is because the concatenation of a sorted pair of internal nodes in
133  * the merkle tree could be reinterpreted as a leaf value.
134  * OpenZeppelin's JavaScript library generates merkle trees that are safe
135  * against this attack out of the box.
136  */
137 library MerkleProof {
138     /**
139      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
140      * defined by `root`. For this, a `proof` must be provided, containing
141      * sibling hashes on the branch from the leaf to the root of the tree. Each
142      * pair of leaves and each pair of pre-images are assumed to be sorted.
143      */
144     function verify(
145         bytes32[] memory proof,
146         bytes32 root,
147         bytes32 leaf
148     ) internal pure returns (bool) {
149         return processProof(proof, leaf) == root;
150     }
151 
152     /**
153      * @dev Calldata version of {verify}
154      *
155      * _Available since v4.7._
156      */
157     function verifyCalldata(
158         bytes32[] calldata proof,
159         bytes32 root,
160         bytes32 leaf
161     ) internal pure returns (bool) {
162         return processProofCalldata(proof, leaf) == root;
163     }
164 
165     /**
166      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
167      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
168      * hash matches the root of the tree. When processing the proof, the pairs
169      * of leafs & pre-images are assumed to be sorted.
170      *
171      * _Available since v4.4._
172      */
173     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
174         bytes32 computedHash = leaf;
175         for (uint256 i = 0; i < proof.length; i++) {
176             computedHash = _hashPair(computedHash, proof[i]);
177         }
178         return computedHash;
179     }
180 
181     /**
182      * @dev Calldata version of {processProof}
183      *
184      * _Available since v4.7._
185      */
186     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
187         bytes32 computedHash = leaf;
188         for (uint256 i = 0; i < proof.length; i++) {
189             computedHash = _hashPair(computedHash, proof[i]);
190         }
191         return computedHash;
192     }
193 
194     /**
195      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
196      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
197      *
198      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
199      *
200      * _Available since v4.7._
201      */
202     function multiProofVerify(
203         bytes32[] memory proof,
204         bool[] memory proofFlags,
205         bytes32 root,
206         bytes32[] memory leaves
207     ) internal pure returns (bool) {
208         return processMultiProof(proof, proofFlags, leaves) == root;
209     }
210 
211     /**
212      * @dev Calldata version of {multiProofVerify}
213      *
214      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
215      *
216      * _Available since v4.7._
217      */
218     function multiProofVerifyCalldata(
219         bytes32[] calldata proof,
220         bool[] calldata proofFlags,
221         bytes32 root,
222         bytes32[] memory leaves
223     ) internal pure returns (bool) {
224         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
225     }
226 
227     /**
228      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
229      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
230      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
231      * respectively.
232      *
233      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
234      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
235      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
236      *
237      * _Available since v4.7._
238      */
239     function processMultiProof(
240         bytes32[] memory proof,
241         bool[] memory proofFlags,
242         bytes32[] memory leaves
243     ) internal pure returns (bytes32 merkleRoot) {
244         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
245         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
246         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
247         // the merkle tree.
248         uint256 leavesLen = leaves.length;
249         uint256 totalHashes = proofFlags.length;
250 
251         // Check proof validity.
252         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
253 
254         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
255         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
256         bytes32[] memory hashes = new bytes32[](totalHashes);
257         uint256 leafPos = 0;
258         uint256 hashPos = 0;
259         uint256 proofPos = 0;
260         // At each step, we compute the next hash using two values:
261         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
262         //   get the next hash.
263         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
264         //   `proof` array.
265         for (uint256 i = 0; i < totalHashes; i++) {
266             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
267             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
268             hashes[i] = _hashPair(a, b);
269         }
270 
271         if (totalHashes > 0) {
272             return hashes[totalHashes - 1];
273         } else if (leavesLen > 0) {
274             return leaves[0];
275         } else {
276             return proof[0];
277         }
278     }
279 
280     /**
281      * @dev Calldata version of {processMultiProof}.
282      *
283      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
284      *
285      * _Available since v4.7._
286      */
287     function processMultiProofCalldata(
288         bytes32[] calldata proof,
289         bool[] calldata proofFlags,
290         bytes32[] memory leaves
291     ) internal pure returns (bytes32 merkleRoot) {
292         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
293         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
294         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
295         // the merkle tree.
296         uint256 leavesLen = leaves.length;
297         uint256 totalHashes = proofFlags.length;
298 
299         // Check proof validity.
300         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
301 
302         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
303         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
304         bytes32[] memory hashes = new bytes32[](totalHashes);
305         uint256 leafPos = 0;
306         uint256 hashPos = 0;
307         uint256 proofPos = 0;
308         // At each step, we compute the next hash using two values:
309         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
310         //   get the next hash.
311         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
312         //   `proof` array.
313         for (uint256 i = 0; i < totalHashes; i++) {
314             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
315             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
316             hashes[i] = _hashPair(a, b);
317         }
318 
319         if (totalHashes > 0) {
320             return hashes[totalHashes - 1];
321         } else if (leavesLen > 0) {
322             return leaves[0];
323         } else {
324             return proof[0];
325         }
326     }
327 
328     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
329         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
330     }
331 
332     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
333         /// @solidity memory-safe-assembly
334         assembly {
335             mstore(0x00, a)
336             mstore(0x20, b)
337             value := keccak256(0x00, 0x40)
338         }
339     }
340 }
341 
342 
343 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
344 
345 
346 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Contract module that helps prevent reentrant calls to a function.
352  *
353  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
354  * available, which can be applied to functions to make sure there are no nested
355  * (reentrant) calls to them.
356  *
357  * Note that because there is a single `nonReentrant` guard, functions marked as
358  * `nonReentrant` may not call one another. This can be worked around by making
359  * those functions `private`, and then adding `external` `nonReentrant` entry
360  * points to them.
361  *
362  * TIP: If you would like to learn more about reentrancy and alternative ways
363  * to protect against it, check out our blog post
364  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
365  */
366 abstract contract ReentrancyGuard {
367     // Booleans are more expensive than uint256 or any type that takes up a full
368     // word because each write operation emits an extra SLOAD to first read the
369     // slot's contents, replace the bits taken up by the boolean, and then write
370     // back. This is the compiler's defense against contract upgrades and
371     // pointer aliasing, and it cannot be disabled.
372 
373     // The values being non-zero value makes deployment a bit more expensive,
374     // but in exchange the refund on every call to nonReentrant will be lower in
375     // amount. Since refunds are capped to a percentage of the total
376     // transaction's gas, it is best to keep them low in cases like this one, to
377     // increase the likelihood of the full refund coming into effect.
378     uint256 private constant _NOT_ENTERED = 1;
379     uint256 private constant _ENTERED = 2;
380 
381     uint256 private _status;
382 
383     constructor() {
384         _status = _NOT_ENTERED;
385     }
386 
387     /**
388      * @dev Prevents a contract from calling itself, directly or indirectly.
389      * Calling a `nonReentrant` function from another `nonReentrant`
390      * function is not supported. It is possible to prevent this from happening
391      * by making the `nonReentrant` function external, and making it call a
392      * `private` function that does the actual work.
393      */
394     modifier nonReentrant() {
395         _nonReentrantBefore();
396         _;
397         _nonReentrantAfter();
398     }
399 
400     function _nonReentrantBefore() private {
401         // On the first call to nonReentrant, _status will be _NOT_ENTERED
402         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
403 
404         // Any calls to nonReentrant after this point will fail
405         _status = _ENTERED;
406     }
407 
408     function _nonReentrantAfter() private {
409         // By storing the original value once again, a refund is triggered (see
410         // https://eips.ethereum.org/EIPS/eip-2200)
411         _status = _NOT_ENTERED;
412     }
413 }
414 
415 
416 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.3.1
417 
418 
419 pragma solidity ^0.8.13;
420 
421 interface IOperatorFilterRegistry {
422     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
423     function register(address registrant) external;
424     function registerAndSubscribe(address registrant, address subscription) external;
425     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
426     function unregister(address addr) external;
427     function updateOperator(address registrant, address operator, bool filtered) external;
428     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
429     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
430     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
431     function subscribe(address registrant, address registrantToSubscribe) external;
432     function unsubscribe(address registrant, bool copyExistingEntries) external;
433     function subscriptionOf(address addr) external returns (address registrant);
434     function subscribers(address registrant) external returns (address[] memory);
435     function subscriberAt(address registrant, uint256 index) external returns (address);
436     function copyEntriesOf(address registrant, address registrantToCopy) external;
437     function isOperatorFiltered(address registrant, address operator) external returns (bool);
438     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
439     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
440     function filteredOperators(address addr) external returns (address[] memory);
441     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
442     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
443     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
444     function isRegistered(address addr) external returns (bool);
445     function codeHashOf(address addr) external returns (bytes32);
446 }
447 
448 
449 // File operator-filter-registry/src/OperatorFilterer.sol@v1.3.1
450 
451 
452 pragma solidity ^0.8.13;
453 
454 /**
455  * @title  OperatorFilterer
456  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
457  *         registrant's entries in the OperatorFilterRegistry.
458  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
459  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
460  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
461  */
462 abstract contract OperatorFilterer {
463     error OperatorNotAllowed(address operator);
464 
465     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
466         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
467 
468     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
469         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
470         // will not revert, but the contract will need to be registered with the registry once it is deployed in
471         // order for the modifier to filter addresses.
472         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
473             if (subscribe) {
474                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
475             } else {
476                 if (subscriptionOrRegistrantToCopy != address(0)) {
477                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
478                 } else {
479                     OPERATOR_FILTER_REGISTRY.register(address(this));
480                 }
481             }
482         }
483     }
484 
485     modifier onlyAllowedOperator(address from) virtual {
486         // Allow spending tokens from addresses with balance
487         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
488         // from an EOA.
489         if (from != msg.sender) {
490             _checkFilterOperator(msg.sender);
491         }
492         _;
493     }
494 
495     modifier onlyAllowedOperatorApproval(address operator) virtual {
496         _checkFilterOperator(operator);
497         _;
498     }
499 
500     function _checkFilterOperator(address operator) internal view virtual {
501         // Check registry code length to facilitate testing in environments without a deployed registry.
502         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
503             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
504                 revert OperatorNotAllowed(operator);
505             }
506         }
507     }
508 }
509 
510 
511 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.3.1
512 
513 
514 pragma solidity ^0.8.13;
515 
516 /**
517  * @title  DefaultOperatorFilterer
518  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
519  */
520 abstract contract DefaultOperatorFilterer is OperatorFilterer {
521     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
522 
523     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
524 }
525 
526 
527 // File contracts/interface/ILucky.sol
528 
529 
530 pragma solidity ^0.8.0;
531 
532 // ILucky
533 interface ILucky {
534     function superMint(address to, uint quantity) external;
535 }
536 
537 interface ILuckyEx {
538     function totalSupply() external view returns(uint);
539     function superMint(address to, uint quantity) external;
540 }
541 
542 
543 // File contracts/interface/IStakingPool.sol
544 
545 
546 pragma solidity ^0.8.0;
547 
548 interface IStakingPool {
549     function pined(uint256 tokenId) external view returns (bool);
550 }
551 
552 
553 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Interface of the ERC165 standard, as defined in the
562  * https://eips.ethereum.org/EIPS/eip-165[EIP].
563  *
564  * Implementers can declare support of contract interfaces, which can then be
565  * queried by others ({ERC165Checker}).
566  *
567  * For an implementation, see {ERC165}.
568  */
569 interface IERC165 {
570     /**
571      * @dev Returns true if this contract implements the interface defined by
572      * `interfaceId`. See the corresponding
573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
574      * to learn more about how these ids are created.
575      *
576      * This function call must use less than 30 000 gas.
577      */
578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
579 }
580 
581 
582 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
583 
584 
585 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Required interface of an ERC721 compliant contract.
591  */
592 interface IERC721 is IERC165 {
593     /**
594      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
595      */
596     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
597 
598     /**
599      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
600      */
601     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
602 
603     /**
604      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
605      */
606     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
607 
608     /**
609      * @dev Returns the number of tokens in ``owner``'s account.
610      */
611     function balanceOf(address owner) external view returns (uint256 balance);
612 
613     /**
614      * @dev Returns the owner of the `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function ownerOf(uint256 tokenId) external view returns (address owner);
621 
622     /**
623      * @dev Safely transfers `tokenId` token from `from` to `to`.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must exist and be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
632      *
633      * Emits a {Transfer} event.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId,
639         bytes calldata data
640     ) external;
641 
642     /**
643      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
644      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must exist and be owned by `from`.
651      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
653      *
654      * Emits a {Transfer} event.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 tokenId
660     ) external;
661 
662     /**
663      * @dev Transfers `tokenId` token from `from` to `to`.
664      *
665      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
666      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
667      * understand this adds an external call which potentially creates a reentrancy vulnerability.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      *
676      * Emits a {Transfer} event.
677      */
678     function transferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
686      * The approval is cleared when the token is transferred.
687      *
688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
689      *
690      * Requirements:
691      *
692      * - The caller must own the token or be an approved operator.
693      * - `tokenId` must exist.
694      *
695      * Emits an {Approval} event.
696      */
697     function approve(address to, uint256 tokenId) external;
698 
699     /**
700      * @dev Approve or remove `operator` as an operator for the caller.
701      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
702      *
703      * Requirements:
704      *
705      * - The `operator` cannot be the caller.
706      *
707      * Emits an {ApprovalForAll} event.
708      */
709     function setApprovalForAll(address operator, bool _approved) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
722      *
723      * See {setApprovalForAll}
724      */
725     function isApprovedForAll(address owner, address operator) external view returns (bool);
726 }
727 
728 
729 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.0
730 
731 
732 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 /**
737  * @title ERC721 token receiver interface
738  * @dev Interface for any contract that wants to support safeTransfers
739  * from ERC721 asset contracts.
740  */
741 interface IERC721Receiver {
742     /**
743      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
744      * by `operator` from `from`, this function is called.
745      *
746      * It must return its Solidity selector to confirm the token transfer.
747      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
748      *
749      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
750      */
751     function onERC721Received(
752         address operator,
753         address from,
754         uint256 tokenId,
755         bytes calldata data
756     ) external returns (bytes4);
757 }
758 
759 
760 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.8.0
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 interface IERC721Metadata is IERC721 {
772     /**
773      * @dev Returns the token collection name.
774      */
775     function name() external view returns (string memory);
776 
777     /**
778      * @dev Returns the token collection symbol.
779      */
780     function symbol() external view returns (string memory);
781 
782     /**
783      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
784      */
785     function tokenURI(uint256 tokenId) external view returns (string memory);
786 }
787 
788 
789 // File @openzeppelin/contracts/utils/Address.sol@v4.8.0
790 
791 
792 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
793 
794 pragma solidity ^0.8.1;
795 
796 /**
797  * @dev Collection of functions related to the address type
798  */
799 library Address {
800     /**
801      * @dev Returns true if `account` is a contract.
802      *
803      * [IMPORTANT]
804      * ====
805      * It is unsafe to assume that an address for which this function returns
806      * false is an externally-owned account (EOA) and not a contract.
807      *
808      * Among others, `isContract` will return false for the following
809      * types of addresses:
810      *
811      *  - an externally-owned account
812      *  - a contract in construction
813      *  - an address where a contract will be created
814      *  - an address where a contract lived, but was destroyed
815      * ====
816      *
817      * [IMPORTANT]
818      * ====
819      * You shouldn't rely on `isContract` to protect against flash loan attacks!
820      *
821      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
822      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
823      * constructor.
824      * ====
825      */
826     function isContract(address account) internal view returns (bool) {
827         // This method relies on extcodesize/address.code.length, which returns 0
828         // for contracts in construction, since the code is only stored at the end
829         // of the constructor execution.
830 
831         return account.code.length > 0;
832     }
833 
834     /**
835      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
836      * `recipient`, forwarding all available gas and reverting on errors.
837      *
838      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
839      * of certain opcodes, possibly making contracts go over the 2300 gas limit
840      * imposed by `transfer`, making them unable to receive funds via
841      * `transfer`. {sendValue} removes this limitation.
842      *
843      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
844      *
845      * IMPORTANT: because control is transferred to `recipient`, care must be
846      * taken to not create reentrancy vulnerabilities. Consider using
847      * {ReentrancyGuard} or the
848      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
849      */
850     function sendValue(address payable recipient, uint256 amount) internal {
851         require(address(this).balance >= amount, "Address: insufficient balance");
852 
853         (bool success, ) = recipient.call{value: amount}("");
854         require(success, "Address: unable to send value, recipient may have reverted");
855     }
856 
857     /**
858      * @dev Performs a Solidity function call using a low level `call`. A
859      * plain `call` is an unsafe replacement for a function call: use this
860      * function instead.
861      *
862      * If `target` reverts with a revert reason, it is bubbled up by this
863      * function (like regular Solidity function calls).
864      *
865      * Returns the raw returned data. To convert to the expected return value,
866      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
867      *
868      * Requirements:
869      *
870      * - `target` must be a contract.
871      * - calling `target` with `data` must not revert.
872      *
873      * _Available since v3.1._
874      */
875     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
876         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
877     }
878 
879     /**
880      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
881      * `errorMessage` as a fallback revert reason when `target` reverts.
882      *
883      * _Available since v3.1._
884      */
885     function functionCall(
886         address target,
887         bytes memory data,
888         string memory errorMessage
889     ) internal returns (bytes memory) {
890         return functionCallWithValue(target, data, 0, errorMessage);
891     }
892 
893     /**
894      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
895      * but also transferring `value` wei to `target`.
896      *
897      * Requirements:
898      *
899      * - the calling contract must have an ETH balance of at least `value`.
900      * - the called Solidity function must be `payable`.
901      *
902      * _Available since v3.1._
903      */
904     function functionCallWithValue(
905         address target,
906         bytes memory data,
907         uint256 value
908     ) internal returns (bytes memory) {
909         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
910     }
911 
912     /**
913      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
914      * with `errorMessage` as a fallback revert reason when `target` reverts.
915      *
916      * _Available since v3.1._
917      */
918     function functionCallWithValue(
919         address target,
920         bytes memory data,
921         uint256 value,
922         string memory errorMessage
923     ) internal returns (bytes memory) {
924         require(address(this).balance >= value, "Address: insufficient balance for call");
925         (bool success, bytes memory returndata) = target.call{value: value}(data);
926         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
931      * but performing a static call.
932      *
933      * _Available since v3.3._
934      */
935     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
936         return functionStaticCall(target, data, "Address: low-level static call failed");
937     }
938 
939     /**
940      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
941      * but performing a static call.
942      *
943      * _Available since v3.3._
944      */
945     function functionStaticCall(
946         address target,
947         bytes memory data,
948         string memory errorMessage
949     ) internal view returns (bytes memory) {
950         (bool success, bytes memory returndata) = target.staticcall(data);
951         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
952     }
953 
954     /**
955      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
956      * but performing a delegate call.
957      *
958      * _Available since v3.4._
959      */
960     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
961         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
962     }
963 
964     /**
965      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
966      * but performing a delegate call.
967      *
968      * _Available since v3.4._
969      */
970     function functionDelegateCall(
971         address target,
972         bytes memory data,
973         string memory errorMessage
974     ) internal returns (bytes memory) {
975         (bool success, bytes memory returndata) = target.delegatecall(data);
976         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
977     }
978 
979     /**
980      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
981      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
982      *
983      * _Available since v4.8._
984      */
985     function verifyCallResultFromTarget(
986         address target,
987         bool success,
988         bytes memory returndata,
989         string memory errorMessage
990     ) internal view returns (bytes memory) {
991         if (success) {
992             if (returndata.length == 0) {
993                 // only check isContract if the call was successful and the return data is empty
994                 // otherwise we already know that it was a contract
995                 require(isContract(target), "Address: call to non-contract");
996             }
997             return returndata;
998         } else {
999             _revert(returndata, errorMessage);
1000         }
1001     }
1002 
1003     /**
1004      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1005      * revert reason or using the provided one.
1006      *
1007      * _Available since v4.3._
1008      */
1009     function verifyCallResult(
1010         bool success,
1011         bytes memory returndata,
1012         string memory errorMessage
1013     ) internal pure returns (bytes memory) {
1014         if (success) {
1015             return returndata;
1016         } else {
1017             _revert(returndata, errorMessage);
1018         }
1019     }
1020 
1021     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1022         // Look for revert reason and bubble it up if present
1023         if (returndata.length > 0) {
1024             // The easiest way to bubble the revert reason is using memory via assembly
1025             /// @solidity memory-safe-assembly
1026             assembly {
1027                 let returndata_size := mload(returndata)
1028                 revert(add(32, returndata), returndata_size)
1029             }
1030         } else {
1031             revert(errorMessage);
1032         }
1033     }
1034 }
1035 
1036 
1037 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
1038 
1039 
1040 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 /**
1045  * @dev Standard math utilities missing in the Solidity language.
1046  */
1047 library Math {
1048     enum Rounding {
1049         Down, // Toward negative infinity
1050         Up, // Toward infinity
1051         Zero // Toward zero
1052     }
1053 
1054     /**
1055      * @dev Returns the largest of two numbers.
1056      */
1057     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1058         return a > b ? a : b;
1059     }
1060 
1061     /**
1062      * @dev Returns the smallest of two numbers.
1063      */
1064     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1065         return a < b ? a : b;
1066     }
1067 
1068     /**
1069      * @dev Returns the average of two numbers. The result is rounded towards
1070      * zero.
1071      */
1072     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1073         // (a + b) / 2 can overflow.
1074         return (a & b) + (a ^ b) / 2;
1075     }
1076 
1077     /**
1078      * @dev Returns the ceiling of the division of two numbers.
1079      *
1080      * This differs from standard division with `/` in that it rounds up instead
1081      * of rounding down.
1082      */
1083     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1084         // (a + b - 1) / b can overflow on addition, so we distribute.
1085         return a == 0 ? 0 : (a - 1) / b + 1;
1086     }
1087 
1088     /**
1089      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1090      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1091      * with further edits by Uniswap Labs also under MIT license.
1092      */
1093     function mulDiv(
1094         uint256 x,
1095         uint256 y,
1096         uint256 denominator
1097     ) internal pure returns (uint256 result) {
1098         unchecked {
1099             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1100             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1101             // variables such that product = prod1 * 2^256 + prod0.
1102             uint256 prod0; // Least significant 256 bits of the product
1103             uint256 prod1; // Most significant 256 bits of the product
1104             assembly {
1105                 let mm := mulmod(x, y, not(0))
1106                 prod0 := mul(x, y)
1107                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1108             }
1109 
1110             // Handle non-overflow cases, 256 by 256 division.
1111             if (prod1 == 0) {
1112                 return prod0 / denominator;
1113             }
1114 
1115             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1116             require(denominator > prod1);
1117 
1118             ///////////////////////////////////////////////
1119             // 512 by 256 division.
1120             ///////////////////////////////////////////////
1121 
1122             // Make division exact by subtracting the remainder from [prod1 prod0].
1123             uint256 remainder;
1124             assembly {
1125                 // Compute remainder using mulmod.
1126                 remainder := mulmod(x, y, denominator)
1127 
1128                 // Subtract 256 bit number from 512 bit number.
1129                 prod1 := sub(prod1, gt(remainder, prod0))
1130                 prod0 := sub(prod0, remainder)
1131             }
1132 
1133             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1134             // See https://cs.stackexchange.com/q/138556/92363.
1135 
1136             // Does not overflow because the denominator cannot be zero at this stage in the function.
1137             uint256 twos = denominator & (~denominator + 1);
1138             assembly {
1139                 // Divide denominator by twos.
1140                 denominator := div(denominator, twos)
1141 
1142                 // Divide [prod1 prod0] by twos.
1143                 prod0 := div(prod0, twos)
1144 
1145                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1146                 twos := add(div(sub(0, twos), twos), 1)
1147             }
1148 
1149             // Shift in bits from prod1 into prod0.
1150             prod0 |= prod1 * twos;
1151 
1152             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1153             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1154             // four bits. That is, denominator * inv = 1 mod 2^4.
1155             uint256 inverse = (3 * denominator) ^ 2;
1156 
1157             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1158             // in modular arithmetic, doubling the correct bits in each step.
1159             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1160             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1161             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1162             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1163             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1164             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1165 
1166             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1167             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1168             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1169             // is no longer required.
1170             result = prod0 * inverse;
1171             return result;
1172         }
1173     }
1174 
1175     /**
1176      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1177      */
1178     function mulDiv(
1179         uint256 x,
1180         uint256 y,
1181         uint256 denominator,
1182         Rounding rounding
1183     ) internal pure returns (uint256) {
1184         uint256 result = mulDiv(x, y, denominator);
1185         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1186             result += 1;
1187         }
1188         return result;
1189     }
1190 
1191     /**
1192      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1193      *
1194      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1195      */
1196     function sqrt(uint256 a) internal pure returns (uint256) {
1197         if (a == 0) {
1198             return 0;
1199         }
1200 
1201         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1202         //
1203         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1204         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1205         //
1206         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1207         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1208         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1209         //
1210         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1211         uint256 result = 1 << (log2(a) >> 1);
1212 
1213         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1214         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1215         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1216         // into the expected uint128 result.
1217         unchecked {
1218             result = (result + a / result) >> 1;
1219             result = (result + a / result) >> 1;
1220             result = (result + a / result) >> 1;
1221             result = (result + a / result) >> 1;
1222             result = (result + a / result) >> 1;
1223             result = (result + a / result) >> 1;
1224             result = (result + a / result) >> 1;
1225             return min(result, a / result);
1226         }
1227     }
1228 
1229     /**
1230      * @notice Calculates sqrt(a), following the selected rounding direction.
1231      */
1232     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1233         unchecked {
1234             uint256 result = sqrt(a);
1235             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Return the log in base 2, rounded down, of a positive value.
1241      * Returns 0 if given 0.
1242      */
1243     function log2(uint256 value) internal pure returns (uint256) {
1244         uint256 result = 0;
1245         unchecked {
1246             if (value >> 128 > 0) {
1247                 value >>= 128;
1248                 result += 128;
1249             }
1250             if (value >> 64 > 0) {
1251                 value >>= 64;
1252                 result += 64;
1253             }
1254             if (value >> 32 > 0) {
1255                 value >>= 32;
1256                 result += 32;
1257             }
1258             if (value >> 16 > 0) {
1259                 value >>= 16;
1260                 result += 16;
1261             }
1262             if (value >> 8 > 0) {
1263                 value >>= 8;
1264                 result += 8;
1265             }
1266             if (value >> 4 > 0) {
1267                 value >>= 4;
1268                 result += 4;
1269             }
1270             if (value >> 2 > 0) {
1271                 value >>= 2;
1272                 result += 2;
1273             }
1274             if (value >> 1 > 0) {
1275                 result += 1;
1276             }
1277         }
1278         return result;
1279     }
1280 
1281     /**
1282      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1283      * Returns 0 if given 0.
1284      */
1285     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1286         unchecked {
1287             uint256 result = log2(value);
1288             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Return the log in base 10, rounded down, of a positive value.
1294      * Returns 0 if given 0.
1295      */
1296     function log10(uint256 value) internal pure returns (uint256) {
1297         uint256 result = 0;
1298         unchecked {
1299             if (value >= 10**64) {
1300                 value /= 10**64;
1301                 result += 64;
1302             }
1303             if (value >= 10**32) {
1304                 value /= 10**32;
1305                 result += 32;
1306             }
1307             if (value >= 10**16) {
1308                 value /= 10**16;
1309                 result += 16;
1310             }
1311             if (value >= 10**8) {
1312                 value /= 10**8;
1313                 result += 8;
1314             }
1315             if (value >= 10**4) {
1316                 value /= 10**4;
1317                 result += 4;
1318             }
1319             if (value >= 10**2) {
1320                 value /= 10**2;
1321                 result += 2;
1322             }
1323             if (value >= 10**1) {
1324                 result += 1;
1325             }
1326         }
1327         return result;
1328     }
1329 
1330     /**
1331      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1332      * Returns 0 if given 0.
1333      */
1334     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1335         unchecked {
1336             uint256 result = log10(value);
1337             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1338         }
1339     }
1340 
1341     /**
1342      * @dev Return the log in base 256, rounded down, of a positive value.
1343      * Returns 0 if given 0.
1344      *
1345      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1346      */
1347     function log256(uint256 value) internal pure returns (uint256) {
1348         uint256 result = 0;
1349         unchecked {
1350             if (value >> 128 > 0) {
1351                 value >>= 128;
1352                 result += 16;
1353             }
1354             if (value >> 64 > 0) {
1355                 value >>= 64;
1356                 result += 8;
1357             }
1358             if (value >> 32 > 0) {
1359                 value >>= 32;
1360                 result += 4;
1361             }
1362             if (value >> 16 > 0) {
1363                 value >>= 16;
1364                 result += 2;
1365             }
1366             if (value >> 8 > 0) {
1367                 result += 1;
1368             }
1369         }
1370         return result;
1371     }
1372 
1373     /**
1374      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1375      * Returns 0 if given 0.
1376      */
1377     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1378         unchecked {
1379             uint256 result = log256(value);
1380             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1381         }
1382     }
1383 }
1384 
1385 
1386 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
1387 
1388 
1389 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1390 
1391 pragma solidity ^0.8.0;
1392 
1393 /**
1394  * @dev String operations.
1395  */
1396 library Strings {
1397     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1398     uint8 private constant _ADDRESS_LENGTH = 20;
1399 
1400     /**
1401      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1402      */
1403     function toString(uint256 value) internal pure returns (string memory) {
1404         unchecked {
1405             uint256 length = Math.log10(value) + 1;
1406             string memory buffer = new string(length);
1407             uint256 ptr;
1408             /// @solidity memory-safe-assembly
1409             assembly {
1410                 ptr := add(buffer, add(32, length))
1411             }
1412             while (true) {
1413                 ptr--;
1414                 /// @solidity memory-safe-assembly
1415                 assembly {
1416                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1417                 }
1418                 value /= 10;
1419                 if (value == 0) break;
1420             }
1421             return buffer;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1427      */
1428     function toHexString(uint256 value) internal pure returns (string memory) {
1429         unchecked {
1430             return toHexString(value, Math.log256(value) + 1);
1431         }
1432     }
1433 
1434     /**
1435      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1436      */
1437     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1438         bytes memory buffer = new bytes(2 * length + 2);
1439         buffer[0] = "0";
1440         buffer[1] = "x";
1441         for (uint256 i = 2 * length + 1; i > 1; --i) {
1442             buffer[i] = _SYMBOLS[value & 0xf];
1443             value >>= 4;
1444         }
1445         require(value == 0, "Strings: hex length insufficient");
1446         return string(buffer);
1447     }
1448 
1449     /**
1450      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1451      */
1452     function toHexString(address addr) internal pure returns (string memory) {
1453         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1454     }
1455 }
1456 
1457 
1458 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.8.0
1459 
1460 
1461 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 /**
1466  * @dev Implementation of the {IERC165} interface.
1467  *
1468  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1469  * for the additional interface id that will be supported. For example:
1470  *
1471  * ```solidity
1472  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1473  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1474  * }
1475  * ```
1476  *
1477  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1478  */
1479 abstract contract ERC165 is IERC165 {
1480     /**
1481      * @dev See {IERC165-supportsInterface}.
1482      */
1483     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1484         return interfaceId == type(IERC165).interfaceId;
1485     }
1486 }
1487 
1488 
1489 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.8.0
1490 
1491 
1492 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1493 
1494 pragma solidity ^0.8.0;
1495 
1496 
1497 
1498 
1499 
1500 
1501 
1502 /**
1503  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1504  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1505  * {ERC721Enumerable}.
1506  */
1507 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1508     using Address for address;
1509     using Strings for uint256;
1510 
1511     // Token name
1512     string private _name;
1513 
1514     // Token symbol
1515     string private _symbol;
1516 
1517     // Mapping from token ID to owner address
1518     mapping(uint256 => address) private _owners;
1519 
1520     // Mapping owner address to token count
1521     mapping(address => uint256) private _balances;
1522 
1523     // Mapping from token ID to approved address
1524     mapping(uint256 => address) private _tokenApprovals;
1525 
1526     // Mapping from owner to operator approvals
1527     mapping(address => mapping(address => bool)) private _operatorApprovals;
1528 
1529     /**
1530      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1531      */
1532     constructor(string memory name_, string memory symbol_) {
1533         _name = name_;
1534         _symbol = symbol_;
1535     }
1536 
1537     /**
1538      * @dev See {IERC165-supportsInterface}.
1539      */
1540     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1541         return
1542             interfaceId == type(IERC721).interfaceId ||
1543             interfaceId == type(IERC721Metadata).interfaceId ||
1544             super.supportsInterface(interfaceId);
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-balanceOf}.
1549      */
1550     function balanceOf(address owner) public view virtual override returns (uint256) {
1551         require(owner != address(0), "ERC721: address zero is not a valid owner");
1552         return _balances[owner];
1553     }
1554 
1555     /**
1556      * @dev See {IERC721-ownerOf}.
1557      */
1558     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1559         address owner = _ownerOf(tokenId);
1560         require(owner != address(0), "ERC721: invalid token ID");
1561         return owner;
1562     }
1563 
1564     /**
1565      * @dev See {IERC721Metadata-name}.
1566      */
1567     function name() public view virtual override returns (string memory) {
1568         return _name;
1569     }
1570 
1571     /**
1572      * @dev See {IERC721Metadata-symbol}.
1573      */
1574     function symbol() public view virtual override returns (string memory) {
1575         return _symbol;
1576     }
1577 
1578     /**
1579      * @dev See {IERC721Metadata-tokenURI}.
1580      */
1581     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1582         _requireMinted(tokenId);
1583 
1584         string memory baseURI = _baseURI();
1585         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1586     }
1587 
1588     /**
1589      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1590      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1591      * by default, can be overridden in child contracts.
1592      */
1593     function _baseURI() internal view virtual returns (string memory) {
1594         return "";
1595     }
1596 
1597     /**
1598      * @dev See {IERC721-approve}.
1599      */
1600     function approve(address to, uint256 tokenId) public virtual override {
1601         address owner = ERC721.ownerOf(tokenId);
1602         require(to != owner, "ERC721: approval to current owner");
1603 
1604         require(
1605             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1606             "ERC721: approve caller is not token owner or approved for all"
1607         );
1608 
1609         _approve(to, tokenId);
1610     }
1611 
1612     /**
1613      * @dev See {IERC721-getApproved}.
1614      */
1615     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1616         _requireMinted(tokenId);
1617 
1618         return _tokenApprovals[tokenId];
1619     }
1620 
1621     /**
1622      * @dev See {IERC721-setApprovalForAll}.
1623      */
1624     function setApprovalForAll(address operator, bool approved) public virtual override {
1625         _setApprovalForAll(_msgSender(), operator, approved);
1626     }
1627 
1628     /**
1629      * @dev See {IERC721-isApprovedForAll}.
1630      */
1631     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1632         return _operatorApprovals[owner][operator];
1633     }
1634 
1635     /**
1636      * @dev See {IERC721-transferFrom}.
1637      */
1638     function transferFrom(
1639         address from,
1640         address to,
1641         uint256 tokenId
1642     ) public virtual override {
1643         //solhint-disable-next-line max-line-length
1644         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1645 
1646         _transfer(from, to, tokenId);
1647     }
1648 
1649     /**
1650      * @dev See {IERC721-safeTransferFrom}.
1651      */
1652     function safeTransferFrom(
1653         address from,
1654         address to,
1655         uint256 tokenId
1656     ) public virtual override {
1657         safeTransferFrom(from, to, tokenId, "");
1658     }
1659 
1660     /**
1661      * @dev See {IERC721-safeTransferFrom}.
1662      */
1663     function safeTransferFrom(
1664         address from,
1665         address to,
1666         uint256 tokenId,
1667         bytes memory data
1668     ) public virtual override {
1669         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1670         _safeTransfer(from, to, tokenId, data);
1671     }
1672 
1673     /**
1674      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1675      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1676      *
1677      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1678      *
1679      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1680      * implement alternative mechanisms to perform token transfer, such as signature-based.
1681      *
1682      * Requirements:
1683      *
1684      * - `from` cannot be the zero address.
1685      * - `to` cannot be the zero address.
1686      * - `tokenId` token must exist and be owned by `from`.
1687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _safeTransfer(
1692         address from,
1693         address to,
1694         uint256 tokenId,
1695         bytes memory data
1696     ) internal virtual {
1697         _transfer(from, to, tokenId);
1698         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1699     }
1700 
1701     /**
1702      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1703      */
1704     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1705         return _owners[tokenId];
1706     }
1707 
1708     /**
1709      * @dev Returns whether `tokenId` exists.
1710      *
1711      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1712      *
1713      * Tokens start existing when they are minted (`_mint`),
1714      * and stop existing when they are burned (`_burn`).
1715      */
1716     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1717         return _ownerOf(tokenId) != address(0);
1718     }
1719 
1720     /**
1721      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1722      *
1723      * Requirements:
1724      *
1725      * - `tokenId` must exist.
1726      */
1727     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1728         address owner = ERC721.ownerOf(tokenId);
1729         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1730     }
1731 
1732     /**
1733      * @dev Safely mints `tokenId` and transfers it to `to`.
1734      *
1735      * Requirements:
1736      *
1737      * - `tokenId` must not exist.
1738      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1739      *
1740      * Emits a {Transfer} event.
1741      */
1742     function _safeMint(address to, uint256 tokenId) internal virtual {
1743         _safeMint(to, tokenId, "");
1744     }
1745 
1746     /**
1747      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1748      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1749      */
1750     function _safeMint(
1751         address to,
1752         uint256 tokenId,
1753         bytes memory data
1754     ) internal virtual {
1755         _mint(to, tokenId);
1756         require(
1757             _checkOnERC721Received(address(0), to, tokenId, data),
1758             "ERC721: transfer to non ERC721Receiver implementer"
1759         );
1760     }
1761 
1762     /**
1763      * @dev Mints `tokenId` and transfers it to `to`.
1764      *
1765      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1766      *
1767      * Requirements:
1768      *
1769      * - `tokenId` must not exist.
1770      * - `to` cannot be the zero address.
1771      *
1772      * Emits a {Transfer} event.
1773      */
1774     function _mint(address to, uint256 tokenId) internal virtual {
1775         require(to != address(0), "ERC721: mint to the zero address");
1776         require(!_exists(tokenId), "ERC721: token already minted");
1777 
1778         _beforeTokenTransfer(address(0), to, tokenId, 1);
1779 
1780         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1781         require(!_exists(tokenId), "ERC721: token already minted");
1782 
1783         unchecked {
1784             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1785             // Given that tokens are minted one by one, it is impossible in practice that
1786             // this ever happens. Might change if we allow batch minting.
1787             // The ERC fails to describe this case.
1788             _balances[to] += 1;
1789         }
1790 
1791         _owners[tokenId] = to;
1792 
1793         emit Transfer(address(0), to, tokenId);
1794 
1795         _afterTokenTransfer(address(0), to, tokenId, 1);
1796     }
1797 
1798     /**
1799      * @dev Destroys `tokenId`.
1800      * The approval is cleared when the token is burned.
1801      * This is an internal function that does not check if the sender is authorized to operate on the token.
1802      *
1803      * Requirements:
1804      *
1805      * - `tokenId` must exist.
1806      *
1807      * Emits a {Transfer} event.
1808      */
1809     function _burn(uint256 tokenId) internal virtual {
1810         address owner = ERC721.ownerOf(tokenId);
1811 
1812         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1813 
1814         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1815         owner = ERC721.ownerOf(tokenId);
1816 
1817         // Clear approvals
1818         delete _tokenApprovals[tokenId];
1819 
1820         unchecked {
1821             // Cannot overflow, as that would require more tokens to be burned/transferred
1822             // out than the owner initially received through minting and transferring in.
1823             _balances[owner] -= 1;
1824         }
1825         delete _owners[tokenId];
1826 
1827         emit Transfer(owner, address(0), tokenId);
1828 
1829         _afterTokenTransfer(owner, address(0), tokenId, 1);
1830     }
1831 
1832     /**
1833      * @dev Transfers `tokenId` from `from` to `to`.
1834      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1835      *
1836      * Requirements:
1837      *
1838      * - `to` cannot be the zero address.
1839      * - `tokenId` token must be owned by `from`.
1840      *
1841      * Emits a {Transfer} event.
1842      */
1843     function _transfer(
1844         address from,
1845         address to,
1846         uint256 tokenId
1847     ) internal virtual {
1848         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1849         require(to != address(0), "ERC721: transfer to the zero address");
1850 
1851         _beforeTokenTransfer(from, to, tokenId, 1);
1852 
1853         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1854         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1855 
1856         // Clear approvals from the previous owner
1857         delete _tokenApprovals[tokenId];
1858 
1859         unchecked {
1860             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1861             // `from`'s balance is the number of token held, which is at least one before the current
1862             // transfer.
1863             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1864             // all 2**256 token ids to be minted, which in practice is impossible.
1865             _balances[from] -= 1;
1866             _balances[to] += 1;
1867         }
1868         _owners[tokenId] = to;
1869 
1870         emit Transfer(from, to, tokenId);
1871 
1872         _afterTokenTransfer(from, to, tokenId, 1);
1873     }
1874 
1875     /**
1876      * @dev Approve `to` to operate on `tokenId`
1877      *
1878      * Emits an {Approval} event.
1879      */
1880     function _approve(address to, uint256 tokenId) internal virtual {
1881         _tokenApprovals[tokenId] = to;
1882         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1883     }
1884 
1885     /**
1886      * @dev Approve `operator` to operate on all of `owner` tokens
1887      *
1888      * Emits an {ApprovalForAll} event.
1889      */
1890     function _setApprovalForAll(
1891         address owner,
1892         address operator,
1893         bool approved
1894     ) internal virtual {
1895         require(owner != operator, "ERC721: approve to caller");
1896         _operatorApprovals[owner][operator] = approved;
1897         emit ApprovalForAll(owner, operator, approved);
1898     }
1899 
1900     /**
1901      * @dev Reverts if the `tokenId` has not been minted yet.
1902      */
1903     function _requireMinted(uint256 tokenId) internal view virtual {
1904         require(_exists(tokenId), "ERC721: invalid token ID");
1905     }
1906 
1907     /**
1908      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1909      * The call is not executed if the target address is not a contract.
1910      *
1911      * @param from address representing the previous owner of the given token ID
1912      * @param to target address that will receive the tokens
1913      * @param tokenId uint256 ID of the token to be transferred
1914      * @param data bytes optional data to send along with the call
1915      * @return bool whether the call correctly returned the expected magic value
1916      */
1917     function _checkOnERC721Received(
1918         address from,
1919         address to,
1920         uint256 tokenId,
1921         bytes memory data
1922     ) private returns (bool) {
1923         if (to.isContract()) {
1924             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1925                 return retval == IERC721Receiver.onERC721Received.selector;
1926             } catch (bytes memory reason) {
1927                 if (reason.length == 0) {
1928                     revert("ERC721: transfer to non ERC721Receiver implementer");
1929                 } else {
1930                     /// @solidity memory-safe-assembly
1931                     assembly {
1932                         revert(add(32, reason), mload(reason))
1933                     }
1934                 }
1935             }
1936         } else {
1937             return true;
1938         }
1939     }
1940 
1941     /**
1942      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1943      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1944      *
1945      * Calling conditions:
1946      *
1947      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1948      * - When `from` is zero, the tokens will be minted for `to`.
1949      * - When `to` is zero, ``from``'s tokens will be burned.
1950      * - `from` and `to` are never both zero.
1951      * - `batchSize` is non-zero.
1952      *
1953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1954      */
1955     function _beforeTokenTransfer(
1956         address from,
1957         address to,
1958         uint256, /* firstTokenId */
1959         uint256 batchSize
1960     ) internal virtual {
1961         if (batchSize > 1) {
1962             if (from != address(0)) {
1963                 _balances[from] -= batchSize;
1964             }
1965             if (to != address(0)) {
1966                 _balances[to] += batchSize;
1967             }
1968         }
1969     }
1970 
1971     /**
1972      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1973      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1974      *
1975      * Calling conditions:
1976      *
1977      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1978      * - When `from` is zero, the tokens were minted for `to`.
1979      * - When `to` is zero, ``from``'s tokens were burned.
1980      * - `from` and `to` are never both zero.
1981      * - `batchSize` is non-zero.
1982      *
1983      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1984      */
1985     function _afterTokenTransfer(
1986         address from,
1987         address to,
1988         uint256 firstTokenId,
1989         uint256 batchSize
1990     ) internal virtual {}
1991 }
1992 
1993 
1994 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.8.0
1995 
1996 
1997 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
1998 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
1999 
2000 pragma solidity ^0.8.0;
2001 
2002 /**
2003  * @dev Library for managing
2004  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2005  * types.
2006  *
2007  * Sets have the following properties:
2008  *
2009  * - Elements are added, removed, and checked for existence in constant time
2010  * (O(1)).
2011  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2012  *
2013  * ```
2014  * contract Example {
2015  *     // Add the library methods
2016  *     using EnumerableSet for EnumerableSet.AddressSet;
2017  *
2018  *     // Declare a set state variable
2019  *     EnumerableSet.AddressSet private mySet;
2020  * }
2021  * ```
2022  *
2023  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
2024  * and `uint256` (`UintSet`) are supported.
2025  *
2026  * [WARNING]
2027  * ====
2028  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
2029  * unusable.
2030  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
2031  *
2032  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
2033  * array of EnumerableSet.
2034  * ====
2035  */
2036 library EnumerableSet {
2037     // To implement this library for multiple types with as little code
2038     // repetition as possible, we write it in terms of a generic Set type with
2039     // bytes32 values.
2040     // The Set implementation uses private functions, and user-facing
2041     // implementations (such as AddressSet) are just wrappers around the
2042     // underlying Set.
2043     // This means that we can only create new EnumerableSets for types that fit
2044     // in bytes32.
2045 
2046     struct Set {
2047         // Storage of set values
2048         bytes32[] _values;
2049         // Position of the value in the `values` array, plus 1 because index 0
2050         // means a value is not in the set.
2051         mapping(bytes32 => uint256) _indexes;
2052     }
2053 
2054     /**
2055      * @dev Add a value to a set. O(1).
2056      *
2057      * Returns true if the value was added to the set, that is if it was not
2058      * already present.
2059      */
2060     function _add(Set storage set, bytes32 value) private returns (bool) {
2061         if (!_contains(set, value)) {
2062             set._values.push(value);
2063             // The value is stored at length-1, but we add 1 to all indexes
2064             // and use 0 as a sentinel value
2065             set._indexes[value] = set._values.length;
2066             return true;
2067         } else {
2068             return false;
2069         }
2070     }
2071 
2072     /**
2073      * @dev Removes a value from a set. O(1).
2074      *
2075      * Returns true if the value was removed from the set, that is if it was
2076      * present.
2077      */
2078     function _remove(Set storage set, bytes32 value) private returns (bool) {
2079         // We read and store the value's index to prevent multiple reads from the same storage slot
2080         uint256 valueIndex = set._indexes[value];
2081 
2082         if (valueIndex != 0) {
2083             // Equivalent to contains(set, value)
2084             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2085             // the array, and then remove the last element (sometimes called as 'swap and pop').
2086             // This modifies the order of the array, as noted in {at}.
2087 
2088             uint256 toDeleteIndex = valueIndex - 1;
2089             uint256 lastIndex = set._values.length - 1;
2090 
2091             if (lastIndex != toDeleteIndex) {
2092                 bytes32 lastValue = set._values[lastIndex];
2093 
2094                 // Move the last value to the index where the value to delete is
2095                 set._values[toDeleteIndex] = lastValue;
2096                 // Update the index for the moved value
2097                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
2098             }
2099 
2100             // Delete the slot where the moved value was stored
2101             set._values.pop();
2102 
2103             // Delete the index for the deleted slot
2104             delete set._indexes[value];
2105 
2106             return true;
2107         } else {
2108             return false;
2109         }
2110     }
2111 
2112     /**
2113      * @dev Returns true if the value is in the set. O(1).
2114      */
2115     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2116         return set._indexes[value] != 0;
2117     }
2118 
2119     /**
2120      * @dev Returns the number of values on the set. O(1).
2121      */
2122     function _length(Set storage set) private view returns (uint256) {
2123         return set._values.length;
2124     }
2125 
2126     /**
2127      * @dev Returns the value stored at position `index` in the set. O(1).
2128      *
2129      * Note that there are no guarantees on the ordering of values inside the
2130      * array, and it may change when more values are added or removed.
2131      *
2132      * Requirements:
2133      *
2134      * - `index` must be strictly less than {length}.
2135      */
2136     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2137         return set._values[index];
2138     }
2139 
2140     /**
2141      * @dev Return the entire set in an array
2142      *
2143      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2144      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2145      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2146      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2147      */
2148     function _values(Set storage set) private view returns (bytes32[] memory) {
2149         return set._values;
2150     }
2151 
2152     // Bytes32Set
2153 
2154     struct Bytes32Set {
2155         Set _inner;
2156     }
2157 
2158     /**
2159      * @dev Add a value to a set. O(1).
2160      *
2161      * Returns true if the value was added to the set, that is if it was not
2162      * already present.
2163      */
2164     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2165         return _add(set._inner, value);
2166     }
2167 
2168     /**
2169      * @dev Removes a value from a set. O(1).
2170      *
2171      * Returns true if the value was removed from the set, that is if it was
2172      * present.
2173      */
2174     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2175         return _remove(set._inner, value);
2176     }
2177 
2178     /**
2179      * @dev Returns true if the value is in the set. O(1).
2180      */
2181     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2182         return _contains(set._inner, value);
2183     }
2184 
2185     /**
2186      * @dev Returns the number of values in the set. O(1).
2187      */
2188     function length(Bytes32Set storage set) internal view returns (uint256) {
2189         return _length(set._inner);
2190     }
2191 
2192     /**
2193      * @dev Returns the value stored at position `index` in the set. O(1).
2194      *
2195      * Note that there are no guarantees on the ordering of values inside the
2196      * array, and it may change when more values are added or removed.
2197      *
2198      * Requirements:
2199      *
2200      * - `index` must be strictly less than {length}.
2201      */
2202     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2203         return _at(set._inner, index);
2204     }
2205 
2206     /**
2207      * @dev Return the entire set in an array
2208      *
2209      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2210      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2211      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2212      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2213      */
2214     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
2215         bytes32[] memory store = _values(set._inner);
2216         bytes32[] memory result;
2217 
2218         /// @solidity memory-safe-assembly
2219         assembly {
2220             result := store
2221         }
2222 
2223         return result;
2224     }
2225 
2226     // AddressSet
2227 
2228     struct AddressSet {
2229         Set _inner;
2230     }
2231 
2232     /**
2233      * @dev Add a value to a set. O(1).
2234      *
2235      * Returns true if the value was added to the set, that is if it was not
2236      * already present.
2237      */
2238     function add(AddressSet storage set, address value) internal returns (bool) {
2239         return _add(set._inner, bytes32(uint256(uint160(value))));
2240     }
2241 
2242     /**
2243      * @dev Removes a value from a set. O(1).
2244      *
2245      * Returns true if the value was removed from the set, that is if it was
2246      * present.
2247      */
2248     function remove(AddressSet storage set, address value) internal returns (bool) {
2249         return _remove(set._inner, bytes32(uint256(uint160(value))));
2250     }
2251 
2252     /**
2253      * @dev Returns true if the value is in the set. O(1).
2254      */
2255     function contains(AddressSet storage set, address value) internal view returns (bool) {
2256         return _contains(set._inner, bytes32(uint256(uint160(value))));
2257     }
2258 
2259     /**
2260      * @dev Returns the number of values in the set. O(1).
2261      */
2262     function length(AddressSet storage set) internal view returns (uint256) {
2263         return _length(set._inner);
2264     }
2265 
2266     /**
2267      * @dev Returns the value stored at position `index` in the set. O(1).
2268      *
2269      * Note that there are no guarantees on the ordering of values inside the
2270      * array, and it may change when more values are added or removed.
2271      *
2272      * Requirements:
2273      *
2274      * - `index` must be strictly less than {length}.
2275      */
2276     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2277         return address(uint160(uint256(_at(set._inner, index))));
2278     }
2279 
2280     /**
2281      * @dev Return the entire set in an array
2282      *
2283      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2284      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2285      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2286      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2287      */
2288     function values(AddressSet storage set) internal view returns (address[] memory) {
2289         bytes32[] memory store = _values(set._inner);
2290         address[] memory result;
2291 
2292         /// @solidity memory-safe-assembly
2293         assembly {
2294             result := store
2295         }
2296 
2297         return result;
2298     }
2299 
2300     // UintSet
2301 
2302     struct UintSet {
2303         Set _inner;
2304     }
2305 
2306     /**
2307      * @dev Add a value to a set. O(1).
2308      *
2309      * Returns true if the value was added to the set, that is if it was not
2310      * already present.
2311      */
2312     function add(UintSet storage set, uint256 value) internal returns (bool) {
2313         return _add(set._inner, bytes32(value));
2314     }
2315 
2316     /**
2317      * @dev Removes a value from a set. O(1).
2318      *
2319      * Returns true if the value was removed from the set, that is if it was
2320      * present.
2321      */
2322     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2323         return _remove(set._inner, bytes32(value));
2324     }
2325 
2326     /**
2327      * @dev Returns true if the value is in the set. O(1).
2328      */
2329     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2330         return _contains(set._inner, bytes32(value));
2331     }
2332 
2333     /**
2334      * @dev Returns the number of values in the set. O(1).
2335      */
2336     function length(UintSet storage set) internal view returns (uint256) {
2337         return _length(set._inner);
2338     }
2339 
2340     /**
2341      * @dev Returns the value stored at position `index` in the set. O(1).
2342      *
2343      * Note that there are no guarantees on the ordering of values inside the
2344      * array, and it may change when more values are added or removed.
2345      *
2346      * Requirements:
2347      *
2348      * - `index` must be strictly less than {length}.
2349      */
2350     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2351         return uint256(_at(set._inner, index));
2352     }
2353 
2354     /**
2355      * @dev Return the entire set in an array
2356      *
2357      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2358      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2359      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2360      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2361      */
2362     function values(UintSet storage set) internal view returns (uint256[] memory) {
2363         bytes32[] memory store = _values(set._inner);
2364         uint256[] memory result;
2365 
2366         /// @solidity memory-safe-assembly
2367         assembly {
2368             result := store
2369         }
2370 
2371         return result;
2372     }
2373 }
2374 
2375 
2376 // File @openzeppelin/contracts/utils/structs/EnumerableMap.sol@v4.8.0
2377 
2378 
2379 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableMap.sol)
2380 // This file was procedurally generated from scripts/generate/templates/EnumerableMap.js.
2381 
2382 pragma solidity ^0.8.0;
2383 
2384 /**
2385  * @dev Library for managing an enumerable variant of Solidity's
2386  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
2387  * type.
2388  *
2389  * Maps have the following properties:
2390  *
2391  * - Entries are added, removed, and checked for existence in constant time
2392  * (O(1)).
2393  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
2394  *
2395  * ```
2396  * contract Example {
2397  *     // Add the library methods
2398  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
2399  *
2400  *     // Declare a set state variable
2401  *     EnumerableMap.UintToAddressMap private myMap;
2402  * }
2403  * ```
2404  *
2405  * The following map types are supported:
2406  *
2407  * - `uint256 -> address` (`UintToAddressMap`) since v3.0.0
2408  * - `address -> uint256` (`AddressToUintMap`) since v4.6.0
2409  * - `bytes32 -> bytes32` (`Bytes32ToBytes32Map`) since v4.6.0
2410  * - `uint256 -> uint256` (`UintToUintMap`) since v4.7.0
2411  * - `bytes32 -> uint256` (`Bytes32ToUintMap`) since v4.7.0
2412  *
2413  * [WARNING]
2414  * ====
2415  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
2416  * unusable.
2417  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
2418  *
2419  * In order to clean an EnumerableMap, you can either remove all elements one by one or create a fresh instance using an
2420  * array of EnumerableMap.
2421  * ====
2422  */
2423 library EnumerableMap {
2424     using EnumerableSet for EnumerableSet.Bytes32Set;
2425 
2426     // To implement this library for multiple types with as little code
2427     // repetition as possible, we write it in terms of a generic Map type with
2428     // bytes32 keys and values.
2429     // The Map implementation uses private functions, and user-facing
2430     // implementations (such as Uint256ToAddressMap) are just wrappers around
2431     // the underlying Map.
2432     // This means that we can only create new EnumerableMaps for types that fit
2433     // in bytes32.
2434 
2435     struct Bytes32ToBytes32Map {
2436         // Storage of keys
2437         EnumerableSet.Bytes32Set _keys;
2438         mapping(bytes32 => bytes32) _values;
2439     }
2440 
2441     /**
2442      * @dev Adds a key-value pair to a map, or updates the value for an existing
2443      * key. O(1).
2444      *
2445      * Returns true if the key was added to the map, that is if it was not
2446      * already present.
2447      */
2448     function set(
2449         Bytes32ToBytes32Map storage map,
2450         bytes32 key,
2451         bytes32 value
2452     ) internal returns (bool) {
2453         map._values[key] = value;
2454         return map._keys.add(key);
2455     }
2456 
2457     /**
2458      * @dev Removes a key-value pair from a map. O(1).
2459      *
2460      * Returns true if the key was removed from the map, that is if it was present.
2461      */
2462     function remove(Bytes32ToBytes32Map storage map, bytes32 key) internal returns (bool) {
2463         delete map._values[key];
2464         return map._keys.remove(key);
2465     }
2466 
2467     /**
2468      * @dev Returns true if the key is in the map. O(1).
2469      */
2470     function contains(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool) {
2471         return map._keys.contains(key);
2472     }
2473 
2474     /**
2475      * @dev Returns the number of key-value pairs in the map. O(1).
2476      */
2477     function length(Bytes32ToBytes32Map storage map) internal view returns (uint256) {
2478         return map._keys.length();
2479     }
2480 
2481     /**
2482      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
2483      *
2484      * Note that there are no guarantees on the ordering of entries inside the
2485      * array, and it may change when more entries are added or removed.
2486      *
2487      * Requirements:
2488      *
2489      * - `index` must be strictly less than {length}.
2490      */
2491     function at(Bytes32ToBytes32Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
2492         bytes32 key = map._keys.at(index);
2493         return (key, map._values[key]);
2494     }
2495 
2496     /**
2497      * @dev Tries to returns the value associated with `key`. O(1).
2498      * Does not revert if `key` is not in the map.
2499      */
2500     function tryGet(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool, bytes32) {
2501         bytes32 value = map._values[key];
2502         if (value == bytes32(0)) {
2503             return (contains(map, key), bytes32(0));
2504         } else {
2505             return (true, value);
2506         }
2507     }
2508 
2509     /**
2510      * @dev Returns the value associated with `key`. O(1).
2511      *
2512      * Requirements:
2513      *
2514      * - `key` must be in the map.
2515      */
2516     function get(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bytes32) {
2517         bytes32 value = map._values[key];
2518         require(value != 0 || contains(map, key), "EnumerableMap: nonexistent key");
2519         return value;
2520     }
2521 
2522     /**
2523      * @dev Same as {get}, with a custom error message when `key` is not in the map.
2524      *
2525      * CAUTION: This function is deprecated because it requires allocating memory for the error
2526      * message unnecessarily. For custom revert reasons use {tryGet}.
2527      */
2528     function get(
2529         Bytes32ToBytes32Map storage map,
2530         bytes32 key,
2531         string memory errorMessage
2532     ) internal view returns (bytes32) {
2533         bytes32 value = map._values[key];
2534         require(value != 0 || contains(map, key), errorMessage);
2535         return value;
2536     }
2537 
2538     // UintToUintMap
2539 
2540     struct UintToUintMap {
2541         Bytes32ToBytes32Map _inner;
2542     }
2543 
2544     /**
2545      * @dev Adds a key-value pair to a map, or updates the value for an existing
2546      * key. O(1).
2547      *
2548      * Returns true if the key was added to the map, that is if it was not
2549      * already present.
2550      */
2551     function set(
2552         UintToUintMap storage map,
2553         uint256 key,
2554         uint256 value
2555     ) internal returns (bool) {
2556         return set(map._inner, bytes32(key), bytes32(value));
2557     }
2558 
2559     /**
2560      * @dev Removes a value from a set. O(1).
2561      *
2562      * Returns true if the key was removed from the map, that is if it was present.
2563      */
2564     function remove(UintToUintMap storage map, uint256 key) internal returns (bool) {
2565         return remove(map._inner, bytes32(key));
2566     }
2567 
2568     /**
2569      * @dev Returns true if the key is in the map. O(1).
2570      */
2571     function contains(UintToUintMap storage map, uint256 key) internal view returns (bool) {
2572         return contains(map._inner, bytes32(key));
2573     }
2574 
2575     /**
2576      * @dev Returns the number of elements in the map. O(1).
2577      */
2578     function length(UintToUintMap storage map) internal view returns (uint256) {
2579         return length(map._inner);
2580     }
2581 
2582     /**
2583      * @dev Returns the element stored at position `index` in the set. O(1).
2584      * Note that there are no guarantees on the ordering of values inside the
2585      * array, and it may change when more values are added or removed.
2586      *
2587      * Requirements:
2588      *
2589      * - `index` must be strictly less than {length}.
2590      */
2591     function at(UintToUintMap storage map, uint256 index) internal view returns (uint256, uint256) {
2592         (bytes32 key, bytes32 value) = at(map._inner, index);
2593         return (uint256(key), uint256(value));
2594     }
2595 
2596     /**
2597      * @dev Tries to returns the value associated with `key`. O(1).
2598      * Does not revert if `key` is not in the map.
2599      */
2600     function tryGet(UintToUintMap storage map, uint256 key) internal view returns (bool, uint256) {
2601         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
2602         return (success, uint256(value));
2603     }
2604 
2605     /**
2606      * @dev Returns the value associated with `key`. O(1).
2607      *
2608      * Requirements:
2609      *
2610      * - `key` must be in the map.
2611      */
2612     function get(UintToUintMap storage map, uint256 key) internal view returns (uint256) {
2613         return uint256(get(map._inner, bytes32(key)));
2614     }
2615 
2616     /**
2617      * @dev Same as {get}, with a custom error message when `key` is not in the map.
2618      *
2619      * CAUTION: This function is deprecated because it requires allocating memory for the error
2620      * message unnecessarily. For custom revert reasons use {tryGet}.
2621      */
2622     function get(
2623         UintToUintMap storage map,
2624         uint256 key,
2625         string memory errorMessage
2626     ) internal view returns (uint256) {
2627         return uint256(get(map._inner, bytes32(key), errorMessage));
2628     }
2629 
2630     // UintToAddressMap
2631 
2632     struct UintToAddressMap {
2633         Bytes32ToBytes32Map _inner;
2634     }
2635 
2636     /**
2637      * @dev Adds a key-value pair to a map, or updates the value for an existing
2638      * key. O(1).
2639      *
2640      * Returns true if the key was added to the map, that is if it was not
2641      * already present.
2642      */
2643     function set(
2644         UintToAddressMap storage map,
2645         uint256 key,
2646         address value
2647     ) internal returns (bool) {
2648         return set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
2649     }
2650 
2651     /**
2652      * @dev Removes a value from a set. O(1).
2653      *
2654      * Returns true if the key was removed from the map, that is if it was present.
2655      */
2656     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
2657         return remove(map._inner, bytes32(key));
2658     }
2659 
2660     /**
2661      * @dev Returns true if the key is in the map. O(1).
2662      */
2663     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
2664         return contains(map._inner, bytes32(key));
2665     }
2666 
2667     /**
2668      * @dev Returns the number of elements in the map. O(1).
2669      */
2670     function length(UintToAddressMap storage map) internal view returns (uint256) {
2671         return length(map._inner);
2672     }
2673 
2674     /**
2675      * @dev Returns the element stored at position `index` in the set. O(1).
2676      * Note that there are no guarantees on the ordering of values inside the
2677      * array, and it may change when more values are added or removed.
2678      *
2679      * Requirements:
2680      *
2681      * - `index` must be strictly less than {length}.
2682      */
2683     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
2684         (bytes32 key, bytes32 value) = at(map._inner, index);
2685         return (uint256(key), address(uint160(uint256(value))));
2686     }
2687 
2688     /**
2689      * @dev Tries to returns the value associated with `key`. O(1).
2690      * Does not revert if `key` is not in the map.
2691      */
2692     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
2693         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
2694         return (success, address(uint160(uint256(value))));
2695     }
2696 
2697     /**
2698      * @dev Returns the value associated with `key`. O(1).
2699      *
2700      * Requirements:
2701      *
2702      * - `key` must be in the map.
2703      */
2704     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
2705         return address(uint160(uint256(get(map._inner, bytes32(key)))));
2706     }
2707 
2708     /**
2709      * @dev Same as {get}, with a custom error message when `key` is not in the map.
2710      *
2711      * CAUTION: This function is deprecated because it requires allocating memory for the error
2712      * message unnecessarily. For custom revert reasons use {tryGet}.
2713      */
2714     function get(
2715         UintToAddressMap storage map,
2716         uint256 key,
2717         string memory errorMessage
2718     ) internal view returns (address) {
2719         return address(uint160(uint256(get(map._inner, bytes32(key), errorMessage))));
2720     }
2721 
2722     // AddressToUintMap
2723 
2724     struct AddressToUintMap {
2725         Bytes32ToBytes32Map _inner;
2726     }
2727 
2728     /**
2729      * @dev Adds a key-value pair to a map, or updates the value for an existing
2730      * key. O(1).
2731      *
2732      * Returns true if the key was added to the map, that is if it was not
2733      * already present.
2734      */
2735     function set(
2736         AddressToUintMap storage map,
2737         address key,
2738         uint256 value
2739     ) internal returns (bool) {
2740         return set(map._inner, bytes32(uint256(uint160(key))), bytes32(value));
2741     }
2742 
2743     /**
2744      * @dev Removes a value from a set. O(1).
2745      *
2746      * Returns true if the key was removed from the map, that is if it was present.
2747      */
2748     function remove(AddressToUintMap storage map, address key) internal returns (bool) {
2749         return remove(map._inner, bytes32(uint256(uint160(key))));
2750     }
2751 
2752     /**
2753      * @dev Returns true if the key is in the map. O(1).
2754      */
2755     function contains(AddressToUintMap storage map, address key) internal view returns (bool) {
2756         return contains(map._inner, bytes32(uint256(uint160(key))));
2757     }
2758 
2759     /**
2760      * @dev Returns the number of elements in the map. O(1).
2761      */
2762     function length(AddressToUintMap storage map) internal view returns (uint256) {
2763         return length(map._inner);
2764     }
2765 
2766     /**
2767      * @dev Returns the element stored at position `index` in the set. O(1).
2768      * Note that there are no guarantees on the ordering of values inside the
2769      * array, and it may change when more values are added or removed.
2770      *
2771      * Requirements:
2772      *
2773      * - `index` must be strictly less than {length}.
2774      */
2775     function at(AddressToUintMap storage map, uint256 index) internal view returns (address, uint256) {
2776         (bytes32 key, bytes32 value) = at(map._inner, index);
2777         return (address(uint160(uint256(key))), uint256(value));
2778     }
2779 
2780     /**
2781      * @dev Tries to returns the value associated with `key`. O(1).
2782      * Does not revert if `key` is not in the map.
2783      */
2784     function tryGet(AddressToUintMap storage map, address key) internal view returns (bool, uint256) {
2785         (bool success, bytes32 value) = tryGet(map._inner, bytes32(uint256(uint160(key))));
2786         return (success, uint256(value));
2787     }
2788 
2789     /**
2790      * @dev Returns the value associated with `key`. O(1).
2791      *
2792      * Requirements:
2793      *
2794      * - `key` must be in the map.
2795      */
2796     function get(AddressToUintMap storage map, address key) internal view returns (uint256) {
2797         return uint256(get(map._inner, bytes32(uint256(uint160(key)))));
2798     }
2799 
2800     /**
2801      * @dev Same as {get}, with a custom error message when `key` is not in the map.
2802      *
2803      * CAUTION: This function is deprecated because it requires allocating memory for the error
2804      * message unnecessarily. For custom revert reasons use {tryGet}.
2805      */
2806     function get(
2807         AddressToUintMap storage map,
2808         address key,
2809         string memory errorMessage
2810     ) internal view returns (uint256) {
2811         return uint256(get(map._inner, bytes32(uint256(uint160(key))), errorMessage));
2812     }
2813 
2814     // Bytes32ToUintMap
2815 
2816     struct Bytes32ToUintMap {
2817         Bytes32ToBytes32Map _inner;
2818     }
2819 
2820     /**
2821      * @dev Adds a key-value pair to a map, or updates the value for an existing
2822      * key. O(1).
2823      *
2824      * Returns true if the key was added to the map, that is if it was not
2825      * already present.
2826      */
2827     function set(
2828         Bytes32ToUintMap storage map,
2829         bytes32 key,
2830         uint256 value
2831     ) internal returns (bool) {
2832         return set(map._inner, key, bytes32(value));
2833     }
2834 
2835     /**
2836      * @dev Removes a value from a set. O(1).
2837      *
2838      * Returns true if the key was removed from the map, that is if it was present.
2839      */
2840     function remove(Bytes32ToUintMap storage map, bytes32 key) internal returns (bool) {
2841         return remove(map._inner, key);
2842     }
2843 
2844     /**
2845      * @dev Returns true if the key is in the map. O(1).
2846      */
2847     function contains(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool) {
2848         return contains(map._inner, key);
2849     }
2850 
2851     /**
2852      * @dev Returns the number of elements in the map. O(1).
2853      */
2854     function length(Bytes32ToUintMap storage map) internal view returns (uint256) {
2855         return length(map._inner);
2856     }
2857 
2858     /**
2859      * @dev Returns the element stored at position `index` in the set. O(1).
2860      * Note that there are no guarantees on the ordering of values inside the
2861      * array, and it may change when more values are added or removed.
2862      *
2863      * Requirements:
2864      *
2865      * - `index` must be strictly less than {length}.
2866      */
2867     function at(Bytes32ToUintMap storage map, uint256 index) internal view returns (bytes32, uint256) {
2868         (bytes32 key, bytes32 value) = at(map._inner, index);
2869         return (key, uint256(value));
2870     }
2871 
2872     /**
2873      * @dev Tries to returns the value associated with `key`. O(1).
2874      * Does not revert if `key` is not in the map.
2875      */
2876     function tryGet(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool, uint256) {
2877         (bool success, bytes32 value) = tryGet(map._inner, key);
2878         return (success, uint256(value));
2879     }
2880 
2881     /**
2882      * @dev Returns the value associated with `key`. O(1).
2883      *
2884      * Requirements:
2885      *
2886      * - `key` must be in the map.
2887      */
2888     function get(Bytes32ToUintMap storage map, bytes32 key) internal view returns (uint256) {
2889         return uint256(get(map._inner, key));
2890     }
2891 
2892     /**
2893      * @dev Same as {get}, with a custom error message when `key` is not in the map.
2894      *
2895      * CAUTION: This function is deprecated because it requires allocating memory for the error
2896      * message unnecessarily. For custom revert reasons use {tryGet}.
2897      */
2898     function get(
2899         Bytes32ToUintMap storage map,
2900         bytes32 key,
2901         string memory errorMessage
2902     ) internal view returns (uint256) {
2903         return uint256(get(map._inner, key, errorMessage));
2904     }
2905 }
2906 
2907 
2908 // File contracts/ERC721GWhitelistAuth/interfaces/IERC721G.sol
2909 
2910 
2911 pragma solidity ^0.8.0;
2912 
2913 struct Auth {
2914     address erc721;
2915     string name;
2916     string symbol;
2917     bool isOpen;
2918 }
2919 
2920 interface IERC721G is IERC721 {
2921     /**
2922      * @dev Emitted when reset `auth` opening status.
2923      */
2924     event SetGiftAuth(address auth, bool isOpen);
2925 
2926     /**
2927      * @dev Returns all auth info.
2928      */
2929     function getAllGiftAuth() external view returns (Auth[] memory);
2930 
2931     /**
2932      * @dev Returns minted quantity for the auth and auth token id.
2933      */
2934     function getGiftMintedQuantity(address auth, uint authTokenId) external view returns (uint);
2935 
2936     /**
2937      * @dev Returns mint count limit for each auth token id.
2938      */
2939     function getGiftMintLimit() external view returns (uint);
2940 
2941     /**
2942      * @dev Returns total mint quantity.
2943      */
2944     function getTotalGiftMint() external view returns (uint);
2945 
2946     /**
2947      * @dev Returns the max total mint limit.
2948      */
2949     function getMaxTotalGiftMint() external view returns (uint);
2950 
2951 }
2952 
2953 
2954 // File contracts/ERC721GWhitelistAuth/ERC721G.sol
2955 
2956 
2957 pragma solidity ^0.8.0;
2958 
2959 
2960 
2961 // ERC721 Gift
2962 contract ERC721G is IERC721G, ERC721 {
2963 
2964     using EnumerableMap for EnumerableMap.AddressToUintMap;
2965 
2966     EnumerableMap.AddressToUintMap private allAuth;
2967     mapping(address => mapping(uint => uint)) private mintedQuantity;
2968     uint private giftMintLimit = 1;
2969     uint private totalGiftMint = 0;
2970     uint private maxTotalGiftMint = 0;
2971 
2972     constructor(string memory name_, string memory symbol_)
2973         ERC721(name_, symbol_)
2974     {
2975     }
2976 
2977     function _setGiftAuth(address erc721, bool isOpen) internal {
2978         uint v = isOpen ? 1 : 0;
2979         allAuth.set(erc721, v);
2980         emit SetGiftAuth(erc721, isOpen);
2981     }
2982 
2983     function _setGiftMintLimit(uint limit_) internal {
2984         giftMintLimit = limit_;
2985     }
2986 
2987     function _setMaxTotalGiftMint(uint maxTotalGiftMint_) internal {
2988         maxTotalGiftMint = maxTotalGiftMint_;
2989     }
2990 
2991     function _mint(uint256 tokenId, address auth, uint authTokenId) internal virtual returns (address) {
2992         (bool suc, uint v) = allAuth.tryGet(auth);
2993         require(suc, "ERC721G: invalid auth erc721");
2994         require(v != 0, "ERC721G: invalid auth erc721");
2995         require(totalGiftMint+1 <= maxTotalGiftMint, "ERC721G: over max total mint limit");
2996         require(mintedQuantity[auth][authTokenId] < giftMintLimit, "ERC721G: mint too many");
2997         mintedQuantity[auth][authTokenId]++;
2998         totalGiftMint++;
2999         address miner = ERC721(auth).ownerOf(authTokenId);
3000         require(miner != address(0), "ERC721G: invalid miner");
3001         ERC721._mint(miner, tokenId);
3002         return miner;
3003     }
3004 
3005     function _getRecipient(address auth, uint authTokenId) internal virtual returns (address) {
3006         (bool suc, uint v) = allAuth.tryGet(auth);
3007         if (!suc || v == 0) {
3008             return address(0);
3009         }
3010 
3011         return ERC721(auth).ownerOf(authTokenId);
3012     }
3013 
3014 
3015     // ------------------- view function -------------------
3016     function getAllGiftAuth() public view override returns(Auth[] memory) {
3017         uint v;
3018         address erc721;
3019         Auth[] memory arr = new Auth[](allAuth.length());
3020         for (uint i = 0; i < allAuth.length(); i++) {
3021             (erc721, v) = allAuth.at(i);
3022             arr[i].erc721 = erc721;
3023             arr[i].isOpen = (v != 0);
3024             if (v == 0) {
3025                 continue;
3026             }
3027 
3028             arr[i].name = ERC721(erc721).name();
3029             arr[i].symbol = ERC721(erc721).symbol();
3030         }
3031 
3032         return arr;
3033     }
3034 
3035     function getGiftMintedQuantity(address auth, uint authTokenId) external view override returns (uint) {
3036         return mintedQuantity[auth][authTokenId];
3037     }
3038 
3039     function getGiftMintLimit() external view override returns (uint) {
3040         return giftMintLimit;
3041     }
3042 
3043     function getTotalGiftMint() external view override returns (uint) {
3044         return totalGiftMint;
3045     }
3046 
3047     function getMaxTotalGiftMint() external view override returns (uint) {
3048         return maxTotalGiftMint;
3049     }
3050 
3051     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
3052         return
3053         interfaceId == type(IERC721G).interfaceId ||
3054         super.supportsInterface(interfaceId);
3055     }
3056 }
3057 
3058 
3059 // File contracts/ERC721GWhitelistAuth/Lucky.sol
3060 
3061 
3062 pragma solidity ^0.8.0;
3063 
3064 
3065 
3066 
3067 
3068 
3069 
3070 // Lucky
3071 contract Lucky is DefaultOperatorFilterer, ILucky, Ownable, ERC721G, ReentrancyGuard {
3072 
3073     enum Mode { WHITELIST, BLUECHIP, SUPER }
3074 
3075     uint public maxTotalSupply = 10000;
3076     uint public totalSupply = 0;
3077 
3078     uint public whitelistMintLimit = 1;
3079     mapping(address => bool) public whitelistMinted;
3080 
3081     uint public bluechipMintLimit = 1;
3082 
3083     uint public firstStepMaxSupply = 3000;
3084 
3085     string public baseURI;
3086     bytes32 public merkleRoot;
3087 
3088     uint public startTime;
3089     Mode public mintMode = Mode.WHITELIST;
3090     address public superMinter;
3091 
3092     address public stakingPool;
3093 
3094     constructor(string memory name_, string memory symbol_, uint startTime_)
3095         ERC721G(name_, symbol_)
3096     {
3097         startTime = startTime_;
3098         ERC721G._setMaxTotalGiftMint(firstStepMaxSupply);
3099     }
3100 
3101     function setFirstStepMaxSupply(uint max) external onlyOwner {
3102         firstStepMaxSupply = max;
3103         ERC721G._setGiftMintLimit(firstStepMaxSupply);
3104     }
3105 
3106     function setStakingPool(address stakingPool_) external onlyOwner {
3107         stakingPool = stakingPool_;
3108     }
3109 
3110     function setBaseURI(string memory baseURI_) external onlyOwner {
3111         baseURI = baseURI_;
3112     }
3113 
3114     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
3115         merkleRoot = merkleRoot_;
3116     }
3117 
3118     function setStartTime(uint startTime_) external onlyOwner {
3119         startTime = startTime_;
3120     }
3121 
3122     function setMintMode(Mode mode_) external onlyOwner {
3123         mintMode = mode_;
3124     }
3125 
3126     function setWhitelistMintLimit(uint limit_) external onlyOwner {
3127         whitelistMintLimit = limit_;
3128     }
3129 
3130     function setBluechip(address erc721, bool isOpen) external onlyOwner {
3131         ERC721G._setGiftAuth(erc721, isOpen);
3132     }
3133 
3134     function setBluechipMintLimit(uint limit_) external onlyOwner {
3135         bluechipMintLimit = limit_;
3136         ERC721G._setGiftMintLimit(limit_);
3137     }
3138 
3139     function setBluechipMaxTotalMint(uint bluechipMaxTotalMint_) external onlyOwner {
3140         ERC721G._setMaxTotalGiftMint(bluechipMaxTotalMint_);
3141     }
3142 
3143     function setSuperMinter(address minter) external onlyOwner {
3144         superMinter = minter;
3145     }
3146 
3147     function whitelistMint(bytes32[] calldata proof) external nonReentrant {
3148         require(block.timestamp >= startTime, "not yet started");
3149         require(mintMode == Mode.WHITELIST, "invalid minting mode");
3150         require(totalSupply + whitelistMintLimit <= firstStepMaxSupply, "over first step max supply");
3151         require(totalSupply + whitelistMintLimit <= maxTotalSupply, "over total supply");
3152         require(!whitelistMinted[msg.sender], "minted already");
3153         require(MerkleProof.verify(proof, merkleRoot, _accountToMerkleLeaf(msg.sender)), "invalid whitelist proof");
3154 
3155         for (uint i = 0; i < whitelistMintLimit; i++) {
3156             ERC721._mint(msg.sender, totalSupply+i);
3157         }
3158 
3159         totalSupply += whitelistMintLimit;
3160         whitelistMinted[msg.sender] = true;
3161     }
3162 
3163     function bluechipMint(address bluechipERC721, uint bluechipTokenId) external nonReentrant {
3164         require(block.timestamp >= startTime, "not yet started");
3165         require(mintMode == Mode.BLUECHIP, "invalid minting mode");
3166         require(totalSupply + bluechipMintLimit <= firstStepMaxSupply, "over first step max supply");
3167         require(totalSupply + bluechipMintLimit <= maxTotalSupply, "over total supply");
3168 
3169         for (uint i = 0; i < bluechipMintLimit; i++) {
3170             ERC721G._mint(totalSupply+i, bluechipERC721, bluechipTokenId);
3171         }
3172 
3173         totalSupply += bluechipMintLimit;
3174     }
3175 
3176     function superMint(address to, uint quantity) external override nonReentrant {
3177         require(block.timestamp >= startTime, "not yet started");
3178         require(mintMode == Mode.SUPER, "invalid minting mode");
3179         require(msg.sender == superMinter, "invalid super minter");
3180         require(totalSupply + quantity <= maxTotalSupply, "over total supply");
3181 
3182         for (uint i = 0; i < quantity; i++) {
3183             ERC721._mint(to, totalSupply+i);
3184         }
3185 
3186         totalSupply += quantity;
3187     }
3188 
3189     // --------------------- internal function ---------------------
3190     function _transfer(address from, address to, uint256 tokenId) internal override {
3191         if(stakingPool != address(0)) {
3192             require(!IStakingPool(stakingPool).pined(tokenId), "token has been pined");
3193         }
3194 
3195         ERC721._transfer(from, to, tokenId);
3196     }
3197 
3198     function _baseURI() internal view override returns (string memory) {
3199         return baseURI;
3200     }
3201 
3202     function _accountToMerkleLeaf(address account) internal pure returns (bytes32) {
3203         return bytes32(uint256(uint160(account)));
3204     }
3205 
3206     // --------------------- DefaultOperatorFilterer ---------------------
3207     function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
3208         super.setApprovalForAll(operator, approved);
3209     }
3210 
3211     function approve(address operator, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
3212         super.approve(operator, tokenId);
3213     }
3214 
3215     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
3216         super.transferFrom(from, to, tokenId);
3217     }
3218 
3219     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
3220         super.safeTransferFrom(from, to, tokenId);
3221     }
3222 
3223     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3224         public
3225         override(ERC721, IERC721)
3226         onlyAllowedOperator(from)
3227     {
3228         super.safeTransferFrom(from, to, tokenId, data);
3229     }
3230 }