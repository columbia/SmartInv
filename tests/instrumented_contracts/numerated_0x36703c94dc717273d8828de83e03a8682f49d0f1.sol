1 //SPDX-License-Identifier: MIT 
2 pragma solidity 0.6.11; 
3 pragma experimental ABIEncoderV2;
4 
5 // ====================================================================
6 //     ________                   _______                           
7 //    / ____/ /__  ____  ____ _  / ____(_)___  ____ _____  ________ 
8 //   / __/ / / _ \/ __ \/ __ `/ / /_  / / __ \/ __ `/ __ \/ ___/ _ \
9 //  / /___/ /  __/ / / / /_/ / / __/ / / / / / /_/ / / / / /__/  __/
10 // /_____/_/\___/_/ /_/\__,_(_)_/   /_/_/ /_/\__,_/_/ /_/\___/\___/                                                                                                                     
11 //                                                                        
12 // ====================================================================
13 // ====================== Elena Protocol (USE) ========================
14 // ====================================================================
15 
16 // Dapp    :  https://elena.finance
17 // Twitter :  https://twitter.com/ElenaProtocol
18 // Telegram:  https://t.me/ElenaFinance
19 // ====================================================================
20 
21 // File: contracts\@openzeppelin\contracts\math\SafeMath.sol
22 // License: MIT
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations with added overflow
26  * checks.
27  *
28  * Arithmetic operations in Solidity wrap on overflow. This can easily result
29  * in bugs, because programmers usually assume that an overflow raises an
30  * error, which is the standard behavior in high level programming languages.
31  * `SafeMath` restores this intuition by reverting the transaction when an
32  * operation overflows.
33  *
34  * Using this library instead of the unchecked operations eliminates an entire
35  * class of bugs, so it's recommended to use it always.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, reverting on
40      * overflow.
41      *
42      * Counterpart to Solidity's `+` operator.
43      *
44      * Requirements:
45      *
46      * - Addition cannot overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      *
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79         return c;
80     }
81     /**
82      * @dev Returns the multiplication of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `*` operator.
86      *
87      * Requirements:
88      *
89      * - Multiplication cannot overflow.
90      */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
95         if (a == 0) {
96             return 0;
97         }
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100         return c;
101     }
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      *
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133         return c;
134     }
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, "SafeMath: modulo by zero");
149     }
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts with custom message when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b != 0, errorMessage);
164         return a % b;
165     }
166 }
167 
168 // File: contracts\@openzeppelin\contracts\token\ERC20\IERC20.sol
169 // License: MIT
170 
171 /**
172  * @dev Interface of the ERC20 standard as defined in the EIP.
173  */
174 interface IERC20 {
175     /**
176      * @dev Returns the amount of tokens in existence.
177      */
178     function totalSupply() external view returns (uint256);
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191     /**
192      * @dev Returns the remaining number of tokens that `spender` will be
193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
194      * zero by default.
195      *
196      * This value changes when {approve} or {transferFrom} are called.
197      */
198     function allowance(address owner, address spender) external view returns (uint256);
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214     /**
215      * @dev Moves `amount` tokens from `sender` to `recipient` using the
216      * allowance mechanism. `amount` is then deducted from the caller's
217      * allowance.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231     /**
232      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
233      * a call to {approve}. `value` is the new allowance.
234      */
235     event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 // File: contracts\@openzeppelin\contracts\utils\EnumerableSet.sol
239 // License: MIT
240 
241 /**
242  * @dev Library for managing
243  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
244  * types.
245  *
246  * Sets have the following properties:
247  *
248  * - Elements are added, removed, and checked for existence in constant time
249  * (O(1)).
250  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
251  *
252  * ```
253  * contract Example {
254  *     // Add the library methods
255  *     using EnumerableSet for EnumerableSet.AddressSet;
256  *
257  *     // Declare a set state variable
258  *     EnumerableSet.AddressSet private mySet;
259  * }
260  * ```
261  *
262  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
263  * (`UintSet`) are supported.
264  */
265 library EnumerableSet {
266     // To implement this library for multiple types with as little code
267     // repetition as possible, we write it in terms of a generic Set type with
268     // bytes32 values.
269     // The Set implementation uses private functions, and user-facing
270     // implementations (such as AddressSet) are just wrappers around the
271     // underlying Set.
272     // This means that we can only create new EnumerableSets for types that fit
273     // in bytes32.
274     struct Set {
275         // Storage of set values
276         bytes32[] _values;
277         // Position of the value in the `values` array, plus 1 because index 0
278         // means a value is not in the set.
279         mapping (bytes32 => uint256) _indexes;
280     }
281     /**
282      * @dev Add a value to a set. O(1).
283      *
284      * Returns true if the value was added to the set, that is if it was not
285      * already present.
286      */
287     function _add(Set storage set, bytes32 value) private returns (bool) {
288         if (!_contains(set, value)) {
289             set._values.push(value);
290             // The value is stored at length-1, but we add 1 to all indexes
291             // and use 0 as a sentinel value
292             set._indexes[value] = set._values.length;
293             return true;
294         } else {
295             return false;
296         }
297     }
298     /**
299      * @dev Removes a value from a set. O(1).
300      *
301      * Returns true if the value was removed from the set, that is if it was
302      * present.
303      */
304     function _remove(Set storage set, bytes32 value) private returns (bool) {
305         // We read and store the value's index to prevent multiple reads from the same storage slot
306         uint256 valueIndex = set._indexes[value];
307         if (valueIndex != 0) { // Equivalent to contains(set, value)
308             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
309             // the array, and then remove the last element (sometimes called as 'swap and pop').
310             // This modifies the order of the array, as noted in {at}.
311             uint256 toDeleteIndex = valueIndex - 1;
312             uint256 lastIndex = set._values.length - 1;
313             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
314             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
315             bytes32 lastvalue = set._values[lastIndex];
316             // Move the last value to the index where the value to delete is
317             set._values[toDeleteIndex] = lastvalue;
318             // Update the index for the moved value
319             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
320             // Delete the slot where the moved value was stored
321             set._values.pop();
322             // Delete the index for the deleted slot
323             delete set._indexes[value];
324             return true;
325         } else {
326             return false;
327         }
328     }
329     /**
330      * @dev Returns true if the value is in the set. O(1).
331      */
332     function _contains(Set storage set, bytes32 value) private view returns (bool) {
333         return set._indexes[value] != 0;
334     }
335     /**
336      * @dev Returns the number of values on the set. O(1).
337      */
338     function _length(Set storage set) private view returns (uint256) {
339         return set._values.length;
340     }
341    /**
342     * @dev Returns the value stored at position `index` in the set. O(1).
343     *
344     * Note that there are no guarantees on the ordering of values inside the
345     * array, and it may change when more values are added or removed.
346     *
347     * Requirements:
348     *
349     * - `index` must be strictly less than {length}.
350     */
351     function _at(Set storage set, uint256 index) private view returns (bytes32) {
352         require(set._values.length > index, "EnumerableSet: index out of bounds");
353         return set._values[index];
354     }
355     // AddressSet
356     struct AddressSet {
357         Set _inner;
358     }
359     /**
360      * @dev Add a value to a set. O(1).
361      *
362      * Returns true if the value was added to the set, that is if it was not
363      * already present.
364      */
365     function add(AddressSet storage set, address value) internal returns (bool) {
366         return _add(set._inner, bytes32(uint256(value)));
367     }
368     /**
369      * @dev Removes a value from a set. O(1).
370      *
371      * Returns true if the value was removed from the set, that is if it was
372      * present.
373      */
374     function remove(AddressSet storage set, address value) internal returns (bool) {
375         return _remove(set._inner, bytes32(uint256(value)));
376     }
377     /**
378      * @dev Returns true if the value is in the set. O(1).
379      */
380     function contains(AddressSet storage set, address value) internal view returns (bool) {
381         return _contains(set._inner, bytes32(uint256(value)));
382     }
383     /**
384      * @dev Returns the number of values in the set. O(1).
385      */
386     function length(AddressSet storage set) internal view returns (uint256) {
387         return _length(set._inner);
388     }
389    /**
390     * @dev Returns the value stored at position `index` in the set. O(1).
391     *
392     * Note that there are no guarantees on the ordering of values inside the
393     * array, and it may change when more values are added or removed.
394     *
395     * Requirements:
396     *
397     * - `index` must be strictly less than {length}.
398     */
399     function at(AddressSet storage set, uint256 index) internal view returns (address) {
400         return address(uint256(_at(set._inner, index)));
401     }
402     // UintSet
403     struct UintSet {
404         Set _inner;
405     }
406     /**
407      * @dev Add a value to a set. O(1).
408      *
409      * Returns true if the value was added to the set, that is if it was not
410      * already present.
411      */
412     function add(UintSet storage set, uint256 value) internal returns (bool) {
413         return _add(set._inner, bytes32(value));
414     }
415     /**
416      * @dev Removes a value from a set. O(1).
417      *
418      * Returns true if the value was removed from the set, that is if it was
419      * present.
420      */
421     function remove(UintSet storage set, uint256 value) internal returns (bool) {
422         return _remove(set._inner, bytes32(value));
423     }
424     /**
425      * @dev Returns true if the value is in the set. O(1).
426      */
427     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
428         return _contains(set._inner, bytes32(value));
429     }
430     /**
431      * @dev Returns the number of values on the set. O(1).
432      */
433     function length(UintSet storage set) internal view returns (uint256) {
434         return _length(set._inner);
435     }
436    /**
437     * @dev Returns the value stored at position `index` in the set. O(1).
438     *
439     * Note that there are no guarantees on the ordering of values inside the
440     * array, and it may change when more values are added or removed.
441     *
442     * Requirements:
443     *
444     * - `index` must be strictly less than {length}.
445     */
446     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
447         return uint256(_at(set._inner, index));
448     }
449 }
450 
451 // File: contracts\@openzeppelin\contracts\utils\Address.sol
452 // License: MIT
453 
454 /**
455  * @dev Collection of functions related to the address type
456  */
457 library Address {
458     /**
459      * @dev Returns true if `account` is a contract.
460      *
461      * [IMPORTANT]
462      * ====
463      * It is unsafe to assume that an address for which this function returns
464      * false is an externally-owned account (EOA) and not a contract.
465      *
466      * Among others, `isContract` will return false for the following
467      * types of addresses:
468      *
469      *  - an externally-owned account
470      *  - a contract in construction
471      *  - an address where a contract will be created
472      *  - an address where a contract lived, but was destroyed
473      * ====
474      */
475     function isContract(address account) internal view returns (bool) {
476         // This method relies in extcodesize, which returns 0 for contracts in
477         // construction, since the code is only stored at the end of the
478         // constructor execution.
479         uint256 size;
480         // solhint-disable-next-line no-inline-assembly
481         assembly { size := extcodesize(account) }
482         return size > 0;
483     }
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
503         (bool success, ) = recipient.call{ value: amount }("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506     /**
507      * @dev Performs a Solidity function call using a low level `call`. A
508      * plain`call` is an unsafe replacement for a function call: use this
509      * function instead.
510      *
511      * If `target` reverts with a revert reason, it is bubbled up by this
512      * function (like regular Solidity function calls).
513      *
514      * Returns the raw returned data. To convert to the expected return value,
515      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
516      *
517      * Requirements:
518      *
519      * - `target` must be a contract.
520      * - calling `target` with `data` must not revert.
521      *
522      * _Available since v3.1._
523      */
524     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
525       return functionCall(target, data, "Address: low-level call failed");
526     }
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
529      * `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
534         return _functionCallWithValue(target, data, 0, errorMessage);
535     }
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but also transferring `value` wei to `target`.
539      *
540      * Requirements:
541      *
542      * - the calling contract must have an ETH balance of at least `value`.
543      * - the called Solidity function must be `payable`.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
548         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
549     }
550     /**
551      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
552      * with `errorMessage` as a fallback revert reason when `target` reverts.
553      *
554      * _Available since v3.1._
555      */
556     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
557         require(address(this).balance >= value, "Address: insufficient balance for call");
558         return _functionCallWithValue(target, data, value, errorMessage);
559     }
560     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
561         require(isContract(target), "Address: call to non-contract");
562         // solhint-disable-next-line avoid-low-level-calls
563         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
564         if (success) {
565             return returndata;
566         } else {
567             // Look for revert reason and bubble it up if present
568             if (returndata.length > 0) {
569                 // The easiest way to bubble the revert reason is using memory via assembly
570                 // solhint-disable-next-line no-inline-assembly
571                 assembly {
572                     let returndata_size := mload(returndata)
573                     revert(add(32, returndata), returndata_size)
574                 }
575             } else {
576                 revert(errorMessage);
577             }
578         }
579     }
580 }
581 
582 // File: contracts\@openzeppelin\contracts\GSN\Context.sol
583 // License: MIT
584 
585 /*
586  * @dev Provides information about the current execution context, including the
587  * sender of the transaction and its data. While these are generally available
588  * via msg.sender and msg.data, they should not be accessed in such a direct
589  * manner, since when dealing with GSN meta-transactions the account sending and
590  * paying for execution may not be the actual sender (as far as an application
591  * is concerned).
592  *
593  * This contract is only required for intermediate, library-like contracts.
594  */
595 abstract contract Context {
596     function _msgSender() internal view virtual returns (address payable) {
597         return msg.sender;
598     }
599     function _msgData() internal view virtual returns (bytes memory) {
600         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
601         return msg.data;
602     }
603 }
604 
605 // File: contracts\@openzeppelin\contracts\access\AccessControl.sol
606 // License: MIT
607 
608 
609 
610 
611 /**
612  * @dev Contract module that allows children to implement role-based access
613  * control mechanisms.
614  *
615  * Roles are referred to by their `bytes32` identifier. These should be exposed
616  * in the external API and be unique. The best way to achieve this is by
617  * using `public constant` hash digests:
618  *
619  * ```
620  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
621  * ```
622  *
623  * Roles can be used to represent a set of permissions. To restrict access to a
624  * function call, use {hasRole}:
625  *
626  * ```
627  * function foo() public {
628  *     require(hasRole(MY_ROLE, msg.sender));
629  *     ...
630  * }
631  * ```
632  *
633  * Roles can be granted and revoked dynamically via the {grantRole} and
634  * {revokeRole} functions. Each role has an associated admin role, and only
635  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
636  *
637  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
638  * that only accounts with this role will be able to grant or revoke other
639  * roles. More complex role relationships can be created by using
640  * {_setRoleAdmin}.
641  *
642  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
643  * grant and revoke this role. Extra precautions should be taken to secure
644  * accounts that have been granted it.
645  */
646 abstract contract AccessControl is Context {
647     using EnumerableSet for EnumerableSet.AddressSet;
648     using Address for address;
649     struct RoleData {
650         EnumerableSet.AddressSet members;
651         bytes32 adminRole;
652     }
653     mapping (bytes32 => RoleData) private _roles;
654     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
655     /**
656      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
657      *
658      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
659      * {RoleAdminChanged} not being emitted signaling this.
660      *
661      * _Available since v3.1._
662      */
663     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
664     /**
665      * @dev Emitted when `account` is granted `role`.
666      *
667      * `sender` is the account that originated the contract call, an admin role
668      * bearer except when using {_setupRole}.
669      */
670     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
671     /**
672      * @dev Emitted when `account` is revoked `role`.
673      *
674      * `sender` is the account that originated the contract call:
675      *   - if using `revokeRole`, it is the admin role bearer
676      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
677      */
678     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
679     /**
680      * @dev Returns `true` if `account` has been granted `role`.
681      */
682     function hasRole(bytes32 role, address account) public view returns (bool) {
683         return _roles[role].members.contains(account);
684     }
685     /**
686      * @dev Returns the number of accounts that have `role`. Can be used
687      * together with {getRoleMember} to enumerate all bearers of a role.
688      */
689     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
690         return _roles[role].members.length();
691     }
692     /**
693      * @dev Returns one of the accounts that have `role`. `index` must be a
694      * value between 0 and {getRoleMemberCount}, non-inclusive.
695      *
696      * Role bearers are not sorted in any particular way, and their ordering may
697      * change at any point.
698      *
699      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
700      * you perform all queries on the same block. See the following
701      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
702      * for more information.
703      */
704     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
705         return _roles[role].members.at(index);
706     }
707     /**
708      * @dev Returns the admin role that controls `role`. See {grantRole} and
709      * {revokeRole}.
710      *
711      * To change a role's admin, use {_setRoleAdmin}.
712      */
713     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
714         return _roles[role].adminRole;
715     }
716     /**
717      * @dev Grants `role` to `account`.
718      *
719      * If `account` had not been already granted `role`, emits a {RoleGranted}
720      * event.
721      *
722      * Requirements:
723      *
724      * - the caller must have ``role``'s admin role.
725      */
726     function grantRole(bytes32 role, address account) public virtual {
727         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
728         _grantRole(role, account);
729     }
730     /**
731      * @dev Revokes `role` from `account`.
732      *
733      * If `account` had been granted `role`, emits a {RoleRevoked} event.
734      *
735      * Requirements:
736      *
737      * - the caller must have ``role``'s admin role.
738      */
739     function revokeRole(bytes32 role, address account) public virtual {
740         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
741         _revokeRole(role, account);
742     }
743     /**
744      * @dev Revokes `role` from the calling account.
745      *
746      * Roles are often managed via {grantRole} and {revokeRole}: this function's
747      * purpose is to provide a mechanism for accounts to lose their privileges
748      * if they are compromised (such as when a trusted device is misplaced).
749      *
750      * If the calling account had been granted `role`, emits a {RoleRevoked}
751      * event.
752      *
753      * Requirements:
754      *
755      * - the caller must be `account`.
756      */
757     function renounceRole(bytes32 role, address account) public virtual {
758         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
759         _revokeRole(role, account);
760     }
761     /**
762      * @dev Grants `role` to `account`.
763      *
764      * If `account` had not been already granted `role`, emits a {RoleGranted}
765      * event. Note that unlike {grantRole}, this function doesn't perform any
766      * checks on the calling account.
767      *
768      * [WARNING]
769      * ====
770      * This function should only be called from the constructor when setting
771      * up the initial roles for the system.
772      *
773      * Using this function in any other way is effectively circumventing the admin
774      * system imposed by {AccessControl}.
775      * ====
776      */
777     function _setupRole(bytes32 role, address account) internal virtual {
778         _grantRole(role, account);
779     }
780     /**
781      * @dev Sets `adminRole` as ``role``'s admin role.
782      *
783      * Emits a {RoleAdminChanged} event.
784      */
785     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
786         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
787         _roles[role].adminRole = adminRole;
788     }
789     function _grantRole(bytes32 role, address account) private {
790         if (_roles[role].members.add(account)) {
791             emit RoleGranted(role, account, _msgSender());
792         }
793     }
794     function _revokeRole(bytes32 role, address account) private {
795         if (_roles[role].members.remove(account)) {
796             emit RoleRevoked(role, account, _msgSender());
797         }
798     }
799 }
800 
801 // File: contracts\Common\ContractGuard.sol
802 // License: MIT
803 
804 contract ContractGuard {
805     mapping(uint256 => mapping(address => bool)) private _status;
806     function checkSameOriginReentranted() internal view returns (bool) {
807         return _status[block.number][tx.origin];
808     }
809     function checkSameSenderReentranted() internal view returns (bool) {
810         return _status[block.number][msg.sender];
811     }
812     modifier onlyOneBlock() {
813         require(
814             !checkSameOriginReentranted(),
815             'ContractGuard: one block, one function'
816         );
817         require(
818             !checkSameSenderReentranted(),
819             'ContractGuard: one block, one function'
820         );
821         _;
822         _status[block.number][tx.origin] = true;
823         _status[block.number][msg.sender] = true;
824     }
825 }
826 
827 // File: contracts\Common\IERC20Detail.sol
828 // License: MIT
829 
830 
831 interface IERC20Detail is IERC20 {
832     function decimals() external view returns (uint8);
833 }
834 
835 // File: contracts\Share\IShareToken.sol
836 // License: MIT
837 
838 
839 
840 interface IShareToken is IERC20 {  
841     function pool_mint(address m_address, uint256 m_amount) external; 
842     function pool_burn_from(address b_address, uint256 b_amount) external; 
843     function burn(uint256 amount) external;
844 }
845 
846 // File: contracts\Oracle\IUniswapPairOracle.sol
847 // License: MIT
848 
849 // Fixed window oracle that recomputes the average price for the entire period once every period
850 // Note that the price average is only guaranteed to be over at least 1 period, but may be over a longer period
851 interface IUniswapPairOracle { 
852     function getPairToken(address token) external view returns(address);
853     function containsToken(address token) external view returns(bool);
854     function getSwapTokenReserve(address token) external view returns(uint256);
855     function update() external returns(bool);
856     // Note this will always return 0 before update has been called successfully for the first time.
857     function consult(address token, uint amountIn) external view returns (uint amountOut);
858 }
859 
860 // File: contracts\USE\IUSEStablecoin.sol
861 // License: MIT
862 
863 
864 interface IUSEStablecoin {
865     function totalSupply() external view returns (uint256);
866     function balanceOf(address account) external view returns (uint256);
867     function transfer(address recipient, uint256 amount) external returns (bool);
868     function allowance(address owner, address spender) external view returns (uint256);
869     function approve(address spender, uint256 amount) external returns (bool);
870     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
871     function owner_address() external returns (address);
872     function creator_address() external returns (address);
873     function timelock_address() external returns (address); 
874     function genesis_supply() external returns (uint256); 
875     function refresh_cooldown() external returns (uint256);
876     function price_target() external returns (uint256);
877     function price_band() external returns (uint256);
878     function DEFAULT_ADMIN_ADDRESS() external returns (address);
879     function COLLATERAL_RATIO_PAUSER() external returns (bytes32);
880     function collateral_ratio_paused() external returns (bool);
881     function last_call_time() external returns (uint256);
882     function USEDAIOracle() external returns (IUniswapPairOracle);
883     function USESharesOracle() external returns (IUniswapPairOracle); 
884     /* ========== VIEWS ========== */
885     function use_pools(address a) external view returns (bool);
886     function global_collateral_ratio() external view returns (uint256);
887     function use_price() external view returns (uint256);
888     function share_price()  external view returns (uint256);
889     function share_price_in_use()  external view returns (uint256); 
890     function globalCollateralValue() external view returns (uint256);
891     /* ========== PUBLIC FUNCTIONS ========== */
892     function refreshCollateralRatio() external;
893     function swapCollateralAmount() external view returns(uint256);
894     function pool_mint(address m_address, uint256 m_amount) external;
895     function pool_burn_from(address b_address, uint256 b_amount) external;
896     function burn(uint256 amount) external;
897 }
898 
899 // File: contracts\USE\Pools\USEPoolAlgo.sol
900 // License: MIT
901 
902 
903 
904 contract USEPoolAlgo {
905     using SafeMath for uint256;
906     // Constants for various precisions
907     uint256 public constant PRICE_PRECISION = 1e6;
908     uint256 public constant COLLATERAL_RATIO_PRECISION = 1e6;
909     // ================ Structs ================
910     // Needed to lower stack size
911     struct MintFU_Params {
912         uint256 shares_price_usd; 
913         uint256 col_price_usd;
914         uint256 shares_amount;
915         uint256 collateral_amount;
916         uint256 col_ratio;
917     }
918     struct BuybackShares_Params {
919         uint256 excess_collateral_dollar_value_d18;
920         uint256 shares_price_usd;
921         uint256 col_price_usd;
922         uint256 shares_amount;
923     }
924     // ================ Functions ================
925     function calcMint1t1USE(uint256 col_price, uint256 collateral_amount_d18) public pure returns (uint256) {
926         return (collateral_amount_d18.mul(col_price)).div(1e6);
927     } 
928     // Must be internal because of the struct
929     function calcMintFractionalUSE(MintFU_Params memory params) public pure returns (uint256,uint256, uint256) {
930           (uint256 mint_amount1, uint256 collateral_need_d18_1, uint256 shares_needed1) = calcMintFractionalWithCollateral(params);
931           (uint256 mint_amount2, uint256 collateral_need_d18_2, uint256 shares_needed2) = calcMintFractionalWithShare(params);
932           if(mint_amount1 > mint_amount2){
933               return (mint_amount2,collateral_need_d18_2,shares_needed2);
934           }else{
935               return (mint_amount1,collateral_need_d18_1,shares_needed1);
936           }
937     }
938     // Must be internal because of the struct
939     function calcMintFractionalWithCollateral(MintFU_Params memory params) public pure returns (uint256,uint256, uint256) {
940         // Since solidity truncates division, every division operation must be the last operation in the equation to ensure minimum error
941         // The contract must check the proper ratio was sent to mint USE. We do this by seeing the minimum mintable USE based on each amount 
942         uint256 c_dollar_value_d18_with_precision = params.collateral_amount.mul(params.col_price_usd);
943         uint256 c_dollar_value_d18 = c_dollar_value_d18_with_precision.div(1e6); 
944         uint calculated_shares_dollar_value_d18 = 
945                     (c_dollar_value_d18_with_precision.div(params.col_ratio))
946                     .sub(c_dollar_value_d18);
947         uint calculated_shares_needed = calculated_shares_dollar_value_d18.mul(1e6).div(params.shares_price_usd);
948         return (
949             c_dollar_value_d18.add(calculated_shares_dollar_value_d18),
950             params.collateral_amount,
951             calculated_shares_needed
952         );
953     }
954      // Must be internal because of the struct
955     function calcMintFractionalWithShare(MintFU_Params memory params) public pure returns (uint256,uint256, uint256) {
956         // Since solidity truncates division, every division operation must be the last operation in the equation to ensure minimum error
957         // The contract must check the proper ratio was sent to mint USE. We do this by seeing the minimum mintable USE based on each amount 
958         uint256 shares_dollar_value_d18_with_precision = params.shares_amount.mul(params.shares_price_usd);
959         uint256 shares_dollar_value_d18 = shares_dollar_value_d18_with_precision.div(1e6); 
960         uint calculated_collateral_dollar_value_d18 = 
961                     shares_dollar_value_d18_with_precision.mul(params.col_ratio)
962                     .div(COLLATERAL_RATIO_PRECISION.sub(params.col_ratio)).div(1e6); 
963         uint calculated_collateral_needed = calculated_collateral_dollar_value_d18.mul(1e6).div(params.col_price_usd);
964         return (
965             shares_dollar_value_d18.add(calculated_collateral_dollar_value_d18),
966             calculated_collateral_needed,
967             params.shares_amount
968         );
969     }
970     function calcRedeem1t1USE(uint256 col_price_usd, uint256 use_amount) public pure returns (uint256) {
971         return use_amount.mul(1e6).div(col_price_usd);
972     }
973     // Must be internal because of the struct
974     function calcBuyBackShares(BuybackShares_Params memory params) public pure returns (uint256) {
975         // If the total collateral value is higher than the amount required at the current collateral ratio then buy back up to the possible Shares with the desired collateral
976         require(params.excess_collateral_dollar_value_d18 > 0, "No excess collateral to buy back!");
977         // Make sure not to take more than is available
978         uint256 shares_dollar_value_d18 = params.shares_amount.mul(params.shares_price_usd).div(1e6);
979         require(shares_dollar_value_d18 <= params.excess_collateral_dollar_value_d18, "You are trying to buy back more than the excess!");
980         // Get the equivalent amount of collateral based on the market value of Shares provided 
981         uint256 collateral_equivalent_d18 = shares_dollar_value_d18.mul(1e6).div(params.col_price_usd);
982         //collateral_equivalent_d18 = collateral_equivalent_d18.sub((collateral_equivalent_d18.mul(params.buyback_fee)).div(1e6));
983         return (
984             collateral_equivalent_d18
985         );
986     }
987     // Returns value of collateral that must increase to reach recollateralization target (if 0 means no recollateralization)
988     function recollateralizeAmount(uint256 total_supply, uint256 global_collateral_ratio, uint256 global_collat_value) public pure returns (uint256) {
989         uint256 target_collat_value = total_supply.mul(global_collateral_ratio).div(1e6); // We want 18 decimals of precision so divide by 1e6; total_supply is 1e18 and global_collateral_ratio is 1e6
990         // Subtract the current value of collateral from the target value needed, if higher than 0 then system needs to recollateralize
991         return target_collat_value.sub(global_collat_value); // If recollateralization is not needed, throws a subtraction underflow
992         // return(recollateralization_left);
993     }
994     function calcRecollateralizeUSEInner(
995         uint256 collateral_amount, 
996         uint256 col_price,
997         uint256 global_collat_value,
998         uint256 frax_total_supply,
999         uint256 global_collateral_ratio
1000     ) public pure returns (uint256, uint256) {
1001         uint256 collat_value_attempted = collateral_amount.mul(col_price).div(1e6);
1002         uint256 effective_collateral_ratio = global_collat_value.mul(1e6).div(frax_total_supply); //returns it in 1e6
1003         uint256 recollat_possible = (global_collateral_ratio.mul(frax_total_supply).sub(frax_total_supply.mul(effective_collateral_ratio))).div(1e6);
1004         uint256 amount_to_recollat;
1005         if(collat_value_attempted <= recollat_possible){
1006             amount_to_recollat = collat_value_attempted;
1007         } else {
1008             amount_to_recollat = recollat_possible;
1009         }
1010         return (amount_to_recollat.mul(1e6).div(col_price), amount_to_recollat);
1011     }
1012 }
1013 
1014 // File: contracts\USE\Pools\USEPool.sol
1015 // License: MIT
1016 
1017 abstract contract USEPool is USEPoolAlgo,ContractGuard,AccessControl {
1018     using SafeMath for uint256;
1019     /* ========== STATE VARIABLES ========== */
1020     IERC20Detail public collateral_token;
1021     address public collateral_address;
1022     address public owner_address;
1023     address public community_address;
1024     address public use_contract_address;
1025     address public shares_contract_address;
1026     address public timelock_address;
1027     IShareToken private SHARE;
1028     IUSEStablecoin private USE; 
1029     uint256 public minting_tax_base;
1030     uint256 public minting_tax_multiplier; 
1031     uint256 public minting_required_reserve_ratio;
1032     uint256 public redemption_gcr_adj = PRECISION;   // PRECISION/PRECISION = 1
1033     uint256 public redemption_tax_base;
1034     uint256 public redemption_tax_multiplier;
1035     uint256 public redemption_tax_exponent;
1036     uint256 public redemption_required_reserve_ratio = 800000;
1037     uint256 public buyback_tax;
1038     uint256 public recollat_tax;
1039     uint256 public community_rate_ratio = 15000;
1040     uint256 public community_rate_in_use;
1041     uint256 public community_rate_in_share;
1042     mapping (address => uint256) public redeemSharesBalances;
1043     mapping (address => uint256) public redeemCollateralBalances;
1044     uint256 public unclaimedPoolCollateral;
1045     uint256 public unclaimedPoolShares;
1046     mapping (address => uint256) public lastRedeemed;
1047     // Constants for various precisions
1048     uint256 public constant PRECISION = 1e6;  
1049     uint256 public constant RESERVE_RATIO_PRECISION = 1e6;    
1050     uint256 public constant COLLATERAL_RATIO_MAX = 1e6;
1051     // Number of decimals needed to get to 18
1052     uint256 public immutable missing_decimals;
1053     // Pool_ceiling is the total units of collateral that a pool contract can hold
1054     uint256 public pool_ceiling = 10000000000e18;
1055     // Stores price of the collateral, if price is paused
1056     uint256 public pausedPrice = 0;
1057     // Bonus rate on Shares minted during recollateralizeUSE(); 6 decimals of precision, set to 0.5% on genesis
1058     uint256 public bonus_rate = 5000;
1059     // Number of blocks to wait before being able to collectRedemption()
1060     uint256 public redemption_delay = 2;
1061     uint256 public global_use_supply_adj = 1000e18;  //genesis_supply
1062     // AccessControl Roles
1063     bytes32 public constant MINT_PAUSER = keccak256("MINT_PAUSER");
1064     bytes32 public constant REDEEM_PAUSER = keccak256("REDEEM_PAUSER");
1065     bytes32 public constant BUYBACK_PAUSER = keccak256("BUYBACK_PAUSER");
1066     bytes32 public constant RECOLLATERALIZE_PAUSER = keccak256("RECOLLATERALIZE_PAUSER");
1067     bytes32 public constant COLLATERAL_PRICE_PAUSER = keccak256("COLLATERAL_PRICE_PAUSER");
1068     bytes32 public constant COMMUNITY_RATER = keccak256("COMMUNITY_RATER");
1069     // AccessControl state variables
1070     bool public mintPaused = false;
1071     bool public redeemPaused = false;
1072     bool public recollateralizePaused = false;
1073     bool public buyBackPaused = false;
1074     bool public collateralPricePaused = false;
1075     event UpdateOracleBonus(address indexed user,bool bonus1, bool bonus2);
1076     /* ========== MODIFIERS ========== */
1077     modifier onlyByOwnerOrGovernance() {
1078         require(msg.sender == timelock_address || msg.sender == owner_address, "You are not the owner or the governance timelock");
1079         _;
1080     }
1081     modifier notRedeemPaused() {
1082         require(redeemPaused == false, "Redeeming is paused");
1083         require(redemptionOpened() == true,"Redeeming is closed");
1084         _;
1085     }
1086     modifier notMintPaused() {
1087         require(mintPaused == false, "Minting is paused");
1088         require(mintingOpened() == true,"Minting is closed");
1089         _;
1090     }
1091     /* ========== CONSTRUCTOR ========== */
1092     constructor(
1093         address _use_contract_address,
1094         address _shares_contract_address,
1095         address _collateral_address,
1096         address _creator_address,
1097         address _timelock_address,
1098         address _community_address
1099     ) public {
1100         USE = IUSEStablecoin(_use_contract_address);
1101         SHARE = IShareToken(_shares_contract_address);
1102         use_contract_address = _use_contract_address;
1103         shares_contract_address = _shares_contract_address;
1104         collateral_address = _collateral_address;
1105         timelock_address = _timelock_address;
1106         owner_address = _creator_address;
1107         community_address = _community_address;
1108         collateral_token = IERC20Detail(_collateral_address); 
1109         missing_decimals = uint(18).sub(collateral_token.decimals());
1110         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1111         grantRole(MINT_PAUSER, timelock_address);
1112         grantRole(REDEEM_PAUSER, timelock_address);
1113         grantRole(RECOLLATERALIZE_PAUSER, timelock_address);
1114         grantRole(BUYBACK_PAUSER, timelock_address);
1115         grantRole(COLLATERAL_PRICE_PAUSER, timelock_address);
1116         grantRole(COMMUNITY_RATER, _community_address);
1117     }
1118     /* ========== VIEWS ========== */
1119     // Returns dollar value of collateral held in this USE pool
1120     function collatDollarBalance() public view returns (uint256) {
1121         uint256 collateral_amount = collateral_token.balanceOf(address(this)).sub(unclaimedPoolCollateral);
1122         uint256 collat_usd_price = collateralPricePaused == true ? pausedPrice : getCollateralPrice();
1123         return collateral_amount.mul(10 ** missing_decimals).mul(collat_usd_price).div(PRICE_PRECISION); 
1124     }
1125     // Returns the value of excess collateral held in this USE pool, compared to what is needed to maintain the global collateral ratio
1126     function availableExcessCollatDV() public view returns (uint256) {      
1127         uint256 total_supply = USE.totalSupply().sub(global_use_supply_adj);       
1128         uint256 global_collat_value = USE.globalCollateralValue();
1129         uint256 global_collateral_ratio = USE.global_collateral_ratio();
1130         // Handles an overcollateralized contract with CR > 1
1131         if (global_collateral_ratio > COLLATERAL_RATIO_PRECISION) {
1132             global_collateral_ratio = COLLATERAL_RATIO_PRECISION; 
1133         }
1134         // Calculates collateral needed to back each 1 USE with $1 of collateral at current collat ratio
1135         uint256 required_collat_dollar_value_d18 = (total_supply.mul(global_collateral_ratio)).div(COLLATERAL_RATIO_PRECISION);
1136         if (global_collat_value > required_collat_dollar_value_d18) {
1137            return global_collat_value.sub(required_collat_dollar_value_d18);
1138         }
1139         return 0;
1140     }
1141     /* ========== PUBLIC FUNCTIONS ========== */ 
1142     function getCollateralPrice() public view virtual returns (uint256);
1143     function getCollateralAmount()   public view  returns (uint256){
1144         return collateral_token.balanceOf(address(this)).sub(unclaimedPoolCollateral);
1145     }
1146     function requiredReserveRatio() public view returns(uint256){
1147         uint256 pool_collateral_amount = getCollateralAmount();
1148         uint256 swap_collateral_amount = USE.swapCollateralAmount();
1149         require(swap_collateral_amount>0,"swap collateral is empty?");
1150         return pool_collateral_amount.mul(RESERVE_RATIO_PRECISION).div(swap_collateral_amount);
1151     }
1152     function mintingOpened() public view returns(bool){ 
1153         return  (requiredReserveRatio() >= minting_required_reserve_ratio);
1154     }
1155     function redemptionOpened() public view returns(bool){
1156         return  (requiredReserveRatio() >= redemption_required_reserve_ratio);
1157     }
1158     //
1159     function mintingTax() public view returns(uint256){
1160         uint256 _dynamicTax =  minting_tax_multiplier.mul(requiredReserveRatio()).div(RESERVE_RATIO_PRECISION); 
1161         return  minting_tax_base + _dynamicTax;       
1162     }
1163     function dynamicRedemptionTax(uint256 ratio,uint256 multiplier,uint256 exponent) public pure returns(uint256){        
1164         return multiplier.mul(RESERVE_RATIO_PRECISION**exponent).div(ratio**exponent);
1165     }
1166     //
1167     function redemptionTax() public view returns(uint256){
1168         uint256 _dynamicTax =dynamicRedemptionTax(requiredReserveRatio(),redemption_tax_multiplier,redemption_tax_exponent);
1169         return  redemption_tax_base + _dynamicTax;       
1170     } 
1171     function updateOraclePrice() public { 
1172         IUniswapPairOracle _useDaiOracle = USE.USEDAIOracle();
1173         IUniswapPairOracle _useSharesOracle = USE.USESharesOracle();
1174         bool _bonus1 = _useDaiOracle.update();
1175         bool _bonus2 = _useSharesOracle.update(); 
1176         if(_bonus1 || _bonus2){
1177             emit UpdateOracleBonus(msg.sender,_bonus1,_bonus2);
1178         }
1179     }
1180     // We separate out the 1t1, fractional and algorithmic minting functions for gas efficiency 
1181     function mint1t1USE(uint256 collateral_amount, uint256 use_out_min) external onlyOneBlock notMintPaused { 
1182         updateOraclePrice();       
1183         uint256 collateral_amount_d18 = collateral_amount * (10 ** missing_decimals);
1184         require(USE.global_collateral_ratio() >= COLLATERAL_RATIO_MAX, "Collateral ratio must be >= 1");
1185         require(getCollateralAmount().add(collateral_amount) <= pool_ceiling, "[Pool's Closed]: Ceiling reached");
1186         (uint256 use_amount_d18) = calcMint1t1USE(
1187             getCollateralPrice(),
1188             collateral_amount_d18
1189         ); //1 USE for each $1 worth of collateral
1190         community_rate_in_use  =  community_rate_in_use.add(use_amount_d18.mul(community_rate_ratio).div(PRECISION));
1191         use_amount_d18 = (use_amount_d18.mul(uint(1e6).sub(mintingTax()))).div(1e6); //remove precision at the end
1192         require(use_out_min <= use_amount_d18, "Slippage limit reached");
1193         collateral_token.transferFrom(msg.sender, address(this), collateral_amount);
1194         USE.pool_mint(msg.sender, use_amount_d18);  
1195     }
1196     // Will fail if fully collateralized or fully algorithmic
1197     // > 0% and < 100% collateral-backed
1198     function mintFractionalUSE(uint256 collateral_amount, uint256 shares_amount, uint256 use_out_min) external onlyOneBlock notMintPaused {
1199         updateOraclePrice();
1200         uint256 share_price = USE.share_price();
1201         uint256 global_collateral_ratio = USE.global_collateral_ratio();
1202         require(global_collateral_ratio < COLLATERAL_RATIO_MAX && global_collateral_ratio > 0, "Collateral ratio needs to be between .000001 and .999999");
1203         require(getCollateralAmount().add(collateral_amount) <= pool_ceiling, "Pool ceiling reached, no more USE can be minted with this collateral");
1204         uint256 collateral_amount_d18 = collateral_amount * (10 ** missing_decimals);
1205         MintFU_Params memory input_params = MintFU_Params(
1206             share_price,
1207             getCollateralPrice(),
1208             shares_amount,
1209             collateral_amount_d18,
1210             global_collateral_ratio
1211         );
1212         (uint256 mint_amount,uint256 collateral_need_d18, uint256 shares_needed) = calcMintFractionalUSE(input_params);
1213         community_rate_in_use  =  community_rate_in_use.add(mint_amount.mul(community_rate_ratio).div(PRECISION));
1214         mint_amount = (mint_amount.mul(uint(1e6).sub(mintingTax()))).div(1e6);
1215         require(use_out_min <= mint_amount, "Slippage limit reached");
1216         require(shares_needed <= shares_amount, "Not enough Shares inputted");
1217         uint256 collateral_need = collateral_need_d18.div(10 ** missing_decimals);
1218         SHARE.pool_burn_from(msg.sender, shares_needed);
1219         collateral_token.transferFrom(msg.sender, address(this), collateral_need);
1220         USE.pool_mint(msg.sender, mint_amount);      
1221     }
1222     // Redeem collateral. 100% collateral-backed
1223     function redeem1t1USE(uint256 use_amount, uint256 COLLATERAL_out_min) external onlyOneBlock notRedeemPaused {
1224         updateOraclePrice();
1225         require(USE.global_collateral_ratio() == COLLATERAL_RATIO_MAX, "Collateral ratio must be == 1");
1226         // Need to adjust for decimals of collateral
1227         uint256 use_amount_precision = use_amount.div(10 ** missing_decimals);
1228         (uint256 collateral_needed) = calcRedeem1t1USE(
1229             getCollateralPrice(),
1230             use_amount_precision
1231         );
1232         community_rate_in_use  =  community_rate_in_use.add(use_amount.mul(community_rate_ratio).div(PRECISION));
1233         collateral_needed = (collateral_needed.mul(uint(1e6).sub(redemptionTax()))).div(1e6);
1234         require(collateral_needed <= getCollateralAmount(), "Not enough collateral in pool");
1235         require(COLLATERAL_out_min <= collateral_needed, "Slippage limit reached");
1236         redeemCollateralBalances[msg.sender] = redeemCollateralBalances[msg.sender].add(collateral_needed);
1237         unclaimedPoolCollateral = unclaimedPoolCollateral.add(collateral_needed);
1238         lastRedeemed[msg.sender] = block.number;
1239         // Move all external functions to the end
1240         USE.pool_burn_from(msg.sender, use_amount); 
1241         require(redemptionOpened() == true,"Redeem amount too large !");
1242     }
1243     // Will fail if fully collateralized or algorithmic
1244     // Redeem USE for collateral and SHARE. > 0% and < 100% collateral-backed
1245     function redeemFractionalUSE(uint256 use_amount, uint256 shares_out_min, uint256 COLLATERAL_out_min) external onlyOneBlock notRedeemPaused {
1246         updateOraclePrice();
1247         uint256 global_collateral_ratio = USE.global_collateral_ratio();
1248         require(global_collateral_ratio < COLLATERAL_RATIO_MAX && global_collateral_ratio > 0, "Collateral ratio needs to be between .000001 and .999999");
1249         global_collateral_ratio = global_collateral_ratio.mul(redemption_gcr_adj).div(PRECISION);
1250         uint256 use_amount_post_tax = (use_amount.mul(uint(1e6).sub(redemptionTax()))).div(PRICE_PRECISION);
1251         uint256 shares_dollar_value_d18 = use_amount_post_tax.sub(use_amount_post_tax.mul(global_collateral_ratio).div(PRICE_PRECISION));
1252         uint256 shares_amount = shares_dollar_value_d18.mul(PRICE_PRECISION).div(USE.share_price());
1253         // Need to adjust for decimals of collateral
1254         uint256 use_amount_precision = use_amount_post_tax.div(10 ** missing_decimals);
1255         uint256 collateral_dollar_value = use_amount_precision.mul(global_collateral_ratio).div(PRICE_PRECISION);
1256         uint256 collateral_amount = collateral_dollar_value.mul(PRICE_PRECISION).div(getCollateralPrice());
1257         require(collateral_amount <= getCollateralAmount(), "Not enough collateral in pool");
1258         require(COLLATERAL_out_min <= collateral_amount, "Slippage limit reached [collateral]");
1259         require(shares_out_min <= shares_amount, "Slippage limit reached [Shares]");
1260         community_rate_in_use  =  community_rate_in_use.add(use_amount.mul(community_rate_ratio).div(PRECISION));
1261         redeemCollateralBalances[msg.sender] = redeemCollateralBalances[msg.sender].add(collateral_amount);
1262         unclaimedPoolCollateral = unclaimedPoolCollateral.add(collateral_amount);
1263         redeemSharesBalances[msg.sender] = redeemSharesBalances[msg.sender].add(shares_amount);
1264         unclaimedPoolShares = unclaimedPoolShares.add(shares_amount);
1265         lastRedeemed[msg.sender] = block.number;
1266         // Move all external functions to the end
1267         USE.pool_burn_from(msg.sender, use_amount);
1268         SHARE.pool_mint(address(this), shares_amount);
1269         require(redemptionOpened() == true,"Redeem amount too large !");
1270     }
1271     // After a redemption happens, transfer the newly minted Shares and owed collateral from this pool
1272     // contract to the user. Redemption is split into two functions to prevent flash loans from being able
1273     // to take out USE/collateral from the system, use an AMM to trade the new price, and then mint back into the system.
1274     function collectRedemption() external onlyOneBlock{        
1275         require((lastRedeemed[msg.sender].add(redemption_delay)) <= block.number, "Must wait for redemption_delay blocks before collecting redemption");
1276         bool sendShares = false;
1277         bool sendCollateral = false;
1278         uint sharesAmount;
1279         uint CollateralAmount;
1280         // Use Checks-Effects-Interactions pattern
1281         if(redeemSharesBalances[msg.sender] > 0){
1282             sharesAmount = redeemSharesBalances[msg.sender];
1283             redeemSharesBalances[msg.sender] = 0;
1284             unclaimedPoolShares = unclaimedPoolShares.sub(sharesAmount);
1285             sendShares = true;
1286         }
1287         if(redeemCollateralBalances[msg.sender] > 0){
1288             CollateralAmount = redeemCollateralBalances[msg.sender];
1289             redeemCollateralBalances[msg.sender] = 0;
1290             unclaimedPoolCollateral = unclaimedPoolCollateral.sub(CollateralAmount);
1291             sendCollateral = true;
1292         }
1293         if(sendShares == true){
1294             SHARE.transfer(msg.sender, sharesAmount);
1295         }
1296         if(sendCollateral == true){
1297             collateral_token.transfer(msg.sender, CollateralAmount);
1298         }
1299     }
1300     // When the protocol is recollateralizing, we need to give a discount of Shares to hit the new CR target
1301     // Thus, if the target collateral ratio is higher than the actual value of collateral, minters get Shares for adding collateral
1302     // This function simply rewards anyone that sends collateral to a pool with the same amount of Shares + the bonus rate
1303     // Anyone can call this function to recollateralize the protocol and take the extra Shares value from the bonus rate as an arb opportunity
1304     function recollateralizeUSE(uint256 collateral_amount, uint256 shares_out_min) external onlyOneBlock {
1305         require(recollateralizePaused == false, "Recollateralize is paused");
1306         updateOraclePrice();
1307         uint256 collateral_amount_d18 = collateral_amount * (10 ** missing_decimals);
1308         uint256 share_price = USE.share_price();
1309         uint256 use_total_supply = USE.totalSupply().sub(global_use_supply_adj);
1310         uint256 global_collateral_ratio = USE.global_collateral_ratio();
1311         uint256 global_collat_value = USE.globalCollateralValue();
1312         (uint256 collateral_units, uint256 amount_to_recollat) = calcRecollateralizeUSEInner(
1313             collateral_amount_d18,
1314             getCollateralPrice(),
1315             global_collat_value,
1316             use_total_supply,
1317             global_collateral_ratio
1318         ); 
1319         uint256 collateral_units_precision = collateral_units.div(10 ** missing_decimals);
1320         uint256 shares_paid_back = amount_to_recollat.mul(uint(1e6).add(bonus_rate).sub(recollat_tax)).div(share_price);
1321         require(shares_out_min <= shares_paid_back, "Slippage limit reached");
1322         community_rate_in_share =  community_rate_in_share.add(shares_paid_back.mul(community_rate_ratio).div(PRECISION));
1323         collateral_token.transferFrom(msg.sender, address(this), collateral_units_precision);
1324         SHARE.pool_mint(msg.sender, shares_paid_back);
1325     }
1326     // Function can be called by an Shares holder to have the protocol buy back Shares with excess collateral value from a desired collateral pool
1327     // This can also happen if the collateral ratio > 1
1328     function buyBackShares(uint256 shares_amount, uint256 COLLATERAL_out_min) external onlyOneBlock {
1329         require(buyBackPaused == false, "Buyback is paused");
1330         updateOraclePrice();
1331         uint256 share_price = USE.share_price();
1332         BuybackShares_Params memory input_params = BuybackShares_Params(
1333             availableExcessCollatDV(),
1334             share_price,
1335             getCollateralPrice(),
1336             shares_amount
1337         );
1338         (uint256 collateral_equivalent_d18) = (calcBuyBackShares(input_params)).mul(uint(1e6).sub(buyback_tax)).div(1e6);
1339         uint256 collateral_precision = collateral_equivalent_d18.div(10 ** missing_decimals);
1340         require(COLLATERAL_out_min <= collateral_precision, "Slippage limit reached");
1341         community_rate_in_share  =  community_rate_in_share.add(shares_amount.mul(community_rate_ratio).div(PRECISION));
1342         // Give the sender their desired collateral and burn the Shares
1343         SHARE.pool_burn_from(msg.sender, shares_amount);
1344         collateral_token.transfer(msg.sender, collateral_precision);
1345     }
1346     /* ========== RESTRICTED FUNCTIONS ========== */
1347     function toggleMinting() external {
1348         require(hasRole(MINT_PAUSER, msg.sender));
1349         mintPaused = !mintPaused;
1350     }
1351     function toggleRedeeming() external {
1352         require(hasRole(REDEEM_PAUSER, msg.sender));
1353         redeemPaused = !redeemPaused;
1354     }
1355     function toggleRecollateralize() external {
1356         require(hasRole(RECOLLATERALIZE_PAUSER, msg.sender));
1357         recollateralizePaused = !recollateralizePaused;
1358     }
1359     function toggleBuyBack() external {
1360         require(hasRole(BUYBACK_PAUSER, msg.sender));
1361         buyBackPaused = !buyBackPaused;
1362     }
1363     function toggleCollateralPrice(uint256 _new_price) external {
1364         require(hasRole(COLLATERAL_PRICE_PAUSER, msg.sender));
1365         // If pausing, set paused price; else if unpausing, clear pausedPrice
1366         if(collateralPricePaused == false){
1367             pausedPrice = _new_price;
1368         } else {
1369             pausedPrice = 0;
1370         }
1371         collateralPricePaused = !collateralPricePaused;
1372     }
1373     function toggleCommunityInSharesRate(uint256 _rate) external{
1374         require(community_rate_in_share>0,"No SHARE rate");
1375         require(hasRole(COMMUNITY_RATER, msg.sender));
1376         uint256 _amount_rate = community_rate_in_share.mul(_rate).div(PRECISION);
1377         community_rate_in_share = community_rate_in_share.sub(_amount_rate);
1378         SHARE.pool_mint(msg.sender,_amount_rate);  
1379     }
1380     function toggleCommunityInUSERate(uint256 _rate) external{
1381         require(community_rate_in_use>0,"No USE rate");
1382         require(hasRole(COMMUNITY_RATER, msg.sender));
1383         uint256 _amount_rate_use = community_rate_in_use.mul(_rate).div(PRECISION);        
1384         community_rate_in_use = community_rate_in_use.sub(_amount_rate_use);
1385         uint256 _share_price_use = USE.share_price_in_use();
1386         uint256 _amount_rate = _amount_rate_use.mul(PRICE_PRECISION).div(_share_price_use);
1387         SHARE.pool_mint(msg.sender,_amount_rate);  
1388     }
1389     // Combined into one function due to 24KiB contract memory limit
1390     function setPoolParameters(uint256 new_ceiling, 
1391                                uint256 new_bonus_rate, 
1392                                uint256 new_redemption_delay, 
1393                                uint256 new_buyback_tax, 
1394                                uint256 new_recollat_tax,
1395                                uint256 use_supply_adj) external onlyByOwnerOrGovernance {
1396         pool_ceiling = new_ceiling;
1397         bonus_rate = new_bonus_rate;
1398         redemption_delay = new_redemption_delay; 
1399         buyback_tax = new_buyback_tax;
1400         recollat_tax = new_recollat_tax;
1401         global_use_supply_adj = use_supply_adj;
1402     }
1403     function setMintingParameters(uint256 _ratioLevel,
1404                                   uint256 _tax_base,
1405                                   uint256 _tax_multiplier) external onlyByOwnerOrGovernance{
1406         minting_required_reserve_ratio = _ratioLevel;
1407         minting_tax_base = _tax_base;
1408         minting_tax_multiplier = _tax_multiplier;
1409     }
1410     function setRedemptionParameters(uint256 _ratioLevel,
1411                                      uint256 _tax_base,
1412                                      uint256 _tax_multiplier,
1413                                      uint256 _tax_exponent,
1414                                      uint256 _redeem_gcr_adj) external onlyByOwnerOrGovernance{
1415         redemption_required_reserve_ratio = _ratioLevel;
1416         redemption_tax_base = _tax_base;
1417         redemption_tax_multiplier = _tax_multiplier;
1418         redemption_tax_exponent = _tax_exponent;
1419         redemption_gcr_adj = _redeem_gcr_adj;
1420     }
1421     function setTimelock(address new_timelock) external onlyByOwnerOrGovernance {
1422         timelock_address = new_timelock;
1423     }
1424     function setOwner(address _owner_address) external onlyByOwnerOrGovernance {
1425         owner_address = _owner_address;
1426     }
1427     function setCommunityParameters(address _community_address,uint256 _ratio) external onlyByOwnerOrGovernance {
1428         community_address = _community_address;
1429         community_rate_ratio = _ratio;
1430     } 
1431     /* ========== EVENTS ========== */
1432 }
1433 
1434 // File: contracts\USE\Pools\USEPoolDAI.sol
1435 // License: MIT
1436 
1437 contract USEPoolDAI is USEPool {
1438     address public DAI_address;
1439     constructor(
1440         address _use_contract_address,
1441         address _shares_contract_address,
1442         address _collateral_address,
1443         address _creator_address, 
1444         address _timelock_address,
1445         address _community_address
1446     ) 
1447     USEPool(_use_contract_address, _shares_contract_address, _collateral_address, _creator_address, _timelock_address,_community_address)
1448     public {
1449         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1450         DAI_address = _collateral_address;
1451     }
1452     // Returns the price of the pool collateral in USD
1453     function getCollateralPrice() public view override returns (uint256) {
1454         if(collateralPricePaused == true){
1455             return pausedPrice;
1456         } else { 
1457             //Only For Dai
1458             return 1 * PRICE_PRECISION; 
1459         }
1460     } 
1461 }