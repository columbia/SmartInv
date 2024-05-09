1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214                 /// @solidity memory-safe-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/utils/Context.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Provides information about the current execution context, including the
235  * sender of the transaction and its data. While these are generally available
236  * via msg.sender and msg.data, they should not be accessed in such a direct
237  * manner, since when dealing with meta-transactions the account sending and
238  * paying for execution may not be the actual sender (as far as an application
239  * is concerned).
240  *
241  * This contract is only required for intermediate, library-like contracts.
242  */
243 abstract contract Context {
244     function _msgSender() internal view virtual returns (address) {
245         return msg.sender;
246     }
247 
248     function _msgData() internal view virtual returns (bytes calldata) {
249         return msg.data;
250     }
251 }
252 
253 // File: @openzeppelin/contracts/access/Ownable.sol
254 
255 
256 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * By default, the owner account will be the one that deploys the contract. This
266  * can later be changed with {transferOwnership}.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be applied to your functions to restrict their use to
270  * the owner.
271  */
272 abstract contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor() {
281         _transferOwnership(_msgSender());
282     }
283 
284     /**
285      * @dev Throws if called by any account other than the owner.
286      */
287     modifier onlyOwner() {
288         _checkOwner();
289         _;
290     }
291 
292     /**
293      * @dev Returns the address of the current owner.
294      */
295     function owner() public view virtual returns (address) {
296         return _owner;
297     }
298 
299     /**
300      * @dev Throws if the sender is not the owner.
301      */
302     function _checkOwner() internal view virtual {
303         require(owner() == _msgSender(), "Ownable: caller is not the owner");
304     }
305 
306     /**
307      * @dev Leaves the contract without owner. It will not be possible to call
308      * `onlyOwner` functions anymore. Can only be called by the current owner.
309      *
310      * NOTE: Renouncing ownership will leave the contract without an owner,
311      * thereby removing any functionality that is only available to the owner.
312      */
313     function renounceOwnership() public virtual onlyOwner {
314         _transferOwnership(address(0));
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Can only be called by the current owner.
320      */
321     function transferOwnership(address newOwner) public virtual onlyOwner {
322         require(newOwner != address(0), "Ownable: new owner is the zero address");
323         _transferOwnership(newOwner);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      * Internal function without access restriction.
329      */
330     function _transferOwnership(address newOwner) internal virtual {
331         address oldOwner = _owner;
332         _owner = newOwner;
333         emit OwnershipTransferred(oldOwner, newOwner);
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
338 
339 
340 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev These functions deal with verification of Merkle Tree proofs.
346  *
347  * The proofs can be generated using the JavaScript library
348  * https://github.com/miguelmota/merkletreejs[merkletreejs].
349  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
350  *
351  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
352  *
353  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
354  * hashing, or use a hash function other than keccak256 for hashing leaves.
355  * This is because the concatenation of a sorted pair of internal nodes in
356  * the merkle tree could be reinterpreted as a leaf value.
357  */
358 library MerkleProof {
359     /**
360      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
361      * defined by `root`. For this, a `proof` must be provided, containing
362      * sibling hashes on the branch from the leaf to the root of the tree. Each
363      * pair of leaves and each pair of pre-images are assumed to be sorted.
364      */
365     function verify(
366         bytes32[] memory proof,
367         bytes32 root,
368         bytes32 leaf
369     ) internal pure returns (bool) {
370         return processProof(proof, leaf) == root;
371     }
372 
373     /**
374      * @dev Calldata version of {verify}
375      *
376      * _Available since v4.7._
377      */
378     function verifyCalldata(
379         bytes32[] calldata proof,
380         bytes32 root,
381         bytes32 leaf
382     ) internal pure returns (bool) {
383         return processProofCalldata(proof, leaf) == root;
384     }
385 
386     /**
387      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
388      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
389      * hash matches the root of the tree. When processing the proof, the pairs
390      * of leafs & pre-images are assumed to be sorted.
391      *
392      * _Available since v4.4._
393      */
394     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
395         bytes32 computedHash = leaf;
396         for (uint256 i = 0; i < proof.length; i++) {
397             computedHash = _hashPair(computedHash, proof[i]);
398         }
399         return computedHash;
400     }
401 
402     /**
403      * @dev Calldata version of {processProof}
404      *
405      * _Available since v4.7._
406      */
407     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
408         bytes32 computedHash = leaf;
409         for (uint256 i = 0; i < proof.length; i++) {
410             computedHash = _hashPair(computedHash, proof[i]);
411         }
412         return computedHash;
413     }
414 
415     /**
416      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
417      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
418      *
419      * _Available since v4.7._
420      */
421     function multiProofVerify(
422         bytes32[] memory proof,
423         bool[] memory proofFlags,
424         bytes32 root,
425         bytes32[] memory leaves
426     ) internal pure returns (bool) {
427         return processMultiProof(proof, proofFlags, leaves) == root;
428     }
429 
430     /**
431      * @dev Calldata version of {multiProofVerify}
432      *
433      * _Available since v4.7._
434      */
435     function multiProofVerifyCalldata(
436         bytes32[] calldata proof,
437         bool[] calldata proofFlags,
438         bytes32 root,
439         bytes32[] memory leaves
440     ) internal pure returns (bool) {
441         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
442     }
443 
444     /**
445      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
446      * consuming from one or the other at each step according to the instructions given by
447      * `proofFlags`.
448      *
449      * _Available since v4.7._
450      */
451     function processMultiProof(
452         bytes32[] memory proof,
453         bool[] memory proofFlags,
454         bytes32[] memory leaves
455     ) internal pure returns (bytes32 merkleRoot) {
456         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
457         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
458         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
459         // the merkle tree.
460         uint256 leavesLen = leaves.length;
461         uint256 totalHashes = proofFlags.length;
462 
463         // Check proof validity.
464         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
465 
466         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
467         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
468         bytes32[] memory hashes = new bytes32[](totalHashes);
469         uint256 leafPos = 0;
470         uint256 hashPos = 0;
471         uint256 proofPos = 0;
472         // At each step, we compute the next hash using two values:
473         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
474         //   get the next hash.
475         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
476         //   `proof` array.
477         for (uint256 i = 0; i < totalHashes; i++) {
478             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
479             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
480             hashes[i] = _hashPair(a, b);
481         }
482 
483         if (totalHashes > 0) {
484             return hashes[totalHashes - 1];
485         } else if (leavesLen > 0) {
486             return leaves[0];
487         } else {
488             return proof[0];
489         }
490     }
491 
492     /**
493      * @dev Calldata version of {processMultiProof}
494      *
495      * _Available since v4.7._
496      */
497     function processMultiProofCalldata(
498         bytes32[] calldata proof,
499         bool[] calldata proofFlags,
500         bytes32[] memory leaves
501     ) internal pure returns (bytes32 merkleRoot) {
502         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
503         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
504         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
505         // the merkle tree.
506         uint256 leavesLen = leaves.length;
507         uint256 totalHashes = proofFlags.length;
508 
509         // Check proof validity.
510         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
511 
512         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
513         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
514         bytes32[] memory hashes = new bytes32[](totalHashes);
515         uint256 leafPos = 0;
516         uint256 hashPos = 0;
517         uint256 proofPos = 0;
518         // At each step, we compute the next hash using two values:
519         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
520         //   get the next hash.
521         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
522         //   `proof` array.
523         for (uint256 i = 0; i < totalHashes; i++) {
524             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
525             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
526             hashes[i] = _hashPair(a, b);
527         }
528 
529         if (totalHashes > 0) {
530             return hashes[totalHashes - 1];
531         } else if (leavesLen > 0) {
532             return leaves[0];
533         } else {
534             return proof[0];
535         }
536     }
537 
538     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
539         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
540     }
541 
542     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
543         /// @solidity memory-safe-assembly
544         assembly {
545             mstore(0x00, a)
546             mstore(0x20, b)
547             value := keccak256(0x00, 0x40)
548         }
549     }
550 }
551 
552 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
553 
554 
555 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 // CAUTION
560 // This version of SafeMath should only be used with Solidity 0.8 or later,
561 // because it relies on the compiler's built in overflow checks.
562 
563 /**
564  * @dev Wrappers over Solidity's arithmetic operations.
565  *
566  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
567  * now has built in overflow checking.
568  */
569 library SafeMath {
570     /**
571      * @dev Returns the addition of two unsigned integers, with an overflow flag.
572      *
573      * _Available since v3.4._
574      */
575     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
576         unchecked {
577             uint256 c = a + b;
578             if (c < a) return (false, 0);
579             return (true, c);
580         }
581     }
582 
583     /**
584      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
585      *
586      * _Available since v3.4._
587      */
588     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
589         unchecked {
590             if (b > a) return (false, 0);
591             return (true, a - b);
592         }
593     }
594 
595     /**
596      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
597      *
598      * _Available since v3.4._
599      */
600     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
601         unchecked {
602             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
603             // benefit is lost if 'b' is also tested.
604             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
605             if (a == 0) return (true, 0);
606             uint256 c = a * b;
607             if (c / a != b) return (false, 0);
608             return (true, c);
609         }
610     }
611 
612     /**
613      * @dev Returns the division of two unsigned integers, with a division by zero flag.
614      *
615      * _Available since v3.4._
616      */
617     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
618         unchecked {
619             if (b == 0) return (false, 0);
620             return (true, a / b);
621         }
622     }
623 
624     /**
625      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
626      *
627      * _Available since v3.4._
628      */
629     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
630         unchecked {
631             if (b == 0) return (false, 0);
632             return (true, a % b);
633         }
634     }
635 
636     /**
637      * @dev Returns the addition of two unsigned integers, reverting on
638      * overflow.
639      *
640      * Counterpart to Solidity's `+` operator.
641      *
642      * Requirements:
643      *
644      * - Addition cannot overflow.
645      */
646     function add(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a + b;
648     }
649 
650     /**
651      * @dev Returns the subtraction of two unsigned integers, reverting on
652      * overflow (when the result is negative).
653      *
654      * Counterpart to Solidity's `-` operator.
655      *
656      * Requirements:
657      *
658      * - Subtraction cannot overflow.
659      */
660     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
661         return a - b;
662     }
663 
664     /**
665      * @dev Returns the multiplication of two unsigned integers, reverting on
666      * overflow.
667      *
668      * Counterpart to Solidity's `*` operator.
669      *
670      * Requirements:
671      *
672      * - Multiplication cannot overflow.
673      */
674     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
675         return a * b;
676     }
677 
678     /**
679      * @dev Returns the integer division of two unsigned integers, reverting on
680      * division by zero. The result is rounded towards zero.
681      *
682      * Counterpart to Solidity's `/` operator.
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function div(uint256 a, uint256 b) internal pure returns (uint256) {
689         return a / b;
690     }
691 
692     /**
693      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
694      * reverting when dividing by zero.
695      *
696      * Counterpart to Solidity's `%` operator. This function uses a `revert`
697      * opcode (which leaves remaining gas untouched) while Solidity uses an
698      * invalid opcode to revert (consuming all remaining gas).
699      *
700      * Requirements:
701      *
702      * - The divisor cannot be zero.
703      */
704     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
705         return a % b;
706     }
707 
708     /**
709      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
710      * overflow (when the result is negative).
711      *
712      * CAUTION: This function is deprecated because it requires allocating memory for the error
713      * message unnecessarily. For custom revert reasons use {trySub}.
714      *
715      * Counterpart to Solidity's `-` operator.
716      *
717      * Requirements:
718      *
719      * - Subtraction cannot overflow.
720      */
721     function sub(
722         uint256 a,
723         uint256 b,
724         string memory errorMessage
725     ) internal pure returns (uint256) {
726         unchecked {
727             require(b <= a, errorMessage);
728             return a - b;
729         }
730     }
731 
732     /**
733      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
734      * division by zero. The result is rounded towards zero.
735      *
736      * Counterpart to Solidity's `/` operator. Note: this function uses a
737      * `revert` opcode (which leaves remaining gas untouched) while Solidity
738      * uses an invalid opcode to revert (consuming all remaining gas).
739      *
740      * Requirements:
741      *
742      * - The divisor cannot be zero.
743      */
744     function div(
745         uint256 a,
746         uint256 b,
747         string memory errorMessage
748     ) internal pure returns (uint256) {
749         unchecked {
750             require(b > 0, errorMessage);
751             return a / b;
752         }
753     }
754 
755     /**
756      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
757      * reverting with custom message when dividing by zero.
758      *
759      * CAUTION: This function is deprecated because it requires allocating memory for the error
760      * message unnecessarily. For custom revert reasons use {tryMod}.
761      *
762      * Counterpart to Solidity's `%` operator. This function uses a `revert`
763      * opcode (which leaves remaining gas untouched) while Solidity uses an
764      * invalid opcode to revert (consuming all remaining gas).
765      *
766      * Requirements:
767      *
768      * - The divisor cannot be zero.
769      */
770     function mod(
771         uint256 a,
772         uint256 b,
773         string memory errorMessage
774     ) internal pure returns (uint256) {
775         unchecked {
776             require(b > 0, errorMessage);
777             return a % b;
778         }
779     }
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
783 
784 
785 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 /**
790  * @dev Interface of the ERC20 standard as defined in the EIP.
791  */
792 interface IERC20 {
793     /**
794      * @dev Emitted when `value` tokens are moved from one account (`from`) to
795      * another (`to`).
796      *
797      * Note that `value` may be zero.
798      */
799     event Transfer(address indexed from, address indexed to, uint256 value);
800 
801     /**
802      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
803      * a call to {approve}. `value` is the new allowance.
804      */
805     event Approval(address indexed owner, address indexed spender, uint256 value);
806 
807     /**
808      * @dev Returns the amount of tokens in existence.
809      */
810     function totalSupply() external view returns (uint256);
811 
812     /**
813      * @dev Returns the amount of tokens owned by `account`.
814      */
815     function balanceOf(address account) external view returns (uint256);
816 
817     /**
818      * @dev Moves `amount` tokens from the caller's account to `to`.
819      *
820      * Returns a boolean value indicating whether the operation succeeded.
821      *
822      * Emits a {Transfer} event.
823      */
824     function transfer(address to, uint256 amount) external returns (bool);
825 
826     /**
827      * @dev Returns the remaining number of tokens that `spender` will be
828      * allowed to spend on behalf of `owner` through {transferFrom}. This is
829      * zero by default.
830      *
831      * This value changes when {approve} or {transferFrom} are called.
832      */
833     function allowance(address owner, address spender) external view returns (uint256);
834 
835     /**
836      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
837      *
838      * Returns a boolean value indicating whether the operation succeeded.
839      *
840      * IMPORTANT: Beware that changing an allowance with this method brings the risk
841      * that someone may use both the old and the new allowance by unfortunate
842      * transaction ordering. One possible solution to mitigate this race
843      * condition is to first reduce the spender's allowance to 0 and set the
844      * desired value afterwards:
845      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
846      *
847      * Emits an {Approval} event.
848      */
849     function approve(address spender, uint256 amount) external returns (bool);
850 
851     /**
852      * @dev Moves `amount` tokens from `from` to `to` using the
853      * allowance mechanism. `amount` is then deducted from the caller's
854      * allowance.
855      *
856      * Returns a boolean value indicating whether the operation succeeded.
857      *
858      * Emits a {Transfer} event.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 amount
864     ) external returns (bool);
865 }
866 
867 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
868 
869 
870 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 /**
875  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
876  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
877  *
878  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
879  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
880  * need to send a transaction, and thus is not required to hold Ether at all.
881  */
882 interface IERC20Permit {
883     /**
884      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
885      * given ``owner``'s signed approval.
886      *
887      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
888      * ordering also apply here.
889      *
890      * Emits an {Approval} event.
891      *
892      * Requirements:
893      *
894      * - `spender` cannot be the zero address.
895      * - `deadline` must be a timestamp in the future.
896      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
897      * over the EIP712-formatted function arguments.
898      * - the signature must use ``owner``'s current nonce (see {nonces}).
899      *
900      * For more information on the signature format, see the
901      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
902      * section].
903      */
904     function permit(
905         address owner,
906         address spender,
907         uint256 value,
908         uint256 deadline,
909         uint8 v,
910         bytes32 r,
911         bytes32 s
912     ) external;
913 
914     /**
915      * @dev Returns the current nonce for `owner`. This value must be
916      * included whenever a signature is generated for {permit}.
917      *
918      * Every successful call to {permit} increases ``owner``'s nonce by one. This
919      * prevents a signature from being used multiple times.
920      */
921     function nonces(address owner) external view returns (uint256);
922 
923     /**
924      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
925      */
926     // solhint-disable-next-line func-name-mixedcase
927     function DOMAIN_SEPARATOR() external view returns (bytes32);
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
931 
932 
933 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 
939 /**
940  * @title SafeERC20
941  * @dev Wrappers around ERC20 operations that throw on failure (when the token
942  * contract returns false). Tokens that return no value (and instead revert or
943  * throw on failure) are also supported, non-reverting calls are assumed to be
944  * successful.
945  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
946  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
947  */
948 library SafeERC20 {
949     using Address for address;
950 
951     function safeTransfer(
952         IERC20 token,
953         address to,
954         uint256 value
955     ) internal {
956         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
957     }
958 
959     function safeTransferFrom(
960         IERC20 token,
961         address from,
962         address to,
963         uint256 value
964     ) internal {
965         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
966     }
967 
968     /**
969      * @dev Deprecated. This function has issues similar to the ones found in
970      * {IERC20-approve}, and its usage is discouraged.
971      *
972      * Whenever possible, use {safeIncreaseAllowance} and
973      * {safeDecreaseAllowance} instead.
974      */
975     function safeApprove(
976         IERC20 token,
977         address spender,
978         uint256 value
979     ) internal {
980         // safeApprove should only be called when setting an initial allowance,
981         // or when resetting it to zero. To increase and decrease it, use
982         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
983         require(
984             (value == 0) || (token.allowance(address(this), spender) == 0),
985             "SafeERC20: approve from non-zero to non-zero allowance"
986         );
987         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
988     }
989 
990     function safeIncreaseAllowance(
991         IERC20 token,
992         address spender,
993         uint256 value
994     ) internal {
995         uint256 newAllowance = token.allowance(address(this), spender) + value;
996         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
997     }
998 
999     function safeDecreaseAllowance(
1000         IERC20 token,
1001         address spender,
1002         uint256 value
1003     ) internal {
1004         unchecked {
1005             uint256 oldAllowance = token.allowance(address(this), spender);
1006             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1007             uint256 newAllowance = oldAllowance - value;
1008             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1009         }
1010     }
1011 
1012     function safePermit(
1013         IERC20Permit token,
1014         address owner,
1015         address spender,
1016         uint256 value,
1017         uint256 deadline,
1018         uint8 v,
1019         bytes32 r,
1020         bytes32 s
1021     ) internal {
1022         uint256 nonceBefore = token.nonces(owner);
1023         token.permit(owner, spender, value, deadline, v, r, s);
1024         uint256 nonceAfter = token.nonces(owner);
1025         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1026     }
1027 
1028     /**
1029      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1030      * on the return value: the return value is optional (but if data is returned, it must not be false).
1031      * @param token The token targeted by the call.
1032      * @param data The call data (encoded using abi.encode or one of its variants).
1033      */
1034     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1035         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1036         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1037         // the target address contains contract code and also asserts for success in the low-level call.
1038 
1039         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1040         if (returndata.length > 0) {
1041             // Return data is optional
1042             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1043         }
1044     }
1045 }
1046 
1047 // File: contracts/ISupportMint.sol
1048 
1049 
1050 pragma solidity >=0.4.22 <0.9.0;
1051 
1052 interface ISupportMint {
1053     function mint(address to, string memory hash, address minter) external;
1054 }
1055 
1056 // File: contracts/IReferBook.sol
1057 
1058 
1059 pragma solidity >=0.4.22 <0.9.0;
1060 
1061 interface IReferBook {
1062     function addReferForNoExist(address referral, address referrer) external;
1063 
1064     function getRefer(address referee) external view returns (address);
1065 }
1066 
1067 // File: contracts/NftMinter.sol
1068 
1069 
1070 
1071 pragma solidity >=0.4.22 <0.9.0;
1072 pragma experimental ABIEncoderV2;
1073 
1074 
1075 
1076 
1077 
1078 
1079 
1080 contract NftMinter is Ownable {
1081     using SafeERC20 for IERC20;
1082     
1083     uint256 public current_supply;
1084     uint256 public current_sold;
1085     IReferBook public referBook;
1086     uint8 public defaultRate;
1087     bool public sendCommission;
1088     uint public price;
1089     uint public buy_limit_per_address = 10;
1090     uint public sell_begin_time = 0;
1091     mapping (address => uint) public mintRecord;
1092     mapping (address => uint8) private _rates;
1093     mapping (address => bool) private _sendCommissions;
1094     ISupportMint public nft;
1095     bytes32 public merkleRoot;
1096     
1097     event Minted(address indexed owner, address indexed reffer, uint count, uint payment);
1098 
1099     constructor(address nft_) {
1100         nft = ISupportMint(nft_);
1101     }
1102 
1103     function rateX1000(address sells) public view returns(uint8) {
1104         address sender = msg.sender;
1105         require(sender == sells || sender == owner());
1106         return _rateImpl(sells);
1107     }
1108 
1109     function referrer(address referal) public view returns (address) {
1110         if (address(referBook) != address(0)) {
1111             return referBook.getRefer(referal);
1112         } else {
1113             return address(0);
1114         }
1115     }
1116 
1117     function openMintAndPricing(uint256 supply, uint256 _price, uint256 _limit, uint256 _time, bytes32 root) public onlyOwner {
1118         current_supply = supply;
1119         price = _price;
1120         buy_limit_per_address = _limit;
1121         sell_begin_time = _time;
1122         merkleRoot = root;
1123     }
1124 
1125     function setReferBook(IReferBook value) public onlyOwner {
1126         require(address(value) != address(0), "PARAM_ERROR");
1127         referBook = value;
1128     }
1129 
1130     function setRateX1000(uint8 defaultValue, address[] memory sells, uint8[] memory _sellRates) public onlyOwner {
1131         require(sells.length == _sellRates.length, "PARAM_ERROR");
1132         for (uint i = 0; i < sells.length; ++i) {
1133             _rates[sells[i]] = _sellRates[i];
1134         }
1135 
1136         defaultRate = defaultValue;
1137     }
1138 
1139     function setSendCommission(bool defaultValue, address[] memory sells, bool[] memory sends) public onlyOwner {
1140         require(sells.length == sends.length, "PARAM_ERROR");
1141         for (uint i = 0; i < sells.length; ++i) {
1142             _sendCommissions[sells[i]] = sends[i];
1143         }
1144 
1145         sendCommission = defaultValue;
1146     }
1147 
1148     function withdraw(address token) public onlyOwner {
1149         if (token == address(0)) {
1150             uint balance = address(this).balance;
1151             Address.sendValue(payable(owner()), balance);
1152         } else {
1153             IERC20 erc20 = IERC20(token);
1154             erc20.safeTransfer(owner(), erc20.balanceOf(address(this)));
1155         }
1156     }
1157 
1158     function buy(uint amount, address to, string memory hash, address referrer_, bytes32[] calldata _merkleProof) public payable {
1159         if (merkleRoot != 0) {
1160             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1161             require(
1162                 MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1163                 "Invalid proof."
1164             );
1165         }
1166         require(block.timestamp >= sell_begin_time, "Sell_Not_Start_Yet");
1167 
1168         mintRecord[msg.sender] = SafeMath.add(mintRecord[msg.sender], amount);
1169         require(mintRecord[msg.sender] <= buy_limit_per_address, "Exceed_Purchase_Limit");
1170         
1171         uint requiredValue = SafeMath.mul(amount, price);
1172         require(msg.value >= requiredValue, "Not_Enough_Payment");
1173 
1174         refer(referrer_);
1175         batchMintImpl(to, hash, amount);
1176 
1177         referrer_ = referrer(msg.sender);
1178         bool sc = _sendCommissions[referrer_];
1179         if (!sc) {
1180             sc = sendCommission;
1181         }
1182         if (sc && referrer_ != address(0)) {
1183             uint commission = _rateImpl(referrer_);
1184             commission = SafeMath.mul(requiredValue, commission) / 1000;
1185             Address.sendValue(payable(referrer_), commission);
1186         }
1187 
1188         emit Minted(msg.sender, referrer_, amount, requiredValue);
1189     }
1190 
1191     function batchMintImpl(address to, string memory hash, uint amount) private {
1192         current_sold = SafeMath.add(current_sold, amount);
1193         require(current_supply >= current_sold, "Not_Enough_Stock");
1194 
1195         for (uint i = 0; i < amount; ++i) {
1196             nft.mint(to, hash, to);
1197         }
1198     }
1199 
1200     function _rateImpl(address sells) private view returns (uint8) {
1201         uint8 result = _rates[sells];
1202         if (result == 0) {
1203             result = defaultRate;
1204         }
1205 
1206         return result;
1207     }
1208 
1209     function refer(address referrer_) private {
1210         require(!Address.isContract(referrer_), "human only!");
1211         if (address(referBook) != address(0)) {
1212             referBook.addReferForNoExist(_msgSender(), referrer_);
1213         }
1214     }
1215 }