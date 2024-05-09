1 // SPDX-License-Identifier: MIT
2 
3 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator)
9         external
10         view
11         returns (bool);
12 
13     function register(address registrant) external;
14 
15     function registerAndSubscribe(address registrant, address subscription)
16         external;
17 
18     function registerAndCopyEntries(
19         address registrant,
20         address registrantToCopy
21     ) external;
22 
23     function unregister(address addr) external;
24 
25     function updateOperator(
26         address registrant,
27         address operator,
28         bool filtered
29     ) external;
30 
31     function updateOperators(
32         address registrant,
33         address[] calldata operators,
34         bool filtered
35     ) external;
36 
37     function updateCodeHash(
38         address registrant,
39         bytes32 codehash,
40         bool filtered
41     ) external;
42 
43     function updateCodeHashes(
44         address registrant,
45         bytes32[] calldata codeHashes,
46         bool filtered
47     ) external;
48 
49     function subscribe(address registrant, address registrantToSubscribe)
50         external;
51 
52     function unsubscribe(address registrant, bool copyExistingEntries) external;
53 
54     function subscriptionOf(address addr) external returns (address registrant);
55 
56     function subscribers(address registrant)
57         external
58         returns (address[] memory);
59 
60     function subscriberAt(address registrant, uint256 index)
61         external
62         returns (address);
63 
64     function copyEntriesOf(address registrant, address registrantToCopy)
65         external;
66 
67     function isOperatorFiltered(address registrant, address operator)
68         external
69         returns (bool);
70 
71     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
72         external
73         returns (bool);
74 
75     function isCodeHashFiltered(address registrant, bytes32 codeHash)
76         external
77         returns (bool);
78 
79     function filteredOperators(address addr)
80         external
81         returns (address[] memory);
82 
83     function filteredCodeHashes(address addr)
84         external
85         returns (bytes32[] memory);
86 
87     function filteredOperatorAt(address registrant, uint256 index)
88         external
89         returns (address);
90 
91     function filteredCodeHashAt(address registrant, uint256 index)
92         external
93         returns (bytes32);
94 
95     function isRegistered(address addr) external returns (bool);
96 
97     function codeHashOf(address addr) external returns (bytes32);
98 }
99 
100 // File: operator-filter-registry/src/OperatorFilterer.sol
101 
102 pragma solidity ^0.8.13;
103 
104 abstract contract OperatorFilterer {
105     error OperatorNotAllowed(address operator);
106 
107     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
108         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
109 
110     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
111         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
112         // will not revert, but the contract will need to be registered with the registry once it is deployed in
113         // order for the modifier to filter addresses.
114         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
115             if (subscribe) {
116                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
117                     address(this),
118                     subscriptionOrRegistrantToCopy
119                 );
120             } else {
121                 if (subscriptionOrRegistrantToCopy != address(0)) {
122                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
123                         address(this),
124                         subscriptionOrRegistrantToCopy
125                     );
126                 } else {
127                     OPERATOR_FILTER_REGISTRY.register(address(this));
128                 }
129             }
130         }
131     }
132 
133     modifier onlyAllowedOperator(address from) virtual {
134         // Check registry code length to facilitate testing in environments without a deployed registry.
135         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
136             // Allow spending tokens from addresses with balance
137             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
138             // from an EOA.
139             if (from == msg.sender) {
140                 _;
141                 return;
142             }
143             if (
144                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
145                     address(this),
146                     msg.sender
147                 )
148             ) {
149                 revert OperatorNotAllowed(msg.sender);
150             }
151         }
152         _;
153     }
154 
155     modifier onlyAllowedOperatorApproval(address operator) virtual {
156         // Check registry code length to facilitate testing in environments without a deployed registry.
157         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
158             if (
159                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
160                     address(this),
161                     operator
162                 )
163             ) {
164                 revert OperatorNotAllowed(operator);
165             }
166         }
167         _;
168     }
169 }
170 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
171 
172 pragma solidity ^0.8.13;
173 
174 abstract contract DefaultOperatorFilterer is OperatorFilterer {
175     address constant DEFAULT_SUBSCRIPTION =
176         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
177 
178     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
179 }
180 
181 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
182 
183 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev These functions deal with verification of Merkle Tree proofs.
189  *
190  * The proofs can be generated using the JavaScript library
191  * https://github.com/miguelmota/merkletreejs[merkletreejs].
192  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
193  *
194  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
195  *
196  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
197  * hashing, or use a hash function other than keccak256 for hashing leaves.
198  * This is because the concatenation of a sorted pair of internal nodes in
199  * the merkle tree could be reinterpreted as a leaf value.
200  */
201 library MerkleProof {
202     /**
203      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
204      * defined by `root`. For this, a `proof` must be provided, containing
205      * sibling hashes on the branch from the leaf to the root of the tree. Each
206      * pair of leaves and each pair of pre-images are assumed to be sorted.
207      */
208     function verify(
209         bytes32[] memory proof,
210         bytes32 root,
211         bytes32 leaf
212     ) internal pure returns (bool) {
213         return processProof(proof, leaf) == root;
214     }
215 
216     /**
217      * @dev Calldata version of {verify}
218      *
219      * _Available since v4.7._
220      */
221     function verifyCalldata(
222         bytes32[] calldata proof,
223         bytes32 root,
224         bytes32 leaf
225     ) internal pure returns (bool) {
226         return processProofCalldata(proof, leaf) == root;
227     }
228 
229     /**
230      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
231      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
232      * hash matches the root of the tree. When processing the proof, the pairs
233      * of leafs & pre-images are assumed to be sorted.
234      *
235      * _Available since v4.4._
236      */
237     function processProof(bytes32[] memory proof, bytes32 leaf)
238         internal
239         pure
240         returns (bytes32)
241     {
242         bytes32 computedHash = leaf;
243         for (uint256 i = 0; i < proof.length; i++) {
244             computedHash = _hashPair(computedHash, proof[i]);
245         }
246         return computedHash;
247     }
248 
249     /**
250      * @dev Calldata version of {processProof}
251      *
252      * _Available since v4.7._
253      */
254     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
255         internal
256         pure
257         returns (bytes32)
258     {
259         bytes32 computedHash = leaf;
260         for (uint256 i = 0; i < proof.length; i++) {
261             computedHash = _hashPair(computedHash, proof[i]);
262         }
263         return computedHash;
264     }
265 
266     /**
267      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
268      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
269      *
270      * _Available since v4.7._
271      */
272     function multiProofVerify(
273         bytes32[] memory proof,
274         bool[] memory proofFlags,
275         bytes32 root,
276         bytes32[] memory leaves
277     ) internal pure returns (bool) {
278         return processMultiProof(proof, proofFlags, leaves) == root;
279     }
280 
281     /**
282      * @dev Calldata version of {multiProofVerify}
283      *
284      * _Available since v4.7._
285      */
286     function multiProofVerifyCalldata(
287         bytes32[] calldata proof,
288         bool[] calldata proofFlags,
289         bytes32 root,
290         bytes32[] memory leaves
291     ) internal pure returns (bool) {
292         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
293     }
294 
295     /**
296      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
297      * consuming from one or the other at each step according to the instructions given by
298      * `proofFlags`.
299      *
300      * _Available since v4.7._
301      */
302     function processMultiProof(
303         bytes32[] memory proof,
304         bool[] memory proofFlags,
305         bytes32[] memory leaves
306     ) internal pure returns (bytes32 merkleRoot) {
307         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
308         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
309         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
310         // the merkle tree.
311         uint256 leavesLen = leaves.length;
312         uint256 totalHashes = proofFlags.length;
313 
314         // Check proof validity.
315         require(
316             leavesLen + proof.length - 1 == totalHashes,
317             "MerkleProof: invalid multiproof"
318         );
319 
320         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
321         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
322         bytes32[] memory hashes = new bytes32[](totalHashes);
323         uint256 leafPos = 0;
324         uint256 hashPos = 0;
325         uint256 proofPos = 0;
326         // At each step, we compute the next hash using two values:
327         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
328         //   get the next hash.
329         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
330         //   `proof` array.
331         for (uint256 i = 0; i < totalHashes; i++) {
332             bytes32 a = leafPos < leavesLen
333                 ? leaves[leafPos++]
334                 : hashes[hashPos++];
335             bytes32 b = proofFlags[i]
336                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
337                 : proof[proofPos++];
338             hashes[i] = _hashPair(a, b);
339         }
340 
341         if (totalHashes > 0) {
342             return hashes[totalHashes - 1];
343         } else if (leavesLen > 0) {
344             return leaves[0];
345         } else {
346             return proof[0];
347         }
348     }
349 
350     /**
351      * @dev Calldata version of {processMultiProof}
352      *
353      * _Available since v4.7._
354      */
355     function processMultiProofCalldata(
356         bytes32[] calldata proof,
357         bool[] calldata proofFlags,
358         bytes32[] memory leaves
359     ) internal pure returns (bytes32 merkleRoot) {
360         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
361         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
362         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
363         // the merkle tree.
364         uint256 leavesLen = leaves.length;
365         uint256 totalHashes = proofFlags.length;
366 
367         // Check proof validity.
368         require(
369             leavesLen + proof.length - 1 == totalHashes,
370             "MerkleProof: invalid multiproof"
371         );
372 
373         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
374         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
375         bytes32[] memory hashes = new bytes32[](totalHashes);
376         uint256 leafPos = 0;
377         uint256 hashPos = 0;
378         uint256 proofPos = 0;
379         // At each step, we compute the next hash using two values:
380         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
381         //   get the next hash.
382         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
383         //   `proof` array.
384         for (uint256 i = 0; i < totalHashes; i++) {
385             bytes32 a = leafPos < leavesLen
386                 ? leaves[leafPos++]
387                 : hashes[hashPos++];
388             bytes32 b = proofFlags[i]
389                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
390                 : proof[proofPos++];
391             hashes[i] = _hashPair(a, b);
392         }
393 
394         if (totalHashes > 0) {
395             return hashes[totalHashes - 1];
396         } else if (leavesLen > 0) {
397             return leaves[0];
398         } else {
399             return proof[0];
400         }
401     }
402 
403     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
404         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
405     }
406 
407     function _efficientHash(bytes32 a, bytes32 b)
408         private
409         pure
410         returns (bytes32 value)
411     {
412         /// @solidity memory-safe-assembly
413         assembly {
414             mstore(0x00, a)
415             mstore(0x20, b)
416             value := keccak256(0x00, 0x40)
417         }
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/Context.sol
422 
423 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
424 
425 pragma solidity ^0.8.0;
426 
427 /**
428  * @dev Provides information about the current execution context, including the
429  * sender of the transaction and its data. While these are generally available
430  * via msg.sender and msg.data, they should not be accessed in such a direct
431  * manner, since when dealing with meta-transactions the account sending and
432  * paying for execution may not be the actual sender (as far as an application
433  * is concerned).
434  *
435  * This contract is only required for intermediate, library-like contracts.
436  */
437 abstract contract Context {
438     function _msgSender() internal view virtual returns (address) {
439         return msg.sender;
440     }
441 
442     function _msgData() internal view virtual returns (bytes calldata) {
443         return msg.data;
444     }
445 }
446 
447 // File: @openzeppelin/contracts/access/Ownable.sol
448 
449 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Contract module which provides a basic access control mechanism, where
455  * there is an account (an owner) that can be granted exclusive access to
456  * specific functions.
457  *
458  * By default, the owner account will be the one that deploys the contract. This
459  * can later be changed with {transferOwnership}.
460  *
461  * This module is used through inheritance. It will make available the modifier
462  * `onlyOwner`, which can be applied to your functions to restrict their use to
463  * the owner.
464  */
465 abstract contract Ownable is Context {
466     address private _owner;
467 
468     event OwnershipTransferred(
469         address indexed previousOwner,
470         address indexed newOwner
471     );
472 
473     /**
474      * @dev Initializes the contract setting the deployer as the initial owner.
475      */
476     constructor() {
477         _transferOwnership(_msgSender());
478     }
479 
480     /**
481      * @dev Throws if called by any account other than the owner.
482      */
483     modifier onlyOwner() {
484         _checkOwner();
485         _;
486     }
487 
488     /**
489      * @dev Returns the address of the current owner.
490      */
491     function owner() public view virtual returns (address) {
492         return _owner;
493     }
494 
495     /**
496      * @dev Throws if the sender is not the owner.
497      */
498     function _checkOwner() internal view virtual {
499         require(owner() == _msgSender(), "Ownable: caller is not the owner");
500     }
501 
502     /**
503      * @dev Leaves the contract without owner. It will not be possible to call
504      * `onlyOwner` functions anymore. Can only be called by the current owner.
505      *
506      * NOTE: Renouncing ownership will leave the contract without an owner,
507      * thereby removing any functionality that is only available to the owner.
508      */
509     function renounceOwnership() public virtual onlyOwner {
510         _transferOwnership(address(0));
511     }
512 
513     /**
514      * @dev Transfers ownership of the contract to a new account (`newOwner`).
515      * Can only be called by the current owner.
516      */
517     function transferOwnership(address newOwner) public virtual onlyOwner {
518         require(
519             newOwner != address(0),
520             "Ownable: new owner is the zero address"
521         );
522         _transferOwnership(newOwner);
523     }
524 
525     /**
526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
527      * Internal function without access restriction.
528      */
529     function _transferOwnership(address newOwner) internal virtual {
530         address oldOwner = _owner;
531         _owner = newOwner;
532         emit OwnershipTransferred(oldOwner, newOwner);
533     }
534 }
535 
536 // File: @openzeppelin/contracts/utils/Address.sol
537 
538 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
539 
540 pragma solidity ^0.8.1;
541 
542 /**
543  * @dev Collection of functions related to the address type
544  */
545 library Address {
546     /**
547      * @dev Returns true if `account` is a contract.
548      *
549      * [IMPORTANT]
550      * ====
551      * It is unsafe to assume that an address for which this function returns
552      * false is an externally-owned account (EOA) and not a contract.
553      *
554      * Among others, `isContract` will return false for the following
555      * types of addresses:
556      *
557      *  - an externally-owned account
558      *  - a contract in construction
559      *  - an address where a contract will be created
560      *  - an address where a contract lived, but was destroyed
561      * ====
562      *
563      * [IMPORTANT]
564      * ====
565      * You shouldn't rely on `isContract` to protect against flash loan attacks!
566      *
567      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
568      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
569      * constructor.
570      * ====
571      */
572     function isContract(address account) internal view returns (bool) {
573         // This method relies on extcodesize/address.code.length, which returns 0
574         // for contracts in construction, since the code is only stored at the end
575         // of the constructor execution.
576 
577         return account.code.length > 0;
578     }
579 
580     /**
581      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
582      * `recipient`, forwarding all available gas and reverting on errors.
583      *
584      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
585      * of certain opcodes, possibly making contracts go over the 2300 gas limit
586      * imposed by `transfer`, making them unable to receive funds via
587      * `transfer`. {sendValue} removes this limitation.
588      *
589      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
590      *
591      * IMPORTANT: because control is transferred to `recipient`, care must be
592      * taken to not create reentrancy vulnerabilities. Consider using
593      * {ReentrancyGuard} or the
594      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
595      */
596     function sendValue(address payable recipient, uint256 amount) internal {
597         require(
598             address(this).balance >= amount,
599             "Address: insufficient balance"
600         );
601 
602         (bool success, ) = recipient.call{value: amount}("");
603         require(
604             success,
605             "Address: unable to send value, recipient may have reverted"
606         );
607     }
608 
609     /**
610      * @dev Performs a Solidity function call using a low level `call`. A
611      * plain `call` is an unsafe replacement for a function call: use this
612      * function instead.
613      *
614      * If `target` reverts with a revert reason, it is bubbled up by this
615      * function (like regular Solidity function calls).
616      *
617      * Returns the raw returned data. To convert to the expected return value,
618      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
619      *
620      * Requirements:
621      *
622      * - `target` must be a contract.
623      * - calling `target` with `data` must not revert.
624      *
625      * _Available since v3.1._
626      */
627     function functionCall(address target, bytes memory data)
628         internal
629         returns (bytes memory)
630     {
631         return functionCall(target, data, "Address: low-level call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
636      * `errorMessage` as a fallback revert reason when `target` reverts.
637      *
638      * _Available since v3.1._
639      */
640     function functionCall(
641         address target,
642         bytes memory data,
643         string memory errorMessage
644     ) internal returns (bytes memory) {
645         return functionCallWithValue(target, data, 0, errorMessage);
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
650      * but also transferring `value` wei to `target`.
651      *
652      * Requirements:
653      *
654      * - the calling contract must have an ETH balance of at least `value`.
655      * - the called Solidity function must be `payable`.
656      *
657      * _Available since v3.1._
658      */
659     function functionCallWithValue(
660         address target,
661         bytes memory data,
662         uint256 value
663     ) internal returns (bytes memory) {
664         return
665             functionCallWithValue(
666                 target,
667                 data,
668                 value,
669                 "Address: low-level call with value failed"
670             );
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
675      * with `errorMessage` as a fallback revert reason when `target` reverts.
676      *
677      * _Available since v3.1._
678      */
679     function functionCallWithValue(
680         address target,
681         bytes memory data,
682         uint256 value,
683         string memory errorMessage
684     ) internal returns (bytes memory) {
685         require(
686             address(this).balance >= value,
687             "Address: insufficient balance for call"
688         );
689         require(isContract(target), "Address: call to non-contract");
690 
691         (bool success, bytes memory returndata) = target.call{value: value}(
692             data
693         );
694         return verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but performing a static call.
700      *
701      * _Available since v3.3._
702      */
703     function functionStaticCall(address target, bytes memory data)
704         internal
705         view
706         returns (bytes memory)
707     {
708         return
709             functionStaticCall(
710                 target,
711                 data,
712                 "Address: low-level static call failed"
713             );
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
718      * but performing a static call.
719      *
720      * _Available since v3.3._
721      */
722     function functionStaticCall(
723         address target,
724         bytes memory data,
725         string memory errorMessage
726     ) internal view returns (bytes memory) {
727         require(isContract(target), "Address: static call to non-contract");
728 
729         (bool success, bytes memory returndata) = target.staticcall(data);
730         return verifyCallResult(success, returndata, errorMessage);
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
735      * but performing a delegate call.
736      *
737      * _Available since v3.4._
738      */
739     function functionDelegateCall(address target, bytes memory data)
740         internal
741         returns (bytes memory)
742     {
743         return
744             functionDelegateCall(
745                 target,
746                 data,
747                 "Address: low-level delegate call failed"
748             );
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
753      * but performing a delegate call.
754      *
755      * _Available since v3.4._
756      */
757     function functionDelegateCall(
758         address target,
759         bytes memory data,
760         string memory errorMessage
761     ) internal returns (bytes memory) {
762         require(isContract(target), "Address: delegate call to non-contract");
763 
764         (bool success, bytes memory returndata) = target.delegatecall(data);
765         return verifyCallResult(success, returndata, errorMessage);
766     }
767 
768     /**
769      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
770      * revert reason using the provided one.
771      *
772      * _Available since v4.3._
773      */
774     function verifyCallResult(
775         bool success,
776         bytes memory returndata,
777         string memory errorMessage
778     ) internal pure returns (bytes memory) {
779         if (success) {
780             return returndata;
781         } else {
782             // Look for revert reason and bubble it up if present
783             if (returndata.length > 0) {
784                 // The easiest way to bubble the revert reason is using memory via assembly
785                 /// @solidity memory-safe-assembly
786                 assembly {
787                     let returndata_size := mload(returndata)
788                     revert(add(32, returndata), returndata_size)
789                 }
790             } else {
791                 revert(errorMessage);
792             }
793         }
794     }
795 }
796 
797 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
798 
799 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @dev Interface of the ERC165 standard, as defined in the
805  * https://eips.ethereum.org/EIPS/eip-165[EIP].
806  *
807  * Implementers can declare support of contract interfaces, which can then be
808  * queried by others ({ERC165Checker}).
809  *
810  * For an implementation, see {ERC165}.
811  */
812 interface IERC165 {
813     /**
814      * @dev Returns true if this contract implements the interface defined by
815      * `interfaceId`. See the corresponding
816      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
817      * to learn more about how these ids are created.
818      *
819      * This function call must use less than 30 000 gas.
820      */
821     function supportsInterface(bytes4 interfaceId) external view returns (bool);
822 }
823 
824 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
825 
826 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 /**
831  * @dev Implementation of the {IERC165} interface.
832  *
833  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
834  * for the additional interface id that will be supported. For example:
835  *
836  * ```solidity
837  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
838  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
839  * }
840  * ```
841  *
842  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
843  */
844 abstract contract ERC165 is IERC165 {
845     /**
846      * @dev See {IERC165-supportsInterface}.
847      */
848     function supportsInterface(bytes4 interfaceId)
849         public
850         view
851         virtual
852         override
853         returns (bool)
854     {
855         return interfaceId == type(IERC165).interfaceId;
856     }
857 }
858 
859 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
860 
861 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
862 
863 pragma solidity ^0.8.0;
864 
865 /**
866  * @dev _Available since v3.1._
867  */
868 interface IERC1155Receiver is IERC165 {
869     /**
870      * @dev Handles the receipt of a single ERC1155 token type. This function is
871      * called at the end of a `safeTransferFrom` after the balance has been updated.
872      *
873      * NOTE: To accept the transfer, this must return
874      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
875      * (i.e. 0xf23a6e61, or its own function selector).
876      *
877      * @param operator The address which initiated the transfer (i.e. msg.sender)
878      * @param from The address which previously owned the token
879      * @param id The ID of the token being transferred
880      * @param value The amount of tokens being transferred
881      * @param data Additional data with no specified format
882      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
883      */
884     function onERC1155Received(
885         address operator,
886         address from,
887         uint256 id,
888         uint256 value,
889         bytes calldata data
890     ) external returns (bytes4);
891 
892     /**
893      * @dev Handles the receipt of a multiple ERC1155 token types. This function
894      * is called at the end of a `safeBatchTransferFrom` after the balances have
895      * been updated.
896      *
897      * NOTE: To accept the transfer(s), this must return
898      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
899      * (i.e. 0xbc197c81, or its own function selector).
900      *
901      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
902      * @param from The address which previously owned the token
903      * @param ids An array containing ids of each token being transferred (order and length must match values array)
904      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
905      * @param data Additional data with no specified format
906      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
907      */
908     function onERC1155BatchReceived(
909         address operator,
910         address from,
911         uint256[] calldata ids,
912         uint256[] calldata values,
913         bytes calldata data
914     ) external returns (bytes4);
915 }
916 
917 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
918 
919 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
920 
921 pragma solidity ^0.8.0;
922 
923 /**
924  * @dev Required interface of an ERC1155 compliant contract, as defined in the
925  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
926  *
927  * _Available since v3.1._
928  */
929 interface IERC1155 is IERC165 {
930     /**
931      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
932      */
933     event TransferSingle(
934         address indexed operator,
935         address indexed from,
936         address indexed to,
937         uint256 id,
938         uint256 value
939     );
940 
941     /**
942      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
943      * transfers.
944      */
945     event TransferBatch(
946         address indexed operator,
947         address indexed from,
948         address indexed to,
949         uint256[] ids,
950         uint256[] values
951     );
952 
953     /**
954      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
955      * `approved`.
956      */
957     event ApprovalForAll(
958         address indexed account,
959         address indexed operator,
960         bool approved
961     );
962 
963     /**
964      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
965      *
966      * If an {URI} event was emitted for `id`, the standard
967      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
968      * returned by {IERC1155MetadataURI-uri}.
969      */
970     event URI(string value, uint256 indexed id);
971 
972     /**
973      * @dev Returns the amount of tokens of token type `id` owned by `account`.
974      *
975      * Requirements:
976      *
977      * - `account` cannot be the zero address.
978      */
979     function balanceOf(address account, uint256 id)
980         external
981         view
982         returns (uint256);
983 
984     /**
985      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
986      *
987      * Requirements:
988      *
989      * - `accounts` and `ids` must have the same length.
990      */
991     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
992         external
993         view
994         returns (uint256[] memory);
995 
996     /**
997      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
998      *
999      * Emits an {ApprovalForAll} event.
1000      *
1001      * Requirements:
1002      *
1003      * - `operator` cannot be the caller.
1004      */
1005     function setApprovalForAll(address operator, bool approved) external;
1006 
1007     /**
1008      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1009      *
1010      * See {setApprovalForAll}.
1011      */
1012     function isApprovedForAll(address account, address operator)
1013         external
1014         view
1015         returns (bool);
1016 
1017     /**
1018      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1019      *
1020      * Emits a {TransferSingle} event.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1026      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1027      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1028      * acceptance magic value.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 id,
1034         uint256 amount,
1035         bytes calldata data
1036     ) external;
1037 
1038     /**
1039      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1040      *
1041      * Emits a {TransferBatch} event.
1042      *
1043      * Requirements:
1044      *
1045      * - `ids` and `amounts` must have the same length.
1046      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1047      * acceptance magic value.
1048      */
1049     function safeBatchTransferFrom(
1050         address from,
1051         address to,
1052         uint256[] calldata ids,
1053         uint256[] calldata amounts,
1054         bytes calldata data
1055     ) external;
1056 }
1057 
1058 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1059 
1060 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 /**
1065  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1066  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1067  *
1068  * _Available since v3.1._
1069  */
1070 interface IERC1155MetadataURI is IERC1155 {
1071     /**
1072      * @dev Returns the URI for token type `id`.
1073      *
1074      * If the `\{id\}` substring is present in the URI, it must be replaced by
1075      * clients with the actual token type ID.
1076      */
1077     function uri(uint256 id) external view returns (string memory);
1078 }
1079 
1080 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1081 
1082 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1083 
1084 pragma solidity ^0.8.0;
1085 
1086 /**
1087  * @dev Implementation of the basic standard multi-token.
1088  * See https://eips.ethereum.org/EIPS/eip-1155
1089  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1090  *
1091  * _Available since v3.1._
1092  */
1093 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1094     using Address for address;
1095 
1096     // Mapping from token ID to account balances
1097     mapping(uint256 => mapping(address => uint256)) private _balances;
1098 
1099     // Mapping from account to operator approvals
1100     mapping(address => mapping(address => bool)) private _operatorApprovals;
1101 
1102     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1103     string private _uri;
1104 
1105     /**
1106      * @dev See {_setURI}.
1107      */
1108     constructor(string memory uri_) {
1109         _setURI(uri_);
1110     }
1111 
1112     /**
1113      * @dev See {IERC165-supportsInterface}.
1114      */
1115     function supportsInterface(bytes4 interfaceId)
1116         public
1117         view
1118         virtual
1119         override(ERC165, IERC165)
1120         returns (bool)
1121     {
1122         return
1123             interfaceId == type(IERC1155).interfaceId ||
1124             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1125             super.supportsInterface(interfaceId);
1126     }
1127 
1128     /**
1129      * @dev See {IERC1155MetadataURI-uri}.
1130      *
1131      * This implementation returns the same URI for *all* token types. It relies
1132      * on the token type ID substitution mechanism
1133      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1134      *
1135      * Clients calling this function must replace the `\{id\}` substring with the
1136      * actual token type ID.
1137      */
1138     function uri(uint256) public view virtual override returns (string memory) {
1139         return _uri;
1140     }
1141 
1142     /**
1143      * @dev See {IERC1155-balanceOf}.
1144      *
1145      * Requirements:
1146      *
1147      * - `account` cannot be the zero address.
1148      */
1149     function balanceOf(address account, uint256 id)
1150         public
1151         view
1152         virtual
1153         override
1154         returns (uint256)
1155     {
1156         require(
1157             account != address(0),
1158             "ERC1155: address zero is not a valid owner"
1159         );
1160         return _balances[id][account];
1161     }
1162 
1163     /**
1164      * @dev See {IERC1155-balanceOfBatch}.
1165      *
1166      * Requirements:
1167      *
1168      * - `accounts` and `ids` must have the same length.
1169      */
1170     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1171         public
1172         view
1173         virtual
1174         override
1175         returns (uint256[] memory)
1176     {
1177         require(
1178             accounts.length == ids.length,
1179             "ERC1155: accounts and ids length mismatch"
1180         );
1181 
1182         uint256[] memory batchBalances = new uint256[](accounts.length);
1183 
1184         for (uint256 i = 0; i < accounts.length; ++i) {
1185             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1186         }
1187 
1188         return batchBalances;
1189     }
1190 
1191     /**
1192      * @dev See {IERC1155-setApprovalForAll}.
1193      */
1194     function setApprovalForAll(address operator, bool approved)
1195         public
1196         virtual
1197         override
1198     {
1199         _setApprovalForAll(_msgSender(), operator, approved);
1200     }
1201 
1202     /**
1203      * @dev See {IERC1155-isApprovedForAll}.
1204      */
1205     function isApprovedForAll(address account, address operator)
1206         public
1207         view
1208         virtual
1209         override
1210         returns (bool)
1211     {
1212         return _operatorApprovals[account][operator];
1213     }
1214 
1215     /**
1216      * @dev See {IERC1155-safeTransferFrom}.
1217      */
1218     function safeTransferFrom(
1219         address from,
1220         address to,
1221         uint256 id,
1222         uint256 amount,
1223         bytes memory data
1224     ) public virtual override {
1225         require(
1226             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1227             "ERC1155: caller is not token owner nor approved"
1228         );
1229         _safeTransferFrom(from, to, id, amount, data);
1230     }
1231 
1232     /**
1233      * @dev See {IERC1155-safeBatchTransferFrom}.
1234      */
1235     function safeBatchTransferFrom(
1236         address from,
1237         address to,
1238         uint256[] memory ids,
1239         uint256[] memory amounts,
1240         bytes memory data
1241     ) public virtual override {
1242         require(
1243             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1244             "ERC1155: caller is not token owner nor approved"
1245         );
1246         _safeBatchTransferFrom(from, to, ids, amounts, data);
1247     }
1248 
1249     /**
1250      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1251      *
1252      * Emits a {TransferSingle} event.
1253      *
1254      * Requirements:
1255      *
1256      * - `to` cannot be the zero address.
1257      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1258      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1259      * acceptance magic value.
1260      */
1261     function _safeTransferFrom(
1262         address from,
1263         address to,
1264         uint256 id,
1265         uint256 amount,
1266         bytes memory data
1267     ) internal virtual {
1268         require(to != address(0), "ERC1155: transfer to the zero address");
1269 
1270         address operator = _msgSender();
1271         uint256[] memory ids = _asSingletonArray(id);
1272         uint256[] memory amounts = _asSingletonArray(amount);
1273 
1274         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1275 
1276         uint256 fromBalance = _balances[id][from];
1277         require(
1278             fromBalance >= amount,
1279             "ERC1155: insufficient balance for transfer"
1280         );
1281         unchecked {
1282             _balances[id][from] = fromBalance - amount;
1283         }
1284         _balances[id][to] += amount;
1285 
1286         emit TransferSingle(operator, from, to, id, amount);
1287 
1288         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1289 
1290         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1291     }
1292 
1293     /**
1294      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1295      *
1296      * Emits a {TransferBatch} event.
1297      *
1298      * Requirements:
1299      *
1300      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1301      * acceptance magic value.
1302      */
1303     function _safeBatchTransferFrom(
1304         address from,
1305         address to,
1306         uint256[] memory ids,
1307         uint256[] memory amounts,
1308         bytes memory data
1309     ) internal virtual {
1310         require(
1311             ids.length == amounts.length,
1312             "ERC1155: ids and amounts length mismatch"
1313         );
1314         require(to != address(0), "ERC1155: transfer to the zero address");
1315 
1316         address operator = _msgSender();
1317 
1318         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1319 
1320         for (uint256 i = 0; i < ids.length; ++i) {
1321             uint256 id = ids[i];
1322             uint256 amount = amounts[i];
1323 
1324             uint256 fromBalance = _balances[id][from];
1325             require(
1326                 fromBalance >= amount,
1327                 "ERC1155: insufficient balance for transfer"
1328             );
1329             unchecked {
1330                 _balances[id][from] = fromBalance - amount;
1331             }
1332             _balances[id][to] += amount;
1333         }
1334 
1335         emit TransferBatch(operator, from, to, ids, amounts);
1336 
1337         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1338 
1339         _doSafeBatchTransferAcceptanceCheck(
1340             operator,
1341             from,
1342             to,
1343             ids,
1344             amounts,
1345             data
1346         );
1347     }
1348 
1349     /**
1350      * @dev Sets a new URI for all token types, by relying on the token type ID
1351      * substitution mechanism
1352      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1353      *
1354      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1355      * URI or any of the amounts in the JSON file at said URI will be replaced by
1356      * clients with the token type ID.
1357      *
1358      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1359      * interpreted by clients as
1360      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1361      * for token type ID 0x4cce0.
1362      *
1363      * See {uri}.
1364      *
1365      * Because these URIs cannot be meaningfully represented by the {URI} event,
1366      * this function emits no events.
1367      */
1368     function _setURI(string memory newuri) internal virtual {
1369         _uri = newuri;
1370     }
1371 
1372     /**
1373      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1374      *
1375      * Emits a {TransferSingle} event.
1376      *
1377      * Requirements:
1378      *
1379      * - `to` cannot be the zero address.
1380      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1381      * acceptance magic value.
1382      */
1383     function _mint(
1384         address to,
1385         uint256 id,
1386         uint256 amount,
1387         bytes memory data
1388     ) internal virtual {
1389         require(to != address(0), "ERC1155: mint to the zero address");
1390 
1391         address operator = _msgSender();
1392         uint256[] memory ids = _asSingletonArray(id);
1393         uint256[] memory amounts = _asSingletonArray(amount);
1394 
1395         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1396 
1397         _balances[id][to] += amount;
1398         emit TransferSingle(operator, address(0), to, id, amount);
1399 
1400         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1401 
1402         _doSafeTransferAcceptanceCheck(
1403             operator,
1404             address(0),
1405             to,
1406             id,
1407             amount,
1408             data
1409         );
1410     }
1411 
1412     /**
1413      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1414      *
1415      * Emits a {TransferBatch} event.
1416      *
1417      * Requirements:
1418      *
1419      * - `ids` and `amounts` must have the same length.
1420      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1421      * acceptance magic value.
1422      */
1423     function _mintBatch(
1424         address to,
1425         uint256[] memory ids,
1426         uint256[] memory amounts,
1427         bytes memory data
1428     ) internal virtual {
1429         require(to != address(0), "ERC1155: mint to the zero address");
1430         require(
1431             ids.length == amounts.length,
1432             "ERC1155: ids and amounts length mismatch"
1433         );
1434 
1435         address operator = _msgSender();
1436 
1437         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1438 
1439         for (uint256 i = 0; i < ids.length; i++) {
1440             _balances[ids[i]][to] += amounts[i];
1441         }
1442 
1443         emit TransferBatch(operator, address(0), to, ids, amounts);
1444 
1445         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1446 
1447         _doSafeBatchTransferAcceptanceCheck(
1448             operator,
1449             address(0),
1450             to,
1451             ids,
1452             amounts,
1453             data
1454         );
1455     }
1456 
1457     /**
1458      * @dev Destroys `amount` tokens of token type `id` from `from`
1459      *
1460      * Emits a {TransferSingle} event.
1461      *
1462      * Requirements:
1463      *
1464      * - `from` cannot be the zero address.
1465      * - `from` must have at least `amount` tokens of token type `id`.
1466      */
1467     function _burn(
1468         address from,
1469         uint256 id,
1470         uint256 amount
1471     ) internal virtual {
1472         require(from != address(0), "ERC1155: burn from the zero address");
1473 
1474         address operator = _msgSender();
1475         uint256[] memory ids = _asSingletonArray(id);
1476         uint256[] memory amounts = _asSingletonArray(amount);
1477 
1478         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1479 
1480         uint256 fromBalance = _balances[id][from];
1481         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1482         unchecked {
1483             _balances[id][from] = fromBalance - amount;
1484         }
1485 
1486         emit TransferSingle(operator, from, address(0), id, amount);
1487 
1488         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1489     }
1490 
1491     /**
1492      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1493      *
1494      * Emits a {TransferBatch} event.
1495      *
1496      * Requirements:
1497      *
1498      * - `ids` and `amounts` must have the same length.
1499      */
1500     function _burnBatch(
1501         address from,
1502         uint256[] memory ids,
1503         uint256[] memory amounts
1504     ) internal virtual {
1505         require(from != address(0), "ERC1155: burn from the zero address");
1506         require(
1507             ids.length == amounts.length,
1508             "ERC1155: ids and amounts length mismatch"
1509         );
1510 
1511         address operator = _msgSender();
1512 
1513         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1514 
1515         for (uint256 i = 0; i < ids.length; i++) {
1516             uint256 id = ids[i];
1517             uint256 amount = amounts[i];
1518 
1519             uint256 fromBalance = _balances[id][from];
1520             require(
1521                 fromBalance >= amount,
1522                 "ERC1155: burn amount exceeds balance"
1523             );
1524             unchecked {
1525                 _balances[id][from] = fromBalance - amount;
1526             }
1527         }
1528 
1529         emit TransferBatch(operator, from, address(0), ids, amounts);
1530 
1531         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1532     }
1533 
1534     /**
1535      * @dev Approve `operator` to operate on all of `owner` tokens
1536      *
1537      * Emits an {ApprovalForAll} event.
1538      */
1539     function _setApprovalForAll(
1540         address owner,
1541         address operator,
1542         bool approved
1543     ) internal virtual {
1544         require(owner != operator, "ERC1155: setting approval status for self");
1545         _operatorApprovals[owner][operator] = approved;
1546         emit ApprovalForAll(owner, operator, approved);
1547     }
1548 
1549     /**
1550      * @dev Hook that is called before any token transfer. This includes minting
1551      * and burning, as well as batched variants.
1552      *
1553      * The same hook is called on both single and batched variants. For single
1554      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1555      *
1556      * Calling conditions (for each `id` and `amount` pair):
1557      *
1558      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1559      * of token type `id` will be  transferred to `to`.
1560      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1561      * for `to`.
1562      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1563      * will be burned.
1564      * - `from` and `to` are never both zero.
1565      * - `ids` and `amounts` have the same, non-zero length.
1566      *
1567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1568      */
1569     function _beforeTokenTransfer(
1570         address operator,
1571         address from,
1572         address to,
1573         uint256[] memory ids,
1574         uint256[] memory amounts,
1575         bytes memory data
1576     ) internal virtual {}
1577 
1578     /**
1579      * @dev Hook that is called after any token transfer. This includes minting
1580      * and burning, as well as batched variants.
1581      *
1582      * The same hook is called on both single and batched variants. For single
1583      * transfers, the length of the `id` and `amount` arrays will be 1.
1584      *
1585      * Calling conditions (for each `id` and `amount` pair):
1586      *
1587      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1588      * of token type `id` will be  transferred to `to`.
1589      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1590      * for `to`.
1591      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1592      * will be burned.
1593      * - `from` and `to` are never both zero.
1594      * - `ids` and `amounts` have the same, non-zero length.
1595      *
1596      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1597      */
1598     function _afterTokenTransfer(
1599         address operator,
1600         address from,
1601         address to,
1602         uint256[] memory ids,
1603         uint256[] memory amounts,
1604         bytes memory data
1605     ) internal virtual {}
1606 
1607     function _doSafeTransferAcceptanceCheck(
1608         address operator,
1609         address from,
1610         address to,
1611         uint256 id,
1612         uint256 amount,
1613         bytes memory data
1614     ) private {
1615         if (to.isContract()) {
1616             try
1617                 IERC1155Receiver(to).onERC1155Received(
1618                     operator,
1619                     from,
1620                     id,
1621                     amount,
1622                     data
1623                 )
1624             returns (bytes4 response) {
1625                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1626                     revert("ERC1155: ERC1155Receiver rejected tokens");
1627                 }
1628             } catch Error(string memory reason) {
1629                 revert(reason);
1630             } catch {
1631                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1632             }
1633         }
1634     }
1635 
1636     function _doSafeBatchTransferAcceptanceCheck(
1637         address operator,
1638         address from,
1639         address to,
1640         uint256[] memory ids,
1641         uint256[] memory amounts,
1642         bytes memory data
1643     ) private {
1644         if (to.isContract()) {
1645             try
1646                 IERC1155Receiver(to).onERC1155BatchReceived(
1647                     operator,
1648                     from,
1649                     ids,
1650                     amounts,
1651                     data
1652                 )
1653             returns (bytes4 response) {
1654                 if (
1655                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1656                 ) {
1657                     revert("ERC1155: ERC1155Receiver rejected tokens");
1658                 }
1659             } catch Error(string memory reason) {
1660                 revert(reason);
1661             } catch {
1662                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1663             }
1664         }
1665     }
1666 
1667     function _asSingletonArray(uint256 element)
1668         private
1669         pure
1670         returns (uint256[] memory)
1671     {
1672         uint256[] memory array = new uint256[](1);
1673         array[0] = element;
1674 
1675         return array;
1676     }
1677 }
1678 
1679 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1680 
1681 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1682 
1683 pragma solidity ^0.8.0;
1684 
1685 /**
1686  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1687  *
1688  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1689  * clearly identified. Note: While a totalSupply of 1 might mean the
1690  * corresponding is an NFT, there is no guarantees that no other token with the
1691  * same id are not going to be minted.
1692  */
1693 abstract contract ERC1155Supply is ERC1155 {
1694     mapping(uint256 => uint256) private _totalSupply;
1695 
1696     /**
1697      * @dev Total amount of tokens in with a given id.
1698      */
1699     function totalSupply(uint256 id) public view virtual returns (uint256) {
1700         return _totalSupply[id];
1701     }
1702 
1703     /**
1704      * @dev Indicates whether any token exist with a given id, or not.
1705      */
1706     function exists(uint256 id) public view virtual returns (bool) {
1707         return ERC1155Supply.totalSupply(id) > 0;
1708     }
1709 
1710     /**
1711      * @dev See {ERC1155-_beforeTokenTransfer}.
1712      */
1713     function _beforeTokenTransfer(
1714         address operator,
1715         address from,
1716         address to,
1717         uint256[] memory ids,
1718         uint256[] memory amounts,
1719         bytes memory data
1720     ) internal virtual override {
1721         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1722 
1723         if (from == address(0)) {
1724             for (uint256 i = 0; i < ids.length; ++i) {
1725                 _totalSupply[ids[i]] += amounts[i];
1726             }
1727         }
1728 
1729         if (to == address(0)) {
1730             for (uint256 i = 0; i < ids.length; ++i) {
1731                 uint256 id = ids[i];
1732                 uint256 amount = amounts[i];
1733                 uint256 supply = _totalSupply[id];
1734                 require(
1735                     supply >= amount,
1736                     "ERC1155: burn amount exceeds totalSupply"
1737                 );
1738                 unchecked {
1739                     _totalSupply[id] = supply - amount;
1740                 }
1741             }
1742         }
1743     }
1744 }
1745 
1746 // File: contracts/stayhuman.sol
1747 
1748 pragma solidity ^0.8.2;
1749 
1750 contract StayhumanGenesis is
1751     ERC1155,
1752     Ownable,
1753     ERC1155Supply,
1754     DefaultOperatorFilterer
1755 {
1756     uint256 public price = 0.08 ether;
1757     uint256 public maxSupply = 333;
1758     bool public presaleActive = false;
1759     bool public phaseTwoActive = false;
1760     bool public saleActive = false;
1761     uint256 public maxPublicPerWallet = 1;
1762     uint256 public activeTokenID = 1;
1763     bytes32 public whitelistRoot;
1764     address private founderWallet = 0x86c4A74e1283AA79504183A8DAF1B4F4D424b9F7;
1765     address private wallet2 = 0x3BdC8d36c45b2eD12B6038fDFEd63cA9F8D5C70e; //Dev Wallet
1766     bytes32 public raffleRoot;
1767     string public name = "StayHuman Genesis";
1768 
1769     mapping(address => bool) public whitelistMinted;
1770     mapping(address => uint256) public numberMinted;
1771 
1772     constructor() ERC1155("ipfs://QmXW9pnARLHFegbWH8ue611j7PYV2KuL6NaVK965ummxRb") {}
1773 
1774     function mintWhitelist(bytes32[] calldata _merkleProof) public payable {
1775         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1776 
1777         require(msg.value >= price, "Send correct amount");
1778         require(presaleActive, "Sale is not active");
1779         require(
1780             totalSupply(activeTokenID) + 1 <= maxSupply,
1781             "Purchase would exceed max supply"
1782         );
1783         require(!whitelistMinted[msg.sender], "Whitelist has already claimed");
1784 
1785         require(
1786             MerkleProof.verify(_merkleProof, whitelistRoot, leaf),
1787             "Invalid proof"
1788         );
1789 
1790         whitelistMinted[msg.sender] = true;
1791         _mint(msg.sender, activeTokenID, 1, "");
1792     }
1793 
1794     function mintSecondPhase(bytes32[] calldata _merkleProof) public payable {
1795         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1796 
1797         require(msg.value >= price, "Send correct amount");
1798         require(phaseTwoActive, "Sale is not active");
1799         require(
1800             totalSupply(activeTokenID) + 1 <= maxSupply,
1801             "Purchase would exceed max supply"
1802         );
1803         require(!whitelistMinted[msg.sender], "Whitelist has already claimed");
1804 
1805         require(
1806             MerkleProof.verify(_merkleProof, raffleRoot, leaf),
1807             "Invalid proof"
1808         );
1809 
1810         whitelistMinted[msg.sender] = true;
1811         _mint(msg.sender, activeTokenID, 1, "");
1812     }
1813 
1814     // If necessary
1815     function publicMint(uint256 amount) public payable {
1816         require(msg.value >= amount * price, "Send correct amount");
1817         require(saleActive, "Sale is not active");
1818         require(amount > 0, "Amount must be positive integer");
1819         require(
1820             totalSupply(activeTokenID) + amount <= maxSupply,
1821             "Purchase would exceed max supply"
1822         );
1823         require(
1824             numberMinted[msg.sender] + amount <= maxPublicPerWallet,
1825             "Max per wallet reached"
1826         );
1827         numberMinted[msg.sender] += amount;
1828 
1829         _mint(msg.sender, activeTokenID, amount, "");
1830     }
1831 
1832     function isWhitelistMinted(address minter) external view returns (bool) {
1833         return whitelistMinted[minter];
1834     }
1835 
1836     function getNumberMintedPublic(address minter)
1837         external
1838         view
1839         returns (uint256)
1840     {
1841         return numberMinted[minter];
1842     }
1843 
1844     function setPresaleStatus(bool _presaleActive) public onlyOwner {
1845         presaleActive = _presaleActive;
1846     }
1847 
1848     function setSecondPhase(bool _secondPhase) public onlyOwner {
1849         presaleActive = !presaleActive;
1850         phaseTwoActive = _secondPhase;
1851     }
1852 
1853     function setMaxPublic(uint256 _amount) public onlyOwner {
1854         maxPublicPerWallet = _amount;
1855     }
1856 
1857     function setSaleStatus(bool _saleActive) public onlyOwner {
1858         saleActive = _saleActive;
1859     }
1860 
1861     function setPrice(uint256 _price) public onlyOwner {
1862         price = _price;
1863     }
1864 
1865     function setWhitelistRoot(bytes32 _presaleRoot, bytes32 _raffleRoot)
1866         external
1867         onlyOwner
1868     {
1869         whitelistRoot = _presaleRoot;
1870         raffleRoot = _raffleRoot;
1871     }
1872 
1873     function setURI(string memory newuri) public onlyOwner {
1874         _setURI(newuri);
1875     }
1876 
1877     function airdrop(address[] calldata receivers) public onlyOwner {
1878         require(receivers.length > 0, "Need at least one address");
1879         for (uint256 i; i < receivers.length; ++i) {
1880             _mint(receivers[i], activeTokenID, 1, "");
1881         }
1882     }
1883 
1884  function withdraw() external onlyOwner {
1885         uint256 balance = address(this).balance;
1886         uint256 balance2 = (balance * 934) / 1000;
1887         uint256 balance3 = (balance * 66) / 1000;
1888 
1889         payable(founderWallet).transfer(balance2);
1890         payable(wallet2).transfer(balance3);
1891     }
1892 
1893     // Required overwrite function by solidity
1894     function _beforeTokenTransfer(
1895         address operator,
1896         address from,
1897         address to,
1898         uint256[] memory ids,
1899         uint256[] memory amounts,
1900         bytes memory data
1901     ) internal override(ERC1155, ERC1155Supply) {
1902         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1903     }
1904 
1905     // Opensea Filtering things
1906     function setApprovalForAll(address operator, bool approved)
1907         public
1908         override
1909         onlyAllowedOperatorApproval(operator)
1910     {
1911         super.setApprovalForAll(operator, approved);
1912     }
1913 
1914     function safeTransferFrom(
1915         address from,
1916         address to,
1917         uint256 tokenId,
1918         uint256 amount,
1919         bytes memory data
1920     ) public override onlyAllowedOperator(from) {
1921         super.safeTransferFrom(from, to, tokenId, amount, data);
1922     }
1923 
1924     function safeBatchTransferFrom(
1925         address from,
1926         address to,
1927         uint256[] memory ids,
1928         uint256[] memory amounts,
1929         bytes memory data
1930     ) public virtual override onlyAllowedOperator(from) {
1931         super.safeBatchTransferFrom(from, to, ids, amounts, data);
1932     }
1933 }