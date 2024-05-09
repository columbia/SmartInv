1 // SPDX-License-Identifier: MIT
2 
3 /*
4    .____    .__             .__    .___  ____  __.
5    |    |   |__| ________ __|__| __| _/ |    |/ _|____ ___.__. ______
6    |    |   |  |/ ____/  |  \  |/ __ |  |      <_/ __ <   |  |/  ___/
7    |    |___|  < <_|  |  |  /  / /_/ |  |    |  \  ___/\___  |\___ \
8    |_______ \__|\__   |____/|__\____ |  |____|__ \___  > ____/____  >
9            \/      |__|             \/          \/   \/\/         \/
10      _____                .____    .__             .__    .___   .__
11     /  _  \ ______   ____ |    |   |__| ________ __|__| __| _/   |__| ____
12    /  /_\  \\____ \_/ __ \|    |   |  |/ ____/  |  \  |/ __ |    |  |/  _ \
13   /    |    \  |_> >  ___/|    |___|  < <_|  |  |  /  / /_/ |    |  (  <_> )
14   \____|__  /   __/ \___  >_______ \__|\__   |____/|__\____ | /\ |__|\____/
15           \/|__|        \/        \/      |__|             \/ \/
16 
17     ** Contract written by Aleph 0ne and using at least one NODE ********
18 */
19 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev External interface of AccessControl declared to support ERC165 detection.
25  */
26 interface IAccessControl {
27     /**
28      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
29      *
30      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
31      * {RoleAdminChanged} not being emitted signaling this.
32      *
33      * _Available since v3.1._
34      */
35     event RoleAdminChanged(
36         bytes32 indexed role,
37         bytes32 indexed previousAdminRole,
38         bytes32 indexed newAdminRole
39     );
40 
41     /**
42      * @dev Emitted when `account` is granted `role`.
43      *
44      * `sender` is the account that originated the contract call, an admin role
45      * bearer except when using {AccessControl-_setupRole}.
46      */
47     event RoleGranted(
48         bytes32 indexed role,
49         address indexed account,
50         address indexed sender
51     );
52 
53     /**
54      * @dev Emitted when `account` is revoked `role`.
55      *
56      * `sender` is the account that originated the contract call:
57      *   - if using `revokeRole`, it is the admin role bearer
58      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
59      */
60     event RoleRevoked(
61         bytes32 indexed role,
62         address indexed account,
63         address indexed sender
64     );
65 
66     /**
67      * @dev Returns `true` if `account` has been granted `role`.
68      */
69     function hasRole(bytes32 role, address account)
70         external
71         view
72         returns (bool);
73 
74     /**
75      * @dev Returns the admin role that controls `role`. See {grantRole} and
76      * {revokeRole}.
77      *
78      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
79      */
80     function getRoleAdmin(bytes32 role) external view returns (bytes32);
81 
82     /**
83      * @dev Grants `role` to `account`.
84      *
85      * If `account` had not been already granted `role`, emits a {RoleGranted}
86      * event.
87      *
88      * Requirements:
89      *
90      * - the caller must have ``role``'s admin role.
91      */
92     function grantRole(bytes32 role, address account) external;
93 
94     /**
95      * @dev Revokes `role` from `account`.
96      *
97      * If `account` had been granted `role`, emits a {RoleRevoked} event.
98      *
99      * Requirements:
100      *
101      * - the caller must have ``role``'s admin role.
102      */
103     function revokeRole(bytes32 role, address account) external;
104 
105     /**
106      * @dev Revokes `role` from the calling account.
107      *
108      * Roles are often managed via {grantRole} and {revokeRole}: this function's
109      * purpose is to provide a mechanism for accounts to lose their privileges
110      * if they are compromised (such as when a trusted device is misplaced).
111      *
112      * If the calling account had been granted `role`, emits a {RoleRevoked}
113      * event.
114      *
115      * Requirements:
116      *
117      * - the caller must be `account`.
118      */
119     function renounceRole(bytes32 role, address account) external;
120 }
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Interface of the ERC165 standard, as defined in the
126  * https://eips.ethereum.org/EIPS/eip-165[EIP].
127  *
128  * Implementers can declare support of contract interfaces, which can then be
129  * queried by others ({ERC165Checker}).
130  *
131  * For an implementation, see {ERC165}.
132  */
133 interface IERC165 {
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30 000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 }
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
149  */
150 interface IAccessControlEnumerable is IAccessControl {
151     /**
152      * @dev Returns one of the accounts that have `role`. `index` must be a
153      * value between 0 and {getRoleMemberCount}, non-inclusive.
154      *
155      * Role bearers are not sorted in any particular way, and their ordering may
156      * change at any point.
157      *
158      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
159      * you perform all queries on the same block. See the following
160      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
161      * for more information.
162      */
163     function getRoleMember(bytes32 role, uint256 index)
164         external
165         view
166         returns (address);
167 
168     /**
169      * @dev Returns the number of accounts that have `role`. Can be used
170      * together with {getRoleMember} to enumerate all bearers of a role.
171      */
172     function getRoleMemberCount(bytes32 role) external view returns (uint256);
173 }
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev Library for managing
179  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
180  * types.
181  *
182  * Sets have the following properties:
183  *
184  * - Elements are added, removed, and checked for existence in constant time
185  * (O(1)).
186  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
187  *
188  * ```
189  * contract Example {
190  *     // Add the library methods
191  *     using EnumerableSet for EnumerableSet.AddressSet;
192  *
193  *     // Declare a set state variable
194  *     EnumerableSet.AddressSet private mySet;
195  * }
196  * ```
197  *
198  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
199  * and `uint256` (`UintSet`) are supported.
200  */
201 library EnumerableSet {
202     // To implement this library for multiple types with as little code
203     // repetition as possible, we write it in terms of a generic Set type with
204     // bytes32 values.
205     // The Set implementation uses private functions, and user-facing
206     // implementations (such as AddressSet) are just wrappers around the
207     // underlying Set.
208     // This means that we can only create new EnumerableSets for types that fit
209     // in bytes32.
210 
211     struct Set {
212         // Storage of set values
213         bytes32[] _values;
214         // Position of the value in the `values` array, plus 1 because index 0
215         // means a value is not in the set.
216         mapping(bytes32 => uint256) _indexes;
217     }
218 
219     /**
220      * @dev Add a value to a set. O(1).
221      *
222      * Returns true if the value was added to the set, that is if it was not
223      * already present.
224      */
225     function _add(Set storage set, bytes32 value) private returns (bool) {
226         if (!_contains(set, value)) {
227             set._values.push(value);
228             // The value is stored at length-1, but we add 1 to all indexes
229             // and use 0 as a sentinel value
230             set._indexes[value] = set._values.length;
231             return true;
232         } else {
233             return false;
234         }
235     }
236 
237     /**
238      * @dev Removes a value from a set. O(1).
239      *
240      * Returns true if the value was removed from the set, that is if it was
241      * present.
242      */
243     function _remove(Set storage set, bytes32 value) private returns (bool) {
244         // We read and store the value's index to prevent multiple reads from the same storage slot
245         uint256 valueIndex = set._indexes[value];
246 
247         if (valueIndex != 0) {
248             // Equivalent to contains(set, value)
249             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
250             // the array, and then remove the last element (sometimes called as 'swap and pop').
251             // This modifies the order of the array, as noted in {at}.
252 
253             uint256 toDeleteIndex = valueIndex - 1;
254             uint256 lastIndex = set._values.length - 1;
255 
256             if (lastIndex != toDeleteIndex) {
257                 bytes32 lastvalue = set._values[lastIndex];
258 
259                 // Move the last value to the index where the value to delete is
260                 set._values[toDeleteIndex] = lastvalue;
261                 // Update the index for the moved value
262                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
263             }
264 
265             // Delete the slot where the moved value was stored
266             set._values.pop();
267 
268             // Delete the index for the deleted slot
269             delete set._indexes[value];
270 
271             return true;
272         } else {
273             return false;
274         }
275     }
276 
277     /**
278      * @dev Returns true if the value is in the set. O(1).
279      */
280     function _contains(Set storage set, bytes32 value)
281         private
282         view
283         returns (bool)
284     {
285         return set._indexes[value] != 0;
286     }
287 
288     /**
289      * @dev Returns the number of values on the set. O(1).
290      */
291     function _length(Set storage set) private view returns (uint256) {
292         return set._values.length;
293     }
294 
295     /**
296      * @dev Returns the value stored at position `index` in the set. O(1).
297      *
298      * Note that there are no guarantees on the ordering of values inside the
299      * array, and it may change when more values are added or removed.
300      *
301      * Requirements:
302      *
303      * - `index` must be strictly less than {length}.
304      */
305     function _at(Set storage set, uint256 index)
306         private
307         view
308         returns (bytes32)
309     {
310         return set._values[index];
311     }
312 
313     /**
314      * @dev Return the entire set in an array
315      *
316      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
317      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
318      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
319      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
320      */
321     function _values(Set storage set) private view returns (bytes32[] memory) {
322         return set._values;
323     }
324 
325     // Bytes32Set
326 
327     struct Bytes32Set {
328         Set _inner;
329     }
330 
331     /**
332      * @dev Add a value to a set. O(1).
333      *
334      * Returns true if the value was added to the set, that is if it was not
335      * already present.
336      */
337     function add(Bytes32Set storage set, bytes32 value)
338         internal
339         returns (bool)
340     {
341         return _add(set._inner, value);
342     }
343 
344     /**
345      * @dev Removes a value from a set. O(1).
346      *
347      * Returns true if the value was removed from the set, that is if it was
348      * present.
349      */
350     function remove(Bytes32Set storage set, bytes32 value)
351         internal
352         returns (bool)
353     {
354         return _remove(set._inner, value);
355     }
356 
357     /**
358      * @dev Returns true if the value is in the set. O(1).
359      */
360     function contains(Bytes32Set storage set, bytes32 value)
361         internal
362         view
363         returns (bool)
364     {
365         return _contains(set._inner, value);
366     }
367 
368     /**
369      * @dev Returns the number of values in the set. O(1).
370      */
371     function length(Bytes32Set storage set) internal view returns (uint256) {
372         return _length(set._inner);
373     }
374 
375     /**
376      * @dev Returns the value stored at position `index` in the set. O(1).
377      *
378      * Note that there are no guarantees on the ordering of values inside the
379      * array, and it may change when more values are added or removed.
380      *
381      * Requirements:
382      *
383      * - `index` must be strictly less than {length}.
384      */
385     function at(Bytes32Set storage set, uint256 index)
386         internal
387         view
388         returns (bytes32)
389     {
390         return _at(set._inner, index);
391     }
392 
393     /**
394      * @dev Return the entire set in an array
395      *
396      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
397      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
398      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
399      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
400      */
401     function values(Bytes32Set storage set)
402         internal
403         view
404         returns (bytes32[] memory)
405     {
406         return _values(set._inner);
407     }
408 
409     // AddressSet
410 
411     struct AddressSet {
412         Set _inner;
413     }
414 
415     /**
416      * @dev Add a value to a set. O(1).
417      *
418      * Returns true if the value was added to the set, that is if it was not
419      * already present.
420      */
421     function add(AddressSet storage set, address value)
422         internal
423         returns (bool)
424     {
425         return _add(set._inner, bytes32(uint256(uint160(value))));
426     }
427 
428     /**
429      * @dev Removes a value from a set. O(1).
430      *
431      * Returns true if the value was removed from the set, that is if it was
432      * present.
433      */
434     function remove(AddressSet storage set, address value)
435         internal
436         returns (bool)
437     {
438         return _remove(set._inner, bytes32(uint256(uint160(value))));
439     }
440 
441     /**
442      * @dev Returns true if the value is in the set. O(1).
443      */
444     function contains(AddressSet storage set, address value)
445         internal
446         view
447         returns (bool)
448     {
449         return _contains(set._inner, bytes32(uint256(uint160(value))));
450     }
451 
452     /**
453      * @dev Returns the number of values in the set. O(1).
454      */
455     function length(AddressSet storage set) internal view returns (uint256) {
456         return _length(set._inner);
457     }
458 
459     /**
460      * @dev Returns the value stored at position `index` in the set. O(1).
461      *
462      * Note that there are no guarantees on the ordering of values inside the
463      * array, and it may change when more values are added or removed.
464      *
465      * Requirements:
466      *
467      * - `index` must be strictly less than {length}.
468      */
469     function at(AddressSet storage set, uint256 index)
470         internal
471         view
472         returns (address)
473     {
474         return address(uint160(uint256(_at(set._inner, index))));
475     }
476 
477     /**
478      * @dev Return the entire set in an array
479      *
480      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
481      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
482      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
483      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
484      */
485     function values(AddressSet storage set)
486         internal
487         view
488         returns (address[] memory)
489     {
490         bytes32[] memory store = _values(set._inner);
491         address[] memory result;
492 
493         assembly {
494             result := store
495         }
496 
497         return result;
498     }
499 
500     // UintSet
501 
502     struct UintSet {
503         Set _inner;
504     }
505 
506     /**
507      * @dev Add a value to a set. O(1).
508      *
509      * Returns true if the value was added to the set, that is if it was not
510      * already present.
511      */
512     function add(UintSet storage set, uint256 value) internal returns (bool) {
513         return _add(set._inner, bytes32(value));
514     }
515 
516     /**
517      * @dev Removes a value from a set. O(1).
518      *
519      * Returns true if the value was removed from the set, that is if it was
520      * present.
521      */
522     function remove(UintSet storage set, uint256 value)
523         internal
524         returns (bool)
525     {
526         return _remove(set._inner, bytes32(value));
527     }
528 
529     /**
530      * @dev Returns true if the value is in the set. O(1).
531      */
532     function contains(UintSet storage set, uint256 value)
533         internal
534         view
535         returns (bool)
536     {
537         return _contains(set._inner, bytes32(value));
538     }
539 
540     /**
541      * @dev Returns the number of values on the set. O(1).
542      */
543     function length(UintSet storage set) internal view returns (uint256) {
544         return _length(set._inner);
545     }
546 
547     /**
548      * @dev Returns the value stored at position `index` in the set. O(1).
549      *
550      * Note that there are no guarantees on the ordering of values inside the
551      * array, and it may change when more values are added or removed.
552      *
553      * Requirements:
554      *
555      * - `index` must be strictly less than {length}.
556      */
557     function at(UintSet storage set, uint256 index)
558         internal
559         view
560         returns (uint256)
561     {
562         return uint256(_at(set._inner, index));
563     }
564 
565     /**
566      * @dev Return the entire set in an array
567      *
568      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
569      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
570      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
571      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
572      */
573     function values(UintSet storage set)
574         internal
575         view
576         returns (uint256[] memory)
577     {
578         bytes32[] memory store = _values(set._inner);
579         uint256[] memory result;
580 
581         assembly {
582             result := store
583         }
584 
585         return result;
586     }
587 }
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev Required interface of an ERC721 compliant contract.
593  */
594 interface IERC721 is IERC165 {
595     /**
596      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
597      */
598     event Transfer(
599         address indexed from,
600         address indexed to,
601         uint256 indexed tokenId
602     );
603 
604     /**
605      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
606      */
607     event Approval(
608         address indexed owner,
609         address indexed approved,
610         uint256 indexed tokenId
611     );
612 
613     /**
614      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
615      */
616     event ApprovalForAll(
617         address indexed owner,
618         address indexed operator,
619         bool approved
620     );
621 
622     /**
623      * @dev Returns the number of tokens in ``owner``'s account.
624      */
625     function balanceOf(address owner) external view returns (uint256 balance);
626 
627     /**
628      * @dev Returns the owner of the `tokenId` token.
629      *
630      * Requirements:
631      *
632      * - `tokenId` must exist.
633      */
634     function ownerOf(uint256 tokenId) external view returns (address owner);
635 
636     /**
637      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
638      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
639      *
640      * Requirements:
641      *
642      * - `from` cannot be the zero address.
643      * - `to` cannot be the zero address.
644      * - `tokenId` token must exist and be owned by `from`.
645      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
647      *
648      * Emits a {Transfer} event.
649      */
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) external;
655 
656     /**
657      * @dev Transfers `tokenId` token from `from` to `to`.
658      *
659      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
660      *
661      * Requirements:
662      *
663      * - `from` cannot be the zero address.
664      * - `to` cannot be the zero address.
665      * - `tokenId` token must be owned by `from`.
666      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
667      *
668      * Emits a {Transfer} event.
669      */
670     function transferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) external;
675 
676     /**
677      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
678      * The approval is cleared when the token is transferred.
679      *
680      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
681      *
682      * Requirements:
683      *
684      * - The caller must own the token or be an approved operator.
685      * - `tokenId` must exist.
686      *
687      * Emits an {Approval} event.
688      */
689     function approve(address to, uint256 tokenId) external;
690 
691     /**
692      * @dev Returns the account approved for `tokenId` token.
693      *
694      * Requirements:
695      *
696      * - `tokenId` must exist.
697      */
698     function getApproved(uint256 tokenId)
699         external
700         view
701         returns (address operator);
702 
703     /**
704      * @dev Approve or remove `operator` as an operator for the caller.
705      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
706      *
707      * Requirements:
708      *
709      * - The `operator` cannot be the caller.
710      *
711      * Emits an {ApprovalForAll} event.
712      */
713     function setApprovalForAll(address operator, bool _approved) external;
714 
715     /**
716      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
717      *
718      * See {setApprovalForAll}
719      */
720     function isApprovedForAll(address owner, address operator)
721         external
722         view
723         returns (bool);
724 
725     /**
726      * @dev Safely transfers `tokenId` token from `from` to `to`.
727      *
728      * Requirements:
729      *
730      * - `from` cannot be the zero address.
731      * - `to` cannot be the zero address.
732      * - `tokenId` token must exist and be owned by `from`.
733      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
734      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
735      *
736      * Emits a {Transfer} event.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes calldata data
743     ) external;
744 }
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
750  * @dev See https://eips.ethereum.org/EIPS/eip-721
751  */
752 interface IERC721Enumerable is IERC721 {
753     /**
754      * @dev Returns the total amount of tokens stored by the contract.
755      */
756     function totalSupply() external view returns (uint256);
757 
758     /**
759      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
760      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
761      */
762     function tokenOfOwnerByIndex(address owner, uint256 index)
763         external
764         view
765         returns (uint256 tokenId);
766 
767     /**
768      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
769      * Use along with {totalSupply} to enumerate all tokens.
770      */
771     function tokenByIndex(uint256 index) external view returns (uint256);
772 }
773 
774 pragma solidity ^0.8.0;
775 
776 /**
777  * @title ERC721 token receiver interface
778  * @dev Interface for any contract that wants to support safeTransfers
779  * from ERC721 asset contracts.
780  */
781 interface IERC721Receiver {
782     /**
783      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
784      * by `operator` from `from`, this function is called.
785      *
786      * It must return its Solidity selector to confirm the token transfer.
787      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
788      *
789      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
790      */
791     function onERC721Received(
792         address operator,
793         address from,
794         uint256 tokenId,
795         bytes calldata data
796     ) external returns (bytes4);
797 }
798 
799 pragma solidity ^0.8.0;
800 
801 /**
802  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
803  * @dev See https://eips.ethereum.org/EIPS/eip-721
804  */
805 interface IERC721Metadata is IERC721 {
806     /**
807      * @dev Returns the token collection name.
808      */
809     function name() external view returns (string memory);
810 
811     /**
812      * @dev Returns the token collection symbol.
813      */
814     function symbol() external view returns (string memory);
815 
816     /**
817      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
818      */
819     function tokenURI(uint256 tokenId) external view returns (string memory);
820 }
821 
822 pragma solidity ^0.8.0;
823 
824 /**
825  * @dev Collection of functions related to the address type
826  */
827 library Address {
828     /**
829      * @dev Returns true if `account` is a contract.
830      *
831      * [IMPORTANT]
832      * ====
833      * It is unsafe to assume that an address for which this function returns
834      * false is an externally-owned account (EOA) and not a contract.
835      *
836      * Among others, `isContract` will return false for the following
837      * types of addresses:
838      *
839      *  - an externally-owned account
840      *  - a contract in construction
841      *  - an address where a contract will be created
842      *  - an address where a contract lived, but was destroyed
843      * ====
844      */
845     function isContract(address account) internal view returns (bool) {
846         // This method relies on extcodesize, which returns 0 for contracts in
847         // construction, since the code is only stored at the end of the
848         // constructor execution.
849 
850         uint256 size;
851         assembly {
852             size := extcodesize(account)
853         }
854         return size > 0;
855     }
856 
857     /**
858      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
859      * `recipient`, forwarding all available gas and reverting on errors.
860      *
861      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
862      * of certain opcodes, possibly making contracts go over the 2300 gas limit
863      * imposed by `transfer`, making them unable to receive funds via
864      * `transfer`. {sendValue} removes this limitation.
865      *
866      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
867      *
868      * IMPORTANT: because control is transferred to `recipient`, care must be
869      * taken to not create reentrancy vulnerabilities. Consider using
870      * {ReentrancyGuard} or the
871      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
872      */
873     function sendValue(address payable recipient, uint256 amount) internal {
874         require(
875             address(this).balance >= amount,
876             "Address: insufficient balance"
877         );
878 
879         (bool success, ) = recipient.call{value: amount}("");
880         require(
881             success,
882             "Address: unable to send value, recipient may have reverted"
883         );
884     }
885 
886     /**
887      * @dev Performs a Solidity function call using a low level `call`. A
888      * plain `call` is an unsafe replacement for a function call: use this
889      * function instead.
890      *
891      * If `target` reverts with a revert reason, it is bubbled up by this
892      * function (like regular Solidity function calls).
893      *
894      * Returns the raw returned data. To convert to the expected return value,
895      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
896      *
897      * Requirements:
898      *
899      * - `target` must be a contract.
900      * - calling `target` with `data` must not revert.
901      *
902      * _Available since v3.1._
903      */
904     function functionCall(address target, bytes memory data)
905         internal
906         returns (bytes memory)
907     {
908         return functionCall(target, data, "Address: low-level call failed");
909     }
910 
911     /**
912      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
913      * `errorMessage` as a fallback revert reason when `target` reverts.
914      *
915      * _Available since v3.1._
916      */
917     function functionCall(
918         address target,
919         bytes memory data,
920         string memory errorMessage
921     ) internal returns (bytes memory) {
922         return functionCallWithValue(target, data, 0, errorMessage);
923     }
924 
925     /**
926      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
927      * but also transferring `value` wei to `target`.
928      *
929      * Requirements:
930      *
931      * - the calling contract must have an ETH balance of at least `value`.
932      * - the called Solidity function must be `payable`.
933      *
934      * _Available since v3.1._
935      */
936     function functionCallWithValue(
937         address target,
938         bytes memory data,
939         uint256 value
940     ) internal returns (bytes memory) {
941         return
942             functionCallWithValue(
943                 target,
944                 data,
945                 value,
946                 "Address: low-level call with value failed"
947             );
948     }
949 
950     /**
951      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
952      * with `errorMessage` as a fallback revert reason when `target` reverts.
953      *
954      * _Available since v3.1._
955      */
956     function functionCallWithValue(
957         address target,
958         bytes memory data,
959         uint256 value,
960         string memory errorMessage
961     ) internal returns (bytes memory) {
962         require(
963             address(this).balance >= value,
964             "Address: insufficient balance for call"
965         );
966         require(isContract(target), "Address: call to non-contract");
967 
968         (bool success, bytes memory returndata) = target.call{value: value}(
969             data
970         );
971         return verifyCallResult(success, returndata, errorMessage);
972     }
973 
974     /**
975      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
976      * but performing a static call.
977      *
978      * _Available since v3.3._
979      */
980     function functionStaticCall(address target, bytes memory data)
981         internal
982         view
983         returns (bytes memory)
984     {
985         return
986             functionStaticCall(
987                 target,
988                 data,
989                 "Address: low-level static call failed"
990             );
991     }
992 
993     /**
994      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
995      * but performing a static call.
996      *
997      * _Available since v3.3._
998      */
999     function functionStaticCall(
1000         address target,
1001         bytes memory data,
1002         string memory errorMessage
1003     ) internal view returns (bytes memory) {
1004         require(isContract(target), "Address: static call to non-contract");
1005 
1006         (bool success, bytes memory returndata) = target.staticcall(data);
1007         return verifyCallResult(success, returndata, errorMessage);
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1012      * but performing a delegate call.
1013      *
1014      * _Available since v3.4._
1015      */
1016     function functionDelegateCall(address target, bytes memory data)
1017         internal
1018         returns (bytes memory)
1019     {
1020         return
1021             functionDelegateCall(
1022                 target,
1023                 data,
1024                 "Address: low-level delegate call failed"
1025             );
1026     }
1027 
1028     /**
1029      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1030      * but performing a delegate call.
1031      *
1032      * _Available since v3.4._
1033      */
1034     function functionDelegateCall(
1035         address target,
1036         bytes memory data,
1037         string memory errorMessage
1038     ) internal returns (bytes memory) {
1039         require(isContract(target), "Address: delegate call to non-contract");
1040 
1041         (bool success, bytes memory returndata) = target.delegatecall(data);
1042         return verifyCallResult(success, returndata, errorMessage);
1043     }
1044 
1045     /**
1046      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1047      * revert reason using the provided one.
1048      *
1049      * _Available since v4.3._
1050      */
1051     function verifyCallResult(
1052         bool success,
1053         bytes memory returndata,
1054         string memory errorMessage
1055     ) internal pure returns (bytes memory) {
1056         if (success) {
1057             return returndata;
1058         } else {
1059             // Look for revert reason and bubble it up if present
1060             if (returndata.length > 0) {
1061                 // The easiest way to bubble the revert reason is using memory via assembly
1062 
1063                 assembly {
1064                     let returndata_size := mload(returndata)
1065                     revert(add(32, returndata), returndata_size)
1066                 }
1067             } else {
1068                 revert(errorMessage);
1069             }
1070         }
1071     }
1072 }
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 /**
1077  * @dev Provides information about the current execution context, including the
1078  * sender of the transaction and its data. While these are generally available
1079  * via msg.sender and msg.data, they should not be accessed in such a direct
1080  * manner, since when dealing with meta-transactions the account sending and
1081  * paying for execution may not be the actual sender (as far as an application
1082  * is concerned).
1083  *
1084  * This contract is only required for intermediate, library-like contracts.
1085  */
1086 abstract contract Context {
1087     function _msgSender() internal view virtual returns (address) {
1088         return msg.sender;
1089     }
1090 
1091     function _msgData() internal view virtual returns (bytes calldata) {
1092         return msg.data;
1093     }
1094 }
1095 
1096 pragma solidity ^0.8.0;
1097 
1098 /**
1099  * @dev String operations.
1100  */
1101 library Strings {
1102     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1103 
1104     /**
1105      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1106      */
1107     function toString(uint256 value) internal pure returns (string memory) {
1108         // Inspired by OraclizeAPI's implementation - MIT licence
1109         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1110 
1111         if (value == 0) {
1112             return "0";
1113         }
1114         uint256 temp = value;
1115         uint256 digits;
1116         while (temp != 0) {
1117             digits++;
1118             temp /= 10;
1119         }
1120         bytes memory buffer = new bytes(digits);
1121         while (value != 0) {
1122             digits -= 1;
1123             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1124             value /= 10;
1125         }
1126         return string(buffer);
1127     }
1128 
1129     /**
1130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1131      */
1132     function toHexString(uint256 value) internal pure returns (string memory) {
1133         if (value == 0) {
1134             return "0x00";
1135         }
1136         uint256 temp = value;
1137         uint256 length = 0;
1138         while (temp != 0) {
1139             length++;
1140             temp >>= 8;
1141         }
1142         return toHexString(value, length);
1143     }
1144 
1145     /**
1146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1147      */
1148     function toHexString(uint256 value, uint256 length)
1149         internal
1150         pure
1151         returns (string memory)
1152     {
1153         bytes memory buffer = new bytes(2 * length + 2);
1154         buffer[0] = "0";
1155         buffer[1] = "x";
1156         for (uint256 i = 2 * length + 1; i > 1; --i) {
1157             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1158             value >>= 4;
1159         }
1160         require(value == 0, "Strings: hex length insufficient");
1161         return string(buffer);
1162     }
1163 }
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 /**
1168  * @dev Implementation of the {IERC165} interface.
1169  *
1170  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1171  * for the additional interface id that will be supported. For example:
1172  *
1173  * ```solidity
1174  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1175  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1176  * }
1177  * ```
1178  *
1179  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1180  */
1181 abstract contract ERC165 is IERC165 {
1182     /**
1183      * @dev See {IERC165-supportsInterface}.
1184      */
1185     function supportsInterface(bytes4 interfaceId)
1186         public
1187         view
1188         virtual
1189         override
1190         returns (bool)
1191     {
1192         return interfaceId == type(IERC165).interfaceId;
1193     }
1194 }
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 /**
1199  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1200  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1201  * {ERC721Enumerable}.
1202  */
1203 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1204     using Address for address;
1205     using Strings for uint256;
1206 
1207     // Token name
1208     string private _name;
1209 
1210     // Token symbol
1211     string private _symbol;
1212 
1213     // Mapping from token ID to owner address
1214     mapping(uint256 => address) private _owners;
1215 
1216     // Mapping owner address to token count
1217     mapping(address => uint256) private _balances;
1218 
1219     // Mapping from token ID to approved address
1220     mapping(uint256 => address) private _tokenApprovals;
1221 
1222     // Mapping from owner to operator approvals
1223     mapping(address => mapping(address => bool)) private _operatorApprovals;
1224 
1225     /**
1226      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1227      */
1228     constructor(string memory name_, string memory symbol_) {
1229         _name = name_;
1230         _symbol = symbol_;
1231     }
1232 
1233     /**
1234      * @dev See {IERC165-supportsInterface}.
1235      */
1236     function supportsInterface(bytes4 interfaceId)
1237         public
1238         view
1239         virtual
1240         override(ERC165, IERC165)
1241         returns (bool)
1242     {
1243         return
1244             interfaceId == type(IERC721).interfaceId ||
1245             interfaceId == type(IERC721Metadata).interfaceId ||
1246             super.supportsInterface(interfaceId);
1247     }
1248 
1249     /**
1250      * @dev See {IERC721-balanceOf}.
1251      */
1252     function balanceOf(address owner)
1253         public
1254         view
1255         virtual
1256         override
1257         returns (uint256)
1258     {
1259         require(
1260             owner != address(0),
1261             "ERC721: balance query for the zero address"
1262         );
1263         return _balances[owner];
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-ownerOf}.
1268      */
1269     function ownerOf(uint256 tokenId)
1270         public
1271         view
1272         virtual
1273         override
1274         returns (address)
1275     {
1276         address owner = _owners[tokenId];
1277         require(
1278             owner != address(0),
1279             "ERC721: owner query for nonexistent token"
1280         );
1281         return owner;
1282     }
1283 
1284     /**
1285      * @dev See {IERC721Metadata-name}.
1286      */
1287     function name() public view virtual override returns (string memory) {
1288         return _name;
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Metadata-symbol}.
1293      */
1294     function symbol() public view virtual override returns (string memory) {
1295         return _symbol;
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Metadata-tokenURI}.
1300      */
1301     function tokenURI(uint256 tokenId)
1302         public
1303         view
1304         virtual
1305         override
1306         returns (string memory)
1307     {
1308         require(
1309             _exists(tokenId),
1310             "ERC721Metadata: URI query for nonexistent token"
1311         );
1312 
1313         string memory baseURI = _baseURI();
1314         return
1315             bytes(baseURI).length > 0
1316                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1317                 : "";
1318     }
1319 
1320     /**
1321      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1322      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1323      * by default, can be overriden in child contracts.
1324      */
1325     function _baseURI() internal view virtual returns (string memory) {
1326         return "";
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-approve}.
1331      */
1332     function approve(address to, uint256 tokenId) public virtual override {
1333         address owner = ERC721.ownerOf(tokenId);
1334         require(to != owner, "ERC721: approval to current owner");
1335 
1336         require(
1337             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1338             "ERC721: approve caller is not owner nor approved for all"
1339         );
1340 
1341         _approve(to, tokenId);
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-getApproved}.
1346      */
1347     function getApproved(uint256 tokenId)
1348         public
1349         view
1350         virtual
1351         override
1352         returns (address)
1353     {
1354         require(
1355             _exists(tokenId),
1356             "ERC721: approved query for nonexistent token"
1357         );
1358 
1359         return _tokenApprovals[tokenId];
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-setApprovalForAll}.
1364      */
1365     function setApprovalForAll(address operator, bool approved)
1366         public
1367         virtual
1368         override
1369     {
1370         _setApprovalForAll(_msgSender(), operator, approved);
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-isApprovedForAll}.
1375      */
1376     function isApprovedForAll(address owner, address operator)
1377         public
1378         view
1379         virtual
1380         override
1381         returns (bool)
1382     {
1383         return _operatorApprovals[owner][operator];
1384     }
1385 
1386     /**
1387      * @dev See {IERC721-transferFrom}.
1388      */
1389     function transferFrom(
1390         address from,
1391         address to,
1392         uint256 tokenId
1393     ) public virtual override {
1394         //solhint-disable-next-line max-line-length
1395         require(
1396             _isApprovedOrOwner(_msgSender(), tokenId),
1397             "ERC721: transfer caller is not owner nor approved"
1398         );
1399 
1400         _transfer(from, to, tokenId);
1401     }
1402 
1403     /**
1404      * @dev See {IERC721-safeTransferFrom}.
1405      */
1406     function safeTransferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId
1410     ) public virtual override {
1411         safeTransferFrom(from, to, tokenId, "");
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-safeTransferFrom}.
1416      */
1417     function safeTransferFrom(
1418         address from,
1419         address to,
1420         uint256 tokenId,
1421         bytes memory _data
1422     ) public virtual override {
1423         require(
1424             _isApprovedOrOwner(_msgSender(), tokenId),
1425             "ERC721: transfer caller is not owner nor approved"
1426         );
1427         _safeTransfer(from, to, tokenId, _data);
1428     }
1429 
1430     /**
1431      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1432      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1433      *
1434      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1435      *
1436      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1437      * implement alternative mechanisms to perform token transfer, such as signature-based.
1438      *
1439      * Requirements:
1440      *
1441      * - `from` cannot be the zero address.
1442      * - `to` cannot be the zero address.
1443      * - `tokenId` token must exist and be owned by `from`.
1444      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1445      *
1446      * Emits a {Transfer} event.
1447      */
1448     function _safeTransfer(
1449         address from,
1450         address to,
1451         uint256 tokenId,
1452         bytes memory _data
1453     ) internal virtual {
1454         _transfer(from, to, tokenId);
1455         require(
1456             _checkOnERC721Received(from, to, tokenId, _data),
1457             "ERC721: transfer to non ERC721Receiver implementer"
1458         );
1459     }
1460 
1461     /**
1462      * @dev Returns whether `tokenId` exists.
1463      *
1464      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1465      *
1466      * Tokens start existing when they are minted (`_mint`),
1467      * and stop existing when they are burned (`_burn`).
1468      */
1469     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1470         return _owners[tokenId] != address(0);
1471     }
1472 
1473     /**
1474      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1475      *
1476      * Requirements:
1477      *
1478      * - `tokenId` must exist.
1479      */
1480     function _isApprovedOrOwner(address spender, uint256 tokenId)
1481         internal
1482         view
1483         virtual
1484         returns (bool)
1485     {
1486         require(
1487             _exists(tokenId),
1488             "ERC721: operator query for nonexistent token"
1489         );
1490         address owner = ERC721.ownerOf(tokenId);
1491         return (spender == owner ||
1492             getApproved(tokenId) == spender ||
1493             isApprovedForAll(owner, spender));
1494     }
1495 
1496     /**
1497      * @dev Safely mints `tokenId` and transfers it to `to`.
1498      *
1499      * Requirements:
1500      *
1501      * - `tokenId` must not exist.
1502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1503      *
1504      * Emits a {Transfer} event.
1505      */
1506     function _safeMint(address to, uint256 tokenId) internal virtual {
1507         _safeMint(to, tokenId, "");
1508     }
1509 
1510     /**
1511      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1512      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1513      */
1514     function _safeMint(
1515         address to,
1516         uint256 tokenId,
1517         bytes memory _data
1518     ) internal virtual {
1519         _mint(to, tokenId);
1520         require(
1521             _checkOnERC721Received(address(0), to, tokenId, _data),
1522             "ERC721: transfer to non ERC721Receiver implementer"
1523         );
1524     }
1525 
1526     /**
1527      * @dev Mints `tokenId` and transfers it to `to`.
1528      *
1529      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1530      *
1531      * Requirements:
1532      *
1533      * - `tokenId` must not exist.
1534      * - `to` cannot be the zero address.
1535      *
1536      * Emits a {Transfer} event.
1537      */
1538     function _mint(address to, uint256 tokenId) internal virtual {
1539         require(to != address(0), "ERC721: mint to the zero address");
1540         require(!_exists(tokenId), "ERC721: token already minted");
1541 
1542         _beforeTokenTransfer(address(0), to, tokenId);
1543 
1544         _balances[to] += 1;
1545         _owners[tokenId] = to;
1546 
1547         emit Transfer(address(0), to, tokenId);
1548     }
1549 
1550     /**
1551      * @dev Destroys `tokenId`.
1552      * The approval is cleared when the token is burned.
1553      *
1554      * Requirements:
1555      *
1556      * - `tokenId` must exist.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _burn(uint256 tokenId) internal virtual {
1561         address owner = ERC721.ownerOf(tokenId);
1562 
1563         _beforeTokenTransfer(owner, address(0), tokenId);
1564 
1565         // Clear approvals
1566         _approve(address(0), tokenId);
1567 
1568         _balances[owner] -= 1;
1569         delete _owners[tokenId];
1570 
1571         emit Transfer(owner, address(0), tokenId);
1572     }
1573 
1574     /**
1575      * @dev Transfers `tokenId` from `from` to `to`.
1576      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1577      *
1578      * Requirements:
1579      *
1580      * - `to` cannot be the zero address.
1581      * - `tokenId` token must be owned by `from`.
1582      *
1583      * Emits a {Transfer} event.
1584      */
1585     function _transfer(
1586         address from,
1587         address to,
1588         uint256 tokenId
1589     ) internal virtual {
1590         require(
1591             ERC721.ownerOf(tokenId) == from,
1592             "ERC721: transfer of token that is not own"
1593         );
1594         require(to != address(0), "ERC721: transfer to the zero address");
1595 
1596         _beforeTokenTransfer(from, to, tokenId);
1597 
1598         // Clear approvals from the previous owner
1599         _approve(address(0), tokenId);
1600 
1601         _balances[from] -= 1;
1602         _balances[to] += 1;
1603         _owners[tokenId] = to;
1604 
1605         emit Transfer(from, to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev Approve `to` to operate on `tokenId`
1610      *
1611      * Emits a {Approval} event.
1612      */
1613     function _approve(address to, uint256 tokenId) internal virtual {
1614         _tokenApprovals[tokenId] = to;
1615         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1616     }
1617 
1618     /**
1619      * @dev Approve `operator` to operate on all of `owner` tokens
1620      *
1621      * Emits a {ApprovalForAll} event.
1622      */
1623     function _setApprovalForAll(
1624         address owner,
1625         address operator,
1626         bool approved
1627     ) internal virtual {
1628         require(owner != operator, "ERC721: approve to caller");
1629         _operatorApprovals[owner][operator] = approved;
1630         emit ApprovalForAll(owner, operator, approved);
1631     }
1632 
1633     /**
1634      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1635      * The call is not executed if the target address is not a contract.
1636      *
1637      * @param from address representing the previous owner of the given token ID
1638      * @param to target address that will receive the tokens
1639      * @param tokenId uint256 ID of the token to be transferred
1640      * @param _data bytes optional data to send along with the call
1641      * @return bool whether the call correctly returned the expected magic value
1642      */
1643     function _checkOnERC721Received(
1644         address from,
1645         address to,
1646         uint256 tokenId,
1647         bytes memory _data
1648     ) private returns (bool) {
1649         if (to.isContract()) {
1650             try
1651                 IERC721Receiver(to).onERC721Received(
1652                     _msgSender(),
1653                     from,
1654                     tokenId,
1655                     _data
1656                 )
1657             returns (bytes4 retval) {
1658                 return retval == IERC721Receiver.onERC721Received.selector;
1659             } catch (bytes memory reason) {
1660                 if (reason.length == 0) {
1661                     revert(
1662                         "ERC721: transfer to non ERC721Receiver implementer"
1663                     );
1664                 } else {
1665                     assembly {
1666                         revert(add(32, reason), mload(reason))
1667                     }
1668                 }
1669             }
1670         } else {
1671             return true;
1672         }
1673     }
1674 
1675     /**
1676      * @dev Hook that is called before any token transfer. This includes minting
1677      * and burning.
1678      *
1679      * Calling conditions:
1680      *
1681      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1682      * transferred to `to`.
1683      * - When `from` is zero, `tokenId` will be minted for `to`.
1684      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1685      * - `from` and `to` are never both zero.
1686      *
1687      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1688      */
1689     function _beforeTokenTransfer(
1690         address from,
1691         address to,
1692         uint256 tokenId
1693     ) internal virtual {}
1694 }
1695 
1696 pragma solidity ^0.8.0;
1697 
1698 /**
1699  * @dev Contract module that allows children to implement role-based access
1700  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1701  * members except through off-chain means by accessing the contract event logs. Some
1702  * applications may benefit from on-chain enumerability, for those cases see
1703  * {AccessControlEnumerable}.
1704  *
1705  * Roles are referred to by their `bytes32` identifier. These should be exposed
1706  * in the external API and be unique. The best way to achieve this is by
1707  * using `public constant` hash digests:
1708  *
1709  * ```
1710  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1711  * ```
1712  *
1713  * Roles can be used to represent a set of permissions. To restrict access to a
1714  * function call, use {hasRole}:
1715  *
1716  * ```
1717  * function foo() public {
1718  *     require(hasRole(MY_ROLE, msg.sender));
1719  *     ...
1720  * }
1721  * ```
1722  *
1723  * Roles can be granted and revoked dynamically via the {grantRole} and
1724  * {revokeRole} functions. Each role has an associated admin role, and only
1725  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1726  *
1727  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1728  * that only accounts with this role will be able to grant or revoke other
1729  * roles. More complex role relationships can be created by using
1730  * {_setRoleAdmin}.
1731  *
1732  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1733  * grant and revoke this role. Extra precautions should be taken to secure
1734  * accounts that have been granted it.
1735  */
1736 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1737     struct RoleData {
1738         mapping(address => bool) members;
1739         bytes32 adminRole;
1740     }
1741 
1742     mapping(bytes32 => RoleData) private _roles;
1743 
1744     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1745 
1746     /**
1747      * @dev Modifier that checks that an account has a specific role. Reverts
1748      * with a standardized message including the required role.
1749      *
1750      * The format of the revert reason is given by the following regular expression:
1751      *
1752      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1753      *
1754      * _Available since v4.1._
1755      */
1756     modifier onlyRole(bytes32 role) {
1757         _checkRole(role, _msgSender());
1758         _;
1759     }
1760 
1761     /**
1762      * @dev See {IERC165-supportsInterface}.
1763      */
1764     function supportsInterface(bytes4 interfaceId)
1765         public
1766         view
1767         virtual
1768         override
1769         returns (bool)
1770     {
1771         return
1772             interfaceId == type(IAccessControl).interfaceId ||
1773             super.supportsInterface(interfaceId);
1774     }
1775 
1776     /**
1777      * @dev Returns `true` if `account` has been granted `role`.
1778      */
1779     function hasRole(bytes32 role, address account)
1780         public
1781         view
1782         virtual
1783         override
1784         returns (bool)
1785     {
1786         return _roles[role].members[account];
1787     }
1788 
1789     /**
1790      * @dev Revert with a standard message if `account` is missing `role`.
1791      *
1792      * The format of the revert reason is given by the following regular expression:
1793      *
1794      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1795      */
1796     function _checkRole(bytes32 role, address account) internal view virtual {
1797         if (!hasRole(role, account)) {
1798             revert(
1799                 string(
1800                     abi.encodePacked(
1801                         "AccessControl: account ",
1802                         Strings.toHexString(uint160(account), 20),
1803                         " is missing role ",
1804                         Strings.toHexString(uint256(role), 32)
1805                     )
1806                 )
1807             );
1808         }
1809     }
1810 
1811     /**
1812      * @dev Returns the admin role that controls `role`. See {grantRole} and
1813      * {revokeRole}.
1814      *
1815      * To change a role's admin, use {_setRoleAdmin}.
1816      */
1817     function getRoleAdmin(bytes32 role)
1818         public
1819         view
1820         virtual
1821         override
1822         returns (bytes32)
1823     {
1824         return _roles[role].adminRole;
1825     }
1826 
1827     /**
1828      * @dev Grants `role` to `account`.
1829      *
1830      * If `account` had not been already granted `role`, emits a {RoleGranted}
1831      * event.
1832      *
1833      * Requirements:
1834      *
1835      * - the caller must have ``role``'s admin role.
1836      */
1837     function grantRole(bytes32 role, address account)
1838         public
1839         virtual
1840         override
1841         onlyRole(getRoleAdmin(role))
1842     {
1843         _grantRole(role, account);
1844     }
1845 
1846     /**
1847      * @dev Revokes `role` from `account`.
1848      *
1849      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1850      *
1851      * Requirements:
1852      *
1853      * - the caller must have ``role``'s admin role.
1854      */
1855     function revokeRole(bytes32 role, address account)
1856         public
1857         virtual
1858         override
1859         onlyRole(getRoleAdmin(role))
1860     {
1861         _revokeRole(role, account);
1862     }
1863 
1864     /**
1865      * @dev Revokes `role` from the calling account.
1866      *
1867      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1868      * purpose is to provide a mechanism for accounts to lose their privileges
1869      * if they are compromised (such as when a trusted device is misplaced).
1870      *
1871      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1872      * event.
1873      *
1874      * Requirements:
1875      *
1876      * - the caller must be `account`.
1877      */
1878     function renounceRole(bytes32 role, address account)
1879         public
1880         virtual
1881         override
1882     {
1883         require(
1884             account == _msgSender(),
1885             "AccessControl: can only renounce roles for self"
1886         );
1887 
1888         _revokeRole(role, account);
1889     }
1890 
1891     /**
1892      * @dev Grants `role` to `account`.
1893      *
1894      * If `account` had not been already granted `role`, emits a {RoleGranted}
1895      * event. Note that unlike {grantRole}, this function doesn't perform any
1896      * checks on the calling account.
1897      *
1898      * [WARNING]
1899      * ====
1900      * This function should only be called from the constructor when setting
1901      * up the initial roles for the system.
1902      *
1903      * Using this function in any other way is effectively circumventing the admin
1904      * system imposed by {AccessControl}.
1905      * ====
1906      *
1907      * NOTE: This function is deprecated in favor of {_grantRole}.
1908      */
1909     function _setupRole(bytes32 role, address account) internal virtual {
1910         _grantRole(role, account);
1911     }
1912 
1913     /**
1914      * @dev Sets `adminRole` as ``role``'s admin role.
1915      *
1916      * Emits a {RoleAdminChanged} event.
1917      */
1918     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1919         bytes32 previousAdminRole = getRoleAdmin(role);
1920         _roles[role].adminRole = adminRole;
1921         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1922     }
1923 
1924     /**
1925      * @dev Grants `role` to `account`.
1926      *
1927      * Internal function without access restriction.
1928      */
1929     function _grantRole(bytes32 role, address account) internal virtual {
1930         if (!hasRole(role, account)) {
1931             _roles[role].members[account] = true;
1932             emit RoleGranted(role, account, _msgSender());
1933         }
1934     }
1935 
1936     /**
1937      * @dev Revokes `role` from `account`.
1938      *
1939      * Internal function without access restriction.
1940      */
1941     function _revokeRole(bytes32 role, address account) internal virtual {
1942         if (hasRole(role, account)) {
1943             _roles[role].members[account] = false;
1944             emit RoleRevoked(role, account, _msgSender());
1945         }
1946     }
1947 }
1948 
1949 pragma solidity ^0.8.0;
1950 
1951 /**
1952  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1953  * enumerability of all the token ids in the contract as well as all token ids owned by each
1954  * account.
1955  */
1956 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1957     // Mapping from owner to list of owned token IDs
1958     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1959 
1960     // Mapping from token ID to index of the owner tokens list
1961     mapping(uint256 => uint256) private _ownedTokensIndex;
1962 
1963     // Array with all token ids, used for enumeration
1964     uint256[] private _allTokens;
1965 
1966     // Mapping from token id to position in the allTokens array
1967     mapping(uint256 => uint256) private _allTokensIndex;
1968 
1969     /**
1970      * @dev See {IERC165-supportsInterface}.
1971      */
1972     function supportsInterface(bytes4 interfaceId)
1973         public
1974         view
1975         virtual
1976         override(IERC165, ERC721)
1977         returns (bool)
1978     {
1979         return
1980             interfaceId == type(IERC721Enumerable).interfaceId ||
1981             super.supportsInterface(interfaceId);
1982     }
1983 
1984     /**
1985      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1986      */
1987     function tokenOfOwnerByIndex(address owner, uint256 index)
1988         public
1989         view
1990         virtual
1991         override
1992         returns (uint256)
1993     {
1994         require(
1995             index < ERC721.balanceOf(owner),
1996             "ERC721Enumerable: owner index out of bounds"
1997         );
1998         return _ownedTokens[owner][index];
1999     }
2000 
2001     /**
2002      * @dev See {IERC721Enumerable-totalSupply}.
2003      */
2004     function totalSupply() public view virtual override returns (uint256) {
2005         return _allTokens.length;
2006     }
2007 
2008     /**
2009      * @dev See {IERC721Enumerable-tokenByIndex}.
2010      */
2011     function tokenByIndex(uint256 index)
2012         public
2013         view
2014         virtual
2015         override
2016         returns (uint256)
2017     {
2018         require(
2019             index < ERC721Enumerable.totalSupply(),
2020             "ERC721Enumerable: global index out of bounds"
2021         );
2022         return _allTokens[index];
2023     }
2024 
2025     /**
2026      * @dev Hook that is called before any token transfer. This includes minting
2027      * and burning.
2028      *
2029      * Calling conditions:
2030      *
2031      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2032      * transferred to `to`.
2033      * - When `from` is zero, `tokenId` will be minted for `to`.
2034      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2035      * - `from` cannot be the zero address.
2036      * - `to` cannot be the zero address.
2037      *
2038      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2039      */
2040     function _beforeTokenTransfer(
2041         address from,
2042         address to,
2043         uint256 tokenId
2044     ) internal virtual override {
2045         super._beforeTokenTransfer(from, to, tokenId);
2046 
2047         if (from == address(0)) {
2048             _addTokenToAllTokensEnumeration(tokenId);
2049         } else if (from != to) {
2050             _removeTokenFromOwnerEnumeration(from, tokenId);
2051         }
2052         if (to == address(0)) {
2053             _removeTokenFromAllTokensEnumeration(tokenId);
2054         } else if (to != from) {
2055             _addTokenToOwnerEnumeration(to, tokenId);
2056         }
2057     }
2058 
2059     /**
2060      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2061      * @param to address representing the new owner of the given token ID
2062      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2063      */
2064     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2065         uint256 length = ERC721.balanceOf(to);
2066         _ownedTokens[to][length] = tokenId;
2067         _ownedTokensIndex[tokenId] = length;
2068     }
2069 
2070     /**
2071      * @dev Private function to add a token to this extension's token tracking data structures.
2072      * @param tokenId uint256 ID of the token to be added to the tokens list
2073      */
2074     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2075         _allTokensIndex[tokenId] = _allTokens.length;
2076         _allTokens.push(tokenId);
2077     }
2078 
2079     /**
2080      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2081      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2082      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2083      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2084      * @param from address representing the previous owner of the given token ID
2085      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2086      */
2087     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
2088         private
2089     {
2090         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2091         // then delete the last slot (swap and pop).
2092 
2093         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2094         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2095 
2096         // When the token to delete is the last token, the swap operation is unnecessary
2097         if (tokenIndex != lastTokenIndex) {
2098             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2099 
2100             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2101             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2102         }
2103 
2104         // This also deletes the contents at the last position of the array
2105         delete _ownedTokensIndex[tokenId];
2106         delete _ownedTokens[from][lastTokenIndex];
2107     }
2108 
2109     /**
2110      * @dev Private function to remove a token from this extension's token tracking data structures.
2111      * This has O(1) time complexity, but alters the order of the _allTokens array.
2112      * @param tokenId uint256 ID of the token to be removed from the tokens list
2113      */
2114     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2115         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2116         // then delete the last slot (swap and pop).
2117 
2118         uint256 lastTokenIndex = _allTokens.length - 1;
2119         uint256 tokenIndex = _allTokensIndex[tokenId];
2120 
2121         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2122         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2123         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2124         uint256 lastTokenId = _allTokens[lastTokenIndex];
2125 
2126         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2127         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2128 
2129         // This also deletes the contents at the last position of the array
2130         delete _allTokensIndex[tokenId];
2131         _allTokens.pop();
2132     }
2133 }
2134 
2135 pragma solidity ^0.8.0;
2136 
2137 /**
2138  * @dev Contract module which provides a basic access control mechanism, where
2139  * there is an account (an owner) that can be granted exclusive access to
2140  * specific functions.
2141  *
2142  * By default, the owner account will be the one that deploys the contract. This
2143  * can later be changed with {transferOwnership}.
2144  *
2145  * This module is used through inheritance. It will make available the modifier
2146  * `onlyOwner`, which can be applied to your functions to restrict their use to
2147  * the owner.
2148  */
2149 abstract contract Ownable is Context {
2150     address private _owner;
2151 
2152     event OwnershipTransferred(
2153         address indexed previousOwner,
2154         address indexed newOwner
2155     );
2156 
2157     /**
2158      * @dev Initializes the contract setting the deployer as the initial owner.
2159      */
2160     constructor() {
2161         _transferOwnership(_msgSender());
2162     }
2163 
2164     /**
2165      * @dev Returns the address of the current owner.
2166      */
2167     function owner() public view virtual returns (address) {
2168         return _owner;
2169     }
2170 
2171     /**
2172      * @dev Throws if called by any account other than the owner.
2173      */
2174     modifier onlyOwner() {
2175         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2176         _;
2177     }
2178 
2179     /**
2180      * @dev Leaves the contract without owner. It will not be possible to call
2181      * `onlyOwner` functions anymore. Can only be called by the current owner.
2182      *
2183      * NOTE: Renouncing ownership will leave the contract without an owner,
2184      * thereby removing any functionality that is only available to the owner.
2185      */
2186     function renounceOwnership() public virtual onlyOwner {
2187         _transferOwnership(address(0));
2188     }
2189 
2190     /**
2191      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2192      * Can only be called by the current owner.
2193      */
2194     function transferOwnership(address newOwner) public virtual onlyOwner {
2195         require(
2196             newOwner != address(0),
2197             "Ownable: new owner is the zero address"
2198         );
2199         _transferOwnership(newOwner);
2200     }
2201 
2202     /**
2203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2204      * Internal function without access restriction.
2205      */
2206     function _transferOwnership(address newOwner) internal virtual {
2207         address oldOwner = _owner;
2208         _owner = newOwner;
2209         emit OwnershipTransferred(oldOwner, newOwner);
2210     }
2211 }
2212 
2213 pragma solidity ^0.8.0;
2214 
2215 /**
2216  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2217  */
2218 abstract contract AccessControlEnumerable is
2219     IAccessControlEnumerable,
2220     AccessControl
2221 {
2222     using EnumerableSet for EnumerableSet.AddressSet;
2223 
2224     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2225 
2226     /**
2227      * @dev See {IERC165-supportsInterface}.
2228      */
2229     function supportsInterface(bytes4 interfaceId)
2230         public
2231         view
2232         virtual
2233         override
2234         returns (bool)
2235     {
2236         return
2237             interfaceId == type(IAccessControlEnumerable).interfaceId ||
2238             super.supportsInterface(interfaceId);
2239     }
2240 
2241     /**
2242      * @dev Returns one of the accounts that have `role`. `index` must be a
2243      * value between 0 and {getRoleMemberCount}, non-inclusive.
2244      *
2245      * Role bearers are not sorted in any particular way, and their ordering may
2246      * change at any point.
2247      *
2248      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2249      * you perform all queries on the same block. See the following
2250      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2251      * for more information.
2252      */
2253     function getRoleMember(bytes32 role, uint256 index)
2254         public
2255         view
2256         virtual
2257         override
2258         returns (address)
2259     {
2260         return _roleMembers[role].at(index);
2261     }
2262 
2263     /**
2264      * @dev Returns the number of accounts that have `role`. Can be used
2265      * together with {getRoleMember} to enumerate all bearers of a role.
2266      */
2267     function getRoleMemberCount(bytes32 role)
2268         public
2269         view
2270         virtual
2271         override
2272         returns (uint256)
2273     {
2274         return _roleMembers[role].length();
2275     }
2276 
2277     /**
2278      * @dev Overload {_grantRole} to track enumerable memberships
2279      */
2280     function _grantRole(bytes32 role, address account)
2281         internal
2282         virtual
2283         override
2284     {
2285         super._grantRole(role, account);
2286         _roleMembers[role].add(account);
2287     }
2288 
2289     /**
2290      * @dev Overload {_revokeRole} to track enumerable memberships
2291      */
2292     function _revokeRole(bytes32 role, address account)
2293         internal
2294         virtual
2295         override
2296     {
2297         super._revokeRole(role, account);
2298         _roleMembers[role].remove(account);
2299     }
2300 }
2301 
2302 pragma solidity ^0.8.0;
2303 
2304 /**
2305  * @dev Contract module that helps prevent reentrant calls to a function.
2306  *
2307  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2308  * available, which can be applied to functions to make sure there are no nested
2309  * (reentrant) calls to them.
2310  *
2311  * Note that because there is a single `nonReentrant` guard, functions marked as
2312  * `nonReentrant` may not call one another. This can be worked around by making
2313  * those functions `private`, and then adding `external` `nonReentrant` entry
2314  * points to them.
2315  *
2316  * TIP: If you would like to learn more about reentrancy and alternative ways
2317  * to protect against it, check out our blog post
2318  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2319  */
2320 abstract contract ReentrancyGuard {
2321     // Booleans are more expensive than uint256 or any type that takes up a full
2322     // word because each write operation emits an extra SLOAD to first read the
2323     // slot's contents, replace the bits taken up by the boolean, and then write
2324     // back. This is the compiler's defense against contract upgrades and
2325     // pointer aliasing, and it cannot be disabled.
2326 
2327     // The values being non-zero value makes deployment a bit more expensive,
2328     // but in exchange the refund on every call to nonReentrant will be lower in
2329     // amount. Since refunds are capped to a percentage of the total
2330     // transaction's gas, it is best to keep them low in cases like this one, to
2331     // increase the likelihood of the full refund coming into effect.
2332     uint256 private constant _NOT_ENTERED = 1;
2333     uint256 private constant _ENTERED = 2;
2334 
2335     uint256 private _status;
2336 
2337     constructor() {
2338         _status = _NOT_ENTERED;
2339     }
2340 
2341     /**
2342      * @dev Prevents a contract from calling itself, directly or indirectly.
2343      * Calling a `nonReentrant` function from another `nonReentrant`
2344      * function is not supported. It is possible to prevent this from happening
2345      * by making the `nonReentrant` function external, and making it call a
2346      * `private` function that does the actual work.
2347      */
2348     modifier nonReentrant() {
2349         // On the first call to nonReentrant, _notEntered will be true
2350         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2351 
2352         // Any calls to nonReentrant after this point will fail
2353         _status = _ENTERED;
2354 
2355         _;
2356 
2357         // By storing the original value once again, a refund is triggered (see
2358         // https://eips.ethereum.org/EIPS/eip-2200)
2359         _status = _NOT_ENTERED;
2360     }
2361 }
2362 
2363 pragma solidity ^0.8.4;
2364 
2365 error ApprovalCallerNotOwnerNorApproved();
2366 error ApprovalQueryForNonexistentToken();
2367 error ApproveToCaller();
2368 error ApprovalToCurrentOwner();
2369 error BalanceQueryForZeroAddress();
2370 error MintToZeroAddress();
2371 error MintZeroQuantity();
2372 error OwnerQueryForNonexistentToken();
2373 error TransferCallerNotOwnerNorApproved();
2374 error TransferFromIncorrectOwner();
2375 error TransferToNonERC721ReceiverImplementer();
2376 error TransferToZeroAddress();
2377 error URIQueryForNonexistentToken();
2378 
2379 /**
2380  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2381  * the Metadata extension. Built to optimize for lower gas during batch mints.
2382  *
2383  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2384  *
2385  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2386  *
2387  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2388  */
2389 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2390     using Address for address;
2391     using Strings for uint256;
2392 
2393     // Compiler will pack this into a single 256bit word.
2394     struct TokenOwnership {
2395         // The address of the owner.
2396         address addr;
2397         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2398         uint64 startTimestamp;
2399         // Whether the token has been burned.
2400         bool burned;
2401     }
2402 
2403     // Compiler will pack this into a single 256bit word.
2404     struct AddressData {
2405         // Realistically, 2**64-1 is more than enough.
2406         uint64 balance;
2407         // Keeps track of mint count with minimal overhead for tokenomics.
2408         uint64 numberMinted;
2409         // Keeps track of burn count with minimal overhead for tokenomics.
2410         uint64 numberBurned;
2411         // For miscellaneous variable(s) pertaining to the address
2412         // (e.g. number of whitelist mint slots used).
2413         // If there are multiple variables, please pack them into a uint64.
2414         uint64 aux;
2415     }
2416 
2417     // The tokenId of the next token to be minted.
2418     uint256 internal _currentIndex;
2419 
2420     // The number of tokens burned.
2421     uint256 internal _burnCounter;
2422 
2423     // Token name
2424     string private _name;
2425 
2426     // Token symbol
2427     string private _symbol;
2428 
2429     // Mapping from token ID to ownership details
2430     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2431     mapping(uint256 => TokenOwnership) internal _ownerships;
2432 
2433     // Mapping owner address to address data
2434     mapping(address => AddressData) private _addressData;
2435 
2436     // Mapping from token ID to approved address
2437     mapping(uint256 => address) private _tokenApprovals;
2438 
2439     // Mapping from owner to operator approvals
2440     mapping(address => mapping(address => bool)) private _operatorApprovals;
2441 
2442     constructor(string memory name_, string memory symbol_) {
2443         _name = name_;
2444         _symbol = symbol_;
2445         _currentIndex = _startTokenId();
2446     }
2447 
2448     /**
2449      * To change the starting tokenId, please override this function.
2450      */
2451     function _startTokenId() internal view virtual returns (uint256) {
2452         return 0;
2453     }
2454 
2455     /**
2456      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2457      */
2458     function totalSupply() public view returns (uint256) {
2459         // Counter underflow is impossible as _burnCounter cannot be incremented
2460         // more than _currentIndex - _startTokenId() times
2461         unchecked {
2462             return _currentIndex - _burnCounter - _startTokenId();
2463         }
2464     }
2465 
2466     /**
2467      * Returns the total amount of tokens minted in the contract.
2468      */
2469     function _totalMinted() internal view returns (uint256) {
2470         // Counter underflow is impossible as _currentIndex does not decrement,
2471         // and it is initialized to _startTokenId()
2472         unchecked {
2473             return _currentIndex - _startTokenId();
2474         }
2475     }
2476 
2477     /**
2478      * @dev See {IERC165-supportsInterface}.
2479      */
2480     function supportsInterface(bytes4 interfaceId)
2481         public
2482         view
2483         virtual
2484         override(ERC165, IERC165)
2485         returns (bool)
2486     {
2487         return
2488             interfaceId == type(IERC721).interfaceId ||
2489             interfaceId == type(IERC721Metadata).interfaceId ||
2490             super.supportsInterface(interfaceId);
2491     }
2492 
2493     /**
2494      * @dev See {IERC721-balanceOf}.
2495      */
2496     function balanceOf(address owner) public view override returns (uint256) {
2497         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2498         return uint256(_addressData[owner].balance);
2499     }
2500 
2501     /**
2502      * Returns the number of tokens minted by `owner`.
2503      */
2504     function _numberMinted(address owner) internal view returns (uint256) {
2505         return uint256(_addressData[owner].numberMinted);
2506     }
2507 
2508     /**
2509      * Returns the number of tokens burned by or on behalf of `owner`.
2510      */
2511     function _numberBurned(address owner) internal view returns (uint256) {
2512         return uint256(_addressData[owner].numberBurned);
2513     }
2514 
2515     /**
2516      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2517      */
2518     function _getAux(address owner) internal view returns (uint64) {
2519         return _addressData[owner].aux;
2520     }
2521 
2522     /**
2523      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2524      * If there are multiple variables, please pack them into a uint64.
2525      */
2526     function _setAux(address owner, uint64 aux) internal {
2527         _addressData[owner].aux = aux;
2528     }
2529 
2530     /**
2531      * Gas spent here starts off proportional to the maximum mint batch size.
2532      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2533      */
2534     function _ownershipOf(uint256 tokenId)
2535         internal
2536         view
2537         returns (TokenOwnership memory)
2538     {
2539         uint256 curr = tokenId;
2540 
2541         unchecked {
2542             if (_startTokenId() <= curr && curr < _currentIndex) {
2543                 TokenOwnership memory ownership = _ownerships[curr];
2544                 if (!ownership.burned) {
2545                     if (ownership.addr != address(0)) {
2546                         return ownership;
2547                     }
2548                     // Invariant:
2549                     // There will always be an ownership that has an address and is not burned
2550                     // before an ownership that does not have an address and is not burned.
2551                     // Hence, curr will not underflow.
2552                     while (true) {
2553                         curr--;
2554                         ownership = _ownerships[curr];
2555                         if (ownership.addr != address(0)) {
2556                             return ownership;
2557                         }
2558                     }
2559                 }
2560             }
2561         }
2562         revert OwnerQueryForNonexistentToken();
2563     }
2564 
2565     /**
2566      * @dev See {IERC721-ownerOf}.
2567      */
2568     function ownerOf(uint256 tokenId) public view override returns (address) {
2569         return _ownershipOf(tokenId).addr;
2570     }
2571 
2572     /**
2573      * @dev See {IERC721Metadata-name}.
2574      */
2575     function name() public view virtual override returns (string memory) {
2576         return _name;
2577     }
2578 
2579     /**
2580      * @dev See {IERC721Metadata-symbol}.
2581      */
2582     function symbol() public view virtual override returns (string memory) {
2583         return _symbol;
2584     }
2585 
2586     /**
2587      * @dev See {IERC721Metadata-tokenURI}.
2588      */
2589     function tokenURI(uint256 tokenId)
2590         public
2591         view
2592         virtual
2593         override
2594         returns (string memory)
2595     {
2596         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2597 
2598         string memory baseURI = _baseURI();
2599         return
2600             bytes(baseURI).length != 0
2601                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2602                 : "";
2603     }
2604 
2605     /**
2606      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2607      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2608      * by default, can be overriden in child contracts.
2609      */
2610     function _baseURI() internal view virtual returns (string memory) {
2611         return "";
2612     }
2613 
2614     /**
2615      * @dev See {IERC721-approve}.
2616      */
2617     function approve(address to, uint256 tokenId) public override {
2618         address owner = ERC721A.ownerOf(tokenId);
2619         if (to == owner) revert ApprovalToCurrentOwner();
2620 
2621         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2622             revert ApprovalCallerNotOwnerNorApproved();
2623         }
2624 
2625         _approve(to, tokenId, owner);
2626     }
2627 
2628     /**
2629      * @dev See {IERC721-getApproved}.
2630      */
2631     function getApproved(uint256 tokenId)
2632         public
2633         view
2634         override
2635         returns (address)
2636     {
2637         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2638 
2639         return _tokenApprovals[tokenId];
2640     }
2641 
2642     /**
2643      * @dev See {IERC721-setApprovalForAll}.
2644      */
2645     function setApprovalForAll(address operator, bool approved)
2646         public
2647         virtual
2648         override
2649     {
2650         if (operator == _msgSender()) revert ApproveToCaller();
2651 
2652         _operatorApprovals[_msgSender()][operator] = approved;
2653         emit ApprovalForAll(_msgSender(), operator, approved);
2654     }
2655 
2656     /**
2657      * @dev See {IERC721-isApprovedForAll}.
2658      */
2659     function isApprovedForAll(address owner, address operator)
2660         public
2661         view
2662         virtual
2663         override
2664         returns (bool)
2665     {
2666         return _operatorApprovals[owner][operator];
2667     }
2668 
2669     /**
2670      * @dev See {IERC721-transferFrom}.
2671      */
2672     function transferFrom(
2673         address from,
2674         address to,
2675         uint256 tokenId
2676     ) public virtual override {
2677         _transfer(from, to, tokenId);
2678     }
2679 
2680     /**
2681      * @dev See {IERC721-safeTransferFrom}.
2682      */
2683     function safeTransferFrom(
2684         address from,
2685         address to,
2686         uint256 tokenId
2687     ) public virtual override {
2688         safeTransferFrom(from, to, tokenId, "");
2689     }
2690 
2691     /**
2692      * @dev See {IERC721-safeTransferFrom}.
2693      */
2694     function safeTransferFrom(
2695         address from,
2696         address to,
2697         uint256 tokenId,
2698         bytes memory _data
2699     ) public virtual override {
2700         _transfer(from, to, tokenId);
2701         if (
2702             to.isContract() &&
2703             !_checkContractOnERC721Received(from, to, tokenId, _data)
2704         ) {
2705             revert TransferToNonERC721ReceiverImplementer();
2706         }
2707     }
2708 
2709     /**
2710      * @dev Returns whether `tokenId` exists.
2711      *
2712      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2713      *
2714      * Tokens start existing when they are minted (`_mint`),
2715      */
2716     function _exists(uint256 tokenId) internal view returns (bool) {
2717         return
2718             _startTokenId() <= tokenId &&
2719             tokenId < _currentIndex &&
2720             !_ownerships[tokenId].burned;
2721     }
2722 
2723     function _safeMint(address to, uint256 quantity) internal {
2724         _safeMint(to, quantity, "");
2725     }
2726 
2727     /**
2728      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2729      *
2730      * Requirements:
2731      *
2732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2733      * - `quantity` must be greater than 0.
2734      *
2735      * Emits a {Transfer} event.
2736      */
2737     function _safeMint(
2738         address to,
2739         uint256 quantity,
2740         bytes memory _data
2741     ) internal {
2742         _mint(to, quantity, _data, true);
2743     }
2744 
2745     /**
2746      * @dev Mints `quantity` tokens and transfers them to `to`.
2747      *
2748      * Requirements:
2749      *
2750      * - `to` cannot be the zero address.
2751      * - `quantity` must be greater than 0.
2752      *
2753      * Emits a {Transfer} event.
2754      */
2755     function _mint(
2756         address to,
2757         uint256 quantity,
2758         bytes memory _data,
2759         bool safe
2760     ) internal {
2761         uint256 startTokenId = _currentIndex;
2762         if (to == address(0)) revert MintToZeroAddress();
2763         if (quantity == 0) revert MintZeroQuantity();
2764 
2765         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2766 
2767         // Overflows are incredibly unrealistic.
2768         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2769         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2770         unchecked {
2771             _addressData[to].balance += uint64(quantity);
2772             _addressData[to].numberMinted += uint64(quantity);
2773 
2774             _ownerships[startTokenId].addr = to;
2775             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2776 
2777             uint256 updatedIndex = startTokenId;
2778             uint256 end = updatedIndex + quantity;
2779 
2780             if (safe && to.isContract()) {
2781                 do {
2782                     emit Transfer(address(0), to, updatedIndex);
2783                     if (
2784                         !_checkContractOnERC721Received(
2785                             address(0),
2786                             to,
2787                             updatedIndex++,
2788                             _data
2789                         )
2790                     ) {
2791                         revert TransferToNonERC721ReceiverImplementer();
2792                     }
2793                 } while (updatedIndex != end);
2794                 // Reentrancy protection
2795                 if (_currentIndex != startTokenId) revert();
2796             } else {
2797                 do {
2798                     emit Transfer(address(0), to, updatedIndex++);
2799                 } while (updatedIndex != end);
2800             }
2801             _currentIndex = updatedIndex;
2802         }
2803         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2804     }
2805 
2806     /**
2807      * @dev Transfers `tokenId` from `from` to `to`.
2808      *
2809      * Requirements:
2810      *
2811      * - `to` cannot be the zero address.
2812      * - `tokenId` token must be owned by `from`.
2813      *
2814      * Emits a {Transfer} event.
2815      */
2816     function _transfer(
2817         address from,
2818         address to,
2819         uint256 tokenId
2820     ) private {
2821         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2822 
2823         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2824 
2825         bool isApprovedOrOwner = (_msgSender() == from ||
2826             isApprovedForAll(from, _msgSender()) ||
2827             getApproved(tokenId) == _msgSender());
2828 
2829         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2830         if (to == address(0)) revert TransferToZeroAddress();
2831 
2832         _beforeTokenTransfers(from, to, tokenId, 1);
2833 
2834         // Clear approvals from the previous owner
2835         _approve(address(0), tokenId, from);
2836 
2837         // Underflow of the sender's balance is impossible because we check for
2838         // ownership above and the recipient's balance can't realistically overflow.
2839         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2840         unchecked {
2841             _addressData[from].balance -= 1;
2842             _addressData[to].balance += 1;
2843 
2844             TokenOwnership storage currSlot = _ownerships[tokenId];
2845             currSlot.addr = to;
2846             currSlot.startTimestamp = uint64(block.timestamp);
2847 
2848             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2849             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2850             uint256 nextTokenId = tokenId + 1;
2851             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2852             if (nextSlot.addr == address(0)) {
2853                 // This will suffice for checking _exists(nextTokenId),
2854                 // as a burned slot cannot contain the zero address.
2855                 if (nextTokenId != _currentIndex) {
2856                     nextSlot.addr = from;
2857                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2858                 }
2859             }
2860         }
2861 
2862         emit Transfer(from, to, tokenId);
2863         _afterTokenTransfers(from, to, tokenId, 1);
2864     }
2865 
2866     /**
2867      * @dev This is equivalent to _burn(tokenId, false)
2868      */
2869     function _burn(uint256 tokenId) internal virtual {
2870         _burn(tokenId, false);
2871     }
2872 
2873     /**
2874      * @dev Destroys `tokenId`.
2875      * The approval is cleared when the token is burned.
2876      *
2877      * Requirements:
2878      *
2879      * - `tokenId` must exist.
2880      *
2881      * Emits a {Transfer} event.
2882      */
2883     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2884         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2885 
2886         address from = prevOwnership.addr;
2887 
2888         if (approvalCheck) {
2889             bool isApprovedOrOwner = (_msgSender() == from ||
2890                 isApprovedForAll(from, _msgSender()) ||
2891                 getApproved(tokenId) == _msgSender());
2892 
2893             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2894         }
2895 
2896         _beforeTokenTransfers(from, address(0), tokenId, 1);
2897 
2898         // Clear approvals from the previous owner
2899         _approve(address(0), tokenId, from);
2900 
2901         // Underflow of the sender's balance is impossible because we check for
2902         // ownership above and the recipient's balance can't realistically overflow.
2903         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2904         unchecked {
2905             AddressData storage addressData = _addressData[from];
2906             addressData.balance -= 1;
2907             addressData.numberBurned += 1;
2908 
2909             // Keep track of who burned the token, and the timestamp of burning.
2910             TokenOwnership storage currSlot = _ownerships[tokenId];
2911             currSlot.addr = from;
2912             currSlot.startTimestamp = uint64(block.timestamp);
2913             currSlot.burned = true;
2914 
2915             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2916             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2917             uint256 nextTokenId = tokenId + 1;
2918             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2919             if (nextSlot.addr == address(0)) {
2920                 // This will suffice for checking _exists(nextTokenId),
2921                 // as a burned slot cannot contain the zero address.
2922                 if (nextTokenId != _currentIndex) {
2923                     nextSlot.addr = from;
2924                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2925                 }
2926             }
2927         }
2928 
2929         emit Transfer(from, address(0), tokenId);
2930         _afterTokenTransfers(from, address(0), tokenId, 1);
2931 
2932         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2933         unchecked {
2934             _burnCounter++;
2935         }
2936     }
2937 
2938     /**
2939      * @dev Approve `to` to operate on `tokenId`
2940      *
2941      * Emits a {Approval} event.
2942      */
2943     function _approve(
2944         address to,
2945         uint256 tokenId,
2946         address owner
2947     ) private {
2948         _tokenApprovals[tokenId] = to;
2949         emit Approval(owner, to, tokenId);
2950     }
2951 
2952     /**
2953      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2954      *
2955      * @param from address representing the previous owner of the given token ID
2956      * @param to target address that will receive the tokens
2957      * @param tokenId uint256 ID of the token to be transferred
2958      * @param _data bytes optional data to send along with the call
2959      * @return bool whether the call correctly returned the expected magic value
2960      */
2961     function _checkContractOnERC721Received(
2962         address from,
2963         address to,
2964         uint256 tokenId,
2965         bytes memory _data
2966     ) private returns (bool) {
2967         try
2968             IERC721Receiver(to).onERC721Received(
2969                 _msgSender(),
2970                 from,
2971                 tokenId,
2972                 _data
2973             )
2974         returns (bytes4 retval) {
2975             return retval == IERC721Receiver(to).onERC721Received.selector;
2976         } catch (bytes memory reason) {
2977             if (reason.length == 0) {
2978                 revert TransferToNonERC721ReceiverImplementer();
2979             } else {
2980                 assembly {
2981                     revert(add(32, reason), mload(reason))
2982                 }
2983             }
2984         }
2985     }
2986 
2987     /**
2988      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2989      * And also called before burning one token.
2990      *
2991      * startTokenId - the first token id to be transferred
2992      * quantity - the amount to be transferred
2993      *
2994      * Calling conditions:
2995      *
2996      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2997      * transferred to `to`.
2998      * - When `from` is zero, `tokenId` will be minted for `to`.
2999      * - When `to` is zero, `tokenId` will be burned by `from`.
3000      * - `from` and `to` are never both zero.
3001      */
3002     function _beforeTokenTransfers(
3003         address from,
3004         address to,
3005         uint256 startTokenId,
3006         uint256 quantity
3007     ) internal virtual {}
3008 
3009     /**
3010      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3011      * minting.
3012      * And also called after one token has been burned.
3013      *
3014      * startTokenId - the first token id to be transferred
3015      * quantity - the amount to be transferred
3016      *
3017      * Calling conditions:
3018      *
3019      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
3020      * transferred to `to`.
3021      * - When `from` is zero, `tokenId` has been minted for `to`.
3022      * - When `to` is zero, `tokenId` has been burned by `from`.
3023      * - `from` and `to` are never both zero.
3024      */
3025     function _afterTokenTransfers(
3026         address from,
3027         address to,
3028         uint256 startTokenId,
3029         uint256 quantity
3030     ) internal virtual {}
3031 }
3032 
3033 pragma solidity ^0.8.0;
3034 
3035 /**
3036  * @dev Interface of the ERC20 standard as defined in the EIP.
3037  */
3038 interface IERC20 {
3039     /**
3040      * @dev Emitted when `value` tokens are moved from one account (`from`) to
3041      * another (`to`).
3042      *
3043      * Note that `value` may be zero.
3044      */
3045     event Transfer(address indexed from, address indexed to, uint256 value);
3046 
3047     /**
3048      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
3049      * a call to {approve}. `value` is the new allowance.
3050      */
3051     event Approval(
3052         address indexed owner,
3053         address indexed spender,
3054         uint256 value
3055     );
3056 
3057     /**
3058      * @dev Returns the amount of tokens in existence.
3059      */
3060     function totalSupply() external view returns (uint256);
3061 
3062     /**
3063      * @dev Returns the amount of tokens owned by `account`.
3064      */
3065     function balanceOf(address account) external view returns (uint256);
3066 
3067     /**
3068      * @dev Moves `amount` tokens from the caller's account to `to`.
3069      *
3070      * Returns a boolean value indicating whether the operation succeeded.
3071      *
3072      * Emits a {Transfer} event.
3073      */
3074     function transfer(address to, uint256 amount) external returns (bool);
3075 
3076     /**
3077      * @dev Returns the remaining number of tokens that `spender` will be
3078      * allowed to spend on behalf of `owner` through {transferFrom}. This is
3079      * zero by default.
3080      *
3081      * This value changes when {approve} or {transferFrom} are called.
3082      */
3083     function allowance(address owner, address spender)
3084         external
3085         view
3086         returns (uint256);
3087 
3088     /**
3089      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
3090      *
3091      * Returns a boolean value indicating whether the operation succeeded.
3092      *
3093      * IMPORTANT: Beware that changing an allowance with this method brings the risk
3094      * that someone may use both the old and the new allowance by unfortunate
3095      * transaction ordering. One possible solution to mitigate this race
3096      * condition is to first reduce the spender's allowance to 0 and set the
3097      * desired value afterwards:
3098      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
3099      *
3100      * Emits an {Approval} event.
3101      */
3102     function approve(address spender, uint256 amount) external returns (bool);
3103 
3104     /**
3105      * @dev Moves `amount` tokens from `from` to `to` using the
3106      * allowance mechanism. `amount` is then deducted from the caller's
3107      * allowance.
3108      *
3109      * Returns a boolean value indicating whether the operation succeeded.
3110      *
3111      * Emits a {Transfer} event.
3112      */
3113     function transferFrom(
3114         address from,
3115         address to,
3116         uint256 amount
3117     ) external returns (bool);
3118 }
3119 
3120 pragma solidity ^0.8.0;
3121 
3122 /**
3123  * @title SafeERC20
3124  * @dev Wrappers around ERC20 operations that throw on failure (when the token
3125  * contract returns false). Tokens that return no value (and instead revert or
3126  * throw on failure) are also supported, non-reverting calls are assumed to be
3127  * successful.
3128  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
3129  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
3130  */
3131 library SafeERC20 {
3132     using Address for address;
3133 
3134     function safeTransfer(
3135         IERC20 token,
3136         address to,
3137         uint256 value
3138     ) internal {
3139         _callOptionalReturn(
3140             token,
3141             abi.encodeWithSelector(token.transfer.selector, to, value)
3142         );
3143     }
3144 
3145     function safeTransferFrom(
3146         IERC20 token,
3147         address from,
3148         address to,
3149         uint256 value
3150     ) internal {
3151         _callOptionalReturn(
3152             token,
3153             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
3154         );
3155     }
3156 
3157     /**
3158      * @dev Deprecated. This function has issues similar to the ones found in
3159      * {IERC20-approve}, and its usage is discouraged.
3160      *
3161      * Whenever possible, use {safeIncreaseAllowance} and
3162      * {safeDecreaseAllowance} instead.
3163      */
3164     function safeApprove(
3165         IERC20 token,
3166         address spender,
3167         uint256 value
3168     ) internal {
3169         // safeApprove should only be called when setting an initial allowance,
3170         // or when resetting it to zero. To increase and decrease it, use
3171         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
3172         require(
3173             (value == 0) || (token.allowance(address(this), spender) == 0),
3174             "SafeERC20: approve from non-zero to non-zero allowance"
3175         );
3176         _callOptionalReturn(
3177             token,
3178             abi.encodeWithSelector(token.approve.selector, spender, value)
3179         );
3180     }
3181 
3182     function safeIncreaseAllowance(
3183         IERC20 token,
3184         address spender,
3185         uint256 value
3186     ) internal {
3187         uint256 newAllowance = token.allowance(address(this), spender) + value;
3188         _callOptionalReturn(
3189             token,
3190             abi.encodeWithSelector(
3191                 token.approve.selector,
3192                 spender,
3193                 newAllowance
3194             )
3195         );
3196     }
3197 
3198     function safeDecreaseAllowance(
3199         IERC20 token,
3200         address spender,
3201         uint256 value
3202     ) internal {
3203         unchecked {
3204             uint256 oldAllowance = token.allowance(address(this), spender);
3205             require(
3206                 oldAllowance >= value,
3207                 "SafeERC20: decreased allowance below zero"
3208             );
3209             uint256 newAllowance = oldAllowance - value;
3210             _callOptionalReturn(
3211                 token,
3212                 abi.encodeWithSelector(
3213                     token.approve.selector,
3214                     spender,
3215                     newAllowance
3216                 )
3217             );
3218         }
3219     }
3220 
3221     /**
3222      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
3223      * on the return value: the return value is optional (but if data is returned, it must not be false).
3224      * @param token The token targeted by the call.
3225      * @param data The call data (encoded using abi.encode or one of its variants).
3226      */
3227     function _callOptionalReturn(IERC20 token, bytes memory data) private {
3228         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
3229         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
3230         // the target address contains contract code and also asserts for success in the low-level call.
3231 
3232         bytes memory returndata = address(token).functionCall(
3233             data,
3234             "SafeERC20: low-level call failed"
3235         );
3236         if (returndata.length > 0) {
3237             // Return data is optional
3238             require(
3239                 abi.decode(returndata, (bool)),
3240                 "SafeERC20: ERC20 operation did not succeed"
3241             );
3242         }
3243     }
3244 }
3245 
3246 pragma solidity ^0.8.0;
3247 
3248 /**
3249  * @title PaymentSplitter
3250  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
3251  * that the Ether will be split in this way, since it is handled transparently by the contract.
3252  *
3253  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
3254  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
3255  * an amount proportional to the percentage of total shares they were assigned.
3256  *
3257  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
3258  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
3259  * function.
3260  *
3261  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
3262  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
3263  * to run tests before sending real value to this contract.
3264  */
3265 contract PaymentSplitter is Context {
3266     event PayeeAdded(address account, uint256 shares);
3267     event PaymentReleased(address to, uint256 amount);
3268     event ERC20PaymentReleased(
3269         IERC20 indexed token,
3270         address to,
3271         uint256 amount
3272     );
3273     event PaymentReceived(address from, uint256 amount);
3274 
3275     uint256 private _totalShares;
3276     uint256 private _totalReleased;
3277 
3278     mapping(address => uint256) private _shares;
3279     mapping(address => uint256) private _released;
3280     address[] private _payees;
3281 
3282     mapping(IERC20 => uint256) private _erc20TotalReleased;
3283     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
3284 
3285     /**
3286      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
3287      * the matching position in the `shares` array.
3288      *
3289      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
3290      * duplicates in `payees`.
3291      */
3292     constructor(address[] memory payees, uint256[] memory shares_) payable {
3293         require(
3294             payees.length == shares_.length,
3295             "PaymentSplitter: payees and shares length mismatch"
3296         );
3297         require(payees.length > 0, "PaymentSplitter: no payees");
3298 
3299         for (uint256 i = 0; i < payees.length; i++) {
3300             _addPayee(payees[i], shares_[i]);
3301         }
3302     }
3303 
3304     /**
3305      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
3306      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
3307      * reliability of the events, and not the actual splitting of Ether.
3308      *
3309      * To learn more about this see the Solidity documentation for
3310      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
3311      * functions].
3312      */
3313     receive() external payable virtual {
3314         emit PaymentReceived(_msgSender(), msg.value);
3315     }
3316 
3317     /**
3318      * @dev Getter for the total shares held by payees.
3319      */
3320     function totalShares() public view returns (uint256) {
3321         return _totalShares;
3322     }
3323 
3324     /**
3325      * @dev Getter for the total amount of Ether already released.
3326      */
3327     function totalReleased() public view returns (uint256) {
3328         return _totalReleased;
3329     }
3330 
3331     /**
3332      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
3333      * contract.
3334      */
3335     function totalReleased(IERC20 token) public view returns (uint256) {
3336         return _erc20TotalReleased[token];
3337     }
3338 
3339     /**
3340      * @dev Getter for the amount of shares held by an account.
3341      */
3342     function shares(address account) public view returns (uint256) {
3343         return _shares[account];
3344     }
3345 
3346     /**
3347      * @dev Getter for the amount of Ether already released to a payee.
3348      */
3349     function released(address account) public view returns (uint256) {
3350         return _released[account];
3351     }
3352 
3353     /**
3354      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
3355      * IERC20 contract.
3356      */
3357     function released(IERC20 token, address account)
3358         public
3359         view
3360         returns (uint256)
3361     {
3362         return _erc20Released[token][account];
3363     }
3364 
3365     /**
3366      * @dev Getter for the address of the payee number `index`.
3367      */
3368     function payee(uint256 index) public view returns (address) {
3369         return _payees[index];
3370     }
3371 
3372     /**
3373      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
3374      * total shares and their previous withdrawals.
3375      */
3376     function release(address payable account) public virtual {
3377         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3378 
3379         uint256 totalReceived = address(this).balance + totalReleased();
3380         uint256 payment = _pendingPayment(
3381             account,
3382             totalReceived,
3383             released(account)
3384         );
3385 
3386         require(payment != 0, "PaymentSplitter: account is not due payment");
3387 
3388         _released[account] += payment;
3389         _totalReleased += payment;
3390 
3391         Address.sendValue(account, payment);
3392         emit PaymentReleased(account, payment);
3393     }
3394 
3395     /**
3396      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
3397      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
3398      * contract.
3399      */
3400     function release(IERC20 token, address account) public virtual {
3401         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3402 
3403         uint256 totalReceived = token.balanceOf(address(this)) +
3404             totalReleased(token);
3405         uint256 payment = _pendingPayment(
3406             account,
3407             totalReceived,
3408             released(token, account)
3409         );
3410 
3411         require(payment != 0, "PaymentSplitter: account is not due payment");
3412 
3413         _erc20Released[token][account] += payment;
3414         _erc20TotalReleased[token] += payment;
3415 
3416         SafeERC20.safeTransfer(token, account, payment);
3417         emit ERC20PaymentReleased(token, account, payment);
3418     }
3419 
3420     /**
3421      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
3422      * already released amounts.
3423      */
3424     function _pendingPayment(
3425         address account,
3426         uint256 totalReceived,
3427         uint256 alreadyReleased
3428     ) private view returns (uint256) {
3429         return
3430             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
3431     }
3432 
3433     /**
3434      * @dev Add a new payee to the contract.
3435      * @param account The address of the payee to add.
3436      * @param shares_ The number of shares owned by the payee.
3437      */
3438     function _addPayee(address account, uint256 shares_) private {
3439         require(
3440             account != address(0),
3441             "PaymentSplitter: account is the zero address"
3442         );
3443         require(shares_ > 0, "PaymentSplitter: shares are 0");
3444         require(
3445             _shares[account] == 0,
3446             "PaymentSplitter: account already has shares"
3447         );
3448 
3449         _payees.push(account);
3450         _shares[account] = shares_;
3451         _totalShares = _totalShares + shares_;
3452         emit PayeeAdded(account, shares_);
3453     }
3454 }
3455 
3456 pragma solidity ^0.8.0;
3457 
3458 contract LiquidKeys is ERC721A, ReentrancyGuard, Ownable, PaymentSplitter {
3459     // Minting Variables
3460     uint256 public mintPrice = 0.420 ether;
3461     uint256 public maxPurchase = 1;
3462     uint256 public maxSupply = 3333;
3463 
3464     address[] public _payees = [
3465         0x7FDE663601A53A6953bbb98F1Ab87E86dEE81b35, // Liquid Payments
3466         0x867Eb0804eACA9FEeda8a0E1d2B9a32eEF58AF8f // Aleph0ne
3467     ];
3468     uint256[] private _shares = [10, 90];
3469 
3470     // Sale Status
3471     bool public saleIsActive = false;
3472     bool public airdropIsActive = true;
3473 
3474     mapping(address => uint256) public addressesThatMinted;
3475 
3476     // Metadata
3477     string _baseTokenURI =
3478         "https://apeliquid.mypinata.cloud/ipfs/QmPT8KDtweNFx1EqtFdaYhkrvAGeAGoY1ubCGxKx8spDur/";
3479     bool public locked;
3480 
3481     // Events
3482     event SaleActivation(bool isActive);
3483     event AirdropActivation(bool isActive);
3484 
3485     constructor()
3486         ERC721A("Liquid Key", "ALKEY")
3487         PaymentSplitter(_payees, _shares)
3488     {}
3489 
3490     //Holder status validation
3491 
3492     // Minting
3493     function ownerMint(address _to, uint256 _count) external onlyOwner {
3494         require(totalSupply() + _count <= maxSupply, "SOLD OUT");
3495         _safeMint(_to, _count);
3496     }
3497 
3498     function airdrop(uint256[] calldata _counts, address[] calldata _list)
3499         external
3500         onlyOwner
3501     {
3502         require(airdropIsActive, "AIRDROP NOT ACTIVE");
3503 
3504         for (uint256 i = 0; i < _list.length; i++) {
3505             //_mint(_list[i], _dropNumber, 1, "");
3506             require(totalSupply() + _counts[i] <= maxSupply, "SOLD OUT");
3507             _safeMint(_list[i], _counts[i]);
3508         }
3509     }
3510 
3511     function mint(uint256 _count) external payable nonReentrant {
3512         require(saleIsActive, "SALE INACTIVE");
3513         require(
3514             ((addressesThatMinted[msg.sender] + _count)) <= maxPurchase,
3515             "this would exceed mint max allowance"
3516         );
3517 
3518         require(totalSupply() + _count <= maxSupply, "SOLD OUT");
3519         require(mintPrice * _count <= msg.value, "INCORRECT ETHER VALUE");
3520 
3521         _safeMint(msg.sender, _count);
3522         addressesThatMinted[msg.sender] += _count;
3523     }
3524 
3525     function toggleSaleStatus() external onlyOwner {
3526         saleIsActive = !saleIsActive;
3527         emit SaleActivation(saleIsActive);
3528     }
3529 
3530     function toggleAirdropStatus() external onlyOwner {
3531         airdropIsActive = !airdropIsActive;
3532         emit AirdropActivation(airdropIsActive);
3533     }
3534 
3535     function setMintPrice(uint256 _mintPrice) external onlyOwner {
3536         mintPrice = _mintPrice;
3537     }
3538 
3539     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
3540         maxPurchase = _maxPurchase;
3541     }
3542 
3543     function lockMetadata() external onlyOwner {
3544         locked = true;
3545     }
3546 
3547     // Payment
3548     function claim() external {
3549         release(payable(msg.sender));
3550     }
3551 
3552     function getWalletOfOwner(address owner)
3553         external
3554         view
3555         returns (uint256[] memory)
3556     {
3557         unchecked {
3558             uint256[] memory a = new uint256[](balanceOf(owner));
3559             uint256 end = _currentIndex;
3560             uint256 tokenIdsIdx;
3561             address currOwnershipAddr;
3562             for (uint256 i; i < end; i++) {
3563                 TokenOwnership memory ownership = _ownerships[i];
3564                 if (ownership.burned) {
3565                     continue;
3566                 }
3567                 if (ownership.addr != address(0)) {
3568                     currOwnershipAddr = ownership.addr;
3569                 }
3570                 if (currOwnershipAddr == owner) {
3571                     a[tokenIdsIdx++] = i;
3572                 }
3573             }
3574             return a;
3575         }
3576     }
3577 
3578     function getTotalSupply() external view returns (uint256) {
3579         return totalSupply();
3580     }
3581 
3582     function setBaseURI(string memory baseURI) external onlyOwner {
3583         require(!locked, "METADATA_LOCKED");
3584         _baseTokenURI = baseURI;
3585     }
3586 
3587     function _baseURI() internal view virtual override returns (string memory) {
3588         return _baseTokenURI;
3589     }
3590 
3591     function tokenURI(uint256 tokenId)
3592         public
3593         view
3594         override
3595         returns (string memory)
3596     {
3597         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
3598     }
3599 
3600     function _startTokenId() internal view virtual override returns (uint256) {
3601         return 1;
3602     }
3603 }