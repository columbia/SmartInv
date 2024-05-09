1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Interface of the ERC165 standard, as defined in the
97  * https://eips.ethereum.org/EIPS/eip-165[EIP].
98  *
99  * Implementers can declare support of contract interfaces, which can then be
100  * queried by others ({ERC165Checker}).
101  *
102  * For an implementation, see {ERC165}.
103  */
104 interface IERC165 {
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 }
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
120  */
121 interface IAccessControlEnumerable is IAccessControl {
122     /**
123      * @dev Returns one of the accounts that have `role`. `index` must be a
124      * value between 0 and {getRoleMemberCount}, non-inclusive.
125      *
126      * Role bearers are not sorted in any particular way, and their ordering may
127      * change at any point.
128      *
129      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
130      * you perform all queries on the same block. See the following
131      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
132      * for more information.
133      */
134     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
135 
136     /**
137      * @dev Returns the number of accounts that have `role`. Can be used
138      * together with {getRoleMember} to enumerate all bearers of a role.
139      */
140     function getRoleMemberCount(bytes32 role) external view returns (uint256);
141 }
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Library for managing
147  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
148  * types.
149  *
150  * Sets have the following properties:
151  *
152  * - Elements are added, removed, and checked for existence in constant time
153  * (O(1)).
154  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
155  *
156  * ```
157  * contract Example {
158  *     // Add the library methods
159  *     using EnumerableSet for EnumerableSet.AddressSet;
160  *
161  *     // Declare a set state variable
162  *     EnumerableSet.AddressSet private mySet;
163  * }
164  * ```
165  *
166  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
167  * and `uint256` (`UintSet`) are supported.
168  */
169 library EnumerableSet {
170     // To implement this library for multiple types with as little code
171     // repetition as possible, we write it in terms of a generic Set type with
172     // bytes32 values.
173     // The Set implementation uses private functions, and user-facing
174     // implementations (such as AddressSet) are just wrappers around the
175     // underlying Set.
176     // This means that we can only create new EnumerableSets for types that fit
177     // in bytes32.
178 
179     struct Set {
180         // Storage of set values
181         bytes32[] _values;
182         // Position of the value in the `values` array, plus 1 because index 0
183         // means a value is not in the set.
184         mapping(bytes32 => uint256) _indexes;
185     }
186 
187     /**
188      * @dev Add a value to a set. O(1).
189      *
190      * Returns true if the value was added to the set, that is if it was not
191      * already present.
192      */
193     function _add(Set storage set, bytes32 value) private returns (bool) {
194         if (!_contains(set, value)) {
195             set._values.push(value);
196             // The value is stored at length-1, but we add 1 to all indexes
197             // and use 0 as a sentinel value
198             set._indexes[value] = set._values.length;
199             return true;
200         } else {
201             return false;
202         }
203     }
204 
205     /**
206      * @dev Removes a value from a set. O(1).
207      *
208      * Returns true if the value was removed from the set, that is if it was
209      * present.
210      */
211     function _remove(Set storage set, bytes32 value) private returns (bool) {
212         // We read and store the value's index to prevent multiple reads from the same storage slot
213         uint256 valueIndex = set._indexes[value];
214 
215         if (valueIndex != 0) {
216             // Equivalent to contains(set, value)
217             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
218             // the array, and then remove the last element (sometimes called as 'swap and pop').
219             // This modifies the order of the array, as noted in {at}.
220 
221             uint256 toDeleteIndex = valueIndex - 1;
222             uint256 lastIndex = set._values.length - 1;
223 
224             if (lastIndex != toDeleteIndex) {
225                 bytes32 lastvalue = set._values[lastIndex];
226 
227                 // Move the last value to the index where the value to delete is
228                 set._values[toDeleteIndex] = lastvalue;
229                 // Update the index for the moved value
230                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
231             }
232 
233             // Delete the slot where the moved value was stored
234             set._values.pop();
235 
236             // Delete the index for the deleted slot
237             delete set._indexes[value];
238 
239             return true;
240         } else {
241             return false;
242         }
243     }
244 
245     /**
246      * @dev Returns true if the value is in the set. O(1).
247      */
248     function _contains(Set storage set, bytes32 value) private view returns (bool) {
249         return set._indexes[value] != 0;
250     }
251 
252     /**
253      * @dev Returns the number of values on the set. O(1).
254      */
255     function _length(Set storage set) private view returns (uint256) {
256         return set._values.length;
257     }
258 
259     /**
260      * @dev Returns the value stored at position `index` in the set. O(1).
261      *
262      * Note that there are no guarantees on the ordering of values inside the
263      * array, and it may change when more values are added or removed.
264      *
265      * Requirements:
266      *
267      * - `index` must be strictly less than {length}.
268      */
269     function _at(Set storage set, uint256 index) private view returns (bytes32) {
270         return set._values[index];
271     }
272 
273     /**
274      * @dev Return the entire set in an array
275      *
276      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
277      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
278      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
279      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
280      */
281     function _values(Set storage set) private view returns (bytes32[] memory) {
282         return set._values;
283     }
284 
285     // Bytes32Set
286 
287     struct Bytes32Set {
288         Set _inner;
289     }
290 
291     /**
292      * @dev Add a value to a set. O(1).
293      *
294      * Returns true if the value was added to the set, that is if it was not
295      * already present.
296      */
297     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
298         return _add(set._inner, value);
299     }
300 
301     /**
302      * @dev Removes a value from a set. O(1).
303      *
304      * Returns true if the value was removed from the set, that is if it was
305      * present.
306      */
307     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
308         return _remove(set._inner, value);
309     }
310 
311     /**
312      * @dev Returns true if the value is in the set. O(1).
313      */
314     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
315         return _contains(set._inner, value);
316     }
317 
318     /**
319      * @dev Returns the number of values in the set. O(1).
320      */
321     function length(Bytes32Set storage set) internal view returns (uint256) {
322         return _length(set._inner);
323     }
324 
325     /**
326      * @dev Returns the value stored at position `index` in the set. O(1).
327      *
328      * Note that there are no guarantees on the ordering of values inside the
329      * array, and it may change when more values are added or removed.
330      *
331      * Requirements:
332      *
333      * - `index` must be strictly less than {length}.
334      */
335     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
336         return _at(set._inner, index);
337     }
338 
339     /**
340      * @dev Return the entire set in an array
341      *
342      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
343      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
344      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
345      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
346      */
347     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
348         return _values(set._inner);
349     }
350 
351     // AddressSet
352 
353     struct AddressSet {
354         Set _inner;
355     }
356 
357     /**
358      * @dev Add a value to a set. O(1).
359      *
360      * Returns true if the value was added to the set, that is if it was not
361      * already present.
362      */
363     function add(AddressSet storage set, address value) internal returns (bool) {
364         return _add(set._inner, bytes32(uint256(uint160(value))));
365     }
366 
367     /**
368      * @dev Removes a value from a set. O(1).
369      *
370      * Returns true if the value was removed from the set, that is if it was
371      * present.
372      */
373     function remove(AddressSet storage set, address value) internal returns (bool) {
374         return _remove(set._inner, bytes32(uint256(uint160(value))));
375     }
376 
377     /**
378      * @dev Returns true if the value is in the set. O(1).
379      */
380     function contains(AddressSet storage set, address value) internal view returns (bool) {
381         return _contains(set._inner, bytes32(uint256(uint160(value))));
382     }
383 
384     /**
385      * @dev Returns the number of values in the set. O(1).
386      */
387     function length(AddressSet storage set) internal view returns (uint256) {
388         return _length(set._inner);
389     }
390 
391     /**
392      * @dev Returns the value stored at position `index` in the set. O(1).
393      *
394      * Note that there are no guarantees on the ordering of values inside the
395      * array, and it may change when more values are added or removed.
396      *
397      * Requirements:
398      *
399      * - `index` must be strictly less than {length}.
400      */
401     function at(AddressSet storage set, uint256 index) internal view returns (address) {
402         return address(uint160(uint256(_at(set._inner, index))));
403     }
404 
405     /**
406      * @dev Return the entire set in an array
407      *
408      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
409      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
410      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
411      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
412      */
413     function values(AddressSet storage set) internal view returns (address[] memory) {
414         bytes32[] memory store = _values(set._inner);
415         address[] memory result;
416 
417         assembly {
418             result := store
419         }
420 
421         return result;
422     }
423 
424     // UintSet
425 
426     struct UintSet {
427         Set _inner;
428     }
429 
430     /**
431      * @dev Add a value to a set. O(1).
432      *
433      * Returns true if the value was added to the set, that is if it was not
434      * already present.
435      */
436     function add(UintSet storage set, uint256 value) internal returns (bool) {
437         return _add(set._inner, bytes32(value));
438     }
439 
440     /**
441      * @dev Removes a value from a set. O(1).
442      *
443      * Returns true if the value was removed from the set, that is if it was
444      * present.
445      */
446     function remove(UintSet storage set, uint256 value) internal returns (bool) {
447         return _remove(set._inner, bytes32(value));
448     }
449 
450     /**
451      * @dev Returns true if the value is in the set. O(1).
452      */
453     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
454         return _contains(set._inner, bytes32(value));
455     }
456 
457     /**
458      * @dev Returns the number of values on the set. O(1).
459      */
460     function length(UintSet storage set) internal view returns (uint256) {
461         return _length(set._inner);
462     }
463 
464     /**
465      * @dev Returns the value stored at position `index` in the set. O(1).
466      *
467      * Note that there are no guarantees on the ordering of values inside the
468      * array, and it may change when more values are added or removed.
469      *
470      * Requirements:
471      *
472      * - `index` must be strictly less than {length}.
473      */
474     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
475         return uint256(_at(set._inner, index));
476     }
477 
478     /**
479      * @dev Return the entire set in an array
480      *
481      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
482      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
483      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
484      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
485      */
486     function values(UintSet storage set) internal view returns (uint256[] memory) {
487         bytes32[] memory store = _values(set._inner);
488         uint256[] memory result;
489 
490         assembly {
491             result := store
492         }
493 
494         return result;
495     }
496 }
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Required interface of an ERC721 compliant contract.
502  */
503 interface IERC721 is IERC165 {
504     /**
505      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
506      */
507     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
511      */
512     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
513 
514     /**
515      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
516      */
517     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
518 
519     /**
520      * @dev Returns the number of tokens in ``owner``'s account.
521      */
522     function balanceOf(address owner) external view returns (uint256 balance);
523 
524     /**
525      * @dev Returns the owner of the `tokenId` token.
526      *
527      * Requirements:
528      *
529      * - `tokenId` must exist.
530      */
531     function ownerOf(uint256 tokenId) external view returns (address owner);
532 
533     /**
534      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
535      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
536      *
537      * Requirements:
538      *
539      * - `from` cannot be the zero address.
540      * - `to` cannot be the zero address.
541      * - `tokenId` token must exist and be owned by `from`.
542      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
544      *
545      * Emits a {Transfer} event.
546      */
547     function safeTransferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Transfers `tokenId` token from `from` to `to`.
555      *
556      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
557      *
558      * Requirements:
559      *
560      * - `from` cannot be the zero address.
561      * - `to` cannot be the zero address.
562      * - `tokenId` token must be owned by `from`.
563      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
564      *
565      * Emits a {Transfer} event.
566      */
567     function transferFrom(
568         address from,
569         address to,
570         uint256 tokenId
571     ) external;
572 
573     /**
574      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
575      * The approval is cleared when the token is transferred.
576      *
577      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
578      *
579      * Requirements:
580      *
581      * - The caller must own the token or be an approved operator.
582      * - `tokenId` must exist.
583      *
584      * Emits an {Approval} event.
585      */
586     function approve(address to, uint256 tokenId) external;
587 
588     /**
589      * @dev Returns the account approved for `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function getApproved(uint256 tokenId) external view returns (address operator);
596 
597     /**
598      * @dev Approve or remove `operator` as an operator for the caller.
599      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
600      *
601      * Requirements:
602      *
603      * - The `operator` cannot be the caller.
604      *
605      * Emits an {ApprovalForAll} event.
606      */
607     function setApprovalForAll(address operator, bool _approved) external;
608 
609     /**
610      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
611      *
612      * See {setApprovalForAll}
613      */
614     function isApprovedForAll(address owner, address operator) external view returns (bool);
615 
616     /**
617      * @dev Safely transfers `tokenId` token from `from` to `to`.
618      *
619      * Requirements:
620      *
621      * - `from` cannot be the zero address.
622      * - `to` cannot be the zero address.
623      * - `tokenId` token must exist and be owned by `from`.
624      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
626      *
627      * Emits a {Transfer} event.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes calldata data
634     ) external;
635 }
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
641  * @dev See https://eips.ethereum.org/EIPS/eip-721
642  */
643 interface IERC721Enumerable is IERC721 {
644     /**
645      * @dev Returns the total amount of tokens stored by the contract.
646      */
647     function totalSupply() external view returns (uint256);
648 
649     /**
650      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
651      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
652      */
653     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
654 
655     /**
656      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
657      * Use along with {totalSupply} to enumerate all tokens.
658      */
659     function tokenByIndex(uint256 index) external view returns (uint256);
660 }
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @title ERC721 token receiver interface
666  * @dev Interface for any contract that wants to support safeTransfers
667  * from ERC721 asset contracts.
668  */
669 interface IERC721Receiver {
670     /**
671      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
672      * by `operator` from `from`, this function is called.
673      *
674      * It must return its Solidity selector to confirm the token transfer.
675      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
676      *
677      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
678      */
679     function onERC721Received(
680         address operator,
681         address from,
682         uint256 tokenId,
683         bytes calldata data
684     ) external returns (bytes4);
685 }
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
691  * @dev See https://eips.ethereum.org/EIPS/eip-721
692  */
693 interface IERC721Metadata is IERC721 {
694     /**
695      * @dev Returns the token collection name.
696      */
697     function name() external view returns (string memory);
698 
699     /**
700      * @dev Returns the token collection symbol.
701      */
702     function symbol() external view returns (string memory);
703 
704     /**
705      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
706      */
707     function tokenURI(uint256 tokenId) external view returns (string memory);
708 }
709 
710 pragma solidity ^0.8.0;
711 
712 /**
713  * @dev Collection of functions related to the address type
714  */
715 library Address {
716     /**
717      * @dev Returns true if `account` is a contract.
718      *
719      * [IMPORTANT]
720      * ====
721      * It is unsafe to assume that an address for which this function returns
722      * false is an externally-owned account (EOA) and not a contract.
723      *
724      * Among others, `isContract` will return false for the following
725      * types of addresses:
726      *
727      *  - an externally-owned account
728      *  - a contract in construction
729      *  - an address where a contract will be created
730      *  - an address where a contract lived, but was destroyed
731      * ====
732      */
733     function isContract(address account) internal view returns (bool) {
734         // This method relies on extcodesize, which returns 0 for contracts in
735         // construction, since the code is only stored at the end of the
736         // constructor execution.
737 
738         uint256 size;
739         assembly {
740             size := extcodesize(account)
741         }
742         return size > 0;
743     }
744 
745     /**
746      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
747      * `recipient`, forwarding all available gas and reverting on errors.
748      *
749      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
750      * of certain opcodes, possibly making contracts go over the 2300 gas limit
751      * imposed by `transfer`, making them unable to receive funds via
752      * `transfer`. {sendValue} removes this limitation.
753      *
754      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
755      *
756      * IMPORTANT: because control is transferred to `recipient`, care must be
757      * taken to not create reentrancy vulnerabilities. Consider using
758      * {ReentrancyGuard} or the
759      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
760      */
761     function sendValue(address payable recipient, uint256 amount) internal {
762         require(address(this).balance >= amount, "Address: insufficient balance");
763 
764         (bool success, ) = recipient.call{value: amount}("");
765         require(success, "Address: unable to send value, recipient may have reverted");
766     }
767 
768     /**
769      * @dev Performs a Solidity function call using a low level `call`. A
770      * plain `call` is an unsafe replacement for a function call: use this
771      * function instead.
772      *
773      * If `target` reverts with a revert reason, it is bubbled up by this
774      * function (like regular Solidity function calls).
775      *
776      * Returns the raw returned data. To convert to the expected return value,
777      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
778      *
779      * Requirements:
780      *
781      * - `target` must be a contract.
782      * - calling `target` with `data` must not revert.
783      *
784      * _Available since v3.1._
785      */
786     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
787         return functionCall(target, data, "Address: low-level call failed");
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
792      * `errorMessage` as a fallback revert reason when `target` reverts.
793      *
794      * _Available since v3.1._
795      */
796     function functionCall(
797         address target,
798         bytes memory data,
799         string memory errorMessage
800     ) internal returns (bytes memory) {
801         return functionCallWithValue(target, data, 0, errorMessage);
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
806      * but also transferring `value` wei to `target`.
807      *
808      * Requirements:
809      *
810      * - the calling contract must have an ETH balance of at least `value`.
811      * - the called Solidity function must be `payable`.
812      *
813      * _Available since v3.1._
814      */
815     function functionCallWithValue(
816         address target,
817         bytes memory data,
818         uint256 value
819     ) internal returns (bytes memory) {
820         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
825      * with `errorMessage` as a fallback revert reason when `target` reverts.
826      *
827      * _Available since v3.1._
828      */
829     function functionCallWithValue(
830         address target,
831         bytes memory data,
832         uint256 value,
833         string memory errorMessage
834     ) internal returns (bytes memory) {
835         require(address(this).balance >= value, "Address: insufficient balance for call");
836         require(isContract(target), "Address: call to non-contract");
837 
838         (bool success, bytes memory returndata) = target.call{value: value}(data);
839         return verifyCallResult(success, returndata, errorMessage);
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
844      * but performing a static call.
845      *
846      * _Available since v3.3._
847      */
848     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
849         return functionStaticCall(target, data, "Address: low-level static call failed");
850     }
851 
852     /**
853      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
854      * but performing a static call.
855      *
856      * _Available since v3.3._
857      */
858     function functionStaticCall(
859         address target,
860         bytes memory data,
861         string memory errorMessage
862     ) internal view returns (bytes memory) {
863         require(isContract(target), "Address: static call to non-contract");
864 
865         (bool success, bytes memory returndata) = target.staticcall(data);
866         return verifyCallResult(success, returndata, errorMessage);
867     }
868 
869     /**
870      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
871      * but performing a delegate call.
872      *
873      * _Available since v3.4._
874      */
875     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
876         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
877     }
878 
879     /**
880      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
881      * but performing a delegate call.
882      *
883      * _Available since v3.4._
884      */
885     function functionDelegateCall(
886         address target,
887         bytes memory data,
888         string memory errorMessage
889     ) internal returns (bytes memory) {
890         require(isContract(target), "Address: delegate call to non-contract");
891 
892         (bool success, bytes memory returndata) = target.delegatecall(data);
893         return verifyCallResult(success, returndata, errorMessage);
894     }
895 
896     /**
897      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
898      * revert reason using the provided one.
899      *
900      * _Available since v4.3._
901      */
902     function verifyCallResult(
903         bool success,
904         bytes memory returndata,
905         string memory errorMessage
906     ) internal pure returns (bytes memory) {
907         if (success) {
908             return returndata;
909         } else {
910             // Look for revert reason and bubble it up if present
911             if (returndata.length > 0) {
912                 // The easiest way to bubble the revert reason is using memory via assembly
913 
914                 assembly {
915                     let returndata_size := mload(returndata)
916                     revert(add(32, returndata), returndata_size)
917                 }
918             } else {
919                 revert(errorMessage);
920             }
921         }
922     }
923 }
924 
925 pragma solidity ^0.8.0;
926 
927 /**
928  * @dev Provides information about the current execution context, including the
929  * sender of the transaction and its data. While these are generally available
930  * via msg.sender and msg.data, they should not be accessed in such a direct
931  * manner, since when dealing with meta-transactions the account sending and
932  * paying for execution may not be the actual sender (as far as an application
933  * is concerned).
934  *
935  * This contract is only required for intermediate, library-like contracts.
936  */
937 abstract contract Context {
938     function _msgSender() internal view virtual returns (address) {
939         return msg.sender;
940     }
941 
942     function _msgData() internal view virtual returns (bytes calldata) {
943         return msg.data;
944     }
945 }
946 
947 pragma solidity ^0.8.0;
948 
949 /**
950  * @dev String operations.
951  */
952 library Strings {
953     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
954 
955     /**
956      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
957      */
958     function toString(uint256 value) internal pure returns (string memory) {
959         // Inspired by OraclizeAPI's implementation - MIT licence
960         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
961 
962         if (value == 0) {
963             return "0";
964         }
965         uint256 temp = value;
966         uint256 digits;
967         while (temp != 0) {
968             digits++;
969             temp /= 10;
970         }
971         bytes memory buffer = new bytes(digits);
972         while (value != 0) {
973             digits -= 1;
974             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
975             value /= 10;
976         }
977         return string(buffer);
978     }
979 
980     /**
981      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
982      */
983     function toHexString(uint256 value) internal pure returns (string memory) {
984         if (value == 0) {
985             return "0x00";
986         }
987         uint256 temp = value;
988         uint256 length = 0;
989         while (temp != 0) {
990             length++;
991             temp >>= 8;
992         }
993         return toHexString(value, length);
994     }
995 
996     /**
997      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
998      */
999     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1000         bytes memory buffer = new bytes(2 * length + 2);
1001         buffer[0] = "0";
1002         buffer[1] = "x";
1003         for (uint256 i = 2 * length + 1; i > 1; --i) {
1004             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1005             value >>= 4;
1006         }
1007         require(value == 0, "Strings: hex length insufficient");
1008         return string(buffer);
1009     }
1010 }
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 /**
1015  * @dev Implementation of the {IERC165} interface.
1016  *
1017  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1018  * for the additional interface id that will be supported. For example:
1019  *
1020  * ```solidity
1021  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1022  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1023  * }
1024  * ```
1025  *
1026  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1027  */
1028 abstract contract ERC165 is IERC165 {
1029     /**
1030      * @dev See {IERC165-supportsInterface}.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1033         return interfaceId == type(IERC165).interfaceId;
1034     }
1035 }
1036 
1037 
1038 
1039 
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 
1044 
1045 /**
1046  * @dev Contract module that allows children to implement role-based access
1047  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1048  * members except through off-chain means by accessing the contract event logs. Some
1049  * applications may benefit from on-chain enumerability, for those cases see
1050  * {AccessControlEnumerable}.
1051  *
1052  * Roles are referred to by their `bytes32` identifier. These should be exposed
1053  * in the external API and be unique. The best way to achieve this is by
1054  * using `public constant` hash digests:
1055  *
1056  * ```
1057  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1058  * ```
1059  *
1060  * Roles can be used to represent a set of permissions. To restrict access to a
1061  * function call, use {hasRole}:
1062  *
1063  * ```
1064  * function foo() public {
1065  *     require(hasRole(MY_ROLE, msg.sender));
1066  *     ...
1067  * }
1068  * ```
1069  *
1070  * Roles can be granted and revoked dynamically via the {grantRole} and
1071  * {revokeRole} functions. Each role has an associated admin role, and only
1072  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1073  *
1074  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1075  * that only accounts with this role will be able to grant or revoke other
1076  * roles. More complex role relationships can be created by using
1077  * {_setRoleAdmin}.
1078  *
1079  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1080  * grant and revoke this role. Extra precautions should be taken to secure
1081  * accounts that have been granted it.
1082  */
1083 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1084     struct RoleData {
1085         mapping(address => bool) members;
1086         bytes32 adminRole;
1087     }
1088 
1089     mapping(bytes32 => RoleData) private _roles;
1090 
1091     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1092 
1093     /**
1094      * @dev Modifier that checks that an account has a specific role. Reverts
1095      * with a standardized message including the required role.
1096      *
1097      * The format of the revert reason is given by the following regular expression:
1098      *
1099      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1100      *
1101      * _Available since v4.1._
1102      */
1103     modifier onlyRole(bytes32 role) {
1104         _checkRole(role, _msgSender());
1105         _;
1106     }
1107 
1108     /**
1109      * @dev See {IERC165-supportsInterface}.
1110      */
1111     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1112         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1113     }
1114 
1115     /**
1116      * @dev Returns `true` if `account` has been granted `role`.
1117      */
1118     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1119         return _roles[role].members[account];
1120     }
1121 
1122     /**
1123      * @dev Revert with a standard message if `account` is missing `role`.
1124      *
1125      * The format of the revert reason is given by the following regular expression:
1126      *
1127      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1128      */
1129     function _checkRole(bytes32 role, address account) internal view virtual {
1130         if (!hasRole(role, account)) {
1131             revert(
1132                 string(
1133                     abi.encodePacked(
1134                         "AccessControl: account ",
1135                         Strings.toHexString(uint160(account), 20),
1136                         " is missing role ",
1137                         Strings.toHexString(uint256(role), 32)
1138                     )
1139                 )
1140             );
1141         }
1142     }
1143 
1144     /**
1145      * @dev Returns the admin role that controls `role`. See {grantRole} and
1146      * {revokeRole}.
1147      *
1148      * To change a role's admin, use {_setRoleAdmin}.
1149      */
1150     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1151         return _roles[role].adminRole;
1152     }
1153 
1154     /**
1155      * @dev Grants `role` to `account`.
1156      *
1157      * If `account` had not been already granted `role`, emits a {RoleGranted}
1158      * event.
1159      *
1160      * Requirements:
1161      *
1162      * - the caller must have ``role``'s admin role.
1163      */
1164     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1165         _grantRole(role, account);
1166     }
1167 
1168     /**
1169      * @dev Revokes `role` from `account`.
1170      *
1171      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1172      *
1173      * Requirements:
1174      *
1175      * - the caller must have ``role``'s admin role.
1176      */
1177     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1178         _revokeRole(role, account);
1179     }
1180 
1181     /**
1182      * @dev Revokes `role` from the calling account.
1183      *
1184      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1185      * purpose is to provide a mechanism for accounts to lose their privileges
1186      * if they are compromised (such as when a trusted device is misplaced).
1187      *
1188      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1189      * event.
1190      *
1191      * Requirements:
1192      *
1193      * - the caller must be `account`.
1194      */
1195     function renounceRole(bytes32 role, address account) public virtual override {
1196         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1197 
1198         _revokeRole(role, account);
1199     }
1200 
1201     /**
1202      * @dev Grants `role` to `account`.
1203      *
1204      * If `account` had not been already granted `role`, emits a {RoleGranted}
1205      * event. Note that unlike {grantRole}, this function doesn't perform any
1206      * checks on the calling account.
1207      *
1208      * [WARNING]
1209      * ====
1210      * This function should only be called from the constructor when setting
1211      * up the initial roles for the system.
1212      *
1213      * Using this function in any other way is effectively circumventing the admin
1214      * system imposed by {AccessControl}.
1215      * ====
1216      *
1217      * NOTE: This function is deprecated in favor of {_grantRole}.
1218      */
1219     function _setupRole(bytes32 role, address account) internal virtual {
1220         _grantRole(role, account);
1221     }
1222 
1223     /**
1224      * @dev Sets `adminRole` as ``role``'s admin role.
1225      *
1226      * Emits a {RoleAdminChanged} event.
1227      */
1228     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1229         bytes32 previousAdminRole = getRoleAdmin(role);
1230         _roles[role].adminRole = adminRole;
1231         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1232     }
1233 
1234     /**
1235      * @dev Grants `role` to `account`.
1236      *
1237      * Internal function without access restriction.
1238      */
1239     function _grantRole(bytes32 role, address account) internal virtual {
1240         if (!hasRole(role, account)) {
1241             _roles[role].members[account] = true;
1242             emit RoleGranted(role, account, _msgSender());
1243         }
1244     }
1245 
1246     /**
1247      * @dev Revokes `role` from `account`.
1248      *
1249      * Internal function without access restriction.
1250      */
1251     function _revokeRole(bytes32 role, address account) internal virtual {
1252         if (hasRole(role, account)) {
1253             _roles[role].members[account] = false;
1254             emit RoleRevoked(role, account, _msgSender());
1255         }
1256     }
1257 }
1258 
1259 
1260 
1261 
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 
1266 /**
1267  * @dev Contract module which provides a basic access control mechanism, where
1268  * there is an account (an owner) that can be granted exclusive access to
1269  * specific functions.
1270  *
1271  * By default, the owner account will be the one that deploys the contract. This
1272  * can later be changed with {transferOwnership}.
1273  *
1274  * This module is used through inheritance. It will make available the modifier
1275  * `onlyOwner`, which can be applied to your functions to restrict their use to
1276  * the owner.
1277  */
1278 abstract contract Ownable is Context {
1279     address private _owner;
1280 
1281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1282 
1283     /**
1284      * @dev Initializes the contract setting the deployer as the initial owner.
1285      */
1286     constructor() {
1287         _transferOwnership(_msgSender());
1288     }
1289 
1290     /**
1291      * @dev Returns the address of the current owner.
1292      */
1293     function owner() public view virtual returns (address) {
1294         return _owner;
1295     }
1296 
1297     /**
1298      * @dev Throws if called by any account other than the owner.
1299      */
1300     modifier onlyOwner() {
1301         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1302         _;
1303     }
1304 
1305     /**
1306      * @dev Leaves the contract without owner. It will not be possible to call
1307      * `onlyOwner` functions anymore. Can only be called by the current owner.
1308      *
1309      * NOTE: Renouncing ownership will leave the contract without an owner,
1310      * thereby removing any functionality that is only available to the owner.
1311      */
1312     function renounceOwnership() public virtual onlyOwner {
1313         _transferOwnership(address(0));
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      * Can only be called by the current owner.
1319      */
1320     function transferOwnership(address newOwner) public virtual onlyOwner {
1321         require(newOwner != address(0), "Ownable: new owner is the zero address");
1322         _transferOwnership(newOwner);
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Internal function without access restriction.
1328      */
1329     function _transferOwnership(address newOwner) internal virtual {
1330         address oldOwner = _owner;
1331         _owner = newOwner;
1332         emit OwnershipTransferred(oldOwner, newOwner);
1333     }
1334 }
1335 
1336 
1337 pragma solidity ^0.8.0;
1338 
1339 
1340 
1341 /**
1342  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1343  */
1344 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1345     using EnumerableSet for EnumerableSet.AddressSet;
1346 
1347     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1348 
1349     /**
1350      * @dev See {IERC165-supportsInterface}.
1351      */
1352     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1353         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1354     }
1355 
1356     /**
1357      * @dev Returns one of the accounts that have `role`. `index` must be a
1358      * value between 0 and {getRoleMemberCount}, non-inclusive.
1359      *
1360      * Role bearers are not sorted in any particular way, and their ordering may
1361      * change at any point.
1362      *
1363      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1364      * you perform all queries on the same block. See the following
1365      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1366      * for more information.
1367      */
1368     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1369         return _roleMembers[role].at(index);
1370     }
1371 
1372     /**
1373      * @dev Returns the number of accounts that have `role`. Can be used
1374      * together with {getRoleMember} to enumerate all bearers of a role.
1375      */
1376     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1377         return _roleMembers[role].length();
1378     }
1379 
1380     /**
1381      * @dev Overload {_grantRole} to track enumerable memberships
1382      */
1383     function _grantRole(bytes32 role, address account) internal virtual override {
1384         super._grantRole(role, account);
1385         _roleMembers[role].add(account);
1386     }
1387 
1388     /**
1389      * @dev Overload {_revokeRole} to track enumerable memberships
1390      */
1391     function _revokeRole(bytes32 role, address account) internal virtual override {
1392         super._revokeRole(role, account);
1393         _roleMembers[role].remove(account);
1394     }
1395 }
1396 
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 /**
1401  * @dev Contract module that helps prevent reentrant calls to a function.
1402  *
1403  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1404  * available, which can be applied to functions to make sure there are no nested
1405  * (reentrant) calls to them.
1406  *
1407  * Note that because there is a single `nonReentrant` guard, functions marked as
1408  * `nonReentrant` may not call one another. This can be worked around by making
1409  * those functions `private`, and then adding `external` `nonReentrant` entry
1410  * points to them.
1411  *
1412  * TIP: If you would like to learn more about reentrancy and alternative ways
1413  * to protect against it, check out our blog post
1414  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1415  */
1416 abstract contract ReentrancyGuard {
1417     // Booleans are more expensive than uint256 or any type that takes up a full
1418     // word because each write operation emits an extra SLOAD to first read the
1419     // slot's contents, replace the bits taken up by the boolean, and then write
1420     // back. This is the compiler's defense against contract upgrades and
1421     // pointer aliasing, and it cannot be disabled.
1422 
1423     // The values being non-zero value makes deployment a bit more expensive,
1424     // but in exchange the refund on every call to nonReentrant will be lower in
1425     // amount. Since refunds are capped to a percentage of the total
1426     // transaction's gas, it is best to keep them low in cases like this one, to
1427     // increase the likelihood of the full refund coming into effect.
1428     uint256 private constant _NOT_ENTERED = 1;
1429     uint256 private constant _ENTERED = 2;
1430 
1431     uint256 private _status;
1432 
1433     constructor() {
1434         _status = _NOT_ENTERED;
1435     }
1436 
1437     /**
1438      * @dev Prevents a contract from calling itself, directly or indirectly.
1439      * Calling a `nonReentrant` function from another `nonReentrant`
1440      * function is not supported. It is possible to prevent this from happening
1441      * by making the `nonReentrant` function external, and making it call a
1442      * `private` function that does the actual work.
1443      */
1444     modifier nonReentrant() {
1445         // On the first call to nonReentrant, _notEntered will be true
1446         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1447 
1448         // Any calls to nonReentrant after this point will fail
1449         _status = _ENTERED;
1450 
1451         _;
1452 
1453         // By storing the original value once again, a refund is triggered (see
1454         // https://eips.ethereum.org/EIPS/eip-2200)
1455         _status = _NOT_ENTERED;
1456     }
1457 }
1458 
1459 
1460 
1461 
1462 
1463 pragma solidity ^0.8.4;
1464 
1465 
1466 error ApprovalCallerNotOwnerNorApproved();
1467 error ApprovalQueryForNonexistentToken();
1468 error ApproveToCaller();
1469 error ApprovalToCurrentOwner();
1470 error BalanceQueryForZeroAddress();
1471 error MintToZeroAddress();
1472 error MintZeroQuantity();
1473 error OwnerQueryForNonexistentToken();
1474 error TransferCallerNotOwnerNorApproved();
1475 error TransferFromIncorrectOwner();
1476 error TransferToNonERC721ReceiverImplementer();
1477 error TransferToZeroAddress();
1478 error URIQueryForNonexistentToken();
1479 
1480 /**
1481  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1482  * the Metadata extension. Built to optimize for lower gas during batch mints.
1483  *
1484  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1485  *
1486  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1487  *
1488  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1489  */
1490 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1491     using Address for address;
1492     using Strings for uint256;
1493 
1494     // Compiler will pack this into a single 256bit word.
1495     struct TokenOwnership {
1496         // The address of the owner.
1497         address addr;
1498         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1499         uint64 startTimestamp;
1500         // Whether the token has been burned.
1501         bool burned;
1502     }
1503 
1504     // Compiler will pack this into a single 256bit word.
1505     struct AddressData {
1506         // Realistically, 2**64-1 is more than enough.
1507         uint64 balance;
1508         // Keeps track of mint count with minimal overhead for tokenomics.
1509         uint64 numberMinted;
1510         // Keeps track of burn count with minimal overhead for tokenomics.
1511         uint64 numberBurned;
1512         // For miscellaneous variable(s) pertaining to the address
1513         // (e.g. number of whitelist mint slots used).
1514         // If there are multiple variables, please pack them into a uint64.
1515         uint64 aux;
1516     }
1517 
1518     // The tokenId of the next token to be minted.
1519     uint256 internal _currentIndex;
1520 
1521     // The number of tokens burned.
1522     uint256 internal _burnCounter;
1523 
1524     // Token name
1525     string private _name;
1526 
1527     // Token symbol
1528     string private _symbol;
1529 
1530     // Mapping from token ID to ownership details
1531     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1532     mapping(uint256 => TokenOwnership) internal _ownerships;
1533 
1534     // Mapping owner address to address data
1535     mapping(address => AddressData) private _addressData;
1536 
1537     // Mapping from token ID to approved address
1538     mapping(uint256 => address) private _tokenApprovals;
1539 
1540     // Mapping from owner to operator approvals
1541     mapping(address => mapping(address => bool)) private _operatorApprovals;
1542 
1543     constructor(string memory name_, string memory symbol_) {
1544         _name = name_;
1545         _symbol = symbol_;
1546         _currentIndex = _startTokenId();
1547     }
1548 
1549     /**
1550      * To change the starting tokenId, please override this function.
1551      */
1552     function _startTokenId() internal view virtual returns (uint256) {
1553         return 0;
1554     }
1555 
1556     /**
1557      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1558      */
1559     function totalSupply() public view returns (uint256) {
1560         // Counter underflow is impossible as _burnCounter cannot be incremented
1561         // more than _currentIndex - _startTokenId() times
1562         unchecked {
1563             return _currentIndex - _burnCounter - _startTokenId();
1564         }
1565     }
1566 
1567     /**
1568      * Returns the total amount of tokens minted in the contract.
1569      */
1570     function _totalMinted() internal view returns (uint256) {
1571         // Counter underflow is impossible as _currentIndex does not decrement,
1572         // and it is initialized to _startTokenId()
1573         unchecked {
1574             return _currentIndex - _startTokenId();
1575         }
1576     }
1577 
1578     /**
1579      * @dev See {IERC165-supportsInterface}.
1580      */
1581     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1582         return
1583             interfaceId == type(IERC721).interfaceId ||
1584             interfaceId == type(IERC721Metadata).interfaceId ||
1585             super.supportsInterface(interfaceId);
1586     }
1587 
1588     /**
1589      * @dev See {IERC721-balanceOf}.
1590      */
1591     function balanceOf(address owner) public view override returns (uint256) {
1592         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1593         return uint256(_addressData[owner].balance);
1594     }
1595 
1596     /**
1597      * Returns the number of tokens minted by `owner`.
1598      */
1599     function _numberMinted(address owner) internal view returns (uint256) {
1600         return uint256(_addressData[owner].numberMinted);
1601     }
1602 
1603     /**
1604      * Returns the number of tokens burned by or on behalf of `owner`.
1605      */
1606     function _numberBurned(address owner) internal view returns (uint256) {
1607         return uint256(_addressData[owner].numberBurned);
1608     }
1609 
1610     /**
1611      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1612      */
1613     function _getAux(address owner) internal view returns (uint64) {
1614         return _addressData[owner].aux;
1615     }
1616 
1617     /**
1618      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1619      * If there are multiple variables, please pack them into a uint64.
1620      */
1621     function _setAux(address owner, uint64 aux) internal {
1622         _addressData[owner].aux = aux;
1623     }
1624 
1625     /**
1626      * Gas spent here starts off proportional to the maximum mint batch size.
1627      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1628      */
1629     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1630         uint256 curr = tokenId;
1631 
1632         unchecked {
1633             if (_startTokenId() <= curr && curr < _currentIndex) {
1634                 TokenOwnership memory ownership = _ownerships[curr];
1635                 if (!ownership.burned) {
1636                     if (ownership.addr != address(0)) {
1637                         return ownership;
1638                     }
1639                     // Invariant:
1640                     // There will always be an ownership that has an address and is not burned
1641                     // before an ownership that does not have an address and is not burned.
1642                     // Hence, curr will not underflow.
1643                     while (true) {
1644                         curr--;
1645                         ownership = _ownerships[curr];
1646                         if (ownership.addr != address(0)) {
1647                             return ownership;
1648                         }
1649                     }
1650                 }
1651             }
1652         }
1653         revert OwnerQueryForNonexistentToken();
1654     }
1655 
1656     /**
1657      * @dev See {IERC721-ownerOf}.
1658      */
1659     function ownerOf(uint256 tokenId) public view override returns (address) {
1660         return _ownershipOf(tokenId).addr;
1661     }
1662 
1663     /**
1664      * @dev See {IERC721Metadata-name}.
1665      */
1666     function name() public view virtual override returns (string memory) {
1667         return _name;
1668     }
1669 
1670     /**
1671      * @dev See {IERC721Metadata-symbol}.
1672      */
1673     function symbol() public view virtual override returns (string memory) {
1674         return _symbol;
1675     }
1676 
1677     /**
1678      * @dev See {IERC721Metadata-tokenURI}.
1679      */
1680     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1681         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1682 
1683         string memory baseURI = _baseURI();
1684         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1685     }
1686 
1687     /**
1688      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1689      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1690      * by default, can be overriden in child contracts.
1691      */
1692     function _baseURI() internal view virtual returns (string memory) {
1693         return '';
1694     }
1695 
1696     /**
1697      * @dev See {IERC721-approve}.
1698      */
1699     function approve(address to, uint256 tokenId) public virtual override {
1700         address owner = ERC721A.ownerOf(tokenId);
1701         if (to == owner) revert ApprovalToCurrentOwner();
1702 
1703         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1704             revert ApprovalCallerNotOwnerNorApproved();
1705         }
1706 
1707         _approve(to, tokenId, owner);
1708     }
1709 
1710     /**
1711      * @dev See {IERC721-getApproved}.
1712      */
1713     function getApproved(uint256 tokenId) public view override returns (address) {
1714         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1715 
1716         return _tokenApprovals[tokenId];
1717     }
1718 
1719     /**
1720      * @dev See {IERC721-setApprovalForAll}.
1721      */
1722     function setApprovalForAll(address operator, bool approved) public virtual override {
1723         if (operator == _msgSender()) revert ApproveToCaller();
1724 
1725         _operatorApprovals[_msgSender()][operator] = approved;
1726         emit ApprovalForAll(_msgSender(), operator, approved);
1727     }
1728 
1729     /**
1730      * @dev See {IERC721-isApprovedForAll}.
1731      */
1732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1733         return _operatorApprovals[owner][operator];
1734     }
1735 
1736     /**
1737      * @dev See {IERC721-transferFrom}.
1738      */
1739     function transferFrom(
1740         address from,
1741         address to,
1742         uint256 tokenId
1743     ) public virtual override {
1744         _transfer(from, to, tokenId);
1745     }
1746 
1747     /**
1748      * @dev See {IERC721-safeTransferFrom}.
1749      */
1750     function safeTransferFrom(
1751         address from,
1752         address to,
1753         uint256 tokenId
1754     ) public virtual override {
1755         safeTransferFrom(from, to, tokenId, '');
1756     }
1757 
1758     /**
1759      * @dev See {IERC721-safeTransferFrom}.
1760      */
1761     function safeTransferFrom(
1762         address from,
1763         address to,
1764         uint256 tokenId,
1765         bytes memory _data
1766     ) public virtual override {
1767         _transfer(from, to, tokenId);
1768         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1769             revert TransferToNonERC721ReceiverImplementer();
1770         }
1771     }
1772 
1773     /**
1774      * @dev Returns whether `tokenId` exists.
1775      *
1776      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1777      *
1778      * Tokens start existing when they are minted (`_mint`),
1779      */
1780     function _exists(uint256 tokenId) internal view returns (bool) {
1781         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1782             !_ownerships[tokenId].burned;
1783     }
1784 
1785     function _safeMint(address to, uint256 quantity) internal {
1786         _safeMint(to, quantity, '');
1787     }
1788 
1789     /**
1790      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1791      *
1792      * Requirements:
1793      *
1794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1795      * - `quantity` must be greater than 0.
1796      *
1797      * Emits a {Transfer} event.
1798      */
1799     function _safeMint(
1800         address to,
1801         uint256 quantity,
1802         bytes memory _data
1803     ) internal {
1804         _mint(to, quantity, _data, true);
1805     }
1806 
1807     /**
1808      * @dev Mints `quantity` tokens and transfers them to `to`.
1809      *
1810      * Requirements:
1811      *
1812      * - `to` cannot be the zero address.
1813      * - `quantity` must be greater than 0.
1814      *
1815      * Emits a {Transfer} event.
1816      */
1817     function _mint(
1818         address to,
1819         uint256 quantity,
1820         bytes memory _data,
1821         bool safe
1822     ) internal {
1823         uint256 startTokenId = _currentIndex;
1824         if (to == address(0)) revert MintToZeroAddress();
1825         if (quantity == 0) revert MintZeroQuantity();
1826 
1827         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1828 
1829         // Overflows are incredibly unrealistic.
1830         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1831         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1832         unchecked {
1833             _addressData[to].balance += uint64(quantity);
1834             _addressData[to].numberMinted += uint64(quantity);
1835 
1836             _ownerships[startTokenId].addr = to;
1837             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1838 
1839             uint256 updatedIndex = startTokenId;
1840             uint256 end = updatedIndex + quantity;
1841 
1842             if (safe && to.isContract()) {
1843                 do {
1844                     emit Transfer(address(0), to, updatedIndex);
1845                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1846                         revert TransferToNonERC721ReceiverImplementer();
1847                     }
1848                 } while (updatedIndex != end);
1849                 // Reentrancy protection
1850                 if (_currentIndex != startTokenId) revert();
1851             } else {
1852                 do {
1853                     emit Transfer(address(0), to, updatedIndex++);
1854                 } while (updatedIndex != end);
1855             }
1856             _currentIndex = updatedIndex;
1857         }
1858         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1859     }
1860 
1861     /**
1862      * @dev Transfers `tokenId` from `from` to `to`.
1863      *
1864      * Requirements:
1865      *
1866      * - `to` cannot be the zero address.
1867      * - `tokenId` token must be owned by `from`.
1868      *
1869      * Emits a {Transfer} event.
1870      */
1871     function _transfer(
1872         address from,
1873         address to,
1874         uint256 tokenId
1875     ) private {
1876         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1877 
1878         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1879 
1880         bool isApprovedOrOwner = (_msgSender() == from ||
1881             isApprovedForAll(from, _msgSender()) ||
1882             getApproved(tokenId) == _msgSender());
1883 
1884         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1885         if (to == address(0)) revert TransferToZeroAddress();
1886 
1887         _beforeTokenTransfers(from, to, tokenId, 1);
1888 
1889         // Clear approvals from the previous owner
1890         _approve(address(0), tokenId, from);
1891 
1892         // Underflow of the sender's balance is impossible because we check for
1893         // ownership above and the recipient's balance can't realistically overflow.
1894         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1895         unchecked {
1896             _addressData[from].balance -= 1;
1897             _addressData[to].balance += 1;
1898 
1899             TokenOwnership storage currSlot = _ownerships[tokenId];
1900             currSlot.addr = to;
1901             currSlot.startTimestamp = uint64(block.timestamp);
1902 
1903             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1904             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1905             uint256 nextTokenId = tokenId + 1;
1906             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1907             if (nextSlot.addr == address(0)) {
1908                 // This will suffice for checking _exists(nextTokenId),
1909                 // as a burned slot cannot contain the zero address.
1910                 if (nextTokenId != _currentIndex) {
1911                     nextSlot.addr = from;
1912                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1913                 }
1914             }
1915         }
1916 
1917         emit Transfer(from, to, tokenId);
1918         _afterTokenTransfers(from, to, tokenId, 1);
1919     }
1920 
1921     /**
1922      * @dev This is equivalent to _burn(tokenId, false)
1923      */
1924     function _burn(uint256 tokenId) internal virtual {
1925         _burn(tokenId, false);
1926     }
1927 
1928     /**
1929      * @dev Destroys `tokenId`.
1930      * The approval is cleared when the token is burned.
1931      *
1932      * Requirements:
1933      *
1934      * - `tokenId` must exist.
1935      *
1936      * Emits a {Transfer} event.
1937      */
1938     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1939         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1940 
1941         address from = prevOwnership.addr;
1942 
1943         if (approvalCheck) {
1944             bool isApprovedOrOwner = (_msgSender() == from ||
1945                 isApprovedForAll(from, _msgSender()) ||
1946                 getApproved(tokenId) == _msgSender());
1947 
1948             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1949         }
1950 
1951         _beforeTokenTransfers(from, address(0), tokenId, 1);
1952 
1953         // Clear approvals from the previous owner
1954         _approve(address(0), tokenId, from);
1955 
1956         // Underflow of the sender's balance is impossible because we check for
1957         // ownership above and the recipient's balance can't realistically overflow.
1958         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1959         unchecked {
1960             AddressData storage addressData = _addressData[from];
1961             addressData.balance -= 1;
1962             addressData.numberBurned += 1;
1963 
1964             // Keep track of who burned the token, and the timestamp of burning.
1965             TokenOwnership storage currSlot = _ownerships[tokenId];
1966             currSlot.addr = from;
1967             currSlot.startTimestamp = uint64(block.timestamp);
1968             currSlot.burned = true;
1969 
1970             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1971             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1972             uint256 nextTokenId = tokenId + 1;
1973             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1974             if (nextSlot.addr == address(0)) {
1975                 // This will suffice for checking _exists(nextTokenId),
1976                 // as a burned slot cannot contain the zero address.
1977                 if (nextTokenId != _currentIndex) {
1978                     nextSlot.addr = from;
1979                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1980                 }
1981             }
1982         }
1983 
1984         emit Transfer(from, address(0), tokenId);
1985         _afterTokenTransfers(from, address(0), tokenId, 1);
1986 
1987         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1988         unchecked {
1989             _burnCounter++;
1990         }
1991     }
1992 
1993     /**
1994      * @dev Approve `to` to operate on `tokenId`
1995      *
1996      * Emits a {Approval} event.
1997      */
1998     function _approve(
1999         address to,
2000         uint256 tokenId,
2001         address owner
2002     ) private {
2003         _tokenApprovals[tokenId] = to;
2004         emit Approval(owner, to, tokenId);
2005     }
2006 
2007     /**
2008      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2009      *
2010      * @param from address representing the previous owner of the given token ID
2011      * @param to target address that will receive the tokens
2012      * @param tokenId uint256 ID of the token to be transferred
2013      * @param _data bytes optional data to send along with the call
2014      * @return bool whether the call correctly returned the expected magic value
2015      */
2016     function _checkContractOnERC721Received(
2017         address from,
2018         address to,
2019         uint256 tokenId,
2020         bytes memory _data
2021     ) private returns (bool) {
2022         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2023             return retval == IERC721Receiver(to).onERC721Received.selector;
2024         } catch (bytes memory reason) {
2025             if (reason.length == 0) {
2026                 revert TransferToNonERC721ReceiverImplementer();
2027             } else {
2028                 assembly {
2029                     revert(add(32, reason), mload(reason))
2030                 }
2031             }
2032         }
2033     }
2034 
2035     /**
2036      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2037      * And also called before burning one token.
2038      *
2039      * startTokenId - the first token id to be transferred
2040      * quantity - the amount to be transferred
2041      *
2042      * Calling conditions:
2043      *
2044      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2045      * transferred to `to`.
2046      * - When `from` is zero, `tokenId` will be minted for `to`.
2047      * - When `to` is zero, `tokenId` will be burned by `from`.
2048      * - `from` and `to` are never both zero.
2049      */
2050     function _beforeTokenTransfers(
2051         address from,
2052         address to,
2053         uint256 startTokenId,
2054         uint256 quantity
2055     ) internal virtual {}
2056 
2057     /**
2058      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2059      * minting.
2060      * And also called after one token has been burned.
2061      *
2062      * startTokenId - the first token id to be transferred
2063      * quantity - the amount to be transferred
2064      *
2065      * Calling conditions:
2066      *
2067      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2068      * transferred to `to`.
2069      * - When `from` is zero, `tokenId` has been minted for `to`.
2070      * - When `to` is zero, `tokenId` has been burned by `from`.
2071      * - `from` and `to` are never both zero.
2072      */
2073     function _afterTokenTransfers(
2074         address from,
2075         address to,
2076         uint256 startTokenId,
2077         uint256 quantity
2078     ) internal virtual {}
2079 }
2080 
2081 
2082 
2083 pragma solidity ^0.8.0;
2084 
2085 /**
2086  * @dev Interface of the ERC20 standard as defined in the EIP.
2087  */
2088 interface IERC20 {
2089     /**
2090      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2091      * another (`to`).
2092      *
2093      * Note that `value` may be zero.
2094      */
2095     event Transfer(address indexed from, address indexed to, uint256 value);
2096 
2097     /**
2098      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2099      * a call to {approve}. `value` is the new allowance.
2100      */
2101     event Approval(address indexed owner, address indexed spender, uint256 value);
2102 
2103     /**
2104      * @dev Returns the amount of tokens in existence.
2105      */
2106     function totalSupply() external view returns (uint256);
2107 
2108     /**
2109      * @dev Returns the amount of tokens owned by `account`.
2110      */
2111     function balanceOf(address account) external view returns (uint256);
2112 
2113     /**
2114      * @dev Moves `amount` tokens from the caller's account to `to`.
2115      *
2116      * Returns a boolean value indicating whether the operation succeeded.
2117      *
2118      * Emits a {Transfer} event.
2119      */
2120     function transfer(address to, uint256 amount) external returns (bool);
2121 
2122     /**
2123      * @dev Returns the remaining number of tokens that `spender` will be
2124      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2125      * zero by default.
2126      *
2127      * This value changes when {approve} or {transferFrom} are called.
2128      */
2129     function allowance(address owner, address spender) external view returns (uint256);
2130 
2131     /**
2132      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2133      *
2134      * Returns a boolean value indicating whether the operation succeeded.
2135      *
2136      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2137      * that someone may use both the old and the new allowance by unfortunate
2138      * transaction ordering. One possible solution to mitigate this race
2139      * condition is to first reduce the spender's allowance to 0 and set the
2140      * desired value afterwards:
2141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2142      *
2143      * Emits an {Approval} event.
2144      */
2145     function approve(address spender, uint256 amount) external returns (bool);
2146 
2147     /**
2148      * @dev Moves `amount` tokens from `from` to `to` using the
2149      * allowance mechanism. `amount` is then deducted from the caller's
2150      * allowance.
2151      *
2152      * Returns a boolean value indicating whether the operation succeeded.
2153      *
2154      * Emits a {Transfer} event.
2155      */
2156     function transferFrom(
2157         address from,
2158         address to,
2159         uint256 amount
2160     ) external returns (bool);
2161 }
2162 
2163 pragma solidity ^0.8.0;
2164 
2165 /**
2166  * @title SafeERC20
2167  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2168  * contract returns false). Tokens that return no value (and instead revert or
2169  * throw on failure) are also supported, non-reverting calls are assumed to be
2170  * successful.
2171  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2172  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2173  */
2174 library SafeERC20 {
2175     using Address for address;
2176 
2177     function safeTransfer(
2178         IERC20 token,
2179         address to,
2180         uint256 value
2181     ) internal {
2182         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2183     }
2184 
2185     function safeTransferFrom(
2186         IERC20 token,
2187         address from,
2188         address to,
2189         uint256 value
2190     ) internal {
2191         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2192     }
2193 
2194     /**
2195      * @dev Deprecated. This function has issues similar to the ones found in
2196      * {IERC20-approve}, and its usage is discouraged.
2197      *
2198      * Whenever possible, use {safeIncreaseAllowance} and
2199      * {safeDecreaseAllowance} instead.
2200      */
2201     function safeApprove(
2202         IERC20 token,
2203         address spender,
2204         uint256 value
2205     ) internal {
2206         // safeApprove should only be called when setting an initial allowance,
2207         // or when resetting it to zero. To increase and decrease it, use
2208         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2209         require(
2210             (value == 0) || (token.allowance(address(this), spender) == 0),
2211             "SafeERC20: approve from non-zero to non-zero allowance"
2212         );
2213         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2214     }
2215 
2216     function safeIncreaseAllowance(
2217         IERC20 token,
2218         address spender,
2219         uint256 value
2220     ) internal {
2221         uint256 newAllowance = token.allowance(address(this), spender) + value;
2222         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2223     }
2224 
2225     function safeDecreaseAllowance(
2226         IERC20 token,
2227         address spender,
2228         uint256 value
2229     ) internal {
2230         unchecked {
2231             uint256 oldAllowance = token.allowance(address(this), spender);
2232             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2233             uint256 newAllowance = oldAllowance - value;
2234             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2235         }
2236     }
2237 
2238     /**
2239      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2240      * on the return value: the return value is optional (but if data is returned, it must not be false).
2241      * @param token The token targeted by the call.
2242      * @param data The call data (encoded using abi.encode or one of its variants).
2243      */
2244     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2245         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2246         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2247         // the target address contains contract code and also asserts for success in the low-level call.
2248 
2249         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2250         if (returndata.length > 0) {
2251             // Return data is optional
2252             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2253         }
2254     }
2255 }
2256 
2257 
2258 pragma solidity ^0.8.0;
2259 
2260 
2261 
2262 /**
2263  * @title PaymentSplitter
2264  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2265  * that the Ether will be split in this way, since it is handled transparently by the contract.
2266  *
2267  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2268  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2269  * an amount proportional to the percentage of total shares they were assigned.
2270  *
2271  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2272  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2273  * function.
2274  *
2275  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2276  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2277  * to run tests before sending real value to this contract.
2278  */
2279 contract PaymentSplitter is Context {
2280     event PayeeAdded(address account, uint256 shares);
2281     event PaymentReleased(address to, uint256 amount);
2282     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2283     event PaymentReceived(address from, uint256 amount);
2284 
2285     uint256 private _totalShares;
2286     uint256 private _totalReleased;
2287 
2288     mapping(address => uint256) private _shares;
2289     mapping(address => uint256) private _released;
2290     address[] private _payees;
2291 
2292     mapping(IERC20 => uint256) private _erc20TotalReleased;
2293     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2294 
2295     /**
2296      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2297      * the matching position in the `shares` array.
2298      *
2299      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2300      * duplicates in `payees`.
2301      */
2302     constructor(address[] memory payees, uint256[] memory shares_) payable {
2303         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2304         require(payees.length > 0, "PaymentSplitter: no payees");
2305 
2306         for (uint256 i = 0; i < payees.length; i++) {
2307             _addPayee(payees[i], shares_[i]);
2308         }
2309     }
2310 
2311     /**
2312      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2313      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2314      * reliability of the events, and not the actual splitting of Ether.
2315      *
2316      * To learn more about this see the Solidity documentation for
2317      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2318      * functions].
2319      */
2320     receive() external payable virtual {
2321         emit PaymentReceived(_msgSender(), msg.value);
2322     }
2323 
2324     /**
2325      * @dev Getter for the total shares held by payees.
2326      */
2327     function totalShares() public view returns (uint256) {
2328         return _totalShares;
2329     }
2330 
2331     /**
2332      * @dev Getter for the total amount of Ether already released.
2333      */
2334     function totalReleased() public view returns (uint256) {
2335         return _totalReleased;
2336     }
2337 
2338     /**
2339      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2340      * contract.
2341      */
2342     function totalReleased(IERC20 token) public view returns (uint256) {
2343         return _erc20TotalReleased[token];
2344     }
2345 
2346     /**
2347      * @dev Getter for the amount of shares held by an account.
2348      */
2349     function shares(address account) public view returns (uint256) {
2350         return _shares[account];
2351     }
2352 
2353     /**
2354      * @dev Getter for the amount of Ether already released to a payee.
2355      */
2356     function released(address account) public view returns (uint256) {
2357         return _released[account];
2358     }
2359 
2360     /**
2361      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2362      * IERC20 contract.
2363      */
2364     function released(IERC20 token, address account) public view returns (uint256) {
2365         return _erc20Released[token][account];
2366     }
2367 
2368     /**
2369      * @dev Getter for the address of the payee number `index`.
2370      */
2371     function payee(uint256 index) public view returns (address) {
2372         return _payees[index];
2373     }
2374 
2375     /**
2376      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2377      * total shares and their previous withdrawals.
2378      */
2379     function release(address payable account) public virtual {
2380         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2381 
2382         uint256 totalReceived = address(this).balance + totalReleased();
2383         uint256 payment = _pendingPayment(account, totalReceived, released(account));
2384 
2385         require(payment != 0, "PaymentSplitter: account is not due payment");
2386 
2387         _released[account] += payment;
2388         _totalReleased += payment;
2389 
2390         Address.sendValue(account, payment);
2391         emit PaymentReleased(account, payment);
2392     }
2393 
2394     /**
2395      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2396      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2397      * contract.
2398      */
2399     function release(IERC20 token, address account) public virtual {
2400         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2401 
2402         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2403         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
2404 
2405         require(payment != 0, "PaymentSplitter: account is not due payment");
2406 
2407         _erc20Released[token][account] += payment;
2408         _erc20TotalReleased[token] += payment;
2409 
2410         SafeERC20.safeTransfer(token, account, payment);
2411         emit ERC20PaymentReleased(token, account, payment);
2412     }
2413 
2414     /**
2415      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2416      * already released amounts.
2417      */
2418     function _pendingPayment(
2419         address account,
2420         uint256 totalReceived,
2421         uint256 alreadyReleased
2422     ) private view returns (uint256) {
2423         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2424     }
2425 
2426     /**
2427      * @dev Add a new payee to the contract.
2428      * @param account The address of the payee to add.
2429      * @param shares_ The number of shares owned by the payee.
2430      */
2431     function _addPayee(address account, uint256 shares_) private {
2432         require(account != address(0), "PaymentSplitter: account is the zero address");
2433         require(shares_ > 0, "PaymentSplitter: shares are 0");
2434         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2435 
2436         _payees.push(account);
2437         _shares[account] = shares_;
2438         _totalShares = _totalShares + shares_;
2439         emit PayeeAdded(account, shares_);
2440     }
2441 }
2442 
2443 
2444 pragma solidity ^0.8.13;
2445 
2446 interface IOperatorFilterRegistry {
2447     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2448     function register(address registrant) external;
2449     function registerAndSubscribe(address registrant, address subscription) external;
2450     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2451     function unregister(address addr) external;
2452     function updateOperator(address registrant, address operator, bool filtered) external;
2453     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2454     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2455     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2456     function subscribe(address registrant, address registrantToSubscribe) external;
2457     function unsubscribe(address registrant, bool copyExistingEntries) external;
2458     function subscriptionOf(address addr) external returns (address registrant);
2459     function subscribers(address registrant) external returns (address[] memory);
2460     function subscriberAt(address registrant, uint256 index) external returns (address);
2461     function copyEntriesOf(address registrant, address registrantToCopy) external;
2462     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2463     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2464     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2465     function filteredOperators(address addr) external returns (address[] memory);
2466     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2467     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2468     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2469     function isRegistered(address addr) external returns (bool);
2470     function codeHashOf(address addr) external returns (bytes32);
2471 }
2472 
2473 pragma solidity ^0.8.13;
2474 
2475 //import {IOperatorFilterRegistry} from "./IOperatorFilterRegistry.sol";
2476 
2477 /**
2478  * @title  OperatorFilterer
2479  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2480  *         registrant's entries in the OperatorFilterRegistry.
2481  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2482  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2483  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2484  */
2485 abstract contract OperatorFilterer {
2486     error OperatorNotAllowed(address operator);
2487 
2488     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2489         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2490 
2491     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2492         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2493         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2494         // order for the modifier to filter addresses.
2495         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2496             if (subscribe) {
2497                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2498             } else {
2499                 if (subscriptionOrRegistrantToCopy != address(0)) {
2500                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2501                 } else {
2502                     OPERATOR_FILTER_REGISTRY.register(address(this));
2503                 }
2504             }
2505         }
2506     }
2507 
2508     modifier onlyAllowedOperator(address from) virtual {
2509         // Check registry code length to facilitate testing in environments without a deployed registry.
2510         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2511             // Allow spending tokens from addresses with balance
2512             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2513             // from an EOA.
2514             if (from == msg.sender) {
2515                 _;
2516                 return;
2517             }
2518             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
2519                 revert OperatorNotAllowed(msg.sender);
2520             }
2521         }
2522         _;
2523     }
2524 
2525     modifier onlyAllowedOperatorApproval(address operator) virtual {
2526         // Check registry code length to facilitate testing in environments without a deployed registry.
2527         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2528             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2529                 revert OperatorNotAllowed(operator);
2530             }
2531         }
2532         _;
2533     }
2534 }
2535 
2536 pragma solidity ^0.8.13;
2537 
2538 //import {OperatorFilterer} from "./OperatorFilterer.sol";
2539 
2540 /**
2541  * @title  DefaultOperatorFilterer
2542  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2543  */
2544 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2545     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2546 
2547     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2548 }
2549 
2550 
2551 contract QuantumCollective is ERC721A, ReentrancyGuard, Ownable, PaymentSplitter, DefaultOperatorFilterer {
2552 
2553 
2554     function setApprovalForAll(address operator, bool approved) public override(ERC721A)  onlyAllowedOperatorApproval(operator) {
2555         super.setApprovalForAll(operator, approved);
2556     }
2557 
2558     function approve(address operator, uint256 tokenId) public override(ERC721A) onlyAllowedOperatorApproval(operator) {
2559         super.approve(operator, tokenId);
2560     }
2561 
2562     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A) onlyAllowedOperator(from) {
2563         super.transferFrom(from, to, tokenId);
2564     }
2565 
2566     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A) onlyAllowedOperator(from) {
2567         super.safeTransferFrom(from, to, tokenId);
2568     }
2569 
2570     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2571         public
2572         override(ERC721A)
2573         onlyAllowedOperator(from)
2574     {
2575         super.safeTransferFrom(from, to, tokenId, data);
2576     }
2577 
2578 
2579     // Minting Variables
2580     uint256 public mintPrice = 0.01 ether;
2581     uint public maxFreePurchase = 1;
2582     uint256 public maxPurchase = 3;
2583     uint256 public maxSupply = 333;
2584     uint256 public maxPublicMints = 50;
2585     uint256 public publicMints = 0;
2586 
2587     address[] public _payees = [
2588         0xCe7a3a51E2170Ecd47BdF45422420614D20672Bc,  // gas pay back
2589         0x13Ede5b6f7d3da059Ae4b6c7ad0A8c254C70F6Ca  // contract wallet
2590 
2591     ];
2592     uint256[] private _shares = [50, 50];
2593 
2594     // Sale Status
2595     bool public saleIsActive = false;
2596 
2597     // mappings
2598 
2599     mapping(address => uint) public addressesThatMinted;
2600 
2601 
2602     // Metadata
2603     string _baseTokenURI = "ipfs://bafybeif5zbzl6blykoyjpg5wabyxxjsyiwtkp6p7v6cmxolxvpncbaqvui/";
2604 
2605 
2606     // Events
2607     event SaleActivation(bool isActive);
2608 
2609     constructor() ERC721A("Project Vendetta", "QSPY") PaymentSplitter(_payees, _shares) {
2610           freelist[0x4e4CC29ab82cf8aa4EcD3578A26409E57793de4b].exists = true;
2611           freelist[0xCe7a3a51E2170Ecd47BdF45422420614D20672Bc].exists = true;
2612           freelist[0x13Ede5b6f7d3da059Ae4b6c7ad0A8c254C70F6Ca].exists = true;
2613 
2614     }
2615 
2616     function OnWhiteList(address walletaddr)
2617         public
2618         view
2619         returns (bool)
2620         {
2621             if (freelist[walletaddr].exists){
2622                 return true;
2623             }
2624             else{
2625                 return false;
2626             }
2627         }
2628 
2629     struct Freelistaddr {
2630         uint256 presalemints;
2631         bool exists;
2632     }
2633     mapping(address => Freelistaddr) public freelist;
2634 
2635    function addToFreeList (address[] memory newWalletaddr) public onlyOwner{
2636         for (uint256 i = 0; i<newWalletaddr.length;i++){
2637             freelist[newWalletaddr[i]].exists = true;
2638         }        
2639     }
2640 
2641     function freelistMint(uint256 numberOfTokens) public payable nonReentrant {
2642         require(freelist[msg.sender].exists == true, "This Wallet is not able mint for presale"); 
2643         require(numberOfTokens > 0 && totalSupply() + numberOfTokens <= maxSupply, "Purchase would exceed current max supply");
2644         require(freelist[msg.sender].presalemints + numberOfTokens <= maxFreePurchase,"This Wallet has already minted its reserve");
2645         freelist[msg.sender].presalemints += numberOfTokens;
2646 
2647         _safeMint(msg.sender, numberOfTokens);
2648     }
2649 
2650     // Minting
2651 
2652 
2653     function mint(uint256 _count) external payable nonReentrant {
2654         require(saleIsActive, "SALE_INACTIVE");
2655         require(((addressesThatMinted[msg.sender] + _count) ) <= maxPurchase , "this would exceed mint max allowance");
2656 
2657         require(
2658             totalSupply() + _count <= maxSupply,
2659             "SOLD_OUT"
2660         );
2661         require(
2662             publicMints + _count <= maxPublicMints,
2663             "PUBLIC_SOLD_OUT"
2664         );
2665         require(
2666             mintPrice * _count <= msg.value,
2667             "INCORRECT_ETHER_VALUE"
2668         );
2669 
2670             publicMints += _count;
2671             _safeMint(msg.sender, _count);
2672             addressesThatMinted[msg.sender] += _count;
2673             
2674         }
2675 
2676 
2677     function toggleSaleStatus() external onlyOwner {
2678         saleIsActive = !saleIsActive;
2679         emit SaleActivation(saleIsActive);
2680     }
2681 
2682     function setMintPrice(uint256 _mintPrice) external onlyOwner {
2683         mintPrice = _mintPrice;
2684     }
2685 
2686     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
2687         maxPurchase = _maxPurchase;
2688     }
2689 
2690     function setMaxPublicMints(uint256 _maxPublicMints) external onlyOwner {
2691         maxPublicMints = _maxPublicMints;
2692     }
2693 
2694     // Payment
2695     function claim() external {
2696         release(payable(msg.sender));
2697     }
2698 
2699     function getWalletOfOwner(address owner) external view returns (uint256[] memory) {
2700     unchecked {
2701         uint256[] memory a = new uint256[](balanceOf(owner));
2702         uint256 end = _currentIndex;
2703         uint256 tokenIdsIdx;
2704         address currOwnershipAddr;
2705         for (uint256 i; i < end; i++) {
2706             TokenOwnership memory ownership = _ownerships[i];
2707             if (ownership.burned) {
2708                 continue;
2709             }
2710             if (ownership.addr != address(0)) {
2711                 currOwnershipAddr = ownership.addr;
2712             }
2713             if (currOwnershipAddr == owner) {
2714                 a[tokenIdsIdx++] = i;
2715             }
2716         }
2717         return a;
2718     }
2719     }
2720 
2721     function ownerMint(address _to, uint256 _count) external onlyOwner {
2722 
2723         require(
2724             totalSupply() + _count <= maxSupply,
2725             "SOLD_OUT"
2726         );
2727         _safeMint(_to, _count);
2728     }
2729 
2730     function setBaseURI(string memory baseURI) external onlyOwner {
2731         _baseTokenURI = baseURI;
2732     }
2733 
2734     function _baseURI() internal view virtual override returns (string memory) {
2735         return _baseTokenURI;
2736     }
2737 
2738    function tokenURI(uint256 tokenId) public view override returns (string memory){
2739         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2740         
2741     }
2742 
2743     function _startTokenId() internal view virtual override returns (uint256){
2744         return 1;
2745     }
2746 
2747 
2748 }