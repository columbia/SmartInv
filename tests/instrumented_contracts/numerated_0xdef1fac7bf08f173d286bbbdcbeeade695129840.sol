1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5 🌎 Website: https://DefiFactory.finance
6 💻 Dashboard: https://app.defifactory.fi
7 👉 Telegram: https://t.me/DefiFactoryBot?start=info-join
8 */
9 
10 struct TaxAmountsInput {
11     address sender;
12     address recipient;
13     uint transferAmount;
14     uint senderRealBalance;
15     uint recipientRealBalance;
16 }
17 struct TaxAmountsOutput {
18     uint senderRealBalance;
19     uint recipientRealBalance;
20     uint burnAndRewardAmount;
21     uint recipientGetsAmount;
22 }
23 struct TemporaryReferralRealAmountsBulk {
24     address addr;
25     uint realBalance;
26 }
27 
28 interface INoBotsTech {
29     function prepareTaxAmounts(
30         TaxAmountsInput calldata taxAmountsInput
31     ) 
32         external
33         returns(TaxAmountsOutput memory taxAmountsOutput);
34     
35     function getTemporaryReferralRealAmountsBulk(address[] calldata addrs)
36         external
37         view
38         returns (TemporaryReferralRealAmountsBulk[] memory);
39         
40     function prepareHumanAddressMintOrBurnRewardsAmounts(bool isMint, address account, uint desiredAmountToMintOrBurn)
41         external
42         returns (uint realAmountToMintOrBurn);
43         
44     function getBalance(address account, uint accountBalance)
45         external
46         view
47         returns(uint);
48         
49     function getRealBalance(address account, uint accountBalance)
50         external
51         view
52         returns(uint);
53         
54     function getRealBalanceTeamVestingContract(uint accountBalance)
55         external
56         view
57         returns(uint);
58         
59     function getTotalSupply()
60         external
61         view
62         returns (uint);
63         
64     function grantRole(bytes32 role, address account) 
65         external;
66         
67     function getCalculatedReferrerRewards(address addr, address[] calldata referrals)
68         external
69         view
70         returns (uint);
71         
72     function getCachedReferrerRewards(address addr)
73         external
74         view
75         returns (uint);
76     
77     function updateReferrersRewards(address[] calldata referrals)
78         external;
79     
80     function clearReferrerRewards(address addr)
81         external;
82     
83     function chargeCustomTax(uint taxAmount, uint accountBalance)
84         external
85         returns (uint);
86     
87     function chargeCustomTaxTeamVestingContract(uint taxAmount, uint accountBalance)
88         external
89         returns (uint);
90         
91     function registerReferral(address referral, address referrer)
92         external;
93         
94     function filterNonZeroReferrals(address[] calldata referrals)
95         external
96         view
97         returns (address[] memory);
98         
99     function publicForcedUpdateCacheMultiplier()
100         external;
101     
102     event MultiplierUpdated(uint newMultiplier);
103     event BotTransactionDetected(address from, address to, uint transferAmount, uint taxedAmount);
104     event ReferrerRewardUpdated(address referrer, uint amount);
105     event ReferralRegistered(address referral, address referrer);
106     event ReferrerReplaced(address referral, address referrerFrom, address referrerTo);
107 }
108 
109 /*
110  * @dev Provides information about the current execution context, including the
111  * sender of the transaction and its data. While these are generally available
112  * via msg.sender and msg.data, they should not be accessed in such a direct
113  * manner, since when dealing with meta-transactions the account sending and
114  * paying for execution may not be the actual sender (as far as an application
115  * is concerned).
116  *
117  * This contract is only required for intermediate, library-like contracts.
118  */
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
126         return msg.data;
127     }
128 }
129 
130 /**
131  * @dev String operations.
132  */
133 library Strings {
134     bytes16 private constant alphabet = "0123456789abcdef";
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
138      */
139     function toString(uint256 value) internal pure returns (string memory) {
140         // Inspired by OraclizeAPI's implementation - MIT licence
141         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
142 
143         if (value == 0) {
144             return "0";
145         }
146         uint256 temp = value;
147         uint256 digits;
148         while (temp != 0) {
149             digits++;
150             temp /= 10;
151         }
152         bytes memory buffer = new bytes(digits);
153         while (value != 0) {
154             digits -= 1;
155             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
156             value /= 10;
157         }
158         return string(buffer);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
163      */
164     function toHexString(uint256 value) internal pure returns (string memory) {
165         if (value == 0) {
166             return "0x00";
167         }
168         uint256 temp = value;
169         uint256 length = 0;
170         while (temp != 0) {
171             length++;
172             temp >>= 8;
173         }
174         return toHexString(value, length);
175     }
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
179      */
180     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
181         bytes memory buffer = new bytes(2 * length + 2);
182         buffer[0] = "0";
183         buffer[1] = "x";
184         for (uint256 i = 2 * length + 1; i > 1; --i) {
185             buffer[i] = alphabet[value & 0xf];
186             value >>= 4;
187         }
188         require(value == 0, "Strings: hex length insufficient");
189         return string(buffer);
190     }
191 
192 }
193 
194 /**
195  * @dev Interface of the ERC165 standard, as defined in the
196  * https://eips.ethereum.org/EIPS/eip-165[EIP].
197  *
198  * Implementers can declare support of contract interfaces, which can then be
199  * queried by others ({ERC165Checker}).
200  *
201  * For an implementation, see {ERC165}.
202  */
203 interface IERC165 {
204     /**
205      * @dev Returns true if this contract implements the interface defined by
206      * `interfaceId`. See the corresponding
207      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
208      * to learn more about how these ids are created.
209      *
210      * This function call must use less than 30 000 gas.
211      */
212     function supportsInterface(bytes4 interfaceId) external view returns (bool);
213 }
214 
215 /**
216  * @dev Implementation of the {IERC165} interface.
217  *
218  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
219  * for the additional interface id that will be supported. For example:
220  *
221  * ```solidity
222  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
223  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
224  * }
225  * ```
226  *
227  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
228  */
229 abstract contract ERC165 is IERC165 {
230     /**
231      * @dev See {IERC165-supportsInterface}.
232      */
233     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
234         return interfaceId == type(IERC165).interfaceId;
235     }
236 }
237 
238 /**
239  * @dev External interface of AccessControl declared to support ERC165 detection.
240  */
241 interface IAccessControl {
242     function hasRole(bytes32 role, address account) external view returns (bool);
243     function getRoleAdmin(bytes32 role) external view returns (bytes32);
244     function grantRole(bytes32 role, address account) external;
245     function revokeRole(bytes32 role, address account) external;
246     function renounceRole(bytes32 role, address account) external;
247 }
248 
249 /**
250  * @dev Contract module that allows children to implement role-based access
251  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
252  * members except through off-chain means by accessing the contract event logs. Some
253  * applications may benefit from on-chain enumerability, for those cases see
254  * {AccessControlEnumerable}.
255  *
256  * Roles are referred to by their `bytes32` identifier. These should be exposed
257  * in the external API and be unique. The best way to achieve this is by
258  * using `public constant` hash digests:
259  *
260  * ```
261  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
262  * ```
263  *
264  * Roles can be used to represent a set of permissions. To restrict access to a
265  * function call, use {hasRole}:
266  *
267  * ```
268  * function foo() public {
269  *     require(hasRole(MY_ROLE, msg.sender));
270  *     ...
271  * }
272  * ```
273  *
274  * Roles can be granted and revoked dynamically via the {grantRole} and
275  * {revokeRole} functions. Each role has an associated admin role, and only
276  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
277  *
278  * By default, the admin role for all roles is `ROLE_ADMIN`, which means
279  * that only accounts with this role will be able to grant or revoke other
280  * roles. More complex role relationships can be created by using
281  * {_setRoleAdmin}.
282  *
283  * WARNING: The `ROLE_ADMIN` is also its own admin: it has permission to
284  * grant and revoke this role. Extra precautions should be taken to secure
285  * accounts that have been granted it.
286  */
287 abstract contract AccessControl is Context, IAccessControl, ERC165 {
288     struct RoleData {
289         mapping (address => bool) members;
290         bytes32 adminRole;
291     }
292 
293     mapping (bytes32 => RoleData) private _roles;
294 
295     bytes32 public constant ROLE_ADMIN = 0x00;
296 
297     /**
298      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
299      *
300      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
301      * {RoleAdminChanged} not being emitted signaling this.
302      *
303      * _Available since v3.1._
304      */
305     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
306 
307     /**
308      * @dev Emitted when `account` is granted `role`.
309      *
310      * `sender` is the account that originated the contract call, an admin role
311      * bearer except when using {_setupRole}.
312      */
313     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
314 
315     /**
316      * @dev Emitted when `account` is revoked `role`.
317      *
318      * `sender` is the account that originated the contract call:
319      *   - if using `revokeRole`, it is the admin role bearer
320      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
321      */
322     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
323 
324     /**
325      * @dev Modifier that checks that an account has a specific role. Reverts
326      * with a standardized message including the required role.
327      *
328      * The format of the revert reason is given by the following regular expression:
329      *
330      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
331      *
332      * _Available since v4.1._
333      */
334     modifier onlyRole(bytes32 role) {
335         _checkRole(role, _msgSender());
336         _;
337     }
338 
339     /**
340      * @dev See {IERC165-supportsInterface}.
341      */
342     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
343         return interfaceId == type(IAccessControl).interfaceId
344             || super.supportsInterface(interfaceId);
345     }
346 
347     /**
348      * @dev Returns `true` if `account` has been granted `role`.
349      */
350     function hasRole(bytes32 role, address account) public view override returns (bool) {
351         return _roles[role].members[account];
352     }
353 
354     /**
355      * @dev Revert with a standard message if `account` is missing `role`.
356      *
357      * The format of the revert reason is given by the following regular expression:
358      *
359      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
360      */
361     function _checkRole(bytes32 role, address account) internal view {
362         if(!hasRole(role, account)) {
363             revert(string(abi.encodePacked(
364                 "AccessControl: account ",
365                 Strings.toHexString(uint160(account), 20),
366                 " is missing role ",
367                 Strings.toHexString(uint256(role), 32)
368             )));
369         }
370     }
371 
372     /**
373      * @dev Returns the admin role that controls `role`. See {grantRole} and
374      * {revokeRole}.
375      *
376      * To change a role's admin, use {_setRoleAdmin}.
377      */
378     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
379         return _roles[role].adminRole;
380     }
381 
382     /**
383      * @dev Grants `role` to `account`.
384      *
385      * If `account` had not been already granted `role`, emits a {RoleGranted}
386      * event.
387      *
388      * Requirements:
389      *
390      * - the caller must have ``role``'s admin role.
391      */
392     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
393         _grantRole(role, account);
394     }
395 
396     /**
397      * @dev Revokes `role` from `account`.
398      *
399      * If `account` had been granted `role`, emits a {RoleRevoked} event.
400      *
401      * Requirements:
402      *
403      * - the caller must have ``role``'s admin role.
404      */
405     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
406         _revokeRole(role, account);
407     }
408 
409     /**
410      * @dev Revokes `role` from the calling account.
411      *
412      * Roles are often managed via {grantRole} and {revokeRole}: this function's
413      * purpose is to provide a mechanism for accounts to lose their privileges
414      * if they are compromised (such as when a trusted device is misplaced).
415      *
416      * If the calling account had been granted `role`, emits a {RoleRevoked}
417      * event.
418      *
419      * Requirements:
420      *
421      * - the caller must be `account`.
422      */
423     function renounceRole(bytes32 role, address account) public virtual override {
424         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
425 
426         _revokeRole(role, account);
427     }
428 
429     /**
430      * @dev Grants `role` to `account`.
431      *
432      * If `account` had not been already granted `role`, emits a {RoleGranted}
433      * event. Note that unlike {grantRole}, this function doesn't perform any
434      * checks on the calling account.
435      *
436      * [WARNING]
437      * ====
438      * This function should only be called from the constructor when setting
439      * up the initial roles for the system.
440      *
441      * Using this function in any other way is effectively circumventing the admin
442      * system imposed by {AccessControl}.
443      * ====
444      */
445     function _setupRole(bytes32 role, address account) internal virtual {
446         _grantRole(role, account);
447     }
448 
449     /**
450      * @dev Sets `adminRole` as ``role``'s admin role.
451      *
452      * Emits a {RoleAdminChanged} event.
453      */
454     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
455         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
456         _roles[role].adminRole = adminRole;
457     }
458 
459     function _grantRole(bytes32 role, address account) private {
460         if (!hasRole(role, account)) {
461             _roles[role].members[account] = true;
462             emit RoleGranted(role, account, _msgSender());
463         }
464     }
465 
466     function _revokeRole(bytes32 role, address account) private {
467         if (hasRole(role, account)) {
468             _roles[role].members[account] = false;
469             emit RoleRevoked(role, account, _msgSender());
470         }
471     }
472 }
473 
474 /**
475  * @dev Library for managing
476  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
477  * types.
478  *
479  * Sets have the following properties:
480  *
481  * - Elements are added, removed, and checked for existence in constant time
482  * (O(1)).
483  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
484  *
485  * ```
486  * contract Example {
487  *     // Add the library methods
488  *     using EnumerableSet for EnumerableSet.AddressSet;
489  *
490  *     // Declare a set state variable
491  *     EnumerableSet.AddressSet private mySet;
492  * }
493  * ```
494  *
495  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
496  * and `uint256` (`UintSet`) are supported.
497  */
498 library EnumerableSet {
499     // To implement this library for multiple types with as little code
500     // repetition as possible, we write it in terms of a generic Set type with
501     // bytes32 values.
502     // The Set implementation uses private functions, and user-facing
503     // implementations (such as AddressSet) are just wrappers around the
504     // underlying Set.
505     // This means that we can only create new EnumerableSets for types that fit
506     // in bytes32.
507 
508     struct Set {
509         // Storage of set values
510         bytes32[] _values;
511 
512         // Position of the value in the `values` array, plus 1 because index 0
513         // means a value is not in the set.
514         mapping (bytes32 => uint256) _indexes;
515     }
516 
517     /**
518      * @dev Add a value to a set. O(1).
519      *
520      * Returns true if the value was added to the set, that is if it was not
521      * already present.
522      */
523     function _add(Set storage set, bytes32 value) private returns (bool) {
524         if (!_contains(set, value)) {
525             set._values.push(value);
526             // The value is stored at length-1, but we add 1 to all indexes
527             // and use 0 as a sentinel value
528             set._indexes[value] = set._values.length;
529             return true;
530         } else {
531             return false;
532         }
533     }
534 
535     /**
536      * @dev Removes a value from a set. O(1).
537      *
538      * Returns true if the value was removed from the set, that is if it was
539      * present.
540      */
541     function _remove(Set storage set, bytes32 value) private returns (bool) {
542         // We read and store the value's index to prevent multiple reads from the same storage slot
543         uint256 valueIndex = set._indexes[value];
544 
545         if (valueIndex != 0) { // Equivalent to contains(set, value)
546             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
547             // the array, and then remove the last element (sometimes called as 'swap and pop').
548             // This modifies the order of the array, as noted in {at}.
549 
550             uint256 toDeleteIndex = valueIndex - 1;
551             uint256 lastIndex = set._values.length - 1;
552 
553             if (lastIndex != toDeleteIndex) {
554                 bytes32 lastvalue = set._values[lastIndex];
555 
556                 // Move the last value to the index where the value to delete is
557                 set._values[toDeleteIndex] = lastvalue;
558                 // Update the index for the moved value
559                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
560             }
561 
562             // Delete the slot where the moved value was stored
563             set._values.pop();
564 
565             // Delete the index for the deleted slot
566             delete set._indexes[value];
567 
568             return true;
569         } else {
570             return false;
571         }
572     }
573 
574     /**
575      * @dev Returns true if the value is in the set. O(1).
576      */
577     function _contains(Set storage set, bytes32 value) private view returns (bool) {
578         return set._indexes[value] != 0;
579     }
580 
581     /**
582      * @dev Returns the number of values on the set. O(1).
583      */
584     function _length(Set storage set) private view returns (uint256) {
585         return set._values.length;
586     }
587 
588    /**
589     * @dev Returns the value stored at position `index` in the set. O(1).
590     *
591     * Note that there are no guarantees on the ordering of values inside the
592     * array, and it may change when more values are added or removed.
593     *
594     * Requirements:
595     *
596     * - `index` must be strictly less than {length}.
597     */
598     function _at(Set storage set, uint256 index) private view returns (bytes32) {
599         return set._values[index];
600     }
601 
602     // Bytes32Set
603 
604     struct Bytes32Set {
605         Set _inner;
606     }
607 
608     /**
609      * @dev Add a value to a set. O(1).
610      *
611      * Returns true if the value was added to the set, that is if it was not
612      * already present.
613      */
614     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
615         return _add(set._inner, value);
616     }
617 
618     /**
619      * @dev Removes a value from a set. O(1).
620      *
621      * Returns true if the value was removed from the set, that is if it was
622      * present.
623      */
624     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
625         return _remove(set._inner, value);
626     }
627 
628     /**
629      * @dev Returns true if the value is in the set. O(1).
630      */
631     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
632         return _contains(set._inner, value);
633     }
634 
635     /**
636      * @dev Returns the number of values in the set. O(1).
637      */
638     function length(Bytes32Set storage set) internal view returns (uint256) {
639         return _length(set._inner);
640     }
641 
642    /**
643     * @dev Returns the value stored at position `index` in the set. O(1).
644     *
645     * Note that there are no guarantees on the ordering of values inside the
646     * array, and it may change when more values are added or removed.
647     *
648     * Requirements:
649     *
650     * - `index` must be strictly less than {length}.
651     */
652     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
653         return _at(set._inner, index);
654     }
655 
656     // AddressSet
657 
658     struct AddressSet {
659         Set _inner;
660     }
661 
662     /**
663      * @dev Add a value to a set. O(1).
664      *
665      * Returns true if the value was added to the set, that is if it was not
666      * already present.
667      */
668     function add(AddressSet storage set, address value) internal returns (bool) {
669         return _add(set._inner, bytes32(uint256(uint160(value))));
670     }
671 
672     /**
673      * @dev Removes a value from a set. O(1).
674      *
675      * Returns true if the value was removed from the set, that is if it was
676      * present.
677      */
678     function remove(AddressSet storage set, address value) internal returns (bool) {
679         return _remove(set._inner, bytes32(uint256(uint160(value))));
680     }
681 
682     /**
683      * @dev Returns true if the value is in the set. O(1).
684      */
685     function contains(AddressSet storage set, address value) internal view returns (bool) {
686         return _contains(set._inner, bytes32(uint256(uint160(value))));
687     }
688 
689     /**
690      * @dev Returns the number of values in the set. O(1).
691      */
692     function length(AddressSet storage set) internal view returns (uint256) {
693         return _length(set._inner);
694     }
695 
696    /**
697     * @dev Returns the value stored at position `index` in the set. O(1).
698     *
699     * Note that there are no guarantees on the ordering of values inside the
700     * array, and it may change when more values are added or removed.
701     *
702     * Requirements:
703     *
704     * - `index` must be strictly less than {length}.
705     */
706     function at(AddressSet storage set, uint256 index) internal view returns (address) {
707         return address(uint160(uint256(_at(set._inner, index))));
708     }
709 
710     // UintSet
711 
712     struct UintSet {
713         Set _inner;
714     }
715 
716     /**
717      * @dev Add a value to a set. O(1).
718      *
719      * Returns true if the value was added to the set, that is if it was not
720      * already present.
721      */
722     function add(UintSet storage set, uint256 value) internal returns (bool) {
723         return _add(set._inner, bytes32(value));
724     }
725 
726     /**
727      * @dev Removes a value from a set. O(1).
728      *
729      * Returns true if the value was removed from the set, that is if it was
730      * present.
731      */
732     function remove(UintSet storage set, uint256 value) internal returns (bool) {
733         return _remove(set._inner, bytes32(value));
734     }
735 
736     /**
737      * @dev Returns true if the value is in the set. O(1).
738      */
739     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
740         return _contains(set._inner, bytes32(value));
741     }
742 
743     /**
744      * @dev Returns the number of values on the set. O(1).
745      */
746     function length(UintSet storage set) internal view returns (uint256) {
747         return _length(set._inner);
748     }
749 
750    /**
751     * @dev Returns the value stored at position `index` in the set. O(1).
752     *
753     * Note that there are no guarantees on the ordering of values inside the
754     * array, and it may change when more values are added or removed.
755     *
756     * Requirements:
757     *
758     * - `index` must be strictly less than {length}.
759     */
760     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
761         return uint256(_at(set._inner, index));
762     }
763 }
764 
765 /**
766  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
767  */
768 interface IAccessControlEnumerable {
769     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
770     function getRoleMemberCount(bytes32 role) external view returns (uint256);
771 }
772 
773 /**
774  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
775  */
776 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
777     using EnumerableSet for EnumerableSet.AddressSet;
778 
779     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
780 
781     /**
782      * @dev See {IERC165-supportsInterface}.
783      */
784     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
785         return interfaceId == type(IAccessControlEnumerable).interfaceId
786             || super.supportsInterface(interfaceId);
787     }
788 
789     /**
790      * @dev Returns one of the accounts that have `role`. `index` must be a
791      * value between 0 and {getRoleMemberCount}, non-inclusive.
792      *
793      * Role bearers are not sorted in any particular way, and their ordering may
794      * change at any point.
795      *
796      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
797      * you perform all queries on the same block. See the following
798      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
799      * for more information.
800      */
801     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
802         return _roleMembers[role].at(index);
803     }
804 
805     /**
806      * @dev Returns the number of accounts that have `role`. Can be used
807      * together with {getRoleMember} to enumerate all bearers of a role.
808      */
809     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
810         return _roleMembers[role].length();
811     }
812 
813     /**
814      * @dev Overload {grantRole} to track enumerable memberships
815      */
816     function grantRole(bytes32 role, address account) public virtual override {
817         super.grantRole(role, account);
818         _roleMembers[role].add(account);
819     }
820 
821     /**
822      * @dev Overload {revokeRole} to track enumerable memberships
823      */
824     function revokeRole(bytes32 role, address account) public virtual override {
825         super.revokeRole(role, account);
826         _roleMembers[role].remove(account);
827     }
828 
829     /**
830      * @dev Overload {renounceRole} to track enumerable memberships
831      */
832     function renounceRole(bytes32 role, address account) public virtual override {
833         super.renounceRole(role, account);
834         _roleMembers[role].remove(account);
835     }
836 
837     /**
838      * @dev Overload {_setupRole} to track enumerable memberships
839      */
840     function _setupRole(bytes32 role, address account) internal virtual override {
841         super._setupRole(role, account);
842         _roleMembers[role].add(account);
843     }
844 }
845 
846 /**
847  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
848  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
849  *
850  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
851  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
852  * need to send a transaction, and thus is not required to hold Ether at all.
853  */
854 interface IERC20Permit {
855     /**
856      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
857      * given ``owner``'s signed approval.
858      *
859      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
860      * ordering also apply here.
861      *
862      * Emits an {Approval} event.
863      *
864      * Requirements:
865      *
866      * - `spender` cannot be the zero address.
867      * - `deadline` must be a timestamp in the future.
868      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
869      * over the EIP712-formatted function arguments.
870      * - the signature must use ``owner``'s current nonce (see {nonces}).
871      *
872      * For more information on the signature format, see the
873      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
874      * section].
875      */
876     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
877 
878     /**
879      * @dev Returns the current nonce for `owner`. This value must be
880      * included whenever a signature is generated for {permit}.
881      *
882      * Every successful call to {permit} increases ``owner``'s nonce by one. This
883      * prevents a signature from being used multiple times.
884      */
885     function nonces(address owner) external view returns (uint256);
886 
887     /**
888      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
889      */
890     // solhint-disable-next-line func-name-mixedcase
891     function DOMAIN_SEPARATOR() external view returns (bytes32);
892 }
893 
894 /**
895  * @dev Interface of the ERC20 standard as defined in the EIP.
896  */
897 interface IERC20 {
898     /**
899      * @dev Returns the amount of tokens in existence.
900      */
901     function totalSupply() external view returns (uint256);
902 
903     /**
904      * @dev Returns the amount of tokens owned by `account`.
905      */
906     function balanceOf(address account) external view returns (uint256);
907 
908     /**
909      * @dev Moves `amount` tokens from the caller's account to `recipient`.
910      *
911      * Returns a boolean value indicating whether the operation succeeded.
912      *
913      * Emits a {Transfer} event.
914      */
915     function transfer(address recipient, uint256 amount) external returns (bool);
916 
917     /**
918      * @dev Returns the remaining number of tokens that `spender` will be
919      * allowed to spend on behalf of `owner` through {transferFrom}. This is
920      * zero by default.
921      *
922      * This value changes when {approve} or {transferFrom} are called.
923      */
924     function allowance(address owner, address spender) external view returns (uint256);
925 
926     /**
927      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
928      *
929      * Returns a boolean value indicating whether the operation succeeded.
930      *
931      * IMPORTANT: Beware that changing an allowance with this method brings the risk
932      * that someone may use both the old and the new allowance by unfortunate
933      * transaction ordering. One possible solution to mitigate this race
934      * condition is to first reduce the spender's allowance to 0 and set the
935      * desired value afterwards:
936      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address spender, uint256 amount) external returns (bool);
941 
942     /**
943      * @dev Moves `amount` tokens from `sender` to `recipient` using the
944      * allowance mechanism. `amount` is then deducted from the caller's
945      * allowance.
946      *
947      * Returns a boolean value indicating whether the operation succeeded.
948      *
949      * Emits a {Transfer} event.
950      */
951     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
952 
953     /**
954      * @dev Emitted when `value` tokens are moved from one account (`from`) to
955      * another (`to`).
956      *
957      * Note that `value` may be zero.
958      */
959     event Transfer(address indexed from, address indexed to, uint256 value);
960 
961     /**
962      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
963      * a call to {approve}. `value` is the new allowance.
964      */
965     event Approval(address indexed owner, address indexed spender, uint256 value);
966 }
967 
968 /**
969  * @dev Interface for the optional metadata functions from the ERC20 standard.
970  *
971  * _Available since v4.1._
972  */
973 interface IERC20Metadata is IERC20 {
974     /**
975      * @dev Returns the name of the token.
976      */
977     function name() external view returns (string memory);
978 
979     /**
980      * @dev Returns the symbol of the token.
981      */
982     function symbol() external view returns (string memory);
983 
984     /**
985      * @dev Returns the decimals places of the token.
986      */
987     function decimals() external view returns (uint8);
988 }
989 
990 /**
991  * @dev Implementation of the {IERC20} interface.
992  *
993  * This implementation is agnostic to the way tokens are created. This means
994  * that a supply mechanism has to be added in a derived contract using {_mint}.
995  * For a generic mechanism see {ERC20PresetMinterPauser}.
996  *
997  * TIP: For a detailed writeup see our guide
998  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
999  * to implement supply mechanisms].
1000  *
1001  * We have followed general OpenZeppelin guidelines: functions revert instead
1002  * of returning `false` on failure. This behavior is nonetheless conventional
1003  * and does not conflict with the expectations of ERC20 applications.
1004  *
1005  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1006  * This allows applications to reconstruct the allowance for all accounts just
1007  * by listening to said events. Other implementations of the EIP may not emit
1008  * these events, as it isn't required by the specification.
1009  *
1010  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1011  * functions have been added to mitigate the well-known issues around setting
1012  * allowances. See {IERC20-approve}.
1013  */
1014 contract ERC20 is Context, IERC20, IERC20Metadata {
1015     mapping (address => uint256) internal _RealBalances;
1016 
1017     mapping (address => mapping (address => uint256)) internal _allowances;
1018 
1019 
1020     string internal _name;
1021     string internal _symbol;
1022 
1023     /**
1024      * @dev Sets the values for {name} and {symbol}.
1025      *
1026      * The defaut value of {decimals} is 18. To select a different value for
1027      * {decimals} you should overload it.
1028      *
1029      * All two of these values are immutable: they can only be set once during
1030      * construction.
1031      */
1032     constructor (string memory name_, string memory symbol_) {
1033         _name = name_;
1034         _symbol = symbol_;
1035     }
1036 
1037     /**
1038      * @dev Returns the name of the token.
1039      */
1040     function name() public view virtual override returns (string memory) {
1041         return _name;
1042     }
1043 
1044     /**
1045      * @dev Returns the symbol of the token, usually a shorter version of the
1046      * name.
1047      */
1048     function symbol() public view virtual override returns (string memory) {
1049         return _symbol;
1050     }
1051 
1052     /**
1053      * @dev Returns the number of decimals used to get its user representation.
1054      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1055      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1056      *
1057      * Tokens usually opt for a value of 18, imitating the relationship between
1058      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1059      * overridden;
1060      *
1061      * NOTE: This information is only used for _display_ purposes: it in
1062      * no way affects any of the arithmetic of the contract, including
1063      * {IERC20-balanceOf} and {IERC20-transfer}.
1064      */
1065     function decimals() public view virtual override returns (uint8) {
1066         return 18;
1067     }
1068 
1069     /**
1070      * @dev See {IERC20-totalSupply}.
1071      */
1072     function totalSupply() public view virtual override returns (uint256) {
1073         // overriden in parent contract
1074     }
1075 
1076     /**
1077      * @dev See {IERC20-balanceOf}.
1078      */
1079     function balanceOf(address account) public view virtual override returns (uint256) {
1080         return _RealBalances[account];
1081     }
1082 
1083     /**
1084      * @dev See {IERC20-transfer}.
1085      *
1086      * Requirements:
1087      *
1088      * - `recipient` cannot be the zero address.
1089      * - the caller must have a balance of at least `amount`.
1090      */
1091     function transfer(address recipient, uint256 amount) public virtual override returns (bool) { }
1092 
1093     /**
1094      * @dev See {IERC20-allowance}.
1095      */
1096     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1097         return _allowances[owner][spender];
1098     }
1099 
1100     /**
1101      * @dev See {IERC20-approve}.
1102      *
1103      * Requirements:
1104      *
1105      * - `spender` cannot be the zero address.
1106      */
1107     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1108         _approve(_msgSender(), spender, amount);
1109         return true;
1110     }
1111 
1112     /**
1113      * @dev See {IERC20-transferFrom}.
1114      *
1115      * Emits an {Approval} event indicating the updated allowance. This is not
1116      * required by the EIP. See the note at the beginning of {ERC20}.
1117      *
1118      * Requirements:
1119      *
1120      * - `sender` and `recipient` cannot be the zero address.
1121      * - `sender` must have a balance of at least `amount`.
1122      * - the caller must have allowance for ``sender``'s tokens of at least
1123      * `amount`.
1124      */
1125     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) { }
1126 
1127     /**
1128      * @dev Atomically increases the allowance granted to `spender` by the caller.
1129      *
1130      * This is an alternative to {approve} that can be used as a mitigation for
1131      * problems described in {IERC20-approve}.
1132      *
1133      * Emits an {Approval} event indicating the updated allowance.
1134      *
1135      * Requirements:
1136      *
1137      * - `spender` cannot be the zero address.
1138      */
1139     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1140         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1141         return true;
1142     }
1143 
1144     /**
1145      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1146      *
1147      * This is an alternative to {approve} that can be used as a mitigation for
1148      * problems described in {IERC20-approve}.
1149      *
1150      * Emits an {Approval} event indicating the updated allowance.
1151      *
1152      * Requirements:
1153      *
1154      * - `spender` cannot be the zero address.
1155      * - `spender` must have allowance for the caller of at least
1156      * `subtractedValue`.
1157      */
1158     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1159         uint256 currentAllowance = _allowances[_msgSender()][spender];
1160         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1161         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1162 
1163         return true;
1164     }
1165 
1166     /**
1167      * @dev Moves tokens `amount` from `sender` to `recipient`.
1168      *
1169      * This is internal function is equivalent to {transfer}, and can be used to
1170      * e.g. implement automatic token fees, slashing mechanisms, etc.
1171      *
1172      * Emits a {Transfer} event.
1173      *
1174      * Requirements:
1175      *
1176      * - `sender` cannot be the zero address.
1177      * - `recipient` cannot be the zero address.
1178      * - `sender` must have a balance of at least `amount`.
1179      */
1180     function _transfer(address sender, address recipient, uint256 amount) internal virtual { }
1181 
1182 
1183     /**
1184      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1185      *
1186      * This internal function is equivalent to `approve`, and can be used to
1187      * e.g. set automatic allowances for certain subsystems, etc.
1188      *
1189      * Emits an {Approval} event.
1190      *
1191      * Requirements:
1192      *
1193      * - `owner` cannot be the zero address.
1194      * - `spender` cannot be the zero address.
1195      */
1196     function _approve(address owner, address spender, uint256 amount) internal virtual {
1197         require(owner != address(0), "ERC20: approve from the zero address");
1198         require(spender != address(0), "ERC20: approve to the zero address");
1199 
1200         _allowances[owner][spender] = amount;
1201         emit Approval(owner, spender, amount);
1202     }
1203 }
1204 
1205 /**
1206  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1207  *
1208  * These functions can be used to verify that a message was signed by the holder
1209  * of the private keys of a given address.
1210  */
1211 library ECDSA {
1212     /**
1213      * @dev Returns the address that signed a hashed message (`hash`) with
1214      * `signature`. This address can then be used for verification purposes.
1215      *
1216      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1217      * this function rejects them by requiring the `s` value to be in the lower
1218      * half order, and the `v` value to be either 27 or 28.
1219      *
1220      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1221      * verification to be secure: it is possible to craft signatures that
1222      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1223      * this is by receiving a hash of the original message (which may otherwise
1224      * be too long), and then calling {toEthSignedMessageHash} on it.
1225      */
1226     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1227         // Divide the signature in r, s and v variables
1228         bytes32 r;
1229         bytes32 s;
1230         uint8 v;
1231 
1232         // Check the signature length
1233         // - case 65: r,s,v signature (standard)
1234         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1235         if (signature.length == 65) {
1236             // ecrecover takes the signature parameters, and the only way to get them
1237             // currently is to use assembly.
1238             // solhint-disable-next-line no-inline-assembly
1239             assembly {
1240                 r := mload(add(signature, 0x20))
1241                 s := mload(add(signature, 0x40))
1242                 v := byte(0, mload(add(signature, 0x60)))
1243             }
1244         } else if (signature.length == 64) {
1245             // ecrecover takes the signature parameters, and the only way to get them
1246             // currently is to use assembly.
1247             // solhint-disable-next-line no-inline-assembly
1248             assembly {
1249                 let vs := mload(add(signature, 0x40))
1250                 r := mload(add(signature, 0x20))
1251                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1252                 v := add(shr(255, vs), 27)
1253             }
1254         } else {
1255             revert("ECDSA: invalid signature length");
1256         }
1257 
1258         return recover(hash, v, r, s);
1259     }
1260 
1261     /**
1262      * @dev Overload of {ECDSA-recover} that receives the `v`,
1263      * `r` and `s` signature fields separately.
1264      */
1265     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1266         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1267         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1268         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1269         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1270         //
1271         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1272         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1273         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1274         // these malleable signatures as well.
1275         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
1276         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
1277 
1278         // If the signature is valid (and not malleable), return the signer address
1279         address signer = ecrecover(hash, v, r, s);
1280         require(signer != address(0), "ECDSA: invalid signature");
1281 
1282         return signer;
1283     }
1284 
1285     /**
1286      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1287      * produces hash corresponding to the one signed with the
1288      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1289      * JSON-RPC method as part of EIP-191.
1290      *
1291      * See {recover}.
1292      */
1293     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1294         // 32 is the length in bytes of hash,
1295         // enforced by the type signature above
1296         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1297     }
1298 
1299     /**
1300      * @dev Returns an Ethereum Signed Typed Data, created from a
1301      * `domainSeparator` and a `structHash`. This produces hash corresponding
1302      * to the one signed with the
1303      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1304      * JSON-RPC method as part of EIP-712.
1305      *
1306      * See {recover}.
1307      */
1308     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1309         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1310     }
1311 }
1312 
1313 /**
1314  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1315  *
1316  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1317  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1318  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1319  *
1320  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1321  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1322  * ({_hashTypedDataV4}).
1323  *
1324  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1325  * the chain id to protect against replay attacks on an eventual fork of the chain.
1326  *
1327  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1328  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1329  *
1330  * _Available since v3.4._
1331  */
1332 abstract contract EIP712 {
1333     /* solhint-disable var-name-mixedcase */
1334     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1335     // invalidate the cached domain separator if the chain id changes.
1336     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1337     uint256 private immutable _CACHED_CHAIN_ID;
1338 
1339     bytes32 private immutable _HASHED_NAME;
1340     bytes32 private immutable _HASHED_VERSION;
1341     bytes32 private immutable _TYPE_HASH;
1342     /* solhint-enable var-name-mixedcase */
1343 
1344     /**
1345      * @dev Initializes the domain separator and parameter caches.
1346      *
1347      * The meaning of `name` and `version` is specified in
1348      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1349      *
1350      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1351      * - `version`: the current major version of the signing domain.
1352      *
1353      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1354      * contract upgrade].
1355      */
1356     constructor(string memory name, string memory version) {
1357         bytes32 hashedName = keccak256(bytes(name));
1358         bytes32 hashedVersion = keccak256(bytes(version));
1359         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1360         _HASHED_NAME = hashedName;
1361         _HASHED_VERSION = hashedVersion;
1362         _CACHED_CHAIN_ID = block.chainid;
1363         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1364         _TYPE_HASH = typeHash;
1365     }
1366 
1367     /**
1368      * @dev Returns the domain separator for the current chain.
1369      */
1370     function _domainSeparatorV4() internal view returns (bytes32) {
1371         if (block.chainid == _CACHED_CHAIN_ID) {
1372             return _CACHED_DOMAIN_SEPARATOR;
1373         } else {
1374             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1375         }
1376     }
1377 
1378     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
1379         return keccak256(
1380             abi.encode(
1381                 typeHash,
1382                 name,
1383                 version,
1384                 block.chainid,
1385                 address(this)
1386             )
1387         );
1388     }
1389 
1390     /**
1391      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1392      * function returns the hash of the fully encoded EIP712 message for this domain.
1393      *
1394      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1395      *
1396      * ```solidity
1397      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1398      *     keccak256("Mail(address to,string contents)"),
1399      *     mailTo,
1400      *     keccak256(bytes(mailContents))
1401      * )));
1402      * address signer = ECDSA.recover(digest, signature);
1403      * ```
1404      */
1405     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1406         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1407     }
1408 }
1409 
1410 /**
1411  * @title Counters
1412  * @author Matt Condon (@shrugs)
1413  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1414  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1415  *
1416  * Include with `using Counters for Counters.Counter;`
1417  */
1418 library Counters {
1419     struct Counter {
1420         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1421         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1422         // this feature: see https://github.com/ethereum/solidity/issues/4637
1423         uint256 _value; // default: 0
1424     }
1425 
1426     function current(Counter storage counter) internal view returns (uint256) {
1427         return counter._value;
1428     }
1429 
1430     function increment(Counter storage counter) internal {
1431         unchecked {
1432             counter._value += 1;
1433         }
1434     }
1435 
1436     function decrement(Counter storage counter) internal {
1437         uint256 value = counter._value;
1438         require(value > 0, "Counter: decrement overflow");
1439         unchecked {
1440             counter._value = value - 1;
1441         }
1442     }
1443 }
1444 
1445 /**
1446  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1447  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1448  *
1449  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1450  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1451  * need to send a transaction, and thus is not required to hold Ether at all.
1452  *
1453  * _Available since v3.4._
1454  */
1455 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1456     using Counters for Counters.Counter;
1457 
1458     mapping (address => Counters.Counter) private _nonces;
1459 
1460     // solhint-disable-next-line var-name-mixedcase
1461     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1462 
1463     /**
1464      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1465      *
1466      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1467      */
1468     constructor(string memory name) EIP712(name, "1") {
1469     }
1470 
1471     /**
1472      * @dev See {IERC20Permit-permit}.
1473      */
1474     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1475         // solhint-disable-next-line not-rely-on-time
1476         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1477 
1478         bytes32 structHash = keccak256(
1479             abi.encode(
1480                 _PERMIT_TYPEHASH,
1481                 owner,
1482                 spender,
1483                 value,
1484                 _useNonce(owner),
1485                 deadline
1486             )
1487         );
1488 
1489         bytes32 hash = _hashTypedDataV4(structHash);
1490 
1491         address signer = ECDSA.recover(hash, v, r, s);
1492         require(signer == owner, "ERC20Permit: invalid signature");
1493 
1494         _approve(owner, spender, value);
1495     }
1496 
1497     /**
1498      * @dev See {IERC20Permit-nonces}.
1499      */
1500     function nonces(address owner) public view virtual override returns (uint256) {
1501         return _nonces[owner].current();
1502     }
1503 
1504     /**
1505      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1506      */
1507     // solhint-disable-next-line func-name-mixedcase
1508     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1509         return _domainSeparatorV4();
1510     }
1511 
1512     /**
1513      * @dev "Consume a nonce": return the current value and increment.
1514      *
1515      * _Available since v4.1._
1516      */
1517     function _useNonce(address owner) internal virtual returns (uint256 current) {
1518         Counters.Counter storage nonce = _nonces[owner];
1519         current = nonce.current();
1520         nonce.increment();
1521     }
1522 }
1523 
1524 contract DefiFactoryToken is Context, AccessControlEnumerable, ERC20, ERC20Permit {
1525     bytes32 public constant ROLE_MINTER = keccak256("ROLE_MINTER");
1526     bytes32 public constant ROLE_BURNER = keccak256("ROLE_BURNER");
1527     bytes32 public constant ROLE_TRANSFERER = keccak256("ROLE_TRANSFERER");
1528     bytes32 public constant ROLE_MODERATOR = keccak256("ROLE_MODERATOR");
1529     bytes32 public constant ROLE_TAXER = keccak256("ROLE_TAXER");
1530     
1531     uint constant NOBOTS_TECH_CONTRACT_ID = 0;
1532     uint constant TEAM_VESTING_CONTRACT_ID = 1;
1533     
1534     address[] utilsContracts;
1535     
1536     struct AccessSettings {
1537         bool isMinter;
1538         bool isBurner;
1539         bool isTransferer;
1540         bool isModerator;
1541         bool isTaxer;
1542         
1543         address addr;
1544     }
1545     
1546     bool public isPaused;
1547     
1548     address constant BURN_ADDRESS = address(0x0);
1549     
1550     event VestedAmountClaimed(address recipient, uint amount);
1551     event UpdatedUtilsContracts(AccessSettings[] accessSettings);
1552     event TransferCustom(address sender, address recipient, uint amount);
1553     event MintHumanAddress(address recipient, uint amount);
1554     event BurnHumanAddress(address sender, uint amount);
1555     event ClaimedReferralRewards(address recipient, uint amount);
1556     
1557     event MintedByBridge(address recipient, uint amount);
1558     event BurnedByBridge(address sender, uint amount);
1559 
1560     constructor() 
1561         ERC20("Defi Factory Token", "DEFT") 
1562         ERC20Permit("Defi Factory Token")
1563     {
1564         _setupRole(ROLE_ADMIN, _msgSender());
1565         _setupRole(ROLE_MINTER, _msgSender());
1566         _setupRole(ROLE_BURNER, _msgSender());
1567         _setupRole(ROLE_TRANSFERER, _msgSender());
1568         _setupRole(ROLE_MODERATOR, _msgSender());
1569         _setupRole(ROLE_TAXER, _msgSender());
1570     }
1571     
1572     modifier notPausedContract {
1573         require(
1574             !isPaused,
1575             "DEFT: paused"
1576         );
1577         _;
1578     }
1579     
1580     modifier pausedContract {
1581         require(
1582             isPaused,
1583             "DEFT: !paused"
1584         );
1585         _;
1586     }
1587     
1588     function updateNameAndSymbol(string calldata __name, string calldata __symbol)
1589         external
1590         onlyRole(ROLE_ADMIN)
1591     {
1592         _name = __name;
1593         _symbol = __symbol;
1594     }
1595     
1596     function balanceOf(address account) 
1597         public 
1598         view 
1599         override 
1600         returns(uint) 
1601     {
1602         return INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]).
1603             getBalance(account, _RealBalances[account]);
1604     }
1605     
1606     function totalSupply() 
1607         public 
1608         view 
1609         override 
1610         returns (uint) 
1611     {
1612         return INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]).
1613             getTotalSupply();
1614     }
1615     
1616     function pauseContract()
1617         external
1618         notPausedContract
1619         onlyRole(ROLE_ADMIN)
1620     {
1621         isPaused = true;
1622     }
1623     
1624     function resumeContract()
1625         external
1626         pausedContract
1627         onlyRole(ROLE_ADMIN)
1628     {
1629         isPaused = false;
1630     }
1631     
1632     function transfer(address recipient, uint256 amount) 
1633         public 
1634         notPausedContract
1635         virtual 
1636         override 
1637         returns (bool) 
1638     {
1639         _transfer(_msgSender(), recipient, amount);
1640         return true;
1641     }
1642     
1643     function transferFrom(address sender, address recipient, uint256 amount) 
1644         public 
1645         notPausedContract
1646         virtual 
1647         override 
1648         returns (bool) 
1649     {
1650         require(
1651             sender != BURN_ADDRESS,
1652             "DEFT: !burn"
1653         );
1654         _transfer(sender, recipient, amount);
1655 
1656         uint256 currentAllowance = _allowances[sender][_msgSender()];
1657         require(currentAllowance >= amount, "DEFT: transfer amount exceeds allowance");
1658         _approve(sender, _msgSender(), currentAllowance - amount);
1659 
1660         return true;
1661     }
1662     
1663     function moderatorTransferFromWhilePaused(address sender, address recipient, uint256 amount) 
1664         external 
1665         pausedContract
1666         onlyRole(ROLE_MODERATOR)
1667         returns (bool) 
1668     {
1669         require(
1670             sender != BURN_ADDRESS,
1671             "DEFT: !burn"
1672         );
1673         _transfer(sender, recipient, amount);
1674 
1675         return true;
1676     }
1677     
1678     function transferCustom(address sender, address recipient, uint256 amount)
1679         external
1680         notPausedContract
1681         onlyRole(ROLE_TRANSFERER)
1682     {
1683         require(
1684             sender != BURN_ADDRESS,
1685             "DEFT: !burn"
1686         );
1687         _transfer(sender, recipient, amount);
1688         
1689         emit TransferCustom(sender, recipient, amount);
1690     }
1691     
1692     function _transfer(address sender, address recipient, uint amount) 
1693         internal
1694         virtual 
1695         override 
1696     {
1697         require(
1698             recipient != BURN_ADDRESS,
1699             "DEFT: !burn"
1700         );
1701         require(
1702             sender != recipient,
1703             "DEFT: !self"
1704         );
1705         
1706         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1707         TaxAmountsOutput memory taxAmountsOutput = iNoBotsTech.prepareTaxAmounts(
1708             TaxAmountsInput(
1709                 sender,
1710                 recipient,
1711                 amount,
1712                 _RealBalances[sender],
1713                 _RealBalances[recipient]
1714             )
1715         );
1716         
1717         _RealBalances[sender] = taxAmountsOutput.senderRealBalance;
1718         _RealBalances[recipient] = taxAmountsOutput.recipientRealBalance;
1719         
1720         emit Transfer(sender, recipient, taxAmountsOutput.recipientGetsAmount);
1721         emit Transfer(sender, BURN_ADDRESS, taxAmountsOutput.burnAndRewardAmount);
1722     }
1723     
1724     function transferFromTeamVestingContract(address recipient, uint256 amount)
1725         external
1726         notPausedContract
1727     {
1728         address vestingContract = utilsContracts[TEAM_VESTING_CONTRACT_ID];
1729         require(vestingContract == _msgSender(), "DEFT: !VESTING_CONTRACT");
1730         
1731         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1732         _RealBalances[vestingContract] -= amount;
1733         _RealBalances[recipient] += 
1734             iNoBotsTech.getRealBalanceTeamVestingContract(amount);
1735         
1736         iNoBotsTech.publicForcedUpdateCacheMultiplier();
1737         
1738         emit Transfer(vestingContract, recipient, amount);
1739         emit VestedAmountClaimed(recipient, amount);
1740     }
1741     
1742     function registerReferral(address referrer)
1743         public
1744     {
1745         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1746         return iNoBotsTech.registerReferral(_msgSender(), referrer);
1747     }
1748     
1749     function getTemporaryReferralRealAmountsBulk(address[] calldata addrs)
1750         external
1751         view
1752         returns (TemporaryReferralRealAmountsBulk[] memory)
1753     {
1754         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1755         return iNoBotsTech.getTemporaryReferralRealAmountsBulk(addrs);
1756     }
1757     
1758     function getCachedReferrerRewards(address addr)
1759         external
1760         view
1761         returns(uint)
1762     {
1763         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1764         return iNoBotsTech.getCachedReferrerRewards(addr);
1765     }
1766     
1767     function getCalculatedReferrerRewards(address addr, address[] calldata referrals)
1768         external
1769         view
1770         returns(uint)
1771     {
1772         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1773         return iNoBotsTech.getCalculatedReferrerRewards(addr, referrals);
1774     }
1775     
1776     function filterNonZeroReferrals(address[] calldata referrals)
1777         external
1778         view
1779         returns (address[] memory)
1780     {
1781         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1782         return iNoBotsTech.filterNonZeroReferrals(referrals);
1783     }
1784     
1785     function claimReferrerRewards(address[] calldata referrals)
1786         external
1787         notPausedContract
1788     {
1789         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1790         iNoBotsTech.updateReferrersRewards(referrals);
1791         
1792         uint rewards = iNoBotsTech.getCachedReferrerRewards(_msgSender());
1793         require(rewards > 0, "DEFT: !rewards");
1794         
1795         iNoBotsTech.clearReferrerRewards(_msgSender());
1796         _mintHumanAddress(_msgSender(), rewards);
1797         
1798         emit ClaimedReferralRewards(_msgSender(), rewards);
1799     }
1800     
1801     function chargeCustomTax(address from, uint amount)
1802         external
1803         notPausedContract
1804         onlyRole(ROLE_TAXER)
1805     {
1806         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1807         _RealBalances[from] = iNoBotsTech.chargeCustomTax(amount, _RealBalances[from]);
1808     }
1809     
1810     function updateUtilsContracts(AccessSettings[] calldata accessSettings)
1811         external
1812         onlyRole(ROLE_ADMIN)
1813     {
1814         for(uint i = 0; i < utilsContracts.length; i++)
1815         {
1816             revokeRole(ROLE_MINTER, utilsContracts[i]);
1817             revokeRole(ROLE_BURNER, utilsContracts[i]);
1818             revokeRole(ROLE_TRANSFERER, utilsContracts[i]);
1819             revokeRole(ROLE_MODERATOR, utilsContracts[i]);
1820             revokeRole(ROLE_TAXER, utilsContracts[i]);
1821         }
1822         delete utilsContracts;
1823         
1824         for(uint i = 0; i < accessSettings.length; i++)
1825         {
1826             if (accessSettings[i].isMinter) grantRole(ROLE_MINTER, accessSettings[i].addr);
1827             if (accessSettings[i].isBurner) grantRole(ROLE_BURNER, accessSettings[i].addr);
1828             if (accessSettings[i].isTransferer) grantRole(ROLE_TRANSFERER, accessSettings[i].addr);
1829             if (accessSettings[i].isModerator) grantRole(ROLE_MODERATOR, accessSettings[i].addr);
1830             if (accessSettings[i].isTaxer) grantRole(ROLE_TAXER, accessSettings[i].addr);
1831             
1832             utilsContracts.push(accessSettings[i].addr);
1833         }
1834         
1835         emit UpdatedUtilsContracts(accessSettings);
1836     }
1837     
1838     function getUtilsContractAtPos(uint pos)
1839         external
1840         view
1841         returns (address)
1842     {
1843         return utilsContracts[pos];
1844     }
1845     
1846     function getUtilsContractsCount()
1847         external
1848         view
1849         returns(uint)
1850     {
1851         return utilsContracts.length;
1852     }
1853     
1854     function mintByBridge(address to, uint desiredAmountToMint) 
1855         external
1856         notPausedContract
1857         onlyRole(ROLE_MINTER)
1858     {
1859         _mintHumanAddress(to, desiredAmountToMint);
1860         emit MintedByBridge(to, desiredAmountToMint);
1861     }
1862     
1863     function mintHumanAddress(address to, uint desiredAmountToMint) 
1864         external
1865         notPausedContract
1866         onlyRole(ROLE_MINTER)
1867     {
1868         _mintHumanAddress(to, desiredAmountToMint);
1869         emit MintHumanAddress(to, desiredAmountToMint);
1870     }
1871     
1872     function _mintHumanAddress(address to, uint desiredAmountToMint) 
1873         private
1874     {
1875         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1876         uint realAmountToMint = 
1877             iNoBotsTech.
1878                 prepareHumanAddressMintOrBurnRewardsAmounts(
1879                     true,
1880                     to,
1881                     desiredAmountToMint
1882                 );
1883         
1884         _RealBalances[to] += realAmountToMint;
1885         iNoBotsTech.publicForcedUpdateCacheMultiplier();
1886         
1887         emit Transfer(address(0), to, desiredAmountToMint);
1888     }
1889 
1890     function burnByBridge(address from, uint desiredAmountToBurn)
1891         external
1892         notPausedContract
1893         onlyRole(ROLE_BURNER)
1894     {
1895         _burnHumanAddress(from, desiredAmountToBurn);
1896         emit BurnedByBridge(from, desiredAmountToBurn);
1897     }
1898 
1899     function burnHumanAddress(address from, uint desiredAmountToBurn)
1900         external
1901         notPausedContract
1902         onlyRole(ROLE_BURNER)
1903     {
1904         _burnHumanAddress(from, desiredAmountToBurn);
1905         emit BurnHumanAddress(from, desiredAmountToBurn);
1906     }
1907 
1908     function _burnHumanAddress(address from, uint desiredAmountToBurn)
1909         private
1910     {
1911         INoBotsTech iNoBotsTech = INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]);
1912         uint realAmountToBurn = 
1913             INoBotsTech(utilsContracts[NOBOTS_TECH_CONTRACT_ID]).
1914                 prepareHumanAddressMintOrBurnRewardsAmounts(
1915                     false,
1916                     from,
1917                     desiredAmountToBurn
1918                 );
1919         
1920         _RealBalances[from] -= realAmountToBurn;
1921         iNoBotsTech.publicForcedUpdateCacheMultiplier();
1922         
1923         emit Transfer(from, address(0), desiredAmountToBurn);
1924     }
1925     
1926     function getChainId() 
1927         external 
1928         view 
1929         returns (uint) 
1930     {
1931         return block.chainid;
1932     }
1933 }