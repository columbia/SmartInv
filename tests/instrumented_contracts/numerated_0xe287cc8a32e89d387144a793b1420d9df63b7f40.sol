1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
99 
100 
101 
102 pragma solidity >=0.6.0 <0.8.0;
103 
104 /**
105  * @dev Contract module that helps prevent reentrant calls to a function.
106  *
107  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
108  * available, which can be applied to functions to make sure there are no nested
109  * (reentrant) calls to them.
110  *
111  * Note that because there is a single `nonReentrant` guard, functions marked as
112  * `nonReentrant` may not call one another. This can be worked around by making
113  * those functions `private`, and then adding `external` `nonReentrant` entry
114  * points to them.
115  *
116  * TIP: If you would like to learn more about reentrancy and alternative ways
117  * to protect against it, check out our blog post
118  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
119  */
120 abstract contract ReentrancyGuard {
121     // Booleans are more expensive than uint256 or any type that takes up a full
122     // word because each write operation emits an extra SLOAD to first read the
123     // slot's contents, replace the bits taken up by the boolean, and then write
124     // back. This is the compiler's defense against contract upgrades and
125     // pointer aliasing, and it cannot be disabled.
126 
127     // The values being non-zero value makes deployment a bit more expensive,
128     // but in exchange the refund on every call to nonReentrant will be lower in
129     // amount. Since refunds are capped to a percentage of the total
130     // transaction's gas, it is best to keep them low in cases like this one, to
131     // increase the likelihood of the full refund coming into effect.
132     uint256 private constant _NOT_ENTERED = 1;
133     uint256 private constant _ENTERED = 2;
134 
135     uint256 private _status;
136 
137     constructor () internal {
138         _status = _NOT_ENTERED;
139     }
140 
141     /**
142      * @dev Prevents a contract from calling itself, directly or indirectly.
143      * Calling a `nonReentrant` function from another `nonReentrant`
144      * function is not supported. It is possible to prevent this from happening
145      * by making the `nonReentrant` function external, and make it call a
146      * `private` function that does the actual work.
147      */
148     modifier nonReentrant() {
149         // On the first call to nonReentrant, _notEntered will be true
150         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
151 
152         // Any calls to nonReentrant after this point will fail
153         _status = _ENTERED;
154 
155         _;
156 
157         // By storing the original value once again, a refund is triggered (see
158         // https://eips.ethereum.org/EIPS/eip-2200)
159         _status = _NOT_ENTERED;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/math/SafeMath.sol
164 
165 
166 
167 pragma solidity >=0.6.0 <0.8.0;
168 
169 /**
170  * @dev Wrappers over Solidity's arithmetic operations with added overflow
171  * checks.
172  *
173  * Arithmetic operations in Solidity wrap on overflow. This can easily result
174  * in bugs, because programmers usually assume that an overflow raises an
175  * error, which is the standard behavior in high level programming languages.
176  * `SafeMath` restores this intuition by reverting the transaction when an
177  * operation overflows.
178  *
179  * Using this library instead of the unchecked operations eliminates an entire
180  * class of bugs, so it's recommended to use it always.
181  */
182 library SafeMath {
183     /**
184      * @dev Returns the addition of two unsigned integers, with an overflow flag.
185      *
186      * _Available since v3.4._
187      */
188     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
189         uint256 c = a + b;
190         if (c < a) return (false, 0);
191         return (true, c);
192     }
193 
194     /**
195      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
196      *
197      * _Available since v3.4._
198      */
199     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
200         if (b > a) return (false, 0);
201         return (true, a - b);
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211         // benefit is lost if 'b' is also tested.
212         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
213         if (a == 0) return (true, 0);
214         uint256 c = a * b;
215         if (c / a != b) return (false, 0);
216         return (true, c);
217     }
218 
219     /**
220      * @dev Returns the division of two unsigned integers, with a division by zero flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         if (b == 0) return (false, 0);
226         return (true, a / b);
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
231      *
232      * _Available since v3.4._
233      */
234     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
235         if (b == 0) return (false, 0);
236         return (true, a % b);
237     }
238 
239     /**
240      * @dev Returns the addition of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `+` operator.
244      *
245      * Requirements:
246      *
247      * - Addition cannot overflow.
248      */
249     function add(uint256 a, uint256 b) internal pure returns (uint256) {
250         uint256 c = a + b;
251         require(c >= a, "SafeMath: addition overflow");
252         return c;
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting on
257      * overflow (when the result is negative).
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b <= a, "SafeMath: subtraction overflow");
267         return a - b;
268     }
269 
270     /**
271      * @dev Returns the multiplication of two unsigned integers, reverting on
272      * overflow.
273      *
274      * Counterpart to Solidity's `*` operator.
275      *
276      * Requirements:
277      *
278      * - Multiplication cannot overflow.
279      */
280     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
281         if (a == 0) return 0;
282         uint256 c = a * b;
283         require(c / a == b, "SafeMath: multiplication overflow");
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         require(b > 0, "SafeMath: division by zero");
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b > 0, "SafeMath: modulo by zero");
318         return a % b;
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
323      * overflow (when the result is negative).
324      *
325      * CAUTION: This function is deprecated because it requires allocating memory for the error
326      * message unnecessarily. For custom revert reasons use {trySub}.
327      *
328      * Counterpart to Solidity's `-` operator.
329      *
330      * Requirements:
331      *
332      * - Subtraction cannot overflow.
333      */
334     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b <= a, errorMessage);
336         return a - b;
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
341      * division by zero. The result is rounded towards zero.
342      *
343      * CAUTION: This function is deprecated because it requires allocating memory for the error
344      * message unnecessarily. For custom revert reasons use {tryDiv}.
345      *
346      * Counterpart to Solidity's `/` operator. Note: this function uses a
347      * `revert` opcode (which leaves remaining gas untouched) while Solidity
348      * uses an invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      *
352      * - The divisor cannot be zero.
353      */
354     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b > 0, errorMessage);
356         return a / b;
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * reverting with custom message when dividing by zero.
362      *
363      * CAUTION: This function is deprecated because it requires allocating memory for the error
364      * message unnecessarily. For custom revert reasons use {tryMod}.
365      *
366      * Counterpart to Solidity's `%` operator. This function uses a `revert`
367      * opcode (which leaves remaining gas untouched) while Solidity uses an
368      * invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
375         require(b > 0, errorMessage);
376         return a % b;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
381 
382 
383 
384 pragma solidity >=0.6.0 <0.8.0;
385 
386 /**
387  * @dev Library for managing
388  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
389  * types.
390  *
391  * Sets have the following properties:
392  *
393  * - Elements are added, removed, and checked for existence in constant time
394  * (O(1)).
395  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
396  *
397  * ```
398  * contract Example {
399  *     // Add the library methods
400  *     using EnumerableSet for EnumerableSet.AddressSet;
401  *
402  *     // Declare a set state variable
403  *     EnumerableSet.AddressSet private mySet;
404  * }
405  * ```
406  *
407  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
408  * and `uint256` (`UintSet`) are supported.
409  */
410 library EnumerableSet {
411     // To implement this library for multiple types with as little code
412     // repetition as possible, we write it in terms of a generic Set type with
413     // bytes32 values.
414     // The Set implementation uses private functions, and user-facing
415     // implementations (such as AddressSet) are just wrappers around the
416     // underlying Set.
417     // This means that we can only create new EnumerableSets for types that fit
418     // in bytes32.
419 
420     struct Set {
421         // Storage of set values
422         bytes32[] _values;
423 
424         // Position of the value in the `values` array, plus 1 because index 0
425         // means a value is not in the set.
426         mapping (bytes32 => uint256) _indexes;
427     }
428 
429     /**
430      * @dev Add a value to a set. O(1).
431      *
432      * Returns true if the value was added to the set, that is if it was not
433      * already present.
434      */
435     function _add(Set storage set, bytes32 value) private returns (bool) {
436         if (!_contains(set, value)) {
437             set._values.push(value);
438             // The value is stored at length-1, but we add 1 to all indexes
439             // and use 0 as a sentinel value
440             set._indexes[value] = set._values.length;
441             return true;
442         } else {
443             return false;
444         }
445     }
446 
447     /**
448      * @dev Removes a value from a set. O(1).
449      *
450      * Returns true if the value was removed from the set, that is if it was
451      * present.
452      */
453     function _remove(Set storage set, bytes32 value) private returns (bool) {
454         // We read and store the value's index to prevent multiple reads from the same storage slot
455         uint256 valueIndex = set._indexes[value];
456 
457         if (valueIndex != 0) { // Equivalent to contains(set, value)
458             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
459             // the array, and then remove the last element (sometimes called as 'swap and pop').
460             // This modifies the order of the array, as noted in {at}.
461 
462             uint256 toDeleteIndex = valueIndex - 1;
463             uint256 lastIndex = set._values.length - 1;
464 
465             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
466             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
467 
468             bytes32 lastvalue = set._values[lastIndex];
469 
470             // Move the last value to the index where the value to delete is
471             set._values[toDeleteIndex] = lastvalue;
472             // Update the index for the moved value
473             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
474 
475             // Delete the slot where the moved value was stored
476             set._values.pop();
477 
478             // Delete the index for the deleted slot
479             delete set._indexes[value];
480 
481             return true;
482         } else {
483             return false;
484         }
485     }
486 
487     /**
488      * @dev Returns true if the value is in the set. O(1).
489      */
490     function _contains(Set storage set, bytes32 value) private view returns (bool) {
491         return set._indexes[value] != 0;
492     }
493 
494     /**
495      * @dev Returns the number of values on the set. O(1).
496      */
497     function _length(Set storage set) private view returns (uint256) {
498         return set._values.length;
499     }
500 
501    /**
502     * @dev Returns the value stored at position `index` in the set. O(1).
503     *
504     * Note that there are no guarantees on the ordering of values inside the
505     * array, and it may change when more values are added or removed.
506     *
507     * Requirements:
508     *
509     * - `index` must be strictly less than {length}.
510     */
511     function _at(Set storage set, uint256 index) private view returns (bytes32) {
512         require(set._values.length > index, "EnumerableSet: index out of bounds");
513         return set._values[index];
514     }
515 
516     // Bytes32Set
517 
518     struct Bytes32Set {
519         Set _inner;
520     }
521 
522     /**
523      * @dev Add a value to a set. O(1).
524      *
525      * Returns true if the value was added to the set, that is if it was not
526      * already present.
527      */
528     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
529         return _add(set._inner, value);
530     }
531 
532     /**
533      * @dev Removes a value from a set. O(1).
534      *
535      * Returns true if the value was removed from the set, that is if it was
536      * present.
537      */
538     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
539         return _remove(set._inner, value);
540     }
541 
542     /**
543      * @dev Returns true if the value is in the set. O(1).
544      */
545     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
546         return _contains(set._inner, value);
547     }
548 
549     /**
550      * @dev Returns the number of values in the set. O(1).
551      */
552     function length(Bytes32Set storage set) internal view returns (uint256) {
553         return _length(set._inner);
554     }
555 
556    /**
557     * @dev Returns the value stored at position `index` in the set. O(1).
558     *
559     * Note that there are no guarantees on the ordering of values inside the
560     * array, and it may change when more values are added or removed.
561     *
562     * Requirements:
563     *
564     * - `index` must be strictly less than {length}.
565     */
566     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
567         return _at(set._inner, index);
568     }
569 
570     // AddressSet
571 
572     struct AddressSet {
573         Set _inner;
574     }
575 
576     /**
577      * @dev Add a value to a set. O(1).
578      *
579      * Returns true if the value was added to the set, that is if it was not
580      * already present.
581      */
582     function add(AddressSet storage set, address value) internal returns (bool) {
583         return _add(set._inner, bytes32(uint256(uint160(value))));
584     }
585 
586     /**
587      * @dev Removes a value from a set. O(1).
588      *
589      * Returns true if the value was removed from the set, that is if it was
590      * present.
591      */
592     function remove(AddressSet storage set, address value) internal returns (bool) {
593         return _remove(set._inner, bytes32(uint256(uint160(value))));
594     }
595 
596     /**
597      * @dev Returns true if the value is in the set. O(1).
598      */
599     function contains(AddressSet storage set, address value) internal view returns (bool) {
600         return _contains(set._inner, bytes32(uint256(uint160(value))));
601     }
602 
603     /**
604      * @dev Returns the number of values in the set. O(1).
605      */
606     function length(AddressSet storage set) internal view returns (uint256) {
607         return _length(set._inner);
608     }
609 
610    /**
611     * @dev Returns the value stored at position `index` in the set. O(1).
612     *
613     * Note that there are no guarantees on the ordering of values inside the
614     * array, and it may change when more values are added or removed.
615     *
616     * Requirements:
617     *
618     * - `index` must be strictly less than {length}.
619     */
620     function at(AddressSet storage set, uint256 index) internal view returns (address) {
621         return address(uint160(uint256(_at(set._inner, index))));
622     }
623 
624 
625     // UintSet
626 
627     struct UintSet {
628         Set _inner;
629     }
630 
631     /**
632      * @dev Add a value to a set. O(1).
633      *
634      * Returns true if the value was added to the set, that is if it was not
635      * already present.
636      */
637     function add(UintSet storage set, uint256 value) internal returns (bool) {
638         return _add(set._inner, bytes32(value));
639     }
640 
641     /**
642      * @dev Removes a value from a set. O(1).
643      *
644      * Returns true if the value was removed from the set, that is if it was
645      * present.
646      */
647     function remove(UintSet storage set, uint256 value) internal returns (bool) {
648         return _remove(set._inner, bytes32(value));
649     }
650 
651     /**
652      * @dev Returns true if the value is in the set. O(1).
653      */
654     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
655         return _contains(set._inner, bytes32(value));
656     }
657 
658     /**
659      * @dev Returns the number of values on the set. O(1).
660      */
661     function length(UintSet storage set) internal view returns (uint256) {
662         return _length(set._inner);
663     }
664 
665    /**
666     * @dev Returns the value stored at position `index` in the set. O(1).
667     *
668     * Note that there are no guarantees on the ordering of values inside the
669     * array, and it may change when more values are added or removed.
670     *
671     * Requirements:
672     *
673     * - `index` must be strictly less than {length}.
674     */
675     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
676         return uint256(_at(set._inner, index));
677     }
678 }
679 
680 // File: @openzeppelin/contracts/utils/Address.sol
681 
682 
683 
684 pragma solidity >=0.6.2 <0.8.0;
685 
686 /**
687  * @dev Collection of functions related to the address type
688  */
689 library Address {
690     /**
691      * @dev Returns true if `account` is a contract.
692      *
693      * [IMPORTANT]
694      * ====
695      * It is unsafe to assume that an address for which this function returns
696      * false is an externally-owned account (EOA) and not a contract.
697      *
698      * Among others, `isContract` will return false for the following
699      * types of addresses:
700      *
701      *  - an externally-owned account
702      *  - a contract in construction
703      *  - an address where a contract will be created
704      *  - an address where a contract lived, but was destroyed
705      * ====
706      */
707     function isContract(address account) internal view returns (bool) {
708         // This method relies on extcodesize, which returns 0 for contracts in
709         // construction, since the code is only stored at the end of the
710         // constructor execution.
711 
712         uint256 size;
713         // solhint-disable-next-line no-inline-assembly
714         assembly { size := extcodesize(account) }
715         return size > 0;
716     }
717 
718     /**
719      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
720      * `recipient`, forwarding all available gas and reverting on errors.
721      *
722      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
723      * of certain opcodes, possibly making contracts go over the 2300 gas limit
724      * imposed by `transfer`, making them unable to receive funds via
725      * `transfer`. {sendValue} removes this limitation.
726      *
727      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
728      *
729      * IMPORTANT: because control is transferred to `recipient`, care must be
730      * taken to not create reentrancy vulnerabilities. Consider using
731      * {ReentrancyGuard} or the
732      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
733      */
734     function sendValue(address payable recipient, uint256 amount) internal {
735         require(address(this).balance >= amount, "Address: insufficient balance");
736 
737         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
738         (bool success, ) = recipient.call{ value: amount }("");
739         require(success, "Address: unable to send value, recipient may have reverted");
740     }
741 
742     /**
743      * @dev Performs a Solidity function call using a low level `call`. A
744      * plain`call` is an unsafe replacement for a function call: use this
745      * function instead.
746      *
747      * If `target` reverts with a revert reason, it is bubbled up by this
748      * function (like regular Solidity function calls).
749      *
750      * Returns the raw returned data. To convert to the expected return value,
751      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
752      *
753      * Requirements:
754      *
755      * - `target` must be a contract.
756      * - calling `target` with `data` must not revert.
757      *
758      * _Available since v3.1._
759      */
760     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
761       return functionCall(target, data, "Address: low-level call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
766      * `errorMessage` as a fallback revert reason when `target` reverts.
767      *
768      * _Available since v3.1._
769      */
770     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
771         return functionCallWithValue(target, data, 0, errorMessage);
772     }
773 
774     /**
775      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
776      * but also transferring `value` wei to `target`.
777      *
778      * Requirements:
779      *
780      * - the calling contract must have an ETH balance of at least `value`.
781      * - the called Solidity function must be `payable`.
782      *
783      * _Available since v3.1._
784      */
785     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
786         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
791      * with `errorMessage` as a fallback revert reason when `target` reverts.
792      *
793      * _Available since v3.1._
794      */
795     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
796         require(address(this).balance >= value, "Address: insufficient balance for call");
797         require(isContract(target), "Address: call to non-contract");
798 
799         // solhint-disable-next-line avoid-low-level-calls
800         (bool success, bytes memory returndata) = target.call{ value: value }(data);
801         return _verifyCallResult(success, returndata, errorMessage);
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
806      * but performing a static call.
807      *
808      * _Available since v3.3._
809      */
810     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
811         return functionStaticCall(target, data, "Address: low-level static call failed");
812     }
813 
814     /**
815      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
816      * but performing a static call.
817      *
818      * _Available since v3.3._
819      */
820     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
821         require(isContract(target), "Address: static call to non-contract");
822 
823         // solhint-disable-next-line avoid-low-level-calls
824         (bool success, bytes memory returndata) = target.staticcall(data);
825         return _verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
830      * but performing a delegate call.
831      *
832      * _Available since v3.4._
833      */
834     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
835         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
836     }
837 
838     /**
839      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
840      * but performing a delegate call.
841      *
842      * _Available since v3.4._
843      */
844     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
845         require(isContract(target), "Address: delegate call to non-contract");
846 
847         // solhint-disable-next-line avoid-low-level-calls
848         (bool success, bytes memory returndata) = target.delegatecall(data);
849         return _verifyCallResult(success, returndata, errorMessage);
850     }
851 
852     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
853         if (success) {
854             return returndata;
855         } else {
856             // Look for revert reason and bubble it up if present
857             if (returndata.length > 0) {
858                 // The easiest way to bubble the revert reason is using memory via assembly
859 
860                 // solhint-disable-next-line no-inline-assembly
861                 assembly {
862                     let returndata_size := mload(returndata)
863                     revert(add(32, returndata), returndata_size)
864                 }
865             } else {
866                 revert(errorMessage);
867             }
868         }
869     }
870 }
871 
872 // File: @openzeppelin/contracts/access/AccessControl.sol
873 
874 
875 
876 pragma solidity >=0.6.0 <0.8.0;
877 
878 
879 
880 
881 /**
882  * @dev Contract module that allows children to implement role-based access
883  * control mechanisms.
884  *
885  * Roles are referred to by their `bytes32` identifier. These should be exposed
886  * in the external API and be unique. The best way to achieve this is by
887  * using `public constant` hash digests:
888  *
889  * ```
890  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
891  * ```
892  *
893  * Roles can be used to represent a set of permissions. To restrict access to a
894  * function call, use {hasRole}:
895  *
896  * ```
897  * function foo() public {
898  *     require(hasRole(MY_ROLE, msg.sender));
899  *     ...
900  * }
901  * ```
902  *
903  * Roles can be granted and revoked dynamically via the {grantRole} and
904  * {revokeRole} functions. Each role has an associated admin role, and only
905  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
906  *
907  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
908  * that only accounts with this role will be able to grant or revoke other
909  * roles. More complex role relationships can be created by using
910  * {_setRoleAdmin}.
911  *
912  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
913  * grant and revoke this role. Extra precautions should be taken to secure
914  * accounts that have been granted it.
915  */
916 abstract contract AccessControl is Context {
917     using EnumerableSet for EnumerableSet.AddressSet;
918     using Address for address;
919 
920     struct RoleData {
921         EnumerableSet.AddressSet members;
922         bytes32 adminRole;
923     }
924 
925     mapping (bytes32 => RoleData) private _roles;
926 
927     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
928 
929     /**
930      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
931      *
932      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
933      * {RoleAdminChanged} not being emitted signaling this.
934      *
935      * _Available since v3.1._
936      */
937     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
938 
939     /**
940      * @dev Emitted when `account` is granted `role`.
941      *
942      * `sender` is the account that originated the contract call, an admin role
943      * bearer except when using {_setupRole}.
944      */
945     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
946 
947     /**
948      * @dev Emitted when `account` is revoked `role`.
949      *
950      * `sender` is the account that originated the contract call:
951      *   - if using `revokeRole`, it is the admin role bearer
952      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
953      */
954     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
955 
956     /**
957      * @dev Returns `true` if `account` has been granted `role`.
958      */
959     function hasRole(bytes32 role, address account) public view returns (bool) {
960         return _roles[role].members.contains(account);
961     }
962 
963     /**
964      * @dev Returns the number of accounts that have `role`. Can be used
965      * together with {getRoleMember} to enumerate all bearers of a role.
966      */
967     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
968         return _roles[role].members.length();
969     }
970 
971     /**
972      * @dev Returns one of the accounts that have `role`. `index` must be a
973      * value between 0 and {getRoleMemberCount}, non-inclusive.
974      *
975      * Role bearers are not sorted in any particular way, and their ordering may
976      * change at any point.
977      *
978      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
979      * you perform all queries on the same block. See the following
980      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
981      * for more information.
982      */
983     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
984         return _roles[role].members.at(index);
985     }
986 
987     /**
988      * @dev Returns the admin role that controls `role`. See {grantRole} and
989      * {revokeRole}.
990      *
991      * To change a role's admin, use {_setRoleAdmin}.
992      */
993     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
994         return _roles[role].adminRole;
995     }
996 
997     /**
998      * @dev Grants `role` to `account`.
999      *
1000      * If `account` had not been already granted `role`, emits a {RoleGranted}
1001      * event.
1002      *
1003      * Requirements:
1004      *
1005      * - the caller must have ``role``'s admin role.
1006      */
1007     function grantRole(bytes32 role, address account) public virtual {
1008         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1009 
1010         _grantRole(role, account);
1011     }
1012 
1013     /**
1014      * @dev Revokes `role` from `account`.
1015      *
1016      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1017      *
1018      * Requirements:
1019      *
1020      * - the caller must have ``role``'s admin role.
1021      */
1022     function revokeRole(bytes32 role, address account) public virtual {
1023         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1024 
1025         _revokeRole(role, account);
1026     }
1027 
1028     /**
1029      * @dev Revokes `role` from the calling account.
1030      *
1031      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1032      * purpose is to provide a mechanism for accounts to lose their privileges
1033      * if they are compromised (such as when a trusted device is misplaced).
1034      *
1035      * If the calling account had been granted `role`, emits a {RoleRevoked}
1036      * event.
1037      *
1038      * Requirements:
1039      *
1040      * - the caller must be `account`.
1041      */
1042     function renounceRole(bytes32 role, address account) public virtual {
1043         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1044 
1045         _revokeRole(role, account);
1046     }
1047 
1048     /**
1049      * @dev Grants `role` to `account`.
1050      *
1051      * If `account` had not been already granted `role`, emits a {RoleGranted}
1052      * event. Note that unlike {grantRole}, this function doesn't perform any
1053      * checks on the calling account.
1054      *
1055      * [WARNING]
1056      * ====
1057      * This function should only be called from the constructor when setting
1058      * up the initial roles for the system.
1059      *
1060      * Using this function in any other way is effectively circumventing the admin
1061      * system imposed by {AccessControl}.
1062      * ====
1063      */
1064     function _setupRole(bytes32 role, address account) internal virtual {
1065         _grantRole(role, account);
1066     }
1067 
1068     /**
1069      * @dev Sets `adminRole` as ``role``'s admin role.
1070      *
1071      * Emits a {RoleAdminChanged} event.
1072      */
1073     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1074         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1075         _roles[role].adminRole = adminRole;
1076     }
1077 
1078     function _grantRole(bytes32 role, address account) private {
1079         if (_roles[role].members.add(account)) {
1080             emit RoleGranted(role, account, _msgSender());
1081         }
1082     }
1083 
1084     function _revokeRole(bytes32 role, address account) private {
1085         if (_roles[role].members.remove(account)) {
1086             emit RoleRevoked(role, account, _msgSender());
1087         }
1088     }
1089 }
1090 
1091 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
1092 
1093 
1094 
1095 pragma solidity >=0.6.0 <0.8.0;
1096 
1097 /**
1098  * @dev These functions deal with verification of Merkle trees (hash trees),
1099  */
1100 library MerkleProof {
1101     /**
1102      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1103      * defined by `root`. For this, a `proof` must be provided, containing
1104      * sibling hashes on the branch from the leaf to the root of the tree. Each
1105      * pair of leaves and each pair of pre-images are assumed to be sorted.
1106      */
1107     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1108         bytes32 computedHash = leaf;
1109 
1110         for (uint256 i = 0; i < proof.length; i++) {
1111             bytes32 proofElement = proof[i];
1112 
1113             if (computedHash <= proofElement) {
1114                 // Hash(current computed hash + current element of the proof)
1115                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1116             } else {
1117                 // Hash(current element of the proof + current computed hash)
1118                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1119             }
1120         }
1121 
1122         // Check if the computed hash (root) is equal to the provided root
1123         return computedHash == root;
1124     }
1125 }
1126 
1127 // File: contracts/NFTFactory.sol
1128 
1129 
1130 pragma solidity ^0.6.0;
1131 pragma experimental ABIEncoderV2;
1132 
1133 
1134 
1135 
1136 
1137 
1138 
1139 interface IERC721 {
1140     function safeMint(address to, uint256 tokenId) external;
1141 
1142     function totalSupply() external view returns (uint256);
1143 }
1144 
1145 
1146 contract NFTFactory is AccessControl, ReentrancyGuard {
1147     using SafeMath for uint256;
1148 
1149     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
1150     bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");
1151 
1152     IERC721 public nft;
1153 
1154     struct UserInfo {
1155         uint256 claimedNum;
1156     }
1157 
1158     struct PoolInfo {
1159         uint256 maxNum;
1160         uint256 supply;
1161         bool paused;
1162         uint256 price;
1163         bytes32 root;
1164         uint256 limitPerAccount;
1165     }
1166 
1167     PoolInfo[] private pools;
1168 
1169     mapping(uint256 => mapping(address => UserInfo)) private users;
1170 
1171     event NewPool(uint256 indexed pid, uint256 maxNum, bool paused, uint256 price, bytes32 root, uint256 limitPerAccount);
1172     event ChangePoolMaxAndLimit(uint256 indexed pid, uint256 maxNum, uint256 price, uint256 limitPerAccount);
1173     event SetPoolRoot(uint256 indexed pid, bytes32 root);
1174     event MintNFT(uint256 indexed pid, address indexed account, uint256 tokenId, uint256 payAmount);
1175     event Withdraw(address indexed account, uint256 amount);
1176     event Paused(uint256 indexed pid);
1177     event Unpaused(uint256 indexed pid);
1178 
1179     constructor(IERC721 _nft) public {
1180         nft = _nft;
1181 
1182         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1183 
1184         _setupRole(OPERATOR_ROLE, _msgSender());
1185         _setupRole(TREASURY_ROLE, _msgSender());
1186     }
1187 
1188     modifier onlyOperator() {
1189         require(hasRole(OPERATOR_ROLE, _msgSender()), "NFTFactory::caller is not operator");
1190         _;
1191     }
1192 
1193     modifier onlyTreasury() {
1194         require(hasRole(TREASURY_ROLE, _msgSender()), "NFTFactory::caller is not treasury");
1195         _;
1196     }
1197 
1198     function addPool(uint256 _maxNum, bool _paused, uint256 _price, uint256 _limitPerAccount, bytes32 _root) external onlyOperator {
1199         require(_limitPerAccount > 0, "NFTFactory::addPool: Limit per account must great than zero");
1200         require(_maxNum > 0, "NFTFactory::addPool: Max num must be higher than zero");
1201 
1202         pools.push(PoolInfo({
1203         maxNum : _maxNum,
1204         supply : 0,
1205         paused : _paused,
1206         price : _price, // allow to zero
1207         root : _root,
1208         limitPerAccount : _limitPerAccount
1209         }));
1210 
1211         emit NewPool(pools.length.sub(1), _maxNum, _paused, _price, _root, _limitPerAccount);
1212     }
1213 
1214     function poolInfo(uint256 _pid) external view returns (PoolInfo memory) {
1215         return pools[_pid];
1216     }
1217 
1218     function userInfo(uint256 _pid, address account) external view returns (UserInfo memory) {
1219         return users[_pid][account];
1220     }
1221 
1222     function poolLength() external view returns (uint256) {
1223         return pools.length;
1224     }
1225 
1226     function mintNFT(uint256 _pid, uint256 _num, bytes32[] calldata _proof) external payable nonReentrant {
1227         address account = _msgSender();
1228         PoolInfo storage pool = pools[_pid];
1229 
1230         require(!pool.paused, "NFTFactory::mintNFT: Has paused");
1231         require(MerkleProof.verify(_proof, pool.root, keccak256(abi.encodePacked(account))), "NFTFactory::mintNFT: Not in whitelist");
1232         require(_num > 0, "NFTFactory:mintNFT: num must be great than zero");
1233         require(pool.supply.add(_num) <= pool.maxNum, "NFTFactory:mintNFT: Pool cap exceeded");
1234         require(pool.price.mul(_num) == msg.value, "NFTFactory::mintNFT: Pay amount error");
1235 
1236         UserInfo storage userinfo = users[_pid][account];
1237         require(userinfo.claimedNum.add(_num) <= pool.limitPerAccount, "NFTFactory::mintNFT: Claim num exceeded");
1238 
1239         for (uint256 i = 0; i < _num; i++) {
1240             uint256 tokenId = nft.totalSupply().add(1);
1241 
1242             pool.supply = pool.supply.add(1);
1243             userinfo.claimedNum = userinfo.claimedNum.add(1);
1244             nft.safeMint(account, tokenId);
1245 
1246             emit MintNFT(_pid, account, tokenId, pool.price);
1247         }
1248     }
1249 
1250     function mintAirdrop(uint256 _pid, address[] calldata _accounts) external onlyOperator {
1251         PoolInfo storage pool = pools[_pid];
1252         require(!pool.paused, "NFTFactory::mintAirdrop: Has paused");
1253         require(_accounts.length > 0, "NFTFactory::mintAirdrop: Accounts is empty");
1254         require(pool.supply.add(_accounts.length) <= pool.maxNum, "NFTFactory:mintAirdrop: Pool cap exceeded");
1255         // pool.limitPerAccount unused
1256         // pool.price unused
1257 
1258         for (uint256 i = 0; i < _accounts.length; i++) {
1259             address account = _accounts[i];
1260             uint256 tokenId = nft.totalSupply().add(1);
1261 
1262             UserInfo storage userinfo = users[_pid][account];
1263             pool.supply = pool.supply.add(1);
1264             userinfo.claimedNum = userinfo.claimedNum.add(1);
1265             nft.safeMint(account, tokenId);
1266 
1267             emit MintNFT(_pid, account, tokenId, 0);
1268         }
1269     }
1270 
1271     function setPoolMaxNumAndLimit(uint256 _pid, uint256 _maxNum, uint256 _price, uint256 _limitPerAccount) external onlyOperator {
1272         PoolInfo storage pool = pools[_pid];
1273 
1274         require(pool.paused, "NFTFactory::setPoolMaxNumAndLimit: Has started");
1275         require(_limitPerAccount > 0, "NFTFactory::setPoolMaxNumAndLimit: Limit must great than zero");
1276         require(_maxNum > 0, "NFTFactory::setPoolMaxNumAndLimit: Max num must be higher than zero");
1277         require(_maxNum >= pool.supply, "NFTFactory::setPoolMaxNumAndLimit: Max num cap exceeded");
1278 
1279         pool.maxNum = _maxNum;
1280         pool.price = _price;
1281         pool.limitPerAccount = _limitPerAccount;
1282 
1283         emit ChangePoolMaxAndLimit(_pid, _maxNum, _price, _limitPerAccount);
1284     }
1285 
1286     function setPoolRoot(uint256 _pid, bytes32 _root) external onlyOperator {
1287         require(pools[_pid].paused, "NFTFactory::setPoolRoot: Has started");
1288 
1289         pools[_pid].root = _root;
1290         emit SetPoolRoot(_pid, _root);
1291     }
1292 
1293     function pause(uint256 _pid) external onlyOperator {
1294         require(!pools[_pid].paused, "NFTFactory::pause: Has paused");
1295 
1296         pools[_pid].paused = true;
1297         emit Paused(_pid);
1298     }
1299 
1300     function unpause(uint256 _pid) external onlyOperator {
1301         require(pools[_pid].paused, "NFTFactory::pause: Has started");
1302 
1303         pools[_pid].paused = false;
1304         emit Unpaused(_pid);
1305     }
1306 
1307     function totalMaxNum() public view returns (uint256) {
1308         uint256 maxNum;
1309         for (uint256 i = 0; i < pools.length; i++) {
1310             maxNum = maxNum.add(pools[i].maxNum);
1311         }
1312         return maxNum;
1313     }
1314 
1315     function totalSupply() public view returns (uint256) {
1316         uint256 supply;
1317         for (uint256 i = 0; i < pools.length; i++) {
1318             supply = supply.add(pools[i].supply);
1319         }
1320         return supply;
1321     }
1322 
1323     function withdrawETH() public onlyTreasury {
1324         uint256 balance = address(this).balance;
1325         Address.sendValue(msg.sender, balance);
1326 
1327         emit Withdraw(msg.sender, balance);
1328     }
1329 }