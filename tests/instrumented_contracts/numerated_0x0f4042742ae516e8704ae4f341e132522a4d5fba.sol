1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.19;
3 
4 
5 contract OperatorFilterer {
6     error OperatorNotAllowed(address operator);
7 
8     IOperatorFilterRegistry constant operatorFilterRegistry =
9         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
10 
11     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
12         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
13         // will not revert, but the contract will need to be registered with the registry once it is deployed in
14         // order for the modifier to filter addresses.
15         if (address(operatorFilterRegistry).code.length > 0) {
16             if (subscribe) {
17                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
18             } else {
19                 if (subscriptionOrRegistrantToCopy != address(0)) {
20                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
21                 } else {
22                     operatorFilterRegistry.register(address(this));
23                 }
24             }
25         }
26     }
27 
28     modifier onlyAllowedOperator() virtual {
29         // Check registry code length to facilitate testing in environments without a deployed registry.
30         if (address(operatorFilterRegistry).code.length > 0) {
31             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
32                 revert OperatorNotAllowed(msg.sender);
33             }
34         }
35         _;
36     }
37 }
38 
39 contract DefaultOperatorFilterer is OperatorFilterer {
40     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
41 
42     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
43 }
44 
45 library EnumerableSet {
46     // To implement this library for multiple types with as little code
47     // repetition as possible, we write it in terms of a generic Set type with
48     // bytes32 values.
49     // The Set implementation uses private functions, and user-facing
50     // implementations (such as AddressSet) are just wrappers around the
51     // underlying Set.
52     // This means that we can only create new EnumerableSets for types that fit
53     // in bytes32.
54 
55     struct Set {
56         // Storage of set values
57         bytes32[] _values;
58         // Position of the value in the `values` array, plus 1 because index 0
59         // means a value is not in the set.
60         mapping(bytes32 => uint256) _indexes;
61     }
62 
63     /**
64      * @dev Add a value to a set. O(1).
65      *
66      * Returns true if the value was added to the set, that is if it was not
67      * already present.
68      */
69     function _add(Set storage set, bytes32 value) private returns (bool) {
70         if (!_contains(set, value)) {
71             set._values.push(value);
72             // The value is stored at length-1, but we add 1 to all indexes
73             // and use 0 as a sentinel value
74             set._indexes[value] = set._values.length;
75             return true;
76         } else {
77             return false;
78         }
79     }
80 
81     /**
82      * @dev Removes a value from a set. O(1).
83      *
84      * Returns true if the value was removed from the set, that is if it was
85      * present.
86      */
87     function _remove(Set storage set, bytes32 value) private returns (bool) {
88         // We read and store the value's index to prevent multiple reads from the same storage slot
89         uint256 valueIndex = set._indexes[value];
90 
91         if (valueIndex != 0) {
92             // Equivalent to contains(set, value)
93             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
94             // the array, and then remove the last element (sometimes called as 'swap and pop').
95             // This modifies the order of the array, as noted in {at}.
96 
97             uint256 toDeleteIndex = valueIndex - 1;
98             uint256 lastIndex = set._values.length - 1;
99 
100             if (lastIndex != toDeleteIndex) {
101                 bytes32 lastValue = set._values[lastIndex];
102 
103                 // Move the last value to the index where the value to delete is
104                 set._values[toDeleteIndex] = lastValue;
105                 // Update the index for the moved value
106                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
107             }
108 
109             // Delete the slot where the moved value was stored
110             set._values.pop();
111 
112             // Delete the index for the deleted slot
113             delete set._indexes[value];
114 
115             return true;
116         } else {
117             return false;
118         }
119     }
120 
121     /**
122      * @dev Returns true if the value is in the set. O(1).
123      */
124     function _contains(Set storage set, bytes32 value) private view returns (bool) {
125         return set._indexes[value] != 0;
126     }
127 
128     /**
129      * @dev Returns the number of values on the set. O(1).
130      */
131     function _length(Set storage set) private view returns (uint256) {
132         return set._values.length;
133     }
134 
135     /**
136      * @dev Returns the value stored at position `index` in the set. O(1).
137      *
138      * Note that there are no guarantees on the ordering of values inside the
139      * array, and it may change when more values are added or removed.
140      *
141      * Requirements:
142      *
143      * - `index` must be strictly less than {length}.
144      */
145     function _at(Set storage set, uint256 index) private view returns (bytes32) {
146         return set._values[index];
147     }
148 
149     /**
150      * @dev Return the entire set in an array
151      *
152      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
153      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
154      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
155      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
156      */
157     function _values(Set storage set) private view returns (bytes32[] memory) {
158         return set._values;
159     }
160 
161     // Bytes32Set
162 
163     struct Bytes32Set {
164         Set _inner;
165     }
166 
167     /**
168      * @dev Add a value to a set. O(1).
169      *
170      * Returns true if the value was added to the set, that is if it was not
171      * already present.
172      */
173     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
174         return _add(set._inner, value);
175     }
176 
177     /**
178      * @dev Removes a value from a set. O(1).
179      *
180      * Returns true if the value was removed from the set, that is if it was
181      * present.
182      */
183     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
184         return _remove(set._inner, value);
185     }
186 
187     /**
188      * @dev Returns true if the value is in the set. O(1).
189      */
190     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
191         return _contains(set._inner, value);
192     }
193 
194     /**
195      * @dev Returns the number of values in the set. O(1).
196      */
197     function length(Bytes32Set storage set) internal view returns (uint256) {
198         return _length(set._inner);
199     }
200 
201     /**
202      * @dev Returns the value stored at position `index` in the set. O(1).
203      *
204      * Note that there are no guarantees on the ordering of values inside the
205      * array, and it may change when more values are added or removed.
206      *
207      * Requirements:
208      *
209      * - `index` must be strictly less than {length}.
210      */
211     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
212         return _at(set._inner, index);
213     }
214 
215     /**
216      * @dev Return the entire set in an array
217      *
218      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
219      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
220      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
221      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
222      */
223     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
224         bytes32[] memory store = _values(set._inner);
225         bytes32[] memory result;
226 
227         /// @solidity memory-safe-assembly
228         assembly {
229             result := store
230         }
231 
232         return result;
233     }
234 
235     // AddressSet
236 
237     struct AddressSet {
238         Set _inner;
239     }
240 
241     /**
242      * @dev Add a value to a set. O(1).
243      *
244      * Returns true if the value was added to the set, that is if it was not
245      * already present.
246      */
247     function add(AddressSet storage set, address value) internal returns (bool) {
248         return _add(set._inner, bytes32(uint256(uint160(value))));
249     }
250 
251     /**
252      * @dev Removes a value from a set. O(1).
253      *
254      * Returns true if the value was removed from the set, that is if it was
255      * present.
256      */
257     function remove(AddressSet storage set, address value) internal returns (bool) {
258         return _remove(set._inner, bytes32(uint256(uint160(value))));
259     }
260 
261     /**
262      * @dev Returns true if the value is in the set. O(1).
263      */
264     function contains(AddressSet storage set, address value) internal view returns (bool) {
265         return _contains(set._inner, bytes32(uint256(uint160(value))));
266     }
267 
268     /**
269      * @dev Returns the number of values in the set. O(1).
270      */
271     function length(AddressSet storage set) internal view returns (uint256) {
272         return _length(set._inner);
273     }
274 
275     /**
276      * @dev Returns the value stored at position `index` in the set. O(1).
277      *
278      * Note that there are no guarantees on the ordering of values inside the
279      * array, and it may change when more values are added or removed.
280      *
281      * Requirements:
282      *
283      * - `index` must be strictly less than {length}.
284      */
285     function at(AddressSet storage set, uint256 index) internal view returns (address) {
286         return address(uint160(uint256(_at(set._inner, index))));
287     }
288 
289     /**
290      * @dev Return the entire set in an array
291      *
292      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
293      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
294      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
295      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
296      */
297     function values(AddressSet storage set) internal view returns (address[] memory) {
298         bytes32[] memory store = _values(set._inner);
299         address[] memory result;
300 
301         /// @solidity memory-safe-assembly
302         assembly {
303             result := store
304         }
305 
306         return result;
307     }
308 
309     // UintSet
310 
311     struct UintSet {
312         Set _inner;
313     }
314 
315     /**
316      * @dev Add a value to a set. O(1).
317      *
318      * Returns true if the value was added to the set, that is if it was not
319      * already present.
320      */
321     function add(UintSet storage set, uint256 value) internal returns (bool) {
322         return _add(set._inner, bytes32(value));
323     }
324 
325     /**
326      * @dev Removes a value from a set. O(1).
327      *
328      * Returns true if the value was removed from the set, that is if it was
329      * present.
330      */
331     function remove(UintSet storage set, uint256 value) internal returns (bool) {
332         return _remove(set._inner, bytes32(value));
333     }
334 
335     /**
336      * @dev Returns true if the value is in the set. O(1).
337      */
338     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
339         return _contains(set._inner, bytes32(value));
340     }
341 
342     /**
343      * @dev Returns the number of values in the set. O(1).
344      */
345     function length(UintSet storage set) internal view returns (uint256) {
346         return _length(set._inner);
347     }
348 
349     /**
350      * @dev Returns the value stored at position `index` in the set. O(1).
351      *
352      * Note that there are no guarantees on the ordering of values inside the
353      * array, and it may change when more values are added or removed.
354      *
355      * Requirements:
356      *
357      * - `index` must be strictly less than {length}.
358      */
359     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
360         return uint256(_at(set._inner, index));
361     }
362 
363     /**
364      * @dev Return the entire set in an array
365      *
366      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
367      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
368      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
369      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
370      */
371     function values(UintSet storage set) internal view returns (uint256[] memory) {
372         bytes32[] memory store = _values(set._inner);
373         uint256[] memory result;
374 
375         /// @solidity memory-safe-assembly
376         assembly {
377             result := store
378         }
379 
380         return result;
381     }
382 }
383 
384 interface IOperatorFilterRegistry {
385     function isOperatorAllowed(address registrant, address operator) external returns (bool);
386     function register(address registrant) external;
387     function registerAndSubscribe(address registrant, address subscription) external;
388     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
389     function updateOperator(address registrant, address operator, bool filtered) external;
390     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
391     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
392     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
393     function subscribe(address registrant, address registrantToSubscribe) external;
394     function unsubscribe(address registrant, bool copyExistingEntries) external;
395     function subscriptionOf(address addr) external returns (address registrant);
396     function subscribers(address registrant) external returns (address[] memory);
397     function subscriberAt(address registrant, uint256 index) external returns (address);
398     function copyEntriesOf(address registrant, address registrantToCopy) external;
399     function isOperatorFiltered(address registrant, address operator) external returns (bool);
400     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
401     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
402     function filteredOperators(address addr) external returns (address[] memory);
403     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
404     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
405     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
406     function isRegistered(address addr) external returns (bool);
407     function codeHashOf(address addr) external returns (bytes32);
408 }
409 
410 interface IERC721A {
411     /**
412      * The caller must own the token or be an approved operator.
413      */
414     error ApprovalCallerNotOwnerNorApproved();
415 
416     /**
417      * The token does not exist.
418      */
419     error ApprovalQueryForNonexistentToken();
420 
421     /**
422      * Cannot query the balance for the zero address.
423      */
424     error BalanceQueryForZeroAddress();
425 
426     /**
427      * Cannot mint to the zero address.
428      */
429     error MintToZeroAddress();
430 
431     /**
432      * The quantity of tokens minted must be more than zero.
433      */
434     error MintZeroQuantity();
435 
436     /**
437      * The token does not exist.
438      */
439     error OwnerQueryForNonexistentToken();
440 
441     /**
442      * The caller must own the token or be an approved operator.
443      */
444     error TransferCallerNotOwnerNorApproved();
445 
446     /**
447      * The token must be owned by `from`.
448      */
449     error TransferFromIncorrectOwner();
450 
451     /**
452      * Cannot safely transfer to a contract that does not implement the
453      * ERC721Receiver interface.
454      */
455     error TransferToNonERC721ReceiverImplementer();
456 
457     /**
458      * Cannot transfer to the zero address.
459      */
460     error TransferToZeroAddress();
461 
462     /**
463      * The token does not exist.
464      */
465     error URIQueryForNonexistentToken();
466 
467     /**
468      * The `quantity` minted with ERC2309 exceeds the safety limit.
469      */
470     error MintERC2309QuantityExceedsLimit();
471 
472     /**
473      * The `extraData` cannot be set on an unintialized ownership slot.
474      */
475     error OwnershipNotInitializedForExtraData();
476 
477     // =============================================================
478     //                            STRUCTS
479     // =============================================================
480 
481     struct TokenOwnership {
482         // The address of the owner.
483         address addr;
484         // Stores the start time of ownership with minimal overhead for tokenomics.
485         uint64 startTimestamp;
486         // Whether the token has been burned.
487         bool burned;
488         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
489         uint24 extraData;
490     }
491 
492     // =============================================================
493     //                         TOKEN COUNTERS
494     // =============================================================
495 
496     /**
497      * @dev Returns the total number of tokens in existence.
498      * Burned tokens will reduce the count.
499      * To get the total number of tokens minted, please see {_totalMinted}.
500      */
501     function totalSupply() external view returns (uint256);
502 
503     // =============================================================
504     //                            IERC165
505     // =============================================================
506 
507     /**
508      * @dev Returns true if this contract implements the interface defined by
509      * `interfaceId`. See the corresponding
510      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
511      * to learn more about how these ids are created.
512      *
513      * This function call must use less than 30000 gas.
514      */
515     function supportsInterface(bytes4 interfaceId) external view returns (bool);
516 
517     // =============================================================
518     //                            IERC721
519     // =============================================================
520 
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
532      * @dev Emitted when `owner` enables or disables
533      * (`approved`) `operator` to manage all of its assets.
534      */
535     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
536 
537     /**
538      * @dev Returns the number of tokens in `owner`'s account.
539      */
540     function balanceOf(address owner) external view returns (uint256 balance);
541 
542     /**
543      * @dev Returns the owner of the `tokenId` token.
544      *
545      * Requirements:
546      *
547      * - `tokenId` must exist.
548      */
549     function ownerOf(uint256 tokenId) external view returns (address owner);
550 
551     /**
552      * @dev Safely transfers `tokenId` token from `from` to `to`,
553      * checking first that contract recipients are aware of the ERC721 protocol
554      * to prevent tokens from being forever locked.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be have been allowed to move
562      * this token by either {approve} or {setApprovalForAll}.
563      * - If `to` refers to a smart contract, it must implement
564      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
565      *
566      * Emits a {Transfer} event.
567      */
568     function safeTransferFrom(
569         address from,
570         address to,
571         uint256 tokenId,
572         bytes calldata data
573     ) external payable;
574 
575     /**
576      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 tokenId
582     ) external payable;
583 
584     /**
585      * @dev Transfers `tokenId` from `from` to `to`.
586      *
587      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
588      * whenever possible.
589      *
590      * Requirements:
591      *
592      * - `from` cannot be the zero address.
593      * - `to` cannot be the zero address.
594      * - `tokenId` token must be owned by `from`.
595      * - If the caller is not `from`, it must be approved to move this token
596      * by either {approve} or {setApprovalForAll}.
597      *
598      * Emits a {Transfer} event.
599      */
600     function transferFrom(
601         address from,
602         address to,
603         uint256 tokenId
604     ) external payable;
605 
606     /**
607      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
608      * The approval is cleared when the token is transferred.
609      *
610      * Only a single account can be approved at a time, so approving the
611      * zero address clears previous approvals.
612      *
613      * Requirements:
614      *
615      * - The caller must own the token or be an approved operator.
616      * - `tokenId` must exist.
617      *
618      * Emits an {Approval} event.
619      */
620     function approve(address to, uint256 tokenId) external payable;
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom}
625      * for any token owned by the caller.
626      *
627      * Requirements:
628      *
629      * - The `operator` cannot be the caller.
630      *
631      * Emits an {ApprovalForAll} event.
632      */
633     function setApprovalForAll(address operator, bool _approved) external;
634 
635     /**
636      * @dev Returns the account approved for `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function getApproved(uint256 tokenId) external view returns (address operator);
643 
644     /**
645      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
646      *
647      * See {setApprovalForAll}.
648      */
649     function isApprovedForAll(address owner, address operator) external view returns (bool);
650 
651     // =============================================================
652     //                        IERC721Metadata
653     // =============================================================
654 
655     /**
656      * @dev Returns the token collection name.
657      */
658     function name() external view returns (string memory);
659 
660     /**
661      * @dev Returns the token collection symbol.
662      */
663     function symbol() external view returns (string memory);
664 
665     /**
666      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
667      */
668     function tokenURI(uint256 tokenId) external view returns (string memory);
669 
670     // =============================================================
671     //                           IERC2309
672     // =============================================================
673 
674     /**
675      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
676      * (inclusive) is transferred from `from` to `to`, as defined in the
677      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
678      *
679      * See {_mintERC2309} for more details.
680      */
681     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
682 }
683 
684 abstract contract Context {
685     function _msgSender() internal view virtual returns (address) {
686         return msg.sender;
687     }
688 
689     function _msgData() internal view virtual returns (bytes calldata) {
690         return msg.data;
691     }
692 }
693 
694 abstract contract Ownable is Context {
695     address private _owner;
696 
697     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
698 
699     /**
700      * @dev Initializes the contract setting the deployer as the initial owner.
701      */
702     constructor() {
703         _transferOwnership(_msgSender());
704     }
705 
706     /**
707      * @dev Throws if called by any account other than the owner.
708      */
709     modifier onlyOwner() {
710         _checkOwner();
711         _;
712     }
713 
714     /**
715      * @dev Returns the address of the current owner.
716      */
717     function owner() public view virtual returns (address) {
718         return _owner;
719     }
720 
721     /**
722      * @dev Throws if the sender is not the owner.
723      */
724     function _checkOwner() internal view virtual {
725         require(owner() == _msgSender(), "Ownable: caller is not the owner");
726     }
727 
728     /**
729      * @dev Leaves the contract without owner. It will not be possible to call
730      * `onlyOwner` functions anymore. Can only be called by the current owner.
731      *
732      * NOTE: Renouncing ownership will leave the contract without an owner,
733      * thereby removing any functionality that is only available to the owner.
734      */
735     function renounceOwnership() public virtual onlyOwner {
736         _transferOwnership(address(0));
737     }
738 
739     /**
740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
741      * Can only be called by the current owner.
742      */
743     function transferOwnership(address newOwner) public virtual onlyOwner {
744         require(newOwner != address(0), "Ownable: new owner is the zero address");
745         _transferOwnership(newOwner);
746     }
747 
748     /**
749      * @dev Transfers ownership of the contract to a new account (`newOwner`).
750      * Internal function without access restriction.
751      */
752     function _transferOwnership(address newOwner) internal virtual {
753         address oldOwner = _owner;
754         _owner = newOwner;
755         emit OwnershipTransferred(oldOwner, newOwner);
756     }
757 }
758 
759 interface ERC721A__IERC721Receiver {
760     function onERC721Received(
761         address operator,
762         address from,
763         uint256 tokenId,
764         bytes calldata data
765     ) external returns (bytes4);
766 }
767 
768 contract ERC721A is IERC721A {
769     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
770     struct TokenApprovalRef {
771         address value;
772     }
773 
774     // =============================================================
775     //                           CONSTANTS
776     // =============================================================
777 
778     // Mask of an entry in packed address data.
779     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
780 
781     // The bit position of `numberMinted` in packed address data.
782     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
783 
784     // The bit position of `numberBurned` in packed address data.
785     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
786 
787     // The bit position of `aux` in packed address data.
788     uint256 private constant _BITPOS_AUX = 192;
789 
790     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
791     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
792 
793     // The bit position of `startTimestamp` in packed ownership.
794     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
795 
796     // The bit mask of the `burned` bit in packed ownership.
797     uint256 private constant _BITMASK_BURNED = 1 << 224;
798 
799     // The bit position of the `nextInitialized` bit in packed ownership.
800     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
801 
802     // The bit mask of the `nextInitialized` bit in packed ownership.
803     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
804 
805     // The bit position of `extraData` in packed ownership.
806     uint256 private constant _BITPOS_EXTRA_DATA = 232;
807 
808     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
809     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
810 
811     // The mask of the lower 160 bits for addresses.
812     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
813 
814     // The maximum `quantity` that can be minted with {_mintERC2309}.
815     // This limit is to prevent overflows on the address data entries.
816     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
817     // is required to cause an overflow, which is unrealistic.
818     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
819 
820     // The `Transfer` event signature is given by:
821     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
822     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
823         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
824 
825     // =============================================================
826     //                            STORAGE
827     // =============================================================
828 
829     // The next token ID to be minted.
830     uint256 private _currentIndex;
831 
832     // The number of tokens burned.
833     uint256 private _burnCounter;
834 
835     // Token name
836     string private _name;
837 
838     // Token symbol
839     string private _symbol;
840 
841     // Mapping from token ID to ownership details
842     // An empty struct value does not necessarily mean the token is unowned.
843     // See {_packedOwnershipOf} implementation for details.
844     //
845     // Bits Layout:
846     // - [0..159]   `addr`
847     // - [160..223] `startTimestamp`
848     // - [224]      `burned`
849     // - [225]      `nextInitialized`
850     // - [232..255] `extraData`
851     mapping(uint256 => uint256) private _packedOwnerships;
852 
853     // Mapping owner address to address data.
854     //
855     // Bits Layout:
856     // - [0..63]    `balance`
857     // - [64..127]  `numberMinted`
858     // - [128..191] `numberBurned`
859     // - [192..255] `aux`
860     mapping(address => uint256) private _packedAddressData;
861 
862     // Mapping from token ID to approved address.
863     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
864 
865     // Mapping from owner to operator approvals
866     mapping(address => mapping(address => bool)) private _operatorApprovals;
867 
868     // =============================================================
869     //                          CONSTRUCTOR
870     // =============================================================
871 
872     constructor(string memory name_, string memory symbol_) {
873         _name = name_;
874         _symbol = symbol_;
875         _currentIndex = _startTokenId();
876     }
877 
878     // =============================================================
879     //                   TOKEN COUNTING OPERATIONS
880     // =============================================================
881 
882     /**
883      * @dev Returns the starting token ID.
884      * To change the starting token ID, please override this function.
885      */
886     function _startTokenId() internal view virtual returns (uint256) {
887         return 1;
888     }
889 
890     /**
891      * @dev Returns the next token ID to be minted.
892      */
893     function _nextTokenId() internal view virtual returns (uint256) {
894         return _currentIndex;
895     }
896 
897     /**
898      * @dev Returns the total number of tokens in existence.
899      * Burned tokens will reduce the count.
900      * To get the total number of tokens minted, please see {_totalMinted}.
901      */
902     function totalSupply() public view virtual override returns (uint256) {
903         // Counter underflow is impossible as _burnCounter cannot be incremented
904         // more than `_currentIndex - _startTokenId()` times.
905         unchecked {
906             return _currentIndex - _burnCounter - _startTokenId();
907         }
908     }
909 
910     /**
911      * @dev Returns the total amount of tokens minted in the contract.
912      */
913     function _totalMinted() internal view virtual returns (uint256) {
914         // Counter underflow is impossible as `_currentIndex` does not decrement,
915         // and it is initialized to `_startTokenId()`.
916         unchecked {
917             return _currentIndex - _startTokenId();
918         }
919     }
920 
921     /**
922      * @dev Returns the total number of tokens burned.
923      */
924     function _totalBurned() internal view virtual returns (uint256) {
925         return _burnCounter;
926     }
927 
928     // =============================================================
929     //                    ADDRESS DATA OPERATIONS
930     // =============================================================
931 
932     /**
933      * @dev Returns the number of tokens in `owner`'s account.
934      */
935     function balanceOf(address owner) public view virtual override returns (uint256) {
936         if (owner == address(0)) revert BalanceQueryForZeroAddress();
937         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
938     }
939 
940     /**
941      * Returns the number of tokens minted by `owner`.
942      */
943     function _numberMinted(address owner) internal view returns (uint256) {
944         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
945     }
946 
947     /**
948      * Returns the number of tokens burned by or on behalf of `owner`.
949      */
950     function _numberBurned(address owner) internal view returns (uint256) {
951         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
952     }
953 
954     /**
955      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
956      */
957     function _getAux(address owner) internal view returns (uint64) {
958         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
959     }
960 
961     /**
962      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
963      * If there are multiple variables, please pack them into a uint64.
964      */
965     function _setAux(address owner, uint64 aux) internal virtual {
966         uint256 packed = _packedAddressData[owner];
967         uint256 auxCasted;
968         // Cast `aux` with assembly to avoid redundant masking.
969         assembly {
970             auxCasted := aux
971         }
972         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
973         _packedAddressData[owner] = packed;
974     }
975 
976     // =============================================================
977     //                            IERC165
978     // =============================================================
979 
980     /**
981      * @dev Returns true if this contract implements the interface defined by
982      * `interfaceId`. See the corresponding
983      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
984      * to learn more about how these ids are created.
985      *
986      * This function call must use less than 30000 gas.
987      */
988     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
989         // The interface IDs are constants representing the first 4 bytes
990         // of the XOR of all function selectors in the interface.
991         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
992         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
993         return
994             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
995             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
996             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
997     }
998 
999     // =============================================================
1000     //                        IERC721Metadata
1001     // =============================================================
1002 
1003     /**
1004      * @dev Returns the token collection name.
1005      */
1006     function name() public view virtual override returns (string memory) {
1007         return _name;
1008     }
1009 
1010     /**
1011      * @dev Returns the token collection symbol.
1012      */
1013     function symbol() public view virtual override returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     /**
1018      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1019      */
1020     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1021         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1022 
1023         string memory baseURI = _baseURI();
1024         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1025     }
1026 
1027     /**
1028      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1029      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1030      * by default, it can be overridden in child contracts.
1031      */
1032     function _baseURI() internal view virtual returns (string memory) {
1033         return '';
1034     }
1035 
1036     // =============================================================
1037     //                     OWNERSHIPS OPERATIONS
1038     // =============================================================
1039 
1040     /**
1041      * @dev Returns the owner of the `tokenId` token.
1042      *
1043      * Requirements:
1044      *
1045      * - `tokenId` must exist.
1046      */
1047     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1048         return address(uint160(_packedOwnershipOf(tokenId)));
1049     }
1050 
1051     /**
1052      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1053      * It gradually moves to O(1) as tokens get transferred around over time.
1054      */
1055     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1056         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1057     }
1058 
1059     /**
1060      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1061      */
1062     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1063         return _unpackedOwnership(_packedOwnerships[index]);
1064     }
1065 
1066     /**
1067      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1068      */
1069     function _initializeOwnershipAt(uint256 index) internal virtual {
1070         if (_packedOwnerships[index] == 0) {
1071             _packedOwnerships[index] = _packedOwnershipOf(index);
1072         }
1073     }
1074 
1075     /**
1076      * Returns the packed ownership data of `tokenId`.
1077      */
1078     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1079         uint256 curr = tokenId;
1080 
1081         unchecked {
1082             if (_startTokenId() <= curr)
1083                 if (curr < _currentIndex) {
1084                     uint256 packed = _packedOwnerships[curr];
1085                     // If not burned.
1086                     if (packed & _BITMASK_BURNED == 0) {
1087                         // Invariant:
1088                         // There will always be an initialized ownership slot
1089                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1090                         // before an unintialized ownership slot
1091                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1092                         // Hence, `curr` will not underflow.
1093                         //
1094                         // We can directly compare the packed value.
1095                         // If the address is zero, packed will be zero.
1096                         while (packed == 0) {
1097                             packed = _packedOwnerships[--curr];
1098                         }
1099                         return packed;
1100                     }
1101                 }
1102         }
1103         revert OwnerQueryForNonexistentToken();
1104     }
1105 
1106     /**
1107      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1108      */
1109     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1110         ownership.addr = address(uint160(packed));
1111         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1112         ownership.burned = packed & _BITMASK_BURNED != 0;
1113         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1114     }
1115 
1116     /**
1117      * @dev Packs ownership data into a single uint256.
1118      */
1119     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1120         assembly {
1121             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1122             owner := and(owner, _BITMASK_ADDRESS)
1123             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1124             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1125         }
1126     }
1127 
1128     /**
1129      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1130      */
1131     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1132         // For branchless setting of the `nextInitialized` flag.
1133         assembly {
1134             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1135             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1136         }
1137     }
1138 
1139     // =============================================================
1140     //                      APPROVAL OPERATIONS
1141     // =============================================================
1142 
1143     /**
1144      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1145      * The approval is cleared when the token is transferred.
1146      *
1147      * Only a single account can be approved at a time, so approving the
1148      * zero address clears previous approvals.
1149      *
1150      * Requirements:
1151      *
1152      * - The caller must own the token or be an approved operator.
1153      * - `tokenId` must exist.
1154      *
1155      * Emits an {Approval} event.
1156      */
1157     function approve(address to, uint256 tokenId) public payable virtual override {
1158         address owner = ownerOf(tokenId);
1159 
1160         if (_msgSenderERC721A() != owner)
1161             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1162                 revert ApprovalCallerNotOwnerNorApproved();
1163             }
1164 
1165         _tokenApprovals[tokenId].value = to;
1166         emit Approval(owner, to, tokenId);
1167     }
1168 
1169     /**
1170      * @dev Returns the account approved for `tokenId` token.
1171      *
1172      * Requirements:
1173      *
1174      * - `tokenId` must exist.
1175      */
1176     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1177         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1178 
1179         return _tokenApprovals[tokenId].value;
1180     }
1181 
1182     /**
1183      * @dev Approve or remove `operator` as an operator for the caller.
1184      * Operators can call {transferFrom} or {safeTransferFrom}
1185      * for any token owned by the caller.
1186      *
1187      * Requirements:
1188      *
1189      * - The `operator` cannot be the caller.
1190      *
1191      * Emits an {ApprovalForAll} event.
1192      */
1193     function setApprovalForAll(address operator, bool approved) public virtual override {
1194         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1195         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1196     }
1197 
1198     /**
1199      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1200      *
1201      * See {setApprovalForAll}.
1202      */
1203     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1204         return _operatorApprovals[owner][operator];
1205     }
1206 
1207     /**
1208      * @dev Returns whether `tokenId` exists.
1209      *
1210      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1211      *
1212      * Tokens start existing when they are minted. See {_mint}.
1213      */
1214     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1215         return
1216             _startTokenId() <= tokenId &&
1217             tokenId < _currentIndex && // If within bounds,
1218             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1219     }
1220 
1221     /**
1222      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1223      */
1224     function _isSenderApprovedOrOwner(
1225         address approvedAddress,
1226         address owner,
1227         address msgSender
1228     ) private pure returns (bool result) {
1229         assembly {
1230             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1231             owner := and(owner, _BITMASK_ADDRESS)
1232             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1233             msgSender := and(msgSender, _BITMASK_ADDRESS)
1234             // `msgSender == owner || msgSender == approvedAddress`.
1235             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1236         }
1237     }
1238 
1239     /**
1240      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1241      */
1242     function _getApprovedSlotAndAddress(uint256 tokenId)
1243         private
1244         view
1245         returns (uint256 approvedAddressSlot, address approvedAddress)
1246     {
1247         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1248         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1249         assembly {
1250             approvedAddressSlot := tokenApproval.slot
1251             approvedAddress := sload(approvedAddressSlot)
1252         }
1253     }
1254 
1255     // =============================================================
1256     //                      TRANSFER OPERATIONS
1257     // =============================================================
1258 
1259     /**
1260      * @dev Transfers `tokenId` from `from` to `to`.
1261      *
1262      * Requirements:
1263      *
1264      * - `from` cannot be the zero address.
1265      * - `to` cannot be the zero address.
1266      * - `tokenId` token must be owned by `from`.
1267      * - If the caller is not `from`, it must be approved to move this token
1268      * by either {approve} or {setApprovalForAll}.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function transferFrom(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) public payable virtual override {
1277         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1278 
1279         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1280 
1281         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1282 
1283         // The nested ifs save around 20+ gas over a compound boolean condition.
1284         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1285             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1286 
1287         if (to == address(0)) revert TransferToZeroAddress();
1288 
1289         _beforeTokenTransfers(from, to, tokenId, 1);
1290 
1291         // Clear approvals from the previous owner.
1292         assembly {
1293             if approvedAddress {
1294                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1295                 sstore(approvedAddressSlot, 0)
1296             }
1297         }
1298 
1299         // Underflow of the sender's balance is impossible because we check for
1300         // ownership above and the recipient's balance can't realistically overflow.
1301         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1302         unchecked {
1303             // We can directly increment and decrement the balances.
1304             --_packedAddressData[from]; // Updates: `balance -= 1`.
1305             ++_packedAddressData[to]; // Updates: `balance += 1`.
1306 
1307             // Updates:
1308             // - `address` to the next owner.
1309             // - `startTimestamp` to the timestamp of transfering.
1310             // - `burned` to `false`.
1311             // - `nextInitialized` to `true`.
1312             _packedOwnerships[tokenId] = _packOwnershipData(
1313                 to,
1314                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1315             );
1316 
1317             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1318             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1319                 uint256 nextTokenId = tokenId + 1;
1320                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1321                 if (_packedOwnerships[nextTokenId] == 0) {
1322                     // If the next slot is within bounds.
1323                     if (nextTokenId != _currentIndex) {
1324                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1325                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1326                     }
1327                 }
1328             }
1329         }
1330 
1331         emit Transfer(from, to, tokenId);
1332         _afterTokenTransfers(from, to, tokenId, 1);
1333     }
1334 
1335     /**
1336      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1337      */
1338     function safeTransferFrom(
1339         address from,
1340         address to,
1341         uint256 tokenId
1342     ) public payable virtual override {
1343         safeTransferFrom(from, to, tokenId, '');
1344     }
1345 
1346     /**
1347      * @dev Safely transfers `tokenId` token from `from` to `to`.
1348      *
1349      * Requirements:
1350      *
1351      * - `from` cannot be the zero address.
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must exist and be owned by `from`.
1354      * - If the caller is not `from`, it must be approved to move this token
1355      * by either {approve} or {setApprovalForAll}.
1356      * - If `to` refers to a smart contract, it must implement
1357      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function safeTransferFrom(
1362         address from,
1363         address to,
1364         uint256 tokenId,
1365         bytes memory _data
1366     ) public payable virtual override {
1367         transferFrom(from, to, tokenId);
1368         if (to.code.length != 0)
1369             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1370                 revert TransferToNonERC721ReceiverImplementer();
1371             }
1372     }
1373 
1374     /**
1375      * @dev Hook that is called before a set of serially-ordered token IDs
1376      * are about to be transferred. This includes minting.
1377      * And also called before burning one token.
1378      *
1379      * `startTokenId` - the first token ID to be transferred.
1380      * `quantity` - the amount to be transferred.
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` will be minted for `to`.
1387      * - When `to` is zero, `tokenId` will be burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _beforeTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 
1397     /**
1398      * @dev Hook that is called after a set of serially-ordered token IDs
1399      * have been transferred. This includes minting.
1400      * And also called after one token has been burned.
1401      *
1402      * `startTokenId` - the first token ID to be transferred.
1403      * `quantity` - the amount to be transferred.
1404      *
1405      * Calling conditions:
1406      *
1407      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1408      * transferred to `to`.
1409      * - When `from` is zero, `tokenId` has been minted for `to`.
1410      * - When `to` is zero, `tokenId` has been burned by `from`.
1411      * - `from` and `to` are never both zero.
1412      */
1413     function _afterTokenTransfers(
1414         address from,
1415         address to,
1416         uint256 startTokenId,
1417         uint256 quantity
1418     ) internal virtual {}
1419 
1420     /**
1421      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1422      *
1423      * `from` - Previous owner of the given token ID.
1424      * `to` - Target address that will receive the token.
1425      * `tokenId` - Token ID to be transferred.
1426      * `_data` - Optional data to send along with the call.
1427      *
1428      * Returns whether the call correctly returned the expected magic value.
1429      */
1430     function _checkContractOnERC721Received(
1431         address from,
1432         address to,
1433         uint256 tokenId,
1434         bytes memory _data
1435     ) private returns (bool) {
1436         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1437             bytes4 retval
1438         ) {
1439             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1440         } catch (bytes memory reason) {
1441             if (reason.length == 0) {
1442                 revert TransferToNonERC721ReceiverImplementer();
1443             } else {
1444                 assembly {
1445                     revert(add(32, reason), mload(reason))
1446                 }
1447             }
1448         }
1449     }
1450 
1451     // =============================================================
1452     //                        MINT OPERATIONS
1453     // =============================================================
1454 
1455     /**
1456      * @dev Mints `quantity` tokens and transfers them to `to`.
1457      *
1458      * Requirements:
1459      *
1460      * - `to` cannot be the zero address.
1461      * - `quantity` must be greater than 0.
1462      *
1463      * Emits a {Transfer} event for each mint.
1464      */
1465     function _mint(address to, uint256 quantity) internal virtual {
1466         uint256 startTokenId = _currentIndex;
1467         if (quantity == 0) revert MintZeroQuantity();
1468 
1469         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1470 
1471         // Overflows are incredibly unrealistic.
1472         // `balance` and `numberMinted` have a maximum limit of 2**64.
1473         // `tokenId` has a maximum limit of 2**256.
1474         unchecked {
1475             // Updates:
1476             // - `balance += quantity`.
1477             // - `numberMinted += quantity`.
1478             //
1479             // We can directly add to the `balance` and `numberMinted`.
1480             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1481 
1482             // Updates:
1483             // - `address` to the owner.
1484             // - `startTimestamp` to the timestamp of minting.
1485             // - `burned` to `false`.
1486             // - `nextInitialized` to `quantity == 1`.
1487             _packedOwnerships[startTokenId] = _packOwnershipData(
1488                 to,
1489                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1490             );
1491 
1492             uint256 toMasked;
1493             uint256 end = startTokenId + quantity;
1494 
1495             // Use assembly to loop and emit the `Transfer` event for gas savings.
1496             // The duplicated `log4` removes an extra check and reduces stack juggling.
1497             // The assembly, together with the surrounding Solidity code, have been
1498             // delicately arranged to nudge the compiler into producing optimized opcodes.
1499             assembly {
1500                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1501                 toMasked := and(to, _BITMASK_ADDRESS)
1502                 // Emit the `Transfer` event.
1503                 log4(
1504                     0, // Start of data (0, since no data).
1505                     0, // End of data (0, since no data).
1506                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1507                     0, // `address(0)`.
1508                     toMasked, // `to`.
1509                     startTokenId // `tokenId`.
1510                 )
1511 
1512                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1513                 // that overflows uint256 will make the loop run out of gas.
1514                 // The compiler will optimize the `iszero` away for performance.
1515                 for {
1516                     let tokenId := add(startTokenId, 1)
1517                 } iszero(eq(tokenId, end)) {
1518                     tokenId := add(tokenId, 1)
1519                 } {
1520                     // Emit the `Transfer` event. Similar to above.
1521                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1522                 }
1523             }
1524             if (toMasked == 0) revert MintToZeroAddress();
1525 
1526             _currentIndex = end;
1527         }
1528         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1529     }
1530 
1531     /**
1532      * @dev Mints `quantity` tokens and transfers them to `to`.
1533      *
1534      * This function is intended for efficient minting only during contract creation.
1535      *
1536      * It emits only one {ConsecutiveTransfer} as defined in
1537      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1538      * instead of a sequence of {Transfer} event(s).
1539      *
1540      * Calling this function outside of contract creation WILL make your contract
1541      * non-compliant with the ERC721 standard.
1542      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1543      * {ConsecutiveTransfer} event is only permissible during contract creation.
1544      *
1545      * Requirements:
1546      *
1547      * - `to` cannot be the zero address.
1548      * - `quantity` must be greater than 0.
1549      *
1550      * Emits a {ConsecutiveTransfer} event.
1551      */
1552     function _mintERC2309(address to, uint256 quantity) internal virtual {
1553         uint256 startTokenId = _currentIndex;
1554         if (to == address(0)) revert MintToZeroAddress();
1555         if (quantity == 0) revert MintZeroQuantity();
1556         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1557 
1558         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1559 
1560         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1561         unchecked {
1562             // Updates:
1563             // - `balance += quantity`.
1564             // - `numberMinted += quantity`.
1565             //
1566             // We can directly add to the `balance` and `numberMinted`.
1567             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1568 
1569             // Updates:
1570             // - `address` to the owner.
1571             // - `startTimestamp` to the timestamp of minting.
1572             // - `burned` to `false`.
1573             // - `nextInitialized` to `quantity == 1`.
1574             _packedOwnerships[startTokenId] = _packOwnershipData(
1575                 to,
1576                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1577             );
1578 
1579             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1580 
1581             _currentIndex = startTokenId + quantity;
1582         }
1583         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1584     }
1585 
1586     /**
1587      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1588      *
1589      * Requirements:
1590      *
1591      * - If `to` refers to a smart contract, it must implement
1592      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1593      * - `quantity` must be greater than 0.
1594      *
1595      * See {_mint}.
1596      *
1597      * Emits a {Transfer} event for each mint.
1598      */
1599     function _safeMint(
1600         address to,
1601         uint256 quantity,
1602         bytes memory _data
1603     ) internal virtual {
1604         _mint(to, quantity);
1605 
1606         unchecked {
1607             if (to.code.length != 0) {
1608                 uint256 end = _currentIndex;
1609                 uint256 index = end - quantity;
1610                 do {
1611                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1612                         revert TransferToNonERC721ReceiverImplementer();
1613                     }
1614                 } while (index < end);
1615                 // Reentrancy protection.
1616                 if (_currentIndex != end) revert();
1617             }
1618         }
1619     }
1620 
1621     /**
1622      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1623      */
1624     function _safeMint(address to, uint256 quantity) internal virtual {
1625         _safeMint(to, quantity, '');
1626     }
1627 
1628     // =============================================================
1629     //                        BURN OPERATIONS
1630     // =============================================================
1631 
1632     /**
1633      * @dev Equivalent to `_burn(tokenId, false)`.
1634      */
1635     function _burn(uint256 tokenId) internal virtual {
1636         _burn(tokenId, false);
1637     }
1638 
1639     /**
1640      * @dev Destroys `tokenId`.
1641      * The approval is cleared when the token is burned.
1642      *
1643      * Requirements:
1644      *
1645      * - `tokenId` must exist.
1646      *
1647      * Emits a {Transfer} event.
1648      */
1649     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1650         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1651 
1652         address from = address(uint160(prevOwnershipPacked));
1653 
1654         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1655 
1656         if (approvalCheck) {
1657             // The nested ifs save around 20+ gas over a compound boolean condition.
1658             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1659                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1660         }
1661 
1662         _beforeTokenTransfers(from, address(0), tokenId, 1);
1663 
1664         // Clear approvals from the previous owner.
1665         assembly {
1666             if approvedAddress {
1667                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1668                 sstore(approvedAddressSlot, 0)
1669             }
1670         }
1671 
1672         // Underflow of the sender's balance is impossible because we check for
1673         // ownership above and the recipient's balance can't realistically overflow.
1674         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1675         unchecked {
1676             // Updates:
1677             // - `balance -= 1`.
1678             // - `numberBurned += 1`.
1679             //
1680             // We can directly decrement the balance, and increment the number burned.
1681             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1682             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1683 
1684             // Updates:
1685             // - `address` to the last owner.
1686             // - `startTimestamp` to the timestamp of burning.
1687             // - `burned` to `true`.
1688             // - `nextInitialized` to `true`.
1689             _packedOwnerships[tokenId] = _packOwnershipData(
1690                 from,
1691                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1692             );
1693 
1694             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1695             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1696                 uint256 nextTokenId = tokenId + 1;
1697                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1698                 if (_packedOwnerships[nextTokenId] == 0) {
1699                     // If the next slot is within bounds.
1700                     if (nextTokenId != _currentIndex) {
1701                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1702                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1703                     }
1704                 }
1705             }
1706         }
1707 
1708         emit Transfer(from, address(0), tokenId);
1709         _afterTokenTransfers(from, address(0), tokenId, 1);
1710 
1711         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1712         unchecked {
1713             _burnCounter++;
1714         }
1715     }
1716 
1717     // =============================================================
1718     //                     EXTRA DATA OPERATIONS
1719     // =============================================================
1720 
1721     /**
1722      * @dev Directly sets the extra data for the ownership data `index`.
1723      */
1724     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1725         uint256 packed = _packedOwnerships[index];
1726         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1727         uint256 extraDataCasted;
1728         // Cast `extraData` with assembly to avoid redundant masking.
1729         assembly {
1730             extraDataCasted := extraData
1731         }
1732         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1733         _packedOwnerships[index] = packed;
1734     }
1735 
1736     /**
1737      * @dev Called during each token transfer to set the 24bit `extraData` field.
1738      * Intended to be overridden by the cosumer contract.
1739      *
1740      * `previousExtraData` - the value of `extraData` before transfer.
1741      *
1742      * Calling conditions:
1743      *
1744      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1745      * transferred to `to`.
1746      * - When `from` is zero, `tokenId` will be minted for `to`.
1747      * - When `to` is zero, `tokenId` will be burned by `from`.
1748      * - `from` and `to` are never both zero.
1749      */
1750     function _extraData(
1751         address from,
1752         address to,
1753         uint24 previousExtraData
1754     ) internal view virtual returns (uint24) {}
1755 
1756     /**
1757      * @dev Returns the next extra data for the packed ownership data.
1758      * The returned result is shifted into position.
1759      */
1760     function _nextExtraData(
1761         address from,
1762         address to,
1763         uint256 prevOwnershipPacked
1764     ) private view returns (uint256) {
1765         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1766         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1767     }
1768 
1769     // =============================================================
1770     //                       OTHER OPERATIONS
1771     // =============================================================
1772 
1773     /**
1774      * @dev Returns the message sender (defaults to `msg.sender`).
1775      *
1776      * If you are writing GSN compatible contracts, you need to override this function.
1777      */
1778     function _msgSenderERC721A() internal view virtual returns (address) {
1779         return msg.sender;
1780     }
1781 
1782     /**
1783      * @dev Converts a uint256 to its ASCII string decimal representation.
1784      */
1785     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1786         assembly {
1787             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1788             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1789             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1790             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1791             let m := add(mload(0x40), 0xa0)
1792             // Update the free memory pointer to allocate.
1793             mstore(0x40, m)
1794             // Assign the `str` to the end.
1795             str := sub(m, 0x20)
1796             // Zeroize the slot after the string.
1797             mstore(str, 0)
1798 
1799             // Cache the end of the memory to calculate the length later.
1800             let end := str
1801 
1802             // We write the string from rightmost digit to leftmost digit.
1803             // The following is essentially a do-while loop that also handles the zero case.
1804             // prettier-ignore
1805             for { let temp := value } 1 {} {
1806                 str := sub(str, 1)
1807                 // Write the character to the pointer.
1808                 // The ASCII index of the '0' character is 48.
1809                 mstore8(str, add(48, mod(temp, 10)))
1810                 // Keep dividing `temp` until zero.
1811                 temp := div(temp, 10)
1812                 // prettier-ignore
1813                 if iszero(temp) { break }
1814             }
1815 
1816             let length := sub(end, str)
1817             // Move the pointer 32 bytes leftwards to make room for the length.
1818             str := sub(str, 0x20)
1819             // Store the length.
1820             mstore(str, length)
1821         }
1822     }
1823 }
1824 
1825 contract MyPersonnalSandwishMaker is ERC721A, Ownable, DefaultOperatorFilterer {
1826 
1827     enum Step {
1828         Before,
1829         PublicSale
1830     }
1831     Step public sellingStep;
1832 
1833     string public baseURI;
1834 
1835     constructor(string memory _baseURI) ERC721A("My Personal Sandwich Maker", "MPSM") {
1836         baseURI = _baseURI;
1837     }
1838 
1839     mapping(address => uint) public mintedAmountNFTsperWalletPublicSale;
1840     mapping(address => uint) public freeMintAmount;
1841     uint public maxWallet = 5;
1842 
1843     uint public MAX_SUPPLY = 1000;
1844 
1845     error ArrayMismatch();
1846 
1847     function batchAirdrop(uint256[] calldata quantities, address[] calldata recipients) external onlyOwner {
1848         if(quantities.length != recipients.length) revert ArrayMismatch();
1849 
1850         uint256 length = quantities.length;
1851 
1852         for(uint256 i; i < length; i++) {
1853             _mint(recipients[i], quantities[i]);
1854         }
1855     }
1856 
1857     function mint(uint _quantity) public {
1858         require(msg.sender == tx.origin);
1859         if(sellingStep != Step.PublicSale) revert("Public Mint not live.");
1860         if(mintedAmountNFTsperWalletPublicSale[msg.sender] > maxWallet) revert("max exceeded");
1861         if(totalSupply() + _quantity > (MAX_SUPPLY)) revert("Max supply exceeded for public exceeded");
1862         mintedAmountNFTsperWalletPublicSale[msg.sender] += _quantity;
1863         _mint(msg.sender, _quantity);
1864     }
1865 
1866     function mintForOwner(uint _quantity) public onlyOwner{
1867         _mint(msg.sender, _quantity);
1868     }
1869 
1870     function changeMaxWallet(uint newValue) public onlyOwner{
1871         maxWallet = newValue;
1872     }
1873 
1874     function changeMaxSupply(uint newValue) public onlyOwner{
1875         MAX_SUPPLY = newValue;
1876     }
1877 
1878     function setStep(uint _step) external onlyOwner {
1879         sellingStep = Step(_step);
1880     }
1881 
1882     function setBaseUri(string memory _baseURI) external onlyOwner {
1883         baseURI = _baseURI;
1884     }
1885 
1886     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator payable {
1887         super.transferFrom(from, to, tokenId);
1888     }
1889 
1890     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator payable {
1891         super.safeTransferFrom(from, to, tokenId);
1892     }
1893 
1894     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1895         public
1896         override
1897         onlyAllowedOperator
1898         payable
1899     {
1900         super.safeTransferFrom(from, to, tokenId, data);
1901     }
1902 
1903     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1904         require(_exists(_tokenId), "URI query for nonexistent token");
1905         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
1906     }
1907 
1908     function withdraw() external onlyOwner {
1909         require(payable(msg.sender).send(address(this).balance));
1910     }
1911 }