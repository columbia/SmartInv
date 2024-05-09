1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Library for managing
12  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
13  * types.
14  *
15  * Sets have the following properties:
16  *
17  * - Elements are added, removed, and checked for existence in constant time
18  * (O(1)).
19  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
20  *
21  * ```
22  * contract Example {
23  *     // Add the library methods
24  *     using EnumerableSet for EnumerableSet.AddressSet;
25  *
26  *     // Declare a set state variable
27  *     EnumerableSet.AddressSet private mySet;
28  * }
29  * ```
30  *
31  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
32  * and `uint256` (`UintSet`) are supported.
33  *
34  * [WARNING]
35  * ====
36  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
37  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
38  *
39  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
40  * ====
41  */
42 library EnumerableSet {
43     // To implement this library for multiple types with as little code
44     // repetition as possible, we write it in terms of a generic Set type with
45     // bytes32 values.
46     // The Set implementation uses private functions, and user-facing
47     // implementations (such as AddressSet) are just wrappers around the
48     // underlying Set.
49     // This means that we can only create new EnumerableSets for types that fit
50     // in bytes32.
51 
52     struct Set {
53         // Storage of set values
54         bytes32[] _values;
55         // Position of the value in the `values` array, plus 1 because index 0
56         // means a value is not in the set.
57         mapping(bytes32 => uint256) _indexes;
58     }
59 
60     /**
61      * @dev Add a value to a set. O(1).
62      *
63      * Returns true if the value was added to the set, that is if it was not
64      * already present.
65      */
66     function _add(Set storage set, bytes32 value) private returns (bool) {
67         if (!_contains(set, value)) {
68             set._values.push(value);
69             // The value is stored at length-1, but we add 1 to all indexes
70             // and use 0 as a sentinel value
71             set._indexes[value] = set._values.length;
72             return true;
73         } else {
74             return false;
75         }
76     }
77 
78     /**
79      * @dev Removes a value from a set. O(1).
80      *
81      * Returns true if the value was removed from the set, that is if it was
82      * present.
83      */
84     function _remove(Set storage set, bytes32 value) private returns (bool) {
85         // We read and store the value's index to prevent multiple reads from the same storage slot
86         uint256 valueIndex = set._indexes[value];
87 
88         if (valueIndex != 0) {
89             // Equivalent to contains(set, value)
90             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
91             // the array, and then remove the last element (sometimes called as 'swap and pop').
92             // This modifies the order of the array, as noted in {at}.
93 
94             uint256 toDeleteIndex = valueIndex - 1;
95             uint256 lastIndex = set._values.length - 1;
96 
97             if (lastIndex != toDeleteIndex) {
98                 bytes32 lastValue = set._values[lastIndex];
99 
100                 // Move the last value to the index where the value to delete is
101                 set._values[toDeleteIndex] = lastValue;
102                 // Update the index for the moved value
103                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
104             }
105 
106             // Delete the slot where the moved value was stored
107             set._values.pop();
108 
109             // Delete the index for the deleted slot
110             delete set._indexes[value];
111 
112             return true;
113         } else {
114             return false;
115         }
116     }
117 
118     /**
119      * @dev Returns true if the value is in the set. O(1).
120      */
121     function _contains(Set storage set, bytes32 value) private view returns (bool) {
122         return set._indexes[value] != 0;
123     }
124 
125     /**
126      * @dev Returns the number of values on the set. O(1).
127      */
128     function _length(Set storage set) private view returns (uint256) {
129         return set._values.length;
130     }
131 
132     /**
133      * @dev Returns the value stored at position `index` in the set. O(1).
134      *
135      * Note that there are no guarantees on the ordering of values inside the
136      * array, and it may change when more values are added or removed.
137      *
138      * Requirements:
139      *
140      * - `index` must be strictly less than {length}.
141      */
142     function _at(Set storage set, uint256 index) private view returns (bytes32) {
143         return set._values[index];
144     }
145 
146     /**
147      * @dev Return the entire set in an array
148      *
149      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
150      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
151      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
152      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
153      */
154     function _values(Set storage set) private view returns (bytes32[] memory) {
155         return set._values;
156     }
157 
158     // Bytes32Set
159 
160     struct Bytes32Set {
161         Set _inner;
162     }
163 
164     /**
165      * @dev Add a value to a set. O(1).
166      *
167      * Returns true if the value was added to the set, that is if it was not
168      * already present.
169      */
170     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
171         return _add(set._inner, value);
172     }
173 
174     /**
175      * @dev Removes a value from a set. O(1).
176      *
177      * Returns true if the value was removed from the set, that is if it was
178      * present.
179      */
180     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
181         return _remove(set._inner, value);
182     }
183 
184     /**
185      * @dev Returns true if the value is in the set. O(1).
186      */
187     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
188         return _contains(set._inner, value);
189     }
190 
191     /**
192      * @dev Returns the number of values in the set. O(1).
193      */
194     function length(Bytes32Set storage set) internal view returns (uint256) {
195         return _length(set._inner);
196     }
197 
198     /**
199      * @dev Returns the value stored at position `index` in the set. O(1).
200      *
201      * Note that there are no guarantees on the ordering of values inside the
202      * array, and it may change when more values are added or removed.
203      *
204      * Requirements:
205      *
206      * - `index` must be strictly less than {length}.
207      */
208     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
209         return _at(set._inner, index);
210     }
211 
212     /**
213      * @dev Return the entire set in an array
214      *
215      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
216      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
217      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
218      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
219      */
220     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
221         return _values(set._inner);
222     }
223 
224     // AddressSet
225 
226     struct AddressSet {
227         Set _inner;
228     }
229 
230     /**
231      * @dev Add a value to a set. O(1).
232      *
233      * Returns true if the value was added to the set, that is if it was not
234      * already present.
235      */
236     function add(AddressSet storage set, address value) internal returns (bool) {
237         return _add(set._inner, bytes32(uint256(uint160(value))));
238     }
239 
240     /**
241      * @dev Removes a value from a set. O(1).
242      *
243      * Returns true if the value was removed from the set, that is if it was
244      * present.
245      */
246     function remove(AddressSet storage set, address value) internal returns (bool) {
247         return _remove(set._inner, bytes32(uint256(uint160(value))));
248     }
249 
250     /**
251      * @dev Returns true if the value is in the set. O(1).
252      */
253     function contains(AddressSet storage set, address value) internal view returns (bool) {
254         return _contains(set._inner, bytes32(uint256(uint160(value))));
255     }
256 
257     /**
258      * @dev Returns the number of values in the set. O(1).
259      */
260     function length(AddressSet storage set) internal view returns (uint256) {
261         return _length(set._inner);
262     }
263 
264     /**
265      * @dev Returns the value stored at position `index` in the set. O(1).
266      *
267      * Note that there are no guarantees on the ordering of values inside the
268      * array, and it may change when more values are added or removed.
269      *
270      * Requirements:
271      *
272      * - `index` must be strictly less than {length}.
273      */
274     function at(AddressSet storage set, uint256 index) internal view returns (address) {
275         return address(uint160(uint256(_at(set._inner, index))));
276     }
277 
278     /**
279      * @dev Return the entire set in an array
280      *
281      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
282      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
283      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
284      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
285      */
286     function values(AddressSet storage set) internal view returns (address[] memory) {
287         bytes32[] memory store = _values(set._inner);
288         address[] memory result;
289 
290         /// @solidity memory-safe-assembly
291         assembly {
292             result := store
293         }
294 
295         return result;
296     }
297 
298     // UintSet
299 
300     struct UintSet {
301         Set _inner;
302     }
303 
304     /**
305      * @dev Add a value to a set. O(1).
306      *
307      * Returns true if the value was added to the set, that is if it was not
308      * already present.
309      */
310     function add(UintSet storage set, uint256 value) internal returns (bool) {
311         return _add(set._inner, bytes32(value));
312     }
313 
314     /**
315      * @dev Removes a value from a set. O(1).
316      *
317      * Returns true if the value was removed from the set, that is if it was
318      * present.
319      */
320     function remove(UintSet storage set, uint256 value) internal returns (bool) {
321         return _remove(set._inner, bytes32(value));
322     }
323 
324     /**
325      * @dev Returns true if the value is in the set. O(1).
326      */
327     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
328         return _contains(set._inner, bytes32(value));
329     }
330 
331     /**
332      * @dev Returns the number of values on the set. O(1).
333      */
334     function length(UintSet storage set) internal view returns (uint256) {
335         return _length(set._inner);
336     }
337 
338     /**
339      * @dev Returns the value stored at position `index` in the set. O(1).
340      *
341      * Note that there are no guarantees on the ordering of values inside the
342      * array, and it may change when more values are added or removed.
343      *
344      * Requirements:
345      *
346      * - `index` must be strictly less than {length}.
347      */
348     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
349         return uint256(_at(set._inner, index));
350     }
351 
352     /**
353      * @dev Return the entire set in an array
354      *
355      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
356      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
357      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
358      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
359      */
360     function values(UintSet storage set) internal view returns (uint256[] memory) {
361         bytes32[] memory store = _values(set._inner);
362         uint256[] memory result;
363 
364         /// @solidity memory-safe-assembly
365         assembly {
366             result := store
367         }
368 
369         return result;
370     }
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
374 
375 
376 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @title ERC721 token receiver interface
382  * @dev Interface for any contract that wants to support safeTransfers
383  * from ERC721 asset contracts.
384  */
385 interface IERC721Receiver {
386     /**
387      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
388      * by `operator` from `from`, this function is called.
389      *
390      * It must return its Solidity selector to confirm the token transfer.
391      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
392      *
393      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
394      */
395     function onERC721Received(
396         address operator,
397         address from,
398         uint256 tokenId,
399         bytes calldata data
400     ) external returns (bytes4);
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
404 
405 
406 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
407 
408 pragma solidity ^0.8.0;
409 
410 
411 /**
412  * @dev Implementation of the {IERC721Receiver} interface.
413  *
414  * Accepts all token transfers.
415  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
416  */
417 contract ERC721Holder is IERC721Receiver {
418     /**
419      * @dev See {IERC721Receiver-onERC721Received}.
420      *
421      * Always returns `IERC721Receiver.onERC721Received.selector`.
422      */
423     function onERC721Received(
424         address,
425         address,
426         uint256,
427         bytes memory
428     ) public virtual override returns (bytes4) {
429         return this.onERC721Received.selector;
430     }
431 }
432 
433 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     /**
451      * @dev Returns true if this contract implements the interface defined by
452      * `interfaceId`. See the corresponding
453      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
454      * to learn more about how these ids are created.
455      *
456      * This function call must use less than 30 000 gas.
457      */
458     function supportsInterface(bytes4 interfaceId) external view returns (bool);
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev Required interface of an ERC721 compliant contract.
471  */
472 interface IERC721 is IERC165 {
473     /**
474      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
480      */
481     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
485      */
486     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
487 
488     /**
489      * @dev Returns the number of tokens in ``owner``'s account.
490      */
491     function balanceOf(address owner) external view returns (uint256 balance);
492 
493     /**
494      * @dev Returns the owner of the `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function ownerOf(uint256 tokenId) external view returns (address owner);
501 
502     /**
503      * @dev Safely transfers `tokenId` token from `from` to `to`.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId,
519         bytes calldata data
520     ) external;
521 
522     /**
523      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
524      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must exist and be owned by `from`.
531      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
533      *
534      * Emits a {Transfer} event.
535      */
536     function safeTransferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Transfers `tokenId` token from `from` to `to`.
544      *
545      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      *
554      * Emits a {Transfer} event.
555      */
556     function transferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
564      * The approval is cleared when the token is transferred.
565      *
566      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
567      *
568      * Requirements:
569      *
570      * - The caller must own the token or be an approved operator.
571      * - `tokenId` must exist.
572      *
573      * Emits an {Approval} event.
574      */
575     function approve(address to, uint256 tokenId) external;
576 
577     /**
578      * @dev Approve or remove `operator` as an operator for the caller.
579      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
580      *
581      * Requirements:
582      *
583      * - The `operator` cannot be the caller.
584      *
585      * Emits an {ApprovalForAll} event.
586      */
587     function setApprovalForAll(address operator, bool _approved) external;
588 
589     /**
590      * @dev Returns the account approved for `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function getApproved(uint256 tokenId) external view returns (address operator);
597 
598     /**
599      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
600      *
601      * See {setApprovalForAll}
602      */
603     function isApprovedForAll(address owner, address operator) external view returns (bool);
604 }
605 
606 // File: @openzeppelin/contracts/utils/Context.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Provides information about the current execution context, including the
615  * sender of the transaction and its data. While these are generally available
616  * via msg.sender and msg.data, they should not be accessed in such a direct
617  * manner, since when dealing with meta-transactions the account sending and
618  * paying for execution may not be the actual sender (as far as an application
619  * is concerned).
620  *
621  * This contract is only required for intermediate, library-like contracts.
622  */
623 abstract contract Context {
624     function _msgSender() internal view virtual returns (address) {
625         return msg.sender;
626     }
627 
628     function _msgData() internal view virtual returns (bytes calldata) {
629         return msg.data;
630     }
631 }
632 
633 // File: @openzeppelin/contracts/access/Ownable.sol
634 
635 
636 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Contract module which provides a basic access control mechanism, where
643  * there is an account (an owner) that can be granted exclusive access to
644  * specific functions.
645  *
646  * By default, the owner account will be the one that deploys the contract. This
647  * can later be changed with {transferOwnership}.
648  *
649  * This module is used through inheritance. It will make available the modifier
650  * `onlyOwner`, which can be applied to your functions to restrict their use to
651  * the owner.
652  */
653 abstract contract Ownable is Context {
654     address private _owner;
655 
656     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
657 
658     /**
659      * @dev Initializes the contract setting the deployer as the initial owner.
660      */
661     constructor() {
662         _transferOwnership(_msgSender());
663     }
664 
665     /**
666      * @dev Throws if called by any account other than the owner.
667      */
668     modifier onlyOwner() {
669         _checkOwner();
670         _;
671     }
672 
673     /**
674      * @dev Returns the address of the current owner.
675      */
676     function owner() public view virtual returns (address) {
677         return _owner;
678     }
679 
680     /**
681      * @dev Throws if the sender is not the owner.
682      */
683     function _checkOwner() internal view virtual {
684         require(owner() == _msgSender(), "Ownable: caller is not the owner");
685     }
686 
687     /**
688      * @dev Leaves the contract without owner. It will not be possible to call
689      * `onlyOwner` functions anymore. Can only be called by the current owner.
690      *
691      * NOTE: Renouncing ownership will leave the contract without an owner,
692      * thereby removing any functionality that is only available to the owner.
693      */
694     function renounceOwnership() public virtual onlyOwner {
695         _transferOwnership(address(0));
696     }
697 
698     /**
699      * @dev Transfers ownership of the contract to a new account (`newOwner`).
700      * Can only be called by the current owner.
701      */
702     function transferOwnership(address newOwner) public virtual onlyOwner {
703         require(newOwner != address(0), "Ownable: new owner is the zero address");
704         _transferOwnership(newOwner);
705     }
706 
707     /**
708      * @dev Transfers ownership of the contract to a new account (`newOwner`).
709      * Internal function without access restriction.
710      */
711     function _transferOwnership(address newOwner) internal virtual {
712         address oldOwner = _owner;
713         _owner = newOwner;
714         emit OwnershipTransferred(oldOwner, newOwner);
715     }
716 }
717 
718 // File: contracts/Staking.sol
719 
720 
721 
722 pragma solidity ^0.8.11;
723 
724 
725 
726 
727 
728 contract Staking is ERC721Holder, Ownable {
729 
730     using EnumerableSet for EnumerableSet.UintSet;
731 
732     struct Staker {
733         EnumerableSet.UintSet tokenIds; // set of token ids
734         uint256 amount;
735     }
736 
737     struct StakedNft {
738         uint256 stakedTime;
739         uint256 lockedTime;
740     }
741 
742     struct Collection {
743         IERC721 NFT;
744         uint256 lockTime;
745         mapping(address => Staker) Stakers;
746         mapping(uint256 => StakedNft) StakedNfts;
747         mapping(uint256 => address) StakerAddresses;
748     }
749 
750     Collection[] nftPools;
751 
752     constructor() {
753     }
754 
755     event Stake(address indexed owner, uint256 id, uint256 time);
756     event Unstake(address indexed owner, uint256 id, uint256 time);
757 
758     function stakeNFT(uint256 _tokenId, uint256 _poolId) public {
759         Collection storage pool = nftPools[_poolId];
760         require(pool.NFT.balanceOf(msg.sender) >= 1, "you dont have enough nfts");
761         require(
762             pool.NFT.ownerOf(_tokenId) == msg.sender,
763             "you don't own this nft!"
764         );
765         pool.Stakers[msg.sender].amount += 1;
766         pool.Stakers[msg.sender].tokenIds.add(_tokenId);
767         pool.StakedNfts[_tokenId].lockedTime = block.timestamp + pool.lockTime;
768         pool.StakedNfts[_tokenId].stakedTime = block.timestamp;
769         pool.StakerAddresses[_tokenId] = msg.sender;
770         pool.NFT.transferFrom(msg.sender, address(this), _tokenId);
771         emit Stake (msg.sender, _tokenId, block.timestamp);
772     }
773 
774     function batchStakeNFT(uint256[] memory _tokenIds, uint256 _poolId) public {
775         Collection storage pool = nftPools[_poolId];
776         require(pool.NFT.balanceOf(msg.sender) >= 1, "you dont have enough nfts");
777         
778         for (uint i = 0; i < _tokenIds.length; i++) {
779             require(
780                 pool.NFT.ownerOf(_tokenIds[i]) == msg.sender,
781                 "you don't own this nft!"
782             );
783             pool.Stakers[msg.sender].amount += 1;
784             pool.Stakers[msg.sender].tokenIds.add(_tokenIds[i]);
785             pool.StakedNfts[_tokenIds[i]].lockedTime = block.timestamp + pool.lockTime;
786             pool.StakedNfts[_tokenIds[i]].stakedTime = block.timestamp;
787             pool.StakerAddresses[_tokenIds[i]] = msg.sender;
788             pool.NFT.transferFrom(msg.sender, address(this), _tokenIds[i]);
789             emit Stake (msg.sender, _tokenIds[i], block.timestamp);
790         }
791     }
792 
793     function unstakeNFT(uint256 _tokenId, uint256 _poolId) public {
794         Collection storage pool = nftPools[_poolId];
795         require(block.timestamp >= pool.StakedNfts[_tokenId].lockedTime, "your nft is locked for withdrawal");
796         require(
797             pool.Stakers[msg.sender].amount > 0,
798             "you have no nfts staked"
799         );
800         require(pool.StakerAddresses[_tokenId] == msg.sender, "you don't own this token!");
801         pool.Stakers[msg.sender].amount -= 1;
802         pool.StakerAddresses[_tokenId] = address(0);
803 
804         Staker storage u = pool.Stakers[msg.sender];
805         u.tokenIds.remove(_tokenId);
806 
807         pool.NFT.transferFrom(address(this), msg.sender, _tokenId);
808 
809         emit Unstake(msg.sender, _tokenId, block.timestamp);
810     }
811 
812     function batchUnstakeNFT(uint256[] memory _tokenIds, uint256 _poolId) public {
813         Collection storage pool = nftPools[_poolId];
814         require(
815             pool.Stakers[msg.sender].amount > 0,
816             "you have no nfts staked"
817         );
818 
819         for (uint i = 0; i < _tokenIds.length; i++) {
820             if(pool.StakerAddresses[_tokenIds[i]] == msg.sender && block.timestamp >= pool.StakedNfts[_tokenIds[i]].lockedTime) {
821                 pool.Stakers[msg.sender].amount -= 1;
822                 pool.StakerAddresses[_tokenIds[i]] = address(0);
823 
824                 Staker storage u = pool.Stakers[msg.sender];
825                 u.tokenIds.remove(_tokenIds[i]);
826 
827                 pool.NFT.transferFrom(address(this), msg.sender, _tokenIds[i]);
828 
829                 emit Unstake(msg.sender, _tokenIds[i], block.timestamp);
830             }
831         }
832     }
833 
834     function addPool(address _nftAddress, uint256 _lockTime) external onlyOwner {
835         Collection storage newCollection = nftPools.push();
836         newCollection.NFT = IERC721(_nftAddress);
837         newCollection.lockTime = _lockTime;
838     }
839 
840     function poolInfo(uint256 _poolId) external view returns(IERC721, uint256) {
841         Collection storage pool = nftPools[_poolId];
842         
843         return (pool.NFT, pool.lockTime);
844     }
845 
846     function updatePoolLocktime(uint256 _poolId, uint256 _lockTime) external onlyOwner {
847         Collection storage pool = nftPools[_poolId];
848         pool.lockTime = _lockTime;
849     }
850 
851     function stakedNftInfo(uint256 _tokenId, uint256 _poolId) external view returns(uint256, uint256) {
852         Collection storage pool = nftPools[_poolId];
853         StakedNft memory stakeInfo = pool.StakedNfts[_tokenId];
854         
855         return (stakeInfo.lockedTime, stakeInfo.stakedTime);
856     }
857 
858     function stakedNfts(address _owner, uint256 _poolId) external view returns(uint256[] memory) {
859         Collection storage pool = nftPools[_poolId];
860         uint256[] memory tempArr = new uint256[](pool.Stakers[_owner].tokenIds.length());
861         for(uint i = 0; i < pool.Stakers[_owner].tokenIds.length(); i++) {
862             tempArr[i] = pool.Stakers[_owner].tokenIds.at(i);
863         }
864         return tempArr;
865     }
866 
867 }