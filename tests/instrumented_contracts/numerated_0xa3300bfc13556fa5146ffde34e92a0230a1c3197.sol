1 // File: @openzeppelin/contracts/introspection/IERC165.sol
2 
3 // SPD-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 // SPD-License-Identifier: MIT
31 
32 pragma solidity ^0.6.2;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(address from, address to, uint256 tokenId) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address from, address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144       * @dev Safely transfers `tokenId` token from `from` to `to`.
145       *
146       * Requirements:
147       *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150       * - `tokenId` token must exist and be owned by `from`.
151       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153       *
154       * Emits a {Transfer} event.
155       */
156     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
157 }
158 
159 // File: contracts/UsesMon.sol
160 
161 // SPD-License-Identifier: AGPL-3.0-or-later
162 
163 pragma solidity ^0.6.8;
164 
165 interface UsesMon {
166   struct Mon {
167       // the original address this monster went to
168       address summoner;
169 
170       // the unique ID associated with parent 1 of this monster
171       uint256 parent1Id;
172 
173       // the unique ID associated with parent 2 of this monster
174       uint256 parent2Id;
175 
176       // the address of the contract that minted this monster
177       address minterContract;
178 
179       // the id of this monster within its specific contract
180       uint256 contractOrder;
181 
182       // the generation of this monster
183       uint256 gen;
184 
185       // used to calculate statistics and other things
186       uint256 bits;
187 
188       // tracks the experience of this monster
189       uint256 exp;
190 
191       // the monster's rarity
192       uint256 rarity;
193   }
194 }
195 
196 // File: contracts/IMonMinter.sol
197 
198 // SPD-License-Identifier: AGPL-3.0-or-later
199 
200 pragma solidity ^0.6.8;
201 pragma experimental ABIEncoderV2;
202 
203 
204 
205 interface IMonMinter is IERC721, UsesMon {
206 
207   function mintMonster(address to,
208                        uint256 parent1Id,
209                        uint256 parent2Id,
210                        address minterContract,
211                        uint256 contractOrder,
212                        uint256 gen,
213                        uint256 bits,
214                        uint256 exp,
215                        uint256 rarity
216                       ) external returns (uint256);
217 
218   function modifyMon(uint256 id,
219                      bool ignoreZeros,
220                      uint256 parent1Id,
221                      uint256 parent2Id,
222                      address minterContract,
223                      uint256 contractOrder,
224                      uint256 gen,
225                      uint256 bits,
226                      uint256 exp,
227                      uint256 rarity
228   ) external;
229 
230   function monRecords(uint256 id) external returns (Mon memory);
231 
232   function setTokenURI(uint256 id, string calldata uri) external;
233 }
234 
235 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
236 
237 // SPD-License-Identifier: MIT
238 
239 pragma solidity ^0.6.0;
240 
241 /**
242  * @dev Library for managing
243  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
244  * types.
245  *
246  * Sets have the following properties:
247  *
248  * - Elements are added, removed, and checked for existence in constant time
249  * (O(1)).
250  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
251  *
252  * ```
253  * contract Example {
254  *     // Add the library methods
255  *     using EnumerableSet for EnumerableSet.AddressSet;
256  *
257  *     // Declare a set state variable
258  *     EnumerableSet.AddressSet private mySet;
259  * }
260  * ```
261  *
262  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
263  * (`UintSet`) are supported.
264  */
265 library EnumerableSet {
266     // To implement this library for multiple types with as little code
267     // repetition as possible, we write it in terms of a generic Set type with
268     // bytes32 values.
269     // The Set implementation uses private functions, and user-facing
270     // implementations (such as AddressSet) are just wrappers around the
271     // underlying Set.
272     // This means that we can only create new EnumerableSets for types that fit
273     // in bytes32.
274 
275     struct Set {
276         // Storage of set values
277         bytes32[] _values;
278 
279         // Position of the value in the `values` array, plus 1 because index 0
280         // means a value is not in the set.
281         mapping (bytes32 => uint256) _indexes;
282     }
283 
284     /**
285      * @dev Add a value to a set. O(1).
286      *
287      * Returns true if the value was added to the set, that is if it was not
288      * already present.
289      */
290     function _add(Set storage set, bytes32 value) private returns (bool) {
291         if (!_contains(set, value)) {
292             set._values.push(value);
293             // The value is stored at length-1, but we add 1 to all indexes
294             // and use 0 as a sentinel value
295             set._indexes[value] = set._values.length;
296             return true;
297         } else {
298             return false;
299         }
300     }
301 
302     /**
303      * @dev Removes a value from a set. O(1).
304      *
305      * Returns true if the value was removed from the set, that is if it was
306      * present.
307      */
308     function _remove(Set storage set, bytes32 value) private returns (bool) {
309         // We read and store the value's index to prevent multiple reads from the same storage slot
310         uint256 valueIndex = set._indexes[value];
311 
312         if (valueIndex != 0) { // Equivalent to contains(set, value)
313             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
314             // the array, and then remove the last element (sometimes called as 'swap and pop').
315             // This modifies the order of the array, as noted in {at}.
316 
317             uint256 toDeleteIndex = valueIndex - 1;
318             uint256 lastIndex = set._values.length - 1;
319 
320             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
321             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
322 
323             bytes32 lastvalue = set._values[lastIndex];
324 
325             // Move the last value to the index where the value to delete is
326             set._values[toDeleteIndex] = lastvalue;
327             // Update the index for the moved value
328             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
329 
330             // Delete the slot where the moved value was stored
331             set._values.pop();
332 
333             // Delete the index for the deleted slot
334             delete set._indexes[value];
335 
336             return true;
337         } else {
338             return false;
339         }
340     }
341 
342     /**
343      * @dev Returns true if the value is in the set. O(1).
344      */
345     function _contains(Set storage set, bytes32 value) private view returns (bool) {
346         return set._indexes[value] != 0;
347     }
348 
349     /**
350      * @dev Returns the number of values on the set. O(1).
351      */
352     function _length(Set storage set) private view returns (uint256) {
353         return set._values.length;
354     }
355 
356    /**
357     * @dev Returns the value stored at position `index` in the set. O(1).
358     *
359     * Note that there are no guarantees on the ordering of values inside the
360     * array, and it may change when more values are added or removed.
361     *
362     * Requirements:
363     *
364     * - `index` must be strictly less than {length}.
365     */
366     function _at(Set storage set, uint256 index) private view returns (bytes32) {
367         require(set._values.length > index, "EnumerableSet: index out of bounds");
368         return set._values[index];
369     }
370 
371     // AddressSet
372 
373     struct AddressSet {
374         Set _inner;
375     }
376 
377     /**
378      * @dev Add a value to a set. O(1).
379      *
380      * Returns true if the value was added to the set, that is if it was not
381      * already present.
382      */
383     function add(AddressSet storage set, address value) internal returns (bool) {
384         return _add(set._inner, bytes32(uint256(value)));
385     }
386 
387     /**
388      * @dev Removes a value from a set. O(1).
389      *
390      * Returns true if the value was removed from the set, that is if it was
391      * present.
392      */
393     function remove(AddressSet storage set, address value) internal returns (bool) {
394         return _remove(set._inner, bytes32(uint256(value)));
395     }
396 
397     /**
398      * @dev Returns true if the value is in the set. O(1).
399      */
400     function contains(AddressSet storage set, address value) internal view returns (bool) {
401         return _contains(set._inner, bytes32(uint256(value)));
402     }
403 
404     /**
405      * @dev Returns the number of values in the set. O(1).
406      */
407     function length(AddressSet storage set) internal view returns (uint256) {
408         return _length(set._inner);
409     }
410 
411    /**
412     * @dev Returns the value stored at position `index` in the set. O(1).
413     *
414     * Note that there are no guarantees on the ordering of values inside the
415     * array, and it may change when more values are added or removed.
416     *
417     * Requirements:
418     *
419     * - `index` must be strictly less than {length}.
420     */
421     function at(AddressSet storage set, uint256 index) internal view returns (address) {
422         return address(uint256(_at(set._inner, index)));
423     }
424 
425 
426     // UintSet
427 
428     struct UintSet {
429         Set _inner;
430     }
431 
432     /**
433      * @dev Add a value to a set. O(1).
434      *
435      * Returns true if the value was added to the set, that is if it was not
436      * already present.
437      */
438     function add(UintSet storage set, uint256 value) internal returns (bool) {
439         return _add(set._inner, bytes32(value));
440     }
441 
442     /**
443      * @dev Removes a value from a set. O(1).
444      *
445      * Returns true if the value was removed from the set, that is if it was
446      * present.
447      */
448     function remove(UintSet storage set, uint256 value) internal returns (bool) {
449         return _remove(set._inner, bytes32(value));
450     }
451 
452     /**
453      * @dev Returns true if the value is in the set. O(1).
454      */
455     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
456         return _contains(set._inner, bytes32(value));
457     }
458 
459     /**
460      * @dev Returns the number of values on the set. O(1).
461      */
462     function length(UintSet storage set) internal view returns (uint256) {
463         return _length(set._inner);
464     }
465 
466    /**
467     * @dev Returns the value stored at position `index` in the set. O(1).
468     *
469     * Note that there are no guarantees on the ordering of values inside the
470     * array, and it may change when more values are added or removed.
471     *
472     * Requirements:
473     *
474     * - `index` must be strictly less than {length}.
475     */
476     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
477         return uint256(_at(set._inner, index));
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/Address.sol
482 
483 // SPD-License-Identifier: MIT
484 
485 pragma solidity ^0.6.2;
486 
487 /**
488  * @dev Collection of functions related to the address type
489  */
490 library Address {
491     /**
492      * @dev Returns true if `account` is a contract.
493      *
494      * [IMPORTANT]
495      * ====
496      * It is unsafe to assume that an address for which this function returns
497      * false is an externally-owned account (EOA) and not a contract.
498      *
499      * Among others, `isContract` will return false for the following
500      * types of addresses:
501      *
502      *  - an externally-owned account
503      *  - a contract in construction
504      *  - an address where a contract will be created
505      *  - an address where a contract lived, but was destroyed
506      * ====
507      */
508     function isContract(address account) internal view returns (bool) {
509         // This method relies in extcodesize, which returns 0 for contracts in
510         // construction, since the code is only stored at the end of the
511         // constructor execution.
512 
513         uint256 size;
514         // solhint-disable-next-line no-inline-assembly
515         assembly { size := extcodesize(account) }
516         return size > 0;
517     }
518 
519     /**
520      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
521      * `recipient`, forwarding all available gas and reverting on errors.
522      *
523      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
524      * of certain opcodes, possibly making contracts go over the 2300 gas limit
525      * imposed by `transfer`, making them unable to receive funds via
526      * `transfer`. {sendValue} removes this limitation.
527      *
528      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
529      *
530      * IMPORTANT: because control is transferred to `recipient`, care must be
531      * taken to not create reentrancy vulnerabilities. Consider using
532      * {ReentrancyGuard} or the
533      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
534      */
535     function sendValue(address payable recipient, uint256 amount) internal {
536         require(address(this).balance >= amount, "Address: insufficient balance");
537 
538         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
539         (bool success, ) = recipient.call{ value: amount }("");
540         require(success, "Address: unable to send value, recipient may have reverted");
541     }
542 
543     /**
544      * @dev Performs a Solidity function call using a low level `call`. A
545      * plain`call` is an unsafe replacement for a function call: use this
546      * function instead.
547      *
548      * If `target` reverts with a revert reason, it is bubbled up by this
549      * function (like regular Solidity function calls).
550      *
551      * Returns the raw returned data. To convert to the expected return value,
552      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
553      *
554      * Requirements:
555      *
556      * - `target` must be a contract.
557      * - calling `target` with `data` must not revert.
558      *
559      * _Available since v3.1._
560      */
561     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
562       return functionCall(target, data, "Address: low-level call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
567      * `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
572         return _functionCallWithValue(target, data, 0, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but also transferring `value` wei to `target`.
578      *
579      * Requirements:
580      *
581      * - the calling contract must have an ETH balance of at least `value`.
582      * - the called Solidity function must be `payable`.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
587         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
592      * with `errorMessage` as a fallback revert reason when `target` reverts.
593      *
594      * _Available since v3.1._
595      */
596     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
597         require(address(this).balance >= value, "Address: insufficient balance for call");
598         return _functionCallWithValue(target, data, value, errorMessage);
599     }
600 
601     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
602         require(isContract(target), "Address: call to non-contract");
603 
604         // solhint-disable-next-line avoid-low-level-calls
605         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 // solhint-disable-next-line no-inline-assembly
614                 assembly {
615                     let returndata_size := mload(returndata)
616                     revert(add(32, returndata), returndata_size)
617                 }
618             } else {
619                 revert(errorMessage);
620             }
621         }
622     }
623 }
624 
625 // File: @openzeppelin/contracts/GSN/Context.sol
626 
627 // SPD-License-Identifier: MIT
628 
629 pragma solidity ^0.6.0;
630 
631 /*
632  * @dev Provides information about the current execution context, including the
633  * sender of the transaction and its data. While these are generally available
634  * via msg.sender and msg.data, they should not be accessed in such a direct
635  * manner, since when dealing with GSN meta-transactions the account sending and
636  * paying for execution may not be the actual sender (as far as an application
637  * is concerned).
638  *
639  * This contract is only required for intermediate, library-like contracts.
640  */
641 abstract contract Context {
642     function _msgSender() internal view virtual returns (address payable) {
643         return msg.sender;
644     }
645 
646     function _msgData() internal view virtual returns (bytes memory) {
647         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
648         return msg.data;
649     }
650 }
651 
652 // File: @openzeppelin/contracts/access/AccessControl.sol
653 
654 // SPD-License-Identifier: MIT
655 
656 pragma solidity ^0.6.0;
657 
658 
659 
660 
661 /**
662  * @dev Contract module that allows children to implement role-based access
663  * control mechanisms.
664  *
665  * Roles are referred to by their `bytes32` identifier. These should be exposed
666  * in the external API and be unique. The best way to achieve this is by
667  * using `public constant` hash digests:
668  *
669  * ```
670  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
671  * ```
672  *
673  * Roles can be used to represent a set of permissions. To restrict access to a
674  * function call, use {hasRole}:
675  *
676  * ```
677  * function foo() public {
678  *     require(hasRole(MY_ROLE, msg.sender));
679  *     ...
680  * }
681  * ```
682  *
683  * Roles can be granted and revoked dynamically via the {grantRole} and
684  * {revokeRole} functions. Each role has an associated admin role, and only
685  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
686  *
687  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
688  * that only accounts with this role will be able to grant or revoke other
689  * roles. More complex role relationships can be created by using
690  * {_setRoleAdmin}.
691  *
692  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
693  * grant and revoke this role. Extra precautions should be taken to secure
694  * accounts that have been granted it.
695  */
696 abstract contract AccessControl is Context {
697     using EnumerableSet for EnumerableSet.AddressSet;
698     using Address for address;
699 
700     struct RoleData {
701         EnumerableSet.AddressSet members;
702         bytes32 adminRole;
703     }
704 
705     mapping (bytes32 => RoleData) private _roles;
706 
707     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
708 
709     /**
710      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
711      *
712      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
713      * {RoleAdminChanged} not being emitted signaling this.
714      *
715      * _Available since v3.1._
716      */
717     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
718 
719     /**
720      * @dev Emitted when `account` is granted `role`.
721      *
722      * `sender` is the account that originated the contract call, an admin role
723      * bearer except when using {_setupRole}.
724      */
725     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
726 
727     /**
728      * @dev Emitted when `account` is revoked `role`.
729      *
730      * `sender` is the account that originated the contract call:
731      *   - if using `revokeRole`, it is the admin role bearer
732      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
733      */
734     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
735 
736     /**
737      * @dev Returns `true` if `account` has been granted `role`.
738      */
739     function hasRole(bytes32 role, address account) public view returns (bool) {
740         return _roles[role].members.contains(account);
741     }
742 
743     /**
744      * @dev Returns the number of accounts that have `role`. Can be used
745      * together with {getRoleMember} to enumerate all bearers of a role.
746      */
747     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
748         return _roles[role].members.length();
749     }
750 
751     /**
752      * @dev Returns one of the accounts that have `role`. `index` must be a
753      * value between 0 and {getRoleMemberCount}, non-inclusive.
754      *
755      * Role bearers are not sorted in any particular way, and their ordering may
756      * change at any point.
757      *
758      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
759      * you perform all queries on the same block. See the following
760      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
761      * for more information.
762      */
763     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
764         return _roles[role].members.at(index);
765     }
766 
767     /**
768      * @dev Returns the admin role that controls `role`. See {grantRole} and
769      * {revokeRole}.
770      *
771      * To change a role's admin, use {_setRoleAdmin}.
772      */
773     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
774         return _roles[role].adminRole;
775     }
776 
777     /**
778      * @dev Grants `role` to `account`.
779      *
780      * If `account` had not been already granted `role`, emits a {RoleGranted}
781      * event.
782      *
783      * Requirements:
784      *
785      * - the caller must have ``role``'s admin role.
786      */
787     function grantRole(bytes32 role, address account) public virtual {
788         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
789 
790         _grantRole(role, account);
791     }
792 
793     /**
794      * @dev Revokes `role` from `account`.
795      *
796      * If `account` had been granted `role`, emits a {RoleRevoked} event.
797      *
798      * Requirements:
799      *
800      * - the caller must have ``role``'s admin role.
801      */
802     function revokeRole(bytes32 role, address account) public virtual {
803         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
804 
805         _revokeRole(role, account);
806     }
807 
808     /**
809      * @dev Revokes `role` from the calling account.
810      *
811      * Roles are often managed via {grantRole} and {revokeRole}: this function's
812      * purpose is to provide a mechanism for accounts to lose their privileges
813      * if they are compromised (such as when a trusted device is misplaced).
814      *
815      * If the calling account had been granted `role`, emits a {RoleRevoked}
816      * event.
817      *
818      * Requirements:
819      *
820      * - the caller must be `account`.
821      */
822     function renounceRole(bytes32 role, address account) public virtual {
823         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
824 
825         _revokeRole(role, account);
826     }
827 
828     /**
829      * @dev Grants `role` to `account`.
830      *
831      * If `account` had not been already granted `role`, emits a {RoleGranted}
832      * event. Note that unlike {grantRole}, this function doesn't perform any
833      * checks on the calling account.
834      *
835      * [WARNING]
836      * ====
837      * This function should only be called from the constructor when setting
838      * up the initial roles for the system.
839      *
840      * Using this function in any other way is effectively circumventing the admin
841      * system imposed by {AccessControl}.
842      * ====
843      */
844     function _setupRole(bytes32 role, address account) internal virtual {
845         _grantRole(role, account);
846     }
847 
848     /**
849      * @dev Sets `adminRole` as ``role``'s admin role.
850      *
851      * Emits a {RoleAdminChanged} event.
852      */
853     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
854         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
855         _roles[role].adminRole = adminRole;
856     }
857 
858     function _grantRole(bytes32 role, address account) private {
859         if (_roles[role].members.add(account)) {
860             emit RoleGranted(role, account, _msgSender());
861         }
862     }
863 
864     function _revokeRole(bytes32 role, address account) private {
865         if (_roles[role].members.remove(account)) {
866             emit RoleRevoked(role, account, _msgSender());
867         }
868     }
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
872 
873 // SPD-License-Identifier: MIT
874 
875 pragma solidity ^0.6.0;
876 
877 /**
878  * @dev Interface of the ERC20 standard as defined in the EIP.
879  */
880 interface IERC20 {
881     /**
882      * @dev Returns the amount of tokens in existence.
883      */
884     function totalSupply() external view returns (uint256);
885 
886     /**
887      * @dev Returns the amount of tokens owned by `account`.
888      */
889     function balanceOf(address account) external view returns (uint256);
890 
891     /**
892      * @dev Moves `amount` tokens from the caller's account to `recipient`.
893      *
894      * Returns a boolean value indicating whether the operation succeeded.
895      *
896      * Emits a {Transfer} event.
897      */
898     function transfer(address recipient, uint256 amount) external returns (bool);
899 
900     /**
901      * @dev Returns the remaining number of tokens that `spender` will be
902      * allowed to spend on behalf of `owner` through {transferFrom}. This is
903      * zero by default.
904      *
905      * This value changes when {approve} or {transferFrom} are called.
906      */
907     function allowance(address owner, address spender) external view returns (uint256);
908 
909     /**
910      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
911      *
912      * Returns a boolean value indicating whether the operation succeeded.
913      *
914      * IMPORTANT: Beware that changing an allowance with this method brings the risk
915      * that someone may use both the old and the new allowance by unfortunate
916      * transaction ordering. One possible solution to mitigate this race
917      * condition is to first reduce the spender's allowance to 0 and set the
918      * desired value afterwards:
919      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
920      *
921      * Emits an {Approval} event.
922      */
923     function approve(address spender, uint256 amount) external returns (bool);
924 
925     /**
926      * @dev Moves `amount` tokens from `sender` to `recipient` using the
927      * allowance mechanism. `amount` is then deducted from the caller's
928      * allowance.
929      *
930      * Returns a boolean value indicating whether the operation succeeded.
931      *
932      * Emits a {Transfer} event.
933      */
934     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
935 
936     /**
937      * @dev Emitted when `value` tokens are moved from one account (`from`) to
938      * another (`to`).
939      *
940      * Note that `value` may be zero.
941      */
942     event Transfer(address indexed from, address indexed to, uint256 value);
943 
944     /**
945      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
946      * a call to {approve}. `value` is the new allowance.
947      */
948     event Approval(address indexed owner, address indexed spender, uint256 value);
949 }
950 
951 // File: @openzeppelin/contracts/math/SafeMath.sol
952 
953 // SPD-License-Identifier: MIT
954 
955 pragma solidity ^0.6.0;
956 
957 /**
958  * @dev Wrappers over Solidity's arithmetic operations with added overflow
959  * checks.
960  *
961  * Arithmetic operations in Solidity wrap on overflow. This can easily result
962  * in bugs, because programmers usually assume that an overflow raises an
963  * error, which is the standard behavior in high level programming languages.
964  * `SafeMath` restores this intuition by reverting the transaction when an
965  * operation overflows.
966  *
967  * Using this library instead of the unchecked operations eliminates an entire
968  * class of bugs, so it's recommended to use it always.
969  */
970 library SafeMath {
971     /**
972      * @dev Returns the addition of two unsigned integers, reverting on
973      * overflow.
974      *
975      * Counterpart to Solidity's `+` operator.
976      *
977      * Requirements:
978      *
979      * - Addition cannot overflow.
980      */
981     function add(uint256 a, uint256 b) internal pure returns (uint256) {
982         uint256 c = a + b;
983         require(c >= a, "SafeMath: addition overflow");
984 
985         return c;
986     }
987 
988     /**
989      * @dev Returns the subtraction of two unsigned integers, reverting on
990      * overflow (when the result is negative).
991      *
992      * Counterpart to Solidity's `-` operator.
993      *
994      * Requirements:
995      *
996      * - Subtraction cannot overflow.
997      */
998     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
999         return sub(a, b, "SafeMath: subtraction overflow");
1000     }
1001 
1002     /**
1003      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1004      * overflow (when the result is negative).
1005      *
1006      * Counterpart to Solidity's `-` operator.
1007      *
1008      * Requirements:
1009      *
1010      * - Subtraction cannot overflow.
1011      */
1012     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1013         require(b <= a, errorMessage);
1014         uint256 c = a - b;
1015 
1016         return c;
1017     }
1018 
1019     /**
1020      * @dev Returns the multiplication of two unsigned integers, reverting on
1021      * overflow.
1022      *
1023      * Counterpart to Solidity's `*` operator.
1024      *
1025      * Requirements:
1026      *
1027      * - Multiplication cannot overflow.
1028      */
1029     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1030         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1031         // benefit is lost if 'b' is also tested.
1032         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1033         if (a == 0) {
1034             return 0;
1035         }
1036 
1037         uint256 c = a * b;
1038         require(c / a == b, "SafeMath: multiplication overflow");
1039 
1040         return c;
1041     }
1042 
1043     /**
1044      * @dev Returns the integer division of two unsigned integers. Reverts on
1045      * division by zero. The result is rounded towards zero.
1046      *
1047      * Counterpart to Solidity's `/` operator. Note: this function uses a
1048      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1049      * uses an invalid opcode to revert (consuming all remaining gas).
1050      *
1051      * Requirements:
1052      *
1053      * - The divisor cannot be zero.
1054      */
1055     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1056         return div(a, b, "SafeMath: division by zero");
1057     }
1058 
1059     /**
1060      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1061      * division by zero. The result is rounded towards zero.
1062      *
1063      * Counterpart to Solidity's `/` operator. Note: this function uses a
1064      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1065      * uses an invalid opcode to revert (consuming all remaining gas).
1066      *
1067      * Requirements:
1068      *
1069      * - The divisor cannot be zero.
1070      */
1071     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1072         require(b > 0, errorMessage);
1073         uint256 c = a / b;
1074         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1075 
1076         return c;
1077     }
1078 
1079     /**
1080      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1081      * Reverts when dividing by zero.
1082      *
1083      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1084      * opcode (which leaves remaining gas untouched) while Solidity uses an
1085      * invalid opcode to revert (consuming all remaining gas).
1086      *
1087      * Requirements:
1088      *
1089      * - The divisor cannot be zero.
1090      */
1091     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1092         return mod(a, b, "SafeMath: modulo by zero");
1093     }
1094 
1095     /**
1096      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1097      * Reverts with custom message when dividing by zero.
1098      *
1099      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1100      * opcode (which leaves remaining gas untouched) while Solidity uses an
1101      * invalid opcode to revert (consuming all remaining gas).
1102      *
1103      * Requirements:
1104      *
1105      * - The divisor cannot be zero.
1106      */
1107     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1108         require(b != 0, errorMessage);
1109         return a % b;
1110     }
1111 }
1112 
1113 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
1114 
1115 // SPD-License-Identifier: MIT
1116 
1117 pragma solidity ^0.6.0;
1118 
1119 
1120 
1121 
1122 /**
1123  * @title SafeERC20
1124  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1125  * contract returns false). Tokens that return no value (and instead revert or
1126  * throw on failure) are also supported, non-reverting calls are assumed to be
1127  * successful.
1128  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1129  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1130  */
1131 library SafeERC20 {
1132     using SafeMath for uint256;
1133     using Address for address;
1134 
1135     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1136         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1137     }
1138 
1139     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1140         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1141     }
1142 
1143     /**
1144      * @dev Deprecated. This function has issues similar to the ones found in
1145      * {IERC20-approve}, and its usage is discouraged.
1146      *
1147      * Whenever possible, use {safeIncreaseAllowance} and
1148      * {safeDecreaseAllowance} instead.
1149      */
1150     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1151         // safeApprove should only be called when setting an initial allowance,
1152         // or when resetting it to zero. To increase and decrease it, use
1153         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1154         // solhint-disable-next-line max-line-length
1155         require((value == 0) || (token.allowance(address(this), spender) == 0),
1156             "SafeERC20: approve from non-zero to non-zero allowance"
1157         );
1158         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1159     }
1160 
1161     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1162         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1163         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1164     }
1165 
1166     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1167         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1168         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1169     }
1170 
1171     /**
1172      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1173      * on the return value: the return value is optional (but if data is returned, it must not be false).
1174      * @param token The token targeted by the call.
1175      * @param data The call data (encoded using abi.encode or one of its variants).
1176      */
1177     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1178         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1179         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1180         // the target address contains contract code and also asserts for success in the low-level call.
1181 
1182         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1183         if (returndata.length > 0) { // Return data is optional
1184             // solhint-disable-next-line max-line-length
1185             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1186         }
1187     }
1188 }
1189 
1190 // File: contracts/MonCreatorInstance.sol
1191 
1192 // SPD-License-Identifier: AGPL-3.0-or-later
1193 
1194 pragma solidity ^0.6.8;
1195 
1196 
1197 
1198 
1199 abstract contract MonCreatorInstance is AccessControl {
1200 
1201   using SafeERC20 for IERC20;
1202   using SafeMath for uint256;
1203 
1204   IERC20 public xmon;
1205   IMonMinter public monMinter;
1206 
1207   uint256 public maxMons;
1208   uint256 public numMons;
1209 
1210   // to be appended before the URI for the NFT
1211   string public prefixURI;
1212 
1213   modifier onlyAdmin {
1214     require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Not admin");
1215     _;
1216   }
1217 
1218   function updateNumMons() internal {
1219     require(numMons < maxMons, "All mons are out");
1220     numMons = numMons.add(1);
1221   }
1222 
1223   function setMaxMons(uint256 m) public onlyAdmin {
1224     maxMons = m;
1225   }
1226 
1227   function setPrefixURI(string memory prefix) public onlyAdmin {
1228     prefixURI = prefix;
1229   }
1230 }
1231 
1232 // File: @openzeppelin/contracts/utils/Strings.sol
1233 
1234 // SPD-License-Identifier: MIT
1235 
1236 pragma solidity ^0.6.0;
1237 
1238 /**
1239  * @dev String operations.
1240  */
1241 library Strings {
1242     /**
1243      * @dev Converts a `uint256` to its ASCII `string` representation.
1244      */
1245     function toString(uint256 value) internal pure returns (string memory) {
1246         // Inspired by OraclizeAPI's implementation - MIT licence
1247         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1248 
1249         if (value == 0) {
1250             return "0";
1251         }
1252         uint256 temp = value;
1253         uint256 digits;
1254         while (temp != 0) {
1255             digits++;
1256             temp /= 10;
1257         }
1258         bytes memory buffer = new bytes(digits);
1259         uint256 index = digits - 1;
1260         temp = value;
1261         while (temp != 0) {
1262             buffer[index--] = byte(uint8(48 + temp % 10));
1263             temp /= 10;
1264         }
1265         return string(buffer);
1266     }
1267 }
1268 
1269 // File: contracts/IDoomAdmin.sol
1270 
1271 // SPD-License-Identifier: AGPL-3.0-or-later
1272 
1273 pragma solidity ^0.6.8;
1274 
1275 interface IDoomAdmin {
1276   function pendingDoom(address a) external view returns(uint256);
1277   function doomBalances(address a) external returns (uint256);
1278   function setDoomBalances(address a, uint256 d) external;
1279 }
1280 
1281 // File: contracts/MonStaker3.sol
1282 
1283 // SPD-License-Identifier: AGPL-3.0-or-later
1284 
1285 pragma solidity ^0.6.8;
1286 
1287 
1288 
1289 
1290 contract MonStaker3 is MonCreatorInstance {
1291 
1292   using SafeMath for uint256;
1293   using Strings for uint256;
1294   using SafeERC20 for IERC20;
1295 
1296   bytes32 public constant STAKER_ADMIN_ROLE = keccak256("STAKER_ADMIN_ROLE");
1297 
1298   // Offset for the URI
1299   int128 public uriOffset;
1300 
1301   // Start time for mintMon
1302   uint256 public claimMonStart;
1303 
1304   // Maximum amount of DOOM to migrate
1305   uint256 public maxDoomToMigrate;
1306 
1307   // Last migration date
1308   uint256 public lastMigrationDate;
1309 
1310   // Record of which addresses have migrated
1311   mapping(address => bool) public hasMigrated;
1312 
1313   // Previous staker reference
1314   IDoomAdmin public prevStaker;
1315 
1316   struct Stake {
1317     uint256 amount;
1318     uint256 startBlock;
1319   }
1320   mapping(address => Stake) public stakeRecords;
1321 
1322   // amount of base doom needed to summon monster
1323   uint256 public baseDoomFee;
1324 
1325   // the amount of doom accrued by each account
1326   mapping(address => uint256) public doomBalances;
1327 
1328   // initial rarity
1329   uint256 public rarity;
1330 
1331   modifier onlyStakerAdmin {
1332     require(hasRole(STAKER_ADMIN_ROLE, msg.sender), "Not staker admin");
1333     _;
1334   }
1335 
1336   constructor(address xmonAddress, address monMinterAddress) public {
1337     // Give caller admin permissions
1338     _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1339 
1340     // Make the caller admin a staker admin
1341     grantRole(STAKER_ADMIN_ROLE, msg.sender);
1342 
1343     // starting rarity is 2
1344     rarity = 2;
1345 
1346     // set xmon instance
1347     xmon = IERC20(xmonAddress);
1348 
1349     // set monMinter instance
1350     monMinter = IMonMinter(monMinterAddress);
1351 
1352     // set max DOOM to migrate to be 666 times doom scaling
1353     maxDoomToMigrate = 666 * (10**21);
1354 
1355     // set new doom fee to be sqrt(12 ether)*6600*10 = approx 23.76*(10**13) = 2376*(10**11)
1356     baseDoomFee = 2376 * (10**11);
1357 
1358     // set prefixURI
1359     prefixURI = "mons2/";
1360 
1361     // Point to previous staker
1362     prevStaker = IDoomAdmin(0xD06337A401B468657dE2f9d3E390cE5b21C3c1C0);
1363 
1364     // Set first time to claim and last migration date to be 2021, April 2, 10 am pacific time
1365     claimMonStart = 1617382800;
1366     lastMigrationDate = 1617382800;
1367   }
1368 
1369   // Taken from Uniswap
1370   function sqrt(uint y) public pure returns (uint z) {
1371     if (y > 3) {
1372         z = y;
1373         uint x = y / 2 + 1;
1374         while (x < z) {
1375             z = x;
1376             x = (y / x + x) / 2;
1377         }
1378     } else if (y != 0) {
1379         z = 1;
1380     }
1381   }
1382 
1383   function addStake(uint256 amount) public {
1384     require(amount > 0, "Need to stake nonzero");
1385 
1386     // award existing doom
1387     awardDoom(msg.sender);
1388 
1389     // update to total amount
1390     uint256 newAmount = stakeRecords[msg.sender].amount.add(amount);
1391 
1392     // update stake records
1393     stakeRecords[msg.sender] = Stake(
1394       newAmount,
1395       block.number
1396     );
1397 
1398     // transfer tokens to contract
1399     xmon.safeTransferFrom(msg.sender, address(this), amount);
1400   }
1401 
1402   function removeStake() public {
1403     // award doom
1404     awardDoom(msg.sender);
1405     emergencyRemoveStake();
1406   }
1407 
1408   function emergencyRemoveStake() public {
1409     // calculate how much to award
1410     uint256 amountToTransfer = stakeRecords[msg.sender].amount;
1411 
1412     // remove stake records
1413     delete stakeRecords[msg.sender];
1414 
1415     // transfer tokens back
1416     xmon.safeTransfer(msg.sender, amountToTransfer);
1417   }
1418 
1419   // Awards accumulated doom and resets startBlock
1420   function awardDoom(address a) public {
1421     // If there is an existing amount staked, add the current accumulated amount and reset the block number
1422     if (stakeRecords[a].amount != 0) {
1423       // DOOM = sqrt(staked balance) * number of blocks staked
1424       uint256 doomAmount = sqrt(stakeRecords[a].amount).mul(block.number.sub(stakeRecords[a].startBlock));
1425       doomBalances[a] = doomBalances[a].add(doomAmount);
1426 
1427       // reset the start block
1428       stakeRecords[a].startBlock = block.number;
1429     }
1430   }
1431 
1432   // Claim a monster
1433   function claimMon() public returns (uint256) {
1434     require(block.timestamp >= claimMonStart, "Not time yet");
1435 
1436     // award doom first
1437     awardDoom(msg.sender);
1438 
1439     // check conditions
1440     require(doomBalances[msg.sender] >= baseDoomFee, "Not enough DOOM");
1441     super.updateNumMons();
1442 
1443     // remove doom fee from caller's doom balance
1444     doomBalances[msg.sender] = doomBalances[msg.sender].sub(baseDoomFee);
1445 
1446     // update the offset of the new mon to be the prefix plus the numMons
1447     // if uriOffset is negative, it will subtract from numMons
1448     // otherwise, it adds to numMons
1449     uint256 offsetMons = uriOffset < 0 ? numMons - uint256(uriOffset) : numMons + uint256(uriOffset);
1450 
1451     // mint the monster
1452     uint256 id = monMinter.mintMonster(
1453       // to
1454       msg.sender,
1455       // parent1Id
1456       0,
1457       // parent2Id
1458       0,
1459       // minterContract (we don't actually care where it came from for now)
1460       address(0),
1461       // contractOrder (also set to be the offset)
1462       offsetMons,
1463       // gen
1464       1,
1465       // bits
1466       0,
1467       // exp
1468       0,
1469       // rarity
1470       rarity
1471     );
1472     string memory uri = string(abi.encodePacked(prefixURI, offsetMons.toString()));
1473     monMinter.setTokenURI(id, uri);
1474 
1475     // return new monster id
1476     return(id);
1477   }
1478 
1479   function migrateDoom() public {
1480     require(!hasMigrated[msg.sender], "Already migrated");
1481     require(block.timestamp <= lastMigrationDate, "Time limit up");
1482     uint256 totalDoom = prevStaker.pendingDoom(msg.sender) + prevStaker.doomBalances(msg.sender);
1483     if (totalDoom > maxDoomToMigrate) {
1484       totalDoom = maxDoomToMigrate;
1485     }
1486     totalDoom = (totalDoom*baseDoomFee)/maxDoomToMigrate;
1487     doomBalances[msg.sender] = totalDoom;
1488     hasMigrated[msg.sender] = true;
1489   }
1490 
1491   function setUriOffset(int128 o) public onlyAdmin {
1492     uriOffset = o;
1493   }
1494 
1495   function setLastMigrationDate(uint256 d) public onlyAdmin {
1496     lastMigrationDate = d;
1497   }
1498 
1499   function setMaxDoomToMigrate(uint256 m) public onlyAdmin {
1500     maxDoomToMigrate = m;
1501   }
1502 
1503   function setClaimMonStart(uint256 c) public onlyAdmin {
1504     claimMonStart = c;
1505   }
1506 
1507   function setRarity(uint256 r) public onlyAdmin {
1508     rarity = r;
1509   }
1510 
1511   function setBaseDoomFee(uint256 f) public onlyAdmin {
1512     baseDoomFee = f;
1513   }
1514 
1515   function setMonMinter(address a) public onlyAdmin {
1516     monMinter = IMonMinter(a);
1517   }
1518 
1519   function setPrevStaker(address a) public onlyAdmin {
1520     prevStaker = IDoomAdmin(a);
1521   }
1522 
1523   // Allows admin to add new staker admins
1524   function setStakerAdminRole(address a) public onlyAdmin {
1525     grantRole(STAKER_ADMIN_ROLE, a);
1526   }
1527 
1528   function moveTokens(address tokenAddress, address to, uint256 numTokens) public onlyAdmin {
1529     require(tokenAddress != address(xmon), "Can't move XMON");
1530     IERC20 _token = IERC20(tokenAddress);
1531     _token.safeTransfer(to, numTokens);
1532   }
1533 
1534   function setDoomBalances(address a, uint256 d) public onlyStakerAdmin {
1535     doomBalances[a] = d;
1536   }
1537 
1538   function balanceOf(address a) public view returns(uint256) {
1539     return stakeRecords[a].amount;
1540   }
1541 
1542   function pendingDoom(address a) public view returns(uint256) {
1543     return(sqrt(stakeRecords[a].amount).mul(block.number.sub(stakeRecords[a].startBlock)));
1544   }
1545 }