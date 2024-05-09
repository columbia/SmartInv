1 //          
2 //              &&&&
3 //              &&&&
4 //              &&&&
5 //              &&&&  &&&&&&&&&       &&&&&&&&&&&&          &&&&&&&&&&/   &&&&.&&&&&&&&&
6 //              &&&&&&&&&   &&&&&   &&&&&&     &&&&&,     &&&&&    &&&&&  &&&&&&&&   &&&&
7 //               &&&&&&      &&&&  &&&&#         &&&&   &&&&&       &&&&& &&&&&&     &&&&&
8 //               &&&&&       &&&&/ &&&&           &&&& #&&&&        &&&&  &&&&&
9 //               &&&&         &&&& &&&&&         &&&&  &&&&        &&&&&  &&&&&
10 //               %%%%        /%%%%   %%%%%%   %%%%%%   %%%%  %%%%%%%%%    %%%%%
11 //              %%%%%        %%%%      %%%%%%%%%%%    %%%%   %%%%%%       %%%%
12 //                                                    %%%%
13 //                                                    %%%%
14 //                                                    %%%%
15 //
16 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.0.1
17 
18 pragma solidity ^0.6.0;
19 
20 /**
21  * @dev Library for managing
22  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
23  * types.
24  *
25  * Sets have the following properties:
26  *
27  * - Elements are added, removed, and checked for existence in constant time
28  * (O(1)).
29  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
30  *
31  * ```
32  * contract Example {
33  *     // Add the library methods
34  *     using EnumerableSet for EnumerableSet.AddressSet;
35  *
36  *     // Declare a set state variable
37  *     EnumerableSet.AddressSet private mySet;
38  * }
39  * ```
40  *
41  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
42  * (`UintSet`) are supported.
43  */
44 library EnumerableSet {
45     // To implement this library for multiple types with as little code
46     // repetition as possible, we write it in terms of a generic Set type with
47     // bytes32 values.
48     // The Set implementation uses private functions, and user-facing
49     // implementations (such as AddressSet) are just wrappers around the
50     // underlying Set.
51     // This means that we can only create new EnumerableSets for types that fit
52     // in bytes32.
53 
54     struct Set {
55         // Storage of set values
56         bytes32[] _values;
57 
58         // Position of the value in the `values` array, plus 1 because index 0
59         // means a value is not in the set.
60         mapping (bytes32 => uint256) _indexes;
61     }
62 
63     /**
64      * @dev Add a value to a set. O(1).
65      *
66      * Returns true if the value was added to the set, that is if it was not
67      * already present.
68      */
69     function _add(Set storage set, bytes32 value) private returns (bool) {
70         if (!_contains(set, value)) {
71             set._values.push(value);
72             // The value is stored at length-1, but we add 1 to all indexes
73             // and use 0 as a sentinel value
74             set._indexes[value] = set._values.length;
75             return true;
76         } else {
77             return false;
78         }
79     }
80 
81     /**
82      * @dev Removes a value from a set. O(1).
83      *
84      * Returns true if the value was removed from the set, that is if it was
85      * present.
86      */
87     function _remove(Set storage set, bytes32 value) private returns (bool) {
88         // We read and store the value's index to prevent multiple reads from the same storage slot
89         uint256 valueIndex = set._indexes[value];
90 
91         if (valueIndex != 0) { // Equivalent to contains(set, value)
92             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
93             // the array, and then remove the last element (sometimes called as 'swap and pop').
94             // This modifies the order of the array, as noted in {at}.
95 
96             uint256 toDeleteIndex = valueIndex - 1;
97             uint256 lastIndex = set._values.length - 1;
98 
99             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
100             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
101 
102             bytes32 lastvalue = set._values[lastIndex];
103 
104             // Move the last value to the index where the value to delete is
105             set._values[toDeleteIndex] = lastvalue;
106             // Update the index for the moved value
107             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
108 
109             // Delete the slot where the moved value was stored
110             set._values.pop();
111 
112             // Delete the index for the deleted slot
113             delete set._indexes[value];
114 
115             return true;
116         } else {
117             return false;
118         }
119     }
120 
121     /**
122      * @dev Returns true if the value is in the set. O(1).
123      */
124     function _contains(Set storage set, bytes32 value) private view returns (bool) {
125         return set._indexes[value] != 0;
126     }
127 
128     /**
129      * @dev Returns the number of values on the set. O(1).
130      */
131     function _length(Set storage set) private view returns (uint256) {
132         return set._values.length;
133     }
134 
135    /**
136     * @dev Returns the value stored at position `index` in the set. O(1).
137     *
138     * Note that there are no guarantees on the ordering of values inside the
139     * array, and it may change when more values are added or removed.
140     *
141     * Requirements:
142     *
143     * - `index` must be strictly less than {length}.
144     */
145     function _at(Set storage set, uint256 index) private view returns (bytes32) {
146         require(set._values.length > index, "EnumerableSet: index out of bounds");
147         return set._values[index];
148     }
149 
150     // AddressSet
151 
152     struct AddressSet {
153         Set _inner;
154     }
155 
156     /**
157      * @dev Add a value to a set. O(1).
158      *
159      * Returns true if the value was added to the set, that is if it was not
160      * already present.
161      */
162     function add(AddressSet storage set, address value) internal returns (bool) {
163         return _add(set._inner, bytes32(uint256(value)));
164     }
165 
166     /**
167      * @dev Removes a value from a set. O(1).
168      *
169      * Returns true if the value was removed from the set, that is if it was
170      * present.
171      */
172     function remove(AddressSet storage set, address value) internal returns (bool) {
173         return _remove(set._inner, bytes32(uint256(value)));
174     }
175 
176     /**
177      * @dev Returns true if the value is in the set. O(1).
178      */
179     function contains(AddressSet storage set, address value) internal view returns (bool) {
180         return _contains(set._inner, bytes32(uint256(value)));
181     }
182 
183     /**
184      * @dev Returns the number of values in the set. O(1).
185      */
186     function length(AddressSet storage set) internal view returns (uint256) {
187         return _length(set._inner);
188     }
189 
190    /**
191     * @dev Returns the value stored at position `index` in the set. O(1).
192     *
193     * Note that there are no guarantees on the ordering of values inside the
194     * array, and it may change when more values are added or removed.
195     *
196     * Requirements:
197     *
198     * - `index` must be strictly less than {length}.
199     */
200     function at(AddressSet storage set, uint256 index) internal view returns (address) {
201         return address(uint256(_at(set._inner, index)));
202     }
203 
204 
205     // UintSet
206 
207     struct UintSet {
208         Set _inner;
209     }
210 
211     /**
212      * @dev Add a value to a set. O(1).
213      *
214      * Returns true if the value was added to the set, that is if it was not
215      * already present.
216      */
217     function add(UintSet storage set, uint256 value) internal returns (bool) {
218         return _add(set._inner, bytes32(value));
219     }
220 
221     /**
222      * @dev Removes a value from a set. O(1).
223      *
224      * Returns true if the value was removed from the set, that is if it was
225      * present.
226      */
227     function remove(UintSet storage set, uint256 value) internal returns (bool) {
228         return _remove(set._inner, bytes32(value));
229     }
230 
231     /**
232      * @dev Returns true if the value is in the set. O(1).
233      */
234     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
235         return _contains(set._inner, bytes32(value));
236     }
237 
238     /**
239      * @dev Returns the number of values on the set. O(1).
240      */
241     function length(UintSet storage set) internal view returns (uint256) {
242         return _length(set._inner);
243     }
244 
245    /**
246     * @dev Returns the value stored at position `index` in the set. O(1).
247     *
248     * Note that there are no guarantees on the ordering of values inside the
249     * array, and it may change when more values are added or removed.
250     *
251     * Requirements:
252     *
253     * - `index` must be strictly less than {length}.
254     */
255     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
256         return uint256(_at(set._inner, index));
257     }
258 }
259 
260 
261 // File @openzeppelin/contracts/utils/Address.sol@v3.0.1
262 
263 pragma solidity ^0.6.2;
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 }
321 
322 
323 // File @openzeppelin/contracts/GSN/Context.sol@v3.0.1
324 
325 pragma solidity ^0.6.0;
326 
327 /*
328  * @dev Provides information about the current execution context, including the
329  * sender of the transaction and its data. While these are generally available
330  * via msg.sender and msg.data, they should not be accessed in such a direct
331  * manner, since when dealing with GSN meta-transactions the account sending and
332  * paying for execution may not be the actual sender (as far as an application
333  * is concerned).
334  *
335  * This contract is only required for intermediate, library-like contracts.
336  */
337 contract Context {
338     // Empty internal constructor, to prevent people from mistakenly deploying
339     // an instance of this contract, which should be used via inheritance.
340     constructor () internal { }
341 
342     function _msgSender() internal view virtual returns (address payable) {
343         return msg.sender;
344     }
345 
346     function _msgData() internal view virtual returns (bytes memory) {
347         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
348         return msg.data;
349     }
350 }
351 
352 
353 // File @openzeppelin/contracts/access/AccessControl.sol@v3.0.1
354 
355 pragma solidity ^0.6.0;
356 
357 
358 
359 /**
360  * @dev Contract module that allows children to implement role-based access
361  * control mechanisms.
362  *
363  * Roles are referred to by their `bytes32` identifier. These should be exposed
364  * in the external API and be unique. The best way to achieve this is by
365  * using `public constant` hash digests:
366  *
367  * ```
368  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
369  * ```
370  *
371  * Roles can be used to represent a set of permissions. To restrict access to a
372  * function call, use {hasRole}:
373  *
374  * ```
375  * function foo() public {
376  *     require(hasRole(MY_ROLE, msg.sender));
377  *     ...
378  * }
379  * ```
380  *
381  * Roles can be granted and revoked dynamically via the {grantRole} and
382  * {revokeRole} functions. Each role has an associated admin role, and only
383  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
384  *
385  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
386  * that only accounts with this role will be able to grant or revoke other
387  * roles. More complex role relationships can be created by using
388  * {_setRoleAdmin}.
389  *
390  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
391  * grant and revoke this role. Extra precautions should be taken to secure
392  * accounts that have been granted it.
393  */
394 abstract contract AccessControl is Context {
395     using EnumerableSet for EnumerableSet.AddressSet;
396     using Address for address;
397 
398     struct RoleData {
399         EnumerableSet.AddressSet members;
400         bytes32 adminRole;
401     }
402 
403     mapping (bytes32 => RoleData) private _roles;
404 
405     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
406 
407     /**
408      * @dev Emitted when `account` is granted `role`.
409      *
410      * `sender` is the account that originated the contract call, an admin role
411      * bearer except when using {_setupRole}.
412      */
413     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
414 
415     /**
416      * @dev Emitted when `account` is revoked `role`.
417      *
418      * `sender` is the account that originated the contract call:
419      *   - if using `revokeRole`, it is the admin role bearer
420      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
421      */
422     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
423 
424     /**
425      * @dev Returns `true` if `account` has been granted `role`.
426      */
427     function hasRole(bytes32 role, address account) public view returns (bool) {
428         return _roles[role].members.contains(account);
429     }
430 
431     /**
432      * @dev Returns the number of accounts that have `role`. Can be used
433      * together with {getRoleMember} to enumerate all bearers of a role.
434      */
435     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
436         return _roles[role].members.length();
437     }
438 
439     /**
440      * @dev Returns one of the accounts that have `role`. `index` must be a
441      * value between 0 and {getRoleMemberCount}, non-inclusive.
442      *
443      * Role bearers are not sorted in any particular way, and their ordering may
444      * change at any point.
445      *
446      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
447      * you perform all queries on the same block. See the following
448      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
449      * for more information.
450      */
451     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
452         return _roles[role].members.at(index);
453     }
454 
455     /**
456      * @dev Returns the admin role that controls `role`. See {grantRole} and
457      * {revokeRole}.
458      *
459      * To change a role's admin, use {_setRoleAdmin}.
460      */
461     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
462         return _roles[role].adminRole;
463     }
464 
465     /**
466      * @dev Grants `role` to `account`.
467      *
468      * If `account` had not been already granted `role`, emits a {RoleGranted}
469      * event.
470      *
471      * Requirements:
472      *
473      * - the caller must have ``role``'s admin role.
474      */
475     function grantRole(bytes32 role, address account) public virtual {
476         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
477 
478         _grantRole(role, account);
479     }
480 
481     /**
482      * @dev Revokes `role` from `account`.
483      *
484      * If `account` had been granted `role`, emits a {RoleRevoked} event.
485      *
486      * Requirements:
487      *
488      * - the caller must have ``role``'s admin role.
489      */
490     function revokeRole(bytes32 role, address account) public virtual {
491         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
492 
493         _revokeRole(role, account);
494     }
495 
496     /**
497      * @dev Revokes `role` from the calling account.
498      *
499      * Roles are often managed via {grantRole} and {revokeRole}: this function's
500      * purpose is to provide a mechanism for accounts to lose their privileges
501      * if they are compromised (such as when a trusted device is misplaced).
502      *
503      * If the calling account had been granted `role`, emits a {RoleRevoked}
504      * event.
505      *
506      * Requirements:
507      *
508      * - the caller must be `account`.
509      */
510     function renounceRole(bytes32 role, address account) public virtual {
511         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
512 
513         _revokeRole(role, account);
514     }
515 
516     /**
517      * @dev Grants `role` to `account`.
518      *
519      * If `account` had not been already granted `role`, emits a {RoleGranted}
520      * event. Note that unlike {grantRole}, this function doesn't perform any
521      * checks on the calling account.
522      *
523      * [WARNING]
524      * ====
525      * This function should only be called from the constructor when setting
526      * up the initial roles for the system.
527      *
528      * Using this function in any other way is effectively circumventing the admin
529      * system imposed by {AccessControl}.
530      * ====
531      */
532     function _setupRole(bytes32 role, address account) internal virtual {
533         _grantRole(role, account);
534     }
535 
536     /**
537      * @dev Sets `adminRole` as ``role``'s admin role.
538      */
539     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
540         _roles[role].adminRole = adminRole;
541     }
542 
543     function _grantRole(bytes32 role, address account) private {
544         if (_roles[role].members.add(account)) {
545             emit RoleGranted(role, account, _msgSender());
546         }
547     }
548 
549     function _revokeRole(bytes32 role, address account) private {
550         if (_roles[role].members.remove(account)) {
551             emit RoleRevoked(role, account, _msgSender());
552         }
553     }
554 }
555 
556 
557 // File @openzeppelin/contracts/token/ERC777/IERC777.sol@v3.0.1
558 
559 pragma solidity ^0.6.0;
560 
561 /**
562  * @dev Interface of the ERC777Token standard as defined in the EIP.
563  *
564  * This contract uses the
565  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
566  * token holders and recipients react to token movements by using setting implementers
567  * for the associated interfaces in said registry. See {IERC1820Registry} and
568  * {ERC1820Implementer}.
569  */
570 interface IERC777 {
571     /**
572      * @dev Returns the name of the token.
573      */
574     function name() external view returns (string memory);
575 
576     /**
577      * @dev Returns the symbol of the token, usually a shorter version of the
578      * name.
579      */
580     function symbol() external view returns (string memory);
581 
582     /**
583      * @dev Returns the smallest part of the token that is not divisible. This
584      * means all token operations (creation, movement and destruction) must have
585      * amounts that are a multiple of this number.
586      *
587      * For most token contracts, this value will equal 1.
588      */
589     function granularity() external view returns (uint256);
590 
591     /**
592      * @dev Returns the amount of tokens in existence.
593      */
594     function totalSupply() external view returns (uint256);
595 
596     /**
597      * @dev Returns the amount of tokens owned by an account (`owner`).
598      */
599     function balanceOf(address owner) external view returns (uint256);
600 
601     /**
602      * @dev Moves `amount` tokens from the caller's account to `recipient`.
603      *
604      * If send or receive hooks are registered for the caller and `recipient`,
605      * the corresponding functions will be called with `data` and empty
606      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
607      *
608      * Emits a {Sent} event.
609      *
610      * Requirements
611      *
612      * - the caller must have at least `amount` tokens.
613      * - `recipient` cannot be the zero address.
614      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
615      * interface.
616      */
617     function send(address recipient, uint256 amount, bytes calldata data) external;
618 
619     /**
620      * @dev Destroys `amount` tokens from the caller's account, reducing the
621      * total supply.
622      *
623      * If a send hook is registered for the caller, the corresponding function
624      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
625      *
626      * Emits a {Burned} event.
627      *
628      * Requirements
629      *
630      * - the caller must have at least `amount` tokens.
631      */
632     function burn(uint256 amount, bytes calldata data) external;
633 
634     /**
635      * @dev Returns true if an account is an operator of `tokenHolder`.
636      * Operators can send and burn tokens on behalf of their owners. All
637      * accounts are their own operator.
638      *
639      * See {operatorSend} and {operatorBurn}.
640      */
641     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
642 
643     /**
644      * @dev Make an account an operator of the caller.
645      *
646      * See {isOperatorFor}.
647      *
648      * Emits an {AuthorizedOperator} event.
649      *
650      * Requirements
651      *
652      * - `operator` cannot be calling address.
653      */
654     function authorizeOperator(address operator) external;
655 
656     /**
657      * @dev Revoke an account's operator status for the caller.
658      *
659      * See {isOperatorFor} and {defaultOperators}.
660      *
661      * Emits a {RevokedOperator} event.
662      *
663      * Requirements
664      *
665      * - `operator` cannot be calling address.
666      */
667     function revokeOperator(address operator) external;
668 
669     /**
670      * @dev Returns the list of default operators. These accounts are operators
671      * for all token holders, even if {authorizeOperator} was never called on
672      * them.
673      *
674      * This list is immutable, but individual holders may revoke these via
675      * {revokeOperator}, in which case {isOperatorFor} will return false.
676      */
677     function defaultOperators() external view returns (address[] memory);
678 
679     /**
680      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
681      * be an operator of `sender`.
682      *
683      * If send or receive hooks are registered for `sender` and `recipient`,
684      * the corresponding functions will be called with `data` and
685      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
686      *
687      * Emits a {Sent} event.
688      *
689      * Requirements
690      *
691      * - `sender` cannot be the zero address.
692      * - `sender` must have at least `amount` tokens.
693      * - the caller must be an operator for `sender`.
694      * - `recipient` cannot be the zero address.
695      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
696      * interface.
697      */
698     function operatorSend(
699         address sender,
700         address recipient,
701         uint256 amount,
702         bytes calldata data,
703         bytes calldata operatorData
704     ) external;
705 
706     /**
707      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
708      * The caller must be an operator of `account`.
709      *
710      * If a send hook is registered for `account`, the corresponding function
711      * will be called with `data` and `operatorData`. See {IERC777Sender}.
712      *
713      * Emits a {Burned} event.
714      *
715      * Requirements
716      *
717      * - `account` cannot be the zero address.
718      * - `account` must have at least `amount` tokens.
719      * - the caller must be an operator for `account`.
720      */
721     function operatorBurn(
722         address account,
723         uint256 amount,
724         bytes calldata data,
725         bytes calldata operatorData
726     ) external;
727 
728     event Sent(
729         address indexed operator,
730         address indexed from,
731         address indexed to,
732         uint256 amount,
733         bytes data,
734         bytes operatorData
735     );
736 
737     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
738 
739     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
740 
741     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
742 
743     event RevokedOperator(address indexed operator, address indexed tokenHolder);
744 }
745 
746 
747 // File @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol@v3.0.1
748 
749 pragma solidity ^0.6.0;
750 
751 /**
752  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
753  *
754  * Accounts can be notified of {IERC777} tokens being sent to them by having a
755  * contract implement this interface (contract holders can be their own
756  * implementer) and registering it on the
757  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
758  *
759  * See {IERC1820Registry} and {ERC1820Implementer}.
760  */
761 interface IERC777Recipient {
762     /**
763      * @dev Called by an {IERC777} token contract whenever tokens are being
764      * moved or created into a registered account (`to`). The type of operation
765      * is conveyed by `from` being the zero address or not.
766      *
767      * This call occurs _after_ the token contract's state is updated, so
768      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
769      *
770      * This function may revert to prevent the operation from being executed.
771      */
772     function tokensReceived(
773         address operator,
774         address from,
775         address to,
776         uint256 amount,
777         bytes calldata userData,
778         bytes calldata operatorData
779     ) external;
780 }
781 
782 
783 // File @openzeppelin/contracts/token/ERC777/IERC777Sender.sol@v3.0.1
784 
785 pragma solidity ^0.6.0;
786 
787 /**
788  * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
789  *
790  * {IERC777} Token holders can be notified of operations performed on their
791  * tokens by having a contract implement this interface (contract holders can be
792  *  their own implementer) and registering it on the
793  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
794  *
795  * See {IERC1820Registry} and {ERC1820Implementer}.
796  */
797 interface IERC777Sender {
798     /**
799      * @dev Called by an {IERC777} token contract whenever a registered holder's
800      * (`from`) tokens are about to be moved or destroyed. The type of operation
801      * is conveyed by `to` being the zero address or not.
802      *
803      * This call occurs _before_ the token contract's state is updated, so
804      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
805      *
806      * This function may revert to prevent the operation from being executed.
807      */
808     function tokensToSend(
809         address operator,
810         address from,
811         address to,
812         uint256 amount,
813         bytes calldata userData,
814         bytes calldata operatorData
815     ) external;
816 }
817 
818 
819 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.0.1
820 
821 pragma solidity ^0.6.0;
822 
823 /**
824  * @dev Interface of the ERC20 standard as defined in the EIP.
825  */
826 interface IERC20 {
827     /**
828      * @dev Returns the amount of tokens in existence.
829      */
830     function totalSupply() external view returns (uint256);
831 
832     /**
833      * @dev Returns the amount of tokens owned by `account`.
834      */
835     function balanceOf(address account) external view returns (uint256);
836 
837     /**
838      * @dev Moves `amount` tokens from the caller's account to `recipient`.
839      *
840      * Returns a boolean value indicating whether the operation succeeded.
841      *
842      * Emits a {Transfer} event.
843      */
844     function transfer(address recipient, uint256 amount) external returns (bool);
845 
846     /**
847      * @dev Returns the remaining number of tokens that `spender` will be
848      * allowed to spend on behalf of `owner` through {transferFrom}. This is
849      * zero by default.
850      *
851      * This value changes when {approve} or {transferFrom} are called.
852      */
853     function allowance(address owner, address spender) external view returns (uint256);
854 
855     /**
856      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
857      *
858      * Returns a boolean value indicating whether the operation succeeded.
859      *
860      * IMPORTANT: Beware that changing an allowance with this method brings the risk
861      * that someone may use both the old and the new allowance by unfortunate
862      * transaction ordering. One possible solution to mitigate this race
863      * condition is to first reduce the spender's allowance to 0 and set the
864      * desired value afterwards:
865      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
866      *
867      * Emits an {Approval} event.
868      */
869     function approve(address spender, uint256 amount) external returns (bool);
870 
871     /**
872      * @dev Moves `amount` tokens from `sender` to `recipient` using the
873      * allowance mechanism. `amount` is then deducted from the caller's
874      * allowance.
875      *
876      * Returns a boolean value indicating whether the operation succeeded.
877      *
878      * Emits a {Transfer} event.
879      */
880     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
881 
882     /**
883      * @dev Emitted when `value` tokens are moved from one account (`from`) to
884      * another (`to`).
885      *
886      * Note that `value` may be zero.
887      */
888     event Transfer(address indexed from, address indexed to, uint256 value);
889 
890     /**
891      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
892      * a call to {approve}. `value` is the new allowance.
893      */
894     event Approval(address indexed owner, address indexed spender, uint256 value);
895 }
896 
897 
898 // File @openzeppelin/contracts/math/SafeMath.sol@v3.0.1
899 
900 pragma solidity ^0.6.0;
901 
902 /**
903  * @dev Wrappers over Solidity's arithmetic operations with added overflow
904  * checks.
905  *
906  * Arithmetic operations in Solidity wrap on overflow. This can easily result
907  * in bugs, because programmers usually assume that an overflow raises an
908  * error, which is the standard behavior in high level programming languages.
909  * `SafeMath` restores this intuition by reverting the transaction when an
910  * operation overflows.
911  *
912  * Using this library instead of the unchecked operations eliminates an entire
913  * class of bugs, so it's recommended to use it always.
914  */
915 library SafeMath {
916     /**
917      * @dev Returns the addition of two unsigned integers, reverting on
918      * overflow.
919      *
920      * Counterpart to Solidity's `+` operator.
921      *
922      * Requirements:
923      * - Addition cannot overflow.
924      */
925     function add(uint256 a, uint256 b) internal pure returns (uint256) {
926         uint256 c = a + b;
927         require(c >= a, "SafeMath: addition overflow");
928 
929         return c;
930     }
931 
932     /**
933      * @dev Returns the subtraction of two unsigned integers, reverting on
934      * overflow (when the result is negative).
935      *
936      * Counterpart to Solidity's `-` operator.
937      *
938      * Requirements:
939      * - Subtraction cannot overflow.
940      */
941     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
942         return sub(a, b, "SafeMath: subtraction overflow");
943     }
944 
945     /**
946      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
947      * overflow (when the result is negative).
948      *
949      * Counterpart to Solidity's `-` operator.
950      *
951      * Requirements:
952      * - Subtraction cannot overflow.
953      */
954     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
955         require(b <= a, errorMessage);
956         uint256 c = a - b;
957 
958         return c;
959     }
960 
961     /**
962      * @dev Returns the multiplication of two unsigned integers, reverting on
963      * overflow.
964      *
965      * Counterpart to Solidity's `*` operator.
966      *
967      * Requirements:
968      * - Multiplication cannot overflow.
969      */
970     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
971         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
972         // benefit is lost if 'b' is also tested.
973         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
974         if (a == 0) {
975             return 0;
976         }
977 
978         uint256 c = a * b;
979         require(c / a == b, "SafeMath: multiplication overflow");
980 
981         return c;
982     }
983 
984     /**
985      * @dev Returns the integer division of two unsigned integers. Reverts on
986      * division by zero. The result is rounded towards zero.
987      *
988      * Counterpart to Solidity's `/` operator. Note: this function uses a
989      * `revert` opcode (which leaves remaining gas untouched) while Solidity
990      * uses an invalid opcode to revert (consuming all remaining gas).
991      *
992      * Requirements:
993      * - The divisor cannot be zero.
994      */
995     function div(uint256 a, uint256 b) internal pure returns (uint256) {
996         return div(a, b, "SafeMath: division by zero");
997     }
998 
999     /**
1000      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1001      * division by zero. The result is rounded towards zero.
1002      *
1003      * Counterpart to Solidity's `/` operator. Note: this function uses a
1004      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1005      * uses an invalid opcode to revert (consuming all remaining gas).
1006      *
1007      * Requirements:
1008      * - The divisor cannot be zero.
1009      */
1010     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1011         // Solidity only automatically asserts when dividing by 0
1012         require(b > 0, errorMessage);
1013         uint256 c = a / b;
1014         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1015 
1016         return c;
1017     }
1018 
1019     /**
1020      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1021      * Reverts when dividing by zero.
1022      *
1023      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1024      * opcode (which leaves remaining gas untouched) while Solidity uses an
1025      * invalid opcode to revert (consuming all remaining gas).
1026      *
1027      * Requirements:
1028      * - The divisor cannot be zero.
1029      */
1030     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1031         return mod(a, b, "SafeMath: modulo by zero");
1032     }
1033 
1034     /**
1035      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1036      * Reverts with custom message when dividing by zero.
1037      *
1038      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1039      * opcode (which leaves remaining gas untouched) while Solidity uses an
1040      * invalid opcode to revert (consuming all remaining gas).
1041      *
1042      * Requirements:
1043      * - The divisor cannot be zero.
1044      */
1045     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1046         require(b != 0, errorMessage);
1047         return a % b;
1048     }
1049 }
1050 
1051 
1052 // File @openzeppelin/contracts/introspection/IERC1820Registry.sol@v3.0.1
1053 
1054 pragma solidity ^0.6.0;
1055 
1056 /**
1057  * @dev Interface of the global ERC1820 Registry, as defined in the
1058  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
1059  * implementers for interfaces in this registry, as well as query support.
1060  *
1061  * Implementers may be shared by multiple accounts, and can also implement more
1062  * than a single interface for each account. Contracts can implement interfaces
1063  * for themselves, but externally-owned accounts (EOA) must delegate this to a
1064  * contract.
1065  *
1066  * {IERC165} interfaces can also be queried via the registry.
1067  *
1068  * For an in-depth explanation and source code analysis, see the EIP text.
1069  */
1070 interface IERC1820Registry {
1071     /**
1072      * @dev Sets `newManager` as the manager for `account`. A manager of an
1073      * account is able to set interface implementers for it.
1074      *
1075      * By default, each account is its own manager. Passing a value of `0x0` in
1076      * `newManager` will reset the manager to this initial state.
1077      *
1078      * Emits a {ManagerChanged} event.
1079      *
1080      * Requirements:
1081      *
1082      * - the caller must be the current manager for `account`.
1083      */
1084     function setManager(address account, address newManager) external;
1085 
1086     /**
1087      * @dev Returns the manager for `account`.
1088      *
1089      * See {setManager}.
1090      */
1091     function getManager(address account) external view returns (address);
1092 
1093     /**
1094      * @dev Sets the `implementer` contract as ``account``'s implementer for
1095      * `interfaceHash`.
1096      *
1097      * `account` being the zero address is an alias for the caller's address.
1098      * The zero address can also be used in `implementer` to remove an old one.
1099      *
1100      * See {interfaceHash} to learn how these are created.
1101      *
1102      * Emits an {InterfaceImplementerSet} event.
1103      *
1104      * Requirements:
1105      *
1106      * - the caller must be the current manager for `account`.
1107      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
1108      * end in 28 zeroes).
1109      * - `implementer` must implement {IERC1820Implementer} and return true when
1110      * queried for support, unless `implementer` is the caller. See
1111      * {IERC1820Implementer-canImplementInterfaceForAddress}.
1112      */
1113     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
1114 
1115     /**
1116      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
1117      * implementer is registered, returns the zero address.
1118      *
1119      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
1120      * zeroes), `account` will be queried for support of it.
1121      *
1122      * `account` being the zero address is an alias for the caller's address.
1123      */
1124     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
1125 
1126     /**
1127      * @dev Returns the interface hash for an `interfaceName`, as defined in the
1128      * corresponding
1129      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
1130      */
1131     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
1132 
1133     /**
1134      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
1135      *  @param account Address of the contract for which to update the cache.
1136      *  @param interfaceId ERC165 interface for which to update the cache.
1137      */
1138     function updateERC165Cache(address account, bytes4 interfaceId) external;
1139 
1140     /**
1141      *  @notice Checks whether a contract implements an ERC165 interface or not.
1142      *  If the result is not cached a direct lookup on the contract address is performed.
1143      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
1144      *  {updateERC165Cache} with the contract address.
1145      *  @param account Address of the contract to check.
1146      *  @param interfaceId ERC165 interface to check.
1147      *  @return True if `account` implements `interfaceId`, false otherwise.
1148      */
1149     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
1150 
1151     /**
1152      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
1153      *  @param account Address of the contract to check.
1154      *  @param interfaceId ERC165 interface to check.
1155      *  @return True if `account` implements `interfaceId`, false otherwise.
1156      */
1157     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
1158 
1159     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
1160 
1161     event ManagerChanged(address indexed account, address indexed newManager);
1162 }
1163 
1164 
1165 // File contracts/openzeppelin-contracts/ERC777.sol
1166 
1167 // SPDX-License-Identifier: MIT
1168 
1169 pragma solidity >=0.6.0 <0.8.0;
1170 
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 /**
1179  * @dev Implementation of the {IERC777} interface.
1180  *
1181  * This implementation is agnostic to the way tokens are created. This means
1182  * that a supply mechanism has to be added in a derived contract using {_mint}.
1183  *
1184  * Support for ERC20 is included in this contract, as specified by the EIP: both
1185  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
1186  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
1187  * movements.
1188  *
1189  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
1190  * are no special restrictions in the amount of tokens that created, moved, or
1191  * destroyed. This makes integration with ERC20 applications seamless.
1192  */
1193 contract ERC777 is Context, IERC777, IERC20 {
1194     using SafeMath for uint256;
1195     using Address for address;
1196 
1197     IERC1820Registry constant internal _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
1198 
1199     mapping(address => uint256) private _balances;
1200 
1201     uint256 private _totalSupply;
1202 
1203     string private _name;
1204     string private _symbol;
1205 
1206     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
1207     // See https://github.com/ethereum/solidity/issues/4024.
1208 
1209     // keccak256("ERC777TokensSender")
1210     bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH =
1211         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
1212 
1213     // keccak256("ERC777TokensRecipient")
1214     bytes32 constant private _TOKENS_RECIPIENT_INTERFACE_HASH =
1215         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
1216 
1217     // This isn't ever read from - it's only used to respond to the defaultOperators query.
1218     address[] private _defaultOperatorsArray;
1219 
1220     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
1221     mapping(address => bool) private _defaultOperators;
1222 
1223     // For each account, a mapping of its operators and revoked default operators.
1224     mapping(address => mapping(address => bool)) private _operators;
1225     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
1226 
1227     // ERC20-allowances
1228     mapping (address => mapping (address => uint256)) private _allowances;
1229 
1230     /**
1231      * @dev `defaultOperators` may be an empty array.
1232      */
1233     constructor(
1234         string memory name_,
1235         string memory symbol_,
1236         address[] memory defaultOperators_
1237     )
1238         public
1239     {
1240         _name = name_;
1241         _symbol = symbol_;
1242 
1243         _defaultOperatorsArray = defaultOperators_;
1244         for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
1245             _defaultOperators[_defaultOperatorsArray[i]] = true;
1246         }
1247 
1248         // register interfaces
1249         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
1250         _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
1251     }
1252 
1253     /**
1254      * @dev See {IERC777-name}.
1255      */
1256     function name() public view override returns (string memory) {
1257         return _name;
1258     }
1259 
1260     /**
1261      * @dev See {IERC777-symbol}.
1262      */
1263     function symbol() public view override returns (string memory) {
1264         return _symbol;
1265     }
1266 
1267     /**
1268      * @dev See {ERC20-decimals}.
1269      *
1270      * Always returns 18, as per the
1271      * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
1272      */
1273     function decimals() public pure returns (uint8) {
1274         return 18;
1275     }
1276 
1277     /**
1278      * @dev See {IERC777-granularity}.
1279      *
1280      * This implementation always returns `1`.
1281      */
1282     function granularity() public view override returns (uint256) {
1283         return 1;
1284     }
1285 
1286     /**
1287      * @dev See {IERC777-totalSupply}.
1288      */
1289     function totalSupply() public view override(IERC20, IERC777) returns (uint256) {
1290         return _totalSupply;
1291     }
1292 
1293     /**
1294      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
1295      */
1296     function balanceOf(address tokenHolder) public view override(IERC20, IERC777) returns (uint256) {
1297         return _balances[tokenHolder];
1298     }
1299 
1300     /**
1301      * @dev See {IERC777-send}.
1302      *
1303      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
1304      */
1305     function send(address recipient, uint256 amount, bytes memory data) public virtual override  {
1306         _send(_msgSender(), recipient, amount, data, "", true);
1307     }
1308 
1309     /**
1310      * @dev See {IERC20-transfer}.
1311      *
1312      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
1313      * interface if it is a contract.
1314      *
1315      * Also emits a {Sent} event.
1316      */
1317     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1318         require(recipient != address(0), "ERC777: transfer to the zero address");
1319 
1320         address from = _msgSender();
1321 
1322         _callTokensToSend(from, from, recipient, amount, "", "");
1323 
1324         _move(from, from, recipient, amount, "", "");
1325 
1326         _callTokensReceived(from, from, recipient, amount, "", "", false);
1327 
1328         return true;
1329     }
1330 
1331     /**
1332      * @dev See {IERC777-burn}.
1333      *
1334      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
1335      */
1336     function burn(uint256 amount, bytes memory data) public virtual override  {
1337         _burn(_msgSender(), amount, data, "");
1338     }
1339 
1340     /**
1341      * @dev See {IERC777-isOperatorFor}.
1342      */
1343     function isOperatorFor(address operator, address tokenHolder) public view override returns (bool) {
1344         return operator == tokenHolder ||
1345             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
1346             _operators[tokenHolder][operator];
1347     }
1348 
1349     /**
1350      * @dev See {IERC777-authorizeOperator}.
1351      */
1352     function authorizeOperator(address operator) public virtual override  {
1353         require(_msgSender() != operator, "ERC777: authorizing self as operator");
1354 
1355         if (_defaultOperators[operator]) {
1356             delete _revokedDefaultOperators[_msgSender()][operator];
1357         } else {
1358             _operators[_msgSender()][operator] = true;
1359         }
1360 
1361         emit AuthorizedOperator(operator, _msgSender());
1362     }
1363 
1364     /**
1365      * @dev See {IERC777-revokeOperator}.
1366      */
1367     function revokeOperator(address operator) public virtual override  {
1368         require(operator != _msgSender(), "ERC777: revoking self as operator");
1369 
1370         if (_defaultOperators[operator]) {
1371             _revokedDefaultOperators[_msgSender()][operator] = true;
1372         } else {
1373             delete _operators[_msgSender()][operator];
1374         }
1375 
1376         emit RevokedOperator(operator, _msgSender());
1377     }
1378 
1379     /**
1380      * @dev See {IERC777-defaultOperators}.
1381      */
1382     function defaultOperators() public view override returns (address[] memory) {
1383         return _defaultOperatorsArray;
1384     }
1385 
1386     /**
1387      * @dev See {IERC777-operatorSend}.
1388      *
1389      * Emits {Sent} and {IERC20-Transfer} events.
1390      */
1391     function operatorSend(
1392         address sender,
1393         address recipient,
1394         uint256 amount,
1395         bytes memory data,
1396         bytes memory operatorData
1397     )
1398         public
1399         virtual
1400         override
1401     {
1402         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
1403         _send(sender, recipient, amount, data, operatorData, true);
1404     }
1405 
1406     /**
1407      * @dev See {IERC777-operatorBurn}.
1408      *
1409      * Emits {Burned} and {IERC20-Transfer} events.
1410      */
1411     function operatorBurn(address account, uint256 amount, bytes memory data, bytes memory operatorData) public virtual override {
1412         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
1413         _burn(account, amount, data, operatorData);
1414     }
1415 
1416     /**
1417      * @dev See {IERC20-allowance}.
1418      *
1419      * Note that operator and allowance concepts are orthogonal: operators may
1420      * not have allowance, and accounts with allowance may not be operators
1421      * themselves.
1422      */
1423     function allowance(address holder, address spender) public view override returns (uint256) {
1424         return _allowances[holder][spender];
1425     }
1426 
1427     /**
1428      * @dev See {IERC20-approve}.
1429      *
1430      * Note that accounts cannot have allowance issued by their operators.
1431      */
1432     function approve(address spender, uint256 value) public virtual override returns (bool) {
1433         address holder = _msgSender();
1434         _approve(holder, spender, value);
1435         return true;
1436     }
1437 
1438    /**
1439     * @dev See {IERC20-transferFrom}.
1440     *
1441     * Note that operator and allowance concepts are orthogonal: operators cannot
1442     * call `transferFrom` (unless they have allowance), and accounts with
1443     * allowance cannot call `operatorSend` (unless they are operators).
1444     *
1445     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
1446     */
1447     function transferFrom(address holder, address recipient, uint256 amount) public virtual override returns (bool) {
1448         require(recipient != address(0), "ERC777: transfer to the zero address");
1449         require(holder != address(0), "ERC777: transfer from the zero address");
1450 
1451         address spender = _msgSender();
1452 
1453         _callTokensToSend(spender, holder, recipient, amount, "", "");
1454 
1455         _move(spender, holder, recipient, amount, "", "");
1456         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
1457 
1458         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
1459 
1460         return true;
1461     }
1462 
1463     /**
1464      * @dev Creates `amount` tokens and assigns them to `account`, increasing
1465      * the total supply.
1466      *
1467      * If a send hook is registered for `account`, the corresponding function
1468      * will be called with `operator`, `data` and `operatorData`.
1469      *
1470      * See {IERC777Sender} and {IERC777Recipient}.
1471      *
1472      * Emits {Minted} and {IERC20-Transfer} events.
1473      *
1474      * Requirements
1475      *
1476      * - `account` cannot be the zero address.
1477      * - if `account` is a contract, it must implement the {IERC777Recipient}
1478      * interface.
1479      */
1480     function _mint(
1481         address account,
1482         uint256 amount,
1483         bytes memory userData,
1484         bytes memory operatorData
1485     )
1486         internal
1487         virtual
1488     {
1489         require(account != address(0), "ERC777: mint to the zero address");
1490 
1491         address operator = _msgSender();
1492 
1493         _beforeTokenTransfer(operator, address(0), account, amount);
1494 
1495         // Update state variables
1496         _totalSupply = _totalSupply.add(amount);
1497         _balances[account] = _balances[account].add(amount);
1498 
1499         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
1500 
1501         emit Minted(operator, account, amount, userData, operatorData);
1502         emit Transfer(address(0), account, amount);
1503     }
1504 
1505     /**
1506      * @dev Send tokens
1507      * @param from address token holder address
1508      * @param to address recipient address
1509      * @param amount uint256 amount of tokens to transfer
1510      * @param userData bytes extra information provided by the token holder (if any)
1511      * @param operatorData bytes extra information provided by the operator (if any)
1512      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1513      */
1514     function _send(
1515         address from,
1516         address to,
1517         uint256 amount,
1518         bytes memory userData,
1519         bytes memory operatorData,
1520         bool requireReceptionAck
1521     )
1522         internal
1523         virtual
1524     {
1525         require(from != address(0), "ERC777: send from the zero address");
1526         require(to != address(0), "ERC777: send to the zero address");
1527 
1528         address operator = _msgSender();
1529 
1530         _callTokensToSend(operator, from, to, amount, userData, operatorData);
1531 
1532         _move(operator, from, to, amount, userData, operatorData);
1533 
1534         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
1535     }
1536 
1537     /**
1538      * @dev Burn tokens
1539      * @param from address token holder address
1540      * @param amount uint256 amount of tokens to burn
1541      * @param data bytes extra information provided by the token holder
1542      * @param operatorData bytes extra information provided by the operator (if any)
1543      */
1544     function _burn(
1545         address from,
1546         uint256 amount,
1547         bytes memory data,
1548         bytes memory operatorData
1549     )
1550         internal
1551         virtual
1552     {
1553         require(from != address(0), "ERC777: burn from the zero address");
1554 
1555         address operator = _msgSender();
1556 
1557         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
1558 
1559         _beforeTokenTransfer(operator, from, address(0), amount);
1560 
1561         // Update state variables
1562         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
1563         _totalSupply = _totalSupply.sub(amount);
1564 
1565         emit Burned(operator, from, amount, data, operatorData);
1566         emit Transfer(from, address(0), amount);
1567     }
1568 
1569     function _move(
1570         address operator,
1571         address from,
1572         address to,
1573         uint256 amount,
1574         bytes memory userData,
1575         bytes memory operatorData
1576     )
1577         private
1578     {
1579         _beforeTokenTransfer(operator, from, to, amount);
1580 
1581         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
1582         _balances[to] = _balances[to].add(amount);
1583 
1584         emit Sent(operator, from, to, amount, userData, operatorData);
1585         emit Transfer(from, to, amount);
1586     }
1587 
1588     /**
1589      * @dev See {ERC20-_approve}.
1590      *
1591      * Note that accounts cannot have allowance issued by their operators.
1592      */
1593     function _approve(address holder, address spender, uint256 value) internal {
1594         require(holder != address(0), "ERC777: approve from the zero address");
1595         require(spender != address(0), "ERC777: approve to the zero address");
1596 
1597         _allowances[holder][spender] = value;
1598         emit Approval(holder, spender, value);
1599     }
1600 
1601     /**
1602      * @dev Call from.tokensToSend() if the interface is registered
1603      * @param operator address operator requesting the transfer
1604      * @param from address token holder address
1605      * @param to address recipient address
1606      * @param amount uint256 amount of tokens to transfer
1607      * @param userData bytes extra information provided by the token holder (if any)
1608      * @param operatorData bytes extra information provided by the operator (if any)
1609      */
1610     function _callTokensToSend(
1611         address operator,
1612         address from,
1613         address to,
1614         uint256 amount,
1615         bytes memory userData,
1616         bytes memory operatorData
1617     )
1618         private
1619     {
1620         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(from, _TOKENS_SENDER_INTERFACE_HASH);
1621         if (implementer != address(0)) {
1622             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
1623         }
1624     }
1625 
1626     /**
1627      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
1628      * tokensReceived() was not registered for the recipient
1629      * @param operator address operator requesting the transfer
1630      * @param from address token holder address
1631      * @param to address recipient address
1632      * @param amount uint256 amount of tokens to transfer
1633      * @param userData bytes extra information provided by the token holder (if any)
1634      * @param operatorData bytes extra information provided by the operator (if any)
1635      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
1636      */
1637     function _callTokensReceived(
1638         address operator,
1639         address from,
1640         address to,
1641         uint256 amount,
1642         bytes memory userData,
1643         bytes memory operatorData,
1644         bool requireReceptionAck
1645     )
1646         private
1647     {
1648         address implementer = _ERC1820_REGISTRY.getInterfaceImplementer(to, _TOKENS_RECIPIENT_INTERFACE_HASH);
1649         if (implementer != address(0)) {
1650             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
1651         } else if (requireReceptionAck) {
1652             require(!to.isContract(), "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
1653         }
1654     }
1655 
1656     /**
1657      * @dev Hook that is called before any token transfer. This includes
1658      * calls to {send}, {transfer}, {operatorSend}, minting and burning.
1659      *
1660      * Calling conditions:
1661      *
1662      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1663      * will be to transferred to `to`.
1664      * - when `from` is zero, `amount` tokens will be minted for `to`.
1665      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1666      * - `from` and `to` are never both zero.
1667      *
1668      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1669      */
1670     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual { }
1671 }
1672 
1673 
1674 // File contracts/ERC777/ERC777Snapshot.sol
1675 
1676 // SPDX-License-Identifier: GPL-3.0
1677 pragma solidity ^0.6.0;
1678 
1679 
1680 /**
1681  * @dev This contract extends an ERC777 token with a snapshot mechanism. When a snapshot is created, the balances and
1682  * total supply at the time are recorded for later access.
1683  *
1684  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1685  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1686  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1687  * used to create an efficient ERC20 forking mechanism.
1688  *
1689  * Snapshots are created by the internal {updateValueAtNow} function.
1690  * To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with a block number.
1691  * To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with a block number
1692  * and the account address.
1693  */
1694 abstract contract ERC777Snapshot is ERC777 {
1695     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1696     // https://github.com/Giveth/minime/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1697 
1698     using SafeMath for uint256;
1699 
1700     /**
1701      * @dev `Snapshot` is the structure that attaches a block number to a
1702      * given value, the block number attached is the one that last changed the
1703      * value
1704      */
1705     struct Snapshot {
1706         // `fromBlock` is the block number that the value was generated from
1707         uint128 fromBlock;
1708         // `value` is the amount of tokens at a specific block number
1709         uint128 value;
1710     }
1711 
1712     // `accountSnapshots` is the map that tracks the balance of each address, in this
1713     //  contract when the balance changes the block number that the change
1714     //  occurred is also included in the map
1715     mapping (address => Snapshot[]) public accountSnapshots;
1716 
1717     // Tracks the history of the `totalSupply` of the token
1718     Snapshot[] public totalSupplySnapshots;
1719 
1720     /**
1721      * @dev Queries the balance of `_owner` at a specific `_blockNumber`
1722      * @param _owner The address from which the balance will be retrieved
1723      * @param _blockNumber The block number when the balance is queried
1724      * @return The balance at `_blockNumber`
1725      */
1726     function balanceOfAt(address _owner, uint128 _blockNumber) external view returns (uint256) {
1727         return _valueAt(accountSnapshots[_owner], _blockNumber);
1728     }
1729 
1730     /**
1731      * @notice Total amount of tokens at a specific `_blockNumber`.
1732      * @param _blockNumber The block number when the totalSupply is queried
1733      * @return The total amount of tokens at `_blockNumber`
1734      */
1735     function totalSupplyAt(uint128 _blockNumber) external view returns(uint256) {
1736         return _valueAt(totalSupplySnapshots, _blockNumber);
1737     }
1738 
1739     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1740     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1741     function _beforeTokenTransfer(address operator, address from, address to, uint256 amount) internal virtual override {
1742         if (from == address(0)) {
1743             // mint
1744             updateValueAtNow(accountSnapshots[to], balanceOf(to).add(amount));
1745             updateValueAtNow(totalSupplySnapshots, totalSupply().add(amount));
1746         } else if (to == address(0)) {
1747             // burn
1748             updateValueAtNow(accountSnapshots[from], balanceOf(from).sub(amount));
1749             updateValueAtNow(totalSupplySnapshots, totalSupply().sub(amount));
1750         } else if (from != to) {
1751             // transfer
1752             updateValueAtNow(accountSnapshots[from], balanceOf(from).sub(amount));
1753             updateValueAtNow(accountSnapshots[to], balanceOf(to).add(amount));
1754         }
1755     }
1756 
1757     /**
1758      * @dev `_valueAt` retrieves the number of tokens at a given block number
1759      * @param snapshots The history of values being queried
1760      * @param _block The block number to retrieve the value at
1761      * @return The number of tokens being queried
1762      */
1763     function _valueAt(
1764         Snapshot[] storage snapshots,
1765         uint128 _block
1766     ) view internal returns (uint256) {
1767         uint256 lenSnapshots = snapshots.length;
1768         if (lenSnapshots == 0) return 0;
1769 
1770         // Shortcut for the actual value
1771         if (_block >= snapshots[lenSnapshots - 1].fromBlock) {
1772             return snapshots[lenSnapshots - 1].value;
1773         }
1774         if (_block < snapshots[0].fromBlock) {
1775             return 0;
1776         }
1777 
1778         // Binary search of the value in the array
1779         uint256 min = 0;
1780         uint256 max = lenSnapshots - 1;
1781         while (max > min) {
1782             uint256 mid = (max + min + 1) / 2;
1783 
1784             uint256 midSnapshotFrom = snapshots[mid].fromBlock;
1785             if (midSnapshotFrom == _block) {
1786                 return snapshots[mid].value;
1787             } else if (midSnapshotFrom < _block) {
1788                 min = mid;
1789             } else {
1790                 max = mid - 1;
1791             }
1792         }
1793 
1794         return snapshots[min].value;
1795     }
1796 
1797     /**
1798      * @dev `updateValueAtNow` used to update the `balances` map and the
1799      *  `totalSupplySnapshots`
1800      * @param snapshots The history of data being updated
1801      * @param _value The new number of tokens
1802      */
1803     function updateValueAtNow(Snapshot[] storage snapshots, uint256 _value) internal {
1804         require(_value <= uint128(-1), "casting overflow");
1805         uint256 lenSnapshots = snapshots.length;
1806 
1807         if (
1808             (lenSnapshots == 0) ||
1809             (snapshots[lenSnapshots - 1].fromBlock < block.number)
1810         ) {
1811             snapshots.push(
1812                 Snapshot(
1813                     uint128(block.number),
1814                     uint128(_value)
1815                 )
1816             );
1817         } else {
1818             snapshots[lenSnapshots - 1].value = uint128(_value);
1819         }
1820     }
1821 }
1822 
1823 
1824 // File contracts/HoprToken.sol
1825 
1826 // SPDX-License-Identifier: GPL-3.0
1827 pragma solidity ^0.6.0;
1828 
1829 
1830 
1831 contract HoprToken is AccessControl, ERC777Snapshot {
1832     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1833 
1834     constructor() public ERC777("HOPR Token", "HOPR", new address[](0)) {
1835         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1836     }
1837 
1838     /**
1839      * @dev Creates `amount` new tokens for `to`.
1840      *
1841      * See {ERC20-_mint}.
1842      *
1843      * Requirements:
1844      *
1845      * - the caller must have the `MINTER_ROLE`.
1846      */
1847     function mint(
1848         address account,
1849         uint256 amount,
1850         bytes memory userData,
1851         bytes memory operatorData
1852     ) public {
1853         require(hasRole(MINTER_ROLE, msg.sender), "HoprToken: caller does not have minter role");
1854         _mint(account, amount, userData, operatorData);
1855     }
1856 }