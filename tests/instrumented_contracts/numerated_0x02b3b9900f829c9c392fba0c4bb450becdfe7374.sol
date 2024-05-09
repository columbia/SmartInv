1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
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
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         unchecked {
174             require(b <= a, errorMessage);
175             return a - b;
176         }
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         unchecked {
193             require(b > 0, errorMessage);
194             return a / b;
195         }
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * reverting with custom message when dividing by zero.
201      *
202      * CAUTION: This function is deprecated because it requires allocating memory for the error
203      * message unnecessarily. For custom revert reasons use {tryMod}.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         unchecked {
215             require(b > 0, errorMessage);
216             return a % b;
217         }
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Library for managing
230  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
231  * types.
232  *
233  * Sets have the following properties:
234  *
235  * - Elements are added, removed, and checked for existence in constant time
236  * (O(1)).
237  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
238  *
239  * ```
240  * contract Example {
241  *     // Add the library methods
242  *     using EnumerableSet for EnumerableSet.AddressSet;
243  *
244  *     // Declare a set state variable
245  *     EnumerableSet.AddressSet private mySet;
246  * }
247  * ```
248  *
249  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
250  * and `uint256` (`UintSet`) are supported.
251  *
252  * [WARNING]
253  * ====
254  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
255  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
256  *
257  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
258  * ====
259  */
260 library EnumerableSet {
261     // To implement this library for multiple types with as little code
262     // repetition as possible, we write it in terms of a generic Set type with
263     // bytes32 values.
264     // The Set implementation uses private functions, and user-facing
265     // implementations (such as AddressSet) are just wrappers around the
266     // underlying Set.
267     // This means that we can only create new EnumerableSets for types that fit
268     // in bytes32.
269 
270     struct Set {
271         // Storage of set values
272         bytes32[] _values;
273         // Position of the value in the `values` array, plus 1 because index 0
274         // means a value is not in the set.
275         mapping(bytes32 => uint256) _indexes;
276     }
277 
278     /**
279      * @dev Add a value to a set. O(1).
280      *
281      * Returns true if the value was added to the set, that is if it was not
282      * already present.
283      */
284     function _add(Set storage set, bytes32 value) private returns (bool) {
285         if (!_contains(set, value)) {
286             set._values.push(value);
287             // The value is stored at length-1, but we add 1 to all indexes
288             // and use 0 as a sentinel value
289             set._indexes[value] = set._values.length;
290             return true;
291         } else {
292             return false;
293         }
294     }
295 
296     /**
297      * @dev Removes a value from a set. O(1).
298      *
299      * Returns true if the value was removed from the set, that is if it was
300      * present.
301      */
302     function _remove(Set storage set, bytes32 value) private returns (bool) {
303         // We read and store the value's index to prevent multiple reads from the same storage slot
304         uint256 valueIndex = set._indexes[value];
305 
306         if (valueIndex != 0) {
307             // Equivalent to contains(set, value)
308             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
309             // the array, and then remove the last element (sometimes called as 'swap and pop').
310             // This modifies the order of the array, as noted in {at}.
311 
312             uint256 toDeleteIndex = valueIndex - 1;
313             uint256 lastIndex = set._values.length - 1;
314 
315             if (lastIndex != toDeleteIndex) {
316                 bytes32 lastValue = set._values[lastIndex];
317 
318                 // Move the last value to the index where the value to delete is
319                 set._values[toDeleteIndex] = lastValue;
320                 // Update the index for the moved value
321                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
322             }
323 
324             // Delete the slot where the moved value was stored
325             set._values.pop();
326 
327             // Delete the index for the deleted slot
328             delete set._indexes[value];
329 
330             return true;
331         } else {
332             return false;
333         }
334     }
335 
336     /**
337      * @dev Returns true if the value is in the set. O(1).
338      */
339     function _contains(Set storage set, bytes32 value) private view returns (bool) {
340         return set._indexes[value] != 0;
341     }
342 
343     /**
344      * @dev Returns the number of values on the set. O(1).
345      */
346     function _length(Set storage set) private view returns (uint256) {
347         return set._values.length;
348     }
349 
350     /**
351      * @dev Returns the value stored at position `index` in the set. O(1).
352      *
353      * Note that there are no guarantees on the ordering of values inside the
354      * array, and it may change when more values are added or removed.
355      *
356      * Requirements:
357      *
358      * - `index` must be strictly less than {length}.
359      */
360     function _at(Set storage set, uint256 index) private view returns (bytes32) {
361         return set._values[index];
362     }
363 
364     /**
365      * @dev Return the entire set in an array
366      *
367      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
368      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
369      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
370      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
371      */
372     function _values(Set storage set) private view returns (bytes32[] memory) {
373         return set._values;
374     }
375 
376     // Bytes32Set
377 
378     struct Bytes32Set {
379         Set _inner;
380     }
381 
382     /**
383      * @dev Add a value to a set. O(1).
384      *
385      * Returns true if the value was added to the set, that is if it was not
386      * already present.
387      */
388     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
389         return _add(set._inner, value);
390     }
391 
392     /**
393      * @dev Removes a value from a set. O(1).
394      *
395      * Returns true if the value was removed from the set, that is if it was
396      * present.
397      */
398     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
399         return _remove(set._inner, value);
400     }
401 
402     /**
403      * @dev Returns true if the value is in the set. O(1).
404      */
405     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
406         return _contains(set._inner, value);
407     }
408 
409     /**
410      * @dev Returns the number of values in the set. O(1).
411      */
412     function length(Bytes32Set storage set) internal view returns (uint256) {
413         return _length(set._inner);
414     }
415 
416     /**
417      * @dev Returns the value stored at position `index` in the set. O(1).
418      *
419      * Note that there are no guarantees on the ordering of values inside the
420      * array, and it may change when more values are added or removed.
421      *
422      * Requirements:
423      *
424      * - `index` must be strictly less than {length}.
425      */
426     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
427         return _at(set._inner, index);
428     }
429 
430     /**
431      * @dev Return the entire set in an array
432      *
433      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
434      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
435      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
436      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
437      */
438     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
439         return _values(set._inner);
440     }
441 
442     // AddressSet
443 
444     struct AddressSet {
445         Set _inner;
446     }
447 
448     /**
449      * @dev Add a value to a set. O(1).
450      *
451      * Returns true if the value was added to the set, that is if it was not
452      * already present.
453      */
454     function add(AddressSet storage set, address value) internal returns (bool) {
455         return _add(set._inner, bytes32(uint256(uint160(value))));
456     }
457 
458     /**
459      * @dev Removes a value from a set. O(1).
460      *
461      * Returns true if the value was removed from the set, that is if it was
462      * present.
463      */
464     function remove(AddressSet storage set, address value) internal returns (bool) {
465         return _remove(set._inner, bytes32(uint256(uint160(value))));
466     }
467 
468     /**
469      * @dev Returns true if the value is in the set. O(1).
470      */
471     function contains(AddressSet storage set, address value) internal view returns (bool) {
472         return _contains(set._inner, bytes32(uint256(uint160(value))));
473     }
474 
475     /**
476      * @dev Returns the number of values in the set. O(1).
477      */
478     function length(AddressSet storage set) internal view returns (uint256) {
479         return _length(set._inner);
480     }
481 
482     /**
483      * @dev Returns the value stored at position `index` in the set. O(1).
484      *
485      * Note that there are no guarantees on the ordering of values inside the
486      * array, and it may change when more values are added or removed.
487      *
488      * Requirements:
489      *
490      * - `index` must be strictly less than {length}.
491      */
492     function at(AddressSet storage set, uint256 index) internal view returns (address) {
493         return address(uint160(uint256(_at(set._inner, index))));
494     }
495 
496     /**
497      * @dev Return the entire set in an array
498      *
499      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
500      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
501      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
502      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
503      */
504     function values(AddressSet storage set) internal view returns (address[] memory) {
505         bytes32[] memory store = _values(set._inner);
506         address[] memory result;
507 
508         /// @solidity memory-safe-assembly
509         assembly {
510             result := store
511         }
512 
513         return result;
514     }
515 
516     // UintSet
517 
518     struct UintSet {
519         Set _inner;
520     }
521 
522     /**
523      * @dev Add a value to a set. O(1).
524      *
525      * Returns true if the value was added to the set, that is if it was not
526      * already present.
527      */
528     function add(UintSet storage set, uint256 value) internal returns (bool) {
529         return _add(set._inner, bytes32(value));
530     }
531 
532     /**
533      * @dev Removes a value from a set. O(1).
534      *
535      * Returns true if the value was removed from the set, that is if it was
536      * present.
537      */
538     function remove(UintSet storage set, uint256 value) internal returns (bool) {
539         return _remove(set._inner, bytes32(value));
540     }
541 
542     /**
543      * @dev Returns true if the value is in the set. O(1).
544      */
545     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
546         return _contains(set._inner, bytes32(value));
547     }
548 
549     /**
550      * @dev Returns the number of values on the set. O(1).
551      */
552     function length(UintSet storage set) internal view returns (uint256) {
553         return _length(set._inner);
554     }
555 
556     /**
557      * @dev Returns the value stored at position `index` in the set. O(1).
558      *
559      * Note that there are no guarantees on the ordering of values inside the
560      * array, and it may change when more values are added or removed.
561      *
562      * Requirements:
563      *
564      * - `index` must be strictly less than {length}.
565      */
566     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
567         return uint256(_at(set._inner, index));
568     }
569 
570     /**
571      * @dev Return the entire set in an array
572      *
573      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
574      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
575      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
576      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
577      */
578     function values(UintSet storage set) internal view returns (uint256[] memory) {
579         bytes32[] memory store = _values(set._inner);
580         uint256[] memory result;
581 
582         /// @solidity memory-safe-assembly
583         assembly {
584             result := store
585         }
586 
587         return result;
588     }
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
592 
593 
594 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @title ERC721 token receiver interface
600  * @dev Interface for any contract that wants to support safeTransfers
601  * from ERC721 asset contracts.
602  */
603 interface IERC721Receiver {
604     /**
605      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
606      * by `operator` from `from`, this function is called.
607      *
608      * It must return its Solidity selector to confirm the token transfer.
609      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
610      *
611      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
612      */
613     function onERC721Received(
614         address operator,
615         address from,
616         uint256 tokenId,
617         bytes calldata data
618     ) external returns (bytes4);
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Implementation of the {IERC721Receiver} interface.
631  *
632  * Accepts all token transfers.
633  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
634  */
635 contract ERC721Holder is IERC721Receiver {
636     /**
637      * @dev See {IERC721Receiver-onERC721Received}.
638      *
639      * Always returns `IERC721Receiver.onERC721Received.selector`.
640      */
641     function onERC721Received(
642         address,
643         address,
644         uint256,
645         bytes memory
646     ) public virtual override returns (bytes4) {
647         return this.onERC721Received.selector;
648     }
649 }
650 
651 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Interface of the ERC165 standard, as defined in the
660  * https://eips.ethereum.org/EIPS/eip-165[EIP].
661  *
662  * Implementers can declare support of contract interfaces, which can then be
663  * queried by others ({ERC165Checker}).
664  *
665  * For an implementation, see {ERC165}.
666  */
667 interface IERC165 {
668     /**
669      * @dev Returns true if this contract implements the interface defined by
670      * `interfaceId`. See the corresponding
671      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
672      * to learn more about how these ids are created.
673      *
674      * This function call must use less than 30 000 gas.
675      */
676     function supportsInterface(bytes4 interfaceId) external view returns (bool);
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
680 
681 
682 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @dev Required interface of an ERC721 compliant contract.
689  */
690 interface IERC721 is IERC165 {
691     /**
692      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
693      */
694     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
695 
696     /**
697      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
698      */
699     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
700 
701     /**
702      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
703      */
704     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
705 
706     /**
707      * @dev Returns the number of tokens in ``owner``'s account.
708      */
709     function balanceOf(address owner) external view returns (uint256 balance);
710 
711     /**
712      * @dev Returns the owner of the `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function ownerOf(uint256 tokenId) external view returns (address owner);
719 
720     /**
721      * @dev Safely transfers `tokenId` token from `from` to `to`.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `tokenId` token must exist and be owned by `from`.
728      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730      *
731      * Emits a {Transfer} event.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId,
737         bytes calldata data
738     ) external;
739 
740     /**
741      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
742      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) external;
759 
760     /**
761      * @dev Transfers `tokenId` token from `from` to `to`.
762      *
763      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must be owned by `from`.
770      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
771      *
772      * Emits a {Transfer} event.
773      */
774     function transferFrom(
775         address from,
776         address to,
777         uint256 tokenId
778     ) external;
779 
780     /**
781      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
782      * The approval is cleared when the token is transferred.
783      *
784      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
785      *
786      * Requirements:
787      *
788      * - The caller must own the token or be an approved operator.
789      * - `tokenId` must exist.
790      *
791      * Emits an {Approval} event.
792      */
793     function approve(address to, uint256 tokenId) external;
794 
795     /**
796      * @dev Approve or remove `operator` as an operator for the caller.
797      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
798      *
799      * Requirements:
800      *
801      * - The `operator` cannot be the caller.
802      *
803      * Emits an {ApprovalForAll} event.
804      */
805     function setApprovalForAll(address operator, bool _approved) external;
806 
807     /**
808      * @dev Returns the account approved for `tokenId` token.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function getApproved(uint256 tokenId) external view returns (address operator);
815 
816     /**
817      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
818      *
819      * See {setApprovalForAll}
820      */
821     function isApprovedForAll(address owner, address operator) external view returns (bool);
822 }
823 
824 // File: @openzeppelin/contracts/utils/Context.sol
825 
826 
827 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
828 
829 pragma solidity ^0.8.0;
830 
831 /**
832  * @dev Provides information about the current execution context, including the
833  * sender of the transaction and its data. While these are generally available
834  * via msg.sender and msg.data, they should not be accessed in such a direct
835  * manner, since when dealing with meta-transactions the account sending and
836  * paying for execution may not be the actual sender (as far as an application
837  * is concerned).
838  *
839  * This contract is only required for intermediate, library-like contracts.
840  */
841 abstract contract Context {
842     function _msgSender() internal view virtual returns (address) {
843         return msg.sender;
844     }
845 
846     function _msgData() internal view virtual returns (bytes calldata) {
847         return msg.data;
848     }
849 }
850 
851 // File: @openzeppelin/contracts/access/Ownable.sol
852 
853 
854 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
855 
856 pragma solidity ^0.8.0;
857 
858 
859 /**
860  * @dev Contract module which provides a basic access control mechanism, where
861  * there is an account (an owner) that can be granted exclusive access to
862  * specific functions.
863  *
864  * By default, the owner account will be the one that deploys the contract. This
865  * can later be changed with {transferOwnership}.
866  *
867  * This module is used through inheritance. It will make available the modifier
868  * `onlyOwner`, which can be applied to your functions to restrict their use to
869  * the owner.
870  */
871 abstract contract Ownable is Context {
872     address private _owner;
873 
874     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
875 
876     /**
877      * @dev Initializes the contract setting the deployer as the initial owner.
878      */
879     constructor() {
880         _transferOwnership(_msgSender());
881     }
882 
883     /**
884      * @dev Throws if called by any account other than the owner.
885      */
886     modifier onlyOwner() {
887         _checkOwner();
888         _;
889     }
890 
891     /**
892      * @dev Returns the address of the current owner.
893      */
894     function owner() public view virtual returns (address) {
895         return _owner;
896     }
897 
898     /**
899      * @dev Throws if the sender is not the owner.
900      */
901     function _checkOwner() internal view virtual {
902         require(owner() == _msgSender(), "Ownable: caller is not the owner");
903     }
904 
905     /**
906      * @dev Leaves the contract without owner. It will not be possible to call
907      * `onlyOwner` functions anymore. Can only be called by the current owner.
908      *
909      * NOTE: Renouncing ownership will leave the contract without an owner,
910      * thereby removing any functionality that is only available to the owner.
911      */
912     function renounceOwnership() public virtual onlyOwner {
913         _transferOwnership(address(0));
914     }
915 
916     /**
917      * @dev Transfers ownership of the contract to a new account (`newOwner`).
918      * Can only be called by the current owner.
919      */
920     function transferOwnership(address newOwner) public virtual onlyOwner {
921         require(newOwner != address(0), "Ownable: new owner is the zero address");
922         _transferOwnership(newOwner);
923     }
924 
925     /**
926      * @dev Transfers ownership of the contract to a new account (`newOwner`).
927      * Internal function without access restriction.
928      */
929     function _transferOwnership(address newOwner) internal virtual {
930         address oldOwner = _owner;
931         _owner = newOwner;
932         emit OwnershipTransferred(oldOwner, newOwner);
933     }
934 }
935 
936 // File: contracts/EternalsStaking.sol
937 
938 
939 
940 pragma solidity ^0.8.11;
941 
942 
943 
944 
945 
946 
947 contract Staking is ERC721Holder, Ownable {
948     using EnumerableSet for EnumerableSet.UintSet;
949     using SafeMath for uint256;
950 
951     struct Staker {
952         EnumerableSet.UintSet tokenIds;
953         uint256 amount;
954     }
955 
956     struct StakedNft {
957         uint256 timestamp;
958         uint256 stakedTime;
959         uint256 lockedTime;
960     }
961 
962     struct Collection {
963         IERC721 NFT;
964         uint256 lockTime;
965         mapping(address => Staker) Stakers;
966         mapping(uint256 => StakedNft) StakedNfts;
967         mapping(uint256 => address) StakerAddresses;
968     }
969 
970     Collection[] public nftPools;
971 
972     constructor() {}
973 
974     event Stake(address indexed owner, uint256 id, uint256 time);
975     event Unstake(address indexed owner, uint256 id, uint256 time);
976 
977     function stakeNFT(uint256 _tokenId, uint256 _poolId) public {
978         require(_poolId < nftPools.length, "Pool does not exist!");
979         Collection storage pool = nftPools[_poolId];
980         require(pool.NFT.balanceOf(msg.sender) >= 1, "Insufficient NFTs");
981         require(pool.NFT.ownerOf(_tokenId) == msg.sender, "NFT not owned");
982 
983         pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.add(1);
984         pool.Stakers[msg.sender].tokenIds.add(_tokenId);
985 
986         StakedNft storage stakedNft = pool.StakedNfts[_tokenId];
987         stakedNft.lockedTime = block.timestamp.add(pool.lockTime);
988         stakedNft.timestamp = block.timestamp;
989         stakedNft.stakedTime = block.timestamp;
990 
991         pool.StakerAddresses[_tokenId] = msg.sender;
992 
993         pool.NFT.safeTransferFrom(msg.sender, address(this), _tokenId);
994 
995         emit Stake(msg.sender, _tokenId, block.timestamp);
996     }
997 
998     function batchStakeNFT(uint256[] memory _tokenIds, uint256 _poolId) public {
999         require(_poolId < nftPools.length, "Pool does not exist!");
1000         Collection storage pool = nftPools[_poolId];
1001         require(pool.NFT.balanceOf(msg.sender) >= _tokenIds.length, "Insufficient NFTs");
1002 
1003         for(uint i = 0; i < _tokenIds.length; i++) {
1004             require(pool.NFT.ownerOf(_tokenIds[i]) == msg.sender, "NFT not owned");
1005             pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.add(1);
1006             pool.Stakers[msg.sender].tokenIds.add(_tokenIds[i]);
1007 
1008             StakedNft storage stakedNft = pool.StakedNfts[_tokenIds[i]];
1009             stakedNft.lockedTime = block.timestamp.add(pool.lockTime);
1010             stakedNft.timestamp = block.timestamp;
1011             stakedNft.stakedTime = block.timestamp;
1012 
1013             pool.StakerAddresses[_tokenIds[i]] = msg.sender;
1014             pool.NFT.safeTransferFrom(msg.sender, address(this), _tokenIds[i]);
1015 
1016             emit Stake(msg.sender, _tokenIds[i], block.timestamp);
1017         }
1018     }
1019 
1020     function unstakeNFT(uint256 _tokenId, uint256 _poolId) public {
1021         require(_poolId < nftPools.length, "Pool does not exist!");
1022         Collection storage pool = nftPools[_poolId];
1023         require(block.timestamp >= pool.StakedNfts[_tokenId].lockedTime, "NFT locked for withdrawal");
1024         require(pool.Stakers[msg.sender].amount > 0, "No staked NFTs");
1025         require(pool.StakerAddresses[_tokenId] == msg.sender, "Token not owned");
1026 
1027         pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.sub(1);
1028         pool.StakerAddresses[_tokenId] = address(0);
1029         pool.Stakers[msg.sender].tokenIds.remove(_tokenId);
1030 
1031         pool.NFT.safeTransferFrom(address(this), msg.sender, _tokenId);
1032 
1033         emit Unstake(msg.sender, _tokenId, block.timestamp);
1034     }
1035 
1036     function batchUnstakeNFT(uint256[] memory _tokenIds, uint256 _poolId) public {
1037         require(_poolId < nftPools.length, "Pool does not exist!");
1038         Collection storage pool = nftPools[_poolId];
1039         require(pool.Stakers[msg.sender].amount >= _tokenIds.length, "Not enough staked NFTs");
1040 
1041         for (uint i = 0; i < _tokenIds.length; i++) {
1042             if(pool.StakerAddresses[_tokenIds[i]] == msg.sender && block.timestamp >= pool.StakedNfts[_tokenIds[i]].lockedTime) {
1043                 pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.sub(1);
1044                 pool.StakerAddresses[_tokenIds[i]] = address(0);
1045                 pool.Stakers[msg.sender].tokenIds.remove(_tokenIds[i]);
1046 
1047                 pool.NFT.safeTransferFrom(address(this), msg.sender, _tokenIds[i]);
1048 
1049                 emit Unstake(msg.sender, _tokenIds[i], block.timestamp);
1050             }
1051         }
1052     }
1053 
1054     function claimRewards(uint256 _tokenId, uint256 _poolId) public {
1055         require(_poolId < nftPools.length, "Pool does not exist!");
1056         Collection storage pool = nftPools[_poolId];
1057         require(pool.Stakers[msg.sender].amount > 0, "No staked NFTs");
1058         require(pool.StakerAddresses[_tokenId] == msg.sender, "Token not owned");
1059 
1060         pool.StakedNfts[_tokenId].timestamp = block.timestamp;        
1061     }
1062 
1063     function addPool(address _nftAddress, uint256 _lockTime) external onlyOwner {
1064         Collection storage newCollection = nftPools.push();
1065         newCollection.NFT = IERC721(_nftAddress);
1066         newCollection.lockTime = _lockTime;
1067     }
1068 
1069     function getPool(uint256 _poolId) public view returns(IERC721, uint256) {
1070         require(_poolId < nftPools.length, "Pool does not exist!");
1071         Collection storage pool = nftPools[_poolId];
1072         return (pool.NFT, pool.lockTime);
1073     }
1074 
1075     function getStakedNft(uint256 _tokenId, uint256 _poolId) public view returns(uint256, uint256, uint256) {
1076         require(_poolId < nftPools.length, "Pool does not exist!");
1077         Collection storage pool = nftPools[_poolId];
1078         StakedNft storage stakedNft = pool.StakedNfts[_tokenId];
1079         return (stakedNft.timestamp, stakedNft.lockedTime, stakedNft.stakedTime);
1080     }
1081 
1082     function getStakerInfo(address _stakerAddress, uint256 _poolId) public view returns(uint256, uint256[] memory) {
1083         require(_poolId < nftPools.length, "Pool does not exist!");
1084         Collection storage pool = nftPools[_poolId];
1085         Staker storage staker = pool.Stakers[_stakerAddress];
1086 
1087         uint256[] memory stakedTokenIds = new uint256[](staker.tokenIds.length());
1088         for(uint i = 0; i < staker.tokenIds.length(); i++){
1089             stakedTokenIds[i] = staker.tokenIds.at(i);
1090         }
1091 
1092         return (staker.amount, stakedTokenIds);
1093     }
1094 
1095     function getStakedTokenOwner(uint256 _tokenId, uint256 _poolId) public view returns(address) {
1096         require(_poolId < nftPools.length, "Pool does not exist!");
1097         Collection storage pool = nftPools[_poolId];
1098         return pool.StakerAddresses[_tokenId];
1099     }
1100 
1101     function getPoolSize() public view returns(uint256) {
1102         return nftPools.length;
1103     }
1104 }