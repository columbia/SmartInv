1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev External interface of AccessControl declared to support ERC165 detection.
8  */
9 interface IAccessControl {
10     /**
11      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
12      *
13      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
14      * {RoleAdminChanged} not being emitted signaling this.
15      *
16      * _Available since v3.1._
17      */
18     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
19 
20     /**
21      * @dev Emitted when `account` is granted `role`.
22      *
23      * `sender` is the account that originated the contract call, an admin role
24      * bearer except when using {AccessControl-_setupRole}.
25      */
26     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
27 
28     /**
29      * @dev Emitted when `account` is revoked `role`.
30      *
31      * `sender` is the account that originated the contract call:
32      *   - if using `revokeRole`, it is the admin role bearer
33      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
34      */
35     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
36 
37     /**
38      * @dev Returns `true` if `account` has been granted `role`.
39      */
40     function hasRole(bytes32 role, address account) external view returns (bool);
41 
42     /**
43      * @dev Returns the admin role that controls `role`. See {grantRole} and
44      * {revokeRole}.
45      *
46      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
47      */
48     function getRoleAdmin(bytes32 role) external view returns (bytes32);
49 
50     /**
51      * @dev Grants `role` to `account`.
52      *
53      * If `account` had not been already granted `role`, emits a {RoleGranted}
54      * event.
55      *
56      * Requirements:
57      *
58      * - the caller must have ``role``'s admin role.
59      */
60     function grantRole(bytes32 role, address account) external;
61 
62     /**
63      * @dev Revokes `role` from `account`.
64      *
65      * If `account` had been granted `role`, emits a {RoleRevoked} event.
66      *
67      * Requirements:
68      *
69      * - the caller must have ``role``'s admin role.
70      */
71     function revokeRole(bytes32 role, address account) external;
72 
73     /**
74      * @dev Revokes `role` from the calling account.
75      *
76      * Roles are often managed via {grantRole} and {revokeRole}: this function's
77      * purpose is to provide a mechanism for accounts to lose their privileges
78      * if they are compromised (such as when a trusted device is misplaced).
79      *
80      * If the calling account had been granted `role`, emits a {RoleRevoked}
81      * event.
82      *
83      * Requirements:
84      *
85      * - the caller must be `account`.
86      */
87     function renounceRole(bytes32 role, address account) external;
88 }
89 
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface of the ERC165 standard, as defined in the
95  * https://eips.ethereum.org/EIPS/eip-165[EIP].
96  *
97  * Implementers can declare support of contract interfaces, which can then be
98  * queried by others ({ERC165Checker}).
99  *
100  * For an implementation, see {ERC165}.
101  */
102 interface IERC165 {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 
115 
116 pragma solidity ^0.8.0;
117 
118 
119 
120 /**
121  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
122  */
123 interface IAccessControlEnumerable is IAccessControl {
124     /**
125      * @dev Returns one of the accounts that have `role`. `index` must be a
126      * value between 0 and {getRoleMemberCount}, non-inclusive.
127      *
128      * Role bearers are not sorted in any particular way, and their ordering may
129      * change at any point.
130      *
131      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
132      * you perform all queries on the same block. See the following
133      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
134      * for more information.
135      */
136     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
137 
138     /**
139      * @dev Returns the number of accounts that have `role`. Can be used
140      * together with {getRoleMember} to enumerate all bearers of a role.
141      */
142     function getRoleMemberCount(bytes32 role) external view returns (uint256);
143 }
144 
145 
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Library for managing
151  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
152  * types.
153  *
154  * Sets have the following properties:
155  *
156  * - Elements are added, removed, and checked for existence in constant time
157  * (O(1)).
158  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
159  *
160  * ```
161  * contract Example {
162  *     // Add the library methods
163  *     using EnumerableSet for EnumerableSet.AddressSet;
164  *
165  *     // Declare a set state variable
166  *     EnumerableSet.AddressSet private mySet;
167  * }
168  * ```
169  *
170  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
171  * and `uint256` (`UintSet`) are supported.
172  */
173 library EnumerableSet {
174     // To implement this library for multiple types with as little code
175     // repetition as possible, we write it in terms of a generic Set type with
176     // bytes32 values.
177     // The Set implementation uses private functions, and user-facing
178     // implementations (such as AddressSet) are just wrappers around the
179     // underlying Set.
180     // This means that we can only create new EnumerableSets for types that fit
181     // in bytes32.
182 
183     struct Set {
184         // Storage of set values
185         bytes32[] _values;
186         // Position of the value in the `values` array, plus 1 because index 0
187         // means a value is not in the set.
188         mapping(bytes32 => uint256) _indexes;
189     }
190 
191     /**
192      * @dev Add a value to a set. O(1).
193      *
194      * Returns true if the value was added to the set, that is if it was not
195      * already present.
196      */
197     function _add(Set storage set, bytes32 value) private returns (bool) {
198         if (!_contains(set, value)) {
199             set._values.push(value);
200             // The value is stored at length-1, but we add 1 to all indexes
201             // and use 0 as a sentinel value
202             set._indexes[value] = set._values.length;
203             return true;
204         } else {
205             return false;
206         }
207     }
208 
209     /**
210      * @dev Removes a value from a set. O(1).
211      *
212      * Returns true if the value was removed from the set, that is if it was
213      * present.
214      */
215     function _remove(Set storage set, bytes32 value) private returns (bool) {
216         // We read and store the value's index to prevent multiple reads from the same storage slot
217         uint256 valueIndex = set._indexes[value];
218 
219         if (valueIndex != 0) {
220             // Equivalent to contains(set, value)
221             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
222             // the array, and then remove the last element (sometimes called as 'swap and pop').
223             // This modifies the order of the array, as noted in {at}.
224 
225             uint256 toDeleteIndex = valueIndex - 1;
226             uint256 lastIndex = set._values.length - 1;
227 
228             if (lastIndex != toDeleteIndex) {
229                 bytes32 lastvalue = set._values[lastIndex];
230 
231                 // Move the last value to the index where the value to delete is
232                 set._values[toDeleteIndex] = lastvalue;
233                 // Update the index for the moved value
234                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
235             }
236 
237             // Delete the slot where the moved value was stored
238             set._values.pop();
239 
240             // Delete the index for the deleted slot
241             delete set._indexes[value];
242 
243             return true;
244         } else {
245             return false;
246         }
247     }
248 
249     /**
250      * @dev Returns true if the value is in the set. O(1).
251      */
252     function _contains(Set storage set, bytes32 value) private view returns (bool) {
253         return set._indexes[value] != 0;
254     }
255 
256     /**
257      * @dev Returns the number of values on the set. O(1).
258      */
259     function _length(Set storage set) private view returns (uint256) {
260         return set._values.length;
261     }
262 
263     /**
264      * @dev Returns the value stored at position `index` in the set. O(1).
265      *
266      * Note that there are no guarantees on the ordering of values inside the
267      * array, and it may change when more values are added or removed.
268      *
269      * Requirements:
270      *
271      * - `index` must be strictly less than {length}.
272      */
273     function _at(Set storage set, uint256 index) private view returns (bytes32) {
274         return set._values[index];
275     }
276 
277     /**
278      * @dev Return the entire set in an array
279      *
280      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
281      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
282      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
283      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
284      */
285     function _values(Set storage set) private view returns (bytes32[] memory) {
286         return set._values;
287     }
288 
289     // Bytes32Set
290 
291     struct Bytes32Set {
292         Set _inner;
293     }
294 
295     /**
296      * @dev Add a value to a set. O(1).
297      *
298      * Returns true if the value was added to the set, that is if it was not
299      * already present.
300      */
301     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
302         return _add(set._inner, value);
303     }
304 
305     /**
306      * @dev Removes a value from a set. O(1).
307      *
308      * Returns true if the value was removed from the set, that is if it was
309      * present.
310      */
311     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
312         return _remove(set._inner, value);
313     }
314 
315     /**
316      * @dev Returns true if the value is in the set. O(1).
317      */
318     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
319         return _contains(set._inner, value);
320     }
321 
322     /**
323      * @dev Returns the number of values in the set. O(1).
324      */
325     function length(Bytes32Set storage set) internal view returns (uint256) {
326         return _length(set._inner);
327     }
328 
329     /**
330      * @dev Returns the value stored at position `index` in the set. O(1).
331      *
332      * Note that there are no guarantees on the ordering of values inside the
333      * array, and it may change when more values are added or removed.
334      *
335      * Requirements:
336      *
337      * - `index` must be strictly less than {length}.
338      */
339     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
340         return _at(set._inner, index);
341     }
342 
343     /**
344      * @dev Return the entire set in an array
345      *
346      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
347      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
348      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
349      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
350      */
351     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
352         return _values(set._inner);
353     }
354 
355     // AddressSet
356 
357     struct AddressSet {
358         Set _inner;
359     }
360 
361     /**
362      * @dev Add a value to a set. O(1).
363      *
364      * Returns true if the value was added to the set, that is if it was not
365      * already present.
366      */
367     function add(AddressSet storage set, address value) internal returns (bool) {
368         return _add(set._inner, bytes32(uint256(uint160(value))));
369     }
370 
371     /**
372      * @dev Removes a value from a set. O(1).
373      *
374      * Returns true if the value was removed from the set, that is if it was
375      * present.
376      */
377     function remove(AddressSet storage set, address value) internal returns (bool) {
378         return _remove(set._inner, bytes32(uint256(uint160(value))));
379     }
380 
381     /**
382      * @dev Returns true if the value is in the set. O(1).
383      */
384     function contains(AddressSet storage set, address value) internal view returns (bool) {
385         return _contains(set._inner, bytes32(uint256(uint160(value))));
386     }
387 
388     /**
389      * @dev Returns the number of values in the set. O(1).
390      */
391     function length(AddressSet storage set) internal view returns (uint256) {
392         return _length(set._inner);
393     }
394 
395     /**
396      * @dev Returns the value stored at position `index` in the set. O(1).
397      *
398      * Note that there are no guarantees on the ordering of values inside the
399      * array, and it may change when more values are added or removed.
400      *
401      * Requirements:
402      *
403      * - `index` must be strictly less than {length}.
404      */
405     function at(AddressSet storage set, uint256 index) internal view returns (address) {
406         return address(uint160(uint256(_at(set._inner, index))));
407     }
408 
409     /**
410      * @dev Return the entire set in an array
411      *
412      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
413      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
414      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
415      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
416      */
417     function values(AddressSet storage set) internal view returns (address[] memory) {
418         bytes32[] memory store = _values(set._inner);
419         address[] memory result;
420 
421         assembly {
422             result := store
423         }
424 
425         return result;
426     }
427 
428     // UintSet
429 
430     struct UintSet {
431         Set _inner;
432     }
433 
434     /**
435      * @dev Add a value to a set. O(1).
436      *
437      * Returns true if the value was added to the set, that is if it was not
438      * already present.
439      */
440     function add(UintSet storage set, uint256 value) internal returns (bool) {
441         return _add(set._inner, bytes32(value));
442     }
443 
444     /**
445      * @dev Removes a value from a set. O(1).
446      *
447      * Returns true if the value was removed from the set, that is if it was
448      * present.
449      */
450     function remove(UintSet storage set, uint256 value) internal returns (bool) {
451         return _remove(set._inner, bytes32(value));
452     }
453 
454     /**
455      * @dev Returns true if the value is in the set. O(1).
456      */
457     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
458         return _contains(set._inner, bytes32(value));
459     }
460 
461     /**
462      * @dev Returns the number of values on the set. O(1).
463      */
464     function length(UintSet storage set) internal view returns (uint256) {
465         return _length(set._inner);
466     }
467 
468     /**
469      * @dev Returns the value stored at position `index` in the set. O(1).
470      *
471      * Note that there are no guarantees on the ordering of values inside the
472      * array, and it may change when more values are added or removed.
473      *
474      * Requirements:
475      *
476      * - `index` must be strictly less than {length}.
477      */
478     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
479         return uint256(_at(set._inner, index));
480     }
481 
482     /**
483      * @dev Return the entire set in an array
484      *
485      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
486      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
487      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
488      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
489      */
490     function values(UintSet storage set) internal view returns (uint256[] memory) {
491         bytes32[] memory store = _values(set._inner);
492         uint256[] memory result;
493 
494         assembly {
495             result := store
496         }
497 
498         return result;
499     }
500 }
501 
502 
503 
504 
505 
506 pragma solidity ^0.8.0;
507 
508 
509 
510 /**
511  * @dev Required interface of an ERC721 compliant contract.
512  */
513 interface IERC721 is IERC165 {
514     /**
515      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
516      */
517     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
518 
519     /**
520      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
521      */
522     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
523 
524     /**
525      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
526      */
527     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
528 
529     /**
530      * @dev Returns the number of tokens in ``owner``'s account.
531      */
532     function balanceOf(address owner) external view returns (uint256 balance);
533 
534     /**
535      * @dev Returns the owner of the `tokenId` token.
536      *
537      * Requirements:
538      *
539      * - `tokenId` must exist.
540      */
541     function ownerOf(uint256 tokenId) external view returns (address owner);
542 
543     /**
544      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
545      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) external;
562 
563     /**
564      * @dev Transfers `tokenId` token from `from` to `to`.
565      *
566      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must be owned by `from`.
573      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
574      *
575      * Emits a {Transfer} event.
576      */
577     function transferFrom(
578         address from,
579         address to,
580         uint256 tokenId
581     ) external;
582 
583     /**
584      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
585      * The approval is cleared when the token is transferred.
586      *
587      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
588      *
589      * Requirements:
590      *
591      * - The caller must own the token or be an approved operator.
592      * - `tokenId` must exist.
593      *
594      * Emits an {Approval} event.
595      */
596     function approve(address to, uint256 tokenId) external;
597 
598     /**
599      * @dev Returns the account approved for `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function getApproved(uint256 tokenId) external view returns (address operator);
606 
607     /**
608      * @dev Approve or remove `operator` as an operator for the caller.
609      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
610      *
611      * Requirements:
612      *
613      * - The `operator` cannot be the caller.
614      *
615      * Emits an {ApprovalForAll} event.
616      */
617     function setApprovalForAll(address operator, bool _approved) external;
618 
619     /**
620      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
621      *
622      * See {setApprovalForAll}
623      */
624     function isApprovedForAll(address owner, address operator) external view returns (bool);
625 
626     /**
627      * @dev Safely transfers `tokenId` token from `from` to `to`.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must exist and be owned by `from`.
634      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
636      *
637      * Emits a {Transfer} event.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId,
643         bytes calldata data
644     ) external;
645 }
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
652  * @dev See https://eips.ethereum.org/EIPS/eip-721
653  */
654 interface IERC721Enumerable is IERC721 {
655     /**
656      * @dev Returns the total amount of tokens stored by the contract.
657      */
658     function totalSupply() external view returns (uint256);
659 
660     /**
661      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
662      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
663      */
664     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
665 
666     /**
667      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
668      * Use along with {totalSupply} to enumerate all tokens.
669      */
670     function tokenByIndex(uint256 index) external view returns (uint256);
671 }
672 
673 
674 
675 
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @title ERC721 token receiver interface
681  * @dev Interface for any contract that wants to support safeTransfers
682  * from ERC721 asset contracts.
683  */
684 interface IERC721Receiver {
685     /**
686      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
687      * by `operator` from `from`, this function is called.
688      *
689      * It must return its Solidity selector to confirm the token transfer.
690      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
691      *
692      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
693      */
694     function onERC721Received(
695         address operator,
696         address from,
697         uint256 tokenId,
698         bytes calldata data
699     ) external returns (bytes4);
700 }
701 
702 
703 
704 
705 pragma solidity ^0.8.0;
706 
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Metadata is IERC721 {
714     /**
715      * @dev Returns the token collection name.
716      */
717     function name() external view returns (string memory);
718 
719     /**
720      * @dev Returns the token collection symbol.
721      */
722     function symbol() external view returns (string memory);
723 
724     /**
725      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
726      */
727     function tokenURI(uint256 tokenId) external view returns (string memory);
728 }
729 
730 
731 
732 pragma solidity ^0.8.0;
733 
734 /**
735  * @dev Collection of functions related to the address type
736  */
737 library Address {
738     /**
739      * @dev Returns true if `account` is a contract.
740      *
741      * [IMPORTANT]
742      * ====
743      * It is unsafe to assume that an address for which this function returns
744      * false is an externally-owned account (EOA) and not a contract.
745      *
746      * Among others, `isContract` will return false for the following
747      * types of addresses:
748      *
749      *  - an externally-owned account
750      *  - a contract in construction
751      *  - an address where a contract will be created
752      *  - an address where a contract lived, but was destroyed
753      * ====
754      */
755     function isContract(address account) internal view returns (bool) {
756         // This method relies on extcodesize, which returns 0 for contracts in
757         // construction, since the code is only stored at the end of the
758         // constructor execution.
759 
760         uint256 size;
761         assembly {
762             size := extcodesize(account)
763         }
764         return size > 0;
765     }
766 
767     /**
768      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
769      * `recipient`, forwarding all available gas and reverting on errors.
770      *
771      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
772      * of certain opcodes, possibly making contracts go over the 2300 gas limit
773      * imposed by `transfer`, making them unable to receive funds via
774      * `transfer`. {sendValue} removes this limitation.
775      *
776      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
777      *
778      * IMPORTANT: because control is transferred to `recipient`, care must be
779      * taken to not create reentrancy vulnerabilities. Consider using
780      * {ReentrancyGuard} or the
781      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
782      */
783     function sendValue(address payable recipient, uint256 amount) internal {
784         require(address(this).balance >= amount, "Address: insufficient balance");
785 
786         (bool success, ) = recipient.call{value: amount}("");
787         require(success, "Address: unable to send value, recipient may have reverted");
788     }
789 
790     /**
791      * @dev Performs a Solidity function call using a low level `call`. A
792      * plain `call` is an unsafe replacement for a function call: use this
793      * function instead.
794      *
795      * If `target` reverts with a revert reason, it is bubbled up by this
796      * function (like regular Solidity function calls).
797      *
798      * Returns the raw returned data. To convert to the expected return value,
799      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
800      *
801      * Requirements:
802      *
803      * - `target` must be a contract.
804      * - calling `target` with `data` must not revert.
805      *
806      * _Available since v3.1._
807      */
808     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
809         return functionCall(target, data, "Address: low-level call failed");
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
814      * `errorMessage` as a fallback revert reason when `target` reverts.
815      *
816      * _Available since v3.1._
817      */
818     function functionCall(
819         address target,
820         bytes memory data,
821         string memory errorMessage
822     ) internal returns (bytes memory) {
823         return functionCallWithValue(target, data, 0, errorMessage);
824     }
825 
826     /**
827      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
828      * but also transferring `value` wei to `target`.
829      *
830      * Requirements:
831      *
832      * - the calling contract must have an ETH balance of at least `value`.
833      * - the called Solidity function must be `payable`.
834      *
835      * _Available since v3.1._
836      */
837     function functionCallWithValue(
838         address target,
839         bytes memory data,
840         uint256 value
841     ) internal returns (bytes memory) {
842         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
843     }
844 
845     /**
846      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
847      * with `errorMessage` as a fallback revert reason when `target` reverts.
848      *
849      * _Available since v3.1._
850      */
851     function functionCallWithValue(
852         address target,
853         bytes memory data,
854         uint256 value,
855         string memory errorMessage
856     ) internal returns (bytes memory) {
857         require(address(this).balance >= value, "Address: insufficient balance for call");
858         require(isContract(target), "Address: call to non-contract");
859 
860         (bool success, bytes memory returndata) = target.call{value: value}(data);
861         return verifyCallResult(success, returndata, errorMessage);
862     }
863 
864     /**
865      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
866      * but performing a static call.
867      *
868      * _Available since v3.3._
869      */
870     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
871         return functionStaticCall(target, data, "Address: low-level static call failed");
872     }
873 
874     /**
875      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
876      * but performing a static call.
877      *
878      * _Available since v3.3._
879      */
880     function functionStaticCall(
881         address target,
882         bytes memory data,
883         string memory errorMessage
884     ) internal view returns (bytes memory) {
885         require(isContract(target), "Address: static call to non-contract");
886 
887         (bool success, bytes memory returndata) = target.staticcall(data);
888         return verifyCallResult(success, returndata, errorMessage);
889     }
890 
891     /**
892      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
893      * but performing a delegate call.
894      *
895      * _Available since v3.4._
896      */
897     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
898         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
899     }
900 
901     /**
902      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
903      * but performing a delegate call.
904      *
905      * _Available since v3.4._
906      */
907     function functionDelegateCall(
908         address target,
909         bytes memory data,
910         string memory errorMessage
911     ) internal returns (bytes memory) {
912         require(isContract(target), "Address: delegate call to non-contract");
913 
914         (bool success, bytes memory returndata) = target.delegatecall(data);
915         return verifyCallResult(success, returndata, errorMessage);
916     }
917 
918     /**
919      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
920      * revert reason using the provided one.
921      *
922      * _Available since v4.3._
923      */
924     function verifyCallResult(
925         bool success,
926         bytes memory returndata,
927         string memory errorMessage
928     ) internal pure returns (bytes memory) {
929         if (success) {
930             return returndata;
931         } else {
932             // Look for revert reason and bubble it up if present
933             if (returndata.length > 0) {
934                 // The easiest way to bubble the revert reason is using memory via assembly
935 
936                 assembly {
937                     let returndata_size := mload(returndata)
938                     revert(add(32, returndata), returndata_size)
939                 }
940             } else {
941                 revert(errorMessage);
942             }
943         }
944     }
945 }
946 
947 
948 pragma solidity ^0.8.0;
949 
950 /**
951  * @dev Provides information about the current execution context, including the
952  * sender of the transaction and its data. While these are generally available
953  * via msg.sender and msg.data, they should not be accessed in such a direct
954  * manner, since when dealing with meta-transactions the account sending and
955  * paying for execution may not be the actual sender (as far as an application
956  * is concerned).
957  *
958  * This contract is only required for intermediate, library-like contracts.
959  */
960 abstract contract Context {
961     function _msgSender() internal view virtual returns (address) {
962         return msg.sender;
963     }
964 
965     function _msgData() internal view virtual returns (bytes calldata) {
966         return msg.data;
967     }
968 }
969 
970 
971 pragma solidity ^0.8.0;
972 
973 /**
974  * @dev String operations.
975  */
976 library Strings {
977     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
978 
979     /**
980      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
981      */
982     function toString(uint256 value) internal pure returns (string memory) {
983         // Inspired by OraclizeAPI's implementation - MIT licence
984         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
985 
986         if (value == 0) {
987             return "0";
988         }
989         uint256 temp = value;
990         uint256 digits;
991         while (temp != 0) {
992             digits++;
993             temp /= 10;
994         }
995         bytes memory buffer = new bytes(digits);
996         while (value != 0) {
997             digits -= 1;
998             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
999             value /= 10;
1000         }
1001         return string(buffer);
1002     }
1003 
1004     /**
1005      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1006      */
1007     function toHexString(uint256 value) internal pure returns (string memory) {
1008         if (value == 0) {
1009             return "0x00";
1010         }
1011         uint256 temp = value;
1012         uint256 length = 0;
1013         while (temp != 0) {
1014             length++;
1015             temp >>= 8;
1016         }
1017         return toHexString(value, length);
1018     }
1019 
1020     /**
1021      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1022      */
1023     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1024         bytes memory buffer = new bytes(2 * length + 2);
1025         buffer[0] = "0";
1026         buffer[1] = "x";
1027         for (uint256 i = 2 * length + 1; i > 1; --i) {
1028             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1029             value >>= 4;
1030         }
1031         require(value == 0, "Strings: hex length insufficient");
1032         return string(buffer);
1033     }
1034 }
1035 
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 
1040 /**
1041  * @dev Implementation of the {IERC165} interface.
1042  *
1043  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1044  * for the additional interface id that will be supported. For example:
1045  *
1046  * ```solidity
1047  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1048  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1049  * }
1050  * ```
1051  *
1052  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1053  */
1054 abstract contract ERC165 is IERC165 {
1055     /**
1056      * @dev See {IERC165-supportsInterface}.
1057      */
1058     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1059         return interfaceId == type(IERC165).interfaceId;
1060     }
1061 }
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 
1066 
1067 /**
1068  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1069  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1070  * {ERC721Enumerable}.
1071  */
1072 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1073     using Address for address;
1074     using Strings for uint256;
1075 
1076     // Token name
1077     string private _name;
1078 
1079     // Token symbol
1080     string private _symbol;
1081 
1082     // Mapping from token ID to owner address
1083     mapping(uint256 => address) private _owners;
1084 
1085     // Mapping owner address to token count
1086     mapping(address => uint256) private _balances;
1087 
1088     // Mapping from token ID to approved address
1089     mapping(uint256 => address) private _tokenApprovals;
1090 
1091     // Mapping from owner to operator approvals
1092     mapping(address => mapping(address => bool)) private _operatorApprovals;
1093 
1094     /**
1095      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1096      */
1097     constructor(string memory name_, string memory symbol_) {
1098         _name = name_;
1099         _symbol = symbol_;
1100     }
1101 
1102     /**
1103      * @dev See {IERC165-supportsInterface}.
1104      */
1105     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1106         return
1107             interfaceId == type(IERC721).interfaceId ||
1108             interfaceId == type(IERC721Metadata).interfaceId ||
1109             super.supportsInterface(interfaceId);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-balanceOf}.
1114      */
1115     function balanceOf(address owner) public view virtual override returns (uint256) {
1116         require(owner != address(0), "ERC721: balance query for the zero address");
1117         return _balances[owner];
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-ownerOf}.
1122      */
1123     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1124         address owner = _owners[tokenId];
1125         require(owner != address(0), "ERC721: owner query for nonexistent token");
1126         return owner;
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Metadata-name}.
1131      */
1132     function name() public view virtual override returns (string memory) {
1133         return _name;
1134     }
1135 
1136     /**
1137      * @dev See {IERC721Metadata-symbol}.
1138      */
1139     function symbol() public view virtual override returns (string memory) {
1140         return _symbol;
1141     }
1142 
1143     /**
1144      * @dev See {IERC721Metadata-tokenURI}.
1145      */
1146     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1147         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1148 
1149         string memory baseURI = _baseURI();
1150         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1151     }
1152 
1153     /**
1154      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1155      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1156      * by default, can be overriden in child contracts.
1157      */
1158     function _baseURI() internal view virtual returns (string memory) {
1159         return "";
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-approve}.
1164      */
1165     function approve(address to, uint256 tokenId) public virtual override {
1166         address owner = ERC721.ownerOf(tokenId);
1167         require(to != owner, "ERC721: approval to current owner");
1168 
1169         require(
1170             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1171             "ERC721: approve caller is not owner nor approved for all"
1172         );
1173 
1174         _approve(to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-getApproved}.
1179      */
1180     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1181         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1182 
1183         return _tokenApprovals[tokenId];
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-setApprovalForAll}.
1188      */
1189     function setApprovalForAll(address operator, bool approved) public virtual override {
1190         _setApprovalForAll(_msgSender(), operator, approved);
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-isApprovedForAll}.
1195      */
1196     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1197         return _operatorApprovals[owner][operator];
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-transferFrom}.
1202      */
1203     function transferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) public virtual override {
1208         //solhint-disable-next-line max-line-length
1209         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1210 
1211         _transfer(from, to, tokenId);
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-safeTransferFrom}.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) public virtual override {
1222         safeTransferFrom(from, to, tokenId, "");
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-safeTransferFrom}.
1227      */
1228     function safeTransferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId,
1232         bytes memory _data
1233     ) public virtual override {
1234         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1235         _safeTransfer(from, to, tokenId, _data);
1236     }
1237 
1238     /**
1239      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1240      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1241      *
1242      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1243      *
1244      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1245      * implement alternative mechanisms to perform token transfer, such as signature-based.
1246      *
1247      * Requirements:
1248      *
1249      * - `from` cannot be the zero address.
1250      * - `to` cannot be the zero address.
1251      * - `tokenId` token must exist and be owned by `from`.
1252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _safeTransfer(
1257         address from,
1258         address to,
1259         uint256 tokenId,
1260         bytes memory _data
1261     ) internal virtual {
1262         _transfer(from, to, tokenId);
1263         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1264     }
1265 
1266     /**
1267      * @dev Returns whether `tokenId` exists.
1268      *
1269      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1270      *
1271      * Tokens start existing when they are minted (`_mint`),
1272      * and stop existing when they are burned (`_burn`).
1273      */
1274     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1275         return _owners[tokenId] != address(0);
1276     }
1277 
1278     /**
1279      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1280      *
1281      * Requirements:
1282      *
1283      * - `tokenId` must exist.
1284      */
1285     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1286         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1287         address owner = ERC721.ownerOf(tokenId);
1288         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1289     }
1290 
1291     /**
1292      * @dev Safely mints `tokenId` and transfers it to `to`.
1293      *
1294      * Requirements:
1295      *
1296      * - `tokenId` must not exist.
1297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1298      *
1299      * Emits a {Transfer} event.
1300      */
1301     function _safeMint(address to, uint256 tokenId) internal virtual {
1302         _safeMint(to, tokenId, "");
1303     }
1304 
1305     /**
1306      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1307      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1308      */
1309     function _safeMint(
1310         address to,
1311         uint256 tokenId,
1312         bytes memory _data
1313     ) internal virtual {
1314         _mint(to, tokenId);
1315         require(
1316             _checkOnERC721Received(address(0), to, tokenId, _data),
1317             "ERC721: transfer to non ERC721Receiver implementer"
1318         );
1319     }
1320 
1321     /**
1322      * @dev Mints `tokenId` and transfers it to `to`.
1323      *
1324      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1325      *
1326      * Requirements:
1327      *
1328      * - `tokenId` must not exist.
1329      * - `to` cannot be the zero address.
1330      *
1331      * Emits a {Transfer} event.
1332      */
1333     function _mint(address to, uint256 tokenId) internal virtual {
1334         require(to != address(0), "ERC721: mint to the zero address");
1335         require(!_exists(tokenId), "ERC721: token already minted");
1336 
1337         _beforeTokenTransfer(address(0), to, tokenId);
1338 
1339         _balances[to] += 1;
1340         _owners[tokenId] = to;
1341 
1342         emit Transfer(address(0), to, tokenId);
1343     }
1344 
1345     /**
1346      * @dev Destroys `tokenId`.
1347      * The approval is cleared when the token is burned.
1348      *
1349      * Requirements:
1350      *
1351      * - `tokenId` must exist.
1352      *
1353      * Emits a {Transfer} event.
1354      */
1355     function _burn(uint256 tokenId) internal virtual {
1356         address owner = ERC721.ownerOf(tokenId);
1357 
1358         _beforeTokenTransfer(owner, address(0), tokenId);
1359 
1360         // Clear approvals
1361         _approve(address(0), tokenId);
1362 
1363         _balances[owner] -= 1;
1364         delete _owners[tokenId];
1365 
1366         emit Transfer(owner, address(0), tokenId);
1367     }
1368 
1369     /**
1370      * @dev Transfers `tokenId` from `from` to `to`.
1371      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1372      *
1373      * Requirements:
1374      *
1375      * - `to` cannot be the zero address.
1376      * - `tokenId` token must be owned by `from`.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function _transfer(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) internal virtual {
1385         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1386         require(to != address(0), "ERC721: transfer to the zero address");
1387 
1388         _beforeTokenTransfer(from, to, tokenId);
1389 
1390         // Clear approvals from the previous owner
1391         _approve(address(0), tokenId);
1392 
1393         _balances[from] -= 1;
1394         _balances[to] += 1;
1395         _owners[tokenId] = to;
1396 
1397         emit Transfer(from, to, tokenId);
1398     }
1399 
1400     /**
1401      * @dev Approve `to` to operate on `tokenId`
1402      *
1403      * Emits a {Approval} event.
1404      */
1405     function _approve(address to, uint256 tokenId) internal virtual {
1406         _tokenApprovals[tokenId] = to;
1407         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1408     }
1409 
1410     /**
1411      * @dev Approve `operator` to operate on all of `owner` tokens
1412      *
1413      * Emits a {ApprovalForAll} event.
1414      */
1415     function _setApprovalForAll(
1416         address owner,
1417         address operator,
1418         bool approved
1419     ) internal virtual {
1420         require(owner != operator, "ERC721: approve to caller");
1421         _operatorApprovals[owner][operator] = approved;
1422         emit ApprovalForAll(owner, operator, approved);
1423     }
1424 
1425     /**
1426      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1427      * The call is not executed if the target address is not a contract.
1428      *
1429      * @param from address representing the previous owner of the given token ID
1430      * @param to target address that will receive the tokens
1431      * @param tokenId uint256 ID of the token to be transferred
1432      * @param _data bytes optional data to send along with the call
1433      * @return bool whether the call correctly returned the expected magic value
1434      */
1435     function _checkOnERC721Received(
1436         address from,
1437         address to,
1438         uint256 tokenId,
1439         bytes memory _data
1440     ) private returns (bool) {
1441         if (to.isContract()) {
1442             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1443                 return retval == IERC721Receiver.onERC721Received.selector;
1444             } catch (bytes memory reason) {
1445                 if (reason.length == 0) {
1446                     revert("ERC721: transfer to non ERC721Receiver implementer");
1447                 } else {
1448                     assembly {
1449                         revert(add(32, reason), mload(reason))
1450                     }
1451                 }
1452             }
1453         } else {
1454             return true;
1455         }
1456     }
1457 
1458     /**
1459      * @dev Hook that is called before any token transfer. This includes minting
1460      * and burning.
1461      *
1462      * Calling conditions:
1463      *
1464      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1465      * transferred to `to`.
1466      * - When `from` is zero, `tokenId` will be minted for `to`.
1467      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1468      * - `from` and `to` are never both zero.
1469      *
1470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1471      */
1472     function _beforeTokenTransfer(
1473         address from,
1474         address to,
1475         uint256 tokenId
1476     ) internal virtual {}
1477 }
1478 
1479 
1480 
1481 
1482 
1483 pragma solidity ^0.8.0;
1484 
1485 
1486 
1487 /**
1488  * @dev Contract module that allows children to implement role-based access
1489  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1490  * members except through off-chain means by accessing the contract event logs. Some
1491  * applications may benefit from on-chain enumerability, for those cases see
1492  * {AccessControlEnumerable}.
1493  *
1494  * Roles are referred to by their `bytes32` identifier. These should be exposed
1495  * in the external API and be unique. The best way to achieve this is by
1496  * using `public constant` hash digests:
1497  *
1498  * ```
1499  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1500  * ```
1501  *
1502  * Roles can be used to represent a set of permissions. To restrict access to a
1503  * function call, use {hasRole}:
1504  *
1505  * ```
1506  * function foo() public {
1507  *     require(hasRole(MY_ROLE, msg.sender));
1508  *     ...
1509  * }
1510  * ```
1511  *
1512  * Roles can be granted and revoked dynamically via the {grantRole} and
1513  * {revokeRole} functions. Each role has an associated admin role, and only
1514  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1515  *
1516  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1517  * that only accounts with this role will be able to grant or revoke other
1518  * roles. More complex role relationships can be created by using
1519  * {_setRoleAdmin}.
1520  *
1521  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1522  * grant and revoke this role. Extra precautions should be taken to secure
1523  * accounts that have been granted it.
1524  */
1525 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1526     struct RoleData {
1527         mapping(address => bool) members;
1528         bytes32 adminRole;
1529     }
1530 
1531     mapping(bytes32 => RoleData) private _roles;
1532 
1533     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1534 
1535     /**
1536      * @dev Modifier that checks that an account has a specific role. Reverts
1537      * with a standardized message including the required role.
1538      *
1539      * The format of the revert reason is given by the following regular expression:
1540      *
1541      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1542      *
1543      * _Available since v4.1._
1544      */
1545     modifier onlyRole(bytes32 role) {
1546         _checkRole(role, _msgSender());
1547         _;
1548     }
1549 
1550     /**
1551      * @dev See {IERC165-supportsInterface}.
1552      */
1553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1554         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1555     }
1556 
1557     /**
1558      * @dev Returns `true` if `account` has been granted `role`.
1559      */
1560     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1561         return _roles[role].members[account];
1562     }
1563 
1564     /**
1565      * @dev Revert with a standard message if `account` is missing `role`.
1566      *
1567      * The format of the revert reason is given by the following regular expression:
1568      *
1569      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1570      */
1571     function _checkRole(bytes32 role, address account) internal view virtual {
1572         if (!hasRole(role, account)) {
1573             revert(
1574                 string(
1575                     abi.encodePacked(
1576                         "AccessControl: account ",
1577                         Strings.toHexString(uint160(account), 20),
1578                         " is missing role ",
1579                         Strings.toHexString(uint256(role), 32)
1580                     )
1581                 )
1582             );
1583         }
1584     }
1585 
1586     /**
1587      * @dev Returns the admin role that controls `role`. See {grantRole} and
1588      * {revokeRole}.
1589      *
1590      * To change a role's admin, use {_setRoleAdmin}.
1591      */
1592     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1593         return _roles[role].adminRole;
1594     }
1595 
1596     /**
1597      * @dev Grants `role` to `account`.
1598      *
1599      * If `account` had not been already granted `role`, emits a {RoleGranted}
1600      * event.
1601      *
1602      * Requirements:
1603      *
1604      * - the caller must have ``role``'s admin role.
1605      */
1606     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1607         _grantRole(role, account);
1608     }
1609 
1610     /**
1611      * @dev Revokes `role` from `account`.
1612      *
1613      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1614      *
1615      * Requirements:
1616      *
1617      * - the caller must have ``role``'s admin role.
1618      */
1619     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1620         _revokeRole(role, account);
1621     }
1622 
1623     /**
1624      * @dev Revokes `role` from the calling account.
1625      *
1626      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1627      * purpose is to provide a mechanism for accounts to lose their privileges
1628      * if they are compromised (such as when a trusted device is misplaced).
1629      *
1630      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1631      * event.
1632      *
1633      * Requirements:
1634      *
1635      * - the caller must be `account`.
1636      */
1637     function renounceRole(bytes32 role, address account) public virtual override {
1638         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1639 
1640         _revokeRole(role, account);
1641     }
1642 
1643     /**
1644      * @dev Grants `role` to `account`.
1645      *
1646      * If `account` had not been already granted `role`, emits a {RoleGranted}
1647      * event. Note that unlike {grantRole}, this function doesn't perform any
1648      * checks on the calling account.
1649      *
1650      * [WARNING]
1651      * ====
1652      * This function should only be called from the constructor when setting
1653      * up the initial roles for the system.
1654      *
1655      * Using this function in any other way is effectively circumventing the admin
1656      * system imposed by {AccessControl}.
1657      * ====
1658      *
1659      * NOTE: This function is deprecated in favor of {_grantRole}.
1660      */
1661     function _setupRole(bytes32 role, address account) internal virtual {
1662         _grantRole(role, account);
1663     }
1664 
1665     /**
1666      * @dev Sets `adminRole` as ``role``'s admin role.
1667      *
1668      * Emits a {RoleAdminChanged} event.
1669      */
1670     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1671         bytes32 previousAdminRole = getRoleAdmin(role);
1672         _roles[role].adminRole = adminRole;
1673         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1674     }
1675 
1676     /**
1677      * @dev Grants `role` to `account`.
1678      *
1679      * Internal function without access restriction.
1680      */
1681     function _grantRole(bytes32 role, address account) internal virtual {
1682         if (!hasRole(role, account)) {
1683             _roles[role].members[account] = true;
1684             emit RoleGranted(role, account, _msgSender());
1685         }
1686     }
1687 
1688     /**
1689      * @dev Revokes `role` from `account`.
1690      *
1691      * Internal function without access restriction.
1692      */
1693     function _revokeRole(bytes32 role, address account) internal virtual {
1694         if (hasRole(role, account)) {
1695             _roles[role].members[account] = false;
1696             emit RoleRevoked(role, account, _msgSender());
1697         }
1698     }
1699 }
1700 
1701 
1702 pragma solidity ^0.8.0;
1703 
1704 
1705 /**
1706  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1707  * enumerability of all the token ids in the contract as well as all token ids owned by each
1708  * account.
1709  */
1710 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1711     // Mapping from owner to list of owned token IDs
1712     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1713 
1714     // Mapping from token ID to index of the owner tokens list
1715     mapping(uint256 => uint256) private _ownedTokensIndex;
1716 
1717     // Array with all token ids, used for enumeration
1718     uint256[] private _allTokens;
1719 
1720     // Mapping from token id to position in the allTokens array
1721     mapping(uint256 => uint256) private _allTokensIndex;
1722 
1723     /**
1724      * @dev See {IERC165-supportsInterface}.
1725      */
1726     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1727         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1728     }
1729 
1730     /**
1731      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1732      */
1733     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1734         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1735         return _ownedTokens[owner][index];
1736     }
1737 
1738     /**
1739      * @dev See {IERC721Enumerable-totalSupply}.
1740      */
1741     function totalSupply() public view virtual override returns (uint256) {
1742         return _allTokens.length;
1743     }
1744 
1745     /**
1746      * @dev See {IERC721Enumerable-tokenByIndex}.
1747      */
1748     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1749         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1750         return _allTokens[index];
1751     }
1752 
1753     /**
1754      * @dev Hook that is called before any token transfer. This includes minting
1755      * and burning.
1756      *
1757      * Calling conditions:
1758      *
1759      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1760      * transferred to `to`.
1761      * - When `from` is zero, `tokenId` will be minted for `to`.
1762      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1763      * - `from` cannot be the zero address.
1764      * - `to` cannot be the zero address.
1765      *
1766      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1767      */
1768     function _beforeTokenTransfer(
1769         address from,
1770         address to,
1771         uint256 tokenId
1772     ) internal virtual override {
1773         super._beforeTokenTransfer(from, to, tokenId);
1774 
1775         if (from == address(0)) {
1776             _addTokenToAllTokensEnumeration(tokenId);
1777         } else if (from != to) {
1778             _removeTokenFromOwnerEnumeration(from, tokenId);
1779         }
1780         if (to == address(0)) {
1781             _removeTokenFromAllTokensEnumeration(tokenId);
1782         } else if (to != from) {
1783             _addTokenToOwnerEnumeration(to, tokenId);
1784         }
1785     }
1786 
1787     /**
1788      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1789      * @param to address representing the new owner of the given token ID
1790      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1791      */
1792     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1793         uint256 length = ERC721.balanceOf(to);
1794         _ownedTokens[to][length] = tokenId;
1795         _ownedTokensIndex[tokenId] = length;
1796     }
1797 
1798     /**
1799      * @dev Private function to add a token to this extension's token tracking data structures.
1800      * @param tokenId uint256 ID of the token to be added to the tokens list
1801      */
1802     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1803         _allTokensIndex[tokenId] = _allTokens.length;
1804         _allTokens.push(tokenId);
1805     }
1806 
1807     /**
1808      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1809      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1810      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1811      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1812      * @param from address representing the previous owner of the given token ID
1813      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1814      */
1815     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1816         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1817         // then delete the last slot (swap and pop).
1818 
1819         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1820         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1821 
1822         // When the token to delete is the last token, the swap operation is unnecessary
1823         if (tokenIndex != lastTokenIndex) {
1824             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1825 
1826             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1827             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1828         }
1829 
1830         // This also deletes the contents at the last position of the array
1831         delete _ownedTokensIndex[tokenId];
1832         delete _ownedTokens[from][lastTokenIndex];
1833     }
1834 
1835     /**
1836      * @dev Private function to remove a token from this extension's token tracking data structures.
1837      * This has O(1) time complexity, but alters the order of the _allTokens array.
1838      * @param tokenId uint256 ID of the token to be removed from the tokens list
1839      */
1840     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1841         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1842         // then delete the last slot (swap and pop).
1843 
1844         uint256 lastTokenIndex = _allTokens.length - 1;
1845         uint256 tokenIndex = _allTokensIndex[tokenId];
1846 
1847         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1848         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1849         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1850         uint256 lastTokenId = _allTokens[lastTokenIndex];
1851 
1852         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1853         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1854 
1855         // This also deletes the contents at the last position of the array
1856         delete _allTokensIndex[tokenId];
1857         _allTokens.pop();
1858     }
1859 }
1860 
1861 
1862 pragma solidity ^0.8.0;
1863 
1864 
1865 /**
1866  * @dev Contract module which provides a basic access control mechanism, where
1867  * there is an account (an owner) that can be granted exclusive access to
1868  * specific functions.
1869  *
1870  * By default, the owner account will be the one that deploys the contract. This
1871  * can later be changed with {transferOwnership}.
1872  *
1873  * This module is used through inheritance. It will make available the modifier
1874  * `onlyOwner`, which can be applied to your functions to restrict their use to
1875  * the owner.
1876  */
1877 abstract contract Ownable is Context {
1878     address private _owner;
1879 
1880     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1881 
1882     /**
1883      * @dev Initializes the contract setting the deployer as the initial owner.
1884      */
1885     constructor() {
1886         _transferOwnership(_msgSender());
1887     }
1888 
1889     /**
1890      * @dev Returns the address of the current owner.
1891      */
1892     function owner() public view virtual returns (address) {
1893         return _owner;
1894     }
1895 
1896     /**
1897      * @dev Throws if called by any account other than the owner.
1898      */
1899     modifier onlyOwner() {
1900         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1901         _;
1902     }
1903 
1904     /**
1905      * @dev Leaves the contract without owner. It will not be possible to call
1906      * `onlyOwner` functions anymore. Can only be called by the current owner.
1907      *
1908      * NOTE: Renouncing ownership will leave the contract without an owner,
1909      * thereby removing any functionality that is only available to the owner.
1910      */
1911     function renounceOwnership() public virtual onlyOwner {
1912         _transferOwnership(address(0));
1913     }
1914 
1915     /**
1916      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1917      * Can only be called by the current owner.
1918      */
1919     function transferOwnership(address newOwner) public virtual onlyOwner {
1920         require(newOwner != address(0), "Ownable: new owner is the zero address");
1921         _transferOwnership(newOwner);
1922     }
1923 
1924     /**
1925      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1926      * Internal function without access restriction.
1927      */
1928     function _transferOwnership(address newOwner) internal virtual {
1929         address oldOwner = _owner;
1930         _owner = newOwner;
1931         emit OwnershipTransferred(oldOwner, newOwner);
1932     }
1933 }
1934 
1935 
1936 pragma solidity ^0.8.0;
1937 
1938 
1939 
1940 /**
1941  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1942  */
1943 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1944     using EnumerableSet for EnumerableSet.AddressSet;
1945 
1946     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1947 
1948     /**
1949      * @dev See {IERC165-supportsInterface}.
1950      */
1951     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1952         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1953     }
1954 
1955     /**
1956      * @dev Returns one of the accounts that have `role`. `index` must be a
1957      * value between 0 and {getRoleMemberCount}, non-inclusive.
1958      *
1959      * Role bearers are not sorted in any particular way, and their ordering may
1960      * change at any point.
1961      *
1962      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1963      * you perform all queries on the same block. See the following
1964      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1965      * for more information.
1966      */
1967     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1968         return _roleMembers[role].at(index);
1969     }
1970 
1971     /**
1972      * @dev Returns the number of accounts that have `role`. Can be used
1973      * together with {getRoleMember} to enumerate all bearers of a role.
1974      */
1975     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1976         return _roleMembers[role].length();
1977     }
1978 
1979     /**
1980      * @dev Overload {_grantRole} to track enumerable memberships
1981      */
1982     function _grantRole(bytes32 role, address account) internal virtual override {
1983         super._grantRole(role, account);
1984         _roleMembers[role].add(account);
1985     }
1986 
1987     /**
1988      * @dev Overload {_revokeRole} to track enumerable memberships
1989      */
1990     function _revokeRole(bytes32 role, address account) internal virtual override {
1991         super._revokeRole(role, account);
1992         _roleMembers[role].remove(account);
1993     }
1994 }
1995 
1996 
1997 pragma solidity ^0.8.0;
1998 
1999 /**
2000  * @dev Contract module that helps prevent reentrant calls to a function.
2001  *
2002  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2003  * available, which can be applied to functions to make sure there are no nested
2004  * (reentrant) calls to them.
2005  *
2006  * Note that because there is a single `nonReentrant` guard, functions marked as
2007  * `nonReentrant` may not call one another. This can be worked around by making
2008  * those functions `private`, and then adding `external` `nonReentrant` entry
2009  * points to them.
2010  *
2011  * TIP: If you would like to learn more about reentrancy and alternative ways
2012  * to protect against it, check out our blog post
2013  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2014  */
2015 abstract contract ReentrancyGuard {
2016     // Booleans are more expensive than uint256 or any type that takes up a full
2017     // word because each write operation emits an extra SLOAD to first read the
2018     // slot's contents, replace the bits taken up by the boolean, and then write
2019     // back. This is the compiler's defense against contract upgrades and
2020     // pointer aliasing, and it cannot be disabled.
2021 
2022     // The values being non-zero value makes deployment a bit more expensive,
2023     // but in exchange the refund on every call to nonReentrant will be lower in
2024     // amount. Since refunds are capped to a percentage of the total
2025     // transaction's gas, it is best to keep them low in cases like this one, to
2026     // increase the likelihood of the full refund coming into effect.
2027     uint256 private constant _NOT_ENTERED = 1;
2028     uint256 private constant _ENTERED = 2;
2029 
2030     uint256 private _status;
2031 
2032     constructor() {
2033         _status = _NOT_ENTERED;
2034     }
2035 
2036     /**
2037      * @dev Prevents a contract from calling itself, directly or indirectly.
2038      * Calling a `nonReentrant` function from another `nonReentrant`
2039      * function is not supported. It is possible to prevent this from happening
2040      * by making the `nonReentrant` function external, and making it call a
2041      * `private` function that does the actual work.
2042      */
2043     modifier nonReentrant() {
2044         // On the first call to nonReentrant, _notEntered will be true
2045         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2046 
2047         // Any calls to nonReentrant after this point will fail
2048         _status = _ENTERED;
2049 
2050         _;
2051 
2052         // By storing the original value once again, a refund is triggered (see
2053         // https://eips.ethereum.org/EIPS/eip-2200)
2054         _status = _NOT_ENTERED;
2055     }
2056 }
2057 
2058 
2059 
2060 
2061 
2062 pragma solidity ^0.8.4;
2063 
2064 
2065 error ApprovalCallerNotOwnerNorApproved();
2066 error ApprovalQueryForNonexistentToken();
2067 error ApproveToCaller();
2068 error ApprovalToCurrentOwner();
2069 error BalanceQueryForZeroAddress();
2070 error MintToZeroAddress();
2071 error MintZeroQuantity();
2072 error OwnerQueryForNonexistentToken();
2073 error TransferCallerNotOwnerNorApproved();
2074 error TransferFromIncorrectOwner();
2075 error TransferToNonERC721ReceiverImplementer();
2076 error TransferToZeroAddress();
2077 error URIQueryForNonexistentToken();
2078 
2079 /**
2080  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2081  * the Metadata extension. Built to optimize for lower gas during batch mints.
2082  *
2083  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2084  *
2085  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2086  *
2087  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2088  */
2089 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2090     using Address for address;
2091     using Strings for uint256;
2092 
2093     // Compiler will pack this into a single 256bit word.
2094     struct TokenOwnership {
2095         // The address of the owner.
2096         address addr;
2097         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2098         uint64 startTimestamp;
2099         // Whether the token has been burned.
2100         bool burned;
2101     }
2102 
2103     // Compiler will pack this into a single 256bit word.
2104     struct AddressData {
2105         // Realistically, 2**64-1 is more than enough.
2106         uint64 balance;
2107         // Keeps track of mint count with minimal overhead for tokenomics.
2108         uint64 numberMinted;
2109         // Keeps track of burn count with minimal overhead for tokenomics.
2110         uint64 numberBurned;
2111         // For miscellaneous variable(s) pertaining to the address
2112         // (e.g. number of whitelist mint slots used).
2113         // If there are multiple variables, please pack them into a uint64.
2114         uint64 aux;
2115     }
2116 
2117     // The tokenId of the next token to be minted.
2118     uint256 internal _currentIndex;
2119 
2120     // The number of tokens burned.
2121     uint256 internal _burnCounter;
2122 
2123     // Token name
2124     string private _name;
2125 
2126     // Token symbol
2127     string private _symbol;
2128 
2129     // Mapping from token ID to ownership details
2130     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2131     mapping(uint256 => TokenOwnership) internal _ownerships;
2132 
2133     // Mapping owner address to address data
2134     mapping(address => AddressData) private _addressData;
2135 
2136     // Mapping from token ID to approved address
2137     mapping(uint256 => address) private _tokenApprovals;
2138 
2139     // Mapping from owner to operator approvals
2140     mapping(address => mapping(address => bool)) private _operatorApprovals;
2141 
2142     constructor(string memory name_, string memory symbol_) {
2143         _name = name_;
2144         _symbol = symbol_;
2145         _currentIndex = _startTokenId();
2146     }
2147 
2148     /**
2149      * To change the starting tokenId, please override this function.
2150      */
2151     function _startTokenId() internal view virtual returns (uint256) {
2152         return 0;
2153     }
2154 
2155     /**
2156      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2157      */
2158     function totalSupply() public view returns (uint256) {
2159         // Counter underflow is impossible as _burnCounter cannot be incremented
2160         // more than _currentIndex - _startTokenId() times
2161         unchecked {
2162             return _currentIndex - _burnCounter - _startTokenId();
2163         }
2164     }
2165 
2166     /**
2167      * Returns the total amount of tokens minted in the contract.
2168      */
2169     function _totalMinted() internal view returns (uint256) {
2170         // Counter underflow is impossible as _currentIndex does not decrement,
2171         // and it is initialized to _startTokenId()
2172         unchecked {
2173             return _currentIndex - _startTokenId();
2174         }
2175     }
2176 
2177     /**
2178      * @dev See {IERC165-supportsInterface}.
2179      */
2180     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2181         return
2182             interfaceId == type(IERC721).interfaceId ||
2183             interfaceId == type(IERC721Metadata).interfaceId ||
2184             super.supportsInterface(interfaceId);
2185     }
2186 
2187     /**
2188      * @dev See {IERC721-balanceOf}.
2189      */
2190     function balanceOf(address owner) public view override returns (uint256) {
2191         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2192         return uint256(_addressData[owner].balance);
2193     }
2194 
2195     /**
2196      * Returns the number of tokens minted by `owner`.
2197      */
2198     function _numberMinted(address owner) internal view returns (uint256) {
2199         return uint256(_addressData[owner].numberMinted);
2200     }
2201 
2202     /**
2203      * Returns the number of tokens burned by or on behalf of `owner`.
2204      */
2205     function _numberBurned(address owner) internal view returns (uint256) {
2206         return uint256(_addressData[owner].numberBurned);
2207     }
2208 
2209     /**
2210      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2211      */
2212     function _getAux(address owner) internal view returns (uint64) {
2213         return _addressData[owner].aux;
2214     }
2215 
2216     /**
2217      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2218      * If there are multiple variables, please pack them into a uint64.
2219      */
2220     function _setAux(address owner, uint64 aux) internal {
2221         _addressData[owner].aux = aux;
2222     }
2223 
2224     /**
2225      * Gas spent here starts off proportional to the maximum mint batch size.
2226      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2227      */
2228     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2229         uint256 curr = tokenId;
2230 
2231         unchecked {
2232             if (_startTokenId() <= curr && curr < _currentIndex) {
2233                 TokenOwnership memory ownership = _ownerships[curr];
2234                 if (!ownership.burned) {
2235                     if (ownership.addr != address(0)) {
2236                         return ownership;
2237                     }
2238                     // Invariant:
2239                     // There will always be an ownership that has an address and is not burned
2240                     // before an ownership that does not have an address and is not burned.
2241                     // Hence, curr will not underflow.
2242                     while (true) {
2243                         curr--;
2244                         ownership = _ownerships[curr];
2245                         if (ownership.addr != address(0)) {
2246                             return ownership;
2247                         }
2248                     }
2249                 }
2250             }
2251         }
2252         revert OwnerQueryForNonexistentToken();
2253     }
2254 
2255     /**
2256      * @dev See {IERC721-ownerOf}.
2257      */
2258     function ownerOf(uint256 tokenId) public view override returns (address) {
2259         return _ownershipOf(tokenId).addr;
2260     }
2261 
2262     /**
2263      * @dev See {IERC721Metadata-name}.
2264      */
2265     function name() public view virtual override returns (string memory) {
2266         return _name;
2267     }
2268 
2269     /**
2270      * @dev See {IERC721Metadata-symbol}.
2271      */
2272     function symbol() public view virtual override returns (string memory) {
2273         return _symbol;
2274     }
2275 
2276     /**
2277      * @dev See {IERC721Metadata-tokenURI}.
2278      */
2279     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2280         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2281 
2282         string memory baseURI = _baseURI();
2283         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2284     }
2285 
2286     /**
2287      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2288      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2289      * by default, can be overriden in child contracts.
2290      */
2291     function _baseURI() internal view virtual returns (string memory) {
2292         return '';
2293     }
2294 
2295     /**
2296      * @dev See {IERC721-approve}.
2297      */
2298     function approve(address to, uint256 tokenId) public override {
2299         address owner = ERC721A.ownerOf(tokenId);
2300         if (to == owner) revert ApprovalToCurrentOwner();
2301 
2302         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2303             revert ApprovalCallerNotOwnerNorApproved();
2304         }
2305 
2306         _approve(to, tokenId, owner);
2307     }
2308 
2309     /**
2310      * @dev See {IERC721-getApproved}.
2311      */
2312     function getApproved(uint256 tokenId) public view override returns (address) {
2313         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2314 
2315         return _tokenApprovals[tokenId];
2316     }
2317 
2318     /**
2319      * @dev See {IERC721-setApprovalForAll}.
2320      */
2321     function setApprovalForAll(address operator, bool approved) public virtual override {
2322         if (operator == _msgSender()) revert ApproveToCaller();
2323 
2324         _operatorApprovals[_msgSender()][operator] = approved;
2325         emit ApprovalForAll(_msgSender(), operator, approved);
2326     }
2327 
2328     /**
2329      * @dev See {IERC721-isApprovedForAll}.
2330      */
2331     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2332         return _operatorApprovals[owner][operator];
2333     }
2334 
2335     /**
2336      * @dev See {IERC721-transferFrom}.
2337      */
2338     function transferFrom(
2339         address from,
2340         address to,
2341         uint256 tokenId
2342     ) public virtual override {
2343         _transfer(from, to, tokenId);
2344     }
2345 
2346     /**
2347      * @dev See {IERC721-safeTransferFrom}.
2348      */
2349     function safeTransferFrom(
2350         address from,
2351         address to,
2352         uint256 tokenId
2353     ) public virtual override {
2354         safeTransferFrom(from, to, tokenId, '');
2355     }
2356 
2357     /**
2358      * @dev See {IERC721-safeTransferFrom}.
2359      */
2360     function safeTransferFrom(
2361         address from,
2362         address to,
2363         uint256 tokenId,
2364         bytes memory _data
2365     ) public virtual override {
2366         _transfer(from, to, tokenId);
2367         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2368             revert TransferToNonERC721ReceiverImplementer();
2369         }
2370     }
2371 
2372     /**
2373      * @dev Returns whether `tokenId` exists.
2374      *
2375      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2376      *
2377      * Tokens start existing when they are minted (`_mint`),
2378      */
2379     function _exists(uint256 tokenId) internal view returns (bool) {
2380         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
2381             !_ownerships[tokenId].burned;
2382     }
2383 
2384     function _safeMint(address to, uint256 quantity) internal {
2385         _safeMint(to, quantity, '');
2386     }
2387 
2388     /**
2389      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2390      *
2391      * Requirements:
2392      *
2393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2394      * - `quantity` must be greater than 0.
2395      *
2396      * Emits a {Transfer} event.
2397      */
2398     function _safeMint(
2399         address to,
2400         uint256 quantity,
2401         bytes memory _data
2402     ) internal {
2403         _mint(to, quantity, _data, true);
2404     }
2405 
2406     /**
2407      * @dev Mints `quantity` tokens and transfers them to `to`.
2408      *
2409      * Requirements:
2410      *
2411      * - `to` cannot be the zero address.
2412      * - `quantity` must be greater than 0.
2413      *
2414      * Emits a {Transfer} event.
2415      */
2416     function _mint(
2417         address to,
2418         uint256 quantity,
2419         bytes memory _data,
2420         bool safe
2421     ) internal {
2422         uint256 startTokenId = _currentIndex;
2423         if (to == address(0)) revert MintToZeroAddress();
2424         if (quantity == 0) revert MintZeroQuantity();
2425 
2426         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2427 
2428         // Overflows are incredibly unrealistic.
2429         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2430         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2431         unchecked {
2432             _addressData[to].balance += uint64(quantity);
2433             _addressData[to].numberMinted += uint64(quantity);
2434 
2435             _ownerships[startTokenId].addr = to;
2436             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2437 
2438             uint256 updatedIndex = startTokenId;
2439             uint256 end = updatedIndex + quantity;
2440 
2441             if (safe && to.isContract()) {
2442                 do {
2443                     emit Transfer(address(0), to, updatedIndex);
2444                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2445                         revert TransferToNonERC721ReceiverImplementer();
2446                     }
2447                 } while (updatedIndex != end);
2448                 // Reentrancy protection
2449                 if (_currentIndex != startTokenId) revert();
2450             } else {
2451                 do {
2452                     emit Transfer(address(0), to, updatedIndex++);
2453                 } while (updatedIndex != end);
2454             }
2455             _currentIndex = updatedIndex;
2456         }
2457         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2458     }
2459 
2460     /**
2461      * @dev Transfers `tokenId` from `from` to `to`.
2462      *
2463      * Requirements:
2464      *
2465      * - `to` cannot be the zero address.
2466      * - `tokenId` token must be owned by `from`.
2467      *
2468      * Emits a {Transfer} event.
2469      */
2470     function _transfer(
2471         address from,
2472         address to,
2473         uint256 tokenId
2474     ) private {
2475         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2476 
2477         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2478 
2479         bool isApprovedOrOwner = (_msgSender() == from ||
2480             isApprovedForAll(from, _msgSender()) ||
2481             getApproved(tokenId) == _msgSender());
2482 
2483         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2484         if (to == address(0)) revert TransferToZeroAddress();
2485 
2486         _beforeTokenTransfers(from, to, tokenId, 1);
2487 
2488         // Clear approvals from the previous owner
2489         _approve(address(0), tokenId, from);
2490 
2491         // Underflow of the sender's balance is impossible because we check for
2492         // ownership above and the recipient's balance can't realistically overflow.
2493         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2494         unchecked {
2495             _addressData[from].balance -= 1;
2496             _addressData[to].balance += 1;
2497 
2498             TokenOwnership storage currSlot = _ownerships[tokenId];
2499             currSlot.addr = to;
2500             currSlot.startTimestamp = uint64(block.timestamp);
2501 
2502             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2503             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2504             uint256 nextTokenId = tokenId + 1;
2505             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2506             if (nextSlot.addr == address(0)) {
2507                 // This will suffice for checking _exists(nextTokenId),
2508                 // as a burned slot cannot contain the zero address.
2509                 if (nextTokenId != _currentIndex) {
2510                     nextSlot.addr = from;
2511                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2512                 }
2513             }
2514         }
2515 
2516         emit Transfer(from, to, tokenId);
2517         _afterTokenTransfers(from, to, tokenId, 1);
2518     }
2519 
2520     /**
2521      * @dev This is equivalent to _burn(tokenId, false)
2522      */
2523     function _burn(uint256 tokenId) internal virtual {
2524         _burn(tokenId, false);
2525     }
2526 
2527     /**
2528      * @dev Destroys `tokenId`.
2529      * The approval is cleared when the token is burned.
2530      *
2531      * Requirements:
2532      *
2533      * - `tokenId` must exist.
2534      *
2535      * Emits a {Transfer} event.
2536      */
2537     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2538         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2539 
2540         address from = prevOwnership.addr;
2541 
2542         if (approvalCheck) {
2543             bool isApprovedOrOwner = (_msgSender() == from ||
2544                 isApprovedForAll(from, _msgSender()) ||
2545                 getApproved(tokenId) == _msgSender());
2546 
2547             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2548         }
2549 
2550         _beforeTokenTransfers(from, address(0), tokenId, 1);
2551 
2552         // Clear approvals from the previous owner
2553         _approve(address(0), tokenId, from);
2554 
2555         // Underflow of the sender's balance is impossible because we check for
2556         // ownership above and the recipient's balance can't realistically overflow.
2557         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2558         unchecked {
2559             AddressData storage addressData = _addressData[from];
2560             addressData.balance -= 1;
2561             addressData.numberBurned += 1;
2562 
2563             // Keep track of who burned the token, and the timestamp of burning.
2564             TokenOwnership storage currSlot = _ownerships[tokenId];
2565             currSlot.addr = from;
2566             currSlot.startTimestamp = uint64(block.timestamp);
2567             currSlot.burned = true;
2568 
2569             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2570             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2571             uint256 nextTokenId = tokenId + 1;
2572             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2573             if (nextSlot.addr == address(0)) {
2574                 // This will suffice for checking _exists(nextTokenId),
2575                 // as a burned slot cannot contain the zero address.
2576                 if (nextTokenId != _currentIndex) {
2577                     nextSlot.addr = from;
2578                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2579                 }
2580             }
2581         }
2582 
2583         emit Transfer(from, address(0), tokenId);
2584         _afterTokenTransfers(from, address(0), tokenId, 1);
2585 
2586         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2587         unchecked {
2588             _burnCounter++;
2589         }
2590     }
2591 
2592     /**
2593      * @dev Approve `to` to operate on `tokenId`
2594      *
2595      * Emits a {Approval} event.
2596      */
2597     function _approve(
2598         address to,
2599         uint256 tokenId,
2600         address owner
2601     ) private {
2602         _tokenApprovals[tokenId] = to;
2603         emit Approval(owner, to, tokenId);
2604     }
2605 
2606     /**
2607      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2608      *
2609      * @param from address representing the previous owner of the given token ID
2610      * @param to target address that will receive the tokens
2611      * @param tokenId uint256 ID of the token to be transferred
2612      * @param _data bytes optional data to send along with the call
2613      * @return bool whether the call correctly returned the expected magic value
2614      */
2615     function _checkContractOnERC721Received(
2616         address from,
2617         address to,
2618         uint256 tokenId,
2619         bytes memory _data
2620     ) private returns (bool) {
2621         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2622             return retval == IERC721Receiver(to).onERC721Received.selector;
2623         } catch (bytes memory reason) {
2624             if (reason.length == 0) {
2625                 revert TransferToNonERC721ReceiverImplementer();
2626             } else {
2627                 assembly {
2628                     revert(add(32, reason), mload(reason))
2629                 }
2630             }
2631         }
2632     }
2633 
2634     /**
2635      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2636      * And also called before burning one token.
2637      *
2638      * startTokenId - the first token id to be transferred
2639      * quantity - the amount to be transferred
2640      *
2641      * Calling conditions:
2642      *
2643      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2644      * transferred to `to`.
2645      * - When `from` is zero, `tokenId` will be minted for `to`.
2646      * - When `to` is zero, `tokenId` will be burned by `from`.
2647      * - `from` and `to` are never both zero.
2648      */
2649     function _beforeTokenTransfers(
2650         address from,
2651         address to,
2652         uint256 startTokenId,
2653         uint256 quantity
2654     ) internal virtual {}
2655 
2656     /**
2657      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2658      * minting.
2659      * And also called after one token has been burned.
2660      *
2661      * startTokenId - the first token id to be transferred
2662      * quantity - the amount to be transferred
2663      *
2664      * Calling conditions:
2665      *
2666      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2667      * transferred to `to`.
2668      * - When `from` is zero, `tokenId` has been minted for `to`.
2669      * - When `to` is zero, `tokenId` has been burned by `from`.
2670      * - `from` and `to` are never both zero.
2671      */
2672     function _afterTokenTransfers(
2673         address from,
2674         address to,
2675         uint256 startTokenId,
2676         uint256 quantity
2677     ) internal virtual {}
2678 }
2679 
2680 
2681 pragma solidity ^0.8.0;
2682 
2683 
2684 
2685 
2686 
2687 contract Legends is ERC721A, ReentrancyGuard, Ownable {
2688 
2689     // Minting Variables
2690     uint256 public mintPrice = 0.08 ether;
2691     uint256 public whitelistMintPrice = 0.025 ether;
2692     uint256 public maxPurchase = 3;
2693     uint256 public maxSupply = 3333;
2694     address public apeLiquidAddress;
2695     uint256 public liquidReserve = 1650;
2696 
2697     uint256 public reserveTokensMinted = 0;
2698 
2699     // Sale Status
2700     bool public saleIsActive = false;
2701     bool public holderSaleIsActive = false;
2702     mapping(uint256 => bool) public claimedApeLiquid;
2703     mapping(uint256 => bool) public burnedApeLiquid;
2704     mapping(address => uint) public addressesThatMinted;
2705     
2706 
2707 
2708     // Metadata
2709     string _baseTokenURI = "https://ipfs.io/ipfs/QmbYdwFxsh8GoZ6F9wY5ekQPwiXJjKiEiCs3neet8WDiF2/";
2710     bool public locked;
2711 
2712     // Events
2713     event SaleActivation(bool isActive);
2714     event HolderSaleActivation(bool isActive);
2715   
2716 
2717 
2718     constructor(address _apeLiquidAddress) ERC721A("Liquid Legends", "LEGENDS") {
2719     apeLiquidAddress = _apeLiquidAddress;
2720     }
2721 
2722  
2723 
2724     //Holder status validation
2725 
2726     function isApeLiquidAvailable(uint256 _tokenId) public view returns(bool) {
2727         return claimedApeLiquid[_tokenId] != true;
2728     }
2729 
2730     function isOwnerOfValidLiquid(uint256[] calldata _apeLiquidIds, address _account) internal view {
2731         ERC721Enumerable apeLiquid = ERC721Enumerable(apeLiquidAddress);
2732         require(apeLiquid.balanceOf(_account) > 0, "NO_AL_TOKENS");
2733         for (uint256 i = 0; i < _apeLiquidIds.length; i++) {
2734             require(isApeLiquidAvailable(_apeLiquidIds[i]), "AL_ALREADY_CLAIMED");
2735             require(apeLiquid.ownerOf(_apeLiquidIds[i]) == _account, "NOT_AL_OWNER");
2736         }
2737     }
2738 
2739     // Minting
2740     function ownerMint(address _to, uint256 _count) external onlyOwner {
2741         require(
2742             totalSupply() + _count <= maxSupply,
2743             "SOLD_OUT"
2744         );
2745         _safeMint(_to, _count);
2746     }
2747 
2748     function holderMint(uint256[] calldata _apeLiquidIds, uint256 _count) external payable nonReentrant {
2749         require(holderSaleIsActive, "HOLDER_SALE_INACTIVE");
2750           require(
2751             whitelistMintPrice  * _count <= msg.value,
2752             "INCORRECT_ETHER_VALUE"
2753         );
2754         require(
2755             _count == _apeLiquidIds.length,
2756             "INSUFFICIENT_AL_TOKENS"
2757         );
2758         require(
2759             totalSupply() + _count <= maxSupply,
2760             "SOLD_OUT"
2761         );
2762         isOwnerOfValidLiquid(_apeLiquidIds, msg.sender);
2763         for (uint256 i = 0; i < _apeLiquidIds.length; i++) {
2764             claimedApeLiquid[_apeLiquidIds[i]] = true;
2765         }
2766         _safeMint(msg.sender, _count);
2767         reserveTokensMinted++;
2768     }
2769 
2770 
2771 
2772     function holderFreeMint(uint256[] calldata _apeLiquidIds, uint256 _count) external nonReentrant {
2773         require(holderSaleIsActive, "HOLDER_SALE_INACTIVE");
2774         require(
2775             _count == _apeLiquidIds.length,
2776             "INSUFFICIENT_AL_TOKENS"
2777         );
2778         require(
2779             totalSupply() + _count <= maxSupply,
2780             "SOLD_OUT"
2781         );
2782         isOwnerOfValidLiquid(_apeLiquidIds, msg.sender);
2783         for (uint256 i = 0; i < _apeLiquidIds.length; i++) {
2784             claimedApeLiquid[_apeLiquidIds[i]] = true;
2785         }
2786         for (uint256 i = 0; i < _apeLiquidIds.length; i++) {
2787             burnedApeLiquid[_apeLiquidIds[i]] = true;
2788         }
2789         _safeMint(msg.sender, _count);
2790         reserveTokensMinted++;
2791     }
2792 
2793 
2794     function mint(uint256 _count) external payable nonReentrant {
2795         require(saleIsActive, "SALE_INACTIVE");
2796         require(((addressesThatMinted[msg.sender] + _count) ) <= maxPurchase , "this would exceed mint max allowance");
2797 
2798         require(
2799             totalSupply() + _count <= maxSupply,
2800             "SOLD_OUT"
2801         );
2802         require(
2803             totalSupply() + _count + liquidReserve - reserveTokensMinted <= maxSupply,
2804             "PUBLIC_SOLD_OUT"
2805         );
2806         require(
2807             mintPrice * _count <= msg.value,
2808             "INCORRECT_ETHER_VALUE"
2809         );
2810 
2811                 _safeMint(msg.sender, _count);
2812                 addressesThatMinted[msg.sender] += _count;
2813         }
2814 
2815 
2816     function toggleHolderSaleStatus() external onlyOwner {
2817         holderSaleIsActive = !holderSaleIsActive;
2818         emit HolderSaleActivation(holderSaleIsActive);
2819     }
2820 
2821 
2822     function toggleSaleStatus() external onlyOwner {
2823         saleIsActive = !saleIsActive;
2824         emit SaleActivation(saleIsActive);
2825     }
2826 
2827     function setMintPrice(uint256 _mintPrice) external onlyOwner {
2828         mintPrice = _mintPrice;
2829     }
2830 
2831     function setWhitelistMintPrice(uint256 _mintPrice) external onlyOwner {
2832         whitelistMintPrice = _mintPrice;
2833     }
2834 
2835     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
2836         maxPurchase = _maxPurchase;
2837     }
2838     function setReserve(uint256 _liquidReserve) external onlyOwner {
2839         liquidReserve = _liquidReserve;
2840     }
2841 
2842     function lockMetadata() external onlyOwner {
2843         locked = true;
2844     }
2845 
2846     function withdraw() external onlyOwner {
2847         payable(owner()).transfer(address(this).balance);
2848     }
2849 
2850 
2851     function getWalletOfOwner(address owner) external view returns (uint256[] memory) {
2852     unchecked {
2853         uint256[] memory a = new uint256[](balanceOf(owner));
2854         uint256 end = _currentIndex;
2855         uint256 tokenIdsIdx;
2856         address currOwnershipAddr;
2857         for (uint256 i; i < end; i++) {
2858             TokenOwnership memory ownership = _ownerships[i];
2859             if (ownership.burned) {
2860                 continue;
2861             }
2862             if (ownership.addr != address(0)) {
2863                 currOwnershipAddr = ownership.addr;
2864             }
2865             if (currOwnershipAddr == owner) {
2866                 a[tokenIdsIdx++] = i;
2867             }
2868         }
2869         return a;
2870     }
2871     }
2872 
2873     function getTotalSupply() external view returns (uint256) {
2874         return totalSupply();
2875     }
2876 
2877     function setBaseURI(string memory baseURI) external onlyOwner {
2878         require(!locked, "METADATA_LOCKED");
2879         _baseTokenURI = baseURI;
2880     }
2881 
2882     function _baseURI() internal view virtual override returns (string memory) {
2883         return _baseTokenURI;
2884     }
2885 
2886     function tokenURI(uint256 tokenId) public view override returns (string memory){
2887         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2888     }
2889 
2890     function _startTokenId() internal view virtual override returns (uint256){
2891         return 1;
2892     }
2893 
2894 
2895 }