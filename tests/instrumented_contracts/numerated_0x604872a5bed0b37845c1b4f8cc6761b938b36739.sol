1 // File: contracts/JulienDurix/brushes.sol
2 
3 pragma solidity ^0.8.6;
4 
5 abstract contract Brushes {
6     function burn(uint256 tokenId)
7         external
8         virtual;
9 
10     function ownerOf(uint256 tokenId) public view virtual returns (address);
11 }
12 // File: @openzeppelin/contracts/utils/Counters.sol
13 
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @title Counters
21  * @author Matt Condon (@shrugs)
22  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
23  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
24  *
25  * Include with `using Counters for Counters.Counter;`
26  */
27 library Counters {
28     struct Counter {
29         // This variable should never be directly accessed by users of the library: interactions must be restricted to
30         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
31         // this feature: see https://github.com/ethereum/solidity/issues/4637
32         uint256 _value; // default: 0
33     }
34 
35     function current(Counter storage counter) internal view returns (uint256) {
36         return counter._value;
37     }
38 
39     function increment(Counter storage counter) internal {
40         unchecked {
41             counter._value += 1;
42         }
43     }
44 
45     function decrement(Counter storage counter) internal {
46         uint256 value = counter._value;
47         require(value > 0, "Counter: decrement overflow");
48         unchecked {
49             counter._value = value - 1;
50         }
51     }
52 
53     function reset(Counter storage counter) internal {
54         counter._value = 0;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
59 
60 
61 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev Library for managing
67  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
68  * types.
69  *
70  * Sets have the following properties:
71  *
72  * - Elements are added, removed, and checked for existence in constant time
73  * (O(1)).
74  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
75  *
76  * ```
77  * contract Example {
78  *     // Add the library methods
79  *     using EnumerableSet for EnumerableSet.AddressSet;
80  *
81  *     // Declare a set state variable
82  *     EnumerableSet.AddressSet private mySet;
83  * }
84  * ```
85  *
86  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
87  * and `uint256` (`UintSet`) are supported.
88  *
89  * [WARNING]
90  * ====
91  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
92  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
93  *
94  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
95  * ====
96  */
97 library EnumerableSet {
98     // To implement this library for multiple types with as little code
99     // repetition as possible, we write it in terms of a generic Set type with
100     // bytes32 values.
101     // The Set implementation uses private functions, and user-facing
102     // implementations (such as AddressSet) are just wrappers around the
103     // underlying Set.
104     // This means that we can only create new EnumerableSets for types that fit
105     // in bytes32.
106 
107     struct Set {
108         // Storage of set values
109         bytes32[] _values;
110         // Position of the value in the `values` array, plus 1 because index 0
111         // means a value is not in the set.
112         mapping(bytes32 => uint256) _indexes;
113     }
114 
115     /**
116      * @dev Add a value to a set. O(1).
117      *
118      * Returns true if the value was added to the set, that is if it was not
119      * already present.
120      */
121     function _add(Set storage set, bytes32 value) private returns (bool) {
122         if (!_contains(set, value)) {
123             set._values.push(value);
124             // The value is stored at length-1, but we add 1 to all indexes
125             // and use 0 as a sentinel value
126             set._indexes[value] = set._values.length;
127             return true;
128         } else {
129             return false;
130         }
131     }
132 
133     /**
134      * @dev Removes a value from a set. O(1).
135      *
136      * Returns true if the value was removed from the set, that is if it was
137      * present.
138      */
139     function _remove(Set storage set, bytes32 value) private returns (bool) {
140         // We read and store the value's index to prevent multiple reads from the same storage slot
141         uint256 valueIndex = set._indexes[value];
142 
143         if (valueIndex != 0) {
144             // Equivalent to contains(set, value)
145             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
146             // the array, and then remove the last element (sometimes called as 'swap and pop').
147             // This modifies the order of the array, as noted in {at}.
148 
149             uint256 toDeleteIndex = valueIndex - 1;
150             uint256 lastIndex = set._values.length - 1;
151 
152             if (lastIndex != toDeleteIndex) {
153                 bytes32 lastValue = set._values[lastIndex];
154 
155                 // Move the last value to the index where the value to delete is
156                 set._values[toDeleteIndex] = lastValue;
157                 // Update the index for the moved value
158                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
159             }
160 
161             // Delete the slot where the moved value was stored
162             set._values.pop();
163 
164             // Delete the index for the deleted slot
165             delete set._indexes[value];
166 
167             return true;
168         } else {
169             return false;
170         }
171     }
172 
173     /**
174      * @dev Returns true if the value is in the set. O(1).
175      */
176     function _contains(Set storage set, bytes32 value) private view returns (bool) {
177         return set._indexes[value] != 0;
178     }
179 
180     /**
181      * @dev Returns the number of values on the set. O(1).
182      */
183     function _length(Set storage set) private view returns (uint256) {
184         return set._values.length;
185     }
186 
187     /**
188      * @dev Returns the value stored at position `index` in the set. O(1).
189      *
190      * Note that there are no guarantees on the ordering of values inside the
191      * array, and it may change when more values are added or removed.
192      *
193      * Requirements:
194      *
195      * - `index` must be strictly less than {length}.
196      */
197     function _at(Set storage set, uint256 index) private view returns (bytes32) {
198         return set._values[index];
199     }
200 
201     /**
202      * @dev Return the entire set in an array
203      *
204      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
205      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
206      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
207      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
208      */
209     function _values(Set storage set) private view returns (bytes32[] memory) {
210         return set._values;
211     }
212 
213     // Bytes32Set
214 
215     struct Bytes32Set {
216         Set _inner;
217     }
218 
219     /**
220      * @dev Add a value to a set. O(1).
221      *
222      * Returns true if the value was added to the set, that is if it was not
223      * already present.
224      */
225     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
226         return _add(set._inner, value);
227     }
228 
229     /**
230      * @dev Removes a value from a set. O(1).
231      *
232      * Returns true if the value was removed from the set, that is if it was
233      * present.
234      */
235     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
236         return _remove(set._inner, value);
237     }
238 
239     /**
240      * @dev Returns true if the value is in the set. O(1).
241      */
242     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
243         return _contains(set._inner, value);
244     }
245 
246     /**
247      * @dev Returns the number of values in the set. O(1).
248      */
249     function length(Bytes32Set storage set) internal view returns (uint256) {
250         return _length(set._inner);
251     }
252 
253     /**
254      * @dev Returns the value stored at position `index` in the set. O(1).
255      *
256      * Note that there are no guarantees on the ordering of values inside the
257      * array, and it may change when more values are added or removed.
258      *
259      * Requirements:
260      *
261      * - `index` must be strictly less than {length}.
262      */
263     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
264         return _at(set._inner, index);
265     }
266 
267     /**
268      * @dev Return the entire set in an array
269      *
270      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
271      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
272      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
273      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
274      */
275     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
276         return _values(set._inner);
277     }
278 
279     // AddressSet
280 
281     struct AddressSet {
282         Set _inner;
283     }
284 
285     /**
286      * @dev Add a value to a set. O(1).
287      *
288      * Returns true if the value was added to the set, that is if it was not
289      * already present.
290      */
291     function add(AddressSet storage set, address value) internal returns (bool) {
292         return _add(set._inner, bytes32(uint256(uint160(value))));
293     }
294 
295     /**
296      * @dev Removes a value from a set. O(1).
297      *
298      * Returns true if the value was removed from the set, that is if it was
299      * present.
300      */
301     function remove(AddressSet storage set, address value) internal returns (bool) {
302         return _remove(set._inner, bytes32(uint256(uint160(value))));
303     }
304 
305     /**
306      * @dev Returns true if the value is in the set. O(1).
307      */
308     function contains(AddressSet storage set, address value) internal view returns (bool) {
309         return _contains(set._inner, bytes32(uint256(uint160(value))));
310     }
311 
312     /**
313      * @dev Returns the number of values in the set. O(1).
314      */
315     function length(AddressSet storage set) internal view returns (uint256) {
316         return _length(set._inner);
317     }
318 
319     /**
320      * @dev Returns the value stored at position `index` in the set. O(1).
321      *
322      * Note that there are no guarantees on the ordering of values inside the
323      * array, and it may change when more values are added or removed.
324      *
325      * Requirements:
326      *
327      * - `index` must be strictly less than {length}.
328      */
329     function at(AddressSet storage set, uint256 index) internal view returns (address) {
330         return address(uint160(uint256(_at(set._inner, index))));
331     }
332 
333     /**
334      * @dev Return the entire set in an array
335      *
336      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
337      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
338      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
339      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
340      */
341     function values(AddressSet storage set) internal view returns (address[] memory) {
342         bytes32[] memory store = _values(set._inner);
343         address[] memory result;
344 
345         /// @solidity memory-safe-assembly
346         assembly {
347             result := store
348         }
349 
350         return result;
351     }
352 
353     // UintSet
354 
355     struct UintSet {
356         Set _inner;
357     }
358 
359     /**
360      * @dev Add a value to a set. O(1).
361      *
362      * Returns true if the value was added to the set, that is if it was not
363      * already present.
364      */
365     function add(UintSet storage set, uint256 value) internal returns (bool) {
366         return _add(set._inner, bytes32(value));
367     }
368 
369     /**
370      * @dev Removes a value from a set. O(1).
371      *
372      * Returns true if the value was removed from the set, that is if it was
373      * present.
374      */
375     function remove(UintSet storage set, uint256 value) internal returns (bool) {
376         return _remove(set._inner, bytes32(value));
377     }
378 
379     /**
380      * @dev Returns true if the value is in the set. O(1).
381      */
382     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
383         return _contains(set._inner, bytes32(value));
384     }
385 
386     /**
387      * @dev Returns the number of values on the set. O(1).
388      */
389     function length(UintSet storage set) internal view returns (uint256) {
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
403     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
404         return uint256(_at(set._inner, index));
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
415     function values(UintSet storage set) internal view returns (uint256[] memory) {
416         bytes32[] memory store = _values(set._inner);
417         uint256[] memory result;
418 
419         /// @solidity memory-safe-assembly
420         assembly {
421             result := store
422         }
423 
424         return result;
425     }
426 }
427 
428 // File: @openzeppelin/contracts/access/IAccessControl.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev External interface of AccessControl declared to support ERC165 detection.
437  */
438 interface IAccessControl {
439     /**
440      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
441      *
442      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
443      * {RoleAdminChanged} not being emitted signaling this.
444      *
445      * _Available since v3.1._
446      */
447     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
448 
449     /**
450      * @dev Emitted when `account` is granted `role`.
451      *
452      * `sender` is the account that originated the contract call, an admin role
453      * bearer except when using {AccessControl-_setupRole}.
454      */
455     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
456 
457     /**
458      * @dev Emitted when `account` is revoked `role`.
459      *
460      * `sender` is the account that originated the contract call:
461      *   - if using `revokeRole`, it is the admin role bearer
462      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
463      */
464     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
465 
466     /**
467      * @dev Returns `true` if `account` has been granted `role`.
468      */
469     function hasRole(bytes32 role, address account) external view returns (bool);
470 
471     /**
472      * @dev Returns the admin role that controls `role`. See {grantRole} and
473      * {revokeRole}.
474      *
475      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
476      */
477     function getRoleAdmin(bytes32 role) external view returns (bytes32);
478 
479     /**
480      * @dev Grants `role` to `account`.
481      *
482      * If `account` had not been already granted `role`, emits a {RoleGranted}
483      * event.
484      *
485      * Requirements:
486      *
487      * - the caller must have ``role``'s admin role.
488      */
489     function grantRole(bytes32 role, address account) external;
490 
491     /**
492      * @dev Revokes `role` from `account`.
493      *
494      * If `account` had been granted `role`, emits a {RoleRevoked} event.
495      *
496      * Requirements:
497      *
498      * - the caller must have ``role``'s admin role.
499      */
500     function revokeRole(bytes32 role, address account) external;
501 
502     /**
503      * @dev Revokes `role` from the calling account.
504      *
505      * Roles are often managed via {grantRole} and {revokeRole}: this function's
506      * purpose is to provide a mechanism for accounts to lose their privileges
507      * if they are compromised (such as when a trusted device is misplaced).
508      *
509      * If the calling account had been granted `role`, emits a {RoleRevoked}
510      * event.
511      *
512      * Requirements:
513      *
514      * - the caller must be `account`.
515      */
516     function renounceRole(bytes32 role, address account) external;
517 }
518 
519 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 
527 /**
528  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
529  */
530 interface IAccessControlEnumerable is IAccessControl {
531     /**
532      * @dev Returns one of the accounts that have `role`. `index` must be a
533      * value between 0 and {getRoleMemberCount}, non-inclusive.
534      *
535      * Role bearers are not sorted in any particular way, and their ordering may
536      * change at any point.
537      *
538      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
539      * you perform all queries on the same block. See the following
540      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
541      * for more information.
542      */
543     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
544 
545     /**
546      * @dev Returns the number of accounts that have `role`. Can be used
547      * together with {getRoleMember} to enumerate all bearers of a role.
548      */
549     function getRoleMemberCount(bytes32 role) external view returns (uint256);
550 }
551 
552 // File: @openzeppelin/contracts/utils/Strings.sol
553 
554 
555 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev String operations.
561  */
562 library Strings {
563     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
564     uint8 private constant _ADDRESS_LENGTH = 20;
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
568      */
569     function toString(uint256 value) internal pure returns (string memory) {
570         // Inspired by OraclizeAPI's implementation - MIT licence
571         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
572 
573         if (value == 0) {
574             return "0";
575         }
576         uint256 temp = value;
577         uint256 digits;
578         while (temp != 0) {
579             digits++;
580             temp /= 10;
581         }
582         bytes memory buffer = new bytes(digits);
583         while (value != 0) {
584             digits -= 1;
585             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
586             value /= 10;
587         }
588         return string(buffer);
589     }
590 
591     /**
592      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
593      */
594     function toHexString(uint256 value) internal pure returns (string memory) {
595         if (value == 0) {
596             return "0x00";
597         }
598         uint256 temp = value;
599         uint256 length = 0;
600         while (temp != 0) {
601             length++;
602             temp >>= 8;
603         }
604         return toHexString(value, length);
605     }
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
609      */
610     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
611         bytes memory buffer = new bytes(2 * length + 2);
612         buffer[0] = "0";
613         buffer[1] = "x";
614         for (uint256 i = 2 * length + 1; i > 1; --i) {
615             buffer[i] = _HEX_SYMBOLS[value & 0xf];
616             value >>= 4;
617         }
618         require(value == 0, "Strings: hex length insufficient");
619         return string(buffer);
620     }
621 
622     /**
623      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
624      */
625     function toHexString(address addr) internal pure returns (string memory) {
626         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
627     }
628 }
629 
630 // File: @openzeppelin/contracts/utils/Address.sol
631 
632 
633 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
634 
635 pragma solidity ^0.8.1;
636 
637 /**
638  * @dev Collection of functions related to the address type
639  */
640 library Address {
641     /**
642      * @dev Returns true if `account` is a contract.
643      *
644      * [IMPORTANT]
645      * ====
646      * It is unsafe to assume that an address for which this function returns
647      * false is an externally-owned account (EOA) and not a contract.
648      *
649      * Among others, `isContract` will return false for the following
650      * types of addresses:
651      *
652      *  - an externally-owned account
653      *  - a contract in construction
654      *  - an address where a contract will be created
655      *  - an address where a contract lived, but was destroyed
656      * ====
657      *
658      * [IMPORTANT]
659      * ====
660      * You shouldn't rely on `isContract` to protect against flash loan attacks!
661      *
662      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
663      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
664      * constructor.
665      * ====
666      */
667     function isContract(address account) internal view returns (bool) {
668         // This method relies on extcodesize/address.code.length, which returns 0
669         // for contracts in construction, since the code is only stored at the end
670         // of the constructor execution.
671 
672         return account.code.length > 0;
673     }
674 
675     /**
676      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
677      * `recipient`, forwarding all available gas and reverting on errors.
678      *
679      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
680      * of certain opcodes, possibly making contracts go over the 2300 gas limit
681      * imposed by `transfer`, making them unable to receive funds via
682      * `transfer`. {sendValue} removes this limitation.
683      *
684      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
685      *
686      * IMPORTANT: because control is transferred to `recipient`, care must be
687      * taken to not create reentrancy vulnerabilities. Consider using
688      * {ReentrancyGuard} or the
689      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
690      */
691     function sendValue(address payable recipient, uint256 amount) internal {
692         require(address(this).balance >= amount, "Address: insufficient balance");
693 
694         (bool success, ) = recipient.call{value: amount}("");
695         require(success, "Address: unable to send value, recipient may have reverted");
696     }
697 
698     /**
699      * @dev Performs a Solidity function call using a low level `call`. A
700      * plain `call` is an unsafe replacement for a function call: use this
701      * function instead.
702      *
703      * If `target` reverts with a revert reason, it is bubbled up by this
704      * function (like regular Solidity function calls).
705      *
706      * Returns the raw returned data. To convert to the expected return value,
707      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
708      *
709      * Requirements:
710      *
711      * - `target` must be a contract.
712      * - calling `target` with `data` must not revert.
713      *
714      * _Available since v3.1._
715      */
716     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
717         return functionCall(target, data, "Address: low-level call failed");
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
722      * `errorMessage` as a fallback revert reason when `target` reverts.
723      *
724      * _Available since v3.1._
725      */
726     function functionCall(
727         address target,
728         bytes memory data,
729         string memory errorMessage
730     ) internal returns (bytes memory) {
731         return functionCallWithValue(target, data, 0, errorMessage);
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
736      * but also transferring `value` wei to `target`.
737      *
738      * Requirements:
739      *
740      * - the calling contract must have an ETH balance of at least `value`.
741      * - the called Solidity function must be `payable`.
742      *
743      * _Available since v3.1._
744      */
745     function functionCallWithValue(
746         address target,
747         bytes memory data,
748         uint256 value
749     ) internal returns (bytes memory) {
750         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
755      * with `errorMessage` as a fallback revert reason when `target` reverts.
756      *
757      * _Available since v3.1._
758      */
759     function functionCallWithValue(
760         address target,
761         bytes memory data,
762         uint256 value,
763         string memory errorMessage
764     ) internal returns (bytes memory) {
765         require(address(this).balance >= value, "Address: insufficient balance for call");
766         require(isContract(target), "Address: call to non-contract");
767 
768         (bool success, bytes memory returndata) = target.call{value: value}(data);
769         return verifyCallResult(success, returndata, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but performing a static call.
775      *
776      * _Available since v3.3._
777      */
778     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
779         return functionStaticCall(target, data, "Address: low-level static call failed");
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
784      * but performing a static call.
785      *
786      * _Available since v3.3._
787      */
788     function functionStaticCall(
789         address target,
790         bytes memory data,
791         string memory errorMessage
792     ) internal view returns (bytes memory) {
793         require(isContract(target), "Address: static call to non-contract");
794 
795         (bool success, bytes memory returndata) = target.staticcall(data);
796         return verifyCallResult(success, returndata, errorMessage);
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
801      * but performing a delegate call.
802      *
803      * _Available since v3.4._
804      */
805     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
806         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
811      * but performing a delegate call.
812      *
813      * _Available since v3.4._
814      */
815     function functionDelegateCall(
816         address target,
817         bytes memory data,
818         string memory errorMessage
819     ) internal returns (bytes memory) {
820         require(isContract(target), "Address: delegate call to non-contract");
821 
822         (bool success, bytes memory returndata) = target.delegatecall(data);
823         return verifyCallResult(success, returndata, errorMessage);
824     }
825 
826     /**
827      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
828      * revert reason using the provided one.
829      *
830      * _Available since v4.3._
831      */
832     function verifyCallResult(
833         bool success,
834         bytes memory returndata,
835         string memory errorMessage
836     ) internal pure returns (bytes memory) {
837         if (success) {
838             return returndata;
839         } else {
840             // Look for revert reason and bubble it up if present
841             if (returndata.length > 0) {
842                 // The easiest way to bubble the revert reason is using memory via assembly
843                 /// @solidity memory-safe-assembly
844                 assembly {
845                     let returndata_size := mload(returndata)
846                     revert(add(32, returndata), returndata_size)
847                 }
848             } else {
849                 revert(errorMessage);
850             }
851         }
852     }
853 }
854 
855 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
856 
857 
858 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 /**
863  * @title ERC721 token receiver interface
864  * @dev Interface for any contract that wants to support safeTransfers
865  * from ERC721 asset contracts.
866  */
867 interface IERC721Receiver {
868     /**
869      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
870      * by `operator` from `from`, this function is called.
871      *
872      * It must return its Solidity selector to confirm the token transfer.
873      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
874      *
875      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
876      */
877     function onERC721Received(
878         address operator,
879         address from,
880         uint256 tokenId,
881         bytes calldata data
882     ) external returns (bytes4);
883 }
884 
885 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
886 
887 
888 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
889 
890 pragma solidity ^0.8.0;
891 
892 /**
893  * @dev Interface of the ERC165 standard, as defined in the
894  * https://eips.ethereum.org/EIPS/eip-165[EIP].
895  *
896  * Implementers can declare support of contract interfaces, which can then be
897  * queried by others ({ERC165Checker}).
898  *
899  * For an implementation, see {ERC165}.
900  */
901 interface IERC165 {
902     /**
903      * @dev Returns true if this contract implements the interface defined by
904      * `interfaceId`. See the corresponding
905      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
906      * to learn more about how these ids are created.
907      *
908      * This function call must use less than 30 000 gas.
909      */
910     function supportsInterface(bytes4 interfaceId) external view returns (bool);
911 }
912 
913 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
914 
915 
916 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
917 
918 pragma solidity ^0.8.0;
919 
920 
921 /**
922  * @dev Implementation of the {IERC165} interface.
923  *
924  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
925  * for the additional interface id that will be supported. For example:
926  *
927  * ```solidity
928  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
929  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
930  * }
931  * ```
932  *
933  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
934  */
935 abstract contract ERC165 is IERC165 {
936     /**
937      * @dev See {IERC165-supportsInterface}.
938      */
939     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
940         return interfaceId == type(IERC165).interfaceId;
941     }
942 }
943 
944 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
945 
946 
947 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
948 
949 pragma solidity ^0.8.0;
950 
951 
952 /**
953  * @dev Required interface of an ERC721 compliant contract.
954  */
955 interface IERC721 is IERC165 {
956     /**
957      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
958      */
959     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
960 
961     /**
962      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
963      */
964     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
965 
966     /**
967      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
968      */
969     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
970 
971     /**
972      * @dev Returns the number of tokens in ``owner``'s account.
973      */
974     function balanceOf(address owner) external view returns (uint256 balance);
975 
976     /**
977      * @dev Returns the owner of the `tokenId` token.
978      *
979      * Requirements:
980      *
981      * - `tokenId` must exist.
982      */
983     function ownerOf(uint256 tokenId) external view returns (address owner);
984 
985     /**
986      * @dev Safely transfers `tokenId` token from `from` to `to`.
987      *
988      * Requirements:
989      *
990      * - `from` cannot be the zero address.
991      * - `to` cannot be the zero address.
992      * - `tokenId` token must exist and be owned by `from`.
993      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
994      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
995      *
996      * Emits a {Transfer} event.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes calldata data
1003     ) external;
1004 
1005     /**
1006      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1007      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1008      *
1009      * Requirements:
1010      *
1011      * - `from` cannot be the zero address.
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must exist and be owned by `from`.
1014      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1015      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) external;
1024 
1025     /**
1026      * @dev Transfers `tokenId` token from `from` to `to`.
1027      *
1028      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1029      *
1030      * Requirements:
1031      *
1032      * - `from` cannot be the zero address.
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must be owned by `from`.
1035      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) external;
1044 
1045     /**
1046      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1047      * The approval is cleared when the token is transferred.
1048      *
1049      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1050      *
1051      * Requirements:
1052      *
1053      * - The caller must own the token or be an approved operator.
1054      * - `tokenId` must exist.
1055      *
1056      * Emits an {Approval} event.
1057      */
1058     function approve(address to, uint256 tokenId) external;
1059 
1060     /**
1061      * @dev Approve or remove `operator` as an operator for the caller.
1062      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1063      *
1064      * Requirements:
1065      *
1066      * - The `operator` cannot be the caller.
1067      *
1068      * Emits an {ApprovalForAll} event.
1069      */
1070     function setApprovalForAll(address operator, bool _approved) external;
1071 
1072     /**
1073      * @dev Returns the account approved for `tokenId` token.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      */
1079     function getApproved(uint256 tokenId) external view returns (address operator);
1080 
1081     /**
1082      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1083      *
1084      * See {setApprovalForAll}
1085      */
1086     function isApprovedForAll(address owner, address operator) external view returns (bool);
1087 }
1088 
1089 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1090 
1091 
1092 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 /**
1098  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1099  * @dev See https://eips.ethereum.org/EIPS/eip-721
1100  */
1101 interface IERC721Enumerable is IERC721 {
1102     /**
1103      * @dev Returns the total amount of tokens stored by the contract.
1104      */
1105     function totalSupply() external view returns (uint256);
1106 
1107     /**
1108      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1109      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1110      */
1111     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1112 
1113     /**
1114      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1115      * Use along with {totalSupply} to enumerate all tokens.
1116      */
1117     function tokenByIndex(uint256 index) external view returns (uint256);
1118 }
1119 
1120 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1121 
1122 
1123 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1124 
1125 pragma solidity ^0.8.0;
1126 
1127 
1128 /**
1129  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1130  * @dev See https://eips.ethereum.org/EIPS/eip-721
1131  */
1132 interface IERC721Metadata is IERC721 {
1133     /**
1134      * @dev Returns the token collection name.
1135      */
1136     function name() external view returns (string memory);
1137 
1138     /**
1139      * @dev Returns the token collection symbol.
1140      */
1141     function symbol() external view returns (string memory);
1142 
1143     /**
1144      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1145      */
1146     function tokenURI(uint256 tokenId) external view returns (string memory);
1147 }
1148 
1149 // File: @openzeppelin/contracts/utils/Context.sol
1150 
1151 
1152 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1153 
1154 pragma solidity ^0.8.0;
1155 
1156 /**
1157  * @dev Provides information about the current execution context, including the
1158  * sender of the transaction and its data. While these are generally available
1159  * via msg.sender and msg.data, they should not be accessed in such a direct
1160  * manner, since when dealing with meta-transactions the account sending and
1161  * paying for execution may not be the actual sender (as far as an application
1162  * is concerned).
1163  *
1164  * This contract is only required for intermediate, library-like contracts.
1165  */
1166 abstract contract Context {
1167     function _msgSender() internal view virtual returns (address) {
1168         return msg.sender;
1169     }
1170 
1171     function _msgData() internal view virtual returns (bytes calldata) {
1172         return msg.data;
1173     }
1174 }
1175 
1176 // File: @openzeppelin/contracts/access/AccessControl.sol
1177 
1178 
1179 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 
1184 
1185 
1186 
1187 /**
1188  * @dev Contract module that allows children to implement role-based access
1189  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1190  * members except through off-chain means by accessing the contract event logs. Some
1191  * applications may benefit from on-chain enumerability, for those cases see
1192  * {AccessControlEnumerable}.
1193  *
1194  * Roles are referred to by their `bytes32` identifier. These should be exposed
1195  * in the external API and be unique. The best way to achieve this is by
1196  * using `public constant` hash digests:
1197  *
1198  * ```
1199  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1200  * ```
1201  *
1202  * Roles can be used to represent a set of permissions. To restrict access to a
1203  * function call, use {hasRole}:
1204  *
1205  * ```
1206  * function foo() public {
1207  *     require(hasRole(MY_ROLE, msg.sender));
1208  *     ...
1209  * }
1210  * ```
1211  *
1212  * Roles can be granted and revoked dynamically via the {grantRole} and
1213  * {revokeRole} functions. Each role has an associated admin role, and only
1214  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1215  *
1216  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1217  * that only accounts with this role will be able to grant or revoke other
1218  * roles. More complex role relationships can be created by using
1219  * {_setRoleAdmin}.
1220  *
1221  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1222  * grant and revoke this role. Extra precautions should be taken to secure
1223  * accounts that have been granted it.
1224  */
1225 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1226     struct RoleData {
1227         mapping(address => bool) members;
1228         bytes32 adminRole;
1229     }
1230 
1231     mapping(bytes32 => RoleData) private _roles;
1232 
1233     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1234 
1235     /**
1236      * @dev Modifier that checks that an account has a specific role. Reverts
1237      * with a standardized message including the required role.
1238      *
1239      * The format of the revert reason is given by the following regular expression:
1240      *
1241      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1242      *
1243      * _Available since v4.1._
1244      */
1245     modifier onlyRole(bytes32 role) {
1246         _checkRole(role);
1247         _;
1248     }
1249 
1250     /**
1251      * @dev See {IERC165-supportsInterface}.
1252      */
1253     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1254         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1255     }
1256 
1257     /**
1258      * @dev Returns `true` if `account` has been granted `role`.
1259      */
1260     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1261         return _roles[role].members[account];
1262     }
1263 
1264     /**
1265      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1266      * Overriding this function changes the behavior of the {onlyRole} modifier.
1267      *
1268      * Format of the revert message is described in {_checkRole}.
1269      *
1270      * _Available since v4.6._
1271      */
1272     function _checkRole(bytes32 role) internal view virtual {
1273         _checkRole(role, _msgSender());
1274     }
1275 
1276     /**
1277      * @dev Revert with a standard message if `account` is missing `role`.
1278      *
1279      * The format of the revert reason is given by the following regular expression:
1280      *
1281      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1282      */
1283     function _checkRole(bytes32 role, address account) internal view virtual {
1284         if (!hasRole(role, account)) {
1285             revert(
1286                 string(
1287                     abi.encodePacked(
1288                         "AccessControl: account ",
1289                         Strings.toHexString(uint160(account), 20),
1290                         " is missing role ",
1291                         Strings.toHexString(uint256(role), 32)
1292                     )
1293                 )
1294             );
1295         }
1296     }
1297 
1298     /**
1299      * @dev Returns the admin role that controls `role`. See {grantRole} and
1300      * {revokeRole}.
1301      *
1302      * To change a role's admin, use {_setRoleAdmin}.
1303      */
1304     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1305         return _roles[role].adminRole;
1306     }
1307 
1308     /**
1309      * @dev Grants `role` to `account`.
1310      *
1311      * If `account` had not been already granted `role`, emits a {RoleGranted}
1312      * event.
1313      *
1314      * Requirements:
1315      *
1316      * - the caller must have ``role``'s admin role.
1317      *
1318      * May emit a {RoleGranted} event.
1319      */
1320     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1321         _grantRole(role, account);
1322     }
1323 
1324     /**
1325      * @dev Revokes `role` from `account`.
1326      *
1327      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1328      *
1329      * Requirements:
1330      *
1331      * - the caller must have ``role``'s admin role.
1332      *
1333      * May emit a {RoleRevoked} event.
1334      */
1335     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1336         _revokeRole(role, account);
1337     }
1338 
1339     /**
1340      * @dev Revokes `role` from the calling account.
1341      *
1342      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1343      * purpose is to provide a mechanism for accounts to lose their privileges
1344      * if they are compromised (such as when a trusted device is misplaced).
1345      *
1346      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1347      * event.
1348      *
1349      * Requirements:
1350      *
1351      * - the caller must be `account`.
1352      *
1353      * May emit a {RoleRevoked} event.
1354      */
1355     function renounceRole(bytes32 role, address account) public virtual override {
1356         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1357 
1358         _revokeRole(role, account);
1359     }
1360 
1361     /**
1362      * @dev Grants `role` to `account`.
1363      *
1364      * If `account` had not been already granted `role`, emits a {RoleGranted}
1365      * event. Note that unlike {grantRole}, this function doesn't perform any
1366      * checks on the calling account.
1367      *
1368      * May emit a {RoleGranted} event.
1369      *
1370      * [WARNING]
1371      * ====
1372      * This function should only be called from the constructor when setting
1373      * up the initial roles for the system.
1374      *
1375      * Using this function in any other way is effectively circumventing the admin
1376      * system imposed by {AccessControl}.
1377      * ====
1378      *
1379      * NOTE: This function is deprecated in favor of {_grantRole}.
1380      */
1381     function _setupRole(bytes32 role, address account) internal virtual {
1382         _grantRole(role, account);
1383     }
1384 
1385     /**
1386      * @dev Sets `adminRole` as ``role``'s admin role.
1387      *
1388      * Emits a {RoleAdminChanged} event.
1389      */
1390     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1391         bytes32 previousAdminRole = getRoleAdmin(role);
1392         _roles[role].adminRole = adminRole;
1393         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1394     }
1395 
1396     /**
1397      * @dev Grants `role` to `account`.
1398      *
1399      * Internal function without access restriction.
1400      *
1401      * May emit a {RoleGranted} event.
1402      */
1403     function _grantRole(bytes32 role, address account) internal virtual {
1404         if (!hasRole(role, account)) {
1405             _roles[role].members[account] = true;
1406             emit RoleGranted(role, account, _msgSender());
1407         }
1408     }
1409 
1410     /**
1411      * @dev Revokes `role` from `account`.
1412      *
1413      * Internal function without access restriction.
1414      *
1415      * May emit a {RoleRevoked} event.
1416      */
1417     function _revokeRole(bytes32 role, address account) internal virtual {
1418         if (hasRole(role, account)) {
1419             _roles[role].members[account] = false;
1420             emit RoleRevoked(role, account, _msgSender());
1421         }
1422     }
1423 }
1424 
1425 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1426 
1427 
1428 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1429 
1430 pragma solidity ^0.8.0;
1431 
1432 
1433 
1434 
1435 /**
1436  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1437  */
1438 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1439     using EnumerableSet for EnumerableSet.AddressSet;
1440 
1441     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1442 
1443     /**
1444      * @dev See {IERC165-supportsInterface}.
1445      */
1446     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1447         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1448     }
1449 
1450     /**
1451      * @dev Returns one of the accounts that have `role`. `index` must be a
1452      * value between 0 and {getRoleMemberCount}, non-inclusive.
1453      *
1454      * Role bearers are not sorted in any particular way, and their ordering may
1455      * change at any point.
1456      *
1457      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1458      * you perform all queries on the same block. See the following
1459      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1460      * for more information.
1461      */
1462     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1463         return _roleMembers[role].at(index);
1464     }
1465 
1466     /**
1467      * @dev Returns the number of accounts that have `role`. Can be used
1468      * together with {getRoleMember} to enumerate all bearers of a role.
1469      */
1470     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1471         return _roleMembers[role].length();
1472     }
1473 
1474     /**
1475      * @dev Overload {_grantRole} to track enumerable memberships
1476      */
1477     function _grantRole(bytes32 role, address account) internal virtual override {
1478         super._grantRole(role, account);
1479         _roleMembers[role].add(account);
1480     }
1481 
1482     /**
1483      * @dev Overload {_revokeRole} to track enumerable memberships
1484      */
1485     function _revokeRole(bytes32 role, address account) internal virtual override {
1486         super._revokeRole(role, account);
1487         _roleMembers[role].remove(account);
1488     }
1489 }
1490 
1491 // File: @openzeppelin/contracts/security/Pausable.sol
1492 
1493 
1494 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1495 
1496 pragma solidity ^0.8.0;
1497 
1498 
1499 /**
1500  * @dev Contract module which allows children to implement an emergency stop
1501  * mechanism that can be triggered by an authorized account.
1502  *
1503  * This module is used through inheritance. It will make available the
1504  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1505  * the functions of your contract. Note that they will not be pausable by
1506  * simply including this module, only once the modifiers are put in place.
1507  */
1508 abstract contract Pausable is Context {
1509     /**
1510      * @dev Emitted when the pause is triggered by `account`.
1511      */
1512     event Paused(address account);
1513 
1514     /**
1515      * @dev Emitted when the pause is lifted by `account`.
1516      */
1517     event Unpaused(address account);
1518 
1519     bool private _paused;
1520 
1521     /**
1522      * @dev Initializes the contract in unpaused state.
1523      */
1524     constructor() {
1525         _paused = false;
1526     }
1527 
1528     /**
1529      * @dev Modifier to make a function callable only when the contract is not paused.
1530      *
1531      * Requirements:
1532      *
1533      * - The contract must not be paused.
1534      */
1535     modifier whenNotPaused() {
1536         _requireNotPaused();
1537         _;
1538     }
1539 
1540     /**
1541      * @dev Modifier to make a function callable only when the contract is paused.
1542      *
1543      * Requirements:
1544      *
1545      * - The contract must be paused.
1546      */
1547     modifier whenPaused() {
1548         _requirePaused();
1549         _;
1550     }
1551 
1552     /**
1553      * @dev Returns true if the contract is paused, and false otherwise.
1554      */
1555     function paused() public view virtual returns (bool) {
1556         return _paused;
1557     }
1558 
1559     /**
1560      * @dev Throws if the contract is paused.
1561      */
1562     function _requireNotPaused() internal view virtual {
1563         require(!paused(), "Pausable: paused");
1564     }
1565 
1566     /**
1567      * @dev Throws if the contract is not paused.
1568      */
1569     function _requirePaused() internal view virtual {
1570         require(paused(), "Pausable: not paused");
1571     }
1572 
1573     /**
1574      * @dev Triggers stopped state.
1575      *
1576      * Requirements:
1577      *
1578      * - The contract must not be paused.
1579      */
1580     function _pause() internal virtual whenNotPaused {
1581         _paused = true;
1582         emit Paused(_msgSender());
1583     }
1584 
1585     /**
1586      * @dev Returns to normal state.
1587      *
1588      * Requirements:
1589      *
1590      * - The contract must be paused.
1591      */
1592     function _unpause() internal virtual whenPaused {
1593         _paused = false;
1594         emit Unpaused(_msgSender());
1595     }
1596 }
1597 
1598 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1599 
1600 
1601 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 
1606 
1607 
1608 
1609 
1610 
1611 
1612 /**
1613  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1614  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1615  * {ERC721Enumerable}.
1616  */
1617 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1618     using Address for address;
1619     using Strings for uint256;
1620 
1621     // Token name
1622     string private _name;
1623 
1624     // Token symbol
1625     string private _symbol;
1626 
1627     // Mapping from token ID to owner address
1628     mapping(uint256 => address) private _owners;
1629 
1630     // Mapping owner address to token count
1631     mapping(address => uint256) private _balances;
1632 
1633     // Mapping from token ID to approved address
1634     mapping(uint256 => address) private _tokenApprovals;
1635 
1636     // Mapping from owner to operator approvals
1637     mapping(address => mapping(address => bool)) private _operatorApprovals;
1638 
1639     /**
1640      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1641      */
1642     constructor(string memory name_, string memory symbol_) {
1643         _name = name_;
1644         _symbol = symbol_;
1645     }
1646 
1647     /**
1648      * @dev See {IERC165-supportsInterface}.
1649      */
1650     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1651         return
1652             interfaceId == type(IERC721).interfaceId ||
1653             interfaceId == type(IERC721Metadata).interfaceId ||
1654             super.supportsInterface(interfaceId);
1655     }
1656 
1657     /**
1658      * @dev See {IERC721-balanceOf}.
1659      */
1660     function balanceOf(address owner) public view virtual override returns (uint256) {
1661         require(owner != address(0), "ERC721: address zero is not a valid owner");
1662         return _balances[owner];
1663     }
1664 
1665     /**
1666      * @dev See {IERC721-ownerOf}.
1667      */
1668     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1669         address owner = _owners[tokenId];
1670         require(owner != address(0), "ERC721: invalid token ID");
1671         return owner;
1672     }
1673 
1674     /**
1675      * @dev See {IERC721Metadata-name}.
1676      */
1677     function name() public view virtual override returns (string memory) {
1678         return _name;
1679     }
1680 
1681     /**
1682      * @dev See {IERC721Metadata-symbol}.
1683      */
1684     function symbol() public view virtual override returns (string memory) {
1685         return _symbol;
1686     }
1687 
1688     /**
1689      * @dev See {IERC721Metadata-tokenURI}.
1690      */
1691     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1692         _requireMinted(tokenId);
1693 
1694         string memory baseURI = _baseURI();
1695         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1696     }
1697 
1698     /**
1699      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1700      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1701      * by default, can be overridden in child contracts.
1702      */
1703     function _baseURI() internal view virtual returns (string memory) {
1704         return "";
1705     }
1706 
1707     /**
1708      * @dev See {IERC721-approve}.
1709      */
1710     function approve(address to, uint256 tokenId) public virtual override {
1711         address owner = ERC721.ownerOf(tokenId);
1712         require(to != owner, "ERC721: approval to current owner");
1713 
1714         require(
1715             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1716             "ERC721: approve caller is not token owner nor approved for all"
1717         );
1718 
1719         _approve(to, tokenId);
1720     }
1721 
1722     /**
1723      * @dev See {IERC721-getApproved}.
1724      */
1725     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1726         _requireMinted(tokenId);
1727 
1728         return _tokenApprovals[tokenId];
1729     }
1730 
1731     /**
1732      * @dev See {IERC721-setApprovalForAll}.
1733      */
1734     function setApprovalForAll(address operator, bool approved) public virtual override {
1735         _setApprovalForAll(_msgSender(), operator, approved);
1736     }
1737 
1738     /**
1739      * @dev See {IERC721-isApprovedForAll}.
1740      */
1741     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1742         return _operatorApprovals[owner][operator];
1743     }
1744 
1745     /**
1746      * @dev See {IERC721-transferFrom}.
1747      */
1748     function transferFrom(
1749         address from,
1750         address to,
1751         uint256 tokenId
1752     ) public virtual override {
1753         //solhint-disable-next-line max-line-length
1754         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1755 
1756         _transfer(from, to, tokenId);
1757     }
1758 
1759     /**
1760      * @dev See {IERC721-safeTransferFrom}.
1761      */
1762     function safeTransferFrom(
1763         address from,
1764         address to,
1765         uint256 tokenId
1766     ) public virtual override {
1767         safeTransferFrom(from, to, tokenId, "");
1768     }
1769 
1770     /**
1771      * @dev See {IERC721-safeTransferFrom}.
1772      */
1773     function safeTransferFrom(
1774         address from,
1775         address to,
1776         uint256 tokenId,
1777         bytes memory data
1778     ) public virtual override {
1779         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1780         _safeTransfer(from, to, tokenId, data);
1781     }
1782 
1783     /**
1784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1786      *
1787      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1788      *
1789      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1790      * implement alternative mechanisms to perform token transfer, such as signature-based.
1791      *
1792      * Requirements:
1793      *
1794      * - `from` cannot be the zero address.
1795      * - `to` cannot be the zero address.
1796      * - `tokenId` token must exist and be owned by `from`.
1797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1798      *
1799      * Emits a {Transfer} event.
1800      */
1801     function _safeTransfer(
1802         address from,
1803         address to,
1804         uint256 tokenId,
1805         bytes memory data
1806     ) internal virtual {
1807         _transfer(from, to, tokenId);
1808         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1809     }
1810 
1811     /**
1812      * @dev Returns whether `tokenId` exists.
1813      *
1814      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1815      *
1816      * Tokens start existing when they are minted (`_mint`),
1817      * and stop existing when they are burned (`_burn`).
1818      */
1819     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1820         return _owners[tokenId] != address(0);
1821     }
1822 
1823     /**
1824      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1825      *
1826      * Requirements:
1827      *
1828      * - `tokenId` must exist.
1829      */
1830     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1831         address owner = ERC721.ownerOf(tokenId);
1832         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1833     }
1834 
1835     /**
1836      * @dev Safely mints `tokenId` and transfers it to `to`.
1837      *
1838      * Requirements:
1839      *
1840      * - `tokenId` must not exist.
1841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1842      *
1843      * Emits a {Transfer} event.
1844      */
1845     function _safeMint(address to, uint256 tokenId) internal virtual {
1846         _safeMint(to, tokenId, "");
1847     }
1848 
1849     /**
1850      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1851      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1852      */
1853     function _safeMint(
1854         address to,
1855         uint256 tokenId,
1856         bytes memory data
1857     ) internal virtual {
1858         _mint(to, tokenId);
1859         require(
1860             _checkOnERC721Received(address(0), to, tokenId, data),
1861             "ERC721: transfer to non ERC721Receiver implementer"
1862         );
1863     }
1864 
1865     /**
1866      * @dev Mints `tokenId` and transfers it to `to`.
1867      *
1868      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1869      *
1870      * Requirements:
1871      *
1872      * - `tokenId` must not exist.
1873      * - `to` cannot be the zero address.
1874      *
1875      * Emits a {Transfer} event.
1876      */
1877     function _mint(address to, uint256 tokenId) internal virtual {
1878         require(to != address(0), "ERC721: mint to the zero address");
1879         require(!_exists(tokenId), "ERC721: token already minted");
1880 
1881         _beforeTokenTransfer(address(0), to, tokenId);
1882 
1883         _balances[to] += 1;
1884         _owners[tokenId] = to;
1885 
1886         emit Transfer(address(0), to, tokenId);
1887 
1888         _afterTokenTransfer(address(0), to, tokenId);
1889     }
1890 
1891     /**
1892      * @dev Destroys `tokenId`.
1893      * The approval is cleared when the token is burned.
1894      *
1895      * Requirements:
1896      *
1897      * - `tokenId` must exist.
1898      *
1899      * Emits a {Transfer} event.
1900      */
1901     function _burn(uint256 tokenId) internal virtual {
1902         address owner = ERC721.ownerOf(tokenId);
1903 
1904         _beforeTokenTransfer(owner, address(0), tokenId);
1905 
1906         // Clear approvals
1907         _approve(address(0), tokenId);
1908 
1909         _balances[owner] -= 1;
1910         delete _owners[tokenId];
1911 
1912         emit Transfer(owner, address(0), tokenId);
1913 
1914         _afterTokenTransfer(owner, address(0), tokenId);
1915     }
1916 
1917     /**
1918      * @dev Transfers `tokenId` from `from` to `to`.
1919      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1920      *
1921      * Requirements:
1922      *
1923      * - `to` cannot be the zero address.
1924      * - `tokenId` token must be owned by `from`.
1925      *
1926      * Emits a {Transfer} event.
1927      */
1928     function _transfer(
1929         address from,
1930         address to,
1931         uint256 tokenId
1932     ) internal virtual {
1933         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1934         require(to != address(0), "ERC721: transfer to the zero address");
1935 
1936         _beforeTokenTransfer(from, to, tokenId);
1937 
1938         // Clear approvals from the previous owner
1939         _approve(address(0), tokenId);
1940 
1941         _balances[from] -= 1;
1942         _balances[to] += 1;
1943         _owners[tokenId] = to;
1944 
1945         emit Transfer(from, to, tokenId);
1946 
1947         _afterTokenTransfer(from, to, tokenId);
1948     }
1949 
1950     /**
1951      * @dev Approve `to` to operate on `tokenId`
1952      *
1953      * Emits an {Approval} event.
1954      */
1955     function _approve(address to, uint256 tokenId) internal virtual {
1956         _tokenApprovals[tokenId] = to;
1957         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1958     }
1959 
1960     /**
1961      * @dev Approve `operator` to operate on all of `owner` tokens
1962      *
1963      * Emits an {ApprovalForAll} event.
1964      */
1965     function _setApprovalForAll(
1966         address owner,
1967         address operator,
1968         bool approved
1969     ) internal virtual {
1970         require(owner != operator, "ERC721: approve to caller");
1971         _operatorApprovals[owner][operator] = approved;
1972         emit ApprovalForAll(owner, operator, approved);
1973     }
1974 
1975     /**
1976      * @dev Reverts if the `tokenId` has not been minted yet.
1977      */
1978     function _requireMinted(uint256 tokenId) internal view virtual {
1979         require(_exists(tokenId), "ERC721: invalid token ID");
1980     }
1981 
1982     /**
1983      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1984      * The call is not executed if the target address is not a contract.
1985      *
1986      * @param from address representing the previous owner of the given token ID
1987      * @param to target address that will receive the tokens
1988      * @param tokenId uint256 ID of the token to be transferred
1989      * @param data bytes optional data to send along with the call
1990      * @return bool whether the call correctly returned the expected magic value
1991      */
1992     function _checkOnERC721Received(
1993         address from,
1994         address to,
1995         uint256 tokenId,
1996         bytes memory data
1997     ) private returns (bool) {
1998         if (to.isContract()) {
1999             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2000                 return retval == IERC721Receiver.onERC721Received.selector;
2001             } catch (bytes memory reason) {
2002                 if (reason.length == 0) {
2003                     revert("ERC721: transfer to non ERC721Receiver implementer");
2004                 } else {
2005                     /// @solidity memory-safe-assembly
2006                     assembly {
2007                         revert(add(32, reason), mload(reason))
2008                     }
2009                 }
2010             }
2011         } else {
2012             return true;
2013         }
2014     }
2015 
2016     /**
2017      * @dev Hook that is called before any token transfer. This includes minting
2018      * and burning.
2019      *
2020      * Calling conditions:
2021      *
2022      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2023      * transferred to `to`.
2024      * - When `from` is zero, `tokenId` will be minted for `to`.
2025      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2026      * - `from` and `to` are never both zero.
2027      *
2028      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2029      */
2030     function _beforeTokenTransfer(
2031         address from,
2032         address to,
2033         uint256 tokenId
2034     ) internal virtual {}
2035 
2036     /**
2037      * @dev Hook that is called after any transfer of tokens. This includes
2038      * minting and burning.
2039      *
2040      * Calling conditions:
2041      *
2042      * - when `from` and `to` are both non-zero.
2043      * - `from` and `to` are never both zero.
2044      *
2045      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2046      */
2047     function _afterTokenTransfer(
2048         address from,
2049         address to,
2050         uint256 tokenId
2051     ) internal virtual {}
2052 }
2053 
2054 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
2055 
2056 
2057 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2058 
2059 pragma solidity ^0.8.0;
2060 
2061 
2062 
2063 /**
2064  * @dev ERC721 token with pausable token transfers, minting and burning.
2065  *
2066  * Useful for scenarios such as preventing trades until the end of an evaluation
2067  * period, or having an emergency switch for freezing all token transfers in the
2068  * event of a large bug.
2069  */
2070 abstract contract ERC721Pausable is ERC721, Pausable {
2071     /**
2072      * @dev See {ERC721-_beforeTokenTransfer}.
2073      *
2074      * Requirements:
2075      *
2076      * - the contract must not be paused.
2077      */
2078     function _beforeTokenTransfer(
2079         address from,
2080         address to,
2081         uint256 tokenId
2082     ) internal virtual override {
2083         super._beforeTokenTransfer(from, to, tokenId);
2084 
2085         require(!paused(), "ERC721Pausable: token transfer while paused");
2086     }
2087 }
2088 
2089 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
2090 
2091 
2092 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
2093 
2094 pragma solidity ^0.8.0;
2095 
2096 
2097 
2098 /**
2099  * @title ERC721 Burnable Token
2100  * @dev ERC721 Token that can be burned (destroyed).
2101  */
2102 abstract contract ERC721Burnable is Context, ERC721 {
2103     /**
2104      * @dev Burns `tokenId`. See {ERC721-_burn}.
2105      *
2106      * Requirements:
2107      *
2108      * - The caller must own `tokenId` or be an approved operator.
2109      */
2110     function burn(uint256 tokenId) public virtual {
2111         //solhint-disable-next-line max-line-length
2112         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2113         _burn(tokenId);
2114     }
2115 }
2116 
2117 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2118 
2119 
2120 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2121 
2122 pragma solidity ^0.8.0;
2123 
2124 
2125 
2126 /**
2127  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2128  * enumerability of all the token ids in the contract as well as all token ids owned by each
2129  * account.
2130  */
2131 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2132     // Mapping from owner to list of owned token IDs
2133     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2134 
2135     // Mapping from token ID to index of the owner tokens list
2136     mapping(uint256 => uint256) private _ownedTokensIndex;
2137 
2138     // Array with all token ids, used for enumeration
2139     uint256[] private _allTokens;
2140 
2141     // Mapping from token id to position in the allTokens array
2142     mapping(uint256 => uint256) private _allTokensIndex;
2143 
2144     /**
2145      * @dev See {IERC165-supportsInterface}.
2146      */
2147     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2148         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2149     }
2150 
2151     /**
2152      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2153      */
2154     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2155         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2156         return _ownedTokens[owner][index];
2157     }
2158 
2159     /**
2160      * @dev See {IERC721Enumerable-totalSupply}.
2161      */
2162     function totalSupply() public view virtual override returns (uint256) {
2163         return _allTokens.length;
2164     }
2165 
2166     /**
2167      * @dev See {IERC721Enumerable-tokenByIndex}.
2168      */
2169     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2170         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2171         return _allTokens[index];
2172     }
2173 
2174     /**
2175      * @dev Hook that is called before any token transfer. This includes minting
2176      * and burning.
2177      *
2178      * Calling conditions:
2179      *
2180      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2181      * transferred to `to`.
2182      * - When `from` is zero, `tokenId` will be minted for `to`.
2183      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2184      * - `from` cannot be the zero address.
2185      * - `to` cannot be the zero address.
2186      *
2187      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2188      */
2189     function _beforeTokenTransfer(
2190         address from,
2191         address to,
2192         uint256 tokenId
2193     ) internal virtual override {
2194         super._beforeTokenTransfer(from, to, tokenId);
2195 
2196         if (from == address(0)) {
2197             _addTokenToAllTokensEnumeration(tokenId);
2198         } else if (from != to) {
2199             _removeTokenFromOwnerEnumeration(from, tokenId);
2200         }
2201         if (to == address(0)) {
2202             _removeTokenFromAllTokensEnumeration(tokenId);
2203         } else if (to != from) {
2204             _addTokenToOwnerEnumeration(to, tokenId);
2205         }
2206     }
2207 
2208     /**
2209      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2210      * @param to address representing the new owner of the given token ID
2211      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2212      */
2213     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2214         uint256 length = ERC721.balanceOf(to);
2215         _ownedTokens[to][length] = tokenId;
2216         _ownedTokensIndex[tokenId] = length;
2217     }
2218 
2219     /**
2220      * @dev Private function to add a token to this extension's token tracking data structures.
2221      * @param tokenId uint256 ID of the token to be added to the tokens list
2222      */
2223     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2224         _allTokensIndex[tokenId] = _allTokens.length;
2225         _allTokens.push(tokenId);
2226     }
2227 
2228     /**
2229      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2230      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2231      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2232      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2233      * @param from address representing the previous owner of the given token ID
2234      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2235      */
2236     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2237         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2238         // then delete the last slot (swap and pop).
2239 
2240         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2241         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2242 
2243         // When the token to delete is the last token, the swap operation is unnecessary
2244         if (tokenIndex != lastTokenIndex) {
2245             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2246 
2247             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2248             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2249         }
2250 
2251         // This also deletes the contents at the last position of the array
2252         delete _ownedTokensIndex[tokenId];
2253         delete _ownedTokens[from][lastTokenIndex];
2254     }
2255 
2256     /**
2257      * @dev Private function to remove a token from this extension's token tracking data structures.
2258      * This has O(1) time complexity, but alters the order of the _allTokens array.
2259      * @param tokenId uint256 ID of the token to be removed from the tokens list
2260      */
2261     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2262         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2263         // then delete the last slot (swap and pop).
2264 
2265         uint256 lastTokenIndex = _allTokens.length - 1;
2266         uint256 tokenIndex = _allTokensIndex[tokenId];
2267 
2268         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2269         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2270         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2271         uint256 lastTokenId = _allTokens[lastTokenIndex];
2272 
2273         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2274         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2275 
2276         // This also deletes the contents at the last position of the array
2277         delete _allTokensIndex[tokenId];
2278         _allTokens.pop();
2279     }
2280 }
2281 
2282 // File: @openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol
2283 
2284 
2285 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol)
2286 
2287 pragma solidity ^0.8.0;
2288 
2289 
2290 
2291 
2292 
2293 
2294 
2295 
2296 /**
2297  * @dev {ERC721} token, including:
2298  *
2299  *  - ability for holders to burn (destroy) their tokens
2300  *  - a minter role that allows for token minting (creation)
2301  *  - a pauser role that allows to stop all token transfers
2302  *  - token ID and URI autogeneration
2303  *
2304  * This contract uses {AccessControl} to lock permissioned functions using the
2305  * different roles - head to its documentation for details.
2306  *
2307  * The account that deploys the contract will be granted the minter and pauser
2308  * roles, as well as the default admin role, which will let it grant both minter
2309  * and pauser roles to other accounts.
2310  *
2311  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
2312  */
2313 contract ERC721PresetMinterPauserAutoId is
2314     Context,
2315     AccessControlEnumerable,
2316     ERC721Enumerable,
2317     ERC721Burnable,
2318     ERC721Pausable
2319 {
2320     using Counters for Counters.Counter;
2321 
2322     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2323     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2324 
2325     Counters.Counter private _tokenIdTracker;
2326 
2327     string private _baseTokenURI;
2328 
2329     /**
2330      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2331      * account that deploys the contract.
2332      *
2333      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2334      * See {ERC721-tokenURI}.
2335      */
2336     constructor(
2337         string memory name,
2338         string memory symbol,
2339         string memory baseTokenURI
2340     ) ERC721(name, symbol) {
2341         _baseTokenURI = baseTokenURI;
2342 
2343         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2344 
2345         _setupRole(MINTER_ROLE, _msgSender());
2346         _setupRole(PAUSER_ROLE, _msgSender());
2347     }
2348 
2349     function _baseURI() internal view virtual override returns (string memory) {
2350         return _baseTokenURI;
2351     }
2352 
2353     /**
2354      * @dev Creates a new token for `to`. Its token ID will be automatically
2355      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
2356      * URI autogenerated based on the base URI passed at construction.
2357      *
2358      * See {ERC721-_mint}.
2359      *
2360      * Requirements:
2361      *
2362      * - the caller must have the `MINTER_ROLE`.
2363      */
2364     function mint(address to) public virtual {
2365         require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
2366 
2367         // We cannot just use balanceOf to create the new tokenId because tokens
2368         // can be burned (destroyed), so we need a separate counter.
2369         _mint(to, _tokenIdTracker.current());
2370         _tokenIdTracker.increment();
2371     }
2372 
2373     /**
2374      * @dev Pauses all token transfers.
2375      *
2376      * See {ERC721Pausable} and {Pausable-_pause}.
2377      *
2378      * Requirements:
2379      *
2380      * - the caller must have the `PAUSER_ROLE`.
2381      */
2382     function pause() public virtual {
2383         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to pause");
2384         _pause();
2385     }
2386 
2387     /**
2388      * @dev Unpauses all token transfers.
2389      *
2390      * See {ERC721Pausable} and {Pausable-_unpause}.
2391      *
2392      * Requirements:
2393      *
2394      * - the caller must have the `PAUSER_ROLE`.
2395      */
2396     function unpause() public virtual {
2397         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to unpause");
2398         _unpause();
2399     }
2400 
2401     function _beforeTokenTransfer(
2402         address from,
2403         address to,
2404         uint256 tokenId
2405     ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
2406         super._beforeTokenTransfer(from, to, tokenId);
2407     }
2408 
2409     /**
2410      * @dev See {IERC165-supportsInterface}.
2411      */
2412     function supportsInterface(bytes4 interfaceId)
2413         public
2414         view
2415         virtual
2416         override(AccessControlEnumerable, ERC721, ERC721Enumerable)
2417         returns (bool)
2418     {
2419         return super.supportsInterface(interfaceId);
2420     }
2421 }
2422 
2423 // File: @openzeppelin/contracts/access/Ownable.sol
2424 
2425 
2426 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2427 
2428 pragma solidity ^0.8.0;
2429 
2430 
2431 /**
2432  * @dev Contract module which provides a basic access control mechanism, where
2433  * there is an account (an owner) that can be granted exclusive access to
2434  * specific functions.
2435  *
2436  * By default, the owner account will be the one that deploys the contract. This
2437  * can later be changed with {transferOwnership}.
2438  *
2439  * This module is used through inheritance. It will make available the modifier
2440  * `onlyOwner`, which can be applied to your functions to restrict their use to
2441  * the owner.
2442  */
2443 abstract contract Ownable is Context {
2444     address private _owner;
2445 
2446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2447 
2448     /**
2449      * @dev Initializes the contract setting the deployer as the initial owner.
2450      */
2451     constructor() {
2452         _transferOwnership(_msgSender());
2453     }
2454 
2455     /**
2456      * @dev Throws if called by any account other than the owner.
2457      */
2458     modifier onlyOwner() {
2459         _checkOwner();
2460         _;
2461     }
2462 
2463     /**
2464      * @dev Returns the address of the current owner.
2465      */
2466     function owner() public view virtual returns (address) {
2467         return _owner;
2468     }
2469 
2470     /**
2471      * @dev Throws if the sender is not the owner.
2472      */
2473     function _checkOwner() internal view virtual {
2474         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2475     }
2476 
2477     /**
2478      * @dev Leaves the contract without owner. It will not be possible to call
2479      * `onlyOwner` functions anymore. Can only be called by the current owner.
2480      *
2481      * NOTE: Renouncing ownership will leave the contract without an owner,
2482      * thereby removing any functionality that is only available to the owner.
2483      */
2484     function renounceOwnership() public virtual onlyOwner {
2485         _transferOwnership(address(0));
2486     }
2487 
2488     /**
2489      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2490      * Can only be called by the current owner.
2491      */
2492     function transferOwnership(address newOwner) public virtual onlyOwner {
2493         require(newOwner != address(0), "Ownable: new owner is the zero address");
2494         _transferOwnership(newOwner);
2495     }
2496 
2497     /**
2498      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2499      * Internal function without access restriction.
2500      */
2501     function _transferOwnership(address newOwner) internal virtual {
2502         address oldOwner = _owner;
2503         _owner = newOwner;
2504         emit OwnershipTransferred(oldOwner, newOwner);
2505     }
2506 }
2507 
2508 // File: contracts/JulienDurix/JulienDurixPostBurn.sol
2509 
2510 
2511 pragma solidity ^0.8.7;
2512 
2513 
2514 
2515 
2516 contract LikeABrush is ERC721PresetMinterPauserAutoId, Ownable {
2517     Brushes private immutable brushes;
2518     address public contract_unreveal = 0x6B6C66C7128f2585D8AAd8e4EFdaC33dD3c376cC;
2519     string public baseURI;
2520     string public baseURIHidden;
2521     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2522     bool public revealed = false;
2523 
2524 
2525     constructor() ERC721PresetMinterPauserAutoId("JulienDurixBrushes", "JDB", "ipfs://") {
2526         brushes = Brushes(contract_unreveal);
2527         _setupRole(ADMIN_ROLE, msg.sender);
2528         _setupRole(MINTER_ROLE, msg.sender);
2529      }
2530 
2531     function JulienDurixReveal(uint256 tokenId, address to) payable public {
2532       require(
2533             brushes.ownerOf(tokenId) == msg.sender,
2534             "Must own the brush you're attempting to reveal"
2535         );
2536         _setupRole(MINTER_ROLE, msg.sender);
2537          brushes.burn(tokenId);
2538          super.mint(to);
2539         _revokeRole(MINTER_ROLE, msg.sender);
2540         
2541     }
2542 
2543     function _baseURI() internal view virtual override returns (string memory) {
2544         return baseURI;
2545     }
2546     
2547     function setNewbaseURI(string memory newBaseURI) public  returns (string memory) {
2548         require(hasRole(ADMIN_ROLE, _msgSender()), "NB1");
2549         baseURI = newBaseURI;
2550         return baseURI;
2551     }
2552 
2553     function setNewbaseHiddenURI(string memory newBaseURI) public  returns (string memory) {
2554         require(hasRole(ADMIN_ROLE, _msgSender()), "NBH");
2555         baseURIHidden = newBaseURI;
2556         return baseURIHidden;
2557     }
2558 
2559     function withdraw(address payable receiver) payable external  returns(bool success) {
2560         require(hasRole(ADMIN_ROLE, _msgSender()), "WT");
2561         receiver.transfer(address(this).balance);
2562         return true;
2563     }
2564   
2565     function adminMinting(address to) public {
2566         require(hasRole(ADMIN_ROLE, _msgSender()), "MT1");
2567         super.mint(to);
2568     }
2569        function flipReveal() external {
2570         require(hasRole(ADMIN_ROLE, _msgSender()), "FR");
2571         revealed = !revealed;
2572     }
2573 
2574     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2575         {
2576             require(_exists(tokenId),"NET");
2577             if (!revealed) {return baseURIHidden;}
2578             return super.tokenURI(tokenId);
2579         }
2580 
2581     function setNewContractAdress(address contractAdress) public  returns (address) {
2582         require(hasRole(ADMIN_ROLE, _msgSender()), "NBH");
2583         contract_unreveal = contractAdress;
2584         return contract_unreveal;
2585     }    
2586 }