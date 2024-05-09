1 /**
2  *Submitted for verification at polygonscan.com on 2022-03-06
3 */
4 
5 /**
6  *Submitted for verification at polygonscan.com on 2022-03-03
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Provides information about the current execution context, including the
180  * sender of the transaction and its data. While these are generally available
181  * via msg.sender and msg.data, they should not be accessed in such a direct
182  * manner, since when dealing with meta-transactions the account sending and
183  * paying for execution may not be the actual sender (as far as an application
184  * is concerned).
185  *
186  * This contract is only required for intermediate, library-like contracts.
187  */
188 abstract contract Context {
189     function _msgSender() internal view virtual returns (address) {
190         return msg.sender;
191     }
192 
193     function _msgData() internal view virtual returns (bytes calldata) {
194         return msg.data;
195     }
196 }
197 
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Interface of the ERC20 standard as defined in the EIP.
203  */
204 interface IERC20 {
205     /**
206      * @dev Returns the amount of tokens in existence.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     /**
211      * @dev Returns the amount of tokens owned by `account`.
212      */
213     function balanceOf(address account) external view returns (uint256);
214 
215     /**
216      * @dev Moves `amount` tokens from the caller's account to `recipient`.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transfer(address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Returns the remaining number of tokens that `spender` will be
226      * allowed to spend on behalf of `owner` through {transferFrom}. This is
227      * zero by default.
228      *
229      * This value changes when {approve} or {transferFrom} are called.
230      */
231     function allowance(address owner, address spender) external view returns (uint256);
232 
233     /**
234      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * IMPORTANT: Beware that changing an allowance with this method brings the risk
239      * that someone may use both the old and the new allowance by unfortunate
240      * transaction ordering. One possible solution to mitigate this race
241      * condition is to first reduce the spender's allowance to 0 and set the
242      * desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address spender, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Moves `amount` tokens from `sender` to `recipient` using the
251      * allowance mechanism. `amount` is then deducted from the caller's
252      * allowance.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(
259         address sender,
260         address recipient,
261         uint256 amount
262     ) external returns (bool);
263 
264     /**
265      * @dev Emitted when `value` tokens are moved from one account (`from`) to
266      * another (`to`).
267      *
268      * Note that `value` may be zero.
269      */
270     event Transfer(address indexed from, address indexed to, uint256 value);
271 
272     /**
273      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
274      * a call to {approve}. `value` is the new allowance.
275      */
276     event Approval(address indexed owner, address indexed spender, uint256 value);
277 }
278 
279 
280 
281 pragma solidity ^0.8.0;
282 
283 
284 /**
285  * @dev Contract module which allows children to implement an emergency stop
286  * mechanism that can be triggered by an authorized account.
287  *
288  * This module is used through inheritance. It will make available the
289  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
290  * the functions of your contract. Note that they will not be pausable by
291  * simply including this module, only once the modifiers are put in place.
292  */
293 abstract contract Pausable is Context {
294     /**
295      * @dev Emitted when the pause is triggered by `account`.
296      */
297     event Paused(address account);
298 
299     /**
300      * @dev Emitted when the pause is lifted by `account`.
301      */
302     event Unpaused(address account);
303 
304     bool private _paused;
305 
306     /**
307      * @dev Initializes the contract in unpaused state.
308      */
309     constructor() {
310         _paused = false;
311     }
312 
313     /**
314      * @dev Returns true if the contract is paused, and false otherwise.
315      */
316     function paused() public view virtual returns (bool) {
317         return _paused;
318     }
319 
320     /**
321      * @dev Modifier to make a function callable only when the contract is not paused.
322      *
323      * Requirements:
324      *
325      * - The contract must not be paused.
326      */
327     modifier whenNotPaused() {
328         require(!paused(), "Pausable: paused");
329         _;
330     }
331 
332     /**
333      * @dev Modifier to make a function callable only when the contract is paused.
334      *
335      * Requirements:
336      *
337      * - The contract must be paused.
338      */
339     modifier whenPaused() {
340         require(paused(), "Pausable: not paused");
341         _;
342     }
343 
344     /**
345      * @dev Triggers stopped state.
346      *
347      * Requirements:
348      *
349      * - The contract must not be paused.
350      */
351     function _pause() internal virtual whenNotPaused {
352         _paused = true;
353         emit Paused(_msgSender());
354     }
355 
356     /**
357      * @dev Returns to normal state.
358      *
359      * Requirements:
360      *
361      * - The contract must be paused.
362      */
363     function _unpause() internal virtual whenPaused {
364         _paused = false;
365         emit Unpaused(_msgSender());
366     }
367 }
368 
369 
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev Standard math utilities missing in the Solidity language.
375  */
376 library Math {
377     /**
378      * @dev Returns the largest of two numbers.
379      */
380     function max(uint256 a, uint256 b) internal pure returns (uint256) {
381         return a >= b ? a : b;
382     }
383 
384     /**
385      * @dev Returns the smallest of two numbers.
386      */
387     function min(uint256 a, uint256 b) internal pure returns (uint256) {
388         return a < b ? a : b;
389     }
390 
391     /**
392      * @dev Returns the average of two numbers. The result is rounded towards
393      * zero.
394      */
395     function average(uint256 a, uint256 b) internal pure returns (uint256) {
396         // (a + b) / 2 can overflow.
397         return (a & b) + (a ^ b) / 2;
398     }
399 
400     /**
401      * @dev Returns the ceiling of the division of two numbers.
402      *
403      * This differs from standard division with `/` in that it rounds up instead
404      * of rounding down.
405      */
406     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
407         // (a + b - 1) / b can overflow on addition, so we distribute.
408         return a / b + (a % b == 0 ? 0 : 1);
409     }
410 }
411 
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev Contract module that helps prevent reentrant calls to a function.
417  *
418  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
419  * available, which can be applied to functions to make sure there are no nested
420  * (reentrant) calls to them.
421  *
422  * Note that because there is a single `nonReentrant` guard, functions marked as
423  * `nonReentrant` may not call one another. This can be worked around by making
424  * those functions `private`, and then adding `external` `nonReentrant` entry
425  * points to them.
426  *
427  * TIP: If you would like to learn more about reentrancy and alternative ways
428  * to protect against it, check out our blog post
429  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
430  */
431 abstract contract ReentrancyGuard {
432     // Booleans are more expensive than uint256 or any type that takes up a full
433     // word because each write operation emits an extra SLOAD to first read the
434     // slot's contents, replace the bits taken up by the boolean, and then write
435     // back. This is the compiler's defense against contract upgrades and
436     // pointer aliasing, and it cannot be disabled.
437 
438     // The values being non-zero value makes deployment a bit more expensive,
439     // but in exchange the refund on every call to nonReentrant will be lower in
440     // amount. Since refunds are capped to a percentage of the total
441     // transaction's gas, it is best to keep them low in cases like this one, to
442     // increase the likelihood of the full refund coming into effect.
443     uint256 private constant _NOT_ENTERED = 1;
444     uint256 private constant _ENTERED = 2;
445 
446     uint256 private _status;
447 
448     constructor() {
449         _status = _NOT_ENTERED;
450     }
451 
452     /**
453      * @dev Prevents a contract from calling itself, directly or indirectly.
454      * Calling a `nonReentrant` function from another `nonReentrant`
455      * function is not supported. It is possible to prevent this from happening
456      * by making the `nonReentrant` function external, and make it call a
457      * `private` function that does the actual work.
458      */
459     modifier nonReentrant() {
460         // On the first call to nonReentrant, _notEntered will be true
461         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
462 
463         // Any calls to nonReentrant after this point will fail
464         _status = _ENTERED;
465 
466         _;
467 
468         // By storing the original value once again, a refund is triggered (see
469         // https://eips.ethereum.org/EIPS/eip-2200)
470         _status = _NOT_ENTERED;
471     }
472 }
473 
474 
475 
476 pragma solidity ^0.8.0;
477 
478 /**
479  * @dev Library for managing
480  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
481  * types.
482  *
483  * Sets have the following properties:
484  *
485  * - Elements are added, removed, and checked for existence in constant time
486  * (O(1)).
487  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
488  *
489  * ```
490  * contract Example {
491  *     // Add the library methods
492  *     using EnumerableSet for EnumerableSet.AddressSet;
493  *
494  *     // Declare a set state variable
495  *     EnumerableSet.AddressSet private mySet;
496  * }
497  * ```
498  *
499  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
500  * and `uint256` (`UintSet`) are supported.
501  */
502 library EnumerableSet {
503     // To implement this library for multiple types with as little code
504     // repetition as possible, we write it in terms of a generic Set type with
505     // bytes32 values.
506     // The Set implementation uses private functions, and user-facing
507     // implementations (such as AddressSet) are just wrappers around the
508     // underlying Set.
509     // This means that we can only create new EnumerableSets for types that fit
510     // in bytes32.
511 
512     struct Set {
513         // Storage of set values
514         bytes32[] _values;
515         // Position of the value in the `values` array, plus 1 because index 0
516         // means a value is not in the set.
517         mapping(bytes32 => uint256) _indexes;
518     }
519 
520     /**
521      * @dev Add a value to a set. O(1).
522      *
523      * Returns true if the value was added to the set, that is if it was not
524      * already present.
525      */
526     function _add(Set storage set, bytes32 value) private returns (bool) {
527         if (!_contains(set, value)) {
528             set._values.push(value);
529             // The value is stored at length-1, but we add 1 to all indexes
530             // and use 0 as a sentinel value
531             set._indexes[value] = set._values.length;
532             return true;
533         } else {
534             return false;
535         }
536     }
537 
538     /**
539      * @dev Removes a value from a set. O(1).
540      *
541      * Returns true if the value was removed from the set, that is if it was
542      * present.
543      */
544     function _remove(Set storage set, bytes32 value) private returns (bool) {
545         // We read and store the value's index to prevent multiple reads from the same storage slot
546         uint256 valueIndex = set._indexes[value];
547 
548         if (valueIndex != 0) {
549             // Equivalent to contains(set, value)
550             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
551             // the array, and then remove the last element (sometimes called as 'swap and pop').
552             // This modifies the order of the array, as noted in {at}.
553 
554             uint256 toDeleteIndex = valueIndex - 1;
555             uint256 lastIndex = set._values.length - 1;
556 
557             if (lastIndex != toDeleteIndex) {
558                 bytes32 lastvalue = set._values[lastIndex];
559 
560                 // Move the last value to the index where the value to delete is
561                 set._values[toDeleteIndex] = lastvalue;
562                 // Update the index for the moved value
563                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
564             }
565 
566             // Delete the slot where the moved value was stored
567             set._values.pop();
568 
569             // Delete the index for the deleted slot
570             delete set._indexes[value];
571 
572             return true;
573         } else {
574             return false;
575         }
576     }
577 
578     /**
579      * @dev Returns true if the value is in the set. O(1).
580      */
581     function _contains(Set storage set, bytes32 value) private view returns (bool) {
582         return set._indexes[value] != 0;
583     }
584 
585     /**
586      * @dev Returns the number of values on the set. O(1).
587      */
588     function _length(Set storage set) private view returns (uint256) {
589         return set._values.length;
590     }
591 
592     /**
593      * @dev Returns the value stored at position `index` in the set. O(1).
594      *
595      * Note that there are no guarantees on the ordering of values inside the
596      * array, and it may change when more values are added or removed.
597      *
598      * Requirements:
599      *
600      * - `index` must be strictly less than {length}.
601      */
602     function _at(Set storage set, uint256 index) private view returns (bytes32) {
603         return set._values[index];
604     }
605 
606     /**
607      * @dev Return the entire set in an array
608      *
609      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
610      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
611      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
612      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
613      */
614     function _values(Set storage set) private view returns (bytes32[] memory) {
615         return set._values;
616     }
617 
618     // Bytes32Set
619 
620     struct Bytes32Set {
621         Set _inner;
622     }
623 
624     /**
625      * @dev Add a value to a set. O(1).
626      *
627      * Returns true if the value was added to the set, that is if it was not
628      * already present.
629      */
630     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
631         return _add(set._inner, value);
632     }
633 
634     /**
635      * @dev Removes a value from a set. O(1).
636      *
637      * Returns true if the value was removed from the set, that is if it was
638      * present.
639      */
640     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
641         return _remove(set._inner, value);
642     }
643 
644     /**
645      * @dev Returns true if the value is in the set. O(1).
646      */
647     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
648         return _contains(set._inner, value);
649     }
650 
651     /**
652      * @dev Returns the number of values in the set. O(1).
653      */
654     function length(Bytes32Set storage set) internal view returns (uint256) {
655         return _length(set._inner);
656     }
657 
658     /**
659      * @dev Returns the value stored at position `index` in the set. O(1).
660      *
661      * Note that there are no guarantees on the ordering of values inside the
662      * array, and it may change when more values are added or removed.
663      *
664      * Requirements:
665      *
666      * - `index` must be strictly less than {length}.
667      */
668     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
669         return _at(set._inner, index);
670     }
671 
672     /**
673      * @dev Return the entire set in an array
674      *
675      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
676      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
677      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
678      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
679      */
680     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
681         return _values(set._inner);
682     }
683 
684     // AddressSet
685 
686     struct AddressSet {
687         Set _inner;
688     }
689 
690     /**
691      * @dev Add a value to a set. O(1).
692      *
693      * Returns true if the value was added to the set, that is if it was not
694      * already present.
695      */
696     function add(AddressSet storage set, address value) internal returns (bool) {
697         return _add(set._inner, bytes32(uint256(uint160(value))));
698     }
699 
700     /**
701      * @dev Removes a value from a set. O(1).
702      *
703      * Returns true if the value was removed from the set, that is if it was
704      * present.
705      */
706     function remove(AddressSet storage set, address value) internal returns (bool) {
707         return _remove(set._inner, bytes32(uint256(uint160(value))));
708     }
709 
710     /**
711      * @dev Returns true if the value is in the set. O(1).
712      */
713     function contains(AddressSet storage set, address value) internal view returns (bool) {
714         return _contains(set._inner, bytes32(uint256(uint160(value))));
715     }
716 
717     /**
718      * @dev Returns the number of values in the set. O(1).
719      */
720     function length(AddressSet storage set) internal view returns (uint256) {
721         return _length(set._inner);
722     }
723 
724     /**
725      * @dev Returns the value stored at position `index` in the set. O(1).
726      *
727      * Note that there are no guarantees on the ordering of values inside the
728      * array, and it may change when more values are added or removed.
729      *
730      * Requirements:
731      *
732      * - `index` must be strictly less than {length}.
733      */
734     function at(AddressSet storage set, uint256 index) internal view returns (address) {
735         return address(uint160(uint256(_at(set._inner, index))));
736     }
737 
738     /**
739      * @dev Return the entire set in an array
740      *
741      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
742      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
743      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
744      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
745      */
746     function values(AddressSet storage set) internal view returns (address[] memory) {
747         bytes32[] memory store = _values(set._inner);
748         address[] memory result;
749 
750         assembly {
751             result := store
752         }
753 
754         return result;
755     }
756 
757     // UintSet
758 
759     struct UintSet {
760         Set _inner;
761     }
762 
763     /**
764      * @dev Add a value to a set. O(1).
765      *
766      * Returns true if the value was added to the set, that is if it was not
767      * already present.
768      */
769     function add(UintSet storage set, uint256 value) internal returns (bool) {
770         return _add(set._inner, bytes32(value));
771     }
772 
773     /**
774      * @dev Removes a value from a set. O(1).
775      *
776      * Returns true if the value was removed from the set, that is if it was
777      * present.
778      */
779     function remove(UintSet storage set, uint256 value) internal returns (bool) {
780         return _remove(set._inner, bytes32(value));
781     }
782 
783     /**
784      * @dev Returns true if the value is in the set. O(1).
785      */
786     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
787         return _contains(set._inner, bytes32(value));
788     }
789 
790     /**
791      * @dev Returns the number of values on the set. O(1).
792      */
793     function length(UintSet storage set) internal view returns (uint256) {
794         return _length(set._inner);
795     }
796 
797     /**
798      * @dev Returns the value stored at position `index` in the set. O(1).
799      *
800      * Note that there are no guarantees on the ordering of values inside the
801      * array, and it may change when more values are added or removed.
802      *
803      * Requirements:
804      *
805      * - `index` must be strictly less than {length}.
806      */
807     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
808         return uint256(_at(set._inner, index));
809     }
810 
811     /**
812      * @dev Return the entire set in an array
813      *
814      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
815      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
816      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
817      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
818      */
819     function values(UintSet storage set) internal view returns (uint256[] memory) {
820         bytes32[] memory store = _values(set._inner);
821         uint256[] memory result;
822 
823         assembly {
824             result := store
825         }
826 
827         return result;
828     }
829 }
830 
831 
832 
833 pragma solidity ^0.8.0;
834 
835 /**
836  * @title ERC721 token receiver interface
837  * @dev Interface for any contract that wants to support safeTransfers
838  * from ERC721 asset contracts.
839  */
840 interface IERC721Receiver {
841     /**
842      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
843      * by `operator` from `from`, this function is called.
844      *
845      * It must return its Solidity selector to confirm the token transfer.
846      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
847      *
848      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
849      */
850     function onERC721Received(
851         address operator,
852         address from,
853         uint256 tokenId,
854         bytes calldata data
855     ) external returns (bytes4);
856 }
857 
858 
859 
860 pragma solidity ^0.8.0;
861 
862 
863 /**
864  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
865  * @dev See https://eips.ethereum.org/EIPS/eip-721
866  */
867 interface IERC721Enumerable is IERC721 {
868     /**
869      * @dev Returns the total amount of tokens stored by the contract.
870      */
871     function totalSupply() external view returns (uint256);
872 
873     /**
874      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
875      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
876      */
877     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
878 
879     /**
880      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
881      * Use along with {totalSupply} to enumerate all tokens.
882      */
883     function tokenByIndex(uint256 index) external view returns (uint256);
884 }
885 
886 
887 
888 pragma solidity ^0.8.0;
889 
890 // CAUTION
891 // This version of SafeMath should only be used with Solidity 0.8 or later,
892 // because it relies on the compiler's built in overflow checks.
893 
894 /**
895  * @dev Wrappers over Solidity's arithmetic operations.
896  *
897  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
898  * now has built in overflow checking.
899  */
900 library SafeMath {
901     /**
902      * @dev Returns the addition of two unsigned integers, with an overflow flag.
903      *
904      * _Available since v3.4._
905      */
906     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
907         unchecked {
908             uint256 c = a + b;
909             if (c < a) return (false, 0);
910             return (true, c);
911         }
912     }
913 
914     /**
915      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
916      *
917      * _Available since v3.4._
918      */
919     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
920         unchecked {
921             if (b > a) return (false, 0);
922             return (true, a - b);
923         }
924     }
925 
926     /**
927      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
928      *
929      * _Available since v3.4._
930      */
931     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
932         unchecked {
933             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
934             // benefit is lost if 'b' is also tested.
935             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
936             if (a == 0) return (true, 0);
937             uint256 c = a * b;
938             if (c / a != b) return (false, 0);
939             return (true, c);
940         }
941     }
942 
943     /**
944      * @dev Returns the division of two unsigned integers, with a division by zero flag.
945      *
946      * _Available since v3.4._
947      */
948     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
949         unchecked {
950             if (b == 0) return (false, 0);
951             return (true, a / b);
952         }
953     }
954 
955     /**
956      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
957      *
958      * _Available since v3.4._
959      */
960     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
961         unchecked {
962             if (b == 0) return (false, 0);
963             return (true, a % b);
964         }
965     }
966 
967     /**
968      * @dev Returns the addition of two unsigned integers, reverting on
969      * overflow.
970      *
971      * Counterpart to Solidity's `+` operator.
972      *
973      * Requirements:
974      *
975      * - Addition cannot overflow.
976      */
977     function add(uint256 a, uint256 b) internal pure returns (uint256) {
978         return a + b;
979     }
980 
981     /**
982      * @dev Returns the subtraction of two unsigned integers, reverting on
983      * overflow (when the result is negative).
984      *
985      * Counterpart to Solidity's `-` operator.
986      *
987      * Requirements:
988      *
989      * - Subtraction cannot overflow.
990      */
991     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
992         return a - b;
993     }
994 
995     /**
996      * @dev Returns the multiplication of two unsigned integers, reverting on
997      * overflow.
998      *
999      * Counterpart to Solidity's `*` operator.
1000      *
1001      * Requirements:
1002      *
1003      * - Multiplication cannot overflow.
1004      */
1005     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1006         return a * b;
1007     }
1008 
1009     /**
1010      * @dev Returns the integer division of two unsigned integers, reverting on
1011      * division by zero. The result is rounded towards zero.
1012      *
1013      * Counterpart to Solidity's `/` operator.
1014      *
1015      * Requirements:
1016      *
1017      * - The divisor cannot be zero.
1018      */
1019     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1020         return a / b;
1021     }
1022 
1023     /**
1024      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1025      * reverting when dividing by zero.
1026      *
1027      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1028      * opcode (which leaves remaining gas untouched) while Solidity uses an
1029      * invalid opcode to revert (consuming all remaining gas).
1030      *
1031      * Requirements:
1032      *
1033      * - The divisor cannot be zero.
1034      */
1035     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1036         return a % b;
1037     }
1038 
1039     /**
1040      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1041      * overflow (when the result is negative).
1042      *
1043      * CAUTION: This function is deprecated because it requires allocating memory for the error
1044      * message unnecessarily. For custom revert reasons use {trySub}.
1045      *
1046      * Counterpart to Solidity's `-` operator.
1047      *
1048      * Requirements:
1049      *
1050      * - Subtraction cannot overflow.
1051      */
1052     function sub(
1053         uint256 a,
1054         uint256 b,
1055         string memory errorMessage
1056     ) internal pure returns (uint256) {
1057         unchecked {
1058             require(b <= a, errorMessage);
1059             return a - b;
1060         }
1061     }
1062 
1063     /**
1064      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1065      * division by zero. The result is rounded towards zero.
1066      *
1067      * Counterpart to Solidity's `/` operator. Note: this function uses a
1068      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1069      * uses an invalid opcode to revert (consuming all remaining gas).
1070      *
1071      * Requirements:
1072      *
1073      * - The divisor cannot be zero.
1074      */
1075     function div(
1076         uint256 a,
1077         uint256 b,
1078         string memory errorMessage
1079     ) internal pure returns (uint256) {
1080         unchecked {
1081             require(b > 0, errorMessage);
1082             return a / b;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1088      * reverting with custom message when dividing by zero.
1089      *
1090      * CAUTION: This function is deprecated because it requires allocating memory for the error
1091      * message unnecessarily. For custom revert reasons use {tryMod}.
1092      *
1093      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1094      * opcode (which leaves remaining gas untouched) while Solidity uses an
1095      * invalid opcode to revert (consuming all remaining gas).
1096      *
1097      * Requirements:
1098      *
1099      * - The divisor cannot be zero.
1100      */
1101     function mod(
1102         uint256 a,
1103         uint256 b,
1104         string memory errorMessage
1105     ) internal pure returns (uint256) {
1106         unchecked {
1107             require(b > 0, errorMessage);
1108             return a % b;
1109         }
1110     }
1111 }
1112 
1113 
1114 
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 
1119 /**
1120  * @dev Contract module which provides a basic access control mechanism, where
1121  * there is an account (an owner) that can be granted exclusive access to
1122  * specific functions.
1123  *
1124  * By default, the owner account will be the one that deploys the contract. This
1125  * can later be changed with {transferOwnership}.
1126  *
1127  * This module is used through inheritance. It will make available the modifier
1128  * `onlyOwner`, which can be applied to your functions to restrict their use to
1129  * the owner.
1130  */
1131 abstract contract Ownable is Context {
1132     address private _owner;
1133 
1134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1135 
1136     /**
1137      * @dev Initializes the contract setting the deployer as the initial owner.
1138      */
1139     constructor() {
1140         _setOwner(_msgSender());
1141     }
1142 
1143     /**
1144      * @dev Returns the address of the current owner.
1145      */
1146     function owner() public view virtual returns (address) {
1147         return _owner;
1148     }
1149 
1150     /**
1151      * @dev Throws if called by any account other than the owner.
1152      */
1153     modifier onlyOwner() {
1154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1155         _;
1156     }
1157 
1158     /**
1159      * @dev Leaves the contract without owner. It will not be possible to call
1160      * `onlyOwner` functions anymore. Can only be called by the current owner.
1161      *
1162      * NOTE: Renouncing ownership will leave the contract without an owner,
1163      * thereby removing any functionality that is only available to the owner.
1164      */
1165     function renounceOwnership() public virtual onlyOwner {
1166         _setOwner(address(0));
1167     }
1168 
1169     /**
1170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1171      * Can only be called by the current owner.
1172      */
1173     function transferOwnership(address newOwner) public virtual onlyOwner {
1174         require(newOwner != address(0), "Ownable: new owner is the zero address");
1175         _setOwner(newOwner);
1176     }
1177 
1178     function _setOwner(address newOwner) private {
1179         address oldOwner = _owner;
1180         _owner = newOwner;
1181         emit OwnershipTransferred(oldOwner, newOwner);
1182     }
1183 }
1184 
1185 
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 
1191 contract LiquidForge is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1192     using EnumerableSet for EnumerableSet.UintSet; 
1193 
1194     uint256 public  PAD_DISTRIBUTION_AMOUNT;
1195     uint256 public  TIGER_DISTRIBUTION_AMOUNT;
1196     uint256 public  FUNDAE_DISTRIBUTION_AMOUNT;
1197     uint256 public  LEGENDS_DISTRIBUTION_AMOUNT;
1198     uint256 public  AZUKI_DISTRIBUTION_AMOUNT;
1199 
1200     mapping (uint256 => bool) public padClaimed;
1201     mapping (uint256 => bool) public tigerClaimed;
1202     mapping (uint256 => bool) public fundaeClaimed;
1203     mapping (uint256 => bool) public legendsClaimed;
1204     mapping (uint256 => bool) public azukiClaimed;
1205 
1206     //addresses 
1207     
1208     address public legendsAddress;
1209     address public padAddress;
1210     address public tigerAddress;
1211     address public cubsAddress;
1212     address public fundaeAddress;
1213     address public azukiAddress;
1214     address public membershipAddress;
1215 
1216     address public erc20Address;
1217 
1218     //uint256's 
1219     uint256 public expiration; 
1220     uint256 public minBlockToClaim; 
1221     //rate governs how often you receive your token
1222     uint256 public legendsRate; 
1223     uint256 public padRate; 
1224     uint256 public tigerRate; 
1225     uint256 public cubsRate; 
1226     uint256 public fundaeRate; 
1227     uint256 public azukiRate; 
1228   
1229     // mappings 
1230 
1231     mapping(uint256 => uint256) public _legendsForgeBlocks;
1232     mapping(uint256 => address) public _legendsTokenForges;
1233 
1234     mapping(uint256 => uint256) public _padForgeBlocks;
1235     mapping(uint256 => address) public _padTokenForges;
1236  
1237     mapping(uint256 => uint256) public _tigerForgeBlocks;
1238     mapping(uint256 => address) public _tigerTokenForges;
1239 
1240     mapping(uint256 => uint256) public _cubsForgeBlocks;
1241     mapping(uint256 => address) public _cubsTokenForges;
1242 
1243     mapping(uint256 => uint256) public _fundaeForgeBlocks;
1244     mapping(uint256 => address) public _fundaeTokenForges;
1245 
1246     mapping(uint256 => uint256) public _azukiForgeBlocks;
1247     mapping(uint256 => address) public _azukiTokenForges;
1248 
1249     mapping(address => EnumerableSet.UintSet) private _membershipForges;
1250     mapping(address => uint256) public _membershipForgeBlocks;
1251 
1252 
1253     constructor(
1254       address _padAddress,
1255       address _legendsAddress,
1256       address _tigerAddress,
1257       address _cubsAddress,
1258       address _fundaeAddress,
1259       address _azukiAddress,
1260       address _membershipAddress ,
1261       address _erc20Address
1262 
1263     ) {
1264         padAddress = _padAddress;
1265         padRate = 0;
1266         legendsAddress = _legendsAddress;
1267         legendsRate = 0;
1268         tigerAddress = _tigerAddress;
1269         tigerRate = 0;
1270         cubsAddress = _cubsAddress;
1271         cubsRate = 0;
1272         fundaeAddress = _fundaeAddress;
1273         fundaeRate = 0;
1274         azukiAddress = _azukiAddress;
1275         azukiRate = 0;
1276         expiration = block.number + 0;
1277         erc20Address = _erc20Address;
1278         membershipAddress = _membershipAddress;
1279        PAD_DISTRIBUTION_AMOUNT = 5000000000000000000;
1280        TIGER_DISTRIBUTION_AMOUNT = 5000000000000000000;
1281        FUNDAE_DISTRIBUTION_AMOUNT = 5000000000000000000;
1282        AZUKI_DISTRIBUTION_AMOUNT = 5000000000000000000;
1283        LEGENDS_DISTRIBUTION_AMOUNT = 25000000000000000000;
1284     }
1285 
1286     function pause() public onlyOwner {
1287         _pause();
1288     }
1289 
1290     function unpause() public onlyOwner {
1291         _unpause();
1292     }
1293 
1294     function revokeLegendReward(uint256[] calldata tokenIds) public onlyOwner {
1295         for(uint256 i; i < tokenIds.length; ++i) {
1296                     uint256 tokenId = tokenIds[i];
1297                     if(!legendsClaimed[tokenId]) {
1298                         legendsClaimed[tokenId] = true;
1299                     }
1300                 }
1301     }
1302 
1303     // Set this to a expiration block to disable the ability to continue accruing tokens past that block number. which is caclculated as current block plus the parm
1304 
1305     // Set a multiplier for how many tokens to earn each time a block passes. and the min number of blocks needed to pass to claim rewards
1306 
1307     function setRates(uint256 _legendsRate,uint256 _cubsRate, uint256 _padRate, uint256 _tigerRate, uint256 _fundaeRate, uint256 _azukiRate, uint256 _minBlockToClaim, uint256 _expiration ) public onlyOwner() {
1308       legendsRate = _legendsRate;
1309       cubsRate = _cubsRate;
1310       padRate = _padRate;
1311       tigerRate = _tigerRate;
1312       fundaeRate = _fundaeRate;
1313       azukiRate = _azukiRate;
1314       minBlockToClaim = _minBlockToClaim;
1315       expiration = block.number + _expiration;
1316     }
1317 
1318     function rewardClaimable(uint256 tokenId, address nftaddress ) public view returns (bool) {
1319         uint256 blockCur = Math.min(block.number, expiration);
1320         if(nftaddress == legendsAddress && _legendsForgeBlocks[tokenId] > 0){
1321            return (blockCur - _legendsForgeBlocks[tokenId]  > minBlockToClaim);
1322         }
1323         if(nftaddress == padAddress && _padForgeBlocks[tokenId] > 0){
1324            return (blockCur - _padForgeBlocks[tokenId]  > minBlockToClaim);
1325         }
1326         if(nftaddress == tigerAddress && _tigerForgeBlocks[tokenId] > 0){
1327            return (blockCur - _tigerForgeBlocks[tokenId]  > minBlockToClaim);
1328         }
1329         if(nftaddress == cubsAddress && _cubsForgeBlocks[tokenId] > 0){
1330            return (blockCur - _cubsForgeBlocks[tokenId]  > minBlockToClaim);
1331         }
1332         if(nftaddress == fundaeAddress && _fundaeForgeBlocks[tokenId] > 0){
1333            return (blockCur - _fundaeForgeBlocks[tokenId]  > minBlockToClaim);
1334         }
1335         if(nftaddress == azukiAddress && _azukiForgeBlocks[tokenId] > 0){
1336            return (blockCur - _azukiForgeBlocks[tokenId]  > minBlockToClaim);
1337         }
1338        return false;
1339     }
1340 
1341         //reward amount by address/tokenIds[]
1342     function calculateReward(address account, uint256 tokenId,address nftaddress ) 
1343       public 
1344       view 
1345       returns (uint256) 
1346     {
1347         if (nftaddress == legendsAddress){
1348       require(Math.min(block.number, expiration) > _legendsForgeBlocks[tokenId], "Invalid blocks");
1349       return legendsRate * 
1350           (_legendsTokenForges[tokenId] == account ? 1 : 0) * 
1351           (Math.min(block.number, expiration) - 
1352             Math.max(_legendsForgeBlocks[tokenId],_membershipForgeBlocks[account]) );
1353         }
1354         if (nftaddress == tigerAddress){
1355       require(Math.min(block.number, expiration) > _tigerForgeBlocks[tokenId], "Invalid blocks");
1356       return tigerRate * 
1357           (_tigerTokenForges[tokenId] == account ? 1 : 0) * 
1358           (Math.min(block.number, expiration) - 
1359             Math.max(_tigerForgeBlocks[tokenId],_membershipForgeBlocks[account]) );
1360         }
1361         if (nftaddress == cubsAddress){
1362       require(Math.min(block.number, expiration) > _cubsForgeBlocks[tokenId], "Invalid blocks");
1363       return cubsRate * 
1364           (_cubsTokenForges[tokenId] == account ? 1 : 0) * 
1365           (Math.min(block.number, expiration) - 
1366             Math.max(_cubsForgeBlocks[tokenId],_membershipForgeBlocks[account]) );
1367         }
1368         if (nftaddress == padAddress){
1369       require(Math.min(block.number, expiration) > _padForgeBlocks[tokenId], "Invalid blocks");
1370       return padRate * 
1371           (_padTokenForges[tokenId] == account ? 1 : 0) * 
1372           (Math.min(block.number, expiration) - 
1373             Math.max(_padForgeBlocks[tokenId],_membershipForgeBlocks[account]) );
1374         }
1375         if (nftaddress == azukiAddress){
1376       require(Math.min(block.number, expiration) > _azukiForgeBlocks[tokenId], "Invalid blocks");
1377       return azukiRate * 
1378           (_azukiTokenForges[tokenId] == account ? 1 : 0) * 
1379           (Math.min(block.number, expiration) - 
1380             Math.max(_azukiForgeBlocks[tokenId],_membershipForgeBlocks[account]) );
1381         }
1382         return 0;
1383     }
1384 
1385 
1386     //reward claim function 
1387     function ClaimRewards(uint256[] calldata tokenIds, address nftaddress) public whenNotPaused {
1388         uint256 reward; 
1389         uint256 blockCur = Math.min(block.number, expiration);
1390         EnumerableSet.UintSet storage forgeSet = _membershipForges[msg.sender];
1391 
1392         require(forgeSet.length() > 0, "No Membership Forged");
1393 
1394         if (nftaddress==legendsAddress) {
1395                 for (uint256 i; i < tokenIds.length; i++) {
1396                     require(IERC721(legendsAddress).ownerOf(tokenIds[i]) == msg.sender);
1397                     require(blockCur - _legendsForgeBlocks[tokenIds[i]]  > minBlockToClaim);                  
1398                 }
1399 
1400             for (uint256 i; i < tokenIds.length; i++) {
1401                 reward += calculateReward(msg.sender, tokenIds[i],legendsAddress);
1402                 _legendsForgeBlocks[tokenIds[i]] = blockCur;
1403             }
1404 
1405                 for(uint256 i; i < tokenIds.length; ++i) {
1406                     uint256 tokenId = tokenIds[i];
1407                     if(!legendsClaimed[tokenId]) {
1408                         legendsClaimed[tokenId] = true;
1409                         reward += LEGENDS_DISTRIBUTION_AMOUNT;
1410                     }
1411                 }
1412         }
1413 
1414         if(nftaddress==padAddress) {
1415             for (uint256 i; i < tokenIds.length; i++) {
1416                     require(IERC721(padAddress).ownerOf(tokenIds[i]) == msg.sender);
1417                     require(blockCur - _padForgeBlocks[tokenIds[i]]  > minBlockToClaim);                  
1418                 }
1419 
1420             for (uint256 i; i < tokenIds.length; i++) {
1421                 reward += calculateReward(msg.sender, tokenIds[i],padAddress);
1422                 _padForgeBlocks[tokenIds[i]] = blockCur;
1423             }
1424 
1425             for(uint256 i; i < tokenIds.length; ++i) {
1426                     uint256 tokenId = tokenIds[i];
1427                     if(!padClaimed[tokenId]) {
1428                         padClaimed[tokenId] = true;
1429                         reward += PAD_DISTRIBUTION_AMOUNT;
1430                     }
1431                 }
1432 
1433         }
1434 
1435         if(nftaddress==tigerAddress){
1436             for (uint256 i; i < tokenIds.length; i++) {
1437             require(IERC721(tigerAddress).ownerOf(tokenIds[i]) == msg.sender);
1438             require(blockCur - _tigerForgeBlocks[tokenIds[i]]  > minBlockToClaim);
1439             
1440                 }
1441 
1442             for (uint256 i; i < tokenIds.length; i++) {
1443                 reward += calculateReward(msg.sender, tokenIds[i],tigerAddress);
1444                 _tigerForgeBlocks[tokenIds[i]] = blockCur;
1445             }
1446 
1447             for(uint256 i; i < tokenIds.length; ++i) {
1448                     uint256 tokenId = tokenIds[i];
1449                     if(!tigerClaimed[tokenId]) {
1450                         tigerClaimed[tokenId] = true;
1451                         reward += TIGER_DISTRIBUTION_AMOUNT;
1452                     }
1453                 }
1454         }
1455 
1456         if(nftaddress==cubsAddress){
1457             for (uint256 i; i < tokenIds.length; i++) {
1458             require(IERC721(cubsAddress).ownerOf(tokenIds[i]) == msg.sender);
1459             require(blockCur - _cubsForgeBlocks[tokenIds[i]]  > minBlockToClaim);
1460             
1461                 } 
1462 
1463             for (uint256 i; i < tokenIds.length; i++) {
1464                 reward += calculateReward(msg.sender, tokenIds[i],cubsAddress);
1465                 _cubsForgeBlocks[tokenIds[i]] = blockCur;
1466             }
1467 
1468         }
1469 
1470         if (nftaddress==fundaeAddress){
1471             for (uint256 i; i < tokenIds.length; i++) {
1472                     require(IERC721(fundaeAddress).ownerOf(tokenIds[i]) == msg.sender);
1473                     require(blockCur - _fundaeForgeBlocks[tokenIds[i]]  > minBlockToClaim);                    
1474                 }
1475             
1476 
1477             for (uint256 i; i < tokenIds.length; i++) {
1478                 reward += calculateReward(msg.sender, tokenIds[i],fundaeAddress);
1479                 _fundaeForgeBlocks[tokenIds[i]] = blockCur;
1480             }
1481 
1482             for(uint256 i; i < tokenIds.length; ++i) {
1483                     uint256 tokenId = tokenIds[i];
1484                     if(!fundaeClaimed[tokenId]) {
1485                         fundaeClaimed[tokenId] = true;
1486                         reward += FUNDAE_DISTRIBUTION_AMOUNT;
1487                     }
1488                 }
1489         }
1490         
1491         if(nftaddress==azukiAddress){
1492             for (uint256 i; i < tokenIds.length; i++) {
1493                     require(IERC721(azukiAddress).ownerOf(tokenIds[i]) == msg.sender);
1494                     require(blockCur - _azukiForgeBlocks[tokenIds[i]]  > minBlockToClaim);
1495                 }            
1496             for (uint256 i; i < tokenIds.length; i++) {
1497                 reward += calculateReward(msg.sender, tokenIds[i],azukiAddress);
1498                 _azukiForgeBlocks[tokenIds[i]] = blockCur;
1499             }
1500 
1501             for(uint256 i; i < tokenIds.length; ++i) {
1502                     uint256 tokenId = tokenIds[i];
1503                     if(!azukiClaimed[tokenId]) {
1504                         azukiClaimed[tokenId] = true;
1505                         reward += AZUKI_DISTRIBUTION_AMOUNT;
1506                     }
1507                 }
1508         }
1509 
1510       if (reward > 0) {
1511         IERC20(erc20Address).transfer(msg.sender, reward);
1512       }
1513     }
1514 
1515         //forge function. 
1516     function Forge(uint256[] calldata tokenIds,address nftaddress) external whenNotPaused {
1517         uint256 blockCur = block.number;
1518         EnumerableSet.UintSet storage forgeSet = _membershipForges[msg.sender];
1519         require(forgeSet.length() > 0, "No Membership Forged");
1520         for (uint256 i; i < tokenIds.length; i++) {             
1521                 require(IERC721(nftaddress).ownerOf(tokenIds[i]) == msg.sender,"you do not own that NFT");         
1522             }
1523         
1524         if (nftaddress==legendsAddress) {
1525             for (uint256 i; i < tokenIds.length; i++) {  
1526                 require(_legendsTokenForges[tokenIds[i]] != msg.sender);            
1527             }
1528             for (uint256 i; i < tokenIds.length; i++) {
1529                 _legendsTokenForges[tokenIds[i]] = msg.sender;
1530                 _legendsForgeBlocks[tokenIds[i]] = blockCur;
1531             }
1532         }
1533         if (nftaddress==padAddress) {
1534             for (uint256 i; i < tokenIds.length; i++) {
1535             require(_padTokenForges[tokenIds[i]] != msg.sender);
1536             }
1537 
1538             for (uint256 i; i < tokenIds.length; i++) {
1539                 _padTokenForges[tokenIds[i]] = msg.sender;
1540                 _padForgeBlocks[tokenIds[i]] = blockCur;
1541             }
1542         }
1543         if (nftaddress==tigerAddress){
1544             for (uint256 i; i < tokenIds.length; i++) {
1545             require(_tigerTokenForges[tokenIds[i]] != msg.sender);
1546             }
1547             
1548             for (uint256 i; i < tokenIds.length; i++) {
1549                 _tigerTokenForges[tokenIds[i]] = msg.sender;
1550                 _tigerForgeBlocks[tokenIds[i]] = blockCur;
1551             }
1552         }
1553         if (nftaddress==cubsAddress){
1554             for (uint256 i; i < tokenIds.length; i++) {
1555             require(_cubsTokenForges[tokenIds[i]] != msg.sender);
1556             }
1557         
1558             for (uint256 i; i < tokenIds.length; i++) {
1559                 _cubsTokenForges[tokenIds[i]] = msg.sender;
1560                 _cubsForgeBlocks[tokenIds[i]] = blockCur;
1561             }
1562         }
1563         if (nftaddress==fundaeAddress) {
1564             for (uint256 i; i < tokenIds.length; i++) {
1565             require(_fundaeTokenForges[tokenIds[i]] != msg.sender);
1566             }
1567             
1568             for (uint256 i; i < tokenIds.length; i++) {
1569                 _fundaeTokenForges[tokenIds[i]] = msg.sender;
1570                 _fundaeForgeBlocks[tokenIds[i]] = blockCur;
1571             }
1572         }
1573         if (nftaddress==azukiAddress) {
1574             for (uint256 i; i < tokenIds.length; i++) {
1575             require(_azukiTokenForges[tokenIds[i]] != msg.sender);
1576             }
1577             
1578             for (uint256 i; i < tokenIds.length; i++) {
1579                 _azukiTokenForges[tokenIds[i]] = msg.sender;
1580                 _azukiForgeBlocks[tokenIds[i]] = blockCur;
1581             }
1582         }
1583     }
1584 
1585  //check forge amount. 
1586     function membershipForgesOf(address account)
1587       external 
1588       view 
1589       returns (uint256[] memory)
1590     {
1591       EnumerableSet.UintSet storage forgeSet = _membershipForges[account];
1592       uint256[] memory tokenIds = new uint256[] (forgeSet.length());
1593 
1594       for (uint256 i; i < forgeSet.length(); i++) {
1595         tokenIds[i] = forgeSet.at(i);
1596       }
1597 
1598       return tokenIds;
1599     }
1600   
1601     //forge function. 
1602     function membershipForge(uint256[] calldata tokenIds) external whenNotPaused {
1603         uint256 blockCur = block.number;
1604         require(msg.sender != membershipAddress, "Invalid address");
1605 
1606         for (uint256 i; i < tokenIds.length; i++) {
1607             IERC721(membershipAddress).safeTransferFrom(
1608                 msg.sender,
1609                 address(this),
1610                 tokenIds[i],
1611                 ""
1612             );
1613             _membershipForges[msg.sender].add(tokenIds[i]);
1614         }
1615         _membershipForgeBlocks[msg.sender] = blockCur;
1616     }
1617 
1618     //withdrawal function.
1619     function membershipWithdraw(uint256[] calldata tokenIds) external whenNotPaused nonReentrant() {
1620 
1621         for (uint256 i; i < tokenIds.length; i++) {
1622             require(
1623                 _membershipForges[msg.sender].contains(tokenIds[i]),
1624                 "Staking: token not forgeed"
1625             );
1626 
1627             _membershipForges[msg.sender].remove(tokenIds[i]);
1628 
1629             IERC721(membershipAddress).safeTransferFrom(
1630                 address(this),
1631                 msg.sender,
1632                 tokenIds[i],
1633                 ""
1634             );
1635         }
1636     }
1637 
1638     //withdrawal function.
1639     function withdrawTokens() external onlyOwner {
1640         uint256 tokenSupply = IERC20(erc20Address).balanceOf(address(this));
1641         IERC20(erc20Address).transfer(msg.sender, tokenSupply);
1642     }
1643 
1644     function onERC721Received(
1645         address,
1646         address,
1647         uint256,
1648         bytes calldata
1649     ) external pure override returns (bytes4) {
1650         return IERC721Receiver.onERC721Received.selector;
1651     }
1652 
1653    
1654 
1655 }