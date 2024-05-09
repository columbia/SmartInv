1 // File: contracts/core/interfaces/IERC20.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface IERC20 {
7     event Approval(address indexed owner, address indexed spender, uint256 value);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 
10     function allowance(address owner, address spender) external view returns (uint256);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function transferFrom(
17         address from,
18         address to,
19         uint256 value
20     ) external returns (bool);
21 
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address owner) external view returns (uint256);
25 
26     function name() external view returns (string memory);
27 
28     function symbol() external view returns (string memory);
29 
30     function decimals() external pure returns (uint8);
31 }
32 
33 // File: @openzeppelin/contracts/utils/Counters.sol
34 
35 
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @title Counters
41  * @author Matt Condon (@shrugs)
42  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
43  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
44  *
45  * Include with `using Counters for Counters.Counter;`
46  */
47 library Counters {
48     struct Counter {
49         // This variable should never be directly accessed by users of the library: interactions must be restricted to
50         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
51         // this feature: see https://github.com/ethereum/solidity/issues/4637
52         uint256 _value; // default: 0
53     }
54 
55     function current(Counter storage counter) internal view returns (uint256) {
56         return counter._value;
57     }
58 
59     function increment(Counter storage counter) internal {
60         unchecked {
61             counter._value += 1;
62         }
63     }
64 
65     function decrement(Counter storage counter) internal {
66         uint256 value = counter._value;
67         require(value > 0, "Counter: decrement overflow");
68         unchecked {
69             counter._value = value - 1;
70         }
71     }
72 
73     function reset(Counter storage counter) internal {
74         counter._value = 0;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
79 
80 
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev Library for managing
86  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
87  * types.
88  *
89  * Sets have the following properties:
90  *
91  * - Elements are added, removed, and checked for existence in constant time
92  * (O(1)).
93  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
94  *
95  * ```
96  * contract Example {
97  *     // Add the library methods
98  *     using EnumerableSet for EnumerableSet.AddressSet;
99  *
100  *     // Declare a set state variable
101  *     EnumerableSet.AddressSet private mySet;
102  * }
103  * ```
104  *
105  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
106  * and `uint256` (`UintSet`) are supported.
107  */
108 library EnumerableSet {
109     // To implement this library for multiple types with as little code
110     // repetition as possible, we write it in terms of a generic Set type with
111     // bytes32 values.
112     // The Set implementation uses private functions, and user-facing
113     // implementations (such as AddressSet) are just wrappers around the
114     // underlying Set.
115     // This means that we can only create new EnumerableSets for types that fit
116     // in bytes32.
117 
118     struct Set {
119         // Storage of set values
120         bytes32[] _values;
121         // Position of the value in the `values` array, plus 1 because index 0
122         // means a value is not in the set.
123         mapping(bytes32 => uint256) _indexes;
124     }
125 
126     /**
127      * @dev Add a value to a set. O(1).
128      *
129      * Returns true if the value was added to the set, that is if it was not
130      * already present.
131      */
132     function _add(Set storage set, bytes32 value) private returns (bool) {
133         if (!_contains(set, value)) {
134             set._values.push(value);
135             // The value is stored at length-1, but we add 1 to all indexes
136             // and use 0 as a sentinel value
137             set._indexes[value] = set._values.length;
138             return true;
139         } else {
140             return false;
141         }
142     }
143 
144     /**
145      * @dev Removes a value from a set. O(1).
146      *
147      * Returns true if the value was removed from the set, that is if it was
148      * present.
149      */
150     function _remove(Set storage set, bytes32 value) private returns (bool) {
151         // We read and store the value's index to prevent multiple reads from the same storage slot
152         uint256 valueIndex = set._indexes[value];
153 
154         if (valueIndex != 0) {
155             // Equivalent to contains(set, value)
156             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
157             // the array, and then remove the last element (sometimes called as 'swap and pop').
158             // This modifies the order of the array, as noted in {at}.
159 
160             uint256 toDeleteIndex = valueIndex - 1;
161             uint256 lastIndex = set._values.length - 1;
162 
163             if (lastIndex != toDeleteIndex) {
164                 bytes32 lastvalue = set._values[lastIndex];
165 
166                 // Move the last value to the index where the value to delete is
167                 set._values[toDeleteIndex] = lastvalue;
168                 // Update the index for the moved value
169                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
170             }
171 
172             // Delete the slot where the moved value was stored
173             set._values.pop();
174 
175             // Delete the index for the deleted slot
176             delete set._indexes[value];
177 
178             return true;
179         } else {
180             return false;
181         }
182     }
183 
184     /**
185      * @dev Returns true if the value is in the set. O(1).
186      */
187     function _contains(Set storage set, bytes32 value) private view returns (bool) {
188         return set._indexes[value] != 0;
189     }
190 
191     /**
192      * @dev Returns the number of values on the set. O(1).
193      */
194     function _length(Set storage set) private view returns (uint256) {
195         return set._values.length;
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
208     function _at(Set storage set, uint256 index) private view returns (bytes32) {
209         return set._values[index];
210     }
211 
212     /**
213      * @dev Return the entire set in an array
214      *
215      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
216      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
217      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
218      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
219      */
220     function _values(Set storage set) private view returns (bytes32[] memory) {
221         return set._values;
222     }
223 
224     // Bytes32Set
225 
226     struct Bytes32Set {
227         Set _inner;
228     }
229 
230     /**
231      * @dev Add a value to a set. O(1).
232      *
233      * Returns true if the value was added to the set, that is if it was not
234      * already present.
235      */
236     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
237         return _add(set._inner, value);
238     }
239 
240     /**
241      * @dev Removes a value from a set. O(1).
242      *
243      * Returns true if the value was removed from the set, that is if it was
244      * present.
245      */
246     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
247         return _remove(set._inner, value);
248     }
249 
250     /**
251      * @dev Returns true if the value is in the set. O(1).
252      */
253     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
254         return _contains(set._inner, value);
255     }
256 
257     /**
258      * @dev Returns the number of values in the set. O(1).
259      */
260     function length(Bytes32Set storage set) internal view returns (uint256) {
261         return _length(set._inner);
262     }
263 
264     /**
265      * @dev Returns the value stored at position `index` in the set. O(1).
266      *
267      * Note that there are no guarantees on the ordering of values inside the
268      * array, and it may change when more values are added or removed.
269      *
270      * Requirements:
271      *
272      * - `index` must be strictly less than {length}.
273      */
274     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
275         return _at(set._inner, index);
276     }
277 
278     /**
279      * @dev Return the entire set in an array
280      *
281      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
282      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
283      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
284      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
285      */
286     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
287         return _values(set._inner);
288     }
289 
290     // AddressSet
291 
292     struct AddressSet {
293         Set _inner;
294     }
295 
296     /**
297      * @dev Add a value to a set. O(1).
298      *
299      * Returns true if the value was added to the set, that is if it was not
300      * already present.
301      */
302     function add(AddressSet storage set, address value) internal returns (bool) {
303         return _add(set._inner, bytes32(uint256(uint160(value))));
304     }
305 
306     /**
307      * @dev Removes a value from a set. O(1).
308      *
309      * Returns true if the value was removed from the set, that is if it was
310      * present.
311      */
312     function remove(AddressSet storage set, address value) internal returns (bool) {
313         return _remove(set._inner, bytes32(uint256(uint160(value))));
314     }
315 
316     /**
317      * @dev Returns true if the value is in the set. O(1).
318      */
319     function contains(AddressSet storage set, address value) internal view returns (bool) {
320         return _contains(set._inner, bytes32(uint256(uint160(value))));
321     }
322 
323     /**
324      * @dev Returns the number of values in the set. O(1).
325      */
326     function length(AddressSet storage set) internal view returns (uint256) {
327         return _length(set._inner);
328     }
329 
330     /**
331      * @dev Returns the value stored at position `index` in the set. O(1).
332      *
333      * Note that there are no guarantees on the ordering of values inside the
334      * array, and it may change when more values are added or removed.
335      *
336      * Requirements:
337      *
338      * - `index` must be strictly less than {length}.
339      */
340     function at(AddressSet storage set, uint256 index) internal view returns (address) {
341         return address(uint160(uint256(_at(set._inner, index))));
342     }
343 
344     /**
345      * @dev Return the entire set in an array
346      *
347      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
348      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
349      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
350      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
351      */
352     function values(AddressSet storage set) internal view returns (address[] memory) {
353         bytes32[] memory store = _values(set._inner);
354         address[] memory result;
355 
356         assembly {
357             result := store
358         }
359 
360         return result;
361     }
362 
363     // UintSet
364 
365     struct UintSet {
366         Set _inner;
367     }
368 
369     /**
370      * @dev Add a value to a set. O(1).
371      *
372      * Returns true if the value was added to the set, that is if it was not
373      * already present.
374      */
375     function add(UintSet storage set, uint256 value) internal returns (bool) {
376         return _add(set._inner, bytes32(value));
377     }
378 
379     /**
380      * @dev Removes a value from a set. O(1).
381      *
382      * Returns true if the value was removed from the set, that is if it was
383      * present.
384      */
385     function remove(UintSet storage set, uint256 value) internal returns (bool) {
386         return _remove(set._inner, bytes32(value));
387     }
388 
389     /**
390      * @dev Returns true if the value is in the set. O(1).
391      */
392     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
393         return _contains(set._inner, bytes32(value));
394     }
395 
396     /**
397      * @dev Returns the number of values on the set. O(1).
398      */
399     function length(UintSet storage set) internal view returns (uint256) {
400         return _length(set._inner);
401     }
402 
403     /**
404      * @dev Returns the value stored at position `index` in the set. O(1).
405      *
406      * Note that there are no guarantees on the ordering of values inside the
407      * array, and it may change when more values are added or removed.
408      *
409      * Requirements:
410      *
411      * - `index` must be strictly less than {length}.
412      */
413     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
414         return uint256(_at(set._inner, index));
415     }
416 
417     /**
418      * @dev Return the entire set in an array
419      *
420      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
421      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
422      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
423      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
424      */
425     function values(UintSet storage set) internal view returns (uint256[] memory) {
426         bytes32[] memory store = _values(set._inner);
427         uint256[] memory result;
428 
429         assembly {
430             result := store
431         }
432 
433         return result;
434     }
435 }
436 
437 // File: @openzeppelin/contracts/access/IAccessControl.sol
438 
439 
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev External interface of AccessControl declared to support ERC165 detection.
445  */
446 interface IAccessControl {
447     /**
448      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
449      *
450      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
451      * {RoleAdminChanged} not being emitted signaling this.
452      *
453      * _Available since v3.1._
454      */
455     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
456 
457     /**
458      * @dev Emitted when `account` is granted `role`.
459      *
460      * `sender` is the account that originated the contract call, an admin role
461      * bearer except when using {AccessControl-_setupRole}.
462      */
463     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
464 
465     /**
466      * @dev Emitted when `account` is revoked `role`.
467      *
468      * `sender` is the account that originated the contract call:
469      *   - if using `revokeRole`, it is the admin role bearer
470      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
471      */
472     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
473 
474     /**
475      * @dev Returns `true` if `account` has been granted `role`.
476      */
477     function hasRole(bytes32 role, address account) external view returns (bool);
478 
479     /**
480      * @dev Returns the admin role that controls `role`. See {grantRole} and
481      * {revokeRole}.
482      *
483      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
484      */
485     function getRoleAdmin(bytes32 role) external view returns (bytes32);
486 
487     /**
488      * @dev Grants `role` to `account`.
489      *
490      * If `account` had not been already granted `role`, emits a {RoleGranted}
491      * event.
492      *
493      * Requirements:
494      *
495      * - the caller must have ``role``'s admin role.
496      */
497     function grantRole(bytes32 role, address account) external;
498 
499     /**
500      * @dev Revokes `role` from `account`.
501      *
502      * If `account` had been granted `role`, emits a {RoleRevoked} event.
503      *
504      * Requirements:
505      *
506      * - the caller must have ``role``'s admin role.
507      */
508     function revokeRole(bytes32 role, address account) external;
509 
510     /**
511      * @dev Revokes `role` from the calling account.
512      *
513      * Roles are often managed via {grantRole} and {revokeRole}: this function's
514      * purpose is to provide a mechanism for accounts to lose their privileges
515      * if they are compromised (such as when a trusted device is misplaced).
516      *
517      * If the calling account had been granted `role`, emits a {RoleRevoked}
518      * event.
519      *
520      * Requirements:
521      *
522      * - the caller must be `account`.
523      */
524     function renounceRole(bytes32 role, address account) external;
525 }
526 
527 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
536  */
537 interface IAccessControlEnumerable is IAccessControl {
538     /**
539      * @dev Returns one of the accounts that have `role`. `index` must be a
540      * value between 0 and {getRoleMemberCount}, non-inclusive.
541      *
542      * Role bearers are not sorted in any particular way, and their ordering may
543      * change at any point.
544      *
545      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
546      * you perform all queries on the same block. See the following
547      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
548      * for more information.
549      */
550     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
551 
552     /**
553      * @dev Returns the number of accounts that have `role`. Can be used
554      * together with {getRoleMember} to enumerate all bearers of a role.
555      */
556     function getRoleMemberCount(bytes32 role) external view returns (uint256);
557 }
558 
559 // File: @openzeppelin/contracts/utils/Strings.sol
560 
561 
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev String operations.
567  */
568 library Strings {
569     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
573      */
574     function toString(uint256 value) internal pure returns (string memory) {
575         // Inspired by OraclizeAPI's implementation - MIT licence
576         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
577 
578         if (value == 0) {
579             return "0";
580         }
581         uint256 temp = value;
582         uint256 digits;
583         while (temp != 0) {
584             digits++;
585             temp /= 10;
586         }
587         bytes memory buffer = new bytes(digits);
588         while (value != 0) {
589             digits -= 1;
590             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
591             value /= 10;
592         }
593         return string(buffer);
594     }
595 
596     /**
597      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
598      */
599     function toHexString(uint256 value) internal pure returns (string memory) {
600         if (value == 0) {
601             return "0x00";
602         }
603         uint256 temp = value;
604         uint256 length = 0;
605         while (temp != 0) {
606             length++;
607             temp >>= 8;
608         }
609         return toHexString(value, length);
610     }
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
614      */
615     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
616         bytes memory buffer = new bytes(2 * length + 2);
617         buffer[0] = "0";
618         buffer[1] = "x";
619         for (uint256 i = 2 * length + 1; i > 1; --i) {
620             buffer[i] = _HEX_SYMBOLS[value & 0xf];
621             value >>= 4;
622         }
623         require(value == 0, "Strings: hex length insufficient");
624         return string(buffer);
625     }
626 }
627 
628 // File: @openzeppelin/contracts/utils/Context.sol
629 
630 
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Provides information about the current execution context, including the
636  * sender of the transaction and its data. While these are generally available
637  * via msg.sender and msg.data, they should not be accessed in such a direct
638  * manner, since when dealing with meta-transactions the account sending and
639  * paying for execution may not be the actual sender (as far as an application
640  * is concerned).
641  *
642  * This contract is only required for intermediate, library-like contracts.
643  */
644 abstract contract Context {
645     function _msgSender() internal view virtual returns (address) {
646         return msg.sender;
647     }
648 
649     function _msgData() internal view virtual returns (bytes calldata) {
650         return msg.data;
651     }
652 }
653 
654 // File: @openzeppelin/contracts/access/Ownable.sol
655 
656 
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /**
662  * @dev Contract module which provides a basic access control mechanism, where
663  * there is an account (an owner) that can be granted exclusive access to
664  * specific functions.
665  *
666  * By default, the owner account will be the one that deploys the contract. This
667  * can later be changed with {transferOwnership}.
668  *
669  * This module is used through inheritance. It will make available the modifier
670  * `onlyOwner`, which can be applied to your functions to restrict their use to
671  * the owner.
672  */
673 abstract contract Ownable is Context {
674     address private _owner;
675 
676     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
677 
678     /**
679      * @dev Initializes the contract setting the deployer as the initial owner.
680      */
681     constructor() {
682         _setOwner(_msgSender());
683     }
684 
685     /**
686      * @dev Returns the address of the current owner.
687      */
688     function owner() public view virtual returns (address) {
689         return _owner;
690     }
691 
692     /**
693      * @dev Throws if called by any account other than the owner.
694      */
695     modifier onlyOwner() {
696         require(owner() == _msgSender(), "Ownable: caller is not the owner");
697         _;
698     }
699 
700     /**
701      * @dev Leaves the contract without owner. It will not be possible to call
702      * `onlyOwner` functions anymore. Can only be called by the current owner.
703      *
704      * NOTE: Renouncing ownership will leave the contract without an owner,
705      * thereby removing any functionality that is only available to the owner.
706      */
707     function renounceOwnership() public virtual onlyOwner {
708         _setOwner(address(0));
709     }
710 
711     /**
712      * @dev Transfers ownership of the contract to a new account (`newOwner`).
713      * Can only be called by the current owner.
714      */
715     function transferOwnership(address newOwner) public virtual onlyOwner {
716         require(newOwner != address(0), "Ownable: new owner is the zero address");
717         _setOwner(newOwner);
718     }
719 
720     function _setOwner(address newOwner) private {
721         address oldOwner = _owner;
722         _owner = newOwner;
723         emit OwnershipTransferred(oldOwner, newOwner);
724     }
725 }
726 
727 // File: @openzeppelin/contracts/security/Pausable.sol
728 
729 
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @dev Contract module which allows children to implement an emergency stop
736  * mechanism that can be triggered by an authorized account.
737  *
738  * This module is used through inheritance. It will make available the
739  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
740  * the functions of your contract. Note that they will not be pausable by
741  * simply including this module, only once the modifiers are put in place.
742  */
743 abstract contract Pausable is Context {
744     /**
745      * @dev Emitted when the pause is triggered by `account`.
746      */
747     event Paused(address account);
748 
749     /**
750      * @dev Emitted when the pause is lifted by `account`.
751      */
752     event Unpaused(address account);
753 
754     bool private _paused;
755 
756     /**
757      * @dev Initializes the contract in unpaused state.
758      */
759     constructor() {
760         _paused = false;
761     }
762 
763     /**
764      * @dev Returns true if the contract is paused, and false otherwise.
765      */
766     function paused() public view virtual returns (bool) {
767         return _paused;
768     }
769 
770     /**
771      * @dev Modifier to make a function callable only when the contract is not paused.
772      *
773      * Requirements:
774      *
775      * - The contract must not be paused.
776      */
777     modifier whenNotPaused() {
778         require(!paused(), "Pausable: paused");
779         _;
780     }
781 
782     /**
783      * @dev Modifier to make a function callable only when the contract is paused.
784      *
785      * Requirements:
786      *
787      * - The contract must be paused.
788      */
789     modifier whenPaused() {
790         require(paused(), "Pausable: not paused");
791         _;
792     }
793 
794     /**
795      * @dev Triggers stopped state.
796      *
797      * Requirements:
798      *
799      * - The contract must not be paused.
800      */
801     function _pause() internal virtual whenNotPaused {
802         _paused = true;
803         emit Paused(_msgSender());
804     }
805 
806     /**
807      * @dev Returns to normal state.
808      *
809      * Requirements:
810      *
811      * - The contract must be paused.
812      */
813     function _unpause() internal virtual whenPaused {
814         _paused = false;
815         emit Unpaused(_msgSender());
816     }
817 }
818 
819 // File: @openzeppelin/contracts/utils/Address.sol
820 
821 
822 
823 pragma solidity ^0.8.0;
824 
825 /**
826  * @dev Collection of functions related to the address type
827  */
828 library Address {
829     /**
830      * @dev Returns true if `account` is a contract.
831      *
832      * [IMPORTANT]
833      * ====
834      * It is unsafe to assume that an address for which this function returns
835      * false is an externally-owned account (EOA) and not a contract.
836      *
837      * Among others, `isContract` will return false for the following
838      * types of addresses:
839      *
840      *  - an externally-owned account
841      *  - a contract in construction
842      *  - an address where a contract will be created
843      *  - an address where a contract lived, but was destroyed
844      * ====
845      */
846     function isContract(address account) internal view returns (bool) {
847         // This method relies on extcodesize, which returns 0 for contracts in
848         // construction, since the code is only stored at the end of the
849         // constructor execution.
850 
851         uint256 size;
852         assembly {
853             size := extcodesize(account)
854         }
855         return size > 0;
856     }
857 
858     /**
859      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
860      * `recipient`, forwarding all available gas and reverting on errors.
861      *
862      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
863      * of certain opcodes, possibly making contracts go over the 2300 gas limit
864      * imposed by `transfer`, making them unable to receive funds via
865      * `transfer`. {sendValue} removes this limitation.
866      *
867      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
868      *
869      * IMPORTANT: because control is transferred to `recipient`, care must be
870      * taken to not create reentrancy vulnerabilities. Consider using
871      * {ReentrancyGuard} or the
872      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
873      */
874     function sendValue(address payable recipient, uint256 amount) internal {
875         require(address(this).balance >= amount, "Address: insufficient balance");
876 
877         (bool success, ) = recipient.call{value: amount}("");
878         require(success, "Address: unable to send value, recipient may have reverted");
879     }
880 
881     /**
882      * @dev Performs a Solidity function call using a low level `call`. A
883      * plain `call` is an unsafe replacement for a function call: use this
884      * function instead.
885      *
886      * If `target` reverts with a revert reason, it is bubbled up by this
887      * function (like regular Solidity function calls).
888      *
889      * Returns the raw returned data. To convert to the expected return value,
890      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
891      *
892      * Requirements:
893      *
894      * - `target` must be a contract.
895      * - calling `target` with `data` must not revert.
896      *
897      * _Available since v3.1._
898      */
899     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
900         return functionCall(target, data, "Address: low-level call failed");
901     }
902 
903     /**
904      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
905      * `errorMessage` as a fallback revert reason when `target` reverts.
906      *
907      * _Available since v3.1._
908      */
909     function functionCall(
910         address target,
911         bytes memory data,
912         string memory errorMessage
913     ) internal returns (bytes memory) {
914         return functionCallWithValue(target, data, 0, errorMessage);
915     }
916 
917     /**
918      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
919      * but also transferring `value` wei to `target`.
920      *
921      * Requirements:
922      *
923      * - the calling contract must have an ETH balance of at least `value`.
924      * - the called Solidity function must be `payable`.
925      *
926      * _Available since v3.1._
927      */
928     function functionCallWithValue(
929         address target,
930         bytes memory data,
931         uint256 value
932     ) internal returns (bytes memory) {
933         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
934     }
935 
936     /**
937      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
938      * with `errorMessage` as a fallback revert reason when `target` reverts.
939      *
940      * _Available since v3.1._
941      */
942     function functionCallWithValue(
943         address target,
944         bytes memory data,
945         uint256 value,
946         string memory errorMessage
947     ) internal returns (bytes memory) {
948         require(address(this).balance >= value, "Address: insufficient balance for call");
949         require(isContract(target), "Address: call to non-contract");
950 
951         (bool success, bytes memory returndata) = target.call{value: value}(data);
952         return verifyCallResult(success, returndata, errorMessage);
953     }
954 
955     /**
956      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
957      * but performing a static call.
958      *
959      * _Available since v3.3._
960      */
961     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
962         return functionStaticCall(target, data, "Address: low-level static call failed");
963     }
964 
965     /**
966      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
967      * but performing a static call.
968      *
969      * _Available since v3.3._
970      */
971     function functionStaticCall(
972         address target,
973         bytes memory data,
974         string memory errorMessage
975     ) internal view returns (bytes memory) {
976         require(isContract(target), "Address: static call to non-contract");
977 
978         (bool success, bytes memory returndata) = target.staticcall(data);
979         return verifyCallResult(success, returndata, errorMessage);
980     }
981 
982     /**
983      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
984      * but performing a delegate call.
985      *
986      * _Available since v3.4._
987      */
988     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
989         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
990     }
991 
992     /**
993      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
994      * but performing a delegate call.
995      *
996      * _Available since v3.4._
997      */
998     function functionDelegateCall(
999         address target,
1000         bytes memory data,
1001         string memory errorMessage
1002     ) internal returns (bytes memory) {
1003         require(isContract(target), "Address: delegate call to non-contract");
1004 
1005         (bool success, bytes memory returndata) = target.delegatecall(data);
1006         return verifyCallResult(success, returndata, errorMessage);
1007     }
1008 
1009     /**
1010      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1011      * revert reason using the provided one.
1012      *
1013      * _Available since v4.3._
1014      */
1015     function verifyCallResult(
1016         bool success,
1017         bytes memory returndata,
1018         string memory errorMessage
1019     ) internal pure returns (bytes memory) {
1020         if (success) {
1021             return returndata;
1022         } else {
1023             // Look for revert reason and bubble it up if present
1024             if (returndata.length > 0) {
1025                 // The easiest way to bubble the revert reason is using memory via assembly
1026 
1027                 assembly {
1028                     let returndata_size := mload(returndata)
1029                     revert(add(32, returndata), returndata_size)
1030                 }
1031             } else {
1032                 revert(errorMessage);
1033             }
1034         }
1035     }
1036 }
1037 
1038 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1039 
1040 
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 /**
1045  * @title ERC721 token receiver interface
1046  * @dev Interface for any contract that wants to support safeTransfers
1047  * from ERC721 asset contracts.
1048  */
1049 interface IERC721Receiver {
1050     /**
1051      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1052      * by `operator` from `from`, this function is called.
1053      *
1054      * It must return its Solidity selector to confirm the token transfer.
1055      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1056      *
1057      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1058      */
1059     function onERC721Received(
1060         address operator,
1061         address from,
1062         uint256 tokenId,
1063         bytes calldata data
1064     ) external returns (bytes4);
1065 }
1066 
1067 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1068 
1069 
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 /**
1074  * @dev Interface of the ERC165 standard, as defined in the
1075  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1076  *
1077  * Implementers can declare support of contract interfaces, which can then be
1078  * queried by others ({ERC165Checker}).
1079  *
1080  * For an implementation, see {ERC165}.
1081  */
1082 interface IERC165 {
1083     /**
1084      * @dev Returns true if this contract implements the interface defined by
1085      * `interfaceId`. See the corresponding
1086      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1087      * to learn more about how these ids are created.
1088      *
1089      * This function call must use less than 30 000 gas.
1090      */
1091     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1092 }
1093 
1094 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1095 
1096 
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 
1101 /**
1102  * @dev Implementation of the {IERC165} interface.
1103  *
1104  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1105  * for the additional interface id that will be supported. For example:
1106  *
1107  * ```solidity
1108  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1109  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1110  * }
1111  * ```
1112  *
1113  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1114  */
1115 abstract contract ERC165 is IERC165 {
1116     /**
1117      * @dev See {IERC165-supportsInterface}.
1118      */
1119     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1120         return interfaceId == type(IERC165).interfaceId;
1121     }
1122 }
1123 
1124 // File: @openzeppelin/contracts/access/AccessControl.sol
1125 
1126 
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 
1131 
1132 
1133 
1134 /**
1135  * @dev Contract module that allows children to implement role-based access
1136  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1137  * members except through off-chain means by accessing the contract event logs. Some
1138  * applications may benefit from on-chain enumerability, for those cases see
1139  * {AccessControlEnumerable}.
1140  *
1141  * Roles are referred to by their `bytes32` identifier. These should be exposed
1142  * in the external API and be unique. The best way to achieve this is by
1143  * using `public constant` hash digests:
1144  *
1145  * ```
1146  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1147  * ```
1148  *
1149  * Roles can be used to represent a set of permissions. To restrict access to a
1150  * function call, use {hasRole}:
1151  *
1152  * ```
1153  * function foo() public {
1154  *     require(hasRole(MY_ROLE, msg.sender));
1155  *     ...
1156  * }
1157  * ```
1158  *
1159  * Roles can be granted and revoked dynamically via the {grantRole} and
1160  * {revokeRole} functions. Each role has an associated admin role, and only
1161  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1162  *
1163  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1164  * that only accounts with this role will be able to grant or revoke other
1165  * roles. More complex role relationships can be created by using
1166  * {_setRoleAdmin}.
1167  *
1168  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1169  * grant and revoke this role. Extra precautions should be taken to secure
1170  * accounts that have been granted it.
1171  */
1172 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1173     struct RoleData {
1174         mapping(address => bool) members;
1175         bytes32 adminRole;
1176     }
1177 
1178     mapping(bytes32 => RoleData) private _roles;
1179 
1180     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1181 
1182     /**
1183      * @dev Modifier that checks that an account has a specific role. Reverts
1184      * with a standardized message including the required role.
1185      *
1186      * The format of the revert reason is given by the following regular expression:
1187      *
1188      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1189      *
1190      * _Available since v4.1._
1191      */
1192     modifier onlyRole(bytes32 role) {
1193         _checkRole(role, _msgSender());
1194         _;
1195     }
1196 
1197     /**
1198      * @dev See {IERC165-supportsInterface}.
1199      */
1200     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1201         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1202     }
1203 
1204     /**
1205      * @dev Returns `true` if `account` has been granted `role`.
1206      */
1207     function hasRole(bytes32 role, address account) public view override returns (bool) {
1208         return _roles[role].members[account];
1209     }
1210 
1211     /**
1212      * @dev Revert with a standard message if `account` is missing `role`.
1213      *
1214      * The format of the revert reason is given by the following regular expression:
1215      *
1216      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1217      */
1218     function _checkRole(bytes32 role, address account) internal view {
1219         if (!hasRole(role, account)) {
1220             revert(
1221                 string(
1222                     abi.encodePacked(
1223                         "AccessControl: account ",
1224                         Strings.toHexString(uint160(account), 20),
1225                         " is missing role ",
1226                         Strings.toHexString(uint256(role), 32)
1227                     )
1228                 )
1229             );
1230         }
1231     }
1232 
1233     /**
1234      * @dev Returns the admin role that controls `role`. See {grantRole} and
1235      * {revokeRole}.
1236      *
1237      * To change a role's admin, use {_setRoleAdmin}.
1238      */
1239     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1240         return _roles[role].adminRole;
1241     }
1242 
1243     /**
1244      * @dev Grants `role` to `account`.
1245      *
1246      * If `account` had not been already granted `role`, emits a {RoleGranted}
1247      * event.
1248      *
1249      * Requirements:
1250      *
1251      * - the caller must have ``role``'s admin role.
1252      */
1253     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1254         _grantRole(role, account);
1255     }
1256 
1257     /**
1258      * @dev Revokes `role` from `account`.
1259      *
1260      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1261      *
1262      * Requirements:
1263      *
1264      * - the caller must have ``role``'s admin role.
1265      */
1266     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1267         _revokeRole(role, account);
1268     }
1269 
1270     /**
1271      * @dev Revokes `role` from the calling account.
1272      *
1273      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1274      * purpose is to provide a mechanism for accounts to lose their privileges
1275      * if they are compromised (such as when a trusted device is misplaced).
1276      *
1277      * If the calling account had been granted `role`, emits a {RoleRevoked}
1278      * event.
1279      *
1280      * Requirements:
1281      *
1282      * - the caller must be `account`.
1283      */
1284     function renounceRole(bytes32 role, address account) public virtual override {
1285         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1286 
1287         _revokeRole(role, account);
1288     }
1289 
1290     /**
1291      * @dev Grants `role` to `account`.
1292      *
1293      * If `account` had not been already granted `role`, emits a {RoleGranted}
1294      * event. Note that unlike {grantRole}, this function doesn't perform any
1295      * checks on the calling account.
1296      *
1297      * [WARNING]
1298      * ====
1299      * This function should only be called from the constructor when setting
1300      * up the initial roles for the system.
1301      *
1302      * Using this function in any other way is effectively circumventing the admin
1303      * system imposed by {AccessControl}.
1304      * ====
1305      */
1306     function _setupRole(bytes32 role, address account) internal virtual {
1307         _grantRole(role, account);
1308     }
1309 
1310     /**
1311      * @dev Sets `adminRole` as ``role``'s admin role.
1312      *
1313      * Emits a {RoleAdminChanged} event.
1314      */
1315     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1316         bytes32 previousAdminRole = getRoleAdmin(role);
1317         _roles[role].adminRole = adminRole;
1318         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1319     }
1320 
1321     function _grantRole(bytes32 role, address account) private {
1322         if (!hasRole(role, account)) {
1323             _roles[role].members[account] = true;
1324             emit RoleGranted(role, account, _msgSender());
1325         }
1326     }
1327 
1328     function _revokeRole(bytes32 role, address account) private {
1329         if (hasRole(role, account)) {
1330             _roles[role].members[account] = false;
1331             emit RoleRevoked(role, account, _msgSender());
1332         }
1333     }
1334 }
1335 
1336 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1337 
1338 
1339 
1340 pragma solidity ^0.8.0;
1341 
1342 
1343 
1344 
1345 /**
1346  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1347  */
1348 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1349     using EnumerableSet for EnumerableSet.AddressSet;
1350 
1351     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1352 
1353     /**
1354      * @dev See {IERC165-supportsInterface}.
1355      */
1356     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1357         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1358     }
1359 
1360     /**
1361      * @dev Returns one of the accounts that have `role`. `index` must be a
1362      * value between 0 and {getRoleMemberCount}, non-inclusive.
1363      *
1364      * Role bearers are not sorted in any particular way, and their ordering may
1365      * change at any point.
1366      *
1367      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1368      * you perform all queries on the same block. See the following
1369      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1370      * for more information.
1371      */
1372     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1373         return _roleMembers[role].at(index);
1374     }
1375 
1376     /**
1377      * @dev Returns the number of accounts that have `role`. Can be used
1378      * together with {getRoleMember} to enumerate all bearers of a role.
1379      */
1380     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1381         return _roleMembers[role].length();
1382     }
1383 
1384     /**
1385      * @dev Overload {grantRole} to track enumerable memberships
1386      */
1387     function grantRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1388         super.grantRole(role, account);
1389         _roleMembers[role].add(account);
1390     }
1391 
1392     /**
1393      * @dev Overload {revokeRole} to track enumerable memberships
1394      */
1395     function revokeRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1396         super.revokeRole(role, account);
1397         _roleMembers[role].remove(account);
1398     }
1399 
1400     /**
1401      * @dev Overload {renounceRole} to track enumerable memberships
1402      */
1403     function renounceRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
1404         super.renounceRole(role, account);
1405         _roleMembers[role].remove(account);
1406     }
1407 
1408     /**
1409      * @dev Overload {_setupRole} to track enumerable memberships
1410      */
1411     function _setupRole(bytes32 role, address account) internal virtual override {
1412         super._setupRole(role, account);
1413         _roleMembers[role].add(account);
1414     }
1415 }
1416 
1417 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1418 
1419 
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 
1424 /**
1425  * @dev Required interface of an ERC721 compliant contract.
1426  */
1427 interface IERC721 is IERC165 {
1428     /**
1429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1430      */
1431     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1432 
1433     /**
1434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1435      */
1436     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1437 
1438     /**
1439      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1440      */
1441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1442 
1443     /**
1444      * @dev Returns the number of tokens in ``owner``'s account.
1445      */
1446     function balanceOf(address owner) external view returns (uint256 balance);
1447 
1448     /**
1449      * @dev Returns the owner of the `tokenId` token.
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must exist.
1454      */
1455     function ownerOf(uint256 tokenId) external view returns (address owner);
1456 
1457     /**
1458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1460      *
1461      * Requirements:
1462      *
1463      * - `from` cannot be the zero address.
1464      * - `to` cannot be the zero address.
1465      * - `tokenId` token must exist and be owned by `from`.
1466      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1468      *
1469      * Emits a {Transfer} event.
1470      */
1471     function safeTransferFrom(
1472         address from,
1473         address to,
1474         uint256 tokenId
1475     ) external;
1476 
1477     /**
1478      * @dev Transfers `tokenId` token from `from` to `to`.
1479      *
1480      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1481      *
1482      * Requirements:
1483      *
1484      * - `from` cannot be the zero address.
1485      * - `to` cannot be the zero address.
1486      * - `tokenId` token must be owned by `from`.
1487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1488      *
1489      * Emits a {Transfer} event.
1490      */
1491     function transferFrom(
1492         address from,
1493         address to,
1494         uint256 tokenId
1495     ) external;
1496 
1497     /**
1498      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1499      * The approval is cleared when the token is transferred.
1500      *
1501      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1502      *
1503      * Requirements:
1504      *
1505      * - The caller must own the token or be an approved operator.
1506      * - `tokenId` must exist.
1507      *
1508      * Emits an {Approval} event.
1509      */
1510     function approve(address to, uint256 tokenId) external;
1511 
1512     /**
1513      * @dev Returns the account approved for `tokenId` token.
1514      *
1515      * Requirements:
1516      *
1517      * - `tokenId` must exist.
1518      */
1519     function getApproved(uint256 tokenId) external view returns (address operator);
1520 
1521     /**
1522      * @dev Approve or remove `operator` as an operator for the caller.
1523      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1524      *
1525      * Requirements:
1526      *
1527      * - The `operator` cannot be the caller.
1528      *
1529      * Emits an {ApprovalForAll} event.
1530      */
1531     function setApprovalForAll(address operator, bool _approved) external;
1532 
1533     /**
1534      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1535      *
1536      * See {setApprovalForAll}
1537      */
1538     function isApprovedForAll(address owner, address operator) external view returns (bool);
1539 
1540     /**
1541      * @dev Safely transfers `tokenId` token from `from` to `to`.
1542      *
1543      * Requirements:
1544      *
1545      * - `from` cannot be the zero address.
1546      * - `to` cannot be the zero address.
1547      * - `tokenId` token must exist and be owned by `from`.
1548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1550      *
1551      * Emits a {Transfer} event.
1552      */
1553     function safeTransferFrom(
1554         address from,
1555         address to,
1556         uint256 tokenId,
1557         bytes calldata data
1558     ) external;
1559 }
1560 
1561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1562 
1563 
1564 
1565 pragma solidity ^0.8.0;
1566 
1567 
1568 /**
1569  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1570  * @dev See https://eips.ethereum.org/EIPS/eip-721
1571  */
1572 interface IERC721Enumerable is IERC721 {
1573     /**
1574      * @dev Returns the total amount of tokens stored by the contract.
1575      */
1576     function totalSupply() external view returns (uint256);
1577 
1578     /**
1579      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1580      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1581      */
1582     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1583 
1584     /**
1585      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1586      * Use along with {totalSupply} to enumerate all tokens.
1587      */
1588     function tokenByIndex(uint256 index) external view returns (uint256);
1589 }
1590 
1591 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1592 
1593 
1594 
1595 pragma solidity ^0.8.0;
1596 
1597 
1598 /**
1599  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1600  * @dev See https://eips.ethereum.org/EIPS/eip-721
1601  */
1602 interface IERC721Metadata is IERC721 {
1603     /**
1604      * @dev Returns the token collection name.
1605      */
1606     function name() external view returns (string memory);
1607 
1608     /**
1609      * @dev Returns the token collection symbol.
1610      */
1611     function symbol() external view returns (string memory);
1612 
1613     /**
1614      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1615      */
1616     function tokenURI(uint256 tokenId) external view returns (string memory);
1617 }
1618 
1619 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1620 
1621 
1622 
1623 pragma solidity ^0.8.0;
1624 
1625 
1626 
1627 
1628 
1629 
1630 
1631 
1632 /**
1633  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1634  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1635  * {ERC721Enumerable}.
1636  */
1637 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1638     using Address for address;
1639     using Strings for uint256;
1640 
1641     // Token name
1642     string private _name;
1643 
1644     // Token symbol
1645     string private _symbol;
1646 
1647     // Mapping from token ID to owner address
1648     mapping(uint256 => address) private _owners;
1649 
1650     // Mapping owner address to token count
1651     mapping(address => uint256) private _balances;
1652 
1653     // Mapping from token ID to approved address
1654     mapping(uint256 => address) private _tokenApprovals;
1655 
1656     // Mapping from owner to operator approvals
1657     mapping(address => mapping(address => bool)) private _operatorApprovals;
1658 
1659     /**
1660      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1661      */
1662     constructor(string memory name_, string memory symbol_) {
1663         _name = name_;
1664         _symbol = symbol_;
1665     }
1666 
1667     /**
1668      * @dev See {IERC165-supportsInterface}.
1669      */
1670     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1671         return
1672             interfaceId == type(IERC721).interfaceId ||
1673             interfaceId == type(IERC721Metadata).interfaceId ||
1674             super.supportsInterface(interfaceId);
1675     }
1676 
1677     /**
1678      * @dev See {IERC721-balanceOf}.
1679      */
1680     function balanceOf(address owner) public view virtual override returns (uint256) {
1681         require(owner != address(0), "ERC721: balance query for the zero address");
1682         return _balances[owner];
1683     }
1684 
1685     /**
1686      * @dev See {IERC721-ownerOf}.
1687      */
1688     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1689         address owner = _owners[tokenId];
1690         require(owner != address(0), "ERC721: owner query for nonexistent token");
1691         return owner;
1692     }
1693 
1694     /**
1695      * @dev See {IERC721Metadata-name}.
1696      */
1697     function name() public view virtual override returns (string memory) {
1698         return _name;
1699     }
1700 
1701     /**
1702      * @dev See {IERC721Metadata-symbol}.
1703      */
1704     function symbol() public view virtual override returns (string memory) {
1705         return _symbol;
1706     }
1707 
1708     /**
1709      * @dev See {IERC721Metadata-tokenURI}.
1710      */
1711     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1712         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1713 
1714         string memory baseURI = _baseURI();
1715         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1716     }
1717 
1718     /**
1719      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1720      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1721      * by default, can be overriden in child contracts.
1722      */
1723     function _baseURI() internal view virtual returns (string memory) {
1724         return "";
1725     }
1726 
1727     /**
1728      * @dev See {IERC721-approve}.
1729      */
1730     function approve(address to, uint256 tokenId) public virtual override {
1731         address owner = ERC721.ownerOf(tokenId);
1732         require(to != owner, "ERC721: approval to current owner");
1733 
1734         require(
1735             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1736             "ERC721: approve caller is not owner nor approved for all"
1737         );
1738 
1739         _approve(to, tokenId);
1740     }
1741 
1742     /**
1743      * @dev See {IERC721-getApproved}.
1744      */
1745     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1746         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1747 
1748         return _tokenApprovals[tokenId];
1749     }
1750 
1751     /**
1752      * @dev See {IERC721-setApprovalForAll}.
1753      */
1754     function setApprovalForAll(address operator, bool approved) public virtual override {
1755         require(operator != _msgSender(), "ERC721: approve to caller");
1756 
1757         _operatorApprovals[_msgSender()][operator] = approved;
1758         emit ApprovalForAll(_msgSender(), operator, approved);
1759     }
1760 
1761     /**
1762      * @dev See {IERC721-isApprovedForAll}.
1763      */
1764     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1765         return _operatorApprovals[owner][operator];
1766     }
1767 
1768     /**
1769      * @dev See {IERC721-transferFrom}.
1770      */
1771     function transferFrom(
1772         address from,
1773         address to,
1774         uint256 tokenId
1775     ) public virtual override {
1776         //solhint-disable-next-line max-line-length
1777         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1778 
1779         _transfer(from, to, tokenId);
1780     }
1781 
1782     /**
1783      * @dev See {IERC721-safeTransferFrom}.
1784      */
1785     function safeTransferFrom(
1786         address from,
1787         address to,
1788         uint256 tokenId
1789     ) public virtual override {
1790         safeTransferFrom(from, to, tokenId, "");
1791     }
1792 
1793     /**
1794      * @dev See {IERC721-safeTransferFrom}.
1795      */
1796     function safeTransferFrom(
1797         address from,
1798         address to,
1799         uint256 tokenId,
1800         bytes memory _data
1801     ) public virtual override {
1802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1803         _safeTransfer(from, to, tokenId, _data);
1804     }
1805 
1806     /**
1807      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1808      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1809      *
1810      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1811      *
1812      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1813      * implement alternative mechanisms to perform token transfer, such as signature-based.
1814      *
1815      * Requirements:
1816      *
1817      * - `from` cannot be the zero address.
1818      * - `to` cannot be the zero address.
1819      * - `tokenId` token must exist and be owned by `from`.
1820      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1821      *
1822      * Emits a {Transfer} event.
1823      */
1824     function _safeTransfer(
1825         address from,
1826         address to,
1827         uint256 tokenId,
1828         bytes memory _data
1829     ) internal virtual {
1830         _transfer(from, to, tokenId);
1831         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1832     }
1833 
1834     /**
1835      * @dev Returns whether `tokenId` exists.
1836      *
1837      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1838      *
1839      * Tokens start existing when they are minted (`_mint`),
1840      * and stop existing when they are burned (`_burn`).
1841      */
1842     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1843         return _owners[tokenId] != address(0);
1844     }
1845 
1846     /**
1847      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1848      *
1849      * Requirements:
1850      *
1851      * - `tokenId` must exist.
1852      */
1853     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1854         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1855         address owner = ERC721.ownerOf(tokenId);
1856         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1857     }
1858 
1859     /**
1860      * @dev Safely mints `tokenId` and transfers it to `to`.
1861      *
1862      * Requirements:
1863      *
1864      * - `tokenId` must not exist.
1865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1866      *
1867      * Emits a {Transfer} event.
1868      */
1869     function _safeMint(address to, uint256 tokenId) internal virtual {
1870         _safeMint(to, tokenId, "");
1871     }
1872 
1873     /**
1874      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1875      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1876      */
1877     function _safeMint(
1878         address to,
1879         uint256 tokenId,
1880         bytes memory _data
1881     ) internal virtual {
1882         _mint(to, tokenId);
1883         require(
1884             _checkOnERC721Received(address(0), to, tokenId, _data),
1885             "ERC721: transfer to non ERC721Receiver implementer"
1886         );
1887     }
1888 
1889     /**
1890      * @dev Mints `tokenId` and transfers it to `to`.
1891      *
1892      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1893      *
1894      * Requirements:
1895      *
1896      * - `tokenId` must not exist.
1897      * - `to` cannot be the zero address.
1898      *
1899      * Emits a {Transfer} event.
1900      */
1901     function _mint(address to, uint256 tokenId) internal virtual {
1902         require(to != address(0), "ERC721: mint to the zero address");
1903         require(!_exists(tokenId), "ERC721: token already minted");
1904 
1905         _beforeTokenTransfer(address(0), to, tokenId);
1906 
1907         _balances[to] += 1;
1908         _owners[tokenId] = to;
1909 
1910         emit Transfer(address(0), to, tokenId);
1911     }
1912 
1913     /**
1914      * @dev Destroys `tokenId`.
1915      * The approval is cleared when the token is burned.
1916      *
1917      * Requirements:
1918      *
1919      * - `tokenId` must exist.
1920      *
1921      * Emits a {Transfer} event.
1922      */
1923     function _burn(uint256 tokenId) internal virtual {
1924         address owner = ERC721.ownerOf(tokenId);
1925 
1926         _beforeTokenTransfer(owner, address(0), tokenId);
1927 
1928         // Clear approvals
1929         _approve(address(0), tokenId);
1930 
1931         _balances[owner] -= 1;
1932         delete _owners[tokenId];
1933 
1934         emit Transfer(owner, address(0), tokenId);
1935     }
1936 
1937     /**
1938      * @dev Transfers `tokenId` from `from` to `to`.
1939      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1940      *
1941      * Requirements:
1942      *
1943      * - `to` cannot be the zero address.
1944      * - `tokenId` token must be owned by `from`.
1945      *
1946      * Emits a {Transfer} event.
1947      */
1948     function _transfer(
1949         address from,
1950         address to,
1951         uint256 tokenId
1952     ) internal virtual {
1953         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1954         require(to != address(0), "ERC721: transfer to the zero address");
1955 
1956         _beforeTokenTransfer(from, to, tokenId);
1957 
1958         // Clear approvals from the previous owner
1959         _approve(address(0), tokenId);
1960 
1961         _balances[from] -= 1;
1962         _balances[to] += 1;
1963         _owners[tokenId] = to;
1964 
1965         emit Transfer(from, to, tokenId);
1966     }
1967 
1968     /**
1969      * @dev Approve `to` to operate on `tokenId`
1970      *
1971      * Emits a {Approval} event.
1972      */
1973     function _approve(address to, uint256 tokenId) internal virtual {
1974         _tokenApprovals[tokenId] = to;
1975         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1976     }
1977 
1978     /**
1979      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1980      * The call is not executed if the target address is not a contract.
1981      *
1982      * @param from address representing the previous owner of the given token ID
1983      * @param to target address that will receive the tokens
1984      * @param tokenId uint256 ID of the token to be transferred
1985      * @param _data bytes optional data to send along with the call
1986      * @return bool whether the call correctly returned the expected magic value
1987      */
1988     function _checkOnERC721Received(
1989         address from,
1990         address to,
1991         uint256 tokenId,
1992         bytes memory _data
1993     ) private returns (bool) {
1994         if (to.isContract()) {
1995             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1996                 return retval == IERC721Receiver.onERC721Received.selector;
1997             } catch (bytes memory reason) {
1998                 if (reason.length == 0) {
1999                     revert("ERC721: transfer to non ERC721Receiver implementer");
2000                 } else {
2001                     assembly {
2002                         revert(add(32, reason), mload(reason))
2003                     }
2004                 }
2005             }
2006         } else {
2007             return true;
2008         }
2009     }
2010 
2011     /**
2012      * @dev Hook that is called before any token transfer. This includes minting
2013      * and burning.
2014      *
2015      * Calling conditions:
2016      *
2017      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2018      * transferred to `to`.
2019      * - When `from` is zero, `tokenId` will be minted for `to`.
2020      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2021      * - `from` and `to` are never both zero.
2022      *
2023      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2024      */
2025     function _beforeTokenTransfer(
2026         address from,
2027         address to,
2028         uint256 tokenId
2029     ) internal virtual {}
2030 }
2031 
2032 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
2033 
2034 
2035 
2036 pragma solidity ^0.8.0;
2037 
2038 
2039 
2040 /**
2041  * @dev ERC721 token with pausable token transfers, minting and burning.
2042  *
2043  * Useful for scenarios such as preventing trades until the end of an evaluation
2044  * period, or having an emergency switch for freezing all token transfers in the
2045  * event of a large bug.
2046  */
2047 abstract contract ERC721Pausable is ERC721, Pausable {
2048     /**
2049      * @dev See {ERC721-_beforeTokenTransfer}.
2050      *
2051      * Requirements:
2052      *
2053      * - the contract must not be paused.
2054      */
2055     function _beforeTokenTransfer(
2056         address from,
2057         address to,
2058         uint256 tokenId
2059     ) internal virtual override {
2060         super._beforeTokenTransfer(from, to, tokenId);
2061 
2062         require(!paused(), "ERC721Pausable: token transfer while paused");
2063     }
2064 }
2065 
2066 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
2067 
2068 
2069 
2070 pragma solidity ^0.8.0;
2071 
2072 
2073 
2074 /**
2075  * @title ERC721 Burnable Token
2076  * @dev ERC721 Token that can be irreversibly burned (destroyed).
2077  */
2078 abstract contract ERC721Burnable is Context, ERC721 {
2079     /**
2080      * @dev Burns `tokenId`. See {ERC721-_burn}.
2081      *
2082      * Requirements:
2083      *
2084      * - The caller must own `tokenId` or be an approved operator.
2085      */
2086     function burn(uint256 tokenId) public virtual {
2087         //solhint-disable-next-line max-line-length
2088         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
2089         _burn(tokenId);
2090     }
2091 }
2092 
2093 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2094 
2095 
2096 
2097 pragma solidity ^0.8.0;
2098 
2099 
2100 
2101 /**
2102  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2103  * enumerability of all the token ids in the contract as well as all token ids owned by each
2104  * account.
2105  */
2106 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2107     // Mapping from owner to list of owned token IDs
2108     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2109 
2110     // Mapping from token ID to index of the owner tokens list
2111     mapping(uint256 => uint256) private _ownedTokensIndex;
2112 
2113     // Array with all token ids, used for enumeration
2114     uint256[] private _allTokens;
2115 
2116     // Mapping from token id to position in the allTokens array
2117     mapping(uint256 => uint256) private _allTokensIndex;
2118 
2119     /**
2120      * @dev See {IERC165-supportsInterface}.
2121      */
2122     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2123         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2124     }
2125 
2126     /**
2127      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2128      */
2129     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2130         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2131         return _ownedTokens[owner][index];
2132     }
2133 
2134     /**
2135      * @dev See {IERC721Enumerable-totalSupply}.
2136      */
2137     function totalSupply() public view virtual override returns (uint256) {
2138         return _allTokens.length;
2139     }
2140 
2141     /**
2142      * @dev See {IERC721Enumerable-tokenByIndex}.
2143      */
2144     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2145         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2146         return _allTokens[index];
2147     }
2148 
2149     /**
2150      * @dev Hook that is called before any token transfer. This includes minting
2151      * and burning.
2152      *
2153      * Calling conditions:
2154      *
2155      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2156      * transferred to `to`.
2157      * - When `from` is zero, `tokenId` will be minted for `to`.
2158      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2159      * - `from` cannot be the zero address.
2160      * - `to` cannot be the zero address.
2161      *
2162      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2163      */
2164     function _beforeTokenTransfer(
2165         address from,
2166         address to,
2167         uint256 tokenId
2168     ) internal virtual override {
2169         super._beforeTokenTransfer(from, to, tokenId);
2170 
2171         if (from == address(0)) {
2172             _addTokenToAllTokensEnumeration(tokenId);
2173         } else if (from != to) {
2174             _removeTokenFromOwnerEnumeration(from, tokenId);
2175         }
2176         if (to == address(0)) {
2177             _removeTokenFromAllTokensEnumeration(tokenId);
2178         } else if (to != from) {
2179             _addTokenToOwnerEnumeration(to, tokenId);
2180         }
2181     }
2182 
2183     /**
2184      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2185      * @param to address representing the new owner of the given token ID
2186      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2187      */
2188     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2189         uint256 length = ERC721.balanceOf(to);
2190         _ownedTokens[to][length] = tokenId;
2191         _ownedTokensIndex[tokenId] = length;
2192     }
2193 
2194     /**
2195      * @dev Private function to add a token to this extension's token tracking data structures.
2196      * @param tokenId uint256 ID of the token to be added to the tokens list
2197      */
2198     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2199         _allTokensIndex[tokenId] = _allTokens.length;
2200         _allTokens.push(tokenId);
2201     }
2202 
2203     /**
2204      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2205      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2206      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2207      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2208      * @param from address representing the previous owner of the given token ID
2209      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2210      */
2211     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2212         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2213         // then delete the last slot (swap and pop).
2214 
2215         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2216         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2217 
2218         // When the token to delete is the last token, the swap operation is unnecessary
2219         if (tokenIndex != lastTokenIndex) {
2220             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2221 
2222             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2223             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2224         }
2225 
2226         // This also deletes the contents at the last position of the array
2227         delete _ownedTokensIndex[tokenId];
2228         delete _ownedTokens[from][lastTokenIndex];
2229     }
2230 
2231     /**
2232      * @dev Private function to remove a token from this extension's token tracking data structures.
2233      * This has O(1) time complexity, but alters the order of the _allTokens array.
2234      * @param tokenId uint256 ID of the token to be removed from the tokens list
2235      */
2236     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2237         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2238         // then delete the last slot (swap and pop).
2239 
2240         uint256 lastTokenIndex = _allTokens.length - 1;
2241         uint256 tokenIndex = _allTokensIndex[tokenId];
2242 
2243         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2244         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2245         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2246         uint256 lastTokenId = _allTokens[lastTokenIndex];
2247 
2248         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2249         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2250 
2251         // This also deletes the contents at the last position of the array
2252         delete _allTokensIndex[tokenId];
2253         _allTokens.pop();
2254     }
2255 }
2256 
2257 // File: @openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol
2258 
2259 
2260 
2261 pragma solidity ^0.8.0;
2262 
2263 
2264 
2265 
2266 
2267 
2268 
2269 
2270 /**
2271  * @dev {ERC721} token, including:
2272  *
2273  *  - ability for holders to burn (destroy) their tokens
2274  *  - a minter role that allows for token minting (creation)
2275  *  - a pauser role that allows to stop all token transfers
2276  *  - token ID and URI autogeneration
2277  *
2278  * This contract uses {AccessControl} to lock permissioned functions using the
2279  * different roles - head to its documentation for details.
2280  *
2281  * The account that deploys the contract will be granted the minter and pauser
2282  * roles, as well as the default admin role, which will let it grant both minter
2283  * and pauser roles to other accounts.
2284  */
2285 contract ERC721PresetMinterPauserAutoId is
2286     Context,
2287     AccessControlEnumerable,
2288     ERC721Enumerable,
2289     ERC721Burnable,
2290     ERC721Pausable
2291 {
2292     using Counters for Counters.Counter;
2293 
2294     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2295     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2296 
2297     Counters.Counter private _tokenIdTracker;
2298 
2299     string private _baseTokenURI;
2300 
2301     /**
2302      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2303      * account that deploys the contract.
2304      *
2305      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2306      * See {ERC721-tokenURI}.
2307      */
2308     constructor(
2309         string memory name,
2310         string memory symbol,
2311         string memory baseTokenURI
2312     ) ERC721(name, symbol) {
2313         _baseTokenURI = baseTokenURI;
2314 
2315         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2316 
2317         _setupRole(MINTER_ROLE, _msgSender());
2318         _setupRole(PAUSER_ROLE, _msgSender());
2319     }
2320 
2321     function _baseURI() internal view virtual override returns (string memory) {
2322         return _baseTokenURI;
2323     }
2324 
2325     /**
2326      * @dev Creates a new token for `to`. Its token ID will be automatically
2327      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2328      * URI autogenerated based on the base URI passed at construction.
2329      *
2330      * See {ERC721-_mint}.
2331      *
2332      * Requirements:
2333      *
2334      * - the caller must have the `MINTER_ROLE`.
2335      */
2336     function mint(address to) public virtual {
2337         require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
2338 
2339         // We cannot just use balanceOf to create the new tokenId because tokens
2340         // can be burned (destroyed), so we need a separate counter.
2341         _mint(to, _tokenIdTracker.current());
2342         _tokenIdTracker.increment();
2343     }
2344 
2345     /**
2346      * @dev Pauses all token transfers.
2347      *
2348      * See {ERC721Pausable} and {Pausable-_pause}.
2349      *
2350      * Requirements:
2351      *
2352      * - the caller must have the `PAUSER_ROLE`.
2353      */
2354     function pause() public virtual {
2355         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to pause");
2356         _pause();
2357     }
2358 
2359     /**
2360      * @dev Unpauses all token transfers.
2361      *
2362      * See {ERC721Pausable} and {Pausable-_unpause}.
2363      *
2364      * Requirements:
2365      *
2366      * - the caller must have the `PAUSER_ROLE`.
2367      */
2368     function unpause() public virtual {
2369         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to unpause");
2370         _unpause();
2371     }
2372 
2373     function _beforeTokenTransfer(
2374         address from,
2375         address to,
2376         uint256 tokenId
2377     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
2378         super._beforeTokenTransfer(from, to, tokenId);
2379     }
2380 
2381     /**
2382      * @dev See {IERC165-supportsInterface}.
2383      */
2384     function supportsInterface(bytes4 interfaceId)
2385         public
2386         view
2387         virtual
2388         override(AccessControlEnumerable, ERC721, ERC721Enumerable)
2389         returns (bool)
2390     {
2391         return super.supportsInterface(interfaceId);
2392     }
2393 }
2394 
2395 // File: contracts/NFT/NftSquid.sol
2396 
2397 
2398 pragma solidity ^0.8.0;
2399 
2400 
2401 
2402 
2403 contract NftSquid is ERC721PresetMinterPauserAutoId, Ownable {
2404     uint256 private constant HALF_YEAR = 180 days;
2405     uint256 private constant MULTIPLIER = 1e18;
2406     uint256 internal constant BURN_DISCOUNT = 40;
2407     uint256 internal constant BONUS_PERPAX = 1500 * 10**18;
2408     uint256 internal constant BASE_AMOUNT = 3000 * 10**18;
2409     uint256 public constant price = 0.45 ether;
2410     // uint256 public constant price = 0.001 ether; // for test
2411 
2412     uint256 public vaultAmount;
2413     uint256 public squidStartTime;
2414     uint256 public nftStartTime;
2415     uint256 public nftEndTime;
2416 
2417     uint256 public remainOwners;
2418     uint256 public constant MAX_PLAYERS = 4560;
2419 
2420     uint256 public id;
2421     address public token;
2422     uint256 public totalEth;
2423 
2424     // reserved for whitelist address
2425     mapping(address => bool) public reserved;
2426     // left reserved that not claim yet
2427     uint16 public reservedCount;
2428     // if turn to false, then all reserved will become invalid
2429     bool public reservedOn = true;
2430     // This is a packed array of booleans.
2431     mapping(uint256 => uint256) private claimedBitMap;
2432 
2433     event Mint(address indexed owner, uint256 tokenId);
2434     event Burn(uint256 tokenId, uint256 withdrawAmount, address indexed sender);
2435 
2436     constructor(
2437         string memory _name,
2438         string memory _symbol,
2439         string memory _baseTokenURI,
2440         address _token,
2441         uint256 _nftStartTime,
2442         uint256 _nftEndTime
2443     ) ERC721PresetMinterPauserAutoId(_name, _symbol, _baseTokenURI) {
2444         token = _token;
2445         nftStartTime = _nftStartTime;
2446         nftEndTime = _nftEndTime;
2447         _mint(msg.sender, MAX_PLAYERS);
2448     }
2449 
2450     function setReservedOff() external onlyOwner {
2451         reservedOn = false;
2452     }
2453 
2454     function addToReserved(address[] memory list) external onlyOwner {
2455         require(block.timestamp < nftEndTime, "NFT_SALE_TIME_END");
2456         for (uint16 i = 0; i < list.length; i++) {
2457             if (!reserved[list[i]]) {
2458                 reserved[list[i]] = true;
2459                 reservedCount++;
2460             }
2461         }
2462     }
2463 
2464     function removeFromReserved(address[] memory list) external onlyOwner {
2465         require(block.timestamp < nftEndTime, "NFT_SALE_TIME_END");
2466         for (uint16 i = 0; i < list.length; i++) {
2467             if (reserved[list[i]]) {
2468                 delete reserved[list[i]];
2469                 reservedCount--;
2470             }
2471         }
2472     }
2473 
2474     // The time players are able to burn
2475     function setSquidStartTime(uint256 _squidStartTime) external onlyOwner {
2476         require(_squidStartTime > nftEndTime, "SQUID_START_TIME_MUST_BIGGER_THAN_NFT_END_TIME");
2477         squidStartTime = _squidStartTime; //unix time
2478     }  
2479      function setNFTStartTime(uint256 _nftStartTime) external onlyOwner {
2480         require(_nftStartTime > block.timestamp, "NFT_START_TIME_MUST_BIGGER_THAN_NOW");
2481         nftStartTime = _nftStartTime; //unix time
2482     }  
2483      function setNFTEndTime(uint256 _nftEndTime) external onlyOwner {
2484         require(_nftEndTime > nftStartTime, "NFT_END_TIME_MUST_AFTER_START_TIME");
2485         nftEndTime = _nftEndTime; //unix time
2486     }
2487 
2488     // player can buy before startTime
2489     function claimApeXNFT(uint256 userSeed) external payable {
2490         require(msg.value == price, "value not match");
2491         totalEth = totalEth + price;
2492         uint256 randRaw = random(userSeed);
2493         uint256 rand = getUnusedRandom(randRaw);
2494         _mint(msg.sender, rand);
2495         _setClaimed(rand);
2496         emit Mint(msg.sender, rand);
2497         require(block.timestamp <= nftEndTime  , "GAME_IS_ALREADY_END");
2498         require(block.timestamp >= nftStartTime  , "GAME_IS_NOT_BEGIN");
2499         id++;
2500         remainOwners++;
2501         require(remainOwners <= MAX_PLAYERS, "SOLD_OUT");
2502         if (reservedOn) {
2503             require(remainOwners <= MAX_PLAYERS - reservedCount, "SOLD_OUT_NORMAL");
2504             if (reserved[msg.sender]) {
2505                 delete reserved[msg.sender];
2506                 reservedCount--;
2507             }
2508         }
2509     }
2510 
2511     // player burn their nft
2512     function burnAndEarn(uint256 tokenId) external {
2513         uint256 _remainOwners = remainOwners;
2514         require(_remainOwners > 0, "ALL_BURNED");
2515         require(ownerOf(tokenId) == msg.sender, "NO_AUTHORITY");
2516         require(squidStartTime != 0 && block.timestamp >= squidStartTime, "GAME_IS_NOT_BEGIN");
2517         _burn(tokenId);
2518         (uint256 withdrawAmount, uint256 bonus) = _calWithdrawAmountAndBonus();
2519 
2520         if (_remainOwners > 1) {
2521             vaultAmount = vaultAmount + BONUS_PERPAX - bonus;
2522         }
2523 
2524         remainOwners = _remainOwners - 1;
2525         emit Burn(tokenId, withdrawAmount, msg.sender);
2526         require(IERC20(token).transfer(msg.sender, withdrawAmount));
2527     }
2528 
2529     function random(uint256 userSeed) public view returns (uint256) {
2530         return
2531             uint256(keccak256(abi.encodePacked(block.timestamp, block.number, userSeed, blockhash(block.number)))) %
2532             MAX_PLAYERS;
2533     }
2534 
2535     function getUnusedRandom(uint256 randomNumber) internal view returns (uint256) {
2536         while (isClaimed(randomNumber)) {
2537             randomNumber++;
2538             if (randomNumber == MAX_PLAYERS) {
2539                 randomNumber = randomNumber % MAX_PLAYERS;
2540             }
2541         }
2542 
2543         return randomNumber;
2544     }
2545 
2546     function isClaimed(uint256 index) public view returns (bool) {
2547         uint256 claimedWordIndex = index / 256;
2548         uint256 claimedBitIndex = index % 256;
2549         uint256 claimedWord = claimedBitMap[claimedWordIndex];
2550         uint256 mask = (1 << claimedBitIndex);
2551         return claimedWord & mask == mask;
2552     }
2553 
2554     function _setClaimed(uint256 index) private {
2555         uint256 claimedWordIndex = index / 256;
2556         uint256 claimedBitIndex = index % 256;
2557         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
2558     }
2559 
2560     function withdrawETH(address to) external onlyOwner {
2561         payable(to).transfer(address(this).balance);
2562     }
2563 
2564     function withdrawERC20Token(address token_, address to, uint256 amount) external onlyOwner returns (bool) {
2565         uint256 balance = IERC20(token_).balanceOf(address(this));
2566         require(balance >= amount, "NOT_ENOUGH_BALANCE");
2567         require(IERC20(token_).transfer(to, amount));
2568         return true;
2569     }
2570 
2571     function calWithdrawAmountAndBonus() external view returns (uint256 withdrawAmount, uint256 bonus) {
2572         return _calWithdrawAmountAndBonus();
2573     }
2574 
2575     function _calWithdrawAmountAndBonus() internal view returns (uint256 withdrawAmount, uint256 bonus) {
2576         uint256 endTime = squidStartTime + HALF_YEAR;
2577         uint256 nowTime = block.timestamp;
2578         uint256 diffTime = nowTime < endTime ? nowTime - squidStartTime : endTime - squidStartTime;
2579 
2580         // the last one is special
2581         if (remainOwners == 1) {
2582             withdrawAmount = BASE_AMOUNT + BONUS_PERPAX + vaultAmount;
2583             return (withdrawAmount, BONUS_PERPAX + vaultAmount);
2584         }
2585 
2586         // (t/6*5000+ vaultAmount/N)60%
2587         bonus =
2588             ((diffTime * BONUS_PERPAX * (100 - BURN_DISCOUNT)) /
2589                 HALF_YEAR +
2590                 (vaultAmount * (100 - BURN_DISCOUNT)) /
2591                 remainOwners) /
2592             100;
2593 
2594         // drain the pool
2595         if (bonus > vaultAmount + BONUS_PERPAX) {
2596             bonus = vaultAmount + BONUS_PERPAX;
2597         }
2598 
2599         withdrawAmount = BASE_AMOUNT + bonus;
2600     }
2601 }