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
26 /**
27  * @dev Library for managing
28  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
29  * types.
30  *
31  * Sets have the following properties:
32  *
33  * - Elements are added, removed, and checked for existence in constant time
34  * (O(1)).
35  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
36  *
37  * ```
38  * contract Example {
39  *     // Add the library methods
40  *     using EnumerableSet for EnumerableSet.AddressSet;
41  *
42  *     // Declare a set state variable
43  *     EnumerableSet.AddressSet private mySet;
44  * }
45  * ```
46  *
47  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
48  * (`UintSet`) are supported.
49  */
50 library EnumerableSet {
51     // To implement this library for multiple types with as little code
52     // repetition as possible, we write it in terms of a generic Set type with
53     // bytes32 values.
54     // The Set implementation uses private functions, and user-facing
55     // implementations (such as AddressSet) are just wrappers around the
56     // underlying Set.
57     // This means that we can only create new EnumerableSets for types that fit
58     // in bytes32.
59 
60     struct Set {
61         // Storage of set values
62         bytes32[] _values;
63 
64         // Position of the value in the `values` array, plus 1 because index 0
65         // means a value is not in the set.
66         mapping (bytes32 => uint256) _indexes;
67     }
68 
69     /**
70      * @dev Add a value to a set. O(1).
71      *
72      * Returns true if the value was added to the set, that is if it was not
73      * already present.
74      */
75     function _add(Set storage set, bytes32 value) private returns (bool) {
76         if (!_contains(set, value)) {
77             set._values.push(value);
78             // The value is stored at length-1, but we add 1 to all indexes
79             // and use 0 as a sentinel value
80             set._indexes[value] = set._values.length;
81             return true;
82         } else {
83             return false;
84         }
85     }
86 
87     /**
88      * @dev Removes a value from a set. O(1).
89      *
90      * Returns true if the value was removed from the set, that is if it was
91      * present.
92      */
93     function _remove(Set storage set, bytes32 value) private returns (bool) {
94         // We read and store the value's index to prevent multiple reads from the same storage slot
95         uint256 valueIndex = set._indexes[value];
96 
97         if (valueIndex != 0) { // Equivalent to contains(set, value)
98             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
99             // the array, and then remove the last element (sometimes called as 'swap and pop').
100             // This modifies the order of the array, as noted in {at}.
101 
102             uint256 toDeleteIndex = valueIndex - 1;
103             uint256 lastIndex = set._values.length - 1;
104 
105             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
106             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
107 
108             bytes32 lastvalue = set._values[lastIndex];
109 
110             // Move the last value to the index where the value to delete is
111             set._values[toDeleteIndex] = lastvalue;
112             // Update the index for the moved value
113             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
114 
115             // Delete the slot where the moved value was stored
116             set._values.pop();
117 
118             // Delete the index for the deleted slot
119             delete set._indexes[value];
120 
121             return true;
122         } else {
123             return false;
124         }
125     }
126 
127     /**
128      * @dev Returns true if the value is in the set. O(1).
129      */
130     function _contains(Set storage set, bytes32 value) private view returns (bool) {
131         return set._indexes[value] != 0;
132     }
133 
134     /**
135      * @dev Returns the number of values on the set. O(1).
136      */
137     function _length(Set storage set) private view returns (uint256) {
138         return set._values.length;
139     }
140 
141    /**
142     * @dev Returns the value stored at position `index` in the set. O(1).
143     *
144     * Note that there are no guarantees on the ordering of values inside the
145     * array, and it may change when more values are added or removed.
146     *
147     * Requirements:
148     *
149     * - `index` must be strictly less than {length}.
150     */
151     function _at(Set storage set, uint256 index) private view returns (bytes32) {
152         require(set._values.length > index, "EnumerableSet: index out of bounds");
153         return set._values[index];
154     }
155 
156     // AddressSet
157 
158     struct AddressSet {
159         Set _inner;
160     }
161 
162     /**
163      * @dev Add a value to a set. O(1).
164      *
165      * Returns true if the value was added to the set, that is if it was not
166      * already present.
167      */
168     function add(AddressSet storage set, address value) internal returns (bool) {
169         return _add(set._inner, bytes32(uint256(value)));
170     }
171 
172     /**
173      * @dev Removes a value from a set. O(1).
174      *
175      * Returns true if the value was removed from the set, that is if it was
176      * present.
177      */
178     function remove(AddressSet storage set, address value) internal returns (bool) {
179         return _remove(set._inner, bytes32(uint256(value)));
180     }
181 
182     /**
183      * @dev Returns true if the value is in the set. O(1).
184      */
185     function contains(AddressSet storage set, address value) internal view returns (bool) {
186         return _contains(set._inner, bytes32(uint256(value)));
187     }
188 
189     /**
190      * @dev Returns the number of values in the set. O(1).
191      */
192     function length(AddressSet storage set) internal view returns (uint256) {
193         return _length(set._inner);
194     }
195 
196    /**
197     * @dev Returns the value stored at position `index` in the set. O(1).
198     *
199     * Note that there are no guarantees on the ordering of values inside the
200     * array, and it may change when more values are added or removed.
201     *
202     * Requirements:
203     *
204     * - `index` must be strictly less than {length}.
205     */
206     function at(AddressSet storage set, uint256 index) internal view returns (address) {
207         return address(uint256(_at(set._inner, index)));
208     }
209 
210 
211     // UintSet
212 
213     struct UintSet {
214         Set _inner;
215     }
216 
217     /**
218      * @dev Add a value to a set. O(1).
219      *
220      * Returns true if the value was added to the set, that is if it was not
221      * already present.
222      */
223     function add(UintSet storage set, uint256 value) internal returns (bool) {
224         return _add(set._inner, bytes32(value));
225     }
226 
227     /**
228      * @dev Removes a value from a set. O(1).
229      *
230      * Returns true if the value was removed from the set, that is if it was
231      * present.
232      */
233     function remove(UintSet storage set, uint256 value) internal returns (bool) {
234         return _remove(set._inner, bytes32(value));
235     }
236 
237     /**
238      * @dev Returns true if the value is in the set. O(1).
239      */
240     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
241         return _contains(set._inner, bytes32(value));
242     }
243 
244     /**
245      * @dev Returns the number of values on the set. O(1).
246      */
247     function length(UintSet storage set) internal view returns (uint256) {
248         return _length(set._inner);
249     }
250 
251    /**
252     * @dev Returns the value stored at position `index` in the set. O(1).
253     *
254     * Note that there are no guarantees on the ordering of values inside the
255     * array, and it may change when more values are added or removed.
256     *
257     * Requirements:
258     *
259     * - `index` must be strictly less than {length}.
260     */
261     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
262         return uint256(_at(set._inner, index));
263     }
264 }
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
289         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
290         // for accounts without code, i.e. `keccak256('')`
291         bytes32 codehash;
292         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { codehash := extcodehash(account) }
295         return (codehash != accountHash && codehash != 0x0);
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341       return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return _functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 
405 
406 /**
407  * @dev Contract module that allows children to implement role-based access
408  * control mechanisms.
409  *
410  * Roles are referred to by their `bytes32` identifier. These should be exposed
411  * in the external API and be unique. The best way to achieve this is by
412  * using `public constant` hash digests:
413  *
414  * ```
415  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
416  * ```
417  *
418  * Roles can be used to represent a set of permissions. To restrict access to a
419  * function call, use {hasRole}:
420  *
421  * ```
422  * function foo() public {
423  *     require(hasRole(MY_ROLE, msg.sender));
424  *     ...
425  * }
426  * ```
427  *
428  * Roles can be granted and revoked dynamically via the {grantRole} and
429  * {revokeRole} functions. Each role has an associated admin role, and only
430  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
431  *
432  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
433  * that only accounts with this role will be able to grant or revoke other
434  * roles. More complex role relationships can be created by using
435  * {_setRoleAdmin}.
436  *
437  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
438  * grant and revoke this role. Extra precautions should be taken to secure
439  * accounts that have been granted it.
440  */
441 abstract contract AccessControl is Context {
442     using EnumerableSet for EnumerableSet.AddressSet;
443     using Address for address;
444 
445     struct RoleData {
446         EnumerableSet.AddressSet members;
447         bytes32 adminRole;
448     }
449 
450     mapping (bytes32 => RoleData) private _roles;
451 
452     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
453 
454     /**
455      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
456      *
457      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
458      * {RoleAdminChanged} not being emitted signaling this.
459      *
460      * _Available since v3.1._
461      */
462     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
463 
464     /**
465      * @dev Emitted when `account` is granted `role`.
466      *
467      * `sender` is the account that originated the contract call, an admin role
468      * bearer except when using {_setupRole}.
469      */
470     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
471 
472     /**
473      * @dev Emitted when `account` is revoked `role`.
474      *
475      * `sender` is the account that originated the contract call:
476      *   - if using `revokeRole`, it is the admin role bearer
477      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
478      */
479     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
480 
481     /**
482      * @dev Returns `true` if `account` has been granted `role`.
483      */
484     function hasRole(bytes32 role, address account) public view returns (bool) {
485         return _roles[role].members.contains(account);
486     }
487 
488     /**
489      * @dev Returns the number of accounts that have `role`. Can be used
490      * together with {getRoleMember} to enumerate all bearers of a role.
491      */
492     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
493         return _roles[role].members.length();
494     }
495 
496     /**
497      * @dev Returns one of the accounts that have `role`. `index` must be a
498      * value between 0 and {getRoleMemberCount}, non-inclusive.
499      *
500      * Role bearers are not sorted in any particular way, and their ordering may
501      * change at any point.
502      *
503      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
504      * you perform all queries on the same block. See the following
505      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
506      * for more information.
507      */
508     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
509         return _roles[role].members.at(index);
510     }
511 
512     /**
513      * @dev Returns the admin role that controls `role`. See {grantRole} and
514      * {revokeRole}.
515      *
516      * To change a role's admin, use {_setRoleAdmin}.
517      */
518     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
519         return _roles[role].adminRole;
520     }
521 
522     /**
523      * @dev Grants `role` to `account`.
524      *
525      * If `account` had not been already granted `role`, emits a {RoleGranted}
526      * event.
527      *
528      * Requirements:
529      *
530      * - the caller must have ``role``'s admin role.
531      */
532     function grantRole(bytes32 role, address account) public virtual {
533         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
534 
535         _grantRole(role, account);
536     }
537 
538     /**
539      * @dev Revokes `role` from `account`.
540      *
541      * If `account` had been granted `role`, emits a {RoleRevoked} event.
542      *
543      * Requirements:
544      *
545      * - the caller must have ``role``'s admin role.
546      */
547     function revokeRole(bytes32 role, address account) public virtual {
548         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
549 
550         _revokeRole(role, account);
551     }
552 
553     /**
554      * @dev Revokes `role` from the calling account.
555      *
556      * Roles are often managed via {grantRole} and {revokeRole}: this function's
557      * purpose is to provide a mechanism for accounts to lose their privileges
558      * if they are compromised (such as when a trusted device is misplaced).
559      *
560      * If the calling account had been granted `role`, emits a {RoleRevoked}
561      * event.
562      *
563      * Requirements:
564      *
565      * - the caller must be `account`.
566      */
567     function renounceRole(bytes32 role, address account) public virtual {
568         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
569 
570         _revokeRole(role, account);
571     }
572 
573     /**
574      * @dev Grants `role` to `account`.
575      *
576      * If `account` had not been already granted `role`, emits a {RoleGranted}
577      * event. Note that unlike {grantRole}, this function doesn't perform any
578      * checks on the calling account.
579      *
580      * [WARNING]
581      * ====
582      * This function should only be called from the constructor when setting
583      * up the initial roles for the system.
584      *
585      * Using this function in any other way is effectively circumventing the admin
586      * system imposed by {AccessControl}.
587      * ====
588      */
589     function _setupRole(bytes32 role, address account) internal virtual {
590         _grantRole(role, account);
591     }
592 
593     /**
594      * @dev Sets `adminRole` as ``role``'s admin role.
595      *
596      * Emits a {RoleAdminChanged} event.
597      */
598     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
599         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
600         _roles[role].adminRole = adminRole;
601     }
602 
603     function _grantRole(bytes32 role, address account) private {
604         if (_roles[role].members.add(account)) {
605             emit RoleGranted(role, account, _msgSender());
606         }
607     }
608 
609     function _revokeRole(bytes32 role, address account) private {
610         if (_roles[role].members.remove(account)) {
611             emit RoleRevoked(role, account, _msgSender());
612         }
613     }
614 }
615 
616 /**
617  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
618  *
619  * These functions can be used to verify that a message was signed by the holder
620  * of the private keys of a given address.
621  */
622 library ECDSA {
623     /**
624      * @dev Returns the address that signed a hashed message (`hash`) with
625      * `signature`. This address can then be used for verification purposes.
626      *
627      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
628      * this function rejects them by requiring the `s` value to be in the lower
629      * half order, and the `v` value to be either 27 or 28.
630      *
631      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
632      * verification to be secure: it is possible to craft signatures that
633      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
634      * this is by receiving a hash of the original message (which may otherwise
635      * be too long), and then calling {toEthSignedMessageHash} on it.
636      */
637     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
638         // Check the signature length
639         if (signature.length != 65) {
640             revert("ECDSA: invalid signature length");
641         }
642 
643         // Divide the signature in r, s and v variables
644         bytes32 r;
645         bytes32 s;
646         uint8 v;
647 
648         // ecrecover takes the signature parameters, and the only way to get them
649         // currently is to use assembly.
650         // solhint-disable-next-line no-inline-assembly
651         assembly {
652             r := mload(add(signature, 0x20))
653             s := mload(add(signature, 0x40))
654             v := byte(0, mload(add(signature, 0x60)))
655         }
656 
657         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
658         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
659         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
660         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
661         //
662         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
663         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
664         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
665         // these malleable signatures as well.
666         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
667             revert("ECDSA: invalid signature 's' value");
668         }
669 
670         if (v != 27 && v != 28) {
671             revert("ECDSA: invalid signature 'v' value");
672         }
673 
674         // If the signature is valid (and not malleable), return the signer address
675         address signer = ecrecover(hash, v, r, s);
676         require(signer != address(0), "ECDSA: invalid signature");
677 
678         return signer;
679     }
680 
681     /**
682      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
683      * replicates the behavior of the
684      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
685      * JSON-RPC method.
686      *
687      * See {recover}.
688      */
689     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
690         // 32 is the length in bytes of hash,
691         // enforced by the type signature above
692         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
693     }
694 }
695 
696 /**
697  * @dev Interface of the ERC20 standard as defined in the EIP.
698  */
699 interface IERC20 {
700     /**
701      * @dev Returns the amount of tokens in existence.
702      */
703     function totalSupply() external view returns (uint256);
704 
705     /**
706      * @dev Returns the amount of tokens owned by `account`.
707      */
708     function balanceOf(address account) external view returns (uint256);
709 
710     /**
711      * @dev Moves `amount` tokens from the caller's account to `recipient`.
712      *
713      * Returns a boolean value indicating whether the operation succeeded.
714      *
715      * Emits a {Transfer} event.
716      */
717     function transfer(address recipient, uint256 amount) external returns (bool);
718 
719     /**
720      * @dev Returns the remaining number of tokens that `spender` will be
721      * allowed to spend on behalf of `owner` through {transferFrom}. This is
722      * zero by default.
723      *
724      * This value changes when {approve} or {transferFrom} are called.
725      */
726     function allowance(address owner, address spender) external view returns (uint256);
727 
728     /**
729      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
730      *
731      * Returns a boolean value indicating whether the operation succeeded.
732      *
733      * IMPORTANT: Beware that changing an allowance with this method brings the risk
734      * that someone may use both the old and the new allowance by unfortunate
735      * transaction ordering. One possible solution to mitigate this race
736      * condition is to first reduce the spender's allowance to 0 and set the
737      * desired value afterwards:
738      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
739      *
740      * Emits an {Approval} event.
741      */
742     function approve(address spender, uint256 amount) external returns (bool);
743 
744     /**
745      * @dev Moves `amount` tokens from `sender` to `recipient` using the
746      * allowance mechanism. `amount` is then deducted from the caller's
747      * allowance.
748      *
749      * Returns a boolean value indicating whether the operation succeeded.
750      *
751      * Emits a {Transfer} event.
752      */
753     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
754 
755     /**
756      * @dev Emitted when `value` tokens are moved from one account (`from`) to
757      * another (`to`).
758      *
759      * Note that `value` may be zero.
760      */
761     event Transfer(address indexed from, address indexed to, uint256 value);
762 
763     /**
764      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
765      * a call to {approve}. `value` is the new allowance.
766      */
767     event Approval(address indexed owner, address indexed spender, uint256 value);
768 }
769 
770 /**
771  * @dev Wrappers over Solidity's arithmetic operations with added overflow
772  * checks.
773  *
774  * Arithmetic operations in Solidity wrap on overflow. This can easily result
775  * in bugs, because programmers usually assume that an overflow raises an
776  * error, which is the standard behavior in high level programming languages.
777  * `SafeMath` restores this intuition by reverting the transaction when an
778  * operation overflows.
779  *
780  * Using this library instead of the unchecked operations eliminates an entire
781  * class of bugs, so it's recommended to use it always.
782  */
783 library SafeMath {
784     /**
785      * @dev Returns the addition of two unsigned integers, reverting on
786      * overflow.
787      *
788      * Counterpart to Solidity's `+` operator.
789      *
790      * Requirements:
791      *
792      * - Addition cannot overflow.
793      */
794     function add(uint256 a, uint256 b) internal pure returns (uint256) {
795         uint256 c = a + b;
796         require(c >= a, "SafeMath: addition overflow");
797 
798         return c;
799     }
800 
801     /**
802      * @dev Returns the subtraction of two unsigned integers, reverting on
803      * overflow (when the result is negative).
804      *
805      * Counterpart to Solidity's `-` operator.
806      *
807      * Requirements:
808      *
809      * - Subtraction cannot overflow.
810      */
811     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
812         return sub(a, b, "SafeMath: subtraction overflow");
813     }
814 
815     /**
816      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
817      * overflow (when the result is negative).
818      *
819      * Counterpart to Solidity's `-` operator.
820      *
821      * Requirements:
822      *
823      * - Subtraction cannot overflow.
824      */
825     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
826         require(b <= a, errorMessage);
827         uint256 c = a - b;
828 
829         return c;
830     }
831 
832     /**
833      * @dev Returns the multiplication of two unsigned integers, reverting on
834      * overflow.
835      *
836      * Counterpart to Solidity's `*` operator.
837      *
838      * Requirements:
839      *
840      * - Multiplication cannot overflow.
841      */
842     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
843         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
844         // benefit is lost if 'b' is also tested.
845         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
846         if (a == 0) {
847             return 0;
848         }
849 
850         uint256 c = a * b;
851         require(c / a == b, "SafeMath: multiplication overflow");
852 
853         return c;
854     }
855 
856     /**
857      * @dev Returns the integer division of two unsigned integers. Reverts on
858      * division by zero. The result is rounded towards zero.
859      *
860      * Counterpart to Solidity's `/` operator. Note: this function uses a
861      * `revert` opcode (which leaves remaining gas untouched) while Solidity
862      * uses an invalid opcode to revert (consuming all remaining gas).
863      *
864      * Requirements:
865      *
866      * - The divisor cannot be zero.
867      */
868     function div(uint256 a, uint256 b) internal pure returns (uint256) {
869         return div(a, b, "SafeMath: division by zero");
870     }
871 
872     /**
873      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
874      * division by zero. The result is rounded towards zero.
875      *
876      * Counterpart to Solidity's `/` operator. Note: this function uses a
877      * `revert` opcode (which leaves remaining gas untouched) while Solidity
878      * uses an invalid opcode to revert (consuming all remaining gas).
879      *
880      * Requirements:
881      *
882      * - The divisor cannot be zero.
883      */
884     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
885         require(b > 0, errorMessage);
886         uint256 c = a / b;
887         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
888 
889         return c;
890     }
891 
892     /**
893      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
894      * Reverts when dividing by zero.
895      *
896      * Counterpart to Solidity's `%` operator. This function uses a `revert`
897      * opcode (which leaves remaining gas untouched) while Solidity uses an
898      * invalid opcode to revert (consuming all remaining gas).
899      *
900      * Requirements:
901      *
902      * - The divisor cannot be zero.
903      */
904     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
905         return mod(a, b, "SafeMath: modulo by zero");
906     }
907 
908     /**
909      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
910      * Reverts with custom message when dividing by zero.
911      *
912      * Counterpart to Solidity's `%` operator. This function uses a `revert`
913      * opcode (which leaves remaining gas untouched) while Solidity uses an
914      * invalid opcode to revert (consuming all remaining gas).
915      *
916      * Requirements:
917      *
918      * - The divisor cannot be zero.
919      */
920     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
921         require(b != 0, errorMessage);
922         return a % b;
923     }
924 }
925 
926 
927 
928 /**
929  * @dev Implementation of the {IERC20} interface.
930  *
931  * This implementation is agnostic to the way tokens are created. This means
932  * that a supply mechanism has to be added in a derived contract using {_mint}.
933  * For a generic mechanism see {ERC20PresetMinterPauser}.
934  *
935  * TIP: For a detailed writeup see our guide
936  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
937  * to implement supply mechanisms].
938  *
939  * We have followed general OpenZeppelin guidelines: functions revert instead
940  * of returning `false` on failure. This behavior is nonetheless conventional
941  * and does not conflict with the expectations of ERC20 applications.
942  *
943  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
944  * This allows applications to reconstruct the allowance for all accounts just
945  * by listening to said events. Other implementations of the EIP may not emit
946  * these events, as it isn't required by the specification.
947  *
948  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
949  * functions have been added to mitigate the well-known issues around setting
950  * allowances. See {IERC20-approve}.
951  */
952 contract ERC20 is Context, IERC20 {
953     using SafeMath for uint256;
954     using Address for address;
955 
956     mapping (address => uint256) private _balances;
957 
958     mapping (address => mapping (address => uint256)) private _allowances;
959 
960     uint256 private _totalSupply;
961 
962     string private _name;
963     string private _symbol;
964     uint8 private _decimals;
965 
966     /**
967      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
968      * a default value of 18.
969      *
970      * To select a different value for {decimals}, use {_setupDecimals}.
971      *
972      * All three of these values are immutable: they can only be set once during
973      * construction.
974      */
975     constructor (string memory name, string memory symbol) public {
976         _name = name;
977         _symbol = symbol;
978         _decimals = 18;
979     }
980 
981     /**
982      * @dev Returns the name of the token.
983      */
984     function name() public view returns (string memory) {
985         return _name;
986     }
987 
988     /**
989      * @dev Returns the symbol of the token, usually a shorter version of the
990      * name.
991      */
992     function symbol() public view returns (string memory) {
993         return _symbol;
994     }
995 
996     /**
997      * @dev Returns the number of decimals used to get its user representation.
998      * For example, if `decimals` equals `2`, a balance of `505` tokens should
999      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1000      *
1001      * Tokens usually opt for a value of 18, imitating the relationship between
1002      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1003      * called.
1004      *
1005      * NOTE: This information is only used for _display_ purposes: it in
1006      * no way affects any of the arithmetic of the contract, including
1007      * {IERC20-balanceOf} and {IERC20-transfer}.
1008      */
1009     function decimals() public view returns (uint8) {
1010         return _decimals;
1011     }
1012 
1013     /**
1014      * @dev See {IERC20-totalSupply}.
1015      */
1016     function totalSupply() public view override returns (uint256) {
1017         return _totalSupply;
1018     }
1019 
1020     /**
1021      * @dev See {IERC20-balanceOf}.
1022      */
1023     function balanceOf(address account) public view override returns (uint256) {
1024         return _balances[account];
1025     }
1026 
1027     /**
1028      * @dev See {IERC20-transfer}.
1029      *
1030      * Requirements:
1031      *
1032      * - `recipient` cannot be the zero address.
1033      * - the caller must have a balance of at least `amount`.
1034      */
1035     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1036         _transfer(_msgSender(), recipient, amount);
1037         return true;
1038     }
1039 
1040     /**
1041      * @dev See {IERC20-allowance}.
1042      */
1043     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1044         return _allowances[owner][spender];
1045     }
1046 
1047     /**
1048      * @dev See {IERC20-approve}.
1049      *
1050      * Requirements:
1051      *
1052      * - `spender` cannot be the zero address.
1053      */
1054     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1055         _approve(_msgSender(), spender, amount);
1056         return true;
1057     }
1058 
1059     /**
1060      * @dev See {IERC20-transferFrom}.
1061      *
1062      * Emits an {Approval} event indicating the updated allowance. This is not
1063      * required by the EIP. See the note at the beginning of {ERC20};
1064      *
1065      * Requirements:
1066      * - `sender` and `recipient` cannot be the zero address.
1067      * - `sender` must have a balance of at least `amount`.
1068      * - the caller must have allowance for ``sender``'s tokens of at least
1069      * `amount`.
1070      */
1071     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1072         _transfer(sender, recipient, amount);
1073         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1074         return true;
1075     }
1076 
1077     /**
1078      * @dev Atomically increases the allowance granted to `spender` by the caller.
1079      *
1080      * This is an alternative to {approve} that can be used as a mitigation for
1081      * problems described in {IERC20-approve}.
1082      *
1083      * Emits an {Approval} event indicating the updated allowance.
1084      *
1085      * Requirements:
1086      *
1087      * - `spender` cannot be the zero address.
1088      */
1089     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1090         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1091         return true;
1092     }
1093 
1094     /**
1095      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1096      *
1097      * This is an alternative to {approve} that can be used as a mitigation for
1098      * problems described in {IERC20-approve}.
1099      *
1100      * Emits an {Approval} event indicating the updated allowance.
1101      *
1102      * Requirements:
1103      *
1104      * - `spender` cannot be the zero address.
1105      * - `spender` must have allowance for the caller of at least
1106      * `subtractedValue`.
1107      */
1108     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1109         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1110         return true;
1111     }
1112 
1113     /**
1114      * @dev Moves tokens `amount` from `sender` to `recipient`.
1115      *
1116      * This is internal function is equivalent to {transfer}, and can be used to
1117      * e.g. implement automatic token fees, slashing mechanisms, etc.
1118      *
1119      * Emits a {Transfer} event.
1120      *
1121      * Requirements:
1122      *
1123      * - `sender` cannot be the zero address.
1124      * - `recipient` cannot be the zero address.
1125      * - `sender` must have a balance of at least `amount`.
1126      */
1127     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1128         require(sender != address(0), "ERC20: transfer from the zero address");
1129         require(recipient != address(0), "ERC20: transfer to the zero address");
1130 
1131         _beforeTokenTransfer(sender, recipient, amount);
1132 
1133         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1134         _balances[recipient] = _balances[recipient].add(amount);
1135         emit Transfer(sender, recipient, amount);
1136     }
1137 
1138     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1139      * the total supply.
1140      *
1141      * Emits a {Transfer} event with `from` set to the zero address.
1142      *
1143      * Requirements
1144      *
1145      * - `to` cannot be the zero address.
1146      */
1147     function _mint(address account, uint256 amount) internal virtual {
1148         require(account != address(0), "ERC20: mint to the zero address");
1149 
1150         _beforeTokenTransfer(address(0), account, amount);
1151 
1152         _totalSupply = _totalSupply.add(amount);
1153         _balances[account] = _balances[account].add(amount);
1154         emit Transfer(address(0), account, amount);
1155     }
1156 
1157     /**
1158      * @dev Destroys `amount` tokens from `account`, reducing the
1159      * total supply.
1160      *
1161      * Emits a {Transfer} event with `to` set to the zero address.
1162      *
1163      * Requirements
1164      *
1165      * - `account` cannot be the zero address.
1166      * - `account` must have at least `amount` tokens.
1167      */
1168     function _burn(address account, uint256 amount) internal virtual {
1169         require(account != address(0), "ERC20: burn from the zero address");
1170 
1171         _beforeTokenTransfer(account, address(0), amount);
1172 
1173         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1174         _totalSupply = _totalSupply.sub(amount);
1175         emit Transfer(account, address(0), amount);
1176     }
1177 
1178     /**
1179      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1180      *
1181      * This is internal function is equivalent to `approve`, and can be used to
1182      * e.g. set automatic allowances for certain subsystems, etc.
1183      *
1184      * Emits an {Approval} event.
1185      *
1186      * Requirements:
1187      *
1188      * - `owner` cannot be the zero address.
1189      * - `spender` cannot be the zero address.
1190      */
1191     function _approve(address owner, address spender, uint256 amount) internal virtual {
1192         require(owner != address(0), "ERC20: approve from the zero address");
1193         require(spender != address(0), "ERC20: approve to the zero address");
1194 
1195         _allowances[owner][spender] = amount;
1196         emit Approval(owner, spender, amount);
1197     }
1198 
1199     /**
1200      * @dev Sets {decimals} to a value other than the default one of 18.
1201      *
1202      * WARNING: This function should only be called from the constructor. Most
1203      * applications that interact with token contracts will not expect
1204      * {decimals} to ever change, and may work incorrectly if it does.
1205      */
1206     function _setupDecimals(uint8 decimals_) internal {
1207         _decimals = decimals_;
1208     }
1209 
1210     /**
1211      * @dev Hook that is called before any transfer of tokens. This includes
1212      * minting and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1217      * will be to transferred to `to`.
1218      * - when `from` is zero, `amount` tokens will be minted for `to`.
1219      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1220      * - `from` and `to` are never both zero.
1221      *
1222      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1223      */
1224     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1225 }
1226 
1227 
1228 /**
1229  * @dev {ERC20} token, including:
1230  *
1231  *  - standard ERC20 contract interactions and functions
1232  *  - an issuer role that allows for token minting via signed claim tickets,
1233  *    which are issued by authorised addresses having the ISSUER_ROLE role.
1234  *  - nonce tracking for each address to prevent ticket claim replay
1235  *
1236  * This contract uses {AccessControl} to lock permissioned functions using the
1237  * different roles.
1238  *
1239  * The account that deploys the contract will be granted the ISSUER_ROLE
1240  * role, as well as the default admin role, which will let it grant
1241  * and revoke ISSUER_ROLE roles to other accounts.
1242  */
1243 contract XFUND is Context, AccessControl, ERC20 {
1244     bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
1245 
1246     mapping(address => mapping(uint256 => bool)) _usedNonces;
1247     mapping(address => uint256) _lastNonce;
1248 
1249     bytes32 private _sigSalt;
1250 
1251     /**
1252      * @dev Log the claim
1253      *
1254      * claimant - wallet address of msg.sender. Indexed
1255      * valHash - sha256 hash of the validator's self-delegate address. Indexed
1256      * issuer - wallet address of the ticket issuer. Indexed
1257      * validator - string value of the validator's self-delegate address.
1258      * nonce - nonce used for this claim
1259      * amount - amount of claim
1260      */
1261     event TicketClaimed(
1262         address indexed claimant,
1263         bytes32 indexed valHash,
1264         address indexed issuer,
1265         string validator,
1266         uint256 nonce,
1267         uint256 amount
1268     );
1269     event SigSalt(bytes32 salt);
1270 
1271     /**
1272      * @dev Grants `DEFAULT_ADMIN_ROLE` and `ISSUER_ROLE` to the
1273      * account that deploys the contract.
1274      *
1275      * See {ERC20-constructor}.
1276      */
1277     constructor(string memory name, string memory symbol, bytes32 sigSalt) public ERC20(name, symbol) {
1278         require(sigSalt[0] != 0 && sigSalt != 0x0, "xFUND: must include sig salt");
1279         _setupDecimals(9);
1280         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1281 
1282         emit SigSalt(sigSalt);
1283         _sigSalt = sigSalt;
1284     }
1285 
1286     /**
1287      * @dev Creates `amount` new tokens for `_msgSender()`, after validating
1288      * via recovery of data held in `ticket`. The `amount`, `nonce` and
1289      * `_msgSender()` values are used to recreate the message hash used to sign
1290      * the `ticket`. If recovery succeeds, the `amount` is minted for
1291      * `_msgSender()`.
1292      *
1293      * Also see {ERC20-_mint}.
1294      *
1295      * Requirements:
1296      *
1297      * - the `ticket` must have been issued by the `ISSUER_ROLE`.
1298      * - the `nonce` must not have been used and must be incremented by 1.
1299      * - the ticket must include the sig salt defined in the contract
1300      * - the ticket must include the contract's address
1301      * - the ticket must include the sha256 hash of the validator's
1302      *   self-delegate address
1303      */
1304     function claim(uint256 amount, uint256 nonce, string memory validator, bytes memory ticket) external {
1305         require(nonce > 0, "xFUND: nonce must be greater than zero");
1306         require(amount > 0, "xFUND: amount must be greater than zero");
1307         require(ticket.length > 0, "xFUND: must include claim ticket");
1308         require(bytes(validator).length > 0, "xFUND: must include validator");
1309 
1310         require(!_usedNonces[_msgSender()][nonce], "xFUND: nonce already used/ticket claimed");
1311         _usedNonces[_msgSender()][nonce] = true;
1312 
1313         require(nonce == (_lastNonce[_msgSender()] + 1), "xFUND: expected nonce mismatch");
1314         _lastNonce[_msgSender()] = nonce;
1315 
1316         bytes32 valHash = keccak256(abi.encodePacked(validator));
1317 
1318         bytes32 message = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(_msgSender(), valHash, amount, nonce, _sigSalt, address(this))));
1319 
1320         address issuer = ECDSA.recover(message, ticket);
1321 
1322         require(hasRole(ISSUER_ROLE, issuer), "xFUND: ticket invalid or issuer does not have issuer role");
1323 
1324         emit TicketClaimed(_msgSender(), valHash, issuer, validator, nonce, amount);
1325 
1326         _mint(_msgSender(), amount);
1327     }
1328 
1329     /**
1330      * @dev Returns the last nonce value used by a claimant.
1331      */
1332     function lastNonce(address account) external view returns (uint256) {
1333         return _lastNonce[account];
1334     }
1335 
1336     /**
1337      * @dev Returns the current signature salt.
1338      */
1339     function sigSalt() external view returns (bytes32) {
1340         return _sigSalt;
1341     }
1342 }