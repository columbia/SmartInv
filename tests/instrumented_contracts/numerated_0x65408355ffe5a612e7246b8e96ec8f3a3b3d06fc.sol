1 //SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Library for managing
10  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
11  * types.
12  *
13  * Sets have the following properties:
14  *
15  * - Elements are added, removed, and checked for existence in constant time
16  * (O(1)).
17  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
18  *
19  * ```
20  * contract Example {
21  *     // Add the library methods
22  *     using EnumerableSet for EnumerableSet.AddressSet;
23  *
24  *     // Declare a set state variable
25  *     EnumerableSet.AddressSet private mySet;
26  * }
27  * ```
28  *
29  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
30  * and `uint256` (`UintSet`) are supported.
31  */
32 library EnumerableSet {
33     // To implement this library for multiple types with as little code
34     // repetition as possible, we write it in terms of a generic Set type with
35     // bytes32 values.
36     // The Set implementation uses private functions, and user-facing
37     // implementations (such as AddressSet) are just wrappers around the
38     // underlying Set.
39     // This means that we can only create new EnumerableSets for types that fit
40     // in bytes32.
41 
42     struct Set {
43         // Storage of set values
44         bytes32[] _values;
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping(bytes32 => uint256) _indexes;
48     }
49 
50     /**
51      * @dev Add a value to a set. O(1).
52      *
53      * Returns true if the value was added to the set, that is if it was not
54      * already present.
55      */
56     function _add(Set storage set, bytes32 value) private returns (bool) {
57         if (!_contains(set, value)) {
58             set._values.push(value);
59             // The value is stored at length-1, but we add 1 to all indexes
60             // and use 0 as a sentinel value
61             set._indexes[value] = set._values.length;
62             return true;
63         } else {
64             return false;
65         }
66     }
67 
68     /**
69      * @dev Removes a value from a set. O(1).
70      *
71      * Returns true if the value was removed from the set, that is if it was
72      * present.
73      */
74     function _remove(Set storage set, bytes32 value) private returns (bool) {
75         // We read and store the value's index to prevent multiple reads from the same storage slot
76         uint256 valueIndex = set._indexes[value];
77 
78         if (valueIndex != 0) {
79             // Equivalent to contains(set, value)
80             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
81             // the array, and then remove the last element (sometimes called as 'swap and pop').
82             // This modifies the order of the array, as noted in {at}.
83 
84             uint256 toDeleteIndex = valueIndex - 1;
85             uint256 lastIndex = set._values.length - 1;
86 
87             if (lastIndex != toDeleteIndex) {
88                 bytes32 lastValue = set._values[lastIndex];
89 
90                 // Move the last value to the index where the value to delete is
91                 set._values[toDeleteIndex] = lastValue;
92                 // Update the index for the moved value
93                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
94             }
95 
96             // Delete the slot where the moved value was stored
97             set._values.pop();
98 
99             // Delete the index for the deleted slot
100             delete set._indexes[value];
101 
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     /**
109      * @dev Returns true if the value is in the set. O(1).
110      */
111     function _contains(Set storage set, bytes32 value)
112         private
113         view
114         returns (bool)
115     {
116         return set._indexes[value] != 0;
117     }
118 
119     /**
120      * @dev Returns the number of values on the set. O(1).
121      */
122     function _length(Set storage set) private view returns (uint256) {
123         return set._values.length;
124     }
125 
126     /**
127      * @dev Returns the value stored at position `index` in the set. O(1).
128      *
129      * Note that there are no guarantees on the ordering of values inside the
130      * array, and it may change when more values are added or removed.
131      *
132      * Requirements:
133      *
134      * - `index` must be strictly less than {length}.
135      */
136     function _at(Set storage set, uint256 index)
137         private
138         view
139         returns (bytes32)
140     {
141         return set._values[index];
142     }
143 
144     /**
145      * @dev Return the entire set in an array
146      *
147      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
148      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
149      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
150      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
151      */
152     function _values(Set storage set) private view returns (bytes32[] memory) {
153         return set._values;
154     }
155 
156     // Bytes32Set
157 
158     struct Bytes32Set {
159         Set _inner;
160     }
161 
162     /**
163      * @dev Add a value to a set. O(1).
164      *
165      * Returns true if the value was added to the set, that is if it was not
166      * already present.
167      */
168     function add(Bytes32Set storage set, bytes32 value)
169         internal
170         returns (bool)
171     {
172         return _add(set._inner, value);
173     }
174 
175     /**
176      * @dev Removes a value from a set. O(1).
177      *
178      * Returns true if the value was removed from the set, that is if it was
179      * present.
180      */
181     function remove(Bytes32Set storage set, bytes32 value)
182         internal
183         returns (bool)
184     {
185         return _remove(set._inner, value);
186     }
187 
188     /**
189      * @dev Returns true if the value is in the set. O(1).
190      */
191     function contains(Bytes32Set storage set, bytes32 value)
192         internal
193         view
194         returns (bool)
195     {
196         return _contains(set._inner, value);
197     }
198 
199     /**
200      * @dev Returns the number of values in the set. O(1).
201      */
202     function length(Bytes32Set storage set) internal view returns (uint256) {
203         return _length(set._inner);
204     }
205 
206     /**
207      * @dev Returns the value stored at position `index` in the set. O(1).
208      *
209      * Note that there are no guarantees on the ordering of values inside the
210      * array, and it may change when more values are added or removed.
211      *
212      * Requirements:
213      *
214      * - `index` must be strictly less than {length}.
215      */
216     function at(Bytes32Set storage set, uint256 index)
217         internal
218         view
219         returns (bytes32)
220     {
221         return _at(set._inner, index);
222     }
223 
224     /**
225      * @dev Return the entire set in an array
226      *
227      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
228      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
229      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
230      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
231      */
232     function values(Bytes32Set storage set)
233         internal
234         view
235         returns (bytes32[] memory)
236     {
237         return _values(set._inner);
238     }
239 
240     // AddressSet
241 
242     struct AddressSet {
243         Set _inner;
244     }
245 
246     /**
247      * @dev Add a value to a set. O(1).
248      *
249      * Returns true if the value was added to the set, that is if it was not
250      * already present.
251      */
252     function add(AddressSet storage set, address value)
253         internal
254         returns (bool)
255     {
256         return _add(set._inner, bytes32(uint256(uint160(value))));
257     }
258 
259     /**
260      * @dev Removes a value from a set. O(1).
261      *
262      * Returns true if the value was removed from the set, that is if it was
263      * present.
264      */
265     function remove(AddressSet storage set, address value)
266         internal
267         returns (bool)
268     {
269         return _remove(set._inner, bytes32(uint256(uint160(value))));
270     }
271 
272     /**
273      * @dev Returns true if the value is in the set. O(1).
274      */
275     function contains(AddressSet storage set, address value)
276         internal
277         view
278         returns (bool)
279     {
280         return _contains(set._inner, bytes32(uint256(uint160(value))));
281     }
282 
283     /**
284      * @dev Returns the number of values in the set. O(1).
285      */
286     function length(AddressSet storage set) internal view returns (uint256) {
287         return _length(set._inner);
288     }
289 
290     /**
291      * @dev Returns the value stored at position `index` in the set. O(1).
292      *
293      * Note that there are no guarantees on the ordering of values inside the
294      * array, and it may change when more values are added or removed.
295      *
296      * Requirements:
297      *
298      * - `index` must be strictly less than {length}.
299      */
300     function at(AddressSet storage set, uint256 index)
301         internal
302         view
303         returns (address)
304     {
305         return address(uint160(uint256(_at(set._inner, index))));
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
316     function values(AddressSet storage set)
317         internal
318         view
319         returns (address[] memory)
320     {
321         bytes32[] memory store = _values(set._inner);
322         address[] memory result;
323 
324         assembly {
325             result := store
326         }
327 
328         return result;
329     }
330 
331     // UintSet
332 
333     struct UintSet {
334         Set _inner;
335     }
336 
337     /**
338      * @dev Add a value to a set. O(1).
339      *
340      * Returns true if the value was added to the set, that is if it was not
341      * already present.
342      */
343     function add(UintSet storage set, uint256 value) internal returns (bool) {
344         return _add(set._inner, bytes32(value));
345     }
346 
347     /**
348      * @dev Removes a value from a set. O(1).
349      *
350      * Returns true if the value was removed from the set, that is if it was
351      * present.
352      */
353     function remove(UintSet storage set, uint256 value)
354         internal
355         returns (bool)
356     {
357         return _remove(set._inner, bytes32(value));
358     }
359 
360     /**
361      * @dev Returns true if the value is in the set. O(1).
362      */
363     function contains(UintSet storage set, uint256 value)
364         internal
365         view
366         returns (bool)
367     {
368         return _contains(set._inner, bytes32(value));
369     }
370 
371     /**
372      * @dev Returns the number of values on the set. O(1).
373      */
374     function length(UintSet storage set) internal view returns (uint256) {
375         return _length(set._inner);
376     }
377 
378     /**
379      * @dev Returns the value stored at position `index` in the set. O(1).
380      *
381      * Note that there are no guarantees on the ordering of values inside the
382      * array, and it may change when more values are added or removed.
383      *
384      * Requirements:
385      *
386      * - `index` must be strictly less than {length}.
387      */
388     function at(UintSet storage set, uint256 index)
389         internal
390         view
391         returns (uint256)
392     {
393         return uint256(_at(set._inner, index));
394     }
395 
396     /**
397      * @dev Return the entire set in an array
398      *
399      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
400      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
401      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
402      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
403      */
404     function values(UintSet storage set)
405         internal
406         view
407         returns (uint256[] memory)
408     {
409         bytes32[] memory store = _values(set._inner);
410         uint256[] memory result;
411 
412         assembly {
413             result := store
414         }
415 
416         return result;
417     }
418 }
419 
420 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
421 
422 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev Interface of the ERC165 standard, as defined in the
428  * https://eips.ethereum.org/EIPS/eip-165[EIP].
429  *
430  * Implementers can declare support of contract interfaces, which can then be
431  * queried by others ({ERC165Checker}).
432  *
433  * For an implementation, see {ERC165}.
434  */
435 interface IERC165 {
436     /**
437      * @dev Returns true if this contract implements the interface defined by
438      * `interfaceId`. See the corresponding
439      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
440      * to learn more about how these ids are created.
441      *
442      * This function call must use less than 30 000 gas.
443      */
444     function supportsInterface(bytes4 interfaceId) external view returns (bool);
445 }
446 
447 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
448 
449 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Required interface of an ERC721 compliant contract.
455  */
456 interface IERC721 is IERC165 {
457     /**
458      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
459      */
460     event Transfer(
461         address indexed from,
462         address indexed to,
463         uint256 indexed tokenId
464     );
465 
466     /**
467      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
468      */
469     event Approval(
470         address indexed owner,
471         address indexed approved,
472         uint256 indexed tokenId
473     );
474 
475     /**
476      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
477      */
478     event ApprovalForAll(
479         address indexed owner,
480         address indexed operator,
481         bool approved
482     );
483 
484     /**
485      * @dev Returns the number of tokens in ``owner``'s account.
486      */
487     function balanceOf(address owner) external view returns (uint256 balance);
488 
489     /**
490      * @dev Returns the owner of the `tokenId` token.
491      *
492      * Requirements:
493      *
494      * - `tokenId` must exist.
495      */
496     function ownerOf(uint256 tokenId) external view returns (address owner);
497 
498     /**
499      * @dev Safely transfers `tokenId` token from `from` to `to`.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId,
515         bytes calldata data
516     ) external;
517 
518     /**
519      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
520      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId
536     ) external;
537 
538     /**
539      * @dev Transfers `tokenId` token from `from` to `to`.
540      *
541      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
542      *
543      * Requirements:
544      *
545      * - `from` cannot be the zero address.
546      * - `to` cannot be the zero address.
547      * - `tokenId` token must be owned by `from`.
548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
549      *
550      * Emits a {Transfer} event.
551      */
552     function transferFrom(
553         address from,
554         address to,
555         uint256 tokenId
556     ) external;
557 
558     /**
559      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
560      * The approval is cleared when the token is transferred.
561      *
562      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
563      *
564      * Requirements:
565      *
566      * - The caller must own the token or be an approved operator.
567      * - `tokenId` must exist.
568      *
569      * Emits an {Approval} event.
570      */
571     function approve(address to, uint256 tokenId) external;
572 
573     /**
574      * @dev Approve or remove `operator` as an operator for the caller.
575      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
576      *
577      * Requirements:
578      *
579      * - The `operator` cannot be the caller.
580      *
581      * Emits an {ApprovalForAll} event.
582      */
583     function setApprovalForAll(address operator, bool _approved) external;
584 
585     /**
586      * @dev Returns the account approved for `tokenId` token.
587      *
588      * Requirements:
589      *
590      * - `tokenId` must exist.
591      */
592     function getApproved(uint256 tokenId)
593         external
594         view
595         returns (address operator);
596 
597     /**
598      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
599      *
600      * See {setApprovalForAll}
601      */
602     function isApprovedForAll(address owner, address operator)
603         external
604         view
605         returns (bool);
606 }
607 
608 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
609 
610 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @title ERC721 token receiver interface
616  * @dev Interface for any contract that wants to support safeTransfers
617  * from ERC721 asset contracts.
618  */
619 interface IERC721Receiver {
620     /**
621      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
622      * by `operator` from `from`, this function is called.
623      *
624      * It must return its Solidity selector to confirm the token transfer.
625      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
626      *
627      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
628      */
629     function onERC721Received(
630         address operator,
631         address from,
632         uint256 tokenId,
633         bytes calldata data
634     ) external returns (bytes4);
635 }
636 
637 // File: contracts/IPermissions.sol
638 
639 pragma solidity ^0.8.0;
640 
641 interface IPermissions {
642     function isWhitelisted(address user) external view returns (bool);
643 
644     function buyLimit(address user) external view returns (uint256);
645 }
646 // File: @chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol
647 
648 pragma solidity ^0.8.0;
649 
650 /** ****************************************************************************
651  * @notice Interface for contracts using VRF randomness
652  * *****************************************************************************
653  * @dev PURPOSE
654  *
655  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
656  * @dev to Vera the verifier in such a way that Vera can be sure he's not
657  * @dev making his output up to suit himself. Reggie provides Vera a public key
658  * @dev to which he knows the secret key. Each time Vera provides a seed to
659  * @dev Reggie, he gives back a value which is computed completely
660  * @dev deterministically from the seed and the secret key.
661  *
662  * @dev Reggie provides a proof by which Vera can verify that the output was
663  * @dev correctly computed once Reggie tells it to her, but without that proof,
664  * @dev the output is indistinguishable to her from a uniform random sample
665  * @dev from the output space.
666  *
667  * @dev The purpose of this contract is to make it easy for unrelated contracts
668  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
669  * @dev simple access to a verifiable source of randomness. It ensures 2 things:
670  * @dev 1. The fulfillment came from the VRFCoordinator
671  * @dev 2. The consumer contract implements fulfillRandomWords.
672  * *****************************************************************************
673  * @dev USAGE
674  *
675  * @dev Calling contracts must inherit from VRFConsumerBase, and can
676  * @dev initialize VRFConsumerBase's attributes in their constructor as
677  * @dev shown:
678  *
679  * @dev   contract VRFConsumer {
680  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
681  * @dev       VRFConsumerBase(_vrfCoordinator) public {
682  * @dev         <initialization with other arguments goes here>
683  * @dev       }
684  * @dev   }
685  *
686  * @dev The oracle will have given you an ID for the VRF keypair they have
687  * @dev committed to (let's call it keyHash). Create subscription, fund it
688  * @dev and your consumer contract as a consumer of it (see VRFCoordinatorInterface
689  * @dev subscription management functions).
690  * @dev Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
691  * @dev callbackGasLimit, numWords),
692  * @dev see (VRFCoordinatorInterface for a description of the arguments).
693  *
694  * @dev Once the VRFCoordinator has received and validated the oracle's response
695  * @dev to your request, it will call your contract's fulfillRandomWords method.
696  *
697  * @dev The randomness argument to fulfillRandomWords is a set of random words
698  * @dev generated from your requestId and the blockHash of the request.
699  *
700  * @dev If your contract could have concurrent requests open, you can use the
701  * @dev requestId returned from requestRandomWords to track which response is associated
702  * @dev with which randomness request.
703  * @dev See "SECURITY CONSIDERATIONS" for principles to keep in mind,
704  * @dev if your contract could have multiple requests in flight simultaneously.
705  *
706  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
707  * @dev differ.
708  *
709  * *****************************************************************************
710  * @dev SECURITY CONSIDERATIONS
711  *
712  * @dev A method with the ability to call your fulfillRandomness method directly
713  * @dev could spoof a VRF response with any random value, so it's critical that
714  * @dev it cannot be directly called by anything other than this base contract
715  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
716  *
717  * @dev For your users to trust that your contract's random behavior is free
718  * @dev from malicious interference, it's best if you can write it so that all
719  * @dev behaviors implied by a VRF response are executed *during* your
720  * @dev fulfillRandomness method. If your contract must store the response (or
721  * @dev anything derived from it) and use it later, you must ensure that any
722  * @dev user-significant behavior which depends on that stored value cannot be
723  * @dev manipulated by a subsequent VRF request.
724  *
725  * @dev Similarly, both miners and the VRF oracle itself have some influence
726  * @dev over the order in which VRF responses appear on the blockchain, so if
727  * @dev your contract could have multiple VRF requests in flight simultaneously,
728  * @dev you must ensure that the order in which the VRF responses arrive cannot
729  * @dev be used to manipulate your contract's user-significant behavior.
730  *
731  * @dev Since the block hash of the block which contains the requestRandomness
732  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
733  * @dev miner could, in principle, fork the blockchain to evict the block
734  * @dev containing the request, forcing the request to be included in a
735  * @dev different block with a different hash, and therefore a different input
736  * @dev to the VRF. However, such an attack would incur a substantial economic
737  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
738  * @dev until it calls responds to a request. It is for this reason that
739  * @dev that you can signal to an oracle you'd like them to wait longer before
740  * @dev responding to the request (however this is not enforced in the contract
741  * @dev and so remains effective only in the case of unmodified oracle software).
742  */
743 abstract contract VRFConsumerBaseV2 {
744     error OnlyCoordinatorCanFulfill(address have, address want);
745     address private immutable vrfCoordinator;
746 
747     /**
748      * @param _vrfCoordinator address of VRFCoordinator contract
749      */
750     constructor(address _vrfCoordinator) {
751         vrfCoordinator = _vrfCoordinator;
752     }
753 
754     /**
755      * @notice fulfillRandomness handles the VRF response. Your contract must
756      * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
757      * @notice principles to keep in mind when implementing your fulfillRandomness
758      * @notice method.
759      *
760      * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
761      * @dev signature, and will call it once it has verified the proof
762      * @dev associated with the randomness. (It is triggered via a call to
763      * @dev rawFulfillRandomness, below.)
764      *
765      * @param requestId The Id initially returned by requestRandomness
766      * @param randomWords the VRF output expanded to the requested number of words
767      */
768     function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
769         internal
770         virtual;
771 
772     // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
773     // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
774     // the origin of the call
775     function rawFulfillRandomWords(
776         uint256 requestId,
777         uint256[] memory randomWords
778     ) external {
779         if (msg.sender != vrfCoordinator) {
780             revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
781         }
782         fulfillRandomWords(requestId, randomWords);
783     }
784 }
785 
786 // File: @chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol
787 
788 pragma solidity ^0.8.0;
789 
790 interface VRFCoordinatorV2Interface {
791     /**
792      * @notice Get configuration relevant for making requests
793      * @return minimumRequestConfirmations global min for request confirmations
794      * @return maxGasLimit global max for request gas limit
795      * @return s_provingKeyHashes list of registered key hashes
796      */
797     function getRequestConfig()
798         external
799         view
800         returns (
801             uint16,
802             uint32,
803             bytes32[] memory
804         );
805 
806     /**
807      * @notice Request a set of random words.
808      * @param keyHash - Corresponds to a particular oracle job which uses
809      * that key for generating the VRF proof. Different keyHash's have different gas price
810      * ceilings, so you can select a specific one to bound your maximum per request cost.
811      * @param subId  - The ID of the VRF subscription. Must be funded
812      * with the minimum subscription balance required for the selected keyHash.
813      * @param minimumRequestConfirmations - How many blocks you'd like the
814      * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
815      * for why you may want to request more. The acceptable range is
816      * [minimumRequestBlockConfirmations, 200].
817      * @param callbackGasLimit - How much gas you'd like to receive in your
818      * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
819      * may be slightly less than this amount because of gas used calling the function
820      * (argument decoding etc.), so you may need to request slightly more than you expect
821      * to have inside fulfillRandomWords. The acceptable range is
822      * [0, maxGasLimit]
823      * @param numWords - The number of uint256 random values you'd like to receive
824      * in your fulfillRandomWords callback. Note these numbers are expanded in a
825      * secure way by the VRFCoordinator from a single random value supplied by the oracle.
826      * @return requestId - A unique identifier of the request. Can be used to match
827      * a request to a response in fulfillRandomWords.
828      */
829     function requestRandomWords(
830         bytes32 keyHash,
831         uint64 subId,
832         uint16 minimumRequestConfirmations,
833         uint32 callbackGasLimit,
834         uint32 numWords
835     ) external returns (uint256 requestId);
836 
837     /**
838      * @notice Create a VRF subscription.
839      * @return subId - A unique subscription id.
840      * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
841      * @dev Note to fund the subscription, use transferAndCall. For example
842      * @dev  LINKTOKEN.transferAndCall(
843      * @dev    address(COORDINATOR),
844      * @dev    amount,
845      * @dev    abi.encode(subId));
846      */
847     function createSubscription() external returns (uint64 subId);
848 
849     /**
850      * @notice Get a VRF subscription.
851      * @param subId - ID of the subscription
852      * @return balance - LINK balance of the subscription in juels.
853      * @return reqCount - number of requests for this subscription, determines fee tier.
854      * @return owner - owner of the subscription.
855      * @return consumers - list of consumer address which are able to use this subscription.
856      */
857     function getSubscription(uint64 subId)
858         external
859         view
860         returns (
861             uint96 balance,
862             uint64 reqCount,
863             address owner,
864             address[] memory consumers
865         );
866 
867     /**
868      * @notice Request subscription owner transfer.
869      * @param subId - ID of the subscription
870      * @param newOwner - proposed new owner of the subscription
871      */
872     function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner)
873         external;
874 
875     /**
876      * @notice Request subscription owner transfer.
877      * @param subId - ID of the subscription
878      * @dev will revert if original owner of subId has
879      * not requested that msg.sender become the new owner.
880      */
881     function acceptSubscriptionOwnerTransfer(uint64 subId) external;
882 
883     /**
884      * @notice Add a consumer to a VRF subscription.
885      * @param subId - ID of the subscription
886      * @param consumer - New consumer which can use the subscription
887      */
888     function addConsumer(uint64 subId, address consumer) external;
889 
890     /**
891      * @notice Remove a consumer from a VRF subscription.
892      * @param subId - ID of the subscription
893      * @param consumer - Consumer to remove from the subscription
894      */
895     function removeConsumer(uint64 subId, address consumer) external;
896 
897     /**
898      * @notice Cancel a subscription
899      * @param subId - ID of the subscription
900      * @param to - Where to send the remaining LINK to
901      */
902     function cancelSubscription(uint64 subId, address to) external;
903 }
904 
905 // File: @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol
906 
907 pragma solidity ^0.8.0;
908 
909 interface LinkTokenInterface {
910     function allowance(address owner, address spender)
911         external
912         view
913         returns (uint256 remaining);
914 
915     function approve(address spender, uint256 value)
916         external
917         returns (bool success);
918 
919     function balanceOf(address owner) external view returns (uint256 balance);
920 
921     function decimals() external view returns (uint8 decimalPlaces);
922 
923     function decreaseApproval(address spender, uint256 addedValue)
924         external
925         returns (bool success);
926 
927     function increaseApproval(address spender, uint256 subtractedValue)
928         external;
929 
930     function name() external view returns (string memory tokenName);
931 
932     function symbol() external view returns (string memory tokenSymbol);
933 
934     function totalSupply() external view returns (uint256 totalTokensIssued);
935 
936     function transfer(address to, uint256 value)
937         external
938         returns (bool success);
939 
940     function transferAndCall(
941         address to,
942         uint256 value,
943         bytes calldata data
944     ) external returns (bool success);
945 
946     function transferFrom(
947         address from,
948         address to,
949         uint256 value
950     ) external returns (bool success);
951 }
952 
953 // File: contracts/SortitionSumTreeFactory.sol
954 
955 /**
956  *  @authors: [@epiqueras]
957  *  @reviewers: [@clesaege, @unknownunknown1, @ferittuncer, @remedcu, @shalzz]
958  *  @auditors: []
959  *  @bounties: [{ duration: 28 days, link: https://github.com/kleros/kleros/issues/115, maxPayout: 50 ETH }]
960  *  @deployments: [ https://etherscan.io/address/0x180eba68d164c3f8c3f6dc354125ebccf4dfcb86 ]
961  */
962 
963 pragma solidity ^0.8.6;
964 
965 library SortitionSumTreeFactory {
966     /* Structs */
967 
968     struct SortitionSumTree {
969         uint256 K; // The maximum number of childs per node.
970         // We use this to keep track of vacant positions in the tree after removing a leaf. This is for keeping the tree as balanced as possible without spending gas on moving nodes around.
971         uint256[] stack;
972         uint256[] nodes;
973         // Two-way mapping of IDs to node indexes. Note that node index 0 is reserved for the root node, and means the ID does not have a node.
974         mapping(bytes32 => uint256) IDsToNodeIndexes;
975         mapping(uint256 => bytes32) nodeIndexesToIDs;
976     }
977 
978     /* Storage */
979 
980     struct SortitionSumTrees {
981         mapping(bytes32 => SortitionSumTree) sortitionSumTrees;
982     }
983 
984     /* internal */
985 
986     /**
987      *  @dev Create a sortition sum tree at the specified key.
988      *  @param _key The key of the new tree.
989      *  @param _K The number of children each node in the tree should have.
990      */
991     function createTree(
992         SortitionSumTrees storage self,
993         bytes32 _key,
994         uint256 _K
995     ) internal {
996         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
997         require(tree.K == 0, "Tree already exists.");
998         require(_K > 1, "K must be greater than one.");
999         tree.K = _K;
1000         tree.stack = new uint256[](0);
1001         tree.nodes = new uint256[](0);
1002         tree.nodes.push(0);
1003     }
1004 
1005     /**
1006      *  @dev Set a value of a tree.
1007      *  @param _key The key of the tree.
1008      *  @param _value The new value.
1009      *  @param _ID The ID of the value.
1010      *  `O(log_k(n))` where
1011      *  `k` is the maximum number of childs per node in the tree,
1012      *   and `n` is the maximum number of nodes ever appended.
1013      */
1014     function set(
1015         SortitionSumTrees storage self,
1016         bytes32 _key,
1017         uint256 _value,
1018         bytes32 _ID
1019     ) internal {
1020         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1021         uint256 treeIndex = tree.IDsToNodeIndexes[_ID];
1022 
1023         if (treeIndex == 0) {
1024             // No existing node.
1025             if (_value != 0) {
1026                 // Non zero value.
1027                 // Append.
1028                 // Add node.
1029                 if (tree.stack.length == 0) {
1030                     // No vacant spots.
1031                     // Get the index and append the value.
1032                     treeIndex = tree.nodes.length;
1033                     tree.nodes.push(_value);
1034 
1035                     // Potentially append a new node and make the parent a sum node.
1036                     if (treeIndex != 1 && (treeIndex - 1) % tree.K == 0) {
1037                         // Is first child.
1038                         uint256 parentIndex = treeIndex / tree.K;
1039                         bytes32 parentID = tree.nodeIndexesToIDs[parentIndex];
1040                         uint256 newIndex = treeIndex + 1;
1041                         tree.nodes.push(tree.nodes[parentIndex]);
1042                         delete tree.nodeIndexesToIDs[parentIndex];
1043                         tree.IDsToNodeIndexes[parentID] = newIndex;
1044                         tree.nodeIndexesToIDs[newIndex] = parentID;
1045                     }
1046                 } else {
1047                     // Some vacant spot.
1048                     // Pop the stack and append the value.
1049                     treeIndex = tree.stack[tree.stack.length - 1];
1050                     tree.stack.pop();
1051                     tree.nodes[treeIndex] = _value;
1052                 }
1053 
1054                 // Add label.
1055                 tree.IDsToNodeIndexes[_ID] = treeIndex;
1056                 tree.nodeIndexesToIDs[treeIndex] = _ID;
1057 
1058                 updateParents(self, _key, treeIndex, true, _value);
1059             }
1060         } else {
1061             // Existing node.
1062             if (_value == 0) {
1063                 // Zero value.
1064                 // Remove.
1065                 // Remember value and set to 0.
1066                 uint256 value = tree.nodes[treeIndex];
1067                 tree.nodes[treeIndex] = 0;
1068 
1069                 // Push to stack.
1070                 tree.stack.push(treeIndex);
1071 
1072                 // Clear label.
1073                 delete tree.IDsToNodeIndexes[_ID];
1074                 delete tree.nodeIndexesToIDs[treeIndex];
1075 
1076                 updateParents(self, _key, treeIndex, false, value);
1077             } else if (_value != tree.nodes[treeIndex]) {
1078                 // New, non zero value.
1079                 // Set.
1080                 bool plusOrMinus = tree.nodes[treeIndex] <= _value;
1081                 uint256 plusOrMinusValue = plusOrMinus
1082                     ? _value - tree.nodes[treeIndex]
1083                     : tree.nodes[treeIndex] - _value;
1084                 tree.nodes[treeIndex] = _value;
1085 
1086                 updateParents(
1087                     self,
1088                     _key,
1089                     treeIndex,
1090                     plusOrMinus,
1091                     plusOrMinusValue
1092                 );
1093             }
1094         }
1095     }
1096 
1097     /* internal Views */
1098 
1099     /**
1100      *  @dev Query the leaves of a tree. Note that if `startIndex == 0`, the tree is empty and the root node will be returned.
1101      *  @param _key The key of the tree to get the leaves from.
1102      *  @param _cursor The pagination cursor.
1103      *  @param _count The number of items to return.
1104      *  @return startIndex The index at which leaves start
1105      *  @return values The values of the returned leaves
1106      *  @return hasMore Whether there are more for pagination.
1107      *  `O(n)` where
1108      *  `n` is the maximum number of nodes ever appended.
1109      */
1110     function queryLeafs(
1111         SortitionSumTrees storage self,
1112         bytes32 _key,
1113         uint256 _cursor,
1114         uint256 _count
1115     )
1116         internal
1117         view
1118         returns (
1119             uint256 startIndex,
1120             uint256[] memory values,
1121             bool hasMore
1122         )
1123     {
1124         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1125 
1126         // Find the start index.
1127         for (uint256 i = 0; i < tree.nodes.length; i++) {
1128             if ((tree.K * i) + 1 >= tree.nodes.length) {
1129                 startIndex = i;
1130                 break;
1131             }
1132         }
1133 
1134         // Get the values.
1135         uint256 loopStartIndex = startIndex + _cursor;
1136         values = new uint256[](
1137             loopStartIndex + _count > tree.nodes.length
1138                 ? tree.nodes.length - loopStartIndex
1139                 : _count
1140         );
1141         uint256 valuesIndex = 0;
1142         for (uint256 j = loopStartIndex; j < tree.nodes.length; j++) {
1143             if (valuesIndex < _count) {
1144                 values[valuesIndex] = tree.nodes[j];
1145                 valuesIndex++;
1146             } else {
1147                 hasMore = true;
1148                 break;
1149             }
1150         }
1151     }
1152 
1153     /**
1154      *  @dev Draw an ID from a tree using a number. Note that this function reverts if the sum of all values in the tree is 0.
1155      *  @param _key The key of the tree.
1156      *  @param _drawnNumber The drawn number.
1157      *  @return ID The drawn ID.
1158      *  `O(k * log_k(n))` where
1159      *  `k` is the maximum number of childs per node in the tree,
1160      *   and `n` is the maximum number of nodes ever appended.
1161      */
1162     function draw(
1163         SortitionSumTrees storage self,
1164         bytes32 _key,
1165         uint256 _drawnNumber
1166     ) internal view returns (bytes32 ID) {
1167         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1168         uint256 treeIndex = 0;
1169         uint256 currentDrawnNumber = _drawnNumber % tree.nodes[0];
1170 
1171         while (
1172             (tree.K * treeIndex) + 1 < tree.nodes.length // While it still has children.
1173         )
1174             for (uint256 i = 1; i <= tree.K; i++) {
1175                 // Loop over children.
1176                 uint256 nodeIndex = (tree.K * treeIndex) + i;
1177                 uint256 nodeValue = tree.nodes[nodeIndex];
1178 
1179                 if (currentDrawnNumber >= nodeValue)
1180                     currentDrawnNumber -= nodeValue; // Go to the next child.
1181                 else {
1182                     // Pick this child.
1183                     treeIndex = nodeIndex;
1184                     break;
1185                 }
1186             }
1187 
1188         ID = tree.nodeIndexesToIDs[treeIndex];
1189     }
1190 
1191     /** @dev Gets a specified ID's associated value.
1192      *  @param _key The key of the tree.
1193      *  @param _ID The ID of the value.
1194      *  @return value The associated value.
1195      */
1196     function stakeOf(
1197         SortitionSumTrees storage self,
1198         bytes32 _key,
1199         bytes32 _ID
1200     ) internal view returns (uint256 value) {
1201         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1202         uint256 treeIndex = tree.IDsToNodeIndexes[_ID];
1203 
1204         if (treeIndex == 0) value = 0;
1205         else value = tree.nodes[treeIndex];
1206     }
1207 
1208     function total(SortitionSumTrees storage self, bytes32 _key)
1209         internal
1210         view
1211         returns (uint256)
1212     {
1213         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1214         if (tree.nodes.length == 0) {
1215             return 0;
1216         } else {
1217             return tree.nodes[0];
1218         }
1219     }
1220 
1221     /* Private */
1222 
1223     /**
1224      *  @dev Update all the parents of a node.
1225      *  @param _key The key of the tree to update.
1226      *  @param _treeIndex The index of the node to start from.
1227      *  @param _plusOrMinus Wether to add (true) or substract (false).
1228      *  @param _value The value to add or substract.
1229      *  `O(log_k(n))` where
1230      *  `k` is the maximum number of childs per node in the tree,
1231      *   and `n` is the maximum number of nodes ever appended.
1232      */
1233     function updateParents(
1234         SortitionSumTrees storage self,
1235         bytes32 _key,
1236         uint256 _treeIndex,
1237         bool _plusOrMinus,
1238         uint256 _value
1239     ) private {
1240         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1241 
1242         uint256 parentIndex = _treeIndex;
1243         while (parentIndex != 0) {
1244             parentIndex = (parentIndex - 1) / tree.K;
1245             tree.nodes[parentIndex] = _plusOrMinus
1246                 ? tree.nodes[parentIndex] + _value
1247                 : tree.nodes[parentIndex] - _value;
1248         }
1249     }
1250 }
1251 
1252 // File: contracts/ILottery.sol
1253 
1254 pragma solidity ^0.8.7;
1255 
1256 interface ILottery {
1257     function getBalance(address staker) external view returns (uint256 balance);
1258 }
1259 
1260 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
1261 
1262 pragma solidity >=0.6.2;
1263 
1264 interface IUniswapV2Router01 {
1265     function factory() external pure returns (address);
1266 
1267     function WETH() external pure returns (address);
1268 
1269     function addLiquidity(
1270         address tokenA,
1271         address tokenB,
1272         uint256 amountADesired,
1273         uint256 amountBDesired,
1274         uint256 amountAMin,
1275         uint256 amountBMin,
1276         address to,
1277         uint256 deadline
1278     )
1279         external
1280         returns (
1281             uint256 amountA,
1282             uint256 amountB,
1283             uint256 liquidity
1284         );
1285 
1286     function addLiquidityETH(
1287         address token,
1288         uint256 amountTokenDesired,
1289         uint256 amountTokenMin,
1290         uint256 amountETHMin,
1291         address to,
1292         uint256 deadline
1293     )
1294         external
1295         payable
1296         returns (
1297             uint256 amountToken,
1298             uint256 amountETH,
1299             uint256 liquidity
1300         );
1301 
1302     function removeLiquidity(
1303         address tokenA,
1304         address tokenB,
1305         uint256 liquidity,
1306         uint256 amountAMin,
1307         uint256 amountBMin,
1308         address to,
1309         uint256 deadline
1310     ) external returns (uint256 amountA, uint256 amountB);
1311 
1312     function removeLiquidityETH(
1313         address token,
1314         uint256 liquidity,
1315         uint256 amountTokenMin,
1316         uint256 amountETHMin,
1317         address to,
1318         uint256 deadline
1319     ) external returns (uint256 amountToken, uint256 amountETH);
1320 
1321     function removeLiquidityWithPermit(
1322         address tokenA,
1323         address tokenB,
1324         uint256 liquidity,
1325         uint256 amountAMin,
1326         uint256 amountBMin,
1327         address to,
1328         uint256 deadline,
1329         bool approveMax,
1330         uint8 v,
1331         bytes32 r,
1332         bytes32 s
1333     ) external returns (uint256 amountA, uint256 amountB);
1334 
1335     function removeLiquidityETHWithPermit(
1336         address token,
1337         uint256 liquidity,
1338         uint256 amountTokenMin,
1339         uint256 amountETHMin,
1340         address to,
1341         uint256 deadline,
1342         bool approveMax,
1343         uint8 v,
1344         bytes32 r,
1345         bytes32 s
1346     ) external returns (uint256 amountToken, uint256 amountETH);
1347 
1348     function swapExactTokensForTokens(
1349         uint256 amountIn,
1350         uint256 amountOutMin,
1351         address[] calldata path,
1352         address to,
1353         uint256 deadline
1354     ) external returns (uint256[] memory amounts);
1355 
1356     function swapTokensForExactTokens(
1357         uint256 amountOut,
1358         uint256 amountInMax,
1359         address[] calldata path,
1360         address to,
1361         uint256 deadline
1362     ) external returns (uint256[] memory amounts);
1363 
1364     function swapExactETHForTokens(
1365         uint256 amountOutMin,
1366         address[] calldata path,
1367         address to,
1368         uint256 deadline
1369     ) external payable returns (uint256[] memory amounts);
1370 
1371     function swapTokensForExactETH(
1372         uint256 amountOut,
1373         uint256 amountInMax,
1374         address[] calldata path,
1375         address to,
1376         uint256 deadline
1377     ) external returns (uint256[] memory amounts);
1378 
1379     function swapExactTokensForETH(
1380         uint256 amountIn,
1381         uint256 amountOutMin,
1382         address[] calldata path,
1383         address to,
1384         uint256 deadline
1385     ) external returns (uint256[] memory amounts);
1386 
1387     function swapETHForExactTokens(
1388         uint256 amountOut,
1389         address[] calldata path,
1390         address to,
1391         uint256 deadline
1392     ) external payable returns (uint256[] memory amounts);
1393 
1394     function quote(
1395         uint256 amountA,
1396         uint256 reserveA,
1397         uint256 reserveB
1398     ) external pure returns (uint256 amountB);
1399 
1400     function getAmountOut(
1401         uint256 amountIn,
1402         uint256 reserveIn,
1403         uint256 reserveOut
1404     ) external pure returns (uint256 amountOut);
1405 
1406     function getAmountIn(
1407         uint256 amountOut,
1408         uint256 reserveIn,
1409         uint256 reserveOut
1410     ) external pure returns (uint256 amountIn);
1411 
1412     function getAmountsOut(uint256 amountIn, address[] calldata path)
1413         external
1414         view
1415         returns (uint256[] memory amounts);
1416 
1417     function getAmountsIn(uint256 amountOut, address[] calldata path)
1418         external
1419         view
1420         returns (uint256[] memory amounts);
1421 }
1422 
1423 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
1424 
1425 pragma solidity >=0.6.2;
1426 
1427 interface IUniswapV2Router02 is IUniswapV2Router01 {
1428     function removeLiquidityETHSupportingFeeOnTransferTokens(
1429         address token,
1430         uint256 liquidity,
1431         uint256 amountTokenMin,
1432         uint256 amountETHMin,
1433         address to,
1434         uint256 deadline
1435     ) external returns (uint256 amountETH);
1436 
1437     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1438         address token,
1439         uint256 liquidity,
1440         uint256 amountTokenMin,
1441         uint256 amountETHMin,
1442         address to,
1443         uint256 deadline,
1444         bool approveMax,
1445         uint8 v,
1446         bytes32 r,
1447         bytes32 s
1448     ) external returns (uint256 amountETH);
1449 
1450     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1451         uint256 amountIn,
1452         uint256 amountOutMin,
1453         address[] calldata path,
1454         address to,
1455         uint256 deadline
1456     ) external;
1457 
1458     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1459         uint256 amountOutMin,
1460         address[] calldata path,
1461         address to,
1462         uint256 deadline
1463     ) external payable;
1464 
1465     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1466         uint256 amountIn,
1467         uint256 amountOutMin,
1468         address[] calldata path,
1469         address to,
1470         uint256 deadline
1471     ) external;
1472 }
1473 
1474 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1475 
1476 pragma solidity >=0.5.0;
1477 
1478 interface IUniswapV2Pair {
1479     event Approval(
1480         address indexed owner,
1481         address indexed spender,
1482         uint256 value
1483     );
1484     event Transfer(address indexed from, address indexed to, uint256 value);
1485 
1486     function name() external pure returns (string memory);
1487 
1488     function symbol() external pure returns (string memory);
1489 
1490     function decimals() external pure returns (uint8);
1491 
1492     function totalSupply() external view returns (uint256);
1493 
1494     function balanceOf(address owner) external view returns (uint256);
1495 
1496     function allowance(address owner, address spender)
1497         external
1498         view
1499         returns (uint256);
1500 
1501     function approve(address spender, uint256 value) external returns (bool);
1502 
1503     function transfer(address to, uint256 value) external returns (bool);
1504 
1505     function transferFrom(
1506         address from,
1507         address to,
1508         uint256 value
1509     ) external returns (bool);
1510 
1511     function DOMAIN_SEPARATOR() external view returns (bytes32);
1512 
1513     function PERMIT_TYPEHASH() external pure returns (bytes32);
1514 
1515     function nonces(address owner) external view returns (uint256);
1516 
1517     function permit(
1518         address owner,
1519         address spender,
1520         uint256 value,
1521         uint256 deadline,
1522         uint8 v,
1523         bytes32 r,
1524         bytes32 s
1525     ) external;
1526 
1527     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1528     event Burn(
1529         address indexed sender,
1530         uint256 amount0,
1531         uint256 amount1,
1532         address indexed to
1533     );
1534     event Swap(
1535         address indexed sender,
1536         uint256 amount0In,
1537         uint256 amount1In,
1538         uint256 amount0Out,
1539         uint256 amount1Out,
1540         address indexed to
1541     );
1542     event Sync(uint112 reserve0, uint112 reserve1);
1543 
1544     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1545 
1546     function factory() external view returns (address);
1547 
1548     function token0() external view returns (address);
1549 
1550     function token1() external view returns (address);
1551 
1552     function getReserves()
1553         external
1554         view
1555         returns (
1556             uint112 reserve0,
1557             uint112 reserve1,
1558             uint32 blockTimestampLast
1559         );
1560 
1561     function price0CumulativeLast() external view returns (uint256);
1562 
1563     function price1CumulativeLast() external view returns (uint256);
1564 
1565     function kLast() external view returns (uint256);
1566 
1567     function mint(address to) external returns (uint256 liquidity);
1568 
1569     function burn(address to)
1570         external
1571         returns (uint256 amount0, uint256 amount1);
1572 
1573     function swap(
1574         uint256 amount0Out,
1575         uint256 amount1Out,
1576         address to,
1577         bytes calldata data
1578     ) external;
1579 
1580     function skim(address to) external;
1581 
1582     function sync() external;
1583 
1584     function initialize(address, address) external;
1585 }
1586 
1587 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
1588 
1589 pragma solidity >=0.5.0;
1590 
1591 interface IUniswapV2Factory {
1592     event PairCreated(
1593         address indexed token0,
1594         address indexed token1,
1595         address pair,
1596         uint256
1597     );
1598 
1599     function feeTo() external view returns (address);
1600 
1601     function feeToSetter() external view returns (address);
1602 
1603     function getPair(address tokenA, address tokenB)
1604         external
1605         view
1606         returns (address pair);
1607 
1608     function allPairs(uint256) external view returns (address pair);
1609 
1610     function allPairsLength() external view returns (uint256);
1611 
1612     function createPair(address tokenA, address tokenB)
1613         external
1614         returns (address pair);
1615 
1616     function setFeeTo(address) external;
1617 
1618     function setFeeToSetter(address) external;
1619 }
1620 
1621 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1622 
1623 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1624 
1625 pragma solidity ^0.8.0;
1626 
1627 // CAUTION
1628 // This version of SafeMath should only be used with Solidity 0.8 or later,
1629 // because it relies on the compiler's built in overflow checks.
1630 
1631 /**
1632  * @dev Wrappers over Solidity's arithmetic operations.
1633  *
1634  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1635  * now has built in overflow checking.
1636  */
1637 library SafeMath {
1638     /**
1639      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1640      *
1641      * _Available since v3.4._
1642      */
1643     function tryAdd(uint256 a, uint256 b)
1644         internal
1645         pure
1646         returns (bool, uint256)
1647     {
1648         unchecked {
1649             uint256 c = a + b;
1650             if (c < a) return (false, 0);
1651             return (true, c);
1652         }
1653     }
1654 
1655     /**
1656      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1657      *
1658      * _Available since v3.4._
1659      */
1660     function trySub(uint256 a, uint256 b)
1661         internal
1662         pure
1663         returns (bool, uint256)
1664     {
1665         unchecked {
1666             if (b > a) return (false, 0);
1667             return (true, a - b);
1668         }
1669     }
1670 
1671     /**
1672      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1673      *
1674      * _Available since v3.4._
1675      */
1676     function tryMul(uint256 a, uint256 b)
1677         internal
1678         pure
1679         returns (bool, uint256)
1680     {
1681         unchecked {
1682             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1683             // benefit is lost if 'b' is also tested.
1684             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1685             if (a == 0) return (true, 0);
1686             uint256 c = a * b;
1687             if (c / a != b) return (false, 0);
1688             return (true, c);
1689         }
1690     }
1691 
1692     /**
1693      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1694      *
1695      * _Available since v3.4._
1696      */
1697     function tryDiv(uint256 a, uint256 b)
1698         internal
1699         pure
1700         returns (bool, uint256)
1701     {
1702         unchecked {
1703             if (b == 0) return (false, 0);
1704             return (true, a / b);
1705         }
1706     }
1707 
1708     /**
1709      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1710      *
1711      * _Available since v3.4._
1712      */
1713     function tryMod(uint256 a, uint256 b)
1714         internal
1715         pure
1716         returns (bool, uint256)
1717     {
1718         unchecked {
1719             if (b == 0) return (false, 0);
1720             return (true, a % b);
1721         }
1722     }
1723 
1724     /**
1725      * @dev Returns the addition of two unsigned integers, reverting on
1726      * overflow.
1727      *
1728      * Counterpart to Solidity's `+` operator.
1729      *
1730      * Requirements:
1731      *
1732      * - Addition cannot overflow.
1733      */
1734     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1735         return a + b;
1736     }
1737 
1738     /**
1739      * @dev Returns the subtraction of two unsigned integers, reverting on
1740      * overflow (when the result is negative).
1741      *
1742      * Counterpart to Solidity's `-` operator.
1743      *
1744      * Requirements:
1745      *
1746      * - Subtraction cannot overflow.
1747      */
1748     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1749         return a - b;
1750     }
1751 
1752     /**
1753      * @dev Returns the multiplication of two unsigned integers, reverting on
1754      * overflow.
1755      *
1756      * Counterpart to Solidity's `*` operator.
1757      *
1758      * Requirements:
1759      *
1760      * - Multiplication cannot overflow.
1761      */
1762     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1763         return a * b;
1764     }
1765 
1766     /**
1767      * @dev Returns the integer division of two unsigned integers, reverting on
1768      * division by zero. The result is rounded towards zero.
1769      *
1770      * Counterpart to Solidity's `/` operator.
1771      *
1772      * Requirements:
1773      *
1774      * - The divisor cannot be zero.
1775      */
1776     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1777         return a / b;
1778     }
1779 
1780     /**
1781      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1782      * reverting when dividing by zero.
1783      *
1784      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1785      * opcode (which leaves remaining gas untouched) while Solidity uses an
1786      * invalid opcode to revert (consuming all remaining gas).
1787      *
1788      * Requirements:
1789      *
1790      * - The divisor cannot be zero.
1791      */
1792     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1793         return a % b;
1794     }
1795 
1796     /**
1797      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1798      * overflow (when the result is negative).
1799      *
1800      * CAUTION: This function is deprecated because it requires allocating memory for the error
1801      * message unnecessarily. For custom revert reasons use {trySub}.
1802      *
1803      * Counterpart to Solidity's `-` operator.
1804      *
1805      * Requirements:
1806      *
1807      * - Subtraction cannot overflow.
1808      */
1809     function sub(
1810         uint256 a,
1811         uint256 b,
1812         string memory errorMessage
1813     ) internal pure returns (uint256) {
1814         unchecked {
1815             require(b <= a, errorMessage);
1816             return a - b;
1817         }
1818     }
1819 
1820     /**
1821      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1822      * division by zero. The result is rounded towards zero.
1823      *
1824      * Counterpart to Solidity's `/` operator. Note: this function uses a
1825      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1826      * uses an invalid opcode to revert (consuming all remaining gas).
1827      *
1828      * Requirements:
1829      *
1830      * - The divisor cannot be zero.
1831      */
1832     function div(
1833         uint256 a,
1834         uint256 b,
1835         string memory errorMessage
1836     ) internal pure returns (uint256) {
1837         unchecked {
1838             require(b > 0, errorMessage);
1839             return a / b;
1840         }
1841     }
1842 
1843     /**
1844      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1845      * reverting with custom message when dividing by zero.
1846      *
1847      * CAUTION: This function is deprecated because it requires allocating memory for the error
1848      * message unnecessarily. For custom revert reasons use {tryMod}.
1849      *
1850      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1851      * opcode (which leaves remaining gas untouched) while Solidity uses an
1852      * invalid opcode to revert (consuming all remaining gas).
1853      *
1854      * Requirements:
1855      *
1856      * - The divisor cannot be zero.
1857      */
1858     function mod(
1859         uint256 a,
1860         uint256 b,
1861         string memory errorMessage
1862     ) internal pure returns (uint256) {
1863         unchecked {
1864             require(b > 0, errorMessage);
1865             return a % b;
1866         }
1867     }
1868 }
1869 
1870 // File: @openzeppelin/contracts/utils/Address.sol
1871 
1872 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1873 
1874 pragma solidity ^0.8.1;
1875 
1876 /**
1877  * @dev Collection of functions related to the address type
1878  */
1879 library Address {
1880     /**
1881      * @dev Returns true if `account` is a contract.
1882      *
1883      * [IMPORTANT]
1884      * ====
1885      * It is unsafe to assume that an address for which this function returns
1886      * false is an externally-owned account (EOA) and not a contract.
1887      *
1888      * Among others, `isContract` will return false for the following
1889      * types of addresses:
1890      *
1891      *  - an externally-owned account
1892      *  - a contract in construction
1893      *  - an address where a contract will be created
1894      *  - an address where a contract lived, but was destroyed
1895      * ====
1896      *
1897      * [IMPORTANT]
1898      * ====
1899      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1900      *
1901      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1902      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1903      * constructor.
1904      * ====
1905      */
1906     function isContract(address account) internal view returns (bool) {
1907         // This method relies on extcodesize/address.code.length, which returns 0
1908         // for contracts in construction, since the code is only stored at the end
1909         // of the constructor execution.
1910 
1911         return account.code.length > 0;
1912     }
1913 
1914     /**
1915      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1916      * `recipient`, forwarding all available gas and reverting on errors.
1917      *
1918      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1919      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1920      * imposed by `transfer`, making them unable to receive funds via
1921      * `transfer`. {sendValue} removes this limitation.
1922      *
1923      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1924      *
1925      * IMPORTANT: because control is transferred to `recipient`, care must be
1926      * taken to not create reentrancy vulnerabilities. Consider using
1927      * {ReentrancyGuard} or the
1928      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1929      */
1930     function sendValue(address payable recipient, uint256 amount) internal {
1931         require(
1932             address(this).balance >= amount,
1933             "Address: insufficient balance"
1934         );
1935 
1936         (bool success, ) = recipient.call{value: amount}("");
1937         require(
1938             success,
1939             "Address: unable to send value, recipient may have reverted"
1940         );
1941     }
1942 
1943     /**
1944      * @dev Performs a Solidity function call using a low level `call`. A
1945      * plain `call` is an unsafe replacement for a function call: use this
1946      * function instead.
1947      *
1948      * If `target` reverts with a revert reason, it is bubbled up by this
1949      * function (like regular Solidity function calls).
1950      *
1951      * Returns the raw returned data. To convert to the expected return value,
1952      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1953      *
1954      * Requirements:
1955      *
1956      * - `target` must be a contract.
1957      * - calling `target` with `data` must not revert.
1958      *
1959      * _Available since v3.1._
1960      */
1961     function functionCall(address target, bytes memory data)
1962         internal
1963         returns (bytes memory)
1964     {
1965         return functionCall(target, data, "Address: low-level call failed");
1966     }
1967 
1968     /**
1969      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1970      * `errorMessage` as a fallback revert reason when `target` reverts.
1971      *
1972      * _Available since v3.1._
1973      */
1974     function functionCall(
1975         address target,
1976         bytes memory data,
1977         string memory errorMessage
1978     ) internal returns (bytes memory) {
1979         return functionCallWithValue(target, data, 0, errorMessage);
1980     }
1981 
1982     /**
1983      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1984      * but also transferring `value` wei to `target`.
1985      *
1986      * Requirements:
1987      *
1988      * - the calling contract must have an ETH balance of at least `value`.
1989      * - the called Solidity function must be `payable`.
1990      *
1991      * _Available since v3.1._
1992      */
1993     function functionCallWithValue(
1994         address target,
1995         bytes memory data,
1996         uint256 value
1997     ) internal returns (bytes memory) {
1998         return
1999             functionCallWithValue(
2000                 target,
2001                 data,
2002                 value,
2003                 "Address: low-level call with value failed"
2004             );
2005     }
2006 
2007     /**
2008      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2009      * with `errorMessage` as a fallback revert reason when `target` reverts.
2010      *
2011      * _Available since v3.1._
2012      */
2013     function functionCallWithValue(
2014         address target,
2015         bytes memory data,
2016         uint256 value,
2017         string memory errorMessage
2018     ) internal returns (bytes memory) {
2019         require(
2020             address(this).balance >= value,
2021             "Address: insufficient balance for call"
2022         );
2023         require(isContract(target), "Address: call to non-contract");
2024 
2025         (bool success, bytes memory returndata) = target.call{value: value}(
2026             data
2027         );
2028         return verifyCallResult(success, returndata, errorMessage);
2029     }
2030 
2031     /**
2032      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2033      * but performing a static call.
2034      *
2035      * _Available since v3.3._
2036      */
2037     function functionStaticCall(address target, bytes memory data)
2038         internal
2039         view
2040         returns (bytes memory)
2041     {
2042         return
2043             functionStaticCall(
2044                 target,
2045                 data,
2046                 "Address: low-level static call failed"
2047             );
2048     }
2049 
2050     /**
2051      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2052      * but performing a static call.
2053      *
2054      * _Available since v3.3._
2055      */
2056     function functionStaticCall(
2057         address target,
2058         bytes memory data,
2059         string memory errorMessage
2060     ) internal view returns (bytes memory) {
2061         require(isContract(target), "Address: static call to non-contract");
2062 
2063         (bool success, bytes memory returndata) = target.staticcall(data);
2064         return verifyCallResult(success, returndata, errorMessage);
2065     }
2066 
2067     /**
2068      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2069      * but performing a delegate call.
2070      *
2071      * _Available since v3.4._
2072      */
2073     function functionDelegateCall(address target, bytes memory data)
2074         internal
2075         returns (bytes memory)
2076     {
2077         return
2078             functionDelegateCall(
2079                 target,
2080                 data,
2081                 "Address: low-level delegate call failed"
2082             );
2083     }
2084 
2085     /**
2086      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2087      * but performing a delegate call.
2088      *
2089      * _Available since v3.4._
2090      */
2091     function functionDelegateCall(
2092         address target,
2093         bytes memory data,
2094         string memory errorMessage
2095     ) internal returns (bytes memory) {
2096         require(isContract(target), "Address: delegate call to non-contract");
2097 
2098         (bool success, bytes memory returndata) = target.delegatecall(data);
2099         return verifyCallResult(success, returndata, errorMessage);
2100     }
2101 
2102     /**
2103      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
2104      * revert reason using the provided one.
2105      *
2106      * _Available since v4.3._
2107      */
2108     function verifyCallResult(
2109         bool success,
2110         bytes memory returndata,
2111         string memory errorMessage
2112     ) internal pure returns (bytes memory) {
2113         if (success) {
2114             return returndata;
2115         } else {
2116             // Look for revert reason and bubble it up if present
2117             if (returndata.length > 0) {
2118                 // The easiest way to bubble the revert reason is using memory via assembly
2119 
2120                 assembly {
2121                     let returndata_size := mload(returndata)
2122                     revert(add(32, returndata), returndata_size)
2123                 }
2124             } else {
2125                 revert(errorMessage);
2126             }
2127         }
2128     }
2129 }
2130 
2131 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2132 
2133 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2134 
2135 pragma solidity ^0.8.0;
2136 
2137 /**
2138  * @dev Interface of the ERC20 standard as defined in the EIP.
2139  */
2140 interface IERC20 {
2141     /**
2142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2143      * another (`to`).
2144      *
2145      * Note that `value` may be zero.
2146      */
2147     event Transfer(address indexed from, address indexed to, uint256 value);
2148 
2149     /**
2150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2151      * a call to {approve}. `value` is the new allowance.
2152      */
2153     event Approval(
2154         address indexed owner,
2155         address indexed spender,
2156         uint256 value
2157     );
2158 
2159     /**
2160      * @dev Returns the amount of tokens in existence.
2161      */
2162     function totalSupply() external view returns (uint256);
2163 
2164     /**
2165      * @dev Returns the amount of tokens owned by `account`.
2166      */
2167     function balanceOf(address account) external view returns (uint256);
2168 
2169     /**
2170      * @dev Moves `amount` tokens from the caller's account to `to`.
2171      *
2172      * Returns a boolean value indicating whether the operation succeeded.
2173      *
2174      * Emits a {Transfer} event.
2175      */
2176     function transfer(address to, uint256 amount) external returns (bool);
2177 
2178     /**
2179      * @dev Returns the remaining number of tokens that `spender` will be
2180      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2181      * zero by default.
2182      *
2183      * This value changes when {approve} or {transferFrom} are called.
2184      */
2185     function allowance(address owner, address spender)
2186         external
2187         view
2188         returns (uint256);
2189 
2190     /**
2191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2192      *
2193      * Returns a boolean value indicating whether the operation succeeded.
2194      *
2195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2196      * that someone may use both the old and the new allowance by unfortunate
2197      * transaction ordering. One possible solution to mitigate this race
2198      * condition is to first reduce the spender's allowance to 0 and set the
2199      * desired value afterwards:
2200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2201      *
2202      * Emits an {Approval} event.
2203      */
2204     function approve(address spender, uint256 amount) external returns (bool);
2205 
2206     /**
2207      * @dev Moves `amount` tokens from `from` to `to` using the
2208      * allowance mechanism. `amount` is then deducted from the caller's
2209      * allowance.
2210      *
2211      * Returns a boolean value indicating whether the operation succeeded.
2212      *
2213      * Emits a {Transfer} event.
2214      */
2215     function transferFrom(
2216         address from,
2217         address to,
2218         uint256 amount
2219     ) external returns (bool);
2220 }
2221 
2222 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2223 
2224 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
2225 
2226 pragma solidity ^0.8.0;
2227 
2228 /**
2229  * @title SafeERC20
2230  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2231  * contract returns false). Tokens that return no value (and instead revert or
2232  * throw on failure) are also supported, non-reverting calls are assumed to be
2233  * successful.
2234  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2235  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2236  */
2237 library SafeERC20 {
2238     using Address for address;
2239 
2240     function safeTransfer(
2241         IERC20 token,
2242         address to,
2243         uint256 value
2244     ) internal {
2245         _callOptionalReturn(
2246             token,
2247             abi.encodeWithSelector(token.transfer.selector, to, value)
2248         );
2249     }
2250 
2251     function safeTransferFrom(
2252         IERC20 token,
2253         address from,
2254         address to,
2255         uint256 value
2256     ) internal {
2257         _callOptionalReturn(
2258             token,
2259             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
2260         );
2261     }
2262 
2263     /**
2264      * @dev Deprecated. This function has issues similar to the ones found in
2265      * {IERC20-approve}, and its usage is discouraged.
2266      *
2267      * Whenever possible, use {safeIncreaseAllowance} and
2268      * {safeDecreaseAllowance} instead.
2269      */
2270     function safeApprove(
2271         IERC20 token,
2272         address spender,
2273         uint256 value
2274     ) internal {
2275         // safeApprove should only be called when setting an initial allowance,
2276         // or when resetting it to zero. To increase and decrease it, use
2277         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2278         require(
2279             (value == 0) || (token.allowance(address(this), spender) == 0),
2280             "SafeERC20: approve from non-zero to non-zero allowance"
2281         );
2282         _callOptionalReturn(
2283             token,
2284             abi.encodeWithSelector(token.approve.selector, spender, value)
2285         );
2286     }
2287 
2288     function safeIncreaseAllowance(
2289         IERC20 token,
2290         address spender,
2291         uint256 value
2292     ) internal {
2293         uint256 newAllowance = token.allowance(address(this), spender) + value;
2294         _callOptionalReturn(
2295             token,
2296             abi.encodeWithSelector(
2297                 token.approve.selector,
2298                 spender,
2299                 newAllowance
2300             )
2301         );
2302     }
2303 
2304     function safeDecreaseAllowance(
2305         IERC20 token,
2306         address spender,
2307         uint256 value
2308     ) internal {
2309         unchecked {
2310             uint256 oldAllowance = token.allowance(address(this), spender);
2311             require(
2312                 oldAllowance >= value,
2313                 "SafeERC20: decreased allowance below zero"
2314             );
2315             uint256 newAllowance = oldAllowance - value;
2316             _callOptionalReturn(
2317                 token,
2318                 abi.encodeWithSelector(
2319                     token.approve.selector,
2320                     spender,
2321                     newAllowance
2322                 )
2323             );
2324         }
2325     }
2326 
2327     /**
2328      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2329      * on the return value: the return value is optional (but if data is returned, it must not be false).
2330      * @param token The token targeted by the call.
2331      * @param data The call data (encoded using abi.encode or one of its variants).
2332      */
2333     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2334         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2335         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2336         // the target address contains contract code and also asserts for success in the low-level call.
2337 
2338         bytes memory returndata = address(token).functionCall(
2339             data,
2340             "SafeERC20: low-level call failed"
2341         );
2342         if (returndata.length > 0) {
2343             // Return data is optional
2344             require(
2345                 abi.decode(returndata, (bool)),
2346                 "SafeERC20: ERC20 operation did not succeed"
2347             );
2348         }
2349     }
2350 }
2351 
2352 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
2353 
2354 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2355 
2356 pragma solidity ^0.8.0;
2357 
2358 /**
2359  * @dev Interface for the optional metadata functions from the ERC20 standard.
2360  *
2361  * _Available since v4.1._
2362  */
2363 interface IERC20Metadata is IERC20 {
2364     /**
2365      * @dev Returns the name of the token.
2366      */
2367     function name() external view returns (string memory);
2368 
2369     /**
2370      * @dev Returns the symbol of the token.
2371      */
2372     function symbol() external view returns (string memory);
2373 
2374     /**
2375      * @dev Returns the decimals places of the token.
2376      */
2377     function decimals() external view returns (uint8);
2378 }
2379 
2380 // File: @openzeppelin/contracts/utils/Context.sol
2381 
2382 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2383 
2384 pragma solidity ^0.8.0;
2385 
2386 /**
2387  * @dev Provides information about the current execution context, including the
2388  * sender of the transaction and its data. While these are generally available
2389  * via msg.sender and msg.data, they should not be accessed in such a direct
2390  * manner, since when dealing with meta-transactions the account sending and
2391  * paying for execution may not be the actual sender (as far as an application
2392  * is concerned).
2393  *
2394  * This contract is only required for intermediate, library-like contracts.
2395  */
2396 abstract contract Context {
2397     function _msgSender() internal view virtual returns (address) {
2398         return msg.sender;
2399     }
2400 
2401     function _msgData() internal view virtual returns (bytes calldata) {
2402         return msg.data;
2403     }
2404 }
2405 
2406 // File: contracts/Multisig.sol
2407 
2408 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2409 
2410 pragma solidity ^0.8.0;
2411 
2412 /**
2413  * @dev Contract module which provides a basic access control mechanism, where
2414  * there is an account (a multisig) that can be granted exclusive access to
2415  * specific functions.
2416  *
2417  * By default, the multisig account will be the one that deploys the contract. This
2418  * can later be changed with {transferMultisig}.
2419  *
2420  * This module is used through inheritance. It will make available the modifier
2421  * `onlyMultisig`, which can be applied to your functions to restrict their use to
2422  * the multisig.
2423  */
2424 abstract contract Multisig is Context {
2425     address private _multisig;
2426 
2427     event MultisigTransferred(
2428         address indexed previousMultisig,
2429         address indexed newMultisig
2430     );
2431 
2432     /**
2433      * @dev Initializes the contract setting the deployer as the initial multisig.
2434      */
2435     constructor() {
2436         _transferMultisig(_msgSender());
2437     }
2438 
2439     /**
2440      * @dev Returns the address of the current multisig.
2441      */
2442     function multisig() public view virtual returns (address) {
2443         return _multisig;
2444     }
2445 
2446     /**
2447      * @dev Throws if called by any account other than the multisig.
2448      */
2449     modifier onlyMultisig() {
2450         require(
2451             multisig() == _msgSender(),
2452             "Multisig: caller is not the multisig"
2453         );
2454         _;
2455     }
2456 
2457     /**
2458      * @dev Transfers ownership of the contract to a new account (`newMultisig`).
2459      * Can only be called by the current multisig.
2460      */
2461     function transferMultisig(address newMultisig) public virtual onlyMultisig {
2462         require(
2463             newMultisig != address(0),
2464             "Multisig: new multisig is the zero address"
2465         );
2466         _transferMultisig(newMultisig);
2467     }
2468 
2469     /**
2470      * @dev Transfers ownership of the contract to a new account (`newMultisig`).
2471      * Internal function without access restriction.
2472      */
2473     function _transferMultisig(address newMultisig) internal virtual {
2474         address oldMultisig = _multisig;
2475         _multisig = newMultisig;
2476         emit MultisigTransferred(oldMultisig, newMultisig);
2477     }
2478 }
2479 
2480 // File: @openzeppelin/contracts/access/Ownable.sol
2481 
2482 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
2483 
2484 pragma solidity ^0.8.0;
2485 
2486 /**
2487  * @dev Contract module which provides a basic access control mechanism, where
2488  * there is an account (an owner) that can be granted exclusive access to
2489  * specific functions.
2490  *
2491  * By default, the owner account will be the one that deploys the contract. This
2492  * can later be changed with {transferOwnership}.
2493  *
2494  * This module is used through inheritance. It will make available the modifier
2495  * `onlyOwner`, which can be applied to your functions to restrict their use to
2496  * the owner.
2497  */
2498 abstract contract Ownable is Context {
2499     address private _owner;
2500 
2501     event OwnershipTransferred(
2502         address indexed previousOwner,
2503         address indexed newOwner
2504     );
2505 
2506     /**
2507      * @dev Initializes the contract setting the deployer as the initial owner.
2508      */
2509     constructor() {
2510         _transferOwnership(_msgSender());
2511     }
2512 
2513     /**
2514      * @dev Returns the address of the current owner.
2515      */
2516     function owner() public view virtual returns (address) {
2517         return _owner;
2518     }
2519 
2520     /**
2521      * @dev Throws if called by any account other than the owner.
2522      */
2523     modifier onlyOwner() {
2524         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2525         _;
2526     }
2527 
2528     /**
2529      * @dev Leaves the contract without owner. It will not be possible to call
2530      * `onlyOwner` functions anymore. Can only be called by the current owner.
2531      *
2532      * NOTE: Renouncing ownership will leave the contract without an owner,
2533      * thereby removing any functionality that is only available to the owner.
2534      */
2535     function renounceOwnership() public virtual onlyOwner {
2536         _transferOwnership(address(0));
2537     }
2538 
2539     /**
2540      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2541      * Can only be called by the current owner.
2542      */
2543     function transferOwnership(address newOwner) public virtual onlyOwner {
2544         require(
2545             newOwner != address(0),
2546             "Ownable: new owner is the zero address"
2547         );
2548         _transferOwnership(newOwner);
2549     }
2550 
2551     /**
2552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2553      * Internal function without access restriction.
2554      */
2555     function _transferOwnership(address newOwner) internal virtual {
2556         address oldOwner = _owner;
2557         _owner = newOwner;
2558         emit OwnershipTransferred(oldOwner, newOwner);
2559     }
2560 }
2561 
2562 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2563 
2564 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
2565 
2566 pragma solidity ^0.8.0;
2567 
2568 /**
2569  * @dev Implementation of the {IERC20} interface.
2570  *
2571  * This implementation is agnostic to the way tokens are created. This means
2572  * that a supply mechanism has to be added in a derived contract using {_mint}.
2573  * For a generic mechanism see {ERC20PresetMinterPauser}.
2574  *
2575  * TIP: For a detailed writeup see our guide
2576  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2577  * to implement supply mechanisms].
2578  *
2579  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2580  * instead returning `false` on failure. This behavior is nonetheless
2581  * conventional and does not conflict with the expectations of ERC20
2582  * applications.
2583  *
2584  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2585  * This allows applications to reconstruct the allowance for all accounts just
2586  * by listening to said events. Other implementations of the EIP may not emit
2587  * these events, as it isn't required by the specification.
2588  *
2589  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2590  * functions have been added to mitigate the well-known issues around setting
2591  * allowances. See {IERC20-approve}.
2592  */
2593 contract ERC20 is Context, IERC20, IERC20Metadata {
2594     mapping(address => uint256) private _balances;
2595 
2596     mapping(address => mapping(address => uint256)) private _allowances;
2597 
2598     uint256 private _totalSupply;
2599 
2600     string private _name;
2601     string private _symbol;
2602 
2603     /**
2604      * @dev Sets the values for {name} and {symbol}.
2605      *
2606      * The default value of {decimals} is 18. To select a different value for
2607      * {decimals} you should overload it.
2608      *
2609      * All two of these values are immutable: they can only be set once during
2610      * construction.
2611      */
2612     constructor(string memory name_, string memory symbol_) {
2613         _name = name_;
2614         _symbol = symbol_;
2615     }
2616 
2617     /**
2618      * @dev Returns the name of the token.
2619      */
2620     function name() public view virtual override returns (string memory) {
2621         return _name;
2622     }
2623 
2624     /**
2625      * @dev Returns the symbol of the token, usually a shorter version of the
2626      * name.
2627      */
2628     function symbol() public view virtual override returns (string memory) {
2629         return _symbol;
2630     }
2631 
2632     /**
2633      * @dev Returns the number of decimals used to get its user representation.
2634      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2635      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2636      *
2637      * Tokens usually opt for a value of 18, imitating the relationship between
2638      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2639      * overridden;
2640      *
2641      * NOTE: This information is only used for _display_ purposes: it in
2642      * no way affects any of the arithmetic of the contract, including
2643      * {IERC20-balanceOf} and {IERC20-transfer}.
2644      */
2645     function decimals() public view virtual override returns (uint8) {
2646         return 18;
2647     }
2648 
2649     /**
2650      * @dev See {IERC20-totalSupply}.
2651      */
2652     function totalSupply() public view virtual override returns (uint256) {
2653         return _totalSupply;
2654     }
2655 
2656     /**
2657      * @dev See {IERC20-balanceOf}.
2658      */
2659     function balanceOf(address account)
2660         public
2661         view
2662         virtual
2663         override
2664         returns (uint256)
2665     {
2666         return _balances[account];
2667     }
2668 
2669     /**
2670      * @dev See {IERC20-transfer}.
2671      *
2672      * Requirements:
2673      *
2674      * - `to` cannot be the zero address.
2675      * - the caller must have a balance of at least `amount`.
2676      */
2677     function transfer(address to, uint256 amount)
2678         public
2679         virtual
2680         override
2681         returns (bool)
2682     {
2683         address owner = _msgSender();
2684         _transfer(owner, to, amount);
2685         return true;
2686     }
2687 
2688     /**
2689      * @dev See {IERC20-allowance}.
2690      */
2691     function allowance(address owner, address spender)
2692         public
2693         view
2694         virtual
2695         override
2696         returns (uint256)
2697     {
2698         return _allowances[owner][spender];
2699     }
2700 
2701     /**
2702      * @dev See {IERC20-approve}.
2703      *
2704      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2705      * `transferFrom`. This is semantically equivalent to an infinite approval.
2706      *
2707      * Requirements:
2708      *
2709      * - `spender` cannot be the zero address.
2710      */
2711     function approve(address spender, uint256 amount)
2712         public
2713         virtual
2714         override
2715         returns (bool)
2716     {
2717         address owner = _msgSender();
2718         _approve(owner, spender, amount);
2719         return true;
2720     }
2721 
2722     /**
2723      * @dev See {IERC20-transferFrom}.
2724      *
2725      * Emits an {Approval} event indicating the updated allowance. This is not
2726      * required by the EIP. See the note at the beginning of {ERC20}.
2727      *
2728      * NOTE: Does not update the allowance if the current allowance
2729      * is the maximum `uint256`.
2730      *
2731      * Requirements:
2732      *
2733      * - `from` and `to` cannot be the zero address.
2734      * - `from` must have a balance of at least `amount`.
2735      * - the caller must have allowance for ``from``'s tokens of at least
2736      * `amount`.
2737      */
2738     function transferFrom(
2739         address from,
2740         address to,
2741         uint256 amount
2742     ) public virtual override returns (bool) {
2743         address spender = _msgSender();
2744         _spendAllowance(from, spender, amount);
2745         _transfer(from, to, amount);
2746         return true;
2747     }
2748 
2749     /**
2750      * @dev Atomically increases the allowance granted to `spender` by the caller.
2751      *
2752      * This is an alternative to {approve} that can be used as a mitigation for
2753      * problems described in {IERC20-approve}.
2754      *
2755      * Emits an {Approval} event indicating the updated allowance.
2756      *
2757      * Requirements:
2758      *
2759      * - `spender` cannot be the zero address.
2760      */
2761     function increaseAllowance(address spender, uint256 addedValue)
2762         public
2763         virtual
2764         returns (bool)
2765     {
2766         address owner = _msgSender();
2767         _approve(owner, spender, allowance(owner, spender) + addedValue);
2768         return true;
2769     }
2770 
2771     /**
2772      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2773      *
2774      * This is an alternative to {approve} that can be used as a mitigation for
2775      * problems described in {IERC20-approve}.
2776      *
2777      * Emits an {Approval} event indicating the updated allowance.
2778      *
2779      * Requirements:
2780      *
2781      * - `spender` cannot be the zero address.
2782      * - `spender` must have allowance for the caller of at least
2783      * `subtractedValue`.
2784      */
2785     function decreaseAllowance(address spender, uint256 subtractedValue)
2786         public
2787         virtual
2788         returns (bool)
2789     {
2790         address owner = _msgSender();
2791         uint256 currentAllowance = allowance(owner, spender);
2792         require(
2793             currentAllowance >= subtractedValue,
2794             "ERC20: decreased allowance below zero"
2795         );
2796         unchecked {
2797             _approve(owner, spender, currentAllowance - subtractedValue);
2798         }
2799 
2800         return true;
2801     }
2802 
2803     /**
2804      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2805      *
2806      * This internal function is equivalent to {transfer}, and can be used to
2807      * e.g. implement automatic token fees, slashing mechanisms, etc.
2808      *
2809      * Emits a {Transfer} event.
2810      *
2811      * Requirements:
2812      *
2813      * - `from` cannot be the zero address.
2814      * - `to` cannot be the zero address.
2815      * - `from` must have a balance of at least `amount`.
2816      */
2817     function _transfer(
2818         address from,
2819         address to,
2820         uint256 amount
2821     ) internal virtual {
2822         require(from != address(0), "ERC20: transfer from the zero address");
2823         require(to != address(0), "ERC20: transfer to the zero address");
2824 
2825         _beforeTokenTransfer(from, to, amount);
2826 
2827         uint256 fromBalance = _balances[from];
2828         require(
2829             fromBalance >= amount,
2830             "ERC20: transfer amount exceeds balance"
2831         );
2832         unchecked {
2833             _balances[from] = fromBalance - amount;
2834         }
2835         _balances[to] += amount;
2836 
2837         emit Transfer(from, to, amount);
2838 
2839         _afterTokenTransfer(from, to, amount);
2840     }
2841 
2842     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2843      * the total supply.
2844      *
2845      * Emits a {Transfer} event with `from` set to the zero address.
2846      *
2847      * Requirements:
2848      *
2849      * - `account` cannot be the zero address.
2850      */
2851     function _mint(address account, uint256 amount) internal virtual {
2852         require(account != address(0), "ERC20: mint to the zero address");
2853 
2854         _beforeTokenTransfer(address(0), account, amount);
2855 
2856         _totalSupply += amount;
2857         _balances[account] += amount;
2858         emit Transfer(address(0), account, amount);
2859 
2860         _afterTokenTransfer(address(0), account, amount);
2861     }
2862 
2863     /**
2864      * @dev Destroys `amount` tokens from `account`, reducing the
2865      * total supply.
2866      *
2867      * Emits a {Transfer} event with `to` set to the zero address.
2868      *
2869      * Requirements:
2870      *
2871      * - `account` cannot be the zero address.
2872      * - `account` must have at least `amount` tokens.
2873      */
2874     function _burn(address account, uint256 amount) internal virtual {
2875         require(account != address(0), "ERC20: burn from the zero address");
2876 
2877         _beforeTokenTransfer(account, address(0), amount);
2878 
2879         uint256 accountBalance = _balances[account];
2880         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2881         unchecked {
2882             _balances[account] = accountBalance - amount;
2883         }
2884         _totalSupply -= amount;
2885 
2886         emit Transfer(account, address(0), amount);
2887 
2888         _afterTokenTransfer(account, address(0), amount);
2889     }
2890 
2891     /**
2892      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2893      *
2894      * This internal function is equivalent to `approve`, and can be used to
2895      * e.g. set automatic allowances for certain subsystems, etc.
2896      *
2897      * Emits an {Approval} event.
2898      *
2899      * Requirements:
2900      *
2901      * - `owner` cannot be the zero address.
2902      * - `spender` cannot be the zero address.
2903      */
2904     function _approve(
2905         address owner,
2906         address spender,
2907         uint256 amount
2908     ) internal virtual {
2909         require(owner != address(0), "ERC20: approve from the zero address");
2910         require(spender != address(0), "ERC20: approve to the zero address");
2911 
2912         _allowances[owner][spender] = amount;
2913         emit Approval(owner, spender, amount);
2914     }
2915 
2916     /**
2917      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2918      *
2919      * Does not update the allowance amount in case of infinite allowance.
2920      * Revert if not enough allowance is available.
2921      *
2922      * Might emit an {Approval} event.
2923      */
2924     function _spendAllowance(
2925         address owner,
2926         address spender,
2927         uint256 amount
2928     ) internal virtual {
2929         uint256 currentAllowance = allowance(owner, spender);
2930         if (currentAllowance != type(uint256).max) {
2931             require(
2932                 currentAllowance >= amount,
2933                 "ERC20: insufficient allowance"
2934             );
2935             unchecked {
2936                 _approve(owner, spender, currentAllowance - amount);
2937             }
2938         }
2939     }
2940 
2941     /**
2942      * @dev Hook that is called before any transfer of tokens. This includes
2943      * minting and burning.
2944      *
2945      * Calling conditions:
2946      *
2947      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2948      * will be transferred to `to`.
2949      * - when `from` is zero, `amount` tokens will be minted for `to`.
2950      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2951      * - `from` and `to` are never both zero.
2952      *
2953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2954      */
2955     function _beforeTokenTransfer(
2956         address from,
2957         address to,
2958         uint256 amount
2959     ) internal virtual {}
2960 
2961     /**
2962      * @dev Hook that is called after any transfer of tokens. This includes
2963      * minting and burning.
2964      *
2965      * Calling conditions:
2966      *
2967      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2968      * has been transferred to `to`.
2969      * - when `from` is zero, `amount` tokens have been minted for `to`.
2970      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2971      * - `from` and `to` are never both zero.
2972      *
2973      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2974      */
2975     function _afterTokenTransfer(
2976         address from,
2977         address to,
2978         uint256 amount
2979     ) internal virtual {}
2980 }
2981 
2982 // File: hardhat/console.sol
2983 
2984 pragma solidity >=0.4.22 <0.9.0;
2985 
2986 library console {
2987     address constant CONSOLE_ADDRESS =
2988         address(0x000000000000000000636F6e736F6c652e6c6f67);
2989 
2990     function _sendLogPayload(bytes memory payload) private view {
2991         uint256 payloadLength = payload.length;
2992         address consoleAddress = CONSOLE_ADDRESS;
2993         assembly {
2994             let payloadStart := add(payload, 32)
2995             let r := staticcall(
2996                 gas(),
2997                 consoleAddress,
2998                 payloadStart,
2999                 payloadLength,
3000                 0,
3001                 0
3002             )
3003         }
3004     }
3005 
3006     function log() internal view {
3007         _sendLogPayload(abi.encodeWithSignature("log()"));
3008     }
3009 
3010     function logInt(int256 p0) internal view {
3011         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
3012     }
3013 
3014     function logUint(uint256 p0) internal view {
3015         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
3016     }
3017 
3018     function logString(string memory p0) internal view {
3019         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
3020     }
3021 
3022     function logBool(bool p0) internal view {
3023         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
3024     }
3025 
3026     function logAddress(address p0) internal view {
3027         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
3028     }
3029 
3030     function logBytes(bytes memory p0) internal view {
3031         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
3032     }
3033 
3034     function logBytes1(bytes1 p0) internal view {
3035         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
3036     }
3037 
3038     function logBytes2(bytes2 p0) internal view {
3039         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
3040     }
3041 
3042     function logBytes3(bytes3 p0) internal view {
3043         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
3044     }
3045 
3046     function logBytes4(bytes4 p0) internal view {
3047         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
3048     }
3049 
3050     function logBytes5(bytes5 p0) internal view {
3051         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
3052     }
3053 
3054     function logBytes6(bytes6 p0) internal view {
3055         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
3056     }
3057 
3058     function logBytes7(bytes7 p0) internal view {
3059         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
3060     }
3061 
3062     function logBytes8(bytes8 p0) internal view {
3063         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
3064     }
3065 
3066     function logBytes9(bytes9 p0) internal view {
3067         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
3068     }
3069 
3070     function logBytes10(bytes10 p0) internal view {
3071         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
3072     }
3073 
3074     function logBytes11(bytes11 p0) internal view {
3075         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
3076     }
3077 
3078     function logBytes12(bytes12 p0) internal view {
3079         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
3080     }
3081 
3082     function logBytes13(bytes13 p0) internal view {
3083         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
3084     }
3085 
3086     function logBytes14(bytes14 p0) internal view {
3087         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
3088     }
3089 
3090     function logBytes15(bytes15 p0) internal view {
3091         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
3092     }
3093 
3094     function logBytes16(bytes16 p0) internal view {
3095         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
3096     }
3097 
3098     function logBytes17(bytes17 p0) internal view {
3099         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
3100     }
3101 
3102     function logBytes18(bytes18 p0) internal view {
3103         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
3104     }
3105 
3106     function logBytes19(bytes19 p0) internal view {
3107         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
3108     }
3109 
3110     function logBytes20(bytes20 p0) internal view {
3111         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
3112     }
3113 
3114     function logBytes21(bytes21 p0) internal view {
3115         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
3116     }
3117 
3118     function logBytes22(bytes22 p0) internal view {
3119         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
3120     }
3121 
3122     function logBytes23(bytes23 p0) internal view {
3123         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
3124     }
3125 
3126     function logBytes24(bytes24 p0) internal view {
3127         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
3128     }
3129 
3130     function logBytes25(bytes25 p0) internal view {
3131         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
3132     }
3133 
3134     function logBytes26(bytes26 p0) internal view {
3135         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
3136     }
3137 
3138     function logBytes27(bytes27 p0) internal view {
3139         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
3140     }
3141 
3142     function logBytes28(bytes28 p0) internal view {
3143         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
3144     }
3145 
3146     function logBytes29(bytes29 p0) internal view {
3147         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
3148     }
3149 
3150     function logBytes30(bytes30 p0) internal view {
3151         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
3152     }
3153 
3154     function logBytes31(bytes31 p0) internal view {
3155         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
3156     }
3157 
3158     function logBytes32(bytes32 p0) internal view {
3159         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
3160     }
3161 
3162     function log(uint256 p0) internal view {
3163         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
3164     }
3165 
3166     function log(string memory p0) internal view {
3167         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
3168     }
3169 
3170     function log(bool p0) internal view {
3171         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
3172     }
3173 
3174     function log(address p0) internal view {
3175         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
3176     }
3177 
3178     function log(uint256 p0, uint256 p1) internal view {
3179         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
3180     }
3181 
3182     function log(uint256 p0, string memory p1) internal view {
3183         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
3184     }
3185 
3186     function log(uint256 p0, bool p1) internal view {
3187         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
3188     }
3189 
3190     function log(uint256 p0, address p1) internal view {
3191         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
3192     }
3193 
3194     function log(string memory p0, uint256 p1) internal view {
3195         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
3196     }
3197 
3198     function log(string memory p0, string memory p1) internal view {
3199         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
3200     }
3201 
3202     function log(string memory p0, bool p1) internal view {
3203         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
3204     }
3205 
3206     function log(string memory p0, address p1) internal view {
3207         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
3208     }
3209 
3210     function log(bool p0, uint256 p1) internal view {
3211         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
3212     }
3213 
3214     function log(bool p0, string memory p1) internal view {
3215         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
3216     }
3217 
3218     function log(bool p0, bool p1) internal view {
3219         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
3220     }
3221 
3222     function log(bool p0, address p1) internal view {
3223         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
3224     }
3225 
3226     function log(address p0, uint256 p1) internal view {
3227         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
3228     }
3229 
3230     function log(address p0, string memory p1) internal view {
3231         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
3232     }
3233 
3234     function log(address p0, bool p1) internal view {
3235         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
3236     }
3237 
3238     function log(address p0, address p1) internal view {
3239         _sendLogPayload(
3240             abi.encodeWithSignature("log(address,address)", p0, p1)
3241         );
3242     }
3243 
3244     function log(
3245         uint256 p0,
3246         uint256 p1,
3247         uint256 p2
3248     ) internal view {
3249         _sendLogPayload(
3250             abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2)
3251         );
3252     }
3253 
3254     function log(
3255         uint256 p0,
3256         uint256 p1,
3257         string memory p2
3258     ) internal view {
3259         _sendLogPayload(
3260             abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2)
3261         );
3262     }
3263 
3264     function log(
3265         uint256 p0,
3266         uint256 p1,
3267         bool p2
3268     ) internal view {
3269         _sendLogPayload(
3270             abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2)
3271         );
3272     }
3273 
3274     function log(
3275         uint256 p0,
3276         uint256 p1,
3277         address p2
3278     ) internal view {
3279         _sendLogPayload(
3280             abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2)
3281         );
3282     }
3283 
3284     function log(
3285         uint256 p0,
3286         string memory p1,
3287         uint256 p2
3288     ) internal view {
3289         _sendLogPayload(
3290             abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2)
3291         );
3292     }
3293 
3294     function log(
3295         uint256 p0,
3296         string memory p1,
3297         string memory p2
3298     ) internal view {
3299         _sendLogPayload(
3300             abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2)
3301         );
3302     }
3303 
3304     function log(
3305         uint256 p0,
3306         string memory p1,
3307         bool p2
3308     ) internal view {
3309         _sendLogPayload(
3310             abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2)
3311         );
3312     }
3313 
3314     function log(
3315         uint256 p0,
3316         string memory p1,
3317         address p2
3318     ) internal view {
3319         _sendLogPayload(
3320             abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2)
3321         );
3322     }
3323 
3324     function log(
3325         uint256 p0,
3326         bool p1,
3327         uint256 p2
3328     ) internal view {
3329         _sendLogPayload(
3330             abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2)
3331         );
3332     }
3333 
3334     function log(
3335         uint256 p0,
3336         bool p1,
3337         string memory p2
3338     ) internal view {
3339         _sendLogPayload(
3340             abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2)
3341         );
3342     }
3343 
3344     function log(
3345         uint256 p0,
3346         bool p1,
3347         bool p2
3348     ) internal view {
3349         _sendLogPayload(
3350             abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2)
3351         );
3352     }
3353 
3354     function log(
3355         uint256 p0,
3356         bool p1,
3357         address p2
3358     ) internal view {
3359         _sendLogPayload(
3360             abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2)
3361         );
3362     }
3363 
3364     function log(
3365         uint256 p0,
3366         address p1,
3367         uint256 p2
3368     ) internal view {
3369         _sendLogPayload(
3370             abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2)
3371         );
3372     }
3373 
3374     function log(
3375         uint256 p0,
3376         address p1,
3377         string memory p2
3378     ) internal view {
3379         _sendLogPayload(
3380             abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2)
3381         );
3382     }
3383 
3384     function log(
3385         uint256 p0,
3386         address p1,
3387         bool p2
3388     ) internal view {
3389         _sendLogPayload(
3390             abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2)
3391         );
3392     }
3393 
3394     function log(
3395         uint256 p0,
3396         address p1,
3397         address p2
3398     ) internal view {
3399         _sendLogPayload(
3400             abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2)
3401         );
3402     }
3403 
3404     function log(
3405         string memory p0,
3406         uint256 p1,
3407         uint256 p2
3408     ) internal view {
3409         _sendLogPayload(
3410             abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2)
3411         );
3412     }
3413 
3414     function log(
3415         string memory p0,
3416         uint256 p1,
3417         string memory p2
3418     ) internal view {
3419         _sendLogPayload(
3420             abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2)
3421         );
3422     }
3423 
3424     function log(
3425         string memory p0,
3426         uint256 p1,
3427         bool p2
3428     ) internal view {
3429         _sendLogPayload(
3430             abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2)
3431         );
3432     }
3433 
3434     function log(
3435         string memory p0,
3436         uint256 p1,
3437         address p2
3438     ) internal view {
3439         _sendLogPayload(
3440             abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2)
3441         );
3442     }
3443 
3444     function log(
3445         string memory p0,
3446         string memory p1,
3447         uint256 p2
3448     ) internal view {
3449         _sendLogPayload(
3450             abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2)
3451         );
3452     }
3453 
3454     function log(
3455         string memory p0,
3456         string memory p1,
3457         string memory p2
3458     ) internal view {
3459         _sendLogPayload(
3460             abi.encodeWithSignature("log(string,string,string)", p0, p1, p2)
3461         );
3462     }
3463 
3464     function log(
3465         string memory p0,
3466         string memory p1,
3467         bool p2
3468     ) internal view {
3469         _sendLogPayload(
3470             abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2)
3471         );
3472     }
3473 
3474     function log(
3475         string memory p0,
3476         string memory p1,
3477         address p2
3478     ) internal view {
3479         _sendLogPayload(
3480             abi.encodeWithSignature("log(string,string,address)", p0, p1, p2)
3481         );
3482     }
3483 
3484     function log(
3485         string memory p0,
3486         bool p1,
3487         uint256 p2
3488     ) internal view {
3489         _sendLogPayload(
3490             abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2)
3491         );
3492     }
3493 
3494     function log(
3495         string memory p0,
3496         bool p1,
3497         string memory p2
3498     ) internal view {
3499         _sendLogPayload(
3500             abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2)
3501         );
3502     }
3503 
3504     function log(
3505         string memory p0,
3506         bool p1,
3507         bool p2
3508     ) internal view {
3509         _sendLogPayload(
3510             abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2)
3511         );
3512     }
3513 
3514     function log(
3515         string memory p0,
3516         bool p1,
3517         address p2
3518     ) internal view {
3519         _sendLogPayload(
3520             abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2)
3521         );
3522     }
3523 
3524     function log(
3525         string memory p0,
3526         address p1,
3527         uint256 p2
3528     ) internal view {
3529         _sendLogPayload(
3530             abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2)
3531         );
3532     }
3533 
3534     function log(
3535         string memory p0,
3536         address p1,
3537         string memory p2
3538     ) internal view {
3539         _sendLogPayload(
3540             abi.encodeWithSignature("log(string,address,string)", p0, p1, p2)
3541         );
3542     }
3543 
3544     function log(
3545         string memory p0,
3546         address p1,
3547         bool p2
3548     ) internal view {
3549         _sendLogPayload(
3550             abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2)
3551         );
3552     }
3553 
3554     function log(
3555         string memory p0,
3556         address p1,
3557         address p2
3558     ) internal view {
3559         _sendLogPayload(
3560             abi.encodeWithSignature("log(string,address,address)", p0, p1, p2)
3561         );
3562     }
3563 
3564     function log(
3565         bool p0,
3566         uint256 p1,
3567         uint256 p2
3568     ) internal view {
3569         _sendLogPayload(
3570             abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2)
3571         );
3572     }
3573 
3574     function log(
3575         bool p0,
3576         uint256 p1,
3577         string memory p2
3578     ) internal view {
3579         _sendLogPayload(
3580             abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2)
3581         );
3582     }
3583 
3584     function log(
3585         bool p0,
3586         uint256 p1,
3587         bool p2
3588     ) internal view {
3589         _sendLogPayload(
3590             abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2)
3591         );
3592     }
3593 
3594     function log(
3595         bool p0,
3596         uint256 p1,
3597         address p2
3598     ) internal view {
3599         _sendLogPayload(
3600             abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2)
3601         );
3602     }
3603 
3604     function log(
3605         bool p0,
3606         string memory p1,
3607         uint256 p2
3608     ) internal view {
3609         _sendLogPayload(
3610             abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2)
3611         );
3612     }
3613 
3614     function log(
3615         bool p0,
3616         string memory p1,
3617         string memory p2
3618     ) internal view {
3619         _sendLogPayload(
3620             abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2)
3621         );
3622     }
3623 
3624     function log(
3625         bool p0,
3626         string memory p1,
3627         bool p2
3628     ) internal view {
3629         _sendLogPayload(
3630             abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2)
3631         );
3632     }
3633 
3634     function log(
3635         bool p0,
3636         string memory p1,
3637         address p2
3638     ) internal view {
3639         _sendLogPayload(
3640             abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2)
3641         );
3642     }
3643 
3644     function log(
3645         bool p0,
3646         bool p1,
3647         uint256 p2
3648     ) internal view {
3649         _sendLogPayload(
3650             abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2)
3651         );
3652     }
3653 
3654     function log(
3655         bool p0,
3656         bool p1,
3657         string memory p2
3658     ) internal view {
3659         _sendLogPayload(
3660             abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2)
3661         );
3662     }
3663 
3664     function log(
3665         bool p0,
3666         bool p1,
3667         bool p2
3668     ) internal view {
3669         _sendLogPayload(
3670             abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2)
3671         );
3672     }
3673 
3674     function log(
3675         bool p0,
3676         bool p1,
3677         address p2
3678     ) internal view {
3679         _sendLogPayload(
3680             abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2)
3681         );
3682     }
3683 
3684     function log(
3685         bool p0,
3686         address p1,
3687         uint256 p2
3688     ) internal view {
3689         _sendLogPayload(
3690             abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2)
3691         );
3692     }
3693 
3694     function log(
3695         bool p0,
3696         address p1,
3697         string memory p2
3698     ) internal view {
3699         _sendLogPayload(
3700             abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2)
3701         );
3702     }
3703 
3704     function log(
3705         bool p0,
3706         address p1,
3707         bool p2
3708     ) internal view {
3709         _sendLogPayload(
3710             abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2)
3711         );
3712     }
3713 
3714     function log(
3715         bool p0,
3716         address p1,
3717         address p2
3718     ) internal view {
3719         _sendLogPayload(
3720             abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2)
3721         );
3722     }
3723 
3724     function log(
3725         address p0,
3726         uint256 p1,
3727         uint256 p2
3728     ) internal view {
3729         _sendLogPayload(
3730             abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2)
3731         );
3732     }
3733 
3734     function log(
3735         address p0,
3736         uint256 p1,
3737         string memory p2
3738     ) internal view {
3739         _sendLogPayload(
3740             abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2)
3741         );
3742     }
3743 
3744     function log(
3745         address p0,
3746         uint256 p1,
3747         bool p2
3748     ) internal view {
3749         _sendLogPayload(
3750             abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2)
3751         );
3752     }
3753 
3754     function log(
3755         address p0,
3756         uint256 p1,
3757         address p2
3758     ) internal view {
3759         _sendLogPayload(
3760             abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2)
3761         );
3762     }
3763 
3764     function log(
3765         address p0,
3766         string memory p1,
3767         uint256 p2
3768     ) internal view {
3769         _sendLogPayload(
3770             abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2)
3771         );
3772     }
3773 
3774     function log(
3775         address p0,
3776         string memory p1,
3777         string memory p2
3778     ) internal view {
3779         _sendLogPayload(
3780             abi.encodeWithSignature("log(address,string,string)", p0, p1, p2)
3781         );
3782     }
3783 
3784     function log(
3785         address p0,
3786         string memory p1,
3787         bool p2
3788     ) internal view {
3789         _sendLogPayload(
3790             abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2)
3791         );
3792     }
3793 
3794     function log(
3795         address p0,
3796         string memory p1,
3797         address p2
3798     ) internal view {
3799         _sendLogPayload(
3800             abi.encodeWithSignature("log(address,string,address)", p0, p1, p2)
3801         );
3802     }
3803 
3804     function log(
3805         address p0,
3806         bool p1,
3807         uint256 p2
3808     ) internal view {
3809         _sendLogPayload(
3810             abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2)
3811         );
3812     }
3813 
3814     function log(
3815         address p0,
3816         bool p1,
3817         string memory p2
3818     ) internal view {
3819         _sendLogPayload(
3820             abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2)
3821         );
3822     }
3823 
3824     function log(
3825         address p0,
3826         bool p1,
3827         bool p2
3828     ) internal view {
3829         _sendLogPayload(
3830             abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2)
3831         );
3832     }
3833 
3834     function log(
3835         address p0,
3836         bool p1,
3837         address p2
3838     ) internal view {
3839         _sendLogPayload(
3840             abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2)
3841         );
3842     }
3843 
3844     function log(
3845         address p0,
3846         address p1,
3847         uint256 p2
3848     ) internal view {
3849         _sendLogPayload(
3850             abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2)
3851         );
3852     }
3853 
3854     function log(
3855         address p0,
3856         address p1,
3857         string memory p2
3858     ) internal view {
3859         _sendLogPayload(
3860             abi.encodeWithSignature("log(address,address,string)", p0, p1, p2)
3861         );
3862     }
3863 
3864     function log(
3865         address p0,
3866         address p1,
3867         bool p2
3868     ) internal view {
3869         _sendLogPayload(
3870             abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2)
3871         );
3872     }
3873 
3874     function log(
3875         address p0,
3876         address p1,
3877         address p2
3878     ) internal view {
3879         _sendLogPayload(
3880             abi.encodeWithSignature("log(address,address,address)", p0, p1, p2)
3881         );
3882     }
3883 
3884     function log(
3885         uint256 p0,
3886         uint256 p1,
3887         uint256 p2,
3888         uint256 p3
3889     ) internal view {
3890         _sendLogPayload(
3891             abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3)
3892         );
3893     }
3894 
3895     function log(
3896         uint256 p0,
3897         uint256 p1,
3898         uint256 p2,
3899         string memory p3
3900     ) internal view {
3901         _sendLogPayload(
3902             abi.encodeWithSignature(
3903                 "log(uint,uint,uint,string)",
3904                 p0,
3905                 p1,
3906                 p2,
3907                 p3
3908             )
3909         );
3910     }
3911 
3912     function log(
3913         uint256 p0,
3914         uint256 p1,
3915         uint256 p2,
3916         bool p3
3917     ) internal view {
3918         _sendLogPayload(
3919             abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3)
3920         );
3921     }
3922 
3923     function log(
3924         uint256 p0,
3925         uint256 p1,
3926         uint256 p2,
3927         address p3
3928     ) internal view {
3929         _sendLogPayload(
3930             abi.encodeWithSignature(
3931                 "log(uint,uint,uint,address)",
3932                 p0,
3933                 p1,
3934                 p2,
3935                 p3
3936             )
3937         );
3938     }
3939 
3940     function log(
3941         uint256 p0,
3942         uint256 p1,
3943         string memory p2,
3944         uint256 p3
3945     ) internal view {
3946         _sendLogPayload(
3947             abi.encodeWithSignature(
3948                 "log(uint,uint,string,uint)",
3949                 p0,
3950                 p1,
3951                 p2,
3952                 p3
3953             )
3954         );
3955     }
3956 
3957     function log(
3958         uint256 p0,
3959         uint256 p1,
3960         string memory p2,
3961         string memory p3
3962     ) internal view {
3963         _sendLogPayload(
3964             abi.encodeWithSignature(
3965                 "log(uint,uint,string,string)",
3966                 p0,
3967                 p1,
3968                 p2,
3969                 p3
3970             )
3971         );
3972     }
3973 
3974     function log(
3975         uint256 p0,
3976         uint256 p1,
3977         string memory p2,
3978         bool p3
3979     ) internal view {
3980         _sendLogPayload(
3981             abi.encodeWithSignature(
3982                 "log(uint,uint,string,bool)",
3983                 p0,
3984                 p1,
3985                 p2,
3986                 p3
3987             )
3988         );
3989     }
3990 
3991     function log(
3992         uint256 p0,
3993         uint256 p1,
3994         string memory p2,
3995         address p3
3996     ) internal view {
3997         _sendLogPayload(
3998             abi.encodeWithSignature(
3999                 "log(uint,uint,string,address)",
4000                 p0,
4001                 p1,
4002                 p2,
4003                 p3
4004             )
4005         );
4006     }
4007 
4008     function log(
4009         uint256 p0,
4010         uint256 p1,
4011         bool p2,
4012         uint256 p3
4013     ) internal view {
4014         _sendLogPayload(
4015             abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3)
4016         );
4017     }
4018 
4019     function log(
4020         uint256 p0,
4021         uint256 p1,
4022         bool p2,
4023         string memory p3
4024     ) internal view {
4025         _sendLogPayload(
4026             abi.encodeWithSignature(
4027                 "log(uint,uint,bool,string)",
4028                 p0,
4029                 p1,
4030                 p2,
4031                 p3
4032             )
4033         );
4034     }
4035 
4036     function log(
4037         uint256 p0,
4038         uint256 p1,
4039         bool p2,
4040         bool p3
4041     ) internal view {
4042         _sendLogPayload(
4043             abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3)
4044         );
4045     }
4046 
4047     function log(
4048         uint256 p0,
4049         uint256 p1,
4050         bool p2,
4051         address p3
4052     ) internal view {
4053         _sendLogPayload(
4054             abi.encodeWithSignature(
4055                 "log(uint,uint,bool,address)",
4056                 p0,
4057                 p1,
4058                 p2,
4059                 p3
4060             )
4061         );
4062     }
4063 
4064     function log(
4065         uint256 p0,
4066         uint256 p1,
4067         address p2,
4068         uint256 p3
4069     ) internal view {
4070         _sendLogPayload(
4071             abi.encodeWithSignature(
4072                 "log(uint,uint,address,uint)",
4073                 p0,
4074                 p1,
4075                 p2,
4076                 p3
4077             )
4078         );
4079     }
4080 
4081     function log(
4082         uint256 p0,
4083         uint256 p1,
4084         address p2,
4085         string memory p3
4086     ) internal view {
4087         _sendLogPayload(
4088             abi.encodeWithSignature(
4089                 "log(uint,uint,address,string)",
4090                 p0,
4091                 p1,
4092                 p2,
4093                 p3
4094             )
4095         );
4096     }
4097 
4098     function log(
4099         uint256 p0,
4100         uint256 p1,
4101         address p2,
4102         bool p3
4103     ) internal view {
4104         _sendLogPayload(
4105             abi.encodeWithSignature(
4106                 "log(uint,uint,address,bool)",
4107                 p0,
4108                 p1,
4109                 p2,
4110                 p3
4111             )
4112         );
4113     }
4114 
4115     function log(
4116         uint256 p0,
4117         uint256 p1,
4118         address p2,
4119         address p3
4120     ) internal view {
4121         _sendLogPayload(
4122             abi.encodeWithSignature(
4123                 "log(uint,uint,address,address)",
4124                 p0,
4125                 p1,
4126                 p2,
4127                 p3
4128             )
4129         );
4130     }
4131 
4132     function log(
4133         uint256 p0,
4134         string memory p1,
4135         uint256 p2,
4136         uint256 p3
4137     ) internal view {
4138         _sendLogPayload(
4139             abi.encodeWithSignature(
4140                 "log(uint,string,uint,uint)",
4141                 p0,
4142                 p1,
4143                 p2,
4144                 p3
4145             )
4146         );
4147     }
4148 
4149     function log(
4150         uint256 p0,
4151         string memory p1,
4152         uint256 p2,
4153         string memory p3
4154     ) internal view {
4155         _sendLogPayload(
4156             abi.encodeWithSignature(
4157                 "log(uint,string,uint,string)",
4158                 p0,
4159                 p1,
4160                 p2,
4161                 p3
4162             )
4163         );
4164     }
4165 
4166     function log(
4167         uint256 p0,
4168         string memory p1,
4169         uint256 p2,
4170         bool p3
4171     ) internal view {
4172         _sendLogPayload(
4173             abi.encodeWithSignature(
4174                 "log(uint,string,uint,bool)",
4175                 p0,
4176                 p1,
4177                 p2,
4178                 p3
4179             )
4180         );
4181     }
4182 
4183     function log(
4184         uint256 p0,
4185         string memory p1,
4186         uint256 p2,
4187         address p3
4188     ) internal view {
4189         _sendLogPayload(
4190             abi.encodeWithSignature(
4191                 "log(uint,string,uint,address)",
4192                 p0,
4193                 p1,
4194                 p2,
4195                 p3
4196             )
4197         );
4198     }
4199 
4200     function log(
4201         uint256 p0,
4202         string memory p1,
4203         string memory p2,
4204         uint256 p3
4205     ) internal view {
4206         _sendLogPayload(
4207             abi.encodeWithSignature(
4208                 "log(uint,string,string,uint)",
4209                 p0,
4210                 p1,
4211                 p2,
4212                 p3
4213             )
4214         );
4215     }
4216 
4217     function log(
4218         uint256 p0,
4219         string memory p1,
4220         string memory p2,
4221         string memory p3
4222     ) internal view {
4223         _sendLogPayload(
4224             abi.encodeWithSignature(
4225                 "log(uint,string,string,string)",
4226                 p0,
4227                 p1,
4228                 p2,
4229                 p3
4230             )
4231         );
4232     }
4233 
4234     function log(
4235         uint256 p0,
4236         string memory p1,
4237         string memory p2,
4238         bool p3
4239     ) internal view {
4240         _sendLogPayload(
4241             abi.encodeWithSignature(
4242                 "log(uint,string,string,bool)",
4243                 p0,
4244                 p1,
4245                 p2,
4246                 p3
4247             )
4248         );
4249     }
4250 
4251     function log(
4252         uint256 p0,
4253         string memory p1,
4254         string memory p2,
4255         address p3
4256     ) internal view {
4257         _sendLogPayload(
4258             abi.encodeWithSignature(
4259                 "log(uint,string,string,address)",
4260                 p0,
4261                 p1,
4262                 p2,
4263                 p3
4264             )
4265         );
4266     }
4267 
4268     function log(
4269         uint256 p0,
4270         string memory p1,
4271         bool p2,
4272         uint256 p3
4273     ) internal view {
4274         _sendLogPayload(
4275             abi.encodeWithSignature(
4276                 "log(uint,string,bool,uint)",
4277                 p0,
4278                 p1,
4279                 p2,
4280                 p3
4281             )
4282         );
4283     }
4284 
4285     function log(
4286         uint256 p0,
4287         string memory p1,
4288         bool p2,
4289         string memory p3
4290     ) internal view {
4291         _sendLogPayload(
4292             abi.encodeWithSignature(
4293                 "log(uint,string,bool,string)",
4294                 p0,
4295                 p1,
4296                 p2,
4297                 p3
4298             )
4299         );
4300     }
4301 
4302     function log(
4303         uint256 p0,
4304         string memory p1,
4305         bool p2,
4306         bool p3
4307     ) internal view {
4308         _sendLogPayload(
4309             abi.encodeWithSignature(
4310                 "log(uint,string,bool,bool)",
4311                 p0,
4312                 p1,
4313                 p2,
4314                 p3
4315             )
4316         );
4317     }
4318 
4319     function log(
4320         uint256 p0,
4321         string memory p1,
4322         bool p2,
4323         address p3
4324     ) internal view {
4325         _sendLogPayload(
4326             abi.encodeWithSignature(
4327                 "log(uint,string,bool,address)",
4328                 p0,
4329                 p1,
4330                 p2,
4331                 p3
4332             )
4333         );
4334     }
4335 
4336     function log(
4337         uint256 p0,
4338         string memory p1,
4339         address p2,
4340         uint256 p3
4341     ) internal view {
4342         _sendLogPayload(
4343             abi.encodeWithSignature(
4344                 "log(uint,string,address,uint)",
4345                 p0,
4346                 p1,
4347                 p2,
4348                 p3
4349             )
4350         );
4351     }
4352 
4353     function log(
4354         uint256 p0,
4355         string memory p1,
4356         address p2,
4357         string memory p3
4358     ) internal view {
4359         _sendLogPayload(
4360             abi.encodeWithSignature(
4361                 "log(uint,string,address,string)",
4362                 p0,
4363                 p1,
4364                 p2,
4365                 p3
4366             )
4367         );
4368     }
4369 
4370     function log(
4371         uint256 p0,
4372         string memory p1,
4373         address p2,
4374         bool p3
4375     ) internal view {
4376         _sendLogPayload(
4377             abi.encodeWithSignature(
4378                 "log(uint,string,address,bool)",
4379                 p0,
4380                 p1,
4381                 p2,
4382                 p3
4383             )
4384         );
4385     }
4386 
4387     function log(
4388         uint256 p0,
4389         string memory p1,
4390         address p2,
4391         address p3
4392     ) internal view {
4393         _sendLogPayload(
4394             abi.encodeWithSignature(
4395                 "log(uint,string,address,address)",
4396                 p0,
4397                 p1,
4398                 p2,
4399                 p3
4400             )
4401         );
4402     }
4403 
4404     function log(
4405         uint256 p0,
4406         bool p1,
4407         uint256 p2,
4408         uint256 p3
4409     ) internal view {
4410         _sendLogPayload(
4411             abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3)
4412         );
4413     }
4414 
4415     function log(
4416         uint256 p0,
4417         bool p1,
4418         uint256 p2,
4419         string memory p3
4420     ) internal view {
4421         _sendLogPayload(
4422             abi.encodeWithSignature(
4423                 "log(uint,bool,uint,string)",
4424                 p0,
4425                 p1,
4426                 p2,
4427                 p3
4428             )
4429         );
4430     }
4431 
4432     function log(
4433         uint256 p0,
4434         bool p1,
4435         uint256 p2,
4436         bool p3
4437     ) internal view {
4438         _sendLogPayload(
4439             abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3)
4440         );
4441     }
4442 
4443     function log(
4444         uint256 p0,
4445         bool p1,
4446         uint256 p2,
4447         address p3
4448     ) internal view {
4449         _sendLogPayload(
4450             abi.encodeWithSignature(
4451                 "log(uint,bool,uint,address)",
4452                 p0,
4453                 p1,
4454                 p2,
4455                 p3
4456             )
4457         );
4458     }
4459 
4460     function log(
4461         uint256 p0,
4462         bool p1,
4463         string memory p2,
4464         uint256 p3
4465     ) internal view {
4466         _sendLogPayload(
4467             abi.encodeWithSignature(
4468                 "log(uint,bool,string,uint)",
4469                 p0,
4470                 p1,
4471                 p2,
4472                 p3
4473             )
4474         );
4475     }
4476 
4477     function log(
4478         uint256 p0,
4479         bool p1,
4480         string memory p2,
4481         string memory p3
4482     ) internal view {
4483         _sendLogPayload(
4484             abi.encodeWithSignature(
4485                 "log(uint,bool,string,string)",
4486                 p0,
4487                 p1,
4488                 p2,
4489                 p3
4490             )
4491         );
4492     }
4493 
4494     function log(
4495         uint256 p0,
4496         bool p1,
4497         string memory p2,
4498         bool p3
4499     ) internal view {
4500         _sendLogPayload(
4501             abi.encodeWithSignature(
4502                 "log(uint,bool,string,bool)",
4503                 p0,
4504                 p1,
4505                 p2,
4506                 p3
4507             )
4508         );
4509     }
4510 
4511     function log(
4512         uint256 p0,
4513         bool p1,
4514         string memory p2,
4515         address p3
4516     ) internal view {
4517         _sendLogPayload(
4518             abi.encodeWithSignature(
4519                 "log(uint,bool,string,address)",
4520                 p0,
4521                 p1,
4522                 p2,
4523                 p3
4524             )
4525         );
4526     }
4527 
4528     function log(
4529         uint256 p0,
4530         bool p1,
4531         bool p2,
4532         uint256 p3
4533     ) internal view {
4534         _sendLogPayload(
4535             abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3)
4536         );
4537     }
4538 
4539     function log(
4540         uint256 p0,
4541         bool p1,
4542         bool p2,
4543         string memory p3
4544     ) internal view {
4545         _sendLogPayload(
4546             abi.encodeWithSignature(
4547                 "log(uint,bool,bool,string)",
4548                 p0,
4549                 p1,
4550                 p2,
4551                 p3
4552             )
4553         );
4554     }
4555 
4556     function log(
4557         uint256 p0,
4558         bool p1,
4559         bool p2,
4560         bool p3
4561     ) internal view {
4562         _sendLogPayload(
4563             abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3)
4564         );
4565     }
4566 
4567     function log(
4568         uint256 p0,
4569         bool p1,
4570         bool p2,
4571         address p3
4572     ) internal view {
4573         _sendLogPayload(
4574             abi.encodeWithSignature(
4575                 "log(uint,bool,bool,address)",
4576                 p0,
4577                 p1,
4578                 p2,
4579                 p3
4580             )
4581         );
4582     }
4583 
4584     function log(
4585         uint256 p0,
4586         bool p1,
4587         address p2,
4588         uint256 p3
4589     ) internal view {
4590         _sendLogPayload(
4591             abi.encodeWithSignature(
4592                 "log(uint,bool,address,uint)",
4593                 p0,
4594                 p1,
4595                 p2,
4596                 p3
4597             )
4598         );
4599     }
4600 
4601     function log(
4602         uint256 p0,
4603         bool p1,
4604         address p2,
4605         string memory p3
4606     ) internal view {
4607         _sendLogPayload(
4608             abi.encodeWithSignature(
4609                 "log(uint,bool,address,string)",
4610                 p0,
4611                 p1,
4612                 p2,
4613                 p3
4614             )
4615         );
4616     }
4617 
4618     function log(
4619         uint256 p0,
4620         bool p1,
4621         address p2,
4622         bool p3
4623     ) internal view {
4624         _sendLogPayload(
4625             abi.encodeWithSignature(
4626                 "log(uint,bool,address,bool)",
4627                 p0,
4628                 p1,
4629                 p2,
4630                 p3
4631             )
4632         );
4633     }
4634 
4635     function log(
4636         uint256 p0,
4637         bool p1,
4638         address p2,
4639         address p3
4640     ) internal view {
4641         _sendLogPayload(
4642             abi.encodeWithSignature(
4643                 "log(uint,bool,address,address)",
4644                 p0,
4645                 p1,
4646                 p2,
4647                 p3
4648             )
4649         );
4650     }
4651 
4652     function log(
4653         uint256 p0,
4654         address p1,
4655         uint256 p2,
4656         uint256 p3
4657     ) internal view {
4658         _sendLogPayload(
4659             abi.encodeWithSignature(
4660                 "log(uint,address,uint,uint)",
4661                 p0,
4662                 p1,
4663                 p2,
4664                 p3
4665             )
4666         );
4667     }
4668 
4669     function log(
4670         uint256 p0,
4671         address p1,
4672         uint256 p2,
4673         string memory p3
4674     ) internal view {
4675         _sendLogPayload(
4676             abi.encodeWithSignature(
4677                 "log(uint,address,uint,string)",
4678                 p0,
4679                 p1,
4680                 p2,
4681                 p3
4682             )
4683         );
4684     }
4685 
4686     function log(
4687         uint256 p0,
4688         address p1,
4689         uint256 p2,
4690         bool p3
4691     ) internal view {
4692         _sendLogPayload(
4693             abi.encodeWithSignature(
4694                 "log(uint,address,uint,bool)",
4695                 p0,
4696                 p1,
4697                 p2,
4698                 p3
4699             )
4700         );
4701     }
4702 
4703     function log(
4704         uint256 p0,
4705         address p1,
4706         uint256 p2,
4707         address p3
4708     ) internal view {
4709         _sendLogPayload(
4710             abi.encodeWithSignature(
4711                 "log(uint,address,uint,address)",
4712                 p0,
4713                 p1,
4714                 p2,
4715                 p3
4716             )
4717         );
4718     }
4719 
4720     function log(
4721         uint256 p0,
4722         address p1,
4723         string memory p2,
4724         uint256 p3
4725     ) internal view {
4726         _sendLogPayload(
4727             abi.encodeWithSignature(
4728                 "log(uint,address,string,uint)",
4729                 p0,
4730                 p1,
4731                 p2,
4732                 p3
4733             )
4734         );
4735     }
4736 
4737     function log(
4738         uint256 p0,
4739         address p1,
4740         string memory p2,
4741         string memory p3
4742     ) internal view {
4743         _sendLogPayload(
4744             abi.encodeWithSignature(
4745                 "log(uint,address,string,string)",
4746                 p0,
4747                 p1,
4748                 p2,
4749                 p3
4750             )
4751         );
4752     }
4753 
4754     function log(
4755         uint256 p0,
4756         address p1,
4757         string memory p2,
4758         bool p3
4759     ) internal view {
4760         _sendLogPayload(
4761             abi.encodeWithSignature(
4762                 "log(uint,address,string,bool)",
4763                 p0,
4764                 p1,
4765                 p2,
4766                 p3
4767             )
4768         );
4769     }
4770 
4771     function log(
4772         uint256 p0,
4773         address p1,
4774         string memory p2,
4775         address p3
4776     ) internal view {
4777         _sendLogPayload(
4778             abi.encodeWithSignature(
4779                 "log(uint,address,string,address)",
4780                 p0,
4781                 p1,
4782                 p2,
4783                 p3
4784             )
4785         );
4786     }
4787 
4788     function log(
4789         uint256 p0,
4790         address p1,
4791         bool p2,
4792         uint256 p3
4793     ) internal view {
4794         _sendLogPayload(
4795             abi.encodeWithSignature(
4796                 "log(uint,address,bool,uint)",
4797                 p0,
4798                 p1,
4799                 p2,
4800                 p3
4801             )
4802         );
4803     }
4804 
4805     function log(
4806         uint256 p0,
4807         address p1,
4808         bool p2,
4809         string memory p3
4810     ) internal view {
4811         _sendLogPayload(
4812             abi.encodeWithSignature(
4813                 "log(uint,address,bool,string)",
4814                 p0,
4815                 p1,
4816                 p2,
4817                 p3
4818             )
4819         );
4820     }
4821 
4822     function log(
4823         uint256 p0,
4824         address p1,
4825         bool p2,
4826         bool p3
4827     ) internal view {
4828         _sendLogPayload(
4829             abi.encodeWithSignature(
4830                 "log(uint,address,bool,bool)",
4831                 p0,
4832                 p1,
4833                 p2,
4834                 p3
4835             )
4836         );
4837     }
4838 
4839     function log(
4840         uint256 p0,
4841         address p1,
4842         bool p2,
4843         address p3
4844     ) internal view {
4845         _sendLogPayload(
4846             abi.encodeWithSignature(
4847                 "log(uint,address,bool,address)",
4848                 p0,
4849                 p1,
4850                 p2,
4851                 p3
4852             )
4853         );
4854     }
4855 
4856     function log(
4857         uint256 p0,
4858         address p1,
4859         address p2,
4860         uint256 p3
4861     ) internal view {
4862         _sendLogPayload(
4863             abi.encodeWithSignature(
4864                 "log(uint,address,address,uint)",
4865                 p0,
4866                 p1,
4867                 p2,
4868                 p3
4869             )
4870         );
4871     }
4872 
4873     function log(
4874         uint256 p0,
4875         address p1,
4876         address p2,
4877         string memory p3
4878     ) internal view {
4879         _sendLogPayload(
4880             abi.encodeWithSignature(
4881                 "log(uint,address,address,string)",
4882                 p0,
4883                 p1,
4884                 p2,
4885                 p3
4886             )
4887         );
4888     }
4889 
4890     function log(
4891         uint256 p0,
4892         address p1,
4893         address p2,
4894         bool p3
4895     ) internal view {
4896         _sendLogPayload(
4897             abi.encodeWithSignature(
4898                 "log(uint,address,address,bool)",
4899                 p0,
4900                 p1,
4901                 p2,
4902                 p3
4903             )
4904         );
4905     }
4906 
4907     function log(
4908         uint256 p0,
4909         address p1,
4910         address p2,
4911         address p3
4912     ) internal view {
4913         _sendLogPayload(
4914             abi.encodeWithSignature(
4915                 "log(uint,address,address,address)",
4916                 p0,
4917                 p1,
4918                 p2,
4919                 p3
4920             )
4921         );
4922     }
4923 
4924     function log(
4925         string memory p0,
4926         uint256 p1,
4927         uint256 p2,
4928         uint256 p3
4929     ) internal view {
4930         _sendLogPayload(
4931             abi.encodeWithSignature(
4932                 "log(string,uint,uint,uint)",
4933                 p0,
4934                 p1,
4935                 p2,
4936                 p3
4937             )
4938         );
4939     }
4940 
4941     function log(
4942         string memory p0,
4943         uint256 p1,
4944         uint256 p2,
4945         string memory p3
4946     ) internal view {
4947         _sendLogPayload(
4948             abi.encodeWithSignature(
4949                 "log(string,uint,uint,string)",
4950                 p0,
4951                 p1,
4952                 p2,
4953                 p3
4954             )
4955         );
4956     }
4957 
4958     function log(
4959         string memory p0,
4960         uint256 p1,
4961         uint256 p2,
4962         bool p3
4963     ) internal view {
4964         _sendLogPayload(
4965             abi.encodeWithSignature(
4966                 "log(string,uint,uint,bool)",
4967                 p0,
4968                 p1,
4969                 p2,
4970                 p3
4971             )
4972         );
4973     }
4974 
4975     function log(
4976         string memory p0,
4977         uint256 p1,
4978         uint256 p2,
4979         address p3
4980     ) internal view {
4981         _sendLogPayload(
4982             abi.encodeWithSignature(
4983                 "log(string,uint,uint,address)",
4984                 p0,
4985                 p1,
4986                 p2,
4987                 p3
4988             )
4989         );
4990     }
4991 
4992     function log(
4993         string memory p0,
4994         uint256 p1,
4995         string memory p2,
4996         uint256 p3
4997     ) internal view {
4998         _sendLogPayload(
4999             abi.encodeWithSignature(
5000                 "log(string,uint,string,uint)",
5001                 p0,
5002                 p1,
5003                 p2,
5004                 p3
5005             )
5006         );
5007     }
5008 
5009     function log(
5010         string memory p0,
5011         uint256 p1,
5012         string memory p2,
5013         string memory p3
5014     ) internal view {
5015         _sendLogPayload(
5016             abi.encodeWithSignature(
5017                 "log(string,uint,string,string)",
5018                 p0,
5019                 p1,
5020                 p2,
5021                 p3
5022             )
5023         );
5024     }
5025 
5026     function log(
5027         string memory p0,
5028         uint256 p1,
5029         string memory p2,
5030         bool p3
5031     ) internal view {
5032         _sendLogPayload(
5033             abi.encodeWithSignature(
5034                 "log(string,uint,string,bool)",
5035                 p0,
5036                 p1,
5037                 p2,
5038                 p3
5039             )
5040         );
5041     }
5042 
5043     function log(
5044         string memory p0,
5045         uint256 p1,
5046         string memory p2,
5047         address p3
5048     ) internal view {
5049         _sendLogPayload(
5050             abi.encodeWithSignature(
5051                 "log(string,uint,string,address)",
5052                 p0,
5053                 p1,
5054                 p2,
5055                 p3
5056             )
5057         );
5058     }
5059 
5060     function log(
5061         string memory p0,
5062         uint256 p1,
5063         bool p2,
5064         uint256 p3
5065     ) internal view {
5066         _sendLogPayload(
5067             abi.encodeWithSignature(
5068                 "log(string,uint,bool,uint)",
5069                 p0,
5070                 p1,
5071                 p2,
5072                 p3
5073             )
5074         );
5075     }
5076 
5077     function log(
5078         string memory p0,
5079         uint256 p1,
5080         bool p2,
5081         string memory p3
5082     ) internal view {
5083         _sendLogPayload(
5084             abi.encodeWithSignature(
5085                 "log(string,uint,bool,string)",
5086                 p0,
5087                 p1,
5088                 p2,
5089                 p3
5090             )
5091         );
5092     }
5093 
5094     function log(
5095         string memory p0,
5096         uint256 p1,
5097         bool p2,
5098         bool p3
5099     ) internal view {
5100         _sendLogPayload(
5101             abi.encodeWithSignature(
5102                 "log(string,uint,bool,bool)",
5103                 p0,
5104                 p1,
5105                 p2,
5106                 p3
5107             )
5108         );
5109     }
5110 
5111     function log(
5112         string memory p0,
5113         uint256 p1,
5114         bool p2,
5115         address p3
5116     ) internal view {
5117         _sendLogPayload(
5118             abi.encodeWithSignature(
5119                 "log(string,uint,bool,address)",
5120                 p0,
5121                 p1,
5122                 p2,
5123                 p3
5124             )
5125         );
5126     }
5127 
5128     function log(
5129         string memory p0,
5130         uint256 p1,
5131         address p2,
5132         uint256 p3
5133     ) internal view {
5134         _sendLogPayload(
5135             abi.encodeWithSignature(
5136                 "log(string,uint,address,uint)",
5137                 p0,
5138                 p1,
5139                 p2,
5140                 p3
5141             )
5142         );
5143     }
5144 
5145     function log(
5146         string memory p0,
5147         uint256 p1,
5148         address p2,
5149         string memory p3
5150     ) internal view {
5151         _sendLogPayload(
5152             abi.encodeWithSignature(
5153                 "log(string,uint,address,string)",
5154                 p0,
5155                 p1,
5156                 p2,
5157                 p3
5158             )
5159         );
5160     }
5161 
5162     function log(
5163         string memory p0,
5164         uint256 p1,
5165         address p2,
5166         bool p3
5167     ) internal view {
5168         _sendLogPayload(
5169             abi.encodeWithSignature(
5170                 "log(string,uint,address,bool)",
5171                 p0,
5172                 p1,
5173                 p2,
5174                 p3
5175             )
5176         );
5177     }
5178 
5179     function log(
5180         string memory p0,
5181         uint256 p1,
5182         address p2,
5183         address p3
5184     ) internal view {
5185         _sendLogPayload(
5186             abi.encodeWithSignature(
5187                 "log(string,uint,address,address)",
5188                 p0,
5189                 p1,
5190                 p2,
5191                 p3
5192             )
5193         );
5194     }
5195 
5196     function log(
5197         string memory p0,
5198         string memory p1,
5199         uint256 p2,
5200         uint256 p3
5201     ) internal view {
5202         _sendLogPayload(
5203             abi.encodeWithSignature(
5204                 "log(string,string,uint,uint)",
5205                 p0,
5206                 p1,
5207                 p2,
5208                 p3
5209             )
5210         );
5211     }
5212 
5213     function log(
5214         string memory p0,
5215         string memory p1,
5216         uint256 p2,
5217         string memory p3
5218     ) internal view {
5219         _sendLogPayload(
5220             abi.encodeWithSignature(
5221                 "log(string,string,uint,string)",
5222                 p0,
5223                 p1,
5224                 p2,
5225                 p3
5226             )
5227         );
5228     }
5229 
5230     function log(
5231         string memory p0,
5232         string memory p1,
5233         uint256 p2,
5234         bool p3
5235     ) internal view {
5236         _sendLogPayload(
5237             abi.encodeWithSignature(
5238                 "log(string,string,uint,bool)",
5239                 p0,
5240                 p1,
5241                 p2,
5242                 p3
5243             )
5244         );
5245     }
5246 
5247     function log(
5248         string memory p0,
5249         string memory p1,
5250         uint256 p2,
5251         address p3
5252     ) internal view {
5253         _sendLogPayload(
5254             abi.encodeWithSignature(
5255                 "log(string,string,uint,address)",
5256                 p0,
5257                 p1,
5258                 p2,
5259                 p3
5260             )
5261         );
5262     }
5263 
5264     function log(
5265         string memory p0,
5266         string memory p1,
5267         string memory p2,
5268         uint256 p3
5269     ) internal view {
5270         _sendLogPayload(
5271             abi.encodeWithSignature(
5272                 "log(string,string,string,uint)",
5273                 p0,
5274                 p1,
5275                 p2,
5276                 p3
5277             )
5278         );
5279     }
5280 
5281     function log(
5282         string memory p0,
5283         string memory p1,
5284         string memory p2,
5285         string memory p3
5286     ) internal view {
5287         _sendLogPayload(
5288             abi.encodeWithSignature(
5289                 "log(string,string,string,string)",
5290                 p0,
5291                 p1,
5292                 p2,
5293                 p3
5294             )
5295         );
5296     }
5297 
5298     function log(
5299         string memory p0,
5300         string memory p1,
5301         string memory p2,
5302         bool p3
5303     ) internal view {
5304         _sendLogPayload(
5305             abi.encodeWithSignature(
5306                 "log(string,string,string,bool)",
5307                 p0,
5308                 p1,
5309                 p2,
5310                 p3
5311             )
5312         );
5313     }
5314 
5315     function log(
5316         string memory p0,
5317         string memory p1,
5318         string memory p2,
5319         address p3
5320     ) internal view {
5321         _sendLogPayload(
5322             abi.encodeWithSignature(
5323                 "log(string,string,string,address)",
5324                 p0,
5325                 p1,
5326                 p2,
5327                 p3
5328             )
5329         );
5330     }
5331 
5332     function log(
5333         string memory p0,
5334         string memory p1,
5335         bool p2,
5336         uint256 p3
5337     ) internal view {
5338         _sendLogPayload(
5339             abi.encodeWithSignature(
5340                 "log(string,string,bool,uint)",
5341                 p0,
5342                 p1,
5343                 p2,
5344                 p3
5345             )
5346         );
5347     }
5348 
5349     function log(
5350         string memory p0,
5351         string memory p1,
5352         bool p2,
5353         string memory p3
5354     ) internal view {
5355         _sendLogPayload(
5356             abi.encodeWithSignature(
5357                 "log(string,string,bool,string)",
5358                 p0,
5359                 p1,
5360                 p2,
5361                 p3
5362             )
5363         );
5364     }
5365 
5366     function log(
5367         string memory p0,
5368         string memory p1,
5369         bool p2,
5370         bool p3
5371     ) internal view {
5372         _sendLogPayload(
5373             abi.encodeWithSignature(
5374                 "log(string,string,bool,bool)",
5375                 p0,
5376                 p1,
5377                 p2,
5378                 p3
5379             )
5380         );
5381     }
5382 
5383     function log(
5384         string memory p0,
5385         string memory p1,
5386         bool p2,
5387         address p3
5388     ) internal view {
5389         _sendLogPayload(
5390             abi.encodeWithSignature(
5391                 "log(string,string,bool,address)",
5392                 p0,
5393                 p1,
5394                 p2,
5395                 p3
5396             )
5397         );
5398     }
5399 
5400     function log(
5401         string memory p0,
5402         string memory p1,
5403         address p2,
5404         uint256 p3
5405     ) internal view {
5406         _sendLogPayload(
5407             abi.encodeWithSignature(
5408                 "log(string,string,address,uint)",
5409                 p0,
5410                 p1,
5411                 p2,
5412                 p3
5413             )
5414         );
5415     }
5416 
5417     function log(
5418         string memory p0,
5419         string memory p1,
5420         address p2,
5421         string memory p3
5422     ) internal view {
5423         _sendLogPayload(
5424             abi.encodeWithSignature(
5425                 "log(string,string,address,string)",
5426                 p0,
5427                 p1,
5428                 p2,
5429                 p3
5430             )
5431         );
5432     }
5433 
5434     function log(
5435         string memory p0,
5436         string memory p1,
5437         address p2,
5438         bool p3
5439     ) internal view {
5440         _sendLogPayload(
5441             abi.encodeWithSignature(
5442                 "log(string,string,address,bool)",
5443                 p0,
5444                 p1,
5445                 p2,
5446                 p3
5447             )
5448         );
5449     }
5450 
5451     function log(
5452         string memory p0,
5453         string memory p1,
5454         address p2,
5455         address p3
5456     ) internal view {
5457         _sendLogPayload(
5458             abi.encodeWithSignature(
5459                 "log(string,string,address,address)",
5460                 p0,
5461                 p1,
5462                 p2,
5463                 p3
5464             )
5465         );
5466     }
5467 
5468     function log(
5469         string memory p0,
5470         bool p1,
5471         uint256 p2,
5472         uint256 p3
5473     ) internal view {
5474         _sendLogPayload(
5475             abi.encodeWithSignature(
5476                 "log(string,bool,uint,uint)",
5477                 p0,
5478                 p1,
5479                 p2,
5480                 p3
5481             )
5482         );
5483     }
5484 
5485     function log(
5486         string memory p0,
5487         bool p1,
5488         uint256 p2,
5489         string memory p3
5490     ) internal view {
5491         _sendLogPayload(
5492             abi.encodeWithSignature(
5493                 "log(string,bool,uint,string)",
5494                 p0,
5495                 p1,
5496                 p2,
5497                 p3
5498             )
5499         );
5500     }
5501 
5502     function log(
5503         string memory p0,
5504         bool p1,
5505         uint256 p2,
5506         bool p3
5507     ) internal view {
5508         _sendLogPayload(
5509             abi.encodeWithSignature(
5510                 "log(string,bool,uint,bool)",
5511                 p0,
5512                 p1,
5513                 p2,
5514                 p3
5515             )
5516         );
5517     }
5518 
5519     function log(
5520         string memory p0,
5521         bool p1,
5522         uint256 p2,
5523         address p3
5524     ) internal view {
5525         _sendLogPayload(
5526             abi.encodeWithSignature(
5527                 "log(string,bool,uint,address)",
5528                 p0,
5529                 p1,
5530                 p2,
5531                 p3
5532             )
5533         );
5534     }
5535 
5536     function log(
5537         string memory p0,
5538         bool p1,
5539         string memory p2,
5540         uint256 p3
5541     ) internal view {
5542         _sendLogPayload(
5543             abi.encodeWithSignature(
5544                 "log(string,bool,string,uint)",
5545                 p0,
5546                 p1,
5547                 p2,
5548                 p3
5549             )
5550         );
5551     }
5552 
5553     function log(
5554         string memory p0,
5555         bool p1,
5556         string memory p2,
5557         string memory p3
5558     ) internal view {
5559         _sendLogPayload(
5560             abi.encodeWithSignature(
5561                 "log(string,bool,string,string)",
5562                 p0,
5563                 p1,
5564                 p2,
5565                 p3
5566             )
5567         );
5568     }
5569 
5570     function log(
5571         string memory p0,
5572         bool p1,
5573         string memory p2,
5574         bool p3
5575     ) internal view {
5576         _sendLogPayload(
5577             abi.encodeWithSignature(
5578                 "log(string,bool,string,bool)",
5579                 p0,
5580                 p1,
5581                 p2,
5582                 p3
5583             )
5584         );
5585     }
5586 
5587     function log(
5588         string memory p0,
5589         bool p1,
5590         string memory p2,
5591         address p3
5592     ) internal view {
5593         _sendLogPayload(
5594             abi.encodeWithSignature(
5595                 "log(string,bool,string,address)",
5596                 p0,
5597                 p1,
5598                 p2,
5599                 p3
5600             )
5601         );
5602     }
5603 
5604     function log(
5605         string memory p0,
5606         bool p1,
5607         bool p2,
5608         uint256 p3
5609     ) internal view {
5610         _sendLogPayload(
5611             abi.encodeWithSignature(
5612                 "log(string,bool,bool,uint)",
5613                 p0,
5614                 p1,
5615                 p2,
5616                 p3
5617             )
5618         );
5619     }
5620 
5621     function log(
5622         string memory p0,
5623         bool p1,
5624         bool p2,
5625         string memory p3
5626     ) internal view {
5627         _sendLogPayload(
5628             abi.encodeWithSignature(
5629                 "log(string,bool,bool,string)",
5630                 p0,
5631                 p1,
5632                 p2,
5633                 p3
5634             )
5635         );
5636     }
5637 
5638     function log(
5639         string memory p0,
5640         bool p1,
5641         bool p2,
5642         bool p3
5643     ) internal view {
5644         _sendLogPayload(
5645             abi.encodeWithSignature(
5646                 "log(string,bool,bool,bool)",
5647                 p0,
5648                 p1,
5649                 p2,
5650                 p3
5651             )
5652         );
5653     }
5654 
5655     function log(
5656         string memory p0,
5657         bool p1,
5658         bool p2,
5659         address p3
5660     ) internal view {
5661         _sendLogPayload(
5662             abi.encodeWithSignature(
5663                 "log(string,bool,bool,address)",
5664                 p0,
5665                 p1,
5666                 p2,
5667                 p3
5668             )
5669         );
5670     }
5671 
5672     function log(
5673         string memory p0,
5674         bool p1,
5675         address p2,
5676         uint256 p3
5677     ) internal view {
5678         _sendLogPayload(
5679             abi.encodeWithSignature(
5680                 "log(string,bool,address,uint)",
5681                 p0,
5682                 p1,
5683                 p2,
5684                 p3
5685             )
5686         );
5687     }
5688 
5689     function log(
5690         string memory p0,
5691         bool p1,
5692         address p2,
5693         string memory p3
5694     ) internal view {
5695         _sendLogPayload(
5696             abi.encodeWithSignature(
5697                 "log(string,bool,address,string)",
5698                 p0,
5699                 p1,
5700                 p2,
5701                 p3
5702             )
5703         );
5704     }
5705 
5706     function log(
5707         string memory p0,
5708         bool p1,
5709         address p2,
5710         bool p3
5711     ) internal view {
5712         _sendLogPayload(
5713             abi.encodeWithSignature(
5714                 "log(string,bool,address,bool)",
5715                 p0,
5716                 p1,
5717                 p2,
5718                 p3
5719             )
5720         );
5721     }
5722 
5723     function log(
5724         string memory p0,
5725         bool p1,
5726         address p2,
5727         address p3
5728     ) internal view {
5729         _sendLogPayload(
5730             abi.encodeWithSignature(
5731                 "log(string,bool,address,address)",
5732                 p0,
5733                 p1,
5734                 p2,
5735                 p3
5736             )
5737         );
5738     }
5739 
5740     function log(
5741         string memory p0,
5742         address p1,
5743         uint256 p2,
5744         uint256 p3
5745     ) internal view {
5746         _sendLogPayload(
5747             abi.encodeWithSignature(
5748                 "log(string,address,uint,uint)",
5749                 p0,
5750                 p1,
5751                 p2,
5752                 p3
5753             )
5754         );
5755     }
5756 
5757     function log(
5758         string memory p0,
5759         address p1,
5760         uint256 p2,
5761         string memory p3
5762     ) internal view {
5763         _sendLogPayload(
5764             abi.encodeWithSignature(
5765                 "log(string,address,uint,string)",
5766                 p0,
5767                 p1,
5768                 p2,
5769                 p3
5770             )
5771         );
5772     }
5773 
5774     function log(
5775         string memory p0,
5776         address p1,
5777         uint256 p2,
5778         bool p3
5779     ) internal view {
5780         _sendLogPayload(
5781             abi.encodeWithSignature(
5782                 "log(string,address,uint,bool)",
5783                 p0,
5784                 p1,
5785                 p2,
5786                 p3
5787             )
5788         );
5789     }
5790 
5791     function log(
5792         string memory p0,
5793         address p1,
5794         uint256 p2,
5795         address p3
5796     ) internal view {
5797         _sendLogPayload(
5798             abi.encodeWithSignature(
5799                 "log(string,address,uint,address)",
5800                 p0,
5801                 p1,
5802                 p2,
5803                 p3
5804             )
5805         );
5806     }
5807 
5808     function log(
5809         string memory p0,
5810         address p1,
5811         string memory p2,
5812         uint256 p3
5813     ) internal view {
5814         _sendLogPayload(
5815             abi.encodeWithSignature(
5816                 "log(string,address,string,uint)",
5817                 p0,
5818                 p1,
5819                 p2,
5820                 p3
5821             )
5822         );
5823     }
5824 
5825     function log(
5826         string memory p0,
5827         address p1,
5828         string memory p2,
5829         string memory p3
5830     ) internal view {
5831         _sendLogPayload(
5832             abi.encodeWithSignature(
5833                 "log(string,address,string,string)",
5834                 p0,
5835                 p1,
5836                 p2,
5837                 p3
5838             )
5839         );
5840     }
5841 
5842     function log(
5843         string memory p0,
5844         address p1,
5845         string memory p2,
5846         bool p3
5847     ) internal view {
5848         _sendLogPayload(
5849             abi.encodeWithSignature(
5850                 "log(string,address,string,bool)",
5851                 p0,
5852                 p1,
5853                 p2,
5854                 p3
5855             )
5856         );
5857     }
5858 
5859     function log(
5860         string memory p0,
5861         address p1,
5862         string memory p2,
5863         address p3
5864     ) internal view {
5865         _sendLogPayload(
5866             abi.encodeWithSignature(
5867                 "log(string,address,string,address)",
5868                 p0,
5869                 p1,
5870                 p2,
5871                 p3
5872             )
5873         );
5874     }
5875 
5876     function log(
5877         string memory p0,
5878         address p1,
5879         bool p2,
5880         uint256 p3
5881     ) internal view {
5882         _sendLogPayload(
5883             abi.encodeWithSignature(
5884                 "log(string,address,bool,uint)",
5885                 p0,
5886                 p1,
5887                 p2,
5888                 p3
5889             )
5890         );
5891     }
5892 
5893     function log(
5894         string memory p0,
5895         address p1,
5896         bool p2,
5897         string memory p3
5898     ) internal view {
5899         _sendLogPayload(
5900             abi.encodeWithSignature(
5901                 "log(string,address,bool,string)",
5902                 p0,
5903                 p1,
5904                 p2,
5905                 p3
5906             )
5907         );
5908     }
5909 
5910     function log(
5911         string memory p0,
5912         address p1,
5913         bool p2,
5914         bool p3
5915     ) internal view {
5916         _sendLogPayload(
5917             abi.encodeWithSignature(
5918                 "log(string,address,bool,bool)",
5919                 p0,
5920                 p1,
5921                 p2,
5922                 p3
5923             )
5924         );
5925     }
5926 
5927     function log(
5928         string memory p0,
5929         address p1,
5930         bool p2,
5931         address p3
5932     ) internal view {
5933         _sendLogPayload(
5934             abi.encodeWithSignature(
5935                 "log(string,address,bool,address)",
5936                 p0,
5937                 p1,
5938                 p2,
5939                 p3
5940             )
5941         );
5942     }
5943 
5944     function log(
5945         string memory p0,
5946         address p1,
5947         address p2,
5948         uint256 p3
5949     ) internal view {
5950         _sendLogPayload(
5951             abi.encodeWithSignature(
5952                 "log(string,address,address,uint)",
5953                 p0,
5954                 p1,
5955                 p2,
5956                 p3
5957             )
5958         );
5959     }
5960 
5961     function log(
5962         string memory p0,
5963         address p1,
5964         address p2,
5965         string memory p3
5966     ) internal view {
5967         _sendLogPayload(
5968             abi.encodeWithSignature(
5969                 "log(string,address,address,string)",
5970                 p0,
5971                 p1,
5972                 p2,
5973                 p3
5974             )
5975         );
5976     }
5977 
5978     function log(
5979         string memory p0,
5980         address p1,
5981         address p2,
5982         bool p3
5983     ) internal view {
5984         _sendLogPayload(
5985             abi.encodeWithSignature(
5986                 "log(string,address,address,bool)",
5987                 p0,
5988                 p1,
5989                 p2,
5990                 p3
5991             )
5992         );
5993     }
5994 
5995     function log(
5996         string memory p0,
5997         address p1,
5998         address p2,
5999         address p3
6000     ) internal view {
6001         _sendLogPayload(
6002             abi.encodeWithSignature(
6003                 "log(string,address,address,address)",
6004                 p0,
6005                 p1,
6006                 p2,
6007                 p3
6008             )
6009         );
6010     }
6011 
6012     function log(
6013         bool p0,
6014         uint256 p1,
6015         uint256 p2,
6016         uint256 p3
6017     ) internal view {
6018         _sendLogPayload(
6019             abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3)
6020         );
6021     }
6022 
6023     function log(
6024         bool p0,
6025         uint256 p1,
6026         uint256 p2,
6027         string memory p3
6028     ) internal view {
6029         _sendLogPayload(
6030             abi.encodeWithSignature(
6031                 "log(bool,uint,uint,string)",
6032                 p0,
6033                 p1,
6034                 p2,
6035                 p3
6036             )
6037         );
6038     }
6039 
6040     function log(
6041         bool p0,
6042         uint256 p1,
6043         uint256 p2,
6044         bool p3
6045     ) internal view {
6046         _sendLogPayload(
6047             abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3)
6048         );
6049     }
6050 
6051     function log(
6052         bool p0,
6053         uint256 p1,
6054         uint256 p2,
6055         address p3
6056     ) internal view {
6057         _sendLogPayload(
6058             abi.encodeWithSignature(
6059                 "log(bool,uint,uint,address)",
6060                 p0,
6061                 p1,
6062                 p2,
6063                 p3
6064             )
6065         );
6066     }
6067 
6068     function log(
6069         bool p0,
6070         uint256 p1,
6071         string memory p2,
6072         uint256 p3
6073     ) internal view {
6074         _sendLogPayload(
6075             abi.encodeWithSignature(
6076                 "log(bool,uint,string,uint)",
6077                 p0,
6078                 p1,
6079                 p2,
6080                 p3
6081             )
6082         );
6083     }
6084 
6085     function log(
6086         bool p0,
6087         uint256 p1,
6088         string memory p2,
6089         string memory p3
6090     ) internal view {
6091         _sendLogPayload(
6092             abi.encodeWithSignature(
6093                 "log(bool,uint,string,string)",
6094                 p0,
6095                 p1,
6096                 p2,
6097                 p3
6098             )
6099         );
6100     }
6101 
6102     function log(
6103         bool p0,
6104         uint256 p1,
6105         string memory p2,
6106         bool p3
6107     ) internal view {
6108         _sendLogPayload(
6109             abi.encodeWithSignature(
6110                 "log(bool,uint,string,bool)",
6111                 p0,
6112                 p1,
6113                 p2,
6114                 p3
6115             )
6116         );
6117     }
6118 
6119     function log(
6120         bool p0,
6121         uint256 p1,
6122         string memory p2,
6123         address p3
6124     ) internal view {
6125         _sendLogPayload(
6126             abi.encodeWithSignature(
6127                 "log(bool,uint,string,address)",
6128                 p0,
6129                 p1,
6130                 p2,
6131                 p3
6132             )
6133         );
6134     }
6135 
6136     function log(
6137         bool p0,
6138         uint256 p1,
6139         bool p2,
6140         uint256 p3
6141     ) internal view {
6142         _sendLogPayload(
6143             abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3)
6144         );
6145     }
6146 
6147     function log(
6148         bool p0,
6149         uint256 p1,
6150         bool p2,
6151         string memory p3
6152     ) internal view {
6153         _sendLogPayload(
6154             abi.encodeWithSignature(
6155                 "log(bool,uint,bool,string)",
6156                 p0,
6157                 p1,
6158                 p2,
6159                 p3
6160             )
6161         );
6162     }
6163 
6164     function log(
6165         bool p0,
6166         uint256 p1,
6167         bool p2,
6168         bool p3
6169     ) internal view {
6170         _sendLogPayload(
6171             abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3)
6172         );
6173     }
6174 
6175     function log(
6176         bool p0,
6177         uint256 p1,
6178         bool p2,
6179         address p3
6180     ) internal view {
6181         _sendLogPayload(
6182             abi.encodeWithSignature(
6183                 "log(bool,uint,bool,address)",
6184                 p0,
6185                 p1,
6186                 p2,
6187                 p3
6188             )
6189         );
6190     }
6191 
6192     function log(
6193         bool p0,
6194         uint256 p1,
6195         address p2,
6196         uint256 p3
6197     ) internal view {
6198         _sendLogPayload(
6199             abi.encodeWithSignature(
6200                 "log(bool,uint,address,uint)",
6201                 p0,
6202                 p1,
6203                 p2,
6204                 p3
6205             )
6206         );
6207     }
6208 
6209     function log(
6210         bool p0,
6211         uint256 p1,
6212         address p2,
6213         string memory p3
6214     ) internal view {
6215         _sendLogPayload(
6216             abi.encodeWithSignature(
6217                 "log(bool,uint,address,string)",
6218                 p0,
6219                 p1,
6220                 p2,
6221                 p3
6222             )
6223         );
6224     }
6225 
6226     function log(
6227         bool p0,
6228         uint256 p1,
6229         address p2,
6230         bool p3
6231     ) internal view {
6232         _sendLogPayload(
6233             abi.encodeWithSignature(
6234                 "log(bool,uint,address,bool)",
6235                 p0,
6236                 p1,
6237                 p2,
6238                 p3
6239             )
6240         );
6241     }
6242 
6243     function log(
6244         bool p0,
6245         uint256 p1,
6246         address p2,
6247         address p3
6248     ) internal view {
6249         _sendLogPayload(
6250             abi.encodeWithSignature(
6251                 "log(bool,uint,address,address)",
6252                 p0,
6253                 p1,
6254                 p2,
6255                 p3
6256             )
6257         );
6258     }
6259 
6260     function log(
6261         bool p0,
6262         string memory p1,
6263         uint256 p2,
6264         uint256 p3
6265     ) internal view {
6266         _sendLogPayload(
6267             abi.encodeWithSignature(
6268                 "log(bool,string,uint,uint)",
6269                 p0,
6270                 p1,
6271                 p2,
6272                 p3
6273             )
6274         );
6275     }
6276 
6277     function log(
6278         bool p0,
6279         string memory p1,
6280         uint256 p2,
6281         string memory p3
6282     ) internal view {
6283         _sendLogPayload(
6284             abi.encodeWithSignature(
6285                 "log(bool,string,uint,string)",
6286                 p0,
6287                 p1,
6288                 p2,
6289                 p3
6290             )
6291         );
6292     }
6293 
6294     function log(
6295         bool p0,
6296         string memory p1,
6297         uint256 p2,
6298         bool p3
6299     ) internal view {
6300         _sendLogPayload(
6301             abi.encodeWithSignature(
6302                 "log(bool,string,uint,bool)",
6303                 p0,
6304                 p1,
6305                 p2,
6306                 p3
6307             )
6308         );
6309     }
6310 
6311     function log(
6312         bool p0,
6313         string memory p1,
6314         uint256 p2,
6315         address p3
6316     ) internal view {
6317         _sendLogPayload(
6318             abi.encodeWithSignature(
6319                 "log(bool,string,uint,address)",
6320                 p0,
6321                 p1,
6322                 p2,
6323                 p3
6324             )
6325         );
6326     }
6327 
6328     function log(
6329         bool p0,
6330         string memory p1,
6331         string memory p2,
6332         uint256 p3
6333     ) internal view {
6334         _sendLogPayload(
6335             abi.encodeWithSignature(
6336                 "log(bool,string,string,uint)",
6337                 p0,
6338                 p1,
6339                 p2,
6340                 p3
6341             )
6342         );
6343     }
6344 
6345     function log(
6346         bool p0,
6347         string memory p1,
6348         string memory p2,
6349         string memory p3
6350     ) internal view {
6351         _sendLogPayload(
6352             abi.encodeWithSignature(
6353                 "log(bool,string,string,string)",
6354                 p0,
6355                 p1,
6356                 p2,
6357                 p3
6358             )
6359         );
6360     }
6361 
6362     function log(
6363         bool p0,
6364         string memory p1,
6365         string memory p2,
6366         bool p3
6367     ) internal view {
6368         _sendLogPayload(
6369             abi.encodeWithSignature(
6370                 "log(bool,string,string,bool)",
6371                 p0,
6372                 p1,
6373                 p2,
6374                 p3
6375             )
6376         );
6377     }
6378 
6379     function log(
6380         bool p0,
6381         string memory p1,
6382         string memory p2,
6383         address p3
6384     ) internal view {
6385         _sendLogPayload(
6386             abi.encodeWithSignature(
6387                 "log(bool,string,string,address)",
6388                 p0,
6389                 p1,
6390                 p2,
6391                 p3
6392             )
6393         );
6394     }
6395 
6396     function log(
6397         bool p0,
6398         string memory p1,
6399         bool p2,
6400         uint256 p3
6401     ) internal view {
6402         _sendLogPayload(
6403             abi.encodeWithSignature(
6404                 "log(bool,string,bool,uint)",
6405                 p0,
6406                 p1,
6407                 p2,
6408                 p3
6409             )
6410         );
6411     }
6412 
6413     function log(
6414         bool p0,
6415         string memory p1,
6416         bool p2,
6417         string memory p3
6418     ) internal view {
6419         _sendLogPayload(
6420             abi.encodeWithSignature(
6421                 "log(bool,string,bool,string)",
6422                 p0,
6423                 p1,
6424                 p2,
6425                 p3
6426             )
6427         );
6428     }
6429 
6430     function log(
6431         bool p0,
6432         string memory p1,
6433         bool p2,
6434         bool p3
6435     ) internal view {
6436         _sendLogPayload(
6437             abi.encodeWithSignature(
6438                 "log(bool,string,bool,bool)",
6439                 p0,
6440                 p1,
6441                 p2,
6442                 p3
6443             )
6444         );
6445     }
6446 
6447     function log(
6448         bool p0,
6449         string memory p1,
6450         bool p2,
6451         address p3
6452     ) internal view {
6453         _sendLogPayload(
6454             abi.encodeWithSignature(
6455                 "log(bool,string,bool,address)",
6456                 p0,
6457                 p1,
6458                 p2,
6459                 p3
6460             )
6461         );
6462     }
6463 
6464     function log(
6465         bool p0,
6466         string memory p1,
6467         address p2,
6468         uint256 p3
6469     ) internal view {
6470         _sendLogPayload(
6471             abi.encodeWithSignature(
6472                 "log(bool,string,address,uint)",
6473                 p0,
6474                 p1,
6475                 p2,
6476                 p3
6477             )
6478         );
6479     }
6480 
6481     function log(
6482         bool p0,
6483         string memory p1,
6484         address p2,
6485         string memory p3
6486     ) internal view {
6487         _sendLogPayload(
6488             abi.encodeWithSignature(
6489                 "log(bool,string,address,string)",
6490                 p0,
6491                 p1,
6492                 p2,
6493                 p3
6494             )
6495         );
6496     }
6497 
6498     function log(
6499         bool p0,
6500         string memory p1,
6501         address p2,
6502         bool p3
6503     ) internal view {
6504         _sendLogPayload(
6505             abi.encodeWithSignature(
6506                 "log(bool,string,address,bool)",
6507                 p0,
6508                 p1,
6509                 p2,
6510                 p3
6511             )
6512         );
6513     }
6514 
6515     function log(
6516         bool p0,
6517         string memory p1,
6518         address p2,
6519         address p3
6520     ) internal view {
6521         _sendLogPayload(
6522             abi.encodeWithSignature(
6523                 "log(bool,string,address,address)",
6524                 p0,
6525                 p1,
6526                 p2,
6527                 p3
6528             )
6529         );
6530     }
6531 
6532     function log(
6533         bool p0,
6534         bool p1,
6535         uint256 p2,
6536         uint256 p3
6537     ) internal view {
6538         _sendLogPayload(
6539             abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3)
6540         );
6541     }
6542 
6543     function log(
6544         bool p0,
6545         bool p1,
6546         uint256 p2,
6547         string memory p3
6548     ) internal view {
6549         _sendLogPayload(
6550             abi.encodeWithSignature(
6551                 "log(bool,bool,uint,string)",
6552                 p0,
6553                 p1,
6554                 p2,
6555                 p3
6556             )
6557         );
6558     }
6559 
6560     function log(
6561         bool p0,
6562         bool p1,
6563         uint256 p2,
6564         bool p3
6565     ) internal view {
6566         _sendLogPayload(
6567             abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3)
6568         );
6569     }
6570 
6571     function log(
6572         bool p0,
6573         bool p1,
6574         uint256 p2,
6575         address p3
6576     ) internal view {
6577         _sendLogPayload(
6578             abi.encodeWithSignature(
6579                 "log(bool,bool,uint,address)",
6580                 p0,
6581                 p1,
6582                 p2,
6583                 p3
6584             )
6585         );
6586     }
6587 
6588     function log(
6589         bool p0,
6590         bool p1,
6591         string memory p2,
6592         uint256 p3
6593     ) internal view {
6594         _sendLogPayload(
6595             abi.encodeWithSignature(
6596                 "log(bool,bool,string,uint)",
6597                 p0,
6598                 p1,
6599                 p2,
6600                 p3
6601             )
6602         );
6603     }
6604 
6605     function log(
6606         bool p0,
6607         bool p1,
6608         string memory p2,
6609         string memory p3
6610     ) internal view {
6611         _sendLogPayload(
6612             abi.encodeWithSignature(
6613                 "log(bool,bool,string,string)",
6614                 p0,
6615                 p1,
6616                 p2,
6617                 p3
6618             )
6619         );
6620     }
6621 
6622     function log(
6623         bool p0,
6624         bool p1,
6625         string memory p2,
6626         bool p3
6627     ) internal view {
6628         _sendLogPayload(
6629             abi.encodeWithSignature(
6630                 "log(bool,bool,string,bool)",
6631                 p0,
6632                 p1,
6633                 p2,
6634                 p3
6635             )
6636         );
6637     }
6638 
6639     function log(
6640         bool p0,
6641         bool p1,
6642         string memory p2,
6643         address p3
6644     ) internal view {
6645         _sendLogPayload(
6646             abi.encodeWithSignature(
6647                 "log(bool,bool,string,address)",
6648                 p0,
6649                 p1,
6650                 p2,
6651                 p3
6652             )
6653         );
6654     }
6655 
6656     function log(
6657         bool p0,
6658         bool p1,
6659         bool p2,
6660         uint256 p3
6661     ) internal view {
6662         _sendLogPayload(
6663             abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3)
6664         );
6665     }
6666 
6667     function log(
6668         bool p0,
6669         bool p1,
6670         bool p2,
6671         string memory p3
6672     ) internal view {
6673         _sendLogPayload(
6674             abi.encodeWithSignature(
6675                 "log(bool,bool,bool,string)",
6676                 p0,
6677                 p1,
6678                 p2,
6679                 p3
6680             )
6681         );
6682     }
6683 
6684     function log(
6685         bool p0,
6686         bool p1,
6687         bool p2,
6688         bool p3
6689     ) internal view {
6690         _sendLogPayload(
6691             abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3)
6692         );
6693     }
6694 
6695     function log(
6696         bool p0,
6697         bool p1,
6698         bool p2,
6699         address p3
6700     ) internal view {
6701         _sendLogPayload(
6702             abi.encodeWithSignature(
6703                 "log(bool,bool,bool,address)",
6704                 p0,
6705                 p1,
6706                 p2,
6707                 p3
6708             )
6709         );
6710     }
6711 
6712     function log(
6713         bool p0,
6714         bool p1,
6715         address p2,
6716         uint256 p3
6717     ) internal view {
6718         _sendLogPayload(
6719             abi.encodeWithSignature(
6720                 "log(bool,bool,address,uint)",
6721                 p0,
6722                 p1,
6723                 p2,
6724                 p3
6725             )
6726         );
6727     }
6728 
6729     function log(
6730         bool p0,
6731         bool p1,
6732         address p2,
6733         string memory p3
6734     ) internal view {
6735         _sendLogPayload(
6736             abi.encodeWithSignature(
6737                 "log(bool,bool,address,string)",
6738                 p0,
6739                 p1,
6740                 p2,
6741                 p3
6742             )
6743         );
6744     }
6745 
6746     function log(
6747         bool p0,
6748         bool p1,
6749         address p2,
6750         bool p3
6751     ) internal view {
6752         _sendLogPayload(
6753             abi.encodeWithSignature(
6754                 "log(bool,bool,address,bool)",
6755                 p0,
6756                 p1,
6757                 p2,
6758                 p3
6759             )
6760         );
6761     }
6762 
6763     function log(
6764         bool p0,
6765         bool p1,
6766         address p2,
6767         address p3
6768     ) internal view {
6769         _sendLogPayload(
6770             abi.encodeWithSignature(
6771                 "log(bool,bool,address,address)",
6772                 p0,
6773                 p1,
6774                 p2,
6775                 p3
6776             )
6777         );
6778     }
6779 
6780     function log(
6781         bool p0,
6782         address p1,
6783         uint256 p2,
6784         uint256 p3
6785     ) internal view {
6786         _sendLogPayload(
6787             abi.encodeWithSignature(
6788                 "log(bool,address,uint,uint)",
6789                 p0,
6790                 p1,
6791                 p2,
6792                 p3
6793             )
6794         );
6795     }
6796 
6797     function log(
6798         bool p0,
6799         address p1,
6800         uint256 p2,
6801         string memory p3
6802     ) internal view {
6803         _sendLogPayload(
6804             abi.encodeWithSignature(
6805                 "log(bool,address,uint,string)",
6806                 p0,
6807                 p1,
6808                 p2,
6809                 p3
6810             )
6811         );
6812     }
6813 
6814     function log(
6815         bool p0,
6816         address p1,
6817         uint256 p2,
6818         bool p3
6819     ) internal view {
6820         _sendLogPayload(
6821             abi.encodeWithSignature(
6822                 "log(bool,address,uint,bool)",
6823                 p0,
6824                 p1,
6825                 p2,
6826                 p3
6827             )
6828         );
6829     }
6830 
6831     function log(
6832         bool p0,
6833         address p1,
6834         uint256 p2,
6835         address p3
6836     ) internal view {
6837         _sendLogPayload(
6838             abi.encodeWithSignature(
6839                 "log(bool,address,uint,address)",
6840                 p0,
6841                 p1,
6842                 p2,
6843                 p3
6844             )
6845         );
6846     }
6847 
6848     function log(
6849         bool p0,
6850         address p1,
6851         string memory p2,
6852         uint256 p3
6853     ) internal view {
6854         _sendLogPayload(
6855             abi.encodeWithSignature(
6856                 "log(bool,address,string,uint)",
6857                 p0,
6858                 p1,
6859                 p2,
6860                 p3
6861             )
6862         );
6863     }
6864 
6865     function log(
6866         bool p0,
6867         address p1,
6868         string memory p2,
6869         string memory p3
6870     ) internal view {
6871         _sendLogPayload(
6872             abi.encodeWithSignature(
6873                 "log(bool,address,string,string)",
6874                 p0,
6875                 p1,
6876                 p2,
6877                 p3
6878             )
6879         );
6880     }
6881 
6882     function log(
6883         bool p0,
6884         address p1,
6885         string memory p2,
6886         bool p3
6887     ) internal view {
6888         _sendLogPayload(
6889             abi.encodeWithSignature(
6890                 "log(bool,address,string,bool)",
6891                 p0,
6892                 p1,
6893                 p2,
6894                 p3
6895             )
6896         );
6897     }
6898 
6899     function log(
6900         bool p0,
6901         address p1,
6902         string memory p2,
6903         address p3
6904     ) internal view {
6905         _sendLogPayload(
6906             abi.encodeWithSignature(
6907                 "log(bool,address,string,address)",
6908                 p0,
6909                 p1,
6910                 p2,
6911                 p3
6912             )
6913         );
6914     }
6915 
6916     function log(
6917         bool p0,
6918         address p1,
6919         bool p2,
6920         uint256 p3
6921     ) internal view {
6922         _sendLogPayload(
6923             abi.encodeWithSignature(
6924                 "log(bool,address,bool,uint)",
6925                 p0,
6926                 p1,
6927                 p2,
6928                 p3
6929             )
6930         );
6931     }
6932 
6933     function log(
6934         bool p0,
6935         address p1,
6936         bool p2,
6937         string memory p3
6938     ) internal view {
6939         _sendLogPayload(
6940             abi.encodeWithSignature(
6941                 "log(bool,address,bool,string)",
6942                 p0,
6943                 p1,
6944                 p2,
6945                 p3
6946             )
6947         );
6948     }
6949 
6950     function log(
6951         bool p0,
6952         address p1,
6953         bool p2,
6954         bool p3
6955     ) internal view {
6956         _sendLogPayload(
6957             abi.encodeWithSignature(
6958                 "log(bool,address,bool,bool)",
6959                 p0,
6960                 p1,
6961                 p2,
6962                 p3
6963             )
6964         );
6965     }
6966 
6967     function log(
6968         bool p0,
6969         address p1,
6970         bool p2,
6971         address p3
6972     ) internal view {
6973         _sendLogPayload(
6974             abi.encodeWithSignature(
6975                 "log(bool,address,bool,address)",
6976                 p0,
6977                 p1,
6978                 p2,
6979                 p3
6980             )
6981         );
6982     }
6983 
6984     function log(
6985         bool p0,
6986         address p1,
6987         address p2,
6988         uint256 p3
6989     ) internal view {
6990         _sendLogPayload(
6991             abi.encodeWithSignature(
6992                 "log(bool,address,address,uint)",
6993                 p0,
6994                 p1,
6995                 p2,
6996                 p3
6997             )
6998         );
6999     }
7000 
7001     function log(
7002         bool p0,
7003         address p1,
7004         address p2,
7005         string memory p3
7006     ) internal view {
7007         _sendLogPayload(
7008             abi.encodeWithSignature(
7009                 "log(bool,address,address,string)",
7010                 p0,
7011                 p1,
7012                 p2,
7013                 p3
7014             )
7015         );
7016     }
7017 
7018     function log(
7019         bool p0,
7020         address p1,
7021         address p2,
7022         bool p3
7023     ) internal view {
7024         _sendLogPayload(
7025             abi.encodeWithSignature(
7026                 "log(bool,address,address,bool)",
7027                 p0,
7028                 p1,
7029                 p2,
7030                 p3
7031             )
7032         );
7033     }
7034 
7035     function log(
7036         bool p0,
7037         address p1,
7038         address p2,
7039         address p3
7040     ) internal view {
7041         _sendLogPayload(
7042             abi.encodeWithSignature(
7043                 "log(bool,address,address,address)",
7044                 p0,
7045                 p1,
7046                 p2,
7047                 p3
7048             )
7049         );
7050     }
7051 
7052     function log(
7053         address p0,
7054         uint256 p1,
7055         uint256 p2,
7056         uint256 p3
7057     ) internal view {
7058         _sendLogPayload(
7059             abi.encodeWithSignature(
7060                 "log(address,uint,uint,uint)",
7061                 p0,
7062                 p1,
7063                 p2,
7064                 p3
7065             )
7066         );
7067     }
7068 
7069     function log(
7070         address p0,
7071         uint256 p1,
7072         uint256 p2,
7073         string memory p3
7074     ) internal view {
7075         _sendLogPayload(
7076             abi.encodeWithSignature(
7077                 "log(address,uint,uint,string)",
7078                 p0,
7079                 p1,
7080                 p2,
7081                 p3
7082             )
7083         );
7084     }
7085 
7086     function log(
7087         address p0,
7088         uint256 p1,
7089         uint256 p2,
7090         bool p3
7091     ) internal view {
7092         _sendLogPayload(
7093             abi.encodeWithSignature(
7094                 "log(address,uint,uint,bool)",
7095                 p0,
7096                 p1,
7097                 p2,
7098                 p3
7099             )
7100         );
7101     }
7102 
7103     function log(
7104         address p0,
7105         uint256 p1,
7106         uint256 p2,
7107         address p3
7108     ) internal view {
7109         _sendLogPayload(
7110             abi.encodeWithSignature(
7111                 "log(address,uint,uint,address)",
7112                 p0,
7113                 p1,
7114                 p2,
7115                 p3
7116             )
7117         );
7118     }
7119 
7120     function log(
7121         address p0,
7122         uint256 p1,
7123         string memory p2,
7124         uint256 p3
7125     ) internal view {
7126         _sendLogPayload(
7127             abi.encodeWithSignature(
7128                 "log(address,uint,string,uint)",
7129                 p0,
7130                 p1,
7131                 p2,
7132                 p3
7133             )
7134         );
7135     }
7136 
7137     function log(
7138         address p0,
7139         uint256 p1,
7140         string memory p2,
7141         string memory p3
7142     ) internal view {
7143         _sendLogPayload(
7144             abi.encodeWithSignature(
7145                 "log(address,uint,string,string)",
7146                 p0,
7147                 p1,
7148                 p2,
7149                 p3
7150             )
7151         );
7152     }
7153 
7154     function log(
7155         address p0,
7156         uint256 p1,
7157         string memory p2,
7158         bool p3
7159     ) internal view {
7160         _sendLogPayload(
7161             abi.encodeWithSignature(
7162                 "log(address,uint,string,bool)",
7163                 p0,
7164                 p1,
7165                 p2,
7166                 p3
7167             )
7168         );
7169     }
7170 
7171     function log(
7172         address p0,
7173         uint256 p1,
7174         string memory p2,
7175         address p3
7176     ) internal view {
7177         _sendLogPayload(
7178             abi.encodeWithSignature(
7179                 "log(address,uint,string,address)",
7180                 p0,
7181                 p1,
7182                 p2,
7183                 p3
7184             )
7185         );
7186     }
7187 
7188     function log(
7189         address p0,
7190         uint256 p1,
7191         bool p2,
7192         uint256 p3
7193     ) internal view {
7194         _sendLogPayload(
7195             abi.encodeWithSignature(
7196                 "log(address,uint,bool,uint)",
7197                 p0,
7198                 p1,
7199                 p2,
7200                 p3
7201             )
7202         );
7203     }
7204 
7205     function log(
7206         address p0,
7207         uint256 p1,
7208         bool p2,
7209         string memory p3
7210     ) internal view {
7211         _sendLogPayload(
7212             abi.encodeWithSignature(
7213                 "log(address,uint,bool,string)",
7214                 p0,
7215                 p1,
7216                 p2,
7217                 p3
7218             )
7219         );
7220     }
7221 
7222     function log(
7223         address p0,
7224         uint256 p1,
7225         bool p2,
7226         bool p3
7227     ) internal view {
7228         _sendLogPayload(
7229             abi.encodeWithSignature(
7230                 "log(address,uint,bool,bool)",
7231                 p0,
7232                 p1,
7233                 p2,
7234                 p3
7235             )
7236         );
7237     }
7238 
7239     function log(
7240         address p0,
7241         uint256 p1,
7242         bool p2,
7243         address p3
7244     ) internal view {
7245         _sendLogPayload(
7246             abi.encodeWithSignature(
7247                 "log(address,uint,bool,address)",
7248                 p0,
7249                 p1,
7250                 p2,
7251                 p3
7252             )
7253         );
7254     }
7255 
7256     function log(
7257         address p0,
7258         uint256 p1,
7259         address p2,
7260         uint256 p3
7261     ) internal view {
7262         _sendLogPayload(
7263             abi.encodeWithSignature(
7264                 "log(address,uint,address,uint)",
7265                 p0,
7266                 p1,
7267                 p2,
7268                 p3
7269             )
7270         );
7271     }
7272 
7273     function log(
7274         address p0,
7275         uint256 p1,
7276         address p2,
7277         string memory p3
7278     ) internal view {
7279         _sendLogPayload(
7280             abi.encodeWithSignature(
7281                 "log(address,uint,address,string)",
7282                 p0,
7283                 p1,
7284                 p2,
7285                 p3
7286             )
7287         );
7288     }
7289 
7290     function log(
7291         address p0,
7292         uint256 p1,
7293         address p2,
7294         bool p3
7295     ) internal view {
7296         _sendLogPayload(
7297             abi.encodeWithSignature(
7298                 "log(address,uint,address,bool)",
7299                 p0,
7300                 p1,
7301                 p2,
7302                 p3
7303             )
7304         );
7305     }
7306 
7307     function log(
7308         address p0,
7309         uint256 p1,
7310         address p2,
7311         address p3
7312     ) internal view {
7313         _sendLogPayload(
7314             abi.encodeWithSignature(
7315                 "log(address,uint,address,address)",
7316                 p0,
7317                 p1,
7318                 p2,
7319                 p3
7320             )
7321         );
7322     }
7323 
7324     function log(
7325         address p0,
7326         string memory p1,
7327         uint256 p2,
7328         uint256 p3
7329     ) internal view {
7330         _sendLogPayload(
7331             abi.encodeWithSignature(
7332                 "log(address,string,uint,uint)",
7333                 p0,
7334                 p1,
7335                 p2,
7336                 p3
7337             )
7338         );
7339     }
7340 
7341     function log(
7342         address p0,
7343         string memory p1,
7344         uint256 p2,
7345         string memory p3
7346     ) internal view {
7347         _sendLogPayload(
7348             abi.encodeWithSignature(
7349                 "log(address,string,uint,string)",
7350                 p0,
7351                 p1,
7352                 p2,
7353                 p3
7354             )
7355         );
7356     }
7357 
7358     function log(
7359         address p0,
7360         string memory p1,
7361         uint256 p2,
7362         bool p3
7363     ) internal view {
7364         _sendLogPayload(
7365             abi.encodeWithSignature(
7366                 "log(address,string,uint,bool)",
7367                 p0,
7368                 p1,
7369                 p2,
7370                 p3
7371             )
7372         );
7373     }
7374 
7375     function log(
7376         address p0,
7377         string memory p1,
7378         uint256 p2,
7379         address p3
7380     ) internal view {
7381         _sendLogPayload(
7382             abi.encodeWithSignature(
7383                 "log(address,string,uint,address)",
7384                 p0,
7385                 p1,
7386                 p2,
7387                 p3
7388             )
7389         );
7390     }
7391 
7392     function log(
7393         address p0,
7394         string memory p1,
7395         string memory p2,
7396         uint256 p3
7397     ) internal view {
7398         _sendLogPayload(
7399             abi.encodeWithSignature(
7400                 "log(address,string,string,uint)",
7401                 p0,
7402                 p1,
7403                 p2,
7404                 p3
7405             )
7406         );
7407     }
7408 
7409     function log(
7410         address p0,
7411         string memory p1,
7412         string memory p2,
7413         string memory p3
7414     ) internal view {
7415         _sendLogPayload(
7416             abi.encodeWithSignature(
7417                 "log(address,string,string,string)",
7418                 p0,
7419                 p1,
7420                 p2,
7421                 p3
7422             )
7423         );
7424     }
7425 
7426     function log(
7427         address p0,
7428         string memory p1,
7429         string memory p2,
7430         bool p3
7431     ) internal view {
7432         _sendLogPayload(
7433             abi.encodeWithSignature(
7434                 "log(address,string,string,bool)",
7435                 p0,
7436                 p1,
7437                 p2,
7438                 p3
7439             )
7440         );
7441     }
7442 
7443     function log(
7444         address p0,
7445         string memory p1,
7446         string memory p2,
7447         address p3
7448     ) internal view {
7449         _sendLogPayload(
7450             abi.encodeWithSignature(
7451                 "log(address,string,string,address)",
7452                 p0,
7453                 p1,
7454                 p2,
7455                 p3
7456             )
7457         );
7458     }
7459 
7460     function log(
7461         address p0,
7462         string memory p1,
7463         bool p2,
7464         uint256 p3
7465     ) internal view {
7466         _sendLogPayload(
7467             abi.encodeWithSignature(
7468                 "log(address,string,bool,uint)",
7469                 p0,
7470                 p1,
7471                 p2,
7472                 p3
7473             )
7474         );
7475     }
7476 
7477     function log(
7478         address p0,
7479         string memory p1,
7480         bool p2,
7481         string memory p3
7482     ) internal view {
7483         _sendLogPayload(
7484             abi.encodeWithSignature(
7485                 "log(address,string,bool,string)",
7486                 p0,
7487                 p1,
7488                 p2,
7489                 p3
7490             )
7491         );
7492     }
7493 
7494     function log(
7495         address p0,
7496         string memory p1,
7497         bool p2,
7498         bool p3
7499     ) internal view {
7500         _sendLogPayload(
7501             abi.encodeWithSignature(
7502                 "log(address,string,bool,bool)",
7503                 p0,
7504                 p1,
7505                 p2,
7506                 p3
7507             )
7508         );
7509     }
7510 
7511     function log(
7512         address p0,
7513         string memory p1,
7514         bool p2,
7515         address p3
7516     ) internal view {
7517         _sendLogPayload(
7518             abi.encodeWithSignature(
7519                 "log(address,string,bool,address)",
7520                 p0,
7521                 p1,
7522                 p2,
7523                 p3
7524             )
7525         );
7526     }
7527 
7528     function log(
7529         address p0,
7530         string memory p1,
7531         address p2,
7532         uint256 p3
7533     ) internal view {
7534         _sendLogPayload(
7535             abi.encodeWithSignature(
7536                 "log(address,string,address,uint)",
7537                 p0,
7538                 p1,
7539                 p2,
7540                 p3
7541             )
7542         );
7543     }
7544 
7545     function log(
7546         address p0,
7547         string memory p1,
7548         address p2,
7549         string memory p3
7550     ) internal view {
7551         _sendLogPayload(
7552             abi.encodeWithSignature(
7553                 "log(address,string,address,string)",
7554                 p0,
7555                 p1,
7556                 p2,
7557                 p3
7558             )
7559         );
7560     }
7561 
7562     function log(
7563         address p0,
7564         string memory p1,
7565         address p2,
7566         bool p3
7567     ) internal view {
7568         _sendLogPayload(
7569             abi.encodeWithSignature(
7570                 "log(address,string,address,bool)",
7571                 p0,
7572                 p1,
7573                 p2,
7574                 p3
7575             )
7576         );
7577     }
7578 
7579     function log(
7580         address p0,
7581         string memory p1,
7582         address p2,
7583         address p3
7584     ) internal view {
7585         _sendLogPayload(
7586             abi.encodeWithSignature(
7587                 "log(address,string,address,address)",
7588                 p0,
7589                 p1,
7590                 p2,
7591                 p3
7592             )
7593         );
7594     }
7595 
7596     function log(
7597         address p0,
7598         bool p1,
7599         uint256 p2,
7600         uint256 p3
7601     ) internal view {
7602         _sendLogPayload(
7603             abi.encodeWithSignature(
7604                 "log(address,bool,uint,uint)",
7605                 p0,
7606                 p1,
7607                 p2,
7608                 p3
7609             )
7610         );
7611     }
7612 
7613     function log(
7614         address p0,
7615         bool p1,
7616         uint256 p2,
7617         string memory p3
7618     ) internal view {
7619         _sendLogPayload(
7620             abi.encodeWithSignature(
7621                 "log(address,bool,uint,string)",
7622                 p0,
7623                 p1,
7624                 p2,
7625                 p3
7626             )
7627         );
7628     }
7629 
7630     function log(
7631         address p0,
7632         bool p1,
7633         uint256 p2,
7634         bool p3
7635     ) internal view {
7636         _sendLogPayload(
7637             abi.encodeWithSignature(
7638                 "log(address,bool,uint,bool)",
7639                 p0,
7640                 p1,
7641                 p2,
7642                 p3
7643             )
7644         );
7645     }
7646 
7647     function log(
7648         address p0,
7649         bool p1,
7650         uint256 p2,
7651         address p3
7652     ) internal view {
7653         _sendLogPayload(
7654             abi.encodeWithSignature(
7655                 "log(address,bool,uint,address)",
7656                 p0,
7657                 p1,
7658                 p2,
7659                 p3
7660             )
7661         );
7662     }
7663 
7664     function log(
7665         address p0,
7666         bool p1,
7667         string memory p2,
7668         uint256 p3
7669     ) internal view {
7670         _sendLogPayload(
7671             abi.encodeWithSignature(
7672                 "log(address,bool,string,uint)",
7673                 p0,
7674                 p1,
7675                 p2,
7676                 p3
7677             )
7678         );
7679     }
7680 
7681     function log(
7682         address p0,
7683         bool p1,
7684         string memory p2,
7685         string memory p3
7686     ) internal view {
7687         _sendLogPayload(
7688             abi.encodeWithSignature(
7689                 "log(address,bool,string,string)",
7690                 p0,
7691                 p1,
7692                 p2,
7693                 p3
7694             )
7695         );
7696     }
7697 
7698     function log(
7699         address p0,
7700         bool p1,
7701         string memory p2,
7702         bool p3
7703     ) internal view {
7704         _sendLogPayload(
7705             abi.encodeWithSignature(
7706                 "log(address,bool,string,bool)",
7707                 p0,
7708                 p1,
7709                 p2,
7710                 p3
7711             )
7712         );
7713     }
7714 
7715     function log(
7716         address p0,
7717         bool p1,
7718         string memory p2,
7719         address p3
7720     ) internal view {
7721         _sendLogPayload(
7722             abi.encodeWithSignature(
7723                 "log(address,bool,string,address)",
7724                 p0,
7725                 p1,
7726                 p2,
7727                 p3
7728             )
7729         );
7730     }
7731 
7732     function log(
7733         address p0,
7734         bool p1,
7735         bool p2,
7736         uint256 p3
7737     ) internal view {
7738         _sendLogPayload(
7739             abi.encodeWithSignature(
7740                 "log(address,bool,bool,uint)",
7741                 p0,
7742                 p1,
7743                 p2,
7744                 p3
7745             )
7746         );
7747     }
7748 
7749     function log(
7750         address p0,
7751         bool p1,
7752         bool p2,
7753         string memory p3
7754     ) internal view {
7755         _sendLogPayload(
7756             abi.encodeWithSignature(
7757                 "log(address,bool,bool,string)",
7758                 p0,
7759                 p1,
7760                 p2,
7761                 p3
7762             )
7763         );
7764     }
7765 
7766     function log(
7767         address p0,
7768         bool p1,
7769         bool p2,
7770         bool p3
7771     ) internal view {
7772         _sendLogPayload(
7773             abi.encodeWithSignature(
7774                 "log(address,bool,bool,bool)",
7775                 p0,
7776                 p1,
7777                 p2,
7778                 p3
7779             )
7780         );
7781     }
7782 
7783     function log(
7784         address p0,
7785         bool p1,
7786         bool p2,
7787         address p3
7788     ) internal view {
7789         _sendLogPayload(
7790             abi.encodeWithSignature(
7791                 "log(address,bool,bool,address)",
7792                 p0,
7793                 p1,
7794                 p2,
7795                 p3
7796             )
7797         );
7798     }
7799 
7800     function log(
7801         address p0,
7802         bool p1,
7803         address p2,
7804         uint256 p3
7805     ) internal view {
7806         _sendLogPayload(
7807             abi.encodeWithSignature(
7808                 "log(address,bool,address,uint)",
7809                 p0,
7810                 p1,
7811                 p2,
7812                 p3
7813             )
7814         );
7815     }
7816 
7817     function log(
7818         address p0,
7819         bool p1,
7820         address p2,
7821         string memory p3
7822     ) internal view {
7823         _sendLogPayload(
7824             abi.encodeWithSignature(
7825                 "log(address,bool,address,string)",
7826                 p0,
7827                 p1,
7828                 p2,
7829                 p3
7830             )
7831         );
7832     }
7833 
7834     function log(
7835         address p0,
7836         bool p1,
7837         address p2,
7838         bool p3
7839     ) internal view {
7840         _sendLogPayload(
7841             abi.encodeWithSignature(
7842                 "log(address,bool,address,bool)",
7843                 p0,
7844                 p1,
7845                 p2,
7846                 p3
7847             )
7848         );
7849     }
7850 
7851     function log(
7852         address p0,
7853         bool p1,
7854         address p2,
7855         address p3
7856     ) internal view {
7857         _sendLogPayload(
7858             abi.encodeWithSignature(
7859                 "log(address,bool,address,address)",
7860                 p0,
7861                 p1,
7862                 p2,
7863                 p3
7864             )
7865         );
7866     }
7867 
7868     function log(
7869         address p0,
7870         address p1,
7871         uint256 p2,
7872         uint256 p3
7873     ) internal view {
7874         _sendLogPayload(
7875             abi.encodeWithSignature(
7876                 "log(address,address,uint,uint)",
7877                 p0,
7878                 p1,
7879                 p2,
7880                 p3
7881             )
7882         );
7883     }
7884 
7885     function log(
7886         address p0,
7887         address p1,
7888         uint256 p2,
7889         string memory p3
7890     ) internal view {
7891         _sendLogPayload(
7892             abi.encodeWithSignature(
7893                 "log(address,address,uint,string)",
7894                 p0,
7895                 p1,
7896                 p2,
7897                 p3
7898             )
7899         );
7900     }
7901 
7902     function log(
7903         address p0,
7904         address p1,
7905         uint256 p2,
7906         bool p3
7907     ) internal view {
7908         _sendLogPayload(
7909             abi.encodeWithSignature(
7910                 "log(address,address,uint,bool)",
7911                 p0,
7912                 p1,
7913                 p2,
7914                 p3
7915             )
7916         );
7917     }
7918 
7919     function log(
7920         address p0,
7921         address p1,
7922         uint256 p2,
7923         address p3
7924     ) internal view {
7925         _sendLogPayload(
7926             abi.encodeWithSignature(
7927                 "log(address,address,uint,address)",
7928                 p0,
7929                 p1,
7930                 p2,
7931                 p3
7932             )
7933         );
7934     }
7935 
7936     function log(
7937         address p0,
7938         address p1,
7939         string memory p2,
7940         uint256 p3
7941     ) internal view {
7942         _sendLogPayload(
7943             abi.encodeWithSignature(
7944                 "log(address,address,string,uint)",
7945                 p0,
7946                 p1,
7947                 p2,
7948                 p3
7949             )
7950         );
7951     }
7952 
7953     function log(
7954         address p0,
7955         address p1,
7956         string memory p2,
7957         string memory p3
7958     ) internal view {
7959         _sendLogPayload(
7960             abi.encodeWithSignature(
7961                 "log(address,address,string,string)",
7962                 p0,
7963                 p1,
7964                 p2,
7965                 p3
7966             )
7967         );
7968     }
7969 
7970     function log(
7971         address p0,
7972         address p1,
7973         string memory p2,
7974         bool p3
7975     ) internal view {
7976         _sendLogPayload(
7977             abi.encodeWithSignature(
7978                 "log(address,address,string,bool)",
7979                 p0,
7980                 p1,
7981                 p2,
7982                 p3
7983             )
7984         );
7985     }
7986 
7987     function log(
7988         address p0,
7989         address p1,
7990         string memory p2,
7991         address p3
7992     ) internal view {
7993         _sendLogPayload(
7994             abi.encodeWithSignature(
7995                 "log(address,address,string,address)",
7996                 p0,
7997                 p1,
7998                 p2,
7999                 p3
8000             )
8001         );
8002     }
8003 
8004     function log(
8005         address p0,
8006         address p1,
8007         bool p2,
8008         uint256 p3
8009     ) internal view {
8010         _sendLogPayload(
8011             abi.encodeWithSignature(
8012                 "log(address,address,bool,uint)",
8013                 p0,
8014                 p1,
8015                 p2,
8016                 p3
8017             )
8018         );
8019     }
8020 
8021     function log(
8022         address p0,
8023         address p1,
8024         bool p2,
8025         string memory p3
8026     ) internal view {
8027         _sendLogPayload(
8028             abi.encodeWithSignature(
8029                 "log(address,address,bool,string)",
8030                 p0,
8031                 p1,
8032                 p2,
8033                 p3
8034             )
8035         );
8036     }
8037 
8038     function log(
8039         address p0,
8040         address p1,
8041         bool p2,
8042         bool p3
8043     ) internal view {
8044         _sendLogPayload(
8045             abi.encodeWithSignature(
8046                 "log(address,address,bool,bool)",
8047                 p0,
8048                 p1,
8049                 p2,
8050                 p3
8051             )
8052         );
8053     }
8054 
8055     function log(
8056         address p0,
8057         address p1,
8058         bool p2,
8059         address p3
8060     ) internal view {
8061         _sendLogPayload(
8062             abi.encodeWithSignature(
8063                 "log(address,address,bool,address)",
8064                 p0,
8065                 p1,
8066                 p2,
8067                 p3
8068             )
8069         );
8070     }
8071 
8072     function log(
8073         address p0,
8074         address p1,
8075         address p2,
8076         uint256 p3
8077     ) internal view {
8078         _sendLogPayload(
8079             abi.encodeWithSignature(
8080                 "log(address,address,address,uint)",
8081                 p0,
8082                 p1,
8083                 p2,
8084                 p3
8085             )
8086         );
8087     }
8088 
8089     function log(
8090         address p0,
8091         address p1,
8092         address p2,
8093         string memory p3
8094     ) internal view {
8095         _sendLogPayload(
8096             abi.encodeWithSignature(
8097                 "log(address,address,address,string)",
8098                 p0,
8099                 p1,
8100                 p2,
8101                 p3
8102             )
8103         );
8104     }
8105 
8106     function log(
8107         address p0,
8108         address p1,
8109         address p2,
8110         bool p3
8111     ) internal view {
8112         _sendLogPayload(
8113             abi.encodeWithSignature(
8114                 "log(address,address,address,bool)",
8115                 p0,
8116                 p1,
8117                 p2,
8118                 p3
8119             )
8120         );
8121     }
8122 
8123     function log(
8124         address p0,
8125         address p1,
8126         address p2,
8127         address p3
8128     ) internal view {
8129         _sendLogPayload(
8130             abi.encodeWithSignature(
8131                 "log(address,address,address,address)",
8132                 p0,
8133                 p1,
8134                 p2,
8135                 p3
8136             )
8137         );
8138     }
8139 }
8140 
8141 contract Lottery is Ownable, VRFConsumerBaseV2, IERC721Receiver, Multisig {
8142     using SortitionSumTreeFactory for SortitionSumTreeFactory.SortitionSumTrees;
8143     using SafeMath for uint256;
8144     using SafeERC20 for IERC20;
8145     using EnumerableSet for EnumerableSet.AddressSet;
8146     mapping(address => bool) internal _whitelistedServices;
8147 
8148     IERC721 public nft721;
8149     uint256 public nftId;
8150     IERC20 public customToken;
8151     IERC20 public ruffle;
8152 
8153     address payable[] public selectedWinners;
8154     address[] public lastWinners;
8155     uint256[] public winningNumbers;
8156     uint256 public jackpot;
8157     uint256 public lastJackpot;
8158     uint256 public totalEthPaid;
8159     uint256 public totalWinnersPaid;
8160     uint256[] public percentageOfJackpot = [75, 18, 7];
8161     mapping(address => uint256) public amountWonByUser;
8162 
8163     enum Status {
8164         NotStarted,
8165         Started,
8166         WinnersSelected,
8167         WinnerPaid
8168     }
8169     Status public status;
8170 
8171     enum LotteryType {
8172         NotStarted,
8173         Ethereum,
8174         Token,
8175         NFT721
8176     }
8177     LotteryType public lotteryType;
8178 
8179     //Staking
8180     uint256 public totalStaked;
8181     mapping(address => uint256) public balanceOf;
8182     bool public stakingEnabled;
8183 
8184     //Variables used for the sortitionsumtrees
8185     bytes32 private constant TREE_KEY = keccak256("Lotto");
8186     uint256 private constant MAX_TREE_LEAVES = 5;
8187 
8188     // Ticket-weighted odds
8189     SortitionSumTreeFactory.SortitionSumTrees internal sortitionSumTrees;
8190 
8191     // Chainlink
8192     VRFCoordinatorV2Interface COORDINATOR;
8193     LinkTokenInterface LINKTOKEN;
8194     uint64 s_subscriptionId;
8195 
8196     // Mainnet coordinator. 0x271682DEB8C4E0901D1a1550aD2e64D568E69909
8197     // see https://docs.chain.link/docs/vrf-contracts/#configurations
8198     address constant vrfCoordinator =
8199         0x271682DEB8C4E0901D1a1550aD2e64D568E69909;
8200 
8201     // Mainnet LINK token contract. 0x514910771af9ca656af840dff83e8264ecf986ca
8202     // see https://docs.chain.link/docs/vrf-contracts/#configurations
8203     address constant link = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
8204 
8205     // 200 gwei Key Hash lane for chainlink mainnet
8206     // see https://docs.chain.link/docs/vrf-contracts/#configurations
8207     bytes32 constant keyHash =
8208         0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef;
8209 
8210     uint32 constant callbackGasLimit = 500000;
8211     uint16 constant requestConfirmations = 3;
8212 
8213     // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
8214     uint32 numWords = 3;
8215 
8216     uint256[] public s_randomWords;
8217     uint256 public s_requestId;
8218     address s_owner;
8219 
8220     event AddWhitelistedService(address newWhitelistedAddress);
8221     event RemoveWhitelistedService(address removedWhitelistedAddress);
8222     event SetCustomToken(IERC20 tokenAddress);
8223     event SetRuffleInuToken(IERC20 ruffleInuTokenAddress);
8224     event Staked(address indexed account, uint256 amount);
8225     event Unstaked(address indexed account, uint256 amount);
8226     event SetERC721(IERC721 nft);
8227     event SetPercentageOfJackpot(
8228         uint256[] newJackpotPercentages,
8229         uint256 newNumWords
8230     );
8231     event UpdateSubscription(
8232         uint256 oldSubscriptionId,
8233         uint256 newSubscriptionId
8234     );
8235     event EthLotteryStarted(uint256 jackpot, uint256 numberOfWinners);
8236     event TokenLotteryStarted(uint256 jackpot, uint256 numberOfWinners);
8237     event NFTLotteryStarted(uint256 nftId);
8238     event PayWinnersEth(address[] winners);
8239     event PayWinnersTokens(address[] winners);
8240     event PayWinnerNFT(address[] winners);
8241     event SetStakingEnabled(bool stakingEnabled);
8242 
8243     constructor(uint64 subscriptionId, address payable _gelatoOp)
8244         VRFConsumerBaseV2(vrfCoordinator)
8245     {
8246         COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
8247         LINKTOKEN = LinkTokenInterface(link);
8248         sortitionSumTrees.createTree(TREE_KEY, MAX_TREE_LEAVES);
8249         s_owner = msg.sender;
8250         s_subscriptionId = subscriptionId;
8251         addWhitelistedService(_gelatoOp);
8252         addWhitelistedService(msg.sender);
8253     }
8254 
8255     modifier onlyWhitelistedServices() {
8256         require(
8257             _whitelistedServices[msg.sender] == true,
8258             "onlyWhitelistedServices can perform this action"
8259         );
8260         _;
8261     }
8262 
8263     modifier lotteryNotStarted() {
8264         require(
8265             status == Status.NotStarted || status == Status.WinnerPaid,
8266             "lottery has already started"
8267         );
8268         require(
8269             lotteryType == LotteryType.NotStarted,
8270             "the previous winner has to be paid before starting a new lottery"
8271         );
8272         _;
8273     }
8274 
8275     modifier winnerPayable() {
8276         require(
8277             status == Status.WinnersSelected,
8278             "the winner is not yet selected"
8279         );
8280         _;
8281     }
8282 
8283     //Receive function
8284     receive() external payable {}
8285 
8286     /// @notice Add new service that can call payWinnersEth and startEthLottery.
8287     /// @param _service New service to add
8288     function addWhitelistedService(address _service) public onlyOwner {
8289         require(
8290             _whitelistedServices[_service] != true,
8291             "TaskTreasury: addWhitelistedService: whitelisted"
8292         );
8293         _whitelistedServices[_service] = true;
8294         emit AddWhitelistedService(_service);
8295     }
8296 
8297     /// @notice Remove old service that can call startEthLottery and payWinnersEth
8298     /// @param _service Old service to remove
8299     function removeWhitelistedService(address _service) external onlyOwner {
8300         require(
8301             _whitelistedServices[_service] == true,
8302             "addWhitelistedService: !whitelisted"
8303         );
8304         _whitelistedServices[_service] = false;
8305         emit RemoveWhitelistedService(_service);
8306     }
8307 
8308     /// @notice a function to cancel the current lottery in case the chainlink vrf fails
8309     /// @dev only call this when the chainlink vrf fails
8310 
8311     function cancelLottery() external onlyOwner {
8312         require(
8313             status == Status.Started || status == Status.WinnersSelected,
8314             "you can only cancel a lottery if one has been started or if something goes wrong after selection"
8315         );
8316         jackpot = 0;
8317         setStakingEnabled(true);
8318         status = Status.WinnerPaid;
8319         lotteryType = LotteryType.NotStarted;
8320         delete selectedWinners;
8321     }
8322 
8323     /// @notice draw the winning addresses from the Sum Tree
8324     function draw() external onlyOwner {
8325         require(status == Status.Started, "lottery has not yen been started");
8326         for (uint256 i = 0; i < s_randomWords.length; i++) {
8327             uint256 winningNumber = s_randomWords[i] % totalStaked;
8328             selectedWinners.push(
8329                 payable(
8330                     address(
8331                         uint160(
8332                             uint256(
8333                                 sortitionSumTrees.draw(TREE_KEY, winningNumber)
8334                             )
8335                         )
8336                     )
8337                 )
8338             );
8339             winningNumbers.push(winningNumber);
8340         }
8341         status = Status.WinnersSelected;
8342     }
8343 
8344     /// @notice function needed to receive erc721 tokens in the contract
8345     function onERC721Received(
8346         address,
8347         address,
8348         uint256,
8349         bytes calldata
8350     ) external pure override returns (bytes4) {
8351         return
8352             bytes4(
8353                 keccak256("onERC721Received(address,address,uint256,bytes)")
8354             );
8355     }
8356 
8357     /// @notice pay the winners of the lottery
8358     function payWinnersTokens() external onlyOwner winnerPayable {
8359         require(
8360             lotteryType == LotteryType.Token,
8361             "the lottery that has been drawn is not a custom lottery"
8362         );
8363 
8364         delete lastWinners;
8365         for (uint256 i = 0; i < selectedWinners.length; i++) {
8366             uint256 _amountWon = jackpot.mul(percentageOfJackpot[i]).div(100);
8367             customToken.safeTransfer(selectedWinners[i], _amountWon);
8368             lastWinners.push(selectedWinners[i]);
8369             amountWonByUser[selectedWinners[i]] += _amountWon;
8370         }
8371         lastJackpot = jackpot;
8372         totalWinnersPaid += selectedWinners.length;
8373         delete selectedWinners;
8374         jackpot = 0;
8375         setStakingEnabled(true);
8376         status = Status.WinnerPaid;
8377         lotteryType = LotteryType.NotStarted;
8378         emit PayWinnersTokens(lastWinners);
8379     }
8380 
8381     /// @notice pay the winners of the lottery
8382     function payWinnersEth() external onlyWhitelistedServices winnerPayable {
8383         require(
8384             lotteryType == LotteryType.Ethereum,
8385             "the lottery that has been drawn is not an eth lottery"
8386         );
8387 
8388         delete lastWinners;
8389         for (uint256 i = 0; i < selectedWinners.length; i++) {
8390             uint256 _amountWon = jackpot.mul(percentageOfJackpot[i]).div(100);
8391             selectedWinners[i].transfer(_amountWon);
8392             lastWinners.push(selectedWinners[i]);
8393             amountWonByUser[selectedWinners[i]] += _amountWon;
8394         }
8395         lastJackpot = jackpot;
8396         totalEthPaid += jackpot;
8397         totalWinnersPaid += selectedWinners.length;
8398         delete selectedWinners;
8399         jackpot = 0;
8400         setStakingEnabled(true);
8401         status = Status.WinnerPaid;
8402         lotteryType = LotteryType.NotStarted;
8403         emit PayWinnersEth(lastWinners);
8404     }
8405 
8406     /// @notice pay the winners of the lottery
8407     function payWinnersERC721() external onlyOwner winnerPayable {
8408         require(
8409             lotteryType == LotteryType.NFT721,
8410             "the lottery that has been drawn is not a ERC721 lottery"
8411         );
8412 
8413         delete lastWinners;
8414         nft721.safeTransferFrom(address(this), selectedWinners[0], nftId);
8415         lastWinners.push(selectedWinners[0]);
8416         totalWinnersPaid += 1;
8417         delete selectedWinners;
8418         setStakingEnabled(true);
8419         status = Status.WinnerPaid;
8420         lotteryType = LotteryType.NotStarted;
8421         emit PayWinnerNFT(lastWinners);
8422     }
8423 
8424     /// @notice a function to add a custom token for a custom token lottery
8425     /// @param customTokenAddress the address of the custom token that we want to add to the contract
8426     function setCustomToken(IERC20 customTokenAddress) external onlyOwner {
8427         customToken = IERC20(customTokenAddress);
8428 
8429         emit SetCustomToken(customTokenAddress);
8430     }
8431 
8432     /// @notice a function to set the address of the ruffle token
8433     /// @param ruffleAddress is the address of the ruffle token
8434     function setRuffleInuToken(IERC20 ruffleAddress) external onlyOwner {
8435         ruffle = IERC20(ruffleAddress);
8436         emit SetRuffleInuToken(ruffleAddress);
8437     }
8438 
8439     /// @notice add erc721 token to the contract for the next lottery
8440     function setERC721(IERC721 _nft) external onlyOwner {
8441         nft721 = IERC721(_nft);
8442         emit SetERC721(_nft);
8443     }
8444 
8445     /// @notice a function to set the jackpot distribution
8446     /// @param percentages an array of the percentage distribution
8447     function setPercentageOfJackpot(uint256[] memory percentages)
8448         external
8449         onlyOwner
8450     {
8451         require(
8452             status == Status.NotStarted || status == Status.WinnerPaid,
8453             "you can only change the jackpot percentages if the lottery is not running"
8454         );
8455         delete percentageOfJackpot;
8456         uint256 _totalSum = 0;
8457         for (uint256 i; i < percentages.length; i++) {
8458             percentageOfJackpot.push(percentages[i]);
8459             _totalSum = _totalSum.add(percentages[i]);
8460         }
8461         require(_totalSum == 100, "the sum of the percentages has to be 100");
8462         numWords = uint32(percentages.length);
8463         emit SetPercentageOfJackpot(percentages, numWords);
8464     }
8465 
8466     /// @notice Stakes tokens. NOTE: Staking and unstaking not possible during lottery draw
8467     /// @param amount Amount to stake and lock
8468     function stake(uint256 amount) external {
8469         require(stakingEnabled, "staking is not open");
8470         if (balanceOf[msg.sender] == 0) {
8471             sortitionSumTrees.set(
8472                 TREE_KEY,
8473                 amount,
8474                 bytes32(uint256(uint160(address(msg.sender))))
8475             );
8476         } else {
8477             uint256 _newValue = balanceOf[msg.sender].add(amount);
8478             sortitionSumTrees.set(
8479                 TREE_KEY,
8480                 _newValue,
8481                 bytes32(uint256(uint160(address(msg.sender))))
8482             );
8483         }
8484         ruffle.safeTransferFrom(msg.sender, address(this), amount);
8485         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
8486         totalStaked = totalStaked.add(amount);
8487         emit Staked(msg.sender, amount);
8488     }
8489 
8490     /// @notice Start a new lottery
8491     /// @param _amount in tokens to add to this lottery
8492     function startTokenLottery(uint256 _amount)
8493         external
8494         onlyOwner
8495         lotteryNotStarted
8496     {
8497         require(
8498             _amount <= customToken.balanceOf(address(this)),
8499             "The jackpot has to be less than or equal to the tokens in the contract"
8500         );
8501 
8502         delete winningNumbers;
8503         delete s_randomWords;
8504         setStakingEnabled(false);
8505         requestRandomWords();
8506         jackpot = _amount;
8507         status = Status.Started;
8508         lotteryType = LotteryType.Token;
8509         emit TokenLotteryStarted(jackpot, numWords);
8510     }
8511 
8512     /// @notice Start a new lottery
8513     /// @param _amount The amount in eth to add to this lottery
8514     function startEthLottery(uint256 _amount)
8515         external
8516         onlyWhitelistedServices
8517         lotteryNotStarted
8518     {
8519         require(
8520             _amount <= address(this).balance,
8521             "You can maximum add all the eth in the contract balance"
8522         );
8523         delete winningNumbers;
8524         delete s_randomWords;
8525         setStakingEnabled(false);
8526         requestRandomWords();
8527         jackpot = _amount;
8528         status = Status.Started;
8529         lotteryType = LotteryType.Ethereum;
8530         emit EthLotteryStarted(jackpot, numWords);
8531     }
8532 
8533     /// @notice Start a new nft lottery
8534     /// @param _tokenId the id of the nft you want to give away in the lottery
8535     /// @dev set the jackpot to 1 winner [100] before calling this function
8536     function startERC721Lottery(uint256 _tokenId)
8537         external
8538         onlyOwner
8539         lotteryNotStarted
8540     {
8541         require(nft721.ownerOf(_tokenId) == address(this));
8542         require(
8543             percentageOfJackpot.length == 1,
8544             "jackpot has to be set to 1 winner first, percentageOfJackpot = [100]"
8545         );
8546         delete winningNumbers;
8547         delete s_randomWords;
8548         nftId = _tokenId;
8549         setStakingEnabled(false);
8550         requestRandomWords();
8551         status = Status.Started;
8552         lotteryType = LotteryType.NFT721;
8553         emit NFTLotteryStarted(nftId);
8554     }
8555 
8556     /// @notice Withdraws staked tokens
8557     /// @param _amount Amount to withdraw
8558     function unstake(uint256 _amount) external {
8559         require(stakingEnabled, "staking is not open");
8560         require(
8561             _amount <= balanceOf[msg.sender],
8562             "you cannot unstake more than you have staked"
8563         );
8564         uint256 _newStakingBalance = balanceOf[msg.sender].sub(_amount);
8565         sortitionSumTrees.set(
8566             TREE_KEY,
8567             _newStakingBalance,
8568             bytes32(uint256(uint160(address(msg.sender))))
8569         );
8570         balanceOf[msg.sender] = _newStakingBalance;
8571         totalStaked = totalStaked.sub(_amount);
8572         ruffle.safeTransfer(msg.sender, _amount);
8573 
8574         emit Unstaked(msg.sender, _amount);
8575     }
8576 
8577     /// @notice function to update the chainlink subscription
8578     /// @param subscriptionId Amount to withdraw
8579     function updateSubscription(uint64 subscriptionId) external {
8580         uint256 _oldValue = s_subscriptionId;
8581         s_subscriptionId = subscriptionId;
8582         emit UpdateSubscription(_oldValue, subscriptionId);
8583     }
8584 
8585     /// @notice Emergency withdraw only call when problems or after community vote
8586     /// @dev Only in emergency cases. Protected by multisig APAD
8587     function withdraw() external onlyMultisig {
8588         payable(msg.sender).transfer(address(this).balance);
8589     }
8590 
8591     /// @notice The chance a user has of winning the lottery. Tokens staked by user / total tokens staked
8592     /// @param account The account that we want to get the chance of winning for
8593     /// @return chanceOfWinning The chance a user has to win
8594     function chanceOf(address account)
8595         external
8596         view
8597         returns (uint256 chanceOfWinning)
8598     {
8599         return
8600             sortitionSumTrees.stakeOf(
8601                 TREE_KEY,
8602                 bytes32(uint256(uint160(address(account))))
8603             );
8604     }
8605 
8606     /// @notice get the staked ruffle balance of an address
8607     function getBalance(address staker)
8608         external
8609         view
8610         returns (uint256 balance)
8611     {
8612         return balanceOf[staker];
8613     }
8614 
8615     /// @notice a function to set open/close staking
8616     function setStakingEnabled(bool _stakingEnabled)
8617         public
8618         onlyWhitelistedServices
8619     {
8620         stakingEnabled = _stakingEnabled;
8621         emit SetStakingEnabled(_stakingEnabled);
8622     }
8623 
8624     /// @notice Request random words from Chainlink VRF V2
8625     function requestRandomWords() internal {
8626         // Will revert if subscription is not set and funded.
8627         s_requestId = COORDINATOR.requestRandomWords(
8628             keyHash,
8629             s_subscriptionId,
8630             requestConfirmations,
8631             callbackGasLimit,
8632             numWords
8633         );
8634     }
8635 
8636     /// @notice fulfill the randomwords from chainlink
8637     function fulfillRandomWords(
8638         uint256, /* requestId */
8639         uint256[] memory randomWords
8640     ) internal override {
8641         s_randomWords = randomWords;
8642         if (s_randomWords.length <= 5) {
8643             for (uint256 i = 0; i < s_randomWords.length; i++) {
8644                 uint256 winningNumber = s_randomWords[i] % totalStaked;
8645                 selectedWinners.push(
8646                     payable(
8647                         address(
8648                             uint160(
8649                                 uint256(
8650                                     sortitionSumTrees.draw(
8651                                         TREE_KEY,
8652                                         winningNumber
8653                                     )
8654                                 )
8655                             )
8656                         )
8657                     )
8658                 );
8659                 winningNumbers.push(winningNumber);
8660             }
8661             status = Status.WinnersSelected;
8662         }
8663     }
8664 }