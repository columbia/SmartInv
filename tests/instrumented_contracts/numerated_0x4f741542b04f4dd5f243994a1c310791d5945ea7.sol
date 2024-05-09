1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/utils/Counters.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @title Counters
95  * @author Matt Condon (@shrugs)
96  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
97  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
98  *
99  * Include with `using Counters for Counters.Counter;`
100  */
101 library Counters {
102     struct Counter {
103         // This variable should never be directly accessed by users of the library: interactions must be restricted to
104         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
105         // this feature: see https://github.com/ethereum/solidity/issues/4637
106         uint256 _value; // default: 0
107     }
108 
109     function current(Counter storage counter) internal view returns (uint256) {
110         return counter._value;
111     }
112 
113     function increment(Counter storage counter) internal {
114         unchecked {
115             counter._value += 1;
116         }
117     }
118 
119     function decrement(Counter storage counter) internal {
120         uint256 value = counter._value;
121         require(value > 0, "Counter: decrement overflow");
122         unchecked {
123             counter._value = value - 1;
124         }
125     }
126 
127     function reset(Counter storage counter) internal {
128         counter._value = 0;
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Library for managing
141  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
142  * types.
143  *
144  * Sets have the following properties:
145  *
146  * - Elements are added, removed, and checked for existence in constant time
147  * (O(1)).
148  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
149  *
150  * ```
151  * contract Example {
152  *     // Add the library methods
153  *     using EnumerableSet for EnumerableSet.AddressSet;
154  *
155  *     // Declare a set state variable
156  *     EnumerableSet.AddressSet private mySet;
157  * }
158  * ```
159  *
160  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
161  * and `uint256` (`UintSet`) are supported.
162  *
163  * [WARNING]
164  * ====
165  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
166  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
167  *
168  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
169  * ====
170  */
171 library EnumerableSet {
172     // To implement this library for multiple types with as little code
173     // repetition as possible, we write it in terms of a generic Set type with
174     // bytes32 values.
175     // The Set implementation uses private functions, and user-facing
176     // implementations (such as AddressSet) are just wrappers around the
177     // underlying Set.
178     // This means that we can only create new EnumerableSets for types that fit
179     // in bytes32.
180 
181     struct Set {
182         // Storage of set values
183         bytes32[] _values;
184         // Position of the value in the `values` array, plus 1 because index 0
185         // means a value is not in the set.
186         mapping(bytes32 => uint256) _indexes;
187     }
188 
189     /**
190      * @dev Add a value to a set. O(1).
191      *
192      * Returns true if the value was added to the set, that is if it was not
193      * already present.
194      */
195     function _add(Set storage set, bytes32 value) private returns (bool) {
196         if (!_contains(set, value)) {
197             set._values.push(value);
198             // The value is stored at length-1, but we add 1 to all indexes
199             // and use 0 as a sentinel value
200             set._indexes[value] = set._values.length;
201             return true;
202         } else {
203             return false;
204         }
205     }
206 
207     /**
208      * @dev Removes a value from a set. O(1).
209      *
210      * Returns true if the value was removed from the set, that is if it was
211      * present.
212      */
213     function _remove(Set storage set, bytes32 value) private returns (bool) {
214         // We read and store the value's index to prevent multiple reads from the same storage slot
215         uint256 valueIndex = set._indexes[value];
216 
217         if (valueIndex != 0) {
218             // Equivalent to contains(set, value)
219             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
220             // the array, and then remove the last element (sometimes called as 'swap and pop').
221             // This modifies the order of the array, as noted in {at}.
222 
223             uint256 toDeleteIndex = valueIndex - 1;
224             uint256 lastIndex = set._values.length - 1;
225 
226             if (lastIndex != toDeleteIndex) {
227                 bytes32 lastValue = set._values[lastIndex];
228 
229                 // Move the last value to the index where the value to delete is
230                 set._values[toDeleteIndex] = lastValue;
231                 // Update the index for the moved value
232                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
233             }
234 
235             // Delete the slot where the moved value was stored
236             set._values.pop();
237 
238             // Delete the index for the deleted slot
239             delete set._indexes[value];
240 
241             return true;
242         } else {
243             return false;
244         }
245     }
246 
247     /**
248      * @dev Returns true if the value is in the set. O(1).
249      */
250     function _contains(Set storage set, bytes32 value) private view returns (bool) {
251         return set._indexes[value] != 0;
252     }
253 
254     /**
255      * @dev Returns the number of values on the set. O(1).
256      */
257     function _length(Set storage set) private view returns (uint256) {
258         return set._values.length;
259     }
260 
261     /**
262      * @dev Returns the value stored at position `index` in the set. O(1).
263      *
264      * Note that there are no guarantees on the ordering of values inside the
265      * array, and it may change when more values are added or removed.
266      *
267      * Requirements:
268      *
269      * - `index` must be strictly less than {length}.
270      */
271     function _at(Set storage set, uint256 index) private view returns (bytes32) {
272         return set._values[index];
273     }
274 
275     /**
276      * @dev Return the entire set in an array
277      *
278      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
279      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
280      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
281      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
282      */
283     function _values(Set storage set) private view returns (bytes32[] memory) {
284         return set._values;
285     }
286 
287     // Bytes32Set
288 
289     struct Bytes32Set {
290         Set _inner;
291     }
292 
293     /**
294      * @dev Add a value to a set. O(1).
295      *
296      * Returns true if the value was added to the set, that is if it was not
297      * already present.
298      */
299     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
300         return _add(set._inner, value);
301     }
302 
303     /**
304      * @dev Removes a value from a set. O(1).
305      *
306      * Returns true if the value was removed from the set, that is if it was
307      * present.
308      */
309     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
310         return _remove(set._inner, value);
311     }
312 
313     /**
314      * @dev Returns true if the value is in the set. O(1).
315      */
316     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
317         return _contains(set._inner, value);
318     }
319 
320     /**
321      * @dev Returns the number of values in the set. O(1).
322      */
323     function length(Bytes32Set storage set) internal view returns (uint256) {
324         return _length(set._inner);
325     }
326 
327     /**
328      * @dev Returns the value stored at position `index` in the set. O(1).
329      *
330      * Note that there are no guarantees on the ordering of values inside the
331      * array, and it may change when more values are added or removed.
332      *
333      * Requirements:
334      *
335      * - `index` must be strictly less than {length}.
336      */
337     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
338         return _at(set._inner, index);
339     }
340 
341     /**
342      * @dev Return the entire set in an array
343      *
344      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
345      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
346      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
347      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
348      */
349     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
350         return _values(set._inner);
351     }
352 
353     // AddressSet
354 
355     struct AddressSet {
356         Set _inner;
357     }
358 
359     /**
360      * @dev Add a value to a set. O(1).
361      *
362      * Returns true if the value was added to the set, that is if it was not
363      * already present.
364      */
365     function add(AddressSet storage set, address value) internal returns (bool) {
366         return _add(set._inner, bytes32(uint256(uint160(value))));
367     }
368 
369     /**
370      * @dev Removes a value from a set. O(1).
371      *
372      * Returns true if the value was removed from the set, that is if it was
373      * present.
374      */
375     function remove(AddressSet storage set, address value) internal returns (bool) {
376         return _remove(set._inner, bytes32(uint256(uint160(value))));
377     }
378 
379     /**
380      * @dev Returns true if the value is in the set. O(1).
381      */
382     function contains(AddressSet storage set, address value) internal view returns (bool) {
383         return _contains(set._inner, bytes32(uint256(uint160(value))));
384     }
385 
386     /**
387      * @dev Returns the number of values in the set. O(1).
388      */
389     function length(AddressSet storage set) internal view returns (uint256) {
390         return _length(set._inner);
391     }
392 
393     /**
394      * @dev Returns the value stored at position `index` in the set. O(1).
395      *
396      * Note that there are no guarantees on the ordering of values inside the
397      * array, and it may change when more values are added or removed.
398      *
399      * Requirements:
400      *
401      * - `index` must be strictly less than {length}.
402      */
403     function at(AddressSet storage set, uint256 index) internal view returns (address) {
404         return address(uint160(uint256(_at(set._inner, index))));
405     }
406 
407     /**
408      * @dev Return the entire set in an array
409      *
410      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
411      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
412      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
413      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
414      */
415     function values(AddressSet storage set) internal view returns (address[] memory) {
416         bytes32[] memory store = _values(set._inner);
417         address[] memory result;
418 
419         /// @solidity memory-safe-assembly
420         assembly {
421             result := store
422         }
423 
424         return result;
425     }
426 
427     // UintSet
428 
429     struct UintSet {
430         Set _inner;
431     }
432 
433     /**
434      * @dev Add a value to a set. O(1).
435      *
436      * Returns true if the value was added to the set, that is if it was not
437      * already present.
438      */
439     function add(UintSet storage set, uint256 value) internal returns (bool) {
440         return _add(set._inner, bytes32(value));
441     }
442 
443     /**
444      * @dev Removes a value from a set. O(1).
445      *
446      * Returns true if the value was removed from the set, that is if it was
447      * present.
448      */
449     function remove(UintSet storage set, uint256 value) internal returns (bool) {
450         return _remove(set._inner, bytes32(value));
451     }
452 
453     /**
454      * @dev Returns true if the value is in the set. O(1).
455      */
456     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
457         return _contains(set._inner, bytes32(value));
458     }
459 
460     /**
461      * @dev Returns the number of values on the set. O(1).
462      */
463     function length(UintSet storage set) internal view returns (uint256) {
464         return _length(set._inner);
465     }
466 
467     /**
468      * @dev Returns the value stored at position `index` in the set. O(1).
469      *
470      * Note that there are no guarantees on the ordering of values inside the
471      * array, and it may change when more values are added or removed.
472      *
473      * Requirements:
474      *
475      * - `index` must be strictly less than {length}.
476      */
477     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
478         return uint256(_at(set._inner, index));
479     }
480 
481     /**
482      * @dev Return the entire set in an array
483      *
484      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
485      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
486      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
487      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
488      */
489     function values(UintSet storage set) internal view returns (uint256[] memory) {
490         bytes32[] memory store = _values(set._inner);
491         uint256[] memory result;
492 
493         /// @solidity memory-safe-assembly
494         assembly {
495             result := store
496         }
497 
498         return result;
499     }
500 }
501 
502 // File: @openzeppelin/contracts/access/IAccessControl.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 /**
510  * @dev External interface of AccessControl declared to support ERC165 detection.
511  */
512 interface IAccessControl {
513     /**
514      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
515      *
516      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
517      * {RoleAdminChanged} not being emitted signaling this.
518      *
519      * _Available since v3.1._
520      */
521     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
522 
523     /**
524      * @dev Emitted when `account` is granted `role`.
525      *
526      * `sender` is the account that originated the contract call, an admin role
527      * bearer except when using {AccessControl-_setupRole}.
528      */
529     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
530 
531     /**
532      * @dev Emitted when `account` is revoked `role`.
533      *
534      * `sender` is the account that originated the contract call:
535      *   - if using `revokeRole`, it is the admin role bearer
536      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
537      */
538     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
539 
540     /**
541      * @dev Returns `true` if `account` has been granted `role`.
542      */
543     function hasRole(bytes32 role, address account) external view returns (bool);
544 
545     /**
546      * @dev Returns the admin role that controls `role`. See {grantRole} and
547      * {revokeRole}.
548      *
549      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
550      */
551     function getRoleAdmin(bytes32 role) external view returns (bytes32);
552 
553     /**
554      * @dev Grants `role` to `account`.
555      *
556      * If `account` had not been already granted `role`, emits a {RoleGranted}
557      * event.
558      *
559      * Requirements:
560      *
561      * - the caller must have ``role``'s admin role.
562      */
563     function grantRole(bytes32 role, address account) external;
564 
565     /**
566      * @dev Revokes `role` from `account`.
567      *
568      * If `account` had been granted `role`, emits a {RoleRevoked} event.
569      *
570      * Requirements:
571      *
572      * - the caller must have ``role``'s admin role.
573      */
574     function revokeRole(bytes32 role, address account) external;
575 
576     /**
577      * @dev Revokes `role` from the calling account.
578      *
579      * Roles are often managed via {grantRole} and {revokeRole}: this function's
580      * purpose is to provide a mechanism for accounts to lose their privileges
581      * if they are compromised (such as when a trusted device is misplaced).
582      *
583      * If the calling account had been granted `role`, emits a {RoleRevoked}
584      * event.
585      *
586      * Requirements:
587      *
588      * - the caller must be `account`.
589      */
590     function renounceRole(bytes32 role, address account) external;
591 }
592 
593 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
603  */
604 interface IAccessControlEnumerable is IAccessControl {
605     /**
606      * @dev Returns one of the accounts that have `role`. `index` must be a
607      * value between 0 and {getRoleMemberCount}, non-inclusive.
608      *
609      * Role bearers are not sorted in any particular way, and their ordering may
610      * change at any point.
611      *
612      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
613      * you perform all queries on the same block. See the following
614      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
615      * for more information.
616      */
617     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
618 
619     /**
620      * @dev Returns the number of accounts that have `role`. Can be used
621      * together with {getRoleMember} to enumerate all bearers of a role.
622      */
623     function getRoleMemberCount(bytes32 role) external view returns (uint256);
624 }
625 
626 // File: @openzeppelin/contracts/utils/Strings.sol
627 
628 
629 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev String operations.
635  */
636 library Strings {
637     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
638     uint8 private constant _ADDRESS_LENGTH = 20;
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
642      */
643     function toString(uint256 value) internal pure returns (string memory) {
644         // Inspired by OraclizeAPI's implementation - MIT licence
645         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
646 
647         if (value == 0) {
648             return "0";
649         }
650         uint256 temp = value;
651         uint256 digits;
652         while (temp != 0) {
653             digits++;
654             temp /= 10;
655         }
656         bytes memory buffer = new bytes(digits);
657         while (value != 0) {
658             digits -= 1;
659             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
660             value /= 10;
661         }
662         return string(buffer);
663     }
664 
665     /**
666      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
667      */
668     function toHexString(uint256 value) internal pure returns (string memory) {
669         if (value == 0) {
670             return "0x00";
671         }
672         uint256 temp = value;
673         uint256 length = 0;
674         while (temp != 0) {
675             length++;
676             temp >>= 8;
677         }
678         return toHexString(value, length);
679     }
680 
681     /**
682      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
683      */
684     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
685         bytes memory buffer = new bytes(2 * length + 2);
686         buffer[0] = "0";
687         buffer[1] = "x";
688         for (uint256 i = 2 * length + 1; i > 1; --i) {
689             buffer[i] = _HEX_SYMBOLS[value & 0xf];
690             value >>= 4;
691         }
692         require(value == 0, "Strings: hex length insufficient");
693         return string(buffer);
694     }
695 
696     /**
697      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
698      */
699     function toHexString(address addr) internal pure returns (string memory) {
700         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
701     }
702 }
703 
704 // File: @openzeppelin/contracts/utils/Address.sol
705 
706 
707 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
708 
709 pragma solidity ^0.8.1;
710 
711 /**
712  * @dev Collection of functions related to the address type
713  */
714 library Address {
715     /**
716      * @dev Returns true if `account` is a contract.
717      *
718      * [IMPORTANT]
719      * ====
720      * It is unsafe to assume that an address for which this function returns
721      * false is an externally-owned account (EOA) and not a contract.
722      *
723      * Among others, `isContract` will return false for the following
724      * types of addresses:
725      *
726      *  - an externally-owned account
727      *  - a contract in construction
728      *  - an address where a contract will be created
729      *  - an address where a contract lived, but was destroyed
730      * ====
731      *
732      * [IMPORTANT]
733      * ====
734      * You shouldn't rely on `isContract` to protect against flash loan attacks!
735      *
736      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
737      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
738      * constructor.
739      * ====
740      */
741     function isContract(address account) internal view returns (bool) {
742         // This method relies on extcodesize/address.code.length, which returns 0
743         // for contracts in construction, since the code is only stored at the end
744         // of the constructor execution.
745 
746         return account.code.length > 0;
747     }
748 
749     /**
750      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
751      * `recipient`, forwarding all available gas and reverting on errors.
752      *
753      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
754      * of certain opcodes, possibly making contracts go over the 2300 gas limit
755      * imposed by `transfer`, making them unable to receive funds via
756      * `transfer`. {sendValue} removes this limitation.
757      *
758      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
759      *
760      * IMPORTANT: because control is transferred to `recipient`, care must be
761      * taken to not create reentrancy vulnerabilities. Consider using
762      * {ReentrancyGuard} or the
763      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
764      */
765     function sendValue(address payable recipient, uint256 amount) internal {
766         require(address(this).balance >= amount, "Address: insufficient balance");
767 
768         (bool success, ) = recipient.call{value: amount}("");
769         require(success, "Address: unable to send value, recipient may have reverted");
770     }
771 
772     /**
773      * @dev Performs a Solidity function call using a low level `call`. A
774      * plain `call` is an unsafe replacement for a function call: use this
775      * function instead.
776      *
777      * If `target` reverts with a revert reason, it is bubbled up by this
778      * function (like regular Solidity function calls).
779      *
780      * Returns the raw returned data. To convert to the expected return value,
781      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
782      *
783      * Requirements:
784      *
785      * - `target` must be a contract.
786      * - calling `target` with `data` must not revert.
787      *
788      * _Available since v3.1._
789      */
790     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
791         return functionCall(target, data, "Address: low-level call failed");
792     }
793 
794     /**
795      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
796      * `errorMessage` as a fallback revert reason when `target` reverts.
797      *
798      * _Available since v3.1._
799      */
800     function functionCall(
801         address target,
802         bytes memory data,
803         string memory errorMessage
804     ) internal returns (bytes memory) {
805         return functionCallWithValue(target, data, 0, errorMessage);
806     }
807 
808     /**
809      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
810      * but also transferring `value` wei to `target`.
811      *
812      * Requirements:
813      *
814      * - the calling contract must have an ETH balance of at least `value`.
815      * - the called Solidity function must be `payable`.
816      *
817      * _Available since v3.1._
818      */
819     function functionCallWithValue(
820         address target,
821         bytes memory data,
822         uint256 value
823     ) internal returns (bytes memory) {
824         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
829      * with `errorMessage` as a fallback revert reason when `target` reverts.
830      *
831      * _Available since v3.1._
832      */
833     function functionCallWithValue(
834         address target,
835         bytes memory data,
836         uint256 value,
837         string memory errorMessage
838     ) internal returns (bytes memory) {
839         require(address(this).balance >= value, "Address: insufficient balance for call");
840         require(isContract(target), "Address: call to non-contract");
841 
842         (bool success, bytes memory returndata) = target.call{value: value}(data);
843         return verifyCallResult(success, returndata, errorMessage);
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
848      * but performing a static call.
849      *
850      * _Available since v3.3._
851      */
852     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
853         return functionStaticCall(target, data, "Address: low-level static call failed");
854     }
855 
856     /**
857      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
858      * but performing a static call.
859      *
860      * _Available since v3.3._
861      */
862     function functionStaticCall(
863         address target,
864         bytes memory data,
865         string memory errorMessage
866     ) internal view returns (bytes memory) {
867         require(isContract(target), "Address: static call to non-contract");
868 
869         (bool success, bytes memory returndata) = target.staticcall(data);
870         return verifyCallResult(success, returndata, errorMessage);
871     }
872 
873     /**
874      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
875      * but performing a delegate call.
876      *
877      * _Available since v3.4._
878      */
879     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
880         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
881     }
882 
883     /**
884      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
885      * but performing a delegate call.
886      *
887      * _Available since v3.4._
888      */
889     function functionDelegateCall(
890         address target,
891         bytes memory data,
892         string memory errorMessage
893     ) internal returns (bytes memory) {
894         require(isContract(target), "Address: delegate call to non-contract");
895 
896         (bool success, bytes memory returndata) = target.delegatecall(data);
897         return verifyCallResult(success, returndata, errorMessage);
898     }
899 
900     /**
901      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
902      * revert reason using the provided one.
903      *
904      * _Available since v4.3._
905      */
906     function verifyCallResult(
907         bool success,
908         bytes memory returndata,
909         string memory errorMessage
910     ) internal pure returns (bytes memory) {
911         if (success) {
912             return returndata;
913         } else {
914             // Look for revert reason and bubble it up if present
915             if (returndata.length > 0) {
916                 // The easiest way to bubble the revert reason is using memory via assembly
917                 /// @solidity memory-safe-assembly
918                 assembly {
919                     let returndata_size := mload(returndata)
920                     revert(add(32, returndata), returndata_size)
921                 }
922             } else {
923                 revert(errorMessage);
924             }
925         }
926     }
927 }
928 
929 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
930 
931 
932 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @title ERC721 token receiver interface
938  * @dev Interface for any contract that wants to support safeTransfers
939  * from ERC721 asset contracts.
940  */
941 interface IERC721Receiver {
942     /**
943      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
944      * by `operator` from `from`, this function is called.
945      *
946      * It must return its Solidity selector to confirm the token transfer.
947      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
948      *
949      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
950      */
951     function onERC721Received(
952         address operator,
953         address from,
954         uint256 tokenId,
955         bytes calldata data
956     ) external returns (bytes4);
957 }
958 
959 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
960 
961 
962 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
963 
964 pragma solidity ^0.8.0;
965 
966 
967 /**
968  * @dev Implementation of the {IERC721Receiver} interface.
969  *
970  * Accepts all token transfers.
971  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
972  */
973 contract ERC721Holder is IERC721Receiver {
974     /**
975      * @dev See {IERC721Receiver-onERC721Received}.
976      *
977      * Always returns `IERC721Receiver.onERC721Received.selector`.
978      */
979     function onERC721Received(
980         address,
981         address,
982         uint256,
983         bytes memory
984     ) public virtual override returns (bytes4) {
985         return this.onERC721Received.selector;
986     }
987 }
988 
989 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
990 
991 
992 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
993 
994 pragma solidity ^0.8.0;
995 
996 /**
997  * @dev Interface of the ERC165 standard, as defined in the
998  * https://eips.ethereum.org/EIPS/eip-165[EIP].
999  *
1000  * Implementers can declare support of contract interfaces, which can then be
1001  * queried by others ({ERC165Checker}).
1002  *
1003  * For an implementation, see {ERC165}.
1004  */
1005 interface IERC165 {
1006     /**
1007      * @dev Returns true if this contract implements the interface defined by
1008      * `interfaceId`. See the corresponding
1009      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1010      * to learn more about how these ids are created.
1011      *
1012      * This function call must use less than 30 000 gas.
1013      */
1014     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1015 }
1016 
1017 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1018 
1019 
1020 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1021 
1022 pragma solidity ^0.8.0;
1023 
1024 
1025 /**
1026  * @dev Implementation of the {IERC165} interface.
1027  *
1028  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1029  * for the additional interface id that will be supported. For example:
1030  *
1031  * ```solidity
1032  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1033  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1034  * }
1035  * ```
1036  *
1037  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1038  */
1039 abstract contract ERC165 is IERC165 {
1040     /**
1041      * @dev See {IERC165-supportsInterface}.
1042      */
1043     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1044         return interfaceId == type(IERC165).interfaceId;
1045     }
1046 }
1047 
1048 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1049 
1050 
1051 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1052 
1053 pragma solidity ^0.8.0;
1054 
1055 
1056 /**
1057  * @dev Required interface of an ERC721 compliant contract.
1058  */
1059 interface IERC721 is IERC165 {
1060     /**
1061      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1062      */
1063     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1064 
1065     /**
1066      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1067      */
1068     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1069 
1070     /**
1071      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1072      */
1073     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1074 
1075     /**
1076      * @dev Returns the number of tokens in ``owner``'s account.
1077      */
1078     function balanceOf(address owner) external view returns (uint256 balance);
1079 
1080     /**
1081      * @dev Returns the owner of the `tokenId` token.
1082      *
1083      * Requirements:
1084      *
1085      * - `tokenId` must exist.
1086      */
1087     function ownerOf(uint256 tokenId) external view returns (address owner);
1088 
1089     /**
1090      * @dev Safely transfers `tokenId` token from `from` to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - `from` cannot be the zero address.
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must exist and be owned by `from`.
1097      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1098      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1099      *
1100      * Emits a {Transfer} event.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes calldata data
1107     ) external;
1108 
1109     /**
1110      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1111      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1112      *
1113      * Requirements:
1114      *
1115      * - `from` cannot be the zero address.
1116      * - `to` cannot be the zero address.
1117      * - `tokenId` token must exist and be owned by `from`.
1118      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1119      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function safeTransferFrom(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) external;
1128 
1129     /**
1130      * @dev Transfers `tokenId` token from `from` to `to`.
1131      *
1132      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1133      *
1134      * Requirements:
1135      *
1136      * - `from` cannot be the zero address.
1137      * - `to` cannot be the zero address.
1138      * - `tokenId` token must be owned by `from`.
1139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function transferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) external;
1148 
1149     /**
1150      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1151      * The approval is cleared when the token is transferred.
1152      *
1153      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1154      *
1155      * Requirements:
1156      *
1157      * - The caller must own the token or be an approved operator.
1158      * - `tokenId` must exist.
1159      *
1160      * Emits an {Approval} event.
1161      */
1162     function approve(address to, uint256 tokenId) external;
1163 
1164     /**
1165      * @dev Approve or remove `operator` as an operator for the caller.
1166      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1167      *
1168      * Requirements:
1169      *
1170      * - The `operator` cannot be the caller.
1171      *
1172      * Emits an {ApprovalForAll} event.
1173      */
1174     function setApprovalForAll(address operator, bool _approved) external;
1175 
1176     /**
1177      * @dev Returns the account approved for `tokenId` token.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      */
1183     function getApproved(uint256 tokenId) external view returns (address operator);
1184 
1185     /**
1186      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1187      *
1188      * See {setApprovalForAll}
1189      */
1190     function isApprovedForAll(address owner, address operator) external view returns (bool);
1191 }
1192 
1193 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1194 
1195 
1196 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 
1201 /**
1202  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1203  * @dev See https://eips.ethereum.org/EIPS/eip-721
1204  */
1205 interface IERC721Enumerable is IERC721 {
1206     /**
1207      * @dev Returns the total amount of tokens stored by the contract.
1208      */
1209     function totalSupply() external view returns (uint256);
1210 
1211     /**
1212      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1213      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1214      */
1215     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1216 
1217     /**
1218      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1219      * Use along with {totalSupply} to enumerate all tokens.
1220      */
1221     function tokenByIndex(uint256 index) external view returns (uint256);
1222 }
1223 
1224 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1225 
1226 
1227 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 
1232 /**
1233  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1234  * @dev See https://eips.ethereum.org/EIPS/eip-721
1235  */
1236 interface IERC721Metadata is IERC721 {
1237     /**
1238      * @dev Returns the token collection name.
1239      */
1240     function name() external view returns (string memory);
1241 
1242     /**
1243      * @dev Returns the token collection symbol.
1244      */
1245     function symbol() external view returns (string memory);
1246 
1247     /**
1248      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1249      */
1250     function tokenURI(uint256 tokenId) external view returns (string memory);
1251 }
1252 
1253 // File: utils/IERC721Batch.sol
1254 
1255 
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 interface IERC721Batch {
1260   function isOwnerOf( address account, uint[] calldata tokenIds ) external view returns( bool );
1261   function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external;
1262   function walletOfOwner( address account ) external view returns( uint[] memory );
1263 }
1264 
1265 // File: @openzeppelin/contracts/utils/Context.sol
1266 
1267 
1268 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 /**
1273  * @dev Provides information about the current execution context, including the
1274  * sender of the transaction and its data. While these are generally available
1275  * via msg.sender and msg.data, they should not be accessed in such a direct
1276  * manner, since when dealing with meta-transactions the account sending and
1277  * paying for execution may not be the actual sender (as far as an application
1278  * is concerned).
1279  *
1280  * This contract is only required for intermediate, library-like contracts.
1281  */
1282 abstract contract Context {
1283     function _msgSender() internal view virtual returns (address) {
1284         return msg.sender;
1285     }
1286 
1287     function _msgData() internal view virtual returns (bytes calldata) {
1288         return msg.data;
1289     }
1290 }
1291 
1292 // File: @openzeppelin/contracts/access/AccessControl.sol
1293 
1294 
1295 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1296 
1297 pragma solidity ^0.8.0;
1298 
1299 
1300 
1301 
1302 
1303 /**
1304  * @dev Contract module that allows children to implement role-based access
1305  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1306  * members except through off-chain means by accessing the contract event logs. Some
1307  * applications may benefit from on-chain enumerability, for those cases see
1308  * {AccessControlEnumerable}.
1309  *
1310  * Roles are referred to by their `bytes32` identifier. These should be exposed
1311  * in the external API and be unique. The best way to achieve this is by
1312  * using `public constant` hash digests:
1313  *
1314  * ```
1315  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1316  * ```
1317  *
1318  * Roles can be used to represent a set of permissions. To restrict access to a
1319  * function call, use {hasRole}:
1320  *
1321  * ```
1322  * function foo() public {
1323  *     require(hasRole(MY_ROLE, msg.sender));
1324  *     ...
1325  * }
1326  * ```
1327  *
1328  * Roles can be granted and revoked dynamically via the {grantRole} and
1329  * {revokeRole} functions. Each role has an associated admin role, and only
1330  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1331  *
1332  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1333  * that only accounts with this role will be able to grant or revoke other
1334  * roles. More complex role relationships can be created by using
1335  * {_setRoleAdmin}.
1336  *
1337  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1338  * grant and revoke this role. Extra precautions should be taken to secure
1339  * accounts that have been granted it.
1340  */
1341 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1342     struct RoleData {
1343         mapping(address => bool) members;
1344         bytes32 adminRole;
1345     }
1346 
1347     mapping(bytes32 => RoleData) private _roles;
1348 
1349     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1350 
1351     /**
1352      * @dev Modifier that checks that an account has a specific role. Reverts
1353      * with a standardized message including the required role.
1354      *
1355      * The format of the revert reason is given by the following regular expression:
1356      *
1357      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1358      *
1359      * _Available since v4.1._
1360      */
1361     modifier onlyRole(bytes32 role) {
1362         _checkRole(role);
1363         _;
1364     }
1365 
1366     /**
1367      * @dev See {IERC165-supportsInterface}.
1368      */
1369     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1370         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1371     }
1372 
1373     /**
1374      * @dev Returns `true` if `account` has been granted `role`.
1375      */
1376     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1377         return _roles[role].members[account];
1378     }
1379 
1380     /**
1381      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1382      * Overriding this function changes the behavior of the {onlyRole} modifier.
1383      *
1384      * Format of the revert message is described in {_checkRole}.
1385      *
1386      * _Available since v4.6._
1387      */
1388     function _checkRole(bytes32 role) internal view virtual {
1389         _checkRole(role, _msgSender());
1390     }
1391 
1392     /**
1393      * @dev Revert with a standard message if `account` is missing `role`.
1394      *
1395      * The format of the revert reason is given by the following regular expression:
1396      *
1397      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1398      */
1399     function _checkRole(bytes32 role, address account) internal view virtual {
1400         if (!hasRole(role, account)) {
1401             revert(
1402                 string(
1403                     abi.encodePacked(
1404                         "AccessControl: account ",
1405                         Strings.toHexString(uint160(account), 20),
1406                         " is missing role ",
1407                         Strings.toHexString(uint256(role), 32)
1408                     )
1409                 )
1410             );
1411         }
1412     }
1413 
1414     /**
1415      * @dev Returns the admin role that controls `role`. See {grantRole} and
1416      * {revokeRole}.
1417      *
1418      * To change a role's admin, use {_setRoleAdmin}.
1419      */
1420     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1421         return _roles[role].adminRole;
1422     }
1423 
1424     /**
1425      * @dev Grants `role` to `account`.
1426      *
1427      * If `account` had not been already granted `role`, emits a {RoleGranted}
1428      * event.
1429      *
1430      * Requirements:
1431      *
1432      * - the caller must have ``role``'s admin role.
1433      *
1434      * May emit a {RoleGranted} event.
1435      */
1436     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1437         _grantRole(role, account);
1438     }
1439 
1440     /**
1441      * @dev Revokes `role` from `account`.
1442      *
1443      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1444      *
1445      * Requirements:
1446      *
1447      * - the caller must have ``role``'s admin role.
1448      *
1449      * May emit a {RoleRevoked} event.
1450      */
1451     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1452         _revokeRole(role, account);
1453     }
1454 
1455     /**
1456      * @dev Revokes `role` from the calling account.
1457      *
1458      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1459      * purpose is to provide a mechanism for accounts to lose their privileges
1460      * if they are compromised (such as when a trusted device is misplaced).
1461      *
1462      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1463      * event.
1464      *
1465      * Requirements:
1466      *
1467      * - the caller must be `account`.
1468      *
1469      * May emit a {RoleRevoked} event.
1470      */
1471     function renounceRole(bytes32 role, address account) public virtual override {
1472         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1473 
1474         _revokeRole(role, account);
1475     }
1476 
1477     /**
1478      * @dev Grants `role` to `account`.
1479      *
1480      * If `account` had not been already granted `role`, emits a {RoleGranted}
1481      * event. Note that unlike {grantRole}, this function doesn't perform any
1482      * checks on the calling account.
1483      *
1484      * May emit a {RoleGranted} event.
1485      *
1486      * [WARNING]
1487      * ====
1488      * This function should only be called from the constructor when setting
1489      * up the initial roles for the system.
1490      *
1491      * Using this function in any other way is effectively circumventing the admin
1492      * system imposed by {AccessControl}.
1493      * ====
1494      *
1495      * NOTE: This function is deprecated in favor of {_grantRole}.
1496      */
1497     function _setupRole(bytes32 role, address account) internal virtual {
1498         _grantRole(role, account);
1499     }
1500 
1501     /**
1502      * @dev Sets `adminRole` as ``role``'s admin role.
1503      *
1504      * Emits a {RoleAdminChanged} event.
1505      */
1506     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1507         bytes32 previousAdminRole = getRoleAdmin(role);
1508         _roles[role].adminRole = adminRole;
1509         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1510     }
1511 
1512     /**
1513      * @dev Grants `role` to `account`.
1514      *
1515      * Internal function without access restriction.
1516      *
1517      * May emit a {RoleGranted} event.
1518      */
1519     function _grantRole(bytes32 role, address account) internal virtual {
1520         if (!hasRole(role, account)) {
1521             _roles[role].members[account] = true;
1522             emit RoleGranted(role, account, _msgSender());
1523         }
1524     }
1525 
1526     /**
1527      * @dev Revokes `role` from `account`.
1528      *
1529      * Internal function without access restriction.
1530      *
1531      * May emit a {RoleRevoked} event.
1532      */
1533     function _revokeRole(bytes32 role, address account) internal virtual {
1534         if (hasRole(role, account)) {
1535             _roles[role].members[account] = false;
1536             emit RoleRevoked(role, account, _msgSender());
1537         }
1538     }
1539 }
1540 
1541 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1542 
1543 
1544 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 
1549 
1550 
1551 /**
1552  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1553  */
1554 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1555     using EnumerableSet for EnumerableSet.AddressSet;
1556 
1557     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1558 
1559     /**
1560      * @dev See {IERC165-supportsInterface}.
1561      */
1562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1563         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1564     }
1565 
1566     /**
1567      * @dev Returns one of the accounts that have `role`. `index` must be a
1568      * value between 0 and {getRoleMemberCount}, non-inclusive.
1569      *
1570      * Role bearers are not sorted in any particular way, and their ordering may
1571      * change at any point.
1572      *
1573      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1574      * you perform all queries on the same block. See the following
1575      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1576      * for more information.
1577      */
1578     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1579         return _roleMembers[role].at(index);
1580     }
1581 
1582     /**
1583      * @dev Returns the number of accounts that have `role`. Can be used
1584      * together with {getRoleMember} to enumerate all bearers of a role.
1585      */
1586     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1587         return _roleMembers[role].length();
1588     }
1589 
1590     /**
1591      * @dev Overload {_grantRole} to track enumerable memberships
1592      */
1593     function _grantRole(bytes32 role, address account) internal virtual override {
1594         super._grantRole(role, account);
1595         _roleMembers[role].add(account);
1596     }
1597 
1598     /**
1599      * @dev Overload {_revokeRole} to track enumerable memberships
1600      */
1601     function _revokeRole(bytes32 role, address account) internal virtual override {
1602         super._revokeRole(role, account);
1603         _roleMembers[role].remove(account);
1604     }
1605 }
1606 
1607 // File: @openzeppelin/contracts/security/Pausable.sol
1608 
1609 
1610 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1611 
1612 pragma solidity ^0.8.0;
1613 
1614 
1615 /**
1616  * @dev Contract module which allows children to implement an emergency stop
1617  * mechanism that can be triggered by an authorized account.
1618  *
1619  * This module is used through inheritance. It will make available the
1620  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1621  * the functions of your contract. Note that they will not be pausable by
1622  * simply including this module, only once the modifiers are put in place.
1623  */
1624 abstract contract Pausable is Context {
1625     /**
1626      * @dev Emitted when the pause is triggered by `account`.
1627      */
1628     event Paused(address account);
1629 
1630     /**
1631      * @dev Emitted when the pause is lifted by `account`.
1632      */
1633     event Unpaused(address account);
1634 
1635     bool private _paused;
1636 
1637     /**
1638      * @dev Initializes the contract in unpaused state.
1639      */
1640     constructor() {
1641         _paused = false;
1642     }
1643 
1644     /**
1645      * @dev Modifier to make a function callable only when the contract is not paused.
1646      *
1647      * Requirements:
1648      *
1649      * - The contract must not be paused.
1650      */
1651     modifier whenNotPaused() {
1652         _requireNotPaused();
1653         _;
1654     }
1655 
1656     /**
1657      * @dev Modifier to make a function callable only when the contract is paused.
1658      *
1659      * Requirements:
1660      *
1661      * - The contract must be paused.
1662      */
1663     modifier whenPaused() {
1664         _requirePaused();
1665         _;
1666     }
1667 
1668     /**
1669      * @dev Returns true if the contract is paused, and false otherwise.
1670      */
1671     function paused() public view virtual returns (bool) {
1672         return _paused;
1673     }
1674 
1675     /**
1676      * @dev Throws if the contract is paused.
1677      */
1678     function _requireNotPaused() internal view virtual {
1679         require(!paused(), "Pausable: paused");
1680     }
1681 
1682     /**
1683      * @dev Throws if the contract is not paused.
1684      */
1685     function _requirePaused() internal view virtual {
1686         require(paused(), "Pausable: not paused");
1687     }
1688 
1689     /**
1690      * @dev Triggers stopped state.
1691      *
1692      * Requirements:
1693      *
1694      * - The contract must not be paused.
1695      */
1696     function _pause() internal virtual whenNotPaused {
1697         _paused = true;
1698         emit Paused(_msgSender());
1699     }
1700 
1701     /**
1702      * @dev Returns to normal state.
1703      *
1704      * Requirements:
1705      *
1706      * - The contract must be paused.
1707      */
1708     function _unpause() internal virtual whenPaused {
1709         _paused = false;
1710         emit Unpaused(_msgSender());
1711     }
1712 }
1713 
1714 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1715 
1716 
1717 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1718 
1719 pragma solidity ^0.8.0;
1720 
1721 
1722 
1723 
1724 
1725 
1726 
1727 
1728 /**
1729  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1730  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1731  * {ERC721Enumerable}.
1732  */
1733 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1734     using Address for address;
1735     using Strings for uint256;
1736 
1737     // Token name
1738     string private _name;
1739 
1740     // Token symbol
1741     string private _symbol;
1742 
1743     // Mapping from token ID to owner address
1744     mapping(uint256 => address) private _owners;
1745 
1746     // Mapping owner address to token count
1747     mapping(address => uint256) private _balances;
1748 
1749     // Mapping from token ID to approved address
1750     mapping(uint256 => address) private _tokenApprovals;
1751 
1752     // Mapping from owner to operator approvals
1753     mapping(address => mapping(address => bool)) private _operatorApprovals;
1754 
1755     /**
1756      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1757      */
1758     constructor(string memory name_, string memory symbol_) {
1759         _name = name_;
1760         _symbol = symbol_;
1761     }
1762 
1763     /**
1764      * @dev See {IERC165-supportsInterface}.
1765      */
1766     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1767         return
1768             interfaceId == type(IERC721).interfaceId ||
1769             interfaceId == type(IERC721Metadata).interfaceId ||
1770             super.supportsInterface(interfaceId);
1771     }
1772 
1773     /**
1774      * @dev See {IERC721-balanceOf}.
1775      */
1776     function balanceOf(address owner) public view virtual override returns (uint256) {
1777         require(owner != address(0), "ERC721: address zero is not a valid owner");
1778         return _balances[owner];
1779     }
1780 
1781     /**
1782      * @dev See {IERC721-ownerOf}.
1783      */
1784     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1785         address owner = _owners[tokenId];
1786         require(owner != address(0), "ERC721: invalid token ID");
1787         return owner;
1788     }
1789 
1790     /**
1791      * @dev See {IERC721Metadata-name}.
1792      */
1793     function name() public view virtual override returns (string memory) {
1794         return _name;
1795     }
1796 
1797     /**
1798      * @dev See {IERC721Metadata-symbol}.
1799      */
1800     function symbol() public view virtual override returns (string memory) {
1801         return _symbol;
1802     }
1803 
1804     /**
1805      * @dev See {IERC721Metadata-tokenURI}.
1806      */
1807     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1808         _requireMinted(tokenId);
1809 
1810         string memory baseURI = _baseURI();
1811         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1812     }
1813 
1814     /**
1815      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1816      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1817      * by default, can be overridden in child contracts.
1818      */
1819     function _baseURI() internal view virtual returns (string memory) {
1820         return "";
1821     }
1822 
1823     /**
1824      * @dev See {IERC721-approve}.
1825      */
1826     function approve(address to, uint256 tokenId) public virtual override {
1827         address owner = ERC721.ownerOf(tokenId);
1828         require(to != owner, "ERC721: approval to current owner");
1829 
1830         require(
1831             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1832             "ERC721: approve caller is not token owner nor approved for all"
1833         );
1834 
1835         _approve(to, tokenId);
1836     }
1837 
1838     /**
1839      * @dev See {IERC721-getApproved}.
1840      */
1841     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1842         _requireMinted(tokenId);
1843 
1844         return _tokenApprovals[tokenId];
1845     }
1846 
1847     /**
1848      * @dev See {IERC721-setApprovalForAll}.
1849      */
1850     function setApprovalForAll(address operator, bool approved) public virtual override {
1851         _setApprovalForAll(_msgSender(), operator, approved);
1852     }
1853 
1854     /**
1855      * @dev See {IERC721-isApprovedForAll}.
1856      */
1857     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1858         return _operatorApprovals[owner][operator];
1859     }
1860 
1861     /**
1862      * @dev See {IERC721-transferFrom}.
1863      */
1864     function transferFrom(
1865         address from,
1866         address to,
1867         uint256 tokenId
1868     ) public virtual override {
1869         //solhint-disable-next-line max-line-length
1870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1871 
1872         _transfer(from, to, tokenId);
1873     }
1874 
1875     /**
1876      * @dev See {IERC721-safeTransferFrom}.
1877      */
1878     function safeTransferFrom(
1879         address from,
1880         address to,
1881         uint256 tokenId
1882     ) public virtual override {
1883         safeTransferFrom(from, to, tokenId, "");
1884     }
1885 
1886     /**
1887      * @dev See {IERC721-safeTransferFrom}.
1888      */
1889     function safeTransferFrom(
1890         address from,
1891         address to,
1892         uint256 tokenId,
1893         bytes memory data
1894     ) public virtual override {
1895         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1896         _safeTransfer(from, to, tokenId, data);
1897     }
1898 
1899     /**
1900      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1901      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1902      *
1903      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1904      *
1905      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1906      * implement alternative mechanisms to perform token transfer, such as signature-based.
1907      *
1908      * Requirements:
1909      *
1910      * - `from` cannot be the zero address.
1911      * - `to` cannot be the zero address.
1912      * - `tokenId` token must exist and be owned by `from`.
1913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1914      *
1915      * Emits a {Transfer} event.
1916      */
1917     function _safeTransfer(
1918         address from,
1919         address to,
1920         uint256 tokenId,
1921         bytes memory data
1922     ) internal virtual {
1923         _transfer(from, to, tokenId);
1924         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1925     }
1926 
1927     /**
1928      * @dev Returns whether `tokenId` exists.
1929      *
1930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1931      *
1932      * Tokens start existing when they are minted (`_mint`),
1933      * and stop existing when they are burned (`_burn`).
1934      */
1935     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1936         return _owners[tokenId] != address(0);
1937     }
1938 
1939     /**
1940      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1941      *
1942      * Requirements:
1943      *
1944      * - `tokenId` must exist.
1945      */
1946     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1947         address owner = ERC721.ownerOf(tokenId);
1948         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1949     }
1950 
1951     /**
1952      * @dev Safely mints `tokenId` and transfers it to `to`.
1953      *
1954      * Requirements:
1955      *
1956      * - `tokenId` must not exist.
1957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1958      *
1959      * Emits a {Transfer} event.
1960      */
1961     function _safeMint(address to, uint256 tokenId) internal virtual {
1962         _safeMint(to, tokenId, "");
1963     }
1964 
1965     /**
1966      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1967      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1968      */
1969     function _safeMint(
1970         address to,
1971         uint256 tokenId,
1972         bytes memory data
1973     ) internal virtual {
1974         _mint(to, tokenId);
1975         require(
1976             _checkOnERC721Received(address(0), to, tokenId, data),
1977             "ERC721: transfer to non ERC721Receiver implementer"
1978         );
1979     }
1980 
1981     /**
1982      * @dev Mints `tokenId` and transfers it to `to`.
1983      *
1984      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1985      *
1986      * Requirements:
1987      *
1988      * - `tokenId` must not exist.
1989      * - `to` cannot be the zero address.
1990      *
1991      * Emits a {Transfer} event.
1992      */
1993     function _mint(address to, uint256 tokenId) internal virtual {
1994         require(to != address(0), "ERC721: mint to the zero address");
1995         require(!_exists(tokenId), "ERC721: token already minted");
1996 
1997         _beforeTokenTransfer(address(0), to, tokenId);
1998 
1999         _balances[to] += 1;
2000         _owners[tokenId] = to;
2001 
2002         emit Transfer(address(0), to, tokenId);
2003 
2004         _afterTokenTransfer(address(0), to, tokenId);
2005     }
2006 
2007     /**
2008      * @dev Destroys `tokenId`.
2009      * The approval is cleared when the token is burned.
2010      *
2011      * Requirements:
2012      *
2013      * - `tokenId` must exist.
2014      *
2015      * Emits a {Transfer} event.
2016      */
2017     function _burn(uint256 tokenId) internal virtual {
2018         address owner = ERC721.ownerOf(tokenId);
2019 
2020         _beforeTokenTransfer(owner, address(0), tokenId);
2021 
2022         // Clear approvals
2023         _approve(address(0), tokenId);
2024 
2025         _balances[owner] -= 1;
2026         delete _owners[tokenId];
2027 
2028         emit Transfer(owner, address(0), tokenId);
2029 
2030         _afterTokenTransfer(owner, address(0), tokenId);
2031     }
2032 
2033     /**
2034      * @dev Transfers `tokenId` from `from` to `to`.
2035      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2036      *
2037      * Requirements:
2038      *
2039      * - `to` cannot be the zero address.
2040      * - `tokenId` token must be owned by `from`.
2041      *
2042      * Emits a {Transfer} event.
2043      */
2044     function _transfer(
2045         address from,
2046         address to,
2047         uint256 tokenId
2048     ) internal virtual {
2049         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2050         require(to != address(0), "ERC721: transfer to the zero address");
2051 
2052         _beforeTokenTransfer(from, to, tokenId);
2053 
2054         // Clear approvals from the previous owner
2055         _approve(address(0), tokenId);
2056 
2057         _balances[from] -= 1;
2058         _balances[to] += 1;
2059         _owners[tokenId] = to;
2060 
2061         emit Transfer(from, to, tokenId);
2062 
2063         _afterTokenTransfer(from, to, tokenId);
2064     }
2065 
2066     /**
2067      * @dev Approve `to` to operate on `tokenId`
2068      *
2069      * Emits an {Approval} event.
2070      */
2071     function _approve(address to, uint256 tokenId) internal virtual {
2072         _tokenApprovals[tokenId] = to;
2073         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2074     }
2075 
2076     /**
2077      * @dev Approve `operator` to operate on all of `owner` tokens
2078      *
2079      * Emits an {ApprovalForAll} event.
2080      */
2081     function _setApprovalForAll(
2082         address owner,
2083         address operator,
2084         bool approved
2085     ) internal virtual {
2086         require(owner != operator, "ERC721: approve to caller");
2087         _operatorApprovals[owner][operator] = approved;
2088         emit ApprovalForAll(owner, operator, approved);
2089     }
2090 
2091     /**
2092      * @dev Reverts if the `tokenId` has not been minted yet.
2093      */
2094     function _requireMinted(uint256 tokenId) internal view virtual {
2095         require(_exists(tokenId), "ERC721: invalid token ID");
2096     }
2097 
2098     /**
2099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2100      * The call is not executed if the target address is not a contract.
2101      *
2102      * @param from address representing the previous owner of the given token ID
2103      * @param to target address that will receive the tokens
2104      * @param tokenId uint256 ID of the token to be transferred
2105      * @param data bytes optional data to send along with the call
2106      * @return bool whether the call correctly returned the expected magic value
2107      */
2108     function _checkOnERC721Received(
2109         address from,
2110         address to,
2111         uint256 tokenId,
2112         bytes memory data
2113     ) private returns (bool) {
2114         if (to.isContract()) {
2115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2116                 return retval == IERC721Receiver.onERC721Received.selector;
2117             } catch (bytes memory reason) {
2118                 if (reason.length == 0) {
2119                     revert("ERC721: transfer to non ERC721Receiver implementer");
2120                 } else {
2121                     /// @solidity memory-safe-assembly
2122                     assembly {
2123                         revert(add(32, reason), mload(reason))
2124                     }
2125                 }
2126             }
2127         } else {
2128             return true;
2129         }
2130     }
2131 
2132     /**
2133      * @dev Hook that is called before any token transfer. This includes minting
2134      * and burning.
2135      *
2136      * Calling conditions:
2137      *
2138      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2139      * transferred to `to`.
2140      * - When `from` is zero, `tokenId` will be minted for `to`.
2141      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2142      * - `from` and `to` are never both zero.
2143      *
2144      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2145      */
2146     function _beforeTokenTransfer(
2147         address from,
2148         address to,
2149         uint256 tokenId
2150     ) internal virtual {}
2151 
2152     /**
2153      * @dev Hook that is called after any transfer of tokens. This includes
2154      * minting and burning.
2155      *
2156      * Calling conditions:
2157      *
2158      * - when `from` and `to` are both non-zero.
2159      * - `from` and `to` are never both zero.
2160      *
2161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2162      */
2163     function _afterTokenTransfer(
2164         address from,
2165         address to,
2166         uint256 tokenId
2167     ) internal virtual {}
2168 }
2169 
2170 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
2171 
2172 
2173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2174 
2175 pragma solidity ^0.8.0;
2176 
2177 
2178 
2179 /**
2180  * @dev ERC721 token with pausable token transfers, minting and burning.
2181  *
2182  * Useful for scenarios such as preventing trades until the end of an evaluation
2183  * period, or having an emergency switch for freezing all token transfers in the
2184  * event of a large bug.
2185  */
2186 abstract contract ERC721Pausable is ERC721, Pausable {
2187     /**
2188      * @dev See {ERC721-_beforeTokenTransfer}.
2189      *
2190      * Requirements:
2191      *
2192      * - the contract must not be paused.
2193      */
2194     function _beforeTokenTransfer(
2195         address from,
2196         address to,
2197         uint256 tokenId
2198     ) internal virtual override {
2199         super._beforeTokenTransfer(from, to, tokenId);
2200 
2201         require(!paused(), "ERC721Pausable: token transfer while paused");
2202     }
2203 }
2204 
2205 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
2206 
2207 
2208 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
2209 
2210 pragma solidity ^0.8.0;
2211 
2212 
2213 
2214 /**
2215  * @title ERC721 Burnable Token
2216  * @dev ERC721 Token that can be burned (destroyed).
2217  */
2218 abstract contract ERC721Burnable is Context, ERC721 {
2219     /**
2220      * @dev Burns `tokenId`. See {ERC721-_burn}.
2221      *
2222      * Requirements:
2223      *
2224      * - The caller must own `tokenId` or be an approved operator.
2225      */
2226     function burn(uint256 tokenId) public virtual {
2227         //solhint-disable-next-line max-line-length
2228         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2229         _burn(tokenId);
2230     }
2231 }
2232 
2233 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2234 
2235 
2236 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2237 
2238 pragma solidity ^0.8.0;
2239 
2240 
2241 
2242 /**
2243  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2244  * enumerability of all the token ids in the contract as well as all token ids owned by each
2245  * account.
2246  */
2247 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2248     // Mapping from owner to list of owned token IDs
2249     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2250 
2251     // Mapping from token ID to index of the owner tokens list
2252     mapping(uint256 => uint256) private _ownedTokensIndex;
2253 
2254     // Array with all token ids, used for enumeration
2255     uint256[] private _allTokens;
2256 
2257     // Mapping from token id to position in the allTokens array
2258     mapping(uint256 => uint256) private _allTokensIndex;
2259 
2260     /**
2261      * @dev See {IERC165-supportsInterface}.
2262      */
2263     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2264         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2265     }
2266 
2267     /**
2268      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2269      */
2270     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2271         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2272         return _ownedTokens[owner][index];
2273     }
2274 
2275     /**
2276      * @dev See {IERC721Enumerable-totalSupply}.
2277      */
2278     function totalSupply() public view virtual override returns (uint256) {
2279         return _allTokens.length;
2280     }
2281 
2282     /**
2283      * @dev See {IERC721Enumerable-tokenByIndex}.
2284      */
2285     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2286         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2287         return _allTokens[index];
2288     }
2289 
2290     /**
2291      * @dev Hook that is called before any token transfer. This includes minting
2292      * and burning.
2293      *
2294      * Calling conditions:
2295      *
2296      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2297      * transferred to `to`.
2298      * - When `from` is zero, `tokenId` will be minted for `to`.
2299      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2300      * - `from` cannot be the zero address.
2301      * - `to` cannot be the zero address.
2302      *
2303      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2304      */
2305     function _beforeTokenTransfer(
2306         address from,
2307         address to,
2308         uint256 tokenId
2309     ) internal virtual override {
2310         super._beforeTokenTransfer(from, to, tokenId);
2311 
2312         if (from == address(0)) {
2313             _addTokenToAllTokensEnumeration(tokenId);
2314         } else if (from != to) {
2315             _removeTokenFromOwnerEnumeration(from, tokenId);
2316         }
2317         if (to == address(0)) {
2318             _removeTokenFromAllTokensEnumeration(tokenId);
2319         } else if (to != from) {
2320             _addTokenToOwnerEnumeration(to, tokenId);
2321         }
2322     }
2323 
2324     /**
2325      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2326      * @param to address representing the new owner of the given token ID
2327      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2328      */
2329     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2330         uint256 length = ERC721.balanceOf(to);
2331         _ownedTokens[to][length] = tokenId;
2332         _ownedTokensIndex[tokenId] = length;
2333     }
2334 
2335     /**
2336      * @dev Private function to add a token to this extension's token tracking data structures.
2337      * @param tokenId uint256 ID of the token to be added to the tokens list
2338      */
2339     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2340         _allTokensIndex[tokenId] = _allTokens.length;
2341         _allTokens.push(tokenId);
2342     }
2343 
2344     /**
2345      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2346      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2347      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2348      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2349      * @param from address representing the previous owner of the given token ID
2350      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2351      */
2352     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2353         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2354         // then delete the last slot (swap and pop).
2355 
2356         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2357         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2358 
2359         // When the token to delete is the last token, the swap operation is unnecessary
2360         if (tokenIndex != lastTokenIndex) {
2361             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2362 
2363             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2364             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2365         }
2366 
2367         // This also deletes the contents at the last position of the array
2368         delete _ownedTokensIndex[tokenId];
2369         delete _ownedTokens[from][lastTokenIndex];
2370     }
2371 
2372     /**
2373      * @dev Private function to remove a token from this extension's token tracking data structures.
2374      * This has O(1) time complexity, but alters the order of the _allTokens array.
2375      * @param tokenId uint256 ID of the token to be removed from the tokens list
2376      */
2377     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2378         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2379         // then delete the last slot (swap and pop).
2380 
2381         uint256 lastTokenIndex = _allTokens.length - 1;
2382         uint256 tokenIndex = _allTokensIndex[tokenId];
2383 
2384         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2385         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2386         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2387         uint256 lastTokenId = _allTokens[lastTokenIndex];
2388 
2389         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2390         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2391 
2392         // This also deletes the contents at the last position of the array
2393         delete _allTokensIndex[tokenId];
2394         _allTokens.pop();
2395     }
2396 }
2397 
2398 // File: @openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol
2399 
2400 
2401 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol)
2402 
2403 pragma solidity ^0.8.0;
2404 
2405 
2406 
2407 
2408 
2409 
2410 
2411 
2412 /**
2413  * @dev {ERC721} token, including:
2414  *
2415  *  - ability for holders to burn (destroy) their tokens
2416  *  - a minter role that allows for token minting (creation)
2417  *  - a pauser role that allows to stop all token transfers
2418  *  - token ID and URI autogeneration
2419  *
2420  * This contract uses {AccessControl} to lock permissioned functions using the
2421  * different roles - head to its documentation for details.
2422  *
2423  * The account that deploys the contract will be granted the minter and pauser
2424  * roles, as well as the default admin role, which will let it grant both minter
2425  * and pauser roles to other accounts.
2426  *
2427  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
2428  */
2429 contract ERC721PresetMinterPauserAutoId is
2430     Context,
2431     AccessControlEnumerable,
2432     ERC721Enumerable,
2433     ERC721Burnable,
2434     ERC721Pausable
2435 {
2436     using Counters for Counters.Counter;
2437 
2438     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2439     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2440 
2441     Counters.Counter private _tokenIdTracker;
2442 
2443     string private _baseTokenURI;
2444 
2445     /**
2446      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2447      * account that deploys the contract.
2448      *
2449      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2450      * See {ERC721-tokenURI}.
2451      */
2452     constructor(
2453         string memory name,
2454         string memory symbol,
2455         string memory baseTokenURI
2456     ) ERC721(name, symbol) {
2457         _baseTokenURI = baseTokenURI;
2458 
2459         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2460 
2461         _setupRole(MINTER_ROLE, _msgSender());
2462         _setupRole(PAUSER_ROLE, _msgSender());
2463     }
2464 
2465     function _baseURI() internal view virtual override returns (string memory) {
2466         return _baseTokenURI;
2467     }
2468 
2469     /**
2470      * @dev Creates a new token for `to`. Its token ID will be automatically
2471      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2472      * URI autogenerated based on the base URI passed at construction.
2473      *
2474      * See {ERC721-_mint}.
2475      *
2476      * Requirements:
2477      *
2478      * - the caller must have the `MINTER_ROLE`.
2479      */
2480     function mint(address to) public virtual {
2481         require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
2482 
2483         // We cannot just use balanceOf to create the new tokenId because tokens
2484         // can be burned (destroyed), so we need a separate counter.
2485         _mint(to, _tokenIdTracker.current());
2486         _tokenIdTracker.increment();
2487     }
2488 
2489     /**
2490      * @dev Pauses all token transfers.
2491      *
2492      * See {ERC721Pausable} and {Pausable-_pause}.
2493      *
2494      * Requirements:
2495      *
2496      * - the caller must have the `PAUSER_ROLE`.
2497      */
2498     function pause() public virtual {
2499         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to pause");
2500         _pause();
2501     }
2502 
2503     /**
2504      * @dev Unpauses all token transfers.
2505      *
2506      * See {ERC721Pausable} and {Pausable-_unpause}.
2507      *
2508      * Requirements:
2509      *
2510      * - the caller must have the `PAUSER_ROLE`.
2511      */
2512     function unpause() public virtual {
2513         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to unpause");
2514         _unpause();
2515     }
2516 
2517     function _beforeTokenTransfer(
2518         address from,
2519         address to,
2520         uint256 tokenId
2521     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
2522         super._beforeTokenTransfer(from, to, tokenId);
2523     }
2524 
2525     /**
2526      * @dev See {IERC165-supportsInterface}.
2527      */
2528     function supportsInterface(bytes4 interfaceId)
2529         public
2530         view
2531         virtual
2532         override(AccessControlEnumerable, ERC721, ERC721Enumerable)
2533         returns (bool)
2534     {
2535         return super.supportsInterface(interfaceId);
2536     }
2537 }
2538 
2539 // File: utils/ERC721B.sol
2540 
2541 
2542 
2543 pragma solidity ^0.8.0;
2544 
2545 
2546 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
2547     using Address for address;
2548 
2549     string private _name;
2550     string private _symbol;
2551 
2552     uint internal _burned;
2553     uint internal _offset;
2554     address[] internal _owners;
2555 
2556     mapping(uint => address) internal _tokenApprovals;
2557     mapping(address => mapping(address => bool)) private _operatorApprovals;
2558 
2559     constructor(string memory name_, string memory symbol_, uint offset) {
2560         _name = name_;
2561         _symbol = symbol_;
2562         _offset = offset;
2563         for(uint i; i < _offset; ++i ){
2564             _owners.push(address(0));
2565         }
2566     }
2567 
2568     //public
2569     function balanceOf(address owner) public view virtual override returns (uint) {
2570         require(owner != address(0), "ERC721: balance query for the zero address");
2571 
2572         uint count;
2573         for( uint i; i < _owners.length; ++i ){
2574           if( owner == _owners[i] )
2575             ++count;
2576         }
2577         return count;
2578     }
2579 
2580     function name() external view virtual override returns (string memory) {
2581         return _name;
2582     }
2583 
2584     function ownerOf(uint tokenId) public view virtual override returns (address) {
2585         address owner = _owners[tokenId];
2586         require(owner != address(0), "ERC721: owner query for nonexistent token");
2587         return owner;
2588     }
2589 
2590     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2591         return
2592             interfaceId == type(IERC721).interfaceId ||
2593             interfaceId == type(IERC721Metadata).interfaceId ||
2594             super.supportsInterface(interfaceId);
2595     }
2596 
2597     function symbol() external view virtual override returns (string memory) {
2598         return _symbol;
2599     }
2600 
2601     function totalSupply() public view virtual returns (uint) {
2602         return _owners.length - (_offset + _burned);
2603     }
2604 
2605 
2606     function approve(address to, uint tokenId) external virtual override {
2607         address owner = ERC721B.ownerOf(tokenId);
2608         require(to != owner, "ERC721: approval to current owner");
2609 
2610         require(
2611             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2612             "ERC721: approve caller is not owner nor approved for all"
2613         );
2614 
2615         _approve(to, tokenId);
2616     }
2617 
2618     function getApproved(uint tokenId) public view virtual override returns (address) {
2619         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2620         return _tokenApprovals[tokenId];
2621     }
2622 
2623     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2624         return _operatorApprovals[owner][operator];
2625     }
2626 
2627     function setApprovalForAll(address operator, bool approved) external virtual override {
2628         require(operator != _msgSender(), "ERC721: approve to caller");
2629         _operatorApprovals[_msgSender()][operator] = approved;
2630         emit ApprovalForAll(_msgSender(), operator, approved);
2631     }
2632 
2633     function transferFrom(
2634         address from,
2635         address to,
2636         uint tokenId
2637     ) public virtual override {
2638         //solhint-disable-next-line max-line-length
2639         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2640         _transfer(from, to, tokenId);
2641     }
2642 
2643     function safeTransferFrom(
2644         address from,
2645         address to,
2646         uint tokenId
2647     ) external virtual override {
2648         safeTransferFrom(from, to, tokenId, "");
2649     }
2650 
2651     function safeTransferFrom(
2652         address from,
2653         address to,
2654         uint tokenId,
2655         bytes memory _data
2656     ) public virtual override {
2657         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2658         _safeTransfer(from, to, tokenId, _data);
2659     }
2660 
2661 
2662     //internal
2663     function _approve(address to, uint tokenId) internal virtual {
2664         _tokenApprovals[tokenId] = to;
2665         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
2666     }
2667 
2668     function _beforeTokenTransfer(
2669         address from,
2670         address to,
2671         uint tokenId
2672     ) internal virtual {}
2673 
2674     function _burn(uint tokenId) internal virtual {
2675         address owner = ERC721B.ownerOf(tokenId);
2676 
2677         _beforeTokenTransfer(owner, address(0), tokenId);
2678 
2679         // Clear approvals
2680         _approve(address(0), tokenId);
2681         _owners[tokenId] = address(0);
2682 
2683         emit Transfer(owner, address(0), tokenId);
2684     }
2685 
2686     function _checkOnERC721Received(
2687         address from,
2688         address to,
2689         uint tokenId,
2690         bytes memory _data
2691     ) private returns (bool) {
2692         if (to.isContract()) {
2693             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2694                 return retval == IERC721Receiver.onERC721Received.selector;
2695             } catch (bytes memory reason) {
2696                 if (reason.length == 0) {
2697                     revert("ERC721: transfer to non ERC721Receiver implementer");
2698                 } else {
2699                     assembly {
2700                         revert(add(32, reason), mload(reason))
2701                     }
2702                 }
2703             }
2704         } else {
2705             return true;
2706         }
2707     }
2708 
2709     function _exists(uint tokenId) internal view virtual returns (bool) {
2710         return tokenId < _owners.length && _owners[tokenId] != address(0);
2711     }
2712 
2713     function _isApprovedOrOwner(address spender, uint tokenId) internal view virtual returns (bool) {
2714         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2715         address owner = ERC721B.ownerOf(tokenId);
2716         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2717     }
2718 
2719     function _mint(address to, uint tokenId) internal virtual {
2720         require(to != address(0), "ERC721: mint to the zero address");
2721         require(!_exists(tokenId), "ERC721: token already minted");
2722 
2723         _beforeTokenTransfer(address(0), to, tokenId);
2724         _owners.push(to);
2725 
2726         emit Transfer(address(0), to, tokenId);
2727     }
2728 
2729     function _next() internal view virtual returns( uint ){
2730         return _owners.length;
2731     }
2732 
2733     function _safeMint(address to, uint tokenId) internal virtual {
2734         _safeMint(to, tokenId, "");
2735     }
2736 
2737     function _safeMint(
2738         address to,
2739         uint tokenId,
2740         bytes memory _data
2741     ) internal virtual {
2742         _mint(to, tokenId);
2743         require(
2744             _checkOnERC721Received(address(0), to, tokenId, _data),
2745             "ERC721: transfer to non ERC721Receiver implementer"
2746         );
2747     }
2748 
2749     function _safeTransfer(
2750         address from,
2751         address to,
2752         uint tokenId,
2753         bytes memory _data
2754     ) internal virtual {
2755         _transfer(from, to, tokenId);
2756         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2757     }
2758 
2759     function _transfer(
2760         address from,
2761         address to,
2762         uint tokenId
2763     ) internal virtual {
2764         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2765         require(to != address(0), "ERC721: transfer to the zero address");
2766 
2767         _beforeTokenTransfer(from, to, tokenId);
2768 
2769         // Clear approvals from the previous owner
2770         _approve(address(0), tokenId);
2771         _owners[tokenId] = to;
2772 
2773         emit Transfer(from, to, tokenId);
2774     }
2775 }
2776 
2777 // File: utils/ERC721EnumerableLite.sol
2778 
2779 
2780 
2781 pragma solidity ^0.8.0;
2782 
2783 
2784 
2785 abstract contract ERC721EnumerableLite is ERC721B, IERC721Batch, IERC721Enumerable {
2786     mapping(address => uint) internal _balances;
2787 
2788     function isOwnerOf( address account, uint[] calldata tokenIds ) external view virtual override returns( bool ){
2789         for(uint i; i < tokenIds.length; ++i ){
2790             if( _owners[ tokenIds[i] ] != account )
2791                 return false;
2792         }
2793 
2794         return true;
2795     }
2796 
2797     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
2798         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2799     }
2800 
2801     function tokenOfOwnerByIndex(address owner, uint index) public view override returns (uint tokenId) {
2802         uint count;
2803         for( uint i; i < _owners.length; ++i ){
2804             if( owner == _owners[i] ){
2805                 if( count == index )
2806                     return i;
2807                 else
2808                     ++count;
2809             }
2810         }
2811 
2812         revert("ERC721Enumerable: owner index out of bounds");
2813     }
2814 
2815     function tokenByIndex(uint index) external view virtual override returns (uint) {
2816         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
2817         return index;
2818     }
2819 
2820     function totalSupply() public view virtual override( ERC721B, IERC721Enumerable ) returns (uint) {
2821         return _owners.length - (_offset + _burned);
2822     }
2823 
2824     function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external override{
2825         for(uint i; i < tokenIds.length; ++i ){
2826             safeTransferFrom( from, to, tokenIds[i], data );
2827         }
2828     }
2829 
2830     function walletOfOwner( address account ) external view virtual override returns( uint[] memory ){
2831         uint quantity = balanceOf( account );
2832         uint[] memory wallet = new uint[]( quantity );
2833         for( uint i; i < quantity; ++i ){
2834             wallet[i] = tokenOfOwnerByIndex( account, i );
2835         }
2836         return wallet;
2837     }
2838 }
2839 
2840 // File: @openzeppelin/contracts/access/Ownable.sol
2841 
2842 
2843 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2844 
2845 pragma solidity ^0.8.0;
2846 
2847 
2848 /**
2849  * @dev Contract module which provides a basic access control mechanism, where
2850  * there is an account (an owner) that can be granted exclusive access to
2851  * specific functions.
2852  *
2853  * By default, the owner account will be the one that deploys the contract. This
2854  * can later be changed with {transferOwnership}.
2855  *
2856  * This module is used through inheritance. It will make available the modifier
2857  * `onlyOwner`, which can be applied to your functions to restrict their use to
2858  * the owner.
2859  */
2860 abstract contract Ownable is Context {
2861     address private _owner;
2862 
2863     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2864 
2865     /**
2866      * @dev Initializes the contract setting the deployer as the initial owner.
2867      */
2868     constructor() {
2869         _transferOwnership(_msgSender());
2870     }
2871 
2872     /**
2873      * @dev Throws if called by any account other than the owner.
2874      */
2875     modifier onlyOwner() {
2876         _checkOwner();
2877         _;
2878     }
2879 
2880     /**
2881      * @dev Returns the address of the current owner.
2882      */
2883     function owner() public view virtual returns (address) {
2884         return _owner;
2885     }
2886 
2887     /**
2888      * @dev Throws if the sender is not the owner.
2889      */
2890     function _checkOwner() internal view virtual {
2891         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2892     }
2893 
2894     /**
2895      * @dev Leaves the contract without owner. It will not be possible to call
2896      * `onlyOwner` functions anymore. Can only be called by the current owner.
2897      *
2898      * NOTE: Renouncing ownership will leave the contract without an owner,
2899      * thereby removing any functionality that is only available to the owner.
2900      */
2901     function renounceOwnership() public virtual onlyOwner {
2902         _transferOwnership(address(0));
2903     }
2904 
2905     /**
2906      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2907      * Can only be called by the current owner.
2908      */
2909     function transferOwnership(address newOwner) public virtual onlyOwner {
2910         require(newOwner != address(0), "Ownable: new owner is the zero address");
2911         _transferOwnership(newOwner);
2912     }
2913 
2914     /**
2915      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2916      * Internal function without access restriction.
2917      */
2918     function _transferOwnership(address newOwner) internal virtual {
2919         address oldOwner = _owner;
2920         _owner = newOwner;
2921         emit OwnershipTransferred(oldOwner, newOwner);
2922     }
2923 }
2924 
2925 // File: utils/Delegated.sol
2926 
2927 
2928 
2929 pragma solidity ^0.8.0;
2930 
2931 
2932 contract Delegated is Ownable{
2933   mapping(address => bool) internal _delegates;
2934 
2935   constructor(){
2936     _delegates[owner()] = true;
2937   }
2938 
2939   modifier onlyDelegates {
2940     require(_delegates[msg.sender], "Invalid delegate" );
2941     _;
2942   }
2943 
2944   //onlyOwner
2945   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
2946     return _delegates[addr];
2947   }
2948 
2949   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
2950     _delegates[addr] = isDelegate_;
2951   }
2952 
2953   function transferOwnership(address newOwner) public virtual override onlyOwner {
2954     _delegates[newOwner] = true;
2955     super.transferOwnership( newOwner );
2956   }
2957 }
2958 
2959 // File: gg-staking-v2.1.sol
2960 
2961 pragma solidity ^0.8.7;
2962 
2963 
2964 
2965 
2966 
2967 
2968 
2969 interface IFlowers is IERC20 {
2970     function mint(address to, uint256 amount) external;
2971     function getPendingStakeRewards(uint256 tokenId) external returns (uint pending);
2972 }
2973 
2974 interface IGoatGauds is IERC721 {
2975     function burnFrom(address, uint[] calldata) external payable;
2976     function resurrect(uint[] calldata, address[] calldata) external;
2977     function walletOfOwner(address) external view returns (uint[] memory tokens);
2978 }
2979 
2980 error SoulBound ();
2981 
2982 contract StakedGoats is Delegated, ERC721EnumerableLite {
2983     using Strings for uint;
2984 
2985     uint256 constant token = 1e18;
2986     uint256 constant stakingTime = 180 seconds;
2987     uint256 public rewardPerHour = (111 * token) / 24;
2988     uint256 public stakedTotal;
2989     uint256 public stakingStartTime;
2990 
2991     string private _tokenURIPrefix = "https://goatgauds.s3.us-west-1.amazonaws.com/metadata/staked/";
2992     string private _tokenURISuffix = ".json";
2993 
2994     // Goat Gauds NFT Contract Address
2995     address contractGoatGauds = 0x5CEbE5Cde01aB154fB46B7984D6354DA367bCBaF;
2996     // GG Flowers Token Contract Address
2997     address contractFlowers = 0x0750e1738F56F81791f0E124d6922fEfe037daE8;
2998 
2999     constructor()
3000     Delegated()
3001     ERC721B("Staked Goat Gauds", "SGG", 0) {
3002     }
3003 
3004     modifier onlySender {
3005         require(msg.sender == tx.origin, "No smart contracts!");
3006         _;
3007     }
3008 
3009     struct Staker {
3010         uint256[] stakedTokens;
3011         uint256 stakeCount;
3012     }
3013 
3014     struct Stake {
3015         uint256 tokenId;
3016         uint256 since;
3017         uint256 cooldown;
3018     }
3019 
3020     /// @notice mapping of a tokenId to its stake
3021     mapping (uint256 => Stake) tokenIdToStake;
3022 
3023     /// @notice mapping of a staker to its wallet
3024     mapping(address => Staker) public stakers;
3025 
3026     /// @notice mapping from token ID to owner address
3027     mapping(uint256 => address) public tokenOwner;
3028 
3029     /// @notice mapping of SGG tokens from tokenIndex to original Token ID
3030     mapping(uint256 => uint256) public tokenIdToIndex;
3031 
3032     /// @notice mapping of SGG tokens from tokenIndex to original Token ID
3033     mapping(uint256 => uint256) public indexToTokenId;
3034 
3035     bool initialized;
3036 
3037     /// @notice event emitted when a user has staked an nft
3038     event Staked(address owner, uint256[] tokens);
3039 
3040     /// @notice event emitted when a users NFT has been migrated from old staking contract
3041     event Migrated(uint256 ggToken, address owner, uint256 sggToken, uint256 flowersMinted);
3042 
3043     /// @notice event emitted when a user has unstaked an nft
3044     event Unstaked(address[] owners, uint256[] tokens);
3045 
3046     /// @notice event emitted when a user claims rewards
3047     event RewardPaid(address indexed user, uint256 reward);
3048 
3049     function tokenURI(uint tokenId) external view override returns (string memory) {
3050         require(_exists(tokenId), "Query for nonexistent token");
3051         return string(abi.encodePacked(_tokenURIPrefix, indexToTokenId[tokenId].toString(), _tokenURISuffix));
3052     }
3053 
3054     function isInitialized() public view returns (bool init) {
3055         if (initialized) {return true;} else {return false;}
3056     }
3057 
3058      // Owner functions
3059 
3060     function setContractAddr(address contractGoatGauds_, address contractFlowers_) public onlyOwner {
3061         contractGoatGauds = contractGoatGauds_;
3062         contractFlowers = contractFlowers_;
3063     }
3064 
3065     function setRewards(uint stakingReward_) public onlyOwner {
3066         rewardPerHour = stakingReward_;
3067     }
3068 
3069     function initStaking() public onlyOwner {
3070         require(
3071             !initialized,
3072             "Staking already started!"
3073             );
3074         stakingStartTime = block.timestamp;
3075         initialized = true;
3076     }
3077 
3078     function getStakedTokens(address user_) public view returns (uint256[] memory tokenIds) {
3079         Staker storage _staker = stakers[user_];
3080         uint256[] memory _tokens = _staker.stakedTokens;
3081         return _tokens;
3082     }
3083 
3084 
3085     function migrate(uint[] memory tokenIds_, address[] memory addresses_) public onlyOwner {
3086         uint _mintId = totalSupply();
3087         for (uint256 i = 0; i < tokenIds_.length; i++) {
3088             address _user = addresses_[i];
3089             Staker storage _staker = stakers[_user];
3090             Stake storage _stake = tokenIdToStake[tokenIds_[i]];
3091             _stake.tokenId = tokenIds_[i];
3092             _stake.since = block.timestamp;
3093             _stake.cooldown = block.timestamp + stakingTime;
3094             _staker.stakedTokens.push(tokenIds_[i]);
3095             tokenOwner[tokenIds_[i]] = _user;
3096             _staker.stakeCount++;
3097             uint _totalClaim = IFlowers(contractFlowers).getPendingStakeRewards(tokenIds_[i]);
3098             IFlowers(contractFlowers).mint(_user, _totalClaim);
3099             indexToTokenId[_mintId] = tokenIds_[i];
3100             tokenIdToIndex[tokenIds_[i]] = _mintId;
3101             _mint(addresses_[i], _mintId++);
3102             emit Migrated(tokenIds_[i], _user, _mintId, _totalClaim);
3103         }
3104         stakedTotal = stakedTotal + tokenIds_.length;
3105     }
3106 
3107     function stakeNFT(uint[] memory tokenIds_) public onlySender {
3108         address _user = msg.sender;
3109         uint _numTokens = tokenIds_.length;
3110         require(
3111             initialized,
3112             "The staking has not started!"
3113             );
3114         Staker storage _staker = stakers[_user];
3115         for (uint256 i = 0; i < _numTokens; i++) {
3116             require(
3117                 IGoatGauds(contractGoatGauds).ownerOf(tokenIds_[i]) == _user,
3118                 "You must be the owner of the token!"
3119                 );
3120             Stake storage _stake = tokenIdToStake[tokenIds_[i]];
3121             _stake.tokenId = tokenIds_[i];
3122             _stake.since = block.timestamp;
3123             _stake.cooldown = block.timestamp + stakingTime;
3124             _staker.stakedTokens.push(tokenIds_[i]);
3125             tokenOwner[tokenIds_[i]] = _user;
3126         }
3127         _staker.stakeCount = _staker.stakeCount + _numTokens;
3128         stakedTotal = stakedTotal + _numTokens;
3129         IGoatGauds(contractGoatGauds).burnFrom(_user, tokenIds_);
3130         uint _mintId = totalSupply();
3131         for (uint256 i = 0; i < _numTokens; i++) {
3132             indexToTokenId[_mintId] = tokenIds_[i];
3133             tokenIdToIndex[tokenIds_[i]] = _mintId;
3134             _mint(_user, _mintId++);
3135         }
3136         emit Staked(_user, tokenIds_);
3137     }
3138 
3139     function stakedSince(uint tokenId_) public view returns (uint _since) {
3140         Stake storage _stake = tokenIdToStake[tokenId_];
3141         if (_stake.since == 0) {
3142             return block.timestamp;
3143         }
3144         return _stake.since;
3145     }
3146 
3147     function stakeDuration(uint tokenId_) public view returns (uint _difference) {
3148         return block.timestamp - stakedSince(tokenId_);
3149     }
3150 
3151     function getPendingStakeRewards(uint tokenId_) public view returns (uint _pending) {
3152         return stakeDuration(tokenId_) * rewardPerHour / 1 hours;
3153     }
3154 
3155     function claimStake(uint[] memory tokenIds_) public onlySender {
3156         address _user;
3157         uint _totalClaim;
3158         for (uint i = 0; i < tokenIds_.length; i++) {
3159             _user = tokenOwner[tokenIds_[i]];
3160             _totalClaim += getPendingStakeRewards(tokenIds_[i]);
3161             Stake storage _stake = tokenIdToStake[tokenIds_[i]];
3162             _stake.since = block.timestamp;
3163         }
3164         require(_totalClaim > 0, "No rewards pending!");
3165         IFlowers(contractFlowers).mint(_user, _totalClaim);
3166         emit RewardPaid(_user, _totalClaim);
3167     }
3168 
3169     function getIndex(uint element, uint[] memory arr) pure internal returns(uint index) {
3170         bytes32 encodedElement = keccak256(abi.encode(element));
3171         for (uint i = 0 ; i < arr.length; i++) {
3172             if (encodedElement == keccak256(abi.encode(arr[i]))) {
3173                 return i;
3174             }
3175         }
3176     }
3177 
3178     function withdrawNFT(uint[] memory tokenIds_) public onlySender {
3179         address _user = msg.sender;
3180         for (uint256 i = 0; i < tokenIds_.length; i++) {
3181             require(
3182                 tokenOwner[tokenIds_[i]] == _user,
3183                 "Cannot withdraw unowned NFT!"
3184             );
3185             Stake storage _stake = tokenIdToStake[tokenIds_[i]];
3186             require(
3187                 _stake.cooldown < block.timestamp,
3188                 "Cooldown: Must wait for cooldown period before withdrawing!"
3189             );
3190         }
3191         claimStake(tokenIds_);
3192         for (uint256 i = 0; i < tokenIds_.length; i++) {
3193             Staker storage _staker = stakers[_user];
3194             uint[] storage _stakedTokens = _staker.stakedTokens;
3195             _stakedTokens[getIndex(tokenIds_[i], _stakedTokens)] = _stakedTokens[_stakedTokens.length - 1];
3196             _stakedTokens.pop();
3197             _staker.stakedTokens = _stakedTokens;
3198             _staker.stakeCount--;
3199             delete tokenIdToStake[tokenIds_[i]];
3200             delete tokenOwner[tokenIds_[i]];
3201         }
3202         stakedTotal = stakedTotal - tokenIds_.length;
3203         address[] memory _userToArr = new address[](tokenIds_.length);
3204         for (uint i = 0; i < tokenIds_.length; i++) {
3205             _userToArr[i] = _user;
3206         }
3207         for (uint256 i = 0; i < tokenIds_.length; i++) {
3208             _burn(tokenIdToIndex[tokenIds_[i]]);
3209             delete indexToTokenId[tokenIdToIndex[tokenIds_[i]]];
3210             delete tokenIdToIndex[tokenIds_[i]];
3211         }
3212         IGoatGauds(contractGoatGauds).resurrect(tokenIds_, _userToArr);
3213         emit Unstaked(_userToArr, tokenIds_);
3214     }
3215 
3216     //internal
3217     function _burn(uint tokenId) internal override {
3218         address curOwner = ERC721B.ownerOf(tokenId);
3219 
3220         // Clear approvals
3221         _approve(owner(), tokenId);
3222         _owners[tokenId] = address(0);
3223         emit Transfer(curOwner, address(0), tokenId);
3224     }
3225 
3226     function _mint(address to, uint tokenId) internal override {
3227         _owners.push(to);
3228         emit Transfer(address(0), to, tokenId);
3229     }
3230 
3231     /// --- Disabling Transfer Of Soulbound NFT --- ///
3232 
3233 
3234     /// @notice Function disabled as cannot transfer a soulbound nft
3235     function safeTransferFrom(
3236         address, 
3237         address, 
3238         uint256,
3239         bytes memory
3240     ) public pure override {
3241         revert SoulBound();
3242     }
3243 
3244     /// @notice Function disabled as cannot transfer a soulbound nft
3245     function safeTransferFrom(
3246         address, 
3247         address, 
3248         uint256 
3249     ) public pure override {
3250         revert SoulBound();
3251     }
3252 
3253     /// @notice Function disabled as cannot transfer a soulbound nft
3254     function transferFrom(
3255         address, 
3256         address, 
3257         uint256
3258     ) public pure override {
3259         revert SoulBound();
3260     }
3261 
3262     /// @notice Function disabled as cannot transfer a soulbound nft
3263     function approve(
3264         address, 
3265         uint256
3266     ) public pure override {
3267         revert SoulBound();
3268     }
3269 
3270     /// @notice Function disabled as cannot transfer a soulbound nft
3271     function setApprovalForAll(
3272         address, 
3273         bool
3274     ) public pure override {
3275         revert SoulBound();
3276     }
3277 
3278     /// @notice Function disabled as cannot transfer a soulbound nft
3279     function getApproved(
3280         uint256
3281     ) public pure override returns (address) {
3282         revert SoulBound();
3283     }
3284 
3285     /// @notice Function disabled as cannot transfer a soulbound nft
3286     function isApprovedForAll(
3287         address, 
3288         address
3289     ) public pure override returns (bool) {
3290         revert SoulBound();
3291     }
3292 
3293 }