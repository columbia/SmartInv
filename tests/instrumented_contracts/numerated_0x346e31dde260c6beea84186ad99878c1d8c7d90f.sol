1 // SPDX-License-Identifier: MIT
2 /*
3    .____    .__             .__    .___   ___________
4    |    |   |__| ________ __|__| __| _/   \_   _____/__________  ____   ____
5    |    |   |  |/ ____/  |  \  |/ __ |     |    __)/  _ \_  __ \/ ___\_/ __ \
6    |    |___|  < <_|  |  |  /  / /_/ |     |     \(  <_> )  | \/ /_/  >  ___/
7    |_______ \__|\__   |____/|__\____ |     \___  / \____/|__|  \___  / \___  >
8            \/      |__|             \/         \/             /_____/      \/
9 
10     * Liquid Key Forge Contract for ApeLiquid.io | August 2022 **************
11 */
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Interface of the ERC165 standard, as defined in the
17  * https://eips.ethereum.org/EIPS/eip-165[EIP].
18  *
19  * Implementers can declare support of contract interfaces, which can then be
20  * queried by others ({ERC165Checker}).
21  *
22  * For an implementation, see {ERC165}.
23  */
24 interface IERC165 {
25     /**
26      * @dev Returns true if this contract implements the interface defined by
27      * `interfaceId`. See the corresponding
28      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
29      * to learn more about how these ids are created.
30      *
31      * This function call must use less than 30 000 gas.
32      */
33     function supportsInterface(bytes4 interfaceId) external view returns (bool);
34 }
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(
46         address indexed from,
47         address indexed to,
48         uint256 indexed tokenId
49     );
50 
51     /**
52      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
53      */
54     event Approval(
55         address indexed owner,
56         address indexed approved,
57         uint256 indexed tokenId
58     );
59 
60     /**
61      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
62      */
63     event ApprovalForAll(
64         address indexed owner,
65         address indexed operator,
66         bool approved
67     );
68 
69     /**
70      * @dev Returns the number of tokens in ``owner``'s account.
71      */
72     function balanceOf(address owner) external view returns (uint256 balance);
73 
74     /**
75      * @dev Returns the owner of the `tokenId` token.
76      *
77      * Requirements:
78      *
79      * - `tokenId` must exist.
80      */
81     function ownerOf(uint256 tokenId) external view returns (address owner);
82 
83     /**
84      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
85      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must exist and be owned by `from`.
92      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
93      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
94      *
95      * Emits a {Transfer} event.
96      */
97     function safeTransferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Transfers `tokenId` token from `from` to `to`.
105      *
106      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId)
146         external
147         view
148         returns (address operator);
149 
150     /**
151      * @dev Approve or remove `operator` as an operator for the caller.
152      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
153      *
154      * Requirements:
155      *
156      * - The `operator` cannot be the caller.
157      *
158      * Emits an {ApprovalForAll} event.
159      */
160     function setApprovalForAll(address operator, bool _approved) external;
161 
162     /**
163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
164      *
165      * See {setApprovalForAll}
166      */
167     function isApprovedForAll(address owner, address operator)
168         external
169         view
170         returns (bool);
171 
172     /**
173      * @dev Safely transfers `tokenId` token from `from` to `to`.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId,
189         bytes calldata data
190     ) external;
191 }
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @dev Provides information about the current execution context, including the
197  * sender of the transaction and its data. While these are generally available
198  * via msg.sender and msg.data, they should not be accessed in such a direct
199  * manner, since when dealing with meta-transactions the account sending and
200  * paying for execution may not be the actual sender (as far as an application
201  * is concerned).
202  *
203  * This contract is only required for intermediate, library-like contracts.
204  */
205 abstract contract Context {
206     function _msgSender() internal view virtual returns (address) {
207         return msg.sender;
208     }
209 
210     function _msgData() internal view virtual returns (bytes calldata) {
211         return msg.data;
212     }
213 }
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Interface of the ERC20 standard as defined in the EIP.
219  */
220 interface IERC20 {
221     /**
222      * @dev Returns the amount of tokens in existence.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     /**
227      * @dev Returns the amount of tokens owned by `account`.
228      */
229     function balanceOf(address account) external view returns (uint256);
230 
231     /**
232      * @dev Moves `amount` tokens from the caller's account to `recipient`.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transfer(address recipient, uint256 amount)
239         external
240         returns (bool);
241 
242     /**
243      * @dev Returns the remaining number of tokens that `spender` will be
244      * allowed to spend on behalf of `owner` through {transferFrom}. This is
245      * zero by default.
246      *
247      * This value changes when {approve} or {transferFrom} are called.
248      */
249     function allowance(address owner, address spender)
250         external
251         view
252         returns (uint256);
253 
254     /**
255      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * IMPORTANT: Beware that changing an allowance with this method brings the risk
260      * that someone may use both the old and the new allowance by unfortunate
261      * transaction ordering. One possible solution to mitigate this race
262      * condition is to first reduce the spender's allowance to 0 and set the
263      * desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address spender, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Moves `amount` tokens from `sender` to `recipient` using the
272      * allowance mechanism. `amount` is then deducted from the caller's
273      * allowance.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) external returns (bool);
284 
285     /**
286      * @dev Emitted when `value` tokens are moved from one account (`from`) to
287      * another (`to`).
288      *
289      * Note that `value` may be zero.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     /**
294      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
295      * a call to {approve}. `value` is the new allowance.
296      */
297     event Approval(
298         address indexed owner,
299         address indexed spender,
300         uint256 value
301     );
302 }
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Contract module which allows children to implement an emergency stop
308  * mechanism that can be triggered by an authorized account.
309  *
310  * This module is used through inheritance. It will make available the
311  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
312  * the functions of your contract. Note that they will not be pausable by
313  * simply including this module, only once the modifiers are put in place.
314  */
315 abstract contract Pausable is Context {
316     /**
317      * @dev Emitted when the pause is triggered by `account`.
318      */
319     event Paused(address account);
320 
321     /**
322      * @dev Emitted when the pause is lifted by `account`.
323      */
324     event Unpaused(address account);
325 
326     bool private _paused;
327 
328     /**
329      * @dev Initializes the contract in unpaused state.
330      */
331     constructor() {
332         _paused = false;
333     }
334 
335     /**
336      * @dev Returns true if the contract is paused, and false otherwise.
337      */
338     function paused() public view virtual returns (bool) {
339         return _paused;
340     }
341 
342     /**
343      * @dev Modifier to make a function callable only when the contract is not paused.
344      *
345      * Requirements:
346      *
347      * - The contract must not be paused.
348      */
349     modifier whenNotPaused() {
350         require(!paused(), "Pausable: paused");
351         _;
352     }
353 
354     /**
355      * @dev Modifier to make a function callable only when the contract is paused.
356      *
357      * Requirements:
358      *
359      * - The contract must be paused.
360      */
361     modifier whenPaused() {
362         require(paused(), "Pausable: not paused");
363         _;
364     }
365 
366     /**
367      * @dev Triggers stopped state.
368      *
369      * Requirements:
370      *
371      * - The contract must not be paused.
372      */
373     function _pause() internal virtual whenNotPaused {
374         _paused = true;
375         emit Paused(_msgSender());
376     }
377 
378     /**
379      * @dev Returns to normal state.
380      *
381      * Requirements:
382      *
383      * - The contract must be paused.
384      */
385     function _unpause() internal virtual whenPaused {
386         _paused = false;
387         emit Unpaused(_msgSender());
388     }
389 }
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev Standard math utilities missing in the Solidity language.
395  */
396 library Math {
397     /**
398      * @dev Returns the largest of two numbers.
399      */
400     function max(uint256 a, uint256 b) internal pure returns (uint256) {
401         return a >= b ? a : b;
402     }
403 
404     /**
405      * @dev Returns the smallest of two numbers.
406      */
407     function min(uint256 a, uint256 b) internal pure returns (uint256) {
408         return a < b ? a : b;
409     }
410 
411     /**
412      * @dev Returns the average of two numbers. The result is rounded towards
413      * zero.
414      */
415     function average(uint256 a, uint256 b) internal pure returns (uint256) {
416         // (a + b) / 2 can overflow.
417         return (a & b) + (a ^ b) / 2;
418     }
419 
420     /**
421      * @dev Returns the ceiling of the division of two numbers.
422      *
423      * This differs from standard division with `/` in that it rounds up instead
424      * of rounding down.
425      */
426     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
427         // (a + b - 1) / b can overflow on addition, so we distribute.
428         return a / b + (a % b == 0 ? 0 : 1);
429     }
430 }
431 
432 pragma solidity ^0.8.0;
433 
434 /**
435  * @dev Contract module that helps prevent reentrant calls to a function.
436  *
437  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
438  * available, which can be applied to functions to make sure there are no nested
439  * (reentrant) calls to them.
440  *
441  * Note that because there is a single `nonReentrant` guard, functions marked as
442  * `nonReentrant` may not call one another. This can be worked around by making
443  * those functions `private`, and then adding `external` `nonReentrant` entry
444  * points to them.
445  *
446  * TIP: If you would like to learn more about reentrancy and alternative ways
447  * to protect against it, check out our blog post
448  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
449  */
450 abstract contract ReentrancyGuard {
451     // Booleans are more expensive than uint256 or any type that takes up a full
452     // word because each write operation emits an extra SLOAD to first read the
453     // slot's contents, replace the bits taken up by the boolean, and then write
454     // back. This is the compiler's defense against contract upgrades and
455     // pointer aliasing, and it cannot be disabled.
456 
457     // The values being non-zero value makes deployment a bit more expensive,
458     // but in exchange the refund on every call to nonReentrant will be lower in
459     // amount. Since refunds are capped to a percentage of the total
460     // transaction's gas, it is best to keep them low in cases like this one, to
461     // increase the likelihood of the full refund coming into effect.
462     uint256 private constant _NOT_ENTERED = 1;
463     uint256 private constant _ENTERED = 2;
464 
465     uint256 private _status;
466 
467     constructor() {
468         _status = _NOT_ENTERED;
469     }
470 
471     /**
472      * @dev Prevents a contract from calling itself, directly or indirectly.
473      * Calling a `nonReentrant` function from another `nonReentrant`
474      * function is not supported. It is possible to prevent this from happening
475      * by making the `nonReentrant` function external, and make it call a
476      * `private` function that does the actual work.
477      */
478     modifier nonReentrant() {
479         // On the first call to nonReentrant, _notEntered will be true
480         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
481 
482         // Any calls to nonReentrant after this point will fail
483         _status = _ENTERED;
484 
485         _;
486 
487         // By storing the original value once again, a refund is triggered (see
488         // https://eips.ethereum.org/EIPS/eip-2200)
489         _status = _NOT_ENTERED;
490     }
491 }
492 
493 pragma solidity ^0.8.0;
494 
495 /**
496  * @dev Library for managing
497  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
498  * types.
499  *
500  * Sets have the following properties:
501  *
502  * - Elements are added, removed, and checked for existence in constant time
503  * (O(1)).
504  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
505  *
506  * ```
507  * contract Example {
508  *     // Add the library methods
509  *     using EnumerableSet for EnumerableSet.AddressSet;
510  *
511  *     // Declare a set state variable
512  *     EnumerableSet.AddressSet private mySet;
513  * }
514  * ```
515  *
516  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
517  * and `uint256` (`UintSet`) are supported.
518  */
519 library EnumerableSet {
520     // To implement this library for multiple types with as little code
521     // repetition as possible, we write it in terms of a generic Set type with
522     // bytes32 values.
523     // The Set implementation uses private functions, and user-facing
524     // implementations (such as AddressSet) are just wrappers around the
525     // underlying Set.
526     // This means that we can only create new EnumerableSets for types that fit
527     // in bytes32.
528 
529     struct Set {
530         // Storage of set values
531         bytes32[] _values;
532         // Position of the value in the `values` array, plus 1 because index 0
533         // means a value is not in the set.
534         mapping(bytes32 => uint256) _indexes;
535     }
536 
537     /**
538      * @dev Add a value to a set. O(1).
539      *
540      * Returns true if the value was added to the set, that is if it was not
541      * already present.
542      */
543     function _add(Set storage set, bytes32 value) private returns (bool) {
544         if (!_contains(set, value)) {
545             set._values.push(value);
546             // The value is stored at length-1, but we add 1 to all indexes
547             // and use 0 as a sentinel value
548             set._indexes[value] = set._values.length;
549             return true;
550         } else {
551             return false;
552         }
553     }
554 
555     /**
556      * @dev Removes a value from a set. O(1).
557      *
558      * Returns true if the value was removed from the set, that is if it was
559      * present.
560      */
561     function _remove(Set storage set, bytes32 value) private returns (bool) {
562         // We read and store the value's index to prevent multiple reads from the same storage slot
563         uint256 valueIndex = set._indexes[value];
564 
565         if (valueIndex != 0) {
566             // Equivalent to contains(set, value)
567             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
568             // the array, and then remove the last element (sometimes called as 'swap and pop').
569             // This modifies the order of the array, as noted in {at}.
570 
571             uint256 toDeleteIndex = valueIndex - 1;
572             uint256 lastIndex = set._values.length - 1;
573 
574             if (lastIndex != toDeleteIndex) {
575                 bytes32 lastvalue = set._values[lastIndex];
576 
577                 // Move the last value to the index where the value to delete is
578                 set._values[toDeleteIndex] = lastvalue;
579                 // Update the index for the moved value
580                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
581             }
582 
583             // Delete the slot where the moved value was stored
584             set._values.pop();
585 
586             // Delete the index for the deleted slot
587             delete set._indexes[value];
588 
589             return true;
590         } else {
591             return false;
592         }
593     }
594 
595     /**
596      * @dev Returns true if the value is in the set. O(1).
597      */
598     function _contains(Set storage set, bytes32 value)
599         private
600         view
601         returns (bool)
602     {
603         return set._indexes[value] != 0;
604     }
605 
606     /**
607      * @dev Returns the number of values on the set. O(1).
608      */
609     function _length(Set storage set) private view returns (uint256) {
610         return set._values.length;
611     }
612 
613     /**
614      * @dev Returns the value stored at position `index` in the set. O(1).
615      *
616      * Note that there are no guarantees on the ordering of values inside the
617      * array, and it may change when more values are added or removed.
618      *
619      * Requirements:
620      *
621      * - `index` must be strictly less than {length}.
622      */
623     function _at(Set storage set, uint256 index)
624         private
625         view
626         returns (bytes32)
627     {
628         return set._values[index];
629     }
630 
631     /**
632      * @dev Return the entire set in an array
633      *
634      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
635      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
636      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
637      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
638      */
639     function _values(Set storage set) private view returns (bytes32[] memory) {
640         return set._values;
641     }
642 
643     // Bytes32Set
644 
645     struct Bytes32Set {
646         Set _inner;
647     }
648 
649     /**
650      * @dev Add a value to a set. O(1).
651      *
652      * Returns true if the value was added to the set, that is if it was not
653      * already present.
654      */
655     function add(Bytes32Set storage set, bytes32 value)
656         internal
657         returns (bool)
658     {
659         return _add(set._inner, value);
660     }
661 
662     /**
663      * @dev Removes a value from a set. O(1).
664      *
665      * Returns true if the value was removed from the set, that is if it was
666      * present.
667      */
668     function remove(Bytes32Set storage set, bytes32 value)
669         internal
670         returns (bool)
671     {
672         return _remove(set._inner, value);
673     }
674 
675     /**
676      * @dev Returns true if the value is in the set. O(1).
677      */
678     function contains(Bytes32Set storage set, bytes32 value)
679         internal
680         view
681         returns (bool)
682     {
683         return _contains(set._inner, value);
684     }
685 
686     /**
687      * @dev Returns the number of values in the set. O(1).
688      */
689     function length(Bytes32Set storage set) internal view returns (uint256) {
690         return _length(set._inner);
691     }
692 
693     /**
694      * @dev Returns the value stored at position `index` in the set. O(1).
695      *
696      * Note that there are no guarantees on the ordering of values inside the
697      * array, and it may change when more values are added or removed.
698      *
699      * Requirements:
700      *
701      * - `index` must be strictly less than {length}.
702      */
703     function at(Bytes32Set storage set, uint256 index)
704         internal
705         view
706         returns (bytes32)
707     {
708         return _at(set._inner, index);
709     }
710 
711     /**
712      * @dev Return the entire set in an array
713      *
714      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
715      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
716      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
717      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
718      */
719     function values(Bytes32Set storage set)
720         internal
721         view
722         returns (bytes32[] memory)
723     {
724         return _values(set._inner);
725     }
726 
727     // AddressSet
728 
729     struct AddressSet {
730         Set _inner;
731     }
732 
733     /**
734      * @dev Add a value to a set. O(1).
735      *
736      * Returns true if the value was added to the set, that is if it was not
737      * already present.
738      */
739     function add(AddressSet storage set, address value)
740         internal
741         returns (bool)
742     {
743         return _add(set._inner, bytes32(uint256(uint160(value))));
744     }
745 
746     /**
747      * @dev Removes a value from a set. O(1).
748      *
749      * Returns true if the value was removed from the set, that is if it was
750      * present.
751      */
752     function remove(AddressSet storage set, address value)
753         internal
754         returns (bool)
755     {
756         return _remove(set._inner, bytes32(uint256(uint160(value))));
757     }
758 
759     /**
760      * @dev Returns true if the value is in the set. O(1).
761      */
762     function contains(AddressSet storage set, address value)
763         internal
764         view
765         returns (bool)
766     {
767         return _contains(set._inner, bytes32(uint256(uint160(value))));
768     }
769 
770     /**
771      * @dev Returns the number of values in the set. O(1).
772      */
773     function length(AddressSet storage set) internal view returns (uint256) {
774         return _length(set._inner);
775     }
776 
777     /**
778      * @dev Returns the value stored at position `index` in the set. O(1).
779      *
780      * Note that there are no guarantees on the ordering of values inside the
781      * array, and it may change when more values are added or removed.
782      *
783      * Requirements:
784      *
785      * - `index` must be strictly less than {length}.
786      */
787     function at(AddressSet storage set, uint256 index)
788         internal
789         view
790         returns (address)
791     {
792         return address(uint160(uint256(_at(set._inner, index))));
793     }
794 
795     /**
796      * @dev Return the entire set in an array
797      *
798      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
799      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
800      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
801      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
802      */
803     function values(AddressSet storage set)
804         internal
805         view
806         returns (address[] memory)
807     {
808         bytes32[] memory store = _values(set._inner);
809         address[] memory result;
810 
811         assembly {
812             result := store
813         }
814 
815         return result;
816     }
817 
818     // UintSet
819 
820     struct UintSet {
821         Set _inner;
822     }
823 
824     /**
825      * @dev Add a value to a set. O(1).
826      *
827      * Returns true if the value was added to the set, that is if it was not
828      * already present.
829      */
830     function add(UintSet storage set, uint256 value) internal returns (bool) {
831         return _add(set._inner, bytes32(value));
832     }
833 
834     /**
835      * @dev Removes a value from a set. O(1).
836      *
837      * Returns true if the value was removed from the set, that is if it was
838      * present.
839      */
840     function remove(UintSet storage set, uint256 value)
841         internal
842         returns (bool)
843     {
844         return _remove(set._inner, bytes32(value));
845     }
846 
847     /**
848      * @dev Returns true if the value is in the set. O(1).
849      */
850     function contains(UintSet storage set, uint256 value)
851         internal
852         view
853         returns (bool)
854     {
855         return _contains(set._inner, bytes32(value));
856     }
857 
858     /**
859      * @dev Returns the number of values on the set. O(1).
860      */
861     function length(UintSet storage set) internal view returns (uint256) {
862         return _length(set._inner);
863     }
864 
865     /**
866      * @dev Returns the value stored at position `index` in the set. O(1).
867      *
868      * Note that there are no guarantees on the ordering of values inside the
869      * array, and it may change when more values are added or removed.
870      *
871      * Requirements:
872      *
873      * - `index` must be strictly less than {length}.
874      */
875     function at(UintSet storage set, uint256 index)
876         internal
877         view
878         returns (uint256)
879     {
880         return uint256(_at(set._inner, index));
881     }
882 
883     /**
884      * @dev Return the entire set in an array
885      *
886      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
887      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
888      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
889      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
890      */
891     function values(UintSet storage set)
892         internal
893         view
894         returns (uint256[] memory)
895     {
896         bytes32[] memory store = _values(set._inner);
897         uint256[] memory result;
898 
899         assembly {
900             result := store
901         }
902 
903         return result;
904     }
905 }
906 
907 pragma solidity ^0.8.0;
908 
909 /**
910  * @title ERC721 token receiver interface
911  * @dev Interface for any contract that wants to support safeTransfers
912  * from ERC721 asset contracts.
913  */
914 interface IERC721Receiver {
915     /**
916      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
917      * by `operator` from `from`, this function is called.
918      *
919      * It must return its Solidity selector to confirm the token transfer.
920      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
921      *
922      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
923      */
924     function onERC721Received(
925         address operator,
926         address from,
927         uint256 tokenId,
928         bytes calldata data
929     ) external returns (bytes4);
930 }
931 
932 pragma solidity ^0.8.0;
933 
934 /**
935  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
936  * @dev See https://eips.ethereum.org/EIPS/eip-721
937  */
938 interface IERC721Enumerable is IERC721 {
939     /**
940      * @dev Returns the total amount of tokens stored by the contract.
941      */
942     function totalSupply() external view returns (uint256);
943 
944     /**
945      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
946      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
947      */
948     function tokenOfOwnerByIndex(address owner, uint256 index)
949         external
950         view
951         returns (uint256 tokenId);
952 
953     /**
954      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
955      * Use along with {totalSupply} to enumerate all tokens.
956      */
957     function tokenByIndex(uint256 index) external view returns (uint256);
958 }
959 
960 pragma solidity ^0.8.0;
961 
962 // CAUTION
963 // This version of SafeMath should only be used with Solidity 0.8 or later,
964 // because it relies on the compiler's built in overflow checks.
965 
966 /**
967  * @dev Wrappers over Solidity's arithmetic operations.
968  *
969  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
970  * now has built in overflow checking.
971  */
972 library SafeMath {
973     /**
974      * @dev Returns the addition of two unsigned integers, with an overflow flag.
975      *
976      * _Available since v3.4._
977      */
978     function tryAdd(uint256 a, uint256 b)
979         internal
980         pure
981         returns (bool, uint256)
982     {
983         unchecked {
984             uint256 c = a + b;
985             if (c < a) return (false, 0);
986             return (true, c);
987         }
988     }
989 
990     /**
991      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
992      *
993      * _Available since v3.4._
994      */
995     function trySub(uint256 a, uint256 b)
996         internal
997         pure
998         returns (bool, uint256)
999     {
1000         unchecked {
1001             if (b > a) return (false, 0);
1002             return (true, a - b);
1003         }
1004     }
1005 
1006     /**
1007      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1008      *
1009      * _Available since v3.4._
1010      */
1011     function tryMul(uint256 a, uint256 b)
1012         internal
1013         pure
1014         returns (bool, uint256)
1015     {
1016         unchecked {
1017             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1018             // benefit is lost if 'b' is also tested.
1019             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1020             if (a == 0) return (true, 0);
1021             uint256 c = a * b;
1022             if (c / a != b) return (false, 0);
1023             return (true, c);
1024         }
1025     }
1026 
1027     /**
1028      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1029      *
1030      * _Available since v3.4._
1031      */
1032     function tryDiv(uint256 a, uint256 b)
1033         internal
1034         pure
1035         returns (bool, uint256)
1036     {
1037         unchecked {
1038             if (b == 0) return (false, 0);
1039             return (true, a / b);
1040         }
1041     }
1042 
1043     /**
1044      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1045      *
1046      * _Available since v3.4._
1047      */
1048     function tryMod(uint256 a, uint256 b)
1049         internal
1050         pure
1051         returns (bool, uint256)
1052     {
1053         unchecked {
1054             if (b == 0) return (false, 0);
1055             return (true, a % b);
1056         }
1057     }
1058 
1059     /**
1060      * @dev Returns the addition of two unsigned integers, reverting on
1061      * overflow.
1062      *
1063      * Counterpart to Solidity's `+` operator.
1064      *
1065      * Requirements:
1066      *
1067      * - Addition cannot overflow.
1068      */
1069     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1070         return a + b;
1071     }
1072 
1073     /**
1074      * @dev Returns the subtraction of two unsigned integers, reverting on
1075      * overflow (when the result is negative).
1076      *
1077      * Counterpart to Solidity's `-` operator.
1078      *
1079      * Requirements:
1080      *
1081      * - Subtraction cannot overflow.
1082      */
1083     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1084         return a - b;
1085     }
1086 
1087     /**
1088      * @dev Returns the multiplication of two unsigned integers, reverting on
1089      * overflow.
1090      *
1091      * Counterpart to Solidity's `*` operator.
1092      *
1093      * Requirements:
1094      *
1095      * - Multiplication cannot overflow.
1096      */
1097     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1098         return a * b;
1099     }
1100 
1101     /**
1102      * @dev Returns the integer division of two unsigned integers, reverting on
1103      * division by zero. The result is rounded towards zero.
1104      *
1105      * Counterpart to Solidity's `/` operator.
1106      *
1107      * Requirements:
1108      *
1109      * - The divisor cannot be zero.
1110      */
1111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1112         return a / b;
1113     }
1114 
1115     /**
1116      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1117      * reverting when dividing by zero.
1118      *
1119      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1120      * opcode (which leaves remaining gas untouched) while Solidity uses an
1121      * invalid opcode to revert (consuming all remaining gas).
1122      *
1123      * Requirements:
1124      *
1125      * - The divisor cannot be zero.
1126      */
1127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1128         return a % b;
1129     }
1130 
1131     /**
1132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1133      * overflow (when the result is negative).
1134      *
1135      * CAUTION: This function is deprecated because it requires allocating memory for the error
1136      * message unnecessarily. For custom revert reasons use {trySub}.
1137      *
1138      * Counterpart to Solidity's `-` operator.
1139      *
1140      * Requirements:
1141      *
1142      * - Subtraction cannot overflow.
1143      */
1144     function sub(
1145         uint256 a,
1146         uint256 b,
1147         string memory errorMessage
1148     ) internal pure returns (uint256) {
1149         unchecked {
1150             require(b <= a, errorMessage);
1151             return a - b;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1157      * division by zero. The result is rounded towards zero.
1158      *
1159      * Counterpart to Solidity's `/` operator. Note: this function uses a
1160      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1161      * uses an invalid opcode to revert (consuming all remaining gas).
1162      *
1163      * Requirements:
1164      *
1165      * - The divisor cannot be zero.
1166      */
1167     function div(
1168         uint256 a,
1169         uint256 b,
1170         string memory errorMessage
1171     ) internal pure returns (uint256) {
1172         unchecked {
1173             require(b > 0, errorMessage);
1174             return a / b;
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1180      * reverting with custom message when dividing by zero.
1181      *
1182      * CAUTION: This function is deprecated because it requires allocating memory for the error
1183      * message unnecessarily. For custom revert reasons use {tryMod}.
1184      *
1185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1186      * opcode (which leaves remaining gas untouched) while Solidity uses an
1187      * invalid opcode to revert (consuming all remaining gas).
1188      *
1189      * Requirements:
1190      *
1191      * - The divisor cannot be zero.
1192      */
1193     function mod(
1194         uint256 a,
1195         uint256 b,
1196         string memory errorMessage
1197     ) internal pure returns (uint256) {
1198         unchecked {
1199             require(b > 0, errorMessage);
1200             return a % b;
1201         }
1202     }
1203 }
1204 
1205 pragma solidity ^0.8.0;
1206 
1207 /**
1208  * @dev Contract module which provides a basic access control mechanism, where
1209  * there is an account (an owner) that can be granted exclusive access to
1210  * specific functions.
1211  *
1212  * By default, the owner account will be the one that deploys the contract. This
1213  * can later be changed with {transferOwnership}.
1214  *
1215  * This module is used through inheritance. It will make available the modifier
1216  * `onlyOwner`, which can be applied to your functions to restrict their use to
1217  * the owner.
1218  */
1219 abstract contract Ownable is Context {
1220     address private _owner;
1221 
1222     event OwnershipTransferred(
1223         address indexed previousOwner,
1224         address indexed newOwner
1225     );
1226 
1227     /**
1228      * @dev Initializes the contract setting the deployer as the initial owner.
1229      */
1230     constructor() {
1231         _setOwner(_msgSender());
1232     }
1233 
1234     /**
1235      * @dev Returns the address of the current owner.
1236      */
1237     function owner() public view virtual returns (address) {
1238         return _owner;
1239     }
1240 
1241     /**
1242      * @dev Throws if called by any account other than the owner.
1243      */
1244     modifier onlyOwner() {
1245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1246         _;
1247     }
1248 
1249     /**
1250      * @dev Leaves the contract without owner. It will not be possible to call
1251      * `onlyOwner` functions anymore. Can only be called by the current owner.
1252      *
1253      * NOTE: Renouncing ownership will leave the contract without an owner,
1254      * thereby removing any functionality that is only available to the owner.
1255      */
1256     function renounceOwnership() public virtual onlyOwner {
1257         _setOwner(address(0));
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Can only be called by the current owner.
1263      */
1264     function transferOwnership(address newOwner) public virtual onlyOwner {
1265         require(
1266             newOwner != address(0),
1267             "Ownable: new owner is the zero address"
1268         );
1269         _setOwner(newOwner);
1270     }
1271 
1272     function _setOwner(address newOwner) private {
1273         address oldOwner = _owner;
1274         _owner = newOwner;
1275         emit OwnershipTransferred(oldOwner, newOwner);
1276     }
1277 }
1278 
1279 pragma solidity ^0.8.0;
1280 
1281 contract LiquidKeyForge is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1282     using EnumerableSet for EnumerableSet.UintSet;
1283 
1284     // addresses for Liquid Key & METL token
1285     address public liquidKeyAddress = 0x753412F4FB7245BCF1c0714fDf59ba89110f39b8;
1286     address public erc20Address = 0xFcbE615dEf610E806BB64427574A2c5c1fB55510;
1287 
1288     // address public liquidRecoveryAddress;
1289 
1290     mapping(address => EnumerableSet.UintSet) private _liquidKeyForges;
1291     mapping(address => uint256) public _liquidKeyForgeBlocks;
1292 
1293     function pause() public onlyOwner {
1294         _pause();
1295     }
1296 
1297     function unpause() public onlyOwner {
1298         _unpause();
1299     }
1300 
1301     // Check which Key is forged
1302     function forgedKeyOwnerAddress(address account)
1303         external
1304         view
1305         returns (uint256[] memory)
1306     {
1307         EnumerableSet.UintSet storage forgeSet = _liquidKeyForges[account];
1308         uint256[] memory tokenIds = new uint256[](forgeSet.length());
1309 
1310         for (uint256 i; i < forgeSet.length(); i++) {
1311             tokenIds[i] = forgeSet.at(i);
1312         }
1313 
1314         return tokenIds;
1315     }
1316 
1317     // Forge Liquid Key
1318     function forgeLiquidKey(uint256[] calldata tokenIds)
1319         external
1320         whenNotPaused
1321     {
1322         uint256 blockCur = block.number;
1323         require(msg.sender != liquidKeyAddress, "Invalid address");
1324 
1325         for (uint256 i; i < tokenIds.length; i++) {
1326             IERC721(liquidKeyAddress).safeTransferFrom(
1327                 msg.sender,
1328                 address(this),
1329                 tokenIds[i],
1330                 "Transfer from Member to Forge"
1331             );
1332             _liquidKeyForges[msg.sender].add(tokenIds[i]);
1333         }
1334         _liquidKeyForgeBlocks[msg.sender] = blockCur;
1335     }
1336 
1337     // Remove Liquid Key from Forge
1338     function removeLiquidKey(uint256[] calldata tokenIds)
1339         external
1340         whenNotPaused
1341         nonReentrant
1342     {
1343         for (uint256 i; i < tokenIds.length; i++) {
1344             require(
1345                 _liquidKeyForges[msg.sender].contains(tokenIds[i]),
1346                 "Forge: Key NOT Forged"
1347             );
1348 
1349             _liquidKeyForges[msg.sender].remove(tokenIds[i]);
1350 
1351             IERC721(liquidKeyAddress).safeTransferFrom(
1352                 address(this),
1353                 msg.sender,
1354                 tokenIds[i],
1355                 "Transfer from Forge to Member"
1356             );
1357         }
1358     }
1359 
1360     // Withdraw keys (backdoor)
1361     function withdrawKeysBackdoor(uint256 tokenId)
1362         external
1363         whenNotPaused
1364         nonReentrant
1365     {
1366         require(
1367             tokenId > 9999,
1368             "You really think we would add a backdoor? lol"
1369         );
1370         return;
1371     }
1372 
1373     // Withdraw all ERC20 tokens (METL)
1374     function withdrawTokens() external onlyOwner {
1375         uint256 tokenSupply = IERC20(erc20Address).balanceOf(address(this));
1376         IERC20(erc20Address).transfer(msg.sender, tokenSupply);
1377     }
1378 
1379     function onERC721Received(
1380         address,
1381         address,
1382         uint256,
1383         bytes calldata
1384     ) external pure override returns (bytes4) {
1385         return IERC721Receiver.onERC721Received.selector;
1386     }
1387 }