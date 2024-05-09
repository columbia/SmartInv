1 // File: contracts/IDelegationRegistry.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 /**
7  * @title An immutable registry contract to be deployed as a standalone primitive
8  * @dev See EIP-5639, new project launches can read previous cold wallet -> hot wallet delegations
9  * from here and integrate those permissions into their flow
10  */
11 interface IDelegationRegistry {
12     /// @notice Delegation type
13     enum DelegationType {
14         NONE,
15         ALL,
16         CONTRACT,
17         TOKEN
18     }
19 
20     /// @notice Info about a single delegation, used for onchain enumeration
21     struct DelegationInfo {
22         DelegationType type_;
23         address vault;
24         address delegate;
25         address contract_;
26         uint256 tokenId;
27     }
28 
29     /// @notice Info about a single contract-level delegation
30     struct ContractDelegation {
31         address contract_;
32         address delegate;
33     }
34 
35     /// @notice Info about a single token-level delegation
36     struct TokenDelegation {
37         address contract_;
38         uint256 tokenId;
39         address delegate;
40     }
41 
42     /// @notice Emitted when a user delegates their entire wallet
43     event DelegateForAll(address vault, address delegate, bool value);
44 
45     /// @notice Emitted when a user delegates a specific contract
46     event DelegateForContract(address vault, address delegate, address contract_, bool value);
47 
48     /// @notice Emitted when a user delegates a specific token
49     event DelegateForToken(address vault, address delegate, address contract_, uint256 tokenId, bool value);
50 
51     /// @notice Emitted when a user revokes all delegations
52     event RevokeAllDelegates(address vault);
53 
54     /// @notice Emitted when a user revoes all delegations for a given delegate
55     event RevokeDelegate(address vault, address delegate);
56 
57     /**
58      * -----------  WRITE -----------
59      */
60 
61     /**
62      * @notice Allow the delegate to act on your behalf for all contracts
63      * @param delegate The hotwallet to act on your behalf
64      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
65      */
66     function delegateForAll(address delegate, bool value) external;
67 
68     /**
69      * @notice Allow the delegate to act on your behalf for a specific contract
70      * @param delegate The hotwallet to act on your behalf
71      * @param contract_ The address for the contract you're delegating
72      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
73      */
74     function delegateForContract(address delegate, address contract_, bool value) external;
75 
76     /**
77      * @notice Allow the delegate to act on your behalf for a specific token
78      * @param delegate The hotwallet to act on your behalf
79      * @param contract_ The address for the contract you're delegating
80      * @param tokenId The token id for the token you're delegating
81      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
82      */
83     function delegateForToken(address delegate, address contract_, uint256 tokenId, bool value) external;
84 
85     /**
86      * @notice Revoke all delegates
87      */
88     function revokeAllDelegates() external;
89 
90     /**
91      * @notice Revoke a specific delegate for all their permissions
92      * @param delegate The hotwallet to revoke
93      */
94     function revokeDelegate(address delegate) external;
95 
96     /**
97      * @notice Remove yourself as a delegate for a specific vault
98      * @param vault The vault which delegated to the msg.sender, and should be removed
99      */
100     function revokeSelf(address vault) external;
101 
102     /**
103      * -----------  READ -----------
104      */
105 
106     /**
107      * @notice Returns all active delegations a given delegate is able to claim on behalf of
108      * @param delegate The delegate that you would like to retrieve delegations for
109      * @return info Array of DelegationInfo structs
110      */
111     function getDelegationsByDelegate(address delegate) external view returns (DelegationInfo[] memory);
112 
113     /**
114      * @notice Returns an array of wallet-level delegates for a given vault
115      * @param vault The cold wallet who issued the delegation
116      * @return addresses Array of wallet-level delegates for a given vault
117      */
118     function getDelegatesForAll(address vault) external view returns (address[] memory);
119 
120     /**
121      * @notice Returns an array of contract-level delegates for a given vault and contract
122      * @param vault The cold wallet who issued the delegation
123      * @param contract_ The address for the contract you're delegating
124      * @return addresses Array of contract-level delegates for a given vault and contract
125      */
126     function getDelegatesForContract(address vault, address contract_) external view returns (address[] memory);
127 
128     /**
129      * @notice Returns an array of contract-level delegates for a given vault's token
130      * @param vault The cold wallet who issued the delegation
131      * @param contract_ The address for the contract holding the token
132      * @param tokenId The token id for the token you're delegating
133      * @return addresses Array of contract-level delegates for a given vault's token
134      */
135     function getDelegatesForToken(address vault, address contract_, uint256 tokenId)
136         external
137         view
138         returns (address[] memory);
139 
140     /**
141      * @notice Returns all contract-level delegations for a given vault
142      * @param vault The cold wallet who issued the delegations
143      * @return delegations Array of ContractDelegation structs
144      */
145     function getContractLevelDelegations(address vault)
146         external
147         view
148         returns (ContractDelegation[] memory delegations);
149 
150     /**
151      * @notice Returns all token-level delegations for a given vault
152      * @param vault The cold wallet who issued the delegations
153      * @return delegations Array of TokenDelegation structs
154      */
155     function getTokenLevelDelegations(address vault) external view returns (TokenDelegation[] memory delegations);
156 
157     /**
158      * @notice Returns true if the address is delegated to act on the entire vault
159      * @param delegate The hotwallet to act on your behalf
160      * @param vault The cold wallet who issued the delegation
161      */
162     function checkDelegateForAll(address delegate, address vault) external view returns (bool);
163 
164     /**
165      * @notice Returns true if the address is delegated to act on your behalf for a token contract or an entire vault
166      * @param delegate The hotwallet to act on your behalf
167      * @param contract_ The address for the contract you're delegating
168      * @param vault The cold wallet who issued the delegation
169      */
170     function checkDelegateForContract(address delegate, address vault, address contract_)
171         external
172         view
173         returns (bool);
174 
175     /**
176      * @notice Returns true if the address is delegated to act on your behalf for a specific token, the token's contract or an entire vault
177      * @param delegate The hotwallet to act on your behalf
178      * @param contract_ The address for the contract you're delegating
179      * @param tokenId The token id for the token you're delegating
180      * @param vault The cold wallet who issued the delegation
181      */
182     function checkDelegateForToken(address delegate, address vault, address contract_, uint256 tokenId)
183         external
184         view
185         returns (bool);
186 }
187 
188 // File: contracts/filter/IOperatorFilterRegistry.sol
189 
190 
191 pragma solidity ^0.8.13;
192 
193 interface IOperatorFilterRegistry {
194     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
195     function register(address registrant) external;
196     function registerAndSubscribe(address registrant, address subscription) external;
197     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
198     function unregister(address addr) external;
199     function updateOperator(address registrant, address operator, bool filtered) external;
200     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
201     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
202     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
203     function subscribe(address registrant, address registrantToSubscribe) external;
204     function unsubscribe(address registrant, bool copyExistingEntries) external;
205     function subscriptionOf(address addr) external returns (address registrant);
206     function subscribers(address registrant) external returns (address[] memory);
207     function subscriberAt(address registrant, uint256 index) external returns (address);
208     function copyEntriesOf(address registrant, address registrantToCopy) external;
209     function isOperatorFiltered(address registrant, address operator) external returns (bool);
210     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
211     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
212     function filteredOperators(address addr) external returns (address[] memory);
213     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
214     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
215     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
216     function isRegistered(address addr) external returns (bool);
217     function codeHashOf(address addr) external returns (bytes32);
218 }
219 // File: contracts/filter/OperatorFilterer.sol
220 
221 
222 pragma solidity ^0.8.13;
223 
224 
225 /**
226  * @title  OperatorFilterer
227  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
228  *         registrant's entries in the OperatorFilterRegistry.
229  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
230  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
231  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
232  */
233 abstract contract OperatorFilterer {
234     error OperatorNotAllowed(address operator);
235 
236     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
237         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
238 
239     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
240         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
241         // will not revert, but the contract will need to be registered with the registry once it is deployed in
242         // order for the modifier to filter addresses.
243         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
244             if (subscribe) {
245                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
246             } else {
247                 if (subscriptionOrRegistrantToCopy != address(0)) {
248                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
249                 } else {
250                     OPERATOR_FILTER_REGISTRY.register(address(this));
251                 }
252             }
253         }
254     }
255 
256     modifier onlyAllowedOperator(address from) virtual {
257         // Allow spending tokens from addresses with balance
258         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
259         // from an EOA.
260         if (from != msg.sender) {
261             _checkFilterOperator(msg.sender);
262         }
263         _;
264     }
265 
266     modifier onlyAllowedOperatorApproval(address operator) virtual {
267         _checkFilterOperator(operator);
268         _;
269     }
270 
271     function _checkFilterOperator(address operator) internal view virtual {
272         // Check registry code length to facilitate testing in environments without a deployed registry.
273         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
274             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
275                 revert OperatorNotAllowed(operator);
276             }
277         }
278     }
279 }
280 // File: contracts/filter/DefaultOperatorFilterer.sol
281 
282 
283 pragma solidity ^0.8.13;
284 
285 
286 /**
287  * @title  DefaultOperatorFilterer
288  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
289  */
290 abstract contract DefaultOperatorFilterer is OperatorFilterer {
291     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
292 
293     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
294 }
295 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
296 
297 
298 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev These functions deal with verification of Merkle Tree proofs.
304  *
305  * The tree and the proofs can be generated using our
306  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
307  * You will find a quickstart guide in the readme.
308  *
309  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
310  * hashing, or use a hash function other than keccak256 for hashing leaves.
311  * This is because the concatenation of a sorted pair of internal nodes in
312  * the merkle tree could be reinterpreted as a leaf value.
313  * OpenZeppelin's JavaScript library generates merkle trees that are safe
314  * against this attack out of the box.
315  */
316 library MerkleProof {
317     /**
318      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
319      * defined by `root`. For this, a `proof` must be provided, containing
320      * sibling hashes on the branch from the leaf to the root of the tree. Each
321      * pair of leaves and each pair of pre-images are assumed to be sorted.
322      */
323     function verify(
324         bytes32[] memory proof,
325         bytes32 root,
326         bytes32 leaf
327     ) internal pure returns (bool) {
328         return processProof(proof, leaf) == root;
329     }
330 
331     /**
332      * @dev Calldata version of {verify}
333      *
334      * _Available since v4.7._
335      */
336     function verifyCalldata(
337         bytes32[] calldata proof,
338         bytes32 root,
339         bytes32 leaf
340     ) internal pure returns (bool) {
341         return processProofCalldata(proof, leaf) == root;
342     }
343 
344     /**
345      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
346      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
347      * hash matches the root of the tree. When processing the proof, the pairs
348      * of leafs & pre-images are assumed to be sorted.
349      *
350      * _Available since v4.4._
351      */
352     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
353         bytes32 computedHash = leaf;
354         for (uint256 i = 0; i < proof.length; i++) {
355             computedHash = _hashPair(computedHash, proof[i]);
356         }
357         return computedHash;
358     }
359 
360     /**
361      * @dev Calldata version of {processProof}
362      *
363      * _Available since v4.7._
364      */
365     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
366         bytes32 computedHash = leaf;
367         for (uint256 i = 0; i < proof.length; i++) {
368             computedHash = _hashPair(computedHash, proof[i]);
369         }
370         return computedHash;
371     }
372 
373     /**
374      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
375      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
376      *
377      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
378      *
379      * _Available since v4.7._
380      */
381     function multiProofVerify(
382         bytes32[] memory proof,
383         bool[] memory proofFlags,
384         bytes32 root,
385         bytes32[] memory leaves
386     ) internal pure returns (bool) {
387         return processMultiProof(proof, proofFlags, leaves) == root;
388     }
389 
390     /**
391      * @dev Calldata version of {multiProofVerify}
392      *
393      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
394      *
395      * _Available since v4.7._
396      */
397     function multiProofVerifyCalldata(
398         bytes32[] calldata proof,
399         bool[] calldata proofFlags,
400         bytes32 root,
401         bytes32[] memory leaves
402     ) internal pure returns (bool) {
403         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
404     }
405 
406     /**
407      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
408      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
409      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
410      * respectively.
411      *
412      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
413      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
414      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
415      *
416      * _Available since v4.7._
417      */
418     function processMultiProof(
419         bytes32[] memory proof,
420         bool[] memory proofFlags,
421         bytes32[] memory leaves
422     ) internal pure returns (bytes32 merkleRoot) {
423         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
424         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
425         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
426         // the merkle tree.
427         uint256 leavesLen = leaves.length;
428         uint256 totalHashes = proofFlags.length;
429 
430         // Check proof validity.
431         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
432 
433         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
434         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
435         bytes32[] memory hashes = new bytes32[](totalHashes);
436         uint256 leafPos = 0;
437         uint256 hashPos = 0;
438         uint256 proofPos = 0;
439         // At each step, we compute the next hash using two values:
440         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
441         //   get the next hash.
442         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
443         //   `proof` array.
444         for (uint256 i = 0; i < totalHashes; i++) {
445             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
446             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
447             hashes[i] = _hashPair(a, b);
448         }
449 
450         if (totalHashes > 0) {
451             return hashes[totalHashes - 1];
452         } else if (leavesLen > 0) {
453             return leaves[0];
454         } else {
455             return proof[0];
456         }
457     }
458 
459     /**
460      * @dev Calldata version of {processMultiProof}.
461      *
462      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
463      *
464      * _Available since v4.7._
465      */
466     function processMultiProofCalldata(
467         bytes32[] calldata proof,
468         bool[] calldata proofFlags,
469         bytes32[] memory leaves
470     ) internal pure returns (bytes32 merkleRoot) {
471         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
472         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
473         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
474         // the merkle tree.
475         uint256 leavesLen = leaves.length;
476         uint256 totalHashes = proofFlags.length;
477 
478         // Check proof validity.
479         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
480 
481         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
482         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
483         bytes32[] memory hashes = new bytes32[](totalHashes);
484         uint256 leafPos = 0;
485         uint256 hashPos = 0;
486         uint256 proofPos = 0;
487         // At each step, we compute the next hash using two values:
488         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
489         //   get the next hash.
490         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
491         //   `proof` array.
492         for (uint256 i = 0; i < totalHashes; i++) {
493             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
494             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
495             hashes[i] = _hashPair(a, b);
496         }
497 
498         if (totalHashes > 0) {
499             return hashes[totalHashes - 1];
500         } else if (leavesLen > 0) {
501             return leaves[0];
502         } else {
503             return proof[0];
504         }
505     }
506 
507     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
508         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
509     }
510 
511     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
512         /// @solidity memory-safe-assembly
513         assembly {
514             mstore(0x00, a)
515             mstore(0x20, b)
516             value := keccak256(0x00, 0x40)
517         }
518     }
519 }
520 
521 // File: contracts/lib/MerkleDistributor.sol
522 
523 
524 
525 pragma solidity ^0.8.0;
526 
527 
528 contract MerkleDistributor {
529     bytes32 public merkleRoot;
530     bool public allowListActive = false;
531 
532     mapping(address => uint256) private _allowListNumMinted;
533 
534     /**
535      * @dev emitted when an account has claimed some tokens
536      */
537     event Claimed(address indexed account, uint256 amount);
538 
539     /**
540      * @dev emitted when the merkle root has changed
541      */
542     event MerkleRootChanged(bytes32 merkleRoot);
543 
544     /**
545      * @dev throws when allow list is not active
546      */
547     modifier isAllowListActive() {
548         require(allowListActive, 'Allow list is not active');
549         _;
550     }
551 
552     /**
553      * @dev throws when number of tokens exceeds total token amount
554      */
555     modifier tokensAvailable(
556         address to,
557         uint256 numberOfTokens,
558         uint256 totalTokenAmount
559     ) {
560         uint256 claimed = getAllowListMinted(to);
561         require(claimed + numberOfTokens <= totalTokenAmount, 'Purchase would exceed number of tokens allotted');
562         _;
563     }
564 
565     /**
566      * @dev throws when parameters sent by claimer is incorrect
567      */
568     modifier ableToClaim(address claimer, bytes32[] memory proof) {
569         require(onAllowList(claimer, proof), 'Not on allow list');
570         _;
571     }
572 
573     /**
574      * @dev sets the state of the allow list
575      */
576     function _setAllowListActive(bool allowListActive_) internal virtual {
577         allowListActive = allowListActive_;
578     }
579 
580     /**
581      * @dev sets the merkle root
582      */
583     function _setAllowList(bytes32 merkleRoot_) internal virtual {
584         merkleRoot = merkleRoot_;
585 
586         emit MerkleRootChanged(merkleRoot);
587     }
588 
589     /**
590      * @dev adds the number of tokens to the incoming address
591      */
592     function _setAllowListMinted(address to, uint256 numberOfTokens) internal virtual {
593         _allowListNumMinted[to] += numberOfTokens;
594 
595         emit Claimed(to, numberOfTokens);
596     }
597 
598     /**
599      * @dev gets the number of tokens from the address
600      */
601     function getAllowListMinted(address from) public view virtual returns (uint256) {
602         return _allowListNumMinted[from];
603     }
604 
605     /**
606      * @dev checks if the claimer has a valid proof
607      */
608     function onAllowList(address claimer, bytes32[] memory proof) public view returns (bool) {
609         bytes32 leaf = keccak256(abi.encodePacked(claimer));
610         return MerkleProof.verify(proof, merkleRoot, leaf);
611     }
612 }
613 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
614 
615 
616 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Contract module that helps prevent reentrant calls to a function.
622  *
623  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
624  * available, which can be applied to functions to make sure there are no nested
625  * (reentrant) calls to them.
626  *
627  * Note that because there is a single `nonReentrant` guard, functions marked as
628  * `nonReentrant` may not call one another. This can be worked around by making
629  * those functions `private`, and then adding `external` `nonReentrant` entry
630  * points to them.
631  *
632  * TIP: If you would like to learn more about reentrancy and alternative ways
633  * to protect against it, check out our blog post
634  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
635  */
636 abstract contract ReentrancyGuard {
637     // Booleans are more expensive than uint256 or any type that takes up a full
638     // word because each write operation emits an extra SLOAD to first read the
639     // slot's contents, replace the bits taken up by the boolean, and then write
640     // back. This is the compiler's defense against contract upgrades and
641     // pointer aliasing, and it cannot be disabled.
642 
643     // The values being non-zero value makes deployment a bit more expensive,
644     // but in exchange the refund on every call to nonReentrant will be lower in
645     // amount. Since refunds are capped to a percentage of the total
646     // transaction's gas, it is best to keep them low in cases like this one, to
647     // increase the likelihood of the full refund coming into effect.
648     uint256 private constant _NOT_ENTERED = 1;
649     uint256 private constant _ENTERED = 2;
650 
651     uint256 private _status;
652 
653     constructor() {
654         _status = _NOT_ENTERED;
655     }
656 
657     /**
658      * @dev Prevents a contract from calling itself, directly or indirectly.
659      * Calling a `nonReentrant` function from another `nonReentrant`
660      * function is not supported. It is possible to prevent this from happening
661      * by making the `nonReentrant` function external, and making it call a
662      * `private` function that does the actual work.
663      */
664     modifier nonReentrant() {
665         _nonReentrantBefore();
666         _;
667         _nonReentrantAfter();
668     }
669 
670     function _nonReentrantBefore() private {
671         // On the first call to nonReentrant, _status will be _NOT_ENTERED
672         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
673 
674         // Any calls to nonReentrant after this point will fail
675         _status = _ENTERED;
676     }
677 
678     function _nonReentrantAfter() private {
679         // By storing the original value once again, a refund is triggered (see
680         // https://eips.ethereum.org/EIPS/eip-2200)
681         _status = _NOT_ENTERED;
682     }
683 }
684 
685 // File: @openzeppelin/contracts/utils/Address.sol
686 
687 
688 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
689 
690 pragma solidity ^0.8.1;
691 
692 /**
693  * @dev Collection of functions related to the address type
694  */
695 library Address {
696     /**
697      * @dev Returns true if `account` is a contract.
698      *
699      * [IMPORTANT]
700      * ====
701      * It is unsafe to assume that an address for which this function returns
702      * false is an externally-owned account (EOA) and not a contract.
703      *
704      * Among others, `isContract` will return false for the following
705      * types of addresses:
706      *
707      *  - an externally-owned account
708      *  - a contract in construction
709      *  - an address where a contract will be created
710      *  - an address where a contract lived, but was destroyed
711      * ====
712      *
713      * [IMPORTANT]
714      * ====
715      * You shouldn't rely on `isContract` to protect against flash loan attacks!
716      *
717      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
718      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
719      * constructor.
720      * ====
721      */
722     function isContract(address account) internal view returns (bool) {
723         // This method relies on extcodesize/address.code.length, which returns 0
724         // for contracts in construction, since the code is only stored at the end
725         // of the constructor execution.
726 
727         return account.code.length > 0;
728     }
729 
730     /**
731      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
732      * `recipient`, forwarding all available gas and reverting on errors.
733      *
734      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
735      * of certain opcodes, possibly making contracts go over the 2300 gas limit
736      * imposed by `transfer`, making them unable to receive funds via
737      * `transfer`. {sendValue} removes this limitation.
738      *
739      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
740      *
741      * IMPORTANT: because control is transferred to `recipient`, care must be
742      * taken to not create reentrancy vulnerabilities. Consider using
743      * {ReentrancyGuard} or the
744      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
745      */
746     function sendValue(address payable recipient, uint256 amount) internal {
747         require(address(this).balance >= amount, "Address: insufficient balance");
748 
749         (bool success, ) = recipient.call{value: amount}("");
750         require(success, "Address: unable to send value, recipient may have reverted");
751     }
752 
753     /**
754      * @dev Performs a Solidity function call using a low level `call`. A
755      * plain `call` is an unsafe replacement for a function call: use this
756      * function instead.
757      *
758      * If `target` reverts with a revert reason, it is bubbled up by this
759      * function (like regular Solidity function calls).
760      *
761      * Returns the raw returned data. To convert to the expected return value,
762      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
763      *
764      * Requirements:
765      *
766      * - `target` must be a contract.
767      * - calling `target` with `data` must not revert.
768      *
769      * _Available since v3.1._
770      */
771     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
772         return functionCall(target, data, "Address: low-level call failed");
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
777      * `errorMessage` as a fallback revert reason when `target` reverts.
778      *
779      * _Available since v3.1._
780      */
781     function functionCall(
782         address target,
783         bytes memory data,
784         string memory errorMessage
785     ) internal returns (bytes memory) {
786         return functionCallWithValue(target, data, 0, errorMessage);
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
791      * but also transferring `value` wei to `target`.
792      *
793      * Requirements:
794      *
795      * - the calling contract must have an ETH balance of at least `value`.
796      * - the called Solidity function must be `payable`.
797      *
798      * _Available since v3.1._
799      */
800     function functionCallWithValue(
801         address target,
802         bytes memory data,
803         uint256 value
804     ) internal returns (bytes memory) {
805         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
806     }
807 
808     /**
809      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
810      * with `errorMessage` as a fallback revert reason when `target` reverts.
811      *
812      * _Available since v3.1._
813      */
814     function functionCallWithValue(
815         address target,
816         bytes memory data,
817         uint256 value,
818         string memory errorMessage
819     ) internal returns (bytes memory) {
820         require(address(this).balance >= value, "Address: insufficient balance for call");
821         require(isContract(target), "Address: call to non-contract");
822 
823         (bool success, bytes memory returndata) = target.call{value: value}(data);
824         return verifyCallResult(success, returndata, errorMessage);
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
829      * but performing a static call.
830      *
831      * _Available since v3.3._
832      */
833     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
834         return functionStaticCall(target, data, "Address: low-level static call failed");
835     }
836 
837     /**
838      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
839      * but performing a static call.
840      *
841      * _Available since v3.3._
842      */
843     function functionStaticCall(
844         address target,
845         bytes memory data,
846         string memory errorMessage
847     ) internal view returns (bytes memory) {
848         require(isContract(target), "Address: static call to non-contract");
849 
850         (bool success, bytes memory returndata) = target.staticcall(data);
851         return verifyCallResult(success, returndata, errorMessage);
852     }
853 
854     /**
855      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
856      * but performing a delegate call.
857      *
858      * _Available since v3.4._
859      */
860     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
861         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
862     }
863 
864     /**
865      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
866      * but performing a delegate call.
867      *
868      * _Available since v3.4._
869      */
870     function functionDelegateCall(
871         address target,
872         bytes memory data,
873         string memory errorMessage
874     ) internal returns (bytes memory) {
875         require(isContract(target), "Address: delegate call to non-contract");
876 
877         (bool success, bytes memory returndata) = target.delegatecall(data);
878         return verifyCallResult(success, returndata, errorMessage);
879     }
880 
881     /**
882      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
883      * revert reason using the provided one.
884      *
885      * _Available since v4.3._
886      */
887     function verifyCallResult(
888         bool success,
889         bytes memory returndata,
890         string memory errorMessage
891     ) internal pure returns (bytes memory) {
892         if (success) {
893             return returndata;
894         } else {
895             // Look for revert reason and bubble it up if present
896             if (returndata.length > 0) {
897                 // The easiest way to bubble the revert reason is using memory via assembly
898                 /// @solidity memory-safe-assembly
899                 assembly {
900                     let returndata_size := mload(returndata)
901                     revert(add(32, returndata), returndata_size)
902                 }
903             } else {
904                 revert(errorMessage);
905             }
906         }
907     }
908 }
909 
910 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
911 
912 
913 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
914 
915 pragma solidity ^0.8.0;
916 
917 /**
918  * @dev Interface of the ERC165 standard, as defined in the
919  * https://eips.ethereum.org/EIPS/eip-165[EIP].
920  *
921  * Implementers can declare support of contract interfaces, which can then be
922  * queried by others ({ERC165Checker}).
923  *
924  * For an implementation, see {ERC165}.
925  */
926 interface IERC165 {
927     /**
928      * @dev Returns true if this contract implements the interface defined by
929      * `interfaceId`. See the corresponding
930      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
931      * to learn more about how these ids are created.
932      *
933      * This function call must use less than 30 000 gas.
934      */
935     function supportsInterface(bytes4 interfaceId) external view returns (bool);
936 }
937 
938 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
939 
940 
941 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 
946 /**
947  * @dev Implementation of the {IERC165} interface.
948  *
949  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
950  * for the additional interface id that will be supported. For example:
951  *
952  * ```solidity
953  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
954  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
955  * }
956  * ```
957  *
958  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
959  */
960 abstract contract ERC165 is IERC165 {
961     /**
962      * @dev See {IERC165-supportsInterface}.
963      */
964     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
965         return interfaceId == type(IERC165).interfaceId;
966     }
967 }
968 
969 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
970 
971 
972 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 
977 /**
978  * @dev _Available since v3.1._
979  */
980 interface IERC1155Receiver is IERC165 {
981     /**
982      * @dev Handles the receipt of a single ERC1155 token type. This function is
983      * called at the end of a `safeTransferFrom` after the balance has been updated.
984      *
985      * NOTE: To accept the transfer, this must return
986      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
987      * (i.e. 0xf23a6e61, or its own function selector).
988      *
989      * @param operator The address which initiated the transfer (i.e. msg.sender)
990      * @param from The address which previously owned the token
991      * @param id The ID of the token being transferred
992      * @param value The amount of tokens being transferred
993      * @param data Additional data with no specified format
994      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
995      */
996     function onERC1155Received(
997         address operator,
998         address from,
999         uint256 id,
1000         uint256 value,
1001         bytes calldata data
1002     ) external returns (bytes4);
1003 
1004     /**
1005      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1006      * is called at the end of a `safeBatchTransferFrom` after the balances have
1007      * been updated.
1008      *
1009      * NOTE: To accept the transfer(s), this must return
1010      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1011      * (i.e. 0xbc197c81, or its own function selector).
1012      *
1013      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1014      * @param from The address which previously owned the token
1015      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1016      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1017      * @param data Additional data with no specified format
1018      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1019      */
1020     function onERC1155BatchReceived(
1021         address operator,
1022         address from,
1023         uint256[] calldata ids,
1024         uint256[] calldata values,
1025         bytes calldata data
1026     ) external returns (bytes4);
1027 }
1028 
1029 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1030 
1031 
1032 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 
1037 /**
1038  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1039  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1040  *
1041  * _Available since v3.1._
1042  */
1043 interface IERC1155 is IERC165 {
1044     /**
1045      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1046      */
1047     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1048 
1049     /**
1050      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1051      * transfers.
1052      */
1053     event TransferBatch(
1054         address indexed operator,
1055         address indexed from,
1056         address indexed to,
1057         uint256[] ids,
1058         uint256[] values
1059     );
1060 
1061     /**
1062      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1063      * `approved`.
1064      */
1065     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1066 
1067     /**
1068      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1069      *
1070      * If an {URI} event was emitted for `id`, the standard
1071      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1072      * returned by {IERC1155MetadataURI-uri}.
1073      */
1074     event URI(string value, uint256 indexed id);
1075 
1076     /**
1077      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1078      *
1079      * Requirements:
1080      *
1081      * - `account` cannot be the zero address.
1082      */
1083     function balanceOf(address account, uint256 id) external view returns (uint256);
1084 
1085     /**
1086      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1087      *
1088      * Requirements:
1089      *
1090      * - `accounts` and `ids` must have the same length.
1091      */
1092     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1093         external
1094         view
1095         returns (uint256[] memory);
1096 
1097     /**
1098      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1099      *
1100      * Emits an {ApprovalForAll} event.
1101      *
1102      * Requirements:
1103      *
1104      * - `operator` cannot be the caller.
1105      */
1106     function setApprovalForAll(address operator, bool approved) external;
1107 
1108     /**
1109      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1110      *
1111      * See {setApprovalForAll}.
1112      */
1113     function isApprovedForAll(address account, address operator) external view returns (bool);
1114 
1115     /**
1116      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1117      *
1118      * Emits a {TransferSingle} event.
1119      *
1120      * Requirements:
1121      *
1122      * - `to` cannot be the zero address.
1123      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1124      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1125      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1126      * acceptance magic value.
1127      */
1128     function safeTransferFrom(
1129         address from,
1130         address to,
1131         uint256 id,
1132         uint256 amount,
1133         bytes calldata data
1134     ) external;
1135 
1136     /**
1137      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1138      *
1139      * Emits a {TransferBatch} event.
1140      *
1141      * Requirements:
1142      *
1143      * - `ids` and `amounts` must have the same length.
1144      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1145      * acceptance magic value.
1146      */
1147     function safeBatchTransferFrom(
1148         address from,
1149         address to,
1150         uint256[] calldata ids,
1151         uint256[] calldata amounts,
1152         bytes calldata data
1153     ) external;
1154 }
1155 
1156 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1157 
1158 
1159 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1160 
1161 pragma solidity ^0.8.0;
1162 
1163 
1164 /**
1165  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1166  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1167  *
1168  * _Available since v3.1._
1169  */
1170 interface IERC1155MetadataURI is IERC1155 {
1171     /**
1172      * @dev Returns the URI for token type `id`.
1173      *
1174      * If the `\{id\}` substring is present in the URI, it must be replaced by
1175      * clients with the actual token type ID.
1176      */
1177     function uri(uint256 id) external view returns (string memory);
1178 }
1179 
1180 // File: @openzeppelin/contracts/utils/Context.sol
1181 
1182 
1183 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 /**
1188  * @dev Provides information about the current execution context, including the
1189  * sender of the transaction and its data. While these are generally available
1190  * via msg.sender and msg.data, they should not be accessed in such a direct
1191  * manner, since when dealing with meta-transactions the account sending and
1192  * paying for execution may not be the actual sender (as far as an application
1193  * is concerned).
1194  *
1195  * This contract is only required for intermediate, library-like contracts.
1196  */
1197 abstract contract Context {
1198     function _msgSender() internal view virtual returns (address) {
1199         return msg.sender;
1200     }
1201 
1202     function _msgData() internal view virtual returns (bytes calldata) {
1203         return msg.data;
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1208 
1209 
1210 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 
1216 
1217 
1218 
1219 
1220 /**
1221  * @dev Implementation of the basic standard multi-token.
1222  * See https://eips.ethereum.org/EIPS/eip-1155
1223  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1224  *
1225  * _Available since v3.1._
1226  */
1227 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1228     using Address for address;
1229 
1230     // Mapping from token ID to account balances
1231     mapping(uint256 => mapping(address => uint256)) private _balances;
1232 
1233     // Mapping from account to operator approvals
1234     mapping(address => mapping(address => bool)) private _operatorApprovals;
1235 
1236     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1237     string private _uri;
1238 
1239     /**
1240      * @dev See {_setURI}.
1241      */
1242     constructor(string memory uri_) {
1243         _setURI(uri_);
1244     }
1245 
1246     /**
1247      * @dev See {IERC165-supportsInterface}.
1248      */
1249     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1250         return
1251             interfaceId == type(IERC1155).interfaceId ||
1252             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1253             super.supportsInterface(interfaceId);
1254     }
1255 
1256     /**
1257      * @dev See {IERC1155MetadataURI-uri}.
1258      *
1259      * This implementation returns the same URI for *all* token types. It relies
1260      * on the token type ID substitution mechanism
1261      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1262      *
1263      * Clients calling this function must replace the `\{id\}` substring with the
1264      * actual token type ID.
1265      */
1266     function uri(uint256) public view virtual override returns (string memory) {
1267         return _uri;
1268     }
1269 
1270     /**
1271      * @dev See {IERC1155-balanceOf}.
1272      *
1273      * Requirements:
1274      *
1275      * - `account` cannot be the zero address.
1276      */
1277     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1278         require(account != address(0), "ERC1155: address zero is not a valid owner");
1279         return _balances[id][account];
1280     }
1281 
1282     /**
1283      * @dev See {IERC1155-balanceOfBatch}.
1284      *
1285      * Requirements:
1286      *
1287      * - `accounts` and `ids` must have the same length.
1288      */
1289     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1290         public
1291         view
1292         virtual
1293         override
1294         returns (uint256[] memory)
1295     {
1296         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1297 
1298         uint256[] memory batchBalances = new uint256[](accounts.length);
1299 
1300         for (uint256 i = 0; i < accounts.length; ++i) {
1301             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1302         }
1303 
1304         return batchBalances;
1305     }
1306 
1307     /**
1308      * @dev See {IERC1155-setApprovalForAll}.
1309      */
1310     function setApprovalForAll(address operator, bool approved) public virtual override {
1311         _setApprovalForAll(_msgSender(), operator, approved);
1312     }
1313 
1314     /**
1315      * @dev See {IERC1155-isApprovedForAll}.
1316      */
1317     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1318         return _operatorApprovals[account][operator];
1319     }
1320 
1321     /**
1322      * @dev See {IERC1155-safeTransferFrom}.
1323      */
1324     function safeTransferFrom(
1325         address from,
1326         address to,
1327         uint256 id,
1328         uint256 amount,
1329         bytes memory data
1330     ) public virtual override {
1331         require(
1332             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1333             "ERC1155: caller is not token owner nor approved"
1334         );
1335         _safeTransferFrom(from, to, id, amount, data);
1336     }
1337 
1338     /**
1339      * @dev See {IERC1155-safeBatchTransferFrom}.
1340      */
1341     function safeBatchTransferFrom(
1342         address from,
1343         address to,
1344         uint256[] memory ids,
1345         uint256[] memory amounts,
1346         bytes memory data
1347     ) public virtual override {
1348         require(
1349             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1350             "ERC1155: caller is not token owner nor approved"
1351         );
1352         _safeBatchTransferFrom(from, to, ids, amounts, data);
1353     }
1354 
1355     /**
1356      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1357      *
1358      * Emits a {TransferSingle} event.
1359      *
1360      * Requirements:
1361      *
1362      * - `to` cannot be the zero address.
1363      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1364      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1365      * acceptance magic value.
1366      */
1367     function _safeTransferFrom(
1368         address from,
1369         address to,
1370         uint256 id,
1371         uint256 amount,
1372         bytes memory data
1373     ) internal virtual {
1374         require(to != address(0), "ERC1155: transfer to the zero address");
1375 
1376         address operator = _msgSender();
1377         uint256[] memory ids = _asSingletonArray(id);
1378         uint256[] memory amounts = _asSingletonArray(amount);
1379 
1380         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1381 
1382         uint256 fromBalance = _balances[id][from];
1383         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1384         unchecked {
1385             _balances[id][from] = fromBalance - amount;
1386         }
1387         _balances[id][to] += amount;
1388 
1389         emit TransferSingle(operator, from, to, id, amount);
1390 
1391         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1392 
1393         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1394     }
1395 
1396     /**
1397      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1398      *
1399      * Emits a {TransferBatch} event.
1400      *
1401      * Requirements:
1402      *
1403      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1404      * acceptance magic value.
1405      */
1406     function _safeBatchTransferFrom(
1407         address from,
1408         address to,
1409         uint256[] memory ids,
1410         uint256[] memory amounts,
1411         bytes memory data
1412     ) internal virtual {
1413         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1414         require(to != address(0), "ERC1155: transfer to the zero address");
1415 
1416         address operator = _msgSender();
1417 
1418         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1419 
1420         for (uint256 i = 0; i < ids.length; ++i) {
1421             uint256 id = ids[i];
1422             uint256 amount = amounts[i];
1423 
1424             uint256 fromBalance = _balances[id][from];
1425             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1426             unchecked {
1427                 _balances[id][from] = fromBalance - amount;
1428             }
1429             _balances[id][to] += amount;
1430         }
1431 
1432         emit TransferBatch(operator, from, to, ids, amounts);
1433 
1434         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1435 
1436         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1437     }
1438 
1439     /**
1440      * @dev Sets a new URI for all token types, by relying on the token type ID
1441      * substitution mechanism
1442      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1443      *
1444      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1445      * URI or any of the amounts in the JSON file at said URI will be replaced by
1446      * clients with the token type ID.
1447      *
1448      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1449      * interpreted by clients as
1450      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1451      * for token type ID 0x4cce0.
1452      *
1453      * See {uri}.
1454      *
1455      * Because these URIs cannot be meaningfully represented by the {URI} event,
1456      * this function emits no events.
1457      */
1458     function _setURI(string memory newuri) internal virtual {
1459         _uri = newuri;
1460     }
1461 
1462     /**
1463      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1464      *
1465      * Emits a {TransferSingle} event.
1466      *
1467      * Requirements:
1468      *
1469      * - `to` cannot be the zero address.
1470      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1471      * acceptance magic value.
1472      */
1473     function _mint(
1474         address to,
1475         uint256 id,
1476         uint256 amount,
1477         bytes memory data
1478     ) internal virtual {
1479         require(to != address(0), "ERC1155: mint to the zero address");
1480 
1481         address operator = _msgSender();
1482         uint256[] memory ids = _asSingletonArray(id);
1483         uint256[] memory amounts = _asSingletonArray(amount);
1484 
1485         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1486 
1487         _balances[id][to] += amount;
1488         emit TransferSingle(operator, address(0), to, id, amount);
1489 
1490         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1491 
1492         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1493     }
1494 
1495     /**
1496      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1497      *
1498      * Emits a {TransferBatch} event.
1499      *
1500      * Requirements:
1501      *
1502      * - `ids` and `amounts` must have the same length.
1503      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1504      * acceptance magic value.
1505      */
1506     function _mintBatch(
1507         address to,
1508         uint256[] memory ids,
1509         uint256[] memory amounts,
1510         bytes memory data
1511     ) internal virtual {
1512         require(to != address(0), "ERC1155: mint to the zero address");
1513         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1514 
1515         address operator = _msgSender();
1516 
1517         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1518 
1519         for (uint256 i = 0; i < ids.length; i++) {
1520             _balances[ids[i]][to] += amounts[i];
1521         }
1522 
1523         emit TransferBatch(operator, address(0), to, ids, amounts);
1524 
1525         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1526 
1527         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1528     }
1529 
1530     /**
1531      * @dev Destroys `amount` tokens of token type `id` from `from`
1532      *
1533      * Emits a {TransferSingle} event.
1534      *
1535      * Requirements:
1536      *
1537      * - `from` cannot be the zero address.
1538      * - `from` must have at least `amount` tokens of token type `id`.
1539      */
1540     function _burn(
1541         address from,
1542         uint256 id,
1543         uint256 amount
1544     ) internal virtual {
1545         require(from != address(0), "ERC1155: burn from the zero address");
1546 
1547         address operator = _msgSender();
1548         uint256[] memory ids = _asSingletonArray(id);
1549         uint256[] memory amounts = _asSingletonArray(amount);
1550 
1551         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1552 
1553         uint256 fromBalance = _balances[id][from];
1554         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1555         unchecked {
1556             _balances[id][from] = fromBalance - amount;
1557         }
1558 
1559         emit TransferSingle(operator, from, address(0), id, amount);
1560 
1561         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1562     }
1563 
1564     /**
1565      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1566      *
1567      * Emits a {TransferBatch} event.
1568      *
1569      * Requirements:
1570      *
1571      * - `ids` and `amounts` must have the same length.
1572      */
1573     function _burnBatch(
1574         address from,
1575         uint256[] memory ids,
1576         uint256[] memory amounts
1577     ) internal virtual {
1578         require(from != address(0), "ERC1155: burn from the zero address");
1579         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1580 
1581         address operator = _msgSender();
1582 
1583         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1584 
1585         for (uint256 i = 0; i < ids.length; i++) {
1586             uint256 id = ids[i];
1587             uint256 amount = amounts[i];
1588 
1589             uint256 fromBalance = _balances[id][from];
1590             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1591             unchecked {
1592                 _balances[id][from] = fromBalance - amount;
1593             }
1594         }
1595 
1596         emit TransferBatch(operator, from, address(0), ids, amounts);
1597 
1598         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1599     }
1600 
1601     /**
1602      * @dev Approve `operator` to operate on all of `owner` tokens
1603      *
1604      * Emits an {ApprovalForAll} event.
1605      */
1606     function _setApprovalForAll(
1607         address owner,
1608         address operator,
1609         bool approved
1610     ) internal virtual {
1611         require(owner != operator, "ERC1155: setting approval status for self");
1612         _operatorApprovals[owner][operator] = approved;
1613         emit ApprovalForAll(owner, operator, approved);
1614     }
1615 
1616     /**
1617      * @dev Hook that is called before any token transfer. This includes minting
1618      * and burning, as well as batched variants.
1619      *
1620      * The same hook is called on both single and batched variants. For single
1621      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1622      *
1623      * Calling conditions (for each `id` and `amount` pair):
1624      *
1625      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1626      * of token type `id` will be  transferred to `to`.
1627      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1628      * for `to`.
1629      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1630      * will be burned.
1631      * - `from` and `to` are never both zero.
1632      * - `ids` and `amounts` have the same, non-zero length.
1633      *
1634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1635      */
1636     function _beforeTokenTransfer(
1637         address operator,
1638         address from,
1639         address to,
1640         uint256[] memory ids,
1641         uint256[] memory amounts,
1642         bytes memory data
1643     ) internal virtual {}
1644 
1645     /**
1646      * @dev Hook that is called after any token transfer. This includes minting
1647      * and burning, as well as batched variants.
1648      *
1649      * The same hook is called on both single and batched variants. For single
1650      * transfers, the length of the `id` and `amount` arrays will be 1.
1651      *
1652      * Calling conditions (for each `id` and `amount` pair):
1653      *
1654      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1655      * of token type `id` will be  transferred to `to`.
1656      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1657      * for `to`.
1658      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1659      * will be burned.
1660      * - `from` and `to` are never both zero.
1661      * - `ids` and `amounts` have the same, non-zero length.
1662      *
1663      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1664      */
1665     function _afterTokenTransfer(
1666         address operator,
1667         address from,
1668         address to,
1669         uint256[] memory ids,
1670         uint256[] memory amounts,
1671         bytes memory data
1672     ) internal virtual {}
1673 
1674     function _doSafeTransferAcceptanceCheck(
1675         address operator,
1676         address from,
1677         address to,
1678         uint256 id,
1679         uint256 amount,
1680         bytes memory data
1681     ) private {
1682         if (to.isContract()) {
1683             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1684                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1685                     revert("ERC1155: ERC1155Receiver rejected tokens");
1686                 }
1687             } catch Error(string memory reason) {
1688                 revert(reason);
1689             } catch {
1690                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1691             }
1692         }
1693     }
1694 
1695     function _doSafeBatchTransferAcceptanceCheck(
1696         address operator,
1697         address from,
1698         address to,
1699         uint256[] memory ids,
1700         uint256[] memory amounts,
1701         bytes memory data
1702     ) private {
1703         if (to.isContract()) {
1704             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1705                 bytes4 response
1706             ) {
1707                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1708                     revert("ERC1155: ERC1155Receiver rejected tokens");
1709                 }
1710             } catch Error(string memory reason) {
1711                 revert(reason);
1712             } catch {
1713                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1714             }
1715         }
1716     }
1717 
1718     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1719         uint256[] memory array = new uint256[](1);
1720         array[0] = element;
1721 
1722         return array;
1723     }
1724 }
1725 
1726 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1727 
1728 
1729 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1730 
1731 pragma solidity ^0.8.0;
1732 
1733 
1734 /**
1735  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1736  * own tokens and those that they have been approved to use.
1737  *
1738  * _Available since v3.1._
1739  */
1740 abstract contract ERC1155Burnable is ERC1155 {
1741     function burn(
1742         address account,
1743         uint256 id,
1744         uint256 value
1745     ) public virtual {
1746         require(
1747             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1748             "ERC1155: caller is not token owner nor approved"
1749         );
1750 
1751         _burn(account, id, value);
1752     }
1753 
1754     function burnBatch(
1755         address account,
1756         uint256[] memory ids,
1757         uint256[] memory values
1758     ) public virtual {
1759         require(
1760             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1761             "ERC1155: caller is not token owner nor approved"
1762         );
1763 
1764         _burnBatch(account, ids, values);
1765     }
1766 }
1767 
1768 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1769 
1770 
1771 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1772 
1773 pragma solidity ^0.8.0;
1774 
1775 
1776 /**
1777  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1778  *
1779  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1780  * clearly identified. Note: While a totalSupply of 1 might mean the
1781  * corresponding is an NFT, there is no guarantees that no other token with the
1782  * same id are not going to be minted.
1783  */
1784 abstract contract ERC1155Supply is ERC1155 {
1785     mapping(uint256 => uint256) private _totalSupply;
1786 
1787     /**
1788      * @dev Total amount of tokens in with a given id.
1789      */
1790     function totalSupply(uint256 id) public view virtual returns (uint256) {
1791         return _totalSupply[id];
1792     }
1793 
1794     /**
1795      * @dev Indicates whether any token exist with a given id, or not.
1796      */
1797     function exists(uint256 id) public view virtual returns (bool) {
1798         return ERC1155Supply.totalSupply(id) > 0;
1799     }
1800 
1801     /**
1802      * @dev See {ERC1155-_beforeTokenTransfer}.
1803      */
1804     function _beforeTokenTransfer(
1805         address operator,
1806         address from,
1807         address to,
1808         uint256[] memory ids,
1809         uint256[] memory amounts,
1810         bytes memory data
1811     ) internal virtual override {
1812         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1813 
1814         if (from == address(0)) {
1815             for (uint256 i = 0; i < ids.length; ++i) {
1816                 _totalSupply[ids[i]] += amounts[i];
1817             }
1818         }
1819 
1820         if (to == address(0)) {
1821             for (uint256 i = 0; i < ids.length; ++i) {
1822                 uint256 id = ids[i];
1823                 uint256 amount = amounts[i];
1824                 uint256 supply = _totalSupply[id];
1825                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1826                 unchecked {
1827                     _totalSupply[id] = supply - amount;
1828                 }
1829             }
1830         }
1831     }
1832 }
1833 
1834 // File: @openzeppelin/contracts/access/Ownable.sol
1835 
1836 
1837 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1838 
1839 pragma solidity ^0.8.0;
1840 
1841 
1842 /**
1843  * @dev Contract module which provides a basic access control mechanism, where
1844  * there is an account (an owner) that can be granted exclusive access to
1845  * specific functions.
1846  *
1847  * By default, the owner account will be the one that deploys the contract. This
1848  * can later be changed with {transferOwnership}.
1849  *
1850  * This module is used through inheritance. It will make available the modifier
1851  * `onlyOwner`, which can be applied to your functions to restrict their use to
1852  * the owner.
1853  */
1854 abstract contract Ownable is Context {
1855     address private _owner;
1856 
1857     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1858 
1859     /**
1860      * @dev Initializes the contract setting the deployer as the initial owner.
1861      */
1862     constructor() {
1863         _transferOwnership(_msgSender());
1864     }
1865 
1866     /**
1867      * @dev Throws if called by any account other than the owner.
1868      */
1869     modifier onlyOwner() {
1870         _checkOwner();
1871         _;
1872     }
1873 
1874     /**
1875      * @dev Returns the address of the current owner.
1876      */
1877     function owner() public view virtual returns (address) {
1878         return _owner;
1879     }
1880 
1881     /**
1882      * @dev Throws if the sender is not the owner.
1883      */
1884     function _checkOwner() internal view virtual {
1885         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1886     }
1887 
1888     /**
1889      * @dev Leaves the contract without owner. It will not be possible to call
1890      * `onlyOwner` functions anymore. Can only be called by the current owner.
1891      *
1892      * NOTE: Renouncing ownership will leave the contract without an owner,
1893      * thereby removing any functionality that is only available to the owner.
1894      */
1895     function renounceOwnership() public virtual onlyOwner {
1896         _transferOwnership(address(0));
1897     }
1898 
1899     /**
1900      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1901      * Can only be called by the current owner.
1902      */
1903     function transferOwnership(address newOwner) public virtual onlyOwner {
1904         require(newOwner != address(0), "Ownable: new owner is the zero address");
1905         _transferOwnership(newOwner);
1906     }
1907 
1908     /**
1909      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1910      * Internal function without access restriction.
1911      */
1912     function _transferOwnership(address newOwner) internal virtual {
1913         address oldOwner = _owner;
1914         _owner = newOwner;
1915         emit OwnershipTransferred(oldOwner, newOwner);
1916     }
1917 }
1918 
1919 // File: contracts/LIVE.sol
1920 
1921 
1922 pragma solidity ^0.8.17;
1923 
1924 
1925 
1926 
1927 
1928 
1929 
1930 
1931 interface IFinsBeachBar {
1932     function balanceOf(address _address) external returns (uint256);
1933     function supportsInterface(bytes4 interfaceId) external returns (bool);
1934 }
1935 
1936 contract LIVEAtFins is MerkleDistributor, ReentrancyGuard, DefaultOperatorFilterer, ERC1155, ERC1155Supply, ERC1155Burnable, Ownable {
1937 
1938     string public name = "Live at Fin's";
1939     string public symbol = "LIVE";
1940 
1941     /// Allow us to cap supply for specific tokens if we want
1942     mapping (uint256 => uint256) public maxSupplyOfTokenByID;
1943 
1944     /// Keep track of which tokens the address has minted
1945     mapping (address => bool[1000]) public addressMintedTokenID;
1946 
1947     /// Fin's Beach Bar contract so we can interface with it
1948     address public finsContractAddress;
1949 
1950     /// delegate.cash registry
1951     address public delegationContractAddress;
1952 
1953     /// Require membership to call a function
1954     bool public onlyFins;
1955 
1956     /// Turn on/off minting
1957     bool public mintIsActive;
1958 
1959     /// Set the current token to mint
1960     uint256 public currentToken;
1961 
1962     constructor(string memory _uri) ERC1155(_uri) {
1963         /// Set the token uri
1964         _setURI(_uri);
1965     }
1966 
1967     /// @dev Set the URI to your base URI here, don't forget the {id} param.
1968     function setURI(string memory newuri) external onlyOwner {
1969         _setURI(newuri);
1970     }
1971 
1972     function setAllowList(bytes32 _merkleRoot) external onlyOwner {
1973         _setAllowList(_merkleRoot);
1974     }
1975 
1976     function setAllowListActive(bool _allowListActive) external onlyOwner {
1977         _setAllowListActive(_allowListActive);
1978     }
1979 
1980     function setMintActive(bool _mintIsActive) external onlyOwner {
1981         mintIsActive = _mintIsActive;
1982     }
1983 
1984     function setCurrentToken(uint256 _tokenId) external onlyOwner {
1985         /// Toggle on/off minting for the specific token
1986         currentToken = _tokenId;
1987     }
1988 
1989     function setTokenMaxSupply(uint256 _tokenId, uint256 _maxSupply) external onlyOwner {
1990         /// Toggle on/off minting for the specific token
1991         maxSupplyOfTokenByID[_tokenId] = _maxSupply;
1992     }
1993 
1994     function setDelegationContract(address _address) external onlyOwner {
1995         // Set the new contract address
1996         delegationContractAddress = _address;
1997     }
1998 
1999     function setFinsBeachBarContract(address _address) external onlyOwner {
2000         /// Validate that the candidate contract is 721
2001         require(
2002             IFinsBeachBar(_address).supportsInterface(0x780e9d63),
2003             "Contract address does not support ERC721Enumerable"
2004         );
2005 
2006         // Set the new contract address
2007         finsContractAddress = _address;
2008     }
2009 
2010     function setOnlyFinsRequirement(bool _require) external onlyOwner {
2011         onlyFins = _require;
2012     }
2013 
2014     /// check to see if the address is a Fin's member
2015     function isFinsMember(address _mintAddress) public returns (bool) {
2016         if (IFinsBeachBar(finsContractAddress).balanceOf(_mintAddress) > 0) { 
2017             return true;
2018         }
2019         return false;
2020     }
2021 
2022     function airdrop(uint256 _tokenID, address _recipient, uint256 _quantity) external onlyOwner {
2023          /// if a max supply is set, enforce supply limits
2024         if (maxSupplyOfTokenByID[_tokenID] > 0){
2025             require(
2026                 totalSupply(_tokenID) + _quantity <= maxSupplyOfTokenByID[_tokenID],
2027                 "Token mint would exceed max supply."
2028             );
2029         }
2030 
2031         _mint(_recipient, _tokenID, _quantity, "");
2032 
2033     }
2034 
2035     function mint(address _vault, bytes32[] memory _merkleProof) external nonReentrant {
2036         address delegate = msg.sender;
2037 
2038         require(mintIsActive, "mint is not active");
2039 
2040         /// if a max supply is set, enforce supply limits
2041         if (maxSupplyOfTokenByID[currentToken] > 0){
2042             require(
2043                 totalSupply(currentToken) < maxSupplyOfTokenByID[currentToken],
2044                 "Token mint would exceed max supply."
2045             );
2046         }
2047 
2048         /// check to see if this is a hot wallet designated to a vault
2049         if (_vault != address(0)) { 
2050             bool isDelegateValid = IDelegationRegistry(delegationContractAddress).checkDelegateForContract(msg.sender, _vault, finsContractAddress);
2051             require(isDelegateValid, "invalid delegate-vault pairing");
2052             delegate = _vault;
2053         }
2054 
2055         /// if the allowlist is active, require them to be on it
2056         if (allowListActive){
2057             require(onAllowList(delegate, _merkleProof), "Not on allow list");
2058         }
2059 
2060         /// if we're restricting it to fin's, check to ensure they have a fin's pass
2061         if (onlyFins){
2062             require(isFinsMember(delegate), "Not a Fin's holder");
2063         }
2064 
2065         /// make sure the address has not minted a token during the current round
2066         require(!addressMintedTokenID[delegate][currentToken], "This address already minted this token");
2067 
2068         /// mark the token as claimed by the current minter
2069         addressMintedTokenID[delegate][currentToken] = true;
2070 
2071         _mint(msg.sender, currentToken, 1, "");
2072     }
2073 
2074     /// @dev allows the owner to withdraw the funds in this contract
2075     function withdrawBalance(address payable _address) external onlyOwner {
2076         (bool success, ) = _address.call{value: address(this).balance}("");
2077         require(success, "Withdraw failed");
2078     }
2079 
2080     function setApprovalForAll(
2081         address _operator, 
2082         bool _approved
2083     ) public override onlyAllowedOperatorApproval(_operator) {
2084         super.setApprovalForAll(_operator, _approved);
2085     }
2086 
2087     function safeTransferFrom(
2088         address _from, 
2089         address _to, 
2090         uint256 _tokenId, 
2091         uint256 _amount, 
2092         bytes memory _data
2093     ) public override onlyAllowedOperator(_from) {
2094         super.safeTransferFrom(_from, _to, _tokenId, _amount, _data);
2095     }
2096 
2097     function safeBatchTransferFrom(
2098         address _from,
2099         address _to,
2100         uint256[] memory _ids,
2101         uint256[] memory _amounts,
2102         bytes memory _data
2103     ) public virtual override onlyAllowedOperator(_from) {
2104         super.safeBatchTransferFrom(_from, _to, _ids, _amounts, _data);
2105     }
2106 
2107     function _beforeTokenTransfer(
2108         address _operator,
2109         address _from,
2110         address _to,
2111         uint256[] memory _ids,
2112         uint256[] memory _amounts,
2113         bytes memory _data
2114     ) internal override(ERC1155, ERC1155Supply) {
2115         super._beforeTokenTransfer(_operator, _from, _to, _ids, _amounts, _data);
2116     }
2117 }