1 pragma solidity 0.6.7;
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
245 // SPDX-License-Identifier: MIT
246 /**
247  * @dev Wrappers over Solidity's arithmetic operations with added overflow
248  * checks.
249  *
250  * Arithmetic operations in Solidity wrap on overflow. This can easily result
251  * in bugs, because programmers usually assume that an overflow raises an
252  * error, which is the standard behavior in high level programming languages.
253  * `SafeMath` restores this intuition by reverting the transaction when an
254  * operation overflows.
255  *
256  * Using this library instead of the unchecked operations eliminates an entire
257  * class of bugs, so it's recommended to use it always.
258  */
259 library SafeMath {
260     /**
261      * @dev Returns the addition of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `+` operator.
265      *
266      * Requirements:
267      *
268      * - Addition cannot overflow.
269      */
270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
271         uint256 c = a + b;
272         require(c >= a, "SafeMath: addition overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the subtraction of two unsigned integers, reverting on
279      * overflow (when the result is negative).
280      *
281      * Counterpart to Solidity's `-` operator.
282      *
283      * Requirements:
284      *
285      * - Subtraction cannot overflow.
286      */
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return sub(a, b, "SafeMath: subtraction overflow");
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      *
299      * - Subtraction cannot overflow.
300      */
301     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b <= a, errorMessage);
303         uint256 c = a - b;
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the multiplication of two unsigned integers, reverting on
310      * overflow.
311      *
312      * Counterpart to Solidity's `*` operator.
313      *
314      * Requirements:
315      *
316      * - Multiplication cannot overflow.
317      */
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
320         // benefit is lost if 'b' is also tested.
321         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
322         if (a == 0) {
323             return 0;
324         }
325 
326         uint256 c = a * b;
327         require(c / a == b, "SafeMath: multiplication overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers. Reverts on
334      * division by zero. The result is rounded towards zero.
335      *
336      * Counterpart to Solidity's `/` operator. Note: this function uses a
337      * `revert` opcode (which leaves remaining gas untouched) while Solidity
338      * uses an invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function div(uint256 a, uint256 b) internal pure returns (uint256) {
345         return div(a, b, "SafeMath: division by zero");
346     }
347 
348     /**
349      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
350      * division by zero. The result is rounded towards zero.
351      *
352      * Counterpart to Solidity's `/` operator. Note: this function uses a
353      * `revert` opcode (which leaves remaining gas untouched) while Solidity
354      * uses an invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b > 0, errorMessage);
362         uint256 c = a / b;
363         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
364 
365         return c;
366     }
367 
368     /**
369      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
370      * Reverts when dividing by zero.
371      *
372      * Counterpart to Solidity's `%` operator. This function uses a `revert`
373      * opcode (which leaves remaining gas untouched) while Solidity uses an
374      * invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
381         return mod(a, b, "SafeMath: modulo by zero");
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
386      * Reverts with custom message when dividing by zero.
387      *
388      * Counterpart to Solidity's `%` operator. This function uses a `revert`
389      * opcode (which leaves remaining gas untouched) while Solidity uses an
390      * invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      *
394      * - The divisor cannot be zero.
395      */
396     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
397         require(b != 0, errorMessage);
398         return a % b;
399     }
400 }
401 
402 // SPDX-License-Identifier: MIT
403 /*
404  * @dev Provides information about the current execution context, including the
405  * sender of the transaction and its data. While these are generally available
406  * via msg.sender and msg.data, they should not be accessed in such a direct
407  * manner, since when dealing with GSN meta-transactions the account sending and
408  * paying for execution may not be the actual sender (as far as an application
409  * is concerned).
410  *
411  * This contract is only required for intermediate, library-like contracts.
412  */
413 abstract contract Context {
414     function _msgSender() internal view virtual returns (address payable) {
415         return msg.sender;
416     }
417 
418     function _msgData() internal view virtual returns (bytes memory) {
419         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
420         return msg.data;
421     }
422 }
423 
424 // File: contracts/GSN/Context.sol
425 // SPDX-License-Identifier: MIT
426 // File: contracts/token/ERC20/IERC20.sol
427 /**
428  * @dev Interface of the ERC20 standard as defined in the EIP.
429  */
430 interface IERC20 {
431     /**
432      * @dev Returns the amount of tokens in existence.
433      */
434     function totalSupply() external view returns (uint256);
435 
436     /**
437      * @dev Returns the amount of tokens owned by `account`.
438      */
439     function balanceOf(address account) external view returns (uint256);
440 
441     /**
442      * @dev Moves `amount` tokens from the caller's account to `recipient`.
443      *
444      * Returns a boolean value indicating whether the operation succeeded.
445      *
446      * Emits a {Transfer} event.
447      */
448     function transfer(address recipient, uint256 amount) external returns (bool);
449 
450     /**
451      * @dev Returns the remaining number of tokens that `spender` will be
452      * allowed to spend on behalf of `owner` through {transferFrom}. This is
453      * zero by default.
454      *
455      * This value changes when {approve} or {transferFrom} are called.
456      */
457     function allowance(address owner, address spender) external view returns (uint256);
458 
459     /**
460      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
461      *
462      * Returns a boolean value indicating whether the operation succeeded.
463      *
464      * IMPORTANT: Beware that changing an allowance with this method brings the risk
465      * that someone may use both the old and the new allowance by unfortunate
466      * transaction ordering. One possible solution to mitigate this race
467      * condition is to first reduce the spender's allowance to 0 and set the
468      * desired value afterwards:
469      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
470      *
471      * Emits an {Approval} event.
472      */
473     function approve(address spender, uint256 amount) external returns (bool);
474 
475     /**
476      * @dev Moves `amount` tokens from `sender` to `recipient` using the
477      * allowance mechanism. `amount` is then deducted from the caller's
478      * allowance.
479      *
480      * Returns a boolean value indicating whether the operation succeeded.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
485 
486     /**
487      * @dev Emitted when `value` tokens are moved from one account (`from`) to
488      * another (`to`).
489      *
490      * Note that `value` may be zero.
491      */
492     event Transfer(address indexed from, address indexed to, uint256 value);
493 
494     /**
495      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
496      * a call to {approve}. `value` is the new allowance.
497      */
498     event Approval(address indexed owner, address indexed spender, uint256 value);
499 }
500 
501 // File: contracts/utils/Address.sol
502 /**
503  * @dev Collection of functions related to the address type
504  */
505 library Address {
506     /**
507      * @dev Returns true if `account` is a contract.
508      *
509      * [IMPORTANT]
510      * ====
511      * It is unsafe to assume that an address for which this function returns
512      * false is an externally-owned account (EOA) and not a contract.
513      *
514      * Among others, `isContract` will return false for the following
515      * types of addresses:
516      *
517      *  - an externally-owned account
518      *  - a contract in construction
519      *  - an address where a contract will be created
520      *  - an address where a contract lived, but was destroyed
521      * ====
522      */
523     function isContract(address account) internal view returns (bool) {
524         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
525         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
526         // for accounts without code, i.e. `keccak256('')`
527         bytes32 codehash;
528         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
529         // solhint-disable-next-line no-inline-assembly
530         assembly { codehash := extcodehash(account) }
531         return (codehash != accountHash && codehash != 0x0);
532     }
533 
534     /**
535      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
536      * `recipient`, forwarding all available gas and reverting on errors.
537      *
538      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
539      * of certain opcodes, possibly making contracts go over the 2300 gas limit
540      * imposed by `transfer`, making them unable to receive funds via
541      * `transfer`. {sendValue} removes this limitation.
542      *
543      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
544      *
545      * IMPORTANT: because control is transferred to `recipient`, care must be
546      * taken to not create reentrancy vulnerabilities. Consider using
547      * {ReentrancyGuard} or the
548      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
549      */
550     function sendValue(address payable recipient, uint256 amount) internal {
551         require(address(this).balance >= amount, "Address: insufficient balance");
552 
553         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
554         (bool success, ) = recipient.call{ value: amount }("");
555         require(success, "Address: unable to send value, recipient may have reverted");
556     }
557 
558     /**
559      * @dev Performs a Solidity function call using a low level `call`. A
560      * plain`call` is an unsafe replacement for a function call: use this
561      * function instead.
562      *
563      * If `target` reverts with a revert reason, it is bubbled up by this
564      * function (like regular Solidity function calls).
565      *
566      * Returns the raw returned data. To convert to the expected return value,
567      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
568      *
569      * Requirements:
570      *
571      * - `target` must be a contract.
572      * - calling `target` with `data` must not revert.
573      *
574      * _Available since v3.1._
575      */
576     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
577       return functionCall(target, data, "Address: low-level call failed");
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
582      * `errorMessage` as a fallback revert reason when `target` reverts.
583      *
584      * _Available since v3.1._
585      */
586     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
587         return _functionCallWithValue(target, data, 0, errorMessage);
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but also transferring `value` wei to `target`.
593      *
594      * Requirements:
595      *
596      * - the calling contract must have an ETH balance of at least `value`.
597      * - the called Solidity function must be `payable`.
598      *
599      * _Available since v3.1._
600      */
601     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
602         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
607      * with `errorMessage` as a fallback revert reason when `target` reverts.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
612         require(address(this).balance >= value, "Address: insufficient balance for call");
613         return _functionCallWithValue(target, data, value, errorMessage);
614     }
615 
616     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
617         require(isContract(target), "Address: call to non-contract");
618 
619         // solhint-disable-next-line avoid-low-level-calls
620         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
621         if (success) {
622             return returndata;
623         } else {
624             // Look for revert reason and bubble it up if present
625             if (returndata.length > 0) {
626                 // The easiest way to bubble the revert reason is using memory via assembly
627 
628                 // solhint-disable-next-line no-inline-assembly
629                 assembly {
630                     let returndata_size := mload(returndata)
631                     revert(add(32, returndata), returndata_size)
632                 }
633             } else {
634                 revert(errorMessage);
635             }
636         }
637     }
638 }
639 
640 // File: contracts/token/ERC20/ERC20.sol
641 /**
642  * @dev Implementation of the {IERC20} interface.
643  *
644  * This implementation is agnostic to the way tokens are created. This means
645  * that a supply mechanism has to be added in a derived contract using {_mint}.
646  * For a generic mechanism see {ERC20PresetMinterPauser}.
647  *
648  * TIP: For a detailed writeup see our guide
649  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
650  * to implement supply mechanisms].
651  *
652  * We have followed general OpenZeppelin guidelines: functions revert instead
653  * of returning `false` on failure. This behavior is nonetheless conventional
654  * and does not conflict with the expectations of ERC20 applications.
655  *
656  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
657  * This allows applications to reconstruct the allowance for all accounts just
658  * by listening to said events. Other implementations of the EIP may not emit
659  * these events, as it isn't required by the specification.
660  *
661  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
662  * functions have been added to mitigate the well-known issues around setting
663  * allowances. See {IERC20-approve}.
664  */
665 contract ERC20 is Context, IERC20 {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     mapping (address => uint256) private _balances;
670 
671     mapping (address => mapping (address => uint256)) private _allowances;
672 
673     uint256 private _totalSupply;
674 
675     string private _name;
676     string private _symbol;
677     uint8 private _decimals;
678 
679     /**
680      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
681      * a default value of 18.
682      *
683      * To select a different value for {decimals}, use {_setupDecimals}.
684      *
685      * All three of these values are immutable: they can only be set once during
686      * construction.
687      */
688     constructor (string memory name, string memory symbol) public {
689         _name = name;
690         _symbol = symbol;
691         _decimals = 18;
692     }
693 
694     /**
695      * @dev Returns the name of the token.
696      */
697     function name() public view returns (string memory) {
698         return _name;
699     }
700 
701     /**
702      * @dev Returns the symbol of the token, usually a shorter version of the
703      * name.
704      */
705     function symbol() public view returns (string memory) {
706         return _symbol;
707     }
708 
709     /**
710      * @dev Returns the number of decimals used to get its user representation.
711      * For example, if `decimals` equals `2`, a balance of `505` tokens should
712      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
713      *
714      * Tokens usually opt for a value of 18, imitating the relationship between
715      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
716      * called.
717      *
718      * NOTE: This information is only used for _display_ purposes: it in
719      * no way affects any of the arithmetic of the contract, including
720      * {IERC20-balanceOf} and {IERC20-transfer}.
721      */
722     function decimals() public view returns (uint8) {
723         return _decimals;
724     }
725 
726     /**
727      * @dev See {IERC20-totalSupply}.
728      */
729     function totalSupply() public view override returns (uint256) {
730         return _totalSupply;
731     }
732 
733     /**
734      * @dev See {IERC20-balanceOf}.
735      */
736     function balanceOf(address account) public view override returns (uint256) {
737         return _balances[account];
738     }
739 
740     /**
741      * @dev See {IERC20-transfer}.
742      *
743      * Requirements:
744      *
745      * - `recipient` cannot be the zero address.
746      * - the caller must have a balance of at least `amount`.
747      */
748     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
749         _transfer(_msgSender(), recipient, amount);
750         return true;
751     }
752 
753     /**
754      * @dev See {IERC20-allowance}.
755      */
756     function allowance(address owner, address spender) public view virtual override returns (uint256) {
757         return _allowances[owner][spender];
758     }
759 
760     /**
761      * @dev See {IERC20-approve}.
762      *
763      * Requirements:
764      *
765      * - `spender` cannot be the zero address.
766      */
767     function approve(address spender, uint256 amount) public virtual override returns (bool) {
768         _approve(_msgSender(), spender, amount);
769         return true;
770     }
771 
772     /**
773      * @dev See {IERC20-transferFrom}.
774      *
775      * Emits an {Approval} event indicating the updated allowance. This is not
776      * required by the EIP. See the note at the beginning of {ERC20};
777      *
778      * Requirements:
779      * - `sender` and `recipient` cannot be the zero address.
780      * - `sender` must have a balance of at least `amount`.
781      * - the caller must have allowance for ``sender``'s tokens of at least
782      * `amount`.
783      */
784     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
785         _transfer(sender, recipient, amount);
786         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
787         return true;
788     }
789 
790     /**
791      * @dev Atomically increases the allowance granted to `spender` by the caller.
792      *
793      * This is an alternative to {approve} that can be used as a mitigation for
794      * problems described in {IERC20-approve}.
795      *
796      * Emits an {Approval} event indicating the updated allowance.
797      *
798      * Requirements:
799      *
800      * - `spender` cannot be the zero address.
801      */
802     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
803         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
804         return true;
805     }
806 
807     /**
808      * @dev Atomically decreases the allowance granted to `spender` by the caller.
809      *
810      * This is an alternative to {approve} that can be used as a mitigation for
811      * problems described in {IERC20-approve}.
812      *
813      * Emits an {Approval} event indicating the updated allowance.
814      *
815      * Requirements:
816      *
817      * - `spender` cannot be the zero address.
818      * - `spender` must have allowance for the caller of at least
819      * `subtractedValue`.
820      */
821     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
822         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
823         return true;
824     }
825 
826     /**
827      * @dev Moves tokens `amount` from `sender` to `recipient`.
828      *
829      * This is internal function is equivalent to {transfer}, and can be used to
830      * e.g. implement automatic token fees, slashing mechanisms, etc.
831      *
832      * Emits a {Transfer} event.
833      *
834      * Requirements:
835      *
836      * - `sender` cannot be the zero address.
837      * - `recipient` cannot be the zero address.
838      * - `sender` must have a balance of at least `amount`.
839      */
840     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
841         require(sender != address(0), "ERC20: transfer from the zero address");
842         require(recipient != address(0), "ERC20: transfer to the zero address");
843 
844         _beforeTokenTransfer(sender, recipient, amount);
845 
846         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
847         _balances[recipient] = _balances[recipient].add(amount);
848         emit Transfer(sender, recipient, amount);
849     }
850 
851     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
852      * the total supply.
853      *
854      * Emits a {Transfer} event with `from` set to the zero address.
855      *
856      * Requirements
857      *
858      * - `to` cannot be the zero address.
859      */
860     function _mint(address account, uint256 amount) internal virtual {
861         require(account != address(0), "ERC20: mint to the zero address");
862 
863         _beforeTokenTransfer(address(0), account, amount);
864 
865         _totalSupply = _totalSupply.add(amount);
866         _balances[account] = _balances[account].add(amount);
867         emit Transfer(address(0), account, amount);
868     }
869 
870     /**
871      * @dev Destroys `amount` tokens from `account`, reducing the
872      * total supply.
873      *
874      * Emits a {Transfer} event with `to` set to the zero address.
875      *
876      * Requirements
877      *
878      * - `account` cannot be the zero address.
879      * - `account` must have at least `amount` tokens.
880      */
881     function _burn(address account, uint256 amount) internal virtual {
882         require(account != address(0), "ERC20: burn from the zero address");
883 
884         _beforeTokenTransfer(account, address(0), amount);
885 
886         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
887         _totalSupply = _totalSupply.sub(amount);
888         emit Transfer(account, address(0), amount);
889     }
890 
891     /**
892      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
893      *
894      * This internal function is equivalent to `approve`, and can be used to
895      * e.g. set automatic allowances for certain subsystems, etc.
896      *
897      * Emits an {Approval} event.
898      *
899      * Requirements:
900      *
901      * - `owner` cannot be the zero address.
902      * - `spender` cannot be the zero address.
903      */
904     function _approve(address owner, address spender, uint256 amount) internal virtual {
905         require(owner != address(0), "ERC20: approve from the zero address");
906         require(spender != address(0), "ERC20: approve to the zero address");
907 
908         _allowances[owner][spender] = amount;
909         emit Approval(owner, spender, amount);
910     }
911 
912     /**
913      * @dev Sets {decimals} to a value other than the default one of 18.
914      *
915      * WARNING: This function should only be called from the constructor. Most
916      * applications that interact with token contracts will not expect
917      * {decimals} to ever change, and may work incorrectly if it does.
918      */
919     function _setupDecimals(uint8 decimals_) internal {
920         _decimals = decimals_;
921     }
922 
923     /**
924      * @dev Hook that is called before any transfer of tokens. This includes
925      * minting and burning.
926      *
927      * Calling conditions:
928      *
929      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
930      * will be to transferred to `to`.
931      * - when `from` is zero, `amount` tokens will be minted for `to`.
932      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
933      * - `from` and `to` are never both zero.
934      *
935      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
936      */
937     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
938 }
939 
940 /**
941  * @title SafeERC20
942  * @dev Wrappers around ERC20 operations that throw on failure (when the token
943  * contract returns false). Tokens that return no value (and instead revert or
944  * throw on failure) are also supported, non-reverting calls are assumed to be
945  * successful.
946  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
947  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
948  */
949 library SafeERC20 {
950     using SafeMath for uint256;
951     using Address for address;
952 
953     function safeTransfer(IERC20 token, address to, uint256 value) internal {
954         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
955     }
956 
957     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
958         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
959     }
960 
961     /**
962      * @dev Deprecated. This function has issues similar to the ones found in
963      * {IERC20-approve}, and its usage is discouraged.
964      *
965      * Whenever possible, use {safeIncreaseAllowance} and
966      * {safeDecreaseAllowance} instead.
967      */
968     function safeApprove(IERC20 token, address spender, uint256 value) internal {
969         // safeApprove should only be called when setting an initial allowance,
970         // or when resetting it to zero. To increase and decrease it, use
971         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
972         // solhint-disable-next-line max-line-length
973         require((value == 0) || (token.allowance(address(this), spender) == 0),
974             "SafeERC20: approve from non-zero to non-zero allowance"
975         );
976         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
977     }
978 
979     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
980         uint256 newAllowance = token.allowance(address(this), spender).add(value);
981         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
982     }
983 
984     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
985         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
986         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
987     }
988 
989     /**
990      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
991      * on the return value: the return value is optional (but if data is returned, it must not be false).
992      * @param token The token targeted by the call.
993      * @param data The call data (encoded using abi.encode or one of its variants).
994      */
995     function _callOptionalReturn(IERC20 token, bytes memory data) private {
996         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
997         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
998         // the target address contains contract code and also asserts for success in the low-level call.
999 
1000         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1001         if (returndata.length > 0) { // Return data is optional
1002             // solhint-disable-next-line max-line-length
1003             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1004         }
1005     }
1006 }
1007 
1008 // SPDX-License-Identifier: MIT
1009 /**
1010  * @dev Contract module which provides a basic access control mechanism, where
1011  * there is an account (an owner) that can be granted exclusive access to
1012  * specific functions.
1013  *
1014  * By default, the owner account will be the one that deploys the contract. This
1015  * can later be changed with {transferOwnership}.
1016  *
1017  * This module is used through inheritance. It will make available the modifier
1018  * `onlyOwner`, which can be applied to your functions to restrict their use to
1019  * the owner.
1020  */
1021 contract Ownable is Context {
1022     address private _owner;
1023 
1024     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1025 
1026     /**
1027      * @dev Initializes the contract setting the deployer as the initial owner.
1028      */
1029     constructor () internal {
1030         address msgSender = _msgSender();
1031         _owner = msgSender;
1032         emit OwnershipTransferred(address(0), msgSender);
1033     }
1034 
1035     /**
1036      * @dev Returns the address of the current owner.
1037      */
1038     function owner() public view returns (address) {
1039         return _owner;
1040     }
1041 
1042     /**
1043      * @dev Throws if called by any account other than the owner.
1044      */
1045     modifier onlyOwner() {
1046         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1047         _;
1048     }
1049 
1050     /**
1051      * @dev Leaves the contract without owner. It will not be possible to call
1052      * `onlyOwner` functions anymore. Can only be called by the current owner.
1053      *
1054      * NOTE: Renouncing ownership will leave the contract without an owner,
1055      * thereby removing any functionality that is only available to the owner.
1056      */
1057     function renounceOwnership() public virtual onlyOwner {
1058         emit OwnershipTransferred(_owner, address(0));
1059         _owner = address(0);
1060     }
1061 
1062     /**
1063      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1064      * Can only be called by the current owner.
1065      */
1066     function transferOwnership(address newOwner) public virtual onlyOwner {
1067         require(newOwner != address(0), "Ownable: new owner is the zero address");
1068         emit OwnershipTransferred(_owner, newOwner);
1069         _owner = newOwner;
1070     }
1071 }
1072 
1073 // MMToken with Governance.
1074 contract MMToken is ERC20("MMToken", "MM"), Ownable {
1075     uint256 private _cap = 721704 * (10 ** 18);
1076 
1077     /**
1078      * @dev Returns the cap on the token's total supply.
1079      */
1080     function cap() public view returns (uint256) {
1081         return _cap;
1082     }
1083 
1084     /**
1085      * @dev See {ERC20-_beforeTokenTransfer}.
1086      *
1087      * Requirements:
1088      *
1089      * - minted tokens must not cause the total supply to go over the cap.
1090      */
1091     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1092         super._beforeTokenTransfer(from, to, amount);
1093 
1094         if (from == address(0)) { // When minting tokens
1095             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1096         }
1097     }
1098 
1099     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1100     function mint(address _to, uint256 _amount) public onlyOwner {
1101         _mint(_to, _amount);
1102     }
1103 }
1104 
1105 // MasterChef was the master of mm. He now governs over MMS. He can make mm and he is a fair guy.
1106 //
1107 // Note that it's ownable and the owner wields tremendous power. The ownership
1108 // will be transferred to a governance smart contract once MMS is sufficiently
1109 // distributed and the community can show to govern itself.
1110 //
1111 // Have fun reading it. Hopefully it's bug-free. God bless.
1112 contract MasterChef is Ownable {
1113     using SafeMath for uint256;
1114     using SafeERC20 for IERC20;
1115 
1116     // Info of each user.
1117     struct UserInfo {
1118         uint256 amount; // How many LP tokens the user has provided.
1119         uint256 rewardDebt; // Reward debt. See explanation below.
1120         //
1121         // We do some fancy math here. Basically, any point in time, the amount of MMs
1122         // entitled to a user but is pending to be distributed is:
1123         //
1124         //   pending reward = (user.amount * pool.accMMPerShare) - user.rewardDebt
1125         //
1126         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1127         //   1. The pool's `accMMPerShare` (and `lastRewardBlock` and `amount`) gets updated.
1128         //   2. User receives the pending reward sent to his/her address.
1129         //   3. User's `amount` gets updated.
1130         //   4. User's `rewardDebt` gets updated.
1131     }
1132 
1133     // Info of each pool.
1134     struct PoolInfo {
1135         IERC20 lpToken; // Address of LP token contract.
1136         uint256 allocPoint; // How many allocation points assigned to this pool. MMs to distribute per block.
1137         uint256 lastRewardBlock; // Last block number that MMs distribution occurs.
1138         uint256 accMMPerShare; // Accumulated MMs per share, times 1e12. See below.
1139         uint256 amount; // How many LP tokens in the pool.
1140     }
1141 	
1142     // MM staking pool id: the first pool to be added in MasterChef
1143     uint256 public constant mmPoolId = 0;
1144 
1145     // The MM TOKEN! default mining pool distribution is 70% initially
1146     MMToken public mm;
1147     // Dev fund (25% initially)
1148     uint256 public devFundDivRate = 28;
1149     // Dev address.
1150     address public devaddr;
1151     // Dev distribution multiplier
1152     uint256 public devMultiplier = 10;
1153     // Treasury fund (5% initially)
1154     uint256 public treasuryDivRate = 14;
1155     // Treasury address.
1156     address public treasuryAddr;
1157     // Treasury distribution multiplier
1158     uint256 public treasuryMultiplier = 1;
1159     // Block number when bonus MM period ends.
1160     uint256 public bonusEndBlock;
1161     // MM tokens created per block.
1162     uint256 public mmPerBlock;
1163     // Bonus muliplier for early mm makers.
1164     uint256 public constant BONUS_MULTIPLIER = 10;
1165 
1166     // Info of each pool.
1167     PoolInfo[] public poolInfo;
1168     // Info of each user that stakes LP tokens.
1169     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1170     // Total allocation points. Must be the sum of all allocation points in all pools.
1171     uint256 public totalAllocPoint = 0;
1172     // The block number when MM mining starts.
1173     uint256 public startBlock;	
1174     // The buyback notifiers: usually earning strategy.
1175     mapping(address => bool) public buybackNotifiers;
1176 
1177     // Events
1178     event Recovered(address token, uint256 amount);
1179     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1180     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1181     event EmergencyWithdraw(
1182         address indexed user,
1183         uint256 indexed pid,
1184         uint256 amount
1185     );
1186     event BuybackMM(uint256 _buybackAmount, uint256 _preAmount);
1187 
1188     constructor(
1189         MMToken _mm,
1190         address _devaddr,
1191         address _treasuryAddr,
1192         uint256 _mmPerBlock,
1193         uint256 _startBlock,
1194         uint256 _bonusEndBlock
1195     ) public {
1196         mm = _mm;
1197         devaddr = _devaddr;
1198         treasuryAddr = _treasuryAddr;
1199         mmPerBlock = _mmPerBlock;
1200         bonusEndBlock = _bonusEndBlock;
1201         startBlock = _startBlock;
1202     }
1203 
1204     function poolLength() external view returns (uint256) {
1205         return poolInfo.length;
1206     }
1207 
1208     // Add a new lp to the pool. Can only be called by the owner.
1209     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1210     function add(
1211         uint256 _allocPoint,
1212         IERC20 _lpToken,
1213         bool _withUpdate
1214     ) public onlyOwner {
1215         if (_withUpdate) {
1216             massUpdatePools();
1217         }
1218         uint256 lastRewardBlock = block.number > startBlock
1219             ? block.number
1220             : startBlock;
1221         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1222         poolInfo.push(
1223             PoolInfo({
1224                 lpToken: _lpToken,
1225                 allocPoint: _allocPoint,
1226                 lastRewardBlock: lastRewardBlock,
1227                 accMMPerShare: 0,
1228                 amount: 0
1229             })
1230         );
1231     }
1232 
1233     // Update the given pool's MM allocation point. Can only be called by the owner.
1234     function set(
1235         uint256 _pid,
1236         uint256 _allocPoint,
1237         bool _withUpdate
1238     ) public onlyOwner {
1239         if (_withUpdate) {
1240             massUpdatePools();
1241         }
1242         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1243             _allocPoint
1244         );
1245         poolInfo[_pid].allocPoint = _allocPoint;
1246     }
1247 
1248     // Return reward multiplier over the given _from to _to block.
1249     function getMultiplier(uint256 _from, uint256 _to)
1250         public
1251         view
1252         returns (uint256)
1253     {
1254         if (_to <= bonusEndBlock) {
1255             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1256         } else if (_from >= bonusEndBlock) {
1257             return _to.sub(_from);
1258         } else {
1259             return
1260                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1261                     _to.sub(bonusEndBlock)
1262                 );
1263         }
1264     }
1265 
1266     // View function to see pending MMs on frontend.
1267     function pendingMM(uint256 _pid, address _user)
1268         external
1269         view
1270         returns (uint256)
1271     {
1272         PoolInfo storage pool = poolInfo[_pid];
1273         UserInfo storage user = userInfo[_pid][_user];
1274         uint256 accMMPerShare = pool.accMMPerShare;
1275         uint256 lpSupply = getLpSupply(_pid);
1276         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1277             uint256 multiplier = getMultiplier(
1278                 pool.lastRewardBlock,
1279                 block.number
1280             );
1281             uint256 mmReward = multiplier
1282                 .mul(mmPerBlock)
1283                 .mul(pool.allocPoint)
1284                 .div(totalAllocPoint);
1285             accMMPerShare = accMMPerShare.add(mmReward.mul(1e12).div(lpSupply));
1286         }
1287         return user.amount.mul(accMMPerShare).div(1e12).sub(user.rewardDebt);
1288     }
1289 
1290     // Update reward vairables for all pools. Be careful of gas spending!
1291     function massUpdatePools() public {
1292         uint256 length = poolInfo.length;
1293         for (uint256 pid = 0; pid < length; ++pid) {
1294             updatePool(pid);
1295         }
1296     }
1297 	
1298     // return Lp supply of given pool
1299     function getLpSupply(uint256 _pid) public view returns (uint256) {	
1300         PoolInfo storage pool = poolInfo[_pid];
1301         uint256 lpSupply = 0;
1302         if (_pid == mmPoolId) {
1303             lpSupply = pool.amount;
1304         } else {
1305             lpSupply = pool.lpToken.balanceOf(address(this));
1306         }
1307         return lpSupply;
1308     }
1309 	
1310     // update the pool's `accMMPerShare`
1311     function updateAccMMPerShare(uint256 _pid, uint256 _delta, uint256 lpSupply) internal {
1312         PoolInfo storage pool = poolInfo[_pid];
1313         pool.accMMPerShare = pool.accMMPerShare.add(_delta.mul(1e12).div(lpSupply));
1314     }
1315 	
1316     // Update MM staking pool with given _amount reward received from buyback.
1317     function notifyBuybackReward(uint256 _amount) external {
1318         require(buybackNotifiers[msg.sender] == true, "!buybackNotifier");
1319         require(_amount > 0 && _amount < mm.totalSupply(), "!_amount");	
1320 		
1321         PoolInfo storage pool = poolInfo[mmPoolId];	
1322         require(pool.amount > 0, "!mmPoolActivated");
1323         
1324         updateAccMMPerShare(mmPoolId, _amount, pool.amount);
1325         emit BuybackMM(_amount, pool.amount);
1326     }
1327 
1328     // Update reward variables of the given pool to be up-to-date.
1329     function updatePool(uint256 _pid) public {
1330         PoolInfo storage pool = poolInfo[_pid];
1331         if (block.number <= pool.lastRewardBlock) {
1332             return;
1333         }
1334         uint256 lpSupply = getLpSupply(_pid);
1335         if (lpSupply == 0) {
1336             pool.lastRewardBlock = block.number;
1337             return;
1338         }
1339         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1340         uint256 mmReward = multiplier
1341             .mul(mmPerBlock)
1342             .mul(pool.allocPoint)
1343             .div(totalAllocPoint);
1344         updateAccMMPerShare(_pid, mmReward, lpSupply);	
1345         mm.mint(devaddr, mmReward.div(devFundDivRate).mul(devMultiplier));	
1346         mm.mint(treasuryAddr, mmReward.div(treasuryDivRate).mul(treasuryMultiplier));
1347         mm.mint(address(this), mmReward);
1348         pool.lastRewardBlock = block.number;
1349     }
1350 
1351     // Deposit LP tokens to MasterChef for MM allocation.
1352     function deposit(uint256 _pid, uint256 _amount) public {
1353         PoolInfo storage pool = poolInfo[_pid];
1354         UserInfo storage user = userInfo[_pid][msg.sender];
1355         updatePool(_pid);
1356         if (user.amount > 0) {
1357             uint256 pending = user
1358                 .amount
1359                 .mul(pool.accMMPerShare)
1360                 .div(1e12)
1361                 .sub(user.rewardDebt);
1362             safeMMTransfer(msg.sender, pending);
1363         }
1364         pool.lpToken.safeTransferFrom(
1365             address(msg.sender),
1366             address(this),
1367             _amount
1368         );
1369         user.amount = user.amount.add(_amount);
1370         pool.amount = pool.amount.add(_amount);
1371         user.rewardDebt = user.amount.mul(pool.accMMPerShare).div(1e12);
1372         emit Deposit(msg.sender, _pid, _amount);
1373     }
1374 
1375     // Withdraw LP tokens from MasterChef.
1376     function withdraw(uint256 _pid, uint256 _amount) public {
1377         PoolInfo storage pool = poolInfo[_pid];
1378         UserInfo storage user = userInfo[_pid][msg.sender];
1379         require(user.amount >= _amount, "withdraw: not good");
1380         updatePool(_pid);
1381         uint256 pending = user.amount.mul(pool.accMMPerShare).div(1e12).sub(
1382             user.rewardDebt
1383         );
1384         safeMMTransfer(msg.sender, pending);
1385         user.amount = user.amount.sub(_amount);
1386         pool.amount = pool.amount.sub(_amount);
1387         user.rewardDebt = user.amount.mul(pool.accMMPerShare).div(1e12);
1388         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1389         emit Withdraw(msg.sender, _pid, _amount);
1390     }
1391 
1392     // Withdraw without caring about rewards. EMERGENCY ONLY.
1393     function emergencyWithdraw(uint256 _pid) public {
1394         PoolInfo storage pool = poolInfo[_pid];
1395         UserInfo storage user = userInfo[_pid][msg.sender];
1396         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1397         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1398         pool.amount = pool.amount.sub(user.amount);
1399         user.amount = 0;
1400         user.rewardDebt = 0;
1401     }
1402 
1403     // Safe mm transfer function, just in case if rounding error causes pool to not have enough MMs.
1404     function safeMMTransfer(address _to, uint256 _amount) internal {
1405         uint256 mmBal = mm.balanceOf(address(this));
1406         if (_amount > mmBal) {
1407             mm.transfer(_to, mmBal);
1408         } else {
1409             mm.transfer(_to, _amount);
1410         }
1411     }
1412 
1413     // Update dev address by the previous dev.
1414     function dev(address _devaddr) public {
1415         require(msg.sender == devaddr, "dev: wut?");
1416         devaddr = _devaddr;
1417     }
1418 
1419     // Update treasury address by the previous treasury.
1420     function setTreasury(address _treasuryAddr) public {
1421         require(msg.sender == treasuryAddr, "treasury: wut?");
1422         treasuryAddr = _treasuryAddr;
1423     }
1424 
1425     // **** Additional functions separate from the original masterchef contract ****
1426 
1427     function setMMPerBlock(uint256 _mmPerBlock) public onlyOwner {
1428         require(_mmPerBlock > 0, "!mmPerBlock-0");
1429 
1430         mmPerBlock = _mmPerBlock;
1431     }
1432 
1433     function setBonusEndBlock(uint256 _bonusEndBlock) public onlyOwner {
1434         bonusEndBlock = _bonusEndBlock;
1435     }
1436 
1437     function setDevFundDivRate(uint256 _devFundDivRate) public onlyOwner {
1438         require(_devFundDivRate > 0, "!devFundDivRate-0");
1439         devFundDivRate = _devFundDivRate;
1440     }
1441 
1442     function setTreasuryDivRate(uint256 _treasuryDivRate) public onlyOwner {
1443         require(_treasuryDivRate > 0, "!treasuryDivRate-0");
1444         treasuryDivRate = _treasuryDivRate;
1445     }
1446 	
1447     function setDevMultiplier(uint256 _devMultiplier) public onlyOwner {
1448         require(_devMultiplier > 0, "!devMultiplier-0");
1449         devMultiplier = _devMultiplier;
1450     }
1451 
1452     function setTreasuryMultiplier(uint256 _treasuryMultiplier) public onlyOwner {
1453         require(_treasuryMultiplier > 0, "!treasuryMultiplier-0");
1454         treasuryMultiplier = _treasuryMultiplier;
1455     }
1456 
1457     function setBuybackNotifier(address _notifier, bool _enable) public onlyOwner {
1458         require(_notifier != address(0), "!invalid-notifier");
1459         buybackNotifiers[_notifier] = _enable;
1460     }
1461 	
1462     // in case we need to migrate to new MM owner
1463     function transferMMOwnership() public onlyOwner {
1464         require(mm.owner() == address(this), "!notMMOwner");
1465         mm.transferOwnership(owner());
1466     }
1467 }