1 // SPDX-License-Identifier: MIT
2 
3 /*
4     We Are Azuki Apes (formerly a Social Club)
5  Contract by the [sometimes] controversial Aleph0ne
6 
7 */
8 
9 pragma solidity ^0.8.15;
10 
11 /**
12  * @dev External interface of AccessControl declared to support ERC165 detection.
13  */
14 interface IAccessControl {
15     /**
16      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
17      *
18      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
19      * {RoleAdminChanged} not being emitted signaling this.
20      *
21      * _Available since v3.1._
22      */
23     event RoleAdminChanged(
24         bytes32 indexed role,
25         bytes32 indexed previousAdminRole,
26         bytes32 indexed newAdminRole
27     );
28 
29     /**
30      * @dev Emitted when `account` is granted `role`.
31      *
32      * `sender` is the account that originated the contract call, an admin role
33      * bearer except when using {AccessControl-_setupRole}.
34      */
35     event RoleGranted(
36         bytes32 indexed role,
37         address indexed account,
38         address indexed sender
39     );
40 
41     /**
42      * @dev Emitted when `account` is revoked `role`.
43      *
44      * `sender` is the account that originated the contract call:
45      *   - if using `revokeRole`, it is the admin role bearer
46      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
47      */
48     event RoleRevoked(
49         bytes32 indexed role,
50         address indexed account,
51         address indexed sender
52     );
53 
54     /**
55      * @dev Returns `true` if `account` has been granted `role`.
56      */
57     function hasRole(
58         bytes32 role,
59         address account
60     ) external view returns (bool);
61 
62     /**
63      * @dev Returns the admin role that controls `role`. See {grantRole} and
64      * {revokeRole}.
65      *
66      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
67      */
68     function getRoleAdmin(bytes32 role) external view returns (bytes32);
69 
70     /**
71      * @dev Grants `role` to `account`.
72      *
73      * If `account` had not been already granted `role`, emits a {RoleGranted}
74      * event.
75      *
76      * Requirements:
77      *
78      * - the caller must have ``role``'s admin role.
79      */
80     function grantRole(bytes32 role, address account) external;
81 
82     /**
83      * @dev Revokes `role` from `account`.
84      *
85      * If `account` had been granted `role`, emits a {RoleRevoked} event.
86      *
87      * Requirements:
88      *
89      * - the caller must have ``role``'s admin role.
90      */
91     function revokeRole(bytes32 role, address account) external;
92 
93     /**
94      * @dev Revokes `role` from the calling account.
95      *
96      * Roles are often managed via {grantRole} and {revokeRole}: this function's
97      * purpose is to provide a mechanism for accounts to lose their privileges
98      * if they are compromised (such as when a trusted device is misplaced).
99      *
100      * If the calling account had been granted `role`, emits a {RoleRevoked}
101      * event.
102      *
103      * Requirements:
104      *
105      * - the caller must be `account`.
106      */
107     function renounceRole(bytes32 role, address account) external;
108 }
109 
110 
111 /**
112  * @dev Interface of the ERC165 standard, as defined in the
113  * https://eips.ethereum.org/EIPS/eip-165[EIP].
114  *
115  * Implementers can declare support of contract interfaces, which can then be
116  * queried by others ({ERC165Checker}).
117  *
118  * For an implementation, see {ERC165}.
119  */
120 interface IERC165 {
121     /**
122      * @dev Returns true if this contract implements the interface defined by
123      * `interfaceId`. See the corresponding
124      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
125      * to learn more about how these ids are created.
126      *
127      * This function call must use less than 30 000 gas.
128      */
129     function supportsInterface(bytes4 interfaceId) external view returns (bool);
130 }
131 
132 
133 /**
134  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
135  */
136 interface IAccessControlEnumerable is IAccessControl {
137     /**
138      * @dev Returns one of the accounts that have `role`. `index` must be a
139      * value between 0 and {getRoleMemberCount}, non-inclusive.
140      *
141      * Role bearers are not sorted in any particular way, and their ordering may
142      * change at any point.
143      *
144      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
145      * you perform all queries on the same block. See the following
146      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
147      * for more information.
148      */
149     function getRoleMember(
150         bytes32 role,
151         uint256 index
152     ) external view returns (address);
153 
154     /**
155      * @dev Returns the number of accounts that have `role`. Can be used
156      * together with {getRoleMember} to enumerate all bearers of a role.
157      */
158     function getRoleMemberCount(bytes32 role) external view returns (uint256);
159 }
160 
161 
162 /**
163  * @dev Library for managing
164  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
165  * types.
166  *
167  * Sets have the following properties:
168  *
169  * - Elements are added, removed, and checked for existence in constant time
170  * (O(1)).
171  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
172  *
173  * ```
174  * contract Example {
175  *     // Add the library methods
176  *     using EnumerableSet for EnumerableSet.AddressSet;
177  *
178  *     // Declare a set state variable
179  *     EnumerableSet.AddressSet private mySet;
180  * }
181  * ```
182  *
183  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
184  * and `uint256` (`UintSet`) are supported.
185  */
186 library EnumerableSet {
187     // To implement this library for multiple types with as little code
188     // repetition as possible, we write it in terms of a generic Set type with
189     // bytes32 values.
190     // The Set implementation uses private functions, and user-facing
191     // implementations (such as AddressSet) are just wrappers around the
192     // underlying Set.
193     // This means that we can only create new EnumerableSets for types that fit
194     // in bytes32.
195 
196     struct Set {
197         // Storage of set values
198         bytes32[] _values;
199         // Position of the value in the `values` array, plus 1 because index 0
200         // means a value is not in the set.
201         mapping(bytes32 => uint256) _indexes;
202     }
203 
204     /**
205      * @dev Add a value to a set. O(1).
206      *
207      * Returns true if the value was added to the set, that is if it was not
208      * already present.
209      */
210     function _add(Set storage set, bytes32 value) private returns (bool) {
211         if (!_contains(set, value)) {
212             set._values.push(value);
213             // The value is stored at length-1, but we add 1 to all indexes
214             // and use 0 as a sentinel value
215             set._indexes[value] = set._values.length;
216             return true;
217         } else {
218             return false;
219         }
220     }
221 
222     /**
223      * @dev Removes a value from a set. O(1).
224      *
225      * Returns true if the value was removed from the set, that is if it was
226      * present.
227      */
228     function _remove(Set storage set, bytes32 value) private returns (bool) {
229         // We read and store the value's index to prevent multiple reads from the same storage slot
230         uint256 valueIndex = set._indexes[value];
231 
232         if (valueIndex != 0) {
233             // Equivalent to contains(set, value)
234             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
235             // the array, and then remove the last element (sometimes called as 'swap and pop').
236             // This modifies the order of the array, as noted in {at}.
237 
238             uint256 toDeleteIndex = valueIndex - 1;
239             uint256 lastIndex = set._values.length - 1;
240 
241             if (lastIndex != toDeleteIndex) {
242                 bytes32 lastvalue = set._values[lastIndex];
243 
244                 // Move the last value to the index where the value to delete is
245                 set._values[toDeleteIndex] = lastvalue;
246                 // Update the index for the moved value
247                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
248             }
249 
250             // Delete the slot where the moved value was stored
251             set._values.pop();
252 
253             // Delete the index for the deleted slot
254             delete set._indexes[value];
255 
256             return true;
257         } else {
258             return false;
259         }
260     }
261 
262     /**
263      * @dev Returns true if the value is in the set. O(1).
264      */
265     function _contains(
266         Set storage set,
267         bytes32 value
268     ) private view returns (bool) {
269         return set._indexes[value] != 0;
270     }
271 
272     /**
273      * @dev Returns the number of values on the set. O(1).
274      */
275     function _length(Set storage set) private view returns (uint256) {
276         return set._values.length;
277     }
278 
279     /**
280      * @dev Returns the value stored at position `index` in the set. O(1).
281      *
282      * Note that there are no guarantees on the ordering of values inside the
283      * array, and it may change when more values are added or removed.
284      *
285      * Requirements:
286      *
287      * - `index` must be strictly less than {length}.
288      */
289     function _at(
290         Set storage set,
291         uint256 index
292     ) private view returns (bytes32) {
293         return set._values[index];
294     }
295 
296     /**
297      * @dev Return the entire set in an array
298      *
299      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
300      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
301      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
302      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
303      */
304     function _values(Set storage set) private view returns (bytes32[] memory) {
305         return set._values;
306     }
307 
308     // Bytes32Set
309 
310     struct Bytes32Set {
311         Set _inner;
312     }
313 
314     /**
315      * @dev Add a value to a set. O(1).
316      *
317      * Returns true if the value was added to the set, that is if it was not
318      * already present.
319      */
320     function add(
321         Bytes32Set storage set,
322         bytes32 value
323     ) internal returns (bool) {
324         return _add(set._inner, value);
325     }
326 
327     /**
328      * @dev Removes a value from a set. O(1).
329      *
330      * Returns true if the value was removed from the set, that is if it was
331      * present.
332      */
333     function remove(
334         Bytes32Set storage set,
335         bytes32 value
336     ) internal returns (bool) {
337         return _remove(set._inner, value);
338     }
339 
340     /**
341      * @dev Returns true if the value is in the set. O(1).
342      */
343     function contains(
344         Bytes32Set storage set,
345         bytes32 value
346     ) internal view returns (bool) {
347         return _contains(set._inner, value);
348     }
349 
350     /**
351      * @dev Returns the number of values in the set. O(1).
352      */
353     function length(Bytes32Set storage set) internal view returns (uint256) {
354         return _length(set._inner);
355     }
356 
357     /**
358      * @dev Returns the value stored at position `index` in the set. O(1).
359      *
360      * Note that there are no guarantees on the ordering of values inside the
361      * array, and it may change when more values are added or removed.
362      *
363      * Requirements:
364      *
365      * - `index` must be strictly less than {length}.
366      */
367     function at(
368         Bytes32Set storage set,
369         uint256 index
370     ) internal view returns (bytes32) {
371         return _at(set._inner, index);
372     }
373 
374     /**
375      * @dev Return the entire set in an array
376      *
377      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
378      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
379      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
380      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
381      */
382     function values(
383         Bytes32Set storage set
384     ) internal view returns (bytes32[] memory) {
385         return _values(set._inner);
386     }
387 
388     // AddressSet
389 
390     struct AddressSet {
391         Set _inner;
392     }
393 
394     /**
395      * @dev Add a value to a set. O(1).
396      *
397      * Returns true if the value was added to the set, that is if it was not
398      * already present.
399      */
400     function add(
401         AddressSet storage set,
402         address value
403     ) internal returns (bool) {
404         return _add(set._inner, bytes32(uint256(uint160(value))));
405     }
406 
407     /**
408      * @dev Removes a value from a set. O(1).
409      *
410      * Returns true if the value was removed from the set, that is if it was
411      * present.
412      */
413     function remove(
414         AddressSet storage set,
415         address value
416     ) internal returns (bool) {
417         return _remove(set._inner, bytes32(uint256(uint160(value))));
418     }
419 
420     /**
421      * @dev Returns true if the value is in the set. O(1).
422      */
423     function contains(
424         AddressSet storage set,
425         address value
426     ) internal view returns (bool) {
427         return _contains(set._inner, bytes32(uint256(uint160(value))));
428     }
429 
430     /**
431      * @dev Returns the number of values in the set. O(1).
432      */
433     function length(AddressSet storage set) internal view returns (uint256) {
434         return _length(set._inner);
435     }
436 
437     /**
438      * @dev Returns the value stored at position `index` in the set. O(1).
439      *
440      * Note that there are no guarantees on the ordering of values inside the
441      * array, and it may change when more values are added or removed.
442      *
443      * Requirements:
444      *
445      * - `index` must be strictly less than {length}.
446      */
447     function at(
448         AddressSet storage set,
449         uint256 index
450     ) internal view returns (address) {
451         return address(uint160(uint256(_at(set._inner, index))));
452     }
453 
454     /**
455      * @dev Return the entire set in an array
456      *
457      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
458      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
459      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
460      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
461      */
462     function values(
463         AddressSet storage set
464     ) internal view returns (address[] memory) {
465         bytes32[] memory store = _values(set._inner);
466         address[] memory result;
467 
468         assembly {
469             result := store
470         }
471 
472         return result;
473     }
474 
475     // UintSet
476 
477     struct UintSet {
478         Set _inner;
479     }
480 
481     /**
482      * @dev Add a value to a set. O(1).
483      *
484      * Returns true if the value was added to the set, that is if it was not
485      * already present.
486      */
487     function add(UintSet storage set, uint256 value) internal returns (bool) {
488         return _add(set._inner, bytes32(value));
489     }
490 
491     /**
492      * @dev Removes a value from a set. O(1).
493      *
494      * Returns true if the value was removed from the set, that is if it was
495      * present.
496      */
497     function remove(
498         UintSet storage set,
499         uint256 value
500     ) internal returns (bool) {
501         return _remove(set._inner, bytes32(value));
502     }
503 
504     /**
505      * @dev Returns true if the value is in the set. O(1).
506      */
507     function contains(
508         UintSet storage set,
509         uint256 value
510     ) internal view returns (bool) {
511         return _contains(set._inner, bytes32(value));
512     }
513 
514     /**
515      * @dev Returns the number of values on the set. O(1).
516      */
517     function length(UintSet storage set) internal view returns (uint256) {
518         return _length(set._inner);
519     }
520 
521     /**
522      * @dev Returns the value stored at position `index` in the set. O(1).
523      *
524      * Note that there are no guarantees on the ordering of values inside the
525      * array, and it may change when more values are added or removed.
526      *
527      * Requirements:
528      *
529      * - `index` must be strictly less than {length}.
530      */
531     function at(
532         UintSet storage set,
533         uint256 index
534     ) internal view returns (uint256) {
535         return uint256(_at(set._inner, index));
536     }
537 
538     /**
539      * @dev Return the entire set in an array
540      *
541      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
542      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
543      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
544      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
545      */
546     function values(
547         UintSet storage set
548     ) internal view returns (uint256[] memory) {
549         bytes32[] memory store = _values(set._inner);
550         uint256[] memory result;
551 
552         assembly {
553             result := store
554         }
555 
556         return result;
557     }
558 }
559 
560 
561 /**
562  * @dev Required interface of an ERC721 compliant contract.
563  */
564 interface IERC721 is IERC165 {
565     /**
566      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
567      */
568     event Transfer(
569         address indexed from,
570         address indexed to,
571         uint256 indexed tokenId
572     );
573 
574     /**
575      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
576      */
577     event Approval(
578         address indexed owner,
579         address indexed approved,
580         uint256 indexed tokenId
581     );
582 
583     /**
584      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
585      */
586     event ApprovalForAll(
587         address indexed owner,
588         address indexed operator,
589         bool approved
590     );
591 
592     /**
593      * @dev Returns the number of tokens in ``owner``'s account.
594      */
595     function balanceOf(address owner) external view returns (uint256 balance);
596 
597     /**
598      * @dev Returns the owner of the `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function ownerOf(uint256 tokenId) external view returns (address owner);
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
608      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must exist and be owned by `from`.
615      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) external;
625 
626     /**
627      * @dev Transfers `tokenId` token from `from` to `to`.
628      *
629      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transferFrom(address from, address to, uint256 tokenId) external;
641 
642     /**
643      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
644      * The approval is cleared when the token is transferred.
645      *
646      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
647      *
648      * Requirements:
649      *
650      * - The caller must own the token or be an approved operator.
651      * - `tokenId` must exist.
652      *
653      * Emits an {Approval} event.
654      */
655     function approve(address to, uint256 tokenId) external;
656 
657     /**
658      * @dev Returns the account approved for `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function getApproved(
665         uint256 tokenId
666     ) external view returns (address operator);
667 
668     /**
669      * @dev Approve or remove `operator` as an operator for the caller.
670      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
671      *
672      * Requirements:
673      *
674      * - The `operator` cannot be the caller.
675      *
676      * Emits an {ApprovalForAll} event.
677      */
678     function setApprovalForAll(address operator, bool _approved) external;
679 
680     /**
681      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
682      *
683      * See {setApprovalForAll}
684      */
685     function isApprovedForAll(
686         address owner,
687         address operator
688     ) external view returns (bool);
689 
690     /**
691      * @dev Safely transfers `tokenId` token from `from` to `to`.
692      *
693      * Requirements:
694      *
695      * - `from` cannot be the zero address.
696      * - `to` cannot be the zero address.
697      * - `tokenId` token must exist and be owned by `from`.
698      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
699      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
700      *
701      * Emits a {Transfer} event.
702      */
703     function safeTransferFrom(
704         address from,
705         address to,
706         uint256 tokenId,
707         bytes calldata data
708     ) external;
709 }
710 
711 
712 /**
713  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
714  * @dev See https://eips.ethereum.org/EIPS/eip-721
715  */
716 interface IERC721Enumerable is IERC721 {
717     /**
718      * @dev Returns the total amount of tokens stored by the contract.
719      */
720     function totalSupply() external view returns (uint256);
721 
722     /**
723      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
724      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
725      */
726     function tokenOfOwnerByIndex(
727         address owner,
728         uint256 index
729     ) external view returns (uint256 tokenId);
730 
731     /**
732      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
733      * Use along with {totalSupply} to enumerate all tokens.
734      */
735     function tokenByIndex(uint256 index) external view returns (uint256);
736 }
737 
738 
739 /**
740  * @title ERC721 token receiver interface
741  * @dev Interface for any contract that wants to support safeTransfers
742  * from ERC721 asset contracts.
743  */
744 interface IERC721Receiver {
745     /**
746      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
747      * by `operator` from `from`, this function is called.
748      *
749      * It must return its Solidity selector to confirm the token transfer.
750      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
751      *
752      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
753      */
754     function onERC721Received(
755         address operator,
756         address from,
757         uint256 tokenId,
758         bytes calldata data
759     ) external returns (bytes4);
760 }
761 
762 
763 /**
764  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
765  * @dev See https://eips.ethereum.org/EIPS/eip-721
766  */
767 interface IERC721Metadata is IERC721 {
768     /**
769      * @dev Returns the token collection name.
770      */
771     function name() external view returns (string memory);
772 
773     /**
774      * @dev Returns the token collection symbol.
775      */
776     function symbol() external view returns (string memory);
777 
778     /**
779      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
780      */
781     function tokenURI(uint256 tokenId) external view returns (string memory);
782 }
783 
784 
785 /**
786  * @dev Collection of functions related to the address type
787  */
788 library Address {
789     /**
790      * @dev Returns true if `account` is a contract.
791      *
792      * [IMPORTANT]
793      * ====
794      * It is unsafe to assume that an address for which this function returns
795      * false is an externally-owned account (EOA) and not a contract.
796      *
797      * Among others, `isContract` will return false for the following
798      * types of addresses:
799      *
800      *  - an externally-owned account
801      *  - a contract in construction
802      *  - an address where a contract will be created
803      *  - an address where a contract lived, but was destroyed
804      * ====
805      */
806     function isContract(address account) internal view returns (bool) {
807         // This method relies on extcodesize, which returns 0 for contracts in
808         // construction, since the code is only stored at the end of the
809         // constructor execution.
810 
811         uint256 size;
812         assembly {
813             size := extcodesize(account)
814         }
815         return size > 0;
816     }
817 
818     /**
819      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
820      * `recipient`, forwarding all available gas and reverting on errors.
821      *
822      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
823      * of certain opcodes, possibly making contracts go over the 2300 gas limit
824      * imposed by `transfer`, making them unable to receive funds via
825      * `transfer`. {sendValue} removes this limitation.
826      *
827      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
828      *
829      * IMPORTANT: because control is transferred to `recipient`, care must be
830      * taken to not create reentrancy vulnerabilities. Consider using
831      * {ReentrancyGuard} or the
832      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
833      */
834     function sendValue(address payable recipient, uint256 amount) internal {
835         require(
836             address(this).balance >= amount,
837             "Address: insufficient balance"
838         );
839 
840         (bool success, ) = recipient.call{value: amount}("");
841         require(
842             success,
843             "Address: unable to send value, recipient may have reverted"
844         );
845     }
846 
847     /**
848      * @dev Performs a Solidity function call using a low level `call`. A
849      * plain `call` is an unsafe replacement for a function call: use this
850      * function instead.
851      *
852      * If `target` reverts with a revert reason, it is bubbled up by this
853      * function (like regular Solidity function calls).
854      *
855      * Returns the raw returned data. To convert to the expected return value,
856      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
857      *
858      * Requirements:
859      *
860      * - `target` must be a contract.
861      * - calling `target` with `data` must not revert.
862      *
863      * _Available since v3.1._
864      */
865     function functionCall(
866         address target,
867         bytes memory data
868     ) internal returns (bytes memory) {
869         return functionCall(target, data, "Address: low-level call failed");
870     }
871 
872     /**
873      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
874      * `errorMessage` as a fallback revert reason when `target` reverts.
875      *
876      * _Available since v3.1._
877      */
878     function functionCall(
879         address target,
880         bytes memory data,
881         string memory errorMessage
882     ) internal returns (bytes memory) {
883         return functionCallWithValue(target, data, 0, errorMessage);
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
888      * but also transferring `value` wei to `target`.
889      *
890      * Requirements:
891      *
892      * - the calling contract must have an ETH balance of at least `value`.
893      * - the called Solidity function must be `payable`.
894      *
895      * _Available since v3.1._
896      */
897     function functionCallWithValue(
898         address target,
899         bytes memory data,
900         uint256 value
901     ) internal returns (bytes memory) {
902         return
903             functionCallWithValue(
904                 target,
905                 data,
906                 value,
907                 "Address: low-level call with value failed"
908             );
909     }
910 
911     /**
912      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
913      * with `errorMessage` as a fallback revert reason when `target` reverts.
914      *
915      * _Available since v3.1._
916      */
917     function functionCallWithValue(
918         address target,
919         bytes memory data,
920         uint256 value,
921         string memory errorMessage
922     ) internal returns (bytes memory) {
923         require(
924             address(this).balance >= value,
925             "Address: insufficient balance for call"
926         );
927         require(isContract(target), "Address: call to non-contract");
928 
929         (bool success, bytes memory returndata) = target.call{value: value}(
930             data
931         );
932         return verifyCallResult(success, returndata, errorMessage);
933     }
934 
935     /**
936      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
937      * but performing a static call.
938      *
939      * _Available since v3.3._
940      */
941     function functionStaticCall(
942         address target,
943         bytes memory data
944     ) internal view returns (bytes memory) {
945         return
946             functionStaticCall(
947                 target,
948                 data,
949                 "Address: low-level static call failed"
950             );
951     }
952 
953     /**
954      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
955      * but performing a static call.
956      *
957      * _Available since v3.3._
958      */
959     function functionStaticCall(
960         address target,
961         bytes memory data,
962         string memory errorMessage
963     ) internal view returns (bytes memory) {
964         require(isContract(target), "Address: static call to non-contract");
965 
966         (bool success, bytes memory returndata) = target.staticcall(data);
967         return verifyCallResult(success, returndata, errorMessage);
968     }
969 
970     /**
971      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
972      * but performing a delegate call.
973      *
974      * _Available since v3.4._
975      */
976     function functionDelegateCall(
977         address target,
978         bytes memory data
979     ) internal returns (bytes memory) {
980         return
981             functionDelegateCall(
982                 target,
983                 data,
984                 "Address: low-level delegate call failed"
985             );
986     }
987 
988     /**
989      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
990      * but performing a delegate call.
991      *
992      * _Available since v3.4._
993      */
994     function functionDelegateCall(
995         address target,
996         bytes memory data,
997         string memory errorMessage
998     ) internal returns (bytes memory) {
999         require(isContract(target), "Address: delegate call to non-contract");
1000 
1001         (bool success, bytes memory returndata) = target.delegatecall(data);
1002         return verifyCallResult(success, returndata, errorMessage);
1003     }
1004 
1005     /**
1006      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1007      * revert reason using the provided one.
1008      *
1009      * _Available since v4.3._
1010      */
1011     function verifyCallResult(
1012         bool success,
1013         bytes memory returndata,
1014         string memory errorMessage
1015     ) internal pure returns (bytes memory) {
1016         if (success) {
1017             return returndata;
1018         } else {
1019             // Look for revert reason and bubble it up if present
1020             if (returndata.length > 0) {
1021                 // The easiest way to bubble the revert reason is using memory via assembly
1022 
1023                 assembly {
1024                     let returndata_size := mload(returndata)
1025                     revert(add(32, returndata), returndata_size)
1026                 }
1027             } else {
1028                 revert(errorMessage);
1029             }
1030         }
1031     }
1032 }
1033 
1034 
1035 /**
1036  * @dev Provides information about the current execution context, including the
1037  * sender of the transaction and its data. While these are generally available
1038  * via msg.sender and msg.data, they should not be accessed in such a direct
1039  * manner, since when dealing with meta-transactions the account sending and
1040  * paying for execution may not be the actual sender (as far as an application
1041  * is concerned).
1042  *
1043  * This contract is only required for intermediate, library-like contracts.
1044  */
1045 abstract contract Context {
1046     function _msgSender() internal view virtual returns (address) {
1047         return msg.sender;
1048     }
1049 
1050     function _msgData() internal view virtual returns (bytes calldata) {
1051         return msg.data;
1052     }
1053 }
1054 
1055 
1056 /**
1057  * @dev String operations.
1058  */
1059 library Strings {
1060     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1061 
1062     /**
1063      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1064      */
1065     function toString(uint256 value) internal pure returns (string memory) {
1066         // Inspired by OraclizeAPI's implementation - MIT licence
1067         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1068 
1069         if (value == 0) {
1070             return "0";
1071         }
1072         uint256 temp = value;
1073         uint256 digits;
1074         while (temp != 0) {
1075             digits++;
1076             temp /= 10;
1077         }
1078         bytes memory buffer = new bytes(digits);
1079         while (value != 0) {
1080             digits -= 1;
1081             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1082             value /= 10;
1083         }
1084         return string(buffer);
1085     }
1086 
1087     /**
1088      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1089      */
1090     function toHexString(uint256 value) internal pure returns (string memory) {
1091         if (value == 0) {
1092             return "0x00";
1093         }
1094         uint256 temp = value;
1095         uint256 length = 0;
1096         while (temp != 0) {
1097             length++;
1098             temp >>= 8;
1099         }
1100         return toHexString(value, length);
1101     }
1102 
1103     /**
1104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1105      */
1106     function toHexString(
1107         uint256 value,
1108         uint256 length
1109     ) internal pure returns (string memory) {
1110         bytes memory buffer = new bytes(2 * length + 2);
1111         buffer[0] = "0";
1112         buffer[1] = "x";
1113         for (uint256 i = 2 * length + 1; i > 1; --i) {
1114             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1115             value >>= 4;
1116         }
1117         require(value == 0, "Strings: hex length insufficient");
1118         return string(buffer);
1119     }
1120 }
1121 
1122 
1123 /**
1124  * @dev Implementation of the {IERC165} interface.
1125  *
1126  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1127  * for the additional interface id that will be supported. For example:
1128  *
1129  * ```solidity
1130  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1131  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1132  * }
1133  * ```
1134  *
1135  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1136  */
1137 abstract contract ERC165 is IERC165 {
1138     /**
1139      * @dev See {IERC165-supportsInterface}.
1140      */
1141     function supportsInterface(
1142         bytes4 interfaceId
1143     ) public view virtual override returns (bool) {
1144         return interfaceId == type(IERC165).interfaceId;
1145     }
1146 }
1147 
1148 
1149 /**
1150  * @dev Contract module that allows children to implement role-based access
1151  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1152  * members except through off-chain means by accessing the contract event logs. Some
1153  * applications may benefit from on-chain enumerability, for those cases see
1154  * {AccessControlEnumerable}.
1155  *
1156  * Roles are referred to by their `bytes32` identifier. These should be exposed
1157  * in the external API and be unique. The best way to achieve this is by
1158  * using `public constant` hash digests:
1159  *
1160  * ```
1161  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1162  * ```
1163  *
1164  * Roles can be used to represent a set of permissions. To restrict access to a
1165  * function call, use {hasRole}:
1166  *
1167  * ```
1168  * function foo() public {
1169  *     require(hasRole(MY_ROLE, msg.sender));
1170  *     ...
1171  * }
1172  * ```
1173  *
1174  * Roles can be granted and revoked dynamically via the {grantRole} and
1175  * {revokeRole} functions. Each role has an associated admin role, and only
1176  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1177  *
1178  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1179  * that only accounts with this role will be able to grant or revoke other
1180  * roles. More complex role relationships can be created by using
1181  * {_setRoleAdmin}.
1182  *
1183  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1184  * grant and revoke this role. Extra precautions should be taken to secure
1185  * accounts that have been granted it.
1186  */
1187 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1188     struct RoleData {
1189         mapping(address => bool) members;
1190         bytes32 adminRole;
1191     }
1192 
1193     mapping(bytes32 => RoleData) private _roles;
1194 
1195     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1196 
1197     /**
1198      * @dev Modifier that checks that an account has a specific role. Reverts
1199      * with a standardized message including the required role.
1200      *
1201      * The format of the revert reason is given by the following regular expression:
1202      *
1203      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1204      *
1205      * _Available since v4.1._
1206      */
1207     modifier onlyRole(bytes32 role) {
1208         _checkRole(role, _msgSender());
1209         _;
1210     }
1211 
1212     /**
1213      * @dev See {IERC165-supportsInterface}.
1214      */
1215     function supportsInterface(
1216         bytes4 interfaceId
1217     ) public view virtual override returns (bool) {
1218         return
1219             interfaceId == type(IAccessControl).interfaceId ||
1220             super.supportsInterface(interfaceId);
1221     }
1222 
1223     /**
1224      * @dev Returns `true` if `account` has been granted `role`.
1225      */
1226     function hasRole(
1227         bytes32 role,
1228         address account
1229     ) public view virtual override returns (bool) {
1230         return _roles[role].members[account];
1231     }
1232 
1233     /**
1234      * @dev Revert with a standard message if `account` is missing `role`.
1235      *
1236      * The format of the revert reason is given by the following regular expression:
1237      *
1238      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1239      */
1240     function _checkRole(bytes32 role, address account) internal view virtual {
1241         if (!hasRole(role, account)) {
1242             revert(
1243                 string(
1244                     abi.encodePacked(
1245                         "AccessControl: account ",
1246                         Strings.toHexString(uint160(account), 20),
1247                         " is missing role ",
1248                         Strings.toHexString(uint256(role), 32)
1249                     )
1250                 )
1251             );
1252         }
1253     }
1254 
1255     /**
1256      * @dev Returns the admin role that controls `role`. See {grantRole} and
1257      * {revokeRole}.
1258      *
1259      * To change a role's admin, use {_setRoleAdmin}.
1260      */
1261     function getRoleAdmin(
1262         bytes32 role
1263     ) public view virtual override returns (bytes32) {
1264         return _roles[role].adminRole;
1265     }
1266 
1267     /**
1268      * @dev Grants `role` to `account`.
1269      *
1270      * If `account` had not been already granted `role`, emits a {RoleGranted}
1271      * event.
1272      *
1273      * Requirements:
1274      *
1275      * - the caller must have ``role``'s admin role.
1276      */
1277     function grantRole(
1278         bytes32 role,
1279         address account
1280     ) public virtual override onlyRole(getRoleAdmin(role)) {
1281         _grantRole(role, account);
1282     }
1283 
1284     /**
1285      * @dev Revokes `role` from `account`.
1286      *
1287      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1288      *
1289      * Requirements:
1290      *
1291      * - the caller must have ``role``'s admin role.
1292      */
1293     function revokeRole(
1294         bytes32 role,
1295         address account
1296     ) public virtual override onlyRole(getRoleAdmin(role)) {
1297         _revokeRole(role, account);
1298     }
1299 
1300     /**
1301      * @dev Revokes `role` from the calling account.
1302      *
1303      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1304      * purpose is to provide a mechanism for accounts to lose their privileges
1305      * if they are compromised (such as when a trusted device is misplaced).
1306      *
1307      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1308      * event.
1309      *
1310      * Requirements:
1311      *
1312      * - the caller must be `account`.
1313      */
1314     function renounceRole(
1315         bytes32 role,
1316         address account
1317     ) public virtual override {
1318         require(
1319             account == _msgSender(),
1320             "AccessControl: can only renounce roles for self"
1321         );
1322 
1323         _revokeRole(role, account);
1324     }
1325 
1326     /**
1327      * @dev Grants `role` to `account`.
1328      *
1329      * If `account` had not been already granted `role`, emits a {RoleGranted}
1330      * event. Note that unlike {grantRole}, this function doesn't perform any
1331      * checks on the calling account.
1332      *
1333      * [WARNING]
1334      * ====
1335      * This function should only be called from the constructor when setting
1336      * up the initial roles for the system.
1337      *
1338      * Using this function in any other way is effectively circumventing the admin
1339      * system imposed by {AccessControl}.
1340      * ====
1341      *
1342      * NOTE: This function is deprecated in favor of {_grantRole}.
1343      */
1344     function _setupRole(bytes32 role, address account) internal virtual {
1345         _grantRole(role, account);
1346     }
1347 
1348     /**
1349      * @dev Sets `adminRole` as ``role``'s admin role.
1350      *
1351      * Emits a {RoleAdminChanged} event.
1352      */
1353     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1354         bytes32 previousAdminRole = getRoleAdmin(role);
1355         _roles[role].adminRole = adminRole;
1356         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1357     }
1358 
1359     /**
1360      * @dev Grants `role` to `account`.
1361      *
1362      * Internal function without access restriction.
1363      */
1364     function _grantRole(bytes32 role, address account) internal virtual {
1365         if (!hasRole(role, account)) {
1366             _roles[role].members[account] = true;
1367             emit RoleGranted(role, account, _msgSender());
1368         }
1369     }
1370 
1371     /**
1372      * @dev Revokes `role` from `account`.
1373      *
1374      * Internal function without access restriction.
1375      */
1376     function _revokeRole(bytes32 role, address account) internal virtual {
1377         if (hasRole(role, account)) {
1378             _roles[role].members[account] = false;
1379             emit RoleRevoked(role, account, _msgSender());
1380         }
1381     }
1382 }
1383 
1384 
1385 /**
1386  * @dev Contract module which provides a basic access control mechanism, where
1387  * there is an account (an owner) that can be granted exclusive access to
1388  * specific functions.
1389  *
1390  * By default, the owner account will be the one that deploys the contract. This
1391  * can later be changed with {transferOwnership}.
1392  *
1393  * This module is used through inheritance. It will make available the modifier
1394  * `onlyOwner`, which can be applied to your functions to restrict their use to
1395  * the owner.
1396  */
1397 abstract contract Ownable is Context {
1398     address private _owner;
1399 
1400     event OwnershipTransferred(
1401         address indexed previousOwner,
1402         address indexed newOwner
1403     );
1404 
1405     /**
1406      * @dev Initializes the contract setting the deployer as the initial owner.
1407      */
1408     constructor() {
1409         _transferOwnership(_msgSender());
1410     }
1411 
1412     /**
1413      * @dev Returns the address of the current owner.
1414      */
1415     function owner() public view virtual returns (address) {
1416         return _owner;
1417     }
1418 
1419     /**
1420      * @dev Throws if called by any account other than the owner.
1421      */
1422     modifier onlyOwner() {
1423         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1424         _;
1425     }
1426 
1427     /**
1428      * @dev Leaves the contract without owner. It will not be possible to call
1429      * `onlyOwner` functions anymore. Can only be called by the current owner.
1430      *
1431      * NOTE: Renouncing ownership will leave the contract without an owner,
1432      * thereby removing any functionality that is only available to the owner.
1433      */
1434     function renounceOwnership() public virtual onlyOwner {
1435         _transferOwnership(address(0));
1436     }
1437 
1438     /**
1439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1440      * Can only be called by the current owner.
1441      */
1442     function transferOwnership(address newOwner) public virtual onlyOwner {
1443         require(
1444             newOwner != address(0),
1445             "Ownable: new owner is the zero address"
1446         );
1447         _transferOwnership(newOwner);
1448     }
1449 
1450     /**
1451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1452      * Internal function without access restriction.
1453      */
1454     function _transferOwnership(address newOwner) internal virtual {
1455         address oldOwner = _owner;
1456         _owner = newOwner;
1457         emit OwnershipTransferred(oldOwner, newOwner);
1458     }
1459 }
1460 
1461 
1462 /**
1463  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1464  */
1465 abstract contract AccessControlEnumerable is
1466     IAccessControlEnumerable,
1467     AccessControl
1468 {
1469     using EnumerableSet for EnumerableSet.AddressSet;
1470 
1471     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1472 
1473     /**
1474      * @dev See {IERC165-supportsInterface}.
1475      */
1476     function supportsInterface(
1477         bytes4 interfaceId
1478     ) public view virtual override returns (bool) {
1479         return
1480             interfaceId == type(IAccessControlEnumerable).interfaceId ||
1481             super.supportsInterface(interfaceId);
1482     }
1483 
1484     /**
1485      * @dev Returns one of the accounts that have `role`. `index` must be a
1486      * value between 0 and {getRoleMemberCount}, non-inclusive.
1487      *
1488      * Role bearers are not sorted in any particular way, and their ordering may
1489      * change at any point.
1490      *
1491      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1492      * you perform all queries on the same block. See the following
1493      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1494      * for more information.
1495      */
1496     function getRoleMember(
1497         bytes32 role,
1498         uint256 index
1499     ) public view virtual override returns (address) {
1500         return _roleMembers[role].at(index);
1501     }
1502 
1503     /**
1504      * @dev Returns the number of accounts that have `role`. Can be used
1505      * together with {getRoleMember} to enumerate all bearers of a role.
1506      */
1507     function getRoleMemberCount(
1508         bytes32 role
1509     ) public view virtual override returns (uint256) {
1510         return _roleMembers[role].length();
1511     }
1512 
1513     /**
1514      * @dev Overload {_grantRole} to track enumerable memberships
1515      */
1516     function _grantRole(
1517         bytes32 role,
1518         address account
1519     ) internal virtual override {
1520         super._grantRole(role, account);
1521         _roleMembers[role].add(account);
1522     }
1523 
1524     /**
1525      * @dev Overload {_revokeRole} to track enumerable memberships
1526      */
1527     function _revokeRole(
1528         bytes32 role,
1529         address account
1530     ) internal virtual override {
1531         super._revokeRole(role, account);
1532         _roleMembers[role].remove(account);
1533     }
1534 }
1535 
1536 
1537 /**
1538  * @dev Contract module that helps prevent reentrant calls to a function.
1539  *
1540  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1541  * available, which can be applied to functions to make sure there are no nested
1542  * (reentrant) calls to them.
1543  *
1544  * Note that because there is a single `nonReentrant` guard, functions marked as
1545  * `nonReentrant` may not call one another. This can be worked around by making
1546  * those functions `private`, and then adding `external` `nonReentrant` entry
1547  * points to them.
1548  *
1549  * TIP: If you would like to learn more about reentrancy and alternative ways
1550  * to protect against it, check out our blog post
1551  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1552  */
1553 abstract contract ReentrancyGuard {
1554     // Booleans are more expensive than uint256 or any type that takes up a full
1555     // word because each write operation emits an extra SLOAD to first read the
1556     // slot's contents, replace the bits taken up by the boolean, and then write
1557     // back. This is the compiler's defense against contract upgrades and
1558     // pointer aliasing, and it cannot be disabled.
1559 
1560     // The values being non-zero value makes deployment a bit more expensive,
1561     // but in exchange the refund on every call to nonReentrant will be lower in
1562     // amount. Since refunds are capped to a percentage of the total
1563     // transaction's gas, it is best to keep them low in cases like this one, to
1564     // increase the likelihood of the full refund coming into effect.
1565     uint256 private constant _NOT_ENTERED = 1;
1566     uint256 private constant _ENTERED = 2;
1567 
1568     uint256 private _status;
1569 
1570     constructor() {
1571         _status = _NOT_ENTERED;
1572     }
1573 
1574     /**
1575      * @dev Prevents a contract from calling itself, directly or indirectly.
1576      * Calling a `nonReentrant` function from another `nonReentrant`
1577      * function is not supported. It is possible to prevent this from happening
1578      * by making the `nonReentrant` function external, and making it call a
1579      * `private` function that does the actual work.
1580      */
1581     modifier nonReentrant() {
1582         // On the first call to nonReentrant, _notEntered will be true
1583         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1584 
1585         // Any calls to nonReentrant after this point will fail
1586         _status = _ENTERED;
1587 
1588         _;
1589 
1590         // By storing the original value once again, a refund is triggered (see
1591         // https://eips.ethereum.org/EIPS/eip-2200)
1592         _status = _NOT_ENTERED;
1593     }
1594 }
1595 
1596 /**
1597  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1598  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1599  * {ERC721Enumerable}.
1600  */
1601 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1602     using Strings for uint256;
1603 
1604     // Token name
1605     string private _name;
1606 
1607     // Token symbol
1608     string private _symbol;
1609 
1610     // Mapping from token ID to owner address
1611     mapping(uint256 => address) private _owners;
1612 
1613     // Mapping owner address to token count
1614     mapping(address => uint256) private _balances;
1615 
1616     // Mapping from token ID to approved address
1617     mapping(uint256 => address) private _tokenApprovals;
1618 
1619     // Mapping from owner to operator approvals
1620     mapping(address => mapping(address => bool)) private _operatorApprovals;
1621 
1622     /**
1623      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1624      */
1625     constructor(string memory name_, string memory symbol_) {
1626         _name = name_;
1627         _symbol = symbol_;
1628     }
1629 
1630     /**
1631      * @dev See {IERC165-supportsInterface}.
1632      */
1633     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1634         return
1635             interfaceId == type(IERC721).interfaceId ||
1636             interfaceId == type(IERC721Metadata).interfaceId ||
1637             super.supportsInterface(interfaceId);
1638     }
1639 
1640     /**
1641      * @dev See {IERC721-balanceOf}.
1642      */
1643     function balanceOf(address owner) public view virtual override returns (uint256) {
1644         require(owner != address(0), "ERC721: address zero is not a valid owner");
1645         return _balances[owner];
1646     }
1647 
1648     /**
1649      * @dev See {IERC721-ownerOf}.
1650      */
1651     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1652         address owner = _ownerOf(tokenId);
1653         require(owner != address(0), "ERC721: invalid token ID");
1654         return owner;
1655     }
1656 
1657     /**
1658      * @dev See {IERC721Metadata-name}.
1659      */
1660     function name() public view virtual override returns (string memory) {
1661         return _name;
1662     }
1663 
1664     /**
1665      * @dev See {IERC721Metadata-symbol}.
1666      */
1667     function symbol() public view virtual override returns (string memory) {
1668         return _symbol;
1669     }
1670 
1671     /**
1672      * @dev See {IERC721Metadata-tokenURI}.
1673      */
1674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1675         _requireMinted(tokenId);
1676 
1677         string memory baseURI = _baseURI();
1678         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1679     }
1680 
1681     /**
1682      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1683      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1684      * by default, can be overridden in child contracts.
1685      */
1686     function _baseURI() internal view virtual returns (string memory) {
1687         return "";
1688     }
1689 
1690     /**
1691      * @dev See {IERC721-approve}.
1692      */
1693     function approve(address to, uint256 tokenId) public virtual override {
1694         address owner = ownerOf(tokenId);
1695         require(to != owner, "ERC721: approval to current owner");
1696 
1697         require(
1698             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1699             "ERC721: approve caller is not token owner or approved for all"
1700         );
1701 
1702         _approve(to, tokenId);
1703     }
1704 
1705     /**
1706      * @dev See {IERC721-getApproved}.
1707      */
1708     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1709         _requireMinted(tokenId);
1710 
1711         return _tokenApprovals[tokenId];
1712     }
1713 
1714     /**
1715      * @dev See {IERC721-setApprovalForAll}.
1716      */
1717     function setApprovalForAll(address operator, bool approved) public virtual override {
1718         _setApprovalForAll(_msgSender(), operator, approved);
1719     }
1720 
1721     /**
1722      * @dev See {IERC721-isApprovedForAll}.
1723      */
1724     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1725         return _operatorApprovals[owner][operator];
1726     }
1727 
1728     /**
1729      * @dev See {IERC721-transferFrom}.
1730      */
1731     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1732         //solhint-disable-next-line max-line-length
1733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1734 
1735         _transfer(from, to, tokenId);
1736     }
1737 
1738     /**
1739      * @dev See {IERC721-safeTransferFrom}.
1740      */
1741     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1742         safeTransferFrom(from, to, tokenId, "");
1743     }
1744 
1745     /**
1746      * @dev See {IERC721-safeTransferFrom}.
1747      */
1748     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
1749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1750         _safeTransfer(from, to, tokenId, data);
1751     }
1752 
1753     /**
1754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1756      *
1757      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1758      *
1759      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1760      * implement alternative mechanisms to perform token transfer, such as signature-based.
1761      *
1762      * Requirements:
1763      *
1764      * - `from` cannot be the zero address.
1765      * - `to` cannot be the zero address.
1766      * - `tokenId` token must exist and be owned by `from`.
1767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1768      *
1769      * Emits a {Transfer} event.
1770      */
1771     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
1772         _transfer(from, to, tokenId);
1773         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1774     }
1775 
1776     /**
1777      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1778      */
1779     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1780         return _owners[tokenId];
1781     }
1782 
1783     /**
1784      * @dev Returns whether `tokenId` exists.
1785      *
1786      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1787      *
1788      * Tokens start existing when they are minted (`_mint`),
1789      * and stop existing when they are burned (`_burn`).
1790      */
1791     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1792         return _ownerOf(tokenId) != address(0);
1793     }
1794 
1795     /**
1796      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1797      *
1798      * Requirements:
1799      *
1800      * - `tokenId` must exist.
1801      */
1802     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1803         address owner = ownerOf(tokenId);
1804         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1805     }
1806 
1807     /**
1808      * @dev Safely mints `tokenId` and transfers it to `to`.
1809      *
1810      * Requirements:
1811      *
1812      * - `tokenId` must not exist.
1813      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1814      *
1815      * Emits a {Transfer} event.
1816      */
1817     function _safeMint(address to, uint256 tokenId) internal virtual {
1818         _safeMint(to, tokenId, "");
1819     }
1820 
1821     /**
1822      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1823      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1824      */
1825     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
1826         _mint(to, tokenId);
1827         require(
1828             _checkOnERC721Received(address(0), to, tokenId, data),
1829             "ERC721: transfer to non ERC721Receiver implementer"
1830         );
1831     }
1832 
1833     /**
1834      * @dev Mints `tokenId` and transfers it to `to`.
1835      *
1836      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1837      *
1838      * Requirements:
1839      *
1840      * - `tokenId` must not exist.
1841      * - `to` cannot be the zero address.
1842      *
1843      * Emits a {Transfer} event.
1844      */
1845     function _mint(address to, uint256 tokenId) internal virtual {
1846         require(to != address(0), "ERC721: mint to the zero address");
1847         require(!_exists(tokenId), "ERC721: token already minted");
1848 
1849         _beforeTokenTransfer(address(0), to, tokenId, 1);
1850 
1851         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1852         require(!_exists(tokenId), "ERC721: token already minted");
1853 
1854         unchecked {
1855             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1856             // Given that tokens are minted one by one, it is impossible in practice that
1857             // this ever happens. Might change if we allow batch minting.
1858             // The ERC fails to describe this case.
1859             _balances[to] += 1;
1860         }
1861 
1862         _owners[tokenId] = to;
1863 
1864         emit Transfer(address(0), to, tokenId);
1865 
1866         _afterTokenTransfer(address(0), to, tokenId, 1);
1867     }
1868 
1869     /**
1870      * @dev Destroys `tokenId`.
1871      * The approval is cleared when the token is burned.
1872      * This is an internal function that does not check if the sender is authorized to operate on the token.
1873      *
1874      * Requirements:
1875      *
1876      * - `tokenId` must exist.
1877      *
1878      * Emits a {Transfer} event.
1879      */
1880     function _burn(uint256 tokenId) internal virtual {
1881         address owner = ownerOf(tokenId);
1882 
1883         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1884 
1885         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1886         owner = ownerOf(tokenId);
1887 
1888         // Clear approvals
1889         delete _tokenApprovals[tokenId];
1890 
1891         // Decrease balance with checked arithmetic, because an `ownerOf` override may
1892         // invalidate the assumption that `_balances[from] >= 1`.
1893         _balances[owner] -= 1;
1894 
1895         delete _owners[tokenId];
1896 
1897         emit Transfer(owner, address(0), tokenId);
1898 
1899         _afterTokenTransfer(owner, address(0), tokenId, 1);
1900     }
1901 
1902     /**
1903      * @dev Transfers `tokenId` from `from` to `to`.
1904      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1905      *
1906      * Requirements:
1907      *
1908      * - `to` cannot be the zero address.
1909      * - `tokenId` token must be owned by `from`.
1910      *
1911      * Emits a {Transfer} event.
1912      */
1913     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1914         require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1915         require(to != address(0), "ERC721: transfer to the zero address");
1916 
1917         _beforeTokenTransfer(from, to, tokenId, 1);
1918 
1919         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1920         require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1921 
1922         // Clear approvals from the previous owner
1923         delete _tokenApprovals[tokenId];
1924 
1925         // Decrease balance with checked arithmetic, because an `ownerOf` override may
1926         // invalidate the assumption that `_balances[from] >= 1`.
1927         _balances[from] -= 1;
1928 
1929         unchecked {
1930             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1931             // all 2**256 token ids to be minted, which in practice is impossible.
1932             _balances[to] += 1;
1933         }
1934 
1935         _owners[tokenId] = to;
1936 
1937         emit Transfer(from, to, tokenId);
1938 
1939         _afterTokenTransfer(from, to, tokenId, 1);
1940     }
1941 
1942     /**
1943      * @dev Approve `to` to operate on `tokenId`
1944      *
1945      * Emits an {Approval} event.
1946      */
1947     function _approve(address to, uint256 tokenId) internal virtual {
1948         _tokenApprovals[tokenId] = to;
1949         emit Approval(ownerOf(tokenId), to, tokenId);
1950     }
1951 
1952     /**
1953      * @dev Approve `operator` to operate on all of `owner` tokens
1954      *
1955      * Emits an {ApprovalForAll} event.
1956      */
1957     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1958         require(owner != operator, "ERC721: approve to caller");
1959         _operatorApprovals[owner][operator] = approved;
1960         emit ApprovalForAll(owner, operator, approved);
1961     }
1962 
1963     /**
1964      * @dev Reverts if the `tokenId` has not been minted yet.
1965      */
1966     function _requireMinted(uint256 tokenId) internal view virtual {
1967         require(_exists(tokenId), "ERC721: invalid token ID");
1968     }
1969 
1970     /**
1971      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1972      * The call is not executed if the target address is not a contract.
1973      *
1974      * @param from address representing the previous owner of the given token ID
1975      * @param to target address that will receive the tokens
1976      * @param tokenId uint256 ID of the token to be transferred
1977      * @param data bytes optional data to send along with the call
1978      * @return bool whether the call correctly returned the expected magic value
1979      */
1980     function _checkOnERC721Received(
1981         address from,
1982         address to,
1983         uint256 tokenId,
1984         bytes memory data
1985     ) private returns (bool) {
1986         if (to.code.length > 0) {
1987             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1988                 return retval == IERC721Receiver.onERC721Received.selector;
1989             } catch (bytes memory reason) {
1990                 if (reason.length == 0) {
1991                     revert("ERC721: transfer to non ERC721Receiver implementer");
1992                 } else {
1993                     /// @solidity memory-safe-assembly
1994                     assembly {
1995                         revert(add(32, reason), mload(reason))
1996                     }
1997                 }
1998             }
1999         } else {
2000             return true;
2001         }
2002     }
2003 
2004     /**
2005      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2006      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2007      *
2008      * Calling conditions:
2009      *
2010      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2011      * - When `from` is zero, the tokens will be minted for `to`.
2012      * - When `to` is zero, ``from``'s tokens will be burned.
2013      * - `from` and `to` are never both zero.
2014      * - `batchSize` is non-zero.
2015      *
2016      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2017      */
2018     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2019 
2020     /**
2021      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2022      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2023      *
2024      * Calling conditions:
2025      *
2026      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2027      * - When `from` is zero, the tokens were minted for `to`.
2028      * - When `to` is zero, ``from``'s tokens were burned.
2029      * - `from` and `to` are never both zero.
2030      * - `batchSize` is non-zero.
2031      *
2032      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2033      */
2034     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2035 
2036     /**
2037      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
2038      *
2039      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
2040      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
2041      * that `ownerOf(tokenId)` is `a`.
2042      */
2043     // solhint-disable-next-line func-name-mixedcase
2044     function __unsafe_increaseBalance(address account, uint256 amount) internal {
2045         _balances[account] += amount;
2046     }
2047 }
2048 
2049 /**
2050  * @dev Interface of the ERC20 standard as defined in the EIP.
2051  */
2052 interface IERC20 {
2053     /**
2054      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2055      * another (`to`).
2056      *
2057      * Note that `value` may be zero.
2058      */
2059     event Transfer(address indexed from, address indexed to, uint256 value);
2060 
2061     /**
2062      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2063      * a call to {approve}. `value` is the new allowance.
2064      */
2065     event Approval(
2066         address indexed owner,
2067         address indexed spender,
2068         uint256 value
2069     );
2070 
2071     /**
2072      * @dev Returns the amount of tokens in existence.
2073      */
2074     function totalSupply() external view returns (uint256);
2075 
2076     /**
2077      * @dev Returns the amount of tokens owned by `account`.
2078      */
2079     function balanceOf(address account) external view returns (uint256);
2080 
2081     /**
2082      * @dev Moves `amount` tokens from the caller's account to `to`.
2083      *
2084      * Returns a boolean value indicating whether the operation succeeded.
2085      *
2086      * Emits a {Transfer} event.
2087      */
2088     function transfer(address to, uint256 amount) external returns (bool);
2089 
2090     /**
2091      * @dev Returns the remaining number of tokens that `spender` will be
2092      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2093      * zero by default.
2094      *
2095      * This value changes when {approve} or {transferFrom} are called.
2096      */
2097     function allowance(
2098         address owner,
2099         address spender
2100     ) external view returns (uint256);
2101 
2102     /**
2103      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2104      *
2105      * Returns a boolean value indicating whether the operation succeeded.
2106      *
2107      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2108      * that someone may use both the old and the new allowance by unfortunate
2109      * transaction ordering. One possible solution to mitigate this race
2110      * condition is to first reduce the spender's allowance to 0 and set the
2111      * desired value afterwards:
2112      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2113      *
2114      * Emits an {Approval} event.
2115      */
2116     function approve(address spender, uint256 amount) external returns (bool);
2117 
2118     /**
2119      * @dev Moves `amount` tokens from `from` to `to` using the
2120      * allowance mechanism. `amount` is then deducted from the caller's
2121      * allowance.
2122      *
2123      * Returns a boolean value indicating whether the operation succeeded.
2124      *
2125      * Emits a {Transfer} event.
2126      */
2127     function transferFrom(
2128         address from,
2129         address to,
2130         uint256 amount
2131     ) external returns (bool);
2132 }
2133 
2134 
2135 /**
2136  * @title SafeERC20
2137  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2138  * contract returns false). Tokens that return no value (and instead revert or
2139  * throw on failure) are also supported, non-reverting calls are assumed to be
2140  * successful.
2141  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2142  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2143  */
2144 library SafeERC20 {
2145     using Address for address;
2146 
2147     function safeTransfer(IERC20 token, address to, uint256 value) internal {
2148         _callOptionalReturn(
2149             token,
2150             abi.encodeWithSelector(token.transfer.selector, to, value)
2151         );
2152     }
2153 
2154     function safeTransferFrom(
2155         IERC20 token,
2156         address from,
2157         address to,
2158         uint256 value
2159     ) internal {
2160         _callOptionalReturn(
2161             token,
2162             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
2163         );
2164     }
2165 
2166     /**
2167      * @dev Deprecated. This function has issues similar to the ones found in
2168      * {IERC20-approve}, and its usage is discouraged.
2169      *
2170      * Whenever possible, use {safeIncreaseAllowance} and
2171      * {safeDecreaseAllowance} instead.
2172      */
2173     function safeApprove(
2174         IERC20 token,
2175         address spender,
2176         uint256 value
2177     ) internal {
2178         // safeApprove should only be called when setting an initial allowance,
2179         // or when resetting it to zero. To increase and decrease it, use
2180         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2181         require(
2182             (value == 0) || (token.allowance(address(this), spender) == 0),
2183             "SafeERC20: approve from non-zero to non-zero allowance"
2184         );
2185         _callOptionalReturn(
2186             token,
2187             abi.encodeWithSelector(token.approve.selector, spender, value)
2188         );
2189     }
2190 
2191     function safeIncreaseAllowance(
2192         IERC20 token,
2193         address spender,
2194         uint256 value
2195     ) internal {
2196         uint256 newAllowance = token.allowance(address(this), spender) + value;
2197         _callOptionalReturn(
2198             token,
2199             abi.encodeWithSelector(
2200                 token.approve.selector,
2201                 spender,
2202                 newAllowance
2203             )
2204         );
2205     }
2206 
2207     function safeDecreaseAllowance(
2208         IERC20 token,
2209         address spender,
2210         uint256 value
2211     ) internal {
2212         unchecked {
2213             uint256 oldAllowance = token.allowance(address(this), spender);
2214             require(
2215                 oldAllowance >= value,
2216                 "SafeERC20: decreased allowance below zero"
2217             );
2218             uint256 newAllowance = oldAllowance - value;
2219             _callOptionalReturn(
2220                 token,
2221                 abi.encodeWithSelector(
2222                     token.approve.selector,
2223                     spender,
2224                     newAllowance
2225                 )
2226             );
2227         }
2228     }
2229 
2230     /**
2231      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2232      * on the return value: the return value is optional (but if data is returned, it must not be false).
2233      * @param token The token targeted by the call.
2234      * @param data The call data (encoded using abi.encode or one of its variants).
2235      */
2236     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2237         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2238         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2239         // the target address contains contract code and also asserts for success in the low-level call.
2240 
2241         bytes memory returndata = address(token).functionCall(
2242             data,
2243             "SafeERC20: low-level call failed"
2244         );
2245         if (returndata.length > 0) {
2246             // Return data is optional
2247             require(
2248                 abi.decode(returndata, (bool)),
2249                 "SafeERC20: ERC20 operation did not succeed"
2250             );
2251         }
2252     }
2253 }
2254 
2255 
2256 /**
2257  * @title PaymentSplitter
2258  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2259  * that the Ether will be split in this way, since it is handled transparently by the contract.
2260  *
2261  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2262  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2263  * an amount proportional to the percentage of total shares they were assigned.
2264  *
2265  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2266  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2267  * function.
2268  *
2269  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2270  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2271  * to run tests before sending real value to this contract.
2272  */
2273 contract PaymentSplitter is Context {
2274     event PayeeAdded(address account, uint256 shares);
2275     event PaymentReleased(address to, uint256 amount);
2276     event ERC20PaymentReleased(
2277         IERC20 indexed token,
2278         address to,
2279         uint256 amount
2280     );
2281     event PaymentReceived(address from, uint256 amount);
2282 
2283     uint256 private _totalShares;
2284     uint256 private _totalReleased;
2285 
2286     mapping(address => uint256) private _shares;
2287     mapping(address => uint256) private _released;
2288     address[] private _payees;
2289 
2290     mapping(IERC20 => uint256) private _erc20TotalReleased;
2291     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2292 
2293     /**
2294      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2295      * the matching position in the `shares` array.
2296      *
2297      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2298      * duplicates in `payees`.
2299      */
2300     constructor(address[] memory payees, uint256[] memory shares_) payable {
2301         require(
2302             payees.length == shares_.length,
2303             "PaymentSplitter: payees and shares length mismatch"
2304         );
2305         require(payees.length > 0, "PaymentSplitter: no payees");
2306 
2307         for (uint256 i = 0; i < payees.length; i++) {
2308             _addPayee(payees[i], shares_[i]);
2309         }
2310     }
2311 
2312     /**
2313      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2314      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2315      * reliability of the events, and not the actual splitting of Ether.
2316      *
2317      * To learn more about this see the Solidity documentation for
2318      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2319      * functions].
2320      */
2321     receive() external payable virtual {
2322         emit PaymentReceived(_msgSender(), msg.value);
2323     }
2324 
2325     /**
2326      * @dev Getter for the total shares held by payees.
2327      */
2328     function totalShares() public view returns (uint256) {
2329         return _totalShares;
2330     }
2331 
2332     /**
2333      * @dev Getter for the total amount of Ether already released.
2334      */
2335     function totalReleased() public view returns (uint256) {
2336         return _totalReleased;
2337     }
2338 
2339     /**
2340      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2341      * contract.
2342      */
2343     function totalReleased(IERC20 token) public view returns (uint256) {
2344         return _erc20TotalReleased[token];
2345     }
2346 
2347     /**
2348      * @dev Getter for the amount of shares held by an account.
2349      */
2350     function shares(address account) public view returns (uint256) {
2351         return _shares[account];
2352     }
2353 
2354     /**
2355      * @dev Getter for the amount of Ether already released to a payee.
2356      */
2357     function released(address account) public view returns (uint256) {
2358         return _released[account];
2359     }
2360 
2361     /**
2362      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2363      * IERC20 contract.
2364      */
2365     function released(
2366         IERC20 token,
2367         address account
2368     ) public view returns (uint256) {
2369         return _erc20Released[token][account];
2370     }
2371 
2372     /**
2373      * @dev Getter for the address of the payee number `index`.
2374      */
2375     function payee(uint256 index) public view returns (address) {
2376         return _payees[index];
2377     }
2378 
2379     /**
2380      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2381      * total shares and their previous withdrawals.
2382      */
2383     function release(address payable account) public virtual {
2384         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2385 
2386         uint256 totalReceived = address(this).balance + totalReleased();
2387         uint256 payment = _pendingPayment(
2388             account,
2389             totalReceived,
2390             released(account)
2391         );
2392 
2393         require(payment != 0, "PaymentSplitter: account is not due payment");
2394 
2395         _released[account] += payment;
2396         _totalReleased += payment;
2397 
2398         Address.sendValue(account, payment);
2399         emit PaymentReleased(account, payment);
2400     }
2401 
2402     /**
2403      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2404      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2405      * contract.
2406      */
2407     function release(IERC20 token, address account) public virtual {
2408         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2409 
2410         uint256 totalReceived = token.balanceOf(address(this)) +
2411             totalReleased(token);
2412         uint256 payment = _pendingPayment(
2413             account,
2414             totalReceived,
2415             released(token, account)
2416         );
2417 
2418         require(payment != 0, "PaymentSplitter: account is not due payment");
2419 
2420         _erc20Released[token][account] += payment;
2421         _erc20TotalReleased[token] += payment;
2422 
2423         SafeERC20.safeTransfer(token, account, payment);
2424         emit ERC20PaymentReleased(token, account, payment);
2425     }
2426 
2427     /**
2428      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2429      * already released amounts.
2430      */
2431     function _pendingPayment(
2432         address account,
2433         uint256 totalReceived,
2434         uint256 alreadyReleased
2435     ) private view returns (uint256) {
2436         return
2437             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2438     }
2439 
2440     /**
2441      * @dev Add a new payee to the contract.
2442      * @param account The address of the payee to add.
2443      * @param shares_ The number of shares owned by the payee.
2444      */
2445     function _addPayee(address account, uint256 shares_) private {
2446         require(
2447             account != address(0),
2448             "PaymentSplitter: account is the zero address"
2449         );
2450         require(shares_ > 0, "PaymentSplitter: shares are 0");
2451         require(
2452             _shares[account] == 0,
2453             "PaymentSplitter: account already has shares"
2454         );
2455 
2456         _payees.push(account);
2457         _shares[account] = shares_;
2458         _totalShares = _totalShares + shares_;
2459         emit PayeeAdded(account, shares_);
2460     }
2461 }
2462 
2463 pragma solidity ^0.8.13;
2464 
2465 interface IOperatorFilterRegistry {
2466     function isOperatorAllowed(
2467         address registrant,
2468         address operator
2469     ) external view returns (bool);
2470 
2471     function register(address registrant) external;
2472 
2473     function registerAndSubscribe(
2474         address registrant,
2475         address subscription
2476     ) external;
2477 
2478     function registerAndCopyEntries(
2479         address registrant,
2480         address registrantToCopy
2481     ) external;
2482 
2483     function unregister(address addr) external;
2484 
2485     function updateOperator(
2486         address registrant,
2487         address operator,
2488         bool filtered
2489     ) external;
2490 
2491     function updateOperators(
2492         address registrant,
2493         address[] calldata operators,
2494         bool filtered
2495     ) external;
2496 
2497     function updateCodeHash(
2498         address registrant,
2499         bytes32 codehash,
2500         bool filtered
2501     ) external;
2502 
2503     function updateCodeHashes(
2504         address registrant,
2505         bytes32[] calldata codeHashes,
2506         bool filtered
2507     ) external;
2508 
2509     function subscribe(
2510         address registrant,
2511         address registrantToSubscribe
2512     ) external;
2513 
2514     function unsubscribe(address registrant, bool copyExistingEntries) external;
2515 
2516     function subscriptionOf(address addr) external returns (address registrant);
2517 
2518     function subscribers(
2519         address registrant
2520     ) external returns (address[] memory);
2521 
2522     function subscriberAt(
2523         address registrant,
2524         uint256 index
2525     ) external returns (address);
2526 
2527     function copyEntriesOf(
2528         address registrant,
2529         address registrantToCopy
2530     ) external;
2531 
2532     function isOperatorFiltered(
2533         address registrant,
2534         address operator
2535     ) external returns (bool);
2536 
2537     function isCodeHashOfFiltered(
2538         address registrant,
2539         address operatorWithCode
2540     ) external returns (bool);
2541 
2542     function isCodeHashFiltered(
2543         address registrant,
2544         bytes32 codeHash
2545     ) external returns (bool);
2546 
2547     function filteredOperators(
2548         address addr
2549     ) external returns (address[] memory);
2550 
2551     function filteredCodeHashes(
2552         address addr
2553     ) external returns (bytes32[] memory);
2554 
2555     function filteredOperatorAt(
2556         address registrant,
2557         uint256 index
2558     ) external returns (address);
2559 
2560     function filteredCodeHashAt(
2561         address registrant,
2562         uint256 index
2563     ) external returns (bytes32);
2564 
2565     function isRegistered(address addr) external returns (bool);
2566 
2567     function codeHashOf(address addr) external returns (bytes32);
2568 }
2569 
2570 pragma solidity ^0.8.13;
2571 
2572 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
2573 /// mandatory on-chain royalty enforcement in order for new collections to
2574 /// receive royalties.
2575 /// For more information, see:
2576 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
2577 abstract contract OperatorFilterer {
2578     /// @dev The default OpenSea operator blocklist subscription.
2579     address internal constant _DEFAULT_SUBSCRIPTION =
2580         0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2581 
2582     /// @dev The OpenSea operator filter registry.
2583     address internal constant _OPERATOR_FILTER_REGISTRY =
2584         0x000000000000AAeB6D7670E522A718067333cd4E;
2585 
2586     /// @dev Registers the current contract to OpenSea's operator filter,
2587     /// and subscribe to the default OpenSea operator blocklist.
2588     /// Note: Will not revert nor update existing settings for repeated registration.
2589     function _registerForOperatorFiltering() internal virtual {
2590         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
2591     }
2592 
2593     /// @dev Registers the current contract to OpenSea's operator filter.
2594     /// Note: Will not revert nor update existing settings for repeated registration.
2595     function _registerForOperatorFiltering(
2596         address subscriptionOrRegistrantToCopy,
2597         bool subscribe
2598     ) internal virtual {
2599         /// @solidity memory-safe-assembly
2600         assembly {
2601             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
2602 
2603             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
2604             subscriptionOrRegistrantToCopy := shr(
2605                 96,
2606                 shl(96, subscriptionOrRegistrantToCopy)
2607             )
2608 
2609             for {
2610 
2611             } iszero(subscribe) {
2612 
2613             } {
2614                 if iszero(subscriptionOrRegistrantToCopy) {
2615                     functionSelector := 0x4420e486 // `register(address)`.
2616                     break
2617                 }
2618                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
2619                 break
2620             }
2621             // Store the function selector.
2622             mstore(0x00, shl(224, functionSelector))
2623             // Store the `address(this)`.
2624             mstore(0x04, address())
2625             // Store the `subscriptionOrRegistrantToCopy`.
2626             mstore(0x24, subscriptionOrRegistrantToCopy)
2627             // Register into the registry.
2628             if iszero(
2629                 call(
2630                     gas(),
2631                     _OPERATOR_FILTER_REGISTRY,
2632                     0,
2633                     0x00,
2634                     0x44,
2635                     0x00,
2636                     0x04
2637                 )
2638             ) {
2639                 // If the function selector has not been overwritten,
2640                 // it is an out-of-gas error.
2641                 if eq(shr(224, mload(0x00)), functionSelector) {
2642                     // To prevent gas under-estimation.
2643                     revert(0, 0)
2644                 }
2645             }
2646             // Restore the part of the free memory pointer that was overwritten,
2647             // which is guaranteed to be zero, because of Solidity's memory size limits.
2648             mstore(0x24, 0)
2649         }
2650     }
2651 
2652     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
2653     modifier onlyAllowedOperator(address from) virtual {
2654         if (from != msg.sender) {
2655             if (!_isPriorityOperator(msg.sender)) {
2656                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
2657             }
2658         }
2659         _;
2660     }
2661 
2662     /// @dev Modifier to guard a function from approving a blocked operator..
2663     modifier onlyAllowedOperatorApproval(address operator) virtual {
2664         if (!_isPriorityOperator(operator)) {
2665             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
2666         }
2667         _;
2668     }
2669 
2670     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
2671     function _revertIfBlocked(address operator) private view {
2672         /// @solidity memory-safe-assembly
2673         assembly {
2674             // Store the function selector of `isOperatorAllowed(address,address)`,
2675             // shifted left by 6 bytes, which is enough for 8tb of memory.
2676             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
2677             mstore(0x00, 0xc6171134001122334455)
2678             // Store the `address(this)`.
2679             mstore(0x1a, address())
2680             // Store the `operator`.
2681             mstore(0x3a, operator)
2682 
2683             // `isOperatorAllowed` always returns true if it does not revert.
2684             if iszero(
2685                 staticcall(
2686                     gas(),
2687                     _OPERATOR_FILTER_REGISTRY,
2688                     0x16,
2689                     0x44,
2690                     0x00,
2691                     0x00
2692                 )
2693             ) {
2694                 // Bubble up the revert if the staticcall reverts.
2695                 returndatacopy(0x00, 0x00, returndatasize())
2696                 revert(0x00, returndatasize())
2697             }
2698 
2699             // We'll skip checking if `from` is inside the blacklist.
2700             // Even though that can block transferring out of wrapper contracts,
2701             // we don't want tokens to be stuck.
2702 
2703             // Restore the part of the free memory pointer that was overwritten,
2704             // which is guaranteed to be zero, if less than 8tb of memory is used.
2705             mstore(0x3a, 0)
2706         }
2707     }
2708 
2709     /// @dev For deriving contracts to override, so that operator filtering
2710     /// can be turned on / off.
2711     /// Returns true by default.
2712     function _operatorFilteringEnabled() internal view virtual returns (bool) {
2713         return true;
2714     }
2715 
2716     /// @dev For deriving contracts to override, so that preferred marketplaces can
2717     /// skip operator filtering, helping users save gas.
2718     /// Returns false for all inputs by default.
2719     function _isPriorityOperator(address) internal view virtual returns (bool) {
2720         return false;
2721     }
2722 }
2723 
2724 /**
2725  * @dev Interface for the NFT Royalty Standard.
2726  *
2727  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2728  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2729  *
2730  * _Available since v4.5._
2731  */
2732 interface IERC2981 is IERC165 {
2733     /**
2734      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2735      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2736      */
2737     function royaltyInfo(
2738         uint256 tokenId,
2739         uint256 salePrice
2740     ) external view returns (address receiver, uint256 royaltyAmount);
2741 }
2742 
2743 /**
2744  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2745  *
2746  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2747  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2748  *
2749  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2750  * fee is specified in basis points by default.
2751  *
2752  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2753  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2754  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2755  *
2756  * _Available since v4.5._
2757  */
2758 abstract contract ERC2981 is IERC2981, ERC165 {
2759     struct RoyaltyInfo {
2760         address receiver;
2761         uint96 royaltyFraction;
2762     }
2763 
2764     RoyaltyInfo private _defaultRoyaltyInfo;
2765     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2766 
2767     /**
2768      * @dev See {IERC165-supportsInterface}.
2769      */
2770     function supportsInterface(
2771         bytes4 interfaceId
2772     ) public view virtual override(IERC165, ERC165) returns (bool) {
2773         return
2774             interfaceId == type(IERC2981).interfaceId ||
2775             super.supportsInterface(interfaceId);
2776     }
2777 
2778     /**
2779      * @inheritdoc IERC2981
2780      */
2781     function royaltyInfo(
2782         uint256 tokenId,
2783         uint256 salePrice
2784     ) public view virtual override returns (address, uint256) {
2785         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
2786 
2787         if (royalty.receiver == address(0)) {
2788             royalty = _defaultRoyaltyInfo;
2789         }
2790 
2791         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) /
2792             _feeDenominator();
2793 
2794         return (royalty.receiver, royaltyAmount);
2795     }
2796 
2797     /**
2798      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2799      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2800      * override.
2801      */
2802     function _feeDenominator() internal pure virtual returns (uint96) {
2803         return 10000;
2804     }
2805 
2806     /**
2807      * @dev Sets the royalty information that all ids in this contract will default to.
2808      *
2809      * Requirements:
2810      *
2811      * - `receiver` cannot be the zero address.
2812      * - `feeNumerator` cannot be greater than the fee denominator.
2813      */
2814     function _setDefaultRoyalty(
2815         address receiver,
2816         uint96 feeNumerator
2817     ) internal virtual {
2818         require(
2819             feeNumerator <= _feeDenominator(),
2820             "ERC2981: royalty fee will exceed salePrice"
2821         );
2822         require(receiver != address(0), "ERC2981: invalid receiver");
2823 
2824         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2825     }
2826 
2827     /**
2828      * @dev Removes default royalty information.
2829      */
2830     function _deleteDefaultRoyalty() internal virtual {
2831         delete _defaultRoyaltyInfo;
2832     }
2833 
2834     /**
2835      * @dev Sets the royalty information for a specific token id, overriding the global default.
2836      *
2837      * Requirements:
2838      *
2839      * - `receiver` cannot be the zero address.
2840      * - `feeNumerator` cannot be greater than the fee denominator.
2841      */
2842     function _setTokenRoyalty(
2843         uint256 tokenId,
2844         address receiver,
2845         uint96 feeNumerator
2846     ) internal virtual {
2847         require(
2848             feeNumerator <= _feeDenominator(),
2849             "ERC2981: royalty fee will exceed salePrice"
2850         );
2851         require(receiver != address(0), "ERC2981: Invalid parameters");
2852 
2853         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2854     }
2855 
2856     /**
2857      * @dev Resets royalty information for the token id back to the global default.
2858      */
2859     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2860         delete _tokenRoyaltyInfo[tokenId];
2861     }
2862 }
2863 
2864 // --------------   Azuki Apes Main Contract Code -------------
2865 
2866 pragma solidity ^0.8.15;
2867 
2868 interface ApeForgeInterface {
2869     function _nftTokenForges(uint256 tokenId) external view returns (address);
2870 }
2871 
2872 contract AzukiApes is ERC721, Ownable, OperatorFilterer {
2873     bool public operatorFilteringEnabled;
2874 
2875     address private ApeContract = 0x813b5c4aE6b188F4581aa1dfdB7f4Aba44AA578B;
2876     address private ApeForge = 0xc4Df0F70A590D01e6cA3B15284b2001c0c60c695;
2877 
2878     uint256 private maxSupply = 3333;
2879     bool public claimIsActive = true;
2880 
2881     string private _baseTokenURI =
2882         "ipfs://QmYfNQVevkhXYoV9Aoo4QuAYpenWrGQCk2AUAuGyh3aLUk/";
2883 
2884     // NOTE: Map old token id to new (same) token id
2885     mapping(uint => uint256) public apeClaimed;
2886     mapping(uint256 => bool) private _lockedTokens;
2887 
2888     mapping(uint256 => uint256) private _lockTimestamps;
2889 
2890     constructor() ERC721("Azuki Apes", "AZUKIAPE") {
2891         _registerForOperatorFiltering();
2892         operatorFilteringEnabled = true;
2893     }
2894 
2895     function isClaimed(uint256 tokenId) external view returns (uint256) {
2896         return apeClaimed[tokenId];
2897     }
2898 
2899     function burn(uint256 tokenId) external {
2900         require(
2901             msg.sender == ownerOf(tokenId) || msg.sender == owner(),
2902             "Must own or be contract owner to burn"
2903         );
2904         _burn(tokenId);
2905     }
2906 
2907     event ClaimActivation(bool isActive);
2908     event ApeWasClaimed(address theAddress, uint256 theTokenId);
2909     event ApeNotFound(address theAddress, uint256 theTokenId, uint256 isForged);
2910 
2911     function mintApe(uint256 tokenId) internal {
2912         _safeMint(msg.sender, tokenId);
2913         apeClaimed[tokenId] = 1;
2914         emit ApeWasClaimed(msg.sender, tokenId);
2915     }
2916 
2917     function claimApes(uint256[] memory theTokenIDs) public {
2918         require(claimIsActive, "Claim Inactive");
2919 
2920         uint256 numTokens = theTokenIDs.length;
2921         require(numTokens != 0, "Empty token ID array");
2922 
2923         // Fetch the balance once instead of in every loop iteration
2924         uint256 senderBalance = IERC721(ApeContract).balanceOf(msg.sender);
2925         require(senderBalance >= numTokens, "Insufficient NFT balance");
2926 
2927         for (uint256 i; i < numTokens; i++) {
2928             uint256 tokenId = theTokenIDs[i];
2929 
2930             if (tokenId > maxSupply) {
2931                 continue;
2932             }
2933 
2934             if (apeClaimed[tokenId] == 0) {
2935                 if (IERC721(ApeContract).ownerOf(tokenId) != msg.sender) {
2936                     emit ApeNotFound(msg.sender, tokenId, 0);
2937                     continue;
2938                 }
2939                 mintApe(tokenId);
2940             }
2941         }
2942     }
2943 
2944     function claimForgedApes(uint256[] memory theTokenIDs) external {
2945         require(claimIsActive, "Claim Inactive");
2946 
2947         uint256 numTokens = theTokenIDs.length;
2948         require(numTokens != 0, "Empty token ID array");
2949 
2950         for (uint256 i; i < numTokens; i++) {
2951             uint256 tokenId = theTokenIDs[i];
2952 
2953             if (tokenId > maxSupply) {
2954                 continue;
2955             }
2956 
2957             if (apeClaimed[tokenId] == 0) {
2958                 if (
2959                     ApeForgeInterface(ApeForge)._nftTokenForges(tokenId) !=
2960                     msg.sender
2961                 ) {
2962                     emit ApeNotFound(msg.sender, tokenId, 1);
2963                     continue;
2964                 }
2965                 mintApe(tokenId);
2966             }
2967         }
2968     }
2969 
2970     // --------------------------------------------------------------------
2971     // OpenSea's new requirements to make sure royalties work (for now,
2972     // until they miraculously again decide to rug all of web3 nfts again)
2973     // They are also bloated as fuck and generally annoying, but if they do
2974     // not exist, OpenSea refuses royalties and transfers are broken. 🖕
2975     //
2976     // ref: https://github.com/Vectorized/closedsea/tree/main
2977 
2978     function setApprovalForAll(address operator, bool approved)
2979         public
2980         override
2981         onlyAllowedOperatorApproval(operator)
2982     {
2983         super.setApprovalForAll(operator, approved);
2984     }
2985 
2986     function approve(address operator, uint256 tokenId)
2987         public
2988         override
2989         onlyAllowedOperatorApproval(operator)
2990     {
2991         super.approve(operator, tokenId);
2992     }
2993 
2994     function transferFrom(address from, address to, uint256 tokenId)
2995         public
2996         override
2997         onlyAllowedOperator(from)
2998     {
2999         super.transferFrom(from, to, tokenId);
3000     }
3001 
3002     function safeTransferFrom(address from, address to, uint256 tokenId)
3003         public
3004         override
3005         onlyAllowedOperator(from)
3006     {
3007         super.safeTransferFrom(from, to, tokenId);
3008     }
3009 
3010     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3011         public
3012         override
3013         onlyAllowedOperator(from)
3014     {
3015         super.safeTransferFrom(from, to, tokenId, data);
3016     }
3017 
3018     function supportsInterface(bytes4 interfaceId)
3019         public
3020         view
3021         virtual
3022         override(ERC721)
3023         returns (bool)
3024     {
3025         // Supports the following `interfaceId`s:
3026         // - IERC165: 0x01ffc9a7
3027         // - IERC721: 0x80ac58cd
3028         // - IERC721Metadata: 0x5b5e139f
3029         // - IERC2981: 0x2a55205a
3030         return ERC721.supportsInterface(interfaceId);
3031     }
3032 
3033     function setOperatorFilteringEnabled(bool value) public onlyOwner {
3034         operatorFilteringEnabled = value;
3035     }
3036 
3037     function _operatorFilteringEnabled() internal view override returns (bool) {
3038         return operatorFilteringEnabled;
3039     }
3040 
3041     function _isPriorityOperator(address operator) internal pure override returns (bool) {
3042         // OpenSea Seaport Conduit:
3043         // https://etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
3044         // https://goerli.etherscan.io/address/0x1E0049783F008A0085193E00003D00cd54003c71
3045         return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
3046     }
3047 
3048     // ---------------------------------------------------------------
3049     // Functions allowed by owner and no one else, hence 'onlyOwner'
3050     // ---------------------------------------------------------------
3051 
3052     function toggleSaleStatus() external onlyOwner {
3053         claimIsActive = !claimIsActive;
3054         emit ClaimActivation(claimIsActive);
3055     }
3056 
3057     function setBaseURI(string memory baseURI) external onlyOwner {
3058         _baseTokenURI = baseURI;
3059     }
3060 
3061     function _baseURI() internal view virtual override returns (string memory) {
3062         return _baseTokenURI;
3063     }
3064 
3065     function tokenURI(
3066         uint256 tokenId
3067     ) public view override returns (string memory) {
3068         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
3069     }
3070 
3071     function changeMaxSupply(uint256 number) external onlyOwner {
3072         maxSupply = number;
3073     }
3074 
3075     // NOTE: These are onlyOwner functions in case something goes
3076     //       wrong, so the issues can be resolved.
3077     //       Mint token to address, claim ETH (if someone accidentally
3078     //       sends it to the contract)
3079     //       burn tokens in case something goes sideways with tokens
3080     //       NONE NEED TO BE USED, but... better to have and not need.
3081 
3082     function mint(address to, uint256 theToken) external onlyOwner {
3083         _safeMint(to, theToken);
3084     }
3085 
3086     function ownerClaim() external onlyOwner {
3087         uint256 balance = address(this).balance;
3088         payable(msg.sender).transfer(balance);
3089     }
3090 
3091     function ownerBurner(uint256[] calldata tokenIds) external onlyOwner {
3092         for (uint256 i; i < tokenIds.length; i++) {
3093             _burn(tokenIds[i]);
3094         }
3095     }
3096 }