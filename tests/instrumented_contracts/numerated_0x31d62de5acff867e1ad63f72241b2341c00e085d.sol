1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 // File: @openzeppelin/contracts/utils/math/Math.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.0 (utils/math/Math.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Standard math utilities missing in the Solidity language.
97  */
98 library Math {
99     /**
100      * @dev Returns the largest of two numbers.
101      */
102     function max(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a >= b ? a : b;
104     }
105 
106     /**
107      * @dev Returns the smallest of two numbers.
108      */
109     function min(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a < b ? a : b;
111     }
112 
113     /**
114      * @dev Returns the average of two numbers. The result is rounded towards
115      * zero.
116      */
117     function average(uint256 a, uint256 b) internal pure returns (uint256) {
118         // (a + b) / 2 can overflow.
119         return (a & b) + (a ^ b) / 2;
120     }
121 
122     /**
123      * @dev Returns the ceiling of the division of two numbers.
124      *
125      * This differs from standard division with `/` in that it rounds up instead
126      * of rounding down.
127      */
128     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
129         // (a + b - 1) / b can overflow on addition, so we distribute.
130         return a / b + (a % b == 0 ? 0 : 1);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Contract module that helps prevent reentrant calls to a function.
143  *
144  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
145  * available, which can be applied to functions to make sure there are no nested
146  * (reentrant) calls to them.
147  *
148  * Note that because there is a single `nonReentrant` guard, functions marked as
149  * `nonReentrant` may not call one another. This can be worked around by making
150  * those functions `private`, and then adding `external` `nonReentrant` entry
151  * points to them.
152  *
153  * TIP: If you would like to learn more about reentrancy and alternative ways
154  * to protect against it, check out our blog post
155  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
156  */
157 abstract contract ReentrancyGuard {
158     // Booleans are more expensive than uint256 or any type that takes up a full
159     // word because each write operation emits an extra SLOAD to first read the
160     // slot's contents, replace the bits taken up by the boolean, and then write
161     // back. This is the compiler's defense against contract upgrades and
162     // pointer aliasing, and it cannot be disabled.
163 
164     // The values being non-zero value makes deployment a bit more expensive,
165     // but in exchange the refund on every call to nonReentrant will be lower in
166     // amount. Since refunds are capped to a percentage of the total
167     // transaction's gas, it is best to keep them low in cases like this one, to
168     // increase the likelihood of the full refund coming into effect.
169     uint256 private constant _NOT_ENTERED = 1;
170     uint256 private constant _ENTERED = 2;
171 
172     uint256 private _status;
173 
174     constructor() {
175         _status = _NOT_ENTERED;
176     }
177 
178     /**
179      * @dev Prevents a contract from calling itself, directly or indirectly.
180      * Calling a `nonReentrant` function from another `nonReentrant`
181      * function is not supported. It is possible to prevent this from happening
182      * by making the `nonReentrant` function external, and making it call a
183      * `private` function that does the actual work.
184      */
185     modifier nonReentrant() {
186         // On the first call to nonReentrant, _notEntered will be true
187         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
188 
189         // Any calls to nonReentrant after this point will fail
190         _status = _ENTERED;
191 
192         _;
193 
194         // By storing the original value once again, a refund is triggered (see
195         // https://eips.ethereum.org/EIPS/eip-2200)
196         _status = _NOT_ENTERED;
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.0 (utils/structs/EnumerableSet.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Library for managing
209  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
210  * types.
211  *
212  * Sets have the following properties:
213  *
214  * - Elements are added, removed, and checked for existence in constant time
215  * (O(1)).
216  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
217  *
218  * ```
219  * contract Example {
220  *     // Add the library methods
221  *     using EnumerableSet for EnumerableSet.AddressSet;
222  *
223  *     // Declare a set state variable
224  *     EnumerableSet.AddressSet private mySet;
225  * }
226  * ```
227  *
228  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
229  * and `uint256` (`UintSet`) are supported.
230  */
231 library EnumerableSet {
232     // To implement this library for multiple types with as little code
233     // repetition as possible, we write it in terms of a generic Set type with
234     // bytes32 values.
235     // The Set implementation uses private functions, and user-facing
236     // implementations (such as AddressSet) are just wrappers around the
237     // underlying Set.
238     // This means that we can only create new EnumerableSets for types that fit
239     // in bytes32.
240 
241     struct Set {
242         // Storage of set values
243         bytes32[] _values;
244         // Position of the value in the `values` array, plus 1 because index 0
245         // means a value is not in the set.
246         mapping(bytes32 => uint256) _indexes;
247     }
248 
249     /**
250      * @dev Add a value to a set. O(1).
251      *
252      * Returns true if the value was added to the set, that is if it was not
253      * already present.
254      */
255     function _add(Set storage set, bytes32 value) private returns (bool) {
256         if (!_contains(set, value)) {
257             set._values.push(value);
258             // The value is stored at length-1, but we add 1 to all indexes
259             // and use 0 as a sentinel value
260             set._indexes[value] = set._values.length;
261             return true;
262         } else {
263             return false;
264         }
265     }
266 
267     /**
268      * @dev Removes a value from a set. O(1).
269      *
270      * Returns true if the value was removed from the set, that is if it was
271      * present.
272      */
273     function _remove(Set storage set, bytes32 value) private returns (bool) {
274         // We read and store the value's index to prevent multiple reads from the same storage slot
275         uint256 valueIndex = set._indexes[value];
276 
277         if (valueIndex != 0) {
278             // Equivalent to contains(set, value)
279             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
280             // the array, and then remove the last element (sometimes called as 'swap and pop').
281             // This modifies the order of the array, as noted in {at}.
282 
283             uint256 toDeleteIndex = valueIndex - 1;
284             uint256 lastIndex = set._values.length - 1;
285 
286             if (lastIndex != toDeleteIndex) {
287                 bytes32 lastvalue = set._values[lastIndex];
288 
289                 // Move the last value to the index where the value to delete is
290                 set._values[toDeleteIndex] = lastvalue;
291                 // Update the index for the moved value
292                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
293             }
294 
295             // Delete the slot where the moved value was stored
296             set._values.pop();
297 
298             // Delete the index for the deleted slot
299             delete set._indexes[value];
300 
301             return true;
302         } else {
303             return false;
304         }
305     }
306 
307     /**
308      * @dev Returns true if the value is in the set. O(1).
309      */
310     function _contains(Set storage set, bytes32 value) private view returns (bool) {
311         return set._indexes[value] != 0;
312     }
313 
314     /**
315      * @dev Returns the number of values on the set. O(1).
316      */
317     function _length(Set storage set) private view returns (uint256) {
318         return set._values.length;
319     }
320 
321     /**
322      * @dev Returns the value stored at position `index` in the set. O(1).
323      *
324      * Note that there are no guarantees on the ordering of values inside the
325      * array, and it may change when more values are added or removed.
326      *
327      * Requirements:
328      *
329      * - `index` must be strictly less than {length}.
330      */
331     function _at(Set storage set, uint256 index) private view returns (bytes32) {
332         return set._values[index];
333     }
334 
335     /**
336      * @dev Return the entire set in an array
337      *
338      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
339      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
340      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
341      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
342      */
343     function _values(Set storage set) private view returns (bytes32[] memory) {
344         return set._values;
345     }
346 
347     // Bytes32Set
348 
349     struct Bytes32Set {
350         Set _inner;
351     }
352 
353     /**
354      * @dev Add a value to a set. O(1).
355      *
356      * Returns true if the value was added to the set, that is if it was not
357      * already present.
358      */
359     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
360         return _add(set._inner, value);
361     }
362 
363     /**
364      * @dev Removes a value from a set. O(1).
365      *
366      * Returns true if the value was removed from the set, that is if it was
367      * present.
368      */
369     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
370         return _remove(set._inner, value);
371     }
372 
373     /**
374      * @dev Returns true if the value is in the set. O(1).
375      */
376     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
377         return _contains(set._inner, value);
378     }
379 
380     /**
381      * @dev Returns the number of values in the set. O(1).
382      */
383     function length(Bytes32Set storage set) internal view returns (uint256) {
384         return _length(set._inner);
385     }
386 
387     /**
388      * @dev Returns the value stored at position `index` in the set. O(1).
389      *
390      * Note that there are no guarantees on the ordering of values inside the
391      * array, and it may change when more values are added or removed.
392      *
393      * Requirements:
394      *
395      * - `index` must be strictly less than {length}.
396      */
397     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
398         return _at(set._inner, index);
399     }
400 
401     /**
402      * @dev Return the entire set in an array
403      *
404      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
405      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
406      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
407      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
408      */
409     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
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
425     function add(AddressSet storage set, address value) internal returns (bool) {
426         return _add(set._inner, bytes32(uint256(uint160(value))));
427     }
428 
429     /**
430      * @dev Removes a value from a set. O(1).
431      *
432      * Returns true if the value was removed from the set, that is if it was
433      * present.
434      */
435     function remove(AddressSet storage set, address value) internal returns (bool) {
436         return _remove(set._inner, bytes32(uint256(uint160(value))));
437     }
438 
439     /**
440      * @dev Returns true if the value is in the set. O(1).
441      */
442     function contains(AddressSet storage set, address value) internal view returns (bool) {
443         return _contains(set._inner, bytes32(uint256(uint160(value))));
444     }
445 
446     /**
447      * @dev Returns the number of values in the set. O(1).
448      */
449     function length(AddressSet storage set) internal view returns (uint256) {
450         return _length(set._inner);
451     }
452 
453     /**
454      * @dev Returns the value stored at position `index` in the set. O(1).
455      *
456      * Note that there are no guarantees on the ordering of values inside the
457      * array, and it may change when more values are added or removed.
458      *
459      * Requirements:
460      *
461      * - `index` must be strictly less than {length}.
462      */
463     function at(AddressSet storage set, uint256 index) internal view returns (address) {
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
475     function values(AddressSet storage set) internal view returns (address[] memory) {
476         bytes32[] memory store = _values(set._inner);
477         address[] memory result;
478 
479         assembly {
480             result := store
481         }
482 
483         return result;
484     }
485 
486     // UintSet
487 
488     struct UintSet {
489         Set _inner;
490     }
491 
492     /**
493      * @dev Add a value to a set. O(1).
494      *
495      * Returns true if the value was added to the set, that is if it was not
496      * already present.
497      */
498     function add(UintSet storage set, uint256 value) internal returns (bool) {
499         return _add(set._inner, bytes32(value));
500     }
501 
502     /**
503      * @dev Removes a value from a set. O(1).
504      *
505      * Returns true if the value was removed from the set, that is if it was
506      * present.
507      */
508     function remove(UintSet storage set, uint256 value) internal returns (bool) {
509         return _remove(set._inner, bytes32(value));
510     }
511 
512     /**
513      * @dev Returns true if the value is in the set. O(1).
514      */
515     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
516         return _contains(set._inner, bytes32(value));
517     }
518 
519     /**
520      * @dev Returns the number of values on the set. O(1).
521      */
522     function length(UintSet storage set) internal view returns (uint256) {
523         return _length(set._inner);
524     }
525 
526     /**
527      * @dev Returns the value stored at position `index` in the set. O(1).
528      *
529      * Note that there are no guarantees on the ordering of values inside the
530      * array, and it may change when more values are added or removed.
531      *
532      * Requirements:
533      *
534      * - `index` must be strictly less than {length}.
535      */
536     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
537         return uint256(_at(set._inner, index));
538     }
539 
540     /**
541      * @dev Return the entire set in an array
542      *
543      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
544      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
545      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
546      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
547      */
548     function values(UintSet storage set) internal view returns (uint256[] memory) {
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
560 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @title ERC721 token receiver interface
569  * @dev Interface for any contract that wants to support safeTransfers
570  * from ERC721 asset contracts.
571  */
572 interface IERC721Receiver {
573     /**
574      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
575      * by `operator` from `from`, this function is called.
576      *
577      * It must return its Solidity selector to confirm the token transfer.
578      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
579      *
580      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
581      */
582     function onERC721Received(
583         address operator,
584         address from,
585         uint256 tokenId,
586         bytes calldata data
587     ) external returns (bytes4);
588 }
589 
590 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Interface of the ERC165 standard, as defined in the
599  * https://eips.ethereum.org/EIPS/eip-165[EIP].
600  *
601  * Implementers can declare support of contract interfaces, which can then be
602  * queried by others ({ERC165Checker}).
603  *
604  * For an implementation, see {ERC165}.
605  */
606 interface IERC165 {
607     /**
608      * @dev Returns true if this contract implements the interface defined by
609      * `interfaceId`. See the corresponding
610      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
611      * to learn more about how these ids are created.
612      *
613      * This function call must use less than 30 000 gas.
614      */
615     function supportsInterface(bytes4 interfaceId) external view returns (bool);
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @dev Required interface of an ERC721 compliant contract.
628  */
629 interface IERC721 is IERC165 {
630     /**
631      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
637      */
638     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
639 
640     /**
641      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
642      */
643     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
644 
645     /**
646      * @dev Returns the number of tokens in ``owner``'s account.
647      */
648     function balanceOf(address owner) external view returns (uint256 balance);
649 
650     /**
651      * @dev Returns the owner of the `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function ownerOf(uint256 tokenId) external view returns (address owner);
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
661      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must exist and be owned by `from`.
668      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
670      *
671      * Emits a {Transfer} event.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external;
678 
679     /**
680      * @dev Transfers `tokenId` token from `from` to `to`.
681      *
682      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      *
691      * Emits a {Transfer} event.
692      */
693     function transferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) external;
698 
699     /**
700      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
701      * The approval is cleared when the token is transferred.
702      *
703      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
704      *
705      * Requirements:
706      *
707      * - The caller must own the token or be an approved operator.
708      * - `tokenId` must exist.
709      *
710      * Emits an {Approval} event.
711      */
712     function approve(address to, uint256 tokenId) external;
713 
714     /**
715      * @dev Returns the account approved for `tokenId` token.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function getApproved(uint256 tokenId) external view returns (address operator);
722 
723     /**
724      * @dev Approve or remove `operator` as an operator for the caller.
725      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
726      *
727      * Requirements:
728      *
729      * - The `operator` cannot be the caller.
730      *
731      * Emits an {ApprovalForAll} event.
732      */
733     function setApprovalForAll(address operator, bool _approved) external;
734 
735     /**
736      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
737      *
738      * See {setApprovalForAll}
739      */
740     function isApprovedForAll(address owner, address operator) external view returns (bool);
741 
742     /**
743      * @dev Safely transfers `tokenId` token from `from` to `to`.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
751      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
752      *
753      * Emits a {Transfer} event.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes calldata data
760     ) external;
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
773  * @dev See https://eips.ethereum.org/EIPS/eip-721
774  */
775 interface IERC721Enumerable is IERC721 {
776     /**
777      * @dev Returns the total amount of tokens stored by the contract.
778      */
779     function totalSupply() external view returns (uint256);
780 
781     /**
782      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
783      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
784      */
785     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
786 
787     /**
788      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
789      * Use along with {totalSupply} to enumerate all tokens.
790      */
791     function tokenByIndex(uint256 index) external view returns (uint256);
792 }
793 
794 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
795 
796 
797 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
798 
799 pragma solidity ^0.8.0;
800 
801 // CAUTION
802 // This version of SafeMath should only be used with Solidity 0.8 or later,
803 // because it relies on the compiler's built in overflow checks.
804 
805 /**
806  * @dev Wrappers over Solidity's arithmetic operations.
807  *
808  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
809  * now has built in overflow checking.
810  */
811 library SafeMath {
812     /**
813      * @dev Returns the addition of two unsigned integers, with an overflow flag.
814      *
815      * _Available since v3.4._
816      */
817     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
818         unchecked {
819             uint256 c = a + b;
820             if (c < a) return (false, 0);
821             return (true, c);
822         }
823     }
824 
825     /**
826      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
827      *
828      * _Available since v3.4._
829      */
830     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
831         unchecked {
832             if (b > a) return (false, 0);
833             return (true, a - b);
834         }
835     }
836 
837     /**
838      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
839      *
840      * _Available since v3.4._
841      */
842     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
843         unchecked {
844             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
845             // benefit is lost if 'b' is also tested.
846             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
847             if (a == 0) return (true, 0);
848             uint256 c = a * b;
849             if (c / a != b) return (false, 0);
850             return (true, c);
851         }
852     }
853 
854     /**
855      * @dev Returns the division of two unsigned integers, with a division by zero flag.
856      *
857      * _Available since v3.4._
858      */
859     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
860         unchecked {
861             if (b == 0) return (false, 0);
862             return (true, a / b);
863         }
864     }
865 
866     /**
867      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
868      *
869      * _Available since v3.4._
870      */
871     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
872         unchecked {
873             if (b == 0) return (false, 0);
874             return (true, a % b);
875         }
876     }
877 
878     /**
879      * @dev Returns the addition of two unsigned integers, reverting on
880      * overflow.
881      *
882      * Counterpart to Solidity's `+` operator.
883      *
884      * Requirements:
885      *
886      * - Addition cannot overflow.
887      */
888     function add(uint256 a, uint256 b) internal pure returns (uint256) {
889         return a + b;
890     }
891 
892     /**
893      * @dev Returns the subtraction of two unsigned integers, reverting on
894      * overflow (when the result is negative).
895      *
896      * Counterpart to Solidity's `-` operator.
897      *
898      * Requirements:
899      *
900      * - Subtraction cannot overflow.
901      */
902     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
903         return a - b;
904     }
905 
906     /**
907      * @dev Returns the multiplication of two unsigned integers, reverting on
908      * overflow.
909      *
910      * Counterpart to Solidity's `*` operator.
911      *
912      * Requirements:
913      *
914      * - Multiplication cannot overflow.
915      */
916     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
917         return a * b;
918     }
919 
920     /**
921      * @dev Returns the integer division of two unsigned integers, reverting on
922      * division by zero. The result is rounded towards zero.
923      *
924      * Counterpart to Solidity's `/` operator.
925      *
926      * Requirements:
927      *
928      * - The divisor cannot be zero.
929      */
930     function div(uint256 a, uint256 b) internal pure returns (uint256) {
931         return a / b;
932     }
933 
934     /**
935      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
936      * reverting when dividing by zero.
937      *
938      * Counterpart to Solidity's `%` operator. This function uses a `revert`
939      * opcode (which leaves remaining gas untouched) while Solidity uses an
940      * invalid opcode to revert (consuming all remaining gas).
941      *
942      * Requirements:
943      *
944      * - The divisor cannot be zero.
945      */
946     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
947         return a % b;
948     }
949 
950     /**
951      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
952      * overflow (when the result is negative).
953      *
954      * CAUTION: This function is deprecated because it requires allocating memory for the error
955      * message unnecessarily. For custom revert reasons use {trySub}.
956      *
957      * Counterpart to Solidity's `-` operator.
958      *
959      * Requirements:
960      *
961      * - Subtraction cannot overflow.
962      */
963     function sub(
964         uint256 a,
965         uint256 b,
966         string memory errorMessage
967     ) internal pure returns (uint256) {
968         unchecked {
969             require(b <= a, errorMessage);
970             return a - b;
971         }
972     }
973 
974     /**
975      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
976      * division by zero. The result is rounded towards zero.
977      *
978      * Counterpart to Solidity's `/` operator. Note: this function uses a
979      * `revert` opcode (which leaves remaining gas untouched) while Solidity
980      * uses an invalid opcode to revert (consuming all remaining gas).
981      *
982      * Requirements:
983      *
984      * - The divisor cannot be zero.
985      */
986     function div(
987         uint256 a,
988         uint256 b,
989         string memory errorMessage
990     ) internal pure returns (uint256) {
991         unchecked {
992             require(b > 0, errorMessage);
993             return a / b;
994         }
995     }
996 
997     /**
998      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
999      * reverting with custom message when dividing by zero.
1000      *
1001      * CAUTION: This function is deprecated because it requires allocating memory for the error
1002      * message unnecessarily. For custom revert reasons use {tryMod}.
1003      *
1004      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1005      * opcode (which leaves remaining gas untouched) while Solidity uses an
1006      * invalid opcode to revert (consuming all remaining gas).
1007      *
1008      * Requirements:
1009      *
1010      * - The divisor cannot be zero.
1011      */
1012     function mod(
1013         uint256 a,
1014         uint256 b,
1015         string memory errorMessage
1016     ) internal pure returns (uint256) {
1017         unchecked {
1018             require(b > 0, errorMessage);
1019             return a % b;
1020         }
1021     }
1022 }
1023 
1024 // File: @openzeppelin/contracts/utils/Context.sol
1025 
1026 
1027 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
1028 
1029 pragma solidity ^0.8.0;
1030 
1031 /**
1032  * @dev Provides information about the current execution context, including the
1033  * sender of the transaction and its data. While these are generally available
1034  * via msg.sender and msg.data, they should not be accessed in such a direct
1035  * manner, since when dealing with meta-transactions the account sending and
1036  * paying for execution may not be the actual sender (as far as an application
1037  * is concerned).
1038  *
1039  * This contract is only required for intermediate, library-like contracts.
1040  */
1041 abstract contract Context {
1042     function _msgSender() internal view virtual returns (address) {
1043         return msg.sender;
1044     }
1045 
1046     function _msgData() internal view virtual returns (bytes calldata) {
1047         return msg.data;
1048     }
1049 }
1050 
1051 // File: @openzeppelin/contracts/security/Pausable.sol
1052 
1053 
1054 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
1055 
1056 pragma solidity ^0.8.0;
1057 
1058 
1059 /**
1060  * @dev Contract module which allows children to implement an emergency stop
1061  * mechanism that can be triggered by an authorized account.
1062  *
1063  * This module is used through inheritance. It will make available the
1064  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1065  * the functions of your contract. Note that they will not be pausable by
1066  * simply including this module, only once the modifiers are put in place.
1067  */
1068 abstract contract Pausable is Context {
1069     /**
1070      * @dev Emitted when the pause is triggered by `account`.
1071      */
1072     event Paused(address account);
1073 
1074     /**
1075      * @dev Emitted when the pause is lifted by `account`.
1076      */
1077     event Unpaused(address account);
1078 
1079     bool private _paused;
1080 
1081     /**
1082      * @dev Initializes the contract in unpaused state.
1083      */
1084     constructor() {
1085         _paused = false;
1086     }
1087 
1088     /**
1089      * @dev Returns true if the contract is paused, and false otherwise.
1090      */
1091     function paused() public view virtual returns (bool) {
1092         return _paused;
1093     }
1094 
1095     /**
1096      * @dev Modifier to make a function callable only when the contract is not paused.
1097      *
1098      * Requirements:
1099      *
1100      * - The contract must not be paused.
1101      */
1102     modifier whenNotPaused() {
1103         require(!paused(), "Pausable: paused");
1104         _;
1105     }
1106 
1107     /**
1108      * @dev Modifier to make a function callable only when the contract is paused.
1109      *
1110      * Requirements:
1111      *
1112      * - The contract must be paused.
1113      */
1114     modifier whenPaused() {
1115         require(paused(), "Pausable: not paused");
1116         _;
1117     }
1118 
1119     /**
1120      * @dev Triggers stopped state.
1121      *
1122      * Requirements:
1123      *
1124      * - The contract must not be paused.
1125      */
1126     function _pause() internal virtual whenNotPaused {
1127         _paused = true;
1128         emit Paused(_msgSender());
1129     }
1130 
1131     /**
1132      * @dev Returns to normal state.
1133      *
1134      * Requirements:
1135      *
1136      * - The contract must be paused.
1137      */
1138     function _unpause() internal virtual whenPaused {
1139         _paused = false;
1140         emit Unpaused(_msgSender());
1141     }
1142 }
1143 
1144 // File: @openzeppelin/contracts/access/Ownable.sol
1145 
1146 
1147 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1148 
1149 pragma solidity ^0.8.0;
1150 
1151 
1152 /**
1153  * @dev Contract module which provides a basic access control mechanism, where
1154  * there is an account (an owner) that can be granted exclusive access to
1155  * specific functions.
1156  *
1157  * By default, the owner account will be the one that deploys the contract. This
1158  * can later be changed with {transferOwnership}.
1159  *
1160  * This module is used through inheritance. It will make available the modifier
1161  * `onlyOwner`, which can be applied to your functions to restrict their use to
1162  * the owner.
1163  */
1164 abstract contract Ownable is Context {
1165     address private _owner;
1166 
1167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1168 
1169     /**
1170      * @dev Initializes the contract setting the deployer as the initial owner.
1171      */
1172     constructor() {
1173         _transferOwnership(_msgSender());
1174     }
1175 
1176     /**
1177      * @dev Returns the address of the current owner.
1178      */
1179     function owner() public view virtual returns (address) {
1180         return _owner;
1181     }
1182 
1183     /**
1184      * @dev Throws if called by any account other than the owner.
1185      */
1186     modifier onlyOwner() {
1187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1188         _;
1189     }
1190 
1191     /**
1192      * @dev Leaves the contract without owner. It will not be possible to call
1193      * `onlyOwner` functions anymore. Can only be called by the current owner.
1194      *
1195      * NOTE: Renouncing ownership will leave the contract without an owner,
1196      * thereby removing any functionality that is only available to the owner.
1197      */
1198     function renounceOwnership() public virtual onlyOwner {
1199         _transferOwnership(address(0));
1200     }
1201 
1202     /**
1203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1204      * Can only be called by the current owner.
1205      */
1206     function transferOwnership(address newOwner) public virtual onlyOwner {
1207         require(newOwner != address(0), "Ownable: new owner is the zero address");
1208         _transferOwnership(newOwner);
1209     }
1210 
1211     /**
1212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1213      * Internal function without access restriction.
1214      */
1215     function _transferOwnership(address newOwner) internal virtual {
1216         address oldOwner = _owner;
1217         _owner = newOwner;
1218         emit OwnershipTransferred(oldOwner, newOwner);
1219     }
1220 }
1221 
1222 // File: WizardStaking.sol
1223 
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 
1228 
1229 
1230 
1231 
1232 
1233 
1234 
1235 
1236 contract WizardStaking is Ownable, IERC721Receiver, ReentrancyGuard, Pausable {
1237     using EnumerableSet for EnumerableSet.UintSet;
1238 
1239     //addresses
1240     address nullAddress = 0x0000000000000000000000000000000000000000;
1241     address public stakingToken;
1242     address public erc20Address;
1243 
1244     //uint256's
1245     uint256 public expiration;
1246     //rate governs how often you receive your token
1247     uint256 public rate;
1248 
1249     // mappings
1250     mapping(address => EnumerableSet.UintSet) private _deposits;
1251     mapping(address => mapping(uint256 => uint256)) public _depositBlocks;
1252     mapping(uint256 => address) private _tokenErc20;
1253 
1254     constructor(
1255         address _stakingToken,
1256         uint256 _rate,
1257         uint256 _expiration,
1258         address _erc20Address
1259     ) {
1260         stakingToken = _stakingToken;
1261         rate = _rate;
1262         expiration = block.number + _expiration;
1263         erc20Address = _erc20Address;
1264         _pause();
1265     }
1266 
1267     function pause() public onlyOwner {
1268         _pause();
1269     }
1270 
1271     function unpause() public onlyOwner {
1272         _unpause();
1273     }
1274 
1275     /* STAKING MECHANICS */
1276 
1277     // Set a multiplier for how many tokens to earn each time a block passes.
1278     function setRate(uint256 _rate) public onlyOwner {
1279         rate = _rate;
1280     }
1281 
1282     // Set this to a block to disable the ability to continue accruing tokens past that block number.
1283     function setExpiration(uint256 _expiration) public onlyOwner {
1284         expiration = block.number + _expiration;
1285     }
1286 
1287     // Set this to update the ERC20 address to receive from staking
1288     function setERC20Address(address _erc20address) public onlyOwner {
1289         require(
1290             erc20Address == address(0),
1291             "Staking: ERC20 address already set"
1292         );
1293         erc20Address = _erc20address;
1294     }
1295 
1296     //check deposit amount.
1297     function depositsOf(address account)
1298         external
1299         view
1300         returns (uint256[] memory)
1301     {
1302         EnumerableSet.UintSet storage depositSet = _deposits[account];
1303         uint256[] memory tokenIds = new uint256[](depositSet.length());
1304 
1305         for (uint256 i; i < depositSet.length(); i++) {
1306             tokenIds[i] = depositSet.at(i);
1307         }
1308 
1309         return tokenIds;
1310     }
1311 
1312     function balanceOf(address account) external view returns (uint256) {
1313         return _deposits[account].length();
1314     }
1315 
1316     function calculateRewards(address account, uint256[] memory tokenIds)
1317         public
1318         view
1319         returns (uint256[] memory rewards)
1320     {
1321         rewards = new uint256[](tokenIds.length);
1322 
1323         for (uint256 i; i < tokenIds.length; i++) {
1324             uint256 tokenId = tokenIds[i];
1325 
1326             rewards[i] =
1327                 rate *
1328                 (_deposits[account].contains(tokenId) ? 1 : 0) *
1329                 (Math.min(block.number, expiration) -
1330                     _depositBlocks[account][tokenId]);
1331         }
1332 
1333         return rewards;
1334     }
1335 
1336     //reward amount by address/tokenIds[]
1337     function calculateReward(address account, uint256 tokenId)
1338         public
1339         view
1340         returns (uint256)
1341     {
1342         require(
1343             Math.min(block.number, expiration) >
1344                 _depositBlocks[account][tokenId],
1345             "Invalid blocks"
1346         );
1347         return
1348             rate *
1349             (_deposits[account].contains(tokenId) ? 1 : 0) *
1350             (Math.min(block.number, expiration) -
1351                 _depositBlocks[account][tokenId]);
1352     }
1353 
1354     //reward claim function
1355     function claimRewards(uint256[] calldata tokenIds) public whenNotPaused {
1356         uint256 reward;
1357         uint256 blockCur = Math.min(block.number, expiration);
1358 
1359         for (uint256 i; i < tokenIds.length; i++) {
1360             reward += calculateReward(msg.sender, tokenIds[i]);
1361             _depositBlocks[msg.sender][tokenIds[i]] = blockCur;
1362         }
1363 
1364         if (reward > 0) {
1365             require(
1366                 erc20Address != address(0),
1367                 "Staking: ERC20 address not set"
1368             );
1369             IERC20(erc20Address).transfer(msg.sender, reward);
1370         }
1371     }
1372 
1373     //deposit function.
1374     function deposit(uint256[] calldata tokenIds) external whenNotPaused {
1375         require(msg.sender != stakingToken, "Invalid address");
1376         claimRewards(tokenIds);
1377 
1378         for (uint256 i; i < tokenIds.length; i++) {
1379             IERC721(stakingToken).safeTransferFrom(
1380                 msg.sender,
1381                 address(this),
1382                 tokenIds[i],
1383                 ""
1384             );
1385 
1386             _deposits[msg.sender].add(tokenIds[i]);
1387         }
1388     }
1389 
1390     function autoStake(address from, uint256 tokenId) external {
1391         require(msg.sender == stakingToken, "Invalid address");
1392         require(
1393             IERC721(stakingToken).ownerOf(tokenId) == address(this),
1394             "Invalid tokenId"
1395         );
1396         _deposits[from].add(tokenId);
1397         _depositBlocks[from][tokenId] = Math.min(block.number, expiration);
1398     }
1399 
1400     //withdrawal function.
1401     function withdraw(uint256[] calldata tokenIds)
1402         external
1403         whenNotPaused
1404         nonReentrant
1405     {
1406         claimRewards(tokenIds);
1407 
1408         for (uint256 i; i < tokenIds.length; i++) {
1409             require(
1410                 _deposits[msg.sender].contains(tokenIds[i]),
1411                 "Staking: token not deposited"
1412             );
1413 
1414             _deposits[msg.sender].remove(tokenIds[i]);
1415 
1416             IERC721(stakingToken).safeTransferFrom(
1417                 address(this),
1418                 msg.sender,
1419                 tokenIds[i],
1420                 ""
1421             );
1422         }
1423     }
1424 
1425     //withdrawal function.
1426     function withdrawTokens() external onlyOwner {
1427         uint256 tokenSupply = IERC20(erc20Address).balanceOf(address(this));
1428         IERC20(erc20Address).transfer(msg.sender, tokenSupply);
1429     }
1430 
1431     function onERC721Received(
1432         address,
1433         address,
1434         uint256,
1435         bytes calldata
1436     ) external pure override returns (bytes4) {
1437         return IERC721Receiver.onERC721Received.selector;
1438     }
1439 }