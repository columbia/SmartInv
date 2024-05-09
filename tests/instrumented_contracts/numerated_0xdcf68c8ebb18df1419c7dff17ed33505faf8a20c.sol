1 // File: openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)
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
31  *
32  * [WARNING]
33  * ====
34  *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
35  *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
36  *
37  *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
38  * ====
39  */
40 library EnumerableSet {
41     // To implement this library for multiple types with as little code
42     // repetition as possible, we write it in terms of a generic Set type with
43     // bytes32 values.
44     // The Set implementation uses private functions, and user-facing
45     // implementations (such as AddressSet) are just wrappers around the
46     // underlying Set.
47     // This means that we can only create new EnumerableSets for types that fit
48     // in bytes32.
49 
50     struct Set {
51         // Storage of set values
52         bytes32[] _values;
53         // Position of the value in the `values` array, plus 1 because index 0
54         // means a value is not in the set.
55         mapping(bytes32 => uint256) _indexes;
56     }
57 
58     /**
59      * @dev Add a value to a set. O(1).
60      *
61      * Returns true if the value was added to the set, that is if it was not
62      * already present.
63      */
64     function _add(Set storage set, bytes32 value) private returns (bool) {
65         if (!_contains(set, value)) {
66             set._values.push(value);
67             // The value is stored at length-1, but we add 1 to all indexes
68             // and use 0 as a sentinel value
69             set._indexes[value] = set._values.length;
70             return true;
71         } else {
72             return false;
73         }
74     }
75 
76     /**
77      * @dev Removes a value from a set. O(1).
78      *
79      * Returns true if the value was removed from the set, that is if it was
80      * present.
81      */
82     function _remove(Set storage set, bytes32 value) private returns (bool) {
83         // We read and store the value's index to prevent multiple reads from the same storage slot
84         uint256 valueIndex = set._indexes[value];
85 
86         if (valueIndex != 0) {
87             // Equivalent to contains(set, value)
88             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
89             // the array, and then remove the last element (sometimes called as 'swap and pop').
90             // This modifies the order of the array, as noted in {at}.
91 
92             uint256 toDeleteIndex = valueIndex - 1;
93             uint256 lastIndex = set._values.length - 1;
94 
95             if (lastIndex != toDeleteIndex) {
96                 bytes32 lastValue = set._values[lastIndex];
97 
98                 // Move the last value to the index where the value to delete is
99                 set._values[toDeleteIndex] = lastValue;
100                 // Update the index for the moved value
101                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
102             }
103 
104             // Delete the slot where the moved value was stored
105             set._values.pop();
106 
107             // Delete the index for the deleted slot
108             delete set._indexes[value];
109 
110             return true;
111         } else {
112             return false;
113         }
114     }
115 
116     /**
117      * @dev Returns true if the value is in the set. O(1).
118      */
119     function _contains(Set storage set, bytes32 value) private view returns (bool) {
120         return set._indexes[value] != 0;
121     }
122 
123     /**
124      * @dev Returns the number of values on the set. O(1).
125      */
126     function _length(Set storage set) private view returns (uint256) {
127         return set._values.length;
128     }
129 
130     /**
131      * @dev Returns the value stored at position `index` in the set. O(1).
132      *
133      * Note that there are no guarantees on the ordering of values inside the
134      * array, and it may change when more values are added or removed.
135      *
136      * Requirements:
137      *
138      * - `index` must be strictly less than {length}.
139      */
140     function _at(Set storage set, uint256 index) private view returns (bytes32) {
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
168     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
169         return _add(set._inner, value);
170     }
171 
172     /**
173      * @dev Removes a value from a set. O(1).
174      *
175      * Returns true if the value was removed from the set, that is if it was
176      * present.
177      */
178     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
179         return _remove(set._inner, value);
180     }
181 
182     /**
183      * @dev Returns true if the value is in the set. O(1).
184      */
185     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
186         return _contains(set._inner, value);
187     }
188 
189     /**
190      * @dev Returns the number of values in the set. O(1).
191      */
192     function length(Bytes32Set storage set) internal view returns (uint256) {
193         return _length(set._inner);
194     }
195 
196     /**
197      * @dev Returns the value stored at position `index` in the set. O(1).
198      *
199      * Note that there are no guarantees on the ordering of values inside the
200      * array, and it may change when more values are added or removed.
201      *
202      * Requirements:
203      *
204      * - `index` must be strictly less than {length}.
205      */
206     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
207         return _at(set._inner, index);
208     }
209 
210     /**
211      * @dev Return the entire set in an array
212      *
213      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
214      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
215      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
216      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
217      */
218     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
219         return _values(set._inner);
220     }
221 
222     // AddressSet
223 
224     struct AddressSet {
225         Set _inner;
226     }
227 
228     /**
229      * @dev Add a value to a set. O(1).
230      *
231      * Returns true if the value was added to the set, that is if it was not
232      * already present.
233      */
234     function add(AddressSet storage set, address value) internal returns (bool) {
235         return _add(set._inner, bytes32(uint256(uint160(value))));
236     }
237 
238     /**
239      * @dev Removes a value from a set. O(1).
240      *
241      * Returns true if the value was removed from the set, that is if it was
242      * present.
243      */
244     function remove(AddressSet storage set, address value) internal returns (bool) {
245         return _remove(set._inner, bytes32(uint256(uint160(value))));
246     }
247 
248     /**
249      * @dev Returns true if the value is in the set. O(1).
250      */
251     function contains(AddressSet storage set, address value) internal view returns (bool) {
252         return _contains(set._inner, bytes32(uint256(uint160(value))));
253     }
254 
255     /**
256      * @dev Returns the number of values in the set. O(1).
257      */
258     function length(AddressSet storage set) internal view returns (uint256) {
259         return _length(set._inner);
260     }
261 
262     /**
263      * @dev Returns the value stored at position `index` in the set. O(1).
264      *
265      * Note that there are no guarantees on the ordering of values inside the
266      * array, and it may change when more values are added or removed.
267      *
268      * Requirements:
269      *
270      * - `index` must be strictly less than {length}.
271      */
272     function at(AddressSet storage set, uint256 index) internal view returns (address) {
273         return address(uint160(uint256(_at(set._inner, index))));
274     }
275 
276     /**
277      * @dev Return the entire set in an array
278      *
279      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
280      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
281      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
282      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
283      */
284     function values(AddressSet storage set) internal view returns (address[] memory) {
285         bytes32[] memory store = _values(set._inner);
286         address[] memory result;
287 
288         /// @solidity memory-safe-assembly
289         assembly {
290             result := store
291         }
292 
293         return result;
294     }
295 
296     // UintSet
297 
298     struct UintSet {
299         Set _inner;
300     }
301 
302     /**
303      * @dev Add a value to a set. O(1).
304      *
305      * Returns true if the value was added to the set, that is if it was not
306      * already present.
307      */
308     function add(UintSet storage set, uint256 value) internal returns (bool) {
309         return _add(set._inner, bytes32(value));
310     }
311 
312     /**
313      * @dev Removes a value from a set. O(1).
314      *
315      * Returns true if the value was removed from the set, that is if it was
316      * present.
317      */
318     function remove(UintSet storage set, uint256 value) internal returns (bool) {
319         return _remove(set._inner, bytes32(value));
320     }
321 
322     /**
323      * @dev Returns true if the value is in the set. O(1).
324      */
325     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
326         return _contains(set._inner, bytes32(value));
327     }
328 
329     /**
330      * @dev Returns the number of values on the set. O(1).
331      */
332     function length(UintSet storage set) internal view returns (uint256) {
333         return _length(set._inner);
334     }
335 
336     /**
337      * @dev Returns the value stored at position `index` in the set. O(1).
338      *
339      * Note that there are no guarantees on the ordering of values inside the
340      * array, and it may change when more values are added or removed.
341      *
342      * Requirements:
343      *
344      * - `index` must be strictly less than {length}.
345      */
346     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
347         return uint256(_at(set._inner, index));
348     }
349 
350     /**
351      * @dev Return the entire set in an array
352      *
353      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
354      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
355      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
356      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
357      */
358     function values(UintSet storage set) internal view returns (uint256[] memory) {
359         bytes32[] memory store = _values(set._inner);
360         uint256[] memory result;
361 
362         /// @solidity memory-safe-assembly
363         assembly {
364             result := store
365         }
366 
367         return result;
368     }
369 }
370 
371 // File: IERC721W.sol
372 
373 
374 pragma solidity ^0.8.0;
375 
376 /* Blue chip NFT (BCN) is the NFT that supported ERC721 and world famous.
377 * BCN's holders can mint new NFT through this protocol.
378 * The new NFT needs to specify the supported BCN's contract addresses and each address's quantity of mintable.
379 * The address holding the BCN can mint the same amount of new NFT.
380 * The tokenId used for each mint will be recorded and cannot be used again.
381 */
382 interface IERC721W{
383     event MintByBCN(uint256 indexed tokenId, address indexed to, address indexed bcn, uint256 bcnTokenId);
384     
385     // Get the length of supported BCN list
386     // Returns length: The length of supported BCN list
387     function lengthOfSupportedBcn() external view returns(uint256 length);
388     
389     // Get a list of supported BCN addresses
390     // Param index: The index in supported BCN list
391     // Returns bcn: The BCN address by the index
392     function supportedBcnByIndex(uint256 index) external view returns(address bcn);
393     
394     // Get whether the BCN is supported
395     // Param bcn: The BCN address
396     // Returns supported: whether the BCN is supported
397     function isBcnSupported(address bcn) external view returns(bool supported);
398     
399     // Get the number of new NFTs that can be mint by one blue chip NFT
400     // Param bcn: The BCN address
401     // Return total: The total number of new NFTs that can be mint by the blue chip NFT
402     // Return remaining: The remaining number of new NFTs that can be mint by the blue chip NFT
403     function mintNumberOfBcn(address bcn) external view returns(uint256 total, uint256 remaining);
404     
405     // Get whether the tokenId of the BCN is used
406     // Param bcn & bcnTokenId: The address and tokenId of BCN to be queried
407     // Return used: true means used
408     function isTokenMintByBcn(address bcn, uint256 bcnTokenId) external view returns(bool used);
409     
410     // Mint new nft By BCN
411     // Param tokenId: New NFT's tokenIf to be mint
412     // Param bcn & bcnTokenId: The address and tokenId of BCN to be queried
413     // Requirement: tokenId is not mint
414     // Requirement: bcn's bcnTokenId is not use
415     // Notice: when the call is successful, record bcnTokenId of bcn is used
416     // Notice: when the call is successful, emit MintByBCN event
417     // Notice: when the call is successful, update the remaining number of mintable 
418     function mintByBcn(uint256 tokenId, address bcn, uint256 bcnTokenId) external;
419 }
420 
421 // File: ChainlinkVRF/VRFCoordinatorV2Interface.sol
422 
423 
424 pragma solidity ^0.8.0;
425 
426 interface VRFCoordinatorV2Interface {
427   /**
428    * @notice Get configuration relevant for making requests
429    * @return minimumRequestConfirmations global min for request confirmations
430    * @return maxGasLimit global max for request gas limit
431    * @return s_provingKeyHashes list of registered key hashes
432    */
433   function getRequestConfig()
434     external
435     view
436     returns (
437       uint16,
438       uint32,
439       bytes32[] memory
440     );
441 
442   /**
443    * @notice Request a set of random words.
444    * @param keyHash - Corresponds to a particular oracle job which uses
445    * that key for generating the VRF proof. Different keyHash's have different gas price
446    * ceilings, so you can select a specific one to bound your maximum per request cost.
447    * @param subId  - The ID of the VRF subscription. Must be funded
448    * with the minimum subscription balance required for the selected keyHash.
449    * @param minimumRequestConfirmations - How many blocks you'd like the
450    * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
451    * for why you may want to request more. The acceptable range is
452    * [minimumRequestBlockConfirmations, 200].
453    * @param callbackGasLimit - How much gas you'd like to receive in your
454    * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
455    * may be slightly less than this amount because of gas used calling the function
456    * (argument decoding etc.), so you may need to request slightly more than you expect
457    * to have inside fulfillRandomWords. The acceptable range is
458    * [0, maxGasLimit]
459    * @param numWords - The number of uint256 random values you'd like to receive
460    * in your fulfillRandomWords callback. Note these numbers are expanded in a
461    * secure way by the VRFCoordinator from a single random value supplied by the oracle.
462    * @return requestId - A unique identifier of the request. Can be used to match
463    * a request to a response in fulfillRandomWords.
464    */
465   function requestRandomWords(
466     bytes32 keyHash,
467     uint64 subId,
468     uint16 minimumRequestConfirmations,
469     uint32 callbackGasLimit,
470     uint32 numWords
471   ) external returns (uint256 requestId);
472 
473   /**
474    * @notice Create a VRF subscription.
475    * @return subId - A unique subscription id.
476    * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
477    * @dev Note to fund the subscription, use transferAndCall. For example
478    * @dev  LINKTOKEN.transferAndCall(
479    * @dev    address(COORDINATOR),
480    * @dev    amount,
481    * @dev    abi.encode(subId));
482    */
483   function createSubscription() external returns (uint64 subId);
484 
485   /**
486    * @notice Get a VRF subscription.
487    * @param subId - ID of the subscription
488    * @return balance - LINK balance of the subscription in juels.
489    * @return reqCount - number of requests for this subscription, determines fee tier.
490    * @return owner - owner of the subscription.
491    * @return consumers - list of consumer address which are able to use this subscription.
492    */
493   function getSubscription(uint64 subId)
494     external
495     view
496     returns (
497       uint96 balance,
498       uint64 reqCount,
499       address owner,
500       address[] memory consumers
501     );
502 
503   /**
504    * @notice Request subscription owner transfer.
505    * @param subId - ID of the subscription
506    * @param newOwner - proposed new owner of the subscription
507    */
508   function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;
509 
510   /**
511    * @notice Request subscription owner transfer.
512    * @param subId - ID of the subscription
513    * @dev will revert if original owner of subId has
514    * not requested that msg.sender become the new owner.
515    */
516   function acceptSubscriptionOwnerTransfer(uint64 subId) external;
517 
518   /**
519    * @notice Add a consumer to a VRF subscription.
520    * @param subId - ID of the subscription
521    * @param consumer - New consumer which can use the subscription
522    */
523   function addConsumer(uint64 subId, address consumer) external;
524 
525   /**
526    * @notice Remove a consumer from a VRF subscription.
527    * @param subId - ID of the subscription
528    * @param consumer - Consumer to remove from the subscription
529    */
530   function removeConsumer(uint64 subId, address consumer) external;
531 
532   /**
533    * @notice Cancel a subscription
534    * @param subId - ID of the subscription
535    * @param to - Where to send the remaining LINK to
536    */
537   function cancelSubscription(uint64 subId, address to) external;
538 
539   /*
540    * @notice Check to see if there exists a request commitment consumers
541    * for all consumers and keyhashes for a given sub.
542    * @param subId - ID of the subscription
543    * @return true if there exists at least one unfulfilled request for the subscription, false
544    * otherwise.
545    */
546   function pendingRequestExists(uint64 subId) external view returns (bool);
547 }
548 // File: ChainlinkVRF/VRFConsumerBaseV2.sol
549 
550 
551 pragma solidity ^0.8.4;
552 
553 /** ****************************************************************************
554  * @notice Interface for contracts using VRF randomness
555  * *****************************************************************************
556  * @dev PURPOSE
557  *
558  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
559  * @dev to Vera the verifier in such a way that Vera can be sure he's not
560  * @dev making his output up to suit himself. Reggie provides Vera a public key
561  * @dev to which he knows the secret key. Each time Vera provides a seed to
562  * @dev Reggie, he gives back a value which is computed completely
563  * @dev deterministically from the seed and the secret key.
564  *
565  * @dev Reggie provides a proof by which Vera can verify that the output was
566  * @dev correctly computed once Reggie tells it to her, but without that proof,
567  * @dev the output is indistinguishable to her from a uniform random sample
568  * @dev from the output space.
569  *
570  * @dev The purpose of this contract is to make it easy for unrelated contracts
571  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
572  * @dev simple access to a verifiable source of randomness. It ensures 2 things:
573  * @dev 1. The fulfillment came from the VRFCoordinator
574  * @dev 2. The consumer contract implements fulfillRandomWords.
575  * *****************************************************************************
576  * @dev USAGE
577  *
578  * @dev Calling contracts must inherit from VRFConsumerBase, and can
579  * @dev initialize VRFConsumerBase's attributes in their constructor as
580  * @dev shown:
581  *
582  * @dev   contract VRFConsumer {
583  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
584  * @dev       VRFConsumerBase(_vrfCoordinator) public {
585  * @dev         <initialization with other arguments goes here>
586  * @dev       }
587  * @dev   }
588  *
589  * @dev The oracle will have given you an ID for the VRF keypair they have
590  * @dev committed to (let's call it keyHash). Create subscription, fund it
591  * @dev and your consumer contract as a consumer of it (see VRFCoordinatorInterface
592  * @dev subscription management functions).
593  * @dev Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
594  * @dev callbackGasLimit, numWords),
595  * @dev see (VRFCoordinatorInterface for a description of the arguments).
596  *
597  * @dev Once the VRFCoordinator has received and validated the oracle's response
598  * @dev to your request, it will call your contract's fulfillRandomWords method.
599  *
600  * @dev The randomness argument to fulfillRandomWords is a set of random words
601  * @dev generated from your requestId and the blockHash of the request.
602  *
603  * @dev If your contract could have concurrent requests open, you can use the
604  * @dev requestId returned from requestRandomWords to track which response is associated
605  * @dev with which randomness request.
606  * @dev See "SECURITY CONSIDERATIONS" for principles to keep in mind,
607  * @dev if your contract could have multiple requests in flight simultaneously.
608  *
609  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
610  * @dev differ.
611  *
612  * *****************************************************************************
613  * @dev SECURITY CONSIDERATIONS
614  *
615  * @dev A method with the ability to call your fulfillRandomness method directly
616  * @dev could spoof a VRF response with any random value, so it's critical that
617  * @dev it cannot be directly called by anything other than this base contract
618  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
619  *
620  * @dev For your users to trust that your contract's random behavior is free
621  * @dev from malicious interference, it's best if you can write it so that all
622  * @dev behaviors implied by a VRF response are executed *during* your
623  * @dev fulfillRandomness method. If your contract must store the response (or
624  * @dev anything derived from it) and use it later, you must ensure that any
625  * @dev user-significant behavior which depends on that stored value cannot be
626  * @dev manipulated by a subsequent VRF request.
627  *
628  * @dev Similarly, both miners and the VRF oracle itself have some influence
629  * @dev over the order in which VRF responses appear on the blockchain, so if
630  * @dev your contract could have multiple VRF requests in flight simultaneously,
631  * @dev you must ensure that the order in which the VRF responses arrive cannot
632  * @dev be used to manipulate your contract's user-significant behavior.
633  *
634  * @dev Since the block hash of the block which contains the requestRandomness
635  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
636  * @dev miner could, in principle, fork the blockchain to evict the block
637  * @dev containing the request, forcing the request to be included in a
638  * @dev different block with a different hash, and therefore a different input
639  * @dev to the VRF. However, such an attack would incur a substantial economic
640  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
641  * @dev until it calls responds to a request. It is for this reason that
642  * @dev that you can signal to an oracle you'd like them to wait longer before
643  * @dev responding to the request (however this is not enforced in the contract
644  * @dev and so remains effective only in the case of unmodified oracle software).
645  */
646 abstract contract VRFConsumerBaseV2 {
647   error OnlyCoordinatorCanFulfill(address have, address want);
648   address private immutable vrfCoordinator;
649 
650   /**
651    * @param _vrfCoordinator address of VRFCoordinator contract
652    */
653   constructor(address _vrfCoordinator) {
654     vrfCoordinator = _vrfCoordinator;
655   }
656 
657   /**
658    * @notice fulfillRandomness handles the VRF response. Your contract must
659    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
660    * @notice principles to keep in mind when implementing your fulfillRandomness
661    * @notice method.
662    *
663    * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
664    * @dev signature, and will call it once it has verified the proof
665    * @dev associated with the randomness. (It is triggered via a call to
666    * @dev rawFulfillRandomness, below.)
667    *
668    * @param requestId The Id initially returned by requestRandomness
669    * @param randomWords the VRF output expanded to the requested number of words
670    */
671   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;
672 
673   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
674   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
675   // the origin of the call
676   function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
677     if (msg.sender != vrfCoordinator) {
678       revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
679     }
680     fulfillRandomWords(requestId, randomWords);
681   }
682 }
683 // File: openzeppelin-contracts/contracts/utils/Context.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Provides information about the current execution context, including the
692  * sender of the transaction and its data. While these are generally available
693  * via msg.sender and msg.data, they should not be accessed in such a direct
694  * manner, since when dealing with meta-transactions the account sending and
695  * paying for execution may not be the actual sender (as far as an application
696  * is concerned).
697  *
698  * This contract is only required for intermediate, library-like contracts.
699  */
700 abstract contract Context {
701     function _msgSender() internal view virtual returns (address) {
702         return msg.sender;
703     }
704 
705     function _msgData() internal view virtual returns (bytes calldata) {
706         return msg.data;
707     }
708 }
709 
710 // File: openzeppelin-contracts/contracts/access/Ownable.sol
711 
712 
713 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 
718 /**
719  * @dev Contract module which provides a basic access control mechanism, where
720  * there is an account (an owner) that can be granted exclusive access to
721  * specific functions.
722  *
723  * By default, the owner account will be the one that deploys the contract. This
724  * can later be changed with {transferOwnership}.
725  *
726  * This module is used through inheritance. It will make available the modifier
727  * `onlyOwner`, which can be applied to your functions to restrict their use to
728  * the owner.
729  */
730 abstract contract Ownable is Context {
731     address private _owner;
732 
733     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
734 
735     /**
736      * @dev Initializes the contract setting the deployer as the initial owner.
737      */
738     constructor() {
739         _transferOwnership(_msgSender());
740     }
741 
742     /**
743      * @dev Throws if called by any account other than the owner.
744      */
745     modifier onlyOwner() {
746         _checkOwner();
747         _;
748     }
749 
750     /**
751      * @dev Returns the address of the current owner.
752      */
753     function owner() public view virtual returns (address) {
754         return _owner;
755     }
756 
757     /**
758      * @dev Throws if the sender is not the owner.
759      */
760     function _checkOwner() internal view virtual {
761         require(owner() == _msgSender(), "Ownable: caller is not the owner");
762     }
763 
764     /**
765      * @dev Leaves the contract without owner. It will not be possible to call
766      * `onlyOwner` functions anymore. Can only be called by the current owner.
767      *
768      * NOTE: Renouncing ownership will leave the contract without an owner,
769      * thereby removing any functionality that is only available to the owner.
770      */
771     function renounceOwnership() public virtual onlyOwner {
772         _transferOwnership(address(0));
773     }
774 
775     /**
776      * @dev Transfers ownership of the contract to a new account (`newOwner`).
777      * Can only be called by the current owner.
778      */
779     function transferOwnership(address newOwner) public virtual onlyOwner {
780         require(newOwner != address(0), "Ownable: new owner is the zero address");
781         _transferOwnership(newOwner);
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Internal function without access restriction.
787      */
788     function _transferOwnership(address newOwner) internal virtual {
789         address oldOwner = _owner;
790         _owner = newOwner;
791         emit OwnershipTransferred(oldOwner, newOwner);
792     }
793 }
794 
795 // File: openzeppelin-contracts/contracts/utils/Strings.sol
796 
797 
798 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
799 
800 pragma solidity ^0.8.0;
801 
802 /**
803  * @dev String operations.
804  */
805 library Strings {
806     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
807     uint8 private constant _ADDRESS_LENGTH = 20;
808 
809     /**
810      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
811      */
812     function toString(uint256 value) internal pure returns (string memory) {
813         // Inspired by OraclizeAPI's implementation - MIT licence
814         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
815 
816         if (value == 0) {
817             return "0";
818         }
819         uint256 temp = value;
820         uint256 digits;
821         while (temp != 0) {
822             digits++;
823             temp /= 10;
824         }
825         bytes memory buffer = new bytes(digits);
826         while (value != 0) {
827             digits -= 1;
828             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
829             value /= 10;
830         }
831         return string(buffer);
832     }
833 
834     /**
835      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
836      */
837     function toHexString(uint256 value) internal pure returns (string memory) {
838         if (value == 0) {
839             return "0x00";
840         }
841         uint256 temp = value;
842         uint256 length = 0;
843         while (temp != 0) {
844             length++;
845             temp >>= 8;
846         }
847         return toHexString(value, length);
848     }
849 
850     /**
851      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
852      */
853     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
854         bytes memory buffer = new bytes(2 * length + 2);
855         buffer[0] = "0";
856         buffer[1] = "x";
857         for (uint256 i = 2 * length + 1; i > 1; --i) {
858             buffer[i] = _HEX_SYMBOLS[value & 0xf];
859             value >>= 4;
860         }
861         require(value == 0, "Strings: hex length insufficient");
862         return string(buffer);
863     }
864 
865     /**
866      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
867      */
868     function toHexString(address addr) internal pure returns (string memory) {
869         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
870     }
871 }
872 
873 // File: openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
874 
875 
876 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
877 
878 pragma solidity ^0.8.0;
879 
880 
881 /**
882  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
883  *
884  * These functions can be used to verify that a message was signed by the holder
885  * of the private keys of a given address.
886  */
887 library ECDSA {
888     enum RecoverError {
889         NoError,
890         InvalidSignature,
891         InvalidSignatureLength,
892         InvalidSignatureS,
893         InvalidSignatureV
894     }
895 
896     function _throwError(RecoverError error) private pure {
897         if (error == RecoverError.NoError) {
898             return; // no error: do nothing
899         } else if (error == RecoverError.InvalidSignature) {
900             revert("ECDSA: invalid signature");
901         } else if (error == RecoverError.InvalidSignatureLength) {
902             revert("ECDSA: invalid signature length");
903         } else if (error == RecoverError.InvalidSignatureS) {
904             revert("ECDSA: invalid signature 's' value");
905         } else if (error == RecoverError.InvalidSignatureV) {
906             revert("ECDSA: invalid signature 'v' value");
907         }
908     }
909 
910     /**
911      * @dev Returns the address that signed a hashed message (`hash`) with
912      * `signature` or error string. This address can then be used for verification purposes.
913      *
914      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
915      * this function rejects them by requiring the `s` value to be in the lower
916      * half order, and the `v` value to be either 27 or 28.
917      *
918      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
919      * verification to be secure: it is possible to craft signatures that
920      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
921      * this is by receiving a hash of the original message (which may otherwise
922      * be too long), and then calling {toEthSignedMessageHash} on it.
923      *
924      * Documentation for signature generation:
925      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
926      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
927      *
928      * _Available since v4.3._
929      */
930     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
931         if (signature.length == 65) {
932             bytes32 r;
933             bytes32 s;
934             uint8 v;
935             // ecrecover takes the signature parameters, and the only way to get them
936             // currently is to use assembly.
937             /// @solidity memory-safe-assembly
938             assembly {
939                 r := mload(add(signature, 0x20))
940                 s := mload(add(signature, 0x40))
941                 v := byte(0, mload(add(signature, 0x60)))
942             }
943             return tryRecover(hash, v, r, s);
944         } else {
945             return (address(0), RecoverError.InvalidSignatureLength);
946         }
947     }
948 
949     /**
950      * @dev Returns the address that signed a hashed message (`hash`) with
951      * `signature`. This address can then be used for verification purposes.
952      *
953      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
954      * this function rejects them by requiring the `s` value to be in the lower
955      * half order, and the `v` value to be either 27 or 28.
956      *
957      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
958      * verification to be secure: it is possible to craft signatures that
959      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
960      * this is by receiving a hash of the original message (which may otherwise
961      * be too long), and then calling {toEthSignedMessageHash} on it.
962      */
963     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
964         (address recovered, RecoverError error) = tryRecover(hash, signature);
965         _throwError(error);
966         return recovered;
967     }
968 
969     /**
970      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
971      *
972      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
973      *
974      * _Available since v4.3._
975      */
976     function tryRecover(
977         bytes32 hash,
978         bytes32 r,
979         bytes32 vs
980     ) internal pure returns (address, RecoverError) {
981         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
982         uint8 v = uint8((uint256(vs) >> 255) + 27);
983         return tryRecover(hash, v, r, s);
984     }
985 
986     /**
987      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
988      *
989      * _Available since v4.2._
990      */
991     function recover(
992         bytes32 hash,
993         bytes32 r,
994         bytes32 vs
995     ) internal pure returns (address) {
996         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
997         _throwError(error);
998         return recovered;
999     }
1000 
1001     /**
1002      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1003      * `r` and `s` signature fields separately.
1004      *
1005      * _Available since v4.3._
1006      */
1007     function tryRecover(
1008         bytes32 hash,
1009         uint8 v,
1010         bytes32 r,
1011         bytes32 s
1012     ) internal pure returns (address, RecoverError) {
1013         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1014         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1015         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1016         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1017         //
1018         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1019         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1020         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1021         // these malleable signatures as well.
1022         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1023             return (address(0), RecoverError.InvalidSignatureS);
1024         }
1025         if (v != 27 && v != 28) {
1026             return (address(0), RecoverError.InvalidSignatureV);
1027         }
1028 
1029         // If the signature is valid (and not malleable), return the signer address
1030         address signer = ecrecover(hash, v, r, s);
1031         if (signer == address(0)) {
1032             return (address(0), RecoverError.InvalidSignature);
1033         }
1034 
1035         return (signer, RecoverError.NoError);
1036     }
1037 
1038     /**
1039      * @dev Overload of {ECDSA-recover} that receives the `v`,
1040      * `r` and `s` signature fields separately.
1041      */
1042     function recover(
1043         bytes32 hash,
1044         uint8 v,
1045         bytes32 r,
1046         bytes32 s
1047     ) internal pure returns (address) {
1048         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1049         _throwError(error);
1050         return recovered;
1051     }
1052 
1053     /**
1054      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1055      * produces hash corresponding to the one signed with the
1056      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1057      * JSON-RPC method as part of EIP-191.
1058      *
1059      * See {recover}.
1060      */
1061     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1062         // 32 is the length in bytes of hash,
1063         // enforced by the type signature above
1064         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1065     }
1066 
1067     /**
1068      * @dev Returns an Ethereum Signed Message, created from `s`. This
1069      * produces hash corresponding to the one signed with the
1070      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1071      * JSON-RPC method as part of EIP-191.
1072      *
1073      * See {recover}.
1074      */
1075     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1076         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1077     }
1078 
1079     /**
1080      * @dev Returns an Ethereum Signed Typed Data, created from a
1081      * `domainSeparator` and a `structHash`. This produces hash corresponding
1082      * to the one signed with the
1083      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1084      * JSON-RPC method as part of EIP-712.
1085      *
1086      * See {recover}.
1087      */
1088     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1089         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1090     }
1091 }
1092 
1093 // File: openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
1094 
1095 
1096 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 /**
1101  * @dev Interface of the ERC165 standard, as defined in the
1102  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1103  *
1104  * Implementers can declare support of contract interfaces, which can then be
1105  * queried by others ({ERC165Checker}).
1106  *
1107  * For an implementation, see {ERC165}.
1108  */
1109 interface IERC165 {
1110     /**
1111      * @dev Returns true if this contract implements the interface defined by
1112      * `interfaceId`. See the corresponding
1113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1114      * to learn more about how these ids are created.
1115      *
1116      * This function call must use less than 30 000 gas.
1117      */
1118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1119 }
1120 
1121 // File: openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
1122 
1123 
1124 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 
1129 /**
1130  * @dev Required interface of an ERC721 compliant contract.
1131  */
1132 interface IERC721 is IERC165 {
1133     /**
1134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1135      */
1136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1137 
1138     /**
1139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1140      */
1141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1142 
1143     /**
1144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1145      */
1146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1147 
1148     /**
1149      * @dev Returns the number of tokens in ``owner``'s account.
1150      */
1151     function balanceOf(address owner) external view returns (uint256 balance);
1152 
1153     /**
1154      * @dev Returns the owner of the `tokenId` token.
1155      *
1156      * Requirements:
1157      *
1158      * - `tokenId` must exist.
1159      */
1160     function ownerOf(uint256 tokenId) external view returns (address owner);
1161 
1162     /**
1163      * @dev Safely transfers `tokenId` token from `from` to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - `from` cannot be the zero address.
1168      * - `to` cannot be the zero address.
1169      * - `tokenId` token must exist and be owned by `from`.
1170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function safeTransferFrom(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes calldata data
1180     ) external;
1181 
1182     /**
1183      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1184      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1185      *
1186      * Requirements:
1187      *
1188      * - `from` cannot be the zero address.
1189      * - `to` cannot be the zero address.
1190      * - `tokenId` token must exist and be owned by `from`.
1191      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId
1200     ) external;
1201 
1202     /**
1203      * @dev Transfers `tokenId` token from `from` to `to`.
1204      *
1205      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1206      *
1207      * Requirements:
1208      *
1209      * - `from` cannot be the zero address.
1210      * - `to` cannot be the zero address.
1211      * - `tokenId` token must be owned by `from`.
1212      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function transferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) external;
1221 
1222     /**
1223      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1224      * The approval is cleared when the token is transferred.
1225      *
1226      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1227      *
1228      * Requirements:
1229      *
1230      * - The caller must own the token or be an approved operator.
1231      * - `tokenId` must exist.
1232      *
1233      * Emits an {Approval} event.
1234      */
1235     function approve(address to, uint256 tokenId) external;
1236 
1237     /**
1238      * @dev Approve or remove `operator` as an operator for the caller.
1239      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1240      *
1241      * Requirements:
1242      *
1243      * - The `operator` cannot be the caller.
1244      *
1245      * Emits an {ApprovalForAll} event.
1246      */
1247     function setApprovalForAll(address operator, bool _approved) external;
1248 
1249     /**
1250      * @dev Returns the account approved for `tokenId` token.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      */
1256     function getApproved(uint256 tokenId) external view returns (address operator);
1257 
1258     /**
1259      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1260      *
1261      * See {setApprovalForAll}
1262      */
1263     function isApprovedForAll(address owner, address operator) external view returns (bool);
1264 }
1265 
1266 // File: openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1267 
1268 
1269 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 
1274 /**
1275  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1276  * @dev See https://eips.ethereum.org/EIPS/eip-721
1277  */
1278 interface IERC721Enumerable is IERC721 {
1279     /**
1280      * @dev Returns the total amount of tokens stored by the contract.
1281      */
1282     function totalSupply() external view returns (uint256);
1283 
1284     /**
1285      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1286      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1287      */
1288     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1289 
1290     /**
1291      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1292      * Use along with {totalSupply} to enumerate all tokens.
1293      */
1294     function tokenByIndex(uint256 index) external view returns (uint256);
1295 }
1296 
1297 // File: openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol
1298 
1299 
1300 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1301 
1302 pragma solidity ^0.8.0;
1303 
1304 
1305 /**
1306  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1307  * @dev See https://eips.ethereum.org/EIPS/eip-721
1308  */
1309 interface IERC721Metadata is IERC721 {
1310     /**
1311      * @dev Returns the token collection name.
1312      */
1313     function name() external view returns (string memory);
1314 
1315     /**
1316      * @dev Returns the token collection symbol.
1317      */
1318     function symbol() external view returns (string memory);
1319 
1320     /**
1321      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1322      */
1323     function tokenURI(uint256 tokenId) external view returns (string memory);
1324 }
1325 
1326 // File: openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
1327 
1328 
1329 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1330 
1331 pragma solidity ^0.8.0;
1332 
1333 /**
1334  * @title ERC721 token receiver interface
1335  * @dev Interface for any contract that wants to support safeTransfers
1336  * from ERC721 asset contracts.
1337  */
1338 interface IERC721Receiver {
1339     /**
1340      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1341      * by `operator` from `from`, this function is called.
1342      *
1343      * It must return its Solidity selector to confirm the token transfer.
1344      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1345      *
1346      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1347      */
1348     function onERC721Received(
1349         address operator,
1350         address from,
1351         uint256 tokenId,
1352         bytes calldata data
1353     ) external returns (bytes4);
1354 }
1355 
1356 // File: AngryCat2.sol
1357 
1358 
1359 pragma solidity ^0.8.0;
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 
1368 
1369 
1370 
1371 interface INEST{
1372     function nestingTransfer(uint256 tokenId) external view returns (bool allowed);
1373 }
1374 
1375 contract NFT is IERC721Metadata, IERC721Enumerable, Ownable, VRFConsumerBaseV2(0x271682DEB8C4E0901D1a1550aD2e64D568E69909), IERC721W{
1376   using EnumerableSet for EnumerableSet.AddressSet;
1377 
1378   struct TokenOwnership {
1379     address addr;
1380     uint64 startTimestamp;
1381   }
1382 
1383   struct AddressData {
1384     uint128 balance;
1385     uint128 numberMinted;
1386   }
1387 
1388   uint256 private currentIndex = 0;
1389   uint256 internal constant maxBatchSize = 50;
1390   string private _name;
1391   string private _symbol;
1392   mapping(uint256 => TokenOwnership) private _ownerships;
1393   mapping(address => AddressData) private _addressData;
1394   mapping(uint256 => address) private _tokenApprovals;
1395   mapping(address => mapping(address => bool)) private _operatorApprovals;
1396   string private _boxUri;
1397   string private _tokenUri;
1398   uint256 constant public maxTotalSupply = 10000;
1399   uint256 private _boxOffset = 10000;
1400   EnumerableSet.AddressSet private _supportedBcns;
1401   mapping(address => uint256) private _supplyOfBcn;
1402   mapping(address => uint256) private _remaingOfBcn;
1403   mapping(address => mapping(uint256 => bool)) private _isTokenMintByBcn;
1404   uint256[] private _startTimes;
1405   address public signer;
1406   address public nest;
1407   mapping(address => bool) public whitelistMinted;
1408   mapping(address => bool) public winnerMinted;
1409   
1410   constructor(string memory name_, string memory symbol_, string memory boxUri_, address signer_, uint256[] memory startTimes) {
1411     _name = name_;
1412     _symbol = symbol_;
1413     _boxUri = boxUri_;
1414     signer = signer_;
1415     _startTimes = startTimes;
1416   }
1417 
1418   function totalSupply() public view override returns (uint256) {
1419     return currentIndex;
1420   }
1421 
1422   function tokenByIndex(uint256 index) public view override returns (uint256) {
1423     require(index < totalSupply(), "ERC721A: global index out of bounds");
1424     return index;
1425   }
1426 
1427   function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256){
1428     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1429     uint256 numMintedSoFar = totalSupply();
1430     uint256 tokenIdsIdx = 0;
1431     address currOwnershipAddr = address(0);
1432     for (uint256 i = 0; i < numMintedSoFar; i++) {
1433       TokenOwnership memory ownership = _ownerships[i];
1434       if (ownership.addr != address(0)) {
1435         currOwnershipAddr = ownership.addr;
1436       }
1437       if (currOwnershipAddr == owner) {
1438         if (tokenIdsIdx == index) {
1439           return i;
1440         }
1441         tokenIdsIdx++;
1442       }
1443     }
1444     revert("ERC721A: unable to get token of owner by index");
1445   }
1446 
1447   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool){
1448     return interfaceId == type(IERC721).interfaceId ||
1449       interfaceId == type(IERC721Metadata).interfaceId ||
1450       interfaceId == type(IERC721Enumerable).interfaceId ||
1451       interfaceId == type(IERC165).interfaceId;
1452   }
1453 
1454   function balanceOf(address owner) public view override returns (uint256) {
1455     require(owner != address(0), "ERC721A: balance query for the zero address");
1456     return uint256(_addressData[owner].balance);
1457   }
1458 
1459   function numberMinted(address owner) external view returns (uint256) {
1460     require(owner != address(0), "ERC721A: number minted query for the zero address");
1461     return uint256(_addressData[owner].numberMinted);
1462   }
1463 
1464   function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory){
1465     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1466     uint256 lowestTokenToCheck;
1467     if (tokenId >= maxBatchSize) {
1468       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1469     }
1470     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1471       TokenOwnership memory ownership = _ownerships[curr];
1472       if (ownership.addr != address(0)) {
1473         return ownership;
1474       }
1475     }
1476     revert("ERC721A: unable to determine the owner of token");
1477   }
1478   
1479   function ownerOf(uint256 tokenId) public view override returns (address) {
1480     return ownershipOf(tokenId).addr;
1481   }
1482 
1483   function name() public view virtual override returns (string memory) {
1484     return _name;
1485   }
1486 
1487   function symbol() public view virtual override returns (string memory) {
1488     return _symbol;
1489   }
1490 
1491   function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
1492     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1493     return _boxOffset < 10000 ? string(abi.encodePacked(_tokenUri, Strings.toString((tokenId+_boxOffset) % 10000))) : _boxUri;
1494   }
1495   
1496   function approve(address to, uint256 tokenId) public override {
1497     address owner = ownerOf(tokenId);
1498     require(to != owner, "ERC721A: approval to current owner");
1499     require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721A: approve caller is not owner nor approved for all");
1500     _approve(to, tokenId, owner);
1501   }
1502 
1503   function getApproved(uint256 tokenId) public view override returns (address) {
1504     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1505     return _tokenApprovals[tokenId];
1506   }
1507 
1508   function setApprovalForAll(address operator, bool approved) public override {
1509     require(operator != _msgSender(), "ERC721A: approve to caller");
1510     _operatorApprovals[_msgSender()][operator] = approved;
1511     emit ApprovalForAll(_msgSender(), operator, approved);
1512   }
1513 
1514   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool){
1515     return _operatorApprovals[owner][operator];
1516   }
1517 
1518   function transferFrom(address from, address to, uint256 tokenId) public override {
1519     _transfer(from, to, tokenId);
1520   }
1521 
1522   function safeTransferFrom(address from, address to, uint256 tokenId) public override {
1523     safeTransferFrom(from, to, tokenId, "");
1524   }
1525 
1526   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
1527     _transfer(from, to, tokenId);
1528     require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721A: transfer to non ERC721Receiver implementer");
1529   }
1530 
1531   function _exists(uint256 tokenId) internal view returns (bool) {
1532     return tokenId < currentIndex;
1533   }
1534 
1535   function _safeMint(address to, uint256 quantity) internal {
1536     _safeMint(to, quantity, "");
1537   }
1538 
1539   function _safeMint(address to, uint256 quantity, bytes memory _data) internal {
1540     require(quantity + currentIndex <= 10000, "NFT: maxTotalSupply");
1541     uint256 startTokenId = currentIndex;
1542     require(to != address(0), "ERC721A: mint to the zero address");
1543     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1544     require(!_exists(startTokenId), "ERC721A: token already minted");
1545     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1546     AddressData memory addressData = _addressData[to];
1547     _addressData[to] = AddressData(
1548       addressData.balance + uint128(quantity),
1549       addressData.numberMinted + uint128(quantity)
1550     );
1551     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1552     uint256 updatedIndex = startTokenId;
1553     for (uint256 i = 0; i < quantity; i++) {
1554       emit Transfer(address(0), to, updatedIndex);
1555       require(_checkOnERC721Received(address(0), to, updatedIndex, _data), "ERC721A: transfer to non ERC721Receiver implementer");
1556       updatedIndex++;
1557     }
1558     currentIndex = updatedIndex;
1559   }
1560 
1561   function _transfer(address from, address to, uint256 tokenId) private {
1562     if(nest != address(0)){
1563       require(INEST(nest).nestingTransfer(tokenId), "NFT:nesting limit");  
1564     }
1565     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1566     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr || getApproved(tokenId) == _msgSender() || isApprovedForAll(prevOwnership.addr, _msgSender()));
1567     require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1568     require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1569     require(to != address(0), "ERC721A: transfer to the zero address");
1570     // Clear approvals from the previous owner
1571     _approve(address(0), tokenId, prevOwnership.addr);
1572     _addressData[from].balance -= 1;
1573     _addressData[to].balance += 1;
1574     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1575     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1576     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1577     uint256 nextTokenId = tokenId + 1;
1578     if (_ownerships[nextTokenId].addr == address(0)) {
1579       if (_exists(nextTokenId)) {
1580         _ownerships[nextTokenId] = TokenOwnership(
1581           prevOwnership.addr,
1582           prevOwnership.startTimestamp
1583         );
1584       }
1585     }
1586     emit Transfer(from, to, tokenId);
1587   }
1588 
1589   function _approve(address to, uint256 tokenId, address owner) private {
1590     _tokenApprovals[tokenId] = to;
1591     emit Approval(owner, to, tokenId);
1592   }
1593   
1594   function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
1595     if (to.code.length > 0) {
1596       try
1597         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1598       returns (bytes4 retval) {
1599         return retval == IERC721Receiver(to).onERC721Received.selector;
1600       } catch (bytes memory reason) {
1601         if (reason.length == 0) {
1602           revert("ERC721A: transfer to non ERC721Receiver implementer");
1603         } else {
1604           assembly {
1605             revert(add(32, reason), mload(reason))
1606           }
1607         }
1608       }
1609     } else {
1610       return true;
1611     }
1612   }
1613   
1614   modifier allowOpen(){
1615       require(_boxOffset >= maxTotalSupply && totalSupply() >= maxTotalSupply, "Cat:not sold out or is open");
1616       _;
1617   }
1618   
1619   function fulfillRandomWords(uint256, uint256[] memory randomWords) internal override allowOpen{
1620       _boxOffset = randomWords[0] % maxTotalSupply;
1621   }
1622     
1623   function openBox() external allowOpen onlyOwner {
1624       require(_boxOffset >= maxTotalSupply && totalSupply() == maxTotalSupply, "Cat:not sold out or is open");
1625       VRFCoordinatorV2Interface(0x271682DEB8C4E0901D1a1550aD2e64D568E69909).requestRandomWords(0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef,411,3,300000,1);
1626   }
1627   
1628   function openBox2() external allowOpen onlyOwner {
1629       _boxOffset = uint256(blockhash(block.number - 1)) % maxTotalSupply;
1630   }
1631   
1632   function setTokenUri(string memory tokenUri_) external onlyOwner{
1633       _tokenUri = tokenUri_;
1634   }
1635   
1636   function setBoxUri(string memory boxUri_) external onlyOwner{
1637       _boxUri = boxUri_;
1638   }
1639   
1640   function lengthOfSupportedBcn() external override view returns(uint256 length){
1641         return _supportedBcns.length();
1642     }
1643     
1644     function supportedBcnByIndex(uint256 index) external override view returns(address bcn){
1645         return _supportedBcns.at(index);
1646     }
1647     
1648     function mintNumberOfBcn(address bcn) external override view returns(uint256 total, uint256 remaining){
1649         return (_supplyOfBcn[bcn], _remaingOfBcn[bcn]);
1650     }
1651     
1652     function isBcnSupported(address bcn) external override view returns(bool supported){
1653         return _supportedBcns.contains(bcn);
1654     }
1655     
1656     function isTokenMintByBcn(address bcn, uint256 bcnTokenId) external override view returns(bool used){
1657         used = _isTokenMintByBcn[bcn][bcnTokenId];
1658     }
1659     
1660     function mintByBcn(uint256 tokenId, address bcn, uint256 bcnTokenId) external override{
1661         require(block.timestamp > uint256(_startTimes[2]), "Cat:not open");
1662         address to = IERC721(bcn).ownerOf(bcnTokenId);
1663         require(to != address(0), "ERC721W:bcnTokenId not exists");
1664         require(!_isTokenMintByBcn[bcn][bcnTokenId], "ERC721W:bcnTokenId is used");
1665         require(_supportedBcns.contains(bcn), "ERC721W:not supported bcn");
1666         _isTokenMintByBcn[bcn][bcnTokenId] = true;
1667         _remaingOfBcn[bcn]--;
1668         emit MintByBCN(totalSupply(), to, bcn, bcnTokenId);
1669         _safeMint(to, 1);
1670     }
1671     
1672     function batchAddBcn(address[] memory bcns, uint256[] memory quantities) external onlyOwner{
1673         for(uint256 i = 0; i < bcns.length; i++){
1674             address bcn = bcns[i];
1675             uint256 quantity = quantities[i];
1676             _supportedBcns.add(bcn);
1677             _supplyOfBcn[bcn] += quantity;
1678             _remaingOfBcn[bcn] += quantity;
1679         }
1680     }
1681     
1682     function enableBcn(address bcn, bool enable) external onlyOwner{
1683         if(enable){
1684             require(_supportedBcns.add(bcn), "ERC721W:alread enable");
1685         }else{
1686             require(_supportedBcns.remove(bcn), "ERC721W:alread disable");
1687         }
1688     }
1689     
1690     function setBcn(address bcn, uint256 quantity, bool minus) external onlyOwner{
1691         if(minus){
1692             _supplyOfBcn[bcn] -= quantity;
1693             _remaingOfBcn[bcn] -= quantity;
1694         }else{
1695             _supplyOfBcn[bcn] += quantity;
1696             _remaingOfBcn[bcn] += quantity;
1697         }
1698     }
1699     
1700     function mintByWhitelist(uint256 quantity, uint8 v, bytes32 r, bytes32 s) external {
1701         address to = _msgSender();
1702         require(block.timestamp > uint256(_startTimes[0]), "Cat:not open");
1703         bytes32 hash = keccak256(abi.encodePacked(block.chainid, address(this), "whitelist", to, quantity));
1704         require(signer == ECDSA.recover(hash, v, r, s), "Cat:sign error");
1705         require(!whitelistMinted[to], "Cat:minted");
1706         whitelistMinted[to] = true;
1707         _safeMint(to, quantity);
1708     }
1709     
1710     function mintByWinner(uint256 quantity, uint8 v, bytes32 r, bytes32 s) external {
1711         address to = _msgSender();
1712         require(block.timestamp > uint256(_startTimes[1]), "Cat:not open");
1713         bytes32 hash = keccak256(abi.encodePacked(block.chainid, address(this), "winner", to, quantity));
1714         require(signer == ecrecover(hash, v, r, s), "Cat:sign error");
1715         require(!winnerMinted[to], "Cat:minted");
1716         winnerMinted[to] = true;
1717         _safeMint(to, quantity);
1718     }
1719     
1720     function getBcnInfo() external view returns(address[] memory bcns, uint256[] memory totals, uint256[] memory remainings){
1721         uint256 len = _supportedBcns.length();
1722         bcns = new address[](len);
1723         totals = new uint256[](len);
1724         remainings = new uint256[](len);
1725         for(uint256 i = 0; i < len; i++){
1726             address bcn = _supportedBcns.at(i);
1727             bcns[i] = bcn;
1728             totals[i] = _supplyOfBcn[bcn];
1729             remainings[i] = _remaingOfBcn[bcn];
1730         }
1731     }
1732     
1733     function getStartTimes() external view returns(uint256[] memory){
1734         return _startTimes;
1735     }
1736     
1737     function setStartTimes(uint256[] memory startTimes) external onlyOwner{
1738         require(startTimes.length == 3, "NFT: array length error");
1739         _startTimes = startTimes;
1740     }
1741     
1742     function setSigner(address _signer) external onlyOwner{
1743         signer = _signer;
1744     }
1745     
1746     function setNest(address _nest) external onlyOwner{
1747         nest = _nest;
1748     }
1749 }