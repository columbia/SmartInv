1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.19;
7 
8 
9 contract OperatorFilterer {
10     error OperatorNotAllowed(address operator);
11 
12     IOperatorFilterRegistry constant operatorFilterRegistry =
13         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
14 
15     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
16         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
17         // will not revert, but the contract will need to be registered with the registry once it is deployed in
18         // order for the modifier to filter addresses.
19         if (address(operatorFilterRegistry).code.length > 0) {
20             if (subscribe) {
21                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
22             } else {
23                 if (subscriptionOrRegistrantToCopy != address(0)) {
24                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
25                 } else {
26                     operatorFilterRegistry.register(address(this));
27                 }
28             }
29         }
30     }
31 
32     modifier onlyAllowedOperator() virtual {
33         // Check registry code length to facilitate testing in environments without a deployed registry.
34         if (address(operatorFilterRegistry).code.length > 0) {
35             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
36                 revert OperatorNotAllowed(msg.sender);
37             }
38         }
39         _;
40     }
41 }
42 
43 contract DefaultOperatorFilterer is OperatorFilterer {
44     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
45 
46     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
47 }
48 
49 library EnumerableSet {
50     // To implement this library for multiple types with as little code
51     // repetition as possible, we write it in terms of a generic Set type with
52     // bytes32 values.
53     // The Set implementation uses private functions, and user-facing
54     // implementations (such as AddressSet) are just wrappers around the
55     // underlying Set.
56     // This means that we can only create new EnumerableSets for types that fit
57     // in bytes32.
58 
59     struct Set {
60         // Storage of set values
61         bytes32[] _values;
62         // Position of the value in the `values` array, plus 1 because index 0
63         // means a value is not in the set.
64         mapping(bytes32 => uint256) _indexes;
65     }
66 
67     /**
68      * @dev Add a value to a set. O(1).
69      *
70      * Returns true if the value was added to the set, that is if it was not
71      * already present.
72      */
73     function _add(Set storage set, bytes32 value) private returns (bool) {
74         if (!_contains(set, value)) {
75             set._values.push(value);
76             // The value is stored at length-1, but we add 1 to all indexes
77             // and use 0 as a sentinel value
78             set._indexes[value] = set._values.length;
79             return true;
80         } else {
81             return false;
82         }
83     }
84 
85     /**
86      * @dev Removes a value from a set. O(1).
87      *
88      * Returns true if the value was removed from the set, that is if it was
89      * present.
90      */
91     function _remove(Set storage set, bytes32 value) private returns (bool) {
92         // We read and store the value's index to prevent multiple reads from the same storage slot
93         uint256 valueIndex = set._indexes[value];
94 
95         if (valueIndex != 0) {
96             // Equivalent to contains(set, value)
97             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
98             // the array, and then remove the last element (sometimes called as 'swap and pop').
99             // This modifies the order of the array, as noted in {at}.
100 
101             uint256 toDeleteIndex = valueIndex - 1;
102             uint256 lastIndex = set._values.length - 1;
103 
104             if (lastIndex != toDeleteIndex) {
105                 bytes32 lastValue = set._values[lastIndex];
106 
107                 // Move the last value to the index where the value to delete is
108                 set._values[toDeleteIndex] = lastValue;
109                 // Update the index for the moved value
110                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
111             }
112 
113             // Delete the slot where the moved value was stored
114             set._values.pop();
115 
116             // Delete the index for the deleted slot
117             delete set._indexes[value];
118 
119             return true;
120         } else {
121             return false;
122         }
123     }
124 
125     /**
126      * @dev Returns true if the value is in the set. O(1).
127      */
128     function _contains(Set storage set, bytes32 value) private view returns (bool) {
129         return set._indexes[value] != 0;
130     }
131 
132     /**
133      * @dev Returns the number of values on the set. O(1).
134      */
135     function _length(Set storage set) private view returns (uint256) {
136         return set._values.length;
137     }
138 
139     /**
140      * @dev Returns the value stored at position `index` in the set. O(1).
141      *
142      * Note that there are no guarantees on the ordering of values inside the
143      * array, and it may change when more values are added or removed.
144      *
145      * Requirements:
146      *
147      * - `index` must be strictly less than {length}.
148      */
149     function _at(Set storage set, uint256 index) private view returns (bytes32) {
150         return set._values[index];
151     }
152 
153     /**
154      * @dev Return the entire set in an array
155      *
156      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
157      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
158      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
159      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
160      */
161     function _values(Set storage set) private view returns (bytes32[] memory) {
162         return set._values;
163     }
164 
165     // Bytes32Set
166 
167     struct Bytes32Set {
168         Set _inner;
169     }
170 
171     /**
172      * @dev Add a value to a set. O(1).
173      *
174      * Returns true if the value was added to the set, that is if it was not
175      * already present.
176      */
177     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
178         return _add(set._inner, value);
179     }
180 
181     /**
182      * @dev Removes a value from a set. O(1).
183      *
184      * Returns true if the value was removed from the set, that is if it was
185      * present.
186      */
187     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
188         return _remove(set._inner, value);
189     }
190 
191     /**
192      * @dev Returns true if the value is in the set. O(1).
193      */
194     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
195         return _contains(set._inner, value);
196     }
197 
198     /**
199      * @dev Returns the number of values in the set. O(1).
200      */
201     function length(Bytes32Set storage set) internal view returns (uint256) {
202         return _length(set._inner);
203     }
204 
205     /**
206      * @dev Returns the value stored at position `index` in the set. O(1).
207      *
208      * Note that there are no guarantees on the ordering of values inside the
209      * array, and it may change when more values are added or removed.
210      *
211      * Requirements:
212      *
213      * - `index` must be strictly less than {length}.
214      */
215     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
216         return _at(set._inner, index);
217     }
218 
219     /**
220      * @dev Return the entire set in an array
221      *
222      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
223      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
224      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
225      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
226      */
227     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
228         bytes32[] memory store = _values(set._inner);
229         bytes32[] memory result;
230 
231         /// @solidity memory-safe-assembly
232         assembly {
233             result := store
234         }
235 
236         return result;
237     }
238 
239     // AddressSet
240 
241     struct AddressSet {
242         Set _inner;
243     }
244 
245     /**
246      * @dev Add a value to a set. O(1).
247      *
248      * Returns true if the value was added to the set, that is if it was not
249      * already present.
250      */
251     function add(AddressSet storage set, address value) internal returns (bool) {
252         return _add(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     /**
256      * @dev Removes a value from a set. O(1).
257      *
258      * Returns true if the value was removed from the set, that is if it was
259      * present.
260      */
261     function remove(AddressSet storage set, address value) internal returns (bool) {
262         return _remove(set._inner, bytes32(uint256(uint160(value))));
263     }
264 
265     /**
266      * @dev Returns true if the value is in the set. O(1).
267      */
268     function contains(AddressSet storage set, address value) internal view returns (bool) {
269         return _contains(set._inner, bytes32(uint256(uint160(value))));
270     }
271 
272     /**
273      * @dev Returns the number of values in the set. O(1).
274      */
275     function length(AddressSet storage set) internal view returns (uint256) {
276         return _length(set._inner);
277     }
278 
279     /**
280      * @dev Returns the value stored at position `index` in the set. O(1).
281      *
282      * Note that there are no guarantees on the ordering of values inside the
283      * array, and it may change when more values are added or removed.
284      *
285      * Requirements:
286      *
287      * - `index` must be strictly less than {length}.
288      */
289     function at(AddressSet storage set, uint256 index) internal view returns (address) {
290         return address(uint160(uint256(_at(set._inner, index))));
291     }
292 
293     /**
294      * @dev Return the entire set in an array
295      *
296      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
297      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
298      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
299      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
300      */
301     function values(AddressSet storage set) internal view returns (address[] memory) {
302         bytes32[] memory store = _values(set._inner);
303         address[] memory result;
304 
305         /// @solidity memory-safe-assembly
306         assembly {
307             result := store
308         }
309 
310         return result;
311     }
312 
313     // UintSet
314 
315     struct UintSet {
316         Set _inner;
317     }
318 
319     /**
320      * @dev Add a value to a set. O(1).
321      *
322      * Returns true if the value was added to the set, that is if it was not
323      * already present.
324      */
325     function add(UintSet storage set, uint256 value) internal returns (bool) {
326         return _add(set._inner, bytes32(value));
327     }
328 
329     /**
330      * @dev Removes a value from a set. O(1).
331      *
332      * Returns true if the value was removed from the set, that is if it was
333      * present.
334      */
335     function remove(UintSet storage set, uint256 value) internal returns (bool) {
336         return _remove(set._inner, bytes32(value));
337     }
338 
339     /**
340      * @dev Returns true if the value is in the set. O(1).
341      */
342     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
343         return _contains(set._inner, bytes32(value));
344     }
345 
346     /**
347      * @dev Returns the number of values in the set. O(1).
348      */
349     function length(UintSet storage set) internal view returns (uint256) {
350         return _length(set._inner);
351     }
352 
353     /**
354      * @dev Returns the value stored at position `index` in the set. O(1).
355      *
356      * Note that there are no guarantees on the ordering of values inside the
357      * array, and it may change when more values are added or removed.
358      *
359      * Requirements:
360      *
361      * - `index` must be strictly less than {length}.
362      */
363     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
364         return uint256(_at(set._inner, index));
365     }
366 
367     /**
368      * @dev Return the entire set in an array
369      *
370      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
371      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
372      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
373      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
374      */
375     function values(UintSet storage set) internal view returns (uint256[] memory) {
376         bytes32[] memory store = _values(set._inner);
377         uint256[] memory result;
378 
379         /// @solidity memory-safe-assembly
380         assembly {
381             result := store
382         }
383 
384         return result;
385     }
386 }
387 
388 interface IOperatorFilterRegistry {
389     function isOperatorAllowed(address registrant, address operator) external returns (bool);
390     function register(address registrant) external;
391     function registerAndSubscribe(address registrant, address subscription) external;
392     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
393     function updateOperator(address registrant, address operator, bool filtered) external;
394     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
395     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
396     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
397     function subscribe(address registrant, address registrantToSubscribe) external;
398     function unsubscribe(address registrant, bool copyExistingEntries) external;
399     function subscriptionOf(address addr) external returns (address registrant);
400     function subscribers(address registrant) external returns (address[] memory);
401     function subscriberAt(address registrant, uint256 index) external returns (address);
402     function copyEntriesOf(address registrant, address registrantToCopy) external;
403     function isOperatorFiltered(address registrant, address operator) external returns (bool);
404     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
405     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
406     function filteredOperators(address addr) external returns (address[] memory);
407     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
408     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
409     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
410     function isRegistered(address addr) external returns (bool);
411     function codeHashOf(address addr) external returns (bytes32);
412 }
413 
414 interface IERC721A {
415     /**
416      * The caller must own the token or be an approved operator.
417      */
418     error ApprovalCallerNotOwnerNorApproved();
419 
420     /**
421      * The token does not exist.
422      */
423     error ApprovalQueryForNonexistentToken();
424 
425     /**
426      * Cannot query the balance for the zero address.
427      */
428     error BalanceQueryForZeroAddress();
429 
430     /**
431      * Cannot mint to the zero address.
432      */
433     error MintToZeroAddress();
434 
435     /**
436      * The quantity of tokens minted must be more than zero.
437      */
438     error MintZeroQuantity();
439 
440     /**
441      * The token does not exist.
442      */
443     error OwnerQueryForNonexistentToken();
444 
445     /**
446      * The caller must own the token or be an approved operator.
447      */
448     error TransferCallerNotOwnerNorApproved();
449 
450     /**
451      * The token must be owned by `from`.
452      */
453     error TransferFromIncorrectOwner();
454 
455     /**
456      * Cannot safely transfer to a contract that does not implement the
457      * ERC721Receiver interface.
458      */
459     error TransferToNonERC721ReceiverImplementer();
460 
461     /**
462      * Cannot transfer to the zero address.
463      */
464     error TransferToZeroAddress();
465 
466     /**
467      * The token does not exist.
468      */
469     error URIQueryForNonexistentToken();
470 
471     /**
472      * The `quantity` minted with ERC2309 exceeds the safety limit.
473      */
474     error MintERC2309QuantityExceedsLimit();
475 
476     /**
477      * The `extraData` cannot be set on an unintialized ownership slot.
478      */
479     error OwnershipNotInitializedForExtraData();
480 
481     // =============================================================
482     //                            STRUCTS
483     // =============================================================
484 
485     struct TokenOwnership {
486         // The address of the owner.
487         address addr;
488         // Stores the start time of ownership with minimal overhead for tokenomics.
489         uint64 startTimestamp;
490         // Whether the token has been burned.
491         bool burned;
492         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
493         uint24 extraData;
494     }
495 
496     // =============================================================
497     //                         TOKEN COUNTERS
498     // =============================================================
499 
500     /**
501      * @dev Returns the total number of tokens in existence.
502      * Burned tokens will reduce the count.
503      * To get the total number of tokens minted, please see {_totalMinted}.
504      */
505     function totalSupply() external view returns (uint256);
506 
507     // =============================================================
508     //                            IERC165
509     // =============================================================
510 
511     /**
512      * @dev Returns true if this contract implements the interface defined by
513      * `interfaceId`. See the corresponding
514      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
515      * to learn more about how these ids are created.
516      *
517      * This function call must use less than 30000 gas.
518      */
519     function supportsInterface(bytes4 interfaceId) external view returns (bool);
520 
521     // =============================================================
522     //                            IERC721
523     // =============================================================
524 
525     /**
526      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
527      */
528     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
529 
530     /**
531      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
532      */
533     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
534 
535     /**
536      * @dev Emitted when `owner` enables or disables
537      * (`approved`) `operator` to manage all of its assets.
538      */
539     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
540 
541     /**
542      * @dev Returns the number of tokens in `owner`'s account.
543      */
544     function balanceOf(address owner) external view returns (uint256 balance);
545 
546     /**
547      * @dev Returns the owner of the `tokenId` token.
548      *
549      * Requirements:
550      *
551      * - `tokenId` must exist.
552      */
553     function ownerOf(uint256 tokenId) external view returns (address owner);
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`,
557      * checking first that contract recipients are aware of the ERC721 protocol
558      * to prevent tokens from being forever locked.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must be have been allowed to move
566      * this token by either {approve} or {setApprovalForAll}.
567      * - If `to` refers to a smart contract, it must implement
568      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId,
576         bytes calldata data
577     ) external payable;
578 
579     /**
580      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external payable;
587 
588     /**
589      * @dev Transfers `tokenId` from `from` to `to`.
590      *
591      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
592      * whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token
600      * by either {approve} or {setApprovalForAll}.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transferFrom(
605         address from,
606         address to,
607         uint256 tokenId
608     ) external payable;
609 
610     /**
611      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
612      * The approval is cleared when the token is transferred.
613      *
614      * Only a single account can be approved at a time, so approving the
615      * zero address clears previous approvals.
616      *
617      * Requirements:
618      *
619      * - The caller must own the token or be an approved operator.
620      * - `tokenId` must exist.
621      *
622      * Emits an {Approval} event.
623      */
624     function approve(address to, uint256 tokenId) external payable;
625 
626     /**
627      * @dev Approve or remove `operator` as an operator for the caller.
628      * Operators can call {transferFrom} or {safeTransferFrom}
629      * for any token owned by the caller.
630      *
631      * Requirements:
632      *
633      * - The `operator` cannot be the caller.
634      *
635      * Emits an {ApprovalForAll} event.
636      */
637     function setApprovalForAll(address operator, bool _approved) external;
638 
639     /**
640      * @dev Returns the account approved for `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function getApproved(uint256 tokenId) external view returns (address operator);
647 
648     /**
649      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
650      *
651      * See {setApprovalForAll}.
652      */
653     function isApprovedForAll(address owner, address operator) external view returns (bool);
654 
655     // =============================================================
656     //                        IERC721Metadata
657     // =============================================================
658 
659     /**
660      * @dev Returns the token collection name.
661      */
662     function name() external view returns (string memory);
663 
664     /**
665      * @dev Returns the token collection symbol.
666      */
667     function symbol() external view returns (string memory);
668 
669     /**
670      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
671      */
672     function tokenURI(uint256 tokenId) external view returns (string memory);
673 
674     // =============================================================
675     //                           IERC2309
676     // =============================================================
677 
678     /**
679      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
680      * (inclusive) is transferred from `from` to `to`, as defined in the
681      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
682      *
683      * See {_mintERC2309} for more details.
684      */
685     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
686 }
687 
688 contract Context {
689     function _msgSender() internal view virtual returns (address) {
690         return msg.sender;
691     }
692 
693     function _msgData() internal view virtual returns (bytes calldata) {
694         return msg.data;
695     }
696 }
697 
698 contract Ownable is Context {
699     address private _owner;
700 
701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
702 
703     /**
704      * @dev Initializes the contract setting the deployer as the initial owner.
705      */
706     constructor() {
707         _transferOwnership(_msgSender());
708     }
709 
710     /**
711      * @dev Throws if called by any account other than the owner.
712      */
713     modifier onlyOwner() {
714         _checkOwner();
715         _;
716     }
717 
718     /**
719      * @dev Returns the address of the current owner.
720      */
721     function owner() public view virtual returns (address) {
722         return _owner;
723     }
724 
725     /**
726      * @dev Throws if the sender is not the owner.
727      */
728     function _checkOwner() internal view virtual {
729         require(owner() == _msgSender(), "Ownable: caller is not the owner");
730     }
731 
732     /**
733      * @dev Leaves the contract without owner. It will not be possible to call
734      * `onlyOwner` functions anymore. Can only be called by the current owner.
735      *
736      * NOTE: Renouncing ownership will leave the contract without an owner,
737      * thereby removing any functionality that is only available to the owner.
738      */
739     function renounceOwnership() public virtual onlyOwner {
740         _transferOwnership(address(0));
741     }
742 
743     /**
744      * @dev Transfers ownership of the contract to a new account (`newOwner`).
745      * Can only be called by the current owner.
746      */
747     function transferOwnership(address newOwner) public virtual onlyOwner {
748         require(newOwner != address(0), "Ownable: new owner is the zero address");
749         _transferOwnership(newOwner);
750     }
751 
752     /**
753      * @dev Transfers ownership of the contract to a new account (`newOwner`).
754      * Internal function without access restriction.
755      */
756     function _transferOwnership(address newOwner) internal virtual {
757         address oldOwner = _owner;
758         _owner = newOwner;
759         emit OwnershipTransferred(oldOwner, newOwner);
760     }
761 }
762 
763 interface ERC721A__IERC721Receiver {
764     function onERC721Received(
765         address operator,
766         address from,
767         uint256 tokenId,
768         bytes calldata data
769     ) external returns (bytes4);
770 }
771 
772 contract ERC721A is IERC721A {
773     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
774     struct TokenApprovalRef {
775         address value;
776     }
777 
778     // =============================================================
779     //                           CONSTANTS
780     // =============================================================
781 
782     // Mask of an entry in packed address data.
783     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
784 
785     // The bit position of `numberMinted` in packed address data.
786     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
787 
788     // The bit position of `numberBurned` in packed address data.
789     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
790 
791     // The bit position of `aux` in packed address data.
792     uint256 private constant _BITPOS_AUX = 192;
793 
794     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
795     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
796 
797     // The bit position of `startTimestamp` in packed ownership.
798     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
799 
800     // The bit mask of the `burned` bit in packed ownership.
801     uint256 private constant _BITMASK_BURNED = 1 << 224;
802 
803     // The bit position of the `nextInitialized` bit in packed ownership.
804     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
805 
806     // The bit mask of the `nextInitialized` bit in packed ownership.
807     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
808 
809     // The bit position of `extraData` in packed ownership.
810     uint256 private constant _BITPOS_EXTRA_DATA = 232;
811 
812     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
813     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
814 
815     // The mask of the lower 160 bits for addresses.
816     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
817 
818     // The maximum `quantity` that can be minted with {_mintERC2309}.
819     // This limit is to prevent overflows on the address data entries.
820     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
821     // is required to cause an overflow, which is unrealistic.
822     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
823 
824     // The `Transfer` event signature is given by:
825     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
826     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
827         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
828 
829     // =============================================================
830     //                            STORAGE
831     // =============================================================
832 
833     // The next token ID to be minted.
834     uint256 private _currentIndex;
835 
836     // The number of tokens burned.
837     uint256 private _burnCounter;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to ownership details
846     // An empty struct value does not necessarily mean the token is unowned.
847     // See {_packedOwnershipOf} implementation for details.
848     //
849     // Bits Layout:
850     // - [0..159]   `addr`
851     // - [160..223] `startTimestamp`
852     // - [224]      `burned`
853     // - [225]      `nextInitialized`
854     // - [232..255] `extraData`
855     mapping(uint256 => uint256) private _packedOwnerships;
856 
857     // Mapping owner address to address data.
858     //
859     // Bits Layout:
860     // - [0..63]    `balance`
861     // - [64..127]  `numberMinted`
862     // - [128..191] `numberBurned`
863     // - [192..255] `aux`
864     mapping(address => uint256) private _packedAddressData;
865 
866     // Mapping from token ID to approved address.
867     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
868 
869     // Mapping from owner to operator approvals
870     mapping(address => mapping(address => bool)) private _operatorApprovals;
871 
872     // =============================================================
873     //                          CONSTRUCTOR
874     // =============================================================
875 
876     constructor(string memory name_, string memory symbol_) {
877         _name = name_;
878         _symbol = symbol_;
879         _currentIndex = _startTokenId();
880     }
881 
882     // =============================================================
883     //                   TOKEN COUNTING OPERATIONS
884     // =============================================================
885 
886     /**
887      * @dev Returns the starting token ID.
888      * To change the starting token ID, please override this function.
889      */
890     function _startTokenId() internal view virtual returns (uint256) {
891         return 1;
892     }
893 
894     /**
895      * @dev Returns the next token ID to be minted.
896      */
897     function _nextTokenId() internal view virtual returns (uint256) {
898         return _currentIndex;
899     }
900 
901     /**
902      * @dev Returns the total number of tokens in existence.
903      * Burned tokens will reduce the count.
904      * To get the total number of tokens minted, please see {_totalMinted}.
905      */
906     function totalSupply() public view virtual override returns (uint256) {
907         // Counter underflow is impossible as _burnCounter cannot be incremented
908         // more than `_currentIndex - _startTokenId()` times.
909         unchecked {
910             return _currentIndex - _burnCounter - _startTokenId();
911         }
912     }
913 
914     /**
915      * @dev Returns the total amount of tokens minted in the contract.
916      */
917     function _totalMinted() internal view virtual returns (uint256) {
918         // Counter underflow is impossible as `_currentIndex` does not decrement,
919         // and it is initialized to `_startTokenId()`.
920         unchecked {
921             return _currentIndex - _startTokenId();
922         }
923     }
924 
925     /**
926      * @dev Returns the total number of tokens burned.
927      */
928     function _totalBurned() internal view virtual returns (uint256) {
929         return _burnCounter;
930     }
931 
932     // =============================================================
933     //                    ADDRESS DATA OPERATIONS
934     // =============================================================
935 
936     /**
937      * @dev Returns the number of tokens in `owner`'s account.
938      */
939     function balanceOf(address owner) public view virtual override returns (uint256) {
940         if (owner == address(0)) revert BalanceQueryForZeroAddress();
941         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
942     }
943 
944     /**
945      * Returns the number of tokens minted by `owner`.
946      */
947     function _numberMinted(address owner) internal view returns (uint256) {
948         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
949     }
950 
951     /**
952      * Returns the number of tokens burned by or on behalf of `owner`.
953      */
954     function _numberBurned(address owner) internal view returns (uint256) {
955         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
956     }
957 
958     /**
959      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
960      */
961     function _getAux(address owner) internal view returns (uint64) {
962         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
963     }
964 
965     /**
966      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
967      * If there are multiple variables, please pack them into a uint64.
968      */
969     function _setAux(address owner, uint64 aux) internal virtual {
970         uint256 packed = _packedAddressData[owner];
971         uint256 auxCasted;
972         // Cast `aux` with assembly to avoid redundant masking.
973         assembly {
974             auxCasted := aux
975         }
976         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
977         _packedAddressData[owner] = packed;
978     }
979 
980     // =============================================================
981     //                            IERC165
982     // =============================================================
983 
984     /**
985      * @dev Returns true if this contract implements the interface defined by
986      * `interfaceId`. See the corresponding
987      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
988      * to learn more about how these ids are created.
989      *
990      * This function call must use less than 30000 gas.
991      */
992     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
993         // The interface IDs are constants representing the first 4 bytes
994         // of the XOR of all function selectors in the interface.
995         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
996         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
997         return
998             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
999             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1000             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1001     }
1002 
1003     // =============================================================
1004     //                        IERC721Metadata
1005     // =============================================================
1006 
1007     /**
1008      * @dev Returns the token collection name.
1009      */
1010     function name() public view virtual override returns (string memory) {
1011         return _name;
1012     }
1013 
1014     /**
1015      * @dev Returns the token collection symbol.
1016      */
1017     function symbol() public view virtual override returns (string memory) {
1018         return _symbol;
1019     }
1020 
1021     /**
1022      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1023      */
1024     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1025         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1026 
1027         string memory baseURI = _baseURI();
1028         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1029     }
1030 
1031     /**
1032      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1033      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1034      * by default, it can be overridden in child contracts.
1035      */
1036     function _baseURI() internal view virtual returns (string memory) {
1037         return '';
1038     }
1039 
1040     // =============================================================
1041     //                     OWNERSHIPS OPERATIONS
1042     // =============================================================
1043 
1044     /**
1045      * @dev Returns the owner of the `tokenId` token.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      */
1051     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1052         return address(uint160(_packedOwnershipOf(tokenId)));
1053     }
1054 
1055     /**
1056      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1057      * It gradually moves to O(1) as tokens get transferred around over time.
1058      */
1059     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1060         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1061     }
1062 
1063     /**
1064      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1065      */
1066     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1067         return _unpackedOwnership(_packedOwnerships[index]);
1068     }
1069 
1070     /**
1071      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1072      */
1073     function _initializeOwnershipAt(uint256 index) internal virtual {
1074         if (_packedOwnerships[index] == 0) {
1075             _packedOwnerships[index] = _packedOwnershipOf(index);
1076         }
1077     }
1078 
1079     /**
1080      * Returns the packed ownership data of `tokenId`.
1081      */
1082     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1083         uint256 curr = tokenId;
1084 
1085         unchecked {
1086             if (_startTokenId() <= curr)
1087                 if (curr < _currentIndex) {
1088                     uint256 packed = _packedOwnerships[curr];
1089                     // If not burned.
1090                     if (packed & _BITMASK_BURNED == 0) {
1091                         // Invariant:
1092                         // There will always be an initialized ownership slot
1093                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1094                         // before an unintialized ownership slot
1095                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1096                         // Hence, `curr` will not underflow.
1097                         //
1098                         // We can directly compare the packed value.
1099                         // If the address is zero, packed will be zero.
1100                         while (packed == 0) {
1101                             packed = _packedOwnerships[--curr];
1102                         }
1103                         return packed;
1104                     }
1105                 }
1106         }
1107         revert OwnerQueryForNonexistentToken();
1108     }
1109 
1110     /**
1111      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1112      */
1113     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1114         ownership.addr = address(uint160(packed));
1115         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1116         ownership.burned = packed & _BITMASK_BURNED != 0;
1117         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1118     }
1119 
1120     /**
1121      * @dev Packs ownership data into a single uint256.
1122      */
1123     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1124         assembly {
1125             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1126             owner := and(owner, _BITMASK_ADDRESS)
1127             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1128             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1129         }
1130     }
1131 
1132     /**
1133      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1134      */
1135     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1136         // For branchless setting of the `nextInitialized` flag.
1137         assembly {
1138             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1139             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1140         }
1141     }
1142 
1143     // =============================================================
1144     //                      APPROVAL OPERATIONS
1145     // =============================================================
1146 
1147     /**
1148      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1149      * The approval is cleared when the token is transferred.
1150      *
1151      * Only a single account can be approved at a time, so approving the
1152      * zero address clears previous approvals.
1153      *
1154      * Requirements:
1155      *
1156      * - The caller must own the token or be an approved operator.
1157      * - `tokenId` must exist.
1158      *
1159      * Emits an {Approval} event.
1160      */
1161     function approve(address to, uint256 tokenId) public payable virtual override {
1162         address owner = ownerOf(tokenId);
1163 
1164         if (_msgSenderERC721A() != owner)
1165             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1166                 revert ApprovalCallerNotOwnerNorApproved();
1167             }
1168 
1169         _tokenApprovals[tokenId].value = to;
1170         emit Approval(owner, to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev Returns the account approved for `tokenId` token.
1175      *
1176      * Requirements:
1177      *
1178      * - `tokenId` must exist.
1179      */
1180     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1181         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1182 
1183         return _tokenApprovals[tokenId].value;
1184     }
1185 
1186     /**
1187      * @dev Approve or remove `operator` as an operator for the caller.
1188      * Operators can call {transferFrom} or {safeTransferFrom}
1189      * for any token owned by the caller.
1190      *
1191      * Requirements:
1192      *
1193      * - The `operator` cannot be the caller.
1194      *
1195      * Emits an {ApprovalForAll} event.
1196      */
1197     function setApprovalForAll(address operator, bool approved) public virtual override {
1198         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1199         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1200     }
1201 
1202     /**
1203      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1204      *
1205      * See {setApprovalForAll}.
1206      */
1207     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1208         return _operatorApprovals[owner][operator];
1209     }
1210 
1211     /**
1212      * @dev Returns whether `tokenId` exists.
1213      *
1214      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1215      *
1216      * Tokens start existing when they are minted. See {_mint}.
1217      */
1218     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1219         return
1220             _startTokenId() <= tokenId &&
1221             tokenId < _currentIndex && // If within bounds,
1222             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1223     }
1224 
1225     /**
1226      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1227      */
1228     function _isSenderApprovedOrOwner(
1229         address approvedAddress,
1230         address owner,
1231         address msgSender
1232     ) private pure returns (bool result) {
1233         assembly {
1234             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1235             owner := and(owner, _BITMASK_ADDRESS)
1236             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1237             msgSender := and(msgSender, _BITMASK_ADDRESS)
1238             // `msgSender == owner || msgSender == approvedAddress`.
1239             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1240         }
1241     }
1242 
1243     /**
1244      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1245      */
1246     function _getApprovedSlotAndAddress(uint256 tokenId)
1247         private
1248         view
1249         returns (uint256 approvedAddressSlot, address approvedAddress)
1250     {
1251         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1252         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1253         assembly {
1254             approvedAddressSlot := tokenApproval.slot
1255             approvedAddress := sload(approvedAddressSlot)
1256         }
1257     }
1258 
1259     // =============================================================
1260     //                      TRANSFER OPERATIONS
1261     // =============================================================
1262 
1263     /**
1264      * @dev Transfers `tokenId` from `from` to `to`.
1265      *
1266      * Requirements:
1267      *
1268      * - `from` cannot be the zero address.
1269      * - `to` cannot be the zero address.
1270      * - `tokenId` token must be owned by `from`.
1271      * - If the caller is not `from`, it must be approved to move this token
1272      * by either {approve} or {setApprovalForAll}.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function transferFrom(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) public payable virtual override {
1281         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1282 
1283         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1284 
1285         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1286 
1287         // The nested ifs save around 20+ gas over a compound boolean condition.
1288         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1289             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1290 
1291         if (to == address(0)) revert TransferToZeroAddress();
1292 
1293         _beforeTokenTransfers(from, to, tokenId, 1);
1294 
1295         // Clear approvals from the previous owner.
1296         assembly {
1297             if approvedAddress {
1298                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1299                 sstore(approvedAddressSlot, 0)
1300             }
1301         }
1302 
1303         // Underflow of the sender's balance is impossible because we check for
1304         // ownership above and the recipient's balance can't realistically overflow.
1305         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1306         unchecked {
1307             // We can directly increment and decrement the balances.
1308             --_packedAddressData[from]; // Updates: `balance -= 1`.
1309             ++_packedAddressData[to]; // Updates: `balance += 1`.
1310 
1311             // Updates:
1312             // - `address` to the next owner.
1313             // - `startTimestamp` to the timestamp of transfering.
1314             // - `burned` to `false`.
1315             // - `nextInitialized` to `true`.
1316             _packedOwnerships[tokenId] = _packOwnershipData(
1317                 to,
1318                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1319             );
1320 
1321             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1322             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1323                 uint256 nextTokenId = tokenId + 1;
1324                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1325                 if (_packedOwnerships[nextTokenId] == 0) {
1326                     // If the next slot is within bounds.
1327                     if (nextTokenId != _currentIndex) {
1328                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1329                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1330                     }
1331                 }
1332             }
1333         }
1334 
1335         emit Transfer(from, to, tokenId);
1336         _afterTokenTransfers(from, to, tokenId, 1);
1337     }
1338 
1339     /**
1340      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1341      */
1342     function safeTransferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) public payable virtual override {
1347         safeTransferFrom(from, to, tokenId, '');
1348     }
1349 
1350     /**
1351      * @dev Safely transfers `tokenId` token from `from` to `to`.
1352      *
1353      * Requirements:
1354      *
1355      * - `from` cannot be the zero address.
1356      * - `to` cannot be the zero address.
1357      * - `tokenId` token must exist and be owned by `from`.
1358      * - If the caller is not `from`, it must be approved to move this token
1359      * by either {approve} or {setApprovalForAll}.
1360      * - If `to` refers to a smart contract, it must implement
1361      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function safeTransferFrom(
1366         address from,
1367         address to,
1368         uint256 tokenId,
1369         bytes memory _data
1370     ) public payable virtual override {
1371         transferFrom(from, to, tokenId);
1372         if (to.code.length != 0)
1373             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1374                 revert TransferToNonERC721ReceiverImplementer();
1375             }
1376     }
1377 
1378     /**
1379      * @dev Hook that is called before a set of serially-ordered token IDs
1380      * are about to be transferred. This includes minting.
1381      * And also called before burning one token.
1382      *
1383      * `startTokenId` - the first token ID to be transferred.
1384      * `quantity` - the amount to be transferred.
1385      *
1386      * Calling conditions:
1387      *
1388      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1389      * transferred to `to`.
1390      * - When `from` is zero, `tokenId` will be minted for `to`.
1391      * - When `to` is zero, `tokenId` will be burned by `from`.
1392      * - `from` and `to` are never both zero.
1393      */
1394     function _beforeTokenTransfers(
1395         address from,
1396         address to,
1397         uint256 startTokenId,
1398         uint256 quantity
1399     ) internal virtual {}
1400 
1401     /**
1402      * @dev Hook that is called after a set of serially-ordered token IDs
1403      * have been transferred. This includes minting.
1404      * And also called after one token has been burned.
1405      *
1406      * `startTokenId` - the first token ID to be transferred.
1407      * `quantity` - the amount to be transferred.
1408      *
1409      * Calling conditions:
1410      *
1411      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1412      * transferred to `to`.
1413      * - When `from` is zero, `tokenId` has been minted for `to`.
1414      * - When `to` is zero, `tokenId` has been burned by `from`.
1415      * - `from` and `to` are never both zero.
1416      */
1417     function _afterTokenTransfers(
1418         address from,
1419         address to,
1420         uint256 startTokenId,
1421         uint256 quantity
1422     ) internal virtual {}
1423 
1424     /**
1425      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1426      *
1427      * `from` - Previous owner of the given token ID.
1428      * `to` - Target address that will receive the token.
1429      * `tokenId` - Token ID to be transferred.
1430      * `_data` - Optional data to send along with the call.
1431      *
1432      * Returns whether the call correctly returned the expected magic value.
1433      */
1434     function _checkContractOnERC721Received(
1435         address from,
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) private returns (bool) {
1440         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1441             bytes4 retval
1442         ) {
1443             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1444         } catch (bytes memory reason) {
1445             if (reason.length == 0) {
1446                 revert TransferToNonERC721ReceiverImplementer();
1447             } else {
1448                 assembly {
1449                     revert(add(32, reason), mload(reason))
1450                 }
1451             }
1452         }
1453     }
1454 
1455     // =============================================================
1456     //                        MINT OPERATIONS
1457     // =============================================================
1458 
1459     /**
1460      * @dev Mints `quantity` tokens and transfers them to `to`.
1461      *
1462      * Requirements:
1463      *
1464      * - `to` cannot be the zero address.
1465      * - `quantity` must be greater than 0.
1466      *
1467      * Emits a {Transfer} event for each mint.
1468      */
1469     function _mint(address to, uint256 quantity) internal virtual {
1470         uint256 startTokenId = _currentIndex;
1471         if (quantity == 0) revert MintZeroQuantity();
1472 
1473         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1474 
1475         // Overflows are incredibly unrealistic.
1476         // `balance` and `numberMinted` have a maximum limit of 2**64.
1477         // `tokenId` has a maximum limit of 2**256.
1478         unchecked {
1479             // Updates:
1480             // - `balance += quantity`.
1481             // - `numberMinted += quantity`.
1482             //
1483             // We can directly add to the `balance` and `numberMinted`.
1484             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1485 
1486             // Updates:
1487             // - `address` to the owner.
1488             // - `startTimestamp` to the timestamp of minting.
1489             // - `burned` to `false`.
1490             // - `nextInitialized` to `quantity == 1`.
1491             _packedOwnerships[startTokenId] = _packOwnershipData(
1492                 to,
1493                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1494             );
1495 
1496             uint256 toMasked;
1497             uint256 end = startTokenId + quantity;
1498 
1499             // Use assembly to loop and emit the `Transfer` event for gas savings.
1500             // The duplicated `log4` removes an extra check and reduces stack juggling.
1501             // The assembly, together with the surrounding Solidity code, have been
1502             // delicately arranged to nudge the compiler into producing optimized opcodes.
1503             assembly {
1504                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1505                 toMasked := and(to, _BITMASK_ADDRESS)
1506                 // Emit the `Transfer` event.
1507                 log4(
1508                     0, // Start of data (0, since no data).
1509                     0, // End of data (0, since no data).
1510                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1511                     0, // `address(0)`.
1512                     toMasked, // `to`.
1513                     startTokenId // `tokenId`.
1514                 )
1515 
1516                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1517                 // that overflows uint256 will make the loop run out of gas.
1518                 // The compiler will optimize the `iszero` away for performance.
1519                 for {
1520                     let tokenId := add(startTokenId, 1)
1521                 } iszero(eq(tokenId, end)) {
1522                     tokenId := add(tokenId, 1)
1523                 } {
1524                     // Emit the `Transfer` event. Similar to above.
1525                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1526                 }
1527             }
1528             if (toMasked == 0) revert MintToZeroAddress();
1529 
1530             _currentIndex = end;
1531         }
1532         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1533     }
1534 
1535     /**
1536      * @dev Mints `quantity` tokens and transfers them to `to`.
1537      *
1538      * This function is intended for efficient minting only during contract creation.
1539      *
1540      * It emits only one {ConsecutiveTransfer} as defined in
1541      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1542      * instead of a sequence of {Transfer} event(s).
1543      *
1544      * Calling this function outside of contract creation WILL make your contract
1545      * non-compliant with the ERC721 standard.
1546      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1547      * {ConsecutiveTransfer} event is only permissible during contract creation.
1548      *
1549      * Requirements:
1550      *
1551      * - `to` cannot be the zero address.
1552      * - `quantity` must be greater than 0.
1553      *
1554      * Emits a {ConsecutiveTransfer} event.
1555      */
1556     function _mintERC2309(address to, uint256 quantity) internal virtual {
1557         uint256 startTokenId = _currentIndex;
1558         if (to == address(0)) revert MintToZeroAddress();
1559         if (quantity == 0) revert MintZeroQuantity();
1560         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1561 
1562         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1563 
1564         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1565         unchecked {
1566             // Updates:
1567             // - `balance += quantity`.
1568             // - `numberMinted += quantity`.
1569             //
1570             // We can directly add to the `balance` and `numberMinted`.
1571             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1572 
1573             // Updates:
1574             // - `address` to the owner.
1575             // - `startTimestamp` to the timestamp of minting.
1576             // - `burned` to `false`.
1577             // - `nextInitialized` to `quantity == 1`.
1578             _packedOwnerships[startTokenId] = _packOwnershipData(
1579                 to,
1580                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1581             );
1582 
1583             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1584 
1585             _currentIndex = startTokenId + quantity;
1586         }
1587         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1588     }
1589 
1590     /**
1591      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1592      *
1593      * Requirements:
1594      *
1595      * - If `to` refers to a smart contract, it must implement
1596      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1597      * - `quantity` must be greater than 0.
1598      *
1599      * See {_mint}.
1600      *
1601      * Emits a {Transfer} event for each mint.
1602      */
1603     function _safeMint(
1604         address to,
1605         uint256 quantity,
1606         bytes memory _data
1607     ) internal virtual {
1608         _mint(to, quantity);
1609 
1610         unchecked {
1611             if (to.code.length != 0) {
1612                 uint256 end = _currentIndex;
1613                 uint256 index = end - quantity;
1614                 do {
1615                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1616                         revert TransferToNonERC721ReceiverImplementer();
1617                     }
1618                 } while (index < end);
1619                 // Reentrancy protection.
1620                 if (_currentIndex != end) revert();
1621             }
1622         }
1623     }
1624 
1625     /**
1626      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1627      */
1628     function _safeMint(address to, uint256 quantity) internal virtual {
1629         _safeMint(to, quantity, '');
1630     }
1631 
1632     // =============================================================
1633     //                        BURN OPERATIONS
1634     // =============================================================
1635 
1636     /**
1637      * @dev Equivalent to `_burn(tokenId, false)`.
1638      */
1639     function _burn(uint256 tokenId) internal virtual {
1640         _burn(tokenId, false);
1641     }
1642 
1643     /**
1644      * @dev Destroys `tokenId`.
1645      * The approval is cleared when the token is burned.
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must exist.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1654         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1655 
1656         address from = address(uint160(prevOwnershipPacked));
1657 
1658         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1659 
1660         if (approvalCheck) {
1661             // The nested ifs save around 20+ gas over a compound boolean condition.
1662             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1663                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1664         }
1665 
1666         _beforeTokenTransfers(from, address(0), tokenId, 1);
1667 
1668         // Clear approvals from the previous owner.
1669         assembly {
1670             if approvedAddress {
1671                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1672                 sstore(approvedAddressSlot, 0)
1673             }
1674         }
1675 
1676         // Underflow of the sender's balance is impossible because we check for
1677         // ownership above and the recipient's balance can't realistically overflow.
1678         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1679         unchecked {
1680             // Updates:
1681             // - `balance -= 1`.
1682             // - `numberBurned += 1`.
1683             //
1684             // We can directly decrement the balance, and increment the number burned.
1685             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1686             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1687 
1688             // Updates:
1689             // - `address` to the last owner.
1690             // - `startTimestamp` to the timestamp of burning.
1691             // - `burned` to `true`.
1692             // - `nextInitialized` to `true`.
1693             _packedOwnerships[tokenId] = _packOwnershipData(
1694                 from,
1695                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1696             );
1697 
1698             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1699             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1700                 uint256 nextTokenId = tokenId + 1;
1701                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1702                 if (_packedOwnerships[nextTokenId] == 0) {
1703                     // If the next slot is within bounds.
1704                     if (nextTokenId != _currentIndex) {
1705                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1706                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1707                     }
1708                 }
1709             }
1710         }
1711 
1712         emit Transfer(from, address(0), tokenId);
1713         _afterTokenTransfers(from, address(0), tokenId, 1);
1714 
1715         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1716         unchecked {
1717             _burnCounter++;
1718         }
1719     }
1720 
1721     // =============================================================
1722     //                     EXTRA DATA OPERATIONS
1723     // =============================================================
1724 
1725     /**
1726      * @dev Directly sets the extra data for the ownership data `index`.
1727      */
1728     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1729         uint256 packed = _packedOwnerships[index];
1730         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1731         uint256 extraDataCasted;
1732         // Cast `extraData` with assembly to avoid redundant masking.
1733         assembly {
1734             extraDataCasted := extraData
1735         }
1736         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1737         _packedOwnerships[index] = packed;
1738     }
1739 
1740     /**
1741      * @dev Called during each token transfer to set the 24bit `extraData` field.
1742      * Intended to be overridden by the cosumer contract.
1743      *
1744      * `previousExtraData` - the value of `extraData` before transfer.
1745      *
1746      * Calling conditions:
1747      *
1748      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1749      * transferred to `to`.
1750      * - When `from` is zero, `tokenId` will be minted for `to`.
1751      * - When `to` is zero, `tokenId` will be burned by `from`.
1752      * - `from` and `to` are never both zero.
1753      */
1754     function _extraData(
1755         address from,
1756         address to,
1757         uint24 previousExtraData
1758     ) internal view virtual returns (uint24) {}
1759 
1760     /**
1761      * @dev Returns the next extra data for the packed ownership data.
1762      * The returned result is shifted into position.
1763      */
1764     function _nextExtraData(
1765         address from,
1766         address to,
1767         uint256 prevOwnershipPacked
1768     ) private view returns (uint256) {
1769         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1770         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1771     }
1772 
1773     // =============================================================
1774     //                       OTHER OPERATIONS
1775     // =============================================================
1776 
1777     /**
1778      * @dev Returns the message sender (defaults to `msg.sender`).
1779      *
1780      * If you are writing GSN compatible contracts, you need to override this function.
1781      */
1782     function _msgSenderERC721A() internal view virtual returns (address) {
1783         return msg.sender;
1784     }
1785 
1786     /**
1787      * @dev Converts a uint256 to its ASCII string decimal representation.
1788      */
1789     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1790         assembly {
1791             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1792             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1793             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1794             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1795             let m := add(mload(0x40), 0xa0)
1796             // Update the free memory pointer to allocate.
1797             mstore(0x40, m)
1798             // Assign the `str` to the end.
1799             str := sub(m, 0x20)
1800             // Zeroize the slot after the string.
1801             mstore(str, 0)
1802 
1803             // Cache the end of the memory to calculate the length later.
1804             let end := str
1805 
1806             // We write the string from rightmost digit to leftmost digit.
1807             // The following is essentially a do-while loop that also handles the zero case.
1808             // prettier-ignore
1809             for { let temp := value } 1 {} {
1810                 str := sub(str, 1)
1811                 // Write the character to the pointer.
1812                 // The ASCII index of the '0' character is 48.
1813                 mstore8(str, add(48, mod(temp, 10)))
1814                 // Keep dividing `temp` until zero.
1815                 temp := div(temp, 10)
1816                 // prettier-ignore
1817                 if iszero(temp) { break }
1818             }
1819 
1820             let length := sub(end, str)
1821             // Move the pointer 32 bytes leftwards to make room for the length.
1822             str := sub(str, 0x20)
1823             // Store the length.
1824             mstore(str, length)
1825         }
1826     }
1827 }
1828 
1829 contract Crocamigos is ERC721A, Ownable, DefaultOperatorFilterer {
1830 
1831     enum Step {
1832         Before,
1833         Public
1834     }
1835     Step public sellingStep;
1836 
1837     string public baseURI;
1838 
1839 
1840     
1841     function mintForOwner(uint _quantity) public onlyOwner{
1842         _mint(msg.sender, _quantity);
1843     }
1844 
1845     function changeMaxWallet(uint newValue) public onlyOwner{
1846         maxWallet = newValue;
1847     }
1848 
1849     function changeMaxSupply(uint newValue) public onlyOwner{
1850         MAX_SUPPLY = newValue;
1851     }
1852 
1853     constructor(string memory _baseURI) ERC721A("Crocamigos", "Crocamigos") {
1854         baseURI = _baseURI;
1855     }
1856 
1857     mapping(address => uint) public mintedAmountNFTsperWalletPublicSale;
1858     mapping(address => uint) public freeMintAmount;
1859     uint public maxWallet = 10;
1860 
1861     uint public MAX_SUPPLY = 4321;
1862 
1863     uint public publicSalePrice = 0.001 ether;
1864 
1865     error ArrayMismatch();
1866     error SupplyExceeded();
1867     error NotEnoughPrice();
1868     error StepNotLive();
1869     error MaxWalletExceeded();
1870 
1871     function batchAirdrop(uint256[] calldata quantities, address[] calldata recipients) external onlyOwner {
1872         if(quantities.length != recipients.length) revert ArrayMismatch();
1873 
1874         uint256 length = quantities.length;
1875 
1876         for(uint256 i; i < length; i++) {
1877             _mint(recipients[i], quantities[i]);
1878         }
1879     }
1880 
1881     function freeMint() public {
1882         require(msg.sender == tx.origin);
1883         if(sellingStep != Step.Public) revert StepNotLive();
1884         if(totalSupply() + 1 > (MAX_SUPPLY)) revert SupplyExceeded();
1885         if(freeMintAmount[msg.sender] <= 0){
1886             // Free Mint !
1887             freeMintAmount[msg.sender] += 1;
1888             _mint(msg.sender, 1);
1889         } else {
1890             revert MaxWalletExceeded();
1891         }
1892     }
1893 
1894     function mint(uint _quantity) public payable {
1895         require(msg.sender == tx.origin);
1896         if(sellingStep != Step.Public) revert StepNotLive();
1897         if(mintedAmountNFTsperWalletPublicSale[msg.sender] + _quantity > maxWallet) revert MaxWalletExceeded();
1898         if(totalSupply() + _quantity > (MAX_SUPPLY)) revert SupplyExceeded();
1899         if(msg.value < publicSalePrice * _quantity) revert NotEnoughPrice();
1900         mintedAmountNFTsperWalletPublicSale[msg.sender] += _quantity;
1901         _mint(msg.sender, _quantity);
1902     }
1903 
1904     function changePrice(uint newPrice) external onlyOwner {
1905         publicSalePrice = newPrice;
1906     }
1907 
1908     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator payable {
1909         super.transferFrom(from, to, tokenId);
1910     }
1911 
1912     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator payable {
1913         super.safeTransferFrom(from, to, tokenId);
1914     }
1915 
1916     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1917         public
1918         override
1919         onlyAllowedOperator
1920         payable
1921     {
1922         super.safeTransferFrom(from, to, tokenId, data);
1923     }
1924 
1925     function setStep(uint _step) external onlyOwner {
1926         sellingStep = Step(_step);
1927     }
1928 
1929     function setBaseUri(string memory _baseURI) external onlyOwner {
1930         baseURI = _baseURI;
1931     }
1932 
1933     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1934         require(_exists(_tokenId), "URI query for nonexistent token");
1935         return string(abi.encodePacked(baseURI, _toString(_tokenId), ".json"));
1936     }
1937 
1938     function withdraw() external onlyOwner {
1939         require(payable(msg.sender).send(address(this).balance));
1940     }
1941 }