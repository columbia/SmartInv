1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * _Available since v4.7._
85      */
86     function multiProofVerify(
87         bytes32[] memory proof,
88         bool[] memory proofFlags,
89         bytes32 root,
90         bytes32[] memory leaves
91     ) internal pure returns (bool) {
92         return processMultiProof(proof, proofFlags, leaves) == root;
93     }
94 
95     /**
96      * @dev Calldata version of {multiProofVerify}
97      *
98      * _Available since v4.7._
99      */
100     function multiProofVerifyCalldata(
101         bytes32[] calldata proof,
102         bool[] calldata proofFlags,
103         bytes32 root,
104         bytes32[] memory leaves
105     ) internal pure returns (bool) {
106         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
107     }
108 
109     /**
110      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
111      * consuming from one or the other at each step according to the instructions given by
112      * `proofFlags`.
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 totalHashes = proofFlags.length;
127 
128         // Check proof validity.
129         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
130 
131         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
132         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
133         bytes32[] memory hashes = new bytes32[](totalHashes);
134         uint256 leafPos = 0;
135         uint256 hashPos = 0;
136         uint256 proofPos = 0;
137         // At each step, we compute the next hash using two values:
138         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
139         //   get the next hash.
140         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
141         //   `proof` array.
142         for (uint256 i = 0; i < totalHashes; i++) {
143             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
144             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
145             hashes[i] = _hashPair(a, b);
146         }
147 
148         if (totalHashes > 0) {
149             return hashes[totalHashes - 1];
150         } else if (leavesLen > 0) {
151             return leaves[0];
152         } else {
153             return proof[0];
154         }
155     }
156 
157     /**
158      * @dev Calldata version of {processMultiProof}
159      *
160      * _Available since v4.7._
161      */
162     function processMultiProofCalldata(
163         bytes32[] calldata proof,
164         bool[] calldata proofFlags,
165         bytes32[] memory leaves
166     ) internal pure returns (bytes32 merkleRoot) {
167         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
168         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
169         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
170         // the merkle tree.
171         uint256 leavesLen = leaves.length;
172         uint256 totalHashes = proofFlags.length;
173 
174         // Check proof validity.
175         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
176 
177         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
178         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
179         bytes32[] memory hashes = new bytes32[](totalHashes);
180         uint256 leafPos = 0;
181         uint256 hashPos = 0;
182         uint256 proofPos = 0;
183         // At each step, we compute the next hash using two values:
184         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
185         //   get the next hash.
186         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
187         //   `proof` array.
188         for (uint256 i = 0; i < totalHashes; i++) {
189             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
190             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
191             hashes[i] = _hashPair(a, b);
192         }
193 
194         if (totalHashes > 0) {
195             return hashes[totalHashes - 1];
196         } else if (leavesLen > 0) {
197             return leaves[0];
198         } else {
199             return proof[0];
200         }
201     }
202 
203     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
204         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
205     }
206 
207     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
208         /// @solidity memory-safe-assembly
209         assembly {
210             mstore(0x00, a)
211             mstore(0x20, b)
212             value := keccak256(0x00, 0x40)
213         }
214     }
215 }
216 
217 // File: @openzeppelin/contracts/utils/Counters.sol
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @title Counters
226  * @author Matt Condon (@shrugs)
227  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
228  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
229  *
230  * Include with `using Counters for Counters.Counter;`
231  */
232 library Counters {
233     struct Counter {
234         // This variable should never be directly accessed by users of the library: interactions must be restricted to
235         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
236         // this feature: see https://github.com/ethereum/solidity/issues/4637
237         uint256 _value; // default: 0
238     }
239 
240     function current(Counter storage counter) internal view returns (uint256) {
241         return counter._value;
242     }
243 
244     function increment(Counter storage counter) internal {
245         unchecked {
246             counter._value += 1;
247         }
248     }
249 
250     function decrement(Counter storage counter) internal {
251         uint256 value = counter._value;
252         require(value > 0, "Counter: decrement overflow");
253         unchecked {
254             counter._value = value - 1;
255         }
256     }
257 
258     function reset(Counter storage counter) internal {
259         counter._value = 0;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev Contract module that helps prevent reentrant calls to a function.
272  *
273  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
274  * available, which can be applied to functions to make sure there are no nested
275  * (reentrant) calls to them.
276  *
277  * Note that because there is a single `nonReentrant` guard, functions marked as
278  * `nonReentrant` may not call one another. This can be worked around by making
279  * those functions `private`, and then adding `external` `nonReentrant` entry
280  * points to them.
281  *
282  * TIP: If you would like to learn more about reentrancy and alternative ways
283  * to protect against it, check out our blog post
284  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
285  */
286 abstract contract ReentrancyGuard {
287     // Booleans are more expensive than uint256 or any type that takes up a full
288     // word because each write operation emits an extra SLOAD to first read the
289     // slot's contents, replace the bits taken up by the boolean, and then write
290     // back. This is the compiler's defense against contract upgrades and
291     // pointer aliasing, and it cannot be disabled.
292 
293     // The values being non-zero value makes deployment a bit more expensive,
294     // but in exchange the refund on every call to nonReentrant will be lower in
295     // amount. Since refunds are capped to a percentage of the total
296     // transaction's gas, it is best to keep them low in cases like this one, to
297     // increase the likelihood of the full refund coming into effect.
298     uint256 private constant _NOT_ENTERED = 1;
299     uint256 private constant _ENTERED = 2;
300 
301     uint256 private _status;
302 
303     constructor() {
304         _status = _NOT_ENTERED;
305     }
306 
307     /**
308      * @dev Prevents a contract from calling itself, directly or indirectly.
309      * Calling a `nonReentrant` function from another `nonReentrant`
310      * function is not supported. It is possible to prevent this from happening
311      * by making the `nonReentrant` function external, and making it call a
312      * `private` function that does the actual work.
313      */
314     modifier nonReentrant() {
315         // On the first call to nonReentrant, _notEntered will be true
316         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
317 
318         // Any calls to nonReentrant after this point will fail
319         _status = _ENTERED;
320 
321         _;
322 
323         // By storing the original value once again, a refund is triggered (see
324         // https://eips.ethereum.org/EIPS/eip-2200)
325         _status = _NOT_ENTERED;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/utils/Strings.sol
330 
331 
332 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev String operations.
338  */
339 library Strings {
340     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
341     uint8 private constant _ADDRESS_LENGTH = 20;
342 
343     /**
344      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
345      */
346     function toString(uint256 value) internal pure returns (string memory) {
347         // Inspired by OraclizeAPI's implementation - MIT licence
348         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
349 
350         if (value == 0) {
351             return "0";
352         }
353         uint256 temp = value;
354         uint256 digits;
355         while (temp != 0) {
356             digits++;
357             temp /= 10;
358         }
359         bytes memory buffer = new bytes(digits);
360         while (value != 0) {
361             digits -= 1;
362             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
363             value /= 10;
364         }
365         return string(buffer);
366     }
367 
368     /**
369      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
370      */
371     function toHexString(uint256 value) internal pure returns (string memory) {
372         if (value == 0) {
373             return "0x00";
374         }
375         uint256 temp = value;
376         uint256 length = 0;
377         while (temp != 0) {
378             length++;
379             temp >>= 8;
380         }
381         return toHexString(value, length);
382     }
383 
384     /**
385      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
386      */
387     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
388         bytes memory buffer = new bytes(2 * length + 2);
389         buffer[0] = "0";
390         buffer[1] = "x";
391         for (uint256 i = 2 * length + 1; i > 1; --i) {
392             buffer[i] = _HEX_SYMBOLS[value & 0xf];
393             value >>= 4;
394         }
395         require(value == 0, "Strings: hex length insufficient");
396         return string(buffer);
397     }
398 
399     /**
400      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
401      */
402     function toHexString(address addr) internal pure returns (string memory) {
403         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
404     }
405 }
406 
407 // File: @openzeppelin/contracts/utils/Context.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 /**
415  * @dev Provides information about the current execution context, including the
416  * sender of the transaction and its data. While these are generally available
417  * via msg.sender and msg.data, they should not be accessed in such a direct
418  * manner, since when dealing with meta-transactions the account sending and
419  * paying for execution may not be the actual sender (as far as an application
420  * is concerned).
421  *
422  * This contract is only required for intermediate, library-like contracts.
423  */
424 abstract contract Context {
425     function _msgSender() internal view virtual returns (address) {
426         return msg.sender;
427     }
428 
429     function _msgData() internal view virtual returns (bytes calldata) {
430         return msg.data;
431     }
432 }
433 
434 // File: @openzeppelin/contracts/access/Ownable.sol
435 
436 
437 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 
442 /**
443  * @dev Contract module which provides a basic access control mechanism, where
444  * there is an account (an owner) that can be granted exclusive access to
445  * specific functions.
446  *
447  * By default, the owner account will be the one that deploys the contract. This
448  * can later be changed with {transferOwnership}.
449  *
450  * This module is used through inheritance. It will make available the modifier
451  * `onlyOwner`, which can be applied to your functions to restrict their use to
452  * the owner.
453  */
454 abstract contract Ownable is Context {
455     address private _owner;
456 
457     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
458 
459     /**
460      * @dev Initializes the contract setting the deployer as the initial owner.
461      */
462     constructor() {
463         _transferOwnership(_msgSender());
464     }
465 
466     /**
467      * @dev Throws if called by any account other than the owner.
468      */
469     modifier onlyOwner() {
470         _checkOwner();
471         _;
472     }
473 
474     /**
475      * @dev Returns the address of the current owner.
476      */
477     function owner() public view virtual returns (address) {
478         return _owner;
479     }
480 
481     /**
482      * @dev Throws if the sender is not the owner.
483      */
484     function _checkOwner() internal view virtual {
485         require(owner() == _msgSender(), "Ownable: caller is not the owner");
486     }
487 
488     /**
489      * @dev Leaves the contract without owner. It will not be possible to call
490      * `onlyOwner` functions anymore. Can only be called by the current owner.
491      *
492      * NOTE: Renouncing ownership will leave the contract without an owner,
493      * thereby removing any functionality that is only available to the owner.
494      */
495     function renounceOwnership() public virtual onlyOwner {
496         _transferOwnership(address(0));
497     }
498 
499     /**
500      * @dev Transfers ownership of the contract to a new account (`newOwner`).
501      * Can only be called by the current owner.
502      */
503     function transferOwnership(address newOwner) public virtual onlyOwner {
504         require(newOwner != address(0), "Ownable: new owner is the zero address");
505         _transferOwnership(newOwner);
506     }
507 
508     /**
509      * @dev Transfers ownership of the contract to a new account (`newOwner`).
510      * Internal function without access restriction.
511      */
512     function _transferOwnership(address newOwner) internal virtual {
513         address oldOwner = _owner;
514         _owner = newOwner;
515         emit OwnershipTransferred(oldOwner, newOwner);
516     }
517 }
518 
519 // File: @openzeppelin/contracts/utils/Address.sol
520 
521 
522 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
523 
524 pragma solidity ^0.8.1;
525 
526 /**
527  * @dev Collection of functions related to the address type
528  */
529 library Address {
530     /**
531      * @dev Returns true if `account` is a contract.
532      *
533      * [IMPORTANT]
534      * ====
535      * It is unsafe to assume that an address for which this function returns
536      * false is an externally-owned account (EOA) and not a contract.
537      *
538      * Among others, `isContract` will return false for the following
539      * types of addresses:
540      *
541      *  - an externally-owned account
542      *  - a contract in construction
543      *  - an address where a contract will be created
544      *  - an address where a contract lived, but was destroyed
545      * ====
546      *
547      * [IMPORTANT]
548      * ====
549      * You shouldn't rely on `isContract` to protect against flash loan attacks!
550      *
551      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
552      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
553      * constructor.
554      * ====
555      */
556     function isContract(address account) internal view returns (bool) {
557         // This method relies on extcodesize/address.code.length, which returns 0
558         // for contracts in construction, since the code is only stored at the end
559         // of the constructor execution.
560 
561         return account.code.length > 0;
562     }
563 
564     /**
565      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
566      * `recipient`, forwarding all available gas and reverting on errors.
567      *
568      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
569      * of certain opcodes, possibly making contracts go over the 2300 gas limit
570      * imposed by `transfer`, making them unable to receive funds via
571      * `transfer`. {sendValue} removes this limitation.
572      *
573      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
574      *
575      * IMPORTANT: because control is transferred to `recipient`, care must be
576      * taken to not create reentrancy vulnerabilities. Consider using
577      * {ReentrancyGuard} or the
578      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
579      */
580     function sendValue(address payable recipient, uint256 amount) internal {
581         require(address(this).balance >= amount, "Address: insufficient balance");
582 
583         (bool success, ) = recipient.call{value: amount}("");
584         require(success, "Address: unable to send value, recipient may have reverted");
585     }
586 
587     /**
588      * @dev Performs a Solidity function call using a low level `call`. A
589      * plain `call` is an unsafe replacement for a function call: use this
590      * function instead.
591      *
592      * If `target` reverts with a revert reason, it is bubbled up by this
593      * function (like regular Solidity function calls).
594      *
595      * Returns the raw returned data. To convert to the expected return value,
596      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
597      *
598      * Requirements:
599      *
600      * - `target` must be a contract.
601      * - calling `target` with `data` must not revert.
602      *
603      * _Available since v3.1._
604      */
605     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
606         return functionCall(target, data, "Address: low-level call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
611      * `errorMessage` as a fallback revert reason when `target` reverts.
612      *
613      * _Available since v3.1._
614      */
615     function functionCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         return functionCallWithValue(target, data, 0, errorMessage);
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
625      * but also transferring `value` wei to `target`.
626      *
627      * Requirements:
628      *
629      * - the calling contract must have an ETH balance of at least `value`.
630      * - the called Solidity function must be `payable`.
631      *
632      * _Available since v3.1._
633      */
634     function functionCallWithValue(
635         address target,
636         bytes memory data,
637         uint256 value
638     ) internal returns (bytes memory) {
639         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
644      * with `errorMessage` as a fallback revert reason when `target` reverts.
645      *
646      * _Available since v3.1._
647      */
648     function functionCallWithValue(
649         address target,
650         bytes memory data,
651         uint256 value,
652         string memory errorMessage
653     ) internal returns (bytes memory) {
654         require(address(this).balance >= value, "Address: insufficient balance for call");
655         require(isContract(target), "Address: call to non-contract");
656 
657         (bool success, bytes memory returndata) = target.call{value: value}(data);
658         return verifyCallResult(success, returndata, errorMessage);
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
663      * but performing a static call.
664      *
665      * _Available since v3.3._
666      */
667     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
668         return functionStaticCall(target, data, "Address: low-level static call failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
673      * but performing a static call.
674      *
675      * _Available since v3.3._
676      */
677     function functionStaticCall(
678         address target,
679         bytes memory data,
680         string memory errorMessage
681     ) internal view returns (bytes memory) {
682         require(isContract(target), "Address: static call to non-contract");
683 
684         (bool success, bytes memory returndata) = target.staticcall(data);
685         return verifyCallResult(success, returndata, errorMessage);
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
690      * but performing a delegate call.
691      *
692      * _Available since v3.4._
693      */
694     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
695         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
700      * but performing a delegate call.
701      *
702      * _Available since v3.4._
703      */
704     function functionDelegateCall(
705         address target,
706         bytes memory data,
707         string memory errorMessage
708     ) internal returns (bytes memory) {
709         require(isContract(target), "Address: delegate call to non-contract");
710 
711         (bool success, bytes memory returndata) = target.delegatecall(data);
712         return verifyCallResult(success, returndata, errorMessage);
713     }
714 
715     /**
716      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
717      * revert reason using the provided one.
718      *
719      * _Available since v4.3._
720      */
721     function verifyCallResult(
722         bool success,
723         bytes memory returndata,
724         string memory errorMessage
725     ) internal pure returns (bytes memory) {
726         if (success) {
727             return returndata;
728         } else {
729             // Look for revert reason and bubble it up if present
730             if (returndata.length > 0) {
731                 // The easiest way to bubble the revert reason is using memory via assembly
732                 /// @solidity memory-safe-assembly
733                 assembly {
734                     let returndata_size := mload(returndata)
735                     revert(add(32, returndata), returndata_size)
736                 }
737             } else {
738                 revert(errorMessage);
739             }
740         }
741     }
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
745 
746 
747 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 /**
752  * @title ERC721 token receiver interface
753  * @dev Interface for any contract that wants to support safeTransfers
754  * from ERC721 asset contracts.
755  */
756 interface IERC721Receiver {
757     /**
758      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
759      * by `operator` from `from`, this function is called.
760      *
761      * It must return its Solidity selector to confirm the token transfer.
762      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
763      *
764      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
765      */
766     function onERC721Received(
767         address operator,
768         address from,
769         uint256 tokenId,
770         bytes calldata data
771     ) external returns (bytes4);
772 }
773 
774 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
775 
776 
777 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 /**
782  * @dev Interface of the ERC165 standard, as defined in the
783  * https://eips.ethereum.org/EIPS/eip-165[EIP].
784  *
785  * Implementers can declare support of contract interfaces, which can then be
786  * queried by others ({ERC165Checker}).
787  *
788  * For an implementation, see {ERC165}.
789  */
790 interface IERC165 {
791     /**
792      * @dev Returns true if this contract implements the interface defined by
793      * `interfaceId`. See the corresponding
794      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
795      * to learn more about how these ids are created.
796      *
797      * This function call must use less than 30 000 gas.
798      */
799     function supportsInterface(bytes4 interfaceId) external view returns (bool);
800 }
801 
802 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
803 
804 
805 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
806 
807 pragma solidity ^0.8.0;
808 
809 
810 /**
811  * @dev Implementation of the {IERC165} interface.
812  *
813  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
814  * for the additional interface id that will be supported. For example:
815  *
816  * ```solidity
817  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
818  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
819  * }
820  * ```
821  *
822  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
823  */
824 abstract contract ERC165 is IERC165 {
825     /**
826      * @dev See {IERC165-supportsInterface}.
827      */
828     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
829         return interfaceId == type(IERC165).interfaceId;
830     }
831 }
832 
833 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
834 
835 
836 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
837 
838 pragma solidity ^0.8.0;
839 
840 
841 /**
842  * @dev Required interface of an ERC721 compliant contract.
843  */
844 interface IERC721 is IERC165 {
845     /**
846      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
847      */
848     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
849 
850     /**
851      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
852      */
853     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
854 
855     /**
856      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
857      */
858     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
859 
860     /**
861      * @dev Returns the number of tokens in ``owner``'s account.
862      */
863     function balanceOf(address owner) external view returns (uint256 balance);
864 
865     /**
866      * @dev Returns the owner of the `tokenId` token.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function ownerOf(uint256 tokenId) external view returns (address owner);
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`.
876      *
877      * Requirements:
878      *
879      * - `from` cannot be the zero address.
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must exist and be owned by `from`.
882      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
884      *
885      * Emits a {Transfer} event.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes calldata data
892     ) external;
893 
894     /**
895      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
896      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
897      *
898      * Requirements:
899      *
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must exist and be owned by `from`.
903      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
905      *
906      * Emits a {Transfer} event.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) external;
913 
914     /**
915      * @dev Transfers `tokenId` token from `from` to `to`.
916      *
917      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
918      *
919      * Requirements:
920      *
921      * - `from` cannot be the zero address.
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must be owned by `from`.
924      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
925      *
926      * Emits a {Transfer} event.
927      */
928     function transferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) external;
933 
934     /**
935      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
936      * The approval is cleared when the token is transferred.
937      *
938      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
939      *
940      * Requirements:
941      *
942      * - The caller must own the token or be an approved operator.
943      * - `tokenId` must exist.
944      *
945      * Emits an {Approval} event.
946      */
947     function approve(address to, uint256 tokenId) external;
948 
949     /**
950      * @dev Approve or remove `operator` as an operator for the caller.
951      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
952      *
953      * Requirements:
954      *
955      * - The `operator` cannot be the caller.
956      *
957      * Emits an {ApprovalForAll} event.
958      */
959     function setApprovalForAll(address operator, bool _approved) external;
960 
961     /**
962      * @dev Returns the account approved for `tokenId` token.
963      *
964      * Requirements:
965      *
966      * - `tokenId` must exist.
967      */
968     function getApproved(uint256 tokenId) external view returns (address operator);
969 
970     /**
971      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
972      *
973      * See {setApprovalForAll}
974      */
975     function isApprovedForAll(address owner, address operator) external view returns (bool);
976 }
977 
978 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
979 
980 
981 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
982 
983 pragma solidity ^0.8.0;
984 
985 
986 /**
987  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
988  * @dev See https://eips.ethereum.org/EIPS/eip-721
989  */
990 interface IERC721Metadata is IERC721 {
991     /**
992      * @dev Returns the token collection name.
993      */
994     function name() external view returns (string memory);
995 
996     /**
997      * @dev Returns the token collection symbol.
998      */
999     function symbol() external view returns (string memory);
1000 
1001     /**
1002      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1003      */
1004     function tokenURI(uint256 tokenId) external view returns (string memory);
1005 }
1006 
1007 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1008 
1009 
1010 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 
1021 /**
1022  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1023  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1024  * {ERC721Enumerable}.
1025  */
1026 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1027     using Address for address;
1028     using Strings for uint256;
1029 
1030     // Token name
1031     string private _name;
1032 
1033     // Token symbol
1034     string private _symbol;
1035 
1036     // Mapping from token ID to owner address
1037     mapping(uint256 => address) private _owners;
1038 
1039     // Mapping owner address to token count
1040     mapping(address => uint256) private _balances;
1041 
1042     // Mapping from token ID to approved address
1043     mapping(uint256 => address) private _tokenApprovals;
1044 
1045     // Mapping from owner to operator approvals
1046     mapping(address => mapping(address => bool)) private _operatorApprovals;
1047 
1048     /**
1049      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1050      */
1051     constructor(string memory name_, string memory symbol_) {
1052         _name = name_;
1053         _symbol = symbol_;
1054     }
1055 
1056     /**
1057      * @dev See {IERC165-supportsInterface}.
1058      */
1059     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1060         return
1061             interfaceId == type(IERC721).interfaceId ||
1062             interfaceId == type(IERC721Metadata).interfaceId ||
1063             super.supportsInterface(interfaceId);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-balanceOf}.
1068      */
1069     function balanceOf(address owner) public view virtual override returns (uint256) {
1070         require(owner != address(0), "ERC721: address zero is not a valid owner");
1071         return _balances[owner];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-ownerOf}.
1076      */
1077     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1078         address owner = _owners[tokenId];
1079         require(owner != address(0), "ERC721: invalid token ID");
1080         return owner;
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Metadata-name}.
1085      */
1086     function name() public view virtual override returns (string memory) {
1087         return _name;
1088     }
1089 
1090     /**
1091      * @dev See {IERC721Metadata-symbol}.
1092      */
1093     function symbol() public view virtual override returns (string memory) {
1094         return _symbol;
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Metadata-tokenURI}.
1099      */
1100     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1101         _requireMinted(tokenId);
1102 
1103         string memory baseURI = _baseURI();
1104         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1105     }
1106 
1107     /**
1108      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1109      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1110      * by default, can be overridden in child contracts.
1111      */
1112     function _baseURI() internal view virtual returns (string memory) {
1113         return "";
1114     }
1115 
1116     /**
1117      * @dev See {IERC721-approve}.
1118      */
1119     function approve(address to, uint256 tokenId) public virtual override {
1120         address owner = ERC721.ownerOf(tokenId);
1121         require(to != owner, "ERC721: approval to current owner");
1122 
1123         require(
1124             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1125             "ERC721: approve caller is not token owner nor approved for all"
1126         );
1127 
1128         _approve(to, tokenId);
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-getApproved}.
1133      */
1134     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1135         _requireMinted(tokenId);
1136 
1137         return _tokenApprovals[tokenId];
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-setApprovalForAll}.
1142      */
1143     function setApprovalForAll(address operator, bool approved) public virtual override {
1144         _setApprovalForAll(_msgSender(), operator, approved);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721-isApprovedForAll}.
1149      */
1150     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1151         return _operatorApprovals[owner][operator];
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-transferFrom}.
1156      */
1157     function transferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId
1161     ) public virtual override {
1162         //solhint-disable-next-line max-line-length
1163         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1164 
1165         _transfer(from, to, tokenId);
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-safeTransferFrom}.
1170      */
1171     function safeTransferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) public virtual override {
1176         safeTransferFrom(from, to, tokenId, "");
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-safeTransferFrom}.
1181      */
1182     function safeTransferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId,
1186         bytes memory data
1187     ) public virtual override {
1188         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1189         _safeTransfer(from, to, tokenId, data);
1190     }
1191 
1192     /**
1193      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1194      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1195      *
1196      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1197      *
1198      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1199      * implement alternative mechanisms to perform token transfer, such as signature-based.
1200      *
1201      * Requirements:
1202      *
1203      * - `from` cannot be the zero address.
1204      * - `to` cannot be the zero address.
1205      * - `tokenId` token must exist and be owned by `from`.
1206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _safeTransfer(
1211         address from,
1212         address to,
1213         uint256 tokenId,
1214         bytes memory data
1215     ) internal virtual {
1216         _transfer(from, to, tokenId);
1217         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1218     }
1219 
1220     /**
1221      * @dev Returns whether `tokenId` exists.
1222      *
1223      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1224      *
1225      * Tokens start existing when they are minted (`_mint`),
1226      * and stop existing when they are burned (`_burn`).
1227      */
1228     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1229         return _owners[tokenId] != address(0);
1230     }
1231 
1232     /**
1233      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      */
1239     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1240         address owner = ERC721.ownerOf(tokenId);
1241         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1242     }
1243 
1244     /**
1245      * @dev Safely mints `tokenId` and transfers it to `to`.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must not exist.
1250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _safeMint(address to, uint256 tokenId) internal virtual {
1255         _safeMint(to, tokenId, "");
1256     }
1257 
1258     /**
1259      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1260      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1261      */
1262     function _safeMint(
1263         address to,
1264         uint256 tokenId,
1265         bytes memory data
1266     ) internal virtual {
1267         _mint(to, tokenId);
1268         require(
1269             _checkOnERC721Received(address(0), to, tokenId, data),
1270             "ERC721: transfer to non ERC721Receiver implementer"
1271         );
1272     }
1273 
1274     /**
1275      * @dev Mints `tokenId` and transfers it to `to`.
1276      *
1277      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1278      *
1279      * Requirements:
1280      *
1281      * - `tokenId` must not exist.
1282      * - `to` cannot be the zero address.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function _mint(address to, uint256 tokenId) internal virtual {
1287         require(to != address(0), "ERC721: mint to the zero address");
1288         require(!_exists(tokenId), "ERC721: token already minted");
1289 
1290         _beforeTokenTransfer(address(0), to, tokenId);
1291 
1292         _balances[to] += 1;
1293         _owners[tokenId] = to;
1294 
1295         emit Transfer(address(0), to, tokenId);
1296 
1297         _afterTokenTransfer(address(0), to, tokenId);
1298     }
1299 
1300     /**
1301      * @dev Destroys `tokenId`.
1302      * The approval is cleared when the token is burned.
1303      *
1304      * Requirements:
1305      *
1306      * - `tokenId` must exist.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _burn(uint256 tokenId) internal virtual {
1311         address owner = ERC721.ownerOf(tokenId);
1312 
1313         _beforeTokenTransfer(owner, address(0), tokenId);
1314 
1315         // Clear approvals
1316         _approve(address(0), tokenId);
1317 
1318         _balances[owner] -= 1;
1319         delete _owners[tokenId];
1320 
1321         emit Transfer(owner, address(0), tokenId);
1322 
1323         _afterTokenTransfer(owner, address(0), tokenId);
1324     }
1325 
1326     /**
1327      * @dev Transfers `tokenId` from `from` to `to`.
1328      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1329      *
1330      * Requirements:
1331      *
1332      * - `to` cannot be the zero address.
1333      * - `tokenId` token must be owned by `from`.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _transfer(
1338         address from,
1339         address to,
1340         uint256 tokenId
1341     ) internal virtual {
1342         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1343         require(to != address(0), "ERC721: transfer to the zero address");
1344 
1345         _beforeTokenTransfer(from, to, tokenId);
1346 
1347         // Clear approvals from the previous owner
1348         _approve(address(0), tokenId);
1349 
1350         _balances[from] -= 1;
1351         _balances[to] += 1;
1352         _owners[tokenId] = to;
1353 
1354         emit Transfer(from, to, tokenId);
1355 
1356         _afterTokenTransfer(from, to, tokenId);
1357     }
1358 
1359     /**
1360      * @dev Approve `to` to operate on `tokenId`
1361      *
1362      * Emits an {Approval} event.
1363      */
1364     function _approve(address to, uint256 tokenId) internal virtual {
1365         _tokenApprovals[tokenId] = to;
1366         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1367     }
1368 
1369     /**
1370      * @dev Approve `operator` to operate on all of `owner` tokens
1371      *
1372      * Emits an {ApprovalForAll} event.
1373      */
1374     function _setApprovalForAll(
1375         address owner,
1376         address operator,
1377         bool approved
1378     ) internal virtual {
1379         require(owner != operator, "ERC721: approve to caller");
1380         _operatorApprovals[owner][operator] = approved;
1381         emit ApprovalForAll(owner, operator, approved);
1382     }
1383 
1384     /**
1385      * @dev Reverts if the `tokenId` has not been minted yet.
1386      */
1387     function _requireMinted(uint256 tokenId) internal view virtual {
1388         require(_exists(tokenId), "ERC721: invalid token ID");
1389     }
1390 
1391     /**
1392      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1393      * The call is not executed if the target address is not a contract.
1394      *
1395      * @param from address representing the previous owner of the given token ID
1396      * @param to target address that will receive the tokens
1397      * @param tokenId uint256 ID of the token to be transferred
1398      * @param data bytes optional data to send along with the call
1399      * @return bool whether the call correctly returned the expected magic value
1400      */
1401     function _checkOnERC721Received(
1402         address from,
1403         address to,
1404         uint256 tokenId,
1405         bytes memory data
1406     ) private returns (bool) {
1407         if (to.isContract()) {
1408             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1409                 return retval == IERC721Receiver.onERC721Received.selector;
1410             } catch (bytes memory reason) {
1411                 if (reason.length == 0) {
1412                     revert("ERC721: transfer to non ERC721Receiver implementer");
1413                 } else {
1414                     /// @solidity memory-safe-assembly
1415                     assembly {
1416                         revert(add(32, reason), mload(reason))
1417                     }
1418                 }
1419             }
1420         } else {
1421             return true;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Hook that is called before any token transfer. This includes minting
1427      * and burning.
1428      *
1429      * Calling conditions:
1430      *
1431      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1432      * transferred to `to`.
1433      * - When `from` is zero, `tokenId` will be minted for `to`.
1434      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1435      * - `from` and `to` are never both zero.
1436      *
1437      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1438      */
1439     function _beforeTokenTransfer(
1440         address from,
1441         address to,
1442         uint256 tokenId
1443     ) internal virtual {}
1444 
1445     /**
1446      * @dev Hook that is called after any transfer of tokens. This includes
1447      * minting and burning.
1448      *
1449      * Calling conditions:
1450      *
1451      * - when `from` and `to` are both non-zero.
1452      * - `from` and `to` are never both zero.
1453      *
1454      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1455      */
1456     function _afterTokenTransfer(
1457         address from,
1458         address to,
1459         uint256 tokenId
1460     ) internal virtual {}
1461 }
1462 
1463 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1464 
1465 
1466 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1467 
1468 pragma solidity ^0.8.0;
1469 
1470 
1471 /**
1472  * @dev ERC721 token with storage based token URI management.
1473  */
1474 abstract contract ERC721URIStorage is ERC721 {
1475     using Strings for uint256;
1476 
1477     // Optional mapping for token URIs
1478     mapping(uint256 => string) private _tokenURIs;
1479 
1480     /**
1481      * @dev See {IERC721Metadata-tokenURI}.
1482      */
1483     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1484         _requireMinted(tokenId);
1485 
1486         string memory _tokenURI = _tokenURIs[tokenId];
1487         string memory base = _baseURI();
1488 
1489         // If there is no base URI, return the token URI.
1490         if (bytes(base).length == 0) {
1491             return _tokenURI;
1492         }
1493         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1494         if (bytes(_tokenURI).length > 0) {
1495             return string(abi.encodePacked(base, _tokenURI));
1496         }
1497 
1498         return super.tokenURI(tokenId);
1499     }
1500 
1501     /**
1502      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1503      *
1504      * Requirements:
1505      *
1506      * - `tokenId` must exist.
1507      */
1508     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1509         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1510         _tokenURIs[tokenId] = _tokenURI;
1511     }
1512 
1513     /**
1514      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1515      * token-specific URI was set for the token, and if so, it deletes the token URI from
1516      * the storage mapping.
1517      */
1518     function _burn(uint256 tokenId) internal virtual override {
1519         super._burn(tokenId);
1520 
1521         if (bytes(_tokenURIs[tokenId]).length != 0) {
1522             delete _tokenURIs[tokenId];
1523         }
1524     }
1525 }
1526 
1527 // File: nftcompanions.sol
1528 
1529 
1530 // numero1.app (c)
1531 
1532 pragma solidity ^0.8.11;
1533 
1534 
1535 
1536 
1537 
1538 
1539 
1540     contract CompanionsNFT is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
1541 
1542 // Admin
1543 
1544     address private constant ADMIN_WALLET = 0xCABEA694c995655a52776481aFb509AfdfeE083A;
1545 
1546 // Supply
1547 
1548     uint public constant MAX_SUPPLY = 2777;
1549     uint public constant GIFT_SUPPLY = 50;
1550     uint public constant MAX_PER_WALLET = 2;
1551 
1552     using Counters for Counters.Counter;
1553     Counters.Counter private _tokenSupply;
1554 
1555 // Tokens per wallet declaration
1556 
1557     mapping(address => uint) public tokensPerWallet;    
1558     mapping(address => uint) public freePerWallet;     
1559 
1560 // Status
1561 
1562     enum TokenStatus {
1563         Paused,
1564         WLMinting,
1565         Minting,       
1566         MintFinished
1567     }    
1568     TokenStatus public tokenStatus=TokenStatus.MintFinished;
1569     event TokenStatusChanged(TokenStatus _tokenStatus); 
1570    
1571 // Base URI
1572     
1573     string public baseURI="ipfs://QmbbVosEWnZgUcZhu5bvjFjSM1gGvbXkgWk6iegJrPJetc/";
1574     event BaseURIChanged(string _baseURI); 
1575 
1576 // Price
1577 
1578     uint internal price = 0.0777 ether;
1579     event PriceChanged(uint _price); 
1580     uint internal ogprice = 0.0667 ether;
1581     event OgPriceChanged(uint _price); 
1582 
1583 // Merkle roots
1584 
1585     bytes32 flRoot;
1586     bytes32 oglRoot;
1587     bytes32 wlRoot;
1588 
1589     function setMerkleRoots(bytes32 _flRoot, bytes32 _oglRoot, bytes32 _wlRoot) external onlyAdmins {
1590         flRoot=_flRoot;
1591         oglRoot=_oglRoot;
1592         wlRoot=_wlRoot;
1593     }
1594 
1595 
1596 // Constructor
1597 
1598     constructor() ERC721("CompanionsNFT", "CompNFT") {    
1599         _tokenSupply.increment();
1600         _safeMint(msg.sender,_tokenSupply.current()); 
1601         tokenStatus=TokenStatus.Paused;
1602         emit TokenStatusChanged(tokenStatus);
1603     }
1604 
1605 // Modifiers 
1606 
1607     modifier onlyAdmins() {
1608         require(address(this) == msg.sender || owner() == msg.sender || ADMIN_WALLET ==msg.sender, "CompanionsNFT: Only admin or owner are allowed!");
1609         _;
1610     }
1611 
1612     modifier statusNotPaused() {
1613         require(tokenStatus!=TokenStatus.Paused, "CompanionsNFT: Contract it's paused!");
1614         _;
1615     }    
1616 
1617 // Internal stuff
1618 
1619     function toBytes32(address addr) pure internal returns (bytes32) {
1620     return bytes32(uint256(uint160(addr)));
1621     }
1622 
1623     function _beforeTokenTransfer(address from, address to, uint tokenId) 
1624         internal
1625         statusNotPaused()
1626         override(ERC721)
1627     {
1628         super._beforeTokenTransfer(from, to, tokenId);
1629     }
1630 
1631 // The following functions are overrides required by Solidity.
1632 
1633     function _burn(uint tokenId) internal override(ERC721, ERC721URIStorage) {
1634         super._burn(tokenId);
1635     }
1636 
1637     function tokenURI(uint tokenId) 
1638         public 
1639         view 
1640         override(ERC721, ERC721URIStorage) 
1641         returns (string memory) 
1642     {
1643         return super.tokenURI(tokenId);
1644     }
1645  
1646  // Token burn
1647 
1648     function burn(uint256 _tokenId) public onlyAdmins {
1649         _burn(_tokenId);
1650     }
1651 
1652 // Token Status
1653 
1654     function setTokenStatus(TokenStatus _Status) external onlyAdmins {
1655         tokenStatus=_Status;
1656         emit TokenStatusChanged(tokenStatus);
1657     }
1658     
1659     function getTokenStatus() public view returns (string memory ) {        
1660         if (tokenStatus==TokenStatus.WLMinting) return "WL Minting"; else
1661         if (tokenStatus==TokenStatus.Minting) return "Minting"; else      
1662         if (tokenStatus==TokenStatus.MintFinished) return "Mint finished";
1663         return "Paused";
1664     }
1665 
1666 // Token BaseURI
1667 
1668     function _baseURI() internal view virtual override returns (string memory) {
1669         return baseURI;
1670     }
1671     
1672     function setBaseURI(string calldata _BaseURI) external onlyAdmins {
1673         baseURI = _BaseURI;
1674         emit BaseURIChanged(_BaseURI);
1675     }
1676 
1677 // Token price
1678 
1679     function setPrice(uint _Price) external onlyAdmins {
1680         price = _Price;
1681         emit PriceChanged(price);
1682     }
1683 
1684     function setOgPrice(uint _OgPrice) external onlyAdmins {
1685         ogprice = _OgPrice;
1686         emit OgPriceChanged(ogprice);
1687     }    
1688 
1689     function getPrice() public view returns (uint) {
1690         return price;
1691     }
1692 
1693     function getOgPrice() public view returns (uint) {
1694         return ogprice;
1695     }    
1696 
1697 // Token supply
1698 
1699     function totalSupply() public view returns (uint) {
1700         return _tokenSupply.current();
1701     }
1702 
1703 // Token mint & gift
1704 
1705     function _mint(uint _amount, uint _price) internal {
1706         require(_amount > 0, "CompanionsNFT: Amount can't be zero!");
1707         require(_tokenSupply.current() < MAX_SUPPLY, "CompanionsNFT: SOLD OUT!");     
1708         require(msg.value >=_price * _amount, "CompanionsNFT: Insuficient funds!");
1709         require(tokensPerWallet[msg.sender] + _amount <= MAX_PER_WALLET, "CompanionsNFT: Max tokens per wallet exceeded!");
1710         require(_tokenSupply.current() + _amount <= MAX_SUPPLY, "CompanionsNFT: Max supply exceeded!");
1711 
1712         for (uint i = 1; i <= _amount; i++) {
1713             _tokenSupply.increment();
1714             _safeMint(msg.sender, _tokenSupply.current());                        
1715         }    
1716         tokensPerWallet[msg.sender] += _amount;
1717     }
1718 
1719     function mint_free(uint amount, bytes32[] calldata merkleProof)
1720         external
1721         payable
1722         nonReentrant 
1723         statusNotPaused()
1724     {
1725         require((tokenStatus == TokenStatus.WLMinting) || (tokenStatus == TokenStatus.Minting) , "CompanionsNFT: It's not in minting!"); 
1726         require(MerkleProof.verify(merkleProof, flRoot, toBytes32(msg.sender)) == true, "CompanionsNFT: Address not allowed to mint for free!");
1727         require((freePerWallet[msg.sender] == 0) && (amount == 1), "CompanionsNFT: Max 1 free token!");
1728         _mint(amount,0);
1729         freePerWallet[msg.sender]=1;
1730     } 
1731 
1732     function mint_og(uint amount, bytes32[] calldata merkleProof)
1733         external
1734         payable
1735         nonReentrant 
1736         statusNotPaused()
1737     {
1738         require((tokenStatus == TokenStatus.WLMinting) || (tokenStatus == TokenStatus.Minting), "CompanionsNFT: It's not in minting!"); 
1739         require(MerkleProof.verify(merkleProof, oglRoot, toBytes32(msg.sender)) == true, "CompanionsNFT: Address not in OG list!");
1740         _mint(amount,ogprice);
1741     } 
1742 
1743     function mint_whitelist(uint amount, bytes32[] calldata merkleProof)
1744         external
1745         payable
1746         nonReentrant 
1747         statusNotPaused()
1748     {
1749         require(tokenStatus == TokenStatus.WLMinting, "CompanionsNFT: It's not in WL minting!"); 
1750         require(MerkleProof.verify(merkleProof, wlRoot, toBytes32(msg.sender)) == true, "CompanionsNFT: Address not in WL!");
1751         _mint(amount,price);
1752     } 
1753 
1754     function mint(uint amount)
1755         external
1756         payable
1757         nonReentrant 
1758         statusNotPaused()
1759     {
1760         require(tokenStatus == TokenStatus.Minting, "CompanionsNFT: It's not in minting!"); 
1761         _mint(amount,price);
1762     }    
1763 
1764     function gift(address to, uint amount)
1765         public
1766         onlyAdmins
1767         statusNotPaused()    
1768     {
1769         require(amount > 0, "CompanionsNFT: Amount can't be zero!");
1770         require(_tokenSupply.current() + amount <= MAX_SUPPLY+GIFT_SUPPLY, "CompanionsNFT: Max supply exceeded!");
1771         for (uint i = 1; i <= amount; i++) {            
1772             _tokenSupply.increment();
1773             _safeMint(to, _tokenSupply.current());
1774         }     
1775         
1776     }
1777 
1778 // Withdraw ETH to the owner
1779     
1780     function withdrawAll() public onlyOwner {
1781         (bool sent, bytes memory data) = payable(msg.sender).call{value: address(this).balance}("");
1782         require(sent,string(abi.encodePacked("CompanionsNFT: Failed to withdraw!",data)));
1783     }    
1784       
1785 }