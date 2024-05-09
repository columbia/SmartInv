1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT AND GPL-3.0-or-later
4 
5 pragma solidity ^0.6.0;
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
122    /**
123     * @dev Returns the value stored at position `index` in the set. O(1).
124     *
125     * Note that there are no guarantees on the ordering of values inside the
126     * array, and it may change when more values are added or removed.
127     *
128     * Requirements:
129     *
130     * - `index` must be strictly less than {length}.
131     */
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
177    /**
178     * @dev Returns the value stored at position `index` in the set. O(1).
179     *
180     * Note that there are no guarantees on the ordering of values inside the
181     * array, and it may change when more values are added or removed.
182     *
183     * Requirements:
184     *
185     * - `index` must be strictly less than {length}.
186     */
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
232    /**
233     * @dev Returns the value stored at position `index` in the set. O(1).
234     *
235     * Note that there are no guarantees on the ordering of values inside the
236     * array, and it may change when more values are added or removed.
237     *
238     * Requirements:
239     *
240     * - `index` must be strictly less than {length}.
241     */
242     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
243         return uint256(_at(set._inner, index));
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/Address.sol
248 
249 
250 pragma solidity ^0.6.2;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts/GSN/Context.sol
391 
392 
393 pragma solidity ^0.6.0;
394 
395 /*
396  * @dev Provides information about the current execution context, including the
397  * sender of the transaction and its data. While these are generally available
398  * via msg.sender and msg.data, they should not be accessed in such a direct
399  * manner, since when dealing with GSN meta-transactions the account sending and
400  * paying for execution may not be the actual sender (as far as an application
401  * is concerned).
402  *
403  * This contract is only required for intermediate, library-like contracts.
404  */
405 abstract contract Context {
406     function _msgSender() internal view virtual returns (address payable) {
407         return msg.sender;
408     }
409 
410     function _msgData() internal view virtual returns (bytes memory) {
411         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
412         return msg.data;
413     }
414 }
415 
416 // File: @openzeppelin/contracts/access/AccessControl.sol
417 
418 
419 pragma solidity ^0.6.0;
420 
421 
422 
423 
424 /**
425  * @dev Contract module that allows children to implement role-based access
426  * control mechanisms.
427  *
428  * Roles are referred to by their `bytes32` identifier. These should be exposed
429  * in the external API and be unique. The best way to achieve this is by
430  * using `public constant` hash digests:
431  *
432  * ```
433  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
434  * ```
435  *
436  * Roles can be used to represent a set of permissions. To restrict access to a
437  * function call, use {hasRole}:
438  *
439  * ```
440  * function foo() public {
441  *     require(hasRole(MY_ROLE, msg.sender));
442  *     ...
443  * }
444  * ```
445  *
446  * Roles can be granted and revoked dynamically via the {grantRole} and
447  * {revokeRole} functions. Each role has an associated admin role, and only
448  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
449  *
450  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
451  * that only accounts with this role will be able to grant or revoke other
452  * roles. More complex role relationships can be created by using
453  * {_setRoleAdmin}.
454  *
455  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
456  * grant and revoke this role. Extra precautions should be taken to secure
457  * accounts that have been granted it.
458  */
459 abstract contract AccessControl is Context {
460     using EnumerableSet for EnumerableSet.AddressSet;
461     using Address for address;
462 
463     struct RoleData {
464         EnumerableSet.AddressSet members;
465         bytes32 adminRole;
466     }
467 
468     mapping (bytes32 => RoleData) private _roles;
469 
470     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
471 
472     /**
473      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
474      *
475      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
476      * {RoleAdminChanged} not being emitted signaling this.
477      *
478      * _Available since v3.1._
479      */
480     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
481 
482     /**
483      * @dev Emitted when `account` is granted `role`.
484      *
485      * `sender` is the account that originated the contract call, an admin role
486      * bearer except when using {_setupRole}.
487      */
488     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
489 
490     /**
491      * @dev Emitted when `account` is revoked `role`.
492      *
493      * `sender` is the account that originated the contract call:
494      *   - if using `revokeRole`, it is the admin role bearer
495      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
496      */
497     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
498 
499     /**
500      * @dev Returns `true` if `account` has been granted `role`.
501      */
502     function hasRole(bytes32 role, address account) public view returns (bool) {
503         return _roles[role].members.contains(account);
504     }
505 
506     /**
507      * @dev Returns the number of accounts that have `role`. Can be used
508      * together with {getRoleMember} to enumerate all bearers of a role.
509      */
510     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
511         return _roles[role].members.length();
512     }
513 
514     /**
515      * @dev Returns one of the accounts that have `role`. `index` must be a
516      * value between 0 and {getRoleMemberCount}, non-inclusive.
517      *
518      * Role bearers are not sorted in any particular way, and their ordering may
519      * change at any point.
520      *
521      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
522      * you perform all queries on the same block. See the following
523      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
524      * for more information.
525      */
526     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
527         return _roles[role].members.at(index);
528     }
529 
530     /**
531      * @dev Returns the admin role that controls `role`. See {grantRole} and
532      * {revokeRole}.
533      *
534      * To change a role's admin, use {_setRoleAdmin}.
535      */
536     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
537         return _roles[role].adminRole;
538     }
539 
540     /**
541      * @dev Grants `role` to `account`.
542      *
543      * If `account` had not been already granted `role`, emits a {RoleGranted}
544      * event.
545      *
546      * Requirements:
547      *
548      * - the caller must have ``role``'s admin role.
549      */
550     function grantRole(bytes32 role, address account) public virtual {
551         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
552 
553         _grantRole(role, account);
554     }
555 
556     /**
557      * @dev Revokes `role` from `account`.
558      *
559      * If `account` had been granted `role`, emits a {RoleRevoked} event.
560      *
561      * Requirements:
562      *
563      * - the caller must have ``role``'s admin role.
564      */
565     function revokeRole(bytes32 role, address account) public virtual {
566         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
567 
568         _revokeRole(role, account);
569     }
570 
571     /**
572      * @dev Revokes `role` from the calling account.
573      *
574      * Roles are often managed via {grantRole} and {revokeRole}: this function's
575      * purpose is to provide a mechanism for accounts to lose their privileges
576      * if they are compromised (such as when a trusted device is misplaced).
577      *
578      * If the calling account had been granted `role`, emits a {RoleRevoked}
579      * event.
580      *
581      * Requirements:
582      *
583      * - the caller must be `account`.
584      */
585     function renounceRole(bytes32 role, address account) public virtual {
586         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
587 
588         _revokeRole(role, account);
589     }
590 
591     /**
592      * @dev Grants `role` to `account`.
593      *
594      * If `account` had not been already granted `role`, emits a {RoleGranted}
595      * event. Note that unlike {grantRole}, this function doesn't perform any
596      * checks on the calling account.
597      *
598      * [WARNING]
599      * ====
600      * This function should only be called from the constructor when setting
601      * up the initial roles for the system.
602      *
603      * Using this function in any other way is effectively circumventing the admin
604      * system imposed by {AccessControl}.
605      * ====
606      */
607     function _setupRole(bytes32 role, address account) internal virtual {
608         _grantRole(role, account);
609     }
610 
611     /**
612      * @dev Sets `adminRole` as ``role``'s admin role.
613      *
614      * Emits a {RoleAdminChanged} event.
615      */
616     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
617         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
618         _roles[role].adminRole = adminRole;
619     }
620 
621     function _grantRole(bytes32 role, address account) private {
622         if (_roles[role].members.add(account)) {
623             emit RoleGranted(role, account, _msgSender());
624         }
625     }
626 
627     function _revokeRole(bytes32 role, address account) private {
628         if (_roles[role].members.remove(account)) {
629             emit RoleRevoked(role, account, _msgSender());
630         }
631     }
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
635 
636 
637 pragma solidity ^0.6.0;
638 
639 /**
640  * @dev Interface of the ERC20 standard as defined in the EIP.
641  */
642 interface IERC20 {
643     /**
644      * @dev Returns the amount of tokens in existence.
645      */
646     function totalSupply() external view returns (uint256);
647 
648     /**
649      * @dev Returns the amount of tokens owned by `account`.
650      */
651     function balanceOf(address account) external view returns (uint256);
652 
653     /**
654      * @dev Moves `amount` tokens from the caller's account to `recipient`.
655      *
656      * Returns a boolean value indicating whether the operation succeeded.
657      *
658      * Emits a {Transfer} event.
659      */
660     function transfer(address recipient, uint256 amount) external returns (bool);
661 
662     /**
663      * @dev Returns the remaining number of tokens that `spender` will be
664      * allowed to spend on behalf of `owner` through {transferFrom}. This is
665      * zero by default.
666      *
667      * This value changes when {approve} or {transferFrom} are called.
668      */
669     function allowance(address owner, address spender) external view returns (uint256);
670 
671     /**
672      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
673      *
674      * Returns a boolean value indicating whether the operation succeeded.
675      *
676      * IMPORTANT: Beware that changing an allowance with this method brings the risk
677      * that someone may use both the old and the new allowance by unfortunate
678      * transaction ordering. One possible solution to mitigate this race
679      * condition is to first reduce the spender's allowance to 0 and set the
680      * desired value afterwards:
681      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
682      *
683      * Emits an {Approval} event.
684      */
685     function approve(address spender, uint256 amount) external returns (bool);
686 
687     /**
688      * @dev Moves `amount` tokens from `sender` to `recipient` using the
689      * allowance mechanism. `amount` is then deducted from the caller's
690      * allowance.
691      *
692      * Returns a boolean value indicating whether the operation succeeded.
693      *
694      * Emits a {Transfer} event.
695      */
696     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
697 
698     /**
699      * @dev Emitted when `value` tokens are moved from one account (`from`) to
700      * another (`to`).
701      *
702      * Note that `value` may be zero.
703      */
704     event Transfer(address indexed from, address indexed to, uint256 value);
705 
706     /**
707      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
708      * a call to {approve}. `value` is the new allowance.
709      */
710     event Approval(address indexed owner, address indexed spender, uint256 value);
711 }
712 
713 // File: contracts/IMintableERC20.sol
714 
715 
716 pragma solidity ^0.6.0;
717 
718 
719 /**
720  * @dev Interface of an ERC20 which implements the mint() function.
721  */
722 interface IMintableERC20
723    is IERC20
724 {
725    /**
726     * @dev Creates `amount` new tokens for `to`.
727     *
728     * See {ERC20-_mint}.
729     *
730     * Requirements:
731     *
732     * - the caller must have the `MINTER_ROLE`.
733     */
734    function mint(address to, uint256 amount) external;
735 }
736 
737 // File: contracts/KnsTokenWork.sol
738 
739 /**************************************************************************************
740  *                                                                                    *
741  *                             GENERATED FILE DO NOT EDIT                             *
742  *   ___  ____  _  _  ____  ____    __   ____  ____  ____     ____  ____  __    ____  *
743  *  / __)( ___)( \( )( ___)(  _ \  /__\ (_  _)( ___)(  _ \   ( ___)(_  _)(  )  ( ___) *
744  * ( (_-. )__)  )  (  )__)  )   / /(__)\  )(   )__)  )(_) )   )__)  _)(_  )(__  )__)  *
745  *  \___/(____)(_)\_)(____)(_)\_)(__)(__)(__) (____)(____/   (__)  (____)(____)(____) *
746  *                                                                                    *
747  *                             GENERATED FILE DO NOT EDIT                             *
748  *                                                                                    *
749  **************************************************************************************/
750 pragma solidity ^0.6.0;
751 
752 contract KnsTokenWork
753 {
754    /**
755     * Compute the work function for a seed, secured_struct_hash, and nonce.
756     *
757     * work_result[10] is the actual work function value, this is what is compared against the target.
758     * work_result[0] through work_result[9] (inclusive) are the values of w[y_i].
759     */
760    function work(
761       uint256 seed,
762       uint256 secured_struct_hash,
763       uint256 nonce
764       ) public pure returns (uint256[11] memory work_result)
765    {
766       uint256 w;
767       uint256 x;
768       uint256 y;
769       uint256 result = secured_struct_hash;
770       uint256 coeff_0 = (nonce % 0x0000fffd)+1;
771       uint256 coeff_1 = (nonce % 0x0000fffb)+1;
772       uint256 coeff_2 = (nonce % 0x0000fff7)+1;
773       uint256 coeff_3 = (nonce % 0x0000fff1)+1;
774       uint256 coeff_4 = (nonce % 0x0000ffef)+1;
775 
776 
777 
778 
779       x = secured_struct_hash % 0x0000fffd;
780       y = coeff_4;
781       y *= x;
782       y += coeff_3;
783       y *= x;
784       y += coeff_2;
785       y *= x;
786       y += coeff_1;
787       y *= x;
788       y += coeff_0;
789       y %= 0x0000ffff;
790       w = uint256( keccak256( abi.encode( seed, y ) ) );
791       work_result[0] = w;
792       result ^= w;
793 
794 
795       x = secured_struct_hash % 0x0000fffb;
796       y = coeff_4;
797       y *= x;
798       y += coeff_3;
799       y *= x;
800       y += coeff_2;
801       y *= x;
802       y += coeff_1;
803       y *= x;
804       y += coeff_0;
805       y %= 0x0000ffff;
806       w = uint256( keccak256( abi.encode( seed, y ) ) );
807       work_result[1] = w;
808       result ^= w;
809 
810 
811       x = secured_struct_hash % 0x0000fff7;
812       y = coeff_4;
813       y *= x;
814       y += coeff_3;
815       y *= x;
816       y += coeff_2;
817       y *= x;
818       y += coeff_1;
819       y *= x;
820       y += coeff_0;
821       y %= 0x0000ffff;
822       w = uint256( keccak256( abi.encode( seed, y ) ) );
823       work_result[2] = w;
824       result ^= w;
825 
826 
827       x = secured_struct_hash % 0x0000fff1;
828       y = coeff_4;
829       y *= x;
830       y += coeff_3;
831       y *= x;
832       y += coeff_2;
833       y *= x;
834       y += coeff_1;
835       y *= x;
836       y += coeff_0;
837       y %= 0x0000ffff;
838       w = uint256( keccak256( abi.encode( seed, y ) ) );
839       work_result[3] = w;
840       result ^= w;
841 
842 
843       x = secured_struct_hash % 0x0000ffef;
844       y = coeff_4;
845       y *= x;
846       y += coeff_3;
847       y *= x;
848       y += coeff_2;
849       y *= x;
850       y += coeff_1;
851       y *= x;
852       y += coeff_0;
853       y %= 0x0000ffff;
854       w = uint256( keccak256( abi.encode( seed, y ) ) );
855       work_result[4] = w;
856       result ^= w;
857 
858 
859       x = secured_struct_hash % 0x0000ffe5;
860       y = coeff_4;
861       y *= x;
862       y += coeff_3;
863       y *= x;
864       y += coeff_2;
865       y *= x;
866       y += coeff_1;
867       y *= x;
868       y += coeff_0;
869       y %= 0x0000ffff;
870       w = uint256( keccak256( abi.encode( seed, y ) ) );
871       work_result[5] = w;
872       result ^= w;
873 
874 
875       x = secured_struct_hash % 0x0000ffdf;
876       y = coeff_4;
877       y *= x;
878       y += coeff_3;
879       y *= x;
880       y += coeff_2;
881       y *= x;
882       y += coeff_1;
883       y *= x;
884       y += coeff_0;
885       y %= 0x0000ffff;
886       w = uint256( keccak256( abi.encode( seed, y ) ) );
887       work_result[6] = w;
888       result ^= w;
889 
890 
891       x = secured_struct_hash % 0x0000ffd9;
892       y = coeff_4;
893       y *= x;
894       y += coeff_3;
895       y *= x;
896       y += coeff_2;
897       y *= x;
898       y += coeff_1;
899       y *= x;
900       y += coeff_0;
901       y %= 0x0000ffff;
902       w = uint256( keccak256( abi.encode( seed, y ) ) );
903       work_result[7] = w;
904       result ^= w;
905 
906 
907       x = secured_struct_hash % 0x0000ffd3;
908       y = coeff_4;
909       y *= x;
910       y += coeff_3;
911       y *= x;
912       y += coeff_2;
913       y *= x;
914       y += coeff_1;
915       y *= x;
916       y += coeff_0;
917       y %= 0x0000ffff;
918       w = uint256( keccak256( abi.encode( seed, y ) ) );
919       work_result[8] = w;
920       result ^= w;
921 
922 
923       x = secured_struct_hash % 0x0000ffd1;
924       y = coeff_4;
925       y *= x;
926       y += coeff_3;
927       y *= x;
928       y += coeff_2;
929       y *= x;
930       y += coeff_1;
931       y *= x;
932       y += coeff_0;
933       y %= 0x0000ffff;
934       w = uint256( keccak256( abi.encode( seed, y ) ) );
935       work_result[9] = w;
936       result ^= w;
937 
938 
939       work_result[10] = result;
940       return work_result;
941    }
942 }
943 
944 // File: contracts/KnsTokenMining.sol
945 
946 
947 pragma solidity ^0.6.0;
948 
949 
950 
951 
952 contract KnsTokenMining
953    is AccessControl,
954       KnsTokenWork
955 {
956    IMintableERC20 public token;
957    mapping (uint256 => uint256) private user_pow_height;
958 
959    uint256 public constant ONE_KNS = 100000000;
960    uint256 public constant MINEABLE_TOKENS = 100 * 1000000 * ONE_KNS;
961 
962    uint256 public constant FINAL_PRINT_RATE = 1500;  // basis points
963    uint256 public constant TOTAL_EMISSION_TIME = 180 days;
964    uint256 public constant EMISSION_COEFF_1 = (MINEABLE_TOKENS * (20000 - FINAL_PRINT_RATE) * TOTAL_EMISSION_TIME);
965    uint256 public constant EMISSION_COEFF_2 = (MINEABLE_TOKENS * (10000 - FINAL_PRINT_RATE));
966    uint256 public constant HC_RESERVE_DECAY_TIME = 5 days;
967    uint256 public constant RECENT_BLOCK_LIMIT = 96;
968 
969    uint256 public start_time;
970    uint256 public token_reserve;
971    uint256 public hc_reserve;
972    uint256 public last_mint_time;
973 
974    bool public is_testing;
975 
976    event Mine( address[] recipients, uint256[] split_percents, uint256 hc_submit, uint256 hc_decay, uint256 token_virtual_mint, uint256[] tokens_mined );
977 
978    constructor( address tok, uint256 start_t, uint256 start_hc_reserve, bool testing )
979       public
980    {
981       token = IMintableERC20(tok);
982       _setupRole( DEFAULT_ADMIN_ROLE, _msgSender() );
983 
984       start_time = start_t;
985       last_mint_time = start_t;
986       hc_reserve = start_hc_reserve;
987       token_reserve = 0;
988 
989       is_testing = testing;
990 
991       _initial_mining_event( start_hc_reserve );
992    }
993 
994    function _initial_mining_event( uint256 start_hc_reserve ) internal
995    {
996       address[] memory recipients = new address[](1);
997       uint256[] memory split_percents = new uint256[](1);
998       uint256[] memory tokens_mined = new uint256[](1);
999 
1000       recipients[0] = address(0);
1001       split_percents[0] = 10000;
1002       tokens_mined[0] = 0;
1003 
1004       emit Mine( recipients, split_percents, start_hc_reserve, 0, 0, tokens_mined );
1005    }
1006 
1007    /**
1008     * Get the hash of the secured struct.
1009     *
1010     * Basically calls keccak256() on parameters.  Mainly exists for readability purposes.
1011     */
1012    function get_secured_struct_hash(
1013       address[] memory recipients,
1014       uint256[] memory split_percents,
1015       uint256 recent_eth_block_number,
1016       uint256 recent_eth_block_hash,
1017       uint256 target,
1018       uint256 pow_height
1019       ) public pure returns (uint256)
1020    {
1021       return uint256( keccak256( abi.encode( recipients, split_percents, recent_eth_block_number, recent_eth_block_hash, target, pow_height ) ) );
1022    }
1023 
1024    /**
1025     * Require w[0]..w[9] are all distinct values.
1026     *
1027     * w[10] is untouched.
1028     */
1029    function check_uniqueness(
1030       uint256[11] memory w
1031       ) public pure
1032    {
1033       // Implement a simple direct comparison algorithm, unroll to optimize gas usage.
1034       require( (w[0] != w[1]) && (w[0] != w[2]) && (w[0] != w[3]) && (w[0] != w[4]) && (w[0] != w[5]) && (w[0] != w[6]) && (w[0] != w[7]) && (w[0] != w[8]) && (w[0] != w[9])
1035                               && (w[1] != w[2]) && (w[1] != w[3]) && (w[1] != w[4]) && (w[1] != w[5]) && (w[1] != w[6]) && (w[1] != w[7]) && (w[1] != w[8]) && (w[1] != w[9])
1036                                                 && (w[2] != w[3]) && (w[2] != w[4]) && (w[2] != w[5]) && (w[2] != w[6]) && (w[2] != w[7]) && (w[2] != w[8]) && (w[2] != w[9])
1037                                                                   && (w[3] != w[4]) && (w[3] != w[5]) && (w[3] != w[6]) && (w[3] != w[7]) && (w[3] != w[8]) && (w[3] != w[9])
1038                                                                                     && (w[4] != w[5]) && (w[4] != w[6]) && (w[4] != w[7]) && (w[4] != w[8]) && (w[4] != w[9])
1039                                                                                                       && (w[5] != w[6]) && (w[5] != w[7]) && (w[5] != w[8]) && (w[5] != w[9])
1040                                                                                                                         && (w[6] != w[7]) && (w[6] != w[8]) && (w[6] != w[9])
1041                                                                                                                                           && (w[7] != w[8]) && (w[7] != w[9])
1042                                                                                                                                                             && (w[8] != w[9]),
1043                "Non-unique work components" );
1044    }
1045 
1046    /**
1047     * Check proof of work for validity.
1048     *
1049     * Throws if the provided fields have any problems.
1050     */
1051    function check_pow(
1052       address[] memory recipients,
1053       uint256[] memory split_percents,
1054       uint256 recent_eth_block_number,
1055       uint256 recent_eth_block_hash,
1056       uint256 target,
1057       uint256 pow_height,
1058       uint256 nonce
1059       ) public view
1060    {
1061       require( recent_eth_block_hash != 0, "Zero block hash not allowed" );
1062       require( recent_eth_block_number <= block.number, "Recent block in future" );
1063       require( recent_eth_block_number + RECENT_BLOCK_LIMIT > block.number, "Recent block too old" );
1064       require( nonce >= recent_eth_block_hash, "Nonce too small" );
1065       require( (recent_eth_block_hash + (1 << 128)) > nonce, "Nonce too large" );
1066       require( uint256( blockhash( recent_eth_block_number ) ) == recent_eth_block_hash, "Block hash mismatch" );
1067 
1068       require( recipients.length <= 5, "Number of recipients cannot exceed 5" );
1069       require( recipients.length == split_percents.length, "Recipient and split percent array size mismatch" );
1070       array_check( split_percents );
1071 
1072       require( get_pow_height( _msgSender(), recipients, split_percents ) + 1 == pow_height, "pow_height mismatch" );
1073       uint256 h = get_secured_struct_hash( recipients, split_percents, recent_eth_block_number, recent_eth_block_hash, target, pow_height );
1074       uint256[11] memory w = work( recent_eth_block_hash, h, nonce );
1075       check_uniqueness( w );
1076       require( w[10] < target, "Work missed target" );     // always fails if target == 0
1077    }
1078 
1079    function array_check( uint256[] memory arr )
1080    internal pure
1081    {
1082       uint256 sum = 0;
1083       for (uint i = 0; i < arr.length; i++)
1084       {
1085          require( arr[i] <= 10000, "Percent array element cannot exceed 10000" );
1086          sum += arr[i];
1087       }
1088       require( sum == 10000, "Split percentages do not add up to 10000" );
1089    }
1090 
1091    function get_emission_curve( uint256 t )
1092       public view returns (uint256)
1093    {
1094       if( t < start_time )
1095          t = start_time;
1096       if( t > start_time + TOTAL_EMISSION_TIME )
1097          t = start_time + TOTAL_EMISSION_TIME;
1098       t -= start_time;
1099       return ((EMISSION_COEFF_1 - (EMISSION_COEFF_2*t))*t) / (10000 * TOTAL_EMISSION_TIME * TOTAL_EMISSION_TIME);
1100    }
1101 
1102    function get_hc_reserve_multiplier( uint256 dt )
1103       public pure returns (uint256)
1104    {
1105       if( dt >= HC_RESERVE_DECAY_TIME )
1106          return 0x80000000;
1107       int256 idt = (int256( dt ) << 32) / int32(HC_RESERVE_DECAY_TIME);
1108       int256 y = -0xa2b23f3;
1109       y *= idt;
1110       y >>= 32;
1111       y += 0x3b9d3bec;
1112       y *= idt;
1113       y >>= 32;
1114       y -= 0xb17217f7;
1115       y *= idt;
1116       y >>= 32;
1117       y += 0x100000000;
1118       if( y < 0 )
1119          y = 0;
1120       return uint256( y );
1121    }
1122 
1123    function get_background_activity( uint256 current_time ) public view
1124       returns (uint256 hc_decay, uint256 token_virtual_mint)
1125    {
1126       hc_decay = 0;
1127       token_virtual_mint = 0;
1128 
1129       if( current_time <= last_mint_time )
1130          return (hc_decay, token_virtual_mint);
1131       uint256 dt = current_time - last_mint_time;
1132 
1133       uint256 f_prev = get_emission_curve( last_mint_time );
1134       uint256 f_now = get_emission_curve( current_time );
1135       if( f_now <= f_prev )
1136          return (hc_decay, token_virtual_mint);
1137 
1138       uint256 mul = get_hc_reserve_multiplier( dt );
1139       uint256 new_hc_reserve = (hc_reserve * mul) >> 32;
1140       hc_decay = hc_reserve - new_hc_reserve;
1141 
1142       token_virtual_mint = f_now - f_prev;
1143 
1144       return (hc_decay, token_virtual_mint);
1145    }
1146 
1147    function process_background_activity( uint256 current_time ) internal
1148       returns (uint256 hc_decay, uint256 token_virtual_mint)
1149    {
1150       (hc_decay, token_virtual_mint) = get_background_activity( current_time );
1151       hc_reserve -= hc_decay;
1152       token_reserve += token_virtual_mint;
1153       last_mint_time = current_time;
1154       return (hc_decay, token_virtual_mint);
1155    }
1156 
1157    /**
1158     * Calculate value in tokens the given hash credits are worth
1159     **/
1160    function get_hash_credits_conversion( uint256 hc )
1161       public view
1162       returns (uint256)
1163    {
1164       require( hc > 1, "HC underflow" );
1165       require( hc < (1 << 128), "HC overflow" );
1166 
1167       // xyk algorithm
1168       uint256 x0 = token_reserve;
1169       uint256 y0 = hc_reserve;
1170 
1171       require( x0 < (1 << 128), "Token balance overflow" );
1172       require( y0 < (1 << 128), "HC balance overflow" );
1173 
1174       uint256 y1 = y0 + hc;
1175       require( y1 < (1 << 128), "HC balance overflow" );
1176 
1177       // x0*y0 = x1*y1 -> x1 = (x0*y0)/y1
1178       // NB above require() ensures overflow safety
1179       uint256 x1 = ((x0*y0)/y1)+1;
1180       require( x1 < x0, "No tokens available" );
1181 
1182       return x0-x1;
1183    }
1184 
1185    /**
1186     * Executes the trade of hash credits to tokens
1187     * Returns number of minted tokens
1188     **/
1189    function convert_hash_credits(
1190       uint256 hc ) internal
1191       returns (uint256)
1192    {
1193       uint256 tokens_minted = get_hash_credits_conversion( hc );
1194       hc_reserve += hc;
1195       token_reserve -= tokens_minted;
1196 
1197       return tokens_minted;
1198    }
1199 
1200    function increment_pow_height(
1201       address[] memory recipients,
1202       uint256[] memory split_percents ) internal
1203    {
1204       user_pow_height[uint256( keccak256( abi.encode( _msgSender(), recipients, split_percents ) ) )] += 1;
1205    }
1206 
1207    function mine_impl(
1208       address[] memory recipients,
1209       uint256[] memory split_percents,
1210       uint256 recent_eth_block_number,
1211       uint256 recent_eth_block_hash,
1212       uint256 target,
1213       uint256 pow_height,
1214       uint256 nonce,
1215       uint256 current_time ) internal
1216    {
1217       check_pow(
1218          recipients,
1219          split_percents,
1220          recent_eth_block_number,
1221          recent_eth_block_hash,
1222          target,
1223          pow_height,
1224          nonce
1225          );
1226       uint256 hc_submit = uint256(-1)/target;
1227 
1228       uint256 hc_decay;
1229       uint256 token_virtual_mint;
1230       (hc_decay, token_virtual_mint) = process_background_activity( current_time );
1231       uint256 token_mined;
1232       token_mined = convert_hash_credits( hc_submit );
1233 
1234       uint256[] memory distribution = distribute( recipients, split_percents, token_mined );
1235       increment_pow_height( recipients, split_percents );
1236 
1237       emit Mine( recipients, split_percents, hc_submit, hc_decay, token_virtual_mint, distribution );
1238    }
1239 
1240    /**
1241     * Get the total number of proof-of-work submitted by a user.
1242     */
1243    function get_pow_height(
1244       address from,
1245       address[] memory recipients,
1246       uint256[] memory split_percents
1247     )
1248       public view
1249       returns (uint256)
1250    {
1251       return user_pow_height[uint256( keccak256( abi.encode( from, recipients, split_percents ) ) )];
1252    }
1253 
1254    /**
1255     * Executes the distribution, minting the tokens to the recipient addresses
1256     **/
1257    function distribute(address[] memory recipients, uint256[] memory split_percents, uint256 token_mined)
1258    internal returns ( uint256[] memory )
1259    {
1260       uint256 remaining = token_mined;
1261       uint256[] memory distribution = new uint256[]( recipients.length );
1262       for (uint i = distribution.length-1; i > 0; i--)
1263       {
1264          distribution[i] = (token_mined * split_percents[i]) / 10000;
1265 	 token.mint( recipients[i], distribution[i] );
1266 	 remaining -= distribution[i];
1267       }
1268       distribution[0] = remaining;
1269       token.mint( recipients[0], remaining );
1270 
1271       return distribution;
1272    }
1273 
1274    function mine(
1275       address[] memory recipients,
1276       uint256[] memory split_percents,
1277       uint256 recent_eth_block_number,
1278       uint256 recent_eth_block_hash,
1279       uint256 target,
1280       uint256 pow_height,
1281       uint256 nonce ) public
1282    {
1283       require( now >= start_time, "Mining has not started" );
1284       mine_impl( recipients, split_percents, recent_eth_block_number, recent_eth_block_hash, target, pow_height, nonce, now );
1285    }
1286 
1287    function test_process_background_activity( uint256 current_time )
1288       public
1289    {
1290       require( is_testing, "Cannot call test method" );
1291       process_background_activity( current_time );
1292    }
1293 
1294    function test_mine(
1295       address[] memory recipients,
1296       uint256[] memory split_percents,
1297       uint256 recent_eth_block_number,
1298       uint256 recent_eth_block_hash,
1299       uint256 target,
1300       uint256 pow_height,
1301       uint256 nonce,
1302       uint256 current_time ) public
1303    {
1304       require( is_testing, "Cannot call test method" );
1305       mine_impl( recipients, split_percents, recent_eth_block_number, recent_eth_block_hash, target, pow_height, nonce, current_time );
1306    }
1307 }