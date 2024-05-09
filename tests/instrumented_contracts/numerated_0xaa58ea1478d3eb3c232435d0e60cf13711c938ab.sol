1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.21;
4 
5 // apply.etf.live
6 
7 /** ****************************************************************************
8  * @notice Interface for contracts using VRF randomness
9  * *****************************************************************************
10  * @dev PURPOSE
11  *
12  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
13  * @dev to Vera the verifier in such a way that Vera can be sure he's not
14  * @dev making his output up to suit himself. Reggie provides Vera a public key
15  * @dev to which he knows the secret key. Each time Vera provides a seed to
16  * @dev Reggie, he gives back a value which is computed completely
17  * @dev deterministically from the seed and the secret key.
18  *
19  * @dev Reggie provides a proof by which Vera can verify that the output was
20  * @dev correctly computed once Reggie tells it to her, but without that proof,
21  * @dev the output is indistinguishable to her from a uniform random sample
22  * @dev from the output space.
23  *
24  * @dev The purpose of this contract is to make it easy for unrelated contracts
25  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
26  * @dev simple access to a verifiable source of randomness. It ensures 2 things:
27  * @dev 1. The fulfillment came from the VRFCoordinator
28  * @dev 2. The consumer contract implements fulfillRandomWords.
29  * *****************************************************************************
30  * @dev USAGE
31  *
32  * @dev Calling contracts must inherit from VRFConsumerBase, and can
33  * @dev initialize VRFConsumerBase's attributes in their constructor as
34  * @dev shown:
35  *
36  * @dev   contract VRFConsumer {
37  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
38  * @dev       VRFConsumerBase(_vrfCoordinator) public {
39  * @dev         <initialization with other arguments goes here>
40  * @dev       }
41  * @dev   }
42  *
43  * @dev The oracle will have given you an ID for the VRF keypair they have
44  * @dev committed to (let's call it keyHash). Create subscription, fund it
45  * @dev and your consumer contract as a consumer of it (see VRFCoordinatorInterface
46  * @dev subscription management functions).
47  * @dev Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
48  * @dev callbackGasLimit, numWords),
49  * @dev see (VRFCoordinatorInterface for a description of the arguments).
50  *
51  * @dev Once the VRFCoordinator has received and validated the oracle's response
52  * @dev to your request, it will call your contract's fulfillRandomWords method.
53  *
54  * @dev The randomness argument to fulfillRandomWords is a set of random words
55  * @dev generated from your requestId and the blockHash of the request.
56  *
57  * @dev If your contract could have concurrent requests open, you can use the
58  * @dev requestId returned from requestRandomWords to track which response is associated
59  * @dev with which randomness request.
60  * @dev See "SECURITY CONSIDERATIONS" for principles to keep in mind,
61  * @dev if your contract could have multiple requests in flight simultaneously.
62  *
63  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
64  * @dev differ.
65  *
66  * *****************************************************************************
67  * @dev SECURITY CONSIDERATIONS
68  *
69  * @dev A method with the ability to call your fulfillRandomness method directly
70  * @dev could spoof a VRF response with any random value, so it's critical that
71  * @dev it cannot be directly called by anything other than this base contract
72  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
73  *
74  * @dev For your users to trust that your contract's random behavior is free
75  * @dev from malicious interference, it's best if you can write it so that all
76  * @dev behaviors implied by a VRF response are executed *during* your
77  * @dev fulfillRandomness method. If your contract must store the response (or
78  * @dev anything derived from it) and use it later, you must ensure that any
79  * @dev user-significant behavior which depends on that stored value cannot be
80  * @dev manipulated by a subsequent VRF request.
81  *
82  * @dev Similarly, both miners and the VRF oracle itself have some influence
83  * @dev over the order in which VRF responses appear on the blockchain, so if
84  * @dev your contract could have multiple VRF requests in flight simultaneously,
85  * @dev you must ensure that the order in which the VRF responses arrive cannot
86  * @dev be used to manipulate your contract's user-significant behavior.
87  *
88  * @dev Since the block hash of the block which contains the requestRandomness
89  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
90  * @dev miner could, in principle, fork the blockchain to evict the block
91  * @dev containing the request, forcing the request to be included in a
92  * @dev different block with a different hash, and therefore a different input
93  * @dev to the VRF. However, such an attack would incur a substantial economic
94  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
95  * @dev until it calls responds to a request. It is for this reason that
96  * @dev that you can signal to an oracle you'd like them to wait longer before
97  * @dev responding to the request (however this is not enforced in the contract
98  * @dev and so remains effective only in the case of unmodified oracle software).
99  */
100 abstract contract VRFConsumerBaseV2 {
101   error OnlyCoordinatorCanFulfill(address have, address want);
102   address private immutable vrfCoordinator;
103 
104   /**
105    * @param _vrfCoordinator address of VRFCoordinator contract
106    */
107   constructor(address _vrfCoordinator) {
108     vrfCoordinator = _vrfCoordinator;
109   }
110 
111   /**
112    * @notice fulfillRandomness handles the VRF response. Your contract must
113    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
114    * @notice principles to keep in mind when implementing your fulfillRandomness
115    * @notice method.
116    *
117    * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
118    * @dev signature, and will call it once it has verified the proof
119    * @dev associated with the randomness. (It is triggered via a call to
120    * @dev rawFulfillRandomness, below.)
121    *
122    * @param requestId The Id initially returned by requestRandomness
123    * @param randomWords the VRF output expanded to the requested number of words
124    */
125   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;
126 
127   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
128   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
129   // the origin of the call
130   function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
131     if (msg.sender != vrfCoordinator) {
132       revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
133     }
134     fulfillRandomWords(requestId, randomWords);
135   }
136 }
137 
138 interface VRFCoordinatorV2Interface {
139   /**
140    * @notice Get configuration relevant for making requests
141    * @return minimumRequestConfirmations global min for request confirmations
142    * @return maxGasLimit global max for request gas limit
143    * @return s_provingKeyHashes list of registered key hashes
144    */
145   function getRequestConfig()
146     external
147     view
148     returns (
149       uint16,
150       uint32,
151       bytes32[] memory
152     );
153 
154   /**
155    * @notice Request a set of random words.
156    * @param keyHash - Corresponds to a particular oracle job which uses
157    * that key for generating the VRF proof. Different keyHash's have different gas price
158    * ceilings, so you can select a specific one to bound your maximum per request cost.
159    * @param subId  - The ID of the VRF subscription. Must be funded
160    * with the minimum subscription balance required for the selected keyHash.
161    * @param minimumRequestConfirmations - How many blocks you'd like the
162    * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
163    * for why you may want to request more. The acceptable range is
164    * [minimumRequestBlockConfirmations, 200].
165    * @param callbackGasLimit - How much gas you'd like to receive in your
166    * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
167    * may be slightly less than this amount because of gas used calling the function
168    * (argument decoding etc.), so you may need to request slightly more than you expect
169    * to have inside fulfillRandomWords. The acceptable range is
170    * [0, maxGasLimit]
171    * @param numWords - The number of uint256 random values you'd like to receive
172    * in your fulfillRandomWords callback. Note these numbers are expanded in a
173    * secure way by the VRFCoordinator from a single random value supplied by the oracle.
174    * @return requestId - A unique identifier of the request. Can be used to match
175    * a request to a response in fulfillRandomWords.
176    */
177   function requestRandomWords(
178     bytes32 keyHash,
179     uint64 subId,
180     uint16 minimumRequestConfirmations,
181     uint32 callbackGasLimit,
182     uint32 numWords
183   ) external returns (uint256 requestId);
184 
185   /**
186    * @notice Create a VRF subscription.
187    * @return subId - A unique subscription id.
188    * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
189    * @dev Note to fund the subscription, use transferAndCall. For example
190    * @dev  LINKTOKEN.transferAndCall(
191    * @dev    address(COORDINATOR),
192    * @dev    amount,
193    * @dev    abi.encode(subId));
194    */
195   function createSubscription() external returns (uint64 subId);
196 
197   /**
198    * @notice Get a VRF subscription.
199    * @param subId - ID of the subscription
200    * @return balance - LINK balance of the subscription in juels.
201    * @return reqCount - number of requests for this subscription, determines fee tier.
202    * @return owner - owner of the subscription.
203    * @return consumers - list of consumer address which are able to use this subscription.
204    */
205   function getSubscription(uint64 subId)
206     external
207     view
208     returns (
209       uint96 balance,
210       uint64 reqCount,
211       address owner,
212       address[] memory consumers
213     );
214 
215   /**
216    * @notice Request subscription owner transfer.
217    * @param subId - ID of the subscription
218    * @param newOwner - proposed new owner of the subscription
219    */
220   function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;
221 
222   /**
223    * @notice Request subscription owner transfer.
224    * @param subId - ID of the subscription
225    * @dev will revert if original owner of subId has
226    * not requested that msg.sender become the new owner.
227    */
228   function acceptSubscriptionOwnerTransfer(uint64 subId) external;
229 
230   /**
231    * @notice Add a consumer to a VRF subscription.
232    * @param subId - ID of the subscription
233    * @param consumer - New consumer which can use the subscription
234    */
235   function addConsumer(uint64 subId, address consumer) external;
236 
237   /**
238    * @notice Remove a consumer from a VRF subscription.
239    * @param subId - ID of the subscription
240    * @param consumer - Consumer to remove from the subscription
241    */
242   function removeConsumer(uint64 subId, address consumer) external;
243 
244   /**
245    * @notice Cancel a subscription
246    * @param subId - ID of the subscription
247    * @param to - Where to send the remaining LINK to
248    */
249   function cancelSubscription(uint64 subId, address to) external;
250 }
251 
252 /**
253  *Submitted for verification at Etherscan.io on 2023-08-25
254 */
255 
256 pragma solidity ^0.8.0;
257 
258 abstract contract Context {
259     function _msgSender() internal view virtual returns (address) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view virtual returns (bytes calldata) {
264         return msg.data;
265     }
266 }
267 
268 library Address {
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize/address.code.length, which returns 0
271         // for contracts in construction, since the code is only stored at the end
272         // of the constructor execution.
273 
274         return account.code.length > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         (bool success, ) = recipient.call{value: amount}("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain `call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         (bool success, bytes memory returndata) = target.staticcall(data);
390         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         (bool success, bytes memory returndata) = target.delegatecall(data);
415         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
416     }
417 
418     /**
419      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
420      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
421      *
422      * _Available since v4.8._
423      */
424     function verifyCallResultFromTarget(
425         address target,
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal view returns (bytes memory) {
430         if (success) {
431             if (returndata.length == 0) {
432                 // only check isContract if the call was successful and the return data is empty
433                 // otherwise we already know that it was a contract
434                 require(isContract(target), "Address: call to non-contract");
435             }
436             return returndata;
437         } else {
438             _revert(returndata, errorMessage);
439         }
440     }
441 
442     /**
443      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
444      * revert reason or using the provided one.
445      *
446      * _Available since v4.3._
447      */
448     function verifyCallResult(
449         bool success,
450         bytes memory returndata,
451         string memory errorMessage
452     ) internal pure returns (bytes memory) {
453         if (success) {
454             return returndata;
455         } else {
456             _revert(returndata, errorMessage);
457         }
458     }
459 
460     function _revert(bytes memory returndata, string memory errorMessage) private pure {
461         // Look for revert reason and bubble it up if present
462         if (returndata.length > 0) {
463             // The easiest way to bubble the revert reason is using memory via assembly
464             /// @solidity memory-safe-assembly
465             assembly {
466                 let returndata_size := mload(returndata)
467                 revert(add(32, returndata), returndata_size)
468             }
469         } else {
470             revert(errorMessage);
471         }
472     }
473 }
474 
475 abstract contract Ownable is Context {
476     address private _owner;
477 
478     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
479 
480     /**
481      * @dev Initializes the contract setting the deployer as the initial owner.
482      */
483     constructor() {
484         _transferOwnership(_msgSender());
485     }
486 
487     /**
488      * @dev Throws if called by any account other than the owner.
489      */
490     modifier onlyOwner() {
491         _checkOwner();
492         _;
493     }
494 
495     /**
496      * @dev Returns the address of the current owner.
497      */
498     function owner() public view virtual returns (address) {
499         return _owner;
500     }
501 
502     /**
503      * @dev Throws if the sender is not the owner.
504      */
505     function _checkOwner() internal view virtual {
506         require(owner() == _msgSender(), "Ownable: caller is not the owner");
507     }
508 
509     /**
510      * @dev Leaves the contract without owner. It will not be possible to call
511      * `onlyOwner` functions. Can only be called by the current owner.
512      *
513      * NOTE: Renouncing ownership will leave the contract without an owner,
514      * thereby disabling any functionality that is only available to the owner.
515      */
516     function renounceOwnership() public virtual onlyOwner {
517         _transferOwnership(address(0));
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         _transferOwnership(newOwner);
527     }
528 
529     /**
530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
531      * Internal function without access restriction.
532      */
533     function _transferOwnership(address newOwner) internal virtual {
534         address oldOwner = _owner;
535         _owner = newOwner;
536         emit OwnershipTransferred(oldOwner, newOwner);
537     }
538 }
539 
540 interface IERC20 {
541     /**
542      * @dev Emitted when `value` tokens are moved from one account (`from`) to
543      * another (`to`).
544      *
545      * Note that `value` may be zero.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 value);
548 
549     /**
550      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
551      * a call to {approve}. `value` is the new allowance.
552      */
553     event Approval(address indexed owner, address indexed spender, uint256 value);
554 
555     /**
556      * @dev Returns the amount of tokens in existence.
557      */
558     function totalSupply() external view returns (uint256);
559 
560     /**
561      * @dev Returns the amount of tokens owned by `account`.
562      */
563     function balanceOf(address account) external view returns (uint256);
564 
565     /**
566      * @dev Moves `amount` tokens from the caller's account to `to`.
567      *
568      * Returns a boolean value indicating whether the operation succeeded.
569      *
570      * Emits a {Transfer} event.
571      */
572     function transfer(address to, uint256 amount) external returns (bool);
573 
574     /**
575      * @dev Returns the remaining number of tokens that `spender` will be
576      * allowed to spend on behalf of `owner` through {transferFrom}. This is
577      * zero by default.
578      *
579      * This value changes when {approve} or {transferFrom} are called.
580      */
581     function allowance(address owner, address spender) external view returns (uint256);
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
585      *
586      * Returns a boolean value indicating whether the operation succeeded.
587      *
588      * IMPORTANT: Beware that changing an allowance with this method brings the risk
589      * that someone may use both the old and the new allowance by unfortunate
590      * transaction ordering. One possible solution to mitigate this race
591      * condition is to first reduce the spender's allowance to 0 and set the
592      * desired value afterwards:
593      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
594      *
595      * Emits an {Approval} event.
596      */
597     function approve(address spender, uint256 amount) external returns (bool);
598 
599     /**
600      * @dev Moves `amount` tokens from `from` to `to` using the
601      * allowance mechanism. `amount` is then deducted from the caller's
602      * allowance.
603      *
604      * Returns a boolean value indicating whether the operation succeeded.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transferFrom(address from, address to, uint256 amount) external returns (bool);
609 }
610 
611 pragma solidity ^0.8.0;
612 
613 interface LinkTokenInterface {
614   function allowance(address owner, address spender) external view returns (uint256 remaining);
615 
616   function approve(address spender, uint256 value) external returns (bool success);
617 
618   function balanceOf(address owner) external view returns (uint256 balance);
619 
620   function decimals() external view returns (uint8 decimalPlaces);
621 
622   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
623 
624   function increaseApproval(address spender, uint256 subtractedValue) external;
625 
626   function name() external view returns (string memory tokenName);
627 
628   function symbol() external view returns (string memory tokenSymbol);
629 
630   function totalSupply() external view returns (uint256 totalTokensIssued);
631 
632   function transfer(address to, uint256 value) external returns (bool success);
633 
634   function transferAndCall(
635     address to,
636     uint256 value,
637     bytes calldata data
638   ) external returns (bool success);
639 
640   function transferFrom(
641     address from,
642     address to,
643     uint256 value
644   ) external returns (bool success);
645 }
646 
647 contract ETFApplicationGame is VRFConsumerBaseV2, Ownable {
648   address public gameToken = 0x667210a731447F8B385e068205759BE2311b86d4; // ETF The Token
649   VRFCoordinatorV2Interface vrfCoord;
650   LinkTokenInterface link;
651   uint64 private _vrfSubscriptionId;
652   bytes32 private _vrfKeyHash;
653   uint16 private _vrfNumBlocks = 3;
654   uint32 private _vrfCallbackGasLimit = 600000;
655   mapping(uint256 => address) private _applicationWagerInitUser;
656   mapping(uint256 => uint256) private _applicationWagerInitAmount;
657   mapping(uint256 => uint256) private _applicationWagerInitNonce;
658   mapping(uint256 => bool) private _applicationWagerInitSettled;
659   mapping(address => uint256) public userWagerNonce;
660 
661   uint256 public poolSize;
662   uint256 public maxWagerPercentage;
663   uint256 private constant PERCENT_DENOMENATOR = 1000;
664   uint256 public minBetAmount;
665   uint256 public payoutPercentage = (PERCENT_DENOMENATOR * 92) / 100;
666   uint256 public applicationsApproved;
667   uint256 public applicationsDenied;
668   uint256 public applicationAmountWon;
669   uint256 public applicationAmountLost;
670   mapping(address => uint256) public applicationsUserWon;
671   mapping(address => uint256) public applicationsUserLost;
672   mapping(address => uint256) public applicationUserAmountWon;
673   mapping(address => uint256) public applicationUserAmountLost;
674   mapping(address => bool) public lastApplicationWon;
675 
676   event InitiatedApplication(
677     address indexed wagerer,
678     uint256 indexed nonce,
679     uint256 requestId,
680     uint256 amountWagered
681   );
682   event SettledApplication(
683     address indexed wagerer,
684     uint256 indexed nonce,
685     uint256 requestId,
686     uint256 amountWagered,
687     bool isWinner,
688     uint256 amountWon
689   );
690 
691   constructor(
692     address _vrfCoordinator,
693     uint64 _subscriptionId,
694     address _linkToken,
695     bytes32 _keyHash
696   ) VRFConsumerBaseV2(_vrfCoordinator) {
697     vrfCoord = VRFCoordinatorV2Interface(_vrfCoordinator);
698     link = LinkTokenInterface(_linkToken);
699     _vrfSubscriptionId = _subscriptionId;
700     _vrfKeyHash = _keyHash;
701   }
702 
703   function setMaxWagerPercentage(uint256 _maxWagerPercentage) external onlyOwner {
704     maxWagerPercentage = _maxWagerPercentage;
705   }
706 
707   function resetPoolSize() external onlyOwner {
708     poolSize = IERC20(gameToken).balanceOf(address(this));
709   }
710 
711   function setMinBetAmount(uint256 _minBetAmount) external onlyOwner {
712     minBetAmount = _minBetAmount;
713   }
714 
715   function submitEtfApplication(uint256 amountBet) external payable {
716     require(IERC20(gameToken).balanceOf(msg.sender) > 0, 'must have a bag to wager');
717     require(
718       amountBet <= (poolSize * maxWagerPercentage) / 100,
719       'cannot exceed max wager'
720     );
721     require(amountBet >= minBetAmount, 'bet more');
722 
723     IERC20(gameToken).transferFrom(msg.sender, address(this), amountBet);
724 
725     uint256 requestId = vrfCoord.requestRandomWords(
726       _vrfKeyHash,
727       _vrfSubscriptionId,
728       _vrfNumBlocks,
729       _vrfCallbackGasLimit,
730       uint16(1)
731     );
732 
733     _applicationWagerInitUser[requestId] = msg.sender;
734     _applicationWagerInitAmount[requestId] = amountBet;
735     _applicationWagerInitNonce[requestId] = userWagerNonce[msg.sender];
736     userWagerNonce[msg.sender]++;
737 
738     emit InitiatedApplication(
739       msg.sender,
740       _applicationWagerInitNonce[requestId],
741       requestId,
742       amountBet
743     );
744   }
745 
746   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
747     internal
748     override
749   {
750     _settleEtfApplication(requestId, randomWords[0]);
751   }
752 
753   function manualFulfillRandomWords(
754     uint256 requestId,
755     uint256[] memory randomWords
756   ) external onlyOwner {
757     _settleEtfApplication(requestId, randomWords[0]);
758   }
759 
760   function _settleEtfApplication(uint256 requestId, uint256 randomNumber) internal {
761     address _user = _applicationWagerInitUser[requestId];
762     require(_user != address(0), 'ETF application record does not exist');
763     require(!_applicationWagerInitSettled[requestId], 'already settled');
764     _applicationWagerInitSettled[requestId] = true;
765 
766     uint256 amountBet = _applicationWagerInitAmount[requestId];
767     uint256 _nonce = _applicationWagerInitNonce[requestId];
768     uint256 _amountToWin = (amountBet * payoutPercentage) /
769       PERCENT_DENOMENATOR;
770     uint256 amountPayout = amountBet + _amountToWin;
771     bool _didUserWin = randomNumber % 2 == 0;
772 
773     if (_didUserWin) {
774       IERC20(gameToken).transfer(_user, amountPayout);
775       applicationsApproved++;
776       applicationAmountWon += _amountToWin;
777       applicationsUserWon[_user]++;
778       applicationUserAmountWon[_user] += _amountToWin;
779       lastApplicationWon[_user] = true;
780       poolSize = IERC20(gameToken).balanceOf(address(this));
781 
782     } else {
783       applicationsDenied++;
784       applicationAmountLost += amountBet;
785       applicationsUserLost[_user]++;
786       applicationUserAmountLost[_user] += amountBet;
787       lastApplicationWon[_user] = false;
788       poolSize = IERC20(gameToken).balanceOf(address(this));      
789     }
790     emit SettledApplication(
791       _user,
792       _nonce,
793       requestId,
794       amountBet,
795       _didUserWin,
796       _amountToWin
797     );
798   }
799 
800   function setPayoutPercentage(uint256 _percentage) external onlyOwner {
801     require(_percentage <= PERCENT_DENOMENATOR, 'cannot exceed 100%');
802     payoutPercentage = _percentage;
803   }
804 
805   function getMaxWager() external view returns (uint256) {
806     return (poolSize * maxWagerPercentage) / 100;
807   }
808 
809   function setGameToken(address _token) external onlyOwner {
810     gameToken = _token;
811   }
812 
813   function setVrfSubscriptionId(uint64 _subId) external onlyOwner {
814     _vrfSubscriptionId = _subId;
815   }
816 
817   function setVrfNumBlocks(uint16 _numBlocks) external onlyOwner {
818     _vrfNumBlocks = _numBlocks;
819   }
820 
821   function setVrfCallbackGasLimit(uint32 _gas) external onlyOwner {
822     _vrfCallbackGasLimit = _gas;
823   }
824 
825   function withdrawGameTokens(uint256 amountToWithdraw) external onlyOwner {
826     IERC20(gameToken).transfer(msg.sender, amountToWithdraw);
827     poolSize = IERC20(gameToken).balanceOf(address(this));
828   }
829 
830   function withdrawEth() external onlyOwner {
831     uint256 ethBalance = address(this).balance;
832     if (ethBalance > 0) {
833         payable(msg.sender).transfer(ethBalance);
834     }
835   }
836 }