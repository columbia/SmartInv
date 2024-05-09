1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity 0.6.11;
3 
4 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
5 
6  
7 pragma solidity ^0.6.0;
8  
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
31  * (`UintSet`) are supported.
32  */
33 library EnumerableSet {
34     // To implement this library for multiple types with as little code
35     // repetition as possible, we write it in terms of a generic Set type with
36     // bytes32 values.
37     // The Set implementation uses private functions, and user-facing
38     // implementations (such as AddressSet) are just wrappers around the
39     // underlying Set.
40     // This means that we can only create new EnumerableSets for types that fit
41     // in bytes32.
42  
43     struct Set {
44         // Storage of set values
45         bytes32[] _values;
46  
47         // Position of the value in the `values` array, plus 1 because index 0
48         // means a value is not in the set.
49         mapping (bytes32 => uint256) _indexes;
50     }
51  
52     /**
53      * @dev Add a value to a set. O(1).
54      *
55      * Returns true if the value was added to the set, that is if it was not
56      * already present.
57      */
58     function _add(Set storage set, bytes32 value) private returns (bool) {
59         if (!_contains(set, value)) {
60             set._values.push(value);
61             // The value is stored at length-1, but we add 1 to all indexes
62             // and use 0 as a sentinel value
63             set._indexes[value] = set._values.length;
64             return true;
65         } else {
66             return false;
67         }
68     }
69  
70     /**
71      * @dev Removes a value from a set. O(1).
72      *
73      * Returns true if the value was removed from the set, that is if it was
74      * present.
75      */
76     function _remove(Set storage set, bytes32 value) private returns (bool) {
77         // We read and store the value's index to prevent multiple reads from the same storage slot
78         uint256 valueIndex = set._indexes[value];
79  
80         if (valueIndex != 0) { // Equivalent to contains(set, value)
81             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
82             // the array, and then remove the last element (sometimes called as 'swap and pop').
83             // This modifies the order of the array, as noted in {at}.
84  
85             uint256 toDeleteIndex = valueIndex - 1;
86             uint256 lastIndex = set._values.length - 1;
87  
88             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
89             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
90  
91             bytes32 lastvalue = set._values[lastIndex];
92  
93             // Move the last value to the index where the value to delete is
94             set._values[toDeleteIndex] = lastvalue;
95             // Update the index for the moved value
96             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
97  
98             // Delete the slot where the moved value was stored
99             set._values.pop();
100  
101             // Delete the index for the deleted slot
102             delete set._indexes[value];
103  
104             return true;
105         } else {
106             return false;
107         }
108     }
109  
110     /**
111      * @dev Returns true if the value is in the set. O(1).
112      */
113     function _contains(Set storage set, bytes32 value) private view returns (bool) {
114         return set._indexes[value] != 0;
115     }
116  
117     /**
118      * @dev Returns the number of values on the set. O(1).
119      */
120     function _length(Set storage set) private view returns (uint256) {
121         return set._values.length;
122     }
123  
124    /**
125     * @dev Returns the value stored at position `index` in the set. O(1).
126     *
127     * Note that there are no guarantees on the ordering of values inside the
128     * array, and it may change when more values are added or removed.
129     *
130     * Requirements:
131     *
132     * - `index` must be strictly less than {length}.
133     */
134     function _at(Set storage set, uint256 index) private view returns (bytes32) {
135         require(set._values.length > index, "EnumerableSet: index out of bounds");
136         return set._values[index];
137     }
138  
139     // AddressSet
140  
141     struct AddressSet {
142         Set _inner;
143     }
144  
145     /**
146      * @dev Add a value to a set. O(1).
147      *
148      * Returns true if the value was added to the set, that is if it was not
149      * already present.
150      */
151     function add(AddressSet storage set, address value) internal returns (bool) {
152         return _add(set._inner, bytes32(uint256(value)));
153     }
154  
155     /**
156      * @dev Removes a value from a set. O(1).
157      *
158      * Returns true if the value was removed from the set, that is if it was
159      * present.
160      */
161     function remove(AddressSet storage set, address value) internal returns (bool) {
162         return _remove(set._inner, bytes32(uint256(value)));
163     }
164  
165     /**
166      * @dev Returns true if the value is in the set. O(1).
167      */
168     function contains(AddressSet storage set, address value) internal view returns (bool) {
169         return _contains(set._inner, bytes32(uint256(value)));
170     }
171  
172     /**
173      * @dev Returns the number of values in the set. O(1).
174      */
175     function length(AddressSet storage set) internal view returns (uint256) {
176         return _length(set._inner);
177     }
178  
179    /**
180     * @dev Returns the value stored at position `index` in the set. O(1).
181     *
182     * Note that there are no guarantees on the ordering of values inside the
183     * array, and it may change when more values are added or removed.
184     *
185     * Requirements:
186     *
187     * - `index` must be strictly less than {length}.
188     */
189     function at(AddressSet storage set, uint256 index) internal view returns (address) {
190         return address(uint256(_at(set._inner, index)));
191     }
192  
193  
194     // UintSet
195  
196     struct UintSet {
197         Set _inner;
198     }
199  
200     /**
201      * @dev Add a value to a set. O(1).
202      *
203      * Returns true if the value was added to the set, that is if it was not
204      * already present.
205      */
206     function add(UintSet storage set, uint256 value) internal returns (bool) {
207         return _add(set._inner, bytes32(value));
208     }
209  
210     /**
211      * @dev Removes a value from a set. O(1).
212      *
213      * Returns true if the value was removed from the set, that is if it was
214      * present.
215      */
216     function remove(UintSet storage set, uint256 value) internal returns (bool) {
217         return _remove(set._inner, bytes32(value));
218     }
219  
220     /**
221      * @dev Returns true if the value is in the set. O(1).
222      */
223     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
224         return _contains(set._inner, bytes32(value));
225     }
226  
227     /**
228      * @dev Returns the number of values on the set. O(1).
229      */
230     function length(UintSet storage set) internal view returns (uint256) {
231         return _length(set._inner);
232     }
233  
234    /**
235     * @dev Returns the value stored at position `index` in the set. O(1).
236     *
237     * Note that there are no guarantees on the ordering of values inside the
238     * array, and it may change when more values are added or removed.
239     *
240     * Requirements:
241     *
242     * - `index` must be strictly less than {length}.
243     */
244     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
245         return uint256(_at(set._inner, index));
246     }
247 }
248  
249 // File: @openzeppelin/contracts/utils/Address.sol
250  
251  
252 pragma solidity ^0.6.2;
253  
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
276         // This method relies in extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279  
280         uint256 size;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { size := extcodesize(account) }
283         return size > 0;
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
392 // File: @openzeppelin/contracts/GSN/Context.sol
393  
394  
395 pragma solidity ^0.6.0;
396  
397 /*
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with GSN meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address payable) {
409         return msg.sender;
410     }
411  
412     function _msgData() internal view virtual returns (bytes memory) {
413         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
414         return msg.data;
415     }
416 }
417  
418 // File: @openzeppelin/contracts/access/AccessControl.sol
419 
420  
421 pragma solidity ^0.6.0;
422  
423  
424  
425  
426 /**
427  * @dev Contract module that allows children to implement role-based access
428  * control mechanisms.
429  *
430  * Roles are referred to by their `bytes32` identifier. These should be exposed
431  * in the external API and be unique. The best way to achieve this is by
432  * using `public constant` hash digests:
433  *
434  * ```
435  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
436  * ```
437  *
438  * Roles can be used to represent a set of permissions. To restrict access to a
439  * function call, use {hasRole}:
440  *
441  * ```
442  * function foo() public {
443  *     require(hasRole(MY_ROLE, msg.sender));
444  *     ...
445  * }
446  * ```
447  *
448  * Roles can be granted and revoked dynamically via the {grantRole} and
449  * {revokeRole} functions. Each role has an associated admin role, and only
450  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
451  *
452  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
453  * that only accounts with this role will be able to grant or revoke other
454  * roles. More complex role relationships can be created by using
455  * {_setRoleAdmin}.
456  *
457  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
458  * grant and revoke this role. Extra precautions should be taken to secure
459  * accounts that have been granted it.
460  */
461 abstract contract AccessControl is Context {
462     using EnumerableSet for EnumerableSet.AddressSet;
463     using Address for address;
464  
465     struct RoleData {
466         EnumerableSet.AddressSet members;
467         bytes32 adminRole;
468     }
469  
470     mapping (bytes32 => RoleData) private _roles;
471  
472     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
473  
474     /**
475      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
476      *
477      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
478      * {RoleAdminChanged} not being emitted signaling this.
479      *
480      * _Available since v3.1._
481      */
482     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
483  
484     /**
485      * @dev Emitted when `account` is granted `role`.
486      *
487      * `sender` is the account that originated the contract call, an admin role
488      * bearer except when using {_setupRole}.
489      */
490     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
491  
492     /**
493      * @dev Emitted when `account` is revoked `role`.
494      *
495      * `sender` is the account that originated the contract call:
496      *   - if using `revokeRole`, it is the admin role bearer
497      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
498      */
499     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
500  
501     /**
502      * @dev Returns `true` if `account` has been granted `role`.
503      */
504     function hasRole(bytes32 role, address account) public view returns (bool) {
505         return _roles[role].members.contains(account);
506     }
507  
508     /**
509      * @dev Returns the number of accounts that have `role`. Can be used
510      * together with {getRoleMember} to enumerate all bearers of a role.
511      */
512     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
513         return _roles[role].members.length();
514     }
515  
516     /**
517      * @dev Returns one of the accounts that have `role`. `index` must be a
518      * value between 0 and {getRoleMemberCount}, non-inclusive.
519      *
520      * Role bearers are not sorted in any particular way, and their ordering may
521      * change at any point.
522      *
523      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
524      * you perform all queries on the same block. See the following
525      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
526      * for more information.
527      */
528     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
529         return _roles[role].members.at(index);
530     }
531  
532     /**
533      * @dev Returns the admin role that controls `role`. See {grantRole} and
534      * {revokeRole}.
535      *
536      * To change a role's admin, use {_setRoleAdmin}.
537      */
538     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
539         return _roles[role].adminRole;
540     }
541  
542     /**
543      * @dev Grants `role` to `account`.
544      *
545      * If `account` had not been already granted `role`, emits a {RoleGranted}
546      * event.
547      *
548      * Requirements:
549      *
550      * - the caller must have ``role``'s admin role.
551      */
552     function grantRole(bytes32 role, address account) public virtual {
553         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
554  
555         _grantRole(role, account);
556     }
557  
558     /**
559      * @dev Revokes `role` from `account`.
560      *
561      * If `account` had been granted `role`, emits a {RoleRevoked} event.
562      *
563      * Requirements:
564      *
565      * - the caller must have ``role``'s admin role.
566      */
567     function revokeRole(bytes32 role, address account) public virtual {
568         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
569  
570         _revokeRole(role, account);
571     }
572  
573     /**
574      * @dev Revokes `role` from the calling account.
575      *
576      * Roles are often managed via {grantRole} and {revokeRole}: this function's
577      * purpose is to provide a mechanism for accounts to lose their privileges
578      * if they are compromised (such as when a trusted device is misplaced).
579      *
580      * If the calling account had been granted `role`, emits a {RoleRevoked}
581      * event.
582      *
583      * Requirements:
584      *
585      * - the caller must be `account`.
586      */
587     function renounceRole(bytes32 role, address account) public virtual {
588         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
589  
590         _revokeRole(role, account);
591     }
592  
593     /**
594      * @dev Grants `role` to `account`.
595      *
596      * If `account` had not been already granted `role`, emits a {RoleGranted}
597      * event. Note that unlike {grantRole}, this function doesn't perform any
598      * checks on the calling account.
599      *
600      * [WARNING]
601      * ====
602      * This function should only be called from the constructor when setting
603      * up the initial roles for the system.
604      *
605      * Using this function in any other way is effectively circumventing the admin
606      * system imposed by {AccessControl}.
607      * ====
608      */
609     function _setupRole(bytes32 role, address account) internal virtual {
610         _grantRole(role, account);
611     }
612  
613     /**
614      * @dev Sets `adminRole` as ``role``'s admin role.
615      *
616      * Emits a {RoleAdminChanged} event.
617      */
618     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
619         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
620         _roles[role].adminRole = adminRole;
621     }
622  
623     function _grantRole(bytes32 role, address account) private {
624         if (_roles[role].members.add(account)) {
625             emit RoleGranted(role, account, _msgSender());
626         }
627     }
628  
629     function _revokeRole(bytes32 role, address account) private {
630         if (_roles[role].members.remove(account)) {
631             emit RoleRevoked(role, account, _msgSender());
632         }
633     }
634 }
635  
636 // File: src/IFUSDSupplyOracle.sol
637  
638 pragma solidity 0.6.11;
639  
640 interface IFUSDSupplyOracle {
641     function getSupply() external view returns (uint256, uint256);
642 }
643  
644 // File: src/FUSDSupplyOracle.sol
645  
646 pragma solidity 0.6.11;
647  
648  
649  
650 contract FUSDSupplyOracle is AccessControl, IFUSDSupplyOracle {
651     event TotalSupplyUpdate(
652         uint256 value,
653         uint256 lastUpdated,
654         uint64 requestId
655     );
656  
657     uint256 public supply;
658     uint256 public lastUpdated;
659     uint64 public requestId;
660  
661     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
662  
663     constructor() public {
664         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
665         _setupRole(RELAYER_ROLE, msg.sender);
666     }
667  
668     function relay(
669         uint256 _supply,
670         uint256 _lastUpdated,
671         uint64 _requestId
672     ) external {
673         require(hasRole(RELAYER_ROLE, msg.sender), "NOT_A_RELAYER");
674         supply = _supply;
675         lastUpdated = _lastUpdated;
676         requestId = _requestId;
677         emit TotalSupplyUpdate(_supply, _lastUpdated, _requestId);
678     }
679  
680     function getSupply() external override view returns (uint256, uint256) {
681         return (supply, lastUpdated);
682     }
683 }