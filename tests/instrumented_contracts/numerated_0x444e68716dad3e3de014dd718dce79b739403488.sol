1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 // CAUTION
224 // This version of SafeMath should only be used with Solidity 0.8 or later,
225 // because it relies on the compiler's built in overflow checks.
226 
227 /**
228  * @dev Wrappers over Solidity's arithmetic operations.
229  *
230  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
231  * now has built in overflow checking.
232  */
233 library SafeMath {
234     /**
235      * @dev Returns the addition of two unsigned integers, with an overflow flag.
236      *
237      * _Available since v3.4._
238      */
239     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             uint256 c = a + b;
242             if (c < a) return (false, 0);
243             return (true, c);
244         }
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
249      *
250      * _Available since v3.4._
251      */
252     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b > a) return (false, 0);
255             return (true, a - b);
256         }
257     }
258 
259     /**
260      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
261      *
262      * _Available since v3.4._
263      */
264     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
267             // benefit is lost if 'b' is also tested.
268             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
269             if (a == 0) return (true, 0);
270             uint256 c = a * b;
271             if (c / a != b) return (false, 0);
272             return (true, c);
273         }
274     }
275 
276     /**
277      * @dev Returns the division of two unsigned integers, with a division by zero flag.
278      *
279      * _Available since v3.4._
280      */
281     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             if (b == 0) return (false, 0);
284             return (true, a / b);
285         }
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
290      *
291      * _Available since v3.4._
292      */
293     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b == 0) return (false, 0);
296             return (true, a % b);
297         }
298     }
299 
300     /**
301      * @dev Returns the addition of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `+` operator.
305      *
306      * Requirements:
307      *
308      * - Addition cannot overflow.
309      */
310     function add(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a + b;
312     }
313 
314     /**
315      * @dev Returns the subtraction of two unsigned integers, reverting on
316      * overflow (when the result is negative).
317      *
318      * Counterpart to Solidity's `-` operator.
319      *
320      * Requirements:
321      *
322      * - Subtraction cannot overflow.
323      */
324     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a - b;
326     }
327 
328     /**
329      * @dev Returns the multiplication of two unsigned integers, reverting on
330      * overflow.
331      *
332      * Counterpart to Solidity's `*` operator.
333      *
334      * Requirements:
335      *
336      * - Multiplication cannot overflow.
337      */
338     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
339         return a * b;
340     }
341 
342     /**
343      * @dev Returns the integer division of two unsigned integers, reverting on
344      * division by zero. The result is rounded towards zero.
345      *
346      * Counterpart to Solidity's `/` operator.
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function div(uint256 a, uint256 b) internal pure returns (uint256) {
353         return a / b;
354     }
355 
356     /**
357      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
358      * reverting when dividing by zero.
359      *
360      * Counterpart to Solidity's `%` operator. This function uses a `revert`
361      * opcode (which leaves remaining gas untouched) while Solidity uses an
362      * invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
369         return a % b;
370     }
371 
372     /**
373      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
374      * overflow (when the result is negative).
375      *
376      * CAUTION: This function is deprecated because it requires allocating memory for the error
377      * message unnecessarily. For custom revert reasons use {trySub}.
378      *
379      * Counterpart to Solidity's `-` operator.
380      *
381      * Requirements:
382      *
383      * - Subtraction cannot overflow.
384      */
385     function sub(
386         uint256 a,
387         uint256 b,
388         string memory errorMessage
389     ) internal pure returns (uint256) {
390         unchecked {
391             require(b <= a, errorMessage);
392             return a - b;
393         }
394     }
395 
396     /**
397      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
398      * division by zero. The result is rounded towards zero.
399      *
400      * Counterpart to Solidity's `/` operator. Note: this function uses a
401      * `revert` opcode (which leaves remaining gas untouched) while Solidity
402      * uses an invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function div(
409         uint256 a,
410         uint256 b,
411         string memory errorMessage
412     ) internal pure returns (uint256) {
413         unchecked {
414             require(b > 0, errorMessage);
415             return a / b;
416         }
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
421      * reverting with custom message when dividing by zero.
422      *
423      * CAUTION: This function is deprecated because it requires allocating memory for the error
424      * message unnecessarily. For custom revert reasons use {tryMod}.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function mod(
435         uint256 a,
436         uint256 b,
437         string memory errorMessage
438     ) internal pure returns (uint256) {
439         unchecked {
440             require(b > 0, errorMessage);
441             return a % b;
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/utils/Strings.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev String operations.
455  */
456 library Strings {
457     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
458     uint8 private constant _ADDRESS_LENGTH = 20;
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
462      */
463     function toString(uint256 value) internal pure returns (string memory) {
464         // Inspired by OraclizeAPI's implementation - MIT licence
465         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
466 
467         if (value == 0) {
468             return "0";
469         }
470         uint256 temp = value;
471         uint256 digits;
472         while (temp != 0) {
473             digits++;
474             temp /= 10;
475         }
476         bytes memory buffer = new bytes(digits);
477         while (value != 0) {
478             digits -= 1;
479             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
480             value /= 10;
481         }
482         return string(buffer);
483     }
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
487      */
488     function toHexString(uint256 value) internal pure returns (string memory) {
489         if (value == 0) {
490             return "0x00";
491         }
492         uint256 temp = value;
493         uint256 length = 0;
494         while (temp != 0) {
495             length++;
496             temp >>= 8;
497         }
498         return toHexString(value, length);
499     }
500 
501     /**
502      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
503      */
504     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
505         bytes memory buffer = new bytes(2 * length + 2);
506         buffer[0] = "0";
507         buffer[1] = "x";
508         for (uint256 i = 2 * length + 1; i > 1; --i) {
509             buffer[i] = _HEX_SYMBOLS[value & 0xf];
510             value >>= 4;
511         }
512         require(value == 0, "Strings: hex length insufficient");
513         return string(buffer);
514     }
515 
516     /**
517      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
518      */
519     function toHexString(address addr) internal pure returns (string memory) {
520         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
521     }
522 }
523 
524 // File: @openzeppelin/contracts/utils/Context.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Provides information about the current execution context, including the
533  * sender of the transaction and its data. While these are generally available
534  * via msg.sender and msg.data, they should not be accessed in such a direct
535  * manner, since when dealing with meta-transactions the account sending and
536  * paying for execution may not be the actual sender (as far as an application
537  * is concerned).
538  *
539  * This contract is only required for intermediate, library-like contracts.
540  */
541 abstract contract Context {
542     function _msgSender() internal view virtual returns (address) {
543         return msg.sender;
544     }
545 
546     function _msgData() internal view virtual returns (bytes calldata) {
547         return msg.data;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/access/Ownable.sol
552 
553 
554 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Contract module which provides a basic access control mechanism, where
561  * there is an account (an owner) that can be granted exclusive access to
562  * specific functions.
563  *
564  * By default, the owner account will be the one that deploys the contract. This
565  * can later be changed with {transferOwnership}.
566  *
567  * This module is used through inheritance. It will make available the modifier
568  * `onlyOwner`, which can be applied to your functions to restrict their use to
569  * the owner.
570  */
571 abstract contract Ownable is Context {
572     address private _owner;
573 
574     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
575 
576     /**
577      * @dev Initializes the contract setting the deployer as the initial owner.
578      */
579     constructor() {
580         _transferOwnership(_msgSender());
581     }
582 
583     /**
584      * @dev Throws if called by any account other than the owner.
585      */
586     modifier onlyOwner() {
587         _checkOwner();
588         _;
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view virtual returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if the sender is not the owner.
600      */
601     function _checkOwner() internal view virtual {
602         require(owner() == _msgSender(), "Ownable: caller is not the owner");
603     }
604 
605     /**
606      * @dev Leaves the contract without owner. It will not be possible to call
607      * `onlyOwner` functions anymore. Can only be called by the current owner.
608      *
609      * NOTE: Renouncing ownership will leave the contract without an owner,
610      * thereby removing any functionality that is only available to the owner.
611      */
612     function renounceOwnership() public virtual onlyOwner {
613         _transferOwnership(address(0));
614     }
615 
616     /**
617      * @dev Transfers ownership of the contract to a new account (`newOwner`).
618      * Can only be called by the current owner.
619      */
620     function transferOwnership(address newOwner) public virtual onlyOwner {
621         require(newOwner != address(0), "Ownable: new owner is the zero address");
622         _transferOwnership(newOwner);
623     }
624 
625     /**
626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
627      * Internal function without access restriction.
628      */
629     function _transferOwnership(address newOwner) internal virtual {
630         address oldOwner = _owner;
631         _owner = newOwner;
632         emit OwnershipTransferred(oldOwner, newOwner);
633     }
634 }
635 
636 // File: @openzeppelin/contracts/utils/Address.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
640 
641 pragma solidity ^0.8.1;
642 
643 /**
644  * @dev Collection of functions related to the address type
645  */
646 library Address {
647     /**
648      * @dev Returns true if `account` is a contract.
649      *
650      * [IMPORTANT]
651      * ====
652      * It is unsafe to assume that an address for which this function returns
653      * false is an externally-owned account (EOA) and not a contract.
654      *
655      * Among others, `isContract` will return false for the following
656      * types of addresses:
657      *
658      *  - an externally-owned account
659      *  - a contract in construction
660      *  - an address where a contract will be created
661      *  - an address where a contract lived, but was destroyed
662      * ====
663      *
664      * [IMPORTANT]
665      * ====
666      * You shouldn't rely on `isContract` to protect against flash loan attacks!
667      *
668      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
669      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
670      * constructor.
671      * ====
672      */
673     function isContract(address account) internal view returns (bool) {
674         // This method relies on extcodesize/address.code.length, which returns 0
675         // for contracts in construction, since the code is only stored at the end
676         // of the constructor execution.
677 
678         return account.code.length > 0;
679     }
680 
681     /**
682      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
683      * `recipient`, forwarding all available gas and reverting on errors.
684      *
685      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
686      * of certain opcodes, possibly making contracts go over the 2300 gas limit
687      * imposed by `transfer`, making them unable to receive funds via
688      * `transfer`. {sendValue} removes this limitation.
689      *
690      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
691      *
692      * IMPORTANT: because control is transferred to `recipient`, care must be
693      * taken to not create reentrancy vulnerabilities. Consider using
694      * {ReentrancyGuard} or the
695      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
696      */
697     function sendValue(address payable recipient, uint256 amount) internal {
698         require(address(this).balance >= amount, "Address: insufficient balance");
699 
700         (bool success, ) = recipient.call{value: amount}("");
701         require(success, "Address: unable to send value, recipient may have reverted");
702     }
703 
704     /**
705      * @dev Performs a Solidity function call using a low level `call`. A
706      * plain `call` is an unsafe replacement for a function call: use this
707      * function instead.
708      *
709      * If `target` reverts with a revert reason, it is bubbled up by this
710      * function (like regular Solidity function calls).
711      *
712      * Returns the raw returned data. To convert to the expected return value,
713      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
714      *
715      * Requirements:
716      *
717      * - `target` must be a contract.
718      * - calling `target` with `data` must not revert.
719      *
720      * _Available since v3.1._
721      */
722     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
723         return functionCall(target, data, "Address: low-level call failed");
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
728      * `errorMessage` as a fallback revert reason when `target` reverts.
729      *
730      * _Available since v3.1._
731      */
732     function functionCall(
733         address target,
734         bytes memory data,
735         string memory errorMessage
736     ) internal returns (bytes memory) {
737         return functionCallWithValue(target, data, 0, errorMessage);
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
742      * but also transferring `value` wei to `target`.
743      *
744      * Requirements:
745      *
746      * - the calling contract must have an ETH balance of at least `value`.
747      * - the called Solidity function must be `payable`.
748      *
749      * _Available since v3.1._
750      */
751     function functionCallWithValue(
752         address target,
753         bytes memory data,
754         uint256 value
755     ) internal returns (bytes memory) {
756         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
757     }
758 
759     /**
760      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
761      * with `errorMessage` as a fallback revert reason when `target` reverts.
762      *
763      * _Available since v3.1._
764      */
765     function functionCallWithValue(
766         address target,
767         bytes memory data,
768         uint256 value,
769         string memory errorMessage
770     ) internal returns (bytes memory) {
771         require(address(this).balance >= value, "Address: insufficient balance for call");
772         require(isContract(target), "Address: call to non-contract");
773 
774         (bool success, bytes memory returndata) = target.call{value: value}(data);
775         return verifyCallResult(success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but performing a static call.
781      *
782      * _Available since v3.3._
783      */
784     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
785         return functionStaticCall(target, data, "Address: low-level static call failed");
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
790      * but performing a static call.
791      *
792      * _Available since v3.3._
793      */
794     function functionStaticCall(
795         address target,
796         bytes memory data,
797         string memory errorMessage
798     ) internal view returns (bytes memory) {
799         require(isContract(target), "Address: static call to non-contract");
800 
801         (bool success, bytes memory returndata) = target.staticcall(data);
802         return verifyCallResult(success, returndata, errorMessage);
803     }
804 
805     /**
806      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
807      * but performing a delegate call.
808      *
809      * _Available since v3.4._
810      */
811     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
812         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
813     }
814 
815     /**
816      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
817      * but performing a delegate call.
818      *
819      * _Available since v3.4._
820      */
821     function functionDelegateCall(
822         address target,
823         bytes memory data,
824         string memory errorMessage
825     ) internal returns (bytes memory) {
826         require(isContract(target), "Address: delegate call to non-contract");
827 
828         (bool success, bytes memory returndata) = target.delegatecall(data);
829         return verifyCallResult(success, returndata, errorMessage);
830     }
831 
832     /**
833      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
834      * revert reason using the provided one.
835      *
836      * _Available since v4.3._
837      */
838     function verifyCallResult(
839         bool success,
840         bytes memory returndata,
841         string memory errorMessage
842     ) internal pure returns (bytes memory) {
843         if (success) {
844             return returndata;
845         } else {
846             // Look for revert reason and bubble it up if present
847             if (returndata.length > 0) {
848                 // The easiest way to bubble the revert reason is using memory via assembly
849                 /// @solidity memory-safe-assembly
850                 assembly {
851                     let returndata_size := mload(returndata)
852                     revert(add(32, returndata), returndata_size)
853                 }
854             } else {
855                 revert(errorMessage);
856             }
857         }
858     }
859 }
860 
861 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
862 
863 
864 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 /**
869  * @title ERC721 token receiver interface
870  * @dev Interface for any contract that wants to support safeTransfers
871  * from ERC721 asset contracts.
872  */
873 interface IERC721Receiver {
874     /**
875      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
876      * by `operator` from `from`, this function is called.
877      *
878      * It must return its Solidity selector to confirm the token transfer.
879      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
880      *
881      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
882      */
883     function onERC721Received(
884         address operator,
885         address from,
886         uint256 tokenId,
887         bytes calldata data
888     ) external returns (bytes4);
889 }
890 
891 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
892 
893 
894 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
895 
896 pragma solidity ^0.8.0;
897 
898 /**
899  * @dev Interface of the ERC165 standard, as defined in the
900  * https://eips.ethereum.org/EIPS/eip-165[EIP].
901  *
902  * Implementers can declare support of contract interfaces, which can then be
903  * queried by others ({ERC165Checker}).
904  *
905  * For an implementation, see {ERC165}.
906  */
907 interface IERC165 {
908     /**
909      * @dev Returns true if this contract implements the interface defined by
910      * `interfaceId`. See the corresponding
911      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
912      * to learn more about how these ids are created.
913      *
914      * This function call must use less than 30 000 gas.
915      */
916     function supportsInterface(bytes4 interfaceId) external view returns (bool);
917 }
918 
919 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
920 
921 
922 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
923 
924 pragma solidity ^0.8.0;
925 
926 
927 /**
928  * @dev Implementation of the {IERC165} interface.
929  *
930  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
931  * for the additional interface id that will be supported. For example:
932  *
933  * ```solidity
934  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
935  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
936  * }
937  * ```
938  *
939  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
940  */
941 abstract contract ERC165 is IERC165 {
942     /**
943      * @dev See {IERC165-supportsInterface}.
944      */
945     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
946         return interfaceId == type(IERC165).interfaceId;
947     }
948 }
949 
950 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
951 
952 
953 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 
958 /**
959  * @dev Required interface of an ERC721 compliant contract.
960  */
961 interface IERC721 is IERC165 {
962     /**
963      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
964      */
965     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
966 
967     /**
968      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
969      */
970     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
971 
972     /**
973      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
974      */
975     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
976 
977     /**
978      * @dev Returns the number of tokens in ``owner``'s account.
979      */
980     function balanceOf(address owner) external view returns (uint256 balance);
981 
982     /**
983      * @dev Returns the owner of the `tokenId` token.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function ownerOf(uint256 tokenId) external view returns (address owner);
990 
991     /**
992      * @dev Safely transfers `tokenId` token from `from` to `to`.
993      *
994      * Requirements:
995      *
996      * - `from` cannot be the zero address.
997      * - `to` cannot be the zero address.
998      * - `tokenId` token must exist and be owned by `from`.
999      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1000      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId,
1008         bytes calldata data
1009     ) external;
1010 
1011     /**
1012      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1013      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1014      *
1015      * Requirements:
1016      *
1017      * - `from` cannot be the zero address.
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must exist and be owned by `from`.
1020      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1021      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) external;
1030 
1031     /**
1032      * @dev Transfers `tokenId` token from `from` to `to`.
1033      *
1034      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1035      *
1036      * Requirements:
1037      *
1038      * - `from` cannot be the zero address.
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function transferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) external;
1050 
1051     /**
1052      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1053      * The approval is cleared when the token is transferred.
1054      *
1055      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1056      *
1057      * Requirements:
1058      *
1059      * - The caller must own the token or be an approved operator.
1060      * - `tokenId` must exist.
1061      *
1062      * Emits an {Approval} event.
1063      */
1064     function approve(address to, uint256 tokenId) external;
1065 
1066     /**
1067      * @dev Approve or remove `operator` as an operator for the caller.
1068      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1069      *
1070      * Requirements:
1071      *
1072      * - The `operator` cannot be the caller.
1073      *
1074      * Emits an {ApprovalForAll} event.
1075      */
1076     function setApprovalForAll(address operator, bool _approved) external;
1077 
1078     /**
1079      * @dev Returns the account approved for `tokenId` token.
1080      *
1081      * Requirements:
1082      *
1083      * - `tokenId` must exist.
1084      */
1085     function getApproved(uint256 tokenId) external view returns (address operator);
1086 
1087     /**
1088      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1089      *
1090      * See {setApprovalForAll}
1091      */
1092     function isApprovedForAll(address owner, address operator) external view returns (bool);
1093 }
1094 
1095 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1096 
1097 
1098 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 
1103 /**
1104  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1105  * @dev See https://eips.ethereum.org/EIPS/eip-721
1106  */
1107 interface IERC721Metadata is IERC721 {
1108     /**
1109      * @dev Returns the token collection name.
1110      */
1111     function name() external view returns (string memory);
1112 
1113     /**
1114      * @dev Returns the token collection symbol.
1115      */
1116     function symbol() external view returns (string memory);
1117 
1118     /**
1119      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1120      */
1121     function tokenURI(uint256 tokenId) external view returns (string memory);
1122 }
1123 
1124 // File: ERC721A.sol
1125 
1126 
1127 // Creator: Chiru Labs
1128 
1129 pragma solidity ^0.8.4;
1130 
1131 
1132 
1133 
1134 
1135 
1136 
1137 
1138 error ApprovalCallerNotOwnerNorApproved();
1139 error ApprovalQueryForNonexistentToken();
1140 error ApproveToCaller();
1141 error ApprovalToCurrentOwner();
1142 error BalanceQueryForZeroAddress();
1143 error MintToZeroAddress();
1144 error MintZeroQuantity();
1145 error OwnerQueryForNonexistentToken();
1146 error TransferCallerNotOwnerNorApproved();
1147 error TransferFromIncorrectOwner();
1148 error TransferToNonERC721ReceiverImplementer();
1149 error TransferToZeroAddress();
1150 error URIQueryForNonexistentToken();
1151 
1152 /**
1153  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1154  * the Metadata extension. Built to optimize for lower gas during batch mints.
1155  *
1156  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1157  *
1158  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1159  *
1160  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1161  */
1162 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1163     using Address for address;
1164     using Strings for uint256;
1165 
1166     // Compiler will pack this into a single 256bit word.
1167     struct TokenOwnership {
1168         // The address of the owner.
1169         address addr;
1170         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1171         uint64 startTimestamp;
1172         // Whether the token has been burned.
1173         bool burned;
1174     }
1175 
1176     // Compiler will pack this into a single 256bit word.
1177     struct AddressData {
1178         // Realistically, 2**64-1 is more than enough.
1179         uint64 balance;
1180         // Keeps track of mint count with minimal overhead for tokenomics.
1181         uint64 numberMinted;
1182         // Keeps track of burn count with minimal overhead for tokenomics.
1183         uint64 numberBurned;
1184         // For miscellaneous variable(s) pertaining to the address
1185         // (e.g. number of whitelist mint slots used).
1186         // If there are multiple variables, please pack them into a uint64.
1187         uint64 aux;
1188     }
1189 
1190     // The tokenId of the next token to be minted.
1191     uint256 internal _currentIndex;
1192 
1193     // The number of tokens burned.
1194     uint256 internal _burnCounter;
1195 
1196     // Token name
1197     string private _name;
1198 
1199     // Token symbol
1200     string private _symbol;
1201 
1202     // Mapping from token ID to ownership details
1203     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1204     mapping(uint256 => TokenOwnership) internal _ownerships;
1205 
1206     // Mapping owner address to address data
1207     mapping(address => AddressData) private _addressData;
1208 
1209     // Mapping from token ID to approved address
1210     mapping(uint256 => address) private _tokenApprovals;
1211 
1212     // Mapping from owner to operator approvals
1213     mapping(address => mapping(address => bool)) private _operatorApprovals;
1214 
1215     constructor(string memory name_, string memory symbol_) {
1216         _name = name_;
1217         _symbol = symbol_;
1218         _currentIndex = _startTokenId();
1219     }
1220 
1221     /**
1222      * To change the starting tokenId, please override this function.
1223      */
1224     function _startTokenId() internal view virtual returns (uint256) {
1225         return 0;
1226     }
1227 
1228     /**
1229      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1230      */
1231     function totalSupply() public view returns (uint256) {
1232         // Counter underflow is impossible as _burnCounter cannot be incremented
1233         // more than _currentIndex - _startTokenId() times
1234         unchecked {
1235             return _currentIndex - _burnCounter - _startTokenId();
1236         }
1237     }
1238 
1239     /**
1240      * Returns the total amount of tokens minted in the contract.
1241      */
1242     function _totalMinted() internal view returns (uint256) {
1243         // Counter underflow is impossible as _currentIndex does not decrement,
1244         // and it is initialized to _startTokenId()
1245         unchecked {
1246             return _currentIndex - _startTokenId();
1247         }
1248     }
1249 
1250     /**
1251      * @dev See {IERC165-supportsInterface}.
1252      */
1253     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1254         return
1255             interfaceId == type(IERC721).interfaceId ||
1256             interfaceId == type(IERC721Metadata).interfaceId ||
1257             super.supportsInterface(interfaceId);
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-balanceOf}.
1262      */
1263     function balanceOf(address owner) public view override returns (uint256) {
1264         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1265         return uint256(_addressData[owner].balance);
1266     }
1267 
1268     /**
1269      * Returns the number of tokens minted by `owner`.
1270      */
1271     function _numberMinted(address owner) internal view returns (uint256) {
1272         return uint256(_addressData[owner].numberMinted);
1273     }
1274 
1275     /**
1276      * Returns the number of tokens burned by or on behalf of `owner`.
1277      */
1278     function _numberBurned(address owner) internal view returns (uint256) {
1279         return uint256(_addressData[owner].numberBurned);
1280     }
1281 
1282     /**
1283      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1284      */
1285     function _getAux(address owner) internal view returns (uint64) {
1286         return _addressData[owner].aux;
1287     }
1288 
1289     /**
1290      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1291      * If there are multiple variables, please pack them into a uint64.
1292      */
1293     function _setAux(address owner, uint64 aux) internal {
1294         _addressData[owner].aux = aux;
1295     }
1296 
1297     /**
1298      * Gas spent here starts off proportional to the maximum mint batch size.
1299      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1300      */
1301     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1302         uint256 curr = tokenId;
1303 
1304         unchecked {
1305             if (_startTokenId() <= curr && curr < _currentIndex) {
1306                 TokenOwnership memory ownership = _ownerships[curr];
1307                 if (!ownership.burned) {
1308                     if (ownership.addr != address(0)) {
1309                         return ownership;
1310                     }
1311                     // Invariant:
1312                     // There will always be an ownership that has an address and is not burned
1313                     // before an ownership that does not have an address and is not burned.
1314                     // Hence, curr will not underflow.
1315                     while (true) {
1316                         curr--;
1317                         ownership = _ownerships[curr];
1318                         if (ownership.addr != address(0)) {
1319                             return ownership;
1320                         }
1321                     }
1322                 }
1323             }
1324         }
1325         revert OwnerQueryForNonexistentToken();
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-ownerOf}.
1330      */
1331     function ownerOf(uint256 tokenId) public view override returns (address) {
1332         return _ownershipOf(tokenId).addr;
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Metadata-name}.
1337      */
1338     function name() public view virtual override returns (string memory) {
1339         return _name;
1340     }
1341 
1342     /**
1343      * @dev See {IERC721Metadata-symbol}.
1344      */
1345     function symbol() public view virtual override returns (string memory) {
1346         return _symbol;
1347     }
1348 
1349     /**
1350      * @dev See {IERC721Metadata-tokenURI}.
1351      */
1352     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1353         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1354 
1355         string memory baseURI = _baseURI();
1356         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1357     }
1358 
1359     /**
1360      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1361      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1362      * by default, can be overriden in child contracts.
1363      */
1364     function _baseURI() internal view virtual returns (string memory) {
1365         return '';
1366     }
1367 
1368     /**
1369      * @dev See {IERC721-approve}.
1370      */
1371     function approve(address to, uint256 tokenId) public override {
1372         address owner = ERC721A.ownerOf(tokenId);
1373         if (to == owner) revert ApprovalToCurrentOwner();
1374 
1375         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1376             revert ApprovalCallerNotOwnerNorApproved();
1377         }
1378 
1379         _approve(to, tokenId, owner);
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-getApproved}.
1384      */
1385     function getApproved(uint256 tokenId) public view override returns (address) {
1386         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1387 
1388         return _tokenApprovals[tokenId];
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-setApprovalForAll}.
1393      */
1394     function setApprovalForAll(address operator, bool approved) public virtual override {
1395         if (operator == _msgSender()) revert ApproveToCaller();
1396 
1397         _operatorApprovals[_msgSender()][operator] = approved;
1398         emit ApprovalForAll(_msgSender(), operator, approved);
1399     }
1400 
1401     /**
1402      * @dev See {IERC721-isApprovedForAll}.
1403      */
1404     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1405         return _operatorApprovals[owner][operator];
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-transferFrom}.
1410      */
1411     function transferFrom(
1412         address from,
1413         address to,
1414         uint256 tokenId
1415     ) public virtual override {
1416         _transfer(from, to, tokenId);
1417     }
1418 
1419     /**
1420      * @dev See {IERC721-safeTransferFrom}.
1421      */
1422     function safeTransferFrom(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) public virtual override {
1427         safeTransferFrom(from, to, tokenId, '');
1428     }
1429 
1430     /**
1431      * @dev See {IERC721-safeTransferFrom}.
1432      */
1433     function safeTransferFrom(
1434         address from,
1435         address to,
1436         uint256 tokenId,
1437         bytes memory _data
1438     ) public virtual override {
1439         _transfer(from, to, tokenId);
1440         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1441             revert TransferToNonERC721ReceiverImplementer();
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns whether `tokenId` exists.
1447      *
1448      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1449      *
1450      * Tokens start existing when they are minted (`_mint`),
1451      */
1452     function _exists(uint256 tokenId) internal view returns (bool) {
1453         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1454     }
1455 
1456     /**
1457      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1458      */
1459     function _safeMint(address to, uint256 quantity) internal {
1460         _safeMint(to, quantity, '');
1461     }
1462 
1463     /**
1464      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1465      *
1466      * Requirements:
1467      *
1468      * - If `to` refers to a smart contract, it must implement 
1469      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1470      * - `quantity` must be greater than 0.
1471      *
1472      * Emits a {Transfer} event.
1473      */
1474     function _safeMint(
1475         address to,
1476         uint256 quantity,
1477         bytes memory _data
1478     ) internal {
1479         uint256 startTokenId = _currentIndex;
1480         if (to == address(0)) revert MintToZeroAddress();
1481         if (quantity == 0) revert MintZeroQuantity();
1482 
1483         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1484 
1485         // Overflows are incredibly unrealistic.
1486         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1487         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1488         unchecked {
1489             _addressData[to].balance += uint64(quantity);
1490             _addressData[to].numberMinted += uint64(quantity);
1491 
1492             _ownerships[startTokenId].addr = to;
1493             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1494 
1495             uint256 updatedIndex = startTokenId;
1496             uint256 end = updatedIndex + quantity;
1497 
1498             if (to.isContract()) {
1499                 do {
1500                     emit Transfer(address(0), to, updatedIndex);
1501                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1502                         revert TransferToNonERC721ReceiverImplementer();
1503                     }
1504                 } while (updatedIndex != end);
1505                 // Reentrancy protection
1506                 if (_currentIndex != startTokenId) revert();
1507             } else {
1508                 do {
1509                     emit Transfer(address(0), to, updatedIndex++);
1510                 } while (updatedIndex != end);
1511             }
1512             _currentIndex = updatedIndex;
1513         }
1514         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1515     }
1516 
1517     /**
1518      * @dev Mints `quantity` tokens and transfers them to `to`.
1519      *
1520      * Requirements:
1521      *
1522      * - `to` cannot be the zero address.
1523      * - `quantity` must be greater than 0.
1524      *
1525      * Emits a {Transfer} event.
1526      */
1527     function _mint(address to, uint256 quantity) internal {
1528         uint256 startTokenId = _currentIndex;
1529         if (to == address(0)) revert MintToZeroAddress();
1530         if (quantity == 0) revert MintZeroQuantity();
1531 
1532         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1533 
1534         // Overflows are incredibly unrealistic.
1535         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1536         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1537         unchecked {
1538             _addressData[to].balance += uint64(quantity);
1539             _addressData[to].numberMinted += uint64(quantity);
1540 
1541             _ownerships[startTokenId].addr = to;
1542             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1543 
1544             uint256 updatedIndex = startTokenId;
1545             uint256 end = updatedIndex + quantity;
1546 
1547             do {
1548                 emit Transfer(address(0), to, updatedIndex++);
1549             } while (updatedIndex != end);
1550 
1551             _currentIndex = updatedIndex;
1552         }
1553         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1554     }
1555 
1556     /**
1557      * @dev Transfers `tokenId` from `from` to `to`.
1558      *
1559      * Requirements:
1560      *
1561      * - `to` cannot be the zero address.
1562      * - `tokenId` token must be owned by `from`.
1563      *
1564      * Emits a {Transfer} event.
1565      */
1566     function _transfer(
1567         address from,
1568         address to,
1569         uint256 tokenId
1570     ) private {
1571         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1572 
1573         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1574 
1575         bool isApprovedOrOwner = (_msgSender() == from ||
1576             isApprovedForAll(from, _msgSender()) ||
1577             getApproved(tokenId) == _msgSender());
1578 
1579         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1580         if (to == address(0)) revert TransferToZeroAddress();
1581 
1582         _beforeTokenTransfers(from, to, tokenId, 1);
1583 
1584         // Clear approvals from the previous owner
1585         _approve(address(0), tokenId, from);
1586 
1587         // Underflow of the sender's balance is impossible because we check for
1588         // ownership above and the recipient's balance can't realistically overflow.
1589         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1590         unchecked {
1591             _addressData[from].balance -= 1;
1592             _addressData[to].balance += 1;
1593 
1594             TokenOwnership storage currSlot = _ownerships[tokenId];
1595             currSlot.addr = to;
1596             currSlot.startTimestamp = uint64(block.timestamp);
1597 
1598             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1599             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1600             uint256 nextTokenId = tokenId + 1;
1601             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1602             if (nextSlot.addr == address(0)) {
1603                 // This will suffice for checking _exists(nextTokenId),
1604                 // as a burned slot cannot contain the zero address.
1605                 if (nextTokenId != _currentIndex) {
1606                     nextSlot.addr = from;
1607                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1608                 }
1609             }
1610         }
1611 
1612         emit Transfer(from, to, tokenId);
1613         _afterTokenTransfers(from, to, tokenId, 1);
1614     }
1615 
1616     /**
1617      * @dev Equivalent to `_burn(tokenId, false)`.
1618      */
1619     function _burn(uint256 tokenId) internal virtual {
1620         _burn(tokenId, false);
1621     }
1622 
1623     /**
1624      * @dev Destroys `tokenId`.
1625      * The approval is cleared when the token is burned.
1626      *
1627      * Requirements:
1628      *
1629      * - `tokenId` must exist.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1634         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1635 
1636         address from = prevOwnership.addr;
1637 
1638         if (approvalCheck) {
1639             bool isApprovedOrOwner = (_msgSender() == from ||
1640                 isApprovedForAll(from, _msgSender()) ||
1641                 getApproved(tokenId) == _msgSender());
1642 
1643             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1644         }
1645 
1646         _beforeTokenTransfers(from, address(0), tokenId, 1);
1647 
1648         // Clear approvals from the previous owner
1649         _approve(address(0), tokenId, from);
1650 
1651         // Underflow of the sender's balance is impossible because we check for
1652         // ownership above and the recipient's balance can't realistically overflow.
1653         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1654         unchecked {
1655             AddressData storage addressData = _addressData[from];
1656             addressData.balance -= 1;
1657             addressData.numberBurned += 1;
1658 
1659             // Keep track of who burned the token, and the timestamp of burning.
1660             TokenOwnership storage currSlot = _ownerships[tokenId];
1661             currSlot.addr = from;
1662             currSlot.startTimestamp = uint64(block.timestamp);
1663             currSlot.burned = true;
1664 
1665             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1666             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1667             uint256 nextTokenId = tokenId + 1;
1668             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1669             if (nextSlot.addr == address(0)) {
1670                 // This will suffice for checking _exists(nextTokenId),
1671                 // as a burned slot cannot contain the zero address.
1672                 if (nextTokenId != _currentIndex) {
1673                     nextSlot.addr = from;
1674                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1675                 }
1676             }
1677         }
1678 
1679         emit Transfer(from, address(0), tokenId);
1680         _afterTokenTransfers(from, address(0), tokenId, 1);
1681 
1682         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1683         unchecked {
1684             _burnCounter++;
1685         }
1686     }
1687 
1688     /**
1689      * @dev Approve `to` to operate on `tokenId`
1690      *
1691      * Emits a {Approval} event.
1692      */
1693     function _approve(
1694         address to,
1695         uint256 tokenId,
1696         address owner
1697     ) private {
1698         _tokenApprovals[tokenId] = to;
1699         emit Approval(owner, to, tokenId);
1700     }
1701 
1702     /**
1703      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1704      *
1705      * @param from address representing the previous owner of the given token ID
1706      * @param to target address that will receive the tokens
1707      * @param tokenId uint256 ID of the token to be transferred
1708      * @param _data bytes optional data to send along with the call
1709      * @return bool whether the call correctly returned the expected magic value
1710      */
1711     function _checkContractOnERC721Received(
1712         address from,
1713         address to,
1714         uint256 tokenId,
1715         bytes memory _data
1716     ) private returns (bool) {
1717         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1718             return retval == IERC721Receiver(to).onERC721Received.selector;
1719         } catch (bytes memory reason) {
1720             if (reason.length == 0) {
1721                 revert TransferToNonERC721ReceiverImplementer();
1722             } else {
1723                 assembly {
1724                     revert(add(32, reason), mload(reason))
1725                 }
1726             }
1727         }
1728     }
1729 
1730     /**
1731      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1732      * And also called before burning one token.
1733      *
1734      * startTokenId - the first token id to be transferred
1735      * quantity - the amount to be transferred
1736      *
1737      * Calling conditions:
1738      *
1739      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1740      * transferred to `to`.
1741      * - When `from` is zero, `tokenId` will be minted for `to`.
1742      * - When `to` is zero, `tokenId` will be burned by `from`.
1743      * - `from` and `to` are never both zero.
1744      */
1745     function _beforeTokenTransfers(
1746         address from,
1747         address to,
1748         uint256 startTokenId,
1749         uint256 quantity
1750     ) internal virtual {}
1751 
1752     /**
1753      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1754      * minting.
1755      * And also called after one token has been burned.
1756      *
1757      * startTokenId - the first token id to be transferred
1758      * quantity - the amount to be transferred
1759      *
1760      * Calling conditions:
1761      *
1762      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1763      * transferred to `to`.
1764      * - When `from` is zero, `tokenId` has been minted for `to`.
1765      * - When `to` is zero, `tokenId` has been burned by `from`.
1766      * - `from` and `to` are never both zero.
1767      */
1768     function _afterTokenTransfers(
1769         address from,
1770         address to,
1771         uint256 startTokenId,
1772         uint256 quantity
1773     ) internal virtual {}
1774 }
1775 // File: bagholders.sol
1776 
1777 
1778 
1779 pragma solidity ^0.8.10;
1780 
1781 
1782 
1783 
1784 
1785 
1786 contract Bagholders is ERC721A, Ownable {
1787     using Strings for uint256;
1788 
1789     uint256 public constant MAX_TOKENS = 7777;
1790 
1791     uint256 public maxWhitelistMint = 1;
1792     uint256 public maxPublicMint = 1;
1793     bool public publicSale = false;
1794     bool public whitelistSale = false;
1795     bool public reservelistSale = false;
1796 
1797 
1798     mapping(address => uint256) public _whitelistClaimed;
1799     mapping(address => uint256) public _reserveClaimed;
1800     mapping(address => uint256) public _publicClaimed;
1801 
1802     string public baseURI = "";
1803     bytes32 public merkleRoot = 0xb067a20ba5ddd291ea422f36db1f2bf093d80e72c2c0f9f11320e8712a6a4f6e;
1804 
1805     constructor() ERC721A("BagHolders", "BAGS") {
1806     }
1807 
1808     function toggleWhitelistSale() external onlyOwner {
1809         whitelistSale = !whitelistSale;
1810     }
1811 
1812     function airdropTheBags() external onlyOwner {
1813         _safeMint(0x85C0b44D3B9a49b09c3B925AF5c935043e66dFbF, 2);
1814         _safeMint(0xB110f4Cf6660e3003c421254Bf1568cA79598a5e, 2);
1815         _safeMint(0x39cb13625945bf0eb05579Ad6c79f748DaCD9b20, 2);
1816         _safeMint(0x740F471701D09e268EFC991f8332B172093D74DD, 2);
1817         _safeMint(0xb522a6619D74546CFFe9fCBEC27dA5D2C5D18066, 2);
1818         _safeMint(0xC2b142beb125579E98c16Ced36629A2d1C3D5841, 2);
1819         _safeMint(0x26Be72cBBf5746F14d731FD4feBF294Cae376f59, 2);
1820         _safeMint(0x1342BD2AB6065379502De00Afd81D4A987318A5E, 2);
1821         _safeMint(0x635bf1DfE7301a560e6fb5fEF4bB9902B5966Ed3, 2);
1822         _safeMint(0x0E16f4A678F7fAcDcf58C9ADf947E8e48845e575, 2);
1823         _safeMint(0x55B0d5Ef132c1A46e3D18409649Ea18351CFEf9A, 2);
1824         _safeMint(0x610243745476e23EF7c17f23168F3E5e774390E2, 2);
1825         _safeMint(0x9A430a8bE98dA5aC1A2FB6F8F53e8fE794de611e, 2);
1826         _safeMint(0xE15Bb22Ce00eA25Aa62BEa202AC1008932F4d785, 2);
1827         _safeMint(0xa22Aae6a5ecdE5CC8abe49E32165366C0D70Ad63, 2);
1828         _safeMint(0xf6f435a13A38149eF954bb391F16d8010380DD4a, 2);
1829         _safeMint(0xB7C5121a82493deCe1Cd4143e0571fcC49AFbFfD, 2);
1830         _safeMint(0x5d1928B9062e34De640b1117efCC81B90B452693, 2);
1831         _safeMint(0xF95C508FA8686279294Ea69f2DeaE18C0bc3C99C, 2);
1832         _safeMint(0x175e89eEb246F66cE664df16F5f046610b867513, 2);
1833         _safeMint(0xEca78934FdB00a2Dadd9a29CF3d45BeF5B3C8E9C, 2);
1834         _safeMint(0xa66489AdA4f1b94EAceFe5FC27F3674DEb407Fbd, 2);
1835         _safeMint(0x05F885113100771A1bDB5C22E7DaDB3acB149E3F, 2);
1836         _safeMint(0x97eec19136E7AB1Cb0a0F4A4C47eE2d55a993C40, 2);
1837         _safeMint(0xBB08a962380b9A1E49f20D6C3bdC81075914b0cD, 2);
1838         _safeMint(0xDc64b93Ccd63D2354a32BbCd2D460735D341415d, 2);
1839         _safeMint(0x551d196803c99dC4E2bf68cB9B61d4C597749Db0, 2);
1840         _safeMint(0xDCa699c2b0E88f2f06aEbe96172fa09D463A4D27, 2);
1841         _safeMint(0x14C30C5d33961C2F4d2cD2d1AB584BbBFF0A635E, 2);
1842         _safeMint(0x3e357db18182f7a597cf49d0C40B692706fa7b2f, 2);
1843         _safeMint(0xD91473629D8B46a8eB44eb6349a568a7eA7a176f, 2);
1844         _safeMint(0xaA898615D42Efd369E151448a992aF897E32F566, 2);
1845         _safeMint(0xE09Cf2aC74009200Bbff7455fF3F69DB5fB49a10, 2);
1846         _safeMint(0x9cCBDd887A92D13C04f6C846A2cF514871474cEb, 2);
1847         _safeMint(0x0b26454ad48F3651F1cC1abCd2E590301CE93556, 2);
1848         _safeMint(0xD74b8B30ce6269bAb58B64b58245da55499B1510, 2);
1849         _safeMint(0xbf1016F104996d33007B041e38C1BEe6E7Fb5d44, 2);
1850         _safeMint(0x5343A7a198eB41E42661f2F8772a4e6c5f1C6b1C, 2);
1851         _safeMint(0xc18c9b1b03CE38425e1C21b720f406f1659002B0, 2);
1852         _safeMint(0x8d6d968B5eBbd66BC79cC1085e0854311fF523D7, 2);
1853         _safeMint(0xaD25C92bAF8564849769224E00316d56DFA5491D, 2);
1854         _safeMint(0x382e00f0EDAe8b5BcB9398D70C1d192bB699d8B7, 2);
1855         _safeMint(0xb3e010F154C03BfdBd141b563a1b92b5DD206F82, 2);
1856         _safeMint(0x54558A1998C1A2cBFF086449710d28Fb7561fe26, 2);
1857         _safeMint(0x580215e9A04f5bB3c03C4f211F91a5EA01411CA1, 2);
1858         _safeMint(0x495777e73d7977AAE1f562c40796C2C7772B29b5, 2);
1859         _safeMint(0xAa86AD45c43b69315fb97d6dAaa0034939DDA34f, 2);
1860         _safeMint(0xEac290B74B14166F15BA296Ec123985cEe96a693, 2);
1861         _safeMint(0x721Cc6751B48bbcbf3E24FA72Cc5bf932783279d, 2);
1862         _safeMint(0x102898958BBf5799F82774a4C4B692d07C59Aa77, 2);
1863         _safeMint(0x10c9374bDddA68929F712515877D6B592A2bF109, 2);
1864         _safeMint(0x00D7A43af16bFEFcc180ecf069276B0D726D4b40, 2);
1865         _safeMint(0x39B3fB116E5F5ce90Ab0A7bf8545E67C451c6263, 2);
1866         _safeMint(0x8cC186f220a2F939a8E7D9dCea340697426d2Daa, 2);
1867         _safeMint(0xaD644370BC6b596643D7Be9E3190a90d25c62346, 2);
1868         _safeMint(0xcA17d93e772ad78304A9cf9F5C7eD15e20c97052, 2);
1869         _safeMint(0x2861D3C46Aad60E971aE8fA5E379aF129D63E745, 2);
1870         _safeMint(0xf2F3b5344c0F2e87A2e613c4425eC3906652fED9, 2);
1871         _safeMint(0x603889De8CAe2431251E20fe850beDa492A7fF6C, 2);
1872         _safeMint(0x2f8404F2c087Ed5Ea1C42Ba9E8392641377A71aB, 2);
1873         _safeMint(0x9490C0AeeB1BA7ad1b871B2104C5FCE4a1323625, 2);
1874         _safeMint(0xAD9435432e85acf64173262fCe0F977552a49C2E, 2);
1875         _safeMint(0xF3d7af96A0C09E4c7a59a75C9bD10B89BD60158C, 2);
1876         _safeMint(0x36b5B82e0598f2d79592289Da87b37401B740F22, 2);
1877         _safeMint(0xa0D3D72516A042E310C459C63Dc664182A5308b9, 2);
1878         _safeMint(0x88FA0374B2aba0f6AF85fc45702f9513d27C255A, 2);
1879         _safeMint(0x9a971B4943eF05cdE48481f5bAFeE1003fEEef4d, 2);
1880         _safeMint(0x0E0A2C07DAb0f1ae64cB1fdb6209c1A01d5FB887, 2);
1881         _safeMint(0x07eE856e17a0f9181644511f4801eD29b03288a4, 2);
1882         _safeMint(0x9c2406669C9FAebbe964D5dA5429D3a320652Fb8, 2);
1883         _safeMint(0xaC2Cd9B5deAA7a3d79AC73de676989Eb49788118, 2);
1884         _safeMint(0x8Ecd31Cd9F47F4a0FCD0a82EeC0445AAB518376d, 2);
1885         _safeMint(0x5646D2E9a7e16bA92239aFD071c0C2495c31CF2C, 2);
1886         _safeMint(0xc8DFCFe493b268AA325579Fb190181C564141a59, 2);
1887         _safeMint(0x8A5675A207Cc7174D7E3b4961aA7e9fcd1234CcF, 2);
1888         _safeMint(0xaD406876a8C7A78dE7fCFF412Cb0276D4BDEb68E, 2);
1889         _safeMint(0x8945ed77E8900a3B7855BF703C192c7979b473CF, 2);
1890         _safeMint(0x2B4775773FD8F49667864208bDE1450C4AE21C03, 2);
1891         _safeMint(0x871bf5306Dab778DCc0E97166FB9a3b9E5b93D04, 2);
1892         _safeMint(0x2E7D8196b52256Da7B1D5eA22Eb8F05686Ab3cD1, 2);
1893         _safeMint(0x26CCB82eD08B0f8F1Ca0086d5B279d5ba132A8a2, 2);
1894         _safeMint(0xd39B2014EF25Ee95f1aEdE9f1d04Ea6a959cf9F6, 2);
1895         _safeMint(0x64247785234f7bdAe872b9a9222920e4EEbf7d54, 2);
1896         _safeMint(0x2653e96428088ffAa8c373Ba81f5B31bF59Ec2f4, 2);
1897         _safeMint(0x5B3228BaCB642A02cFa4763B84e4D116e6c2B709, 2);
1898         _safeMint(0xEb55B194379D0468bBd734cd08b41d9097F90D09, 2);
1899         _safeMint(0x3a15a2bd61B95C93E4DA375538f054309c4380B3, 2);
1900         _safeMint(0x0D85fb3d7Ff838d4E6C52f52D810420fbe3819F0, 2);
1901         _safeMint(0xBd44f279590d4A81A29b63E2C65119c44Cdb2581, 2);
1902         _safeMint(0x0e1A70ED924Bc4F3C57c454D7833C46911A9d849, 2);
1903         _safeMint(0x1796C568D22240d63B9566328EAB535a3968f8C3, 2);
1904         _safeMint(0x397280745AF703Fbb38e1c591524f92d42A57B89, 2);
1905         _safeMint(0x9056B05A07d4BB085f64127F39d6fAed2ed4808b, 2);
1906         _safeMint(0x069BA33753343b3E73661F06EB7D0a71b3813B4A, 2);
1907         _safeMint(0x4de6967967a3c9001d14FF57ad42D879D7E05124, 2);
1908         _safeMint(0xa0915E1C7E4C2543ecB05c423E8e7a0dB31213a7, 2);
1909         _safeMint(0xCA83C9DfdFffc4AaAe66f52906566F5d58f24E31, 2);
1910         _safeMint(0xe89b3dCa875Bd1C74bD9B22703A487472568E030, 2);
1911         _safeMint(0x1507dBF6196A6e1AB160275eC43c6baA30D1a197, 2);
1912         _safeMint(0xB4Dbcd527c8EbC09b00c4BDd506a23894604B8a0, 2);
1913         _safeMint(0x1FeC03eB0dbd4190dEB139e429A9DE6C29de70a6, 2);
1914         _safeMint(0x2fAD4D2f4BD33E0aE89c776568D2f1c2c92ddb70, 2);
1915         _safeMint(0x2746e48720BF4464B6cc334056cb540148760A38, 2);
1916         _safeMint(0x2284a738F2d84A4D035FE8121A039e79a09547FF, 2);
1917         _safeMint(0x5D37445E60C6de44c9327eC8Bb300e876C3D5713, 2);
1918         _safeMint(0xD6DFd56ab8A116ED6370984945FEB8Be7d6c3221, 2);
1919         _safeMint(0xb03F4d215e2ef5986b763B45BDF53E330BE38d62, 2);
1920         _safeMint(0xeb89b2499077C01c094b8398A98a11A3087Cbb3b, 2);
1921         _safeMint(0x280b5EC890809a98435B84f0cDb56714B16A4c91, 2);
1922         _safeMint(0x9B7f79e13768e4dAbA808492E59CAF16aaAc952E, 2);
1923         _safeMint(0x863581c07688D990210c0Fda40cb2347de9DC873, 2);
1924         _safeMint(0xB38319AC1308ddcf15e3cd8f6d67D26F424279E5, 2);
1925         _safeMint(0xe09adcc2854C3299a2886D0DFeb03ed2a3Df63D0, 2);
1926         _safeMint(0xA6769fA1625845Ca606A6aA3C8056Bc2982C1076, 2);
1927         _safeMint(0xe30bfb74c86A316f4e03d42C8f261324CDD25173, 2);
1928         _safeMint(0x5dC73C27933411916D612c55a074BF38e3b75a97, 2);
1929         _safeMint(0x21dcB6f533D13166ABb801390744d0BfF8a546A0, 2);
1930         _safeMint(0xFb8d3BDD6Da52F65227A6a17f96C939e53908326, 2);
1931         _safeMint(0xDD41AdE62481e69F171d758a14680a060b42fc44, 2);
1932         _safeMint(0xEE04770359f9363A5d67a7F80f6Ac4122dFb970e, 2);
1933         _safeMint(0x0e999151217a907B2C4dDB90BEc16f05b263f923, 2);
1934         _safeMint(0x7Bd02565e438C7Eb709313Ac5A7C15d023e6f985, 2);
1935         _safeMint(0xABf35f4981b9497d01d951D7577bF0de21fFaA2B, 2);
1936         _safeMint(0xF88F8d5eDf096576c5eCfbb51b1fc12E8a144fA4, 2);
1937         _safeMint(0x32502a4D1c96273fe62669165A64b8a39f4512B4, 2);
1938         _safeMint(0xEDad44d3D2c67e30bEb056a68fef514d0E52BaaF, 2);
1939         _safeMint(0xD9bDed47B38999Bb8C584a051b6b0E7Ed39aAfd8, 2);
1940         _safeMint(0xe53B6F0F2Cff473e7FC31Adc712112351f411B2b, 2);
1941         _safeMint(0x25e4B97cc81eB2Ff49a719Edd86dE91d47531da7, 2);
1942         _safeMint(0x85E5e02EFB864b609a587c522C7148C662730aD5, 2);
1943         _safeMint(0xC8c5dF49795e3f5E2943eEBFf50C3Cc9fb8d4967, 2);
1944         _safeMint(0x4f2793344c2cf3A4C18305bA834Da0D7188Bcaf2, 2);
1945         _safeMint(0x4FBb8130A8DDc899c879c445abF15463c29f1DC5, 2);
1946         _safeMint(0xEb7CF8C3F5e4425d6426FD84A5F8AFD68569a64f, 2);
1947         _safeMint(0x2De09E956a252203a60a36f9ca143ecEe336d827, 2);
1948         _safeMint(0x6173b476B12Cc40099F6e6fA6c064D6EE2aB493a, 2);
1949         _safeMint(0xC59e912fc173F7d62Af19d405816970dAE7384f8, 2);
1950         _safeMint(0x1697a4e259bc568814cc575D29B878B6992d5f9c, 2);
1951         _safeMint(0xB080D6F42d774818bb9549492147917727C11dAC, 2);
1952         _safeMint(0x832C5dd5bE10B8a188f858b41e6bF426aE6917aC, 2);
1953         _safeMint(0xDCdf84646166E015496C51E5D9099F52Ae753903, 2);
1954         _safeMint(0xcE504F9d1F95AB5DcE9c8318393b95B351c6C868, 2);
1955         _safeMint(0x24a6AE8D89DA1d0ba1d8A3c3012216bFc0D99888, 2);
1956         _safeMint(0xC5DC0a1064fddE66962a2B449057FE339F4D86Fb, 2);
1957         _safeMint(0x07197EcAF257a64502fD5Fe6A0d5bf31DbCBa081, 2);
1958         _safeMint(0x6590592B2c2753f3C5c564430F6eF12C11a82Cd1, 2);
1959         _safeMint(0x861dd17c9fea84F9D8Bc6D32c34B90F4eC6317Fb, 2);
1960         _safeMint(0xBA5E8D9dccf97a200b30f54f4EC5EDBE2fE92ED1, 2);
1961         _safeMint(0x19b191f625518c85C54C5d672e7fc9440F1824E0, 2);
1962         _safeMint(0x40F085176BEaa2Fc417164D4b8e7399c4AddEf77, 2);
1963         _safeMint(0x61D3D2452448f9f78380FF40d924855719029fb0, 2);
1964         _safeMint(0x54C5BC3e9ca2CE0b69aF1D5102f6F8fb268A7513, 2);
1965         _safeMint(0x44BB5F45f3f447e90200d61eC4c68f41cCFf37Ff, 2);
1966         _safeMint(0xdeC2c041B3B5dC8Ed7b77B87F6a986fe225Bf30e, 2);
1967         _safeMint(0x213571f3b8B8cC8f463c42D994c3f5E2C34fA3F0, 2);
1968         _safeMint(0x58217E3c57a74B9Bf6c539A755c2B0e417162a9C, 2);
1969         _safeMint(0x8bC539F3cFB68C28d52102180a877dcf7db476Ae, 2);
1970         _safeMint(0x70919456288650894Fd2DCE95Ed78BBe57dFDbf6, 2);
1971         _safeMint(0x04B2CB5BB145E6ba3D67c9DEbcc14c461c9a968D, 2);
1972         _safeMint(0x31E58EdE8f0e39Dc832BDaF992CBE9EF3c70f545, 2);
1973         _safeMint(0xdaea44D64813A1a4bBA1B2A61c10D915234Bf105, 2);
1974         _safeMint(0x6A5b8C260f6EcE3B361a1998DA609335d618AC48, 2);
1975         _safeMint(0xAd74b2FCa61Ab5E987907F3DA9825776F53e6c02, 2);
1976         _safeMint(0x7268146dDca1b4917758456041764b8eC4317dDE, 2);
1977         _safeMint(0x97d93F8a99c74FaAD615f56ebf27654D63A34a5d, 2);
1978         _safeMint(0x62A79a85E34DB40fAC6F422BfAF1cb86d15C550E, 10);
1979         _safeMint(0xd27d1C330B89a11C2b62613E22Be40BC19d4351E, 10);
1980         _safeMint(0xFD3f1300948ecF87677E54120Ed7C1fE151c53C3, 10);
1981         _safeMint(0x3832a2Adbb1f55B284f67DAccdbe8effc01128e5, 10);
1982         _safeMint(0x8E893de17Ee6C3d2c725502Ab3a0614779c3cCCb, 10);
1983         _safeMint(0xF7CB1ACcfaE480283B9560A0B1D614663033d876, 10);
1984         _safeMint(0x739b51cE1645E4E13ff1a87e93013C3fd3360Ed9, 10);
1985         _safeMint(0xd2d6d1De0577E1FEb65279d3D291d04Cff10f00D, 10);
1986         _safeMint(0x98845CFA79B5Fa7878cB7BC203b8bF1429Ec4e7e, 10);
1987         _safeMint(0xd83dFa6E5301A3A98972ef6F1109927Ed48aAbf9, 10);
1988         _safeMint(0x9590Ea8123396623d109ef502b05659E9Ab59584, 10);
1989         _safeMint(0xe818E86d00670559c15A0943F37280CfFca1CB2E, 10);
1990         _safeMint(0x5fA89a1a3fef2c4Ca7083d4Dd1f6509dEee25df7, 10);
1991         _safeMint(0x327993A6950c0BD11F2f31511E42949DA5E8DaFb, 10);
1992         _safeMint(0x95EBF2A0EfEbd053C576806bbfC007ab80fB9870, 10);
1993         _safeMint(0x565E5E99ECe7aD636bAeffd162a1D9B7A6e5aC8e, 10);
1994         _safeMint(0xd6FeB6d54a254D5408b072B5CB1E43606eeEb2f7, 10);
1995         _safeMint(0x7b50700534cc27bD9aD321A475Fd136f7Fc0a333, 10);
1996     }
1997 
1998     function togglePublicSale() external onlyOwner {
1999         publicSale = !publicSale;
2000     }
2001 
2002     function toggleReserveSale() external onlyOwner {
2003         reservelistSale = !reservelistSale;
2004     }
2005 
2006     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2007         baseURI = _newBaseURI;
2008     }
2009 
2010     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2011         merkleRoot = _merkleRoot;
2012     }
2013 
2014     function _baseURI() internal view override returns (string memory) {
2015         return baseURI;
2016     }
2017 
2018     //change max mint for wl
2019     function setMaxWhitelistMint(uint256 _newMaxWhitelistMint) external onlyOwner {
2020         maxWhitelistMint = _newMaxWhitelistMint;
2021     }
2022 
2023     //change max mint for publix
2024     function setMaxPublicMint(uint256 _newMaxPublicMint) external onlyOwner {
2025         maxPublicMint = _newMaxPublicMint;
2026     }
2027 
2028     //wl only mint
2029     function whitelistMint(uint256 tokens, bytes32[] calldata merkleProof) external {
2030         require(whitelistSale, "BAGS: You can not mint right now");
2031         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "BAGS: Please wait to mint on public sale");
2032         require(_whitelistClaimed[_msgSender()] + tokens <= maxWhitelistMint, "BAGS: Cannot mint this many BAGS");
2033         require(tokens > 0, "BAGS: Please mint at least 1 BAGS");
2034 
2035         _whitelistClaimed[_msgSender()] += tokens;
2036         _safeMint(_msgSender(), tokens);
2037     }
2038 
2039     //reserve only mint
2040     function reserveMint(uint256 tokens, bytes32[] calldata merkleProof) external {
2041         require(reservelistSale, "BAGS: You can not mint right now");
2042         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "BAGS: Please wait to mint on public sale");
2043         require(_reserveClaimed[_msgSender()] + tokens <= maxWhitelistMint, "BAGS: Cannot mint this many BAGS");
2044         require(tokens > 0, "BAGS: Please mint at least 1 BAGS");
2045 
2046         _whitelistClaimed[_msgSender()] += tokens;
2047         _reserveClaimed[_msgSender()] += tokens;
2048         _safeMint(_msgSender(), tokens);
2049     }
2050 
2051     //mint function for public
2052     function mint(uint256 tokens) external {
2053         require(publicSale, "BAGS: Public sale has not started");
2054         require(totalSupply() + tokens <= MAX_TOKENS, "BAGS: Exceeded supply");
2055         require(_publicClaimed[_msgSender()] + tokens <= maxPublicMint, "BAGS: Cannot mint this many BAGS");
2056         require(tokens > 0, "BAGS: Please mint at least 1 BAGS");
2057 
2058         _publicClaimed[_msgSender()] +=tokens;
2059         _safeMint(_msgSender(), tokens);
2060     }
2061 
2062     // No restrictions. use for giveaways, airdrops, etc
2063     function airdrop(address to, uint256 tokens) external onlyOwner {
2064         require(totalSupply() + tokens <= MAX_TOKENS, "BAGS: Minting would exceed max supply");
2065         require(tokens > 0, "BAGS: Must mint at least one token");
2066         _safeMint(to, tokens);
2067     }
2068 }