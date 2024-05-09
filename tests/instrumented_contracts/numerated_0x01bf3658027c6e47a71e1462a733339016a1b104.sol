1 // File: contracts/INemsPrice.sol
2 
3 
4 
5 pragma solidity ^0.8.17;
6 
7 interface INemsPrice {
8     function NemsUSDPrice() external view returns (uint256);
9 }
10 // File: contracts/lib/Constants.sol
11 
12 
13 pragma solidity ^0.8.13;
14 
15 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
16 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
17 // File: contracts/IOperatorFilterRegistry.sol
18 
19 
20 pragma solidity ^0.8.13;
21 
22 interface IOperatorFilterRegistry {
23     /**
24      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
25      *         true if supplied registrant address is not registered.
26      */
27     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
28 
29     /**
30      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
31      */
32     function register(address registrant) external;
33 
34     /**
35      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
36      */
37     function registerAndSubscribe(address registrant, address subscription) external;
38 
39     /**
40      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
41      *         address without subscribing.
42      */
43     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
44 
45     /**
46      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
47      *         Note that this does not remove any filtered addresses or codeHashes.
48      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
49      */
50     function unregister(address addr) external;
51 
52     /**
53      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
54      */
55     function updateOperator(address registrant, address operator, bool filtered) external;
56 
57     /**
58      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
59      */
60     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
61 
62     /**
63      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
64      */
65     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
66 
67     /**
68      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
69      */
70     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
71 
72     /**
73      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
74      *         subscription if present.
75      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
76      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
77      *         used.
78      */
79     function subscribe(address registrant, address registrantToSubscribe) external;
80 
81     /**
82      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
83      */
84     function unsubscribe(address registrant, bool copyExistingEntries) external;
85 
86     /**
87      * @notice Get the subscription address of a given registrant, if any.
88      */
89     function subscriptionOf(address addr) external returns (address registrant);
90 
91     /**
92      * @notice Get the set of addresses subscribed to a given registrant.
93      *         Note that order is not guaranteed as updates are made.
94      */
95     function subscribers(address registrant) external returns (address[] memory);
96 
97     /**
98      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
99      *         Note that order is not guaranteed as updates are made.
100      */
101     function subscriberAt(address registrant, uint256 index) external returns (address);
102 
103     /**
104      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
105      */
106     function copyEntriesOf(address registrant, address registrantToCopy) external;
107 
108     /**
109      * @notice Returns true if operator is filtered by a given address or its subscription.
110      */
111     function isOperatorFiltered(address registrant, address operator) external returns (bool);
112 
113     /**
114      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
115      */
116     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
117 
118     /**
119      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
120      */
121     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
122 
123     /**
124      * @notice Returns a list of filtered operators for a given address or its subscription.
125      */
126     function filteredOperators(address addr) external returns (address[] memory);
127 
128     /**
129      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
130      *         Note that order is not guaranteed as updates are made.
131      */
132     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
133 
134     /**
135      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
136      *         its subscription.
137      *         Note that order is not guaranteed as updates are made.
138      */
139     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
140 
141     /**
142      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
143      *         its subscription.
144      *         Note that order is not guaranteed as updates are made.
145      */
146     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
147 
148     /**
149      * @notice Returns true if an address has registered
150      */
151     function isRegistered(address addr) external returns (bool);
152 
153     /**
154      * @dev Convenience method to compute the code hash of an arbitrary contract
155      */
156     function codeHashOf(address addr) external returns (bytes32);
157 }
158 // File: contracts/OperatorFilterer.sol
159 
160 
161 pragma solidity ^0.8.13;
162 
163 
164 /**
165  * @title  OperatorFilterer
166  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
167  *         registrant's entries in the OperatorFilterRegistry.
168  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
169  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
170  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
171  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
172  *         administration methods on the contract itself to interact with the registry otherwise the subscription
173  *         will be locked to the options set during construction.
174  */
175 
176 abstract contract OperatorFilterer {
177     /// @dev Emitted when an operator is not allowed.
178     error OperatorNotAllowed(address operator);
179 
180     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
181         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
182 
183     /// @dev The constructor that is called when the contract is being deployed.
184     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
185         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
186         // will not revert, but the contract will need to be registered with the registry once it is deployed in
187         // order for the modifier to filter addresses.
188         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
189             if (subscribe) {
190                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
191             } else {
192                 if (subscriptionOrRegistrantToCopy != address(0)) {
193                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
194                 } else {
195                     OPERATOR_FILTER_REGISTRY.register(address(this));
196                 }
197             }
198         }
199     }
200 
201     /**
202      * @dev A helper function to check if an operator is allowed.
203      */
204     modifier onlyAllowedOperator(address from) virtual {
205         // Allow spending tokens from addresses with balance
206         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
207         // from an EOA.
208         if (from != msg.sender) {
209             _checkFilterOperator(msg.sender);
210         }
211         _;
212     }
213 
214     /**
215      * @dev A helper function to check if an operator approval is allowed.
216      */
217     modifier onlyAllowedOperatorApproval(address operator) virtual {
218         _checkFilterOperator(operator);
219         _;
220     }
221 
222     /**
223      * @dev A helper function to check if an operator is allowed.
224      */
225     function _checkFilterOperator(address operator) internal view virtual {
226         // Check registry code length to facilitate testing in environments without a deployed registry.
227         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
228             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
229             // may specify their own OperatorFilterRegistry implementations, which may behave differently
230             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
231                 revert OperatorNotAllowed(operator);
232             }
233         }
234     }
235 }
236 // File: contracts/DefaultOperatorFilterer.sol
237 
238 
239 pragma solidity ^0.8.13;
240 
241 
242 /**
243  * @title  DefaultOperatorFilterer
244  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
245  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
246  *         administration methods on the contract itself to interact with the registry otherwise the subscription
247  *         will be locked to the options set during construction.
248  */
249 
250 abstract contract DefaultOperatorFilterer is OperatorFilterer {
251     /// @dev The constructor that is called when the contract is being deployed.
252     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
253 }
254 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev Interface of the ERC20 standard as defined in the EIP.
263  */
264 interface IERC20 {
265     /**
266      * @dev Emitted when `value` tokens are moved from one account (`from`) to
267      * another (`to`).
268      *
269      * Note that `value` may be zero.
270      */
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 
273     /**
274      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
275      * a call to {approve}. `value` is the new allowance.
276      */
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 
279     /**
280      * @dev Returns the amount of tokens in existence.
281      */
282     function totalSupply() external view returns (uint256);
283 
284     /**
285      * @dev Returns the amount of tokens owned by `account`.
286      */
287     function balanceOf(address account) external view returns (uint256);
288 
289     /**
290      * @dev Moves `amount` tokens from the caller's account to `to`.
291      *
292      * Returns a boolean value indicating whether the operation succeeded.
293      *
294      * Emits a {Transfer} event.
295      */
296     function transfer(address to, uint256 amount) external returns (bool);
297 
298     /**
299      * @dev Returns the remaining number of tokens that `spender` will be
300      * allowed to spend on behalf of `owner` through {transferFrom}. This is
301      * zero by default.
302      *
303      * This value changes when {approve} or {transferFrom} are called.
304      */
305     function allowance(address owner, address spender) external view returns (uint256);
306 
307     /**
308      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
309      *
310      * Returns a boolean value indicating whether the operation succeeded.
311      *
312      * IMPORTANT: Beware that changing an allowance with this method brings the risk
313      * that someone may use both the old and the new allowance by unfortunate
314      * transaction ordering. One possible solution to mitigate this race
315      * condition is to first reduce the spender's allowance to 0 and set the
316      * desired value afterwards:
317      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
318      *
319      * Emits an {Approval} event.
320      */
321     function approve(address spender, uint256 amount) external returns (bool);
322 
323     /**
324      * @dev Moves `amount` tokens from `from` to `to` using the
325      * allowance mechanism. `amount` is then deducted from the caller's
326      * allowance.
327      *
328      * Returns a boolean value indicating whether the operation succeeded.
329      *
330      * Emits a {Transfer} event.
331      */
332     function transferFrom(
333         address from,
334         address to,
335         uint256 amount
336     ) external returns (bool);
337 }
338 
339 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev These functions deal with verification of Merkle Tree proofs.
348  *
349  * The tree and the proofs can be generated using our
350  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
351  * You will find a quickstart guide in the readme.
352  *
353  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
354  * hashing, or use a hash function other than keccak256 for hashing leaves.
355  * This is because the concatenation of a sorted pair of internal nodes in
356  * the merkle tree could be reinterpreted as a leaf value.
357  * OpenZeppelin's JavaScript library generates merkle trees that are safe
358  * against this attack out of the box.
359  */
360 library MerkleProof {
361     /**
362      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
363      * defined by `root`. For this, a `proof` must be provided, containing
364      * sibling hashes on the branch from the leaf to the root of the tree. Each
365      * pair of leaves and each pair of pre-images are assumed to be sorted.
366      */
367     function verify(
368         bytes32[] memory proof,
369         bytes32 root,
370         bytes32 leaf
371     ) internal pure returns (bool) {
372         return processProof(proof, leaf) == root;
373     }
374 
375     /**
376      * @dev Calldata version of {verify}
377      *
378      * _Available since v4.7._
379      */
380     function verifyCalldata(
381         bytes32[] calldata proof,
382         bytes32 root,
383         bytes32 leaf
384     ) internal pure returns (bool) {
385         return processProofCalldata(proof, leaf) == root;
386     }
387 
388     /**
389      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
390      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
391      * hash matches the root of the tree. When processing the proof, the pairs
392      * of leafs & pre-images are assumed to be sorted.
393      *
394      * _Available since v4.4._
395      */
396     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
397         bytes32 computedHash = leaf;
398         for (uint256 i = 0; i < proof.length; i++) {
399             computedHash = _hashPair(computedHash, proof[i]);
400         }
401         return computedHash;
402     }
403 
404     /**
405      * @dev Calldata version of {processProof}
406      *
407      * _Available since v4.7._
408      */
409     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
410         bytes32 computedHash = leaf;
411         for (uint256 i = 0; i < proof.length; i++) {
412             computedHash = _hashPair(computedHash, proof[i]);
413         }
414         return computedHash;
415     }
416 
417     /**
418      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
419      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
420      *
421      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
422      *
423      * _Available since v4.7._
424      */
425     function multiProofVerify(
426         bytes32[] memory proof,
427         bool[] memory proofFlags,
428         bytes32 root,
429         bytes32[] memory leaves
430     ) internal pure returns (bool) {
431         return processMultiProof(proof, proofFlags, leaves) == root;
432     }
433 
434     /**
435      * @dev Calldata version of {multiProofVerify}
436      *
437      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
438      *
439      * _Available since v4.7._
440      */
441     function multiProofVerifyCalldata(
442         bytes32[] calldata proof,
443         bool[] calldata proofFlags,
444         bytes32 root,
445         bytes32[] memory leaves
446     ) internal pure returns (bool) {
447         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
448     }
449 
450     /**
451      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
452      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
453      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
454      * respectively.
455      *
456      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
457      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
458      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
459      *
460      * _Available since v4.7._
461      */
462     function processMultiProof(
463         bytes32[] memory proof,
464         bool[] memory proofFlags,
465         bytes32[] memory leaves
466     ) internal pure returns (bytes32 merkleRoot) {
467         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
468         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
469         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
470         // the merkle tree.
471         uint256 leavesLen = leaves.length;
472         uint256 totalHashes = proofFlags.length;
473 
474         // Check proof validity.
475         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
476 
477         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
478         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
479         bytes32[] memory hashes = new bytes32[](totalHashes);
480         uint256 leafPos = 0;
481         uint256 hashPos = 0;
482         uint256 proofPos = 0;
483         // At each step, we compute the next hash using two values:
484         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
485         //   get the next hash.
486         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
487         //   `proof` array.
488         for (uint256 i = 0; i < totalHashes; i++) {
489             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
490             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
491             hashes[i] = _hashPair(a, b);
492         }
493 
494         if (totalHashes > 0) {
495             return hashes[totalHashes - 1];
496         } else if (leavesLen > 0) {
497             return leaves[0];
498         } else {
499             return proof[0];
500         }
501     }
502 
503     /**
504      * @dev Calldata version of {processMultiProof}.
505      *
506      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
507      *
508      * _Available since v4.7._
509      */
510     function processMultiProofCalldata(
511         bytes32[] calldata proof,
512         bool[] calldata proofFlags,
513         bytes32[] memory leaves
514     ) internal pure returns (bytes32 merkleRoot) {
515         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
516         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
517         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
518         // the merkle tree.
519         uint256 leavesLen = leaves.length;
520         uint256 totalHashes = proofFlags.length;
521 
522         // Check proof validity.
523         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
524 
525         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
526         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
527         bytes32[] memory hashes = new bytes32[](totalHashes);
528         uint256 leafPos = 0;
529         uint256 hashPos = 0;
530         uint256 proofPos = 0;
531         // At each step, we compute the next hash using two values:
532         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
533         //   get the next hash.
534         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
535         //   `proof` array.
536         for (uint256 i = 0; i < totalHashes; i++) {
537             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
538             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
539             hashes[i] = _hashPair(a, b);
540         }
541 
542         if (totalHashes > 0) {
543             return hashes[totalHashes - 1];
544         } else if (leavesLen > 0) {
545             return leaves[0];
546         } else {
547             return proof[0];
548         }
549     }
550 
551     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
552         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
553     }
554 
555     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
556         /// @solidity memory-safe-assembly
557         assembly {
558             mstore(0x00, a)
559             mstore(0x20, b)
560             value := keccak256(0x00, 0x40)
561         }
562     }
563 }
564 
565 // File: @openzeppelin/contracts/utils/Context.sol
566 
567 
568 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @dev Provides information about the current execution context, including the
574  * sender of the transaction and its data. While these are generally available
575  * via msg.sender and msg.data, they should not be accessed in such a direct
576  * manner, since when dealing with meta-transactions the account sending and
577  * paying for execution may not be the actual sender (as far as an application
578  * is concerned).
579  *
580  * This contract is only required for intermediate, library-like contracts.
581  */
582 abstract contract Context {
583     function _msgSender() internal view virtual returns (address) {
584         return msg.sender;
585     }
586 
587     function _msgData() internal view virtual returns (bytes calldata) {
588         return msg.data;
589     }
590 }
591 
592 // File: @openzeppelin/contracts/security/Pausable.sol
593 
594 
595 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 
600 /**
601  * @dev Contract module which allows children to implement an emergency stop
602  * mechanism that can be triggered by an authorized account.
603  *
604  * This module is used through inheritance. It will make available the
605  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
606  * the functions of your contract. Note that they will not be pausable by
607  * simply including this module, only once the modifiers are put in place.
608  */
609 abstract contract Pausable is Context {
610     /**
611      * @dev Emitted when the pause is triggered by `account`.
612      */
613     event Paused(address account);
614 
615     /**
616      * @dev Emitted when the pause is lifted by `account`.
617      */
618     event Unpaused(address account);
619 
620     bool private _paused;
621 
622     /**
623      * @dev Initializes the contract in unpaused state.
624      */
625     constructor() {
626         _paused = false;
627     }
628 
629     /**
630      * @dev Modifier to make a function callable only when the contract is not paused.
631      *
632      * Requirements:
633      *
634      * - The contract must not be paused.
635      */
636     modifier whenNotPaused() {
637         _requireNotPaused();
638         _;
639     }
640 
641     /**
642      * @dev Modifier to make a function callable only when the contract is paused.
643      *
644      * Requirements:
645      *
646      * - The contract must be paused.
647      */
648     modifier whenPaused() {
649         _requirePaused();
650         _;
651     }
652 
653     /**
654      * @dev Returns true if the contract is paused, and false otherwise.
655      */
656     function paused() public view virtual returns (bool) {
657         return _paused;
658     }
659 
660     /**
661      * @dev Throws if the contract is paused.
662      */
663     function _requireNotPaused() internal view virtual {
664         require(!paused(), "Pausable: paused");
665     }
666 
667     /**
668      * @dev Throws if the contract is not paused.
669      */
670     function _requirePaused() internal view virtual {
671         require(paused(), "Pausable: not paused");
672     }
673 
674     /**
675      * @dev Triggers stopped state.
676      *
677      * Requirements:
678      *
679      * - The contract must not be paused.
680      */
681     function _pause() internal virtual whenNotPaused {
682         _paused = true;
683         emit Paused(_msgSender());
684     }
685 
686     /**
687      * @dev Returns to normal state.
688      *
689      * Requirements:
690      *
691      * - The contract must be paused.
692      */
693     function _unpause() internal virtual whenPaused {
694         _paused = false;
695         emit Unpaused(_msgSender());
696     }
697 }
698 
699 // File: @openzeppelin/contracts/access/Ownable.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Contract module which provides a basic access control mechanism, where
709  * there is an account (an owner) that can be granted exclusive access to
710  * specific functions.
711  *
712  * By default, the owner account will be the one that deploys the contract. This
713  * can later be changed with {transferOwnership}.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * `onlyOwner`, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 abstract contract Ownable is Context {
720     address private _owner;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor() {
728         _transferOwnership(_msgSender());
729     }
730 
731     /**
732      * @dev Returns the address of the current owner.
733      */
734     function owner() public view virtual returns (address) {
735         return _owner;
736     }
737 
738     /**
739      * @dev Throws if called by any account other than the owner.
740      */
741     modifier onlyOwner() {
742         require(owner() == _msgSender(), "Ownable: caller is not the owner");
743         _;
744     }
745 
746     /**
747      * @dev Leaves the contract without owner. It will not be possible to call
748      * `onlyOwner` functions anymore. Can only be called by the current owner.
749      *
750      * NOTE: Renouncing ownership will leave the contract without an owner,
751      * thereby removing any functionality that is only available to the owner.
752      */
753     function renounceOwnership() public virtual onlyOwner {
754         _transferOwnership(address(0));
755     }
756 
757     /**
758      * @dev Transfers ownership of the contract to a new account (`newOwner`).
759      * Can only be called by the current owner.
760      */
761     function transferOwnership(address newOwner) public virtual onlyOwner {
762         require(newOwner != address(0), "Ownable: new owner is the zero address");
763         _transferOwnership(newOwner);
764     }
765 
766     /**
767      * @dev Transfers ownership of the contract to a new account (`newOwner`).
768      * Internal function without access restriction.
769      */
770     function _transferOwnership(address newOwner) internal virtual {
771         address oldOwner = _owner;
772         _owner = newOwner;
773         emit OwnershipTransferred(oldOwner, newOwner);
774     }
775 }
776 
777 // File: @openzeppelin/contracts/utils/Address.sol
778 
779 
780 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
781 
782 pragma solidity ^0.8.1;
783 
784 /**
785  * @dev Collection of functions related to the address type
786  */
787 library Address {
788     /**
789      * @dev Returns true if `account` is a contract.
790      *
791      * [IMPORTANT]
792      * ====
793      * It is unsafe to assume that an address for which this function returns
794      * false is an externally-owned account (EOA) and not a contract.
795      *
796      * Among others, `isContract` will return false for the following
797      * types of addresses:
798      *
799      *  - an externally-owned account
800      *  - a contract in construction
801      *  - an address where a contract will be created
802      *  - an address where a contract lived, but was destroyed
803      * ====
804      *
805      * [IMPORTANT]
806      * ====
807      * You shouldn't rely on `isContract` to protect against flash loan attacks!
808      *
809      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
810      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
811      * constructor.
812      * ====
813      */
814     function isContract(address account) internal view returns (bool) {
815         // This method relies on extcodesize/address.code.length, which returns 0
816         // for contracts in construction, since the code is only stored at the end
817         // of the constructor execution.
818 
819         return account.code.length > 0;
820     }
821 
822     /**
823      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
824      * `recipient`, forwarding all available gas and reverting on errors.
825      *
826      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
827      * of certain opcodes, possibly making contracts go over the 2300 gas limit
828      * imposed by `transfer`, making them unable to receive funds via
829      * `transfer`. {sendValue} removes this limitation.
830      *
831      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
832      *
833      * IMPORTANT: because control is transferred to `recipient`, care must be
834      * taken to not create reentrancy vulnerabilities. Consider using
835      * {ReentrancyGuard} or the
836      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
837      */
838     function sendValue(address payable recipient, uint256 amount) internal {
839         require(address(this).balance >= amount, "Address: insufficient balance");
840 
841         (bool success, ) = recipient.call{value: amount}("");
842         require(success, "Address: unable to send value, recipient may have reverted");
843     }
844 
845     /**
846      * @dev Performs a Solidity function call using a low level `call`. A
847      * plain `call` is an unsafe replacement for a function call: use this
848      * function instead.
849      *
850      * If `target` reverts with a revert reason, it is bubbled up by this
851      * function (like regular Solidity function calls).
852      *
853      * Returns the raw returned data. To convert to the expected return value,
854      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
855      *
856      * Requirements:
857      *
858      * - `target` must be a contract.
859      * - calling `target` with `data` must not revert.
860      *
861      * _Available since v3.1._
862      */
863     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
864         return functionCall(target, data, "Address: low-level call failed");
865     }
866 
867     /**
868      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
869      * `errorMessage` as a fallback revert reason when `target` reverts.
870      *
871      * _Available since v3.1._
872      */
873     function functionCall(
874         address target,
875         bytes memory data,
876         string memory errorMessage
877     ) internal returns (bytes memory) {
878         return functionCallWithValue(target, data, 0, errorMessage);
879     }
880 
881     /**
882      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
883      * but also transferring `value` wei to `target`.
884      *
885      * Requirements:
886      *
887      * - the calling contract must have an ETH balance of at least `value`.
888      * - the called Solidity function must be `payable`.
889      *
890      * _Available since v3.1._
891      */
892     function functionCallWithValue(
893         address target,
894         bytes memory data,
895         uint256 value
896     ) internal returns (bytes memory) {
897         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
898     }
899 
900     /**
901      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
902      * with `errorMessage` as a fallback revert reason when `target` reverts.
903      *
904      * _Available since v3.1._
905      */
906     function functionCallWithValue(
907         address target,
908         bytes memory data,
909         uint256 value,
910         string memory errorMessage
911     ) internal returns (bytes memory) {
912         require(address(this).balance >= value, "Address: insufficient balance for call");
913         require(isContract(target), "Address: call to non-contract");
914 
915         (bool success, bytes memory returndata) = target.call{value: value}(data);
916         return verifyCallResult(success, returndata, errorMessage);
917     }
918 
919     /**
920      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
921      * but performing a static call.
922      *
923      * _Available since v3.3._
924      */
925     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
926         return functionStaticCall(target, data, "Address: low-level static call failed");
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
931      * but performing a static call.
932      *
933      * _Available since v3.3._
934      */
935     function functionStaticCall(
936         address target,
937         bytes memory data,
938         string memory errorMessage
939     ) internal view returns (bytes memory) {
940         require(isContract(target), "Address: static call to non-contract");
941 
942         (bool success, bytes memory returndata) = target.staticcall(data);
943         return verifyCallResult(success, returndata, errorMessage);
944     }
945 
946     /**
947      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
948      * but performing a delegate call.
949      *
950      * _Available since v3.4._
951      */
952     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
953         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
954     }
955 
956     /**
957      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
958      * but performing a delegate call.
959      *
960      * _Available since v3.4._
961      */
962     function functionDelegateCall(
963         address target,
964         bytes memory data,
965         string memory errorMessage
966     ) internal returns (bytes memory) {
967         require(isContract(target), "Address: delegate call to non-contract");
968 
969         (bool success, bytes memory returndata) = target.delegatecall(data);
970         return verifyCallResult(success, returndata, errorMessage);
971     }
972 
973     /**
974      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
975      * revert reason using the provided one.
976      *
977      * _Available since v4.3._
978      */
979     function verifyCallResult(
980         bool success,
981         bytes memory returndata,
982         string memory errorMessage
983     ) internal pure returns (bytes memory) {
984         if (success) {
985             return returndata;
986         } else {
987             // Look for revert reason and bubble it up if present
988             if (returndata.length > 0) {
989                 // The easiest way to bubble the revert reason is using memory via assembly
990 
991                 assembly {
992                     let returndata_size := mload(returndata)
993                     revert(add(32, returndata), returndata_size)
994                 }
995             } else {
996                 revert(errorMessage);
997             }
998         }
999     }
1000 }
1001 
1002 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1003 
1004 
1005 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1006 
1007 pragma solidity ^0.8.0;
1008 
1009 /**
1010  * @dev Interface of the ERC165 standard, as defined in the
1011  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1012  *
1013  * Implementers can declare support of contract interfaces, which can then be
1014  * queried by others ({ERC165Checker}).
1015  *
1016  * For an implementation, see {ERC165}.
1017  */
1018 interface IERC165 {
1019     /**
1020      * @dev Returns true if this contract implements the interface defined by
1021      * `interfaceId`. See the corresponding
1022      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1023      * to learn more about how these ids are created.
1024      *
1025      * This function call must use less than 30 000 gas.
1026      */
1027     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1028 }
1029 
1030 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1031 
1032 
1033 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1034 
1035 pragma solidity ^0.8.0;
1036 
1037 
1038 /**
1039  * @dev Required interface of an ERC721 compliant contract.
1040  */
1041 interface IERC721 is IERC165 {
1042     /**
1043      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1044      */
1045     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1046 
1047     /**
1048      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1049      */
1050     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1051 
1052     /**
1053      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1054      */
1055     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1056 
1057     /**
1058      * @dev Returns the number of tokens in ``owner``'s account.
1059      */
1060     function balanceOf(address owner) external view returns (uint256 balance);
1061 
1062     /**
1063      * @dev Returns the owner of the `tokenId` token.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must exist.
1068      */
1069     function ownerOf(uint256 tokenId) external view returns (address owner);
1070 
1071     /**
1072      * @dev Safely transfers `tokenId` token from `from` to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must exist and be owned by `from`.
1079      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes calldata data
1089     ) external;
1090 
1091     /**
1092      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1093      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must exist and be owned by `from`.
1100      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) external;
1110 
1111     /**
1112      * @dev Transfers `tokenId` token from `from` to `to`.
1113      *
1114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1115      *
1116      * Requirements:
1117      *
1118      * - `from` cannot be the zero address.
1119      * - `to` cannot be the zero address.
1120      * - `tokenId` token must be owned by `from`.
1121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function transferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) external;
1130 
1131     /**
1132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1133      * The approval is cleared when the token is transferred.
1134      *
1135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1136      *
1137      * Requirements:
1138      *
1139      * - The caller must own the token or be an approved operator.
1140      * - `tokenId` must exist.
1141      *
1142      * Emits an {Approval} event.
1143      */
1144     function approve(address to, uint256 tokenId) external;
1145 
1146     /**
1147      * @dev Approve or remove `operator` as an operator for the caller.
1148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1149      *
1150      * Requirements:
1151      *
1152      * - The `operator` cannot be the caller.
1153      *
1154      * Emits an {ApprovalForAll} event.
1155      */
1156     function setApprovalForAll(address operator, bool _approved) external;
1157 
1158     /**
1159      * @dev Returns the account approved for `tokenId` token.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must exist.
1164      */
1165     function getApproved(uint256 tokenId) external view returns (address operator);
1166 
1167     /**
1168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1169      *
1170      * See {setApprovalForAll}
1171      */
1172     function isApprovedForAll(address owner, address operator) external view returns (bool);
1173 }
1174 
1175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1176 
1177 
1178 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 
1183 /**
1184  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1185  * @dev See https://eips.ethereum.org/EIPS/eip-721
1186  */
1187 interface IERC721Enumerable is IERC721 {
1188     /**
1189      * @dev Returns the total amount of tokens stored by the contract.
1190      */
1191     function totalSupply() external view returns (uint256);
1192 
1193     /**
1194      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1195      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1196      */
1197     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1198 
1199     /**
1200      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1201      * Use along with {totalSupply} to enumerate all tokens.
1202      */
1203     function tokenByIndex(uint256 index) external view returns (uint256);
1204 }
1205 
1206 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1207 
1208 
1209 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1210 
1211 pragma solidity ^0.8.0;
1212 
1213 
1214 /**
1215  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1216  * @dev See https://eips.ethereum.org/EIPS/eip-721
1217  */
1218 interface IERC721Metadata is IERC721 {
1219     /**
1220      * @dev Returns the token collection name.
1221      */
1222     function name() external view returns (string memory);
1223 
1224     /**
1225      * @dev Returns the token collection symbol.
1226      */
1227     function symbol() external view returns (string memory);
1228 
1229     /**
1230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1231      */
1232     function tokenURI(uint256 tokenId) external view returns (string memory);
1233 }
1234 
1235 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1236 
1237 
1238 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 
1243 /**
1244  * @dev Implementation of the {IERC165} interface.
1245  *
1246  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1247  * for the additional interface id that will be supported. For example:
1248  *
1249  * ```solidity
1250  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1251  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1252  * }
1253  * ```
1254  *
1255  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1256  */
1257 abstract contract ERC165 is IERC165 {
1258     /**
1259      * @dev See {IERC165-supportsInterface}.
1260      */
1261     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1262         return interfaceId == type(IERC165).interfaceId;
1263     }
1264 }
1265 
1266 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1267 
1268 
1269 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 /**
1274  * @title ERC721 token receiver interface
1275  * @dev Interface for any contract that wants to support safeTransfers
1276  * from ERC721 asset contracts.
1277  */
1278 interface IERC721Receiver {
1279     /**
1280      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1281      * by `operator` from `from`, this function is called.
1282      *
1283      * It must return its Solidity selector to confirm the token transfer.
1284      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1285      *
1286      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1287      */
1288     function onERC721Received(
1289         address operator,
1290         address from,
1291         uint256 tokenId,
1292         bytes calldata data
1293     ) external returns (bytes4);
1294 }
1295 
1296 // File: @openzeppelin/contracts/utils/Strings.sol
1297 
1298 
1299 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1300 
1301 pragma solidity ^0.8.0;
1302 
1303 /**
1304  * @dev String operations.
1305  */
1306 library Strings {
1307     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1308     uint8 private constant _ADDRESS_LENGTH = 20;
1309 
1310     /**
1311      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1312      */
1313     function toString(uint256 value) internal pure returns (string memory) {
1314         // Inspired by OraclizeAPI's implementation - MIT licence
1315         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1316 
1317         if (value == 0) {
1318             return "0";
1319         }
1320         uint256 temp = value;
1321         uint256 digits;
1322         while (temp != 0) {
1323             digits++;
1324             temp /= 10;
1325         }
1326         bytes memory buffer = new bytes(digits);
1327         while (value != 0) {
1328             digits -= 1;
1329             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1330             value /= 10;
1331         }
1332         return string(buffer);
1333     }
1334 
1335     /**
1336      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1337      */
1338     function toHexString(uint256 value) internal pure returns (string memory) {
1339         if (value == 0) {
1340             return "0x00";
1341         }
1342         uint256 temp = value;
1343         uint256 length = 0;
1344         while (temp != 0) {
1345             length++;
1346             temp >>= 8;
1347         }
1348         return toHexString(value, length);
1349     }
1350 
1351     /**
1352      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1353      */
1354     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1355         bytes memory buffer = new bytes(2 * length + 2);
1356         buffer[0] = "0";
1357         buffer[1] = "x";
1358         for (uint256 i = 2 * length + 1; i > 1; --i) {
1359             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1360             value >>= 4;
1361         }
1362         require(value == 0, "Strings: hex length insufficient");
1363         return string(buffer);
1364     }
1365 
1366     /**
1367      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1368      */
1369     function toHexString(address addr) internal pure returns (string memory) {
1370         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1371     }
1372 }
1373 
1374 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1375 
1376 
1377 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 /**
1389  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1390  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1391  * {ERC721Enumerable}.
1392  */
1393 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1394     using Address for address;
1395     using Strings for uint256;
1396 
1397     // Token name
1398     string private _name;
1399 
1400     // Token symbol
1401     string private _symbol;
1402 
1403     // Mapping from token ID to owner address
1404     mapping(uint256 => address) private _owners;
1405 
1406     // Mapping owner address to token count
1407     mapping(address => uint256) private _balances;
1408 
1409     // Mapping from token ID to approved address
1410     mapping(uint256 => address) private _tokenApprovals;
1411 
1412     // Mapping from owner to operator approvals
1413     mapping(address => mapping(address => bool)) private _operatorApprovals;
1414 
1415     /**
1416      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1417      */
1418     constructor(string memory name_, string memory symbol_) {
1419         _name = name_;
1420         _symbol = symbol_;
1421     }
1422 
1423     /**
1424      * @dev See {IERC165-supportsInterface}.
1425      */
1426     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1427         return
1428             interfaceId == type(IERC721).interfaceId ||
1429             interfaceId == type(IERC721Metadata).interfaceId ||
1430             super.supportsInterface(interfaceId);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-balanceOf}.
1435      */
1436     function balanceOf(address owner) public view virtual override returns (uint256) {
1437         require(owner != address(0), "ERC721: address zero is not a valid owner");
1438         return _balances[owner];
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-ownerOf}.
1443      */
1444     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1445         address owner = _owners[tokenId];
1446         require(owner != address(0), "ERC721: invalid token ID");
1447         return owner;
1448     }
1449 
1450     /**
1451      * @dev See {IERC721Metadata-name}.
1452      */
1453     function name() public view virtual override returns (string memory) {
1454         return _name;
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Metadata-symbol}.
1459      */
1460     function symbol() public view virtual override returns (string memory) {
1461         return _symbol;
1462     }
1463 
1464     /**
1465      * @dev See {IERC721Metadata-tokenURI}.
1466      */
1467     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1468         _requireMinted(tokenId);
1469 
1470         string memory baseURI = _baseURI();
1471         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1472     }
1473 
1474     /**
1475      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1476      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1477      * by default, can be overridden in child contracts.
1478      */
1479     function _baseURI() internal view virtual returns (string memory) {
1480         return "";
1481     }
1482 
1483     /**
1484      * @dev See {IERC721-approve}.
1485      */
1486     function approve(address to, uint256 tokenId) public virtual override {
1487         address owner = ERC721.ownerOf(tokenId);
1488         require(to != owner, "ERC721: approval to current owner");
1489 
1490         require(
1491             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1492             "ERC721: approve caller is not token owner nor approved for all"
1493         );
1494 
1495         _approve(to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-getApproved}.
1500      */
1501     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1502         _requireMinted(tokenId);
1503 
1504         return _tokenApprovals[tokenId];
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-setApprovalForAll}.
1509      */
1510     function setApprovalForAll(address operator, bool approved) public virtual override {
1511         _setApprovalForAll(_msgSender(), operator, approved);
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-isApprovedForAll}.
1516      */
1517     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1518         return _operatorApprovals[owner][operator];
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-transferFrom}.
1523      */
1524     function transferFrom(
1525         address from,
1526         address to,
1527         uint256 tokenId
1528     ) public virtual override {
1529         //solhint-disable-next-line max-line-length
1530         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1531 
1532         _transfer(from, to, tokenId);
1533     }
1534 
1535     /**
1536      * @dev See {IERC721-safeTransferFrom}.
1537      */
1538     function safeTransferFrom(
1539         address from,
1540         address to,
1541         uint256 tokenId
1542     ) public virtual override {
1543         safeTransferFrom(from, to, tokenId, "");
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-safeTransferFrom}.
1548      */
1549     function safeTransferFrom(
1550         address from,
1551         address to,
1552         uint256 tokenId,
1553         bytes memory data
1554     ) public virtual override {
1555         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1556         _safeTransfer(from, to, tokenId, data);
1557     }
1558 
1559     /**
1560      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1561      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1562      *
1563      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1564      *
1565      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1566      * implement alternative mechanisms to perform token transfer, such as signature-based.
1567      *
1568      * Requirements:
1569      *
1570      * - `from` cannot be the zero address.
1571      * - `to` cannot be the zero address.
1572      * - `tokenId` token must exist and be owned by `from`.
1573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1574      *
1575      * Emits a {Transfer} event.
1576      */
1577     function _safeTransfer(
1578         address from,
1579         address to,
1580         uint256 tokenId,
1581         bytes memory data
1582     ) internal virtual {
1583         _transfer(from, to, tokenId);
1584         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1585     }
1586 
1587     /**
1588      * @dev Returns whether `tokenId` exists.
1589      *
1590      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1591      *
1592      * Tokens start existing when they are minted (`_mint`),
1593      * and stop existing when they are burned (`_burn`).
1594      */
1595     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1596         return _owners[tokenId] != address(0);
1597     }
1598 
1599     /**
1600      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1601      *
1602      * Requirements:
1603      *
1604      * - `tokenId` must exist.
1605      */
1606     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1607         address owner = ERC721.ownerOf(tokenId);
1608         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1609     }
1610 
1611     /**
1612      * @dev Safely mints `tokenId` and transfers it to `to`.
1613      *
1614      * Requirements:
1615      *
1616      * - `tokenId` must not exist.
1617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1618      *
1619      * Emits a {Transfer} event.
1620      */
1621     function _safeMint(address to, uint256 tokenId) internal virtual {
1622         _safeMint(to, tokenId, "");
1623     }
1624 
1625     /**
1626      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1627      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1628      */
1629     function _safeMint(
1630         address to,
1631         uint256 tokenId,
1632         bytes memory data
1633     ) internal virtual {
1634         _mint(to, tokenId);
1635         require(
1636             _checkOnERC721Received(address(0), to, tokenId, data),
1637             "ERC721: transfer to non ERC721Receiver implementer"
1638         );
1639     }
1640 
1641     /**
1642      * @dev Mints `tokenId` and transfers it to `to`.
1643      *
1644      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1645      *
1646      * Requirements:
1647      *
1648      * - `tokenId` must not exist.
1649      * - `to` cannot be the zero address.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function _mint(address to, uint256 tokenId) internal virtual {
1654         require(to != address(0), "ERC721: mint to the zero address");
1655         require(!_exists(tokenId), "ERC721: token already minted");
1656 
1657         _beforeTokenTransfer(address(0), to, tokenId);
1658 
1659         _balances[to] += 1;
1660         _owners[tokenId] = to;
1661 
1662         emit Transfer(address(0), to, tokenId);
1663 
1664         _afterTokenTransfer(address(0), to, tokenId);
1665     }
1666 
1667     /**
1668      * @dev Destroys `tokenId`.
1669      * The approval is cleared when the token is burned.
1670      *
1671      * Requirements:
1672      *
1673      * - `tokenId` must exist.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _burn(uint256 tokenId) internal virtual {
1678         address owner = ERC721.ownerOf(tokenId);
1679 
1680         _beforeTokenTransfer(owner, address(0), tokenId);
1681 
1682         // Clear approvals
1683         _approve(address(0), tokenId);
1684 
1685         _balances[owner] -= 1;
1686         delete _owners[tokenId];
1687 
1688         emit Transfer(owner, address(0), tokenId);
1689 
1690         _afterTokenTransfer(owner, address(0), tokenId);
1691     }
1692 
1693     /**
1694      * @dev Transfers `tokenId` from `from` to `to`.
1695      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1696      *
1697      * Requirements:
1698      *
1699      * - `to` cannot be the zero address.
1700      * - `tokenId` token must be owned by `from`.
1701      *
1702      * Emits a {Transfer} event.
1703      */
1704     function _transfer(
1705         address from,
1706         address to,
1707         uint256 tokenId
1708     ) internal virtual {
1709         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1710         require(to != address(0), "ERC721: transfer to the zero address");
1711 
1712         _beforeTokenTransfer(from, to, tokenId);
1713 
1714         // Clear approvals from the previous owner
1715         _approve(address(0), tokenId);
1716 
1717         _balances[from] -= 1;
1718         _balances[to] += 1;
1719         _owners[tokenId] = to;
1720 
1721         emit Transfer(from, to, tokenId);
1722 
1723         _afterTokenTransfer(from, to, tokenId);
1724     }
1725 
1726     /**
1727      * @dev Approve `to` to operate on `tokenId`
1728      *
1729      * Emits an {Approval} event.
1730      */
1731     function _approve(address to, uint256 tokenId) internal virtual {
1732         _tokenApprovals[tokenId] = to;
1733         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1734     }
1735 
1736     /**
1737      * @dev Approve `operator` to operate on all of `owner` tokens
1738      *
1739      * Emits an {ApprovalForAll} event.
1740      */
1741     function _setApprovalForAll(
1742         address owner,
1743         address operator,
1744         bool approved
1745     ) internal virtual {
1746         require(owner != operator, "ERC721: approve to caller");
1747         _operatorApprovals[owner][operator] = approved;
1748         emit ApprovalForAll(owner, operator, approved);
1749     }
1750 
1751     /**
1752      * @dev Reverts if the `tokenId` has not been minted yet.
1753      */
1754     function _requireMinted(uint256 tokenId) internal view virtual {
1755         require(_exists(tokenId), "ERC721: invalid token ID");
1756     }
1757 
1758     /**
1759      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1760      * The call is not executed if the target address is not a contract.
1761      *
1762      * @param from address representing the previous owner of the given token ID
1763      * @param to target address that will receive the tokens
1764      * @param tokenId uint256 ID of the token to be transferred
1765      * @param data bytes optional data to send along with the call
1766      * @return bool whether the call correctly returned the expected magic value
1767      */
1768     function _checkOnERC721Received(
1769         address from,
1770         address to,
1771         uint256 tokenId,
1772         bytes memory data
1773     ) private returns (bool) {
1774         if (to.isContract()) {
1775             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1776                 return retval == IERC721Receiver.onERC721Received.selector;
1777             } catch (bytes memory reason) {
1778                 if (reason.length == 0) {
1779                     revert("ERC721: transfer to non ERC721Receiver implementer");
1780                 } else {
1781                     /// @solidity memory-safe-assembly
1782                     assembly {
1783                         revert(add(32, reason), mload(reason))
1784                     }
1785                 }
1786             }
1787         } else {
1788             return true;
1789         }
1790     }
1791 
1792     /**
1793      * @dev Hook that is called before any token transfer. This includes minting
1794      * and burning.
1795      *
1796      * Calling conditions:
1797      *
1798      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1799      * transferred to `to`.
1800      * - When `from` is zero, `tokenId` will be minted for `to`.
1801      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1802      * - `from` and `to` are never both zero.
1803      *
1804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1805      */
1806     function _beforeTokenTransfer(
1807         address from,
1808         address to,
1809         uint256 tokenId
1810     ) internal virtual {}
1811 
1812     /**
1813      * @dev Hook that is called after any transfer of tokens. This includes
1814      * minting and burning.
1815      *
1816      * Calling conditions:
1817      *
1818      * - when `from` and `to` are both non-zero.
1819      * - `from` and `to` are never both zero.
1820      *
1821      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1822      */
1823     function _afterTokenTransfer(
1824         address from,
1825         address to,
1826         uint256 tokenId
1827     ) internal virtual {}
1828 }
1829 
1830 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1831 
1832 
1833 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1834 
1835 pragma solidity ^0.8.0;
1836 
1837 
1838 
1839 /**
1840  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1841  * enumerability of all the token ids in the contract as well as all token ids owned by each
1842  * account.
1843  */
1844 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1845     // Mapping from owner to list of owned token IDs
1846     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1847 
1848     // Mapping from token ID to index of the owner tokens list
1849     mapping(uint256 => uint256) private _ownedTokensIndex;
1850 
1851     // Array with all token ids, used for enumeration
1852     uint256[] private _allTokens;
1853 
1854     // Mapping from token id to position in the allTokens array
1855     mapping(uint256 => uint256) private _allTokensIndex;
1856 
1857     /**
1858      * @dev See {IERC165-supportsInterface}.
1859      */
1860     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1861         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1862     }
1863 
1864     /**
1865      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1866      */
1867     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1868         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1869         return _ownedTokens[owner][index];
1870     }
1871 
1872     /**
1873      * @dev See {IERC721Enumerable-totalSupply}.
1874      */
1875     function totalSupply() public view virtual override returns (uint256) {
1876         return _allTokens.length;
1877     }
1878 
1879     /**
1880      * @dev See {IERC721Enumerable-tokenByIndex}.
1881      */
1882     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1883         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1884         return _allTokens[index];
1885     }
1886 
1887     /**
1888      * @dev Hook that is called before any token transfer. This includes minting
1889      * and burning.
1890      *
1891      * Calling conditions:
1892      *
1893      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1894      * transferred to `to`.
1895      * - When `from` is zero, `tokenId` will be minted for `to`.
1896      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1897      * - `from` cannot be the zero address.
1898      * - `to` cannot be the zero address.
1899      *
1900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1901      */
1902     function _beforeTokenTransfer(
1903         address from,
1904         address to,
1905         uint256 tokenId
1906     ) internal virtual override {
1907         super._beforeTokenTransfer(from, to, tokenId);
1908 
1909         if (from == address(0)) {
1910             _addTokenToAllTokensEnumeration(tokenId);
1911         } else if (from != to) {
1912             _removeTokenFromOwnerEnumeration(from, tokenId);
1913         }
1914         if (to == address(0)) {
1915             _removeTokenFromAllTokensEnumeration(tokenId);
1916         } else if (to != from) {
1917             _addTokenToOwnerEnumeration(to, tokenId);
1918         }
1919     }
1920 
1921     /**
1922      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1923      * @param to address representing the new owner of the given token ID
1924      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1925      */
1926     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1927         uint256 length = ERC721.balanceOf(to);
1928         _ownedTokens[to][length] = tokenId;
1929         _ownedTokensIndex[tokenId] = length;
1930     }
1931 
1932     /**
1933      * @dev Private function to add a token to this extension's token tracking data structures.
1934      * @param tokenId uint256 ID of the token to be added to the tokens list
1935      */
1936     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1937         _allTokensIndex[tokenId] = _allTokens.length;
1938         _allTokens.push(tokenId);
1939     }
1940 
1941     /**
1942      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1943      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1944      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1945      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1946      * @param from address representing the previous owner of the given token ID
1947      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1948      */
1949     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1950         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1951         // then delete the last slot (swap and pop).
1952 
1953         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1954         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1955 
1956         // When the token to delete is the last token, the swap operation is unnecessary
1957         if (tokenIndex != lastTokenIndex) {
1958             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1959 
1960             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1961             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1962         }
1963 
1964         // This also deletes the contents at the last position of the array
1965         delete _ownedTokensIndex[tokenId];
1966         delete _ownedTokens[from][lastTokenIndex];
1967     }
1968 
1969     /**
1970      * @dev Private function to remove a token from this extension's token tracking data structures.
1971      * This has O(1) time complexity, but alters the order of the _allTokens array.
1972      * @param tokenId uint256 ID of the token to be removed from the tokens list
1973      */
1974     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1975         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1976         // then delete the last slot (swap and pop).
1977 
1978         uint256 lastTokenIndex = _allTokens.length - 1;
1979         uint256 tokenIndex = _allTokensIndex[tokenId];
1980 
1981         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1982         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1983         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1984         uint256 lastTokenId = _allTokens[lastTokenIndex];
1985 
1986         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1987         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1988 
1989         // This also deletes the contents at the last position of the array
1990         delete _allTokensIndex[tokenId];
1991         _allTokens.pop();
1992     }
1993 }
1994 
1995 // File: contracts/NemesisLands.sol
1996 
1997 
1998 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1999 
2000 pragma solidity ^0.8.0;
2001 
2002 
2003 
2004 
2005 
2006 
2007 
2008 
2009 
2010 
2011 
2012 
2013 
2014 
2015 
2016 
2017 
2018 contract NemesisLands is  Ownable, ERC721Enumerable, DefaultOperatorFilterer, Pausable, INemsPrice {
2019 
2020 //impostare la base uri (con lo slsh finale) all'api del bridge 
2021 //di lettura dei metadati su polygon
2022   uint256 public startDate;
2023 
2024 
2025 constructor(
2026     uint256 _startDate,
2027     address _USDCAddress, // 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
2028     address _USDTAddress, // 0xdac17f958d2ee523a2206206994597c13d831ec7
2029     address _NEMSAddress  // 0xb435A47eCea7F5366b2520e45B9beD7E01d2FFAe
2030 
2031   ) ERC721("The Nemesis Lands", "TNL") {
2032     setStartDate(_startDate);
2033     USDC = IERC20(_USDCAddress);
2034     USDT = IERC20(_USDTAddress);
2035     NEMS= IERC20(_NEMSAddress);
2036   } 
2037 
2038   IERC20 USDT;
2039   IERC20 USDC;
2040   IERC20 NEMS;
2041   
2042   using Strings for uint256;
2043 
2044   string public baseURI="https://api.thenemesis.io/v5/lands/assets/1/";
2045   string public contractURI="https://api.thenemesis.io/v5/lands/collection/1";
2046   uint256 public PublicUSDPrice = 280;//costo al pubblico
2047   uint256 public WLUSDPrice = 140;//costo per gli utenti whitelist
2048   uint256 public _NemsUSDPrice = 1000000000000000000;//prezzo di 1 NEMS in USD 18 Decimali;
2049   uint256 public maxSupply = 11520;//numero di token della collection
2050   bool public isPublicOpen;
2051 
2052    error FunctionInvalidAtThisStage();
2053 
2054   mapping(uint256 => address) public _reservedLands;
2055 
2056     enum MintStage {
2057         NotOpen,
2058         ReservedLands,
2059         Public
2060     }
2061 
2062  function uri(uint256 _tokenID)
2063         public
2064         view
2065         returns (string memory)
2066     {
2067         return tokenURI(_tokenID);
2068     }
2069 
2070 
2071 
2072   function _contractURI() public view  returns (string memory) {
2073     return contractURI;
2074   }
2075 
2076   function _baseURI() internal view virtual override returns (string memory) {
2077     return baseURI;
2078   }
2079 
2080     modifier atMintStage(MintStage mintStage_) {
2081         MintStage mintStage = getMintStage();
2082 
2083         require(mintStage==mintStage_, "This function is not allowed now");
2084 
2085         if (mintStage != mintStage_) revert FunctionInvalidAtThisStage();
2086         _;
2087     }
2088     //mette in pausa il contratto
2089     function pause() public onlyOwner {
2090         _pause();
2091     }
2092 
2093     //riattiva il contratto
2094     function unpause() public onlyOwner {
2095         _unpause();
2096     }
2097 
2098     //override necessario per implementazione ERC721Enumerable
2099     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
2100         internal
2101         whenNotPaused
2102         override
2103     {
2104         super._beforeTokenTransfer(from, to, tokenId);
2105     }
2106 
2107  
2108 
2109     function getMintStage() public view returns (MintStage) {
2110         return isPublicOpen?MintStage.Public:MintStage.ReservedLands;
2111     }
2112 
2113 
2114     function mintReservedLands(uint256[] memory _tokenIds, bool _usdt) public whenNotPaused atMintStage(MintStage.ReservedLands) {
2115 
2116         uint256 numNft = _tokenIds.length;  
2117 
2118         require(numNft > 0, "need to mint at least 1 NFT");
2119 
2120             for (uint256 i=0; i< numNft; i++) {       
2121                     uint256 tokenid = _tokenIds[i];
2122                     require(_reservedLands[tokenid] == msg.sender, "You have not reserved all the requested lands");
2123             }
2124         
2125             for (uint256 i = 0; i <  numNft; i++) {
2126                     _safeMint(msg.sender, _tokenIds[i]);
2127 
2128             }
2129 
2130             if(_usdt){
2131                 _checkAllowanceAndTransferERC20(USDT,numNft );
2132             }else{
2133                 //USDC
2134                 _checkAllowanceAndTransferERC20(USDC,numNft );
2135             }
2136 
2137     }
2138 
2139 
2140     function mintPublicLands(uint256[] memory _tokenIds) public whenNotPaused atMintStage(MintStage.Public) {
2141 
2142             uint256 numNft = _tokenIds.length;  
2143 
2144             require(numNft > 0, "need to mint at least 1 NFT");
2145 
2146             for (uint256 i=0; i< numNft; i++) {       
2147                 uint256 tokenid = _tokenIds[i];
2148                 bool tokenExist = _exists(tokenid);
2149                 require(!tokenExist, "Land already minted");
2150             }
2151         
2152             for (uint256 i = 0; i <  numNft; i++) {
2153                 _safeMint(msg.sender, _tokenIds[i]);
2154             }
2155 
2156             _checkAllowanceAndTransferERC20(NEMS,numNft);
2157 
2158     }
2159 
2160 
2161     function _checkAllowanceAndTransferERC20(IERC20 token, uint256 numnft) internal{
2162           uint256 balancetoken = token.balanceOf(msg.sender);
2163           uint256 amount = getLandPrice();
2164           uint256 totalprice = amount * numnft;
2165           require (balancetoken >= totalprice, "You don't have enough funds to process the payment.");
2166           token.transferFrom(msg.sender,address(this), totalprice);
2167     }
2168 
2169 
2170     function getLandPrice() public view  returns (uint256 _price){
2171         MintStage stage = getMintStage();
2172 
2173         if(stage==MintStage.Public){
2174            //solo pagamento in NEMS
2175            return PublicUSDPrice * _NemsUSDPrice;
2176 
2177         }else if(stage== MintStage.ReservedLands){
2178             //pagamento in USDC/USDT
2179             return WLUSDPrice * 1e18;
2180         }
2181     }
2182 
2183     function getNextFreeLand() internal view returns (uint256 _tokenID) {
2184          for (uint256 i = 1; i <= maxSupply; i++) 
2185         {
2186             if(!_exists(i)){
2187                 return i;
2188             }
2189         }
2190         return 0;
2191     }
2192 
2193 
2194   function tokenURI(uint256 tokenId)
2195     public
2196     view
2197     virtual
2198     override
2199     returns (string memory)
2200   {
2201     require(
2202       _exists(tokenId), "URI query for nonexistent token");
2203 
2204     string memory currentBaseURI = _baseURI();
2205     return bytes(currentBaseURI).length > 0
2206         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2207         : "";
2208   }
2209 
2210 
2211     function airdrop(uint256[] memory landnum, address[] calldata wallets) external whenNotPaused onlyOwner {
2212         
2213         require (landnum.length == wallets.length, "The array must have the same length");
2214         require (landnum.length > 0, "Mint amount should be greater than 0");
2215         uint256 supply = totalSupply();
2216         require ((supply + landnum.length) <= maxSupply,"max NFT limit exceeded");
2217 
2218         for (uint256 i = 0; i < landnum.length; i++) {
2219                 uint256 _landnum = landnum[i];
2220                 address wallet = wallets[i];
2221                 require(!_exists(_landnum), "Land already minted!");
2222                 _safeMint(wallet,_landnum );
2223         }
2224     }
2225 
2226 
2227     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2228         baseURI = _newBaseURI;
2229     }
2230 
2231     function setContractURI(string memory _newContractURI) public onlyOwner {
2232         contractURI = _newContractURI;
2233     }
2234 
2235     function setPublicUSDPrice(uint256 _PublicUSDPrice) public onlyOwner {
2236         PublicUSDPrice = _PublicUSDPrice;
2237     }
2238       function setWLUSDPrice(uint256 _WLUSDPrice) public onlyOwner {
2239         WLUSDPrice = _WLUSDPrice;
2240     }
2241       function setNemsUSDPrice(uint256 USDPrice) public onlyOwner {
2242         _NemsUSDPrice = USDPrice;
2243     }
2244 
2245       function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2246         maxSupply = _maxSupply;
2247     }
2248 
2249     function setisPublicOpen(bool  _isPublicOpen) public onlyOwner {
2250         isPublicOpen = _isPublicOpen;
2251     }
2252 
2253     function setStartDate(uint256 date) public onlyOwner {
2254         startDate = date;
2255     }
2256 
2257     
2258     function addLandReservation(uint256[] memory landnum, address[] calldata reserve) external whenNotPaused onlyOwner {
2259 
2260         require(landnum.length == reserve.length, "The array must have the same length");
2261 
2262          for (uint256 i = 0; i < landnum.length; i++) 
2263                 {
2264                 uint256 _landnum = landnum[i];
2265                 address wallet = reserve[i];
2266 
2267                 require(_reservedLands[_landnum] == address(0), "Land already reserved!");
2268                 require(!_exists(_landnum), "Land already minted!");
2269                 _reservedLands[_landnum]= wallet;
2270                 }
2271     }
2272 
2273   function removeLandReservation(uint256[] memory landnum ) external whenNotPaused onlyOwner {
2274         require (landnum.length > 0, "No landNums specified");
2275 
2276         for (uint256 i = 0; i < landnum.length; i++) {
2277             _reservedLands[landnum[i]] = address(0);
2278         }
2279   }
2280 
2281   //trasferisce gli eth dal contratto al wallet dell'owner
2282   function withdraw() external onlyOwner {
2283    //(bool success,)=payable(owner()).call{value:address(this).balance}("");
2284 
2285     uint256 balanceUsdt = USDT.balanceOf(address(this));
2286         if(balanceUsdt > 0){
2287             USDT.transfer(owner(),balanceUsdt);
2288         }
2289 
2290 
2291     uint256 balanceUsdc = USDC.balanceOf(address(this));
2292         if(balanceUsdc > 0){
2293             USDC.transfer(owner(), balanceUsdc);
2294 
2295         }
2296 
2297     uint256 balanceNems = NEMS.balanceOf(address(this));
2298         if(balanceNems > 0){
2299             NEMS.transfer(owner(), balanceNems);
2300         }
2301 
2302   }
2303 
2304 
2305     function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
2306         super.setApprovalForAll(operator, approved);
2307     }
2308 
2309     function approve(address operator, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
2310         super.approve(operator, tokenId);
2311     }
2312 
2313     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2314         super.transferFrom(from, to, tokenId);
2315     }
2316 
2317     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2318         super.safeTransferFrom(from, to, tokenId);
2319     }
2320 
2321     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2322         public
2323         override(ERC721, IERC721)
2324         onlyAllowedOperator(from)
2325     {
2326         super.safeTransferFrom(from, to, tokenId, data);
2327     }
2328 
2329     function NemsUSDPrice() external view returns (uint256) {
2330         return _NemsUSDPrice;
2331     }
2332 
2333 }