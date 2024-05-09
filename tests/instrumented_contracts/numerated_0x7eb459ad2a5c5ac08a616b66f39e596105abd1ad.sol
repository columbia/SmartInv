1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Library for managing
116  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
117  * types.
118  *
119  * Sets have the following properties:
120  *
121  * - Elements are added, removed, and checked for existence in constant time
122  * (O(1)).
123  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
124  *
125  * ```
126  * contract Example {
127  *     // Add the library methods
128  *     using EnumerableSet for EnumerableSet.AddressSet;
129  *
130  *     // Declare a set state variable
131  *     EnumerableSet.AddressSet private mySet;
132  * }
133  * ```
134  *
135  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
136  * and `uint256` (`UintSet`) are supported.
137  */
138 library EnumerableSet {
139     // To implement this library for multiple types with as little code
140     // repetition as possible, we write it in terms of a generic Set type with
141     // bytes32 values.
142     // The Set implementation uses private functions, and user-facing
143     // implementations (such as AddressSet) are just wrappers around the
144     // underlying Set.
145     // This means that we can only create new EnumerableSets for types that fit
146     // in bytes32.
147 
148     struct Set {
149         // Storage of set values
150         bytes32[] _values;
151         // Position of the value in the `values` array, plus 1 because index 0
152         // means a value is not in the set.
153         mapping(bytes32 => uint256) _indexes;
154     }
155 
156     /**
157      * @dev Add a value to a set. O(1).
158      *
159      * Returns true if the value was added to the set, that is if it was not
160      * already present.
161      */
162     function _add(Set storage set, bytes32 value) private returns (bool) {
163         if (!_contains(set, value)) {
164             set._values.push(value);
165             // The value is stored at length-1, but we add 1 to all indexes
166             // and use 0 as a sentinel value
167             set._indexes[value] = set._values.length;
168             return true;
169         } else {
170             return false;
171         }
172     }
173 
174     /**
175      * @dev Removes a value from a set. O(1).
176      *
177      * Returns true if the value was removed from the set, that is if it was
178      * present.
179      */
180     function _remove(Set storage set, bytes32 value) private returns (bool) {
181         // We read and store the value's index to prevent multiple reads from the same storage slot
182         uint256 valueIndex = set._indexes[value];
183 
184         if (valueIndex != 0) {
185             // Equivalent to contains(set, value)
186             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
187             // the array, and then remove the last element (sometimes called as 'swap and pop').
188             // This modifies the order of the array, as noted in {at}.
189 
190             uint256 toDeleteIndex = valueIndex - 1;
191             uint256 lastIndex = set._values.length - 1;
192 
193             if (lastIndex != toDeleteIndex) {
194                 bytes32 lastvalue = set._values[lastIndex];
195 
196                 // Move the last value to the index where the value to delete is
197                 set._values[toDeleteIndex] = lastvalue;
198                 // Update the index for the moved value
199                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
200             }
201 
202             // Delete the slot where the moved value was stored
203             set._values.pop();
204 
205             // Delete the index for the deleted slot
206             delete set._indexes[value];
207 
208             return true;
209         } else {
210             return false;
211         }
212     }
213 
214     /**
215      * @dev Returns true if the value is in the set. O(1).
216      */
217     function _contains(Set storage set, bytes32 value) private view returns (bool) {
218         return set._indexes[value] != 0;
219     }
220 
221     /**
222      * @dev Returns the number of values on the set. O(1).
223      */
224     function _length(Set storage set) private view returns (uint256) {
225         return set._values.length;
226     }
227 
228     /**
229      * @dev Returns the value stored at position `index` in the set. O(1).
230      *
231      * Note that there are no guarantees on the ordering of values inside the
232      * array, and it may change when more values are added or removed.
233      *
234      * Requirements:
235      *
236      * - `index` must be strictly less than {length}.
237      */
238     function _at(Set storage set, uint256 index) private view returns (bytes32) {
239         return set._values[index];
240     }
241 
242     /**
243      * @dev Return the entire set in an array
244      *
245      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
246      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
247      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
248      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
249      */
250     function _values(Set storage set) private view returns (bytes32[] memory) {
251         return set._values;
252     }
253 
254     // Bytes32Set
255 
256     struct Bytes32Set {
257         Set _inner;
258     }
259 
260     /**
261      * @dev Add a value to a set. O(1).
262      *
263      * Returns true if the value was added to the set, that is if it was not
264      * already present.
265      */
266     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
267         return _add(set._inner, value);
268     }
269 
270     /**
271      * @dev Removes a value from a set. O(1).
272      *
273      * Returns true if the value was removed from the set, that is if it was
274      * present.
275      */
276     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
277         return _remove(set._inner, value);
278     }
279 
280     /**
281      * @dev Returns true if the value is in the set. O(1).
282      */
283     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
284         return _contains(set._inner, value);
285     }
286 
287     /**
288      * @dev Returns the number of values in the set. O(1).
289      */
290     function length(Bytes32Set storage set) internal view returns (uint256) {
291         return _length(set._inner);
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
304     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
305         return _at(set._inner, index);
306     }
307 
308     /**
309      * @dev Return the entire set in an array
310      *
311      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
312      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
313      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
314      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
315      */
316     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
317         return _values(set._inner);
318     }
319 
320     // AddressSet
321 
322     struct AddressSet {
323         Set _inner;
324     }
325 
326     /**
327      * @dev Add a value to a set. O(1).
328      *
329      * Returns true if the value was added to the set, that is if it was not
330      * already present.
331      */
332     function add(AddressSet storage set, address value) internal returns (bool) {
333         return _add(set._inner, bytes32(uint256(uint160(value))));
334     }
335 
336     /**
337      * @dev Removes a value from a set. O(1).
338      *
339      * Returns true if the value was removed from the set, that is if it was
340      * present.
341      */
342     function remove(AddressSet storage set, address value) internal returns (bool) {
343         return _remove(set._inner, bytes32(uint256(uint160(value))));
344     }
345 
346     /**
347      * @dev Returns true if the value is in the set. O(1).
348      */
349     function contains(AddressSet storage set, address value) internal view returns (bool) {
350         return _contains(set._inner, bytes32(uint256(uint160(value))));
351     }
352 
353     /**
354      * @dev Returns the number of values in the set. O(1).
355      */
356     function length(AddressSet storage set) internal view returns (uint256) {
357         return _length(set._inner);
358     }
359 
360     /**
361      * @dev Returns the value stored at position `index` in the set. O(1).
362      *
363      * Note that there are no guarantees on the ordering of values inside the
364      * array, and it may change when more values are added or removed.
365      *
366      * Requirements:
367      *
368      * - `index` must be strictly less than {length}.
369      */
370     function at(AddressSet storage set, uint256 index) internal view returns (address) {
371         return address(uint160(uint256(_at(set._inner, index))));
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
382     function values(AddressSet storage set) internal view returns (address[] memory) {
383         bytes32[] memory store = _values(set._inner);
384         address[] memory result;
385 
386         assembly {
387             result := store
388         }
389 
390         return result;
391     }
392 
393     // UintSet
394 
395     struct UintSet {
396         Set _inner;
397     }
398 
399     /**
400      * @dev Add a value to a set. O(1).
401      *
402      * Returns true if the value was added to the set, that is if it was not
403      * already present.
404      */
405     function add(UintSet storage set, uint256 value) internal returns (bool) {
406         return _add(set._inner, bytes32(value));
407     }
408 
409     /**
410      * @dev Removes a value from a set. O(1).
411      *
412      * Returns true if the value was removed from the set, that is if it was
413      * present.
414      */
415     function remove(UintSet storage set, uint256 value) internal returns (bool) {
416         return _remove(set._inner, bytes32(value));
417     }
418 
419     /**
420      * @dev Returns true if the value is in the set. O(1).
421      */
422     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
423         return _contains(set._inner, bytes32(value));
424     }
425 
426     /**
427      * @dev Returns the number of values on the set. O(1).
428      */
429     function length(UintSet storage set) internal view returns (uint256) {
430         return _length(set._inner);
431     }
432 
433     /**
434      * @dev Returns the value stored at position `index` in the set. O(1).
435      *
436      * Note that there are no guarantees on the ordering of values inside the
437      * array, and it may change when more values are added or removed.
438      *
439      * Requirements:
440      *
441      * - `index` must be strictly less than {length}.
442      */
443     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
444         return uint256(_at(set._inner, index));
445     }
446 
447     /**
448      * @dev Return the entire set in an array
449      *
450      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
451      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
452      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
453      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
454      */
455     function values(UintSet storage set) internal view returns (uint256[] memory) {
456         bytes32[] memory store = _values(set._inner);
457         uint256[] memory result;
458 
459         assembly {
460             result := store
461         }
462 
463         return result;
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @title ERC721 token receiver interface
476  * @dev Interface for any contract that wants to support safeTransfers
477  * from ERC721 asset contracts.
478  */
479 interface IERC721Receiver {
480     /**
481      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
482      * by `operator` from `from`, this function is called.
483      *
484      * It must return its Solidity selector to confirm the token transfer.
485      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
486      *
487      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
488      */
489     function onERC721Received(
490         address operator,
491         address from,
492         uint256 tokenId,
493         bytes calldata data
494     ) external returns (bytes4);
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Implementation of the {IERC721Receiver} interface.
507  *
508  * Accepts all token transfers.
509  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
510  */
511 contract ERC721Holder is IERC721Receiver {
512     /**
513      * @dev See {IERC721Receiver-onERC721Received}.
514      *
515      * Always returns `IERC721Receiver.onERC721Received.selector`.
516      */
517     function onERC721Received(
518         address,
519         address,
520         uint256,
521         bytes memory
522     ) public virtual override returns (bytes4) {
523         return this.onERC721Received.selector;
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev Interface of the ERC20 standard as defined in the EIP.
536  */
537 interface IERC20 {
538     /**
539      * @dev Returns the amount of tokens in existence.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     /**
544      * @dev Returns the amount of tokens owned by `account`.
545      */
546     function balanceOf(address account) external view returns (uint256);
547 
548     /**
549      * @dev Moves `amount` tokens from the caller's account to `recipient`.
550      *
551      * Returns a boolean value indicating whether the operation succeeded.
552      *
553      * Emits a {Transfer} event.
554      */
555     function transfer(address recipient, uint256 amount) external returns (bool);
556 
557     /**
558      * @dev Returns the remaining number of tokens that `spender` will be
559      * allowed to spend on behalf of `owner` through {transferFrom}. This is
560      * zero by default.
561      *
562      * This value changes when {approve} or {transferFrom} are called.
563      */
564     function allowance(address owner, address spender) external view returns (uint256);
565 
566     /**
567      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
568      *
569      * Returns a boolean value indicating whether the operation succeeded.
570      *
571      * IMPORTANT: Beware that changing an allowance with this method brings the risk
572      * that someone may use both the old and the new allowance by unfortunate
573      * transaction ordering. One possible solution to mitigate this race
574      * condition is to first reduce the spender's allowance to 0 and set the
575      * desired value afterwards:
576      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
577      *
578      * Emits an {Approval} event.
579      */
580     function approve(address spender, uint256 amount) external returns (bool);
581 
582     /**
583      * @dev Moves `amount` tokens from `sender` to `recipient` using the
584      * allowance mechanism. `amount` is then deducted from the caller's
585      * allowance.
586      *
587      * Returns a boolean value indicating whether the operation succeeded.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transferFrom(
592         address sender,
593         address recipient,
594         uint256 amount
595     ) external returns (bool);
596 
597     /**
598      * @dev Emitted when `value` tokens are moved from one account (`from`) to
599      * another (`to`).
600      *
601      * Note that `value` may be zero.
602      */
603     event Transfer(address indexed from, address indexed to, uint256 value);
604 
605     /**
606      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
607      * a call to {approve}. `value` is the new allowance.
608      */
609     event Approval(address indexed owner, address indexed spender, uint256 value);
610 }
611 
612 // File: interfaces/IMintableERC20.sol
613 
614 
615 pragma solidity =0.8.10;
616 
617 
618 /**
619  * @notice ERC20-compliant interface with added
620  *         function for minting new tokens to addresses
621  *
622  * See {IERC20}
623  */
624 interface IMintableERC20 is IERC20 {
625   /**
626    * @dev Allows issuing new tokens to an address
627    *
628    * @dev Should have restricted access
629    */
630   function mint(address _to, uint256 _amount) external;
631 }
632 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev Interface of the ERC165 standard, as defined in the
641  * https://eips.ethereum.org/EIPS/eip-165[EIP].
642  *
643  * Implementers can declare support of contract interfaces, which can then be
644  * queried by others ({ERC165Checker}).
645  *
646  * For an implementation, see {ERC165}.
647  */
648 interface IERC165 {
649     /**
650      * @dev Returns true if this contract implements the interface defined by
651      * `interfaceId`. See the corresponding
652      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
653      * to learn more about how these ids are created.
654      *
655      * This function call must use less than 30 000 gas.
656      */
657     function supportsInterface(bytes4 interfaceId) external view returns (bool);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @dev Required interface of an ERC721 compliant contract.
670  */
671 interface IERC721 is IERC165 {
672     /**
673      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
674      */
675     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
676 
677     /**
678      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
679      */
680     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
681 
682     /**
683      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
684      */
685     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
686 
687     /**
688      * @dev Returns the number of tokens in ``owner``'s account.
689      */
690     function balanceOf(address owner) external view returns (uint256 balance);
691 
692     /**
693      * @dev Returns the owner of the `tokenId` token.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function ownerOf(uint256 tokenId) external view returns (address owner);
700 
701     /**
702      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
703      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
712      *
713      * Emits a {Transfer} event.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) external;
720 
721     /**
722      * @dev Transfers `tokenId` token from `from` to `to`.
723      *
724      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
725      *
726      * Requirements:
727      *
728      * - `from` cannot be the zero address.
729      * - `to` cannot be the zero address.
730      * - `tokenId` token must be owned by `from`.
731      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
732      *
733      * Emits a {Transfer} event.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) external;
740 
741     /**
742      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
743      * The approval is cleared when the token is transferred.
744      *
745      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
746      *
747      * Requirements:
748      *
749      * - The caller must own the token or be an approved operator.
750      * - `tokenId` must exist.
751      *
752      * Emits an {Approval} event.
753      */
754     function approve(address to, uint256 tokenId) external;
755 
756     /**
757      * @dev Returns the account approved for `tokenId` token.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function getApproved(uint256 tokenId) external view returns (address operator);
764 
765     /**
766      * @dev Approve or remove `operator` as an operator for the caller.
767      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
768      *
769      * Requirements:
770      *
771      * - The `operator` cannot be the caller.
772      *
773      * Emits an {ApprovalForAll} event.
774      */
775     function setApprovalForAll(address operator, bool _approved) external;
776 
777     /**
778      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
779      *
780      * See {setApprovalForAll}
781      */
782     function isApprovedForAll(address owner, address operator) external view returns (bool);
783 
784     /**
785      * @dev Safely transfers `tokenId` token from `from` to `to`.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId,
801         bytes calldata data
802     ) external;
803 }
804 
805 // File: ExoticApeStaking.sol
806 
807 
808 pragma solidity =0.8.10;
809 
810 
811 
812 
813 
814 
815 /**
816  * @notice Staking contract that allows NFT users
817  *         to temporarily lock their NFTs to earn
818  *         ERC-20 token rewards
819  *
820  * The NFTs are locked inside this contract for the
821  * duration of the staking period while allowing the
822  * user to unstake at any time
823  *
824  * While the NFTs are staked, they are technically
825  * owned by this contract and cannot be moved or placed
826  * on any marketplace
827  *
828  * The contract allows users to stake and unstake multiple
829  * NFTs efficiently, in one transaction
830  *
831  * Staking rewards are paid out to users once
832  * they unstake their NFTs and are calculated
833  * based on a rounded down number of days the NFTs
834  * were staken for
835  *
836  * Some of the rarest NFTs are boosted by the contract
837  * owner to receive bigger staking rewards
838  *
839  * @dev Features a contract owner that is able to change
840  *      the daily rewards, the boosted NFT list and the
841  *      boosted NFT daily rewards
842  */
843 contract ExoticApeStaking is ERC721Holder, Ownable {
844   using EnumerableSet for EnumerableSet.UintSet;
845 
846   /**
847    * @notice Stores the ERC-20 token that will
848    *         be paid out to NFT holders for staking
849    */
850   IMintableERC20 public immutable erc20;
851 
852   /**
853    * @notice Stores the ERC-721 token that will
854    *         be staken to receive ERC-20 rewards
855    */
856   IERC721 public immutable erc721;
857 
858   /**
859    * @notice Amount of tokens earned for each
860    *         day (24 hours) the token was staked for
861    *
862    * @dev Can be changed by contract owner via setDailyRewards()
863    */
864   uint128 public dailyRewards;
865 
866   /**
867    * @notice Some NFTs are boosted to receive bigger token
868    *         rewards. This multiplier shows how much more
869    *         they will receive
870    *
871    * E.g. dailyRewardBoostMultiplier = 10 means that the boosted
872    * NFTs will receive 10 times the dailyRewards
873    *
874    * @dev Can be changed by contract owner via setDailyRewardBoostMultiplier()
875    */
876   uint128 public dailyRewardBoostMultiplier;
877 
878   /**
879    * @notice Boosted NFTs contained in this list
880    *         earn bigger daily rewards
881    *
882    * @dev We use an EnumerableSet to store this data
883    *      instead of an array to be able to query in
884    *      O(1) complexity
885    *
886    ** @dev Can be changed by contract owner via setBoostedNftIds()
887    */
888   EnumerableSet.UintSet private boostedNftIds;
889 
890   /**
891    * @notice Stores ownership information for staked
892    *         NFTs
893    */
894   mapping(uint256 => address) public ownerOf;
895 
896   /**
897    * @notice Stores time staking started for staked
898    *         NFTs
899    */
900   mapping(uint256 => uint256) public stakedAt;
901 
902   /**
903    * @dev Stores the staked tokens of an address
904    */
905   mapping(address => EnumerableSet.UintSet) private stakedTokens;
906 
907   /**
908    * @dev Smart contract unique identifier, a random number
909    *
910    * @dev Should be regenerated each time smart contact source code is changed
911    *      and changes smart contract itself is to be redeployed
912    *
913    * @dev Generated using https://www.random.org/bytes/
914    */
915 	uint256 public constant UID = 0x78ea82e97e97cd54405b116b0209cbaf8bcb22911b5ad1045e81ea6caf7d47fa;
916 
917   /**
918    * @dev Sets initialization variables which cannot be
919    *      changed in the future
920    *
921    * @param _erc20Address address of erc20 rewards token
922    * @param _erc721Address address of erc721 token to be staken for rewards
923    * @param _dailyRewards daily amount of tokens to be paid to stakers for every day
924    *                       they have staken an NFT
925    * @param _boostedNftIds boosted NFTs receive bigger rewards
926    * @param _dailyRewardBoostMultiplier multiplier of rewards for boosted NFTs
927    */
928   constructor(
929     address _erc20Address,
930     address _erc721Address,
931     uint128 _dailyRewards,
932     uint256[] memory _boostedNftIds,
933     uint128 _dailyRewardBoostMultiplier
934   ) {
935     erc20 = IMintableERC20(_erc20Address);
936     erc721 = IERC721(_erc721Address);
937     setDailyRewards(_dailyRewards);
938     setBoostedNftIds(_boostedNftIds);
939     setDailyRewardBoostMultiplier(_dailyRewardBoostMultiplier);
940   }
941 
942   /**
943    * @dev Emitted every time a token is staked
944    *
945    * Emitted in stake()
946    *
947    * @param by address that staked the NFT
948    * @param time block timestamp the NFT were staked at
949    * @param tokenId token ID of NFT that was staken
950    */
951   event Staked(address indexed by, uint256 indexed tokenId, uint256 time);
952 
953   /**
954    * @dev Emitted every time a token is unstaked
955    *
956    * Emitted in unstake()
957    *
958    * @param by address that unstaked the NFT
959    * @param time block timestamp the NFT were staked at
960    * @param tokenId token ID of NFT that was unstaken
961    * @param stakedAt when the NFT initially staked at
962    * @param reward how many tokens user got for the
963    *               staking of the NFT
964    */
965   event Unstaked(address indexed by, uint256 indexed tokenId, uint256 time, uint256 stakedAt, uint256 reward);
966 
967   /**
968    * @dev Emitted when the boosted NFT ids is changed
969    *
970    * Emitted in setDailyReward()
971    *
972    * @param by address that changed the daily reward
973    * @param oldDailyRewards old daily reward
974    * @param newDailyRewards new daily reward in effect
975    */
976   event DailyRewardsChanged(address indexed by, uint128 oldDailyRewards, uint128 newDailyRewards);
977 
978   /**
979    * @dev Emitted when the boosted NFT daily reward
980    *      multiplier is changed
981    *
982    * Emitted in setDailyRewardBoostMultiplier()
983    *
984    * @param by address that changed the daily reward boost multiplier
985    * @param oldDailyRewardBoostMultiplier old daily reward boost multiplier
986    * @param newDailyRewardBoostMultiplier new daily reward boost multiplier
987    */
988   event DailyRewardBoostMultiplierChanged(
989     address indexed by,
990     uint128 oldDailyRewardBoostMultiplier,
991     uint128 newDailyRewardBoostMultiplier
992   );
993 
994   /**
995    * @dev Emitted when the boosted NFT ids change
996    *
997    * Emitted in setBoostedNftIds()
998    *
999    * @param by address that changed the boosted NFT ids
1000    * @param oldBoostedNftIds old boosted NFT ids
1001    * @param newBoostedNftIds new boosted NFT ids
1002    */
1003   event BoostedNftIdsChanged(address indexed by, uint256[] oldBoostedNftIds, uint256[] newBoostedNftIds);
1004 
1005   /**
1006    * @notice Checks whether a token is boosted to receive
1007    *         bigger staking rewards
1008    *
1009    * @param _tokenId ID of token to check
1010    * @return whether the token is boosted
1011    */
1012   function isBoostedToken(uint256 _tokenId) public view returns (bool) {
1013     return boostedNftIds.contains(_tokenId);
1014   }
1015 
1016   /**
1017    * @notice Changes the daily reward in erc20 tokens received
1018    *         for every NFT staked
1019    *
1020    * @dev Restricted to contract owner
1021    *
1022    * @param _newDailyRewards the new daily reward in erc20 tokens
1023    */
1024   function setDailyRewards(uint128 _newDailyRewards) public onlyOwner {
1025     // Emit event
1026     emit DailyRewardsChanged(msg.sender, dailyRewards, _newDailyRewards);
1027 
1028     // Change storage variable
1029     dailyRewards = _newDailyRewards;
1030   }
1031 
1032   /**
1033    * @notice Changes the daily reward boost multiplier for
1034    *         boosted NFTs
1035    *
1036    * @dev Restricted to contract owner
1037    *
1038    * @param _newDailyRewardBoostMultiplier the new daily reward boost multiplier
1039    */
1040   function setDailyRewardBoostMultiplier(uint128 _newDailyRewardBoostMultiplier) public onlyOwner {
1041     // Emit event
1042     emit DailyRewardBoostMultiplierChanged(msg.sender, dailyRewardBoostMultiplier, _newDailyRewardBoostMultiplier);
1043 
1044     // Change storage variable
1045     dailyRewardBoostMultiplier = _newDailyRewardBoostMultiplier;
1046   }
1047 
1048   /**
1049    * @notice Changes the boosted NFT ids that receive
1050    *         a bigger daily reward
1051    *
1052    * @dev Restricted to contract owner
1053    *
1054    * @param _newBoostedNftIds the new boosted NFT ids
1055    */
1056   function setBoostedNftIds(uint256[] memory _newBoostedNftIds) public onlyOwner {
1057     // Create array to store old boosted NFTs and emit
1058     // event later
1059     uint256[] memory oldBoostedNftIds = new uint256[](boostedNftIds.length());
1060 
1061     // Empty boosted NFT ids set
1062     for (uint256 i = 0; boostedNftIds.length() > 0; i++) {
1063       // Get a value from the set
1064       // Since set length is > 0 it is guaranteed
1065       // that there is a value at index 0
1066       uint256 value = boostedNftIds.at(0);
1067 
1068       // Remove the value
1069       boostedNftIds.remove(value);
1070 
1071       // Store the value to the old boosted NFT ids
1072       // list to later emit event
1073       oldBoostedNftIds[i] = value;
1074     }
1075 
1076     // Emit event
1077     emit BoostedNftIdsChanged(msg.sender, oldBoostedNftIds, _newBoostedNftIds);
1078 
1079     // Enumerate new boosted NFT ids
1080     for (uint256 i = 0; i < _newBoostedNftIds.length; i++) {
1081       uint256 boostedNftId = _newBoostedNftIds[i];
1082 
1083       // Add boosted NFT id to set
1084       boostedNftIds.add(boostedNftId);
1085     }
1086   }
1087 
1088   /**
1089    * @notice Calculates all the NFTs currently staken by
1090    *         an address
1091    *
1092    * @dev This is an auxiliary function to help with integration
1093    *      and is not used anywhere in the smart contract login
1094    *
1095    * @param _owner address to search staked tokens of
1096    * @return an array of token IDs of NFTs that are currently staken
1097    */
1098   function tokensStakedByOwner(address _owner) external view returns (uint256[] memory) {
1099     // Cache the length of the staked tokens set for the owner
1100     uint256 stakedTokensLength = stakedTokens[_owner].length();
1101 
1102     // Create an empty array to store the result
1103     // Should be the same length as the staked tokens
1104     // set
1105     uint256[] memory tokenIds = new uint256[](stakedTokensLength);
1106 
1107     // Copy set values to array
1108     for (uint256 i = 0; i < stakedTokensLength; i++) {
1109       tokenIds[i] = stakedTokens[_owner].at(i);
1110     }
1111 
1112     // Return array result
1113     return tokenIds;
1114   }
1115 
1116   /**
1117    * @notice Calculates the rewards that would be earned by
1118    *         the user for each an NFT if he was to unstake it at
1119    *         the current block
1120    *
1121    * @param _tokenId token ID of NFT rewards are to be calculated for
1122    * @return the amount of rewards for the input staken NFT
1123    */
1124   function currentRewardsOf(uint256 _tokenId) public view returns (uint256) {
1125     // Verify NFT is staked
1126     require(stakedAt[_tokenId] != 0, "not staked");
1127 
1128     // Get current token ID staking time by calculating the
1129     // delta between the current block time(`block.timestamp`)
1130     // and the time the token was initially staked(`stakedAt[tokenId]`)
1131     uint256 stakingTime = block.timestamp - stakedAt[_tokenId];
1132 
1133     // `stakingTime` is the staking time in seconds
1134     // Calculate the staking time in days by:
1135     //   * dividing by 60 (seconds in a minute)
1136     //   * dividing by 60 (minutes in an hour)
1137     //   * dividing by 24 (hours in a day)
1138     // This will yield the (rounded down) staking
1139     // time in days
1140     uint256 stakingDays = stakingTime / 60 / 60 / 24;
1141 
1142     // Calculate reward for token by multiplying
1143     // rounded down number of staked days by daily
1144     // rewards variable
1145     uint256 reward = stakingDays * dailyRewards;
1146 
1147     // If the NFT is boosted
1148     if (isBoostedToken(_tokenId)) {
1149       // Multiply the reward
1150       reward *= dailyRewardBoostMultiplier;
1151     }
1152 
1153     // Return reward
1154     return reward;
1155   }
1156 
1157   /**
1158    * @notice Stake NFTs to start earning ERC-20
1159    *         token rewards
1160    *
1161    * The ERC-20 token rewards will be paid out
1162    * when the NFTs are unstaken
1163    *
1164    * @dev Sender must first approve this contract
1165    *      to transfer NFTs on his behalf and NFT
1166    *      ownership is transferred to this contract
1167    *      for the duration of the staking
1168    *
1169    * @param _tokenIds token IDs of NFTs to be staken
1170    */
1171   function stake(uint256[] memory _tokenIds) public {
1172     // Ensure at least one token ID was sent
1173     require(_tokenIds.length > 0, "no token IDs sent");
1174 
1175     // Enumerate sent token IDs
1176     for (uint256 i = 0; i < _tokenIds.length; i++) {
1177       // Get token ID
1178       uint256 tokenId = _tokenIds[i];
1179 
1180       // Store NFT owner
1181       ownerOf[tokenId] = msg.sender;
1182 
1183       // Add NFT to owner staked tokens
1184       stakedTokens[msg.sender].add(tokenId);
1185 
1186       // Store staking time as block timestamp the
1187       // the transaction was confirmed in
1188       stakedAt[tokenId] = block.timestamp;
1189 
1190       // Transfer token to staking contract
1191       // Will fail if the user does not own the
1192       // token or has not approved the staking
1193       // contract for transferring tokens on his
1194       // behalf
1195       erc721.safeTransferFrom(msg.sender, address(this), tokenId, "");
1196 
1197       // Emit event
1198       emit Staked(msg.sender, tokenId, stakedAt[tokenId]);
1199     }
1200   }
1201 
1202   /**
1203    * @notice Unstake NFTs to receive ERC-20 token rewards
1204    *
1205    * @dev Sender must have first staken the NFTs
1206    *
1207    * @param _tokenIds token IDs of NFTs to be unstaken
1208    */
1209   function unstake(uint256[] memory _tokenIds) public {
1210     // Ensure at least one token ID was sent
1211     require(_tokenIds.length > 0, "no token IDs sent");
1212 
1213     // Create a variable to store the total rewards for all
1214     // NFTs sent
1215     uint256 totalRewards = 0;
1216 
1217     // Enumerate sent token IDs
1218     for (uint256 i = 0; i < _tokenIds.length; i++) {
1219       // Get token ID
1220       uint256 tokenId = _tokenIds[i];
1221 
1222       // Verify sender is token ID owner
1223       // Will fail if token is not staked (owner is 0x0)
1224       require(ownerOf[tokenId] == msg.sender, "not token owner");
1225 
1226       // Calculate rewards for token ID. Will revert
1227       // if the token is not staken
1228       uint256 rewards = currentRewardsOf(tokenId);
1229 
1230       // Increase amount of total rewards
1231       // for all tokens sent
1232       totalRewards += rewards;
1233 
1234       // Emit event
1235       emit Unstaked(msg.sender, tokenId, block.timestamp, stakedAt[tokenId], rewards);
1236 
1237       // Reset `ownerOf` and `stakedAt`
1238       // for token
1239       ownerOf[tokenId] = address(0);
1240       stakedAt[tokenId] = 0;
1241 
1242       // Remove NFT from owner staked tokens
1243       stakedTokens[msg.sender].remove(tokenId);
1244 
1245       // Transfer NFT back to user
1246       erc721.transferFrom(address(this), msg.sender, tokenId);
1247     }
1248 
1249     // Mint total rewards for all sent NFTs
1250     // to user
1251     erc20.mint(msg.sender, totalRewards);
1252   }
1253 }