1 // SPDX-License-Identifier: MIT
2 
3 /*
4      _____                .____    .__             .__    .___   .__
5     /  _  \ ______   ____ |    |   |__| ________ __|__| __| _/   |__| ____
6    /  /_\  \\____ \_/ __ \|    |   |  |/ ____/  |  \  |/ __ |    |  |/  _ \
7   /    |    \  |_> >  ___/|    |___|  < <_|  |  |  /  / /_/ |    |  (  <_> )
8   \____|__  /   __/ \___  >_______ \__|\__   |____/|__\____ | /\ |__|\____/
9           \/|__|        \/        \/      |__|             \/ \/
10       __________        __
11       \______   \ _____/  |_  ______
12        |     ___// __ \   __\/  ___/
13        |    |   \  ___/|  |  \___ \
14        |____|    \___  >__| /____  >
15                      \/          \/
16 */
17 
18 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev External interface of AccessControl declared to support ERC165 detection.
24  */
25 interface IAccessControl {
26     /**
27      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
28      *
29      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
30      * {RoleAdminChanged} not being emitted signaling this.
31      *
32      * _Available since v3.1._
33      */
34     event RoleAdminChanged(
35         bytes32 indexed role,
36         bytes32 indexed previousAdminRole,
37         bytes32 indexed newAdminRole
38     );
39 
40     /**
41      * @dev Emitted when `account` is granted `role`.
42      *
43      * `sender` is the account that originated the contract call, an admin role
44      * bearer except when using {AccessControl-_setupRole}.
45      */
46     event RoleGranted(
47         bytes32 indexed role,
48         address indexed account,
49         address indexed sender
50     );
51 
52     /**
53      * @dev Emitted when `account` is revoked `role`.
54      *
55      * `sender` is the account that originated the contract call:
56      *   - if using `revokeRole`, it is the admin role bearer
57      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
58      */
59     event RoleRevoked(
60         bytes32 indexed role,
61         address indexed account,
62         address indexed sender
63     );
64 
65     /**
66      * @dev Returns `true` if `account` has been granted `role`.
67      */
68     function hasRole(bytes32 role, address account)
69         external
70         view
71         returns (bool);
72 
73     /**
74      * @dev Returns the admin role that controls `role`. See {grantRole} and
75      * {revokeRole}.
76      *
77      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
78      */
79     function getRoleAdmin(bytes32 role) external view returns (bytes32);
80 
81     /**
82      * @dev Grants `role` to `account`.
83      *
84      * If `account` had not been already granted `role`, emits a {RoleGranted}
85      * event.
86      *
87      * Requirements:
88      *
89      * - the caller must have ``role``'s admin role.
90      */
91     function grantRole(bytes32 role, address account) external;
92 
93     /**
94      * @dev Revokes `role` from `account`.
95      *
96      * If `account` had been granted `role`, emits a {RoleRevoked} event.
97      *
98      * Requirements:
99      *
100      * - the caller must have ``role``'s admin role.
101      */
102     function revokeRole(bytes32 role, address account) external;
103 
104     /**
105      * @dev Revokes `role` from the calling account.
106      *
107      * Roles are often managed via {grantRole} and {revokeRole}: this function's
108      * purpose is to provide a mechanism for accounts to lose their privileges
109      * if they are compromised (such as when a trusted device is misplaced).
110      *
111      * If the calling account had been granted `role`, emits a {RoleRevoked}
112      * event.
113      *
114      * Requirements:
115      *
116      * - the caller must be `account`.
117      */
118     function renounceRole(bytes32 role, address account) external;
119 }
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
148  */
149 interface IAccessControlEnumerable is IAccessControl {
150     /**
151      * @dev Returns one of the accounts that have `role`. `index` must be a
152      * value between 0 and {getRoleMemberCount}, non-inclusive.
153      *
154      * Role bearers are not sorted in any particular way, and their ordering may
155      * change at any point.
156      *
157      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
158      * you perform all queries on the same block. See the following
159      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
160      * for more information.
161      */
162     function getRoleMember(bytes32 role, uint256 index)
163         external
164         view
165         returns (address);
166 
167     /**
168      * @dev Returns the number of accounts that have `role`. Can be used
169      * together with {getRoleMember} to enumerate all bearers of a role.
170      */
171     function getRoleMemberCount(bytes32 role) external view returns (uint256);
172 }
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Library for managing
178  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
179  * types.
180  *
181  * Sets have the following properties:
182  *
183  * - Elements are added, removed, and checked for existence in constant time
184  * (O(1)).
185  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
186  *
187  * ```
188  * contract Example {
189  *     // Add the library methods
190  *     using EnumerableSet for EnumerableSet.AddressSet;
191  *
192  *     // Declare a set state variable
193  *     EnumerableSet.AddressSet private mySet;
194  * }
195  * ```
196  *
197  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
198  * and `uint256` (`UintSet`) are supported.
199  */
200 library EnumerableSet {
201     // To implement this library for multiple types with as little code
202     // repetition as possible, we write it in terms of a generic Set type with
203     // bytes32 values.
204     // The Set implementation uses private functions, and user-facing
205     // implementations (such as AddressSet) are just wrappers around the
206     // underlying Set.
207     // This means that we can only create new EnumerableSets for types that fit
208     // in bytes32.
209 
210     struct Set {
211         // Storage of set values
212         bytes32[] _values;
213         // Position of the value in the `values` array, plus 1 because index 0
214         // means a value is not in the set.
215         mapping(bytes32 => uint256) _indexes;
216     }
217 
218     /**
219      * @dev Add a value to a set. O(1).
220      *
221      * Returns true if the value was added to the set, that is if it was not
222      * already present.
223      */
224     function _add(Set storage set, bytes32 value) private returns (bool) {
225         if (!_contains(set, value)) {
226             set._values.push(value);
227             // The value is stored at length-1, but we add 1 to all indexes
228             // and use 0 as a sentinel value
229             set._indexes[value] = set._values.length;
230             return true;
231         } else {
232             return false;
233         }
234     }
235 
236     /**
237      * @dev Removes a value from a set. O(1).
238      *
239      * Returns true if the value was removed from the set, that is if it was
240      * present.
241      */
242     function _remove(Set storage set, bytes32 value) private returns (bool) {
243         // We read and store the value's index to prevent multiple reads from the same storage slot
244         uint256 valueIndex = set._indexes[value];
245 
246         if (valueIndex != 0) {
247             // Equivalent to contains(set, value)
248             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
249             // the array, and then remove the last element (sometimes called as 'swap and pop').
250             // This modifies the order of the array, as noted in {at}.
251 
252             uint256 toDeleteIndex = valueIndex - 1;
253             uint256 lastIndex = set._values.length - 1;
254 
255             if (lastIndex != toDeleteIndex) {
256                 bytes32 lastvalue = set._values[lastIndex];
257 
258                 // Move the last value to the index where the value to delete is
259                 set._values[toDeleteIndex] = lastvalue;
260                 // Update the index for the moved value
261                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
262             }
263 
264             // Delete the slot where the moved value was stored
265             set._values.pop();
266 
267             // Delete the index for the deleted slot
268             delete set._indexes[value];
269 
270             return true;
271         } else {
272             return false;
273         }
274     }
275 
276     /**
277      * @dev Returns true if the value is in the set. O(1).
278      */
279     function _contains(Set storage set, bytes32 value)
280         private
281         view
282         returns (bool)
283     {
284         return set._indexes[value] != 0;
285     }
286 
287     /**
288      * @dev Returns the number of values on the set. O(1).
289      */
290     function _length(Set storage set) private view returns (uint256) {
291         return set._values.length;
292     }
293 
294     /**
295      * @dev Returns the value stored at position `index` in the set. O(1).
296      *
297      * Note that there are no guarantees on the ordering of values inside the
298      * array, and it may change when more values are added or removed.
299      *
300      * Requirements:
301      *
302      * - `index` must be strictly less than {length}.
303      */
304     function _at(Set storage set, uint256 index)
305         private
306         view
307         returns (bytes32)
308     {
309         return set._values[index];
310     }
311 
312     /**
313      * @dev Return the entire set in an array
314      *
315      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
316      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
317      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
318      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
319      */
320     function _values(Set storage set) private view returns (bytes32[] memory) {
321         return set._values;
322     }
323 
324     // Bytes32Set
325 
326     struct Bytes32Set {
327         Set _inner;
328     }
329 
330     /**
331      * @dev Add a value to a set. O(1).
332      *
333      * Returns true if the value was added to the set, that is if it was not
334      * already present.
335      */
336     function add(Bytes32Set storage set, bytes32 value)
337         internal
338         returns (bool)
339     {
340         return _add(set._inner, value);
341     }
342 
343     /**
344      * @dev Removes a value from a set. O(1).
345      *
346      * Returns true if the value was removed from the set, that is if it was
347      * present.
348      */
349     function remove(Bytes32Set storage set, bytes32 value)
350         internal
351         returns (bool)
352     {
353         return _remove(set._inner, value);
354     }
355 
356     /**
357      * @dev Returns true if the value is in the set. O(1).
358      */
359     function contains(Bytes32Set storage set, bytes32 value)
360         internal
361         view
362         returns (bool)
363     {
364         return _contains(set._inner, value);
365     }
366 
367     /**
368      * @dev Returns the number of values in the set. O(1).
369      */
370     function length(Bytes32Set storage set) internal view returns (uint256) {
371         return _length(set._inner);
372     }
373 
374     /**
375      * @dev Returns the value stored at position `index` in the set. O(1).
376      *
377      * Note that there are no guarantees on the ordering of values inside the
378      * array, and it may change when more values are added or removed.
379      *
380      * Requirements:
381      *
382      * - `index` must be strictly less than {length}.
383      */
384     function at(Bytes32Set storage set, uint256 index)
385         internal
386         view
387         returns (bytes32)
388     {
389         return _at(set._inner, index);
390     }
391 
392     /**
393      * @dev Return the entire set in an array
394      *
395      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
396      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
397      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
398      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
399      */
400     function values(Bytes32Set storage set)
401         internal
402         view
403         returns (bytes32[] memory)
404     {
405         return _values(set._inner);
406     }
407 
408     // AddressSet
409 
410     struct AddressSet {
411         Set _inner;
412     }
413 
414     /**
415      * @dev Add a value to a set. O(1).
416      *
417      * Returns true if the value was added to the set, that is if it was not
418      * already present.
419      */
420     function add(AddressSet storage set, address value)
421         internal
422         returns (bool)
423     {
424         return _add(set._inner, bytes32(uint256(uint160(value))));
425     }
426 
427     /**
428      * @dev Removes a value from a set. O(1).
429      *
430      * Returns true if the value was removed from the set, that is if it was
431      * present.
432      */
433     function remove(AddressSet storage set, address value)
434         internal
435         returns (bool)
436     {
437         return _remove(set._inner, bytes32(uint256(uint160(value))));
438     }
439 
440     /**
441      * @dev Returns true if the value is in the set. O(1).
442      */
443     function contains(AddressSet storage set, address value)
444         internal
445         view
446         returns (bool)
447     {
448         return _contains(set._inner, bytes32(uint256(uint160(value))));
449     }
450 
451     /**
452      * @dev Returns the number of values in the set. O(1).
453      */
454     function length(AddressSet storage set) internal view returns (uint256) {
455         return _length(set._inner);
456     }
457 
458     /**
459      * @dev Returns the value stored at position `index` in the set. O(1).
460      *
461      * Note that there are no guarantees on the ordering of values inside the
462      * array, and it may change when more values are added or removed.
463      *
464      * Requirements:
465      *
466      * - `index` must be strictly less than {length}.
467      */
468     function at(AddressSet storage set, uint256 index)
469         internal
470         view
471         returns (address)
472     {
473         return address(uint160(uint256(_at(set._inner, index))));
474     }
475 
476     /**
477      * @dev Return the entire set in an array
478      *
479      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
480      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
481      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
482      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
483      */
484     function values(AddressSet storage set)
485         internal
486         view
487         returns (address[] memory)
488     {
489         bytes32[] memory store = _values(set._inner);
490         address[] memory result;
491 
492         assembly {
493             result := store
494         }
495 
496         return result;
497     }
498 
499     // UintSet
500 
501     struct UintSet {
502         Set _inner;
503     }
504 
505     /**
506      * @dev Add a value to a set. O(1).
507      *
508      * Returns true if the value was added to the set, that is if it was not
509      * already present.
510      */
511     function add(UintSet storage set, uint256 value) internal returns (bool) {
512         return _add(set._inner, bytes32(value));
513     }
514 
515     /**
516      * @dev Removes a value from a set. O(1).
517      *
518      * Returns true if the value was removed from the set, that is if it was
519      * present.
520      */
521     function remove(UintSet storage set, uint256 value)
522         internal
523         returns (bool)
524     {
525         return _remove(set._inner, bytes32(value));
526     }
527 
528     /**
529      * @dev Returns true if the value is in the set. O(1).
530      */
531     function contains(UintSet storage set, uint256 value)
532         internal
533         view
534         returns (bool)
535     {
536         return _contains(set._inner, bytes32(value));
537     }
538 
539     /**
540      * @dev Returns the number of values on the set. O(1).
541      */
542     function length(UintSet storage set) internal view returns (uint256) {
543         return _length(set._inner);
544     }
545 
546     /**
547      * @dev Returns the value stored at position `index` in the set. O(1).
548      *
549      * Note that there are no guarantees on the ordering of values inside the
550      * array, and it may change when more values are added or removed.
551      *
552      * Requirements:
553      *
554      * - `index` must be strictly less than {length}.
555      */
556     function at(UintSet storage set, uint256 index)
557         internal
558         view
559         returns (uint256)
560     {
561         return uint256(_at(set._inner, index));
562     }
563 
564     /**
565      * @dev Return the entire set in an array
566      *
567      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
568      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
569      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
570      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
571      */
572     function values(UintSet storage set)
573         internal
574         view
575         returns (uint256[] memory)
576     {
577         bytes32[] memory store = _values(set._inner);
578         uint256[] memory result;
579 
580         assembly {
581             result := store
582         }
583 
584         return result;
585     }
586 }
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Required interface of an ERC721 compliant contract.
592  */
593 interface IERC721 is IERC165 {
594     /**
595      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
596      */
597     event Transfer(
598         address indexed from,
599         address indexed to,
600         uint256 indexed tokenId
601     );
602 
603     /**
604      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
605      */
606     event Approval(
607         address indexed owner,
608         address indexed approved,
609         uint256 indexed tokenId
610     );
611 
612     /**
613      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
614      */
615     event ApprovalForAll(
616         address indexed owner,
617         address indexed operator,
618         bool approved
619     );
620 
621     /**
622      * @dev Returns the number of tokens in ``owner``'s account.
623      */
624     function balanceOf(address owner) external view returns (uint256 balance);
625 
626     /**
627      * @dev Returns the owner of the `tokenId` token.
628      *
629      * Requirements:
630      *
631      * - `tokenId` must exist.
632      */
633     function ownerOf(uint256 tokenId) external view returns (address owner);
634 
635     /**
636      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
637      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must exist and be owned by `from`.
644      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
645      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
646      *
647      * Emits a {Transfer} event.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) external;
654 
655     /**
656      * @dev Transfers `tokenId` token from `from` to `to`.
657      *
658      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must be owned by `from`.
665      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
666      *
667      * Emits a {Transfer} event.
668      */
669     function transferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
677      * The approval is cleared when the token is transferred.
678      *
679      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
680      *
681      * Requirements:
682      *
683      * - The caller must own the token or be an approved operator.
684      * - `tokenId` must exist.
685      *
686      * Emits an {Approval} event.
687      */
688     function approve(address to, uint256 tokenId) external;
689 
690     /**
691      * @dev Returns the account approved for `tokenId` token.
692      *
693      * Requirements:
694      *
695      * - `tokenId` must exist.
696      */
697     function getApproved(uint256 tokenId)
698         external
699         view
700         returns (address operator);
701 
702     /**
703      * @dev Approve or remove `operator` as an operator for the caller.
704      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
705      *
706      * Requirements:
707      *
708      * - The `operator` cannot be the caller.
709      *
710      * Emits an {ApprovalForAll} event.
711      */
712     function setApprovalForAll(address operator, bool _approved) external;
713 
714     /**
715      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
716      *
717      * See {setApprovalForAll}
718      */
719     function isApprovedForAll(address owner, address operator)
720         external
721         view
722         returns (bool);
723 
724     /**
725      * @dev Safely transfers `tokenId` token from `from` to `to`.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must exist and be owned by `from`.
732      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
733      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
734      *
735      * Emits a {Transfer} event.
736      */
737     function safeTransferFrom(
738         address from,
739         address to,
740         uint256 tokenId,
741         bytes calldata data
742     ) external;
743 }
744 
745 pragma solidity ^0.8.0;
746 
747 /**
748  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
749  * @dev See https://eips.ethereum.org/EIPS/eip-721
750  */
751 interface IERC721Enumerable is IERC721 {
752     /**
753      * @dev Returns the total amount of tokens stored by the contract.
754      */
755     function totalSupply() external view returns (uint256);
756 
757     /**
758      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
759      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
760      */
761     function tokenOfOwnerByIndex(address owner, uint256 index)
762         external
763         view
764         returns (uint256 tokenId);
765 
766     /**
767      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
768      * Use along with {totalSupply} to enumerate all tokens.
769      */
770     function tokenByIndex(uint256 index) external view returns (uint256);
771 }
772 
773 pragma solidity ^0.8.0;
774 
775 /**
776  * @title ERC721 token receiver interface
777  * @dev Interface for any contract that wants to support safeTransfers
778  * from ERC721 asset contracts.
779  */
780 interface IERC721Receiver {
781     /**
782      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
783      * by `operator` from `from`, this function is called.
784      *
785      * It must return its Solidity selector to confirm the token transfer.
786      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
787      *
788      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
789      */
790     function onERC721Received(
791         address operator,
792         address from,
793         uint256 tokenId,
794         bytes calldata data
795     ) external returns (bytes4);
796 }
797 
798 pragma solidity ^0.8.0;
799 
800 /**
801  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
802  * @dev See https://eips.ethereum.org/EIPS/eip-721
803  */
804 interface IERC721Metadata is IERC721 {
805     /**
806      * @dev Returns the token collection name.
807      */
808     function name() external view returns (string memory);
809 
810     /**
811      * @dev Returns the token collection symbol.
812      */
813     function symbol() external view returns (string memory);
814 
815     /**
816      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
817      */
818     function tokenURI(uint256 tokenId) external view returns (string memory);
819 }
820 
821 pragma solidity ^0.8.0;
822 
823 /**
824  * @dev Collection of functions related to the address type
825  */
826 library Address {
827     /**
828      * @dev Returns true if `account` is a contract.
829      *
830      * [IMPORTANT]
831      * ====
832      * It is unsafe to assume that an address for which this function returns
833      * false is an externally-owned account (EOA) and not a contract.
834      *
835      * Among others, `isContract` will return false for the following
836      * types of addresses:
837      *
838      *  - an externally-owned account
839      *  - a contract in construction
840      *  - an address where a contract will be created
841      *  - an address where a contract lived, but was destroyed
842      * ====
843      */
844     function isContract(address account) internal view returns (bool) {
845         // This method relies on extcodesize, which returns 0 for contracts in
846         // construction, since the code is only stored at the end of the
847         // constructor execution.
848 
849         uint256 size;
850         assembly {
851             size := extcodesize(account)
852         }
853         return size > 0;
854     }
855 
856     /**
857      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
858      * `recipient`, forwarding all available gas and reverting on errors.
859      *
860      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
861      * of certain opcodes, possibly making contracts go over the 2300 gas limit
862      * imposed by `transfer`, making them unable to receive funds via
863      * `transfer`. {sendValue} removes this limitation.
864      *
865      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
866      *
867      * IMPORTANT: because control is transferred to `recipient`, care must be
868      * taken to not create reentrancy vulnerabilities. Consider using
869      * {ReentrancyGuard} or the
870      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
871      */
872     function sendValue(address payable recipient, uint256 amount) internal {
873         require(
874             address(this).balance >= amount,
875             "Address: insufficient balance"
876         );
877 
878         (bool success, ) = recipient.call{value: amount}("");
879         require(
880             success,
881             "Address: unable to send value, recipient may have reverted"
882         );
883     }
884 
885     /**
886      * @dev Performs a Solidity function call using a low level `call`. A
887      * plain `call` is an unsafe replacement for a function call: use this
888      * function instead.
889      *
890      * If `target` reverts with a revert reason, it is bubbled up by this
891      * function (like regular Solidity function calls).
892      *
893      * Returns the raw returned data. To convert to the expected return value,
894      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
895      *
896      * Requirements:
897      *
898      * - `target` must be a contract.
899      * - calling `target` with `data` must not revert.
900      *
901      * _Available since v3.1._
902      */
903     function functionCall(address target, bytes memory data)
904         internal
905         returns (bytes memory)
906     {
907         return functionCall(target, data, "Address: low-level call failed");
908     }
909 
910     /**
911      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
912      * `errorMessage` as a fallback revert reason when `target` reverts.
913      *
914      * _Available since v3.1._
915      */
916     function functionCall(
917         address target,
918         bytes memory data,
919         string memory errorMessage
920     ) internal returns (bytes memory) {
921         return functionCallWithValue(target, data, 0, errorMessage);
922     }
923 
924     /**
925      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
926      * but also transferring `value` wei to `target`.
927      *
928      * Requirements:
929      *
930      * - the calling contract must have an ETH balance of at least `value`.
931      * - the called Solidity function must be `payable`.
932      *
933      * _Available since v3.1._
934      */
935     function functionCallWithValue(
936         address target,
937         bytes memory data,
938         uint256 value
939     ) internal returns (bytes memory) {
940         return
941             functionCallWithValue(
942                 target,
943                 data,
944                 value,
945                 "Address: low-level call with value failed"
946             );
947     }
948 
949     /**
950      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
951      * with `errorMessage` as a fallback revert reason when `target` reverts.
952      *
953      * _Available since v3.1._
954      */
955     function functionCallWithValue(
956         address target,
957         bytes memory data,
958         uint256 value,
959         string memory errorMessage
960     ) internal returns (bytes memory) {
961         require(
962             address(this).balance >= value,
963             "Address: insufficient balance for call"
964         );
965         require(isContract(target), "Address: call to non-contract");
966 
967         (bool success, bytes memory returndata) = target.call{value: value}(
968             data
969         );
970         return verifyCallResult(success, returndata, errorMessage);
971     }
972 
973     /**
974      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
975      * but performing a static call.
976      *
977      * _Available since v3.3._
978      */
979     function functionStaticCall(address target, bytes memory data)
980         internal
981         view
982         returns (bytes memory)
983     {
984         return
985             functionStaticCall(
986                 target,
987                 data,
988                 "Address: low-level static call failed"
989             );
990     }
991 
992     /**
993      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
994      * but performing a static call.
995      *
996      * _Available since v3.3._
997      */
998     function functionStaticCall(
999         address target,
1000         bytes memory data,
1001         string memory errorMessage
1002     ) internal view returns (bytes memory) {
1003         require(isContract(target), "Address: static call to non-contract");
1004 
1005         (bool success, bytes memory returndata) = target.staticcall(data);
1006         return verifyCallResult(success, returndata, errorMessage);
1007     }
1008 
1009     /**
1010      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1011      * but performing a delegate call.
1012      *
1013      * _Available since v3.4._
1014      */
1015     function functionDelegateCall(address target, bytes memory data)
1016         internal
1017         returns (bytes memory)
1018     {
1019         return
1020             functionDelegateCall(
1021                 target,
1022                 data,
1023                 "Address: low-level delegate call failed"
1024             );
1025     }
1026 
1027     /**
1028      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1029      * but performing a delegate call.
1030      *
1031      * _Available since v3.4._
1032      */
1033     function functionDelegateCall(
1034         address target,
1035         bytes memory data,
1036         string memory errorMessage
1037     ) internal returns (bytes memory) {
1038         require(isContract(target), "Address: delegate call to non-contract");
1039 
1040         (bool success, bytes memory returndata) = target.delegatecall(data);
1041         return verifyCallResult(success, returndata, errorMessage);
1042     }
1043 
1044     /**
1045      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1046      * revert reason using the provided one.
1047      *
1048      * _Available since v4.3._
1049      */
1050     function verifyCallResult(
1051         bool success,
1052         bytes memory returndata,
1053         string memory errorMessage
1054     ) internal pure returns (bytes memory) {
1055         if (success) {
1056             return returndata;
1057         } else {
1058             // Look for revert reason and bubble it up if present
1059             if (returndata.length > 0) {
1060                 // The easiest way to bubble the revert reason is using memory via assembly
1061 
1062                 assembly {
1063                     let returndata_size := mload(returndata)
1064                     revert(add(32, returndata), returndata_size)
1065                 }
1066             } else {
1067                 revert(errorMessage);
1068             }
1069         }
1070     }
1071 }
1072 
1073 pragma solidity ^0.8.0;
1074 
1075 /**
1076  * @dev Provides information about the current execution context, including the
1077  * sender of the transaction and its data. While these are generally available
1078  * via msg.sender and msg.data, they should not be accessed in such a direct
1079  * manner, since when dealing with meta-transactions the account sending and
1080  * paying for execution may not be the actual sender (as far as an application
1081  * is concerned).
1082  *
1083  * This contract is only required for intermediate, library-like contracts.
1084  */
1085 abstract contract Context {
1086     function _msgSender() internal view virtual returns (address) {
1087         return msg.sender;
1088     }
1089 
1090     function _msgData() internal view virtual returns (bytes calldata) {
1091         return msg.data;
1092     }
1093 }
1094 
1095 pragma solidity ^0.8.0;
1096 
1097 /**
1098  * @dev String operations.
1099  */
1100 library Strings {
1101     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1102 
1103     /**
1104      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1105      */
1106     function toString(uint256 value) internal pure returns (string memory) {
1107         // Inspired by OraclizeAPI's implementation - MIT licence
1108         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1109 
1110         if (value == 0) {
1111             return "0";
1112         }
1113         uint256 temp = value;
1114         uint256 digits;
1115         while (temp != 0) {
1116             digits++;
1117             temp /= 10;
1118         }
1119         bytes memory buffer = new bytes(digits);
1120         while (value != 0) {
1121             digits -= 1;
1122             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1123             value /= 10;
1124         }
1125         return string(buffer);
1126     }
1127 
1128     /**
1129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1130      */
1131     function toHexString(uint256 value) internal pure returns (string memory) {
1132         if (value == 0) {
1133             return "0x00";
1134         }
1135         uint256 temp = value;
1136         uint256 length = 0;
1137         while (temp != 0) {
1138             length++;
1139             temp >>= 8;
1140         }
1141         return toHexString(value, length);
1142     }
1143 
1144     /**
1145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1146      */
1147     function toHexString(uint256 value, uint256 length)
1148         internal
1149         pure
1150         returns (string memory)
1151     {
1152         bytes memory buffer = new bytes(2 * length + 2);
1153         buffer[0] = "0";
1154         buffer[1] = "x";
1155         for (uint256 i = 2 * length + 1; i > 1; --i) {
1156             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1157             value >>= 4;
1158         }
1159         require(value == 0, "Strings: hex length insufficient");
1160         return string(buffer);
1161     }
1162 }
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 /**
1167  * @dev Implementation of the {IERC165} interface.
1168  *
1169  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1170  * for the additional interface id that will be supported. For example:
1171  *
1172  * ```solidity
1173  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1174  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1175  * }
1176  * ```
1177  *
1178  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1179  */
1180 abstract contract ERC165 is IERC165 {
1181     /**
1182      * @dev See {IERC165-supportsInterface}.
1183      */
1184     function supportsInterface(bytes4 interfaceId)
1185         public
1186         view
1187         virtual
1188         override
1189         returns (bool)
1190     {
1191         return interfaceId == type(IERC165).interfaceId;
1192     }
1193 }
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 /**
1198  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1199  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1200  * {ERC721Enumerable}.
1201  */
1202 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1203     using Address for address;
1204     using Strings for uint256;
1205 
1206     // Token name
1207     string private _name;
1208 
1209     // Token symbol
1210     string private _symbol;
1211 
1212     // Mapping from token ID to owner address
1213     mapping(uint256 => address) private _owners;
1214 
1215     // Mapping owner address to token count
1216     mapping(address => uint256) private _balances;
1217 
1218     // Mapping from token ID to approved address
1219     mapping(uint256 => address) private _tokenApprovals;
1220 
1221     // Mapping from owner to operator approvals
1222     mapping(address => mapping(address => bool)) private _operatorApprovals;
1223 
1224     /**
1225      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1226      */
1227     constructor(string memory name_, string memory symbol_) {
1228         _name = name_;
1229         _symbol = symbol_;
1230     }
1231 
1232     /**
1233      * @dev See {IERC165-supportsInterface}.
1234      */
1235     function supportsInterface(bytes4 interfaceId)
1236         public
1237         view
1238         virtual
1239         override(ERC165, IERC165)
1240         returns (bool)
1241     {
1242         return
1243             interfaceId == type(IERC721).interfaceId ||
1244             interfaceId == type(IERC721Metadata).interfaceId ||
1245             super.supportsInterface(interfaceId);
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-balanceOf}.
1250      */
1251     function balanceOf(address owner)
1252         public
1253         view
1254         virtual
1255         override
1256         returns (uint256)
1257     {
1258         require(
1259             owner != address(0),
1260             "ERC721: balance query for the zero address"
1261         );
1262         return _balances[owner];
1263     }
1264 
1265     /**
1266      * @dev See {IERC721-ownerOf}.
1267      */
1268     function ownerOf(uint256 tokenId)
1269         public
1270         view
1271         virtual
1272         override
1273         returns (address)
1274     {
1275         address owner = _owners[tokenId];
1276         require(
1277             owner != address(0),
1278             "ERC721: owner query for nonexistent token"
1279         );
1280         return owner;
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Metadata-name}.
1285      */
1286     function name() public view virtual override returns (string memory) {
1287         return _name;
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Metadata-symbol}.
1292      */
1293     function symbol() public view virtual override returns (string memory) {
1294         return _symbol;
1295     }
1296 
1297     /**
1298      * @dev See {IERC721Metadata-tokenURI}.
1299      */
1300     function tokenURI(uint256 tokenId)
1301         public
1302         view
1303         virtual
1304         override
1305         returns (string memory)
1306     {
1307         require(
1308             _exists(tokenId),
1309             "ERC721Metadata: URI query for nonexistent token"
1310         );
1311 
1312         string memory baseURI = _baseURI();
1313         return
1314             bytes(baseURI).length > 0
1315                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1316                 : "";
1317     }
1318 
1319     /**
1320      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1321      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1322      * by default, can be overriden in child contracts.
1323      */
1324     function _baseURI() internal view virtual returns (string memory) {
1325         return "";
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-approve}.
1330      */
1331     function approve(address to, uint256 tokenId) public virtual override {
1332         address owner = ERC721.ownerOf(tokenId);
1333         require(to != owner, "ERC721: approval to current owner");
1334 
1335         require(
1336             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1337             "ERC721: approve caller is not owner nor approved for all"
1338         );
1339 
1340         _approve(to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev See {IERC721-getApproved}.
1345      */
1346     function getApproved(uint256 tokenId)
1347         public
1348         view
1349         virtual
1350         override
1351         returns (address)
1352     {
1353         require(
1354             _exists(tokenId),
1355             "ERC721: approved query for nonexistent token"
1356         );
1357 
1358         return _tokenApprovals[tokenId];
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-setApprovalForAll}.
1363      */
1364     function setApprovalForAll(address operator, bool approved)
1365         public
1366         virtual
1367         override
1368     {
1369         _setApprovalForAll(_msgSender(), operator, approved);
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-isApprovedForAll}.
1374      */
1375     function isApprovedForAll(address owner, address operator)
1376         public
1377         view
1378         virtual
1379         override
1380         returns (bool)
1381     {
1382         return _operatorApprovals[owner][operator];
1383     }
1384 
1385     /**
1386      * @dev See {IERC721-transferFrom}.
1387      */
1388     function transferFrom(
1389         address from,
1390         address to,
1391         uint256 tokenId
1392     ) public virtual override {
1393         //solhint-disable-next-line max-line-length
1394         require(
1395             _isApprovedOrOwner(_msgSender(), tokenId),
1396             "ERC721: transfer caller is not owner nor approved"
1397         );
1398 
1399         _transfer(from, to, tokenId);
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-safeTransferFrom}.
1404      */
1405     function safeTransferFrom(
1406         address from,
1407         address to,
1408         uint256 tokenId
1409     ) public virtual override {
1410         safeTransferFrom(from, to, tokenId, "");
1411     }
1412 
1413     /**
1414      * @dev See {IERC721-safeTransferFrom}.
1415      */
1416     function safeTransferFrom(
1417         address from,
1418         address to,
1419         uint256 tokenId,
1420         bytes memory _data
1421     ) public virtual override {
1422         require(
1423             _isApprovedOrOwner(_msgSender(), tokenId),
1424             "ERC721: transfer caller is not owner nor approved"
1425         );
1426         _safeTransfer(from, to, tokenId, _data);
1427     }
1428 
1429     /**
1430      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1431      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1432      *
1433      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1434      *
1435      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1436      * implement alternative mechanisms to perform token transfer, such as signature-based.
1437      *
1438      * Requirements:
1439      *
1440      * - `from` cannot be the zero address.
1441      * - `to` cannot be the zero address.
1442      * - `tokenId` token must exist and be owned by `from`.
1443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1444      *
1445      * Emits a {Transfer} event.
1446      */
1447     function _safeTransfer(
1448         address from,
1449         address to,
1450         uint256 tokenId,
1451         bytes memory _data
1452     ) internal virtual {
1453         _transfer(from, to, tokenId);
1454         require(
1455             _checkOnERC721Received(from, to, tokenId, _data),
1456             "ERC721: transfer to non ERC721Receiver implementer"
1457         );
1458     }
1459 
1460     /**
1461      * @dev Returns whether `tokenId` exists.
1462      *
1463      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1464      *
1465      * Tokens start existing when they are minted (`_mint`),
1466      * and stop existing when they are burned (`_burn`).
1467      */
1468     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1469         return _owners[tokenId] != address(0);
1470     }
1471 
1472     /**
1473      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1474      *
1475      * Requirements:
1476      *
1477      * - `tokenId` must exist.
1478      */
1479     function _isApprovedOrOwner(address spender, uint256 tokenId)
1480         internal
1481         view
1482         virtual
1483         returns (bool)
1484     {
1485         require(
1486             _exists(tokenId),
1487             "ERC721: operator query for nonexistent token"
1488         );
1489         address owner = ERC721.ownerOf(tokenId);
1490         return (spender == owner ||
1491             getApproved(tokenId) == spender ||
1492             isApprovedForAll(owner, spender));
1493     }
1494 
1495     /**
1496      * @dev Safely mints `tokenId` and transfers it to `to`.
1497      *
1498      * Requirements:
1499      *
1500      * - `tokenId` must not exist.
1501      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function _safeMint(address to, uint256 tokenId) internal virtual {
1506         _safeMint(to, tokenId, "");
1507     }
1508 
1509     /**
1510      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1511      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1512      */
1513     function _safeMint(
1514         address to,
1515         uint256 tokenId,
1516         bytes memory _data
1517     ) internal virtual {
1518         _mint(to, tokenId);
1519         require(
1520             _checkOnERC721Received(address(0), to, tokenId, _data),
1521             "ERC721: transfer to non ERC721Receiver implementer"
1522         );
1523     }
1524 
1525     /**
1526      * @dev Mints `tokenId` and transfers it to `to`.
1527      *
1528      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must not exist.
1533      * - `to` cannot be the zero address.
1534      *
1535      * Emits a {Transfer} event.
1536      */
1537     function _mint(address to, uint256 tokenId) internal virtual {
1538         require(to != address(0), "ERC721: mint to the zero address");
1539         require(!_exists(tokenId), "ERC721: token already minted");
1540 
1541         _beforeTokenTransfer(address(0), to, tokenId);
1542 
1543         _balances[to] += 1;
1544         _owners[tokenId] = to;
1545 
1546         emit Transfer(address(0), to, tokenId);
1547     }
1548 
1549     /**
1550      * @dev Destroys `tokenId`.
1551      * The approval is cleared when the token is burned.
1552      *
1553      * Requirements:
1554      *
1555      * - `tokenId` must exist.
1556      *
1557      * Emits a {Transfer} event.
1558      */
1559     function _burn(uint256 tokenId) internal virtual {
1560         address owner = ERC721.ownerOf(tokenId);
1561 
1562         _beforeTokenTransfer(owner, address(0), tokenId);
1563 
1564         // Clear approvals
1565         _approve(address(0), tokenId);
1566 
1567         _balances[owner] -= 1;
1568         delete _owners[tokenId];
1569 
1570         emit Transfer(owner, address(0), tokenId);
1571     }
1572 
1573     /**
1574      * @dev Transfers `tokenId` from `from` to `to`.
1575      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1576      *
1577      * Requirements:
1578      *
1579      * - `to` cannot be the zero address.
1580      * - `tokenId` token must be owned by `from`.
1581      *
1582      * Emits a {Transfer} event.
1583      */
1584     function _transfer(
1585         address from,
1586         address to,
1587         uint256 tokenId
1588     ) internal virtual {
1589         require(
1590             ERC721.ownerOf(tokenId) == from,
1591             "ERC721: transfer of token that is not own"
1592         );
1593         require(to != address(0), "ERC721: transfer to the zero address");
1594 
1595         _beforeTokenTransfer(from, to, tokenId);
1596 
1597         // Clear approvals from the previous owner
1598         _approve(address(0), tokenId);
1599 
1600         _balances[from] -= 1;
1601         _balances[to] += 1;
1602         _owners[tokenId] = to;
1603 
1604         emit Transfer(from, to, tokenId);
1605     }
1606 
1607     /**
1608      * @dev Approve `to` to operate on `tokenId`
1609      *
1610      * Emits a {Approval} event.
1611      */
1612     function _approve(address to, uint256 tokenId) internal virtual {
1613         _tokenApprovals[tokenId] = to;
1614         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1615     }
1616 
1617     /**
1618      * @dev Approve `operator` to operate on all of `owner` tokens
1619      *
1620      * Emits a {ApprovalForAll} event.
1621      */
1622     function _setApprovalForAll(
1623         address owner,
1624         address operator,
1625         bool approved
1626     ) internal virtual {
1627         require(owner != operator, "ERC721: approve to caller");
1628         _operatorApprovals[owner][operator] = approved;
1629         emit ApprovalForAll(owner, operator, approved);
1630     }
1631 
1632     /**
1633      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1634      * The call is not executed if the target address is not a contract.
1635      *
1636      * @param from address representing the previous owner of the given token ID
1637      * @param to target address that will receive the tokens
1638      * @param tokenId uint256 ID of the token to be transferred
1639      * @param _data bytes optional data to send along with the call
1640      * @return bool whether the call correctly returned the expected magic value
1641      */
1642     function _checkOnERC721Received(
1643         address from,
1644         address to,
1645         uint256 tokenId,
1646         bytes memory _data
1647     ) private returns (bool) {
1648         if (to.isContract()) {
1649             try
1650                 IERC721Receiver(to).onERC721Received(
1651                     _msgSender(),
1652                     from,
1653                     tokenId,
1654                     _data
1655                 )
1656             returns (bytes4 retval) {
1657                 return retval == IERC721Receiver.onERC721Received.selector;
1658             } catch (bytes memory reason) {
1659                 if (reason.length == 0) {
1660                     revert(
1661                         "ERC721: transfer to non ERC721Receiver implementer"
1662                     );
1663                 } else {
1664                     assembly {
1665                         revert(add(32, reason), mload(reason))
1666                     }
1667                 }
1668             }
1669         } else {
1670             return true;
1671         }
1672     }
1673 
1674     /**
1675      * @dev Hook that is called before any token transfer. This includes minting
1676      * and burning.
1677      *
1678      * Calling conditions:
1679      *
1680      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1681      * transferred to `to`.
1682      * - When `from` is zero, `tokenId` will be minted for `to`.
1683      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1684      * - `from` and `to` are never both zero.
1685      *
1686      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1687      */
1688     function _beforeTokenTransfer(
1689         address from,
1690         address to,
1691         uint256 tokenId
1692     ) internal virtual {}
1693 }
1694 
1695 pragma solidity ^0.8.0;
1696 
1697 /**
1698  * @dev Contract module that allows children to implement role-based access
1699  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1700  * members except through off-chain means by accessing the contract event logs. Some
1701  * applications may benefit from on-chain enumerability, for those cases see
1702  * {AccessControlEnumerable}.
1703  *
1704  * Roles are referred to by their `bytes32` identifier. These should be exposed
1705  * in the external API and be unique. The best way to achieve this is by
1706  * using `public constant` hash digests:
1707  *
1708  * ```
1709  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1710  * ```
1711  *
1712  * Roles can be used to represent a set of permissions. To restrict access to a
1713  * function call, use {hasRole}:
1714  *
1715  * ```
1716  * function foo() public {
1717  *     require(hasRole(MY_ROLE, msg.sender));
1718  *     ...
1719  * }
1720  * ```
1721  *
1722  * Roles can be granted and revoked dynamically via the {grantRole} and
1723  * {revokeRole} functions. Each role has an associated admin role, and only
1724  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1725  *
1726  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1727  * that only accounts with this role will be able to grant or revoke other
1728  * roles. More complex role relationships can be created by using
1729  * {_setRoleAdmin}.
1730  *
1731  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1732  * grant and revoke this role. Extra precautions should be taken to secure
1733  * accounts that have been granted it.
1734  */
1735 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1736     struct RoleData {
1737         mapping(address => bool) members;
1738         bytes32 adminRole;
1739     }
1740 
1741     mapping(bytes32 => RoleData) private _roles;
1742 
1743     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1744 
1745     /**
1746      * @dev Modifier that checks that an account has a specific role. Reverts
1747      * with a standardized message including the required role.
1748      *
1749      * The format of the revert reason is given by the following regular expression:
1750      *
1751      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1752      *
1753      * _Available since v4.1._
1754      */
1755     modifier onlyRole(bytes32 role) {
1756         _checkRole(role, _msgSender());
1757         _;
1758     }
1759 
1760     /**
1761      * @dev See {IERC165-supportsInterface}.
1762      */
1763     function supportsInterface(bytes4 interfaceId)
1764         public
1765         view
1766         virtual
1767         override
1768         returns (bool)
1769     {
1770         return
1771             interfaceId == type(IAccessControl).interfaceId ||
1772             super.supportsInterface(interfaceId);
1773     }
1774 
1775     /**
1776      * @dev Returns `true` if `account` has been granted `role`.
1777      */
1778     function hasRole(bytes32 role, address account)
1779         public
1780         view
1781         virtual
1782         override
1783         returns (bool)
1784     {
1785         return _roles[role].members[account];
1786     }
1787 
1788     /**
1789      * @dev Revert with a standard message if `account` is missing `role`.
1790      *
1791      * The format of the revert reason is given by the following regular expression:
1792      *
1793      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1794      */
1795     function _checkRole(bytes32 role, address account) internal view virtual {
1796         if (!hasRole(role, account)) {
1797             revert(
1798                 string(
1799                     abi.encodePacked(
1800                         "AccessControl: account ",
1801                         Strings.toHexString(uint160(account), 20),
1802                         " is missing role ",
1803                         Strings.toHexString(uint256(role), 32)
1804                     )
1805                 )
1806             );
1807         }
1808     }
1809 
1810     /**
1811      * @dev Returns the admin role that controls `role`. See {grantRole} and
1812      * {revokeRole}.
1813      *
1814      * To change a role's admin, use {_setRoleAdmin}.
1815      */
1816     function getRoleAdmin(bytes32 role)
1817         public
1818         view
1819         virtual
1820         override
1821         returns (bytes32)
1822     {
1823         return _roles[role].adminRole;
1824     }
1825 
1826     /**
1827      * @dev Grants `role` to `account`.
1828      *
1829      * If `account` had not been already granted `role`, emits a {RoleGranted}
1830      * event.
1831      *
1832      * Requirements:
1833      *
1834      * - the caller must have ``role``'s admin role.
1835      */
1836     function grantRole(bytes32 role, address account)
1837         public
1838         virtual
1839         override
1840         onlyRole(getRoleAdmin(role))
1841     {
1842         _grantRole(role, account);
1843     }
1844 
1845     /**
1846      * @dev Revokes `role` from `account`.
1847      *
1848      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1849      *
1850      * Requirements:
1851      *
1852      * - the caller must have ``role``'s admin role.
1853      */
1854     function revokeRole(bytes32 role, address account)
1855         public
1856         virtual
1857         override
1858         onlyRole(getRoleAdmin(role))
1859     {
1860         _revokeRole(role, account);
1861     }
1862 
1863     /**
1864      * @dev Revokes `role` from the calling account.
1865      *
1866      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1867      * purpose is to provide a mechanism for accounts to lose their privileges
1868      * if they are compromised (such as when a trusted device is misplaced).
1869      *
1870      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1871      * event.
1872      *
1873      * Requirements:
1874      *
1875      * - the caller must be `account`.
1876      */
1877     function renounceRole(bytes32 role, address account)
1878         public
1879         virtual
1880         override
1881     {
1882         require(
1883             account == _msgSender(),
1884             "AccessControl: can only renounce roles for self"
1885         );
1886 
1887         _revokeRole(role, account);
1888     }
1889 
1890     /**
1891      * @dev Grants `role` to `account`.
1892      *
1893      * If `account` had not been already granted `role`, emits a {RoleGranted}
1894      * event. Note that unlike {grantRole}, this function doesn't perform any
1895      * checks on the calling account.
1896      *
1897      * [WARNING]
1898      * ====
1899      * This function should only be called from the constructor when setting
1900      * up the initial roles for the system.
1901      *
1902      * Using this function in any other way is effectively circumventing the admin
1903      * system imposed by {AccessControl}.
1904      * ====
1905      *
1906      * NOTE: This function is deprecated in favor of {_grantRole}.
1907      */
1908     function _setupRole(bytes32 role, address account) internal virtual {
1909         _grantRole(role, account);
1910     }
1911 
1912     /**
1913      * @dev Sets `adminRole` as ``role``'s admin role.
1914      *
1915      * Emits a {RoleAdminChanged} event.
1916      */
1917     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1918         bytes32 previousAdminRole = getRoleAdmin(role);
1919         _roles[role].adminRole = adminRole;
1920         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1921     }
1922 
1923     /**
1924      * @dev Grants `role` to `account`.
1925      *
1926      * Internal function without access restriction.
1927      */
1928     function _grantRole(bytes32 role, address account) internal virtual {
1929         if (!hasRole(role, account)) {
1930             _roles[role].members[account] = true;
1931             emit RoleGranted(role, account, _msgSender());
1932         }
1933     }
1934 
1935     /**
1936      * @dev Revokes `role` from `account`.
1937      *
1938      * Internal function without access restriction.
1939      */
1940     function _revokeRole(bytes32 role, address account) internal virtual {
1941         if (hasRole(role, account)) {
1942             _roles[role].members[account] = false;
1943             emit RoleRevoked(role, account, _msgSender());
1944         }
1945     }
1946 }
1947 
1948 pragma solidity ^0.8.0;
1949 
1950 /**
1951  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1952  * enumerability of all the token ids in the contract as well as all token ids owned by each
1953  * account.
1954  */
1955 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1956     // Mapping from owner to list of owned token IDs
1957     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1958 
1959     // Mapping from token ID to index of the owner tokens list
1960     mapping(uint256 => uint256) private _ownedTokensIndex;
1961 
1962     // Array with all token ids, used for enumeration
1963     uint256[] private _allTokens;
1964 
1965     // Mapping from token id to position in the allTokens array
1966     mapping(uint256 => uint256) private _allTokensIndex;
1967 
1968     /**
1969      * @dev See {IERC165-supportsInterface}.
1970      */
1971     function supportsInterface(bytes4 interfaceId)
1972         public
1973         view
1974         virtual
1975         override(IERC165, ERC721)
1976         returns (bool)
1977     {
1978         return
1979             interfaceId == type(IERC721Enumerable).interfaceId ||
1980             super.supportsInterface(interfaceId);
1981     }
1982 
1983     /**
1984      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1985      */
1986     function tokenOfOwnerByIndex(address owner, uint256 index)
1987         public
1988         view
1989         virtual
1990         override
1991         returns (uint256)
1992     {
1993         require(
1994             index < ERC721.balanceOf(owner),
1995             "ERC721Enumerable: owner index out of bounds"
1996         );
1997         return _ownedTokens[owner][index];
1998     }
1999 
2000     /**
2001      * @dev See {IERC721Enumerable-totalSupply}.
2002      */
2003     function totalSupply() public view virtual override returns (uint256) {
2004         return _allTokens.length;
2005     }
2006 
2007     /**
2008      * @dev See {IERC721Enumerable-tokenByIndex}.
2009      */
2010     function tokenByIndex(uint256 index)
2011         public
2012         view
2013         virtual
2014         override
2015         returns (uint256)
2016     {
2017         require(
2018             index < ERC721Enumerable.totalSupply(),
2019             "ERC721Enumerable: global index out of bounds"
2020         );
2021         return _allTokens[index];
2022     }
2023 
2024     /**
2025      * @dev Hook that is called before any token transfer. This includes minting
2026      * and burning.
2027      *
2028      * Calling conditions:
2029      *
2030      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2031      * transferred to `to`.
2032      * - When `from` is zero, `tokenId` will be minted for `to`.
2033      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2034      * - `from` cannot be the zero address.
2035      * - `to` cannot be the zero address.
2036      *
2037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2038      */
2039     function _beforeTokenTransfer(
2040         address from,
2041         address to,
2042         uint256 tokenId
2043     ) internal virtual override {
2044         super._beforeTokenTransfer(from, to, tokenId);
2045 
2046         if (from == address(0)) {
2047             _addTokenToAllTokensEnumeration(tokenId);
2048         } else if (from != to) {
2049             _removeTokenFromOwnerEnumeration(from, tokenId);
2050         }
2051         if (to == address(0)) {
2052             _removeTokenFromAllTokensEnumeration(tokenId);
2053         } else if (to != from) {
2054             _addTokenToOwnerEnumeration(to, tokenId);
2055         }
2056     }
2057 
2058     /**
2059      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2060      * @param to address representing the new owner of the given token ID
2061      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2062      */
2063     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2064         uint256 length = ERC721.balanceOf(to);
2065         _ownedTokens[to][length] = tokenId;
2066         _ownedTokensIndex[tokenId] = length;
2067     }
2068 
2069     /**
2070      * @dev Private function to add a token to this extension's token tracking data structures.
2071      * @param tokenId uint256 ID of the token to be added to the tokens list
2072      */
2073     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2074         _allTokensIndex[tokenId] = _allTokens.length;
2075         _allTokens.push(tokenId);
2076     }
2077 
2078     /**
2079      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2080      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2081      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2082      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2083      * @param from address representing the previous owner of the given token ID
2084      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2085      */
2086     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
2087         private
2088     {
2089         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2090         // then delete the last slot (swap and pop).
2091 
2092         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2093         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2094 
2095         // When the token to delete is the last token, the swap operation is unnecessary
2096         if (tokenIndex != lastTokenIndex) {
2097             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2098 
2099             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2100             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2101         }
2102 
2103         // This also deletes the contents at the last position of the array
2104         delete _ownedTokensIndex[tokenId];
2105         delete _ownedTokens[from][lastTokenIndex];
2106     }
2107 
2108     /**
2109      * @dev Private function to remove a token from this extension's token tracking data structures.
2110      * This has O(1) time complexity, but alters the order of the _allTokens array.
2111      * @param tokenId uint256 ID of the token to be removed from the tokens list
2112      */
2113     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2114         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2115         // then delete the last slot (swap and pop).
2116 
2117         uint256 lastTokenIndex = _allTokens.length - 1;
2118         uint256 tokenIndex = _allTokensIndex[tokenId];
2119 
2120         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2121         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2122         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2123         uint256 lastTokenId = _allTokens[lastTokenIndex];
2124 
2125         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2126         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2127 
2128         // This also deletes the contents at the last position of the array
2129         delete _allTokensIndex[tokenId];
2130         _allTokens.pop();
2131     }
2132 }
2133 
2134 pragma solidity ^0.8.0;
2135 
2136 /**
2137  * @dev Contract module which provides a basic access control mechanism, where
2138  * there is an account (an owner) that can be granted exclusive access to
2139  * specific functions.
2140  *
2141  * By default, the owner account will be the one that deploys the contract. This
2142  * can later be changed with {transferOwnership}.
2143  *
2144  * This module is used through inheritance. It will make available the modifier
2145  * `onlyOwner`, which can be applied to your functions to restrict their use to
2146  * the owner.
2147  */
2148 abstract contract Ownable is Context {
2149     address private _owner;
2150 
2151     event OwnershipTransferred(
2152         address indexed previousOwner,
2153         address indexed newOwner
2154     );
2155 
2156     /**
2157      * @dev Initializes the contract setting the deployer as the initial owner.
2158      */
2159     constructor() {
2160         _transferOwnership(_msgSender());
2161     }
2162 
2163     /**
2164      * @dev Returns the address of the current owner.
2165      */
2166     function owner() public view virtual returns (address) {
2167         return _owner;
2168     }
2169 
2170     /**
2171      * @dev Throws if called by any account other than the owner.
2172      */
2173     modifier onlyOwner() {
2174         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2175         _;
2176     }
2177 
2178     /**
2179      * @dev Leaves the contract without owner. It will not be possible to call
2180      * `onlyOwner` functions anymore. Can only be called by the current owner.
2181      *
2182      * NOTE: Renouncing ownership will leave the contract without an owner,
2183      * thereby removing any functionality that is only available to the owner.
2184      */
2185     function renounceOwnership() public virtual onlyOwner {
2186         _transferOwnership(address(0));
2187     }
2188 
2189     /**
2190      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2191      * Can only be called by the current owner.
2192      */
2193     function transferOwnership(address newOwner) public virtual onlyOwner {
2194         require(
2195             newOwner != address(0),
2196             "Ownable: new owner is the zero address"
2197         );
2198         _transferOwnership(newOwner);
2199     }
2200 
2201     /**
2202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2203      * Internal function without access restriction.
2204      */
2205     function _transferOwnership(address newOwner) internal virtual {
2206         address oldOwner = _owner;
2207         _owner = newOwner;
2208         emit OwnershipTransferred(oldOwner, newOwner);
2209     }
2210 }
2211 
2212 pragma solidity ^0.8.0;
2213 
2214 /**
2215  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2216  */
2217 abstract contract AccessControlEnumerable is
2218     IAccessControlEnumerable,
2219     AccessControl
2220 {
2221     using EnumerableSet for EnumerableSet.AddressSet;
2222 
2223     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2224 
2225     /**
2226      * @dev See {IERC165-supportsInterface}.
2227      */
2228     function supportsInterface(bytes4 interfaceId)
2229         public
2230         view
2231         virtual
2232         override
2233         returns (bool)
2234     {
2235         return
2236             interfaceId == type(IAccessControlEnumerable).interfaceId ||
2237             super.supportsInterface(interfaceId);
2238     }
2239 
2240     /**
2241      * @dev Returns one of the accounts that have `role`. `index` must be a
2242      * value between 0 and {getRoleMemberCount}, non-inclusive.
2243      *
2244      * Role bearers are not sorted in any particular way, and their ordering may
2245      * change at any point.
2246      *
2247      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2248      * you perform all queries on the same block. See the following
2249      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2250      * for more information.
2251      */
2252     function getRoleMember(bytes32 role, uint256 index)
2253         public
2254         view
2255         virtual
2256         override
2257         returns (address)
2258     {
2259         return _roleMembers[role].at(index);
2260     }
2261 
2262     /**
2263      * @dev Returns the number of accounts that have `role`. Can be used
2264      * together with {getRoleMember} to enumerate all bearers of a role.
2265      */
2266     function getRoleMemberCount(bytes32 role)
2267         public
2268         view
2269         virtual
2270         override
2271         returns (uint256)
2272     {
2273         return _roleMembers[role].length();
2274     }
2275 
2276     /**
2277      * @dev Overload {_grantRole} to track enumerable memberships
2278      */
2279     function _grantRole(bytes32 role, address account)
2280         internal
2281         virtual
2282         override
2283     {
2284         super._grantRole(role, account);
2285         _roleMembers[role].add(account);
2286     }
2287 
2288     /**
2289      * @dev Overload {_revokeRole} to track enumerable memberships
2290      */
2291     function _revokeRole(bytes32 role, address account)
2292         internal
2293         virtual
2294         override
2295     {
2296         super._revokeRole(role, account);
2297         _roleMembers[role].remove(account);
2298     }
2299 }
2300 
2301 pragma solidity ^0.8.0;
2302 
2303 /**
2304  * @dev Contract module that helps prevent reentrant calls to a function.
2305  *
2306  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2307  * available, which can be applied to functions to make sure there are no nested
2308  * (reentrant) calls to them.
2309  *
2310  * Note that because there is a single `nonReentrant` guard, functions marked as
2311  * `nonReentrant` may not call one another. This can be worked around by making
2312  * those functions `private`, and then adding `external` `nonReentrant` entry
2313  * points to them.
2314  *
2315  * TIP: If you would like to learn more about reentrancy and alternative ways
2316  * to protect against it, check out our blog post
2317  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2318  */
2319 abstract contract ReentrancyGuard {
2320     // Booleans are more expensive than uint256 or any type that takes up a full
2321     // word because each write operation emits an extra SLOAD to first read the
2322     // slot's contents, replace the bits taken up by the boolean, and then write
2323     // back. This is the compiler's defense against contract upgrades and
2324     // pointer aliasing, and it cannot be disabled.
2325 
2326     // The values being non-zero value makes deployment a bit more expensive,
2327     // but in exchange the refund on every call to nonReentrant will be lower in
2328     // amount. Since refunds are capped to a percentage of the total
2329     // transaction's gas, it is best to keep them low in cases like this one, to
2330     // increase the likelihood of the full refund coming into effect.
2331     uint256 private constant _NOT_ENTERED = 1;
2332     uint256 private constant _ENTERED = 2;
2333 
2334     uint256 private _status;
2335 
2336     constructor() {
2337         _status = _NOT_ENTERED;
2338     }
2339 
2340     /**
2341      * @dev Prevents a contract from calling itself, directly or indirectly.
2342      * Calling a `nonReentrant` function from another `nonReentrant`
2343      * function is not supported. It is possible to prevent this from happening
2344      * by making the `nonReentrant` function external, and making it call a
2345      * `private` function that does the actual work.
2346      */
2347     modifier nonReentrant() {
2348         // On the first call to nonReentrant, _notEntered will be true
2349         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2350 
2351         // Any calls to nonReentrant after this point will fail
2352         _status = _ENTERED;
2353 
2354         _;
2355 
2356         // By storing the original value once again, a refund is triggered (see
2357         // https://eips.ethereum.org/EIPS/eip-2200)
2358         _status = _NOT_ENTERED;
2359     }
2360 }
2361 
2362 pragma solidity ^0.8.4;
2363 
2364 error ApprovalCallerNotOwnerNorApproved();
2365 error ApprovalQueryForNonexistentToken();
2366 error ApproveToCaller();
2367 error ApprovalToCurrentOwner();
2368 error BalanceQueryForZeroAddress();
2369 error MintToZeroAddress();
2370 error MintZeroQuantity();
2371 error OwnerQueryForNonexistentToken();
2372 error TransferCallerNotOwnerNorApproved();
2373 error TransferFromIncorrectOwner();
2374 error TransferToNonERC721ReceiverImplementer();
2375 error TransferToZeroAddress();
2376 error URIQueryForNonexistentToken();
2377 
2378 /**
2379  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2380  * the Metadata extension. Built to optimize for lower gas during batch mints.
2381  *
2382  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2383  *
2384  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2385  *
2386  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2387  */
2388 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2389     using Address for address;
2390     using Strings for uint256;
2391 
2392     // Compiler will pack this into a single 256bit word.
2393     struct TokenOwnership {
2394         // The address of the owner.
2395         address addr;
2396         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2397         uint64 startTimestamp;
2398         // Whether the token has been burned.
2399         bool burned;
2400     }
2401 
2402     // Compiler will pack this into a single 256bit word.
2403     struct AddressData {
2404         // Realistically, 2**64-1 is more than enough.
2405         uint64 balance;
2406         // Keeps track of mint count with minimal overhead for tokenomics.
2407         uint64 numberMinted;
2408         // Keeps track of burn count with minimal overhead for tokenomics.
2409         uint64 numberBurned;
2410         // For miscellaneous variable(s) pertaining to the address
2411         // (e.g. number of whitelist mint slots used).
2412         // If there are multiple variables, please pack them into a uint64.
2413         uint64 aux;
2414     }
2415 
2416     // The tokenId of the next token to be minted.
2417     uint256 internal _currentIndex;
2418 
2419     // The number of tokens burned.
2420     uint256 internal _burnCounter;
2421 
2422     // Token name
2423     string private _name;
2424 
2425     // Token symbol
2426     string private _symbol;
2427 
2428     // Mapping from token ID to ownership details
2429     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2430     mapping(uint256 => TokenOwnership) internal _ownerships;
2431 
2432     // Mapping owner address to address data
2433     mapping(address => AddressData) private _addressData;
2434 
2435     // Mapping from token ID to approved address
2436     mapping(uint256 => address) private _tokenApprovals;
2437 
2438     // Mapping from owner to operator approvals
2439     mapping(address => mapping(address => bool)) private _operatorApprovals;
2440 
2441     constructor(string memory name_, string memory symbol_) {
2442         _name = name_;
2443         _symbol = symbol_;
2444         _currentIndex = _startTokenId();
2445     }
2446 
2447     /**
2448      * To change the starting tokenId, please override this function.
2449      */
2450     function _startTokenId() internal view virtual returns (uint256) {
2451         return 0;
2452     }
2453 
2454     /**
2455      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2456      */
2457     function totalSupply() public view returns (uint256) {
2458         // Counter underflow is impossible as _burnCounter cannot be incremented
2459         // more than _currentIndex - _startTokenId() times
2460         unchecked {
2461             return _currentIndex - _burnCounter - _startTokenId();
2462         }
2463     }
2464 
2465     /**
2466      * Returns the total amount of tokens minted in the contract.
2467      */
2468     function _totalMinted() internal view returns (uint256) {
2469         // Counter underflow is impossible as _currentIndex does not decrement,
2470         // and it is initialized to _startTokenId()
2471         unchecked {
2472             return _currentIndex - _startTokenId();
2473         }
2474     }
2475 
2476     /**
2477      * @dev See {IERC165-supportsInterface}.
2478      */
2479     function supportsInterface(bytes4 interfaceId)
2480         public
2481         view
2482         virtual
2483         override(ERC165, IERC165)
2484         returns (bool)
2485     {
2486         return
2487             interfaceId == type(IERC721).interfaceId ||
2488             interfaceId == type(IERC721Metadata).interfaceId ||
2489             super.supportsInterface(interfaceId);
2490     }
2491 
2492     /**
2493      * @dev See {IERC721-balanceOf}.
2494      */
2495     function balanceOf(address owner) public view override returns (uint256) {
2496         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2497         return uint256(_addressData[owner].balance);
2498     }
2499 
2500     /**
2501      * Returns the number of tokens minted by `owner`.
2502      */
2503     function _numberMinted(address owner) internal view returns (uint256) {
2504         return uint256(_addressData[owner].numberMinted);
2505     }
2506 
2507     /**
2508      * Returns the number of tokens burned by or on behalf of `owner`.
2509      */
2510     function _numberBurned(address owner) internal view returns (uint256) {
2511         return uint256(_addressData[owner].numberBurned);
2512     }
2513 
2514     /**
2515      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2516      */
2517     function _getAux(address owner) internal view returns (uint64) {
2518         return _addressData[owner].aux;
2519     }
2520 
2521     /**
2522      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2523      * If there are multiple variables, please pack them into a uint64.
2524      */
2525     function _setAux(address owner, uint64 aux) internal {
2526         _addressData[owner].aux = aux;
2527     }
2528 
2529     /**
2530      * Gas spent here starts off proportional to the maximum mint batch size.
2531      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2532      */
2533     function _ownershipOf(uint256 tokenId)
2534         internal
2535         view
2536         returns (TokenOwnership memory)
2537     {
2538         uint256 curr = tokenId;
2539 
2540         unchecked {
2541             if (_startTokenId() <= curr && curr < _currentIndex) {
2542                 TokenOwnership memory ownership = _ownerships[curr];
2543                 if (!ownership.burned) {
2544                     if (ownership.addr != address(0)) {
2545                         return ownership;
2546                     }
2547                     // Invariant:
2548                     // There will always be an ownership that has an address and is not burned
2549                     // before an ownership that does not have an address and is not burned.
2550                     // Hence, curr will not underflow.
2551                     while (true) {
2552                         curr--;
2553                         ownership = _ownerships[curr];
2554                         if (ownership.addr != address(0)) {
2555                             return ownership;
2556                         }
2557                     }
2558                 }
2559             }
2560         }
2561         revert OwnerQueryForNonexistentToken();
2562     }
2563 
2564     /**
2565      * @dev See {IERC721-ownerOf}.
2566      */
2567     function ownerOf(uint256 tokenId) public view override returns (address) {
2568         return _ownershipOf(tokenId).addr;
2569     }
2570 
2571     /**
2572      * @dev See {IERC721Metadata-name}.
2573      */
2574     function name() public view virtual override returns (string memory) {
2575         return _name;
2576     }
2577 
2578     /**
2579      * @dev See {IERC721Metadata-symbol}.
2580      */
2581     function symbol() public view virtual override returns (string memory) {
2582         return _symbol;
2583     }
2584 
2585     /**
2586      * @dev See {IERC721Metadata-tokenURI}.
2587      */
2588     function tokenURI(uint256 tokenId)
2589         public
2590         view
2591         virtual
2592         override
2593         returns (string memory)
2594     {
2595         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2596 
2597         string memory baseURI = _baseURI();
2598         return
2599             bytes(baseURI).length != 0
2600                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2601                 : "";
2602     }
2603 
2604     /**
2605      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2606      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2607      * by default, can be overriden in child contracts.
2608      */
2609     function _baseURI() internal view virtual returns (string memory) {
2610         return "";
2611     }
2612 
2613     /**
2614      * @dev See {IERC721-approve}.
2615      */
2616     function approve(address to, uint256 tokenId) public virtual override {
2617         address owner = ERC721A.ownerOf(tokenId);
2618         if (to == owner) revert ApprovalToCurrentOwner();
2619 
2620         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2621             revert ApprovalCallerNotOwnerNorApproved();
2622         }
2623 
2624         _approve(to, tokenId, owner);
2625     }
2626 
2627     /**
2628      * @dev See {IERC721-getApproved}.
2629      */
2630     function getApproved(uint256 tokenId)
2631         public
2632         view
2633         override
2634         returns (address)
2635     {
2636         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2637 
2638         return _tokenApprovals[tokenId];
2639     }
2640 
2641     /**
2642      * @dev See {IERC721-setApprovalForAll}.
2643      */
2644     function setApprovalForAll(address operator, bool approved)
2645         public
2646         virtual
2647         override
2648     {
2649         if (operator == _msgSender()) revert ApproveToCaller();
2650 
2651         _operatorApprovals[_msgSender()][operator] = approved;
2652         emit ApprovalForAll(_msgSender(), operator, approved);
2653     }
2654 
2655     /**
2656      * @dev See {IERC721-isApprovedForAll}.
2657      */
2658     function isApprovedForAll(address owner, address operator)
2659         public
2660         view
2661         virtual
2662         override
2663         returns (bool)
2664     {
2665         return _operatorApprovals[owner][operator];
2666     }
2667 
2668     /**
2669      * @dev See {IERC721-transferFrom}.
2670      */
2671     function transferFrom(
2672         address from,
2673         address to,
2674         uint256 tokenId
2675     ) public virtual override {
2676         _transfer(from, to, tokenId);
2677     }
2678 
2679     /**
2680      * @dev See {IERC721-safeTransferFrom}.
2681      */
2682     function safeTransferFrom(
2683         address from,
2684         address to,
2685         uint256 tokenId
2686     ) public virtual override {
2687         safeTransferFrom(from, to, tokenId, "");
2688     }
2689 
2690     /**
2691      * @dev See {IERC721-safeTransferFrom}.
2692      */
2693     function safeTransferFrom(
2694         address from,
2695         address to,
2696         uint256 tokenId,
2697         bytes memory _data
2698     ) public virtual override {
2699         _transfer(from, to, tokenId);
2700         if (
2701             to.isContract() &&
2702             !_checkContractOnERC721Received(from, to, tokenId, _data)
2703         ) {
2704             revert TransferToNonERC721ReceiverImplementer();
2705         }
2706     }
2707 
2708     /**
2709      * @dev Returns whether `tokenId` exists.
2710      *
2711      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2712      *
2713      * Tokens start existing when they are minted (`_mint`),
2714      */
2715     function _exists(uint256 tokenId) internal view returns (bool) {
2716         return
2717             _startTokenId() <= tokenId &&
2718             tokenId < _currentIndex &&
2719             !_ownerships[tokenId].burned;
2720     }
2721 
2722     function _safeMint(address to, uint256 quantity) internal {
2723         _safeMint(to, quantity, "");
2724     }
2725 
2726     /**
2727      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2728      *
2729      * Requirements:
2730      *
2731      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2732      * - `quantity` must be greater than 0.
2733      *
2734      * Emits a {Transfer} event.
2735      */
2736     function _safeMint(
2737         address to,
2738         uint256 quantity,
2739         bytes memory _data
2740     ) internal {
2741         _mint(to, quantity, _data, true);
2742     }
2743 
2744     /**
2745      * @dev Mints `quantity` tokens and transfers them to `to`.
2746      *
2747      * Requirements:
2748      *
2749      * - `to` cannot be the zero address.
2750      * - `quantity` must be greater than 0.
2751      *
2752      * Emits a {Transfer} event.
2753      */
2754     function _mint(
2755         address to,
2756         uint256 quantity,
2757         bytes memory _data,
2758         bool safe
2759     ) internal {
2760         uint256 startTokenId = _currentIndex;
2761         if (to == address(0)) revert MintToZeroAddress();
2762         if (quantity == 0) revert MintZeroQuantity();
2763 
2764         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2765 
2766         // Overflows are incredibly unrealistic.
2767         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2768         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2769         unchecked {
2770             _addressData[to].balance += uint64(quantity);
2771             _addressData[to].numberMinted += uint64(quantity);
2772 
2773             _ownerships[startTokenId].addr = to;
2774             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2775 
2776             uint256 updatedIndex = startTokenId;
2777             uint256 end = updatedIndex + quantity;
2778 
2779             if (safe && to.isContract()) {
2780                 do {
2781                     emit Transfer(address(0), to, updatedIndex);
2782                     if (
2783                         !_checkContractOnERC721Received(
2784                             address(0),
2785                             to,
2786                             updatedIndex++,
2787                             _data
2788                         )
2789                     ) {
2790                         revert TransferToNonERC721ReceiverImplementer();
2791                     }
2792                 } while (updatedIndex != end);
2793                 // Reentrancy protection
2794                 if (_currentIndex != startTokenId) revert();
2795             } else {
2796                 do {
2797                     emit Transfer(address(0), to, updatedIndex++);
2798                 } while (updatedIndex != end);
2799             }
2800             _currentIndex = updatedIndex;
2801         }
2802         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2803     }
2804 
2805     /**
2806      * @dev Transfers `tokenId` from `from` to `to`.
2807      *
2808      * Requirements:
2809      *
2810      * - `to` cannot be the zero address.
2811      * - `tokenId` token must be owned by `from`.
2812      *
2813      * Emits a {Transfer} event.
2814      */
2815     function _transfer(
2816         address from,
2817         address to,
2818         uint256 tokenId
2819     ) private {
2820         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2821 
2822         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2823 
2824         bool isApprovedOrOwner = (_msgSender() == from ||
2825             isApprovedForAll(from, _msgSender()) ||
2826             getApproved(tokenId) == _msgSender());
2827 
2828         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2829         if (to == address(0)) revert TransferToZeroAddress();
2830 
2831         _beforeTokenTransfers(from, to, tokenId, 1);
2832 
2833         // Clear approvals from the previous owner
2834         _approve(address(0), tokenId, from);
2835 
2836         // Underflow of the sender's balance is impossible because we check for
2837         // ownership above and the recipient's balance can't realistically overflow.
2838         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2839         unchecked {
2840             _addressData[from].balance -= 1;
2841             _addressData[to].balance += 1;
2842 
2843             TokenOwnership storage currSlot = _ownerships[tokenId];
2844             currSlot.addr = to;
2845             currSlot.startTimestamp = uint64(block.timestamp);
2846 
2847             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2848             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2849             uint256 nextTokenId = tokenId + 1;
2850             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2851             if (nextSlot.addr == address(0)) {
2852                 // This will suffice for checking _exists(nextTokenId),
2853                 // as a burned slot cannot contain the zero address.
2854                 if (nextTokenId != _currentIndex) {
2855                     nextSlot.addr = from;
2856                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2857                 }
2858             }
2859         }
2860 
2861         emit Transfer(from, to, tokenId);
2862         _afterTokenTransfers(from, to, tokenId, 1);
2863     }
2864 
2865     /**
2866      * @dev This is equivalent to _burn(tokenId, false)
2867      */
2868     function _burn(uint256 tokenId) internal virtual {
2869         _burn(tokenId, false);
2870     }
2871 
2872     /**
2873      * @dev Destroys `tokenId`.
2874      * The approval is cleared when the token is burned.
2875      *
2876      * Requirements:
2877      *
2878      * - `tokenId` must exist.
2879      *
2880      * Emits a {Transfer} event.
2881      */
2882     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2883         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2884 
2885         address from = prevOwnership.addr;
2886 
2887         if (approvalCheck) {
2888             bool isApprovedOrOwner = (_msgSender() == from ||
2889                 isApprovedForAll(from, _msgSender()) ||
2890                 getApproved(tokenId) == _msgSender());
2891 
2892             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2893         }
2894 
2895         _beforeTokenTransfers(from, address(0), tokenId, 1);
2896 
2897         // Clear approvals from the previous owner
2898         _approve(address(0), tokenId, from);
2899 
2900         // Underflow of the sender's balance is impossible because we check for
2901         // ownership above and the recipient's balance can't realistically overflow.
2902         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2903         unchecked {
2904             AddressData storage addressData = _addressData[from];
2905             addressData.balance -= 1;
2906             addressData.numberBurned += 1;
2907 
2908             // Keep track of who burned the token, and the timestamp of burning.
2909             TokenOwnership storage currSlot = _ownerships[tokenId];
2910             currSlot.addr = from;
2911             currSlot.startTimestamp = uint64(block.timestamp);
2912             currSlot.burned = true;
2913 
2914             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2915             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2916             uint256 nextTokenId = tokenId + 1;
2917             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2918             if (nextSlot.addr == address(0)) {
2919                 // This will suffice for checking _exists(nextTokenId),
2920                 // as a burned slot cannot contain the zero address.
2921                 if (nextTokenId != _currentIndex) {
2922                     nextSlot.addr = from;
2923                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2924                 }
2925             }
2926         }
2927 
2928         emit Transfer(from, address(0), tokenId);
2929         _afterTokenTransfers(from, address(0), tokenId, 1);
2930 
2931         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2932         unchecked {
2933             _burnCounter++;
2934         }
2935     }
2936 
2937     /**
2938      * @dev Approve `to` to operate on `tokenId`
2939      *
2940      * Emits a {Approval} event.
2941      */
2942     function _approve(
2943         address to,
2944         uint256 tokenId,
2945         address owner
2946     ) private {
2947         _tokenApprovals[tokenId] = to;
2948         emit Approval(owner, to, tokenId);
2949     }
2950 
2951     /**
2952      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2953      *
2954      * @param from address representing the previous owner of the given token ID
2955      * @param to target address that will receive the tokens
2956      * @param tokenId uint256 ID of the token to be transferred
2957      * @param _data bytes optional data to send along with the call
2958      * @return bool whether the call correctly returned the expected magic value
2959      */
2960     function _checkContractOnERC721Received(
2961         address from,
2962         address to,
2963         uint256 tokenId,
2964         bytes memory _data
2965     ) private returns (bool) {
2966         try
2967             IERC721Receiver(to).onERC721Received(
2968                 _msgSender(),
2969                 from,
2970                 tokenId,
2971                 _data
2972             )
2973         returns (bytes4 retval) {
2974             return retval == IERC721Receiver(to).onERC721Received.selector;
2975         } catch (bytes memory reason) {
2976             if (reason.length == 0) {
2977                 revert TransferToNonERC721ReceiverImplementer();
2978             } else {
2979                 assembly {
2980                     revert(add(32, reason), mload(reason))
2981                 }
2982             }
2983         }
2984     }
2985 
2986     /**
2987      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2988      * And also called before burning one token.
2989      *
2990      * startTokenId - the first token id to be transferred
2991      * quantity - the amount to be transferred
2992      *
2993      * Calling conditions:
2994      *
2995      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2996      * transferred to `to`.
2997      * - When `from` is zero, `tokenId` will be minted for `to`.
2998      * - When `to` is zero, `tokenId` will be burned by `from`.
2999      * - `from` and `to` are never both zero.
3000      */
3001     function _beforeTokenTransfers(
3002         address from,
3003         address to,
3004         uint256 startTokenId,
3005         uint256 quantity
3006     ) internal virtual {}
3007 
3008     /**
3009      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3010      * minting.
3011      * And also called after one token has been burned.
3012      *
3013      * startTokenId - the first token id to be transferred
3014      * quantity - the amount to be transferred
3015      *
3016      * Calling conditions:
3017      *
3018      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
3019      * transferred to `to`.
3020      * - When `from` is zero, `tokenId` has been minted for `to`.
3021      * - When `to` is zero, `tokenId` has been burned by `from`.
3022      * - `from` and `to` are never both zero.
3023      */
3024     function _afterTokenTransfers(
3025         address from,
3026         address to,
3027         uint256 startTokenId,
3028         uint256 quantity
3029     ) internal virtual {}
3030 }
3031 
3032 pragma solidity ^0.8.0;
3033 
3034 /**
3035  * @dev Interface of the ERC20 standard as defined in the EIP.
3036  */
3037 interface IERC20 {
3038     /**
3039      * @dev Emitted when `value` tokens are moved from one account (`from`) to
3040      * another (`to`).
3041      *
3042      * Note that `value` may be zero.
3043      */
3044     event Transfer(address indexed from, address indexed to, uint256 value);
3045 
3046     /**
3047      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
3048      * a call to {approve}. `value` is the new allowance.
3049      */
3050     event Approval(
3051         address indexed owner,
3052         address indexed spender,
3053         uint256 value
3054     );
3055 
3056     /**
3057      * @dev Returns the amount of tokens in existence.
3058      */
3059     function totalSupply() external view returns (uint256);
3060 
3061     /**
3062      * @dev Returns the amount of tokens owned by `account`.
3063      */
3064     function balanceOf(address account) external view returns (uint256);
3065 
3066     /**
3067      * @dev Moves `amount` tokens from the caller's account to `to`.
3068      *
3069      * Returns a boolean value indicating whether the operation succeeded.
3070      *
3071      * Emits a {Transfer} event.
3072      */
3073     function transfer(address to, uint256 amount) external returns (bool);
3074 
3075     /**
3076      * @dev Returns the remaining number of tokens that `spender` will be
3077      * allowed to spend on behalf of `owner` through {transferFrom}. This is
3078      * zero by default.
3079      *
3080      * This value changes when {approve} or {transferFrom} are called.
3081      */
3082     function allowance(address owner, address spender)
3083         external
3084         view
3085         returns (uint256);
3086 
3087     /**
3088      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
3089      *
3090      * Returns a boolean value indicating whether the operation succeeded.
3091      *
3092      * IMPORTANT: Beware that changing an allowance with this method brings the risk
3093      * that someone may use both the old and the new allowance by unfortunate
3094      * transaction ordering. One possible solution to mitigate this race
3095      * condition is to first reduce the spender's allowance to 0 and set the
3096      * desired value afterwards:
3097      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
3098      *
3099      * Emits an {Approval} event.
3100      */
3101     function approve(address spender, uint256 amount) external returns (bool);
3102 
3103     /**
3104      * @dev Moves `amount` tokens from `from` to `to` using the
3105      * allowance mechanism. `amount` is then deducted from the caller's
3106      * allowance.
3107      *
3108      * Returns a boolean value indicating whether the operation succeeded.
3109      *
3110      * Emits a {Transfer} event.
3111      */
3112     function transferFrom(
3113         address from,
3114         address to,
3115         uint256 amount
3116     ) external returns (bool);
3117 }
3118 
3119 pragma solidity ^0.8.0;
3120 
3121 /**
3122  * @title SafeERC20
3123  * @dev Wrappers around ERC20 operations that throw on failure (when the token
3124  * contract returns false). Tokens that return no value (and instead revert or
3125  * throw on failure) are also supported, non-reverting calls are assumed to be
3126  * successful.
3127  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
3128  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
3129  */
3130 library SafeERC20 {
3131     using Address for address;
3132 
3133     function safeTransfer(
3134         IERC20 token,
3135         address to,
3136         uint256 value
3137     ) internal {
3138         _callOptionalReturn(
3139             token,
3140             abi.encodeWithSelector(token.transfer.selector, to, value)
3141         );
3142     }
3143 
3144     function safeTransferFrom(
3145         IERC20 token,
3146         address from,
3147         address to,
3148         uint256 value
3149     ) internal {
3150         _callOptionalReturn(
3151             token,
3152             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
3153         );
3154     }
3155 
3156     /**
3157      * @dev Deprecated. This function has issues similar to the ones found in
3158      * {IERC20-approve}, and its usage is discouraged.
3159      *
3160      * Whenever possible, use {safeIncreaseAllowance} and
3161      * {safeDecreaseAllowance} instead.
3162      */
3163     function safeApprove(
3164         IERC20 token,
3165         address spender,
3166         uint256 value
3167     ) internal {
3168         // safeApprove should only be called when setting an initial allowance,
3169         // or when resetting it to zero. To increase and decrease it, use
3170         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
3171         require(
3172             (value == 0) || (token.allowance(address(this), spender) == 0),
3173             "SafeERC20: approve from non-zero to non-zero allowance"
3174         );
3175         _callOptionalReturn(
3176             token,
3177             abi.encodeWithSelector(token.approve.selector, spender, value)
3178         );
3179     }
3180 
3181     function safeIncreaseAllowance(
3182         IERC20 token,
3183         address spender,
3184         uint256 value
3185     ) internal {
3186         uint256 newAllowance = token.allowance(address(this), spender) + value;
3187         _callOptionalReturn(
3188             token,
3189             abi.encodeWithSelector(
3190                 token.approve.selector,
3191                 spender,
3192                 newAllowance
3193             )
3194         );
3195     }
3196 
3197     function safeDecreaseAllowance(
3198         IERC20 token,
3199         address spender,
3200         uint256 value
3201     ) internal {
3202         unchecked {
3203             uint256 oldAllowance = token.allowance(address(this), spender);
3204             require(
3205                 oldAllowance >= value,
3206                 "SafeERC20: decreased allowance below zero"
3207             );
3208             uint256 newAllowance = oldAllowance - value;
3209             _callOptionalReturn(
3210                 token,
3211                 abi.encodeWithSelector(
3212                     token.approve.selector,
3213                     spender,
3214                     newAllowance
3215                 )
3216             );
3217         }
3218     }
3219 
3220     /**
3221      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
3222      * on the return value: the return value is optional (but if data is returned, it must not be false).
3223      * @param token The token targeted by the call.
3224      * @param data The call data (encoded using abi.encode or one of its variants).
3225      */
3226     function _callOptionalReturn(IERC20 token, bytes memory data) private {
3227         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
3228         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
3229         // the target address contains contract code and also asserts for success in the low-level call.
3230 
3231         bytes memory returndata = address(token).functionCall(
3232             data,
3233             "SafeERC20: low-level call failed"
3234         );
3235         if (returndata.length > 0) {
3236             // Return data is optional
3237             require(
3238                 abi.decode(returndata, (bool)),
3239                 "SafeERC20: ERC20 operation did not succeed"
3240             );
3241         }
3242     }
3243 }
3244 
3245 pragma solidity ^0.8.0;
3246 
3247 /**
3248  * @title PaymentSplitter
3249  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
3250  * that the Ether will be split in this way, since it is handled transparently by the contract.
3251  *
3252  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
3253  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
3254  * an amount proportional to the percentage of total shares they were assigned.
3255  *
3256  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
3257  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
3258  * function.
3259  *
3260  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
3261  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
3262  * to run tests before sending real value to this contract.
3263  */
3264 contract PaymentSplitter is Context {
3265     event PayeeAdded(address account, uint256 shares);
3266     event PaymentReleased(address to, uint256 amount);
3267     event ERC20PaymentReleased(
3268         IERC20 indexed token,
3269         address to,
3270         uint256 amount
3271     );
3272     event PaymentReceived(address from, uint256 amount);
3273 
3274     uint256 private _totalShares;
3275     uint256 private _totalReleased;
3276 
3277     mapping(address => uint256) private _shares;
3278     mapping(address => uint256) private _released;
3279     address[] private _payees;
3280 
3281     mapping(IERC20 => uint256) private _erc20TotalReleased;
3282     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
3283 
3284     /**
3285      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
3286      * the matching position in the `shares` array.
3287      *
3288      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
3289      * duplicates in `payees`.
3290      */
3291     constructor(address[] memory payees, uint256[] memory shares_) payable {
3292         require(
3293             payees.length == shares_.length,
3294             "PaymentSplitter: payees and shares length mismatch"
3295         );
3296         require(payees.length > 0, "PaymentSplitter: no payees");
3297 
3298         for (uint256 i = 0; i < payees.length; i++) {
3299             _addPayee(payees[i], shares_[i]);
3300         }
3301     }
3302 
3303     /**
3304      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
3305      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
3306      * reliability of the events, and not the actual splitting of Ether.
3307      *
3308      * To learn more about this see the Solidity documentation for
3309      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
3310      * functions].
3311      */
3312     receive() external payable virtual {
3313         emit PaymentReceived(_msgSender(), msg.value);
3314     }
3315 
3316     /**
3317      * @dev Getter for the total shares held by payees.
3318      */
3319     function totalShares() public view returns (uint256) {
3320         return _totalShares;
3321     }
3322 
3323     /**
3324      * @dev Getter for the total amount of Ether already released.
3325      */
3326     function totalReleased() public view returns (uint256) {
3327         return _totalReleased;
3328     }
3329 
3330     /**
3331      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
3332      * contract.
3333      */
3334     function totalReleased(IERC20 token) public view returns (uint256) {
3335         return _erc20TotalReleased[token];
3336     }
3337 
3338     /**
3339      * @dev Getter for the amount of shares held by an account.
3340      */
3341     function shares(address account) public view returns (uint256) {
3342         return _shares[account];
3343     }
3344 
3345     /**
3346      * @dev Getter for the amount of Ether already released to a payee.
3347      */
3348     function released(address account) public view returns (uint256) {
3349         return _released[account];
3350     }
3351 
3352     /**
3353      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
3354      * IERC20 contract.
3355      */
3356     function released(IERC20 token, address account)
3357         public
3358         view
3359         returns (uint256)
3360     {
3361         return _erc20Released[token][account];
3362     }
3363 
3364     /**
3365      * @dev Getter for the address of the payee number `index`.
3366      */
3367     function payee(uint256 index) public view returns (address) {
3368         return _payees[index];
3369     }
3370 
3371     /**
3372      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
3373      * total shares and their previous withdrawals.
3374      */
3375     function release(address payable account) public virtual {
3376         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3377 
3378         uint256 totalReceived = address(this).balance + totalReleased();
3379         uint256 payment = _pendingPayment(
3380             account,
3381             totalReceived,
3382             released(account)
3383         );
3384 
3385         require(payment != 0, "PaymentSplitter: account is not due payment");
3386 
3387         _released[account] += payment;
3388         _totalReleased += payment;
3389 
3390         Address.sendValue(account, payment);
3391         emit PaymentReleased(account, payment);
3392     }
3393 
3394     /**
3395      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
3396      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
3397      * contract.
3398      */
3399     function release(IERC20 token, address account) public virtual {
3400         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3401 
3402         uint256 totalReceived = token.balanceOf(address(this)) +
3403             totalReleased(token);
3404         uint256 payment = _pendingPayment(
3405             account,
3406             totalReceived,
3407             released(token, account)
3408         );
3409 
3410         require(payment != 0, "PaymentSplitter: account is not due payment");
3411 
3412         _erc20Released[token][account] += payment;
3413         _erc20TotalReleased[token] += payment;
3414 
3415         SafeERC20.safeTransfer(token, account, payment);
3416         emit ERC20PaymentReleased(token, account, payment);
3417     }
3418 
3419     /**
3420      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
3421      * already released amounts.
3422      */
3423     function _pendingPayment(
3424         address account,
3425         uint256 totalReceived,
3426         uint256 alreadyReleased
3427     ) private view returns (uint256) {
3428         return
3429             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
3430     }
3431 
3432     /**
3433      * @dev Add a new payee to the contract.
3434      * @param account The address of the payee to add.
3435      * @param shares_ The number of shares owned by the payee.
3436      */
3437     function _addPayee(address account, uint256 shares_) private {
3438         require(
3439             account != address(0),
3440             "PaymentSplitter: account is the zero address"
3441         );
3442         require(shares_ > 0, "PaymentSplitter: shares are 0");
3443         require(
3444             _shares[account] == 0,
3445             "PaymentSplitter: account already has shares"
3446         );
3447 
3448         _payees.push(account);
3449         _shares[account] = shares_;
3450         _totalShares = _totalShares + shares_;
3451         emit PayeeAdded(account, shares_);
3452     }
3453 }
3454 pragma solidity ^0.8.0;
3455 
3456 interface IOperatorFilterRegistry {
3457     function isOperatorAllowed(address registrant, address operator)
3458         external
3459         view
3460         returns (bool);
3461 
3462     function register(address registrant) external;
3463 
3464     function registerAndSubscribe(address registrant, address subscription)
3465         external;
3466 
3467     function registerAndCopyEntries(
3468         address registrant,
3469         address registrantToCopy
3470     ) external;
3471 
3472     function unregister(address addr) external;
3473 
3474     function updateOperator(
3475         address registrant,
3476         address operator,
3477         bool filtered
3478     ) external;
3479 
3480     function updateOperators(
3481         address registrant,
3482         address[] calldata operators,
3483         bool filtered
3484     ) external;
3485 
3486     function updateCodeHash(
3487         address registrant,
3488         bytes32 codehash,
3489         bool filtered
3490     ) external;
3491 
3492     function updateCodeHashes(
3493         address registrant,
3494         bytes32[] calldata codeHashes,
3495         bool filtered
3496     ) external;
3497 
3498     function subscribe(address registrant, address registrantToSubscribe)
3499         external;
3500 
3501     function unsubscribe(address registrant, bool copyExistingEntries) external;
3502 
3503     function subscriptionOf(address addr) external returns (address registrant);
3504 
3505     function subscribers(address registrant)
3506         external
3507         returns (address[] memory);
3508 
3509     function subscriberAt(address registrant, uint256 index)
3510         external
3511         returns (address);
3512 
3513     function copyEntriesOf(address registrant, address registrantToCopy)
3514         external;
3515 
3516     function isOperatorFiltered(address registrant, address operator)
3517         external
3518         returns (bool);
3519 
3520     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
3521         external
3522         returns (bool);
3523 
3524     function isCodeHashFiltered(address registrant, bytes32 codeHash)
3525         external
3526         returns (bool);
3527 
3528     function filteredOperators(address addr)
3529         external
3530         returns (address[] memory);
3531 
3532     function filteredCodeHashes(address addr)
3533         external
3534         returns (bytes32[] memory);
3535 
3536     function filteredOperatorAt(address registrant, uint256 index)
3537         external
3538         returns (address);
3539 
3540     function filteredCodeHashAt(address registrant, uint256 index)
3541         external
3542         returns (bytes32);
3543 
3544     function isRegistered(address addr) external returns (bool);
3545 
3546     function codeHashOf(address addr) external returns (bytes32);
3547 }
3548 
3549 /**
3550  * @title  OperatorFilterer
3551  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
3552  *         registrant's entries in the OperatorFilterRegistry.
3553  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
3554  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
3555  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
3556  */
3557 abstract contract OperatorFilterer {
3558     error OperatorNotAllowed(address operator);
3559 
3560     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
3561         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3562 
3563     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3564         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3565         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3566         // order for the modifier to filter addresses.
3567         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3568             if (subscribe) {
3569                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
3570                     address(this),
3571                     subscriptionOrRegistrantToCopy
3572                 );
3573             } else {
3574                 if (subscriptionOrRegistrantToCopy != address(0)) {
3575                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
3576                         address(this),
3577                         subscriptionOrRegistrantToCopy
3578                     );
3579                 } else {
3580                     OPERATOR_FILTER_REGISTRY.register(address(this));
3581                 }
3582             }
3583         }
3584     }
3585 
3586     modifier onlyAllowedOperator(address from) virtual {
3587         // Check registry code length to facilitate testing in environments without a deployed registry.
3588         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3589             // Allow spending tokens from addresses with balance
3590             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3591             // from an EOA.
3592             if (from == msg.sender) {
3593                 _;
3594                 return;
3595             }
3596             if (
3597                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
3598                     address(this),
3599                     msg.sender
3600                 )
3601             ) {
3602                 revert OperatorNotAllowed(msg.sender);
3603             }
3604         }
3605         _;
3606     }
3607 
3608     modifier onlyAllowedOperatorApproval(address operator) virtual {
3609         // Check registry code length to facilitate testing in environments without a deployed registry.
3610         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3611             if (
3612                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
3613                     address(this),
3614                     operator
3615                 )
3616             ) {
3617                 revert OperatorNotAllowed(operator);
3618             }
3619         }
3620         _;
3621     }
3622 }
3623 
3624 /**
3625  * @title  DefaultOperatorFilterer
3626  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
3627  */
3628 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3629     address constant DEFAULT_SUBSCRIPTION =
3630         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3631 
3632     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3633 }
3634 
3635 contract OtherContract {
3636     mapping(uint256 => address) public _nftTokenForges;
3637 
3638     // Define function to get NFT token forge address from mapping
3639     function getNftTokenForgeAddress(uint256 key)
3640         public
3641         view
3642         returns (address)
3643     {
3644         return _nftTokenForges[key];
3645     }
3646 }
3647 
3648 contract MythicPets is
3649     ERC721A,
3650     ReentrancyGuard,
3651     Ownable,
3652     PaymentSplitter,
3653     DefaultOperatorFilterer
3654 {
3655     // Minting Variables
3656     uint256 public mintPrice = 0.15 ether;
3657     uint256 public maxPurchase = 33;
3658     uint256 public maxSupply = 3333;
3659 
3660     // Sale Status
3661     bool public saleIsActive = false;
3662     bool public freeMintIsActive = true;
3663     bool public airdropIsActive = true;
3664 
3665     // the membership contract
3666     address public membership = 0xBA3B1b86ae330d2118e868b4906cc954a4207835;
3667 
3668     mapping(address => uint256) public addressesThatMinted;
3669     mapping(uint256 => bool) public memberFreeMinted; // by token id
3670 
3671     // Metadata
3672     string _baseTokenURI = "https://apeliquid.io/pets/json/";
3673     bool public locked;
3674 
3675     // Events
3676     event SaleActivation(bool isActive);
3677     event AirdropActivation(bool isActive);
3678     event FreeMintActivation(bool isActive);
3679 
3680     constructor()
3681         ERC721A("Mythic Pets", "PETS")
3682         PaymentSplitter(_payees, _shares)
3683     {}
3684 
3685     function flipMintStatus(uint256 tokenId) external onlyOwner {
3686         memberFreeMinted[tokenId] = !memberFreeMinted[tokenId];
3687     }
3688 
3689     // Holder status validation
3690     // Define function to get NFT token forge address from other contract
3691     function getNftTokenForgeAddress(address otherContract, uint256 key)
3692         public
3693         view
3694         returns (address)
3695     {
3696         return OtherContract(otherContract).getNftTokenForgeAddress(key);
3697     }
3698 
3699     function airdrop(uint256[] calldata _counts, address[] calldata _list)
3700         external
3701         onlyOwner
3702     {
3703         require(airdropIsActive, "AIRDROP NOT ACTIVE");
3704 
3705         for (uint256 i = 0; i < _list.length; i++) {
3706             require(totalSupply() + _counts[i] <= maxSupply, "SOLD OUT");
3707             _safeMint(_list[i], _counts[i]);
3708         }
3709     }
3710 
3711     function freeMint(uint256 memberTokenId) external nonReentrant {
3712         uint256 _count = 1; // one at a time for free
3713 
3714         require(freeMintIsActive, "FREE MINT INACTIVE");
3715 
3716         // Check to make sure we haven't already minted for this tokenid
3717         require(!memberFreeMinted[memberTokenId], "Already Minted!");
3718 
3719         require(totalSupply() + _count <= maxSupply, "SOLD OUT");
3720         //require(mintPrice * _count <= msg.value, "INCORRECT ETHER VALUE");
3721 
3722         require(
3723             getNftTokenForgeAddress(membership, memberTokenId) == msg.sender,
3724             "This membership is not forged!"
3725         );
3726 
3727         _safeMint(msg.sender, _count);
3728         // addressesThatMinted[msg.sender] += _count;
3729         memberFreeMinted[memberTokenId] = true;
3730     }
3731 
3732     function mint(uint256 _count) external payable nonReentrant {
3733         require(saleIsActive, "SALE INACTIVE");
3734         require(
3735             ((addressesThatMinted[msg.sender] + _count)) <= maxPurchase,
3736             "this would exceed mint max allowance"
3737         );
3738 
3739         require(totalSupply() + _count <= maxSupply, "SOLD OUT");
3740         require(mintPrice * _count <= msg.value, "INCORRECT ETHER VALUE");
3741 
3742         _safeMint(msg.sender, _count);
3743         addressesThatMinted[msg.sender] += _count;
3744     }
3745 
3746     function toggleSaleStatus() external onlyOwner {
3747         saleIsActive = !saleIsActive;
3748         emit SaleActivation(saleIsActive);
3749     }
3750 
3751     function freeMintStatus() external onlyOwner {
3752         freeMintIsActive = !freeMintIsActive;
3753         emit FreeMintActivation(freeMintIsActive);
3754     }
3755 
3756     function toggleAirdropStatus() external onlyOwner {
3757         airdropIsActive = !airdropIsActive;
3758         emit AirdropActivation(airdropIsActive);
3759     }
3760 
3761     function setMintPrice(uint256 _mintPrice) external onlyOwner {
3762         mintPrice = _mintPrice;
3763     }
3764 
3765     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
3766         maxPurchase = _maxPurchase;
3767     }
3768 
3769     function lockMetadata() external onlyOwner {
3770         locked = true;
3771     }
3772 
3773     // Payments
3774     function claim() external {
3775         release(payable(msg.sender));
3776     }
3777 
3778     function getWalletOfOwner(address owner)
3779         external
3780         view
3781         returns (uint256[] memory)
3782     {
3783         unchecked {
3784             uint256[] memory a = new uint256[](balanceOf(owner));
3785             uint256 end = _currentIndex;
3786             uint256 tokenIdsIdx;
3787             address currOwnershipAddr;
3788             for (uint256 i; i < end; i++) {
3789                 TokenOwnership memory ownership = _ownerships[i];
3790                 if (ownership.burned) {
3791                     continue;
3792                 }
3793                 if (ownership.addr != address(0)) {
3794                     currOwnershipAddr = ownership.addr;
3795                 }
3796                 if (currOwnershipAddr == owner) {
3797                     a[tokenIdsIdx++] = i;
3798                 }
3799             }
3800             return a;
3801         }
3802     }
3803 
3804     function getTotalSupply() external view returns (uint256) {
3805         return totalSupply();
3806     }
3807 
3808     function setBaseURI(string memory baseURI) external onlyOwner {
3809         require(!locked, "METADATA_LOCKED");
3810         _baseTokenURI = baseURI;
3811     }
3812 
3813     function _baseURI() internal view virtual override returns (string memory) {
3814         return _baseTokenURI;
3815     }
3816 
3817     function tokenURI(uint256 tokenId)
3818         public
3819         view
3820         override
3821         returns (string memory)
3822     {
3823         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
3824     }
3825 
3826     function _startTokenId() internal view virtual override returns (uint256) {
3827         return 1;
3828     }
3829 
3830     address[] public _payees = [
3831         0xcd245Eb87Cce56756BBF4661A5a88999A48d8752,
3832         0xfebbB48C8f7A67Dc3DcEE19524A410E078e6A6a1,
3833         0x0C07747AB98EE84971C90Fbd353eda207B737c43,
3834         0x867Eb0804eACA9FEeda8a0E1d2B9a32eEF58AF8f
3835     ];
3836     uint256[] private _shares = [15, 10, 10, 65];
3837 
3838     // OpenSea's new bullshit requirements, which violate my moral code, but
3839     // are nonetheless necessary to make this all work properly.
3840     // They are also bloated as fuck and generally annoying, but if they do
3841     // not exist, OpenSea refuses to work properly. :middle_finger_emoji:
3842     function setApprovalForAll(address operator, bool approved)
3843         public
3844         override
3845         onlyAllowedOperatorApproval(operator)
3846     {
3847         super.setApprovalForAll(operator, approved);
3848     }
3849 
3850     function approve(address operator, uint256 tokenId)
3851         public
3852         override
3853         onlyAllowedOperatorApproval(operator)
3854     {
3855         super.approve(operator, tokenId);
3856     }
3857 
3858 }