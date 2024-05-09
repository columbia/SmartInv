1 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
28  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
29  * and `uint256` (`UintSet`) are supported.
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
44         // Position of the value in the `values` array, plus 1 because index 0
45         // means a value is not in the set.
46         mapping(bytes32 => uint256) _indexes;
47     }
48 
49     /**
50      * @dev Add a value to a set. O(1).
51      *
52      * Returns true if the value was added to the set, that is if it was not
53      * already present.
54      */
55     function _add(Set storage set, bytes32 value) private returns (bool) {
56         if (!_contains(set, value)) {
57             set._values.push(value);
58             // The value is stored at length-1, but we add 1 to all indexes
59             // and use 0 as a sentinel value
60             set._indexes[value] = set._values.length;
61             return true;
62         } else {
63             return false;
64         }
65     }
66 
67     /**
68      * @dev Removes a value from a set. O(1).
69      *
70      * Returns true if the value was removed from the set, that is if it was
71      * present.
72      */
73     function _remove(Set storage set, bytes32 value) private returns (bool) {
74         // We read and store the value's index to prevent multiple reads from the same storage slot
75         uint256 valueIndex = set._indexes[value];
76 
77         if (valueIndex != 0) {
78             // Equivalent to contains(set, value)
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
111     function _contains(Set storage set, bytes32 value)
112         private
113         view
114         returns (bool)
115     {
116         return set._indexes[value] != 0;
117     }
118 
119     /**
120      * @dev Returns the number of values on the set. O(1).
121      */
122     function _length(Set storage set) private view returns (uint256) {
123         return set._values.length;
124     }
125 
126     /**
127      * @dev Returns the value stored at position `index` in the set. O(1).
128      *
129      * Note that there are no guarantees on the ordering of values inside the
130      * array, and it may change when more values are added or removed.
131      *
132      * Requirements:
133      *
134      * - `index` must be strictly less than {length}.
135      */
136     function _at(Set storage set, uint256 index)
137         private
138         view
139         returns (bytes32)
140     {
141         require(
142             set._values.length > index,
143             "EnumerableSet: index out of bounds"
144         );
145         return set._values[index];
146     }
147 
148     // Bytes32Set
149 
150     struct Bytes32Set {
151         Set _inner;
152     }
153 
154     /**
155      * @dev Add a value to a set. O(1).
156      *
157      * Returns true if the value was added to the set, that is if it was not
158      * already present.
159      */
160     function add(Bytes32Set storage set, bytes32 value)
161         internal
162         returns (bool)
163     {
164         return _add(set._inner, value);
165     }
166 
167     /**
168      * @dev Removes a value from a set. O(1).
169      *
170      * Returns true if the value was removed from the set, that is if it was
171      * present.
172      */
173     function remove(Bytes32Set storage set, bytes32 value)
174         internal
175         returns (bool)
176     {
177         return _remove(set._inner, value);
178     }
179 
180     /**
181      * @dev Returns true if the value is in the set. O(1).
182      */
183     function contains(Bytes32Set storage set, bytes32 value)
184         internal
185         view
186         returns (bool)
187     {
188         return _contains(set._inner, value);
189     }
190 
191     /**
192      * @dev Returns the number of values in the set. O(1).
193      */
194     function length(Bytes32Set storage set) internal view returns (uint256) {
195         return _length(set._inner);
196     }
197 
198     /**
199      * @dev Returns the value stored at position `index` in the set. O(1).
200      *
201      * Note that there are no guarantees on the ordering of values inside the
202      * array, and it may change when more values are added or removed.
203      *
204      * Requirements:
205      *
206      * - `index` must be strictly less than {length}.
207      */
208     function at(Bytes32Set storage set, uint256 index)
209         internal
210         view
211         returns (bytes32)
212     {
213         return _at(set._inner, index);
214     }
215 
216     // AddressSet
217 
218     struct AddressSet {
219         Set _inner;
220     }
221 
222     /**
223      * @dev Add a value to a set. O(1).
224      *
225      * Returns true if the value was added to the set, that is if it was not
226      * already present.
227      */
228     function add(AddressSet storage set, address value)
229         internal
230         returns (bool)
231     {
232         return _add(set._inner, bytes32(uint256(value)));
233     }
234 
235     /**
236      * @dev Removes a value from a set. O(1).
237      *
238      * Returns true if the value was removed from the set, that is if it was
239      * present.
240      */
241     function remove(AddressSet storage set, address value)
242         internal
243         returns (bool)
244     {
245         return _remove(set._inner, bytes32(uint256(value)));
246     }
247 
248     /**
249      * @dev Returns true if the value is in the set. O(1).
250      */
251     function contains(AddressSet storage set, address value)
252         internal
253         view
254         returns (bool)
255     {
256         return _contains(set._inner, bytes32(uint256(value)));
257     }
258 
259     /**
260      * @dev Returns the number of values in the set. O(1).
261      */
262     function length(AddressSet storage set) internal view returns (uint256) {
263         return _length(set._inner);
264     }
265 
266     /**
267      * @dev Returns the value stored at position `index` in the set. O(1).
268      *
269      * Note that there are no guarantees on the ordering of values inside the
270      * array, and it may change when more values are added or removed.
271      *
272      * Requirements:
273      *
274      * - `index` must be strictly less than {length}.
275      */
276     function at(AddressSet storage set, uint256 index)
277         internal
278         view
279         returns (address)
280     {
281         return address(uint256(_at(set._inner, index)));
282     }
283 
284     // UintSet
285 
286     struct UintSet {
287         Set _inner;
288     }
289 
290     /**
291      * @dev Add a value to a set. O(1).
292      *
293      * Returns true if the value was added to the set, that is if it was not
294      * already present.
295      */
296     function add(UintSet storage set, uint256 value) internal returns (bool) {
297         return _add(set._inner, bytes32(value));
298     }
299 
300     /**
301      * @dev Removes a value from a set. O(1).
302      *
303      * Returns true if the value was removed from the set, that is if it was
304      * present.
305      */
306     function remove(UintSet storage set, uint256 value)
307         internal
308         returns (bool)
309     {
310         return _remove(set._inner, bytes32(value));
311     }
312 
313     /**
314      * @dev Returns true if the value is in the set. O(1).
315      */
316     function contains(UintSet storage set, uint256 value)
317         internal
318         view
319         returns (bool)
320     {
321         return _contains(set._inner, bytes32(value));
322     }
323 
324     /**
325      * @dev Returns the number of values on the set. O(1).
326      */
327     function length(UintSet storage set) internal view returns (uint256) {
328         return _length(set._inner);
329     }
330 
331     /**
332      * @dev Returns the value stored at position `index` in the set. O(1).
333      *
334      * Note that there are no guarantees on the ordering of values inside the
335      * array, and it may change when more values are added or removed.
336      *
337      * Requirements:
338      *
339      * - `index` must be strictly less than {length}.
340      */
341     function at(UintSet storage set, uint256 index)
342         internal
343         view
344         returns (uint256)
345     {
346         return uint256(_at(set._inner, index));
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/Address.sol
351 
352 pragma solidity >=0.6.2 <0.8.0;
353 
354 /**
355  * @dev Collection of functions related to the address type
356  */
357 library Address {
358     /**
359      * @dev Returns true if `account` is a contract.
360      *
361      * [IMPORTANT]
362      * ====
363      * It is unsafe to assume that an address for which this function returns
364      * false is an externally-owned account (EOA) and not a contract.
365      *
366      * Among others, `isContract` will return false for the following
367      * types of addresses:
368      *
369      *  - an externally-owned account
370      *  - a contract in construction
371      *  - an address where a contract will be created
372      *  - an address where a contract lived, but was destroyed
373      * ====
374      */
375     function isContract(address account) internal view returns (bool) {
376         // This method relies on extcodesize, which returns 0 for contracts in
377         // construction, since the code is only stored at the end of the
378         // constructor execution.
379 
380         uint256 size;
381         // solhint-disable-next-line no-inline-assembly
382         assembly {
383             size := extcodesize(account)
384         }
385         return size > 0;
386     }
387 
388     /**
389      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
390      * `recipient`, forwarding all available gas and reverting on errors.
391      *
392      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
393      * of certain opcodes, possibly making contracts go over the 2300 gas limit
394      * imposed by `transfer`, making them unable to receive funds via
395      * `transfer`. {sendValue} removes this limitation.
396      *
397      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
398      *
399      * IMPORTANT: because control is transferred to `recipient`, care must be
400      * taken to not create reentrancy vulnerabilities. Consider using
401      * {ReentrancyGuard} or the
402      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
403      */
404     function sendValue(address payable recipient, uint256 amount) internal {
405         require(
406             address(this).balance >= amount,
407             "Address: insufficient balance"
408         );
409 
410         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
411         (bool success, ) = recipient.call{value: amount}("");
412         require(
413             success,
414             "Address: unable to send value, recipient may have reverted"
415         );
416     }
417 
418     /**
419      * @dev Performs a Solidity function call using a low level `call`. A
420      * plain`call` is an unsafe replacement for a function call: use this
421      * function instead.
422      *
423      * If `target` reverts with a revert reason, it is bubbled up by this
424      * function (like regular Solidity function calls).
425      *
426      * Returns the raw returned data. To convert to the expected return value,
427      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
428      *
429      * Requirements:
430      *
431      * - `target` must be a contract.
432      * - calling `target` with `data` must not revert.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(address target, bytes memory data)
437         internal
438         returns (bytes memory)
439     {
440         return functionCall(target, data, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, 0, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but also transferring `value` wei to `target`.
460      *
461      * Requirements:
462      *
463      * - the calling contract must have an ETH balance of at least `value`.
464      * - the called Solidity function must be `payable`.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 value
472     ) internal returns (bytes memory) {
473         return
474             functionCallWithValue(
475                 target,
476                 data,
477                 value,
478                 "Address: low-level call with value failed"
479             );
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
484      * with `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCallWithValue(
489         address target,
490         bytes memory data,
491         uint256 value,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(
495             address(this).balance >= value,
496             "Address: insufficient balance for call"
497         );
498         require(isContract(target), "Address: call to non-contract");
499 
500         // solhint-disable-next-line avoid-low-level-calls
501         (bool success, bytes memory returndata) =
502             target.call{value: value}(data);
503         return _verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
508      * but performing a static call.
509      *
510      * _Available since v3.3._
511      */
512     function functionStaticCall(address target, bytes memory data)
513         internal
514         view
515         returns (bytes memory)
516     {
517         return
518             functionStaticCall(
519                 target,
520                 data,
521                 "Address: low-level static call failed"
522             );
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(
532         address target,
533         bytes memory data,
534         string memory errorMessage
535     ) internal view returns (bytes memory) {
536         require(isContract(target), "Address: static call to non-contract");
537 
538         // solhint-disable-next-line avoid-low-level-calls
539         (bool success, bytes memory returndata) = target.staticcall(data);
540         return _verifyCallResult(success, returndata, errorMessage);
541     }
542 
543     function _verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) private pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554 
555                 // solhint-disable-next-line no-inline-assembly
556                 assembly {
557                     let returndata_size := mload(returndata)
558                     revert(add(32, returndata), returndata_size)
559                 }
560             } else {
561                 revert(errorMessage);
562             }
563         }
564     }
565 }
566 
567 // File: @openzeppelin/contracts/GSN/Context.sol
568 
569 pragma solidity >=0.6.0 <0.8.0;
570 
571 /*
572  * @dev Provides information about the current execution context, including the
573  * sender of the transaction and its data. While these are generally available
574  * via msg.sender and msg.data, they should not be accessed in such a direct
575  * manner, since when dealing with GSN meta-transactions the account sending and
576  * paying for execution may not be the actual sender (as far as an application
577  * is concerned).
578  *
579  * This contract is only required for intermediate, library-like contracts.
580  */
581 abstract contract Context {
582     function _msgSender() internal view virtual returns (address payable) {
583         return msg.sender;
584     }
585 
586     function _msgData() internal view virtual returns (bytes memory) {
587         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
588         return msg.data;
589     }
590 }
591 
592 // File: @openzeppelin/contracts/access/AccessControl.sol
593 
594 pragma solidity >=0.6.0 <0.8.0;
595 
596 /**
597  * @dev Contract module that allows children to implement role-based access
598  * control mechanisms.
599  *
600  * Roles are referred to by their `bytes32` identifier. These should be exposed
601  * in the external API and be unique. The best way to achieve this is by
602  * using `public constant` hash digests:
603  *
604  * ```
605  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
606  * ```
607  *
608  * Roles can be used to represent a set of permissions. To restrict access to a
609  * function call, use {hasRole}:
610  *
611  * ```
612  * function foo() public {
613  *     require(hasRole(MY_ROLE, msg.sender));
614  *     ...
615  * }
616  * ```
617  *
618  * Roles can be granted and revoked dynamically via the {grantRole} and
619  * {revokeRole} functions. Each role has an associated admin role, and only
620  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
621  *
622  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
623  * that only accounts with this role will be able to grant or revoke other
624  * roles. More complex role relationships can be created by using
625  * {_setRoleAdmin}.
626  *
627  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
628  * grant and revoke this role. Extra precautions should be taken to secure
629  * accounts that have been granted it.
630  */
631 abstract contract AccessControl is Context {
632     using EnumerableSet for EnumerableSet.AddressSet;
633     using Address for address;
634 
635     struct RoleData {
636         EnumerableSet.AddressSet members;
637         bytes32 adminRole;
638     }
639 
640     mapping(bytes32 => RoleData) private _roles;
641 
642     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
643 
644     /**
645      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
646      *
647      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
648      * {RoleAdminChanged} not being emitted signaling this.
649      *
650      * _Available since v3.1._
651      */
652     event RoleAdminChanged(
653         bytes32 indexed role,
654         bytes32 indexed previousAdminRole,
655         bytes32 indexed newAdminRole
656     );
657 
658     /**
659      * @dev Emitted when `account` is granted `role`.
660      *
661      * `sender` is the account that originated the contract call, an admin role
662      * bearer except when using {_setupRole}.
663      */
664     event RoleGranted(
665         bytes32 indexed role,
666         address indexed account,
667         address indexed sender
668     );
669 
670     /**
671      * @dev Emitted when `account` is revoked `role`.
672      *
673      * `sender` is the account that originated the contract call:
674      *   - if using `revokeRole`, it is the admin role bearer
675      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
676      */
677     event RoleRevoked(
678         bytes32 indexed role,
679         address indexed account,
680         address indexed sender
681     );
682 
683     /**
684      * @dev Returns `true` if `account` has been granted `role`.
685      */
686     function hasRole(bytes32 role, address account) public view returns (bool) {
687         return _roles[role].members.contains(account);
688     }
689 
690     /**
691      * @dev Returns the number of accounts that have `role`. Can be used
692      * together with {getRoleMember} to enumerate all bearers of a role.
693      */
694     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
695         return _roles[role].members.length();
696     }
697 
698     /**
699      * @dev Returns one of the accounts that have `role`. `index` must be a
700      * value between 0 and {getRoleMemberCount}, non-inclusive.
701      *
702      * Role bearers are not sorted in any particular way, and their ordering may
703      * change at any point.
704      *
705      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
706      * you perform all queries on the same block. See the following
707      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
708      * for more information.
709      */
710     function getRoleMember(bytes32 role, uint256 index)
711         public
712         view
713         returns (address)
714     {
715         return _roles[role].members.at(index);
716     }
717 
718     /**
719      * @dev Returns the admin role that controls `role`. See {grantRole} and
720      * {revokeRole}.
721      *
722      * To change a role's admin, use {_setRoleAdmin}.
723      */
724     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
725         return _roles[role].adminRole;
726     }
727 
728     /**
729      * @dev Grants `role` to `account`.
730      *
731      * If `account` had not been already granted `role`, emits a {RoleGranted}
732      * event.
733      *
734      * Requirements:
735      *
736      * - the caller must have ``role``'s admin role.
737      */
738     function grantRole(bytes32 role, address account) public virtual {
739         require(
740             hasRole(_roles[role].adminRole, _msgSender()),
741             "AccessControl: sender must be an admin to grant"
742         );
743 
744         _grantRole(role, account);
745     }
746 
747     /**
748      * @dev Revokes `role` from `account`.
749      *
750      * If `account` had been granted `role`, emits a {RoleRevoked} event.
751      *
752      * Requirements:
753      *
754      * - the caller must have ``role``'s admin role.
755      */
756     function revokeRole(bytes32 role, address account) public virtual {
757         require(
758             hasRole(_roles[role].adminRole, _msgSender()),
759             "AccessControl: sender must be an admin to revoke"
760         );
761 
762         _revokeRole(role, account);
763     }
764 
765     /**
766      * @dev Revokes `role` from the calling account.
767      *
768      * Roles are often managed via {grantRole} and {revokeRole}: this function's
769      * purpose is to provide a mechanism for accounts to lose their privileges
770      * if they are compromised (such as when a trusted device is misplaced).
771      *
772      * If the calling account had been granted `role`, emits a {RoleRevoked}
773      * event.
774      *
775      * Requirements:
776      *
777      * - the caller must be `account`.
778      */
779     function renounceRole(bytes32 role, address account) public virtual {
780         require(
781             account == _msgSender(),
782             "AccessControl: can only renounce roles for self"
783         );
784 
785         _revokeRole(role, account);
786     }
787 
788     /**
789      * @dev Grants `role` to `account`.
790      *
791      * If `account` had not been already granted `role`, emits a {RoleGranted}
792      * event. Note that unlike {grantRole}, this function doesn't perform any
793      * checks on the calling account.
794      *
795      * [WARNING]
796      * ====
797      * This function should only be called from the constructor when setting
798      * up the initial roles for the system.
799      *
800      * Using this function in any other way is effectively circumventing the admin
801      * system imposed by {AccessControl}.
802      * ====
803      */
804     function _setupRole(bytes32 role, address account) internal virtual {
805         _grantRole(role, account);
806     }
807 
808     /**
809      * @dev Sets `adminRole` as ``role``'s admin role.
810      *
811      * Emits a {RoleAdminChanged} event.
812      */
813     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
814         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
815         _roles[role].adminRole = adminRole;
816     }
817 
818     function _grantRole(bytes32 role, address account) private {
819         if (_roles[role].members.add(account)) {
820             emit RoleGranted(role, account, _msgSender());
821         }
822     }
823 
824     function _revokeRole(bytes32 role, address account) private {
825         if (_roles[role].members.remove(account)) {
826             emit RoleRevoked(role, account, _msgSender());
827         }
828     }
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
832 
833 pragma solidity >=0.6.0 <0.8.0;
834 
835 /**
836  * @dev Interface of the ERC20 standard as defined in the EIP.
837  */
838 interface IERC20 {
839     /**
840      * @dev Returns the amount of tokens in existence.
841      */
842     function totalSupply() external view returns (uint256);
843 
844     /**
845      * @dev Returns the amount of tokens owned by `account`.
846      */
847     function balanceOf(address account) external view returns (uint256);
848 
849     /**
850      * @dev Moves `amount` tokens from the caller's account to `recipient`.
851      *
852      * Returns a boolean value indicating whether the operation succeeded.
853      *
854      * Emits a {Transfer} event.
855      */
856     function transfer(address recipient, uint256 amount)
857         external
858         returns (bool);
859 
860     /**
861      * @dev Returns the remaining number of tokens that `spender` will be
862      * allowed to spend on behalf of `owner` through {transferFrom}. This is
863      * zero by default.
864      *
865      * This value changes when {approve} or {transferFrom} are called.
866      */
867     function allowance(address owner, address spender)
868         external
869         view
870         returns (uint256);
871 
872     /**
873      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
874      *
875      * Returns a boolean value indicating whether the operation succeeded.
876      *
877      * IMPORTANT: Beware that changing an allowance with this method brings the risk
878      * that someone may use both the old and the new allowance by unfortunate
879      * transaction ordering. One possible solution to mitigate this race
880      * condition is to first reduce the spender's allowance to 0 and set the
881      * desired value afterwards:
882      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
883      *
884      * Emits an {Approval} event.
885      */
886     function approve(address spender, uint256 amount) external returns (bool);
887 
888     /**
889      * @dev Moves `amount` tokens from `sender` to `recipient` using the
890      * allowance mechanism. `amount` is then deducted from the caller's
891      * allowance.
892      *
893      * Returns a boolean value indicating whether the operation succeeded.
894      *
895      * Emits a {Transfer} event.
896      */
897     function transferFrom(
898         address sender,
899         address recipient,
900         uint256 amount
901     ) external returns (bool);
902 
903     /**
904      * @dev Emitted when `value` tokens are moved from one account (`from`) to
905      * another (`to`).
906      *
907      * Note that `value` may be zero.
908      */
909     event Transfer(address indexed from, address indexed to, uint256 value);
910 
911     /**
912      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
913      * a call to {approve}. `value` is the new allowance.
914      */
915     event Approval(
916         address indexed owner,
917         address indexed spender,
918         uint256 value
919     );
920 }
921 
922 // File: @openzeppelin/contracts/math/SafeMath.sol
923 
924 pragma solidity >=0.6.0 <0.8.0;
925 
926 /**
927  * @dev Wrappers over Solidity's arithmetic operations with added overflow
928  * checks.
929  *
930  * Arithmetic operations in Solidity wrap on overflow. This can easily result
931  * in bugs, because programmers usually assume that an overflow raises an
932  * error, which is the standard behavior in high level programming languages.
933  * `SafeMath` restores this intuition by reverting the transaction when an
934  * operation overflows.
935  *
936  * Using this library instead of the unchecked operations eliminates an entire
937  * class of bugs, so it's recommended to use it always.
938  */
939 library SafeMath {
940     /**
941      * @dev Returns the addition of two unsigned integers, reverting on
942      * overflow.
943      *
944      * Counterpart to Solidity's `+` operator.
945      *
946      * Requirements:
947      *
948      * - Addition cannot overflow.
949      */
950     function add(uint256 a, uint256 b) internal pure returns (uint256) {
951         uint256 c = a + b;
952         require(c >= a, "SafeMath: addition overflow");
953 
954         return c;
955     }
956 
957     /**
958      * @dev Returns the subtraction of two unsigned integers, reverting on
959      * overflow (when the result is negative).
960      *
961      * Counterpart to Solidity's `-` operator.
962      *
963      * Requirements:
964      *
965      * - Subtraction cannot overflow.
966      */
967     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
968         return sub(a, b, "SafeMath: subtraction overflow");
969     }
970 
971     /**
972      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
973      * overflow (when the result is negative).
974      *
975      * Counterpart to Solidity's `-` operator.
976      *
977      * Requirements:
978      *
979      * - Subtraction cannot overflow.
980      */
981     function sub(
982         uint256 a,
983         uint256 b,
984         string memory errorMessage
985     ) internal pure returns (uint256) {
986         require(b <= a, errorMessage);
987         uint256 c = a - b;
988 
989         return c;
990     }
991 
992     /**
993      * @dev Returns the multiplication of two unsigned integers, reverting on
994      * overflow.
995      *
996      * Counterpart to Solidity's `*` operator.
997      *
998      * Requirements:
999      *
1000      * - Multiplication cannot overflow.
1001      */
1002     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1003         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1004         // benefit is lost if 'b' is also tested.
1005         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1006         if (a == 0) {
1007             return 0;
1008         }
1009 
1010         uint256 c = a * b;
1011         require(c / a == b, "SafeMath: multiplication overflow");
1012 
1013         return c;
1014     }
1015 
1016     /**
1017      * @dev Returns the integer division of two unsigned integers. Reverts on
1018      * division by zero. The result is rounded towards zero.
1019      *
1020      * Counterpart to Solidity's `/` operator. Note: this function uses a
1021      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1022      * uses an invalid opcode to revert (consuming all remaining gas).
1023      *
1024      * Requirements:
1025      *
1026      * - The divisor cannot be zero.
1027      */
1028     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1029         return div(a, b, "SafeMath: division by zero");
1030     }
1031 
1032     /**
1033      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1034      * division by zero. The result is rounded towards zero.
1035      *
1036      * Counterpart to Solidity's `/` operator. Note: this function uses a
1037      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1038      * uses an invalid opcode to revert (consuming all remaining gas).
1039      *
1040      * Requirements:
1041      *
1042      * - The divisor cannot be zero.
1043      */
1044     function div(
1045         uint256 a,
1046         uint256 b,
1047         string memory errorMessage
1048     ) internal pure returns (uint256) {
1049         require(b > 0, errorMessage);
1050         uint256 c = a / b;
1051         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1052 
1053         return c;
1054     }
1055 
1056     /**
1057      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1058      * Reverts when dividing by zero.
1059      *
1060      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1061      * opcode (which leaves remaining gas untouched) while Solidity uses an
1062      * invalid opcode to revert (consuming all remaining gas).
1063      *
1064      * Requirements:
1065      *
1066      * - The divisor cannot be zero.
1067      */
1068     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1069         return mod(a, b, "SafeMath: modulo by zero");
1070     }
1071 
1072     /**
1073      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1074      * Reverts with custom message when dividing by zero.
1075      *
1076      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1077      * opcode (which leaves remaining gas untouched) while Solidity uses an
1078      * invalid opcode to revert (consuming all remaining gas).
1079      *
1080      * Requirements:
1081      *
1082      * - The divisor cannot be zero.
1083      */
1084     function mod(
1085         uint256 a,
1086         uint256 b,
1087         string memory errorMessage
1088     ) internal pure returns (uint256) {
1089         require(b != 0, errorMessage);
1090         return a % b;
1091     }
1092 }
1093 
1094 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1095 
1096 pragma solidity >=0.6.0 <0.8.0;
1097 
1098 /**
1099  * @dev Implementation of the {IERC20} interface.
1100  *
1101  * This implementation is agnostic to the way tokens are created. This means
1102  * that a supply mechanism has to be added in a derived contract using {_mint}.
1103  * For a generic mechanism see {ERC20PresetMinterPauser}.
1104  *
1105  * TIP: For a detailed writeup see our guide
1106  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1107  * to implement supply mechanisms].
1108  *
1109  * We have followed general OpenZeppelin guidelines: functions revert instead
1110  * of returning `false` on failure. This behavior is nonetheless conventional
1111  * and does not conflict with the expectations of ERC20 applications.
1112  *
1113  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1114  * This allows applications to reconstruct the allowance for all accounts just
1115  * by listening to said events. Other implementations of the EIP may not emit
1116  * these events, as it isn't required by the specification.
1117  *
1118  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1119  * functions have been added to mitigate the well-known issues around setting
1120  * allowances. See {IERC20-approve}.
1121  */
1122 contract ERC20 is Context, IERC20 {
1123     using SafeMath for uint256;
1124 
1125     mapping(address => uint256) private _balances;
1126 
1127     mapping(address => mapping(address => uint256)) private _allowances;
1128 
1129     uint256 private _totalSupply;
1130 
1131     string private _name;
1132     string private _symbol;
1133     uint8 private _decimals;
1134 
1135     /**
1136      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1137      * a default value of 18.
1138      *
1139      * To select a different value for {decimals}, use {_setupDecimals}.
1140      *
1141      * All three of these values are immutable: they can only be set once during
1142      * construction.
1143      */
1144     constructor(string memory name_, string memory symbol_) public {
1145         _name = name_;
1146         _symbol = symbol_;
1147         _decimals = 18;
1148     }
1149 
1150     /**
1151      * @dev Returns the name of the token.
1152      */
1153     function name() public view returns (string memory) {
1154         return _name;
1155     }
1156 
1157     /**
1158      * @dev Returns the symbol of the token, usually a shorter version of the
1159      * name.
1160      */
1161     function symbol() public view returns (string memory) {
1162         return _symbol;
1163     }
1164 
1165     /**
1166      * @dev Returns the number of decimals used to get its user representation.
1167      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1168      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1169      *
1170      * Tokens usually opt for a value of 18, imitating the relationship between
1171      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1172      * called.
1173      *
1174      * NOTE: This information is only used for _display_ purposes: it in
1175      * no way affects any of the arithmetic of the contract, including
1176      * {IERC20-balanceOf} and {IERC20-transfer}.
1177      */
1178     function decimals() public view returns (uint8) {
1179         return _decimals;
1180     }
1181 
1182     /**
1183      * @dev See {IERC20-totalSupply}.
1184      */
1185     function totalSupply() public view override returns (uint256) {
1186         return _totalSupply;
1187     }
1188 
1189     /**
1190      * @dev See {IERC20-balanceOf}.
1191      */
1192     function balanceOf(address account) public view override returns (uint256) {
1193         return _balances[account];
1194     }
1195 
1196     /**
1197      * @dev See {IERC20-transfer}.
1198      *
1199      * Requirements:
1200      *
1201      * - `recipient` cannot be the zero address.
1202      * - the caller must have a balance of at least `amount`.
1203      */
1204     function transfer(address recipient, uint256 amount)
1205         public
1206         virtual
1207         override
1208         returns (bool)
1209     {
1210         _transfer(_msgSender(), recipient, amount);
1211         return true;
1212     }
1213 
1214     /**
1215      * @dev See {IERC20-allowance}.
1216      */
1217     function allowance(address owner, address spender)
1218         public
1219         view
1220         virtual
1221         override
1222         returns (uint256)
1223     {
1224         return _allowances[owner][spender];
1225     }
1226 
1227     /**
1228      * @dev See {IERC20-approve}.
1229      *
1230      * Requirements:
1231      *
1232      * - `spender` cannot be the zero address.
1233      */
1234     function approve(address spender, uint256 amount)
1235         public
1236         virtual
1237         override
1238         returns (bool)
1239     {
1240         _approve(_msgSender(), spender, amount);
1241         return true;
1242     }
1243 
1244     /**
1245      * @dev See {IERC20-transferFrom}.
1246      *
1247      * Emits an {Approval} event indicating the updated allowance. This is not
1248      * required by the EIP. See the note at the beginning of {ERC20}.
1249      *
1250      * Requirements:
1251      *
1252      * - `sender` and `recipient` cannot be the zero address.
1253      * - `sender` must have a balance of at least `amount`.
1254      * - the caller must have allowance for ``sender``'s tokens of at least
1255      * `amount`.
1256      */
1257     function transferFrom(
1258         address sender,
1259         address recipient,
1260         uint256 amount
1261     ) public virtual override returns (bool) {
1262         _transfer(sender, recipient, amount);
1263         _approve(
1264             sender,
1265             _msgSender(),
1266             _allowances[sender][_msgSender()].sub(
1267                 amount,
1268                 "ERC20: transfer amount exceeds allowance"
1269             )
1270         );
1271         return true;
1272     }
1273 
1274     /**
1275      * @dev Atomically increases the allowance granted to `spender` by the caller.
1276      *
1277      * This is an alternative to {approve} that can be used as a mitigation for
1278      * problems described in {IERC20-approve}.
1279      *
1280      * Emits an {Approval} event indicating the updated allowance.
1281      *
1282      * Requirements:
1283      *
1284      * - `spender` cannot be the zero address.
1285      */
1286     function increaseAllowance(address spender, uint256 addedValue)
1287         public
1288         virtual
1289         returns (bool)
1290     {
1291         _approve(
1292             _msgSender(),
1293             spender,
1294             _allowances[_msgSender()][spender].add(addedValue)
1295         );
1296         return true;
1297     }
1298 
1299     /**
1300      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1301      *
1302      * This is an alternative to {approve} that can be used as a mitigation for
1303      * problems described in {IERC20-approve}.
1304      *
1305      * Emits an {Approval} event indicating the updated allowance.
1306      *
1307      * Requirements:
1308      *
1309      * - `spender` cannot be the zero address.
1310      * - `spender` must have allowance for the caller of at least
1311      * `subtractedValue`.
1312      */
1313     function decreaseAllowance(address spender, uint256 subtractedValue)
1314         public
1315         virtual
1316         returns (bool)
1317     {
1318         _approve(
1319             _msgSender(),
1320             spender,
1321             _allowances[_msgSender()][spender].sub(
1322                 subtractedValue,
1323                 "ERC20: decreased allowance below zero"
1324             )
1325         );
1326         return true;
1327     }
1328 
1329     /**
1330      * @dev Moves tokens `amount` from `sender` to `recipient`.
1331      *
1332      * This is internal function is equivalent to {transfer}, and can be used to
1333      * e.g. implement automatic token fees, slashing mechanisms, etc.
1334      *
1335      * Emits a {Transfer} event.
1336      *
1337      * Requirements:
1338      *
1339      * - `sender` cannot be the zero address.
1340      * - `recipient` cannot be the zero address.
1341      * - `sender` must have a balance of at least `amount`.
1342      */
1343     function _transfer(
1344         address sender,
1345         address recipient,
1346         uint256 amount
1347     ) internal virtual {
1348         require(sender != address(0), "ERC20: transfer from the zero address");
1349         require(recipient != address(0), "ERC20: transfer to the zero address");
1350 
1351         _beforeTokenTransfer(sender, recipient, amount);
1352 
1353         _balances[sender] = _balances[sender].sub(
1354             amount,
1355             "ERC20: transfer amount exceeds balance"
1356         );
1357         _balances[recipient] = _balances[recipient].add(amount);
1358         emit Transfer(sender, recipient, amount);
1359     }
1360 
1361     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1362      * the total supply.
1363      *
1364      * Emits a {Transfer} event with `from` set to the zero address.
1365      *
1366      * Requirements:
1367      *
1368      * - `to` cannot be the zero address.
1369      */
1370     function _mint(address account, uint256 amount) internal virtual {
1371         require(account != address(0), "ERC20: mint to the zero address");
1372 
1373         _beforeTokenTransfer(address(0), account, amount);
1374 
1375         _totalSupply = _totalSupply.add(amount);
1376         _balances[account] = _balances[account].add(amount);
1377         emit Transfer(address(0), account, amount);
1378     }
1379 
1380     /**
1381      * @dev Destroys `amount` tokens from `account`, reducing the
1382      * total supply.
1383      *
1384      * Emits a {Transfer} event with `to` set to the zero address.
1385      *
1386      * Requirements:
1387      *
1388      * - `account` cannot be the zero address.
1389      * - `account` must have at least `amount` tokens.
1390      */
1391     function _burn(address account, uint256 amount) internal virtual {
1392         require(account != address(0), "ERC20: burn from the zero address");
1393 
1394         _beforeTokenTransfer(account, address(0), amount);
1395 
1396         _balances[account] = _balances[account].sub(
1397             amount,
1398             "ERC20: burn amount exceeds balance"
1399         );
1400         _totalSupply = _totalSupply.sub(amount);
1401         emit Transfer(account, address(0), amount);
1402     }
1403 
1404     /**
1405      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1406      *
1407      * This internal function is equivalent to `approve`, and can be used to
1408      * e.g. set automatic allowances for certain subsystems, etc.
1409      *
1410      * Emits an {Approval} event.
1411      *
1412      * Requirements:
1413      *
1414      * - `owner` cannot be the zero address.
1415      * - `spender` cannot be the zero address.
1416      */
1417     function _approve(
1418         address owner,
1419         address spender,
1420         uint256 amount
1421     ) internal virtual {
1422         require(owner != address(0), "ERC20: approve from the zero address");
1423         require(spender != address(0), "ERC20: approve to the zero address");
1424 
1425         _allowances[owner][spender] = amount;
1426         emit Approval(owner, spender, amount);
1427     }
1428 
1429     /**
1430      * @dev Sets {decimals} to a value other than the default one of 18.
1431      *
1432      * WARNING: This function should only be called from the constructor. Most
1433      * applications that interact with token contracts will not expect
1434      * {decimals} to ever change, and may work incorrectly if it does.
1435      */
1436     function _setupDecimals(uint8 decimals_) internal {
1437         _decimals = decimals_;
1438     }
1439 
1440     /**
1441      * @dev Hook that is called before any transfer of tokens. This includes
1442      * minting and burning.
1443      *
1444      * Calling conditions:
1445      *
1446      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1447      * will be to transferred to `to`.
1448      * - when `from` is zero, `amount` tokens will be minted for `to`.
1449      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1450      * - `from` and `to` are never both zero.
1451      *
1452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1453      */
1454     function _beforeTokenTransfer(
1455         address from,
1456         address to,
1457         uint256 amount
1458     ) internal virtual {}
1459 }
1460 
1461 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
1462 
1463 pragma solidity >=0.6.0 <0.8.0;
1464 
1465 /**
1466  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1467  * tokens and those that they have an allowance for, in a way that can be
1468  * recognized off-chain (via event analysis).
1469  */
1470 abstract contract ERC20Burnable is Context, ERC20 {
1471     using SafeMath for uint256;
1472 
1473     /**
1474      * @dev Destroys `amount` tokens from the caller.
1475      *
1476      * See {ERC20-_burn}.
1477      */
1478     function burn(uint256 amount) public virtual {
1479         _burn(_msgSender(), amount);
1480     }
1481 
1482     /**
1483      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1484      * allowance.
1485      *
1486      * See {ERC20-_burn} and {ERC20-allowance}.
1487      *
1488      * Requirements:
1489      *
1490      * - the caller must have allowance for ``accounts``'s tokens of at least
1491      * `amount`.
1492      */
1493     function burnFrom(address account, uint256 amount) public virtual {
1494         uint256 decreasedAllowance =
1495             allowance(account, _msgSender()).sub(
1496                 amount,
1497                 "ERC20: burn amount exceeds allowance"
1498             );
1499 
1500         _approve(account, _msgSender(), decreasedAllowance);
1501         _burn(account, amount);
1502     }
1503 }
1504 
1505 // File: @openzeppelin/contracts/utils/Pausable.sol
1506 
1507 pragma solidity >=0.6.0 <0.8.0;
1508 
1509 /**
1510  * @dev Contract module which allows children to implement an emergency stop
1511  * mechanism that can be triggered by an authorized account.
1512  *
1513  * This module is used through inheritance. It will make available the
1514  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1515  * the functions of your contract. Note that they will not be pausable by
1516  * simply including this module, only once the modifiers are put in place.
1517  */
1518 abstract contract Pausable is Context {
1519     /**
1520      * @dev Emitted when the pause is triggered by `account`.
1521      */
1522     event Paused(address account);
1523 
1524     /**
1525      * @dev Emitted when the pause is lifted by `account`.
1526      */
1527     event Unpaused(address account);
1528 
1529     bool private _paused;
1530 
1531     /**
1532      * @dev Initializes the contract in unpaused state.
1533      */
1534     constructor() internal {
1535         _paused = false;
1536     }
1537 
1538     /**
1539      * @dev Returns true if the contract is paused, and false otherwise.
1540      */
1541     function paused() public view returns (bool) {
1542         return _paused;
1543     }
1544 
1545     /**
1546      * @dev Modifier to make a function callable only when the contract is not paused.
1547      *
1548      * Requirements:
1549      *
1550      * - The contract must not be paused.
1551      */
1552     modifier whenNotPaused() {
1553         require(!_paused, "Pausable: paused");
1554         _;
1555     }
1556 
1557     /**
1558      * @dev Modifier to make a function callable only when the contract is paused.
1559      *
1560      * Requirements:
1561      *
1562      * - The contract must be paused.
1563      */
1564     modifier whenPaused() {
1565         require(_paused, "Pausable: not paused");
1566         _;
1567     }
1568 
1569     /**
1570      * @dev Triggers stopped state.
1571      *
1572      * Requirements:
1573      *
1574      * - The contract must not be paused.
1575      */
1576     function _pause() internal virtual whenNotPaused {
1577         _paused = true;
1578         emit Paused(_msgSender());
1579     }
1580 
1581     /**
1582      * @dev Returns to normal state.
1583      *
1584      * Requirements:
1585      *
1586      * - The contract must be paused.
1587      */
1588     function _unpause() internal virtual whenPaused {
1589         _paused = false;
1590         emit Unpaused(_msgSender());
1591     }
1592 }
1593 
1594 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
1595 
1596 pragma solidity >=0.6.0 <0.8.0;
1597 
1598 /**
1599  * @dev ERC20 token with pausable token transfers, minting and burning.
1600  *
1601  * Useful for scenarios such as preventing trades until the end of an evaluation
1602  * period, or having an emergency switch for freezing all token transfers in the
1603  * event of a large bug.
1604  */
1605 abstract contract ERC20Pausable is ERC20, Pausable {
1606     /**
1607      * @dev See {ERC20-_beforeTokenTransfer}.
1608      *
1609      * Requirements:
1610      *
1611      * - the contract must not be paused.
1612      */
1613     function _beforeTokenTransfer(
1614         address from,
1615         address to,
1616         uint256 amount
1617     ) internal virtual override {
1618         super._beforeTokenTransfer(from, to, amount);
1619 
1620         require(!paused(), "ERC20Pausable: token transfer while paused");
1621     }
1622 }
1623 
1624 // File: contracts/WrappedSCRT.sol
1625 
1626 pragma solidity >=0.6.0 <0.8.0;
1627 
1628 contract WrappedSCRT is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1629     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1630     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1631 
1632     /**
1633      * @dev Grants `DEFAULT_ADMIN_ROLE` and `PAUSER_ROLE` to the
1634      * account that deploys the contract. Grnats `MINTER_ROLE` to the bridge.
1635      *
1636      * See {ERC20-constructor}.
1637      */
1638     constructor(address bridge) public ERC20("Wrapped SCRT", "WSCRT") {
1639         _setupDecimals(6);
1640 
1641         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1642         _setupRole(PAUSER_ROLE, _msgSender());
1643         _setupRole(MINTER_ROLE, bridge);
1644     }
1645 
1646     /**
1647      * @dev Pauses all token transfers.
1648      *
1649      * See {ERC20Pausable} and {Pausable-_pause}.
1650      *
1651      * Requirements:
1652      *
1653      * - the caller must have the `PAUSER_ROLE`.
1654      */
1655     function pause() public virtual {
1656         require(
1657             hasRole(PAUSER_ROLE, _msgSender()),
1658             "WrappedSCRT: must have pauser role to pause"
1659         );
1660         _pause();
1661     }
1662 
1663     /**
1664      * @dev Unpauses all token transfers.
1665      *
1666      * See {ERC20Pausable} and {Pausable-_unpause}.
1667      *
1668      * Requirements:
1669      *
1670      * - the caller must have the `PAUSER_ROLE`.
1671      */
1672     function unpause() public virtual {
1673         require(
1674             hasRole(PAUSER_ROLE, _msgSender()),
1675             "WrappedSCRT: must have pauser role to unpause"
1676         );
1677         _unpause();
1678     }
1679 
1680     function _transfer(
1681         address sender,
1682         address recipient,
1683         uint256 amount
1684     ) internal virtual override {
1685         if (hasRole(MINTER_ROLE, sender)) {
1686             _mint(recipient, amount);
1687         } else if (hasRole(MINTER_ROLE, recipient)) {
1688             _burn(sender, amount);
1689         } else {
1690             super._transfer(sender, recipient, amount);
1691         }
1692     }
1693 
1694     function _beforeTokenTransfer(
1695         address from,
1696         address to,
1697         uint256 amount
1698     ) internal virtual override(ERC20, ERC20Pausable) {
1699         super._beforeTokenTransfer(from, to, amount);
1700     }
1701 }