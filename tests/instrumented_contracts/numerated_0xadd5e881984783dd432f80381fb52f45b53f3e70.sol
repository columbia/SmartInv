1 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 
164 // File @openzeppelin/contracts/GSN/Context.sol@v3.3.0
165 
166 // SPDX-License-Identifier: MIT
167 
168 pragma solidity >=0.6.0 <0.8.0;
169 
170 /*
171  * @dev Provides information about the current execution context, including the
172  * sender of the transaction and its data. While these are generally available
173  * via msg.sender and msg.data, they should not be accessed in such a direct
174  * manner, since when dealing with GSN meta-transactions the account sending and
175  * paying for execution may not be the actual sender (as far as an application
176  * is concerned).
177  *
178  * This contract is only required for intermediate, library-like contracts.
179  */
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address payable) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes memory) {
186         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
187         return msg.data;
188     }
189 }
190 
191 
192 // File @openzeppelin/contracts/access/Ownable.sol@v3.3.0
193 
194 // SPDX-License-Identifier: MIT
195 
196 pragma solidity >=0.6.0 <0.8.0;
197 
198 /**
199  * @dev Contract module which provides a basic access control mechanism, where
200  * there is an account (an owner) that can be granted exclusive access to
201  * specific functions.
202  *
203  * By default, the owner account will be the one that deploys the contract. This
204  * can later be changed with {transferOwnership}.
205  *
206  * This module is used through inheritance. It will make available the modifier
207  * `onlyOwner`, which can be applied to your functions to restrict their use to
208  * the owner.
209  */
210 abstract contract Ownable is Context {
211     address private _owner;
212 
213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215     /**
216      * @dev Initializes the contract setting the deployer as the initial owner.
217      */
218     constructor () internal {
219         address msgSender = _msgSender();
220         _owner = msgSender;
221         emit OwnershipTransferred(address(0), msgSender);
222     }
223 
224     /**
225      * @dev Returns the address of the current owner.
226      */
227     function owner() public view returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * @dev Throws if called by any account other than the owner.
233      */
234     modifier onlyOwner() {
235         require(_owner == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         emit OwnershipTransferred(_owner, address(0));
248         _owner = address(0);
249     }
250 
251     /**
252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
253      * Can only be called by the current owner.
254      */
255     function transferOwnership(address newOwner) public virtual onlyOwner {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         emit OwnershipTransferred(_owner, newOwner);
258         _owner = newOwner;
259     }
260 }
261 
262 
263 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
264 
265 // SPDX-License-Identifier: MIT
266 
267 pragma solidity >=0.6.0 <0.8.0;
268 
269 /**
270  * @dev Interface of the ERC20 standard as defined in the EIP.
271  */
272 interface IERC20 {
273     /**
274      * @dev Returns the amount of tokens in existence.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     /**
279      * @dev Returns the amount of tokens owned by `account`.
280      */
281     function balanceOf(address account) external view returns (uint256);
282 
283     /**
284      * @dev Moves `amount` tokens from the caller's account to `recipient`.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transfer(address recipient, uint256 amount) external returns (bool);
291 
292     /**
293      * @dev Returns the remaining number of tokens that `spender` will be
294      * allowed to spend on behalf of `owner` through {transferFrom}. This is
295      * zero by default.
296      *
297      * This value changes when {approve} or {transferFrom} are called.
298      */
299     function allowance(address owner, address spender) external view returns (uint256);
300 
301     /**
302      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * IMPORTANT: Beware that changing an allowance with this method brings the risk
307      * that someone may use both the old and the new allowance by unfortunate
308      * transaction ordering. One possible solution to mitigate this race
309      * condition is to first reduce the spender's allowance to 0 and set the
310      * desired value afterwards:
311      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address spender, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Moves `amount` tokens from `sender` to `recipient` using the
319      * allowance mechanism. `amount` is then deducted from the caller's
320      * allowance.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Emitted when `value` tokens are moved from one account (`from`) to
330      * another (`to`).
331      *
332      * Note that `value` may be zero.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 value);
335 
336     /**
337      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
338      * a call to {approve}. `value` is the new allowance.
339      */
340     event Approval(address indexed owner, address indexed spender, uint256 value);
341 }
342 
343 
344 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.3.0
345 
346 // SPDX-License-Identifier: MIT
347 
348 pragma solidity >=0.6.0 <0.8.0;
349 
350 /**
351  * @dev Library for managing
352  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
353  * types.
354  *
355  * Sets have the following properties:
356  *
357  * - Elements are added, removed, and checked for existence in constant time
358  * (O(1)).
359  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
360  *
361  * ```
362  * contract Example {
363  *     // Add the library methods
364  *     using EnumerableSet for EnumerableSet.AddressSet;
365  *
366  *     // Declare a set state variable
367  *     EnumerableSet.AddressSet private mySet;
368  * }
369  * ```
370  *
371  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
372  * and `uint256` (`UintSet`) are supported.
373  */
374 library EnumerableSet {
375     // To implement this library for multiple types with as little code
376     // repetition as possible, we write it in terms of a generic Set type with
377     // bytes32 values.
378     // The Set implementation uses private functions, and user-facing
379     // implementations (such as AddressSet) are just wrappers around the
380     // underlying Set.
381     // This means that we can only create new EnumerableSets for types that fit
382     // in bytes32.
383 
384     struct Set {
385         // Storage of set values
386         bytes32[] _values;
387 
388         // Position of the value in the `values` array, plus 1 because index 0
389         // means a value is not in the set.
390         mapping (bytes32 => uint256) _indexes;
391     }
392 
393     /**
394      * @dev Add a value to a set. O(1).
395      *
396      * Returns true if the value was added to the set, that is if it was not
397      * already present.
398      */
399     function _add(Set storage set, bytes32 value) private returns (bool) {
400         if (!_contains(set, value)) {
401             set._values.push(value);
402             // The value is stored at length-1, but we add 1 to all indexes
403             // and use 0 as a sentinel value
404             set._indexes[value] = set._values.length;
405             return true;
406         } else {
407             return false;
408         }
409     }
410 
411     /**
412      * @dev Removes a value from a set. O(1).
413      *
414      * Returns true if the value was removed from the set, that is if it was
415      * present.
416      */
417     function _remove(Set storage set, bytes32 value) private returns (bool) {
418         // We read and store the value's index to prevent multiple reads from the same storage slot
419         uint256 valueIndex = set._indexes[value];
420 
421         if (valueIndex != 0) { // Equivalent to contains(set, value)
422             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
423             // the array, and then remove the last element (sometimes called as 'swap and pop').
424             // This modifies the order of the array, as noted in {at}.
425 
426             uint256 toDeleteIndex = valueIndex - 1;
427             uint256 lastIndex = set._values.length - 1;
428 
429             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
430             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
431 
432             bytes32 lastvalue = set._values[lastIndex];
433 
434             // Move the last value to the index where the value to delete is
435             set._values[toDeleteIndex] = lastvalue;
436             // Update the index for the moved value
437             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
438 
439             // Delete the slot where the moved value was stored
440             set._values.pop();
441 
442             // Delete the index for the deleted slot
443             delete set._indexes[value];
444 
445             return true;
446         } else {
447             return false;
448         }
449     }
450 
451     /**
452      * @dev Returns true if the value is in the set. O(1).
453      */
454     function _contains(Set storage set, bytes32 value) private view returns (bool) {
455         return set._indexes[value] != 0;
456     }
457 
458     /**
459      * @dev Returns the number of values on the set. O(1).
460      */
461     function _length(Set storage set) private view returns (uint256) {
462         return set._values.length;
463     }
464 
465    /**
466     * @dev Returns the value stored at position `index` in the set. O(1).
467     *
468     * Note that there are no guarantees on the ordering of values inside the
469     * array, and it may change when more values are added or removed.
470     *
471     * Requirements:
472     *
473     * - `index` must be strictly less than {length}.
474     */
475     function _at(Set storage set, uint256 index) private view returns (bytes32) {
476         require(set._values.length > index, "EnumerableSet: index out of bounds");
477         return set._values[index];
478     }
479 
480     // Bytes32Set
481 
482     struct Bytes32Set {
483         Set _inner;
484     }
485 
486     /**
487      * @dev Add a value to a set. O(1).
488      *
489      * Returns true if the value was added to the set, that is if it was not
490      * already present.
491      */
492     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
493         return _add(set._inner, value);
494     }
495 
496     /**
497      * @dev Removes a value from a set. O(1).
498      *
499      * Returns true if the value was removed from the set, that is if it was
500      * present.
501      */
502     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
503         return _remove(set._inner, value);
504     }
505 
506     /**
507      * @dev Returns true if the value is in the set. O(1).
508      */
509     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
510         return _contains(set._inner, value);
511     }
512 
513     /**
514      * @dev Returns the number of values in the set. O(1).
515      */
516     function length(Bytes32Set storage set) internal view returns (uint256) {
517         return _length(set._inner);
518     }
519 
520    /**
521     * @dev Returns the value stored at position `index` in the set. O(1).
522     *
523     * Note that there are no guarantees on the ordering of values inside the
524     * array, and it may change when more values are added or removed.
525     *
526     * Requirements:
527     *
528     * - `index` must be strictly less than {length}.
529     */
530     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
531         return _at(set._inner, index);
532     }
533 
534     // AddressSet
535 
536     struct AddressSet {
537         Set _inner;
538     }
539 
540     /**
541      * @dev Add a value to a set. O(1).
542      *
543      * Returns true if the value was added to the set, that is if it was not
544      * already present.
545      */
546     function add(AddressSet storage set, address value) internal returns (bool) {
547         return _add(set._inner, bytes32(uint256(value)));
548     }
549 
550     /**
551      * @dev Removes a value from a set. O(1).
552      *
553      * Returns true if the value was removed from the set, that is if it was
554      * present.
555      */
556     function remove(AddressSet storage set, address value) internal returns (bool) {
557         return _remove(set._inner, bytes32(uint256(value)));
558     }
559 
560     /**
561      * @dev Returns true if the value is in the set. O(1).
562      */
563     function contains(AddressSet storage set, address value) internal view returns (bool) {
564         return _contains(set._inner, bytes32(uint256(value)));
565     }
566 
567     /**
568      * @dev Returns the number of values in the set. O(1).
569      */
570     function length(AddressSet storage set) internal view returns (uint256) {
571         return _length(set._inner);
572     }
573 
574    /**
575     * @dev Returns the value stored at position `index` in the set. O(1).
576     *
577     * Note that there are no guarantees on the ordering of values inside the
578     * array, and it may change when more values are added or removed.
579     *
580     * Requirements:
581     *
582     * - `index` must be strictly less than {length}.
583     */
584     function at(AddressSet storage set, uint256 index) internal view returns (address) {
585         return address(uint256(_at(set._inner, index)));
586     }
587 
588 
589     // UintSet
590 
591     struct UintSet {
592         Set _inner;
593     }
594 
595     /**
596      * @dev Add a value to a set. O(1).
597      *
598      * Returns true if the value was added to the set, that is if it was not
599      * already present.
600      */
601     function add(UintSet storage set, uint256 value) internal returns (bool) {
602         return _add(set._inner, bytes32(value));
603     }
604 
605     /**
606      * @dev Removes a value from a set. O(1).
607      *
608      * Returns true if the value was removed from the set, that is if it was
609      * present.
610      */
611     function remove(UintSet storage set, uint256 value) internal returns (bool) {
612         return _remove(set._inner, bytes32(value));
613     }
614 
615     /**
616      * @dev Returns true if the value is in the set. O(1).
617      */
618     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
619         return _contains(set._inner, bytes32(value));
620     }
621 
622     /**
623      * @dev Returns the number of values on the set. O(1).
624      */
625     function length(UintSet storage set) internal view returns (uint256) {
626         return _length(set._inner);
627     }
628 
629    /**
630     * @dev Returns the value stored at position `index` in the set. O(1).
631     *
632     * Note that there are no guarantees on the ordering of values inside the
633     * array, and it may change when more values are added or removed.
634     *
635     * Requirements:
636     *
637     * - `index` must be strictly less than {length}.
638     */
639     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
640         return uint256(_at(set._inner, index));
641     }
642 }
643 
644 
645 // File @openzeppelin/contracts/utils/Address.sol@v3.3.0
646 
647 // SPDX-License-Identifier: MIT
648 
649 pragma solidity >=0.6.2 <0.8.0;
650 
651 /**
652  * @dev Collection of functions related to the address type
653  */
654 library Address {
655     /**
656      * @dev Returns true if `account` is a contract.
657      *
658      * [IMPORTANT]
659      * ====
660      * It is unsafe to assume that an address for which this function returns
661      * false is an externally-owned account (EOA) and not a contract.
662      *
663      * Among others, `isContract` will return false for the following
664      * types of addresses:
665      *
666      *  - an externally-owned account
667      *  - a contract in construction
668      *  - an address where a contract will be created
669      *  - an address where a contract lived, but was destroyed
670      * ====
671      */
672     function isContract(address account) internal view returns (bool) {
673         // This method relies on extcodesize, which returns 0 for contracts in
674         // construction, since the code is only stored at the end of the
675         // constructor execution.
676 
677         uint256 size;
678         // solhint-disable-next-line no-inline-assembly
679         assembly { size := extcodesize(account) }
680         return size > 0;
681     }
682 
683     /**
684      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
685      * `recipient`, forwarding all available gas and reverting on errors.
686      *
687      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
688      * of certain opcodes, possibly making contracts go over the 2300 gas limit
689      * imposed by `transfer`, making them unable to receive funds via
690      * `transfer`. {sendValue} removes this limitation.
691      *
692      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
693      *
694      * IMPORTANT: because control is transferred to `recipient`, care must be
695      * taken to not create reentrancy vulnerabilities. Consider using
696      * {ReentrancyGuard} or the
697      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
698      */
699     function sendValue(address payable recipient, uint256 amount) internal {
700         require(address(this).balance >= amount, "Address: insufficient balance");
701 
702         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
703         (bool success, ) = recipient.call{ value: amount }("");
704         require(success, "Address: unable to send value, recipient may have reverted");
705     }
706 
707     /**
708      * @dev Performs a Solidity function call using a low level `call`. A
709      * plain`call` is an unsafe replacement for a function call: use this
710      * function instead.
711      *
712      * If `target` reverts with a revert reason, it is bubbled up by this
713      * function (like regular Solidity function calls).
714      *
715      * Returns the raw returned data. To convert to the expected return value,
716      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
717      *
718      * Requirements:
719      *
720      * - `target` must be a contract.
721      * - calling `target` with `data` must not revert.
722      *
723      * _Available since v3.1._
724      */
725     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
726       return functionCall(target, data, "Address: low-level call failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
731      * `errorMessage` as a fallback revert reason when `target` reverts.
732      *
733      * _Available since v3.1._
734      */
735     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
736         return functionCallWithValue(target, data, 0, errorMessage);
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
741      * but also transferring `value` wei to `target`.
742      *
743      * Requirements:
744      *
745      * - the calling contract must have an ETH balance of at least `value`.
746      * - the called Solidity function must be `payable`.
747      *
748      * _Available since v3.1._
749      */
750     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
751         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
756      * with `errorMessage` as a fallback revert reason when `target` reverts.
757      *
758      * _Available since v3.1._
759      */
760     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
761         require(address(this).balance >= value, "Address: insufficient balance for call");
762         require(isContract(target), "Address: call to non-contract");
763 
764         // solhint-disable-next-line avoid-low-level-calls
765         (bool success, bytes memory returndata) = target.call{ value: value }(data);
766         return _verifyCallResult(success, returndata, errorMessage);
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
771      * but performing a static call.
772      *
773      * _Available since v3.3._
774      */
775     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
776         return functionStaticCall(target, data, "Address: low-level static call failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
786         require(isContract(target), "Address: static call to non-contract");
787 
788         // solhint-disable-next-line avoid-low-level-calls
789         (bool success, bytes memory returndata) = target.staticcall(data);
790         return _verifyCallResult(success, returndata, errorMessage);
791     }
792 
793     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
794         if (success) {
795             return returndata;
796         } else {
797             // Look for revert reason and bubble it up if present
798             if (returndata.length > 0) {
799                 // The easiest way to bubble the revert reason is using memory via assembly
800 
801                 // solhint-disable-next-line no-inline-assembly
802                 assembly {
803                     let returndata_size := mload(returndata)
804                     revert(add(32, returndata), returndata_size)
805                 }
806             } else {
807                 revert(errorMessage);
808             }
809         }
810     }
811 }
812 
813 
814 // File @openzeppelin/contracts/access/AccessControl.sol@v3.3.0
815 
816 // SPDX-License-Identifier: MIT
817 
818 pragma solidity >=0.6.0 <0.8.0;
819 
820 
821 
822 /**
823  * @dev Contract module that allows children to implement role-based access
824  * control mechanisms.
825  *
826  * Roles are referred to by their `bytes32` identifier. These should be exposed
827  * in the external API and be unique. The best way to achieve this is by
828  * using `public constant` hash digests:
829  *
830  * ```
831  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
832  * ```
833  *
834  * Roles can be used to represent a set of permissions. To restrict access to a
835  * function call, use {hasRole}:
836  *
837  * ```
838  * function foo() public {
839  *     require(hasRole(MY_ROLE, msg.sender));
840  *     ...
841  * }
842  * ```
843  *
844  * Roles can be granted and revoked dynamically via the {grantRole} and
845  * {revokeRole} functions. Each role has an associated admin role, and only
846  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
847  *
848  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
849  * that only accounts with this role will be able to grant or revoke other
850  * roles. More complex role relationships can be created by using
851  * {_setRoleAdmin}.
852  *
853  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
854  * grant and revoke this role. Extra precautions should be taken to secure
855  * accounts that have been granted it.
856  */
857 abstract contract AccessControl is Context {
858     using EnumerableSet for EnumerableSet.AddressSet;
859     using Address for address;
860 
861     struct RoleData {
862         EnumerableSet.AddressSet members;
863         bytes32 adminRole;
864     }
865 
866     mapping (bytes32 => RoleData) private _roles;
867 
868     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
869 
870     /**
871      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
872      *
873      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
874      * {RoleAdminChanged} not being emitted signaling this.
875      *
876      * _Available since v3.1._
877      */
878     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
879 
880     /**
881      * @dev Emitted when `account` is granted `role`.
882      *
883      * `sender` is the account that originated the contract call, an admin role
884      * bearer except when using {_setupRole}.
885      */
886     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
887 
888     /**
889      * @dev Emitted when `account` is revoked `role`.
890      *
891      * `sender` is the account that originated the contract call:
892      *   - if using `revokeRole`, it is the admin role bearer
893      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
894      */
895     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
896 
897     /**
898      * @dev Returns `true` if `account` has been granted `role`.
899      */
900     function hasRole(bytes32 role, address account) public view returns (bool) {
901         return _roles[role].members.contains(account);
902     }
903 
904     /**
905      * @dev Returns the number of accounts that have `role`. Can be used
906      * together with {getRoleMember} to enumerate all bearers of a role.
907      */
908     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
909         return _roles[role].members.length();
910     }
911 
912     /**
913      * @dev Returns one of the accounts that have `role`. `index` must be a
914      * value between 0 and {getRoleMemberCount}, non-inclusive.
915      *
916      * Role bearers are not sorted in any particular way, and their ordering may
917      * change at any point.
918      *
919      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
920      * you perform all queries on the same block. See the following
921      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
922      * for more information.
923      */
924     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
925         return _roles[role].members.at(index);
926     }
927 
928     /**
929      * @dev Returns the admin role that controls `role`. See {grantRole} and
930      * {revokeRole}.
931      *
932      * To change a role's admin, use {_setRoleAdmin}.
933      */
934     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
935         return _roles[role].adminRole;
936     }
937 
938     /**
939      * @dev Grants `role` to `account`.
940      *
941      * If `account` had not been already granted `role`, emits a {RoleGranted}
942      * event.
943      *
944      * Requirements:
945      *
946      * - the caller must have ``role``'s admin role.
947      */
948     function grantRole(bytes32 role, address account) public virtual {
949         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
950 
951         _grantRole(role, account);
952     }
953 
954     /**
955      * @dev Revokes `role` from `account`.
956      *
957      * If `account` had been granted `role`, emits a {RoleRevoked} event.
958      *
959      * Requirements:
960      *
961      * - the caller must have ``role``'s admin role.
962      */
963     function revokeRole(bytes32 role, address account) public virtual {
964         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
965 
966         _revokeRole(role, account);
967     }
968 
969     /**
970      * @dev Revokes `role` from the calling account.
971      *
972      * Roles are often managed via {grantRole} and {revokeRole}: this function's
973      * purpose is to provide a mechanism for accounts to lose their privileges
974      * if they are compromised (such as when a trusted device is misplaced).
975      *
976      * If the calling account had been granted `role`, emits a {RoleRevoked}
977      * event.
978      *
979      * Requirements:
980      *
981      * - the caller must be `account`.
982      */
983     function renounceRole(bytes32 role, address account) public virtual {
984         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
985 
986         _revokeRole(role, account);
987     }
988 
989     /**
990      * @dev Grants `role` to `account`.
991      *
992      * If `account` had not been already granted `role`, emits a {RoleGranted}
993      * event. Note that unlike {grantRole}, this function doesn't perform any
994      * checks on the calling account.
995      *
996      * [WARNING]
997      * ====
998      * This function should only be called from the constructor when setting
999      * up the initial roles for the system.
1000      *
1001      * Using this function in any other way is effectively circumventing the admin
1002      * system imposed by {AccessControl}.
1003      * ====
1004      */
1005     function _setupRole(bytes32 role, address account) internal virtual {
1006         _grantRole(role, account);
1007     }
1008 
1009     /**
1010      * @dev Sets `adminRole` as ``role``'s admin role.
1011      *
1012      * Emits a {RoleAdminChanged} event.
1013      */
1014     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1015         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1016         _roles[role].adminRole = adminRole;
1017     }
1018 
1019     function _grantRole(bytes32 role, address account) private {
1020         if (_roles[role].members.add(account)) {
1021             emit RoleGranted(role, account, _msgSender());
1022         }
1023     }
1024 
1025     function _revokeRole(bytes32 role, address account) private {
1026         if (_roles[role].members.remove(account)) {
1027             emit RoleRevoked(role, account, _msgSender());
1028         }
1029     }
1030 }
1031 
1032 
1033 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
1034 
1035 // SPDX-License-Identifier: MIT
1036 
1037 pragma solidity >=0.6.0 <0.8.0;
1038 
1039 
1040 
1041 /**
1042  * @dev Implementation of the {IERC20} interface.
1043  *
1044  * This implementation is agnostic to the way tokens are created. This means
1045  * that a supply mechanism has to be added in a derived contract using {_mint}.
1046  * For a generic mechanism see {ERC20PresetMinterPauser}.
1047  *
1048  * TIP: For a detailed writeup see our guide
1049  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1050  * to implement supply mechanisms].
1051  *
1052  * We have followed general OpenZeppelin guidelines: functions revert instead
1053  * of returning `false` on failure. This behavior is nonetheless conventional
1054  * and does not conflict with the expectations of ERC20 applications.
1055  *
1056  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1057  * This allows applications to reconstruct the allowance for all accounts just
1058  * by listening to said events. Other implementations of the EIP may not emit
1059  * these events, as it isn't required by the specification.
1060  *
1061  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1062  * functions have been added to mitigate the well-known issues around setting
1063  * allowances. See {IERC20-approve}.
1064  */
1065 contract ERC20 is Context, IERC20 {
1066     using SafeMath for uint256;
1067 
1068     mapping (address => uint256) private _balances;
1069 
1070     mapping (address => mapping (address => uint256)) private _allowances;
1071 
1072     uint256 private _totalSupply;
1073 
1074     string private _name;
1075     string private _symbol;
1076     uint8 private _decimals;
1077 
1078     /**
1079      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1080      * a default value of 18.
1081      *
1082      * To select a different value for {decimals}, use {_setupDecimals}.
1083      *
1084      * All three of these values are immutable: they can only be set once during
1085      * construction.
1086      */
1087     constructor (string memory name_, string memory symbol_) public {
1088         _name = name_;
1089         _symbol = symbol_;
1090         _decimals = 18;
1091     }
1092 
1093     /**
1094      * @dev Returns the name of the token.
1095      */
1096     function name() public view returns (string memory) {
1097         return _name;
1098     }
1099 
1100     /**
1101      * @dev Returns the symbol of the token, usually a shorter version of the
1102      * name.
1103      */
1104     function symbol() public view returns (string memory) {
1105         return _symbol;
1106     }
1107 
1108     /**
1109      * @dev Returns the number of decimals used to get its user representation.
1110      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1111      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1112      *
1113      * Tokens usually opt for a value of 18, imitating the relationship between
1114      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1115      * called.
1116      *
1117      * NOTE: This information is only used for _display_ purposes: it in
1118      * no way affects any of the arithmetic of the contract, including
1119      * {IERC20-balanceOf} and {IERC20-transfer}.
1120      */
1121     function decimals() public view returns (uint8) {
1122         return _decimals;
1123     }
1124 
1125     /**
1126      * @dev See {IERC20-totalSupply}.
1127      */
1128     function totalSupply() public view override returns (uint256) {
1129         return _totalSupply;
1130     }
1131 
1132     /**
1133      * @dev See {IERC20-balanceOf}.
1134      */
1135     function balanceOf(address account) public view override returns (uint256) {
1136         return _balances[account];
1137     }
1138 
1139     /**
1140      * @dev See {IERC20-transfer}.
1141      *
1142      * Requirements:
1143      *
1144      * - `recipient` cannot be the zero address.
1145      * - the caller must have a balance of at least `amount`.
1146      */
1147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1148         _transfer(_msgSender(), recipient, amount);
1149         return true;
1150     }
1151 
1152     /**
1153      * @dev See {IERC20-allowance}.
1154      */
1155     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1156         return _allowances[owner][spender];
1157     }
1158 
1159     /**
1160      * @dev See {IERC20-approve}.
1161      *
1162      * Requirements:
1163      *
1164      * - `spender` cannot be the zero address.
1165      */
1166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1167         _approve(_msgSender(), spender, amount);
1168         return true;
1169     }
1170 
1171     /**
1172      * @dev See {IERC20-transferFrom}.
1173      *
1174      * Emits an {Approval} event indicating the updated allowance. This is not
1175      * required by the EIP. See the note at the beginning of {ERC20}.
1176      *
1177      * Requirements:
1178      *
1179      * - `sender` and `recipient` cannot be the zero address.
1180      * - `sender` must have a balance of at least `amount`.
1181      * - the caller must have allowance for ``sender``'s tokens of at least
1182      * `amount`.
1183      */
1184     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1185         _transfer(sender, recipient, amount);
1186         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1187         return true;
1188     }
1189 
1190     /**
1191      * @dev Atomically increases the allowance granted to `spender` by the caller.
1192      *
1193      * This is an alternative to {approve} that can be used as a mitigation for
1194      * problems described in {IERC20-approve}.
1195      *
1196      * Emits an {Approval} event indicating the updated allowance.
1197      *
1198      * Requirements:
1199      *
1200      * - `spender` cannot be the zero address.
1201      */
1202     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1204         return true;
1205     }
1206 
1207     /**
1208      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1209      *
1210      * This is an alternative to {approve} that can be used as a mitigation for
1211      * problems described in {IERC20-approve}.
1212      *
1213      * Emits an {Approval} event indicating the updated allowance.
1214      *
1215      * Requirements:
1216      *
1217      * - `spender` cannot be the zero address.
1218      * - `spender` must have allowance for the caller of at least
1219      * `subtractedValue`.
1220      */
1221     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1222         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1223         return true;
1224     }
1225 
1226     /**
1227      * @dev Moves tokens `amount` from `sender` to `recipient`.
1228      *
1229      * This is internal function is equivalent to {transfer}, and can be used to
1230      * e.g. implement automatic token fees, slashing mechanisms, etc.
1231      *
1232      * Emits a {Transfer} event.
1233      *
1234      * Requirements:
1235      *
1236      * - `sender` cannot be the zero address.
1237      * - `recipient` cannot be the zero address.
1238      * - `sender` must have a balance of at least `amount`.
1239      */
1240     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1241         require(sender != address(0), "ERC20: transfer from the zero address");
1242         require(recipient != address(0), "ERC20: transfer to the zero address");
1243 
1244         _beforeTokenTransfer(sender, recipient, amount);
1245 
1246         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1247         _balances[recipient] = _balances[recipient].add(amount);
1248         emit Transfer(sender, recipient, amount);
1249     }
1250 
1251     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1252      * the total supply.
1253      *
1254      * Emits a {Transfer} event with `from` set to the zero address.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      */
1260     function _mint(address account, uint256 amount) internal virtual {
1261         require(account != address(0), "ERC20: mint to the zero address");
1262 
1263         _beforeTokenTransfer(address(0), account, amount);
1264 
1265         _totalSupply = _totalSupply.add(amount);
1266         _balances[account] = _balances[account].add(amount);
1267         emit Transfer(address(0), account, amount);
1268     }
1269 
1270     /**
1271      * @dev Destroys `amount` tokens from `account`, reducing the
1272      * total supply.
1273      *
1274      * Emits a {Transfer} event with `to` set to the zero address.
1275      *
1276      * Requirements:
1277      *
1278      * - `account` cannot be the zero address.
1279      * - `account` must have at least `amount` tokens.
1280      */
1281     function _burn(address account, uint256 amount) internal virtual {
1282         require(account != address(0), "ERC20: burn from the zero address");
1283 
1284         _beforeTokenTransfer(account, address(0), amount);
1285 
1286         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1287         _totalSupply = _totalSupply.sub(amount);
1288         emit Transfer(account, address(0), amount);
1289     }
1290 
1291     /**
1292      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1293      *
1294      * This internal function is equivalent to `approve`, and can be used to
1295      * e.g. set automatic allowances for certain subsystems, etc.
1296      *
1297      * Emits an {Approval} event.
1298      *
1299      * Requirements:
1300      *
1301      * - `owner` cannot be the zero address.
1302      * - `spender` cannot be the zero address.
1303      */
1304     function _approve(address owner, address spender, uint256 amount) internal virtual {
1305         require(owner != address(0), "ERC20: approve from the zero address");
1306         require(spender != address(0), "ERC20: approve to the zero address");
1307 
1308         _allowances[owner][spender] = amount;
1309         emit Approval(owner, spender, amount);
1310     }
1311 
1312     /**
1313      * @dev Sets {decimals} to a value other than the default one of 18.
1314      *
1315      * WARNING: This function should only be called from the constructor. Most
1316      * applications that interact with token contracts will not expect
1317      * {decimals} to ever change, and may work incorrectly if it does.
1318      */
1319     function _setupDecimals(uint8 decimals_) internal {
1320         _decimals = decimals_;
1321     }
1322 
1323     /**
1324      * @dev Hook that is called before any transfer of tokens. This includes
1325      * minting and burning.
1326      *
1327      * Calling conditions:
1328      *
1329      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1330      * will be to transferred to `to`.
1331      * - when `from` is zero, `amount` tokens will be minted for `to`.
1332      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1333      * - `from` and `to` are never both zero.
1334      *
1335      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1336      */
1337     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1338 }
1339 
1340 
1341 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.3.0
1342 
1343 // SPDX-License-Identifier: MIT
1344 
1345 pragma solidity >=0.6.0 <0.8.0;
1346 
1347 
1348 /**
1349  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1350  * tokens and those that they have an allowance for, in a way that can be
1351  * recognized off-chain (via event analysis).
1352  */
1353 abstract contract ERC20Burnable is Context, ERC20 {
1354     using SafeMath for uint256;
1355 
1356     /**
1357      * @dev Destroys `amount` tokens from the caller.
1358      *
1359      * See {ERC20-_burn}.
1360      */
1361     function burn(uint256 amount) public virtual {
1362         _burn(_msgSender(), amount);
1363     }
1364 
1365     /**
1366      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1367      * allowance.
1368      *
1369      * See {ERC20-_burn} and {ERC20-allowance}.
1370      *
1371      * Requirements:
1372      *
1373      * - the caller must have allowance for ``accounts``'s tokens of at least
1374      * `amount`.
1375      */
1376     function burnFrom(address account, uint256 amount) public virtual {
1377         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1378 
1379         _approve(account, _msgSender(), decreasedAllowance);
1380         _burn(account, amount);
1381     }
1382 }
1383 
1384 
1385 // File @openzeppelin/contracts/utils/Pausable.sol@v3.3.0
1386 
1387 // SPDX-License-Identifier: MIT
1388 
1389 pragma solidity >=0.6.0 <0.8.0;
1390 
1391 /**
1392  * @dev Contract module which allows children to implement an emergency stop
1393  * mechanism that can be triggered by an authorized account.
1394  *
1395  * This module is used through inheritance. It will make available the
1396  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1397  * the functions of your contract. Note that they will not be pausable by
1398  * simply including this module, only once the modifiers are put in place.
1399  */
1400 abstract contract Pausable is Context {
1401     /**
1402      * @dev Emitted when the pause is triggered by `account`.
1403      */
1404     event Paused(address account);
1405 
1406     /**
1407      * @dev Emitted when the pause is lifted by `account`.
1408      */
1409     event Unpaused(address account);
1410 
1411     bool private _paused;
1412 
1413     /**
1414      * @dev Initializes the contract in unpaused state.
1415      */
1416     constructor () internal {
1417         _paused = false;
1418     }
1419 
1420     /**
1421      * @dev Returns true if the contract is paused, and false otherwise.
1422      */
1423     function paused() public view returns (bool) {
1424         return _paused;
1425     }
1426 
1427     /**
1428      * @dev Modifier to make a function callable only when the contract is not paused.
1429      *
1430      * Requirements:
1431      *
1432      * - The contract must not be paused.
1433      */
1434     modifier whenNotPaused() {
1435         require(!_paused, "Pausable: paused");
1436         _;
1437     }
1438 
1439     /**
1440      * @dev Modifier to make a function callable only when the contract is paused.
1441      *
1442      * Requirements:
1443      *
1444      * - The contract must be paused.
1445      */
1446     modifier whenPaused() {
1447         require(_paused, "Pausable: not paused");
1448         _;
1449     }
1450 
1451     /**
1452      * @dev Triggers stopped state.
1453      *
1454      * Requirements:
1455      *
1456      * - The contract must not be paused.
1457      */
1458     function _pause() internal virtual whenNotPaused {
1459         _paused = true;
1460         emit Paused(_msgSender());
1461     }
1462 
1463     /**
1464      * @dev Returns to normal state.
1465      *
1466      * Requirements:
1467      *
1468      * - The contract must be paused.
1469      */
1470     function _unpause() internal virtual whenPaused {
1471         _paused = false;
1472         emit Unpaused(_msgSender());
1473     }
1474 }
1475 
1476 
1477 // File @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol@v3.3.0
1478 
1479 // SPDX-License-Identifier: MIT
1480 
1481 pragma solidity >=0.6.0 <0.8.0;
1482 
1483 
1484 /**
1485  * @dev ERC20 token with pausable token transfers, minting and burning.
1486  *
1487  * Useful for scenarios such as preventing trades until the end of an evaluation
1488  * period, or having an emergency switch for freezing all token transfers in the
1489  * event of a large bug.
1490  */
1491 abstract contract ERC20Pausable is ERC20, Pausable {
1492     /**
1493      * @dev See {ERC20-_beforeTokenTransfer}.
1494      *
1495      * Requirements:
1496      *
1497      * - the contract must not be paused.
1498      */
1499     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1500         super._beforeTokenTransfer(from, to, amount);
1501 
1502         require(!paused(), "ERC20Pausable: token transfer while paused");
1503     }
1504 }
1505 
1506 
1507 // File @openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol@v3.3.0
1508 
1509 // SPDX-License-Identifier: MIT
1510 
1511 pragma solidity >=0.6.0 <0.8.0;
1512 
1513 
1514 
1515 
1516 
1517 /**
1518  * @dev {ERC20} token, including:
1519  *
1520  *  - ability for holders to burn (destroy) their tokens
1521  *  - a minter role that allows for token minting (creation)
1522  *  - a pauser role that allows to stop all token transfers
1523  *
1524  * This contract uses {AccessControl} to lock permissioned functions using the
1525  * different roles - head to its documentation for details.
1526  *
1527  * The account that deploys the contract will be granted the minter and pauser
1528  * roles, as well as the default admin role, which will let it grant both minter
1529  * and pauser roles to other accounts.
1530  */
1531 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1532     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1533     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1534 
1535     /**
1536      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1537      * account that deploys the contract.
1538      *
1539      * See {ERC20-constructor}.
1540      */
1541     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1542         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1543 
1544         _setupRole(MINTER_ROLE, _msgSender());
1545         _setupRole(PAUSER_ROLE, _msgSender());
1546     }
1547 
1548     /**
1549      * @dev Creates `amount` new tokens for `to`.
1550      *
1551      * See {ERC20-_mint}.
1552      *
1553      * Requirements:
1554      *
1555      * - the caller must have the `MINTER_ROLE`.
1556      */
1557     function mint(address to, uint256 amount) public virtual {
1558         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1559         _mint(to, amount);
1560     }
1561 
1562     /**
1563      * @dev Pauses all token transfers.
1564      *
1565      * See {ERC20Pausable} and {Pausable-_pause}.
1566      *
1567      * Requirements:
1568      *
1569      * - the caller must have the `PAUSER_ROLE`.
1570      */
1571     function pause() public virtual {
1572         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1573         _pause();
1574     }
1575 
1576     /**
1577      * @dev Unpauses all token transfers.
1578      *
1579      * See {ERC20Pausable} and {Pausable-_unpause}.
1580      *
1581      * Requirements:
1582      *
1583      * - the caller must have the `PAUSER_ROLE`.
1584      */
1585     function unpause() public virtual {
1586         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1587         _unpause();
1588     }
1589 
1590     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1591         super._beforeTokenTransfer(from, to, amount);
1592     }
1593 }
1594 
1595 
1596 // File contracts/ViteToken.sol
1597 
1598 // contracts/ViteToken.sol
1599 // SPDX-License-Identifier: GPL-3.03
1600 pragma solidity ^0.6.0;
1601 
1602 // @openzeppelin/contracts@v3.3.0
1603 
1604 
1605 
1606 
1607 contract ViteToken is ERC20PresetMinterPauser {
1608     uint256 private erc20_decimals = 18;
1609     uint256 private erc20_units = 10**erc20_decimals;
1610 
1611     constructor() public ERC20PresetMinterPauser("Vite", "VITE") {}
1612 
1613     /**
1614      * @dev See {ERC20-_beforeTokenTransfer}.
1615      */
1616     function _beforeTokenTransfer(
1617         address from,
1618         address to,
1619         uint256 amount
1620     ) internal override(ERC20PresetMinterPauser) {
1621         super._beforeTokenTransfer(from, to, amount);
1622     }
1623 }