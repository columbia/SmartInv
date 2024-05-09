1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
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
14 
15 library EnumerableSet {
16     // To implement this library for multiple types with as little code
17     // repetition as possible, we write it in terms of a generic Set type with
18     // bytes32 values.
19     // The Set implementation uses private functions, and user-facing
20     // implementations (such as AddressSet) are just wrappers around the
21     // underlying Set.
22     // This means that we can only create new EnumerableSets for types that fit
23     // in bytes32.
24 
25     struct Set {
26         // Storage of set values
27         bytes32[] _values;
28 
29         // Position of the value in the `values` array, plus 1 because index 0
30         // means a value is not in the set.
31         mapping (bytes32 => uint256) _indexes;
32     }
33 
34     /**
35      * @dev Add a value to a set. O(1).
36      *
37      * Returns true if the value was added to the set, that is if it was not
38      * already present.
39      */
40     function _add(Set storage set, bytes32 value) private returns (bool) {
41         if (!_contains(set, value)) {
42             set._values.push(value);
43             // The value is stored at length-1, but we add 1 to all indexes
44             // and use 0 as a sentinel value
45             set._indexes[value] = set._values.length;
46             return true;
47         } else {
48             return false;
49         }
50     }
51 
52     /**
53      * @dev Removes a value from a set. O(1).
54      *
55      * Returns true if the value was removed from the set, that is if it was
56      * present.
57      */
58     function _remove(Set storage set, bytes32 value) private returns (bool) {
59         // We read and store the value's index to prevent multiple reads from the same storage slot
60         uint256 valueIndex = set._indexes[value];
61 
62         if (valueIndex != 0) { // Equivalent to contains(set, value)
63             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
64             // the array, and then remove the last element (sometimes called as 'swap and pop').
65             // This modifies the order of the array, as noted in {at}.
66 
67             uint256 toDeleteIndex = valueIndex - 1;
68             uint256 lastIndex = set._values.length - 1;
69 
70             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
71             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
72 
73             bytes32 lastvalue = set._values[lastIndex];
74 
75             // Move the last value to the index where the value to delete is
76             set._values[toDeleteIndex] = lastvalue;
77             // Update the index for the moved value
78             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
79 
80             // Delete the slot where the moved value was stored
81             set._values.pop();
82 
83             // Delete the index for the deleted slot
84             delete set._indexes[value];
85 
86             return true;
87         } else {
88             return false;
89         }
90     }
91 
92     /**
93      * @dev Returns true if the value is in the set. O(1).
94      */
95     function _contains(Set storage set, bytes32 value) private view returns (bool) {
96         return set._indexes[value] != 0;
97     }
98 
99     /**
100      * @dev Returns the number of values on the set. O(1).
101      */
102     function _length(Set storage set) private view returns (uint256) {
103         return set._values.length;
104     }
105 
106    /**
107     * @dev Returns the value stored at position `index` in the set. O(1).
108     *
109     * Note that there are no guarantees on the ordering of values inside the
110     * array, and it may change when more values are added or removed.
111     *
112     * Requirements:
113     *
114     * - `index` must be strictly less than {length}.
115     */
116     function _at(Set storage set, uint256 index) private view returns (bytes32) {
117         require(set._values.length > index, "EnumerableSet: index out of bounds");
118         return set._values[index];
119     }
120 
121     // AddressSet
122 
123     struct AddressSet {
124         Set _inner;
125     }
126 
127     /**
128      * @dev Add a value to a set. O(1).
129      *
130      * Returns true if the value was added to the set, that is if it was not
131      * already present.
132      */
133     function add(AddressSet storage set, address value) internal returns (bool) {
134         return _add(set._inner, bytes32(uint256(value)));
135     }
136 
137     /**
138      * @dev Removes a value from a set. O(1).
139      *
140      * Returns true if the value was removed from the set, that is if it was
141      * present.
142      */
143     function remove(AddressSet storage set, address value) internal returns (bool) {
144         return _remove(set._inner, bytes32(uint256(value)));
145     }
146 
147     /**
148      * @dev Returns true if the value is in the set. O(1).
149      */
150     function contains(AddressSet storage set, address value) internal view returns (bool) {
151         return _contains(set._inner, bytes32(uint256(value)));
152     }
153 
154     /**
155      * @dev Returns the number of values in the set. O(1).
156      */
157     function length(AddressSet storage set) internal view returns (uint256) {
158         return _length(set._inner);
159     }
160 
161    /**
162     * @dev Returns the value stored at position `index` in the set. O(1).
163     *
164     * Note that there are no guarantees on the ordering of values inside the
165     * array, and it may change when more values are added or removed.
166     *
167     * Requirements:
168     *
169     * - `index` must be strictly less than {length}.
170     */
171     function at(AddressSet storage set, uint256 index) internal view returns (address) {
172         return address(uint256(_at(set._inner, index)));
173     }
174 
175 
176     // UintSet
177 
178     struct UintSet {
179         Set _inner;
180     }
181 
182     /**
183      * @dev Add a value to a set. O(1).
184      *
185      * Returns true if the value was added to the set, that is if it was not
186      * already present.
187      */
188     function add(UintSet storage set, uint256 value) internal returns (bool) {
189         return _add(set._inner, bytes32(value));
190     }
191 
192     /**
193      * @dev Removes a value from a set. O(1).
194      *
195      * Returns true if the value was removed from the set, that is if it was
196      * present.
197      */
198     function remove(UintSet storage set, uint256 value) internal returns (bool) {
199         return _remove(set._inner, bytes32(value));
200     }
201 
202     /**
203      * @dev Returns true if the value is in the set. O(1).
204      */
205     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
206         return _contains(set._inner, bytes32(value));
207     }
208 
209     /**
210      * @dev Returns the number of values on the set. O(1).
211      */
212     function length(UintSet storage set) internal view returns (uint256) {
213         return _length(set._inner);
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
226     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
227         return uint256(_at(set._inner, index));
228     }
229 }
230 
231 
232 library SafeMath {
233     /**
234      * @dev Returns the addition of two unsigned integers, reverting on
235      * overflow.
236      *
237      * Counterpart to Solidity's `+` operator.
238      *
239      * Requirements:
240      *
241      * - Addition cannot overflow.
242      */
243     function add(uint256 a, uint256 b) internal pure returns (uint256) {
244         uint256 c = a + b;
245         require(c >= a, "SafeMath: addition overflow");
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the subtraction of two unsigned integers, reverting on
252      * overflow (when the result is negative).
253      *
254      * Counterpart to Solidity's `-` operator.
255      *
256      * Requirements:
257      *
258      * - Subtraction cannot overflow.
259      */
260     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261         return sub(a, b, "SafeMath: subtraction overflow");
262     }
263 
264     /**
265      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
266      * overflow (when the result is negative).
267      *
268      * Counterpart to Solidity's `-` operator.
269      *
270      * Requirements:
271      *
272      * - Subtraction cannot overflow.
273      */
274     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b <= a, errorMessage);
276         uint256 c = a - b;
277 
278         return c;
279     }
280 
281     /**
282      * @dev Returns the multiplication of two unsigned integers, reverting on
283      * overflow.
284      *
285      * Counterpart to Solidity's `*` operator.
286      *
287      * Requirements:
288      *
289      * - Multiplication cannot overflow.
290      */
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
293         // benefit is lost if 'b' is also tested.
294         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
295         if (a == 0) {
296             return 0;
297         }
298 
299         uint256 c = a * b;
300         require(c / a == b, "SafeMath: multiplication overflow");
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the integer division of two unsigned integers. Reverts on
307      * division by zero. The result is rounded towards zero.
308      *
309      * Counterpart to Solidity's `/` operator. Note: this function uses a
310      * `revert` opcode (which leaves remaining gas untouched) while Solidity
311      * uses an invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function div(uint256 a, uint256 b) internal pure returns (uint256) {
318         return div(a, b, "SafeMath: division by zero");
319     }
320 
321     /**
322      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
323      * division by zero. The result is rounded towards zero.
324      *
325      * Counterpart to Solidity's `/` operator. Note: this function uses a
326      * `revert` opcode (which leaves remaining gas untouched) while Solidity
327      * uses an invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b > 0, errorMessage);
335         uint256 c = a / b;
336         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
337 
338         return c;
339     }
340 
341     /**
342      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
343      * Reverts when dividing by zero.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
354         return mod(a, b, "SafeMath: modulo by zero");
355     }
356 
357     /**
358      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
359      * Reverts with custom message when dividing by zero.
360      *
361      * Counterpart to Solidity's `%` operator. This function uses a `revert`
362      * opcode (which leaves remaining gas untouched) while Solidity uses an
363      * invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      *
367      * - The divisor cannot be zero.
368      */
369     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
370         require(b != 0, errorMessage);
371         return a % b;
372     }
373 }
374 
375 
376 contract Pausable is Context {
377     /**
378      * @dev Emitted when the pause is triggered by `account`.
379      */
380     event Paused(address account);
381 
382     /**
383      * @dev Emitted when the pause is lifted by `account`.
384      */
385     event Unpaused(address account);
386 
387     bool private _paused;
388 
389     /**
390      * @dev Initializes the contract in unpaused state.
391      */
392     constructor () internal {
393         _paused = false;
394     }
395 
396     /**
397      * @dev Returns true if the contract is paused, and false otherwise.
398      */
399     function paused() public view returns (bool) {
400         return _paused;
401     }
402 
403     /**
404      * @dev Modifier to make a function callable only when the contract is not paused.
405      *
406      * Requirements:
407      *
408      * - The contract must not be paused.
409      */
410     modifier whenNotPaused() {
411         require(!_paused, "Pausable: paused");
412         _;
413     }
414 
415     /**
416      * @dev Modifier to make a function callable only when the contract is paused.
417      *
418      * Requirements:
419      *
420      * - The contract must be paused.
421      */
422     modifier whenPaused() {
423         require(_paused, "Pausable: not paused");
424         _;
425     }
426 
427     /**
428      * @dev Triggers stopped state.
429      *
430      * Requirements:
431      *
432      * - The contract must not be paused.
433      */
434     function _pause() internal virtual whenNotPaused {
435         _paused = true;
436         emit Paused(_msgSender());
437     }
438 
439     /**
440      * @dev Returns to normal state.
441      *
442      * Requirements:
443      *
444      * - The contract must be paused.
445      */
446     function _unpause() internal virtual whenPaused {
447         _paused = false;
448         emit Unpaused(_msgSender());
449     }
450 }
451 
452 
453 /**
454  * @dev Contract module that allows children to implement role-based access
455  * control mechanisms.
456  *
457  * Roles are referred to by their `bytes32` identifier. These should be exposed
458  * in the external API and be unique. The best way to achieve this is by
459  * using `public constant` hash digests:
460  *
461  * ```
462  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
463  * ```
464  *
465  * Roles can be used to represent a set of permissions. To restrict access to a
466  * function call, use {hasRole}:
467  *
468  * ```
469  * function foo() public {
470  *     require(hasRole(MY_ROLE, msg.sender));
471  *     ...
472  * }
473  * ```
474  *
475  * Roles can be granted and revoked dynamically via the {grantRole} and
476  * {revokeRole} functions. Each role has an associated admin role, and only
477  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
478  *
479  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
480  * that only accounts with this role will be able to grant or revoke other
481  * roles. More complex role relationships can be created by using
482  * {_setRoleAdmin}.
483  *
484  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
485  * grant and revoke this role. Extra precautions should be taken to secure
486  * accounts that have been granted it.
487  */
488 abstract contract AccessControl is Context {
489     using EnumerableSet for EnumerableSet.AddressSet;
490     using Address for address;
491 
492     struct RoleData {
493         EnumerableSet.AddressSet members;
494         bytes32 adminRole;
495     }
496 
497     mapping (bytes32 => RoleData) private _roles;
498 
499     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
500 
501     /**
502      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
503      *
504      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
505      * {RoleAdminChanged} not being emitted signaling this.
506      *
507      * _Available since v3.1._
508      */
509     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
510 
511     /**
512      * @dev Emitted when `account` is granted `role`.
513      *
514      * `sender` is the account that originated the contract call, an admin role
515      * bearer except when using {_setupRole}.
516      */
517     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
518 
519     /**
520      * @dev Emitted when `account` is revoked `role`.
521      *
522      * `sender` is the account that originated the contract call:
523      *   - if using `revokeRole`, it is the admin role bearer
524      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
525      */
526     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
527 
528     /**
529      * @dev Returns `true` if `account` has been granted `role`.
530      */
531     function hasRole(bytes32 role, address account) public view returns (bool) {
532         return _roles[role].members.contains(account);
533     }
534 
535     /**
536      * @dev Returns the number of accounts that have `role`. Can be used
537      * together with {getRoleMember} to enumerate all bearers of a role.
538      */
539     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
540         return _roles[role].members.length();
541     }
542 
543     /**
544      * @dev Returns one of the accounts that have `role`. `index` must be a
545      * value between 0 and {getRoleMemberCount}, non-inclusive.
546      *
547      * Role bearers are not sorted in any particular way, and their ordering may
548      * change at any point.
549      *
550      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
551      * you perform all queries on the same block. See the following
552      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
553      * for more information.
554      */
555     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
556         return _roles[role].members.at(index);
557     }
558 
559     /**
560      * @dev Returns the admin role that controls `role`. See {grantRole} and
561      * {revokeRole}.
562      *
563      * To change a role's admin, use {_setRoleAdmin}.
564      */
565     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
566         return _roles[role].adminRole;
567     }
568 
569     /**
570      * @dev Grants `role` to `account`.
571      *
572      * If `account` had not been already granted `role`, emits a {RoleGranted}
573      * event.
574      *
575      * Requirements:
576      *
577      * - the caller must have ``role``'s admin role.
578      */
579     function grantRole(bytes32 role, address account) public virtual {
580         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
581 
582         _grantRole(role, account);
583     }
584 
585     /**
586      * @dev Revokes `role` from `account`.
587      *
588      * If `account` had been granted `role`, emits a {RoleRevoked} event.
589      *
590      * Requirements:
591      *
592      * - the caller must have ``role``'s admin role.
593      */
594     function revokeRole(bytes32 role, address account) public virtual {
595         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
596 
597         _revokeRole(role, account);
598     }
599 
600     /**
601      * @dev Revokes `role` from the calling account.
602      *
603      * Roles are often managed via {grantRole} and {revokeRole}: this function's
604      * purpose is to provide a mechanism for accounts to lose their privileges
605      * if they are compromised (such as when a trusted device is misplaced).
606      *
607      * If the calling account had been granted `role`, emits a {RoleRevoked}
608      * event.
609      *
610      * Requirements:
611      *
612      * - the caller must be `account`.
613      */
614     function renounceRole(bytes32 role, address account) public virtual {
615         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
616 
617         _revokeRole(role, account);
618     }
619 
620     /**
621      * @dev Grants `role` to `account`.
622      *
623      * If `account` had not been already granted `role`, emits a {RoleGranted}
624      * event. Note that unlike {grantRole}, this function doesn't perform any
625      * checks on the calling account.
626      *
627      * [WARNING]
628      * ====
629      * This function should only be called from the constructor when setting
630      * up the initial roles for the system.
631      *
632      * Using this function in any other way is effectively circumventing the admin
633      * system imposed by {AccessControl}.
634      * ====
635      */
636     function _setupRole(bytes32 role, address account) internal virtual {
637         _grantRole(role, account);
638     }
639 
640     /**
641      * @dev Sets `adminRole` as ``role``'s admin role.
642      *
643      * Emits a {RoleAdminChanged} event.
644      */
645     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
646         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
647         _roles[role].adminRole = adminRole;
648     }
649 
650     function _grantRole(bytes32 role, address account) private {
651         if (_roles[role].members.add(account)) {
652             emit RoleGranted(role, account, _msgSender());
653         }
654     }
655 
656     function _revokeRole(bytes32 role, address account) private {
657         if (_roles[role].members.remove(account)) {
658             emit RoleRevoked(role, account, _msgSender());
659         }
660     }
661 }
662 
663 
664 /**
665  * @dev Collection of functions related to the address type
666  */
667 library Address {
668     /**
669      * @dev Returns true if `account` is a contract.
670      *
671      * [IMPORTANT]
672      * ====
673      * It is unsafe to assume that an address for which this function returns
674      * false is an externally-owned account (EOA) and not a contract.
675      *
676      * Among others, `isContract` will return false for the following
677      * types of addresses:
678      *
679      *  - an externally-owned account
680      *  - a contract in construction
681      *  - an address where a contract will be created
682      *  - an address where a contract lived, but was destroyed
683      * ====
684      */
685     function isContract(address account) internal view returns (bool) {
686         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
687         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
688         // for accounts without code, i.e. `keccak256('')`
689         bytes32 codehash;
690         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
691         // solhint-disable-next-line no-inline-assembly
692         assembly { codehash := extcodehash(account) }
693         return (codehash != accountHash && codehash != 0x0);
694     }
695 
696     /**
697      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
698      * `recipient`, forwarding all available gas and reverting on errors.
699      *
700      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
701      * of certain opcodes, possibly making contracts go over the 2300 gas limit
702      * imposed by `transfer`, making them unable to receive funds via
703      * `transfer`. {sendValue} removes this limitation.
704      *
705      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
706      *
707      * IMPORTANT: because control is transferred to `recipient`, care must be
708      * taken to not create reentrancy vulnerabilities. Consider using
709      * {ReentrancyGuard} or the
710      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
711      */
712     function sendValue(address payable recipient, uint256 amount) internal {
713         require(address(this).balance >= amount, "Address: insufficient balance");
714 
715         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
716         (bool success, ) = recipient.call{ value: amount }("");
717         require(success, "Address: unable to send value, recipient may have reverted");
718     }
719 
720     /**
721      * @dev Performs a Solidity function call using a low level `call`. A
722      * plain`call` is an unsafe replacement for a function call: use this
723      * function instead.
724      *
725      * If `target` reverts with a revert reason, it is bubbled up by this
726      * function (like regular Solidity function calls).
727      *
728      * Returns the raw returned data. To convert to the expected return value,
729      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
730      *
731      * Requirements:
732      *
733      * - `target` must be a contract.
734      * - calling `target` with `data` must not revert.
735      *
736      * _Available since v3.1._
737      */
738     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
739       return functionCall(target, data, "Address: low-level call failed");
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
744      * `errorMessage` as a fallback revert reason when `target` reverts.
745      *
746      * _Available since v3.1._
747      */
748     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
749         return _functionCallWithValue(target, data, 0, errorMessage);
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
754      * but also transferring `value` wei to `target`.
755      *
756      * Requirements:
757      *
758      * - the calling contract must have an ETH balance of at least `value`.
759      * - the called Solidity function must be `payable`.
760      *
761      * _Available since v3.1._
762      */
763     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
764         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
769      * with `errorMessage` as a fallback revert reason when `target` reverts.
770      *
771      * _Available since v3.1._
772      */
773     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
774         require(address(this).balance >= value, "Address: insufficient balance for call");
775         return _functionCallWithValue(target, data, value, errorMessage);
776     }
777 
778     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
779         require(isContract(target), "Address: call to non-contract");
780 
781         // solhint-disable-next-line avoid-low-level-calls
782         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
783         if (success) {
784             return returndata;
785         } else {
786             // Look for revert reason and bubble it up if present
787             if (returndata.length > 0) {
788                 // The easiest way to bubble the revert reason is using memory via assembly
789 
790                 // solhint-disable-next-line no-inline-assembly
791                 assembly {
792                     let returndata_size := mload(returndata)
793                     revert(add(32, returndata), returndata_size)
794                 }
795             } else {
796                 revert(errorMessage);
797             }
798         }
799     }
800 }
801 
802 
803 interface IERC20 {
804     
805     function name() external view returns (string memory);
806 
807     function symbol() external view returns (string memory);
808 
809     function decimals() external view returns (uint8);
810 
811     function totalSupply() external view returns (uint);
812 
813     function balanceOf(address owner) external view returns (uint);
814 
815     function allowance(address owner, address spender) external view returns (uint);
816 
817     function transfer(address to, uint value) external returns (bool);
818 
819     function approve(address spender, uint value) external returns (bool);
820 
821     function transferFrom(
822         address from,
823         address to,
824         uint value
825     ) external returns (bool);
826 
827     event Transfer(address indexed from, address indexed to, uint value);
828 
829     event Approval(address indexed owner, address indexed spender, uint value);
830 }
831 
832 
833 
834 contract LnAdmin {
835     address public admin;
836     address public candidate;
837 
838     constructor(address _admin) public {
839         require(_admin != address(0), "admin address cannot be 0");
840         admin = _admin;
841         emit AdminChanged(address(0), _admin);
842     }
843 
844     function setCandidate(address _candidate) external onlyAdmin {
845         address old = candidate;
846         candidate = _candidate;
847         emit candidateChanged( old, candidate);
848     }
849 
850     function becomeAdmin( ) external {
851         require( msg.sender == candidate, "Only candidate can become admin");
852         address old = admin;
853         admin = candidate;
854         emit AdminChanged( old, admin ); 
855     }
856 
857     modifier onlyAdmin {
858         require( (msg.sender == admin), "Only the contract admin can perform this action");
859         _;
860     }
861 
862     event candidateChanged(address oldCandidate, address newCandidate );
863     event AdminChanged(address oldAdmin, address newAdmin);
864 }
865 
866 
867 
868 library SafeDecimalMath {
869     using SafeMath for uint;
870 
871     uint8 public constant decimals = 18;
872     uint8 public constant highPrecisionDecimals = 27;
873 
874     uint public constant UNIT = 10**uint(decimals);
875 
876     uint public constant PRECISE_UNIT = 10**uint(highPrecisionDecimals);
877     uint private constant UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR = 10**uint(highPrecisionDecimals - decimals);
878 
879     function unit() external pure returns (uint) {
880         return UNIT;
881     }
882 
883     function preciseUnit() external pure returns (uint) {
884         return PRECISE_UNIT;
885     }
886 
887     function multiplyDecimal(uint x, uint y) internal pure returns (uint) {
888         
889         return x.mul(y) / UNIT;
890     }
891 
892     function _multiplyDecimalRound(
893         uint x,
894         uint y,
895         uint precisionUnit
896     ) private pure returns (uint) {
897         
898         uint quotientTimesTen = x.mul(y) / (precisionUnit / 10);
899 
900         if (quotientTimesTen % 10 >= 5) {
901             quotientTimesTen += 10;
902         }
903 
904         return quotientTimesTen / 10;
905     }
906 
907     function multiplyDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
908         return _multiplyDecimalRound(x, y, PRECISE_UNIT);
909     }
910 
911     function multiplyDecimalRound(uint x, uint y) internal pure returns (uint) {
912         return _multiplyDecimalRound(x, y, UNIT);
913     }
914 
915     function divideDecimal(uint x, uint y) internal pure returns (uint) {
916         
917         return x.mul(UNIT).div(y);
918     }
919 
920     function _divideDecimalRound(
921         uint x,
922         uint y,
923         uint precisionUnit
924     ) private pure returns (uint) {
925         uint resultTimesTen = x.mul(precisionUnit * 10).div(y);
926 
927         if (resultTimesTen % 10 >= 5) {
928             resultTimesTen += 10;
929         }
930 
931         return resultTimesTen / 10;
932     }
933 
934     function divideDecimalRound(uint x, uint y) internal pure returns (uint) {
935         return _divideDecimalRound(x, y, UNIT);
936     }
937 
938     function divideDecimalRoundPrecise(uint x, uint y) internal pure returns (uint) {
939         return _divideDecimalRound(x, y, PRECISE_UNIT);
940     }
941 
942     function decimalToPreciseDecimal(uint i) internal pure returns (uint) {
943         return i.mul(UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR);
944     }
945 
946     function preciseDecimalToDecimal(uint i) internal pure returns (uint) {
947         uint quotientTimesTen = i / (UNIT_TO_HIGH_PRECISION_CONVERSION_FACTOR / 10);
948 
949         if (quotientTimesTen % 10 >= 5) {
950             quotientTimesTen += 10;
951         }
952 
953         return quotientTimesTen / 10;
954     }
955 }
956 
957 
958 
959 abstract contract LnOperatorModifier is LnAdmin {
960     
961     address public operator;
962 
963     constructor(address _operator) internal {
964         require(admin != address(0), "admin must be set");
965 
966         operator = _operator;
967         emit OperatorUpdated(_operator);
968     }
969 
970     function setOperator(address _opperator) external onlyAdmin {
971         operator = _opperator;
972         emit OperatorUpdated(_opperator);
973     }
974 
975     modifier onlyOperator() {
976         require(msg.sender == operator, "Only operator can perform this action");
977         _;
978     }
979 
980     event OperatorUpdated(address operator);
981 }
982 
983 
984 
985 // contract access control
986 contract LnAccessControl is AccessControl {
987     using Address for address;
988 
989     // -------------------------------------------------------
990     // role type
991     bytes32 public constant ISSUE_ASSET_ROLE = ("ISSUE_ASSET"); //keccak256
992     bytes32 public constant BURN_ASSET_ROLE = ("BURN_ASSET");
993 
994     bytes32 public constant DEBT_SYSTEM = ("LnDebtSystem");
995     // -------------------------------------------------------
996     constructor(address admin) public {
997         _setupRole(DEFAULT_ADMIN_ROLE, admin);
998     }
999 
1000     function IsAdmin(address _address) public view returns (bool) {
1001         return hasRole(DEFAULT_ADMIN_ROLE, _address);
1002     }
1003 
1004     function SetAdmin(address _address) public returns (bool) {
1005         require(IsAdmin(msg.sender), "Only admin");
1006 
1007         _setupRole(DEFAULT_ADMIN_ROLE, _address);
1008     }
1009 
1010     // -------------------------------------------------------
1011     // this func need admin role. grantRole and revokeRole need admin role
1012     function SetRoles(bytes32 roleType, address[] calldata addresses, bool[] calldata setTo) external {
1013         require(IsAdmin(msg.sender), "Only admin");
1014 
1015         _setRoles(roleType, addresses, setTo);
1016     }
1017 
1018     function _setRoles(bytes32 roleType, address[] calldata addresses, bool[] calldata setTo) private {
1019         require(addresses.length == setTo.length, "parameter address length not eq");
1020 
1021         for (uint256 i=0; i < addresses.length; i++) {
1022             //require(addresses[i].isContract(), "Role address need contract only");
1023             if (setTo[i]) {
1024                 grantRole(roleType, addresses[i]);
1025             } else {
1026                 revokeRole(roleType, addresses[i]);
1027             }
1028         }
1029     }
1030 
1031     // function SetRoles(bytes32 roleType, address[] calldata addresses, bool[] calldata setTo) public {
1032     //     _setRoles(roleType, addresses, setTo);
1033     // }
1034 
1035     // Issue burn
1036     function SetIssueAssetRole(address[] calldata issuer, bool[] calldata setTo) public {
1037         _setRoles(ISSUE_ASSET_ROLE, issuer, setTo);
1038     }
1039 
1040     function SetBurnAssetRole(address[] calldata burner, bool[] calldata setTo) public {
1041         _setRoles(BURN_ASSET_ROLE, burner, setTo);
1042     }
1043     
1044     //
1045     function SetDebtSystemRole(address[] calldata _address, bool[] calldata _setTo) public {
1046         _setRoles(DEBT_SYSTEM, _address, _setTo);
1047     }
1048 }
1049 
1050 
1051 interface ILinearStaking {
1052     function staking(uint256 amount) external returns (bool);
1053     function cancelStaking(uint256 amount) external returns (bool);
1054     function claim() external returns (bool);
1055     function stakingBalanceOf(address account) external view returns(uint256);
1056 }
1057 
1058 contract LnLinearStakingStorage is LnAdmin {
1059     using SafeMath for uint256;
1060 
1061     LnAccessControl public accessCtrl;
1062 
1063     bytes32 public constant DATA_ACCESS_ROLE = "LinearStakingStorage";
1064 
1065     struct StakingData {
1066         uint256 amount;
1067         uint256 staketime;
1068     }
1069 
1070     mapping (address => StakingData[]) public stakesdata;
1071     mapping (uint256 => uint256) public weeksTotal; // week staking amount
1072 
1073     uint256 public stakingStartTime = 1600329600; // TODO: UTC or UTC+8
1074     uint256 public stakingEndTime = 1605168000;
1075     uint256 public totalWeekNumber = 8;
1076     uint256 public weekRewardAmount = 18750000e18;
1077 
1078     constructor(address _admin, address _accessCtrl) public LnAdmin(_admin) {
1079         accessCtrl = LnAccessControl(_accessCtrl);
1080     }
1081 
1082     modifier OnlyLinearStakingStorageRole(address _address) {
1083         require(accessCtrl.hasRole(DATA_ACCESS_ROLE, _address), "Only Linear Staking Storage Role");
1084         _;
1085     }
1086 
1087     function setAccessControl(address _accessCtrl) external onlyAdmin {
1088         accessCtrl = LnAccessControl(_accessCtrl);
1089     }
1090 
1091     function weekTotalStaking() public view returns (uint256[] memory) {
1092         uint256[] memory totals = new uint256[](totalWeekNumber);
1093         for (uint256 i=0; i< totalWeekNumber; i++) {
1094             uint256 delta = weeksTotal[i];
1095             if (i == 0) {
1096                 totals[i] = delta;
1097             } else {
1098                 
1099                 totals[i] = totals[i-1].add(delta);
1100             }
1101         }
1102         return totals;
1103     }
1104 
1105     function getStakesdataLength(address account) external view returns(uint256) {
1106         return stakesdata[account].length;
1107     }
1108 
1109     function getStakesDataByIndex(address account, uint256 index) external view returns(uint256, uint256) {
1110         return (stakesdata[account][index].amount, stakesdata[account][index].staketime);
1111     }
1112 
1113     function stakingBalanceOf(address account) external view returns(uint256) {
1114         uint256 total = 0;
1115         StakingData[] memory stakes = stakesdata[account];
1116         for (uint256 i=0; i < stakes.length; i++) {
1117             total = total.add(stakes[i].amount);
1118         }
1119         return total;
1120     }
1121 
1122     function requireInStakingPeriod() external view {
1123         require(stakingStartTime < block.timestamp, "Staking not start");
1124         require(block.timestamp < stakingEndTime, "Staking stage has end.");
1125     }
1126 
1127     function requireStakingEnd() external view {
1128         require(block.timestamp > stakingEndTime, "Need wait to staking end");
1129     }
1130 
1131     function PushStakingData(address account, uint256 amount, uint256 staketime) external OnlyLinearStakingStorageRole(msg.sender) {
1132         LnLinearStakingStorage.StakingData memory data = LnLinearStakingStorage.StakingData({
1133             amount: amount,
1134             staketime: staketime
1135         });
1136         stakesdata[account].push(data);
1137     }
1138 
1139     function StakingDataAdd(address account, uint256 index, uint256 amount) external OnlyLinearStakingStorageRole(msg.sender) {
1140         stakesdata[account][index].amount = stakesdata[account][index].amount.add(amount);
1141     }
1142 
1143     function StakingDataSub(address account, uint256 index, uint256 amount) external OnlyLinearStakingStorageRole(msg.sender) {
1144         stakesdata[account][index].amount = stakesdata[account][index].amount.sub(amount, "StakingDataSub sub overflow");
1145     }
1146 
1147     function DeleteStakesData(address account) external OnlyLinearStakingStorageRole(msg.sender) {
1148         delete stakesdata[account];
1149     }
1150 
1151     function PopStakesData(address account) external OnlyLinearStakingStorageRole(msg.sender) {
1152         stakesdata[account].pop();
1153     }
1154 
1155     function AddWeeksTotal(uint256 staketime, uint256 amount) external OnlyLinearStakingStorageRole(msg.sender) {
1156         uint256 weekNumber = staketime.sub(stakingStartTime, "AddWeeksTotal sub overflow") / 1 weeks;
1157         weeksTotal[weekNumber] = weeksTotal[weekNumber].add(amount);
1158     }
1159 
1160     function SubWeeksTotal(uint256 staketime, uint256 amount) external OnlyLinearStakingStorageRole(msg.sender) {
1161         uint256 weekNumber = staketime.sub(stakingStartTime, "SubWeeksTotal weekNumber sub overflow") / 1 weeks;
1162         weeksTotal[weekNumber] = weeksTotal[weekNumber].sub(amount, "SubWeeksTotal weeksTotal sub overflow");
1163     }
1164 
1165     function setWeekRewardAmount(uint256 _weekRewardAmount) external onlyAdmin {
1166         weekRewardAmount = _weekRewardAmount;
1167     }
1168 
1169     function setStakingPeriod(uint _stakingStartTime, uint _stakingEndTime) external onlyAdmin {
1170         require(_stakingEndTime > _stakingStartTime);
1171 
1172         stakingStartTime = _stakingStartTime;
1173         stakingEndTime = _stakingEndTime;
1174 
1175         totalWeekNumber = stakingEndTime.sub(stakingStartTime, "setStakingPeriod totalWeekNumber sub overflow") / 1 weeks;
1176         if (stakingEndTime.sub(stakingStartTime, "setStakingPeriod stakingEndTime sub overflow") % 1 weeks != 0) {
1177             totalWeekNumber = totalWeekNumber.add(1);
1178         }
1179     }
1180 }
1181 
1182 contract LnLinearStaking is LnAdmin, Pausable, ILinearStaking {
1183     using SafeMath for uint256;
1184 
1185     IERC20 public linaToken; // lina token proxy address
1186     LnLinearStakingStorage public stakingStorage;
1187     
1188     constructor(
1189         address _admin,
1190         address _linaToken,
1191         address _storage
1192     ) public LnAdmin(_admin) {
1193         linaToken = IERC20(_linaToken);
1194         stakingStorage = LnLinearStakingStorage(_storage);
1195     }
1196 
1197     function setLinaToken(address _linaToken) external onlyAdmin {
1198         linaToken = IERC20(_linaToken);
1199     }
1200 
1201     function setPaused(bool _paused) external onlyAdmin {
1202         if (_paused) {
1203             _pause();
1204         } else {
1205             _unpause();
1206         }
1207     }
1208 
1209     //////////////////////////////////////////////////////
1210     event Staking(address indexed who, uint256 value, uint staketime);
1211     event CancelStaking(address indexed who, uint256 value);
1212     event Claim(address indexed who, uint256 rewardval, uint256 totalStaking);
1213 
1214     uint256 public accountStakingListLimit = 50;
1215     uint256 public minStakingAmount = 1e18; // 1 token
1216     uint256 public constant PRECISION_UINT = 1e23;
1217 
1218     function setLinaTokenAddress(address _token) external onlyAdmin {
1219         linaToken = IERC20(_token);
1220     }
1221 
1222     function setStakingListLimit(uint256 _limit) external onlyAdmin {
1223         accountStakingListLimit = _limit;
1224     }
1225 
1226     function setMinStakingAmount(uint256 _minStakingAmount) external onlyAdmin {
1227         minStakingAmount = _minStakingAmount;
1228     }
1229 
1230     function stakingBalanceOf(address account) external override view returns(uint256) {
1231         return stakingStorage.stakingBalanceOf(account);
1232     }
1233 
1234     function getStakesdataLength(address account) external view returns(uint256) {
1235         return stakingStorage.getStakesdataLength(account);
1236     }
1237     //--------------------------------------------------------
1238 
1239     function staking(uint256 amount) public whenNotPaused override returns (bool) {
1240         stakingStorage.requireInStakingPeriod();
1241 
1242         require(amount >= minStakingAmount, "Staking amount too small.");
1243         require(stakingStorage.getStakesdataLength(msg.sender) < accountStakingListLimit, "Staking list out of limit.");
1244 
1245         //linaToken.burn(msg.sender, amount);
1246         linaToken.transferFrom(msg.sender, address(this), amount);
1247      
1248         stakingStorage.PushStakingData(msg.sender, amount, block.timestamp);
1249         stakingStorage.AddWeeksTotal(block.timestamp, amount);
1250 
1251         emit Staking(msg.sender, amount, block.timestamp);
1252         return true;
1253     }
1254 
1255     function cancelStaking(uint256 amount) public whenNotPaused override returns (bool) {
1256         stakingStorage.requireInStakingPeriod();
1257 
1258         require(amount > 0, "Invalid amount.");
1259 
1260         uint256 returnToken = amount;
1261         for (uint256 i = stakingStorage.getStakesdataLength(msg.sender); i >= 1 ; i--) {
1262             (uint256 stakingAmount, uint256 staketime) = stakingStorage.getStakesDataByIndex(msg.sender, i-1);
1263             if (amount >= stakingAmount) {
1264                 amount = amount.sub(stakingAmount, "cancelStaking sub overflow");
1265                 
1266                 stakingStorage.PopStakesData(msg.sender);
1267                 stakingStorage.SubWeeksTotal(staketime, stakingAmount);
1268             } else {
1269                 stakingStorage.StakingDataSub(msg.sender, i-1, amount);
1270                 stakingStorage.SubWeeksTotal(staketime, amount);
1271 
1272                 amount = 0;
1273             }
1274             if (amount == 0) break;
1275         }
1276         require(amount == 0, "Cancel amount too big then staked.");
1277 
1278         //linaToken.mint(msg.sender, returnToken);
1279         linaToken.transfer(msg.sender, returnToken);
1280 
1281         emit CancelStaking(msg.sender, returnToken);
1282 
1283         return true;
1284     }
1285 
1286     // claim reward
1287     function claim() public whenNotPaused override returns (bool) {
1288         stakingStorage.requireStakingEnd();
1289 
1290         require(stakingStorage.getStakesdataLength(msg.sender) > 0, "Nothing to claim");
1291 
1292         uint256 totalWeekNumber = stakingStorage.totalWeekNumber();
1293 
1294         uint256 totalStaking = 0;
1295         uint256 totalReward = 0;
1296 
1297         uint256[] memory finalTotals = stakingStorage.weekTotalStaking();
1298         for (uint256 i=0; i < stakingStorage.getStakesdataLength(msg.sender); i++) {
1299             (uint256 stakingAmount, uint256 staketime) = stakingStorage.getStakesDataByIndex(msg.sender, i);
1300             uint256 stakedWeedNumber = staketime.sub(stakingStorage.stakingStartTime(), "claim sub overflow") / 1 weeks;
1301 
1302             totalStaking = totalStaking.add(stakingAmount);
1303             
1304             uint256 reward = 0;
1305             for (uint256 j=stakedWeedNumber; j < totalWeekNumber; j++) {
1306                 reward = reward.add( stakingAmount.mul(PRECISION_UINT).div(finalTotals[j]) ); //move .mul(weekRewardAmount) to next line.
1307             }
1308             reward = reward.mul(stakingStorage.weekRewardAmount()).div(PRECISION_UINT);
1309 
1310             totalReward = totalReward.add( reward );
1311         }
1312 
1313         stakingStorage.DeleteStakesData(msg.sender);
1314         
1315         //linaToken.mint(msg.sender, totalStaking.add(totalReward) );
1316         linaToken.transfer(msg.sender, totalStaking.add(totalReward) );
1317 
1318         emit Claim(msg.sender, totalReward, totalStaking);
1319         return true;
1320     }
1321 }
1322 
1323 contract LnRewardCalculator  {
1324     using SafeMath for uint256;
1325 
1326     struct UserInfo {
1327         uint256 reward;
1328         uint256 amount;     
1329         uint256 rewardDebt; 
1330     }
1331 
1332     struct PoolInfo {
1333         uint256 amount;           
1334         uint256 lastRewardBlock;  
1335         uint256 accRewardPerShare;
1336     }
1337 
1338     uint256 public rewardPerBlock;
1339 
1340     PoolInfo public mPoolInfo;
1341     mapping (address => UserInfo) public userInfo;
1342 
1343     uint256 public startBlock;
1344     uint256 public remainReward;
1345     uint256 public accReward;
1346 
1347     constructor( uint256 _rewardPerBlock, uint256 _startBlock ) public {
1348         rewardPerBlock = _rewardPerBlock;
1349         startBlock = _startBlock;
1350         mPoolInfo.lastRewardBlock = startBlock;
1351     }
1352 
1353 
1354     function _calcReward( uint256 curBlock, address _user) internal view returns (uint256) {
1355         PoolInfo storage pool = mPoolInfo;
1356         UserInfo storage user = userInfo[_user];
1357         uint256 accRewardPerShare = pool.accRewardPerShare;
1358         uint256 lpSupply = pool.amount;
1359         if (curBlock > pool.lastRewardBlock && lpSupply != 0) {
1360             uint256 multiplier = curBlock.sub( pool.lastRewardBlock, "cr curBlock sub overflow" );
1361             uint256 curReward = multiplier.mul(rewardPerBlock);
1362             accRewardPerShare = accRewardPerShare.add(curReward.mul(1e20).div(lpSupply));
1363         }
1364         uint newReward = user.amount.mul(accRewardPerShare).div(1e20).sub(user.rewardDebt, "cr newReward sub overflow");
1365         return newReward.add( user.reward );
1366     }
1367 
1368 
1369     function rewardOf( address _user ) public view returns( uint256 ){
1370         return userInfo[_user].reward;
1371     }
1372 
1373 
1374     function amount( ) public view returns( uint256 ){
1375         return mPoolInfo.amount;
1376     }
1377 
1378     function amountOf( address _user ) public view returns( uint256 ){
1379         return userInfo[_user].amount;
1380     }
1381 
1382     function getUserInfo(address _user) public view returns(uint256,uint256,uint256) {
1383         return (userInfo[_user].reward, userInfo[_user].amount, userInfo[_user].rewardDebt);
1384     }
1385 
1386     function getPoolInfo() public view returns(uint256,uint256,uint256) {
1387         return (mPoolInfo.amount, mPoolInfo.lastRewardBlock, mPoolInfo.accRewardPerShare);
1388     }
1389 
1390     function _update( uint256 curBlock ) internal {
1391         PoolInfo storage pool = mPoolInfo;
1392         if (curBlock <= pool.lastRewardBlock) {
1393             return;
1394         }
1395         uint256 lpSupply = pool.amount;
1396         if (lpSupply == 0) {
1397             pool.lastRewardBlock = curBlock;
1398             return;
1399         }
1400         uint256 multiplier = curBlock.sub( pool.lastRewardBlock, "_update curBlock sub overflow" );
1401         uint256 curReward = multiplier.mul(rewardPerBlock);
1402         
1403         remainReward = remainReward.add( curReward );
1404         accReward = accReward.add( curReward );
1405 
1406         pool.accRewardPerShare = pool.accRewardPerShare.add(curReward.mul(1e20).div(lpSupply));
1407         pool.lastRewardBlock = curBlock;
1408     }
1409 
1410     function _deposit( uint256 curBlock, address _addr, uint256 _amount) internal {
1411         PoolInfo storage pool = mPoolInfo;
1412         UserInfo storage user = userInfo[ _addr];
1413         _update( curBlock );
1414         if (user.amount > 0) {
1415             uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e20).sub(user.rewardDebt, "_deposit pending sub overflow");
1416             if(pending > 0) {
1417                 reward( user, pending );
1418             }
1419         }
1420         if(_amount > 0) {
1421             user.amount = user.amount.add(_amount);
1422             pool.amount = pool.amount.add(_amount);
1423         }
1424         user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e20);
1425     }
1426 
1427     function _withdraw( uint256 curBlock, address _addr, uint256 _amount) internal {
1428         PoolInfo storage pool = mPoolInfo;
1429         UserInfo storage user = userInfo[_addr];
1430         require(user.amount >= _amount, "_withdraw: not good");
1431         _update( curBlock );
1432         uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e20).sub(user.rewardDebt, "_withdraw pending sub overflow");
1433         if(pending > 0) {
1434             reward( user, pending );
1435         }
1436         if(_amount > 0) {
1437             user.amount = user.amount.sub(_amount, "_withdraw user.amount sub overflow");
1438             pool.amount = pool.amount.sub(_amount, "_withdraw pool.amount sub overflow");
1439         }
1440         user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e20);
1441     }
1442 
1443     function reward( UserInfo storage user, uint256 _amount) internal {
1444         if (_amount > remainReward) {
1445             _amount = remainReward;
1446         }
1447         remainReward = remainReward.sub( _amount, "reward remainReward sub overflow");
1448         user.reward = user.reward.add( _amount );
1449     }
1450 
1451     function _claim( address _addr ) internal {
1452         UserInfo storage user = userInfo[_addr];
1453         if( user.reward > 0 )
1454         {
1455             user.reward = 0;
1456         }
1457     }
1458 
1459 }
1460 
1461 contract LnRewardCalculatorTest is LnRewardCalculator{
1462     constructor( uint256 _rewardPerBlock, uint256 _startBlock ) public 
1463         LnRewardCalculator( _rewardPerBlock, _startBlock ) {
1464     }
1465 
1466     function deposit( uint256 curBlock, address _addr, uint256 _amount) public {
1467         _deposit( curBlock, _addr, _amount );
1468     }
1469 
1470     function withdraw( uint256 curBlock, address _addr, uint256 _amount) public {
1471         _withdraw( curBlock, _addr, _amount );
1472     }
1473     function calcReward( uint256 curBlock, address _user) public view returns (uint256) {
1474         return _calcReward( curBlock, _user);
1475     }
1476 
1477 }
1478 
1479 
1480 contract LnSimpleStaking is LnAdmin, Pausable, ILinearStaking, LnRewardCalculator {
1481     using SafeMath for uint256;
1482     using SafeDecimalMath for uint256;
1483 
1484     IERC20 public linaToken; // lina token proxy address
1485     LnLinearStakingStorage public stakingStorage;
1486     uint256 public mEndBlock;
1487     address public mOldStaking;
1488     uint256 public mOldAmount;
1489     uint256 public mWidthdrawRewardFromOldStaking;
1490 
1491     uint256 public claimRewardLockTime = 1620806400; // 2021-5-12
1492 
1493     address public mTargetAddress;
1494     uint256 public mTransLockTime;
1495 
1496     mapping (address => uint ) public mOldReward;
1497 
1498     constructor(
1499         address _admin,
1500         address _linaToken,
1501         address _storage, uint256 _rewardPerBlock, uint256 _startBlock, uint256 _endBlock ) 
1502             public LnAdmin(_admin) LnRewardCalculator(_rewardPerBlock, _startBlock ){
1503         linaToken = IERC20(_linaToken);
1504         stakingStorage = LnLinearStakingStorage(_storage);
1505         mEndBlock = _endBlock;
1506     }
1507 
1508     function setLinaToken(address _linaToken) external onlyAdmin {
1509         linaToken = IERC20(_linaToken);
1510     }
1511 
1512     function setPaused(bool _paused) external onlyAdmin {
1513         if (_paused) {
1514             _pause();
1515         } else {
1516             _unpause();
1517         }
1518     }
1519 
1520     //////////////////////////////////////////////////////
1521     event Staking(address indexed who, uint256 value, uint staketime);
1522     event CancelStaking(address indexed who, uint256 value);
1523     event Claim(address indexed who, uint256 rewardval, uint256 totalStaking);
1524     event TransLock(address target, uint256 time);
1525 
1526     uint256 public accountStakingListLimit = 50;
1527     uint256 public minStakingAmount = 1e18; // 1 token
1528     uint256 public constant PRECISION_UINT = 1e23;
1529 
1530     function setStakingListLimit(uint256 _limit) external onlyAdmin {
1531         accountStakingListLimit = _limit;
1532     }
1533 
1534     function setMinStakingAmount(uint256 _minStakingAmount) external onlyAdmin {
1535         minStakingAmount = _minStakingAmount;
1536     }
1537 
1538     function stakingBalanceOf(address account) external override view returns(uint256) {
1539         uint256 stakingBalance = super.amountOf(account).add( stakingStorage.stakingBalanceOf(account) );
1540         return stakingBalance;
1541     }
1542 
1543     function getStakesdataLength(address account) external view returns(uint256) {
1544         return stakingStorage.getStakesdataLength(account);
1545     }
1546     //--------------------------------------------------------
1547 
1548     function migrationsOldStaking( address contractAddr, uint amount, uint blockNb ) public onlyAdmin {
1549         super._deposit( blockNb, contractAddr, amount );
1550         mOldStaking = contractAddr;
1551         mOldAmount = amount;
1552     }
1553 
1554 
1555     function staking(uint256 amount) public whenNotPaused override returns (bool) {
1556         stakingStorage.requireInStakingPeriod();
1557 
1558         require(amount >= minStakingAmount, "Staking amount too small.");
1559         //require(stakingStorage.getStakesdataLength(msg.sender) < accountStakingListLimit, "Staking list out of limit.");
1560 
1561         linaToken.transferFrom(msg.sender, address(this), amount);
1562      
1563         uint256 blockNb = block.number;
1564         if (blockNb > mEndBlock) {
1565             blockNb = mEndBlock;
1566         }
1567         super._deposit( blockNb, msg.sender, amount );
1568 
1569         emit Staking(msg.sender, amount, block.timestamp);
1570 
1571         return true;
1572     }
1573 
1574     function _widthdrawFromOldStaking( address _addr, uint amount ) internal {
1575         uint256 blockNb = block.number;
1576         if (blockNb > mEndBlock) {
1577             blockNb = mEndBlock;
1578         }
1579         
1580         uint oldStakingAmount = super.amountOf( mOldStaking );
1581         super._withdraw( blockNb, mOldStaking, amount );
1582         // sub already withraw reward, then cal portion 
1583         uint reward = super.rewardOf( mOldStaking).sub( mWidthdrawRewardFromOldStaking, "_widthdrawFromOldStaking reward sub overflow" )
1584             .mul( amount ).mul(1e20).div( oldStakingAmount ).div(1e20);
1585         mWidthdrawRewardFromOldStaking = mWidthdrawRewardFromOldStaking.add( reward );
1586         mOldReward[ _addr ] = mOldReward[_addr].add( reward );
1587     }
1588 
1589     function _cancelStaking(address user, uint256 amount) internal {
1590         uint256 blockNb = block.number;
1591         if (blockNb > mEndBlock) {
1592             blockNb = mEndBlock;
1593         }
1594 
1595         uint256 returnAmount = amount;
1596         uint256 newAmount = super.amountOf(user);
1597         if (newAmount >= amount) {
1598             super._withdraw( blockNb, user, amount );
1599             amount = 0;
1600         } else {
1601             if (newAmount > 0) {
1602                 super._withdraw( blockNb, user, newAmount );
1603                 amount = amount.sub(newAmount, "_cancelStaking amount sub overflow");
1604             }
1605             
1606             for (uint256 i = stakingStorage.getStakesdataLength(user); i >= 1 ; i--) {
1607                 (uint256 stakingAmount, uint256 staketime) = stakingStorage.getStakesDataByIndex(user, i-1);
1608                 if (amount >= stakingAmount) {
1609                     amount = amount.sub(stakingAmount, "_cancelStaking amount sub overflow");
1610                     
1611                     stakingStorage.PopStakesData(user);
1612                     stakingStorage.SubWeeksTotal(staketime, stakingAmount);
1613                     _widthdrawFromOldStaking( user, stakingAmount );
1614 
1615                 } else {
1616                     stakingStorage.StakingDataSub(user, i-1, amount);
1617                     stakingStorage.SubWeeksTotal(staketime, amount);
1618                     _widthdrawFromOldStaking( user, amount );
1619 
1620                     amount = 0;
1621                 }
1622                 if (amount == 0) break;
1623             }
1624         }
1625 
1626         // cancel as many as possible, not fail, that waste gas
1627         //require(amount == 0, "Cancel amount too big then staked.");
1628         
1629         linaToken.transfer(msg.sender, returnAmount.sub(amount));
1630     }
1631 
1632     function cancelStaking(uint256 amount) public whenNotPaused override returns (bool) {
1633         //stakingStorage.requireInStakingPeriod();
1634 
1635         require(amount > 0, "Invalid amount.");
1636 
1637         _cancelStaking(msg.sender, amount);
1638 
1639         emit CancelStaking(msg.sender, amount);
1640 
1641         return true;
1642     }
1643 
1644     function getTotalReward( uint blockNb, address _user ) public view returns ( uint256 total ){
1645         if( blockNb > mEndBlock ){
1646             blockNb = mEndBlock;
1647         }
1648         
1649         // 这里奖励分成了三部分
1650         // 1,已经从旧奖池中cancel了的
1651         // 2,还在旧奖池中的
1652         // 3，在新奖池中的
1653         total = mOldReward[ _user ];
1654         uint iMyOldStaking = 0;
1655         for (uint256 i=0; i < stakingStorage.getStakesdataLength( _user ); i++) {
1656             (uint256 stakingAmount, ) = stakingStorage.getStakesDataByIndex( _user, i);
1657             iMyOldStaking = iMyOldStaking.add( stakingAmount );
1658         }
1659         if( iMyOldStaking > 0 ){
1660             uint oldStakingAmount = super.amountOf( mOldStaking );
1661             uint iReward2 = super._calcReward( blockNb, mOldStaking).sub( mWidthdrawRewardFromOldStaking, "getTotalReward iReward2 sub overflow" )
1662                 .mul( iMyOldStaking ).div( oldStakingAmount );
1663             total = total.add( iReward2 );
1664         }
1665 
1666         uint256 reward3 = super._calcReward( blockNb, _user );
1667         total = total.add( reward3 );
1668     }
1669 
1670 
1671     // claim reward
1672     // Note: 需要提前提前把奖励token转进来
1673     function claim() public whenNotPaused override returns (bool) {
1674         //stakingStorage.requireStakingEnd();
1675         require(block.timestamp > claimRewardLockTime, "Not time to claim reward");
1676 
1677         uint iMyOldStaking = stakingStorage.stakingBalanceOf( msg.sender );
1678         uint iAmount = super.amountOf( msg.sender );
1679         _cancelStaking( msg.sender, iMyOldStaking.add( iAmount ));
1680 
1681         uint iReward = getTotalReward( mEndBlock, msg.sender );
1682 
1683         _claim( msg.sender );
1684         mOldReward[ msg.sender ] = 0;
1685         linaToken.transfer(msg.sender, iReward );
1686 
1687         emit Claim(msg.sender, iReward, iMyOldStaking.add( iAmount ));
1688         return true;
1689     }
1690 
1691     function setRewardLockTime(uint256 newtime) public onlyAdmin {
1692         claimRewardLockTime = newtime;
1693     }
1694 
1695     function calcReward( uint256 curBlock, address _user) public view returns (uint256) {
1696         return _calcReward( curBlock, _user);
1697     }
1698 
1699     function setTransLock(address target, uint256 locktime) public onlyAdmin {
1700         require(locktime >= now + 2 days, "locktime need larger than cur time 2 days");
1701         mTargetAddress = target;
1702         mTransLockTime = locktime;
1703 
1704         emit TransLock(mTargetAddress, mTransLockTime);
1705     }
1706 
1707     function transTokens(uint256 amount) public onlyAdmin {
1708         require(mTransLockTime > 0, "mTransLockTime not set");
1709         require(now > mTransLockTime, "Pls wait to unlock time");
1710         linaToken.transfer(mTargetAddress, amount);
1711     }
1712 }