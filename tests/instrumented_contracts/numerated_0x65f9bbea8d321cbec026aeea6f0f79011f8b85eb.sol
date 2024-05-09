1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-04
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /*
8      _____                .____    .__             .__    .___   .__
9     /  _  \ ______   ____ |    |   |__| ________ __|__| __| _/   |__| ____
10    /  /_\  \\____ \_/ __ \|    |   |  |/ ____/  |  \  |/ __ |    |  |/  _ \
11   /    |    \  |_> >  ___/|    |___|  < <_|  |  |  /  / /_/ |    |  (  <_> )
12   \____|__  /   __/ \___  >_______ \__|\__   |____/|__\____ | /\ |__|\____/
13           \/|__|        \/        \/      |__|             \/ \/
14    __________                __                         __
15    \______   \_____    ____ |  | _____________    ____ |  | __
16     |    |  _/\__  \ _/ ___\|  |/ /\____ \__  \ _/ ___\|  |/ /
17     |    |   \ / __ \\  \___|    < |  |_> > __ \\  \___|    <
18     |______  /(____  /\___  >__|_ \|   __(____  /\___  >__|_ \
19            \/      \/     \/     \/|__|       \/     \/     \/
20 
21 */
22 
23 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev External interface of AccessControl declared to support ERC165 detection.
29  */
30 interface IAccessControl {
31     /**
32      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
33      *
34      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
35      * {RoleAdminChanged} not being emitted signaling this.
36      *
37      * _Available since v3.1._
38      */
39     event RoleAdminChanged(
40         bytes32 indexed role,
41         bytes32 indexed previousAdminRole,
42         bytes32 indexed newAdminRole
43     );
44 
45     /**
46      * @dev Emitted when `account` is granted `role`.
47      *
48      * `sender` is the account that originated the contract call, an admin role
49      * bearer except when using {AccessControl-_setupRole}.
50      */
51     event RoleGranted(
52         bytes32 indexed role,
53         address indexed account,
54         address indexed sender
55     );
56 
57     /**
58      * @dev Emitted when `account` is revoked `role`.
59      *
60      * `sender` is the account that originated the contract call:
61      *   - if using `revokeRole`, it is the admin role bearer
62      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
63      */
64     event RoleRevoked(
65         bytes32 indexed role,
66         address indexed account,
67         address indexed sender
68     );
69 
70     /**
71      * @dev Returns `true` if `account` has been granted `role`.
72      */
73     function hasRole(bytes32 role, address account)
74         external
75         view
76         returns (bool);
77 
78     /**
79      * @dev Returns the admin role that controls `role`. See {grantRole} and
80      * {revokeRole}.
81      *
82      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
83      */
84     function getRoleAdmin(bytes32 role) external view returns (bytes32);
85 
86     /**
87      * @dev Grants `role` to `account`.
88      *
89      * If `account` had not been already granted `role`, emits a {RoleGranted}
90      * event.
91      *
92      * Requirements:
93      *
94      * - the caller must have ``role``'s admin role.
95      */
96     function grantRole(bytes32 role, address account) external;
97 
98     /**
99      * @dev Revokes `role` from `account`.
100      *
101      * If `account` had been granted `role`, emits a {RoleRevoked} event.
102      *
103      * Requirements:
104      *
105      * - the caller must have ``role``'s admin role.
106      */
107     function revokeRole(bytes32 role, address account) external;
108 
109     /**
110      * @dev Revokes `role` from the calling account.
111      *
112      * Roles are often managed via {grantRole} and {revokeRole}: this function's
113      * purpose is to provide a mechanism for accounts to lose their privileges
114      * if they are compromised (such as when a trusted device is misplaced).
115      *
116      * If the calling account had been granted `role`, emits a {RoleRevoked}
117      * event.
118      *
119      * Requirements:
120      *
121      * - the caller must be `account`.
122      */
123     function renounceRole(bytes32 role, address account) external;
124 }
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Interface of the ERC165 standard, as defined in the
130  * https://eips.ethereum.org/EIPS/eip-165[EIP].
131  *
132  * Implementers can declare support of contract interfaces, which can then be
133  * queried by others ({ERC165Checker}).
134  *
135  * For an implementation, see {ERC165}.
136  */
137 interface IERC165 {
138     /**
139      * @dev Returns true if this contract implements the interface defined by
140      * `interfaceId`. See the corresponding
141      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
142      * to learn more about how these ids are created.
143      *
144      * This function call must use less than 30 000 gas.
145      */
146     function supportsInterface(bytes4 interfaceId) external view returns (bool);
147 }
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
153  */
154 interface IAccessControlEnumerable is IAccessControl {
155     /**
156      * @dev Returns one of the accounts that have `role`. `index` must be a
157      * value between 0 and {getRoleMemberCount}, non-inclusive.
158      *
159      * Role bearers are not sorted in any particular way, and their ordering may
160      * change at any point.
161      *
162      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
163      * you perform all queries on the same block. See the following
164      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
165      * for more information.
166      */
167     function getRoleMember(bytes32 role, uint256 index)
168         external
169         view
170         returns (address);
171 
172     /**
173      * @dev Returns the number of accounts that have `role`. Can be used
174      * together with {getRoleMember} to enumerate all bearers of a role.
175      */
176     function getRoleMemberCount(bytes32 role) external view returns (uint256);
177 }
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Library for managing
183  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
184  * types.
185  *
186  * Sets have the following properties:
187  *
188  * - Elements are added, removed, and checked for existence in constant time
189  * (O(1)).
190  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
191  *
192  * ```
193  * contract Example {
194  *     // Add the library methods
195  *     using EnumerableSet for EnumerableSet.AddressSet;
196  *
197  *     // Declare a set state variable
198  *     EnumerableSet.AddressSet private mySet;
199  * }
200  * ```
201  *
202  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
203  * and `uint256` (`UintSet`) are supported.
204  */
205 library EnumerableSet {
206     // To implement this library for multiple types with as little code
207     // repetition as possible, we write it in terms of a generic Set type with
208     // bytes32 values.
209     // The Set implementation uses private functions, and user-facing
210     // implementations (such as AddressSet) are just wrappers around the
211     // underlying Set.
212     // This means that we can only create new EnumerableSets for types that fit
213     // in bytes32.
214 
215     struct Set {
216         // Storage of set values
217         bytes32[] _values;
218         // Position of the value in the `values` array, plus 1 because index 0
219         // means a value is not in the set.
220         mapping(bytes32 => uint256) _indexes;
221     }
222 
223     /**
224      * @dev Add a value to a set. O(1).
225      *
226      * Returns true if the value was added to the set, that is if it was not
227      * already present.
228      */
229     function _add(Set storage set, bytes32 value) private returns (bool) {
230         if (!_contains(set, value)) {
231             set._values.push(value);
232             // The value is stored at length-1, but we add 1 to all indexes
233             // and use 0 as a sentinel value
234             set._indexes[value] = set._values.length;
235             return true;
236         } else {
237             return false;
238         }
239     }
240 
241     /**
242      * @dev Removes a value from a set. O(1).
243      *
244      * Returns true if the value was removed from the set, that is if it was
245      * present.
246      */
247     function _remove(Set storage set, bytes32 value) private returns (bool) {
248         // We read and store the value's index to prevent multiple reads from the same storage slot
249         uint256 valueIndex = set._indexes[value];
250 
251         if (valueIndex != 0) {
252             // Equivalent to contains(set, value)
253             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
254             // the array, and then remove the last element (sometimes called as 'swap and pop').
255             // This modifies the order of the array, as noted in {at}.
256 
257             uint256 toDeleteIndex = valueIndex - 1;
258             uint256 lastIndex = set._values.length - 1;
259 
260             if (lastIndex != toDeleteIndex) {
261                 bytes32 lastvalue = set._values[lastIndex];
262 
263                 // Move the last value to the index where the value to delete is
264                 set._values[toDeleteIndex] = lastvalue;
265                 // Update the index for the moved value
266                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
267             }
268 
269             // Delete the slot where the moved value was stored
270             set._values.pop();
271 
272             // Delete the index for the deleted slot
273             delete set._indexes[value];
274 
275             return true;
276         } else {
277             return false;
278         }
279     }
280 
281     /**
282      * @dev Returns true if the value is in the set. O(1).
283      */
284     function _contains(Set storage set, bytes32 value)
285         private
286         view
287         returns (bool)
288     {
289         return set._indexes[value] != 0;
290     }
291 
292     /**
293      * @dev Returns the number of values on the set. O(1).
294      */
295     function _length(Set storage set) private view returns (uint256) {
296         return set._values.length;
297     }
298 
299     /**
300      * @dev Returns the value stored at position `index` in the set. O(1).
301      *
302      * Note that there are no guarantees on the ordering of values inside the
303      * array, and it may change when more values are added or removed.
304      *
305      * Requirements:
306      *
307      * - `index` must be strictly less than {length}.
308      */
309     function _at(Set storage set, uint256 index)
310         private
311         view
312         returns (bytes32)
313     {
314         return set._values[index];
315     }
316 
317     /**
318      * @dev Return the entire set in an array
319      *
320      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
321      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
322      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
323      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
324      */
325     function _values(Set storage set) private view returns (bytes32[] memory) {
326         return set._values;
327     }
328 
329     // Bytes32Set
330 
331     struct Bytes32Set {
332         Set _inner;
333     }
334 
335     /**
336      * @dev Add a value to a set. O(1).
337      *
338      * Returns true if the value was added to the set, that is if it was not
339      * already present.
340      */
341     function add(Bytes32Set storage set, bytes32 value)
342         internal
343         returns (bool)
344     {
345         return _add(set._inner, value);
346     }
347 
348     /**
349      * @dev Removes a value from a set. O(1).
350      *
351      * Returns true if the value was removed from the set, that is if it was
352      * present.
353      */
354     function remove(Bytes32Set storage set, bytes32 value)
355         internal
356         returns (bool)
357     {
358         return _remove(set._inner, value);
359     }
360 
361     /**
362      * @dev Returns true if the value is in the set. O(1).
363      */
364     function contains(Bytes32Set storage set, bytes32 value)
365         internal
366         view
367         returns (bool)
368     {
369         return _contains(set._inner, value);
370     }
371 
372     /**
373      * @dev Returns the number of values in the set. O(1).
374      */
375     function length(Bytes32Set storage set) internal view returns (uint256) {
376         return _length(set._inner);
377     }
378 
379     /**
380      * @dev Returns the value stored at position `index` in the set. O(1).
381      *
382      * Note that there are no guarantees on the ordering of values inside the
383      * array, and it may change when more values are added or removed.
384      *
385      * Requirements:
386      *
387      * - `index` must be strictly less than {length}.
388      */
389     function at(Bytes32Set storage set, uint256 index)
390         internal
391         view
392         returns (bytes32)
393     {
394         return _at(set._inner, index);
395     }
396 
397     /**
398      * @dev Return the entire set in an array
399      *
400      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
401      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
402      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
403      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
404      */
405     function values(Bytes32Set storage set)
406         internal
407         view
408         returns (bytes32[] memory)
409     {
410         return _values(set._inner);
411     }
412 
413     // AddressSet
414 
415     struct AddressSet {
416         Set _inner;
417     }
418 
419     /**
420      * @dev Add a value to a set. O(1).
421      *
422      * Returns true if the value was added to the set, that is if it was not
423      * already present.
424      */
425     function add(AddressSet storage set, address value)
426         internal
427         returns (bool)
428     {
429         return _add(set._inner, bytes32(uint256(uint160(value))));
430     }
431 
432     /**
433      * @dev Removes a value from a set. O(1).
434      *
435      * Returns true if the value was removed from the set, that is if it was
436      * present.
437      */
438     function remove(AddressSet storage set, address value)
439         internal
440         returns (bool)
441     {
442         return _remove(set._inner, bytes32(uint256(uint160(value))));
443     }
444 
445     /**
446      * @dev Returns true if the value is in the set. O(1).
447      */
448     function contains(AddressSet storage set, address value)
449         internal
450         view
451         returns (bool)
452     {
453         return _contains(set._inner, bytes32(uint256(uint160(value))));
454     }
455 
456     /**
457      * @dev Returns the number of values in the set. O(1).
458      */
459     function length(AddressSet storage set) internal view returns (uint256) {
460         return _length(set._inner);
461     }
462 
463     /**
464      * @dev Returns the value stored at position `index` in the set. O(1).
465      *
466      * Note that there are no guarantees on the ordering of values inside the
467      * array, and it may change when more values are added or removed.
468      *
469      * Requirements:
470      *
471      * - `index` must be strictly less than {length}.
472      */
473     function at(AddressSet storage set, uint256 index)
474         internal
475         view
476         returns (address)
477     {
478         return address(uint160(uint256(_at(set._inner, index))));
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
489     function values(AddressSet storage set)
490         internal
491         view
492         returns (address[] memory)
493     {
494         bytes32[] memory store = _values(set._inner);
495         address[] memory result;
496 
497         assembly {
498             result := store
499         }
500 
501         return result;
502     }
503 
504     // UintSet
505 
506     struct UintSet {
507         Set _inner;
508     }
509 
510     /**
511      * @dev Add a value to a set. O(1).
512      *
513      * Returns true if the value was added to the set, that is if it was not
514      * already present.
515      */
516     function add(UintSet storage set, uint256 value) internal returns (bool) {
517         return _add(set._inner, bytes32(value));
518     }
519 
520     /**
521      * @dev Removes a value from a set. O(1).
522      *
523      * Returns true if the value was removed from the set, that is if it was
524      * present.
525      */
526     function remove(UintSet storage set, uint256 value)
527         internal
528         returns (bool)
529     {
530         return _remove(set._inner, bytes32(value));
531     }
532 
533     /**
534      * @dev Returns true if the value is in the set. O(1).
535      */
536     function contains(UintSet storage set, uint256 value)
537         internal
538         view
539         returns (bool)
540     {
541         return _contains(set._inner, bytes32(value));
542     }
543 
544     /**
545      * @dev Returns the number of values on the set. O(1).
546      */
547     function length(UintSet storage set) internal view returns (uint256) {
548         return _length(set._inner);
549     }
550 
551     /**
552      * @dev Returns the value stored at position `index` in the set. O(1).
553      *
554      * Note that there are no guarantees on the ordering of values inside the
555      * array, and it may change when more values are added or removed.
556      *
557      * Requirements:
558      *
559      * - `index` must be strictly less than {length}.
560      */
561     function at(UintSet storage set, uint256 index)
562         internal
563         view
564         returns (uint256)
565     {
566         return uint256(_at(set._inner, index));
567     }
568 
569     /**
570      * @dev Return the entire set in an array
571      *
572      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
573      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
574      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
575      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
576      */
577     function values(UintSet storage set)
578         internal
579         view
580         returns (uint256[] memory)
581     {
582         bytes32[] memory store = _values(set._inner);
583         uint256[] memory result;
584 
585         assembly {
586             result := store
587         }
588 
589         return result;
590     }
591 }
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev Required interface of an ERC721 compliant contract.
597  */
598 interface IERC721 is IERC165 {
599     /**
600      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
601      */
602     event Transfer(
603         address indexed from,
604         address indexed to,
605         uint256 indexed tokenId
606     );
607 
608     /**
609      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
610      */
611     event Approval(
612         address indexed owner,
613         address indexed approved,
614         uint256 indexed tokenId
615     );
616 
617     /**
618      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
619      */
620     event ApprovalForAll(
621         address indexed owner,
622         address indexed operator,
623         bool approved
624     );
625 
626     /**
627      * @dev Returns the number of tokens in ``owner``'s account.
628      */
629     function balanceOf(address owner) external view returns (uint256 balance);
630 
631     /**
632      * @dev Returns the owner of the `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function ownerOf(uint256 tokenId) external view returns (address owner);
639 
640     /**
641      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
642      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must exist and be owned by `from`.
649      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) external;
659 
660     /**
661      * @dev Transfers `tokenId` token from `from` to `to`.
662      *
663      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must be owned by `from`.
670      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
671      *
672      * Emits a {Transfer} event.
673      */
674     function transferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) external;
679 
680     /**
681      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
682      * The approval is cleared when the token is transferred.
683      *
684      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
685      *
686      * Requirements:
687      *
688      * - The caller must own the token or be an approved operator.
689      * - `tokenId` must exist.
690      *
691      * Emits an {Approval} event.
692      */
693     function approve(address to, uint256 tokenId) external;
694 
695     /**
696      * @dev Returns the account approved for `tokenId` token.
697      *
698      * Requirements:
699      *
700      * - `tokenId` must exist.
701      */
702     function getApproved(uint256 tokenId)
703         external
704         view
705         returns (address operator);
706 
707     /**
708      * @dev Approve or remove `operator` as an operator for the caller.
709      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
710      *
711      * Requirements:
712      *
713      * - The `operator` cannot be the caller.
714      *
715      * Emits an {ApprovalForAll} event.
716      */
717     function setApprovalForAll(address operator, bool _approved) external;
718 
719     /**
720      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
721      *
722      * See {setApprovalForAll}
723      */
724     function isApprovedForAll(address owner, address operator)
725         external
726         view
727         returns (bool);
728 
729     /**
730      * @dev Safely transfers `tokenId` token from `from` to `to`.
731      *
732      * Requirements:
733      *
734      * - `from` cannot be the zero address.
735      * - `to` cannot be the zero address.
736      * - `tokenId` token must exist and be owned by `from`.
737      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
738      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
739      *
740      * Emits a {Transfer} event.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId,
746         bytes calldata data
747     ) external;
748 }
749 
750 pragma solidity ^0.8.0;
751 
752 /**
753  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
754  * @dev See https://eips.ethereum.org/EIPS/eip-721
755  */
756 interface IERC721Enumerable is IERC721 {
757     /**
758      * @dev Returns the total amount of tokens stored by the contract.
759      */
760     function totalSupply() external view returns (uint256);
761 
762     /**
763      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
764      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
765      */
766     function tokenOfOwnerByIndex(address owner, uint256 index)
767         external
768         view
769         returns (uint256 tokenId);
770 
771     /**
772      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
773      * Use along with {totalSupply} to enumerate all tokens.
774      */
775     function tokenByIndex(uint256 index) external view returns (uint256);
776 }
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @title ERC721 token receiver interface
782  * @dev Interface for any contract that wants to support safeTransfers
783  * from ERC721 asset contracts.
784  */
785 interface IERC721Receiver {
786     /**
787      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
788      * by `operator` from `from`, this function is called.
789      *
790      * It must return its Solidity selector to confirm the token transfer.
791      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
792      *
793      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
794      */
795     function onERC721Received(
796         address operator,
797         address from,
798         uint256 tokenId,
799         bytes calldata data
800     ) external returns (bytes4);
801 }
802 
803 pragma solidity ^0.8.0;
804 
805 /**
806  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
807  * @dev See https://eips.ethereum.org/EIPS/eip-721
808  */
809 interface IERC721Metadata is IERC721 {
810     /**
811      * @dev Returns the token collection name.
812      */
813     function name() external view returns (string memory);
814 
815     /**
816      * @dev Returns the token collection symbol.
817      */
818     function symbol() external view returns (string memory);
819 
820     /**
821      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
822      */
823     function tokenURI(uint256 tokenId) external view returns (string memory);
824 }
825 
826 pragma solidity ^0.8.0;
827 
828 /**
829  * @dev Collection of functions related to the address type
830  */
831 library Address {
832     /**
833      * @dev Returns true if `account` is a contract.
834      *
835      * [IMPORTANT]
836      * ====
837      * It is unsafe to assume that an address for which this function returns
838      * false is an externally-owned account (EOA) and not a contract.
839      *
840      * Among others, `isContract` will return false for the following
841      * types of addresses:
842      *
843      *  - an externally-owned account
844      *  - a contract in construction
845      *  - an address where a contract will be created
846      *  - an address where a contract lived, but was destroyed
847      * ====
848      */
849     function isContract(address account) internal view returns (bool) {
850         // This method relies on extcodesize, which returns 0 for contracts in
851         // construction, since the code is only stored at the end of the
852         // constructor execution.
853 
854         uint256 size;
855         assembly {
856             size := extcodesize(account)
857         }
858         return size > 0;
859     }
860 
861     /**
862      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
863      * `recipient`, forwarding all available gas and reverting on errors.
864      *
865      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
866      * of certain opcodes, possibly making contracts go over the 2300 gas limit
867      * imposed by `transfer`, making them unable to receive funds via
868      * `transfer`. {sendValue} removes this limitation.
869      *
870      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
871      *
872      * IMPORTANT: because control is transferred to `recipient`, care must be
873      * taken to not create reentrancy vulnerabilities. Consider using
874      * {ReentrancyGuard} or the
875      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
876      */
877     function sendValue(address payable recipient, uint256 amount) internal {
878         require(
879             address(this).balance >= amount,
880             "Address: insufficient balance"
881         );
882 
883         (bool success, ) = recipient.call{value: amount}("");
884         require(
885             success,
886             "Address: unable to send value, recipient may have reverted"
887         );
888     }
889 
890     /**
891      * @dev Performs a Solidity function call using a low level `call`. A
892      * plain `call` is an unsafe replacement for a function call: use this
893      * function instead.
894      *
895      * If `target` reverts with a revert reason, it is bubbled up by this
896      * function (like regular Solidity function calls).
897      *
898      * Returns the raw returned data. To convert to the expected return value,
899      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
900      *
901      * Requirements:
902      *
903      * - `target` must be a contract.
904      * - calling `target` with `data` must not revert.
905      *
906      * _Available since v3.1._
907      */
908     function functionCall(address target, bytes memory data)
909         internal
910         returns (bytes memory)
911     {
912         return functionCall(target, data, "Address: low-level call failed");
913     }
914 
915     /**
916      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
917      * `errorMessage` as a fallback revert reason when `target` reverts.
918      *
919      * _Available since v3.1._
920      */
921     function functionCall(
922         address target,
923         bytes memory data,
924         string memory errorMessage
925     ) internal returns (bytes memory) {
926         return functionCallWithValue(target, data, 0, errorMessage);
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
931      * but also transferring `value` wei to `target`.
932      *
933      * Requirements:
934      *
935      * - the calling contract must have an ETH balance of at least `value`.
936      * - the called Solidity function must be `payable`.
937      *
938      * _Available since v3.1._
939      */
940     function functionCallWithValue(
941         address target,
942         bytes memory data,
943         uint256 value
944     ) internal returns (bytes memory) {
945         return
946             functionCallWithValue(
947                 target,
948                 data,
949                 value,
950                 "Address: low-level call with value failed"
951             );
952     }
953 
954     /**
955      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
956      * with `errorMessage` as a fallback revert reason when `target` reverts.
957      *
958      * _Available since v3.1._
959      */
960     function functionCallWithValue(
961         address target,
962         bytes memory data,
963         uint256 value,
964         string memory errorMessage
965     ) internal returns (bytes memory) {
966         require(
967             address(this).balance >= value,
968             "Address: insufficient balance for call"
969         );
970         require(isContract(target), "Address: call to non-contract");
971 
972         (bool success, bytes memory returndata) = target.call{value: value}(
973             data
974         );
975         return verifyCallResult(success, returndata, errorMessage);
976     }
977 
978     /**
979      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
980      * but performing a static call.
981      *
982      * _Available since v3.3._
983      */
984     function functionStaticCall(address target, bytes memory data)
985         internal
986         view
987         returns (bytes memory)
988     {
989         return
990             functionStaticCall(
991                 target,
992                 data,
993                 "Address: low-level static call failed"
994             );
995     }
996 
997     /**
998      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
999      * but performing a static call.
1000      *
1001      * _Available since v3.3._
1002      */
1003     function functionStaticCall(
1004         address target,
1005         bytes memory data,
1006         string memory errorMessage
1007     ) internal view returns (bytes memory) {
1008         require(isContract(target), "Address: static call to non-contract");
1009 
1010         (bool success, bytes memory returndata) = target.staticcall(data);
1011         return verifyCallResult(success, returndata, errorMessage);
1012     }
1013 
1014     /**
1015      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1016      * but performing a delegate call.
1017      *
1018      * _Available since v3.4._
1019      */
1020     function functionDelegateCall(address target, bytes memory data)
1021         internal
1022         returns (bytes memory)
1023     {
1024         return
1025             functionDelegateCall(
1026                 target,
1027                 data,
1028                 "Address: low-level delegate call failed"
1029             );
1030     }
1031 
1032     /**
1033      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1034      * but performing a delegate call.
1035      *
1036      * _Available since v3.4._
1037      */
1038     function functionDelegateCall(
1039         address target,
1040         bytes memory data,
1041         string memory errorMessage
1042     ) internal returns (bytes memory) {
1043         require(isContract(target), "Address: delegate call to non-contract");
1044 
1045         (bool success, bytes memory returndata) = target.delegatecall(data);
1046         return verifyCallResult(success, returndata, errorMessage);
1047     }
1048 
1049     /**
1050      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1051      * revert reason using the provided one.
1052      *
1053      * _Available since v4.3._
1054      */
1055     function verifyCallResult(
1056         bool success,
1057         bytes memory returndata,
1058         string memory errorMessage
1059     ) internal pure returns (bytes memory) {
1060         if (success) {
1061             return returndata;
1062         } else {
1063             // Look for revert reason and bubble it up if present
1064             if (returndata.length > 0) {
1065                 // The easiest way to bubble the revert reason is using memory via assembly
1066 
1067                 assembly {
1068                     let returndata_size := mload(returndata)
1069                     revert(add(32, returndata), returndata_size)
1070                 }
1071             } else {
1072                 revert(errorMessage);
1073             }
1074         }
1075     }
1076 }
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 /**
1081  * @dev Provides information about the current execution context, including the
1082  * sender of the transaction and its data. While these are generally available
1083  * via msg.sender and msg.data, they should not be accessed in such a direct
1084  * manner, since when dealing with meta-transactions the account sending and
1085  * paying for execution may not be the actual sender (as far as an application
1086  * is concerned).
1087  *
1088  * This contract is only required for intermediate, library-like contracts.
1089  */
1090 abstract contract Context {
1091     function _msgSender() internal view virtual returns (address) {
1092         return msg.sender;
1093     }
1094 
1095     function _msgData() internal view virtual returns (bytes calldata) {
1096         return msg.data;
1097     }
1098 }
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 /**
1103  * @dev String operations.
1104  */
1105 library Strings {
1106     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1107 
1108     /**
1109      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1110      */
1111     function toString(uint256 value) internal pure returns (string memory) {
1112         // Inspired by OraclizeAPI's implementation - MIT licence
1113         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1114 
1115         if (value == 0) {
1116             return "0";
1117         }
1118         uint256 temp = value;
1119         uint256 digits;
1120         while (temp != 0) {
1121             digits++;
1122             temp /= 10;
1123         }
1124         bytes memory buffer = new bytes(digits);
1125         while (value != 0) {
1126             digits -= 1;
1127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1128             value /= 10;
1129         }
1130         return string(buffer);
1131     }
1132 
1133     /**
1134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1135      */
1136     function toHexString(uint256 value) internal pure returns (string memory) {
1137         if (value == 0) {
1138             return "0x00";
1139         }
1140         uint256 temp = value;
1141         uint256 length = 0;
1142         while (temp != 0) {
1143             length++;
1144             temp >>= 8;
1145         }
1146         return toHexString(value, length);
1147     }
1148 
1149     /**
1150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1151      */
1152     function toHexString(uint256 value, uint256 length)
1153         internal
1154         pure
1155         returns (string memory)
1156     {
1157         bytes memory buffer = new bytes(2 * length + 2);
1158         buffer[0] = "0";
1159         buffer[1] = "x";
1160         for (uint256 i = 2 * length + 1; i > 1; --i) {
1161             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1162             value >>= 4;
1163         }
1164         require(value == 0, "Strings: hex length insufficient");
1165         return string(buffer);
1166     }
1167 }
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 /**
1172  * @dev Implementation of the {IERC165} interface.
1173  *
1174  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1175  * for the additional interface id that will be supported. For example:
1176  *
1177  * ```solidity
1178  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1179  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1180  * }
1181  * ```
1182  *
1183  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1184  */
1185 abstract contract ERC165 is IERC165 {
1186     /**
1187      * @dev See {IERC165-supportsInterface}.
1188      */
1189     function supportsInterface(bytes4 interfaceId)
1190         public
1191         view
1192         virtual
1193         override
1194         returns (bool)
1195     {
1196         return interfaceId == type(IERC165).interfaceId;
1197     }
1198 }
1199 
1200 pragma solidity ^0.8.0;
1201 
1202 /**
1203  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1204  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1205  * {ERC721Enumerable}.
1206  */
1207 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1208     using Address for address;
1209     using Strings for uint256;
1210 
1211     // Token name
1212     string private _name;
1213 
1214     // Token symbol
1215     string private _symbol;
1216 
1217     // Mapping from token ID to owner address
1218     mapping(uint256 => address) private _owners;
1219 
1220     // Mapping owner address to token count
1221     mapping(address => uint256) private _balances;
1222 
1223     // Mapping from token ID to approved address
1224     mapping(uint256 => address) private _tokenApprovals;
1225 
1226     // Mapping from owner to operator approvals
1227     mapping(address => mapping(address => bool)) private _operatorApprovals;
1228 
1229     /**
1230      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1231      */
1232     constructor(string memory name_, string memory symbol_) {
1233         _name = name_;
1234         _symbol = symbol_;
1235     }
1236 
1237     /**
1238      * @dev See {IERC165-supportsInterface}.
1239      */
1240     function supportsInterface(bytes4 interfaceId)
1241         public
1242         view
1243         virtual
1244         override(ERC165, IERC165)
1245         returns (bool)
1246     {
1247         return
1248             interfaceId == type(IERC721).interfaceId ||
1249             interfaceId == type(IERC721Metadata).interfaceId ||
1250             super.supportsInterface(interfaceId);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-balanceOf}.
1255      */
1256     function balanceOf(address owner)
1257         public
1258         view
1259         virtual
1260         override
1261         returns (uint256)
1262     {
1263         require(
1264             owner != address(0),
1265             "ERC721: balance query for the zero address"
1266         );
1267         return _balances[owner];
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-ownerOf}.
1272      */
1273     function ownerOf(uint256 tokenId)
1274         public
1275         view
1276         virtual
1277         override
1278         returns (address)
1279     {
1280         address owner = _owners[tokenId];
1281         require(
1282             owner != address(0),
1283             "ERC721: owner query for nonexistent token"
1284         );
1285         return owner;
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Metadata-name}.
1290      */
1291     function name() public view virtual override returns (string memory) {
1292         return _name;
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Metadata-symbol}.
1297      */
1298     function symbol() public view virtual override returns (string memory) {
1299         return _symbol;
1300     }
1301 
1302     /**
1303      * @dev See {IERC721Metadata-tokenURI}.
1304      */
1305     function tokenURI(uint256 tokenId)
1306         public
1307         view
1308         virtual
1309         override
1310         returns (string memory)
1311     {
1312         require(
1313             _exists(tokenId),
1314             "ERC721Metadata: URI query for nonexistent token"
1315         );
1316 
1317         string memory baseURI = _baseURI();
1318         return
1319             bytes(baseURI).length > 0
1320                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1321                 : "";
1322     }
1323 
1324     /**
1325      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1326      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1327      * by default, can be overriden in child contracts.
1328      */
1329     function _baseURI() internal view virtual returns (string memory) {
1330         return "";
1331     }
1332 
1333     /**
1334      * @dev See {IERC721-approve}.
1335      */
1336     function approve(address to, uint256 tokenId) public virtual override {
1337         address owner = ERC721.ownerOf(tokenId);
1338         require(to != owner, "ERC721: approval to current owner");
1339 
1340         require(
1341             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1342             "ERC721: approve caller is not owner nor approved for all"
1343         );
1344 
1345         _approve(to, tokenId);
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-getApproved}.
1350      */
1351     function getApproved(uint256 tokenId)
1352         public
1353         view
1354         virtual
1355         override
1356         returns (address)
1357     {
1358         require(
1359             _exists(tokenId),
1360             "ERC721: approved query for nonexistent token"
1361         );
1362 
1363         return _tokenApprovals[tokenId];
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-setApprovalForAll}.
1368      */
1369     function setApprovalForAll(address operator, bool approved)
1370         public
1371         virtual
1372         override
1373     {
1374         _setApprovalForAll(_msgSender(), operator, approved);
1375     }
1376 
1377     /**
1378      * @dev See {IERC721-isApprovedForAll}.
1379      */
1380     function isApprovedForAll(address owner, address operator)
1381         public
1382         view
1383         virtual
1384         override
1385         returns (bool)
1386     {
1387         return _operatorApprovals[owner][operator];
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-transferFrom}.
1392      */
1393     function transferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) public virtual override {
1398         //solhint-disable-next-line max-line-length
1399         require(
1400             _isApprovedOrOwner(_msgSender(), tokenId),
1401             "ERC721: transfer caller is not owner nor approved"
1402         );
1403 
1404         _transfer(from, to, tokenId);
1405     }
1406 
1407     /**
1408      * @dev See {IERC721-safeTransferFrom}.
1409      */
1410     function safeTransferFrom(
1411         address from,
1412         address to,
1413         uint256 tokenId
1414     ) public virtual override {
1415         safeTransferFrom(from, to, tokenId, "");
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-safeTransferFrom}.
1420      */
1421     function safeTransferFrom(
1422         address from,
1423         address to,
1424         uint256 tokenId,
1425         bytes memory _data
1426     ) public virtual override {
1427         require(
1428             _isApprovedOrOwner(_msgSender(), tokenId),
1429             "ERC721: transfer caller is not owner nor approved"
1430         );
1431         _safeTransfer(from, to, tokenId, _data);
1432     }
1433 
1434     /**
1435      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1436      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1437      *
1438      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1439      *
1440      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1441      * implement alternative mechanisms to perform token transfer, such as signature-based.
1442      *
1443      * Requirements:
1444      *
1445      * - `from` cannot be the zero address.
1446      * - `to` cannot be the zero address.
1447      * - `tokenId` token must exist and be owned by `from`.
1448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1449      *
1450      * Emits a {Transfer} event.
1451      */
1452     function _safeTransfer(
1453         address from,
1454         address to,
1455         uint256 tokenId,
1456         bytes memory _data
1457     ) internal virtual {
1458         _transfer(from, to, tokenId);
1459         require(
1460             _checkOnERC721Received(from, to, tokenId, _data),
1461             "ERC721: transfer to non ERC721Receiver implementer"
1462         );
1463     }
1464 
1465     /**
1466      * @dev Returns whether `tokenId` exists.
1467      *
1468      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1469      *
1470      * Tokens start existing when they are minted (`_mint`),
1471      * and stop existing when they are burned (`_burn`).
1472      */
1473     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1474         return _owners[tokenId] != address(0);
1475     }
1476 
1477     /**
1478      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1479      *
1480      * Requirements:
1481      *
1482      * - `tokenId` must exist.
1483      */
1484     function _isApprovedOrOwner(address spender, uint256 tokenId)
1485         internal
1486         view
1487         virtual
1488         returns (bool)
1489     {
1490         require(
1491             _exists(tokenId),
1492             "ERC721: operator query for nonexistent token"
1493         );
1494         address owner = ERC721.ownerOf(tokenId);
1495         return (spender == owner ||
1496             getApproved(tokenId) == spender ||
1497             isApprovedForAll(owner, spender));
1498     }
1499 
1500     /**
1501      * @dev Safely mints `tokenId` and transfers it to `to`.
1502      *
1503      * Requirements:
1504      *
1505      * - `tokenId` must not exist.
1506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function _safeMint(address to, uint256 tokenId) internal virtual {
1511         _safeMint(to, tokenId, "");
1512     }
1513 
1514     /**
1515      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1516      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1517      */
1518     function _safeMint(
1519         address to,
1520         uint256 tokenId,
1521         bytes memory _data
1522     ) internal virtual {
1523         _mint(to, tokenId);
1524         require(
1525             _checkOnERC721Received(address(0), to, tokenId, _data),
1526             "ERC721: transfer to non ERC721Receiver implementer"
1527         );
1528     }
1529 
1530     /**
1531      * @dev Mints `tokenId` and transfers it to `to`.
1532      *
1533      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1534      *
1535      * Requirements:
1536      *
1537      * - `tokenId` must not exist.
1538      * - `to` cannot be the zero address.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _mint(address to, uint256 tokenId) internal virtual {
1543         require(to != address(0), "ERC721: mint to the zero address");
1544         require(!_exists(tokenId), "ERC721: token already minted");
1545 
1546         _beforeTokenTransfer(address(0), to, tokenId);
1547 
1548         _balances[to] += 1;
1549         _owners[tokenId] = to;
1550 
1551         emit Transfer(address(0), to, tokenId);
1552     }
1553 
1554     /**
1555      * @dev Destroys `tokenId`.
1556      * The approval is cleared when the token is burned.
1557      *
1558      * Requirements:
1559      *
1560      * - `tokenId` must exist.
1561      *
1562      * Emits a {Transfer} event.
1563      */
1564     function _burn(uint256 tokenId) internal virtual {
1565         address owner = ERC721.ownerOf(tokenId);
1566 
1567         _beforeTokenTransfer(owner, address(0), tokenId);
1568 
1569         // Clear approvals
1570         _approve(address(0), tokenId);
1571 
1572         _balances[owner] -= 1;
1573         delete _owners[tokenId];
1574 
1575         emit Transfer(owner, address(0), tokenId);
1576     }
1577 
1578     /**
1579      * @dev Transfers `tokenId` from `from` to `to`.
1580      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1581      *
1582      * Requirements:
1583      *
1584      * - `to` cannot be the zero address.
1585      * - `tokenId` token must be owned by `from`.
1586      *
1587      * Emits a {Transfer} event.
1588      */
1589     function _transfer(
1590         address from,
1591         address to,
1592         uint256 tokenId
1593     ) internal virtual {
1594         require(
1595             ERC721.ownerOf(tokenId) == from,
1596             "ERC721: transfer of token that is not own"
1597         );
1598         require(to != address(0), "ERC721: transfer to the zero address");
1599 
1600         _beforeTokenTransfer(from, to, tokenId);
1601 
1602         // Clear approvals from the previous owner
1603         _approve(address(0), tokenId);
1604 
1605         _balances[from] -= 1;
1606         _balances[to] += 1;
1607         _owners[tokenId] = to;
1608 
1609         emit Transfer(from, to, tokenId);
1610     }
1611 
1612     /**
1613      * @dev Approve `to` to operate on `tokenId`
1614      *
1615      * Emits a {Approval} event.
1616      */
1617     function _approve(address to, uint256 tokenId) internal virtual {
1618         _tokenApprovals[tokenId] = to;
1619         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1620     }
1621 
1622     /**
1623      * @dev Approve `operator` to operate on all of `owner` tokens
1624      *
1625      * Emits a {ApprovalForAll} event.
1626      */
1627     function _setApprovalForAll(
1628         address owner,
1629         address operator,
1630         bool approved
1631     ) internal virtual {
1632         require(owner != operator, "ERC721: approve to caller");
1633         _operatorApprovals[owner][operator] = approved;
1634         emit ApprovalForAll(owner, operator, approved);
1635     }
1636 
1637     /**
1638      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1639      * The call is not executed if the target address is not a contract.
1640      *
1641      * @param from address representing the previous owner of the given token ID
1642      * @param to target address that will receive the tokens
1643      * @param tokenId uint256 ID of the token to be transferred
1644      * @param _data bytes optional data to send along with the call
1645      * @return bool whether the call correctly returned the expected magic value
1646      */
1647     function _checkOnERC721Received(
1648         address from,
1649         address to,
1650         uint256 tokenId,
1651         bytes memory _data
1652     ) private returns (bool) {
1653         if (to.isContract()) {
1654             try
1655                 IERC721Receiver(to).onERC721Received(
1656                     _msgSender(),
1657                     from,
1658                     tokenId,
1659                     _data
1660                 )
1661             returns (bytes4 retval) {
1662                 return retval == IERC721Receiver.onERC721Received.selector;
1663             } catch (bytes memory reason) {
1664                 if (reason.length == 0) {
1665                     revert(
1666                         "ERC721: transfer to non ERC721Receiver implementer"
1667                     );
1668                 } else {
1669                     assembly {
1670                         revert(add(32, reason), mload(reason))
1671                     }
1672                 }
1673             }
1674         } else {
1675             return true;
1676         }
1677     }
1678 
1679     /**
1680      * @dev Hook that is called before any token transfer. This includes minting
1681      * and burning.
1682      *
1683      * Calling conditions:
1684      *
1685      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1686      * transferred to `to`.
1687      * - When `from` is zero, `tokenId` will be minted for `to`.
1688      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1689      * - `from` and `to` are never both zero.
1690      *
1691      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1692      */
1693     function _beforeTokenTransfer(
1694         address from,
1695         address to,
1696         uint256 tokenId
1697     ) internal virtual {}
1698 }
1699 
1700 pragma solidity ^0.8.0;
1701 
1702 /**
1703  * @dev Contract module that allows children to implement role-based access
1704  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1705  * members except through off-chain means by accessing the contract event logs. Some
1706  * applications may benefit from on-chain enumerability, for those cases see
1707  * {AccessControlEnumerable}.
1708  *
1709  * Roles are referred to by their `bytes32` identifier. These should be exposed
1710  * in the external API and be unique. The best way to achieve this is by
1711  * using `public constant` hash digests:
1712  *
1713  * ```
1714  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1715  * ```
1716  *
1717  * Roles can be used to represent a set of permissions. To restrict access to a
1718  * function call, use {hasRole}:
1719  *
1720  * ```
1721  * function foo() public {
1722  *     require(hasRole(MY_ROLE, msg.sender));
1723  *     ...
1724  * }
1725  * ```
1726  *
1727  * Roles can be granted and revoked dynamically via the {grantRole} and
1728  * {revokeRole} functions. Each role has an associated admin role, and only
1729  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1730  *
1731  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1732  * that only accounts with this role will be able to grant or revoke other
1733  * roles. More complex role relationships can be created by using
1734  * {_setRoleAdmin}.
1735  *
1736  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1737  * grant and revoke this role. Extra precautions should be taken to secure
1738  * accounts that have been granted it.
1739  */
1740 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1741     struct RoleData {
1742         mapping(address => bool) members;
1743         bytes32 adminRole;
1744     }
1745 
1746     mapping(bytes32 => RoleData) private _roles;
1747 
1748     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1749 
1750     /**
1751      * @dev Modifier that checks that an account has a specific role. Reverts
1752      * with a standardized message including the required role.
1753      *
1754      * The format of the revert reason is given by the following regular expression:
1755      *
1756      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1757      *
1758      * _Available since v4.1._
1759      */
1760     modifier onlyRole(bytes32 role) {
1761         _checkRole(role, _msgSender());
1762         _;
1763     }
1764 
1765     /**
1766      * @dev See {IERC165-supportsInterface}.
1767      */
1768     function supportsInterface(bytes4 interfaceId)
1769         public
1770         view
1771         virtual
1772         override
1773         returns (bool)
1774     {
1775         return
1776             interfaceId == type(IAccessControl).interfaceId ||
1777             super.supportsInterface(interfaceId);
1778     }
1779 
1780     /**
1781      * @dev Returns `true` if `account` has been granted `role`.
1782      */
1783     function hasRole(bytes32 role, address account)
1784         public
1785         view
1786         virtual
1787         override
1788         returns (bool)
1789     {
1790         return _roles[role].members[account];
1791     }
1792 
1793     /**
1794      * @dev Revert with a standard message if `account` is missing `role`.
1795      *
1796      * The format of the revert reason is given by the following regular expression:
1797      *
1798      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1799      */
1800     function _checkRole(bytes32 role, address account) internal view virtual {
1801         if (!hasRole(role, account)) {
1802             revert(
1803                 string(
1804                     abi.encodePacked(
1805                         "AccessControl: account ",
1806                         Strings.toHexString(uint160(account), 20),
1807                         " is missing role ",
1808                         Strings.toHexString(uint256(role), 32)
1809                     )
1810                 )
1811             );
1812         }
1813     }
1814 
1815     /**
1816      * @dev Returns the admin role that controls `role`. See {grantRole} and
1817      * {revokeRole}.
1818      *
1819      * To change a role's admin, use {_setRoleAdmin}.
1820      */
1821     function getRoleAdmin(bytes32 role)
1822         public
1823         view
1824         virtual
1825         override
1826         returns (bytes32)
1827     {
1828         return _roles[role].adminRole;
1829     }
1830 
1831     /**
1832      * @dev Grants `role` to `account`.
1833      *
1834      * If `account` had not been already granted `role`, emits a {RoleGranted}
1835      * event.
1836      *
1837      * Requirements:
1838      *
1839      * - the caller must have ``role``'s admin role.
1840      */
1841     function grantRole(bytes32 role, address account)
1842         public
1843         virtual
1844         override
1845         onlyRole(getRoleAdmin(role))
1846     {
1847         _grantRole(role, account);
1848     }
1849 
1850     /**
1851      * @dev Revokes `role` from `account`.
1852      *
1853      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1854      *
1855      * Requirements:
1856      *
1857      * - the caller must have ``role``'s admin role.
1858      */
1859     function revokeRole(bytes32 role, address account)
1860         public
1861         virtual
1862         override
1863         onlyRole(getRoleAdmin(role))
1864     {
1865         _revokeRole(role, account);
1866     }
1867 
1868     /**
1869      * @dev Revokes `role` from the calling account.
1870      *
1871      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1872      * purpose is to provide a mechanism for accounts to lose their privileges
1873      * if they are compromised (such as when a trusted device is misplaced).
1874      *
1875      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1876      * event.
1877      *
1878      * Requirements:
1879      *
1880      * - the caller must be `account`.
1881      */
1882     function renounceRole(bytes32 role, address account)
1883         public
1884         virtual
1885         override
1886     {
1887         require(
1888             account == _msgSender(),
1889             "AccessControl: can only renounce roles for self"
1890         );
1891 
1892         _revokeRole(role, account);
1893     }
1894 
1895     /**
1896      * @dev Grants `role` to `account`.
1897      *
1898      * If `account` had not been already granted `role`, emits a {RoleGranted}
1899      * event. Note that unlike {grantRole}, this function doesn't perform any
1900      * checks on the calling account.
1901      *
1902      * [WARNING]
1903      * ====
1904      * This function should only be called from the constructor when setting
1905      * up the initial roles for the system.
1906      *
1907      * Using this function in any other way is effectively circumventing the admin
1908      * system imposed by {AccessControl}.
1909      * ====
1910      *
1911      * NOTE: This function is deprecated in favor of {_grantRole}.
1912      */
1913     function _setupRole(bytes32 role, address account) internal virtual {
1914         _grantRole(role, account);
1915     }
1916 
1917     /**
1918      * @dev Sets `adminRole` as ``role``'s admin role.
1919      *
1920      * Emits a {RoleAdminChanged} event.
1921      */
1922     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1923         bytes32 previousAdminRole = getRoleAdmin(role);
1924         _roles[role].adminRole = adminRole;
1925         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1926     }
1927 
1928     /**
1929      * @dev Grants `role` to `account`.
1930      *
1931      * Internal function without access restriction.
1932      */
1933     function _grantRole(bytes32 role, address account) internal virtual {
1934         if (!hasRole(role, account)) {
1935             _roles[role].members[account] = true;
1936             emit RoleGranted(role, account, _msgSender());
1937         }
1938     }
1939 
1940     /**
1941      * @dev Revokes `role` from `account`.
1942      *
1943      * Internal function without access restriction.
1944      */
1945     function _revokeRole(bytes32 role, address account) internal virtual {
1946         if (hasRole(role, account)) {
1947             _roles[role].members[account] = false;
1948             emit RoleRevoked(role, account, _msgSender());
1949         }
1950     }
1951 }
1952 
1953 pragma solidity ^0.8.0;
1954 
1955 /**
1956  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1957  * enumerability of all the token ids in the contract as well as all token ids owned by each
1958  * account.
1959  */
1960 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1961     // Mapping from owner to list of owned token IDs
1962     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1963 
1964     // Mapping from token ID to index of the owner tokens list
1965     mapping(uint256 => uint256) private _ownedTokensIndex;
1966 
1967     // Array with all token ids, used for enumeration
1968     uint256[] private _allTokens;
1969 
1970     // Mapping from token id to position in the allTokens array
1971     mapping(uint256 => uint256) private _allTokensIndex;
1972 
1973     /**
1974      * @dev See {IERC165-supportsInterface}.
1975      */
1976     function supportsInterface(bytes4 interfaceId)
1977         public
1978         view
1979         virtual
1980         override(IERC165, ERC721)
1981         returns (bool)
1982     {
1983         return
1984             interfaceId == type(IERC721Enumerable).interfaceId ||
1985             super.supportsInterface(interfaceId);
1986     }
1987 
1988     /**
1989      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1990      */
1991     function tokenOfOwnerByIndex(address owner, uint256 index)
1992         public
1993         view
1994         virtual
1995         override
1996         returns (uint256)
1997     {
1998         require(
1999             index < ERC721.balanceOf(owner),
2000             "ERC721Enumerable: owner index out of bounds"
2001         );
2002         return _ownedTokens[owner][index];
2003     }
2004 
2005     /**
2006      * @dev See {IERC721Enumerable-totalSupply}.
2007      */
2008     function totalSupply() public view virtual override returns (uint256) {
2009         return _allTokens.length;
2010     }
2011 
2012     /**
2013      * @dev See {IERC721Enumerable-tokenByIndex}.
2014      */
2015     function tokenByIndex(uint256 index)
2016         public
2017         view
2018         virtual
2019         override
2020         returns (uint256)
2021     {
2022         require(
2023             index < ERC721Enumerable.totalSupply(),
2024             "ERC721Enumerable: global index out of bounds"
2025         );
2026         return _allTokens[index];
2027     }
2028 
2029     /**
2030      * @dev Hook that is called before any token transfer. This includes minting
2031      * and burning.
2032      *
2033      * Calling conditions:
2034      *
2035      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2036      * transferred to `to`.
2037      * - When `from` is zero, `tokenId` will be minted for `to`.
2038      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2039      * - `from` cannot be the zero address.
2040      * - `to` cannot be the zero address.
2041      *
2042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2043      */
2044     function _beforeTokenTransfer(
2045         address from,
2046         address to,
2047         uint256 tokenId
2048     ) internal virtual override {
2049         super._beforeTokenTransfer(from, to, tokenId);
2050 
2051         if (from == address(0)) {
2052             _addTokenToAllTokensEnumeration(tokenId);
2053         } else if (from != to) {
2054             _removeTokenFromOwnerEnumeration(from, tokenId);
2055         }
2056         if (to == address(0)) {
2057             _removeTokenFromAllTokensEnumeration(tokenId);
2058         } else if (to != from) {
2059             _addTokenToOwnerEnumeration(to, tokenId);
2060         }
2061     }
2062 
2063     /**
2064      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2065      * @param to address representing the new owner of the given token ID
2066      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2067      */
2068     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2069         uint256 length = ERC721.balanceOf(to);
2070         _ownedTokens[to][length] = tokenId;
2071         _ownedTokensIndex[tokenId] = length;
2072     }
2073 
2074     /**
2075      * @dev Private function to add a token to this extension's token tracking data structures.
2076      * @param tokenId uint256 ID of the token to be added to the tokens list
2077      */
2078     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2079         _allTokensIndex[tokenId] = _allTokens.length;
2080         _allTokens.push(tokenId);
2081     }
2082 
2083     /**
2084      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2085      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2086      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2087      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2088      * @param from address representing the previous owner of the given token ID
2089      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2090      */
2091     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
2092         private
2093     {
2094         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2095         // then delete the last slot (swap and pop).
2096 
2097         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2098         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2099 
2100         // When the token to delete is the last token, the swap operation is unnecessary
2101         if (tokenIndex != lastTokenIndex) {
2102             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2103 
2104             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2105             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2106         }
2107 
2108         // This also deletes the contents at the last position of the array
2109         delete _ownedTokensIndex[tokenId];
2110         delete _ownedTokens[from][lastTokenIndex];
2111     }
2112 
2113     /**
2114      * @dev Private function to remove a token from this extension's token tracking data structures.
2115      * This has O(1) time complexity, but alters the order of the _allTokens array.
2116      * @param tokenId uint256 ID of the token to be removed from the tokens list
2117      */
2118     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2119         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2120         // then delete the last slot (swap and pop).
2121 
2122         uint256 lastTokenIndex = _allTokens.length - 1;
2123         uint256 tokenIndex = _allTokensIndex[tokenId];
2124 
2125         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2126         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2127         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2128         uint256 lastTokenId = _allTokens[lastTokenIndex];
2129 
2130         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2131         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2132 
2133         // This also deletes the contents at the last position of the array
2134         delete _allTokensIndex[tokenId];
2135         _allTokens.pop();
2136     }
2137 }
2138 
2139 pragma solidity ^0.8.0;
2140 
2141 /**
2142  * @dev Contract module which provides a basic access control mechanism, where
2143  * there is an account (an owner) that can be granted exclusive access to
2144  * specific functions.
2145  *
2146  * By default, the owner account will be the one that deploys the contract. This
2147  * can later be changed with {transferOwnership}.
2148  *
2149  * This module is used through inheritance. It will make available the modifier
2150  * `onlyOwner`, which can be applied to your functions to restrict their use to
2151  * the owner.
2152  */
2153 abstract contract Ownable is Context {
2154     address private _owner;
2155 
2156     event OwnershipTransferred(
2157         address indexed previousOwner,
2158         address indexed newOwner
2159     );
2160 
2161     /**
2162      * @dev Initializes the contract setting the deployer as the initial owner.
2163      */
2164     constructor() {
2165         _transferOwnership(_msgSender());
2166     }
2167 
2168     /**
2169      * @dev Returns the address of the current owner.
2170      */
2171     function owner() public view virtual returns (address) {
2172         return _owner;
2173     }
2174 
2175     /**
2176      * @dev Throws if called by any account other than the owner.
2177      */
2178     modifier onlyOwner() {
2179         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2180         _;
2181     }
2182 
2183     /**
2184      * @dev Leaves the contract without owner. It will not be possible to call
2185      * `onlyOwner` functions anymore. Can only be called by the current owner.
2186      *
2187      * NOTE: Renouncing ownership will leave the contract without an owner,
2188      * thereby removing any functionality that is only available to the owner.
2189      */
2190     function renounceOwnership() public virtual onlyOwner {
2191         _transferOwnership(address(0));
2192     }
2193 
2194     /**
2195      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2196      * Can only be called by the current owner.
2197      */
2198     function transferOwnership(address newOwner) public virtual onlyOwner {
2199         require(
2200             newOwner != address(0),
2201             "Ownable: new owner is the zero address"
2202         );
2203         _transferOwnership(newOwner);
2204     }
2205 
2206     /**
2207      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2208      * Internal function without access restriction.
2209      */
2210     function _transferOwnership(address newOwner) internal virtual {
2211         address oldOwner = _owner;
2212         _owner = newOwner;
2213         emit OwnershipTransferred(oldOwner, newOwner);
2214     }
2215 }
2216 
2217 pragma solidity ^0.8.0;
2218 
2219 /**
2220  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2221  */
2222 abstract contract AccessControlEnumerable is
2223     IAccessControlEnumerable,
2224     AccessControl
2225 {
2226     using EnumerableSet for EnumerableSet.AddressSet;
2227 
2228     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2229 
2230     /**
2231      * @dev See {IERC165-supportsInterface}.
2232      */
2233     function supportsInterface(bytes4 interfaceId)
2234         public
2235         view
2236         virtual
2237         override
2238         returns (bool)
2239     {
2240         return
2241             interfaceId == type(IAccessControlEnumerable).interfaceId ||
2242             super.supportsInterface(interfaceId);
2243     }
2244 
2245     /**
2246      * @dev Returns one of the accounts that have `role`. `index` must be a
2247      * value between 0 and {getRoleMemberCount}, non-inclusive.
2248      *
2249      * Role bearers are not sorted in any particular way, and their ordering may
2250      * change at any point.
2251      *
2252      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2253      * you perform all queries on the same block. See the following
2254      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2255      * for more information.
2256      */
2257     function getRoleMember(bytes32 role, uint256 index)
2258         public
2259         view
2260         virtual
2261         override
2262         returns (address)
2263     {
2264         return _roleMembers[role].at(index);
2265     }
2266 
2267     /**
2268      * @dev Returns the number of accounts that have `role`. Can be used
2269      * together with {getRoleMember} to enumerate all bearers of a role.
2270      */
2271     function getRoleMemberCount(bytes32 role)
2272         public
2273         view
2274         virtual
2275         override
2276         returns (uint256)
2277     {
2278         return _roleMembers[role].length();
2279     }
2280 
2281     /**
2282      * @dev Overload {_grantRole} to track enumerable memberships
2283      */
2284     function _grantRole(bytes32 role, address account)
2285         internal
2286         virtual
2287         override
2288     {
2289         super._grantRole(role, account);
2290         _roleMembers[role].add(account);
2291     }
2292 
2293     /**
2294      * @dev Overload {_revokeRole} to track enumerable memberships
2295      */
2296     function _revokeRole(bytes32 role, address account)
2297         internal
2298         virtual
2299         override
2300     {
2301         super._revokeRole(role, account);
2302         _roleMembers[role].remove(account);
2303     }
2304 }
2305 
2306 pragma solidity ^0.8.0;
2307 
2308 /**
2309  * @dev Contract module that helps prevent reentrant calls to a function.
2310  *
2311  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2312  * available, which can be applied to functions to make sure there are no nested
2313  * (reentrant) calls to them.
2314  *
2315  * Note that because there is a single `nonReentrant` guard, functions marked as
2316  * `nonReentrant` may not call one another. This can be worked around by making
2317  * those functions `private`, and then adding `external` `nonReentrant` entry
2318  * points to them.
2319  *
2320  * TIP: If you would like to learn more about reentrancy and alternative ways
2321  * to protect against it, check out our blog post
2322  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2323  */
2324 abstract contract ReentrancyGuard {
2325     // Booleans are more expensive than uint256 or any type that takes up a full
2326     // word because each write operation emits an extra SLOAD to first read the
2327     // slot's contents, replace the bits taken up by the boolean, and then write
2328     // back. This is the compiler's defense against contract upgrades and
2329     // pointer aliasing, and it cannot be disabled.
2330 
2331     // The values being non-zero value makes deployment a bit more expensive,
2332     // but in exchange the refund on every call to nonReentrant will be lower in
2333     // amount. Since refunds are capped to a percentage of the total
2334     // transaction's gas, it is best to keep them low in cases like this one, to
2335     // increase the likelihood of the full refund coming into effect.
2336     uint256 private constant _NOT_ENTERED = 1;
2337     uint256 private constant _ENTERED = 2;
2338 
2339     uint256 private _status;
2340 
2341     constructor() {
2342         _status = _NOT_ENTERED;
2343     }
2344 
2345     /**
2346      * @dev Prevents a contract from calling itself, directly or indirectly.
2347      * Calling a `nonReentrant` function from another `nonReentrant`
2348      * function is not supported. It is possible to prevent this from happening
2349      * by making the `nonReentrant` function external, and making it call a
2350      * `private` function that does the actual work.
2351      */
2352     modifier nonReentrant() {
2353         // On the first call to nonReentrant, _notEntered will be true
2354         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2355 
2356         // Any calls to nonReentrant after this point will fail
2357         _status = _ENTERED;
2358 
2359         _;
2360 
2361         // By storing the original value once again, a refund is triggered (see
2362         // https://eips.ethereum.org/EIPS/eip-2200)
2363         _status = _NOT_ENTERED;
2364     }
2365 }
2366 
2367 pragma solidity ^0.8.4;
2368 
2369 error ApprovalCallerNotOwnerNorApproved();
2370 error ApprovalQueryForNonexistentToken();
2371 error ApproveToCaller();
2372 error ApprovalToCurrentOwner();
2373 error BalanceQueryForZeroAddress();
2374 error MintToZeroAddress();
2375 error MintZeroQuantity();
2376 error OwnerQueryForNonexistentToken();
2377 error TransferCallerNotOwnerNorApproved();
2378 error TransferFromIncorrectOwner();
2379 error TransferToNonERC721ReceiverImplementer();
2380 error TransferToZeroAddress();
2381 error URIQueryForNonexistentToken();
2382 
2383 /**
2384  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2385  * the Metadata extension. Built to optimize for lower gas during batch mints.
2386  *
2387  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2388  *
2389  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2390  *
2391  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2392  */
2393 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2394     using Address for address;
2395     using Strings for uint256;
2396 
2397     // Compiler will pack this into a single 256bit word.
2398     struct TokenOwnership {
2399         // The address of the owner.
2400         address addr;
2401         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2402         uint64 startTimestamp;
2403         // Whether the token has been burned.
2404         bool burned;
2405     }
2406 
2407     // Compiler will pack this into a single 256bit word.
2408     struct AddressData {
2409         // Realistically, 2**64-1 is more than enough.
2410         uint64 balance;
2411         // Keeps track of mint count with minimal overhead for tokenomics.
2412         uint64 numberMinted;
2413         // Keeps track of burn count with minimal overhead for tokenomics.
2414         uint64 numberBurned;
2415         // For miscellaneous variable(s) pertaining to the address
2416         // (e.g. number of whitelist mint slots used).
2417         // If there are multiple variables, please pack them into a uint64.
2418         uint64 aux;
2419     }
2420 
2421     // The tokenId of the next token to be minted.
2422     uint256 internal _currentIndex;
2423 
2424     // The number of tokens burned.
2425     uint256 internal _burnCounter;
2426 
2427     // Token name
2428     string private _name;
2429 
2430     // Token symbol
2431     string private _symbol;
2432 
2433     // Mapping from token ID to ownership details
2434     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2435     mapping(uint256 => TokenOwnership) internal _ownerships;
2436 
2437     // Mapping owner address to address data
2438     mapping(address => AddressData) private _addressData;
2439 
2440     // Mapping from token ID to approved address
2441     mapping(uint256 => address) private _tokenApprovals;
2442 
2443     // Mapping from owner to operator approvals
2444     mapping(address => mapping(address => bool)) private _operatorApprovals;
2445 
2446     constructor(string memory name_, string memory symbol_) {
2447         _name = name_;
2448         _symbol = symbol_;
2449         _currentIndex = _startTokenId();
2450     }
2451 
2452     /**
2453      * To change the starting tokenId, please override this function.
2454      */
2455     function _startTokenId() internal view virtual returns (uint256) {
2456         return 0;
2457     }
2458 
2459     /**
2460      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2461      */
2462     function totalSupply() public view returns (uint256) {
2463         // Counter underflow is impossible as _burnCounter cannot be incremented
2464         // more than _currentIndex - _startTokenId() times
2465         unchecked {
2466             return _currentIndex - _burnCounter - _startTokenId();
2467         }
2468     }
2469 
2470     /**
2471      * Returns the total amount of tokens minted in the contract.
2472      */
2473     function _totalMinted() internal view returns (uint256) {
2474         // Counter underflow is impossible as _currentIndex does not decrement,
2475         // and it is initialized to _startTokenId()
2476         unchecked {
2477             return _currentIndex - _startTokenId();
2478         }
2479     }
2480 
2481     /**
2482      * @dev See {IERC165-supportsInterface}.
2483      */
2484     function supportsInterface(bytes4 interfaceId)
2485         public
2486         view
2487         virtual
2488         override(ERC165, IERC165)
2489         returns (bool)
2490     {
2491         return
2492             interfaceId == type(IERC721).interfaceId ||
2493             interfaceId == type(IERC721Metadata).interfaceId ||
2494             super.supportsInterface(interfaceId);
2495     }
2496 
2497     /**
2498      * @dev See {IERC721-balanceOf}.
2499      */
2500     function balanceOf(address owner) public view override returns (uint256) {
2501         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2502         return uint256(_addressData[owner].balance);
2503     }
2504 
2505     /**
2506      * Returns the number of tokens minted by `owner`.
2507      */
2508     function _numberMinted(address owner) internal view returns (uint256) {
2509         return uint256(_addressData[owner].numberMinted);
2510     }
2511 
2512     /**
2513      * Returns the number of tokens burned by or on behalf of `owner`.
2514      */
2515     function _numberBurned(address owner) internal view returns (uint256) {
2516         return uint256(_addressData[owner].numberBurned);
2517     }
2518 
2519     /**
2520      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2521      */
2522     function _getAux(address owner) internal view returns (uint64) {
2523         return _addressData[owner].aux;
2524     }
2525 
2526     /**
2527      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2528      * If there are multiple variables, please pack them into a uint64.
2529      */
2530     function _setAux(address owner, uint64 aux) internal {
2531         _addressData[owner].aux = aux;
2532     }
2533 
2534     /**
2535      * Gas spent here starts off proportional to the maximum mint batch size.
2536      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2537      */
2538     function _ownershipOf(uint256 tokenId)
2539         internal
2540         view
2541         returns (TokenOwnership memory)
2542     {
2543         uint256 curr = tokenId;
2544 
2545         unchecked {
2546             if (_startTokenId() <= curr && curr < _currentIndex) {
2547                 TokenOwnership memory ownership = _ownerships[curr];
2548                 if (!ownership.burned) {
2549                     if (ownership.addr != address(0)) {
2550                         return ownership;
2551                     }
2552                     // Invariant:
2553                     // There will always be an ownership that has an address and is not burned
2554                     // before an ownership that does not have an address and is not burned.
2555                     // Hence, curr will not underflow.
2556                     while (true) {
2557                         curr--;
2558                         ownership = _ownerships[curr];
2559                         if (ownership.addr != address(0)) {
2560                             return ownership;
2561                         }
2562                     }
2563                 }
2564             }
2565         }
2566         revert OwnerQueryForNonexistentToken();
2567     }
2568 
2569     /**
2570      * @dev See {IERC721-ownerOf}.
2571      */
2572     function ownerOf(uint256 tokenId) public view override returns (address) {
2573         return _ownershipOf(tokenId).addr;
2574     }
2575 
2576     /**
2577      * @dev See {IERC721Metadata-name}.
2578      */
2579     function name() public view virtual override returns (string memory) {
2580         return _name;
2581     }
2582 
2583     /**
2584      * @dev See {IERC721Metadata-symbol}.
2585      */
2586     function symbol() public view virtual override returns (string memory) {
2587         return _symbol;
2588     }
2589 
2590     /**
2591      * @dev See {IERC721Metadata-tokenURI}.
2592      */
2593     function tokenURI(uint256 tokenId)
2594         public
2595         view
2596         virtual
2597         override
2598         returns (string memory)
2599     {
2600         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2601 
2602         string memory baseURI = _baseURI();
2603         return
2604             bytes(baseURI).length != 0
2605                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2606                 : "";
2607     }
2608 
2609     /**
2610      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2611      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2612      * by default, can be overriden in child contracts.
2613      */
2614     function _baseURI() internal view virtual returns (string memory) {
2615         return "";
2616     }
2617 
2618     /**
2619      * @dev See {IERC721-approve}.
2620      */
2621     function approve(address to, uint256 tokenId) public virtual override {
2622         address owner = ERC721A.ownerOf(tokenId);
2623         if (to == owner) revert ApprovalToCurrentOwner();
2624 
2625         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2626             revert ApprovalCallerNotOwnerNorApproved();
2627         }
2628 
2629         _approve(to, tokenId, owner);
2630     }
2631 
2632     /**
2633      * @dev See {IERC721-getApproved}.
2634      */
2635     function getApproved(uint256 tokenId)
2636         public
2637         view
2638         override
2639         returns (address)
2640     {
2641         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2642 
2643         return _tokenApprovals[tokenId];
2644     }
2645 
2646     /**
2647      * @dev See {IERC721-setApprovalForAll}.
2648      */
2649     function setApprovalForAll(address operator, bool approved)
2650         public
2651         virtual
2652         override
2653     {
2654         if (operator == _msgSender()) revert ApproveToCaller();
2655 
2656         _operatorApprovals[_msgSender()][operator] = approved;
2657         emit ApprovalForAll(_msgSender(), operator, approved);
2658     }
2659 
2660     /**
2661      * @dev See {IERC721-isApprovedForAll}.
2662      */
2663     function isApprovedForAll(address owner, address operator)
2664         public
2665         view
2666         virtual
2667         override
2668         returns (bool)
2669     {
2670         return _operatorApprovals[owner][operator];
2671     }
2672 
2673     /**
2674      * @dev See {IERC721-transferFrom}.
2675      */
2676     function transferFrom(
2677         address from,
2678         address to,
2679         uint256 tokenId
2680     ) public virtual override {
2681         _transfer(from, to, tokenId);
2682     }
2683 
2684     /**
2685      * @dev See {IERC721-safeTransferFrom}.
2686      */
2687     function safeTransferFrom(
2688         address from,
2689         address to,
2690         uint256 tokenId
2691     ) public virtual override {
2692         safeTransferFrom(from, to, tokenId, "");
2693     }
2694 
2695     /**
2696      * @dev See {IERC721-safeTransferFrom}.
2697      */
2698     function safeTransferFrom(
2699         address from,
2700         address to,
2701         uint256 tokenId,
2702         bytes memory _data
2703     ) public virtual override {
2704         _transfer(from, to, tokenId);
2705         if (
2706             to.isContract() &&
2707             !_checkContractOnERC721Received(from, to, tokenId, _data)
2708         ) {
2709             revert TransferToNonERC721ReceiverImplementer();
2710         }
2711     }
2712 
2713     /**
2714      * @dev Returns whether `tokenId` exists.
2715      *
2716      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2717      *
2718      * Tokens start existing when they are minted (`_mint`),
2719      */
2720     function _exists(uint256 tokenId) internal view returns (bool) {
2721         return
2722             _startTokenId() <= tokenId &&
2723             tokenId < _currentIndex &&
2724             !_ownerships[tokenId].burned;
2725     }
2726 
2727     function _safeMint(address to, uint256 quantity) internal {
2728         _safeMint(to, quantity, "");
2729     }
2730 
2731     /**
2732      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2733      *
2734      * Requirements:
2735      *
2736      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2737      * - `quantity` must be greater than 0.
2738      *
2739      * Emits a {Transfer} event.
2740      */
2741     function _safeMint(
2742         address to,
2743         uint256 quantity,
2744         bytes memory _data
2745     ) internal {
2746         _mint(to, quantity, _data, true);
2747     }
2748 
2749     /**
2750      * @dev Mints `quantity` tokens and transfers them to `to`.
2751      *
2752      * Requirements:
2753      *
2754      * - `to` cannot be the zero address.
2755      * - `quantity` must be greater than 0.
2756      *
2757      * Emits a {Transfer} event.
2758      */
2759     function _mint(
2760         address to,
2761         uint256 quantity,
2762         bytes memory _data,
2763         bool safe
2764     ) internal {
2765         uint256 startTokenId = _currentIndex;
2766         if (to == address(0)) revert MintToZeroAddress();
2767         if (quantity == 0) revert MintZeroQuantity();
2768 
2769         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2770 
2771         // Overflows are incredibly unrealistic.
2772         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2773         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2774         unchecked {
2775             _addressData[to].balance += uint64(quantity);
2776             _addressData[to].numberMinted += uint64(quantity);
2777 
2778             _ownerships[startTokenId].addr = to;
2779             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2780 
2781             uint256 updatedIndex = startTokenId;
2782             uint256 end = updatedIndex + quantity;
2783 
2784             if (safe && to.isContract()) {
2785                 do {
2786                     emit Transfer(address(0), to, updatedIndex);
2787                     if (
2788                         !_checkContractOnERC721Received(
2789                             address(0),
2790                             to,
2791                             updatedIndex++,
2792                             _data
2793                         )
2794                     ) {
2795                         revert TransferToNonERC721ReceiverImplementer();
2796                     }
2797                 } while (updatedIndex != end);
2798                 // Reentrancy protection
2799                 if (_currentIndex != startTokenId) revert();
2800             } else {
2801                 do {
2802                     emit Transfer(address(0), to, updatedIndex++);
2803                 } while (updatedIndex != end);
2804             }
2805             _currentIndex = updatedIndex;
2806         }
2807         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2808     }
2809 
2810     /**
2811      * @dev Transfers `tokenId` from `from` to `to`.
2812      *
2813      * Requirements:
2814      *
2815      * - `to` cannot be the zero address.
2816      * - `tokenId` token must be owned by `from`.
2817      *
2818      * Emits a {Transfer} event.
2819      */
2820     function _transfer(
2821         address from,
2822         address to,
2823         uint256 tokenId
2824     ) private {
2825         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2826 
2827         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2828 
2829         bool isApprovedOrOwner = (_msgSender() == from ||
2830             isApprovedForAll(from, _msgSender()) ||
2831             getApproved(tokenId) == _msgSender());
2832 
2833         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2834         if (to == address(0)) revert TransferToZeroAddress();
2835 
2836         _beforeTokenTransfers(from, to, tokenId, 1);
2837 
2838         // Clear approvals from the previous owner
2839         _approve(address(0), tokenId, from);
2840 
2841         // Underflow of the sender's balance is impossible because we check for
2842         // ownership above and the recipient's balance can't realistically overflow.
2843         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2844         unchecked {
2845             _addressData[from].balance -= 1;
2846             _addressData[to].balance += 1;
2847 
2848             TokenOwnership storage currSlot = _ownerships[tokenId];
2849             currSlot.addr = to;
2850             currSlot.startTimestamp = uint64(block.timestamp);
2851 
2852             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2853             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2854             uint256 nextTokenId = tokenId + 1;
2855             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2856             if (nextSlot.addr == address(0)) {
2857                 // This will suffice for checking _exists(nextTokenId),
2858                 // as a burned slot cannot contain the zero address.
2859                 if (nextTokenId != _currentIndex) {
2860                     nextSlot.addr = from;
2861                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2862                 }
2863             }
2864         }
2865 
2866         emit Transfer(from, to, tokenId);
2867         _afterTokenTransfers(from, to, tokenId, 1);
2868     }
2869 
2870     /**
2871      * @dev This is equivalent to _burn(tokenId, false)
2872      */
2873     function _burn(uint256 tokenId) internal virtual {
2874         _burn(tokenId, false);
2875     }
2876 
2877     /**
2878      * @dev Destroys `tokenId`.
2879      * The approval is cleared when the token is burned.
2880      *
2881      * Requirements:
2882      *
2883      * - `tokenId` must exist.
2884      *
2885      * Emits a {Transfer} event.
2886      */
2887     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2888         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2889 
2890         address from = prevOwnership.addr;
2891 
2892         if (approvalCheck) {
2893             bool isApprovedOrOwner = (_msgSender() == from ||
2894                 isApprovedForAll(from, _msgSender()) ||
2895                 getApproved(tokenId) == _msgSender());
2896 
2897             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2898         }
2899 
2900         _beforeTokenTransfers(from, address(0), tokenId, 1);
2901 
2902         // Clear approvals from the previous owner
2903         _approve(address(0), tokenId, from);
2904 
2905         // Underflow of the sender's balance is impossible because we check for
2906         // ownership above and the recipient's balance can't realistically overflow.
2907         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2908         unchecked {
2909             AddressData storage addressData = _addressData[from];
2910             addressData.balance -= 1;
2911             addressData.numberBurned += 1;
2912 
2913             // Keep track of who burned the token, and the timestamp of burning.
2914             TokenOwnership storage currSlot = _ownerships[tokenId];
2915             currSlot.addr = from;
2916             currSlot.startTimestamp = uint64(block.timestamp);
2917             currSlot.burned = true;
2918 
2919             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2920             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2921             uint256 nextTokenId = tokenId + 1;
2922             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2923             if (nextSlot.addr == address(0)) {
2924                 // This will suffice for checking _exists(nextTokenId),
2925                 // as a burned slot cannot contain the zero address.
2926                 if (nextTokenId != _currentIndex) {
2927                     nextSlot.addr = from;
2928                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2929                 }
2930             }
2931         }
2932 
2933         emit Transfer(from, address(0), tokenId);
2934         _afterTokenTransfers(from, address(0), tokenId, 1);
2935 
2936         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2937         unchecked {
2938             _burnCounter++;
2939         }
2940     }
2941 
2942     /**
2943      * @dev Approve `to` to operate on `tokenId`
2944      *
2945      * Emits a {Approval} event.
2946      */
2947     function _approve(
2948         address to,
2949         uint256 tokenId,
2950         address owner
2951     ) private {
2952         _tokenApprovals[tokenId] = to;
2953         emit Approval(owner, to, tokenId);
2954     }
2955 
2956     /**
2957      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2958      *
2959      * @param from address representing the previous owner of the given token ID
2960      * @param to target address that will receive the tokens
2961      * @param tokenId uint256 ID of the token to be transferred
2962      * @param _data bytes optional data to send along with the call
2963      * @return bool whether the call correctly returned the expected magic value
2964      */
2965     function _checkContractOnERC721Received(
2966         address from,
2967         address to,
2968         uint256 tokenId,
2969         bytes memory _data
2970     ) private returns (bool) {
2971         try
2972             IERC721Receiver(to).onERC721Received(
2973                 _msgSender(),
2974                 from,
2975                 tokenId,
2976                 _data
2977             )
2978         returns (bytes4 retval) {
2979             return retval == IERC721Receiver(to).onERC721Received.selector;
2980         } catch (bytes memory reason) {
2981             if (reason.length == 0) {
2982                 revert TransferToNonERC721ReceiverImplementer();
2983             } else {
2984                 assembly {
2985                     revert(add(32, reason), mload(reason))
2986                 }
2987             }
2988         }
2989     }
2990 
2991     /**
2992      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2993      * And also called before burning one token.
2994      *
2995      * startTokenId - the first token id to be transferred
2996      * quantity - the amount to be transferred
2997      *
2998      * Calling conditions:
2999      *
3000      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3001      * transferred to `to`.
3002      * - When `from` is zero, `tokenId` will be minted for `to`.
3003      * - When `to` is zero, `tokenId` will be burned by `from`.
3004      * - `from` and `to` are never both zero.
3005      */
3006     function _beforeTokenTransfers(
3007         address from,
3008         address to,
3009         uint256 startTokenId,
3010         uint256 quantity
3011     ) internal virtual {}
3012 
3013     /**
3014      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3015      * minting.
3016      * And also called after one token has been burned.
3017      *
3018      * startTokenId - the first token id to be transferred
3019      * quantity - the amount to be transferred
3020      *
3021      * Calling conditions:
3022      *
3023      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
3024      * transferred to `to`.
3025      * - When `from` is zero, `tokenId` has been minted for `to`.
3026      * - When `to` is zero, `tokenId` has been burned by `from`.
3027      * - `from` and `to` are never both zero.
3028      */
3029     function _afterTokenTransfers(
3030         address from,
3031         address to,
3032         uint256 startTokenId,
3033         uint256 quantity
3034     ) internal virtual {}
3035 }
3036 
3037 pragma solidity ^0.8.0;
3038 
3039 /**
3040  * @dev Interface of the ERC20 standard as defined in the EIP.
3041  */
3042 interface IERC20 {
3043     /**
3044      * @dev Emitted when `value` tokens are moved from one account (`from`) to
3045      * another (`to`).
3046      *
3047      * Note that `value` may be zero.
3048      */
3049     event Transfer(address indexed from, address indexed to, uint256 value);
3050 
3051     /**
3052      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
3053      * a call to {approve}. `value` is the new allowance.
3054      */
3055     event Approval(
3056         address indexed owner,
3057         address indexed spender,
3058         uint256 value
3059     );
3060 
3061     /**
3062      * @dev Returns the amount of tokens in existence.
3063      */
3064     function totalSupply() external view returns (uint256);
3065 
3066     /**
3067      * @dev Returns the amount of tokens owned by `account`.
3068      */
3069     function balanceOf(address account) external view returns (uint256);
3070 
3071     /**
3072      * @dev Moves `amount` tokens from the caller's account to `to`.
3073      *
3074      * Returns a boolean value indicating whether the operation succeeded.
3075      *
3076      * Emits a {Transfer} event.
3077      */
3078     function transfer(address to, uint256 amount) external returns (bool);
3079 
3080     /**
3081      * @dev Returns the remaining number of tokens that `spender` will be
3082      * allowed to spend on behalf of `owner` through {transferFrom}. This is
3083      * zero by default.
3084      *
3085      * This value changes when {approve} or {transferFrom} are called.
3086      */
3087     function allowance(address owner, address spender)
3088         external
3089         view
3090         returns (uint256);
3091 
3092     /**
3093      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
3094      *
3095      * Returns a boolean value indicating whether the operation succeeded.
3096      *
3097      * IMPORTANT: Beware that changing an allowance with this method brings the risk
3098      * that someone may use both the old and the new allowance by unfortunate
3099      * transaction ordering. One possible solution to mitigate this race
3100      * condition is to first reduce the spender's allowance to 0 and set the
3101      * desired value afterwards:
3102      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
3103      *
3104      * Emits an {Approval} event.
3105      */
3106     function approve(address spender, uint256 amount) external returns (bool);
3107 
3108     /**
3109      * @dev Moves `amount` tokens from `from` to `to` using the
3110      * allowance mechanism. `amount` is then deducted from the caller's
3111      * allowance.
3112      *
3113      * Returns a boolean value indicating whether the operation succeeded.
3114      *
3115      * Emits a {Transfer} event.
3116      */
3117     function transferFrom(
3118         address from,
3119         address to,
3120         uint256 amount
3121     ) external returns (bool);
3122 }
3123 
3124 pragma solidity ^0.8.0;
3125 
3126 /**
3127  * @title SafeERC20
3128  * @dev Wrappers around ERC20 operations that throw on failure (when the token
3129  * contract returns false). Tokens that return no value (and instead revert or
3130  * throw on failure) are also supported, non-reverting calls are assumed to be
3131  * successful.
3132  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
3133  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
3134  */
3135 library SafeERC20 {
3136     using Address for address;
3137 
3138     function safeTransfer(
3139         IERC20 token,
3140         address to,
3141         uint256 value
3142     ) internal {
3143         _callOptionalReturn(
3144             token,
3145             abi.encodeWithSelector(token.transfer.selector, to, value)
3146         );
3147     }
3148 
3149     function safeTransferFrom(
3150         IERC20 token,
3151         address from,
3152         address to,
3153         uint256 value
3154     ) internal {
3155         _callOptionalReturn(
3156             token,
3157             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
3158         );
3159     }
3160 
3161     /**
3162      * @dev Deprecated. This function has issues similar to the ones found in
3163      * {IERC20-approve}, and its usage is discouraged.
3164      *
3165      * Whenever possible, use {safeIncreaseAllowance} and
3166      * {safeDecreaseAllowance} instead.
3167      */
3168     function safeApprove(
3169         IERC20 token,
3170         address spender,
3171         uint256 value
3172     ) internal {
3173         // safeApprove should only be called when setting an initial allowance,
3174         // or when resetting it to zero. To increase and decrease it, use
3175         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
3176         require(
3177             (value == 0) || (token.allowance(address(this), spender) == 0),
3178             "SafeERC20: approve from non-zero to non-zero allowance"
3179         );
3180         _callOptionalReturn(
3181             token,
3182             abi.encodeWithSelector(token.approve.selector, spender, value)
3183         );
3184     }
3185 
3186     function safeIncreaseAllowance(
3187         IERC20 token,
3188         address spender,
3189         uint256 value
3190     ) internal {
3191         uint256 newAllowance = token.allowance(address(this), spender) + value;
3192         _callOptionalReturn(
3193             token,
3194             abi.encodeWithSelector(
3195                 token.approve.selector,
3196                 spender,
3197                 newAllowance
3198             )
3199         );
3200     }
3201 
3202     function safeDecreaseAllowance(
3203         IERC20 token,
3204         address spender,
3205         uint256 value
3206     ) internal {
3207         unchecked {
3208             uint256 oldAllowance = token.allowance(address(this), spender);
3209             require(
3210                 oldAllowance >= value,
3211                 "SafeERC20: decreased allowance below zero"
3212             );
3213             uint256 newAllowance = oldAllowance - value;
3214             _callOptionalReturn(
3215                 token,
3216                 abi.encodeWithSelector(
3217                     token.approve.selector,
3218                     spender,
3219                     newAllowance
3220                 )
3221             );
3222         }
3223     }
3224 
3225     /**
3226      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
3227      * on the return value: the return value is optional (but if data is returned, it must not be false).
3228      * @param token The token targeted by the call.
3229      * @param data The call data (encoded using abi.encode or one of its variants).
3230      */
3231     function _callOptionalReturn(IERC20 token, bytes memory data) private {
3232         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
3233         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
3234         // the target address contains contract code and also asserts for success in the low-level call.
3235 
3236         bytes memory returndata = address(token).functionCall(
3237             data,
3238             "SafeERC20: low-level call failed"
3239         );
3240         if (returndata.length > 0) {
3241             // Return data is optional
3242             require(
3243                 abi.decode(returndata, (bool)),
3244                 "SafeERC20: ERC20 operation did not succeed"
3245             );
3246         }
3247     }
3248 }
3249 
3250 pragma solidity ^0.8.0;
3251 
3252 /**
3253  * @title PaymentSplitter
3254  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
3255  * that the Ether will be split in this way, since it is handled transparently by the contract.
3256  *
3257  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
3258  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
3259  * an amount proportional to the percentage of total shares they were assigned.
3260  *
3261  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
3262  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
3263  * function.
3264  *
3265  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
3266  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
3267  * to run tests before sending real value to this contract.
3268  */
3269 contract PaymentSplitter is Context {
3270     event PayeeAdded(address account, uint256 shares);
3271     event PaymentReleased(address to, uint256 amount);
3272     event ERC20PaymentReleased(
3273         IERC20 indexed token,
3274         address to,
3275         uint256 amount
3276     );
3277     event PaymentReceived(address from, uint256 amount);
3278 
3279     uint256 private _totalShares;
3280     uint256 private _totalReleased;
3281 
3282     mapping(address => uint256) private _shares;
3283     mapping(address => uint256) private _released;
3284     address[] private _payees;
3285 
3286     mapping(IERC20 => uint256) private _erc20TotalReleased;
3287     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
3288 
3289     /**
3290      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
3291      * the matching position in the `shares` array.
3292      *
3293      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
3294      * duplicates in `payees`.
3295      */
3296     constructor(address[] memory payees, uint256[] memory shares_) payable {
3297         require(
3298             payees.length == shares_.length,
3299             "PaymentSplitter: payees and shares length mismatch"
3300         );
3301         require(payees.length > 0, "PaymentSplitter: no payees");
3302 
3303         for (uint256 i = 0; i < payees.length; i++) {
3304             _addPayee(payees[i], shares_[i]);
3305         }
3306     }
3307 
3308     /**
3309      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
3310      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
3311      * reliability of the events, and not the actual splitting of Ether.
3312      *
3313      * To learn more about this see the Solidity documentation for
3314      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
3315      * functions].
3316      */
3317     receive() external payable virtual {
3318         emit PaymentReceived(_msgSender(), msg.value);
3319     }
3320 
3321     /**
3322      * @dev Getter for the total shares held by payees.
3323      */
3324     function totalShares() public view returns (uint256) {
3325         return _totalShares;
3326     }
3327 
3328     /**
3329      * @dev Getter for the total amount of Ether already released.
3330      */
3331     function totalReleased() public view returns (uint256) {
3332         return _totalReleased;
3333     }
3334 
3335     /**
3336      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
3337      * contract.
3338      */
3339     function totalReleased(IERC20 token) public view returns (uint256) {
3340         return _erc20TotalReleased[token];
3341     }
3342 
3343     /**
3344      * @dev Getter for the amount of shares held by an account.
3345      */
3346     function shares(address account) public view returns (uint256) {
3347         return _shares[account];
3348     }
3349 
3350     /**
3351      * @dev Getter for the amount of Ether already released to a payee.
3352      */
3353     function released(address account) public view returns (uint256) {
3354         return _released[account];
3355     }
3356 
3357     /**
3358      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
3359      * IERC20 contract.
3360      */
3361     function released(IERC20 token, address account)
3362         public
3363         view
3364         returns (uint256)
3365     {
3366         return _erc20Released[token][account];
3367     }
3368 
3369     /**
3370      * @dev Getter for the address of the payee number `index`.
3371      */
3372     function payee(uint256 index) public view returns (address) {
3373         return _payees[index];
3374     }
3375 
3376     /**
3377      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
3378      * total shares and their previous withdrawals.
3379      */
3380     function release(address payable account) public virtual {
3381         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3382 
3383         uint256 totalReceived = address(this).balance + totalReleased();
3384         uint256 payment = _pendingPayment(
3385             account,
3386             totalReceived,
3387             released(account)
3388         );
3389 
3390         require(payment != 0, "PaymentSplitter: account is not due payment");
3391 
3392         _released[account] += payment;
3393         _totalReleased += payment;
3394 
3395         Address.sendValue(account, payment);
3396         emit PaymentReleased(account, payment);
3397     }
3398 
3399     /**
3400      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
3401      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
3402      * contract.
3403      */
3404     function release(IERC20 token, address account) public virtual {
3405         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3406 
3407         uint256 totalReceived = token.balanceOf(address(this)) +
3408             totalReleased(token);
3409         uint256 payment = _pendingPayment(
3410             account,
3411             totalReceived,
3412             released(token, account)
3413         );
3414 
3415         require(payment != 0, "PaymentSplitter: account is not due payment");
3416 
3417         _erc20Released[token][account] += payment;
3418         _erc20TotalReleased[token] += payment;
3419 
3420         SafeERC20.safeTransfer(token, account, payment);
3421         emit ERC20PaymentReleased(token, account, payment);
3422     }
3423 
3424     /**
3425      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
3426      * already released amounts.
3427      */
3428     function _pendingPayment(
3429         address account,
3430         uint256 totalReceived,
3431         uint256 alreadyReleased
3432     ) private view returns (uint256) {
3433         return
3434             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
3435     }
3436 
3437     /**
3438      * @dev Add a new payee to the contract.
3439      * @param account The address of the payee to add.
3440      * @param shares_ The number of shares owned by the payee.
3441      */
3442     function _addPayee(address account, uint256 shares_) private {
3443         require(
3444             account != address(0),
3445             "PaymentSplitter: account is the zero address"
3446         );
3447         require(shares_ > 0, "PaymentSplitter: shares are 0");
3448         require(
3449             _shares[account] == 0,
3450             "PaymentSplitter: account already has shares"
3451         );
3452 
3453         _payees.push(account);
3454         _shares[account] = shares_;
3455         _totalShares = _totalShares + shares_;
3456         emit PayeeAdded(account, shares_);
3457     }
3458 }
3459 pragma solidity ^0.8.0;
3460 
3461 interface IOperatorFilterRegistry {
3462     function isOperatorAllowed(address registrant, address operator)
3463         external
3464         view
3465         returns (bool);
3466 
3467     function register(address registrant) external;
3468 
3469     function registerAndSubscribe(address registrant, address subscription)
3470         external;
3471 
3472     function registerAndCopyEntries(
3473         address registrant,
3474         address registrantToCopy
3475     ) external;
3476 
3477     function unregister(address addr) external;
3478 
3479     function updateOperator(
3480         address registrant,
3481         address operator,
3482         bool filtered
3483     ) external;
3484 
3485     function updateOperators(
3486         address registrant,
3487         address[] calldata operators,
3488         bool filtered
3489     ) external;
3490 
3491     function updateCodeHash(
3492         address registrant,
3493         bytes32 codehash,
3494         bool filtered
3495     ) external;
3496 
3497     function updateCodeHashes(
3498         address registrant,
3499         bytes32[] calldata codeHashes,
3500         bool filtered
3501     ) external;
3502 
3503     function subscribe(address registrant, address registrantToSubscribe)
3504         external;
3505 
3506     function unsubscribe(address registrant, bool copyExistingEntries) external;
3507 
3508     function subscriptionOf(address addr) external returns (address registrant);
3509 
3510     function subscribers(address registrant)
3511         external
3512         returns (address[] memory);
3513 
3514     function subscriberAt(address registrant, uint256 index)
3515         external
3516         returns (address);
3517 
3518     function copyEntriesOf(address registrant, address registrantToCopy)
3519         external;
3520 
3521     function isOperatorFiltered(address registrant, address operator)
3522         external
3523         returns (bool);
3524 
3525     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
3526         external
3527         returns (bool);
3528 
3529     function isCodeHashFiltered(address registrant, bytes32 codeHash)
3530         external
3531         returns (bool);
3532 
3533     function filteredOperators(address addr)
3534         external
3535         returns (address[] memory);
3536 
3537     function filteredCodeHashes(address addr)
3538         external
3539         returns (bytes32[] memory);
3540 
3541     function filteredOperatorAt(address registrant, uint256 index)
3542         external
3543         returns (address);
3544 
3545     function filteredCodeHashAt(address registrant, uint256 index)
3546         external
3547         returns (bytes32);
3548 
3549     function isRegistered(address addr) external returns (bool);
3550 
3551     function codeHashOf(address addr) external returns (bytes32);
3552 }
3553 
3554 /**
3555  * @title  OperatorFilterer
3556  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3557  *         registrant's entries in the OperatorFilterRegistry.
3558  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3559  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3560  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3561  */
3562 abstract contract OperatorFilterer {
3563     error OperatorNotAllowed(address operator);
3564 
3565     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3566         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3567 
3568     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3569         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3570         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3571         // order for the modifier to filter addresses.
3572         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3573             if (subscribe) {
3574                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
3575                     address(this),
3576                     subscriptionOrRegistrantToCopy
3577                 );
3578             } else {
3579                 if (subscriptionOrRegistrantToCopy != address(0)) {
3580                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
3581                         address(this),
3582                         subscriptionOrRegistrantToCopy
3583                     );
3584                 } else {
3585                     OPERATOR_FILTER_REGISTRY.register(address(this));
3586                 }
3587             }
3588         }
3589     }
3590 
3591     modifier onlyAllowedOperator(address from) virtual {
3592         // Check registry code length to facilitate testing in environments without a deployed registry.
3593         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3594             // Allow spending tokens from addresses with balance
3595             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3596             // from an EOA.
3597             if (from == msg.sender) {
3598                 _;
3599                 return;
3600             }
3601             if (
3602                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
3603                     address(this),
3604                     msg.sender
3605                 )
3606             ) {
3607                 revert OperatorNotAllowed(msg.sender);
3608             }
3609         }
3610         _;
3611     }
3612 
3613     modifier onlyAllowedOperatorApproval(address operator) virtual {
3614         // Check registry code length to facilitate testing in environments without a deployed registry.
3615         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3616             if (
3617                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
3618                     address(this),
3619                     operator
3620                 )
3621             ) {
3622                 revert OperatorNotAllowed(operator);
3623             }
3624         }
3625         _;
3626     }
3627 }
3628 
3629 /**
3630  * @title  DefaultOperatorFilterer
3631  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3632  */
3633 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3634     address constant DEFAULT_SUBSCRIPTION =
3635         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3636 
3637     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3638 }
3639 
3640 contract JourneyPacks is
3641     ERC721A,
3642     ReentrancyGuard,
3643     Ownable,
3644     PaymentSplitter,
3645     DefaultOperatorFilterer
3646 {
3647     // Minting Variables
3648     uint256 public mintPrice = 0.1 ether;
3649     uint256 public maxPurchase = 10;
3650     uint256 public maxSupply = 3333;
3651 
3652     address[] public _payees = [
3653         0x7FDE663601A53A6953bbb98F1Ab87E86dEE81b35, // Liquid Payments
3654         0x867Eb0804eACA9FEeda8a0E1d2B9a32eEF58AF8f,
3655         0x0C07747AB98EE84971C90Fbd353eda207B737c43
3656     ];
3657     uint256[] private _shares = [25, 65, 10];
3658 
3659     // Sale Status
3660     bool public saleIsActive = false;
3661     bool public airdropIsActive = true;
3662 
3663     mapping(address => uint256) public addressesThatMinted;
3664 
3665     // Metadata
3666     string _baseTokenURI = "https://apeliquid.io/packs/json/";
3667     bool public locked;
3668 
3669     // Events
3670     event SaleActivation(bool isActive);
3671     event AirdropActivation(bool isActive);
3672 
3673     constructor()
3674         ERC721A("Backpacks", "PACK")
3675         PaymentSplitter(_payees, _shares)
3676     {}
3677 
3678     //Holder status validation
3679 
3680     // Minting
3681     function ownerMint(address _to, uint256 _count) external onlyOwner {
3682         require(totalSupply() + _count <= maxSupply, "SOLD OUT");
3683         _safeMint(_to, _count);
3684     }
3685 
3686     function airdrop(uint256[] calldata _counts, address[] calldata _list)
3687         external
3688         onlyOwner
3689     {
3690         require(airdropIsActive, "AIRDROP NOT ACTIVE");
3691 
3692         for (uint256 i = 0; i < _list.length; i++) {
3693             //_mint(_list[i], _dropNumber, 1, "");
3694             require(totalSupply() + _counts[i] <= maxSupply, "SOLD OUT");
3695             _safeMint(_list[i], _counts[i]);
3696         }
3697     }
3698 
3699     function mint(uint256 _count) external payable nonReentrant {
3700         require(saleIsActive, "SALE INACTIVE");
3701         require(
3702             ((addressesThatMinted[msg.sender] + _count)) <= maxPurchase,
3703             "this would exceed mint max allowance"
3704         );
3705 
3706         require(totalSupply() + _count <= maxSupply, "SOLD OUT");
3707         require(mintPrice * _count <= msg.value, "INCORRECT ETHER VALUE");
3708 
3709         _safeMint(msg.sender, _count);
3710         addressesThatMinted[msg.sender] += _count;
3711     }
3712 
3713     function toggleSaleStatus() external onlyOwner {
3714         saleIsActive = !saleIsActive;
3715         emit SaleActivation(saleIsActive);
3716     }
3717 
3718     function toggleAirdropStatus() external onlyOwner {
3719         airdropIsActive = !airdropIsActive;
3720         emit AirdropActivation(airdropIsActive);
3721     }
3722 
3723     function setMintPrice(uint256 _mintPrice) external onlyOwner {
3724         mintPrice = _mintPrice;
3725     }
3726 
3727     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
3728         maxPurchase = _maxPurchase;
3729     }
3730 
3731     function lockMetadata() external onlyOwner {
3732         locked = true;
3733     }
3734 
3735     // Payments
3736     function claim() external {
3737         release(payable(msg.sender));
3738     }
3739 
3740     function getWalletOfOwner(address owner)
3741         external
3742         view
3743         returns (uint256[] memory)
3744     {
3745         unchecked {
3746             uint256[] memory a = new uint256[](balanceOf(owner));
3747             uint256 end = _currentIndex;
3748             uint256 tokenIdsIdx;
3749             address currOwnershipAddr;
3750             for (uint256 i; i < end; i++) {
3751                 TokenOwnership memory ownership = _ownerships[i];
3752                 if (ownership.burned) {
3753                     continue;
3754                 }
3755                 if (ownership.addr != address(0)) {
3756                     currOwnershipAddr = ownership.addr;
3757                 }
3758                 if (currOwnershipAddr == owner) {
3759                     a[tokenIdsIdx++] = i;
3760                 }
3761             }
3762             return a;
3763         }
3764     }
3765 
3766     function getTotalSupply() external view returns (uint256) {
3767         return totalSupply();
3768     }
3769 
3770     function setBaseURI(string memory baseURI) external onlyOwner {
3771         require(!locked, "METADATA_LOCKED");
3772         _baseTokenURI = baseURI;
3773     }
3774 
3775     function _baseURI() internal view virtual override returns (string memory) {
3776         return _baseTokenURI;
3777     }
3778 
3779     function tokenURI(uint256 tokenId)
3780         public
3781         view
3782         override
3783         returns (string memory)
3784     {
3785         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
3786     }
3787 
3788     function _startTokenId() internal view virtual override returns (uint256) {
3789         return 1;
3790     }
3791 
3792     // OpenSea's new bullshit requirements, which violate my moral code, but
3793     // are nonetheless necessary to make this all work properly.
3794     function setApprovalForAll(address operator, bool approved)
3795         public
3796         override
3797         onlyAllowedOperatorApproval(operator)
3798     {
3799         super.setApprovalForAll(operator, approved);
3800     }
3801 
3802     function approve(address operator, uint256 tokenId)
3803         public
3804         override
3805         onlyAllowedOperatorApproval(operator)
3806     {
3807         super.approve(operator, tokenId);
3808     }
3809 
3810     function transferFrom(
3811         address from,
3812         address to,
3813         uint256 tokenId
3814     ) public override onlyAllowedOperator(from) {
3815         super.transferFrom(from, to, tokenId);
3816     }
3817 
3818     function safeTransferFrom(
3819         address from,
3820         address to,
3821         uint256 tokenId
3822     ) public override onlyAllowedOperator(from) {
3823         super.safeTransferFrom(from, to, tokenId);
3824     }
3825 
3826     function safeTransferFrom(
3827         address from,
3828         address to,
3829         uint256 tokenId,
3830         bytes memory data
3831     ) public override onlyAllowedOperator(from) {
3832         super.safeTransferFrom(from, to, tokenId, data);
3833     }
3834 }