1 /**
2  *Submitted for verification at polygonscan.com on 2023-01-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-24
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
11 
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev External interface of AccessControl declared to support ERC165 detection.
17  */
18 interface IAccessControl {
19     /**
20      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
21      *
22      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
23      * {RoleAdminChanged} not being emitted signaling this.
24      *
25      * _Available since v3.1._
26      */
27     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
28 
29     /**
30      * @dev Emitted when `account` is granted `role`.
31      *
32      * `sender` is the account that originated the contract call, an admin role
33      * bearer except when using {AccessControl-_setupRole}.
34      */
35     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
36 
37     /**
38      * @dev Emitted when `account` is revoked `role`.
39      *
40      * `sender` is the account that originated the contract call:
41      *   - if using `revokeRole`, it is the admin role bearer
42      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
43      */
44     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
45 
46     /**
47      * @dev Returns `true` if `account` has been granted `role`.
48      */
49     function hasRole(bytes32 role, address account) external view returns (bool);
50 
51     /**
52      * @dev Returns the admin role that controls `role`. See {grantRole} and
53      * {revokeRole}.
54      *
55      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
56      */
57     function getRoleAdmin(bytes32 role) external view returns (bytes32);
58 
59     /**
60      * @dev Grants `role` to `account`.
61      *
62      * If `account` had not been already granted `role`, emits a {RoleGranted}
63      * event.
64      *
65      * Requirements:
66      *
67      * - the caller must have ``role``'s admin role.
68      */
69     function grantRole(bytes32 role, address account) external;
70 
71     /**
72      * @dev Revokes `role` from `account`.
73      *
74      * If `account` had been granted `role`, emits a {RoleRevoked} event.
75      *
76      * Requirements:
77      *
78      * - the caller must have ``role``'s admin role.
79      */
80     function revokeRole(bytes32 role, address account) external;
81 
82     /**
83      * @dev Revokes `role` from the calling account.
84      *
85      * Roles are often managed via {grantRole} and {revokeRole}: this function's
86      * purpose is to provide a mechanism for accounts to lose their privileges
87      * if they are compromised (such as when a trusted device is misplaced).
88      *
89      * If the calling account had been granted `role`, emits a {RoleRevoked}
90      * event.
91      *
92      * Requirements:
93      *
94      * - the caller must be `account`.
95      */
96     function renounceRole(bytes32 role, address account) external;
97 }
98 
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Interface of the ERC165 standard, as defined in the
104  * https://eips.ethereum.org/EIPS/eip-165[EIP].
105  *
106  * Implementers can declare support of contract interfaces, which can then be
107  * queried by others ({ERC165Checker}).
108  *
109  * For an implementation, see {ERC165}.
110  */
111 interface IERC165 {
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30 000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 }
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
127  */
128 interface IAccessControlEnumerable is IAccessControl {
129     /**
130      * @dev Returns one of the accounts that have `role`. `index` must be a
131      * value between 0 and {getRoleMemberCount}, non-inclusive.
132      *
133      * Role bearers are not sorted in any particular way, and their ordering may
134      * change at any point.
135      *
136      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
137      * you perform all queries on the same block. See the following
138      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
139      * for more information.
140      */
141     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
142 
143     /**
144      * @dev Returns the number of accounts that have `role`. Can be used
145      * together with {getRoleMember} to enumerate all bearers of a role.
146      */
147     function getRoleMemberCount(bytes32 role) external view returns (uint256);
148 }
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Library for managing
154  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
155  * types.
156  *
157  * Sets have the following properties:
158  *
159  * - Elements are added, removed, and checked for existence in constant time
160  * (O(1)).
161  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
162  *
163  * ```
164  * contract Example {
165  *     // Add the library methods
166  *     using EnumerableSet for EnumerableSet.AddressSet;
167  *
168  *     // Declare a set state variable
169  *     EnumerableSet.AddressSet private mySet;
170  * }
171  * ```
172  *
173  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
174  * and `uint256` (`UintSet`) are supported.
175  */
176 library EnumerableSet {
177     // To implement this library for multiple types with as little code
178     // repetition as possible, we write it in terms of a generic Set type with
179     // bytes32 values.
180     // The Set implementation uses private functions, and user-facing
181     // implementations (such as AddressSet) are just wrappers around the
182     // underlying Set.
183     // This means that we can only create new EnumerableSets for types that fit
184     // in bytes32.
185 
186     struct Set {
187         // Storage of set values
188         bytes32[] _values;
189         // Position of the value in the `values` array, plus 1 because index 0
190         // means a value is not in the set.
191         mapping(bytes32 => uint256) _indexes;
192     }
193 
194     /**
195      * @dev Add a value to a set. O(1).
196      *
197      * Returns true if the value was added to the set, that is if it was not
198      * already present.
199      */
200     function _add(Set storage set, bytes32 value) private returns (bool) {
201         if (!_contains(set, value)) {
202             set._values.push(value);
203             // The value is stored at length-1, but we add 1 to all indexes
204             // and use 0 as a sentinel value
205             set._indexes[value] = set._values.length;
206             return true;
207         } else {
208             return false;
209         }
210     }
211 
212     /**
213      * @dev Removes a value from a set. O(1).
214      *
215      * Returns true if the value was removed from the set, that is if it was
216      * present.
217      */
218     function _remove(Set storage set, bytes32 value) private returns (bool) {
219         // We read and store the value's index to prevent multiple reads from the same storage slot
220         uint256 valueIndex = set._indexes[value];
221 
222         if (valueIndex != 0) {
223             // Equivalent to contains(set, value)
224             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
225             // the array, and then remove the last element (sometimes called as 'swap and pop').
226             // This modifies the order of the array, as noted in {at}.
227 
228             uint256 toDeleteIndex = valueIndex - 1;
229             uint256 lastIndex = set._values.length - 1;
230 
231             if (lastIndex != toDeleteIndex) {
232                 bytes32 lastvalue = set._values[lastIndex];
233 
234                 // Move the last value to the index where the value to delete is
235                 set._values[toDeleteIndex] = lastvalue;
236                 // Update the index for the moved value
237                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
238             }
239 
240             // Delete the slot where the moved value was stored
241             set._values.pop();
242 
243             // Delete the index for the deleted slot
244             delete set._indexes[value];
245 
246             return true;
247         } else {
248             return false;
249         }
250     }
251 
252     /**
253      * @dev Returns true if the value is in the set. O(1).
254      */
255     function _contains(Set storage set, bytes32 value) private view returns (bool) {
256         return set._indexes[value] != 0;
257     }
258 
259     /**
260      * @dev Returns the number of values on the set. O(1).
261      */
262     function _length(Set storage set) private view returns (uint256) {
263         return set._values.length;
264     }
265 
266     /**
267      * @dev Returns the value stored at position `index` in the set. O(1).
268      *
269      * Note that there are no guarantees on the ordering of values inside the
270      * array, and it may change when more values are added or removed.
271      *
272      * Requirements:
273      *
274      * - `index` must be strictly less than {length}.
275      */
276     function _at(Set storage set, uint256 index) private view returns (bytes32) {
277         return set._values[index];
278     }
279 
280     /**
281      * @dev Return the entire set in an array
282      *
283      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
284      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
285      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
286      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
287      */
288     function _values(Set storage set) private view returns (bytes32[] memory) {
289         return set._values;
290     }
291 
292     // Bytes32Set
293 
294     struct Bytes32Set {
295         Set _inner;
296     }
297 
298     /**
299      * @dev Add a value to a set. O(1).
300      *
301      * Returns true if the value was added to the set, that is if it was not
302      * already present.
303      */
304     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
305         return _add(set._inner, value);
306     }
307 
308     /**
309      * @dev Removes a value from a set. O(1).
310      *
311      * Returns true if the value was removed from the set, that is if it was
312      * present.
313      */
314     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
315         return _remove(set._inner, value);
316     }
317 
318     /**
319      * @dev Returns true if the value is in the set. O(1).
320      */
321     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
322         return _contains(set._inner, value);
323     }
324 
325     /**
326      * @dev Returns the number of values in the set. O(1).
327      */
328     function length(Bytes32Set storage set) internal view returns (uint256) {
329         return _length(set._inner);
330     }
331 
332     /**
333      * @dev Returns the value stored at position `index` in the set. O(1).
334      *
335      * Note that there are no guarantees on the ordering of values inside the
336      * array, and it may change when more values are added or removed.
337      *
338      * Requirements:
339      *
340      * - `index` must be strictly less than {length}.
341      */
342     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
343         return _at(set._inner, index);
344     }
345 
346     /**
347      * @dev Return the entire set in an array
348      *
349      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
350      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
351      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
352      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
353      */
354     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
355         return _values(set._inner);
356     }
357 
358     // AddressSet
359 
360     struct AddressSet {
361         Set _inner;
362     }
363 
364     /**
365      * @dev Add a value to a set. O(1).
366      *
367      * Returns true if the value was added to the set, that is if it was not
368      * already present.
369      */
370     function add(AddressSet storage set, address value) internal returns (bool) {
371         return _add(set._inner, bytes32(uint256(uint160(value))));
372     }
373 
374     /**
375      * @dev Removes a value from a set. O(1).
376      *
377      * Returns true if the value was removed from the set, that is if it was
378      * present.
379      */
380     function remove(AddressSet storage set, address value) internal returns (bool) {
381         return _remove(set._inner, bytes32(uint256(uint160(value))));
382     }
383 
384     /**
385      * @dev Returns true if the value is in the set. O(1).
386      */
387     function contains(AddressSet storage set, address value) internal view returns (bool) {
388         return _contains(set._inner, bytes32(uint256(uint160(value))));
389     }
390 
391     /**
392      * @dev Returns the number of values in the set. O(1).
393      */
394     function length(AddressSet storage set) internal view returns (uint256) {
395         return _length(set._inner);
396     }
397 
398     /**
399      * @dev Returns the value stored at position `index` in the set. O(1).
400      *
401      * Note that there are no guarantees on the ordering of values inside the
402      * array, and it may change when more values are added or removed.
403      *
404      * Requirements:
405      *
406      * - `index` must be strictly less than {length}.
407      */
408     function at(AddressSet storage set, uint256 index) internal view returns (address) {
409         return address(uint160(uint256(_at(set._inner, index))));
410     }
411 
412     /**
413      * @dev Return the entire set in an array
414      *
415      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
416      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
417      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
418      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
419      */
420     function values(AddressSet storage set) internal view returns (address[] memory) {
421         bytes32[] memory store = _values(set._inner);
422         address[] memory result;
423 
424         assembly {
425             result := store
426         }
427 
428         return result;
429     }
430 
431     // UintSet
432 
433     struct UintSet {
434         Set _inner;
435     }
436 
437     /**
438      * @dev Add a value to a set. O(1).
439      *
440      * Returns true if the value was added to the set, that is if it was not
441      * already present.
442      */
443     function add(UintSet storage set, uint256 value) internal returns (bool) {
444         return _add(set._inner, bytes32(value));
445     }
446 
447     /**
448      * @dev Removes a value from a set. O(1).
449      *
450      * Returns true if the value was removed from the set, that is if it was
451      * present.
452      */
453     function remove(UintSet storage set, uint256 value) internal returns (bool) {
454         return _remove(set._inner, bytes32(value));
455     }
456 
457     /**
458      * @dev Returns true if the value is in the set. O(1).
459      */
460     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
461         return _contains(set._inner, bytes32(value));
462     }
463 
464     /**
465      * @dev Returns the number of values on the set. O(1).
466      */
467     function length(UintSet storage set) internal view returns (uint256) {
468         return _length(set._inner);
469     }
470 
471     /**
472      * @dev Returns the value stored at position `index` in the set. O(1).
473      *
474      * Note that there are no guarantees on the ordering of values inside the
475      * array, and it may change when more values are added or removed.
476      *
477      * Requirements:
478      *
479      * - `index` must be strictly less than {length}.
480      */
481     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
482         return uint256(_at(set._inner, index));
483     }
484 
485     /**
486      * @dev Return the entire set in an array
487      *
488      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
489      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
490      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
491      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
492      */
493     function values(UintSet storage set) internal view returns (uint256[] memory) {
494         bytes32[] memory store = _values(set._inner);
495         uint256[] memory result;
496 
497         assembly {
498             result := store
499         }
500 
501         return result;
502     }
503 }
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Required interface of an ERC721 compliant contract.
509  */
510 interface IERC721 is IERC165 {
511     /**
512      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
513      */
514     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
518      */
519     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
523      */
524     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
525 
526     /**
527      * @dev Returns the number of tokens in ``owner``'s account.
528      */
529     function balanceOf(address owner) external view returns (uint256 balance);
530 
531     /**
532      * @dev Returns the owner of the `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function ownerOf(uint256 tokenId) external view returns (address owner);
539 
540     /**
541      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
542      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
543      *
544      * Requirements:
545      *
546      * - `from` cannot be the zero address.
547      * - `to` cannot be the zero address.
548      * - `tokenId` token must exist and be owned by `from`.
549      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
550      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
551      *
552      * Emits a {Transfer} event.
553      */
554     function safeTransferFrom(
555         address from,
556         address to,
557         uint256 tokenId
558     ) external;
559 
560     /**
561      * @dev Transfers `tokenId` token from `from` to `to`.
562      *
563      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must be owned by `from`.
570      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
571      *
572      * Emits a {Transfer} event.
573      */
574     function transferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
582      * The approval is cleared when the token is transferred.
583      *
584      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
585      *
586      * Requirements:
587      *
588      * - The caller must own the token or be an approved operator.
589      * - `tokenId` must exist.
590      *
591      * Emits an {Approval} event.
592      */
593     function approve(address to, uint256 tokenId) external;
594 
595     /**
596      * @dev Returns the account approved for `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function getApproved(uint256 tokenId) external view returns (address operator);
603 
604     /**
605      * @dev Approve or remove `operator` as an operator for the caller.
606      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
607      *
608      * Requirements:
609      *
610      * - The `operator` cannot be the caller.
611      *
612      * Emits an {ApprovalForAll} event.
613      */
614     function setApprovalForAll(address operator, bool _approved) external;
615 
616     /**
617      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
618      *
619      * See {setApprovalForAll}
620      */
621     function isApprovedForAll(address owner, address operator) external view returns (bool);
622 
623     /**
624      * @dev Safely transfers `tokenId` token from `from` to `to`.
625      *
626      * Requirements:
627      *
628      * - `from` cannot be the zero address.
629      * - `to` cannot be the zero address.
630      * - `tokenId` token must exist and be owned by `from`.
631      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
632      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
633      *
634      * Emits a {Transfer} event.
635      */
636     function safeTransferFrom(
637         address from,
638         address to,
639         uint256 tokenId,
640         bytes calldata data
641     ) external;
642 }
643 
644 pragma solidity ^0.8.0;
645 
646 /**
647  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
648  * @dev See https://eips.ethereum.org/EIPS/eip-721
649  */
650 interface IERC721Enumerable is IERC721 {
651     /**
652      * @dev Returns the total amount of tokens stored by the contract.
653      */
654     function totalSupply() external view returns (uint256);
655 
656     /**
657      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
658      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
659      */
660     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
661 
662     /**
663      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
664      * Use along with {totalSupply} to enumerate all tokens.
665      */
666     function tokenByIndex(uint256 index) external view returns (uint256);
667 }
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @title ERC721 token receiver interface
673  * @dev Interface for any contract that wants to support safeTransfers
674  * from ERC721 asset contracts.
675  */
676 interface IERC721Receiver {
677     /**
678      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
679      * by `operator` from `from`, this function is called.
680      *
681      * It must return its Solidity selector to confirm the token transfer.
682      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
683      *
684      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
685      */
686     function onERC721Received(
687         address operator,
688         address from,
689         uint256 tokenId,
690         bytes calldata data
691     ) external returns (bytes4);
692 }
693 
694 pragma solidity ^0.8.0;
695 
696 /**
697  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
698  * @dev See https://eips.ethereum.org/EIPS/eip-721
699  */
700 interface IERC721Metadata is IERC721 {
701     /**
702      * @dev Returns the token collection name.
703      */
704     function name() external view returns (string memory);
705 
706     /**
707      * @dev Returns the token collection symbol.
708      */
709     function symbol() external view returns (string memory);
710 
711     /**
712      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
713      */
714     function tokenURI(uint256 tokenId) external view returns (string memory);
715 }
716 
717 pragma solidity ^0.8.0;
718 
719 /**
720  * @dev Collection of functions related to the address type
721  */
722 library Address {
723     /**
724      * @dev Returns true if `account` is a contract.
725      *
726      * [IMPORTANT]
727      * ====
728      * It is unsafe to assume that an address for which this function returns
729      * false is an externally-owned account (EOA) and not a contract.
730      *
731      * Among others, `isContract` will return false for the following
732      * types of addresses:
733      *
734      *  - an externally-owned account
735      *  - a contract in construction
736      *  - an address where a contract will be created
737      *  - an address where a contract lived, but was destroyed
738      * ====
739      */
740     function isContract(address account) internal view returns (bool) {
741         // This method relies on extcodesize, which returns 0 for contracts in
742         // construction, since the code is only stored at the end of the
743         // constructor execution.
744 
745         uint256 size;
746         assembly {
747             size := extcodesize(account)
748         }
749         return size > 0;
750     }
751 
752     /**
753      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
754      * `recipient`, forwarding all available gas and reverting on errors.
755      *
756      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
757      * of certain opcodes, possibly making contracts go over the 2300 gas limit
758      * imposed by `transfer`, making them unable to receive funds via
759      * `transfer`. {sendValue} removes this limitation.
760      *
761      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
762      *
763      * IMPORTANT: because control is transferred to `recipient`, care must be
764      * taken to not create reentrancy vulnerabilities. Consider using
765      * {ReentrancyGuard} or the
766      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
767      */
768     function sendValue(address payable recipient, uint256 amount) internal {
769         require(address(this).balance >= amount, "Address: insufficient balance");
770 
771         (bool success, ) = recipient.call{value: amount}("");
772         require(success, "Address: unable to send value, recipient may have reverted");
773     }
774 
775     /**
776      * @dev Performs a Solidity function call using a low level `call`. A
777      * plain `call` is an unsafe replacement for a function call: use this
778      * function instead.
779      *
780      * If `target` reverts with a revert reason, it is bubbled up by this
781      * function (like regular Solidity function calls).
782      *
783      * Returns the raw returned data. To convert to the expected return value,
784      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
785      *
786      * Requirements:
787      *
788      * - `target` must be a contract.
789      * - calling `target` with `data` must not revert.
790      *
791      * _Available since v3.1._
792      */
793     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
794         return functionCall(target, data, "Address: low-level call failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
799      * `errorMessage` as a fallback revert reason when `target` reverts.
800      *
801      * _Available since v3.1._
802      */
803     function functionCall(
804         address target,
805         bytes memory data,
806         string memory errorMessage
807     ) internal returns (bytes memory) {
808         return functionCallWithValue(target, data, 0, errorMessage);
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
813      * but also transferring `value` wei to `target`.
814      *
815      * Requirements:
816      *
817      * - the calling contract must have an ETH balance of at least `value`.
818      * - the called Solidity function must be `payable`.
819      *
820      * _Available since v3.1._
821      */
822     function functionCallWithValue(
823         address target,
824         bytes memory data,
825         uint256 value
826     ) internal returns (bytes memory) {
827         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
832      * with `errorMessage` as a fallback revert reason when `target` reverts.
833      *
834      * _Available since v3.1._
835      */
836     function functionCallWithValue(
837         address target,
838         bytes memory data,
839         uint256 value,
840         string memory errorMessage
841     ) internal returns (bytes memory) {
842         require(address(this).balance >= value, "Address: insufficient balance for call");
843         require(isContract(target), "Address: call to non-contract");
844 
845         (bool success, bytes memory returndata) = target.call{value: value}(data);
846         return verifyCallResult(success, returndata, errorMessage);
847     }
848 
849     /**
850      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
851      * but performing a static call.
852      *
853      * _Available since v3.3._
854      */
855     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
856         return functionStaticCall(target, data, "Address: low-level static call failed");
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
861      * but performing a static call.
862      *
863      * _Available since v3.3._
864      */
865     function functionStaticCall(
866         address target,
867         bytes memory data,
868         string memory errorMessage
869     ) internal view returns (bytes memory) {
870         require(isContract(target), "Address: static call to non-contract");
871 
872         (bool success, bytes memory returndata) = target.staticcall(data);
873         return verifyCallResult(success, returndata, errorMessage);
874     }
875 
876     /**
877      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
878      * but performing a delegate call.
879      *
880      * _Available since v3.4._
881      */
882     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
883         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
888      * but performing a delegate call.
889      *
890      * _Available since v3.4._
891      */
892     function functionDelegateCall(
893         address target,
894         bytes memory data,
895         string memory errorMessage
896     ) internal returns (bytes memory) {
897         require(isContract(target), "Address: delegate call to non-contract");
898 
899         (bool success, bytes memory returndata) = target.delegatecall(data);
900         return verifyCallResult(success, returndata, errorMessage);
901     }
902 
903     /**
904      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
905      * revert reason using the provided one.
906      *
907      * _Available since v4.3._
908      */
909     function verifyCallResult(
910         bool success,
911         bytes memory returndata,
912         string memory errorMessage
913     ) internal pure returns (bytes memory) {
914         if (success) {
915             return returndata;
916         } else {
917             // Look for revert reason and bubble it up if present
918             if (returndata.length > 0) {
919                 // The easiest way to bubble the revert reason is using memory via assembly
920 
921                 assembly {
922                     let returndata_size := mload(returndata)
923                     revert(add(32, returndata), returndata_size)
924                 }
925             } else {
926                 revert(errorMessage);
927             }
928         }
929     }
930 }
931 
932 pragma solidity ^0.8.0;
933 
934 /**
935  * @dev Provides information about the current execution context, including the
936  * sender of the transaction and its data. While these are generally available
937  * via msg.sender and msg.data, they should not be accessed in such a direct
938  * manner, since when dealing with meta-transactions the account sending and
939  * paying for execution may not be the actual sender (as far as an application
940  * is concerned).
941  *
942  * This contract is only required for intermediate, library-like contracts.
943  */
944 abstract contract Context {
945     function _msgSender() internal view virtual returns (address) {
946         return msg.sender;
947     }
948 
949     function _msgData() internal view virtual returns (bytes calldata) {
950         return msg.data;
951     }
952 }
953 
954 pragma solidity ^0.8.0;
955 
956 /**
957  * @dev String operations.
958  */
959 library Strings {
960     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
961 
962     /**
963      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
964      */
965     function toString(uint256 value) internal pure returns (string memory) {
966         // Inspired by OraclizeAPI's implementation - MIT licence
967         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
968 
969         if (value == 0) {
970             return "0";
971         }
972         uint256 temp = value;
973         uint256 digits;
974         while (temp != 0) {
975             digits++;
976             temp /= 10;
977         }
978         bytes memory buffer = new bytes(digits);
979         while (value != 0) {
980             digits -= 1;
981             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
982             value /= 10;
983         }
984         return string(buffer);
985     }
986 
987     /**
988      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
989      */
990     function toHexString(uint256 value) internal pure returns (string memory) {
991         if (value == 0) {
992             return "0x00";
993         }
994         uint256 temp = value;
995         uint256 length = 0;
996         while (temp != 0) {
997             length++;
998             temp >>= 8;
999         }
1000         return toHexString(value, length);
1001     }
1002 
1003     /**
1004      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1005      */
1006     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1007         bytes memory buffer = new bytes(2 * length + 2);
1008         buffer[0] = "0";
1009         buffer[1] = "x";
1010         for (uint256 i = 2 * length + 1; i > 1; --i) {
1011             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1012             value >>= 4;
1013         }
1014         require(value == 0, "Strings: hex length insufficient");
1015         return string(buffer);
1016     }
1017 }
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 /**
1022  * @dev Implementation of the {IERC165} interface.
1023  *
1024  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1025  * for the additional interface id that will be supported. For example:
1026  *
1027  * ```solidity
1028  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1029  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1030  * }
1031  * ```
1032  *
1033  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1034  */
1035 abstract contract ERC165 is IERC165 {
1036     /**
1037      * @dev See {IERC165-supportsInterface}.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1040         return interfaceId == type(IERC165).interfaceId;
1041     }
1042 }
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 /**
1047  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1048  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1049  * {ERC721Enumerable}.
1050  */
1051 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1052     using Address for address;
1053     using Strings for uint256;
1054 
1055     // Token name
1056     string private _name;
1057 
1058     // Token symbol
1059     string private _symbol;
1060 
1061     // Mapping from token ID to owner address
1062     mapping(uint256 => address) private _owners;
1063 
1064     // Mapping owner address to token count
1065     mapping(address => uint256) private _balances;
1066 
1067     // Mapping from token ID to approved address
1068     mapping(uint256 => address) private _tokenApprovals;
1069 
1070     // Mapping from owner to operator approvals
1071     mapping(address => mapping(address => bool)) private _operatorApprovals;
1072 
1073     /**
1074      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1075      */
1076     constructor(string memory name_, string memory symbol_) {
1077         _name = name_;
1078         _symbol = symbol_;
1079     }
1080 
1081     /**
1082      * @dev See {IERC165-supportsInterface}.
1083      */
1084     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1085         return
1086             interfaceId == type(IERC721).interfaceId ||
1087             interfaceId == type(IERC721Metadata).interfaceId ||
1088             super.supportsInterface(interfaceId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-balanceOf}.
1093      */
1094     function balanceOf(address owner) public view virtual override returns (uint256) {
1095         require(owner != address(0), "ERC721: balance query for the zero address");
1096         return _balances[owner];
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-ownerOf}.
1101      */
1102     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1103         address owner = _owners[tokenId];
1104         require(owner != address(0), "ERC721: owner query for nonexistent token");
1105         return owner;
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Metadata-name}.
1110      */
1111     function name() public view virtual override returns (string memory) {
1112         return _name;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Metadata-symbol}.
1117      */
1118     function symbol() public view virtual override returns (string memory) {
1119         return _symbol;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Metadata-tokenURI}.
1124      */
1125     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1126         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1127 
1128         string memory baseURI = _baseURI();
1129         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1130     }
1131 
1132     /**
1133      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1134      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1135      * by default, can be overriden in child contracts.
1136      */
1137     function _baseURI() internal view virtual returns (string memory) {
1138         return "";
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-approve}.
1143      */
1144     function approve(address to, uint256 tokenId) public virtual override {
1145         address owner = ERC721.ownerOf(tokenId);
1146         require(to != owner, "ERC721: approval to current owner");
1147 
1148         require(
1149             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1150             "ERC721: approve caller is not owner nor approved for all"
1151         );
1152 
1153         _approve(to, tokenId);
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-getApproved}.
1158      */
1159     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1160         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1161 
1162         return _tokenApprovals[tokenId];
1163     }
1164 
1165     /**
1166      * @dev See {IERC721-setApprovalForAll}.
1167      */
1168     function setApprovalForAll(address operator, bool approved) public virtual override {
1169         _setApprovalForAll(_msgSender(), operator, approved);
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-isApprovedForAll}.
1174      */
1175     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1176         return _operatorApprovals[owner][operator];
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-transferFrom}.
1181      */
1182     function transferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) public virtual override {
1187         //solhint-disable-next-line max-line-length
1188         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1189 
1190         _transfer(from, to, tokenId);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-safeTransferFrom}.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) public virtual override {
1201         safeTransferFrom(from, to, tokenId, "");
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-safeTransferFrom}.
1206      */
1207     function safeTransferFrom(
1208         address from,
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) public virtual override {
1213         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1214         _safeTransfer(from, to, tokenId, _data);
1215     }
1216 
1217     /**
1218      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1219      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1220      *
1221      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1222      *
1223      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1224      * implement alternative mechanisms to perform token transfer, such as signature-based.
1225      *
1226      * Requirements:
1227      *
1228      * - `from` cannot be the zero address.
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must exist and be owned by `from`.
1231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _safeTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId,
1239         bytes memory _data
1240     ) internal virtual {
1241         _transfer(from, to, tokenId);
1242         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1243     }
1244 
1245     /**
1246      * @dev Returns whether `tokenId` exists.
1247      *
1248      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1249      *
1250      * Tokens start existing when they are minted (`_mint`),
1251      * and stop existing when they are burned (`_burn`).
1252      */
1253     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1254         return _owners[tokenId] != address(0);
1255     }
1256 
1257     /**
1258      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1259      *
1260      * Requirements:
1261      *
1262      * - `tokenId` must exist.
1263      */
1264     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1265         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1266         address owner = ERC721.ownerOf(tokenId);
1267         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1268     }
1269 
1270     /**
1271      * @dev Safely mints `tokenId` and transfers it to `to`.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must not exist.
1276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _safeMint(address to, uint256 tokenId) internal virtual {
1281         _safeMint(to, tokenId, "");
1282     }
1283 
1284     /**
1285      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1286      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1287      */
1288     function _safeMint(
1289         address to,
1290         uint256 tokenId,
1291         bytes memory _data
1292     ) internal virtual {
1293         _mint(to, tokenId);
1294         require(
1295             _checkOnERC721Received(address(0), to, tokenId, _data),
1296             "ERC721: transfer to non ERC721Receiver implementer"
1297         );
1298     }
1299 
1300     /**
1301      * @dev Mints `tokenId` and transfers it to `to`.
1302      *
1303      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must not exist.
1308      * - `to` cannot be the zero address.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _mint(address to, uint256 tokenId) internal virtual {
1313         require(to != address(0), "ERC721: mint to the zero address");
1314         require(!_exists(tokenId), "ERC721: token already minted");
1315 
1316         _beforeTokenTransfer(address(0), to, tokenId);
1317 
1318         _balances[to] += 1;
1319         _owners[tokenId] = to;
1320 
1321         emit Transfer(address(0), to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Destroys `tokenId`.
1326      * The approval is cleared when the token is burned.
1327      *
1328      * Requirements:
1329      *
1330      * - `tokenId` must exist.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _burn(uint256 tokenId) internal virtual {
1335         address owner = ERC721.ownerOf(tokenId);
1336 
1337         _beforeTokenTransfer(owner, address(0), tokenId);
1338 
1339         // Clear approvals
1340         _approve(address(0), tokenId);
1341 
1342         _balances[owner] -= 1;
1343         delete _owners[tokenId];
1344 
1345         emit Transfer(owner, address(0), tokenId);
1346     }
1347 
1348     /**
1349      * @dev Transfers `tokenId` from `from` to `to`.
1350      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1351      *
1352      * Requirements:
1353      *
1354      * - `to` cannot be the zero address.
1355      * - `tokenId` token must be owned by `from`.
1356      *
1357      * Emits a {Transfer} event.
1358      */
1359     function _transfer(
1360         address from,
1361         address to,
1362         uint256 tokenId
1363     ) internal virtual {
1364         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1365         require(to != address(0), "ERC721: transfer to the zero address");
1366 
1367         _beforeTokenTransfer(from, to, tokenId);
1368 
1369         // Clear approvals from the previous owner
1370         _approve(address(0), tokenId);
1371 
1372         _balances[from] -= 1;
1373         _balances[to] += 1;
1374         _owners[tokenId] = to;
1375 
1376         emit Transfer(from, to, tokenId);
1377     }
1378 
1379     /**
1380      * @dev Approve `to` to operate on `tokenId`
1381      *
1382      * Emits a {Approval} event.
1383      */
1384     function _approve(address to, uint256 tokenId) internal virtual {
1385         _tokenApprovals[tokenId] = to;
1386         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev Approve `operator` to operate on all of `owner` tokens
1391      *
1392      * Emits a {ApprovalForAll} event.
1393      */
1394     function _setApprovalForAll(
1395         address owner,
1396         address operator,
1397         bool approved
1398     ) internal virtual {
1399         require(owner != operator, "ERC721: approve to caller");
1400         _operatorApprovals[owner][operator] = approved;
1401         emit ApprovalForAll(owner, operator, approved);
1402     }
1403 
1404     /**
1405      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1406      * The call is not executed if the target address is not a contract.
1407      *
1408      * @param from address representing the previous owner of the given token ID
1409      * @param to target address that will receive the tokens
1410      * @param tokenId uint256 ID of the token to be transferred
1411      * @param _data bytes optional data to send along with the call
1412      * @return bool whether the call correctly returned the expected magic value
1413      */
1414     function _checkOnERC721Received(
1415         address from,
1416         address to,
1417         uint256 tokenId,
1418         bytes memory _data
1419     ) private returns (bool) {
1420         if (to.isContract()) {
1421             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1422                 return retval == IERC721Receiver.onERC721Received.selector;
1423             } catch (bytes memory reason) {
1424                 if (reason.length == 0) {
1425                     revert("ERC721: transfer to non ERC721Receiver implementer");
1426                 } else {
1427                     assembly {
1428                         revert(add(32, reason), mload(reason))
1429                     }
1430                 }
1431             }
1432         } else {
1433             return true;
1434         }
1435     }
1436 
1437     /**
1438      * @dev Hook that is called before any token transfer. This includes minting
1439      * and burning.
1440      *
1441      * Calling conditions:
1442      *
1443      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1444      * transferred to `to`.
1445      * - When `from` is zero, `tokenId` will be minted for `to`.
1446      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1447      * - `from` and `to` are never both zero.
1448      *
1449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1450      */
1451     function _beforeTokenTransfer(
1452         address from,
1453         address to,
1454         uint256 tokenId
1455     ) internal virtual {}
1456 }
1457 
1458 
1459 
1460 
1461 
1462 pragma solidity ^0.8.0;
1463 
1464 
1465 
1466 /**
1467  * @dev Contract module that allows children to implement role-based access
1468  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1469  * members except through off-chain means by accessing the contract event logs. Some
1470  * applications may benefit from on-chain enumerability, for those cases see
1471  * {AccessControlEnumerable}.
1472  *
1473  * Roles are referred to by their `bytes32` identifier. These should be exposed
1474  * in the external API and be unique. The best way to achieve this is by
1475  * using `public constant` hash digests:
1476  *
1477  * ```
1478  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1479  * ```
1480  *
1481  * Roles can be used to represent a set of permissions. To restrict access to a
1482  * function call, use {hasRole}:
1483  *
1484  * ```
1485  * function foo() public {
1486  *     require(hasRole(MY_ROLE, msg.sender));
1487  *     ...
1488  * }
1489  * ```
1490  *
1491  * Roles can be granted and revoked dynamically via the {grantRole} and
1492  * {revokeRole} functions. Each role has an associated admin role, and only
1493  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1494  *
1495  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1496  * that only accounts with this role will be able to grant or revoke other
1497  * roles. More complex role relationships can be created by using
1498  * {_setRoleAdmin}.
1499  *
1500  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1501  * grant and revoke this role. Extra precautions should be taken to secure
1502  * accounts that have been granted it.
1503  */
1504 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1505     struct RoleData {
1506         mapping(address => bool) members;
1507         bytes32 adminRole;
1508     }
1509 
1510     mapping(bytes32 => RoleData) private _roles;
1511 
1512     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1513 
1514     /**
1515      * @dev Modifier that checks that an account has a specific role. Reverts
1516      * with a standardized message including the required role.
1517      *
1518      * The format of the revert reason is given by the following regular expression:
1519      *
1520      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1521      *
1522      * _Available since v4.1._
1523      */
1524     modifier onlyRole(bytes32 role) {
1525         _checkRole(role, _msgSender());
1526         _;
1527     }
1528 
1529     /**
1530      * @dev See {IERC165-supportsInterface}.
1531      */
1532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1533         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1534     }
1535 
1536     /**
1537      * @dev Returns `true` if `account` has been granted `role`.
1538      */
1539     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1540         return _roles[role].members[account];
1541     }
1542 
1543     /**
1544      * @dev Revert with a standard message if `account` is missing `role`.
1545      *
1546      * The format of the revert reason is given by the following regular expression:
1547      *
1548      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1549      */
1550     function _checkRole(bytes32 role, address account) internal view virtual {
1551         if (!hasRole(role, account)) {
1552             revert(
1553                 string(
1554                     abi.encodePacked(
1555                         "AccessControl: account ",
1556                         Strings.toHexString(uint160(account), 20),
1557                         " is missing role ",
1558                         Strings.toHexString(uint256(role), 32)
1559                     )
1560                 )
1561             );
1562         }
1563     }
1564 
1565     /**
1566      * @dev Returns the admin role that controls `role`. See {grantRole} and
1567      * {revokeRole}.
1568      *
1569      * To change a role's admin, use {_setRoleAdmin}.
1570      */
1571     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1572         return _roles[role].adminRole;
1573     }
1574 
1575     /**
1576      * @dev Grants `role` to `account`.
1577      *
1578      * If `account` had not been already granted `role`, emits a {RoleGranted}
1579      * event.
1580      *
1581      * Requirements:
1582      *
1583      * - the caller must have ``role``'s admin role.
1584      */
1585     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1586         _grantRole(role, account);
1587     }
1588 
1589     /**
1590      * @dev Revokes `role` from `account`.
1591      *
1592      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1593      *
1594      * Requirements:
1595      *
1596      * - the caller must have ``role``'s admin role.
1597      */
1598     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1599         _revokeRole(role, account);
1600     }
1601 
1602     /**
1603      * @dev Revokes `role` from the calling account.
1604      *
1605      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1606      * purpose is to provide a mechanism for accounts to lose their privileges
1607      * if they are compromised (such as when a trusted device is misplaced).
1608      *
1609      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1610      * event.
1611      *
1612      * Requirements:
1613      *
1614      * - the caller must be `account`.
1615      */
1616     function renounceRole(bytes32 role, address account) public virtual override {
1617         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1618 
1619         _revokeRole(role, account);
1620     }
1621 
1622     /**
1623      * @dev Grants `role` to `account`.
1624      *
1625      * If `account` had not been already granted `role`, emits a {RoleGranted}
1626      * event. Note that unlike {grantRole}, this function doesn't perform any
1627      * checks on the calling account.
1628      *
1629      * [WARNING]
1630      * ====
1631      * This function should only be called from the constructor when setting
1632      * up the initial roles for the system.
1633      *
1634      * Using this function in any other way is effectively circumventing the admin
1635      * system imposed by {AccessControl}.
1636      * ====
1637      *
1638      * NOTE: This function is deprecated in favor of {_grantRole}.
1639      */
1640     function _setupRole(bytes32 role, address account) internal virtual {
1641         _grantRole(role, account);
1642     }
1643 
1644     /**
1645      * @dev Sets `adminRole` as ``role``'s admin role.
1646      *
1647      * Emits a {RoleAdminChanged} event.
1648      */
1649     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1650         bytes32 previousAdminRole = getRoleAdmin(role);
1651         _roles[role].adminRole = adminRole;
1652         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1653     }
1654 
1655     /**
1656      * @dev Grants `role` to `account`.
1657      *
1658      * Internal function without access restriction.
1659      */
1660     function _grantRole(bytes32 role, address account) internal virtual {
1661         if (!hasRole(role, account)) {
1662             _roles[role].members[account] = true;
1663             emit RoleGranted(role, account, _msgSender());
1664         }
1665     }
1666 
1667     /**
1668      * @dev Revokes `role` from `account`.
1669      *
1670      * Internal function without access restriction.
1671      */
1672     function _revokeRole(bytes32 role, address account) internal virtual {
1673         if (hasRole(role, account)) {
1674             _roles[role].members[account] = false;
1675             emit RoleRevoked(role, account, _msgSender());
1676         }
1677     }
1678 }
1679 
1680 
1681 
1682 
1683 pragma solidity ^0.8.0;
1684 
1685 
1686 /**
1687  * @dev Contract module which provides a basic access control mechanism, where
1688  * there is an account (an owner) that can be granted exclusive access to
1689  * specific functions.
1690  *
1691  * By default, the owner account will be the one that deploys the contract. This
1692  * can later be changed with {transferOwnership}.
1693  *
1694  * This module is used through inheritance. It will make available the modifier
1695  * `onlyOwner`, which can be applied to your functions to restrict their use to
1696  * the owner.
1697  */
1698 abstract contract Ownable is Context {
1699     address private _owner;
1700 
1701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1702 
1703     /**
1704      * @dev Initializes the contract setting the deployer as the initial owner.
1705      */
1706     constructor() {
1707         _transferOwnership(_msgSender());
1708     }
1709 
1710     /**
1711      * @dev Returns the address of the current owner.
1712      */
1713     function owner() public view virtual returns (address) {
1714         return _owner;
1715     }
1716 
1717     /**
1718      * @dev Throws if called by any account other than the owner.
1719      */
1720     modifier onlyOwner() {
1721         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1722         _;
1723     }
1724 
1725     /**
1726      * @dev Leaves the contract without owner. It will not be possible to call
1727      * `onlyOwner` functions anymore. Can only be called by the current owner.
1728      *
1729      * NOTE: Renouncing ownership will leave the contract without an owner,
1730      * thereby removing any functionality that is only available to the owner.
1731      */
1732     function renounceOwnership() public virtual onlyOwner {
1733         _transferOwnership(address(0));
1734     }
1735 
1736     /**
1737      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1738      * Can only be called by the current owner.
1739      */
1740     function transferOwnership(address newOwner) public virtual onlyOwner {
1741         require(newOwner != address(0), "Ownable: new owner is the zero address");
1742         _transferOwnership(newOwner);
1743     }
1744 
1745     /**
1746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1747      * Internal function without access restriction.
1748      */
1749     function _transferOwnership(address newOwner) internal virtual {
1750         address oldOwner = _owner;
1751         _owner = newOwner;
1752         emit OwnershipTransferred(oldOwner, newOwner);
1753     }
1754 }
1755 
1756 
1757 pragma solidity ^0.8.0;
1758 
1759 
1760 
1761 /**
1762  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1763  */
1764 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1765     using EnumerableSet for EnumerableSet.AddressSet;
1766 
1767     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1768 
1769     /**
1770      * @dev See {IERC165-supportsInterface}.
1771      */
1772     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1773         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1774     }
1775 
1776     /**
1777      * @dev Returns one of the accounts that have `role`. `index` must be a
1778      * value between 0 and {getRoleMemberCount}, non-inclusive.
1779      *
1780      * Role bearers are not sorted in any particular way, and their ordering may
1781      * change at any point.
1782      *
1783      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1784      * you perform all queries on the same block. See the following
1785      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1786      * for more information.
1787      */
1788     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1789         return _roleMembers[role].at(index);
1790     }
1791 
1792     /**
1793      * @dev Returns the number of accounts that have `role`. Can be used
1794      * together with {getRoleMember} to enumerate all bearers of a role.
1795      */
1796     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1797         return _roleMembers[role].length();
1798     }
1799 
1800     /**
1801      * @dev Overload {_grantRole} to track enumerable memberships
1802      */
1803     function _grantRole(bytes32 role, address account) internal virtual override {
1804         super._grantRole(role, account);
1805         _roleMembers[role].add(account);
1806     }
1807 
1808     /**
1809      * @dev Overload {_revokeRole} to track enumerable memberships
1810      */
1811     function _revokeRole(bytes32 role, address account) internal virtual override {
1812         super._revokeRole(role, account);
1813         _roleMembers[role].remove(account);
1814     }
1815 }
1816 
1817 
1818 pragma solidity ^0.8.0;
1819 
1820 /**
1821  * @dev Contract module that helps prevent reentrant calls to a function.
1822  *
1823  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1824  * available, which can be applied to functions to make sure there are no nested
1825  * (reentrant) calls to them.
1826  *
1827  * Note that because there is a single `nonReentrant` guard, functions marked as
1828  * `nonReentrant` may not call one another. This can be worked around by making
1829  * those functions `private`, and then adding `external` `nonReentrant` entry
1830  * points to them.
1831  *
1832  * TIP: If you would like to learn more about reentrancy and alternative ways
1833  * to protect against it, check out our blog post
1834  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1835  */
1836 abstract contract ReentrancyGuard {
1837     // Booleans are more expensive than uint256 or any type that takes up a full
1838     // word because each write operation emits an extra SLOAD to first read the
1839     // slot's contents, replace the bits taken up by the boolean, and then write
1840     // back. This is the compiler's defense against contract upgrades and
1841     // pointer aliasing, and it cannot be disabled.
1842 
1843     // The values being non-zero value makes deployment a bit more expensive,
1844     // but in exchange the refund on every call to nonReentrant will be lower in
1845     // amount. Since refunds are capped to a percentage of the total
1846     // transaction's gas, it is best to keep them low in cases like this one, to
1847     // increase the likelihood of the full refund coming into effect.
1848     uint256 private constant _NOT_ENTERED = 1;
1849     uint256 private constant _ENTERED = 2;
1850 
1851     uint256 private _status;
1852 
1853     constructor() {
1854         _status = _NOT_ENTERED;
1855     }
1856 
1857     /**
1858      * @dev Prevents a contract from calling itself, directly or indirectly.
1859      * Calling a `nonReentrant` function from another `nonReentrant`
1860      * function is not supported. It is possible to prevent this from happening
1861      * by making the `nonReentrant` function external, and making it call a
1862      * `private` function that does the actual work.
1863      */
1864     modifier nonReentrant() {
1865         // On the first call to nonReentrant, _notEntered will be true
1866         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1867 
1868         // Any calls to nonReentrant after this point will fail
1869         _status = _ENTERED;
1870 
1871         _;
1872 
1873         // By storing the original value once again, a refund is triggered (see
1874         // https://eips.ethereum.org/EIPS/eip-2200)
1875         _status = _NOT_ENTERED;
1876     }
1877 }
1878 
1879 
1880 
1881 
1882 
1883 pragma solidity ^0.8.4;
1884 
1885 
1886 error ApprovalCallerNotOwnerNorApproved();
1887 error ApprovalQueryForNonexistentToken();
1888 error ApproveToCaller();
1889 error ApprovalToCurrentOwner();
1890 error BalanceQueryForZeroAddress();
1891 error MintToZeroAddress();
1892 error MintZeroQuantity();
1893 error OwnerQueryForNonexistentToken();
1894 error TransferCallerNotOwnerNorApproved();
1895 error TransferFromIncorrectOwner();
1896 error TransferToNonERC721ReceiverImplementer();
1897 error TransferToZeroAddress();
1898 error URIQueryForNonexistentToken();
1899 
1900 /**
1901  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1902  * the Metadata extension. Built to optimize for lower gas during batch mints.
1903  *
1904  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1905  *
1906  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1907  *
1908  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1909  */
1910 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1911     using Address for address;
1912     using Strings for uint256;
1913 
1914     // Compiler will pack this into a single 256bit word.
1915     struct TokenOwnership {
1916         // The address of the owner.
1917         address addr;
1918         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1919         uint64 startTimestamp;
1920         // Whether the token has been burned.
1921         bool burned;
1922     }
1923 
1924     // Compiler will pack this into a single 256bit word.
1925     struct AddressData {
1926         // Realistically, 2**64-1 is more than enough.
1927         uint64 balance;
1928         // Keeps track of mint count with minimal overhead for tokenomics.
1929         uint64 numberMinted;
1930         // Keeps track of burn count with minimal overhead for tokenomics.
1931         uint64 numberBurned;
1932         // For miscellaneous variable(s) pertaining to the address
1933         // (e.g. number of whitelist mint slots used).
1934         // If there are multiple variables, please pack them into a uint64.
1935         uint64 aux;
1936     }
1937 
1938     // The tokenId of the next token to be minted.
1939     uint256 internal _currentIndex;
1940 
1941     // The number of tokens burned.
1942     uint256 internal _burnCounter;
1943 
1944     // Token name
1945     string private _name;
1946 
1947     // Token symbol
1948     string private _symbol;
1949 
1950     // Mapping from token ID to ownership details
1951     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1952     mapping(uint256 => TokenOwnership) internal _ownerships;
1953 
1954     // Mapping owner address to address data
1955     mapping(address => AddressData) private _addressData;
1956 
1957     // Mapping from token ID to approved address
1958     mapping(uint256 => address) private _tokenApprovals;
1959 
1960     // Mapping from owner to operator approvals
1961     mapping(address => mapping(address => bool)) private _operatorApprovals;
1962 
1963     constructor(string memory name_, string memory symbol_) {
1964         _name = name_;
1965         _symbol = symbol_;
1966         _currentIndex = _startTokenId();
1967     }
1968 
1969     /**
1970      * To change the starting tokenId, please override this function.
1971      */
1972     function _startTokenId() internal view virtual returns (uint256) {
1973         return 0;
1974     }
1975 
1976     /**
1977      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1978      */
1979     function totalSupply() public view returns (uint256) {
1980         // Counter underflow is impossible as _burnCounter cannot be incremented
1981         // more than _currentIndex - _startTokenId() times
1982         unchecked {
1983             return _currentIndex - _burnCounter - _startTokenId();
1984         }
1985     }
1986 
1987     /**
1988      * Returns the total amount of tokens minted in the contract.
1989      */
1990     function _totalMinted() internal view returns (uint256) {
1991         // Counter underflow is impossible as _currentIndex does not decrement,
1992         // and it is initialized to _startTokenId()
1993         unchecked {
1994             return _currentIndex - _startTokenId();
1995         }
1996     }
1997 
1998     /**
1999      * @dev See {IERC165-supportsInterface}.
2000      */
2001     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2002         return
2003             interfaceId == type(IERC721).interfaceId ||
2004             interfaceId == type(IERC721Metadata).interfaceId ||
2005             super.supportsInterface(interfaceId);
2006     }
2007 
2008     /**
2009      * @dev See {IERC721-balanceOf}.
2010      */
2011     function balanceOf(address owner) public view override returns (uint256) {
2012         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2013         return uint256(_addressData[owner].balance);
2014     }
2015 
2016     /**
2017      * Returns the number of tokens minted by `owner`.
2018      */
2019     function _numberMinted(address owner) internal view returns (uint256) {
2020         return uint256(_addressData[owner].numberMinted);
2021     }
2022 
2023     /**
2024      * Returns the number of tokens burned by or on behalf of `owner`.
2025      */
2026     function _numberBurned(address owner) internal view returns (uint256) {
2027         return uint256(_addressData[owner].numberBurned);
2028     }
2029 
2030     /**
2031      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2032      */
2033     function _getAux(address owner) internal view returns (uint64) {
2034         return _addressData[owner].aux;
2035     }
2036 
2037     /**
2038      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2039      * If there are multiple variables, please pack them into a uint64.
2040      */
2041     function _setAux(address owner, uint64 aux) internal {
2042         _addressData[owner].aux = aux;
2043     }
2044 
2045     /**
2046      * Gas spent here starts off proportional to the maximum mint batch size.
2047      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2048      */
2049     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2050         uint256 curr = tokenId;
2051 
2052         unchecked {
2053             if (_startTokenId() <= curr && curr < _currentIndex) {
2054                 TokenOwnership memory ownership = _ownerships[curr];
2055                 if (!ownership.burned) {
2056                     if (ownership.addr != address(0)) {
2057                         return ownership;
2058                     }
2059                     // Invariant:
2060                     // There will always be an ownership that has an address and is not burned
2061                     // before an ownership that does not have an address and is not burned.
2062                     // Hence, curr will not underflow.
2063                     while (true) {
2064                         curr--;
2065                         ownership = _ownerships[curr];
2066                         if (ownership.addr != address(0)) {
2067                             return ownership;
2068                         }
2069                     }
2070                 }
2071             }
2072         }
2073         revert OwnerQueryForNonexistentToken();
2074     }
2075 
2076     /**
2077      * @dev See {IERC721-ownerOf}.
2078      */
2079     function ownerOf(uint256 tokenId) public view override returns (address) {
2080         return _ownershipOf(tokenId).addr;
2081     }
2082 
2083     /**
2084      * @dev See {IERC721Metadata-name}.
2085      */
2086     function name() public view virtual override returns (string memory) {
2087         return _name;
2088     }
2089 
2090     /**
2091      * @dev See {IERC721Metadata-symbol}.
2092      */
2093     function symbol() public view virtual override returns (string memory) {
2094         return _symbol;
2095     }
2096 
2097     /**
2098      * @dev See {IERC721Metadata-tokenURI}.
2099      */
2100     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2101         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2102 
2103         string memory baseURI = _baseURI();
2104         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2105     }
2106 
2107     /**
2108      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2109      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2110      * by default, can be overriden in child contracts.
2111      */
2112     function _baseURI() internal view virtual returns (string memory) {
2113         return '';
2114     }
2115 
2116     /**
2117      * @dev See {IERC721-approve}.
2118      */
2119     function approve(address to, uint256 tokenId) public virtual override {
2120         address owner = ERC721A.ownerOf(tokenId);
2121         if (to == owner) revert ApprovalToCurrentOwner();
2122 
2123         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2124             revert ApprovalCallerNotOwnerNorApproved();
2125         }
2126 
2127         _approve(to, tokenId, owner);
2128     }
2129 
2130     /**
2131      * @dev See {IERC721-getApproved}.
2132      */
2133     function getApproved(uint256 tokenId) public view override returns (address) {
2134         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2135 
2136         return _tokenApprovals[tokenId];
2137     }
2138 
2139     /**
2140      * @dev See {IERC721-setApprovalForAll}.
2141      */
2142     function setApprovalForAll(address operator, bool approved) public virtual override {
2143         if (operator == _msgSender()) revert ApproveToCaller();
2144 
2145         _operatorApprovals[_msgSender()][operator] = approved;
2146         emit ApprovalForAll(_msgSender(), operator, approved);
2147     }
2148 
2149     /**
2150      * @dev See {IERC721-isApprovedForAll}.
2151      */
2152     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2153         return _operatorApprovals[owner][operator];
2154     }
2155 
2156     /**
2157      * @dev See {IERC721-transferFrom}.
2158      */
2159     function transferFrom(
2160         address from,
2161         address to,
2162         uint256 tokenId
2163     ) public virtual override {
2164         _transfer(from, to, tokenId);
2165     }
2166 
2167     /**
2168      * @dev See {IERC721-safeTransferFrom}.
2169      */
2170     function safeTransferFrom(
2171         address from,
2172         address to,
2173         uint256 tokenId
2174     ) public virtual override {
2175         safeTransferFrom(from, to, tokenId, '');
2176     }
2177 
2178     /**
2179      * @dev See {IERC721-safeTransferFrom}.
2180      */
2181     function safeTransferFrom(
2182         address from,
2183         address to,
2184         uint256 tokenId,
2185         bytes memory _data
2186     ) public virtual override {
2187         _transfer(from, to, tokenId);
2188         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2189             revert TransferToNonERC721ReceiverImplementer();
2190         }
2191     }
2192 
2193     /**
2194      * @dev Returns whether `tokenId` exists.
2195      *
2196      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2197      *
2198      * Tokens start existing when they are minted (`_mint`),
2199      */
2200     function _exists(uint256 tokenId) internal view returns (bool) {
2201         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
2202             !_ownerships[tokenId].burned;
2203     }
2204 
2205     function _safeMint(address to, uint256 quantity) internal {
2206         _safeMint(to, quantity, '');
2207     }
2208 
2209     /**
2210      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2211      *
2212      * Requirements:
2213      *
2214      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2215      * - `quantity` must be greater than 0.
2216      *
2217      * Emits a {Transfer} event.
2218      */
2219     function _safeMint(
2220         address to,
2221         uint256 quantity,
2222         bytes memory _data
2223     ) internal {
2224         _mint(to, quantity, _data, true);
2225     }
2226 
2227     /**
2228      * @dev Mints `quantity` tokens and transfers them to `to`.
2229      *
2230      * Requirements:
2231      *
2232      * - `to` cannot be the zero address.
2233      * - `quantity` must be greater than 0.
2234      *
2235      * Emits a {Transfer} event.
2236      */
2237     function _mint(
2238         address to,
2239         uint256 quantity,
2240         bytes memory _data,
2241         bool safe
2242     ) internal {
2243         uint256 startTokenId = _currentIndex;
2244         if (to == address(0)) revert MintToZeroAddress();
2245         if (quantity == 0) revert MintZeroQuantity();
2246 
2247         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2248 
2249         // Overflows are incredibly unrealistic.
2250         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2251         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2252         unchecked {
2253             _addressData[to].balance += uint64(quantity);
2254             _addressData[to].numberMinted += uint64(quantity);
2255 
2256             _ownerships[startTokenId].addr = to;
2257             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2258 
2259             uint256 updatedIndex = startTokenId;
2260             uint256 end = updatedIndex + quantity;
2261 
2262             if (safe && to.isContract()) {
2263                 do {
2264                     emit Transfer(address(0), to, updatedIndex);
2265                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2266                         revert TransferToNonERC721ReceiverImplementer();
2267                     }
2268                 } while (updatedIndex != end);
2269                 // Reentrancy protection
2270                 if (_currentIndex != startTokenId) revert();
2271             } else {
2272                 do {
2273                     emit Transfer(address(0), to, updatedIndex++);
2274                 } while (updatedIndex != end);
2275             }
2276             _currentIndex = updatedIndex;
2277         }
2278         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2279     }
2280 
2281     /**
2282      * @dev Transfers `tokenId` from `from` to `to`.
2283      *
2284      * Requirements:
2285      *
2286      * - `to` cannot be the zero address.
2287      * - `tokenId` token must be owned by `from`.
2288      *
2289      * Emits a {Transfer} event.
2290      */
2291     function _transfer(
2292         address from,
2293         address to,
2294         uint256 tokenId
2295     ) private {
2296         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2297 
2298         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2299 
2300         bool isApprovedOrOwner = (_msgSender() == from ||
2301             isApprovedForAll(from, _msgSender()) ||
2302             getApproved(tokenId) == _msgSender());
2303 
2304         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2305         if (to == address(0)) revert TransferToZeroAddress();
2306 
2307         _beforeTokenTransfers(from, to, tokenId, 1);
2308 
2309         // Clear approvals from the previous owner
2310         _approve(address(0), tokenId, from);
2311 
2312         // Underflow of the sender's balance is impossible because we check for
2313         // ownership above and the recipient's balance can't realistically overflow.
2314         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2315         unchecked {
2316             _addressData[from].balance -= 1;
2317             _addressData[to].balance += 1;
2318 
2319             TokenOwnership storage currSlot = _ownerships[tokenId];
2320             currSlot.addr = to;
2321             currSlot.startTimestamp = uint64(block.timestamp);
2322 
2323             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2324             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2325             uint256 nextTokenId = tokenId + 1;
2326             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2327             if (nextSlot.addr == address(0)) {
2328                 // This will suffice for checking _exists(nextTokenId),
2329                 // as a burned slot cannot contain the zero address.
2330                 if (nextTokenId != _currentIndex) {
2331                     nextSlot.addr = from;
2332                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2333                 }
2334             }
2335         }
2336 
2337         emit Transfer(from, to, tokenId);
2338         _afterTokenTransfers(from, to, tokenId, 1);
2339     }
2340 
2341     /**
2342      * @dev This is equivalent to _burn(tokenId, false)
2343      */
2344     function _burn(uint256 tokenId) internal virtual {
2345         _burn(tokenId, false);
2346     }
2347 
2348     /**
2349      * @dev Destroys `tokenId`.
2350      * The approval is cleared when the token is burned.
2351      *
2352      * Requirements:
2353      *
2354      * - `tokenId` must exist.
2355      *
2356      * Emits a {Transfer} event.
2357      */
2358     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2359         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2360 
2361         address from = prevOwnership.addr;
2362 
2363         if (approvalCheck) {
2364             bool isApprovedOrOwner = (_msgSender() == from ||
2365                 isApprovedForAll(from, _msgSender()) ||
2366                 getApproved(tokenId) == _msgSender());
2367 
2368             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2369         }
2370 
2371         _beforeTokenTransfers(from, address(0), tokenId, 1);
2372 
2373         // Clear approvals from the previous owner
2374         _approve(address(0), tokenId, from);
2375 
2376         // Underflow of the sender's balance is impossible because we check for
2377         // ownership above and the recipient's balance can't realistically overflow.
2378         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2379         unchecked {
2380             AddressData storage addressData = _addressData[from];
2381             addressData.balance -= 1;
2382             addressData.numberBurned += 1;
2383 
2384             // Keep track of who burned the token, and the timestamp of burning.
2385             TokenOwnership storage currSlot = _ownerships[tokenId];
2386             currSlot.addr = from;
2387             currSlot.startTimestamp = uint64(block.timestamp);
2388             currSlot.burned = true;
2389 
2390             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2391             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2392             uint256 nextTokenId = tokenId + 1;
2393             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2394             if (nextSlot.addr == address(0)) {
2395                 // This will suffice for checking _exists(nextTokenId),
2396                 // as a burned slot cannot contain the zero address.
2397                 if (nextTokenId != _currentIndex) {
2398                     nextSlot.addr = from;
2399                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2400                 }
2401             }
2402         }
2403 
2404         emit Transfer(from, address(0), tokenId);
2405         _afterTokenTransfers(from, address(0), tokenId, 1);
2406 
2407         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2408         unchecked {
2409             _burnCounter++;
2410         }
2411     }
2412 
2413     /**
2414      * @dev Approve `to` to operate on `tokenId`
2415      *
2416      * Emits a {Approval} event.
2417      */
2418     function _approve(
2419         address to,
2420         uint256 tokenId,
2421         address owner
2422     ) private {
2423         _tokenApprovals[tokenId] = to;
2424         emit Approval(owner, to, tokenId);
2425     }
2426 
2427     /**
2428      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2429      *
2430      * @param from address representing the previous owner of the given token ID
2431      * @param to target address that will receive the tokens
2432      * @param tokenId uint256 ID of the token to be transferred
2433      * @param _data bytes optional data to send along with the call
2434      * @return bool whether the call correctly returned the expected magic value
2435      */
2436     function _checkContractOnERC721Received(
2437         address from,
2438         address to,
2439         uint256 tokenId,
2440         bytes memory _data
2441     ) private returns (bool) {
2442         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2443             return retval == IERC721Receiver(to).onERC721Received.selector;
2444         } catch (bytes memory reason) {
2445             if (reason.length == 0) {
2446                 revert TransferToNonERC721ReceiverImplementer();
2447             } else {
2448                 assembly {
2449                     revert(add(32, reason), mload(reason))
2450                 }
2451             }
2452         }
2453     }
2454 
2455     /**
2456      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2457      * And also called before burning one token.
2458      *
2459      * startTokenId - the first token id to be transferred
2460      * quantity - the amount to be transferred
2461      *
2462      * Calling conditions:
2463      *
2464      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2465      * transferred to `to`.
2466      * - When `from` is zero, `tokenId` will be minted for `to`.
2467      * - When `to` is zero, `tokenId` will be burned by `from`.
2468      * - `from` and `to` are never both zero.
2469      */
2470     function _beforeTokenTransfers(
2471         address from,
2472         address to,
2473         uint256 startTokenId,
2474         uint256 quantity
2475     ) internal virtual {}
2476 
2477     /**
2478      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2479      * minting.
2480      * And also called after one token has been burned.
2481      *
2482      * startTokenId - the first token id to be transferred
2483      * quantity - the amount to be transferred
2484      *
2485      * Calling conditions:
2486      *
2487      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2488      * transferred to `to`.
2489      * - When `from` is zero, `tokenId` has been minted for `to`.
2490      * - When `to` is zero, `tokenId` has been burned by `from`.
2491      * - `from` and `to` are never both zero.
2492      */
2493     function _afterTokenTransfers(
2494         address from,
2495         address to,
2496         uint256 startTokenId,
2497         uint256 quantity
2498     ) internal virtual {}
2499 }
2500 
2501 
2502 
2503 
2504 pragma solidity ^0.8.13;
2505 
2506 interface IOperatorFilterRegistry {
2507     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2508     function register(address registrant) external;
2509     function registerAndSubscribe(address registrant, address subscription) external;
2510     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2511     function unregister(address addr) external;
2512     function updateOperator(address registrant, address operator, bool filtered) external;
2513     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2514     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2515     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2516     function subscribe(address registrant, address registrantToSubscribe) external;
2517     function unsubscribe(address registrant, bool copyExistingEntries) external;
2518     function subscriptionOf(address addr) external returns (address registrant);
2519     function subscribers(address registrant) external returns (address[] memory);
2520     function subscriberAt(address registrant, uint256 index) external returns (address);
2521     function copyEntriesOf(address registrant, address registrantToCopy) external;
2522     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2523     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2524     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2525     function filteredOperators(address addr) external returns (address[] memory);
2526     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2527     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2528     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2529     function isRegistered(address addr) external returns (bool);
2530     function codeHashOf(address addr) external returns (bytes32);
2531 }
2532 
2533 pragma solidity ^0.8.13;
2534 
2535 //import {IOperatorFilterRegistry} from "./IOperatorFilterRegistry.sol";
2536 
2537 /**
2538  * @title  OperatorFilterer
2539  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2540  *         registrant's entries in the OperatorFilterRegistry.
2541  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2542  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2543  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2544  */
2545 abstract contract OperatorFilterer {
2546     error OperatorNotAllowed(address operator);
2547 
2548     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2549         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2550 
2551     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2552         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2553         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2554         // order for the modifier to filter addresses.
2555         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2556             if (subscribe) {
2557                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2558             } else {
2559                 if (subscriptionOrRegistrantToCopy != address(0)) {
2560                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2561                 } else {
2562                     OPERATOR_FILTER_REGISTRY.register(address(this));
2563                 }
2564             }
2565         }
2566     }
2567 
2568     modifier onlyAllowedOperator(address from) virtual {
2569         // Check registry code length to facilitate testing in environments without a deployed registry.
2570         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2571             // Allow spending tokens from addresses with balance
2572             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2573             // from an EOA.
2574             if (from == msg.sender) {
2575                 _;
2576                 return;
2577             }
2578             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
2579                 revert OperatorNotAllowed(msg.sender);
2580             }
2581         }
2582         _;
2583     }
2584 
2585     modifier onlyAllowedOperatorApproval(address operator) virtual {
2586         // Check registry code length to facilitate testing in environments without a deployed registry.
2587         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2588             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2589                 revert OperatorNotAllowed(operator);
2590             }
2591         }
2592         _;
2593     }
2594 }
2595 
2596 pragma solidity ^0.8.13;
2597 
2598 //import {OperatorFilterer} from "./OperatorFilterer.sol";
2599 
2600 /**
2601  * @title  DefaultOperatorFilterer
2602  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2603  */
2604 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2605     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2606 
2607     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2608 }
2609 
2610 
2611 
2612 contract QuacksQQ is ERC721A, ReentrancyGuard, Ownable,  DefaultOperatorFilterer {
2613     using Strings for uint256;
2614 
2615     // Minting Variables
2616     uint256 public mintPrice = 0.0005 ether;
2617     uint256 public maxPurchase = 80;
2618     uint256 public maxSupply = 16027;
2619 
2620 
2621     // Sale Status
2622     bool public saleIsActive = false;
2623 
2624 
2625     // mappings
2626     mapping(address => uint) public addressesThatMinted;
2627     mapping(uint256 => uint256) public tokenIdLevels;
2628     mapping(uint256 => uint256) public tokenIdBurnedBy;
2629     mapping(uint => string) public levelBaseTokenURIs;
2630 
2631 
2632     // Metadata
2633     string _baseTokenURI = "ipfs://bafybeicld43chptveq6ysonrrmbde5lc5zmhdkynm7nge6kfmxwf4ojtrm/";
2634 
2635     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2636         super.setApprovalForAll(operator, approved);
2637     }
2638 
2639     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2640         super.approve(operator, tokenId);
2641     }
2642 
2643     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2644         super.transferFrom(from, to, tokenId);
2645     }
2646 
2647     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2648         super.safeTransferFrom(from, to, tokenId);
2649     }
2650 
2651     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2652         public
2653         override
2654         onlyAllowedOperator(from)
2655     {
2656         super.safeTransferFrom(from, to, tokenId, data);
2657     }
2658 
2659     // Events
2660     event SaleActivation(bool isActive);
2661 
2662 
2663     constructor() ERC721A("Quacks QQ", "QUACKS") {
2664     }
2665 
2666 
2667     // Minting
2668     function ownerMint(address _to, uint256 _count) external onlyOwner {
2669         require(
2670             totalSupply() + _count <= maxSupply,
2671             "SOLD_OUT"
2672         );
2673         _safeMint(_to, _count);
2674     }
2675 
2676    
2677     function mint(uint256 _count) external payable nonReentrant {
2678         require(saleIsActive, "SALE_INACTIVE");
2679         require(((addressesThatMinted[msg.sender] + _count) ) <= maxPurchase , "this would exceed mint max allowance");
2680 
2681         require(
2682             totalSupply() + _count <= maxSupply,
2683             "SOLD_OUT"
2684         );
2685         require(
2686             mintPrice * _count <= msg.value,
2687             "INCORRECT_ETHER_VALUE"
2688         );
2689 
2690             _safeMint(msg.sender, _count);
2691             addressesThatMinted[msg.sender] += _count;
2692         }
2693 
2694 
2695     function toggleSaleStatus() external onlyOwner {
2696         saleIsActive = !saleIsActive;
2697         emit SaleActivation(saleIsActive);
2698     }
2699 
2700     function setMintPrice(uint256 _mintPrice) external onlyOwner {
2701         mintPrice = _mintPrice;
2702     }
2703 
2704 
2705     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
2706         maxPurchase = _maxPurchase;
2707     }
2708 
2709     function withdraw() external onlyOwner {
2710         payable(owner()).transfer(address(this).balance);
2711     }
2712 
2713     function burnAndCombine(
2714         uint256 _tokenID,
2715         uint256[] calldata tokenIds
2716     )
2717     external payable  {
2718 
2719         bool check = false;
2720         bool check2 = false;
2721         require(tokenIds.length == 2);
2722         require(ownerOf(_tokenID) == msg.sender, "NOT_TOKEN_OWNER");
2723         for (uint256 i; i < tokenIds.length; i++) {
2724             require(ownerOf(tokenIds[i]) == msg.sender, "NOT_TOKEN_OWNER");
2725             require(tokenIdLevels[tokenIds[i]] == tokenIdLevels[_tokenID], "Tokens are not right level");
2726             if (tokenIds[i] == _tokenID) {
2727                 check = true;
2728             }
2729             else {
2730                 check2 = true;
2731             }
2732             
2733         }
2734         require(check == true, "tokenID param not in token array param");
2735         require(check2 == true, "no burn token in token array param");
2736         for (uint256 i; i < tokenIds.length; i++) {
2737             if (tokenIds[i] != _tokenID) {
2738                 _burn(tokenIds[i],false);
2739                 tokenIdBurnedBy[tokenIds[i]] = _tokenID;
2740             
2741             }
2742             else {
2743                 tokenIdLevels[tokenIds[i]] += 1;
2744             }
2745             
2746         }
2747    
2748     }
2749 
2750     function getWalletOfOwner(address owner) external view returns (uint256[] memory) {
2751     unchecked {
2752         uint256[] memory a = new uint256[](balanceOf(owner));
2753         uint256 end = _currentIndex;
2754         uint256 tokenIdsIdx;
2755         address currOwnershipAddr;
2756         for (uint256 i; i < end; i++) {
2757             TokenOwnership memory ownership = _ownerships[i];
2758             if (ownership.burned) {
2759                 continue;
2760             }
2761             if (ownership.addr != address(0)) {
2762                 currOwnershipAddr = ownership.addr;
2763             }
2764             if (currOwnershipAddr == owner) {
2765                 a[tokenIdsIdx++] = i;
2766             }
2767         }
2768         return a;
2769     }
2770     }
2771 
2772     function getTotalSupply() external view returns (uint256) {
2773         return totalSupply();
2774     }
2775 
2776     function setBaseURI(string memory baseURI) external onlyOwner {
2777         _baseTokenURI = baseURI;
2778     }
2779 
2780     function _baseURI() internal view virtual override returns (string memory) {
2781         return _baseTokenURI;
2782     }
2783 
2784     function setTokenLevelsURI(string memory baseURI, uint256 level) external onlyOwner {
2785         levelBaseTokenURIs[level] = baseURI;
2786     }
2787 
2788 //    function tokenURI(uint256 tokenId) public view override returns (string memory){
2789 //         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2790         
2791 //     }
2792 
2793     function tokenURI(uint256 tokenId) public view override returns (string memory){
2794         // return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2795         string memory token_str = tokenId.toString();
2796         if (tokenIdLevels[tokenId] > 0) {
2797             return string(abi.encodePacked(levelBaseTokenURIs[tokenIdLevels[tokenId]],token_str, ".json"));
2798         }
2799         else {
2800             return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2801         }
2802     }
2803 
2804     function _startTokenId() internal view virtual override returns (uint256){
2805         return 1;
2806     }
2807 
2808 
2809 }