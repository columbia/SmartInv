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
143 
144   /**
145    * @notice Returns the global config that applies to all VRF requests.
146    * @return minimumRequestBlockConfirmations - A minimum number of confirmation
147    * blocks on VRF requests before oracles should respond.
148    * @return fulfillmentFlatFeeLinkPPM - The charge per request on top of the gas fees.
149    * Its flat fee specified in millionths of LINK.
150    * @return maxGasLimit - The maximum gas limit supported for a fulfillRandomWords callback.
151    * @return stalenessSeconds - How long we wait until we consider the ETH/LINK price
152    * (used for converting gas costs to LINK) is stale and use `fallbackWeiPerUnitLink`
153    * @return gasAfterPaymentCalculation - How much gas is used outside of the payment calculation,
154    * i.e. the gas overhead of actually making the payment to oracles.
155    * @return minimumSubscriptionBalance - The minimum subscription balance required to make a request. Its set to be about 300%
156    * of the cost of a single request to handle in ETH/LINK price between request and fulfillment time.
157    * @return fallbackWeiPerUnitLink - fallback ETH/LINK price in the case of a stale feed.
158    */
159   function getConfig()
160   external
161   view
162   returns (
163     uint16 minimumRequestBlockConfirmations,
164     uint32 fulfillmentFlatFeeLinkPPM,
165     uint32 maxGasLimit,
166     uint32 stalenessSeconds,
167     uint32 gasAfterPaymentCalculation,
168     uint96 minimumSubscriptionBalance,
169     int256 fallbackWeiPerUnitLink
170   );
171 
172   /**
173    * @notice Request a set of random words.
174    * @param keyHash - Corresponds to a particular oracle job which uses
175    * that key for generating the VRF proof. Different keyHash's have different gas price
176    * ceilings, so you can select a specific one to bound your maximum per request cost.
177    * @param subId  - The ID of the VRF subscription. Must be funded
178    * with at least minimumSubscriptionBalance (see getConfig) LINK
179    * before making a request.
180    * @param minimumRequestConfirmations - How many blocks you'd like the
181    * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
182    * for why you may want to request more. The acceptable range is
183    * [minimumRequestBlockConfirmations, 200].
184    * @param callbackGasLimit - How much gas you'd like to receive in your
185    * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
186    * may be slightly less than this amount because of gas used calling the function
187    * (argument decoding etc.), so you may need to request slightly more than you expect
188    * to have inside fulfillRandomWords. The acceptable range is
189    * [5000, maxGasLimit].
190    * @param numWords - The number of uint256 random values you'd like to receive
191    * in your fulfillRandomWords callback. Note these numbers are expanded in a
192    * secure way by the VRFCoordinator from a single random value supplied by the oracle.
193    * @return requestId - A unique identifier of the request. Can be used to match
194    * a request to a response in fulfillRandomWords.
195    */
196   function requestRandomWords(
197     bytes32 keyHash,
198     uint64  subId,
199     uint16  minimumRequestConfirmations,
200     uint32  callbackGasLimit,
201     uint32  numWords
202   )
203     external
204     returns (
205       uint256 requestId
206     );
207 
208   /**
209    * @notice Create a VRF subscription.
210    * @return subId - A unique subscription id.
211    * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
212    * @dev Note to fund the subscription, use transferAndCall. For example
213    * @dev  LINKTOKEN.transferAndCall(
214    * @dev    address(COORDINATOR),
215    * @dev    amount,
216    * @dev    abi.encode(subId));
217    */
218   function createSubscription()
219     external
220     returns (
221       uint64 subId
222     );
223 
224   /**
225    * @notice Get a VRF subscription.
226    * @param subId - ID of the subscription
227    * @return balance - LINK balance of the subscription in juels.
228    * @return owner - Owner of the subscription
229    * @return consumers - List of consumer address which are able to use this subscription.
230    */
231   function getSubscription(
232     uint64 subId
233   )
234     external
235     view
236     returns (
237       uint96 balance,
238       address owner,
239       address[] memory consumers
240     );
241 
242   /**
243    * @notice Request subscription owner transfer.
244    * @param subId - ID of the subscription
245    * @param newOwner - proposed new owner of the subscription
246    */
247   function requestSubscriptionOwnerTransfer(
248     uint64 subId,
249     address newOwner
250   )
251     external;
252 
253   /**
254    * @notice Request subscription owner transfer.
255    * @param subId - ID of the subscription
256    * @dev will revert if original owner of subId has
257    * not requested that msg.sender become the new owner.
258    */
259   function acceptSubscriptionOwnerTransfer(
260     uint64 subId
261   )
262     external;
263 
264   /**
265    * @notice Add a consumer to a VRF subscription.
266    * @param subId - ID of the subscription
267    * @param consumer - New consumer which can use the subscription
268    */
269   function addConsumer(
270     uint64 subId,
271     address consumer
272   )
273     external;
274 
275   /**
276    * @notice Remove a consumer from a VRF subscription.
277    * @param subId - ID of the subscription
278    * @param consumer - Consumer to remove from the subscription
279    */
280   function removeConsumer(
281     uint64 subId,
282     address consumer
283   )
284     external;
285 
286   /**
287    * @notice Withdraw funds from a VRF subscription
288    * @param subId - ID of the subscription
289    * @param to - Where to send the withdrawn LINK to
290    * @param amount - How much to withdraw in juels
291    */
292   function defundSubscription(
293     uint64 subId,
294     address to,
295     uint96 amount
296   )
297     external;
298 
299   /**
300    * @notice Cancel a subscription
301    * @param subId - ID of the subscription
302    * @param to - Where to send the remaining LINK to
303    */
304   function cancelSubscription(
305     uint64 subId,
306     address to
307   )
308     external;
309 }
310 
311 // File: @openzeppelin/contracts/utils/Counters.sol
312 
313 
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @title Counters
319  * @author Matt Condon (@shrugs)
320  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
321  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
322  *
323  * Include with `using Counters for Counters.Counter;`
324  */
325 library Counters {
326     struct Counter {
327         // This variable should never be directly accessed by users of the library: interactions must be restricted to
328         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
329         // this feature: see https://github.com/ethereum/solidity/issues/4637
330         uint256 _value; // default: 0
331     }
332 
333     function current(Counter storage counter) internal view returns (uint256) {
334         return counter._value;
335     }
336 
337     function increment(Counter storage counter) internal {
338         unchecked {
339             counter._value += 1;
340         }
341     }
342 
343     function decrement(Counter storage counter) internal {
344         uint256 value = counter._value;
345         require(value > 0, "Counter: decrement overflow");
346         unchecked {
347             counter._value = value - 1;
348         }
349     }
350 
351     function reset(Counter storage counter) internal {
352         counter._value = 0;
353     }
354 }
355 
356 // File: @openzeppelin/contracts/utils/Strings.sol
357 
358 
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev String operations.
364  */
365 library Strings {
366     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
367 
368     /**
369      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
370      */
371     function toString(uint256 value) internal pure returns (string memory) {
372         // Inspired by OraclizeAPI's implementation - MIT licence
373         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
374 
375         if (value == 0) {
376             return "0";
377         }
378         uint256 temp = value;
379         uint256 digits;
380         while (temp != 0) {
381             digits++;
382             temp /= 10;
383         }
384         bytes memory buffer = new bytes(digits);
385         while (value != 0) {
386             digits -= 1;
387             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
388             value /= 10;
389         }
390         return string(buffer);
391     }
392 
393     /**
394      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
395      */
396     function toHexString(uint256 value) internal pure returns (string memory) {
397         if (value == 0) {
398             return "0x00";
399         }
400         uint256 temp = value;
401         uint256 length = 0;
402         while (temp != 0) {
403             length++;
404             temp >>= 8;
405         }
406         return toHexString(value, length);
407     }
408 
409     /**
410      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
411      */
412     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
413         bytes memory buffer = new bytes(2 * length + 2);
414         buffer[0] = "0";
415         buffer[1] = "x";
416         for (uint256 i = 2 * length + 1; i > 1; --i) {
417             buffer[i] = _HEX_SYMBOLS[value & 0xf];
418             value >>= 4;
419         }
420         require(value == 0, "Strings: hex length insufficient");
421         return string(buffer);
422     }
423 }
424 
425 // File: @openzeppelin/contracts/utils/Context.sol
426 
427 
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @dev Provides information about the current execution context, including the
433  * sender of the transaction and its data. While these are generally available
434  * via msg.sender and msg.data, they should not be accessed in such a direct
435  * manner, since when dealing with meta-transactions the account sending and
436  * paying for execution may not be the actual sender (as far as an application
437  * is concerned).
438  *
439  * This contract is only required for intermediate, library-like contracts.
440  */
441 abstract contract Context {
442     function _msgSender() internal view virtual returns (address) {
443         return msg.sender;
444     }
445 
446     function _msgData() internal view virtual returns (bytes calldata) {
447         return msg.data;
448     }
449 }
450 
451 // File: @openzeppelin/contracts/access/Ownable.sol
452 
453 
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Contract module which provides a basic access control mechanism, where
460  * there is an account (an owner) that can be granted exclusive access to
461  * specific functions.
462  *
463  * By default, the owner account will be the one that deploys the contract. This
464  * can later be changed with {transferOwnership}.
465  *
466  * This module is used through inheritance. It will make available the modifier
467  * `onlyOwner`, which can be applied to your functions to restrict their use to
468  * the owner.
469  */
470 abstract contract Ownable is Context {
471     address private _owner;
472 
473     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
474 
475     /**
476      * @dev Initializes the contract setting the deployer as the initial owner.
477      */
478     constructor() {
479         _setOwner(_msgSender());
480     }
481 
482     /**
483      * @dev Returns the address of the current owner.
484      */
485     function owner() public view virtual returns (address) {
486         return _owner;
487     }
488 
489     /**
490      * @dev Throws if called by any account other than the owner.
491      */
492     modifier onlyOwner() {
493         require(owner() == _msgSender(), "Ownable: caller is not the owner");
494         _;
495     }
496 
497     /**
498      * @dev Leaves the contract without owner. It will not be possible to call
499      * `onlyOwner` functions anymore. Can only be called by the current owner.
500      *
501      * NOTE: Renouncing ownership will leave the contract without an owner,
502      * thereby removing any functionality that is only available to the owner.
503      */
504     function renounceOwnership() public virtual onlyOwner {
505         _setOwner(address(0));
506     }
507 
508     /**
509      * @dev Transfers ownership of the contract to a new account (`newOwner`).
510      * Can only be called by the current owner.
511      */
512     function transferOwnership(address newOwner) public virtual onlyOwner {
513         require(newOwner != address(0), "Ownable: new owner is the zero address");
514         _setOwner(newOwner);
515     }
516 
517     function _setOwner(address newOwner) private {
518         address oldOwner = _owner;
519         _owner = newOwner;
520         emit OwnershipTransferred(oldOwner, newOwner);
521     }
522 }
523 
524 // File: @openzeppelin/contracts/security/Pausable.sol
525 
526 
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Contract module which allows children to implement an emergency stop
533  * mechanism that can be triggered by an authorized account.
534  *
535  * This module is used through inheritance. It will make available the
536  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
537  * the functions of your contract. Note that they will not be pausable by
538  * simply including this module, only once the modifiers are put in place.
539  */
540 abstract contract Pausable is Context {
541     /**
542      * @dev Emitted when the pause is triggered by `account`.
543      */
544     event Paused(address account);
545 
546     /**
547      * @dev Emitted when the pause is lifted by `account`.
548      */
549     event Unpaused(address account);
550 
551     bool private _paused;
552 
553     /**
554      * @dev Initializes the contract in unpaused state.
555      */
556     constructor() {
557         _paused = false;
558     }
559 
560     /**
561      * @dev Returns true if the contract is paused, and false otherwise.
562      */
563     function paused() public view virtual returns (bool) {
564         return _paused;
565     }
566 
567     /**
568      * @dev Modifier to make a function callable only when the contract is not paused.
569      *
570      * Requirements:
571      *
572      * - The contract must not be paused.
573      */
574     modifier whenNotPaused() {
575         require(!paused(), "Pausable: paused");
576         _;
577     }
578 
579     /**
580      * @dev Modifier to make a function callable only when the contract is paused.
581      *
582      * Requirements:
583      *
584      * - The contract must be paused.
585      */
586     modifier whenPaused() {
587         require(paused(), "Pausable: not paused");
588         _;
589     }
590 
591     /**
592      * @dev Triggers stopped state.
593      *
594      * Requirements:
595      *
596      * - The contract must not be paused.
597      */
598     function _pause() internal virtual whenNotPaused {
599         _paused = true;
600         emit Paused(_msgSender());
601     }
602 
603     /**
604      * @dev Returns to normal state.
605      *
606      * Requirements:
607      *
608      * - The contract must be paused.
609      */
610     function _unpause() internal virtual whenPaused {
611         _paused = false;
612         emit Unpaused(_msgSender());
613     }
614 }
615 
616 // File: @openzeppelin/contracts/utils/Address.sol
617 
618 
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Collection of functions related to the address type
624  */
625 library Address {
626     /**
627      * @dev Returns true if `account` is a contract.
628      *
629      * [IMPORTANT]
630      * ====
631      * It is unsafe to assume that an address for which this function returns
632      * false is an externally-owned account (EOA) and not a contract.
633      *
634      * Among others, `isContract` will return false for the following
635      * types of addresses:
636      *
637      *  - an externally-owned account
638      *  - a contract in construction
639      *  - an address where a contract will be created
640      *  - an address where a contract lived, but was destroyed
641      * ====
642      */
643     function isContract(address account) internal view returns (bool) {
644         // This method relies on extcodesize, which returns 0 for contracts in
645         // construction, since the code is only stored at the end of the
646         // constructor execution.
647 
648         uint256 size;
649         assembly {
650             size := extcodesize(account)
651         }
652         return size > 0;
653     }
654 
655     /**
656      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
657      * `recipient`, forwarding all available gas and reverting on errors.
658      *
659      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
660      * of certain opcodes, possibly making contracts go over the 2300 gas limit
661      * imposed by `transfer`, making them unable to receive funds via
662      * `transfer`. {sendValue} removes this limitation.
663      *
664      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
665      *
666      * IMPORTANT: because control is transferred to `recipient`, care must be
667      * taken to not create reentrancy vulnerabilities. Consider using
668      * {ReentrancyGuard} or the
669      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
670      */
671     function sendValue(address payable recipient, uint256 amount) internal {
672         require(address(this).balance >= amount, "Address: insufficient balance");
673 
674         (bool success, ) = recipient.call{value: amount}("");
675         require(success, "Address: unable to send value, recipient may have reverted");
676     }
677 
678     /**
679      * @dev Performs a Solidity function call using a low level `call`. A
680      * plain `call` is an unsafe replacement for a function call: use this
681      * function instead.
682      *
683      * If `target` reverts with a revert reason, it is bubbled up by this
684      * function (like regular Solidity function calls).
685      *
686      * Returns the raw returned data. To convert to the expected return value,
687      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
688      *
689      * Requirements:
690      *
691      * - `target` must be a contract.
692      * - calling `target` with `data` must not revert.
693      *
694      * _Available since v3.1._
695      */
696     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
697         return functionCall(target, data, "Address: low-level call failed");
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
702      * `errorMessage` as a fallback revert reason when `target` reverts.
703      *
704      * _Available since v3.1._
705      */
706     function functionCall(
707         address target,
708         bytes memory data,
709         string memory errorMessage
710     ) internal returns (bytes memory) {
711         return functionCallWithValue(target, data, 0, errorMessage);
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
716      * but also transferring `value` wei to `target`.
717      *
718      * Requirements:
719      *
720      * - the calling contract must have an ETH balance of at least `value`.
721      * - the called Solidity function must be `payable`.
722      *
723      * _Available since v3.1._
724      */
725     function functionCallWithValue(
726         address target,
727         bytes memory data,
728         uint256 value
729     ) internal returns (bytes memory) {
730         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
735      * with `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCallWithValue(
740         address target,
741         bytes memory data,
742         uint256 value,
743         string memory errorMessage
744     ) internal returns (bytes memory) {
745         require(address(this).balance >= value, "Address: insufficient balance for call");
746         require(isContract(target), "Address: call to non-contract");
747 
748         (bool success, bytes memory returndata) = target.call{value: value}(data);
749         return verifyCallResult(success, returndata, errorMessage);
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
754      * but performing a static call.
755      *
756      * _Available since v3.3._
757      */
758     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
759         return functionStaticCall(target, data, "Address: low-level static call failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
764      * but performing a static call.
765      *
766      * _Available since v3.3._
767      */
768     function functionStaticCall(
769         address target,
770         bytes memory data,
771         string memory errorMessage
772     ) internal view returns (bytes memory) {
773         require(isContract(target), "Address: static call to non-contract");
774 
775         (bool success, bytes memory returndata) = target.staticcall(data);
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a delegate call.
782      *
783      * _Available since v3.4._
784      */
785     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
786         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a delegate call.
792      *
793      * _Available since v3.4._
794      */
795     function functionDelegateCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal returns (bytes memory) {
800         require(isContract(target), "Address: delegate call to non-contract");
801 
802         (bool success, bytes memory returndata) = target.delegatecall(data);
803         return verifyCallResult(success, returndata, errorMessage);
804     }
805 
806     /**
807      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
808      * revert reason using the provided one.
809      *
810      * _Available since v4.3._
811      */
812     function verifyCallResult(
813         bool success,
814         bytes memory returndata,
815         string memory errorMessage
816     ) internal pure returns (bytes memory) {
817         if (success) {
818             return returndata;
819         } else {
820             // Look for revert reason and bubble it up if present
821             if (returndata.length > 0) {
822                 // The easiest way to bubble the revert reason is using memory via assembly
823 
824                 assembly {
825                     let returndata_size := mload(returndata)
826                     revert(add(32, returndata), returndata_size)
827                 }
828             } else {
829                 revert(errorMessage);
830             }
831         }
832     }
833 }
834 
835 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
836 
837 
838 
839 pragma solidity ^0.8.0;
840 
841 /**
842  * @title ERC721 token receiver interface
843  * @dev Interface for any contract that wants to support safeTransfers
844  * from ERC721 asset contracts.
845  */
846 interface IERC721Receiver {
847     /**
848      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
849      * by `operator` from `from`, this function is called.
850      *
851      * It must return its Solidity selector to confirm the token transfer.
852      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
853      *
854      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
855      */
856     function onERC721Received(
857         address operator,
858         address from,
859         uint256 tokenId,
860         bytes calldata data
861     ) external returns (bytes4);
862 }
863 
864 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
865 
866 
867 
868 pragma solidity ^0.8.0;
869 
870 /**
871  * @dev Interface of the ERC165 standard, as defined in the
872  * https://eips.ethereum.org/EIPS/eip-165[EIP].
873  *
874  * Implementers can declare support of contract interfaces, which can then be
875  * queried by others ({ERC165Checker}).
876  *
877  * For an implementation, see {ERC165}.
878  */
879 interface IERC165 {
880     /**
881      * @dev Returns true if this contract implements the interface defined by
882      * `interfaceId`. See the corresponding
883      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
884      * to learn more about how these ids are created.
885      *
886      * This function call must use less than 30 000 gas.
887      */
888     function supportsInterface(bytes4 interfaceId) external view returns (bool);
889 }
890 
891 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
892 
893 
894 
895 pragma solidity ^0.8.0;
896 
897 
898 /**
899  * @dev Implementation of the {IERC165} interface.
900  *
901  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
902  * for the additional interface id that will be supported. For example:
903  *
904  * ```solidity
905  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
906  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
907  * }
908  * ```
909  *
910  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
911  */
912 abstract contract ERC165 is IERC165 {
913     /**
914      * @dev See {IERC165-supportsInterface}.
915      */
916     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
917         return interfaceId == type(IERC165).interfaceId;
918     }
919 }
920 
921 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
922 
923 
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @dev Required interface of an ERC721 compliant contract.
930  */
931 interface IERC721 is IERC165 {
932     /**
933      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
934      */
935     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
936 
937     /**
938      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
939      */
940     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
941 
942     /**
943      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
944      */
945     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
946 
947     /**
948      * @dev Returns the number of tokens in ``owner``'s account.
949      */
950     function balanceOf(address owner) external view returns (uint256 balance);
951 
952     /**
953      * @dev Returns the owner of the `tokenId` token.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      */
959     function ownerOf(uint256 tokenId) external view returns (address owner);
960 
961     /**
962      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
963      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
964      *
965      * Requirements:
966      *
967      * - `from` cannot be the zero address.
968      * - `to` cannot be the zero address.
969      * - `tokenId` token must exist and be owned by `from`.
970      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
971      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
972      *
973      * Emits a {Transfer} event.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId
979     ) external;
980 
981     /**
982      * @dev Transfers `tokenId` token from `from` to `to`.
983      *
984      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
985      *
986      * Requirements:
987      *
988      * - `from` cannot be the zero address.
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must be owned by `from`.
991      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
992      *
993      * Emits a {Transfer} event.
994      */
995     function transferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) external;
1000 
1001     /**
1002      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1003      * The approval is cleared when the token is transferred.
1004      *
1005      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1006      *
1007      * Requirements:
1008      *
1009      * - The caller must own the token or be an approved operator.
1010      * - `tokenId` must exist.
1011      *
1012      * Emits an {Approval} event.
1013      */
1014     function approve(address to, uint256 tokenId) external;
1015 
1016     /**
1017      * @dev Returns the account approved for `tokenId` token.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function getApproved(uint256 tokenId) external view returns (address operator);
1024 
1025     /**
1026      * @dev Approve or remove `operator` as an operator for the caller.
1027      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1028      *
1029      * Requirements:
1030      *
1031      * - The `operator` cannot be the caller.
1032      *
1033      * Emits an {ApprovalForAll} event.
1034      */
1035     function setApprovalForAll(address operator, bool _approved) external;
1036 
1037     /**
1038      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1039      *
1040      * See {setApprovalForAll}
1041      */
1042     function isApprovedForAll(address owner, address operator) external view returns (bool);
1043 
1044     /**
1045      * @dev Safely transfers `tokenId` token from `from` to `to`.
1046      *
1047      * Requirements:
1048      *
1049      * - `from` cannot be the zero address.
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must exist and be owned by `from`.
1052      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1053      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function safeTransferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes calldata data
1062     ) external;
1063 }
1064 
1065 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1066 
1067 
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 
1072 /**
1073  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1074  * @dev See https://eips.ethereum.org/EIPS/eip-721
1075  */
1076 interface IERC721Metadata is IERC721 {
1077     /**
1078      * @dev Returns the token collection name.
1079      */
1080     function name() external view returns (string memory);
1081 
1082     /**
1083      * @dev Returns the token collection symbol.
1084      */
1085     function symbol() external view returns (string memory);
1086 
1087     /**
1088      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1089      */
1090     function tokenURI(uint256 tokenId) external view returns (string memory);
1091 }
1092 
1093 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1094 
1095 
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 
1101 
1102 
1103 
1104 
1105 
1106 /**
1107  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1108  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1109  * {ERC721Enumerable}.
1110  */
1111 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1112     using Address for address;
1113     using Strings for uint256;
1114 
1115     // Token name
1116     string private _name;
1117 
1118     // Token symbol
1119     string private _symbol;
1120 
1121     // Mapping from token ID to owner address
1122     mapping(uint256 => address) private _owners;
1123 
1124     // Mapping owner address to token count
1125     mapping(address => uint256) private _balances;
1126 
1127     // Mapping from token ID to approved address
1128     mapping(uint256 => address) private _tokenApprovals;
1129 
1130     // Mapping from owner to operator approvals
1131     mapping(address => mapping(address => bool)) private _operatorApprovals;
1132 
1133     /**
1134      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1135      */
1136     constructor(string memory name_, string memory symbol_) {
1137         _name = name_;
1138         _symbol = symbol_;
1139     }
1140 
1141     /**
1142      * @dev See {IERC165-supportsInterface}.
1143      */
1144     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1145         return
1146             interfaceId == type(IERC721).interfaceId ||
1147             interfaceId == type(IERC721Metadata).interfaceId ||
1148             super.supportsInterface(interfaceId);
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-balanceOf}.
1153      */
1154     function balanceOf(address owner) public view virtual override returns (uint256) {
1155         require(owner != address(0), "ERC721: balance query for the zero address");
1156         return _balances[owner];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-ownerOf}.
1161      */
1162     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1163         address owner = _owners[tokenId];
1164         require(owner != address(0), "ERC721: owner query for nonexistent token");
1165         return owner;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Metadata-name}.
1170      */
1171     function name() public view virtual override returns (string memory) {
1172         return _name;
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Metadata-symbol}.
1177      */
1178     function symbol() public view virtual override returns (string memory) {
1179         return _symbol;
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Metadata-tokenURI}.
1184      */
1185     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1186         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1187 
1188         string memory baseURI = _baseURI();
1189         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1190     }
1191 
1192     /**
1193      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1194      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1195      * by default, can be overriden in child contracts.
1196      */
1197     function _baseURI() internal view virtual returns (string memory) {
1198         return "";
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-approve}.
1203      */
1204     function approve(address to, uint256 tokenId) public virtual override {
1205         address owner = ERC721.ownerOf(tokenId);
1206         require(to != owner, "ERC721: approval to current owner");
1207 
1208         require(
1209             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1210             "ERC721: approve caller is not owner nor approved for all"
1211         );
1212 
1213         _approve(to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-getApproved}.
1218      */
1219     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1220         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1221 
1222         return _tokenApprovals[tokenId];
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-setApprovalForAll}.
1227      */
1228     function setApprovalForAll(address operator, bool approved) public virtual override {
1229         require(operator != _msgSender(), "ERC721: approve to caller");
1230 
1231         _operatorApprovals[_msgSender()][operator] = approved;
1232         emit ApprovalForAll(_msgSender(), operator, approved);
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-isApprovedForAll}.
1237      */
1238     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1239         return _operatorApprovals[owner][operator];
1240     }
1241 
1242     /**
1243      * @dev See {IERC721-transferFrom}.
1244      */
1245     function transferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) public virtual override {
1250         //solhint-disable-next-line max-line-length
1251         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1252 
1253         _transfer(from, to, tokenId);
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-safeTransferFrom}.
1258      */
1259     function safeTransferFrom(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) public virtual override {
1264         safeTransferFrom(from, to, tokenId, "");
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-safeTransferFrom}.
1269      */
1270     function safeTransferFrom(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes memory _data
1275     ) public virtual override {
1276         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1277         _safeTransfer(from, to, tokenId, _data);
1278     }
1279 
1280     /**
1281      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1282      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1283      *
1284      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1285      *
1286      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1287      * implement alternative mechanisms to perform token transfer, such as signature-based.
1288      *
1289      * Requirements:
1290      *
1291      * - `from` cannot be the zero address.
1292      * - `to` cannot be the zero address.
1293      * - `tokenId` token must exist and be owned by `from`.
1294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1295      *
1296      * Emits a {Transfer} event.
1297      */
1298     function _safeTransfer(
1299         address from,
1300         address to,
1301         uint256 tokenId,
1302         bytes memory _data
1303     ) internal virtual {
1304         _transfer(from, to, tokenId);
1305         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1306     }
1307 
1308     /**
1309      * @dev Returns whether `tokenId` exists.
1310      *
1311      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1312      *
1313      * Tokens start existing when they are minted (`_mint`),
1314      * and stop existing when they are burned (`_burn`).
1315      */
1316     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1317         return _owners[tokenId] != address(0);
1318     }
1319 
1320     /**
1321      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1322      *
1323      * Requirements:
1324      *
1325      * - `tokenId` must exist.
1326      */
1327     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1328         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1329         address owner = ERC721.ownerOf(tokenId);
1330         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1331     }
1332 
1333     /**
1334      * @dev Safely mints `tokenId` and transfers it to `to`.
1335      *
1336      * Requirements:
1337      *
1338      * - `tokenId` must not exist.
1339      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1340      *
1341      * Emits a {Transfer} event.
1342      */
1343     function _safeMint(address to, uint256 tokenId) internal virtual {
1344         _safeMint(to, tokenId, "");
1345     }
1346 
1347     /**
1348      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1349      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1350      */
1351     function _safeMint(
1352         address to,
1353         uint256 tokenId,
1354         bytes memory _data
1355     ) internal virtual {
1356         _mint(to, tokenId);
1357         require(
1358             _checkOnERC721Received(address(0), to, tokenId, _data),
1359             "ERC721: transfer to non ERC721Receiver implementer"
1360         );
1361     }
1362 
1363     /**
1364      * @dev Mints `tokenId` and transfers it to `to`.
1365      *
1366      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1367      *
1368      * Requirements:
1369      *
1370      * - `tokenId` must not exist.
1371      * - `to` cannot be the zero address.
1372      *
1373      * Emits a {Transfer} event.
1374      */
1375     function _mint(address to, uint256 tokenId) internal virtual {
1376         require(to != address(0), "ERC721: mint to the zero address");
1377         require(!_exists(tokenId), "ERC721: token already minted");
1378 
1379         _beforeTokenTransfer(address(0), to, tokenId);
1380 
1381         _balances[to] += 1;
1382         _owners[tokenId] = to;
1383 
1384         emit Transfer(address(0), to, tokenId);
1385     }
1386 
1387     /**
1388      * @dev Destroys `tokenId`.
1389      * The approval is cleared when the token is burned.
1390      *
1391      * Requirements:
1392      *
1393      * - `tokenId` must exist.
1394      *
1395      * Emits a {Transfer} event.
1396      */
1397     function _burn(uint256 tokenId) internal virtual {
1398         address owner = ERC721.ownerOf(tokenId);
1399 
1400         _beforeTokenTransfer(owner, address(0), tokenId);
1401 
1402         // Clear approvals
1403         _approve(address(0), tokenId);
1404 
1405         _balances[owner] -= 1;
1406         delete _owners[tokenId];
1407 
1408         emit Transfer(owner, address(0), tokenId);
1409     }
1410 
1411     /**
1412      * @dev Transfers `tokenId` from `from` to `to`.
1413      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1414      *
1415      * Requirements:
1416      *
1417      * - `to` cannot be the zero address.
1418      * - `tokenId` token must be owned by `from`.
1419      *
1420      * Emits a {Transfer} event.
1421      */
1422     function _transfer(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) internal virtual {
1427         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1428         require(to != address(0), "ERC721: transfer to the zero address");
1429 
1430         _beforeTokenTransfer(from, to, tokenId);
1431 
1432         // Clear approvals from the previous owner
1433         _approve(address(0), tokenId);
1434 
1435         _balances[from] -= 1;
1436         _balances[to] += 1;
1437         _owners[tokenId] = to;
1438 
1439         emit Transfer(from, to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev Approve `to` to operate on `tokenId`
1444      *
1445      * Emits a {Approval} event.
1446      */
1447     function _approve(address to, uint256 tokenId) internal virtual {
1448         _tokenApprovals[tokenId] = to;
1449         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1450     }
1451 
1452     /**
1453      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1454      * The call is not executed if the target address is not a contract.
1455      *
1456      * @param from address representing the previous owner of the given token ID
1457      * @param to target address that will receive the tokens
1458      * @param tokenId uint256 ID of the token to be transferred
1459      * @param _data bytes optional data to send along with the call
1460      * @return bool whether the call correctly returned the expected magic value
1461      */
1462     function _checkOnERC721Received(
1463         address from,
1464         address to,
1465         uint256 tokenId,
1466         bytes memory _data
1467     ) private returns (bool) {
1468         if (to.isContract()) {
1469             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1470                 return retval == IERC721Receiver.onERC721Received.selector;
1471             } catch (bytes memory reason) {
1472                 if (reason.length == 0) {
1473                     revert("ERC721: transfer to non ERC721Receiver implementer");
1474                 } else {
1475                     assembly {
1476                         revert(add(32, reason), mload(reason))
1477                     }
1478                 }
1479             }
1480         } else {
1481             return true;
1482         }
1483     }
1484 
1485     /**
1486      * @dev Hook that is called before any token transfer. This includes minting
1487      * and burning.
1488      *
1489      * Calling conditions:
1490      *
1491      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1492      * transferred to `to`.
1493      * - When `from` is zero, `tokenId` will be minted for `to`.
1494      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1495      * - `from` and `to` are never both zero.
1496      *
1497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1498      */
1499     function _beforeTokenTransfer(
1500         address from,
1501         address to,
1502         uint256 tokenId
1503     ) internal virtual {}
1504 }
1505 
1506 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1507 
1508 
1509 
1510 pragma solidity ^0.8.0;
1511 
1512 
1513 
1514 /**
1515  * @title ERC721 Burnable Token
1516  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1517  */
1518 abstract contract ERC721Burnable is Context, ERC721 {
1519     /**
1520      * @dev Burns `tokenId`. See {ERC721-_burn}.
1521      *
1522      * Requirements:
1523      *
1524      * - The caller must own `tokenId` or be an approved operator.
1525      */
1526     function burn(uint256 tokenId) public virtual {
1527         //solhint-disable-next-line max-line-length
1528         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1529         _burn(tokenId);
1530     }
1531 }
1532 
1533 // File: contracts/avatars.sol
1534 
1535 
1536 pragma solidity ^0.8.4;
1537 
1538 
1539 
1540 
1541 
1542 
1543 
1544 
1545 interface IAvatarMetadata {
1546     function tokenURI(uint256 seed, uint256 tokenId) external view returns (string memory);
1547 }
1548 
1549 contract MEE6Avatars is ERC721, Pausable, Ownable, ERC721Burnable, VRFConsumerBaseV2 {
1550     using Counters for Counters.Counter;
1551 
1552     Counters.Counter private _tokenIdCounter;
1553     bool private _isMintAllowed;
1554     bool private _isGenSeedAllowed;
1555     bool private _isMetadataContractAddressUnlocked;
1556     address private _metadataContractAddress;
1557     string private _contractUri;
1558     string private _uri;
1559     uint256 private _seed;
1560     VRFCoordinatorV2Interface VRF_COORDINATOR;
1561 
1562     constructor(string memory name, string memory symbol, string memory baseUri, string memory contractUri, address vrfCoordinator) ERC721(name, symbol) VRFConsumerBaseV2(vrfCoordinator)  {
1563         _uri = baseUri;
1564         _contractUri = contractUri;
1565         _isMintAllowed = true;
1566         _isGenSeedAllowed = true;
1567         _metadataContractAddress = address(0);
1568         _isMetadataContractAddressUnlocked = true;
1569         VRF_COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
1570     }
1571 
1572     function _baseURI() internal view override returns (string memory) {
1573         return _uri;
1574     }
1575 
1576     function contractURI() public view returns (string memory) {
1577         return _contractUri;
1578     }
1579 
1580     function seed() public view returns (uint256) {
1581         return _seed;
1582     }
1583 
1584     function genSeed(uint64 subscriptionId, bytes32 keyHash, uint16 requestConfirmations, uint32 callbackGasLimit) public onlyOwner returns (uint256) {
1585         require(_isGenSeedAllowed);
1586         return VRF_COORDINATOR.requestRandomWords(
1587             keyHash,
1588             subscriptionId,
1589             requestConfirmations,
1590             callbackGasLimit,
1591             1
1592         );
1593     }
1594 
1595     function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
1596         require(_isGenSeedAllowed);
1597         _seed = randomWords[0];
1598     }
1599 
1600     function lockGenSeed() public onlyOwner {
1601         _isGenSeedAllowed = false;
1602     }
1603 
1604     function setContractURI(string memory newContractUri) public onlyOwner {
1605         _contractUri = newContractUri;
1606     }
1607 
1608     function setBaseURI(string memory newBaseUri) public onlyOwner {
1609         _uri = newBaseUri;
1610     }
1611 
1612     function setMetadataContractAddress(address addr) public onlyOwner {
1613         require(_isMetadataContractAddressUnlocked);
1614         _metadataContractAddress = addr;
1615     }
1616 
1617     function lockMetadataContractAddress() public onlyOwner {
1618         _isMetadataContractAddressUnlocked = false;
1619     }
1620 
1621     function lockMint() public onlyOwner {
1622         _isMintAllowed = false;
1623     }
1624 
1625     function pause() public onlyOwner {
1626         _pause();
1627     }
1628 
1629     function unpause() public onlyOwner {
1630         _unpause();
1631     }
1632 
1633     function safeMint(address to) public onlyOwner {
1634         require(_isMintAllowed);
1635         uint256 tokenId = _tokenIdCounter.current();
1636         _tokenIdCounter.increment();
1637         _safeMint(to, tokenId);
1638     }
1639 
1640     function batchMint(address[] calldata addresses) external onlyOwner {
1641         require(_isMintAllowed);
1642         for (uint256 i = 0; i < addresses.length; i++) {
1643             safeMint(addresses[i]);
1644         }
1645     }
1646 
1647     function _requireMinted(uint256 tokenId) internal view {
1648         require(_exists(tokenId), "ERC721: invalid token ID");
1649     }
1650 
1651     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1652         _requireMinted(tokenId);
1653         if (_metadataContractAddress != address(0)) {
1654             return IAvatarMetadata(_metadataContractAddress).tokenURI(_seed, tokenId);
1655         } else {
1656             string memory baseURI = _baseURI();
1657             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "/", Strings.toString(_seed), "/", Strings.toString(tokenId))) : "";
1658         }
1659     }
1660 
1661     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1662     internal
1663     whenNotPaused
1664     override
1665     {
1666         super._beforeTokenTransfer(from, to, tokenId);
1667     }
1668 }