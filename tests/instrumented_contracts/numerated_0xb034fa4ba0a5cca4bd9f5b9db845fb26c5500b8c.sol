1 // File: @openzeppelin/contracts/access/IAccessControl.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev These functions deal with verification of Merkle Tree proofs.
101  *
102  * The tree and the proofs can be generated using our
103  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
104  * You will find a quickstart guide in the readme.
105  *
106  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
107  * hashing, or use a hash function other than keccak256 for hashing leaves.
108  * This is because the concatenation of a sorted pair of internal nodes in
109  * the merkle tree could be reinterpreted as a leaf value.
110  * OpenZeppelin's JavaScript library generates merkle trees that are safe
111  * against this attack out of the box.
112  */
113 library MerkleProof {
114     /**
115      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
116      * defined by `root`. For this, a `proof` must be provided, containing
117      * sibling hashes on the branch from the leaf to the root of the tree. Each
118      * pair of leaves and each pair of pre-images are assumed to be sorted.
119      */
120     function verify(
121         bytes32[] memory proof,
122         bytes32 root,
123         bytes32 leaf
124     ) internal pure returns (bool) {
125         return processProof(proof, leaf) == root;
126     }
127 
128     /**
129      * @dev Calldata version of {verify}
130      *
131      * _Available since v4.7._
132      */
133     function verifyCalldata(
134         bytes32[] calldata proof,
135         bytes32 root,
136         bytes32 leaf
137     ) internal pure returns (bool) {
138         return processProofCalldata(proof, leaf) == root;
139     }
140 
141     /**
142      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
143      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
144      * hash matches the root of the tree. When processing the proof, the pairs
145      * of leafs & pre-images are assumed to be sorted.
146      *
147      * _Available since v4.4._
148      */
149     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
150         bytes32 computedHash = leaf;
151         for (uint256 i = 0; i < proof.length; i++) {
152             computedHash = _hashPair(computedHash, proof[i]);
153         }
154         return computedHash;
155     }
156 
157     /**
158      * @dev Calldata version of {processProof}
159      *
160      * _Available since v4.7._
161      */
162     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
163         bytes32 computedHash = leaf;
164         for (uint256 i = 0; i < proof.length; i++) {
165             computedHash = _hashPair(computedHash, proof[i]);
166         }
167         return computedHash;
168     }
169 
170     /**
171      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
172      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
173      *
174      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
175      *
176      * _Available since v4.7._
177      */
178     function multiProofVerify(
179         bytes32[] memory proof,
180         bool[] memory proofFlags,
181         bytes32 root,
182         bytes32[] memory leaves
183     ) internal pure returns (bool) {
184         return processMultiProof(proof, proofFlags, leaves) == root;
185     }
186 
187     /**
188      * @dev Calldata version of {multiProofVerify}
189      *
190      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
191      *
192      * _Available since v4.7._
193      */
194     function multiProofVerifyCalldata(
195         bytes32[] calldata proof,
196         bool[] calldata proofFlags,
197         bytes32 root,
198         bytes32[] memory leaves
199     ) internal pure returns (bool) {
200         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
201     }
202 
203     /**
204      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
205      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
206      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
207      * respectively.
208      *
209      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
210      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
211      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
212      *
213      * _Available since v4.7._
214      */
215     function processMultiProof(
216         bytes32[] memory proof,
217         bool[] memory proofFlags,
218         bytes32[] memory leaves
219     ) internal pure returns (bytes32 merkleRoot) {
220         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
221         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
222         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
223         // the merkle tree.
224         uint256 leavesLen = leaves.length;
225         uint256 totalHashes = proofFlags.length;
226 
227         // Check proof validity.
228         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
229 
230         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
231         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
232         bytes32[] memory hashes = new bytes32[](totalHashes);
233         uint256 leafPos = 0;
234         uint256 hashPos = 0;
235         uint256 proofPos = 0;
236         // At each step, we compute the next hash using two values:
237         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
238         //   get the next hash.
239         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
240         //   `proof` array.
241         for (uint256 i = 0; i < totalHashes; i++) {
242             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
243             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
244             hashes[i] = _hashPair(a, b);
245         }
246 
247         if (totalHashes > 0) {
248             return hashes[totalHashes - 1];
249         } else if (leavesLen > 0) {
250             return leaves[0];
251         } else {
252             return proof[0];
253         }
254     }
255 
256     /**
257      * @dev Calldata version of {processMultiProof}.
258      *
259      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
260      *
261      * _Available since v4.7._
262      */
263     function processMultiProofCalldata(
264         bytes32[] calldata proof,
265         bool[] calldata proofFlags,
266         bytes32[] memory leaves
267     ) internal pure returns (bytes32 merkleRoot) {
268         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
269         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
270         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
271         // the merkle tree.
272         uint256 leavesLen = leaves.length;
273         uint256 totalHashes = proofFlags.length;
274 
275         // Check proof validity.
276         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
277 
278         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
279         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
280         bytes32[] memory hashes = new bytes32[](totalHashes);
281         uint256 leafPos = 0;
282         uint256 hashPos = 0;
283         uint256 proofPos = 0;
284         // At each step, we compute the next hash using two values:
285         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
286         //   get the next hash.
287         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
288         //   `proof` array.
289         for (uint256 i = 0; i < totalHashes; i++) {
290             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
291             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
292             hashes[i] = _hashPair(a, b);
293         }
294 
295         if (totalHashes > 0) {
296             return hashes[totalHashes - 1];
297         } else if (leavesLen > 0) {
298             return leaves[0];
299         } else {
300             return proof[0];
301         }
302     }
303 
304     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
305         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
306     }
307 
308     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
309         /// @solidity memory-safe-assembly
310         assembly {
311             mstore(0x00, a)
312             mstore(0x20, b)
313             value := keccak256(0x00, 0x40)
314         }
315     }
316 }
317 
318 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
319 
320 
321 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Contract module that helps prevent reentrant calls to a function.
327  *
328  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
329  * available, which can be applied to functions to make sure there are no nested
330  * (reentrant) calls to them.
331  *
332  * Note that because there is a single `nonReentrant` guard, functions marked as
333  * `nonReentrant` may not call one another. This can be worked around by making
334  * those functions `private`, and then adding `external` `nonReentrant` entry
335  * points to them.
336  *
337  * TIP: If you would like to learn more about reentrancy and alternative ways
338  * to protect against it, check out our blog post
339  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
340  */
341 abstract contract ReentrancyGuard {
342     // Booleans are more expensive than uint256 or any type that takes up a full
343     // word because each write operation emits an extra SLOAD to first read the
344     // slot's contents, replace the bits taken up by the boolean, and then write
345     // back. This is the compiler's defense against contract upgrades and
346     // pointer aliasing, and it cannot be disabled.
347 
348     // The values being non-zero value makes deployment a bit more expensive,
349     // but in exchange the refund on every call to nonReentrant will be lower in
350     // amount. Since refunds are capped to a percentage of the total
351     // transaction's gas, it is best to keep them low in cases like this one, to
352     // increase the likelihood of the full refund coming into effect.
353     uint256 private constant _NOT_ENTERED = 1;
354     uint256 private constant _ENTERED = 2;
355 
356     uint256 private _status;
357 
358     constructor() {
359         _status = _NOT_ENTERED;
360     }
361 
362     /**
363      * @dev Prevents a contract from calling itself, directly or indirectly.
364      * Calling a `nonReentrant` function from another `nonReentrant`
365      * function is not supported. It is possible to prevent this from happening
366      * by making the `nonReentrant` function external, and making it call a
367      * `private` function that does the actual work.
368      */
369     modifier nonReentrant() {
370         _nonReentrantBefore();
371         _;
372         _nonReentrantAfter();
373     }
374 
375     function _nonReentrantBefore() private {
376         // On the first call to nonReentrant, _status will be _NOT_ENTERED
377         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
378 
379         // Any calls to nonReentrant after this point will fail
380         _status = _ENTERED;
381     }
382 
383     function _nonReentrantAfter() private {
384         // By storing the original value once again, a refund is triggered (see
385         // https://eips.ethereum.org/EIPS/eip-2200)
386         _status = _NOT_ENTERED;
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/math/Math.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Standard math utilities missing in the Solidity language.
399  */
400 library Math {
401     enum Rounding {
402         Down, // Toward negative infinity
403         Up, // Toward infinity
404         Zero // Toward zero
405     }
406 
407     /**
408      * @dev Returns the largest of two numbers.
409      */
410     function max(uint256 a, uint256 b) internal pure returns (uint256) {
411         return a > b ? a : b;
412     }
413 
414     /**
415      * @dev Returns the smallest of two numbers.
416      */
417     function min(uint256 a, uint256 b) internal pure returns (uint256) {
418         return a < b ? a : b;
419     }
420 
421     /**
422      * @dev Returns the average of two numbers. The result is rounded towards
423      * zero.
424      */
425     function average(uint256 a, uint256 b) internal pure returns (uint256) {
426         // (a + b) / 2 can overflow.
427         return (a & b) + (a ^ b) / 2;
428     }
429 
430     /**
431      * @dev Returns the ceiling of the division of two numbers.
432      *
433      * This differs from standard division with `/` in that it rounds up instead
434      * of rounding down.
435      */
436     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
437         // (a + b - 1) / b can overflow on addition, so we distribute.
438         return a == 0 ? 0 : (a - 1) / b + 1;
439     }
440 
441     /**
442      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
443      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
444      * with further edits by Uniswap Labs also under MIT license.
445      */
446     function mulDiv(
447         uint256 x,
448         uint256 y,
449         uint256 denominator
450     ) internal pure returns (uint256 result) {
451         unchecked {
452             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
453             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
454             // variables such that product = prod1 * 2^256 + prod0.
455             uint256 prod0; // Least significant 256 bits of the product
456             uint256 prod1; // Most significant 256 bits of the product
457             assembly {
458                 let mm := mulmod(x, y, not(0))
459                 prod0 := mul(x, y)
460                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
461             }
462 
463             // Handle non-overflow cases, 256 by 256 division.
464             if (prod1 == 0) {
465                 return prod0 / denominator;
466             }
467 
468             // Make sure the result is less than 2^256. Also prevents denominator == 0.
469             require(denominator > prod1);
470 
471             ///////////////////////////////////////////////
472             // 512 by 256 division.
473             ///////////////////////////////////////////////
474 
475             // Make division exact by subtracting the remainder from [prod1 prod0].
476             uint256 remainder;
477             assembly {
478                 // Compute remainder using mulmod.
479                 remainder := mulmod(x, y, denominator)
480 
481                 // Subtract 256 bit number from 512 bit number.
482                 prod1 := sub(prod1, gt(remainder, prod0))
483                 prod0 := sub(prod0, remainder)
484             }
485 
486             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
487             // See https://cs.stackexchange.com/q/138556/92363.
488 
489             // Does not overflow because the denominator cannot be zero at this stage in the function.
490             uint256 twos = denominator & (~denominator + 1);
491             assembly {
492                 // Divide denominator by twos.
493                 denominator := div(denominator, twos)
494 
495                 // Divide [prod1 prod0] by twos.
496                 prod0 := div(prod0, twos)
497 
498                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
499                 twos := add(div(sub(0, twos), twos), 1)
500             }
501 
502             // Shift in bits from prod1 into prod0.
503             prod0 |= prod1 * twos;
504 
505             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
506             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
507             // four bits. That is, denominator * inv = 1 mod 2^4.
508             uint256 inverse = (3 * denominator) ^ 2;
509 
510             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
511             // in modular arithmetic, doubling the correct bits in each step.
512             inverse *= 2 - denominator * inverse; // inverse mod 2^8
513             inverse *= 2 - denominator * inverse; // inverse mod 2^16
514             inverse *= 2 - denominator * inverse; // inverse mod 2^32
515             inverse *= 2 - denominator * inverse; // inverse mod 2^64
516             inverse *= 2 - denominator * inverse; // inverse mod 2^128
517             inverse *= 2 - denominator * inverse; // inverse mod 2^256
518 
519             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
520             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
521             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
522             // is no longer required.
523             result = prod0 * inverse;
524             return result;
525         }
526     }
527 
528     /**
529      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
530      */
531     function mulDiv(
532         uint256 x,
533         uint256 y,
534         uint256 denominator,
535         Rounding rounding
536     ) internal pure returns (uint256) {
537         uint256 result = mulDiv(x, y, denominator);
538         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
539             result += 1;
540         }
541         return result;
542     }
543 
544     /**
545      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
546      *
547      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
548      */
549     function sqrt(uint256 a) internal pure returns (uint256) {
550         if (a == 0) {
551             return 0;
552         }
553 
554         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
555         //
556         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
557         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
558         //
559         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
560         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
561         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
562         //
563         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
564         uint256 result = 1 << (log2(a) >> 1);
565 
566         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
567         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
568         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
569         // into the expected uint128 result.
570         unchecked {
571             result = (result + a / result) >> 1;
572             result = (result + a / result) >> 1;
573             result = (result + a / result) >> 1;
574             result = (result + a / result) >> 1;
575             result = (result + a / result) >> 1;
576             result = (result + a / result) >> 1;
577             result = (result + a / result) >> 1;
578             return min(result, a / result);
579         }
580     }
581 
582     /**
583      * @notice Calculates sqrt(a), following the selected rounding direction.
584      */
585     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
586         unchecked {
587             uint256 result = sqrt(a);
588             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
589         }
590     }
591 
592     /**
593      * @dev Return the log in base 2, rounded down, of a positive value.
594      * Returns 0 if given 0.
595      */
596     function log2(uint256 value) internal pure returns (uint256) {
597         uint256 result = 0;
598         unchecked {
599             if (value >> 128 > 0) {
600                 value >>= 128;
601                 result += 128;
602             }
603             if (value >> 64 > 0) {
604                 value >>= 64;
605                 result += 64;
606             }
607             if (value >> 32 > 0) {
608                 value >>= 32;
609                 result += 32;
610             }
611             if (value >> 16 > 0) {
612                 value >>= 16;
613                 result += 16;
614             }
615             if (value >> 8 > 0) {
616                 value >>= 8;
617                 result += 8;
618             }
619             if (value >> 4 > 0) {
620                 value >>= 4;
621                 result += 4;
622             }
623             if (value >> 2 > 0) {
624                 value >>= 2;
625                 result += 2;
626             }
627             if (value >> 1 > 0) {
628                 result += 1;
629             }
630         }
631         return result;
632     }
633 
634     /**
635      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
636      * Returns 0 if given 0.
637      */
638     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
639         unchecked {
640             uint256 result = log2(value);
641             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
642         }
643     }
644 
645     /**
646      * @dev Return the log in base 10, rounded down, of a positive value.
647      * Returns 0 if given 0.
648      */
649     function log10(uint256 value) internal pure returns (uint256) {
650         uint256 result = 0;
651         unchecked {
652             if (value >= 10**64) {
653                 value /= 10**64;
654                 result += 64;
655             }
656             if (value >= 10**32) {
657                 value /= 10**32;
658                 result += 32;
659             }
660             if (value >= 10**16) {
661                 value /= 10**16;
662                 result += 16;
663             }
664             if (value >= 10**8) {
665                 value /= 10**8;
666                 result += 8;
667             }
668             if (value >= 10**4) {
669                 value /= 10**4;
670                 result += 4;
671             }
672             if (value >= 10**2) {
673                 value /= 10**2;
674                 result += 2;
675             }
676             if (value >= 10**1) {
677                 result += 1;
678             }
679         }
680         return result;
681     }
682 
683     /**
684      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
685      * Returns 0 if given 0.
686      */
687     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
688         unchecked {
689             uint256 result = log10(value);
690             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
691         }
692     }
693 
694     /**
695      * @dev Return the log in base 256, rounded down, of a positive value.
696      * Returns 0 if given 0.
697      *
698      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
699      */
700     function log256(uint256 value) internal pure returns (uint256) {
701         uint256 result = 0;
702         unchecked {
703             if (value >> 128 > 0) {
704                 value >>= 128;
705                 result += 16;
706             }
707             if (value >> 64 > 0) {
708                 value >>= 64;
709                 result += 8;
710             }
711             if (value >> 32 > 0) {
712                 value >>= 32;
713                 result += 4;
714             }
715             if (value >> 16 > 0) {
716                 value >>= 16;
717                 result += 2;
718             }
719             if (value >> 8 > 0) {
720                 result += 1;
721             }
722         }
723         return result;
724     }
725 
726     /**
727      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
728      * Returns 0 if given 0.
729      */
730     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
731         unchecked {
732             uint256 result = log256(value);
733             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
734         }
735     }
736 }
737 
738 // File: @openzeppelin/contracts/utils/Strings.sol
739 
740 
741 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @dev String operations.
748  */
749 library Strings {
750     bytes16 private constant _SYMBOLS = "0123456789abcdef";
751     uint8 private constant _ADDRESS_LENGTH = 20;
752 
753     /**
754      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
755      */
756     function toString(uint256 value) internal pure returns (string memory) {
757         unchecked {
758             uint256 length = Math.log10(value) + 1;
759             string memory buffer = new string(length);
760             uint256 ptr;
761             /// @solidity memory-safe-assembly
762             assembly {
763                 ptr := add(buffer, add(32, length))
764             }
765             while (true) {
766                 ptr--;
767                 /// @solidity memory-safe-assembly
768                 assembly {
769                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
770                 }
771                 value /= 10;
772                 if (value == 0) break;
773             }
774             return buffer;
775         }
776     }
777 
778     /**
779      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
780      */
781     function toHexString(uint256 value) internal pure returns (string memory) {
782         unchecked {
783             return toHexString(value, Math.log256(value) + 1);
784         }
785     }
786 
787     /**
788      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
789      */
790     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
791         bytes memory buffer = new bytes(2 * length + 2);
792         buffer[0] = "0";
793         buffer[1] = "x";
794         for (uint256 i = 2 * length + 1; i > 1; --i) {
795             buffer[i] = _SYMBOLS[value & 0xf];
796             value >>= 4;
797         }
798         require(value == 0, "Strings: hex length insufficient");
799         return string(buffer);
800     }
801 
802     /**
803      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
804      */
805     function toHexString(address addr) internal pure returns (string memory) {
806         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
807     }
808 }
809 
810 // File: @openzeppelin/contracts/utils/Context.sol
811 
812 
813 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
814 
815 pragma solidity ^0.8.0;
816 
817 /**
818  * @dev Provides information about the current execution context, including the
819  * sender of the transaction and its data. While these are generally available
820  * via msg.sender and msg.data, they should not be accessed in such a direct
821  * manner, since when dealing with meta-transactions the account sending and
822  * paying for execution may not be the actual sender (as far as an application
823  * is concerned).
824  *
825  * This contract is only required for intermediate, library-like contracts.
826  */
827 abstract contract Context {
828     function _msgSender() internal view virtual returns (address) {
829         return msg.sender;
830     }
831 
832     function _msgData() internal view virtual returns (bytes calldata) {
833         return msg.data;
834     }
835 }
836 
837 // File: @openzeppelin/contracts/utils/Address.sol
838 
839 
840 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
841 
842 pragma solidity ^0.8.1;
843 
844 /**
845  * @dev Collection of functions related to the address type
846  */
847 library Address {
848     /**
849      * @dev Returns true if `account` is a contract.
850      *
851      * [IMPORTANT]
852      * ====
853      * It is unsafe to assume that an address for which this function returns
854      * false is an externally-owned account (EOA) and not a contract.
855      *
856      * Among others, `isContract` will return false for the following
857      * types of addresses:
858      *
859      *  - an externally-owned account
860      *  - a contract in construction
861      *  - an address where a contract will be created
862      *  - an address where a contract lived, but was destroyed
863      * ====
864      *
865      * [IMPORTANT]
866      * ====
867      * You shouldn't rely on `isContract` to protect against flash loan attacks!
868      *
869      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
870      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
871      * constructor.
872      * ====
873      */
874     function isContract(address account) internal view returns (bool) {
875         // This method relies on extcodesize/address.code.length, which returns 0
876         // for contracts in construction, since the code is only stored at the end
877         // of the constructor execution.
878 
879         return account.code.length > 0;
880     }
881 
882     /**
883      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
884      * `recipient`, forwarding all available gas and reverting on errors.
885      *
886      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
887      * of certain opcodes, possibly making contracts go over the 2300 gas limit
888      * imposed by `transfer`, making them unable to receive funds via
889      * `transfer`. {sendValue} removes this limitation.
890      *
891      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
892      *
893      * IMPORTANT: because control is transferred to `recipient`, care must be
894      * taken to not create reentrancy vulnerabilities. Consider using
895      * {ReentrancyGuard} or the
896      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
897      */
898     function sendValue(address payable recipient, uint256 amount) internal {
899         require(address(this).balance >= amount, "Address: insufficient balance");
900 
901         (bool success, ) = recipient.call{value: amount}("");
902         require(success, "Address: unable to send value, recipient may have reverted");
903     }
904 
905     /**
906      * @dev Performs a Solidity function call using a low level `call`. A
907      * plain `call` is an unsafe replacement for a function call: use this
908      * function instead.
909      *
910      * If `target` reverts with a revert reason, it is bubbled up by this
911      * function (like regular Solidity function calls).
912      *
913      * Returns the raw returned data. To convert to the expected return value,
914      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
915      *
916      * Requirements:
917      *
918      * - `target` must be a contract.
919      * - calling `target` with `data` must not revert.
920      *
921      * _Available since v3.1._
922      */
923     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
924         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
925     }
926 
927     /**
928      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
929      * `errorMessage` as a fallback revert reason when `target` reverts.
930      *
931      * _Available since v3.1._
932      */
933     function functionCall(
934         address target,
935         bytes memory data,
936         string memory errorMessage
937     ) internal returns (bytes memory) {
938         return functionCallWithValue(target, data, 0, errorMessage);
939     }
940 
941     /**
942      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
943      * but also transferring `value` wei to `target`.
944      *
945      * Requirements:
946      *
947      * - the calling contract must have an ETH balance of at least `value`.
948      * - the called Solidity function must be `payable`.
949      *
950      * _Available since v3.1._
951      */
952     function functionCallWithValue(
953         address target,
954         bytes memory data,
955         uint256 value
956     ) internal returns (bytes memory) {
957         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
958     }
959 
960     /**
961      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
962      * with `errorMessage` as a fallback revert reason when `target` reverts.
963      *
964      * _Available since v3.1._
965      */
966     function functionCallWithValue(
967         address target,
968         bytes memory data,
969         uint256 value,
970         string memory errorMessage
971     ) internal returns (bytes memory) {
972         require(address(this).balance >= value, "Address: insufficient balance for call");
973         (bool success, bytes memory returndata) = target.call{value: value}(data);
974         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
975     }
976 
977     /**
978      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
979      * but performing a static call.
980      *
981      * _Available since v3.3._
982      */
983     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
984         return functionStaticCall(target, data, "Address: low-level static call failed");
985     }
986 
987     /**
988      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
989      * but performing a static call.
990      *
991      * _Available since v3.3._
992      */
993     function functionStaticCall(
994         address target,
995         bytes memory data,
996         string memory errorMessage
997     ) internal view returns (bytes memory) {
998         (bool success, bytes memory returndata) = target.staticcall(data);
999         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1000     }
1001 
1002     /**
1003      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1004      * but performing a delegate call.
1005      *
1006      * _Available since v3.4._
1007      */
1008     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1009         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1010     }
1011 
1012     /**
1013      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1014      * but performing a delegate call.
1015      *
1016      * _Available since v3.4._
1017      */
1018     function functionDelegateCall(
1019         address target,
1020         bytes memory data,
1021         string memory errorMessage
1022     ) internal returns (bytes memory) {
1023         (bool success, bytes memory returndata) = target.delegatecall(data);
1024         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1025     }
1026 
1027     /**
1028      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1029      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1030      *
1031      * _Available since v4.8._
1032      */
1033     function verifyCallResultFromTarget(
1034         address target,
1035         bool success,
1036         bytes memory returndata,
1037         string memory errorMessage
1038     ) internal view returns (bytes memory) {
1039         if (success) {
1040             if (returndata.length == 0) {
1041                 // only check isContract if the call was successful and the return data is empty
1042                 // otherwise we already know that it was a contract
1043                 require(isContract(target), "Address: call to non-contract");
1044             }
1045             return returndata;
1046         } else {
1047             _revert(returndata, errorMessage);
1048         }
1049     }
1050 
1051     /**
1052      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1053      * revert reason or using the provided one.
1054      *
1055      * _Available since v4.3._
1056      */
1057     function verifyCallResult(
1058         bool success,
1059         bytes memory returndata,
1060         string memory errorMessage
1061     ) internal pure returns (bytes memory) {
1062         if (success) {
1063             return returndata;
1064         } else {
1065             _revert(returndata, errorMessage);
1066         }
1067     }
1068 
1069     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1070         // Look for revert reason and bubble it up if present
1071         if (returndata.length > 0) {
1072             // The easiest way to bubble the revert reason is using memory via assembly
1073             /// @solidity memory-safe-assembly
1074             assembly {
1075                 let returndata_size := mload(returndata)
1076                 revert(add(32, returndata), returndata_size)
1077             }
1078         } else {
1079             revert(errorMessage);
1080         }
1081     }
1082 }
1083 
1084 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1085 
1086 
1087 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1088 
1089 pragma solidity ^0.8.0;
1090 
1091 /**
1092  * @title ERC721 token receiver interface
1093  * @dev Interface for any contract that wants to support safeTransfers
1094  * from ERC721 asset contracts.
1095  */
1096 interface IERC721Receiver {
1097     /**
1098      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1099      * by `operator` from `from`, this function is called.
1100      *
1101      * It must return its Solidity selector to confirm the token transfer.
1102      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1103      *
1104      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1105      */
1106     function onERC721Received(
1107         address operator,
1108         address from,
1109         uint256 tokenId,
1110         bytes calldata data
1111     ) external returns (bytes4);
1112 }
1113 
1114 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1115 
1116 
1117 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 /**
1122  * @dev Interface of the ERC165 standard, as defined in the
1123  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1124  *
1125  * Implementers can declare support of contract interfaces, which can then be
1126  * queried by others ({ERC165Checker}).
1127  *
1128  * For an implementation, see {ERC165}.
1129  */
1130 interface IERC165 {
1131     /**
1132      * @dev Returns true if this contract implements the interface defined by
1133      * `interfaceId`. See the corresponding
1134      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1135      * to learn more about how these ids are created.
1136      *
1137      * This function call must use less than 30 000 gas.
1138      */
1139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1140 }
1141 
1142 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1143 
1144 
1145 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 /**
1151  * @dev Implementation of the {IERC165} interface.
1152  *
1153  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1154  * for the additional interface id that will be supported. For example:
1155  *
1156  * ```solidity
1157  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1158  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1159  * }
1160  * ```
1161  *
1162  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1163  */
1164 abstract contract ERC165 is IERC165 {
1165     /**
1166      * @dev See {IERC165-supportsInterface}.
1167      */
1168     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1169         return interfaceId == type(IERC165).interfaceId;
1170     }
1171 }
1172 
1173 // File: @openzeppelin/contracts/access/AccessControl.sol
1174 
1175 
1176 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 
1182 
1183 
1184 /**
1185  * @dev Contract module that allows children to implement role-based access
1186  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1187  * members except through off-chain means by accessing the contract event logs. Some
1188  * applications may benefit from on-chain enumerability, for those cases see
1189  * {AccessControlEnumerable}.
1190  *
1191  * Roles are referred to by their `bytes32` identifier. These should be exposed
1192  * in the external API and be unique. The best way to achieve this is by
1193  * using `public constant` hash digests:
1194  *
1195  * ```
1196  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1197  * ```
1198  *
1199  * Roles can be used to represent a set of permissions. To restrict access to a
1200  * function call, use {hasRole}:
1201  *
1202  * ```
1203  * function foo() public {
1204  *     require(hasRole(MY_ROLE, msg.sender));
1205  *     ...
1206  * }
1207  * ```
1208  *
1209  * Roles can be granted and revoked dynamically via the {grantRole} and
1210  * {revokeRole} functions. Each role has an associated admin role, and only
1211  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1212  *
1213  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1214  * that only accounts with this role will be able to grant or revoke other
1215  * roles. More complex role relationships can be created by using
1216  * {_setRoleAdmin}.
1217  *
1218  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1219  * grant and revoke this role. Extra precautions should be taken to secure
1220  * accounts that have been granted it.
1221  */
1222 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1223     struct RoleData {
1224         mapping(address => bool) members;
1225         bytes32 adminRole;
1226     }
1227 
1228     mapping(bytes32 => RoleData) private _roles;
1229 
1230     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1231 
1232     /**
1233      * @dev Modifier that checks that an account has a specific role. Reverts
1234      * with a standardized message including the required role.
1235      *
1236      * The format of the revert reason is given by the following regular expression:
1237      *
1238      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1239      *
1240      * _Available since v4.1._
1241      */
1242     modifier onlyRole(bytes32 role) {
1243         _checkRole(role);
1244         _;
1245     }
1246 
1247     /**
1248      * @dev See {IERC165-supportsInterface}.
1249      */
1250     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1251         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1252     }
1253 
1254     /**
1255      * @dev Returns `true` if `account` has been granted `role`.
1256      */
1257     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1258         return _roles[role].members[account];
1259     }
1260 
1261     /**
1262      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1263      * Overriding this function changes the behavior of the {onlyRole} modifier.
1264      *
1265      * Format of the revert message is described in {_checkRole}.
1266      *
1267      * _Available since v4.6._
1268      */
1269     function _checkRole(bytes32 role) internal view virtual {
1270         _checkRole(role, _msgSender());
1271     }
1272 
1273     /**
1274      * @dev Revert with a standard message if `account` is missing `role`.
1275      *
1276      * The format of the revert reason is given by the following regular expression:
1277      *
1278      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1279      */
1280     function _checkRole(bytes32 role, address account) internal view virtual {
1281         if (!hasRole(role, account)) {
1282             revert(
1283                 string(
1284                     abi.encodePacked(
1285                         "AccessControl: account ",
1286                         Strings.toHexString(account),
1287                         " is missing role ",
1288                         Strings.toHexString(uint256(role), 32)
1289                     )
1290                 )
1291             );
1292         }
1293     }
1294 
1295     /**
1296      * @dev Returns the admin role that controls `role`. See {grantRole} and
1297      * {revokeRole}.
1298      *
1299      * To change a role's admin, use {_setRoleAdmin}.
1300      */
1301     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1302         return _roles[role].adminRole;
1303     }
1304 
1305     /**
1306      * @dev Grants `role` to `account`.
1307      *
1308      * If `account` had not been already granted `role`, emits a {RoleGranted}
1309      * event.
1310      *
1311      * Requirements:
1312      *
1313      * - the caller must have ``role``'s admin role.
1314      *
1315      * May emit a {RoleGranted} event.
1316      */
1317     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1318         _grantRole(role, account);
1319     }
1320 
1321     /**
1322      * @dev Revokes `role` from `account`.
1323      *
1324      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1325      *
1326      * Requirements:
1327      *
1328      * - the caller must have ``role``'s admin role.
1329      *
1330      * May emit a {RoleRevoked} event.
1331      */
1332     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1333         _revokeRole(role, account);
1334     }
1335 
1336     /**
1337      * @dev Revokes `role` from the calling account.
1338      *
1339      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1340      * purpose is to provide a mechanism for accounts to lose their privileges
1341      * if they are compromised (such as when a trusted device is misplaced).
1342      *
1343      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1344      * event.
1345      *
1346      * Requirements:
1347      *
1348      * - the caller must be `account`.
1349      *
1350      * May emit a {RoleRevoked} event.
1351      */
1352     function renounceRole(bytes32 role, address account) public virtual override {
1353         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1354 
1355         _revokeRole(role, account);
1356     }
1357 
1358     /**
1359      * @dev Grants `role` to `account`.
1360      *
1361      * If `account` had not been already granted `role`, emits a {RoleGranted}
1362      * event. Note that unlike {grantRole}, this function doesn't perform any
1363      * checks on the calling account.
1364      *
1365      * May emit a {RoleGranted} event.
1366      *
1367      * [WARNING]
1368      * ====
1369      * This function should only be called from the constructor when setting
1370      * up the initial roles for the system.
1371      *
1372      * Using this function in any other way is effectively circumventing the admin
1373      * system imposed by {AccessControl}.
1374      * ====
1375      *
1376      * NOTE: This function is deprecated in favor of {_grantRole}.
1377      */
1378     function _setupRole(bytes32 role, address account) internal virtual {
1379         _grantRole(role, account);
1380     }
1381 
1382     /**
1383      * @dev Sets `adminRole` as ``role``'s admin role.
1384      *
1385      * Emits a {RoleAdminChanged} event.
1386      */
1387     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1388         bytes32 previousAdminRole = getRoleAdmin(role);
1389         _roles[role].adminRole = adminRole;
1390         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1391     }
1392 
1393     /**
1394      * @dev Grants `role` to `account`.
1395      *
1396      * Internal function without access restriction.
1397      *
1398      * May emit a {RoleGranted} event.
1399      */
1400     function _grantRole(bytes32 role, address account) internal virtual {
1401         if (!hasRole(role, account)) {
1402             _roles[role].members[account] = true;
1403             emit RoleGranted(role, account, _msgSender());
1404         }
1405     }
1406 
1407     /**
1408      * @dev Revokes `role` from `account`.
1409      *
1410      * Internal function without access restriction.
1411      *
1412      * May emit a {RoleRevoked} event.
1413      */
1414     function _revokeRole(bytes32 role, address account) internal virtual {
1415         if (hasRole(role, account)) {
1416             _roles[role].members[account] = false;
1417             emit RoleRevoked(role, account, _msgSender());
1418         }
1419     }
1420 }
1421 
1422 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1423 
1424 
1425 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1426 
1427 pragma solidity ^0.8.0;
1428 
1429 
1430 /**
1431  * @dev Required interface of an ERC721 compliant contract.
1432  */
1433 interface IERC721 is IERC165 {
1434     /**
1435      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1436      */
1437     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1438 
1439     /**
1440      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1441      */
1442     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1443 
1444     /**
1445      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1446      */
1447     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1448 
1449     /**
1450      * @dev Returns the number of tokens in ``owner``'s account.
1451      */
1452     function balanceOf(address owner) external view returns (uint256 balance);
1453 
1454     /**
1455      * @dev Returns the owner of the `tokenId` token.
1456      *
1457      * Requirements:
1458      *
1459      * - `tokenId` must exist.
1460      */
1461     function ownerOf(uint256 tokenId) external view returns (address owner);
1462 
1463     /**
1464      * @dev Safely transfers `tokenId` token from `from` to `to`.
1465      *
1466      * Requirements:
1467      *
1468      * - `from` cannot be the zero address.
1469      * - `to` cannot be the zero address.
1470      * - `tokenId` token must exist and be owned by `from`.
1471      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1472      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1473      *
1474      * Emits a {Transfer} event.
1475      */
1476     function safeTransferFrom(
1477         address from,
1478         address to,
1479         uint256 tokenId,
1480         bytes calldata data
1481     ) external;
1482 
1483     /**
1484      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1485      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1486      *
1487      * Requirements:
1488      *
1489      * - `from` cannot be the zero address.
1490      * - `to` cannot be the zero address.
1491      * - `tokenId` token must exist and be owned by `from`.
1492      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1494      *
1495      * Emits a {Transfer} event.
1496      */
1497     function safeTransferFrom(
1498         address from,
1499         address to,
1500         uint256 tokenId
1501     ) external;
1502 
1503     /**
1504      * @dev Transfers `tokenId` token from `from` to `to`.
1505      *
1506      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1507      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1508      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1509      *
1510      * Requirements:
1511      *
1512      * - `from` cannot be the zero address.
1513      * - `to` cannot be the zero address.
1514      * - `tokenId` token must be owned by `from`.
1515      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1516      *
1517      * Emits a {Transfer} event.
1518      */
1519     function transferFrom(
1520         address from,
1521         address to,
1522         uint256 tokenId
1523     ) external;
1524 
1525     /**
1526      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1527      * The approval is cleared when the token is transferred.
1528      *
1529      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1530      *
1531      * Requirements:
1532      *
1533      * - The caller must own the token or be an approved operator.
1534      * - `tokenId` must exist.
1535      *
1536      * Emits an {Approval} event.
1537      */
1538     function approve(address to, uint256 tokenId) external;
1539 
1540     /**
1541      * @dev Approve or remove `operator` as an operator for the caller.
1542      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1543      *
1544      * Requirements:
1545      *
1546      * - The `operator` cannot be the caller.
1547      *
1548      * Emits an {ApprovalForAll} event.
1549      */
1550     function setApprovalForAll(address operator, bool _approved) external;
1551 
1552     /**
1553      * @dev Returns the account approved for `tokenId` token.
1554      *
1555      * Requirements:
1556      *
1557      * - `tokenId` must exist.
1558      */
1559     function getApproved(uint256 tokenId) external view returns (address operator);
1560 
1561     /**
1562      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1563      *
1564      * See {setApprovalForAll}
1565      */
1566     function isApprovedForAll(address owner, address operator) external view returns (bool);
1567 }
1568 
1569 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1570 
1571 
1572 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1573 
1574 pragma solidity ^0.8.0;
1575 
1576 
1577 /**
1578  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1579  * @dev See https://eips.ethereum.org/EIPS/eip-721
1580  */
1581 interface IERC721Metadata is IERC721 {
1582     /**
1583      * @dev Returns the token collection name.
1584      */
1585     function name() external view returns (string memory);
1586 
1587     /**
1588      * @dev Returns the token collection symbol.
1589      */
1590     function symbol() external view returns (string memory);
1591 
1592     /**
1593      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1594      */
1595     function tokenURI(uint256 tokenId) external view returns (string memory);
1596 }
1597 
1598 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1599 
1600 
1601 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 
1607 
1608 
1609 
1610 
1611 
1612 /**
1613  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1614  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1615  * {ERC721Enumerable}.
1616  */
1617 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1618     using Address for address;
1619     using Strings for uint256;
1620 
1621     // Token name
1622     string private _name;
1623 
1624     // Token symbol
1625     string private _symbol;
1626 
1627     // Mapping from token ID to owner address
1628     mapping(uint256 => address) private _owners;
1629 
1630     // Mapping owner address to token count
1631     mapping(address => uint256) private _balances;
1632 
1633     // Mapping from token ID to approved address
1634     mapping(uint256 => address) private _tokenApprovals;
1635 
1636     // Mapping from owner to operator approvals
1637     mapping(address => mapping(address => bool)) private _operatorApprovals;
1638 
1639     /**
1640      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1641      */
1642     constructor(string memory name_, string memory symbol_) {
1643         _name = name_;
1644         _symbol = symbol_;
1645     }
1646 
1647     /**
1648      * @dev See {IERC165-supportsInterface}.
1649      */
1650     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1651         return
1652             interfaceId == type(IERC721).interfaceId ||
1653             interfaceId == type(IERC721Metadata).interfaceId ||
1654             super.supportsInterface(interfaceId);
1655     }
1656 
1657     /**
1658      * @dev See {IERC721-balanceOf}.
1659      */
1660     function balanceOf(address owner) public view virtual override returns (uint256) {
1661         require(owner != address(0), "ERC721: address zero is not a valid owner");
1662         return _balances[owner];
1663     }
1664 
1665     /**
1666      * @dev See {IERC721-ownerOf}.
1667      */
1668     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1669         address owner = _ownerOf(tokenId);
1670         require(owner != address(0), "ERC721: invalid token ID");
1671         return owner;
1672     }
1673 
1674     /**
1675      * @dev See {IERC721Metadata-name}.
1676      */
1677     function name() public view virtual override returns (string memory) {
1678         return _name;
1679     }
1680 
1681     /**
1682      * @dev See {IERC721Metadata-symbol}.
1683      */
1684     function symbol() public view virtual override returns (string memory) {
1685         return _symbol;
1686     }
1687 
1688     /**
1689      * @dev See {IERC721Metadata-tokenURI}.
1690      */
1691     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1692         _requireMinted(tokenId);
1693 
1694         string memory baseURI = _baseURI();
1695         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1696     }
1697 
1698     /**
1699      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1700      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1701      * by default, can be overridden in child contracts.
1702      */
1703     function _baseURI() internal view virtual returns (string memory) {
1704         return "";
1705     }
1706 
1707     /**
1708      * @dev See {IERC721-approve}.
1709      */
1710     function approve(address to, uint256 tokenId) public virtual override {
1711         address owner = ERC721.ownerOf(tokenId);
1712         require(to != owner, "ERC721: approval to current owner");
1713 
1714         require(
1715             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1716             "ERC721: approve caller is not token owner or approved for all"
1717         );
1718 
1719         _approve(to, tokenId);
1720     }
1721 
1722     /**
1723      * @dev See {IERC721-getApproved}.
1724      */
1725     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1726         _requireMinted(tokenId);
1727 
1728         return _tokenApprovals[tokenId];
1729     }
1730 
1731     /**
1732      * @dev See {IERC721-setApprovalForAll}.
1733      */
1734     function setApprovalForAll(address operator, bool approved) public virtual override {
1735         _setApprovalForAll(_msgSender(), operator, approved);
1736     }
1737 
1738     /**
1739      * @dev See {IERC721-isApprovedForAll}.
1740      */
1741     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1742         return _operatorApprovals[owner][operator];
1743     }
1744 
1745     /**
1746      * @dev See {IERC721-transferFrom}.
1747      */
1748     function transferFrom(
1749         address from,
1750         address to,
1751         uint256 tokenId
1752     ) public virtual override {
1753         //solhint-disable-next-line max-line-length
1754         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1755 
1756         _transfer(from, to, tokenId);
1757     }
1758 
1759     /**
1760      * @dev See {IERC721-safeTransferFrom}.
1761      */
1762     function safeTransferFrom(
1763         address from,
1764         address to,
1765         uint256 tokenId
1766     ) public virtual override {
1767         safeTransferFrom(from, to, tokenId, "");
1768     }
1769 
1770     /**
1771      * @dev See {IERC721-safeTransferFrom}.
1772      */
1773     function safeTransferFrom(
1774         address from,
1775         address to,
1776         uint256 tokenId,
1777         bytes memory data
1778     ) public virtual override {
1779         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1780         _safeTransfer(from, to, tokenId, data);
1781     }
1782 
1783     /**
1784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1786      *
1787      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1788      *
1789      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1790      * implement alternative mechanisms to perform token transfer, such as signature-based.
1791      *
1792      * Requirements:
1793      *
1794      * - `from` cannot be the zero address.
1795      * - `to` cannot be the zero address.
1796      * - `tokenId` token must exist and be owned by `from`.
1797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1798      *
1799      * Emits a {Transfer} event.
1800      */
1801     function _safeTransfer(
1802         address from,
1803         address to,
1804         uint256 tokenId,
1805         bytes memory data
1806     ) internal virtual {
1807         _transfer(from, to, tokenId);
1808         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1809     }
1810 
1811     /**
1812      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1813      */
1814     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1815         return _owners[tokenId];
1816     }
1817 
1818     /**
1819      * @dev Returns whether `tokenId` exists.
1820      *
1821      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1822      *
1823      * Tokens start existing when they are minted (`_mint`),
1824      * and stop existing when they are burned (`_burn`).
1825      */
1826     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1827         return _ownerOf(tokenId) != address(0);
1828     }
1829 
1830     /**
1831      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1832      *
1833      * Requirements:
1834      *
1835      * - `tokenId` must exist.
1836      */
1837     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1838         address owner = ERC721.ownerOf(tokenId);
1839         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1840     }
1841 
1842     /**
1843      * @dev Safely mints `tokenId` and transfers it to `to`.
1844      *
1845      * Requirements:
1846      *
1847      * - `tokenId` must not exist.
1848      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1849      *
1850      * Emits a {Transfer} event.
1851      */
1852     function _safeMint(address to, uint256 tokenId) internal virtual {
1853         _safeMint(to, tokenId, "");
1854     }
1855 
1856     /**
1857      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1858      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1859      */
1860     function _safeMint(
1861         address to,
1862         uint256 tokenId,
1863         bytes memory data
1864     ) internal virtual {
1865         _mint(to, tokenId);
1866         require(
1867             _checkOnERC721Received(address(0), to, tokenId, data),
1868             "ERC721: transfer to non ERC721Receiver implementer"
1869         );
1870     }
1871 
1872     /**
1873      * @dev Mints `tokenId` and transfers it to `to`.
1874      *
1875      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1876      *
1877      * Requirements:
1878      *
1879      * - `tokenId` must not exist.
1880      * - `to` cannot be the zero address.
1881      *
1882      * Emits a {Transfer} event.
1883      */
1884     function _mint(address to, uint256 tokenId) internal virtual {
1885         require(to != address(0), "ERC721: mint to the zero address");
1886         require(!_exists(tokenId), "ERC721: token already minted");
1887 
1888         _beforeTokenTransfer(address(0), to, tokenId, 1);
1889 
1890         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1891         require(!_exists(tokenId), "ERC721: token already minted");
1892 
1893         unchecked {
1894             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1895             // Given that tokens are minted one by one, it is impossible in practice that
1896             // this ever happens. Might change if we allow batch minting.
1897             // The ERC fails to describe this case.
1898             _balances[to] += 1;
1899         }
1900 
1901         _owners[tokenId] = to;
1902 
1903         emit Transfer(address(0), to, tokenId);
1904 
1905         _afterTokenTransfer(address(0), to, tokenId, 1);
1906     }
1907 
1908     /**
1909      * @dev Destroys `tokenId`.
1910      * The approval is cleared when the token is burned.
1911      * This is an internal function that does not check if the sender is authorized to operate on the token.
1912      *
1913      * Requirements:
1914      *
1915      * - `tokenId` must exist.
1916      *
1917      * Emits a {Transfer} event.
1918      */
1919     function _burn(uint256 tokenId) internal virtual {
1920         address owner = ERC721.ownerOf(tokenId);
1921 
1922         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1923 
1924         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1925         owner = ERC721.ownerOf(tokenId);
1926 
1927         // Clear approvals
1928         delete _tokenApprovals[tokenId];
1929 
1930         unchecked {
1931             // Cannot overflow, as that would require more tokens to be burned/transferred
1932             // out than the owner initially received through minting and transferring in.
1933             _balances[owner] -= 1;
1934         }
1935         delete _owners[tokenId];
1936 
1937         emit Transfer(owner, address(0), tokenId);
1938 
1939         _afterTokenTransfer(owner, address(0), tokenId, 1);
1940     }
1941 
1942     /**
1943      * @dev Transfers `tokenId` from `from` to `to`.
1944      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1945      *
1946      * Requirements:
1947      *
1948      * - `to` cannot be the zero address.
1949      * - `tokenId` token must be owned by `from`.
1950      *
1951      * Emits a {Transfer} event.
1952      */
1953     function _transfer(
1954         address from,
1955         address to,
1956         uint256 tokenId
1957     ) internal virtual {
1958         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1959         require(to != address(0), "ERC721: transfer to the zero address");
1960 
1961         _beforeTokenTransfer(from, to, tokenId, 1);
1962 
1963         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1964         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1965 
1966         // Clear approvals from the previous owner
1967         delete _tokenApprovals[tokenId];
1968 
1969         unchecked {
1970             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1971             // `from`'s balance is the number of token held, which is at least one before the current
1972             // transfer.
1973             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1974             // all 2**256 token ids to be minted, which in practice is impossible.
1975             _balances[from] -= 1;
1976             _balances[to] += 1;
1977         }
1978         _owners[tokenId] = to;
1979 
1980         emit Transfer(from, to, tokenId);
1981 
1982         _afterTokenTransfer(from, to, tokenId, 1);
1983     }
1984 
1985     /**
1986      * @dev Approve `to` to operate on `tokenId`
1987      *
1988      * Emits an {Approval} event.
1989      */
1990     function _approve(address to, uint256 tokenId) internal virtual {
1991         _tokenApprovals[tokenId] = to;
1992         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1993     }
1994 
1995     /**
1996      * @dev Approve `operator` to operate on all of `owner` tokens
1997      *
1998      * Emits an {ApprovalForAll} event.
1999      */
2000     function _setApprovalForAll(
2001         address owner,
2002         address operator,
2003         bool approved
2004     ) internal virtual {
2005         require(owner != operator, "ERC721: approve to caller");
2006         _operatorApprovals[owner][operator] = approved;
2007         emit ApprovalForAll(owner, operator, approved);
2008     }
2009 
2010     /**
2011      * @dev Reverts if the `tokenId` has not been minted yet.
2012      */
2013     function _requireMinted(uint256 tokenId) internal view virtual {
2014         require(_exists(tokenId), "ERC721: invalid token ID");
2015     }
2016 
2017     /**
2018      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2019      * The call is not executed if the target address is not a contract.
2020      *
2021      * @param from address representing the previous owner of the given token ID
2022      * @param to target address that will receive the tokens
2023      * @param tokenId uint256 ID of the token to be transferred
2024      * @param data bytes optional data to send along with the call
2025      * @return bool whether the call correctly returned the expected magic value
2026      */
2027     function _checkOnERC721Received(
2028         address from,
2029         address to,
2030         uint256 tokenId,
2031         bytes memory data
2032     ) private returns (bool) {
2033         if (to.isContract()) {
2034             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2035                 return retval == IERC721Receiver.onERC721Received.selector;
2036             } catch (bytes memory reason) {
2037                 if (reason.length == 0) {
2038                     revert("ERC721: transfer to non ERC721Receiver implementer");
2039                 } else {
2040                     /// @solidity memory-safe-assembly
2041                     assembly {
2042                         revert(add(32, reason), mload(reason))
2043                     }
2044                 }
2045             }
2046         } else {
2047             return true;
2048         }
2049     }
2050 
2051     /**
2052      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2053      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2054      *
2055      * Calling conditions:
2056      *
2057      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2058      * - When `from` is zero, the tokens will be minted for `to`.
2059      * - When `to` is zero, ``from``'s tokens will be burned.
2060      * - `from` and `to` are never both zero.
2061      * - `batchSize` is non-zero.
2062      *
2063      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2064      */
2065     function _beforeTokenTransfer(
2066         address from,
2067         address to,
2068         uint256, /* firstTokenId */
2069         uint256 batchSize
2070     ) internal virtual {
2071         if (batchSize > 1) {
2072             if (from != address(0)) {
2073                 _balances[from] -= batchSize;
2074             }
2075             if (to != address(0)) {
2076                 _balances[to] += batchSize;
2077             }
2078         }
2079     }
2080 
2081     /**
2082      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2083      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2084      *
2085      * Calling conditions:
2086      *
2087      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2088      * - When `from` is zero, the tokens were minted for `to`.
2089      * - When `to` is zero, ``from``'s tokens were burned.
2090      * - `from` and `to` are never both zero.
2091      * - `batchSize` is non-zero.
2092      *
2093      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2094      */
2095     function _afterTokenTransfer(
2096         address from,
2097         address to,
2098         uint256 firstTokenId,
2099         uint256 batchSize
2100     ) internal virtual {}
2101 }
2102 
2103 // File: contracts/utils/Ownable.sol
2104 
2105 
2106 pragma solidity ^0.8.0;
2107 
2108 contract Ownable {
2109     address private _convenienceOwner;
2110 
2111     event OwnershipSet(address indexed previousOwner, address indexed newOwner);
2112 
2113     /// @notice returns the address of the current _convenienceOwner
2114     /// @dev not used for access control, used by services that require a single owner account
2115     /// @return _convenienceOwner address
2116     function owner() public view virtual returns (address) {
2117         return _convenienceOwner;
2118     }
2119 
2120     /// @notice Set the _convenienceOwner address
2121     /// @dev not used for access control, used by services that require a single owner account
2122     /// @param newOwner address of the new _convenienceOwner
2123     function _setOwnership(address newOwner) internal virtual {
2124         address oldOwner = _convenienceOwner;
2125         _convenienceOwner = newOwner;
2126         emit OwnershipSet(oldOwner, newOwner);
2127     }
2128 
2129     /// @notice This empty reserved space is put in place to allow future versions to add new
2130     /// variables without shifting down storage in the inheritance chain.
2131     /// See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
2132     uint256[100] private __gap;
2133 }
2134 
2135 // File: contracts/utils/Errors.sol
2136 
2137 
2138 pragma solidity ^0.8.0;
2139 
2140 error MaxSupplyReached();
2141 error AlreadyMinted();
2142 error ProofInvalidOrNotInAllowlist();
2143 error CannotMintFromContract();
2144 
2145 // File: contracts/X_MARKS_THE_SPOT.sol
2146 
2147 
2148 pragma solidity ^0.8.0;
2149 
2150 
2151 
2152 
2153 
2154 
2155 
2156 
2157 
2158 /// @author @0x__jj, @llio (Deca)
2159 contract X_MARKS_THE_SPOT is ERC721, ReentrancyGuard, AccessControl, Ownable {
2160   using Address for address;
2161   using Strings for *;
2162 
2163   mapping(address => bool) public minted;
2164 
2165   uint256 public totalSupply = 0;
2166 
2167   uint256 public constant MAX_SUPPLY = 100;
2168 
2169   bytes32 public merkleRoot;
2170 
2171   string public baseUri;
2172 
2173   constructor(string memory _baseUri, address[] memory _admins)
2174     ERC721("X MARKS THE SPOT", "XMTS")
2175   {
2176     _setOwnership(msg.sender);
2177     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
2178     for (uint256 i = 0; i < _admins.length; i++) {
2179       _grantRole(DEFAULT_ADMIN_ROLE, _admins[i]);
2180     }
2181     baseUri = _baseUri;
2182   }
2183 
2184   function setMerkleRoot(bytes32 _merkleRoot)
2185     external
2186     onlyRole(DEFAULT_ADMIN_ROLE)
2187   {
2188     merkleRoot = _merkleRoot;
2189   }
2190 
2191   function setOwnership(address _newOwner)
2192     external
2193     onlyRole(DEFAULT_ADMIN_ROLE)
2194   {
2195     _setOwnership(_newOwner);
2196   }
2197 
2198   function setBaseUri(string memory _newBaseUri)
2199     external
2200     onlyRole(DEFAULT_ADMIN_ROLE)
2201   {
2202     baseUri = _newBaseUri;
2203   }
2204 
2205   function mint(bytes32[] calldata _merkleProof)
2206     external
2207     nonReentrant
2208     returns (uint256)
2209   {
2210     if (totalSupply >= MAX_SUPPLY) revert MaxSupplyReached();
2211     if (minted[msg.sender]) revert AlreadyMinted();
2212     if (msg.sender.isContract()) revert CannotMintFromContract();
2213     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2214     if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf))
2215       revert ProofInvalidOrNotInAllowlist();
2216 
2217     uint256 tokenId = totalSupply;
2218     totalSupply++;
2219     minted[msg.sender] = true;
2220     _safeMint(msg.sender, tokenId);
2221     return tokenId;
2222   }
2223 
2224   function tokenURI(uint256 _tokenId)
2225     public
2226     view
2227     override(ERC721)
2228     returns (string memory)
2229   {
2230     require(_exists(_tokenId), "DECAL: URI query for nonexistent token");
2231     string memory baseURI = _baseURI();
2232     require(bytes(baseURI).length > 0, "baseURI not set");
2233     return string(abi.encodePacked(baseURI, _tokenId.toString()));
2234   }
2235 
2236   function getTokensOfOwner(address _owner)
2237     public
2238     view
2239     returns (uint256[] memory)
2240   {
2241     uint256 tokenCount = balanceOf(_owner);
2242     uint256[] memory tokenIds = new uint256[](tokenCount);
2243     uint256 seen = 0;
2244     for (uint256 i; i < totalSupply; i++) {
2245       if (ownerOf(i) == _owner) {
2246         tokenIds[seen] = i;
2247         seen++;
2248       }
2249       if (seen == tokenCount) break;
2250     }
2251     return tokenIds;
2252   }
2253 
2254   /**
2255    * @dev See {IERC165-supportsInterface}.
2256    */
2257   function supportsInterface(bytes4 interfaceId)
2258     public
2259     view
2260     virtual
2261     override(ERC721, AccessControl)
2262     returns (bool)
2263   {
2264     return super.supportsInterface(interfaceId);
2265   }
2266 
2267   function _baseURI() internal view override(ERC721) returns (string memory) {
2268     return baseUri;
2269   }
2270 }