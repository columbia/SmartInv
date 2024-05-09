1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/token/ERC20/extensions/IERC20Metadata.sol
83 
84 
85 
86 pragma solidity ^0.8.0;
87 
88 
89 /**
90  * @dev Interface for the optional metadata functions from the ERC20 standard.
91  *
92  * _Available since v4.1._
93  */
94 interface IERC20Metadata is IERC20 {
95     /**
96      * @dev Returns the name of the token.
97      */
98     function name() external view returns (string memory);
99 
100     /**
101      * @dev Returns the symbol of the token.
102      */
103     function symbol() external view returns (string memory);
104 
105     /**
106      * @dev Returns the decimals places of the token.
107      */
108     function decimals() external view returns (uint8);
109 }
110 
111 
112 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/utils/Context.sol
113 
114 pragma solidity ^0.8.0;
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
133         return msg.data;
134     }
135 }
136 
137 
138 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/utils/structs/EnumerableSet.sol
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Library for managing
144  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
145  * types.
146  *
147  * Sets have the following properties:
148  *
149  * - Elements are added, removed, and checked for existence in constant time
150  * (O(1)).
151  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
152  *
153  * ```
154  * contract Example {
155  *     // Add the library methods
156  *     using EnumerableSet for EnumerableSet.AddressSet;
157  *
158  *     // Declare a set state variable
159  *     EnumerableSet.AddressSet private mySet;
160  * }
161  * ```
162  *
163  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
164  * and `uint256` (`UintSet`) are supported.
165  */
166 library EnumerableSet {
167     // To implement this library for multiple types with as little code
168     // repetition as possible, we write it in terms of a generic Set type with
169     // bytes32 values.
170     // The Set implementation uses private functions, and user-facing
171     // implementations (such as AddressSet) are just wrappers around the
172     // underlying Set.
173     // This means that we can only create new EnumerableSets for types that fit
174     // in bytes32.
175 
176     struct Set {
177         // Storage of set values
178         bytes32[] _values;
179 
180         // Position of the value in the `values` array, plus 1 because index 0
181         // means a value is not in the set.
182         mapping (bytes32 => uint256) _indexes;
183     }
184 
185     /**
186      * @dev Add a value to a set. O(1).
187      *
188      * Returns true if the value was added to the set, that is if it was not
189      * already present.
190      */
191     function _add(Set storage set, bytes32 value) private returns (bool) {
192         if (!_contains(set, value)) {
193             set._values.push(value);
194             // The value is stored at length-1, but we add 1 to all indexes
195             // and use 0 as a sentinel value
196             set._indexes[value] = set._values.length;
197             return true;
198         } else {
199             return false;
200         }
201     }
202 
203     /**
204      * @dev Removes a value from a set. O(1).
205      *
206      * Returns true if the value was removed from the set, that is if it was
207      * present.
208      */
209     function _remove(Set storage set, bytes32 value) private returns (bool) {
210         // We read and store the value's index to prevent multiple reads from the same storage slot
211         uint256 valueIndex = set._indexes[value];
212 
213         if (valueIndex != 0) { // Equivalent to contains(set, value)
214             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
215             // the array, and then remove the last element (sometimes called as 'swap and pop').
216             // This modifies the order of the array, as noted in {at}.
217 
218             uint256 toDeleteIndex = valueIndex - 1;
219             uint256 lastIndex = set._values.length - 1;
220 
221             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
222             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
223 
224             bytes32 lastvalue = set._values[lastIndex];
225 
226             // Move the last value to the index where the value to delete is
227             set._values[toDeleteIndex] = lastvalue;
228             // Update the index for the moved value
229             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
230 
231             // Delete the slot where the moved value was stored
232             set._values.pop();
233 
234             // Delete the index for the deleted slot
235             delete set._indexes[value];
236 
237             return true;
238         } else {
239             return false;
240         }
241     }
242 
243     /**
244      * @dev Returns true if the value is in the set. O(1).
245      */
246     function _contains(Set storage set, bytes32 value) private view returns (bool) {
247         return set._indexes[value] != 0;
248     }
249 
250     /**
251      * @dev Returns the number of values on the set. O(1).
252      */
253     function _length(Set storage set) private view returns (uint256) {
254         return set._values.length;
255     }
256 
257    /**
258     * @dev Returns the value stored at position `index` in the set. O(1).
259     *
260     * Note that there are no guarantees on the ordering of values inside the
261     * array, and it may change when more values are added or removed.
262     *
263     * Requirements:
264     *
265     * - `index` must be strictly less than {length}.
266     */
267     function _at(Set storage set, uint256 index) private view returns (bytes32) {
268         require(set._values.length > index, "EnumerableSet: index out of bounds");
269         return set._values[index];
270     }
271 
272     // Bytes32Set
273 
274     struct Bytes32Set {
275         Set _inner;
276     }
277 
278     /**
279      * @dev Add a value to a set. O(1).
280      *
281      * Returns true if the value was added to the set, that is if it was not
282      * already present.
283      */
284     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
285         return _add(set._inner, value);
286     }
287 
288     /**
289      * @dev Removes a value from a set. O(1).
290      *
291      * Returns true if the value was removed from the set, that is if it was
292      * present.
293      */
294     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
295         return _remove(set._inner, value);
296     }
297 
298     /**
299      * @dev Returns true if the value is in the set. O(1).
300      */
301     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
302         return _contains(set._inner, value);
303     }
304 
305     /**
306      * @dev Returns the number of values in the set. O(1).
307      */
308     function length(Bytes32Set storage set) internal view returns (uint256) {
309         return _length(set._inner);
310     }
311 
312    /**
313     * @dev Returns the value stored at position `index` in the set. O(1).
314     *
315     * Note that there are no guarantees on the ordering of values inside the
316     * array, and it may change when more values are added or removed.
317     *
318     * Requirements:
319     *
320     * - `index` must be strictly less than {length}.
321     */
322     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
323         return _at(set._inner, index);
324     }
325 
326     // AddressSet
327 
328     struct AddressSet {
329         Set _inner;
330     }
331 
332     /**
333      * @dev Add a value to a set. O(1).
334      *
335      * Returns true if the value was added to the set, that is if it was not
336      * already present.
337      */
338     function add(AddressSet storage set, address value) internal returns (bool) {
339         return _add(set._inner, bytes32(uint256(uint160(value))));
340     }
341 
342     /**
343      * @dev Removes a value from a set. O(1).
344      *
345      * Returns true if the value was removed from the set, that is if it was
346      * present.
347      */
348     function remove(AddressSet storage set, address value) internal returns (bool) {
349         return _remove(set._inner, bytes32(uint256(uint160(value))));
350     }
351 
352     /**
353      * @dev Returns true if the value is in the set. O(1).
354      */
355     function contains(AddressSet storage set, address value) internal view returns (bool) {
356         return _contains(set._inner, bytes32(uint256(uint160(value))));
357     }
358 
359     /**
360      * @dev Returns the number of values in the set. O(1).
361      */
362     function length(AddressSet storage set) internal view returns (uint256) {
363         return _length(set._inner);
364     }
365 
366    /**
367     * @dev Returns the value stored at position `index` in the set. O(1).
368     *
369     * Note that there are no guarantees on the ordering of values inside the
370     * array, and it may change when more values are added or removed.
371     *
372     * Requirements:
373     *
374     * - `index` must be strictly less than {length}.
375     */
376     function at(AddressSet storage set, uint256 index) internal view returns (address) {
377         return address(uint160(uint256(_at(set._inner, index))));
378     }
379 
380 
381     // UintSet
382 
383     struct UintSet {
384         Set _inner;
385     }
386 
387     /**
388      * @dev Add a value to a set. O(1).
389      *
390      * Returns true if the value was added to the set, that is if it was not
391      * already present.
392      */
393     function add(UintSet storage set, uint256 value) internal returns (bool) {
394         return _add(set._inner, bytes32(value));
395     }
396 
397     /**
398      * @dev Removes a value from a set. O(1).
399      *
400      * Returns true if the value was removed from the set, that is if it was
401      * present.
402      */
403     function remove(UintSet storage set, uint256 value) internal returns (bool) {
404         return _remove(set._inner, bytes32(value));
405     }
406 
407     /**
408      * @dev Returns true if the value is in the set. O(1).
409      */
410     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
411         return _contains(set._inner, bytes32(value));
412     }
413 
414     /**
415      * @dev Returns the number of values on the set. O(1).
416      */
417     function length(UintSet storage set) internal view returns (uint256) {
418         return _length(set._inner);
419     }
420 
421    /**
422     * @dev Returns the value stored at position `index` in the set. O(1).
423     *
424     * Note that there are no guarantees on the ordering of values inside the
425     * array, and it may change when more values are added or removed.
426     *
427     * Requirements:
428     *
429     * - `index` must be strictly less than {length}.
430     */
431     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
432         return uint256(_at(set._inner, index));
433     }
434 }
435 
436 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/utils/introspection/IERC165.sol
437 
438 
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Interface of the ERC165 standard, as defined in the
444  * https://eips.ethereum.org/EIPS/eip-165[EIP].
445  *
446  * Implementers can declare support of contract interfaces, which can then be
447  * queried by others ({ERC165Checker}).
448  *
449  * For an implementation, see {ERC165}.
450  */
451 interface IERC165 {
452     /**
453      * @dev Returns true if this contract implements the interface defined by
454      * `interfaceId`. See the corresponding
455      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
456      * to learn more about how these ids are created.
457      *
458      * This function call must use less than 30 000 gas.
459      */
460     function supportsInterface(bytes4 interfaceId) external view returns (bool);
461 }
462 
463 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/utils/introspection/ERC165.sol
464 
465 
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/utils/Strings.sol
494 
495 
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev String operations.
501  */
502 library Strings {
503     bytes16 private constant alphabet = "0123456789abcdef";
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
507      */
508     function toString(uint256 value) internal pure returns (string memory) {
509         // Inspired by OraclizeAPI's implementation - MIT licence
510         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
511 
512         if (value == 0) {
513             return "0";
514         }
515         uint256 temp = value;
516         uint256 digits;
517         while (temp != 0) {
518             digits++;
519             temp /= 10;
520         }
521         bytes memory buffer = new bytes(digits);
522         while (value != 0) {
523             digits -= 1;
524             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
525             value /= 10;
526         }
527         return string(buffer);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
532      */
533     function toHexString(uint256 value) internal pure returns (string memory) {
534         if (value == 0) {
535             return "0x00";
536         }
537         uint256 temp = value;
538         uint256 length = 0;
539         while (temp != 0) {
540             length++;
541             temp >>= 8;
542         }
543         return toHexString(value, length);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
548      */
549     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
550         bytes memory buffer = new bytes(2 * length + 2);
551         buffer[0] = "0";
552         buffer[1] = "x";
553         for (uint256 i = 2 * length + 1; i > 1; --i) {
554             buffer[i] = alphabet[value & 0xf];
555             value >>= 4;
556         }
557         require(value == 0, "Strings: hex length insufficient");
558         return string(buffer);
559     }
560 
561 }
562 
563 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/access/AccessControl.sol
564 
565 
566 
567 pragma solidity ^0.8.0;
568 
569 
570 
571 
572 /**
573  * @dev External interface of AccessControl declared to support ERC165 detection.
574  */
575 interface IAccessControl {
576     function hasRole(bytes32 role, address account) external view returns (bool);
577     function getRoleAdmin(bytes32 role) external view returns (bytes32);
578     function grantRole(bytes32 role, address account) external;
579     function revokeRole(bytes32 role, address account) external;
580     function renounceRole(bytes32 role, address account) external;
581 }
582 
583 /**
584  * @dev Contract module that allows children to implement role-based access
585  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
586  * members except through off-chain means by accessing the contract event logs. Some
587  * applications may benefit from on-chain enumerability, for those cases see
588  * {AccessControlEnumerable}.
589  *
590  * Roles are referred to by their `bytes32` identifier. These should be exposed
591  * in the external API and be unique. The best way to achieve this is by
592  * using `public constant` hash digests:
593  *
594  * ```
595  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
596  * ```
597  *
598  * Roles can be used to represent a set of permissions. To restrict access to a
599  * function call, use {hasRole}:
600  *
601  * ```
602  * function foo() public {
603  *     require(hasRole(MY_ROLE, msg.sender));
604  *     ...
605  * }
606  * ```
607  *
608  * Roles can be granted and revoked dynamically via the {grantRole} and
609  * {revokeRole} functions. Each role has an associated admin role, and only
610  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
611  *
612  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
613  * that only accounts with this role will be able to grant or revoke other
614  * roles. More complex role relationships can be created by using
615  * {_setRoleAdmin}.
616  *
617  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
618  * grant and revoke this role. Extra precautions should be taken to secure
619  * accounts that have been granted it.
620  */
621 abstract contract AccessControl is Context, IAccessControl, ERC165 {
622     struct RoleData {
623         mapping (address => bool) members;
624         bytes32 adminRole;
625     }
626 
627     mapping (bytes32 => RoleData) private _roles;
628 
629     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
630 
631     /**
632      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
633      *
634      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
635      * {RoleAdminChanged} not being emitted signaling this.
636      *
637      * _Available since v3.1._
638      */
639     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
640 
641     /**
642      * @dev Emitted when `account` is granted `role`.
643      *
644      * `sender` is the account that originated the contract call, an admin role
645      * bearer except when using {_setupRole}.
646      */
647     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
648 
649     /**
650      * @dev Emitted when `account` is revoked `role`.
651      *
652      * `sender` is the account that originated the contract call:
653      *   - if using `revokeRole`, it is the admin role bearer
654      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
655      */
656     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
657 
658     /**
659      * @dev Modifier that checks that an account has a specific role. Reverts
660      * with a standardized message including the required role.
661      *
662      * The format of the revert reason is given by the following regular expression:
663      *
664      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
665      *
666      * _Available since v4.1._
667      */
668     modifier onlyRole(bytes32 role) {
669         _checkRole(role, _msgSender());
670         _;
671     }
672 
673     /**
674      * @dev See {IERC165-supportsInterface}.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677         return interfaceId == type(IAccessControl).interfaceId
678             || super.supportsInterface(interfaceId);
679     }
680 
681     /**
682      * @dev Returns `true` if `account` has been granted `role`.
683      */
684     function hasRole(bytes32 role, address account) public view override returns (bool) {
685         return _roles[role].members[account];
686     }
687 
688     /**
689      * @dev Revert with a standard message if `account` is missing `role`.
690      *
691      * The format of the revert reason is given by the following regular expression:
692      *
693      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
694      */
695     function _checkRole(bytes32 role, address account) internal view {
696         if(!hasRole(role, account)) {
697             revert(string(abi.encodePacked(
698                 "AccessControl: account ",
699                 Strings.toHexString(uint160(account), 20),
700                 " is missing role ",
701                 Strings.toHexString(uint256(role), 32)
702             )));
703         }
704     }
705 
706     /**
707      * @dev Returns the admin role that controls `role`. See {grantRole} and
708      * {revokeRole}.
709      *
710      * To change a role's admin, use {_setRoleAdmin}.
711      */
712     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
713         return _roles[role].adminRole;
714     }
715 
716     /**
717      * @dev Grants `role` to `account`.
718      *
719      * If `account` had not been already granted `role`, emits a {RoleGranted}
720      * event.
721      *
722      * Requirements:
723      *
724      * - the caller must have ``role``'s admin role.
725      */
726     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
727         _grantRole(role, account);
728     }
729 
730     /**
731      * @dev Revokes `role` from `account`.
732      *
733      * If `account` had been granted `role`, emits a {RoleRevoked} event.
734      *
735      * Requirements:
736      *
737      * - the caller must have ``role``'s admin role.
738      */
739     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
740         _revokeRole(role, account);
741     }
742 
743     /**
744      * @dev Revokes `role` from the calling account.
745      *
746      * Roles are often managed via {grantRole} and {revokeRole}: this function's
747      * purpose is to provide a mechanism for accounts to lose their privileges
748      * if they are compromised (such as when a trusted device is misplaced).
749      *
750      * If the calling account had been granted `role`, emits a {RoleRevoked}
751      * event.
752      *
753      * Requirements:
754      *
755      * - the caller must be `account`.
756      */
757     function renounceRole(bytes32 role, address account) public virtual override {
758         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
759 
760         _revokeRole(role, account);
761     }
762 
763     /**
764      * @dev Grants `role` to `account`.
765      *
766      * If `account` had not been already granted `role`, emits a {RoleGranted}
767      * event. Note that unlike {grantRole}, this function doesn't perform any
768      * checks on the calling account.
769      *
770      * [WARNING]
771      * ====
772      * This function should only be called from the constructor when setting
773      * up the initial roles for the system.
774      *
775      * Using this function in any other way is effectively circumventing the admin
776      * system imposed by {AccessControl}.
777      * ====
778      */
779     function _setupRole(bytes32 role, address account) internal virtual {
780         _grantRole(role, account);
781     }
782 
783     /**
784      * @dev Sets `adminRole` as ``role``'s admin role.
785      *
786      * Emits a {RoleAdminChanged} event.
787      */
788     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
789         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
790         _roles[role].adminRole = adminRole;
791     }
792 
793     function _grantRole(bytes32 role, address account) private {
794         if (!hasRole(role, account)) {
795             _roles[role].members[account] = true;
796             emit RoleGranted(role, account, _msgSender());
797         }
798     }
799 
800     function _revokeRole(bytes32 role, address account) private {
801         if (hasRole(role, account)) {
802             _roles[role].members[account] = false;
803             emit RoleRevoked(role, account, _msgSender());
804         }
805     }
806 }
807 
808 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/access/AccessControlEnumerable.sol
809 
810 
811 
812 pragma solidity ^0.8.0;
813 
814 
815 
816 /**
817  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
818  */
819 interface IAccessControlEnumerable {
820     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
821     function getRoleMemberCount(bytes32 role) external view returns (uint256);
822 }
823 
824 /**
825  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
826  */
827 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
828     using EnumerableSet for EnumerableSet.AddressSet;
829 
830     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
836         return interfaceId == type(IAccessControlEnumerable).interfaceId
837             || super.supportsInterface(interfaceId);
838     }
839 
840     /**
841      * @dev Returns one of the accounts that have `role`. `index` must be a
842      * value between 0 and {getRoleMemberCount}, non-inclusive.
843      *
844      * Role bearers are not sorted in any particular way, and their ordering may
845      * change at any point.
846      *
847      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
848      * you perform all queries on the same block. See the following
849      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
850      * for more information.
851      */
852     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
853         return _roleMembers[role].at(index);
854     }
855 
856     /**
857      * @dev Returns the number of accounts that have `role`. Can be used
858      * together with {getRoleMember} to enumerate all bearers of a role.
859      */
860     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
861         return _roleMembers[role].length();
862     }
863 
864     /**
865      * @dev Overload {grantRole} to track enumerable memberships
866      */
867     function grantRole(bytes32 role, address account) public virtual override {
868         super.grantRole(role, account);
869         _roleMembers[role].add(account);
870     }
871 
872     /**
873      * @dev Overload {revokeRole} to track enumerable memberships
874      */
875     function revokeRole(bytes32 role, address account) public virtual override {
876         super.revokeRole(role, account);
877         _roleMembers[role].remove(account);
878     }
879 
880     /**
881      * @dev Overload {renounceRole} to track enumerable memberships
882      */
883     function renounceRole(bytes32 role, address account) public virtual override {
884         super.renounceRole(role, account);
885         _roleMembers[role].remove(account);
886     }
887 
888     /**
889      * @dev Overload {_setupRole} to track enumerable memberships
890      */
891     function _setupRole(bytes32 role, address account) internal virtual override {
892         super._setupRole(role, account);
893         _roleMembers[role].add(account);
894     }
895 }
896 
897 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/token/ERC20/ERC20.sol
898 
899 
900 
901 pragma solidity ^0.8.0;
902 
903 
904 
905 
906 /**
907  * @dev Implementation of the {IERC20} interface.
908  *
909  * This implementation is agnostic to the way tokens are created. This means
910  * that a supply mechanism has to be added in a derived contract using {_mint}.
911  * For a generic mechanism see {ERC20PresetMinterPauser}.
912  *
913  * TIP: For a detailed writeup see our guide
914  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
915  * to implement supply mechanisms].
916  *
917  * We have followed general OpenZeppelin guidelines: functions revert instead
918  * of returning `false` on failure. This behavior is nonetheless conventional
919  * and does not conflict with the expectations of ERC20 applications.
920  *
921  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
922  * This allows applications to reconstruct the allowance for all accounts just
923  * by listening to said events. Other implementations of the EIP may not emit
924  * these events, as it isn't required by the specification.
925  *
926  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
927  * functions have been added to mitigate the well-known issues around setting
928  * allowances. See {IERC20-approve}.
929  */
930 contract ERC20 is Context, IERC20, IERC20Metadata {
931     mapping (address => uint256) private _balances;
932 
933     mapping (address => mapping (address => uint256)) private _allowances;
934 
935     uint256 private _totalSupply;
936 
937     string private _name;
938     string private _symbol;
939 
940     /**
941      * @dev Sets the values for {name} and {symbol}.
942      *
943      * The defaut value of {decimals} is 18. To select a different value for
944      * {decimals} you should overload it.
945      *
946      * All two of these values are immutable: they can only be set once during
947      * construction.
948      */
949     constructor (string memory name_, string memory symbol_) {
950         _name = name_;
951         _symbol = symbol_;
952     }
953 
954     /**
955      * @dev Returns the name of the token.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev Returns the symbol of the token, usually a shorter version of the
963      * name.
964      */
965     function symbol() public view virtual override returns (string memory) {
966         return _symbol;
967     }
968 
969     /**
970      * @dev Returns the number of decimals used to get its user representation.
971      * For example, if `decimals` equals `2`, a balance of `505` tokens should
972      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
973      *
974      * Tokens usually opt for a value of 18, imitating the relationship between
975      * Ether and Wei. This is the value {ERC20} uses, unless this function is
976      * overridden;
977      *
978      * NOTE: This information is only used for _display_ purposes: it in
979      * no way affects any of the arithmetic of the contract, including
980      * {IERC20-balanceOf} and {IERC20-transfer}.
981      */
982     function decimals() public view virtual override returns (uint8) {
983         return 18;
984     }
985 
986     /**
987      * @dev See {IERC20-totalSupply}.
988      */
989     function totalSupply() public view virtual override returns (uint256) {
990         return _totalSupply;
991     }
992 
993     /**
994      * @dev See {IERC20-balanceOf}.
995      */
996     function balanceOf(address account) public view virtual override returns (uint256) {
997         return _balances[account];
998     }
999 
1000     /**
1001      * @dev See {IERC20-transfer}.
1002      *
1003      * Requirements:
1004      *
1005      * - `recipient` cannot be the zero address.
1006      * - the caller must have a balance of at least `amount`.
1007      */
1008     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1009         _transfer(_msgSender(), recipient, amount);
1010         return true;
1011     }
1012 
1013     /**
1014      * @dev See {IERC20-allowance}.
1015      */
1016     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1017         return _allowances[owner][spender];
1018     }
1019 
1020     /**
1021      * @dev See {IERC20-approve}.
1022      *
1023      * Requirements:
1024      *
1025      * - `spender` cannot be the zero address.
1026      */
1027     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1028         _approve(_msgSender(), spender, amount);
1029         return true;
1030     }
1031 
1032     /**
1033      * @dev See {IERC20-transferFrom}.
1034      *
1035      * Emits an {Approval} event indicating the updated allowance. This is not
1036      * required by the EIP. See the note at the beginning of {ERC20}.
1037      *
1038      * Requirements:
1039      *
1040      * - `sender` and `recipient` cannot be the zero address.
1041      * - `sender` must have a balance of at least `amount`.
1042      * - the caller must have allowance for ``sender``'s tokens of at least
1043      * `amount`.
1044      */
1045     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1046         _transfer(sender, recipient, amount);
1047 
1048         uint256 currentAllowance = _allowances[sender][_msgSender()];
1049         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1050         _approve(sender, _msgSender(), currentAllowance - amount);
1051 
1052         return true;
1053     }
1054 
1055     /**
1056      * @dev Atomically increases the allowance granted to `spender` by the caller.
1057      *
1058      * This is an alternative to {approve} that can be used as a mitigation for
1059      * problems described in {IERC20-approve}.
1060      *
1061      * Emits an {Approval} event indicating the updated allowance.
1062      *
1063      * Requirements:
1064      *
1065      * - `spender` cannot be the zero address.
1066      */
1067     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1068         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1069         return true;
1070     }
1071 
1072     /**
1073      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1074      *
1075      * This is an alternative to {approve} that can be used as a mitigation for
1076      * problems described in {IERC20-approve}.
1077      *
1078      * Emits an {Approval} event indicating the updated allowance.
1079      *
1080      * Requirements:
1081      *
1082      * - `spender` cannot be the zero address.
1083      * - `spender` must have allowance for the caller of at least
1084      * `subtractedValue`.
1085      */
1086     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1087         uint256 currentAllowance = _allowances[_msgSender()][spender];
1088         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1089         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1090 
1091         return true;
1092     }
1093 
1094     /**
1095      * @dev Moves tokens `amount` from `sender` to `recipient`.
1096      *
1097      * This is internal function is equivalent to {transfer}, and can be used to
1098      * e.g. implement automatic token fees, slashing mechanisms, etc.
1099      *
1100      * Emits a {Transfer} event.
1101      *
1102      * Requirements:
1103      *
1104      * - `sender` cannot be the zero address.
1105      * - `recipient` cannot be the zero address.
1106      * - `sender` must have a balance of at least `amount`.
1107      */
1108     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1109         require(sender != address(0), "ERC20: transfer from the zero address");
1110         require(recipient != address(0), "ERC20: transfer to the zero address");
1111 
1112         _beforeTokenTransfer(sender, recipient, amount);
1113 
1114         uint256 senderBalance = _balances[sender];
1115         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1116         _balances[sender] = senderBalance - amount;
1117         _balances[recipient] += amount;
1118 
1119         emit Transfer(sender, recipient, amount);
1120     }
1121 
1122     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1123      * the total supply.
1124      *
1125      * Emits a {Transfer} event with `from` set to the zero address.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      */
1131     function _mint(address account, uint256 amount) internal virtual {
1132         require(account != address(0), "ERC20: mint to the zero address");
1133 
1134         _beforeTokenTransfer(address(0), account, amount);
1135 
1136         _totalSupply += amount;
1137         _balances[account] += amount;
1138         emit Transfer(address(0), account, amount);
1139     }
1140 
1141     /**
1142      * @dev Destroys `amount` tokens from `account`, reducing the
1143      * total supply.
1144      *
1145      * Emits a {Transfer} event with `to` set to the zero address.
1146      *
1147      * Requirements:
1148      *
1149      * - `account` cannot be the zero address.
1150      * - `account` must have at least `amount` tokens.
1151      */
1152     function _burn(address account, uint256 amount) internal virtual {
1153         require(account != address(0), "ERC20: burn from the zero address");
1154 
1155         _beforeTokenTransfer(account, address(0), amount);
1156 
1157         uint256 accountBalance = _balances[account];
1158         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1159         _balances[account] = accountBalance - amount;
1160         _totalSupply -= amount;
1161 
1162         emit Transfer(account, address(0), amount);
1163     }
1164 
1165     /**
1166      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1167      *
1168      * This internal function is equivalent to `approve`, and can be used to
1169      * e.g. set automatic allowances for certain subsystems, etc.
1170      *
1171      * Emits an {Approval} event.
1172      *
1173      * Requirements:
1174      *
1175      * - `owner` cannot be the zero address.
1176      * - `spender` cannot be the zero address.
1177      */
1178     function _approve(address owner, address spender, uint256 amount) internal virtual {
1179         require(owner != address(0), "ERC20: approve from the zero address");
1180         require(spender != address(0), "ERC20: approve to the zero address");
1181 
1182         _allowances[owner][spender] = amount;
1183         emit Approval(owner, spender, amount);
1184     }
1185 
1186     /**
1187      * @dev Hook that is called before any transfer of tokens. This includes
1188      * minting and burning.
1189      *
1190      * Calling conditions:
1191      *
1192      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1193      * will be to transferred to `to`.
1194      * - when `from` is zero, `amount` tokens will be minted for `to`.
1195      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1196      * - `from` and `to` are never both zero.
1197      *
1198      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1199      */
1200     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1201 }
1202 
1203 
1204 
1205 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.1.0/contracts/token/ERC20/extensions/ERC20Burnable.sol
1206 
1207 
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 
1212 
1213 /**
1214  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1215  * tokens and those that they have an allowance for, in a way that can be
1216  * recognized off-chain (via event analysis).
1217  */
1218 abstract contract ERC20Burnable is Context, ERC20 {
1219     /**
1220      * @dev Destroys `amount` tokens from the caller.
1221      *
1222      * See {ERC20-_burn}.
1223      */
1224     function burn(uint256 amount) public virtual {
1225         _burn(_msgSender(), amount);
1226     }
1227 
1228     /**
1229      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1230      * allowance.
1231      *
1232      * See {ERC20-_burn} and {ERC20-allowance}.
1233      *
1234      * Requirements:
1235      *
1236      * - the caller must have allowance for ``accounts``'s tokens of at least
1237      * `amount`.
1238      */
1239     function burnFrom(address account, uint256 amount) public virtual {
1240         uint256 currentAllowance = allowance(account, _msgSender());
1241         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1242         _approve(account, _msgSender(), currentAllowance - amount);
1243         _burn(account, amount);
1244     }
1245 }
1246 
1247 
1248 // File: contracts/DAX.sol
1249 
1250 pragma solidity ^0.8.4;
1251 
1252 
1253 contract DAX is Context, AccessControlEnumerable, ERC20, ERC20Burnable {
1254     
1255     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1256 
1257     constructor () ERC20("Dragon X", "DAX") {
1258         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1259         _setupRole(MINTER_ROLE, _msgSender());
1260     }
1261     
1262     function mint(address to, uint256 amount) public virtual {
1263         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1264         _mint(to, amount);
1265     }
1266 }