1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 library EnumerableSet {
28     // To implement this library for multiple types with as little code
29     // repetition as possible, we write it in terms of a generic Set type with
30     // bytes32 values.
31     // The Set implementation uses private functions, and user-facing
32     // implementations (such as AddressSet) are just wrappers around the
33     // underlying Set.
34     // This means that we can only create new EnumerableSets for types that fit
35     // in bytes32.
36 
37     struct Set {
38         // Storage of set values
39         bytes32[] _values;
40 
41         // Position of the value in the `values` array, plus 1 because index 0
42         // means a value is not in the set.
43         mapping (bytes32 => uint256) _indexes;
44     }
45 
46     /**
47      * @dev Add a value to a set. O(1).
48      *
49      * Returns true if the value was added to the set, that is if it was not
50      * already present.
51      */
52     function _add(Set storage set, bytes32 value) private returns (bool) {
53         if (!_contains(set, value)) {
54             set._values.push(value);
55             // The value is stored at length-1, but we add 1 to all indexes
56             // and use 0 as a sentinel value
57             set._indexes[value] = set._values.length;
58             return true;
59         } else {
60             return false;
61         }
62     }
63 
64     /**
65      * @dev Removes a value from a set. O(1).
66      *
67      * Returns true if the value was removed from the set, that is if it was
68      * present.
69      */
70     function _remove(Set storage set, bytes32 value) private returns (bool) {
71         // We read and store the value's index to prevent multiple reads from the same storage slot
72         uint256 valueIndex = set._indexes[value];
73 
74         if (valueIndex != 0) { // Equivalent to contains(set, value)
75             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
76             // the array, and then remove the last element (sometimes called as 'swap and pop').
77             // This modifies the order of the array, as noted in {at}.
78 
79             uint256 toDeleteIndex = valueIndex - 1;
80             uint256 lastIndex = set._values.length - 1;
81 
82             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
83             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
84 
85             bytes32 lastvalue = set._values[lastIndex];
86 
87             // Move the last value to the index where the value to delete is
88             set._values[toDeleteIndex] = lastvalue;
89             // Update the index for the moved value
90             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
91 
92             // Delete the slot where the moved value was stored
93             set._values.pop();
94 
95             // Delete the index for the deleted slot
96             delete set._indexes[value];
97 
98             return true;
99         } else {
100             return false;
101         }
102     }
103 
104     /**
105      * @dev Returns true if the value is in the set. O(1).
106      */
107     function _contains(Set storage set, bytes32 value) private view returns (bool) {
108         return set._indexes[value] != 0;
109     }
110 
111     /**
112      * @dev Returns the number of values on the set. O(1).
113      */
114     function _length(Set storage set) private view returns (uint256) {
115         return set._values.length;
116     }
117 
118    /**
119     * @dev Returns the value stored at position `index` in the set. O(1).
120     *
121     * Note that there are no guarantees on the ordering of values inside the
122     * array, and it may change when more values are added or removed.
123     *
124     * Requirements:
125     *
126     * - `index` must be strictly less than {length}.
127     */
128     function _at(Set storage set, uint256 index) private view returns (bytes32) {
129         require(set._values.length > index, "EnumerableSet: index out of bounds");
130         return set._values[index];
131     }
132 
133     // AddressSet
134 
135     struct AddressSet {
136         Set _inner;
137     }
138 
139     /**
140      * @dev Add a value to a set. O(1).
141      *
142      * Returns true if the value was added to the set, that is if it was not
143      * already present.
144      */
145     function add(AddressSet storage set, address value) internal returns (bool) {
146         return _add(set._inner, bytes32(uint256(value)));
147     }
148 
149     /**
150      * @dev Removes a value from a set. O(1).
151      *
152      * Returns true if the value was removed from the set, that is if it was
153      * present.
154      */
155     function remove(AddressSet storage set, address value) internal returns (bool) {
156         return _remove(set._inner, bytes32(uint256(value)));
157     }
158 
159     /**
160      * @dev Returns true if the value is in the set. O(1).
161      */
162     function contains(AddressSet storage set, address value) internal view returns (bool) {
163         return _contains(set._inner, bytes32(uint256(value)));
164     }
165 
166     /**
167      * @dev Returns the number of values in the set. O(1).
168      */
169     function length(AddressSet storage set) internal view returns (uint256) {
170         return _length(set._inner);
171     }
172 
173    /**
174     * @dev Returns the value stored at position `index` in the set. O(1).
175     *
176     * Note that there are no guarantees on the ordering of values inside the
177     * array, and it may change when more values are added or removed.
178     *
179     * Requirements:
180     *
181     * - `index` must be strictly less than {length}.
182     */
183     function at(AddressSet storage set, uint256 index) internal view returns (address) {
184         return address(uint256(_at(set._inner, index)));
185     }
186 
187 
188     // UintSet
189 
190     struct UintSet {
191         Set _inner;
192     }
193 
194     /**
195      * @dev Add a value to a set. O(1).
196      *
197      * Returns true if the value was added to the set, that is if it was not
198      * already present.
199      */
200     function add(UintSet storage set, uint256 value) internal returns (bool) {
201         return _add(set._inner, bytes32(value));
202     }
203 
204     /**
205      * @dev Removes a value from a set. O(1).
206      *
207      * Returns true if the value was removed from the set, that is if it was
208      * present.
209      */
210     function remove(UintSet storage set, uint256 value) internal returns (bool) {
211         return _remove(set._inner, bytes32(value));
212     }
213 
214     /**
215      * @dev Returns true if the value is in the set. O(1).
216      */
217     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
218         return _contains(set._inner, bytes32(value));
219     }
220 
221     /**
222      * @dev Returns the number of values on the set. O(1).
223      */
224     function length(UintSet storage set) internal view returns (uint256) {
225         return _length(set._inner);
226     }
227 
228    /**
229     * @dev Returns the value stored at position `index` in the set. O(1).
230     *
231     * Note that there are no guarantees on the ordering of values inside the
232     * array, and it may change when more values are added or removed.
233     *
234     * Requirements:
235     *
236     * - `index` must be strictly less than {length}.
237     */
238     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
239         return uint256(_at(set._inner, index));
240     }
241 }
242 
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         // solhint-disable-next-line no-inline-assembly
268         assembly { size := extcodesize(account) }
269         return size > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292         (bool success, ) = recipient.call{ value: amount }("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain`call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315       return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: value }(data);
355         return _verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
365         return functionStaticCall(target, data, "Address: low-level static call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
375         require(isContract(target), "Address: static call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.staticcall(data);
379         return _verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.3._
387      */
388     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.3._
397      */
398     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return _verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
407         if (success) {
408             return returndata;
409         } else {
410             // Look for revert reason and bubble it up if present
411             if (returndata.length > 0) {
412                 // The easiest way to bubble the revert reason is using memory via assembly
413 
414                 // solhint-disable-next-line no-inline-assembly
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 /**
427  * @title Ownable
428  * @dev The Ownable contract has an owner address, and provides basic authorization control
429  * functions, this simplifies the implementation of "user permissions".
430  */
431 contract Ownable {
432     address private _owner;
433 
434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436     /**
437      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
438      * account.
439      */
440     constructor () internal {
441         _owner = msg.sender;
442         emit OwnershipTransferred(address(0), _owner);
443     }
444 
445     /**
446      * @return the address of the owner.
447      */
448     function owner() public view returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if called by any account other than the owner.
454      */
455     modifier onlyOwner() {
456         require(isOwner());
457         _;
458     }
459 
460     /**
461      * @return true if `msg.sender` is the owner of the contract.
462      */
463     function isOwner() public view returns (bool) {
464         return msg.sender == _owner;
465     }
466 
467     /**
468      * @dev Allows the current owner to relinquish control of the contract.
469      * @notice Renouncing to ownership will leave the contract without an owner.
470      * It will not be possible to call the functions with the `onlyOwner`
471      * modifier anymore.
472      */
473     function renounceOwnership() public onlyOwner {
474         emit OwnershipTransferred(_owner, address(0));
475         _owner = address(0);
476     }
477 
478     /**
479      * @dev Allows the current owner to transfer control of the contract to a newOwner.
480      * @param newOwner The address to transfer ownership to.
481      */
482     function transferOwnership(address newOwner) public onlyOwner {
483         _transferOwnership(newOwner);
484     }
485 
486     /**
487      * @dev Transfers control of the contract to a newOwner.
488      * @param newOwner The address to transfer ownership to.
489      */
490     function _transferOwnership(address newOwner) internal {
491         require(newOwner != address(0));
492         emit OwnershipTransferred(_owner, newOwner);
493         _owner = newOwner;
494     }
495 }
496 
497 
498 /**
499  * @dev Interface of the ERC20 standard as defined in the EIP.
500  */
501 interface IERC20 {
502     /**
503      * @dev Returns the amount of tokens in existence.
504      */
505     function totalSupply() external view returns (uint256);
506 
507     /**
508      * @dev Returns the amount of tokens owned by `account`.
509      */
510     function balanceOf(address account) external view returns (uint256);
511 
512     /**
513      * @dev Moves `amount` tokens from the caller's account to `recipient`.
514      *
515      * Returns a boolean value indicating whether the operation succeeded.
516      *
517      * Emits a {Transfer} event.
518      */
519     function transfer(address recipient, uint256 amount) external returns (bool);
520 
521     /**
522      * @dev Returns the remaining number of tokens that `spender` will be
523      * allowed to spend on behalf of `owner` through {transferFrom}. This is
524      * zero by default.
525      *
526      * This value changes when {approve} or {transferFrom} are called.
527      */
528     function allowance(address owner, address spender) external view returns (uint256);
529 
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
532      *
533      * Returns a boolean value indicating whether the operation succeeded.
534      *
535      * IMPORTANT: Beware that changing an allowance with this method brings the risk
536      * that someone may use both the old and the new allowance by unfortunate
537      * transaction ordering. One possible solution to mitigate this race
538      * condition is to first reduce the spender's allowance to 0 and set the
539      * desired value afterwards:
540      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
541      *
542      * Emits an {Approval} event.
543      */
544     function approve(address spender, uint256 amount) external returns (bool);
545 
546     /**
547      * @dev Moves `amount` tokens from `sender` to `recipient` using the
548      * allowance mechanism. `amount` is then deducted from the caller's
549      * allowance.
550      *
551      * Returns a boolean value indicating whether the operation succeeded.
552      *
553      * Emits a {Transfer} event.
554      */
555     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
556 
557     /**
558      * @dev Emitted when `value` tokens are moved from one account (`from`) to
559      * another (`to`).
560      *
561      * Note that `value` may be zero.
562      */
563     event Transfer(address indexed from, address indexed to, uint256 value);
564 
565     /**
566      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
567      * a call to {approve}. `value` is the new allowance.
568      */
569     event Approval(address indexed owner, address indexed spender, uint256 value);
570 }
571 
572 /**
573  * @dev Wrappers over Solidity's arithmetic operations with added overflow
574  * checks.
575  *
576  * Arithmetic operations in Solidity wrap on overflow. This can easily result
577  * in bugs, because programmers usually assume that an overflow raises an
578  * error, which is the standard behavior in high level programming languages.
579  * `SafeMath` restores this intuition by reverting the transaction when an
580  * operation overflows.
581  *
582  * Using this library instead of the unchecked operations eliminates an entire
583  * class of bugs, so it's recommended to use it always.
584  */
585 library SafeMath {
586     /**
587      * @dev Returns the addition of two unsigned integers, reverting on
588      * overflow.
589      *
590      * Counterpart to Solidity's `+` operator.
591      *
592      * Requirements:
593      *
594      * - Addition cannot overflow.
595      */
596     function add(uint256 a, uint256 b) internal pure returns (uint256) {
597         uint256 c = a + b;
598         require(c >= a, "SafeMath: addition overflow");
599 
600         return c;
601     }
602 
603     /**
604      * @dev Returns the subtraction of two unsigned integers, reverting on
605      * overflow (when the result is negative).
606      *
607      * Counterpart to Solidity's `-` operator.
608      *
609      * Requirements:
610      *
611      * - Subtraction cannot overflow.
612      */
613     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
614         return sub(a, b, "SafeMath: subtraction overflow");
615     }
616 
617     /**
618      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
619      * overflow (when the result is negative).
620      *
621      * Counterpart to Solidity's `-` operator.
622      *
623      * Requirements:
624      *
625      * - Subtraction cannot overflow.
626      */
627     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
628         require(b <= a, errorMessage);
629         uint256 c = a - b;
630 
631         return c;
632     }
633 
634     /**
635      * @dev Returns the multiplication of two unsigned integers, reverting on
636      * overflow.
637      *
638      * Counterpart to Solidity's `*` operator.
639      *
640      * Requirements:
641      *
642      * - Multiplication cannot overflow.
643      */
644     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
645         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
646         // benefit is lost if 'b' is also tested.
647         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
648         if (a == 0) {
649             return 0;
650         }
651 
652         uint256 c = a * b;
653         require(c / a == b, "SafeMath: multiplication overflow");
654 
655         return c;
656     }
657 
658     /**
659      * @dev Returns the integer division of two unsigned integers. Reverts on
660      * division by zero. The result is rounded towards zero.
661      *
662      * Counterpart to Solidity's `/` operator. Note: this function uses a
663      * `revert` opcode (which leaves remaining gas untouched) while Solidity
664      * uses an invalid opcode to revert (consuming all remaining gas).
665      *
666      * Requirements:
667      *
668      * - The divisor cannot be zero.
669      */
670     function div(uint256 a, uint256 b) internal pure returns (uint256) {
671         return div(a, b, "SafeMath: division by zero");
672     }
673 
674     /**
675      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
676      * division by zero. The result is rounded towards zero.
677      *
678      * Counterpart to Solidity's `/` operator. Note: this function uses a
679      * `revert` opcode (which leaves remaining gas untouched) while Solidity
680      * uses an invalid opcode to revert (consuming all remaining gas).
681      *
682      * Requirements:
683      *
684      * - The divisor cannot be zero.
685      */
686     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
687         require(b > 0, errorMessage);
688         uint256 c = a / b;
689         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
690 
691         return c;
692     }
693 
694     /**
695      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
696      * Reverts when dividing by zero.
697      *
698      * Counterpart to Solidity's `%` operator. This function uses a `revert`
699      * opcode (which leaves remaining gas untouched) while Solidity uses an
700      * invalid opcode to revert (consuming all remaining gas).
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
707         return mod(a, b, "SafeMath: modulo by zero");
708     }
709 
710     /**
711      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
712      * Reverts with custom message when dividing by zero.
713      *
714      * Counterpart to Solidity's `%` operator. This function uses a `revert`
715      * opcode (which leaves remaining gas untouched) while Solidity uses an
716      * invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
723         require(b != 0, errorMessage);
724         return a % b;
725     }
726 }
727 
728 /**
729  * @dev Implementation of the {IERC20} interface.
730  *
731  * This implementation is agnostic to the way tokens are created. This means
732  * that a supply mechanism has to be added in a derived contract using {_mint}.
733  * For a generic mechanism see {ERC20PresetMinterPauser}.
734  *
735  * TIP: For a detailed writeup see our guide
736  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
737  * to implement supply mechanisms].
738  *
739  * We have followed general OpenZeppelin guidelines: functions revert instead
740  * of returning `false` on failure. This behavior is nonetheless conventional
741  * and does not conflict with the expectations of ERC20 applications.
742  *
743  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
744  * This allows applications to reconstruct the allowance for all accounts just
745  * by listening to said events. Other implementations of the EIP may not emit
746  * these events, as it isn't required by the specification.
747  *
748  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
749  * functions have been added to mitigate the well-known issues around setting
750  * allowances. See {IERC20-approve}.
751  */
752 contract ERC20 is Context, IERC20 {
753     using SafeMath for uint256;
754 
755     mapping (address => uint256) private _balances;
756 
757     mapping (address => mapping (address => uint256)) private _allowances;
758 
759     uint256 private _totalSupply;
760 
761     string internal _name;
762     string internal _symbol;
763     uint8 internal _decimals;
764 
765     /**
766      * @dev Returns the name of the token.
767      */
768     function name() public view returns (string memory) {
769         return _name;
770     }
771 
772     /**
773      * @dev Returns the symbol of the token, usually a shorter version of the
774      * name.
775      */
776     function symbol() public view returns (string memory) {
777         return _symbol;
778     }
779 
780     /**
781      * @dev Returns the number of decimals used to get its user representation.
782      * For example, if `decimals` equals `2`, a balance of `505` tokens should
783      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
784      *
785      * Tokens usually opt for a value of 18, imitating the relationship between
786      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
787      * called.
788      *
789      * NOTE: This information is only used for _display_ purposes: it in
790      * no way affects any of the arithmetic of the contract, including
791      * {IERC20-balanceOf} and {IERC20-transfer}.
792      */
793     function decimals() public view returns (uint8) {
794         return _decimals;
795     }
796 
797     /**
798      * @dev See {IERC20-totalSupply}.
799      */
800     function totalSupply() public view override returns (uint256) {
801         return _totalSupply;
802     }
803 
804     /**
805      * @dev See {IERC20-balanceOf}.
806      */
807     function balanceOf(address account) public view override returns (uint256) {
808         return _balances[account];
809     }
810 
811     /**
812      * @dev See {IERC20-transfer}.
813      *
814      * Requirements:
815      *
816      * - `recipient` cannot be the zero address.
817      * - the caller must have a balance of at least `amount`.
818      */
819     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
820         _transfer(_msgSender(), recipient, amount);
821         return true;
822     }
823 
824     /**
825      * @dev See {IERC20-allowance}.
826      */
827     function allowance(address owner, address spender) public view virtual override returns (uint256) {
828         return _allowances[owner][spender];
829     }
830 
831     /**
832      * @dev See {IERC20-approve}.
833      *
834      * Requirements:
835      *
836      * - `spender` cannot be the zero address.
837      */
838     function approve(address spender, uint256 amount) public virtual override returns (bool) {
839         _approve(_msgSender(), spender, amount);
840         return true;
841     }
842 
843     /**
844      * @dev See {IERC20-transferFrom}.
845      *
846      * Emits an {Approval} event indicating the updated allowance. This is not
847      * required by the EIP. See the note at the beginning of {ERC20}.
848      *
849      * Requirements:
850      *
851      * - `sender` and `recipient` cannot be the zero address.
852      * - `sender` must have a balance of at least `amount`.
853      * - the caller must have allowance for ``sender``'s tokens of at least
854      * `amount`.
855      */
856     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
857         _transfer(sender, recipient, amount);
858         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
859         return true;
860     }
861 
862     /**
863      * @dev Atomically increases the allowance granted to `spender` by the caller.
864      *
865      * This is an alternative to {approve} that can be used as a mitigation for
866      * problems described in {IERC20-approve}.
867      *
868      * Emits an {Approval} event indicating the updated allowance.
869      *
870      * Requirements:
871      *
872      * - `spender` cannot be the zero address.
873      */
874     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
875         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
876         return true;
877     }
878 
879     /**
880      * @dev Atomically decreases the allowance granted to `spender` by the caller.
881      *
882      * This is an alternative to {approve} that can be used as a mitigation for
883      * problems described in {IERC20-approve}.
884      *
885      * Emits an {Approval} event indicating the updated allowance.
886      *
887      * Requirements:
888      *
889      * - `spender` cannot be the zero address.
890      * - `spender` must have allowance for the caller of at least
891      * `subtractedValue`.
892      */
893     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
894         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
895         return true;
896     }
897 
898     /**
899      * @dev Moves tokens `amount` from `sender` to `recipient`.
900      *
901      * This is internal function is equivalent to {transfer}, and can be used to
902      * e.g. implement automatic token fees, slashing mechanisms, etc.
903      *
904      * Emits a {Transfer} event.
905      *
906      * Requirements:
907      *
908      * - `sender` cannot be the zero address.
909      * - `recipient` cannot be the zero address.
910      * - `sender` must have a balance of at least `amount`.
911      */
912     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
913         require(sender != address(0), "ERC20: transfer from the zero address");
914         require(recipient != address(0), "ERC20: transfer to the zero address");
915 
916         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
917         _balances[recipient] = _balances[recipient].add(amount);
918         emit Transfer(sender, recipient, amount);
919     }
920 
921     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
922      * the total supply.
923      *
924      * Emits a {Transfer} event with `from` set to the zero address.
925      *
926      * Requirements:
927      *
928      * - `to` cannot be the zero address.
929      */
930     function _mint(address account, uint256 amount) internal virtual {
931         require(account != address(0), "ERC20: mint to the zero address");
932 
933         _totalSupply = _totalSupply.add(amount);
934         _balances[account] = _balances[account].add(amount);
935         emit Transfer(address(0), account, amount);
936     }
937 
938     /**
939      * @dev Destroys `amount` tokens from `account`, reducing the
940      * total supply.
941      *
942      * Emits a {Transfer} event with `to` set to the zero address.
943      *
944      * Requirements:
945      *
946      * - `account` cannot be the zero address.
947      * - `account` must have at least `amount` tokens.
948      */
949     function _burn(address account, uint256 amount) internal virtual {
950         require(account != address(0), "ERC20: burn from the zero address");
951 
952         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
953         _totalSupply = _totalSupply.sub(amount);
954         emit Transfer(account, address(0), amount);
955     }
956 
957     /**
958      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
959      *
960      * This internal function is equivalent to `approve`, and can be used to
961      * e.g. set automatic allowances for certain subsystems, etc.
962      *
963      * Emits an {Approval} event.
964      *
965      * Requirements:
966      *
967      * - `owner` cannot be the zero address.
968      * - `spender` cannot be the zero address.
969      */
970     function _approve(address owner, address spender, uint256 amount) internal virtual {
971         require(owner != address(0), "ERC20: approve from the zero address");
972         require(spender != address(0), "ERC20: approve to the zero address");
973 
974         _allowances[owner][spender] = amount;
975         emit Approval(owner, spender, amount);
976     }
977 
978     /**
979      * @dev Sets {decimals} to a value other than the default one of 18.
980      *
981      * WARNING: This function should only be called from the constructor. Most
982      * applications that interact with token contracts will not expect
983      * {decimals} to ever change, and may work incorrectly if it does.
984      */
985     function _setupDecimals(uint8 decimals_) internal {
986         _decimals = decimals_;
987     }
988 }
989 
990 contract ANRXERC20 is ERC20, Ownable {
991 
992     constructor() public {
993         _name = "AnRKey X";
994         _symbol = "$ANRX";
995         _decimals = 18;
996         
997         _mint(msg.sender, 200000000000000000000000000);
998     }
999 
1000     function mint(address account, uint256 amount) external onlyOwner {
1001         _mint(account, amount);
1002     }
1003     
1004     function burn(uint256 amount) external {
1005         _burn(msg.sender, amount);
1006     }
1007 
1008 }