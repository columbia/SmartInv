1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 library EnumerableSet {
6 
7     struct Set {
8         // Storage of set values
9         bytes32[] _values;
10         // Position of the value in the `values` array, plus 1 because index 0
11         // means a value is not in the set.
12         mapping(bytes32 => uint256) _indexes;
13     }
14 
15     function _add(Set storage set, bytes32 value) private returns (bool) {
16         if (!_contains(set, value)) {
17             set._values.push(value);
18             // The value is stored at length-1, but we add 1 to all indexes
19             // and use 0 as a sentinel value
20             set._indexes[value] = set._values.length;
21             return true;
22         } else {
23             return false;
24         }
25     }
26 
27     function _remove(Set storage set, bytes32 value) private returns (bool) {
28         // We read and store the value's index to prevent multiple reads from the same storage slot
29         uint256 valueIndex = set._indexes[value];
30 
31         if (valueIndex != 0) {
32             // Equivalent to contains(set, value)
33             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
34             // the array, and then remove the last element (sometimes called as 'swap and pop').
35             // This modifies the order of the array, as noted in {at}.
36 
37             uint256 toDeleteIndex = valueIndex - 1;
38             uint256 lastIndex = set._values.length - 1;
39 
40             if (lastIndex != toDeleteIndex) {
41                 bytes32 lastValue = set._values[lastIndex];
42 
43                 // Move the last value to the index where the value to delete is
44                 set._values[toDeleteIndex] = lastValue;
45                 // Update the index for the moved value
46                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
47             }
48 
49             // Delete the slot where the moved value was stored
50             set._values.pop();
51 
52             // Delete the index for the deleted slot
53             delete set._indexes[value];
54 
55             return true;
56         } else {
57             return false;
58         }
59     }
60 
61     /**
62      * @dev Returns true if the value is in the set. O(1).
63      */
64     function _contains(Set storage set, bytes32 value) private view returns (bool) {
65         return set._indexes[value] != 0;
66     }
67 
68     /**
69      * @dev Returns the number of values on the set. O(1).
70      */
71     function _length(Set storage set) private view returns (uint256) {
72         return set._values.length;
73     }
74 
75     function _at(Set storage set, uint256 index) private view returns (bytes32) {
76         return set._values[index];
77     }
78 
79     function _values(Set storage set) private view returns (bytes32[] memory) {
80         return set._values;
81     }
82 
83     // Bytes32Set
84 
85     struct Bytes32Set {
86         Set _inner;
87     }
88 
89     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
90         return _add(set._inner, value);
91     }
92 
93     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
94         return _remove(set._inner, value);
95     }
96 
97     /**
98      * @dev Returns true if the value is in the set. O(1).
99      */
100     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
101         return _contains(set._inner, value);
102     }
103 
104     /**
105      * @dev Returns the number of values in the set. O(1).
106      */
107     function length(Bytes32Set storage set) internal view returns (uint256) {
108         return _length(set._inner);
109     }
110 
111     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
112         return _at(set._inner, index);
113     }
114 
115     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
116         bytes32[] memory store = _values(set._inner);
117         bytes32[] memory result;
118 
119         /// @solidity memory-safe-assembly
120         assembly {
121             result := store
122         }
123 
124         return result;
125     }
126 
127     // AddressSet
128 
129     struct AddressSet {
130         Set _inner;
131     }
132 
133     /**
134      * @dev Add a value to a set. O(1).
135      *
136      * Returns true if the value was added to the set, that is if it was not
137      * already present.
138      */
139     function add(AddressSet storage set, address value) internal returns (bool) {
140         return _add(set._inner, bytes32(uint256(uint160(value))));
141     }
142 
143     /**
144      * @dev Removes a value from a set. O(1).
145      *
146      * Returns true if the value was removed from the set, that is if it was
147      * present.
148      */
149     function remove(AddressSet storage set, address value) internal returns (bool) {
150         return _remove(set._inner, bytes32(uint256(uint160(value))));
151     }
152 
153     /**
154      * @dev Returns true if the value is in the set. O(1).
155      */
156     function contains(AddressSet storage set, address value) internal view returns (bool) {
157         return _contains(set._inner, bytes32(uint256(uint160(value))));
158     }
159 
160     /**
161      * @dev Returns the number of values in the set. O(1).
162      */
163     function length(AddressSet storage set) internal view returns (uint256) {
164         return _length(set._inner);
165     }
166 
167     function at(AddressSet storage set, uint256 index) internal view returns (address) {
168         return address(uint160(uint256(_at(set._inner, index))));
169     }
170 
171     function values(AddressSet storage set) internal view returns (address[] memory) {
172         bytes32[] memory store = _values(set._inner);
173         address[] memory result;
174 
175         /// @solidity memory-safe-assembly
176         assembly {
177             result := store
178         }
179 
180         return result;
181     }
182 
183     // UintSet
184 
185     struct UintSet {
186         Set _inner;
187     }
188 
189     /**
190      * @dev Add a value to a set. O(1).
191      *
192      * Returns true if the value was added to the set, that is if it was not
193      * already present.
194      */
195     function add(UintSet storage set, uint256 value) internal returns (bool) {
196         return _add(set._inner, bytes32(value));
197     }
198 
199     /**
200      * @dev Removes a value from a set. O(1).
201      *
202      * Returns true if the value was removed from the set, that is if it was
203      * present.
204      */
205     function remove(UintSet storage set, uint256 value) internal returns (bool) {
206         return _remove(set._inner, bytes32(value));
207     }
208 
209     /**
210      * @dev Returns true if the value is in the set. O(1).
211      */
212     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
213         return _contains(set._inner, bytes32(value));
214     }
215 
216     function length(UintSet storage set) internal view returns (uint256) {
217         return _length(set._inner);
218     }
219 
220     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
221         return uint256(_at(set._inner, index));
222     }
223 
224     function values(UintSet storage set) internal view returns (uint256[] memory) {
225         bytes32[] memory store = _values(set._inner);
226         uint256[] memory result;
227 
228         /// @solidity memory-safe-assembly
229         assembly {
230             result := store
231         }
232 
233         return result;
234     }
235 }
236 
237 
238 interface IOperatorFilterRegistry {
239     function isOperatorAllowed(address registrant, address operator) external returns (bool);
240     function register(address registrant) external;
241     function registerAndSubscribe(address registrant, address subscription) external;
242     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
243     function updateOperator(address registrant, address operator, bool filtered) external;
244     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
245     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
246     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
247     function subscribe(address registrant, address registrantToSubscribe) external;
248     function unsubscribe(address registrant, bool copyExistingEntries) external;
249     function subscriptionOf(address addr) external returns (address registrant);
250     function subscribers(address registrant) external returns (address[] memory);
251     function subscriberAt(address registrant, uint256 index) external returns (address);
252     function copyEntriesOf(address registrant, address registrantToCopy) external;
253     function isOperatorFiltered(address registrant, address operator) external returns (bool);
254     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
255     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
256     function filteredOperators(address addr) external returns (address[] memory);
257     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
258     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
259     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
260     function isRegistered(address addr) external returns (bool);
261     function codeHashOf(address addr) external returns (bytes32);
262 }
263 
264 contract OperatorFilterer {
265     error OperatorNotAllowed(address operator);
266 
267     IOperatorFilterRegistry constant operatorFilterRegistry =
268         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
269 
270     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
271         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
272         // will not revert, but the contract will need to be registered with the registry once it is deployed in
273         // order for the modifier to filter addresses.
274         if (address(operatorFilterRegistry).code.length > 0) {
275             if (subscribe) {
276                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
277             } else {
278                 if (subscriptionOrRegistrantToCopy != address(0)) {
279                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
280                 } else {
281                     operatorFilterRegistry.register(address(this));
282                 }
283             }
284         }
285     }
286 
287     modifier onlyAllowedOperator() virtual {
288         // Check registry code length to facilitate testing in environments without a deployed registry.
289         if (address(operatorFilterRegistry).code.length > 0) {
290             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
291                 revert OperatorNotAllowed(msg.sender);
292             }
293         }
294         _;
295     }
296 }
297 
298 contract DefaultOperatorFilterer is OperatorFilterer {
299     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
300 
301     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
302 }
303 
304 
305 library MerkleProof {
306   
307     function verify(
308         bytes32[] memory proof,
309         bytes32 root,
310         bytes32 leaf
311     ) internal pure returns (bool) {
312         return processProof(proof, leaf) == root;
313     }
314 
315     function verifyCalldata(
316         bytes32[] calldata proof,
317         bytes32 root,
318         bytes32 leaf
319     ) internal pure returns (bool) {
320         return processProofCalldata(proof, leaf) == root;
321     }
322 
323     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
324         bytes32 computedHash = leaf;
325         for (uint256 i = 0; i < proof.length; i++) {
326             computedHash = _hashPair(computedHash, proof[i]);
327         }
328         return computedHash;
329     }
330 
331     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
332         bytes32 computedHash = leaf;
333         for (uint256 i = 0; i < proof.length; i++) {
334             computedHash = _hashPair(computedHash, proof[i]);
335         }
336         return computedHash;
337     }
338 
339     function multiProofVerify(
340         bytes32[] memory proof,
341         bool[] memory proofFlags,
342         bytes32 root,
343         bytes32[] memory leaves
344     ) internal pure returns (bool) {
345         return processMultiProof(proof, proofFlags, leaves) == root;
346     }
347 
348     function multiProofVerifyCalldata(
349         bytes32[] calldata proof,
350         bool[] calldata proofFlags,
351         bytes32 root,
352         bytes32[] memory leaves
353     ) internal pure returns (bool) {
354         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
355     }
356 
357     function processMultiProof(
358         bytes32[] memory proof,
359         bool[] memory proofFlags,
360         bytes32[] memory leaves
361     ) internal pure returns (bytes32 merkleRoot) {
362        
363         uint256 leavesLen = leaves.length;
364         uint256 totalHashes = proofFlags.length;
365 
366         // Check proof validity.
367         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
368 
369         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
370         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
371         bytes32[] memory hashes = new bytes32[](totalHashes);
372         uint256 leafPos = 0;
373         uint256 hashPos = 0;
374         uint256 proofPos = 0;
375         // At each step, we compute the next hash using two values:
376         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
377         //   get the next hash.
378         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
379         //   `proof` array.
380         for (uint256 i = 0; i < totalHashes; i++) {
381             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
382             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
383             hashes[i] = _hashPair(a, b);
384         }
385 
386         if (totalHashes > 0) {
387             return hashes[totalHashes - 1];
388         } else if (leavesLen > 0) {
389             return leaves[0];
390         } else {
391             return proof[0];
392         }
393     }
394 
395     /**
396      * @dev Calldata version of {processMultiProof}.
397      *
398      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
399      *
400      * _Available since v4.7._
401      */
402     function processMultiProofCalldata(
403         bytes32[] calldata proof,
404         bool[] calldata proofFlags,
405         bytes32[] memory leaves
406     ) internal pure returns (bytes32 merkleRoot) {
407         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
408         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
409         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
410         // the merkle tree.
411         uint256 leavesLen = leaves.length;
412         uint256 totalHashes = proofFlags.length;
413 
414         // Check proof validity.
415         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
416 
417         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
418         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
419         bytes32[] memory hashes = new bytes32[](totalHashes);
420         uint256 leafPos = 0;
421         uint256 hashPos = 0;
422         uint256 proofPos = 0;
423         // At each step, we compute the next hash using two values:
424         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
425         //   get the next hash.
426         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
427         //   `proof` array.
428         for (uint256 i = 0; i < totalHashes; i++) {
429             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
430             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
431             hashes[i] = _hashPair(a, b);
432         }
433 
434         if (totalHashes > 0) {
435             return hashes[totalHashes - 1];
436         } else if (leavesLen > 0) {
437             return leaves[0];
438         } else {
439             return proof[0];
440         }
441     }
442 
443     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
444         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
445     }
446 
447     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
448         /// @solidity memory-safe-assembly
449         assembly {
450             mstore(0x00, a)
451             mstore(0x20, b)
452             value := keccak256(0x00, 0x40)
453         }
454     }
455 }
456 
457 
458 library Math {
459     enum Rounding {
460         Down, // Toward negative infinity
461         Up, // Toward infinity
462         Zero // Toward zero
463     }
464 
465     /**
466      * @dev Returns the largest of two numbers.
467      */
468     function max(uint256 a, uint256 b) internal pure returns (uint256) {
469         return a > b ? a : b;
470     }
471 
472     /**
473      * @dev Returns the smallest of two numbers.
474      */
475     function min(uint256 a, uint256 b) internal pure returns (uint256) {
476         return a < b ? a : b;
477     }
478 
479     /**
480      * @dev Returns the average of two numbers. The result is rounded towards
481      * zero.
482      */
483     function average(uint256 a, uint256 b) internal pure returns (uint256) {
484         // (a + b) / 2 can overflow.
485         return (a & b) + (a ^ b) / 2;
486     }
487 
488     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
489         // (a + b - 1) / b can overflow on addition, so we distribute.
490         return a == 0 ? 0 : (a - 1) / b + 1;
491     }
492 
493     function mulDiv(
494         uint256 x,
495         uint256 y,
496         uint256 denominator
497     ) internal pure returns (uint256 result) {
498         unchecked {
499             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
500             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
501             // variables such that product = prod1 * 2^256 + prod0.
502             uint256 prod0; // Least significant 256 bits of the product
503             uint256 prod1; // Most significant 256 bits of the product
504             assembly {
505                 let mm := mulmod(x, y, not(0))
506                 prod0 := mul(x, y)
507                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
508             }
509 
510             // Handle non-overflow cases, 256 by 256 division.
511             if (prod1 == 0) {
512                 return prod0 / denominator;
513             }
514 
515             // Make sure the result is less than 2^256. Also prevents denominator == 0.
516             require(denominator > prod1);
517 
518             ///////////////////////////////////////////////
519             // 512 by 256 division.
520             ///////////////////////////////////////////////
521 
522             // Make division exact by subtracting the remainder from [prod1 prod0].
523             uint256 remainder;
524             assembly {
525                 // Compute remainder using mulmod.
526                 remainder := mulmod(x, y, denominator)
527 
528                 // Subtract 256 bit number from 512 bit number.
529                 prod1 := sub(prod1, gt(remainder, prod0))
530                 prod0 := sub(prod0, remainder)
531             }
532 
533             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
534             // See https://cs.stackexchange.com/q/138556/92363.
535 
536             // Does not overflow because the denominator cannot be zero at this stage in the function.
537             uint256 twos = denominator & (~denominator + 1);
538             assembly {
539                 // Divide denominator by twos.
540                 denominator := div(denominator, twos)
541 
542                 // Divide [prod1 prod0] by twos.
543                 prod0 := div(prod0, twos)
544 
545                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
546                 twos := add(div(sub(0, twos), twos), 1)
547             }
548 
549             // Shift in bits from prod1 into prod0.
550             prod0 |= prod1 * twos;
551 
552             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
553             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
554             // four bits. That is, denominator * inv = 1 mod 2^4.
555             uint256 inverse = (3 * denominator) ^ 2;
556 
557             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
558             // in modular arithmetic, doubling the correct bits in each step.
559             inverse *= 2 - denominator * inverse; // inverse mod 2^8
560             inverse *= 2 - denominator * inverse; // inverse mod 2^16
561             inverse *= 2 - denominator * inverse; // inverse mod 2^32
562             inverse *= 2 - denominator * inverse; // inverse mod 2^64
563             inverse *= 2 - denominator * inverse; // inverse mod 2^128
564             inverse *= 2 - denominator * inverse; // inverse mod 2^256
565 
566             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
567             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
568             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
569             // is no longer required.
570             result = prod0 * inverse;
571             return result;
572         }
573     }
574 
575     /**
576      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
577      */
578     function mulDiv(
579         uint256 x,
580         uint256 y,
581         uint256 denominator,
582         Rounding rounding
583     ) internal pure returns (uint256) {
584         uint256 result = mulDiv(x, y, denominator);
585         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
586             result += 1;
587         }
588         return result;
589     }
590 
591     /**
592      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
593      *
594      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
595      */
596     function sqrt(uint256 a) internal pure returns (uint256) {
597         if (a == 0) {
598             return 0;
599         }
600 
601         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
602         //
603         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
604         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
605         //
606         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
607         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
608         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
609         //
610         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
611         uint256 result = 1 << (log2(a) >> 1);
612 
613         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
614         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
615         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
616         // into the expected uint128 result.
617         unchecked {
618             result = (result + a / result) >> 1;
619             result = (result + a / result) >> 1;
620             result = (result + a / result) >> 1;
621             result = (result + a / result) >> 1;
622             result = (result + a / result) >> 1;
623             result = (result + a / result) >> 1;
624             result = (result + a / result) >> 1;
625             return min(result, a / result);
626         }
627     }
628 
629     /**
630      * @notice Calculates sqrt(a), following the selected rounding direction.
631      */
632     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
633         unchecked {
634             uint256 result = sqrt(a);
635             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
636         }
637     }
638 
639     /**
640      * @dev Return the log in base 2, rounded down, of a positive value.
641      * Returns 0 if given 0.
642      */
643     function log2(uint256 value) internal pure returns (uint256) {
644         uint256 result = 0;
645         unchecked {
646             if (value >> 128 > 0) {
647                 value >>= 128;
648                 result += 128;
649             }
650             if (value >> 64 > 0) {
651                 value >>= 64;
652                 result += 64;
653             }
654             if (value >> 32 > 0) {
655                 value >>= 32;
656                 result += 32;
657             }
658             if (value >> 16 > 0) {
659                 value >>= 16;
660                 result += 16;
661             }
662             if (value >> 8 > 0) {
663                 value >>= 8;
664                 result += 8;
665             }
666             if (value >> 4 > 0) {
667                 value >>= 4;
668                 result += 4;
669             }
670             if (value >> 2 > 0) {
671                 value >>= 2;
672                 result += 2;
673             }
674             if (value >> 1 > 0) {
675                 result += 1;
676             }
677         }
678         return result;
679     }
680 
681     /**
682      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
683      * Returns 0 if given 0.
684      */
685     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
686         unchecked {
687             uint256 result = log2(value);
688             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
689         }
690     }
691 
692     /**
693      * @dev Return the log in base 10, rounded down, of a positive value.
694      * Returns 0 if given 0.
695      */
696     function log10(uint256 value) internal pure returns (uint256) {
697         uint256 result = 0;
698         unchecked {
699             if (value >= 10**64) {
700                 value /= 10**64;
701                 result += 64;
702             }
703             if (value >= 10**32) {
704                 value /= 10**32;
705                 result += 32;
706             }
707             if (value >= 10**16) {
708                 value /= 10**16;
709                 result += 16;
710             }
711             if (value >= 10**8) {
712                 value /= 10**8;
713                 result += 8;
714             }
715             if (value >= 10**4) {
716                 value /= 10**4;
717                 result += 4;
718             }
719             if (value >= 10**2) {
720                 value /= 10**2;
721                 result += 2;
722             }
723             if (value >= 10**1) {
724                 result += 1;
725             }
726         }
727         return result;
728     }
729 
730     /**
731      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
732      * Returns 0 if given 0.
733      */
734     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
735         unchecked {
736             uint256 result = log10(value);
737             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
738         }
739     }
740 
741     /**
742      * @dev Return the log in base 256, rounded down, of a positive value.
743      * Returns 0 if given 0.
744      *
745      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
746      */
747     function log256(uint256 value) internal pure returns (uint256) {
748         uint256 result = 0;
749         unchecked {
750             if (value >> 128 > 0) {
751                 value >>= 128;
752                 result += 16;
753             }
754             if (value >> 64 > 0) {
755                 value >>= 64;
756                 result += 8;
757             }
758             if (value >> 32 > 0) {
759                 value >>= 32;
760                 result += 4;
761             }
762             if (value >> 16 > 0) {
763                 value >>= 16;
764                 result += 2;
765             }
766             if (value >> 8 > 0) {
767                 result += 1;
768             }
769         }
770         return result;
771     }
772 
773     /**
774      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
775      * Returns 0 if given 0.
776      */
777     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
778         unchecked {
779             uint256 result = log256(value);
780             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
781         }
782     }
783 }
784 
785 library Strings {
786     bytes16 private constant _SYMBOLS = "0123456789abcdef";
787     uint8 private constant _ADDRESS_LENGTH = 20;
788 
789     /**
790      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
791      */
792     function toString(uint256 value) internal pure returns (string memory) {
793         unchecked {
794             uint256 length = Math.log10(value) + 1;
795             string memory buffer = new string(length);
796             uint256 ptr;
797             /// @solidity memory-safe-assembly
798             assembly {
799                 ptr := add(buffer, add(32, length))
800             }
801             while (true) {
802                 ptr--;
803                 /// @solidity memory-safe-assembly
804                 assembly {
805                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
806                 }
807                 value /= 10;
808                 if (value == 0) break;
809             }
810             return buffer;
811         }
812     }
813 
814     /**
815      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
816      */
817     function toHexString(uint256 value) internal pure returns (string memory) {
818         unchecked {
819             return toHexString(value, Math.log256(value) + 1);
820         }
821     }
822 
823     /**
824      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
825      */
826     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
827         bytes memory buffer = new bytes(2 * length + 2);
828         buffer[0] = "0";
829         buffer[1] = "x";
830         for (uint256 i = 2 * length + 1; i > 1; --i) {
831             buffer[i] = _SYMBOLS[value & 0xf];
832             value >>= 4;
833         }
834         require(value == 0, "Strings: hex length insufficient");
835         return string(buffer);
836     }
837 
838     /**
839      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
840      */
841     function toHexString(address addr) internal pure returns (string memory) {
842         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
843     }
844 }
845 
846 
847 abstract contract Context {
848     function _msgSender() internal view virtual returns (address) {
849         return msg.sender;
850     }
851 
852     function _msgData() internal view virtual returns (bytes calldata) {
853         return msg.data;
854     }
855 }
856 
857 
858 abstract contract Ownable is Context {
859     address private _owner;
860 
861     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
862 
863     /**
864      * @dev Initializes the contract setting the deployer as the initial owner.
865      */
866     constructor() {
867         _transferOwnership(_msgSender());
868     }
869 
870     /**
871      * @dev Throws if called by any account other than the owner.
872      */
873     modifier onlyOwner() {
874         _checkOwner();
875         _;
876     }
877 
878     /**
879      * @dev Returns the address of the current owner.
880      */
881     function owner() public view virtual returns (address) {
882         return _owner;
883     }
884 
885     /**
886      * @dev Throws if the sender is not the owner.
887      */
888     function _checkOwner() internal view virtual {
889         require(owner() == _msgSender(), "Ownable: caller is not the owner");
890     }
891 
892     /**
893      * @dev Leaves the contract without owner. It will not be possible to call
894      * `onlyOwner` functions anymore. Can only be called by the current owner.
895      *
896      * NOTE: Renouncing ownership will leave the contract without an owner,
897      * thereby removing any functionality that is only available to the owner.
898      */
899     function renounceOwnership() public virtual onlyOwner {
900         _transferOwnership(address(0));
901     }
902 
903     /**
904      * @dev Transfers ownership of the contract to a new account (`newOwner`).
905      * Can only be called by the current owner.
906      */
907     function transferOwnership(address newOwner) public virtual onlyOwner {
908         require(newOwner != address(0), "Ownable: new owner is the zero address");
909         _transferOwnership(newOwner);
910     }
911 
912     /**
913      * @dev Transfers ownership of the contract to a new account (`newOwner`).
914      * Internal function without access restriction.
915      */
916     function _transferOwnership(address newOwner) internal virtual {
917         address oldOwner = _owner;
918         _owner = newOwner;
919         emit OwnershipTransferred(oldOwner, newOwner);
920     }
921 }
922 
923 
924 library Address {
925     
926     function isContract(address account) internal view returns (bool) {
927         // This method relies on extcodesize/address.code.length, which returns 0
928         // for contracts in construction, since the code is only stored at the end
929         // of the constructor execution.
930 
931         return account.code.length > 0;
932     }
933 
934     function sendValue(address payable recipient, uint256 amount) internal {
935         require(address(this).balance >= amount, "Address: insufficient balance");
936 
937         (bool success, ) = recipient.call{value: amount}("");
938         require(success, "Address: unable to send value, recipient may have reverted");
939     }
940 
941     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
942         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
943     }
944 
945     /**
946      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
947      * `errorMessage` as a fallback revert reason when `target` reverts.
948      *
949      * _Available since v3.1._
950      */
951     function functionCall(
952         address target,
953         bytes memory data,
954         string memory errorMessage
955     ) internal returns (bytes memory) {
956         return functionCallWithValue(target, data, 0, errorMessage);
957     }
958 
959     /**
960      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
961      * but also transferring `value` wei to `target`.
962      *
963      * Requirements:
964      *
965      * - the calling contract must have an ETH balance of at least `value`.
966      * - the called Solidity function must be `payable`.
967      *
968      * _Available since v3.1._
969      */
970     function functionCallWithValue(
971         address target,
972         bytes memory data,
973         uint256 value
974     ) internal returns (bytes memory) {
975         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
976     }
977 
978     /**
979      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
980      * with `errorMessage` as a fallback revert reason when `target` reverts.
981      *
982      * _Available since v3.1._
983      */
984     function functionCallWithValue(
985         address target,
986         bytes memory data,
987         uint256 value,
988         string memory errorMessage
989     ) internal returns (bytes memory) {
990         require(address(this).balance >= value, "Address: insufficient balance for call");
991         (bool success, bytes memory returndata) = target.call{value: value}(data);
992         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
993     }
994 
995     /**
996      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
997      * but performing a static call.
998      *
999      * _Available since v3.3._
1000      */
1001     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1002         return functionStaticCall(target, data, "Address: low-level static call failed");
1003     }
1004 
1005     /**
1006      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1007      * but performing a static call.
1008      *
1009      * _Available since v3.3._
1010      */
1011     function functionStaticCall(
1012         address target,
1013         bytes memory data,
1014         string memory errorMessage
1015     ) internal view returns (bytes memory) {
1016         (bool success, bytes memory returndata) = target.staticcall(data);
1017         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1018     }
1019 
1020     /**
1021      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1022      * but performing a delegate call.
1023      *
1024      * _Available since v3.4._
1025      */
1026     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1027         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1028     }
1029 
1030     /**
1031      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1032      * but performing a delegate call.
1033      *
1034      * _Available since v3.4._
1035      */
1036     function functionDelegateCall(
1037         address target,
1038         bytes memory data,
1039         string memory errorMessage
1040     ) internal returns (bytes memory) {
1041         (bool success, bytes memory returndata) = target.delegatecall(data);
1042         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1043     }
1044 
1045     /**
1046      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1047      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1048      *
1049      * _Available since v4.8._
1050      */
1051     function verifyCallResultFromTarget(
1052         address target,
1053         bool success,
1054         bytes memory returndata,
1055         string memory errorMessage
1056     ) internal view returns (bytes memory) {
1057         if (success) {
1058             if (returndata.length == 0) {
1059                 // only check isContract if the call was successful and the return data is empty
1060                 // otherwise we already know that it was a contract
1061                 require(isContract(target), "Address: call to non-contract");
1062             }
1063             return returndata;
1064         } else {
1065             _revert(returndata, errorMessage);
1066         }
1067     }
1068 
1069     /**
1070      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1071      * revert reason or using the provided one.
1072      *
1073      * _Available since v4.3._
1074      */
1075     function verifyCallResult(
1076         bool success,
1077         bytes memory returndata,
1078         string memory errorMessage
1079     ) internal pure returns (bytes memory) {
1080         if (success) {
1081             return returndata;
1082         } else {
1083             _revert(returndata, errorMessage);
1084         }
1085     }
1086 
1087     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1088         // Look for revert reason and bubble it up if present
1089         if (returndata.length > 0) {
1090             // The easiest way to bubble the revert reason is using memory via assembly
1091             /// @solidity memory-safe-assembly
1092             assembly {
1093                 let returndata_size := mload(returndata)
1094                 revert(add(32, returndata), returndata_size)
1095             }
1096         } else {
1097             revert(errorMessage);
1098         }
1099     }
1100 }
1101 
1102 
1103 interface IERC721Receiver {
1104     function onERC721Received(
1105         address operator,
1106         address from,
1107         uint256 tokenId,
1108         bytes calldata data
1109     ) external returns (bytes4);
1110 }
1111 
1112 interface IERC165 {
1113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1114 }
1115 
1116 
1117 abstract contract ERC165 is IERC165 {
1118     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1119         return interfaceId == type(IERC165).interfaceId;
1120     }
1121 }
1122 
1123 interface IERC721 is IERC165 {
1124     
1125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1126     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1127     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1128     function balanceOf(address owner) external view returns (uint256 balance);
1129     function ownerOf(uint256 tokenId) external view returns (address owner);
1130     function safeTransferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes calldata data
1135     ) external;
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) external;
1141     function transferFrom(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) external;
1146     function approve(address to, uint256 tokenId) external;
1147     function setApprovalForAll(address operator, bool _approved) external;
1148     function getApproved(uint256 tokenId) external view returns (address operator);
1149     function isApprovedForAll(address owner, address operator) external view returns (bool);
1150 }
1151 
1152 
1153 interface IERC721Metadata is IERC721 {
1154     function name() external view returns (string memory);
1155     function symbol() external view returns (string memory);
1156     function tokenURI(uint256 tokenId) external view returns (string memory);
1157 }
1158 
1159 
1160 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1161     using Address for address;
1162     using Strings for uint256;
1163 
1164     // Token name
1165     string private _name;
1166 
1167     // Token symbol
1168     string private _symbol;
1169 
1170     // Mapping from token ID to owner address
1171     mapping(uint256 => address) private _owners;
1172 
1173     // Mapping owner address to token count
1174     mapping(address => uint256) private _balances;
1175 
1176     // Mapping from token ID to approved address
1177     mapping(uint256 => address) private _tokenApprovals;
1178 
1179     // Mapping from owner to operator approvals
1180     mapping(address => mapping(address => bool)) private _operatorApprovals;
1181 
1182     /**
1183      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1184      */
1185     constructor(string memory name_, string memory symbol_) {
1186         _name = name_;
1187         _symbol = symbol_;
1188     }
1189 
1190     /**
1191      * @dev See {IERC165-supportsInterface}.
1192      */
1193     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1194         return
1195             interfaceId == type(IERC721).interfaceId ||
1196             interfaceId == type(IERC721Metadata).interfaceId ||
1197             super.supportsInterface(interfaceId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-balanceOf}.
1202      */
1203     function balanceOf(address owner) public view virtual override returns (uint256) {
1204         require(owner != address(0), "ERC721: address zero is not a valid owner");
1205         return _balances[owner];
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-ownerOf}.
1210      */
1211     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1212         address owner = _ownerOf(tokenId);
1213         require(owner != address(0), "ERC721: invalid token ID");
1214         return owner;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Metadata-name}.
1219      */
1220     function name() public view virtual override returns (string memory) {
1221         return _name;
1222     }
1223 
1224     /**
1225      * @dev See {IERC721Metadata-symbol}.
1226      */
1227     function symbol() public view virtual override returns (string memory) {
1228         return _symbol;
1229     }
1230 
1231     /**
1232      * @dev See {IERC721Metadata-tokenURI}.
1233      */
1234     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1235         _requireMinted(tokenId);
1236 
1237         string memory baseURI = _baseURI();
1238         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1239     }
1240 
1241     /**
1242      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1243      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1244      * by default, can be overridden in child contracts.
1245      */
1246     function _baseURI() internal view virtual returns (string memory) {
1247         return "";
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-approve}.
1252      */
1253     function approve(address to, uint256 tokenId) public virtual override {
1254         address owner = ERC721.ownerOf(tokenId);
1255         require(to != owner, "ERC721: approval to current owner");
1256 
1257         require(
1258             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1259             "ERC721: approve caller is not token owner or approved for all"
1260         );
1261 
1262         _approve(to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-getApproved}.
1267      */
1268     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1269         _requireMinted(tokenId);
1270 
1271         return _tokenApprovals[tokenId];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-setApprovalForAll}.
1276      */
1277     function setApprovalForAll(address operator, bool approved) public virtual override {
1278         _setApprovalForAll(_msgSender(), operator, approved);
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-isApprovedForAll}.
1283      */
1284     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1285         return _operatorApprovals[owner][operator];
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-transferFrom}.
1290      */
1291     function transferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) public virtual override {
1296         //solhint-disable-next-line max-line-length
1297         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1298 
1299         _transfer(from, to, tokenId);
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-safeTransferFrom}.
1304      */
1305     function safeTransferFrom(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) public virtual override {
1310         safeTransferFrom(from, to, tokenId, "");
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-safeTransferFrom}.
1315      */
1316     function safeTransferFrom(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory data
1321     ) public virtual override {
1322         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1323         _safeTransfer(from, to, tokenId, data);
1324     }
1325 
1326     function _safeTransfer(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory data
1331     ) internal virtual {
1332         _transfer(from, to, tokenId);
1333         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1334     }
1335 
1336     /**
1337      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1338      */
1339     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1340         return _owners[tokenId];
1341     }
1342 
1343     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1344         return _ownerOf(tokenId) != address(0);
1345     }
1346 
1347     /**
1348      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1349      *
1350      * Requirements:
1351      *
1352      * - `tokenId` must exist.
1353      */
1354     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1355         address owner = ERC721.ownerOf(tokenId);
1356         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1357     }
1358 
1359     /**
1360      * @dev Safely mints `tokenId` and transfers it to `to`.
1361      *
1362      * Requirements:
1363      *
1364      * - `tokenId` must not exist.
1365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _safeMint(address to, uint256 tokenId) internal virtual {
1370         _safeMint(to, tokenId, "");
1371     }
1372 
1373     /**
1374      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1375      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1376      */
1377     function _safeMint(
1378         address to,
1379         uint256 tokenId,
1380         bytes memory data
1381     ) internal virtual {
1382         _mint(to, tokenId);
1383         require(
1384             _checkOnERC721Received(address(0), to, tokenId, data),
1385             "ERC721: transfer to non ERC721Receiver implementer"
1386         );
1387     }
1388 
1389     /**
1390      * @dev Mints `tokenId` and transfers it to `to`.
1391      *
1392      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1393      *
1394      * Requirements:
1395      *
1396      * - `tokenId` must not exist.
1397      * - `to` cannot be the zero address.
1398      *
1399      * Emits a {Transfer} event.
1400      */
1401     function _mint(address to, uint256 tokenId) internal virtual {
1402         require(to != address(0), "ERC721: mint to the zero address");
1403         require(!_exists(tokenId), "ERC721: token already minted");
1404 
1405         _beforeTokenTransfer(address(0), to, tokenId, 1);
1406 
1407         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1408         require(!_exists(tokenId), "ERC721: token already minted");
1409 
1410         unchecked {
1411             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1412             // Given that tokens are minted one by one, it is impossible in practice that
1413             // this ever happens. Might change if we allow batch minting.
1414             // The ERC fails to describe this case.
1415             _balances[to] += 1;
1416         }
1417 
1418         _owners[tokenId] = to;
1419 
1420         emit Transfer(address(0), to, tokenId);
1421 
1422         _afterTokenTransfer(address(0), to, tokenId, 1);
1423     }
1424 
1425     /**
1426      * @dev Destroys `tokenId`.
1427      * The approval is cleared when the token is burned.
1428      * This is an internal function that does not check if the sender is authorized to operate on the token.
1429      *
1430      * Requirements:
1431      *
1432      * - `tokenId` must exist.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _burn(uint256 tokenId) internal virtual {
1437         address owner = ERC721.ownerOf(tokenId);
1438 
1439         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1440 
1441         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1442         owner = ERC721.ownerOf(tokenId);
1443 
1444         // Clear approvals
1445         delete _tokenApprovals[tokenId];
1446 
1447         unchecked {
1448             // Cannot overflow, as that would require more tokens to be burned/transferred
1449             // out than the owner initially received through minting and transferring in.
1450             _balances[owner] -= 1;
1451         }
1452         delete _owners[tokenId];
1453 
1454         emit Transfer(owner, address(0), tokenId);
1455 
1456         _afterTokenTransfer(owner, address(0), tokenId, 1);
1457     }
1458 
1459     /**
1460      * @dev Transfers `tokenId` from `from` to `to`.
1461      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1462      *
1463      * Requirements:
1464      *
1465      * - `to` cannot be the zero address.
1466      * - `tokenId` token must be owned by `from`.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function _transfer(
1471         address from,
1472         address to,
1473         uint256 tokenId
1474     ) internal virtual {
1475         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1476         require(to != address(0), "ERC721: transfer to the zero address");
1477 
1478         _beforeTokenTransfer(from, to, tokenId, 1);
1479 
1480         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1481         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1482 
1483         // Clear approvals from the previous owner
1484         delete _tokenApprovals[tokenId];
1485 
1486         unchecked {
1487             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1488             // `from`'s balance is the number of token held, which is at least one before the current
1489             // transfer.
1490             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1491             // all 2**256 token ids to be minted, which in practice is impossible.
1492             _balances[from] -= 1;
1493             _balances[to] += 1;
1494         }
1495         _owners[tokenId] = to;
1496 
1497         emit Transfer(from, to, tokenId);
1498 
1499         _afterTokenTransfer(from, to, tokenId, 1);
1500     }
1501 
1502     /**
1503      * @dev Approve `to` to operate on `tokenId`
1504      *
1505      * Emits an {Approval} event.
1506      */
1507     function _approve(address to, uint256 tokenId) internal virtual {
1508         _tokenApprovals[tokenId] = to;
1509         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1510     }
1511 
1512     /**
1513      * @dev Approve `operator` to operate on all of `owner` tokens
1514      *
1515      * Emits an {ApprovalForAll} event.
1516      */
1517     function _setApprovalForAll(
1518         address owner,
1519         address operator,
1520         bool approved
1521     ) internal virtual {
1522         require(owner != operator, "ERC721: approve to caller");
1523         _operatorApprovals[owner][operator] = approved;
1524         emit ApprovalForAll(owner, operator, approved);
1525     }
1526 
1527     /**
1528      * @dev Reverts if the `tokenId` has not been minted yet.
1529      */
1530     function _requireMinted(uint256 tokenId) internal view virtual {
1531         require(_exists(tokenId), "ERC721: invalid token ID");
1532     }
1533 
1534     /**
1535      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1536      * The call is not executed if the target address is not a contract.
1537      *
1538      * @param from address representing the previous owner of the given token ID
1539      * @param to target address that will receive the tokens
1540      * @param tokenId uint256 ID of the token to be transferred
1541      * @param data bytes optional data to send along with the call
1542      * @return bool whether the call correctly returned the expected magic value
1543      */
1544     function _checkOnERC721Received(
1545         address from,
1546         address to,
1547         uint256 tokenId,
1548         bytes memory data
1549     ) private returns (bool) {
1550         if (to.isContract()) {
1551             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1552                 return retval == IERC721Receiver.onERC721Received.selector;
1553             } catch (bytes memory reason) {
1554                 if (reason.length == 0) {
1555                     revert("ERC721: transfer to non ERC721Receiver implementer");
1556                 } else {
1557                     /// @solidity memory-safe-assembly
1558                     assembly {
1559                         revert(add(32, reason), mload(reason))
1560                     }
1561                 }
1562             }
1563         } else {
1564             return true;
1565         }
1566     }
1567 
1568     /**
1569      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1570      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1571      *
1572      * Calling conditions:
1573      *
1574      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1575      * - When `from` is zero, the tokens will be minted for `to`.
1576      * - When `to` is zero, ``from``'s tokens will be burned.
1577      * - `from` and `to` are never both zero.
1578      * - `batchSize` is non-zero.
1579      *
1580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1581      */
1582     function _beforeTokenTransfer(
1583         address from,
1584         address to,
1585         uint256, /* firstTokenId */
1586         uint256 batchSize
1587     ) internal virtual {
1588         if (batchSize > 1) {
1589             if (from != address(0)) {
1590                 _balances[from] -= batchSize;
1591             }
1592             if (to != address(0)) {
1593                 _balances[to] += batchSize;
1594             }
1595         }
1596     }
1597 
1598     /**
1599      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1600      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1601      *
1602      * Calling conditions:
1603      *
1604      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1605      * - When `from` is zero, the tokens were minted for `to`.
1606      * - When `to` is zero, ``from``'s tokens were burned.
1607      * - `from` and `to` are never both zero.
1608      * - `batchSize` is non-zero.
1609      *
1610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1611      */
1612     function _afterTokenTransfer(
1613         address from,
1614         address to,
1615         uint256 firstTokenId,
1616         uint256 batchSize
1617     ) internal virtual {}
1618 }
1619 
1620 error AllWhiteBagFull();
1621 error AllBagFull();
1622 
1623 contract ASTRO is ERC721, Ownable, DefaultOperatorFilterer {
1624 
1625     using Strings for uint256;
1626     uint private supply;
1627 
1628     bytes32 public merkleRoot;
1629 
1630     string public uriPrefix = "";
1631     string public uriSuffix = ".json";
1632     
1633     uint256 public pCost = 0.0088 ether;
1634     uint256 public wCost = 0.004 ether;
1635 
1636     uint256 public maxSupply = 5555;  
1637     
1638     uint public whitelistWalletLimit;   //as per requirement , whitelist user can mint from both sides
1639     uint public publicWalletLimit;
1640 
1641     bool public whitelistMintEnabled = false;
1642     bool public publicMintEnabled = false;
1643 
1644     mapping (address => uint256) public NftBagPb;
1645     mapping (address => uint256) public NftBagWL;
1646 
1647     constructor(uint _MaxPWallet,uint _MaxWWallet) ERC721("Astro Tales", "ASTRO") {
1648         setPublicwalletLimit(_MaxPWallet);
1649         setWhitewalletLimit(_MaxWWallet);
1650     }
1651 
1652      modifier mintCompliance(uint256 _mintAmount) {
1653         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1654         _;
1655     }
1656 
1657     modifier pmintPriceCompliance(uint256 _mintAmount) {
1658         require(msg.value >= pCost * _mintAmount, "Insufficient funds!");
1659         _;
1660     }
1661 
1662     modifier wmintPriceCompliance(uint256 _mintAmount) {
1663         require(msg.value >= wCost * _mintAmount, "Insufficient funds!");
1664         _;
1665     }
1666 
1667     function whitelistMint(bytes32[] calldata _merkleProof,uint256 _mintAmount) public payable mintCompliance(_mintAmount) wmintPriceCompliance(_mintAmount) {
1668         require(whitelistMintEnabled,"Whitelist Mint Paused!!");
1669         require(tx.origin == msg.sender,"Error: Invalid Caller!");
1670         require(_mintAmount <= whitelistWalletLimit, "Invalid mint amount!");
1671         address account = msg.sender;
1672         if(NftBagWL[account] + _mintAmount > whitelistWalletLimit) {
1673             revert AllWhiteBagFull();
1674         }
1675         bytes32 leaf = keccak256(abi.encodePacked(account));
1676         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof!");
1677         mint(account, _mintAmount);
1678         NftBagWL[account] += _mintAmount;
1679     }
1680 
1681     function publicMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) pmintPriceCompliance(_mintAmount) {
1682         require(publicMintEnabled,"Public Mint Paused!!");
1683         require(tx.origin == msg.sender,"Error: Invalid Caller!");
1684         require(_mintAmount <= publicWalletLimit, "Invalid mint amount!");
1685         address account = msg.sender;
1686         if(NftBagPb[account] + _mintAmount > publicWalletLimit) {
1687             revert AllBagFull();
1688         }
1689         mint(account, _mintAmount);
1690         NftBagPb[account] += _mintAmount;
1691     }
1692 
1693     function mintTeam(address _adr, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1694         mint(_adr, _mintAmount);
1695     }
1696 
1697     function mint(address _user, uint _unit) internal {
1698         for (uint256 i = 0; i < _unit; i++) {
1699             _safeMint(_user, supply);
1700             supply = supply + 1;    //coz nft start with zero index
1701         }
1702     }
1703 
1704     function walletOfOwner(address _owner)
1705         public
1706         view
1707         returns (uint256[] memory)
1708     {
1709         uint256 ownerTokenCount = balanceOf(_owner);
1710         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1711         uint256 currentTokenId = 0;
1712         uint256 ownedTokenIndex = 0;
1713 
1714         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= totalSupply()) {
1715             address currentTokenOwner = ownerOf(currentTokenId);
1716 
1717             if (currentTokenOwner == _owner) {
1718                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1719 
1720                 ownedTokenIndex++;
1721             }
1722 
1723             currentTokenId++;
1724         }
1725 
1726         return ownedTokenIds;
1727     }
1728 
1729     function tokenURI(uint256 tokenId)
1730         public
1731         view
1732         virtual
1733         override
1734         returns (string memory)
1735     {
1736         require(
1737         _exists(tokenId),
1738         "ERC721Metadata: URI query for nonexistent token"
1739         );
1740 
1741         string memory currentBaseURI = _baseURI();
1742         return bytes(currentBaseURI).length > 0
1743             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), uriSuffix))
1744             : "";
1745     }
1746 
1747     function enableDisableWhitelistMint(bool _status) public onlyOwner {
1748         whitelistMintEnabled = _status;
1749     }
1750 
1751     function enableDisablePublicMint(bool _status) public onlyOwner {
1752         publicMintEnabled = _status;
1753     }
1754 
1755     function setPsaleCost(uint256 _newcost) public onlyOwner {
1756         pCost = _newcost;
1757     }
1758 
1759     function setWsaleCost(uint256 _newcost) public onlyOwner {
1760         wCost = _newcost;
1761     }
1762 
1763     function setWhitewalletLimit(uint _value) public onlyOwner {
1764         whitelistWalletLimit = _value;
1765     }
1766 
1767     function setPublicwalletLimit(uint _value) public onlyOwner {
1768         publicWalletLimit = _value;
1769     }
1770 
1771     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1772         uriPrefix = _uriPrefix;
1773     }
1774 
1775     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1776         uriSuffix = _uriSuffix;
1777     }
1778 
1779     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1780         merkleRoot = _merkleRoot;
1781     }
1782     
1783     function totalSupply() public view returns (uint) {
1784         return supply;
1785     }
1786 
1787     function withdraw() public onlyOwner {
1788         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1789         require(os);
1790     }
1791 
1792     function _baseURI() internal view virtual override returns (string memory) {
1793         return uriPrefix;
1794     }
1795 
1796     // -------------------------  Opensea Royality Filter  -----------------------
1797 
1798     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
1799         super.transferFrom(from, to, tokenId);
1800     }
1801 
1802     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
1803         super.safeTransferFrom(from, to, tokenId);
1804     }
1805 
1806     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1807         public
1808         override
1809         onlyAllowedOperator
1810     {
1811         super.safeTransferFrom(from, to, tokenId, data);
1812     }
1813 
1814 }