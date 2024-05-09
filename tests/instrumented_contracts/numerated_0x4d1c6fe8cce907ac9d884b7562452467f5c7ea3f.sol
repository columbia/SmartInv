1 // File: contracts/TokenInterface.sol
2 
3 
4 
5 pragma solidity ^0.7.3;
6 
7 interface TokenInterface{
8     function burnFrom(address _from, uint _amount) external;
9     function mintTo(address _to, uint _amount) external;
10 }
11 
12 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
13 
14 
15 
16 pragma solidity ^0.7.0;
17 
18 /**
19  * @dev Library for managing
20  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
21  * types.
22  *
23  * Sets have the following properties:
24  *
25  * - Elements are added, removed, and checked for existence in constant time
26  * (O(1)).
27  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
28  *
29  * ```
30  * contract Example {
31  *     // Add the library methods
32  *     using EnumerableSet for EnumerableSet.AddressSet;
33  *
34  *     // Declare a set state variable
35  *     EnumerableSet.AddressSet private mySet;
36  * }
37  * ```
38  *
39  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
40  * (`UintSet`) are supported.
41  */
42 library EnumerableSet {
43     // To implement this library for multiple types with as little code
44     // repetition as possible, we write it in terms of a generic Set type with
45     // bytes32 values.
46     // The Set implementation uses private functions, and user-facing
47     // implementations (such as AddressSet) are just wrappers around the
48     // underlying Set.
49     // This means that we can only create new EnumerableSets for types that fit
50     // in bytes32.
51 
52     struct Set {
53         // Storage of set values
54         bytes32[] _values;
55 
56         // Position of the value in the `values` array, plus 1 because index 0
57         // means a value is not in the set.
58         mapping (bytes32 => uint256) _indexes;
59     }
60 
61     /**
62      * @dev Add a value to a set. O(1).
63      *
64      * Returns true if the value was added to the set, that is if it was not
65      * already present.
66      */
67     function _add(Set storage set, bytes32 value) private returns (bool) {
68         if (!_contains(set, value)) {
69             set._values.push(value);
70             // The value is stored at length-1, but we add 1 to all indexes
71             // and use 0 as a sentinel value
72             set._indexes[value] = set._values.length;
73             return true;
74         } else {
75             return false;
76         }
77     }
78 
79     /**
80      * @dev Removes a value from a set. O(1).
81      *
82      * Returns true if the value was removed from the set, that is if it was
83      * present.
84      */
85     function _remove(Set storage set, bytes32 value) private returns (bool) {
86         // We read and store the value's index to prevent multiple reads from the same storage slot
87         uint256 valueIndex = set._indexes[value];
88 
89         if (valueIndex != 0) { // Equivalent to contains(set, value)
90             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
91             // the array, and then remove the last element (sometimes called as 'swap and pop').
92             // This modifies the order of the array, as noted in {at}.
93 
94             uint256 toDeleteIndex = valueIndex - 1;
95             uint256 lastIndex = set._values.length - 1;
96 
97             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
98             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
99 
100             bytes32 lastvalue = set._values[lastIndex];
101 
102             // Move the last value to the index where the value to delete is
103             set._values[toDeleteIndex] = lastvalue;
104             // Update the index for the moved value
105             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
106 
107             // Delete the slot where the moved value was stored
108             set._values.pop();
109 
110             // Delete the index for the deleted slot
111             delete set._indexes[value];
112 
113             return true;
114         } else {
115             return false;
116         }
117     }
118 
119     /**
120      * @dev Returns true if the value is in the set. O(1).
121      */
122     function _contains(Set storage set, bytes32 value) private view returns (bool) {
123         return set._indexes[value] != 0;
124     }
125 
126     /**
127      * @dev Returns the number of values on the set. O(1).
128      */
129     function _length(Set storage set) private view returns (uint256) {
130         return set._values.length;
131     }
132 
133    /**
134     * @dev Returns the value stored at position `index` in the set. O(1).
135     *
136     * Note that there are no guarantees on the ordering of values inside the
137     * array, and it may change when more values are added or removed.
138     *
139     * Requirements:
140     *
141     * - `index` must be strictly less than {length}.
142     */
143     function _at(Set storage set, uint256 index) private view returns (bytes32) {
144         require(set._values.length > index, "EnumerableSet: index out of bounds");
145         return set._values[index];
146     }
147 
148     // AddressSet
149 
150     struct AddressSet {
151         Set _inner;
152     }
153 
154     /**
155      * @dev Add a value to a set. O(1).
156      *
157      * Returns true if the value was added to the set, that is if it was not
158      * already present.
159      */
160     function add(AddressSet storage set, address value) internal returns (bool) {
161         return _add(set._inner, bytes32(uint256(value)));
162     }
163 
164     /**
165      * @dev Removes a value from a set. O(1).
166      *
167      * Returns true if the value was removed from the set, that is if it was
168      * present.
169      */
170     function remove(AddressSet storage set, address value) internal returns (bool) {
171         return _remove(set._inner, bytes32(uint256(value)));
172     }
173 
174     /**
175      * @dev Returns true if the value is in the set. O(1).
176      */
177     function contains(AddressSet storage set, address value) internal view returns (bool) {
178         return _contains(set._inner, bytes32(uint256(value)));
179     }
180 
181     /**
182      * @dev Returns the number of values in the set. O(1).
183      */
184     function length(AddressSet storage set) internal view returns (uint256) {
185         return _length(set._inner);
186     }
187 
188    /**
189     * @dev Returns the value stored at position `index` in the set. O(1).
190     *
191     * Note that there are no guarantees on the ordering of values inside the
192     * array, and it may change when more values are added or removed.
193     *
194     * Requirements:
195     *
196     * - `index` must be strictly less than {length}.
197     */
198     function at(AddressSet storage set, uint256 index) internal view returns (address) {
199         return address(uint256(_at(set._inner, index)));
200     }
201 
202 
203     // UintSet
204 
205     struct UintSet {
206         Set _inner;
207     }
208 
209     /**
210      * @dev Add a value to a set. O(1).
211      *
212      * Returns true if the value was added to the set, that is if it was not
213      * already present.
214      */
215     function add(UintSet storage set, uint256 value) internal returns (bool) {
216         return _add(set._inner, bytes32(value));
217     }
218 
219     /**
220      * @dev Removes a value from a set. O(1).
221      *
222      * Returns true if the value was removed from the set, that is if it was
223      * present.
224      */
225     function remove(UintSet storage set, uint256 value) internal returns (bool) {
226         return _remove(set._inner, bytes32(value));
227     }
228 
229     /**
230      * @dev Returns true if the value is in the set. O(1).
231      */
232     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
233         return _contains(set._inner, bytes32(value));
234     }
235 
236     /**
237      * @dev Returns the number of values on the set. O(1).
238      */
239     function length(UintSet storage set) internal view returns (uint256) {
240         return _length(set._inner);
241     }
242 
243    /**
244     * @dev Returns the value stored at position `index` in the set. O(1).
245     *
246     * Note that there are no guarantees on the ordering of values inside the
247     * array, and it may change when more values are added or removed.
248     *
249     * Requirements:
250     *
251     * - `index` must be strictly less than {length}.
252     */
253     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
254         return uint256(_at(set._inner, index));
255     }
256 }
257 
258 // File: @openzeppelin/contracts/utils/Address.sol
259 
260 
261 
262 pragma solidity ^0.7.0;
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != accountHash && codehash != 0x0);
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/GSN/Context.sol
403 
404 
405 
406 pragma solidity ^0.7.0;
407 
408 /*
409  * @dev Provides information about the current execution context, including the
410  * sender of the transaction and its data. While these are generally available
411  * via msg.sender and msg.data, they should not be accessed in such a direct
412  * manner, since when dealing with GSN meta-transactions the account sending and
413  * paying for execution may not be the actual sender (as far as an application
414  * is concerned).
415  *
416  * This contract is only required for intermediate, library-like contracts.
417  */
418 abstract contract Context {
419     function _msgSender() internal view virtual returns (address payable) {
420         return msg.sender;
421     }
422 
423     function _msgData() internal view virtual returns (bytes memory) {
424         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
425         return msg.data;
426     }
427 }
428 
429 // File: @openzeppelin/contracts/access/AccessControl.sol
430 
431 
432 
433 pragma solidity ^0.7.0;
434 
435 
436 
437 
438 /**
439  * @dev Contract module that allows children to implement role-based access
440  * control mechanisms.
441  *
442  * Roles are referred to by their `bytes32` identifier. These should be exposed
443  * in the external API and be unique. The best way to achieve this is by
444  * using `public constant` hash digests:
445  *
446  * ```
447  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
448  * ```
449  *
450  * Roles can be used to represent a set of permissions. To restrict access to a
451  * function call, use {hasRole}:
452  *
453  * ```
454  * function foo() public {
455  *     require(hasRole(MY_ROLE, msg.sender));
456  *     ...
457  * }
458  * ```
459  *
460  * Roles can be granted and revoked dynamically via the {grantRole} and
461  * {revokeRole} functions. Each role has an associated admin role, and only
462  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
463  *
464  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
465  * that only accounts with this role will be able to grant or revoke other
466  * roles. More complex role relationships can be created by using
467  * {_setRoleAdmin}.
468  *
469  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
470  * grant and revoke this role. Extra precautions should be taken to secure
471  * accounts that have been granted it.
472  */
473 abstract contract AccessControl is Context {
474     using EnumerableSet for EnumerableSet.AddressSet;
475     using Address for address;
476 
477     struct RoleData {
478         EnumerableSet.AddressSet members;
479         bytes32 adminRole;
480     }
481 
482     mapping (bytes32 => RoleData) private _roles;
483 
484     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
485 
486     /**
487      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
488      *
489      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
490      * {RoleAdminChanged} not being emitted signaling this.
491      *
492      * _Available since v3.1._
493      */
494     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
495 
496     /**
497      * @dev Emitted when `account` is granted `role`.
498      *
499      * `sender` is the account that originated the contract call, an admin role
500      * bearer except when using {_setupRole}.
501      */
502     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
503 
504     /**
505      * @dev Emitted when `account` is revoked `role`.
506      *
507      * `sender` is the account that originated the contract call:
508      *   - if using `revokeRole`, it is the admin role bearer
509      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
510      */
511     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
512 
513     /**
514      * @dev Returns `true` if `account` has been granted `role`.
515      */
516     function hasRole(bytes32 role, address account) public view returns (bool) {
517         return _roles[role].members.contains(account);
518     }
519 
520     /**
521      * @dev Returns the number of accounts that have `role`. Can be used
522      * together with {getRoleMember} to enumerate all bearers of a role.
523      */
524     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
525         return _roles[role].members.length();
526     }
527 
528     /**
529      * @dev Returns one of the accounts that have `role`. `index` must be a
530      * value between 0 and {getRoleMemberCount}, non-inclusive.
531      *
532      * Role bearers are not sorted in any particular way, and their ordering may
533      * change at any point.
534      *
535      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
536      * you perform all queries on the same block. See the following
537      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
538      * for more information.
539      */
540     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
541         return _roles[role].members.at(index);
542     }
543 
544     /**
545      * @dev Returns the admin role that controls `role`. See {grantRole} and
546      * {revokeRole}.
547      *
548      * To change a role's admin, use {_setRoleAdmin}.
549      */
550     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
551         return _roles[role].adminRole;
552     }
553 
554     /**
555      * @dev Grants `role` to `account`.
556      *
557      * If `account` had not been already granted `role`, emits a {RoleGranted}
558      * event.
559      *
560      * Requirements:
561      *
562      * - the caller must have ``role``'s admin role.
563      */
564     function grantRole(bytes32 role, address account) public virtual {
565         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
566 
567         _grantRole(role, account);
568     }
569 
570     /**
571      * @dev Revokes `role` from `account`.
572      *
573      * If `account` had been granted `role`, emits a {RoleRevoked} event.
574      *
575      * Requirements:
576      *
577      * - the caller must have ``role``'s admin role.
578      */
579     function revokeRole(bytes32 role, address account) public virtual {
580         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
581 
582         _revokeRole(role, account);
583     }
584 
585     /**
586      * @dev Revokes `role` from the calling account.
587      *
588      * Roles are often managed via {grantRole} and {revokeRole}: this function's
589      * purpose is to provide a mechanism for accounts to lose their privileges
590      * if they are compromised (such as when a trusted device is misplaced).
591      *
592      * If the calling account had been granted `role`, emits a {RoleRevoked}
593      * event.
594      *
595      * Requirements:
596      *
597      * - the caller must be `account`.
598      */
599     function renounceRole(bytes32 role, address account) public virtual {
600         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
601 
602         _revokeRole(role, account);
603     }
604 
605     /**
606      * @dev Grants `role` to `account`.
607      *
608      * If `account` had not been already granted `role`, emits a {RoleGranted}
609      * event. Note that unlike {grantRole}, this function doesn't perform any
610      * checks on the calling account.
611      *
612      * [WARNING]
613      * ====
614      * This function should only be called from the constructor when setting
615      * up the initial roles for the system.
616      *
617      * Using this function in any other way is effectively circumventing the admin
618      * system imposed by {AccessControl}.
619      * ====
620      */
621     function _setupRole(bytes32 role, address account) internal virtual {
622         _grantRole(role, account);
623     }
624 
625     /**
626      * @dev Sets `adminRole` as ``role``'s admin role.
627      *
628      * Emits a {RoleAdminChanged} event.
629      */
630     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
631         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
632         _roles[role].adminRole = adminRole;
633     }
634 
635     function _grantRole(bytes32 role, address account) private {
636         if (_roles[role].members.add(account)) {
637             emit RoleGranted(role, account, _msgSender());
638         }
639     }
640 
641     function _revokeRole(bytes32 role, address account) private {
642         if (_roles[role].members.remove(account)) {
643             emit RoleRevoked(role, account, _msgSender());
644         }
645     }
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
649 
650 
651 
652 pragma solidity ^0.7.0;
653 
654 /**
655  * @dev Interface of the ERC20 standard as defined in the EIP.
656  */
657 interface IERC20 {
658     /**
659      * @dev Returns the amount of tokens in existence.
660      */
661     function totalSupply() external view returns (uint256);
662 
663     /**
664      * @dev Returns the amount of tokens owned by `account`.
665      */
666     function balanceOf(address account) external view returns (uint256);
667 
668     /**
669      * @dev Moves `amount` tokens from the caller's account to `recipient`.
670      *
671      * Returns a boolean value indicating whether the operation succeeded.
672      *
673      * Emits a {Transfer} event.
674      */
675     function transfer(address recipient, uint256 amount) external returns (bool);
676 
677     /**
678      * @dev Returns the remaining number of tokens that `spender` will be
679      * allowed to spend on behalf of `owner` through {transferFrom}. This is
680      * zero by default.
681      *
682      * This value changes when {approve} or {transferFrom} are called.
683      */
684     function allowance(address owner, address spender) external view returns (uint256);
685 
686     /**
687      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
688      *
689      * Returns a boolean value indicating whether the operation succeeded.
690      *
691      * IMPORTANT: Beware that changing an allowance with this method brings the risk
692      * that someone may use both the old and the new allowance by unfortunate
693      * transaction ordering. One possible solution to mitigate this race
694      * condition is to first reduce the spender's allowance to 0 and set the
695      * desired value afterwards:
696      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
697      *
698      * Emits an {Approval} event.
699      */
700     function approve(address spender, uint256 amount) external returns (bool);
701 
702     /**
703      * @dev Moves `amount` tokens from `sender` to `recipient` using the
704      * allowance mechanism. `amount` is then deducted from the caller's
705      * allowance.
706      *
707      * Returns a boolean value indicating whether the operation succeeded.
708      *
709      * Emits a {Transfer} event.
710      */
711     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
712 
713     /**
714      * @dev Emitted when `value` tokens are moved from one account (`from`) to
715      * another (`to`).
716      *
717      * Note that `value` may be zero.
718      */
719     event Transfer(address indexed from, address indexed to, uint256 value);
720 
721     /**
722      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
723      * a call to {approve}. `value` is the new allowance.
724      */
725     event Approval(address indexed owner, address indexed spender, uint256 value);
726 }
727 
728 // File: @openzeppelin/contracts/math/SafeMath.sol
729 
730 
731 
732 pragma solidity ^0.7.0;
733 
734 /**
735  * @dev Wrappers over Solidity's arithmetic operations with added overflow
736  * checks.
737  *
738  * Arithmetic operations in Solidity wrap on overflow. This can easily result
739  * in bugs, because programmers usually assume that an overflow raises an
740  * error, which is the standard behavior in high level programming languages.
741  * `SafeMath` restores this intuition by reverting the transaction when an
742  * operation overflows.
743  *
744  * Using this library instead of the unchecked operations eliminates an entire
745  * class of bugs, so it's recommended to use it always.
746  */
747 library SafeMath {
748     /**
749      * @dev Returns the addition of two unsigned integers, reverting on
750      * overflow.
751      *
752      * Counterpart to Solidity's `+` operator.
753      *
754      * Requirements:
755      *
756      * - Addition cannot overflow.
757      */
758     function add(uint256 a, uint256 b) internal pure returns (uint256) {
759         uint256 c = a + b;
760         require(c >= a, "SafeMath: addition overflow");
761 
762         return c;
763     }
764 
765     /**
766      * @dev Returns the subtraction of two unsigned integers, reverting on
767      * overflow (when the result is negative).
768      *
769      * Counterpart to Solidity's `-` operator.
770      *
771      * Requirements:
772      *
773      * - Subtraction cannot overflow.
774      */
775     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
776         return sub(a, b, "SafeMath: subtraction overflow");
777     }
778 
779     /**
780      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
781      * overflow (when the result is negative).
782      *
783      * Counterpart to Solidity's `-` operator.
784      *
785      * Requirements:
786      *
787      * - Subtraction cannot overflow.
788      */
789     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
790         require(b <= a, errorMessage);
791         uint256 c = a - b;
792 
793         return c;
794     }
795 
796     /**
797      * @dev Returns the multiplication of two unsigned integers, reverting on
798      * overflow.
799      *
800      * Counterpart to Solidity's `*` operator.
801      *
802      * Requirements:
803      *
804      * - Multiplication cannot overflow.
805      */
806     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
807         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
808         // benefit is lost if 'b' is also tested.
809         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
810         if (a == 0) {
811             return 0;
812         }
813 
814         uint256 c = a * b;
815         require(c / a == b, "SafeMath: multiplication overflow");
816 
817         return c;
818     }
819 
820     /**
821      * @dev Returns the integer division of two unsigned integers. Reverts on
822      * division by zero. The result is rounded towards zero.
823      *
824      * Counterpart to Solidity's `/` operator. Note: this function uses a
825      * `revert` opcode (which leaves remaining gas untouched) while Solidity
826      * uses an invalid opcode to revert (consuming all remaining gas).
827      *
828      * Requirements:
829      *
830      * - The divisor cannot be zero.
831      */
832     function div(uint256 a, uint256 b) internal pure returns (uint256) {
833         return div(a, b, "SafeMath: division by zero");
834     }
835 
836     /**
837      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
838      * division by zero. The result is rounded towards zero.
839      *
840      * Counterpart to Solidity's `/` operator. Note: this function uses a
841      * `revert` opcode (which leaves remaining gas untouched) while Solidity
842      * uses an invalid opcode to revert (consuming all remaining gas).
843      *
844      * Requirements:
845      *
846      * - The divisor cannot be zero.
847      */
848     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
849         require(b > 0, errorMessage);
850         uint256 c = a / b;
851         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
852 
853         return c;
854     }
855 
856     /**
857      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
858      * Reverts when dividing by zero.
859      *
860      * Counterpart to Solidity's `%` operator. This function uses a `revert`
861      * opcode (which leaves remaining gas untouched) while Solidity uses an
862      * invalid opcode to revert (consuming all remaining gas).
863      *
864      * Requirements:
865      *
866      * - The divisor cannot be zero.
867      */
868     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
869         return mod(a, b, "SafeMath: modulo by zero");
870     }
871 
872     /**
873      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
874      * Reverts with custom message when dividing by zero.
875      *
876      * Counterpart to Solidity's `%` operator. This function uses a `revert`
877      * opcode (which leaves remaining gas untouched) while Solidity uses an
878      * invalid opcode to revert (consuming all remaining gas).
879      *
880      * Requirements:
881      *
882      * - The divisor cannot be zero.
883      */
884     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
885         require(b != 0, errorMessage);
886         return a % b;
887     }
888 }
889 
890 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
891 
892 
893 
894 pragma solidity ^0.7.0;
895 
896 
897 
898 
899 /**
900  * @title SafeERC20
901  * @dev Wrappers around ERC20 operations that throw on failure (when the token
902  * contract returns false). Tokens that return no value (and instead revert or
903  * throw on failure) are also supported, non-reverting calls are assumed to be
904  * successful.
905  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
906  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
907  */
908 library SafeERC20 {
909     using SafeMath for uint256;
910     using Address for address;
911 
912     function safeTransfer(IERC20 token, address to, uint256 value) internal {
913         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
914     }
915 
916     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
917         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
918     }
919 
920     /**
921      * @dev Deprecated. This function has issues similar to the ones found in
922      * {IERC20-approve}, and its usage is discouraged.
923      *
924      * Whenever possible, use {safeIncreaseAllowance} and
925      * {safeDecreaseAllowance} instead.
926      */
927     function safeApprove(IERC20 token, address spender, uint256 value) internal {
928         // safeApprove should only be called when setting an initial allowance,
929         // or when resetting it to zero. To increase and decrease it, use
930         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
931         // solhint-disable-next-line max-line-length
932         require((value == 0) || (token.allowance(address(this), spender) == 0),
933             "SafeERC20: approve from non-zero to non-zero allowance"
934         );
935         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
936     }
937 
938     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
939         uint256 newAllowance = token.allowance(address(this), spender).add(value);
940         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
941     }
942 
943     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
944         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
945         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
946     }
947 
948     /**
949      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
950      * on the return value: the return value is optional (but if data is returned, it must not be false).
951      * @param token The token targeted by the call.
952      * @param data The call data (encoded using abi.encode or one of its variants).
953      */
954     function _callOptionalReturn(IERC20 token, bytes memory data) private {
955         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
956         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
957         // the target address contains contract code and also asserts for success in the low-level call.
958 
959         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
960         if (returndata.length > 0) { // Return data is optional
961             // solhint-disable-next-line max-line-length
962             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
963         }
964     }
965 }
966 
967 // File: contracts/TokenStaking.sol
968 
969 // SPDX-License-Identifier: GPL-3.0
970 
971 // Author: Matt Hooft 
972 // https://github.com/Civitas-Fundamenta
973 // mhooft@fundamenta.network
974 
975 // A simple token Staking Contract that uses a configurable `stakeCap` to limit inflation.
976 // Employs the use of Role Based Access Control (RBAC) so allow outside accounts and contracts
977 // to interact with it securely allowing for future extensibility.
978 
979 pragma solidity ^0.7.3;
980 
981 
982 
983 
984 
985 
986 contract Staking is AccessControl {
987 
988     using SafeMath for uint256;
989     using SafeERC20 for IERC20;
990     
991     TokenInterface private fundamenta;  
992     
993     /**
994      * @dev Smart Contract uses Role Based Access Control to 
995      * 
996      * alllow for secure access as well as enabling the ability 
997      *
998      * for other contracts such as oracles to interact with ifundamenta.
999      */
1000 
1001     //-------RBAC---------------------------
1002 
1003     bytes32 public constant _STAKING = keccak256("_STAKING");
1004     bytes32 public constant _RESCUE = keccak256("_RESCUE");
1005     bytes32 public constant _ADMIN = keccak256("_ADMIN");
1006 
1007     //-------Staking Vars-------------------
1008     
1009     uint public stakeCalc;
1010     uint public stakeCap;
1011     uint public rewardsWindow;
1012     uint public stakeLockMultiplier;
1013     bool public stakingOff;
1014     bool public paused;
1015     bool public emergencyWDoff;
1016     
1017     //--------Staking mapping/Arrays----------
1018 
1019     address[] internal stakeholders;
1020     mapping(address => uint) internal stakes;
1021     mapping(address => uint) internal rewards;
1022     mapping(address => uint) internal lastWithdraw;
1023     
1024     //----------Events----------------------
1025     
1026     event StakeCreated(address _stakeholder, uint _stakes, uint _blockHeight);
1027     event StakeRemoved(address _stakeholder, uint _stakes, uint rewards, uint _blockHeight);
1028     event RewardsWithdrawn(address _stakeholder, uint _rewards, uint blockHeight);
1029     event TokensRescued (address _pebcak, address _ERC20, uint _ERC20Amount, uint _blockHeightRescued);
1030     event ETHRescued (address _pebcak, uint _ETHAmount, uint _blockHeightRescued);
1031 
1032     //-------Constructor----------------------
1033 
1034     constructor(){
1035         stakingOff = true;
1036         emergencyWDoff = true;
1037         stakeCalc = 500;
1038         stakeCap = 3e22;
1039         rewardsWindow = 6500;
1040         stakeLockMultiplier = 2;
1041         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1042     }
1043 
1044     //-------Set Token Address----------------
1045     
1046     function setAddress(TokenInterface _token) public {
1047         require(hasRole(_ADMIN, msg.sender));
1048         fundamenta = _token;
1049     }
1050     
1051     //-------Modifiers--------------------------
1052 
1053     modifier pause() {
1054         require(!paused, "TokenStaking: Contract is Paused");
1055         _;
1056     }
1057 
1058     modifier stakeToggle() {
1059         require(!stakingOff, "TokenStaking: Staking is not currently active");
1060         _;
1061     }
1062     
1063     modifier emergency() {
1064         require(!emergencyWDoff, "TokenStaking: Emergency Withdraw is not enabled");
1065         _;
1066     }
1067 
1068     //--------Staking Functions-------------------
1069 
1070     /**
1071      * @dev allows a user to create a staking positon. Users will
1072      * 
1073      * not be allowed to stake more than the `stakeCap` which is 
1074      *
1075      * a settable variable by Admins/Contrcats with the `_STAKING` 
1076      * 
1077      * Role.
1078      */
1079 
1080     function createStake(uint _stake) public pause stakeToggle {
1081         lastWithdraw[msg.sender] = block.number;
1082         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1083         if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
1084         stakes[msg.sender] = stakes[msg.sender].add(_stake);
1085         fundamenta.mintTo(msg.sender, rewardsAccrued());
1086         fundamenta.burnFrom(msg.sender, _stake);
1087         require(stakes[msg.sender] <= stakeCap, "TokenStaking: Can't Stake More than allowed moneybags"); 
1088         lastWithdraw[msg.sender] = block.number;
1089         emit StakeCreated(msg.sender, _stake, block.number);
1090     }
1091     
1092     /**
1093      * @dev removes a users staked positon if the required lock
1094      * 
1095      * window is satisfied. Also pays out any `_rewardsAccrued` to
1096      *
1097      * the user if any rewards are pending.
1098      */
1099     
1100     function removeStake(uint _stake) public pause {
1101         uint unlockWindow = rewardsWindow.mul(stakeLockMultiplier);
1102         require(block.number >= lastWithdraw[msg.sender].add(unlockWindow), "TokenStaking: FMTA has not been staked for long enough");
1103         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1104         if(stakes[msg.sender] == 0 && _stake != 0 ) {
1105             revert("TokenStaking: You don't have any tokens staked");
1106         }else if (stakes[msg.sender] != 0 && _stake != 0) {
1107             fundamenta.mintTo(msg.sender, rewardsAccrued());
1108             fundamenta.mintTo(msg.sender, _stake);
1109             stakes[msg.sender] = stakes[msg.sender].sub(_stake);
1110             lastWithdraw[msg.sender] = block.number;
1111         }else if (stakes[msg.sender] == 0) {
1112             fundamenta.mintTo(msg.sender, rewardsAccrued());
1113             fundamenta.mintTo(msg.sender, _stake);
1114             stakes[msg.sender] = stakes[msg.sender].sub(_stake);
1115             removeStakeholder(msg.sender);
1116             lastWithdraw[msg.sender] = block.number;
1117         }
1118         emit StakeRemoved(msg.sender, _stake, rewardsAccrued(), block.number);
1119         
1120     }
1121     
1122     /**
1123      * @dev returns the amount of rewards a user as accrued.
1124      */
1125     
1126     function rewardsAccrued() public view returns (uint) {
1127         uint _rewardsAccrued;
1128         uint multiplier;
1129         multiplier = block.number.sub(lastWithdraw[msg.sender]).div(rewardsWindow);
1130         _rewardsAccrued = calculateReward(msg.sender).mul(multiplier);
1131         return _rewardsAccrued;
1132         
1133     }
1134     
1135     /**
1136      * @dev allows user to withrdraw any pending rewards as
1137      * 
1138      * long as the `rewardsWindow` is satisfied.
1139      */
1140      
1141     function withdrawReward() public pause stakeToggle {
1142         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1143         if(lastWithdraw[msg.sender] == 0) {
1144            revert("TokenStaking: You cannot withdraw if you hve never staked");
1145         } else if (lastWithdraw[msg.sender] != 0){
1146             require(block.number > lastWithdraw[msg.sender].add(rewardsWindow), "TokenStaking: It hasn't been enough time since your last withdrawl");
1147             fundamenta.mintTo(msg.sender, rewardsAccrued());
1148             lastWithdraw[msg.sender] = block.number;
1149             emit RewardsWithdrawn(msg.sender, rewardsAccrued(), block.number);
1150         }
1151     }
1152     
1153     /**
1154      * @dev allows user to withrdraw any pending rewards and
1155      * 
1156      * staking position if `emergencyWDoff` is false enabling 
1157      * 
1158      * emergency withdraw situtaions when staking is off and 
1159      * 
1160      * the contract is paused.  This will likely never be used.
1161      */
1162     
1163     function emergencyWithdrawRewardAndStakes() public emergency {
1164         rewards[msg.sender] = rewards[msg.sender].add(rewardsAccrued());
1165         fundamenta.mintTo(msg.sender, rewardsAccrued());
1166         fundamenta.mintTo(msg.sender, stakes[msg.sender]);
1167         stakes[msg.sender] = stakes[msg.sender].sub(stakes[msg.sender]);
1168         removeStakeholder(msg.sender);
1169     }
1170     
1171     /**
1172      * @dev returns a users `lastWithdraw` which is the last block
1173      * 
1174      * height that the user last withdrew rewards.
1175      */
1176     
1177     function lastWdHeight() public view returns (uint) {
1178         return lastWithdraw[msg.sender];
1179     }
1180     
1181     /**
1182      * @dev returns to the user the amount of blocks that they must
1183      * 
1184      * have their stake locked before they are able to unstake their
1185      * 
1186      * positon.
1187      */
1188     
1189     function stakeUnlockWindow() external view returns (uint) {
1190         uint unlockWindow = rewardsWindow.mul(stakeLockMultiplier);
1191         uint stakeWindow = lastWithdraw[msg.sender].add(unlockWindow);
1192         return stakeWindow;
1193     }
1194     
1195     /**
1196      * @dev allows admin with the `_STAKING` role to set the 
1197      * 
1198      * `stakeMultiplier` which is used in the calculation that
1199      *
1200      * determines how long a user must have a staked positon 
1201      * 
1202      * before they are able to unstake said positon.
1203      */
1204     
1205     function setStakeMultiplier(uint _newMultiplier) public pause stakeToggle {
1206         require(hasRole(_STAKING, msg.sender));
1207         stakeLockMultiplier = _newMultiplier;
1208     }
1209     
1210     /**
1211      * @dev returns a users staked position.
1212      */
1213     
1214     function stakeOf (address _stakeholder) public view returns(uint) {
1215         return stakes[_stakeholder];
1216     }
1217     
1218     /**
1219      * @dev returns the total amount of FMTA that has been 
1220      * 
1221      * placed in staking postions by users.
1222      */
1223     
1224     function totalStakes() public view returns(uint) {
1225         uint _totalStakes = 0;
1226         for (uint s = 0; s < stakeholders.length; s += 1) {
1227             _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
1228         }
1229         
1230         return _totalStakes;
1231     }
1232     
1233     /**
1234      * @dev returns if an account is a stakeholder and holds
1235      * 
1236      * a staked position.
1237      */
1238 
1239     function isStakeholder(address _address) public view returns(bool, uint) {
1240         for (uint s = 0; s < stakeholders.length; s += 1) {
1241             if (_address == stakeholders[s]) return (true, s);
1242         }
1243         
1244         return (false, 0);
1245     }
1246     
1247     /**
1248      * @dev internal function that adds accounts as stakeholders.
1249      */
1250     
1251     function addStakeholder(address _stakeholder) internal pause stakeToggle {
1252         (bool _isStakeholder, ) = isStakeholder(_stakeholder);
1253         if(!_isStakeholder) stakeholders.push(_stakeholder);
1254     }
1255     
1256     /**
1257      * @dev internal function that removes accounts as stakeholders.
1258      */
1259     
1260     function removeStakeholder(address _stakeholder) internal {
1261         (bool _isStakeholder, uint s) = isStakeholder(_stakeholder);
1262         if(_isStakeholder){
1263             stakeholders[s] = stakeholders[stakeholders.length - 1];
1264             stakeholders.pop();
1265         }
1266     }
1267     
1268     /**
1269      * @dev returns an accounts total rewards paid over the
1270      * 
1271      * Staking Contracts lifetime.
1272      */
1273     
1274     function totalRewardsOf(address _stakeholder) external view returns(uint) {
1275         return rewards[_stakeholder];
1276     }
1277     
1278     /**
1279      * @dev returns the amount of total rewards paid to all
1280      * 
1281      * accounts over the Staking Contracts lifetime.
1282      */
1283     
1284     function totalRewardsPaid() external view returns(uint) {
1285         uint _totalRewards = 0;
1286         for (uint s = 0; s < stakeholders.length; s += 1){
1287             _totalRewards = _totalRewards.add(rewards[stakeholders[s]]);
1288         }
1289         
1290         return _totalRewards;
1291     }
1292     
1293      /**
1294      * @dev allows admin with the `_STAKING` role to set the
1295      * 
1296      * Staking Contracts `stakeCalc` which is the divisor used
1297      * 
1298      * in `calculateReward` to determine the reward during each 
1299      * 
1300      * `rewardsWindow`.
1301      */
1302     
1303     function setStakeCalc(uint _stakeCalc) external pause stakeToggle {
1304         require(hasRole(_STAKING, msg.sender));
1305         stakeCalc = _stakeCalc;
1306     }
1307     
1308      /**
1309      * @dev allows admin with the `_STAKING` role to set the
1310      * 
1311      * Staking Contracts `stakeCap` which determines how many
1312      * 
1313      * tokens total can be staked per accounfundamenta.
1314      */
1315     
1316     function setStakeCap(uint _stakeCap) external pause stakeToggle {
1317         require(hasRole(_STAKING, msg.sender));
1318         stakeCap = _stakeCap;
1319     }
1320     
1321      /**
1322      * @dev allows admin with the `_STAKING` role to set the
1323      * 
1324      * Staking Contracts `stakeOff` bool to true ot false 
1325      * 
1326      * effecively turning staking on or off. The only function 
1327      * 
1328      * that is not effected is removng stake 
1329      */
1330     
1331     function stakeOff(bool _stakingOff) public {
1332         require(hasRole(_STAKING, msg.sender));
1333         stakingOff = _stakingOff;
1334     }
1335     
1336     /**
1337      * @dev allows admin with the `_STAKING` role to set the
1338      * 
1339      * Staking Contracts `rewardsWindow` which determines how
1340      * 
1341      * long a user must wait before they can with draw in the 
1342      * 
1343      * form of a number of blocks that must pass since the users
1344      * 
1345      * `lastWithdraw`.
1346      */
1347     
1348     function setRewardsWindow(uint _newWindow) external pause stakeToggle {
1349         require(hasRole(_STAKING, msg.sender));
1350         rewardsWindow = _newWindow;
1351     }
1352     
1353     /**
1354      * @dev simple function help track and calculate the rewards
1355      * 
1356      * accrued between rewards windows. it uses `stakeCalc` which
1357      * 
1358      * is settable by admins with the `_STAKING` role.
1359      */
1360     
1361     function calculateReward(address _stakeholder) public view returns(uint) {
1362         return stakes[_stakeholder] / stakeCalc;
1363     }
1364     
1365     /**
1366      * @dev turns on the emergencyWD function which is used for 
1367      * 
1368      * when the staking contract is paused or stopped for some
1369      * 
1370      * unforseeable reason and we still need to let users withdraw.
1371      */
1372     
1373     function setEmergencyWDoff(bool _emergencyWD) external {
1374         require(hasRole(_ADMIN, msg.sender));
1375         emergencyWDoff = _emergencyWD;
1376     }
1377     
1378 
1379     //----------Pause----------------------
1380 
1381     /**
1382      * @dev pauses the Smart Contract.
1383      */
1384 
1385     function setPaused(bool _paused) external {
1386         require(hasRole(_ADMIN, msg.sender));
1387         paused = _paused;
1388     }
1389     
1390     //----Emergency PEBCAK Functions-------
1391     
1392     function mistakenERC20DepositRescue(address _ERC20, address _pebcak, uint _ERC20Amount) public {
1393         require(hasRole(_RESCUE, msg.sender),"TokenStaking: Message Sender must be _RESCUE");
1394         IERC20(_ERC20).safeTransfer(_pebcak, _ERC20Amount);
1395         emit TokensRescued (_pebcak, _ERC20, _ERC20Amount, block.number);
1396     }
1397 
1398     function mistakenDepositRescue(address payable _pebcak, uint _etherAmount) public {
1399         require(hasRole(_RESCUE, msg.sender),"TokenStaking: Message Sender must be _RESCUE");
1400         _pebcak.transfer(_etherAmount);
1401         emit ETHRescued (_pebcak, _etherAmount, block.number);
1402     }
1403 
1404 }