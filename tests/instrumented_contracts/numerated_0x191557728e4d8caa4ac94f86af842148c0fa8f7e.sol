1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 /**
15  * @dev Contract module which provides a basic access control mechanism, where
16  * there is an account (an owner) that can be granted exclusive access to
17  * specific functions.
18  *
19  * By default, the owner account will be the one that deploys the contract. This
20  * can later be changed with {transferOwnership}.
21  *
22  * This module is used through inheritance. It will make available the modifier
23  * `onlyOwner`, which can be applied to your functions to restrict their use to
24  * the owner.
25  */
26 contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor () internal {
35         address msgSender = _msgSender();
36         _owner = msgSender;
37         emit OwnershipTransferred(address(0), msgSender);
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(_owner == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 library SafeMath {
78     /**
79      * @dev Returns the addition of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `+` operator.
83      *
84      * Requirements:
85      *
86      * - Addition cannot overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b <= a, errorMessage);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      *
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b > 0, errorMessage);
180         uint256 c = a / b;
181         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
188      * Reverts when dividing by zero.
189      *
190      * Counterpart to Solidity's `%` operator. This function uses a `revert`
191      * opcode (which leaves remaining gas untouched) while Solidity uses an
192      * invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts with custom message when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b != 0, errorMessage);
216         return a % b;
217     }
218 }
219 interface IERC20 {
220     /**
221      * @dev Returns the amount of tokens in existence.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     /**
226      * @dev Returns the amount of tokens owned by `account`.
227      */
228     function balanceOf(address account) external view returns (uint256);
229 
230     /**
231      * @dev Moves `amount` tokens from the caller's account to `recipient`.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transfer(address recipient, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Returns the remaining number of tokens that `spender` will be
241      * allowed to spend on behalf of `owner` through {transferFrom}. This is
242      * zero by default.
243      *
244      * This value changes when {approve} or {transferFrom} are called.
245      */
246     function allowance(address owner, address spender) external view returns (uint256);
247 
248     /**
249      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * IMPORTANT: Beware that changing an allowance with this method brings the risk
254      * that someone may use both the old and the new allowance by unfortunate
255      * transaction ordering. One possible solution to mitigate this race
256      * condition is to first reduce the spender's allowance to 0 and set the
257      * desired value afterwards:
258      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259      *
260      * Emits an {Approval} event.
261      */
262     function approve(address spender, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Moves `amount` tokens from `sender` to `recipient` using the
266      * allowance mechanism. `amount` is then deducted from the caller's
267      * allowance.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Emitted when `value` tokens are moved from one account (`from`) to
277      * another (`to`).
278      *
279      * Note that `value` may be zero.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 value);
282 
283     /**
284      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
285      * a call to {approve}. `value` is the new allowance.
286      */
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289 
290 library Address {
291     /**
292      * @dev Returns true if `account` is a contract.
293      *
294      * [IMPORTANT]
295      * ====
296      * It is unsafe to assume that an address for which this function returns
297      * false is an externally-owned account (EOA) and not a contract.
298      *
299      * Among others, `isContract` will return false for the following
300      * types of addresses:
301      *
302      *  - an externally-owned account
303      *  - a contract in construction
304      *  - an address where a contract will be created
305      *  - an address where a contract lived, but was destroyed
306      * ====
307      */
308     function isContract(address account) internal view returns (bool) {
309         // This method relies in extcodesize, which returns 0 for contracts in
310         // construction, since the code is only stored at the end of the
311         // constructor execution.
312 
313         uint256 size;
314         // solhint-disable-next-line no-inline-assembly
315         assembly { size := extcodesize(account) }
316         return size > 0;
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      */
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(address(this).balance >= amount, "Address: insufficient balance");
337 
338         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
339         (bool success, ) = recipient.call{ value: amount }("");
340         require(success, "Address: unable to send value, recipient may have reverted");
341     }
342 
343     /**
344      * @dev Performs a Solidity function call using a low level `call`. A
345      * plain`call` is an unsafe replacement for a function call: use this
346      * function instead.
347      *
348      * If `target` reverts with a revert reason, it is bubbled up by this
349      * function (like regular Solidity function calls).
350      *
351      * Returns the raw returned data. To convert to the expected return value,
352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
353      *
354      * Requirements:
355      *
356      * - `target` must be a contract.
357      * - calling `target` with `data` must not revert.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
362       return functionCall(target, data, "Address: low-level call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
367      * `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
372         return _functionCallWithValue(target, data, 0, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but also transferring `value` wei to `target`.
378      *
379      * Requirements:
380      *
381      * - the calling contract must have an ETH balance of at least `value`.
382      * - the called Solidity function must be `payable`.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392      * with `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
397         require(address(this).balance >= value, "Address: insufficient balance for call");
398         return _functionCallWithValue(target, data, value, errorMessage);
399     }
400 
401     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
402         require(isContract(target), "Address: call to non-contract");
403 
404         // solhint-disable-next-line avoid-low-level-calls
405         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
406         if (success) {
407             return returndata;
408         } else {
409             // Look for revert reason and bubble it up if present
410             if (returndata.length > 0) {
411                 // The easiest way to bubble the revert reason is using memory via assembly
412 
413                 // solhint-disable-next-line no-inline-assembly
414                 assembly {
415                     let returndata_size := mload(returndata)
416                     revert(add(32, returndata), returndata_size)
417                 }
418             } else {
419                 revert(errorMessage);
420             }
421         }
422     }
423 }
424 /**
425  * @dev Library for managing
426  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
427  * types.
428  *
429  * Sets have the following properties:
430  *
431  * - Elements are added, removed, and checked for existence in constant time
432  * (O(1)).
433  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
434  *
435  * ```
436  * contract Example {
437  *     // Add the library methods
438  *     using EnumerableSet for EnumerableSet.AddressSet;
439  *
440  *     // Declare a set state variable
441  *     EnumerableSet.AddressSet private mySet;
442  * }
443  * ```
444  *
445  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
446  * (`UintSet`) are supported.
447  */
448 library EnumerableSet {
449     // To implement this library for multiple types with as little code
450     // repetition as possible, we write it in terms of a generic Set type with
451     // bytes32 values.
452     // The Set implementation uses private functions, and user-facing
453     // implementations (such as AddressSet) are just wrappers around the
454     // underlying Set.
455     // This means that we can only create new EnumerableSets for types that fit
456     // in bytes32.
457 
458     struct Set {
459         // Storage of set values
460         bytes32[] _values;
461 
462         // Position of the value in the `values` array, plus 1 because index 0
463         // means a value is not in the set.
464         mapping (bytes32 => uint256) _indexes;
465     }
466 
467     /**
468      * @dev Add a value to a set. O(1).
469      *
470      * Returns true if the value was added to the set, that is if it was not
471      * already present.
472      */
473     function _add(Set storage set, bytes32 value) private returns (bool) {
474         if (!_contains(set, value)) {
475             set._values.push(value);
476             // The value is stored at length-1, but we add 1 to all indexes
477             // and use 0 as a sentinel value
478             set._indexes[value] = set._values.length;
479             return true;
480         } else {
481             return false;
482         }
483     }
484 
485     /**
486      * @dev Removes a value from a set. O(1).
487      *
488      * Returns true if the value was removed from the set, that is if it was
489      * present.
490      */
491     function _remove(Set storage set, bytes32 value) private returns (bool) {
492         // We read and store the value's index to prevent multiple reads from the same storage slot
493         uint256 valueIndex = set._indexes[value];
494 
495         if (valueIndex != 0) { // Equivalent to contains(set, value)
496             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
497             // the array, and then remove the last element (sometimes called as 'swap and pop').
498             // This modifies the order of the array, as noted in {at}.
499 
500             uint256 toDeleteIndex = valueIndex - 1;
501             uint256 lastIndex = set._values.length - 1;
502 
503             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
504             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
505 
506             bytes32 lastvalue = set._values[lastIndex];
507 
508             // Move the last value to the index where the value to delete is
509             set._values[toDeleteIndex] = lastvalue;
510             // Update the index for the moved value
511             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
512 
513             // Delete the slot where the moved value was stored
514             set._values.pop();
515 
516             // Delete the index for the deleted slot
517             delete set._indexes[value];
518 
519             return true;
520         } else {
521             return false;
522         }
523     }
524 
525     /**
526      * @dev Returns true if the value is in the set. O(1).
527      */
528     function _contains(Set storage set, bytes32 value) private view returns (bool) {
529         return set._indexes[value] != 0;
530     }
531 
532     /**
533      * @dev Returns the number of values on the set. O(1).
534      */
535     function _length(Set storage set) private view returns (uint256) {
536         return set._values.length;
537     }
538 
539    /**
540     * @dev Returns the value stored at position `index` in the set. O(1).
541     *
542     * Note that there are no guarantees on the ordering of values inside the
543     * array, and it may change when more values are added or removed.
544     *
545     * Requirements:
546     *
547     * - `index` must be strictly less than {length}.
548     */
549     function _at(Set storage set, uint256 index) private view returns (bytes32) {
550         require(set._values.length > index, "EnumerableSet: index out of bounds");
551         return set._values[index];
552     }
553 
554     // AddressSet
555 
556     struct AddressSet {
557         Set _inner;
558     }
559 
560     /**
561      * @dev Add a value to a set. O(1).
562      *
563      * Returns true if the value was added to the set, that is if it was not
564      * already present.
565      */
566     function add(AddressSet storage set, address value) internal returns (bool) {
567         return _add(set._inner, bytes32(uint256(value)));
568     }
569 
570     /**
571      * @dev Removes a value from a set. O(1).
572      *
573      * Returns true if the value was removed from the set, that is if it was
574      * present.
575      */
576     function remove(AddressSet storage set, address value) internal returns (bool) {
577         return _remove(set._inner, bytes32(uint256(value)));
578     }
579 
580     /**
581      * @dev Returns true if the value is in the set. O(1).
582      */
583     function contains(AddressSet storage set, address value) internal view returns (bool) {
584         return _contains(set._inner, bytes32(uint256(value)));
585     }
586 
587     /**
588      * @dev Returns the number of values in the set. O(1).
589      */
590     function length(AddressSet storage set) internal view returns (uint256) {
591         return _length(set._inner);
592     }
593 
594    /**
595     * @dev Returns the value stored at position `index` in the set. O(1).
596     *
597     * Note that there are no guarantees on the ordering of values inside the
598     * array, and it may change when more values are added or removed.
599     *
600     * Requirements:
601     *
602     * - `index` must be strictly less than {length}.
603     */
604     function at(AddressSet storage set, uint256 index) internal view returns (address) {
605         return address(uint256(_at(set._inner, index)));
606     }
607 
608 
609     // UintSet
610 
611     struct UintSet {
612         Set _inner;
613     }
614 
615     /**
616      * @dev Add a value to a set. O(1).
617      *
618      * Returns true if the value was added to the set, that is if it was not
619      * already present.
620      */
621     function add(UintSet storage set, uint256 value) internal returns (bool) {
622         return _add(set._inner, bytes32(value));
623     }
624 
625     /**
626      * @dev Removes a value from a set. O(1).
627      *
628      * Returns true if the value was removed from the set, that is if it was
629      * present.
630      */
631     function remove(UintSet storage set, uint256 value) internal returns (bool) {
632         return _remove(set._inner, bytes32(value));
633     }
634 
635     /**
636      * @dev Returns true if the value is in the set. O(1).
637      */
638     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
639         return _contains(set._inner, bytes32(value));
640     }
641 
642     /**
643      * @dev Returns the number of values on the set. O(1).
644      */
645     function length(UintSet storage set) internal view returns (uint256) {
646         return _length(set._inner);
647     }
648 
649    /**
650     * @dev Returns the value stored at position `index` in the set. O(1).
651     *
652     * Note that there are no guarantees on the ordering of values inside the
653     * array, and it may change when more values are added or removed.
654     *
655     * Requirements:
656     *
657     * - `index` must be strictly less than {length}.
658     */
659     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
660         return uint256(_at(set._inner, index));
661     }
662 }
663 /**
664  * @dev Contract module that allows children to implement role-based access
665  * control mechanisms.
666  *
667  * Roles are referred to by their `bytes32` identifier. These should be exposed
668  * in the external API and be unique. The best way to achieve this is by
669  * using `public constant` hash digests:
670  *
671  * ```
672  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
673  * ```
674  *
675  * Roles can be used to represent a set of permissions. To restrict access to a
676  * function call, use {hasRole}:
677  *
678  * ```
679  * function foo() public {
680  *     require(hasRole(MY_ROLE, msg.sender));
681  *     ...
682  * }
683  * ```
684  *
685  * Roles can be granted and revoked dynamically via the {grantRole} and
686  * {revokeRole} functions. Each role has an associated admin role, and only
687  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
688  *
689  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
690  * that only accounts with this role will be able to grant or revoke other
691  * roles. More complex role relationships can be created by using
692  * {_setRoleAdmin}.
693  *
694  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
695  * grant and revoke this role. Extra precautions should be taken to secure
696  * accounts that have been granted it.
697  */
698 abstract contract AccessControl is Context {
699     using EnumerableSet for EnumerableSet.AddressSet;
700     using Address for address;
701 
702     struct RoleData {
703         EnumerableSet.AddressSet members;
704         bytes32 adminRole;
705     }
706 
707     mapping (bytes32 => RoleData) private _roles;
708 
709     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
710 
711     /**
712      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
713      *
714      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
715      * {RoleAdminChanged} not being emitted signaling this.
716      *
717      * _Available since v3.1._
718      */
719     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
720 
721     /**
722      * @dev Emitted when `account` is granted `role`.
723      *
724      * `sender` is the account that originated the contract call, an admin role
725      * bearer except when using {_setupRole}.
726      */
727     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
728 
729     /**
730      * @dev Emitted when `account` is revoked `role`.
731      *
732      * `sender` is the account that originated the contract call:
733      *   - if using `revokeRole`, it is the admin role bearer
734      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
735      */
736     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
737 
738     /**
739      * @dev Returns `true` if `account` has been granted `role`.
740      */
741     function hasRole(bytes32 role, address account) public view returns (bool) {
742         return _roles[role].members.contains(account);
743     }
744 
745     /**
746      * @dev Returns the number of accounts that have `role`. Can be used
747      * together with {getRoleMember} to enumerate all bearers of a role.
748      */
749     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
750         return _roles[role].members.length();
751     }
752 
753     /**
754      * @dev Returns one of the accounts that have `role`. `index` must be a
755      * value between 0 and {getRoleMemberCount}, non-inclusive.
756      *
757      * Role bearers are not sorted in any particular way, and their ordering may
758      * change at any point.
759      *
760      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
761      * you perform all queries on the same block. See the following
762      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
763      * for more information.
764      */
765     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
766         return _roles[role].members.at(index);
767     }
768 
769     /**
770      * @dev Returns the admin role that controls `role`. See {grantRole} and
771      * {revokeRole}.
772      *
773      * To change a role's admin, use {_setRoleAdmin}.
774      */
775     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
776         return _roles[role].adminRole;
777     }
778 
779     /**
780      * @dev Grants `role` to `account`.
781      *
782      * If `account` had not been already granted `role`, emits a {RoleGranted}
783      * event.
784      *
785      * Requirements:
786      *
787      * - the caller must have ``role``'s admin role.
788      */
789     function grantRole(bytes32 role, address account) public virtual {
790         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
791 
792         _grantRole(role, account);
793     }
794 
795     /**
796      * @dev Revokes `role` from `account`.
797      *
798      * If `account` had been granted `role`, emits a {RoleRevoked} event.
799      *
800      * Requirements:
801      *
802      * - the caller must have ``role``'s admin role.
803      */
804     function revokeRole(bytes32 role, address account) public virtual {
805         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
806 
807         _revokeRole(role, account);
808     }
809 
810     /**
811      * @dev Revokes `role` from the calling account.
812      *
813      * Roles are often managed via {grantRole} and {revokeRole}: this function's
814      * purpose is to provide a mechanism for accounts to lose their privileges
815      * if they are compromised (such as when a trusted device is misplaced).
816      *
817      * If the calling account had been granted `role`, emits a {RoleRevoked}
818      * event.
819      *
820      * Requirements:
821      *
822      * - the caller must be `account`.
823      */
824     function renounceRole(bytes32 role, address account) public virtual {
825         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
826 
827         _revokeRole(role, account);
828     }
829 
830     /**
831      * @dev Grants `role` to `account`.
832      *
833      * If `account` had not been already granted `role`, emits a {RoleGranted}
834      * event. Note that unlike {grantRole}, this function doesn't perform any
835      * checks on the calling account.
836      *
837      * [WARNING]
838      * ====
839      * This function should only be called from the constructor when setting
840      * up the initial roles for the system.
841      *
842      * Using this function in any other way is effectively circumventing the admin
843      * system imposed by {AccessControl}.
844      * ====
845      */
846     function _setupRole(bytes32 role, address account) internal virtual {
847         _grantRole(role, account);
848     }
849 
850     /**
851      * @dev Sets `adminRole` as ``role``'s admin role.
852      *
853      * Emits a {RoleAdminChanged} event.
854      */
855     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
856         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
857         _roles[role].adminRole = adminRole;
858     }
859 
860     function _grantRole(bytes32 role, address account) private {
861         if (_roles[role].members.add(account)) {
862             emit RoleGranted(role, account, _msgSender());
863         }
864     }
865 
866     function _revokeRole(bytes32 role, address account) private {
867         if (_roles[role].members.remove(account)) {
868             emit RoleRevoked(role, account, _msgSender());
869         }
870     }
871 }
872 /**
873  * @dev Implementation of the {IERC20} interface.
874  *
875  * This implementation is agnostic to the way tokens are created. This means
876  * that a supply mechanism has to be added in a derived contract using {_mint}.
877  * For a generic mechanism see {ERC20PresetMinterPauser}.
878  *
879  * TIP: For a detailed writeup see our guide
880  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
881  * to implement supply mechanisms].
882  *
883  * We have followed general OpenZeppelin guidelines: functions revert instead
884  * of returning `false` on failure. This behavior is nonetheless conventional
885  * and does not conflict with the expectations of ERC20 applications.
886  *
887  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
888  * This allows applications to reconstruct the allowance for all accounts just
889  * by listening to said events. Other implementations of the EIP may not emit
890  * these events, as it isn't required by the specification.
891  *
892  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
893  * functions have been added to mitigate the well-known issues around setting
894  * allowances. See {IERC20-approve}.
895  */
896 contract ERC20 is Context, IERC20 {
897     using SafeMath for uint256;
898     using Address for address;
899 
900     mapping (address => uint256) private _balances;
901 
902     mapping (address => mapping (address => uint256)) private _allowances;
903 
904     uint256 private _totalSupply;
905 
906     string private _name;
907     string private _symbol;
908     uint8 private _decimals;
909 
910     constructor (string memory name, string memory symbol, uint8 decimals) public {
911         _name = name;
912         _symbol = symbol;
913         _decimals = decimals;
914     }
915 
916     /**
917      * @dev Returns the name of the token.
918      */
919     function name() public view returns (string memory) {
920         return _name;
921     }
922 
923     /**
924      * @dev Returns the symbol of the token, usually a shorter version of the
925      * name.
926      */
927     function symbol() public view returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev Returns the number of decimals used to get its user representation.
933      * For example, if `decimals` equals `2`, a balance of `505` tokens should
934      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
935      *
936      * Tokens usually opt for a value of 18, imitating the relationship between
937      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
938      * called.
939      *
940      * NOTE: This information is only used for _display_ purposes: it in
941      * no way affects any of the arithmetic of the contract, including
942      * {IERC20-balanceOf} and {IERC20-transfer}.
943      */
944     function decimals() public view returns (uint8) {
945         return _decimals;
946     }
947 
948     /**
949      * @dev See {IERC20-totalSupply}.
950      */
951     function totalSupply() public view override returns (uint256) {
952         return _totalSupply;
953     }
954 
955     /**
956      * @dev See {IERC20-balanceOf}.
957      */
958     function balanceOf(address account) public view override returns (uint256) {
959         return _balances[account];
960     }
961 
962     /**
963      * @dev See {IERC20-transfer}.
964      *
965      * Requirements:
966      *
967      * - `recipient` cannot be the zero address.
968      * - the caller must have a balance of at least `amount`.
969      */
970     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
971         _transfer(_msgSender(), recipient, amount);
972         return true;
973     }
974 
975     /**
976      * @dev See {IERC20-allowance}.
977      */
978     function allowance(address owner, address spender) public view virtual override returns (uint256) {
979         return _allowances[owner][spender];
980     }
981 
982     /**
983      * @dev See {IERC20-approve}.
984      *
985      * Requirements:
986      *
987      * - `spender` cannot be the zero address.
988      */
989     function approve(address spender, uint256 amount) public virtual override returns (bool) {
990         _approve(_msgSender(), spender, amount);
991         return true;
992     }
993 
994     /**
995      * @dev See {IERC20-transferFrom}.
996      *
997      * Emits an {Approval} event indicating the updated allowance. This is not
998      * required by the EIP. See the note at the beginning of {ERC20};
999      *
1000      * Requirements:
1001      * - `sender` and `recipient` cannot be the zero address.
1002      * - `sender` must have a balance of at least `amount`.
1003      * - the caller must have allowance for ``sender``'s tokens of at least
1004      * `amount`.
1005      */
1006     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1007         _transfer(sender, recipient, amount);
1008         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1009         return true;
1010     }
1011 
1012     /**
1013      * @dev Atomically increases the allowance granted to `spender` by the caller.
1014      *
1015      * This is an alternative to {approve} that can be used as a mitigation for
1016      * problems described in {IERC20-approve}.
1017      *
1018      * Emits an {Approval} event indicating the updated allowance.
1019      *
1020      * Requirements:
1021      *
1022      * - `spender` cannot be the zero address.
1023      */
1024     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1025         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1026         return true;
1027     }
1028 
1029     /**
1030      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1031      *
1032      * This is an alternative to {approve} that can be used as a mitigation for
1033      * problems described in {IERC20-approve}.
1034      *
1035      * Emits an {Approval} event indicating the updated allowance.
1036      *
1037      * Requirements:
1038      *
1039      * - `spender` cannot be the zero address.
1040      * - `spender` must have allowance for the caller of at least
1041      * `subtractedValue`.
1042      */
1043     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1044         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1045         return true;
1046     }
1047 
1048     /**
1049      * @dev Moves tokens `amount` from `sender` to `recipient`.
1050      *
1051      * This is internal function is equivalent to {transfer}, and can be used to
1052      * e.g. implement automatic token fees, slashing mechanisms, etc.
1053      *
1054      * Emits a {Transfer} event.
1055      *
1056      * Requirements:
1057      *
1058      * - `sender` cannot be the zero address.
1059      * - `recipient` cannot be the zero address.
1060      * - `sender` must have a balance of at least `amount`.
1061      */
1062     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1063         require(sender != address(0), "ERC20: transfer from the zero address");
1064         require(recipient != address(0), "ERC20: transfer to the zero address");
1065 
1066         _beforeTokenTransfer(sender, recipient, amount);
1067 
1068         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1069         _balances[recipient] = _balances[recipient].add(amount);
1070         emit Transfer(sender, recipient, amount);
1071     }
1072 
1073     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1074      * the total supply.
1075      *
1076      * Emits a {Transfer} event with `from` set to the zero address.
1077      *
1078      * Requirements
1079      *
1080      * - `to` cannot be the zero address.
1081      */
1082     function _mint(address account, uint256 amount) internal virtual {
1083         require(account != address(0), "ERC20: mint to the zero address");
1084 
1085         _beforeTokenTransfer(address(0), account, amount);
1086 
1087         _totalSupply = _totalSupply.add(amount);
1088         _balances[account] = _balances[account].add(amount);
1089         emit Transfer(address(0), account, amount);
1090     }
1091 
1092     /**
1093      * @dev Destroys `amount` tokens from `account`, reducing the
1094      * total supply.
1095      *
1096      * Emits a {Transfer} event with `to` set to the zero address.
1097      *
1098      * Requirements
1099      *
1100      * - `account` cannot be the zero address.
1101      * - `account` must have at least `amount` tokens.
1102      */
1103     function _burn(address account, uint256 amount) internal virtual {
1104         require(account != address(0), "ERC20: burn from the zero address");
1105 
1106         _beforeTokenTransfer(account, address(0), amount);
1107 
1108         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1109         _totalSupply = _totalSupply.sub(amount);
1110         emit Transfer(account, address(0), amount);
1111     }
1112 
1113     /**
1114      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1115      *
1116      * This internal function is equivalent to `approve`, and can be used to
1117      * e.g. set automatic allowances for certain subsystems, etc.
1118      *
1119      * Emits an {Approval} event.
1120      *
1121      * Requirements:
1122      *
1123      * - `owner` cannot be the zero address.
1124      * - `spender` cannot be the zero address.
1125      */
1126     function _approve(address owner, address spender, uint256 amount) internal virtual {
1127         require(owner != address(0), "ERC20: approve from the zero address");
1128         require(spender != address(0), "ERC20: approve to the zero address");
1129 
1130         _allowances[owner][spender] = amount;
1131         emit Approval(owner, spender, amount);
1132     }
1133 
1134     /**
1135      * @dev Sets {decimals} to a value other than the default one of 18.
1136      *
1137      * WARNING: This function should only be called from the constructor. Most
1138      * applications that interact with token contracts will not expect
1139      * {decimals} to ever change, and may work incorrectly if it does.
1140      */
1141     function _setupDecimals(uint8 decimals_) internal {
1142         _decimals = decimals_;
1143     }
1144 
1145     /**
1146      * @dev Hook that is called before any transfer of tokens. This includes
1147      * minting and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1152      * will be to transferred to `to`.
1153      * - when `from` is zero, `amount` tokens will be minted for `to`.
1154      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1155      * - `from` and `to` are never both zero.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1160 }
1161 /**
1162  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1163  * tokens and those that they have an allowance for, in a way that can be
1164  * recognized off-chain (via event analysis).
1165  */
1166 abstract contract ERC20Burnable is Context, ERC20 {
1167     /**
1168      * @dev Destroys `amount` tokens from the caller.
1169      *
1170      * See {ERC20-_burn}.
1171      */
1172     function burn(uint256 amount) public virtual {
1173         _burn(_msgSender(), amount);
1174     }
1175 
1176     /**
1177      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1178      * allowance.
1179      *
1180      * See {ERC20-_burn} and {ERC20-allowance}.
1181      *
1182      * Requirements:
1183      *
1184      * - the caller must have allowance for ``accounts``'s tokens of at least
1185      * `amount`.
1186      */
1187     function burnFrom(address account, uint256 amount) public virtual {
1188         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1189 
1190         _approve(account, _msgSender(), decreasedAllowance);
1191         _burn(account, amount);
1192     }
1193 }
1194 /**
1195  * @dev Contract module which allows children to implement an emergency stop
1196  * mechanism that can be triggered by an authorized account.
1197  *
1198  * This module is used through inheritance. It will make available the
1199  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1200  * the functions of your contract. Note that they will not be pausable by
1201  * simply including this module, only once the modifiers are put in place.
1202  */
1203 contract Pausable is Context {
1204     /**
1205      * @dev Emitted when the pause is triggered by `account`.
1206      */
1207     event Paused(address account);
1208 
1209     /**
1210      * @dev Emitted when the pause is lifted by `account`.
1211      */
1212     event Unpaused(address account);
1213 
1214     bool private _paused;
1215 
1216     /**
1217      * @dev Initializes the contract in unpaused state.
1218      */
1219     constructor () internal {
1220         _paused = false;
1221     }
1222 
1223     /**
1224      * @dev Returns true if the contract is paused, and false otherwise.
1225      */
1226     function paused() public view returns (bool) {
1227         return _paused;
1228     }
1229 
1230     /**
1231      * @dev Modifier to make a function callable only when the contract is not paused.
1232      *
1233      * Requirements:
1234      *
1235      * - The contract must not be paused.
1236      */
1237     modifier whenNotPaused() {
1238         require(!_paused, "Pausable: paused");
1239         _;
1240     }
1241 
1242     /**
1243      * @dev Modifier to make a function callable only when the contract is paused.
1244      *
1245      * Requirements:
1246      *
1247      * - The contract must be paused.
1248      */
1249     modifier whenPaused() {
1250         require(_paused, "Pausable: not paused");
1251         _;
1252     }
1253 
1254     /**
1255      * @dev Triggers stopped state.
1256      *
1257      * Requirements:
1258      *
1259      * - The contract must not be paused.
1260      */
1261     function _pause() internal virtual whenNotPaused {
1262         _paused = true;
1263         emit Paused(_msgSender());
1264     }
1265 
1266     /**
1267      * @dev Returns to normal state.
1268      *
1269      * Requirements:
1270      *
1271      * - The contract must be paused.
1272      */
1273     function _unpause() internal virtual whenPaused {
1274         _paused = false;
1275         emit Unpaused(_msgSender());
1276     }
1277 }
1278 
1279 /**
1280  * @dev ERC20 token with pausable token transfers, minting and burning.
1281  *
1282  * Useful for scenarios such as preventing trades until the end of an evaluation
1283  * period, or having an emergency switch for freezing all token transfers in the
1284  * event of a large bug.
1285  */
1286 abstract contract ERC20Pausable is ERC20, Pausable {
1287     /**
1288      * @dev See {ERC20-_beforeTokenTransfer}.
1289      *
1290      * Requirements:
1291      *
1292      * - the contract must not be paused.
1293      */
1294     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1295         super._beforeTokenTransfer(from, to, amount);
1296 
1297         require(!paused(), "ERC20Pausable: token transfer while paused");
1298     }
1299 }
1300 
1301 /**
1302  * @dev {ERC20} token, including:
1303  *
1304  *  - ability for holders to burn (destroy) their tokens
1305  *  - a minter role that allows for token minting (creation)
1306  *  - a pauser role that allows to stop all token transfers
1307  *
1308  * This contract uses {AccessControl} to lock permissioned functions using the
1309  * different roles - head to its documentation for details.
1310  *
1311  * The account that deploys the contract will be granted the minter and pauser
1312  * roles, as well as the default admin role, which will let it grant both minter
1313  * and pauser roles to other accounts.
1314  */
1315 
1316 contract EcoToken is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1317     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1318     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1319     uint256 private _cap;
1320 
1321     /**
1322      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1323      * account that deploys the contract.
1324      *
1325      * See {ERC20-constructor}.
1326      */
1327     constructor(uint256 cap,string memory name, string memory symbol,uint8 decimals) public ERC20(name, symbol,decimals) {
1328         require(cap > 0, "ERC20Capped: cap is 0");
1329 
1330         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1331 
1332         _setupRole(MINTER_ROLE, _msgSender());
1333         _setupRole(PAUSER_ROLE, _msgSender());
1334         _cap = cap;
1335     }
1336     /**
1337      * @dev Returns the cap on the token's total supply.
1338      */
1339     function cap() public view returns (uint256) {
1340         return _cap;
1341     }
1342 
1343     /**
1344      * @dev Creates `amount` new tokens for `to`.
1345      *
1346      * See {ERC20-_mint}.
1347      *
1348      * Requirements:
1349      *
1350      * - the caller must have the `MINTER_ROLE`.
1351      */
1352     function mint(address to, uint256 amount) public virtual {
1353         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1354         _mint(to, amount);
1355     }
1356 
1357     /**
1358      * @dev Pauses all token transfers.
1359      *
1360      * See {ERC20Pausable} and {Pausable-_pause}.
1361      *
1362      * Requirements:
1363      *
1364      * - the caller must have the `PAUSER_ROLE`.
1365      */
1366     function pause() public virtual {
1367         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1368         _pause();
1369     }
1370 
1371     /**
1372      * @dev Unpauses all token transfers.
1373      *
1374      * See {ERC20Pausable} and {Pausable-_unpause}.
1375      *
1376      * Requirements:
1377      *
1378      * - the caller must have the `PAUSER_ROLE`.
1379      */
1380     function unpause() public virtual {
1381         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1382         _unpause();
1383     }
1384 
1385     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1386         super._beforeTokenTransfer(from, to, amount);
1387     
1388         if (from == address(0)) { // When minting tokens
1389             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
1390         }        
1391     }
1392 }