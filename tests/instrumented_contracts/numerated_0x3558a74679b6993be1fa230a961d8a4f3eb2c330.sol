1 pragma solidity 0.7.1;
2 
3 contract Context {
4     function _msgSender() internal view returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 pragma solidity 0.7.1;
15 
16 /**
17  * @dev Contract module which provides a basic access control mechanism, where
18  * there is an account (an owner) that can be granted exclusive access to
19  * specific functions.
20  *
21  * By default, the owner account will be the one that deploys the contract. This
22  * can later be changed with {transferOwnership}.
23  *
24  * This module is used through inheritance. It will make available the modifier
25  * `onlyOwner`, which can be applied to your functions to restrict their use to
26  * the owner.
27  */
28 abstract contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Initializes the contract setting the deployer as the initial owner.
35      */
36     constructor () {
37         address msgSender = _msgSender();
38         _owner = msgSender;
39         emit OwnershipTransferred(address(0), msgSender);
40     }
41 
42     /**
43      * @dev Returns the address of the current owner.
44      */
45     function owner() public view returns (address) {
46         return _owner;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     /**
58      * @dev Leaves the contract without owner. It will not be possible to call
59      * `onlyOwner` functions anymore. Can only be called by the current owner.
60      *
61      * NOTE: Renouncing ownership will leave the contract without an owner,
62      * thereby removing any functionality that is only available to the owner.
63      */
64     function renounceOwnership() public onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Can only be called by the current owner.
72      */
73     function transferOwnership(address newOwner) public onlyOwner {
74         require(newOwner != address(0), "Ownable: new owner is the zero address");
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 pragma solidity 0.7.1;
81 
82 /**
83  * @dev Library for managing
84  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
85  * types.
86  *
87  * Sets have the following properties:
88  *
89  * - Elements are added, removed, and checked for existence in constant time
90  * (O(1)).
91  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
92  *
93  * ```
94  * contract Example {
95  *     // Add the library methods
96  *     using EnumerableSet for EnumerableSet.AddressSet;
97  *
98  *     // Declare a set state variable
99  *     EnumerableSet.AddressSet private mySet;
100  * }
101  * ```
102  *
103  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
104  * (`UintSet`) are supported.
105  */
106 library EnumerableSet {
107     // To implement this library for multiple types with as little code
108     // repetition as possible, we write it in terms of a generic Set type with
109     // bytes32 values.
110     // The Set implementation uses private functions, and user-facing
111     // implementations (such as AddressSet) are just wrappers around the
112     // underlying Set.
113     // This means that we can only create new EnumerableSets for types that fit
114     // in bytes32.
115 
116     struct Set {
117         // Storage of set values
118         bytes32[] _values;
119 
120         // Position of the value in the `values` array, plus 1 because index 0
121         // means a value is not in the set.
122         mapping (bytes32 => uint256) _indexes;
123     }
124 
125     /**
126      * @dev Add a value to a set. O(1).
127      *
128      * Returns true if the value was added to the set, that is if it was not
129      * already present.
130      */
131     function _add(Set storage set, bytes32 value) private returns (bool) {
132         if (!_contains(set, value)) {
133             set._values.push(value);
134             // The value is stored at length-1, but we add 1 to all indexes
135             // and use 0 as a sentinel value
136             set._indexes[value] = set._values.length;
137             return true;
138         } else {
139             return false;
140         }
141     }
142 
143     /**
144      * @dev Removes a value from a set. O(1).
145      *
146      * Returns true if the value was removed from the set, that is if it was
147      * present.
148      */
149     function _remove(Set storage set, bytes32 value) private returns (bool) {
150         // We read and store the value's index to prevent multiple reads from the same storage slot
151         uint256 valueIndex = set._indexes[value];
152 
153         if (valueIndex != 0) { // Equivalent to contains(set, value)
154             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
155             // the array, and then remove the last element (sometimes called as 'swap and pop').
156             // This modifies the order of the array, as noted in {at}.
157 
158             uint256 toDeleteIndex = valueIndex - 1;
159             uint256 lastIndex = set._values.length - 1;
160 
161             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
162             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
163 
164             bytes32 lastvalue = set._values[lastIndex];
165 
166             // Move the last value to the index where the value to delete is
167             set._values[toDeleteIndex] = lastvalue;
168             // Update the index for the moved value
169             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
170 
171             // Delete the slot where the moved value was stored
172             set._values.pop();
173 
174             // Delete the index for the deleted slot
175             delete set._indexes[value];
176 
177             return true;
178         } else {
179             return false;
180         }
181     }
182 
183     /**
184      * @dev Returns true if the value is in the set. O(1).
185      */
186     function _contains(Set storage set, bytes32 value) private view returns (bool) {
187         return set._indexes[value] != 0;
188     }
189 
190     /**
191      * @dev Returns the number of values on the set. O(1).
192      */
193     function _length(Set storage set) private view returns (uint256) {
194         return set._values.length;
195     }
196 
197    /**
198     * @dev Returns the value stored at position `index` in the set. O(1).
199     *
200     * Note that there are no guarantees on the ordering of values inside the
201     * array, and it may change when more values are added or removed.
202     *
203     * Requirements:
204     *
205     * - `index` must be strictly less than {length}.
206     */
207     function _at(Set storage set, uint256 index) private view returns (bytes32) {
208         require(set._values.length > index, "EnumerableSet: index out of bounds");
209         return set._values[index];
210     }
211 
212     // AddressSet
213 
214     struct AddressSet {
215         Set _inner;
216     }
217 
218     /**
219      * @dev Add a value to a set. O(1).
220      *
221      * Returns true if the value was added to the set, that is if it was not
222      * already present.
223      */
224     function add(AddressSet storage set, address value) internal returns (bool) {
225         return _add(set._inner, bytes32(uint256(value)));
226     }
227 
228     /**
229      * @dev Removes a value from a set. O(1).
230      *
231      * Returns true if the value was removed from the set, that is if it was
232      * present.
233      */
234     function remove(AddressSet storage set, address value) internal returns (bool) {
235         return _remove(set._inner, bytes32(uint256(value)));
236     }
237 
238     /**
239      * @dev Returns true if the value is in the set. O(1).
240      */
241     function contains(AddressSet storage set, address value) internal view returns (bool) {
242         return _contains(set._inner, bytes32(uint256(value)));
243     }
244 
245     /**
246      * @dev Returns the number of values in the set. O(1).
247      */
248     function length(AddressSet storage set) internal view returns (uint256) {
249         return _length(set._inner);
250     }
251 
252    /**
253     * @dev Returns the value stored at position `index` in the set. O(1).
254     *
255     * Note that there are no guarantees on the ordering of values inside the
256     * array, and it may change when more values are added or removed.
257     *
258     * Requirements:
259     *
260     * - `index` must be strictly less than {length}.
261     */
262     function at(AddressSet storage set, uint256 index) internal view returns (address) {
263         return address(uint256(_at(set._inner, index)));
264     }
265 
266 
267     // UintSet
268 
269     struct UintSet {
270         Set _inner;
271     }
272 
273     /**
274      * @dev Add a value to a set. O(1).
275      *
276      * Returns true if the value was added to the set, that is if it was not
277      * already present.
278      */
279     function add(UintSet storage set, uint256 value) internal returns (bool) {
280         return _add(set._inner, bytes32(value));
281     }
282 
283     /**
284      * @dev Removes a value from a set. O(1).
285      *
286      * Returns true if the value was removed from the set, that is if it was
287      * present.
288      */
289     function remove(UintSet storage set, uint256 value) internal returns (bool) {
290         return _remove(set._inner, bytes32(value));
291     }
292 
293     /**
294      * @dev Returns true if the value is in the set. O(1).
295      */
296     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
297         return _contains(set._inner, bytes32(value));
298     }
299 
300     /**
301      * @dev Returns the number of values on the set. O(1).
302      */
303     function length(UintSet storage set) internal view returns (uint256) {
304         return _length(set._inner);
305     }
306 
307    /**
308     * @dev Returns the value stored at position `index` in the set. O(1).
309     *
310     * Note that there are no guarantees on the ordering of values inside the
311     * array, and it may change when more values are added or removed.
312     *
313     * Requirements:
314     *
315     * - `index` must be strictly less than {length}.
316     */
317     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
318         return uint256(_at(set._inner, index));
319     }
320 }
321 pragma solidity 0.7.1;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327 
328     modifier onlyPayloadSize(uint256 size) {
329      assert(msg.data.length == size + 4);
330      _;
331    }
332     /**
333      * @dev Returns true if `account` is a contract.
334      *
335      * [IMPORTANT]
336      * ====
337      * It is unsafe to assume that an address for which this function returns
338      * false is an externally-owned account (EOA) and not a contract.
339      *
340      * Among others, `isContract` will return false for the following
341      * types of addresses:
342      *
343      *  - an externally-owned account
344      *  - a contract in construction
345      *  - an address where a contract will be created
346      *  - an address where a contract lived, but was destroyed
347      * ====
348      */
349     function isContract(address account) internal view returns (bool) {
350         // This method relies in extcodesize, which returns 0 for contracts in
351         // construction, since the code is only stored at the end of the
352         // constructor execution.
353 
354         uint256 size;
355         // solhint-disable-next-line no-inline-assembly
356         assembly { size := extcodesize(account) }
357         return size > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(address(this).balance >= amount, "Address: insufficient balance");
378 
379         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
380         (bool success, ) = recipient.call{ value: amount }("");
381         require(success, "Address: unable to send value, recipient may have reverted");
382     }
383 
384     /**
385      * @dev Performs a Solidity function call using a low level `call`. A
386      * plain`call` is an unsafe replacement for a function call: use this
387      * function instead.
388      *
389      * If `target` reverts with a revert reason, it is bubbled up by this
390      * function (like regular Solidity function calls).
391      *
392      * Returns the raw returned data. To convert to the expected return value,
393      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
394      *
395      * Requirements:
396      *
397      * - `target` must be a contract.
398      * - calling `target` with `data` must not revert.
399      *
400      * _Available since v3.1._
401      */
402     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
403       return functionCall(target, data, "Address: low-level call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
408      * `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
413         return _functionCallWithValue(target, data, 0, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but also transferring `value` wei to `target`.
419      *
420      * Requirements:
421      *
422      * - the calling contract must have an ETH balance of at least `value`.
423      * - the called Solidity function must be `payable`.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
433      * with `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         return _functionCallWithValue(target, data, value, errorMessage);
440     }
441 
442     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
443         require(isContract(target), "Address: call to non-contract");
444 
445         // solhint-disable-next-line avoid-low-level-calls
446         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 // solhint-disable-next-line no-inline-assembly
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 pragma solidity 0.7.1;
466 
467 /**
468  * @dev Wrappers over Solidity's arithmetic operations with added overflow
469  * checks.
470  *
471  * Arithmetic operations in Solidity wrap on overflow. This can easily result
472  * in bugs, because programmers usually assume that an overflow raises an
473  * error, which is the standard behavior in high level programming languages.
474  * `SafeMath` restores this intuition by reverting the transaction when an
475  * operation overflows.
476  *
477  * Using this library instead of the unchecked operations eliminates an entire
478  * class of bugs, so it's recommended to use it always.
479  */
480 library SafeMath {
481     /**
482      * @dev Returns the addition of two unsigned integers, reverting on
483      * overflow.
484      *
485      * Counterpart to Solidity's `+` operator.
486      *
487      * Requirements:
488      * - Addition cannot overflow.
489      */
490     function add(uint256 a, uint256 b) internal pure returns (uint256) {
491         uint256 c = a + b;
492         require(c >= a, "SafeMath: addition overflow");
493 
494         return c;
495     }
496 
497     /**
498      * @dev Returns the subtraction of two unsigned integers, reverting on
499      * overflow (when the result is negative).
500      *
501      * Counterpart to Solidity's `-` operator.
502      *
503      * Requirements:
504      * - Subtraction cannot overflow.
505      */
506     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
507         return sub(a, b, "SafeMath: subtraction overflow");
508     }
509 
510     /**
511      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
512      * overflow (when the result is negative).
513      *
514      * Counterpart to Solidity's `-` operator.
515      *
516      * Requirements:
517      * - Subtraction cannot overflow.
518      */
519     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
520         require(b <= a, errorMessage);
521         uint256 c = a - b;
522 
523         return c;
524     }
525 
526     /**
527      * @dev Returns the multiplication of two unsigned integers, reverting on
528      * overflow.
529      *
530      * Counterpart to Solidity's `*` operator.
531      *
532      * Requirements:
533      * - Multiplication cannot overflow.
534      */
535     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
537         // benefit is lost if 'b' is also tested.
538         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
539         if (a == 0) {
540             return 0;
541         }
542 
543         uint256 c = a * b;
544         require(c / a == b, "SafeMath: multiplication overflow");
545 
546         return c;
547     }
548 
549     /**
550      * @dev Returns the integer division of two unsigned integers. Reverts on
551      * division by zero. The result is rounded towards zero.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      * - The divisor cannot be zero.
559      */
560     function div(uint256 a, uint256 b) internal pure returns (uint256) {
561         return div(a, b, "SafeMath: division by zero");
562     }
563 
564     /**
565      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
566      * division by zero. The result is rounded towards zero.
567      *
568      * Counterpart to Solidity's `/` operator. Note: this function uses a
569      * `revert` opcode (which leaves remaining gas untouched) while Solidity
570      * uses an invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      * - The divisor cannot be zero.
574      */
575     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
576         require(b > 0, errorMessage);
577         uint256 c = a / b;
578         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
579 
580         return c;
581     }
582 
583 }
584 
585 pragma solidity 0.7.1;
586 /**
587  * @dev Interface of the ERC20 standard as defined in the EIP.
588  */
589 interface IERC20 {
590     /**
591      * @dev Returns the amount of tokens in existence.
592      */
593     function totalSupply() external view returns (uint256);
594 
595     /**
596      * @dev Returns the amount of tokens owned by `account`.
597      */
598     function balanceOf(address account) external view returns (uint256);
599 
600     /**
601      * @dev Moves `amount` tokens from the caller's account to `recipient`.
602      *
603      * Returns a boolean value indicating whether the operation succeeded.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transfer(address recipient, uint256 amount) external returns (bool);
608 
609     /**
610      * @dev Returns the remaining number of tokens that `spender` will be
611      * allowed to spend on behalf of `owner` through {transferFrom}. This is
612      * zero by default.
613      *
614      * This value changes when {approve} or {transferFrom} are called.
615      */
616     function allowance(address owner, address spender) external view returns (uint256);
617 
618     /**
619      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
620      *
621      * Returns a boolean value indicating whether the operation succeeded.
622      *
623      * IMPORTANT: Beware that changing an allowance with this method brings the risk
624      * that someone may use both the old and the new allowance by unfortunate
625      * transaction ordering. One possible solution to mitigate this race
626      * condition is to first reduce the spender's allowance to 0 and set the
627      * desired value afterwards:
628      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
629      *
630      * Emits an {Approval} event.
631      */
632     function approve(address spender, uint256 amount) external returns (bool);
633 
634     /**
635      * @dev Moves `amount` tokens from `sender` to `recipient` using the
636      * allowance mechanism. `amount` is then deducted from the caller's
637      * allowance.
638      *
639      * Returns a boolean value indicating whether the operation succeeded.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
644 
645     /**
646      * @dev Emitted when `value` tokens are moved from one account (`from`) to
647      * another (`to`).
648      *
649      * Note that `value` may be zero.
650      */
651     event Transfer(address indexed from, address indexed to, uint256 value);
652 
653     /**
654      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
655      * a call to {approve}. `value` is the new allowance.
656      */
657     event Approval(address indexed owner, address indexed spender, uint256 value);
658 }
659 
660 pragma solidity 0.7.1;
661 
662 /**
663  * @title SafeERC20
664  * @dev Wrappers around ERC20 operations that throw on failure (when the token
665  * contract returns false). Tokens that return no value (and instead revert or
666  * throw on failure) are also supported, non-reverting calls are assumed to be
667  * successful.
668  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
669  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
670  */
671 library SafeERC20 {
672     using SafeMath for uint256;
673     using Address for address;
674 
675     modifier onlyPayloadSize(uint256 size) {
676      assert(msg.data.length == size + 4);
677      _;
678    }
679 
680     function safeTransfer(IERC20 token, address to, uint256 value) internal {
681         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
682     }
683 
684     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
685         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
686     }
687 
688     /**
689      * @dev Deprecated. This function has issues similar to the ones found in
690      * {IERC20-approve}, and its usage is discouraged.
691      *
692      * Whenever possible, use {safeIncreaseAllowance} and
693      * {safeDecreaseAllowance} instead.
694      */
695     function safeApprove(IERC20 token, address spender, uint256 value) internal {
696         // safeApprove should only be called when setting an initial allowance,
697         // or when resetting it to zero. To increase and decrease it, use
698         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
699         // solhint-disable-next-line max-line-length
700         require((value == 0) || (token.allowance(address(this), spender) == 0),
701             "SafeERC20: approve from non-zero to non-zero allowance"
702         );
703         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
704     }
705 
706     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
707         uint256 newAllowance = token.allowance(address(this), spender).add(value);
708         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
709     }
710 
711     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
712         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
713         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
714     }
715 
716     /**
717      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
718      * on the return value: the return value is optional (but if data is returned, it must not be false).
719      * @param token The token targeted by the call.
720      * @param data The call data (encoded using abi.encode or one of its variants).
721      */
722     function _callOptionalReturn(IERC20 token, bytes memory data) private {
723         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
724         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
725         // the target address contains contract code and also asserts for success in the low-level call.
726 
727         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
728         if (returndata.length > 0) { // Return data is optional
729             // solhint-disable-next-line max-line-length
730             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
731         }
732     }
733 }
734 
735 pragma solidity 0.7.1;
736 
737 /**
738  * @dev Implementation of the {IERC20} interface.
739  *
740  * This implementation is agnostic to the way tokens are created. This means
741  * that a supply mechanism has to be added in a derived contract using {_mint}.
742  * For a generic mechanism see {ERC20PresetMinterPauser}.
743  *
744  * TIP: For a detailed writeup see our guide
745  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
746  * to implement supply mechanisms].
747  *
748  * We have followed general OpenZeppelin guidelines: functions revert instead
749  * of returning `false` on failure. This behavior is nonetheless conventional
750  * and does not conflict with the expectations of ERC20 applications.
751  *
752  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
753  * This allows applications to reconstruct the allowance for all accounts just
754  * by listening to said events. Other implementations of the EIP may not emit
755  * these events, as it isn't required by the specification.
756  *
757  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
758  * functions have been added to mitigate the well-known issues around setting
759  * allowances. See {IERC20-approve}.
760  */
761 contract ERC20 is Context, IERC20 {
762     using SafeMath for uint256;
763     using Address for address;
764 
765     mapping (address => uint256) private _balances;
766 
767     mapping (address => mapping (address => uint256)) internal _allowances;
768 
769     uint256 private _totalSupply;
770 
771     string private _name;
772     string private _symbol;
773     uint8 private _decimals;
774     address public addr;
775 
776     /**
777      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
778      * a default value of 18.
779      *
780      * To select a different value for {decimals}, use {_setupDecimals}.
781      *
782      * All three of these values are immutable: they can only be set once during
783      * construction.
784      */
785     constructor (string memory name, string memory symbol) public {
786         _name = name;
787         _symbol = symbol;
788         _decimals = 18;
789     }
790 
791     /**
792      * @dev Returns the name of the token.
793      */
794     function name() public view returns (string memory) {
795         return _name;
796     }
797 
798     /**
799      * @dev Returns the symbol of the token, usually a shorter version of the
800      * name.
801      */
802     function symbol() public view returns (string memory) {
803         return _symbol;
804     }
805 
806     /**
807      * @dev Returns the number of decimals used to get its user representation.
808      * For example, if `decimals` equals `2`, a balance of `505` tokens should
809      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
810      *
811      * Tokens usually opt for a value of 18, imitating the relationship between
812      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
813      * called.
814      *
815      * NOTE: This information is only used for _display_ purposes: it in
816      * no way affects any of the arithmetic of the contract, including
817      * {IERC20-balanceOf} and {IERC20-transfer}.
818      */
819     function decimals() public view returns (uint8) {
820         return _decimals;
821     }
822 
823     /**
824      * @dev See {IERC20-totalSupply}.
825      */
826     function totalSupply() public view override returns (uint256) {
827         return _totalSupply;
828     }
829 
830     /**
831      * @dev See {IERC20-balanceOf}.
832      */
833     function balanceOf(address account) public view override returns (uint256) {
834         return _balances[account];
835     }
836 
837 
838     /**
839      * @dev See {IERC20-allowance}.
840      */
841     function allowance(address owner, address spender) public view virtual override returns (uint256) {
842         return _allowances[owner][spender];
843     }
844 
845     /**
846      * @dev See {IERC20-approve}.
847      *
848      * Requirements:
849      *
850      * - `spender` cannot be the zero address.
851      */
852     function approve(address spender, uint256 amount) public virtual override returns (bool) {
853         _approve(_msgSender(), spender, amount);
854         return true;
855     }
856     
857     // override the functions and make it virtual to be overridden by child contract
858      function transfer(address recipient, uint256 amount) external override virtual returns (bool) { }
859      function transferFrom(address sender, address recipient, uint256 amount) external override virtual returns (bool) { }
860    
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
916         _beforeTokenTransfer(sender, recipient, amount);
917         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
918         _balances[recipient] = _balances[recipient].add(amount);
919         emit Transfer(sender, recipient, amount);
920     }
921 
922     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
923      * the total supply.
924      *
925      * Emits a {Transfer} event with `from` set to the zero address.
926      *
927      * Requirements
928      *
929      * - `to` cannot be the zero address.
930      */
931     function _mint(address account, uint256 amount) internal virtual {
932         require(account != address(0), "ERC20: mint to the zero address");
933 
934         _beforeTokenTransfer(address(0), account, amount);
935 
936         _totalSupply = _totalSupply.add(amount);
937         _balances[account] = _balances[account].add(amount);
938         emit Transfer(address(0), account, amount);
939     }
940 
941     /**
942      * @dev Destroys `amount` tokens from `account`, reducing the
943      * total supply.
944      *
945      * Emits a {Transfer} event with `to` set to the zero address.
946      *
947      * Requirements
948      *
949      * - `account` cannot be the zero address.
950      * - `account` must have at least `amount` tokens.
951      */
952     function _burn(address account, uint256 amount) internal virtual {
953         require(account != address(0), "ERC20: burn from the zero address");
954 
955         _beforeTokenTransfer(account, address(0), amount);
956 
957         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
958         _totalSupply = _totalSupply.sub(amount);
959         emit Transfer(account, address(0), amount);
960     }
961 
962     /**
963      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
964      *
965      * This is internal function is equivalent to `approve`, and can be used to
966      * e.g. set automatic allowances for certain subsystems, etc.
967      *
968      * Emits an {Approval} event.
969      *
970      * Requirements:
971      *
972      * - `owner` cannot be the zero address.
973      * - `spender` cannot be the zero address.
974      */
975     function _approve(address owner, address spender, uint256 amount) internal virtual {
976         require(owner != address(0), "ERC20: approve from the zero address");
977         require(spender != address(0), "ERC20: approve to the zero address");
978 
979         _allowances[owner][spender] = amount;
980         emit Approval(owner, spender, amount);
981     }
982 
983     /**
984      * @dev Sets {decimals} to a value other than the default one of 18.
985      *
986      * WARNING: This function should only be called from the constructor. Most
987      * applications that interact with token contracts will not expect
988      * {decimals} to ever change, and may work incorrectly if it does.
989      */
990     function _setupDecimals(uint8 decimals_) internal {
991         _decimals = decimals_;
992     }
993 
994     /**
995      * @dev Hook that is called before any transfer of tokens. This includes
996      * minting and burning.
997      *
998      * Calling conditions:
999      *
1000      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1001      * will be to transferred to `to`.
1002      * - when `from` is zero, `amount` tokens will be minted for `to`.
1003      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1004      * - `from` and `to` are never both zero.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1009 }
1010 
1011 pragma solidity 0.7.1;
1012 
1013 // ZOM with Governance.
1014 contract ZOMHealth is ERC20("zom.health", "ZOM"), Ownable {
1015 
1016     using SafeMath for uint256;
1017 
1018     // Copied and modified from YAM code:
1019     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1020     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1021     // Which is copied and modified from COMPOUND:
1022     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1023 
1024     mapping (address => address) internal _delegates;
1025 
1026     /// @notice A checkpoint for marking number of votes from a given block
1027     struct Checkpoint {
1028         uint32 fromBlock;
1029         uint256 votes;
1030     }
1031     
1032     uint256 private _premint = 13900000000000000000000000;
1033 
1034     /// @notice A record of votes checkpoints for each account, by index
1035     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1036 
1037     /// @notice The number of checkpoints for each account
1038     mapping (address => uint32) public numCheckpoints;
1039 
1040     /// @notice The EIP-712 typehash for the contract's domain
1041     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1042 
1043     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1044     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1045 
1046     /// @notice A record of states for signing / validating signatures
1047     mapping (address => uint) public nonces;
1048     
1049       /// @notice An event thats emitted when an account changes its delegate
1050     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1051 
1052     /// @notice An event thats emitted when a delegate account's vote balance changes
1053     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1054     
1055    constructor () public {
1056         mint(_msgSender(), _premint);
1057     }
1058 
1059    modifier onlyPayloadSize(uint256 size) {
1060      assert(msg.data.length == size + 4);
1061      _;
1062    }
1063 
1064     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (ZOM_Obsidian stake contract).
1065     function mint(address _to, uint256 _amount) public onlyOwner {
1066         _mint(_to, _amount);
1067         _moveDelegates(address(0), _delegates[_to], _amount);
1068     }
1069     
1070     /**
1071      * @dev See {IERC20-transfer}.
1072      *
1073      * Requirements:
1074      *
1075      * - `recipient` cannot be the zero address.
1076      * - the caller must have a balance of at least `amount`.
1077      * - burn 5% and send rest
1078      */
1079     
1080      function transfer(address recipient, uint256 amount) public override onlyPayloadSize(2 * 32) returns (bool) {
1081         // reduce 5% from the amount 
1082         uint256 amounttoburn = _getamount(amount);
1083         // send rest amount to receiver
1084         uint256 amounttosend = amount.sub(amounttoburn);
1085         
1086         // burn 5% 
1087         _burn(_msgSender(), amounttoburn);
1088         _moveDelegates(_delegates[_msgSender()], address(0), amounttoburn);
1089         
1090         // transfer the rest amount
1091        _transfer(_msgSender(), recipient, amounttosend);
1092         return true;
1093      }
1094      
1095       /**
1096      * @dev See {IERC20-transferFrom}.
1097      *
1098      * Emits an {Approval} event indicating the updated allowance. This is not
1099      * required by the EIP. See the note at the beginning of {ERC20};
1100      *
1101      * Requirements:
1102      * - `sender` and `recipient` cannot be the zero address.
1103      * - `sender` must have a balance of at least `amount`.
1104      * - the caller must have allowance for ``sender``'s tokens of at least
1105      * `amount`.
1106      * - burn 5% and send rest
1107      */
1108     function transferFrom(address sender, address recipient, uint256 amount) public override onlyPayloadSize(3 * 32) returns (bool) {
1109         // reduce 5% from the amount 
1110         uint256 amounttoburn = _getamount(amount);
1111         // send rest amount to receiver
1112         uint256 amounttosend = amount.sub(amounttoburn);
1113         
1114         // burn 5% 
1115         _burn(sender, amounttoburn);
1116         _moveDelegates(_delegates[sender], address(0), amounttoburn);
1117         
1118         // transfer the amount
1119         _transfer(sender, recipient, amounttosend);
1120         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1121         return true;
1122     }
1123     
1124     // get 5% of the amount
1125     function _getamount(uint256 amount) pure private returns (uint256) {
1126         uint256 amountafter = amount.mul(5).div(100);
1127         amountafter = amountafter > 0 ? amountafter : 1;
1128         return amountafter;
1129     }
1130 
1131     /// @notice Burn `_amount` token to `_from`. 
1132     function burn(address _from, uint256 _amount) public onlyOwner {
1133          _burn(_from, _amount);
1134         _moveDelegates(_delegates[_from], address(0), _amount);
1135     }
1136 
1137     /**
1138      * @notice Delegate votes from `msg.sender` to `delegatee`
1139      * @param delegator The address to get delegatee for
1140      */
1141     function delegates(address delegator)
1142         external
1143         view
1144         returns (address)
1145     {
1146         return _delegates[delegator];
1147     }
1148 
1149    /**
1150     * @notice Delegate votes from `msg.sender` to `delegatee`
1151     * @param delegatee The address to delegate votes to
1152     */
1153     function delegate(address delegatee) external {
1154         return _delegate(msg.sender, delegatee);
1155     }
1156 
1157     /**
1158      * @notice Delegates votes from signatory to `delegatee`
1159      * @param delegatee The address to delegate votes to
1160      * @param nonce The contract state required to match the signature
1161      * @param expiry The time at which to expire the signature
1162      * @param v The recovery byte of the signature
1163      * @param r Half of the ECDSA signature pair
1164      * @param s Half of the ECDSA signature pair
1165      */
1166     function delegateBySig(
1167         address delegatee,
1168         uint nonce,
1169         uint expiry,
1170         uint8 v,
1171         bytes32 r,
1172         bytes32 s
1173     )
1174         external
1175     {
1176         bytes32 domainSeparator = keccak256(
1177             abi.encode(
1178                 DOMAIN_TYPEHASH,
1179                 keccak256(bytes(name())),
1180                 getChainId(),
1181                 address(this)
1182             )
1183         );
1184 
1185         bytes32 structHash = keccak256(
1186             abi.encode(
1187                 DELEGATION_TYPEHASH,
1188                 delegatee,
1189                 nonce,
1190                 expiry
1191             )
1192         );
1193 
1194         bytes32 digest = keccak256(
1195             abi.encodePacked(
1196                 "\x19\x01",
1197                 domainSeparator,
1198                 structHash
1199             )
1200         );
1201 
1202         address signatory = ecrecover(digest, v, r, s);
1203         require(signatory != address(0), "ZOM::delegateBySig: invalid signature");
1204         require(nonce == nonces[signatory]++, "ZOM::delegateBySig: invalid nonce");
1205         require(block.timestamp <= expiry, "ZOM::delegateBySig: signature expired");
1206         return _delegate(signatory, delegatee);
1207     }
1208 
1209     /**
1210      * @notice Gets the current votes balance for `account`
1211      * @param account The address to get votes balance
1212      * @return The number of current votes for `account`
1213      */
1214     function getCurrentVotes(address account)
1215         external
1216         view
1217         returns (uint256)
1218     {
1219         uint32 nCheckpoints = numCheckpoints[account];
1220         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1221     }
1222 
1223     /**
1224      * @notice Determine the prior number of votes for an account as of a block number
1225      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1226      * @param account The address of the account to check
1227      * @param blockNumber The block number to get the vote balance at
1228      * @return The number of votes the account had as of the given block
1229      */
1230     function getPriorVotes(address account, uint blockNumber)
1231         external
1232         view
1233         returns (uint256)
1234     {
1235         require(blockNumber < block.number, "ZOM::getPriorVotes: not yet determined");
1236 
1237         uint32 nCheckpoints = numCheckpoints[account];
1238         if (nCheckpoints == 0) {
1239             return 0;
1240         }
1241 
1242         // First check most recent balance
1243         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1244             return checkpoints[account][nCheckpoints - 1].votes;
1245         }
1246 
1247         // Next check implicit zero balance
1248         if (checkpoints[account][0].fromBlock > blockNumber) {
1249             return 0;
1250         }
1251 
1252         uint32 lower = 0;
1253         uint32 upper = nCheckpoints - 1;
1254         while (upper > lower) {
1255             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1256             Checkpoint memory cp = checkpoints[account][center];
1257             if (cp.fromBlock == blockNumber) {
1258                 return cp.votes;
1259             } else if (cp.fromBlock < blockNumber) {
1260                 lower = center;
1261             } else {
1262                 upper = center - 1;
1263             }
1264         }
1265         return checkpoints[account][lower].votes;
1266     }
1267 
1268     function _delegate(address delegator, address delegatee)
1269         internal
1270     {
1271         address currentDelegate = _delegates[delegator];
1272         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ZOMs (not scaled);
1273         _delegates[delegator] = delegatee;
1274 
1275         emit DelegateChanged(delegator, currentDelegate, delegatee);
1276 
1277         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1278     }
1279 
1280     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1281         if (srcRep != dstRep && amount > 0) {
1282             if (srcRep != address(0)) {
1283                 // decrease old representative
1284                 uint32 srcRepNum = numCheckpoints[srcRep];
1285                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1286                 uint256 srcRepNew = srcRepOld.sub(amount);
1287                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1288             }
1289 
1290             if (dstRep != address(0)) {
1291                 // increase new representative
1292                 uint32 dstRepNum = numCheckpoints[dstRep];
1293                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1294                 uint256 dstRepNew = dstRepOld.add(amount);
1295                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1296             }
1297         }
1298     }
1299 
1300     function _writeCheckpoint(
1301         address delegatee,
1302         uint32 nCheckpoints,
1303         uint256 oldVotes,
1304         uint256 newVotes
1305     )
1306         internal
1307     {
1308         uint32 blockNumber = safe32(block.number, "ZOM::_writeCheckpoint: block number exceeds 32 bits");
1309 
1310         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1311             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1312         } else {
1313             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1314             numCheckpoints[delegatee] = nCheckpoints + 1;
1315         }
1316 
1317         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1318     }
1319 
1320     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1321         require(n < 2**32, errorMessage);
1322         return uint32(n);
1323     }
1324 
1325     function getChainId() internal pure returns (uint) {
1326         uint256 chainId;
1327         assembly { chainId := chainid() }
1328         return chainId;
1329     }
1330 }
1331 
1332 pragma solidity 0.7.1;
1333 
1334 interface IMigratorObsidian {
1335     // Perform LP token migration from legacy UniswapV2 to zomhealth.
1336     // Take the current LP token address and return the new LP token address.
1337     // Migrator should have full access to the caller's LP token.
1338     // Return the new LP token address.
1339     //
1340     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1341     // zomhealth must mint EXACTLY the same amount of zomhealth LP tokens or
1342     // else something bad will happen. Traditional UniswapV2 does not
1343     // do that so be careful!
1344     function migrate(IERC20 token) external returns (IERC20);
1345 }
1346 
1347 // ZOM_Obsidian is the master of Zom. He can make Zom and he is a fair guy.
1348 //
1349 // Note that it's ownable and the owner wields tremendous power. The ownership
1350 // will be transferred to a governance smart contract once ZOM is sufficiently
1351 // distributed and the community can show to govern itself.
1352 //
1353 // Have fun reading it. Hopefully it's bug-free. God bless.
1354 contract ZOM_Obsidian is Ownable {
1355     using SafeMath for uint256;
1356     using SafeERC20 for IERC20;
1357 
1358     // Info of each user.
1359     struct UserInfo {
1360         uint256 amount;     // How many LP tokens the user has provided.
1361         uint256 rewardDebt; // Reward debt. See explanation below.
1362         //
1363         // We do some fancy math here. Basically, any point in time, the amount of ZOMs
1364         // entitled to a user but is pending to be distributed is:
1365         //
1366         //   pending reward = (user.amount * pool.accZomPerShare) - user.rewardDebt
1367         //
1368         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1369         //   1. The pool's `accZomPerShare` (and `lastRewardBlock`) gets updated.
1370         //   2. User receives the pending reward sent to his/her address.
1371         //   3. User's `amount` gets updated.
1372         //   4. User's `rewardDebt` gets updated.
1373     }
1374 
1375     // Info of each pool.
1376     struct PoolInfo {
1377         IERC20 lpToken;           // Address of LP token contract.
1378         uint256 allocPoint;       // How many allocation points assigned to this pool. ZOMs to distribute per block.
1379         uint256 lastRewardBlock;  // Last block number that ZOMs distribution occurs.
1380         uint256 accZomPerShare; // Accumulated ZOMs per share, times 1e12. See below.
1381     }
1382 
1383     // The ZOM TOKEN!
1384     ZOMHealth public zom;
1385     // Dev address.
1386     address public devaddr;
1387     // Block number when bonus ZOM period ends.
1388     uint256 public bonusEndBlock;
1389     // ZOM tokens created per block.
1390     uint256 public zomPerBlock;
1391     // Bonus muliplier for early zom makers.
1392     uint256 public constant BONUS_MULTIPLIER = 5;
1393     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1394     IMigratorObsidian public migrator;
1395 
1396     // Info of each pool.
1397     PoolInfo[] public poolInfo;
1398     // Info of each user that stakes LP tokens.
1399     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1400     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1401     uint256 public totalAllocPoint = 0;
1402     // The block number when ZOM mining starts.
1403     uint256 public startBlock;
1404 
1405     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1406     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1407     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1408 
1409     constructor(
1410         ZOMHealth _zom,
1411         address _devaddr,
1412         uint256 _zomPerBlock,
1413         uint256 _startBlock,
1414         uint256 _bonusEndBlock
1415     ) public {
1416         zom = _zom;
1417         devaddr = _devaddr;
1418         zomPerBlock = _zomPerBlock;
1419         bonusEndBlock = _bonusEndBlock;
1420         startBlock = _startBlock;
1421     }
1422 
1423     function poolLength() external view returns (uint256) {
1424         return poolInfo.length;
1425     }
1426 
1427     // Add a new lp to the pool. Can only be called by the owner.
1428     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1429     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1430         if (_withUpdate) {
1431             massUpdatePools();
1432         }
1433         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1434         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1435         poolInfo.push(PoolInfo({
1436             lpToken: _lpToken,
1437             allocPoint: _allocPoint,
1438             lastRewardBlock: lastRewardBlock,
1439             accZomPerShare: 0
1440         }));
1441     }
1442 
1443     // Update the given pool's ZOM allocation point. Can only be called by the owner.
1444     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1445         if (_withUpdate) {
1446             massUpdatePools();
1447         }
1448         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1449         poolInfo[_pid].allocPoint = _allocPoint;
1450     }
1451 
1452     // Set the migrator contract. Can only be called by the owner.
1453     function setMigrator(IMigratorObsidian _migrator) public onlyOwner {
1454         migrator = _migrator;
1455     }
1456 
1457     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1458     function migrate(uint256 _pid) public {
1459         require(address(migrator) != address(0), "migrate: no migrator");
1460         PoolInfo storage pool = poolInfo[_pid];
1461         IERC20 lpToken = pool.lpToken;
1462         uint256 bal = lpToken.balanceOf(address(this));
1463         lpToken.safeApprove(address(migrator), bal);
1464         IERC20 newLpToken = migrator.migrate(lpToken);
1465         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1466         pool.lpToken = newLpToken;
1467     }
1468 
1469     // Return reward multiplier over the given _from to _to block.
1470     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1471         if (_to <= bonusEndBlock) {
1472             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1473         } else if (_from >= bonusEndBlock) {
1474             return _to.sub(_from);
1475         } else {
1476             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1477                 _to.sub(bonusEndBlock)
1478             );
1479         }
1480     }
1481 
1482     // View function to see pending ZOMs on frontend.
1483     function pendingZom(uint256 _pid, address _user) external view returns (uint256) {
1484         PoolInfo storage pool = poolInfo[_pid];
1485         UserInfo storage user = userInfo[_pid][_user];
1486         uint256 accZomPerShare = pool.accZomPerShare;
1487         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1488         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1489             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1490             uint256 zomReward = multiplier.mul(zomPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1491             accZomPerShare = accZomPerShare.add(zomReward.mul(1e12).div(lpSupply));
1492         }
1493         return user.amount.mul(accZomPerShare).div(1e12).sub(user.rewardDebt);
1494     }
1495 
1496     // Update reward vairables for all pools. Be careful of gas spending!
1497     function massUpdatePools() public {
1498         uint256 length = poolInfo.length;
1499         for (uint256 pid = 0; pid < length; ++pid) {
1500             updatePool(pid);
1501         }
1502     }
1503 
1504     // Update reward variables of the given pool to be up-to-date.
1505     function updatePool(uint256 _pid) public {
1506         PoolInfo storage pool = poolInfo[_pid];
1507         if (block.number <= pool.lastRewardBlock) {
1508             return;
1509         }
1510         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1511         if (lpSupply == 0) {
1512             pool.lastRewardBlock = block.number;
1513             return;
1514         }
1515         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1516         uint256 zomReward = multiplier.mul(zomPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1517         uint256 devrew = zomReward.mul(15).div(100); // 15% to dev/ team address
1518         uint256 liquipoolrew =  zomReward.sub(devrew); // rest to liquidity pool
1519         
1520         //distribute tokens
1521         zom.mint(devaddr, devrew);
1522         zom.mint(address(this), liquipoolrew);
1523         
1524         pool.accZomPerShare = pool.accZomPerShare.add(zomReward.mul(1e12).div(lpSupply));
1525         pool.lastRewardBlock = block.number;
1526     }
1527 
1528     // Deposit LP tokens to ZOM_Obsidian for ZOM allocation.
1529     function deposit(uint256 _pid, uint256 _amount) public {
1530         PoolInfo storage pool = poolInfo[_pid];
1531         UserInfo storage user = userInfo[_pid][msg.sender];
1532         updatePool(_pid);
1533         if (user.amount > 0) {
1534             uint256 pending = user.amount.mul(pool.accZomPerShare).div(1e12).sub(user.rewardDebt);
1535             safeZomTransfer(msg.sender, pending);
1536         }
1537         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1538         user.amount = user.amount.add(_amount);
1539         user.rewardDebt = user.amount.mul(pool.accZomPerShare).div(1e12);
1540         emit Deposit(msg.sender, _pid, _amount);
1541     }
1542 
1543     // Withdraw LP tokens from ZOM_Obsidian.
1544     function withdraw(uint256 _pid, uint256 _amount) public {
1545         PoolInfo storage pool = poolInfo[_pid];
1546         UserInfo storage user = userInfo[_pid][msg.sender];
1547         require(user.amount >= _amount, "withdraw: not good");
1548         updatePool(_pid);
1549         uint256 pending = user.amount.mul(pool.accZomPerShare).div(1e12).sub(user.rewardDebt);
1550         safeZomTransfer(msg.sender, pending);
1551         user.amount = user.amount.sub(_amount);
1552         user.rewardDebt = user.amount.mul(pool.accZomPerShare).div(1e12);
1553         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1554         emit Withdraw(msg.sender, _pid, _amount);
1555     }
1556 
1557     // Withdraw without caring about rewards. EMERGENCY ONLY.
1558     function emergencyWithdraw(uint256 _pid) public {
1559         PoolInfo storage pool = poolInfo[_pid];
1560         UserInfo storage user = userInfo[_pid][msg.sender];
1561         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1562         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1563         user.amount = 0;
1564         user.rewardDebt = 0;
1565     }
1566 
1567     // Safe zom transfer function, just in case if rounding error causes pool to not have enough ZOMs.
1568     function safeZomTransfer(address _to, uint256 _amount) internal {
1569         uint256 zomBal = zom.balanceOf(address(this));
1570         if (_amount > zomBal) {
1571             require(zom.transfer(_to, zomBal), "zom transfer failed");
1572         } else {
1573             require(zom.transfer(_to, _amount), "zom transfer failed");
1574         }
1575     }
1576 
1577     // Update dev address by the previous dev.
1578     function dev(address _devaddr) public {
1579         require(msg.sender == devaddr, "dev: wut?");
1580         devaddr = _devaddr;
1581     }
1582 }