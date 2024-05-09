1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 
4 library SafeMath {
5 
6   /**
7    * @dev Multiplies two unsigned integers, reverts on overflow.
8    */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13     if (a == 0) {
14       return 0;
15     }
16 
17     uint256 c = a * b;
18     require(c / a == b, "SafeMath#mul: OVERFLOW");
19 
20     return c;
21   }
22 
23   /**
24    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25    */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // Solidity only automatically asserts when dividing by 0
28     require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32     return c;
33   }
34 
35   /**
36    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37    */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b <= a, "SafeMath#sub: UNDERFLOW");
40     uint256 c = a - b;
41 
42     return c;
43   }
44 
45   /**
46    * @dev Adds two unsigned integers, reverts on overflow.
47    */
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a + b;
50     require(c >= a, "SafeMath#add: OVERFLOW");
51 
52     return c; 
53   }
54 
55   /**
56    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
57    * reverts when dividing by zero.
58    */
59   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
61     return a % b;
62   }
63 
64 }
65 
66 abstract contract Context {
67     function _msgSender() internal view virtual returns (address) {
68         return msg.sender;
69     }
70 
71     function _msgData() internal view virtual returns (bytes calldata) {
72         return msg.data;
73     }
74 }
75 
76 /**
77  * @dev Contract module which provides a basic access control mechanism, where
78  * there is an account (an owner) that can be granted exclusive access to
79  * specific functions.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _setOwner(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _setOwner(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _setOwner(newOwner);
130     }
131 
132     function _setOwner(address newOwner) private {
133         address oldOwner = _owner;
134         _owner = newOwner;
135         emit OwnershipTransferred(oldOwner, newOwner);
136     }
137 }
138 
139 
140 /**
141  * @dev Interface of the ERC20 standard as defined in the EIP.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through {transferFrom}. This is
166      * zero by default.
167      *
168      * This value changes when {approve} or {transferFrom} are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * IMPORTANT: Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an {Approval} event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a {Transfer} event.
196      */
197     function transferFrom(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) external returns (bool);
202 
203     /**
204      * @dev Emitted when `value` tokens are moved from one account (`from`) to
205      * another (`to`).
206      *
207      * Note that `value` may be zero.
208      */
209     event Transfer(address indexed from, address indexed to, uint256 value);
210 
211     /**
212      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
213      * a call to {approve}. `value` is the new allowance.
214      */
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 interface LinkTokenInterface {
219 
220   function allowance(
221     address owner,
222     address spender
223   )
224     external
225     view
226     returns (
227       uint256 remaining
228     );
229 
230   function approve(
231     address spender,
232     uint256 value
233   )
234     external
235     returns (
236       bool success
237     );
238 
239   function balanceOf(
240     address owner
241   )
242     external
243     view
244     returns (
245       uint256 balance
246     );
247 
248   function decimals()
249     external
250     view
251     returns (
252       uint8 decimalPlaces
253     );
254 
255   function decreaseApproval(
256     address spender,
257     uint256 addedValue
258   )
259     external
260     returns (
261       bool success
262     );
263 
264   function increaseApproval(
265     address spender,
266     uint256 subtractedValue
267   ) external;
268 
269   function name()
270     external
271     view
272     returns (
273       string memory tokenName
274     );
275 
276   function symbol()
277     external
278     view
279     returns (
280       string memory tokenSymbol
281     );
282 
283   function totalSupply()
284     external
285     view
286     returns (
287       uint256 totalTokensIssued
288     );
289 
290   function transfer(
291     address to,
292     uint256 value
293   )
294     external
295     returns (
296       bool success
297     );
298 
299   function transferAndCall(
300     address to,
301     uint256 value,
302     bytes calldata data
303   )
304     external
305     returns (
306       bool success
307     );
308 
309   function transferFrom(
310     address from,
311     address to,
312     uint256 value
313   )
314     external
315     returns (
316       bool success
317     );
318 
319 }
320 
321 contract VRFRequestIDBase {
322 
323   /**
324    * @notice returns the seed which is actually input to the VRF coordinator
325    *
326    * @dev To prevent repetition of VRF output due to repetition of the
327    * @dev user-supplied seed, that seed is combined in a hash with the
328    * @dev user-specific nonce, and the address of the consuming contract. The
329    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
330    * @dev the final seed, but the nonce does protect against repetition in
331    * @dev requests which are included in a single block.
332    *
333    * @param _userSeed VRF seed input provided by user
334    * @param _requester Address of the requesting contract
335    * @param _nonce User-specific nonce at the time of the request
336    */
337   function makeVRFInputSeed(
338     bytes32 _keyHash,
339     uint256 _userSeed,
340     address _requester,
341     uint256 _nonce
342   )
343     internal
344     pure
345     returns (
346       uint256
347     )
348   {
349     return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
350   }
351 
352   /**
353    * @notice Returns the id for this request
354    * @param _keyHash The serviceAgreement ID to be used for this request
355    * @param _vRFInputSeed The seed to be passed directly to the VRF
356    * @return The id for this request
357    *
358    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
359    * @dev contract, but the one generated by makeVRFInputSeed
360    */
361   function makeRequestId(
362     bytes32 _keyHash,
363     uint256 _vRFInputSeed
364   )
365     internal
366     pure
367     returns (
368       bytes32
369     )
370   {
371     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
372   }
373 }
374 /** ****************************************************************************
375  * @notice Interface for contracts using VRF randomness
376  * *****************************************************************************
377  * @dev PURPOSE
378  *
379  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
380  * @dev to Vera the verifier in such a way that Vera can be sure he's not
381  * @dev making his output up to suit himself. Reggie provides Vera a public key
382  * @dev to which he knows the secret key. Each time Vera provides a seed to
383  * @dev Reggie, he gives back a value which is computed completely
384  * @dev deterministically from the seed and the secret key.
385  *
386  * @dev Reggie provides a proof by which Vera can verify that the output was
387  * @dev correctly computed once Reggie tells it to her, but without that proof,
388  * @dev the output is indistinguishable to her from a uniform random sample
389  * @dev from the output space.
390  *
391  * @dev The purpose of this contract is to make it easy for unrelated contracts
392  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
393  * @dev simple access to a verifiable source of randomness.
394  * *****************************************************************************
395  * @dev USAGE
396  *
397  * @dev Calling contracts must inherit from VRFConsumerBase, and can
398  * @dev initialize VRFConsumerBase's attributes in their constructor as
399  * @dev shown:
400  *
401  * @dev   contract VRFConsumer {
402  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
403  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
404  * @dev         <initialization with other arguments goes here>
405  * @dev       }
406  * @dev   }
407  *
408  * @dev The oracle will have given you an ID for the VRF keypair they have
409  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
410  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
411  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
412  * @dev want to generate randomness from.
413  *
414  * @dev Once the VRFCoordinator has received and validated the oracle's response
415  * @dev to your request, it will call your contract's fulfillRandomness method.
416  *
417  * @dev The randomness argument to fulfillRandomness is the actual random value
418  * @dev generated from your seed.
419  *
420  * @dev The requestId argument is generated from the keyHash and the seed by
421  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
422  * @dev requests open, you can use the requestId to track which seed is
423  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
424  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
425  * @dev if your contract could have multiple requests in flight simultaneously.)
426  *
427  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
428  * @dev differ. (Which is critical to making unpredictable randomness! See the
429  * @dev next section.)
430  *
431  * *****************************************************************************
432  * @dev SECURITY CONSIDERATIONS
433  *
434  * @dev A method with the ability to call your fulfillRandomness method directly
435  * @dev could spoof a VRF response with any random value, so it's critical that
436  * @dev it cannot be directly called by anything other than this base contract
437  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
438  *
439  * @dev For your users to trust that your contract's random behavior is free
440  * @dev from malicious interference, it's best if you can write it so that all
441  * @dev behaviors implied by a VRF response are executed *during* your
442  * @dev fulfillRandomness method. If your contract must store the response (or
443  * @dev anything derived from it) and use it later, you must ensure that any
444  * @dev user-significant behavior which depends on that stored value cannot be
445  * @dev manipulated by a subsequent VRF request.
446  *
447  * @dev Similarly, both miners and the VRF oracle itself have some influence
448  * @dev over the order in which VRF responses appear on the blockchain, so if
449  * @dev your contract could have multiple VRF requests in flight simultaneously,
450  * @dev you must ensure that the order in which the VRF responses arrive cannot
451  * @dev be used to manipulate your contract's user-significant behavior.
452  *
453  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
454  * @dev block in which the request is made, user-provided seeds have no impact
455  * @dev on its economic security properties. They are only included for API
456  * @dev compatability with previous versions of this contract.
457  *
458  * @dev Since the block hash of the block which contains the requestRandomness
459  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
460  * @dev miner could, in principle, fork the blockchain to evict the block
461  * @dev containing the request, forcing the request to be included in a
462  * @dev different block with a different hash, and therefore a different input
463  * @dev to the VRF. However, such an attack would incur a substantial economic
464  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
465  * @dev until it calls responds to a request.
466  */
467 abstract contract VRFConsumerBase is VRFRequestIDBase {
468 
469   /**
470    * @notice fulfillRandomness handles the VRF response. Your contract must
471    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
472    * @notice principles to keep in mind when implementing your fulfillRandomness
473    * @notice method.
474    *
475    * @dev VRFConsumerBase expects its subcontracts to have a method with this
476    * @dev signature, and will call it once it has verified the proof
477    * @dev associated with the randomness. (It is triggered via a call to
478    * @dev rawFulfillRandomness, below.)
479    *
480    * @param requestId The Id initially returned by requestRandomness
481    * @param randomness the VRF output
482    */
483   function fulfillRandomness(
484     bytes32 requestId,
485     uint256 randomness
486   )
487     internal
488     virtual;
489 
490   /**
491    * @dev In order to keep backwards compatibility we have kept the user
492    * seed field around. We remove the use of it because given that the blockhash
493    * enters later, it overrides whatever randomness the used seed provides.
494    * Given that it adds no security, and can easily lead to misunderstandings,
495    * we have removed it from usage and can now provide a simpler API.
496    */
497   uint256 constant private USER_SEED_PLACEHOLDER = 0;
498 
499   /**
500    * @notice requestRandomness initiates a request for VRF output given _seed
501    *
502    * @dev The fulfillRandomness method receives the output, once it's provided
503    * @dev by the Oracle, and verified by the vrfCoordinator.
504    *
505    * @dev The _keyHash must already be registered with the VRFCoordinator, and
506    * @dev the _fee must exceed the fee specified during registration of the
507    * @dev _keyHash.
508    *
509    * @dev The _seed parameter is vestigial, and is kept only for API
510    * @dev compatibility with older versions. It can't *hurt* to mix in some of
511    * @dev your own randomness, here, but it's not necessary because the VRF
512    * @dev oracle will mix the hash of the block containing your request into the
513    * @dev VRF seed it ultimately uses.
514    *
515    * @param _keyHash ID of public key against which randomness is generated
516    * @param _fee The amount of LINK to send with the request
517    *
518    * @return requestId unique ID for this request
519    *
520    * @dev The returned requestId can be used to distinguish responses to
521    * @dev concurrent requests. It is passed as the first argument to
522    * @dev fulfillRandomness.
523    */
524   function requestRandomness(
525     bytes32 _keyHash,
526     uint256 _fee
527   )
528     internal
529     returns (
530       bytes32 requestId
531     )
532   {
533     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
534     // This is the seed passed to VRFCoordinator. The oracle will mix this with
535     // the hash of the block containing this request to obtain the seed/input
536     // which is finally passed to the VRF cryptographic machinery.
537     uint256 vRFSeed  = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
538     // nonces[_keyHash] must stay in sync with
539     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
540     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
541     // This provides protection against the user repeating their input seed,
542     // which would result in a predictable/duplicate output, if multiple such
543     // requests appeared in the same block.
544     nonces[_keyHash] = nonces[_keyHash] + 1;
545     return makeRequestId(_keyHash, vRFSeed);
546   }
547 
548   LinkTokenInterface immutable internal LINK;
549   address immutable private vrfCoordinator;
550 
551   // Nonces for each VRF key from which randomness has been requested.
552   //
553   // Must stay in sync with VRFCoordinator[_keyHash][this]
554   mapping(bytes32 /* keyHash */ => uint256 /* nonce */) private nonces;
555 
556   /**
557    * @param _vrfCoordinator address of VRFCoordinator contract
558    * @param _link address of LINK token contract
559    *
560    * @dev https://docs.chain.link/docs/link-token-contracts
561    */
562   constructor(
563     address _vrfCoordinator,
564     address _link
565   ) {
566     vrfCoordinator = _vrfCoordinator;
567     LINK = LinkTokenInterface(_link);
568   }
569 
570   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
571   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
572   // the origin of the call
573   function rawFulfillRandomness(
574     bytes32 requestId,
575     uint256 randomness
576   )
577     external
578   {
579     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
580     fulfillRandomness(requestId, randomness);
581   }
582 }
583 
584 contract DNXEGGFarmZero is VRFConsumerBase, Ownable {
585     
586     using SafeMath for uint256;
587     
588     struct StakerInfo {
589         uint256 amount;
590         uint256 startStakeTime;
591         uint16 claimedEggs;
592         uint256 claimedTickets;
593     }
594     
595     uint256 public maximumStakers;       // points generated per LP token per second staked
596     uint256 public currentStakers;
597     uint256 public minimumStake;
598     uint256 public maximumStake;
599     uint256 public stakingFee;
600     IERC20 dnxcToken;                    // token being staked
601     
602     address private _rewardDistributor;
603     uint256[] timeTable;
604     mapping(address => StakerInfo) public stakerInfo;
605     bytes32 internal keyHash;
606     uint256 internal fee;
607     uint256 public randomResult;
608     bool paused;
609     
610     constructor(uint16 _maximumStakers, uint256 _minimumStake, uint256 _maximumStake, uint256 _stakingFee,  IERC20 _dnxcToken) VRFConsumerBase(
611             0xf0d54349aDdcf704F77AE15b96510dEA15cb7952, // VRF Coordinator
612             0x514910771AF9Ca656af840dff83E8264EcF986CA  // LINK Token
613         ) 
614      {
615         keyHash = 0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445;
616         fee = 2 * 10 ** 18; // 0.1 LINK (Varies by network)
617         
618         maximumStakers = _maximumStakers;
619         minimumStake = _minimumStake;
620         maximumStake = _maximumStake;
621         stakingFee = _stakingFee;
622         paused = true;
623         
624         timeTable = [ 120, 120, 120, 119, 119, 119, 119, 118, 118, 118, 118, 118, 117, 117, 117, 117, 116, 116, 116, 116, 115, 115, 115, 115, 115, 114, 114, 114, 114, 113, 113, 113, 113, 113, 112, 112, 112, 112, 111, 111, 111, 111, 110, 110, 110, 110, 110, 109, 109, 109, 109, 108, 108, 108, 108, 108, 107, 107, 107, 107, 106, 106, 106, 106, 105, 105, 105, 105, 105, 104, 104, 104, 104, 103, 103, 103, 103, 103, 102, 102, 102, 102, 101, 101, 101, 101, 101, 100, 100, 100, 100, 99, 99, 99, 99, 98, 98, 98, 98, 98, 97, 97, 97, 97, 96, 96, 96, 96, 96, 95, 95, 95, 95, 94, 94, 94, 94, 93, 93, 93, 93, 93, 92, 92, 92, 92, 91, 91, 91, 91, 91, 90, 90, 90, 90, 89, 89, 89, 89, 88, 88, 88, 88, 88, 87, 87, 87, 87, 86, 86, 86, 86, 86, 85, 85, 85, 85, 84, 84, 84, 84, 84, 83, 83, 83, 83, 82, 82, 82, 82, 81, 81, 81, 81, 81, 80, 80, 80, 80, 79, 79, 79, 79, 79, 78, 78, 78, 78, 77, 77, 77, 77, 76, 76, 76, 76, 76, 75, 75, 75, 75, 74, 74, 74, 74, 74, 73, 73, 73, 73, 72, 72, 72, 72, 71, 71, 71, 71, 71, 70, 70, 70, 70, 69, 69, 69, 69, 69, 68, 68, 68, 68, 67, 67, 67, 67, 67, 66, 66, 66, 66, 65, 65, 65, 65, 64, 64, 64, 64, 64, 63, 63, 63, 63, 62, 62, 62, 62, 62, 61, 61, 61, 61, 60, 60, 60, 60, 59, 59, 59, 59, 59, 58, 58, 58, 58, 57, 57, 57, 57, 57, 56, 56, 56, 56, 55, 55, 55, 55, 54, 54, 54, 54, 54, 53, 53, 53, 53, 52, 52, 52, 52, 52, 51, 51, 51, 51, 50, 50, 50, 50, 50, 49, 49, 49, 49, 48, 48, 48, 48, 47, 47, 47, 47, 47, 46, 46, 46, 46, 45, 45, 45, 45, 45, 44, 44, 44, 44, 43, 43, 43, 43, 42, 42, 42, 42, 42, 41, 41, 41, 41, 40, 40, 40, 40, 40, 39, 39, 39, 39, 38, 38, 38, 38, 37, 37, 37, 37, 37, 36, 36, 36, 36, 35, 35, 35, 35, 35, 34, 34, 34, 34, 33, 33, 33, 33, 33, 32, 32, 32, 32, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29, 29, 29, 29, 28, 28, 28, 28, 28, 27, 27, 27, 27, 26, 26, 26, 26, 25, 25, 25, 25, 25, 24, 24, 24, 24, 23, 23, 23, 23, 23, 22, 22, 22, 22, 21, 21, 21, 21, 20, 20, 20, 20, 20, 19, 19, 19, 19, 18, 18, 18];
625         dnxcToken = _dnxcToken;
626         _rewardDistributor = address(owner());
627     }
628     
629     function changeMaximumStakers(uint256 _max) onlyOwner public {
630         maximumStakers = _max;
631     }
632     function changePause(bool _pause) onlyOwner public {
633         paused = _pause;
634     }
635     
636     function changeDistributor(address _address) onlyOwner public {
637         _rewardDistributor = _address;
638     }
639     
640     function changeStakingFees(uint256 _stakingFee) onlyOwner public {
641         stakingFee = _stakingFee;
642     }
643     
644     function stake(uint256 _amount) public payable {
645         require (paused == false, "E09");
646         require (currentStakers <= maximumStakers, "E03");
647         
648         StakerInfo storage user = stakerInfo[msg.sender];
649         require (user.amount.add(_amount) >= minimumStake, "E01");
650         require (dnxcToken.transferFrom(msg.sender, address(this), _amount), "E02");
651         
652         if(user.amount == 0) {
653             require (msg.value >= stakingFee, "E04");
654             user.startStakeTime = block.timestamp;
655             currentStakers = currentStakers.add(1);
656         }
657         
658         user.amount = user.amount.add(_amount);
659     }
660     
661     function unstake() public {
662         
663         StakerInfo storage user = stakerInfo[msg.sender];
664         require(user.amount > 0, "E06");
665         dnxcToken.transfer(
666             msg.sender,
667             user.amount
668         );
669         
670         if (user.claimedEggs == 0) {
671             currentStakers = currentStakers - 1;
672         }
673         
674         user.amount = 0;
675         user.claimedEggs = 0;
676         user.claimedTickets = 0;
677         user.startStakeTime = 0;
678         delete stakerInfo[msg.sender];
679     }
680     
681     function claimEgg(address _recipent) public {
682         require(msg.sender == _rewardDistributor, "E03");
683         StakerInfo storage user = stakerInfo[_recipent];
684         require(isEggClaimable(_recipent), "E07");
685         require(user.claimedEggs < 1, "E05");
686         user.claimedEggs = 1;
687     }
688     
689     function claimTickets(address _recipent) public {
690         require(msg.sender == _rewardDistributor, "E03");
691         StakerInfo storage user = stakerInfo[_recipent];
692         require(countTicketsClaimable(_recipent) > 0, "E08");
693         user.claimedTickets = user.claimedTickets.add(countTicketsClaimable(_recipent));
694     }
695     
696     function countTicketsClaimable(address _user) public view returns (uint256) {
697         StakerInfo storage user = stakerInfo[_user];
698         uint256 eligibleTicketsPerRound = user.amount.div(100000000000000000000);
699         uint256 weeksAfterStakingStarted = ( block.timestamp - user.startStakeTime ).div(7 days);
700         uint256 totalTickets = eligibleTicketsPerRound.mul(weeksAfterStakingStarted);
701         return totalTickets.sub(user.claimedTickets);
702     }
703     
704     function isEggClaimable(address _user) public view returns (bool) {
705         StakerInfo storage user = stakerInfo[_user];
706         require(user.claimedEggs < 1, "E05");
707         uint256 cappedAmount = user.amount;
708         if (cappedAmount > maximumStake) {
709             cappedAmount = maximumStake;
710         }
711         
712         uint256 ratio = cappedAmount.sub(minimumStake).div(10000000000000000000);
713         if (ratio > 450) {
714             ratio = 450;
715         }
716        
717         return (block.timestamp >user.startStakeTime + ( timeTable[ratio] * 1 days ));
718     }
719     
720     function getDeliveryTimeForEgg(address _user) public view returns (uint256) {
721         
722         StakerInfo storage user = stakerInfo[_user];
723         uint256 cappedAmount = user.amount;
724         if (cappedAmount > maximumStake) {
725             cappedAmount = maximumStake;
726         }
727         
728         
729         uint256 ratio = cappedAmount.sub(minimumStake).div(10000000000000000000);
730         if (ratio > 450) {
731             ratio = 450;
732         }
733        
734         return (user.startStakeTime + ( timeTable[ratio] * 1 days ));
735     }
736     
737     function getDeliveryTimeForEggByAmount(uint256 _amount) public view returns (uint256) {
738         
739         uint256 cappedAmount = _amount;
740         if (cappedAmount > maximumStake) {
741             cappedAmount = maximumStake;
742         }
743         
744         if (cappedAmount == 0) {
745             return 0;
746         }
747         
748         uint256 ratio = cappedAmount.sub(minimumStake).div(10000000000000000000);
749         if (ratio > 450) {
750             ratio = 450;
751         }
752        
753         return (( timeTable[ratio] * 1 days ));
754     }
755     function getTimestampOfStartedStaking(address _user) public view returns (uint256) {
756         StakerInfo storage user = stakerInfo[_user];
757         return user.startStakeTime;
758     }
759     
760     /** 
761      * Requests randomness for distribution
762      */
763     function getRandomNumber() public onlyOwner returns (bytes32 requestId) {
764         require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
765         return requestRandomness(keyHash, fee);
766     }
767     
768     function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
769         randomResult = randomness;
770     }
771     
772     function withdrawLink() onlyOwner external {
773         require(LINK.transfer(msg.sender, LINK.balanceOf(address(this))), "Unable to transfer");
774     }
775     
776     function withdrawFees() onlyOwner external {
777         require(payable(msg.sender).send(address(this).balance));
778     }
779     
780 
781 }