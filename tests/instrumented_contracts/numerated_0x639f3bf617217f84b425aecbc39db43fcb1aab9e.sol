1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
88 
89 
90 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 // CAUTION
95 // This version of SafeMath should only be used with Solidity 0.8 or later,
96 // because it relies on the compiler's built in overflow checks.
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations.
100  *
101  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
102  * now has built in overflow checking.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, with an overflow flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             uint256 c = a + b;
113             if (c < a) return (false, 0);
114             return (true, c);
115         }
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         unchecked {
125             if (b > a) return (false, 0);
126             return (true, a - b);
127         }
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
132      *
133      * _Available since v3.4._
134      */
135     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         unchecked {
137             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138             // benefit is lost if 'b' is also tested.
139             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140             if (a == 0) return (true, 0);
141             uint256 c = a * b;
142             if (c / a != b) return (false, 0);
143             return (true, c);
144         }
145     }
146 
147     /**
148      * @dev Returns the division of two unsigned integers, with a division by zero flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         unchecked {
154             if (b == 0) return (false, 0);
155             return (true, a / b);
156         }
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         unchecked {
166             if (b == 0) return (false, 0);
167             return (true, a % b);
168         }
169     }
170 
171     /**
172      * @dev Returns the addition of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `+` operator.
176      *
177      * Requirements:
178      *
179      * - Addition cannot overflow.
180      */
181     function add(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a + b;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a - b;
197     }
198 
199     /**
200      * @dev Returns the multiplication of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `*` operator.
204      *
205      * Requirements:
206      *
207      * - Multiplication cannot overflow.
208      */
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a * b;
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers, reverting on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator.
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a / b;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * reverting when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return a % b;
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245      * overflow (when the result is negative).
246      *
247      * CAUTION: This function is deprecated because it requires allocating memory for the error
248      * message unnecessarily. For custom revert reasons use {trySub}.
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      *
254      * - Subtraction cannot overflow.
255      */
256     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         unchecked {
258             require(b <= a, errorMessage);
259             return a - b;
260         }
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         unchecked {
277             require(b > 0, errorMessage);
278             return a / b;
279         }
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * reverting with custom message when dividing by zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryMod}.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         unchecked {
299             require(b > 0, errorMessage);
300             return a % b;
301         }
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
306 
307 
308 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Library for managing
314  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
315  * types.
316  *
317  * Sets have the following properties:
318  *
319  * - Elements are added, removed, and checked for existence in constant time
320  * (O(1)).
321  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
322  *
323  * ```
324  * contract Example {
325  *     // Add the library methods
326  *     using EnumerableSet for EnumerableSet.AddressSet;
327  *
328  *     // Declare a set state variable
329  *     EnumerableSet.AddressSet private mySet;
330  * }
331  * ```
332  *
333  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
334  * and `uint256` (`UintSet`) are supported.
335  *
336  * [WARNING]
337  * ====
338  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
339  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
340  *
341  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
342  * ====
343  */
344 library EnumerableSet {
345     // To implement this library for multiple types with as little code
346     // repetition as possible, we write it in terms of a generic Set type with
347     // bytes32 values.
348     // The Set implementation uses private functions, and user-facing
349     // implementations (such as AddressSet) are just wrappers around the
350     // underlying Set.
351     // This means that we can only create new EnumerableSets for types that fit
352     // in bytes32.
353 
354     struct Set {
355         // Storage of set values
356         bytes32[] _values;
357         // Position of the value in the `values` array, plus 1 because index 0
358         // means a value is not in the set.
359         mapping(bytes32 => uint256) _indexes;
360     }
361 
362     /**
363      * @dev Add a value to a set. O(1).
364      *
365      * Returns true if the value was added to the set, that is if it was not
366      * already present.
367      */
368     function _add(Set storage set, bytes32 value) private returns (bool) {
369         if (!_contains(set, value)) {
370             set._values.push(value);
371             // The value is stored at length-1, but we add 1 to all indexes
372             // and use 0 as a sentinel value
373             set._indexes[value] = set._values.length;
374             return true;
375         } else {
376             return false;
377         }
378     }
379 
380     /**
381      * @dev Removes a value from a set. O(1).
382      *
383      * Returns true if the value was removed from the set, that is if it was
384      * present.
385      */
386     function _remove(Set storage set, bytes32 value) private returns (bool) {
387         // We read and store the value's index to prevent multiple reads from the same storage slot
388         uint256 valueIndex = set._indexes[value];
389 
390         if (valueIndex != 0) {
391             // Equivalent to contains(set, value)
392             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
393             // the array, and then remove the last element (sometimes called as 'swap and pop').
394             // This modifies the order of the array, as noted in {at}.
395 
396             uint256 toDeleteIndex = valueIndex - 1;
397             uint256 lastIndex = set._values.length - 1;
398 
399             if (lastIndex != toDeleteIndex) {
400                 bytes32 lastValue = set._values[lastIndex];
401 
402                 // Move the last value to the index where the value to delete is
403                 set._values[toDeleteIndex] = lastValue;
404                 // Update the index for the moved value
405                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
406             }
407 
408             // Delete the slot where the moved value was stored
409             set._values.pop();
410 
411             // Delete the index for the deleted slot
412             delete set._indexes[value];
413 
414             return true;
415         } else {
416             return false;
417         }
418     }
419 
420     /**
421      * @dev Returns true if the value is in the set. O(1).
422      */
423     function _contains(Set storage set, bytes32 value) private view returns (bool) {
424         return set._indexes[value] != 0;
425     }
426 
427     /**
428      * @dev Returns the number of values on the set. O(1).
429      */
430     function _length(Set storage set) private view returns (uint256) {
431         return set._values.length;
432     }
433 
434     /**
435      * @dev Returns the value stored at position `index` in the set. O(1).
436      *
437      * Note that there are no guarantees on the ordering of values inside the
438      * array, and it may change when more values are added or removed.
439      *
440      * Requirements:
441      *
442      * - `index` must be strictly less than {length}.
443      */
444     function _at(Set storage set, uint256 index) private view returns (bytes32) {
445         return set._values[index];
446     }
447 
448     /**
449      * @dev Return the entire set in an array
450      *
451      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
452      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
453      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
454      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
455      */
456     function _values(Set storage set) private view returns (bytes32[] memory) {
457         return set._values;
458     }
459 
460     // Bytes32Set
461 
462     struct Bytes32Set {
463         Set _inner;
464     }
465 
466     /**
467      * @dev Add a value to a set. O(1).
468      *
469      * Returns true if the value was added to the set, that is if it was not
470      * already present.
471      */
472     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
473         return _add(set._inner, value);
474     }
475 
476     /**
477      * @dev Removes a value from a set. O(1).
478      *
479      * Returns true if the value was removed from the set, that is if it was
480      * present.
481      */
482     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
483         return _remove(set._inner, value);
484     }
485 
486     /**
487      * @dev Returns true if the value is in the set. O(1).
488      */
489     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
490         return _contains(set._inner, value);
491     }
492 
493     /**
494      * @dev Returns the number of values in the set. O(1).
495      */
496     function length(Bytes32Set storage set) internal view returns (uint256) {
497         return _length(set._inner);
498     }
499 
500     /**
501      * @dev Returns the value stored at position `index` in the set. O(1).
502      *
503      * Note that there are no guarantees on the ordering of values inside the
504      * array, and it may change when more values are added or removed.
505      *
506      * Requirements:
507      *
508      * - `index` must be strictly less than {length}.
509      */
510     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
511         return _at(set._inner, index);
512     }
513 
514     /**
515      * @dev Return the entire set in an array
516      *
517      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
518      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
519      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
520      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
521      */
522     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
523         return _values(set._inner);
524     }
525 
526     // AddressSet
527 
528     struct AddressSet {
529         Set _inner;
530     }
531 
532     /**
533      * @dev Add a value to a set. O(1).
534      *
535      * Returns true if the value was added to the set, that is if it was not
536      * already present.
537      */
538     function add(AddressSet storage set, address value) internal returns (bool) {
539         return _add(set._inner, bytes32(uint256(uint160(value))));
540     }
541 
542     /**
543      * @dev Removes a value from a set. O(1).
544      *
545      * Returns true if the value was removed from the set, that is if it was
546      * present.
547      */
548     function remove(AddressSet storage set, address value) internal returns (bool) {
549         return _remove(set._inner, bytes32(uint256(uint160(value))));
550     }
551 
552     /**
553      * @dev Returns true if the value is in the set. O(1).
554      */
555     function contains(AddressSet storage set, address value) internal view returns (bool) {
556         return _contains(set._inner, bytes32(uint256(uint160(value))));
557     }
558 
559     /**
560      * @dev Returns the number of values in the set. O(1).
561      */
562     function length(AddressSet storage set) internal view returns (uint256) {
563         return _length(set._inner);
564     }
565 
566     /**
567      * @dev Returns the value stored at position `index` in the set. O(1).
568      *
569      * Note that there are no guarantees on the ordering of values inside the
570      * array, and it may change when more values are added or removed.
571      *
572      * Requirements:
573      *
574      * - `index` must be strictly less than {length}.
575      */
576     function at(AddressSet storage set, uint256 index) internal view returns (address) {
577         return address(uint160(uint256(_at(set._inner, index))));
578     }
579 
580     /**
581      * @dev Return the entire set in an array
582      *
583      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
584      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
585      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
586      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
587      */
588     function values(AddressSet storage set) internal view returns (address[] memory) {
589         bytes32[] memory store = _values(set._inner);
590         address[] memory result;
591 
592         /// @solidity memory-safe-assembly
593         assembly {
594             result := store
595         }
596 
597         return result;
598     }
599 
600     // UintSet
601 
602     struct UintSet {
603         Set _inner;
604     }
605 
606     /**
607      * @dev Add a value to a set. O(1).
608      *
609      * Returns true if the value was added to the set, that is if it was not
610      * already present.
611      */
612     function add(UintSet storage set, uint256 value) internal returns (bool) {
613         return _add(set._inner, bytes32(value));
614     }
615 
616     /**
617      * @dev Removes a value from a set. O(1).
618      *
619      * Returns true if the value was removed from the set, that is if it was
620      * present.
621      */
622     function remove(UintSet storage set, uint256 value) internal returns (bool) {
623         return _remove(set._inner, bytes32(value));
624     }
625 
626     /**
627      * @dev Returns true if the value is in the set. O(1).
628      */
629     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
630         return _contains(set._inner, bytes32(value));
631     }
632 
633     /**
634      * @dev Returns the number of values on the set. O(1).
635      */
636     function length(UintSet storage set) internal view returns (uint256) {
637         return _length(set._inner);
638     }
639 
640     /**
641      * @dev Returns the value stored at position `index` in the set. O(1).
642      *
643      * Note that there are no guarantees on the ordering of values inside the
644      * array, and it may change when more values are added or removed.
645      *
646      * Requirements:
647      *
648      * - `index` must be strictly less than {length}.
649      */
650     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
651         return uint256(_at(set._inner, index));
652     }
653 
654     /**
655      * @dev Return the entire set in an array
656      *
657      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
658      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
659      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
660      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
661      */
662     function values(UintSet storage set) internal view returns (uint256[] memory) {
663         bytes32[] memory store = _values(set._inner);
664         uint256[] memory result;
665 
666         /// @solidity memory-safe-assembly
667         assembly {
668             result := store
669         }
670 
671         return result;
672     }
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
676 
677 
678 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @title ERC721 token receiver interface
684  * @dev Interface for any contract that wants to support safeTransfers
685  * from ERC721 asset contracts.
686  */
687 interface IERC721Receiver {
688     /**
689      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
690      * by `operator` from `from`, this function is called.
691      *
692      * It must return its Solidity selector to confirm the token transfer.
693      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
694      *
695      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
696      */
697     function onERC721Received(
698         address operator,
699         address from,
700         uint256 tokenId,
701         bytes calldata data
702     ) external returns (bytes4);
703 }
704 
705 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
706 
707 
708 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @dev Implementation of the {IERC721Receiver} interface.
715  *
716  * Accepts all token transfers.
717  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
718  */
719 contract ERC721Holder is IERC721Receiver {
720     /**
721      * @dev See {IERC721Receiver-onERC721Received}.
722      *
723      * Always returns `IERC721Receiver.onERC721Received.selector`.
724      */
725     function onERC721Received(
726         address,
727         address,
728         uint256,
729         bytes memory
730     ) public virtual override returns (bytes4) {
731         return this.onERC721Received.selector;
732     }
733 }
734 
735 // File: @openzeppelin/contracts/utils/Strings.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 /**
743  * @dev String operations.
744  */
745 library Strings {
746     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
747 
748     /**
749      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
750      */
751     function toString(uint256 value) internal pure returns (string memory) {
752         // Inspired by OraclizeAPI's implementation - MIT licence
753         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
754 
755         if (value == 0) {
756             return "0";
757         }
758         uint256 temp = value;
759         uint256 digits;
760         while (temp != 0) {
761             digits++;
762             temp /= 10;
763         }
764         bytes memory buffer = new bytes(digits);
765         while (value != 0) {
766             digits -= 1;
767             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
768             value /= 10;
769         }
770         return string(buffer);
771     }
772 
773     /**
774      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
775      */
776     function toHexString(uint256 value) internal pure returns (string memory) {
777         if (value == 0) {
778             return "0x00";
779         }
780         uint256 temp = value;
781         uint256 length = 0;
782         while (temp != 0) {
783             length++;
784             temp >>= 8;
785         }
786         return toHexString(value, length);
787     }
788 
789     /**
790      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
791      */
792     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
793         bytes memory buffer = new bytes(2 * length + 2);
794         buffer[0] = "0";
795         buffer[1] = "x";
796         for (uint256 i = 2 * length + 1; i > 1; --i) {
797             buffer[i] = _HEX_SYMBOLS[value & 0xf];
798             value >>= 4;
799         }
800         require(value == 0, "Strings: hex length insufficient");
801         return string(buffer);
802     }
803 }
804 
805 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
806 
807 
808 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 
813 /**
814  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
815  *
816  * These functions can be used to verify that a message was signed by the holder
817  * of the private keys of a given address.
818  */
819 library ECDSA {
820     enum RecoverError {
821         NoError,
822         InvalidSignature,
823         InvalidSignatureLength,
824         InvalidSignatureS,
825         InvalidSignatureV
826     }
827 
828     function _throwError(RecoverError error) private pure {
829         if (error == RecoverError.NoError) {
830             return; // no error: do nothing
831         } else if (error == RecoverError.InvalidSignature) {
832             revert("ECDSA: invalid signature");
833         } else if (error == RecoverError.InvalidSignatureLength) {
834             revert("ECDSA: invalid signature length");
835         } else if (error == RecoverError.InvalidSignatureS) {
836             revert("ECDSA: invalid signature 's' value");
837         } else if (error == RecoverError.InvalidSignatureV) {
838             revert("ECDSA: invalid signature 'v' value");
839         }
840     }
841 
842     /**
843      * @dev Returns the address that signed a hashed message (`hash`) with
844      * `signature` or error string. This address can then be used for verification purposes.
845      *
846      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
847      * this function rejects them by requiring the `s` value to be in the lower
848      * half order, and the `v` value to be either 27 or 28.
849      *
850      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
851      * verification to be secure: it is possible to craft signatures that
852      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
853      * this is by receiving a hash of the original message (which may otherwise
854      * be too long), and then calling {toEthSignedMessageHash} on it.
855      *
856      * Documentation for signature generation:
857      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
858      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
859      *
860      * _Available since v4.3._
861      */
862     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
863         if (signature.length == 65) {
864             bytes32 r;
865             bytes32 s;
866             uint8 v;
867             // ecrecover takes the signature parameters, and the only way to get them
868             // currently is to use assembly.
869             /// @solidity memory-safe-assembly
870             assembly {
871                 r := mload(add(signature, 0x20))
872                 s := mload(add(signature, 0x40))
873                 v := byte(0, mload(add(signature, 0x60)))
874             }
875             return tryRecover(hash, v, r, s);
876         } else {
877             return (address(0), RecoverError.InvalidSignatureLength);
878         }
879     }
880 
881     /**
882      * @dev Returns the address that signed a hashed message (`hash`) with
883      * `signature`. This address can then be used for verification purposes.
884      *
885      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
886      * this function rejects them by requiring the `s` value to be in the lower
887      * half order, and the `v` value to be either 27 or 28.
888      *
889      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
890      * verification to be secure: it is possible to craft signatures that
891      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
892      * this is by receiving a hash of the original message (which may otherwise
893      * be too long), and then calling {toEthSignedMessageHash} on it.
894      */
895     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
896         (address recovered, RecoverError error) = tryRecover(hash, signature);
897         _throwError(error);
898         return recovered;
899     }
900 
901     /**
902      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
903      *
904      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
905      *
906      * _Available since v4.3._
907      */
908     function tryRecover(
909         bytes32 hash,
910         bytes32 r,
911         bytes32 vs
912     ) internal pure returns (address, RecoverError) {
913         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
914         uint8 v = uint8((uint256(vs) >> 255) + 27);
915         return tryRecover(hash, v, r, s);
916     }
917 
918     /**
919      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
920      *
921      * _Available since v4.2._
922      */
923     function recover(
924         bytes32 hash,
925         bytes32 r,
926         bytes32 vs
927     ) internal pure returns (address) {
928         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
929         _throwError(error);
930         return recovered;
931     }
932 
933     /**
934      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
935      * `r` and `s` signature fields separately.
936      *
937      * _Available since v4.3._
938      */
939     function tryRecover(
940         bytes32 hash,
941         uint8 v,
942         bytes32 r,
943         bytes32 s
944     ) internal pure returns (address, RecoverError) {
945         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
946         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
947         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
948         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
949         //
950         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
951         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
952         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
953         // these malleable signatures as well.
954         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
955             return (address(0), RecoverError.InvalidSignatureS);
956         }
957         if (v != 27 && v != 28) {
958             return (address(0), RecoverError.InvalidSignatureV);
959         }
960 
961         // If the signature is valid (and not malleable), return the signer address
962         address signer = ecrecover(hash, v, r, s);
963         if (signer == address(0)) {
964             return (address(0), RecoverError.InvalidSignature);
965         }
966 
967         return (signer, RecoverError.NoError);
968     }
969 
970     /**
971      * @dev Overload of {ECDSA-recover} that receives the `v`,
972      * `r` and `s` signature fields separately.
973      */
974     function recover(
975         bytes32 hash,
976         uint8 v,
977         bytes32 r,
978         bytes32 s
979     ) internal pure returns (address) {
980         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
981         _throwError(error);
982         return recovered;
983     }
984 
985     /**
986      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
987      * produces hash corresponding to the one signed with the
988      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
989      * JSON-RPC method as part of EIP-191.
990      *
991      * See {recover}.
992      */
993     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
994         // 32 is the length in bytes of hash,
995         // enforced by the type signature above
996         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
997     }
998 
999     /**
1000      * @dev Returns an Ethereum Signed Message, created from `s`. This
1001      * produces hash corresponding to the one signed with the
1002      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1003      * JSON-RPC method as part of EIP-191.
1004      *
1005      * See {recover}.
1006      */
1007     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1008         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1009     }
1010 
1011     /**
1012      * @dev Returns an Ethereum Signed Typed Data, created from a
1013      * `domainSeparator` and a `structHash`. This produces hash corresponding
1014      * to the one signed with the
1015      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1016      * JSON-RPC method as part of EIP-712.
1017      *
1018      * See {recover}.
1019      */
1020     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1021         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1022     }
1023 }
1024 
1025 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1026 
1027 
1028 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1029 
1030 pragma solidity ^0.8.0;
1031 
1032 /**
1033  * @dev Interface of the ERC165 standard, as defined in the
1034  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1035  *
1036  * Implementers can declare support of contract interfaces, which can then be
1037  * queried by others ({ERC165Checker}).
1038  *
1039  * For an implementation, see {ERC165}.
1040  */
1041 interface IERC165 {
1042     /**
1043      * @dev Returns true if this contract implements the interface defined by
1044      * `interfaceId`. See the corresponding
1045      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1046      * to learn more about how these ids are created.
1047      *
1048      * This function call must use less than 30 000 gas.
1049      */
1050     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1051 }
1052 
1053 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 
1061 /**
1062  * @dev Required interface of an ERC721 compliant contract.
1063  */
1064 interface IERC721 is IERC165 {
1065     /**
1066      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1067      */
1068     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1069 
1070     /**
1071      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1072      */
1073     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1074 
1075     /**
1076      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1077      */
1078     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1079 
1080     /**
1081      * @dev Returns the number of tokens in ``owner``'s account.
1082      */
1083     function balanceOf(address owner) external view returns (uint256 balance);
1084 
1085     /**
1086      * @dev Returns the owner of the `tokenId` token.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      */
1092     function ownerOf(uint256 tokenId) external view returns (address owner);
1093 
1094     /**
1095      * @dev Safely transfers `tokenId` token from `from` to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - `from` cannot be the zero address.
1100      * - `to` cannot be the zero address.
1101      * - `tokenId` token must exist and be owned by `from`.
1102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function safeTransferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes calldata data
1112     ) external;
1113 
1114     /**
1115      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1116      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1117      *
1118      * Requirements:
1119      *
1120      * - `from` cannot be the zero address.
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must exist and be owned by `from`.
1123      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function safeTransferFrom(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) external;
1133 
1134     /**
1135      * @dev Transfers `tokenId` token from `from` to `to`.
1136      *
1137      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1138      *
1139      * Requirements:
1140      *
1141      * - `from` cannot be the zero address.
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must be owned by `from`.
1144      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function transferFrom(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) external;
1153 
1154     /**
1155      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1156      * The approval is cleared when the token is transferred.
1157      *
1158      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1159      *
1160      * Requirements:
1161      *
1162      * - The caller must own the token or be an approved operator.
1163      * - `tokenId` must exist.
1164      *
1165      * Emits an {Approval} event.
1166      */
1167     function approve(address to, uint256 tokenId) external;
1168 
1169     /**
1170      * @dev Approve or remove `operator` as an operator for the caller.
1171      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1172      *
1173      * Requirements:
1174      *
1175      * - The `operator` cannot be the caller.
1176      *
1177      * Emits an {ApprovalForAll} event.
1178      */
1179     function setApprovalForAll(address operator, bool _approved) external;
1180 
1181     /**
1182      * @dev Returns the account approved for `tokenId` token.
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must exist.
1187      */
1188     function getApproved(uint256 tokenId) external view returns (address operator);
1189 
1190     /**
1191      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1192      *
1193      * See {setApprovalForAll}
1194      */
1195     function isApprovedForAll(address owner, address operator) external view returns (bool);
1196 }
1197 
1198 // File: @openzeppelin/contracts/utils/Context.sol
1199 
1200 
1201 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1202 
1203 pragma solidity ^0.8.0;
1204 
1205 /**
1206  * @dev Provides information about the current execution context, including the
1207  * sender of the transaction and its data. While these are generally available
1208  * via msg.sender and msg.data, they should not be accessed in such a direct
1209  * manner, since when dealing with meta-transactions the account sending and
1210  * paying for execution may not be the actual sender (as far as an application
1211  * is concerned).
1212  *
1213  * This contract is only required for intermediate, library-like contracts.
1214  */
1215 abstract contract Context {
1216     function _msgSender() internal view virtual returns (address) {
1217         return msg.sender;
1218     }
1219 
1220     function _msgData() internal view virtual returns (bytes calldata) {
1221         return msg.data;
1222     }
1223 }
1224 
1225 // File: @openzeppelin/contracts/access/Ownable.sol
1226 
1227 
1228 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 /**
1234  * @dev Contract module which provides a basic access control mechanism, where
1235  * there is an account (an owner) that can be granted exclusive access to
1236  * specific functions.
1237  *
1238  * By default, the owner account will be the one that deploys the contract. This
1239  * can later be changed with {transferOwnership}.
1240  *
1241  * This module is used through inheritance. It will make available the modifier
1242  * `onlyOwner`, which can be applied to your functions to restrict their use to
1243  * the owner.
1244  */
1245 abstract contract Ownable is Context {
1246     address private _owner;
1247 
1248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1249 
1250     /**
1251      * @dev Initializes the contract setting the deployer as the initial owner.
1252      */
1253     constructor() {
1254         _transferOwnership(_msgSender());
1255     }
1256 
1257     /**
1258      * @dev Throws if called by any account other than the owner.
1259      */
1260     modifier onlyOwner() {
1261         _checkOwner();
1262         _;
1263     }
1264 
1265     /**
1266      * @dev Returns the address of the current owner.
1267      */
1268     function owner() public view virtual returns (address) {
1269         return _owner;
1270     }
1271 
1272     /**
1273      * @dev Throws if the sender is not the owner.
1274      */
1275     function _checkOwner() internal view virtual {
1276         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1277     }
1278 
1279     /**
1280      * @dev Leaves the contract without owner. It will not be possible to call
1281      * `onlyOwner` functions anymore. Can only be called by the current owner.
1282      *
1283      * NOTE: Renouncing ownership will leave the contract without an owner,
1284      * thereby removing any functionality that is only available to the owner.
1285      */
1286     function renounceOwnership() public virtual onlyOwner {
1287         _transferOwnership(address(0));
1288     }
1289 
1290     /**
1291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1292      * Can only be called by the current owner.
1293      */
1294     function transferOwnership(address newOwner) public virtual onlyOwner {
1295         require(newOwner != address(0), "Ownable: new owner is the zero address");
1296         _transferOwnership(newOwner);
1297     }
1298 
1299     /**
1300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1301      * Internal function without access restriction.
1302      */
1303     function _transferOwnership(address newOwner) internal virtual {
1304         address oldOwner = _owner;
1305         _owner = newOwner;
1306         emit OwnershipTransferred(oldOwner, newOwner);
1307     }
1308 }
1309 
1310 // File: contracts/SacredShardStaking.sol
1311 
1312 
1313 pragma solidity ^0.8.11;
1314 
1315 
1316 
1317 
1318 
1319 
1320 
1321 
1322 contract SacredShardStaking is ERC721Holder, Ownable {
1323     using EnumerableSet for EnumerableSet.UintSet;
1324     using ECDSA for bytes32;
1325     using SafeMath for uint256;
1326     address private systemAddress;
1327 
1328     struct Staker {
1329         EnumerableSet.UintSet tokenIds;
1330         uint256 amount;
1331         uint256 lastClaimTime; // Timestamp of the last reward claim
1332     }
1333 
1334     struct StakedNft {
1335         uint256 timestamp;
1336         uint256 stakedTime;
1337         uint256 lockedTime;
1338         uint256 tier;
1339     }
1340 
1341     struct Collection {
1342         IERC721 NFT;
1343         uint256 lockTime;
1344         uint256 rewardPerDay; // Reward amount per day for each tier
1345         uint256 claimCooldown; // Cooldown period between reward claims (in seconds)
1346         address rewardTokenAddress;
1347         mapping(address => Staker) Stakers;
1348         mapping(uint256 => StakedNft) StakedNfts;
1349         mapping(uint256 => address) StakerAddresses;
1350     }
1351 
1352     Collection[] public nftPools;
1353     mapping(string => bool) public _usedNonces;
1354     mapping(uint256 => uint256) public tierRewards; // Mapping to store reward per day for each tier
1355 
1356     // Server verification event
1357     event TierVerified(uint256 indexed poolId, uint256 indexed tokenId, bool isVerified);
1358 
1359     event Recover(address indexed owner, uint256 indexed amount);
1360 
1361     constructor() {}
1362 
1363     event Stake(address indexed owner, uint256 id, uint256 time);
1364     event Unstake(address indexed owner, uint256 id, uint256 time);
1365     event RewardClaimed(address indexed staker, uint256 amount);
1366 
1367     function recoverTokens(uint256 _poolId) external onlyOwner {
1368         Collection storage pool = nftPools[_poolId];
1369         // Transfer rewards to the staker
1370         IERC20 rewardToken = IERC20(pool.rewardTokenAddress); // ERC20 token used for rewards
1371 
1372         uint256 balance = rewardToken.balanceOf(address(this));
1373         rewardToken.transfer(owner(), balance);
1374         emit Recover(address(rewardToken), balance);
1375     }
1376 
1377     function stakeNFT(uint256 _tokenId, uint256 _poolId, uint256 _tier, string memory nonce, bytes32 hash, bytes memory signature) public {
1378         require(matchSigner(hash, signature), "please redeem through website");
1379         require(!_usedNonces[nonce], "hash reused");
1380         require(hashTransaction(msg.sender, 1, nonce) == hash, "hash failed"); 
1381 
1382         _usedNonces[nonce] = true;
1383         require(_poolId < nftPools.length, "Pool does not exist!");
1384         Collection storage pool = nftPools[_poolId];
1385         require(pool.NFT.balanceOf(msg.sender) >= 1, "Insufficient NFTs");
1386         require(pool.NFT.ownerOf(_tokenId) == msg.sender, "NFT not owned");
1387 
1388 
1389         pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.add(1);
1390         pool.Stakers[msg.sender].tokenIds.add(_tokenId);
1391 
1392         StakedNft storage stakedNft = pool.StakedNfts[_tokenId];
1393         stakedNft.lockedTime = block.timestamp.add(pool.lockTime);
1394         stakedNft.timestamp = block.timestamp;
1395         stakedNft.stakedTime = block.timestamp;
1396         stakedNft.tier = _tier;
1397 
1398         pool.StakerAddresses[_tokenId] = msg.sender;
1399 
1400         pool.NFT.safeTransferFrom(msg.sender, address(this), _tokenId);
1401 
1402         emit Stake(msg.sender, _tokenId, block.timestamp);
1403     }
1404 
1405     function batchStakeNFT(uint256[] memory _tokenIds, uint256 _poolId, uint256[] memory _tiers, string memory nonce, bytes32 hash, bytes memory signature) public {
1406         require(matchSigner(hash, signature), "please redeem through website");
1407         require(!_usedNonces[nonce], "hash reused");
1408         require(hashTransaction(msg.sender, 1, nonce) == hash, "hash failed"); 
1409 
1410         _usedNonces[nonce] = true;
1411         require(_poolId < nftPools.length, "Pool does not exist!");
1412         Collection storage pool = nftPools[_poolId];
1413         require(_tokenIds.length == _tiers.length, "Invalid input");
1414 
1415         for (uint256 i = 0; i < _tokenIds.length; i++) {
1416             uint256 _tokenId = _tokenIds[i];
1417             uint256 _tier = _tiers[i];
1418 
1419             require(pool.NFT.balanceOf(msg.sender) >= 1, "Insufficient NFTs");
1420             require(pool.NFT.ownerOf(_tokenId) == msg.sender, "NFT not owned");
1421 
1422             pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.add(1);
1423             pool.Stakers[msg.sender].tokenIds.add(_tokenId);
1424 
1425             StakedNft storage stakedNft = pool.StakedNfts[_tokenId];
1426             stakedNft.lockedTime = block.timestamp.add(pool.lockTime);
1427             stakedNft.timestamp = block.timestamp;
1428             stakedNft.stakedTime = block.timestamp;
1429             stakedNft.tier = _tier;
1430 
1431             pool.StakerAddresses[_tokenId] = msg.sender;
1432 
1433             pool.NFT.safeTransferFrom(msg.sender, address(this), _tokenId);
1434 
1435             emit Stake(msg.sender, _tokenId, block.timestamp);
1436         }
1437     }
1438 
1439     function calculateRewards(uint256 _poolId, address _staker) internal view returns (uint256) {
1440         require(_poolId < nftPools.length, "Pool does not exist!");
1441         Collection storage pool = nftPools[_poolId];
1442         Staker storage staker = pool.Stakers[_staker];
1443 
1444         uint256 totalRewards = 0;
1445         IERC20 rewardToken = IERC20(pool.rewardTokenAddress);
1446         uint256 rewardBalance = rewardToken.balanceOf(address(this));
1447 
1448         
1449 
1450         for (uint256 i = 0; i < staker.tokenIds.length(); i++) {
1451             uint256 tokenId = staker.tokenIds.at(i);
1452             uint256 rewardPerSecond = tierRewards[pool.StakedNfts[tokenId].tier];
1453             uint256 stakingDuration = 0;
1454             
1455             stakingDuration = block.timestamp.sub(pool.StakedNfts[tokenId].timestamp);
1456 
1457             uint256 rewards = stakingDuration.mul(rewardPerSecond);
1458             totalRewards = totalRewards.add(rewards);
1459         }
1460 
1461         if(rewardBalance < totalRewards){
1462             return rewardBalance;
1463         }
1464 
1465         return totalRewards;
1466     }
1467 
1468     function claimRewards(uint256 _poolId) public {
1469         require(_poolId < nftPools.length, "Pool does not exist!");
1470         Collection storage pool = nftPools[_poolId];
1471         Staker storage staker = pool.Stakers[msg.sender];
1472         require(staker.amount > 0, "No staked NFTs");
1473         require(block.timestamp >= staker.lastClaimTime.add(pool.claimCooldown), "Cooldown period not elapsed");
1474 
1475         uint256 totalRewards = calculateRewards(_poolId, msg.sender);
1476 
1477         // Update the timestamp of each staked NFT
1478         for (uint256 i = 0; i < staker.tokenIds.length(); i++) {
1479             uint256 tokenId = staker.tokenIds.at(i);
1480             pool.StakedNfts[tokenId].timestamp = block.timestamp;
1481         }
1482 
1483         staker.lastClaimTime = block.timestamp;
1484 
1485         // Transfer rewards to the staker
1486         IERC20 rewardToken = IERC20(pool.rewardTokenAddress); // ERC20 token used for rewards
1487         rewardToken.transfer(msg.sender, totalRewards);
1488 
1489         staker.lastClaimTime = block.timestamp;
1490 
1491         emit RewardClaimed(msg.sender, totalRewards);
1492     }
1493 
1494     function unstakeNFT(uint256 _tokenId, uint256 _poolId) public {
1495         require(_poolId < nftPools.length, "Pool does not exist!");
1496         Collection storage pool = nftPools[_poolId];
1497         require(block.timestamp >= pool.StakedNfts[_tokenId].lockedTime, "NFT locked for withdrawal");
1498         require(pool.Stakers[msg.sender].amount > 0, "No staked NFTs");
1499         require(pool.StakerAddresses[_tokenId] == msg.sender, "Token not owned");
1500 
1501         claimRewards(_poolId);
1502 
1503         pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.sub(1);
1504         pool.StakerAddresses[_tokenId] = address(0);
1505         pool.Stakers[msg.sender].tokenIds.remove(_tokenId);
1506 
1507         pool.NFT.safeTransferFrom(address(this), msg.sender, _tokenId);
1508 
1509         emit Unstake(msg.sender, _tokenId, block.timestamp);
1510     }
1511 
1512     function batchUnstakeNFT(uint256[] memory _tokenIds, uint256 _poolId) public {
1513         require(_poolId < nftPools.length, "Pool does not exist!");
1514         Collection storage pool = nftPools[_poolId];
1515 
1516         claimRewards(_poolId);
1517 
1518         for (uint256 i = 0; i < _tokenIds.length; i++) {
1519             uint256 _tokenId = _tokenIds[i];
1520             require(block.timestamp >= pool.StakedNfts[_tokenId].lockedTime, "NFT locked for withdrawal");
1521             require(pool.Stakers[msg.sender].amount > 0, "No staked NFTs");
1522             require(pool.StakerAddresses[_tokenId] == msg.sender, "Token not owned");
1523 
1524             pool.Stakers[msg.sender].amount = pool.Stakers[msg.sender].amount.sub(1);
1525             pool.StakerAddresses[_tokenId] = address(0);
1526             pool.Stakers[msg.sender].tokenIds.remove(_tokenId);
1527 
1528             pool.NFT.safeTransferFrom(address(this), msg.sender, _tokenId);
1529 
1530             emit Unstake(msg.sender, _tokenId, block.timestamp);
1531         }
1532     }
1533 
1534     function addPool(address _nftAddress, uint256 _lockTime, uint256 _rewardPerDay, uint256 _claimCooldown, address _rewardTokenAddress) external onlyOwner {
1535         Collection storage newCollection = nftPools.push();
1536         newCollection.NFT = IERC721(_nftAddress);
1537         newCollection.lockTime = _lockTime;
1538         newCollection.rewardPerDay = _rewardPerDay;
1539         newCollection.claimCooldown = _claimCooldown;
1540         newCollection.rewardTokenAddress = _rewardTokenAddress;
1541     }
1542 
1543     function setTierReward(uint256 _tier, uint256 _rewardPerDay) external onlyOwner {
1544         tierRewards[_tier] = _rewardPerDay;
1545     }
1546 
1547     function setSigner(address _signer) external onlyOwner {
1548         systemAddress = _signer;
1549     }
1550 
1551     function matchSigner(bytes32 hash, bytes memory signature) public view returns (bool) {
1552         return systemAddress == hash.toEthSignedMessageHash().recover(signature);
1553     }
1554 
1555     function hashTransaction(
1556     address sender,
1557     uint256 amount,
1558     string memory nonce
1559     ) public view returns (bytes32) {
1560     
1561         bytes32 hash = keccak256(
1562         abi.encodePacked(sender, amount, nonce, address(this))
1563         );
1564 
1565         return hash;
1566     }
1567 
1568     function getStakedNft(uint256 _tokenId, uint256 _poolId) public view returns (uint256, uint256, uint256, uint256) {
1569         require(_poolId < nftPools.length, "Pool does not exist!");
1570         Collection storage pool = nftPools[_poolId];
1571         StakedNft storage stakedNft = pool.StakedNfts[_tokenId];
1572         return (stakedNft.timestamp, stakedNft.lockedTime, stakedNft.stakedTime, stakedNft.tier);
1573     }
1574 
1575     function calculateEstimatedReward(uint256 _poolId, address _staker) public view returns (uint256) {
1576         require(_poolId < nftPools.length, "Pool does not exist!");
1577         Collection storage pool = nftPools[_poolId];
1578         Staker storage staker = pool.Stakers[_staker];
1579 
1580         uint256 totalRewards = 0;
1581         
1582         for (uint256 i = 0; i < staker.tokenIds.length(); i++) {
1583             uint256 tokenId = staker.tokenIds.at(i);
1584             uint256 rewardPerSecond = tierRewards[pool.StakedNfts[tokenId].tier];
1585             uint256 stakingDuration = 0;
1586             stakingDuration = block.timestamp.sub(pool.StakedNfts[tokenId].timestamp);
1587 
1588             uint256 rewards = stakingDuration.mul(rewardPerSecond);
1589             totalRewards = totalRewards.add(rewards);
1590         }
1591 
1592         return totalRewards;
1593     }
1594 
1595     function calculateEstimatedRewardDaily(uint256 _poolId, address _staker) public view returns (uint256) {
1596         require(_poolId < nftPools.length, "Pool does not exist!");
1597         Collection storage pool = nftPools[_poolId];
1598         Staker storage staker = pool.Stakers[_staker];
1599 
1600         uint256 totalRewards = 0;
1601         
1602         for (uint256 i = 0; i < staker.tokenIds.length(); i++) {
1603             uint256 tokenId = staker.tokenIds.at(i);
1604             uint256 rewardPerSecond = tierRewards[pool.StakedNfts[tokenId].tier];
1605             uint256 stakingDuration = 1 days;
1606 
1607             uint256 rewards = stakingDuration.mul(rewardPerSecond);
1608             totalRewards = totalRewards.add(rewards);
1609         }
1610 
1611         return totalRewards;
1612     }
1613 
1614     function getStakerInfo(address _stakerAddress, uint256 _poolId) public view returns (uint256, uint256[] memory) {
1615         require(_poolId < nftPools.length, "Pool does not exist");
1616         Collection storage pool = nftPools[_poolId];
1617         Staker storage staker = pool.Stakers[_stakerAddress];
1618 
1619         uint256[] memory stakedTokenIds = new uint256[](staker.tokenIds.length());
1620         for (uint256 i = 0; i < staker.tokenIds.length(); i++) {
1621             stakedTokenIds[i] = staker.tokenIds.at(i);
1622         }
1623 
1624         return (staker.amount, stakedTokenIds);
1625     }
1626 
1627     function getStakedTokenOwner(uint256 _tokenId, uint256 _poolId) public view returns (address) {
1628         require(_poolId < nftPools.length, "Pool does not exist!");
1629         Collection storage pool = nftPools[_poolId];
1630         return pool.StakerAddresses[_tokenId];
1631     }
1632 
1633     function getPoolSize() public view returns (uint256) {
1634         return nftPools.length;
1635     }
1636 }