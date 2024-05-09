1 // SPDX-License-Identifier: Apache-2.0
2 pragma solidity 0.6.11;
3 pragma experimental ABIEncoderV2;
4 
5 
6 /**
7  * @dev Library for managing
8  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
9  * types.
10  *
11  * Sets have the following properties:
12  *
13  * - Elements are added, removed, and checked for existence in constant time
14  * (O(1)).
15  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
16  *
17  * ```
18  * contract Example {
19  *     // Add the library methods
20  *     using EnumerableSet for EnumerableSet.AddressSet;
21  *
22  *     // Declare a set state variable
23  *     EnumerableSet.AddressSet private mySet;
24  * }
25  * ```
26  *
27  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
28  * (`UintSet`) are supported.
29  */
30 library EnumerableSet {
31     // To implement this library for multiple types with as little code
32     // repetition as possible, we write it in terms of a generic Set type with
33     // bytes32 values.
34     // The Set implementation uses private functions, and user-facing
35     // implementations (such as AddressSet) are just wrappers around the
36     // underlying Set.
37     // This means that we can only create new EnumerableSets for types that fit
38     // in bytes32.
39 
40     struct Set {
41         // Storage of set values
42         bytes32[] _values;
43 
44         // Position of the value in the `values` array, plus 1 because index 0
45         // means a value is not in the set.
46         mapping (bytes32 => uint256) _indexes;
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
77         if (valueIndex != 0) { // Equivalent to contains(set, value)
78             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
79             // the array, and then remove the last element (sometimes called as 'swap and pop').
80             // This modifies the order of the array, as noted in {at}.
81 
82             uint256 toDeleteIndex = valueIndex - 1;
83             uint256 lastIndex = set._values.length - 1;
84 
85             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
86             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
87 
88             bytes32 lastvalue = set._values[lastIndex];
89 
90             // Move the last value to the index where the value to delete is
91             set._values[toDeleteIndex] = lastvalue;
92             // Update the index for the moved value
93             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
94 
95             // Delete the slot where the moved value was stored
96             set._values.pop();
97 
98             // Delete the index for the deleted slot
99             delete set._indexes[value];
100 
101             return true;
102         } else {
103             return false;
104         }
105     }
106 
107     /**
108      * @dev Returns true if the value is in the set. O(1).
109      */
110     function _contains(Set storage set, bytes32 value) private view returns (bool) {
111         return set._indexes[value] != 0;
112     }
113 
114     /**
115      * @dev Returns the number of values on the set. O(1).
116      */
117     function _length(Set storage set) private view returns (uint256) {
118         return set._values.length;
119     }
120 
121    /**
122     * @dev Returns the value stored at position `index` in the set. O(1).
123     *
124     * Note that there are no guarantees on the ordering of values inside the
125     * array, and it may change when more values are added or removed.
126     *
127     * Requirements:
128     *
129     * - `index` must be strictly less than {length}.
130     */
131     function _at(Set storage set, uint256 index) private view returns (bytes32) {
132         require(set._values.length > index, "EnumerableSet: index out of bounds");
133         return set._values[index];
134     }
135 
136     // AddressSet
137 
138     struct AddressSet {
139         Set _inner;
140     }
141 
142     /**
143      * @dev Add a value to a set. O(1).
144      *
145      * Returns true if the value was added to the set, that is if it was not
146      * already present.
147      */
148     function add(AddressSet storage set, address value) internal returns (bool) {
149         return _add(set._inner, bytes32(uint256(value)));
150     }
151 
152     /**
153      * @dev Removes a value from a set. O(1).
154      *
155      * Returns true if the value was removed from the set, that is if it was
156      * present.
157      */
158     function remove(AddressSet storage set, address value) internal returns (bool) {
159         return _remove(set._inner, bytes32(uint256(value)));
160     }
161 
162     /**
163      * @dev Returns true if the value is in the set. O(1).
164      */
165     function contains(AddressSet storage set, address value) internal view returns (bool) {
166         return _contains(set._inner, bytes32(uint256(value)));
167     }
168 
169     /**
170      * @dev Returns the number of values in the set. O(1).
171      */
172     function length(AddressSet storage set) internal view returns (uint256) {
173         return _length(set._inner);
174     }
175 
176    /**
177     * @dev Returns the value stored at position `index` in the set. O(1).
178     *
179     * Note that there are no guarantees on the ordering of values inside the
180     * array, and it may change when more values are added or removed.
181     *
182     * Requirements:
183     *
184     * - `index` must be strictly less than {length}.
185     */
186     function at(AddressSet storage set, uint256 index) internal view returns (address) {
187         return address(uint256(_at(set._inner, index)));
188     }
189 
190 
191     // UintSet
192 
193     struct UintSet {
194         Set _inner;
195     }
196 
197     /**
198      * @dev Add a value to a set. O(1).
199      *
200      * Returns true if the value was added to the set, that is if it was not
201      * already present.
202      */
203     function add(UintSet storage set, uint256 value) internal returns (bool) {
204         return _add(set._inner, bytes32(value));
205     }
206 
207     /**
208      * @dev Removes a value from a set. O(1).
209      *
210      * Returns true if the value was removed from the set, that is if it was
211      * present.
212      */
213     function remove(UintSet storage set, uint256 value) internal returns (bool) {
214         return _remove(set._inner, bytes32(value));
215     }
216 
217     /**
218      * @dev Returns true if the value is in the set. O(1).
219      */
220     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
221         return _contains(set._inner, bytes32(value));
222     }
223 
224     /**
225      * @dev Returns the number of values on the set. O(1).
226      */
227     function length(UintSet storage set) internal view returns (uint256) {
228         return _length(set._inner);
229     }
230 
231    /**
232     * @dev Returns the value stored at position `index` in the set. O(1).
233     *
234     * Note that there are no guarantees on the ordering of values inside the
235     * array, and it may change when more values are added or removed.
236     *
237     * Requirements:
238     *
239     * - `index` must be strictly less than {length}.
240     */
241     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
242         return uint256(_at(set._inner, index));
243     }
244 }
245 
246 
247 
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 
388 /*
389  * @dev Provides information about the current execution context, including the
390  * sender of the transaction and its data. While these are generally available
391  * via msg.sender and msg.data, they should not be accessed in such a direct
392  * manner, since when dealing with GSN meta-transactions the account sending and
393  * paying for execution may not be the actual sender (as far as an application
394  * is concerned).
395  *
396  * This contract is only required for intermediate, library-like contracts.
397  */
398 abstract contract Context {
399     function _msgSender() internal view virtual returns (address payable) {
400         return msg.sender;
401     }
402 
403     function _msgData() internal view virtual returns (bytes memory) {
404         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
405         return msg.data;
406     }
407 }
408 
409 
410 /**
411  * @dev Contract module that allows children to implement role-based access
412  * control mechanisms.
413  *
414  * Roles are referred to by their `bytes32` identifier. These should be exposed
415  * in the external API and be unique. The best way to achieve this is by
416  * using `public constant` hash digests:
417  *
418  * ```
419  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
420  * ```
421  *
422  * Roles can be used to represent a set of permissions. To restrict access to a
423  * function call, use {hasRole}:
424  *
425  * ```
426  * function foo() public {
427  *     require(hasRole(MY_ROLE, msg.sender));
428  *     ...
429  * }
430  * ```
431  *
432  * Roles can be granted and revoked dynamically via the {grantRole} and
433  * {revokeRole} functions. Each role has an associated admin role, and only
434  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
435  *
436  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
437  * that only accounts with this role will be able to grant or revoke other
438  * roles. More complex role relationships can be created by using
439  * {_setRoleAdmin}.
440  *
441  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
442  * grant and revoke this role. Extra precautions should be taken to secure
443  * accounts that have been granted it.
444  */
445 abstract contract AccessControl is Context {
446     using EnumerableSet for EnumerableSet.AddressSet;
447     using Address for address;
448 
449     struct RoleData {
450         EnumerableSet.AddressSet members;
451         bytes32 adminRole;
452     }
453 
454     mapping (bytes32 => RoleData) private _roles;
455 
456     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
457 
458     /**
459      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
460      *
461      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
462      * {RoleAdminChanged} not being emitted signaling this.
463      *
464      * _Available since v3.1._
465      */
466     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
467 
468     /**
469      * @dev Emitted when `account` is granted `role`.
470      *
471      * `sender` is the account that originated the contract call, an admin role
472      * bearer except when using {_setupRole}.
473      */
474     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
475 
476     /**
477      * @dev Emitted when `account` is revoked `role`.
478      *
479      * `sender` is the account that originated the contract call:
480      *   - if using `revokeRole`, it is the admin role bearer
481      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
482      */
483     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
484 
485     /**
486      * @dev Returns `true` if `account` has been granted `role`.
487      */
488     function hasRole(bytes32 role, address account) public view returns (bool) {
489         return _roles[role].members.contains(account);
490     }
491 
492     /**
493      * @dev Returns the number of accounts that have `role`. Can be used
494      * together with {getRoleMember} to enumerate all bearers of a role.
495      */
496     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
497         return _roles[role].members.length();
498     }
499 
500     /**
501      * @dev Returns one of the accounts that have `role`. `index` must be a
502      * value between 0 and {getRoleMemberCount}, non-inclusive.
503      *
504      * Role bearers are not sorted in any particular way, and their ordering may
505      * change at any point.
506      *
507      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
508      * you perform all queries on the same block. See the following
509      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
510      * for more information.
511      */
512     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
513         return _roles[role].members.at(index);
514     }
515 
516     /**
517      * @dev Returns the admin role that controls `role`. See {grantRole} and
518      * {revokeRole}.
519      *
520      * To change a role's admin, use {_setRoleAdmin}.
521      */
522     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
523         return _roles[role].adminRole;
524     }
525 
526     /**
527      * @dev Grants `role` to `account`.
528      *
529      * If `account` had not been already granted `role`, emits a {RoleGranted}
530      * event.
531      *
532      * Requirements:
533      *
534      * - the caller must have ``role``'s admin role.
535      */
536     function grantRole(bytes32 role, address account) public virtual {
537         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
538 
539         _grantRole(role, account);
540     }
541 
542     /**
543      * @dev Revokes `role` from `account`.
544      *
545      * If `account` had been granted `role`, emits a {RoleRevoked} event.
546      *
547      * Requirements:
548      *
549      * - the caller must have ``role``'s admin role.
550      */
551     function revokeRole(bytes32 role, address account) public virtual {
552         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
553 
554         _revokeRole(role, account);
555     }
556 
557     /**
558      * @dev Revokes `role` from the calling account.
559      *
560      * Roles are often managed via {grantRole} and {revokeRole}: this function's
561      * purpose is to provide a mechanism for accounts to lose their privileges
562      * if they are compromised (such as when a trusted device is misplaced).
563      *
564      * If the calling account had been granted `role`, emits a {RoleRevoked}
565      * event.
566      *
567      * Requirements:
568      *
569      * - the caller must be `account`.
570      */
571     function renounceRole(bytes32 role, address account) public virtual {
572         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
573 
574         _revokeRole(role, account);
575     }
576 
577     /**
578      * @dev Grants `role` to `account`.
579      *
580      * If `account` had not been already granted `role`, emits a {RoleGranted}
581      * event. Note that unlike {grantRole}, this function doesn't perform any
582      * checks on the calling account.
583      *
584      * [WARNING]
585      * ====
586      * This function should only be called from the constructor when setting
587      * up the initial roles for the system.
588      *
589      * Using this function in any other way is effectively circumventing the admin
590      * system imposed by {AccessControl}.
591      * ====
592      */
593     function _setupRole(bytes32 role, address account) internal virtual {
594         _grantRole(role, account);
595     }
596 
597     /**
598      * @dev Sets `adminRole` as ``role``'s admin role.
599      *
600      * Emits a {RoleAdminChanged} event.
601      */
602     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
603         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
604         _roles[role].adminRole = adminRole;
605     }
606 
607     function _grantRole(bytes32 role, address account) private {
608         if (_roles[role].members.add(account)) {
609             emit RoleGranted(role, account, _msgSender());
610         }
611     }
612 
613     function _revokeRole(bytes32 role, address account) private {
614         if (_roles[role].members.remove(account)) {
615             emit RoleRevoked(role, account, _msgSender());
616         }
617     }
618 }
619 
620 
621 interface IStdReference {
622     /// A structure returned whenever someone requests for standard reference data.
623     struct ReferenceData {
624         uint256 rate; // base/quote exchange rate, multiplied by 1e18.
625         uint256 lastUpdatedBase; // UNIX epoch of the last time when base price gets updated.
626         uint256 lastUpdatedQuote; // UNIX epoch of the last time when quote price gets updated.
627     }
628 
629     /// Returns the price data for the given base/quote pair. Revert if not available.
630     function getReferenceData(string memory _base, string memory _quote)
631         external
632         view
633         returns (ReferenceData memory);
634 
635     /// Similar to getReferenceData, but with multiple base/quote pairs at once.
636     function getReferenceDataBulk(string[] memory _bases, string[] memory _quotes)
637         external
638         view
639         returns (ReferenceData[] memory);
640 }
641 
642 abstract contract StdReferenceBase is IStdReference {
643     function getReferenceData(string memory _base, string memory _quote)
644         public
645         virtual
646         override
647         view
648         returns (ReferenceData memory);
649 
650     function getReferenceDataBulk(string[] memory _bases, string[] memory _quotes)
651         public
652         override
653         view
654         returns (ReferenceData[] memory)
655     {
656         require(_bases.length == _quotes.length, "BAD_INPUT_LENGTH");
657         uint256 len = _bases.length;
658         ReferenceData[] memory results = new ReferenceData[](len);
659         for (uint256 idx = 0; idx < len; idx++) {
660             results[idx] = getReferenceData(_bases[idx], _quotes[idx]);
661         }
662         return results;
663     }
664 }
665 
666 /// @title BandChain StdReferenceBasic
667 /// @author Band Protocol Team
668 contract StdReferenceBasic is AccessControl, StdReferenceBase {
669     event RefDataUpdate(
670         string symbol,
671         uint64 rate,
672         uint64 resolveTime,
673         uint64 requestId
674     );
675 
676     struct RefData {
677         uint64 rate; // USD-rate, multiplied by 1e9.
678         uint64 resolveTime; // UNIX epoch when data is last resolved.
679         uint64 requestId; // BandChain request identifier for this data.
680     }
681 
682     mapping(string => RefData) public refs; // Mapping from symbol to ref data.
683     bytes32 public constant RELAYER_ROLE = keccak256("RELAYER_ROLE");
684 
685     constructor() public {
686         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
687         _setupRole(RELAYER_ROLE, msg.sender);
688     }
689 
690     function relay(
691         string[] memory _symbols,
692         uint64[] memory _rates,
693         uint64[] memory _resolveTimes,
694         uint64[] memory _requestIds
695     ) external {
696         require(hasRole(RELAYER_ROLE, msg.sender), "NOT_A_RELAYER");
697         uint256 len = _symbols.length;
698         require(_rates.length == len, "BAD_RATES_LENGTH");
699         require(_resolveTimes.length == len, "BAD_RESOLVE_TIMES_LENGTH");
700         require(_requestIds.length == len, "BAD_REQUEST_IDS_LENGTH");
701         for (uint256 idx = 0; idx < len; idx++) {
702             refs[_symbols[idx]] = RefData({
703                 rate: _rates[idx],
704                 resolveTime: _resolveTimes[idx],
705                 requestId: _requestIds[idx]
706             });
707             emit RefDataUpdate(
708                 _symbols[idx],
709                 _rates[idx],
710                 _resolveTimes[idx],
711                 _requestIds[idx]
712             );
713         }
714     }
715 
716     function getReferenceData(string memory _base, string memory _quote)
717         public
718         override
719         view
720         returns (ReferenceData memory)
721     {
722         (uint256 baseRate, uint256 baseLastUpdate) = _getRefData(_base);
723         (uint256 quoteRate, uint256 quoteLastUpdate) = _getRefData(_quote);
724         return
725             ReferenceData({
726                 rate: (baseRate * 1e18) / quoteRate,
727                 lastUpdatedBase: baseLastUpdate,
728                 lastUpdatedQuote: quoteLastUpdate
729             });
730     }
731 
732     function _getRefData(string memory _symbol)
733         internal
734         view
735         returns (uint256 rate, uint256 lastUpdate)
736     {
737         if (keccak256(bytes(_symbol)) == keccak256(bytes("USD"))) {
738             return (1e9, now);
739         }
740         RefData storage refData = refs[_symbol];
741         require(refData.resolveTime > 0, "REF_DATA_NOT_AVAILABLE");
742         return (uint256(refData.rate), uint256(refData.resolveTime));
743     }
744 }