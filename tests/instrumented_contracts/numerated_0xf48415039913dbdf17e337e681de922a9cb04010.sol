1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
3 
4 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
5 
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
101 
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
105 
106 
107 
108 /**
109  * @dev Interface of the ERC165 standard, as defined in the
110  * https://eips.ethereum.org/EIPS/eip-165[EIP].
111  *
112  * Implementers can declare support of contract interfaces, which can then be
113  * queried by others ({ERC165Checker}).
114  *
115  * For an implementation, see {ERC165}.
116  */
117 interface IERC165 {
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 }
128 
129 /**
130  * @dev Required interface of an ERC721 compliant contract.
131  */
132 interface IERC721 is IERC165 {
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external;
181 
182     /**
183      * @dev Transfers `tokenId` token from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must be owned by `from`.
192      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
204      * The approval is cleared when the token is transferred.
205      *
206      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
207      *
208      * Requirements:
209      *
210      * - The caller must own the token or be an approved operator.
211      * - `tokenId` must exist.
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Returns the account approved for `tokenId` token.
219      *
220      * Requirements:
221      *
222      * - `tokenId` must exist.
223      */
224     function getApproved(uint256 tokenId) external view returns (address operator);
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
240      *
241      * See {setApprovalForAll}
242      */
243     function isApprovedForAll(address owner, address operator) external view returns (bool);
244 
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must exist and be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
255      *
256      * Emits a {Transfer} event.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId,
262         bytes calldata data
263     ) external;
264 }// OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
265 
266 
267 
268 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
269 
270 
271 
272 /**
273  * @title ERC721 token receiver interface
274  * @dev Interface for any contract that wants to support safeTransfers
275  * from ERC721 asset contracts.
276  */
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
286      */
287     function onERC721Received(
288         address operator,
289         address from,
290         uint256 tokenId,
291         bytes calldata data
292     ) external returns (bytes4);
293 }
294 
295 /**
296  * @dev Implementation of the {IERC721Receiver} interface.
297  *
298  * Accepts all token transfers.
299  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
300  */
301 contract ERC721Holder is IERC721Receiver {
302     /**
303      * @dev See {IERC721Receiver-onERC721Received}.
304      *
305      * Always returns `IERC721Receiver.onERC721Received.selector`.
306      */
307     function onERC721Received(
308         address,
309         address,
310         uint256,
311         bytes memory
312     ) public virtual override returns (bytes4) {
313         return this.onERC721Received.selector;
314     }
315 }// OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
316 
317 
318 
319 /**
320  * @dev Library for managing
321  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
322  * types.
323  *
324  * Sets have the following properties:
325  *
326  * - Elements are added, removed, and checked for existence in constant time
327  * (O(1)).
328  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
329  *
330  * ```
331  * contract Example {
332  *     // Add the library methods
333  *     using EnumerableSet for EnumerableSet.AddressSet;
334  *
335  *     // Declare a set state variable
336  *     EnumerableSet.AddressSet private mySet;
337  * }
338  * ```
339  *
340  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
341  * and `uint256` (`UintSet`) are supported.
342  */
343 library EnumerableSet {
344     // To implement this library for multiple types with as little code
345     // repetition as possible, we write it in terms of a generic Set type with
346     // bytes32 values.
347     // The Set implementation uses private functions, and user-facing
348     // implementations (such as AddressSet) are just wrappers around the
349     // underlying Set.
350     // This means that we can only create new EnumerableSets for types that fit
351     // in bytes32.
352 
353     struct Set {
354         // Storage of set values
355         bytes32[] _values;
356         // Position of the value in the `values` array, plus 1 because index 0
357         // means a value is not in the set.
358         mapping(bytes32 => uint256) _indexes;
359     }
360 
361     /**
362      * @dev Add a value to a set. O(1).
363      *
364      * Returns true if the value was added to the set, that is if it was not
365      * already present.
366      */
367     function _add(Set storage set, bytes32 value) private returns (bool) {
368         if (!_contains(set, value)) {
369             set._values.push(value);
370             // The value is stored at length-1, but we add 1 to all indexes
371             // and use 0 as a sentinel value
372             set._indexes[value] = set._values.length;
373             return true;
374         } else {
375             return false;
376         }
377     }
378 
379     /**
380      * @dev Removes a value from a set. O(1).
381      *
382      * Returns true if the value was removed from the set, that is if it was
383      * present.
384      */
385     function _remove(Set storage set, bytes32 value) private returns (bool) {
386         // We read and store the value's index to prevent multiple reads from the same storage slot
387         uint256 valueIndex = set._indexes[value];
388 
389         if (valueIndex != 0) {
390             // Equivalent to contains(set, value)
391             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
392             // the array, and then remove the last element (sometimes called as 'swap and pop').
393             // This modifies the order of the array, as noted in {at}.
394 
395             uint256 toDeleteIndex = valueIndex - 1;
396             uint256 lastIndex = set._values.length - 1;
397 
398             if (lastIndex != toDeleteIndex) {
399                 bytes32 lastValue = set._values[lastIndex];
400 
401                 // Move the last value to the index where the value to delete is
402                 set._values[toDeleteIndex] = lastValue;
403                 // Update the index for the moved value
404                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
405             }
406 
407             // Delete the slot where the moved value was stored
408             set._values.pop();
409 
410             // Delete the index for the deleted slot
411             delete set._indexes[value];
412 
413             return true;
414         } else {
415             return false;
416         }
417     }
418 
419     /**
420      * @dev Returns true if the value is in the set. O(1).
421      */
422     function _contains(Set storage set, bytes32 value) private view returns (bool) {
423         return set._indexes[value] != 0;
424     }
425 
426     /**
427      * @dev Returns the number of values on the set. O(1).
428      */
429     function _length(Set storage set) private view returns (uint256) {
430         return set._values.length;
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
443     function _at(Set storage set, uint256 index) private view returns (bytes32) {
444         return set._values[index];
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
455     function _values(Set storage set) private view returns (bytes32[] memory) {
456         return set._values;
457     }
458 
459     // Bytes32Set
460 
461     struct Bytes32Set {
462         Set _inner;
463     }
464 
465     /**
466      * @dev Add a value to a set. O(1).
467      *
468      * Returns true if the value was added to the set, that is if it was not
469      * already present.
470      */
471     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
472         return _add(set._inner, value);
473     }
474 
475     /**
476      * @dev Removes a value from a set. O(1).
477      *
478      * Returns true if the value was removed from the set, that is if it was
479      * present.
480      */
481     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
482         return _remove(set._inner, value);
483     }
484 
485     /**
486      * @dev Returns true if the value is in the set. O(1).
487      */
488     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
489         return _contains(set._inner, value);
490     }
491 
492     /**
493      * @dev Returns the number of values in the set. O(1).
494      */
495     function length(Bytes32Set storage set) internal view returns (uint256) {
496         return _length(set._inner);
497     }
498 
499     /**
500      * @dev Returns the value stored at position `index` in the set. O(1).
501      *
502      * Note that there are no guarantees on the ordering of values inside the
503      * array, and it may change when more values are added or removed.
504      *
505      * Requirements:
506      *
507      * - `index` must be strictly less than {length}.
508      */
509     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
510         return _at(set._inner, index);
511     }
512 
513     /**
514      * @dev Return the entire set in an array
515      *
516      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
517      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
518      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
519      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
520      */
521     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
522         return _values(set._inner);
523     }
524 
525     // AddressSet
526 
527     struct AddressSet {
528         Set _inner;
529     }
530 
531     /**
532      * @dev Add a value to a set. O(1).
533      *
534      * Returns true if the value was added to the set, that is if it was not
535      * already present.
536      */
537     function add(AddressSet storage set, address value) internal returns (bool) {
538         return _add(set._inner, bytes32(uint256(uint160(value))));
539     }
540 
541     /**
542      * @dev Removes a value from a set. O(1).
543      *
544      * Returns true if the value was removed from the set, that is if it was
545      * present.
546      */
547     function remove(AddressSet storage set, address value) internal returns (bool) {
548         return _remove(set._inner, bytes32(uint256(uint160(value))));
549     }
550 
551     /**
552      * @dev Returns true if the value is in the set. O(1).
553      */
554     function contains(AddressSet storage set, address value) internal view returns (bool) {
555         return _contains(set._inner, bytes32(uint256(uint160(value))));
556     }
557 
558     /**
559      * @dev Returns the number of values in the set. O(1).
560      */
561     function length(AddressSet storage set) internal view returns (uint256) {
562         return _length(set._inner);
563     }
564 
565     /**
566      * @dev Returns the value stored at position `index` in the set. O(1).
567      *
568      * Note that there are no guarantees on the ordering of values inside the
569      * array, and it may change when more values are added or removed.
570      *
571      * Requirements:
572      *
573      * - `index` must be strictly less than {length}.
574      */
575     function at(AddressSet storage set, uint256 index) internal view returns (address) {
576         return address(uint160(uint256(_at(set._inner, index))));
577     }
578 
579     /**
580      * @dev Return the entire set in an array
581      *
582      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
583      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
584      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
585      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
586      */
587     function values(AddressSet storage set) internal view returns (address[] memory) {
588         bytes32[] memory store = _values(set._inner);
589         address[] memory result;
590 
591         assembly {
592             result := store
593         }
594 
595         return result;
596     }
597 
598     // UintSet
599 
600     struct UintSet {
601         Set _inner;
602     }
603 
604     /**
605      * @dev Add a value to a set. O(1).
606      *
607      * Returns true if the value was added to the set, that is if it was not
608      * already present.
609      */
610     function add(UintSet storage set, uint256 value) internal returns (bool) {
611         return _add(set._inner, bytes32(value));
612     }
613 
614     /**
615      * @dev Removes a value from a set. O(1).
616      *
617      * Returns true if the value was removed from the set, that is if it was
618      * present.
619      */
620     function remove(UintSet storage set, uint256 value) internal returns (bool) {
621         return _remove(set._inner, bytes32(value));
622     }
623 
624     /**
625      * @dev Returns true if the value is in the set. O(1).
626      */
627     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
628         return _contains(set._inner, bytes32(value));
629     }
630 
631     /**
632      * @dev Returns the number of values on the set. O(1).
633      */
634     function length(UintSet storage set) internal view returns (uint256) {
635         return _length(set._inner);
636     }
637 
638     /**
639      * @dev Returns the value stored at position `index` in the set. O(1).
640      *
641      * Note that there are no guarantees on the ordering of values inside the
642      * array, and it may change when more values are added or removed.
643      *
644      * Requirements:
645      *
646      * - `index` must be strictly less than {length}.
647      */
648     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
649         return uint256(_at(set._inner, index));
650     }
651 
652     /**
653      * @dev Return the entire set in an array
654      *
655      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
656      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
657      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
658      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
659      */
660     function values(UintSet storage set) internal view returns (uint256[] memory) {
661         bytes32[] memory store = _values(set._inner);
662         uint256[] memory result;
663 
664         assembly {
665             result := store
666         }
667 
668         return result;
669     }
670 }
671 interface IGum {
672     function mint(address, uint256) external;
673 
674     function decimals() external returns (uint8);
675 }
676 
677 error NotStarted();
678 error TokenNotDeposited();
679 error UnknownBGContract();
680 
681 /**
682  * @notice Accept deposits of Bubblegum Kid and Bubblegum Puppy NFTs
683  * ("staking") in exchange for GUM token rewards. Thanks to the Sappy Seals team,
684  * this contract is largely based on their work
685  * @dev Contract defines a "day" as 7200 ethereum blocks.
686  */
687 contract Staking is ERC721Holder, Ownable {
688     using EnumerableSet for EnumerableSet.UintSet;
689 
690     address public constant BGK = 0xa5ae87B40076745895BB7387011ca8DE5fde37E0;
691     address public constant BGP = 0x86e9C5ad3D4b5519DA2D2C19F5c71bAa5Ef40933;
692     enum BGContract {
693         BGK,
694         BGP
695     }
696 
697     uint256 public constant GUM_TOKEN_DECIMALS = 18;
698 
699     address public gumToken;
700 
701     bool public started;
702 
703     mapping(address => mapping(BGContract => EnumerableSet.UintSet))
704         private _deposits;
705     mapping(BGContract => mapping(uint256 => uint256)) public depositBlocks;
706     uint256 public stakeRewardRate;
707 
708     event GumTokenUpdated(address _gumToken);
709     event Started();
710     event Stopped();
711     event Deposited(address from, uint256[] tokenIds, uint8[] bgContracts);
712     event Withdrawn(address to, uint256[] tokenIds, uint8[] bgContracts);
713     event StakeRewardRateUpdated(uint256 _stakeRewardRate);
714     event RewardClaimed(address to, uint256 amount);
715 
716     constructor(address _gumToken) {
717         gumToken = _gumToken;
718         stakeRewardRate = 1;
719         started = false;
720     }
721 
722     modifier onlyStarted() {
723         if (!started) revert NotStarted();
724         _;
725     }
726 
727     function start() public onlyOwner {
728         started = true;
729         emit Started();
730     }
731 
732     function stop() public onlyOwner {
733         started = false;
734         emit Stopped();
735     }
736 
737     function unsafe_inc(uint256 x) private pure returns (uint256) {
738         unchecked {
739             return x + 1;
740         }
741     }
742 
743     /**
744      * @dev Change the address of the reward token contract (must
745      * support ERC20 functions named in IGum interface and conform
746      * to hardcoded GUM_TOKEN_DECIMALS constant).
747      */
748     function updateGumToken(address _gumToken) public onlyOwner {
749         gumToken = _gumToken;
750         emit GumTokenUpdated(_gumToken);
751     }
752 
753     function updateStakeRewardRate(uint256 _stakeRewardRate) public onlyOwner {
754         stakeRewardRate = _stakeRewardRate;
755         emit StakeRewardRateUpdated(_stakeRewardRate);
756     }
757 
758     /**
759      * @dev Mint GUM token rewards
760      * @param to The recipient's ethereum address
761      * @param amount The amount to mint
762      */
763     function _reward(address to, uint256 amount) internal {
764         IGum(gumToken).mint(to, amount);
765     }
766 
767     /**
768      * @dev Calculate accrued GUM token rewards for a given
769      * BGK or BGP NFT
770      * @param account The user's ethereum address
771      * @param tokenId The NFT's id
772      * @param _bgContract Kids (0) or Puppies (1)
773      * @return rewards
774      */
775     function getRewardsForToken(
776         address account,
777         uint256 tokenId,
778         uint8 _bgContract
779     ) internal view returns (uint256) {
780         BGContract bgContract = BGContract(_bgContract);
781         // the user has not staked this nft
782         if (!_deposits[account][bgContract].contains(tokenId)) {
783             return 0;
784         }
785         // when was the NFT deposited?
786         uint256 depositBlock = depositBlocks[bgContract][tokenId];
787         // how many days have elapsed since the NFT was deposited or
788         // rewards were claimed?
789         uint256 depositDaysElapsed = (block.number - depositBlock) / 7200;
790         return stakeRewardRate * depositDaysElapsed * 10**GUM_TOKEN_DECIMALS;
791     }
792 
793     /**
794      * @dev Calculate accrued GUM token rewards for a set
795      * of BGK and BGP NFTs
796      * @param account The user's ethereum address
797      * @param tokenIds The NFTs' ids
798      * @param bgContracts The NFTs' contracts -- Kids (0)
799      * or Puppies (1) -- with indices corresponding to those
800      * of `tokenIds`
801      * @return rewards
802      */
803     function calculateRewards(
804         address account,
805         uint256[] calldata tokenIds,
806         uint8[] calldata bgContracts
807     ) public view returns (uint256[] memory rewards) {
808         rewards = new uint256[](tokenIds.length);
809         for (uint256 i; i < tokenIds.length; i = unsafe_inc(i)) {
810             rewards[i] = getRewardsForToken(
811                 account,
812                 tokenIds[i],
813                 bgContracts[i]
814             );
815         }
816     }
817 
818     /**
819      * @dev Claim accrued GUM token rewards for all
820      * staked BGK and BGP NFTs -- if caller's rewards are
821      * greater than 0, balance will be transferred to
822      * caller's address
823      */
824     function claimRewards() public {
825         address account = msg.sender;
826         uint256 amount;
827         for (uint8 i; i < 2; i++) {
828             BGContract bgContract = BGContract(i);
829             for (
830                 uint256 j;
831                 j < _deposits[account][bgContract].length();
832                 j = unsafe_inc(j)
833             ) {
834                 uint256 tokenId = _deposits[account][bgContract].at(j);
835                 uint256 thisAmount = (getRewardsForToken(account, tokenId, i));
836                 if (thisAmount > 0) {
837                     amount += thisAmount;
838                     depositBlocks[bgContract][tokenId] = block.number;
839                 }
840             }
841         }
842         if (amount > 0) {
843             _reward(account, amount);
844             emit RewardClaimed(account, amount);
845         }
846     }
847 
848     /**
849      * @dev Deposit ("stake") a set of BGK and BGP NFTs. Caller
850      * must be the owner of the NFTs supplied as arguments.
851      * @param tokenIds The NFTs' ids
852      * @param bgContracts The NFTs' contracts -- Kids (0)
853      * or Puppies (1) -- with indices corresponding to those
854      * of `tokenIds`
855      */
856     function deposit(uint256[] calldata tokenIds, uint8[] calldata bgContracts)
857         external
858         onlyStarted
859     {
860         address account = msg.sender;
861         for (uint256 i; i < tokenIds.length; i = unsafe_inc(i)) {
862             uint256 tokenId = tokenIds[i];
863             BGContract bgContract = BGContract(bgContracts[i]);
864             address bgContractAddress;
865             if (bgContract == BGContract.BGK) {
866                 bgContractAddress = BGK;
867             } else if (bgContract == BGContract.BGP) {
868                 bgContractAddress = BGP;
869             } else {
870                 revert UnknownBGContract();
871             }
872             IERC721(bgContractAddress).safeTransferFrom(
873                 account,
874                 address(this),
875                 tokenId,
876                 ""
877             );
878             _deposits[account][bgContract].add(tokenId);
879             depositBlocks[bgContract][tokenId] = block.number;
880         }
881         emit Deposited(account, tokenIds, bgContracts);
882     }
883 
884     /**
885      * @dev Withdraw ("unstake") a set of deposited BGK and BGP
886      * NFTs. Calling `withdraw` automatically claims accrued
887      * rewards on the NFTs supplied as arguments. Caller must
888      * have deposited the NFTs.
889      * @param tokenIds The NFTs' ids
890      * @param bgContracts The NFTs' contracts -- Kids (0)
891      * or Puppies (1) -- with indices corresponding to those
892      * of `tokenIds`
893      */
894     function withdraw(uint256[] calldata tokenIds, uint8[] calldata bgContracts)
895         external
896     {
897         claimRewards();
898         address account = msg.sender;
899         for (uint256 i; i < tokenIds.length; i = unsafe_inc(i)) {
900             uint256 tokenId = tokenIds[i];
901             BGContract bgContract = BGContract(bgContracts[i]);
902             if (!_deposits[account][bgContract].contains(tokenId)) {
903                 revert TokenNotDeposited();
904             }
905             _deposits[account][bgContract].remove(tokenId);
906             address nftAddress;
907             if (bgContract == BGContract.BGK) {
908                 nftAddress = BGK;
909             } else if (bgContract == BGContract.BGP) {
910                 nftAddress = BGP;
911             } else {
912                 revert UnknownBGContract();
913             }
914             IERC721(nftAddress).safeTransferFrom(
915                 address(this),
916                 account,
917                 tokenId,
918                 ""
919             );
920         }
921         emit Withdrawn(account, tokenIds, bgContracts);
922     }
923 
924     /**
925      * @dev Get the ids of Kid and Puppy NFTs staked by the
926      * user supplied in the `account` argument
927      * @param account The depositor's ethereum address
928      * @return bgContracts The ids of the deposited NFTs,
929      * as an array: the first item is an array of Kid ids,
930      * the second an array of Pup ids
931      */
932     function depositsOf(address account)
933         external
934         view
935         returns (uint256[][2] memory)
936     {
937         EnumerableSet.UintSet storage bgkDepositSet = _deposits[account][
938             BGContract.BGK
939         ];
940         uint256[] memory bgkIds = new uint256[](bgkDepositSet.length());
941         for (uint256 i; i < bgkDepositSet.length(); i = unsafe_inc(i)) {
942             bgkIds[i] = bgkDepositSet.at(i);
943         }
944         EnumerableSet.UintSet storage bgpDepositSet = _deposits[account][
945             BGContract.BGP
946         ];
947         uint256[] memory bgpIds = new uint256[](bgpDepositSet.length());
948         for (uint256 i; i < bgpDepositSet.length(); i = unsafe_inc(i)) {
949             bgpIds[i] = bgpDepositSet.at(i);
950         }
951         return [bgkIds, bgpIds];
952     }
953 }