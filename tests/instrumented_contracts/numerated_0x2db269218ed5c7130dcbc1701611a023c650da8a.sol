1 // SPDX-License-Identifier: MIT
2 // Copyright (c) 2023 Keisuke OHNO (kei31.eth)
3 
4 /*
5 
6 Permission is hereby granted, free of charge, to any person obtaining a copy
7 of this software and associated documentation files (the "Software"), to deal
8 in the Software without restriction, including without limitation the rights
9 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 copies of the Software, and to permit persons to whom the Software is
11 furnished to do so, subject to the following conditions:
12 
13 The above copyright notice and this permission notice shall be included in all
14 copies or substantial portions of the Software.
15 
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
22 SOFTWARE.
23 
24 */
25 
26 
27 
28 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
29 
30 
31 pragma solidity ^0.8.13;
32 
33 interface IOperatorFilterRegistry {
34     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
35     function register(address registrant) external;
36     function registerAndSubscribe(address registrant, address subscription) external;
37     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
38     function unregister(address addr) external;
39     function updateOperator(address registrant, address operator, bool filtered) external;
40     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
41     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
42     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
43     function subscribe(address registrant, address registrantToSubscribe) external;
44     function unsubscribe(address registrant, bool copyExistingEntries) external;
45     function subscriptionOf(address addr) external returns (address registrant);
46     function subscribers(address registrant) external returns (address[] memory);
47     function subscriberAt(address registrant, uint256 index) external returns (address);
48     function copyEntriesOf(address registrant, address registrantToCopy) external;
49     function isOperatorFiltered(address registrant, address operator) external returns (bool);
50     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
51     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
52     function filteredOperators(address addr) external returns (address[] memory);
53     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
54     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
55     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
56     function isRegistered(address addr) external returns (bool);
57     function codeHashOf(address addr) external returns (bytes32);
58 }
59 
60 // File: operator-filter-registry/src/UpdatableOperatorFilterer.sol
61 
62 
63 pragma solidity ^0.8.13;
64 
65 
66 /**
67  * @title  UpdatableOperatorFilterer
68  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
69  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
70  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
71  *         which will bypass registry checks.
72  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
73  *         on-chain, eg, if the registry is revoked or bypassed.
74  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
75  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
76  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
77  */
78 abstract contract UpdatableOperatorFilterer {
79     error OperatorNotAllowed(address operator);
80     error OnlyOwner();
81 
82     IOperatorFilterRegistry public operatorFilterRegistry;
83 
84     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
85         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
86         operatorFilterRegistry = registry;
87         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
88         // will not revert, but the contract will need to be registered with the registry once it is deployed in
89         // order for the modifier to filter addresses.
90         if (address(registry).code.length > 0) {
91             if (subscribe) {
92                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
93             } else {
94                 if (subscriptionOrRegistrantToCopy != address(0)) {
95                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
96                 } else {
97                     registry.register(address(this));
98                 }
99             }
100         }
101     }
102 
103     modifier onlyAllowedOperator(address from) virtual {
104         // Allow spending tokens from addresses with balance
105         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
106         // from an EOA.
107         if (from != msg.sender) {
108             _checkFilterOperator(msg.sender);
109         }
110         _;
111     }
112 
113     modifier onlyAllowedOperatorApproval(address operator) virtual {
114         _checkFilterOperator(operator);
115         _;
116     }
117 
118     /**
119      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
120      *         address, checks will be bypassed. OnlyOwner.
121      */
122     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
123         if (msg.sender != owner()) {
124             revert OnlyOwner();
125         }
126         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
127     }
128 
129     /**
130      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
131      */
132     function owner() public view virtual returns (address);
133 
134     function _checkFilterOperator(address operator) internal view virtual {
135         IOperatorFilterRegistry registry = operatorFilterRegistry;
136         // Check registry code length to facilitate testing in environments without a deployed registry.
137         if (address(registry) != address(0) && address(registry).code.length > 0) {
138             if (!registry.isOperatorAllowed(address(this), operator)) {
139                 revert OperatorNotAllowed(operator);
140             }
141         }
142     }
143 }
144 
145 // File: operator-filter-registry/src/RevokableOperatorFilterer.sol
146 
147 
148 pragma solidity ^0.8.13;
149 
150 
151 
152 /**
153  * @title  RevokableOperatorFilterer
154  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
155  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
156  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
157  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
158  *         address cannot be further updated.
159  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
160  *         on-chain, eg, if the registry is revoked or bypassed.
161  */
162 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
163     error RegistryHasBeenRevoked();
164     error InitialRegistryAddressCannotBeZeroAddress();
165 
166     bool public isOperatorFilterRegistryRevoked;
167 
168     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
169         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
170     {
171         // don't allow creating a contract with a permanently revoked registry
172         if (_registry == address(0)) {
173             revert InitialRegistryAddressCannotBeZeroAddress();
174         }
175     }
176 
177     function _checkFilterOperator(address operator) internal view virtual override {
178         if (address(operatorFilterRegistry) != address(0)) {
179             super._checkFilterOperator(operator);
180         }
181     }
182 
183     /**
184      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
185      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
186      */
187     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
188         if (msg.sender != owner()) {
189             revert OnlyOwner();
190         }
191         // if registry has been revoked, do not allow further updates
192         if (isOperatorFilterRegistryRevoked) {
193             revert RegistryHasBeenRevoked();
194         }
195 
196         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
197     }
198 
199     /**
200      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
201      */
202     function revokeOperatorFilterRegistry() public {
203         if (msg.sender != owner()) {
204             revert OnlyOwner();
205         }
206         // if registry has been revoked, do not allow further updates
207         if (isOperatorFilterRegistryRevoked) {
208             revert RegistryHasBeenRevoked();
209         }
210 
211         // set to zero address to bypass checks
212         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
213         isOperatorFilterRegistryRevoked = true;
214     }
215 }
216 
217 // File: operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol
218 
219 
220 pragma solidity ^0.8.13;
221 
222 
223 /**
224  * @title  RevokableDefaultOperatorFilterer
225  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
226  *         Note that OpenSea will disable creator fee enforcement if filtered operators begin fulfilling orders
227  *         on-chain, eg, if the registry is revoked or bypassed.
228  */
229 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
230     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
231 
232     constructor() RevokableOperatorFilterer(0x000000000000AAeB6D7670E522A718067333cd4E, DEFAULT_SUBSCRIPTION, true) {}
233 }
234 
235 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
236 
237 
238 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Contract module that helps prevent reentrant calls to a function.
244  *
245  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
246  * available, which can be applied to functions to make sure there are no nested
247  * (reentrant) calls to them.
248  *
249  * Note that because there is a single `nonReentrant` guard, functions marked as
250  * `nonReentrant` may not call one another. This can be worked around by making
251  * those functions `private`, and then adding `external` `nonReentrant` entry
252  * points to them.
253  *
254  * TIP: If you would like to learn more about reentrancy and alternative ways
255  * to protect against it, check out our blog post
256  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
257  */
258 abstract contract ReentrancyGuard {
259     // Booleans are more expensive than uint256 or any type that takes up a full
260     // word because each write operation emits an extra SLOAD to first read the
261     // slot's contents, replace the bits taken up by the boolean, and then write
262     // back. This is the compiler's defense against contract upgrades and
263     // pointer aliasing, and it cannot be disabled.
264 
265     // The values being non-zero value makes deployment a bit more expensive,
266     // but in exchange the refund on every call to nonReentrant will be lower in
267     // amount. Since refunds are capped to a percentage of the total
268     // transaction's gas, it is best to keep them low in cases like this one, to
269     // increase the likelihood of the full refund coming into effect.
270     uint256 private constant _NOT_ENTERED = 1;
271     uint256 private constant _ENTERED = 2;
272 
273     uint256 private _status;
274 
275     constructor() {
276         _status = _NOT_ENTERED;
277     }
278 
279     /**
280      * @dev Prevents a contract from calling itself, directly or indirectly.
281      * Calling a `nonReentrant` function from another `nonReentrant`
282      * function is not supported. It is possible to prevent this from happening
283      * by making the `nonReentrant` function external, and making it call a
284      * `private` function that does the actual work.
285      */
286     modifier nonReentrant() {
287         _nonReentrantBefore();
288         _;
289         _nonReentrantAfter();
290     }
291 
292     function _nonReentrantBefore() private {
293         // On the first call to nonReentrant, _status will be _NOT_ENTERED
294         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
295 
296         // Any calls to nonReentrant after this point will fail
297         _status = _ENTERED;
298     }
299 
300     function _nonReentrantAfter() private {
301         // By storing the original value once again, a refund is triggered (see
302         // https://eips.ethereum.org/EIPS/eip-2200)
303         _status = _NOT_ENTERED;
304     }
305 }
306 
307 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
308 
309 
310 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev These functions deal with verification of Merkle Tree proofs.
316  *
317  * The tree and the proofs can be generated using our
318  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
319  * You will find a quickstart guide in the readme.
320  *
321  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
322  * hashing, or use a hash function other than keccak256 for hashing leaves.
323  * This is because the concatenation of a sorted pair of internal nodes in
324  * the merkle tree could be reinterpreted as a leaf value.
325  * OpenZeppelin's JavaScript library generates merkle trees that are safe
326  * against this attack out of the box.
327  */
328 library MerkleProof {
329     /**
330      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
331      * defined by `root`. For this, a `proof` must be provided, containing
332      * sibling hashes on the branch from the leaf to the root of the tree. Each
333      * pair of leaves and each pair of pre-images are assumed to be sorted.
334      */
335     function verify(
336         bytes32[] memory proof,
337         bytes32 root,
338         bytes32 leaf
339     ) internal pure returns (bool) {
340         return processProof(proof, leaf) == root;
341     }
342 
343     /**
344      * @dev Calldata version of {verify}
345      *
346      * _Available since v4.7._
347      */
348     function verifyCalldata(
349         bytes32[] calldata proof,
350         bytes32 root,
351         bytes32 leaf
352     ) internal pure returns (bool) {
353         return processProofCalldata(proof, leaf) == root;
354     }
355 
356     /**
357      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
358      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
359      * hash matches the root of the tree. When processing the proof, the pairs
360      * of leafs & pre-images are assumed to be sorted.
361      *
362      * _Available since v4.4._
363      */
364     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
365         bytes32 computedHash = leaf;
366         for (uint256 i = 0; i < proof.length; i++) {
367             computedHash = _hashPair(computedHash, proof[i]);
368         }
369         return computedHash;
370     }
371 
372     /**
373      * @dev Calldata version of {processProof}
374      *
375      * _Available since v4.7._
376      */
377     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
378         bytes32 computedHash = leaf;
379         for (uint256 i = 0; i < proof.length; i++) {
380             computedHash = _hashPair(computedHash, proof[i]);
381         }
382         return computedHash;
383     }
384 
385     /**
386      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
387      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
388      *
389      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
390      *
391      * _Available since v4.7._
392      */
393     function multiProofVerify(
394         bytes32[] memory proof,
395         bool[] memory proofFlags,
396         bytes32 root,
397         bytes32[] memory leaves
398     ) internal pure returns (bool) {
399         return processMultiProof(proof, proofFlags, leaves) == root;
400     }
401 
402     /**
403      * @dev Calldata version of {multiProofVerify}
404      *
405      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
406      *
407      * _Available since v4.7._
408      */
409     function multiProofVerifyCalldata(
410         bytes32[] calldata proof,
411         bool[] calldata proofFlags,
412         bytes32 root,
413         bytes32[] memory leaves
414     ) internal pure returns (bool) {
415         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
416     }
417 
418     /**
419      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
420      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
421      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
422      * respectively.
423      *
424      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
425      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
426      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
427      *
428      * _Available since v4.7._
429      */
430     function processMultiProof(
431         bytes32[] memory proof,
432         bool[] memory proofFlags,
433         bytes32[] memory leaves
434     ) internal pure returns (bytes32 merkleRoot) {
435         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
436         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
437         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
438         // the merkle tree.
439         uint256 leavesLen = leaves.length;
440         uint256 totalHashes = proofFlags.length;
441 
442         // Check proof validity.
443         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
444 
445         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
446         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
447         bytes32[] memory hashes = new bytes32[](totalHashes);
448         uint256 leafPos = 0;
449         uint256 hashPos = 0;
450         uint256 proofPos = 0;
451         // At each step, we compute the next hash using two values:
452         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
453         //   get the next hash.
454         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
455         //   `proof` array.
456         for (uint256 i = 0; i < totalHashes; i++) {
457             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
458             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
459             hashes[i] = _hashPair(a, b);
460         }
461 
462         if (totalHashes > 0) {
463             return hashes[totalHashes - 1];
464         } else if (leavesLen > 0) {
465             return leaves[0];
466         } else {
467             return proof[0];
468         }
469     }
470 
471     /**
472      * @dev Calldata version of {processMultiProof}.
473      *
474      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
475      *
476      * _Available since v4.7._
477      */
478     function processMultiProofCalldata(
479         bytes32[] calldata proof,
480         bool[] calldata proofFlags,
481         bytes32[] memory leaves
482     ) internal pure returns (bytes32 merkleRoot) {
483         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
484         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
485         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
486         // the merkle tree.
487         uint256 leavesLen = leaves.length;
488         uint256 totalHashes = proofFlags.length;
489 
490         // Check proof validity.
491         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
492 
493         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
494         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
495         bytes32[] memory hashes = new bytes32[](totalHashes);
496         uint256 leafPos = 0;
497         uint256 hashPos = 0;
498         uint256 proofPos = 0;
499         // At each step, we compute the next hash using two values:
500         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
501         //   get the next hash.
502         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
503         //   `proof` array.
504         for (uint256 i = 0; i < totalHashes; i++) {
505             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
506             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
507             hashes[i] = _hashPair(a, b);
508         }
509 
510         if (totalHashes > 0) {
511             return hashes[totalHashes - 1];
512         } else if (leavesLen > 0) {
513             return leaves[0];
514         } else {
515             return proof[0];
516         }
517     }
518 
519     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
520         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
521     }
522 
523     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
524         /// @solidity memory-safe-assembly
525         assembly {
526             mstore(0x00, a)
527             mstore(0x20, b)
528             value := keccak256(0x00, 0x40)
529         }
530     }
531 }
532 
533 // File: @openzeppelin/contracts/access/IAccessControl.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev External interface of AccessControl declared to support ERC165 detection.
542  */
543 interface IAccessControl {
544     /**
545      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
546      *
547      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
548      * {RoleAdminChanged} not being emitted signaling this.
549      *
550      * _Available since v3.1._
551      */
552     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
553 
554     /**
555      * @dev Emitted when `account` is granted `role`.
556      *
557      * `sender` is the account that originated the contract call, an admin role
558      * bearer except when using {AccessControl-_setupRole}.
559      */
560     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
561 
562     /**
563      * @dev Emitted when `account` is revoked `role`.
564      *
565      * `sender` is the account that originated the contract call:
566      *   - if using `revokeRole`, it is the admin role bearer
567      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
568      */
569     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
570 
571     /**
572      * @dev Returns `true` if `account` has been granted `role`.
573      */
574     function hasRole(bytes32 role, address account) external view returns (bool);
575 
576     /**
577      * @dev Returns the admin role that controls `role`. See {grantRole} and
578      * {revokeRole}.
579      *
580      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
581      */
582     function getRoleAdmin(bytes32 role) external view returns (bytes32);
583 
584     /**
585      * @dev Grants `role` to `account`.
586      *
587      * If `account` had not been already granted `role`, emits a {RoleGranted}
588      * event.
589      *
590      * Requirements:
591      *
592      * - the caller must have ``role``'s admin role.
593      */
594     function grantRole(bytes32 role, address account) external;
595 
596     /**
597      * @dev Revokes `role` from `account`.
598      *
599      * If `account` had been granted `role`, emits a {RoleRevoked} event.
600      *
601      * Requirements:
602      *
603      * - the caller must have ``role``'s admin role.
604      */
605     function revokeRole(bytes32 role, address account) external;
606 
607     /**
608      * @dev Revokes `role` from the calling account.
609      *
610      * Roles are often managed via {grantRole} and {revokeRole}: this function's
611      * purpose is to provide a mechanism for accounts to lose their privileges
612      * if they are compromised (such as when a trusted device is misplaced).
613      *
614      * If the calling account had been granted `role`, emits a {RoleRevoked}
615      * event.
616      *
617      * Requirements:
618      *
619      * - the caller must be `account`.
620      */
621     function renounceRole(bytes32 role, address account) external;
622 }
623 
624 // File: contract-allow-list/contracts/proxy/interface/IContractAllowListProxy.sol
625 
626 
627 pragma solidity >=0.7.0 <0.9.0;
628 
629 interface IContractAllowListProxy {
630     function isAllowed(address _transferer, uint256 _level)
631         external
632         view
633         returns (bool);
634 }
635 
636 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
640 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Library for managing
646  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
647  * types.
648  *
649  * Sets have the following properties:
650  *
651  * - Elements are added, removed, and checked for existence in constant time
652  * (O(1)).
653  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
654  *
655  * ```
656  * contract Example {
657  *     // Add the library methods
658  *     using EnumerableSet for EnumerableSet.AddressSet;
659  *
660  *     // Declare a set state variable
661  *     EnumerableSet.AddressSet private mySet;
662  * }
663  * ```
664  *
665  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
666  * and `uint256` (`UintSet`) are supported.
667  *
668  * [WARNING]
669  * ====
670  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
671  * unusable.
672  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
673  *
674  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
675  * array of EnumerableSet.
676  * ====
677  */
678 library EnumerableSet {
679     // To implement this library for multiple types with as little code
680     // repetition as possible, we write it in terms of a generic Set type with
681     // bytes32 values.
682     // The Set implementation uses private functions, and user-facing
683     // implementations (such as AddressSet) are just wrappers around the
684     // underlying Set.
685     // This means that we can only create new EnumerableSets for types that fit
686     // in bytes32.
687 
688     struct Set {
689         // Storage of set values
690         bytes32[] _values;
691         // Position of the value in the `values` array, plus 1 because index 0
692         // means a value is not in the set.
693         mapping(bytes32 => uint256) _indexes;
694     }
695 
696     /**
697      * @dev Add a value to a set. O(1).
698      *
699      * Returns true if the value was added to the set, that is if it was not
700      * already present.
701      */
702     function _add(Set storage set, bytes32 value) private returns (bool) {
703         if (!_contains(set, value)) {
704             set._values.push(value);
705             // The value is stored at length-1, but we add 1 to all indexes
706             // and use 0 as a sentinel value
707             set._indexes[value] = set._values.length;
708             return true;
709         } else {
710             return false;
711         }
712     }
713 
714     /**
715      * @dev Removes a value from a set. O(1).
716      *
717      * Returns true if the value was removed from the set, that is if it was
718      * present.
719      */
720     function _remove(Set storage set, bytes32 value) private returns (bool) {
721         // We read and store the value's index to prevent multiple reads from the same storage slot
722         uint256 valueIndex = set._indexes[value];
723 
724         if (valueIndex != 0) {
725             // Equivalent to contains(set, value)
726             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
727             // the array, and then remove the last element (sometimes called as 'swap and pop').
728             // This modifies the order of the array, as noted in {at}.
729 
730             uint256 toDeleteIndex = valueIndex - 1;
731             uint256 lastIndex = set._values.length - 1;
732 
733             if (lastIndex != toDeleteIndex) {
734                 bytes32 lastValue = set._values[lastIndex];
735 
736                 // Move the last value to the index where the value to delete is
737                 set._values[toDeleteIndex] = lastValue;
738                 // Update the index for the moved value
739                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
740             }
741 
742             // Delete the slot where the moved value was stored
743             set._values.pop();
744 
745             // Delete the index for the deleted slot
746             delete set._indexes[value];
747 
748             return true;
749         } else {
750             return false;
751         }
752     }
753 
754     /**
755      * @dev Returns true if the value is in the set. O(1).
756      */
757     function _contains(Set storage set, bytes32 value) private view returns (bool) {
758         return set._indexes[value] != 0;
759     }
760 
761     /**
762      * @dev Returns the number of values on the set. O(1).
763      */
764     function _length(Set storage set) private view returns (uint256) {
765         return set._values.length;
766     }
767 
768     /**
769      * @dev Returns the value stored at position `index` in the set. O(1).
770      *
771      * Note that there are no guarantees on the ordering of values inside the
772      * array, and it may change when more values are added or removed.
773      *
774      * Requirements:
775      *
776      * - `index` must be strictly less than {length}.
777      */
778     function _at(Set storage set, uint256 index) private view returns (bytes32) {
779         return set._values[index];
780     }
781 
782     /**
783      * @dev Return the entire set in an array
784      *
785      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
786      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
787      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
788      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
789      */
790     function _values(Set storage set) private view returns (bytes32[] memory) {
791         return set._values;
792     }
793 
794     // Bytes32Set
795 
796     struct Bytes32Set {
797         Set _inner;
798     }
799 
800     /**
801      * @dev Add a value to a set. O(1).
802      *
803      * Returns true if the value was added to the set, that is if it was not
804      * already present.
805      */
806     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
807         return _add(set._inner, value);
808     }
809 
810     /**
811      * @dev Removes a value from a set. O(1).
812      *
813      * Returns true if the value was removed from the set, that is if it was
814      * present.
815      */
816     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
817         return _remove(set._inner, value);
818     }
819 
820     /**
821      * @dev Returns true if the value is in the set. O(1).
822      */
823     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
824         return _contains(set._inner, value);
825     }
826 
827     /**
828      * @dev Returns the number of values in the set. O(1).
829      */
830     function length(Bytes32Set storage set) internal view returns (uint256) {
831         return _length(set._inner);
832     }
833 
834     /**
835      * @dev Returns the value stored at position `index` in the set. O(1).
836      *
837      * Note that there are no guarantees on the ordering of values inside the
838      * array, and it may change when more values are added or removed.
839      *
840      * Requirements:
841      *
842      * - `index` must be strictly less than {length}.
843      */
844     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
845         return _at(set._inner, index);
846     }
847 
848     /**
849      * @dev Return the entire set in an array
850      *
851      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
852      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
853      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
854      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
855      */
856     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
857         bytes32[] memory store = _values(set._inner);
858         bytes32[] memory result;
859 
860         /// @solidity memory-safe-assembly
861         assembly {
862             result := store
863         }
864 
865         return result;
866     }
867 
868     // AddressSet
869 
870     struct AddressSet {
871         Set _inner;
872     }
873 
874     /**
875      * @dev Add a value to a set. O(1).
876      *
877      * Returns true if the value was added to the set, that is if it was not
878      * already present.
879      */
880     function add(AddressSet storage set, address value) internal returns (bool) {
881         return _add(set._inner, bytes32(uint256(uint160(value))));
882     }
883 
884     /**
885      * @dev Removes a value from a set. O(1).
886      *
887      * Returns true if the value was removed from the set, that is if it was
888      * present.
889      */
890     function remove(AddressSet storage set, address value) internal returns (bool) {
891         return _remove(set._inner, bytes32(uint256(uint160(value))));
892     }
893 
894     /**
895      * @dev Returns true if the value is in the set. O(1).
896      */
897     function contains(AddressSet storage set, address value) internal view returns (bool) {
898         return _contains(set._inner, bytes32(uint256(uint160(value))));
899     }
900 
901     /**
902      * @dev Returns the number of values in the set. O(1).
903      */
904     function length(AddressSet storage set) internal view returns (uint256) {
905         return _length(set._inner);
906     }
907 
908     /**
909      * @dev Returns the value stored at position `index` in the set. O(1).
910      *
911      * Note that there are no guarantees on the ordering of values inside the
912      * array, and it may change when more values are added or removed.
913      *
914      * Requirements:
915      *
916      * - `index` must be strictly less than {length}.
917      */
918     function at(AddressSet storage set, uint256 index) internal view returns (address) {
919         return address(uint160(uint256(_at(set._inner, index))));
920     }
921 
922     /**
923      * @dev Return the entire set in an array
924      *
925      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
926      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
927      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
928      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
929      */
930     function values(AddressSet storage set) internal view returns (address[] memory) {
931         bytes32[] memory store = _values(set._inner);
932         address[] memory result;
933 
934         /// @solidity memory-safe-assembly
935         assembly {
936             result := store
937         }
938 
939         return result;
940     }
941 
942     // UintSet
943 
944     struct UintSet {
945         Set _inner;
946     }
947 
948     /**
949      * @dev Add a value to a set. O(1).
950      *
951      * Returns true if the value was added to the set, that is if it was not
952      * already present.
953      */
954     function add(UintSet storage set, uint256 value) internal returns (bool) {
955         return _add(set._inner, bytes32(value));
956     }
957 
958     /**
959      * @dev Removes a value from a set. O(1).
960      *
961      * Returns true if the value was removed from the set, that is if it was
962      * present.
963      */
964     function remove(UintSet storage set, uint256 value) internal returns (bool) {
965         return _remove(set._inner, bytes32(value));
966     }
967 
968     /**
969      * @dev Returns true if the value is in the set. O(1).
970      */
971     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
972         return _contains(set._inner, bytes32(value));
973     }
974 
975     /**
976      * @dev Returns the number of values in the set. O(1).
977      */
978     function length(UintSet storage set) internal view returns (uint256) {
979         return _length(set._inner);
980     }
981 
982     /**
983      * @dev Returns the value stored at position `index` in the set. O(1).
984      *
985      * Note that there are no guarantees on the ordering of values inside the
986      * array, and it may change when more values are added or removed.
987      *
988      * Requirements:
989      *
990      * - `index` must be strictly less than {length}.
991      */
992     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
993         return uint256(_at(set._inner, index));
994     }
995 
996     /**
997      * @dev Return the entire set in an array
998      *
999      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1000      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1001      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1002      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1003      */
1004     function values(UintSet storage set) internal view returns (uint256[] memory) {
1005         bytes32[] memory store = _values(set._inner);
1006         uint256[] memory result;
1007 
1008         /// @solidity memory-safe-assembly
1009         assembly {
1010             result := store
1011         }
1012 
1013         return result;
1014     }
1015 }
1016 
1017 // File: contract-allow-list/contracts/ERC721AntiScam/restrictApprove/IERC721RestrictApprove.sol
1018 
1019 
1020 pragma solidity >=0.8.0;
1021 
1022 /// @title IERC721RestrictApprove
1023 /// @dev Approve抑制機能付きコントラクトのインターフェース
1024 /// @author Lavulite
1025 
1026 interface IERC721RestrictApprove {
1027     /**
1028      * @dev CALレベルが変更された場合のイベント
1029      */
1030     event CalLevelChanged(address indexed operator, uint256 indexed level);
1031     
1032     /**
1033      * @dev LocalContractAllowListnに追加された場合のイベント
1034      */
1035     event LocalCalAdded(address indexed operator, address indexed transferer);
1036 
1037     /**
1038      * @dev LocalContractAllowListnに削除された場合のイベント
1039      */
1040     event LocalCalRemoved(address indexed operator, address indexed transferer);
1041 
1042     /**
1043      * @dev CALを利用する場合のCALのレベルを設定する。レベルが高いほど、許可されるコントラクトの範囲が狭い。
1044      */
1045     function setCALLevel(uint256 level) external;
1046 
1047     /**
1048      * @dev CALのアドレスをセットする。
1049      */
1050     function setCAL(address calAddress) external;
1051 
1052     /**
1053      * @dev CALのリストに無い独自の許可アドレスを追加する場合、こちらにアドレスを記載する。
1054      */
1055     function addLocalContractAllowList(address transferer) external;
1056 
1057     /**
1058      * @dev CALのリストにある独自の許可アドレスを削除する場合、こちらにアドレスを記載する。
1059      */
1060     function removeLocalContractAllowList(address transferer) external;
1061 
1062     /**
1063      * @dev CALのリストにある独自の許可アドレスの一覧を取得する。
1064      */
1065     function getLocalContractAllowList() external view returns(address[] memory);
1066 
1067 }
1068 
1069 // File: @openzeppelin/contracts/utils/StorageSlot.sol
1070 
1071 
1072 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 /**
1077  * @dev Library for reading and writing primitive types to specific storage slots.
1078  *
1079  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
1080  * This library helps with reading and writing to such slots without the need for inline assembly.
1081  *
1082  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
1083  *
1084  * Example usage to set ERC1967 implementation slot:
1085  * ```
1086  * contract ERC1967 {
1087  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1088  *
1089  *     function _getImplementation() internal view returns (address) {
1090  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
1091  *     }
1092  *
1093  *     function _setImplementation(address newImplementation) internal {
1094  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
1095  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
1096  *     }
1097  * }
1098  * ```
1099  *
1100  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
1101  */
1102 library StorageSlot {
1103     struct AddressSlot {
1104         address value;
1105     }
1106 
1107     struct BooleanSlot {
1108         bool value;
1109     }
1110 
1111     struct Bytes32Slot {
1112         bytes32 value;
1113     }
1114 
1115     struct Uint256Slot {
1116         uint256 value;
1117     }
1118 
1119     /**
1120      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
1121      */
1122     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
1123         /// @solidity memory-safe-assembly
1124         assembly {
1125             r.slot := slot
1126         }
1127     }
1128 
1129     /**
1130      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
1131      */
1132     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
1133         /// @solidity memory-safe-assembly
1134         assembly {
1135             r.slot := slot
1136         }
1137     }
1138 
1139     /**
1140      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
1141      */
1142     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
1143         /// @solidity memory-safe-assembly
1144         assembly {
1145             r.slot := slot
1146         }
1147     }
1148 
1149     /**
1150      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
1151      */
1152     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
1153         /// @solidity memory-safe-assembly
1154         assembly {
1155             r.slot := slot
1156         }
1157     }
1158 }
1159 
1160 // File: @openzeppelin/contracts/utils/Address.sol
1161 
1162 
1163 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1164 
1165 pragma solidity ^0.8.1;
1166 
1167 /**
1168  * @dev Collection of functions related to the address type
1169  */
1170 library Address {
1171     /**
1172      * @dev Returns true if `account` is a contract.
1173      *
1174      * [IMPORTANT]
1175      * ====
1176      * It is unsafe to assume that an address for which this function returns
1177      * false is an externally-owned account (EOA) and not a contract.
1178      *
1179      * Among others, `isContract` will return false for the following
1180      * types of addresses:
1181      *
1182      *  - an externally-owned account
1183      *  - a contract in construction
1184      *  - an address where a contract will be created
1185      *  - an address where a contract lived, but was destroyed
1186      * ====
1187      *
1188      * [IMPORTANT]
1189      * ====
1190      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1191      *
1192      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1193      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1194      * constructor.
1195      * ====
1196      */
1197     function isContract(address account) internal view returns (bool) {
1198         // This method relies on extcodesize/address.code.length, which returns 0
1199         // for contracts in construction, since the code is only stored at the end
1200         // of the constructor execution.
1201 
1202         return account.code.length > 0;
1203     }
1204 
1205     /**
1206      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1207      * `recipient`, forwarding all available gas and reverting on errors.
1208      *
1209      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1210      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1211      * imposed by `transfer`, making them unable to receive funds via
1212      * `transfer`. {sendValue} removes this limitation.
1213      *
1214      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1215      *
1216      * IMPORTANT: because control is transferred to `recipient`, care must be
1217      * taken to not create reentrancy vulnerabilities. Consider using
1218      * {ReentrancyGuard} or the
1219      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1220      */
1221     function sendValue(address payable recipient, uint256 amount) internal {
1222         require(address(this).balance >= amount, "Address: insufficient balance");
1223 
1224         (bool success, ) = recipient.call{value: amount}("");
1225         require(success, "Address: unable to send value, recipient may have reverted");
1226     }
1227 
1228     /**
1229      * @dev Performs a Solidity function call using a low level `call`. A
1230      * plain `call` is an unsafe replacement for a function call: use this
1231      * function instead.
1232      *
1233      * If `target` reverts with a revert reason, it is bubbled up by this
1234      * function (like regular Solidity function calls).
1235      *
1236      * Returns the raw returned data. To convert to the expected return value,
1237      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1238      *
1239      * Requirements:
1240      *
1241      * - `target` must be a contract.
1242      * - calling `target` with `data` must not revert.
1243      *
1244      * _Available since v3.1._
1245      */
1246     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1247         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1248     }
1249 
1250     /**
1251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1252      * `errorMessage` as a fallback revert reason when `target` reverts.
1253      *
1254      * _Available since v3.1._
1255      */
1256     function functionCall(
1257         address target,
1258         bytes memory data,
1259         string memory errorMessage
1260     ) internal returns (bytes memory) {
1261         return functionCallWithValue(target, data, 0, errorMessage);
1262     }
1263 
1264     /**
1265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1266      * but also transferring `value` wei to `target`.
1267      *
1268      * Requirements:
1269      *
1270      * - the calling contract must have an ETH balance of at least `value`.
1271      * - the called Solidity function must be `payable`.
1272      *
1273      * _Available since v3.1._
1274      */
1275     function functionCallWithValue(
1276         address target,
1277         bytes memory data,
1278         uint256 value
1279     ) internal returns (bytes memory) {
1280         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1281     }
1282 
1283     /**
1284      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1285      * with `errorMessage` as a fallback revert reason when `target` reverts.
1286      *
1287      * _Available since v3.1._
1288      */
1289     function functionCallWithValue(
1290         address target,
1291         bytes memory data,
1292         uint256 value,
1293         string memory errorMessage
1294     ) internal returns (bytes memory) {
1295         require(address(this).balance >= value, "Address: insufficient balance for call");
1296         (bool success, bytes memory returndata) = target.call{value: value}(data);
1297         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1298     }
1299 
1300     /**
1301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1302      * but performing a static call.
1303      *
1304      * _Available since v3.3._
1305      */
1306     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1307         return functionStaticCall(target, data, "Address: low-level static call failed");
1308     }
1309 
1310     /**
1311      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1312      * but performing a static call.
1313      *
1314      * _Available since v3.3._
1315      */
1316     function functionStaticCall(
1317         address target,
1318         bytes memory data,
1319         string memory errorMessage
1320     ) internal view returns (bytes memory) {
1321         (bool success, bytes memory returndata) = target.staticcall(data);
1322         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1323     }
1324 
1325     /**
1326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1327      * but performing a delegate call.
1328      *
1329      * _Available since v3.4._
1330      */
1331     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1332         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1333     }
1334 
1335     /**
1336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1337      * but performing a delegate call.
1338      *
1339      * _Available since v3.4._
1340      */
1341     function functionDelegateCall(
1342         address target,
1343         bytes memory data,
1344         string memory errorMessage
1345     ) internal returns (bytes memory) {
1346         (bool success, bytes memory returndata) = target.delegatecall(data);
1347         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1348     }
1349 
1350     /**
1351      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1352      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1353      *
1354      * _Available since v4.8._
1355      */
1356     function verifyCallResultFromTarget(
1357         address target,
1358         bool success,
1359         bytes memory returndata,
1360         string memory errorMessage
1361     ) internal view returns (bytes memory) {
1362         if (success) {
1363             if (returndata.length == 0) {
1364                 // only check isContract if the call was successful and the return data is empty
1365                 // otherwise we already know that it was a contract
1366                 require(isContract(target), "Address: call to non-contract");
1367             }
1368             return returndata;
1369         } else {
1370             _revert(returndata, errorMessage);
1371         }
1372     }
1373 
1374     /**
1375      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1376      * revert reason or using the provided one.
1377      *
1378      * _Available since v4.3._
1379      */
1380     function verifyCallResult(
1381         bool success,
1382         bytes memory returndata,
1383         string memory errorMessage
1384     ) internal pure returns (bytes memory) {
1385         if (success) {
1386             return returndata;
1387         } else {
1388             _revert(returndata, errorMessage);
1389         }
1390     }
1391 
1392     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1393         // Look for revert reason and bubble it up if present
1394         if (returndata.length > 0) {
1395             // The easiest way to bubble the revert reason is using memory via assembly
1396             /// @solidity memory-safe-assembly
1397             assembly {
1398                 let returndata_size := mload(returndata)
1399                 revert(add(32, returndata), returndata_size)
1400             }
1401         } else {
1402             revert(errorMessage);
1403         }
1404     }
1405 }
1406 
1407 // File: @openzeppelin/contracts/utils/math/Math.sol
1408 
1409 
1410 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 /**
1415  * @dev Standard math utilities missing in the Solidity language.
1416  */
1417 library Math {
1418     enum Rounding {
1419         Down, // Toward negative infinity
1420         Up, // Toward infinity
1421         Zero // Toward zero
1422     }
1423 
1424     /**
1425      * @dev Returns the largest of two numbers.
1426      */
1427     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1428         return a > b ? a : b;
1429     }
1430 
1431     /**
1432      * @dev Returns the smallest of two numbers.
1433      */
1434     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1435         return a < b ? a : b;
1436     }
1437 
1438     /**
1439      * @dev Returns the average of two numbers. The result is rounded towards
1440      * zero.
1441      */
1442     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1443         // (a + b) / 2 can overflow.
1444         return (a & b) + (a ^ b) / 2;
1445     }
1446 
1447     /**
1448      * @dev Returns the ceiling of the division of two numbers.
1449      *
1450      * This differs from standard division with `/` in that it rounds up instead
1451      * of rounding down.
1452      */
1453     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1454         // (a + b - 1) / b can overflow on addition, so we distribute.
1455         return a == 0 ? 0 : (a - 1) / b + 1;
1456     }
1457 
1458     /**
1459      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1460      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1461      * with further edits by Uniswap Labs also under MIT license.
1462      */
1463     function mulDiv(
1464         uint256 x,
1465         uint256 y,
1466         uint256 denominator
1467     ) internal pure returns (uint256 result) {
1468         unchecked {
1469             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1470             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1471             // variables such that product = prod1 * 2^256 + prod0.
1472             uint256 prod0; // Least significant 256 bits of the product
1473             uint256 prod1; // Most significant 256 bits of the product
1474             assembly {
1475                 let mm := mulmod(x, y, not(0))
1476                 prod0 := mul(x, y)
1477                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1478             }
1479 
1480             // Handle non-overflow cases, 256 by 256 division.
1481             if (prod1 == 0) {
1482                 return prod0 / denominator;
1483             }
1484 
1485             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1486             require(denominator > prod1);
1487 
1488             ///////////////////////////////////////////////
1489             // 512 by 256 division.
1490             ///////////////////////////////////////////////
1491 
1492             // Make division exact by subtracting the remainder from [prod1 prod0].
1493             uint256 remainder;
1494             assembly {
1495                 // Compute remainder using mulmod.
1496                 remainder := mulmod(x, y, denominator)
1497 
1498                 // Subtract 256 bit number from 512 bit number.
1499                 prod1 := sub(prod1, gt(remainder, prod0))
1500                 prod0 := sub(prod0, remainder)
1501             }
1502 
1503             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1504             // See https://cs.stackexchange.com/q/138556/92363.
1505 
1506             // Does not overflow because the denominator cannot be zero at this stage in the function.
1507             uint256 twos = denominator & (~denominator + 1);
1508             assembly {
1509                 // Divide denominator by twos.
1510                 denominator := div(denominator, twos)
1511 
1512                 // Divide [prod1 prod0] by twos.
1513                 prod0 := div(prod0, twos)
1514 
1515                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1516                 twos := add(div(sub(0, twos), twos), 1)
1517             }
1518 
1519             // Shift in bits from prod1 into prod0.
1520             prod0 |= prod1 * twos;
1521 
1522             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1523             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1524             // four bits. That is, denominator * inv = 1 mod 2^4.
1525             uint256 inverse = (3 * denominator) ^ 2;
1526 
1527             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1528             // in modular arithmetic, doubling the correct bits in each step.
1529             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1530             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1531             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1532             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1533             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1534             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1535 
1536             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1537             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1538             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1539             // is no longer required.
1540             result = prod0 * inverse;
1541             return result;
1542         }
1543     }
1544 
1545     /**
1546      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1547      */
1548     function mulDiv(
1549         uint256 x,
1550         uint256 y,
1551         uint256 denominator,
1552         Rounding rounding
1553     ) internal pure returns (uint256) {
1554         uint256 result = mulDiv(x, y, denominator);
1555         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1556             result += 1;
1557         }
1558         return result;
1559     }
1560 
1561     /**
1562      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1563      *
1564      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1565      */
1566     function sqrt(uint256 a) internal pure returns (uint256) {
1567         if (a == 0) {
1568             return 0;
1569         }
1570 
1571         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1572         //
1573         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1574         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1575         //
1576         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1577         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1578         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1579         //
1580         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1581         uint256 result = 1 << (log2(a) >> 1);
1582 
1583         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1584         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1585         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1586         // into the expected uint128 result.
1587         unchecked {
1588             result = (result + a / result) >> 1;
1589             result = (result + a / result) >> 1;
1590             result = (result + a / result) >> 1;
1591             result = (result + a / result) >> 1;
1592             result = (result + a / result) >> 1;
1593             result = (result + a / result) >> 1;
1594             result = (result + a / result) >> 1;
1595             return min(result, a / result);
1596         }
1597     }
1598 
1599     /**
1600      * @notice Calculates sqrt(a), following the selected rounding direction.
1601      */
1602     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1603         unchecked {
1604             uint256 result = sqrt(a);
1605             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1606         }
1607     }
1608 
1609     /**
1610      * @dev Return the log in base 2, rounded down, of a positive value.
1611      * Returns 0 if given 0.
1612      */
1613     function log2(uint256 value) internal pure returns (uint256) {
1614         uint256 result = 0;
1615         unchecked {
1616             if (value >> 128 > 0) {
1617                 value >>= 128;
1618                 result += 128;
1619             }
1620             if (value >> 64 > 0) {
1621                 value >>= 64;
1622                 result += 64;
1623             }
1624             if (value >> 32 > 0) {
1625                 value >>= 32;
1626                 result += 32;
1627             }
1628             if (value >> 16 > 0) {
1629                 value >>= 16;
1630                 result += 16;
1631             }
1632             if (value >> 8 > 0) {
1633                 value >>= 8;
1634                 result += 8;
1635             }
1636             if (value >> 4 > 0) {
1637                 value >>= 4;
1638                 result += 4;
1639             }
1640             if (value >> 2 > 0) {
1641                 value >>= 2;
1642                 result += 2;
1643             }
1644             if (value >> 1 > 0) {
1645                 result += 1;
1646             }
1647         }
1648         return result;
1649     }
1650 
1651     /**
1652      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1653      * Returns 0 if given 0.
1654      */
1655     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1656         unchecked {
1657             uint256 result = log2(value);
1658             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1659         }
1660     }
1661 
1662     /**
1663      * @dev Return the log in base 10, rounded down, of a positive value.
1664      * Returns 0 if given 0.
1665      */
1666     function log10(uint256 value) internal pure returns (uint256) {
1667         uint256 result = 0;
1668         unchecked {
1669             if (value >= 10**64) {
1670                 value /= 10**64;
1671                 result += 64;
1672             }
1673             if (value >= 10**32) {
1674                 value /= 10**32;
1675                 result += 32;
1676             }
1677             if (value >= 10**16) {
1678                 value /= 10**16;
1679                 result += 16;
1680             }
1681             if (value >= 10**8) {
1682                 value /= 10**8;
1683                 result += 8;
1684             }
1685             if (value >= 10**4) {
1686                 value /= 10**4;
1687                 result += 4;
1688             }
1689             if (value >= 10**2) {
1690                 value /= 10**2;
1691                 result += 2;
1692             }
1693             if (value >= 10**1) {
1694                 result += 1;
1695             }
1696         }
1697         return result;
1698     }
1699 
1700     /**
1701      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1702      * Returns 0 if given 0.
1703      */
1704     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1705         unchecked {
1706             uint256 result = log10(value);
1707             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1708         }
1709     }
1710 
1711     /**
1712      * @dev Return the log in base 256, rounded down, of a positive value.
1713      * Returns 0 if given 0.
1714      *
1715      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1716      */
1717     function log256(uint256 value) internal pure returns (uint256) {
1718         uint256 result = 0;
1719         unchecked {
1720             if (value >> 128 > 0) {
1721                 value >>= 128;
1722                 result += 16;
1723             }
1724             if (value >> 64 > 0) {
1725                 value >>= 64;
1726                 result += 8;
1727             }
1728             if (value >> 32 > 0) {
1729                 value >>= 32;
1730                 result += 4;
1731             }
1732             if (value >> 16 > 0) {
1733                 value >>= 16;
1734                 result += 2;
1735             }
1736             if (value >> 8 > 0) {
1737                 result += 1;
1738             }
1739         }
1740         return result;
1741     }
1742 
1743     /**
1744      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1745      * Returns 0 if given 0.
1746      */
1747     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1748         unchecked {
1749             uint256 result = log256(value);
1750             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1751         }
1752     }
1753 }
1754 
1755 // File: @openzeppelin/contracts/utils/Strings.sol
1756 
1757 
1758 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1759 
1760 pragma solidity ^0.8.0;
1761 
1762 
1763 /**
1764  * @dev String operations.
1765  */
1766 library Strings {
1767     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1768     uint8 private constant _ADDRESS_LENGTH = 20;
1769 
1770     /**
1771      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1772      */
1773     function toString(uint256 value) internal pure returns (string memory) {
1774         unchecked {
1775             uint256 length = Math.log10(value) + 1;
1776             string memory buffer = new string(length);
1777             uint256 ptr;
1778             /// @solidity memory-safe-assembly
1779             assembly {
1780                 ptr := add(buffer, add(32, length))
1781             }
1782             while (true) {
1783                 ptr--;
1784                 /// @solidity memory-safe-assembly
1785                 assembly {
1786                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1787                 }
1788                 value /= 10;
1789                 if (value == 0) break;
1790             }
1791             return buffer;
1792         }
1793     }
1794 
1795     /**
1796      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1797      */
1798     function toHexString(uint256 value) internal pure returns (string memory) {
1799         unchecked {
1800             return toHexString(value, Math.log256(value) + 1);
1801         }
1802     }
1803 
1804     /**
1805      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1806      */
1807     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1808         bytes memory buffer = new bytes(2 * length + 2);
1809         buffer[0] = "0";
1810         buffer[1] = "x";
1811         for (uint256 i = 2 * length + 1; i > 1; --i) {
1812             buffer[i] = _SYMBOLS[value & 0xf];
1813             value >>= 4;
1814         }
1815         require(value == 0, "Strings: hex length insufficient");
1816         return string(buffer);
1817     }
1818 
1819     /**
1820      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1821      */
1822     function toHexString(address addr) internal pure returns (string memory) {
1823         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1824     }
1825 }
1826 
1827 // File: @openzeppelin/contracts/utils/Context.sol
1828 
1829 
1830 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1831 
1832 pragma solidity ^0.8.0;
1833 
1834 /**
1835  * @dev Provides information about the current execution context, including the
1836  * sender of the transaction and its data. While these are generally available
1837  * via msg.sender and msg.data, they should not be accessed in such a direct
1838  * manner, since when dealing with meta-transactions the account sending and
1839  * paying for execution may not be the actual sender (as far as an application
1840  * is concerned).
1841  *
1842  * This contract is only required for intermediate, library-like contracts.
1843  */
1844 abstract contract Context {
1845     function _msgSender() internal view virtual returns (address) {
1846         return msg.sender;
1847     }
1848 
1849     function _msgData() internal view virtual returns (bytes calldata) {
1850         return msg.data;
1851     }
1852 }
1853 
1854 // File: @openzeppelin/contracts/access/Ownable.sol
1855 
1856 
1857 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1858 
1859 pragma solidity ^0.8.0;
1860 
1861 
1862 /**
1863  * @dev Contract module which provides a basic access control mechanism, where
1864  * there is an account (an owner) that can be granted exclusive access to
1865  * specific functions.
1866  *
1867  * By default, the owner account will be the one that deploys the contract. This
1868  * can later be changed with {transferOwnership}.
1869  *
1870  * This module is used through inheritance. It will make available the modifier
1871  * `onlyOwner`, which can be applied to your functions to restrict their use to
1872  * the owner.
1873  */
1874 abstract contract Ownable is Context {
1875     address private _owner;
1876 
1877     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1878 
1879     /**
1880      * @dev Initializes the contract setting the deployer as the initial owner.
1881      */
1882     constructor() {
1883         _transferOwnership(_msgSender());
1884     }
1885 
1886     /**
1887      * @dev Throws if called by any account other than the owner.
1888      */
1889     modifier onlyOwner() {
1890         _checkOwner();
1891         _;
1892     }
1893 
1894     /**
1895      * @dev Returns the address of the current owner.
1896      */
1897     function owner() public view virtual returns (address) {
1898         return _owner;
1899     }
1900 
1901     /**
1902      * @dev Throws if the sender is not the owner.
1903      */
1904     function _checkOwner() internal view virtual {
1905         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1906     }
1907 
1908     /**
1909      * @dev Leaves the contract without owner. It will not be possible to call
1910      * `onlyOwner` functions anymore. Can only be called by the current owner.
1911      *
1912      * NOTE: Renouncing ownership will leave the contract without an owner,
1913      * thereby removing any functionality that is only available to the owner.
1914      */
1915     function renounceOwnership() public virtual onlyOwner {
1916         _transferOwnership(address(0));
1917     }
1918 
1919     /**
1920      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1921      * Can only be called by the current owner.
1922      */
1923     function transferOwnership(address newOwner) public virtual onlyOwner {
1924         require(newOwner != address(0), "Ownable: new owner is the zero address");
1925         _transferOwnership(newOwner);
1926     }
1927 
1928     /**
1929      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1930      * Internal function without access restriction.
1931      */
1932     function _transferOwnership(address newOwner) internal virtual {
1933         address oldOwner = _owner;
1934         _owner = newOwner;
1935         emit OwnershipTransferred(oldOwner, newOwner);
1936     }
1937 }
1938 
1939 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1940 
1941 
1942 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1943 
1944 pragma solidity ^0.8.0;
1945 
1946 /**
1947  * @title ERC721 token receiver interface
1948  * @dev Interface for any contract that wants to support safeTransfers
1949  * from ERC721 asset contracts.
1950  */
1951 interface IERC721Receiver {
1952     /**
1953      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1954      * by `operator` from `from`, this function is called.
1955      *
1956      * It must return its Solidity selector to confirm the token transfer.
1957      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1958      *
1959      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1960      */
1961     function onERC721Received(
1962         address operator,
1963         address from,
1964         uint256 tokenId,
1965         bytes calldata data
1966     ) external returns (bytes4);
1967 }
1968 
1969 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1970 
1971 
1972 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1973 
1974 pragma solidity ^0.8.0;
1975 
1976 /**
1977  * @dev Interface of the ERC165 standard, as defined in the
1978  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1979  *
1980  * Implementers can declare support of contract interfaces, which can then be
1981  * queried by others ({ERC165Checker}).
1982  *
1983  * For an implementation, see {ERC165}.
1984  */
1985 interface IERC165 {
1986     /**
1987      * @dev Returns true if this contract implements the interface defined by
1988      * `interfaceId`. See the corresponding
1989      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1990      * to learn more about how these ids are created.
1991      *
1992      * This function call must use less than 30 000 gas.
1993      */
1994     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1995 }
1996 
1997 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1998 
1999 
2000 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2001 
2002 pragma solidity ^0.8.0;
2003 
2004 
2005 /**
2006  * @dev Interface for the NFT Royalty Standard.
2007  *
2008  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2009  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2010  *
2011  * _Available since v4.5._
2012  */
2013 interface IERC2981 is IERC165 {
2014     /**
2015      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2016      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2017      */
2018     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2019         external
2020         view
2021         returns (address receiver, uint256 royaltyAmount);
2022 }
2023 
2024 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2025 
2026 
2027 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2028 
2029 pragma solidity ^0.8.0;
2030 
2031 
2032 /**
2033  * @dev Implementation of the {IERC165} interface.
2034  *
2035  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2036  * for the additional interface id that will be supported. For example:
2037  *
2038  * ```solidity
2039  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2040  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2041  * }
2042  * ```
2043  *
2044  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2045  */
2046 abstract contract ERC165 is IERC165 {
2047     /**
2048      * @dev See {IERC165-supportsInterface}.
2049      */
2050     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2051         return interfaceId == type(IERC165).interfaceId;
2052     }
2053 }
2054 
2055 // File: @openzeppelin/contracts/token/common/ERC2981.sol
2056 
2057 
2058 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2059 
2060 pragma solidity ^0.8.0;
2061 
2062 
2063 
2064 /**
2065  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2066  *
2067  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2068  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2069  *
2070  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2071  * fee is specified in basis points by default.
2072  *
2073  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2074  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2075  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2076  *
2077  * _Available since v4.5._
2078  */
2079 abstract contract ERC2981 is IERC2981, ERC165 {
2080     struct RoyaltyInfo {
2081         address receiver;
2082         uint96 royaltyFraction;
2083     }
2084 
2085     RoyaltyInfo private _defaultRoyaltyInfo;
2086     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2087 
2088     /**
2089      * @dev See {IERC165-supportsInterface}.
2090      */
2091     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2092         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2093     }
2094 
2095     /**
2096      * @inheritdoc IERC2981
2097      */
2098     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2099         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2100 
2101         if (royalty.receiver == address(0)) {
2102             royalty = _defaultRoyaltyInfo;
2103         }
2104 
2105         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2106 
2107         return (royalty.receiver, royaltyAmount);
2108     }
2109 
2110     /**
2111      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2112      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2113      * override.
2114      */
2115     function _feeDenominator() internal pure virtual returns (uint96) {
2116         return 10000;
2117     }
2118 
2119     /**
2120      * @dev Sets the royalty information that all ids in this contract will default to.
2121      *
2122      * Requirements:
2123      *
2124      * - `receiver` cannot be the zero address.
2125      * - `feeNumerator` cannot be greater than the fee denominator.
2126      */
2127     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2128         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2129         require(receiver != address(0), "ERC2981: invalid receiver");
2130 
2131         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2132     }
2133 
2134     /**
2135      * @dev Removes default royalty information.
2136      */
2137     function _deleteDefaultRoyalty() internal virtual {
2138         delete _defaultRoyaltyInfo;
2139     }
2140 
2141     /**
2142      * @dev Sets the royalty information for a specific token id, overriding the global default.
2143      *
2144      * Requirements:
2145      *
2146      * - `receiver` cannot be the zero address.
2147      * - `feeNumerator` cannot be greater than the fee denominator.
2148      */
2149     function _setTokenRoyalty(
2150         uint256 tokenId,
2151         address receiver,
2152         uint96 feeNumerator
2153     ) internal virtual {
2154         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2155         require(receiver != address(0), "ERC2981: Invalid parameters");
2156 
2157         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2158     }
2159 
2160     /**
2161      * @dev Resets royalty information for the token id back to the global default.
2162      */
2163     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2164         delete _tokenRoyaltyInfo[tokenId];
2165     }
2166 }
2167 
2168 // File: @openzeppelin/contracts/access/AccessControl.sol
2169 
2170 
2171 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
2172 
2173 pragma solidity ^0.8.0;
2174 
2175 
2176 
2177 
2178 
2179 /**
2180  * @dev Contract module that allows children to implement role-based access
2181  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2182  * members except through off-chain means by accessing the contract event logs. Some
2183  * applications may benefit from on-chain enumerability, for those cases see
2184  * {AccessControlEnumerable}.
2185  *
2186  * Roles are referred to by their `bytes32` identifier. These should be exposed
2187  * in the external API and be unique. The best way to achieve this is by
2188  * using `public constant` hash digests:
2189  *
2190  * ```
2191  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2192  * ```
2193  *
2194  * Roles can be used to represent a set of permissions. To restrict access to a
2195  * function call, use {hasRole}:
2196  *
2197  * ```
2198  * function foo() public {
2199  *     require(hasRole(MY_ROLE, msg.sender));
2200  *     ...
2201  * }
2202  * ```
2203  *
2204  * Roles can be granted and revoked dynamically via the {grantRole} and
2205  * {revokeRole} functions. Each role has an associated admin role, and only
2206  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2207  *
2208  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2209  * that only accounts with this role will be able to grant or revoke other
2210  * roles. More complex role relationships can be created by using
2211  * {_setRoleAdmin}.
2212  *
2213  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2214  * grant and revoke this role. Extra precautions should be taken to secure
2215  * accounts that have been granted it.
2216  */
2217 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2218     struct RoleData {
2219         mapping(address => bool) members;
2220         bytes32 adminRole;
2221     }
2222 
2223     mapping(bytes32 => RoleData) private _roles;
2224 
2225     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2226 
2227     /**
2228      * @dev Modifier that checks that an account has a specific role. Reverts
2229      * with a standardized message including the required role.
2230      *
2231      * The format of the revert reason is given by the following regular expression:
2232      *
2233      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2234      *
2235      * _Available since v4.1._
2236      */
2237     modifier onlyRole(bytes32 role) {
2238         _checkRole(role);
2239         _;
2240     }
2241 
2242     /**
2243      * @dev See {IERC165-supportsInterface}.
2244      */
2245     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2246         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2247     }
2248 
2249     /**
2250      * @dev Returns `true` if `account` has been granted `role`.
2251      */
2252     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2253         return _roles[role].members[account];
2254     }
2255 
2256     /**
2257      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2258      * Overriding this function changes the behavior of the {onlyRole} modifier.
2259      *
2260      * Format of the revert message is described in {_checkRole}.
2261      *
2262      * _Available since v4.6._
2263      */
2264     function _checkRole(bytes32 role) internal view virtual {
2265         _checkRole(role, _msgSender());
2266     }
2267 
2268     /**
2269      * @dev Revert with a standard message if `account` is missing `role`.
2270      *
2271      * The format of the revert reason is given by the following regular expression:
2272      *
2273      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2274      */
2275     function _checkRole(bytes32 role, address account) internal view virtual {
2276         if (!hasRole(role, account)) {
2277             revert(
2278                 string(
2279                     abi.encodePacked(
2280                         "AccessControl: account ",
2281                         Strings.toHexString(account),
2282                         " is missing role ",
2283                         Strings.toHexString(uint256(role), 32)
2284                     )
2285                 )
2286             );
2287         }
2288     }
2289 
2290     /**
2291      * @dev Returns the admin role that controls `role`. See {grantRole} and
2292      * {revokeRole}.
2293      *
2294      * To change a role's admin, use {_setRoleAdmin}.
2295      */
2296     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2297         return _roles[role].adminRole;
2298     }
2299 
2300     /**
2301      * @dev Grants `role` to `account`.
2302      *
2303      * If `account` had not been already granted `role`, emits a {RoleGranted}
2304      * event.
2305      *
2306      * Requirements:
2307      *
2308      * - the caller must have ``role``'s admin role.
2309      *
2310      * May emit a {RoleGranted} event.
2311      */
2312     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2313         _grantRole(role, account);
2314     }
2315 
2316     /**
2317      * @dev Revokes `role` from `account`.
2318      *
2319      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2320      *
2321      * Requirements:
2322      *
2323      * - the caller must have ``role``'s admin role.
2324      *
2325      * May emit a {RoleRevoked} event.
2326      */
2327     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2328         _revokeRole(role, account);
2329     }
2330 
2331     /**
2332      * @dev Revokes `role` from the calling account.
2333      *
2334      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2335      * purpose is to provide a mechanism for accounts to lose their privileges
2336      * if they are compromised (such as when a trusted device is misplaced).
2337      *
2338      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2339      * event.
2340      *
2341      * Requirements:
2342      *
2343      * - the caller must be `account`.
2344      *
2345      * May emit a {RoleRevoked} event.
2346      */
2347     function renounceRole(bytes32 role, address account) public virtual override {
2348         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2349 
2350         _revokeRole(role, account);
2351     }
2352 
2353     /**
2354      * @dev Grants `role` to `account`.
2355      *
2356      * If `account` had not been already granted `role`, emits a {RoleGranted}
2357      * event. Note that unlike {grantRole}, this function doesn't perform any
2358      * checks on the calling account.
2359      *
2360      * May emit a {RoleGranted} event.
2361      *
2362      * [WARNING]
2363      * ====
2364      * This function should only be called from the constructor when setting
2365      * up the initial roles for the system.
2366      *
2367      * Using this function in any other way is effectively circumventing the admin
2368      * system imposed by {AccessControl}.
2369      * ====
2370      *
2371      * NOTE: This function is deprecated in favor of {_grantRole}.
2372      */
2373     function _setupRole(bytes32 role, address account) internal virtual {
2374         _grantRole(role, account);
2375     }
2376 
2377     /**
2378      * @dev Sets `adminRole` as ``role``'s admin role.
2379      *
2380      * Emits a {RoleAdminChanged} event.
2381      */
2382     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2383         bytes32 previousAdminRole = getRoleAdmin(role);
2384         _roles[role].adminRole = adminRole;
2385         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2386     }
2387 
2388     /**
2389      * @dev Grants `role` to `account`.
2390      *
2391      * Internal function without access restriction.
2392      *
2393      * May emit a {RoleGranted} event.
2394      */
2395     function _grantRole(bytes32 role, address account) internal virtual {
2396         if (!hasRole(role, account)) {
2397             _roles[role].members[account] = true;
2398             emit RoleGranted(role, account, _msgSender());
2399         }
2400     }
2401 
2402     /**
2403      * @dev Revokes `role` from `account`.
2404      *
2405      * Internal function without access restriction.
2406      *
2407      * May emit a {RoleRevoked} event.
2408      */
2409     function _revokeRole(bytes32 role, address account) internal virtual {
2410         if (hasRole(role, account)) {
2411             _roles[role].members[account] = false;
2412             emit RoleRevoked(role, account, _msgSender());
2413         }
2414     }
2415 }
2416 
2417 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2418 
2419 
2420 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2421 
2422 pragma solidity ^0.8.0;
2423 
2424 
2425 /**
2426  * @dev Required interface of an ERC721 compliant contract.
2427  */
2428 interface IERC721 is IERC165 {
2429     /**
2430      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2431      */
2432     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2433 
2434     /**
2435      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2436      */
2437     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2438 
2439     /**
2440      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2441      */
2442     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2443 
2444     /**
2445      * @dev Returns the number of tokens in ``owner``'s account.
2446      */
2447     function balanceOf(address owner) external view returns (uint256 balance);
2448 
2449     /**
2450      * @dev Returns the owner of the `tokenId` token.
2451      *
2452      * Requirements:
2453      *
2454      * - `tokenId` must exist.
2455      */
2456     function ownerOf(uint256 tokenId) external view returns (address owner);
2457 
2458     /**
2459      * @dev Safely transfers `tokenId` token from `from` to `to`.
2460      *
2461      * Requirements:
2462      *
2463      * - `from` cannot be the zero address.
2464      * - `to` cannot be the zero address.
2465      * - `tokenId` token must exist and be owned by `from`.
2466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2468      *
2469      * Emits a {Transfer} event.
2470      */
2471     function safeTransferFrom(
2472         address from,
2473         address to,
2474         uint256 tokenId,
2475         bytes calldata data
2476     ) external;
2477 
2478     /**
2479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2481      *
2482      * Requirements:
2483      *
2484      * - `from` cannot be the zero address.
2485      * - `to` cannot be the zero address.
2486      * - `tokenId` token must exist and be owned by `from`.
2487      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2489      *
2490      * Emits a {Transfer} event.
2491      */
2492     function safeTransferFrom(
2493         address from,
2494         address to,
2495         uint256 tokenId
2496     ) external;
2497 
2498     /**
2499      * @dev Transfers `tokenId` token from `from` to `to`.
2500      *
2501      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2502      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2503      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2504      *
2505      * Requirements:
2506      *
2507      * - `from` cannot be the zero address.
2508      * - `to` cannot be the zero address.
2509      * - `tokenId` token must be owned by `from`.
2510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2511      *
2512      * Emits a {Transfer} event.
2513      */
2514     function transferFrom(
2515         address from,
2516         address to,
2517         uint256 tokenId
2518     ) external;
2519 
2520     /**
2521      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2522      * The approval is cleared when the token is transferred.
2523      *
2524      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2525      *
2526      * Requirements:
2527      *
2528      * - The caller must own the token or be an approved operator.
2529      * - `tokenId` must exist.
2530      *
2531      * Emits an {Approval} event.
2532      */
2533     function approve(address to, uint256 tokenId) external;
2534 
2535     /**
2536      * @dev Approve or remove `operator` as an operator for the caller.
2537      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2538      *
2539      * Requirements:
2540      *
2541      * - The `operator` cannot be the caller.
2542      *
2543      * Emits an {ApprovalForAll} event.
2544      */
2545     function setApprovalForAll(address operator, bool _approved) external;
2546 
2547     /**
2548      * @dev Returns the account approved for `tokenId` token.
2549      *
2550      * Requirements:
2551      *
2552      * - `tokenId` must exist.
2553      */
2554     function getApproved(uint256 tokenId) external view returns (address operator);
2555 
2556     /**
2557      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2558      *
2559      * See {setApprovalForAll}
2560      */
2561     function isApprovedForAll(address owner, address operator) external view returns (bool);
2562 }
2563 
2564 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2565 
2566 
2567 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2568 
2569 pragma solidity ^0.8.0;
2570 
2571 
2572 /**
2573  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2574  * @dev See https://eips.ethereum.org/EIPS/eip-721
2575  */
2576 interface IERC721Metadata is IERC721 {
2577     /**
2578      * @dev Returns the token collection name.
2579      */
2580     function name() external view returns (string memory);
2581 
2582     /**
2583      * @dev Returns the token collection symbol.
2584      */
2585     function symbol() external view returns (string memory);
2586 
2587     /**
2588      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2589      */
2590     function tokenURI(uint256 tokenId) external view returns (string memory);
2591 }
2592 
2593 // File: solidity-bits/contracts/BitScan.sol
2594 
2595 
2596 /**
2597    _____       ___     ___ __           ____  _ __      
2598   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
2599   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
2600  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
2601 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
2602                            /____/                        
2603 
2604 - npm: https://www.npmjs.com/package/solidity-bits
2605 - github: https://github.com/estarriolvetch/solidity-bits
2606 
2607  */
2608 
2609 pragma solidity ^0.8.0;
2610 
2611 
2612 library BitScan {
2613     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
2614     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
2615 
2616     /**
2617         @dev Isolate the least significant set bit.
2618      */ 
2619     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
2620         require(bb > 0);
2621         unchecked {
2622             return bb & (0 - bb);
2623         }
2624     } 
2625 
2626     /**
2627         @dev Isolate the most significant set bit.
2628      */ 
2629     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
2630         require(bb > 0);
2631         unchecked {
2632             bb |= bb >> 128;
2633             bb |= bb >> 64;
2634             bb |= bb >> 32;
2635             bb |= bb >> 16;
2636             bb |= bb >> 8;
2637             bb |= bb >> 4;
2638             bb |= bb >> 2;
2639             bb |= bb >> 1;
2640             
2641             return (bb >> 1) + 1;
2642         }
2643     } 
2644 
2645     /**
2646         @dev Find the index of the lest significant set bit. (trailing zero count)
2647      */ 
2648     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
2649         unchecked {
2650             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
2651         }   
2652     }
2653 
2654     /**
2655         @dev Find the index of the most significant set bit.
2656      */ 
2657     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
2658         unchecked {
2659             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
2660         }   
2661     }
2662 
2663     function log2(uint256 bb) pure internal returns (uint8) {
2664         unchecked {
2665             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
2666         } 
2667     }
2668 }
2669 
2670 // File: solidity-bits/contracts/BitMaps.sol
2671 
2672 
2673 /**
2674    _____       ___     ___ __           ____  _ __      
2675   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
2676   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
2677  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
2678 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
2679                            /____/                        
2680 
2681 - npm: https://www.npmjs.com/package/solidity-bits
2682 - github: https://github.com/estarriolvetch/solidity-bits
2683 
2684  */
2685 pragma solidity ^0.8.0;
2686 
2687 
2688 /**
2689  * @dev This Library is a modified version of Openzeppelin's BitMaps library.
2690  * Functions of finding the index of the closest set bit from a given index are added.
2691  * The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
2692  * The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
2693 */
2694 
2695 /**
2696  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
2697  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
2698  */
2699 
2700 library BitMaps {
2701     using BitScan for uint256;
2702     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
2703     uint256 private constant MASK_FULL = type(uint256).max;
2704 
2705     struct BitMap {
2706         mapping(uint256 => uint256) _data;
2707     }
2708 
2709     /**
2710      * @dev Returns whether the bit at `index` is set.
2711      */
2712     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
2713         uint256 bucket = index >> 8;
2714         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
2715         return bitmap._data[bucket] & mask != 0;
2716     }
2717 
2718     /**
2719      * @dev Sets the bit at `index` to the boolean `value`.
2720      */
2721     function setTo(
2722         BitMap storage bitmap,
2723         uint256 index,
2724         bool value
2725     ) internal {
2726         if (value) {
2727             set(bitmap, index);
2728         } else {
2729             unset(bitmap, index);
2730         }
2731     }
2732 
2733     /**
2734      * @dev Sets the bit at `index`.
2735      */
2736     function set(BitMap storage bitmap, uint256 index) internal {
2737         uint256 bucket = index >> 8;
2738         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
2739         bitmap._data[bucket] |= mask;
2740     }
2741 
2742     /**
2743      * @dev Unsets the bit at `index`.
2744      */
2745     function unset(BitMap storage bitmap, uint256 index) internal {
2746         uint256 bucket = index >> 8;
2747         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
2748         bitmap._data[bucket] &= ~mask;
2749     }
2750 
2751 
2752     /**
2753      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
2754      */    
2755     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
2756         uint256 bucket = startIndex >> 8;
2757 
2758         uint256 bucketStartIndex = (startIndex & 0xff);
2759 
2760         unchecked {
2761             if(bucketStartIndex + amount < 256) {
2762                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
2763             } else {
2764                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
2765                 amount -= (256 - bucketStartIndex);
2766                 bucket++;
2767 
2768                 while(amount > 256) {
2769                     bitmap._data[bucket] = MASK_FULL;
2770                     amount -= 256;
2771                     bucket++;
2772                 }
2773 
2774                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
2775             }
2776         }
2777     }
2778 
2779 
2780     /**
2781      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
2782      */    
2783     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
2784         uint256 bucket = startIndex >> 8;
2785 
2786         uint256 bucketStartIndex = (startIndex & 0xff);
2787 
2788         unchecked {
2789             if(bucketStartIndex + amount < 256) {
2790                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
2791             } else {
2792                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
2793                 amount -= (256 - bucketStartIndex);
2794                 bucket++;
2795 
2796                 while(amount > 256) {
2797                     bitmap._data[bucket] = 0;
2798                     amount -= 256;
2799                     bucket++;
2800                 }
2801 
2802                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
2803             }
2804         }
2805     }
2806 
2807 
2808     /**
2809      * @dev Find the closest index of the set bit before `index`.
2810      */
2811     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
2812         uint256 bucket = index >> 8;
2813 
2814         // index within the bucket
2815         uint256 bucketIndex = (index & 0xff);
2816 
2817         // load a bitboard from the bitmap.
2818         uint256 bb = bitmap._data[bucket];
2819 
2820         // offset the bitboard to scan from `bucketIndex`.
2821         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
2822         
2823         if(bb > 0) {
2824             unchecked {
2825                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());    
2826             }
2827         } else {
2828             while(true) {
2829                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
2830                 unchecked {
2831                     bucket--;
2832                 }
2833                 // No offset. Always scan from the least significiant bit now.
2834                 bb = bitmap._data[bucket];
2835                 
2836                 if(bb > 0) {
2837                     unchecked {
2838                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
2839                         break;
2840                     }
2841                 } 
2842             }
2843         }
2844     }
2845 
2846     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
2847         return bitmap._data[bucket];
2848     }
2849 }
2850 
2851 // File: erc721psi/contracts/ERC721Psi.sol
2852 
2853 
2854 /**
2855   ______ _____   _____ ______ ___  __ _  _  _ 
2856  |  ____|  __ \ / ____|____  |__ \/_ | || || |
2857  | |__  | |__) | |        / /   ) || | \| |/ |
2858  |  __| |  _  /| |       / /   / / | |\_   _/ 
2859  | |____| | \ \| |____  / /   / /_ | |  | |   
2860  |______|_|  \_\\_____|/_/   |____||_|  |_|   
2861 
2862  - github: https://github.com/estarriolvetch/ERC721Psi
2863  - npm: https://www.npmjs.com/package/erc721psi
2864                                           
2865  */
2866 
2867 pragma solidity ^0.8.0;
2868 
2869 
2870 
2871 
2872 
2873 
2874 
2875 
2876 
2877 
2878 
2879 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata {
2880     using Address for address;
2881     using Strings for uint256;
2882     using BitMaps for BitMaps.BitMap;
2883 
2884     BitMaps.BitMap private _batchHead;
2885 
2886     string private _name;
2887     string private _symbol;
2888 
2889     // Mapping from token ID to owner address
2890     mapping(uint256 => address) internal _owners;
2891     uint256 private _currentIndex;
2892 
2893     mapping(uint256 => address) private _tokenApprovals;
2894     mapping(address => mapping(address => bool)) private _operatorApprovals;
2895 
2896     /**
2897      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2898      */
2899     constructor(string memory name_, string memory symbol_) {
2900         _name = name_;
2901         _symbol = symbol_;
2902         _currentIndex = _startTokenId();
2903     }
2904 
2905     /**
2906      * @dev Returns the starting token ID.
2907      * To change the starting token ID, please override this function.
2908      */
2909     function _startTokenId() internal pure returns (uint256) {
2910         // It will become modifiable in the future versions
2911         return 0;
2912     }
2913 
2914     /**
2915      * @dev Returns the next token ID to be minted.
2916      */
2917     function _nextTokenId() internal view virtual returns (uint256) {
2918         return _currentIndex;
2919     }
2920 
2921     /**
2922      * @dev Returns the total amount of tokens minted in the contract.
2923      */
2924     function _totalMinted() internal view virtual returns (uint256) {
2925         return _currentIndex - _startTokenId();
2926     }
2927 
2928 
2929     /**
2930      * @dev See {IERC165-supportsInterface}.
2931      */
2932     function supportsInterface(bytes4 interfaceId)
2933         public
2934         view
2935         virtual
2936         override(ERC165, IERC165)
2937         returns (bool)
2938     {
2939         return
2940             interfaceId == type(IERC721).interfaceId ||
2941             interfaceId == type(IERC721Metadata).interfaceId ||
2942             super.supportsInterface(interfaceId);
2943     }
2944 
2945     /**
2946      * @dev See {IERC721-balanceOf}.
2947      */
2948     function balanceOf(address owner) 
2949         public 
2950         view 
2951         virtual 
2952         override 
2953         returns (uint) 
2954     {
2955         require(owner != address(0), "ERC721Psi: balance query for the zero address");
2956 
2957         uint count;
2958         for( uint i = _startTokenId(); i < _nextTokenId(); ++i ){
2959             if(_exists(i)){
2960                 if( owner == ownerOf(i)){
2961                     ++count;
2962                 }
2963             }
2964         }
2965         return count;
2966     }
2967 
2968     /**
2969      * @dev See {IERC721-ownerOf}.
2970      */
2971     function ownerOf(uint256 tokenId)
2972         public
2973         view
2974         virtual
2975         override
2976         returns (address)
2977     {
2978         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
2979         return owner;
2980     }
2981 
2982     function _ownerAndBatchHeadOf(uint256 tokenId) internal view returns (address owner, uint256 tokenIdBatchHead){
2983         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
2984         tokenIdBatchHead = _getBatchHead(tokenId);
2985         owner = _owners[tokenIdBatchHead];
2986     }
2987 
2988     /**
2989      * @dev See {IERC721Metadata-name}.
2990      */
2991     function name() public view virtual override returns (string memory) {
2992         return _name;
2993     }
2994 
2995     /**
2996      * @dev See {IERC721Metadata-symbol}.
2997      */
2998     function symbol() public view virtual override returns (string memory) {
2999         return _symbol;
3000     }
3001 
3002     /**
3003      * @dev See {IERC721Metadata-tokenURI}.
3004      */
3005     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3006         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
3007 
3008         string memory baseURI = _baseURI();
3009         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3010     }
3011 
3012     /**
3013      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3014      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3015      * by default, can be overriden in child contracts.
3016      */
3017     function _baseURI() internal view virtual returns (string memory) {
3018         return "";
3019     }
3020 
3021 
3022     /**
3023      * @dev See {IERC721-approve}.
3024      */
3025     function approve(address to, uint256 tokenId) public virtual override {
3026         address owner = ownerOf(tokenId);
3027         require(to != owner, "ERC721Psi: approval to current owner");
3028 
3029         require(
3030             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3031             "ERC721Psi: approve caller is not owner nor approved for all"
3032         );
3033 
3034         _approve(to, tokenId);
3035     }
3036 
3037     /**
3038      * @dev See {IERC721-getApproved}.
3039      */
3040     function getApproved(uint256 tokenId)
3041         public
3042         view
3043         virtual
3044         override
3045         returns (address)
3046     {
3047         require(
3048             _exists(tokenId),
3049             "ERC721Psi: approved query for nonexistent token"
3050         );
3051 
3052         return _tokenApprovals[tokenId];
3053     }
3054 
3055     /**
3056      * @dev See {IERC721-setApprovalForAll}.
3057      */
3058     function setApprovalForAll(address operator, bool approved)
3059         public
3060         virtual
3061         override
3062     {
3063         require(operator != _msgSender(), "ERC721Psi: approve to caller");
3064 
3065         _operatorApprovals[_msgSender()][operator] = approved;
3066         emit ApprovalForAll(_msgSender(), operator, approved);
3067     }
3068 
3069     /**
3070      * @dev See {IERC721-isApprovedForAll}.
3071      */
3072     function isApprovedForAll(address owner, address operator)
3073         public
3074         view
3075         virtual
3076         override
3077         returns (bool)
3078     {
3079         return _operatorApprovals[owner][operator];
3080     }
3081 
3082     /**
3083      * @dev See {IERC721-transferFrom}.
3084      */
3085     function transferFrom(
3086         address from,
3087         address to,
3088         uint256 tokenId
3089     ) public virtual override {
3090         //solhint-disable-next-line max-line-length
3091         require(
3092             _isApprovedOrOwner(_msgSender(), tokenId),
3093             "ERC721Psi: transfer caller is not owner nor approved"
3094         );
3095 
3096         _transfer(from, to, tokenId);
3097     }
3098 
3099     /**
3100      * @dev See {IERC721-safeTransferFrom}.
3101      */
3102     function safeTransferFrom(
3103         address from,
3104         address to,
3105         uint256 tokenId
3106     ) public virtual override {
3107         safeTransferFrom(from, to, tokenId, "");
3108     }
3109 
3110     /**
3111      * @dev See {IERC721-safeTransferFrom}.
3112      */
3113     function safeTransferFrom(
3114         address from,
3115         address to,
3116         uint256 tokenId,
3117         bytes memory _data
3118     ) public virtual override {
3119         require(
3120             _isApprovedOrOwner(_msgSender(), tokenId),
3121             "ERC721Psi: transfer caller is not owner nor approved"
3122         );
3123         _safeTransfer(from, to, tokenId, _data);
3124     }
3125 
3126     /**
3127      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3128      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3129      *
3130      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
3131      *
3132      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3133      * implement alternative mechanisms to perform token transfer, such as signature-based.
3134      *
3135      * Requirements:
3136      *
3137      * - `from` cannot be the zero address.
3138      * - `to` cannot be the zero address.
3139      * - `tokenId` token must exist and be owned by `from`.
3140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3141      *
3142      * Emits a {Transfer} event.
3143      */
3144     function _safeTransfer(
3145         address from,
3146         address to,
3147         uint256 tokenId,
3148         bytes memory _data
3149     ) internal virtual {
3150         _transfer(from, to, tokenId);
3151         require(
3152             _checkOnERC721Received(from, to, tokenId, 1,_data),
3153             "ERC721Psi: transfer to non ERC721Receiver implementer"
3154         );
3155     }
3156 
3157     /**
3158      * @dev Returns whether `tokenId` exists.
3159      *
3160      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3161      *
3162      * Tokens start existing when they are minted (`_mint`).
3163      */
3164     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3165         return tokenId < _nextTokenId() && _startTokenId() <= tokenId;
3166     }
3167 
3168     /**
3169      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3170      *
3171      * Requirements:
3172      *
3173      * - `tokenId` must exist.
3174      */
3175     function _isApprovedOrOwner(address spender, uint256 tokenId)
3176         internal
3177         view
3178         virtual
3179         returns (bool)
3180     {
3181         require(
3182             _exists(tokenId),
3183             "ERC721Psi: operator query for nonexistent token"
3184         );
3185         address owner = ownerOf(tokenId);
3186         return (spender == owner ||
3187             getApproved(tokenId) == spender ||
3188             isApprovedForAll(owner, spender));
3189     }
3190 
3191     /**
3192      * @dev Safely mints `quantity` tokens and transfers them to `to`.
3193      *
3194      * Requirements:
3195      *
3196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
3197      * - `quantity` must be greater than 0.
3198      *
3199      * Emits a {Transfer} event.
3200      */
3201     function _safeMint(address to, uint256 quantity) internal virtual {
3202         _safeMint(to, quantity, "");
3203     }
3204 
3205     
3206     function _safeMint(
3207         address to,
3208         uint256 quantity,
3209         bytes memory _data
3210     ) internal virtual {
3211         uint256 nextTokenId = _nextTokenId();
3212         _mint(to, quantity);
3213         require(
3214             _checkOnERC721Received(address(0), to, nextTokenId, quantity, _data),
3215             "ERC721Psi: transfer to non ERC721Receiver implementer"
3216         );
3217     }
3218 
3219 
3220     function _mint(
3221         address to,
3222         uint256 quantity
3223     ) internal virtual {
3224         uint256 nextTokenId = _nextTokenId();
3225         
3226         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
3227         require(to != address(0), "ERC721Psi: mint to the zero address");
3228         
3229         _beforeTokenTransfers(address(0), to, nextTokenId, quantity);
3230         _currentIndex += quantity;
3231         _owners[nextTokenId] = to;
3232         _batchHead.set(nextTokenId);
3233         _afterTokenTransfers(address(0), to, nextTokenId, quantity);
3234         
3235         // Emit events
3236         for(uint256 tokenId=nextTokenId; tokenId < nextTokenId + quantity; tokenId++){
3237             emit Transfer(address(0), to, tokenId);
3238         } 
3239     }
3240 
3241 
3242     /**
3243      * @dev Transfers `tokenId` from `from` to `to`.
3244      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3245      *
3246      * Requirements:
3247      *
3248      * - `to` cannot be the zero address.
3249      * - `tokenId` token must be owned by `from`.
3250      *
3251      * Emits a {Transfer} event.
3252      */
3253     function _transfer(
3254         address from,
3255         address to,
3256         uint256 tokenId
3257     ) internal virtual {
3258         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
3259 
3260         require(
3261             owner == from,
3262             "ERC721Psi: transfer of token that is not own"
3263         );
3264         require(to != address(0), "ERC721Psi: transfer to the zero address");
3265 
3266         _beforeTokenTransfers(from, to, tokenId, 1);
3267 
3268         // Clear approvals from the previous owner
3269         _approve(address(0), tokenId);   
3270 
3271         uint256 subsequentTokenId = tokenId + 1;
3272 
3273         if(!_batchHead.get(subsequentTokenId) &&  
3274             subsequentTokenId < _nextTokenId()
3275         ) {
3276             _owners[subsequentTokenId] = from;
3277             _batchHead.set(subsequentTokenId);
3278         }
3279 
3280         _owners[tokenId] = to;
3281         if(tokenId != tokenIdBatchHead) {
3282             _batchHead.set(tokenId);
3283         }
3284 
3285         emit Transfer(from, to, tokenId);
3286 
3287         _afterTokenTransfers(from, to, tokenId, 1);
3288     }
3289 
3290     /**
3291      * @dev Approve `to` to operate on `tokenId`
3292      *
3293      * Emits a {Approval} event.
3294      */
3295     function _approve(address to, uint256 tokenId) internal virtual {
3296         _tokenApprovals[tokenId] = to;
3297         emit Approval(ownerOf(tokenId), to, tokenId);
3298     }
3299 
3300     /**
3301      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3302      * The call is not executed if the target address is not a contract.
3303      *
3304      * @param from address representing the previous owner of the given token ID
3305      * @param to target address that will receive the tokens
3306      * @param startTokenId uint256 the first ID of the tokens to be transferred
3307      * @param quantity uint256 amount of the tokens to be transfered.
3308      * @param _data bytes optional data to send along with the call
3309      * @return r bool whether the call correctly returned the expected magic value
3310      */
3311     function _checkOnERC721Received(
3312         address from,
3313         address to,
3314         uint256 startTokenId,
3315         uint256 quantity,
3316         bytes memory _data
3317     ) private returns (bool r) {
3318         if (to.isContract()) {
3319             r = true;
3320             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
3321                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3322                     r = r && retval == IERC721Receiver.onERC721Received.selector;
3323                 } catch (bytes memory reason) {
3324                     if (reason.length == 0) {
3325                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
3326                     } else {
3327                         assembly {
3328                             revert(add(32, reason), mload(reason))
3329                         }
3330                     }
3331                 }
3332             }
3333             return r;
3334         } else {
3335             return true;
3336         }
3337     }
3338 
3339     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
3340         tokenIdBatchHead = _batchHead.scanForward(tokenId); 
3341     }
3342 
3343 
3344     function totalSupply() public virtual view returns (uint256) {
3345         return _totalMinted();
3346     }
3347 
3348     /**
3349      * @dev Returns an array of token IDs owned by `owner`.
3350      *
3351      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
3352      * It is meant to be called off-chain.
3353      *
3354      * This function is compatiable with ERC721AQueryable.
3355      */
3356     function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
3357         unchecked {
3358             uint256 tokenIdsIdx;
3359             uint256 tokenIdsLength = balanceOf(owner);
3360             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
3361             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
3362                 if (_exists(i)) {
3363                     if (ownerOf(i) == owner) {
3364                         tokenIds[tokenIdsIdx++] = i;
3365                     }
3366                 }
3367             }
3368             return tokenIds;   
3369         }
3370     }
3371 
3372     /**
3373      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
3374      *
3375      * startTokenId - the first token id to be transferred
3376      * quantity - the amount to be transferred
3377      *
3378      * Calling conditions:
3379      *
3380      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3381      * transferred to `to`.
3382      * - When `from` is zero, `tokenId` will be minted for `to`.
3383      */
3384     function _beforeTokenTransfers(
3385         address from,
3386         address to,
3387         uint256 startTokenId,
3388         uint256 quantity
3389     ) internal virtual {}
3390 
3391     /**
3392      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3393      * minting.
3394      *
3395      * startTokenId - the first token id to be transferred
3396      * quantity - the amount to be transferred
3397      *
3398      * Calling conditions:
3399      *
3400      * - when `from` and `to` are both non-zero.
3401      * - `from` and `to` are never both zero.
3402      */
3403     function _afterTokenTransfers(
3404         address from,
3405         address to,
3406         uint256 startTokenId,
3407         uint256 quantity
3408     ) internal virtual {}
3409 }
3410 // File: erc721psi/contracts/extension/ERC721PsiBurnable.sol
3411 
3412 
3413 /**
3414   ______ _____   _____ ______ ___  __ _  _  _ 
3415  |  ____|  __ \ / ____|____  |__ \/_ | || || |
3416  | |__  | |__) | |        / /   ) || | \| |/ |
3417  |  __| |  _  /| |       / /   / / | |\_   _/ 
3418  | |____| | \ \| |____  / /   / /_ | |  | |   
3419  |______|_|  \_\\_____|/_/   |____||_|  |_|   
3420                                               
3421                                             
3422  */
3423 pragma solidity ^0.8.0;
3424 
3425 
3426 
3427 
3428 abstract contract ERC721PsiBurnable is ERC721Psi {
3429     using BitMaps for BitMaps.BitMap;
3430     BitMaps.BitMap private _burnedToken;
3431 
3432     /**
3433      * @dev Destroys `tokenId`.
3434      * The approval is cleared when the token is burned.
3435      *
3436      * Requirements:
3437      *
3438      * - `tokenId` must exist.
3439      *
3440      * Emits a {Transfer} event.
3441      */
3442     function _burn(uint256 tokenId) internal virtual {
3443         address from = ownerOf(tokenId);
3444         _beforeTokenTransfers(from, address(0), tokenId, 1);
3445         _burnedToken.set(tokenId);
3446         
3447         emit Transfer(from, address(0), tokenId);
3448 
3449         _afterTokenTransfers(from, address(0), tokenId, 1);
3450     }
3451 
3452     /**
3453      * @dev Returns whether `tokenId` exists.
3454      *
3455      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3456      *
3457      * Tokens start existing when they are minted (`_mint`),
3458      * and stop existing when they are burned (`_burn`).
3459      */
3460     function _exists(uint256 tokenId) internal view override virtual returns (bool){
3461         if(_burnedToken.get(tokenId)) {
3462             return false;
3463         } 
3464         return super._exists(tokenId);
3465     }
3466 
3467     /**
3468      * @dev See {IERC721Enumerable-totalSupply}.
3469      */
3470     function totalSupply() public view virtual override returns (uint256) {
3471         return _totalMinted() - _burned();
3472     }
3473 
3474     /**
3475      * @dev Returns number of token burned.
3476      */
3477     function _burned() internal view returns (uint256 burned){
3478         uint256 startBucket = _startTokenId() >> 8;
3479         uint256 lastBucket = (_nextTokenId() >> 8) + 1;
3480 
3481         for(uint256 i=startBucket; i < lastBucket; i++) {
3482             uint256 bucket = _burnedToken.getBucket(i);
3483             burned += _popcount(bucket);
3484         }
3485     }
3486 
3487     /**
3488      * @dev Returns number of set bits.
3489      */
3490     function _popcount(uint256 x) private pure returns (uint256 count) {
3491         unchecked{
3492             for (count=0; x!=0; count++)
3493                 x &= x - 1;
3494         }
3495     }
3496 }
3497 // File: contract-allow-list/contracts/ERC721AntiScam/restrictApprove/ERC721RestrictApprove.sol
3498 
3499 
3500 pragma solidity >=0.8.0;
3501 
3502 
3503 
3504 
3505 
3506 /// @title AntiScam機能付きERC721A
3507 /// @dev Readmeを見てください。
3508 
3509 abstract contract ERC721RestrictApprove is ERC721PsiBurnable, IERC721RestrictApprove {
3510     using EnumerableSet for EnumerableSet.AddressSet;
3511 
3512     IContractAllowListProxy public CAL;
3513     EnumerableSet.AddressSet localAllowedAddresses;
3514 
3515     modifier onlyHolder(uint256 tokenId) {
3516         require(
3517             msg.sender == ownerOf(tokenId),
3518             "RestrictApprove: operation is only holder."
3519         );
3520         _;
3521     }
3522 
3523     /*//////////////////////////////////////////////////////////////
3524     変数
3525     //////////////////////////////////////////////////////////////*/
3526     bool public enableRestrict = true;
3527 
3528     // token lock
3529     mapping(uint256 => uint256) public tokenCALLevel;
3530 
3531     // wallet lock
3532     mapping(address => uint256) public walletCALLevel;
3533 
3534     // contract lock
3535     uint256 public CALLevel = 1;
3536 
3537     /*///////////////////////////////////////////////////////////////
3538     Approve抑制機能ロジック
3539     //////////////////////////////////////////////////////////////*/
3540     function _addLocalContractAllowList(address transferer)
3541         internal
3542         virtual
3543     {
3544         localAllowedAddresses.add(transferer);
3545         emit LocalCalAdded(msg.sender, transferer);
3546     }
3547 
3548     function _removeLocalContractAllowList(address transferer)
3549         internal
3550         virtual
3551     {
3552         localAllowedAddresses.remove(transferer);
3553         emit LocalCalRemoved(msg.sender, transferer);
3554     }
3555 
3556     function _getLocalContractAllowList()
3557         internal
3558         virtual
3559         view
3560         returns(address[] memory)
3561     {
3562         return localAllowedAddresses.values();
3563     }
3564 
3565     function _isLocalAllowed(address transferer)
3566         internal
3567         view
3568         virtual
3569         returns (bool)
3570     {
3571         return localAllowedAddresses.contains(transferer);
3572     }
3573 
3574     function _isAllowed(address transferer)
3575         internal
3576         view
3577         virtual
3578         returns (bool)
3579     {
3580         return _isAllowed(msg.sender, transferer);
3581     }
3582 
3583     function _isAllowed(uint256 tokenId, address transferer)
3584         internal
3585         view
3586         virtual
3587         returns (bool)
3588     {
3589         uint256 level = _getCALLevel(msg.sender, tokenId);
3590         return _isAllowed(transferer, level);
3591     }
3592 
3593     function _isAllowed(address holder, address transferer)
3594         internal
3595         view
3596         virtual
3597         returns (bool)
3598     {
3599         uint256 level = _getCALLevel(holder);
3600         return _isAllowed(transferer, level);
3601     }
3602 
3603     function _isAllowed(address transferer, uint256 level)
3604         internal
3605         view
3606         virtual
3607         returns (bool)
3608     {
3609         if (!enableRestrict) {
3610             return true;
3611         }
3612 
3613         return _isLocalAllowed(transferer) || CAL.isAllowed(transferer, level);
3614     }
3615 
3616     function _getCALLevel(address holder, uint256 tokenId)
3617         internal
3618         view
3619         virtual
3620         returns (uint256)
3621     {
3622         if (tokenCALLevel[tokenId] > 0) {
3623             return tokenCALLevel[tokenId];
3624         }
3625 
3626         return _getCALLevel(holder);
3627     }
3628 
3629     function _getCALLevel(address holder)
3630         internal
3631         view
3632         virtual
3633         returns (uint256)
3634     {
3635         if (walletCALLevel[holder] > 0) {
3636             return walletCALLevel[holder];
3637         }
3638 
3639         return CALLevel;
3640     }
3641 
3642     function _setCAL(address _cal) internal virtual {
3643         CAL = IContractAllowListProxy(_cal);
3644     }
3645 
3646     function _deleteTokenCALLevel(uint256 tokenId) internal virtual {
3647         delete tokenCALLevel[tokenId];
3648     }
3649 
3650     function setTokenCALLevel(uint256 tokenId, uint256 level)
3651         external
3652         virtual
3653         onlyHolder(tokenId)
3654     {
3655         tokenCALLevel[tokenId] = level;
3656     }
3657 
3658     function setWalletCALLevel(uint256 level)
3659         external
3660         virtual
3661     {
3662         walletCALLevel[msg.sender] = level;
3663     }
3664 
3665     /*///////////////////////////////////////////////////////////////
3666                               OVERRIDES
3667     //////////////////////////////////////////////////////////////*/
3668 
3669     function isApprovedForAll(address owner, address operator)
3670         public
3671         view
3672         virtual
3673         override
3674         returns (bool)
3675     {
3676         if (_isAllowed(owner, operator) == false) {
3677             return false;
3678         }
3679         return super.isApprovedForAll(owner, operator);
3680     }
3681 
3682     function setApprovalForAll(address operator, bool approved)
3683         public
3684         virtual
3685         override
3686     {
3687         require(
3688             _isAllowed(operator) || approved == false,
3689             "RestrictApprove: Can not approve locked token"
3690         );
3691         super.setApprovalForAll(operator, approved);
3692     }
3693 
3694     function _beforeApprove(address to, uint256 tokenId)
3695         internal
3696         virtual
3697     {
3698         if (to != address(0)) {
3699             require(_isAllowed(tokenId, to), "RestrictApprove: The contract is not allowed.");
3700         }
3701     }
3702 
3703     function approve(address to, uint256 tokenId)
3704         public
3705         virtual
3706         override
3707     {
3708         _beforeApprove(to, tokenId);
3709         super.approve(to, tokenId);
3710     }
3711 
3712     function _afterTokenTransfers(
3713         address from,
3714         address, /*to*/
3715         uint256 startTokenId,
3716         uint256 /*quantity*/
3717     ) internal virtual override {
3718         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
3719         if (from != address(0)) {
3720             // CALレベルをデフォルトに戻す。
3721             _deleteTokenCALLevel(startTokenId);
3722         }
3723     }
3724 
3725     function supportsInterface(bytes4 interfaceId)
3726         public
3727         view
3728         virtual
3729         override
3730         returns (bool)
3731     {
3732         return
3733             interfaceId == type(IERC721RestrictApprove).interfaceId ||
3734             super.supportsInterface(interfaceId);
3735     }
3736 }
3737 
3738 // File: base64-sol/base64.sol
3739 
3740 
3741 
3742 pragma solidity >=0.6.0;
3743 
3744 /// @title Base64
3745 /// @author Brecht Devos - <brecht@loopring.org>
3746 /// @notice Provides functions for encoding/decoding base64
3747 library Base64 {
3748     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
3749     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
3750                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
3751                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
3752                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
3753 
3754     function encode(bytes memory data) internal pure returns (string memory) {
3755         if (data.length == 0) return '';
3756 
3757         // load the table into memory
3758         string memory table = TABLE_ENCODE;
3759 
3760         // multiply by 4/3 rounded up
3761         uint256 encodedLen = 4 * ((data.length + 2) / 3);
3762 
3763         // add some extra buffer at the end required for the writing
3764         string memory result = new string(encodedLen + 32);
3765 
3766         assembly {
3767             // set the actual output length
3768             mstore(result, encodedLen)
3769 
3770             // prepare the lookup table
3771             let tablePtr := add(table, 1)
3772 
3773             // input ptr
3774             let dataPtr := data
3775             let endPtr := add(dataPtr, mload(data))
3776 
3777             // result ptr, jump over length
3778             let resultPtr := add(result, 32)
3779 
3780             // run over the input, 3 bytes at a time
3781             for {} lt(dataPtr, endPtr) {}
3782             {
3783                 // read 3 bytes
3784                 dataPtr := add(dataPtr, 3)
3785                 let input := mload(dataPtr)
3786 
3787                 // write 4 characters
3788                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
3789                 resultPtr := add(resultPtr, 1)
3790                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
3791                 resultPtr := add(resultPtr, 1)
3792                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
3793                 resultPtr := add(resultPtr, 1)
3794                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
3795                 resultPtr := add(resultPtr, 1)
3796             }
3797 
3798             // padding with '='
3799             switch mod(mload(data), 3)
3800             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
3801             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
3802         }
3803 
3804         return result;
3805     }
3806 
3807     function decode(string memory _data) internal pure returns (bytes memory) {
3808         bytes memory data = bytes(_data);
3809 
3810         if (data.length == 0) return new bytes(0);
3811         require(data.length % 4 == 0, "invalid base64 decoder input");
3812 
3813         // load the table into memory
3814         bytes memory table = TABLE_DECODE;
3815 
3816         // every 4 characters represent 3 bytes
3817         uint256 decodedLen = (data.length / 4) * 3;
3818 
3819         // add some extra buffer at the end required for the writing
3820         bytes memory result = new bytes(decodedLen + 32);
3821 
3822         assembly {
3823             // padding with '='
3824             let lastBytes := mload(add(data, mload(data)))
3825             if eq(and(lastBytes, 0xFF), 0x3d) {
3826                 decodedLen := sub(decodedLen, 1)
3827                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
3828                     decodedLen := sub(decodedLen, 1)
3829                 }
3830             }
3831 
3832             // set the actual output length
3833             mstore(result, decodedLen)
3834 
3835             // prepare the lookup table
3836             let tablePtr := add(table, 1)
3837 
3838             // input ptr
3839             let dataPtr := data
3840             let endPtr := add(dataPtr, mload(data))
3841 
3842             // result ptr, jump over length
3843             let resultPtr := add(result, 32)
3844 
3845             // run over the input, 4 characters at a time
3846             for {} lt(dataPtr, endPtr) {}
3847             {
3848                // read 4 characters
3849                dataPtr := add(dataPtr, 4)
3850                let input := mload(dataPtr)
3851 
3852                // write 3 bytes
3853                let output := add(
3854                    add(
3855                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
3856                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
3857                    add(
3858                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
3859                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
3860                     )
3861                 )
3862                 mstore(resultPtr, shl(232, output))
3863                 resultPtr := add(resultPtr, 3)
3864             }
3865         }
3866 
3867         return result;
3868     }
3869 }
3870 
3871 // File: contracts/nft721_contract.sol
3872 
3873 
3874 // Copyright (c) 2023 Keisuke OHNO (kei31.eth)
3875 
3876 /*
3877 
3878 Permission is hereby granted, free of charge, to any person obtaining a copy
3879 of this software and associated documentation files (the "Software"), to deal
3880 in the Software without restriction, including without limitation the rights
3881 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
3882 copies of the Software, and to permit persons to whom the Software is
3883 furnished to do so, subject to the following conditions:
3884 
3885 The above copyright notice and this permission notice shall be included in all
3886 copies or substantial portions of the Software.
3887 
3888 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
3889 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
3890 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
3891 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
3892 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
3893 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
3894 SOFTWARE.
3895 
3896 */
3897 
3898 
3899 pragma solidity >=0.8.17;
3900 
3901 
3902 
3903 
3904 
3905 
3906 
3907 
3908 
3909 
3910 //tokenURI interface
3911 interface iTokenURI {
3912     function tokenURI(uint256 _tokenId) external view returns (string memory);
3913 }
3914 
3915 //SBT interface
3916 interface iSbtCollection {
3917     function externalMint(address _address , uint256 _amount ) external payable;
3918     function balanceOf(address _owner) external view returns (uint);
3919 }
3920 
3921 
3922 contract NFTContract721 is RevokableDefaultOperatorFilterer, ERC2981 ,Ownable, ERC721RestrictApprove ,AccessControl,ReentrancyGuard {
3923 
3924     constructor(
3925     ) ERC721Psi("Devils", "DVLS") {
3926         
3927         //Role initialization
3928         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
3929         grantRole(MINTER_ROLE       , msg.sender);
3930         grantRole(AIRDROP_ROLE      , msg.sender);
3931         grantRole(ADMIN             , msg.sender);
3932 
3933         setUseSingleMetadata(true);
3934         setMetadataTitle("Devils");
3935         setMetadataDescription("Devils");
3936         setMetadataAttributes("Devils");
3937         setImageURI("https://arweave.net/ZiLtBj2ZHjAK-piHxRqges3jPVkiMprhC903z4fr9KI");
3938 
3939         //CAL initialization
3940         setCALLevel(1);
3941 
3942         _setCAL(0xdbaa28cBe70aF04EbFB166b1A3E8F8034e5B9FC7);//Ethereum mainnet proxy
3943         //_setCAL(0xb506d7BbE23576b8AAf22477cd9A7FDF08002211);//Goerli testnet proxy
3944 
3945         _addLocalContractAllowList(0x1E0049783F008A0085193E00003D00cd54003c71);//OpenSea
3946         _addLocalContractAllowList(0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be);//Rarible
3947 
3948         //initial mint
3949         //_safeMint(msg.sender, 1);        
3950 
3951         //Royalty
3952         setDefaultRoyalty(0x02F8E85E7A5b1EF6B2FDf82d75ACf26fC6CC4717 , 1000);
3953         setWithdrawAddress(0xddAa0455f45B9f78484bEDfBD200D71810E44ad9);
3954 
3955         setMerkleRoot(0x9d4ccb286a19aa4164b32e9faf71e17599789bdaa64c4845512d3b6d45e1d37d);
3956 
3957     }
3958 
3959     //
3960     //withdraw section
3961     //
3962 
3963     address public withdrawAddress = 0xdEcf4B112d4120B6998e5020a6B4819E490F7db6;
3964 
3965     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
3966         withdrawAddress = _withdrawAddress;
3967     }
3968 
3969     function withdraw() public payable onlyOwner {
3970         (bool os, ) = payable(withdrawAddress).call{value: address(this).balance}('');
3971         require(os);
3972     }
3973 
3974 
3975     //
3976     //mint section
3977     //
3978 
3979     uint256 public cost = 1000000000000000;
3980     uint256 public maxSupply = 8888 -1;
3981     uint256 public maxMintAmountPerTransaction = 200;
3982     uint256 public publicSaleMaxMintAmountPerAddress = 5;
3983     bool public paused = true;
3984 
3985     bool public onlyAllowlisted = true;
3986     bool public mintCount = true;
3987     bool public burnAndMintMode = false;
3988 
3989     //0 : Merkle Tree
3990     //1 : Mapping
3991     uint256 public allowlistType = 0;
3992     bytes32 public merkleRoot;
3993     uint256 public saleId = 0;
3994     mapping(uint256 => mapping(address => uint256)) public userMintedAmount;
3995     mapping(uint256 => mapping(address => uint256)) public allowlistUserAmount;
3996 
3997     bool public mintWithSBT = false;
3998     iSbtCollection public sbtCollection;
3999 
4000 
4001     modifier callerIsUser() {
4002         require(tx.origin == msg.sender, "The caller is another contract.");
4003         _;
4004     }
4005  
4006     //mint with merkle tree
4007     function mint(uint256 _mintAmount , uint256 _maxMintAmount , bytes32[] calldata _merkleProof , uint256 _burnId ) public payable callerIsUser{
4008         require(!paused, "the contract is paused");
4009         require(0 < _mintAmount, "need to mint at least 1 NFT");
4010         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
4011         require( _nextTokenId() + _mintAmount -1 <= maxSupply , "max NFT limit exceeded");
4012         require(cost * _mintAmount <= msg.value, "insufficient funds");
4013 
4014         uint256 maxMintAmountPerAddress;
4015         if(onlyAllowlisted == true) {
4016             if(allowlistType == 0){
4017                 //Merkle tree
4018                 bytes32 leaf = keccak256( abi.encodePacked(msg.sender, _maxMintAmount) );
4019                 require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "user is not allowlisted");
4020                 maxMintAmountPerAddress = _maxMintAmount;
4021             }else if(allowlistType == 1){
4022                 //Mapping
4023                 require( allowlistUserAmount[saleId][msg.sender] != 0 , "user is not allowlisted");
4024                 maxMintAmountPerAddress = allowlistUserAmount[saleId][msg.sender];
4025             }
4026         }else{
4027             maxMintAmountPerAddress = publicSaleMaxMintAmountPerAddress;
4028         }
4029 
4030         if(mintCount == true){
4031             require(_mintAmount <= maxMintAmountPerAddress - userMintedAmount[saleId][msg.sender] , "max NFT per address exceeded");
4032             userMintedAmount[saleId][msg.sender] += _mintAmount;
4033         }
4034 
4035         if(burnAndMintMode == true ){
4036             require(_mintAmount == 1, "The number of mints is over.");
4037             require(msg.sender == ownerOf(_burnId) , "Owner is different");
4038             _burn(_burnId);
4039         }
4040 
4041         if( mintWithSBT == true ){
4042             if( sbtCollection.balanceOf(msg.sender) == 0 ){
4043                 sbtCollection.externalMint(msg.sender,1);
4044             }
4045         }
4046 
4047         _safeMint(msg.sender, _mintAmount);
4048     }
4049 
4050     bytes32 public constant AIRDROP_ROLE = keccak256("AIRDROP_ROLE");
4051     function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public {
4052         require(hasRole(AIRDROP_ROLE, msg.sender), "Caller is not a air dropper");
4053         require(_airdropAddresses.length == _UserMintAmount.length , "Array lengths are different");
4054         uint256 _mintAmount = 0;
4055         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
4056             _mintAmount += _UserMintAmount[i];
4057         }
4058         require(0 < _mintAmount , "need to mint at least 1 NFT");
4059         require( _nextTokenId() + _mintAmount -1 <= maxSupply , "max NFT limit exceeded");        
4060         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
4061             _safeMint(_airdropAddresses[i], _UserMintAmount[i] );
4062         }
4063     }
4064 
4065     function currentTokenId() public view returns(uint256){
4066         return _nextTokenId() -1;
4067     }
4068 
4069     function setMintWithSBT(bool _mintWithSBT) public onlyRole(ADMIN) {
4070         mintWithSBT = _mintWithSBT;
4071     }
4072 
4073     function setSbtCollection(address _address) public onlyRole(ADMIN) {
4074         sbtCollection = iSbtCollection(_address);
4075     }
4076 
4077     function setBurnAndMintMode(bool _burnAndMintMode) public onlyRole(ADMIN) {
4078         burnAndMintMode = _burnAndMintMode;
4079     }
4080 
4081     function setMerkleRoot(bytes32 _merkleRoot) public onlyRole(ADMIN) {
4082         merkleRoot = _merkleRoot;
4083     }
4084 
4085     function setPause(bool _state) public onlyRole(ADMIN) {
4086         paused = _state;
4087     }
4088 
4089     function setAllowListType(uint256 _type)public onlyRole(ADMIN){
4090         require( _type == 0 || _type == 1 , "Allow list type error");
4091         allowlistType = _type;
4092     }
4093 
4094     function setAllowlistMapping(uint256 _saleId , address[] memory addresses, uint256[] memory saleSupplies) public onlyRole(ADMIN) {
4095         require(addresses.length == saleSupplies.length);
4096         for (uint256 i = 0; i < addresses.length; i++) {
4097             allowlistUserAmount[_saleId][addresses[i]] = saleSupplies[i];
4098         }
4099     }
4100 
4101     function getAllowlistUserAmount(address _address ) public view returns(uint256){
4102         return allowlistUserAmount[saleId][_address];
4103     }
4104 
4105     function getUserMintedAmountBySaleId(uint256 _saleId , address _address ) public view returns(uint256){
4106         return userMintedAmount[_saleId][_address];
4107     }
4108 
4109     function getUserMintedAmount(address _address ) public view returns(uint256){
4110         return userMintedAmount[saleId][_address];
4111     }
4112 
4113     function setSaleId(uint256 _saleId) public onlyRole(ADMIN) {
4114         saleId = _saleId;
4115     }
4116 
4117     function setMaxSupply(uint256 _maxSupply) public onlyRole(ADMIN) {
4118         maxSupply = _maxSupply;
4119     }
4120 
4121     function setPublicSaleMaxMintAmountPerAddress(uint256 _publicSaleMaxMintAmountPerAddress) public onlyRole(ADMIN) {
4122         publicSaleMaxMintAmountPerAddress = _publicSaleMaxMintAmountPerAddress;
4123     }
4124 
4125     function setCost(uint256 _newCost) public onlyRole(ADMIN) {
4126         cost = _newCost;
4127     }
4128 
4129     function setOnlyAllowlisted(bool _state) public onlyRole(ADMIN) {
4130         onlyAllowlisted = _state;
4131     }
4132 
4133     function setMaxMintAmountPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyRole(ADMIN) {
4134         maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
4135     }
4136   
4137     function setMintCount(bool _state) public onlyRole(ADMIN) {
4138         mintCount = _state;
4139     }
4140  
4141 
4142 
4143     //
4144     //URI section
4145     //
4146 
4147     string public baseURI;
4148     string public baseExtension = ".json";
4149 
4150     function _baseURI() internal view virtual override returns (string memory) {
4151         return baseURI;        
4152     }
4153 
4154     function setBaseURI(string memory _newBaseURI) public onlyRole(ADMIN) {
4155         baseURI = _newBaseURI;
4156     }
4157 
4158     function setBaseExtension(string memory _newBaseExtension) public onlyRole(ADMIN) {
4159         baseExtension = _newBaseExtension;
4160     }
4161 
4162 
4163 
4164     //
4165     //interface metadata
4166     //
4167 
4168     iTokenURI public interfaceOfTokenURI;
4169     bool public useInterfaceMetadata = false;
4170 
4171     function setInterfaceOfTokenURI(address _address) public onlyRole(ADMIN) {
4172         interfaceOfTokenURI = iTokenURI(_address);
4173     }
4174 
4175     function setUseInterfaceMetadata(bool _useInterfaceMetadata) public onlyRole(ADMIN) {
4176         useInterfaceMetadata = _useInterfaceMetadata;
4177     }
4178 
4179 
4180 
4181     //
4182     //single metadata
4183     //
4184 
4185     bool public useSingleMetadata = false;
4186     string public imageURI;
4187     string public metadataTitle;
4188     string public metadataDescription;
4189     string public metadataAttributes;
4190     bool public useAnimationUrl = false;
4191     string public animationURI;
4192 
4193     //single image metadata
4194     function setUseSingleMetadata(bool _useSingleMetadata) public onlyRole(ADMIN) {
4195         useSingleMetadata = _useSingleMetadata;
4196     }
4197     function setMetadataTitle(string memory _metadataTitle) public onlyRole(ADMIN) {
4198         metadataTitle = _metadataTitle;
4199     }
4200     function setMetadataDescription(string memory _metadataDescription) public onlyRole(ADMIN) {
4201         metadataDescription = _metadataDescription;
4202     }
4203     function setMetadataAttributes(string memory _metadataAttributes) public onlyRole(ADMIN) {
4204         metadataAttributes = _metadataAttributes;
4205     }
4206     function setImageURI(string memory _ImageURI) public onlyRole(ADMIN) {
4207         imageURI = _ImageURI;
4208     }
4209     function setUseAnimationUrl(bool _useAnimationUrl) public onlyRole(ADMIN) {
4210         useAnimationUrl = _useAnimationUrl;
4211     }
4212     function setAnimationURI(string memory _animationURI) public onlyRole(ADMIN) {
4213         animationURI = _animationURI;
4214     }
4215 
4216 
4217 
4218     //
4219     //token URI
4220     //
4221 
4222     function tokenURI(uint256 tokenId) public view override returns (string memory) {
4223         if (useInterfaceMetadata == true) {
4224             return interfaceOfTokenURI.tokenURI(tokenId);
4225         }
4226         if(useSingleMetadata == true){
4227             return string( abi.encodePacked( 'data:application/json;base64,' , Base64.encode(
4228                 abi.encodePacked(
4229                     '{',
4230                         '"name":"' , metadataTitle ,'",' ,
4231                         '"description":"' , metadataDescription ,  '",' ,
4232                         '"image": "' , imageURI , '",' ,
4233                         useAnimationUrl==true ? string(abi.encodePacked('"animation_url": "' , animationURI , '",')) :"" ,
4234                         '"attributes":[{"trait_type":"type","value":"' , metadataAttributes , '"}]',
4235                     '}'
4236                 )
4237             ) ) );
4238         }
4239         return string(abi.encodePacked(ERC721Psi.tokenURI(tokenId), baseExtension));
4240     }
4241 
4242 
4243 
4244 
4245     //
4246     //burnin' section
4247     //
4248 
4249     bytes32 public constant MINTER_ROLE  = keccak256("MINTER_ROLE");
4250     bytes32 public constant BURNER_ROLE  = keccak256("BURNER_ROLE");
4251 
4252     function externalMint(address _address , uint256 _amount ) external payable {
4253         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
4254         require( _nextTokenId() + _amount -1 <= maxSupply , "max NFT limit exceeded");
4255         _safeMint( _address, _amount );
4256     }
4257 
4258     function externalBurn(uint256[] memory _burnTokenIds) external nonReentrant{
4259         require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
4260         for (uint256 i = 0; i < _burnTokenIds.length; i++) {
4261             uint256 tokenId = _burnTokenIds[i];
4262             require(tx.origin == ownerOf(tokenId) , "Owner is different");
4263             _burn(tokenId);
4264         }        
4265     }
4266 
4267 
4268 
4269     //
4270     //sbt and opensea filter section
4271     //
4272 
4273     bool public isSBT = false;
4274 
4275     function setIsSBT(bool _state) public onlyRole(ADMIN) {
4276         isSBT = _state;
4277     }
4278 
4279     function _beforeTokenTransfers( address from, address to, uint256 startTokenId, uint256 quantity) internal virtual override{
4280         require( isSBT == false || from == address(0) || to == address(0)|| to == address(0x000000000000000000000000000000000000dEaD), "transfer is prohibited");
4281         super._beforeTokenTransfers(from, to, startTokenId, quantity);
4282     }
4283 
4284     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperatorApproval(operator){
4285         require( isSBT == false || approved == false , "setApprovalForAll is prohibited");
4286         super.setApprovalForAll(operator, approved);
4287     }
4288 
4289     function approve(address operator, uint256 tokenId) public virtual override onlyAllowedOperatorApproval(operator){
4290         require( isSBT == false , "approve is prohibited");
4291         super.approve(operator, tokenId);
4292     }
4293 
4294     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
4295         super.transferFrom(from, to, tokenId);
4296     }
4297 
4298     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
4299         super.safeTransferFrom(from, to, tokenId);
4300     }
4301 
4302     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
4303         super.safeTransferFrom(from, to, tokenId, data);
4304     }
4305 
4306     function owner() public view virtual override (Ownable, UpdatableOperatorFilterer) returns (address) {
4307         return Ownable.owner();
4308     }
4309 
4310 
4311 
4312 
4313     //
4314     //ERC721PsiAddressData section
4315     //
4316 
4317     // Mapping owner address to address data
4318     mapping(address => AddressData) _addressData;
4319 
4320     // Compiler will pack this into a single 256bit word.
4321     struct AddressData {
4322         // Realistically, 2**64-1 is more than enough.
4323         uint64 balance;
4324         // Keeps track of mint count with minimal overhead for tokenomics.
4325         uint64 numberMinted;
4326         // Keeps track of burn count with minimal overhead for tokenomics.
4327         uint64 numberBurned;
4328         // For miscellaneous variable(s) pertaining to the address
4329         // (e.g. number of whitelist mint slots used).
4330         // If there are multiple variables, please pack them into a uint64.
4331         uint64 aux;
4332     }
4333 
4334 
4335     /**
4336      * @dev See {IERC721-balanceOf}.
4337      */
4338     function balanceOf(address _owner) 
4339         public 
4340         view 
4341         virtual 
4342         override 
4343         returns (uint) 
4344     {
4345         require(_owner != address(0), "ERC721Psi: balance query for the zero address");
4346         return uint256(_addressData[_owner].balance);   
4347     }
4348 
4349     /**
4350      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
4351      * minting.
4352      *
4353      * startTokenId - the first token id to be transferred
4354      * quantity - the amount to be transferred
4355      *
4356      * Calling conditions:
4357      *
4358      * - when `from` and `to` are both non-zero.
4359      * - `from` and `to` are never both zero.
4360      */
4361     function _afterTokenTransfers(
4362         address from,
4363         address to,
4364         uint256 startTokenId,
4365         uint256 quantity
4366     ) internal override virtual {
4367         require(quantity < 2 ** 64);
4368         uint64 _quantity = uint64(quantity);
4369 
4370         if(from != address(0)){
4371             _addressData[from].balance -= _quantity;
4372         } else {
4373             // Mint
4374             _addressData[to].numberMinted += _quantity;
4375         }
4376 
4377         if(to != address(0)){
4378             _addressData[to].balance += _quantity;
4379         } else {
4380             // Burn
4381             _addressData[from].numberBurned += _quantity;
4382         }
4383         super._afterTokenTransfers(from, to, startTokenId, quantity);
4384     }
4385 
4386 
4387 
4388 
4389     //
4390     //ERC721AntiScam section
4391     //
4392 
4393     bytes32 public constant ADMIN = keccak256("ADMIN");
4394 
4395     function setEnebleRestrict(bool _enableRestrict )public onlyRole(ADMIN){
4396         enableRestrict = _enableRestrict;
4397     }
4398 
4399     /*///////////////////////////////////////////////////////////////
4400                     OVERRIDES ERC721RestrictApprove
4401     //////////////////////////////////////////////////////////////*/
4402     function addLocalContractAllowList(address transferer)
4403         external
4404         override
4405         onlyRole(ADMIN)
4406     {
4407         _addLocalContractAllowList(transferer);
4408     }
4409 
4410     function removeLocalContractAllowList(address transferer)
4411         external
4412         override
4413         onlyRole(ADMIN)
4414     {
4415         _removeLocalContractAllowList(transferer);
4416     }
4417 
4418     function getLocalContractAllowList()
4419         external
4420         override
4421         view
4422         returns(address[] memory)
4423     {
4424         return _getLocalContractAllowList();
4425     }
4426 
4427     function setCALLevel(uint256 level) public override onlyRole(ADMIN) {
4428         CALLevel = level;
4429     }
4430 
4431     function setCAL(address calAddress) external override onlyRole(ADMIN) {
4432         _setCAL(calAddress);
4433     }
4434 
4435 
4436 
4437 
4438     //
4439     //setDefaultRoyalty
4440     //
4441     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner{
4442         _setDefaultRoyalty(_receiver, _feeNumerator);
4443     }
4444 
4445 
4446 
4447     /*///////////////////////////////////////////////////////////////
4448                     OVERRIDES ERC721RestrictApprove
4449     //////////////////////////////////////////////////////////////*/
4450     function supportsInterface(bytes4 interfaceId)
4451         public
4452         view
4453         override(ERC2981,ERC721RestrictApprove, AccessControl)
4454         returns (bool)
4455     {
4456         return
4457             ERC2981.supportsInterface(interfaceId) ||
4458             AccessControl.supportsInterface(interfaceId) ||
4459             ERC721RestrictApprove.supportsInterface(interfaceId);
4460     }
4461 
4462 
4463     
4464 
4465 }