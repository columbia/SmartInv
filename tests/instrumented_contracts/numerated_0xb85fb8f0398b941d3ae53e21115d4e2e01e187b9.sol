1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
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
284     function _contains(Set storage set, bytes32 value) private view returns (bool) {
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
305     function _at(Set storage set, uint256 index) private view returns (bytes32) {
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
333     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
334         return _add(set._inner, value);
335     }
336 
337     /**
338      * @dev Removes a value from a set. O(1).
339      *
340      * Returns true if the value was removed from the set, that is if it was
341      * present.
342      */
343     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
344         return _remove(set._inner, value);
345     }
346 
347     /**
348      * @dev Returns true if the value is in the set. O(1).
349      */
350     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
351         return _contains(set._inner, value);
352     }
353 
354     /**
355      * @dev Returns the number of values in the set. O(1).
356      */
357     function length(Bytes32Set storage set) internal view returns (uint256) {
358         return _length(set._inner);
359     }
360 
361     /**
362      * @dev Returns the value stored at position `index` in the set. O(1).
363      *
364      * Note that there are no guarantees on the ordering of values inside the
365      * array, and it may change when more values are added or removed.
366      *
367      * Requirements:
368      *
369      * - `index` must be strictly less than {length}.
370      */
371     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
372         return _at(set._inner, index);
373     }
374 
375     /**
376      * @dev Return the entire set in an array
377      *
378      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
379      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
380      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
381      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
382      */
383     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
384         return _values(set._inner);
385     }
386 
387     // AddressSet
388 
389     struct AddressSet {
390         Set _inner;
391     }
392 
393     /**
394      * @dev Add a value to a set. O(1).
395      *
396      * Returns true if the value was added to the set, that is if it was not
397      * already present.
398      */
399     function add(AddressSet storage set, address value) internal returns (bool) {
400         return _add(set._inner, bytes32(uint256(uint160(value))));
401     }
402 
403     /**
404      * @dev Removes a value from a set. O(1).
405      *
406      * Returns true if the value was removed from the set, that is if it was
407      * present.
408      */
409     function remove(AddressSet storage set, address value) internal returns (bool) {
410         return _remove(set._inner, bytes32(uint256(uint160(value))));
411     }
412 
413     /**
414      * @dev Returns true if the value is in the set. O(1).
415      */
416     function contains(AddressSet storage set, address value) internal view returns (bool) {
417         return _contains(set._inner, bytes32(uint256(uint160(value))));
418     }
419 
420     /**
421      * @dev Returns the number of values in the set. O(1).
422      */
423     function length(AddressSet storage set) internal view returns (uint256) {
424         return _length(set._inner);
425     }
426 
427     /**
428      * @dev Returns the value stored at position `index` in the set. O(1).
429      *
430      * Note that there are no guarantees on the ordering of values inside the
431      * array, and it may change when more values are added or removed.
432      *
433      * Requirements:
434      *
435      * - `index` must be strictly less than {length}.
436      */
437     function at(AddressSet storage set, uint256 index) internal view returns (address) {
438         return address(uint160(uint256(_at(set._inner, index))));
439     }
440 
441     /**
442      * @dev Return the entire set in an array
443      *
444      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
445      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
446      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
447      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
448      */
449     function values(AddressSet storage set) internal view returns (address[] memory) {
450         bytes32[] memory store = _values(set._inner);
451         address[] memory result;
452 
453         assembly {
454             result := store
455         }
456 
457         return result;
458     }
459 
460     // UintSet
461 
462     struct UintSet {
463         Set _inner;
464     }
465 
466     /**
467      * @dev Add a value to a set. O(1).
468      *
469      * Returns true if the value was added to the set, that is if it was not
470      * already present.
471      */
472     function add(UintSet storage set, uint256 value) internal returns (bool) {
473         return _add(set._inner, bytes32(value));
474     }
475 
476     /**
477      * @dev Removes a value from a set. O(1).
478      *
479      * Returns true if the value was removed from the set, that is if it was
480      * present.
481      */
482     function remove(UintSet storage set, uint256 value) internal returns (bool) {
483         return _remove(set._inner, bytes32(value));
484     }
485 
486     /**
487      * @dev Returns true if the value is in the set. O(1).
488      */
489     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
490         return _contains(set._inner, bytes32(value));
491     }
492 
493     /**
494      * @dev Returns the number of values on the set. O(1).
495      */
496     function length(UintSet storage set) internal view returns (uint256) {
497         return _length(set._inner);
498     }
499 
500     /**
501      * @dev Returns the value stored at position `index` in the set. O(1).
502      *
503      * Note that there are no guarantees on the ordering of values inside the
504      * array, and it may change when more values are added or removed.
505      *
506      * Requirements:
507      *
508      * - `index` must be strictly less than {length}.
509      */
510     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
511         return uint256(_at(set._inner, index));
512     }
513 
514     /**
515      * @dev Return the entire set in an array
516      *
517      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
518      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
519      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
520      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
521      */
522     function values(UintSet storage set) internal view returns (uint256[] memory) {
523         bytes32[] memory store = _values(set._inner);
524         uint256[] memory result;
525 
526         assembly {
527             result := store
528         }
529 
530         return result;
531     }
532 }
533 
534 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Contract module that helps prevent reentrant calls to a function.
543  *
544  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
545  * available, which can be applied to functions to make sure there are no nested
546  * (reentrant) calls to them.
547  *
548  * Note that because there is a single `nonReentrant` guard, functions marked as
549  * `nonReentrant` may not call one another. This can be worked around by making
550  * those functions `private`, and then adding `external` `nonReentrant` entry
551  * points to them.
552  *
553  * TIP: If you would like to learn more about reentrancy and alternative ways
554  * to protect against it, check out our blog post
555  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
556  */
557 abstract contract ReentrancyGuard {
558     // Booleans are more expensive than uint256 or any type that takes up a full
559     // word because each write operation emits an extra SLOAD to first read the
560     // slot's contents, replace the bits taken up by the boolean, and then write
561     // back. This is the compiler's defense against contract upgrades and
562     // pointer aliasing, and it cannot be disabled.
563 
564     // The values being non-zero value makes deployment a bit more expensive,
565     // but in exchange the refund on every call to nonReentrant will be lower in
566     // amount. Since refunds are capped to a percentage of the total
567     // transaction's gas, it is best to keep them low in cases like this one, to
568     // increase the likelihood of the full refund coming into effect.
569     uint256 private constant _NOT_ENTERED = 1;
570     uint256 private constant _ENTERED = 2;
571 
572     uint256 private _status;
573 
574     constructor() {
575         _status = _NOT_ENTERED;
576     }
577 
578     /**
579      * @dev Prevents a contract from calling itself, directly or indirectly.
580      * Calling a `nonReentrant` function from another `nonReentrant`
581      * function is not supported. It is possible to prevent this from happening
582      * by making the `nonReentrant` function external, and making it call a
583      * `private` function that does the actual work.
584      */
585     modifier nonReentrant() {
586         // On the first call to nonReentrant, _notEntered will be true
587         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
588 
589         // Any calls to nonReentrant after this point will fail
590         _status = _ENTERED;
591 
592         _;
593 
594         // By storing the original value once again, a refund is triggered (see
595         // https://eips.ethereum.org/EIPS/eip-2200)
596         _status = _NOT_ENTERED;
597     }
598 }
599 
600 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @title Counters
609  * @author Matt Condon (@shrugs)
610  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
611  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
612  *
613  * Include with `using Counters for Counters.Counter;`
614  */
615 library Counters {
616     struct Counter {
617         // This variable should never be directly accessed by users of the library: interactions must be restricted to
618         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
619         // this feature: see https://github.com/ethereum/solidity/issues/4637
620         uint256 _value; // default: 0
621     }
622 
623     function current(Counter storage counter) internal view returns (uint256) {
624         return counter._value;
625     }
626 
627     function increment(Counter storage counter) internal {
628         unchecked {
629             counter._value += 1;
630         }
631     }
632 
633     function decrement(Counter storage counter) internal {
634         uint256 value = counter._value;
635         require(value > 0, "Counter: decrement overflow");
636         unchecked {
637             counter._value = value - 1;
638         }
639     }
640 
641     function reset(Counter storage counter) internal {
642         counter._value = 0;
643     }
644 }
645 
646 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
647 
648 
649 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @title ERC721 token receiver interface
655  * @dev Interface for any contract that wants to support safeTransfers
656  * from ERC721 asset contracts.
657  */
658 interface IERC721Receiver {
659     /**
660      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
661      * by `operator` from `from`, this function is called.
662      *
663      * It must return its Solidity selector to confirm the token transfer.
664      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
665      *
666      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
667      */
668     function onERC721Received(
669         address operator,
670         address from,
671         uint256 tokenId,
672         bytes calldata data
673     ) external returns (bytes4);
674 }
675 
676 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev Provides information about the current execution context, including the
685  * sender of the transaction and its data. While these are generally available
686  * via msg.sender and msg.data, they should not be accessed in such a direct
687  * manner, since when dealing with meta-transactions the account sending and
688  * paying for execution may not be the actual sender (as far as an application
689  * is concerned).
690  *
691  * This contract is only required for intermediate, library-like contracts.
692  */
693 abstract contract Context {
694     function _msgSender() internal view virtual returns (address) {
695         return msg.sender;
696     }
697 
698     function _msgData() internal view virtual returns (bytes calldata) {
699         return msg.data;
700     }
701 }
702 
703 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @dev Contract module which provides a basic access control mechanism, where
713  * there is an account (an owner) that can be granted exclusive access to
714  * specific functions.
715  *
716  * By default, the owner account will be the one that deploys the contract. This
717  * can later be changed with {transferOwnership}.
718  *
719  * This module is used through inheritance. It will make available the modifier
720  * `onlyOwner`, which can be applied to your functions to restrict their use to
721  * the owner.
722  */
723 abstract contract Ownable is Context {
724     address private _owner;
725 
726     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
727 
728     /**
729      * @dev Initializes the contract setting the deployer as the initial owner.
730      */
731     constructor() {
732         _transferOwnership(_msgSender());
733     }
734 
735     /**
736      * @dev Returns the address of the current owner.
737      */
738     function owner() public view virtual returns (address) {
739         return _owner;
740     }
741 
742     /**
743      * @dev Throws if called by any account other than the owner.
744      */
745     modifier onlyOwner() {
746         require(owner() == _msgSender(), "Ownable: caller is not the owner");
747         _;
748     }
749 
750     /**
751      * @dev Leaves the contract without owner. It will not be possible to call
752      * `onlyOwner` functions anymore. Can only be called by the current owner.
753      *
754      * NOTE: Renouncing ownership will leave the contract without an owner,
755      * thereby removing any functionality that is only available to the owner.
756      */
757     function renounceOwnership() public virtual onlyOwner {
758         _transferOwnership(address(0));
759     }
760 
761     /**
762      * @dev Transfers ownership of the contract to a new account (`newOwner`).
763      * Can only be called by the current owner.
764      */
765     function transferOwnership(address newOwner) public virtual onlyOwner {
766         require(newOwner != address(0), "Ownable: new owner is the zero address");
767         _transferOwnership(newOwner);
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
772      * Internal function without access restriction.
773      */
774     function _transferOwnership(address newOwner) internal virtual {
775         address oldOwner = _owner;
776         _owner = newOwner;
777         emit OwnershipTransferred(oldOwner, newOwner);
778     }
779 }
780 
781 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
782 
783 
784 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 /**
789  * @dev Interface of the ERC20 standard as defined in the EIP.
790  */
791 interface IERC20 {
792     /**
793      * @dev Returns the amount of tokens in existence.
794      */
795     function totalSupply() external view returns (uint256);
796 
797     /**
798      * @dev Returns the amount of tokens owned by `account`.
799      */
800     function balanceOf(address account) external view returns (uint256);
801 
802     /**
803      * @dev Moves `amount` tokens from the caller's account to `to`.
804      *
805      * Returns a boolean value indicating whether the operation succeeded.
806      *
807      * Emits a {Transfer} event.
808      */
809     function transfer(address to, uint256 amount) external returns (bool);
810 
811     /**
812      * @dev Returns the remaining number of tokens that `spender` will be
813      * allowed to spend on behalf of `owner` through {transferFrom}. This is
814      * zero by default.
815      *
816      * This value changes when {approve} or {transferFrom} are called.
817      */
818     function allowance(address owner, address spender) external view returns (uint256);
819 
820     /**
821      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
822      *
823      * Returns a boolean value indicating whether the operation succeeded.
824      *
825      * IMPORTANT: Beware that changing an allowance with this method brings the risk
826      * that someone may use both the old and the new allowance by unfortunate
827      * transaction ordering. One possible solution to mitigate this race
828      * condition is to first reduce the spender's allowance to 0 and set the
829      * desired value afterwards:
830      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address spender, uint256 amount) external returns (bool);
835 
836     /**
837      * @dev Moves `amount` tokens from `from` to `to` using the
838      * allowance mechanism. `amount` is then deducted from the caller's
839      * allowance.
840      *
841      * Returns a boolean value indicating whether the operation succeeded.
842      *
843      * Emits a {Transfer} event.
844      */
845     function transferFrom(
846         address from,
847         address to,
848         uint256 amount
849     ) external returns (bool);
850 
851     /**
852      * @dev Emitted when `value` tokens are moved from one account (`from`) to
853      * another (`to`).
854      *
855      * Note that `value` may be zero.
856      */
857     event Transfer(address indexed from, address indexed to, uint256 value);
858 
859     /**
860      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
861      * a call to {approve}. `value` is the new allowance.
862      */
863     event Approval(address indexed owner, address indexed spender, uint256 value);
864 }
865 
866 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
867 
868 
869 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 
874 /**
875  * @dev Interface for the optional metadata functions from the ERC20 standard.
876  *
877  * _Available since v4.1._
878  */
879 interface IERC20Metadata is IERC20 {
880     /**
881      * @dev Returns the name of the token.
882      */
883     function name() external view returns (string memory);
884 
885     /**
886      * @dev Returns the symbol of the token.
887      */
888     function symbol() external view returns (string memory);
889 
890     /**
891      * @dev Returns the decimals places of the token.
892      */
893     function decimals() external view returns (uint8);
894 }
895 
896 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
897 
898 
899 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
900 
901 pragma solidity ^0.8.0;
902 
903 
904 
905 
906 /**
907  * @dev Implementation of the {IERC20} interface.
908  *
909  * This implementation is agnostic to the way tokens are created. This means
910  * that a supply mechanism has to be added in a derived contract using {_mint}.
911  * For a generic mechanism see {ERC20PresetMinterPauser}.
912  *
913  * TIP: For a detailed writeup see our guide
914  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
915  * to implement supply mechanisms].
916  *
917  * We have followed general OpenZeppelin Contracts guidelines: functions revert
918  * instead returning `false` on failure. This behavior is nonetheless
919  * conventional and does not conflict with the expectations of ERC20
920  * applications.
921  *
922  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
923  * This allows applications to reconstruct the allowance for all accounts just
924  * by listening to said events. Other implementations of the EIP may not emit
925  * these events, as it isn't required by the specification.
926  *
927  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
928  * functions have been added to mitigate the well-known issues around setting
929  * allowances. See {IERC20-approve}.
930  */
931 contract ERC20 is Context, IERC20, IERC20Metadata {
932     mapping(address => uint256) private _balances;
933 
934     mapping(address => mapping(address => uint256)) private _allowances;
935 
936     uint256 private _totalSupply;
937 
938     string private _name;
939     string private _symbol;
940 
941     /**
942      * @dev Sets the values for {name} and {symbol}.
943      *
944      * The default value of {decimals} is 18. To select a different value for
945      * {decimals} you should overload it.
946      *
947      * All two of these values are immutable: they can only be set once during
948      * construction.
949      */
950     constructor(string memory name_, string memory symbol_) {
951         _name = name_;
952         _symbol = symbol_;
953     }
954 
955     /**
956      * @dev Returns the name of the token.
957      */
958     function name() public view virtual override returns (string memory) {
959         return _name;
960     }
961 
962     /**
963      * @dev Returns the symbol of the token, usually a shorter version of the
964      * name.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev Returns the number of decimals used to get its user representation.
972      * For example, if `decimals` equals `2`, a balance of `505` tokens should
973      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
974      *
975      * Tokens usually opt for a value of 18, imitating the relationship between
976      * Ether and Wei. This is the value {ERC20} uses, unless this function is
977      * overridden;
978      *
979      * NOTE: This information is only used for _display_ purposes: it in
980      * no way affects any of the arithmetic of the contract, including
981      * {IERC20-balanceOf} and {IERC20-transfer}.
982      */
983     function decimals() public view virtual override returns (uint8) {
984         return 18;
985     }
986 
987     /**
988      * @dev See {IERC20-totalSupply}.
989      */
990     function totalSupply() public view virtual override returns (uint256) {
991         return _totalSupply;
992     }
993 
994     /**
995      * @dev See {IERC20-balanceOf}.
996      */
997     function balanceOf(address account) public view virtual override returns (uint256) {
998         return _balances[account];
999     }
1000 
1001     /**
1002      * @dev See {IERC20-transfer}.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - the caller must have a balance of at least `amount`.
1008      */
1009     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1010         address owner = _msgSender();
1011         _transfer(owner, to, amount);
1012         return true;
1013     }
1014 
1015     /**
1016      * @dev See {IERC20-allowance}.
1017      */
1018     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1019         return _allowances[owner][spender];
1020     }
1021 
1022     /**
1023      * @dev See {IERC20-approve}.
1024      *
1025      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1026      * `transferFrom`. This is semantically equivalent to an infinite approval.
1027      *
1028      * Requirements:
1029      *
1030      * - `spender` cannot be the zero address.
1031      */
1032     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1033         address owner = _msgSender();
1034         _approve(owner, spender, amount);
1035         return true;
1036     }
1037 
1038     /**
1039      * @dev See {IERC20-transferFrom}.
1040      *
1041      * Emits an {Approval} event indicating the updated allowance. This is not
1042      * required by the EIP. See the note at the beginning of {ERC20}.
1043      *
1044      * NOTE: Does not update the allowance if the current allowance
1045      * is the maximum `uint256`.
1046      *
1047      * Requirements:
1048      *
1049      * - `from` and `to` cannot be the zero address.
1050      * - `from` must have a balance of at least `amount`.
1051      * - the caller must have allowance for ``from``'s tokens of at least
1052      * `amount`.
1053      */
1054     function transferFrom(
1055         address from,
1056         address to,
1057         uint256 amount
1058     ) public virtual override returns (bool) {
1059         address spender = _msgSender();
1060         _spendAllowance(from, spender, amount);
1061         _transfer(from, to, amount);
1062         return true;
1063     }
1064 
1065     /**
1066      * @dev Atomically increases the allowance granted to `spender` by the caller.
1067      *
1068      * This is an alternative to {approve} that can be used as a mitigation for
1069      * problems described in {IERC20-approve}.
1070      *
1071      * Emits an {Approval} event indicating the updated allowance.
1072      *
1073      * Requirements:
1074      *
1075      * - `spender` cannot be the zero address.
1076      */
1077     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1078         address owner = _msgSender();
1079         _approve(owner, spender, allowance(owner, spender) + addedValue);
1080         return true;
1081     }
1082 
1083     /**
1084      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1085      *
1086      * This is an alternative to {approve} that can be used as a mitigation for
1087      * problems described in {IERC20-approve}.
1088      *
1089      * Emits an {Approval} event indicating the updated allowance.
1090      *
1091      * Requirements:
1092      *
1093      * - `spender` cannot be the zero address.
1094      * - `spender` must have allowance for the caller of at least
1095      * `subtractedValue`.
1096      */
1097     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1098         address owner = _msgSender();
1099         uint256 currentAllowance = allowance(owner, spender);
1100         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1101         unchecked {
1102             _approve(owner, spender, currentAllowance - subtractedValue);
1103         }
1104 
1105         return true;
1106     }
1107 
1108     /**
1109      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1110      *
1111      * This internal function is equivalent to {transfer}, and can be used to
1112      * e.g. implement automatic token fees, slashing mechanisms, etc.
1113      *
1114      * Emits a {Transfer} event.
1115      *
1116      * Requirements:
1117      *
1118      * - `from` cannot be the zero address.
1119      * - `to` cannot be the zero address.
1120      * - `from` must have a balance of at least `amount`.
1121      */
1122     function _transfer(
1123         address from,
1124         address to,
1125         uint256 amount
1126     ) internal virtual {
1127         require(from != address(0), "ERC20: transfer from the zero address");
1128         require(to != address(0), "ERC20: transfer to the zero address");
1129 
1130         _beforeTokenTransfer(from, to, amount);
1131 
1132         uint256 fromBalance = _balances[from];
1133         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1134         unchecked {
1135             _balances[from] = fromBalance - amount;
1136         }
1137         _balances[to] += amount;
1138 
1139         emit Transfer(from, to, amount);
1140 
1141         _afterTokenTransfer(from, to, amount);
1142     }
1143 
1144     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1145      * the total supply.
1146      *
1147      * Emits a {Transfer} event with `from` set to the zero address.
1148      *
1149      * Requirements:
1150      *
1151      * - `account` cannot be the zero address.
1152      */
1153     function _mint(address account, uint256 amount) internal virtual {
1154         require(account != address(0), "ERC20: mint to the zero address");
1155 
1156         _beforeTokenTransfer(address(0), account, amount);
1157 
1158         _totalSupply += amount;
1159         _balances[account] += amount;
1160         emit Transfer(address(0), account, amount);
1161 
1162         _afterTokenTransfer(address(0), account, amount);
1163     }
1164 
1165     /**
1166      * @dev Destroys `amount` tokens from `account`, reducing the
1167      * total supply.
1168      *
1169      * Emits a {Transfer} event with `to` set to the zero address.
1170      *
1171      * Requirements:
1172      *
1173      * - `account` cannot be the zero address.
1174      * - `account` must have at least `amount` tokens.
1175      */
1176     function _burn(address account, uint256 amount) internal virtual {
1177         require(account != address(0), "ERC20: burn from the zero address");
1178 
1179         _beforeTokenTransfer(account, address(0), amount);
1180 
1181         uint256 accountBalance = _balances[account];
1182         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1183         unchecked {
1184             _balances[account] = accountBalance - amount;
1185         }
1186         _totalSupply -= amount;
1187 
1188         emit Transfer(account, address(0), amount);
1189 
1190         _afterTokenTransfer(account, address(0), amount);
1191     }
1192 
1193     /**
1194      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1195      *
1196      * This internal function is equivalent to `approve`, and can be used to
1197      * e.g. set automatic allowances for certain subsystems, etc.
1198      *
1199      * Emits an {Approval} event.
1200      *
1201      * Requirements:
1202      *
1203      * - `owner` cannot be the zero address.
1204      * - `spender` cannot be the zero address.
1205      */
1206     function _approve(
1207         address owner,
1208         address spender,
1209         uint256 amount
1210     ) internal virtual {
1211         require(owner != address(0), "ERC20: approve from the zero address");
1212         require(spender != address(0), "ERC20: approve to the zero address");
1213 
1214         _allowances[owner][spender] = amount;
1215         emit Approval(owner, spender, amount);
1216     }
1217 
1218     /**
1219      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1220      *
1221      * Does not update the allowance amount in case of infinite allowance.
1222      * Revert if not enough allowance is available.
1223      *
1224      * Might emit an {Approval} event.
1225      */
1226     function _spendAllowance(
1227         address owner,
1228         address spender,
1229         uint256 amount
1230     ) internal virtual {
1231         uint256 currentAllowance = allowance(owner, spender);
1232         if (currentAllowance != type(uint256).max) {
1233             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1234             unchecked {
1235                 _approve(owner, spender, currentAllowance - amount);
1236             }
1237         }
1238     }
1239 
1240     /**
1241      * @dev Hook that is called before any transfer of tokens. This includes
1242      * minting and burning.
1243      *
1244      * Calling conditions:
1245      *
1246      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1247      * will be transferred to `to`.
1248      * - when `from` is zero, `amount` tokens will be minted for `to`.
1249      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1250      * - `from` and `to` are never both zero.
1251      *
1252      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1253      */
1254     function _beforeTokenTransfer(
1255         address from,
1256         address to,
1257         uint256 amount
1258     ) internal virtual {}
1259 
1260     /**
1261      * @dev Hook that is called after any transfer of tokens. This includes
1262      * minting and burning.
1263      *
1264      * Calling conditions:
1265      *
1266      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1267      * has been transferred to `to`.
1268      * - when `from` is zero, `amount` tokens have been minted for `to`.
1269      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1270      * - `from` and `to` are never both zero.
1271      *
1272      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1273      */
1274     function _afterTokenTransfer(
1275         address from,
1276         address to,
1277         uint256 amount
1278     ) internal virtual {}
1279 }
1280 
1281 // File: staking.sol
1282 
1283 pragma solidity 0.8.7;
1284 
1285 
1286 
1287 
1288 
1289 
1290 
1291 
1292 /// SPDX-License-Identifier: UNLICENSED
1293 
1294 
1295 contract SuperlativeApesStaking is ERC20("Superlative Staking", "SLAPE"), IERC721Receiver, Ownable, ReentrancyGuard {
1296 
1297     using EnumerableSet for EnumerableSet.UintSet;
1298 
1299     mapping (address => uint256) public totalStakedTokens;
1300     mapping(uint256 => uint256) public stakedDays;
1301     mapping(address => EnumerableSet.UintSet) private _deposits;
1302 
1303     mapping(address => EnumerableSet.UintSet) private _depositsMutant;
1304     mapping (address => uint256) public totalStakedMutantTokens;
1305     mapping(uint256 => uint256) public stakedMutantDays;
1306 
1307     uint256 public ReservedForLiquidity = 888888 ether;
1308 
1309     uint256 constant public APE_RATE = 10 ether; 
1310     uint256 constant public GOLD_RATE = 20 ether;
1311 
1312 
1313     uint256 constant public MUTANT_RATE = 5 ether;
1314     uint256 constant public MUTANT_M3_RATE = 20 ether;
1315 
1316     
1317     uint256[] public GOLD_APES = [1207, 415 , 286 , 2591, 2457, 2131, 2128, 1704, 1605, 1529, 1437, 1378, 3794, 3776, 3730, 3207, 3028, 2663, 4441, 4354, 4325, 3910];
1318     uint256 [] public M3 = [3499,1046,4407,83,2736];
1319     
1320 
1321     address[] public stakedWalletSlape;
1322     address[] public stakedWalletMutant;
1323     address[] private tempArray;
1324 
1325     IERC721 public superlativeApesContract = IERC721(0x1e87eE9249Cc647Af9EDEecB73D6b76AF14d8C27);
1326     IERC721 public superlativeMutantContract = IERC721(0x9FB2EEb75754815c5Cc9092Cd53549cEa5dc404f);
1327 
1328     constructor() 
1329     {
1330         _mint(msg.sender,ReservedForLiquidity);
1331     }
1332 
1333     function stakedWalletsLength() public view returns(uint256)
1334     {
1335         return stakedWalletSlape.length;
1336     }
1337 
1338     function teamMint(uint256 totalAmount) public onlyOwner
1339     {
1340         _mint(msg.sender, (totalAmount * 10 ** 18));
1341     }
1342 
1343     function StakeYourSlape(uint256[] calldata tokenID) public 
1344     {
1345         require(superlativeApesContract.isApprovedForAll(msg.sender, address(this)), "You are not Approved to stake your NFT!");
1346         
1347         for(uint256 i; i<tokenID.length; i++)
1348         {
1349             superlativeApesContract.safeTransferFrom(msg.sender, address(this), tokenID[i], "");
1350 
1351             if(!contains(msg.sender))
1352             {
1353                 stakedWalletSlape.push(msg.sender);
1354             }
1355             
1356             _deposits[msg.sender].add(tokenID[i]);
1357             totalStakedTokens[msg.sender] = totalStakedTokens[msg.sender] + 1;
1358             stakedDays[tokenID[i]] = block.timestamp;
1359         }
1360     }
1361 
1362     function unStakeYourSlape(uint256[] calldata tokenID) public 
1363     {
1364         claimTokens();
1365         for(uint256 i; i<tokenID.length; i++)
1366         {
1367             superlativeApesContract.safeTransferFrom(address(this), msg.sender, tokenID[i], "");
1368             _deposits[msg.sender].remove(tokenID[i]);
1369             totalStakedTokens[msg.sender] = totalStakedTokens[msg.sender] + 1;
1370 
1371             if(_deposits[msg.sender].values().length < 1)
1372             {
1373                 remove(msg.sender);
1374             }
1375         }
1376     }
1377 
1378     function contains(address _incoming) internal view returns(bool)
1379     {
1380         bool doesListContainElement = false;
1381     
1382         for (uint i=0; i < stakedWalletSlape.length; i++) {
1383             if (_incoming == stakedWalletSlape[i]) {
1384                 doesListContainElement = true;
1385             }
1386         }
1387 
1388         return doesListContainElement;
1389     }
1390     
1391     function remove(address _incoming) internal {
1392 
1393         delete tempArray;
1394         
1395         for (uint256 i = 0; i<stakedWalletSlape.length; i++){
1396             if(stakedWalletSlape[i] != _incoming)
1397             {
1398                 tempArray.push(stakedWalletSlape[i]);
1399             }
1400         }
1401 
1402         delete stakedWalletSlape;
1403 
1404         stakedWalletSlape = tempArray;
1405         
1406     }
1407 
1408 
1409     function claimTokens() public 
1410     {
1411         uint256 payout = 0;
1412         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
1413         {
1414             payout += totalRewardsToPay(_deposits[msg.sender].at(i));
1415             stakedDays[_deposits[msg.sender].at(i)] = block.timestamp;
1416         }
1417         _mint(msg.sender, payout);
1418     }
1419 
1420     function viewRewardTotal() external view returns (uint256)
1421     {
1422         uint256 payout = 0;
1423         
1424         for(uint256 i = 0; i < _deposits[msg.sender].length(); i++)
1425         {
1426             payout = payout + totalRewardsToPay(_deposits[msg.sender].at(i));
1427         }
1428         return payout;
1429     }
1430 
1431     function totalRewardsToPay(uint256 tokenId) internal view returns(uint256)
1432     {
1433         uint256 payout = 0;
1434         
1435         payout = howManyDaysStaked(tokenId) * APE_RATE;
1436 
1437         for(uint256 i=0; i<GOLD_APES.length; i++)
1438         {
1439             if(tokenId == GOLD_APES[i])
1440             {
1441                 payout = howManyDaysStaked(tokenId) * GOLD_RATE;
1442             }   
1443         }
1444         return payout;
1445     }
1446 
1447     function howManyDaysStaked(uint256 tokenId) public view returns(uint256)
1448     {
1449         
1450         require(
1451             _deposits[msg.sender].contains(tokenId),
1452             'Token not deposited'
1453         );
1454         
1455         uint256 timeCalc = block.timestamp - stakedDays[tokenId];
1456         uint256 returndays = timeCalc / 86400;
1457        
1458         return returndays;
1459     }
1460 
1461     function returnStakedTokens() public view returns (uint256[] memory)
1462     {
1463         return _deposits[msg.sender].values();
1464     }
1465     
1466 
1467 
1468     //Mutant Functions
1469 
1470     function containsMutate(address _incoming) internal view returns(bool)
1471     {
1472         bool doesListContainElement = false;
1473     
1474         for (uint i=0; i < stakedWalletMutant.length; i++) {
1475             if (_incoming == stakedWalletMutant[i]) {
1476                 doesListContainElement = true;
1477             }
1478         }
1479 
1480         return doesListContainElement;
1481     }
1482 
1483     function unStakeYourMutant(uint256[] calldata tokenID) public 
1484     {
1485         claimTokensMutants();
1486         for(uint256 i; i<tokenID.length; i++)
1487         {
1488             superlativeMutantContract.safeTransferFrom(address(this), msg.sender, tokenID[i], "");
1489             _depositsMutant[msg.sender].remove(tokenID[i]);
1490             totalStakedMutantTokens[msg.sender] = totalStakedMutantTokens[msg.sender] + 1;
1491 
1492             if(_depositsMutant[msg.sender].values().length < 1)
1493             {
1494                 remove(msg.sender);
1495             }
1496         }
1497     }
1498 
1499     function StakeYourMutant(uint256[] calldata tokenID) public 
1500     {
1501         require(superlativeMutantContract.isApprovedForAll(msg.sender, address(this)), "You are not Approved to stake your NFT!");
1502         
1503         for(uint256 i; i<tokenID.length; i++)
1504         {
1505             superlativeMutantContract.safeTransferFrom(msg.sender, address(this), tokenID[i], "");
1506 
1507             if(!containsMutate(msg.sender))
1508             {
1509                 stakedWalletMutant.push(msg.sender);
1510             }
1511             
1512             _depositsMutant[msg.sender].add(tokenID[i]);
1513             totalStakedMutantTokens[msg.sender] = totalStakedMutantTokens[msg.sender] + 1;
1514             stakedMutantDays[tokenID[i]] = block.timestamp;
1515         }
1516     }
1517 
1518     function claimTokensMutants() public 
1519     {
1520         uint256 payout = 0;
1521         for(uint256 i = 0; i < _depositsMutant[msg.sender].length(); i++)
1522         {
1523             payout += totalRewardsToPayMutant(_depositsMutant[msg.sender].at(i));   
1524             stakedMutantDays[_depositsMutant[msg.sender].at(i)] = block.timestamp;
1525         }
1526 
1527         _mint(msg.sender, payout);
1528     }
1529 
1530     function viewRewardTotalMutant() external view returns (uint256)
1531     {
1532         uint256 payout = 0;
1533         
1534         for(uint256 i = 0; i < _depositsMutant[msg.sender].length(); i++)
1535         {
1536             payout = payout + totalRewardsToPayMutant(_depositsMutant[msg.sender].at(i));
1537         }
1538         return payout;
1539     }
1540 
1541     function howManyDaysStakedMutant(uint256 tokenId) public view returns(uint256)
1542     {
1543         
1544         require(
1545             _depositsMutant[msg.sender].contains(tokenId),
1546             'Token not deposited'
1547         );
1548         
1549         uint256 timeCalc = block.timestamp - stakedMutantDays[tokenId];
1550         uint256 returndays = timeCalc / 86400;
1551        
1552         return returndays;
1553     }
1554 
1555     function returnStakedTokensMutant() public view returns (uint256[] memory)
1556     {
1557         return _depositsMutant[msg.sender].values();
1558     }
1559 
1560     function totalRewardsToPayMutant(uint256 tokenId) internal view returns(uint256)
1561     {
1562         uint256 payout = howManyDaysStakedMutant(tokenId) * MUTANT_RATE;
1563         
1564         for(uint256 i=0;i<M3.length;i++)
1565         {
1566             if(M3[i] == tokenId)
1567             {
1568                 payout = howManyDaysStakedMutant(tokenId) * MUTANT_M3_RATE;
1569             }
1570         }
1571 
1572         if(tokenId >= 13333)
1573         {
1574             payout = howManyDaysStakedMutant(tokenId) * MUTANT_M3_RATE;
1575         }
1576         
1577         
1578         return payout;
1579     }
1580 
1581 
1582     function onERC721Received(
1583         address,
1584         address,
1585         uint256,
1586         bytes calldata
1587     ) external pure override returns (bytes4) {
1588         return IERC721Receiver.onERC721Received.selector;
1589     }
1590 }