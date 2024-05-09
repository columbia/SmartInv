1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 
6 /**
7  * @dev Library for managing
8  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
9  * types.
10  *
11  * Sets have the following properties:
12  *
13  * - Elements are added, removed, and checked for existence in constant time
14  * (O(1)).
15  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
16  *
17  * ```
18  * contract Example {
19  *     // Add the library methods
20  *     using EnumerableSet for EnumerableSet.AddressSet;
21  *
22  *     // Declare a set state variable
23  *     EnumerableSet.AddressSet private mySet;
24  * }
25  * ```
26  *
27  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
28  * and `uint256` (`UintSet`) are supported.
29  *
30  * [WARNING]
31  * ====
32  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
33  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
34  *
35  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
36  * ====
37  */
38 library EnumerableSet {
39     // To implement this library for multiple types with as little code
40     // repetition as possible, we write it in terms of a generic Set type with
41     // bytes32 values.
42     // The Set implementation uses private functions, and user-facing
43     // implementations (such as AddressSet) are just wrappers around the
44     // underlying Set.
45     // This means that we can only create new EnumerableSets for types that fit
46     // in bytes32.
47 
48     struct Set {
49         // Storage of set values
50         bytes32[] _values;
51         // Position of the value in the `values` array, plus 1 because index 0
52         // means a value is not in the set.
53         mapping(bytes32 => uint256) _indexes;
54     }
55 
56     /**
57      * @dev Add a value to a set. O(1).
58      *
59      * Returns true if the value was added to the set, that is if it was not
60      * already present.
61      */
62     function _add(Set storage set, bytes32 value) private returns (bool) {
63         if (!_contains(set, value)) {
64             set._values.push(value);
65             // The value is stored at length-1, but we add 1 to all indexes
66             // and use 0 as a sentinel value
67             set._indexes[value] = set._values.length;
68             return true;
69         } else {
70             return false;
71         }
72     }
73 
74     /**
75      * @dev Removes a value from a set. O(1).
76      *
77      * Returns true if the value was removed from the set, that is if it was
78      * present.
79      */
80     function _remove(Set storage set, bytes32 value) private returns (bool) {
81         // We read and store the value's index to prevent multiple reads from the same storage slot
82         uint256 valueIndex = set._indexes[value];
83 
84         if (valueIndex != 0) {
85             // Equivalent to contains(set, value)
86             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
87             // the array, and then remove the last element (sometimes called as 'swap and pop').
88             // This modifies the order of the array, as noted in {at}.
89 
90             uint256 toDeleteIndex = valueIndex - 1;
91             uint256 lastIndex = set._values.length - 1;
92 
93             if (lastIndex != toDeleteIndex) {
94                 bytes32 lastValue = set._values[lastIndex];
95 
96                 // Move the last value to the index where the value to delete is
97                 set._values[toDeleteIndex] = lastValue;
98                 // Update the index for the moved value
99                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
100             }
101 
102             // Delete the slot where the moved value was stored
103             set._values.pop();
104 
105             // Delete the index for the deleted slot
106             delete set._indexes[value];
107 
108             return true;
109         } else {
110             return false;
111         }
112     }
113 
114     /**
115      * @dev Returns true if the value is in the set. O(1).
116      */
117     function _contains(Set storage set, bytes32 value) private view returns (bool) {
118         return set._indexes[value] != 0;
119     }
120 
121     /**
122      * @dev Returns the number of values on the set. O(1).
123      */
124     function _length(Set storage set) private view returns (uint256) {
125         return set._values.length;
126     }
127 
128     /**
129      * @dev Returns the value stored at position `index` in the set. O(1).
130      *
131      * Note that there are no guarantees on the ordering of values inside the
132      * array, and it may change when more values are added or removed.
133      *
134      * Requirements:
135      *
136      * - `index` must be strictly less than {length}.
137      */
138     function _at(Set storage set, uint256 index) private view returns (bytes32) {
139         return set._values[index];
140     }
141 
142     /**
143      * @dev Return the entire set in an array
144      *
145      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
146      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
147      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
148      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
149      */
150     function _values(Set storage set) private view returns (bytes32[] memory) {
151         return set._values;
152     }
153 
154     // Bytes32Set
155 
156     struct Bytes32Set {
157         Set _inner;
158     }
159 
160     /**
161      * @dev Add a value to a set. O(1).
162      *
163      * Returns true if the value was added to the set, that is if it was not
164      * already present.
165      */
166     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
167         return _add(set._inner, value);
168     }
169 
170     /**
171      * @dev Removes a value from a set. O(1).
172      *
173      * Returns true if the value was removed from the set, that is if it was
174      * present.
175      */
176     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
177         return _remove(set._inner, value);
178     }
179 
180     /**
181      * @dev Returns true if the value is in the set. O(1).
182      */
183     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
184         return _contains(set._inner, value);
185     }
186 
187     /**
188      * @dev Returns the number of values in the set. O(1).
189      */
190     function length(Bytes32Set storage set) internal view returns (uint256) {
191         return _length(set._inner);
192     }
193 
194     /**
195      * @dev Returns the value stored at position `index` in the set. O(1).
196      *
197      * Note that there are no guarantees on the ordering of values inside the
198      * array, and it may change when more values are added or removed.
199      *
200      * Requirements:
201      *
202      * - `index` must be strictly less than {length}.
203      */
204     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
205         return _at(set._inner, index);
206     }
207 
208     /**
209      * @dev Return the entire set in an array
210      *
211      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
212      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
213      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
214      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
215      */
216     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
217         return _values(set._inner);
218     }
219 
220     // AddressSet
221 
222     struct AddressSet {
223         Set _inner;
224     }
225 
226     /**
227      * @dev Add a value to a set. O(1).
228      *
229      * Returns true if the value was added to the set, that is if it was not
230      * already present.
231      */
232     function add(AddressSet storage set, address value) internal returns (bool) {
233         return _add(set._inner, bytes32(uint256(uint160(value))));
234     }
235 
236     /**
237      * @dev Removes a value from a set. O(1).
238      *
239      * Returns true if the value was removed from the set, that is if it was
240      * present.
241      */
242     function remove(AddressSet storage set, address value) internal returns (bool) {
243         return _remove(set._inner, bytes32(uint256(uint160(value))));
244     }
245 
246     /**
247      * @dev Returns true if the value is in the set. O(1).
248      */
249     function contains(AddressSet storage set, address value) internal view returns (bool) {
250         return _contains(set._inner, bytes32(uint256(uint160(value))));
251     }
252 
253     /**
254      * @dev Returns the number of values in the set. O(1).
255      */
256     function length(AddressSet storage set) internal view returns (uint256) {
257         return _length(set._inner);
258     }
259 
260     /**
261      * @dev Returns the value stored at position `index` in the set. O(1).
262      *
263      * Note that there are no guarantees on the ordering of values inside the
264      * array, and it may change when more values are added or removed.
265      *
266      * Requirements:
267      *
268      * - `index` must be strictly less than {length}.
269      */
270     function at(AddressSet storage set, uint256 index) internal view returns (address) {
271         return address(uint160(uint256(_at(set._inner, index))));
272     }
273 
274     /**
275      * @dev Return the entire set in an array
276      *
277      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
278      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
279      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
280      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
281      */
282     function values(AddressSet storage set) internal view returns (address[] memory) {
283         bytes32[] memory store = _values(set._inner);
284         address[] memory result;
285 
286         /// @solidity memory-safe-assembly
287         assembly {
288             result := store
289         }
290 
291         return result;
292     }
293 
294     // UintSet
295 
296     struct UintSet {
297         Set _inner;
298     }
299 
300     /**
301      * @dev Add a value to a set. O(1).
302      *
303      * Returns true if the value was added to the set, that is if it was not
304      * already present.
305      */
306     function add(UintSet storage set, uint256 value) internal returns (bool) {
307         return _add(set._inner, bytes32(value));
308     }
309 
310     /**
311      * @dev Removes a value from a set. O(1).
312      *
313      * Returns true if the value was removed from the set, that is if it was
314      * present.
315      */
316     function remove(UintSet storage set, uint256 value) internal returns (bool) {
317         return _remove(set._inner, bytes32(value));
318     }
319 
320     /**
321      * @dev Returns true if the value is in the set. O(1).
322      */
323     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
324         return _contains(set._inner, bytes32(value));
325     }
326 
327     /**
328      * @dev Returns the number of values on the set. O(1).
329      */
330     function length(UintSet storage set) internal view returns (uint256) {
331         return _length(set._inner);
332     }
333 
334     /**
335      * @dev Returns the value stored at position `index` in the set. O(1).
336      *
337      * Note that there are no guarantees on the ordering of values inside the
338      * array, and it may change when more values are added or removed.
339      *
340      * Requirements:
341      *
342      * - `index` must be strictly less than {length}.
343      */
344     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
345         return uint256(_at(set._inner, index));
346     }
347 
348     /**
349      * @dev Return the entire set in an array
350      *
351      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
352      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
353      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
354      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
355      */
356     function values(UintSet storage set) internal view returns (uint256[] memory) {
357         bytes32[] memory store = _values(set._inner);
358         uint256[] memory result;
359 
360         /// @solidity memory-safe-assembly
361         assembly {
362             result := store
363         }
364 
365         return result;
366     }
367 }
368 
369 
370 /**
371  * @dev Interface of ERC721A.
372  */
373 interface IERC721A {
374   /**
375    * The caller must own the token or be an approved operator.
376    */
377   error ApprovalCallerNotOwnerNorApproved();
378 
379   /**
380    * The token does not exist.
381    */
382   error ApprovalQueryForNonexistentToken();
383 
384   /**
385    * Cannot query the balance for the zero address.
386    */
387   error BalanceQueryForZeroAddress();
388 
389   /**
390    * Cannot mint to the zero address.
391    */
392   error MintToZeroAddress();
393 
394   /**
395    * The quantity of tokens minted must be more than zero.
396    */
397   error MintZeroQuantity();
398 
399   /**
400    * The token does not exist.
401    */
402   error OwnerQueryForNonexistentToken();
403 
404   /**
405    * The caller must own the token or be an approved operator.
406    */
407   error TransferCallerNotOwnerNorApproved();
408 
409   /**
410    * The token must be owned by `from`.
411    */
412   error TransferFromIncorrectOwner();
413 
414   /**
415    * Cannot safely transfer to a contract that does not implement the
416    * ERC721Receiver interface.
417    */
418   error TransferToNonERC721ReceiverImplementer();
419 
420   /**
421    * Cannot transfer to the zero address.
422    */
423   error TransferToZeroAddress();
424 
425   /**
426    * The token does not exist.
427    */
428   error URIQueryForNonexistentToken();
429 
430   /**
431    * The `quantity` minted with ERC2309 exceeds the safety limit.
432    */
433   error MintERC2309QuantityExceedsLimit();
434 
435   /**
436    * The `extraData` cannot be set on an unintialized ownership slot.
437    */
438   error OwnershipNotInitializedForExtraData();
439 
440   // =============================================================
441   //                            STRUCTS
442   // =============================================================
443 
444   struct TokenOwnership {
445     // The address of the owner.
446     address addr;
447     // Stores the start time of ownership with minimal overhead for tokenomics.
448     uint64 startTimestamp;
449     // Whether the token has been burned.
450     bool burned;
451     // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
452     uint24 extraData;
453   }
454 
455   // =============================================================
456   //                         TOKEN COUNTERS
457   // =============================================================
458 
459   /**
460    * @dev Returns the total number of tokens in existence.
461    * Burned tokens will reduce the count.
462    * To get the total number of tokens minted, please see {_totalMinted}.
463    */
464   function totalSupply() external view returns (uint256);
465 
466   // =============================================================
467   //                            IERC165
468   // =============================================================
469 
470   /**
471    * @dev Returns true if this contract implements the interface defined by
472    * `interfaceId`. See the corresponding
473    * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
474    * to learn more about how these ids are created.
475    *
476    * This function call must use less than 30000 gas.
477    */
478   function supportsInterface(bytes4 interfaceId) external view returns (bool);
479 
480   // =============================================================
481   //                            IERC721
482   // =============================================================
483 
484   /**
485    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
486    */
487   event Transfer(
488     address indexed from,
489     address indexed to,
490     uint256 indexed tokenId
491   );
492 
493   /**
494    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
495    */
496   event Approval(
497     address indexed owner,
498     address indexed approved,
499     uint256 indexed tokenId
500   );
501 
502   /**
503    * @dev Emitted when `owner` enables or disables
504    * (`approved`) `operator` to manage all of its assets.
505    */
506   event ApprovalForAll(
507     address indexed owner,
508     address indexed operator,
509     bool approved
510   );
511 
512   /**
513    * @dev Returns the number of tokens in `owner`'s account.
514    */
515   function balanceOf(address owner) external view returns (uint256 balance);
516 
517   /**
518    * @dev Returns the owner of the `tokenId` token.
519    *
520    * Requirements:
521    *
522    * - `tokenId` must exist.
523    */
524   function ownerOf(uint256 tokenId) external view returns (address owner);
525 
526   /**
527    * @dev Safely transfers `tokenId` token from `from` to `to`,
528    * checking first that contract recipients are aware of the ERC721 protocol
529    * to prevent tokens from being forever locked.
530    *
531    * Requirements:
532    *
533    * - `from` cannot be the zero address.
534    * - `to` cannot be the zero address.
535    * - `tokenId` token must exist and be owned by `from`.
536    * - If the caller is not `from`, it must be have been allowed to move
537    * this token by either {approve} or {setApprovalForAll}.
538    * - If `to` refers to a smart contract, it must implement
539    * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540    *
541    * Emits a {Transfer} event.
542    */
543   function safeTransferFrom(
544     address from,
545     address to,
546     uint256 tokenId,
547     bytes calldata data
548   ) external payable;
549 
550   /**
551    * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
552    */
553   function safeTransferFrom(
554     address from,
555     address to,
556     uint256 tokenId
557   ) external payable;
558 
559   /**
560    * @dev Transfers `tokenId` from `from` to `to`.
561    *
562    * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
563    * whenever possible.
564    *
565    * Requirements:
566    *
567    * - `from` cannot be the zero address.
568    * - `to` cannot be the zero address.
569    * - `tokenId` token must be owned by `from`.
570    * - If the caller is not `from`, it must be approved to move this token
571    * by either {approve} or {setApprovalForAll}.
572    *
573    * Emits a {Transfer} event.
574    */
575   function transferFrom(
576     address from,
577     address to,
578     uint256 tokenId
579   ) external payable;
580 
581   /**
582    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
583    * The approval is cleared when the token is transferred.
584    *
585    * Only a single account can be approved at a time, so approving the
586    * zero address clears previous approvals.
587    *
588    * Requirements:
589    *
590    * - The caller must own the token or be an approved operator.
591    * - `tokenId` must exist.
592    *
593    * Emits an {Approval} event.
594    */
595   function approve(address to, uint256 tokenId) external payable;
596 
597   /**
598    * @dev Approve or remove `operator` as an operator for the caller.
599    * Operators can call {transferFrom} or {safeTransferFrom}
600    * for any token owned by the caller.
601    *
602    * Requirements:
603    *
604    * - The `operator` cannot be the caller.
605    *
606    * Emits an {ApprovalForAll} event.
607    */
608   function setApprovalForAll(address operator, bool _approved) external;
609 
610   /**
611    * @dev Returns the account approved for `tokenId` token.
612    *
613    * Requirements:
614    *
615    * - `tokenId` must exist.
616    */
617   function getApproved(uint256 tokenId)
618     external
619     view
620     returns (address operator);
621 
622   /**
623    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
624    *
625    * See {setApprovalForAll}.
626    */
627   function isApprovedForAll(address owner, address operator)
628     external
629     view
630     returns (bool);
631 
632   // =============================================================
633   //                        IERC721Metadata
634   // =============================================================
635 
636   /**
637    * @dev Returns the token collection name.
638    */
639   function name() external view returns (string memory);
640 
641   /**
642    * @dev Returns the token collection symbol.
643    */
644   function symbol() external view returns (string memory);
645 
646   /**
647    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
648    */
649   function tokenURI(uint256 tokenId) external view returns (string memory);
650 
651   // =============================================================
652   //                           IERC2309
653   // =============================================================
654 
655   /**
656    * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
657    * (inclusive) is transferred from `from` to `to`, as defined in the
658    * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
659    *
660    * See {_mintERC2309} for more details.
661    */
662   event ConsecutiveTransfer(
663     uint256 indexed fromTokenId,
664     uint256 toTokenId,
665     address indexed from,
666     address indexed to
667   );
668 }
669 
670 /**
671  * @dev Interface of ERC721 token receiver.
672  */
673 interface ERC721A__IERC721Receiver {
674   function onERC721Received(
675     address operator,
676     address from,
677     uint256 tokenId,
678     bytes calldata data
679   ) external returns (bytes4);
680 }
681 
682 /**
683  * @title ERC721A
684  *
685  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
686  * Non-Fungible Token Standard, including the Metadata extension.
687  * Optimized for lower gas during batch mints.
688  *
689  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
690  * starting from `_startTokenId()`.
691  *
692  * Assumptions:
693  *
694  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
695  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
696  */
697 contract ERC721A is IERC721A {
698   // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
699   struct TokenApprovalRef {
700     address value;
701   }
702 
703   // =============================================================
704   //                           CONSTANTS
705   // =============================================================
706 
707   // Mask of an entry in packed address data.
708   uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
709 
710   // The bit position of `numberMinted` in packed address data.
711   uint256 private constant _BITPOS_NUMBER_MINTED = 64;
712 
713   // The bit position of `numberBurned` in packed address data.
714   uint256 private constant _BITPOS_NUMBER_BURNED = 128;
715 
716   // The bit position of `aux` in packed address data.
717   uint256 private constant _BITPOS_AUX = 192;
718 
719   // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
720   uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
721 
722   // The bit position of `startTimestamp` in packed ownership.
723   uint256 private constant _BITPOS_START_TIMESTAMP = 160;
724 
725   // The bit mask of the `burned` bit in packed ownership.
726   uint256 private constant _BITMASK_BURNED = 1 << 224;
727 
728   // The bit position of the `nextInitialized` bit in packed ownership.
729   uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
730 
731   // The bit mask of the `nextInitialized` bit in packed ownership.
732   uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
733 
734   // The bit position of `extraData` in packed ownership.
735   uint256 private constant _BITPOS_EXTRA_DATA = 232;
736 
737   // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
738   uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
739 
740   // The mask of the lower 160 bits for addresses.
741   uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
742 
743   // The maximum `quantity` that can be minted with {_mintERC2309}.
744   // This limit is to prevent overflows on the address data entries.
745   // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
746   // is required to cause an overflow, which is unrealistic.
747   uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
748 
749   // The `Transfer` event signature is given by:
750   // `keccak256(bytes("Transfer(address,address,uint256)"))`.
751   bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
752     0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
753 
754   // =============================================================
755   //                            STORAGE
756   // =============================================================
757 
758   // The next token ID to be minted.
759   uint256 private _currentIndex;
760 
761   // The number of tokens burned.
762   uint256 private _burnCounter;
763 
764   // Token name
765   string private _name;
766 
767   // Token symbol
768   string private _symbol;
769 
770   // Mapping from token ID to ownership details
771   // An empty struct value does not necessarily mean the token is unowned.
772   // See {_packedOwnershipOf} implementation for details.
773   //
774   // Bits Layout:
775   // - [0..159]   `addr`
776   // - [160..223] `startTimestamp`
777   // - [224]      `burned`
778   // - [225]      `nextInitialized`
779   // - [232..255] `extraData`
780   mapping(uint256 => uint256) private _packedOwnerships;
781 
782   // Mapping owner address to address data.
783   //
784   // Bits Layout:
785   // - [0..63]    `balance`
786   // - [64..127]  `numberMinted`
787   // - [128..191] `numberBurned`
788   // - [192..255] `aux`
789   mapping(address => uint256) private _packedAddressData;
790 
791   // Mapping from token ID to approved address.
792   mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
793 
794   // Mapping from owner to operator approvals
795   mapping(address => mapping(address => bool)) private _operatorApprovals;
796 
797   // =============================================================
798   //                          CONSTRUCTOR
799   // =============================================================
800 
801   constructor(string memory name_, string memory symbol_) {
802     _name = name_;
803     _symbol = symbol_;
804     _currentIndex = _startTokenId();
805   }
806 
807   // =============================================================
808   //                   TOKEN COUNTING OPERATIONS
809   // =============================================================
810 
811   /**
812    * @dev Returns the starting token ID.
813    * To change the starting token ID, please override this function.
814    */
815   function _startTokenId() internal view virtual returns (uint256) {
816     return 1;
817   }
818 
819   /**
820    * @dev Returns the next token ID to be minted.
821    */
822   function _nextTokenId() internal view virtual returns (uint256) {
823     return _currentIndex;
824   }
825 
826   /**
827    * @dev Returns the total number of tokens in existence.
828    * Burned tokens will reduce the count.
829    * To get the total number of tokens minted, please see {_totalMinted}.
830    */
831   function totalSupply() public view virtual override returns (uint256) {
832     // Counter underflow is impossible as _burnCounter cannot be incremented
833     // more than `_currentIndex - _startTokenId()` times.
834     unchecked {
835       return _currentIndex - _burnCounter - _startTokenId();
836     }
837   }
838 
839   /**
840    * @dev Returns the total amount of tokens minted in the contract.
841    */
842   function _totalMinted() internal view virtual returns (uint256) {
843     // Counter underflow is impossible as `_currentIndex` does not decrement,
844     // and it is initialized to `_startTokenId()`.
845     unchecked {
846       return _currentIndex - _startTokenId();
847     }
848   }
849 
850   /**
851    * @dev Returns the total number of tokens burned.
852    */
853   function _totalBurned() internal view virtual returns (uint256) {
854     return _burnCounter;
855   }
856 
857   // =============================================================
858   //                    ADDRESS DATA OPERATIONS
859   // =============================================================
860 
861   /**
862    * @dev Returns the number of tokens in `owner`'s account.
863    */
864   function balanceOf(address owner)
865     public
866     view
867     virtual
868     override
869     returns (uint256)
870   {
871     if (owner == address(0)) revert BalanceQueryForZeroAddress();
872     return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
873   }
874 
875   /**
876    * Returns the number of tokens minted by `owner`.
877    */
878   function _numberMinted(address owner) internal view returns (uint256) {
879     return
880       (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) &
881       _BITMASK_ADDRESS_DATA_ENTRY;
882   }
883 
884   /**
885    * Returns the number of tokens burned by or on behalf of `owner`.
886    */
887   function _numberBurned(address owner) internal view returns (uint256) {
888     return
889       (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) &
890       _BITMASK_ADDRESS_DATA_ENTRY;
891   }
892 
893   /**
894    * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
895    */
896   function _getAux(address owner) internal view returns (uint64) {
897     return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
898   }
899 
900   /**
901    * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
902    * If there are multiple variables, please pack them into a uint64.
903    */
904   function _setAux(address owner, uint64 aux) internal virtual {
905     uint256 packed = _packedAddressData[owner];
906     uint256 auxCasted;
907     // Cast `aux` with assembly to avoid redundant masking.
908     assembly {
909       auxCasted := aux
910     }
911     packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
912     _packedAddressData[owner] = packed;
913   }
914 
915   // =============================================================
916   //                            IERC165
917   // =============================================================
918 
919   /**
920    * @dev Returns true if this contract implements the interface defined by
921    * `interfaceId`. See the corresponding
922    * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
923    * to learn more about how these ids are created.
924    *
925    * This function call must use less than 30000 gas.
926    */
927   function supportsInterface(bytes4 interfaceId)
928     public
929     view
930     virtual
931     override
932     returns (bool)
933   {
934     // The interface IDs are constants representing the first 4 bytes
935     // of the XOR of all function selectors in the interface.
936     // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
937     // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
938     return
939       interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
940       interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
941       interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
942   }
943 
944   // =============================================================
945   //                        IERC721Metadata
946   // =============================================================
947 
948   /**
949    * @dev Returns the token collection name.
950    */
951   function name() public view virtual override returns (string memory) {
952     return _name;
953   }
954 
955   /**
956    * @dev Returns the token collection symbol.
957    */
958   function symbol() public view virtual override returns (string memory) {
959     return _symbol;
960   }
961 
962   /**
963    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
964    */
965   function tokenURI(uint256 tokenId)
966     public
967     view
968     virtual
969     override
970     returns (string memory)
971   {
972     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
973 
974     string memory baseURI = _baseURI();
975     return
976       bytes(baseURI).length != 0
977         ? string(abi.encodePacked(baseURI, _toString(tokenId)))
978         : "";
979   }
980 
981   /**
982    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984    * by default, it can be overridden in child contracts.
985    */
986   function _baseURI() internal view virtual returns (string memory) {
987     return "";
988   }
989 
990   // =============================================================
991   //                     OWNERSHIPS OPERATIONS
992   // =============================================================
993 
994   /**
995    * @dev Returns the owner of the `tokenId` token.
996    *
997    * Requirements:
998    *
999    * - `tokenId` must exist.
1000    */
1001   function ownerOf(uint256 tokenId)
1002     public
1003     view
1004     virtual
1005     override
1006     returns (address)
1007   {
1008     return address(uint160(_packedOwnershipOf(tokenId)));
1009   }
1010 
1011   /**
1012    * @dev Gas spent here starts off proportional to the maximum mint batch size.
1013    * It gradually moves to O(1) as tokens get transferred around over time.
1014    */
1015   function _ownershipOf(uint256 tokenId)
1016     internal
1017     view
1018     virtual
1019     returns (TokenOwnership memory)
1020   {
1021     return _unpackedOwnership(_packedOwnershipOf(tokenId));
1022   }
1023 
1024   /**
1025    * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1026    */
1027   function _ownershipAt(uint256 index)
1028     internal
1029     view
1030     virtual
1031     returns (TokenOwnership memory)
1032   {
1033     return _unpackedOwnership(_packedOwnerships[index]);
1034   }
1035 
1036   /**
1037    * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1038    */
1039   function _initializeOwnershipAt(uint256 index) internal virtual {
1040     if (_packedOwnerships[index] == 0) {
1041       _packedOwnerships[index] = _packedOwnershipOf(index);
1042     }
1043   }
1044 
1045   /**
1046    * Returns the packed ownership data of `tokenId`.
1047    */
1048   function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1049     uint256 curr = tokenId;
1050 
1051     unchecked {
1052       if (_startTokenId() <= curr)
1053         if (curr < _currentIndex) {
1054           uint256 packed = _packedOwnerships[curr];
1055           // If not burned.
1056           if (packed & _BITMASK_BURNED == 0) {
1057             // Invariant:
1058             // There will always be an initialized ownership slot
1059             // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1060             // before an unintialized ownership slot
1061             // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1062             // Hence, `curr` will not underflow.
1063             //
1064             // We can directly compare the packed value.
1065             // If the address is zero, packed will be zero.
1066             while (packed == 0) {
1067               packed = _packedOwnerships[--curr];
1068             }
1069             return packed;
1070           }
1071         }
1072     }
1073     revert OwnerQueryForNonexistentToken();
1074   }
1075 
1076   /**
1077    * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1078    */
1079   function _unpackedOwnership(uint256 packed)
1080     private
1081     pure
1082     returns (TokenOwnership memory ownership)
1083   {
1084     ownership.addr = address(uint160(packed));
1085     ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1086     ownership.burned = packed & _BITMASK_BURNED != 0;
1087     ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1088   }
1089 
1090   /**
1091    * @dev Packs ownership data into a single uint256.
1092    */
1093   function _packOwnershipData(address owner, uint256 flags)
1094     private
1095     view
1096     returns (uint256 result)
1097   {
1098     assembly {
1099       // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1100       owner := and(owner, _BITMASK_ADDRESS)
1101       // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1102       result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1103     }
1104   }
1105 
1106   /**
1107    * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1108    */
1109   function _nextInitializedFlag(uint256 quantity)
1110     private
1111     pure
1112     returns (uint256 result)
1113   {
1114     // For branchless setting of the `nextInitialized` flag.
1115     assembly {
1116       // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1117       result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1118     }
1119   }
1120 
1121   // =============================================================
1122   //                      APPROVAL OPERATIONS
1123   // =============================================================
1124 
1125   /**
1126    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1127    * The approval is cleared when the token is transferred.
1128    *
1129    * Only a single account can be approved at a time, so approving the
1130    * zero address clears previous approvals.
1131    *
1132    * Requirements:
1133    *
1134    * - The caller must own the token or be an approved operator.
1135    * - `tokenId` must exist.
1136    *
1137    * Emits an {Approval} event.
1138    */
1139   function approve(address to, uint256 tokenId)
1140     public
1141     payable
1142     virtual
1143     override
1144   {
1145     address owner = ownerOf(tokenId);
1146 
1147     if (_msgSenderERC721A() != owner)
1148       if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1149         revert ApprovalCallerNotOwnerNorApproved();
1150       }
1151 
1152     _tokenApprovals[tokenId].value = to;
1153     emit Approval(owner, to, tokenId);
1154   }
1155 
1156   /**
1157    * @dev Returns the account approved for `tokenId` token.
1158    *
1159    * Requirements:
1160    *
1161    * - `tokenId` must exist.
1162    */
1163   function getApproved(uint256 tokenId)
1164     public
1165     view
1166     virtual
1167     override
1168     returns (address)
1169   {
1170     if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1171 
1172     return _tokenApprovals[tokenId].value;
1173   }
1174 
1175   /**
1176    * @dev Approve or remove `operator` as an operator for the caller.
1177    * Operators can call {transferFrom} or {safeTransferFrom}
1178    * for any token owned by the caller.
1179    *
1180    * Requirements:
1181    *
1182    * - The `operator` cannot be the caller.
1183    *
1184    * Emits an {ApprovalForAll} event.
1185    */
1186   function setApprovalForAll(address operator, bool approved)
1187     public
1188     virtual
1189     override
1190   {
1191     _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1192     emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1193   }
1194 
1195   /**
1196    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1197    *
1198    * See {setApprovalForAll}.
1199    */
1200   function isApprovedForAll(address owner, address operator)
1201     public
1202     view
1203     virtual
1204     override
1205     returns (bool)
1206   {
1207     return _operatorApprovals[owner][operator];
1208   }
1209 
1210   /**
1211    * @dev Returns whether `tokenId` exists.
1212    *
1213    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1214    *
1215    * Tokens start existing when they are minted. See {_mint}.
1216    */
1217   function _exists(uint256 tokenId) internal view virtual returns (bool) {
1218     return
1219       _startTokenId() <= tokenId &&
1220       tokenId < _currentIndex && // If within bounds,
1221       _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1222   }
1223 
1224   /**
1225    * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1226    */
1227   function _isSenderApprovedOrOwner(
1228     address approvedAddress,
1229     address owner,
1230     address msgSender
1231   ) private pure returns (bool result) {
1232     assembly {
1233       // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1234       owner := and(owner, _BITMASK_ADDRESS)
1235       // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1236       msgSender := and(msgSender, _BITMASK_ADDRESS)
1237       // `msgSender == owner || msgSender == approvedAddress`.
1238       result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1239     }
1240   }
1241 
1242   /**
1243    * @dev Returns the storage slot and value for the approved address of `tokenId`.
1244    */
1245   function _getApprovedSlotAndAddress(uint256 tokenId)
1246     private
1247     view
1248     returns (uint256 approvedAddressSlot, address approvedAddress)
1249   {
1250     TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1251     // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1252     assembly {
1253       approvedAddressSlot := tokenApproval.slot
1254       approvedAddress := sload(approvedAddressSlot)
1255     }
1256   }
1257 
1258   // =============================================================
1259   //                      TRANSFER OPERATIONS
1260   // =============================================================
1261 
1262   /**
1263    * @dev Transfers `tokenId` from `from` to `to`.
1264    *
1265    * Requirements:
1266    *
1267    * - `from` cannot be the zero address.
1268    * - `to` cannot be the zero address.
1269    * - `tokenId` token must be owned by `from`.
1270    * - If the caller is not `from`, it must be approved to move this token
1271    * by either {approve} or {setApprovalForAll}.
1272    *
1273    * Emits a {Transfer} event.
1274    */
1275   function transferFrom(
1276     address from,
1277     address to,
1278     uint256 tokenId
1279   ) public payable virtual override {
1280     uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1281 
1282     if (address(uint160(prevOwnershipPacked)) != from)
1283       revert TransferFromIncorrectOwner();
1284 
1285     (
1286       uint256 approvedAddressSlot,
1287       address approvedAddress
1288     ) = _getApprovedSlotAndAddress(tokenId);
1289 
1290     // The nested ifs save around 20+ gas over a compound boolean condition.
1291     if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1292       if (!isApprovedForAll(from, _msgSenderERC721A()))
1293         revert TransferCallerNotOwnerNorApproved();
1294 
1295     if (to == address(0)) revert TransferToZeroAddress();
1296 
1297     _beforeTokenTransfers(from, to, tokenId, 1);
1298 
1299     // Clear approvals from the previous owner.
1300     assembly {
1301       if approvedAddress {
1302         // This is equivalent to `delete _tokenApprovals[tokenId]`.
1303         sstore(approvedAddressSlot, 0)
1304       }
1305     }
1306 
1307     // Underflow of the sender's balance is impossible because we check for
1308     // ownership above and the recipient's balance can't realistically overflow.
1309     // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1310     unchecked {
1311       // We can directly increment and decrement the balances.
1312       --_packedAddressData[from]; // Updates: `balance -= 1`.
1313       ++_packedAddressData[to]; // Updates: `balance += 1`.
1314 
1315       // Updates:
1316       // - `address` to the next owner.
1317       // - `startTimestamp` to the timestamp of transfering.
1318       // - `burned` to `false`.
1319       // - `nextInitialized` to `true`.
1320       _packedOwnerships[tokenId] = _packOwnershipData(
1321         to,
1322         _BITMASK_NEXT_INITIALIZED |
1323           _nextExtraData(from, to, prevOwnershipPacked)
1324       );
1325 
1326       // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1327       if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1328         uint256 nextTokenId = tokenId + 1;
1329         // If the next slot's address is zero and not burned (i.e. packed value is zero).
1330         if (_packedOwnerships[nextTokenId] == 0) {
1331           // If the next slot is within bounds.
1332           if (nextTokenId != _currentIndex) {
1333             // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1334             _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1335           }
1336         }
1337       }
1338     }
1339 
1340     emit Transfer(from, to, tokenId);
1341     _afterTokenTransfers(from, to, tokenId, 1);
1342   }
1343 
1344   /**
1345    * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1346    */
1347   function safeTransferFrom(
1348     address from,
1349     address to,
1350     uint256 tokenId
1351   ) public payable virtual override {
1352     safeTransferFrom(from, to, tokenId, "");
1353   }
1354 
1355   /**
1356    * @dev Safely transfers `tokenId` token from `from` to `to`.
1357    *
1358    * Requirements:
1359    *
1360    * - `from` cannot be the zero address.
1361    * - `to` cannot be the zero address.
1362    * - `tokenId` token must exist and be owned by `from`.
1363    * - If the caller is not `from`, it must be approved to move this token
1364    * by either {approve} or {setApprovalForAll}.
1365    * - If `to` refers to a smart contract, it must implement
1366    * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1367    *
1368    * Emits a {Transfer} event.
1369    */
1370   function safeTransferFrom(
1371     address from,
1372     address to,
1373     uint256 tokenId,
1374     bytes memory _data
1375   ) public payable virtual override {
1376     transferFrom(from, to, tokenId);
1377     if (to.code.length != 0)
1378       if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1379         revert TransferToNonERC721ReceiverImplementer();
1380       }
1381   }
1382 
1383   /**
1384    * @dev Hook that is called before a set of serially-ordered token IDs
1385    * are about to be transferred. This includes minting.
1386    * And also called before burning one token.
1387    *
1388    * `startTokenId` - the first token ID to be transferred.
1389    * `quantity` - the amount to be transferred.
1390    *
1391    * Calling conditions:
1392    *
1393    * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1394    * transferred to `to`.
1395    * - When `from` is zero, `tokenId` will be minted for `to`.
1396    * - When `to` is zero, `tokenId` will be burned by `from`.
1397    * - `from` and `to` are never both zero.
1398    */
1399   function _beforeTokenTransfers(
1400     address from,
1401     address to,
1402     uint256 startTokenId,
1403     uint256 quantity
1404   ) internal virtual {}
1405 
1406   /**
1407    * @dev Hook that is called after a set of serially-ordered token IDs
1408    * have been transferred. This includes minting.
1409    * And also called after one token has been burned.
1410    *
1411    * `startTokenId` - the first token ID to be transferred.
1412    * `quantity` - the amount to be transferred.
1413    *
1414    * Calling conditions:
1415    *
1416    * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1417    * transferred to `to`.
1418    * - When `from` is zero, `tokenId` has been minted for `to`.
1419    * - When `to` is zero, `tokenId` has been burned by `from`.
1420    * - `from` and `to` are never both zero.
1421    */
1422   function _afterTokenTransfers(
1423     address from,
1424     address to,
1425     uint256 startTokenId,
1426     uint256 quantity
1427   ) internal virtual {}
1428 
1429   /**
1430    * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1431    *
1432    * `from` - Previous owner of the given token ID.
1433    * `to` - Target address that will receive the token.
1434    * `tokenId` - Token ID to be transferred.
1435    * `_data` - Optional data to send along with the call.
1436    *
1437    * Returns whether the call correctly returned the expected magic value.
1438    */
1439   function _checkContractOnERC721Received(
1440     address from,
1441     address to,
1442     uint256 tokenId,
1443     bytes memory _data
1444   ) private returns (bool) {
1445     try
1446       ERC721A__IERC721Receiver(to).onERC721Received(
1447         _msgSenderERC721A(),
1448         from,
1449         tokenId,
1450         _data
1451       )
1452     returns (bytes4 retval) {
1453       return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1454     } catch (bytes memory reason) {
1455       if (reason.length == 0) {
1456         revert TransferToNonERC721ReceiverImplementer();
1457       } else {
1458         assembly {
1459           revert(add(32, reason), mload(reason))
1460         }
1461       }
1462     }
1463   }
1464 
1465   // =============================================================
1466   //                        MINT OPERATIONS
1467   // =============================================================
1468 
1469   /**
1470    * @dev Mints `quantity` tokens and transfers them to `to`.
1471    *
1472    * Requirements:
1473    *
1474    * - `to` cannot be the zero address.
1475    * - `quantity` must be greater than 0.
1476    *
1477    * Emits a {Transfer} event for each mint.
1478    */
1479   function _mint(address to, uint256 quantity) internal virtual {
1480     uint256 startTokenId = _currentIndex;
1481     if (quantity == 0) revert MintZeroQuantity();
1482 
1483     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1484 
1485     // Overflows are incredibly unrealistic.
1486     // `balance` and `numberMinted` have a maximum limit of 2**64.
1487     // `tokenId` has a maximum limit of 2**256.
1488     unchecked {
1489       // Updates:
1490       // - `balance += quantity`.
1491       // - `numberMinted += quantity`.
1492       //
1493       // We can directly add to the `balance` and `numberMinted`.
1494       _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1495 
1496       // Updates:
1497       // - `address` to the owner.
1498       // - `startTimestamp` to the timestamp of minting.
1499       // - `burned` to `false`.
1500       // - `nextInitialized` to `quantity == 1`.
1501       _packedOwnerships[startTokenId] = _packOwnershipData(
1502         to,
1503         _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1504       );
1505 
1506       uint256 toMasked;
1507       uint256 end = startTokenId + quantity;
1508 
1509       // Use assembly to loop and emit the `Transfer` event for gas savings.
1510       // The duplicated `log4` removes an extra check and reduces stack juggling.
1511       // The assembly, together with the surrounding Solidity code, have been
1512       // delicately arranged to nudge the compiler into producing optimized opcodes.
1513       assembly {
1514         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1515         toMasked := and(to, _BITMASK_ADDRESS)
1516         // Emit the `Transfer` event.
1517         log4(
1518           0, // Start of data (0, since no data).
1519           0, // End of data (0, since no data).
1520           _TRANSFER_EVENT_SIGNATURE, // Signature.
1521           0, // `address(0)`.
1522           toMasked, // `to`.
1523           startTokenId // `tokenId`.
1524         )
1525 
1526         // The `iszero(eq(,))` check ensures that large values of `quantity`
1527         // that overflows uint256 will make the loop run out of gas.
1528         // The compiler will optimize the `iszero` away for performance.
1529         for {
1530           let tokenId := add(startTokenId, 1)
1531         } iszero(eq(tokenId, end)) {
1532           tokenId := add(tokenId, 1)
1533         } {
1534           // Emit the `Transfer` event. Similar to above.
1535           log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1536         }
1537       }
1538       if (toMasked == 0) revert MintToZeroAddress();
1539 
1540       _currentIndex = end;
1541     }
1542     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1543   }
1544 
1545   /**
1546    * @dev Mints `quantity` tokens and transfers them to `to`.
1547    *
1548    * This function is intended for efficient minting only during contract creation.
1549    *
1550    * It emits only one {ConsecutiveTransfer} as defined in
1551    * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1552    * instead of a sequence of {Transfer} event(s).
1553    *
1554    * Calling this function outside of contract creation WILL make your contract
1555    * non-compliant with the ERC721 standard.
1556    * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1557    * {ConsecutiveTransfer} event is only permissible during contract creation.
1558    *
1559    * Requirements:
1560    *
1561    * - `to` cannot be the zero address.
1562    * - `quantity` must be greater than 0.
1563    *
1564    * Emits a {ConsecutiveTransfer} event.
1565    */
1566   function _mintERC2309(address to, uint256 quantity) internal virtual {
1567     uint256 startTokenId = _currentIndex;
1568     if (to == address(0)) revert MintToZeroAddress();
1569     if (quantity == 0) revert MintZeroQuantity();
1570     if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT)
1571       revert MintERC2309QuantityExceedsLimit();
1572 
1573     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1574 
1575     // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1576     unchecked {
1577       // Updates:
1578       // - `balance += quantity`.
1579       // - `numberMinted += quantity`.
1580       //
1581       // We can directly add to the `balance` and `numberMinted`.
1582       _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1583 
1584       // Updates:
1585       // - `address` to the owner.
1586       // - `startTimestamp` to the timestamp of minting.
1587       // - `burned` to `false`.
1588       // - `nextInitialized` to `quantity == 1`.
1589       _packedOwnerships[startTokenId] = _packOwnershipData(
1590         to,
1591         _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1592       );
1593 
1594       emit ConsecutiveTransfer(
1595         startTokenId,
1596         startTokenId + quantity - 1,
1597         address(0),
1598         to
1599       );
1600 
1601       _currentIndex = startTokenId + quantity;
1602     }
1603     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1604   }
1605 
1606   /**
1607    * @dev Safely mints `quantity` tokens and transfers them to `to`.
1608    *
1609    * Requirements:
1610    *
1611    * - If `to` refers to a smart contract, it must implement
1612    * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1613    * - `quantity` must be greater than 0.
1614    *
1615    * See {_mint}.
1616    *
1617    * Emits a {Transfer} event for each mint.
1618    */
1619   function _safeMint(
1620     address to,
1621     uint256 quantity,
1622     bytes memory _data
1623   ) internal virtual {
1624     _mint(to, quantity);
1625 
1626     unchecked {
1627       if (to.code.length != 0) {
1628         uint256 end = _currentIndex;
1629         uint256 index = end - quantity;
1630         do {
1631           if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1632             revert TransferToNonERC721ReceiverImplementer();
1633           }
1634         } while (index < end);
1635         // Reentrancy protection.
1636         if (_currentIndex != end) revert();
1637       }
1638     }
1639   }
1640 
1641   /**
1642    * @dev Equivalent to `_safeMint(to, quantity, '')`.
1643    */
1644   function _safeMint(address to, uint256 quantity) internal virtual {
1645     _safeMint(to, quantity, "");
1646   }
1647 
1648   // =============================================================
1649   //                        BURN OPERATIONS
1650   // =============================================================
1651 
1652   /**
1653    * @dev Equivalent to `_burn(tokenId, false)`.
1654    */
1655   function _burn(uint256 tokenId) internal virtual {
1656     _burn(tokenId, false);
1657   }
1658 
1659   /**
1660    * @dev Destroys `tokenId`.
1661    * The approval is cleared when the token is burned.
1662    *
1663    * Requirements:
1664    *
1665    * - `tokenId` must exist.
1666    *
1667    * Emits a {Transfer} event.
1668    */
1669   function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1670     uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1671 
1672     address from = address(uint160(prevOwnershipPacked));
1673 
1674     (
1675       uint256 approvedAddressSlot,
1676       address approvedAddress
1677     ) = _getApprovedSlotAndAddress(tokenId);
1678 
1679     if (approvalCheck) {
1680       // The nested ifs save around 20+ gas over a compound boolean condition.
1681       if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1682         if (!isApprovedForAll(from, _msgSenderERC721A()))
1683           revert TransferCallerNotOwnerNorApproved();
1684     }
1685 
1686     _beforeTokenTransfers(from, address(0), tokenId, 1);
1687 
1688     // Clear approvals from the previous owner.
1689     assembly {
1690       if approvedAddress {
1691         // This is equivalent to `delete _tokenApprovals[tokenId]`.
1692         sstore(approvedAddressSlot, 0)
1693       }
1694     }
1695 
1696     // Underflow of the sender's balance is impossible because we check for
1697     // ownership above and the recipient's balance can't realistically overflow.
1698     // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1699     unchecked {
1700       // Updates:
1701       // - `balance -= 1`.
1702       // - `numberBurned += 1`.
1703       //
1704       // We can directly decrement the balance, and increment the number burned.
1705       // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1706       _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1707 
1708       // Updates:
1709       // - `address` to the last owner.
1710       // - `startTimestamp` to the timestamp of burning.
1711       // - `burned` to `true`.
1712       // - `nextInitialized` to `true`.
1713       _packedOwnerships[tokenId] = _packOwnershipData(
1714         from,
1715         (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) |
1716           _nextExtraData(from, address(0), prevOwnershipPacked)
1717       );
1718 
1719       // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1720       if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1721         uint256 nextTokenId = tokenId + 1;
1722         // If the next slot's address is zero and not burned (i.e. packed value is zero).
1723         if (_packedOwnerships[nextTokenId] == 0) {
1724           // If the next slot is within bounds.
1725           if (nextTokenId != _currentIndex) {
1726             // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1727             _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1728           }
1729         }
1730       }
1731     }
1732 
1733     emit Transfer(from, address(0), tokenId);
1734     _afterTokenTransfers(from, address(0), tokenId, 1);
1735 
1736     // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1737     unchecked {
1738       _burnCounter++;
1739     }
1740   }
1741 
1742   // =============================================================
1743   //                     EXTRA DATA OPERATIONS
1744   // =============================================================
1745 
1746   /**
1747    * @dev Directly sets the extra data for the ownership data `index`.
1748    */
1749   function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1750     uint256 packed = _packedOwnerships[index];
1751     if (packed == 0) revert OwnershipNotInitializedForExtraData();
1752     uint256 extraDataCasted;
1753     // Cast `extraData` with assembly to avoid redundant masking.
1754     assembly {
1755       extraDataCasted := extraData
1756     }
1757     packed =
1758       (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) |
1759       (extraDataCasted << _BITPOS_EXTRA_DATA);
1760     _packedOwnerships[index] = packed;
1761   }
1762 
1763   /**
1764    * @dev Called during each token transfer to set the 24bit `extraData` field.
1765    * Intended to be overridden by the cosumer contract.
1766    *
1767    * `previousExtraData` - the value of `extraData` before transfer.
1768    *
1769    * Calling conditions:
1770    *
1771    * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1772    * transferred to `to`.
1773    * - When `from` is zero, `tokenId` will be minted for `to`.
1774    * - When `to` is zero, `tokenId` will be burned by `from`.
1775    * - `from` and `to` are never both zero.
1776    */
1777   function _extraData(
1778     address from,
1779     address to,
1780     uint24 previousExtraData
1781   ) internal view virtual returns (uint24) {}
1782 
1783   /**
1784    * @dev Returns the next extra data for the packed ownership data.
1785    * The returned result is shifted into position.
1786    */
1787   function _nextExtraData(
1788     address from,
1789     address to,
1790     uint256 prevOwnershipPacked
1791   ) private view returns (uint256) {
1792     uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1793     return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1794   }
1795 
1796   // =============================================================
1797   //                       OTHER OPERATIONS
1798   // =============================================================
1799 
1800   /**
1801    * @dev Returns the message sender (defaults to `msg.sender`).
1802    *
1803    * If you are writing GSN compatible contracts, you need to override this function.
1804    */
1805   function _msgSenderERC721A() internal view virtual returns (address) {
1806     return msg.sender;
1807   }
1808 
1809   /**
1810    * @dev Converts a uint256 to its ASCII string decimal representation.
1811    */
1812   function _toString(uint256 value)
1813     internal
1814     pure
1815     virtual
1816     returns (string memory str)
1817   {
1818     assembly {
1819       // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1820       // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1821       // We will need 1 word for the trailing zeros padding, 1 word for the length,
1822       // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1823       let m := add(mload(0x40), 0xa0)
1824       // Update the free memory pointer to allocate.
1825       mstore(0x40, m)
1826       // Assign the `str` to the end.
1827       str := sub(m, 0x20)
1828       // Zeroize the slot after the string.
1829       mstore(str, 0)
1830 
1831       // Cache the end of the memory to calculate the length later.
1832       let end := str
1833 
1834       // We write the string from rightmost digit to leftmost digit.
1835       // The following is essentially a do-while loop that also handles the zero case.
1836       // prettier-ignore
1837       for { let temp := value } 1 {} {
1838                 str := sub(str, 1)
1839                 // Write the character to the pointer.
1840                 // The ASCII index of the '0' character is 48.
1841                 mstore8(str, add(48, mod(temp, 10)))
1842                 // Keep dividing `temp` until zero.
1843                 temp := div(temp, 10)
1844                 // prettier-ignore
1845                 if iszero(temp) { break }
1846             }
1847 
1848       let length := sub(end, str)
1849       // Move the pointer 32 bytes leftwards to make room for the length.
1850       str := sub(str, 0x20)
1851       // Store the length.
1852       mstore(str, length)
1853     }
1854   }
1855 }
1856 
1857 library MerkleProof {
1858   /**
1859    * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1860    * defined by `root`. For this, a `proof` must be provided, containing
1861    * sibling hashes on the branch from the leaf to the root of the tree. Each
1862    * pair of leaves and each pair of pre-images are assumed to be sorted.
1863    */
1864   function verify(
1865     bytes32[] memory proof,
1866     bytes32 root,
1867     bytes32 leaf
1868   ) internal pure returns (bool) {
1869     return processProof(proof, leaf) == root;
1870   }
1871 
1872   /**
1873    * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1874    * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1875    * hash matches the root of the tree. When processing the proof, the pairs
1876    * of leafs & pre-images are assumed to be sorted.
1877    *
1878    * _Available since v4.4._
1879    */
1880   function processProof(bytes32[] memory proof, bytes32 leaf)
1881     internal
1882     pure
1883     returns (bytes32)
1884   {
1885     bytes32 computedHash = leaf;
1886     for (uint256 i = 0; i < proof.length; i++) {
1887       bytes32 proofElement = proof[i];
1888       if (computedHash <= proofElement) {
1889         // Hash(current computed hash + current element of the proof)
1890         computedHash = _efficientHash(computedHash, proofElement);
1891       } else {
1892         // Hash(current element of the proof + current computed hash)
1893         computedHash = _efficientHash(proofElement, computedHash);
1894       }
1895     }
1896     return computedHash;
1897   }
1898 
1899   function _efficientHash(bytes32 a, bytes32 b)
1900     private
1901     pure
1902     returns (bytes32 value)
1903   {
1904     assembly {
1905       mstore(0x00, a)
1906       mstore(0x20, b)
1907       value := keccak256(0x00, 0x40)
1908     }
1909   }
1910 }
1911 
1912 library SafeMath {
1913   /**
1914    * @dev Returns the addition of two unsigned integers, with an overflow flag.
1915    *
1916    * _Available since v3.4._
1917    */
1918   function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1919     unchecked {
1920       uint256 c = a + b;
1921       if (c < a) return (false, 0);
1922       return (true, c);
1923     }
1924   }
1925 
1926   /**
1927    * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1928    *
1929    * _Available since v3.4._
1930    */
1931   function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1932     unchecked {
1933       if (b > a) return (false, 0);
1934       return (true, a - b);
1935     }
1936   }
1937 
1938   /**
1939    * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1940    *
1941    * _Available since v3.4._
1942    */
1943   function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1944     unchecked {
1945       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1946       // benefit is lost if 'b' is also tested.
1947       // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1948       if (a == 0) return (true, 0);
1949       uint256 c = a * b;
1950       if (c / a != b) return (false, 0);
1951       return (true, c);
1952     }
1953   }
1954 
1955   /**
1956    * @dev Returns the division of two unsigned integers, with a division by zero flag.
1957    *
1958    * _Available since v3.4._
1959    */
1960   function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1961     unchecked {
1962       if (b == 0) return (false, 0);
1963       return (true, a / b);
1964     }
1965   }
1966 
1967   /**
1968    * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1969    *
1970    * _Available since v3.4._
1971    */
1972   function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1973     unchecked {
1974       if (b == 0) return (false, 0);
1975       return (true, a % b);
1976     }
1977   }
1978 
1979   /**
1980    * @dev Returns the addition of two unsigned integers, reverting on
1981    * overflow.
1982    *
1983    * Counterpart to Solidity's `+` operator.
1984    *
1985    * Requirements:
1986    *
1987    * - Addition cannot overflow.
1988    */
1989   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1990     return a + b;
1991   }
1992 
1993   /**
1994    * @dev Returns the subtraction of two unsigned integers, reverting on
1995    * overflow (when the result is negative).
1996    *
1997    * Counterpart to Solidity's `-` operator.
1998    *
1999    * Requirements:
2000    *
2001    * - Subtraction cannot overflow.
2002    */
2003   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2004     return a - b;
2005   }
2006 
2007   /**
2008    * @dev Returns the multiplication of two unsigned integers, reverting on
2009    * overflow.
2010    *
2011    * Counterpart to Solidity's `*` operator.
2012    *
2013    * Requirements:
2014    *
2015    * - Multiplication cannot overflow.
2016    */
2017   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2018     return a * b;
2019   }
2020 
2021   /**
2022    * @dev Returns the integer division of two unsigned integers, reverting on
2023    * division by zero. The result is rounded towards zero.
2024    *
2025    * Counterpart to Solidity's `/` operator.
2026    *
2027    * Requirements:
2028    *
2029    * - The divisor cannot be zero.
2030    */
2031   function div(uint256 a, uint256 b) internal pure returns (uint256) {
2032     return a / b;
2033   }
2034 
2035   /**
2036    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2037    * reverting when dividing by zero.
2038    *
2039    * Counterpart to Solidity's `%` operator. This function uses a `revert`
2040    * opcode (which leaves remaining gas untouched) while Solidity uses an
2041    * invalid opcode to revert (consuming all remaining gas).
2042    *
2043    * Requirements:
2044    *
2045    * - The divisor cannot be zero.
2046    */
2047   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2048     return a % b;
2049   }
2050 
2051   /**
2052    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2053    * overflow (when the result is negative).
2054    *
2055    * CAUTION: This function is deprecated because it requires allocating memory for the error
2056    * message unnecessarily. For custom revert reasons use {trySub}.
2057    *
2058    * Counterpart to Solidity's `-` operator.
2059    *
2060    * Requirements:
2061    *
2062    * - Subtraction cannot overflow.
2063    */
2064   function sub(
2065     uint256 a,
2066     uint256 b,
2067     string memory errorMessage
2068   ) internal pure returns (uint256) {
2069     unchecked {
2070       require(b <= a, errorMessage);
2071       return a - b;
2072     }
2073   }
2074 
2075   /**
2076    * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2077    * division by zero. The result is rounded towards zero.
2078    *
2079    * Counterpart to Solidity's `/` operator. Note: this function uses a
2080    * `revert` opcode (which leaves remaining gas untouched) while Solidity
2081    * uses an invalid opcode to revert (consuming all remaining gas).
2082    *
2083    * Requirements:
2084    *
2085    * - The divisor cannot be zero.
2086    */
2087   function div(
2088     uint256 a,
2089     uint256 b,
2090     string memory errorMessage
2091   ) internal pure returns (uint256) {
2092     unchecked {
2093       require(b > 0, errorMessage);
2094       return a / b;
2095     }
2096   }
2097 
2098   /**
2099    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2100    * reverting with custom message when dividing by zero.
2101    *
2102    * CAUTION: This function is deprecated because it requires allocating memory for the error
2103    * message unnecessarily. For custom revert reasons use {tryMod}.
2104    *
2105    * Counterpart to Solidity's `%` operator. This function uses a `revert`
2106    * opcode (which leaves remaining gas untouched) while Solidity uses an
2107    * invalid opcode to revert (consuming all remaining gas).
2108    *
2109    * Requirements:
2110    *
2111    * - The divisor cannot be zero.
2112    */
2113   function mod(
2114     uint256 a,
2115     uint256 b,
2116     string memory errorMessage
2117   ) internal pure returns (uint256) {
2118     unchecked {
2119       require(b > 0, errorMessage);
2120       return a % b;
2121     }
2122   }
2123 }
2124 
2125 library Counters {
2126   struct Counter {
2127     // This variable should never be directly accessed by users of the library: interactions must be restricted to
2128     // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
2129     // this feature: see https://github.com/ethereum/solidity/issues/4637
2130     uint256 _value; // default: 0
2131   }
2132 
2133   function current(Counter storage counter) internal view returns (uint256) {
2134     return counter._value;
2135   }
2136 
2137   function increment(Counter storage counter) internal {
2138     unchecked {
2139       counter._value += 1;
2140     }
2141   }
2142 
2143   function decrement(Counter storage counter) internal {
2144     uint256 value = counter._value;
2145     require(value > 0, "Counter: decrement overflow");
2146     unchecked {
2147       counter._value = value - 1;
2148     }
2149   }
2150 
2151   function reset(Counter storage counter) internal {
2152     counter._value = 0;
2153   }
2154 }
2155 
2156 library Strings {
2157   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2158   uint8 private constant _ADDRESS_LENGTH = 20;
2159 
2160   /**
2161    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2162    */
2163   function toString(uint256 value) internal pure returns (string memory) {
2164     // Inspired by OraclizeAPI's implementation - MIT licence
2165     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2166 
2167     if (value == 0) {
2168       return "0";
2169     }
2170     uint256 temp = value;
2171     uint256 digits;
2172     while (temp != 0) {
2173       digits++;
2174       temp /= 10;
2175     }
2176     bytes memory buffer = new bytes(digits);
2177     while (value != 0) {
2178       digits -= 1;
2179       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2180       value /= 10;
2181     }
2182     return string(buffer);
2183   }
2184 
2185   /**
2186    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2187    */
2188   function toHexString(uint256 value) internal pure returns (string memory) {
2189     if (value == 0) {
2190       return "0x00";
2191     }
2192     uint256 temp = value;
2193     uint256 length = 0;
2194     while (temp != 0) {
2195       length++;
2196       temp >>= 8;
2197     }
2198     return toHexString(value, length);
2199   }
2200 
2201   /**
2202    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2203    */
2204   function toHexString(uint256 value, uint256 length)
2205     internal
2206     pure
2207     returns (string memory)
2208   {
2209     bytes memory buffer = new bytes(2 * length + 2);
2210     buffer[0] = "0";
2211     buffer[1] = "x";
2212     for (uint256 i = 2 * length + 1; i > 1; --i) {
2213       buffer[i] = _HEX_SYMBOLS[value & 0xf];
2214       value >>= 4;
2215     }
2216     require(value == 0, "Strings: hex length insufficient");
2217     return string(buffer);
2218   }
2219 
2220   /**
2221    * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2222    */
2223   function toHexString(address addr) internal pure returns (string memory) {
2224     return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2225   }
2226 }
2227 
2228 abstract contract Context {
2229   function _msgSender() internal view virtual returns (address) {
2230     return msg.sender;
2231   }
2232 
2233   function _msgData() internal view virtual returns (bytes calldata) {
2234     return msg.data;
2235   }
2236 }
2237 
2238 abstract contract Ownable is Context {
2239   address private _owner;
2240 
2241   event OwnershipTransferred(
2242     address indexed previousOwner,
2243     address indexed newOwner
2244   );
2245 
2246   /**
2247    * @dev Initializes the contract setting the deployer as the initial owner.
2248    */
2249   constructor() {
2250     _transferOwnership(_msgSender());
2251   }
2252 
2253   /**
2254    * @dev Throws if called by any account other than the owner.
2255    */
2256   modifier onlyOwner() {
2257     _checkOwner();
2258     _;
2259   }
2260 
2261   /**
2262    * @dev Returns the address of the current owner.
2263    */
2264   function owner() public view virtual returns (address) {
2265     return _owner;
2266   }
2267 
2268   /**
2269    * @dev Throws if the sender is not the owner.
2270    */
2271   function _checkOwner() internal view virtual {
2272     require(owner() == _msgSender(), "Ownable: caller is not the owner");
2273   }
2274 
2275   /**
2276    * @dev Leaves the contract without owner. It will not be possible to call
2277    * `onlyOwner` functions anymore. Can only be called by the current owner.
2278    *
2279    * NOTE: Renouncing ownership will leave the contract without an owner,
2280    * thereby removing any functionality that is only available to the owner.
2281    */
2282   function renounceOwnership() public virtual onlyOwner {
2283     _transferOwnership(address(0));
2284   }
2285 
2286   /**
2287    * @dev Transfers ownership of the contract to a new account (`newOwner`).
2288    * Can only be called by the current owner.
2289    */
2290   function transferOwnership(address newOwner) public virtual onlyOwner {
2291     require(newOwner != address(0), "Ownable: new owner is the zero address");
2292     _transferOwnership(newOwner);
2293   }
2294 
2295   /**
2296    * @dev Transfers ownership of the contract to a new account (`newOwner`).
2297    * Internal function without access restriction.
2298    */
2299   function _transferOwnership(address newOwner) internal virtual {
2300     address oldOwner = _owner;
2301     _owner = newOwner;
2302     emit OwnershipTransferred(oldOwner, newOwner);
2303   }
2304 }
2305 
2306 library Address {
2307   /**
2308    * @dev Returns true if `account` is a contract.
2309    *
2310    * [IMPORTANT]
2311    * ====
2312    * It is unsafe to assume that an address for which this function returns
2313    * false is an externally-owned account (EOA) and not a contract.
2314    *
2315    * Among others, `isContract` will return false for the following
2316    * types of addresses:
2317    *
2318    *  - an externally-owned account
2319    *  - a contract in construction
2320    *  - an address where a contract will be created
2321    *  - an address where a contract lived, but was destroyed
2322    * ====
2323    *
2324    * [IMPORTANT]
2325    * ====
2326    * You shouldn't rely on `isContract` to protect against flash loan attacks!
2327    *
2328    * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2329    * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2330    * constructor.
2331    * ====
2332    */
2333   function isContract(address account) internal view returns (bool) {
2334     // This method relies on extcodesize/address.code.length, which returns 0
2335     // for contracts in construction, since the code is only stored at the end
2336     // of the constructor execution.
2337 
2338     return account.code.length > 0;
2339   }
2340 
2341   /**
2342    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2343    * `recipient`, forwarding all available gas and reverting on errors.
2344    *
2345    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2346    * of certain opcodes, possibly making contracts go over the 2300 gas limit
2347    * imposed by `transfer`, making them unable to receive funds via
2348    * `transfer`. {sendValue} removes this limitation.
2349    *
2350    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2351    *
2352    * IMPORTANT: because control is transferred to `recipient`, care must be
2353    * taken to not create reentrancy vulnerabilities. Consider using
2354    * {ReentrancyGuard} or the
2355    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2356    */
2357   function sendValue(address payable recipient, uint256 amount) internal {
2358     require(address(this).balance >= amount, "Address: insufficient balance");
2359 
2360     (bool success, ) = recipient.call{value: amount}("");
2361     require(
2362       success,
2363       "Address: unable to send value, recipient may have reverted"
2364     );
2365   }
2366 
2367   /**
2368    * @dev Performs a Solidity function call using a low level `call`. A
2369    * plain `call` is an unsafe replacement for a function call: use this
2370    * function instead.
2371    *
2372    * If `target` reverts with a revert reason, it is bubbled up by this
2373    * function (like regular Solidity function calls).
2374    *
2375    * Returns the raw returned data. To convert to the expected return value,
2376    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2377    *
2378    * Requirements:
2379    *
2380    * - `target` must be a contract.
2381    * - calling `target` with `data` must not revert.
2382    *
2383    * _Available since v3.1._
2384    */
2385   function functionCall(address target, bytes memory data)
2386     internal
2387     returns (bytes memory)
2388   {
2389     return functionCall(target, data, "Address: low-level call failed");
2390   }
2391 
2392   /**
2393    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2394    * `errorMessage` as a fallback revert reason when `target` reverts.
2395    *
2396    * _Available since v3.1._
2397    */
2398   function functionCall(
2399     address target,
2400     bytes memory data,
2401     string memory errorMessage
2402   ) internal returns (bytes memory) {
2403     return functionCallWithValue(target, data, 0, errorMessage);
2404   }
2405 
2406   /**
2407    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2408    * but also transferring `value` wei to `target`.
2409    *
2410    * Requirements:
2411    *
2412    * - the calling contract must have an ETH balance of at least `value`.
2413    * - the called Solidity function must be `payable`.
2414    *
2415    * _Available since v3.1._
2416    */
2417   function functionCallWithValue(
2418     address target,
2419     bytes memory data,
2420     uint256 value
2421   ) internal returns (bytes memory) {
2422     return
2423       functionCallWithValue(
2424         target,
2425         data,
2426         value,
2427         "Address: low-level call with value failed"
2428       );
2429   }
2430 
2431   /**
2432    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2433    * with `errorMessage` as a fallback revert reason when `target` reverts.
2434    *
2435    * _Available since v3.1._
2436    */
2437   function functionCallWithValue(
2438     address target,
2439     bytes memory data,
2440     uint256 value,
2441     string memory errorMessage
2442   ) internal returns (bytes memory) {
2443     require(
2444       address(this).balance >= value,
2445       "Address: insufficient balance for call"
2446     );
2447     require(isContract(target), "Address: call to non-contract");
2448 
2449     (bool success, bytes memory returndata) = target.call{value: value}(data);
2450     return verifyCallResult(success, returndata, errorMessage);
2451   }
2452 
2453   /**
2454    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2455    * but performing a static call.
2456    *
2457    * _Available since v3.3._
2458    */
2459   function functionStaticCall(address target, bytes memory data)
2460     internal
2461     view
2462     returns (bytes memory)
2463   {
2464     return
2465       functionStaticCall(target, data, "Address: low-level static call failed");
2466   }
2467 
2468   /**
2469    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2470    * but performing a static call.
2471    *
2472    * _Available since v3.3._
2473    */
2474   function functionStaticCall(
2475     address target,
2476     bytes memory data,
2477     string memory errorMessage
2478   ) internal view returns (bytes memory) {
2479     require(isContract(target), "Address: static call to non-contract");
2480 
2481     (bool success, bytes memory returndata) = target.staticcall(data);
2482     return verifyCallResult(success, returndata, errorMessage);
2483   }
2484 
2485   /**
2486    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2487    * but performing a delegate call.
2488    *
2489    * _Available since v3.4._
2490    */
2491   function functionDelegateCall(address target, bytes memory data)
2492     internal
2493     returns (bytes memory)
2494   {
2495     return
2496       functionDelegateCall(
2497         target,
2498         data,
2499         "Address: low-level delegate call failed"
2500       );
2501   }
2502 
2503   /**
2504    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2505    * but performing a delegate call.
2506    *
2507    * _Available since v3.4._
2508    */
2509   function functionDelegateCall(
2510     address target,
2511     bytes memory data,
2512     string memory errorMessage
2513   ) internal returns (bytes memory) {
2514     require(isContract(target), "Address: delegate call to non-contract");
2515 
2516     (bool success, bytes memory returndata) = target.delegatecall(data);
2517     return verifyCallResult(success, returndata, errorMessage);
2518   }
2519 
2520   /**
2521    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2522    * revert reason using the provided one.
2523    *
2524    * _Available since v4.3._
2525    */
2526   function verifyCallResult(
2527     bool success,
2528     bytes memory returndata,
2529     string memory errorMessage
2530   ) internal pure returns (bytes memory) {
2531     if (success) {
2532       return returndata;
2533     } else {
2534       // Look for revert reason and bubble it up if present
2535       if (returndata.length > 0) {
2536         // The easiest way to bubble the revert reason is using memory via assembly
2537         /// @solidity memory-safe-assembly
2538         assembly {
2539           let returndata_size := mload(returndata)
2540           revert(add(32, returndata), returndata_size)
2541         }
2542       } else {
2543         revert(errorMessage);
2544       }
2545     }
2546   }
2547 }
2548 
2549 library ECDSA {
2550   enum RecoverError {
2551     NoError,
2552     InvalidSignature,
2553     InvalidSignatureLength,
2554     InvalidSignatureS,
2555     InvalidSignatureV
2556   }
2557 
2558   function _throwError(RecoverError error) private pure {
2559     if (error == RecoverError.NoError) {
2560       return; // no error: do nothing
2561     } else if (error == RecoverError.InvalidSignature) {
2562       revert("ECDSA: invalid signature");
2563     } else if (error == RecoverError.InvalidSignatureLength) {
2564       revert("ECDSA: invalid signature length");
2565     } else if (error == RecoverError.InvalidSignatureS) {
2566       revert("ECDSA: invalid signature 's' value");
2567     } else if (error == RecoverError.InvalidSignatureV) {
2568       revert("ECDSA: invalid signature 'v' value");
2569     }
2570   }
2571 
2572   /**
2573    * @dev Returns the address that signed a hashed message (`hash`) with
2574    * `signature` or error string. This address can then be used for verification purposes.
2575    *
2576    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2577    * this function rejects them by requiring the `s` value to be in the lower
2578    * half order, and the `v` value to be either 27 or 28.
2579    *
2580    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2581    * verification to be secure: it is possible to craft signatures that
2582    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2583    * this is by receiving a hash of the original message (which may otherwise
2584    * be too long), and then calling {toEthSignedMessageHash} on it.
2585    *
2586    * Documentation for signature generation:
2587    * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2588    * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2589    *
2590    * _Available since v4.3._
2591    */
2592   function tryRecover(bytes32 hash, bytes memory signature)
2593     internal
2594     pure
2595     returns (address, RecoverError)
2596   {
2597     // Check the signature length
2598     // - case 65: r,s,v signature (standard)
2599     // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
2600     if (signature.length == 65) {
2601       bytes32 r;
2602       bytes32 s;
2603       uint8 v;
2604       // ecrecover takes the signature parameters, and the only way to get them
2605       // currently is to use assembly.
2606       /// @solidity memory-safe-assembly
2607       assembly {
2608         r := mload(add(signature, 0x20))
2609         s := mload(add(signature, 0x40))
2610         v := byte(0, mload(add(signature, 0x60)))
2611       }
2612       return tryRecover(hash, v, r, s);
2613     } else if (signature.length == 64) {
2614       bytes32 r;
2615       bytes32 vs;
2616       // ecrecover takes the signature parameters, and the only way to get them
2617       // currently is to use assembly.
2618       /// @solidity memory-safe-assembly
2619       assembly {
2620         r := mload(add(signature, 0x20))
2621         vs := mload(add(signature, 0x40))
2622       }
2623       return tryRecover(hash, r, vs);
2624     } else {
2625       return (address(0), RecoverError.InvalidSignatureLength);
2626     }
2627   }
2628 
2629   /**
2630    * @dev Returns the address that signed a hashed message (`hash`) with
2631    * `signature`. This address can then be used for verification purposes.
2632    *
2633    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2634    * this function rejects them by requiring the `s` value to be in the lower
2635    * half order, and the `v` value to be either 27 or 28.
2636    *
2637    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2638    * verification to be secure: it is possible to craft signatures that
2639    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2640    * this is by receiving a hash of the original message (which may otherwise
2641    * be too long), and then calling {toEthSignedMessageHash} on it.
2642    */
2643   function recover(bytes32 hash, bytes memory signature)
2644     internal
2645     pure
2646     returns (address)
2647   {
2648     (address recovered, RecoverError error) = tryRecover(hash, signature);
2649     _throwError(error);
2650     return recovered;
2651   }
2652 
2653   /**
2654    * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2655    *
2656    * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2657    *
2658    * _Available since v4.3._
2659    */
2660   function tryRecover(
2661     bytes32 hash,
2662     bytes32 r,
2663     bytes32 vs
2664   ) internal pure returns (address, RecoverError) {
2665     bytes32 s = vs &
2666       bytes32(
2667         0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2668       );
2669     uint8 v = uint8((uint256(vs) >> 255) + 27);
2670     return tryRecover(hash, v, r, s);
2671   }
2672 
2673   /**
2674    * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2675    *
2676    * _Available since v4.2._
2677    */
2678   function recover(
2679     bytes32 hash,
2680     bytes32 r,
2681     bytes32 vs
2682   ) internal pure returns (address) {
2683     (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2684     _throwError(error);
2685     return recovered;
2686   }
2687 
2688   /**
2689    * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2690    * `r` and `s` signature fields separately.
2691    *
2692    * _Available since v4.3._
2693    */
2694   function tryRecover(
2695     bytes32 hash,
2696     uint8 v,
2697     bytes32 r,
2698     bytes32 s
2699   ) internal pure returns (address, RecoverError) {
2700     // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2701     // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2702     // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2703     // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2704     //
2705     // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2706     // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2707     // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2708     // these malleable signatures as well.
2709     if (
2710       uint256(s) >
2711       0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
2712     ) {
2713       return (address(0), RecoverError.InvalidSignatureS);
2714     }
2715     if (v != 27 && v != 28) {
2716       return (address(0), RecoverError.InvalidSignatureV);
2717     }
2718 
2719     // If the signature is valid (and not malleable), return the signer address
2720     address signer = ecrecover(hash, v, r, s);
2721     if (signer == address(0)) {
2722       return (address(0), RecoverError.InvalidSignature);
2723     }
2724 
2725     return (signer, RecoverError.NoError);
2726   }
2727 
2728   /**
2729    * @dev Overload of {ECDSA-recover} that receives the `v`,
2730    * `r` and `s` signature fields separately.
2731    */
2732   function recover(
2733     bytes32 hash,
2734     uint8 v,
2735     bytes32 r,
2736     bytes32 s
2737   ) internal pure returns (address) {
2738     (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2739     _throwError(error);
2740     return recovered;
2741   }
2742 
2743   /**
2744    * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2745    * produces hash corresponding to the one signed with the
2746    * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2747    * JSON-RPC method as part of EIP-191.
2748    *
2749    * See {recover}.
2750    */
2751   function toEthSignedMessageHash(bytes32 hash)
2752     internal
2753     pure
2754     returns (bytes32)
2755   {
2756     // 32 is the length in bytes of hash,
2757     // enforced by the type signature above
2758     return
2759       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2760   }
2761 
2762   /**
2763    * @dev Returns an Ethereum Signed Message, created from `s`. This
2764    * produces hash corresponding to the one signed with the
2765    * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2766    * JSON-RPC method as part of EIP-191.
2767    *
2768    * See {recover}.
2769    */
2770   function toEthSignedMessageHash(bytes memory s)
2771     internal
2772     pure
2773     returns (bytes32)
2774   {
2775     return
2776       keccak256(
2777         abi.encodePacked(
2778           "\x19Ethereum Signed Message:\n",
2779           Strings.toString(s.length),
2780           s
2781         )
2782       );
2783   }
2784 
2785   /**
2786    * @dev Returns an Ethereum Signed Typed Data, created from a
2787    * `domainSeparator` and a `structHash`. This produces hash corresponding
2788    * to the one signed with the
2789    * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2790    * JSON-RPC method as part of EIP-712.
2791    *
2792    * See {recover}.
2793    */
2794   function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
2795     internal
2796     pure
2797     returns (bytes32)
2798   {
2799     return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2800   }
2801 }
2802 pragma solidity ^0.8.0;
2803 
2804 /**
2805  * @dev Contract module that helps prevent reentrant calls to a function.
2806  *
2807  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2808  * available, which can be applied to functions to make sure there are no nested
2809  * (reentrant) calls to them.
2810  *
2811  * Note that because there is a single `nonReentrant` guard, functions marked as
2812  * `nonReentrant` may not call one another. This can be worked around by making
2813  * those functions `private`, and then adding `external` `nonReentrant` entry
2814  * points to them.
2815  *
2816  * TIP: If you would like to learn more about reentrancy and alternative ways
2817  * to protect against it, check out our blog post
2818  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2819  */
2820 abstract contract ReentrancyGuard {
2821     // Booleans are more expensive than uint256 or any type that takes up a full
2822     // word because each write operation emits an extra SLOAD to first read the
2823     // slot's contents, replace the bits taken up by the boolean, and then write
2824     // back. This is the compiler's defense against contract upgrades and
2825     // pointer aliasing, and it cannot be disabled.
2826 
2827     // The values being non-zero value makes deployment a bit more expensive,
2828     // but in exchange the refund on every call to nonReentrant will be lower in
2829     // amount. Since refunds are capped to a percentage of the total
2830     // transaction's gas, it is best to keep them low in cases like this one, to
2831     // increase the likelihood of the full refund coming into effect.
2832     uint256 private constant _NOT_ENTERED = 1;
2833     uint256 private constant _ENTERED = 2;
2834 
2835     uint256 private _status;
2836 
2837     constructor() {
2838         _status = _NOT_ENTERED;
2839     }
2840 
2841     /**
2842      * @dev Prevents a contract from calling itself, directly or indirectly.
2843      * Calling a `nonReentrant` function from another `nonReentrant`
2844      * function is not supported. It is possible to prevent this from happening
2845      * by making the `nonReentrant` function external, and making it call a
2846      * `private` function that does the actual work.
2847      */
2848     modifier nonReentrant() {
2849         _nonReentrantBefore();
2850         _;
2851         _nonReentrantAfter();
2852     }
2853 
2854     function _nonReentrantBefore() private {
2855         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2856         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2857 
2858         // Any calls to nonReentrant after this point will fail
2859         _status = _ENTERED;
2860     }
2861 
2862     function _nonReentrantAfter() private {
2863         // By storing the original value once again, a refund is triggered (see
2864         // https://eips.ethereum.org/EIPS/eip-2200)
2865         _status = _NOT_ENTERED;
2866     }
2867 
2868     /**
2869      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
2870      * `nonReentrant` function in the call stack.
2871      */
2872     function _reentrancyGuardEntered() internal view returns (bool) {
2873         return _status == _ENTERED;
2874     }
2875 }
2876 
2877 contract DigiMiners is ERC721A, Ownable, ReentrancyGuard {
2878 
2879   using SafeMath for uint256;
2880   using ECDSA for bytes32;
2881 
2882   using EnumerableSet for EnumerableSet.UintSet;
2883   uint256 public ALLOWLIST_SALE_START_TIME;
2884   uint256 public ALLOWLIST_SALE_END_TIME;
2885   uint256 public PUBLIC_SALE_START_TIME;
2886   uint256 public PUBLIC_SALE_END_TIME;
2887 
2888   uint256 public MAX_SUPPLY = 10000;
2889   uint256 public allowListLimitPerwallet = 1;
2890   uint256 public allowListLimit = 2500;
2891   uint256 public totalAllowlistMinted;
2892   uint256 public totalPublicMinted;
2893   uint256 public MAX_PUBLIC_LIMIT;
2894 
2895   bytes32 public root;
2896 
2897   address private _signerAddress;
2898 
2899   string private baseURI_;
2900 
2901   mapping(address => uint256) private allowlistMinted;
2902   mapping(address => bool) private publicMinted;
2903   mapping (address => EnumerableSet.UintSet) private _holderTokens;
2904   mapping(bytes=>bool) public signUsed;
2905   event AllowListSaleTimeChanged(uint256 startTime, uint256 endTime);
2906   event PublicSaleTimeChanged(uint256 startTime, uint256 endTime);
2907 
2908   constructor() ERC721A("DigiMiners", "$MINE") {
2909     _signerAddress = 0xc37CF7E6573C6fEf0fDeE4aB0115f20E5B24e0b7;
2910   }
2911 
2912 
2913   function _baseURI() internal view virtual override returns (string memory) {
2914     return baseURI_;
2915   }
2916 
2917   function setBaseURI(string memory URI) public onlyOwner {
2918     baseURI_ = URI;
2919   }
2920   
2921 
2922   function whenAllowlistSaleIsOn() public view returns (bool) {
2923     if (
2924       block.timestamp > ALLOWLIST_SALE_START_TIME &&
2925       block.timestamp < ALLOWLIST_SALE_END_TIME
2926     ) {
2927       return true;
2928     } else {
2929       return false;
2930     }
2931   }
2932 
2933   function whenPublicSaleIsOn() public view returns (bool) {
2934     if (
2935       block.timestamp > PUBLIC_SALE_START_TIME &&
2936       block.timestamp < PUBLIC_SALE_END_TIME
2937     ) {
2938       return true;
2939     } else {
2940       return false;
2941     }
2942   }
2943 
2944   function setPublicLimit(uint256 _limit) public onlyOwner {
2945     MAX_PUBLIC_LIMIT = _limit;
2946   }
2947 
2948   function checkAllowListMinted(address _wallet) public view returns (uint256) {
2949     return allowlistMinted[_wallet];
2950   }
2951 
2952   function checkPublicMinted(address _wallet) public view returns (bool) {
2953     return publicMinted[_wallet];
2954   }
2955 
2956   function setSigner(address _signer) public onlyOwner {
2957     _signerAddress = _signer;
2958   }
2959 
2960   function setAllowlistLimit(uint256 _limit) public onlyOwner {
2961     allowListLimit = _limit;
2962   }
2963 
2964   function startAllowlistPhase(uint256 startTime, uint256 endTime)
2965     public
2966     onlyOwner
2967   {
2968     ALLOWLIST_SALE_START_TIME = startTime;
2969     ALLOWLIST_SALE_END_TIME = endTime;
2970     emit AllowListSaleTimeChanged(startTime, endTime);
2971   }
2972 
2973   function changePublicSaleTime(uint256 startTime, uint256 endTime)
2974     public
2975     onlyOwner
2976   {
2977     PUBLIC_SALE_START_TIME = startTime;
2978     PUBLIC_SALE_END_TIME = endTime;
2979     emit PublicSaleTimeChanged(startTime, endTime);
2980   }
2981 
2982   function allowListMint(bytes32[] calldata proof) public nonReentrant {
2983     require(whenAllowlistSaleIsOn() == true, "DIGI: Allowlist Sale Not Started Yet");
2984     require(
2985       isValid(proof, keccak256(abi.encodePacked(msg.sender))) == true,
2986       "DIGI: Not a Part of Allowlist"
2987     );
2988     allowlistMinted[msg.sender] += 1;
2989     require(
2990       allowlistMinted[msg.sender] <= allowListLimitPerwallet,
2991       "DIGI: You Already Minted Enough"
2992     );
2993     totalAllowlistMinted += 1;
2994     require(
2995       totalAllowlistMinted <= allowListLimit,
2996       "DIGI: Allowlist Limit Reached "
2997     );
2998     require(totalSupply().add(1) <= MAX_SUPPLY, "DIGI: Exceeding Max Limit");
2999     _safeMint(msg.sender, 1);
3000   }
3001 
3002   function publicMint(bytes calldata signature) public nonReentrant {
3003     require(whenPublicSaleIsOn() == true, "DIGI: Public Sale Not Started Yet");
3004     require(publicMinted[msg.sender] == false, "DIGI: You Already minted");
3005     publicMinted[msg.sender] = true;
3006     require(signUsed[signature]==false, "DIGI: Signature is Used");
3007     require(
3008       _signerAddress == checkSign(signature, msg.sender), "DIGI: Invalid Signature"
3009     );
3010     signUsed[signature] = true;
3011     totalPublicMinted += 1;
3012     require(totalPublicMinted <= MAX_PUBLIC_LIMIT, "DIGI: Public Limit Reached");
3013     require(totalSupply().add(1) <= MAX_SUPPLY, "DIGI: Exceeding Max Limit");
3014     _safeMint(msg.sender, 1);
3015   }
3016   
3017   function checkSign(bytes calldata signature, address wallet) public pure returns(address) {
3018     return
3019         keccak256(
3020           abi.encodePacked(
3021             "\x19Ethereum Signed Message:\n32",
3022             keccak256(abi.encodePacked(wallet))
3023           )
3024         ).recover(signature);
3025   }
3026 
3027   function getSignData(address wallet) public pure returns(bytes32){
3028        return keccak256(abi.encodePacked(wallet));
3029   }
3030 
3031   function ownerMint(uint256 quantity) public onlyOwner {
3032     require(totalSupply().add(quantity) <= MAX_SUPPLY, "DIGI: Exceeding Max Limit");
3033     _safeMint(msg.sender, quantity);
3034   }
3035 
3036   function isValid(bytes32[] memory proof, bytes32 leaf)
3037     public
3038     view
3039     returns (bool)
3040   {
3041     return MerkleProof.verify(proof, root, leaf);
3042   }
3043 
3044 
3045   function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
3046         return _holderTokens[owner].at(index);
3047   }
3048 
3049   function getTokenHolding(address owner) public view returns(uint256[] memory) {
3050     uint256 len = _holderTokens[owner].length();
3051     uint256[] memory tokens = new uint256[](len);
3052     for(uint256 i=0;i<len;i++){
3053       uint256 tokenId = tokenOfOwnerByIndex(owner,i);
3054       tokens[i] = tokenId;
3055     }
3056     return tokens;
3057   }
3058 
3059 
3060   function _beforeTokenTransfers(
3061     address from,
3062     address to,
3063     uint256 startTokenId,
3064     uint256 quantity
3065   ) internal virtual override {
3066     for(uint256 i = 0;i<quantity;i++){
3067       if(from!=address(0)){
3068         _holderTokens[from].remove(startTokenId.add(i));
3069       }
3070         _holderTokens[to].add(startTokenId.add(i));
3071     }
3072   }
3073 
3074 
3075   function setRoot(bytes32 _root) public onlyOwner {
3076     root = _root;
3077   }
3078 
3079   function withdraw() public onlyOwner {
3080     payable(owner()).transfer(balanceOf(address(this)));
3081   }
3082 }