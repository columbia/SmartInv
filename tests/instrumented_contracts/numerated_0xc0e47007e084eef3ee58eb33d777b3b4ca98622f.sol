1 // File: contracts\utils\EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.0;
6 
7 /**
8  * @dev Library for managing
9  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
10  * types.
11  *
12  * Sets have the following properties:
13  *
14  * - Elements are added, removed, and checked for existence in constant time
15  * (O(1)).
16  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
17  *
18  * ```
19  * contract Example {
20  *     // Add the library methods
21  *     using EnumerableSet for EnumerableSet.AddressSet;
22  *
23  *     // Declare a set state variable
24  *     EnumerableSet.AddressSet private mySet;
25  * }
26  * ```
27  *
28  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
29  * (`UintSet`) are supported.
30  */
31 library EnumerableSet {
32     // To implement this library for multiple types with as little code
33     // repetition as possible, we write it in terms of a generic Set type with
34     // bytes32 values.
35     // The Set implementation uses private functions, and user-facing
36     // implementations (such as AddressSet) are just wrappers around the
37     // underlying Set.
38     // This means that we can only create new EnumerableSets for types that fit
39     // in bytes32.
40 
41     struct Set {
42         // Storage of set values
43         bytes32[] _values;
44 
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping (bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) { // Equivalent to contains(set, value)
79             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
80             // the array, and then remove the last element (sometimes called as 'swap and pop').
81             // This modifies the order of the array, as noted in {at}.
82 
83             uint256 toDeleteIndex = valueIndex - 1;
84             uint256 lastIndex = set._values.length - 1;
85 
86             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
87             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
88 
89             bytes32 lastvalue = set._values[lastIndex];
90 
91             // Move the last value to the index where the value to delete is
92             set._values[toDeleteIndex] = lastvalue;
93             // Update the index for the moved value
94             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value) private view returns (bool) {
112         return set._indexes[value] != 0;
113     }
114 
115     /**
116      * @dev Returns the number of values on the set. O(1).
117      */
118     function _length(Set storage set) private view returns (uint256) {
119         return set._values.length;
120     }
121 
122     /**
123      * @dev Returns the value stored at position `index` in the set. O(1).
124      *
125      * Note that there are no guarantees on the ordering of values inside the
126      * array, and it may change when more values are added or removed.
127      *
128      * Requirements:
129      *
130      * - `index` must be strictly less than {length}.
131      */
132     function _at(Set storage set, uint256 index) private view returns (bytes32) {
133         require(set._values.length > index, "EnumerableSet: index out of bounds");
134         return set._values[index];
135     }
136 
137     // AddressSet
138 
139     struct AddressSet {
140         Set _inner;
141     }
142 
143     /**
144      * @dev Add a value to a set. O(1).
145      *
146      * Returns true if the value was added to the set, that is if it was not
147      * already present.
148      */
149     function add(AddressSet storage set, address value) internal returns (bool) {
150         return _add(set._inner, bytes32(uint256(value)));
151     }
152 
153     /**
154      * @dev Removes a value from a set. O(1).
155      *
156      * Returns true if the value was removed from the set, that is if it was
157      * present.
158      */
159     function remove(AddressSet storage set, address value) internal returns (bool) {
160         return _remove(set._inner, bytes32(uint256(value)));
161     }
162 
163     /**
164      * @dev Returns true if the value is in the set. O(1).
165      */
166     function contains(AddressSet storage set, address value) internal view returns (bool) {
167         return _contains(set._inner, bytes32(uint256(value)));
168     }
169 
170     /**
171      * @dev Returns the number of values in the set. O(1).
172      */
173     function length(AddressSet storage set) internal view returns (uint256) {
174         return _length(set._inner);
175     }
176 
177     /**
178      * @dev Returns the value stored at position `index` in the set. O(1).
179      *
180      * Note that there are no guarantees on the ordering of values inside the
181      * array, and it may change when more values are added or removed.
182      *
183      * Requirements:
184      *
185      * - `index` must be strictly less than {length}.
186      */
187     function at(AddressSet storage set, uint256 index) internal view returns (address) {
188         return address(uint256(_at(set._inner, index)));
189     }
190 
191 
192     // UintSet
193 
194     struct UintSet {
195         Set _inner;
196     }
197 
198     /**
199      * @dev Add a value to a set. O(1).
200      *
201      * Returns true if the value was added to the set, that is if it was not
202      * already present.
203      */
204     function add(UintSet storage set, uint256 value) internal returns (bool) {
205         return _add(set._inner, bytes32(value));
206     }
207 
208     /**
209      * @dev Removes a value from a set. O(1).
210      *
211      * Returns true if the value was removed from the set, that is if it was
212      * present.
213      */
214     function remove(UintSet storage set, uint256 value) internal returns (bool) {
215         return _remove(set._inner, bytes32(value));
216     }
217 
218     /**
219      * @dev Returns true if the value is in the set. O(1).
220      */
221     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
222         return _contains(set._inner, bytes32(value));
223     }
224 
225     /**
226      * @dev Returns the number of values on the set. O(1).
227      */
228     function length(UintSet storage set) internal view returns (uint256) {
229         return _length(set._inner);
230     }
231 
232     /**
233      * @dev Returns the value stored at position `index` in the set. O(1).
234      *
235      * Note that there are no guarantees on the ordering of values inside the
236      * array, and it may change when more values are added or removed.
237      *
238      * Requirements:
239      *
240      * - `index` must be strictly less than {length}.
241      */
242     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
243         return uint256(_at(set._inner, index));
244     }
245 }
246 
247 // File: contracts\utils\Address.sol
248 
249 pragma solidity ^0.7.0;
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // This method relies in extcodesize, which returns 0 for contracts in
274         // construction, since the code is only stored at the end of the
275         // constructor execution.
276 
277         uint256 size;
278         // solhint-disable-next-line no-inline-assembly
279         assembly { size := extcodesize(account) }
280         return size > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
303         (bool success, ) = recipient.call{ value: amount }("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain`call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326         return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
336         return _functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         return _functionCallWithValue(target, data, value, errorMessage);
363     }
364 
365     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 // File: contracts\GSN\Context.sol
390 
391 
392 pragma solidity ^0.7.0;
393 
394 /*
395  * @dev Provides information about the current execution context, including the
396  * sender of the transaction and its data. While these are generally available
397  * via msg.sender and msg.data, they should not be accessed in such a direct
398  * manner, since when dealing with GSN meta-transactions the account sending and
399  * paying for execution may not be the actual sender (as far as an application
400  * is concerned).
401  *
402  * This contract is only required for intermediate, library-like contracts.
403  */
404 abstract contract Context {
405     function _msgSender() internal view virtual returns (address payable) {
406         return msg.sender;
407     }
408 
409     function _msgData() internal view virtual returns (bytes memory) {
410         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
411         return msg.data;
412     }
413 }
414 
415 // File: contracts\access\AccessControl.sol
416 
417 pragma solidity ^0.7.0;
418 
419 
420 
421 
422 /**
423  * @dev Contract module that allows children to implement role-based access
424  * control mechanisms.
425  *
426  * Roles are referred to by their `bytes32` identifier. These should be exposed
427  * in the external API and be unique. The best way to achieve this is by
428  * using `public constant` hash digests:
429  *
430  * ```
431  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
432  * ```
433  *
434  * Roles can be used to represent a set of permissions. To restrict access to a
435  * function call, use {hasRole}:
436  *
437  * ```
438  * function foo() public {
439  *     require(hasRole(MY_ROLE, msg.sender));
440  *     ...
441  * }
442  * ```
443  *
444  * Roles can be granted and revoked dynamically via the {grantRole} and
445  * {revokeRole} functions. Each role has an associated admin role, and only
446  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
447  *
448  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
449  * that only accounts with this role will be able to grant or revoke other
450  * roles. More complex role relationships can be created by using
451  * {_setRoleAdmin}.
452  *
453  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
454  * grant and revoke this role. Extra precautions should be taken to secure
455  * accounts that have been granted it.
456  */
457 abstract contract AccessControl is Context {
458     using EnumerableSet for EnumerableSet.AddressSet;
459     using Address for address;
460 
461     struct RoleData {
462         EnumerableSet.AddressSet members;
463         bytes32 adminRole;
464     }
465 
466     mapping (bytes32 => RoleData) private _roles;
467 
468     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
469 
470     /**
471      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
472      *
473      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
474      * {RoleAdminChanged} not being emitted signaling this.
475      *
476      * _Available since v3.1._
477      */
478     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
479 
480     /**
481      * @dev Emitted when `account` is granted `role`.
482      *
483      * `sender` is the account that originated the contract call, an admin role
484      * bearer except when using {_setupRole}.
485      */
486     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
487 
488     /**
489      * @dev Emitted when `account` is revoked `role`.
490      *
491      * `sender` is the account that originated the contract call:
492      *   - if using `revokeRole`, it is the admin role bearer
493      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
494      */
495     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
496 
497     /**
498      * @dev Returns `true` if `account` has been granted `role`.
499      */
500     function hasRole(bytes32 role, address account) public view returns (bool) {
501         return _roles[role].members.contains(account);
502     }
503 
504     /**
505      * @dev Returns the number of accounts that have `role`. Can be used
506      * together with {getRoleMember} to enumerate all bearers of a role.
507      */
508     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
509         return _roles[role].members.length();
510     }
511 
512     /**
513      * @dev Returns one of the accounts that have `role`. `index` must be a
514      * value between 0 and {getRoleMemberCount}, non-inclusive.
515      *
516      * Role bearers are not sorted in any particular way, and their ordering may
517      * change at any point.
518      *
519      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
520      * you perform all queries on the same block. See the following
521      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
522      * for more information.
523      */
524     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
525         return _roles[role].members.at(index);
526     }
527 
528     /**
529      * @dev Returns the admin role that controls `role`. See {grantRole} and
530      * {revokeRole}.
531      *
532      * To change a role's admin, use {_setRoleAdmin}.
533      */
534     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
535         return _roles[role].adminRole;
536     }
537 
538     /**
539      * @dev Grants `role` to `account`.
540      *
541      * If `account` had not been already granted `role`, emits a {RoleGranted}
542      * event.
543      *
544      * Requirements:
545      *
546      * - the caller must have ``role``'s admin role.
547      */
548     function grantRole(bytes32 role, address account) public virtual {
549         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
550 
551         _grantRole(role, account);
552     }
553 
554     /**
555      * @dev Revokes `role` from `account`.
556      *
557      * If `account` had been granted `role`, emits a {RoleRevoked} event.
558      *
559      * Requirements:
560      *
561      * - the caller must have ``role``'s admin role.
562      */
563     function revokeRole(bytes32 role, address account) public virtual {
564         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
565 
566         _revokeRole(role, account);
567     }
568 
569     /**
570      * @dev Revokes `role` from the calling account.
571      *
572      * Roles are often managed via {grantRole} and {revokeRole}: this function's
573      * purpose is to provide a mechanism for accounts to lose their privileges
574      * if they are compromised (such as when a trusted device is misplaced).
575      *
576      * If the calling account had been granted `role`, emits a {RoleRevoked}
577      * event.
578      *
579      * Requirements:
580      *
581      * - the caller must be `account`.
582      */
583     function renounceRole(bytes32 role, address account) public virtual {
584         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
585 
586         _revokeRole(role, account);
587     }
588 
589     /**
590      * @dev Grants `role` to `account`.
591      *
592      * If `account` had not been already granted `role`, emits a {RoleGranted}
593      * event. Note that unlike {grantRole}, this function doesn't perform any
594      * checks on the calling account.
595      *
596      * [WARNING]
597      * ====
598      * This function should only be called from the constructor when setting
599      * up the initial roles for the system.
600      *
601      * Using this function in any other way is effectively circumventing the admin
602      * system imposed by {AccessControl}.
603      * ====
604      */
605     function _setupRole(bytes32 role, address account) internal virtual {
606         _grantRole(role, account);
607     }
608 
609     /**
610      * @dev Sets `adminRole` as ``role``'s admin role.
611      *
612      * Emits a {RoleAdminChanged} event.
613      */
614     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
615         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
616         _roles[role].adminRole = adminRole;
617     }
618 
619     function _grantRole(bytes32 role, address account) private {
620         if (_roles[role].members.add(account)) {
621             emit RoleGranted(role, account, _msgSender());
622         }
623     }
624 
625     function _revokeRole(bytes32 role, address account) private {
626         if (_roles[role].members.remove(account)) {
627             emit RoleRevoked(role, account, _msgSender());
628         }
629     }
630 }
631 
632 // File: contracts\ERC20\IERC20.sol
633 
634 pragma solidity ^0.7.0;
635 
636 /**
637  * @dev Interface of the ERC20 standard as defined in the EIP.
638  */
639 interface IERC20 {
640     /**
641      * @dev Returns the amount of tokens in existence.
642      */
643     function totalSupply() external view returns (uint256);
644 
645     /**
646      * @dev Returns the amount of tokens owned by `account`.
647      */
648     function balanceOf(address account) external view returns (uint256);
649 
650     /**
651      * @dev Moves `amount` tokens from the caller's account to `recipient`.
652      *
653      * Returns a boolean value indicating whether the operation succeeded.
654      *
655      * Emits a {Transfer} event.
656      */
657     function transfer(address recipient, uint256 amount) external returns (bool);
658 
659     /**
660      * @dev Returns the remaining number of tokens that `spender` will be
661      * allowed to spend on behalf of `owner` through {transferFrom}. This is
662      * zero by default.
663      *
664      * This value changes when {approve} or {transferFrom} are called.
665      */
666     function allowance(address owner, address spender) external view returns (uint256);
667 
668     /**
669      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
670      *
671      * Returns a boolean value indicating whether the operation succeeded.
672      *
673      * IMPORTANT: Beware that changing an allowance with this method brings the risk
674      * that someone may use both the old and the new allowance by unfortunate
675      * transaction ordering. One possible solution to mitigate this race
676      * condition is to first reduce the spender's allowance to 0 and set the
677      * desired value afterwards:
678      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
679      *
680      * Emits an {Approval} event.
681      */
682     function approve(address spender, uint256 amount) external returns (bool);
683 
684     /**
685      * @dev Moves `amount` tokens from `sender` to `recipient` using the
686      * allowance mechanism. `amount` is then deducted from the caller's
687      * allowance.
688      *
689      * Returns a boolean value indicating whether the operation succeeded.
690      *
691      * Emits a {Transfer} event.
692      */
693     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
694 
695     /**
696      * @dev Emitted when `value` tokens are moved from one account (`from`) to
697      * another (`to`).
698      *
699      * Note that `value` may be zero.
700      */
701     event Transfer(address indexed from, address indexed to, uint256 value);
702 
703     /**
704      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
705      * a call to {approve}. `value` is the new allowance.
706      */
707     event Approval(address indexed owner, address indexed spender, uint256 value);
708 }
709 
710 // File: contracts\math\SafeMath.sol
711 
712 pragma solidity ^0.7.0;
713 
714 /**
715  * @dev Wrappers over Solidity's arithmetic operations with added overflow
716  * checks.
717  *
718  * Arithmetic operations in Solidity wrap on overflow. This can easily result
719  * in bugs, because programmers usually assume that an overflow raises an
720  * error, which is the standard behavior in high level programming languages.
721  * `SafeMath` restores this intuition by reverting the transaction when an
722  * operation overflows.
723  *
724  * Using this library instead of the unchecked operations eliminates an entire
725  * class of bugs, so it's recommended to use it always.
726  */
727 library SafeMath {
728     /**
729      * @dev Returns the addition of two unsigned integers, reverting on
730      * overflow.
731      *
732      * Counterpart to Solidity's `+` operator.
733      *
734      * Requirements:
735      *
736      * - Addition cannot overflow.
737      */
738     function add(uint256 a, uint256 b) internal pure returns (uint256) {
739         uint256 c = a + b;
740         require(c >= a, "SafeMath: addition overflow");
741 
742         return c;
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, reverting on
747      * overflow (when the result is negative).
748      *
749      * Counterpart to Solidity's `-` operator.
750      *
751      * Requirements:
752      *
753      * - Subtraction cannot overflow.
754      */
755     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
756         return sub(a, b, "SafeMath: subtraction overflow");
757     }
758 
759     /**
760      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
761      * overflow (when the result is negative).
762      *
763      * Counterpart to Solidity's `-` operator.
764      *
765      * Requirements:
766      *
767      * - Subtraction cannot overflow.
768      */
769     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
770         require(b <= a, errorMessage);
771         uint256 c = a - b;
772 
773         return c;
774     }
775 
776     /**
777      * @dev Returns the multiplication of two unsigned integers, reverting on
778      * overflow.
779      *
780      * Counterpart to Solidity's `*` operator.
781      *
782      * Requirements:
783      *
784      * - Multiplication cannot overflow.
785      */
786     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
787         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
788         // benefit is lost if 'b' is also tested.
789         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
790         if (a == 0) {
791             return 0;
792         }
793 
794         uint256 c = a * b;
795         require(c / a == b, "SafeMath: multiplication overflow");
796 
797         return c;
798     }
799 
800     /**
801      * @dev Returns the integer division of two unsigned integers. Reverts on
802      * division by zero. The result is rounded towards zero.
803      *
804      * Counterpart to Solidity's `/` operator. Note: this function uses a
805      * `revert` opcode (which leaves remaining gas untouched) while Solidity
806      * uses an invalid opcode to revert (consuming all remaining gas).
807      *
808      * Requirements:
809      *
810      * - The divisor cannot be zero.
811      */
812     function div(uint256 a, uint256 b) internal pure returns (uint256) {
813         return div(a, b, "SafeMath: division by zero");
814     }
815 
816     /**
817      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
818      * division by zero. The result is rounded towards zero.
819      *
820      * Counterpart to Solidity's `/` operator. Note: this function uses a
821      * `revert` opcode (which leaves remaining gas untouched) while Solidity
822      * uses an invalid opcode to revert (consuming all remaining gas).
823      *
824      * Requirements:
825      *
826      * - The divisor cannot be zero.
827      */
828     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
829         require(b > 0, errorMessage);
830         uint256 c = a / b;
831         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
832 
833         return c;
834     }
835 
836     /**
837      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
838      * Reverts when dividing by zero.
839      *
840      * Counterpart to Solidity's `%` operator. This function uses a `revert`
841      * opcode (which leaves remaining gas untouched) while Solidity uses an
842      * invalid opcode to revert (consuming all remaining gas).
843      *
844      * Requirements:
845      *
846      * - The divisor cannot be zero.
847      */
848     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
849         return mod(a, b, "SafeMath: modulo by zero");
850     }
851 
852     /**
853      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
854      * Reverts with custom message when dividing by zero.
855      *
856      * Counterpart to Solidity's `%` operator. This function uses a `revert`
857      * opcode (which leaves remaining gas untouched) while Solidity uses an
858      * invalid opcode to revert (consuming all remaining gas).
859      *
860      * Requirements:
861      *
862      * - The divisor cannot be zero.
863      */
864     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
865         require(b != 0, errorMessage);
866         return a % b;
867     }
868 }
869 
870 // File: contracts\ERC20\ERC20.sol
871 
872 pragma solidity ^0.7.0;
873 
874 
875 
876 
877 
878 /**
879  * @dev Implementation of the {IERC20} interface.
880  *
881  * This implementation is agnostic to the way tokens are created. This means
882  * that a supply mechanism has to be added in a derived contract using {_mint}.
883  * For a generic mechanism see {ERC20PresetMinterPauser}.
884  *
885  * TIP: For a detailed writeup see our guide
886  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
887  * to implement supply mechanisms].
888  *
889  * We have followed general OpenZeppelin guidelines: functions revert instead
890  * of returning `false` on failure. This behavior is nonetheless conventional
891  * and does not conflict with the expectations of ERC20 applications.
892  *
893  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
894  * This allows applications to reconstruct the allowance for all accounts just
895  * by listening to said events. Other implementations of the EIP may not emit
896  * these events, as it isn't required by the specification.
897  *
898  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
899  * functions have been added to mitigate the well-known issues around setting
900  * allowances. See {IERC20-approve}.
901  */
902 contract ERC20 is Context, IERC20 {
903     using SafeMath for uint256;
904     using Address for address;
905 
906     mapping (address => uint256) private _balances;
907 
908     mapping (address => mapping (address => uint256)) private _allowances;
909 
910     uint256 private _totalSupply;
911 
912     string private _name;
913     string private _symbol;
914     uint8 private _decimals;
915 
916     /**
917      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
918      * a default value of 18.
919      *
920      * To select a different value for {decimals}, use {_setupDecimals}.
921      *
922      * All three of these values are immutable: they can only be set once during
923      * construction.
924      */
925     constructor (string memory name, string memory symbol) public {
926         _name = name; // StarCurve
927         _symbol = symbol; // XSTAR
928         _decimals = 18;
929     }
930 
931     /**
932      * @dev Returns the name of the ERC20.
933      */
934     function name() public view returns (string memory) {
935         return _name;
936     }
937 
938     /**
939      * @dev Returns the symbol of the ERC20, usually a shorter version of the
940      * name.
941      */
942     function symbol() public view returns (string memory) {
943         return _symbol;
944     }
945 
946     /**
947      * @dev Returns the number of decimals used to get its user representation.
948      * For example, if `decimals` equals `2`, a balance of `505` tokens should
949      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
950      *
951      * Tokens usually opt for a value of 18, imitating the relationship between
952      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
953      * called.
954      *
955      * NOTE: This information is only used for _display_ purposes: it in
956      * no way affects any of the arithmetic of the contract, including
957      * {IERC20-balanceOf} and {IERC20-transfer}.
958      */
959     function decimals() public view returns (uint8) {
960         return _decimals;
961     }
962 
963     /**
964      * @dev See {IERC20-totalSupply}.
965      */
966     function totalSupply() public view override returns (uint256) {
967         return _totalSupply;
968     }
969 
970     /**
971      * @dev See {IERC20-balanceOf}.
972      */
973     function balanceOf(address account) public view override returns (uint256) {
974         return _balances[account];
975     }
976 
977     /**
978      * @dev See {IERC20-transfer}.
979      *
980      * Requirements:
981      *
982      * - `recipient` cannot be the zero address.
983      * - the caller must have a balance of at least `amount`.
984      */
985     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
986         _transfer(_msgSender(), recipient, amount);
987         return true;
988     }
989 
990     /**
991      * @dev See {IERC20-allowance}.
992      */
993     function allowance(address owner, address spender) public view virtual override returns (uint256) {
994         return _allowances[owner][spender];
995     }
996 
997     /**
998      * @dev See {IERC20-approve}.
999      *
1000      * Requirements:
1001      *
1002      * - `spender` cannot be the zero address.
1003      */
1004     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1005         _approve(_msgSender(), spender, amount);
1006         return true;
1007     }
1008 
1009     /**
1010      * @dev See {IERC20-transferFrom}.
1011      *
1012      * Emits an {Approval} event indicating the updated allowance. This is not
1013      * required by the EIP. See the note at the beginning of {ERC20};
1014      *
1015      * Requirements:
1016      * - `sender` and `recipient` cannot be the zero address.
1017      * - `sender` must have a balance of at least `amount`.
1018      * - the caller must have allowance for ``sender``'s tokens of at least
1019      * `amount`.
1020      */
1021     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1022         _transfer(sender, recipient, amount);
1023         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1024         return true;
1025     }
1026 
1027     /**
1028      * @dev Atomically increases the allowance granted to `spender` by the caller.
1029      *
1030      * This is an alternative to {approve} that can be used as a mitigation for
1031      * problems described in {IERC20-approve}.
1032      *
1033      * Emits an {Approval} event indicating the updated allowance.
1034      *
1035      * Requirements:
1036      *
1037      * - `spender` cannot be the zero address.
1038      */
1039     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1040         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1041         return true;
1042     }
1043 
1044     /**
1045      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1046      *
1047      * This is an alternative to {approve} that can be used as a mitigation for
1048      * problems described in {IERC20-approve}.
1049      *
1050      * Emits an {Approval} event indicating the updated allowance.
1051      *
1052      * Requirements:
1053      *
1054      * - `spender` cannot be the zero address.
1055      * - `spender` must have allowance for the caller of at least
1056      * `subtractedValue`.
1057      */
1058     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1059         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1060         return true;
1061     }
1062 
1063     /**
1064      * @dev Moves tokens `amount` from `sender` to `recipient`.
1065      *
1066      * This is internal function is equivalent to {transfer}, and can be used to
1067      * e.g. implement automatic ERC20 fees, slashing mechanisms, etc.
1068      *
1069      * Emits a {Transfer} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `sender` cannot be the zero address.
1074      * - `recipient` cannot be the zero address.
1075      * - `sender` must have a balance of at least `amount`.
1076      */
1077     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1078         require(sender != address(0), "ERC20: transfer from the zero address");
1079         require(recipient != address(0), "ERC20: transfer to the zero address");
1080 
1081         _beforeTokenTransfer(sender, recipient, amount);
1082 
1083         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1084         _balances[recipient] = _balances[recipient].add(amount);
1085         emit Transfer(sender, recipient, amount);
1086     }
1087 
1088     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1089      * the total supply.
1090      *
1091      * Emits a {Transfer} event with `from` set to the zero address.
1092      *
1093      * Requirements
1094      *
1095      * - `to` cannot be the zero address.
1096      */
1097     function _mint(address account, uint256 amount) internal virtual {
1098         require(account != address(0), "ERC20: mint to the zero address");
1099 
1100         _beforeTokenTransfer(address(0), account, amount);
1101 
1102         _totalSupply = _totalSupply.add(amount);
1103         _balances[account] = _balances[account].add(amount);
1104         emit Transfer(address(0), account, amount);
1105     }
1106 
1107     /**
1108      * @dev Destroys `amount` tokens from `account`, reducing the
1109      * total supply.
1110      *
1111      * Emits a {Transfer} event with `to` set to the zero address.
1112      *
1113      * Requirements
1114      *
1115      * - `account` cannot be the zero address.
1116      * - `account` must have at least `amount` tokens.
1117      */
1118     function _burn(address account, uint256 amount) internal virtual {
1119         require(account != address(0), "ERC20: burn from the zero address");
1120 
1121         _beforeTokenTransfer(account, address(0), amount);
1122 
1123         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1124         _totalSupply = _totalSupply.sub(amount);
1125         emit Transfer(account, address(0), amount);
1126     }
1127 
1128     /**
1129      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1130      *
1131      * This is internal function is equivalent to `approve`, and can be used to
1132      * e.g. set automatic allowances for certain subsystems, etc.
1133      *
1134      * Emits an {Approval} event.
1135      *
1136      * Requirements:
1137      *
1138      * - `owner` cannot be the zero address.
1139      * - `spender` cannot be the zero address.
1140      */
1141     function _approve(address owner, address spender, uint256 amount) internal virtual {
1142         require(owner != address(0), "ERC20: approve from the zero address");
1143         require(spender != address(0), "ERC20: approve to the zero address");
1144 
1145         _allowances[owner][spender] = amount;
1146         emit Approval(owner, spender, amount);
1147     }
1148 
1149     /**
1150      * @dev Sets {decimals} to a value other than the default one of 18.
1151      *
1152      * WARNING: This function should only be called from the constructor. Most
1153      * applications that interact with ERC20 contracts will not expect
1154      * {decimals} to ever change, and may work incorrectly if it does.
1155      */
1156     function _setupDecimals(uint8 decimals_) internal {
1157         _decimals = decimals_;
1158     }
1159 
1160     /**
1161      * @dev Hook that is called before any transfer of tokens. This includes
1162      * minting and burning.
1163      *
1164      * Calling conditions:
1165      *
1166      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1167      * will be to transferred to `to`.
1168      * - when `from` is zero, `amount` tokens will be minted for `to`.
1169      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1170      * - `from` and `to` are never both zero.
1171      *
1172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1173      */
1174     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1175 }
1176 
1177 // File: contracts\ERC20\ERC20Burnable.sol
1178 
1179 pragma solidity ^0.7.0;
1180 
1181 
1182 
1183 /**
1184  * @dev Extension of {ERC20} that allows ERC20 holders to destroy both their own
1185  * tokens and those that they have an allowance for, in a way that can be
1186  * recognized off-chain (via event analysis).
1187  */
1188 abstract contract ERC20Burnable is Context, ERC20 {
1189     using SafeMath for uint256;
1190 
1191     /**
1192      * @dev Destroys `amount` tokens from the caller.
1193      *
1194      * See {ERC20-_burn}.
1195      */
1196     function burn(uint256 amount) public virtual {
1197         _burn(_msgSender(), amount);
1198     }
1199 
1200     /**
1201      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1202      * allowance.
1203      *
1204      * See {ERC20-_burn} and {ERC20-allowance}.
1205      *
1206      * Requirements:
1207      *
1208      * - the caller must have allowance for ``accounts``'s tokens of at least
1209      * `amount`.
1210      */
1211     function burnFrom(address account, uint256 amount) public virtual {
1212         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1213 
1214         _approve(account, _msgSender(), decreasedAllowance);
1215         _burn(account, amount);
1216     }
1217 }
1218 
1219 // File: contracts\utils\Pausable.sol
1220 
1221 pragma solidity ^0.7.0;
1222 
1223 
1224 /**
1225  * @dev Contract module which allows children to implement an emergency stop
1226  * mechanism that can be triggered by an authorized account.
1227  *
1228  * This module is used through inheritance. It will make available the
1229  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1230  * the functions of your contract. Note that they will not be pausable by
1231  * simply including this module, only once the modifiers are put in place.
1232  */
1233 contract Pausable is Context {
1234     /**
1235      * @dev Emitted when the pause is triggered by `account`.
1236      */
1237     event Paused(address account);
1238 
1239     /**
1240      * @dev Emitted when the pause is lifted by `account`.
1241      */
1242     event Unpaused(address account);
1243 
1244     bool private _paused;
1245 
1246     /**
1247      * @dev Initializes the contract in unpaused state.
1248      */
1249     constructor () public {
1250         _paused = false;
1251     }
1252 
1253     /**
1254      * @dev Returns true if the contract is paused, and false otherwise.
1255      */
1256     function paused() public view returns (bool) {
1257         return _paused;
1258     }
1259 
1260     /**
1261      * @dev Modifier to make a function callable only when the contract is not paused.
1262      *
1263      * Requirements:
1264      *
1265      * - The contract must not be paused.
1266      */
1267     modifier whenNotPaused() {
1268         require(!_paused, "Pausable: paused");
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Modifier to make a function callable only when the contract is paused.
1274      *
1275      * Requirements:
1276      *
1277      * - The contract must be paused.
1278      */
1279     modifier whenPaused() {
1280         require(_paused, "Pausable: not paused");
1281         _;
1282     }
1283 
1284     /**
1285      * @dev Triggers stopped state.
1286      *
1287      * Requirements:
1288      *
1289      * - The contract must not be paused.
1290      */
1291     function _pause() internal virtual whenNotPaused {
1292         _paused = true;
1293         emit Paused(_msgSender());
1294     }
1295 
1296     /**
1297      * @dev Returns to normal state.
1298      *
1299      * Requirements:
1300      *
1301      * - The contract must be paused.
1302      */
1303     function _unpause() internal virtual whenPaused {
1304         _paused = false;
1305         emit Unpaused(_msgSender());
1306     }
1307 }
1308 
1309 // File: contracts\ERC20\ERC20Pausable.sol
1310 
1311 pragma solidity ^0.7.0;
1312 
1313 
1314 
1315 /**
1316  * @dev ERC20 contracts with pausable contracts transfers, minting and burning.
1317  *
1318  * Useful for scenarios such as preventing trades until the end of an evaluation
1319  * period, or having an emergency switch for freezing all contracts transfers in the
1320  * event of a large bug.
1321  */
1322 abstract contract ERC20Pausable is ERC20, Pausable {
1323     /**
1324      * @dev See {ERC20-_beforeTokenTransfer}.
1325      *
1326      * Requirements:
1327      *
1328      * - the contract must not be paused.
1329      */
1330     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1331         super._beforeTokenTransfer(from, to, amount);
1332 
1333         require(!paused(), "ERC20Pausable: token transfer while paused");
1334     }
1335 }
1336 
1337 // File: contracts\XSTAR.sol
1338 
1339 pragma solidity ^0.7.0;
1340 
1341 
1342 
1343 
1344 
1345 
1346 /**
1347  * @dev {ERC20} contracts, including:
1348  *
1349  *  - ability for holders to burn (destroy) their tokens
1350  *  - a minter role that allows for contracts minting (creation)
1351  *  - a pauser role that allows to stop all contracts transfers
1352  *
1353  * This contract uses {AccessControl} to lock permissioned functions using the
1354  * different roles - head to its documentation for details.
1355  *
1356  * The account that deploys the contract will be granted the minter and pauser
1357  * roles, as well as the default admin role, which will let it grant both minter
1358  * and pauser roles to other accounts.
1359  */
1360 contract XSTAR is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1361     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1362     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1363 
1364     /**
1365      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1366      * account that deploys the contract.
1367      *
1368      * See {ERC20-constructor}.
1369      */
1370     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1371         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1372 
1373         _setupRole(MINTER_ROLE, _msgSender());
1374         _setupRole(PAUSER_ROLE, _msgSender());
1375     }
1376 
1377     /**
1378      * @dev Creates `amount` new tokens for `to`.
1379      *
1380      * See {ERC20-_mint}.
1381      *
1382      * Requirements:
1383      *
1384      * - the caller must have the `MINTER_ROLE`.
1385      */
1386     function mint(address to, uint256 amount) public virtual {
1387         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1388         _mint(to, amount);
1389     }
1390 
1391     /**
1392      * @dev Pauses all contracts transfers.
1393      *
1394      * See {ERC20Pausable} and {Pausable-_pause}.
1395      *
1396      * Requirements:
1397      *
1398      * - the caller must have the `PAUSER_ROLE`.
1399      */
1400     function pause() public virtual {
1401         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1402         _pause();
1403     }
1404 
1405     /**
1406      * @dev Unpauses all contracts transfers.
1407      *
1408      * See {ERC20Pausable} and {Pausable-_unpause}.
1409      *
1410      * Requirements:
1411      *
1412      * - the caller must have the `PAUSER_ROLE`.
1413      */
1414     function unpause() public virtual {
1415         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1416         _unpause();
1417     }
1418 
1419     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1420         super._beforeTokenTransfer(from, to, amount);
1421     }
1422 }