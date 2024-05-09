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
26 library EnumerableSet {
27     // To implement this library for multiple types with as little code
28     // repetition as possible, we write it in terms of a generic Set type with
29     // bytes32 values.
30     // The Set implementation uses private functions, and user-facing
31     // implementations (such as AddressSet) are just wrappers around the
32     // underlying Set.
33     // This means that we can only create new EnumerableSets for types that fit
34     // in bytes32.
35 
36     struct Set {
37         // Storage of set values
38         bytes32[] _values;
39 
40         // Position of the value in the `values` array, plus 1 because index 0
41         // means a value is not in the set.
42         mapping (bytes32 => uint256) _indexes;
43     }
44 
45     /**
46      * @dev Add a value to a set. O(1).
47      *
48      * Returns true if the value was added to the set, that is if it was not
49      * already present.
50      */
51     function _add(Set storage set, bytes32 value) private returns (bool) {
52         if (!_contains(set, value)) {
53             set._values.push(value);
54             // The value is stored at length-1, but we add 1 to all indexes
55             // and use 0 as a sentinel value
56             set._indexes[value] = set._values.length;
57             return true;
58         } else {
59             return false;
60         }
61     }
62 
63     /**
64      * @dev Removes a value from a set. O(1).
65      *
66      * Returns true if the value was removed from the set, that is if it was
67      * present.
68      */
69     function _remove(Set storage set, bytes32 value) private returns (bool) {
70         // We read and store the value's index to prevent multiple reads from the same storage slot
71         uint256 valueIndex = set._indexes[value];
72 
73         if (valueIndex != 0) { // Equivalent to contains(set, value)
74             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
75             // the array, and then remove the last element (sometimes called as 'swap and pop').
76             // This modifies the order of the array, as noted in {at}.
77 
78             uint256 toDeleteIndex = valueIndex - 1;
79             uint256 lastIndex = set._values.length - 1;
80 
81             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
82             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
83 
84             bytes32 lastvalue = set._values[lastIndex];
85 
86             // Move the last value to the index where the value to delete is
87             set._values[toDeleteIndex] = lastvalue;
88             // Update the index for the moved value
89             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
90 
91             // Delete the slot where the moved value was stored
92             set._values.pop();
93 
94             // Delete the index for the deleted slot
95             delete set._indexes[value];
96 
97             return true;
98         } else {
99             return false;
100         }
101     }
102 
103     /**
104      * @dev Returns true if the value is in the set. O(1).
105      */
106     function _contains(Set storage set, bytes32 value) private view returns (bool) {
107         return set._indexes[value] != 0;
108     }
109 
110     /**
111      * @dev Returns the number of values on the set. O(1).
112      */
113     function _length(Set storage set) private view returns (uint256) {
114         return set._values.length;
115     }
116 
117    /**
118     * @dev Returns the value stored at position `index` in the set. O(1).
119     *
120     * Note that there are no guarantees on the ordering of values inside the
121     * array, and it may change when more values are added or removed.
122     *
123     * Requirements:
124     *
125     * - `index` must be strictly less than {length}.
126     */
127     function _at(Set storage set, uint256 index) private view returns (bytes32) {
128         require(set._values.length > index, "EnumerableSet: index out of bounds");
129         return set._values[index];
130     }
131 
132     struct AddressSet {
133         Set _inner;
134     }
135 
136     /**
137      * @dev Add a value to a set. O(1).
138      *
139      * Returns true if the value was added to the set, that is if it was not
140      * already present.
141      */
142     function add(AddressSet storage set, address value) internal returns (bool) {
143         return _add(set._inner, bytes32(uint256(value)));
144     }
145 
146     /**
147      * @dev Removes a value from a set. O(1).
148      *
149      * Returns true if the value was removed from the set, that is if it was
150      * present.
151      */
152     function remove(AddressSet storage set, address value) internal returns (bool) {
153         return _remove(set._inner, bytes32(uint256(value)));
154     }
155 
156     /**
157      * @dev Returns true if the value is in the set. O(1).
158      */
159     function contains(AddressSet storage set, address value) internal view returns (bool) {
160         return _contains(set._inner, bytes32(uint256(value)));
161     }
162 
163     /**
164      * @dev Returns the number of values in the set. O(1).
165      */
166     function length(AddressSet storage set) internal view returns (uint256) {
167         return _length(set._inner);
168     }
169 
170    /**
171     * @dev Returns the value stored at position `index` in the set. O(1).
172     *
173     * Note that there are no guarantees on the ordering of values inside the
174     * array, and it may change when more values are added or removed.
175     *
176     * Requirements:
177     *
178     * - `index` must be strictly less than {length}.
179     */
180     function at(AddressSet storage set, uint256 index) internal view returns (address) {
181         return address(uint256(_at(set._inner, index)));
182     }
183 
184     struct UintSet {
185         Set _inner;
186     }
187 
188     /**
189      * @dev Add a value to a set. O(1).
190      *
191      * Returns true if the value was added to the set, that is if it was not
192      * already present.
193      */
194     function add(UintSet storage set, uint256 value) internal returns (bool) {
195         return _add(set._inner, bytes32(value));
196     }
197 
198     /**
199      * @dev Removes a value from a set. O(1).
200      *
201      * Returns true if the value was removed from the set, that is if it was
202      * present.
203      */
204     function remove(UintSet storage set, uint256 value) internal returns (bool) {
205         return _remove(set._inner, bytes32(value));
206     }
207 
208     /**
209      * @dev Returns true if the value is in the set. O(1).
210      */
211     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
212         return _contains(set._inner, bytes32(value));
213     }
214 
215     /**
216      * @dev Returns the number of values on the set. O(1).
217      */
218     function length(UintSet storage set) internal view returns (uint256) {
219         return _length(set._inner);
220     }
221 
222    /**
223     * @dev Returns the value stored at position `index` in the set. O(1).
224     *
225     * Note that there are no guarantees on the ordering of values inside the
226     * array, and it may change when more values are added or removed.
227     *
228     * Requirements:
229     *
230     * - `index` must be strictly less than {length}.
231     */
232     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
233         return uint256(_at(set._inner, index));
234     }
235 }
236 
237 abstract contract AccessControl is Context {
238     using EnumerableSet for EnumerableSet.AddressSet;
239     using Address for address;
240 
241     struct RoleData {
242         EnumerableSet.AddressSet members;
243         bytes32 adminRole;
244     }
245 
246     mapping (bytes32 => RoleData) private _roles;
247 
248     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
249 
250     /**
251      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
252      *
253      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
254      * {RoleAdminChanged} not being emitted signaling this.
255      *
256      * _Available since v3.1._
257      */
258     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
259 
260     /**
261      * @dev Emitted when `account` is granted `role`.
262      *
263      * `sender` is the account that originated the contract call, an admin role
264      * bearer except when using {_setupRole}.
265      */
266     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
267 
268     /**
269      * @dev Emitted when `account` is revoked `role`.
270      *
271      * `sender` is the account that originated the contract call:
272      *   - if using `revokeRole`, it is the admin role bearer
273      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
274      */
275     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
276 
277     /**
278      * @dev Returns `true` if `account` has been granted `role`.
279      */
280     function hasRole(bytes32 role, address account) public view returns (bool) {
281         return _roles[role].members.contains(account);
282     }
283 
284     /**
285      * @dev Returns the number of accounts that have `role`. Can be used
286      * together with {getRoleMember} to enumerate all bearers of a role.
287      */
288     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
289         return _roles[role].members.length();
290     }
291 
292     /**
293      * @dev Returns one of the accounts that have `role`. `index` must be a
294      * value between 0 and {getRoleMemberCount}, non-inclusive.
295      *
296      * Role bearers are not sorted in any particular way, and their ordering may
297      * change at any point.
298      */
299     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
300         return _roles[role].members.at(index);
301     }
302 
303     /**
304      * @dev Returns the admin role that controls `role`. See {grantRole} and
305      * {revokeRole}.
306      *
307      * To change a role's admin, use {_setRoleAdmin}.
308      */
309     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
310         return _roles[role].adminRole;
311     }
312 
313     /**
314      * @dev Grants `role` to `account`.
315      *
316      * If `account` had not been already granted `role`, emits a {RoleGranted}
317      * event.
318      *
319      * Requirements:
320      *
321      * - the caller must have ``role``'s admin role.
322      */
323     function grantRole(bytes32 role, address account) public virtual {
324         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
325 
326         _grantRole(role, account);
327     }
328 
329     /**
330      * @dev Revokes `role` from `account`.
331      *
332      * If `account` had been granted `role`, emits a {RoleRevoked} event.
333      *
334      * Requirements:
335      *
336      * - the caller must have ``role``'s admin role.
337      */
338     function revokeRole(bytes32 role, address account) public virtual {
339         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
340 
341         _revokeRole(role, account);
342     }
343 
344     /**
345      * @dev Revokes `role` from the calling account.
346      *
347      * Roles are often managed via {grantRole} and {revokeRole}: this function's
348      * purpose is to provide a mechanism for accounts to lose their privileges
349      * if they are compromised (such as when a trusted device is misplaced).
350      *
351      * If the calling account had been granted `role`, emits a {RoleRevoked}
352      * event.
353      *
354      * Requirements:
355      *
356      * - the caller must be `account`.
357      */
358     function renounceRole(bytes32 role, address account) public virtual {
359         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
360 
361         _revokeRole(role, account);
362     }
363 
364     /**
365      * @dev Grants `role` to `account`.
366      *
367      * If `account` had not been already granted `role`, emits a {RoleGranted}
368      * event. Note that unlike {grantRole}, this function doesn't perform any
369      * checks on the calling account.
370      *
371      * [WARNING]
372      * ====
373      * This function should only be called from the constructor when setting
374      * up the initial roles for the system.
375      *
376      * Using this function in any other way is effectively circumventing the admin
377      * system imposed by {AccessControl}.
378      * ====
379      */
380     function _setupRole(bytes32 role, address account) internal virtual {
381         _grantRole(role, account);
382     }
383 
384     /**
385      * @dev Sets `adminRole` as ``role``'s admin role.
386      *
387      * Emits a {RoleAdminChanged} event.
388      */
389     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
390         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
391         _roles[role].adminRole = adminRole;
392     }
393 
394     function _grantRole(bytes32 role, address account) private {
395         if (_roles[role].members.add(account)) {
396             emit RoleGranted(role, account, _msgSender());
397         }
398     }
399 
400     function _revokeRole(bytes32 role, address account) private {
401         if (_roles[role].members.remove(account)) {
402             emit RoleRevoked(role, account, _msgSender());
403         }
404     }
405 }
406 
407 pragma solidity 0.6.6;
408 
409 
410 contract AccessControlMixin is AccessControl {
411     string private _revertMsg;
412     function _setupContractId(string memory contractId) internal {
413         _revertMsg = string(abi.encodePacked(contractId, ": INSUFFICIENT_PERMISSIONS"));
414     }
415 
416     modifier only(bytes32 role) {
417         require(
418             hasRole(role, _msgSender()),
419             _revertMsg
420         );
421         _;
422     }
423 }
424 
425 // SPDX-License-Identifier: MIT
426 
427 pragma solidity ^0.6.0;
428 
429 /**
430  * @dev Interface of the ERC20 standard as defined in the EIP.
431  */
432 interface IERC20 {
433     /**
434      * @dev Returns the amount of tokens in existence.
435      */
436     function totalSupply() external view returns (uint256);
437 
438     /**
439      * @dev Returns the amount of tokens owned by `account`.
440      */
441     function balanceOf(address account) external view returns (uint256);
442 
443     /**
444      * @dev Moves `amount` tokens from the caller's account to `recipient`.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * Emits a {Transfer} event.
449      */
450     function transfer(address recipient, uint256 amount) external returns (bool);
451 
452     /**
453      * @dev Returns the remaining number of tokens that `spender` will be
454      * allowed to spend on behalf of `owner` through {transferFrom}. This is
455      * zero by default.
456      *
457      * This value changes when {approve} or {transferFrom} are called.
458      */
459     function allowance(address owner, address spender) external view returns (uint256);
460 
461     /**
462      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
463      *
464      * Returns a boolean value indicating whether the operation succeeded.
465      *
466      * IMPORTANT: Beware that changing an allowance with this method brings the risk
467      * that someone may use both the old and the new allowance by unfortunate
468      * transaction ordering. One possible solution to mitigate this race
469      * condition is to first reduce the spender's allowance to 0 and set the
470      * desired value afterwards:
471      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
472      *
473      * Emits an {Approval} event.
474      */
475     function approve(address spender, uint256 amount) external returns (bool);
476 
477     /**
478      * @dev Moves `amount` tokens from `sender` to `recipient` using the
479      * allowance mechanism. `amount` is then deducted from the caller's
480      * allowance.
481      *
482      * Returns a boolean value indicating whether the operation succeeded.
483      *
484      * Emits a {Transfer} event.
485      */
486     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
487 
488     /**
489      * @dev Emitted when `value` tokens are moved from one account (`from`) to
490      * another (`to`).
491      *
492      * Note that `value` may be zero.
493      */
494     event Transfer(address indexed from, address indexed to, uint256 value);
495 
496     /**
497      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
498      * a call to {approve}. `value` is the new allowance.
499      */
500     event Approval(address indexed owner, address indexed spender, uint256 value);
501 }
502 
503 // SPDX-License-Identifier: MIT
504 
505 pragma solidity ^0.6.0;
506 
507 /**
508  * @dev Wrappers over Solidity's arithmetic operations with added overflow
509  * checks.
510  *
511  * Arithmetic operations in Solidity wrap on overflow. This can easily result
512  * in bugs, because programmers usually assume that an overflow raises an
513  * error, which is the standard behavior in high level programming languages.
514  * `SafeMath` restores this intuition by reverting the transaction when an
515  * operation overflows.
516  *
517  * Using this library instead of the unchecked operations eliminates an entire
518  * class of bugs, so it's recommended to use it always.
519  */
520 library SafeMath {
521     /**
522      * @dev Returns the addition of two unsigned integers, reverting on
523      * overflow.
524      *
525      * Counterpart to Solidity's `+` operator.
526      *
527      * Requirements:
528      *
529      * - Addition cannot overflow.
530      */
531     function add(uint256 a, uint256 b) internal pure returns (uint256) {
532         uint256 c = a + b;
533         require(c >= a, "SafeMath: addition overflow");
534 
535         return c;
536     }
537 
538     /**
539      * @dev Returns the subtraction of two unsigned integers, reverting on
540      * overflow (when the result is negative).
541      *
542      * Counterpart to Solidity's `-` operator.
543      *
544      * Requirements:
545      *
546      * - Subtraction cannot overflow.
547      */
548     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
549         return sub(a, b, "SafeMath: subtraction overflow");
550     }
551 
552     /**
553      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
554      * overflow (when the result is negative).
555      *
556      * Counterpart to Solidity's `-` operator.
557      *
558      * Requirements:
559      *
560      * - Subtraction cannot overflow.
561      */
562     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b <= a, errorMessage);
564         uint256 c = a - b;
565 
566         return c;
567     }
568 
569     /**
570      * @dev Returns the multiplication of two unsigned integers, reverting on
571      * overflow.
572      *
573      * Counterpart to Solidity's `*` operator.
574      *
575      * Requirements:
576      *
577      * - Multiplication cannot overflow.
578      */
579     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
580         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
581         // benefit is lost if 'b' is also tested.
582         if (a == 0) {
583             return 0;
584         }
585 
586         uint256 c = a * b;
587         require(c / a == b, "SafeMath: multiplication overflow");
588 
589         return c;
590     }
591 
592     /**
593      * @dev Returns the integer division of two unsigned integers. Reverts on
594      * division by zero. The result is rounded towards zero.
595      *
596      * Counterpart to Solidity's `/` operator. Note: this function uses a
597      * `revert` opcode (which leaves remaining gas untouched) while Solidity
598      * uses an invalid opcode to revert (consuming all remaining gas).
599      *
600      * Requirements:
601      *
602      * - The divisor cannot be zero.
603      */
604     function div(uint256 a, uint256 b) internal pure returns (uint256) {
605         return div(a, b, "SafeMath: division by zero");
606     }
607 
608     /**
609      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
610      * division by zero. The result is rounded towards zero.
611      *
612      * Counterpart to Solidity's `/` operator. Note: this function uses a
613      * `revert` opcode (which leaves remaining gas untouched) while Solidity
614      * uses an invalid opcode to revert (consuming all remaining gas).
615      *
616      * Requirements:
617      *
618      * - The divisor cannot be zero.
619      */
620     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
621         require(b > 0, errorMessage);
622         uint256 c = a / b;
623         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
624 
625         return c;
626     }
627 
628     /**
629      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
630      * Reverts when dividing by zero.
631      *
632      * Counterpart to Solidity's `%` operator. This function uses a `revert`
633      * opcode (which leaves remaining gas untouched) while Solidity uses an
634      * invalid opcode to revert (consuming all remaining gas).
635      *
636      * Requirements:
637      *
638      * - The divisor cannot be zero.
639      */
640     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
641         return mod(a, b, "SafeMath: modulo by zero");
642     }
643 
644     /**
645      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
646      * Reverts with custom message when dividing by zero.
647      *
648      * Counterpart to Solidity's `%` operator. This function uses a `revert`
649      * opcode (which leaves remaining gas untouched) while Solidity uses an
650      * invalid opcode to revert (consuming all remaining gas).
651      *
652      * Requirements:
653      *
654      * - The divisor cannot be zero.
655      */
656     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
657         require(b != 0, errorMessage);
658         return a % b;
659     }
660 }
661 
662 // SPDX-License-Identifier: MIT
663 
664 pragma solidity ^0.6.2;
665 
666 /**
667  * @dev Collection of functions related to the address type
668  */
669 library Address {
670     /**
671      * @dev Returns true if `account` is a contract.
672      *
673      * [IMPORTANT]
674      * ====
675      * It is unsafe to assume that an address for which this function returns
676      * false is an externally-owned account (EOA) and not a contract.
677      *
678      * Among others, `isContract` will return false for the following
679      * types of addresses:
680      *
681      *  - an externally-owned account
682      *  - a contract in construction
683      *  - an address where a contract will be created
684      *  - an address where a contract lived, but was destroyed
685      * ====
686      */
687     function isContract(address account) internal view returns (bool) {
688         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
689         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
690         // for accounts without code, i.e. `keccak256('')`
691         bytes32 codehash;
692         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
693         // solhint-disable-next-line no-inline-assembly
694         assembly { codehash := extcodehash(account) }
695         return (codehash != accountHash && codehash != 0x0);
696     }
697 
698     /**
699      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
700      * `recipient`, forwarding all available gas and reverting on errors.
701      *
702      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
703      * of certain opcodes, possibly making contracts go over the 2300 gas limit
704      * imposed by `transfer`, making them unable to receive funds via
705      * `transfer`. {sendValue} removes this limitation.
706      *
707      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
708      *
709      * IMPORTANT: because control is transferred to `recipient`, care must be
710      * taken to not create reentrancy vulnerabilities. Consider using
711      * {ReentrancyGuard} or the
712      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
713      */
714     function sendValue(address payable recipient, uint256 amount) internal {
715         require(address(this).balance >= amount, "Address: insufficient balance");
716 
717         (bool success, ) = recipient.call{ value: amount }("");
718         require(success, "Address: unable to send value, recipient may have reverted");
719     }
720 
721     /**
722      * @dev Performs a Solidity function call using a low level `call`. A
723      * plain`call` is an unsafe replacement for a function call: use this
724      * function instead.
725      *
726      * If `target` reverts with a revert reason, it is bubbled up by this
727      * function (like regular Solidity function calls).
728      *
729      * Returns the raw returned data. To convert to the expected return value,
730      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
731      *
732      * Requirements:
733      *
734      * - `target` must be a contract.
735      * - calling `target` with `data` must not revert.
736      *
737      * _Available since v3.1._
738      */
739     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
740       return functionCall(target, data, "Address: low-level call failed");
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
745      * `errorMessage` as a fallback revert reason when `target` reverts.
746      *
747      * _Available since v3.1._
748      */
749     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
750         return _functionCallWithValue(target, data, 0, errorMessage);
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
755      * but also transferring `value` wei to `target`.
756      *
757      * Requirements:
758      *
759      * - the calling contract must have an ETH balance of at least `value`.
760      * - the called Solidity function must be `payable`.
761      *
762      * _Available since v3.1._
763      */
764     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
765         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
766     }
767 
768     /**
769      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
770      * with `errorMessage` as a fallback revert reason when `target` reverts.
771      *
772      * _Available since v3.1._
773      */
774     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
775         require(address(this).balance >= value, "Address: insufficient balance for call");
776         return _functionCallWithValue(target, data, value, errorMessage);
777     }
778 
779     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
780         require(isContract(target), "Address: call to non-contract");
781 
782         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
783         if (success) {
784             return returndata;
785         } else {
786             if (returndata.length > 0) {
787                 assembly {
788                     let returndata_size := mload(returndata)
789                     revert(add(32, returndata), returndata_size)
790                 }
791             } else {
792                 revert(errorMessage);
793             }
794         }
795     }
796 }
797 
798 // SPDX-License-Identifier: MIT
799 
800 pragma solidity ^0.6.0;
801 
802 
803 /**
804  * @dev Implementation of the {IERC20} interface.
805  */
806 contract ERC20 is Context, IERC20 {
807     using SafeMath for uint256;
808     using Address for address;
809 
810     mapping (address => uint256) private _balances;
811 
812     mapping (address => mapping (address => uint256)) private _allowances;
813 
814     uint256 private _totalSupply;
815 
816     string private _name;
817     string private _symbol;
818     uint8 private _decimals;
819     
820     bool private _allBurnt;
821 
822     /**
823      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
824      * a default value of 18.
825      *
826      * To select a different value for {decimals}, use {_setupDecimals}.
827      *
828      * All three of these values are immutable: they can only be set once during
829      * construction.
830      */
831     constructor (string memory name, string memory symbol) public {
832         _name = name;
833         _symbol = symbol;
834         _decimals = 18;
835     }
836 
837     /**
838      * @dev Returns the name of the token.
839      */
840     function name() public view returns (string memory) {
841         return _name;
842     }
843 
844     /**
845      * @dev Returns the symbol of the token, usually a shorter version of the
846      * name.
847      */
848     function symbol() public view returns (string memory) {
849         return _symbol;
850     }
851 
852     /**
853      * @dev Returns the number of decimals used to get its user representation.
854      * For example, if `decimals` equals `2`, a balance of `505` tokens should
855      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
856      *
857      * Tokens usually opt for a value of 18, imitating the relationship between
858      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
859      * called.
860      *
861      * NOTE: This information is only used for _display_ purposes: it in
862      * no way affects any of the arithmetic of the contract, including
863      * {IERC20-balanceOf} and {IERC20-transfer}.
864      */
865     function decimals() public view returns (uint8) {
866         return _decimals;
867     }
868 
869     /**
870      * @dev See {IERC20-totalSupply}.
871      */
872     function totalSupply() public view override returns (uint256) {
873         if(isBurnt()) {
874             return 0;
875         }
876         
877         return _totalSupply;
878 
879     }
880 
881     /**
882      * @dev See {IERC20-balanceOf}.
883      */
884     function balanceOf(address account) public view override returns (uint256) {
885         if(isBurnt()) {
886             return 0;
887         }
888         
889         return _balances[account];
890 
891     }
892 
893     /**
894      * @dev See {IERC20-transfer}.
895      *
896      * Requirements:
897      *
898      * - `recipient` cannot be the zero address.
899      * - the caller must have a balance of at least `amount`.
900      */
901     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
902         
903         require(!isBurnt(), "Everything burnt");
904         
905         _transfer(_msgSender(), recipient, amount);
906         return true;
907 
908     }
909 
910     /**
911      * @dev See {IERC20-allowance}.
912      */
913     function allowance(address owner, address spender) public view virtual override returns (uint256) {
914         if(isBurnt()) {
915             return 0;
916         }
917         
918         return _allowances[owner][spender];
919     }
920 
921     /**
922      * @dev See {IERC20-approve}.
923      *
924      * Requirements:
925      *
926      * - `spender` cannot be the zero address.
927      */
928     function approve(address spender, uint256 amount) public virtual override returns (bool) {
929         
930         require(!isBurnt(), "Everything burnt");
931         
932         _approve(_msgSender(), spender, amount);
933         return true;
934 
935     }
936 
937     /**
938      * @dev See {IERC20-transferFrom}.
939      *
940      * Emits an {Approval} event indicating the updated allowance. This is not
941      * required by the EIP. See the note at the beginning of {ERC20};
942      *
943      * Requirements:
944      * - `sender` and `recipient` cannot be the zero address.
945      * - `sender` must have a balance of at least `amount`.
946      * - the caller must have allowance for ``sender``'s tokens of at least
947      * `amount`.
948      */
949     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
950         
951         require(!isBurnt(), "Everything burnt");
952         
953         _transfer(sender, recipient, amount);
954         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
955         return true;
956 
957     }
958 
959     /**
960      * @dev Atomically increases the allowance granted to `spender` by the caller.
961      *
962      * This is an alternative to {approve} that can be used as a mitigation for
963      * problems described in {IERC20-approve}.
964      *
965      * Emits an {Approval} event indicating the updated allowance.
966      *
967      * Requirements:
968      *
969      * - `spender` cannot be the zero address.
970      */
971     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
972         
973         require(!isBurnt(), "Everything burnt");
974         
975         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
976         return true;
977 
978     }
979 
980     /**
981      * @dev Atomically decreases the allowance granted to `spender` by the caller.
982      *
983      * This is an alternative to {approve} that can be used as a mitigation for
984      * problems described in {IERC20-approve}.
985      *
986      * Emits an {Approval} event indicating the updated allowance.
987      *
988      * Requirements:
989      *
990      * - `spender` cannot be the zero address.
991      * - `spender` must have allowance for the caller of at least
992      * `subtractedValue`.
993      */
994     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
995         
996         require(!isBurnt(), "Everything burnt");
997         
998         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
999         return true;
1000 
1001     }
1002 
1003     /**
1004      * @dev Moves tokens `amount` from `sender` to `recipient`.
1005      *
1006      * This is internal function is equivalent to {transfer}, and can be used to
1007      * e.g. implement automatic token fees, slashing mechanisms, etc.
1008      *
1009      * Emits a {Transfer} event.
1010      *
1011      * Requirements:
1012      *
1013      * - `sender` cannot be the zero address.
1014      * - `recipient` cannot be the zero address.
1015      * - `sender` must have a balance of at least `amount`.
1016      */
1017     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1018         require(sender != address(0), "ERC20: transfer from the zero address");
1019         require(recipient != address(0), "ERC20: transfer to the zero address");
1020 
1021         _beforeTokenTransfer(sender, recipient, amount);
1022 
1023         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1024         _balances[recipient] = _balances[recipient].add(amount);
1025         emit Transfer(sender, recipient, amount);
1026     }
1027     
1028     function _updateLockedAmount(address account, uint256 amount) internal {
1029         
1030         _balances[account] = _balances[account].sub(amount, "Low balance");
1031         
1032     }
1033     
1034     function _updateBalanceAfterUnlock(address account, uint256 amount) internal {
1035         
1036         _balances[account] = _balances[account].add(amount);
1037         
1038     }
1039 
1040     function _mint(address account, uint256 amount) internal virtual {
1041         require(account != address(0), "ERC20: mint to the zero address");
1042 
1043         _beforeTokenTransfer(address(0), account, amount);
1044 
1045         _totalSupply = _totalSupply.add(amount);
1046         _balances[account] = _balances[account].add(amount);
1047         emit Transfer(address(0), account, amount);
1048     }
1049 
1050     function _burn(address account, uint256 amount) internal virtual {
1051         require(account != address(0), "ERC20: burn from the zero address");
1052 
1053         _beforeTokenTransfer(account, address(0), amount);
1054 
1055         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1056         _totalSupply = _totalSupply.sub(amount);
1057         emit Transfer(account, address(0), amount);
1058     }
1059 
1060     function _approve(address owner, address spender, uint256 amount) internal virtual {
1061         require(owner != address(0), "ERC20: approve from the zero address");
1062         require(spender != address(0), "ERC20: approve to the zero address");
1063 
1064         _allowances[owner][spender] = amount;
1065         emit Approval(owner, spender, amount);
1066     }
1067 
1068     function _setupDecimals(uint8 decimals_) internal {
1069         _decimals = decimals_;
1070     }
1071     
1072     function isBurnt() public view returns(bool) {
1073         return _allBurnt;
1074     }
1075     
1076     function _setBurnt() internal {
1077         require(!_allBurnt, "Already burnt everything");
1078         
1079         _allBurnt = true;
1080     }
1081 
1082     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1083 }
1084 
1085 pragma solidity 0.6.6;
1086 
1087 contract BusyToken is ERC20, AccessControlMixin {
1088     
1089     struct LockedTokens {
1090         bool exists;
1091         uint256 totalAmount;
1092         uint256 releasedAmount;
1093         uint256 startedAt;
1094         uint256 releaseAt;
1095     }
1096     
1097     event Vested(address indexed recipient, uint256 amount, uint256 startedAt, uint256 releaseAt);
1098     event ReleasedVesting(address indexed recipient, uint256 totalAmount, uint256 totalReleased, uint256 releasedNow);
1099     
1100     event Burnt(address invoker, uint256 amount);
1101 
1102     mapping (address => LockedTokens) private _lockedTokens;
1103     
1104     function _attemptLock(address recipient, uint256 numerator, uint256 denominator, uint256 releaseAt) internal only(DEFAULT_ADMIN_ROLE) {
1105         
1106         LockedTokens memory entry = _lockedTokens[recipient];
1107         require(!entry.exists, "Bad vesting recipient address");
1108         
1109         if(releaseAt <= now) { return; }
1110         
1111         uint256 amount = _calculatePercentage(totalSupply(), numerator, denominator);
1112 
1113         _updateLockedAmount(msg.sender, amount);
1114         _lockedTokens[recipient] = LockedTokens(true, amount, 0, now, releaseAt);
1115 
1116         emit Vested(recipient, amount, now, releaseAt);
1117 
1118     }
1119     
1120     function _calculatePercentage(uint256 total, uint256 numerator, uint256 denominator) internal pure returns (uint256) {
1121 
1122         return total.mul(numerator).div(denominator);
1123         
1124     }
1125 
1126     constructor(string memory name_, string memory symbol_)
1127         public
1128         ERC20(name_, symbol_)
1129     {
1130     
1131         _setupContractId("BUSY Token");
1132         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1133 
1134         uint256 amount = 255 * (10 ** 6) * (10**18);
1135 
1136         _mint(msg.sender, amount);
1137         grantRole(DEFAULT_ADMIN_ROLE, 0x79a2CcB4E79Fa310547fdb208741A345A56f7291);
1138         grantRole(DEFAULT_ADMIN_ROLE, 0xfa86c5C86fd7D04D0F5f49eb93a0FA6681866dfe);
1139         grantRole(DEFAULT_ADMIN_ROLE, 0x9c128FfF01951f7cB8a1332B2655a0F87170Cced);
1140         grantRole(DEFAULT_ADMIN_ROLE, 0x5dC5370FC946C07629A0Aa08E9D41d5bBC9Dc1c0);
1141     }
1142 
1143     function multibeneficiaryVestingV1(address recipient, uint256 amount, uint256 numerator, uint256 denominator, uint256 releaseAt) external only(DEFAULT_ADMIN_ROLE) {
1144         
1145         require(!isBurnt(), "Everything burnt");
1146 
1147         require(recipient != address(0), "Bad recipient address");
1148         require(amount != 0, "Bad vesting amount");
1149         require(balanceOf(msg.sender) > amount, "Low balance");
1150         
1151         LockedTokens memory entry = _lockedTokens[recipient];
1152         require(!entry.exists, "Vesting not possible in this address");
1153         require(releaseAt > now, "Release time not in future");
1154 
1155         uint256 _amount = _calculatePercentage(amount, numerator, denominator);
1156         
1157         _transfer(msg.sender, recipient, _amount);
1158 
1159         _updateLockedAmount(msg.sender, amount.sub(_amount));
1160 
1161         _lockedTokens[recipient] = LockedTokens(true, amount.sub(_amount), 0, now, releaseAt);
1162         emit Vested(recipient, amount, now, releaseAt);
1163 
1164     }
1165     
1166     function multibeneficiaryVestingV2(address recipient, uint256 amount, uint256 startAt, uint256 releaseAt) public only(DEFAULT_ADMIN_ROLE) {
1167         
1168         require(!isBurnt(), "Everything burnt");
1169 
1170         require(recipient != address(0), "Bad recipient address");
1171         require(amount != 0, "Bad vesting amount");
1172         require(balanceOf(msg.sender) > amount, "Low balance");
1173         
1174         LockedTokens memory entry = _lockedTokens[recipient];
1175         require(!entry.exists, "Vesting not possible in this address");
1176         require(startAt > now, "Starting time not in future");
1177         require(releaseAt > now, "Release time not in future");
1178         require(startAt < releaseAt, "Release time > starting time of vesting");
1179 
1180         _updateLockedAmount(msg.sender, amount);
1181 
1182         _lockedTokens[recipient] = LockedTokens(true, amount, 0, startAt, releaseAt);
1183 
1184         emit Vested(recipient, amount, startAt, releaseAt);
1185 
1186     }
1187     
1188     function getLockedTokens(address owner) external view returns(uint256, uint256, uint256, uint256) {
1189         
1190         require(!isBurnt(), "Everything burnt");
1191         
1192         LockedTokens memory entry = _lockedTokens[owner];
1193         if(!entry.exists) {
1194             return (0, 0, 0, 0);
1195         }
1196         
1197         return (entry.totalAmount, entry.releasedAmount, entry.startedAt, entry.releaseAt);
1198         
1199     }
1200     function attemptUnlock(address owner) external {
1201         
1202         require(!isBurnt(), "Everything burnt");
1203 
1204         require(owner == msg.sender, "Access declined");
1205 
1206         LockedTokens memory entry = _lockedTokens[owner];
1207         require(entry.exists, "Nothing vested in this address");
1208         
1209 
1210         if(entry.startedAt > now) { return; }
1211         if(entry.releaseAt <= now) {
1212             if(entry.totalAmount == entry.releasedAmount) { return; }
1213             
1214             uint256 releaseNow = entry.totalAmount.sub(entry.releasedAmount);
1215             
1216             _updateBalanceAfterUnlock(owner, releaseNow);
1217             entry.releasedAmount = entry.totalAmount;
1218             _lockedTokens[owner] = entry;
1219             emit ReleasedVesting(owner, entry.totalAmount, entry.releasedAmount, releaseNow);
1220 
1221             return;
1222 
1223         }
1224         uint256 releasable = entry.totalAmount.mul(now.sub(entry.startedAt)).div(entry.releaseAt.sub(entry.startedAt));
1225         require(releasable != 0, "Nothing to release now");
1226         require(releasable > entry.releasedAmount, "Nothing to release now");
1227         uint256 releaseNow = releasable.sub(entry.releasedAmount);
1228         _updateBalanceAfterUnlock(owner, releaseNow);
1229         entry.releasedAmount = releasable;
1230         _lockedTokens[owner] = entry;
1231         emit ReleasedVesting(owner, entry.totalAmount, entry.releasedAmount, releaseNow);
1232     }
1233     
1234     function burn() external only(DEFAULT_ADMIN_ROLE) {
1235         _setBurnt();
1236         
1237         emit Burnt(msg.sender, totalSupply());
1238     }
1239 }