1 // SPDX-License-Identifier: (Apache-2.0 AND MIT AND BSD-4-Clause)
2 //------------------------------------------------------------------------------
3 //
4 //   Copyright 2020 Fetch.AI Limited
5 //
6 //   Licensed under the Apache License, Version 2.0 (the "License");
7 //   you may not use this file except in compliance with the License.
8 //   You may obtain a copy of the License at
9 //
10 //       http://www.apache.org/licenses/LICENSE-2.0
11 //
12 //   Unless required by applicable law or agreed to in writing, software
13 //   distributed under the License is distributed on an "AS IS" BASIS,
14 //   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15 //   See the License for the specific language governing permissions and
16 //   limitations under the License.
17 //
18 //------------------------------------------------------------------------------
19 
20 pragma solidity ^0.6.0;
21 
22 
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 
100 
101 /**
102  * @dev Library for managing
103  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
104  * types.
105  *
106  * Sets have the following properties:
107  *
108  * - Elements are added, removed, and checked for existence in constant time
109  * (O(1)).
110  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
111  *
112  * ```
113  * contract Example {
114  *     // Add the library methods
115  *     using EnumerableSet for EnumerableSet.AddressSet;
116  *
117  *     // Declare a set state variable
118  *     EnumerableSet.AddressSet private mySet;
119  * }
120  * ```
121  *
122  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
123  * (`UintSet`) are supported.
124  */
125 library EnumerableSet {
126     // To implement this library for multiple types with as little code
127     // repetition as possible, we write it in terms of a generic Set type with
128     // bytes32 values.
129     // The Set implementation uses private functions, and user-facing
130     // implementations (such as AddressSet) are just wrappers around the
131     // underlying Set.
132     // This means that we can only create new EnumerableSets for types that fit
133     // in bytes32.
134 
135     struct Set {
136         // Storage of set values
137         bytes32[] _values;
138 
139         // Position of the value in the `values` array, plus 1 because index 0
140         // means a value is not in the set.
141         mapping (bytes32 => uint256) _indexes;
142     }
143 
144     /**
145      * @dev Add a value to a set. O(1).
146      *
147      * Returns true if the value was added to the set, that is if it was not
148      * already present.
149      */
150     function _add(Set storage set, bytes32 value) private returns (bool) {
151         if (!_contains(set, value)) {
152             set._values.push(value);
153             // The value is stored at length-1, but we add 1 to all indexes
154             // and use 0 as a sentinel value
155             set._indexes[value] = set._values.length;
156             return true;
157         } else {
158             return false;
159         }
160     }
161 
162     /**
163      * @dev Removes a value from a set. O(1).
164      *
165      * Returns true if the value was removed from the set, that is if it was
166      * present.
167      */
168     function _remove(Set storage set, bytes32 value) private returns (bool) {
169         // We read and store the value's index to prevent multiple reads from the same storage slot
170         uint256 valueIndex = set._indexes[value];
171 
172         if (valueIndex != 0) { // Equivalent to contains(set, value)
173             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
174             // the array, and then remove the last element (sometimes called as 'swap and pop').
175             // This modifies the order of the array, as noted in {at}.
176 
177             uint256 toDeleteIndex = valueIndex - 1;
178             uint256 lastIndex = set._values.length - 1;
179 
180             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
181             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
182 
183             bytes32 lastvalue = set._values[lastIndex];
184 
185             // Move the last value to the index where the value to delete is
186             set._values[toDeleteIndex] = lastvalue;
187             // Update the index for the moved value
188             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
189 
190             // Delete the slot where the moved value was stored
191             set._values.pop();
192 
193             // Delete the index for the deleted slot
194             delete set._indexes[value];
195 
196             return true;
197         } else {
198             return false;
199         }
200     }
201 
202     /**
203      * @dev Returns true if the value is in the set. O(1).
204      */
205     function _contains(Set storage set, bytes32 value) private view returns (bool) {
206         return set._indexes[value] != 0;
207     }
208 
209     /**
210      * @dev Returns the number of values on the set. O(1).
211      */
212     function _length(Set storage set) private view returns (uint256) {
213         return set._values.length;
214     }
215 
216    /**
217     * @dev Returns the value stored at position `index` in the set. O(1).
218     *
219     * Note that there are no guarantees on the ordering of values inside the
220     * array, and it may change when more values are added or removed.
221     *
222     * Requirements:
223     *
224     * - `index` must be strictly less than {length}.
225     */
226     function _at(Set storage set, uint256 index) private view returns (bytes32) {
227         require(set._values.length > index, "EnumerableSet: index out of bounds");
228         return set._values[index];
229     }
230 
231     // AddressSet
232 
233     struct AddressSet {
234         Set _inner;
235     }
236 
237     /**
238      * @dev Add a value to a set. O(1).
239      *
240      * Returns true if the value was added to the set, that is if it was not
241      * already present.
242      */
243     function add(AddressSet storage set, address value) internal returns (bool) {
244         return _add(set._inner, bytes32(uint256(value)));
245     }
246 
247     /**
248      * @dev Removes a value from a set. O(1).
249      *
250      * Returns true if the value was removed from the set, that is if it was
251      * present.
252      */
253     function remove(AddressSet storage set, address value) internal returns (bool) {
254         return _remove(set._inner, bytes32(uint256(value)));
255     }
256 
257     /**
258      * @dev Returns true if the value is in the set. O(1).
259      */
260     function contains(AddressSet storage set, address value) internal view returns (bool) {
261         return _contains(set._inner, bytes32(uint256(value)));
262     }
263 
264     /**
265      * @dev Returns the number of values in the set. O(1).
266      */
267     function length(AddressSet storage set) internal view returns (uint256) {
268         return _length(set._inner);
269     }
270 
271    /**
272     * @dev Returns the value stored at position `index` in the set. O(1).
273     *
274     * Note that there are no guarantees on the ordering of values inside the
275     * array, and it may change when more values are added or removed.
276     *
277     * Requirements:
278     *
279     * - `index` must be strictly less than {length}.
280     */
281     function at(AddressSet storage set, uint256 index) internal view returns (address) {
282         return address(uint256(_at(set._inner, index)));
283     }
284 
285 
286     // UintSet
287 
288     struct UintSet {
289         Set _inner;
290     }
291 
292     /**
293      * @dev Add a value to a set. O(1).
294      *
295      * Returns true if the value was added to the set, that is if it was not
296      * already present.
297      */
298     function add(UintSet storage set, uint256 value) internal returns (bool) {
299         return _add(set._inner, bytes32(value));
300     }
301 
302     /**
303      * @dev Removes a value from a set. O(1).
304      *
305      * Returns true if the value was removed from the set, that is if it was
306      * present.
307      */
308     function remove(UintSet storage set, uint256 value) internal returns (bool) {
309         return _remove(set._inner, bytes32(value));
310     }
311 
312     /**
313      * @dev Returns true if the value is in the set. O(1).
314      */
315     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
316         return _contains(set._inner, bytes32(value));
317     }
318 
319     /**
320      * @dev Returns the number of values on the set. O(1).
321      */
322     function length(UintSet storage set) internal view returns (uint256) {
323         return _length(set._inner);
324     }
325 
326    /**
327     * @dev Returns the value stored at position `index` in the set. O(1).
328     *
329     * Note that there are no guarantees on the ordering of values inside the
330     * array, and it may change when more values are added or removed.
331     *
332     * Requirements:
333     *
334     * - `index` must be strictly less than {length}.
335     */
336     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
337         return uint256(_at(set._inner, index));
338     }
339 }
340 
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
365         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
366         // for accounts without code, i.e. `keccak256('')`
367         bytes32 codehash;
368         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
369         // solhint-disable-next-line no-inline-assembly
370         assembly { codehash := extcodehash(account) }
371         return (codehash != accountHash && codehash != 0x0);
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
394         (bool success, ) = recipient.call{ value: amount }("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain`call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417       return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
427         return _functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
447      * with `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
452         require(address(this).balance >= value, "Address: insufficient balance for call");
453         return _functionCallWithValue(target, data, value, errorMessage);
454     }
455 
456     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
457         require(isContract(target), "Address: call to non-contract");
458 
459         // solhint-disable-next-line avoid-low-level-calls
460         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 // solhint-disable-next-line no-inline-assembly
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 
481 /*
482  * @dev Provides information about the current execution context, including the
483  * sender of the transaction and its data. While these are generally available
484  * via msg.sender and msg.data, they should not be accessed in such a direct
485  * manner, since when dealing with GSN meta-transactions the account sending and
486  * paying for execution may not be the actual sender (as far as an application
487  * is concerned).
488  *
489  * This contract is only required for intermediate, library-like contracts.
490  */
491 abstract contract Context {
492     function _msgSender() internal view virtual returns (address payable) {
493         return msg.sender;
494     }
495 
496     function _msgData() internal view virtual returns (bytes memory) {
497         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
498         return msg.data;
499     }
500 }
501 
502 /**
503  * @dev Contract module that allows children to implement role-based access
504  * control mechanisms.
505  *
506  * Roles are referred to by their `bytes32` identifier. These should be exposed
507  * in the external API and be unique. The best way to achieve this is by
508  * using `public constant` hash digests:
509  *
510  * ```
511  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
512  * ```
513  *
514  * Roles can be used to represent a set of permissions. To restrict access to a
515  * function call, use {hasRole}:
516  *
517  * ```
518  * function foo() public {
519  *     require(hasRole(MY_ROLE, msg.sender));
520  *     ...
521  * }
522  * ```
523  *
524  * Roles can be granted and revoked dynamically via the {grantRole} and
525  * {revokeRole} functions. Each role has an associated admin role, and only
526  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
527  *
528  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
529  * that only accounts with this role will be able to grant or revoke other
530  * roles. More complex role relationships can be created by using
531  * {_setRoleAdmin}.
532  *
533  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
534  * grant and revoke this role. Extra precautions should be taken to secure
535  * accounts that have been granted it.
536  */
537 abstract contract AccessControl is Context {
538     using EnumerableSet for EnumerableSet.AddressSet;
539     using Address for address;
540 
541     struct RoleData {
542         EnumerableSet.AddressSet members;
543         bytes32 adminRole;
544     }
545 
546     mapping (bytes32 => RoleData) private _roles;
547 
548     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
549 
550     /**
551      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
552      *
553      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
554      * {RoleAdminChanged} not being emitted signaling this.
555      *
556      * _Available since v3.1._
557      */
558     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
559 
560     /**
561      * @dev Emitted when `account` is granted `role`.
562      *
563      * `sender` is the account that originated the contract call, an admin role
564      * bearer except when using {_setupRole}.
565      */
566     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
567 
568     /**
569      * @dev Emitted when `account` is revoked `role`.
570      *
571      * `sender` is the account that originated the contract call:
572      *   - if using `revokeRole`, it is the admin role bearer
573      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
574      */
575     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
576 
577     /**
578      * @dev Returns `true` if `account` has been granted `role`.
579      */
580     function hasRole(bytes32 role, address account) public view returns (bool) {
581         return _roles[role].members.contains(account);
582     }
583 
584     /**
585      * @dev Returns the number of accounts that have `role`. Can be used
586      * together with {getRoleMember} to enumerate all bearers of a role.
587      */
588     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
589         return _roles[role].members.length();
590     }
591 
592     /**
593      * @dev Returns one of the accounts that have `role`. `index` must be a
594      * value between 0 and {getRoleMemberCount}, non-inclusive.
595      *
596      * Role bearers are not sorted in any particular way, and their ordering may
597      * change at any point.
598      *
599      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
600      * you perform all queries on the same block. See the following
601      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
602      * for more information.
603      */
604     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
605         return _roles[role].members.at(index);
606     }
607 
608     /**
609      * @dev Returns the admin role that controls `role`. See {grantRole} and
610      * {revokeRole}.
611      *
612      * To change a role's admin, use {_setRoleAdmin}.
613      */
614     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
615         return _roles[role].adminRole;
616     }
617 
618     /**
619      * @dev Grants `role` to `account`.
620      *
621      * If `account` had not been already granted `role`, emits a {RoleGranted}
622      * event.
623      *
624      * Requirements:
625      *
626      * - the caller must have ``role``'s admin role.
627      */
628     function grantRole(bytes32 role, address account) public virtual {
629         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
630 
631         _grantRole(role, account);
632     }
633 
634     /**
635      * @dev Revokes `role` from `account`.
636      *
637      * If `account` had been granted `role`, emits a {RoleRevoked} event.
638      *
639      * Requirements:
640      *
641      * - the caller must have ``role``'s admin role.
642      */
643     function revokeRole(bytes32 role, address account) public virtual {
644         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
645 
646         _revokeRole(role, account);
647     }
648 
649     /**
650      * @dev Revokes `role` from the calling account.
651      *
652      * Roles are often managed via {grantRole} and {revokeRole}: this function's
653      * purpose is to provide a mechanism for accounts to lose their privileges
654      * if they are compromised (such as when a trusted device is misplaced).
655      *
656      * If the calling account had been granted `role`, emits a {RoleRevoked}
657      * event.
658      *
659      * Requirements:
660      *
661      * - the caller must be `account`.
662      */
663     function renounceRole(bytes32 role, address account) public virtual {
664         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
665 
666         _revokeRole(role, account);
667     }
668 
669     /**
670      * @dev Grants `role` to `account`.
671      *
672      * If `account` had not been already granted `role`, emits a {RoleGranted}
673      * event. Note that unlike {grantRole}, this function doesn't perform any
674      * checks on the calling account.
675      *
676      * [WARNING]
677      * ====
678      * This function should only be called from the constructor when setting
679      * up the initial roles for the system.
680      *
681      * Using this function in any other way is effectively circumventing the admin
682      * system imposed by {AccessControl}.
683      * ====
684      */
685     function _setupRole(bytes32 role, address account) internal virtual {
686         _grantRole(role, account);
687     }
688 
689     /**
690      * @dev Sets `adminRole` as ``role``'s admin role.
691      *
692      * Emits a {RoleAdminChanged} event.
693      */
694     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
695         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
696         _roles[role].adminRole = adminRole;
697     }
698 
699     function _grantRole(bytes32 role, address account) private {
700         if (_roles[role].members.add(account)) {
701             emit RoleGranted(role, account, _msgSender());
702         }
703     }
704 
705     function _revokeRole(bytes32 role, address account) private {
706         if (_roles[role].members.remove(account)) {
707             emit RoleRevoked(role, account, _msgSender());
708         }
709     }
710 }
711 //------------------------------------------------------------------------------
712 //
713 //   Copyright 2020 Fetch.AI Limited
714 //
715 //   Licensed under the Apache License, Version 2.0 (the "License");
716 //   you may not use this file except in compliance with the License.
717 //   You may obtain a copy of the License at
718 //
719 //       http://www.apache.org/licenses/LICENSE-2.0
720 //
721 //   Unless required by applicable law or agreed to in writing, software
722 //   distributed under the License is distributed on an "AS IS" BASIS,
723 //   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
724 //   See the License for the specific language governing permissions and
725 //   limitations under the License.
726 //
727 //------------------------------------------------------------------------------
728 
729 
730 /*
731  * ABDK Math 64.64 Smart Contract Library.  Copyright © 2019 by ABDK Consulting.
732  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
733  */
734 
735 /**
736  * Smart contract library of mathematical functions operating with signed
737  * 64.64-bit fixed point numbers.  Signed 64.64-bit fixed point number is
738  * basically a simple fraction whose numerator is signed 128-bit integer and
739  * denominator is 2^64.  As long as denominator is always the same, there is no
740  * need to store it, thus in Solidity signed 64.64-bit fixed point numbers are
741  * represented by int128 type holding only the numerator.
742  */
743 library ABDKMath64x64 {
744   /*
745    * Minimum value signed 64.64-bit fixed point number may have. 
746    */
747   int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
748 
749   /*
750    * Maximum value signed 64.64-bit fixed point number may have. 
751    */
752   int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
753 
754   /**
755    * Convert signed 256-bit integer number into signed 64.64-bit fixed point
756    * number.  Revert on overflow.
757    *
758    * @param x signed 256-bit integer number
759    * @return signed 64.64-bit fixed point number
760    */
761   function fromInt (int256 x) internal pure returns (int128) {
762     require (x >= -0x8000000000000000 && x <= 0x7FFFFFFFFFFFFFFF);
763     return int128 (x << 64);
764   }
765 
766   /**
767    * Convert signed 64.64 fixed point number into signed 64-bit integer number
768    * rounding down.
769    *
770    * @param x signed 64.64-bit fixed point number
771    * @return signed 64-bit integer number
772    */
773   function toInt (int128 x) internal pure returns (int64) {
774     return int64 (x >> 64);
775   }
776 
777   /**
778    * Convert unsigned 256-bit integer number into signed 64.64-bit fixed point
779    * number.  Revert on overflow.
780    *
781    * @param x unsigned 256-bit integer number
782    * @return signed 64.64-bit fixed point number
783    */
784   function fromUInt (uint256 x) internal pure returns (int128) {
785     require (x <= 0x7FFFFFFFFFFFFFFF);
786     return int128 (x << 64);
787   }
788 
789   /**
790    * Convert signed 64.64 fixed point number into unsigned 64-bit integer
791    * number rounding down.  Revert on underflow.
792    *
793    * @param x signed 64.64-bit fixed point number
794    * @return unsigned 64-bit integer number
795    */
796   function toUInt (int128 x) internal pure returns (uint64) {
797     require (x >= 0);
798     return uint64 (x >> 64);
799   }
800 
801   /**
802    * Convert signed 128.128 fixed point number into signed 64.64-bit fixed point
803    * number rounding down.  Revert on overflow.
804    *
805    * @param x signed 128.128-bin fixed point number
806    * @return signed 64.64-bit fixed point number
807    */
808   function from128x128 (int256 x) internal pure returns (int128) {
809     int256 result = x >> 64;
810     require (result >= MIN_64x64 && result <= MAX_64x64);
811     return int128 (result);
812   }
813 
814   /**
815    * Convert signed 64.64 fixed point number into signed 128.128 fixed point
816    * number.
817    *
818    * @param x signed 64.64-bit fixed point number
819    * @return signed 128.128 fixed point number
820    */
821   function to128x128 (int128 x) internal pure returns (int256) {
822     return int256 (x) << 64;
823   }
824 
825   /**
826    * Calculate x + y.  Revert on overflow.
827    *
828    * @param x signed 64.64-bit fixed point number
829    * @param y signed 64.64-bit fixed point number
830    * @return signed 64.64-bit fixed point number
831    */
832   function add (int128 x, int128 y) internal pure returns (int128) {
833     int256 result = int256(x) + y;
834     require (result >= MIN_64x64 && result <= MAX_64x64);
835     return int128 (result);
836   }
837 
838   /**
839    * Calculate x - y.  Revert on overflow.
840    *
841    * @param x signed 64.64-bit fixed point number
842    * @param y signed 64.64-bit fixed point number
843    * @return signed 64.64-bit fixed point number
844    */
845   function sub (int128 x, int128 y) internal pure returns (int128) {
846     int256 result = int256(x) - y;
847     require (result >= MIN_64x64 && result <= MAX_64x64);
848     return int128 (result);
849   }
850 
851   /**
852    * Calculate x * y rounding down.  Revert on overflow.
853    *
854    * @param x signed 64.64-bit fixed point number
855    * @param y signed 64.64-bit fixed point number
856    * @return signed 64.64-bit fixed point number
857    */
858   function mul (int128 x, int128 y) internal pure returns (int128) {
859     int256 result = int256(x) * y >> 64;
860     require (result >= MIN_64x64 && result <= MAX_64x64);
861     return int128 (result);
862   }
863 
864   /**
865    * Calculate x * y rounding towards zero, where x is signed 64.64 fixed point
866    * number and y is signed 256-bit integer number.  Revert on overflow.
867    *
868    * @param x signed 64.64 fixed point number
869    * @param y signed 256-bit integer number
870    * @return signed 256-bit integer number
871    */
872   function muli (int128 x, int256 y) internal pure returns (int256) {
873     if (x == MIN_64x64) {
874       require (y >= -0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF &&
875         y <= 0x1000000000000000000000000000000000000000000000000);
876       return -y << 63;
877     } else {
878       bool negativeResult = false;
879       if (x < 0) {
880         x = -x;
881         negativeResult = true;
882       }
883       if (y < 0) {
884         y = -y; // We rely on overflow behavior here
885         negativeResult = !negativeResult;
886       }
887       uint256 absoluteResult = mulu (x, uint256 (y));
888       if (negativeResult) {
889         require (absoluteResult <=
890           0x8000000000000000000000000000000000000000000000000000000000000000);
891         return -int256 (absoluteResult); // We rely on overflow behavior here
892       } else {
893         require (absoluteResult <=
894           0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
895         return int256 (absoluteResult);
896       }
897     }
898   }
899 
900   /**
901    * Calculate x * y rounding down, where x is signed 64.64 fixed point number
902    * and y is unsigned 256-bit integer number.  Revert on overflow.
903    *
904    * @param x signed 64.64 fixed point number
905    * @param y unsigned 256-bit integer number
906    * @return unsigned 256-bit integer number
907    */
908   function mulu (int128 x, uint256 y) internal pure returns (uint256) {
909     if (y == 0) return 0;
910 
911     require (x >= 0);
912 
913     uint256 lo = (uint256 (x) * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)) >> 64;
914     uint256 hi = uint256 (x) * (y >> 128);
915 
916     require (hi <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
917     hi <<= 64;
918 
919     require (hi <=
920       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF - lo);
921     return hi + lo;
922   }
923 
924   /**
925    * Calculate x / y rounding towards zero.  Revert on overflow or when y is
926    * zero.
927    *
928    * @param x signed 64.64-bit fixed point number
929    * @param y signed 64.64-bit fixed point number
930    * @return signed 64.64-bit fixed point number
931    */
932   function div (int128 x, int128 y) internal pure returns (int128) {
933     require (y != 0);
934     int256 result = (int256 (x) << 64) / y;
935     require (result >= MIN_64x64 && result <= MAX_64x64);
936     return int128 (result);
937   }
938 
939   /**
940    * Calculate x / y rounding towards zero, where x and y are signed 256-bit
941    * integer numbers.  Revert on overflow or when y is zero.
942    *
943    * @param x signed 256-bit integer number
944    * @param y signed 256-bit integer number
945    * @return signed 64.64-bit fixed point number
946    */
947   function divi (int256 x, int256 y) internal pure returns (int128) {
948     require (y != 0);
949 
950     bool negativeResult = false;
951     if (x < 0) {
952       x = -x; // We rely on overflow behavior here
953       negativeResult = true;
954     }
955     if (y < 0) {
956       y = -y; // We rely on overflow behavior here
957       negativeResult = !negativeResult;
958     }
959     uint128 absoluteResult = divuu (uint256 (x), uint256 (y));
960     if (negativeResult) {
961       require (absoluteResult <= 0x80000000000000000000000000000000);
962       return -int128 (absoluteResult); // We rely on overflow behavior here
963     } else {
964       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
965       return int128 (absoluteResult); // We rely on overflow behavior here
966     }
967   }
968 
969   /**
970    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
971    * integer numbers.  Revert on overflow or when y is zero.
972    *
973    * @param x unsigned 256-bit integer number
974    * @param y unsigned 256-bit integer number
975    * @return signed 64.64-bit fixed point number
976    */
977   function divu (uint256 x, uint256 y) internal pure returns (int128) {
978     require (y != 0);
979     uint128 result = divuu (x, y);
980     require (result <= uint128 (MAX_64x64));
981     return int128 (result);
982   }
983 
984   /**
985    * Calculate -x.  Revert on overflow.
986    *
987    * @param x signed 64.64-bit fixed point number
988    * @return signed 64.64-bit fixed point number
989    */
990   function neg (int128 x) internal pure returns (int128) {
991     require (x != MIN_64x64);
992     return -x;
993   }
994 
995   /**
996    * Calculate |x|.  Revert on overflow.
997    *
998    * @param x signed 64.64-bit fixed point number
999    * @return signed 64.64-bit fixed point number
1000    */
1001   function abs (int128 x) internal pure returns (int128) {
1002     require (x != MIN_64x64);
1003     return x < 0 ? -x : x;
1004   }
1005 
1006   /**
1007    * Calculate 1 / x rounding towards zero.  Revert on overflow or when x is
1008    * zero.
1009    *
1010    * @param x signed 64.64-bit fixed point number
1011    * @return signed 64.64-bit fixed point number
1012    */
1013   function inv (int128 x) internal pure returns (int128) {
1014     require (x != 0);
1015     int256 result = int256 (0x100000000000000000000000000000000) / x;
1016     require (result >= MIN_64x64 && result <= MAX_64x64);
1017     return int128 (result);
1018   }
1019 
1020   /**
1021    * Calculate arithmetics average of x and y, i.e. (x + y) / 2 rounding down.
1022    *
1023    * @param x signed 64.64-bit fixed point number
1024    * @param y signed 64.64-bit fixed point number
1025    * @return signed 64.64-bit fixed point number
1026    */
1027   function avg (int128 x, int128 y) internal pure returns (int128) {
1028     return int128 ((int256 (x) + int256 (y)) >> 1);
1029   }
1030 
1031   /**
1032    * Calculate geometric average of x and y, i.e. sqrt (x * y) rounding down.
1033    * Revert on overflow or in case x * y is negative.
1034    *
1035    * @param x signed 64.64-bit fixed point number
1036    * @param y signed 64.64-bit fixed point number
1037    * @return signed 64.64-bit fixed point number
1038    */
1039   function gavg (int128 x, int128 y) internal pure returns (int128) {
1040     int256 m = int256 (x) * int256 (y);
1041     require (m >= 0);
1042     require (m <
1043         0x4000000000000000000000000000000000000000000000000000000000000000);
1044     return int128 (sqrtu (uint256 (m)));
1045   }
1046 
1047   /**
1048    * Calculate x^y assuming 0^0 is 1, where x is signed 64.64 fixed point number
1049    * and y is unsigned 256-bit integer number.  Revert on overflow.
1050    *
1051    * @param x signed 64.64-bit fixed point number
1052    * @param y uint256 value
1053    * @return signed 64.64-bit fixed point number
1054    */
1055   function pow (int128 x, uint256 y) internal pure returns (int128) {
1056     uint256 absoluteResult;
1057     bool negativeResult = false;
1058     if (x >= 0) {
1059       absoluteResult = powu (uint256 (x) << 63, y);
1060     } else {
1061       // We rely on overflow behavior here
1062       absoluteResult = powu (uint256 (uint128 (-x)) << 63, y);
1063       negativeResult = y & 1 > 0;
1064     }
1065 
1066     absoluteResult >>= 63;
1067 
1068     if (negativeResult) {
1069       require (absoluteResult <= 0x80000000000000000000000000000000);
1070       return -int128 (absoluteResult); // We rely on overflow behavior here
1071     } else {
1072       require (absoluteResult <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1073       return int128 (absoluteResult); // We rely on overflow behavior here
1074     }
1075   }
1076 
1077   /**
1078    * Calculate sqrt (x) rounding down.  Revert if x < 0.
1079    *
1080    * @param x signed 64.64-bit fixed point number
1081    * @return signed 64.64-bit fixed point number
1082    */
1083   function sqrt (int128 x) internal pure returns (int128) {
1084     require (x >= 0);
1085     return int128 (sqrtu (uint256 (x) << 64));
1086   }
1087 
1088   /**
1089    * Calculate binary logarithm of x.  Revert if x <= 0.
1090    *
1091    * @param x signed 64.64-bit fixed point number
1092    * @return signed 64.64-bit fixed point number
1093    */
1094   function log_2 (int128 x) internal pure returns (int128) {
1095     require (x > 0);
1096 
1097     int256 msb = 0;
1098     int256 xc = x;
1099     if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
1100     if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
1101     if (xc >= 0x10000) { xc >>= 16; msb += 16; }
1102     if (xc >= 0x100) { xc >>= 8; msb += 8; }
1103     if (xc >= 0x10) { xc >>= 4; msb += 4; }
1104     if (xc >= 0x4) { xc >>= 2; msb += 2; }
1105     if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
1106 
1107     int256 result = msb - 64 << 64;
1108     uint256 ux = uint256 (x) << uint256 (127 - msb);
1109     for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
1110       ux *= ux;
1111       uint256 b = ux >> 255;
1112       ux >>= 127 + b;
1113       result += bit * int256 (b);
1114     }
1115 
1116     return int128 (result);
1117   }
1118 
1119   /**
1120    * Calculate natural logarithm of x.  Revert if x <= 0.
1121    *
1122    * @param x signed 64.64-bit fixed point number
1123    * @return signed 64.64-bit fixed point number
1124    */
1125   function ln (int128 x) internal pure returns (int128) {
1126     require (x > 0);
1127 
1128     return int128 (
1129         uint256 (log_2 (x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF >> 128);
1130   }
1131 
1132   /**
1133    * Calculate binary exponent of x.  Revert on overflow.
1134    *
1135    * @param x signed 64.64-bit fixed point number
1136    * @return signed 64.64-bit fixed point number
1137    */
1138   function exp_2 (int128 x) internal pure returns (int128) {
1139     require (x < 0x400000000000000000); // Overflow
1140 
1141     if (x < -0x400000000000000000) return 0; // Underflow
1142 
1143     uint256 result = 0x80000000000000000000000000000000;
1144 
1145     if (x & 0x8000000000000000 > 0)
1146       result = result * 0x16A09E667F3BCC908B2FB1366EA957D3E >> 128;
1147     if (x & 0x4000000000000000 > 0)
1148       result = result * 0x1306FE0A31B7152DE8D5A46305C85EDEC >> 128;
1149     if (x & 0x2000000000000000 > 0)
1150       result = result * 0x1172B83C7D517ADCDF7C8C50EB14A791F >> 128;
1151     if (x & 0x1000000000000000 > 0)
1152       result = result * 0x10B5586CF9890F6298B92B71842A98363 >> 128;
1153     if (x & 0x800000000000000 > 0)
1154       result = result * 0x1059B0D31585743AE7C548EB68CA417FD >> 128;
1155     if (x & 0x400000000000000 > 0)
1156       result = result * 0x102C9A3E778060EE6F7CACA4F7A29BDE8 >> 128;
1157     if (x & 0x200000000000000 > 0)
1158       result = result * 0x10163DA9FB33356D84A66AE336DCDFA3F >> 128;
1159     if (x & 0x100000000000000 > 0)
1160       result = result * 0x100B1AFA5ABCBED6129AB13EC11DC9543 >> 128;
1161     if (x & 0x80000000000000 > 0)
1162       result = result * 0x10058C86DA1C09EA1FF19D294CF2F679B >> 128;
1163     if (x & 0x40000000000000 > 0)
1164       result = result * 0x1002C605E2E8CEC506D21BFC89A23A00F >> 128;
1165     if (x & 0x20000000000000 > 0)
1166       result = result * 0x100162F3904051FA128BCA9C55C31E5DF >> 128;
1167     if (x & 0x10000000000000 > 0)
1168       result = result * 0x1000B175EFFDC76BA38E31671CA939725 >> 128;
1169     if (x & 0x8000000000000 > 0)
1170       result = result * 0x100058BA01FB9F96D6CACD4B180917C3D >> 128;
1171     if (x & 0x4000000000000 > 0)
1172       result = result * 0x10002C5CC37DA9491D0985C348C68E7B3 >> 128;
1173     if (x & 0x2000000000000 > 0)
1174       result = result * 0x1000162E525EE054754457D5995292026 >> 128;
1175     if (x & 0x1000000000000 > 0)
1176       result = result * 0x10000B17255775C040618BF4A4ADE83FC >> 128;
1177     if (x & 0x800000000000 > 0)
1178       result = result * 0x1000058B91B5BC9AE2EED81E9B7D4CFAB >> 128;
1179     if (x & 0x400000000000 > 0)
1180       result = result * 0x100002C5C89D5EC6CA4D7C8ACC017B7C9 >> 128;
1181     if (x & 0x200000000000 > 0)
1182       result = result * 0x10000162E43F4F831060E02D839A9D16D >> 128;
1183     if (x & 0x100000000000 > 0)
1184       result = result * 0x100000B1721BCFC99D9F890EA06911763 >> 128;
1185     if (x & 0x80000000000 > 0)
1186       result = result * 0x10000058B90CF1E6D97F9CA14DBCC1628 >> 128;
1187     if (x & 0x40000000000 > 0)
1188       result = result * 0x1000002C5C863B73F016468F6BAC5CA2B >> 128;
1189     if (x & 0x20000000000 > 0)
1190       result = result * 0x100000162E430E5A18F6119E3C02282A5 >> 128;
1191     if (x & 0x10000000000 > 0)
1192       result = result * 0x1000000B1721835514B86E6D96EFD1BFE >> 128;
1193     if (x & 0x8000000000 > 0)
1194       result = result * 0x100000058B90C0B48C6BE5DF846C5B2EF >> 128;
1195     if (x & 0x4000000000 > 0)
1196       result = result * 0x10000002C5C8601CC6B9E94213C72737A >> 128;
1197     if (x & 0x2000000000 > 0)
1198       result = result * 0x1000000162E42FFF037DF38AA2B219F06 >> 128;
1199     if (x & 0x1000000000 > 0)
1200       result = result * 0x10000000B17217FBA9C739AA5819F44F9 >> 128;
1201     if (x & 0x800000000 > 0)
1202       result = result * 0x1000000058B90BFCDEE5ACD3C1CEDC823 >> 128;
1203     if (x & 0x400000000 > 0)
1204       result = result * 0x100000002C5C85FE31F35A6A30DA1BE50 >> 128;
1205     if (x & 0x200000000 > 0)
1206       result = result * 0x10000000162E42FF0999CE3541B9FFFCF >> 128;
1207     if (x & 0x100000000 > 0)
1208       result = result * 0x100000000B17217F80F4EF5AADDA45554 >> 128;
1209     if (x & 0x80000000 > 0)
1210       result = result * 0x10000000058B90BFBF8479BD5A81B51AD >> 128;
1211     if (x & 0x40000000 > 0)
1212       result = result * 0x1000000002C5C85FDF84BD62AE30A74CC >> 128;
1213     if (x & 0x20000000 > 0)
1214       result = result * 0x100000000162E42FEFB2FED257559BDAA >> 128;
1215     if (x & 0x10000000 > 0)
1216       result = result * 0x1000000000B17217F7D5A7716BBA4A9AE >> 128;
1217     if (x & 0x8000000 > 0)
1218       result = result * 0x100000000058B90BFBE9DDBAC5E109CCE >> 128;
1219     if (x & 0x4000000 > 0)
1220       result = result * 0x10000000002C5C85FDF4B15DE6F17EB0D >> 128;
1221     if (x & 0x2000000 > 0)
1222       result = result * 0x1000000000162E42FEFA494F1478FDE05 >> 128;
1223     if (x & 0x1000000 > 0)
1224       result = result * 0x10000000000B17217F7D20CF927C8E94C >> 128;
1225     if (x & 0x800000 > 0)
1226       result = result * 0x1000000000058B90BFBE8F71CB4E4B33D >> 128;
1227     if (x & 0x400000 > 0)
1228       result = result * 0x100000000002C5C85FDF477B662B26945 >> 128;
1229     if (x & 0x200000 > 0)
1230       result = result * 0x10000000000162E42FEFA3AE53369388C >> 128;
1231     if (x & 0x100000 > 0)
1232       result = result * 0x100000000000B17217F7D1D351A389D40 >> 128;
1233     if (x & 0x80000 > 0)
1234       result = result * 0x10000000000058B90BFBE8E8B2D3D4EDE >> 128;
1235     if (x & 0x40000 > 0)
1236       result = result * 0x1000000000002C5C85FDF4741BEA6E77E >> 128;
1237     if (x & 0x20000 > 0)
1238       result = result * 0x100000000000162E42FEFA39FE95583C2 >> 128;
1239     if (x & 0x10000 > 0)
1240       result = result * 0x1000000000000B17217F7D1CFB72B45E1 >> 128;
1241     if (x & 0x8000 > 0)
1242       result = result * 0x100000000000058B90BFBE8E7CC35C3F0 >> 128;
1243     if (x & 0x4000 > 0)
1244       result = result * 0x10000000000002C5C85FDF473E242EA38 >> 128;
1245     if (x & 0x2000 > 0)
1246       result = result * 0x1000000000000162E42FEFA39F02B772C >> 128;
1247     if (x & 0x1000 > 0)
1248       result = result * 0x10000000000000B17217F7D1CF7D83C1A >> 128;
1249     if (x & 0x800 > 0)
1250       result = result * 0x1000000000000058B90BFBE8E7BDCBE2E >> 128;
1251     if (x & 0x400 > 0)
1252       result = result * 0x100000000000002C5C85FDF473DEA871F >> 128;
1253     if (x & 0x200 > 0)
1254       result = result * 0x10000000000000162E42FEFA39EF44D91 >> 128;
1255     if (x & 0x100 > 0)
1256       result = result * 0x100000000000000B17217F7D1CF79E949 >> 128;
1257     if (x & 0x80 > 0)
1258       result = result * 0x10000000000000058B90BFBE8E7BCE544 >> 128;
1259     if (x & 0x40 > 0)
1260       result = result * 0x1000000000000002C5C85FDF473DE6ECA >> 128;
1261     if (x & 0x20 > 0)
1262       result = result * 0x100000000000000162E42FEFA39EF366F >> 128;
1263     if (x & 0x10 > 0)
1264       result = result * 0x1000000000000000B17217F7D1CF79AFA >> 128;
1265     if (x & 0x8 > 0)
1266       result = result * 0x100000000000000058B90BFBE8E7BCD6D >> 128;
1267     if (x & 0x4 > 0)
1268       result = result * 0x10000000000000002C5C85FDF473DE6B2 >> 128;
1269     if (x & 0x2 > 0)
1270       result = result * 0x1000000000000000162E42FEFA39EF358 >> 128;
1271     if (x & 0x1 > 0)
1272       result = result * 0x10000000000000000B17217F7D1CF79AB >> 128;
1273 
1274     result >>= uint256 (63 - (x >> 64));
1275     require (result <= uint256 (MAX_64x64));
1276 
1277     return int128 (result);
1278   }
1279 
1280   /**
1281    * Calculate natural exponent of x.  Revert on overflow.
1282    *
1283    * @param x signed 64.64-bit fixed point number
1284    * @return signed 64.64-bit fixed point number
1285    */
1286   function exp (int128 x) internal pure returns (int128) {
1287     require (x < 0x400000000000000000); // Overflow
1288 
1289     if (x < -0x400000000000000000) return 0; // Underflow
1290 
1291     return exp_2 (
1292         int128 (int256 (x) * 0x171547652B82FE1777D0FFDA0D23A7D12 >> 128));
1293   }
1294 
1295   /**
1296    * Calculate x / y rounding towards zero, where x and y are unsigned 256-bit
1297    * integer numbers.  Revert on overflow or when y is zero.
1298    *
1299    * @param x unsigned 256-bit integer number
1300    * @param y unsigned 256-bit integer number
1301    * @return unsigned 64.64-bit fixed point number
1302    */
1303   function divuu (uint256 x, uint256 y) private pure returns (uint128) {
1304     require (y != 0);
1305 
1306     uint256 result;
1307 
1308     if (x <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1309       result = (x << 64) / y;
1310     else {
1311       uint256 msb = 192;
1312       uint256 xc = x >> 192;
1313       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
1314       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
1315       if (xc >= 0x100) { xc >>= 8; msb += 8; }
1316       if (xc >= 0x10) { xc >>= 4; msb += 4; }
1317       if (xc >= 0x4) { xc >>= 2; msb += 2; }
1318       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
1319 
1320       result = (x << 255 - msb) / ((y - 1 >> msb - 191) + 1);
1321       require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1322 
1323       uint256 hi = result * (y >> 128);
1324       uint256 lo = result * (y & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1325 
1326       uint256 xh = x >> 192;
1327       uint256 xl = x << 64;
1328 
1329       if (xl < lo) xh -= 1;
1330       xl -= lo; // We rely on overflow behavior here
1331       lo = hi << 128;
1332       if (xl < lo) xh -= 1;
1333       xl -= lo; // We rely on overflow behavior here
1334 
1335       assert (xh == hi >> 128);
1336 
1337       result += xl / y;
1338     }
1339 
1340     require (result <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
1341     return uint128 (result);
1342   }
1343 
1344   /**
1345    * Calculate x^y assuming 0^0 is 1, where x is unsigned 129.127 fixed point
1346    * number and y is unsigned 256-bit integer number.  Revert on overflow.
1347    *
1348    * @param x unsigned 129.127-bit fixed point number
1349    * @param y uint256 value
1350    * @return unsigned 129.127-bit fixed point number
1351    */
1352   function powu (uint256 x, uint256 y) private pure returns (uint256) {
1353     if (y == 0) return 0x80000000000000000000000000000000;
1354     else if (x == 0) return 0;
1355     else {
1356       int256 msb = 0;
1357       uint256 xc = x;
1358       if (xc >= 0x100000000000000000000000000000000) { xc >>= 128; msb += 128; }
1359       if (xc >= 0x10000000000000000) { xc >>= 64; msb += 64; }
1360       if (xc >= 0x100000000) { xc >>= 32; msb += 32; }
1361       if (xc >= 0x10000) { xc >>= 16; msb += 16; }
1362       if (xc >= 0x100) { xc >>= 8; msb += 8; }
1363       if (xc >= 0x10) { xc >>= 4; msb += 4; }
1364       if (xc >= 0x4) { xc >>= 2; msb += 2; }
1365       if (xc >= 0x2) msb += 1;  // No need to shift xc anymore
1366 
1367       int256 xe = msb - 127;
1368       if (xe > 0) x >>= uint256 (xe);
1369       else x <<= uint256 (-xe);
1370 
1371       uint256 result = 0x80000000000000000000000000000000;
1372       int256 re = 0;
1373 
1374       while (y > 0) {
1375         if (y & 1 > 0) {
1376           result = result * x;
1377           y -= 1;
1378           re += xe;
1379           if (result >=
1380             0x8000000000000000000000000000000000000000000000000000000000000000) {
1381             result >>= 128;
1382             re += 1;
1383           } else result >>= 127;
1384           if (re < -127) return 0; // Underflow
1385           require (re < 128); // Overflow
1386         } else {
1387           x = x * x;
1388           y >>= 1;
1389           xe <<= 1;
1390           if (x >=
1391             0x8000000000000000000000000000000000000000000000000000000000000000) {
1392             x >>= 128;
1393             xe += 1;
1394           } else x >>= 127;
1395           if (xe < -127) return 0; // Underflow
1396           require (xe < 128); // Overflow
1397         }
1398       }
1399 
1400       if (re > 0) result <<= uint256 (re);
1401       else if (re < 0) result >>= uint256 (-re);
1402 
1403       return result;
1404     }
1405   }
1406 
1407   /**
1408    * Calculate sqrt (x) rounding down, where x is unsigned 256-bit integer
1409    * number.
1410    *
1411    * @param x unsigned 256-bit integer number
1412    * @return unsigned 128-bit integer number
1413    */
1414   function sqrtu (uint256 x) private pure returns (uint128) {
1415     if (x == 0) return 0;
1416     else {
1417       uint256 xx = x;
1418       uint256 r = 1;
1419       if (xx >= 0x100000000000000000000000000000000) { xx >>= 128; r <<= 64; }
1420       if (xx >= 0x10000000000000000) { xx >>= 64; r <<= 32; }
1421       if (xx >= 0x100000000) { xx >>= 32; r <<= 16; }
1422       if (xx >= 0x10000) { xx >>= 16; r <<= 8; }
1423       if (xx >= 0x100) { xx >>= 8; r <<= 4; }
1424       if (xx >= 0x10) { xx >>= 4; r <<= 2; }
1425       if (xx >= 0x8) { r <<= 1; }
1426       r = (r + x / r) >> 1;
1427       r = (r + x / r) >> 1;
1428       r = (r + x / r) >> 1;
1429       r = (r + x / r) >> 1;
1430       r = (r + x / r) >> 1;
1431       r = (r + x / r) >> 1;
1432       r = (r + x / r) >> 1; // Seven iterations should be enough
1433       uint256 r1 = x / r;
1434       return uint128 (r < r1 ? r : r1);
1435     }
1436   }
1437 }
1438 //------------------------------------------------------------------------------
1439 //
1440 //   Copyright 2020 Fetch.AI Limited
1441 //
1442 //   Licensed under the Apache License, Version 2.0 (the "License");
1443 //   you may not use this file except in compliance with the License.
1444 //   You may obtain a copy of the License at
1445 //
1446 //       http://www.apache.org/licenses/LICENSE-2.0
1447 //
1448 //   Unless required by applicable law or agreed to in writing, software
1449 //   distributed under the License is distributed on an "AS IS" BASIS,
1450 //   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1451 //   See the License for the specific language governing permissions and
1452 //   limitations under the License.
1453 //
1454 //------------------------------------------------------------------------------
1455 
1456 
1457 
1458 
1459 /**
1460  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1461  * checks.
1462  *
1463  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1464  * in bugs, because programmers usually assume that an overflow raises an
1465  * error, which is the standard behavior in high level programming languages.
1466  * `SafeMath` restores this intuition by reverting the transaction when an
1467  * operation overflows.
1468  *
1469  * Using this library instead of the unchecked operations eliminates an entire
1470  * class of bugs, so it's recommended to use it always.
1471  */
1472 library SafeMath {
1473     /**
1474      * @dev Returns the addition of two unsigned integers, reverting on
1475      * overflow.
1476      *
1477      * Counterpart to Solidity's `+` operator.
1478      *
1479      * Requirements:
1480      *
1481      * - Addition cannot overflow.
1482      */
1483     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1484         uint256 c = a + b;
1485         require(c >= a, "SafeMath: addition overflow");
1486 
1487         return c;
1488     }
1489 
1490     /**
1491      * @dev Returns the subtraction of two unsigned integers, reverting on
1492      * overflow (when the result is negative).
1493      *
1494      * Counterpart to Solidity's `-` operator.
1495      *
1496      * Requirements:
1497      *
1498      * - Subtraction cannot overflow.
1499      */
1500     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1501         return sub(a, b, "SafeMath: subtraction overflow");
1502     }
1503 
1504     /**
1505      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1506      * overflow (when the result is negative).
1507      *
1508      * Counterpart to Solidity's `-` operator.
1509      *
1510      * Requirements:
1511      *
1512      * - Subtraction cannot overflow.
1513      */
1514     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1515         require(b <= a, errorMessage);
1516         uint256 c = a - b;
1517 
1518         return c;
1519     }
1520 
1521     /**
1522      * @dev Returns the multiplication of two unsigned integers, reverting on
1523      * overflow.
1524      *
1525      * Counterpart to Solidity's `*` operator.
1526      *
1527      * Requirements:
1528      *
1529      * - Multiplication cannot overflow.
1530      */
1531     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1532         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1533         // benefit is lost if 'b' is also tested.
1534         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1535         if (a == 0) {
1536             return 0;
1537         }
1538 
1539         uint256 c = a * b;
1540         require(c / a == b, "SafeMath: multiplication overflow");
1541 
1542         return c;
1543     }
1544 
1545     /**
1546      * @dev Returns the integer division of two unsigned integers. Reverts on
1547      * division by zero. The result is rounded towards zero.
1548      *
1549      * Counterpart to Solidity's `/` operator. Note: this function uses a
1550      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1551      * uses an invalid opcode to revert (consuming all remaining gas).
1552      *
1553      * Requirements:
1554      *
1555      * - The divisor cannot be zero.
1556      */
1557     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1558         return div(a, b, "SafeMath: division by zero");
1559     }
1560 
1561     /**
1562      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1563      * division by zero. The result is rounded towards zero.
1564      *
1565      * Counterpart to Solidity's `/` operator. Note: this function uses a
1566      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1567      * uses an invalid opcode to revert (consuming all remaining gas).
1568      *
1569      * Requirements:
1570      *
1571      * - The divisor cannot be zero.
1572      */
1573     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1574         require(b > 0, errorMessage);
1575         uint256 c = a / b;
1576         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1577 
1578         return c;
1579     }
1580 
1581     /**
1582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1583      * Reverts when dividing by zero.
1584      *
1585      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1586      * opcode (which leaves remaining gas untouched) while Solidity uses an
1587      * invalid opcode to revert (consuming all remaining gas).
1588      *
1589      * Requirements:
1590      *
1591      * - The divisor cannot be zero.
1592      */
1593     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1594         return mod(a, b, "SafeMath: modulo by zero");
1595     }
1596 
1597     /**
1598      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1599      * Reverts with custom message when dividing by zero.
1600      *
1601      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1602      * opcode (which leaves remaining gas untouched) while Solidity uses an
1603      * invalid opcode to revert (consuming all remaining gas).
1604      *
1605      * Requirements:
1606      *
1607      * - The divisor cannot be zero.
1608      */
1609     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1610         require(b != 0, errorMessage);
1611         return a % b;
1612     }
1613 }
1614 
1615 
1616 library AssetLib {
1617     using SafeMath for uint256;
1618 
1619 
1620     struct Asset {
1621         uint256 principal;
1622         uint256 compoundInterest;
1623     }
1624 
1625 
1626     function composite(Asset storage asset)
1627         internal view returns(uint256)
1628     {
1629         return asset.principal.add(asset.compoundInterest);
1630     }
1631 
1632 
1633     function compositeM(Asset memory asset)
1634         internal pure returns(uint256)
1635     {
1636         return asset.principal.add(asset.compoundInterest);
1637     }
1638 
1639 
1640     function imAddS(Asset memory to, Asset storage amount)
1641         internal view
1642     {
1643         to.principal = to.principal.add(amount.principal);
1644         to.compoundInterest = to.compoundInterest.add(amount.compoundInterest);
1645     }
1646 
1647 
1648     function iAdd(Asset storage to, Asset memory amount)
1649         internal
1650     {
1651         to.principal = to.principal.add(amount.principal);
1652         to.compoundInterest = to.compoundInterest.add(amount.compoundInterest);
1653     }
1654 
1655 
1656     function imSubM(Asset memory from, Asset storage amount)
1657         internal view
1658     {
1659         from.principal = from.principal.sub(amount.principal);
1660         from.compoundInterest = from.compoundInterest.sub(amount.compoundInterest);
1661     }
1662 
1663 
1664     function iSub(Asset storage from, Asset memory amount)
1665         internal
1666     {
1667         from.principal = from.principal.sub(amount.principal);
1668         from.compoundInterest = from.compoundInterest.sub(amount.compoundInterest);
1669     }
1670 
1671 
1672     function iSubPrincipalFirst(Asset storage from, uint256 amount)
1673         internal returns(Asset memory _amount)
1674     {
1675         if (from.principal >= amount) {
1676             from.principal = from.principal.sub(amount);
1677             _amount.principal = amount;
1678         } else {
1679            _amount.compoundInterest = amount.sub(from.principal);
1680             // NOTE(pb): Fail as soon as possible (even though this ordering of lines makes code less readable):
1681             from.compoundInterest = from.compoundInterest.sub(_amount.compoundInterest);
1682 
1683             _amount.principal = from.principal;
1684             from.principal = 0;
1685         }
1686     }
1687 
1688 
1689     function iSubCompoundInterestFirst(Asset storage from, uint256 amount)
1690         internal returns(Asset memory _amount)
1691     {
1692         if (from.compoundInterest >= amount) {
1693             from.compoundInterest = from.compoundInterest.sub(amount);
1694             _amount.compoundInterest = amount;
1695         } else {
1696             _amount.principal = amount.sub(from.compoundInterest);
1697             // NOTE(pb): Fail as soon as possible (even though this ordering of lines makes code less readable):
1698             from.principal = from.principal.sub(_amount.principal);
1699 
1700             _amount.compoundInterest = from.compoundInterest;
1701             from.compoundInterest = 0;
1702         }
1703     }
1704 
1705     // NOTE(pb): This is a little bit more expensive version of the commented-out function bellow,
1706     //           but it avoids copying the code by reusing (calling existing functions), and so
1707     //           making code more reliable and readable.
1708     function iRelocatePrincipalFirst(Asset storage from, Asset storage to, uint256 amount)
1709         internal returns(Asset memory _amount)
1710     {
1711         _amount = iSubPrincipalFirst(from, amount);
1712         iAdd(to, _amount);
1713     }
1714 
1715     // NOTE(pb): This is a little bit more expensive version of the commented-out function bellow,
1716     //           but it avoids copying the code by reusing (calling existing functions), and so
1717     //           making code more reliable and readable.
1718     function iRelocateCompoundInterestFirst(Asset storage from, Asset storage to, uint256 amount)
1719         internal returns(Asset memory _amount)
1720     {
1721         _amount = iSubCompoundInterestFirst(from, amount);
1722         iAdd(to, _amount);
1723     }
1724 
1725     ////NOTE(pb): Whole Commented out code block bellow consumes less gas then variant above, however for the price
1726     ////          of copy code which can be rather called (see notes in the commented out code):
1727     //function iRelocatePrincipalFirst(Asset storage from, Asset storage to, uint256 amount)
1728     //    internal pure returns(Asset memory _amount)
1729     //{
1730     //    if (from.principal >= amount) {
1731     //        from.principal = from.principal.sub(amount);
1732     //        to.principal = to.principal.add(amount);
1733     //        // NOTE(pb): Line bellow is enough - no necessity to call subtract for compound as it is called in
1734     //        //           uncommented variant of this function above.
1735     //        _amount.principal = amount;
1736     //    } else {
1737     //        _amount.compoundInterest = amount.sub(from.principal);
1738     //        // NOTE(pb): Fail as soon as possible (even though this ordering of lines makes code less readable):
1739     //        from.compoundInterest = from.compoundInterest.sub(_amount.compoundInterest);
1740     //        to.compoundInterest = to.compoundInterest.add(_amount.compoundInterest);
1741     //        to.principal = to.principal.add(from.principal);
1742 
1743     //        _amount.principal = from.principal;
1744     //        // NOTE(pb): Line bellow is enough - no necessity to call subtract for principal as it is called in
1745     //        //           uncommented variant of this function above.
1746     //         from.principal = 0;
1747     //     }
1748     //}
1749 
1750 
1751     //function iRelocateCompoundInterestFirst(Asset storage from, Asset storage to, uint256 amount)
1752     //    internal pure returns(Asset memory _amount)
1753     //{
1754     //    if (from.compoundInterest >= amount) {
1755     //        from.compoundInterest = from.compoundInterest.sub(amount);
1756     //        to.compoundInterest = to.compoundInterest.add(amount);
1757     //        // NOTE(pb): Line bellow is enough - no necessity to call subtract for principal as it is called in
1758     //        //           uncommented variant of this function above.
1759     //        _amount.compoundInterest = amount;
1760     //    } else {
1761     //        _amount.principal = amount.sub(from.compoundInterest);
1762     //        // NOTE(pb): Fail as soon as possible (even though this ordering of lines makes code less readable):
1763     //        from.principal = from.principal.sub(_amount.principal);
1764     //        to.principal = to.principal.add(_amount.principal);
1765     //        to.compoundInterest = to.compoundInterest.add(from.compoundInterest);
1766 
1767     //        _amount.compoundInterest = from.compoundInterest;
1768     //        // NOTE(pb): Line bellow is enough - no necessity to call subtract for compound as it is called in
1769     //        //           uncommented variant of this function above.
1770     //         from.compoundInterest = 0;
1771     //    }
1772     //}
1773 }
1774 
1775 
1776 library Finance {
1777     using SafeMath for uint256;
1778     using AssetLib for AssetLib.Asset;
1779 
1780 
1781     function pow (int128 x, uint256 n)
1782         internal pure returns (int128 r)
1783     {
1784         r = ABDKMath64x64.fromUInt (1);
1785 
1786         while (n != 0) {
1787             if ((n & 1) != 0) {
1788                 r = ABDKMath64x64.mul (r, x);
1789                 n -= 1;
1790             } else {
1791                 x = ABDKMath64x64.mul (x, x);
1792                 n >>= 1;
1793             }
1794         }
1795     }
1796 
1797 
1798     function compoundInterest (uint256 principal, uint256 ratio, uint256 n)
1799         internal pure returns (uint256)
1800     {
1801         return ABDKMath64x64.mulu (
1802             pow (
1803                 ABDKMath64x64.add (
1804                     ABDKMath64x64.fromUInt (1),
1805                     ABDKMath64x64.divu (
1806                           ratio,
1807                           10**18)
1808                     ),
1809                     n
1810                 ),
1811             principal);
1812     }
1813 
1814 
1815     function compoundInterest (uint256 principal, int256 ratio, uint256 n)
1816         internal pure returns (uint256)
1817     {
1818         return ABDKMath64x64.mulu (
1819             pow (
1820                 ABDKMath64x64.add (
1821                     ABDKMath64x64.fromUInt (1),
1822                     ABDKMath64x64.divi (
1823                           ratio,
1824                           10**18)
1825                     ),
1826                     n
1827                 ),
1828             principal);
1829     }
1830 
1831 
1832     function compoundInterest (AssetLib.Asset storage asset, uint256 interest, uint256 n)
1833         internal
1834     {
1835         uint256 composite = asset.composite();
1836         composite = compoundInterest(composite, interest, n);
1837 
1838         asset.compoundInterest = composite.sub(asset.principal);
1839     }
1840 }
1841 
1842 
1843 // [Canonical ERC20-FET] = 10**(-18)x[ECR20-FET]
1844 contract Staking is AccessControl {
1845     using SafeMath for uint256;
1846     using AssetLib for AssetLib.Asset;
1847 
1848     struct InterestRatePerBlock {
1849         uint256 sinceBlock;
1850         // NOTE(pb): To simplify, interest rate value can *not* be negative
1851         uint256 rate; // Signed interest rate in [10**18] units => real_rate = rate / 10**18.
1852         //// Number of users who bound stake while this particular interest rate was still in effect.
1853         //// This enables to identify when we can delete interest rates which are no more used by anyone
1854         //// (continuously from the beginning).
1855         //uint256 numberOfRegisteredUsers;
1856     }
1857 
1858     struct Stake {
1859         uint256 sinceBlock;
1860         uint256 sinceInterestRateIndex;
1861         AssetLib.Asset asset;
1862     }
1863 
1864     struct LockedAsset {
1865         uint256 liquidSinceBlock;
1866         AssetLib.Asset asset;
1867     }
1868 
1869     struct Locked {
1870         AssetLib.Asset aggregate;
1871         LockedAsset[] assets;
1872     }
1873 
1874     // *******    EVENTS    ********
1875     event BindStake(
1876           address indexed stakerAddress
1877         , uint256 indexed sinceInterestRateIndex
1878         , uint256 principal
1879         , uint256 compoundInterest
1880     );
1881 
1882     /**
1883      * @dev This event is triggered exclusivelly to recalculate the compount interest of ALREADY staked asset
1884      *      for the poriod since it was calculated the last time. This means this event does *NOT* include *YET*
1885      *      any added (resp. removed) asset user is currently binding (resp. unbinding).
1886      *      The main motivation for this event is to give listener opportunity to get feedback what is the 
1887      *      user's staked asset value with compound interrest recalculated to *CURRENT* block *BEFORE* user's
1888      *      action (binding resp. unbinding) affects user's staked asset value.
1889      */
1890     event StakeCompoundInterest(
1891           address indexed stakerAddress
1892         , uint256 indexed sinceInterestRateIndex
1893         , uint256 principal // = previous_principal
1894         , uint256 compoundInterest // = previous_principal * (pow(1+interest, _getBlockNumber()-since_block) - 1)
1895     );
1896 
1897     event LiquidityDeposited(
1898           address indexed stakerAddress
1899         , uint256 amount
1900     );
1901 
1902     event LiquidityUnlocked(
1903           address indexed stakerAddress
1904         , uint256 principal
1905         , uint256 compoundInterest
1906     );
1907 
1908     event UnbindStake(
1909           address indexed stakerAddress
1910         , uint256 indexed liquidSinceBlock
1911         , uint256 principal
1912         , uint256 compoundInterest
1913     );
1914 
1915     event NewInterestRate(
1916           uint256 indexed index
1917         , uint256 rate // Signed interest rate in [10**18] units => real_rate = rate / 10**18
1918     );
1919 
1920     event Withdraw(
1921           address indexed stakerAddress
1922         , uint256 principal
1923         , uint256 compoundInterest
1924     );
1925 
1926     event LockPeriod(uint64 numOfBlocks);
1927     event Pause(uint256 sinceBlock);
1928     event TokenWithdrawal(address targetAddress, uint256 amount);
1929     event ExcessTokenWithdrawal(address targetAddress, uint256 amount);
1930     event RewardsPoolTokenTopUp(address sender, uint256 amount);
1931     event RewardsPoolTokenWithdrawal(address targetAddress, uint256 amount);
1932     event DeleteContract();
1933 
1934 
1935     bytes32 public constant DELEGATE_ROLE = keccak256("DELEGATE_ROLE");
1936     uint256 public constant DELETE_PROTECTION_PERIOD = 370285;// 60*24*60*60[s] / (14[s/block]) = 370285[block];
1937 
1938     IERC20 public _token;
1939 
1940     // NOTE(pb): This needs to be either completely replaced by multisig concept,
1941     //           or at least joined with multisig.
1942     //           This contract does not have, by-design on conceptual level, any clearly defined repeating
1943     //           life-cycle behaviour (for instance: `initialise -> staking-period -> locked-period` cycle
1944     //           with clear start & end of each life-cycle. Life-cycle of this contract is single monolithic
1945     //           period `creation -> delete-contract`, where there is no clear place where to `update` the
1946     //           earliest deletion block value, thus it would need to be set once at the contract creation
1947     //           point what completely defeats the protection by time delay.
1948     uint256 public _earliestDelete;
1949     
1950     uint256 public _pausedSinceBlock;
1951     uint64 public _lockPeriodInBlocks;
1952 
1953     // Represents amount of reward funds which are dedicated to cover accrued compound interest during user withdrawals.
1954     uint256 public _rewardsPoolBalance;
1955     // Accumulated global value of all principals (from all users) currently held in this contract (liquid, bound and locked).
1956     uint256 public _accruedGlobalPrincipal;
1957     AssetLib.Asset public _accruedGlobalLiquidity; // Exact
1958     AssetLib.Asset public _accruedGlobalLocked; // Exact
1959 
1960     uint256 public _interestRatesStartIdx;
1961     uint256 public _interestRatesNextIdx;
1962     mapping(uint256 => InterestRatePerBlock) public _interestRates;
1963 
1964     mapping(address => Stake) _stakes;
1965     mapping(address => Locked) _locked;
1966     mapping(address => AssetLib.Asset) public _liquidity;
1967 
1968 
1969     /* Only callable by owner */
1970     modifier onlyOwner() {
1971         require(_isOwner(), "Caller is not an owner");
1972         _;
1973     }
1974 
1975     /* Only callable by owner or delegate */
1976     modifier onlyDelegate() {
1977         require(_isOwner() || hasRole(DELEGATE_ROLE, msg.sender), "Caller is neither owner nor delegate");
1978         _;
1979     }
1980 
1981     modifier verifyTxExpiration(uint256 expirationBlock) {
1982         require(_getBlockNumber() <= expirationBlock, "Transaction expired");
1983         _;
1984     }
1985 
1986     modifier verifyNotPaused() {
1987         require(_pausedSinceBlock > _getBlockNumber(), "Contract has been paused");
1988         _;
1989     }
1990 
1991 
1992     /*******************
1993     Contract start
1994     *******************/
1995     /**
1996      * @param ERC20Address address of the ERC20 contract
1997      */
1998     constructor(
1999           address ERC20Address
2000         , uint256 interestRatePerBlock
2001         , uint256 pausedSinceBlock
2002         , uint64  lockPeriodInBlocks) 
2003     public 
2004     {
2005         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2006 
2007         _token = IERC20(ERC20Address);
2008         _earliestDelete = _getBlockNumber().add(DELETE_PROTECTION_PERIOD);
2009         
2010         // NOTE(pb): Unnecessary initialisations, shall be done implicitly by VM
2011         //_interestRatesStartIdx = 0;
2012         //_interestRatesNextIdx = 0;
2013         //_rewardsPoolBalance = 0;
2014         //_accruedGlobalPrincipal = 0;
2015         //_accruedGlobalLiquidity = 0;
2016         //_accruedGlobalLocked = 0;
2017 
2018         _updateLockPeriod(lockPeriodInBlocks);
2019         _addInterestRate(interestRatePerBlock);
2020         _pauseSince(pausedSinceBlock /* uint256(0) */);
2021     }
2022 
2023 
2024     /**
2025      * @notice Add new interest rate in to the ordered container of previously added interest rates
2026      * @param rate - signed interest rate value in [10**18] units => real_rate [1] = rate [10**18] / 10**18
2027      * @param expirationBlock - block number beyond which is the carrier Tx considered expired, and so rejected.
2028      *                     This is for protection of Tx sender to exactly define lifecycle length of the Tx,
2029      *                     and so avoiding uncertainty of how long Tx sender needs to wait for Tx processing.
2030      *                     Tx can be withheld
2031      * @dev expiration period
2032      */
2033     function addInterestRate(
2034         uint256 rate,
2035         uint256 expirationBlock
2036         )
2037         external
2038         onlyDelegate()
2039         verifyTxExpiration(expirationBlock)
2040     {
2041         _addInterestRate(rate);
2042     }
2043 
2044 
2045     function deposit(
2046         uint256 amount,
2047         uint256 txExpirationBlock
2048         )
2049         external
2050         verifyTxExpiration(txExpirationBlock)
2051         verifyNotPaused
2052     {
2053         bool makeTransfer = amount != 0;
2054         if (makeTransfer) {
2055             require(_token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
2056             _accruedGlobalPrincipal = _accruedGlobalPrincipal.add(amount);
2057             _accruedGlobalLiquidity.principal = _accruedGlobalLiquidity.principal.add(amount);
2058             emit LiquidityDeposited(msg.sender, amount);
2059         }
2060 
2061         uint256 curr_block = _getBlockNumber();
2062         (, AssetLib.Asset storage liquidity,) = _collectLiquidity(msg.sender, curr_block);
2063 
2064         if (makeTransfer) {
2065             liquidity.principal = liquidity.principal.add(amount);
2066        }
2067     }
2068 
2069 
2070     /**
2071      * @notice Withdraws amount from sender' available liquidity pool back to sender address,
2072      *         preferring withdrawal from compound interest dimension of liquidity.
2073      *
2074      * @param amount - value to withdraw
2075      *
2076      * @dev public access
2077      */
2078     function withdraw(
2079         uint256 amount,
2080         uint256 txExpirationBlock
2081         )
2082         external
2083         verifyTxExpiration(txExpirationBlock)
2084         verifyNotPaused
2085     {
2086         address sender = msg.sender;
2087         uint256 curr_block = _getBlockNumber();
2088         (, AssetLib.Asset storage liquidity,) = _collectLiquidity(sender, curr_block);
2089 
2090         AssetLib.Asset memory _amount = liquidity.iSubCompoundInterestFirst(amount);
2091         _finaliseWithdraw(sender, _amount, amount);
2092     }
2093 
2094 
2095     /**
2096      * @notice Withdraws *WHOLE* compound interest amount available to sender.
2097      *
2098      * @dev public access
2099      */
2100     function withdrawPrincipal(
2101         uint256 txExpirationBlock
2102         )
2103         external
2104         verifyTxExpiration(txExpirationBlock)
2105         verifyNotPaused
2106     {
2107         address sender = msg.sender;
2108         uint256 curr_block = _getBlockNumber();
2109         (, AssetLib.Asset storage liquidity, ) = _collectLiquidity(sender, curr_block);
2110 
2111         AssetLib.Asset memory _amount;
2112         _amount.principal = liquidity.principal;
2113         liquidity.principal = 0;
2114 
2115         _finaliseWithdraw(sender, _amount, _amount.principal);
2116     }
2117 
2118 
2119     /**
2120      * @notice Withdraws *WHOLE* compound interest amount available to sender.
2121      *
2122      * @dev public access
2123      */
2124     function withdrawCompoundInterest(
2125         uint256 txExpirationBlock
2126         )
2127         external
2128         verifyTxExpiration(txExpirationBlock)
2129         verifyNotPaused
2130     {
2131         address sender = msg.sender;
2132         uint256 curr_block = _getBlockNumber();
2133         (, AssetLib.Asset storage liquidity, ) = _collectLiquidity(sender, curr_block);
2134 
2135         AssetLib.Asset memory _amount;
2136         _amount.compoundInterest = liquidity.compoundInterest;
2137         liquidity.compoundInterest = 0;
2138 
2139         _finaliseWithdraw(sender, _amount, _amount.compoundInterest);
2140     }
2141 
2142 
2143     /**
2144      * @notice Withdraws whole liquidity available to sender back to sender' address,
2145      *
2146      * @dev public access
2147      */
2148     function withdrawWholeLiquidity(
2149         uint256 txExpirationBlock
2150         )
2151         external
2152         verifyTxExpiration(txExpirationBlock)
2153         verifyNotPaused
2154     {
2155         address sender = msg.sender;
2156         uint256 curr_block = _getBlockNumber();
2157         (, AssetLib.Asset storage liquidity, ) = _collectLiquidity(sender, curr_block);
2158 
2159         _finaliseWithdraw(sender, liquidity, liquidity.composite());
2160         liquidity.compoundInterest = 0;
2161         liquidity.principal = 0;
2162     }
2163 
2164 
2165     function bindStake(
2166         uint256 amount,
2167         uint256 txExpirationBlock
2168         )
2169         external
2170         verifyTxExpiration(txExpirationBlock)
2171         verifyNotPaused
2172     {
2173         require(amount != 0, "Amount must be higher than zero");
2174 
2175         uint256 curr_block = _getBlockNumber();
2176 
2177         (, AssetLib.Asset storage liquidity, ) = _collectLiquidity(msg.sender, curr_block);
2178 
2179         //// NOTE(pb): Strictly speaking, the following check is not necessary, since the requirement will be checked
2180         ////           during the `iRelocatePrincipalFirst(...)` method code flow (see bellow).
2181         //uint256 composite = liquidity.composite();
2182         //require(amount <= composite, "Insufficient liquidity.");
2183 
2184         Stake storage stake = _updateStakeCompoundInterest(msg.sender, curr_block);
2185         AssetLib.Asset memory _amount = liquidity.iRelocatePrincipalFirst(stake.asset, amount);
2186         _accruedGlobalLiquidity.iSub(_amount);
2187 
2188        //// NOTE(pb): Emitting only info about Tx input `amount` value, decomposed to principal & compound interest
2189        ////           coordinates based on liquidity available.
2190        //if (amount > 0) {
2191             emit BindStake(msg.sender, stake.sinceInterestRateIndex, _amount.principal, _amount.compoundInterest);
2192         //}
2193     }
2194 
2195 
2196     /**
2197      * @notice Unbinds amount from the stake of sender of the transaction,
2198      *         and *LOCKS* it for number of blocks defined by value of the
2199      *         `_lockPeriodInBlocks` state of this contract at the point
2200      *         of this call.
2201      *         The locked amount can *NOT* be withdrawn from the contract
2202      *         *BEFORE* the lock period ends.
2203      *
2204      *         Unbinding (=calling this method) also means, that compound
2205      *         interest will be calculated for period since la.
2206      *
2207      * @param amount - value to un-bind from the stake
2208      *                 If `amount=0` then the **WHOLE** stake (including
2209      *                 compound interest) will be unbound.
2210      *
2211      * @dev public access
2212      */
2213     function unbindStake(
2214         uint256 amount, //NOTE: If zero, then all stake is withdrawn
2215         uint256 txExpirationBlock
2216         )
2217         external
2218         verifyTxExpiration(txExpirationBlock)
2219         verifyNotPaused
2220     {
2221         uint256 curr_block = _getBlockNumber();
2222         address sender = msg.sender;
2223         Stake storage stake = _updateStakeCompoundInterest(sender, curr_block);
2224 
2225         uint256 stake_composite = stake.asset.composite();
2226         AssetLib.Asset memory _amount;
2227 
2228         if (amount > 0) {
2229             // TODO(pb): Failing this way is expensive (causing rollback of state change).
2230             //           It would be beneficial to retain newly calculated liquidity value
2231             //           in to the state, thus the invested calculation would not come to wain.
2232             //           However that comes with another implication - this would need
2233             //           to return status/error code instead of reverting = caller MUST actually
2234             //           check the return value, what might be trap for callers who do not expect
2235             //           this behaviour (Tx execution passed , but in fact the essential feature
2236             //           has not been fully executed).
2237             require(amount <= stake_composite, "Amount is higher than stake");
2238 
2239             if (_lockPeriodInBlocks == 0) {
2240                 _amount = stake.asset.iRelocateCompoundInterestFirst(_liquidity[sender], amount);
2241                 _accruedGlobalLiquidity.iAdd(_amount);
2242                 emit UnbindStake(sender, curr_block, _amount.principal, _amount.compoundInterest);
2243                 emit LiquidityUnlocked(sender, _amount.principal, _amount.compoundInterest);
2244             } else {
2245                 Locked storage locked = _locked[sender];
2246                 LockedAsset storage newLockedAsset = locked.assets.push();
2247                 newLockedAsset.liquidSinceBlock = curr_block.add(_lockPeriodInBlocks);
2248                 _amount = stake.asset.iRelocateCompoundInterestFirst(newLockedAsset.asset, amount);
2249 
2250                 _accruedGlobalLocked.iAdd(_amount);
2251                 locked.aggregate.iAdd(_amount);
2252 
2253                 // NOTE: Emitting only info about Tx input values, not resulting compound values
2254                 emit UnbindStake(sender, newLockedAsset.liquidSinceBlock, _amount.principal, _amount.compoundInterest);
2255             }
2256         } else {
2257             if (stake_composite == 0) {
2258                 // NOTE(pb): Nothing to do
2259                 return;
2260             }
2261 
2262             _amount = stake.asset;
2263             stake.asset.principal = 0;
2264             stake.asset.compoundInterest = 0;
2265 
2266             if (_lockPeriodInBlocks == 0) {
2267                 _liquidity[sender].iAdd(_amount);
2268                 _accruedGlobalLiquidity.iAdd(_amount);
2269                 emit UnbindStake(sender, curr_block, _amount.principal, _amount.compoundInterest);
2270                 emit LiquidityUnlocked(sender, _amount.principal, _amount.compoundInterest);
2271             } else {
2272                 Locked storage locked = _locked[sender];
2273                 LockedAsset storage newLockedAsset = locked.assets.push();
2274                 newLockedAsset.liquidSinceBlock = curr_block.add(_lockPeriodInBlocks);
2275                 newLockedAsset.asset = _amount;
2276 
2277                 _accruedGlobalLocked.iAdd(_amount);
2278                 locked.aggregate.iAdd(_amount);
2279 
2280                 // NOTE: Emitting only info about Tx input values, not resulting compound values
2281                 emit UnbindStake(msg.sender, newLockedAsset.liquidSinceBlock, newLockedAsset.asset.principal, newLockedAsset.asset.compoundInterest);
2282             }
2283         }
2284     }
2285 
2286 
2287     function getRewardsPoolBalance() external view returns(uint256) {
2288         return _rewardsPoolBalance;
2289     }
2290 
2291 
2292     function getEarliestDeleteBlock() external view returns(uint256) {
2293         return _earliestDelete;
2294     }
2295 
2296 
2297     function getNumberOfLockedAssetsForUser(address forAddress) external view returns(uint256 length) {
2298         length = _locked[forAddress].assets.length;
2299     }
2300 
2301 
2302     function getLockedAssetsAggregateForUser(address forAddress) external view returns(uint256 principal, uint256 compoundInterest) {
2303         AssetLib.Asset storage aggregate = _locked[forAddress].aggregate;
2304         return (aggregate.principal, aggregate.compoundInterest);
2305     }
2306 
2307 
2308     /**
2309      * @dev Returns locked assets decomposed in to 3 separate arrays (principal, compound interest, liquid since block)
2310      *      NOTE(pb): This method might be quite expensive, depending on size of locked assets
2311      */
2312     function getLockedAssetsForUser(address forAddress)
2313         external view
2314         returns(uint256[] memory principal, uint256[] memory compoundInterest, uint256[] memory liquidSinceBlock)
2315     {
2316         LockedAsset[] storage lockedAssets = _locked[forAddress].assets;
2317         uint256 length = lockedAssets.length;
2318         if (length != 0) {
2319             principal = new uint256[](length);
2320             compoundInterest = new uint256[](length);
2321             liquidSinceBlock = new uint256[](length);
2322 
2323             for (uint256 i=0; i < length; ++i) {
2324                 LockedAsset storage la = lockedAssets[i];
2325                 AssetLib.Asset storage a = la.asset;
2326                 principal[i] = a.principal;
2327                 compoundInterest[i] = a.compoundInterest;
2328                 liquidSinceBlock[i] = la.liquidSinceBlock;
2329             }
2330         }
2331     }
2332 
2333 
2334     function getStakeForUser(address forAddress) external view returns(uint256 principal, uint256 compoundInterest, uint256 sinceBlock, uint256 sinceInterestRateIndex) {
2335         Stake storage stake = _stakes[forAddress];
2336         principal = stake.asset.principal;
2337         compoundInterest = stake.asset.compoundInterest;
2338         sinceBlock = stake.sinceBlock;
2339         sinceInterestRateIndex = stake.sinceInterestRateIndex;
2340     }
2341 
2342 
2343     /**
2344        @dev Even though this is considered as administrative action (is not affected by
2345             by contract paused state, it can be executed by anyone who wishes to
2346             top-up the rewards pool (funds are sent in to contract, *not* the other way around).
2347             The Rewards Pool is exclusively dedicated to cover withdrawals of user' compound interest,
2348             which is effectively the reward.
2349      */
2350     function topUpRewardsPool(
2351         uint256 amount,
2352         uint256 txExpirationBlock
2353         )
2354         external
2355         verifyTxExpiration(txExpirationBlock)
2356     {
2357         if (amount == 0) {
2358             return;
2359         }
2360 
2361         require(_token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
2362         _rewardsPoolBalance = _rewardsPoolBalance.add(amount);
2363         emit RewardsPoolTokenTopUp(msg.sender, amount);
2364     }
2365 
2366 
2367     /**
2368      * @notice Updates Lock Period value
2369      * @param numOfBlocks  length of the lock period
2370      * @dev Delegate only
2371      */
2372     function updateLockPeriod(uint64 numOfBlocks, uint256 txExpirationBlock)
2373         external
2374         verifyTxExpiration(txExpirationBlock)
2375         onlyDelegate
2376     {
2377         _updateLockPeriod(numOfBlocks);
2378     }
2379 
2380 
2381     /**
2382      * @notice Pauses all NON-administrative interaction with the contract since the specidfed block number 
2383      * @param blockNumber block number since which non-admin interaction will be paused (for all _getBlockNumber() >= blockNumber)
2384      * @dev Delegate only
2385      */
2386     function pauseSince(uint256 blockNumber, uint256 txExpirationBlock)
2387         external
2388         verifyTxExpiration(txExpirationBlock)
2389         onlyDelegate
2390     {
2391         _pauseSince(blockNumber);
2392     }
2393 
2394 
2395     /**
2396      * @dev Withdraw tokens from rewards pool.
2397      *
2398      * @param amount : amount to withdraw.
2399      *                 If `amount == 0` then whole amount in rewards pool will be withdrawn.
2400      * @param targetAddress : address to send tokens to
2401      */
2402     function withdrawFromRewardsPool(uint256 amount, address payable targetAddress,
2403         uint256 txExpirationBlock
2404         )
2405         external
2406         verifyTxExpiration(txExpirationBlock)
2407         onlyOwner
2408     {
2409         if (amount == 0) {
2410             amount = _rewardsPoolBalance;
2411         } else {
2412             require(amount <= _rewardsPoolBalance, "Amount higher than rewards pool");
2413         }
2414 
2415         // NOTE(pb): Strictly speaking, consistency check in following lines is not necessary,
2416         //           the if-else code above guarantees that everything is alright:
2417         uint256 contractBalance = _token.balanceOf(address(this));
2418         uint256 expectedMinContractBalance = _accruedGlobalPrincipal.add(amount);
2419         require(expectedMinContractBalance <= contractBalance, "Contract inconsistency.");
2420 
2421         require(_token.transfer(targetAddress, amount), "Not enough funds on contr. addr.");
2422 
2423         // NOTE(pb): No need for SafeMath.sub since the overflow is checked in the if-else code above.
2424         _rewardsPoolBalance -= amount;
2425 
2426         emit RewardsPoolTokenWithdrawal(targetAddress, amount);
2427     }
2428 
2429 
2430     /**
2431      * @dev Withdraw "excess" tokens, which were sent to contract directly via direct ERC20.transfer(...),
2432      *      without interacting with API of this (Staking) contract, what could be done only by mistake.
2433      *      Thus this method is meant to be used primarily for rescue purposes, enabling withdrawal of such
2434      *      "excess" tokens out of contract.
2435      * @param targetAddress : address to send tokens to
2436      * @param txExpirationBlock : block number until which is the transaction valid (inclusive).
2437      *                            When transaction is processed after this block, it fails.
2438      */
2439     function withdrawExcessTokens(address payable targetAddress, uint256 txExpirationBlock)
2440         external
2441         verifyTxExpiration(txExpirationBlock)
2442         onlyOwner
2443     {
2444         uint256 contractBalance = _token.balanceOf(address(this));
2445         uint256 expectedMinContractBalance = _accruedGlobalPrincipal.add(_rewardsPoolBalance);
2446         // NOTE(pb): The following subtraction shall *fail* (revert) IF the contract is in *INCONSISTENT* state,
2447         //           = when contract balance is less than minial expected balance:
2448         uint256 excessAmount = contractBalance.sub(expectedMinContractBalance);
2449         require(_token.transfer(targetAddress, excessAmount), "Not enough funds on contr. addr.");
2450         emit ExcessTokenWithdrawal(targetAddress, excessAmount);
2451     }
2452 
2453 
2454     /**
2455      * @notice Delete the contract, transfers the remaining token and ether balance to the specified
2456        payoutAddress
2457      * @param payoutAddress address to transfer the balances to. Ensure that this is able to handle ERC20 tokens
2458      * @dev owner only + only on or after `_earliestDelete` block
2459      */
2460     function deleteContract(address payable payoutAddress, uint256 txExpirationBlock)
2461     external
2462     verifyTxExpiration(txExpirationBlock)
2463     onlyOwner
2464     {
2465         require(_earliestDelete >= _getBlockNumber(), "Earliest delete not reached");
2466         uint256 contractBalance = _token.balanceOf(address(this));
2467         require(_token.transfer(payoutAddress, contractBalance));
2468         emit DeleteContract();
2469         selfdestruct(payoutAddress);
2470     }
2471  
2472 
2473     // **********************************************************
2474     // ******************    INTERNAL METHODS   *****************
2475 
2476 
2477     /**
2478      * @dev VIRTUAL Method returning bock number. Introduced for 
2479      *      testing purposes (allows mocking).
2480      */
2481     function _getBlockNumber() internal view virtual returns(uint256)
2482     {
2483         return block.number;
2484     }
2485 
2486 
2487     function _isOwner() internal view returns(bool) {
2488         return hasRole(DEFAULT_ADMIN_ROLE, msg.sender);
2489     }
2490 
2491 
2492     /**
2493      * @notice Add new interest rate in to the ordered container of previously added interest rates
2494      * @param rate - signed interest rate value in [10**18] units => real_rate [1] = rate [10**18] / 10**18
2495      */
2496     function _addInterestRate(uint256 rate) internal 
2497     {
2498         uint256 idx = _interestRatesNextIdx;
2499         _interestRates[idx] = InterestRatePerBlock({
2500               sinceBlock: _getBlockNumber()
2501             , rate: rate
2502             //,numberOfRegisteredUsers: 0
2503             });
2504         _interestRatesNextIdx = _interestRatesNextIdx.add(1);
2505 
2506         emit NewInterestRate(idx, rate);
2507     }
2508 
2509 
2510     /**
2511      * @notice Updates Lock Period value
2512      * @param numOfBlocks  length of the lock period
2513      */
2514     function _updateLockPeriod(uint64 numOfBlocks) internal
2515     {
2516         _lockPeriodInBlocks = numOfBlocks;
2517         emit LockPeriod(numOfBlocks);
2518     }
2519 
2520 
2521     /**
2522      * @notice Pauses all NON-administrative interaction with the contract since the specidfed block number 
2523      * @param blockNumber block number since which non-admin interaction will be paused (for all _getBlockNumber() >= blockNumber)
2524      */
2525     function _pauseSince(uint256 blockNumber) internal 
2526     {
2527         uint256 currentBlockNumber = _getBlockNumber();
2528         _pausedSinceBlock = blockNumber < currentBlockNumber ? currentBlockNumber : blockNumber;
2529         emit Pause(_pausedSinceBlock);
2530     }
2531 
2532 
2533     /**
2534      * @notice Withdraws amount from sender' available liquidity pool back to sender address,
2535      *         preferring withdrawal from compound interest dimension of liquidity.
2536      *
2537      * @param amount - value to withdraw
2538      *
2539      * @dev NOTE(pb): Passing redundant `uint256 amount` (on top of the `Asset _amount`) in the name
2540      *                of performance to avoid calculating it again from `_amount` (or the other way around).
2541      *                IMPLICATION: Caller **MUST** pass correct values, ensuring that `amount == _amount.composite()`,
2542      *                since this private method is **NOT** verifying this condition due to performance reasons.
2543      */
2544     function _finaliseWithdraw(address sender, AssetLib.Asset memory _amount, uint256 amount) internal {
2545          if (amount != 0) {
2546             require(_rewardsPoolBalance >= _amount.compoundInterest, "Not enough funds in rewards pool");
2547             require(_token.transfer(sender, amount), "Transfer failed");
2548 
2549             _rewardsPoolBalance = _rewardsPoolBalance.sub(_amount.compoundInterest);
2550             _accruedGlobalPrincipal = _accruedGlobalPrincipal.sub(_amount.principal);
2551             _accruedGlobalLiquidity.iSub(_amount);
2552 
2553             // NOTE(pb): Emitting only info about Tx input `amount` value, decomposed to principal & compound interest
2554             //           coordinates based on liquidity available.
2555             emit Withdraw(msg.sender, _amount.principal, _amount.compoundInterest);
2556          }
2557     }
2558 
2559 
2560     function _updateStakeCompoundInterest(address sender, uint256 at_block)
2561         internal
2562         returns(Stake storage stake)
2563     {
2564         stake = _stakes[sender];
2565         uint256 composite = stake.asset.composite();
2566         if (composite != 0)
2567         {
2568             // TODO(pb): There is more effective algorithm than this.
2569             uint256 start_block = stake.sinceBlock;
2570             // NOTE(pb): Probability of `++i`  or `j=i+1` overflowing is limitly approaching zero,
2571             // since we would need to create `(1<<256)-1`, resp `1<<256)-2`,  number of interrest rates in order to reach the overflow
2572             for (uint256 i=stake.sinceInterestRateIndex; i < _interestRatesNextIdx; ++i) {
2573                 InterestRatePerBlock storage interest = _interestRates[i];
2574                 // TODO(pb): It is not strictly necessary to do this assert, and rather fully rely
2575                 //           on correctness of `addInterestRate(...)` implementation.
2576                 require(interest.sinceBlock <= start_block, "sinceBlock inconsistency");
2577                 uint256 end_block = at_block;
2578 
2579                 uint256 j = i + 1;
2580                 if (j < _interestRatesNextIdx) {
2581                     InterestRatePerBlock storage next_interest = _interestRates[j];
2582                     end_block = next_interest.sinceBlock;
2583                 }
2584 
2585                 composite = Finance.compoundInterest(composite, interest.rate, end_block - start_block);
2586                 start_block = end_block;
2587             }
2588 
2589             stake.asset.compoundInterest = composite.sub(stake.asset.principal);
2590         }
2591 
2592         stake.sinceBlock = at_block;
2593         stake.sinceInterestRateIndex = (_interestRatesNextIdx != 0 ? _interestRatesNextIdx - 1 : 0);
2594         // TODO(pb): Careful: The `StakeCompoundInterest` event doers not carry explicit block number value - it relies
2595         //           on the fact that Event implicitly carries value block.number where the event has been triggered,
2596         //           what however can be different than value of the `at_block` input parameter passed in.
2597         //           Thus this method needs to be EITHER refactored to drop the `at_block` parameter (and so get the
2598         //           value internally by calling the `_getBlockNumber()` method), OR the `StakeCompoundInterest` event
2599         //           needs to be extended to include the `uint256 sinceBlock` attribute.
2600         //           The original reason for passing the `at_block` parameter was to spare gas for calling the
2601         //           `_getBlockNumber()` method twice (by the caller of this method + by this method), what might NOT be
2602         //           relevant anymore (after refactoring), since caller might not need to use the block number value anymore.
2603         emit StakeCompoundInterest(sender, stake.sinceInterestRateIndex, stake.asset.principal, stake.asset.compoundInterest);
2604     }
2605 
2606 
2607     function _collectLiquidity(address sender, uint256 at_block)
2608         internal
2609         returns(AssetLib.Asset memory unlockedLiquidity, AssetLib.Asset storage liquidity, bool collected)
2610     {
2611         Locked storage locked = _locked[sender];
2612         LockedAsset[] storage lockedAssets = locked.assets;
2613         liquidity = _liquidity[sender];
2614 
2615         for (uint256 i=0; i < lockedAssets.length; ) {
2616             LockedAsset memory l = lockedAssets[i];
2617 
2618             if (l.liquidSinceBlock > at_block) {
2619                 ++i; // NOTE(pb): Probability of overflow is zero, what is ensured by condition in this for cycle.
2620                 continue;
2621             }
2622 
2623             unlockedLiquidity.principal = unlockedLiquidity.principal.add(l.asset.principal);
2624             // NOTE(pb): The following can potentially overflow, since accrued compound interest can be high, depending on values on sequence of interest rates & length of compounding intervals involved.
2625             unlockedLiquidity.compoundInterest = unlockedLiquidity.compoundInterest.add(l.asset.compoundInterest);
2626 
2627             // Copying last element of the array in to the current one,
2628             // so that the last one can be popped out of the array.
2629             // NOTE(pb): Probability of overflow during `-` operation is zero, what is ensured by condition in this for cycle.
2630             uint256 last_idx = lockedAssets.length - 1;
2631             if (i != last_idx) {
2632                 lockedAssets[i] = lockedAssets[last_idx];
2633             }
2634             // TODO(pb): It will be cheaper (GAS consumption-wise) to simply leave
2635             // elements in array (do NOT delete them) and rather store "amortised"
2636             // size of the array in secondary separate store variable (= do NOT
2637             // use `array.length` as primary indication of array length).
2638             // Destruction of the array items is expensive. Excess of "allocated"
2639             // array storage can be left temporarily (or even permanently) unused.
2640             lockedAssets.pop();
2641         }
2642 
2643         // TODO(pb): This should not be necessary.
2644         if (lockedAssets.length == 0) {
2645             delete _locked[sender];
2646         }
2647 
2648         collected = unlockedLiquidity.principal != 0 || unlockedLiquidity.compoundInterest != 0;
2649         if (collected) {
2650              emit LiquidityUnlocked(sender, unlockedLiquidity.principal, unlockedLiquidity.compoundInterest);
2651 
2652             _accruedGlobalLocked.iSub(unlockedLiquidity);
2653             if (lockedAssets.length != 0) {
2654                 locked.aggregate.iSub(unlockedLiquidity);
2655             }
2656 
2657             _accruedGlobalLiquidity.iAdd(unlockedLiquidity);
2658 
2659             liquidity.iAdd(unlockedLiquidity);
2660         }
2661     }
2662 
2663 }