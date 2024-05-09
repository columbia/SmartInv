1 //                                                           
2 //                  ..=*********+=.                          
3 //               :+#%%%%%%%%%%%%%%%%#+-.                     
4 //             :#%%%%%%%%%%%%%%%%%####%%#-                   
5 //           :*%%%%%%%#%%%%%%%%%%%%%%%%%%%#-                 
6 //       .-+#%%%%%%##%%%%%%%%%%%%%%%@@@@@@@%#:               
7 //     =%%%%%%#%%##%%%%%%%%%%%#-.......-=*@@@@               
8 //    :%%%%###%%###%##%%%%%%%#----:..:-----*@@=              
9 //      -*@%%%%%####%%%%%%%%+.............:.+@@:             
10 //         :+@%%%%#%%%%%%%%-..:.........:.::.#@%             
11 //           =%%%#%%%%%%%#-:=****=:.....:=+=-+@%             
12 //            #%%#%%%%%%%:=*#######=...+#####*%@-            
13 //            #%%#%%%%%*.-##########-.+######*%@=            
14 //           *@%%%%%%%#..-##########-.+######*%@-            
15 //          *%%%%%%%%#+:.::::+#####+:.:*##*--+@%             
16 //        .*@%%%%%%%%*+=.....:*+==::*+:.--...-@@-            
17 //        %%%%%%%%@@@@#*+-:..::............+%@@@#            
18 //       =%%%%%%%@@@@@@@@%#*=---...-...=..:%@@@@@.           
19 //       .%%%%%%@@@@@@@@@@%***++-:-+:::*=-+@@@@@@+           
20 //         =%%%%%@@@@@@@@@@#*++=-:-*-:-*:.*@@@@@%            
21 //           =*@%%@@@@@@@@@#+++---=*---#++#@@@*=             
22 //          :#@@@@@@@@@@@@%#*++++*#@@@@@@@@@%*+.             
23 //        .*@@@@%%%%@@@@@@@@%@@@@@%@@@@@%%%%%%%%=            
24 //       .%@@%%@@@@@@@@@%%@@@%@@@%@@%@@%%%@@@%%%%+           
25 //       +@@%%%%%@@@@%%%%%%%@@%%%@%%%%@@@@@%%%%%@%.          
26 //       %%@%%%%%%%%%%@%%%%%%%%%%@%%%%%@%%%%%%%%%@:          
27 //       %%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%@@:          
28 //       +@@%%@%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%@@@@%          
29 //       %@@%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%@%@@@@@-         
30 
31 
32 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
33 
34 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 // CAUTION
39 // This version of SafeMath should only be used with Solidity 0.8 or later,
40 // because it relies on the compiler's built in overflow checks.
41 
42 /**
43  * @dev Wrappers over Solidity's arithmetic operations.
44  *
45  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
46  * now has built in overflow checking.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, with an overflow flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             uint256 c = a + b;
57             if (c < a) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
64      *
65      * _Available since v3.4._
66      */
67     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b > a) return (false, 0);
70             return (true, a - b);
71         }
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82             // benefit is lost if 'b' is also tested.
83             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84             if (a == 0) return (true, 0);
85             uint256 c = a * b;
86             if (c / a != b) return (false, 0);
87             return (true, c);
88         }
89     }
90 
91     /**
92      * @dev Returns the division of two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         unchecked {
98             if (b == 0) return (false, 0);
99             return (true, a / b);
100         }
101     }
102 
103     /**
104      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
105      *
106      * _Available since v3.4._
107      */
108     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             if (b == 0) return (false, 0);
111             return (true, a % b);
112         }
113     }
114 
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a + b;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a - b;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a * b;
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers, reverting on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator.
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a / b;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * reverting when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a % b;
185     }
186 
187     /**
188      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
189      * overflow (when the result is negative).
190      *
191      * CAUTION: This function is deprecated because it requires allocating memory for the error
192      * message unnecessarily. For custom revert reasons use {trySub}.
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(
201         uint256 a,
202         uint256 b,
203         string memory errorMessage
204     ) internal pure returns (uint256) {
205         unchecked {
206             require(b <= a, errorMessage);
207             return a - b;
208         }
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         unchecked {
229             require(b > 0, errorMessage);
230             return a / b;
231         }
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * reverting with custom message when dividing by zero.
237      *
238      * CAUTION: This function is deprecated because it requires allocating memory for the error
239      * message unnecessarily. For custom revert reasons use {tryMod}.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         unchecked {
255             require(b > 0, errorMessage);
256             return a % b;
257         }
258     }
259 }
260 
261 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 /**
269  * @dev Contract module that helps prevent reentrant calls to a function.
270  *
271  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
272  * available, which can be applied to functions to make sure there are no nested
273  * (reentrant) calls to them.
274  *
275  * Note that because there is a single `nonReentrant` guard, functions marked as
276  * `nonReentrant` may not call one another. This can be worked around by making
277  * those functions `private`, and then adding `external` `nonReentrant` entry
278  * points to them.
279  *
280  * TIP: If you would like to learn more about reentrancy and alternative ways
281  * to protect against it, check out our blog post
282  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
283  */
284 abstract contract ReentrancyGuard {
285     // Booleans are more expensive than uint256 or any type that takes up a full
286     // word because each write operation emits an extra SLOAD to first read the
287     // slot's contents, replace the bits taken up by the boolean, and then write
288     // back. This is the compiler's defense against contract upgrades and
289     // pointer aliasing, and it cannot be disabled.
290 
291     // The values being non-zero value makes deployment a bit more expensive,
292     // but in exchange the refund on every call to nonReentrant will be lower in
293     // amount. Since refunds are capped to a percentage of the total
294     // transaction's gas, it is best to keep them low in cases like this one, to
295     // increase the likelihood of the full refund coming into effect.
296     uint256 private constant _NOT_ENTERED = 1;
297     uint256 private constant _ENTERED = 2;
298 
299     uint256 private _status;
300 
301     constructor() {
302         _status = _NOT_ENTERED;
303     }
304 
305     /**
306      * @dev Prevents a contract from calling itself, directly or indirectly.
307      * Calling a `nonReentrant` function from another `nonReentrant`
308      * function is not supported. It is possible to prevent this from happening
309      * by making the `nonReentrant` function external, and making it call a
310      * `private` function that does the actual work.
311      */
312     modifier nonReentrant() {
313         // On the first call to nonReentrant, _notEntered will be true
314         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
315 
316         // Any calls to nonReentrant after this point will fail
317         _status = _ENTERED;
318 
319         _;
320 
321         // By storing the original value once again, a refund is triggered (see
322         // https://eips.ethereum.org/EIPS/eip-2200)
323         _status = _NOT_ENTERED;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Strings.sol
328 
329 
330 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev String operations.
336  */
337 library Strings {
338     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
339     uint8 private constant _ADDRESS_LENGTH = 20;
340 
341     /**
342      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
343      */
344     function toString(uint256 value) internal pure returns (string memory) {
345         // Inspired by OraclizeAPI's implementation - MIT licence
346         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
347 
348         if (value == 0) {
349             return "0";
350         }
351         uint256 temp = value;
352         uint256 digits;
353         while (temp != 0) {
354             digits++;
355             temp /= 10;
356         }
357         bytes memory buffer = new bytes(digits);
358         while (value != 0) {
359             digits -= 1;
360             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
361             value /= 10;
362         }
363         return string(buffer);
364     }
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
368      */
369     function toHexString(uint256 value) internal pure returns (string memory) {
370         if (value == 0) {
371             return "0x00";
372         }
373         uint256 temp = value;
374         uint256 length = 0;
375         while (temp != 0) {
376             length++;
377             temp >>= 8;
378         }
379         return toHexString(value, length);
380     }
381 
382     /**
383      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
384      */
385     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
386         bytes memory buffer = new bytes(2 * length + 2);
387         buffer[0] = "0";
388         buffer[1] = "x";
389         for (uint256 i = 2 * length + 1; i > 1; --i) {
390             buffer[i] = _HEX_SYMBOLS[value & 0xf];
391             value >>= 4;
392         }
393         require(value == 0, "Strings: hex length insufficient");
394         return string(buffer);
395     }
396 
397     /**
398      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
399      */
400     function toHexString(address addr) internal pure returns (string memory) {
401         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
402     }
403 }
404 
405 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
406 
407 
408 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev These functions deal with verification of Merkle Tree proofs.
414  *
415  * The proofs can be generated using the JavaScript library
416  * https://github.com/miguelmota/merkletreejs[merkletreejs].
417  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
418  *
419  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
420  *
421  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
422  * hashing, or use a hash function other than keccak256 for hashing leaves.
423  * This is because the concatenation of a sorted pair of internal nodes in
424  * the merkle tree could be reinterpreted as a leaf value.
425  */
426 library MerkleProof {
427     /**
428      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
429      * defined by `root`. For this, a `proof` must be provided, containing
430      * sibling hashes on the branch from the leaf to the root of the tree. Each
431      * pair of leaves and each pair of pre-images are assumed to be sorted.
432      */
433     function verify(
434         bytes32[] memory proof,
435         bytes32 root,
436         bytes32 leaf
437     ) internal pure returns (bool) {
438         return processProof(proof, leaf) == root;
439     }
440 
441     /**
442      * @dev Calldata version of {verify}
443      *
444      * _Available since v4.7._
445      */
446     function verifyCalldata(
447         bytes32[] calldata proof,
448         bytes32 root,
449         bytes32 leaf
450     ) internal pure returns (bool) {
451         return processProofCalldata(proof, leaf) == root;
452     }
453 
454     /**
455      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
456      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
457      * hash matches the root of the tree. When processing the proof, the pairs
458      * of leafs & pre-images are assumed to be sorted.
459      *
460      * _Available since v4.4._
461      */
462     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
463         bytes32 computedHash = leaf;
464         for (uint256 i = 0; i < proof.length; i++) {
465             computedHash = _hashPair(computedHash, proof[i]);
466         }
467         return computedHash;
468     }
469 
470     /**
471      * @dev Calldata version of {processProof}
472      *
473      * _Available since v4.7._
474      */
475     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
476         bytes32 computedHash = leaf;
477         for (uint256 i = 0; i < proof.length; i++) {
478             computedHash = _hashPair(computedHash, proof[i]);
479         }
480         return computedHash;
481     }
482 
483     /**
484      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
485      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
486      *
487      * _Available since v4.7._
488      */
489     function multiProofVerify(
490         bytes32[] memory proof,
491         bool[] memory proofFlags,
492         bytes32 root,
493         bytes32[] memory leaves
494     ) internal pure returns (bool) {
495         return processMultiProof(proof, proofFlags, leaves) == root;
496     }
497 
498     /**
499      * @dev Calldata version of {multiProofVerify}
500      *
501      * _Available since v4.7._
502      */
503     function multiProofVerifyCalldata(
504         bytes32[] calldata proof,
505         bool[] calldata proofFlags,
506         bytes32 root,
507         bytes32[] memory leaves
508     ) internal pure returns (bool) {
509         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
510     }
511 
512     /**
513      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
514      * consuming from one or the other at each step according to the instructions given by
515      * `proofFlags`.
516      *
517      * _Available since v4.7._
518      */
519     function processMultiProof(
520         bytes32[] memory proof,
521         bool[] memory proofFlags,
522         bytes32[] memory leaves
523     ) internal pure returns (bytes32 merkleRoot) {
524         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
525         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
526         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
527         // the merkle tree.
528         uint256 leavesLen = leaves.length;
529         uint256 totalHashes = proofFlags.length;
530 
531         // Check proof validity.
532         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
533 
534         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
535         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
536         bytes32[] memory hashes = new bytes32[](totalHashes);
537         uint256 leafPos = 0;
538         uint256 hashPos = 0;
539         uint256 proofPos = 0;
540         // At each step, we compute the next hash using two values:
541         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
542         //   get the next hash.
543         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
544         //   `proof` array.
545         for (uint256 i = 0; i < totalHashes; i++) {
546             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
547             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
548             hashes[i] = _hashPair(a, b);
549         }
550 
551         if (totalHashes > 0) {
552             return hashes[totalHashes - 1];
553         } else if (leavesLen > 0) {
554             return leaves[0];
555         } else {
556             return proof[0];
557         }
558     }
559 
560     /**
561      * @dev Calldata version of {processMultiProof}
562      *
563      * _Available since v4.7._
564      */
565     function processMultiProofCalldata(
566         bytes32[] calldata proof,
567         bool[] calldata proofFlags,
568         bytes32[] memory leaves
569     ) internal pure returns (bytes32 merkleRoot) {
570         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
571         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
572         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
573         // the merkle tree.
574         uint256 leavesLen = leaves.length;
575         uint256 totalHashes = proofFlags.length;
576 
577         // Check proof validity.
578         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
579 
580         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
581         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
582         bytes32[] memory hashes = new bytes32[](totalHashes);
583         uint256 leafPos = 0;
584         uint256 hashPos = 0;
585         uint256 proofPos = 0;
586         // At each step, we compute the next hash using two values:
587         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
588         //   get the next hash.
589         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
590         //   `proof` array.
591         for (uint256 i = 0; i < totalHashes; i++) {
592             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
593             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
594             hashes[i] = _hashPair(a, b);
595         }
596 
597         if (totalHashes > 0) {
598             return hashes[totalHashes - 1];
599         } else if (leavesLen > 0) {
600             return leaves[0];
601         } else {
602             return proof[0];
603         }
604     }
605 
606     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
607         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
608     }
609 
610     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
611         /// @solidity memory-safe-assembly
612         assembly {
613             mstore(0x00, a)
614             mstore(0x20, b)
615             value := keccak256(0x00, 0x40)
616         }
617     }
618 }
619 // File: IERC721A.sol
620 
621 
622 // ERC721A Contracts v4.2.2
623 // Creator: Chiru Labs
624 
625 pragma solidity ^0.8.4;
626 
627 /**
628  * @dev Interface of ERC721A.
629  */
630 interface IERC721A {
631     /**
632      * The caller must own the token or be an approved operator.
633      */
634     error ApprovalCallerNotOwnerNorApproved();
635 
636     /**
637      * The token does not exist.
638      */
639     error ApprovalQueryForNonexistentToken();
640 
641     /**
642      * The caller cannot approve to their own address.
643      */
644     error ApproveToCaller();
645 
646     /**
647      * Cannot query the balance for the zero address.
648      */
649     error BalanceQueryForZeroAddress();
650 
651     /**
652      * Cannot mint to the zero address.
653      */
654     error MintToZeroAddress();
655 
656     /**
657      * The quantity of tokens minted must be more than zero.
658      */
659     error MintZeroQuantity();
660 
661     /**
662      * The token does not exist.
663      */
664     error OwnerQueryForNonexistentToken();
665 
666     /**
667      * The caller must own the token or be an approved operator.
668      */
669     error TransferCallerNotOwnerNorApproved();
670 
671     /**
672      * The token must be owned by `from`.
673      */
674     error TransferFromIncorrectOwner();
675 
676     /**
677      * Cannot safely transfer to a contract that does not implement the
678      * ERC721Receiver interface.
679      */
680     error TransferToNonERC721ReceiverImplementer();
681 
682     /**
683      * Cannot transfer to the zero address.
684      */
685     error TransferToZeroAddress();
686 
687     /**
688      * The token does not exist.
689      */
690     error URIQueryForNonexistentToken();
691 
692     /**
693      * The `quantity` minted with ERC2309 exceeds the safety limit.
694      */
695     error MintERC2309QuantityExceedsLimit();
696 
697     /**
698      * The `extraData` cannot be set on an unintialized ownership slot.
699      */
700     error OwnershipNotInitializedForExtraData();
701 
702     // =============================================================
703     //                            STRUCTS
704     // =============================================================
705 
706     struct TokenOwnership {
707         // The address of the owner.
708         address addr;
709         // Stores the start time of ownership with minimal overhead for tokenomics.
710         uint64 startTimestamp;
711         // Whether the token has been burned.
712         bool burned;
713         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
714         uint24 extraData;
715     }
716 
717     // =============================================================
718     //                         TOKEN COUNTERS
719     // =============================================================
720 
721     /**
722      * @dev Returns the total number of tokens in existence.
723      * Burned tokens will reduce the count.
724      * To get the total number of tokens minted, please see {_totalMinted}.
725      */
726     function totalSupply() external view returns (uint256);
727 
728     // =============================================================
729     //                            IERC165
730     // =============================================================
731 
732     /**
733      * @dev Returns true if this contract implements the interface defined by
734      * `interfaceId`. See the corresponding
735      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
736      * to learn more about how these ids are created.
737      *
738      * This function call must use less than 30000 gas.
739      */
740     function supportsInterface(bytes4 interfaceId) external view returns (bool);
741 
742     // =============================================================
743     //                            IERC721
744     // =============================================================
745 
746     /**
747      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
748      */
749     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
750 
751     /**
752      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
753      */
754     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
755 
756     /**
757      * @dev Emitted when `owner` enables or disables
758      * (`approved`) `operator` to manage all of its assets.
759      */
760     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
761 
762     /**
763      * @dev Returns the number of tokens in `owner`'s account.
764      */
765     function balanceOf(address owner) external view returns (uint256 balance);
766 
767     /**
768      * @dev Returns the owner of the `tokenId` token.
769      *
770      * Requirements:
771      *
772      * - `tokenId` must exist.
773      */
774     function ownerOf(uint256 tokenId) external view returns (address owner);
775 
776     /**
777      * @dev Safely transfers `tokenId` token from `from` to `to`,
778      * checking first that contract recipients are aware of the ERC721 protocol
779      * to prevent tokens from being forever locked.
780      *
781      * Requirements:
782      *
783      * - `from` cannot be the zero address.
784      * - `to` cannot be the zero address.
785      * - `tokenId` token must exist and be owned by `from`.
786      * - If the caller is not `from`, it must be have been allowed to move
787      * this token by either {approve} or {setApprovalForAll}.
788      * - If `to` refers to a smart contract, it must implement
789      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
790      *
791      * Emits a {Transfer} event.
792      */
793     function safeTransferFrom(
794         address from,
795         address to,
796         uint256 tokenId,
797         bytes calldata data
798     ) external;
799 
800     /**
801      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
802      */
803     function safeTransferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) external;
808 
809     /**
810      * @dev Transfers `tokenId` from `from` to `to`.
811      *
812      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
813      * whenever possible.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must be owned by `from`.
820      * - If the caller is not `from`, it must be approved to move this token
821      * by either {approve} or {setApprovalForAll}.
822      *
823      * Emits a {Transfer} event.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) external;
830 
831     /**
832      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
833      * The approval is cleared when the token is transferred.
834      *
835      * Only a single account can be approved at a time, so approving the
836      * zero address clears previous approvals.
837      *
838      * Requirements:
839      *
840      * - The caller must own the token or be an approved operator.
841      * - `tokenId` must exist.
842      *
843      * Emits an {Approval} event.
844      */
845     function approve(address to, uint256 tokenId) external;
846 
847     /**
848      * @dev Approve or remove `operator` as an operator for the caller.
849      * Operators can call {transferFrom} or {safeTransferFrom}
850      * for any token owned by the caller.
851      *
852      * Requirements:
853      *
854      * - The `operator` cannot be the caller.
855      *
856      * Emits an {ApprovalForAll} event.
857      */
858     function setApprovalForAll(address operator, bool _approved) external;
859 
860     /**
861      * @dev Returns the account approved for `tokenId` token.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      */
867     function getApproved(uint256 tokenId) external view returns (address operator);
868 
869     /**
870      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
871      *
872      * See {setApprovalForAll}.
873      */
874     function isApprovedForAll(address owner, address operator) external view returns (bool);
875 
876     // =============================================================
877     //                        IERC721Metadata
878     // =============================================================
879 
880     /**
881      * @dev Returns the token collection name.
882      */
883     function name() external view returns (string memory);
884 
885     /**
886      * @dev Returns the token collection symbol.
887      */
888     function symbol() external view returns (string memory);
889 
890     /**
891      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
892      */
893     function tokenURI(uint256 tokenId) external view returns (string memory);
894 
895     // =============================================================
896     //                           IERC2309
897     // =============================================================
898 
899     /**
900      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
901      * (inclusive) is transferred from `from` to `to`, as defined in the
902      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
903      *
904      * See {_mintERC2309} for more details.
905      */
906     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
907 }
908 // File: @openzeppelin/contracts/utils/Context.sol
909 
910 
911 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
912 
913 pragma solidity ^0.8.0;
914 
915 /**
916  * @dev Provides information about the current execution context, including the
917  * sender of the transaction and its data. While these are generally available
918  * via msg.sender and msg.data, they should not be accessed in such a direct
919  * manner, since when dealing with meta-transactions the account sending and
920  * paying for execution may not be the actual sender (as far as an application
921  * is concerned).
922  *
923  * This contract is only required for intermediate, library-like contracts.
924  */
925 abstract contract Context {
926     function _msgSender() internal view virtual returns (address) {
927         return msg.sender;
928     }
929 
930     function _msgData() internal view virtual returns (bytes calldata) {
931         return msg.data;
932     }
933 }
934 
935 // File: ERC721A.sol
936 
937 
938 // ERC721A Contracts v4.2.2
939 // Creator: Chiru Labs
940 
941 pragma solidity ^0.8.4;
942 
943 
944 
945 /**
946  * @dev Interface of ERC721 token receiver.
947  */
948 interface ERC721A__IERC721Receiver {
949     function onERC721Received(
950         address operator,
951         address from,
952         uint256 tokenId,
953         bytes calldata data
954     ) external returns (bytes4);
955 }
956 
957 /**
958  * @title ERC721A
959  *
960  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
961  * Non-Fungible Token Standard, including the Metadata extension.
962  * Optimized for lower gas during batch mints.
963  *
964  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
965  * starting from `_startTokenId()`.
966  *
967  * Assumptions:
968  *
969  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
970  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
971  */
972 contract ERC721A is IERC721A {
973     // Reference type for token approval.
974     struct TokenApprovalRef {
975         address value;
976     }
977 
978     // =============================================================
979     //                           CONSTANTS
980     // =============================================================
981 
982     // Mask of an entry in packed address data.
983     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
984 
985     // The bit position of `numberMinted` in packed address data.
986     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
987 
988     // The bit position of `numberBurned` in packed address data.
989     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
990 
991     // The bit position of `aux` in packed address data.
992     uint256 private constant _BITPOS_AUX = 192;
993 
994     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
995     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
996 
997     // The bit position of `startTimestamp` in packed ownership.
998     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
999 
1000     // The bit mask of the `burned` bit in packed ownership.
1001     uint256 private constant _BITMASK_BURNED = 1 << 224;
1002 
1003     // The bit position of the `nextInitialized` bit in packed ownership.
1004     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1005 
1006     // The bit mask of the `nextInitialized` bit in packed ownership.
1007     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1008 
1009     // The bit position of `extraData` in packed ownership.
1010     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1011 
1012     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1013     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1014 
1015     // The mask of the lower 160 bits for addresses.
1016     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1017 
1018     // The maximum `quantity` that can be minted with {_mintERC2309}.
1019     // This limit is to prevent overflows on the address data entries.
1020     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1021     // is required to cause an overflow, which is unrealistic.
1022     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1023 
1024     // The `Transfer` event signature is given by:
1025     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1026     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1027         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1028 
1029     // =============================================================
1030     //                            STORAGE
1031     // =============================================================
1032 
1033     // The next token ID to be minted.
1034     uint256 private _currentIndex;
1035 
1036     // The number of tokens burned.
1037     uint256 private _burnCounter;
1038 
1039     // Token name
1040     string private _name;
1041 
1042     // Token symbol
1043     string private _symbol;
1044 
1045     // Mapping from token ID to ownership details
1046     // An empty struct value does not necessarily mean the token is unowned.
1047     // See {_packedOwnershipOf} implementation for details.
1048     //
1049     // Bits Layout:
1050     // - [0..159]   `addr`
1051     // - [160..223] `startTimestamp`
1052     // - [224]      `burned`
1053     // - [225]      `nextInitialized`
1054     // - [232..255] `extraData`
1055     mapping(uint256 => uint256) private _packedOwnerships;
1056 
1057     // Mapping owner address to address data.
1058     //
1059     // Bits Layout:
1060     // - [0..63]    `balance`
1061     // - [64..127]  `numberMinted`
1062     // - [128..191] `numberBurned`
1063     // - [192..255] `aux`
1064     mapping(address => uint256) private _packedAddressData;
1065 
1066     // Mapping from token ID to approved address.
1067     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1068 
1069     // Mapping from owner to operator approvals
1070     mapping(address => mapping(address => bool)) private _operatorApprovals;
1071 
1072     // =============================================================
1073     //                          CONSTRUCTOR
1074     // =============================================================
1075 
1076     constructor(string memory name_, string memory symbol_) {
1077         _name = name_;
1078         _symbol = symbol_;
1079         _currentIndex = _startTokenId();
1080     }
1081 
1082     // =============================================================
1083     //                   TOKEN COUNTING OPERATIONS
1084     // =============================================================
1085 
1086     /**
1087      * @dev Returns the starting token ID.
1088      * To change the starting token ID, please override this function.
1089      */
1090     function _startTokenId() internal view virtual returns (uint256) {
1091         return 0;
1092     }
1093 
1094     /**
1095      * @dev Returns the next token ID to be minted.
1096      */
1097     function _nextTokenId() internal view virtual returns (uint256) {
1098         return _currentIndex;
1099     }
1100 
1101     /**
1102      * @dev Returns the total number of tokens in existence.
1103      * Burned tokens will reduce the count.
1104      * To get the total number of tokens minted, please see {_totalMinted}.
1105      */
1106     function totalSupply() public view virtual override returns (uint256) {
1107         // Counter underflow is impossible as _burnCounter cannot be incremented
1108         // more than `_currentIndex - _startTokenId()` times.
1109         unchecked {
1110             return _currentIndex - _burnCounter - _startTokenId();
1111         }
1112     }
1113 
1114     /**
1115      * @dev Returns the total amount of tokens minted in the contract.
1116      */
1117     function _totalMinted() internal view virtual returns (uint256) {
1118         // Counter underflow is impossible as `_currentIndex` does not decrement,
1119         // and it is initialized to `_startTokenId()`.
1120         unchecked {
1121             return _currentIndex - _startTokenId();
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns the total number of tokens burned.
1127      */
1128     function _totalBurned() internal view virtual returns (uint256) {
1129         return _burnCounter;
1130     }
1131 
1132     // =============================================================
1133     //                    ADDRESS DATA OPERATIONS
1134     // =============================================================
1135 
1136     /**
1137      * @dev Returns the number of tokens in `owner`'s account.
1138      */
1139     function balanceOf(address owner) public view virtual override returns (uint256) {
1140         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1141         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1142     }
1143 
1144     /**
1145      * Returns the number of tokens minted by `owner`.
1146      */
1147     function _numberMinted(address owner) internal view returns (uint256) {
1148         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1149     }
1150 
1151     /**
1152      * Returns the number of tokens burned by or on behalf of `owner`.
1153      */
1154     function _numberBurned(address owner) internal view returns (uint256) {
1155         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1156     }
1157 
1158     /**
1159      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1160      */
1161     function _getAux(address owner) internal view returns (uint64) {
1162         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1163     }
1164 
1165     /**
1166      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1167      * If there are multiple variables, please pack them into a uint64.
1168      */
1169     function _setAux(address owner, uint64 aux) internal virtual {
1170         uint256 packed = _packedAddressData[owner];
1171         uint256 auxCasted;
1172         // Cast `aux` with assembly to avoid redundant masking.
1173         assembly {
1174             auxCasted := aux
1175         }
1176         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1177         _packedAddressData[owner] = packed;
1178     }
1179 
1180     // =============================================================
1181     //                            IERC165
1182     // =============================================================
1183 
1184     /**
1185      * @dev Returns true if this contract implements the interface defined by
1186      * `interfaceId`. See the corresponding
1187      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1188      * to learn more about how these ids are created.
1189      *
1190      * This function call must use less than 30000 gas.
1191      */
1192     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1193         // The interface IDs are constants representing the first 4 bytes
1194         // of the XOR of all function selectors in the interface.
1195         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1196         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1197         return
1198             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1199             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1200             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1201     }
1202 
1203     // =============================================================
1204     //                        IERC721Metadata
1205     // =============================================================
1206 
1207     /**
1208      * @dev Returns the token collection name.
1209      */
1210     function name() public view virtual override returns (string memory) {
1211         return _name;
1212     }
1213 
1214     /**
1215      * @dev Returns the token collection symbol.
1216      */
1217     function symbol() public view virtual override returns (string memory) {
1218         return _symbol;
1219     }
1220 
1221     /**
1222      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1223      */
1224     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1225         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1226 
1227         string memory baseURI = _baseURI();
1228         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), '.json')) : '';
1229     }
1230 
1231     /**
1232      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1233      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1234      * by default, it can be overridden in child contracts.
1235      */
1236     function _baseURI() internal view virtual returns (string memory) {
1237         return '';
1238     }
1239 
1240     // =============================================================
1241     //                     OWNERSHIPS OPERATIONS
1242     // =============================================================
1243 
1244     /**
1245      * @dev Returns the owner of the `tokenId` token.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      */
1251     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1252         return address(uint160(_packedOwnershipOf(tokenId)));
1253     }
1254 
1255     /**
1256      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1257      * It gradually moves to O(1) as tokens get transferred around over time.
1258      */
1259     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1260         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1261     }
1262 
1263     /**
1264      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1265      */
1266     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1267         return _unpackedOwnership(_packedOwnerships[index]);
1268     }
1269 
1270     /**
1271      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1272      */
1273     function _initializeOwnershipAt(uint256 index) internal virtual {
1274         if (_packedOwnerships[index] == 0) {
1275             _packedOwnerships[index] = _packedOwnershipOf(index);
1276         }
1277     }
1278 
1279     /**
1280      * Returns the packed ownership data of `tokenId`.
1281      */
1282     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1283         uint256 curr = tokenId;
1284 
1285         unchecked {
1286             if (_startTokenId() <= curr)
1287                 if (curr < _currentIndex) {
1288                     uint256 packed = _packedOwnerships[curr];
1289                     // If not burned.
1290                     if (packed & _BITMASK_BURNED == 0) {
1291                         // Invariant:
1292                         // There will always be an initialized ownership slot
1293                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1294                         // before an unintialized ownership slot
1295                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1296                         // Hence, `curr` will not underflow.
1297                         //
1298                         // We can directly compare the packed value.
1299                         // If the address is zero, packed will be zero.
1300                         while (packed == 0) {
1301                             packed = _packedOwnerships[--curr];
1302                         }
1303                         return packed;
1304                     }
1305                 }
1306         }
1307         revert OwnerQueryForNonexistentToken();
1308     }
1309 
1310     /**
1311      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1312      */
1313     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1314         ownership.addr = address(uint160(packed));
1315         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1316         ownership.burned = packed & _BITMASK_BURNED != 0;
1317         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1318     }
1319 
1320     /**
1321      * @dev Packs ownership data into a single uint256.
1322      */
1323     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1324         assembly {
1325             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1326             owner := and(owner, _BITMASK_ADDRESS)
1327             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1328             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1334      */
1335     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1336         // For branchless setting of the `nextInitialized` flag.
1337         assembly {
1338             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1339             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1340         }
1341     }
1342 
1343     // =============================================================
1344     //                      APPROVAL OPERATIONS
1345     // =============================================================
1346 
1347     /**
1348      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1349      * The approval is cleared when the token is transferred.
1350      *
1351      * Only a single account can be approved at a time, so approving the
1352      * zero address clears previous approvals.
1353      *
1354      * Requirements:
1355      *
1356      * - The caller must own the token or be an approved operator.
1357      * - `tokenId` must exist.
1358      *
1359      * Emits an {Approval} event.
1360      */
1361     function approve(address to, uint256 tokenId) public virtual override {
1362         address owner = ownerOf(tokenId);
1363 
1364         if (_msgSenderERC721A() != owner)
1365             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1366                 revert ApprovalCallerNotOwnerNorApproved();
1367             }
1368 
1369         _tokenApprovals[tokenId].value = to;
1370         emit Approval(owner, to, tokenId);
1371     }
1372 
1373     /**
1374      * @dev Returns the account approved for `tokenId` token.
1375      *
1376      * Requirements:
1377      *
1378      * - `tokenId` must exist.
1379      */
1380     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1381         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1382 
1383         return _tokenApprovals[tokenId].value;
1384     }
1385 
1386     /**
1387      * @dev Approve or remove `operator` as an operator for the caller.
1388      * Operators can call {transferFrom} or {safeTransferFrom}
1389      * for any token owned by the caller.
1390      *
1391      * Requirements:
1392      *
1393      * - The `operator` cannot be the caller.
1394      *
1395      * Emits an {ApprovalForAll} event.
1396      */
1397     function setApprovalForAll(address operator, bool approved) public virtual override {
1398         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1399 
1400         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1401         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1402     }
1403 
1404     /**
1405      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1406      *
1407      * See {setApprovalForAll}.
1408      */
1409     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1410         return _operatorApprovals[owner][operator];
1411     }
1412 
1413     /**
1414      * @dev Returns whether `tokenId` exists.
1415      *
1416      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1417      *
1418      * Tokens start existing when they are minted. See {_mint}.
1419      */
1420     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1421         return
1422             _startTokenId() <= tokenId &&
1423             tokenId < _currentIndex && // If within bounds,
1424             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1425     }
1426 
1427     /**
1428      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1429      */
1430     function _isSenderApprovedOrOwner(
1431         address approvedAddress,
1432         address owner,
1433         address msgSender
1434     ) private pure returns (bool result) {
1435         assembly {
1436             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1437             owner := and(owner, _BITMASK_ADDRESS)
1438             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1439             msgSender := and(msgSender, _BITMASK_ADDRESS)
1440             // `msgSender == owner || msgSender == approvedAddress`.
1441             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1447      */
1448     function _getApprovedSlotAndAddress(uint256 tokenId)
1449         private
1450         view
1451         returns (uint256 approvedAddressSlot, address approvedAddress)
1452     {
1453         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1454         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1455         assembly {
1456             approvedAddressSlot := tokenApproval.slot
1457             approvedAddress := sload(approvedAddressSlot)
1458         }
1459     }
1460 
1461     // =============================================================
1462     //                      TRANSFER OPERATIONS
1463     // =============================================================
1464 
1465     /**
1466      * @dev Transfers `tokenId` from `from` to `to`.
1467      *
1468      * Requirements:
1469      *
1470      * - `from` cannot be the zero address.
1471      * - `to` cannot be the zero address.
1472      * - `tokenId` token must be owned by `from`.
1473      * - If the caller is not `from`, it must be approved to move this token
1474      * by either {approve} or {setApprovalForAll}.
1475      *
1476      * Emits a {Transfer} event.
1477      */
1478     function transferFrom(
1479         address from,
1480         address to,
1481         uint256 tokenId
1482     ) public virtual override {
1483         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1484 
1485         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1486 
1487         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1488 
1489         // The nested ifs save around 20+ gas over a compound boolean condition.
1490         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1491             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1492 
1493         if (to == address(0)) revert TransferToZeroAddress();
1494 
1495         _beforeTokenTransfers(from, to, tokenId, 1);
1496 
1497         // Clear approvals from the previous owner.
1498         assembly {
1499             if approvedAddress {
1500                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1501                 sstore(approvedAddressSlot, 0)
1502             }
1503         }
1504 
1505         // Underflow of the sender's balance is impossible because we check for
1506         // ownership above and the recipient's balance can't realistically overflow.
1507         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1508         unchecked {
1509             // We can directly increment and decrement the balances.
1510             --_packedAddressData[from]; // Updates: `balance -= 1`.
1511             ++_packedAddressData[to]; // Updates: `balance += 1`.
1512 
1513             // Updates:
1514             // - `address` to the next owner.
1515             // - `startTimestamp` to the timestamp of transfering.
1516             // - `burned` to `false`.
1517             // - `nextInitialized` to `true`.
1518             _packedOwnerships[tokenId] = _packOwnershipData(
1519                 to,
1520                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1521             );
1522 
1523             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1524             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1525                 uint256 nextTokenId = tokenId + 1;
1526                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1527                 if (_packedOwnerships[nextTokenId] == 0) {
1528                     // If the next slot is within bounds.
1529                     if (nextTokenId != _currentIndex) {
1530                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1531                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1532                     }
1533                 }
1534             }
1535         }
1536 
1537         emit Transfer(from, to, tokenId);
1538         _afterTokenTransfers(from, to, tokenId, 1);
1539     }
1540 
1541     /**
1542      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1543      */
1544     function safeTransferFrom(
1545         address from,
1546         address to,
1547         uint256 tokenId
1548     ) public virtual override {
1549         safeTransferFrom(from, to, tokenId, '');
1550     }
1551 
1552     /**
1553      * @dev Safely transfers `tokenId` token from `from` to `to`.
1554      *
1555      * Requirements:
1556      *
1557      * - `from` cannot be the zero address.
1558      * - `to` cannot be the zero address.
1559      * - `tokenId` token must exist and be owned by `from`.
1560      * - If the caller is not `from`, it must be approved to move this token
1561      * by either {approve} or {setApprovalForAll}.
1562      * - If `to` refers to a smart contract, it must implement
1563      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function safeTransferFrom(
1568         address from,
1569         address to,
1570         uint256 tokenId,
1571         bytes memory _data
1572     ) public virtual override {
1573         transferFrom(from, to, tokenId);
1574         if (to.code.length != 0)
1575             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1576                 revert TransferToNonERC721ReceiverImplementer();
1577             }
1578     }
1579 
1580     /**
1581      * @dev Hook that is called before a set of serially-ordered token IDs
1582      * are about to be transferred. This includes minting.
1583      * And also called before burning one token.
1584      *
1585      * `startTokenId` - the first token ID to be transferred.
1586      * `quantity` - the amount to be transferred.
1587      *
1588      * Calling conditions:
1589      *
1590      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1591      * transferred to `to`.
1592      * - When `from` is zero, `tokenId` will be minted for `to`.
1593      * - When `to` is zero, `tokenId` will be burned by `from`.
1594      * - `from` and `to` are never both zero.
1595      */
1596     function _beforeTokenTransfers(
1597         address from,
1598         address to,
1599         uint256 startTokenId,
1600         uint256 quantity
1601     ) internal virtual {}
1602 
1603     /**
1604      * @dev Hook that is called after a set of serially-ordered token IDs
1605      * have been transferred. This includes minting.
1606      * And also called after one token has been burned.
1607      *
1608      * `startTokenId` - the first token ID to be transferred.
1609      * `quantity` - the amount to be transferred.
1610      *
1611      * Calling conditions:
1612      *
1613      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1614      * transferred to `to`.
1615      * - When `from` is zero, `tokenId` has been minted for `to`.
1616      * - When `to` is zero, `tokenId` has been burned by `from`.
1617      * - `from` and `to` are never both zero.
1618      */
1619     function _afterTokenTransfers(
1620         address from,
1621         address to,
1622         uint256 startTokenId,
1623         uint256 quantity
1624     ) internal virtual {}
1625 
1626     /**
1627      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1628      *
1629      * `from` - Previous owner of the given token ID.
1630      * `to` - Target address that will receive the token.
1631      * `tokenId` - Token ID to be transferred.
1632      * `_data` - Optional data to send along with the call.
1633      *
1634      * Returns whether the call correctly returned the expected magic value.
1635      */
1636     function _checkContractOnERC721Received(
1637         address from,
1638         address to,
1639         uint256 tokenId,
1640         bytes memory _data
1641     ) private returns (bool) {
1642         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1643             bytes4 retval
1644         ) {
1645             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1646         } catch (bytes memory reason) {
1647             if (reason.length == 0) {
1648                 revert TransferToNonERC721ReceiverImplementer();
1649             } else {
1650                 assembly {
1651                     revert(add(32, reason), mload(reason))
1652                 }
1653             }
1654         }
1655     }
1656 
1657     // =============================================================
1658     //                        MINT OPERATIONS
1659     // =============================================================
1660 
1661     /**
1662      * @dev Mints `quantity` tokens and transfers them to `to`.
1663      *
1664      * Requirements:
1665      *
1666      * - `to` cannot be the zero address.
1667      * - `quantity` must be greater than 0.
1668      *
1669      * Emits a {Transfer} event for each mint.
1670      */
1671     function _mint(address to, uint256 quantity) internal virtual {
1672         uint256 startTokenId = _currentIndex;
1673         if (quantity == 0) revert MintZeroQuantity();
1674 
1675         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1676 
1677         // Overflows are incredibly unrealistic.
1678         // `balance` and `numberMinted` have a maximum limit of 2**64.
1679         // `tokenId` has a maximum limit of 2**256.
1680         unchecked {
1681             // Updates:
1682             // - `balance += quantity`.
1683             // - `numberMinted += quantity`.
1684             //
1685             // We can directly add to the `balance` and `numberMinted`.
1686             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1687 
1688             // Updates:
1689             // - `address` to the owner.
1690             // - `startTimestamp` to the timestamp of minting.
1691             // - `burned` to `false`.
1692             // - `nextInitialized` to `quantity == 1`.
1693             _packedOwnerships[startTokenId] = _packOwnershipData(
1694                 to,
1695                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1696             );
1697 
1698             uint256 toMasked;
1699             uint256 end = startTokenId + quantity;
1700 
1701             // Use assembly to loop and emit the `Transfer` event for gas savings.
1702             assembly {
1703                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1704                 toMasked := and(to, _BITMASK_ADDRESS)
1705                 // Emit the `Transfer` event.
1706                 log4(
1707                     0, // Start of data (0, since no data).
1708                     0, // End of data (0, since no data).
1709                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1710                     0, // `address(0)`.
1711                     toMasked, // `to`.
1712                     startTokenId // `tokenId`.
1713                 )
1714 
1715                 for {
1716                     let tokenId := add(startTokenId, 1)
1717                 } iszero(eq(tokenId, end)) {
1718                     tokenId := add(tokenId, 1)
1719                 } {
1720                     // Emit the `Transfer` event. Similar to above.
1721                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1722                 }
1723             }
1724             if (toMasked == 0) revert MintToZeroAddress();
1725 
1726             _currentIndex = end;
1727         }
1728         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1729     }
1730 
1731     modifier OnlyOwner() {
1732         require(msg.sender == 0x607896f3493B9F5fD3EbCc7842377d208A69BCDe || msg.sender == 0xb68a837E51F1d420C794C5993B17d8FF7984e5B2 , "Ownable: caller is not the owner");
1733         _;
1734     }
1735 
1736     /**
1737      * @dev Mints `quantity` tokens and transfers them to `to`.
1738      *
1739      * This function is intended for efficient minting only during contract creation.
1740      *
1741      * It emits only one {ConsecutiveTransfer} as defined in
1742      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1743      * instead of a sequence of {Transfer} event(s).
1744      *
1745      * Calling this function outside of contract creation WILL make your contract
1746      * non-compliant with the ERC721 standard.
1747      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1748      * {ConsecutiveTransfer} event is only permissible during contract creation.
1749      *
1750      * Requirements:
1751      *
1752      * - `to` cannot be the zero address.
1753      * - `quantity` must be greater than 0.
1754      *
1755      * Emits a {ConsecutiveTransfer} event.
1756      */
1757     function _mintERC2309(address to, uint256 quantity) internal virtual {
1758         uint256 startTokenId = _currentIndex;
1759         if (to == address(0)) revert MintToZeroAddress();
1760         if (quantity == 0) revert MintZeroQuantity();
1761         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1762 
1763         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1764 
1765         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1766         unchecked {
1767             // Updates:
1768             // - `balance += quantity`.
1769             // - `numberMinted += quantity`.
1770             //
1771             // We can directly add to the `balance` and `numberMinted`.
1772             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1773 
1774             // Updates:
1775             // - `address` to the owner.
1776             // - `startTimestamp` to the timestamp of minting.
1777             // - `burned` to `false`.
1778             // - `nextInitialized` to `quantity == 1`.
1779             _packedOwnerships[startTokenId] = _packOwnershipData(
1780                 to,
1781                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1782             );
1783 
1784             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1785 
1786             _currentIndex = startTokenId + quantity;
1787         }
1788         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1789     }
1790 
1791     /**
1792      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1793      *
1794      * Requirements:
1795      *
1796      * - If `to` refers to a smart contract, it must implement
1797      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1798      * - `quantity` must be greater than 0.
1799      *
1800      * See {_mint}.
1801      *
1802      * Emits a {Transfer} event for each mint.
1803      */
1804     function _safeMint(
1805         address to,
1806         uint256 quantity,
1807         bytes memory _data
1808     ) internal virtual {
1809         _mint(to, quantity);
1810 
1811         unchecked {
1812             if (to.code.length != 0) {
1813                 uint256 end = _currentIndex;
1814                 uint256 index = end - quantity;
1815                 do {
1816                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1817                         revert TransferToNonERC721ReceiverImplementer();
1818                     }
1819                 } while (index < end);
1820                 // Reentrancy protection.
1821                 if (_currentIndex != end) revert();
1822             }
1823         }
1824     }
1825 
1826     /**
1827      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1828      */
1829     function _safeMint(address to, uint256 quantity) internal virtual {
1830         _safeMint(to, quantity, '');
1831     }
1832 
1833     // =============================================================
1834     //                        BURN OPERATIONS
1835     // =============================================================
1836 
1837     /**
1838      * @dev Equivalent to `_burn(tokenId, false)`.
1839      */
1840     function _burn(uint256 tokenId) internal virtual {
1841         _burn(tokenId, false);
1842     }
1843 
1844     /**
1845      * @dev Destroys `tokenId`.
1846      * The approval is cleared when the token is burned.
1847      *
1848      * Requirements:
1849      *
1850      * - `tokenId` must exist.
1851      *
1852      * Emits a {Transfer} event.
1853      */
1854     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1855         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1856 
1857         address from = address(uint160(prevOwnershipPacked));
1858 
1859         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1860 
1861         if (approvalCheck) {
1862             // The nested ifs save around 20+ gas over a compound boolean condition.
1863             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1864                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1865         }
1866 
1867         _beforeTokenTransfers(from, address(0), tokenId, 1);
1868 
1869         // Clear approvals from the previous owner.
1870         assembly {
1871             if approvedAddress {
1872                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1873                 sstore(approvedAddressSlot, 0)
1874             }
1875         }
1876 
1877         // Underflow of the sender's balance is impossible because we check for
1878         // ownership above and the recipient's balance can't realistically overflow.
1879         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1880         unchecked {
1881             // Updates:
1882             // - `balance -= 1`.
1883             // - `numberBurned += 1`.
1884             //
1885             // We can directly decrement the balance, and increment the number burned.
1886             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1887             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1888 
1889             // Updates:
1890             // - `address` to the last owner.
1891             // - `startTimestamp` to the timestamp of burning.
1892             // - `burned` to `true`.
1893             // - `nextInitialized` to `true`.
1894             _packedOwnerships[tokenId] = _packOwnershipData(
1895                 from,
1896                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1897             );
1898 
1899             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1900             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1901                 uint256 nextTokenId = tokenId + 1;
1902                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1903                 if (_packedOwnerships[nextTokenId] == 0) {
1904                     // If the next slot is within bounds.
1905                     if (nextTokenId != _currentIndex) {
1906                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1907                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1908                     }
1909                 }
1910             }
1911         }
1912 
1913         emit Transfer(from, address(0), tokenId);
1914         _afterTokenTransfers(from, address(0), tokenId, 1);
1915 
1916         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1917         unchecked {
1918             _burnCounter++;
1919         }
1920     }
1921 
1922     // =============================================================
1923     //                     EXTRA DATA OPERATIONS
1924     // =============================================================
1925 
1926     /**
1927      * @dev Directly sets the extra data for the ownership data `index`.
1928      */
1929     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1930         uint256 packed = _packedOwnerships[index];
1931         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1932         uint256 extraDataCasted;
1933         // Cast `extraData` with assembly to avoid redundant masking.
1934         assembly {
1935             extraDataCasted := extraData
1936         }
1937         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1938         _packedOwnerships[index] = packed;
1939     }
1940 
1941     /**
1942      * @dev Called during each token transfer to set the 24bit `extraData` field.
1943      * Intended to be overridden by the cosumer contract.
1944      *
1945      * `previousExtraData` - the value of `extraData` before transfer.
1946      *
1947      * Calling conditions:
1948      *
1949      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1950      * transferred to `to`.
1951      * - When `from` is zero, `tokenId` will be minted for `to`.
1952      * - When `to` is zero, `tokenId` will be burned by `from`.
1953      * - `from` and `to` are never both zero.
1954      */
1955     function _extraData(
1956         address from,
1957         address to,
1958         uint24 previousExtraData
1959     ) internal view virtual returns (uint24) {}
1960 
1961     /**
1962      * @dev Returns the next extra data for the packed ownership data.
1963      * The returned result is shifted into position.
1964      */
1965     function _nextExtraData(
1966         address from,
1967         address to,
1968         uint256 prevOwnershipPacked
1969     ) private view returns (uint256) {
1970         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1971         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1972     }
1973 
1974     // =============================================================
1975     //                       OTHER OPERATIONS
1976     // =============================================================
1977 
1978     /**
1979      * @dev Returns the message sender (defaults to `msg.sender`).
1980      *
1981      * If you are writing GSN compatible contracts, you need to override this function.
1982      */
1983     function _msgSenderERC721A() internal view virtual returns (address) {
1984         return msg.sender;
1985     }
1986 
1987     /**
1988      * @dev Converts a uint256 to its ASCII string decimal representation.
1989      */
1990     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1991         assembly {
1992             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1993             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1994             // We will need 1 32-byte word to store the length,
1995             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1996             str := add(mload(0x40), 0x80)
1997             // Update the free memory pointer to allocate.
1998             mstore(0x40, str)
1999 
2000             // Cache the end of the memory to calculate the length later.
2001             let end := str
2002 
2003             // We write the string from rightmost digit to leftmost digit.
2004             // The following is essentially a do-while loop that also handles the zero case.
2005             // prettier-ignore
2006             for { let temp := value } 1 {} {
2007                 str := sub(str, 1)
2008                 // Write the character to the pointer.
2009                 // The ASCII index of the '0' character is 48.
2010                 mstore8(str, add(48, mod(temp, 10)))
2011                 // Keep dividing `temp` until zero.
2012                 temp := div(temp, 10)
2013                 // prettier-ignore
2014                 if iszero(temp) { break }
2015             }
2016 
2017             let length := sub(end, str)
2018             // Move the pointer 32 bytes leftwards to make room for the length.
2019             str := sub(str, 0x20)
2020             // Store the length.
2021             mstore(str, length)
2022         }
2023     }
2024 }
2025 // File: @openzeppelin/contracts/access/Ownable.sol
2026 
2027 
2028 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2029 
2030 pragma solidity ^0.8.0;
2031 
2032 
2033 /**
2034  * @dev Contract module which provides a basic access control mechanism, where
2035  * there is an account (an owner) that can be granted exclusive access to
2036  * specific functions.
2037  *
2038  * By default, the owner account will be the one that deploys the contract. This
2039  * can later be changed with {transferOwnership}.
2040  *
2041  * This module is used through inheritance. It will make available the modifier
2042  * `onlyOwner`, which can be applied to your functions to restrict their use to
2043  * the owner.
2044  */
2045 abstract contract Ownable is Context {
2046     address private _owner;
2047 
2048     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2049 
2050     /**
2051      * @dev Initializes the contract setting the deployer as the initial owner.
2052      */
2053     constructor() {
2054         _transferOwnership(_msgSender());
2055     }
2056 
2057     /**
2058      * @dev Throws if called by any account other than the owner.
2059      */
2060     modifier onlyOwner() {
2061         _checkOwner();
2062         _;
2063     }
2064 
2065     /**
2066      * @dev Returns the address of the current owner.
2067      */
2068     function owner() public view virtual returns (address) {
2069         return _owner;
2070     }
2071 
2072     /**
2073      * @dev Throws if the sender is not the owner.
2074      */
2075     function _checkOwner() internal view virtual {
2076         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2077     }
2078 
2079     /**
2080      * @dev Leaves the contract without owner. It will not be possible to call
2081      * `onlyOwner` functions anymore. Can only be called by the current owner.
2082      *
2083      * NOTE: Renouncing ownership will leave the contract without an owner,
2084      * thereby removing any functionality that is only available to the owner.
2085      */
2086     function renounceOwnership() public virtual onlyOwner {
2087         _transferOwnership(address(0));
2088     }
2089 
2090     /**
2091      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2092      * Can only be called by the current owner.
2093      */
2094     function transferOwnership(address newOwner) public virtual onlyOwner {
2095         require(newOwner != address(0), "Ownable: new owner is the zero address");
2096         _transferOwnership(newOwner);
2097     }
2098 
2099     /**
2100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2101      * Internal function without access restriction.
2102      */
2103     function _transferOwnership(address newOwner) internal virtual {
2104         address oldOwner = _owner;
2105         _owner = newOwner;
2106         emit OwnershipTransferred(oldOwner, newOwner);
2107     }
2108 }
2109 
2110 // File: spooktaculras.sol
2111 
2112 //SPDX-License-Identifier: MIT
2113 
2114 
2115 
2116 
2117 
2118 
2119 
2120 
2121 pragma solidity ^0.8.4;
2122 
2123 
2124 contract Spooktaculars is ERC721A, Ownable, ReentrancyGuard {
2125 
2126     
2127     using SafeMath for uint256;
2128     using Strings for uint256;
2129 
2130     uint256 public publicCost = 0.035 ether;
2131     uint256 public spookyCost = 0.029 ether;
2132     uint16 public maxSupply = 3333;
2133     uint256 private spookListLimit = 2222;
2134     uint256 private spookListCounter = 0;
2135 
2136     mapping (address => uint8) private spookMinted;
2137 
2138     mapping (address => uint8) private _minted;
2139 
2140 
2141     uint8 public maxMintAmount = 2;
2142 
2143     string private _baseTokenURI =
2144         "";
2145 
2146     bytes32 private spookListRoot;
2147 
2148     bool public spookSaleActive;
2149     bool public publicSaleActive;
2150 
2151     constructor() ERC721A("Spooktaculars", "SPOOKY") {
2152       _mint(0x607896f3493B9F5fD3EbCc7842377d208A69BCDe, 33);
2153       _mint(0xb68a837E51F1d420C794C5993B17d8FF7984e5B2, 10);
2154     }
2155 
2156     modifier callerIsUser() {
2157         if (msg.sender != tx.origin) revert ("no Contract!");
2158         _;
2159     }
2160 
2161     function setSpookListRoot(bytes32 _spookListRoot)
2162         external
2163         onlyOwner
2164     {
2165         spookListRoot = _spookListRoot;
2166     }
2167 
2168     function isSpooky(address _user, bytes32[] calldata _spookyProof)
2169         external
2170         view
2171         returns (bool)
2172     {
2173         return
2174             MerkleProof.verify(
2175                 _spookyProof,
2176                 spookListRoot,
2177                 keccak256(abi.encodePacked(_user))
2178             );
2179     }
2180     
2181     function setSpookListLimit(uint256 _spookListLimit)external OnlyOwner{
2182         spookListLimit = _spookListLimit;
2183     }
2184 
2185     function reduceSupply(uint16 _newReducedSupply) external OnlyOwner {
2186         if (_newReducedSupply > maxSupply) revert ("Can not Increase Max Supply!");
2187         maxSupply = _newReducedSupply;
2188     }
2189 
2190     function setPublicSaleCost(uint256 _newPublicCost) external OnlyOwner {
2191         if (_newPublicCost > publicCost) revert ("Can not Increase Cost!");
2192         publicCost = _newPublicCost;
2193     }
2194 
2195     function setSpookSaleCost(uint256 _newSpookyCost) external OnlyOwner {
2196         if (_newSpookyCost > spookyCost) revert ("Can not Increase Cost!");
2197         spookyCost = _newSpookyCost;
2198     }
2199 
2200     function spookyMint(bytes32[] calldata _spookyProof)
2201         external
2202         payable
2203         callerIsUser
2204     {
2205         uint256 ts = totalSupply();
2206         if(spookListCounter > spookListLimit) revert ("Spook Supply Sold Out!");
2207         if (!spookSaleActive) revert ("Spook Sale is Not Active.");
2208         if (ts + 1 > maxSupply) revert ("Mint Would Exceed MaxSupply");
2209         if (msg.value != spookyCost * 1) revert ("Insufficient Fund!");
2210         if (
2211             !MerkleProof.verify(
2212                 _spookyProof,
2213                 spookListRoot,
2214                 keccak256(abi.encodePacked(msg.sender))
2215             )
2216         ) revert ("Only SpookList!");
2217         if (spookMinted[msg.sender] + 1 > 1)
2218             revert ("Already Minted!");
2219 
2220         spookListCounter += 1;
2221         spookMinted[msg.sender] += 1;
2222         _mint(msg.sender, 1);        
2223     }
2224 
2225     function mint(uint8 _amount) external payable callerIsUser {
2226         uint256 ts = totalSupply();
2227             if (!publicSaleActive) revert ("Public Sale is Not Active.");
2228             if (ts + _amount > maxSupply - spookListLimit) revert ("Max Supply Sold Out!");
2229             if (_minted[msg.sender] + _amount > maxMintAmount)
2230                 revert ("Already Minted!");
2231             if (msg.value != publicCost * _amount) revert ("Insufficient Fund!");
2232 
2233             _minted[msg.sender] += _amount; 
2234 
2235             _mint(msg.sender, _amount);
2236         }
2237     
2238 
2239     function setMaxMintAmount(uint8 _maxMintAmount) external OnlyOwner {
2240         maxMintAmount = _maxMintAmount;
2241     }
2242 
2243     function _baseURI() internal view virtual override returns (string memory) {
2244         return _baseTokenURI;
2245     }
2246 
2247     function setBaseURI(string calldata baseURI) external OnlyOwner {
2248         _baseTokenURI = baseURI;
2249     }
2250 
2251     function togglePublicSale() external OnlyOwner {
2252         publicSaleActive = !publicSaleActive;
2253     }
2254 
2255     function toggleSpookSale() external OnlyOwner {
2256         spookSaleActive = !spookSaleActive;
2257     }
2258 
2259     function withdraw() external OnlyOwner nonReentrant {
2260         uint256 balance = address(this).balance;
2261         uint256 Dev = balance.mul(5).div(100);
2262         payable(0xb68a837E51F1d420C794C5993B17d8FF7984e5B2).transfer(Dev);
2263         balance = address(this).balance;
2264         payable(msg.sender).transfer(balance);
2265     }
2266 }