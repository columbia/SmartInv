1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev These functions deal with verification of Merkle Tree proofs.
242  *
243  * The proofs can be generated using the JavaScript library
244  * https://github.com/miguelmota/merkletreejs[merkletreejs].
245  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
246  *
247  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
248  *
249  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
250  * hashing, or use a hash function other than keccak256 for hashing leaves.
251  * This is because the concatenation of a sorted pair of internal nodes in
252  * the merkle tree could be reinterpreted as a leaf value.
253  */
254 library MerkleProof {
255     /**
256      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
257      * defined by `root`. For this, a `proof` must be provided, containing
258      * sibling hashes on the branch from the leaf to the root of the tree. Each
259      * pair of leaves and each pair of pre-images are assumed to be sorted.
260      */
261     function verify(
262         bytes32[] memory proof,
263         bytes32 root,
264         bytes32 leaf
265     ) internal pure returns (bool) {
266         return processProof(proof, leaf) == root;
267     }
268 
269     /**
270      * @dev Calldata version of {verify}
271      *
272      * _Available since v4.7._
273      */
274     function verifyCalldata(
275         bytes32[] calldata proof,
276         bytes32 root,
277         bytes32 leaf
278     ) internal pure returns (bool) {
279         return processProofCalldata(proof, leaf) == root;
280     }
281 
282     /**
283      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
284      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
285      * hash matches the root of the tree. When processing the proof, the pairs
286      * of leafs & pre-images are assumed to be sorted.
287      *
288      * _Available since v4.4._
289      */
290     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
291         bytes32 computedHash = leaf;
292         for (uint256 i = 0; i < proof.length; i++) {
293             computedHash = _hashPair(computedHash, proof[i]);
294         }
295         return computedHash;
296     }
297 
298     /**
299      * @dev Calldata version of {processProof}
300      *
301      * _Available since v4.7._
302      */
303     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
304         bytes32 computedHash = leaf;
305         for (uint256 i = 0; i < proof.length; i++) {
306             computedHash = _hashPair(computedHash, proof[i]);
307         }
308         return computedHash;
309     }
310 
311     /**
312      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
313      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
314      *
315      * _Available since v4.7._
316      */
317     function multiProofVerify(
318         bytes32[] memory proof,
319         bool[] memory proofFlags,
320         bytes32 root,
321         bytes32[] memory leaves
322     ) internal pure returns (bool) {
323         return processMultiProof(proof, proofFlags, leaves) == root;
324     }
325 
326     /**
327      * @dev Calldata version of {multiProofVerify}
328      *
329      * _Available since v4.7._
330      */
331     function multiProofVerifyCalldata(
332         bytes32[] calldata proof,
333         bool[] calldata proofFlags,
334         bytes32 root,
335         bytes32[] memory leaves
336     ) internal pure returns (bool) {
337         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
338     }
339 
340     /**
341      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
342      * consuming from one or the other at each step according to the instructions given by
343      * `proofFlags`.
344      *
345      * _Available since v4.7._
346      */
347     function processMultiProof(
348         bytes32[] memory proof,
349         bool[] memory proofFlags,
350         bytes32[] memory leaves
351     ) internal pure returns (bytes32 merkleRoot) {
352         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
353         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
354         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
355         // the merkle tree.
356         uint256 leavesLen = leaves.length;
357         uint256 totalHashes = proofFlags.length;
358 
359         // Check proof validity.
360         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
361 
362         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
363         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
364         bytes32[] memory hashes = new bytes32[](totalHashes);
365         uint256 leafPos = 0;
366         uint256 hashPos = 0;
367         uint256 proofPos = 0;
368         // At each step, we compute the next hash using two values:
369         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
370         //   get the next hash.
371         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
372         //   `proof` array.
373         for (uint256 i = 0; i < totalHashes; i++) {
374             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
375             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
376             hashes[i] = _hashPair(a, b);
377         }
378 
379         if (totalHashes > 0) {
380             return hashes[totalHashes - 1];
381         } else if (leavesLen > 0) {
382             return leaves[0];
383         } else {
384             return proof[0];
385         }
386     }
387 
388     /**
389      * @dev Calldata version of {processMultiProof}
390      *
391      * _Available since v4.7._
392      */
393     function processMultiProofCalldata(
394         bytes32[] calldata proof,
395         bool[] calldata proofFlags,
396         bytes32[] memory leaves
397     ) internal pure returns (bytes32 merkleRoot) {
398         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
399         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
400         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
401         // the merkle tree.
402         uint256 leavesLen = leaves.length;
403         uint256 totalHashes = proofFlags.length;
404 
405         // Check proof validity.
406         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
407 
408         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
409         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
410         bytes32[] memory hashes = new bytes32[](totalHashes);
411         uint256 leafPos = 0;
412         uint256 hashPos = 0;
413         uint256 proofPos = 0;
414         // At each step, we compute the next hash using two values:
415         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
416         //   get the next hash.
417         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
418         //   `proof` array.
419         for (uint256 i = 0; i < totalHashes; i++) {
420             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
421             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
422             hashes[i] = _hashPair(a, b);
423         }
424 
425         if (totalHashes > 0) {
426             return hashes[totalHashes - 1];
427         } else if (leavesLen > 0) {
428             return leaves[0];
429         } else {
430             return proof[0];
431         }
432     }
433 
434     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
435         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
436     }
437 
438     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
439         /// @solidity memory-safe-assembly
440         assembly {
441             mstore(0x00, a)
442             mstore(0x20, b)
443             value := keccak256(0x00, 0x40)
444         }
445     }
446 }
447 
448 // File: @openzeppelin/contracts/utils/Strings.sol
449 
450 
451 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev String operations.
457  */
458 library Strings {
459     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
460     uint8 private constant _ADDRESS_LENGTH = 20;
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
464      */
465     function toString(uint256 value) internal pure returns (string memory) {
466         // Inspired by OraclizeAPI's implementation - MIT licence
467         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
468 
469         if (value == 0) {
470             return "0";
471         }
472         uint256 temp = value;
473         uint256 digits;
474         while (temp != 0) {
475             digits++;
476             temp /= 10;
477         }
478         bytes memory buffer = new bytes(digits);
479         while (value != 0) {
480             digits -= 1;
481             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
482             value /= 10;
483         }
484         return string(buffer);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
489      */
490     function toHexString(uint256 value) internal pure returns (string memory) {
491         if (value == 0) {
492             return "0x00";
493         }
494         uint256 temp = value;
495         uint256 length = 0;
496         while (temp != 0) {
497             length++;
498             temp >>= 8;
499         }
500         return toHexString(value, length);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
505      */
506     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
507         bytes memory buffer = new bytes(2 * length + 2);
508         buffer[0] = "0";
509         buffer[1] = "x";
510         for (uint256 i = 2 * length + 1; i > 1; --i) {
511             buffer[i] = _HEX_SYMBOLS[value & 0xf];
512             value >>= 4;
513         }
514         require(value == 0, "Strings: hex length insufficient");
515         return string(buffer);
516     }
517 
518     /**
519      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
520      */
521     function toHexString(address addr) internal pure returns (string memory) {
522         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
523     }
524 }
525 
526 // File: @openzeppelin/contracts/utils/Address.sol
527 
528 
529 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
530 
531 pragma solidity ^0.8.1;
532 
533 /**
534  * @dev Collection of functions related to the address type
535  */
536 library Address {
537     /**
538      * @dev Returns true if `account` is a contract.
539      *
540      * [IMPORTANT]
541      * ====
542      * It is unsafe to assume that an address for which this function returns
543      * false is an externally-owned account (EOA) and not a contract.
544      *
545      * Among others, `isContract` will return false for the following
546      * types of addresses:
547      *
548      *  - an externally-owned account
549      *  - a contract in construction
550      *  - an address where a contract will be created
551      *  - an address where a contract lived, but was destroyed
552      * ====
553      *
554      * [IMPORTANT]
555      * ====
556      * You shouldn't rely on `isContract` to protect against flash loan attacks!
557      *
558      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
559      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
560      * constructor.
561      * ====
562      */
563     function isContract(address account) internal view returns (bool) {
564         // This method relies on extcodesize/address.code.length, which returns 0
565         // for contracts in construction, since the code is only stored at the end
566         // of the constructor execution.
567 
568         return account.code.length > 0;
569     }
570 
571     /**
572      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
573      * `recipient`, forwarding all available gas and reverting on errors.
574      *
575      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
576      * of certain opcodes, possibly making contracts go over the 2300 gas limit
577      * imposed by `transfer`, making them unable to receive funds via
578      * `transfer`. {sendValue} removes this limitation.
579      *
580      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
581      *
582      * IMPORTANT: because control is transferred to `recipient`, care must be
583      * taken to not create reentrancy vulnerabilities. Consider using
584      * {ReentrancyGuard} or the
585      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
586      */
587     function sendValue(address payable recipient, uint256 amount) internal {
588         require(address(this).balance >= amount, "Address: insufficient balance");
589 
590         (bool success, ) = recipient.call{value: amount}("");
591         require(success, "Address: unable to send value, recipient may have reverted");
592     }
593 
594     /**
595      * @dev Performs a Solidity function call using a low level `call`. A
596      * plain `call` is an unsafe replacement for a function call: use this
597      * function instead.
598      *
599      * If `target` reverts with a revert reason, it is bubbled up by this
600      * function (like regular Solidity function calls).
601      *
602      * Returns the raw returned data. To convert to the expected return value,
603      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
604      *
605      * Requirements:
606      *
607      * - `target` must be a contract.
608      * - calling `target` with `data` must not revert.
609      *
610      * _Available since v3.1._
611      */
612     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
613         return functionCall(target, data, "Address: low-level call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
618      * `errorMessage` as a fallback revert reason when `target` reverts.
619      *
620      * _Available since v3.1._
621      */
622     function functionCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal returns (bytes memory) {
627         return functionCallWithValue(target, data, 0, errorMessage);
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
632      * but also transferring `value` wei to `target`.
633      *
634      * Requirements:
635      *
636      * - the calling contract must have an ETH balance of at least `value`.
637      * - the called Solidity function must be `payable`.
638      *
639      * _Available since v3.1._
640      */
641     function functionCallWithValue(
642         address target,
643         bytes memory data,
644         uint256 value
645     ) internal returns (bytes memory) {
646         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
651      * with `errorMessage` as a fallback revert reason when `target` reverts.
652      *
653      * _Available since v3.1._
654      */
655     function functionCallWithValue(
656         address target,
657         bytes memory data,
658         uint256 value,
659         string memory errorMessage
660     ) internal returns (bytes memory) {
661         require(address(this).balance >= value, "Address: insufficient balance for call");
662         require(isContract(target), "Address: call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.call{value: value}(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
670      * but performing a static call.
671      *
672      * _Available since v3.3._
673      */
674     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
675         return functionStaticCall(target, data, "Address: low-level static call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
680      * but performing a static call.
681      *
682      * _Available since v3.3._
683      */
684     function functionStaticCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal view returns (bytes memory) {
689         require(isContract(target), "Address: static call to non-contract");
690 
691         (bool success, bytes memory returndata) = target.staticcall(data);
692         return verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
697      * but performing a delegate call.
698      *
699      * _Available since v3.4._
700      */
701     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
702         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
707      * but performing a delegate call.
708      *
709      * _Available since v3.4._
710      */
711     function functionDelegateCall(
712         address target,
713         bytes memory data,
714         string memory errorMessage
715     ) internal returns (bytes memory) {
716         require(isContract(target), "Address: delegate call to non-contract");
717 
718         (bool success, bytes memory returndata) = target.delegatecall(data);
719         return verifyCallResult(success, returndata, errorMessage);
720     }
721 
722     /**
723      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
724      * revert reason using the provided one.
725      *
726      * _Available since v4.3._
727      */
728     function verifyCallResult(
729         bool success,
730         bytes memory returndata,
731         string memory errorMessage
732     ) internal pure returns (bytes memory) {
733         if (success) {
734             return returndata;
735         } else {
736             // Look for revert reason and bubble it up if present
737             if (returndata.length > 0) {
738                 // The easiest way to bubble the revert reason is using memory via assembly
739                 /// @solidity memory-safe-assembly
740                 assembly {
741                     let returndata_size := mload(returndata)
742                     revert(add(32, returndata), returndata_size)
743                 }
744             } else {
745                 revert(errorMessage);
746             }
747         }
748     }
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
752 
753 
754 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 /**
759  * @title ERC721 token receiver interface
760  * @dev Interface for any contract that wants to support safeTransfers
761  * from ERC721 asset contracts.
762  */
763 interface IERC721Receiver {
764     /**
765      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
766      * by `operator` from `from`, this function is called.
767      *
768      * It must return its Solidity selector to confirm the token transfer.
769      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
770      *
771      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
772      */
773     function onERC721Received(
774         address operator,
775         address from,
776         uint256 tokenId,
777         bytes calldata data
778     ) external returns (bytes4);
779 }
780 
781 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
782 
783 
784 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 /**
789  * @dev Interface of the ERC165 standard, as defined in the
790  * https://eips.ethereum.org/EIPS/eip-165[EIP].
791  *
792  * Implementers can declare support of contract interfaces, which can then be
793  * queried by others ({ERC165Checker}).
794  *
795  * For an implementation, see {ERC165}.
796  */
797 interface IERC165 {
798     /**
799      * @dev Returns true if this contract implements the interface defined by
800      * `interfaceId`. See the corresponding
801      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
802      * to learn more about how these ids are created.
803      *
804      * This function call must use less than 30 000 gas.
805      */
806     function supportsInterface(bytes4 interfaceId) external view returns (bool);
807 }
808 
809 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
810 
811 
812 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 
817 /**
818  * @dev Implementation of the {IERC165} interface.
819  *
820  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
821  * for the additional interface id that will be supported. For example:
822  *
823  * ```solidity
824  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
825  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
826  * }
827  * ```
828  *
829  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
830  */
831 abstract contract ERC165 is IERC165 {
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
836         return interfaceId == type(IERC165).interfaceId;
837     }
838 }
839 
840 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
841 
842 
843 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 
848 /**
849  * @dev Required interface of an ERC721 compliant contract.
850  */
851 interface IERC721 is IERC165 {
852     /**
853      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
854      */
855     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
856 
857     /**
858      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
859      */
860     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
861 
862     /**
863      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
864      */
865     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
866 
867     /**
868      * @dev Returns the number of tokens in ``owner``'s account.
869      */
870     function balanceOf(address owner) external view returns (uint256 balance);
871 
872     /**
873      * @dev Returns the owner of the `tokenId` token.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function ownerOf(uint256 tokenId) external view returns (address owner);
880 
881     /**
882      * @dev Safely transfers `tokenId` token from `from` to `to`.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must exist and be owned by `from`.
889      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
891      *
892      * Emits a {Transfer} event.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId,
898         bytes calldata data
899     ) external;
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
903      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) external;
920 
921     /**
922      * @dev Transfers `tokenId` token from `from` to `to`.
923      *
924      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must be owned by `from`.
931      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
932      *
933      * Emits a {Transfer} event.
934      */
935     function transferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) external;
940 
941     /**
942      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
943      * The approval is cleared when the token is transferred.
944      *
945      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
946      *
947      * Requirements:
948      *
949      * - The caller must own the token or be an approved operator.
950      * - `tokenId` must exist.
951      *
952      * Emits an {Approval} event.
953      */
954     function approve(address to, uint256 tokenId) external;
955 
956     /**
957      * @dev Approve or remove `operator` as an operator for the caller.
958      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
959      *
960      * Requirements:
961      *
962      * - The `operator` cannot be the caller.
963      *
964      * Emits an {ApprovalForAll} event.
965      */
966     function setApprovalForAll(address operator, bool _approved) external;
967 
968     /**
969      * @dev Returns the account approved for `tokenId` token.
970      *
971      * Requirements:
972      *
973      * - `tokenId` must exist.
974      */
975     function getApproved(uint256 tokenId) external view returns (address operator);
976 
977     /**
978      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
979      *
980      * See {setApprovalForAll}
981      */
982     function isApprovedForAll(address owner, address operator) external view returns (bool);
983 }
984 
985 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
986 
987 
988 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
989 
990 pragma solidity ^0.8.0;
991 
992 
993 /**
994  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
995  * @dev See https://eips.ethereum.org/EIPS/eip-721
996  */
997 interface IERC721Enumerable is IERC721 {
998     /**
999      * @dev Returns the total amount of tokens stored by the contract.
1000      */
1001     function totalSupply() external view returns (uint256);
1002 
1003     /**
1004      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1005      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1006      */
1007     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1008 
1009     /**
1010      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1011      * Use along with {totalSupply} to enumerate all tokens.
1012      */
1013     function tokenByIndex(uint256 index) external view returns (uint256);
1014 }
1015 
1016 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1017 
1018 
1019 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 /**
1025  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1026  * @dev See https://eips.ethereum.org/EIPS/eip-721
1027  */
1028 interface IERC721Metadata is IERC721 {
1029     /**
1030      * @dev Returns the token collection name.
1031      */
1032     function name() external view returns (string memory);
1033 
1034     /**
1035      * @dev Returns the token collection symbol.
1036      */
1037     function symbol() external view returns (string memory);
1038 
1039     /**
1040      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1041      */
1042     function tokenURI(uint256 tokenId) external view returns (string memory);
1043 }
1044 
1045 // File: @openzeppelin/contracts/utils/Context.sol
1046 
1047 
1048 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1049 
1050 pragma solidity ^0.8.0;
1051 
1052 /**
1053  * @dev Provides information about the current execution context, including the
1054  * sender of the transaction and its data. While these are generally available
1055  * via msg.sender and msg.data, they should not be accessed in such a direct
1056  * manner, since when dealing with meta-transactions the account sending and
1057  * paying for execution may not be the actual sender (as far as an application
1058  * is concerned).
1059  *
1060  * This contract is only required for intermediate, library-like contracts.
1061  */
1062 abstract contract Context {
1063     function _msgSender() internal view virtual returns (address) {
1064         return msg.sender;
1065     }
1066 
1067     function _msgData() internal view virtual returns (bytes calldata) {
1068         return msg.data;
1069     }
1070 }
1071 
1072 // File: contracts/ERC721A.sol
1073 
1074 
1075 
1076 pragma solidity ^0.8.0;
1077 
1078 
1079 
1080 
1081 
1082 
1083 
1084 
1085 
1086 /**
1087  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1088  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1089  *
1090  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1091  *
1092  * Does not support burning tokens to address(0).
1093  *
1094  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1095  */
1096 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1097     using Address for address;
1098     using Strings for uint256;
1099 
1100     struct TokenOwnership {
1101         address addr;
1102         uint64 startTimestamp;
1103     }
1104 
1105     struct AddressData {
1106         uint128 balance;
1107         uint128 numberMinted;
1108     }
1109 
1110     uint256 internal currentIndex;
1111 
1112     // Token name
1113     string private _name;
1114 
1115     // Token symbol
1116     string private _symbol;
1117 
1118     // Mapping from token ID to ownership details
1119     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1120     mapping(uint256 => TokenOwnership) internal _ownerships;
1121 
1122     // Mapping owner address to address data
1123     mapping(address => AddressData) private _addressData;
1124 
1125     // Mapping from token ID to approved address
1126     mapping(uint256 => address) private _tokenApprovals;
1127 
1128     // Mapping from owner to operator approvals
1129     mapping(address => mapping(address => bool)) private _operatorApprovals;
1130 
1131     constructor(string memory name_, string memory symbol_) {
1132         _name = name_;
1133         _symbol = symbol_;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Enumerable-totalSupply}.
1138      */
1139     function totalSupply() public view override returns (uint256) {
1140         return currentIndex;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Enumerable-tokenByIndex}.
1145      */
1146     function tokenByIndex(uint256 index) public view override returns (uint256) {
1147         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1148         return index;
1149     }
1150 
1151     /**
1152      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1153      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1154      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1155      */
1156     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1157         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1158         uint256 numMintedSoFar = totalSupply();
1159         uint256 tokenIdsIdx;
1160         address currOwnershipAddr;
1161 
1162         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1163         unchecked {
1164             for (uint256 i; i < numMintedSoFar; i++) {
1165                 TokenOwnership memory ownership = _ownerships[i];
1166                 if (ownership.addr != address(0)) {
1167                     currOwnershipAddr = ownership.addr;
1168                 }
1169                 if (currOwnershipAddr == owner) {
1170                     if (tokenIdsIdx == index) {
1171                         return i;
1172                     }
1173                     tokenIdsIdx++;
1174                 }
1175             }
1176         }
1177 
1178         revert('ERC721A: unable to get token of owner by index');
1179     }
1180 
1181     /**
1182      * @dev See {IERC165-supportsInterface}.
1183      */
1184     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1185         return
1186             interfaceId == type(IERC721).interfaceId ||
1187             interfaceId == type(IERC721Metadata).interfaceId ||
1188             interfaceId == type(IERC721Enumerable).interfaceId ||
1189             super.supportsInterface(interfaceId);
1190     }
1191 
1192     /**
1193      * @dev See {IERC721-balanceOf}.
1194      */
1195     function balanceOf(address owner) public view override returns (uint256) {
1196         require(owner != address(0), 'ERC721A: balance query for the zero address');
1197         return uint256(_addressData[owner].balance);
1198     }
1199 
1200     function _numberMinted(address owner) internal view returns (uint256) {
1201         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1202         return uint256(_addressData[owner].numberMinted);
1203     }
1204 
1205     /**
1206      * Gas spent here starts off proportional to the maximum mint batch size.
1207      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1208      */
1209     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1210         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1211 
1212         unchecked {
1213             for (uint256 curr = tokenId; curr >= 0; curr--) {
1214                 TokenOwnership memory ownership = _ownerships[curr];
1215                 if (ownership.addr != address(0)) {
1216                     return ownership;
1217                 }
1218             }
1219         }
1220 
1221         revert('ERC721A: unable to determine the owner of token');
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-ownerOf}.
1226      */
1227     function ownerOf(uint256 tokenId) public view override returns (address) {
1228         return ownershipOf(tokenId).addr;
1229     }
1230 
1231     /**
1232      * @dev See {IERC721Metadata-name}.
1233      */
1234     function name() public view virtual override returns (string memory) {
1235         return _name;
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Metadata-symbol}.
1240      */
1241     function symbol() public view virtual override returns (string memory) {
1242         return _symbol;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-tokenURI}.
1247      */
1248     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1249         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1250 
1251         string memory baseURI = _baseURI();
1252         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1253     }
1254 
1255     /**
1256      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1257      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1258      * by default, can be overriden in child contracts.
1259      */
1260     function _baseURI() internal view virtual returns (string memory) {
1261         return '';
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-approve}.
1266      */
1267     function approve(address to, uint256 tokenId) public override {
1268         address owner = ERC721A.ownerOf(tokenId);
1269         require(to != owner, 'ERC721A: approval to current owner');
1270 
1271         require(
1272             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1273             'ERC721A: approve caller is not owner nor approved for all'
1274         );
1275 
1276         _approve(to, tokenId, owner);
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-getApproved}.
1281      */
1282     function getApproved(uint256 tokenId) public view override returns (address) {
1283         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1284 
1285         return _tokenApprovals[tokenId];
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-setApprovalForAll}.
1290      */
1291     function setApprovalForAll(address operator, bool approved) public override {
1292         require(operator != _msgSender(), 'ERC721A: approve to caller');
1293 
1294         _operatorApprovals[_msgSender()][operator] = approved;
1295         emit ApprovalForAll(_msgSender(), operator, approved);
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-isApprovedForAll}.
1300      */
1301     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1302         return _operatorApprovals[owner][operator];
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-transferFrom}.
1307      */
1308     function transferFrom(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) public override {
1313         _transfer(from, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-safeTransferFrom}.
1318      */
1319     function safeTransferFrom(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) public override {
1324         safeTransferFrom(from, to, tokenId, '');
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-safeTransferFrom}.
1329      */
1330     function safeTransferFrom(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) public override {
1336         _transfer(from, to, tokenId);
1337         require(
1338             _checkOnERC721Received(from, to, tokenId, _data),
1339             'ERC721A: transfer to non ERC721Receiver implementer'
1340         );
1341     }
1342 
1343     /**
1344      * @dev Returns whether `tokenId` exists.
1345      *
1346      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1347      *
1348      * Tokens start existing when they are minted (`_mint`),
1349      */
1350     function _exists(uint256 tokenId) internal view returns (bool) {
1351         return tokenId < currentIndex;
1352     }
1353 
1354     function _safeMint(address to, uint256 quantity) internal {
1355         _safeMint(to, quantity, '');
1356     }
1357 
1358     /**
1359      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1360      *
1361      * Requirements:
1362      *
1363      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1364      * - `quantity` must be greater than 0.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function _safeMint(
1369         address to,
1370         uint256 quantity,
1371         bytes memory _data
1372     ) internal {
1373         _mint(to, quantity, _data, true);
1374     }
1375 
1376     /**
1377      * @dev Mints `quantity` tokens and transfers them to `to`.
1378      *
1379      * Requirements:
1380      *
1381      * - `to` cannot be the zero address.
1382      * - `quantity` must be greater than 0.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function _mint(
1387         address to,
1388         uint256 quantity,
1389         bytes memory _data,
1390         bool safe
1391     ) internal {
1392         uint256 startTokenId = currentIndex;
1393         require(to != address(0), 'ERC721A: mint to the zero address');
1394         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1395 
1396         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1397 
1398         // Overflows are incredibly unrealistic.
1399         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1400         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1401         unchecked {
1402             _addressData[to].balance += uint128(quantity);
1403             _addressData[to].numberMinted += uint128(quantity);
1404 
1405             _ownerships[startTokenId].addr = to;
1406             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1407 
1408             uint256 updatedIndex = startTokenId;
1409 
1410             for (uint256 i; i < quantity; i++) {
1411                 emit Transfer(address(0), to, updatedIndex);
1412                 if (safe) {
1413                     require(
1414                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1415                         'ERC721A: transfer to non ERC721Receiver implementer'
1416                     );
1417                 }
1418 
1419                 updatedIndex++;
1420             }
1421 
1422             currentIndex = updatedIndex;
1423         }
1424 
1425         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1426     }
1427 
1428     /**
1429      * @dev Transfers `tokenId` from `from` to `to`.
1430      *
1431      * Requirements:
1432      *
1433      * - `to` cannot be the zero address.
1434      * - `tokenId` token must be owned by `from`.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function _transfer(
1439         address from,
1440         address to,
1441         uint256 tokenId
1442     ) private {
1443         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1444 
1445         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1446             getApproved(tokenId) == _msgSender() ||
1447             isApprovedForAll(prevOwnership.addr, _msgSender()));
1448 
1449         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1450 
1451         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1452         require(to != address(0), 'ERC721A: transfer to the zero address');
1453 
1454         _beforeTokenTransfers(from, to, tokenId, 1);
1455 
1456         // Clear approvals from the previous owner
1457         _approve(address(0), tokenId, prevOwnership.addr);
1458 
1459         // Underflow of the sender's balance is impossible because we check for
1460         // ownership above and the recipient's balance can't realistically overflow.
1461         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1462         unchecked {
1463             _addressData[from].balance -= 1;
1464             _addressData[to].balance += 1;
1465 
1466             _ownerships[tokenId].addr = to;
1467             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1468 
1469             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1470             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1471             uint256 nextTokenId = tokenId + 1;
1472             if (_ownerships[nextTokenId].addr == address(0)) {
1473                 if (_exists(nextTokenId)) {
1474                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1475                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1476                 }
1477             }
1478         }
1479 
1480         emit Transfer(from, to, tokenId);
1481         _afterTokenTransfers(from, to, tokenId, 1);
1482     }
1483 
1484     /**
1485      * @dev Approve `to` to operate on `tokenId`
1486      *
1487      * Emits a {Approval} event.
1488      */
1489     function _approve(
1490         address to,
1491         uint256 tokenId,
1492         address owner
1493     ) private {
1494         _tokenApprovals[tokenId] = to;
1495         emit Approval(owner, to, tokenId);
1496     }
1497 
1498     /**
1499      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1500      * The call is not executed if the target address is not a contract.
1501      *
1502      * @param from address representing the previous owner of the given token ID
1503      * @param to target address that will receive the tokens
1504      * @param tokenId uint256 ID of the token to be transferred
1505      * @param _data bytes optional data to send along with the call
1506      * @return bool whether the call correctly returned the expected magic value
1507      */
1508     function _checkOnERC721Received(
1509         address from,
1510         address to,
1511         uint256 tokenId,
1512         bytes memory _data
1513     ) private returns (bool) {
1514         if (to.isContract()) {
1515             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1516                 return retval == IERC721Receiver(to).onERC721Received.selector;
1517             } catch (bytes memory reason) {
1518                 if (reason.length == 0) {
1519                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1520                 } else {
1521                     assembly {
1522                         revert(add(32, reason), mload(reason))
1523                     }
1524                 }
1525             }
1526         } else {
1527             return true;
1528         }
1529     }
1530 
1531     /**
1532      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1533      *
1534      * startTokenId - the first token id to be transferred
1535      * quantity - the amount to be transferred
1536      *
1537      * Calling conditions:
1538      *
1539      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1540      * transferred to `to`.
1541      * - When `from` is zero, `tokenId` will be minted for `to`.
1542      */
1543     function _beforeTokenTransfers(
1544         address from,
1545         address to,
1546         uint256 startTokenId,
1547         uint256 quantity
1548     ) internal virtual {}
1549 
1550     /**
1551      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1552      * minting.
1553      *
1554      * startTokenId - the first token id to be transferred
1555      * quantity - the amount to be transferred
1556      *
1557      * Calling conditions:
1558      *
1559      * - when `from` and `to` are both non-zero.
1560      * - `from` and `to` are never both zero.
1561      */
1562     function _afterTokenTransfers(
1563         address from,
1564         address to,
1565         uint256 startTokenId,
1566         uint256 quantity
1567     ) internal virtual {}
1568 }
1569 // File: @openzeppelin/contracts/access/Ownable.sol
1570 
1571 
1572 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1573 
1574 pragma solidity ^0.8.0;
1575 
1576 
1577 /**
1578  * @dev Contract module which provides a basic access control mechanism, where
1579  * there is an account (an owner) that can be granted exclusive access to
1580  * specific functions.
1581  *
1582  * By default, the owner account will be the one that deploys the contract. This
1583  * can later be changed with {transferOwnership}.
1584  *
1585  * This module is used through inheritance. It will make available the modifier
1586  * `onlyOwner`, which can be applied to your functions to restrict their use to
1587  * the owner.
1588  */
1589 abstract contract Ownable is Context {
1590     address private _owner;
1591 
1592     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1593 
1594     /**
1595      * @dev Initializes the contract setting the deployer as the initial owner.
1596      */
1597     constructor() {
1598         _transferOwnership(_msgSender());
1599     }
1600 
1601     /**
1602      * @dev Throws if called by any account other than the owner.
1603      */
1604     modifier onlyOwner() {
1605         _checkOwner();
1606         _;
1607     }
1608 
1609     /**
1610      * @dev Returns the address of the current owner.
1611      */
1612     function owner() public view virtual returns (address) {
1613         return _owner;
1614     }
1615 
1616     /**
1617      * @dev Throws if the sender is not the owner.
1618      */
1619     function _checkOwner() internal view virtual {
1620         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1621     }
1622 
1623     /**
1624      * @dev Leaves the contract without owner. It will not be possible to call
1625      * `onlyOwner` functions anymore. Can only be called by the current owner.
1626      *
1627      * NOTE: Renouncing ownership will leave the contract without an owner,
1628      * thereby removing any functionality that is only available to the owner.
1629      */
1630     function renounceOwnership() public virtual onlyOwner {
1631         _transferOwnership(address(0));
1632     }
1633 
1634     /**
1635      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1636      * Can only be called by the current owner.
1637      */
1638     function transferOwnership(address newOwner) public virtual onlyOwner {
1639         require(newOwner != address(0), "Ownable: new owner is the zero address");
1640         _transferOwnership(newOwner);
1641     }
1642 
1643     /**
1644      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1645      * Internal function without access restriction.
1646      */
1647     function _transferOwnership(address newOwner) internal virtual {
1648         address oldOwner = _owner;
1649         _owner = newOwner;
1650         emit OwnershipTransferred(oldOwner, newOwner);
1651     }
1652 }
1653 
1654 // File: contracts/tenya-reopass.sol
1655 
1656 
1657 pragma solidity ^0.8.0;
1658 
1659 contract TenyaReoPass is ERC721A, Ownable {
1660 
1661   using SafeMath for uint256;
1662   using Strings for uint256;
1663   string private _baseUri;
1664   string private _notRevealURI; 
1665   bool public RevealedActive = false;
1666   uint256 public PricePublicSale = 0.03 ether;
1667   uint256 public Price = 0 ether;
1668   uint256 public MaxToken = 4000;
1669   uint256 public TokenIndex = 0;
1670   event TokenMinted(uint256 supply);
1671   enum Steps {Launch, PublicMint, OGMint, WLMint, Sale, SoldOut}
1672   Steps public sellingStep;
1673   mapping (address => uint256) public MaxPublicMint;
1674   mapping (address => uint256) public MaxOGMint;
1675   mapping (address => uint256) public MaxWLMint;
1676   mapping (address => uint256) public MaxFinalMint;
1677   bytes32 public merkleRootOG;
1678   bytes32 public merkleRootNormalWL;
1679 
1680   constructor() ERC721A("Reo Pass", "REO") {sellingStep = Steps.Launch;}
1681 
1682   function _baseURI() internal view virtual override returns (string memory) { return _baseUri; }
1683 
1684   function tokenURI(uint256 tokenId) public view virtual override returns (string memory a) {
1685     require(_exists(tokenId), "ERC721 Metadata: URI query for nonexistent token");
1686     if (totalSupply() >= MaxToken || RevealedActive == true) {
1687       if (tokenId < MaxToken) {
1688         uint256 offsetId = tokenId.add(MaxToken.sub(TokenIndex)).mod(MaxToken);
1689         return string(abi.encodePacked(_baseURI(), "reopass-", offsetId.toString(), ".json"));
1690       }
1691     } else { return _notRevealURI; }
1692   }
1693 
1694   function mintPublic(uint8 mintAmount) public payable {
1695     require(sellingStep == Steps.PublicMint, "Public Mint has not started");
1696     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");
1697     require(MaxPublicMint[msg.sender] + mintAmount <= 3, "Max NFTs Reached");
1698     require(mintAmount > 0, "At least one should be minted");
1699     MaxPublicMint[msg.sender] += mintAmount;
1700     require(PricePublicSale * mintAmount <= msg.value, "Not enough funds");
1701     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1702     _mint(msg.sender, mintAmount);
1703     emit TokenMinted(totalSupply());
1704   }
1705 
1706   function mintOG(uint8 mintAmount , address _account, bytes32[] calldata _proof) public payable {
1707     require(sellingStep == Steps.OGMint, "OG Mint has not started");
1708     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");
1709     require(isOGWhitelisted(_account, _proof), "Account address not eligilble(not part of OG).");
1710     require(isOGWhitelisted(msg.sender, _proof), "Account address is not the function caller.");
1711     require(mintAmount > 0, "At least one should be minted");
1712     require(MaxOGMint[msg.sender] + mintAmount <= 1, "Max NFTs Reached");
1713     MaxOGMint[msg.sender] += mintAmount;
1714     require(Price * mintAmount <= msg.value, "Not enough funds");
1715     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1716     _mint(msg.sender, mintAmount);
1717     emit TokenMinted(totalSupply());
1718   }
1719 
1720   function mintWL(uint8 mintAmount , address _account, bytes32[] calldata _proof) public payable {
1721     require(sellingStep == Steps.WLMint, "WL Mint has not started");
1722     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");
1723     require(isWalletWhiteListed(_account, _proof), "Account address not eligilble(not part of WL).");
1724     require(isWalletWhiteListed(msg.sender, _proof), "Account address is not the function caller.");
1725     require(mintAmount > 0, "At least one should be minted");
1726     require(MaxWLMint[msg.sender] + mintAmount <= 1, "Max NFTs Reached");
1727     MaxWLMint[msg.sender] += mintAmount;
1728     require(Price * mintAmount <= msg.value, "Not enough funds");
1729     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1730     _mint(msg.sender, mintAmount);
1731     emit TokenMinted(totalSupply());
1732   }
1733 
1734   function mint(uint8 mintAmount) public payable {
1735     require(sellingStep != Steps.SoldOut, "Sold Out");
1736     require(sellingStep == Steps.Sale, "Final Sale has not started");
1737     require(totalSupply().add(mintAmount) <= MaxToken, "Sold Out");    
1738     require(mintAmount > 0, "At least one should be minted");                                                          
1739     require(MaxFinalMint[msg.sender] + mintAmount <= 3, "Max NFTs Reached");
1740     MaxFinalMint[msg.sender] += mintAmount;
1741     require(PricePublicSale * mintAmount <= msg.value, "Not enough funds"); 
1742     if(totalSupply() + mintAmount == MaxToken) { sellingStep = Steps.SoldOut; }
1743     _mint(msg.sender, mintAmount);
1744     emit TokenMinted(totalSupply());
1745   }
1746 
1747   function _mint(address recipient, uint256 quantity) internal {
1748     _safeMint(recipient, quantity);
1749   }
1750 
1751   function OwnerMint(uint256 num) public onlyOwner {
1752     require(totalSupply().add(num) <= MaxToken, "Sold Out");
1753     if(totalSupply().add(num) == MaxToken) { sellingStep = Steps.SoldOut; }    
1754     _mint(msg.sender, num);
1755     emit TokenMinted(totalSupply());
1756   }
1757 
1758   function Airdrop(uint256 num, address recipient) public onlyOwner {
1759     require(totalSupply().add(num) <= MaxToken, "Sold Out");
1760     if(totalSupply().add(num) == MaxToken) { sellingStep = Steps.SoldOut; }    
1761     _mint(recipient, num);
1762     emit TokenMinted(totalSupply());
1763   }
1764 
1765   function AirdropGroup(address[] memory receivers) external onlyOwner {
1766     require(totalSupply().add(receivers.length) <= MaxToken, "Sold Out");
1767     if(totalSupply().add(receivers.length) == MaxToken) { sellingStep = Steps.SoldOut; }    
1768     for (uint256 i = 0; i < receivers.length; i++) {
1769       Airdrop(1, receivers[i]);
1770     }
1771   }
1772 
1773   function setPublicMint() external onlyOwner {
1774     sellingStep = Steps.PublicMint;
1775   }
1776 
1777   function setOGMint() external onlyOwner {
1778     require(sellingStep == Steps.PublicMint, "Public mint is ongoing, please change state first.");
1779     sellingStep = Steps.OGMint;
1780   }
1781 
1782   function setWLMint() external onlyOwner {
1783     require(sellingStep == Steps.OGMint, "OG mint is ongoing, please change state first.");
1784     sellingStep = Steps.WLMint;
1785   }
1786 
1787    function setSale() external onlyOwner {
1788     require(sellingStep == Steps.WLMint, "WL mint is ongoing, please change state first.");
1789     sellingStep = Steps.Sale;
1790   }
1791 
1792   function setBaseURI(string calldata baseURI) external onlyOwner {
1793     _baseUri = baseURI;
1794   }
1795 
1796   function setNotRevealURI(string memory preRevealURI) external onlyOwner {
1797     _notRevealURI = preRevealURI;
1798   }
1799 
1800   function setPricePublicSale(uint256 _newPricePublicSale) public onlyOwner {
1801     PricePublicSale = _newPricePublicSale;
1802   }
1803 
1804   function setPrice(uint256 _newPrice) public onlyOwner {
1805     Price = _newPrice;
1806   }
1807 
1808   
1809   function _leaf(address account) internal pure returns(bytes32) {
1810     return keccak256(abi.encodePacked(account));
1811   }
1812 
1813   //// OG WHITELIST WALLETS
1814   function isOGWhitelisted(address account, bytes32[] calldata proof) internal view returns(bool) {
1815     return _verify(_leaf(account), proof);
1816   }
1817 
1818   function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1819     return MerkleProof.verify(proof, merkleRootOG, leaf);
1820   }
1821 
1822   function changeMerkleRootOG(bytes32 _newMerkleRootOG) external onlyOwner {
1823     merkleRootOG = _newMerkleRootOG;
1824   }
1825 
1826   //NORMAL WHITELIST WALLETS
1827   function isWalletWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
1828     return _verifyWL(_leaf(account), proof);
1829   }
1830 
1831   function _verifyWL(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1832         return MerkleProof.verify(proof, merkleRootNormalWL, leaf);
1833   }
1834 
1835   function changeMerkleRootNormalWL(bytes32 _newmerkleRootNormalWL) external onlyOwner {
1836       merkleRootNormalWL = _newmerkleRootNormalWL;
1837   }
1838 
1839   ////////////////////
1840 
1841   function getTokenByOwner(address _owner) public view returns (uint256[] memory) {
1842     uint256 tokenCount = balanceOf(_owner);
1843     uint256[] memory tokenIds = new uint256[](tokenCount);
1844     for (uint256 i; i < tokenCount; i++) {
1845       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1846     }
1847     return tokenIds;
1848   }
1849 
1850   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1851     return ownershipOf(tokenId);
1852   }
1853 
1854   function numberMinted(address owner) public view returns (uint256) {
1855     return _numberMinted(owner);
1856   }
1857 
1858   function TurnRevealMode() public onlyOwner {
1859     RevealedActive = true;
1860   }
1861 
1862   function withdraw() public payable onlyOwner {
1863     (bool mod, ) = payable(owner()).call{value: address(this).balance}("");
1864     require(mod);
1865   }
1866   
1867 }