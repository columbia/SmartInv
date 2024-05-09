1 // File: contracts/filter/IOperatorFilterRegistry.sol
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
32 // File: contracts/filter/OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.13;
36 
37 
38 /**
39  * @title  OperatorFilterer
40  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
41  *         registrant's entries in the OperatorFilterRegistry.
42  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
43  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
44  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
45  */
46 abstract contract OperatorFilterer {
47     error OperatorNotAllowed(address operator);
48 
49     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
50         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
51 
52     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
53         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
54         // will not revert, but the contract will need to be registered with the registry once it is deployed in
55         // order for the modifier to filter addresses.
56         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
57             if (subscribe) {
58                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
59             } else {
60                 if (subscriptionOrRegistrantToCopy != address(0)) {
61                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
62                 } else {
63                     OPERATOR_FILTER_REGISTRY.register(address(this));
64                 }
65             }
66         }
67     }
68 
69     modifier onlyAllowedOperator(address from) virtual {
70         // Allow spending tokens from addresses with balance
71         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
72         // from an EOA.
73         if (from != msg.sender) {
74             _checkFilterOperator(msg.sender);
75         }
76         _;
77     }
78 
79     modifier onlyAllowedOperatorApproval(address operator) virtual {
80         _checkFilterOperator(operator);
81         _;
82     }
83 
84     function _checkFilterOperator(address operator) internal view virtual {
85         // Check registry code length to facilitate testing in environments without a deployed registry.
86         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
87             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
88                 revert OperatorNotAllowed(operator);
89             }
90         }
91     }
92 }
93 // File: contracts/filter/DefaultOperatorFilterer.sol
94 
95 
96 pragma solidity ^0.8.13;
97 
98 
99 /**
100  * @title  DefaultOperatorFilterer
101  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
102  */
103 abstract contract DefaultOperatorFilterer is OperatorFilterer {
104     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
105 
106     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
107 }
108 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev These functions deal with verification of Merkle Tree proofs.
117  *
118  * The tree and the proofs can be generated using our
119  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
120  * You will find a quickstart guide in the readme.
121  *
122  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
123  * hashing, or use a hash function other than keccak256 for hashing leaves.
124  * This is because the concatenation of a sorted pair of internal nodes in
125  * the merkle tree could be reinterpreted as a leaf value.
126  * OpenZeppelin's JavaScript library generates merkle trees that are safe
127  * against this attack out of the box.
128  */
129 library MerkleProof {
130     /**
131      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
132      * defined by `root`. For this, a `proof` must be provided, containing
133      * sibling hashes on the branch from the leaf to the root of the tree. Each
134      * pair of leaves and each pair of pre-images are assumed to be sorted.
135      */
136     function verify(
137         bytes32[] memory proof,
138         bytes32 root,
139         bytes32 leaf
140     ) internal pure returns (bool) {
141         return processProof(proof, leaf) == root;
142     }
143 
144     /**
145      * @dev Calldata version of {verify}
146      *
147      * _Available since v4.7._
148      */
149     function verifyCalldata(
150         bytes32[] calldata proof,
151         bytes32 root,
152         bytes32 leaf
153     ) internal pure returns (bool) {
154         return processProofCalldata(proof, leaf) == root;
155     }
156 
157     /**
158      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
159      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
160      * hash matches the root of the tree. When processing the proof, the pairs
161      * of leafs & pre-images are assumed to be sorted.
162      *
163      * _Available since v4.4._
164      */
165     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
166         bytes32 computedHash = leaf;
167         for (uint256 i = 0; i < proof.length; i++) {
168             computedHash = _hashPair(computedHash, proof[i]);
169         }
170         return computedHash;
171     }
172 
173     /**
174      * @dev Calldata version of {processProof}
175      *
176      * _Available since v4.7._
177      */
178     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
179         bytes32 computedHash = leaf;
180         for (uint256 i = 0; i < proof.length; i++) {
181             computedHash = _hashPair(computedHash, proof[i]);
182         }
183         return computedHash;
184     }
185 
186     /**
187      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
188      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
189      *
190      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
191      *
192      * _Available since v4.7._
193      */
194     function multiProofVerify(
195         bytes32[] memory proof,
196         bool[] memory proofFlags,
197         bytes32 root,
198         bytes32[] memory leaves
199     ) internal pure returns (bool) {
200         return processMultiProof(proof, proofFlags, leaves) == root;
201     }
202 
203     /**
204      * @dev Calldata version of {multiProofVerify}
205      *
206      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
207      *
208      * _Available since v4.7._
209      */
210     function multiProofVerifyCalldata(
211         bytes32[] calldata proof,
212         bool[] calldata proofFlags,
213         bytes32 root,
214         bytes32[] memory leaves
215     ) internal pure returns (bool) {
216         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
217     }
218 
219     /**
220      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
221      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
222      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
223      * respectively.
224      *
225      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
226      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
227      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
228      *
229      * _Available since v4.7._
230      */
231     function processMultiProof(
232         bytes32[] memory proof,
233         bool[] memory proofFlags,
234         bytes32[] memory leaves
235     ) internal pure returns (bytes32 merkleRoot) {
236         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
237         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
238         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
239         // the merkle tree.
240         uint256 leavesLen = leaves.length;
241         uint256 totalHashes = proofFlags.length;
242 
243         // Check proof validity.
244         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
245 
246         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
247         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
248         bytes32[] memory hashes = new bytes32[](totalHashes);
249         uint256 leafPos = 0;
250         uint256 hashPos = 0;
251         uint256 proofPos = 0;
252         // At each step, we compute the next hash using two values:
253         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
254         //   get the next hash.
255         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
256         //   `proof` array.
257         for (uint256 i = 0; i < totalHashes; i++) {
258             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
259             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
260             hashes[i] = _hashPair(a, b);
261         }
262 
263         if (totalHashes > 0) {
264             return hashes[totalHashes - 1];
265         } else if (leavesLen > 0) {
266             return leaves[0];
267         } else {
268             return proof[0];
269         }
270     }
271 
272     /**
273      * @dev Calldata version of {processMultiProof}.
274      *
275      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
276      *
277      * _Available since v4.7._
278      */
279     function processMultiProofCalldata(
280         bytes32[] calldata proof,
281         bool[] calldata proofFlags,
282         bytes32[] memory leaves
283     ) internal pure returns (bytes32 merkleRoot) {
284         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
285         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
286         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
287         // the merkle tree.
288         uint256 leavesLen = leaves.length;
289         uint256 totalHashes = proofFlags.length;
290 
291         // Check proof validity.
292         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
293 
294         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
295         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
296         bytes32[] memory hashes = new bytes32[](totalHashes);
297         uint256 leafPos = 0;
298         uint256 hashPos = 0;
299         uint256 proofPos = 0;
300         // At each step, we compute the next hash using two values:
301         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
302         //   get the next hash.
303         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
304         //   `proof` array.
305         for (uint256 i = 0; i < totalHashes; i++) {
306             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
307             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
308             hashes[i] = _hashPair(a, b);
309         }
310 
311         if (totalHashes > 0) {
312             return hashes[totalHashes - 1];
313         } else if (leavesLen > 0) {
314             return leaves[0];
315         } else {
316             return proof[0];
317         }
318     }
319 
320     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
321         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
322     }
323 
324     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
325         /// @solidity memory-safe-assembly
326         assembly {
327             mstore(0x00, a)
328             mstore(0x20, b)
329             value := keccak256(0x00, 0x40)
330         }
331     }
332 }
333 
334 // File: contracts/lib/MerkleDistributor.sol
335 
336 
337 
338 pragma solidity ^0.8.0;
339 
340 
341 contract MerkleDistributor {
342     bytes32 public merkleRoot;
343     bool public allowListActive = false;
344 
345     mapping(address => uint256) private _allowListNumMinted;
346 
347     /**
348      * @dev emitted when an account has claimed some tokens
349      */
350     event Claimed(address indexed account, uint256 amount);
351 
352     /**
353      * @dev emitted when the merkle root has changed
354      */
355     event MerkleRootChanged(bytes32 merkleRoot);
356 
357     /**
358      * @dev throws when allow list is not active
359      */
360     modifier isAllowListActive() {
361         require(allowListActive, 'Allow list is not active');
362         _;
363     }
364 
365     /**
366      * @dev throws when number of tokens exceeds total token amount
367      */
368     modifier tokensAvailable(
369         address to,
370         uint256 numberOfTokens,
371         uint256 totalTokenAmount
372     ) {
373         uint256 claimed = getAllowListMinted(to);
374         require(claimed + numberOfTokens <= totalTokenAmount, 'Purchase would exceed number of tokens allotted');
375         _;
376     }
377 
378     /**
379      * @dev throws when parameters sent by claimer is incorrect
380      */
381     modifier ableToClaim(address claimer, bytes32[] memory proof) {
382         require(onAllowList(claimer, proof), 'Not on allow list');
383         _;
384     }
385 
386     /**
387      * @dev sets the state of the allow list
388      */
389     function _setAllowListActive(bool allowListActive_) internal virtual {
390         allowListActive = allowListActive_;
391     }
392 
393     /**
394      * @dev sets the merkle root
395      */
396     function _setAllowList(bytes32 merkleRoot_) internal virtual {
397         merkleRoot = merkleRoot_;
398 
399         emit MerkleRootChanged(merkleRoot);
400     }
401 
402     /**
403      * @dev adds the number of tokens to the incoming address
404      */
405     function _setAllowListMinted(address to, uint256 numberOfTokens) internal virtual {
406         _allowListNumMinted[to] += numberOfTokens;
407 
408         emit Claimed(to, numberOfTokens);
409     }
410 
411     /**
412      * @dev gets the number of tokens from the address
413      */
414     function getAllowListMinted(address from) public view virtual returns (uint256) {
415         return _allowListNumMinted[from];
416     }
417 
418     /**
419      * @dev checks if the claimer has a valid proof
420      */
421     function onAllowList(address claimer, bytes32[] memory proof) public view returns (bool) {
422         bytes32 leaf = keccak256(abi.encodePacked(claimer));
423         return MerkleProof.verify(proof, merkleRoot, leaf);
424     }
425 }
426 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
427 
428 
429 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev Contract module that helps prevent reentrant calls to a function.
435  *
436  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
437  * available, which can be applied to functions to make sure there are no nested
438  * (reentrant) calls to them.
439  *
440  * Note that because there is a single `nonReentrant` guard, functions marked as
441  * `nonReentrant` may not call one another. This can be worked around by making
442  * those functions `private`, and then adding `external` `nonReentrant` entry
443  * points to them.
444  *
445  * TIP: If you would like to learn more about reentrancy and alternative ways
446  * to protect against it, check out our blog post
447  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
448  */
449 abstract contract ReentrancyGuard {
450     // Booleans are more expensive than uint256 or any type that takes up a full
451     // word because each write operation emits an extra SLOAD to first read the
452     // slot's contents, replace the bits taken up by the boolean, and then write
453     // back. This is the compiler's defense against contract upgrades and
454     // pointer aliasing, and it cannot be disabled.
455 
456     // The values being non-zero value makes deployment a bit more expensive,
457     // but in exchange the refund on every call to nonReentrant will be lower in
458     // amount. Since refunds are capped to a percentage of the total
459     // transaction's gas, it is best to keep them low in cases like this one, to
460     // increase the likelihood of the full refund coming into effect.
461     uint256 private constant _NOT_ENTERED = 1;
462     uint256 private constant _ENTERED = 2;
463 
464     uint256 private _status;
465 
466     constructor() {
467         _status = _NOT_ENTERED;
468     }
469 
470     /**
471      * @dev Prevents a contract from calling itself, directly or indirectly.
472      * Calling a `nonReentrant` function from another `nonReentrant`
473      * function is not supported. It is possible to prevent this from happening
474      * by making the `nonReentrant` function external, and making it call a
475      * `private` function that does the actual work.
476      */
477     modifier nonReentrant() {
478         _nonReentrantBefore();
479         _;
480         _nonReentrantAfter();
481     }
482 
483     function _nonReentrantBefore() private {
484         // On the first call to nonReentrant, _status will be _NOT_ENTERED
485         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
486 
487         // Any calls to nonReentrant after this point will fail
488         _status = _ENTERED;
489     }
490 
491     function _nonReentrantAfter() private {
492         // By storing the original value once again, a refund is triggered (see
493         // https://eips.ethereum.org/EIPS/eip-2200)
494         _status = _NOT_ENTERED;
495     }
496 }
497 
498 // File: @openzeppelin/contracts/utils/Address.sol
499 
500 
501 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
502 
503 pragma solidity ^0.8.1;
504 
505 /**
506  * @dev Collection of functions related to the address type
507  */
508 library Address {
509     /**
510      * @dev Returns true if `account` is a contract.
511      *
512      * [IMPORTANT]
513      * ====
514      * It is unsafe to assume that an address for which this function returns
515      * false is an externally-owned account (EOA) and not a contract.
516      *
517      * Among others, `isContract` will return false for the following
518      * types of addresses:
519      *
520      *  - an externally-owned account
521      *  - a contract in construction
522      *  - an address where a contract will be created
523      *  - an address where a contract lived, but was destroyed
524      * ====
525      *
526      * [IMPORTANT]
527      * ====
528      * You shouldn't rely on `isContract` to protect against flash loan attacks!
529      *
530      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
531      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
532      * constructor.
533      * ====
534      */
535     function isContract(address account) internal view returns (bool) {
536         // This method relies on extcodesize/address.code.length, which returns 0
537         // for contracts in construction, since the code is only stored at the end
538         // of the constructor execution.
539 
540         return account.code.length > 0;
541     }
542 
543     /**
544      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
545      * `recipient`, forwarding all available gas and reverting on errors.
546      *
547      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
548      * of certain opcodes, possibly making contracts go over the 2300 gas limit
549      * imposed by `transfer`, making them unable to receive funds via
550      * `transfer`. {sendValue} removes this limitation.
551      *
552      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
553      *
554      * IMPORTANT: because control is transferred to `recipient`, care must be
555      * taken to not create reentrancy vulnerabilities. Consider using
556      * {ReentrancyGuard} or the
557      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
558      */
559     function sendValue(address payable recipient, uint256 amount) internal {
560         require(address(this).balance >= amount, "Address: insufficient balance");
561 
562         (bool success, ) = recipient.call{value: amount}("");
563         require(success, "Address: unable to send value, recipient may have reverted");
564     }
565 
566     /**
567      * @dev Performs a Solidity function call using a low level `call`. A
568      * plain `call` is an unsafe replacement for a function call: use this
569      * function instead.
570      *
571      * If `target` reverts with a revert reason, it is bubbled up by this
572      * function (like regular Solidity function calls).
573      *
574      * Returns the raw returned data. To convert to the expected return value,
575      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
576      *
577      * Requirements:
578      *
579      * - `target` must be a contract.
580      * - calling `target` with `data` must not revert.
581      *
582      * _Available since v3.1._
583      */
584     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
585         return functionCall(target, data, "Address: low-level call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
590      * `errorMessage` as a fallback revert reason when `target` reverts.
591      *
592      * _Available since v3.1._
593      */
594     function functionCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, 0, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but also transferring `value` wei to `target`.
605      *
606      * Requirements:
607      *
608      * - the calling contract must have an ETH balance of at least `value`.
609      * - the called Solidity function must be `payable`.
610      *
611      * _Available since v3.1._
612      */
613     function functionCallWithValue(
614         address target,
615         bytes memory data,
616         uint256 value
617     ) internal returns (bytes memory) {
618         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
623      * with `errorMessage` as a fallback revert reason when `target` reverts.
624      *
625      * _Available since v3.1._
626      */
627     function functionCallWithValue(
628         address target,
629         bytes memory data,
630         uint256 value,
631         string memory errorMessage
632     ) internal returns (bytes memory) {
633         require(address(this).balance >= value, "Address: insufficient balance for call");
634         require(isContract(target), "Address: call to non-contract");
635 
636         (bool success, bytes memory returndata) = target.call{value: value}(data);
637         return verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
642      * but performing a static call.
643      *
644      * _Available since v3.3._
645      */
646     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
647         return functionStaticCall(target, data, "Address: low-level static call failed");
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
652      * but performing a static call.
653      *
654      * _Available since v3.3._
655      */
656     function functionStaticCall(
657         address target,
658         bytes memory data,
659         string memory errorMessage
660     ) internal view returns (bytes memory) {
661         require(isContract(target), "Address: static call to non-contract");
662 
663         (bool success, bytes memory returndata) = target.staticcall(data);
664         return verifyCallResult(success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but performing a delegate call.
670      *
671      * _Available since v3.4._
672      */
673     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
674         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
679      * but performing a delegate call.
680      *
681      * _Available since v3.4._
682      */
683     function functionDelegateCall(
684         address target,
685         bytes memory data,
686         string memory errorMessage
687     ) internal returns (bytes memory) {
688         require(isContract(target), "Address: delegate call to non-contract");
689 
690         (bool success, bytes memory returndata) = target.delegatecall(data);
691         return verifyCallResult(success, returndata, errorMessage);
692     }
693 
694     /**
695      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
696      * revert reason using the provided one.
697      *
698      * _Available since v4.3._
699      */
700     function verifyCallResult(
701         bool success,
702         bytes memory returndata,
703         string memory errorMessage
704     ) internal pure returns (bytes memory) {
705         if (success) {
706             return returndata;
707         } else {
708             // Look for revert reason and bubble it up if present
709             if (returndata.length > 0) {
710                 // The easiest way to bubble the revert reason is using memory via assembly
711                 /// @solidity memory-safe-assembly
712                 assembly {
713                     let returndata_size := mload(returndata)
714                     revert(add(32, returndata), returndata_size)
715                 }
716             } else {
717                 revert(errorMessage);
718             }
719         }
720     }
721 }
722 
723 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 /**
731  * @dev Interface of the ERC165 standard, as defined in the
732  * https://eips.ethereum.org/EIPS/eip-165[EIP].
733  *
734  * Implementers can declare support of contract interfaces, which can then be
735  * queried by others ({ERC165Checker}).
736  *
737  * For an implementation, see {ERC165}.
738  */
739 interface IERC165 {
740     /**
741      * @dev Returns true if this contract implements the interface defined by
742      * `interfaceId`. See the corresponding
743      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
744      * to learn more about how these ids are created.
745      *
746      * This function call must use less than 30 000 gas.
747      */
748     function supportsInterface(bytes4 interfaceId) external view returns (bool);
749 }
750 
751 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
752 
753 
754 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 
759 /**
760  * @dev Implementation of the {IERC165} interface.
761  *
762  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
763  * for the additional interface id that will be supported. For example:
764  *
765  * ```solidity
766  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
767  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
768  * }
769  * ```
770  *
771  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
772  */
773 abstract contract ERC165 is IERC165 {
774     /**
775      * @dev See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
778         return interfaceId == type(IERC165).interfaceId;
779     }
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
783 
784 
785 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 
790 /**
791  * @dev _Available since v3.1._
792  */
793 interface IERC1155Receiver is IERC165 {
794     /**
795      * @dev Handles the receipt of a single ERC1155 token type. This function is
796      * called at the end of a `safeTransferFrom` after the balance has been updated.
797      *
798      * NOTE: To accept the transfer, this must return
799      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
800      * (i.e. 0xf23a6e61, or its own function selector).
801      *
802      * @param operator The address which initiated the transfer (i.e. msg.sender)
803      * @param from The address which previously owned the token
804      * @param id The ID of the token being transferred
805      * @param value The amount of tokens being transferred
806      * @param data Additional data with no specified format
807      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
808      */
809     function onERC1155Received(
810         address operator,
811         address from,
812         uint256 id,
813         uint256 value,
814         bytes calldata data
815     ) external returns (bytes4);
816 
817     /**
818      * @dev Handles the receipt of a multiple ERC1155 token types. This function
819      * is called at the end of a `safeBatchTransferFrom` after the balances have
820      * been updated.
821      *
822      * NOTE: To accept the transfer(s), this must return
823      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
824      * (i.e. 0xbc197c81, or its own function selector).
825      *
826      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
827      * @param from The address which previously owned the token
828      * @param ids An array containing ids of each token being transferred (order and length must match values array)
829      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
830      * @param data Additional data with no specified format
831      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
832      */
833     function onERC1155BatchReceived(
834         address operator,
835         address from,
836         uint256[] calldata ids,
837         uint256[] calldata values,
838         bytes calldata data
839     ) external returns (bytes4);
840 }
841 
842 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
843 
844 
845 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
846 
847 pragma solidity ^0.8.0;
848 
849 
850 /**
851  * @dev Required interface of an ERC1155 compliant contract, as defined in the
852  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
853  *
854  * _Available since v3.1._
855  */
856 interface IERC1155 is IERC165 {
857     /**
858      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
859      */
860     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
861 
862     /**
863      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
864      * transfers.
865      */
866     event TransferBatch(
867         address indexed operator,
868         address indexed from,
869         address indexed to,
870         uint256[] ids,
871         uint256[] values
872     );
873 
874     /**
875      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
876      * `approved`.
877      */
878     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
879 
880     /**
881      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
882      *
883      * If an {URI} event was emitted for `id`, the standard
884      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
885      * returned by {IERC1155MetadataURI-uri}.
886      */
887     event URI(string value, uint256 indexed id);
888 
889     /**
890      * @dev Returns the amount of tokens of token type `id` owned by `account`.
891      *
892      * Requirements:
893      *
894      * - `account` cannot be the zero address.
895      */
896     function balanceOf(address account, uint256 id) external view returns (uint256);
897 
898     /**
899      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
900      *
901      * Requirements:
902      *
903      * - `accounts` and `ids` must have the same length.
904      */
905     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
906         external
907         view
908         returns (uint256[] memory);
909 
910     /**
911      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
912      *
913      * Emits an {ApprovalForAll} event.
914      *
915      * Requirements:
916      *
917      * - `operator` cannot be the caller.
918      */
919     function setApprovalForAll(address operator, bool approved) external;
920 
921     /**
922      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
923      *
924      * See {setApprovalForAll}.
925      */
926     function isApprovedForAll(address account, address operator) external view returns (bool);
927 
928     /**
929      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
930      *
931      * Emits a {TransferSingle} event.
932      *
933      * Requirements:
934      *
935      * - `to` cannot be the zero address.
936      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
937      * - `from` must have a balance of tokens of type `id` of at least `amount`.
938      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
939      * acceptance magic value.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 id,
945         uint256 amount,
946         bytes calldata data
947     ) external;
948 
949     /**
950      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
951      *
952      * Emits a {TransferBatch} event.
953      *
954      * Requirements:
955      *
956      * - `ids` and `amounts` must have the same length.
957      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
958      * acceptance magic value.
959      */
960     function safeBatchTransferFrom(
961         address from,
962         address to,
963         uint256[] calldata ids,
964         uint256[] calldata amounts,
965         bytes calldata data
966     ) external;
967 }
968 
969 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
970 
971 
972 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 
977 /**
978  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
979  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
980  *
981  * _Available since v3.1._
982  */
983 interface IERC1155MetadataURI is IERC1155 {
984     /**
985      * @dev Returns the URI for token type `id`.
986      *
987      * If the `\{id\}` substring is present in the URI, it must be replaced by
988      * clients with the actual token type ID.
989      */
990     function uri(uint256 id) external view returns (string memory);
991 }
992 
993 // File: @openzeppelin/contracts/utils/Context.sol
994 
995 
996 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @dev Provides information about the current execution context, including the
1002  * sender of the transaction and its data. While these are generally available
1003  * via msg.sender and msg.data, they should not be accessed in such a direct
1004  * manner, since when dealing with meta-transactions the account sending and
1005  * paying for execution may not be the actual sender (as far as an application
1006  * is concerned).
1007  *
1008  * This contract is only required for intermediate, library-like contracts.
1009  */
1010 abstract contract Context {
1011     function _msgSender() internal view virtual returns (address) {
1012         return msg.sender;
1013     }
1014 
1015     function _msgData() internal view virtual returns (bytes calldata) {
1016         return msg.data;
1017     }
1018 }
1019 
1020 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1021 
1022 
1023 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 
1028 
1029 
1030 
1031 
1032 
1033 /**
1034  * @dev Implementation of the basic standard multi-token.
1035  * See https://eips.ethereum.org/EIPS/eip-1155
1036  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1037  *
1038  * _Available since v3.1._
1039  */
1040 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1041     using Address for address;
1042 
1043     // Mapping from token ID to account balances
1044     mapping(uint256 => mapping(address => uint256)) private _balances;
1045 
1046     // Mapping from account to operator approvals
1047     mapping(address => mapping(address => bool)) private _operatorApprovals;
1048 
1049     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1050     string private _uri;
1051 
1052     /**
1053      * @dev See {_setURI}.
1054      */
1055     constructor(string memory uri_) {
1056         _setURI(uri_);
1057     }
1058 
1059     /**
1060      * @dev See {IERC165-supportsInterface}.
1061      */
1062     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1063         return
1064             interfaceId == type(IERC1155).interfaceId ||
1065             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1066             super.supportsInterface(interfaceId);
1067     }
1068 
1069     /**
1070      * @dev See {IERC1155MetadataURI-uri}.
1071      *
1072      * This implementation returns the same URI for *all* token types. It relies
1073      * on the token type ID substitution mechanism
1074      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1075      *
1076      * Clients calling this function must replace the `\{id\}` substring with the
1077      * actual token type ID.
1078      */
1079     function uri(uint256) public view virtual override returns (string memory) {
1080         return _uri;
1081     }
1082 
1083     /**
1084      * @dev See {IERC1155-balanceOf}.
1085      *
1086      * Requirements:
1087      *
1088      * - `account` cannot be the zero address.
1089      */
1090     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1091         require(account != address(0), "ERC1155: address zero is not a valid owner");
1092         return _balances[id][account];
1093     }
1094 
1095     /**
1096      * @dev See {IERC1155-balanceOfBatch}.
1097      *
1098      * Requirements:
1099      *
1100      * - `accounts` and `ids` must have the same length.
1101      */
1102     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1103         public
1104         view
1105         virtual
1106         override
1107         returns (uint256[] memory)
1108     {
1109         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1110 
1111         uint256[] memory batchBalances = new uint256[](accounts.length);
1112 
1113         for (uint256 i = 0; i < accounts.length; ++i) {
1114             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1115         }
1116 
1117         return batchBalances;
1118     }
1119 
1120     /**
1121      * @dev See {IERC1155-setApprovalForAll}.
1122      */
1123     function setApprovalForAll(address operator, bool approved) public virtual override {
1124         _setApprovalForAll(_msgSender(), operator, approved);
1125     }
1126 
1127     /**
1128      * @dev See {IERC1155-isApprovedForAll}.
1129      */
1130     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1131         return _operatorApprovals[account][operator];
1132     }
1133 
1134     /**
1135      * @dev See {IERC1155-safeTransferFrom}.
1136      */
1137     function safeTransferFrom(
1138         address from,
1139         address to,
1140         uint256 id,
1141         uint256 amount,
1142         bytes memory data
1143     ) public virtual override {
1144         require(
1145             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1146             "ERC1155: caller is not token owner nor approved"
1147         );
1148         _safeTransferFrom(from, to, id, amount, data);
1149     }
1150 
1151     /**
1152      * @dev See {IERC1155-safeBatchTransferFrom}.
1153      */
1154     function safeBatchTransferFrom(
1155         address from,
1156         address to,
1157         uint256[] memory ids,
1158         uint256[] memory amounts,
1159         bytes memory data
1160     ) public virtual override {
1161         require(
1162             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1163             "ERC1155: caller is not token owner nor approved"
1164         );
1165         _safeBatchTransferFrom(from, to, ids, amounts, data);
1166     }
1167 
1168     /**
1169      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1170      *
1171      * Emits a {TransferSingle} event.
1172      *
1173      * Requirements:
1174      *
1175      * - `to` cannot be the zero address.
1176      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1177      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1178      * acceptance magic value.
1179      */
1180     function _safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 id,
1184         uint256 amount,
1185         bytes memory data
1186     ) internal virtual {
1187         require(to != address(0), "ERC1155: transfer to the zero address");
1188 
1189         address operator = _msgSender();
1190         uint256[] memory ids = _asSingletonArray(id);
1191         uint256[] memory amounts = _asSingletonArray(amount);
1192 
1193         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1194 
1195         uint256 fromBalance = _balances[id][from];
1196         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1197         unchecked {
1198             _balances[id][from] = fromBalance - amount;
1199         }
1200         _balances[id][to] += amount;
1201 
1202         emit TransferSingle(operator, from, to, id, amount);
1203 
1204         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1205 
1206         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1207     }
1208 
1209     /**
1210      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1211      *
1212      * Emits a {TransferBatch} event.
1213      *
1214      * Requirements:
1215      *
1216      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1217      * acceptance magic value.
1218      */
1219     function _safeBatchTransferFrom(
1220         address from,
1221         address to,
1222         uint256[] memory ids,
1223         uint256[] memory amounts,
1224         bytes memory data
1225     ) internal virtual {
1226         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1227         require(to != address(0), "ERC1155: transfer to the zero address");
1228 
1229         address operator = _msgSender();
1230 
1231         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1232 
1233         for (uint256 i = 0; i < ids.length; ++i) {
1234             uint256 id = ids[i];
1235             uint256 amount = amounts[i];
1236 
1237             uint256 fromBalance = _balances[id][from];
1238             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1239             unchecked {
1240                 _balances[id][from] = fromBalance - amount;
1241             }
1242             _balances[id][to] += amount;
1243         }
1244 
1245         emit TransferBatch(operator, from, to, ids, amounts);
1246 
1247         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1248 
1249         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1250     }
1251 
1252     /**
1253      * @dev Sets a new URI for all token types, by relying on the token type ID
1254      * substitution mechanism
1255      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1256      *
1257      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1258      * URI or any of the amounts in the JSON file at said URI will be replaced by
1259      * clients with the token type ID.
1260      *
1261      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1262      * interpreted by clients as
1263      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1264      * for token type ID 0x4cce0.
1265      *
1266      * See {uri}.
1267      *
1268      * Because these URIs cannot be meaningfully represented by the {URI} event,
1269      * this function emits no events.
1270      */
1271     function _setURI(string memory newuri) internal virtual {
1272         _uri = newuri;
1273     }
1274 
1275     /**
1276      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1277      *
1278      * Emits a {TransferSingle} event.
1279      *
1280      * Requirements:
1281      *
1282      * - `to` cannot be the zero address.
1283      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1284      * acceptance magic value.
1285      */
1286     function _mint(
1287         address to,
1288         uint256 id,
1289         uint256 amount,
1290         bytes memory data
1291     ) internal virtual {
1292         require(to != address(0), "ERC1155: mint to the zero address");
1293 
1294         address operator = _msgSender();
1295         uint256[] memory ids = _asSingletonArray(id);
1296         uint256[] memory amounts = _asSingletonArray(amount);
1297 
1298         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1299 
1300         _balances[id][to] += amount;
1301         emit TransferSingle(operator, address(0), to, id, amount);
1302 
1303         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1304 
1305         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1306     }
1307 
1308     /**
1309      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1310      *
1311      * Emits a {TransferBatch} event.
1312      *
1313      * Requirements:
1314      *
1315      * - `ids` and `amounts` must have the same length.
1316      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1317      * acceptance magic value.
1318      */
1319     function _mintBatch(
1320         address to,
1321         uint256[] memory ids,
1322         uint256[] memory amounts,
1323         bytes memory data
1324     ) internal virtual {
1325         require(to != address(0), "ERC1155: mint to the zero address");
1326         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1327 
1328         address operator = _msgSender();
1329 
1330         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1331 
1332         for (uint256 i = 0; i < ids.length; i++) {
1333             _balances[ids[i]][to] += amounts[i];
1334         }
1335 
1336         emit TransferBatch(operator, address(0), to, ids, amounts);
1337 
1338         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1339 
1340         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1341     }
1342 
1343     /**
1344      * @dev Destroys `amount` tokens of token type `id` from `from`
1345      *
1346      * Emits a {TransferSingle} event.
1347      *
1348      * Requirements:
1349      *
1350      * - `from` cannot be the zero address.
1351      * - `from` must have at least `amount` tokens of token type `id`.
1352      */
1353     function _burn(
1354         address from,
1355         uint256 id,
1356         uint256 amount
1357     ) internal virtual {
1358         require(from != address(0), "ERC1155: burn from the zero address");
1359 
1360         address operator = _msgSender();
1361         uint256[] memory ids = _asSingletonArray(id);
1362         uint256[] memory amounts = _asSingletonArray(amount);
1363 
1364         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1365 
1366         uint256 fromBalance = _balances[id][from];
1367         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1368         unchecked {
1369             _balances[id][from] = fromBalance - amount;
1370         }
1371 
1372         emit TransferSingle(operator, from, address(0), id, amount);
1373 
1374         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1375     }
1376 
1377     /**
1378      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1379      *
1380      * Emits a {TransferBatch} event.
1381      *
1382      * Requirements:
1383      *
1384      * - `ids` and `amounts` must have the same length.
1385      */
1386     function _burnBatch(
1387         address from,
1388         uint256[] memory ids,
1389         uint256[] memory amounts
1390     ) internal virtual {
1391         require(from != address(0), "ERC1155: burn from the zero address");
1392         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1393 
1394         address operator = _msgSender();
1395 
1396         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1397 
1398         for (uint256 i = 0; i < ids.length; i++) {
1399             uint256 id = ids[i];
1400             uint256 amount = amounts[i];
1401 
1402             uint256 fromBalance = _balances[id][from];
1403             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1404             unchecked {
1405                 _balances[id][from] = fromBalance - amount;
1406             }
1407         }
1408 
1409         emit TransferBatch(operator, from, address(0), ids, amounts);
1410 
1411         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1412     }
1413 
1414     /**
1415      * @dev Approve `operator` to operate on all of `owner` tokens
1416      *
1417      * Emits an {ApprovalForAll} event.
1418      */
1419     function _setApprovalForAll(
1420         address owner,
1421         address operator,
1422         bool approved
1423     ) internal virtual {
1424         require(owner != operator, "ERC1155: setting approval status for self");
1425         _operatorApprovals[owner][operator] = approved;
1426         emit ApprovalForAll(owner, operator, approved);
1427     }
1428 
1429     /**
1430      * @dev Hook that is called before any token transfer. This includes minting
1431      * and burning, as well as batched variants.
1432      *
1433      * The same hook is called on both single and batched variants. For single
1434      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1435      *
1436      * Calling conditions (for each `id` and `amount` pair):
1437      *
1438      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1439      * of token type `id` will be  transferred to `to`.
1440      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1441      * for `to`.
1442      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1443      * will be burned.
1444      * - `from` and `to` are never both zero.
1445      * - `ids` and `amounts` have the same, non-zero length.
1446      *
1447      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1448      */
1449     function _beforeTokenTransfer(
1450         address operator,
1451         address from,
1452         address to,
1453         uint256[] memory ids,
1454         uint256[] memory amounts,
1455         bytes memory data
1456     ) internal virtual {}
1457 
1458     /**
1459      * @dev Hook that is called after any token transfer. This includes minting
1460      * and burning, as well as batched variants.
1461      *
1462      * The same hook is called on both single and batched variants. For single
1463      * transfers, the length of the `id` and `amount` arrays will be 1.
1464      *
1465      * Calling conditions (for each `id` and `amount` pair):
1466      *
1467      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1468      * of token type `id` will be  transferred to `to`.
1469      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1470      * for `to`.
1471      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1472      * will be burned.
1473      * - `from` and `to` are never both zero.
1474      * - `ids` and `amounts` have the same, non-zero length.
1475      *
1476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1477      */
1478     function _afterTokenTransfer(
1479         address operator,
1480         address from,
1481         address to,
1482         uint256[] memory ids,
1483         uint256[] memory amounts,
1484         bytes memory data
1485     ) internal virtual {}
1486 
1487     function _doSafeTransferAcceptanceCheck(
1488         address operator,
1489         address from,
1490         address to,
1491         uint256 id,
1492         uint256 amount,
1493         bytes memory data
1494     ) private {
1495         if (to.isContract()) {
1496             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1497                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1498                     revert("ERC1155: ERC1155Receiver rejected tokens");
1499                 }
1500             } catch Error(string memory reason) {
1501                 revert(reason);
1502             } catch {
1503                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1504             }
1505         }
1506     }
1507 
1508     function _doSafeBatchTransferAcceptanceCheck(
1509         address operator,
1510         address from,
1511         address to,
1512         uint256[] memory ids,
1513         uint256[] memory amounts,
1514         bytes memory data
1515     ) private {
1516         if (to.isContract()) {
1517             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1518                 bytes4 response
1519             ) {
1520                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1521                     revert("ERC1155: ERC1155Receiver rejected tokens");
1522                 }
1523             } catch Error(string memory reason) {
1524                 revert(reason);
1525             } catch {
1526                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1527             }
1528         }
1529     }
1530 
1531     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1532         uint256[] memory array = new uint256[](1);
1533         array[0] = element;
1534 
1535         return array;
1536     }
1537 }
1538 
1539 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
1540 
1541 
1542 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
1543 
1544 pragma solidity ^0.8.0;
1545 
1546 
1547 /**
1548  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1549  * own tokens and those that they have been approved to use.
1550  *
1551  * _Available since v3.1._
1552  */
1553 abstract contract ERC1155Burnable is ERC1155 {
1554     function burn(
1555         address account,
1556         uint256 id,
1557         uint256 value
1558     ) public virtual {
1559         require(
1560             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1561             "ERC1155: caller is not token owner nor approved"
1562         );
1563 
1564         _burn(account, id, value);
1565     }
1566 
1567     function burnBatch(
1568         address account,
1569         uint256[] memory ids,
1570         uint256[] memory values
1571     ) public virtual {
1572         require(
1573             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1574             "ERC1155: caller is not token owner nor approved"
1575         );
1576 
1577         _burnBatch(account, ids, values);
1578     }
1579 }
1580 
1581 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1582 
1583 
1584 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 
1589 /**
1590  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1591  *
1592  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1593  * clearly identified. Note: While a totalSupply of 1 might mean the
1594  * corresponding is an NFT, there is no guarantees that no other token with the
1595  * same id are not going to be minted.
1596  */
1597 abstract contract ERC1155Supply is ERC1155 {
1598     mapping(uint256 => uint256) private _totalSupply;
1599 
1600     /**
1601      * @dev Total amount of tokens in with a given id.
1602      */
1603     function totalSupply(uint256 id) public view virtual returns (uint256) {
1604         return _totalSupply[id];
1605     }
1606 
1607     /**
1608      * @dev Indicates whether any token exist with a given id, or not.
1609      */
1610     function exists(uint256 id) public view virtual returns (bool) {
1611         return ERC1155Supply.totalSupply(id) > 0;
1612     }
1613 
1614     /**
1615      * @dev See {ERC1155-_beforeTokenTransfer}.
1616      */
1617     function _beforeTokenTransfer(
1618         address operator,
1619         address from,
1620         address to,
1621         uint256[] memory ids,
1622         uint256[] memory amounts,
1623         bytes memory data
1624     ) internal virtual override {
1625         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1626 
1627         if (from == address(0)) {
1628             for (uint256 i = 0; i < ids.length; ++i) {
1629                 _totalSupply[ids[i]] += amounts[i];
1630             }
1631         }
1632 
1633         if (to == address(0)) {
1634             for (uint256 i = 0; i < ids.length; ++i) {
1635                 uint256 id = ids[i];
1636                 uint256 amount = amounts[i];
1637                 uint256 supply = _totalSupply[id];
1638                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1639                 unchecked {
1640                     _totalSupply[id] = supply - amount;
1641                 }
1642             }
1643         }
1644     }
1645 }
1646 
1647 // File: @openzeppelin/contracts/access/Ownable.sol
1648 
1649 
1650 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1651 
1652 pragma solidity ^0.8.0;
1653 
1654 
1655 /**
1656  * @dev Contract module which provides a basic access control mechanism, where
1657  * there is an account (an owner) that can be granted exclusive access to
1658  * specific functions.
1659  *
1660  * By default, the owner account will be the one that deploys the contract. This
1661  * can later be changed with {transferOwnership}.
1662  *
1663  * This module is used through inheritance. It will make available the modifier
1664  * `onlyOwner`, which can be applied to your functions to restrict their use to
1665  * the owner.
1666  */
1667 abstract contract Ownable is Context {
1668     address private _owner;
1669 
1670     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1671 
1672     /**
1673      * @dev Initializes the contract setting the deployer as the initial owner.
1674      */
1675     constructor() {
1676         _transferOwnership(_msgSender());
1677     }
1678 
1679     /**
1680      * @dev Throws if called by any account other than the owner.
1681      */
1682     modifier onlyOwner() {
1683         _checkOwner();
1684         _;
1685     }
1686 
1687     /**
1688      * @dev Returns the address of the current owner.
1689      */
1690     function owner() public view virtual returns (address) {
1691         return _owner;
1692     }
1693 
1694     /**
1695      * @dev Throws if the sender is not the owner.
1696      */
1697     function _checkOwner() internal view virtual {
1698         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1699     }
1700 
1701     /**
1702      * @dev Leaves the contract without owner. It will not be possible to call
1703      * `onlyOwner` functions anymore. Can only be called by the current owner.
1704      *
1705      * NOTE: Renouncing ownership will leave the contract without an owner,
1706      * thereby removing any functionality that is only available to the owner.
1707      */
1708     function renounceOwnership() public virtual onlyOwner {
1709         _transferOwnership(address(0));
1710     }
1711 
1712     /**
1713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1714      * Can only be called by the current owner.
1715      */
1716     function transferOwnership(address newOwner) public virtual onlyOwner {
1717         require(newOwner != address(0), "Ownable: new owner is the zero address");
1718         _transferOwnership(newOwner);
1719     }
1720 
1721     /**
1722      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1723      * Internal function without access restriction.
1724      */
1725     function _transferOwnership(address newOwner) internal virtual {
1726         address oldOwner = _owner;
1727         _owner = newOwner;
1728         emit OwnershipTransferred(oldOwner, newOwner);
1729     }
1730 }
1731 
1732 // File: contracts/FinsX.sol
1733 
1734 
1735 pragma solidity ^0.8.17;
1736 
1737 
1738 
1739 
1740 
1741 
1742 
1743 contract FinsXM is MerkleDistributor, ReentrancyGuard, DefaultOperatorFilterer, ERC1155, ERC1155Supply, ERC1155Burnable, Ownable{
1744 
1745     string public name = "FinsXM";
1746     string public symbol = "FINSXM";
1747 
1748     /// is the mint/claim active?
1749     bool public mintIsActive = false;
1750     
1751     /// keep track of which round of the game we are in
1752     uint256 public currentRound = 0;
1753 
1754     /// supply cap for each round of minting
1755     uint256[5] public supplyByRound = [625, 300, 100, 50, 20];
1756 
1757     /// odds of rolling a special token are better with each progressive round
1758     uint256 currentOdds = supplyByRound[currentRound]/2;
1759 
1760     /// the number of special tokens that can exist at once
1761     uint256 MAX_SUPPLY_SPECIAL = 5;
1762     
1763     /// track how many total tokens have been minted each round
1764     mapping (uint256 => uint256) public totalTokensMintedPerRound;
1765 
1766     /// track how many total tokens have been minted each round for this user
1767     mapping (address => bool[5]) public addressMintedEachRound;
1768 
1769     uint256 private nonce;
1770 
1771     constructor(string memory _uri) ERC1155(_uri) {
1772         /// set the token uri
1773         _setURI(_uri);
1774 
1775         /// mint the first token when the contract is created
1776         _mint(msg.sender, 0, 5, "");
1777 
1778         /// keep track of this token
1779         totalTokensMintedPerRound[0] = 5;
1780     }
1781 
1782     /// @dev set the URI to your base URI here, don't forget the {id} param.
1783     function setURI(string memory newuri) external onlyOwner {
1784         _setURI(newuri);
1785     }
1786 
1787     function setMintIsActive(bool _mintIsActive) external onlyOwner {
1788         mintIsActive = _mintIsActive;
1789     }
1790 
1791     function setAllowListActive(bool _allowListActive) external onlyOwner {
1792         _setAllowListActive(_allowListActive);
1793     }
1794 
1795     function setAllowList(bytes32 _merkleRoot) external onlyOwner {
1796         _setAllowList(_merkleRoot);
1797     }
1798 
1799     function setCurrentRound(uint256 _round) external onlyOwner {
1800         require(_round >= 0 && _round <= 4, "Round must be between 0 and 4");
1801         currentRound = _round;
1802     }
1803 
1804     /// a function to check if the address owns every token up to the current one
1805     function _hasEveryTokenSoFar(address _address) internal view returns(bool) {
1806         /// check the current balance of each token up to the current round
1807         for (uint256 i; i < currentRound; ++i) {
1808             /// if the address is mising any token before this one, return false
1809             if(balanceOf(_address, i) < 1){
1810                 return false;
1811             }
1812         }
1813         return true;
1814     }
1815 
1816     /// generate a kind of random number
1817     function _kindaRandom(uint256 _max) internal returns (uint256) {
1818         uint256 kindaRandomnumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % _max;
1819         nonce++;
1820         return kindaRandomnumber;
1821     }
1822 
1823 
1824     function mint(bytes32[] memory _merkleProof) external nonReentrant {
1825         /// ensure the mint is active
1826         require(mintIsActive, "Mint is not active");
1827 
1828         /// if the allowlist is active, require them to be on it
1829         if (allowListActive){
1830             /// ensure the address is on the allowlist
1831             require(onAllowList(msg.sender, _merkleProof), "Not on allow list");
1832         }
1833 
1834         /// make sure the address has not minted a token during the current round
1835         require(addressMintedEachRound[msg.sender][currentRound] == false, "Already minted a token this round");
1836 
1837         /// make sure we haven't exceeded the supply for the given round
1838         require(totalTokensMintedPerRound[currentRound] < supplyByRound[currentRound], "No remaning supply this round");
1839 
1840         /// make sure they have every token up to the current one
1841         require(_hasEveryTokenSoFar(msg.sender), "Address is missing a token");
1842 
1843         uint256 idToMint = currentRound;
1844 
1845         /// have a chance at minting an ultra-rare token as long as max supply hasn't been reached and it's not the final round
1846         if (totalSupply(5) < MAX_SUPPLY_SPECIAL && currentRound != 4){
1847             if (_kindaRandom(supplyByRound[currentRound]) == 10){
1848                 idToMint = 5;
1849             }
1850         }
1851     
1852         /// increase the total number of tokens minted during the current round by 1 unless it's the special
1853         if (idToMint != 5){
1854             totalTokensMintedPerRound[currentRound] = totalTokensMintedPerRound[currentRound] + 1;
1855         }
1856         
1857         /// increase the total number of tokens minted during the current round by 1
1858         addressMintedEachRound[msg.sender][currentRound] = true;
1859 
1860         _mint(msg.sender, idToMint, 1, "");
1861     }
1862 
1863     /// @dev allows the owner to withdraw the funds in this contract
1864     function withdrawBalance(address payable _address) external onlyOwner {
1865         (bool success, ) = _address.call{value: address(this).balance}("");
1866         require(success, "Withdraw failed");
1867     }
1868 
1869     function setApprovalForAll(
1870         address _operator, 
1871         bool _approved
1872     ) public override onlyAllowedOperatorApproval(_operator) {
1873         super.setApprovalForAll(_operator, _approved);
1874     }
1875 
1876     function safeTransferFrom(
1877         address _from, 
1878         address _to, 
1879         uint256 _tokenId, 
1880         uint256 _amount, 
1881         bytes memory _data
1882     ) public override onlyAllowedOperator(_from) {
1883         super.safeTransferFrom(_from, _to, _tokenId, _amount, _data);
1884     }
1885 
1886     function safeBatchTransferFrom(
1887         address _from,
1888         address _to,
1889         uint256[] memory _ids,
1890         uint256[] memory _amounts,
1891         bytes memory _data
1892     ) public virtual override onlyAllowedOperator(_from) {
1893         super.safeBatchTransferFrom(_from, _to, _ids, _amounts, _data);
1894     }
1895 
1896     function _beforeTokenTransfer(
1897         address _operator,
1898         address _from,
1899         address _to,
1900         uint256[] memory _ids,
1901         uint256[] memory _amounts,
1902         bytes memory _data
1903     ) internal override(ERC1155, ERC1155Supply) {
1904         super._beforeTokenTransfer(_operator, _from, _to, _ids, _amounts, _data);
1905     }
1906 }