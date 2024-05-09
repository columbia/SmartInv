1 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 
32 // File: operator-filter-registry/src/OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.13;
36 
37 
38 abstract contract OperatorFilterer {
39     error OperatorNotAllowed(address operator);
40 
41     IOperatorFilterRegistry constant operatorFilterRegistry =
42         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
43 
44     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
45         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
46         // will not revert, but the contract will need to be registered with the registry once it is deployed in
47         // order for the modifier to filter addresses.
48         if (address(operatorFilterRegistry).code.length > 0) {
49             if (subscribe) {
50                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
51             } else {
52                 if (subscriptionOrRegistrantToCopy != address(0)) {
53                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
54                 } else {
55                     operatorFilterRegistry.register(address(this));
56                 }
57             }
58         }
59     }
60 
61     modifier onlyAllowedOperator(address from) virtual {
62         // Check registry code length to facilitate testing in environments without a deployed registry.
63         if (address(operatorFilterRegistry).code.length > 0) {
64             // Allow spending tokens from addresses with balance
65             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
66             // from an EOA.
67             if (from == msg.sender) {
68                 _;
69                 return;
70             }
71             if (
72                 !(
73                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
74                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
75                 )
76             ) {
77                 revert OperatorNotAllowed(msg.sender);
78             }
79         }
80         _;
81     }
82 }
83 
84 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
85 
86 
87 pragma solidity ^0.8.13;
88 
89 
90 abstract contract DefaultOperatorFilterer is OperatorFilterer {
91     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
92 
93     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
94 }
95 
96 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
97 
98 
99 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev These functions deal with verification of Merkle Tree proofs.
105  *
106  * The tree and the proofs can be generated using our
107  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
108  * You will find a quickstart guide in the readme.
109  *
110  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
111  * hashing, or use a hash function other than keccak256 for hashing leaves.
112  * This is because the concatenation of a sorted pair of internal nodes in
113  * the merkle tree could be reinterpreted as a leaf value.
114  * OpenZeppelin's JavaScript library generates merkle trees that are safe
115  * against this attack out of the box.
116  */
117 library MerkleProof {
118     /**
119      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
120      * defined by `root`. For this, a `proof` must be provided, containing
121      * sibling hashes on the branch from the leaf to the root of the tree. Each
122      * pair of leaves and each pair of pre-images are assumed to be sorted.
123      */
124     function verify(
125         bytes32[] memory proof,
126         bytes32 root,
127         bytes32 leaf
128     ) internal pure returns (bool) {
129         return processProof(proof, leaf) == root;
130     }
131 
132     /**
133      * @dev Calldata version of {verify}
134      *
135      * _Available since v4.7._
136      */
137     function verifyCalldata(
138         bytes32[] calldata proof,
139         bytes32 root,
140         bytes32 leaf
141     ) internal pure returns (bool) {
142         return processProofCalldata(proof, leaf) == root;
143     }
144 
145     /**
146      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
147      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
148      * hash matches the root of the tree. When processing the proof, the pairs
149      * of leafs & pre-images are assumed to be sorted.
150      *
151      * _Available since v4.4._
152      */
153     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
154         bytes32 computedHash = leaf;
155         for (uint256 i = 0; i < proof.length; i++) {
156             computedHash = _hashPair(computedHash, proof[i]);
157         }
158         return computedHash;
159     }
160 
161     /**
162      * @dev Calldata version of {processProof}
163      *
164      * _Available since v4.7._
165      */
166     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
167         bytes32 computedHash = leaf;
168         for (uint256 i = 0; i < proof.length; i++) {
169             computedHash = _hashPair(computedHash, proof[i]);
170         }
171         return computedHash;
172     }
173 
174     /**
175      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
176      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
177      *
178      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
179      *
180      * _Available since v4.7._
181      */
182     function multiProofVerify(
183         bytes32[] memory proof,
184         bool[] memory proofFlags,
185         bytes32 root,
186         bytes32[] memory leaves
187     ) internal pure returns (bool) {
188         return processMultiProof(proof, proofFlags, leaves) == root;
189     }
190 
191     /**
192      * @dev Calldata version of {multiProofVerify}
193      *
194      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
195      *
196      * _Available since v4.7._
197      */
198     function multiProofVerifyCalldata(
199         bytes32[] calldata proof,
200         bool[] calldata proofFlags,
201         bytes32 root,
202         bytes32[] memory leaves
203     ) internal pure returns (bool) {
204         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
205     }
206 
207     /**
208      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
209      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
210      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
211      * respectively.
212      *
213      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
214      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
215      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
216      *
217      * _Available since v4.7._
218      */
219     function processMultiProof(
220         bytes32[] memory proof,
221         bool[] memory proofFlags,
222         bytes32[] memory leaves
223     ) internal pure returns (bytes32 merkleRoot) {
224         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
225         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
226         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
227         // the merkle tree.
228         uint256 leavesLen = leaves.length;
229         uint256 totalHashes = proofFlags.length;
230 
231         // Check proof validity.
232         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
233 
234         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
235         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
236         bytes32[] memory hashes = new bytes32[](totalHashes);
237         uint256 leafPos = 0;
238         uint256 hashPos = 0;
239         uint256 proofPos = 0;
240         // At each step, we compute the next hash using two values:
241         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
242         //   get the next hash.
243         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
244         //   `proof` array.
245         for (uint256 i = 0; i < totalHashes; i++) {
246             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
247             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
248             hashes[i] = _hashPair(a, b);
249         }
250 
251         if (totalHashes > 0) {
252             return hashes[totalHashes - 1];
253         } else if (leavesLen > 0) {
254             return leaves[0];
255         } else {
256             return proof[0];
257         }
258     }
259 
260     /**
261      * @dev Calldata version of {processMultiProof}.
262      *
263      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
264      *
265      * _Available since v4.7._
266      */
267     function processMultiProofCalldata(
268         bytes32[] calldata proof,
269         bool[] calldata proofFlags,
270         bytes32[] memory leaves
271     ) internal pure returns (bytes32 merkleRoot) {
272         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
273         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
274         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
275         // the merkle tree.
276         uint256 leavesLen = leaves.length;
277         uint256 totalHashes = proofFlags.length;
278 
279         // Check proof validity.
280         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
281 
282         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
283         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
284         bytes32[] memory hashes = new bytes32[](totalHashes);
285         uint256 leafPos = 0;
286         uint256 hashPos = 0;
287         uint256 proofPos = 0;
288         // At each step, we compute the next hash using two values:
289         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
290         //   get the next hash.
291         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
292         //   `proof` array.
293         for (uint256 i = 0; i < totalHashes; i++) {
294             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
295             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
296             hashes[i] = _hashPair(a, b);
297         }
298 
299         if (totalHashes > 0) {
300             return hashes[totalHashes - 1];
301         } else if (leavesLen > 0) {
302             return leaves[0];
303         } else {
304             return proof[0];
305         }
306     }
307 
308     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
309         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
310     }
311 
312     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
313         /// @solidity memory-safe-assembly
314         assembly {
315             mstore(0x00, a)
316             mstore(0x20, b)
317             value := keccak256(0x00, 0x40)
318         }
319     }
320 }
321 
322 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
323 
324 
325 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Contract module that helps prevent reentrant calls to a function.
331  *
332  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
333  * available, which can be applied to functions to make sure there are no nested
334  * (reentrant) calls to them.
335  *
336  * Note that because there is a single `nonReentrant` guard, functions marked as
337  * `nonReentrant` may not call one another. This can be worked around by making
338  * those functions `private`, and then adding `external` `nonReentrant` entry
339  * points to them.
340  *
341  * TIP: If you would like to learn more about reentrancy and alternative ways
342  * to protect against it, check out our blog post
343  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
344  */
345 abstract contract ReentrancyGuard {
346     // Booleans are more expensive than uint256 or any type that takes up a full
347     // word because each write operation emits an extra SLOAD to first read the
348     // slot's contents, replace the bits taken up by the boolean, and then write
349     // back. This is the compiler's defense against contract upgrades and
350     // pointer aliasing, and it cannot be disabled.
351 
352     // The values being non-zero value makes deployment a bit more expensive,
353     // but in exchange the refund on every call to nonReentrant will be lower in
354     // amount. Since refunds are capped to a percentage of the total
355     // transaction's gas, it is best to keep them low in cases like this one, to
356     // increase the likelihood of the full refund coming into effect.
357     uint256 private constant _NOT_ENTERED = 1;
358     uint256 private constant _ENTERED = 2;
359 
360     uint256 private _status;
361 
362     constructor() {
363         _status = _NOT_ENTERED;
364     }
365 
366     /**
367      * @dev Prevents a contract from calling itself, directly or indirectly.
368      * Calling a `nonReentrant` function from another `nonReentrant`
369      * function is not supported. It is possible to prevent this from happening
370      * by making the `nonReentrant` function external, and making it call a
371      * `private` function that does the actual work.
372      */
373     modifier nonReentrant() {
374         _nonReentrantBefore();
375         _;
376         _nonReentrantAfter();
377     }
378 
379     function _nonReentrantBefore() private {
380         // On the first call to nonReentrant, _status will be _NOT_ENTERED
381         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
382 
383         // Any calls to nonReentrant after this point will fail
384         _status = _ENTERED;
385     }
386 
387     function _nonReentrantAfter() private {
388         // By storing the original value once again, a refund is triggered (see
389         // https://eips.ethereum.org/EIPS/eip-2200)
390         _status = _NOT_ENTERED;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/utils/Address.sol
395 
396 
397 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
398 
399 pragma solidity ^0.8.1;
400 
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * [IMPORTANT]
409      * ====
410      * It is unsafe to assume that an address for which this function returns
411      * false is an externally-owned account (EOA) and not a contract.
412      *
413      * Among others, `isContract` will return false for the following
414      * types of addresses:
415      *
416      *  - an externally-owned account
417      *  - a contract in construction
418      *  - an address where a contract will be created
419      *  - an address where a contract lived, but was destroyed
420      * ====
421      *
422      * [IMPORTANT]
423      * ====
424      * You shouldn't rely on `isContract` to protect against flash loan attacks!
425      *
426      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
427      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
428      * constructor.
429      * ====
430      */
431     function isContract(address account) internal view returns (bool) {
432         // This method relies on extcodesize/address.code.length, which returns 0
433         // for contracts in construction, since the code is only stored at the end
434         // of the constructor execution.
435 
436         return account.code.length > 0;
437     }
438 
439     /**
440      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
441      * `recipient`, forwarding all available gas and reverting on errors.
442      *
443      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
444      * of certain opcodes, possibly making contracts go over the 2300 gas limit
445      * imposed by `transfer`, making them unable to receive funds via
446      * `transfer`. {sendValue} removes this limitation.
447      *
448      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
449      *
450      * IMPORTANT: because control is transferred to `recipient`, care must be
451      * taken to not create reentrancy vulnerabilities. Consider using
452      * {ReentrancyGuard} or the
453      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
454      */
455     function sendValue(address payable recipient, uint256 amount) internal {
456         require(address(this).balance >= amount, "Address: insufficient balance");
457 
458         (bool success, ) = recipient.call{value: amount}("");
459         require(success, "Address: unable to send value, recipient may have reverted");
460     }
461 
462     /**
463      * @dev Performs a Solidity function call using a low level `call`. A
464      * plain `call` is an unsafe replacement for a function call: use this
465      * function instead.
466      *
467      * If `target` reverts with a revert reason, it is bubbled up by this
468      * function (like regular Solidity function calls).
469      *
470      * Returns the raw returned data. To convert to the expected return value,
471      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
472      *
473      * Requirements:
474      *
475      * - `target` must be a contract.
476      * - calling `target` with `data` must not revert.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
486      * `errorMessage` as a fallback revert reason when `target` reverts.
487      *
488      * _Available since v3.1._
489      */
490     function functionCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         return functionCallWithValue(target, data, 0, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but also transferring `value` wei to `target`.
501      *
502      * Requirements:
503      *
504      * - the calling contract must have an ETH balance of at least `value`.
505      * - the called Solidity function must be `payable`.
506      *
507      * _Available since v3.1._
508      */
509     function functionCallWithValue(
510         address target,
511         bytes memory data,
512         uint256 value
513     ) internal returns (bytes memory) {
514         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
519      * with `errorMessage` as a fallback revert reason when `target` reverts.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(
524         address target,
525         bytes memory data,
526         uint256 value,
527         string memory errorMessage
528     ) internal returns (bytes memory) {
529         require(address(this).balance >= value, "Address: insufficient balance for call");
530         (bool success, bytes memory returndata) = target.call{value: value}(data);
531         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         (bool success, bytes memory returndata) = target.staticcall(data);
556         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
561      * but performing a delegate call.
562      *
563      * _Available since v3.4._
564      */
565     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
566         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
571      * but performing a delegate call.
572      *
573      * _Available since v3.4._
574      */
575     function functionDelegateCall(
576         address target,
577         bytes memory data,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         (bool success, bytes memory returndata) = target.delegatecall(data);
581         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
582     }
583 
584     /**
585      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
586      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
587      *
588      * _Available since v4.8._
589      */
590     function verifyCallResultFromTarget(
591         address target,
592         bool success,
593         bytes memory returndata,
594         string memory errorMessage
595     ) internal view returns (bytes memory) {
596         if (success) {
597             if (returndata.length == 0) {
598                 // only check isContract if the call was successful and the return data is empty
599                 // otherwise we already know that it was a contract
600                 require(isContract(target), "Address: call to non-contract");
601             }
602             return returndata;
603         } else {
604             _revert(returndata, errorMessage);
605         }
606     }
607 
608     /**
609      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
610      * revert reason or using the provided one.
611      *
612      * _Available since v4.3._
613      */
614     function verifyCallResult(
615         bool success,
616         bytes memory returndata,
617         string memory errorMessage
618     ) internal pure returns (bytes memory) {
619         if (success) {
620             return returndata;
621         } else {
622             _revert(returndata, errorMessage);
623         }
624     }
625 
626     function _revert(bytes memory returndata, string memory errorMessage) private pure {
627         // Look for revert reason and bubble it up if present
628         if (returndata.length > 0) {
629             // The easiest way to bubble the revert reason is using memory via assembly
630             /// @solidity memory-safe-assembly
631             assembly {
632                 let returndata_size := mload(returndata)
633                 revert(add(32, returndata), returndata_size)
634             }
635         } else {
636             revert(errorMessage);
637         }
638     }
639 }
640 
641 // File: @openzeppelin/contracts/utils/math/Math.sol
642 
643 
644 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
645 
646 pragma solidity ^0.8.0;
647 
648 /**
649  * @dev Standard math utilities missing in the Solidity language.
650  */
651 library Math {
652     enum Rounding {
653         Down, // Toward negative infinity
654         Up, // Toward infinity
655         Zero // Toward zero
656     }
657 
658     /**
659      * @dev Returns the largest of two numbers.
660      */
661     function max(uint256 a, uint256 b) internal pure returns (uint256) {
662         return a > b ? a : b;
663     }
664 
665     /**
666      * @dev Returns the smallest of two numbers.
667      */
668     function min(uint256 a, uint256 b) internal pure returns (uint256) {
669         return a < b ? a : b;
670     }
671 
672     /**
673      * @dev Returns the average of two numbers. The result is rounded towards
674      * zero.
675      */
676     function average(uint256 a, uint256 b) internal pure returns (uint256) {
677         // (a + b) / 2 can overflow.
678         return (a & b) + (a ^ b) / 2;
679     }
680 
681     /**
682      * @dev Returns the ceiling of the division of two numbers.
683      *
684      * This differs from standard division with `/` in that it rounds up instead
685      * of rounding down.
686      */
687     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
688         // (a + b - 1) / b can overflow on addition, so we distribute.
689         return a == 0 ? 0 : (a - 1) / b + 1;
690     }
691 
692     /**
693      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
694      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
695      * with further edits by Uniswap Labs also under MIT license.
696      */
697     function mulDiv(
698         uint256 x,
699         uint256 y,
700         uint256 denominator
701     ) internal pure returns (uint256 result) {
702         unchecked {
703             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
704             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
705             // variables such that product = prod1 * 2^256 + prod0.
706             uint256 prod0; // Least significant 256 bits of the product
707             uint256 prod1; // Most significant 256 bits of the product
708             assembly {
709                 let mm := mulmod(x, y, not(0))
710                 prod0 := mul(x, y)
711                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
712             }
713 
714             // Handle non-overflow cases, 256 by 256 division.
715             if (prod1 == 0) {
716                 return prod0 / denominator;
717             }
718 
719             // Make sure the result is less than 2^256. Also prevents denominator == 0.
720             require(denominator > prod1);
721 
722             ///////////////////////////////////////////////
723             // 512 by 256 division.
724             ///////////////////////////////////////////////
725 
726             // Make division exact by subtracting the remainder from [prod1 prod0].
727             uint256 remainder;
728             assembly {
729                 // Compute remainder using mulmod.
730                 remainder := mulmod(x, y, denominator)
731 
732                 // Subtract 256 bit number from 512 bit number.
733                 prod1 := sub(prod1, gt(remainder, prod0))
734                 prod0 := sub(prod0, remainder)
735             }
736 
737             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
738             // See https://cs.stackexchange.com/q/138556/92363.
739 
740             // Does not overflow because the denominator cannot be zero at this stage in the function.
741             uint256 twos = denominator & (~denominator + 1);
742             assembly {
743                 // Divide denominator by twos.
744                 denominator := div(denominator, twos)
745 
746                 // Divide [prod1 prod0] by twos.
747                 prod0 := div(prod0, twos)
748 
749                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
750                 twos := add(div(sub(0, twos), twos), 1)
751             }
752 
753             // Shift in bits from prod1 into prod0.
754             prod0 |= prod1 * twos;
755 
756             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
757             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
758             // four bits. That is, denominator * inv = 1 mod 2^4.
759             uint256 inverse = (3 * denominator) ^ 2;
760 
761             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
762             // in modular arithmetic, doubling the correct bits in each step.
763             inverse *= 2 - denominator * inverse; // inverse mod 2^8
764             inverse *= 2 - denominator * inverse; // inverse mod 2^16
765             inverse *= 2 - denominator * inverse; // inverse mod 2^32
766             inverse *= 2 - denominator * inverse; // inverse mod 2^64
767             inverse *= 2 - denominator * inverse; // inverse mod 2^128
768             inverse *= 2 - denominator * inverse; // inverse mod 2^256
769 
770             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
771             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
772             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
773             // is no longer required.
774             result = prod0 * inverse;
775             return result;
776         }
777     }
778 
779     /**
780      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
781      */
782     function mulDiv(
783         uint256 x,
784         uint256 y,
785         uint256 denominator,
786         Rounding rounding
787     ) internal pure returns (uint256) {
788         uint256 result = mulDiv(x, y, denominator);
789         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
790             result += 1;
791         }
792         return result;
793     }
794 
795     /**
796      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
797      *
798      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
799      */
800     function sqrt(uint256 a) internal pure returns (uint256) {
801         if (a == 0) {
802             return 0;
803         }
804 
805         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
806         //
807         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
808         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
809         //
810         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
811         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
812         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
813         //
814         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
815         uint256 result = 1 << (log2(a) >> 1);
816 
817         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
818         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
819         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
820         // into the expected uint128 result.
821         unchecked {
822             result = (result + a / result) >> 1;
823             result = (result + a / result) >> 1;
824             result = (result + a / result) >> 1;
825             result = (result + a / result) >> 1;
826             result = (result + a / result) >> 1;
827             result = (result + a / result) >> 1;
828             result = (result + a / result) >> 1;
829             return min(result, a / result);
830         }
831     }
832 
833     /**
834      * @notice Calculates sqrt(a), following the selected rounding direction.
835      */
836     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
837         unchecked {
838             uint256 result = sqrt(a);
839             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
840         }
841     }
842 
843     /**
844      * @dev Return the log in base 2, rounded down, of a positive value.
845      * Returns 0 if given 0.
846      */
847     function log2(uint256 value) internal pure returns (uint256) {
848         uint256 result = 0;
849         unchecked {
850             if (value >> 128 > 0) {
851                 value >>= 128;
852                 result += 128;
853             }
854             if (value >> 64 > 0) {
855                 value >>= 64;
856                 result += 64;
857             }
858             if (value >> 32 > 0) {
859                 value >>= 32;
860                 result += 32;
861             }
862             if (value >> 16 > 0) {
863                 value >>= 16;
864                 result += 16;
865             }
866             if (value >> 8 > 0) {
867                 value >>= 8;
868                 result += 8;
869             }
870             if (value >> 4 > 0) {
871                 value >>= 4;
872                 result += 4;
873             }
874             if (value >> 2 > 0) {
875                 value >>= 2;
876                 result += 2;
877             }
878             if (value >> 1 > 0) {
879                 result += 1;
880             }
881         }
882         return result;
883     }
884 
885     /**
886      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
887      * Returns 0 if given 0.
888      */
889     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
890         unchecked {
891             uint256 result = log2(value);
892             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
893         }
894     }
895 
896     /**
897      * @dev Return the log in base 10, rounded down, of a positive value.
898      * Returns 0 if given 0.
899      */
900     function log10(uint256 value) internal pure returns (uint256) {
901         uint256 result = 0;
902         unchecked {
903             if (value >= 10**64) {
904                 value /= 10**64;
905                 result += 64;
906             }
907             if (value >= 10**32) {
908                 value /= 10**32;
909                 result += 32;
910             }
911             if (value >= 10**16) {
912                 value /= 10**16;
913                 result += 16;
914             }
915             if (value >= 10**8) {
916                 value /= 10**8;
917                 result += 8;
918             }
919             if (value >= 10**4) {
920                 value /= 10**4;
921                 result += 4;
922             }
923             if (value >= 10**2) {
924                 value /= 10**2;
925                 result += 2;
926             }
927             if (value >= 10**1) {
928                 result += 1;
929             }
930         }
931         return result;
932     }
933 
934     /**
935      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
936      * Returns 0 if given 0.
937      */
938     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
939         unchecked {
940             uint256 result = log10(value);
941             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
942         }
943     }
944 
945     /**
946      * @dev Return the log in base 256, rounded down, of a positive value.
947      * Returns 0 if given 0.
948      *
949      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
950      */
951     function log256(uint256 value) internal pure returns (uint256) {
952         uint256 result = 0;
953         unchecked {
954             if (value >> 128 > 0) {
955                 value >>= 128;
956                 result += 16;
957             }
958             if (value >> 64 > 0) {
959                 value >>= 64;
960                 result += 8;
961             }
962             if (value >> 32 > 0) {
963                 value >>= 32;
964                 result += 4;
965             }
966             if (value >> 16 > 0) {
967                 value >>= 16;
968                 result += 2;
969             }
970             if (value >> 8 > 0) {
971                 result += 1;
972             }
973         }
974         return result;
975     }
976 
977     /**
978      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
979      * Returns 0 if given 0.
980      */
981     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
982         unchecked {
983             uint256 result = log256(value);
984             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
985         }
986     }
987 }
988 
989 // File: @openzeppelin/contracts/utils/Strings.sol
990 
991 
992 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
993 
994 pragma solidity ^0.8.0;
995 
996 
997 /**
998  * @dev String operations.
999  */
1000 library Strings {
1001     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1002     uint8 private constant _ADDRESS_LENGTH = 20;
1003 
1004     /**
1005      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1006      */
1007     function toString(uint256 value) internal pure returns (string memory) {
1008         unchecked {
1009             uint256 length = Math.log10(value) + 1;
1010             string memory buffer = new string(length);
1011             uint256 ptr;
1012             /// @solidity memory-safe-assembly
1013             assembly {
1014                 ptr := add(buffer, add(32, length))
1015             }
1016             while (true) {
1017                 ptr--;
1018                 /// @solidity memory-safe-assembly
1019                 assembly {
1020                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1021                 }
1022                 value /= 10;
1023                 if (value == 0) break;
1024             }
1025             return buffer;
1026         }
1027     }
1028 
1029     /**
1030      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1031      */
1032     function toHexString(uint256 value) internal pure returns (string memory) {
1033         unchecked {
1034             return toHexString(value, Math.log256(value) + 1);
1035         }
1036     }
1037 
1038     /**
1039      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1040      */
1041     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1042         bytes memory buffer = new bytes(2 * length + 2);
1043         buffer[0] = "0";
1044         buffer[1] = "x";
1045         for (uint256 i = 2 * length + 1; i > 1; --i) {
1046             buffer[i] = _SYMBOLS[value & 0xf];
1047             value >>= 4;
1048         }
1049         require(value == 0, "Strings: hex length insufficient");
1050         return string(buffer);
1051     }
1052 
1053     /**
1054      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1055      */
1056     function toHexString(address addr) internal pure returns (string memory) {
1057         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1058     }
1059 }
1060 
1061 // File: @openzeppelin/contracts/utils/Context.sol
1062 
1063 
1064 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1065 
1066 pragma solidity ^0.8.0;
1067 
1068 /**
1069  * @dev Provides information about the current execution context, including the
1070  * sender of the transaction and its data. While these are generally available
1071  * via msg.sender and msg.data, they should not be accessed in such a direct
1072  * manner, since when dealing with meta-transactions the account sending and
1073  * paying for execution may not be the actual sender (as far as an application
1074  * is concerned).
1075  *
1076  * This contract is only required for intermediate, library-like contracts.
1077  */
1078 abstract contract Context {
1079     function _msgSender() internal view virtual returns (address) {
1080         return msg.sender;
1081     }
1082 
1083     function _msgData() internal view virtual returns (bytes calldata) {
1084         return msg.data;
1085     }
1086 }
1087 
1088 // File: @openzeppelin/contracts/access/Ownable.sol
1089 
1090 
1091 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 
1096 /**
1097  * @dev Contract module which provides a basic access control mechanism, where
1098  * there is an account (an owner) that can be granted exclusive access to
1099  * specific functions.
1100  *
1101  * By default, the owner account will be the one that deploys the contract. This
1102  * can later be changed with {transferOwnership}.
1103  *
1104  * This module is used through inheritance. It will make available the modifier
1105  * `onlyOwner`, which can be applied to your functions to restrict their use to
1106  * the owner.
1107  */
1108 abstract contract Ownable is Context {
1109     address private _owner;
1110 
1111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1112 
1113     /**
1114      * @dev Initializes the contract setting the deployer as the initial owner.
1115      */
1116     constructor() {
1117         _transferOwnership(_msgSender());
1118     }
1119 
1120     /**
1121      * @dev Throws if called by any account other than the owner.
1122      */
1123     modifier onlyOwner() {
1124         _checkOwner();
1125         _;
1126     }
1127 
1128     /**
1129      * @dev Returns the address of the current owner.
1130      */
1131     function owner() public view virtual returns (address) {
1132         return _owner;
1133     }
1134 
1135     /**
1136      * @dev Throws if the sender is not the owner.
1137      */
1138     function _checkOwner() internal view virtual {
1139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1140     }
1141 
1142     /**
1143      * @dev Leaves the contract without owner. It will not be possible to call
1144      * `onlyOwner` functions anymore. Can only be called by the current owner.
1145      *
1146      * NOTE: Renouncing ownership will leave the contract without an owner,
1147      * thereby removing any functionality that is only available to the owner.
1148      */
1149     function renounceOwnership() public virtual onlyOwner {
1150         _transferOwnership(address(0));
1151     }
1152 
1153     /**
1154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1155      * Can only be called by the current owner.
1156      */
1157     function transferOwnership(address newOwner) public virtual onlyOwner {
1158         require(newOwner != address(0), "Ownable: new owner is the zero address");
1159         _transferOwnership(newOwner);
1160     }
1161 
1162     /**
1163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1164      * Internal function without access restriction.
1165      */
1166     function _transferOwnership(address newOwner) internal virtual {
1167         address oldOwner = _owner;
1168         _owner = newOwner;
1169         emit OwnershipTransferred(oldOwner, newOwner);
1170     }
1171 }
1172 
1173 // File: erc721a/contracts/IERC721A.sol
1174 
1175 
1176 // ERC721A Contracts v4.2.3
1177 // Creator: Chiru Labs
1178 
1179 pragma solidity ^0.8.4;
1180 
1181 /**
1182  * @dev Interface of ERC721A.
1183  */
1184 interface IERC721A {
1185     /**
1186      * The caller must own the token or be an approved operator.
1187      */
1188     error ApprovalCallerNotOwnerNorApproved();
1189 
1190     /**
1191      * The token does not exist.
1192      */
1193     error ApprovalQueryForNonexistentToken();
1194 
1195     /**
1196      * Cannot query the balance for the zero address.
1197      */
1198     error BalanceQueryForZeroAddress();
1199 
1200     /**
1201      * Cannot mint to the zero address.
1202      */
1203     error MintToZeroAddress();
1204 
1205     /**
1206      * The quantity of tokens minted must be more than zero.
1207      */
1208     error MintZeroQuantity();
1209 
1210     /**
1211      * The token does not exist.
1212      */
1213     error OwnerQueryForNonexistentToken();
1214 
1215     /**
1216      * The caller must own the token or be an approved operator.
1217      */
1218     error TransferCallerNotOwnerNorApproved();
1219 
1220     /**
1221      * The token must be owned by `from`.
1222      */
1223     error TransferFromIncorrectOwner();
1224 
1225     /**
1226      * Cannot safely transfer to a contract that does not implement the
1227      * ERC721Receiver interface.
1228      */
1229     error TransferToNonERC721ReceiverImplementer();
1230 
1231     /**
1232      * Cannot transfer to the zero address.
1233      */
1234     error TransferToZeroAddress();
1235 
1236     /**
1237      * The token does not exist.
1238      */
1239     error URIQueryForNonexistentToken();
1240 
1241     /**
1242      * The `quantity` minted with ERC2309 exceeds the safety limit.
1243      */
1244     error MintERC2309QuantityExceedsLimit();
1245 
1246     /**
1247      * The `extraData` cannot be set on an unintialized ownership slot.
1248      */
1249     error OwnershipNotInitializedForExtraData();
1250 
1251     // =============================================================
1252     //                            STRUCTS
1253     // =============================================================
1254 
1255     struct TokenOwnership {
1256         // The address of the owner.
1257         address addr;
1258         // Stores the start time of ownership with minimal overhead for tokenomics.
1259         uint64 startTimestamp;
1260         // Whether the token has been burned.
1261         bool burned;
1262         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1263         uint24 extraData;
1264     }
1265 
1266     // =============================================================
1267     //                         TOKEN COUNTERS
1268     // =============================================================
1269 
1270     /**
1271      * @dev Returns the total number of tokens in existence.
1272      * Burned tokens will reduce the count.
1273      * To get the total number of tokens minted, please see {_totalMinted}.
1274      */
1275     function totalSupply() external view returns (uint256);
1276 
1277     // =============================================================
1278     //                            IERC165
1279     // =============================================================
1280 
1281     /**
1282      * @dev Returns true if this contract implements the interface defined by
1283      * `interfaceId`. See the corresponding
1284      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1285      * to learn more about how these ids are created.
1286      *
1287      * This function call must use less than 30000 gas.
1288      */
1289     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1290 
1291     // =============================================================
1292     //                            IERC721
1293     // =============================================================
1294 
1295     /**
1296      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1297      */
1298     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1299 
1300     /**
1301      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1302      */
1303     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1304 
1305     /**
1306      * @dev Emitted when `owner` enables or disables
1307      * (`approved`) `operator` to manage all of its assets.
1308      */
1309     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1310 
1311     /**
1312      * @dev Returns the number of tokens in `owner`'s account.
1313      */
1314     function balanceOf(address owner) external view returns (uint256 balance);
1315 
1316     /**
1317      * @dev Returns the owner of the `tokenId` token.
1318      *
1319      * Requirements:
1320      *
1321      * - `tokenId` must exist.
1322      */
1323     function ownerOf(uint256 tokenId) external view returns (address owner);
1324 
1325     /**
1326      * @dev Safely transfers `tokenId` token from `from` to `to`,
1327      * checking first that contract recipients are aware of the ERC721 protocol
1328      * to prevent tokens from being forever locked.
1329      *
1330      * Requirements:
1331      *
1332      * - `from` cannot be the zero address.
1333      * - `to` cannot be the zero address.
1334      * - `tokenId` token must exist and be owned by `from`.
1335      * - If the caller is not `from`, it must be have been allowed to move
1336      * this token by either {approve} or {setApprovalForAll}.
1337      * - If `to` refers to a smart contract, it must implement
1338      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1339      *
1340      * Emits a {Transfer} event.
1341      */
1342     function safeTransferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId,
1346         bytes calldata data
1347     ) external payable;
1348 
1349     /**
1350      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1351      */
1352     function safeTransferFrom(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) external payable;
1357 
1358     /**
1359      * @dev Transfers `tokenId` from `from` to `to`.
1360      *
1361      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1362      * whenever possible.
1363      *
1364      * Requirements:
1365      *
1366      * - `from` cannot be the zero address.
1367      * - `to` cannot be the zero address.
1368      * - `tokenId` token must be owned by `from`.
1369      * - If the caller is not `from`, it must be approved to move this token
1370      * by either {approve} or {setApprovalForAll}.
1371      *
1372      * Emits a {Transfer} event.
1373      */
1374     function transferFrom(
1375         address from,
1376         address to,
1377         uint256 tokenId
1378     ) external payable;
1379 
1380     /**
1381      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1382      * The approval is cleared when the token is transferred.
1383      *
1384      * Only a single account can be approved at a time, so approving the
1385      * zero address clears previous approvals.
1386      *
1387      * Requirements:
1388      *
1389      * - The caller must own the token or be an approved operator.
1390      * - `tokenId` must exist.
1391      *
1392      * Emits an {Approval} event.
1393      */
1394     function approve(address to, uint256 tokenId) external payable;
1395 
1396     /**
1397      * @dev Approve or remove `operator` as an operator for the caller.
1398      * Operators can call {transferFrom} or {safeTransferFrom}
1399      * for any token owned by the caller.
1400      *
1401      * Requirements:
1402      *
1403      * - The `operator` cannot be the caller.
1404      *
1405      * Emits an {ApprovalForAll} event.
1406      */
1407     function setApprovalForAll(address operator, bool _approved) external;
1408 
1409     /**
1410      * @dev Returns the account approved for `tokenId` token.
1411      *
1412      * Requirements:
1413      *
1414      * - `tokenId` must exist.
1415      */
1416     function getApproved(uint256 tokenId) external view returns (address operator);
1417 
1418     /**
1419      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1420      *
1421      * See {setApprovalForAll}.
1422      */
1423     function isApprovedForAll(address owner, address operator) external view returns (bool);
1424 
1425     // =============================================================
1426     //                        IERC721Metadata
1427     // =============================================================
1428 
1429     /**
1430      * @dev Returns the token collection name.
1431      */
1432     function name() external view returns (string memory);
1433 
1434     /**
1435      * @dev Returns the token collection symbol.
1436      */
1437     function symbol() external view returns (string memory);
1438 
1439     /**
1440      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1441      */
1442     function tokenURI(uint256 tokenId) external view returns (string memory);
1443 
1444     // =============================================================
1445     //                           IERC2309
1446     // =============================================================
1447 
1448     /**
1449      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1450      * (inclusive) is transferred from `from` to `to`, as defined in the
1451      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1452      *
1453      * See {_mintERC2309} for more details.
1454      */
1455     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1456 }
1457 
1458 // File: erc721a/contracts/ERC721A.sol
1459 
1460 
1461 // ERC721A Contracts v4.2.3
1462 // Creator: Chiru Labs
1463 
1464 pragma solidity ^0.8.4;
1465 
1466 
1467 /**
1468  * @dev Interface of ERC721 token receiver.
1469  */
1470 interface ERC721A__IERC721Receiver {
1471     function onERC721Received(
1472         address operator,
1473         address from,
1474         uint256 tokenId,
1475         bytes calldata data
1476     ) external returns (bytes4);
1477 }
1478 
1479 /**
1480  * @title ERC721A
1481  *
1482  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1483  * Non-Fungible Token Standard, including the Metadata extension.
1484  * Optimized for lower gas during batch mints.
1485  *
1486  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1487  * starting from `_startTokenId()`.
1488  *
1489  * Assumptions:
1490  *
1491  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1492  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1493  */
1494 contract ERC721A is IERC721A {
1495     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1496     struct TokenApprovalRef {
1497         address value;
1498     }
1499 
1500     // =============================================================
1501     //                           CONSTANTS
1502     // =============================================================
1503 
1504     // Mask of an entry in packed address data.
1505     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1506 
1507     // The bit position of `numberMinted` in packed address data.
1508     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1509 
1510     // The bit position of `numberBurned` in packed address data.
1511     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1512 
1513     // The bit position of `aux` in packed address data.
1514     uint256 private constant _BITPOS_AUX = 192;
1515 
1516     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1517     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1518 
1519     // The bit position of `startTimestamp` in packed ownership.
1520     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1521 
1522     // The bit mask of the `burned` bit in packed ownership.
1523     uint256 private constant _BITMASK_BURNED = 1 << 224;
1524 
1525     // The bit position of the `nextInitialized` bit in packed ownership.
1526     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1527 
1528     // The bit mask of the `nextInitialized` bit in packed ownership.
1529     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1530 
1531     // The bit position of `extraData` in packed ownership.
1532     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1533 
1534     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1535     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1536 
1537     // The mask of the lower 160 bits for addresses.
1538     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1539 
1540     // The maximum `quantity` that can be minted with {_mintERC2309}.
1541     // This limit is to prevent overflows on the address data entries.
1542     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1543     // is required to cause an overflow, which is unrealistic.
1544     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1545 
1546     // The `Transfer` event signature is given by:
1547     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1548     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1549         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1550 
1551     // =============================================================
1552     //                            STORAGE
1553     // =============================================================
1554 
1555     // The next token ID to be minted.
1556     uint256 private _currentIndex;
1557 
1558     // The number of tokens burned.
1559     uint256 private _burnCounter;
1560 
1561     // Token name
1562     string private _name;
1563 
1564     // Token symbol
1565     string private _symbol;
1566 
1567     // Mapping from token ID to ownership details
1568     // An empty struct value does not necessarily mean the token is unowned.
1569     // See {_packedOwnershipOf} implementation for details.
1570     //
1571     // Bits Layout:
1572     // - [0..159]   `addr`
1573     // - [160..223] `startTimestamp`
1574     // - [224]      `burned`
1575     // - [225]      `nextInitialized`
1576     // - [232..255] `extraData`
1577     mapping(uint256 => uint256) private _packedOwnerships;
1578 
1579     // Mapping owner address to address data.
1580     //
1581     // Bits Layout:
1582     // - [0..63]    `balance`
1583     // - [64..127]  `numberMinted`
1584     // - [128..191] `numberBurned`
1585     // - [192..255] `aux`
1586     mapping(address => uint256) private _packedAddressData;
1587 
1588     // Mapping from token ID to approved address.
1589     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1590 
1591     // Mapping from owner to operator approvals
1592     mapping(address => mapping(address => bool)) private _operatorApprovals;
1593 
1594     // =============================================================
1595     //                          CONSTRUCTOR
1596     // =============================================================
1597 
1598     constructor(string memory name_, string memory symbol_) {
1599         _name = name_;
1600         _symbol = symbol_;
1601         _currentIndex = _startTokenId();
1602     }
1603 
1604     // =============================================================
1605     //                   TOKEN COUNTING OPERATIONS
1606     // =============================================================
1607 
1608     /**
1609      * @dev Returns the starting token ID.
1610      * To change the starting token ID, please override this function.
1611      */
1612     function _startTokenId() internal view virtual returns (uint256) {
1613         return 0;
1614     }
1615 
1616     /**
1617      * @dev Returns the next token ID to be minted.
1618      */
1619     function _nextTokenId() internal view virtual returns (uint256) {
1620         return _currentIndex;
1621     }
1622 
1623     /**
1624      * @dev Returns the total number of tokens in existence.
1625      * Burned tokens will reduce the count.
1626      * To get the total number of tokens minted, please see {_totalMinted}.
1627      */
1628     function totalSupply() public view virtual override returns (uint256) {
1629         // Counter underflow is impossible as _burnCounter cannot be incremented
1630         // more than `_currentIndex - _startTokenId()` times.
1631         unchecked {
1632             return _currentIndex - _burnCounter - _startTokenId();
1633         }
1634     }
1635 
1636     /**
1637      * @dev Returns the total amount of tokens minted in the contract.
1638      */
1639     function _totalMinted() internal view virtual returns (uint256) {
1640         // Counter underflow is impossible as `_currentIndex` does not decrement,
1641         // and it is initialized to `_startTokenId()`.
1642         unchecked {
1643             return _currentIndex - _startTokenId();
1644         }
1645     }
1646 
1647     /**
1648      * @dev Returns the total number of tokens burned.
1649      */
1650     function _totalBurned() internal view virtual returns (uint256) {
1651         return _burnCounter;
1652     }
1653 
1654     // =============================================================
1655     //                    ADDRESS DATA OPERATIONS
1656     // =============================================================
1657 
1658     /**
1659      * @dev Returns the number of tokens in `owner`'s account.
1660      */
1661     function balanceOf(address owner) public view virtual override returns (uint256) {
1662         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1663         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1664     }
1665 
1666     /**
1667      * Returns the number of tokens minted by `owner`.
1668      */
1669     function _numberMinted(address owner) internal view returns (uint256) {
1670         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1671     }
1672 
1673     /**
1674      * Returns the number of tokens burned by or on behalf of `owner`.
1675      */
1676     function _numberBurned(address owner) internal view returns (uint256) {
1677         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1678     }
1679 
1680     /**
1681      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1682      */
1683     function _getAux(address owner) internal view returns (uint64) {
1684         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1685     }
1686 
1687     /**
1688      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1689      * If there are multiple variables, please pack them into a uint64.
1690      */
1691     function _setAux(address owner, uint64 aux) internal virtual {
1692         uint256 packed = _packedAddressData[owner];
1693         uint256 auxCasted;
1694         // Cast `aux` with assembly to avoid redundant masking.
1695         assembly {
1696             auxCasted := aux
1697         }
1698         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1699         _packedAddressData[owner] = packed;
1700     }
1701 
1702     // =============================================================
1703     //                            IERC165
1704     // =============================================================
1705 
1706     /**
1707      * @dev Returns true if this contract implements the interface defined by
1708      * `interfaceId`. See the corresponding
1709      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1710      * to learn more about how these ids are created.
1711      *
1712      * This function call must use less than 30000 gas.
1713      */
1714     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1715         // The interface IDs are constants representing the first 4 bytes
1716         // of the XOR of all function selectors in the interface.
1717         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1718         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1719         return
1720             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1721             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1722             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1723     }
1724 
1725     // =============================================================
1726     //                        IERC721Metadata
1727     // =============================================================
1728 
1729     /**
1730      * @dev Returns the token collection name.
1731      */
1732     function name() public view virtual override returns (string memory) {
1733         return _name;
1734     }
1735 
1736     /**
1737      * @dev Returns the token collection symbol.
1738      */
1739     function symbol() public view virtual override returns (string memory) {
1740         return _symbol;
1741     }
1742 
1743     /**
1744      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1745      */
1746     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1747         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1748 
1749         string memory baseURI = _baseURI();
1750         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1751     }
1752 
1753     /**
1754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1756      * by default, it can be overridden in child contracts.
1757      */
1758     function _baseURI() internal view virtual returns (string memory) {
1759         return '';
1760     }
1761 
1762     // =============================================================
1763     //                     OWNERSHIPS OPERATIONS
1764     // =============================================================
1765 
1766     /**
1767      * @dev Returns the owner of the `tokenId` token.
1768      *
1769      * Requirements:
1770      *
1771      * - `tokenId` must exist.
1772      */
1773     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1774         return address(uint160(_packedOwnershipOf(tokenId)));
1775     }
1776 
1777     /**
1778      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1779      * It gradually moves to O(1) as tokens get transferred around over time.
1780      */
1781     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1782         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1783     }
1784 
1785     /**
1786      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1787      */
1788     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1789         return _unpackedOwnership(_packedOwnerships[index]);
1790     }
1791 
1792     /**
1793      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1794      */
1795     function _initializeOwnershipAt(uint256 index) internal virtual {
1796         if (_packedOwnerships[index] == 0) {
1797             _packedOwnerships[index] = _packedOwnershipOf(index);
1798         }
1799     }
1800 
1801     /**
1802      * Returns the packed ownership data of `tokenId`.
1803      */
1804     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1805         uint256 curr = tokenId;
1806 
1807         unchecked {
1808             if (_startTokenId() <= curr)
1809                 if (curr < _currentIndex) {
1810                     uint256 packed = _packedOwnerships[curr];
1811                     // If not burned.
1812                     if (packed & _BITMASK_BURNED == 0) {
1813                         // Invariant:
1814                         // There will always be an initialized ownership slot
1815                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1816                         // before an unintialized ownership slot
1817                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1818                         // Hence, `curr` will not underflow.
1819                         //
1820                         // We can directly compare the packed value.
1821                         // If the address is zero, packed will be zero.
1822                         while (packed == 0) {
1823                             packed = _packedOwnerships[--curr];
1824                         }
1825                         return packed;
1826                     }
1827                 }
1828         }
1829         revert OwnerQueryForNonexistentToken();
1830     }
1831 
1832     /**
1833      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1834      */
1835     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1836         ownership.addr = address(uint160(packed));
1837         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1838         ownership.burned = packed & _BITMASK_BURNED != 0;
1839         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1840     }
1841 
1842     /**
1843      * @dev Packs ownership data into a single uint256.
1844      */
1845     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1846         assembly {
1847             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1848             owner := and(owner, _BITMASK_ADDRESS)
1849             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1850             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1851         }
1852     }
1853 
1854     /**
1855      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1856      */
1857     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1858         // For branchless setting of the `nextInitialized` flag.
1859         assembly {
1860             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1861             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1862         }
1863     }
1864 
1865     // =============================================================
1866     //                      APPROVAL OPERATIONS
1867     // =============================================================
1868 
1869     /**
1870      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1871      * The approval is cleared when the token is transferred.
1872      *
1873      * Only a single account can be approved at a time, so approving the
1874      * zero address clears previous approvals.
1875      *
1876      * Requirements:
1877      *
1878      * - The caller must own the token or be an approved operator.
1879      * - `tokenId` must exist.
1880      *
1881      * Emits an {Approval} event.
1882      */
1883     function approve(address to, uint256 tokenId) public payable virtual override {
1884         address owner = ownerOf(tokenId);
1885 
1886         if (_msgSenderERC721A() != owner)
1887             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1888                 revert ApprovalCallerNotOwnerNorApproved();
1889             }
1890 
1891         _tokenApprovals[tokenId].value = to;
1892         emit Approval(owner, to, tokenId);
1893     }
1894 
1895     /**
1896      * @dev Returns the account approved for `tokenId` token.
1897      *
1898      * Requirements:
1899      *
1900      * - `tokenId` must exist.
1901      */
1902     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1903         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1904 
1905         return _tokenApprovals[tokenId].value;
1906     }
1907 
1908     /**
1909      * @dev Approve or remove `operator` as an operator for the caller.
1910      * Operators can call {transferFrom} or {safeTransferFrom}
1911      * for any token owned by the caller.
1912      *
1913      * Requirements:
1914      *
1915      * - The `operator` cannot be the caller.
1916      *
1917      * Emits an {ApprovalForAll} event.
1918      */
1919     function setApprovalForAll(address operator, bool approved) public virtual override {
1920         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1921         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1922     }
1923 
1924     /**
1925      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1926      *
1927      * See {setApprovalForAll}.
1928      */
1929     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1930         return _operatorApprovals[owner][operator];
1931     }
1932 
1933     /**
1934      * @dev Returns whether `tokenId` exists.
1935      *
1936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1937      *
1938      * Tokens start existing when they are minted. See {_mint}.
1939      */
1940     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1941         return
1942             _startTokenId() <= tokenId &&
1943             tokenId < _currentIndex && // If within bounds,
1944             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1945     }
1946 
1947     /**
1948      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1949      */
1950     function _isSenderApprovedOrOwner(
1951         address approvedAddress,
1952         address owner,
1953         address msgSender
1954     ) private pure returns (bool result) {
1955         assembly {
1956             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1957             owner := and(owner, _BITMASK_ADDRESS)
1958             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1959             msgSender := and(msgSender, _BITMASK_ADDRESS)
1960             // `msgSender == owner || msgSender == approvedAddress`.
1961             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1962         }
1963     }
1964 
1965     /**
1966      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1967      */
1968     function _getApprovedSlotAndAddress(uint256 tokenId)
1969         private
1970         view
1971         returns (uint256 approvedAddressSlot, address approvedAddress)
1972     {
1973         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1974         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1975         assembly {
1976             approvedAddressSlot := tokenApproval.slot
1977             approvedAddress := sload(approvedAddressSlot)
1978         }
1979     }
1980 
1981     // =============================================================
1982     //                      TRANSFER OPERATIONS
1983     // =============================================================
1984 
1985     /**
1986      * @dev Transfers `tokenId` from `from` to `to`.
1987      *
1988      * Requirements:
1989      *
1990      * - `from` cannot be the zero address.
1991      * - `to` cannot be the zero address.
1992      * - `tokenId` token must be owned by `from`.
1993      * - If the caller is not `from`, it must be approved to move this token
1994      * by either {approve} or {setApprovalForAll}.
1995      *
1996      * Emits a {Transfer} event.
1997      */
1998     function transferFrom(
1999         address from,
2000         address to,
2001         uint256 tokenId
2002     ) public payable virtual override {
2003         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2004 
2005         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2006 
2007         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2008 
2009         // The nested ifs save around 20+ gas over a compound boolean condition.
2010         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2011             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2012 
2013         if (to == address(0)) revert TransferToZeroAddress();
2014 
2015         _beforeTokenTransfers(from, to, tokenId, 1);
2016 
2017         // Clear approvals from the previous owner.
2018         assembly {
2019             if approvedAddress {
2020                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2021                 sstore(approvedAddressSlot, 0)
2022             }
2023         }
2024 
2025         // Underflow of the sender's balance is impossible because we check for
2026         // ownership above and the recipient's balance can't realistically overflow.
2027         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2028         unchecked {
2029             // We can directly increment and decrement the balances.
2030             --_packedAddressData[from]; // Updates: `balance -= 1`.
2031             ++_packedAddressData[to]; // Updates: `balance += 1`.
2032 
2033             // Updates:
2034             // - `address` to the next owner.
2035             // - `startTimestamp` to the timestamp of transfering.
2036             // - `burned` to `false`.
2037             // - `nextInitialized` to `true`.
2038             _packedOwnerships[tokenId] = _packOwnershipData(
2039                 to,
2040                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2041             );
2042 
2043             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2044             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2045                 uint256 nextTokenId = tokenId + 1;
2046                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2047                 if (_packedOwnerships[nextTokenId] == 0) {
2048                     // If the next slot is within bounds.
2049                     if (nextTokenId != _currentIndex) {
2050                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2051                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2052                     }
2053                 }
2054             }
2055         }
2056 
2057         emit Transfer(from, to, tokenId);
2058         _afterTokenTransfers(from, to, tokenId, 1);
2059     }
2060 
2061     /**
2062      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2063      */
2064     function safeTransferFrom(
2065         address from,
2066         address to,
2067         uint256 tokenId
2068     ) public payable virtual override {
2069         safeTransferFrom(from, to, tokenId, '');
2070     }
2071 
2072     /**
2073      * @dev Safely transfers `tokenId` token from `from` to `to`.
2074      *
2075      * Requirements:
2076      *
2077      * - `from` cannot be the zero address.
2078      * - `to` cannot be the zero address.
2079      * - `tokenId` token must exist and be owned by `from`.
2080      * - If the caller is not `from`, it must be approved to move this token
2081      * by either {approve} or {setApprovalForAll}.
2082      * - If `to` refers to a smart contract, it must implement
2083      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2084      *
2085      * Emits a {Transfer} event.
2086      */
2087     function safeTransferFrom(
2088         address from,
2089         address to,
2090         uint256 tokenId,
2091         bytes memory _data
2092     ) public payable virtual override {
2093         transferFrom(from, to, tokenId);
2094         if (to.code.length != 0)
2095             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2096                 revert TransferToNonERC721ReceiverImplementer();
2097             }
2098     }
2099 
2100     /**
2101      * @dev Hook that is called before a set of serially-ordered token IDs
2102      * are about to be transferred. This includes minting.
2103      * And also called before burning one token.
2104      *
2105      * `startTokenId` - the first token ID to be transferred.
2106      * `quantity` - the amount to be transferred.
2107      *
2108      * Calling conditions:
2109      *
2110      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2111      * transferred to `to`.
2112      * - When `from` is zero, `tokenId` will be minted for `to`.
2113      * - When `to` is zero, `tokenId` will be burned by `from`.
2114      * - `from` and `to` are never both zero.
2115      */
2116     function _beforeTokenTransfers(
2117         address from,
2118         address to,
2119         uint256 startTokenId,
2120         uint256 quantity
2121     ) internal virtual {}
2122 
2123     /**
2124      * @dev Hook that is called after a set of serially-ordered token IDs
2125      * have been transferred. This includes minting.
2126      * And also called after one token has been burned.
2127      *
2128      * `startTokenId` - the first token ID to be transferred.
2129      * `quantity` - the amount to be transferred.
2130      *
2131      * Calling conditions:
2132      *
2133      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2134      * transferred to `to`.
2135      * - When `from` is zero, `tokenId` has been minted for `to`.
2136      * - When `to` is zero, `tokenId` has been burned by `from`.
2137      * - `from` and `to` are never both zero.
2138      */
2139     function _afterTokenTransfers(
2140         address from,
2141         address to,
2142         uint256 startTokenId,
2143         uint256 quantity
2144     ) internal virtual {}
2145 
2146     /**
2147      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2148      *
2149      * `from` - Previous owner of the given token ID.
2150      * `to` - Target address that will receive the token.
2151      * `tokenId` - Token ID to be transferred.
2152      * `_data` - Optional data to send along with the call.
2153      *
2154      * Returns whether the call correctly returned the expected magic value.
2155      */
2156     function _checkContractOnERC721Received(
2157         address from,
2158         address to,
2159         uint256 tokenId,
2160         bytes memory _data
2161     ) private returns (bool) {
2162         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2163             bytes4 retval
2164         ) {
2165             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2166         } catch (bytes memory reason) {
2167             if (reason.length == 0) {
2168                 revert TransferToNonERC721ReceiverImplementer();
2169             } else {
2170                 assembly {
2171                     revert(add(32, reason), mload(reason))
2172                 }
2173             }
2174         }
2175     }
2176 
2177     // =============================================================
2178     //                        MINT OPERATIONS
2179     // =============================================================
2180 
2181     /**
2182      * @dev Mints `quantity` tokens and transfers them to `to`.
2183      *
2184      * Requirements:
2185      *
2186      * - `to` cannot be the zero address.
2187      * - `quantity` must be greater than 0.
2188      *
2189      * Emits a {Transfer} event for each mint.
2190      */
2191     function _mint(address to, uint256 quantity) internal virtual {
2192         uint256 startTokenId = _currentIndex;
2193         if (quantity == 0) revert MintZeroQuantity();
2194 
2195         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2196 
2197         // Overflows are incredibly unrealistic.
2198         // `balance` and `numberMinted` have a maximum limit of 2**64.
2199         // `tokenId` has a maximum limit of 2**256.
2200         unchecked {
2201             // Updates:
2202             // - `balance += quantity`.
2203             // - `numberMinted += quantity`.
2204             //
2205             // We can directly add to the `balance` and `numberMinted`.
2206             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2207 
2208             // Updates:
2209             // - `address` to the owner.
2210             // - `startTimestamp` to the timestamp of minting.
2211             // - `burned` to `false`.
2212             // - `nextInitialized` to `quantity == 1`.
2213             _packedOwnerships[startTokenId] = _packOwnershipData(
2214                 to,
2215                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2216             );
2217 
2218             uint256 toMasked;
2219             uint256 end = startTokenId + quantity;
2220 
2221             // Use assembly to loop and emit the `Transfer` event for gas savings.
2222             // The duplicated `log4` removes an extra check and reduces stack juggling.
2223             // The assembly, together with the surrounding Solidity code, have been
2224             // delicately arranged to nudge the compiler into producing optimized opcodes.
2225             assembly {
2226                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2227                 toMasked := and(to, _BITMASK_ADDRESS)
2228                 // Emit the `Transfer` event.
2229                 log4(
2230                     0, // Start of data (0, since no data).
2231                     0, // End of data (0, since no data).
2232                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2233                     0, // `address(0)`.
2234                     toMasked, // `to`.
2235                     startTokenId // `tokenId`.
2236                 )
2237 
2238                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2239                 // that overflows uint256 will make the loop run out of gas.
2240                 // The compiler will optimize the `iszero` away for performance.
2241                 for {
2242                     let tokenId := add(startTokenId, 1)
2243                 } iszero(eq(tokenId, end)) {
2244                     tokenId := add(tokenId, 1)
2245                 } {
2246                     // Emit the `Transfer` event. Similar to above.
2247                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2248                 }
2249             }
2250             if (toMasked == 0) revert MintToZeroAddress();
2251 
2252             _currentIndex = end;
2253         }
2254         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2255     }
2256 
2257     /**
2258      * @dev Mints `quantity` tokens and transfers them to `to`.
2259      *
2260      * This function is intended for efficient minting only during contract creation.
2261      *
2262      * It emits only one {ConsecutiveTransfer} as defined in
2263      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2264      * instead of a sequence of {Transfer} event(s).
2265      *
2266      * Calling this function outside of contract creation WILL make your contract
2267      * non-compliant with the ERC721 standard.
2268      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2269      * {ConsecutiveTransfer} event is only permissible during contract creation.
2270      *
2271      * Requirements:
2272      *
2273      * - `to` cannot be the zero address.
2274      * - `quantity` must be greater than 0.
2275      *
2276      * Emits a {ConsecutiveTransfer} event.
2277      */
2278     function _mintERC2309(address to, uint256 quantity) internal virtual {
2279         uint256 startTokenId = _currentIndex;
2280         if (to == address(0)) revert MintToZeroAddress();
2281         if (quantity == 0) revert MintZeroQuantity();
2282         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2283 
2284         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2285 
2286         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2287         unchecked {
2288             // Updates:
2289             // - `balance += quantity`.
2290             // - `numberMinted += quantity`.
2291             //
2292             // We can directly add to the `balance` and `numberMinted`.
2293             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2294 
2295             // Updates:
2296             // - `address` to the owner.
2297             // - `startTimestamp` to the timestamp of minting.
2298             // - `burned` to `false`.
2299             // - `nextInitialized` to `quantity == 1`.
2300             _packedOwnerships[startTokenId] = _packOwnershipData(
2301                 to,
2302                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2303             );
2304 
2305             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2306 
2307             _currentIndex = startTokenId + quantity;
2308         }
2309         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2310     }
2311 
2312     /**
2313      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2314      *
2315      * Requirements:
2316      *
2317      * - If `to` refers to a smart contract, it must implement
2318      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2319      * - `quantity` must be greater than 0.
2320      *
2321      * See {_mint}.
2322      *
2323      * Emits a {Transfer} event for each mint.
2324      */
2325     function _safeMint(
2326         address to,
2327         uint256 quantity,
2328         bytes memory _data
2329     ) internal virtual {
2330         _mint(to, quantity);
2331 
2332         unchecked {
2333             if (to.code.length != 0) {
2334                 uint256 end = _currentIndex;
2335                 uint256 index = end - quantity;
2336                 do {
2337                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2338                         revert TransferToNonERC721ReceiverImplementer();
2339                     }
2340                 } while (index < end);
2341                 // Reentrancy protection.
2342                 if (_currentIndex != end) revert();
2343             }
2344         }
2345     }
2346 
2347     /**
2348      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2349      */
2350     function _safeMint(address to, uint256 quantity) internal virtual {
2351         _safeMint(to, quantity, '');
2352     }
2353 
2354     // =============================================================
2355     //                        BURN OPERATIONS
2356     // =============================================================
2357 
2358     /**
2359      * @dev Equivalent to `_burn(tokenId, false)`.
2360      */
2361     function _burn(uint256 tokenId) internal virtual {
2362         _burn(tokenId, false);
2363     }
2364 
2365     /**
2366      * @dev Destroys `tokenId`.
2367      * The approval is cleared when the token is burned.
2368      *
2369      * Requirements:
2370      *
2371      * - `tokenId` must exist.
2372      *
2373      * Emits a {Transfer} event.
2374      */
2375     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2376         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2377 
2378         address from = address(uint160(prevOwnershipPacked));
2379 
2380         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2381 
2382         if (approvalCheck) {
2383             // The nested ifs save around 20+ gas over a compound boolean condition.
2384             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2385                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2386         }
2387 
2388         _beforeTokenTransfers(from, address(0), tokenId, 1);
2389 
2390         // Clear approvals from the previous owner.
2391         assembly {
2392             if approvedAddress {
2393                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2394                 sstore(approvedAddressSlot, 0)
2395             }
2396         }
2397 
2398         // Underflow of the sender's balance is impossible because we check for
2399         // ownership above and the recipient's balance can't realistically overflow.
2400         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2401         unchecked {
2402             // Updates:
2403             // - `balance -= 1`.
2404             // - `numberBurned += 1`.
2405             //
2406             // We can directly decrement the balance, and increment the number burned.
2407             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2408             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2409 
2410             // Updates:
2411             // - `address` to the last owner.
2412             // - `startTimestamp` to the timestamp of burning.
2413             // - `burned` to `true`.
2414             // - `nextInitialized` to `true`.
2415             _packedOwnerships[tokenId] = _packOwnershipData(
2416                 from,
2417                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2418             );
2419 
2420             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2421             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2422                 uint256 nextTokenId = tokenId + 1;
2423                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2424                 if (_packedOwnerships[nextTokenId] == 0) {
2425                     // If the next slot is within bounds.
2426                     if (nextTokenId != _currentIndex) {
2427                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2428                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2429                     }
2430                 }
2431             }
2432         }
2433 
2434         emit Transfer(from, address(0), tokenId);
2435         _afterTokenTransfers(from, address(0), tokenId, 1);
2436 
2437         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2438         unchecked {
2439             _burnCounter++;
2440         }
2441     }
2442 
2443     // =============================================================
2444     //                     EXTRA DATA OPERATIONS
2445     // =============================================================
2446 
2447     /**
2448      * @dev Directly sets the extra data for the ownership data `index`.
2449      */
2450     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2451         uint256 packed = _packedOwnerships[index];
2452         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2453         uint256 extraDataCasted;
2454         // Cast `extraData` with assembly to avoid redundant masking.
2455         assembly {
2456             extraDataCasted := extraData
2457         }
2458         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2459         _packedOwnerships[index] = packed;
2460     }
2461 
2462     /**
2463      * @dev Called during each token transfer to set the 24bit `extraData` field.
2464      * Intended to be overridden by the cosumer contract.
2465      *
2466      * `previousExtraData` - the value of `extraData` before transfer.
2467      *
2468      * Calling conditions:
2469      *
2470      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2471      * transferred to `to`.
2472      * - When `from` is zero, `tokenId` will be minted for `to`.
2473      * - When `to` is zero, `tokenId` will be burned by `from`.
2474      * - `from` and `to` are never both zero.
2475      */
2476     function _extraData(
2477         address from,
2478         address to,
2479         uint24 previousExtraData
2480     ) internal view virtual returns (uint24) {}
2481 
2482     /**
2483      * @dev Returns the next extra data for the packed ownership data.
2484      * The returned result is shifted into position.
2485      */
2486     function _nextExtraData(
2487         address from,
2488         address to,
2489         uint256 prevOwnershipPacked
2490     ) private view returns (uint256) {
2491         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2492         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2493     }
2494 
2495     // =============================================================
2496     //                       OTHER OPERATIONS
2497     // =============================================================
2498 
2499     /**
2500      * @dev Returns the message sender (defaults to `msg.sender`).
2501      *
2502      * If you are writing GSN compatible contracts, you need to override this function.
2503      */
2504     function _msgSenderERC721A() internal view virtual returns (address) {
2505         return msg.sender;
2506     }
2507 
2508     /**
2509      * @dev Converts a uint256 to its ASCII string decimal representation.
2510      */
2511     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2512         assembly {
2513             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2514             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2515             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2516             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2517             let m := add(mload(0x40), 0xa0)
2518             // Update the free memory pointer to allocate.
2519             mstore(0x40, m)
2520             // Assign the `str` to the end.
2521             str := sub(m, 0x20)
2522             // Zeroize the slot after the string.
2523             mstore(str, 0)
2524 
2525             // Cache the end of the memory to calculate the length later.
2526             let end := str
2527 
2528             // We write the string from rightmost digit to leftmost digit.
2529             // The following is essentially a do-while loop that also handles the zero case.
2530             // prettier-ignore
2531             for { let temp := value } 1 {} {
2532                 str := sub(str, 1)
2533                 // Write the character to the pointer.
2534                 // The ASCII index of the '0' character is 48.
2535                 mstore8(str, add(48, mod(temp, 10)))
2536                 // Keep dividing `temp` until zero.
2537                 temp := div(temp, 10)
2538                 // prettier-ignore
2539                 if iszero(temp) { break }
2540             }
2541 
2542             let length := sub(end, str)
2543             // Move the pointer 32 bytes leftwards to make room for the length.
2544             str := sub(str, 0x20)
2545             // Store the length.
2546             mstore(str, length)
2547         }
2548     }
2549 }
2550 
2551 // File: troublemkrs_deposit.sol
2552 
2553 
2554 
2555 pragma solidity >=0.8.9 <0.9.0;
2556 
2557 
2558 
2559 
2560 
2561 
2562 
2563 
2564 
2565 contract Troublemakers is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2566     bytes32 public root;
2567 	using Strings for uint;
2568 
2569 	uint public maxSupply = 333;
2570 	uint public maxPerWallet = 1;
2571 
2572 	uint public maxDeposits = 0;
2573     uint public currentDeposits = 0;
2574 
2575 	uint public publicPrice = 0.169 ether;
2576 	uint public whitelistPrice = 0.169 ether;
2577 
2578 	bool public isPublicMint = false;
2579     bool public isWhitelistMint = false;
2580     bool public isMetadataFinal;
2581 
2582     string private _baseURL;
2583 	string public prerevealURL = '';
2584 
2585     address[] public awardableWallets;
2586 	address public withdrawAddress = 0x60e9C96430D50a49eaBF3e5f5351055Dc15Af7fA;
2587 
2588     mapping (address => uint) public depositStatus;
2589 
2590 	constructor()
2591 	ERC721A('Troublemakers', 'TROUBLE') {
2592     }
2593 
2594     function amountDeposited(address _wallet) public view returns (uint) {
2595         return depositStatus[_wallet];
2596     }
2597 
2598 	function _baseURI() internal view override returns (string memory) {
2599 		return _baseURL;
2600 	}
2601 
2602 	function _startTokenId() internal pure override returns (uint) {
2603 		return 1;
2604 	}
2605 
2606 	function contractURI() public pure returns (string memory) {
2607 		return "";
2608 	}
2609 
2610     function finalizeMetadata() external onlyOwner {
2611         isMetadataFinal = true;
2612     }
2613 
2614 	function reveal(string memory url) external onlyOwner {
2615         require(!isMetadataFinal, "Metadata is finalized");
2616 		_baseURL = url;
2617 	}
2618     function setRoot(bytes32 _root) external onlyOwner {
2619 		root = _root;
2620 	}
2621 
2622 	function setMaxDeposits(uint _max) external onlyOwner {
2623 		maxDeposits = _max;
2624 	}
2625 
2626 	function setMaxPerWallet(uint _max) external onlyOwner {
2627 		maxPerWallet = _max;
2628 	}
2629 
2630     function setPublicPrice(uint _price) external onlyOwner {
2631 		publicPrice = _price;
2632 	}
2633 
2634     function setWhitelistPrice(uint _price) external onlyOwner {
2635 		whitelistPrice = _price;
2636 	}
2637 
2638 	function setPublicState(bool value) external onlyOwner {
2639 		isPublicMint = value;
2640 	}
2641 
2642     function setWhitelistState(bool value) external onlyOwner {
2643 		isWhitelistMint = value;
2644 	}
2645 
2646     function withdraw() public onlyOwner {
2647         uint256 balance = address(this).balance;
2648         payable(withdrawAddress).transfer(balance);
2649     }
2650 
2651 	function airdrop(address to, uint count) external onlyOwner {
2652 		require(
2653 			_totalMinted() + count <= maxSupply,
2654 			'Exceeds max supply'
2655 		);
2656 		_safeMint(to, count);
2657 	}
2658 
2659 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
2660         require(maxDeposits <= newMaxSupply);
2661 		maxSupply = newMaxSupply;
2662 	}
2663 
2664 	function tokenURI(uint tokenId)
2665 		public
2666 		view
2667 		override
2668 		returns (string memory)
2669 	{
2670         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2671 
2672         return bytes(_baseURI()).length > 0 
2673             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
2674             : prerevealURL;
2675 	}
2676 
2677 	function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
2678         return MerkleProof.verify(proof, root, leaf);
2679     }
2680 
2681 
2682 	/*
2683 			DEPOSIT + AWARD FUNCTIONS
2684 	*/
2685 
2686     /// @notice This is a whitelist only function that will create a deposit, which will result in a Troublemaker NFT minted to the depositer once the awardTokensFromDeposits function is called by the contract owner
2687     function depositAllowlist(bytes32[] memory proof) public payable {
2688 		uint count = 1;
2689 		require(isWhitelistMint, "Whitelist mint has not started");
2690 		require(currentDeposits + count <= maxDeposits, "Exceeds max deposits allowed");
2691 		require(depositStatus[msg.sender] < maxPerWallet, "Exceeds max per wallet");
2692         
2693         if (!isValid(proof, keccak256(abi.encodePacked(msg.sender)))) revert("Wallet is not on allowlist");
2694 
2695 		require(
2696 			msg.value >= count * whitelistPrice,
2697 			"Ether value sent is not sufficient"
2698 		);
2699 
2700         awardableWallets.push(msg.sender);
2701         depositStatus[msg.sender]++;
2702 	}
2703 
2704     /// @notice This is a public function that will create a deposit, which will result in a Troublemaker NFT minted to the depositer once the awardTokensFromDeposits function is called by the contract owner
2705     function depositPublic() public payable {
2706 		uint count = 1;
2707 		require(isPublicMint, "Public mint has not started");
2708 		require(currentDeposits + count <= maxDeposits, "Exceeds max deposits allowed");
2709 		require(depositStatus[msg.sender] < maxPerWallet, "Exceeds max per wallet");
2710 
2711 		require(
2712 			msg.value >= count * publicPrice,
2713 			'Ether value sent is not sufficient'
2714 		);
2715 
2716         currentDeposits++;
2717 
2718         awardableWallets.push(msg.sender);
2719         depositStatus[msg.sender]++;
2720 	}
2721 
2722     /// @notice This function settles previous debts via awardableWallets and will award a Troublemaker NFT to anyone who is owed one at time of execution 
2723 	function awardTokensFromDeposits() public onlyOwner {
2724         require(awardableWallets.length > 0, "There are no wallets to award to");
2725 
2726         // Loop for each wallet in awardableWallets
2727         for (uint i = awardableWallets.length; i > 0; i--) {
2728             require(_totalMinted() + 1 <= maxSupply, "Exceeds max supply");
2729 
2730             // Mint to address
2731             _safeMint(awardableWallets[i-1], 1);
2732 
2733             // Remove address from awardableWallets list
2734             awardableWallets.pop();
2735 
2736         }
2737 
2738 	}   
2739 
2740 
2741 	/*
2742 			OPENSEA OPERATOR OVERRIDES (ROYALTIES)
2743 	*/
2744 
2745     function transferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A) onlyAllowedOperator(from) {
2746         super.transferFrom(from, to, tokenId);
2747     }
2748 
2749     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A) onlyAllowedOperator(from) {
2750         super.safeTransferFrom(from, to, tokenId);
2751     }
2752 
2753     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override(ERC721A) onlyAllowedOperator(from) {
2754         super.safeTransferFrom(from, to, tokenId, data);
2755     }
2756 
2757 }