1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
152         if (success) {
153             return returndata;
154         } else {
155             // Look for revert reason and bubble it up if present
156             if (returndata.length > 0) {
157                 // The easiest way to bubble the revert reason is using memory via assembly
158 
159                 // solhint-disable-next-line no-inline-assembly
160                 assembly {
161                     let returndata_size := mload(returndata)
162                     revert(add(32, returndata), returndata_size)
163                 }
164             } else {
165                 revert(errorMessage);
166             }
167         }
168     }
169 }
170 
171 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/Context
172 
173 /*
174  * @dev Provides information about the current execution context, including the
175  * sender of the transaction and its data. While these are generally available
176  * via msg.sender and msg.data, they should not be accessed in such a direct
177  * manner, since when dealing with GSN meta-transactions the account sending and
178  * paying for execution may not be the actual sender (as far as an application
179  * is concerned).
180  *
181  * This contract is only required for intermediate, library-like contracts.
182  */
183 abstract contract Context {
184     function _msgSender() internal view virtual returns (address payable) {
185         return msg.sender;
186     }
187 
188     function _msgData() internal view virtual returns (bytes memory) {
189         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
190         return msg.data;
191     }
192 }
193 
194 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/EnumerableSet
195 
196 /**
197  * @dev Library for managing
198  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
199  * types.
200  *
201  * Sets have the following properties:
202  *
203  * - Elements are added, removed, and checked for existence in constant time
204  * (O(1)).
205  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
206  *
207  * ```
208  * contract Example {
209  *     // Add the library methods
210  *     using EnumerableSet for EnumerableSet.AddressSet;
211  *
212  *     // Declare a set state variable
213  *     EnumerableSet.AddressSet private mySet;
214  * }
215  * ```
216  *
217  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
218  * and `uint256` (`UintSet`) are supported.
219  */
220 library EnumerableSet {
221     // To implement this library for multiple types with as little code
222     // repetition as possible, we write it in terms of a generic Set type with
223     // bytes32 values.
224     // The Set implementation uses private functions, and user-facing
225     // implementations (such as AddressSet) are just wrappers around the
226     // underlying Set.
227     // This means that we can only create new EnumerableSets for types that fit
228     // in bytes32.
229 
230     struct Set {
231         // Storage of set values
232         bytes32[] _values;
233 
234         // Position of the value in the `values` array, plus 1 because index 0
235         // means a value is not in the set.
236         mapping (bytes32 => uint256) _indexes;
237     }
238 
239     /**
240      * @dev Add a value to a set. O(1).
241      *
242      * Returns true if the value was added to the set, that is if it was not
243      * already present.
244      */
245     function _add(Set storage set, bytes32 value) private returns (bool) {
246         if (!_contains(set, value)) {
247             set._values.push(value);
248             // The value is stored at length-1, but we add 1 to all indexes
249             // and use 0 as a sentinel value
250             set._indexes[value] = set._values.length;
251             return true;
252         } else {
253             return false;
254         }
255     }
256 
257     /**
258      * @dev Removes a value from a set. O(1).
259      *
260      * Returns true if the value was removed from the set, that is if it was
261      * present.
262      */
263     function _remove(Set storage set, bytes32 value) private returns (bool) {
264         // We read and store the value's index to prevent multiple reads from the same storage slot
265         uint256 valueIndex = set._indexes[value];
266 
267         if (valueIndex != 0) { // Equivalent to contains(set, value)
268             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
269             // the array, and then remove the last element (sometimes called as 'swap and pop').
270             // This modifies the order of the array, as noted in {at}.
271 
272             uint256 toDeleteIndex = valueIndex - 1;
273             uint256 lastIndex = set._values.length - 1;
274 
275             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
276             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
277 
278             bytes32 lastvalue = set._values[lastIndex];
279 
280             // Move the last value to the index where the value to delete is
281             set._values[toDeleteIndex] = lastvalue;
282             // Update the index for the moved value
283             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
284 
285             // Delete the slot where the moved value was stored
286             set._values.pop();
287 
288             // Delete the index for the deleted slot
289             delete set._indexes[value];
290 
291             return true;
292         } else {
293             return false;
294         }
295     }
296 
297     /**
298      * @dev Returns true if the value is in the set. O(1).
299      */
300     function _contains(Set storage set, bytes32 value) private view returns (bool) {
301         return set._indexes[value] != 0;
302     }
303 
304     /**
305      * @dev Returns the number of values on the set. O(1).
306      */
307     function _length(Set storage set) private view returns (uint256) {
308         return set._values.length;
309     }
310 
311    /**
312     * @dev Returns the value stored at position `index` in the set. O(1).
313     *
314     * Note that there are no guarantees on the ordering of values inside the
315     * array, and it may change when more values are added or removed.
316     *
317     * Requirements:
318     *
319     * - `index` must be strictly less than {length}.
320     */
321     function _at(Set storage set, uint256 index) private view returns (bytes32) {
322         require(set._values.length > index, "EnumerableSet: index out of bounds");
323         return set._values[index];
324     }
325 
326     // Bytes32Set
327 
328     struct Bytes32Set {
329         Set _inner;
330     }
331 
332     /**
333      * @dev Add a value to a set. O(1).
334      *
335      * Returns true if the value was added to the set, that is if it was not
336      * already present.
337      */
338     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
339         return _add(set._inner, value);
340     }
341 
342     /**
343      * @dev Removes a value from a set. O(1).
344      *
345      * Returns true if the value was removed from the set, that is if it was
346      * present.
347      */
348     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
349         return _remove(set._inner, value);
350     }
351 
352     /**
353      * @dev Returns true if the value is in the set. O(1).
354      */
355     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
356         return _contains(set._inner, value);
357     }
358 
359     /**
360      * @dev Returns the number of values in the set. O(1).
361      */
362     function length(Bytes32Set storage set) internal view returns (uint256) {
363         return _length(set._inner);
364     }
365 
366    /**
367     * @dev Returns the value stored at position `index` in the set. O(1).
368     *
369     * Note that there are no guarantees on the ordering of values inside the
370     * array, and it may change when more values are added or removed.
371     *
372     * Requirements:
373     *
374     * - `index` must be strictly less than {length}.
375     */
376     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
377         return _at(set._inner, index);
378     }
379 
380     // AddressSet
381 
382     struct AddressSet {
383         Set _inner;
384     }
385 
386     /**
387      * @dev Add a value to a set. O(1).
388      *
389      * Returns true if the value was added to the set, that is if it was not
390      * already present.
391      */
392     function add(AddressSet storage set, address value) internal returns (bool) {
393         return _add(set._inner, bytes32(uint256(value)));
394     }
395 
396     /**
397      * @dev Removes a value from a set. O(1).
398      *
399      * Returns true if the value was removed from the set, that is if it was
400      * present.
401      */
402     function remove(AddressSet storage set, address value) internal returns (bool) {
403         return _remove(set._inner, bytes32(uint256(value)));
404     }
405 
406     /**
407      * @dev Returns true if the value is in the set. O(1).
408      */
409     function contains(AddressSet storage set, address value) internal view returns (bool) {
410         return _contains(set._inner, bytes32(uint256(value)));
411     }
412 
413     /**
414      * @dev Returns the number of values in the set. O(1).
415      */
416     function length(AddressSet storage set) internal view returns (uint256) {
417         return _length(set._inner);
418     }
419 
420    /**
421     * @dev Returns the value stored at position `index` in the set. O(1).
422     *
423     * Note that there are no guarantees on the ordering of values inside the
424     * array, and it may change when more values are added or removed.
425     *
426     * Requirements:
427     *
428     * - `index` must be strictly less than {length}.
429     */
430     function at(AddressSet storage set, uint256 index) internal view returns (address) {
431         return address(uint256(_at(set._inner, index)));
432     }
433 
434 
435     // UintSet
436 
437     struct UintSet {
438         Set _inner;
439     }
440 
441     /**
442      * @dev Add a value to a set. O(1).
443      *
444      * Returns true if the value was added to the set, that is if it was not
445      * already present.
446      */
447     function add(UintSet storage set, uint256 value) internal returns (bool) {
448         return _add(set._inner, bytes32(value));
449     }
450 
451     /**
452      * @dev Removes a value from a set. O(1).
453      *
454      * Returns true if the value was removed from the set, that is if it was
455      * present.
456      */
457     function remove(UintSet storage set, uint256 value) internal returns (bool) {
458         return _remove(set._inner, bytes32(value));
459     }
460 
461     /**
462      * @dev Returns true if the value is in the set. O(1).
463      */
464     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
465         return _contains(set._inner, bytes32(value));
466     }
467 
468     /**
469      * @dev Returns the number of values on the set. O(1).
470      */
471     function length(UintSet storage set) internal view returns (uint256) {
472         return _length(set._inner);
473     }
474 
475    /**
476     * @dev Returns the value stored at position `index` in the set. O(1).
477     *
478     * Note that there are no guarantees on the ordering of values inside the
479     * array, and it may change when more values are added or removed.
480     *
481     * Requirements:
482     *
483     * - `index` must be strictly less than {length}.
484     */
485     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
486         return uint256(_at(set._inner, index));
487     }
488 }
489 
490 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/IERC20
491 
492 /**
493  * @dev Interface of the ERC20 standard as defined in the EIP.
494  */
495 interface IERC20 {
496     /**
497      * @dev Returns the amount of tokens in existence.
498      */
499     function totalSupply() external view returns (uint256);
500 
501     /**
502      * @dev Returns the amount of tokens owned by `account`.
503      */
504     function balanceOf(address account) external view returns (uint256);
505 
506     /**
507      * @dev Moves `amount` tokens from the caller's account to `recipient`.
508      *
509      * Returns a boolean value indicating whether the operation succeeded.
510      *
511      * Emits a {Transfer} event.
512      */
513     function transfer(address recipient, uint256 amount) external returns (bool);
514 
515     /**
516      * @dev Returns the remaining number of tokens that `spender` will be
517      * allowed to spend on behalf of `owner` through {transferFrom}. This is
518      * zero by default.
519      *
520      * This value changes when {approve} or {transferFrom} are called.
521      */
522     function allowance(address owner, address spender) external view returns (uint256);
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
526      *
527      * Returns a boolean value indicating whether the operation succeeded.
528      *
529      * IMPORTANT: Beware that changing an allowance with this method brings the risk
530      * that someone may use both the old and the new allowance by unfortunate
531      * transaction ordering. One possible solution to mitigate this race
532      * condition is to first reduce the spender's allowance to 0 and set the
533      * desired value afterwards:
534      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
535      *
536      * Emits an {Approval} event.
537      */
538     function approve(address spender, uint256 amount) external returns (bool);
539 
540     /**
541      * @dev Moves `amount` tokens from `sender` to `recipient` using the
542      * allowance mechanism. `amount` is then deducted from the caller's
543      * allowance.
544      *
545      * Returns a boolean value indicating whether the operation succeeded.
546      *
547      * Emits a {Transfer} event.
548      */
549     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
550 
551     /**
552      * @dev Emitted when `value` tokens are moved from one account (`from`) to
553      * another (`to`).
554      *
555      * Note that `value` may be zero.
556      */
557     event Transfer(address indexed from, address indexed to, uint256 value);
558 
559     /**
560      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
561      * a call to {approve}. `value` is the new allowance.
562      */
563     event Approval(address indexed owner, address indexed spender, uint256 value);
564 }
565 
566 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/SafeMath
567 
568 /**
569  * @dev Wrappers over Solidity's arithmetic operations with added overflow
570  * checks.
571  *
572  * Arithmetic operations in Solidity wrap on overflow. This can easily result
573  * in bugs, because programmers usually assume that an overflow raises an
574  * error, which is the standard behavior in high level programming languages.
575  * `SafeMath` restores this intuition by reverting the transaction when an
576  * operation overflows.
577  *
578  * Using this library instead of the unchecked operations eliminates an entire
579  * class of bugs, so it's recommended to use it always.
580  */
581 library SafeMath {
582     /**
583      * @dev Returns the addition of two unsigned integers, reverting on
584      * overflow.
585      *
586      * Counterpart to Solidity's `+` operator.
587      *
588      * Requirements:
589      *
590      * - Addition cannot overflow.
591      */
592     function add(uint256 a, uint256 b) internal pure returns (uint256) {
593         uint256 c = a + b;
594         require(c >= a, "SafeMath: addition overflow");
595 
596         return c;
597     }
598 
599     /**
600      * @dev Returns the subtraction of two unsigned integers, reverting on
601      * overflow (when the result is negative).
602      *
603      * Counterpart to Solidity's `-` operator.
604      *
605      * Requirements:
606      *
607      * - Subtraction cannot overflow.
608      */
609     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
610         return sub(a, b, "SafeMath: subtraction overflow");
611     }
612 
613     /**
614      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
615      * overflow (when the result is negative).
616      *
617      * Counterpart to Solidity's `-` operator.
618      *
619      * Requirements:
620      *
621      * - Subtraction cannot overflow.
622      */
623     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
624         require(b <= a, errorMessage);
625         uint256 c = a - b;
626 
627         return c;
628     }
629 
630     /**
631      * @dev Returns the multiplication of two unsigned integers, reverting on
632      * overflow.
633      *
634      * Counterpart to Solidity's `*` operator.
635      *
636      * Requirements:
637      *
638      * - Multiplication cannot overflow.
639      */
640     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
641         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
642         // benefit is lost if 'b' is also tested.
643         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
644         if (a == 0) {
645             return 0;
646         }
647 
648         uint256 c = a * b;
649         require(c / a == b, "SafeMath: multiplication overflow");
650 
651         return c;
652     }
653 
654     /**
655      * @dev Returns the integer division of two unsigned integers. Reverts on
656      * division by zero. The result is rounded towards zero.
657      *
658      * Counterpart to Solidity's `/` operator. Note: this function uses a
659      * `revert` opcode (which leaves remaining gas untouched) while Solidity
660      * uses an invalid opcode to revert (consuming all remaining gas).
661      *
662      * Requirements:
663      *
664      * - The divisor cannot be zero.
665      */
666     function div(uint256 a, uint256 b) internal pure returns (uint256) {
667         return div(a, b, "SafeMath: division by zero");
668     }
669 
670     /**
671      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
672      * division by zero. The result is rounded towards zero.
673      *
674      * Counterpart to Solidity's `/` operator. Note: this function uses a
675      * `revert` opcode (which leaves remaining gas untouched) while Solidity
676      * uses an invalid opcode to revert (consuming all remaining gas).
677      *
678      * Requirements:
679      *
680      * - The divisor cannot be zero.
681      */
682     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
683         require(b > 0, errorMessage);
684         uint256 c = a / b;
685         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
686 
687         return c;
688     }
689 
690     /**
691      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
692      * Reverts when dividing by zero.
693      *
694      * Counterpart to Solidity's `%` operator. This function uses a `revert`
695      * opcode (which leaves remaining gas untouched) while Solidity uses an
696      * invalid opcode to revert (consuming all remaining gas).
697      *
698      * Requirements:
699      *
700      * - The divisor cannot be zero.
701      */
702     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
703         return mod(a, b, "SafeMath: modulo by zero");
704     }
705 
706     /**
707      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
708      * Reverts with custom message when dividing by zero.
709      *
710      * Counterpart to Solidity's `%` operator. This function uses a `revert`
711      * opcode (which leaves remaining gas untouched) while Solidity uses an
712      * invalid opcode to revert (consuming all remaining gas).
713      *
714      * Requirements:
715      *
716      * - The divisor cannot be zero.
717      */
718     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
719         require(b != 0, errorMessage);
720         return a % b;
721     }
722 }
723 
724 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/AccessControl
725 
726 /**
727  * @dev Contract module that allows children to implement role-based access
728  * control mechanisms.
729  *
730  * Roles are referred to by their `bytes32` identifier. These should be exposed
731  * in the external API and be unique. The best way to achieve this is by
732  * using `public constant` hash digests:
733  *
734  * ```
735  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
736  * ```
737  *
738  * Roles can be used to represent a set of permissions. To restrict access to a
739  * function call, use {hasRole}:
740  *
741  * ```
742  * function foo() public {
743  *     require(hasRole(MY_ROLE, msg.sender));
744  *     ...
745  * }
746  * ```
747  *
748  * Roles can be granted and revoked dynamically via the {grantRole} and
749  * {revokeRole} functions. Each role has an associated admin role, and only
750  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
751  *
752  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
753  * that only accounts with this role will be able to grant or revoke other
754  * roles. More complex role relationships can be created by using
755  * {_setRoleAdmin}.
756  *
757  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
758  * grant and revoke this role. Extra precautions should be taken to secure
759  * accounts that have been granted it.
760  */
761 abstract contract AccessControl is Context {
762     using EnumerableSet for EnumerableSet.AddressSet;
763     using Address for address;
764 
765     struct RoleData {
766         EnumerableSet.AddressSet members;
767         bytes32 adminRole;
768     }
769 
770     mapping (bytes32 => RoleData) private _roles;
771 
772     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
773 
774     /**
775      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
776      *
777      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
778      * {RoleAdminChanged} not being emitted signaling this.
779      *
780      * _Available since v3.1._
781      */
782     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
783 
784     /**
785      * @dev Emitted when `account` is granted `role`.
786      *
787      * `sender` is the account that originated the contract call, an admin role
788      * bearer except when using {_setupRole}.
789      */
790     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
791 
792     /**
793      * @dev Emitted when `account` is revoked `role`.
794      *
795      * `sender` is the account that originated the contract call:
796      *   - if using `revokeRole`, it is the admin role bearer
797      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
798      */
799     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
800 
801     /**
802      * @dev Returns `true` if `account` has been granted `role`.
803      */
804     function hasRole(bytes32 role, address account) public view returns (bool) {
805         return _roles[role].members.contains(account);
806     }
807 
808     /**
809      * @dev Returns the number of accounts that have `role`. Can be used
810      * together with {getRoleMember} to enumerate all bearers of a role.
811      */
812     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
813         return _roles[role].members.length();
814     }
815 
816     /**
817      * @dev Returns one of the accounts that have `role`. `index` must be a
818      * value between 0 and {getRoleMemberCount}, non-inclusive.
819      *
820      * Role bearers are not sorted in any particular way, and their ordering may
821      * change at any point.
822      *
823      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
824      * you perform all queries on the same block. See the following
825      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
826      * for more information.
827      */
828     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
829         return _roles[role].members.at(index);
830     }
831 
832     /**
833      * @dev Returns the admin role that controls `role`. See {grantRole} and
834      * {revokeRole}.
835      *
836      * To change a role's admin, use {_setRoleAdmin}.
837      */
838     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
839         return _roles[role].adminRole;
840     }
841 
842     /**
843      * @dev Grants `role` to `account`.
844      *
845      * If `account` had not been already granted `role`, emits a {RoleGranted}
846      * event.
847      *
848      * Requirements:
849      *
850      * - the caller must have ``role``'s admin role.
851      */
852     function grantRole(bytes32 role, address account) public virtual {
853         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
854 
855         _grantRole(role, account);
856     }
857 
858     /**
859      * @dev Revokes `role` from `account`.
860      *
861      * If `account` had been granted `role`, emits a {RoleRevoked} event.
862      *
863      * Requirements:
864      *
865      * - the caller must have ``role``'s admin role.
866      */
867     function revokeRole(bytes32 role, address account) public virtual {
868         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
869 
870         _revokeRole(role, account);
871     }
872 
873     /**
874      * @dev Revokes `role` from the calling account.
875      *
876      * Roles are often managed via {grantRole} and {revokeRole}: this function's
877      * purpose is to provide a mechanism for accounts to lose their privileges
878      * if they are compromised (such as when a trusted device is misplaced).
879      *
880      * If the calling account had been granted `role`, emits a {RoleRevoked}
881      * event.
882      *
883      * Requirements:
884      *
885      * - the caller must be `account`.
886      */
887     function renounceRole(bytes32 role, address account) public virtual {
888         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
889 
890         _revokeRole(role, account);
891     }
892 
893     /**
894      * @dev Grants `role` to `account`.
895      *
896      * If `account` had not been already granted `role`, emits a {RoleGranted}
897      * event. Note that unlike {grantRole}, this function doesn't perform any
898      * checks on the calling account.
899      *
900      * [WARNING]
901      * ====
902      * This function should only be called from the constructor when setting
903      * up the initial roles for the system.
904      *
905      * Using this function in any other way is effectively circumventing the admin
906      * system imposed by {AccessControl}.
907      * ====
908      */
909     function _setupRole(bytes32 role, address account) internal virtual {
910         _grantRole(role, account);
911     }
912 
913     /**
914      * @dev Sets `adminRole` as ``role``'s admin role.
915      *
916      * Emits a {RoleAdminChanged} event.
917      */
918     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
919         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
920         _roles[role].adminRole = adminRole;
921     }
922 
923     function _grantRole(bytes32 role, address account) private {
924         if (_roles[role].members.add(account)) {
925             emit RoleGranted(role, account, _msgSender());
926         }
927     }
928 
929     function _revokeRole(bytes32 role, address account) private {
930         if (_roles[role].members.remove(account)) {
931             emit RoleRevoked(role, account, _msgSender());
932         }
933     }
934 }
935 
936 // Part: OpenZeppelin/openzeppelin-contracts@3.3.0/SafeERC20
937 
938 /**
939  * @title SafeERC20
940  * @dev Wrappers around ERC20 operations that throw on failure (when the token
941  * contract returns false). Tokens that return no value (and instead revert or
942  * throw on failure) are also supported, non-reverting calls are assumed to be
943  * successful.
944  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
945  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
946  */
947 library SafeERC20 {
948     using SafeMath for uint256;
949     using Address for address;
950 
951     function safeTransfer(IERC20 token, address to, uint256 value) internal {
952         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
953     }
954 
955     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
956         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
957     }
958 
959     /**
960      * @dev Deprecated. This function has issues similar to the ones found in
961      * {IERC20-approve}, and its usage is discouraged.
962      *
963      * Whenever possible, use {safeIncreaseAllowance} and
964      * {safeDecreaseAllowance} instead.
965      */
966     function safeApprove(IERC20 token, address spender, uint256 value) internal {
967         // safeApprove should only be called when setting an initial allowance,
968         // or when resetting it to zero. To increase and decrease it, use
969         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
970         // solhint-disable-next-line max-line-length
971         require((value == 0) || (token.allowance(address(this), spender) == 0),
972             "SafeERC20: approve from non-zero to non-zero allowance"
973         );
974         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
975     }
976 
977     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
978         uint256 newAllowance = token.allowance(address(this), spender).add(value);
979         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
980     }
981 
982     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
983         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
984         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
985     }
986 
987     /**
988      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
989      * on the return value: the return value is optional (but if data is returned, it must not be false).
990      * @param token The token targeted by the call.
991      * @param data The call data (encoded using abi.encode or one of its variants).
992      */
993     function _callOptionalReturn(IERC20 token, bytes memory data) private {
994         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
995         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
996         // the target address contains contract code and also asserts for success in the low-level call.
997 
998         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
999         if (returndata.length > 0) { // Return data is optional
1000             // solhint-disable-next-line max-line-length
1001             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1002         }
1003     }
1004 }
1005 
1006 // Part: SafeDecimalMath
1007 
1008 // https://docs.synthetix.io/contracts/SafeDecimalMath
1009 library SafeDecimalMath {
1010     using SafeMath for uint;
1011 
1012     /* Number of decimal places in the representations. */
1013     uint8 public constant decimals = 18;
1014     uint8 public constant highPrecisionDecimals = 27;
1015 
1016     /* The number representing 1.0. */
1017     uint public constant UNIT = 10**uint(decimals);
1018 
1019     /* The number representing 1.0 for higher fidelity numbers. */
1020     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
1021     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
1022 
1023     /**
1024      * @return Provides an interface to UNIT.
1025      */
1026     function unit() external pure returns (uint) {
1027         return UNIT;
1028     }
1029 
1030     /**
1031      * @return Provides an interface to PRECISE_UNIT.
1032      */
1033     function preciseUnit() external pure returns (uint) {
1034         return PRECISE_UNIT;
1035     }
1036 
1037     /**
1038      * @return The result of multiplying x and y, interpreting the operands as fixed-point
1039      * decimals.
1040      *
1041      * @dev A unit factor is divided out after the product of x and y is evaluated,
1042      * so that product must be less than 2**256. As this is an integer division,
1043      * the internal division always rounds down. This helps save on gas. Rounding
1044      * is more expensive on gas.
1045      */
1046     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
1047         /* Divide by UNIT to remove the extra factor introduced by the product. */
1048         return x.mul(y) / UNIT;
1049     }
1050 
1051     /**
1052      * @return The result of safely multiplying x and y, interpreting the operands
1053      * as fixed-point decimals of the specified precision unit.
1054      *
1055      * @dev The operands should be in the form of a the specified unit factor which will be
1056      * divided out after the product of x and y is evaluated, so that product must be
1057      * less than 2**256.
1058      *
1059      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1060      * Rounding is useful when you need to retain fidelity for small decimal numbers
1061      * (eg. small fractions or percentages).
1062      */
1063     function _multiplyDecimalRound(
1064         uint x,
1065         uint y,
1066         uint precisionUnit
1067     ) private pure returns (uint) {
1068         /* Divide by UNIT to remove the extra factor introduced by the product. */
1069         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
1070 
1071         if (quotientTimesTen % 10 >= 5) {
1072             quotientTimesTen += 10;
1073         }
1074 
1075         return quotientTimesTen / 10;
1076     }
1077 
1078     /**
1079      * @return The result of safely multiplying x and y, interpreting the operands
1080      * as fixed-point decimals of a precise unit.
1081      *
1082      * @dev The operands should be in the precise unit factor which will be
1083      * divided out after the product of x and y is evaluated, so that product must be
1084      * less than 2**256.
1085      *
1086      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1087      * Rounding is useful when you need to retain fidelity for small decimal numbers
1088      * (eg. small fractions or percentages).
1089      */
1090     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1091         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
1092     }
1093 
1094     /**
1095      * @return The result of safely multiplying x and y, interpreting the operands
1096      * as fixed-point decimals of a standard unit.
1097      *
1098      * @dev The operands should be in the standard unit factor which will be
1099      * divided out after the product of x and y is evaluated, so that product must be
1100      * less than 2**256.
1101      *
1102      * Unlike multiplyDecimal, this function rounds the result to the nearest increment.
1103      * Rounding is useful when you need to retain fidelity for small decimal numbers
1104      * (eg. small fractions or percentages).
1105      */
1106     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
1107         return _multiplyDecimalRound(x, y, UNIT);
1108     }
1109 
1110     /**
1111      * @return The result of safely dividing x and y. The return value is a high
1112      * precision decimal.
1113      *
1114      * @dev y is divided after the product of x and the standard precision unit
1115      * is evaluated, so the product of x and UNIT must be less than 2**256. As
1116      * this is an integer division, the result is always rounded down.
1117      * This helps save on gas. Rounding is more expensive on gas.
1118      */
1119     function divideDecimal(uint x, uint y) internal pure returns (uint) {
1120         /* Reintroduce the UNIT factor that will be divided out by y. */
1121         return x.mul(UNIT).div(y);
1122     }
1123 
1124     /**
1125      * @return The result of safely dividing x and y. The return value is as a rounded
1126      * decimal in the precision unit specified in the parameter.
1127      *
1128      * @dev y is divided after the product of x and the specified precision unit
1129      * is evaluated, so the product of x and the specified precision unit must
1130      * be less than 2**256. The result is rounded to the nearest increment.
1131      */
1132     function _divideDecimalRound(
1133         uint x,
1134         uint y,
1135         uint precisionUnit
1136     ) private pure returns (uint) {
1137         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
1138 
1139         if (resultTimesTen % 10 >= 5) {
1140             resultTimesTen += 10;
1141         }
1142 
1143         return resultTimesTen / 10;
1144     }
1145 
1146     /**
1147      * @return The result of safely dividing x and y. The return value is as a rounded
1148      * standard precision decimal.
1149      *
1150      * @dev y is divided after the product of x and the standard precision unit
1151      * is evaluated, so the product of x and the standard precision unit must
1152      * be less than 2**256. The result is rounded to the nearest increment.
1153      */
1154     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
1155         return _divideDecimalRound(x, y, UNIT);
1156     }
1157 
1158     /**
1159      * @return The result of safely dividing x and y. The return value is as a rounded
1160      * high precision decimal.
1161      *
1162      * @dev y is divided after the product of x and the high precision unit
1163      * is evaluated, so the product of x and the high precision unit must
1164      * be less than 2**256. The result is rounded to the nearest increment.
1165      */
1166     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
1167         return _divideDecimalRound(x, y, PRECISE_UNIT);
1168     }
1169 
1170     /**
1171      * @dev Convert a standard decimal representation to a high precision one.
1172      */
1173     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
1174         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
1175     }
1176 
1177     /**
1178      * @dev Convert a high precision decimal to a standard decimal representation.
1179      */
1180     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
1181         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
1182 
1183         if (quotientTimesTen % 10 >= 5) {
1184             quotientTimesTen += 10;
1185         }
1186 
1187         return quotientTimesTen / 10;
1188     }
1189 }
1190 
1191 // File: CrossLock.sol
1192 
1193 contract CrossLock is AccessControl {
1194     using SafeERC20 for IERC20;
1195     using SafeMath for uint256;
1196     using SafeDecimalMath for uint256;
1197 
1198     bytes32 public constant CROSSER_ROLE = "CROSSER_ROLE";
1199 
1200     // ethToken => bscToken
1201     mapping(address => address) public supportToken;
1202     // mapping(address => mapping(address => uint256)) public lockAmount;
1203 
1204     // fee
1205     // leave ethereum
1206     mapping(address => uint256) public lockFeeRatio;
1207     mapping(address => uint256) public lockFeeAmount;
1208     // back ethereum
1209     mapping(address => uint256) public unlockFeeRatio;
1210     mapping(address => uint256) public unlockFeeAmount;
1211     //
1212     address public feeTo;
1213 
1214     mapping(string => bool) public txUnlocked;
1215 
1216     event Lock(
1217         address ethToken,
1218         address bscToken,
1219         address locker,
1220         address recipient,
1221         uint256 amount
1222     );
1223     event Unlock(
1224         address ethToken,
1225         address bscToken,
1226         address from,
1227         address recipient,
1228         uint256 amount,
1229         string txid
1230     );
1231     event ChangeAdmin(address oldAdmin, address newAdmin);
1232 
1233     constructor(address _crosser, address _feeTo) public {
1234         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1235         _setupRole(CROSSER_ROLE, _crosser);
1236         feeTo = _feeTo;
1237     }
1238 
1239     function addSupportToken(address ethTokenAddr, address bscTokenAddr)
1240         public
1241         onlyAdmin
1242     {
1243         require(
1244             supportToken[ethTokenAddr] == address(0),
1245             "Toke already Supported"
1246         );
1247         supportToken[ethTokenAddr] = bscTokenAddr;
1248     }
1249 
1250     function removeSupportToken(address ethTokenAddr) public onlyAdmin {
1251         require(supportToken[ethTokenAddr] != address(0), "Toke not Supported");
1252         delete supportToken[ethTokenAddr];
1253     }
1254 
1255     function addSupportTokens(
1256         address[] memory ethTokenAddrs,
1257         address[] memory bscTokenAddrs
1258     ) public {
1259         require(
1260             ethTokenAddrs.length == bscTokenAddrs.length,
1261             "Token length not match"
1262         );
1263         for (uint256 i; i < ethTokenAddrs.length; i++) {
1264             addSupportToken(ethTokenAddrs[i], bscTokenAddrs[i]);
1265         }
1266     }
1267 
1268     function removeSupportTokens(address[] memory addrs) public {
1269         for (uint256 i; i < addrs.length; i++) {
1270             removeSupportToken(addrs[i]);
1271         }
1272     }
1273 
1274     function setFee(
1275         address token,
1276         uint256 _lockFeeAmount,
1277         uint256 _lockFeeRatio,
1278         uint256 _unlockFeeAmount,
1279         uint256 _unlockFeeRatio
1280     ) public onlyAdmin {
1281         require(supportToken[token] != address(0), "Toke not Supported");
1282         lockFeeAmount[token] = _lockFeeAmount;
1283         lockFeeRatio[token] = _lockFeeRatio;
1284         unlockFeeAmount[token] = _unlockFeeAmount;
1285         unlockFeeRatio[token] = _unlockFeeRatio;
1286     }
1287 
1288     function calculateFee(
1289         address token,
1290         uint256 amount,
1291         uint256 crossType
1292     ) public view returns (uint256 feeAmount, uint256 remainAmount) {
1293         uint256 _feeMinAmount;
1294         uint256 _feeRatio;
1295         if (crossType == 0) {
1296             // leave ethereum
1297             _feeMinAmount = lockFeeAmount[token];
1298             _feeRatio = lockFeeRatio[token];
1299         } else {
1300             // back ethereum
1301             _feeMinAmount = unlockFeeAmount[token];
1302             _feeRatio = unlockFeeRatio[token];
1303         }
1304         feeAmount = _feeMinAmount.add(amount.multiplyDecimal(_feeRatio));
1305         remainAmount = amount.sub(feeAmount);
1306     }
1307 
1308     function lock(
1309         address token,
1310         address recipient,
1311         uint256 amount
1312     ) public onlySupportToken(token) {
1313         (uint256 feeAmount, uint256 remainAmount) =
1314             calculateFee(token, amount, 0);
1315         IERC20(token).safeTransferFrom(msg.sender, feeTo, feeAmount);
1316         IERC20(token).safeTransferFrom(msg.sender, address(this), remainAmount);
1317         emit Lock(
1318             token,
1319             supportToken[token],
1320             msg.sender,
1321             recipient,
1322             remainAmount
1323         );
1324     }
1325 
1326     function unlock(
1327         address token,
1328         address from,
1329         address recipient,
1330         uint256 amount,
1331         string memory _txid
1332     ) public onlySupportToken(token) onlyCrosser whenNotUnlocked(_txid) {
1333         (uint256 feeAmount, uint256 remainAmount) =
1334             calculateFee(token, amount, 1);
1335         txUnlocked[_txid] = true;
1336         // lockAmount[token][recipient] = lockAmount[token][recipient].sub(amount);
1337         IERC20(token).safeTransfer(feeTo, feeAmount);
1338         IERC20(token).safeTransfer(recipient, remainAmount);
1339         emit Unlock(token, supportToken[token], from, recipient, remainAmount, _txid);
1340     }
1341 
1342     modifier onlySupportToken(address token) {
1343         require(supportToken[token] != address(0), "Lock::Not Support Token");
1344         _;
1345     }
1346 
1347     modifier onlyAdmin {
1348         require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "caller is not admin");
1349         _;
1350     }
1351 
1352     modifier onlyCrosser {
1353         require(hasRole(CROSSER_ROLE, msg.sender), "caller is not crosser");
1354         _;
1355     }
1356 
1357     modifier whenNotUnlocked(string memory _txid) {
1358         require(txUnlocked[_txid] == false, "tx unlocked");
1359         _;
1360     }
1361 }