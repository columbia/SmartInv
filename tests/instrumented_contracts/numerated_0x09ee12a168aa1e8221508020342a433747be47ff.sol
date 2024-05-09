1 // File: @chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 /** ****************************************************************************
7  * @notice Interface for contracts using VRF randomness
8  * *****************************************************************************
9  * @dev PURPOSE
10  *
11  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
12  * @dev to Vera the verifier in such a way that Vera can be sure he's not
13  * @dev making his output up to suit himself. Reggie provides Vera a public key
14  * @dev to which he knows the secret key. Each time Vera provides a seed to
15  * @dev Reggie, he gives back a value which is computed completely
16  * @dev deterministically from the seed and the secret key.
17  *
18  * @dev Reggie provides a proof by which Vera can verify that the output was
19  * @dev correctly computed once Reggie tells it to her, but without that proof,
20  * @dev the output is indistinguishable to her from a uniform random sample
21  * @dev from the output space.
22  *
23  * @dev The purpose of this contract is to make it easy for unrelated contracts
24  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
25  * @dev simple access to a verifiable source of randomness. It ensures 2 things:
26  * @dev 1. The fulfillment came from the VRFCoordinator
27  * @dev 2. The consumer contract implements fulfillRandomWords.
28  * *****************************************************************************
29  * @dev USAGE
30  *
31  * @dev Calling contracts must inherit from VRFConsumerBase, and can
32  * @dev initialize VRFConsumerBase's attributes in their constructor as
33  * @dev shown:
34  *
35  * @dev   contract VRFConsumer {
36  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
37  * @dev       VRFConsumerBase(_vrfCoordinator) public {
38  * @dev         <initialization with other arguments goes here>
39  * @dev       }
40  * @dev   }
41  *
42  * @dev The oracle will have given you an ID for the VRF keypair they have
43  * @dev committed to (let's call it keyHash). Create subscription, fund it
44  * @dev and your consumer contract as a consumer of it (see VRFCoordinatorInterface
45  * @dev subscription management functions).
46  * @dev Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
47  * @dev callbackGasLimit, numWords),
48  * @dev see (VRFCoordinatorInterface for a description of the arguments).
49  *
50  * @dev Once the VRFCoordinator has received and validated the oracle's response
51  * @dev to your request, it will call your contract's fulfillRandomWords method.
52  *
53  * @dev The randomness argument to fulfillRandomWords is a set of random words
54  * @dev generated from your requestId and the blockHash of the request.
55  *
56  * @dev If your contract could have concurrent requests open, you can use the
57  * @dev requestId returned from requestRandomWords to track which response is associated
58  * @dev with which randomness request.
59  * @dev See "SECURITY CONSIDERATIONS" for principles to keep in mind,
60  * @dev if your contract could have multiple requests in flight simultaneously.
61  *
62  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
63  * @dev differ.
64  *
65  * *****************************************************************************
66  * @dev SECURITY CONSIDERATIONS
67  *
68  * @dev A method with the ability to call your fulfillRandomness method directly
69  * @dev could spoof a VRF response with any random value, so it's critical that
70  * @dev it cannot be directly called by anything other than this base contract
71  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
72  *
73  * @dev For your users to trust that your contract's random behavior is free
74  * @dev from malicious interference, it's best if you can write it so that all
75  * @dev behaviors implied by a VRF response are executed *during* your
76  * @dev fulfillRandomness method. If your contract must store the response (or
77  * @dev anything derived from it) and use it later, you must ensure that any
78  * @dev user-significant behavior which depends on that stored value cannot be
79  * @dev manipulated by a subsequent VRF request.
80  *
81  * @dev Similarly, both miners and the VRF oracle itself have some influence
82  * @dev over the order in which VRF responses appear on the blockchain, so if
83  * @dev your contract could have multiple VRF requests in flight simultaneously,
84  * @dev you must ensure that the order in which the VRF responses arrive cannot
85  * @dev be used to manipulate your contract's user-significant behavior.
86  *
87  * @dev Since the block hash of the block which contains the requestRandomness
88  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
89  * @dev miner could, in principle, fork the blockchain to evict the block
90  * @dev containing the request, forcing the request to be included in a
91  * @dev different block with a different hash, and therefore a different input
92  * @dev to the VRF. However, such an attack would incur a substantial economic
93  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
94  * @dev until it calls responds to a request. It is for this reason that
95  * @dev that you can signal to an oracle you'd like them to wait longer before
96  * @dev responding to the request (however this is not enforced in the contract
97  * @dev and so remains effective only in the case of unmodified oracle software).
98  */
99 abstract contract VRFConsumerBaseV2 {
100   error OnlyCoordinatorCanFulfill(address have, address want);
101   address private immutable vrfCoordinator;
102 
103   /**
104    * @param _vrfCoordinator address of VRFCoordinator contract
105    */
106   constructor(address _vrfCoordinator) {
107     vrfCoordinator = _vrfCoordinator;
108   }
109 
110   /**
111    * @notice fulfillRandomness handles the VRF response. Your contract must
112    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
113    * @notice principles to keep in mind when implementing your fulfillRandomness
114    * @notice method.
115    *
116    * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
117    * @dev signature, and will call it once it has verified the proof
118    * @dev associated with the randomness. (It is triggered via a call to
119    * @dev rawFulfillRandomness, below.)
120    *
121    * @param requestId The Id initially returned by requestRandomness
122    * @param randomWords the VRF output expanded to the requested number of words
123    */
124   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;
125 
126   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
127   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
128   // the origin of the call
129   function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
130     if (msg.sender != vrfCoordinator) {
131       revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
132     }
133     fulfillRandomWords(requestId, randomWords);
134   }
135 }
136 
137 // File: @chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol
138 
139 
140 pragma solidity ^0.8.0;
141 
142 interface VRFCoordinatorV2Interface {
143   /**
144    * @notice Get configuration relevant for making requests
145    * @return minimumRequestConfirmations global min for request confirmations
146    * @return maxGasLimit global max for request gas limit
147    * @return s_provingKeyHashes list of registered key hashes
148    */
149   function getRequestConfig()
150     external
151     view
152     returns (
153       uint16,
154       uint32,
155       bytes32[] memory
156     );
157 
158   /**
159    * @notice Request a set of random words.
160    * @param keyHash - Corresponds to a particular oracle job which uses
161    * that key for generating the VRF proof. Different keyHash's have different gas price
162    * ceilings, so you can select a specific one to bound your maximum per request cost.
163    * @param subId  - The ID of the VRF subscription. Must be funded
164    * with the minimum subscription balance required for the selected keyHash.
165    * @param minimumRequestConfirmations - How many blocks you'd like the
166    * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
167    * for why you may want to request more. The acceptable range is
168    * [minimumRequestBlockConfirmations, 200].
169    * @param callbackGasLimit - How much gas you'd like to receive in your
170    * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
171    * may be slightly less than this amount because of gas used calling the function
172    * (argument decoding etc.), so you may need to request slightly more than you expect
173    * to have inside fulfillRandomWords. The acceptable range is
174    * [0, maxGasLimit]
175    * @param numWords - The number of uint256 random values you'd like to receive
176    * in your fulfillRandomWords callback. Note these numbers are expanded in a
177    * secure way by the VRFCoordinator from a single random value supplied by the oracle.
178    * @return requestId - A unique identifier of the request. Can be used to match
179    * a request to a response in fulfillRandomWords.
180    */
181   function requestRandomWords(
182     bytes32 keyHash,
183     uint64 subId,
184     uint16 minimumRequestConfirmations,
185     uint32 callbackGasLimit,
186     uint32 numWords
187   ) external returns (uint256 requestId);
188 
189   /**
190    * @notice Create a VRF subscription.
191    * @return subId - A unique subscription id.
192    * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
193    * @dev Note to fund the subscription, use transferAndCall. For example
194    * @dev  LINKTOKEN.transferAndCall(
195    * @dev    address(COORDINATOR),
196    * @dev    amount,
197    * @dev    abi.encode(subId));
198    */
199   function createSubscription() external returns (uint64 subId);
200 
201   /**
202    * @notice Get a VRF subscription.
203    * @param subId - ID of the subscription
204    * @return balance - LINK balance of the subscription in juels.
205    * @return reqCount - number of requests for this subscription, determines fee tier.
206    * @return owner - owner of the subscription.
207    * @return consumers - list of consumer address which are able to use this subscription.
208    */
209   function getSubscription(uint64 subId)
210     external
211     view
212     returns (
213       uint96 balance,
214       uint64 reqCount,
215       address owner,
216       address[] memory consumers
217     );
218 
219   /**
220    * @notice Request subscription owner transfer.
221    * @param subId - ID of the subscription
222    * @param newOwner - proposed new owner of the subscription
223    */
224   function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;
225 
226   /**
227    * @notice Request subscription owner transfer.
228    * @param subId - ID of the subscription
229    * @dev will revert if original owner of subId has
230    * not requested that msg.sender become the new owner.
231    */
232   function acceptSubscriptionOwnerTransfer(uint64 subId) external;
233 
234   /**
235    * @notice Add a consumer to a VRF subscription.
236    * @param subId - ID of the subscription
237    * @param consumer - New consumer which can use the subscription
238    */
239   function addConsumer(uint64 subId, address consumer) external;
240 
241   /**
242    * @notice Remove a consumer from a VRF subscription.
243    * @param subId - ID of the subscription
244    * @param consumer - Consumer to remove from the subscription
245    */
246   function removeConsumer(uint64 subId, address consumer) external;
247 
248   /**
249    * @notice Cancel a subscription
250    * @param subId - ID of the subscription
251    * @param to - Where to send the remaining LINK to
252    */
253   function cancelSubscription(uint64 subId, address to) external;
254 
255   /*
256    * @notice Check to see if there exists a request commitment consumers
257    * for all consumers and keyhashes for a given sub.
258    * @param subId - ID of the subscription
259    * @return true if there exists at least one unfulfilled request for the subscription, false
260    * otherwise.
261    */
262   function pendingRequestExists(uint64 subId) external view returns (bool);
263 }
264 
265 // File: operator-filter-registry/src/lib/Constants.sol
266 
267 
268 pragma solidity ^0.8.13;
269 
270 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
271 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
272 
273 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
274 
275 
276 pragma solidity ^0.8.13;
277 
278 interface IOperatorFilterRegistry {
279     /**
280      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
281      *         true if supplied registrant address is not registered.
282      */
283     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
284 
285     /**
286      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
287      */
288     function register(address registrant) external;
289 
290     /**
291      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
292      */
293     function registerAndSubscribe(address registrant, address subscription) external;
294 
295     /**
296      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
297      *         address without subscribing.
298      */
299     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
300 
301     /**
302      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
303      *         Note that this does not remove any filtered addresses or codeHashes.
304      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
305      */
306     function unregister(address addr) external;
307 
308     /**
309      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
310      */
311     function updateOperator(address registrant, address operator, bool filtered) external;
312 
313     /**
314      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
315      */
316     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
317 
318     /**
319      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
320      */
321     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
322 
323     /**
324      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
325      */
326     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
327 
328     /**
329      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
330      *         subscription if present.
331      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
332      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
333      *         used.
334      */
335     function subscribe(address registrant, address registrantToSubscribe) external;
336 
337     /**
338      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
339      */
340     function unsubscribe(address registrant, bool copyExistingEntries) external;
341 
342     /**
343      * @notice Get the subscription address of a given registrant, if any.
344      */
345     function subscriptionOf(address addr) external returns (address registrant);
346 
347     /**
348      * @notice Get the set of addresses subscribed to a given registrant.
349      *         Note that order is not guaranteed as updates are made.
350      */
351     function subscribers(address registrant) external returns (address[] memory);
352 
353     /**
354      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
355      *         Note that order is not guaranteed as updates are made.
356      */
357     function subscriberAt(address registrant, uint256 index) external returns (address);
358 
359     /**
360      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
361      */
362     function copyEntriesOf(address registrant, address registrantToCopy) external;
363 
364     /**
365      * @notice Returns true if operator is filtered by a given address or its subscription.
366      */
367     function isOperatorFiltered(address registrant, address operator) external returns (bool);
368 
369     /**
370      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
371      */
372     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
373 
374     /**
375      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
376      */
377     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
378 
379     /**
380      * @notice Returns a list of filtered operators for a given address or its subscription.
381      */
382     function filteredOperators(address addr) external returns (address[] memory);
383 
384     /**
385      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
386      *         Note that order is not guaranteed as updates are made.
387      */
388     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
389 
390     /**
391      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
392      *         its subscription.
393      *         Note that order is not guaranteed as updates are made.
394      */
395     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
396 
397     /**
398      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
399      *         its subscription.
400      *         Note that order is not guaranteed as updates are made.
401      */
402     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
403 
404     /**
405      * @notice Returns true if an address has registered
406      */
407     function isRegistered(address addr) external returns (bool);
408 
409     /**
410      * @dev Convenience method to compute the code hash of an arbitrary contract
411      */
412     function codeHashOf(address addr) external returns (bytes32);
413 }
414 
415 // File: operator-filter-registry/src/OperatorFilterer.sol
416 
417 
418 pragma solidity ^0.8.13;
419 
420 
421 /**
422  * @title  OperatorFilterer
423  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
424  *         registrant's entries in the OperatorFilterRegistry.
425  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
426  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
427  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
428  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
429  *         administration methods on the contract itself to interact with the registry otherwise the subscription
430  *         will be locked to the options set during construction.
431  */
432 
433 abstract contract OperatorFilterer {
434     /// @dev Emitted when an operator is not allowed.
435     error OperatorNotAllowed(address operator);
436 
437     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
438         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
439 
440     /// @dev The constructor that is called when the contract is being deployed.
441     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
442         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
443         // will not revert, but the contract will need to be registered with the registry once it is deployed in
444         // order for the modifier to filter addresses.
445         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
446             if (subscribe) {
447                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
448             } else {
449                 if (subscriptionOrRegistrantToCopy != address(0)) {
450                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
451                 } else {
452                     OPERATOR_FILTER_REGISTRY.register(address(this));
453                 }
454             }
455         }
456     }
457 
458     /**
459      * @dev A helper function to check if an operator is allowed.
460      */
461     modifier onlyAllowedOperator(address from) virtual {
462         // Allow spending tokens from addresses with balance
463         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
464         // from an EOA.
465         if (from != msg.sender) {
466             _checkFilterOperator(msg.sender);
467         }
468         _;
469     }
470 
471     /**
472      * @dev A helper function to check if an operator approval is allowed.
473      */
474     modifier onlyAllowedOperatorApproval(address operator) virtual {
475         _checkFilterOperator(operator);
476         _;
477     }
478 
479     /**
480      * @dev A helper function to check if an operator is allowed.
481      */
482     function _checkFilterOperator(address operator) internal view virtual {
483         // Check registry code length to facilitate testing in environments without a deployed registry.
484         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
485             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
486             // may specify their own OperatorFilterRegistry implementations, which may behave differently
487             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
488                 revert OperatorNotAllowed(operator);
489             }
490         }
491     }
492 }
493 
494 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
495 
496 
497 pragma solidity ^0.8.13;
498 
499 
500 /**
501  * @title  DefaultOperatorFilterer
502  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
503  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
504  *         administration methods on the contract itself to interact with the registry otherwise the subscription
505  *         will be locked to the options set during construction.
506  */
507 
508 abstract contract DefaultOperatorFilterer is OperatorFilterer {
509     /// @dev The constructor that is called when the contract is being deployed.
510     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
511 }
512 
513 // File: @openzeppelin/contracts/utils/math/Math.sol
514 
515 
516 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Standard math utilities missing in the Solidity language.
522  */
523 library Math {
524     enum Rounding {
525         Down, // Toward negative infinity
526         Up, // Toward infinity
527         Zero // Toward zero
528     }
529 
530     /**
531      * @dev Returns the largest of two numbers.
532      */
533     function max(uint256 a, uint256 b) internal pure returns (uint256) {
534         return a > b ? a : b;
535     }
536 
537     /**
538      * @dev Returns the smallest of two numbers.
539      */
540     function min(uint256 a, uint256 b) internal pure returns (uint256) {
541         return a < b ? a : b;
542     }
543 
544     /**
545      * @dev Returns the average of two numbers. The result is rounded towards
546      * zero.
547      */
548     function average(uint256 a, uint256 b) internal pure returns (uint256) {
549         // (a + b) / 2 can overflow.
550         return (a & b) + (a ^ b) / 2;
551     }
552 
553     /**
554      * @dev Returns the ceiling of the division of two numbers.
555      *
556      * This differs from standard division with `/` in that it rounds up instead
557      * of rounding down.
558      */
559     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
560         // (a + b - 1) / b can overflow on addition, so we distribute.
561         return a == 0 ? 0 : (a - 1) / b + 1;
562     }
563 
564     /**
565      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
566      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
567      * with further edits by Uniswap Labs also under MIT license.
568      */
569     function mulDiv(
570         uint256 x,
571         uint256 y,
572         uint256 denominator
573     ) internal pure returns (uint256 result) {
574         unchecked {
575             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
576             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
577             // variables such that product = prod1 * 2^256 + prod0.
578             uint256 prod0; // Least significant 256 bits of the product
579             uint256 prod1; // Most significant 256 bits of the product
580             assembly {
581                 let mm := mulmod(x, y, not(0))
582                 prod0 := mul(x, y)
583                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
584             }
585 
586             // Handle non-overflow cases, 256 by 256 division.
587             if (prod1 == 0) {
588                 return prod0 / denominator;
589             }
590 
591             // Make sure the result is less than 2^256. Also prevents denominator == 0.
592             require(denominator > prod1);
593 
594             ///////////////////////////////////////////////
595             // 512 by 256 division.
596             ///////////////////////////////////////////////
597 
598             // Make division exact by subtracting the remainder from [prod1 prod0].
599             uint256 remainder;
600             assembly {
601                 // Compute remainder using mulmod.
602                 remainder := mulmod(x, y, denominator)
603 
604                 // Subtract 256 bit number from 512 bit number.
605                 prod1 := sub(prod1, gt(remainder, prod0))
606                 prod0 := sub(prod0, remainder)
607             }
608 
609             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
610             // See https://cs.stackexchange.com/q/138556/92363.
611 
612             // Does not overflow because the denominator cannot be zero at this stage in the function.
613             uint256 twos = denominator & (~denominator + 1);
614             assembly {
615                 // Divide denominator by twos.
616                 denominator := div(denominator, twos)
617 
618                 // Divide [prod1 prod0] by twos.
619                 prod0 := div(prod0, twos)
620 
621                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
622                 twos := add(div(sub(0, twos), twos), 1)
623             }
624 
625             // Shift in bits from prod1 into prod0.
626             prod0 |= prod1 * twos;
627 
628             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
629             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
630             // four bits. That is, denominator * inv = 1 mod 2^4.
631             uint256 inverse = (3 * denominator) ^ 2;
632 
633             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
634             // in modular arithmetic, doubling the correct bits in each step.
635             inverse *= 2 - denominator * inverse; // inverse mod 2^8
636             inverse *= 2 - denominator * inverse; // inverse mod 2^16
637             inverse *= 2 - denominator * inverse; // inverse mod 2^32
638             inverse *= 2 - denominator * inverse; // inverse mod 2^64
639             inverse *= 2 - denominator * inverse; // inverse mod 2^128
640             inverse *= 2 - denominator * inverse; // inverse mod 2^256
641 
642             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
643             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
644             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
645             // is no longer required.
646             result = prod0 * inverse;
647             return result;
648         }
649     }
650 
651     /**
652      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
653      */
654     function mulDiv(
655         uint256 x,
656         uint256 y,
657         uint256 denominator,
658         Rounding rounding
659     ) internal pure returns (uint256) {
660         uint256 result = mulDiv(x, y, denominator);
661         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
662             result += 1;
663         }
664         return result;
665     }
666 
667     /**
668      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
669      *
670      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
671      */
672     function sqrt(uint256 a) internal pure returns (uint256) {
673         if (a == 0) {
674             return 0;
675         }
676 
677         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
678         //
679         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
680         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
681         //
682         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
683         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
684         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
685         //
686         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
687         uint256 result = 1 << (log2(a) >> 1);
688 
689         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
690         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
691         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
692         // into the expected uint128 result.
693         unchecked {
694             result = (result + a / result) >> 1;
695             result = (result + a / result) >> 1;
696             result = (result + a / result) >> 1;
697             result = (result + a / result) >> 1;
698             result = (result + a / result) >> 1;
699             result = (result + a / result) >> 1;
700             result = (result + a / result) >> 1;
701             return min(result, a / result);
702         }
703     }
704 
705     /**
706      * @notice Calculates sqrt(a), following the selected rounding direction.
707      */
708     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
709         unchecked {
710             uint256 result = sqrt(a);
711             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
712         }
713     }
714 
715     /**
716      * @dev Return the log in base 2, rounded down, of a positive value.
717      * Returns 0 if given 0.
718      */
719     function log2(uint256 value) internal pure returns (uint256) {
720         uint256 result = 0;
721         unchecked {
722             if (value >> 128 > 0) {
723                 value >>= 128;
724                 result += 128;
725             }
726             if (value >> 64 > 0) {
727                 value >>= 64;
728                 result += 64;
729             }
730             if (value >> 32 > 0) {
731                 value >>= 32;
732                 result += 32;
733             }
734             if (value >> 16 > 0) {
735                 value >>= 16;
736                 result += 16;
737             }
738             if (value >> 8 > 0) {
739                 value >>= 8;
740                 result += 8;
741             }
742             if (value >> 4 > 0) {
743                 value >>= 4;
744                 result += 4;
745             }
746             if (value >> 2 > 0) {
747                 value >>= 2;
748                 result += 2;
749             }
750             if (value >> 1 > 0) {
751                 result += 1;
752             }
753         }
754         return result;
755     }
756 
757     /**
758      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
759      * Returns 0 if given 0.
760      */
761     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
762         unchecked {
763             uint256 result = log2(value);
764             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
765         }
766     }
767 
768     /**
769      * @dev Return the log in base 10, rounded down, of a positive value.
770      * Returns 0 if given 0.
771      */
772     function log10(uint256 value) internal pure returns (uint256) {
773         uint256 result = 0;
774         unchecked {
775             if (value >= 10**64) {
776                 value /= 10**64;
777                 result += 64;
778             }
779             if (value >= 10**32) {
780                 value /= 10**32;
781                 result += 32;
782             }
783             if (value >= 10**16) {
784                 value /= 10**16;
785                 result += 16;
786             }
787             if (value >= 10**8) {
788                 value /= 10**8;
789                 result += 8;
790             }
791             if (value >= 10**4) {
792                 value /= 10**4;
793                 result += 4;
794             }
795             if (value >= 10**2) {
796                 value /= 10**2;
797                 result += 2;
798             }
799             if (value >= 10**1) {
800                 result += 1;
801             }
802         }
803         return result;
804     }
805 
806     /**
807      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
808      * Returns 0 if given 0.
809      */
810     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
811         unchecked {
812             uint256 result = log10(value);
813             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
814         }
815     }
816 
817     /**
818      * @dev Return the log in base 256, rounded down, of a positive value.
819      * Returns 0 if given 0.
820      *
821      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
822      */
823     function log256(uint256 value) internal pure returns (uint256) {
824         uint256 result = 0;
825         unchecked {
826             if (value >> 128 > 0) {
827                 value >>= 128;
828                 result += 16;
829             }
830             if (value >> 64 > 0) {
831                 value >>= 64;
832                 result += 8;
833             }
834             if (value >> 32 > 0) {
835                 value >>= 32;
836                 result += 4;
837             }
838             if (value >> 16 > 0) {
839                 value >>= 16;
840                 result += 2;
841             }
842             if (value >> 8 > 0) {
843                 result += 1;
844             }
845         }
846         return result;
847     }
848 
849     /**
850      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
851      * Returns 0 if given 0.
852      */
853     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
854         unchecked {
855             uint256 result = log256(value);
856             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
857         }
858     }
859 }
860 
861 // File: @openzeppelin/contracts/utils/Strings.sol
862 
863 
864 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
865 
866 pragma solidity ^0.8.0;
867 
868 
869 /**
870  * @dev String operations.
871  */
872 library Strings {
873     bytes16 private constant _SYMBOLS = "0123456789abcdef";
874     uint8 private constant _ADDRESS_LENGTH = 20;
875 
876     /**
877      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
878      */
879     function toString(uint256 value) internal pure returns (string memory) {
880         unchecked {
881             uint256 length = Math.log10(value) + 1;
882             string memory buffer = new string(length);
883             uint256 ptr;
884             /// @solidity memory-safe-assembly
885             assembly {
886                 ptr := add(buffer, add(32, length))
887             }
888             while (true) {
889                 ptr--;
890                 /// @solidity memory-safe-assembly
891                 assembly {
892                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
893                 }
894                 value /= 10;
895                 if (value == 0) break;
896             }
897             return buffer;
898         }
899     }
900 
901     /**
902      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
903      */
904     function toHexString(uint256 value) internal pure returns (string memory) {
905         unchecked {
906             return toHexString(value, Math.log256(value) + 1);
907         }
908     }
909 
910     /**
911      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
912      */
913     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
914         bytes memory buffer = new bytes(2 * length + 2);
915         buffer[0] = "0";
916         buffer[1] = "x";
917         for (uint256 i = 2 * length + 1; i > 1; --i) {
918             buffer[i] = _SYMBOLS[value & 0xf];
919             value >>= 4;
920         }
921         require(value == 0, "Strings: hex length insufficient");
922         return string(buffer);
923     }
924 
925     /**
926      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
927      */
928     function toHexString(address addr) internal pure returns (string memory) {
929         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
930     }
931 }
932 
933 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
934 
935 
936 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
937 
938 pragma solidity ^0.8.0;
939 
940 /**
941  * @dev Contract module that helps prevent reentrant calls to a function.
942  *
943  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
944  * available, which can be applied to functions to make sure there are no nested
945  * (reentrant) calls to them.
946  *
947  * Note that because there is a single `nonReentrant` guard, functions marked as
948  * `nonReentrant` may not call one another. This can be worked around by making
949  * those functions `private`, and then adding `external` `nonReentrant` entry
950  * points to them.
951  *
952  * TIP: If you would like to learn more about reentrancy and alternative ways
953  * to protect against it, check out our blog post
954  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
955  */
956 abstract contract ReentrancyGuard {
957     // Booleans are more expensive than uint256 or any type that takes up a full
958     // word because each write operation emits an extra SLOAD to first read the
959     // slot's contents, replace the bits taken up by the boolean, and then write
960     // back. This is the compiler's defense against contract upgrades and
961     // pointer aliasing, and it cannot be disabled.
962 
963     // The values being non-zero value makes deployment a bit more expensive,
964     // but in exchange the refund on every call to nonReentrant will be lower in
965     // amount. Since refunds are capped to a percentage of the total
966     // transaction's gas, it is best to keep them low in cases like this one, to
967     // increase the likelihood of the full refund coming into effect.
968     uint256 private constant _NOT_ENTERED = 1;
969     uint256 private constant _ENTERED = 2;
970 
971     uint256 private _status;
972 
973     constructor() {
974         _status = _NOT_ENTERED;
975     }
976 
977     /**
978      * @dev Prevents a contract from calling itself, directly or indirectly.
979      * Calling a `nonReentrant` function from another `nonReentrant`
980      * function is not supported. It is possible to prevent this from happening
981      * by making the `nonReentrant` function external, and making it call a
982      * `private` function that does the actual work.
983      */
984     modifier nonReentrant() {
985         _nonReentrantBefore();
986         _;
987         _nonReentrantAfter();
988     }
989 
990     function _nonReentrantBefore() private {
991         // On the first call to nonReentrant, _status will be _NOT_ENTERED
992         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
993 
994         // Any calls to nonReentrant after this point will fail
995         _status = _ENTERED;
996     }
997 
998     function _nonReentrantAfter() private {
999         // By storing the original value once again, a refund is triggered (see
1000         // https://eips.ethereum.org/EIPS/eip-2200)
1001         _status = _NOT_ENTERED;
1002     }
1003 }
1004 
1005 // File: @openzeppelin/contracts/utils/Context.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 /**
1013  * @dev Provides information about the current execution context, including the
1014  * sender of the transaction and its data. While these are generally available
1015  * via msg.sender and msg.data, they should not be accessed in such a direct
1016  * manner, since when dealing with meta-transactions the account sending and
1017  * paying for execution may not be the actual sender (as far as an application
1018  * is concerned).
1019  *
1020  * This contract is only required for intermediate, library-like contracts.
1021  */
1022 abstract contract Context {
1023     function _msgSender() internal view virtual returns (address) {
1024         return msg.sender;
1025     }
1026 
1027     function _msgData() internal view virtual returns (bytes calldata) {
1028         return msg.data;
1029     }
1030 }
1031 
1032 // File: @openzeppelin/contracts/access/Ownable.sol
1033 
1034 
1035 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 
1040 /**
1041  * @dev Contract module which provides a basic access control mechanism, where
1042  * there is an account (an owner) that can be granted exclusive access to
1043  * specific functions.
1044  *
1045  * By default, the owner account will be the one that deploys the contract. This
1046  * can later be changed with {transferOwnership}.
1047  *
1048  * This module is used through inheritance. It will make available the modifier
1049  * `onlyOwner`, which can be applied to your functions to restrict their use to
1050  * the owner.
1051  */
1052 abstract contract Ownable is Context {
1053     address private _owner;
1054 
1055     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1056 
1057     /**
1058      * @dev Initializes the contract setting the deployer as the initial owner.
1059      */
1060     constructor() {
1061         _transferOwnership(_msgSender());
1062     }
1063 
1064     /**
1065      * @dev Throws if called by any account other than the owner.
1066      */
1067     modifier onlyOwner() {
1068         _checkOwner();
1069         _;
1070     }
1071 
1072     /**
1073      * @dev Returns the address of the current owner.
1074      */
1075     function owner() public view virtual returns (address) {
1076         return _owner;
1077     }
1078 
1079     /**
1080      * @dev Throws if the sender is not the owner.
1081      */
1082     function _checkOwner() internal view virtual {
1083         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1084     }
1085 
1086     /**
1087      * @dev Leaves the contract without owner. It will not be possible to call
1088      * `onlyOwner` functions anymore. Can only be called by the current owner.
1089      *
1090      * NOTE: Renouncing ownership will leave the contract without an owner,
1091      * thereby removing any functionality that is only available to the owner.
1092      */
1093     function renounceOwnership() public virtual onlyOwner {
1094         _transferOwnership(address(0));
1095     }
1096 
1097     /**
1098      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1099      * Can only be called by the current owner.
1100      */
1101     function transferOwnership(address newOwner) public virtual onlyOwner {
1102         require(newOwner != address(0), "Ownable: new owner is the zero address");
1103         _transferOwnership(newOwner);
1104     }
1105 
1106     /**
1107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1108      * Internal function without access restriction.
1109      */
1110     function _transferOwnership(address newOwner) internal virtual {
1111         address oldOwner = _owner;
1112         _owner = newOwner;
1113         emit OwnershipTransferred(oldOwner, newOwner);
1114     }
1115 }
1116 
1117 // File: erc721a/contracts/IERC721A.sol
1118 
1119 
1120 // ERC721A Contracts v4.2.3
1121 // Creator: Chiru Labs
1122 
1123 pragma solidity ^0.8.4;
1124 
1125 /**
1126  * @dev Interface of ERC721A.
1127  */
1128 interface IERC721A {
1129     /**
1130      * The caller must own the token or be an approved operator.
1131      */
1132     error ApprovalCallerNotOwnerNorApproved();
1133 
1134     /**
1135      * The token does not exist.
1136      */
1137     error ApprovalQueryForNonexistentToken();
1138 
1139     /**
1140      * Cannot query the balance for the zero address.
1141      */
1142     error BalanceQueryForZeroAddress();
1143 
1144     /**
1145      * Cannot mint to the zero address.
1146      */
1147     error MintToZeroAddress();
1148 
1149     /**
1150      * The quantity of tokens minted must be more than zero.
1151      */
1152     error MintZeroQuantity();
1153 
1154     /**
1155      * The token does not exist.
1156      */
1157     error OwnerQueryForNonexistentToken();
1158 
1159     /**
1160      * The caller must own the token or be an approved operator.
1161      */
1162     error TransferCallerNotOwnerNorApproved();
1163 
1164     /**
1165      * The token must be owned by `from`.
1166      */
1167     error TransferFromIncorrectOwner();
1168 
1169     /**
1170      * Cannot safely transfer to a contract that does not implement the
1171      * ERC721Receiver interface.
1172      */
1173     error TransferToNonERC721ReceiverImplementer();
1174 
1175     /**
1176      * Cannot transfer to the zero address.
1177      */
1178     error TransferToZeroAddress();
1179 
1180     /**
1181      * The token does not exist.
1182      */
1183     error URIQueryForNonexistentToken();
1184 
1185     /**
1186      * The `quantity` minted with ERC2309 exceeds the safety limit.
1187      */
1188     error MintERC2309QuantityExceedsLimit();
1189 
1190     /**
1191      * The `extraData` cannot be set on an unintialized ownership slot.
1192      */
1193     error OwnershipNotInitializedForExtraData();
1194 
1195     // =============================================================
1196     //                            STRUCTS
1197     // =============================================================
1198 
1199     struct TokenOwnership {
1200         // The address of the owner.
1201         address addr;
1202         // Stores the start time of ownership with minimal overhead for tokenomics.
1203         uint64 startTimestamp;
1204         // Whether the token has been burned.
1205         bool burned;
1206         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1207         uint24 extraData;
1208     }
1209 
1210     // =============================================================
1211     //                         TOKEN COUNTERS
1212     // =============================================================
1213 
1214     /**
1215      * @dev Returns the total number of tokens in existence.
1216      * Burned tokens will reduce the count.
1217      * To get the total number of tokens minted, please see {_totalMinted}.
1218      */
1219     function totalSupply() external view returns (uint256);
1220 
1221     // =============================================================
1222     //                            IERC165
1223     // =============================================================
1224 
1225     /**
1226      * @dev Returns true if this contract implements the interface defined by
1227      * `interfaceId`. See the corresponding
1228      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1229      * to learn more about how these ids are created.
1230      *
1231      * This function call must use less than 30000 gas.
1232      */
1233     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1234 
1235     // =============================================================
1236     //                            IERC721
1237     // =============================================================
1238 
1239     /**
1240      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1241      */
1242     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1243 
1244     /**
1245      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1246      */
1247     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1248 
1249     /**
1250      * @dev Emitted when `owner` enables or disables
1251      * (`approved`) `operator` to manage all of its assets.
1252      */
1253     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1254 
1255     /**
1256      * @dev Returns the number of tokens in `owner`'s account.
1257      */
1258     function balanceOf(address owner) external view returns (uint256 balance);
1259 
1260     /**
1261      * @dev Returns the owner of the `tokenId` token.
1262      *
1263      * Requirements:
1264      *
1265      * - `tokenId` must exist.
1266      */
1267     function ownerOf(uint256 tokenId) external view returns (address owner);
1268 
1269     /**
1270      * @dev Safely transfers `tokenId` token from `from` to `to`,
1271      * checking first that contract recipients are aware of the ERC721 protocol
1272      * to prevent tokens from being forever locked.
1273      *
1274      * Requirements:
1275      *
1276      * - `from` cannot be the zero address.
1277      * - `to` cannot be the zero address.
1278      * - `tokenId` token must exist and be owned by `from`.
1279      * - If the caller is not `from`, it must be have been allowed to move
1280      * this token by either {approve} or {setApprovalForAll}.
1281      * - If `to` refers to a smart contract, it must implement
1282      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1283      *
1284      * Emits a {Transfer} event.
1285      */
1286     function safeTransferFrom(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes calldata data
1291     ) external payable;
1292 
1293     /**
1294      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1295      */
1296     function safeTransferFrom(
1297         address from,
1298         address to,
1299         uint256 tokenId
1300     ) external payable;
1301 
1302     /**
1303      * @dev Transfers `tokenId` from `from` to `to`.
1304      *
1305      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1306      * whenever possible.
1307      *
1308      * Requirements:
1309      *
1310      * - `from` cannot be the zero address.
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must be owned by `from`.
1313      * - If the caller is not `from`, it must be approved to move this token
1314      * by either {approve} or {setApprovalForAll}.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function transferFrom(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) external payable;
1323 
1324     /**
1325      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1326      * The approval is cleared when the token is transferred.
1327      *
1328      * Only a single account can be approved at a time, so approving the
1329      * zero address clears previous approvals.
1330      *
1331      * Requirements:
1332      *
1333      * - The caller must own the token or be an approved operator.
1334      * - `tokenId` must exist.
1335      *
1336      * Emits an {Approval} event.
1337      */
1338     function approve(address to, uint256 tokenId) external payable;
1339 
1340     /**
1341      * @dev Approve or remove `operator` as an operator for the caller.
1342      * Operators can call {transferFrom} or {safeTransferFrom}
1343      * for any token owned by the caller.
1344      *
1345      * Requirements:
1346      *
1347      * - The `operator` cannot be the caller.
1348      *
1349      * Emits an {ApprovalForAll} event.
1350      */
1351     function setApprovalForAll(address operator, bool _approved) external;
1352 
1353     /**
1354      * @dev Returns the account approved for `tokenId` token.
1355      *
1356      * Requirements:
1357      *
1358      * - `tokenId` must exist.
1359      */
1360     function getApproved(uint256 tokenId) external view returns (address operator);
1361 
1362     /**
1363      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1364      *
1365      * See {setApprovalForAll}.
1366      */
1367     function isApprovedForAll(address owner, address operator) external view returns (bool);
1368 
1369     // =============================================================
1370     //                        IERC721Metadata
1371     // =============================================================
1372 
1373     /**
1374      * @dev Returns the token collection name.
1375      */
1376     function name() external view returns (string memory);
1377 
1378     /**
1379      * @dev Returns the token collection symbol.
1380      */
1381     function symbol() external view returns (string memory);
1382 
1383     /**
1384      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1385      */
1386     function tokenURI(uint256 tokenId) external view returns (string memory);
1387 
1388     // =============================================================
1389     //                           IERC2309
1390     // =============================================================
1391 
1392     /**
1393      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1394      * (inclusive) is transferred from `from` to `to`, as defined in the
1395      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1396      *
1397      * See {_mintERC2309} for more details.
1398      */
1399     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1400 }
1401 
1402 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
1403 
1404 
1405 // ERC721A Contracts v4.2.3
1406 // Creator: Chiru Labs
1407 
1408 pragma solidity ^0.8.4;
1409 
1410 
1411 /**
1412  * @dev Interface of ERC721ABurnable.
1413  */
1414 interface IERC721ABurnable is IERC721A {
1415     /**
1416      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1417      *
1418      * Requirements:
1419      *
1420      * - The caller must own `tokenId` or be an approved operator.
1421      */
1422     function burn(uint256 tokenId) external;
1423 }
1424 
1425 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1426 
1427 
1428 // ERC721A Contracts v4.2.3
1429 // Creator: Chiru Labs
1430 
1431 pragma solidity ^0.8.4;
1432 
1433 
1434 /**
1435  * @dev Interface of ERC721AQueryable.
1436  */
1437 interface IERC721AQueryable is IERC721A {
1438     /**
1439      * Invalid query range (`start` >= `stop`).
1440      */
1441     error InvalidQueryRange();
1442 
1443     /**
1444      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1445      *
1446      * If the `tokenId` is out of bounds:
1447      *
1448      * - `addr = address(0)`
1449      * - `startTimestamp = 0`
1450      * - `burned = false`
1451      * - `extraData = 0`
1452      *
1453      * If the `tokenId` is burned:
1454      *
1455      * - `addr = <Address of owner before token was burned>`
1456      * - `startTimestamp = <Timestamp when token was burned>`
1457      * - `burned = true`
1458      * - `extraData = <Extra data when token was burned>`
1459      *
1460      * Otherwise:
1461      *
1462      * - `addr = <Address of owner>`
1463      * - `startTimestamp = <Timestamp of start of ownership>`
1464      * - `burned = false`
1465      * - `extraData = <Extra data at start of ownership>`
1466      */
1467     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1468 
1469     /**
1470      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1471      * See {ERC721AQueryable-explicitOwnershipOf}
1472      */
1473     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1474 
1475     /**
1476      * @dev Returns an array of token IDs owned by `owner`,
1477      * in the range [`start`, `stop`)
1478      * (i.e. `start <= tokenId < stop`).
1479      *
1480      * This function allows for tokens to be queried if the collection
1481      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1482      *
1483      * Requirements:
1484      *
1485      * - `start < stop`
1486      */
1487     function tokensOfOwnerIn(
1488         address owner,
1489         uint256 start,
1490         uint256 stop
1491     ) external view returns (uint256[] memory);
1492 
1493     /**
1494      * @dev Returns an array of token IDs owned by `owner`.
1495      *
1496      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1497      * It is meant to be called off-chain.
1498      *
1499      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1500      * multiple smaller scans if the collection is large enough to cause
1501      * an out-of-gas error (10K collections should be fine).
1502      */
1503     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1504 }
1505 
1506 // File: erc721a/contracts/ERC721A.sol
1507 
1508 
1509 // ERC721A Contracts v4.2.3
1510 // Creator: Chiru Labs
1511 
1512 pragma solidity ^0.8.4;
1513 
1514 
1515 /**
1516  * @dev Interface of ERC721 token receiver.
1517  */
1518 interface ERC721A__IERC721Receiver {
1519     function onERC721Received(
1520         address operator,
1521         address from,
1522         uint256 tokenId,
1523         bytes calldata data
1524     ) external returns (bytes4);
1525 }
1526 
1527 /**
1528  * @title ERC721A
1529  *
1530  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1531  * Non-Fungible Token Standard, including the Metadata extension.
1532  * Optimized for lower gas during batch mints.
1533  *
1534  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1535  * starting from `_startTokenId()`.
1536  *
1537  * Assumptions:
1538  *
1539  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1540  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1541  */
1542 contract ERC721A is IERC721A {
1543     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1544     struct TokenApprovalRef {
1545         address value;
1546     }
1547 
1548     // =============================================================
1549     //                           CONSTANTS
1550     // =============================================================
1551 
1552     // Mask of an entry in packed address data.
1553     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1554 
1555     // The bit position of `numberMinted` in packed address data.
1556     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1557 
1558     // The bit position of `numberBurned` in packed address data.
1559     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1560 
1561     // The bit position of `aux` in packed address data.
1562     uint256 private constant _BITPOS_AUX = 192;
1563 
1564     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1565     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1566 
1567     // The bit position of `startTimestamp` in packed ownership.
1568     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1569 
1570     // The bit mask of the `burned` bit in packed ownership.
1571     uint256 private constant _BITMASK_BURNED = 1 << 224;
1572 
1573     // The bit position of the `nextInitialized` bit in packed ownership.
1574     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1575 
1576     // The bit mask of the `nextInitialized` bit in packed ownership.
1577     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1578 
1579     // The bit position of `extraData` in packed ownership.
1580     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1581 
1582     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1583     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1584 
1585     // The mask of the lower 160 bits for addresses.
1586     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1587 
1588     // The maximum `quantity` that can be minted with {_mintERC2309}.
1589     // This limit is to prevent overflows on the address data entries.
1590     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1591     // is required to cause an overflow, which is unrealistic.
1592     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1593 
1594     // The `Transfer` event signature is given by:
1595     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1596     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1597         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1598 
1599     // =============================================================
1600     //                            STORAGE
1601     // =============================================================
1602 
1603     // The next token ID to be minted.
1604     uint256 private _currentIndex;
1605 
1606     // The number of tokens burned.
1607     uint256 private _burnCounter;
1608 
1609     // Token name
1610     string private _name;
1611 
1612     // Token symbol
1613     string private _symbol;
1614 
1615     // Mapping from token ID to ownership details
1616     // An empty struct value does not necessarily mean the token is unowned.
1617     // See {_packedOwnershipOf} implementation for details.
1618     //
1619     // Bits Layout:
1620     // - [0..159]   `addr`
1621     // - [160..223] `startTimestamp`
1622     // - [224]      `burned`
1623     // - [225]      `nextInitialized`
1624     // - [232..255] `extraData`
1625     mapping(uint256 => uint256) private _packedOwnerships;
1626 
1627     // Mapping owner address to address data.
1628     //
1629     // Bits Layout:
1630     // - [0..63]    `balance`
1631     // - [64..127]  `numberMinted`
1632     // - [128..191] `numberBurned`
1633     // - [192..255] `aux`
1634     mapping(address => uint256) private _packedAddressData;
1635 
1636     // Mapping from token ID to approved address.
1637     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1638 
1639     // Mapping from owner to operator approvals
1640     mapping(address => mapping(address => bool)) private _operatorApprovals;
1641 
1642     // =============================================================
1643     //                          CONSTRUCTOR
1644     // =============================================================
1645 
1646     constructor(string memory name_, string memory symbol_) {
1647         _name = name_;
1648         _symbol = symbol_;
1649         _currentIndex = _startTokenId();
1650     }
1651 
1652     // =============================================================
1653     //                   TOKEN COUNTING OPERATIONS
1654     // =============================================================
1655 
1656     /**
1657      * @dev Returns the starting token ID.
1658      * To change the starting token ID, please override this function.
1659      */
1660     function _startTokenId() internal view virtual returns (uint256) {
1661         return 0;
1662     }
1663 
1664     /**
1665      * @dev Returns the next token ID to be minted.
1666      */
1667     function _nextTokenId() internal view virtual returns (uint256) {
1668         return _currentIndex;
1669     }
1670 
1671     /**
1672      * @dev Returns the total number of tokens in existence.
1673      * Burned tokens will reduce the count.
1674      * To get the total number of tokens minted, please see {_totalMinted}.
1675      */
1676     function totalSupply() public view virtual override returns (uint256) {
1677         // Counter underflow is impossible as _burnCounter cannot be incremented
1678         // more than `_currentIndex - _startTokenId()` times.
1679         unchecked {
1680             return _currentIndex - _burnCounter - _startTokenId();
1681         }
1682     }
1683 
1684     /**
1685      * @dev Returns the total amount of tokens minted in the contract.
1686      */
1687     function _totalMinted() internal view virtual returns (uint256) {
1688         // Counter underflow is impossible as `_currentIndex` does not decrement,
1689         // and it is initialized to `_startTokenId()`.
1690         unchecked {
1691             return _currentIndex - _startTokenId();
1692         }
1693     }
1694 
1695     /**
1696      * @dev Returns the total number of tokens burned.
1697      */
1698     function _totalBurned() internal view virtual returns (uint256) {
1699         return _burnCounter;
1700     }
1701 
1702     // =============================================================
1703     //                    ADDRESS DATA OPERATIONS
1704     // =============================================================
1705 
1706     /**
1707      * @dev Returns the number of tokens in `owner`'s account.
1708      */
1709     function balanceOf(address owner) public view virtual override returns (uint256) {
1710         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1711         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1712     }
1713 
1714     /**
1715      * Returns the number of tokens minted by `owner`.
1716      */
1717     function _numberMinted(address owner) internal view returns (uint256) {
1718         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1719     }
1720 
1721     /**
1722      * Returns the number of tokens burned by or on behalf of `owner`.
1723      */
1724     function _numberBurned(address owner) internal view returns (uint256) {
1725         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1726     }
1727 
1728     /**
1729      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1730      */
1731     function _getAux(address owner) internal view returns (uint64) {
1732         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1733     }
1734 
1735     /**
1736      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1737      * If there are multiple variables, please pack them into a uint64.
1738      */
1739     function _setAux(address owner, uint64 aux) internal virtual {
1740         uint256 packed = _packedAddressData[owner];
1741         uint256 auxCasted;
1742         // Cast `aux` with assembly to avoid redundant masking.
1743         assembly {
1744             auxCasted := aux
1745         }
1746         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1747         _packedAddressData[owner] = packed;
1748     }
1749 
1750     // =============================================================
1751     //                            IERC165
1752     // =============================================================
1753 
1754     /**
1755      * @dev Returns true if this contract implements the interface defined by
1756      * `interfaceId`. See the corresponding
1757      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1758      * to learn more about how these ids are created.
1759      *
1760      * This function call must use less than 30000 gas.
1761      */
1762     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1763         // The interface IDs are constants representing the first 4 bytes
1764         // of the XOR of all function selectors in the interface.
1765         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1766         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1767         return
1768             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1769             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1770             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1771     }
1772 
1773     // =============================================================
1774     //                        IERC721Metadata
1775     // =============================================================
1776 
1777     /**
1778      * @dev Returns the token collection name.
1779      */
1780     function name() public view virtual override returns (string memory) {
1781         return _name;
1782     }
1783 
1784     /**
1785      * @dev Returns the token collection symbol.
1786      */
1787     function symbol() public view virtual override returns (string memory) {
1788         return _symbol;
1789     }
1790 
1791     /**
1792      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1793      */
1794     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1795         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1796 
1797         string memory baseURI = _baseURI();
1798         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1799     }
1800 
1801     /**
1802      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1803      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1804      * by default, it can be overridden in child contracts.
1805      */
1806     function _baseURI() internal view virtual returns (string memory) {
1807         return '';
1808     }
1809 
1810     // =============================================================
1811     //                     OWNERSHIPS OPERATIONS
1812     // =============================================================
1813 
1814     /**
1815      * @dev Returns the owner of the `tokenId` token.
1816      *
1817      * Requirements:
1818      *
1819      * - `tokenId` must exist.
1820      */
1821     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1822         return address(uint160(_packedOwnershipOf(tokenId)));
1823     }
1824 
1825     /**
1826      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1827      * It gradually moves to O(1) as tokens get transferred around over time.
1828      */
1829     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1830         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1831     }
1832 
1833     /**
1834      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1835      */
1836     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1837         return _unpackedOwnership(_packedOwnerships[index]);
1838     }
1839 
1840     /**
1841      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1842      */
1843     function _initializeOwnershipAt(uint256 index) internal virtual {
1844         if (_packedOwnerships[index] == 0) {
1845             _packedOwnerships[index] = _packedOwnershipOf(index);
1846         }
1847     }
1848 
1849     /**
1850      * Returns the packed ownership data of `tokenId`.
1851      */
1852     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1853         uint256 curr = tokenId;
1854 
1855         unchecked {
1856             if (_startTokenId() <= curr)
1857                 if (curr < _currentIndex) {
1858                     uint256 packed = _packedOwnerships[curr];
1859                     // If not burned.
1860                     if (packed & _BITMASK_BURNED == 0) {
1861                         // Invariant:
1862                         // There will always be an initialized ownership slot
1863                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1864                         // before an unintialized ownership slot
1865                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1866                         // Hence, `curr` will not underflow.
1867                         //
1868                         // We can directly compare the packed value.
1869                         // If the address is zero, packed will be zero.
1870                         while (packed == 0) {
1871                             packed = _packedOwnerships[--curr];
1872                         }
1873                         return packed;
1874                     }
1875                 }
1876         }
1877         revert OwnerQueryForNonexistentToken();
1878     }
1879 
1880     /**
1881      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1882      */
1883     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1884         ownership.addr = address(uint160(packed));
1885         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1886         ownership.burned = packed & _BITMASK_BURNED != 0;
1887         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1888     }
1889 
1890     /**
1891      * @dev Packs ownership data into a single uint256.
1892      */
1893     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1894         assembly {
1895             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1896             owner := and(owner, _BITMASK_ADDRESS)
1897             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1898             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1899         }
1900     }
1901 
1902     /**
1903      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1904      */
1905     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1906         // For branchless setting of the `nextInitialized` flag.
1907         assembly {
1908             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1909             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1910         }
1911     }
1912 
1913     // =============================================================
1914     //                      APPROVAL OPERATIONS
1915     // =============================================================
1916 
1917     /**
1918      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1919      * The approval is cleared when the token is transferred.
1920      *
1921      * Only a single account can be approved at a time, so approving the
1922      * zero address clears previous approvals.
1923      *
1924      * Requirements:
1925      *
1926      * - The caller must own the token or be an approved operator.
1927      * - `tokenId` must exist.
1928      *
1929      * Emits an {Approval} event.
1930      */
1931     function approve(address to, uint256 tokenId) public payable virtual override {
1932         address owner = ownerOf(tokenId);
1933 
1934         if (_msgSenderERC721A() != owner)
1935             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1936                 revert ApprovalCallerNotOwnerNorApproved();
1937             }
1938 
1939         _tokenApprovals[tokenId].value = to;
1940         emit Approval(owner, to, tokenId);
1941     }
1942 
1943     /**
1944      * @dev Returns the account approved for `tokenId` token.
1945      *
1946      * Requirements:
1947      *
1948      * - `tokenId` must exist.
1949      */
1950     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1951         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1952 
1953         return _tokenApprovals[tokenId].value;
1954     }
1955 
1956     /**
1957      * @dev Approve or remove `operator` as an operator for the caller.
1958      * Operators can call {transferFrom} or {safeTransferFrom}
1959      * for any token owned by the caller.
1960      *
1961      * Requirements:
1962      *
1963      * - The `operator` cannot be the caller.
1964      *
1965      * Emits an {ApprovalForAll} event.
1966      */
1967     function setApprovalForAll(address operator, bool approved) public virtual override {
1968         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1969         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1970     }
1971 
1972     /**
1973      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1974      *
1975      * See {setApprovalForAll}.
1976      */
1977     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1978         return _operatorApprovals[owner][operator];
1979     }
1980 
1981     /**
1982      * @dev Returns whether `tokenId` exists.
1983      *
1984      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1985      *
1986      * Tokens start existing when they are minted. See {_mint}.
1987      */
1988     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1989         return
1990             _startTokenId() <= tokenId &&
1991             tokenId < _currentIndex && // If within bounds,
1992             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1993     }
1994 
1995     /**
1996      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1997      */
1998     function _isSenderApprovedOrOwner(
1999         address approvedAddress,
2000         address owner,
2001         address msgSender
2002     ) private pure returns (bool result) {
2003         assembly {
2004             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2005             owner := and(owner, _BITMASK_ADDRESS)
2006             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2007             msgSender := and(msgSender, _BITMASK_ADDRESS)
2008             // `msgSender == owner || msgSender == approvedAddress`.
2009             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2010         }
2011     }
2012 
2013     /**
2014      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2015      */
2016     function _getApprovedSlotAndAddress(uint256 tokenId)
2017         private
2018         view
2019         returns (uint256 approvedAddressSlot, address approvedAddress)
2020     {
2021         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2022         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2023         assembly {
2024             approvedAddressSlot := tokenApproval.slot
2025             approvedAddress := sload(approvedAddressSlot)
2026         }
2027     }
2028 
2029     // =============================================================
2030     //                      TRANSFER OPERATIONS
2031     // =============================================================
2032 
2033     /**
2034      * @dev Transfers `tokenId` from `from` to `to`.
2035      *
2036      * Requirements:
2037      *
2038      * - `from` cannot be the zero address.
2039      * - `to` cannot be the zero address.
2040      * - `tokenId` token must be owned by `from`.
2041      * - If the caller is not `from`, it must be approved to move this token
2042      * by either {approve} or {setApprovalForAll}.
2043      *
2044      * Emits a {Transfer} event.
2045      */
2046     function transferFrom(
2047         address from,
2048         address to,
2049         uint256 tokenId
2050     ) public payable virtual override {
2051         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2052 
2053         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2054 
2055         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2056 
2057         // The nested ifs save around 20+ gas over a compound boolean condition.
2058         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2059             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2060 
2061         if (to == address(0)) revert TransferToZeroAddress();
2062 
2063         _beforeTokenTransfers(from, to, tokenId, 1);
2064 
2065         // Clear approvals from the previous owner.
2066         assembly {
2067             if approvedAddress {
2068                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2069                 sstore(approvedAddressSlot, 0)
2070             }
2071         }
2072 
2073         // Underflow of the sender's balance is impossible because we check for
2074         // ownership above and the recipient's balance can't realistically overflow.
2075         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2076         unchecked {
2077             // We can directly increment and decrement the balances.
2078             --_packedAddressData[from]; // Updates: `balance -= 1`.
2079             ++_packedAddressData[to]; // Updates: `balance += 1`.
2080 
2081             // Updates:
2082             // - `address` to the next owner.
2083             // - `startTimestamp` to the timestamp of transfering.
2084             // - `burned` to `false`.
2085             // - `nextInitialized` to `true`.
2086             _packedOwnerships[tokenId] = _packOwnershipData(
2087                 to,
2088                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2089             );
2090 
2091             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2092             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2093                 uint256 nextTokenId = tokenId + 1;
2094                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2095                 if (_packedOwnerships[nextTokenId] == 0) {
2096                     // If the next slot is within bounds.
2097                     if (nextTokenId != _currentIndex) {
2098                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2099                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2100                     }
2101                 }
2102             }
2103         }
2104 
2105         emit Transfer(from, to, tokenId);
2106         _afterTokenTransfers(from, to, tokenId, 1);
2107     }
2108 
2109     /**
2110      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2111      */
2112     function safeTransferFrom(
2113         address from,
2114         address to,
2115         uint256 tokenId
2116     ) public payable virtual override {
2117         safeTransferFrom(from, to, tokenId, '');
2118     }
2119 
2120     /**
2121      * @dev Safely transfers `tokenId` token from `from` to `to`.
2122      *
2123      * Requirements:
2124      *
2125      * - `from` cannot be the zero address.
2126      * - `to` cannot be the zero address.
2127      * - `tokenId` token must exist and be owned by `from`.
2128      * - If the caller is not `from`, it must be approved to move this token
2129      * by either {approve} or {setApprovalForAll}.
2130      * - If `to` refers to a smart contract, it must implement
2131      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2132      *
2133      * Emits a {Transfer} event.
2134      */
2135     function safeTransferFrom(
2136         address from,
2137         address to,
2138         uint256 tokenId,
2139         bytes memory _data
2140     ) public payable virtual override {
2141         transferFrom(from, to, tokenId);
2142         if (to.code.length != 0)
2143             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2144                 revert TransferToNonERC721ReceiverImplementer();
2145             }
2146     }
2147 
2148     /**
2149      * @dev Hook that is called before a set of serially-ordered token IDs
2150      * are about to be transferred. This includes minting.
2151      * And also called before burning one token.
2152      *
2153      * `startTokenId` - the first token ID to be transferred.
2154      * `quantity` - the amount to be transferred.
2155      *
2156      * Calling conditions:
2157      *
2158      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2159      * transferred to `to`.
2160      * - When `from` is zero, `tokenId` will be minted for `to`.
2161      * - When `to` is zero, `tokenId` will be burned by `from`.
2162      * - `from` and `to` are never both zero.
2163      */
2164     function _beforeTokenTransfers(
2165         address from,
2166         address to,
2167         uint256 startTokenId,
2168         uint256 quantity
2169     ) internal virtual {}
2170 
2171     /**
2172      * @dev Hook that is called after a set of serially-ordered token IDs
2173      * have been transferred. This includes minting.
2174      * And also called after one token has been burned.
2175      *
2176      * `startTokenId` - the first token ID to be transferred.
2177      * `quantity` - the amount to be transferred.
2178      *
2179      * Calling conditions:
2180      *
2181      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2182      * transferred to `to`.
2183      * - When `from` is zero, `tokenId` has been minted for `to`.
2184      * - When `to` is zero, `tokenId` has been burned by `from`.
2185      * - `from` and `to` are never both zero.
2186      */
2187     function _afterTokenTransfers(
2188         address from,
2189         address to,
2190         uint256 startTokenId,
2191         uint256 quantity
2192     ) internal virtual {}
2193 
2194     /**
2195      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2196      *
2197      * `from` - Previous owner of the given token ID.
2198      * `to` - Target address that will receive the token.
2199      * `tokenId` - Token ID to be transferred.
2200      * `_data` - Optional data to send along with the call.
2201      *
2202      * Returns whether the call correctly returned the expected magic value.
2203      */
2204     function _checkContractOnERC721Received(
2205         address from,
2206         address to,
2207         uint256 tokenId,
2208         bytes memory _data
2209     ) private returns (bool) {
2210         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2211             bytes4 retval
2212         ) {
2213             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2214         } catch (bytes memory reason) {
2215             if (reason.length == 0) {
2216                 revert TransferToNonERC721ReceiverImplementer();
2217             } else {
2218                 assembly {
2219                     revert(add(32, reason), mload(reason))
2220                 }
2221             }
2222         }
2223     }
2224 
2225     // =============================================================
2226     //                        MINT OPERATIONS
2227     // =============================================================
2228 
2229     /**
2230      * @dev Mints `quantity` tokens and transfers them to `to`.
2231      *
2232      * Requirements:
2233      *
2234      * - `to` cannot be the zero address.
2235      * - `quantity` must be greater than 0.
2236      *
2237      * Emits a {Transfer} event for each mint.
2238      */
2239     function _mint(address to, uint256 quantity) internal virtual {
2240         uint256 startTokenId = _currentIndex;
2241         if (quantity == 0) revert MintZeroQuantity();
2242 
2243         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2244 
2245         // Overflows are incredibly unrealistic.
2246         // `balance` and `numberMinted` have a maximum limit of 2**64.
2247         // `tokenId` has a maximum limit of 2**256.
2248         unchecked {
2249             // Updates:
2250             // - `balance += quantity`.
2251             // - `numberMinted += quantity`.
2252             //
2253             // We can directly add to the `balance` and `numberMinted`.
2254             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2255 
2256             // Updates:
2257             // - `address` to the owner.
2258             // - `startTimestamp` to the timestamp of minting.
2259             // - `burned` to `false`.
2260             // - `nextInitialized` to `quantity == 1`.
2261             _packedOwnerships[startTokenId] = _packOwnershipData(
2262                 to,
2263                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2264             );
2265 
2266             uint256 toMasked;
2267             uint256 end = startTokenId + quantity;
2268 
2269             // Use assembly to loop and emit the `Transfer` event for gas savings.
2270             // The duplicated `log4` removes an extra check and reduces stack juggling.
2271             // The assembly, together with the surrounding Solidity code, have been
2272             // delicately arranged to nudge the compiler into producing optimized opcodes.
2273             assembly {
2274                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2275                 toMasked := and(to, _BITMASK_ADDRESS)
2276                 // Emit the `Transfer` event.
2277                 log4(
2278                     0, // Start of data (0, since no data).
2279                     0, // End of data (0, since no data).
2280                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2281                     0, // `address(0)`.
2282                     toMasked, // `to`.
2283                     startTokenId // `tokenId`.
2284                 )
2285 
2286                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2287                 // that overflows uint256 will make the loop run out of gas.
2288                 // The compiler will optimize the `iszero` away for performance.
2289                 for {
2290                     let tokenId := add(startTokenId, 1)
2291                 } iszero(eq(tokenId, end)) {
2292                     tokenId := add(tokenId, 1)
2293                 } {
2294                     // Emit the `Transfer` event. Similar to above.
2295                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2296                 }
2297             }
2298             if (toMasked == 0) revert MintToZeroAddress();
2299 
2300             _currentIndex = end;
2301         }
2302         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2303     }
2304 
2305     /**
2306      * @dev Mints `quantity` tokens and transfers them to `to`.
2307      *
2308      * This function is intended for efficient minting only during contract creation.
2309      *
2310      * It emits only one {ConsecutiveTransfer} as defined in
2311      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2312      * instead of a sequence of {Transfer} event(s).
2313      *
2314      * Calling this function outside of contract creation WILL make your contract
2315      * non-compliant with the ERC721 standard.
2316      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2317      * {ConsecutiveTransfer} event is only permissible during contract creation.
2318      *
2319      * Requirements:
2320      *
2321      * - `to` cannot be the zero address.
2322      * - `quantity` must be greater than 0.
2323      *
2324      * Emits a {ConsecutiveTransfer} event.
2325      */
2326     function _mintERC2309(address to, uint256 quantity) internal virtual {
2327         uint256 startTokenId = _currentIndex;
2328         if (to == address(0)) revert MintToZeroAddress();
2329         if (quantity == 0) revert MintZeroQuantity();
2330         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2331 
2332         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2333 
2334         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2335         unchecked {
2336             // Updates:
2337             // - `balance += quantity`.
2338             // - `numberMinted += quantity`.
2339             //
2340             // We can directly add to the `balance` and `numberMinted`.
2341             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2342 
2343             // Updates:
2344             // - `address` to the owner.
2345             // - `startTimestamp` to the timestamp of minting.
2346             // - `burned` to `false`.
2347             // - `nextInitialized` to `quantity == 1`.
2348             _packedOwnerships[startTokenId] = _packOwnershipData(
2349                 to,
2350                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2351             );
2352 
2353             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2354 
2355             _currentIndex = startTokenId + quantity;
2356         }
2357         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2358     }
2359 
2360     /**
2361      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2362      *
2363      * Requirements:
2364      *
2365      * - If `to` refers to a smart contract, it must implement
2366      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2367      * - `quantity` must be greater than 0.
2368      *
2369      * See {_mint}.
2370      *
2371      * Emits a {Transfer} event for each mint.
2372      */
2373     function _safeMint(
2374         address to,
2375         uint256 quantity,
2376         bytes memory _data
2377     ) internal virtual {
2378         _mint(to, quantity);
2379 
2380         unchecked {
2381             if (to.code.length != 0) {
2382                 uint256 end = _currentIndex;
2383                 uint256 index = end - quantity;
2384                 do {
2385                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2386                         revert TransferToNonERC721ReceiverImplementer();
2387                     }
2388                 } while (index < end);
2389                 // Reentrancy protection.
2390                 if (_currentIndex != end) revert();
2391             }
2392         }
2393     }
2394 
2395     /**
2396      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2397      */
2398     function _safeMint(address to, uint256 quantity) internal virtual {
2399         _safeMint(to, quantity, '');
2400     }
2401 
2402     // =============================================================
2403     //                        BURN OPERATIONS
2404     // =============================================================
2405 
2406     /**
2407      * @dev Equivalent to `_burn(tokenId, false)`.
2408      */
2409     function _burn(uint256 tokenId) internal virtual {
2410         _burn(tokenId, false);
2411     }
2412 
2413     /**
2414      * @dev Destroys `tokenId`.
2415      * The approval is cleared when the token is burned.
2416      *
2417      * Requirements:
2418      *
2419      * - `tokenId` must exist.
2420      *
2421      * Emits a {Transfer} event.
2422      */
2423     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2424         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2425 
2426         address from = address(uint160(prevOwnershipPacked));
2427 
2428         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2429 
2430         if (approvalCheck) {
2431             // The nested ifs save around 20+ gas over a compound boolean condition.
2432             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2433                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2434         }
2435 
2436         _beforeTokenTransfers(from, address(0), tokenId, 1);
2437 
2438         // Clear approvals from the previous owner.
2439         assembly {
2440             if approvedAddress {
2441                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2442                 sstore(approvedAddressSlot, 0)
2443             }
2444         }
2445 
2446         // Underflow of the sender's balance is impossible because we check for
2447         // ownership above and the recipient's balance can't realistically overflow.
2448         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2449         unchecked {
2450             // Updates:
2451             // - `balance -= 1`.
2452             // - `numberBurned += 1`.
2453             //
2454             // We can directly decrement the balance, and increment the number burned.
2455             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2456             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2457 
2458             // Updates:
2459             // - `address` to the last owner.
2460             // - `startTimestamp` to the timestamp of burning.
2461             // - `burned` to `true`.
2462             // - `nextInitialized` to `true`.
2463             _packedOwnerships[tokenId] = _packOwnershipData(
2464                 from,
2465                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2466             );
2467 
2468             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2469             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2470                 uint256 nextTokenId = tokenId + 1;
2471                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2472                 if (_packedOwnerships[nextTokenId] == 0) {
2473                     // If the next slot is within bounds.
2474                     if (nextTokenId != _currentIndex) {
2475                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2476                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2477                     }
2478                 }
2479             }
2480         }
2481 
2482         emit Transfer(from, address(0), tokenId);
2483         _afterTokenTransfers(from, address(0), tokenId, 1);
2484 
2485         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2486         unchecked {
2487             _burnCounter++;
2488         }
2489     }
2490 
2491     // =============================================================
2492     //                     EXTRA DATA OPERATIONS
2493     // =============================================================
2494 
2495     /**
2496      * @dev Directly sets the extra data for the ownership data `index`.
2497      */
2498     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2499         uint256 packed = _packedOwnerships[index];
2500         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2501         uint256 extraDataCasted;
2502         // Cast `extraData` with assembly to avoid redundant masking.
2503         assembly {
2504             extraDataCasted := extraData
2505         }
2506         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2507         _packedOwnerships[index] = packed;
2508     }
2509 
2510     /**
2511      * @dev Called during each token transfer to set the 24bit `extraData` field.
2512      * Intended to be overridden by the cosumer contract.
2513      *
2514      * `previousExtraData` - the value of `extraData` before transfer.
2515      *
2516      * Calling conditions:
2517      *
2518      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2519      * transferred to `to`.
2520      * - When `from` is zero, `tokenId` will be minted for `to`.
2521      * - When `to` is zero, `tokenId` will be burned by `from`.
2522      * - `from` and `to` are never both zero.
2523      */
2524     function _extraData(
2525         address from,
2526         address to,
2527         uint24 previousExtraData
2528     ) internal view virtual returns (uint24) {}
2529 
2530     /**
2531      * @dev Returns the next extra data for the packed ownership data.
2532      * The returned result is shifted into position.
2533      */
2534     function _nextExtraData(
2535         address from,
2536         address to,
2537         uint256 prevOwnershipPacked
2538     ) private view returns (uint256) {
2539         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2540         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2541     }
2542 
2543     // =============================================================
2544     //                       OTHER OPERATIONS
2545     // =============================================================
2546 
2547     /**
2548      * @dev Returns the message sender (defaults to `msg.sender`).
2549      *
2550      * If you are writing GSN compatible contracts, you need to override this function.
2551      */
2552     function _msgSenderERC721A() internal view virtual returns (address) {
2553         return msg.sender;
2554     }
2555 
2556     /**
2557      * @dev Converts a uint256 to its ASCII string decimal representation.
2558      */
2559     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2560         assembly {
2561             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2562             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2563             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2564             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2565             let m := add(mload(0x40), 0xa0)
2566             // Update the free memory pointer to allocate.
2567             mstore(0x40, m)
2568             // Assign the `str` to the end.
2569             str := sub(m, 0x20)
2570             // Zeroize the slot after the string.
2571             mstore(str, 0)
2572 
2573             // Cache the end of the memory to calculate the length later.
2574             let end := str
2575 
2576             // We write the string from rightmost digit to leftmost digit.
2577             // The following is essentially a do-while loop that also handles the zero case.
2578             // prettier-ignore
2579             for { let temp := value } 1 {} {
2580                 str := sub(str, 1)
2581                 // Write the character to the pointer.
2582                 // The ASCII index of the '0' character is 48.
2583                 mstore8(str, add(48, mod(temp, 10)))
2584                 // Keep dividing `temp` until zero.
2585                 temp := div(temp, 10)
2586                 // prettier-ignore
2587                 if iszero(temp) { break }
2588             }
2589 
2590             let length := sub(end, str)
2591             // Move the pointer 32 bytes leftwards to make room for the length.
2592             str := sub(str, 0x20)
2593             // Store the length.
2594             mstore(str, length)
2595         }
2596     }
2597 }
2598 
2599 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
2600 
2601 
2602 // ERC721A Contracts v4.2.3
2603 // Creator: Chiru Labs
2604 
2605 pragma solidity ^0.8.4;
2606 
2607 
2608 
2609 /**
2610  * @title ERC721ABurnable.
2611  *
2612  * @dev ERC721A token that can be irreversibly burned (destroyed).
2613  */
2614 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
2615     /**
2616      * @dev Burns `tokenId`. See {ERC721A-_burn}.
2617      *
2618      * Requirements:
2619      *
2620      * - The caller must own `tokenId` or be an approved operator.
2621      */
2622     function burn(uint256 tokenId) public virtual override {
2623         _burn(tokenId, true);
2624     }
2625 }
2626 
2627 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2628 
2629 
2630 // ERC721A Contracts v4.2.3
2631 // Creator: Chiru Labs
2632 
2633 pragma solidity ^0.8.4;
2634 
2635 
2636 
2637 /**
2638  * @title ERC721AQueryable.
2639  *
2640  * @dev ERC721A subclass with convenience query functions.
2641  */
2642 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2643     /**
2644      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2645      *
2646      * If the `tokenId` is out of bounds:
2647      *
2648      * - `addr = address(0)`
2649      * - `startTimestamp = 0`
2650      * - `burned = false`
2651      * - `extraData = 0`
2652      *
2653      * If the `tokenId` is burned:
2654      *
2655      * - `addr = <Address of owner before token was burned>`
2656      * - `startTimestamp = <Timestamp when token was burned>`
2657      * - `burned = true`
2658      * - `extraData = <Extra data when token was burned>`
2659      *
2660      * Otherwise:
2661      *
2662      * - `addr = <Address of owner>`
2663      * - `startTimestamp = <Timestamp of start of ownership>`
2664      * - `burned = false`
2665      * - `extraData = <Extra data at start of ownership>`
2666      */
2667     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2668         TokenOwnership memory ownership;
2669         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2670             return ownership;
2671         }
2672         ownership = _ownershipAt(tokenId);
2673         if (ownership.burned) {
2674             return ownership;
2675         }
2676         return _ownershipOf(tokenId);
2677     }
2678 
2679     /**
2680      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2681      * See {ERC721AQueryable-explicitOwnershipOf}
2682      */
2683     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2684         external
2685         view
2686         virtual
2687         override
2688         returns (TokenOwnership[] memory)
2689     {
2690         unchecked {
2691             uint256 tokenIdsLength = tokenIds.length;
2692             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2693             for (uint256 i; i != tokenIdsLength; ++i) {
2694                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2695             }
2696             return ownerships;
2697         }
2698     }
2699 
2700     /**
2701      * @dev Returns an array of token IDs owned by `owner`,
2702      * in the range [`start`, `stop`)
2703      * (i.e. `start <= tokenId < stop`).
2704      *
2705      * This function allows for tokens to be queried if the collection
2706      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2707      *
2708      * Requirements:
2709      *
2710      * - `start < stop`
2711      */
2712     function tokensOfOwnerIn(
2713         address owner,
2714         uint256 start,
2715         uint256 stop
2716     ) external view virtual override returns (uint256[] memory) {
2717         unchecked {
2718             if (start >= stop) revert InvalidQueryRange();
2719             uint256 tokenIdsIdx;
2720             uint256 stopLimit = _nextTokenId();
2721             // Set `start = max(start, _startTokenId())`.
2722             if (start < _startTokenId()) {
2723                 start = _startTokenId();
2724             }
2725             // Set `stop = min(stop, stopLimit)`.
2726             if (stop > stopLimit) {
2727                 stop = stopLimit;
2728             }
2729             uint256 tokenIdsMaxLength = balanceOf(owner);
2730             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2731             // to cater for cases where `balanceOf(owner)` is too big.
2732             if (start < stop) {
2733                 uint256 rangeLength = stop - start;
2734                 if (rangeLength < tokenIdsMaxLength) {
2735                     tokenIdsMaxLength = rangeLength;
2736                 }
2737             } else {
2738                 tokenIdsMaxLength = 0;
2739             }
2740             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2741             if (tokenIdsMaxLength == 0) {
2742                 return tokenIds;
2743             }
2744             // We need to call `explicitOwnershipOf(start)`,
2745             // because the slot at `start` may not be initialized.
2746             TokenOwnership memory ownership = explicitOwnershipOf(start);
2747             address currOwnershipAddr;
2748             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2749             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2750             if (!ownership.burned) {
2751                 currOwnershipAddr = ownership.addr;
2752             }
2753             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2754                 ownership = _ownershipAt(i);
2755                 if (ownership.burned) {
2756                     continue;
2757                 }
2758                 if (ownership.addr != address(0)) {
2759                     currOwnershipAddr = ownership.addr;
2760                 }
2761                 if (currOwnershipAddr == owner) {
2762                     tokenIds[tokenIdsIdx++] = i;
2763                 }
2764             }
2765             // Downsize the array to fit.
2766             assembly {
2767                 mstore(tokenIds, tokenIdsIdx)
2768             }
2769             return tokenIds;
2770         }
2771     }
2772 
2773     /**
2774      * @dev Returns an array of token IDs owned by `owner`.
2775      *
2776      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2777      * It is meant to be called off-chain.
2778      *
2779      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2780      * multiple smaller scans if the collection is large enough to cause
2781      * an out-of-gas error (10K collections should be fine).
2782      */
2783     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2784         unchecked {
2785             uint256 tokenIdsIdx;
2786             address currOwnershipAddr;
2787             uint256 tokenIdsLength = balanceOf(owner);
2788             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2789             TokenOwnership memory ownership;
2790             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2791                 ownership = _ownershipAt(i);
2792                 if (ownership.burned) {
2793                     continue;
2794                 }
2795                 if (ownership.addr != address(0)) {
2796                     currOwnershipAddr = ownership.addr;
2797                 }
2798                 if (currOwnershipAddr == owner) {
2799                     tokenIds[tokenIdsIdx++] = i;
2800                 }
2801             }
2802             return tokenIds;
2803         }
2804     }
2805 }
2806 
2807 // File: contracts/Deviants.sol
2808 
2809 
2810 pragma solidity ^0.8.4;
2811 
2812 
2813 
2814 
2815 
2816 
2817 
2818 
2819 
2820 
2821  /**
2822   * @title Deviants
2823   * @dev The contract allows users to convert:
2824   * For each Silver Mint Pass - Mint 1 Deviant 
2825   * For each Diamond Mint Pass- Mint 1 Deviant 
2826   * For each Gold Mint Pass- Mint 3 Deviants
2827   * For each Crimson Mint Pass- Mint 1 Deviant
2828   * @dev The contract also has owner who have the privilages to set the state of the contract.
2829   * @dev The contract use ChainLink vrf to generate random numbers.
2830   */
2831 contract Deviants is ERC721A, ERC721AQueryable,ERC721ABurnable, Ownable, ReentrancyGuard, DefaultOperatorFilterer, VRFConsumerBaseV2 {
2832     using Strings for uint256;
2833 
2834     /** 
2835      * @dev the receiver of the passes users will convert in Deviants.
2836      */
2837     address public receiver;
2838 
2839     /** 
2840      * @dev Set max supply for the Deviants collection
2841      */
2842     uint256 public constant maxSupply = 10000;
2843 
2844     /** 
2845      * @dev request id from ChainLink VRF
2846      */
2847     uint256 public requestIdNr;
2848 
2849     /** 
2850      * @dev first random number from ChainLinkVRF
2851      */
2852     uint256 public randomNumber1;
2853 
2854     /** 
2855      * @dev second random number from ChainLinkVRF
2856      */
2857     uint256 public randomNumber2;
2858     
2859     /** 
2860      * @dev State of the mint => true=paused/false=unpaused
2861      */
2862     bool public pauseMint = true;
2863 
2864     /** 
2865      * @dev checks if the collection is revealed
2866      */
2867     bool public revealed = false;
2868 
2869     /** 
2870      * @dev checks if the owner requested the random numbers from ChainLinkVRF
2871      */
2872     bool public numbersRequested = false;
2873 
2874     /** 
2875      * @dev checks if ChainLink vrf returned the numbers to the Deviants contract;
2876      */
2877     bool public numbersReceived = false;
2878 
2879     /** 
2880      * @dev state to check crypto.com allocation
2881      */
2882     bool public last300On = false;
2883 
2884     /**
2885      * @dev Silver/Diamond/Gold/Crimson erc721A contracts.
2886      */
2887     ERC721A public deviantsSilverPassCollection; 
2888     ERC721A public deviantsDiamondPassCollection;
2889     ERC721A public deviantsGoldPassCollection;
2890     ERC721A public deviantsCrimsonPassCollection;
2891 
2892     /** 
2893      * @dev Prefix for tokens metadata URIs
2894      */
2895     string public baseURI;
2896 
2897     /** 
2898      * @dev Sufix for tokens metadata URIs
2899      */
2900     string public uriSuffix = '.json';
2901 
2902     /**
2903      * @dev unrevealed token URI
2904      */
2905     string public unrevealedURI;
2906 
2907     /**
2908      * @dev legendary unrevealed token URI
2909      */
2910     string public legendaryUnrevealedURI;
2911 
2912     /**
2913      * @dev Chainlink VRF coordinator address specific to desired chain
2914      */
2915     VRFCoordinatorV2Interface public i_vrfCoordinator;
2916 
2917     /**
2918      * @dev Chainlink VRF subscription Id created by the owner
2919      */
2920     uint64  private  i_subscriptionId;
2921 
2922     /**
2923      * @dev gasLane (keyHash) of the specific chain  
2924      */
2925     bytes32 private  i_gasLane;
2926 
2927     /**
2928      * @dev Chainlink VRF callback function limit cost
2929      */
2930     uint32 private  i_callbackGasLimit;
2931 
2932     /**
2933      * @dev How many blocks the VRF service waits before writing a fulfillment to the chain
2934      */
2935     uint16 private  REQUEST_CONFIRMATIONS = 3;
2936 
2937     /**
2938      * @dev number of random words chainLink VRF will provide
2939      */
2940     uint32 private  NUM_WORDS = 2;
2941 
2942     /**
2943      * @dev mapping with blockedMarketplaces for this contract
2944      */
2945     mapping(address => bool) public blockedMarketplaces; 
2946 
2947     /**
2948      * @dev Emits an event when an NFT is minted 
2949      * @param minterAddress The address of the user who executed the mint.
2950      * @param amount The amount of NFTs minted.
2951      */
2952     event MintDeviants(
2953         address indexed minterAddress,
2954         uint256 amount
2955     );
2956 
2957     /**
2958      * @dev Emits an event when owner mint a batch.
2959      * @param owner The addresses who is the contract owner.
2960      * @param addresses The addresses array.
2961      * @param amount The amount of NFTs minted for each address.
2962      */
2963     event MintBatch(
2964         address indexed owner,
2965         address[] addresses,
2966         uint256 amount
2967     );
2968     
2969     /**
2970      * @dev Constructor function that sets the initial values for the contract's variables.
2971      * @param uri The metadata URI prefix.
2972      * @param _unrevealedURI The unrevealed URI metadata
2973      * @param _legendaryUnrevealedURI The legendary unrevealed URI metadata
2974      * @param _receiver The receiver address
2975      * @param vrfCoordinatorV2 The ChainLink vrf coordinator address.
2976      * @param _deviantsSilverPassCollection Silver collection address.
2977      * @param _deviantsDiamondPassCollection Dimond collection address.
2978      * @param _deviantsGoldPassCollection Gold collection address.
2979      * @param _deviantsCrimsonPassCollection Crimson collection address.
2980      */
2981     constructor(
2982         string memory uri,
2983         string memory _unrevealedURI,
2984         string memory _legendaryUnrevealedURI,
2985         address _receiver,
2986         address vrfCoordinatorV2,
2987         ERC721A _deviantsSilverPassCollection,
2988         ERC721A _deviantsDiamondPassCollection,
2989         ERC721A _deviantsGoldPassCollection,
2990         ERC721A _deviantsCrimsonPassCollection
2991     )VRFConsumerBaseV2(vrfCoordinatorV2)
2992      ERC721A("Deviants", "DNFT") {
2993         baseURI = uri;
2994         unrevealedURI = _unrevealedURI;
2995         legendaryUnrevealedURI = _legendaryUnrevealedURI;
2996         receiver = _receiver;
2997         deviantsSilverPassCollection = _deviantsSilverPassCollection;
2998         deviantsDiamondPassCollection = _deviantsDiamondPassCollection;
2999         deviantsGoldPassCollection = _deviantsGoldPassCollection; 
3000         deviantsCrimsonPassCollection = _deviantsCrimsonPassCollection;
3001         i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
3002 
3003     }
3004 
3005     /**
3006      * @dev Function that initiate all the chainLink variables
3007      * @param subscriptionId Sets the subscriptionId
3008      * @param gasLane Sets the gasLane
3009      * @param callbackGasLimit Sets the callbackGasLimit 
3010      * @notice Only the contract owner can call this function.
3011      */
3012     function initChainlink(
3013         uint64 subscriptionId,
3014         bytes32 gasLane,
3015         uint32 callbackGasLimit
3016     ) external onlyOwner {
3017         i_subscriptionId = subscriptionId;
3018         i_gasLane = gasLane;
3019         i_callbackGasLimit = callbackGasLimit; 
3020     }
3021 
3022     /**
3023      * @dev Function that asks ChainLink VRF for random numbers
3024      * @notice Only the contract owner can call this function.
3025      */
3026     function askRandomNumber() external onlyOwner  {
3027 
3028         uint256 requestId = i_vrfCoordinator.requestRandomWords(
3029             i_gasLane,
3030             i_subscriptionId,
3031             REQUEST_CONFIRMATIONS,
3032             i_callbackGasLimit,
3033             NUM_WORDS
3034         );
3035         numbersRequested = true;
3036         requestIdNr = requestId;
3037 
3038     }
3039 
3040     /**
3041      * @dev Fallback function called by chainlink after askRandomNumber function is called;
3042      * @param _requestId Id we recived when we called the askRandom function
3043      * @param _randomWords Array with random numbers generated by ChainLink
3044      */
3045     function fulfillRandomWords(
3046         uint256 _requestId,
3047         uint256[] memory _randomWords ) internal override{
3048 
3049         require(numbersRequested == true,"DNFT: number not requested");
3050         require(requestIdNr != 0 , "DNFT:request error");
3051         randomNumber1 = _randomWords[0];
3052         randomNumber2 = _randomWords[1];
3053         numbersReceived = true;
3054     }
3055 
3056      /**
3057       * @dev mintDeviants converts mintPasses into Deviants NFTS.
3058       * @param tokenIdsSilver arrays with tokenIds from Silver collection that user wants to convert to Deviants rate 1-1
3059       * @param tokenIdsDiamond arrays with tokenIds from Diamond collection that user wants to convert to Deviants rate 1-1
3060       * @param tokenIdsGold arrays with tokenIds from Gold collection that user wants to convert to Deviants rate 1-3
3061       * @param tokenIdsCrimson arrays with tokenIds Crimson Silver collection that user wants to convert to Deviants rate 1-1
3062       * @notice Throws if:
3063       * - mint closed if the function is called if the contract is paused.
3064       * - mints exceeded if the minted amount exceeds the maxSupply.
3065       * - mints exceeded if the minted amount exceeds the 9700.
3066       */
3067     function mintDeviants
3068     (uint256[] calldata tokenIdsSilver,
3069      uint256[] calldata tokenIdsDiamond,
3070      uint256[] calldata tokenIdsGold,
3071      uint256[] calldata tokenIdsCrimson) external {
3072 
3073         require(!pauseMint, "DNFT: Mint closed");
3074         uint256 mintAmount = tokenIdsSilver.length + tokenIdsDiamond.length + tokenIdsCrimson.length + tokenIdsGold.length * 3;
3075 
3076         //Crypto.com allocation.
3077         if(!last300On){
3078             require(totalSupply() + mintAmount <= 9700, "DNFT: maxSupply exceeded for now");
3079         }
3080         require(totalSupply() + mintAmount <= maxSupply, "DNFT: maxSupply exceeded");
3081 
3082         for(uint256 i = 0 ; i < tokenIdsSilver.length;i++){
3083             deviantsSilverPassCollection.safeTransferFrom(msg.sender,receiver,tokenIdsSilver[i]);
3084         }
3085         for(uint256 i = 0 ; i < tokenIdsDiamond.length;i++){
3086             deviantsDiamondPassCollection.safeTransferFrom(msg.sender,receiver,tokenIdsDiamond[i]);
3087         }
3088         for(uint256 i = 0 ; i < tokenIdsGold.length;i++){
3089             deviantsGoldPassCollection.safeTransferFrom(msg.sender,receiver,tokenIdsGold[i]);
3090         }
3091         for(uint256 i = 0 ; i < tokenIdsCrimson.length;i++){
3092             deviantsCrimsonPassCollection.safeTransferFrom(msg.sender,receiver,tokenIdsCrimson[i]);
3093         }
3094         _safeMint(msg.sender,mintAmount);
3095         emit MintDeviants(msg.sender,mintAmount);
3096     }
3097 
3098     /**
3099      * @dev Function to mint a batch of NFTs to multiple addresses
3100      * @param addresses An array of addresses to mint NFTs to
3101      * @param _mintAmounts The amount of NFTs to mint to each address
3102      * @notice Only the contract owner can call this function.
3103      */
3104     function mintBatch(address[] memory addresses, uint256 _mintAmounts) external onlyOwner{
3105         require(totalSupply() + addresses.length * _mintAmounts <= maxSupply,"DNFT: maxSupply exceeded");
3106 
3107         for(uint256 i = 0;i < addresses.length; i++){
3108             _safeMint(addresses[i],_mintAmounts);
3109         }
3110         emit MintBatch(msg.sender, addresses, _mintAmounts);
3111     }
3112 
3113     /**
3114      * @dev This function sets the base URI of the NFT contract.
3115      * @param uri The new base URI of the NFT contract.
3116      * @notice Only the contract owner can call this function.
3117      */
3118     function setBasedURI(string memory uri) external onlyOwner{
3119         baseURI = uri;
3120     }
3121 
3122     /**
3123      * @dev Set the pause state of the contract, only the contract owner can set the pause state
3124      * @param state Boolean state of the pause, true means that the contract is paused, false means that the contract is not paused
3125      */
3126     function setPauseMint(bool state) external onlyOwner{
3127         pauseMint = state;
3128     }
3129 
3130     /**
3131      * @dev Sets the uriSuffix for the ERC-721A token metadata.
3132      * @param _uriSuffix The new uriSuffix to be set.
3133      */
3134     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
3135         uriSuffix = _uriSuffix;
3136     }
3137 
3138     /**
3139      * @dev Sets the unrevealedURI for the ERC-721A token metadata.
3140      * @param _unrevealedURI The new _unrevealedURI to be set.
3141      */
3142     function setUnrevealedURI(string memory _unrevealedURI) public onlyOwner{
3143         unrevealedURI = _unrevealedURI;
3144     }
3145 
3146     /**
3147      * @dev Sets the legendaryUnrevealedURI for the ERC-721A token metadata.
3148      * @param _legendaryUnrevealedURI The new legendaryUnrevealedURI to be set.
3149      */
3150     function setLegendaryUnrevealedURI(string memory _legendaryUnrevealedURI) public onlyOwner{
3151         legendaryUnrevealedURI = _legendaryUnrevealedURI;
3152     }
3153 
3154     /**
3155      * @dev Sets the receiver.
3156      * @param _receiver The new receiver.
3157      */
3158     function setReceiver(address _receiver) public onlyOwner {
3159         receiver = _receiver;
3160     }
3161 
3162     /**
3163      * @dev Sets the revealed state of the contract.
3164      * @param state State of the revealed.
3165      */
3166     function setRevealed(bool state) public onlyOwner {
3167         revealed = state;
3168     }
3169 
3170     /**
3171      * @dev Allow users to mint the las 300 nfts
3172      * @param state If set to true, users can mint the tokenIDS from 9700 to 10000
3173      */
3174     function setLast300On(bool state) public onlyOwner{
3175         last300On = state;
3176     }
3177 
3178     /**
3179      * @dev blockMarketplaces from listing our nft.
3180      * @param marketplace marketplace address
3181      * @param state checks if the marketplace is blocked or not
3182      */
3183     function setBlokedMarketplaces(address marketplace, bool state) public onlyOwner{
3184         blockedMarketplaces[marketplace] = state;
3185     }
3186 
3187     /**
3188      * setters for deviantsPASS Addresses;
3189      */
3190     function setDeviantsSilverPassCollection(ERC721A _deviantsSilverPassCollection) external onlyOwner{
3191         deviantsSilverPassCollection = _deviantsSilverPassCollection;
3192     }
3193 
3194     function setDeviantsDiamondPassCollection(ERC721A _deviantsDiamondPassCollection) external onlyOwner{
3195         deviantsDiamondPassCollection = _deviantsDiamondPassCollection;
3196     }
3197 
3198     function setDeviantsGoldPassCollection(ERC721A _deviantsGoldPassCollection) external onlyOwner{
3199         deviantsGoldPassCollection = _deviantsGoldPassCollection;
3200     }
3201 
3202     function setDeviantsCrimsonPassCollection(ERC721A _deviantsCrimsonPassCollection) external onlyOwner{
3203         deviantsCrimsonPassCollection = _deviantsCrimsonPassCollection;
3204     }
3205 
3206 
3207     /**
3208      * @dev Returns the total amount of Deviants one user can mint (Silver + Dimond + Gold*3 + Crimson)
3209      */
3210     function getUserStatus(address holder) public view returns(uint256){
3211         uint256 userMintAmount = deviantsSilverPassCollection.balanceOf(holder) + deviantsDiamondPassCollection.balanceOf(holder) + deviantsCrimsonPassCollection.balanceOf(holder) + deviantsGoldPassCollection.balanceOf(holder) * 3;
3212         return userMintAmount;
3213     }
3214 
3215     /**
3216     * @dev Returns the starting token ID for the token.
3217     * @return uint256 The starting token ID for the token.
3218     */
3219     function _startTokenId() internal view virtual override returns (uint256) {
3220         return 1;
3221     }
3222 
3223     /**
3224      * @dev Returns the token URI for the given token ID. Throws if the token ID does not exist
3225      * @param _tokenId The token ID to retrieve the URI for
3226      * @notice Retrieve the URI for the given token ID
3227      * @return The token URI for the given token ID
3228      */
3229     function tokenURI(uint256 _tokenId) public view virtual override(ERC721A,IERC721A) returns (string memory) {
3230         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
3231 
3232          if (revealed == false) {
3233             if(_tokenId <=15){
3234                 return legendaryUnrevealedURI;
3235             }else{
3236                 return unrevealedURI;
3237             }
3238         }
3239         string memory currentBaseURI = _baseURI();
3240         return bytes(currentBaseURI).length > 0
3241             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
3242             : '';
3243     }
3244         
3245     /**
3246      * @dev Returns the current base URI.
3247      * @return The base URI of the contract.
3248      */
3249     function _baseURI() internal view virtual override returns (string memory) {
3250         return baseURI;
3251     }
3252 
3253     // DefaultOperatorFilterer functions
3254 
3255     function setApprovalForAll(address operator, bool approved) public  override(ERC721A,IERC721A) onlyAllowedOperatorApproval(operator) {
3256         require(!blockedMarketplaces[operator],"DNFT: Invalid marketplace");
3257         super.setApprovalForAll(operator, approved);
3258     }
3259 
3260     function approve(address operator, uint256 tokenId) public payable override(ERC721A,IERC721A) onlyAllowedOperatorApproval(operator) {
3261         require(!blockedMarketplaces[operator],"DNFT: Invalid marketplace");
3262         super.approve(operator, tokenId);
3263     }
3264 
3265     function transferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A,IERC721A) onlyAllowedOperator(from) {
3266         require(!blockedMarketplaces[to],"DNFT: Invalid marketplace");
3267         super.transferFrom(from, to, tokenId);
3268     }
3269 
3270     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A,IERC721A) onlyAllowedOperator(from) {
3271         require(!blockedMarketplaces[to],"DNFT: Invalid marketplace");
3272         super.safeTransferFrom(from, to, tokenId);
3273     }
3274 
3275     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3276         public
3277         payable 
3278         override(ERC721A,IERC721A)
3279         onlyAllowedOperator(from)
3280     {
3281         require(!blockedMarketplaces[to],"DNFT: Invalid marketplace");
3282         super.safeTransferFrom(from, to, tokenId, data);
3283     }
3284 }