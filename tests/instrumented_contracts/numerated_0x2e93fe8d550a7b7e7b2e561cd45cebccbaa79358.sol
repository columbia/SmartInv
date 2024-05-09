1 // SPDX-License-Identifier: MIT
2 
3 /**
4 Author: GXChain Core Team.
5 Version: 1.0
6 */
7 
8 pragma solidity 0.6.2;
9 pragma experimental ABIEncoderV2;
10 
11 
12 // 
13 /**
14  * @dev Library for managing
15  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
16  * types.
17  *
18  * Sets have the following properties:
19  *
20  * - Elements are added, removed, and checked for existence in constant time
21  * (O(1)).
22  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
23  *
24  * ```
25  * contract Example {
26  *     // Add the library methods
27  *     using EnumerableSet for EnumerableSet.AddressSet;
28  *
29  *     // Declare a set state variable
30  *     EnumerableSet.AddressSet private mySet;
31  * }
32  * ```
33  *
34  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
35  * (`UintSet`) are supported.
36  */
37 library EnumerableSet {
38     // To implement this library for multiple types with as little code
39     // repetition as possible, we write it in terms of a generic Set type with
40     // bytes32 values.
41     // The Set implementation uses private functions, and user-facing
42     // implementations (such as AddressSet) are just wrappers around the
43     // underlying Set.
44     // This means that we can only create new EnumerableSets for types that fit
45     // in bytes32.
46 
47     struct Set {
48         // Storage of set values
49         bytes32[] _values;
50 
51         // Position of the value in the `values` array, plus 1 because index 0
52         // means a value is not in the set.
53         mapping (bytes32 => uint256) _indexes;
54     }
55 
56     /**
57      * @dev Add a value to a set. O(1).
58      *
59      * Returns true if the value was added to the set, that is if it was not
60      * already present.
61      */
62     function _add(Set storage set, bytes32 value) private returns (bool) {
63         if (!_contains(set, value)) {
64             set._values.push(value);
65             // The value is stored at length-1, but we add 1 to all indexes
66             // and use 0 as a sentinel value
67             set._indexes[value] = set._values.length;
68             return true;
69         } else {
70             return false;
71         }
72     }
73 
74     /**
75      * @dev Removes a value from a set. O(1).
76      *
77      * Returns true if the value was removed from the set, that is if it was
78      * present.
79      */
80     function _remove(Set storage set, bytes32 value) private returns (bool) {
81         // We read and store the value's index to prevent multiple reads from the same storage slot
82         uint256 valueIndex = set._indexes[value];
83 
84         if (valueIndex != 0) { // Equivalent to contains(set, value)
85             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
86             // the array, and then remove the last element (sometimes called as 'swap and pop').
87             // This modifies the order of the array, as noted in {at}.
88 
89             uint256 toDeleteIndex = valueIndex - 1;
90             uint256 lastIndex = set._values.length - 1;
91 
92             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
93             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
94 
95             bytes32 lastvalue = set._values[lastIndex];
96 
97             // Move the last value to the index where the value to delete is
98             set._values[toDeleteIndex] = lastvalue;
99             // Update the index for the moved value
100             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
101 
102             // Delete the slot where the moved value was stored
103             set._values.pop();
104 
105             // Delete the index for the deleted slot
106             delete set._indexes[value];
107 
108             return true;
109         } else {
110             return false;
111         }
112     }
113 
114     /**
115      * @dev Returns true if the value is in the set. O(1).
116      */
117     function _contains(Set storage set, bytes32 value) private view returns (bool) {
118         return set._indexes[value] != 0;
119     }
120 
121     /**
122      * @dev Returns the number of values on the set. O(1).
123      */
124     function _length(Set storage set) private view returns (uint256) {
125         return set._values.length;
126     }
127 
128    /**
129     * @dev Returns the value stored at position `index` in the set. O(1).
130     *
131     * Note that there are no guarantees on the ordering of values inside the
132     * array, and it may change when more values are added or removed.
133     *
134     * Requirements:
135     *
136     * - `index` must be strictly less than {length}.
137     */
138     function _at(Set storage set, uint256 index) private view returns (bytes32) {
139         require(set._values.length > index, "EnumerableSet: index out of bounds");
140         return set._values[index];
141     }
142 
143     // AddressSet
144 
145     struct AddressSet {
146         Set _inner;
147     }
148 
149     /**
150      * @dev Add a value to a set. O(1).
151      *
152      * Returns true if the value was added to the set, that is if it was not
153      * already present.
154      */
155     function add(AddressSet storage set, address value) internal returns (bool) {
156         return _add(set._inner, bytes32(uint256(value)));
157     }
158 
159     /**
160      * @dev Removes a value from a set. O(1).
161      *
162      * Returns true if the value was removed from the set, that is if it was
163      * present.
164      */
165     function remove(AddressSet storage set, address value) internal returns (bool) {
166         return _remove(set._inner, bytes32(uint256(value)));
167     }
168 
169     /**
170      * @dev Returns true if the value is in the set. O(1).
171      */
172     function contains(AddressSet storage set, address value) internal view returns (bool) {
173         return _contains(set._inner, bytes32(uint256(value)));
174     }
175 
176     /**
177      * @dev Returns the number of values in the set. O(1).
178      */
179     function length(AddressSet storage set) internal view returns (uint256) {
180         return _length(set._inner);
181     }
182 
183    /**
184     * @dev Returns the value stored at position `index` in the set. O(1).
185     *
186     * Note that there are no guarantees on the ordering of values inside the
187     * array, and it may change when more values are added or removed.
188     *
189     * Requirements:
190     *
191     * - `index` must be strictly less than {length}.
192     */
193     function at(AddressSet storage set, uint256 index) internal view returns (address) {
194         return address(uint256(_at(set._inner, index)));
195     }
196 
197 
198     // UintSet
199 
200     struct UintSet {
201         Set _inner;
202     }
203 
204     /**
205      * @dev Add a value to a set. O(1).
206      *
207      * Returns true if the value was added to the set, that is if it was not
208      * already present.
209      */
210     function add(UintSet storage set, uint256 value) internal returns (bool) {
211         return _add(set._inner, bytes32(value));
212     }
213 
214     /**
215      * @dev Removes a value from a set. O(1).
216      *
217      * Returns true if the value was removed from the set, that is if it was
218      * present.
219      */
220     function remove(UintSet storage set, uint256 value) internal returns (bool) {
221         return _remove(set._inner, bytes32(value));
222     }
223 
224     /**
225      * @dev Returns true if the value is in the set. O(1).
226      */
227     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
228         return _contains(set._inner, bytes32(value));
229     }
230 
231     /**
232      * @dev Returns the number of values on the set. O(1).
233      */
234     function length(UintSet storage set) internal view returns (uint256) {
235         return _length(set._inner);
236     }
237 
238    /**
239     * @dev Returns the value stored at position `index` in the set. O(1).
240     *
241     * Note that there are no guarantees on the ordering of values inside the
242     * array, and it may change when more values are added or removed.
243     *
244     * Requirements:
245     *
246     * - `index` must be strictly less than {length}.
247     */
248     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
249         return uint256(_at(set._inner, index));
250     }
251 }
252 
253 // 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
277         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
278         // for accounts without code, i.e. `keccak256('')`
279         bytes32 codehash;
280         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { codehash := extcodehash(account) }
283         return (codehash != accountHash && codehash != 0x0);
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return _functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         return _functionCallWithValue(target, data, value, errorMessage);
366     }
367 
368     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
369         require(isContract(target), "Address: call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 // 
393 /*
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with GSN meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address payable) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes memory) {
409         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
410         return msg.data;
411     }
412 }
413 
414 // 
415 /**
416  * @dev Contract module that allows children to implement role-based access
417  * control mechanisms.
418  *
419  * Roles are referred to by their `bytes32` identifier. These should be exposed
420  * in the external API and be unique. The best way to achieve this is by
421  * using `public constant` hash digests:
422  *
423  * ```
424  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
425  * ```
426  *
427  * Roles can be used to represent a set of permissions. To restrict access to a
428  * function call, use {hasRole}:
429  *
430  * ```
431  * function foo() public {
432  *     require(hasRole(MY_ROLE, msg.sender));
433  *     ...
434  * }
435  * ```
436  *
437  * Roles can be granted and revoked dynamically via the {grantRole} and
438  * {revokeRole} functions. Each role has an associated admin role, and only
439  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
440  *
441  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
442  * that only accounts with this role will be able to grant or revoke other
443  * roles. More complex role relationships can be created by using
444  * {_setRoleAdmin}.
445  *
446  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
447  * grant and revoke this role. Extra precautions should be taken to secure
448  * accounts that have been granted it.
449  */
450 abstract contract AccessControl is Context {
451     using EnumerableSet for EnumerableSet.AddressSet;
452     using Address for address;
453 
454     struct RoleData {
455         EnumerableSet.AddressSet members;
456         bytes32 adminRole;
457     }
458 
459     mapping (bytes32 => RoleData) private _roles;
460 
461     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
462 
463     /**
464      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
465      *
466      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
467      * {RoleAdminChanged} not being emitted signaling this.
468      *
469      * _Available since v3.1._
470      */
471     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
472 
473     /**
474      * @dev Emitted when `account` is granted `role`.
475      *
476      * `sender` is the account that originated the contract call, an admin role
477      * bearer except when using {_setupRole}.
478      */
479     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
480 
481     /**
482      * @dev Emitted when `account` is revoked `role`.
483      *
484      * `sender` is the account that originated the contract call:
485      *   - if using `revokeRole`, it is the admin role bearer
486      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
487      */
488     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
489 
490     /**
491      * @dev Returns `true` if `account` has been granted `role`.
492      */
493     function hasRole(bytes32 role, address account) public view returns (bool) {
494         return _roles[role].members.contains(account);
495     }
496 
497     /**
498      * @dev Returns the number of accounts that have `role`. Can be used
499      * together with {getRoleMember} to enumerate all bearers of a role.
500      */
501     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
502         return _roles[role].members.length();
503     }
504 
505     /**
506      * @dev Returns one of the accounts that have `role`. `index` must be a
507      * value between 0 and {getRoleMemberCount}, non-inclusive.
508      *
509      * Role bearers are not sorted in any particular way, and their ordering may
510      * change at any point.
511      *
512      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
513      * you perform all queries on the same block. See the following
514      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
515      * for more information.
516      */
517     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
518         return _roles[role].members.at(index);
519     }
520 
521     /**
522      * @dev Returns the admin role that controls `role`. See {grantRole} and
523      * {revokeRole}.
524      *
525      * To change a role's admin, use {_setRoleAdmin}.
526      */
527     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
528         return _roles[role].adminRole;
529     }
530 
531     /**
532      * @dev Grants `role` to `account`.
533      *
534      * If `account` had not been already granted `role`, emits a {RoleGranted}
535      * event.
536      *
537      * Requirements:
538      *
539      * - the caller must have ``role``'s admin role.
540      */
541     function grantRole(bytes32 role, address account) public virtual {
542         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
543 
544         _grantRole(role, account);
545     }
546 
547     /**
548      * @dev Revokes `role` from `account`.
549      *
550      * If `account` had been granted `role`, emits a {RoleRevoked} event.
551      *
552      * Requirements:
553      *
554      * - the caller must have ``role``'s admin role.
555      */
556     function revokeRole(bytes32 role, address account) public virtual {
557         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
558 
559         _revokeRole(role, account);
560     }
561 
562     /**
563      * @dev Revokes `role` from the calling account.
564      *
565      * Roles are often managed via {grantRole} and {revokeRole}: this function's
566      * purpose is to provide a mechanism for accounts to lose their privileges
567      * if they are compromised (such as when a trusted device is misplaced).
568      *
569      * If the calling account had been granted `role`, emits a {RoleRevoked}
570      * event.
571      *
572      * Requirements:
573      *
574      * - the caller must be `account`.
575      */
576     function renounceRole(bytes32 role, address account) public virtual {
577         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
578 
579         _revokeRole(role, account);
580     }
581 
582     /**
583      * @dev Grants `role` to `account`.
584      *
585      * If `account` had not been already granted `role`, emits a {RoleGranted}
586      * event. Note that unlike {grantRole}, this function doesn't perform any
587      * checks on the calling account.
588      *
589      * [WARNING]
590      * ====
591      * This function should only be called from the constructor when setting
592      * up the initial roles for the system.
593      *
594      * Using this function in any other way is effectively circumventing the admin
595      * system imposed by {AccessControl}.
596      * ====
597      */
598     function _setupRole(bytes32 role, address account) internal virtual {
599         _grantRole(role, account);
600     }
601 
602     /**
603      * @dev Sets `adminRole` as ``role``'s admin role.
604      *
605      * Emits a {RoleAdminChanged} event.
606      */
607     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
608         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
609         _roles[role].adminRole = adminRole;
610     }
611 
612     function _grantRole(bytes32 role, address account) private {
613         if (_roles[role].members.add(account)) {
614             emit RoleGranted(role, account, _msgSender());
615         }
616     }
617 
618     function _revokeRole(bytes32 role, address account) private {
619         if (_roles[role].members.remove(account)) {
620             emit RoleRevoked(role, account, _msgSender());
621         }
622     }
623 }
624 
625 // 
626 /**
627  * @dev Interface of the ERC20 standard as defined in the EIP.
628  */
629 interface IERC20 {
630     /**
631      * @dev Returns the amount of tokens in existence.
632      */
633     function totalSupply() external view returns (uint256);
634 
635     /**
636      * @dev Returns the amount of tokens owned by `account`.
637      */
638     function balanceOf(address account) external view returns (uint256);
639 
640     /**
641      * @dev Moves `amount` tokens from the caller's account to `recipient`.
642      *
643      * Returns a boolean value indicating whether the operation succeeded.
644      *
645      * Emits a {Transfer} event.
646      */
647     function transfer(address recipient, uint256 amount) external returns (bool);
648 
649     /**
650      * @dev Returns the remaining number of tokens that `spender` will be
651      * allowed to spend on behalf of `owner` through {transferFrom}. This is
652      * zero by default.
653      *
654      * This value changes when {approve} or {transferFrom} are called.
655      */
656     function allowance(address owner, address spender) external view returns (uint256);
657 
658     /**
659      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
660      *
661      * Returns a boolean value indicating whether the operation succeeded.
662      *
663      * IMPORTANT: Beware that changing an allowance with this method brings the risk
664      * that someone may use both the old and the new allowance by unfortunate
665      * transaction ordering. One possible solution to mitigate this race
666      * condition is to first reduce the spender's allowance to 0 and set the
667      * desired value afterwards:
668      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
669      *
670      * Emits an {Approval} event.
671      */
672     function approve(address spender, uint256 amount) external returns (bool);
673 
674     /**
675      * @dev Moves `amount` tokens from `sender` to `recipient` using the
676      * allowance mechanism. `amount` is then deducted from the caller's
677      * allowance.
678      *
679      * Returns a boolean value indicating whether the operation succeeded.
680      *
681      * Emits a {Transfer} event.
682      */
683     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
684 
685     /**
686      * @dev Emitted when `value` tokens are moved from one account (`from`) to
687      * another (`to`).
688      *
689      * Note that `value` may be zero.
690      */
691     event Transfer(address indexed from, address indexed to, uint256 value);
692 
693     /**
694      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
695      * a call to {approve}. `value` is the new allowance.
696      */
697     event Approval(address indexed owner, address indexed spender, uint256 value);
698 }
699 
700 // 
701 /**
702  * @dev Wrappers over Solidity's arithmetic operations with added overflow
703  * checks.
704  *
705  * Arithmetic operations in Solidity wrap on overflow. This can easily result
706  * in bugs, because programmers usually assume that an overflow raises an
707  * error, which is the standard behavior in high level programming languages.
708  * `SafeMath` restores this intuition by reverting the transaction when an
709  * operation overflows.
710  *
711  * Using this library instead of the unchecked operations eliminates an entire
712  * class of bugs, so it's recommended to use it always.
713  */
714 library SafeMath {
715     /**
716      * @dev Returns the addition of two unsigned integers, reverting on
717      * overflow.
718      *
719      * Counterpart to Solidity's `+` operator.
720      *
721      * Requirements:
722      *
723      * - Addition cannot overflow.
724      */
725     function add(uint256 a, uint256 b) internal pure returns (uint256) {
726         uint256 c = a + b;
727         require(c >= a, "SafeMath: addition overflow");
728 
729         return c;
730     }
731 
732     /**
733      * @dev Returns the subtraction of two unsigned integers, reverting on
734      * overflow (when the result is negative).
735      *
736      * Counterpart to Solidity's `-` operator.
737      *
738      * Requirements:
739      *
740      * - Subtraction cannot overflow.
741      */
742     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
743         return sub(a, b, "SafeMath: subtraction overflow");
744     }
745 
746     /**
747      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
748      * overflow (when the result is negative).
749      *
750      * Counterpart to Solidity's `-` operator.
751      *
752      * Requirements:
753      *
754      * - Subtraction cannot overflow.
755      */
756     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
757         require(b <= a, errorMessage);
758         uint256 c = a - b;
759 
760         return c;
761     }
762 
763     /**
764      * @dev Returns the multiplication of two unsigned integers, reverting on
765      * overflow.
766      *
767      * Counterpart to Solidity's `*` operator.
768      *
769      * Requirements:
770      *
771      * - Multiplication cannot overflow.
772      */
773     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
774         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
775         // benefit is lost if 'b' is also tested.
776         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
777         if (a == 0) {
778             return 0;
779         }
780 
781         uint256 c = a * b;
782         require(c / a == b, "SafeMath: multiplication overflow");
783 
784         return c;
785     }
786 
787     /**
788      * @dev Returns the integer division of two unsigned integers. Reverts on
789      * division by zero. The result is rounded towards zero.
790      *
791      * Counterpart to Solidity's `/` operator. Note: this function uses a
792      * `revert` opcode (which leaves remaining gas untouched) while Solidity
793      * uses an invalid opcode to revert (consuming all remaining gas).
794      *
795      * Requirements:
796      *
797      * - The divisor cannot be zero.
798      */
799     function div(uint256 a, uint256 b) internal pure returns (uint256) {
800         return div(a, b, "SafeMath: division by zero");
801     }
802 
803     /**
804      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
805      * division by zero. The result is rounded towards zero.
806      *
807      * Counterpart to Solidity's `/` operator. Note: this function uses a
808      * `revert` opcode (which leaves remaining gas untouched) while Solidity
809      * uses an invalid opcode to revert (consuming all remaining gas).
810      *
811      * Requirements:
812      *
813      * - The divisor cannot be zero.
814      */
815     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
816         require(b > 0, errorMessage);
817         uint256 c = a / b;
818         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
819 
820         return c;
821     }
822 
823     /**
824      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
825      * Reverts when dividing by zero.
826      *
827      * Counterpart to Solidity's `%` operator. This function uses a `revert`
828      * opcode (which leaves remaining gas untouched) while Solidity uses an
829      * invalid opcode to revert (consuming all remaining gas).
830      *
831      * Requirements:
832      *
833      * - The divisor cannot be zero.
834      */
835     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
836         return mod(a, b, "SafeMath: modulo by zero");
837     }
838 
839     /**
840      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
841      * Reverts with custom message when dividing by zero.
842      *
843      * Counterpart to Solidity's `%` operator. This function uses a `revert`
844      * opcode (which leaves remaining gas untouched) while Solidity uses an
845      * invalid opcode to revert (consuming all remaining gas).
846      *
847      * Requirements:
848      *
849      * - The divisor cannot be zero.
850      */
851     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
852         require(b != 0, errorMessage);
853         return a % b;
854     }
855 }
856 
857 // 
858 /**
859  * @dev Implementation of the {IERC20} interface.
860  *
861  * This implementation is agnostic to the way tokens are created. This means
862  * that a supply mechanism has to be added in a derived contract using {_mint}.
863  * For a generic mechanism see {ERC20PresetMinterPauser}.
864  *
865  * TIP: For a detailed writeup see our guide
866  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
867  * to implement supply mechanisms].
868  *
869  * We have followed general OpenZeppelin guidelines: functions revert instead
870  * of returning `false` on failure. This behavior is nonetheless conventional
871  * and does not conflict with the expectations of ERC20 applications.
872  *
873  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
874  * This allows applications to reconstruct the allowance for all accounts just
875  * by listening to said events. Other implementations of the EIP may not emit
876  * these events, as it isn't required by the specification.
877  *
878  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
879  * functions have been added to mitigate the well-known issues around setting
880  * allowances. See {IERC20-approve}.
881  */
882 contract ERC20 is Context, IERC20 {
883     using SafeMath for uint256;
884     using Address for address;
885 
886     mapping (address => uint256) private _balances;
887 
888     mapping (address => mapping (address => uint256)) private _allowances;
889 
890     uint256 private _totalSupply;
891 
892     string private _name;
893     string private _symbol;
894     uint8 private _decimals;
895 
896     /**
897      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
898      * a default value of 18.
899      *
900      * To select a different value for {decimals}, use {_setupDecimals}.
901      *
902      * All three of these values are immutable: they can only be set once during
903      * construction.
904      */
905     constructor (string memory name, string memory symbol) public {
906         _name = name;
907         _symbol = symbol;
908         _decimals = 18;
909     }
910 
911     /**
912      * @dev Returns the name of the token.
913      */
914     function name() public view returns (string memory) {
915         return _name;
916     }
917 
918     /**
919      * @dev Returns the symbol of the token, usually a shorter version of the
920      * name.
921      */
922     function symbol() public view returns (string memory) {
923         return _symbol;
924     }
925 
926     /**
927      * @dev Returns the number of decimals used to get its user representation.
928      * For example, if `decimals` equals `2`, a balance of `505` tokens should
929      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
930      *
931      * Tokens usually opt for a value of 18, imitating the relationship between
932      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
933      * called.
934      *
935      * NOTE: This information is only used for _display_ purposes: it in
936      * no way affects any of the arithmetic of the contract, including
937      * {IERC20-balanceOf} and {IERC20-transfer}.
938      */
939     function decimals() public view returns (uint8) {
940         return _decimals;
941     }
942 
943     /**
944      * @dev See {IERC20-totalSupply}.
945      */
946     function totalSupply() public view override returns (uint256) {
947         return _totalSupply;
948     }
949 
950     /**
951      * @dev See {IERC20-balanceOf}.
952      */
953     function balanceOf(address account) public view override returns (uint256) {
954         return _balances[account];
955     }
956 
957     /**
958      * @dev See {IERC20-transfer}.
959      *
960      * Requirements:
961      *
962      * - `recipient` cannot be the zero address.
963      * - the caller must have a balance of at least `amount`.
964      */
965     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
966         _transfer(_msgSender(), recipient, amount);
967         return true;
968     }
969 
970     /**
971      * @dev See {IERC20-allowance}.
972      */
973     function allowance(address owner, address spender) public view virtual override returns (uint256) {
974         return _allowances[owner][spender];
975     }
976 
977     /**
978      * @dev See {IERC20-approve}.
979      *
980      * Requirements:
981      *
982      * - `spender` cannot be the zero address.
983      */
984     function approve(address spender, uint256 amount) public virtual override returns (bool) {
985         _approve(_msgSender(), spender, amount);
986         return true;
987     }
988 
989     /**
990      * @dev See {IERC20-transferFrom}.
991      *
992      * Emits an {Approval} event indicating the updated allowance. This is not
993      * required by the EIP. See the note at the beginning of {ERC20};
994      *
995      * Requirements:
996      * - `sender` and `recipient` cannot be the zero address.
997      * - `sender` must have a balance of at least `amount`.
998      * - the caller must have allowance for ``sender``'s tokens of at least
999      * `amount`.
1000      */
1001     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1002         _transfer(sender, recipient, amount);
1003         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1004         return true;
1005     }
1006 
1007     /**
1008      * @dev Atomically increases the allowance granted to `spender` by the caller.
1009      *
1010      * This is an alternative to {approve} that can be used as a mitigation for
1011      * problems described in {IERC20-approve}.
1012      *
1013      * Emits an {Approval} event indicating the updated allowance.
1014      *
1015      * Requirements:
1016      *
1017      * - `spender` cannot be the zero address.
1018      */
1019     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1020         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1021         return true;
1022     }
1023 
1024     /**
1025      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1026      *
1027      * This is an alternative to {approve} that can be used as a mitigation for
1028      * problems described in {IERC20-approve}.
1029      *
1030      * Emits an {Approval} event indicating the updated allowance.
1031      *
1032      * Requirements:
1033      *
1034      * - `spender` cannot be the zero address.
1035      * - `spender` must have allowance for the caller of at least
1036      * `subtractedValue`.
1037      */
1038     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1039         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1040         return true;
1041     }
1042 
1043     /**
1044      * @dev Moves tokens `amount` from `sender` to `recipient`.
1045      *
1046      * This is internal function is equivalent to {transfer}, and can be used to
1047      * e.g. implement automatic token fees, slashing mechanisms, etc.
1048      *
1049      * Emits a {Transfer} event.
1050      *
1051      * Requirements:
1052      *
1053      * - `sender` cannot be the zero address.
1054      * - `recipient` cannot be the zero address.
1055      * - `sender` must have a balance of at least `amount`.
1056      */
1057     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1058         require(sender != address(0), "ERC20: transfer from the zero address");
1059         require(recipient != address(0), "ERC20: transfer to the zero address");
1060 
1061         _beforeTokenTransfer(sender, recipient, amount);
1062 
1063         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1064         _balances[recipient] = _balances[recipient].add(amount);
1065         emit Transfer(sender, recipient, amount);
1066     }
1067 
1068     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1069      * the total supply.
1070      *
1071      * Emits a {Transfer} event with `from` set to the zero address.
1072      *
1073      * Requirements
1074      *
1075      * - `to` cannot be the zero address.
1076      */
1077     function _mint(address account, uint256 amount) internal virtual {
1078         require(account != address(0), "ERC20: mint to the zero address");
1079 
1080         _beforeTokenTransfer(address(0), account, amount);
1081 
1082         _totalSupply = _totalSupply.add(amount);
1083         _balances[account] = _balances[account].add(amount);
1084         emit Transfer(address(0), account, amount);
1085     }
1086 
1087     /**
1088      * @dev Destroys `amount` tokens from `account`, reducing the
1089      * total supply.
1090      *
1091      * Emits a {Transfer} event with `to` set to the zero address.
1092      *
1093      * Requirements
1094      *
1095      * - `account` cannot be the zero address.
1096      * - `account` must have at least `amount` tokens.
1097      */
1098     function _burn(address account, uint256 amount) internal virtual {
1099         require(account != address(0), "ERC20: burn from the zero address");
1100 
1101         _beforeTokenTransfer(account, address(0), amount);
1102 
1103         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1104         _totalSupply = _totalSupply.sub(amount);
1105         emit Transfer(account, address(0), amount);
1106     }
1107 
1108     /**
1109      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1110      *
1111      * This is internal function is equivalent to `approve`, and can be used to
1112      * e.g. set automatic allowances for certain subsystems, etc.
1113      *
1114      * Emits an {Approval} event.
1115      *
1116      * Requirements:
1117      *
1118      * - `owner` cannot be the zero address.
1119      * - `spender` cannot be the zero address.
1120      */
1121     function _approve(address owner, address spender, uint256 amount) internal virtual {
1122         require(owner != address(0), "ERC20: approve from the zero address");
1123         require(spender != address(0), "ERC20: approve to the zero address");
1124 
1125         _allowances[owner][spender] = amount;
1126         emit Approval(owner, spender, amount);
1127     }
1128 
1129     /**
1130      * @dev Sets {decimals} to a value other than the default one of 18.
1131      *
1132      * WARNING: This function should only be called from the constructor. Most
1133      * applications that interact with token contracts will not expect
1134      * {decimals} to ever change, and may work incorrectly if it does.
1135      */
1136     function _setupDecimals(uint8 decimals_) internal {
1137         _decimals = decimals_;
1138     }
1139 
1140     /**
1141      * @dev Hook that is called before any transfer of tokens. This includes
1142      * minting and burning.
1143      *
1144      * Calling conditions:
1145      *
1146      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1147      * will be to transferred to `to`.
1148      * - when `from` is zero, `amount` tokens will be minted for `to`.
1149      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1155 }
1156 
1157 // 
1158 /**
1159  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1160  * tokens and those that they have an allowance for, in a way that can be
1161  * recognized off-chain (via event analysis).
1162  */
1163 abstract contract ERC20Burnable is Context, ERC20 {
1164     /**
1165      * @dev Destroys `amount` tokens from the caller.
1166      *
1167      * See {ERC20-_burn}.
1168      */
1169     function burn(uint256 amount) public virtual {
1170         _burn(_msgSender(), amount);
1171     }
1172 
1173     /**
1174      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1175      * allowance.
1176      *
1177      * See {ERC20-_burn} and {ERC20-allowance}.
1178      *
1179      * Requirements:
1180      *
1181      * - the caller must have allowance for ``accounts``'s tokens of at least
1182      * `amount`.
1183      */
1184     function burnFrom(address account, uint256 amount) public virtual {
1185         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1186 
1187         _approve(account, _msgSender(), decreasedAllowance);
1188         _burn(account, amount);
1189     }
1190 }
1191 
1192 // 
1193 /**
1194  * @dev Contract module which allows children to implement an emergency stop
1195  * mechanism that can be triggered by an authorized account.
1196  *
1197  * This module is used through inheritance. It will make available the
1198  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1199  * the functions of your contract. Note that they will not be pausable by
1200  * simply including this module, only once the modifiers are put in place.
1201  */
1202 contract Pausable is Context {
1203     /**
1204      * @dev Emitted when the pause is triggered by `account`.
1205      */
1206     event Paused(address account);
1207 
1208     /**
1209      * @dev Emitted when the pause is lifted by `account`.
1210      */
1211     event Unpaused(address account);
1212 
1213     bool private _paused;
1214 
1215     /**
1216      * @dev Initializes the contract in unpaused state.
1217      */
1218     constructor () internal {
1219         _paused = false;
1220     }
1221 
1222     /**
1223      * @dev Returns true if the contract is paused, and false otherwise.
1224      */
1225     function paused() public view returns (bool) {
1226         return _paused;
1227     }
1228 
1229     /**
1230      * @dev Modifier to make a function callable only when the contract is not paused.
1231      *
1232      * Requirements:
1233      *
1234      * - The contract must not be paused.
1235      */
1236     modifier whenNotPaused() {
1237         require(!_paused, "Pausable: paused");
1238         _;
1239     }
1240 
1241     /**
1242      * @dev Modifier to make a function callable only when the contract is paused.
1243      *
1244      * Requirements:
1245      *
1246      * - The contract must be paused.
1247      */
1248     modifier whenPaused() {
1249         require(_paused, "Pausable: not paused");
1250         _;
1251     }
1252 
1253     /**
1254      * @dev Triggers stopped state.
1255      *
1256      * Requirements:
1257      *
1258      * - The contract must not be paused.
1259      */
1260     function _pause() internal virtual whenNotPaused {
1261         _paused = true;
1262         emit Paused(_msgSender());
1263     }
1264 
1265     /**
1266      * @dev Returns to normal state.
1267      *
1268      * Requirements:
1269      *
1270      * - The contract must be paused.
1271      */
1272     function _unpause() internal virtual whenPaused {
1273         _paused = false;
1274         emit Unpaused(_msgSender());
1275     }
1276 }
1277 
1278 // 
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
1301 // 
1302 /**
1303  * @dev {ERC20} token, including:
1304  *
1305  *  - ability for holders to burn (destroy) their tokens
1306  *  - a minter role that allows for token minting (creation)
1307  *  - a pauser role that allows to stop all token transfers
1308  *
1309  * This contract uses {AccessControl} to lock permissioned functions using the
1310  * different roles - head to its documentation for details.
1311  *
1312  * The account that deploys the contract will be granted the minter and pauser
1313  * roles, as well as the default admin role, which will let it grant both minter
1314  * and pauser roles to other accounts.
1315  */
1316 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1317     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1318     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1319 
1320     /**
1321      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1322      * account that deploys the contract.
1323      *
1324      * See {ERC20-constructor}.
1325      */
1326     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1327         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1328 
1329         _setupRole(MINTER_ROLE, _msgSender());
1330         _setupRole(PAUSER_ROLE, _msgSender());
1331     }
1332 
1333     /**
1334      * @dev Creates `amount` new tokens for `to`.
1335      *
1336      * See {ERC20-_mint}.
1337      *
1338      * Requirements:
1339      *
1340      * - the caller must have the `MINTER_ROLE`.
1341      */
1342     function mint(address to, uint256 amount) public virtual {
1343         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1344         _mint(to, amount);
1345     }
1346 
1347     /**
1348      * @dev Pauses all token transfers.
1349      *
1350      * See {ERC20Pausable} and {Pausable-_pause}.
1351      *
1352      * Requirements:
1353      *
1354      * - the caller must have the `PAUSER_ROLE`.
1355      */
1356     function pause() public virtual {
1357         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1358         _pause();
1359     }
1360 
1361     /**
1362      * @dev Unpauses all token transfers.
1363      *
1364      * See {ERC20Pausable} and {Pausable-_unpause}.
1365      *
1366      * Requirements:
1367      *
1368      * - the caller must have the `PAUSER_ROLE`.
1369      */
1370     function unpause() public virtual {
1371         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1372         _unpause();
1373     }
1374 
1375     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1376         super._beforeTokenTransfer(from, to, amount);
1377     }
1378 }
1379 
1380 // 
1381 contract GXC is ERC20PresetMinterPauser {
1382     bytes32 public constant ADJUST_ROLE = keccak256("ADJUST_ROLE");
1383     bytes32 public constant DELIVER_ROLE = keccak256("DELIVER_ROLE");
1384 
1385     string[100] private txidArray;
1386     uint256 arrayLength = 100;
1387     uint256 private id;
1388 
1389     uint256 private _minDeliver = 50000;
1390     uint256 private _minBurn = 50000;
1391 
1392     uint8 private decimals_ = 5;
1393 
1394     event Deliver(address indexed to, uint256 amount, string from, string txid);
1395 
1396     event Burn(address indexed from, uint256 amount, string to);
1397 
1398     constructor(string memory name, string memory symbol)
1399         public
1400         ERC20PresetMinterPauser(name, symbol)
1401     {
1402         super._setupDecimals(decimals_);
1403         _setupRole(ADJUST_ROLE, _msgSender());
1404     }
1405 
1406 
1407     function deliver(
1408         address to,
1409         uint256 amount,
1410         string memory from,
1411         string memory txid
1412     ) public {
1413         require(
1414             amount >= _minDeliver,
1415             "The minimum value must be greater than minDeliver"
1416         );
1417         require(hasRole(DELIVER_ROLE, _msgSender()), "Must have deliver role to deliver");
1418         for (uint256 i = 0; i < arrayLength; i++) {
1419             require(
1420                 keccak256(abi.encodePacked(txidArray[i])) !=
1421                     keccak256(abi.encodePacked(txid)),
1422                 "The txid has existed"
1423             );
1424         }
1425         uint256 id_number = id % arrayLength;
1426         txidArray[id_number] = txid;
1427         id++;
1428         transfer(to, amount);
1429         emit Deliver(to, amount, from, txid);
1430     }
1431 
1432     function burn(uint256 amount, string memory to) public {
1433         require(
1434             amount >= _minBurn,
1435             "The minimum value must be greater than minBurn"
1436         );
1437         super.burn(amount);
1438         emit Burn(msg.sender, amount, to);
1439     }
1440 
1441     function adjustParams(uint256 minDeliver , uint256 minBurn)
1442         public
1443     {
1444         require(hasRole(ADJUST_ROLE, _msgSender()), "Adjust role required");
1445         _minDeliver = minDeliver;
1446         _minBurn = minBurn;
1447     }
1448 
1449     function getParams() public view returns (uint256 ,uint256){
1450         return (_minDeliver, _minBurn);
1451     }
1452 
1453     function getTxids() public view returns (string[100] memory) {
1454         return txidArray;
1455     }
1456 }