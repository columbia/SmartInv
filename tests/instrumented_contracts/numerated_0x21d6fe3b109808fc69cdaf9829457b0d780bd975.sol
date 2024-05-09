1 // SPDX-License-Identifier: MIT
2 
3 /*
4      .____    .__             .__    .___
5      |    |   |__| ________ __|__| __| _/
6      |    |   |  |/ ____/  |  \  |/ __ |
7      |    |___|  < <_|  |  |  /  / /_/ |
8      |_______ \__|\__   |____/|__\____ |
9              \/      |__|             \/
10  ___________.__  __
11  \__    ___/|__|/  |______    ____   ______
12    |    |   |  \   __\__  \  /    \ /  ___/
13    |    |   |  ||  |  / __ \|   |  \\___ \
14    |____|   |__||__| (____  /___|  /____  >
15                           \/     \/     \/
16 */
17 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev External interface of AccessControl declared to support ERC165 detection.
23  */
24 interface IAccessControl {
25     /**
26      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
27      *
28      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
29      * {RoleAdminChanged} not being emitted signaling this.
30      *
31      * _Available since v3.1._
32      */
33     event RoleAdminChanged(
34         bytes32 indexed role,
35         bytes32 indexed previousAdminRole,
36         bytes32 indexed newAdminRole
37     );
38 
39     /**
40      * @dev Emitted when `account` is granted `role`.
41      *
42      * `sender` is the account that originated the contract call, an admin role
43      * bearer except when using {AccessControl-_setupRole}.
44      */
45     event RoleGranted(
46         bytes32 indexed role,
47         address indexed account,
48         address indexed sender
49     );
50 
51     /**
52      * @dev Emitted when `account` is revoked `role`.
53      *
54      * `sender` is the account that originated the contract call:
55      *   - if using `revokeRole`, it is the admin role bearer
56      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
57      */
58     event RoleRevoked(
59         bytes32 indexed role,
60         address indexed account,
61         address indexed sender
62     );
63 
64     /**
65      * @dev Returns `true` if `account` has been granted `role`.
66      */
67     function hasRole(
68         bytes32 role,
69         address account
70     ) external view returns (bool);
71 
72     /**
73      * @dev Returns the admin role that controls `role`. See {grantRole} and
74      * {revokeRole}.
75      *
76      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
77      */
78     function getRoleAdmin(bytes32 role) external view returns (bytes32);
79 
80     /**
81      * @dev Grants `role` to `account`.
82      *
83      * If `account` had not been already granted `role`, emits a {RoleGranted}
84      * event.
85      *
86      * Requirements:
87      *
88      * - the caller must have ``role``'s admin role.
89      */
90     function grantRole(bytes32 role, address account) external;
91 
92     /**
93      * @dev Revokes `role` from `account`.
94      *
95      * If `account` had been granted `role`, emits a {RoleRevoked} event.
96      *
97      * Requirements:
98      *
99      * - the caller must have ``role``'s admin role.
100      */
101     function revokeRole(bytes32 role, address account) external;
102 
103     /**
104      * @dev Revokes `role` from the calling account.
105      *
106      * Roles are often managed via {grantRole} and {revokeRole}: this function's
107      * purpose is to provide a mechanism for accounts to lose their privileges
108      * if they are compromised (such as when a trusted device is misplaced).
109      *
110      * If the calling account had been granted `role`, emits a {RoleRevoked}
111      * event.
112      *
113      * Requirements:
114      *
115      * - the caller must be `account`.
116      */
117     function renounceRole(bytes32 role, address account) external;
118 }
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC165 standard, as defined in the
124  * https://eips.ethereum.org/EIPS/eip-165[EIP].
125  *
126  * Implementers can declare support of contract interfaces, which can then be
127  * queried by others ({ERC165Checker}).
128  *
129  * For an implementation, see {ERC165}.
130  */
131 interface IERC165 {
132     /**
133      * @dev Returns true if this contract implements the interface defined by
134      * `interfaceId`. See the corresponding
135      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
136      * to learn more about how these ids are created.
137      *
138      * This function call must use less than 30 000 gas.
139      */
140     function supportsInterface(bytes4 interfaceId) external view returns (bool);
141 }
142 
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
147  */
148 interface IAccessControlEnumerable is IAccessControl {
149     /**
150      * @dev Returns one of the accounts that have `role`. `index` must be a
151      * value between 0 and {getRoleMemberCount}, non-inclusive.
152      *
153      * Role bearers are not sorted in any particular way, and their ordering may
154      * change at any point.
155      *
156      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
157      * you perform all queries on the same block. See the following
158      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
159      * for more information.
160      */
161     function getRoleMember(
162         bytes32 role,
163         uint256 index
164     ) external view returns (address);
165 
166     /**
167      * @dev Returns the number of accounts that have `role`. Can be used
168      * together with {getRoleMember} to enumerate all bearers of a role.
169      */
170     function getRoleMemberCount(bytes32 role) external view returns (uint256);
171 }
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Library for managing
177  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
178  * types.
179  *
180  * Sets have the following properties:
181  *
182  * - Elements are added, removed, and checked for existence in constant time
183  * (O(1)).
184  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
185  *
186  * ```
187  * contract Example {
188  *     // Add the library methods
189  *     using EnumerableSet for EnumerableSet.AddressSet;
190  *
191  *     // Declare a set state variable
192  *     EnumerableSet.AddressSet private mySet;
193  * }
194  * ```
195  *
196  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
197  * and `uint256` (`UintSet`) are supported.
198  */
199 library EnumerableSet {
200     // To implement this library for multiple types with as little code
201     // repetition as possible, we write it in terms of a generic Set type with
202     // bytes32 values.
203     // The Set implementation uses private functions, and user-facing
204     // implementations (such as AddressSet) are just wrappers around the
205     // underlying Set.
206     // This means that we can only create new EnumerableSets for types that fit
207     // in bytes32.
208 
209     struct Set {
210         // Storage of set values
211         bytes32[] _values;
212         // Position of the value in the `values` array, plus 1 because index 0
213         // means a value is not in the set.
214         mapping(bytes32 => uint256) _indexes;
215     }
216 
217     /**
218      * @dev Add a value to a set. O(1).
219      *
220      * Returns true if the value was added to the set, that is if it was not
221      * already present.
222      */
223     function _add(Set storage set, bytes32 value) private returns (bool) {
224         if (!_contains(set, value)) {
225             set._values.push(value);
226             // The value is stored at length-1, but we add 1 to all indexes
227             // and use 0 as a sentinel value
228             set._indexes[value] = set._values.length;
229             return true;
230         } else {
231             return false;
232         }
233     }
234 
235     /**
236      * @dev Removes a value from a set. O(1).
237      *
238      * Returns true if the value was removed from the set, that is if it was
239      * present.
240      */
241     function _remove(Set storage set, bytes32 value) private returns (bool) {
242         // We read and store the value's index to prevent multiple reads from the same storage slot
243         uint256 valueIndex = set._indexes[value];
244 
245         if (valueIndex != 0) {
246             // Equivalent to contains(set, value)
247             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
248             // the array, and then remove the last element (sometimes called as 'swap and pop').
249             // This modifies the order of the array, as noted in {at}.
250 
251             uint256 toDeleteIndex = valueIndex - 1;
252             uint256 lastIndex = set._values.length - 1;
253 
254             if (lastIndex != toDeleteIndex) {
255                 bytes32 lastvalue = set._values[lastIndex];
256 
257                 // Move the last value to the index where the value to delete is
258                 set._values[toDeleteIndex] = lastvalue;
259                 // Update the index for the moved value
260                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
261             }
262 
263             // Delete the slot where the moved value was stored
264             set._values.pop();
265 
266             // Delete the index for the deleted slot
267             delete set._indexes[value];
268 
269             return true;
270         } else {
271             return false;
272         }
273     }
274 
275     /**
276      * @dev Returns true if the value is in the set. O(1).
277      */
278     function _contains(
279         Set storage set,
280         bytes32 value
281     ) private view returns (bool) {
282         return set._indexes[value] != 0;
283     }
284 
285     /**
286      * @dev Returns the number of values on the set. O(1).
287      */
288     function _length(Set storage set) private view returns (uint256) {
289         return set._values.length;
290     }
291 
292     /**
293      * @dev Returns the value stored at position `index` in the set. O(1).
294      *
295      * Note that there are no guarantees on the ordering of values inside the
296      * array, and it may change when more values are added or removed.
297      *
298      * Requirements:
299      *
300      * - `index` must be strictly less than {length}.
301      */
302     function _at(
303         Set storage set,
304         uint256 index
305     ) private view returns (bytes32) {
306         return set._values[index];
307     }
308 
309     /**
310      * @dev Return the entire set in an array
311      *
312      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
313      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
314      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
315      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
316      */
317     function _values(Set storage set) private view returns (bytes32[] memory) {
318         return set._values;
319     }
320 
321     // Bytes32Set
322 
323     struct Bytes32Set {
324         Set _inner;
325     }
326 
327     /**
328      * @dev Add a value to a set. O(1).
329      *
330      * Returns true if the value was added to the set, that is if it was not
331      * already present.
332      */
333     function add(
334         Bytes32Set storage set,
335         bytes32 value
336     ) internal returns (bool) {
337         return _add(set._inner, value);
338     }
339 
340     /**
341      * @dev Removes a value from a set. O(1).
342      *
343      * Returns true if the value was removed from the set, that is if it was
344      * present.
345      */
346     function remove(
347         Bytes32Set storage set,
348         bytes32 value
349     ) internal returns (bool) {
350         return _remove(set._inner, value);
351     }
352 
353     /**
354      * @dev Returns true if the value is in the set. O(1).
355      */
356     function contains(
357         Bytes32Set storage set,
358         bytes32 value
359     ) internal view returns (bool) {
360         return _contains(set._inner, value);
361     }
362 
363     /**
364      * @dev Returns the number of values in the set. O(1).
365      */
366     function length(Bytes32Set storage set) internal view returns (uint256) {
367         return _length(set._inner);
368     }
369 
370     /**
371      * @dev Returns the value stored at position `index` in the set. O(1).
372      *
373      * Note that there are no guarantees on the ordering of values inside the
374      * array, and it may change when more values are added or removed.
375      *
376      * Requirements:
377      *
378      * - `index` must be strictly less than {length}.
379      */
380     function at(
381         Bytes32Set storage set,
382         uint256 index
383     ) internal view returns (bytes32) {
384         return _at(set._inner, index);
385     }
386 
387     /**
388      * @dev Return the entire set in an array
389      *
390      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
391      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
392      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
393      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
394      */
395     function values(
396         Bytes32Set storage set
397     ) internal view returns (bytes32[] memory) {
398         return _values(set._inner);
399     }
400 
401     // AddressSet
402 
403     struct AddressSet {
404         Set _inner;
405     }
406 
407     /**
408      * @dev Add a value to a set. O(1).
409      *
410      * Returns true if the value was added to the set, that is if it was not
411      * already present.
412      */
413     function add(
414         AddressSet storage set,
415         address value
416     ) internal returns (bool) {
417         return _add(set._inner, bytes32(uint256(uint160(value))));
418     }
419 
420     /**
421      * @dev Removes a value from a set. O(1).
422      *
423      * Returns true if the value was removed from the set, that is if it was
424      * present.
425      */
426     function remove(
427         AddressSet storage set,
428         address value
429     ) internal returns (bool) {
430         return _remove(set._inner, bytes32(uint256(uint160(value))));
431     }
432 
433     /**
434      * @dev Returns true if the value is in the set. O(1).
435      */
436     function contains(
437         AddressSet storage set,
438         address value
439     ) internal view returns (bool) {
440         return _contains(set._inner, bytes32(uint256(uint160(value))));
441     }
442 
443     /**
444      * @dev Returns the number of values in the set. O(1).
445      */
446     function length(AddressSet storage set) internal view returns (uint256) {
447         return _length(set._inner);
448     }
449 
450     /**
451      * @dev Returns the value stored at position `index` in the set. O(1).
452      *
453      * Note that there are no guarantees on the ordering of values inside the
454      * array, and it may change when more values are added or removed.
455      *
456      * Requirements:
457      *
458      * - `index` must be strictly less than {length}.
459      */
460     function at(
461         AddressSet storage set,
462         uint256 index
463     ) internal view returns (address) {
464         return address(uint160(uint256(_at(set._inner, index))));
465     }
466 
467     /**
468      * @dev Return the entire set in an array
469      *
470      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
471      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
472      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
473      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
474      */
475     function values(
476         AddressSet storage set
477     ) internal view returns (address[] memory) {
478         bytes32[] memory store = _values(set._inner);
479         address[] memory result;
480 
481         assembly {
482             result := store
483         }
484 
485         return result;
486     }
487 
488     // UintSet
489 
490     struct UintSet {
491         Set _inner;
492     }
493 
494     /**
495      * @dev Add a value to a set. O(1).
496      *
497      * Returns true if the value was added to the set, that is if it was not
498      * already present.
499      */
500     function add(UintSet storage set, uint256 value) internal returns (bool) {
501         return _add(set._inner, bytes32(value));
502     }
503 
504     /**
505      * @dev Removes a value from a set. O(1).
506      *
507      * Returns true if the value was removed from the set, that is if it was
508      * present.
509      */
510     function remove(
511         UintSet storage set,
512         uint256 value
513     ) internal returns (bool) {
514         return _remove(set._inner, bytes32(value));
515     }
516 
517     /**
518      * @dev Returns true if the value is in the set. O(1).
519      */
520     function contains(
521         UintSet storage set,
522         uint256 value
523     ) internal view returns (bool) {
524         return _contains(set._inner, bytes32(value));
525     }
526 
527     /**
528      * @dev Returns the number of values on the set. O(1).
529      */
530     function length(UintSet storage set) internal view returns (uint256) {
531         return _length(set._inner);
532     }
533 
534     /**
535      * @dev Returns the value stored at position `index` in the set. O(1).
536      *
537      * Note that there are no guarantees on the ordering of values inside the
538      * array, and it may change when more values are added or removed.
539      *
540      * Requirements:
541      *
542      * - `index` must be strictly less than {length}.
543      */
544     function at(
545         UintSet storage set,
546         uint256 index
547     ) internal view returns (uint256) {
548         return uint256(_at(set._inner, index));
549     }
550 
551     /**
552      * @dev Return the entire set in an array
553      *
554      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
555      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
556      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
557      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
558      */
559     function values(
560         UintSet storage set
561     ) internal view returns (uint256[] memory) {
562         bytes32[] memory store = _values(set._inner);
563         uint256[] memory result;
564 
565         assembly {
566             result := store
567         }
568 
569         return result;
570     }
571 }
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Required interface of an ERC721 compliant contract.
577  */
578 interface IERC721 is IERC165 {
579     /**
580      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
581      */
582     event Transfer(
583         address indexed from,
584         address indexed to,
585         uint256 indexed tokenId
586     );
587 
588     /**
589      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
590      */
591     event Approval(
592         address indexed owner,
593         address indexed approved,
594         uint256 indexed tokenId
595     );
596 
597     /**
598      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
599      */
600     event ApprovalForAll(
601         address indexed owner,
602         address indexed operator,
603         bool approved
604     );
605 
606     /**
607      * @dev Returns the number of tokens in ``owner``'s account.
608      */
609     function balanceOf(address owner) external view returns (uint256 balance);
610 
611     /**
612      * @dev Returns the owner of the `tokenId` token.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      */
618     function ownerOf(uint256 tokenId) external view returns (address owner);
619 
620     /**
621      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
622      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Transfers `tokenId` token from `from` to `to`.
642      *
643      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must be owned by `from`.
650      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651      *
652      * Emits a {Transfer} event.
653      */
654     function transferFrom(address from, address to, uint256 tokenId) external;
655 
656     /**
657      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
658      * The approval is cleared when the token is transferred.
659      *
660      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
661      *
662      * Requirements:
663      *
664      * - The caller must own the token or be an approved operator.
665      * - `tokenId` must exist.
666      *
667      * Emits an {Approval} event.
668      */
669     function approve(address to, uint256 tokenId) external;
670 
671     /**
672      * @dev Returns the account approved for `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function getApproved(
679         uint256 tokenId
680     ) external view returns (address operator);
681 
682     /**
683      * @dev Approve or remove `operator` as an operator for the caller.
684      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
685      *
686      * Requirements:
687      *
688      * - The `operator` cannot be the caller.
689      *
690      * Emits an {ApprovalForAll} event.
691      */
692     function setApprovalForAll(address operator, bool _approved) external;
693 
694     /**
695      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
696      *
697      * See {setApprovalForAll}
698      */
699     function isApprovedForAll(
700         address owner,
701         address operator
702     ) external view returns (bool);
703 
704     /**
705      * @dev Safely transfers `tokenId` token from `from` to `to`.
706      *
707      * Requirements:
708      *
709      * - `from` cannot be the zero address.
710      * - `to` cannot be the zero address.
711      * - `tokenId` token must exist and be owned by `from`.
712      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
713      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
714      *
715      * Emits a {Transfer} event.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 tokenId,
721         bytes calldata data
722     ) external;
723 }
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
729  * @dev See https://eips.ethereum.org/EIPS/eip-721
730  */
731 interface IERC721Enumerable is IERC721 {
732     /**
733      * @dev Returns the total amount of tokens stored by the contract.
734      */
735     function totalSupply() external view returns (uint256);
736 
737     /**
738      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
739      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
740      */
741     function tokenOfOwnerByIndex(
742         address owner,
743         uint256 index
744     ) external view returns (uint256 tokenId);
745 
746     /**
747      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
748      * Use along with {totalSupply} to enumerate all tokens.
749      */
750     function tokenByIndex(uint256 index) external view returns (uint256);
751 }
752 
753 pragma solidity ^0.8.0;
754 
755 /**
756  * @title ERC721 token receiver interface
757  * @dev Interface for any contract that wants to support safeTransfers
758  * from ERC721 asset contracts.
759  */
760 interface IERC721Receiver {
761     /**
762      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
763      * by `operator` from `from`, this function is called.
764      *
765      * It must return its Solidity selector to confirm the token transfer.
766      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
767      *
768      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
769      */
770     function onERC721Received(
771         address operator,
772         address from,
773         uint256 tokenId,
774         bytes calldata data
775     ) external returns (bytes4);
776 }
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
782  * @dev See https://eips.ethereum.org/EIPS/eip-721
783  */
784 interface IERC721Metadata is IERC721 {
785     /**
786      * @dev Returns the token collection name.
787      */
788     function name() external view returns (string memory);
789 
790     /**
791      * @dev Returns the token collection symbol.
792      */
793     function symbol() external view returns (string memory);
794 
795     /**
796      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
797      */
798     function tokenURI(uint256 tokenId) external view returns (string memory);
799 }
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @dev Collection of functions related to the address type
805  */
806 library Address {
807     /**
808      * @dev Returns true if `account` is a contract.
809      *
810      * [IMPORTANT]
811      * ====
812      * It is unsafe to assume that an address for which this function returns
813      * false is an externally-owned account (EOA) and not a contract.
814      *
815      * Among others, `isContract` will return false for the following
816      * types of addresses:
817      *
818      *  - an externally-owned account
819      *  - a contract in construction
820      *  - an address where a contract will be created
821      *  - an address where a contract lived, but was destroyed
822      * ====
823      */
824     function isContract(address account) internal view returns (bool) {
825         // This method relies on extcodesize, which returns 0 for contracts in
826         // construction, since the code is only stored at the end of the
827         // constructor execution.
828 
829         uint256 size;
830         assembly {
831             size := extcodesize(account)
832         }
833         return size > 0;
834     }
835 
836     /**
837      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
838      * `recipient`, forwarding all available gas and reverting on errors.
839      *
840      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
841      * of certain opcodes, possibly making contracts go over the 2300 gas limit
842      * imposed by `transfer`, making them unable to receive funds via
843      * `transfer`. {sendValue} removes this limitation.
844      *
845      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
846      *
847      * IMPORTANT: because control is transferred to `recipient`, care must be
848      * taken to not create reentrancy vulnerabilities. Consider using
849      * {ReentrancyGuard} or the
850      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
851      */
852     function sendValue(address payable recipient, uint256 amount) internal {
853         require(
854             address(this).balance >= amount,
855             "Address: insufficient balance"
856         );
857 
858         (bool success, ) = recipient.call{value: amount}("");
859         require(
860             success,
861             "Address: unable to send value, recipient may have reverted"
862         );
863     }
864 
865     /**
866      * @dev Performs a Solidity function call using a low level `call`. A
867      * plain `call` is an unsafe replacement for a function call: use this
868      * function instead.
869      *
870      * If `target` reverts with a revert reason, it is bubbled up by this
871      * function (like regular Solidity function calls).
872      *
873      * Returns the raw returned data. To convert to the expected return value,
874      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
875      *
876      * Requirements:
877      *
878      * - `target` must be a contract.
879      * - calling `target` with `data` must not revert.
880      *
881      * _Available since v3.1._
882      */
883     function functionCall(
884         address target,
885         bytes memory data
886     ) internal returns (bytes memory) {
887         return functionCall(target, data, "Address: low-level call failed");
888     }
889 
890     /**
891      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
892      * `errorMessage` as a fallback revert reason when `target` reverts.
893      *
894      * _Available since v3.1._
895      */
896     function functionCall(
897         address target,
898         bytes memory data,
899         string memory errorMessage
900     ) internal returns (bytes memory) {
901         return functionCallWithValue(target, data, 0, errorMessage);
902     }
903 
904     /**
905      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
906      * but also transferring `value` wei to `target`.
907      *
908      * Requirements:
909      *
910      * - the calling contract must have an ETH balance of at least `value`.
911      * - the called Solidity function must be `payable`.
912      *
913      * _Available since v3.1._
914      */
915     function functionCallWithValue(
916         address target,
917         bytes memory data,
918         uint256 value
919     ) internal returns (bytes memory) {
920         return
921             functionCallWithValue(
922                 target,
923                 data,
924                 value,
925                 "Address: low-level call with value failed"
926             );
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
931      * with `errorMessage` as a fallback revert reason when `target` reverts.
932      *
933      * _Available since v3.1._
934      */
935     function functionCallWithValue(
936         address target,
937         bytes memory data,
938         uint256 value,
939         string memory errorMessage
940     ) internal returns (bytes memory) {
941         require(
942             address(this).balance >= value,
943             "Address: insufficient balance for call"
944         );
945         require(isContract(target), "Address: call to non-contract");
946 
947         (bool success, bytes memory returndata) = target.call{value: value}(
948             data
949         );
950         return verifyCallResult(success, returndata, errorMessage);
951     }
952 
953     /**
954      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
955      * but performing a static call.
956      *
957      * _Available since v3.3._
958      */
959     function functionStaticCall(
960         address target,
961         bytes memory data
962     ) internal view returns (bytes memory) {
963         return
964             functionStaticCall(
965                 target,
966                 data,
967                 "Address: low-level static call failed"
968             );
969     }
970 
971     /**
972      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
973      * but performing a static call.
974      *
975      * _Available since v3.3._
976      */
977     function functionStaticCall(
978         address target,
979         bytes memory data,
980         string memory errorMessage
981     ) internal view returns (bytes memory) {
982         require(isContract(target), "Address: static call to non-contract");
983 
984         (bool success, bytes memory returndata) = target.staticcall(data);
985         return verifyCallResult(success, returndata, errorMessage);
986     }
987 
988     /**
989      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
990      * but performing a delegate call.
991      *
992      * _Available since v3.4._
993      */
994     function functionDelegateCall(
995         address target,
996         bytes memory data
997     ) internal returns (bytes memory) {
998         return
999             functionDelegateCall(
1000                 target,
1001                 data,
1002                 "Address: low-level delegate call failed"
1003             );
1004     }
1005 
1006     /**
1007      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1008      * but performing a delegate call.
1009      *
1010      * _Available since v3.4._
1011      */
1012     function functionDelegateCall(
1013         address target,
1014         bytes memory data,
1015         string memory errorMessage
1016     ) internal returns (bytes memory) {
1017         require(isContract(target), "Address: delegate call to non-contract");
1018 
1019         (bool success, bytes memory returndata) = target.delegatecall(data);
1020         return verifyCallResult(success, returndata, errorMessage);
1021     }
1022 
1023     /**
1024      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1025      * revert reason using the provided one.
1026      *
1027      * _Available since v4.3._
1028      */
1029     function verifyCallResult(
1030         bool success,
1031         bytes memory returndata,
1032         string memory errorMessage
1033     ) internal pure returns (bytes memory) {
1034         if (success) {
1035             return returndata;
1036         } else {
1037             // Look for revert reason and bubble it up if present
1038             if (returndata.length > 0) {
1039                 // The easiest way to bubble the revert reason is using memory via assembly
1040 
1041                 assembly {
1042                     let returndata_size := mload(returndata)
1043                     revert(add(32, returndata), returndata_size)
1044                 }
1045             } else {
1046                 revert(errorMessage);
1047             }
1048         }
1049     }
1050 }
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 /**
1055  * @dev Provides information about the current execution context, including the
1056  * sender of the transaction and its data. While these are generally available
1057  * via msg.sender and msg.data, they should not be accessed in such a direct
1058  * manner, since when dealing with meta-transactions the account sending and
1059  * paying for execution may not be the actual sender (as far as an application
1060  * is concerned).
1061  *
1062  * This contract is only required for intermediate, library-like contracts.
1063  */
1064 abstract contract Context {
1065     function _msgSender() internal view virtual returns (address) {
1066         return msg.sender;
1067     }
1068 
1069     function _msgData() internal view virtual returns (bytes calldata) {
1070         return msg.data;
1071     }
1072 }
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 /**
1077  * @dev String operations.
1078  */
1079 library Strings {
1080     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1081 
1082     /**
1083      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1084      */
1085     function toString(uint256 value) internal pure returns (string memory) {
1086         // Inspired by OraclizeAPI's implementation - MIT licence
1087         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1088 
1089         if (value == 0) {
1090             return "0";
1091         }
1092         uint256 temp = value;
1093         uint256 digits;
1094         while (temp != 0) {
1095             digits++;
1096             temp /= 10;
1097         }
1098         bytes memory buffer = new bytes(digits);
1099         while (value != 0) {
1100             digits -= 1;
1101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1102             value /= 10;
1103         }
1104         return string(buffer);
1105     }
1106 
1107     /**
1108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1109      */
1110     function toHexString(uint256 value) internal pure returns (string memory) {
1111         if (value == 0) {
1112             return "0x00";
1113         }
1114         uint256 temp = value;
1115         uint256 length = 0;
1116         while (temp != 0) {
1117             length++;
1118             temp >>= 8;
1119         }
1120         return toHexString(value, length);
1121     }
1122 
1123     /**
1124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1125      */
1126     function toHexString(
1127         uint256 value,
1128         uint256 length
1129     ) internal pure returns (string memory) {
1130         bytes memory buffer = new bytes(2 * length + 2);
1131         buffer[0] = "0";
1132         buffer[1] = "x";
1133         for (uint256 i = 2 * length + 1; i > 1; --i) {
1134             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1135             value >>= 4;
1136         }
1137         require(value == 0, "Strings: hex length insufficient");
1138         return string(buffer);
1139     }
1140 }
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 /**
1145  * @dev Implementation of the {IERC165} interface.
1146  *
1147  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1148  * for the additional interface id that will be supported. For example:
1149  *
1150  * ```solidity
1151  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1152  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1153  * }
1154  * ```
1155  *
1156  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1157  */
1158 abstract contract ERC165 is IERC165 {
1159     /**
1160      * @dev See {IERC165-supportsInterface}.
1161      */
1162     function supportsInterface(
1163         bytes4 interfaceId
1164     ) public view virtual override returns (bool) {
1165         return interfaceId == type(IERC165).interfaceId;
1166     }
1167 }
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 /**
1172  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1173  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1174  * {ERC721Enumerable}.
1175  */
1176 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1177     using Address for address;
1178     using Strings for uint256;
1179 
1180     // Token name
1181     string private _name;
1182 
1183     // Token symbol
1184     string private _symbol;
1185 
1186     // Mapping from token ID to owner address
1187     mapping(uint256 => address) private _owners;
1188 
1189     // Mapping owner address to token count
1190     mapping(address => uint256) private _balances;
1191 
1192     // Mapping from token ID to approved address
1193     mapping(uint256 => address) private _tokenApprovals;
1194 
1195     // Mapping from owner to operator approvals
1196     mapping(address => mapping(address => bool)) private _operatorApprovals;
1197 
1198     /**
1199      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1200      */
1201     constructor(string memory name_, string memory symbol_) {
1202         _name = name_;
1203         _symbol = symbol_;
1204     }
1205 
1206     /**
1207      * @dev See {IERC165-supportsInterface}.
1208      */
1209     function supportsInterface(
1210         bytes4 interfaceId
1211     ) public view virtual override(ERC165, IERC165) returns (bool) {
1212         return
1213             interfaceId == type(IERC721).interfaceId ||
1214             interfaceId == type(IERC721Metadata).interfaceId ||
1215             super.supportsInterface(interfaceId);
1216     }
1217 
1218     /**
1219      * @dev See {IERC721-balanceOf}.
1220      */
1221     function balanceOf(
1222         address owner
1223     ) public view virtual override returns (uint256) {
1224         require(
1225             owner != address(0),
1226             "ERC721: balance query for the zero address"
1227         );
1228         return _balances[owner];
1229     }
1230 
1231     /**
1232      * @dev See {IERC721-ownerOf}.
1233      */
1234     function ownerOf(
1235         uint256 tokenId
1236     ) public view virtual override returns (address) {
1237         address owner = _owners[tokenId];
1238         require(
1239             owner != address(0),
1240             "ERC721: owner query for nonexistent token"
1241         );
1242         return owner;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-name}.
1247      */
1248     function name() public view virtual override returns (string memory) {
1249         return _name;
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Metadata-symbol}.
1254      */
1255     function symbol() public view virtual override returns (string memory) {
1256         return _symbol;
1257     }
1258 
1259     /**
1260      * @dev See {IERC721Metadata-tokenURI}.
1261      */
1262     function tokenURI(
1263         uint256 tokenId
1264     ) public view virtual override returns (string memory) {
1265         require(
1266             _exists(tokenId),
1267             "ERC721Metadata: URI query for nonexistent token"
1268         );
1269 
1270         string memory baseURI = _baseURI();
1271         return
1272             bytes(baseURI).length > 0
1273                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1274                 : "";
1275     }
1276 
1277     /**
1278      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1279      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1280      * by default, can be overriden in child contracts.
1281      */
1282     function _baseURI() internal view virtual returns (string memory) {
1283         return "";
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-approve}.
1288      */
1289     function approve(address to, uint256 tokenId) public virtual override {
1290         address owner = ERC721.ownerOf(tokenId);
1291         require(to != owner, "ERC721: approval to current owner");
1292 
1293         require(
1294             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1295             "ERC721: approve caller is not owner nor approved for all"
1296         );
1297 
1298         _approve(to, tokenId);
1299     }
1300 
1301     /**
1302      * @dev See {IERC721-getApproved}.
1303      */
1304     function getApproved(
1305         uint256 tokenId
1306     ) public view virtual override returns (address) {
1307         require(
1308             _exists(tokenId),
1309             "ERC721: approved query for nonexistent token"
1310         );
1311 
1312         return _tokenApprovals[tokenId];
1313     }
1314 
1315     /**
1316      * @dev See {IERC721-setApprovalForAll}.
1317      */
1318     function setApprovalForAll(
1319         address operator,
1320         bool approved
1321     ) public virtual override {
1322         _setApprovalForAll(_msgSender(), operator, approved);
1323     }
1324 
1325     /**
1326      * @dev See {IERC721-isApprovedForAll}.
1327      */
1328     function isApprovedForAll(
1329         address owner,
1330         address operator
1331     ) public view virtual override returns (bool) {
1332         return _operatorApprovals[owner][operator];
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-transferFrom}.
1337      */
1338     function transferFrom(
1339         address from,
1340         address to,
1341         uint256 tokenId
1342     ) public virtual override {
1343         //solhint-disable-next-line max-line-length
1344         require(
1345             _isApprovedOrOwner(_msgSender(), tokenId),
1346             "ERC721: transfer caller is not owner nor approved"
1347         );
1348 
1349         _transfer(from, to, tokenId);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-safeTransferFrom}.
1354      */
1355     function safeTransferFrom(
1356         address from,
1357         address to,
1358         uint256 tokenId
1359     ) public virtual override {
1360         safeTransferFrom(from, to, tokenId, "");
1361     }
1362 
1363     /**
1364      * @dev See {IERC721-safeTransferFrom}.
1365      */
1366     function safeTransferFrom(
1367         address from,
1368         address to,
1369         uint256 tokenId,
1370         bytes memory _data
1371     ) public virtual override {
1372         require(
1373             _isApprovedOrOwner(_msgSender(), tokenId),
1374             "ERC721: transfer caller is not owner nor approved"
1375         );
1376         _safeTransfer(from, to, tokenId, _data);
1377     }
1378 
1379     /**
1380      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1381      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1382      *
1383      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1384      *
1385      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1386      * implement alternative mechanisms to perform token transfer, such as signature-based.
1387      *
1388      * Requirements:
1389      *
1390      * - `from` cannot be the zero address.
1391      * - `to` cannot be the zero address.
1392      * - `tokenId` token must exist and be owned by `from`.
1393      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function _safeTransfer(
1398         address from,
1399         address to,
1400         uint256 tokenId,
1401         bytes memory _data
1402     ) internal virtual {
1403         _transfer(from, to, tokenId);
1404         require(
1405             _checkOnERC721Received(from, to, tokenId, _data),
1406             "ERC721: transfer to non ERC721Receiver implementer"
1407         );
1408     }
1409 
1410     /**
1411      * @dev Returns whether `tokenId` exists.
1412      *
1413      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1414      *
1415      * Tokens start existing when they are minted (`_mint`),
1416      * and stop existing when they are burned (`_burn`).
1417      */
1418     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1419         return _owners[tokenId] != address(0);
1420     }
1421 
1422     /**
1423      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1424      *
1425      * Requirements:
1426      *
1427      * - `tokenId` must exist.
1428      */
1429     function _isApprovedOrOwner(
1430         address spender,
1431         uint256 tokenId
1432     ) internal view virtual returns (bool) {
1433         require(
1434             _exists(tokenId),
1435             "ERC721: operator query for nonexistent token"
1436         );
1437         address owner = ERC721.ownerOf(tokenId);
1438         return (spender == owner ||
1439             getApproved(tokenId) == spender ||
1440             isApprovedForAll(owner, spender));
1441     }
1442 
1443     /**
1444      * @dev Safely mints `tokenId` and transfers it to `to`.
1445      *
1446      * Requirements:
1447      *
1448      * - `tokenId` must not exist.
1449      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1450      *
1451      * Emits a {Transfer} event.
1452      */
1453     function _safeMint(address to, uint256 tokenId) internal virtual {
1454         _safeMint(to, tokenId, "");
1455     }
1456 
1457     /**
1458      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1459      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1460      */
1461     function _safeMint(
1462         address to,
1463         uint256 tokenId,
1464         bytes memory _data
1465     ) internal virtual {
1466         _mint(to, tokenId);
1467         require(
1468             _checkOnERC721Received(address(0), to, tokenId, _data),
1469             "ERC721: transfer to non ERC721Receiver implementer"
1470         );
1471     }
1472 
1473     /**
1474      * @dev Mints `tokenId` and transfers it to `to`.
1475      *
1476      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1477      *
1478      * Requirements:
1479      *
1480      * - `tokenId` must not exist.
1481      * - `to` cannot be the zero address.
1482      *
1483      * Emits a {Transfer} event.
1484      */
1485     function _mint(address to, uint256 tokenId) internal virtual {
1486         require(to != address(0), "ERC721: mint to the zero address");
1487         require(!_exists(tokenId), "ERC721: token already minted");
1488 
1489         _beforeTokenTransfer(address(0), to, tokenId);
1490 
1491         _balances[to] += 1;
1492         _owners[tokenId] = to;
1493 
1494         emit Transfer(address(0), to, tokenId);
1495     }
1496 
1497     /**
1498      * @dev Destroys `tokenId`.
1499      * The approval is cleared when the token is burned.
1500      *
1501      * Requirements:
1502      *
1503      * - `tokenId` must exist.
1504      *
1505      * Emits a {Transfer} event.
1506      */
1507     function _burn(uint256 tokenId) internal virtual {
1508         address owner = ERC721.ownerOf(tokenId);
1509 
1510         _beforeTokenTransfer(owner, address(0), tokenId);
1511 
1512         // Clear approvals
1513         _approve(address(0), tokenId);
1514 
1515         _balances[owner] -= 1;
1516         delete _owners[tokenId];
1517 
1518         emit Transfer(owner, address(0), tokenId);
1519     }
1520 
1521     /**
1522      * @dev Transfers `tokenId` from `from` to `to`.
1523      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1524      *
1525      * Requirements:
1526      *
1527      * - `to` cannot be the zero address.
1528      * - `tokenId` token must be owned by `from`.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function _transfer(
1533         address from,
1534         address to,
1535         uint256 tokenId
1536     ) internal virtual {
1537         require(
1538             ERC721.ownerOf(tokenId) == from,
1539             "ERC721: transfer of token that is not own"
1540         );
1541         require(to != address(0), "ERC721: transfer to the zero address");
1542 
1543         _beforeTokenTransfer(from, to, tokenId);
1544 
1545         // Clear approvals from the previous owner
1546         _approve(address(0), tokenId);
1547 
1548         _balances[from] -= 1;
1549         _balances[to] += 1;
1550         _owners[tokenId] = to;
1551 
1552         emit Transfer(from, to, tokenId);
1553     }
1554 
1555     /**
1556      * @dev Approve `to` to operate on `tokenId`
1557      *
1558      * Emits a {Approval} event.
1559      */
1560     function _approve(address to, uint256 tokenId) internal virtual {
1561         _tokenApprovals[tokenId] = to;
1562         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev Approve `operator` to operate on all of `owner` tokens
1567      *
1568      * Emits a {ApprovalForAll} event.
1569      */
1570     function _setApprovalForAll(
1571         address owner,
1572         address operator,
1573         bool approved
1574     ) internal virtual {
1575         require(owner != operator, "ERC721: approve to caller");
1576         _operatorApprovals[owner][operator] = approved;
1577         emit ApprovalForAll(owner, operator, approved);
1578     }
1579 
1580     /**
1581      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1582      * The call is not executed if the target address is not a contract.
1583      *
1584      * @param from address representing the previous owner of the given token ID
1585      * @param to target address that will receive the tokens
1586      * @param tokenId uint256 ID of the token to be transferred
1587      * @param _data bytes optional data to send along with the call
1588      * @return bool whether the call correctly returned the expected magic value
1589      */
1590     function _checkOnERC721Received(
1591         address from,
1592         address to,
1593         uint256 tokenId,
1594         bytes memory _data
1595     ) private returns (bool) {
1596         if (to.isContract()) {
1597             try
1598                 IERC721Receiver(to).onERC721Received(
1599                     _msgSender(),
1600                     from,
1601                     tokenId,
1602                     _data
1603                 )
1604             returns (bytes4 retval) {
1605                 return retval == IERC721Receiver.onERC721Received.selector;
1606             } catch (bytes memory reason) {
1607                 if (reason.length == 0) {
1608                     revert(
1609                         "ERC721: transfer to non ERC721Receiver implementer"
1610                     );
1611                 } else {
1612                     assembly {
1613                         revert(add(32, reason), mload(reason))
1614                     }
1615                 }
1616             }
1617         } else {
1618             return true;
1619         }
1620     }
1621 
1622     /**
1623      * @dev Hook that is called before any token transfer. This includes minting
1624      * and burning.
1625      *
1626      * Calling conditions:
1627      *
1628      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1629      * transferred to `to`.
1630      * - When `from` is zero, `tokenId` will be minted for `to`.
1631      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1632      * - `from` and `to` are never both zero.
1633      *
1634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1635      */
1636     function _beforeTokenTransfer(
1637         address from,
1638         address to,
1639         uint256 tokenId
1640     ) internal virtual {}
1641 }
1642 
1643 pragma solidity ^0.8.0;
1644 
1645 /**
1646  * @dev Contract module that allows children to implement role-based access
1647  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1648  * members except through off-chain means by accessing the contract event logs. Some
1649  * applications may benefit from on-chain enumerability, for those cases see
1650  * {AccessControlEnumerable}.
1651  *
1652  * Roles are referred to by their `bytes32` identifier. These should be exposed
1653  * in the external API and be unique. The best way to achieve this is by
1654  * using `public constant` hash digests:
1655  *
1656  * ```
1657  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1658  * ```
1659  *
1660  * Roles can be used to represent a set of permissions. To restrict access to a
1661  * function call, use {hasRole}:
1662  *
1663  * ```
1664  * function foo() public {
1665  *     require(hasRole(MY_ROLE, msg.sender));
1666  *     ...
1667  * }
1668  * ```
1669  *
1670  * Roles can be granted and revoked dynamically via the {grantRole} and
1671  * {revokeRole} functions. Each role has an associated admin role, and only
1672  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1673  *
1674  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1675  * that only accounts with this role will be able to grant or revoke other
1676  * roles. More complex role relationships can be created by using
1677  * {_setRoleAdmin}.
1678  *
1679  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1680  * grant and revoke this role. Extra precautions should be taken to secure
1681  * accounts that have been granted it.
1682  */
1683 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1684     struct RoleData {
1685         mapping(address => bool) members;
1686         bytes32 adminRole;
1687     }
1688 
1689     mapping(bytes32 => RoleData) private _roles;
1690 
1691     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1692 
1693     /**
1694      * @dev Modifier that checks that an account has a specific role. Reverts
1695      * with a standardized message including the required role.
1696      *
1697      * The format of the revert reason is given by the following regular expression:
1698      *
1699      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1700      *
1701      * _Available since v4.1._
1702      */
1703     modifier onlyRole(bytes32 role) {
1704         _checkRole(role, _msgSender());
1705         _;
1706     }
1707 
1708     /**
1709      * @dev See {IERC165-supportsInterface}.
1710      */
1711     function supportsInterface(
1712         bytes4 interfaceId
1713     ) public view virtual override returns (bool) {
1714         return
1715             interfaceId == type(IAccessControl).interfaceId ||
1716             super.supportsInterface(interfaceId);
1717     }
1718 
1719     /**
1720      * @dev Returns `true` if `account` has been granted `role`.
1721      */
1722     function hasRole(
1723         bytes32 role,
1724         address account
1725     ) public view virtual override returns (bool) {
1726         return _roles[role].members[account];
1727     }
1728 
1729     /**
1730      * @dev Revert with a standard message if `account` is missing `role`.
1731      *
1732      * The format of the revert reason is given by the following regular expression:
1733      *
1734      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1735      */
1736     function _checkRole(bytes32 role, address account) internal view virtual {
1737         if (!hasRole(role, account)) {
1738             revert(
1739                 string(
1740                     abi.encodePacked(
1741                         "AccessControl: account ",
1742                         Strings.toHexString(uint160(account), 20),
1743                         " is missing role ",
1744                         Strings.toHexString(uint256(role), 32)
1745                     )
1746                 )
1747             );
1748         }
1749     }
1750 
1751     /**
1752      * @dev Returns the admin role that controls `role`. See {grantRole} and
1753      * {revokeRole}.
1754      *
1755      * To change a role's admin, use {_setRoleAdmin}.
1756      */
1757     function getRoleAdmin(
1758         bytes32 role
1759     ) public view virtual override returns (bytes32) {
1760         return _roles[role].adminRole;
1761     }
1762 
1763     /**
1764      * @dev Grants `role` to `account`.
1765      *
1766      * If `account` had not been already granted `role`, emits a {RoleGranted}
1767      * event.
1768      *
1769      * Requirements:
1770      *
1771      * - the caller must have ``role``'s admin role.
1772      */
1773     function grantRole(
1774         bytes32 role,
1775         address account
1776     ) public virtual override onlyRole(getRoleAdmin(role)) {
1777         _grantRole(role, account);
1778     }
1779 
1780     /**
1781      * @dev Revokes `role` from `account`.
1782      *
1783      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1784      *
1785      * Requirements:
1786      *
1787      * - the caller must have ``role``'s admin role.
1788      */
1789     function revokeRole(
1790         bytes32 role,
1791         address account
1792     ) public virtual override onlyRole(getRoleAdmin(role)) {
1793         _revokeRole(role, account);
1794     }
1795 
1796     /**
1797      * @dev Revokes `role` from the calling account.
1798      *
1799      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1800      * purpose is to provide a mechanism for accounts to lose their privileges
1801      * if they are compromised (such as when a trusted device is misplaced).
1802      *
1803      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1804      * event.
1805      *
1806      * Requirements:
1807      *
1808      * - the caller must be `account`.
1809      */
1810     function renounceRole(
1811         bytes32 role,
1812         address account
1813     ) public virtual override {
1814         require(
1815             account == _msgSender(),
1816             "AccessControl: can only renounce roles for self"
1817         );
1818 
1819         _revokeRole(role, account);
1820     }
1821 
1822     /**
1823      * @dev Grants `role` to `account`.
1824      *
1825      * If `account` had not been already granted `role`, emits a {RoleGranted}
1826      * event. Note that unlike {grantRole}, this function doesn't perform any
1827      * checks on the calling account.
1828      *
1829      * [WARNING]
1830      * ====
1831      * This function should only be called from the constructor when setting
1832      * up the initial roles for the system.
1833      *
1834      * Using this function in any other way is effectively circumventing the admin
1835      * system imposed by {AccessControl}.
1836      * ====
1837      *
1838      * NOTE: This function is deprecated in favor of {_grantRole}.
1839      */
1840     function _setupRole(bytes32 role, address account) internal virtual {
1841         _grantRole(role, account);
1842     }
1843 
1844     /**
1845      * @dev Sets `adminRole` as ``role``'s admin role.
1846      *
1847      * Emits a {RoleAdminChanged} event.
1848      */
1849     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1850         bytes32 previousAdminRole = getRoleAdmin(role);
1851         _roles[role].adminRole = adminRole;
1852         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1853     }
1854 
1855     /**
1856      * @dev Grants `role` to `account`.
1857      *
1858      * Internal function without access restriction.
1859      */
1860     function _grantRole(bytes32 role, address account) internal virtual {
1861         if (!hasRole(role, account)) {
1862             _roles[role].members[account] = true;
1863             emit RoleGranted(role, account, _msgSender());
1864         }
1865     }
1866 
1867     /**
1868      * @dev Revokes `role` from `account`.
1869      *
1870      * Internal function without access restriction.
1871      */
1872     function _revokeRole(bytes32 role, address account) internal virtual {
1873         if (hasRole(role, account)) {
1874             _roles[role].members[account] = false;
1875             emit RoleRevoked(role, account, _msgSender());
1876         }
1877     }
1878 }
1879 
1880 pragma solidity ^0.8.0;
1881 
1882 /**
1883  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1884  * enumerability of all the token ids in the contract as well as all token ids owned by each
1885  * account.
1886  */
1887 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1888     // Mapping from owner to list of owned token IDs
1889     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1890 
1891     // Mapping from token ID to index of the owner tokens list
1892     mapping(uint256 => uint256) private _ownedTokensIndex;
1893 
1894     // Array with all token ids, used for enumeration
1895     uint256[] private _allTokens;
1896 
1897     // Mapping from token id to position in the allTokens array
1898     mapping(uint256 => uint256) private _allTokensIndex;
1899 
1900     /**
1901      * @dev See {IERC165-supportsInterface}.
1902      */
1903     function supportsInterface(
1904         bytes4 interfaceId
1905     ) public view virtual override(IERC165, ERC721) returns (bool) {
1906         return
1907             interfaceId == type(IERC721Enumerable).interfaceId ||
1908             super.supportsInterface(interfaceId);
1909     }
1910 
1911     /**
1912      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1913      */
1914     function tokenOfOwnerByIndex(
1915         address owner,
1916         uint256 index
1917     ) public view virtual override returns (uint256) {
1918         require(
1919             index < ERC721.balanceOf(owner),
1920             "ERC721Enumerable: owner index out of bounds"
1921         );
1922         return _ownedTokens[owner][index];
1923     }
1924 
1925     /**
1926      * @dev See {IERC721Enumerable-totalSupply}.
1927      */
1928     function totalSupply() public view virtual override returns (uint256) {
1929         return _allTokens.length;
1930     }
1931 
1932     /**
1933      * @dev See {IERC721Enumerable-tokenByIndex}.
1934      */
1935     function tokenByIndex(
1936         uint256 index
1937     ) public view virtual override returns (uint256) {
1938         require(
1939             index < ERC721Enumerable.totalSupply(),
1940             "ERC721Enumerable: global index out of bounds"
1941         );
1942         return _allTokens[index];
1943     }
1944 
1945     /**
1946      * @dev Hook that is called before any token transfer. This includes minting
1947      * and burning.
1948      *
1949      * Calling conditions:
1950      *
1951      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1952      * transferred to `to`.
1953      * - When `from` is zero, `tokenId` will be minted for `to`.
1954      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1955      * - `from` cannot be the zero address.
1956      * - `to` cannot be the zero address.
1957      *
1958      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1959      */
1960     function _beforeTokenTransfer(
1961         address from,
1962         address to,
1963         uint256 tokenId
1964     ) internal virtual override {
1965         super._beforeTokenTransfer(from, to, tokenId);
1966 
1967         if (from == address(0)) {
1968             _addTokenToAllTokensEnumeration(tokenId);
1969         } else if (from != to) {
1970             _removeTokenFromOwnerEnumeration(from, tokenId);
1971         }
1972         if (to == address(0)) {
1973             _removeTokenFromAllTokensEnumeration(tokenId);
1974         } else if (to != from) {
1975             _addTokenToOwnerEnumeration(to, tokenId);
1976         }
1977     }
1978 
1979     /**
1980      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1981      * @param to address representing the new owner of the given token ID
1982      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1983      */
1984     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1985         uint256 length = ERC721.balanceOf(to);
1986         _ownedTokens[to][length] = tokenId;
1987         _ownedTokensIndex[tokenId] = length;
1988     }
1989 
1990     /**
1991      * @dev Private function to add a token to this extension's token tracking data structures.
1992      * @param tokenId uint256 ID of the token to be added to the tokens list
1993      */
1994     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1995         _allTokensIndex[tokenId] = _allTokens.length;
1996         _allTokens.push(tokenId);
1997     }
1998 
1999     /**
2000      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2001      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2002      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2003      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2004      * @param from address representing the previous owner of the given token ID
2005      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2006      */
2007     function _removeTokenFromOwnerEnumeration(
2008         address from,
2009         uint256 tokenId
2010     ) private {
2011         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2012         // then delete the last slot (swap and pop).
2013 
2014         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2015         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2016 
2017         // When the token to delete is the last token, the swap operation is unnecessary
2018         if (tokenIndex != lastTokenIndex) {
2019             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2020 
2021             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2022             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2023         }
2024 
2025         // This also deletes the contents at the last position of the array
2026         delete _ownedTokensIndex[tokenId];
2027         delete _ownedTokens[from][lastTokenIndex];
2028     }
2029 
2030     /**
2031      * @dev Private function to remove a token from this extension's token tracking data structures.
2032      * This has O(1) time complexity, but alters the order of the _allTokens array.
2033      * @param tokenId uint256 ID of the token to be removed from the tokens list
2034      */
2035     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2036         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2037         // then delete the last slot (swap and pop).
2038 
2039         uint256 lastTokenIndex = _allTokens.length - 1;
2040         uint256 tokenIndex = _allTokensIndex[tokenId];
2041 
2042         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2043         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2044         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2045         uint256 lastTokenId = _allTokens[lastTokenIndex];
2046 
2047         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2048         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2049 
2050         // This also deletes the contents at the last position of the array
2051         delete _allTokensIndex[tokenId];
2052         _allTokens.pop();
2053     }
2054 }
2055 
2056 pragma solidity ^0.8.0;
2057 
2058 /**
2059  * @dev Contract module which provides a basic access control mechanism, where
2060  * there is an account (an owner) that can be granted exclusive access to
2061  * specific functions.
2062  *
2063  * By default, the owner account will be the one that deploys the contract. This
2064  * can later be changed with {transferOwnership}.
2065  *
2066  * This module is used through inheritance. It will make available the modifier
2067  * `onlyOwner`, which can be applied to your functions to restrict their use to
2068  * the owner.
2069  */
2070 abstract contract Ownable is Context {
2071     address private _owner;
2072 
2073     event OwnershipTransferred(
2074         address indexed previousOwner,
2075         address indexed newOwner
2076     );
2077 
2078     /**
2079      * @dev Initializes the contract setting the deployer as the initial owner.
2080      */
2081     constructor() {
2082         _transferOwnership(_msgSender());
2083     }
2084 
2085     /**
2086      * @dev Returns the address of the current owner.
2087      */
2088     function owner() public view virtual returns (address) {
2089         return _owner;
2090     }
2091 
2092     /**
2093      * @dev Throws if called by any account other than the owner.
2094      */
2095     modifier onlyOwner() {
2096         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2097         _;
2098     }
2099 
2100     /**
2101      * @dev Leaves the contract without owner. It will not be possible to call
2102      * `onlyOwner` functions anymore. Can only be called by the current owner.
2103      *
2104      * NOTE: Renouncing ownership will leave the contract without an owner,
2105      * thereby removing any functionality that is only available to the owner.
2106      */
2107     function renounceOwnership() public virtual onlyOwner {
2108         _transferOwnership(address(0));
2109     }
2110 
2111     /**
2112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2113      * Can only be called by the current owner.
2114      */
2115     function transferOwnership(address newOwner) public virtual onlyOwner {
2116         require(
2117             newOwner != address(0),
2118             "Ownable: new owner is the zero address"
2119         );
2120         _transferOwnership(newOwner);
2121     }
2122 
2123     /**
2124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2125      * Internal function without access restriction.
2126      */
2127     function _transferOwnership(address newOwner) internal virtual {
2128         address oldOwner = _owner;
2129         _owner = newOwner;
2130         emit OwnershipTransferred(oldOwner, newOwner);
2131     }
2132 }
2133 
2134 pragma solidity ^0.8.0;
2135 
2136 /**
2137  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2138  */
2139 abstract contract AccessControlEnumerable is
2140     IAccessControlEnumerable,
2141     AccessControl
2142 {
2143     using EnumerableSet for EnumerableSet.AddressSet;
2144 
2145     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2146 
2147     /**
2148      * @dev See {IERC165-supportsInterface}.
2149      */
2150     function supportsInterface(
2151         bytes4 interfaceId
2152     ) public view virtual override returns (bool) {
2153         return
2154             interfaceId == type(IAccessControlEnumerable).interfaceId ||
2155             super.supportsInterface(interfaceId);
2156     }
2157 
2158     /**
2159      * @dev Returns one of the accounts that have `role`. `index` must be a
2160      * value between 0 and {getRoleMemberCount}, non-inclusive.
2161      *
2162      * Role bearers are not sorted in any particular way, and their ordering may
2163      * change at any point.
2164      *
2165      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2166      * you perform all queries on the same block. See the following
2167      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2168      * for more information.
2169      */
2170     function getRoleMember(
2171         bytes32 role,
2172         uint256 index
2173     ) public view virtual override returns (address) {
2174         return _roleMembers[role].at(index);
2175     }
2176 
2177     /**
2178      * @dev Returns the number of accounts that have `role`. Can be used
2179      * together with {getRoleMember} to enumerate all bearers of a role.
2180      */
2181     function getRoleMemberCount(
2182         bytes32 role
2183     ) public view virtual override returns (uint256) {
2184         return _roleMembers[role].length();
2185     }
2186 
2187     /**
2188      * @dev Overload {_grantRole} to track enumerable memberships
2189      */
2190     function _grantRole(
2191         bytes32 role,
2192         address account
2193     ) internal virtual override {
2194         super._grantRole(role, account);
2195         _roleMembers[role].add(account);
2196     }
2197 
2198     /**
2199      * @dev Overload {_revokeRole} to track enumerable memberships
2200      */
2201     function _revokeRole(
2202         bytes32 role,
2203         address account
2204     ) internal virtual override {
2205         super._revokeRole(role, account);
2206         _roleMembers[role].remove(account);
2207     }
2208 }
2209 
2210 pragma solidity ^0.8.0;
2211 
2212 /**
2213  * @dev Contract module that helps prevent reentrant calls to a function.
2214  *
2215  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2216  * available, which can be applied to functions to make sure there are no nested
2217  * (reentrant) calls to them.
2218  *
2219  * Note that because there is a single `nonReentrant` guard, functions marked as
2220  * `nonReentrant` may not call one another. This can be worked around by making
2221  * those functions `private`, and then adding `external` `nonReentrant` entry
2222  * points to them.
2223  *
2224  * TIP: If you would like to learn more about reentrancy and alternative ways
2225  * to protect against it, check out our blog post
2226  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2227  */
2228 abstract contract ReentrancyGuard {
2229     // Booleans are more expensive than uint256 or any type that takes up a full
2230     // word because each write operation emits an extra SLOAD to first read the
2231     // slot's contents, replace the bits taken up by the boolean, and then write
2232     // back. This is the compiler's defense against contract upgrades and
2233     // pointer aliasing, and it cannot be disabled.
2234 
2235     // The values being non-zero value makes deployment a bit more expensive,
2236     // but in exchange the refund on every call to nonReentrant will be lower in
2237     // amount. Since refunds are capped to a percentage of the total
2238     // transaction's gas, it is best to keep them low in cases like this one, to
2239     // increase the likelihood of the full refund coming into effect.
2240     uint256 private constant _NOT_ENTERED = 1;
2241     uint256 private constant _ENTERED = 2;
2242 
2243     uint256 private _status;
2244 
2245     constructor() {
2246         _status = _NOT_ENTERED;
2247     }
2248 
2249     /**
2250      * @dev Prevents a contract from calling itself, directly or indirectly.
2251      * Calling a `nonReentrant` function from another `nonReentrant`
2252      * function is not supported. It is possible to prevent this from happening
2253      * by making the `nonReentrant` function external, and making it call a
2254      * `private` function that does the actual work.
2255      */
2256     modifier nonReentrant() {
2257         // On the first call to nonReentrant, _notEntered will be true
2258         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2259 
2260         // Any calls to nonReentrant after this point will fail
2261         _status = _ENTERED;
2262 
2263         _;
2264 
2265         // By storing the original value once again, a refund is triggered (see
2266         // https://eips.ethereum.org/EIPS/eip-2200)
2267         _status = _NOT_ENTERED;
2268     }
2269 }
2270 
2271 pragma solidity ^0.8.4;
2272 
2273 error ApprovalCallerNotOwnerNorApproved();
2274 error ApprovalQueryForNonexistentToken();
2275 error ApproveToCaller();
2276 error ApprovalToCurrentOwner();
2277 error BalanceQueryForZeroAddress();
2278 error MintToZeroAddress();
2279 error MintZeroQuantity();
2280 error OwnerQueryForNonexistentToken();
2281 error TransferCallerNotOwnerNorApproved();
2282 error TransferFromIncorrectOwner();
2283 error TransferToNonERC721ReceiverImplementer();
2284 error TransferToZeroAddress();
2285 error URIQueryForNonexistentToken();
2286 
2287 /**
2288  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2289  * the Metadata extension. Built to optimize for lower gas during batch mints.
2290  *
2291  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2292  *
2293  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2294  *
2295  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2296  */
2297 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2298     using Address for address;
2299     using Strings for uint256;
2300 
2301     // Compiler will pack this into a single 256bit word.
2302     struct TokenOwnership {
2303         // The address of the owner.
2304         address addr;
2305         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2306         uint64 startTimestamp;
2307         // Whether the token has been burned.
2308         bool burned;
2309     }
2310 
2311     // Compiler will pack this into a single 256bit word.
2312     struct AddressData {
2313         // Realistically, 2**64-1 is more than enough.
2314         uint64 balance;
2315         // Keeps track of mint count with minimal overhead for tokenomics.
2316         uint64 numberMinted;
2317         // Keeps track of burn count with minimal overhead for tokenomics.
2318         uint64 numberBurned;
2319         // For miscellaneous variable(s) pertaining to the address
2320         // (e.g. number of whitelist mint slots used).
2321         // If there are multiple variables, please pack them into a uint64.
2322         uint64 aux;
2323     }
2324 
2325     // The tokenId of the next token to be minted.
2326     uint256 internal _currentIndex;
2327 
2328     // The number of tokens burned.
2329     uint256 internal _burnCounter;
2330 
2331     // Token name
2332     string private _name;
2333 
2334     // Token symbol
2335     string private _symbol;
2336 
2337     // Mapping from token ID to ownership details
2338     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2339     mapping(uint256 => TokenOwnership) internal _ownerships;
2340 
2341     // Mapping owner address to address data
2342     mapping(address => AddressData) private _addressData;
2343 
2344     // Mapping from token ID to approved address
2345     mapping(uint256 => address) private _tokenApprovals;
2346 
2347     // Mapping from owner to operator approvals
2348     mapping(address => mapping(address => bool)) private _operatorApprovals;
2349 
2350     constructor(string memory name_, string memory symbol_) {
2351         _name = name_;
2352         _symbol = symbol_;
2353         _currentIndex = _startTokenId();
2354     }
2355 
2356     /**
2357      * To change the starting tokenId, please override this function.
2358      */
2359     function _startTokenId() internal view virtual returns (uint256) {
2360         return 0;
2361     }
2362 
2363     /**
2364      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2365      */
2366     function totalSupply() public view returns (uint256) {
2367         // Counter underflow is impossible as _burnCounter cannot be incremented
2368         // more than _currentIndex - _startTokenId() times
2369         unchecked {
2370             return _currentIndex - _burnCounter - _startTokenId();
2371         }
2372     }
2373 
2374     /**
2375      * Returns the total amount of tokens minted in the contract.
2376      */
2377     function _totalMinted() internal view returns (uint256) {
2378         // Counter underflow is impossible as _currentIndex does not decrement,
2379         // and it is initialized to _startTokenId()
2380         unchecked {
2381             return _currentIndex - _startTokenId();
2382         }
2383     }
2384 
2385     /**
2386      * @dev See {IERC165-supportsInterface}.
2387      */
2388     function supportsInterface(
2389         bytes4 interfaceId
2390     ) public view virtual override(ERC165, IERC165) returns (bool) {
2391         return
2392             interfaceId == type(IERC721).interfaceId ||
2393             interfaceId == type(IERC721Metadata).interfaceId ||
2394             super.supportsInterface(interfaceId);
2395     }
2396 
2397     /**
2398      * @dev See {IERC721-balanceOf}.
2399      */
2400     function balanceOf(address owner) public view override returns (uint256) {
2401         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2402         return uint256(_addressData[owner].balance);
2403     }
2404 
2405     /**
2406      * Returns the number of tokens minted by `owner`.
2407      */
2408     function _numberMinted(address owner) internal view returns (uint256) {
2409         return uint256(_addressData[owner].numberMinted);
2410     }
2411 
2412     /**
2413      * Returns the number of tokens burned by or on behalf of `owner`.
2414      */
2415     function _numberBurned(address owner) internal view returns (uint256) {
2416         return uint256(_addressData[owner].numberBurned);
2417     }
2418 
2419     /**
2420      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2421      */
2422     function _getAux(address owner) internal view returns (uint64) {
2423         return _addressData[owner].aux;
2424     }
2425 
2426     /**
2427      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2428      * If there are multiple variables, please pack them into a uint64.
2429      */
2430     function _setAux(address owner, uint64 aux) internal {
2431         _addressData[owner].aux = aux;
2432     }
2433 
2434     /**
2435      * Gas spent here starts off proportional to the maximum mint batch size.
2436      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2437      */
2438     function _ownershipOf(
2439         uint256 tokenId
2440     ) internal view returns (TokenOwnership memory) {
2441         uint256 curr = tokenId;
2442 
2443         unchecked {
2444             if (_startTokenId() <= curr && curr < _currentIndex) {
2445                 TokenOwnership memory ownership = _ownerships[curr];
2446                 if (!ownership.burned) {
2447                     if (ownership.addr != address(0)) {
2448                         return ownership;
2449                     }
2450                     // Invariant:
2451                     // There will always be an ownership that has an address and is not burned
2452                     // before an ownership that does not have an address and is not burned.
2453                     // Hence, curr will not underflow.
2454                     while (true) {
2455                         curr--;
2456                         ownership = _ownerships[curr];
2457                         if (ownership.addr != address(0)) {
2458                             return ownership;
2459                         }
2460                     }
2461                 }
2462             }
2463         }
2464         revert OwnerQueryForNonexistentToken();
2465     }
2466 
2467     /**
2468      * @dev See {IERC721-ownerOf}.
2469      */
2470     function ownerOf(uint256 tokenId) public view override returns (address) {
2471         return _ownershipOf(tokenId).addr;
2472     }
2473 
2474     /**
2475      * @dev See {IERC721Metadata-name}.
2476      */
2477     function name() public view virtual override returns (string memory) {
2478         return _name;
2479     }
2480 
2481     /**
2482      * @dev See {IERC721Metadata-symbol}.
2483      */
2484     function symbol() public view virtual override returns (string memory) {
2485         return _symbol;
2486     }
2487 
2488     /**
2489      * @dev See {IERC721Metadata-tokenURI}.
2490      */
2491     function tokenURI(
2492         uint256 tokenId
2493     ) public view virtual override returns (string memory) {
2494         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2495 
2496         string memory baseURI = _baseURI();
2497         return
2498             bytes(baseURI).length != 0
2499                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2500                 : "";
2501     }
2502 
2503     /**
2504      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2505      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2506      * by default, can be overriden in child contracts.
2507      */
2508     function _baseURI() internal view virtual returns (string memory) {
2509         return "";
2510     }
2511 
2512     /**
2513      * @dev See {IERC721-approve}.
2514      */
2515     function approve(address to, uint256 tokenId) public virtual override {
2516         address owner = ERC721A.ownerOf(tokenId);
2517         if (to == owner) revert ApprovalToCurrentOwner();
2518 
2519         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2520             revert ApprovalCallerNotOwnerNorApproved();
2521         }
2522 
2523         _approve(to, tokenId, owner);
2524     }
2525 
2526     /**
2527      * @dev See {IERC721-getApproved}.
2528      */
2529     function getApproved(
2530         uint256 tokenId
2531     ) public view override returns (address) {
2532         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2533 
2534         return _tokenApprovals[tokenId];
2535     }
2536 
2537     /**
2538      * @dev See {IERC721-setApprovalForAll}.
2539      */
2540     function setApprovalForAll(
2541         address operator,
2542         bool approved
2543     ) public virtual override {
2544         if (operator == _msgSender()) revert ApproveToCaller();
2545 
2546         _operatorApprovals[_msgSender()][operator] = approved;
2547         emit ApprovalForAll(_msgSender(), operator, approved);
2548     }
2549 
2550     /**
2551      * @dev See {IERC721-isApprovedForAll}.
2552      */
2553     function isApprovedForAll(
2554         address owner,
2555         address operator
2556     ) public view virtual override returns (bool) {
2557         return _operatorApprovals[owner][operator];
2558     }
2559 
2560     /**
2561      * @dev See {IERC721-transferFrom}.
2562      */
2563     function transferFrom(
2564         address from,
2565         address to,
2566         uint256 tokenId
2567     ) public virtual override {
2568         _transfer(from, to, tokenId);
2569     }
2570 
2571     /**
2572      * @dev See {IERC721-safeTransferFrom}.
2573      */
2574     function safeTransferFrom(
2575         address from,
2576         address to,
2577         uint256 tokenId
2578     ) public virtual override {
2579         safeTransferFrom(from, to, tokenId, "");
2580     }
2581 
2582     /**
2583      * @dev See {IERC721-safeTransferFrom}.
2584      */
2585     function safeTransferFrom(
2586         address from,
2587         address to,
2588         uint256 tokenId,
2589         bytes memory _data
2590     ) public virtual override {
2591         _transfer(from, to, tokenId);
2592         if (
2593             to.isContract() &&
2594             !_checkContractOnERC721Received(from, to, tokenId, _data)
2595         ) {
2596             revert TransferToNonERC721ReceiverImplementer();
2597         }
2598     }
2599 
2600     /**
2601      * @dev Returns whether `tokenId` exists.
2602      *
2603      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2604      *
2605      * Tokens start existing when they are minted (`_mint`),
2606      */
2607     function _exists(uint256 tokenId) internal view returns (bool) {
2608         return
2609             _startTokenId() <= tokenId &&
2610             tokenId < _currentIndex &&
2611             !_ownerships[tokenId].burned;
2612     }
2613 
2614     function _safeMint(address to, uint256 quantity) internal {
2615         _safeMint(to, quantity, "");
2616     }
2617 
2618     /**
2619      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2620      *
2621      * Requirements:
2622      *
2623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2624      * - `quantity` must be greater than 0.
2625      *
2626      * Emits a {Transfer} event.
2627      */
2628     function _safeMint(
2629         address to,
2630         uint256 quantity,
2631         bytes memory _data
2632     ) internal {
2633         _mint(to, quantity, _data, true);
2634     }
2635 
2636     /**
2637      * @dev Mints `quantity` tokens and transfers them to `to`.
2638      *
2639      * Requirements:
2640      *
2641      * - `to` cannot be the zero address.
2642      * - `quantity` must be greater than 0.
2643      *
2644      * Emits a {Transfer} event.
2645      */
2646     function _mint(
2647         address to,
2648         uint256 quantity,
2649         bytes memory _data,
2650         bool safe
2651     ) internal {
2652         uint256 startTokenId = _currentIndex;
2653         if (to == address(0)) revert MintToZeroAddress();
2654         if (quantity == 0) revert MintZeroQuantity();
2655 
2656         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2657 
2658         // Overflows are incredibly unrealistic.
2659         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2660         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2661         unchecked {
2662             _addressData[to].balance += uint64(quantity);
2663             _addressData[to].numberMinted += uint64(quantity);
2664 
2665             _ownerships[startTokenId].addr = to;
2666             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2667 
2668             uint256 updatedIndex = startTokenId;
2669             uint256 end = updatedIndex + quantity;
2670 
2671             if (safe && to.isContract()) {
2672                 do {
2673                     emit Transfer(address(0), to, updatedIndex);
2674                     if (
2675                         !_checkContractOnERC721Received(
2676                             address(0),
2677                             to,
2678                             updatedIndex++,
2679                             _data
2680                         )
2681                     ) {
2682                         revert TransferToNonERC721ReceiverImplementer();
2683                     }
2684                 } while (updatedIndex != end);
2685                 // Reentrancy protection
2686                 if (_currentIndex != startTokenId) revert();
2687             } else {
2688                 do {
2689                     emit Transfer(address(0), to, updatedIndex++);
2690                 } while (updatedIndex != end);
2691             }
2692             _currentIndex = updatedIndex;
2693         }
2694         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2695     }
2696 
2697     /**
2698      * @dev Transfers `tokenId` from `from` to `to`.
2699      *
2700      * Requirements:
2701      *
2702      * - `to` cannot be the zero address.
2703      * - `tokenId` token must be owned by `from`.
2704      *
2705      * Emits a {Transfer} event.
2706      */
2707     function _transfer(address from, address to, uint256 tokenId) private {
2708         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2709 
2710         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2711 
2712         bool isApprovedOrOwner = (_msgSender() == from ||
2713             isApprovedForAll(from, _msgSender()) ||
2714             getApproved(tokenId) == _msgSender());
2715 
2716         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2717         if (to == address(0)) revert TransferToZeroAddress();
2718 
2719         _beforeTokenTransfers(from, to, tokenId, 1);
2720 
2721         // Clear approvals from the previous owner
2722         _approve(address(0), tokenId, from);
2723 
2724         // Underflow of the sender's balance is impossible because we check for
2725         // ownership above and the recipient's balance can't realistically overflow.
2726         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2727         unchecked {
2728             _addressData[from].balance -= 1;
2729             _addressData[to].balance += 1;
2730 
2731             TokenOwnership storage currSlot = _ownerships[tokenId];
2732             currSlot.addr = to;
2733             currSlot.startTimestamp = uint64(block.timestamp);
2734 
2735             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2736             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2737             uint256 nextTokenId = tokenId + 1;
2738             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2739             if (nextSlot.addr == address(0)) {
2740                 // This will suffice for checking _exists(nextTokenId),
2741                 // as a burned slot cannot contain the zero address.
2742                 if (nextTokenId != _currentIndex) {
2743                     nextSlot.addr = from;
2744                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2745                 }
2746             }
2747         }
2748 
2749         emit Transfer(from, to, tokenId);
2750         _afterTokenTransfers(from, to, tokenId, 1);
2751     }
2752 
2753     /**
2754      * @dev This is equivalent to _burn(tokenId, false)
2755      */
2756     function _burn(uint256 tokenId) internal virtual {
2757         _burn(tokenId, false);
2758     }
2759 
2760     /**
2761      * @dev Destroys `tokenId`.
2762      * The approval is cleared when the token is burned.
2763      *
2764      * Requirements:
2765      *
2766      * - `tokenId` must exist.
2767      *
2768      * Emits a {Transfer} event.
2769      */
2770     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2771         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2772 
2773         address from = prevOwnership.addr;
2774 
2775         if (approvalCheck) {
2776             bool isApprovedOrOwner = (_msgSender() == from ||
2777                 isApprovedForAll(from, _msgSender()) ||
2778                 getApproved(tokenId) == _msgSender());
2779 
2780             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2781         }
2782 
2783         _beforeTokenTransfers(from, address(0), tokenId, 1);
2784 
2785         // Clear approvals from the previous owner
2786         _approve(address(0), tokenId, from);
2787 
2788         // Underflow of the sender's balance is impossible because we check for
2789         // ownership above and the recipient's balance can't realistically overflow.
2790         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2791         unchecked {
2792             AddressData storage addressData = _addressData[from];
2793             addressData.balance -= 1;
2794             addressData.numberBurned += 1;
2795 
2796             // Keep track of who burned the token, and the timestamp of burning.
2797             TokenOwnership storage currSlot = _ownerships[tokenId];
2798             currSlot.addr = from;
2799             currSlot.startTimestamp = uint64(block.timestamp);
2800             currSlot.burned = true;
2801 
2802             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2803             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2804             uint256 nextTokenId = tokenId + 1;
2805             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2806             if (nextSlot.addr == address(0)) {
2807                 // This will suffice for checking _exists(nextTokenId),
2808                 // as a burned slot cannot contain the zero address.
2809                 if (nextTokenId != _currentIndex) {
2810                     nextSlot.addr = from;
2811                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2812                 }
2813             }
2814         }
2815 
2816         emit Transfer(from, address(0), tokenId);
2817         _afterTokenTransfers(from, address(0), tokenId, 1);
2818 
2819         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2820         unchecked {
2821             _burnCounter++;
2822         }
2823     }
2824 
2825     /**
2826      * @dev Approve `to` to operate on `tokenId`
2827      *
2828      * Emits a {Approval} event.
2829      */
2830     function _approve(address to, uint256 tokenId, address owner) private {
2831         _tokenApprovals[tokenId] = to;
2832         emit Approval(owner, to, tokenId);
2833     }
2834 
2835     /**
2836      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2837      *
2838      * @param from address representing the previous owner of the given token ID
2839      * @param to target address that will receive the tokens
2840      * @param tokenId uint256 ID of the token to be transferred
2841      * @param _data bytes optional data to send along with the call
2842      * @return bool whether the call correctly returned the expected magic value
2843      */
2844     function _checkContractOnERC721Received(
2845         address from,
2846         address to,
2847         uint256 tokenId,
2848         bytes memory _data
2849     ) private returns (bool) {
2850         try
2851             IERC721Receiver(to).onERC721Received(
2852                 _msgSender(),
2853                 from,
2854                 tokenId,
2855                 _data
2856             )
2857         returns (bytes4 retval) {
2858             return retval == IERC721Receiver(to).onERC721Received.selector;
2859         } catch (bytes memory reason) {
2860             if (reason.length == 0) {
2861                 revert TransferToNonERC721ReceiverImplementer();
2862             } else {
2863                 assembly {
2864                     revert(add(32, reason), mload(reason))
2865                 }
2866             }
2867         }
2868     }
2869 
2870     /**
2871      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2872      * And also called before burning one token.
2873      *
2874      * startTokenId - the first token id to be transferred
2875      * quantity - the amount to be transferred
2876      *
2877      * Calling conditions:
2878      *
2879      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2880      * transferred to `to`.
2881      * - When `from` is zero, `tokenId` will be minted for `to`.
2882      * - When `to` is zero, `tokenId` will be burned by `from`.
2883      * - `from` and `to` are never both zero.
2884      */
2885     function _beforeTokenTransfers(
2886         address from,
2887         address to,
2888         uint256 startTokenId,
2889         uint256 quantity
2890     ) internal virtual {}
2891 
2892     /**
2893      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2894      * minting.
2895      * And also called after one token has been burned.
2896      *
2897      * startTokenId - the first token id to be transferred
2898      * quantity - the amount to be transferred
2899      *
2900      * Calling conditions:
2901      *
2902      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2903      * transferred to `to`.
2904      * - When `from` is zero, `tokenId` has been minted for `to`.
2905      * - When `to` is zero, `tokenId` has been burned by `from`.
2906      * - `from` and `to` are never both zero.
2907      */
2908     function _afterTokenTransfers(
2909         address from,
2910         address to,
2911         uint256 startTokenId,
2912         uint256 quantity
2913     ) internal virtual {}
2914 }
2915 
2916 pragma solidity ^0.8.0;
2917 
2918 /**
2919  * @dev Interface of the ERC20 standard as defined in the EIP.
2920  */
2921 interface IERC20 {
2922     /**
2923      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2924      * another (`to`).
2925      *
2926      * Note that `value` may be zero.
2927      */
2928     event Transfer(address indexed from, address indexed to, uint256 value);
2929 
2930     /**
2931      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2932      * a call to {approve}. `value` is the new allowance.
2933      */
2934     event Approval(
2935         address indexed owner,
2936         address indexed spender,
2937         uint256 value
2938     );
2939 
2940     /**
2941      * @dev Returns the amount of tokens in existence.
2942      */
2943     function totalSupply() external view returns (uint256);
2944 
2945     /**
2946      * @dev Returns the amount of tokens owned by `account`.
2947      */
2948     function balanceOf(address account) external view returns (uint256);
2949 
2950     /**
2951      * @dev Moves `amount` tokens from the caller's account to `to`.
2952      *
2953      * Returns a boolean value indicating whether the operation succeeded.
2954      *
2955      * Emits a {Transfer} event.
2956      */
2957     function transfer(address to, uint256 amount) external returns (bool);
2958 
2959     /**
2960      * @dev Returns the remaining number of tokens that `spender` will be
2961      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2962      * zero by default.
2963      *
2964      * This value changes when {approve} or {transferFrom} are called.
2965      */
2966     function allowance(
2967         address owner,
2968         address spender
2969     ) external view returns (uint256);
2970 
2971     /**
2972      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2973      *
2974      * Returns a boolean value indicating whether the operation succeeded.
2975      *
2976      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2977      * that someone may use both the old and the new allowance by unfortunate
2978      * transaction ordering. One possible solution to mitigate this race
2979      * condition is to first reduce the spender's allowance to 0 and set the
2980      * desired value afterwards:
2981      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2982      *
2983      * Emits an {Approval} event.
2984      */
2985     function approve(address spender, uint256 amount) external returns (bool);
2986 
2987     /**
2988      * @dev Moves `amount` tokens from `from` to `to` using the
2989      * allowance mechanism. `amount` is then deducted from the caller's
2990      * allowance.
2991      *
2992      * Returns a boolean value indicating whether the operation succeeded.
2993      *
2994      * Emits a {Transfer} event.
2995      */
2996     function transferFrom(
2997         address from,
2998         address to,
2999         uint256 amount
3000     ) external returns (bool);
3001 }
3002 
3003 pragma solidity ^0.8.0;
3004 
3005 /**
3006  * @title SafeERC20
3007  * @dev Wrappers around ERC20 operations that throw on failure (when the token
3008  * contract returns false). Tokens that return no value (and instead revert or
3009  * throw on failure) are also supported, non-reverting calls are assumed to be
3010  * successful.
3011  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
3012  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
3013  */
3014 library SafeERC20 {
3015     using Address for address;
3016 
3017     function safeTransfer(IERC20 token, address to, uint256 value) internal {
3018         _callOptionalReturn(
3019             token,
3020             abi.encodeWithSelector(token.transfer.selector, to, value)
3021         );
3022     }
3023 
3024     function safeTransferFrom(
3025         IERC20 token,
3026         address from,
3027         address to,
3028         uint256 value
3029     ) internal {
3030         _callOptionalReturn(
3031             token,
3032             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
3033         );
3034     }
3035 
3036     /**
3037      * @dev Deprecated. This function has issues similar to the ones found in
3038      * {IERC20-approve}, and its usage is discouraged.
3039      *
3040      * Whenever possible, use {safeIncreaseAllowance} and
3041      * {safeDecreaseAllowance} instead.
3042      */
3043     function safeApprove(
3044         IERC20 token,
3045         address spender,
3046         uint256 value
3047     ) internal {
3048         // safeApprove should only be called when setting an initial allowance,
3049         // or when resetting it to zero. To increase and decrease it, use
3050         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
3051         require(
3052             (value == 0) || (token.allowance(address(this), spender) == 0),
3053             "SafeERC20: approve from non-zero to non-zero allowance"
3054         );
3055         _callOptionalReturn(
3056             token,
3057             abi.encodeWithSelector(token.approve.selector, spender, value)
3058         );
3059     }
3060 
3061     function safeIncreaseAllowance(
3062         IERC20 token,
3063         address spender,
3064         uint256 value
3065     ) internal {
3066         uint256 newAllowance = token.allowance(address(this), spender) + value;
3067         _callOptionalReturn(
3068             token,
3069             abi.encodeWithSelector(
3070                 token.approve.selector,
3071                 spender,
3072                 newAllowance
3073             )
3074         );
3075     }
3076 
3077     function safeDecreaseAllowance(
3078         IERC20 token,
3079         address spender,
3080         uint256 value
3081     ) internal {
3082         unchecked {
3083             uint256 oldAllowance = token.allowance(address(this), spender);
3084             require(
3085                 oldAllowance >= value,
3086                 "SafeERC20: decreased allowance below zero"
3087             );
3088             uint256 newAllowance = oldAllowance - value;
3089             _callOptionalReturn(
3090                 token,
3091                 abi.encodeWithSelector(
3092                     token.approve.selector,
3093                     spender,
3094                     newAllowance
3095                 )
3096             );
3097         }
3098     }
3099 
3100     /**
3101      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
3102      * on the return value: the return value is optional (but if data is returned, it must not be false).
3103      * @param token The token targeted by the call.
3104      * @param data The call data (encoded using abi.encode or one of its variants).
3105      */
3106     function _callOptionalReturn(IERC20 token, bytes memory data) private {
3107         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
3108         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
3109         // the target address contains contract code and also asserts for success in the low-level call.
3110 
3111         bytes memory returndata = address(token).functionCall(
3112             data,
3113             "SafeERC20: low-level call failed"
3114         );
3115         if (returndata.length > 0) {
3116             // Return data is optional
3117             require(
3118                 abi.decode(returndata, (bool)),
3119                 "SafeERC20: ERC20 operation did not succeed"
3120             );
3121         }
3122     }
3123 }
3124 
3125 pragma solidity ^0.8.0;
3126 
3127 /**
3128  * @title PaymentSplitter
3129  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
3130  * that the Ether will be split in this way, since it is handled transparently by the contract.
3131  *
3132  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
3133  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
3134  * an amount proportional to the percentage of total shares they were assigned.
3135  *
3136  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
3137  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
3138  * function.
3139  *
3140  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
3141  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
3142  * to run tests before sending real value to this contract.
3143  */
3144 contract PaymentSplitter is Context {
3145     event PayeeAdded(address account, uint256 shares);
3146     event PaymentReleased(address to, uint256 amount);
3147     event ERC20PaymentReleased(
3148         IERC20 indexed token,
3149         address to,
3150         uint256 amount
3151     );
3152     event PaymentReceived(address from, uint256 amount);
3153 
3154     uint256 private _totalShares;
3155     uint256 private _totalReleased;
3156 
3157     mapping(address => uint256) private _shares;
3158     mapping(address => uint256) private _released;
3159     address[] private _payees;
3160 
3161     mapping(IERC20 => uint256) private _erc20TotalReleased;
3162     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
3163 
3164     /**
3165      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
3166      * the matching position in the `shares` array.
3167      *
3168      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
3169      * duplicates in `payees`.
3170      */
3171     constructor(address[] memory payees, uint256[] memory shares_) payable {
3172         require(
3173             payees.length == shares_.length,
3174             "PaymentSplitter: payees and shares length mismatch"
3175         );
3176         require(payees.length > 0, "PaymentSplitter: no payees");
3177 
3178         for (uint256 i = 0; i < payees.length; i++) {
3179             _addPayee(payees[i], shares_[i]);
3180         }
3181     }
3182 
3183     /**
3184      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
3185      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
3186      * reliability of the events, and not the actual splitting of Ether.
3187      *
3188      * To learn more about this see the Solidity documentation for
3189      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
3190      * functions].
3191      */
3192     receive() external payable virtual {
3193         emit PaymentReceived(_msgSender(), msg.value);
3194     }
3195 
3196     /**
3197      * @dev Getter for the total shares held by payees.
3198      */
3199     function totalShares() public view returns (uint256) {
3200         return _totalShares;
3201     }
3202 
3203     /**
3204      * @dev Getter for the total amount of Ether already released.
3205      */
3206     function totalReleased() public view returns (uint256) {
3207         return _totalReleased;
3208     }
3209 
3210     /**
3211      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
3212      * contract.
3213      */
3214     function totalReleased(IERC20 token) public view returns (uint256) {
3215         return _erc20TotalReleased[token];
3216     }
3217 
3218     /**
3219      * @dev Getter for the amount of shares held by an account.
3220      */
3221     function shares(address account) public view returns (uint256) {
3222         return _shares[account];
3223     }
3224 
3225     /**
3226      * @dev Getter for the amount of Ether already released to a payee.
3227      */
3228     function released(address account) public view returns (uint256) {
3229         return _released[account];
3230     }
3231 
3232     /**
3233      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
3234      * IERC20 contract.
3235      */
3236     function released(
3237         IERC20 token,
3238         address account
3239     ) public view returns (uint256) {
3240         return _erc20Released[token][account];
3241     }
3242 
3243     /**
3244      * @dev Getter for the address of the payee number `index`.
3245      */
3246     function payee(uint256 index) public view returns (address) {
3247         return _payees[index];
3248     }
3249 
3250     /**
3251      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
3252      * total shares and their previous withdrawals.
3253      */
3254     function release(address payable account) public virtual {
3255         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3256 
3257         uint256 totalReceived = address(this).balance + totalReleased();
3258         uint256 payment = _pendingPayment(
3259             account,
3260             totalReceived,
3261             released(account)
3262         );
3263 
3264         require(payment != 0, "PaymentSplitter: account is not due payment");
3265 
3266         _released[account] += payment;
3267         _totalReleased += payment;
3268 
3269         Address.sendValue(account, payment);
3270         emit PaymentReleased(account, payment);
3271     }
3272 
3273     /**
3274      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
3275      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
3276      * contract.
3277      */
3278     function release(IERC20 token, address account) public virtual {
3279         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3280 
3281         uint256 totalReceived = token.balanceOf(address(this)) +
3282             totalReleased(token);
3283         uint256 payment = _pendingPayment(
3284             account,
3285             totalReceived,
3286             released(token, account)
3287         );
3288 
3289         require(payment != 0, "PaymentSplitter: account is not due payment");
3290 
3291         _erc20Released[token][account] += payment;
3292         _erc20TotalReleased[token] += payment;
3293 
3294         SafeERC20.safeTransfer(token, account, payment);
3295         emit ERC20PaymentReleased(token, account, payment);
3296     }
3297 
3298     /**
3299      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
3300      * already released amounts.
3301      */
3302     function _pendingPayment(
3303         address account,
3304         uint256 totalReceived,
3305         uint256 alreadyReleased
3306     ) private view returns (uint256) {
3307         return
3308             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
3309     }
3310 
3311     /**
3312      * @dev Add a new payee to the contract.
3313      * @param account The address of the payee to add.
3314      * @param shares_ The number of shares owned by the payee.
3315      */
3316     function _addPayee(address account, uint256 shares_) private {
3317         require(
3318             account != address(0),
3319             "PaymentSplitter: account is the zero address"
3320         );
3321         require(shares_ > 0, "PaymentSplitter: shares are 0");
3322         require(
3323             _shares[account] == 0,
3324             "PaymentSplitter: account already has shares"
3325         );
3326 
3327         _payees.push(account);
3328         _shares[account] = shares_;
3329         _totalShares = _totalShares + shares_;
3330         emit PayeeAdded(account, shares_);
3331     }
3332 }
3333 pragma solidity ^0.8.0;
3334 
3335 interface IOperatorFilterRegistry {
3336     function isOperatorAllowed(
3337         address registrant,
3338         address operator
3339     ) external view returns (bool);
3340 
3341     function register(address registrant) external;
3342 
3343     function registerAndSubscribe(
3344         address registrant,
3345         address subscription
3346     ) external;
3347 
3348     function registerAndCopyEntries(
3349         address registrant,
3350         address registrantToCopy
3351     ) external;
3352 
3353     function unregister(address addr) external;
3354 
3355     function updateOperator(
3356         address registrant,
3357         address operator,
3358         bool filtered
3359     ) external;
3360 
3361     function updateOperators(
3362         address registrant,
3363         address[] calldata operators,
3364         bool filtered
3365     ) external;
3366 
3367     function updateCodeHash(
3368         address registrant,
3369         bytes32 codehash,
3370         bool filtered
3371     ) external;
3372 
3373     function updateCodeHashes(
3374         address registrant,
3375         bytes32[] calldata codeHashes,
3376         bool filtered
3377     ) external;
3378 
3379     function subscribe(
3380         address registrant,
3381         address registrantToSubscribe
3382     ) external;
3383 
3384     function unsubscribe(address registrant, bool copyExistingEntries) external;
3385 
3386     function subscriptionOf(address addr) external returns (address registrant);
3387 
3388     function subscribers(
3389         address registrant
3390     ) external returns (address[] memory);
3391 
3392     function subscriberAt(
3393         address registrant,
3394         uint256 index
3395     ) external returns (address);
3396 
3397     function copyEntriesOf(
3398         address registrant,
3399         address registrantToCopy
3400     ) external;
3401 
3402     function isOperatorFiltered(
3403         address registrant,
3404         address operator
3405     ) external returns (bool);
3406 
3407     function isCodeHashOfFiltered(
3408         address registrant,
3409         address operatorWithCode
3410     ) external returns (bool);
3411 
3412     function isCodeHashFiltered(
3413         address registrant,
3414         bytes32 codeHash
3415     ) external returns (bool);
3416 
3417     function filteredOperators(
3418         address addr
3419     ) external returns (address[] memory);
3420 
3421     function filteredCodeHashes(
3422         address addr
3423     ) external returns (bytes32[] memory);
3424 
3425     function filteredOperatorAt(
3426         address registrant,
3427         uint256 index
3428     ) external returns (address);
3429 
3430     function filteredCodeHashAt(
3431         address registrant,
3432         uint256 index
3433     ) external returns (bytes32);
3434 
3435     function isRegistered(address addr) external returns (bool);
3436 
3437     function codeHashOf(address addr) external returns (bytes32);
3438 }
3439 
3440 /**
3441  * @title  OperatorFilterer
3442  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3443  *         registrant's entries in the OperatorFilterRegistry.
3444  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3445  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3446  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3447  */
3448 abstract contract OperatorFilterer {
3449     error OperatorNotAllowed(address operator);
3450 
3451     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3452         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3453 
3454     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3455         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3456         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3457         // order for the modifier to filter addresses.
3458         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3459             if (subscribe) {
3460                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
3461                     address(this),
3462                     subscriptionOrRegistrantToCopy
3463                 );
3464             } else {
3465                 if (subscriptionOrRegistrantToCopy != address(0)) {
3466                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
3467                         address(this),
3468                         subscriptionOrRegistrantToCopy
3469                     );
3470                 } else {
3471                     OPERATOR_FILTER_REGISTRY.register(address(this));
3472                 }
3473             }
3474         }
3475     }
3476 
3477     modifier onlyAllowedOperator(address from) virtual {
3478         // Check registry code length to facilitate testing in environments without a deployed registry.
3479         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3480             // Allow spending tokens from addresses with balance
3481             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3482             // from an EOA.
3483             if (from == msg.sender) {
3484                 _;
3485                 return;
3486             }
3487             if (
3488                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
3489                     address(this),
3490                     msg.sender
3491                 )
3492             ) {
3493                 revert OperatorNotAllowed(msg.sender);
3494             }
3495         }
3496         _;
3497     }
3498 
3499     modifier onlyAllowedOperatorApproval(address operator) virtual {
3500         // Check registry code length to facilitate testing in environments without a deployed registry.
3501         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3502             if (
3503                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
3504                     address(this),
3505                     operator
3506                 )
3507             ) {
3508                 revert OperatorNotAllowed(operator);
3509             }
3510         }
3511         _;
3512     }
3513 }
3514 
3515 /**
3516  * @dev Required interface of an ERC1155 compliant contract, as defined in the
3517  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
3518  *
3519  * _Available since v3.1._
3520  */
3521 interface IERC1155 is IERC165 {
3522     /**
3523      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
3524      */
3525     event TransferSingle(
3526         address indexed operator,
3527         address indexed from,
3528         address indexed to,
3529         uint256 id,
3530         uint256 value
3531     );
3532 
3533     /**
3534      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
3535      * transfers.
3536      */
3537     event TransferBatch(
3538         address indexed operator,
3539         address indexed from,
3540         address indexed to,
3541         uint256[] ids,
3542         uint256[] values
3543     );
3544 
3545     /**
3546      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
3547      * `approved`.
3548      */
3549     event ApprovalForAll(
3550         address indexed account,
3551         address indexed operator,
3552         bool approved
3553     );
3554 
3555     /**
3556      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
3557      *
3558      * If an {URI} event was emitted for `id`, the standard
3559      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
3560      * returned by {IERC1155MetadataURI-uri}.
3561      */
3562     event URI(string value, uint256 indexed id);
3563 
3564     /**
3565      * @dev Returns the amount of tokens of token type `id` owned by `account`.
3566      *
3567      * Requirements:
3568      *
3569      * - `account` cannot be the zero address.
3570      */
3571     function balanceOf(
3572         address account,
3573         uint256 id
3574     ) external view returns (uint256);
3575 
3576     /**
3577      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
3578      *
3579      * Requirements:
3580      *
3581      * - `accounts` and `ids` must have the same length.
3582      */
3583     function balanceOfBatch(
3584         address[] calldata accounts,
3585         uint256[] calldata ids
3586     ) external view returns (uint256[] memory);
3587 
3588     /**
3589      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
3590      *
3591      * Emits an {ApprovalForAll} event.
3592      *
3593      * Requirements:
3594      *
3595      * - `operator` cannot be the caller.
3596      */
3597     function setApprovalForAll(address operator, bool approved) external;
3598 
3599     /**
3600      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
3601      *
3602      * See {setApprovalForAll}.
3603      */
3604     function isApprovedForAll(
3605         address account,
3606         address operator
3607     ) external view returns (bool);
3608 
3609     /**
3610      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
3611      *
3612      * Emits a {TransferSingle} event.
3613      *
3614      * Requirements:
3615      *
3616      * - `to` cannot be the zero address.
3617      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
3618      * - `from` must have a balance of tokens of type `id` of at least `amount`.
3619      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
3620      * acceptance magic value.
3621      */
3622     function safeTransferFrom(
3623         address from,
3624         address to,
3625         uint256 id,
3626         uint256 amount,
3627         bytes calldata data
3628     ) external;
3629 
3630     /**
3631      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
3632      *
3633      * Emits a {TransferBatch} event.
3634      *
3635      * Requirements:
3636      *
3637      * - `ids` and `amounts` must have the same length.
3638      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
3639      * acceptance magic value.
3640      */
3641     function safeBatchTransferFrom(
3642         address from,
3643         address to,
3644         uint256[] calldata ids,
3645         uint256[] calldata amounts,
3646         bytes calldata data
3647     ) external;
3648 }
3649 
3650 /**
3651  * @title  DefaultOperatorFilterer
3652  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3653  */
3654 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3655     address constant DEFAULT_SUBSCRIPTION =
3656         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3657 
3658     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3659 }
3660 
3661 // Burn Artifact using this code.
3662 interface IMythicArtifacts {
3663     function burnArtifacts(
3664         address tokenOwner,
3665         uint256 tokenId,
3666         uint256 totalToBurn
3667     ) external;
3668 }
3669 
3670 contract LiquidTitans is
3671     ERC721A,
3672     ReentrancyGuard,
3673     Ownable,
3674     DefaultOperatorFilterer
3675 {
3676     // Setup all the crazy contracts, variables, and other abstracted nonsense
3677     // we need to burn, destroy, transfer, and spend METL on so we can mint
3678     ERC721A public erc721Token;
3679     IERC20 public erc20Token;
3680 
3681     // Minting Variables
3682     uint256 public mintPrice = 142;
3683     uint256 public maxPurchase = 42;
3684     uint256 public maxSupply = 420;
3685 
3686     address public DEAD = 0x000000000000000000000000000000000000dEaD;
3687     address public Legends = 0x372405A6d95628Ad14518BfE05165D397f43dE1D;
3688     address public Invaders = 0x2f3A9adc5301600Cd9205eF7657cF0733fF71D04;
3689     address public Artifacts = 0xf85906f89aecA56aff6D34790677595aF6B4FBD7;
3690     address public LiquidDeployer = 0x866cfDa1B7cD90Cd250485cd8b700211480845D7;
3691 
3692     // Liquid METL -- bang your head as you read this line of code
3693     address public METLToken = 0xFcbE615dEf610E806BB64427574A2c5c1fB55510;
3694 
3695     // Specify the IERC20 interface to the METL Token
3696     IERC20 METLTokenAddress = IERC20(address(METLToken));
3697 
3698     // Sale Status
3699     bool public saleIsActive = true;
3700     bool public airdropIsActive = true;
3701 
3702     mapping(address => uint256) public addressesThatMinted;
3703 
3704     // Metadata
3705     string _baseTokenURI = "https://apeliquid.io/titans/json/";
3706     bool public locked;
3707 
3708     // Events
3709     event SaleActivation(bool isActive);
3710     event AirdropActivation(bool isActive);
3711 
3712     constructor() ERC721A("Liquid Titans", "TITANS") {}
3713 
3714     function airdrop(
3715         uint256[] calldata _counts,
3716         address[] calldata _list
3717     ) external onlyOwner {
3718         require(airdropIsActive, "AIRDROP NOT ACTIVE");
3719 
3720         for (uint256 i = 0; i < _list.length; i++) {
3721             require(totalSupply() + _counts[i] <= maxSupply, "SOLD OUT");
3722             _safeMint(_list[i], _counts[i]);
3723         }
3724     }
3725 
3726     // -----------------------------------------------------------------------------------
3727     // Minting and other primary functions (burn, mint, rinse, repeat, ignore, block, fud)
3728     // -----------------------------------------------------------------------------------
3729 
3730     function SendMETL() public {
3731         // Transfer METL
3732         uint256 metlAmount = mintPrice * 1 ether;
3733 
3734         // Call the transfer function of the token contract
3735         require(
3736             METLTokenAddress.allowance(msg.sender, address(this)) >= metlAmount,
3737             "Error: Transfer not approved"
3738         );
3739         //bool success = AcceptMETL(metlRequired);
3740         METLTokenAddress.transferFrom(msg.sender, address(this), metlAmount);
3741     }
3742 
3743     // This requires an approval for the contract and token before it will work
3744     // Go to the original contract and "Approve All" instead of each token id
3745     // to save gas over the long term
3746     function sendNFTToDead(address nftContractAddress, uint256 tokenId) public {
3747         require(tokenId > 0, "Invalid token ID");
3748 
3749         // Create an instance of the IERC721 interface
3750         IERC721 nftContract = IERC721(nftContractAddress);
3751 
3752         // Make sure the caller is the owner of the NFT
3753         require(
3754             nftContract.ownerOf(tokenId) == msg.sender,
3755             "Not the owner of the NFT"
3756         );
3757 
3758         // Approve the contract to manage the NFT on behalf of the owner
3759         require(
3760             nftContract.getApproved(tokenId) == address(this),
3761             "Not approved to manage NFT"
3762         );
3763 
3764         // Transfer the NFT to the dead address
3765         nftContract.safeTransferFrom(msg.sender, DEAD, tokenId);
3766     }
3767 
3768     function DepositMETL(uint256 amount) public {
3769         require(amount >= mintPrice, "Insufficient ERC20 deposit");
3770         erc20Token.transferFrom(msg.sender, address(this), amount);
3771     }
3772 
3773     event TitanMinted(
3774         address indexed owner,
3775         uint256 legendId,
3776         uint256 invader1,
3777         uint256 invader2,
3778         uint256 invader3,
3779         uint256 timestamp
3780     );
3781 
3782     function mintTitan(
3783         uint256 legendId,
3784         uint256 invader1,
3785         uint256 invader2,
3786         uint256 invader3
3787     ) public nonReentrant {
3788         require(saleIsActive, "Sale not active");
3789 
3790         // Burn the required NFTs
3791         sendNFTToDead(Legends, legendId);
3792         sendNFTToDead(Invaders, invader1);
3793         sendNFTToDead(Invaders, invader2);
3794         sendNFTToDead(Invaders, invader3);
3795 
3796         // Transfer METL
3797         SendMETL();
3798 
3799         // Mint the Titan NFT
3800         uint256 tokenId = totalSupply() + 1;
3801         require(tokenId <= maxSupply, "SOLD OUT");
3802         _safeMint(msg.sender, 1);
3803 
3804         // Emit the TitanMinted event
3805         emit TitanMinted(
3806             msg.sender,
3807             legendId,
3808             invader1,
3809             invader2,
3810             invader3,
3811             block.timestamp
3812         );
3813     }
3814 
3815     // ----------------------------------------------------------------------------
3816     // All the owner functions, which are pretty heavy-handed and to be used with
3817     // extreme caution
3818     // ----------------------------------------------------------------------------
3819     function toggleSaleStatus() external onlyOwner {
3820         saleIsActive = !saleIsActive;
3821         emit SaleActivation(saleIsActive);
3822     }
3823 
3824     function toggleAirdropStatus() external onlyOwner {
3825         airdropIsActive = !airdropIsActive;
3826         emit AirdropActivation(airdropIsActive);
3827     }
3828 
3829     function setMintPrice(uint256 _mintPrice) external onlyOwner {
3830         mintPrice = _mintPrice;
3831     }
3832 
3833     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
3834         maxPurchase = _maxPurchase;
3835     }
3836 
3837     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
3838         maxSupply = _maxSupply;
3839     }
3840 
3841     function lockMetadata() external onlyOwner {
3842         locked = true;
3843     }
3844 
3845     function getTotalSupply() external view returns (uint256) {
3846         return totalSupply();
3847     }
3848 
3849     function setBaseURI(string memory baseURI) external onlyOwner {
3850         require(!locked, "METADATA_LOCKED");
3851         _baseTokenURI = baseURI;
3852     }
3853 
3854     function _baseURI() internal view virtual override returns (string memory) {
3855         return _baseTokenURI;
3856     }
3857 
3858     function tokenURI(
3859         uint256 tokenId
3860     ) public view override returns (string memory) {
3861         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
3862     }
3863 
3864     function _startTokenId() internal view virtual override returns (uint256) {
3865         return 1;
3866     }
3867 
3868     function getWalletOfOwner(address owner)
3869         external
3870         view
3871         returns (uint256[] memory)
3872     {
3873         unchecked {
3874             uint256[] memory a = new uint256[](balanceOf(owner));
3875             uint256 end = _currentIndex;
3876             uint256 tokenIdsIdx;
3877             address currOwnershipAddr;
3878             for (uint256 i; i < end; i++) {
3879                 TokenOwnership memory ownership = _ownerships[i];
3880                 if (ownership.burned) {
3881                     continue;
3882                 }
3883                 if (ownership.addr != address(0)) {
3884                     currOwnershipAddr = ownership.addr;
3885                 }
3886                 if (currOwnershipAddr == owner) {
3887                     a[tokenIdsIdx++] = i;
3888                 }
3889             }
3890             return a;
3891         }
3892     }
3893 
3894     // OpenSea's new bullshit requirements, which violate my moral code, but
3895     // are nonetheless necessary to make this all work properly.
3896     function setApprovalForAll(
3897         address operator,
3898         bool approved
3899     ) public override onlyAllowedOperatorApproval(operator) {
3900         super.setApprovalForAll(operator, approved);
3901     }
3902 
3903     // Take my love, take my land, Take me where I cannot stand.
3904     // I don't care, I'm still free, You can't take the sky from me.
3905     //
3906     function removeAllMETL() public onlyOwner {
3907         uint256 balance = METLTokenAddress.balanceOf(address(this));
3908         METLTokenAddress.transfer(LiquidDeployer, balance);
3909     }
3910 }