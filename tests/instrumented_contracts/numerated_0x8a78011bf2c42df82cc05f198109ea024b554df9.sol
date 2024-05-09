1 pragma solidity ^0.6.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Library for managing
7  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
8  * types.
9  *
10  * Sets have the following properties:
11  *
12  * - Elements are added, removed, and checked for existence in constant time
13  * (O(1)).
14  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
15  *
16  * ```
17  * contract Example {
18  *     // Add the library methods
19  *     using EnumerableSet for EnumerableSet.AddressSet;
20  *
21  *     // Declare a set state variable
22  *     EnumerableSet.AddressSet private mySet;
23  * }
24  * ```
25  *
26  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
27  * (`UintSet`) are supported.
28  */
29 library EnumerableSet {
30     // To implement this library for multiple types with as little code
31     // repetition as possible, we write it in terms of a generic Set type with
32     // bytes32 values.
33     // The Set implementation uses private functions, and user-facing
34     // implementations (such as AddressSet) are just wrappers around the
35     // underlying Set.
36     // This means that we can only create new EnumerableSets for types that fit
37     // in bytes32.
38 
39     struct Set {
40         // Storage of set values
41         bytes32[] _values;
42 
43         // Position of the value in the `values` array, plus 1 because index 0
44         // means a value is not in the set.
45         mapping (bytes32 => uint256) _indexes;
46     }
47 
48     /**
49      * @dev Add a value to a set. O(1).
50      *
51      * Returns true if the value was added to the set, that is if it was not
52      * already present.
53      */
54     function _add(Set storage set, bytes32 value) private returns (bool) {
55         if (!_contains(set, value)) {
56             set._values.push(value);
57             // The value is stored at length-1, but we add 1 to all indexes
58             // and use 0 as a sentinel value
59             set._indexes[value] = set._values.length;
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     /**
67      * @dev Removes a value from a set. O(1).
68      *
69      * Returns true if the value was removed from the set, that is if it was
70      * present.
71      */
72     function _remove(Set storage set, bytes32 value) private returns (bool) {
73         // We read and store the value's index to prevent multiple reads from the same storage slot
74         uint256 valueIndex = set._indexes[value];
75 
76         if (valueIndex != 0) { // Equivalent to contains(set, value)
77             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
78             // the array, and then remove the last element (sometimes called as 'swap and pop').
79             // This modifies the order of the array, as noted in {at}.
80 
81             uint256 toDeleteIndex = valueIndex - 1;
82             uint256 lastIndex = set._values.length - 1;
83 
84             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
85             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
86 
87             bytes32 lastvalue = set._values[lastIndex];
88 
89             // Move the last value to the index where the value to delete is
90             set._values[toDeleteIndex] = lastvalue;
91             // Update the index for the moved value
92             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
93 
94             // Delete the slot where the moved value was stored
95             set._values.pop();
96 
97             // Delete the index for the deleted slot
98             delete set._indexes[value];
99 
100             return true;
101         } else {
102             return false;
103         }
104     }
105 
106     /**
107      * @dev Returns true if the value is in the set. O(1).
108      */
109     function _contains(Set storage set, bytes32 value) private view returns (bool) {
110         return set._indexes[value] != 0;
111     }
112 
113     /**
114      * @dev Returns the number of values on the set. O(1).
115      */
116     function _length(Set storage set) private view returns (uint256) {
117         return set._values.length;
118     }
119 
120    /**
121     * @dev Returns the value stored at position `index` in the set. O(1).
122     *
123     * Note that there are no guarantees on the ordering of values inside the
124     * array, and it may change when more values are added or removed.
125     *
126     * Requirements:
127     *
128     * - `index` must be strictly less than {length}.
129     */
130     function _at(Set storage set, uint256 index) private view returns (bytes32) {
131         require(set._values.length > index, "EnumerableSet: index out of bounds");
132         return set._values[index];
133     }
134 
135     // AddressSet
136 
137     struct AddressSet {
138         Set _inner;
139     }
140 
141     /**
142      * @dev Add a value to a set. O(1).
143      *
144      * Returns true if the value was added to the set, that is if it was not
145      * already present.
146      */
147     function add(AddressSet storage set, address value) internal returns (bool) {
148         return _add(set._inner, bytes32(uint256(value)));
149     }
150 
151     /**
152      * @dev Removes a value from a set. O(1).
153      *
154      * Returns true if the value was removed from the set, that is if it was
155      * present.
156      */
157     function remove(AddressSet storage set, address value) internal returns (bool) {
158         return _remove(set._inner, bytes32(uint256(value)));
159     }
160 
161     /**
162      * @dev Returns true if the value is in the set. O(1).
163      */
164     function contains(AddressSet storage set, address value) internal view returns (bool) {
165         return _contains(set._inner, bytes32(uint256(value)));
166     }
167 
168     /**
169      * @dev Returns the number of values in the set. O(1).
170      */
171     function length(AddressSet storage set) internal view returns (uint256) {
172         return _length(set._inner);
173     }
174 
175    /**
176     * @dev Returns the value stored at position `index` in the set. O(1).
177     *
178     * Note that there are no guarantees on the ordering of values inside the
179     * array, and it may change when more values are added or removed.
180     *
181     * Requirements:
182     *
183     * - `index` must be strictly less than {length}.
184     */
185     function at(AddressSet storage set, uint256 index) internal view returns (address) {
186         return address(uint256(_at(set._inner, index)));
187     }
188 
189 
190     // UintSet
191 
192     struct UintSet {
193         Set _inner;
194     }
195 
196     /**
197      * @dev Add a value to a set. O(1).
198      *
199      * Returns true if the value was added to the set, that is if it was not
200      * already present.
201      */
202     function add(UintSet storage set, uint256 value) internal returns (bool) {
203         return _add(set._inner, bytes32(value));
204     }
205 
206     /**
207      * @dev Removes a value from a set. O(1).
208      *
209      * Returns true if the value was removed from the set, that is if it was
210      * present.
211      */
212     function remove(UintSet storage set, uint256 value) internal returns (bool) {
213         return _remove(set._inner, bytes32(value));
214     }
215 
216     /**
217      * @dev Returns true if the value is in the set. O(1).
218      */
219     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
220         return _contains(set._inner, bytes32(value));
221     }
222 
223     /**
224      * @dev Returns the number of values on the set. O(1).
225      */
226     function length(UintSet storage set) internal view returns (uint256) {
227         return _length(set._inner);
228     }
229 
230    /**
231     * @dev Returns the value stored at position `index` in the set. O(1).
232     *
233     * Note that there are no guarantees on the ordering of values inside the
234     * array, and it may change when more values are added or removed.
235     *
236     * Requirements:
237     *
238     * - `index` must be strictly less than {length}.
239     */
240     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
241         return uint256(_at(set._inner, index));
242     }
243 }
244 
245 /**
246  * @dev Wrappers over Solidity's arithmetic operations with added overflow
247  * checks.
248  *
249  * Arithmetic operations in Solidity wrap on overflow. This can easily result
250  * in bugs, because programmers usually assume that an overflow raises an
251  * error, which is the standard behavior in high level programming languages.
252  * `SafeMath` restores this intuition by reverting the transaction when an
253  * operation overflows.
254  *
255  * Using this library instead of the unchecked operations eliminates an entire
256  * class of bugs, so it's recommended to use it always.
257  */
258 library SafeMath {
259     /**
260      * @dev Returns the addition of two unsigned integers, reverting on
261      * overflow.
262      *
263      * Counterpart to Solidity's `+` operator.
264      *
265      * Requirements:
266      *
267      * - Addition cannot overflow.
268      */
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         uint256 c = a + b;
271         require(c >= a, "SafeMath: addition overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the subtraction of two unsigned integers, reverting on
278      * overflow (when the result is negative).
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         return sub(a, b, "SafeMath: subtraction overflow");
288     }
289 
290     /**
291      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
292      * overflow (when the result is negative).
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      *
298      * - Subtraction cannot overflow.
299      */
300     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b <= a, errorMessage);
302         uint256 c = a - b;
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the multiplication of two unsigned integers, reverting on
309      * overflow.
310      *
311      * Counterpart to Solidity's `*` operator.
312      *
313      * Requirements:
314      *
315      * - Multiplication cannot overflow.
316      */
317     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
318         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
319         // benefit is lost if 'b' is also tested.
320         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
321         if (a == 0) {
322             return 0;
323         }
324 
325         uint256 c = a * b;
326         require(c / a == b, "SafeMath: multiplication overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the integer division of two unsigned integers. Reverts on
333      * division by zero. The result is rounded towards zero.
334      *
335      * Counterpart to Solidity's `/` operator. Note: this function uses a
336      * `revert` opcode (which leaves remaining gas untouched) while Solidity
337      * uses an invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      *
341      * - The divisor cannot be zero.
342      */
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344         return div(a, b, "SafeMath: division by zero");
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator. Note: this function uses a
352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
353      * uses an invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      *
357      * - The divisor cannot be zero.
358      */
359     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
360         require(b > 0, errorMessage);
361         uint256 c = a / b;
362         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * Reverts when dividing by zero.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
380         return mod(a, b, "SafeMath: modulo by zero");
381     }
382 
383     /**
384      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
385      * Reverts with custom message when dividing by zero.
386      *
387      * Counterpart to Solidity's `%` operator. This function uses a `revert`
388      * opcode (which leaves remaining gas untouched) while Solidity uses an
389      * invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
396         require(b != 0, errorMessage);
397         return a % b;
398     }
399 }
400 
401 /*
402  * @dev Provides information about the current execution context, including the
403  * sender of the transaction and its data. While these are generally available
404  * via msg.sender and msg.data, they should not be accessed in such a direct
405  * manner, since when dealing with GSN meta-transactions the account sending and
406  * paying for execution may not be the actual sender (as far as an application
407  * is concerned).
408  *
409  * This contract is only required for intermediate, library-like contracts.
410  */
411 abstract contract Context {
412     function _msgSender() internal view virtual returns (address payable) {
413         return msg.sender;
414     }
415 
416     function _msgData() internal view virtual returns (bytes memory) {
417         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
418         return msg.data;
419     }
420 }
421 
422 // File: contracts/GSN/Context.sol
423 // File: contracts/token/ERC20/IERC20.sol
424 /**
425  * @dev Interface of the ERC20 standard as defined in the EIP.
426  */
427 interface IERC20 {
428     /**
429      * @dev Returns the amount of tokens in existence.
430      */
431     function totalSupply() external view returns (uint256);
432 
433     /**
434      * @dev Returns the amount of tokens owned by `account`.
435      */
436     function balanceOf(address account) external view returns (uint256);
437 
438     /**
439      * @dev Moves `amount` tokens from the caller's account to `recipient`.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transfer(address recipient, uint256 amount) external returns (bool);
446 
447     /**
448      * @dev Returns the remaining number of tokens that `spender` will be
449      * allowed to spend on behalf of `owner` through {transferFrom}. This is
450      * zero by default.
451      *
452      * This value changes when {approve} or {transferFrom} are called.
453      */
454     function allowance(address owner, address spender) external view returns (uint256);
455 
456     /**
457      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
458      *
459      * Returns a boolean value indicating whether the operation succeeded.
460      *
461      * IMPORTANT: Beware that changing an allowance with this method brings the risk
462      * that someone may use both the old and the new allowance by unfortunate
463      * transaction ordering. One possible solution to mitigate this race
464      * condition is to first reduce the spender's allowance to 0 and set the
465      * desired value afterwards:
466      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
467      *
468      * Emits an {Approval} event.
469      */
470     function approve(address spender, uint256 amount) external returns (bool);
471 
472     /**
473      * @dev Moves `amount` tokens from `sender` to `recipient` using the
474      * allowance mechanism. `amount` is then deducted from the caller's
475      * allowance.
476      *
477      * Returns a boolean value indicating whether the operation succeeded.
478      *
479      * Emits a {Transfer} event.
480      */
481     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
482 
483     /**
484      * @dev Emitted when `value` tokens are moved from one account (`from`) to
485      * another (`to`).
486      *
487      * Note that `value` may be zero.
488      */
489     event Transfer(address indexed from, address indexed to, uint256 value);
490 
491     /**
492      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
493      * a call to {approve}. `value` is the new allowance.
494      */
495     event Approval(address indexed owner, address indexed spender, uint256 value);
496 }
497 
498 // File: contracts/utils/Address.sol
499 /**
500  * @dev Collection of functions related to the address type
501  */
502 library Address {
503     /**
504      * @dev Returns true if `account` is a contract.
505      *
506      * [IMPORTANT]
507      * ====
508      * It is unsafe to assume that an address for which this function returns
509      * false is an externally-owned account (EOA) and not a contract.
510      *
511      * Among others, `isContract` will return false for the following
512      * types of addresses:
513      *
514      *  - an externally-owned account
515      *  - a contract in construction
516      *  - an address where a contract will be created
517      *  - an address where a contract lived, but was destroyed
518      * ====
519      */
520     function isContract(address account) internal view returns (bool) {
521         // This method relies on extcodesize, which returns 0 for contracts in
522         // construction, since the code is only stored at the end of the
523         // constructor execution.
524 
525         uint256 size;
526         // solhint-disable-next-line no-inline-assembly
527         assembly { size := extcodesize(account) }
528         return size > 0;
529     }
530 
531     /**
532      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
533      * `recipient`, forwarding all available gas and reverting on errors.
534      *
535      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
536      * of certain opcodes, possibly making contracts go over the 2300 gas limit
537      * imposed by `transfer`, making them unable to receive funds via
538      * `transfer`. {sendValue} removes this limitation.
539      *
540      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
541      *
542      * IMPORTANT: because control is transferred to `recipient`, care must be
543      * taken to not create reentrancy vulnerabilities. Consider using
544      * {ReentrancyGuard} or the
545      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
546      */
547     function sendValue(address payable recipient, uint256 amount) internal {
548         require(address(this).balance >= amount, "Address: insufficient balance");
549 
550         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
551         (bool success, ) = recipient.call{ value: amount }("");
552         require(success, "Address: unable to send value, recipient may have reverted");
553     }
554 
555     /**
556      * @dev Performs a Solidity function call using a low level `call`. A
557      * plain`call` is an unsafe replacement for a function call: use this
558      * function instead.
559      *
560      * If `target` reverts with a revert reason, it is bubbled up by this
561      * function (like regular Solidity function calls).
562      *
563      * Returns the raw returned data. To convert to the expected return value,
564      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
565      *
566      * Requirements:
567      *
568      * - `target` must be a contract.
569      * - calling `target` with `data` must not revert.
570      *
571      * _Available since v3.1._
572      */
573     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
574       return functionCall(target, data, "Address: low-level call failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
579      * `errorMessage` as a fallback revert reason when `target` reverts.
580      *
581      * _Available since v3.1._
582      */
583     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
584         return _functionCallWithValue(target, data, 0, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but also transferring `value` wei to `target`.
590      *
591      * Requirements:
592      *
593      * - the calling contract must have an ETH balance of at least `value`.
594      * - the called Solidity function must be `payable`.
595      *
596      * _Available since v3.1._
597      */
598     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
604      * with `errorMessage` as a fallback revert reason when `target` reverts.
605      *
606      * _Available since v3.1._
607      */
608     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
609         require(address(this).balance >= value, "Address: insufficient balance for call");
610         return _functionCallWithValue(target, data, value, errorMessage);
611     }
612 
613     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
614         require(isContract(target), "Address: call to non-contract");
615 
616         // solhint-disable-next-line avoid-low-level-calls
617         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
618         if (success) {
619             return returndata;
620         } else {
621             // Look for revert reason and bubble it up if present
622             if (returndata.length > 0) {
623                 // The easiest way to bubble the revert reason is using memory via assembly
624 
625                 // solhint-disable-next-line no-inline-assembly
626                 assembly {
627                     let returndata_size := mload(returndata)
628                     revert(add(32, returndata), returndata_size)
629                 }
630             } else {
631                 revert(errorMessage);
632             }
633         }
634     }
635 }
636 
637 // File: contracts/token/ERC20/ERC20.sol
638 /**
639  * @dev Implementation of the {IERC20} interface.
640  *
641  * This implementation is agnostic to the way tokens are created. This means
642  * that a supply mechanism has to be added in a derived contract using {_mint}.
643  * For a generic mechanism see {ERC20PresetMinterPauser}.
644  *
645  * TIP: For a detailed writeup see our guide
646  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
647  * to implement supply mechanisms].
648  *
649  * We have followed general OpenZeppelin guidelines: functions revert instead
650  * of returning `false` on failure. This behavior is nonetheless conventional
651  * and does not conflict with the expectations of ERC20 applications.
652  *
653  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
654  * This allows applications to reconstruct the allowance for all accounts just
655  * by listening to said events. Other implementations of the EIP may not emit
656  * these events, as it isn't required by the specification.
657  *
658  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
659  * functions have been added to mitigate the well-known issues around setting
660  * allowances. See {IERC20-approve}.
661  */
662 contract ERC20 is Context, IERC20 {
663     using SafeMath for uint256;
664     using Address for address;
665 
666     mapping (address => uint256) private _balances;
667 
668     mapping (address => mapping (address => uint256)) private _allowances;
669 
670     uint256 private _totalSupply;
671 
672     string private _name;
673     string private _symbol;
674     uint8 private _decimals;
675 
676     /**
677      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
678      * a default value of 18.
679      *
680      * To select a different value for {decimals}, use {_setupDecimals}.
681      *
682      * All three of these values are immutable: they can only be set once during
683      * construction.
684      */
685     constructor (string memory name, string memory symbol) public {
686         _name = name;
687         _symbol = symbol;
688         _decimals = 18;
689     }
690 
691     /**
692      * @dev Returns the name of the token.
693      */
694     function name() public view returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev Returns the symbol of the token, usually a shorter version of the
700      * name.
701      */
702     function symbol() public view returns (string memory) {
703         return _symbol;
704     }
705 
706     /**
707      * @dev Returns the number of decimals used to get its user representation.
708      * For example, if `decimals` equals `2`, a balance of `505` tokens should
709      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
710      *
711      * Tokens usually opt for a value of 18, imitating the relationship between
712      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
713      * called.
714      *
715      * NOTE: This information is only used for _display_ purposes: it in
716      * no way affects any of the arithmetic of the contract, including
717      * {IERC20-balanceOf} and {IERC20-transfer}.
718      */
719     function decimals() public view returns (uint8) {
720         return _decimals;
721     }
722 
723     /**
724      * @dev See {IERC20-totalSupply}.
725      */
726     function totalSupply() public view override returns (uint256) {
727         return _totalSupply;
728     }
729 
730     /**
731      * @dev See {IERC20-balanceOf}.
732      */
733     function balanceOf(address account) public view override returns (uint256) {
734         return _balances[account];
735     }
736 
737     /**
738      * @dev See {IERC20-transfer}.
739      *
740      * Requirements:
741      *
742      * - `recipient` cannot be the zero address.
743      * - the caller must have a balance of at least `amount`.
744      */
745     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
746         _transfer(_msgSender(), recipient, amount);
747         return true;
748     }
749 
750     /**
751      * @dev See {IERC20-allowance}.
752      */
753     function allowance(address owner, address spender) public view virtual override returns (uint256) {
754         return _allowances[owner][spender];
755     }
756 
757     /**
758      * @dev See {IERC20-approve}.
759      *
760      * Requirements:
761      *
762      * - `spender` cannot be the zero address.
763      */
764     function approve(address spender, uint256 amount) public virtual override returns (bool) {
765         _approve(_msgSender(), spender, amount);
766         return true;
767     }
768 
769     /**
770      * @dev See {IERC20-transferFrom}.
771      *
772      * Emits an {Approval} event indicating the updated allowance. This is not
773      * required by the EIP. See the note at the beginning of {ERC20};
774      *
775      * Requirements:
776      * - `sender` and `recipient` cannot be the zero address.
777      * - `sender` must have a balance of at least `amount`.
778      * - the caller must have allowance for ``sender``'s tokens of at least
779      * `amount`.
780      */
781     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
782         _transfer(sender, recipient, amount);
783         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
784         return true;
785     }
786 
787     /**
788      * @dev Atomically increases the allowance granted to `spender` by the caller.
789      *
790      * This is an alternative to {approve} that can be used as a mitigation for
791      * problems described in {IERC20-approve}.
792      *
793      * Emits an {Approval} event indicating the updated allowance.
794      *
795      * Requirements:
796      *
797      * - `spender` cannot be the zero address.
798      */
799     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
800         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
801         return true;
802     }
803 
804     /**
805      * @dev Atomically decreases the allowance granted to `spender` by the caller.
806      *
807      * This is an alternative to {approve} that can be used as a mitigation for
808      * problems described in {IERC20-approve}.
809      *
810      * Emits an {Approval} event indicating the updated allowance.
811      *
812      * Requirements:
813      *
814      * - `spender` cannot be the zero address.
815      * - `spender` must have allowance for the caller of at least
816      * `subtractedValue`.
817      */
818     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
820         return true;
821     }
822 
823     /**
824      * @dev Moves tokens `amount` from `sender` to `recipient`.
825      *
826      * This is internal function is equivalent to {transfer}, and can be used to
827      * e.g. implement automatic token fees, slashing mechanisms, etc.
828      *
829      * Emits a {Transfer} event.
830      *
831      * Requirements:
832      *
833      * - `sender` cannot be the zero address.
834      * - `recipient` cannot be the zero address.
835      * - `sender` must have a balance of at least `amount`.
836      */
837     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
838         require(sender != address(0), "ERC20: transfer from the zero address");
839         require(recipient != address(0), "ERC20: transfer to the zero address");
840 
841         _beforeTokenTransfer(sender, recipient, amount);
842 
843         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
844         _balances[recipient] = _balances[recipient].add(amount);
845         emit Transfer(sender, recipient, amount);
846     }
847 
848     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
849      * the total supply.
850      *
851      * Emits a {Transfer} event with `from` set to the zero address.
852      *
853      * Requirements
854      *
855      * - `to` cannot be the zero address.
856      */
857     function _mint(address account, uint256 amount) internal virtual {
858         require(account != address(0), "ERC20: mint to the zero address");
859 
860         _beforeTokenTransfer(address(0), account, amount);
861 
862         _totalSupply = _totalSupply.add(amount);
863         _balances[account] = _balances[account].add(amount);
864         emit Transfer(address(0), account, amount);
865     }
866 
867     /**
868      * @dev Destroys `amount` tokens from `account`, reducing the
869      * total supply.
870      *
871      * Emits a {Transfer} event with `to` set to the zero address.
872      *
873      * Requirements
874      *
875      * - `account` cannot be the zero address.
876      * - `account` must have at least `amount` tokens.
877      */
878     function _burn(address account, uint256 amount) internal virtual {
879         require(account != address(0), "ERC20: burn from the zero address");
880 
881         _beforeTokenTransfer(account, address(0), amount);
882 
883         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
884         _totalSupply = _totalSupply.sub(amount);
885         emit Transfer(account, address(0), amount);
886     }
887 
888     /**
889      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
890      *
891      * This internal function is equivalent to `approve`, and can be used to
892      * e.g. set automatic allowances for certain subsystems, etc.
893      *
894      * Emits an {Approval} event.
895      *
896      * Requirements:
897      *
898      * - `owner` cannot be the zero address.
899      * - `spender` cannot be the zero address.
900      */
901     function _approve(address owner, address spender, uint256 amount) internal virtual {
902         require(owner != address(0), "ERC20: approve from the zero address");
903         require(spender != address(0), "ERC20: approve to the zero address");
904 
905         _allowances[owner][spender] = amount;
906         emit Approval(owner, spender, amount);
907     }
908 
909     /**
910      * @dev Sets {decimals} to a value other than the default one of 18.
911      *
912      * WARNING: This function should only be called from the constructor. Most
913      * applications that interact with token contracts will not expect
914      * {decimals} to ever change, and may work incorrectly if it does.
915      */
916     function _setupDecimals(uint8 decimals_) internal {
917         _decimals = decimals_;
918     }
919 
920     /**
921      * @dev Hook that is called before any transfer of tokens. This includes
922      * minting and burning.
923      *
924      * Calling conditions:
925      *
926      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
927      * will be to transferred to `to`.
928      * - when `from` is zero, `amount` tokens will be minted for `to`.
929      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
930      * - `from` and `to` are never both zero.
931      *
932      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
933      */
934     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
935 }
936 
937 /**
938  * @title SafeERC20
939  * @dev Wrappers around ERC20 operations that throw on failure (when the token
940  * contract returns false). Tokens that return no value (and instead revert or
941  * throw on failure) are also supported, non-reverting calls are assumed to be
942  * successful.
943  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
944  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
945  */
946 library SafeERC20 {
947     using SafeMath for uint256;
948     using Address for address;
949 
950     function safeTransfer(IERC20 token, address to, uint256 value) internal {
951         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
952     }
953 
954     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
955         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
956     }
957 
958     /**
959      * @dev Deprecated. This function has issues similar to the ones found in
960      * {IERC20-approve}, and its usage is discouraged.
961      *
962      * Whenever possible, use {safeIncreaseAllowance} and
963      * {safeDecreaseAllowance} instead.
964      */
965     function safeApprove(IERC20 token, address spender, uint256 value) internal {
966         // safeApprove should only be called when setting an initial allowance,
967         // or when resetting it to zero. To increase and decrease it, use
968         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
969         // solhint-disable-next-line max-line-length
970         require((value == 0) || (token.allowance(address(this), spender) == 0),
971             "SafeERC20: approve from non-zero to non-zero allowance"
972         );
973         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
974     }
975 
976     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
977         uint256 newAllowance = token.allowance(address(this), spender).add(value);
978         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
979     }
980 
981     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
982         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
983         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
984     }
985 
986     /**
987      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
988      * on the return value: the return value is optional (but if data is returned, it must not be false).
989      * @param token The token targeted by the call.
990      * @param data The call data (encoded using abi.encode or one of its variants).
991      */
992     function _callOptionalReturn(IERC20 token, bytes memory data) private {
993         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
994         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
995         // the target address contains contract code and also asserts for success in the low-level call.
996 
997         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
998         if (returndata.length > 0) { // Return data is optional
999             // solhint-disable-next-line max-line-length
1000             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1001         }
1002     }
1003 }
1004 
1005 /**
1006  * @dev Contract module which provides a basic access control mechanism, where
1007  * there is an account (an owner) that can be granted exclusive access to
1008  * specific functions.
1009  *
1010  * By default, the owner account will be the one that deploys the contract. This
1011  * can later be changed with {transferOwnership}.
1012  *
1013  * This module is used through inheritance. It will make available the modifier
1014  * `onlyOwner`, which can be applied to your functions to restrict their use to
1015  * the owner.
1016  */
1017 contract Ownable is Context {
1018     address private _owner;
1019 
1020     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1021 
1022     /**
1023      * @dev Initializes the contract setting the deployer as the initial owner.
1024      */
1025     constructor () internal {
1026         address msgSender = _msgSender();
1027         _owner = msgSender;
1028         emit OwnershipTransferred(address(0), msgSender);
1029     }
1030 
1031     /**
1032      * @dev Returns the address of the current owner.
1033      */
1034     function owner() public view returns (address) {
1035         return _owner;
1036     }
1037 
1038     /**
1039      * @dev Throws if called by any account other than the owner.
1040      */
1041     modifier onlyOwner() {
1042         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1043         _;
1044     }
1045 
1046     /**
1047      * @dev Leaves the contract without owner. It will not be possible to call
1048      * `onlyOwner` functions anymore. Can only be called by the current owner.
1049      *
1050      * NOTE: Renouncing ownership will leave the contract without an owner,
1051      * thereby removing any functionality that is only available to the owner.
1052      */
1053     function renounceOwnership() public virtual onlyOwner {
1054         emit OwnershipTransferred(_owner, address(0));
1055         _owner = address(0);
1056     }
1057 
1058     /**
1059      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1060      * Can only be called by the current owner.
1061      */
1062     function transferOwnership(address newOwner) public virtual onlyOwner {
1063         require(newOwner != address(0), "Ownable: new owner is the zero address");
1064         emit OwnershipTransferred(_owner, newOwner);
1065         _owner = newOwner;
1066     }
1067 }
1068 
1069 // MasterChef was the master of dop. He now governs over DOPS. He can make Dops and he is a fair guy.
1070 //
1071 // Note that it's ownable and the owner wields tremendous power. The ownership
1072 // will be transferred to a governance smart contract once DOPS is sufficiently
1073 // distributed and the community can show to govern itself.
1074 //
1075 // Have fun reading it. Hopefully it's bug-free. God bless.
1076 contract MasterChef is Ownable {
1077     using SafeMath for uint256;
1078     using SafeERC20 for IERC20;
1079 
1080     // Info of each user.
1081     struct UserInfo {
1082         uint256 amount; // How many LP tokens the user has provided.
1083         uint256 rewardDebt; // Reward debt. See explanation below.
1084         //
1085         // We do some fancy math here. Basically, any point in time, the amount of DOPs
1086         // entitled to a user but is pending to be distributed is:
1087         //
1088         //   pending reward = (user.amount * pool.accDopPerShare) - user.rewardDebt
1089         //
1090         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1091         //   1. The pool's `accDopPerShare` (and `lastRewardBlock`) gets updated.
1092         //   2. User receives the pending reward sent to his/her address.
1093         //   3. User's `amount` gets updated.
1094         //   4. User's `rewardDebt` gets updated.
1095     }
1096 
1097     // Info of each pool.
1098     struct PoolInfo {
1099         IERC20 lpToken; // Address of LP token contract.
1100         uint256 allocPoint; // How many allocation points assigned to this pool. DOPs to distribute per block.
1101         uint256 lastRewardBlock; // Last block number that DOPs distribution occurs.
1102         uint256 accDopPerShare; // Accumulated DOPs per share, times 1e12. See below.
1103     }
1104 
1105     // The DOP TOKEN!
1106     IERC20 public dop;
1107     // Dev fund (2%, initially)
1108     uint256 public devFundDivRate = 50;
1109     // Dev address.
1110     address public devaddr;
1111     // Block number when bonus DOP period ends.
1112     uint256 public bonusEndBlock;
1113     // DOP tokens created per block.
1114     uint256 public dopPerBlock;
1115     // Bonus muliplier for early dop makers.
1116     uint256 public constant BONUS_MULTIPLIER = 10;
1117 
1118     // Info of each pool.
1119     PoolInfo[] public poolInfo;
1120     // Info of each user that stakes LP tokens.
1121     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1122     // Total allocation points. Must be the sum of all allocation points in all pools.
1123     uint256 public totalAllocPoint = 0;
1124     // The block number when DOP mining starts.
1125     uint256 public startBlock;
1126 
1127     // Events
1128     event Recovered(address token, uint256 amount);
1129     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1130     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1131     event EmergencyWithdraw(
1132         address indexed user,
1133         uint256 indexed pid,
1134         uint256 amount
1135     );
1136 
1137     constructor(
1138         address _dop,
1139         // address _devaddr,
1140         uint256 _dopPerBlock,
1141         uint256 _startBlock,
1142         uint256 _bonusEndBlock
1143     ) public {
1144         dop = IERC20(_dop);
1145         devaddr = msg.sender;
1146         // devaddr = _devaddr;
1147         dopPerBlock = _dopPerBlock;
1148         bonusEndBlock = _bonusEndBlock;
1149         startBlock = _startBlock;
1150     }
1151 
1152     function poolLength() external view returns (uint256) {
1153         return poolInfo.length;
1154     }
1155 
1156     // Add a new lp to the pool. Can only be called by the owner.
1157     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1158     function add(
1159         uint256 _allocPoint,
1160         IERC20 _lpToken,
1161         bool _withUpdate
1162     ) public onlyOwner {
1163         if (_withUpdate) {
1164             massUpdatePools();
1165         }
1166         uint256 lastRewardBlock = block.number > startBlock
1167             ? block.number
1168             : startBlock;
1169         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1170         poolInfo.push(
1171             PoolInfo({
1172                 lpToken: _lpToken,
1173                 allocPoint: _allocPoint,
1174                 lastRewardBlock: lastRewardBlock,
1175                 accDopPerShare: 0
1176             })
1177         );
1178     }
1179 
1180     // Update the given pool's DOP allocation point. Can only be called by the owner.
1181     function set(
1182         uint256 _pid,
1183         uint256 _allocPoint,
1184         bool _withUpdate
1185     ) public onlyOwner {
1186         if (_withUpdate) {
1187             massUpdatePools();
1188         }
1189         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1190             _allocPoint
1191         );
1192         poolInfo[_pid].allocPoint = _allocPoint;
1193     }
1194 
1195     // Return reward multiplier over the given _from to _to block.
1196     function getMultiplier(uint256 _from, uint256 _to)
1197         public
1198         view
1199         returns (uint256)
1200     {
1201         if (_to <= bonusEndBlock) {
1202             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1203         } else if (_from >= bonusEndBlock) {
1204             return _to.sub(_from);
1205         } else {
1206             return
1207                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1208                     _to.sub(bonusEndBlock)
1209                 );
1210         }
1211     }
1212 
1213     // View function to see pending DOPs on frontend.
1214     function pendingDop(uint256 _pid, address _user)
1215         external
1216         view
1217         returns (uint256)
1218     {
1219         PoolInfo storage pool = poolInfo[_pid];
1220         UserInfo storage user = userInfo[_pid][_user];
1221         uint256 accDopPerShare = pool.accDopPerShare;
1222         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1223         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1224             uint256 multiplier = getMultiplier(
1225                 pool.lastRewardBlock,
1226                 block.number
1227             );
1228             uint256 dopReward = multiplier
1229                 .mul(dopPerBlock)
1230                 .mul(pool.allocPoint)
1231                 .div(totalAllocPoint);
1232             accDopPerShare = accDopPerShare.add(
1233                 dopReward.mul(1e12).div(lpSupply)
1234             );
1235         }
1236         return
1237             user.amount.mul(accDopPerShare).div(1e12).sub(user.rewardDebt);
1238     }
1239 
1240     // Update reward vairables for all pools. Be careful of gas spending!
1241     function massUpdatePools() public {
1242         uint256 length = poolInfo.length;
1243         for (uint256 pid = 0; pid < length; ++pid) {
1244             updatePool(pid);
1245         }
1246     }
1247 
1248     // Update reward variables of the given pool to be up-to-date.
1249     function updatePool(uint256 _pid) public {
1250         PoolInfo storage pool = poolInfo[_pid];
1251         if (block.number <= pool.lastRewardBlock) {
1252             return;
1253         }
1254         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1255         if (lpSupply == 0) {
1256             pool.lastRewardBlock = block.number;
1257             return;
1258         }
1259         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1260         uint256 dopReward = multiplier
1261             .mul(dopPerBlock)
1262             .mul(pool.allocPoint)
1263             .div(totalAllocPoint);
1264         // dop.mint(devaddr, dopReward.div(devFundDivRate));
1265         // dop.mint(address(this), dopReward);
1266         pool.accDopPerShare = pool.accDopPerShare.add(
1267             dopReward.mul(1e12).div(lpSupply)
1268         );
1269         pool.lastRewardBlock = block.number;
1270     }
1271 
1272     // Deposit LP tokens to MasterChef for DOP allocation.
1273     function deposit(uint256 _pid, uint256 _amount) public {
1274         PoolInfo storage pool = poolInfo[_pid];
1275         UserInfo storage user = userInfo[_pid][msg.sender];
1276         updatePool(_pid);
1277         if (user.amount > 0) {
1278             uint256 pending = user
1279                 .amount
1280                 .mul(pool.accDopPerShare)
1281                 .div(1e12)
1282                 .sub(user.rewardDebt);
1283             safeDopTransfer(msg.sender, pending);
1284         }
1285         pool.lpToken.safeTransferFrom(
1286             address(msg.sender),
1287             address(this),
1288             _amount
1289         );
1290         user.amount = user.amount.add(_amount);
1291         user.rewardDebt = user.amount.mul(pool.accDopPerShare).div(1e12);
1292         emit Deposit(msg.sender, _pid, _amount);
1293     }
1294 
1295     // Withdraw LP tokens from MasterChef.
1296     function withdraw(uint256 _pid, uint256 _amount) public {
1297         PoolInfo storage pool = poolInfo[_pid];
1298         UserInfo storage user = userInfo[_pid][msg.sender];
1299         require(user.amount >= _amount, "withdraw: not good");
1300         updatePool(_pid);
1301         uint256 pending = user.amount.mul(pool.accDopPerShare).div(1e12).sub(
1302             user.rewardDebt
1303         );
1304         safeDopTransfer(msg.sender, pending);
1305         user.amount = user.amount.sub(_amount);
1306         user.rewardDebt = user.amount.mul(pool.accDopPerShare).div(1e12);
1307         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1308         emit Withdraw(msg.sender, _pid, _amount);
1309     }
1310 
1311     // Withdraw without caring about rewards. EMERGENCY ONLY.
1312     function emergencyWithdraw(uint256 _pid) public {
1313         PoolInfo storage pool = poolInfo[_pid];
1314         UserInfo storage user = userInfo[_pid][msg.sender];
1315         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1316         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1317         user.amount = 0;
1318         user.rewardDebt = 0;
1319     }
1320 
1321     // Safe dop transfer function, just in case if rounding error causes pool to not have enough DOPs.
1322     function safeDopTransfer(address _to, uint256 _amount) internal {
1323         uint256 dopBal = dop.balanceOf(address(this));
1324         if (_amount > dopBal) {
1325             dop.transfer(_to, dopBal);
1326         } else {
1327             dop.transfer(_to, _amount);
1328         }
1329     }
1330 
1331     // Update dev address by the previous dev.
1332     function dev(address _devaddr) public {
1333         require(msg.sender == devaddr, "dev: wut?");
1334         devaddr = _devaddr;
1335     }
1336 
1337     // **** Additional functions separate from the original masterchef contract ****
1338 
1339     function setDopPerBlock(uint256 _dopPerBlock) public onlyOwner {
1340         require(_dopPerBlock > 0, "!dopPerBlock-0");
1341 
1342         dopPerBlock = _dopPerBlock;
1343     }
1344 
1345     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1346         bonusEndBlock = _bonusEndBlock;
1347     }
1348 
1349     function setDevFundDivRate(uint256 _devFundDivRate) public onlyOwner {
1350         require(_devFundDivRate > 0, "!devFundDivRate-0");
1351         devFundDivRate = _devFundDivRate;
1352     }
1353 }