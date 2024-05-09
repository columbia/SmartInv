1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
3 
4 /*
5 
6   .____    .__             .__    .___ .___                         .___
7   |    |   |__| ________ __|__| __| _/ |   | _______  _______     __| _/___________  ______
8   |    |   |  |/ ____/  |  \  |/ __ |  |   |/    \  \/ /\__  \   / __ |/ __ \_  __ \/  ___/
9   |    |___|  < <_|  |  |  /  / /_/ |  |   |   |  \   /  / __ \_/ /_/ \  ___/|  | \/\___ \
10   |_______ \__|\__   |____/|__\____ |  |___|___|  /\_/  (____  /\____ |\___  >__|  /____  >
11           \/      |__|             \/           \/           \/      \/    \/           \/
12      _____                .____    .__             .__    .___    _____  .__        __
13     /  _  \ ______   ____ |    |   |__| ________ __|__| __| _/   /     \ |__| _____/  |_
14    /  /_\  \\____ \_/ __ \|    |   |  |/ ____/  |  \  |/ __ |   /  \ /  \|  |/    \   __\
15   /    |    \  |_> >  ___/|    |___|  < <_|  |  |  /  / /_/ |  /    Y    \  |   |  \  |
16   \____|__  /   __/ \___  >_______ \__|\__   |____/|__\____ |  \____|__  /__|___|  /__|
17           \/|__|        \/        \/      |__|             \/          \/        \/
18 
19     Contract created for ApeLiquid.io by Ryo & Aleph 0ne
20 
21 */
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev External interface of AccessControl declared to support ERC165 detection.
27  */
28 interface IAccessControl {
29     /**
30      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
31      *
32      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
33      * {RoleAdminChanged} not being emitted signaling this.
34      *
35      * _Available since v3.1._
36      */
37     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
38 
39     /**
40      * @dev Emitted when `account` is granted `role`.
41      *
42      * `sender` is the account that originated the contract call, an admin role
43      * bearer except when using {AccessControl-_setupRole}.
44      */
45     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
46 
47     /**
48      * @dev Emitted when `account` is revoked `role`.
49      *
50      * `sender` is the account that originated the contract call:
51      *   - if using `revokeRole`, it is the admin role bearer
52      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
53      */
54     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
55 
56     /**
57      * @dev Returns `true` if `account` has been granted `role`.
58      */
59     function hasRole(bytes32 role, address account) external view returns (bool);
60 
61     /**
62      * @dev Returns the admin role that controls `role`. See {grantRole} and
63      * {revokeRole}.
64      *
65      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
66      */
67     function getRoleAdmin(bytes32 role) external view returns (bytes32);
68 
69     /**
70      * @dev Grants `role` to `account`.
71      *
72      * If `account` had not been already granted `role`, emits a {RoleGranted}
73      * event.
74      *
75      * Requirements:
76      *
77      * - the caller must have ``role``'s admin role.
78      */
79     function grantRole(bytes32 role, address account) external;
80 
81     /**
82      * @dev Revokes `role` from `account`.
83      *
84      * If `account` had been granted `role`, emits a {RoleRevoked} event.
85      *
86      * Requirements:
87      *
88      * - the caller must have ``role``'s admin role.
89      */
90     function revokeRole(bytes32 role, address account) external;
91 
92     /**
93      * @dev Revokes `role` from the calling account.
94      *
95      * Roles are often managed via {grantRole} and {revokeRole}: this function's
96      * purpose is to provide a mechanism for accounts to lose their privileges
97      * if they are compromised (such as when a trusted device is misplaced).
98      *
99      * If the calling account had been granted `role`, emits a {RoleRevoked}
100      * event.
101      *
102      * Requirements:
103      *
104      * - the caller must be `account`.
105      */
106     function renounceRole(bytes32 role, address account) external;
107 }
108 
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Interface of the ERC165 standard, as defined in the
114  * https://eips.ethereum.org/EIPS/eip-165[EIP].
115  *
116  * Implementers can declare support of contract interfaces, which can then be
117  * queried by others ({ERC165Checker}).
118  *
119  * For an implementation, see {ERC165}.
120  */
121 interface IERC165 {
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30 000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 }
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
137  */
138 interface IAccessControlEnumerable is IAccessControl {
139     /**
140      * @dev Returns one of the accounts that have `role`. `index` must be a
141      * value between 0 and {getRoleMemberCount}, non-inclusive.
142      *
143      * Role bearers are not sorted in any particular way, and their ordering may
144      * change at any point.
145      *
146      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
147      * you perform all queries on the same block. See the following
148      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
149      * for more information.
150      */
151     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
152 
153     /**
154      * @dev Returns the number of accounts that have `role`. Can be used
155      * together with {getRoleMember} to enumerate all bearers of a role.
156      */
157     function getRoleMemberCount(bytes32 role) external view returns (uint256);
158 }
159 
160 pragma solidity ^0.8.0;
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
265     function _contains(Set storage set, bytes32 value) private view returns (bool) {
266         return set._indexes[value] != 0;
267     }
268 
269     /**
270      * @dev Returns the number of values on the set. O(1).
271      */
272     function _length(Set storage set) private view returns (uint256) {
273         return set._values.length;
274     }
275 
276     /**
277      * @dev Returns the value stored at position `index` in the set. O(1).
278      *
279      * Note that there are no guarantees on the ordering of values inside the
280      * array, and it may change when more values are added or removed.
281      *
282      * Requirements:
283      *
284      * - `index` must be strictly less than {length}.
285      */
286     function _at(Set storage set, uint256 index) private view returns (bytes32) {
287         return set._values[index];
288     }
289 
290     /**
291      * @dev Return the entire set in an array
292      *
293      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
294      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
295      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
296      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
297      */
298     function _values(Set storage set) private view returns (bytes32[] memory) {
299         return set._values;
300     }
301 
302     // Bytes32Set
303 
304     struct Bytes32Set {
305         Set _inner;
306     }
307 
308     /**
309      * @dev Add a value to a set. O(1).
310      *
311      * Returns true if the value was added to the set, that is if it was not
312      * already present.
313      */
314     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
315         return _add(set._inner, value);
316     }
317 
318     /**
319      * @dev Removes a value from a set. O(1).
320      *
321      * Returns true if the value was removed from the set, that is if it was
322      * present.
323      */
324     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
325         return _remove(set._inner, value);
326     }
327 
328     /**
329      * @dev Returns true if the value is in the set. O(1).
330      */
331     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
332         return _contains(set._inner, value);
333     }
334 
335     /**
336      * @dev Returns the number of values in the set. O(1).
337      */
338     function length(Bytes32Set storage set) internal view returns (uint256) {
339         return _length(set._inner);
340     }
341 
342     /**
343      * @dev Returns the value stored at position `index` in the set. O(1).
344      *
345      * Note that there are no guarantees on the ordering of values inside the
346      * array, and it may change when more values are added or removed.
347      *
348      * Requirements:
349      *
350      * - `index` must be strictly less than {length}.
351      */
352     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
353         return _at(set._inner, index);
354     }
355 
356     /**
357      * @dev Return the entire set in an array
358      *
359      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
360      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
361      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
362      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
363      */
364     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
365         return _values(set._inner);
366     }
367 
368     // AddressSet
369 
370     struct AddressSet {
371         Set _inner;
372     }
373 
374     /**
375      * @dev Add a value to a set. O(1).
376      *
377      * Returns true if the value was added to the set, that is if it was not
378      * already present.
379      */
380     function add(AddressSet storage set, address value) internal returns (bool) {
381         return _add(set._inner, bytes32(uint256(uint160(value))));
382     }
383 
384     /**
385      * @dev Removes a value from a set. O(1).
386      *
387      * Returns true if the value was removed from the set, that is if it was
388      * present.
389      */
390     function remove(AddressSet storage set, address value) internal returns (bool) {
391         return _remove(set._inner, bytes32(uint256(uint160(value))));
392     }
393 
394     /**
395      * @dev Returns true if the value is in the set. O(1).
396      */
397     function contains(AddressSet storage set, address value) internal view returns (bool) {
398         return _contains(set._inner, bytes32(uint256(uint160(value))));
399     }
400 
401     /**
402      * @dev Returns the number of values in the set. O(1).
403      */
404     function length(AddressSet storage set) internal view returns (uint256) {
405         return _length(set._inner);
406     }
407 
408     /**
409      * @dev Returns the value stored at position `index` in the set. O(1).
410      *
411      * Note that there are no guarantees on the ordering of values inside the
412      * array, and it may change when more values are added or removed.
413      *
414      * Requirements:
415      *
416      * - `index` must be strictly less than {length}.
417      */
418     function at(AddressSet storage set, uint256 index) internal view returns (address) {
419         return address(uint160(uint256(_at(set._inner, index))));
420     }
421 
422     /**
423      * @dev Return the entire set in an array
424      *
425      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
426      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
427      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
428      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
429      */
430     function values(AddressSet storage set) internal view returns (address[] memory) {
431         bytes32[] memory store = _values(set._inner);
432         address[] memory result;
433 
434         assembly {
435             result := store
436         }
437 
438         return result;
439     }
440 
441     // UintSet
442 
443     struct UintSet {
444         Set _inner;
445     }
446 
447     /**
448      * @dev Add a value to a set. O(1).
449      *
450      * Returns true if the value was added to the set, that is if it was not
451      * already present.
452      */
453     function add(UintSet storage set, uint256 value) internal returns (bool) {
454         return _add(set._inner, bytes32(value));
455     }
456 
457     /**
458      * @dev Removes a value from a set. O(1).
459      *
460      * Returns true if the value was removed from the set, that is if it was
461      * present.
462      */
463     function remove(UintSet storage set, uint256 value) internal returns (bool) {
464         return _remove(set._inner, bytes32(value));
465     }
466 
467     /**
468      * @dev Returns true if the value is in the set. O(1).
469      */
470     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
471         return _contains(set._inner, bytes32(value));
472     }
473 
474     /**
475      * @dev Returns the number of values on the set. O(1).
476      */
477     function length(UintSet storage set) internal view returns (uint256) {
478         return _length(set._inner);
479     }
480 
481     /**
482      * @dev Returns the value stored at position `index` in the set. O(1).
483      *
484      * Note that there are no guarantees on the ordering of values inside the
485      * array, and it may change when more values are added or removed.
486      *
487      * Requirements:
488      *
489      * - `index` must be strictly less than {length}.
490      */
491     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
492         return uint256(_at(set._inner, index));
493     }
494 
495     /**
496      * @dev Return the entire set in an array
497      *
498      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
499      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
500      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
501      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
502      */
503     function values(UintSet storage set) internal view returns (uint256[] memory) {
504         bytes32[] memory store = _values(set._inner);
505         uint256[] memory result;
506 
507         assembly {
508             result := store
509         }
510 
511         return result;
512     }
513 }
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Required interface of an ERC721 compliant contract.
519  */
520 interface IERC721 is IERC165 {
521     /**
522      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
523      */
524     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
528      */
529     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
530 
531     /**
532      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
533      */
534     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
535 
536     /**
537      * @dev Returns the number of tokens in ``owner``'s account.
538      */
539     function balanceOf(address owner) external view returns (uint256 balance);
540 
541     /**
542      * @dev Returns the owner of the `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function ownerOf(uint256 tokenId) external view returns (address owner);
549 
550     /**
551      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
552      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must exist and be owned by `from`.
559      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
561      *
562      * Emits a {Transfer} event.
563      */
564     function safeTransferFrom(
565         address from,
566         address to,
567         uint256 tokenId
568     ) external;
569 
570     /**
571      * @dev Transfers `tokenId` token from `from` to `to`.
572      *
573      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      *
582      * Emits a {Transfer} event.
583      */
584     function transferFrom(
585         address from,
586         address to,
587         uint256 tokenId
588     ) external;
589 
590     /**
591      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
592      * The approval is cleared when the token is transferred.
593      *
594      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
595      *
596      * Requirements:
597      *
598      * - The caller must own the token or be an approved operator.
599      * - `tokenId` must exist.
600      *
601      * Emits an {Approval} event.
602      */
603     function approve(address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Returns the account approved for `tokenId` token.
607      *
608      * Requirements:
609      *
610      * - `tokenId` must exist.
611      */
612     function getApproved(uint256 tokenId) external view returns (address operator);
613 
614     /**
615      * @dev Approve or remove `operator` as an operator for the caller.
616      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
617      *
618      * Requirements:
619      *
620      * - The `operator` cannot be the caller.
621      *
622      * Emits an {ApprovalForAll} event.
623      */
624     function setApprovalForAll(address operator, bool _approved) external;
625 
626     /**
627      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
628      *
629      * See {setApprovalForAll}
630      */
631     function isApprovedForAll(address owner, address operator) external view returns (bool);
632 
633     /**
634      * @dev Safely transfers `tokenId` token from `from` to `to`.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must exist and be owned by `from`.
641      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
643      *
644      * Emits a {Transfer} event.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId,
650         bytes calldata data
651     ) external;
652 }
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Enumerable is IERC721 {
661     /**
662      * @dev Returns the total amount of tokens stored by the contract.
663      */
664     function totalSupply() external view returns (uint256);
665 
666     /**
667      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
668      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
669      */
670     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
671 
672     /**
673      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
674      * Use along with {totalSupply} to enumerate all tokens.
675      */
676     function tokenByIndex(uint256 index) external view returns (uint256);
677 }
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @title ERC721 token receiver interface
683  * @dev Interface for any contract that wants to support safeTransfers
684  * from ERC721 asset contracts.
685  */
686 interface IERC721Receiver {
687     /**
688      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
689      * by `operator` from `from`, this function is called.
690      *
691      * It must return its Solidity selector to confirm the token transfer.
692      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
693      *
694      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
695      */
696     function onERC721Received(
697         address operator,
698         address from,
699         uint256 tokenId,
700         bytes calldata data
701     ) external returns (bytes4);
702 }
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
708  * @dev See https://eips.ethereum.org/EIPS/eip-721
709  */
710 interface IERC721Metadata is IERC721 {
711     /**
712      * @dev Returns the token collection name.
713      */
714     function name() external view returns (string memory);
715 
716     /**
717      * @dev Returns the token collection symbol.
718      */
719     function symbol() external view returns (string memory);
720 
721     /**
722      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
723      */
724     function tokenURI(uint256 tokenId) external view returns (string memory);
725 }
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @dev Collection of functions related to the address type
731  */
732 library Address {
733     /**
734      * @dev Returns true if `account` is a contract.
735      *
736      * [IMPORTANT]
737      * ====
738      * It is unsafe to assume that an address for which this function returns
739      * false is an externally-owned account (EOA) and not a contract.
740      *
741      * Among others, `isContract` will return false for the following
742      * types of addresses:
743      *
744      *  - an externally-owned account
745      *  - a contract in construction
746      *  - an address where a contract will be created
747      *  - an address where a contract lived, but was destroyed
748      * ====
749      */
750     function isContract(address account) internal view returns (bool) {
751         // This method relies on extcodesize, which returns 0 for contracts in
752         // construction, since the code is only stored at the end of the
753         // constructor execution.
754 
755         uint256 size;
756         assembly {
757             size := extcodesize(account)
758         }
759         return size > 0;
760     }
761 
762     /**
763      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
764      * `recipient`, forwarding all available gas and reverting on errors.
765      *
766      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
767      * of certain opcodes, possibly making contracts go over the 2300 gas limit
768      * imposed by `transfer`, making them unable to receive funds via
769      * `transfer`. {sendValue} removes this limitation.
770      *
771      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
772      *
773      * IMPORTANT: because control is transferred to `recipient`, care must be
774      * taken to not create reentrancy vulnerabilities. Consider using
775      * {ReentrancyGuard} or the
776      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
777      */
778     function sendValue(address payable recipient, uint256 amount) internal {
779         require(address(this).balance >= amount, "Address: insufficient balance");
780 
781         (bool success, ) = recipient.call{value: amount}("");
782         require(success, "Address: unable to send value, recipient may have reverted");
783     }
784 
785     /**
786      * @dev Performs a Solidity function call using a low level `call`. A
787      * plain `call` is an unsafe replacement for a function call: use this
788      * function instead.
789      *
790      * If `target` reverts with a revert reason, it is bubbled up by this
791      * function (like regular Solidity function calls).
792      *
793      * Returns the raw returned data. To convert to the expected return value,
794      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
795      *
796      * Requirements:
797      *
798      * - `target` must be a contract.
799      * - calling `target` with `data` must not revert.
800      *
801      * _Available since v3.1._
802      */
803     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
804         return functionCall(target, data, "Address: low-level call failed");
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
809      * `errorMessage` as a fallback revert reason when `target` reverts.
810      *
811      * _Available since v3.1._
812      */
813     function functionCall(
814         address target,
815         bytes memory data,
816         string memory errorMessage
817     ) internal returns (bytes memory) {
818         return functionCallWithValue(target, data, 0, errorMessage);
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
823      * but also transferring `value` wei to `target`.
824      *
825      * Requirements:
826      *
827      * - the calling contract must have an ETH balance of at least `value`.
828      * - the called Solidity function must be `payable`.
829      *
830      * _Available since v3.1._
831      */
832     function functionCallWithValue(
833         address target,
834         bytes memory data,
835         uint256 value
836     ) internal returns (bytes memory) {
837         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
842      * with `errorMessage` as a fallback revert reason when `target` reverts.
843      *
844      * _Available since v3.1._
845      */
846     function functionCallWithValue(
847         address target,
848         bytes memory data,
849         uint256 value,
850         string memory errorMessage
851     ) internal returns (bytes memory) {
852         require(address(this).balance >= value, "Address: insufficient balance for call");
853         require(isContract(target), "Address: call to non-contract");
854 
855         (bool success, bytes memory returndata) = target.call{value: value}(data);
856         return verifyCallResult(success, returndata, errorMessage);
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
861      * but performing a static call.
862      *
863      * _Available since v3.3._
864      */
865     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
866         return functionStaticCall(target, data, "Address: low-level static call failed");
867     }
868 
869     /**
870      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
871      * but performing a static call.
872      *
873      * _Available since v3.3._
874      */
875     function functionStaticCall(
876         address target,
877         bytes memory data,
878         string memory errorMessage
879     ) internal view returns (bytes memory) {
880         require(isContract(target), "Address: static call to non-contract");
881 
882         (bool success, bytes memory returndata) = target.staticcall(data);
883         return verifyCallResult(success, returndata, errorMessage);
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
888      * but performing a delegate call.
889      *
890      * _Available since v3.4._
891      */
892     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
893         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
894     }
895 
896     /**
897      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
898      * but performing a delegate call.
899      *
900      * _Available since v3.4._
901      */
902     function functionDelegateCall(
903         address target,
904         bytes memory data,
905         string memory errorMessage
906     ) internal returns (bytes memory) {
907         require(isContract(target), "Address: delegate call to non-contract");
908 
909         (bool success, bytes memory returndata) = target.delegatecall(data);
910         return verifyCallResult(success, returndata, errorMessage);
911     }
912 
913     /**
914      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
915      * revert reason using the provided one.
916      *
917      * _Available since v4.3._
918      */
919     function verifyCallResult(
920         bool success,
921         bytes memory returndata,
922         string memory errorMessage
923     ) internal pure returns (bytes memory) {
924         if (success) {
925             return returndata;
926         } else {
927             // Look for revert reason and bubble it up if present
928             if (returndata.length > 0) {
929                 // The easiest way to bubble the revert reason is using memory via assembly
930 
931                 assembly {
932                     let returndata_size := mload(returndata)
933                     revert(add(32, returndata), returndata_size)
934                 }
935             } else {
936                 revert(errorMessage);
937             }
938         }
939     }
940 }
941 
942 pragma solidity ^0.8.0;
943 
944 /**
945  * @dev Provides information about the current execution context, including the
946  * sender of the transaction and its data. While these are generally available
947  * via msg.sender and msg.data, they should not be accessed in such a direct
948  * manner, since when dealing with meta-transactions the account sending and
949  * paying for execution may not be the actual sender (as far as an application
950  * is concerned).
951  *
952  * This contract is only required for intermediate, library-like contracts.
953  */
954 abstract contract Context {
955     function _msgSender() internal view virtual returns (address) {
956         return msg.sender;
957     }
958 
959     function _msgData() internal view virtual returns (bytes calldata) {
960         return msg.data;
961     }
962 }
963 
964 pragma solidity ^0.8.0;
965 
966 /**
967  * @dev String operations.
968  */
969 library Strings {
970     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
971 
972     /**
973      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
974      */
975     function toString(uint256 value) internal pure returns (string memory) {
976         // Inspired by OraclizeAPI's implementation - MIT licence
977         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
978 
979         if (value == 0) {
980             return "0";
981         }
982         uint256 temp = value;
983         uint256 digits;
984         while (temp != 0) {
985             digits++;
986             temp /= 10;
987         }
988         bytes memory buffer = new bytes(digits);
989         while (value != 0) {
990             digits -= 1;
991             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
992             value /= 10;
993         }
994         return string(buffer);
995     }
996 
997     /**
998      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
999      */
1000     function toHexString(uint256 value) internal pure returns (string memory) {
1001         if (value == 0) {
1002             return "0x00";
1003         }
1004         uint256 temp = value;
1005         uint256 length = 0;
1006         while (temp != 0) {
1007             length++;
1008             temp >>= 8;
1009         }
1010         return toHexString(value, length);
1011     }
1012 
1013     /**
1014      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1015      */
1016     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1017         bytes memory buffer = new bytes(2 * length + 2);
1018         buffer[0] = "0";
1019         buffer[1] = "x";
1020         for (uint256 i = 2 * length + 1; i > 1; --i) {
1021             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1022             value >>= 4;
1023         }
1024         require(value == 0, "Strings: hex length insufficient");
1025         return string(buffer);
1026     }
1027 }
1028 
1029 pragma solidity ^0.8.0;
1030 
1031 /**
1032  * @dev Implementation of the {IERC165} interface.
1033  *
1034  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1035  * for the additional interface id that will be supported. For example:
1036  *
1037  * ```solidity
1038  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1039  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1040  * }
1041  * ```
1042  *
1043  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1044  */
1045 abstract contract ERC165 is IERC165 {
1046     /**
1047      * @dev See {IERC165-supportsInterface}.
1048      */
1049     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1050         return interfaceId == type(IERC165).interfaceId;
1051     }
1052 }
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 /**
1057  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1058  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1059  * {ERC721Enumerable}.
1060  */
1061 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1062     using Address for address;
1063     using Strings for uint256;
1064 
1065     // Token name
1066     string private _name;
1067 
1068     // Token symbol
1069     string private _symbol;
1070 
1071     // Mapping from token ID to owner address
1072     mapping(uint256 => address) private _owners;
1073 
1074     // Mapping owner address to token count
1075     mapping(address => uint256) private _balances;
1076 
1077     // Mapping from token ID to approved address
1078     mapping(uint256 => address) private _tokenApprovals;
1079 
1080     // Mapping from owner to operator approvals
1081     mapping(address => mapping(address => bool)) private _operatorApprovals;
1082 
1083     /**
1084      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1085      */
1086     constructor(string memory name_, string memory symbol_) {
1087         _name = name_;
1088         _symbol = symbol_;
1089     }
1090 
1091     /**
1092      * @dev See {IERC165-supportsInterface}.
1093      */
1094     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1095         return
1096             interfaceId == type(IERC721).interfaceId ||
1097             interfaceId == type(IERC721Metadata).interfaceId ||
1098             super.supportsInterface(interfaceId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-balanceOf}.
1103      */
1104     function balanceOf(address owner) public view virtual override returns (uint256) {
1105         require(owner != address(0), "ERC721: balance query for the zero address");
1106         return _balances[owner];
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-ownerOf}.
1111      */
1112     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1113         address owner = _owners[tokenId];
1114         require(owner != address(0), "ERC721: owner query for nonexistent token");
1115         return owner;
1116     }
1117 
1118     /**
1119      * @dev See {IERC721Metadata-name}.
1120      */
1121     function name() public view virtual override returns (string memory) {
1122         return _name;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Metadata-symbol}.
1127      */
1128     function symbol() public view virtual override returns (string memory) {
1129         return _symbol;
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Metadata-tokenURI}.
1134      */
1135     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1136         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1137 
1138         string memory baseURI = _baseURI();
1139         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1140     }
1141 
1142     /**
1143      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1144      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1145      * by default, can be overriden in child contracts.
1146      */
1147     function _baseURI() internal view virtual returns (string memory) {
1148         return "";
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-approve}.
1153      */
1154     function approve(address to, uint256 tokenId) public virtual override {
1155         address owner = ERC721.ownerOf(tokenId);
1156         require(to != owner, "ERC721: approval to current owner");
1157 
1158         require(
1159             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1160             "ERC721: approve caller is not owner nor approved for all"
1161         );
1162 
1163         _approve(to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-getApproved}.
1168      */
1169     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1170         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1171 
1172         return _tokenApprovals[tokenId];
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-setApprovalForAll}.
1177      */
1178     function setApprovalForAll(address operator, bool approved) public virtual override {
1179         _setApprovalForAll(_msgSender(), operator, approved);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-isApprovedForAll}.
1184      */
1185     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1186         return _operatorApprovals[owner][operator];
1187     }
1188 
1189     /**
1190      * @dev See {IERC721-transferFrom}.
1191      */
1192     function transferFrom(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) public virtual override {
1197         //solhint-disable-next-line max-line-length
1198         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1199 
1200         _transfer(from, to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-safeTransferFrom}.
1205      */
1206     function safeTransferFrom(
1207         address from,
1208         address to,
1209         uint256 tokenId
1210     ) public virtual override {
1211         safeTransferFrom(from, to, tokenId, "");
1212     }
1213 
1214     /**
1215      * @dev See {IERC721-safeTransferFrom}.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId,
1221         bytes memory _data
1222     ) public virtual override {
1223         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1224         _safeTransfer(from, to, tokenId, _data);
1225     }
1226 
1227     /**
1228      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1229      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1230      *
1231      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1232      *
1233      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1234      * implement alternative mechanisms to perform token transfer, such as signature-based.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must exist and be owned by `from`.
1241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _safeTransfer(
1246         address from,
1247         address to,
1248         uint256 tokenId,
1249         bytes memory _data
1250     ) internal virtual {
1251         _transfer(from, to, tokenId);
1252         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1253     }
1254 
1255     /**
1256      * @dev Returns whether `tokenId` exists.
1257      *
1258      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1259      *
1260      * Tokens start existing when they are minted (`_mint`),
1261      * and stop existing when they are burned (`_burn`).
1262      */
1263     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1264         return _owners[tokenId] != address(0);
1265     }
1266 
1267     /**
1268      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      */
1274     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1275         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1276         address owner = ERC721.ownerOf(tokenId);
1277         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1278     }
1279 
1280     /**
1281      * @dev Safely mints `tokenId` and transfers it to `to`.
1282      *
1283      * Requirements:
1284      *
1285      * - `tokenId` must not exist.
1286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _safeMint(address to, uint256 tokenId) internal virtual {
1291         _safeMint(to, tokenId, "");
1292     }
1293 
1294     /**
1295      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1296      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1297      */
1298     function _safeMint(
1299         address to,
1300         uint256 tokenId,
1301         bytes memory _data
1302     ) internal virtual {
1303         _mint(to, tokenId);
1304         require(
1305             _checkOnERC721Received(address(0), to, tokenId, _data),
1306             "ERC721: transfer to non ERC721Receiver implementer"
1307         );
1308     }
1309 
1310     /**
1311      * @dev Mints `tokenId` and transfers it to `to`.
1312      *
1313      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must not exist.
1318      * - `to` cannot be the zero address.
1319      *
1320      * Emits a {Transfer} event.
1321      */
1322     function _mint(address to, uint256 tokenId) internal virtual {
1323         require(to != address(0), "ERC721: mint to the zero address");
1324         require(!_exists(tokenId), "ERC721: token already minted");
1325 
1326         _beforeTokenTransfer(address(0), to, tokenId);
1327 
1328         _balances[to] += 1;
1329         _owners[tokenId] = to;
1330 
1331         emit Transfer(address(0), to, tokenId);
1332     }
1333 
1334     /**
1335      * @dev Destroys `tokenId`.
1336      * The approval is cleared when the token is burned.
1337      *
1338      * Requirements:
1339      *
1340      * - `tokenId` must exist.
1341      *
1342      * Emits a {Transfer} event.
1343      */
1344     function _burn(uint256 tokenId) internal virtual {
1345         address owner = ERC721.ownerOf(tokenId);
1346 
1347         _beforeTokenTransfer(owner, address(0), tokenId);
1348 
1349         // Clear approvals
1350         _approve(address(0), tokenId);
1351 
1352         _balances[owner] -= 1;
1353         delete _owners[tokenId];
1354 
1355         emit Transfer(owner, address(0), tokenId);
1356     }
1357 
1358     /**
1359      * @dev Transfers `tokenId` from `from` to `to`.
1360      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1361      *
1362      * Requirements:
1363      *
1364      * - `to` cannot be the zero address.
1365      * - `tokenId` token must be owned by `from`.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _transfer(
1370         address from,
1371         address to,
1372         uint256 tokenId
1373     ) internal virtual {
1374         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1375         require(to != address(0), "ERC721: transfer to the zero address");
1376 
1377         _beforeTokenTransfer(from, to, tokenId);
1378 
1379         // Clear approvals from the previous owner
1380         _approve(address(0), tokenId);
1381 
1382         _balances[from] -= 1;
1383         _balances[to] += 1;
1384         _owners[tokenId] = to;
1385 
1386         emit Transfer(from, to, tokenId);
1387     }
1388 
1389     /**
1390      * @dev Approve `to` to operate on `tokenId`
1391      *
1392      * Emits a {Approval} event.
1393      */
1394     function _approve(address to, uint256 tokenId) internal virtual {
1395         _tokenApprovals[tokenId] = to;
1396         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1397     }
1398 
1399     /**
1400      * @dev Approve `operator` to operate on all of `owner` tokens
1401      *
1402      * Emits a {ApprovalForAll} event.
1403      */
1404     function _setApprovalForAll(
1405         address owner,
1406         address operator,
1407         bool approved
1408     ) internal virtual {
1409         require(owner != operator, "ERC721: approve to caller");
1410         _operatorApprovals[owner][operator] = approved;
1411         emit ApprovalForAll(owner, operator, approved);
1412     }
1413 
1414     /**
1415      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1416      * The call is not executed if the target address is not a contract.
1417      *
1418      * @param from address representing the previous owner of the given token ID
1419      * @param to target address that will receive the tokens
1420      * @param tokenId uint256 ID of the token to be transferred
1421      * @param _data bytes optional data to send along with the call
1422      * @return bool whether the call correctly returned the expected magic value
1423      */
1424     function _checkOnERC721Received(
1425         address from,
1426         address to,
1427         uint256 tokenId,
1428         bytes memory _data
1429     ) private returns (bool) {
1430         if (to.isContract()) {
1431             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1432                 return retval == IERC721Receiver.onERC721Received.selector;
1433             } catch (bytes memory reason) {
1434                 if (reason.length == 0) {
1435                     revert("ERC721: transfer to non ERC721Receiver implementer");
1436                 } else {
1437                     assembly {
1438                         revert(add(32, reason), mload(reason))
1439                     }
1440                 }
1441             }
1442         } else {
1443             return true;
1444         }
1445     }
1446 
1447     /**
1448      * @dev Hook that is called before any token transfer. This includes minting
1449      * and burning.
1450      *
1451      * Calling conditions:
1452      *
1453      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1454      * transferred to `to`.
1455      * - When `from` is zero, `tokenId` will be minted for `to`.
1456      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1457      * - `from` and `to` are never both zero.
1458      *
1459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1460      */
1461     function _beforeTokenTransfer(
1462         address from,
1463         address to,
1464         uint256 tokenId
1465     ) internal virtual {}
1466 }
1467 
1468 
1469 
1470 
1471 
1472 pragma solidity ^0.8.0;
1473 
1474 
1475 
1476 /**
1477  * @dev Contract module that allows children to implement role-based access
1478  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1479  * members except through off-chain means by accessing the contract event logs. Some
1480  * applications may benefit from on-chain enumerability, for those cases see
1481  * {AccessControlEnumerable}.
1482  *
1483  * Roles are referred to by their `bytes32` identifier. These should be exposed
1484  * in the external API and be unique. The best way to achieve this is by
1485  * using `public constant` hash digests:
1486  *
1487  * ```
1488  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1489  * ```
1490  *
1491  * Roles can be used to represent a set of permissions. To restrict access to a
1492  * function call, use {hasRole}:
1493  *
1494  * ```
1495  * function foo() public {
1496  *     require(hasRole(MY_ROLE, msg.sender));
1497  *     ...
1498  * }
1499  * ```
1500  *
1501  * Roles can be granted and revoked dynamically via the {grantRole} and
1502  * {revokeRole} functions. Each role has an associated admin role, and only
1503  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1504  *
1505  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1506  * that only accounts with this role will be able to grant or revoke other
1507  * roles. More complex role relationships can be created by using
1508  * {_setRoleAdmin}.
1509  *
1510  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1511  * grant and revoke this role. Extra precautions should be taken to secure
1512  * accounts that have been granted it.
1513  */
1514 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1515     struct RoleData {
1516         mapping(address => bool) members;
1517         bytes32 adminRole;
1518     }
1519 
1520     mapping(bytes32 => RoleData) private _roles;
1521 
1522     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1523 
1524     /**
1525      * @dev Modifier that checks that an account has a specific role. Reverts
1526      * with a standardized message including the required role.
1527      *
1528      * The format of the revert reason is given by the following regular expression:
1529      *
1530      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1531      *
1532      * _Available since v4.1._
1533      */
1534     modifier onlyRole(bytes32 role) {
1535         _checkRole(role, _msgSender());
1536         _;
1537     }
1538 
1539     /**
1540      * @dev See {IERC165-supportsInterface}.
1541      */
1542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1543         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1544     }
1545 
1546     /**
1547      * @dev Returns `true` if `account` has been granted `role`.
1548      */
1549     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1550         return _roles[role].members[account];
1551     }
1552 
1553     /**
1554      * @dev Revert with a standard message if `account` is missing `role`.
1555      *
1556      * The format of the revert reason is given by the following regular expression:
1557      *
1558      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1559      */
1560     function _checkRole(bytes32 role, address account) internal view virtual {
1561         if (!hasRole(role, account)) {
1562             revert(
1563                 string(
1564                     abi.encodePacked(
1565                         "AccessControl: account ",
1566                         Strings.toHexString(uint160(account), 20),
1567                         " is missing role ",
1568                         Strings.toHexString(uint256(role), 32)
1569                     )
1570                 )
1571             );
1572         }
1573     }
1574 
1575     /**
1576      * @dev Returns the admin role that controls `role`. See {grantRole} and
1577      * {revokeRole}.
1578      *
1579      * To change a role's admin, use {_setRoleAdmin}.
1580      */
1581     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1582         return _roles[role].adminRole;
1583     }
1584 
1585     /**
1586      * @dev Grants `role` to `account`.
1587      *
1588      * If `account` had not been already granted `role`, emits a {RoleGranted}
1589      * event.
1590      *
1591      * Requirements:
1592      *
1593      * - the caller must have ``role``'s admin role.
1594      */
1595     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1596         _grantRole(role, account);
1597     }
1598 
1599     /**
1600      * @dev Revokes `role` from `account`.
1601      *
1602      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1603      *
1604      * Requirements:
1605      *
1606      * - the caller must have ``role``'s admin role.
1607      */
1608     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1609         _revokeRole(role, account);
1610     }
1611 
1612     /**
1613      * @dev Revokes `role` from the calling account.
1614      *
1615      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1616      * purpose is to provide a mechanism for accounts to lose their privileges
1617      * if they are compromised (such as when a trusted device is misplaced).
1618      *
1619      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1620      * event.
1621      *
1622      * Requirements:
1623      *
1624      * - the caller must be `account`.
1625      */
1626     function renounceRole(bytes32 role, address account) public virtual override {
1627         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1628 
1629         _revokeRole(role, account);
1630     }
1631 
1632     /**
1633      * @dev Grants `role` to `account`.
1634      *
1635      * If `account` had not been already granted `role`, emits a {RoleGranted}
1636      * event. Note that unlike {grantRole}, this function doesn't perform any
1637      * checks on the calling account.
1638      *
1639      * [WARNING]
1640      * ====
1641      * This function should only be called from the constructor when setting
1642      * up the initial roles for the system.
1643      *
1644      * Using this function in any other way is effectively circumventing the admin
1645      * system imposed by {AccessControl}.
1646      * ====
1647      *
1648      * NOTE: This function is deprecated in favor of {_grantRole}.
1649      */
1650     function _setupRole(bytes32 role, address account) internal virtual {
1651         _grantRole(role, account);
1652     }
1653 
1654     /**
1655      * @dev Sets `adminRole` as ``role``'s admin role.
1656      *
1657      * Emits a {RoleAdminChanged} event.
1658      */
1659     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1660         bytes32 previousAdminRole = getRoleAdmin(role);
1661         _roles[role].adminRole = adminRole;
1662         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1663     }
1664 
1665     /**
1666      * @dev Grants `role` to `account`.
1667      *
1668      * Internal function without access restriction.
1669      */
1670     function _grantRole(bytes32 role, address account) internal virtual {
1671         if (!hasRole(role, account)) {
1672             _roles[role].members[account] = true;
1673             emit RoleGranted(role, account, _msgSender());
1674         }
1675     }
1676 
1677     /**
1678      * @dev Revokes `role` from `account`.
1679      *
1680      * Internal function without access restriction.
1681      */
1682     function _revokeRole(bytes32 role, address account) internal virtual {
1683         if (hasRole(role, account)) {
1684             _roles[role].members[account] = false;
1685             emit RoleRevoked(role, account, _msgSender());
1686         }
1687     }
1688 }
1689 
1690 
1691 pragma solidity ^0.8.0;
1692 
1693 
1694 /**
1695  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1696  * enumerability of all the token ids in the contract as well as all token ids owned by each
1697  * account.
1698  */
1699 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1700     // Mapping from owner to list of owned token IDs
1701     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1702 
1703     // Mapping from token ID to index of the owner tokens list
1704     mapping(uint256 => uint256) private _ownedTokensIndex;
1705 
1706     // Array with all token ids, used for enumeration
1707     uint256[] private _allTokens;
1708 
1709     // Mapping from token id to position in the allTokens array
1710     mapping(uint256 => uint256) private _allTokensIndex;
1711 
1712     /**
1713      * @dev See {IERC165-supportsInterface}.
1714      */
1715     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1716         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1717     }
1718 
1719     /**
1720      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1721      */
1722     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1723         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1724         return _ownedTokens[owner][index];
1725     }
1726 
1727     /**
1728      * @dev See {IERC721Enumerable-totalSupply}.
1729      */
1730     function totalSupply() public view virtual override returns (uint256) {
1731         return _allTokens.length;
1732     }
1733 
1734     /**
1735      * @dev See {IERC721Enumerable-tokenByIndex}.
1736      */
1737     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1738         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1739         return _allTokens[index];
1740     }
1741 
1742     /**
1743      * @dev Hook that is called before any token transfer. This includes minting
1744      * and burning.
1745      *
1746      * Calling conditions:
1747      *
1748      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1749      * transferred to `to`.
1750      * - When `from` is zero, `tokenId` will be minted for `to`.
1751      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1752      * - `from` cannot be the zero address.
1753      * - `to` cannot be the zero address.
1754      *
1755      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1756      */
1757     function _beforeTokenTransfer(
1758         address from,
1759         address to,
1760         uint256 tokenId
1761     ) internal virtual override {
1762         super._beforeTokenTransfer(from, to, tokenId);
1763 
1764         if (from == address(0)) {
1765             _addTokenToAllTokensEnumeration(tokenId);
1766         } else if (from != to) {
1767             _removeTokenFromOwnerEnumeration(from, tokenId);
1768         }
1769         if (to == address(0)) {
1770             _removeTokenFromAllTokensEnumeration(tokenId);
1771         } else if (to != from) {
1772             _addTokenToOwnerEnumeration(to, tokenId);
1773         }
1774     }
1775 
1776     /**
1777      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1778      * @param to address representing the new owner of the given token ID
1779      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1780      */
1781     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1782         uint256 length = ERC721.balanceOf(to);
1783         _ownedTokens[to][length] = tokenId;
1784         _ownedTokensIndex[tokenId] = length;
1785     }
1786 
1787     /**
1788      * @dev Private function to add a token to this extension's token tracking data structures.
1789      * @param tokenId uint256 ID of the token to be added to the tokens list
1790      */
1791     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1792         _allTokensIndex[tokenId] = _allTokens.length;
1793         _allTokens.push(tokenId);
1794     }
1795 
1796     /**
1797      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1798      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1799      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1800      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1801      * @param from address representing the previous owner of the given token ID
1802      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1803      */
1804     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1805         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1806         // then delete the last slot (swap and pop).
1807 
1808         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1809         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1810 
1811         // When the token to delete is the last token, the swap operation is unnecessary
1812         if (tokenIndex != lastTokenIndex) {
1813             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1814 
1815             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1816             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1817         }
1818 
1819         // This also deletes the contents at the last position of the array
1820         delete _ownedTokensIndex[tokenId];
1821         delete _ownedTokens[from][lastTokenIndex];
1822     }
1823 
1824     /**
1825      * @dev Private function to remove a token from this extension's token tracking data structures.
1826      * This has O(1) time complexity, but alters the order of the _allTokens array.
1827      * @param tokenId uint256 ID of the token to be removed from the tokens list
1828      */
1829     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1830         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1831         // then delete the last slot (swap and pop).
1832 
1833         uint256 lastTokenIndex = _allTokens.length - 1;
1834         uint256 tokenIndex = _allTokensIndex[tokenId];
1835 
1836         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1837         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1838         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1839         uint256 lastTokenId = _allTokens[lastTokenIndex];
1840 
1841         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1842         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1843 
1844         // This also deletes the contents at the last position of the array
1845         delete _allTokensIndex[tokenId];
1846         _allTokens.pop();
1847     }
1848 }
1849 
1850 
1851 pragma solidity ^0.8.0;
1852 
1853 
1854 /**
1855  * @dev Contract module which provides a basic access control mechanism, where
1856  * there is an account (an owner) that can be granted exclusive access to
1857  * specific functions.
1858  *
1859  * By default, the owner account will be the one that deploys the contract. This
1860  * can later be changed with {transferOwnership}.
1861  *
1862  * This module is used through inheritance. It will make available the modifier
1863  * `onlyOwner`, which can be applied to your functions to restrict their use to
1864  * the owner.
1865  */
1866 abstract contract Ownable is Context {
1867     address private _owner;
1868 
1869     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1870 
1871     /**
1872      * @dev Initializes the contract setting the deployer as the initial owner.
1873      */
1874     constructor() {
1875         _transferOwnership(_msgSender());
1876     }
1877 
1878     /**
1879      * @dev Returns the address of the current owner.
1880      */
1881     function owner() public view virtual returns (address) {
1882         return _owner;
1883     }
1884 
1885     /**
1886      * @dev Throws if called by any account other than the owner.
1887      */
1888     modifier onlyOwner() {
1889         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1890         _;
1891     }
1892 
1893     /**
1894      * @dev Leaves the contract without owner. It will not be possible to call
1895      * `onlyOwner` functions anymore. Can only be called by the current owner.
1896      *
1897      * NOTE: Renouncing ownership will leave the contract without an owner,
1898      * thereby removing any functionality that is only available to the owner.
1899      */
1900     function renounceOwnership() public virtual onlyOwner {
1901         _transferOwnership(address(0));
1902     }
1903 
1904     /**
1905      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1906      * Can only be called by the current owner.
1907      */
1908     function transferOwnership(address newOwner) public virtual onlyOwner {
1909         require(newOwner != address(0), "Ownable: new owner is the zero address");
1910         _transferOwnership(newOwner);
1911     }
1912 
1913     /**
1914      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1915      * Internal function without access restriction.
1916      */
1917     function _transferOwnership(address newOwner) internal virtual {
1918         address oldOwner = _owner;
1919         _owner = newOwner;
1920         emit OwnershipTransferred(oldOwner, newOwner);
1921     }
1922 }
1923 
1924 
1925 pragma solidity ^0.8.0;
1926 
1927 
1928 
1929 /**
1930  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1931  */
1932 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1933     using EnumerableSet for EnumerableSet.AddressSet;
1934 
1935     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1936 
1937     /**
1938      * @dev See {IERC165-supportsInterface}.
1939      */
1940     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1941         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1942     }
1943 
1944     /**
1945      * @dev Returns one of the accounts that have `role`. `index` must be a
1946      * value between 0 and {getRoleMemberCount}, non-inclusive.
1947      *
1948      * Role bearers are not sorted in any particular way, and their ordering may
1949      * change at any point.
1950      *
1951      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1952      * you perform all queries on the same block. See the following
1953      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1954      * for more information.
1955      */
1956     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1957         return _roleMembers[role].at(index);
1958     }
1959 
1960     /**
1961      * @dev Returns the number of accounts that have `role`. Can be used
1962      * together with {getRoleMember} to enumerate all bearers of a role.
1963      */
1964     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1965         return _roleMembers[role].length();
1966     }
1967 
1968     /**
1969      * @dev Overload {_grantRole} to track enumerable memberships
1970      */
1971     function _grantRole(bytes32 role, address account) internal virtual override {
1972         super._grantRole(role, account);
1973         _roleMembers[role].add(account);
1974     }
1975 
1976     /**
1977      * @dev Overload {_revokeRole} to track enumerable memberships
1978      */
1979     function _revokeRole(bytes32 role, address account) internal virtual override {
1980         super._revokeRole(role, account);
1981         _roleMembers[role].remove(account);
1982     }
1983 }
1984 
1985 
1986 pragma solidity ^0.8.0;
1987 
1988 /**
1989  * @dev Contract module that helps prevent reentrant calls to a function.
1990  *
1991  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1992  * available, which can be applied to functions to make sure there are no nested
1993  * (reentrant) calls to them.
1994  *
1995  * Note that because there is a single `nonReentrant` guard, functions marked as
1996  * `nonReentrant` may not call one another. This can be worked around by making
1997  * those functions `private`, and then adding `external` `nonReentrant` entry
1998  * points to them.
1999  *
2000  * TIP: If you would like to learn more about reentrancy and alternative ways
2001  * to protect against it, check out our blog post
2002  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2003  */
2004 abstract contract ReentrancyGuard {
2005     // Booleans are more expensive than uint256 or any type that takes up a full
2006     // word because each write operation emits an extra SLOAD to first read the
2007     // slot's contents, replace the bits taken up by the boolean, and then write
2008     // back. This is the compiler's defense against contract upgrades and
2009     // pointer aliasing, and it cannot be disabled.
2010 
2011     // The values being non-zero value makes deployment a bit more expensive,
2012     // but in exchange the refund on every call to nonReentrant will be lower in
2013     // amount. Since refunds are capped to a percentage of the total
2014     // transaction's gas, it is best to keep them low in cases like this one, to
2015     // increase the likelihood of the full refund coming into effect.
2016     uint256 private constant _NOT_ENTERED = 1;
2017     uint256 private constant _ENTERED = 2;
2018 
2019     uint256 private _status;
2020 
2021     constructor() {
2022         _status = _NOT_ENTERED;
2023     }
2024 
2025     /**
2026      * @dev Prevents a contract from calling itself, directly or indirectly.
2027      * Calling a `nonReentrant` function from another `nonReentrant`
2028      * function is not supported. It is possible to prevent this from happening
2029      * by making the `nonReentrant` function external, and making it call a
2030      * `private` function that does the actual work.
2031      */
2032     modifier nonReentrant() {
2033         // On the first call to nonReentrant, _notEntered will be true
2034         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2035 
2036         // Any calls to nonReentrant after this point will fail
2037         _status = _ENTERED;
2038 
2039         _;
2040 
2041         // By storing the original value once again, a refund is triggered (see
2042         // https://eips.ethereum.org/EIPS/eip-2200)
2043         _status = _NOT_ENTERED;
2044     }
2045 }
2046 
2047 
2048 
2049 
2050 
2051 pragma solidity ^0.8.4;
2052 
2053 
2054 error ApprovalCallerNotOwnerNorApproved();
2055 error ApprovalQueryForNonexistentToken();
2056 error ApproveToCaller();
2057 error ApprovalToCurrentOwner();
2058 error BalanceQueryForZeroAddress();
2059 error MintToZeroAddress();
2060 error MintZeroQuantity();
2061 error OwnerQueryForNonexistentToken();
2062 error TransferCallerNotOwnerNorApproved();
2063 error TransferFromIncorrectOwner();
2064 error TransferToNonERC721ReceiverImplementer();
2065 error TransferToZeroAddress();
2066 error URIQueryForNonexistentToken();
2067 
2068 /**
2069  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2070  * the Metadata extension. Built to optimize for lower gas during batch mints.
2071  *
2072  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2073  *
2074  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2075  *
2076  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2077  */
2078 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
2079     using Address for address;
2080     using Strings for uint256;
2081 
2082     // Compiler will pack this into a single 256bit word.
2083     struct TokenOwnership {
2084         // The address of the owner.
2085         address addr;
2086         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2087         uint64 startTimestamp;
2088         // Whether the token has been burned.
2089         bool burned;
2090     }
2091 
2092     // Compiler will pack this into a single 256bit word.
2093     struct AddressData {
2094         // Realistically, 2**64-1 is more than enough.
2095         uint64 balance;
2096         // Keeps track of mint count with minimal overhead for tokenomics.
2097         uint64 numberMinted;
2098         // Keeps track of burn count with minimal overhead for tokenomics.
2099         uint64 numberBurned;
2100         // For miscellaneous variable(s) pertaining to the address
2101         // (e.g. number of whitelist mint slots used).
2102         // If there are multiple variables, please pack them into a uint64.
2103         uint64 aux;
2104     }
2105 
2106     // The tokenId of the next token to be minted.
2107     uint256 internal _currentIndex;
2108 
2109     // The number of tokens burned.
2110     uint256 internal _burnCounter;
2111 
2112     // Token name
2113     string private _name;
2114 
2115     // Token symbol
2116     string private _symbol;
2117 
2118     // Mapping from token ID to ownership details
2119     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2120     mapping(uint256 => TokenOwnership) internal _ownerships;
2121 
2122     // Mapping owner address to address data
2123     mapping(address => AddressData) private _addressData;
2124 
2125     // Mapping from token ID to approved address
2126     mapping(uint256 => address) private _tokenApprovals;
2127 
2128     // Mapping from owner to operator approvals
2129     mapping(address => mapping(address => bool)) private _operatorApprovals;
2130 
2131     constructor(string memory name_, string memory symbol_) {
2132         _name = name_;
2133         _symbol = symbol_;
2134         _currentIndex = _startTokenId();
2135     }
2136 
2137     /**
2138      * To change the starting tokenId, please override this function.
2139      */
2140     function _startTokenId() internal view virtual returns (uint256) {
2141         return 0;
2142     }
2143 
2144     /**
2145      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2146      */
2147     function totalSupply() public view returns (uint256) {
2148         // Counter underflow is impossible as _burnCounter cannot be incremented
2149         // more than _currentIndex - _startTokenId() times
2150         unchecked {
2151             return _currentIndex - _burnCounter - _startTokenId();
2152         }
2153     }
2154 
2155     /**
2156      * Returns the total amount of tokens minted in the contract.
2157      */
2158     function _totalMinted() internal view returns (uint256) {
2159         // Counter underflow is impossible as _currentIndex does not decrement,
2160         // and it is initialized to _startTokenId()
2161         unchecked {
2162             return _currentIndex - _startTokenId();
2163         }
2164     }
2165 
2166     /**
2167      * @dev See {IERC165-supportsInterface}.
2168      */
2169     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2170         return
2171             interfaceId == type(IERC721).interfaceId ||
2172             interfaceId == type(IERC721Metadata).interfaceId ||
2173             super.supportsInterface(interfaceId);
2174     }
2175 
2176     /**
2177      * @dev See {IERC721-balanceOf}.
2178      */
2179     function balanceOf(address owner) public view override returns (uint256) {
2180         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2181         return uint256(_addressData[owner].balance);
2182     }
2183 
2184     /**
2185      * Returns the number of tokens minted by `owner`.
2186      */
2187     function _numberMinted(address owner) internal view returns (uint256) {
2188         return uint256(_addressData[owner].numberMinted);
2189     }
2190 
2191     /**
2192      * Returns the number of tokens burned by or on behalf of `owner`.
2193      */
2194     function _numberBurned(address owner) internal view returns (uint256) {
2195         return uint256(_addressData[owner].numberBurned);
2196     }
2197 
2198     /**
2199      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2200      */
2201     function _getAux(address owner) internal view returns (uint64) {
2202         return _addressData[owner].aux;
2203     }
2204 
2205     /**
2206      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2207      * If there are multiple variables, please pack them into a uint64.
2208      */
2209     function _setAux(address owner, uint64 aux) internal {
2210         _addressData[owner].aux = aux;
2211     }
2212 
2213     /**
2214      * Gas spent here starts off proportional to the maximum mint batch size.
2215      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2216      */
2217     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2218         uint256 curr = tokenId;
2219 
2220         unchecked {
2221             if (_startTokenId() <= curr && curr < _currentIndex) {
2222                 TokenOwnership memory ownership = _ownerships[curr];
2223                 if (!ownership.burned) {
2224                     if (ownership.addr != address(0)) {
2225                         return ownership;
2226                     }
2227                     // Invariant:
2228                     // There will always be an ownership that has an address and is not burned
2229                     // before an ownership that does not have an address and is not burned.
2230                     // Hence, curr will not underflow.
2231                     while (true) {
2232                         curr--;
2233                         ownership = _ownerships[curr];
2234                         if (ownership.addr != address(0)) {
2235                             return ownership;
2236                         }
2237                     }
2238                 }
2239             }
2240         }
2241         revert OwnerQueryForNonexistentToken();
2242     }
2243 
2244     /**
2245      * @dev See {IERC721-ownerOf}.
2246      */
2247     function ownerOf(uint256 tokenId) public view override returns (address) {
2248         return _ownershipOf(tokenId).addr;
2249     }
2250 
2251     /**
2252      * @dev See {IERC721Metadata-name}.
2253      */
2254     function name() public view virtual override returns (string memory) {
2255         return _name;
2256     }
2257 
2258     /**
2259      * @dev See {IERC721Metadata-symbol}.
2260      */
2261     function symbol() public view virtual override returns (string memory) {
2262         return _symbol;
2263     }
2264 
2265     /**
2266      * @dev See {IERC721Metadata-tokenURI}.
2267      */
2268     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2269         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2270 
2271         string memory baseURI = _baseURI();
2272         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
2273     }
2274 
2275     /**
2276      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2277      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2278      * by default, can be overriden in child contracts.
2279      */
2280     function _baseURI() internal view virtual returns (string memory) {
2281         return '';
2282     }
2283 
2284     /**
2285      * @dev See {IERC721-approve}.
2286      */
2287     function approve(address to, uint256 tokenId) public override {
2288         address owner = ERC721A.ownerOf(tokenId);
2289         if (to == owner) revert ApprovalToCurrentOwner();
2290 
2291         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2292             revert ApprovalCallerNotOwnerNorApproved();
2293         }
2294 
2295         _approve(to, tokenId, owner);
2296     }
2297 
2298     /**
2299      * @dev See {IERC721-getApproved}.
2300      */
2301     function getApproved(uint256 tokenId) public view override returns (address) {
2302         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2303 
2304         return _tokenApprovals[tokenId];
2305     }
2306 
2307     /**
2308      * @dev See {IERC721-setApprovalForAll}.
2309      */
2310     function setApprovalForAll(address operator, bool approved) public virtual override {
2311         if (operator == _msgSender()) revert ApproveToCaller();
2312 
2313         _operatorApprovals[_msgSender()][operator] = approved;
2314         emit ApprovalForAll(_msgSender(), operator, approved);
2315     }
2316 
2317     /**
2318      * @dev See {IERC721-isApprovedForAll}.
2319      */
2320     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2321         return _operatorApprovals[owner][operator];
2322     }
2323 
2324     /**
2325      * @dev See {IERC721-transferFrom}.
2326      */
2327     function transferFrom(
2328         address from,
2329         address to,
2330         uint256 tokenId
2331     ) public virtual override {
2332         _transfer(from, to, tokenId);
2333     }
2334 
2335     /**
2336      * @dev See {IERC721-safeTransferFrom}.
2337      */
2338     function safeTransferFrom(
2339         address from,
2340         address to,
2341         uint256 tokenId
2342     ) public virtual override {
2343         safeTransferFrom(from, to, tokenId, '');
2344     }
2345 
2346     /**
2347      * @dev See {IERC721-safeTransferFrom}.
2348      */
2349     function safeTransferFrom(
2350         address from,
2351         address to,
2352         uint256 tokenId,
2353         bytes memory _data
2354     ) public virtual override {
2355         _transfer(from, to, tokenId);
2356         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2357             revert TransferToNonERC721ReceiverImplementer();
2358         }
2359     }
2360 
2361     /**
2362      * @dev Returns whether `tokenId` exists.
2363      *
2364      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2365      *
2366      * Tokens start existing when they are minted (`_mint`),
2367      */
2368     function _exists(uint256 tokenId) internal view returns (bool) {
2369         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
2370             !_ownerships[tokenId].burned;
2371     }
2372 
2373     function _safeMint(address to, uint256 quantity) internal {
2374         _safeMint(to, quantity, '');
2375     }
2376 
2377     /**
2378      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2379      *
2380      * Requirements:
2381      *
2382      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2383      * - `quantity` must be greater than 0.
2384      *
2385      * Emits a {Transfer} event.
2386      */
2387     function _safeMint(
2388         address to,
2389         uint256 quantity,
2390         bytes memory _data
2391     ) internal {
2392         _mint(to, quantity, _data, true);
2393     }
2394 
2395     /**
2396      * @dev Mints `quantity` tokens and transfers them to `to`.
2397      *
2398      * Requirements:
2399      *
2400      * - `to` cannot be the zero address.
2401      * - `quantity` must be greater than 0.
2402      *
2403      * Emits a {Transfer} event.
2404      */
2405     function _mint(
2406         address to,
2407         uint256 quantity,
2408         bytes memory _data,
2409         bool safe
2410     ) internal {
2411         uint256 startTokenId = _currentIndex;
2412         if (to == address(0)) revert MintToZeroAddress();
2413         if (quantity == 0) revert MintZeroQuantity();
2414 
2415         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2416 
2417         // Overflows are incredibly unrealistic.
2418         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2419         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2420         unchecked {
2421             _addressData[to].balance += uint64(quantity);
2422             _addressData[to].numberMinted += uint64(quantity);
2423 
2424             _ownerships[startTokenId].addr = to;
2425             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2426 
2427             uint256 updatedIndex = startTokenId;
2428             uint256 end = updatedIndex + quantity;
2429 
2430             if (safe && to.isContract()) {
2431                 do {
2432                     emit Transfer(address(0), to, updatedIndex);
2433                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2434                         revert TransferToNonERC721ReceiverImplementer();
2435                     }
2436                 } while (updatedIndex != end);
2437                 // Reentrancy protection
2438                 if (_currentIndex != startTokenId) revert();
2439             } else {
2440                 do {
2441                     emit Transfer(address(0), to, updatedIndex++);
2442                 } while (updatedIndex != end);
2443             }
2444             _currentIndex = updatedIndex;
2445         }
2446         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2447     }
2448 
2449     /**
2450      * @dev Transfers `tokenId` from `from` to `to`.
2451      *
2452      * Requirements:
2453      *
2454      * - `to` cannot be the zero address.
2455      * - `tokenId` token must be owned by `from`.
2456      *
2457      * Emits a {Transfer} event.
2458      */
2459     function _transfer(
2460         address from,
2461         address to,
2462         uint256 tokenId
2463     ) private {
2464         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2465 
2466         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2467 
2468         bool isApprovedOrOwner = (_msgSender() == from ||
2469             isApprovedForAll(from, _msgSender()) ||
2470             getApproved(tokenId) == _msgSender());
2471 
2472         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2473         if (to == address(0)) revert TransferToZeroAddress();
2474 
2475         _beforeTokenTransfers(from, to, tokenId, 1);
2476 
2477         // Clear approvals from the previous owner
2478         _approve(address(0), tokenId, from);
2479 
2480         // Underflow of the sender's balance is impossible because we check for
2481         // ownership above and the recipient's balance can't realistically overflow.
2482         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2483         unchecked {
2484             _addressData[from].balance -= 1;
2485             _addressData[to].balance += 1;
2486 
2487             TokenOwnership storage currSlot = _ownerships[tokenId];
2488             currSlot.addr = to;
2489             currSlot.startTimestamp = uint64(block.timestamp);
2490 
2491             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2492             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2493             uint256 nextTokenId = tokenId + 1;
2494             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2495             if (nextSlot.addr == address(0)) {
2496                 // This will suffice for checking _exists(nextTokenId),
2497                 // as a burned slot cannot contain the zero address.
2498                 if (nextTokenId != _currentIndex) {
2499                     nextSlot.addr = from;
2500                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2501                 }
2502             }
2503         }
2504 
2505         emit Transfer(from, to, tokenId);
2506         _afterTokenTransfers(from, to, tokenId, 1);
2507     }
2508 
2509     /**
2510      * @dev This is equivalent to _burn(tokenId, false)
2511      */
2512     function _burn(uint256 tokenId) internal virtual {
2513         _burn(tokenId, false);
2514     }
2515 
2516     /**
2517      * @dev Destroys `tokenId`.
2518      * The approval is cleared when the token is burned.
2519      *
2520      * Requirements:
2521      *
2522      * - `tokenId` must exist.
2523      *
2524      * Emits a {Transfer} event.
2525      */
2526     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2527         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2528 
2529         address from = prevOwnership.addr;
2530 
2531         if (approvalCheck) {
2532             bool isApprovedOrOwner = (_msgSender() == from ||
2533                 isApprovedForAll(from, _msgSender()) ||
2534                 getApproved(tokenId) == _msgSender());
2535 
2536             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2537         }
2538 
2539         _beforeTokenTransfers(from, address(0), tokenId, 1);
2540 
2541         // Clear approvals from the previous owner
2542         _approve(address(0), tokenId, from);
2543 
2544         // Underflow of the sender's balance is impossible because we check for
2545         // ownership above and the recipient's balance can't realistically overflow.
2546         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2547         unchecked {
2548             AddressData storage addressData = _addressData[from];
2549             addressData.balance -= 1;
2550             addressData.numberBurned += 1;
2551 
2552             // Keep track of who burned the token, and the timestamp of burning.
2553             TokenOwnership storage currSlot = _ownerships[tokenId];
2554             currSlot.addr = from;
2555             currSlot.startTimestamp = uint64(block.timestamp);
2556             currSlot.burned = true;
2557 
2558             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2559             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2560             uint256 nextTokenId = tokenId + 1;
2561             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2562             if (nextSlot.addr == address(0)) {
2563                 // This will suffice for checking _exists(nextTokenId),
2564                 // as a burned slot cannot contain the zero address.
2565                 if (nextTokenId != _currentIndex) {
2566                     nextSlot.addr = from;
2567                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2568                 }
2569             }
2570         }
2571 
2572         emit Transfer(from, address(0), tokenId);
2573         _afterTokenTransfers(from, address(0), tokenId, 1);
2574 
2575         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2576         unchecked {
2577             _burnCounter++;
2578         }
2579     }
2580 
2581     /**
2582      * @dev Approve `to` to operate on `tokenId`
2583      *
2584      * Emits a {Approval} event.
2585      */
2586     function _approve(
2587         address to,
2588         uint256 tokenId,
2589         address owner
2590     ) private {
2591         _tokenApprovals[tokenId] = to;
2592         emit Approval(owner, to, tokenId);
2593     }
2594 
2595     /**
2596      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2597      *
2598      * @param from address representing the previous owner of the given token ID
2599      * @param to target address that will receive the tokens
2600      * @param tokenId uint256 ID of the token to be transferred
2601      * @param _data bytes optional data to send along with the call
2602      * @return bool whether the call correctly returned the expected magic value
2603      */
2604     function _checkContractOnERC721Received(
2605         address from,
2606         address to,
2607         uint256 tokenId,
2608         bytes memory _data
2609     ) private returns (bool) {
2610         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2611             return retval == IERC721Receiver(to).onERC721Received.selector;
2612         } catch (bytes memory reason) {
2613             if (reason.length == 0) {
2614                 revert TransferToNonERC721ReceiverImplementer();
2615             } else {
2616                 assembly {
2617                     revert(add(32, reason), mload(reason))
2618                 }
2619             }
2620         }
2621     }
2622 
2623     /**
2624      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2625      * And also called before burning one token.
2626      *
2627      * startTokenId - the first token id to be transferred
2628      * quantity - the amount to be transferred
2629      *
2630      * Calling conditions:
2631      *
2632      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2633      * transferred to `to`.
2634      * - When `from` is zero, `tokenId` will be minted for `to`.
2635      * - When `to` is zero, `tokenId` will be burned by `from`.
2636      * - `from` and `to` are never both zero.
2637      */
2638     function _beforeTokenTransfers(
2639         address from,
2640         address to,
2641         uint256 startTokenId,
2642         uint256 quantity
2643     ) internal virtual {}
2644 
2645     /**
2646      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2647      * minting.
2648      * And also called after one token has been burned.
2649      *
2650      * startTokenId - the first token id to be transferred
2651      * quantity - the amount to be transferred
2652      *
2653      * Calling conditions:
2654      *
2655      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2656      * transferred to `to`.
2657      * - When `from` is zero, `tokenId` has been minted for `to`.
2658      * - When `to` is zero, `tokenId` has been burned by `from`.
2659      * - `from` and `to` are never both zero.
2660      */
2661     function _afterTokenTransfers(
2662         address from,
2663         address to,
2664         uint256 startTokenId,
2665         uint256 quantity
2666     ) internal virtual {}
2667 }
2668 
2669 
2670 
2671 pragma solidity ^0.8.0;
2672 
2673 /**
2674  * @dev Interface of the ERC20 standard as defined in the EIP.
2675  */
2676 interface IERC20 {
2677     /**
2678      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2679      * another (`to`).
2680      *
2681      * Note that `value` may be zero.
2682      */
2683     event Transfer(address indexed from, address indexed to, uint256 value);
2684 
2685     /**
2686      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2687      * a call to {approve}. `value` is the new allowance.
2688      */
2689     event Approval(address indexed owner, address indexed spender, uint256 value);
2690 
2691     /**
2692      * @dev Returns the amount of tokens in existence.
2693      */
2694     function totalSupply() external view returns (uint256);
2695 
2696     /**
2697      * @dev Returns the amount of tokens owned by `account`.
2698      */
2699     function balanceOf(address account) external view returns (uint256);
2700 
2701     /**
2702      * @dev Moves `amount` tokens from the caller's account to `to`.
2703      *
2704      * Returns a boolean value indicating whether the operation succeeded.
2705      *
2706      * Emits a {Transfer} event.
2707      */
2708     function transfer(address to, uint256 amount) external returns (bool);
2709 
2710     /**
2711      * @dev Returns the remaining number of tokens that `spender` will be
2712      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2713      * zero by default.
2714      *
2715      * This value changes when {approve} or {transferFrom} are called.
2716      */
2717     function allowance(address owner, address spender) external view returns (uint256);
2718 
2719     /**
2720      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2721      *
2722      * Returns a boolean value indicating whether the operation succeeded.
2723      *
2724      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2725      * that someone may use both the old and the new allowance by unfortunate
2726      * transaction ordering. One possible solution to mitigate this race
2727      * condition is to first reduce the spender's allowance to 0 and set the
2728      * desired value afterwards:
2729      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2730      *
2731      * Emits an {Approval} event.
2732      */
2733     function approve(address spender, uint256 amount) external returns (bool);
2734 
2735     /**
2736      * @dev Moves `amount` tokens from `from` to `to` using the
2737      * allowance mechanism. `amount` is then deducted from the caller's
2738      * allowance.
2739      *
2740      * Returns a boolean value indicating whether the operation succeeded.
2741      *
2742      * Emits a {Transfer} event.
2743      */
2744     function transferFrom(
2745         address from,
2746         address to,
2747         uint256 amount
2748     ) external returns (bool);
2749 }
2750 
2751 pragma solidity ^0.8.0;
2752 
2753 /**
2754  * @title SafeERC20
2755  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2756  * contract returns false). Tokens that return no value (and instead revert or
2757  * throw on failure) are also supported, non-reverting calls are assumed to be
2758  * successful.
2759  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2760  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2761  */
2762 library SafeERC20 {
2763     using Address for address;
2764 
2765     function safeTransfer(
2766         IERC20 token,
2767         address to,
2768         uint256 value
2769     ) internal {
2770         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2771     }
2772 
2773     function safeTransferFrom(
2774         IERC20 token,
2775         address from,
2776         address to,
2777         uint256 value
2778     ) internal {
2779         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2780     }
2781 
2782     /**
2783      * @dev Deprecated. This function has issues similar to the ones found in
2784      * {IERC20-approve}, and its usage is discouraged.
2785      *
2786      * Whenever possible, use {safeIncreaseAllowance} and
2787      * {safeDecreaseAllowance} instead.
2788      */
2789     function safeApprove(
2790         IERC20 token,
2791         address spender,
2792         uint256 value
2793     ) internal {
2794         // safeApprove should only be called when setting an initial allowance,
2795         // or when resetting it to zero. To increase and decrease it, use
2796         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2797         require(
2798             (value == 0) || (token.allowance(address(this), spender) == 0),
2799             "SafeERC20: approve from non-zero to non-zero allowance"
2800         );
2801         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2802     }
2803 
2804     function safeIncreaseAllowance(
2805         IERC20 token,
2806         address spender,
2807         uint256 value
2808     ) internal {
2809         uint256 newAllowance = token.allowance(address(this), spender) + value;
2810         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2811     }
2812 
2813     function safeDecreaseAllowance(
2814         IERC20 token,
2815         address spender,
2816         uint256 value
2817     ) internal {
2818         unchecked {
2819             uint256 oldAllowance = token.allowance(address(this), spender);
2820             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2821             uint256 newAllowance = oldAllowance - value;
2822             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2823         }
2824     }
2825 
2826     /**
2827      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2828      * on the return value: the return value is optional (but if data is returned, it must not be false).
2829      * @param token The token targeted by the call.
2830      * @param data The call data (encoded using abi.encode or one of its variants).
2831      */
2832     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2833         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2834         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2835         // the target address contains contract code and also asserts for success in the low-level call.
2836 
2837         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2838         if (returndata.length > 0) {
2839             // Return data is optional
2840             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2841         }
2842     }
2843 }
2844 
2845 
2846 pragma solidity ^0.8.0;
2847 
2848 
2849 
2850 /**
2851  * @title PaymentSplitter
2852  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2853  * that the Ether will be split in this way, since it is handled transparently by the contract.
2854  *
2855  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2856  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2857  * an amount proportional to the percentage of total shares they were assigned.
2858  *
2859  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2860  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2861  * function.
2862  *
2863  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2864  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2865  * to run tests before sending real value to this contract.
2866  */
2867 contract PaymentSplitter is Context {
2868     event PayeeAdded(address account, uint256 shares);
2869     event PaymentReleased(address to, uint256 amount);
2870     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2871     event PaymentReceived(address from, uint256 amount);
2872 
2873     uint256 private _totalShares;
2874     uint256 private _totalReleased;
2875 
2876     mapping(address => uint256) private _shares;
2877     mapping(address => uint256) private _released;
2878     address[] private _payees;
2879 
2880     mapping(IERC20 => uint256) private _erc20TotalReleased;
2881     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2882 
2883     /**
2884      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2885      * the matching position in the `shares` array.
2886      *
2887      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2888      * duplicates in `payees`.
2889      */
2890     constructor(address[] memory payees, uint256[] memory shares_) payable {
2891         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2892         require(payees.length > 0, "PaymentSplitter: no payees");
2893 
2894         for (uint256 i = 0; i < payees.length; i++) {
2895             _addPayee(payees[i], shares_[i]);
2896         }
2897     }
2898 
2899     /**
2900      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2901      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2902      * reliability of the events, and not the actual splitting of Ether.
2903      *
2904      * To learn more about this see the Solidity documentation for
2905      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2906      * functions].
2907      */
2908     receive() external payable virtual {
2909         emit PaymentReceived(_msgSender(), msg.value);
2910     }
2911 
2912     /**
2913      * @dev Getter for the total shares held by payees.
2914      */
2915     function totalShares() public view returns (uint256) {
2916         return _totalShares;
2917     }
2918 
2919     /**
2920      * @dev Getter for the total amount of Ether already released.
2921      */
2922     function totalReleased() public view returns (uint256) {
2923         return _totalReleased;
2924     }
2925 
2926     /**
2927      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2928      * contract.
2929      */
2930     function totalReleased(IERC20 token) public view returns (uint256) {
2931         return _erc20TotalReleased[token];
2932     }
2933 
2934     /**
2935      * @dev Getter for the amount of shares held by an account.
2936      */
2937     function shares(address account) public view returns (uint256) {
2938         return _shares[account];
2939     }
2940 
2941     /**
2942      * @dev Getter for the amount of Ether already released to a payee.
2943      */
2944     function released(address account) public view returns (uint256) {
2945         return _released[account];
2946     }
2947 
2948     /**
2949      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2950      * IERC20 contract.
2951      */
2952     function released(IERC20 token, address account) public view returns (uint256) {
2953         return _erc20Released[token][account];
2954     }
2955 
2956     /**
2957      * @dev Getter for the address of the payee number `index`.
2958      */
2959     function payee(uint256 index) public view returns (address) {
2960         return _payees[index];
2961     }
2962 
2963     /**
2964      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2965      * total shares and their previous withdrawals.
2966      */
2967     function release(address payable account) public virtual {
2968         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2969 
2970         uint256 totalReceived = address(this).balance + totalReleased();
2971         uint256 payment = _pendingPayment(account, totalReceived, released(account));
2972 
2973         require(payment != 0, "PaymentSplitter: account is not due payment");
2974 
2975         _released[account] += payment;
2976         _totalReleased += payment;
2977 
2978         Address.sendValue(account, payment);
2979         emit PaymentReleased(account, payment);
2980     }
2981 
2982     /**
2983      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2984      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2985      * contract.
2986      */
2987     function release(IERC20 token, address account) public virtual {
2988         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2989 
2990         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2991         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
2992 
2993         require(payment != 0, "PaymentSplitter: account is not due payment");
2994 
2995         _erc20Released[token][account] += payment;
2996         _erc20TotalReleased[token] += payment;
2997 
2998         SafeERC20.safeTransfer(token, account, payment);
2999         emit ERC20PaymentReleased(token, account, payment);
3000     }
3001 
3002     /**
3003      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
3004      * already released amounts.
3005      */
3006     function _pendingPayment(
3007         address account,
3008         uint256 totalReceived,
3009         uint256 alreadyReleased
3010     ) private view returns (uint256) {
3011         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
3012     }
3013 
3014     /**
3015      * @dev Add a new payee to the contract.
3016      * @param account The address of the payee to add.
3017      * @param shares_ The number of shares owned by the payee.
3018      */
3019     function _addPayee(address account, uint256 shares_) private {
3020         require(account != address(0), "PaymentSplitter: account is the zero address");
3021         require(shares_ > 0, "PaymentSplitter: shares are 0");
3022         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
3023 
3024         _payees.push(account);
3025         _shares[account] = shares_;
3026         _totalShares = _totalShares + shares_;
3027         emit PayeeAdded(account, shares_);
3028     }
3029 }
3030 
3031 contract LiquidInvaders is ERC721A, ReentrancyGuard, Ownable, PaymentSplitter {
3032 
3033     // Minting Variables
3034     uint256 public mintPrice = 0.069 ether;
3035     uint256 public maxPurchase = 11;
3036     uint256 public maxSupply = 3333;
3037     address public apeLiquidAddress; // = 0x61028F622CB6618cAC3DeB9ef0f0D5B9c6369C72;
3038 
3039     address[] public _payees = [
3040         0x4e4CC29ab82cf8aa4EcD3578A26409E57793de4b,  // dev
3041         0x1Fd81469948135d389DCD4C47102FE6d6b229B7e,  // contract
3042         0x7FDE663601A53A6953bbb98F1Ab87E86dEE81b35,  // liquid + abductions
3043         0x2A724010b221DdAc53Efe3daeCC08DEfb81bD160,  // metl
3044         0x89B4b7b597D9D091E55426B7Ce7Fc722577dE1eC   // artist
3045     ];
3046     uint256[] private _shares = [5, 25, 40, 25, 5];
3047 
3048     // Sale Status
3049     bool public saleIsActive = false;
3050     bool public holderSaleIsActive = false;
3051     mapping(uint256 => bool) public claimedApeLiquid;
3052     mapping(address => uint) public addressesThatMinted;
3053 
3054     // Metadata
3055     string _baseTokenURI = "http://ipfs.io/ipfs/QmU1MSagkzwvxKJ51QHvi8aoBwQa5Cbs7H879yKhW7kp2U/";
3056     bool public locked;
3057 
3058     // Events
3059     event SaleActivation(bool isActive);
3060     event HolderSaleActivation(bool isActive);
3061 
3062     constructor(address _apeLiquidAddress) ERC721A("Liquid Invaders", "INVADER") PaymentSplitter(_payees, _shares) {
3063     apeLiquidAddress = _apeLiquidAddress;
3064     }
3065 
3066     //Holder status validation
3067     function isApeLiquidAvailable(uint256 _tokenId) public view returns(bool) {
3068         return claimedApeLiquid[_tokenId] != true;
3069     }
3070 
3071     // Minting
3072     function ownerMint(address _to, uint256 _count) external onlyOwner {
3073         require(
3074             totalSupply() + _count <= maxSupply,
3075             "SOLD_OUT"
3076         );
3077         _safeMint(_to, _count);
3078     }
3079 
3080     function membershipAirdopMint(address[] calldata _to, uint256[] calldata _tokenIds) external onlyOwner {
3081         for (uint256 i = 0; i < _tokenIds.length; i++) {
3082         _safeMint(_to[i], 1);
3083         claimedApeLiquid[_tokenIds[i]] = true;
3084         }
3085     }
3086 
3087     function holderFreeMint(uint256[] calldata _apeLiquidIds, uint256 _count) external nonReentrant {
3088         require(holderSaleIsActive, "HOLDER_SALE_INACTIVE");
3089         require(
3090             _count == _apeLiquidIds.length,
3091             "INSUFFICIENT_AL_TOKENS"
3092         );
3093         require(
3094             totalSupply() + _count <= maxSupply,
3095             "SOLD_OUT"
3096         );
3097 
3098         ERC721Enumerable apeLiquid = ERC721Enumerable(apeLiquidAddress);
3099         require(apeLiquid.balanceOf(msg.sender) > 0, "NO_AL_TOKENS");
3100         for (uint256 i = 0; i < _apeLiquidIds.length; i++) {
3101             require(isApeLiquidAvailable(_apeLiquidIds[i]), "AL_ALREADY_CLAIMED");
3102             require(apeLiquid.ownerOf(_apeLiquidIds[i]) == msg.sender, "NOT_AL_OWNER");
3103             claimedApeLiquid[_apeLiquidIds[i]] = true;
3104         }
3105 
3106         _safeMint(msg.sender, _count);
3107     }
3108 
3109     function mint(uint256 _count) external payable nonReentrant {
3110         require(saleIsActive, "SALE_INACTIVE");
3111         require(((addressesThatMinted[msg.sender] + _count) ) <= maxPurchase , "this would exceed mint max allowance");
3112 
3113         require(
3114             totalSupply() + _count <= maxSupply,
3115             "SOLD_OUT"
3116         );
3117         require(
3118             totalSupply() + _count <= maxSupply,
3119             "PUBLIC_SOLD_OUT"
3120         );
3121         require(
3122             mintPrice * _count <= msg.value,
3123             "INCORRECT_ETHER_VALUE"
3124         );
3125 
3126             _safeMint(msg.sender, _count);
3127             addressesThatMinted[msg.sender] += _count;
3128         }
3129 
3130     function toggleHolderSaleStatus() external onlyOwner {
3131         holderSaleIsActive = !holderSaleIsActive;
3132         emit HolderSaleActivation(holderSaleIsActive);
3133     }
3134 
3135     function toggleSaleStatus() external onlyOwner {
3136         saleIsActive = !saleIsActive;
3137         emit SaleActivation(saleIsActive);
3138     }
3139 
3140     function setMintPrice(uint256 _mintPrice) external onlyOwner {
3141         mintPrice = _mintPrice;
3142     }
3143 
3144     function setApeLiquidAddress(address _apeLiquidAddress) external onlyOwner {
3145         apeLiquidAddress = _apeLiquidAddress;
3146     }
3147 
3148     function setMaxPurchase(uint256 _maxPurchase) external onlyOwner {
3149         maxPurchase = _maxPurchase;
3150     }
3151 
3152     function lockMetadata() external onlyOwner {
3153         locked = true;
3154     }
3155 
3156     // Payment
3157     function claim() external {
3158         release(payable(msg.sender));
3159     }
3160 
3161     function getWalletOfOwner(address owner) external view returns (uint256[] memory) {
3162     unchecked {
3163         uint256[] memory a = new uint256[](balanceOf(owner));
3164         uint256 end = _currentIndex;
3165         uint256 tokenIdsIdx;
3166         address currOwnershipAddr;
3167         for (uint256 i; i < end; i++) {
3168             TokenOwnership memory ownership = _ownerships[i];
3169             if (ownership.burned) {
3170                 continue;
3171             }
3172             if (ownership.addr != address(0)) {
3173                 currOwnershipAddr = ownership.addr;
3174             }
3175             if (currOwnershipAddr == owner) {
3176                 a[tokenIdsIdx++] = i;
3177             }
3178         }
3179         return a;
3180     }
3181     }
3182 
3183     function getTotalSupply() external view returns (uint256) {
3184         return totalSupply();
3185     }
3186 
3187     function setBaseURI(string memory baseURI) external onlyOwner {
3188         require(!locked, "METADATA_LOCKED");
3189         _baseTokenURI = baseURI;
3190     }
3191 
3192     function _baseURI() internal view virtual override returns (string memory) {
3193         return _baseTokenURI;
3194     }
3195 
3196     function tokenURI(uint256 tokenId) public view override returns (string memory){
3197         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
3198     }
3199 
3200     function _startTokenId() internal view virtual override returns (uint256){
3201         return 1;
3202     }
3203 
3204 
3205 }