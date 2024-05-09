1 pragma solidity ^0.4.24;
2 
3 // File: Multiownable/contracts/Multiownable.sol
4 
5 contract Multiownable {
6 
7     // VARIABLES
8 
9     uint256 public ownersGeneration;
10     uint256 public howManyOwnersDecide;
11     address[] public owners;
12     bytes32[] public allOperations;
13     address internal insideCallSender;
14     uint256 internal insideCallCount;
15 
16     // Reverse lookup tables for owners and allOperations
17     mapping(address => uint) public ownersIndices; // Starts from 1
18     mapping(bytes32 => uint) public allOperationsIndicies;
19 
20     // Owners voting mask per operations
21     mapping(bytes32 => uint256) public votesMaskByOperation;
22     mapping(bytes32 => uint256) public votesCountByOperation;
23 
24     // EVENTS
25 
26     event OwnershipTransferred(address[] previousOwners, uint howManyOwnersDecide, address[] newOwners, uint newHowManyOwnersDecide);
27     event OperationCreated(bytes32 operation, uint howMany, uint ownersCount, address proposer);
28     event OperationUpvoted(bytes32 operation, uint votes, uint howMany, uint ownersCount, address upvoter);
29     event OperationPerformed(bytes32 operation, uint howMany, uint ownersCount, address performer);
30     event OperationDownvoted(bytes32 operation, uint votes, uint ownersCount,  address downvoter);
31     event OperationCancelled(bytes32 operation, address lastCanceller);
32     
33     // ACCESSORS
34 
35     function isOwner(address wallet) public constant returns(bool) {
36         return ownersIndices[wallet] > 0;
37     }
38 
39     function ownersCount() public constant returns(uint) {
40         return owners.length;
41     }
42 
43     function allOperationsCount() public constant returns(uint) {
44         return allOperations.length;
45     }
46 
47     // MODIFIERS
48 
49     /**
50     * @dev Allows to perform method by any of the owners
51     */
52     modifier onlyAnyOwner {
53         if (checkHowManyOwners(1)) {
54             bool update = (insideCallSender == address(0));
55             if (update) {
56                 insideCallSender = msg.sender;
57                 insideCallCount = 1;
58             }
59             _;
60             if (update) {
61                 insideCallSender = address(0);
62                 insideCallCount = 0;
63             }
64         }
65     }
66 
67     /**
68     * @dev Allows to perform method only after many owners call it with the same arguments
69     */
70     modifier onlyManyOwners {
71         if (checkHowManyOwners(howManyOwnersDecide)) {
72             bool update = (insideCallSender == address(0));
73             if (update) {
74                 insideCallSender = msg.sender;
75                 insideCallCount = howManyOwnersDecide;
76             }
77             _;
78             if (update) {
79                 insideCallSender = address(0);
80                 insideCallCount = 0;
81             }
82         }
83     }
84 
85     /**
86     * @dev Allows to perform method only after all owners call it with the same arguments
87     */
88     modifier onlyAllOwners {
89         if (checkHowManyOwners(owners.length)) {
90             bool update = (insideCallSender == address(0));
91             if (update) {
92                 insideCallSender = msg.sender;
93                 insideCallCount = owners.length;
94             }
95             _;
96             if (update) {
97                 insideCallSender = address(0);
98                 insideCallCount = 0;
99             }
100         }
101     }
102 
103     /**
104     * @dev Allows to perform method only after some owners call it with the same arguments
105     */
106     modifier onlySomeOwners(uint howMany) {
107         require(howMany > 0, "onlySomeOwners: howMany argument is zero");
108         require(howMany <= owners.length, "onlySomeOwners: howMany argument exceeds the number of owners");
109         
110         if (checkHowManyOwners(howMany)) {
111             bool update = (insideCallSender == address(0));
112             if (update) {
113                 insideCallSender = msg.sender;
114                 insideCallCount = howMany;
115             }
116             _;
117             if (update) {
118                 insideCallSender = address(0);
119                 insideCallCount = 0;
120             }
121         }
122     }
123 
124     // CONSTRUCTOR
125 
126     constructor() public {
127         owners.push(msg.sender);
128         ownersIndices[msg.sender] = 1;
129         howManyOwnersDecide = 1;
130     }
131 
132     // INTERNAL METHODS
133 
134     /**
135      * @dev onlyManyOwners modifier helper
136      */
137     function checkHowManyOwners(uint howMany) internal returns(bool) {
138         if (insideCallSender == msg.sender) {
139             require(howMany <= insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");
140             return true;
141         }
142 
143         uint ownerIndex = ownersIndices[msg.sender] - 1;
144         require(ownerIndex < owners.length, "checkHowManyOwners: msg.sender is not an owner");
145         bytes32 operation = keccak256(msg.data, ownersGeneration);
146 
147         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");
148         votesMaskByOperation[operation] |= (2 ** ownerIndex);
149         uint operationVotesCount = votesCountByOperation[operation] + 1;
150         votesCountByOperation[operation] = operationVotesCount;
151         if (operationVotesCount == 1) {
152             allOperationsIndicies[operation] = allOperations.length;
153             allOperations.push(operation);
154             emit OperationCreated(operation, howMany, owners.length, msg.sender);
155         }
156         emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);
157 
158         // If enough owners confirmed the same operation
159         if (votesCountByOperation[operation] == howMany) {
160             deleteOperation(operation);
161             emit OperationPerformed(operation, howMany, owners.length, msg.sender);
162             return true;
163         }
164 
165         return false;
166     }
167 
168     /**
169     * @dev Used to delete cancelled or performed operation
170     * @param operation defines which operation to delete
171     */
172     function deleteOperation(bytes32 operation) internal {
173         uint index = allOperationsIndicies[operation];
174         if (index < allOperations.length - 1) { // Not last
175             allOperations[index] = allOperations[allOperations.length - 1];
176             allOperationsIndicies[allOperations[index]] = index;
177         }
178         allOperations.length--;
179 
180         delete votesMaskByOperation[operation];
181         delete votesCountByOperation[operation];
182         delete allOperationsIndicies[operation];
183     }
184 
185     // PUBLIC METHODS
186 
187     /**
188     * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations
189     * @param operation defines which operation to delete
190     */
191     function cancelPending(bytes32 operation) public onlyAnyOwner {
192         uint ownerIndex = ownersIndices[msg.sender] - 1;
193         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0, "cancelPending: operation not found for this user");
194         votesMaskByOperation[operation] &= ~(2 ** ownerIndex);
195         uint operationVotesCount = votesCountByOperation[operation] - 1;
196         votesCountByOperation[operation] = operationVotesCount;
197         emit OperationDownvoted(operation, operationVotesCount, owners.length, msg.sender);
198         if (operationVotesCount == 0) {
199             deleteOperation(operation);
200             emit OperationCancelled(operation, msg.sender);
201         }
202     }
203 
204     /**
205     * @dev Allows owners to change ownership
206     * @param newOwners defines array of addresses of new owners
207     */
208     function transferOwnership(address[] newOwners) public {
209         transferOwnershipWithHowMany(newOwners, newOwners.length);
210     }
211 
212     /**
213     * @dev Allows owners to change ownership
214     * @param newOwners defines array of addresses of new owners
215     * @param newHowManyOwnersDecide defines how many owners can decide
216     */
217     function transferOwnershipWithHowMany(address[] newOwners, uint256 newHowManyOwnersDecide) public onlyManyOwners {
218         require(newOwners.length > 0, "transferOwnershipWithHowMany: owners array is empty");
219         require(newOwners.length <= 256, "transferOwnershipWithHowMany: owners count is greater then 256");
220         require(newHowManyOwnersDecide > 0, "transferOwnershipWithHowMany: newHowManyOwnersDecide equal to 0");
221         require(newHowManyOwnersDecide <= newOwners.length, "transferOwnershipWithHowMany: newHowManyOwnersDecide exceeds the number of owners");
222 
223         // Reset owners reverse lookup table
224         for (uint j = 0; j < owners.length; j++) {
225             delete ownersIndices[owners[j]];
226         }
227         for (uint i = 0; i < newOwners.length; i++) {
228             require(newOwners[i] != address(0), "transferOwnershipWithHowMany: owners array contains zero");
229             require(ownersIndices[newOwners[i]] == 0, "transferOwnershipWithHowMany: owners array contains duplicates");
230             ownersIndices[newOwners[i]] = i + 1;
231         }
232         
233         emit OwnershipTransferred(owners, howManyOwnersDecide, newOwners, newHowManyOwnersDecide);
234         owners = newOwners;
235         howManyOwnersDecide = newHowManyOwnersDecide;
236         allOperations.length = 0;
237         ownersGeneration++;
238     }
239 
240 }
241 
242 // File: zeppelin-solidity/contracts/math/SafeMath.sol
243 
244 /**
245  * @title SafeMath
246  * @dev Math operations with safety checks that throw on error
247  */
248 library SafeMath {
249 
250   /**
251   * @dev Multiplies two numbers, throws on overflow.
252   */
253   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
254     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
255     // benefit is lost if 'b' is also tested.
256     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
257     if (a == 0) {
258       return 0;
259     }
260 
261     c = a * b;
262     assert(c / a == b);
263     return c;
264   }
265 
266   /**
267   * @dev Integer division of two numbers, truncating the quotient.
268   */
269   function div(uint256 a, uint256 b) internal pure returns (uint256) {
270     // assert(b > 0); // Solidity automatically throws when dividing by 0
271     // uint256 c = a / b;
272     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273     return a / b;
274   }
275 
276   /**
277   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
278   */
279   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
280     assert(b <= a);
281     return a - b;
282   }
283 
284   /**
285   * @dev Adds two numbers, throws on overflow.
286   */
287   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
288     c = a + b;
289     assert(c >= a);
290     return c;
291   }
292 }
293 
294 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
295 
296 /**
297  * @title Ownable
298  * @dev The Ownable contract has an owner address, and provides basic authorization control
299  * functions, this simplifies the implementation of "user permissions".
300  */
301 contract Ownable {
302   address public owner;
303 
304 
305   event OwnershipRenounced(address indexed previousOwner);
306   event OwnershipTransferred(
307     address indexed previousOwner,
308     address indexed newOwner
309   );
310 
311 
312   /**
313    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
314    * account.
315    */
316   constructor() public {
317     owner = msg.sender;
318   }
319 
320   /**
321    * @dev Throws if called by any account other than the owner.
322    */
323   modifier onlyOwner() {
324     require(msg.sender == owner);
325     _;
326   }
327 
328   /**
329    * @dev Allows the current owner to relinquish control of the contract.
330    */
331   function renounceOwnership() public onlyOwner {
332     emit OwnershipRenounced(owner);
333     owner = address(0);
334   }
335 
336   /**
337    * @dev Allows the current owner to transfer control of the contract to a newOwner.
338    * @param _newOwner The address to transfer ownership to.
339    */
340   function transferOwnership(address _newOwner) public onlyOwner {
341     _transferOwnership(_newOwner);
342   }
343 
344   /**
345    * @dev Transfers control of the contract to a newOwner.
346    * @param _newOwner The address to transfer ownership to.
347    */
348   function _transferOwnership(address _newOwner) internal {
349     require(_newOwner != address(0));
350     emit OwnershipTransferred(owner, _newOwner);
351     owner = _newOwner;
352   }
353 }
354 
355 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
356 
357 /**
358  * @title ERC20Basic
359  * @dev Simpler version of ERC20 interface
360  * @dev see https://github.com/ethereum/EIPs/issues/179
361  */
362 contract ERC20Basic {
363   function totalSupply() public view returns (uint256);
364   function balanceOf(address who) public view returns (uint256);
365   function transfer(address to, uint256 value) public returns (bool);
366   event Transfer(address indexed from, address indexed to, uint256 value);
367 }
368 
369 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
370 
371 /**
372  * @title ERC20 interface
373  * @dev see https://github.com/ethereum/EIPs/issues/20
374  */
375 contract ERC20 is ERC20Basic {
376   function allowance(address owner, address spender)
377     public view returns (uint256);
378 
379   function transferFrom(address from, address to, uint256 value)
380     public returns (bool);
381 
382   function approve(address spender, uint256 value) public returns (bool);
383   event Approval(
384     address indexed owner,
385     address indexed spender,
386     uint256 value
387   );
388 }
389 
390 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure.
395  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
396  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
397  */
398 library SafeERC20 {
399   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
400     require(token.transfer(to, value));
401   }
402 
403   function safeTransferFrom(
404     ERC20 token,
405     address from,
406     address to,
407     uint256 value
408   )
409     internal
410   {
411     require(token.transferFrom(from, to, value));
412   }
413 
414   function safeApprove(ERC20 token, address spender, uint256 value) internal {
415     require(token.approve(spender, value));
416   }
417 }
418 
419 // File: contracts/TokenSwap.sol
420 
421 /**
422  * @title TokenSwap
423  * This product is protected under license.  Any unauthorized copy, modification, or use without
424  * express written consent from the creators is prohibited.
425  */
426 
427 
428 
429 
430 
431 
432 
433 contract TokenSwap is Ownable, Multiownable {
434 
435     // LIBRARIES
436 
437     using SafeERC20 for ERC20;
438     using SafeMath for uint256;
439 
440     // TYPES
441 
442     enum Status {AddParties, WaitingDeposits, SwapConfirmed, SwapCanceled}
443 
444     struct SwapOffer {
445         address participant;
446         ERC20 token;
447 
448         uint256 tokensForSwap;
449         uint256 withdrawnTokensForSwap;
450 
451         uint256 tokensFee;
452         uint256 withdrawnFee;
453 
454         uint256 tokensTotal;
455         uint256 withdrawnTokensTotal;
456     }
457 
458     struct LockupStage {
459         uint256 secondsSinceLockupStart;
460         uint8 unlockedTokensPercentage;
461     }
462 
463     // VARIABLES
464     Status public status = Status.AddParties;
465 
466     uint256 internal startLockupAt;
467     LockupStage[] internal lockupStages;
468 
469     address[] internal participants;
470     mapping(address => bool) internal isParticipant;
471     mapping(address => address) internal tokenByParticipant;
472     mapping(address => SwapOffer) internal offerByToken;
473 
474     // EVENTS
475     event AddLockupStage(uint256 secondsSinceLockupStart, uint8 unlockedTokensPercentage);
476     event StatusUpdate(Status oldStatus, Status newStatus);
477     event AddParty(address participant, ERC20 token, uint256 amount);
478     event RemoveParty(address participant);
479     event ConfirmParties();
480     event CancelSwap();
481     event ConfirmSwap();
482     event StartLockup(uint256 startLockupAt);
483     event Withdraw(address participant, ERC20 token, uint256 amount);
484     event WithdrawFee(ERC20 token, uint256 amount);
485     event Reclaim(address participant, ERC20 token, uint256 amount);
486 
487     // MODIFIERS
488     modifier onlyParticipant {
489         require(
490             isParticipant[msg.sender] == true,
491             "Only swap participants allowed to call the method"
492         );
493         _;
494     }
495 
496     modifier canAddParty {
497         require(status == Status.AddParties, "Unable to add new parties in the current status");
498         _;
499     }
500 
501     modifier canRemoveParty {
502         require(status == Status.AddParties, "Unable to remove parties in the current status");
503         _;
504     }
505 
506     modifier canConfirmParties {
507         require(
508             status == Status.AddParties,
509             "Unable to confirm parties in the current status"
510         );
511         require(participants.length > 1, "Need at least two participants");
512         _;
513     }
514 
515     modifier canCancelSwap {
516         require(
517             status == Status.WaitingDeposits,
518             "Unable to cancel swap in the current status"
519         );
520         _;
521     }
522 
523     modifier canConfirmSwap {
524         require(status == Status.WaitingDeposits, "Unable to confirm in the current status");
525         require(
526             _haveEveryoneDeposited(),
527             "Unable to confirm swap before all parties have deposited tokens"
528         );
529         _;
530     }
531 
532     modifier canWithdraw {
533         require(status == Status.SwapConfirmed, "Unable to withdraw tokens in the current status");
534         require(startLockupAt != 0, "Lockup has not been started");
535         _;
536     }
537 
538     modifier canWithdrawFee {
539         require(status == Status.SwapConfirmed, "Unable to withdraw fee in the current status");
540         require(startLockupAt != 0, "Lockup has not been started");
541         _;
542     }
543 
544     modifier canReclaim {
545         require(
546             status == Status.SwapConfirmed || status == Status.SwapCanceled,
547             "Unable to reclaim in the current status"
548         );
549         _;
550     }
551 
552     // CONSTRUCTOR
553     constructor() public {
554         _initializeLockupStages();
555         _validateLockupStages();
556     }
557 
558     // EXTERNAL METHODS
559     /**
560      * @dev Add new party to the swap.
561      * @param _participant Address of the participant.
562      * @param _token An ERC20-compliant token which participant is offering to swap.
563      * @param _tokensForSwap How much tokens the participant wants to swap.
564      * @param _tokensFee How much tokens will be payed as a fee.
565      * @param _tokensTotal How much tokens the participant is offering (i.e. _tokensForSwap + _tokensFee).
566      */
567     function addParty(
568         address _participant,
569         ERC20 _token,
570         uint256 _tokensForSwap,
571         uint256 _tokensFee,
572         uint256 _tokensTotal
573     )
574     external
575     onlyOwner
576     canAddParty
577     {
578         require(_participant != address(0), "_participant is invalid address");
579         require(_token != address(0), "_token is invalid address");
580         require(_tokensForSwap > 0, "_tokensForSwap must be positive");
581         require(_tokensFee > 0, "_tokensFee must be positive");
582         require(_tokensTotal == _tokensForSwap.add(_tokensFee), "token amounts inconsistency");
583         require(
584             isParticipant[_participant] == false,
585             "Unable to add the same party multiple times"
586         );
587 
588         isParticipant[_participant] = true;
589         SwapOffer memory offer = SwapOffer({
590             participant: _participant,
591             token: _token,
592             tokensForSwap: _tokensForSwap,
593             withdrawnTokensForSwap: 0,
594             tokensFee: _tokensFee,
595             withdrawnFee: 0,
596             tokensTotal: _tokensTotal,
597             withdrawnTokensTotal: 0
598         });
599         participants.push(offer.participant);
600         offerByToken[offer.token] = offer;
601         tokenByParticipant[offer.participant] = offer.token;
602 
603         emit AddParty(offer.participant, offer.token, offer.tokensTotal);
604     }
605 
606     /**
607      * @dev Remove party.
608      * @param _participantIndex Index of the participant in the participants array.
609      */
610     function removeParty(uint256 _participantIndex) external onlyOwner canRemoveParty {
611         require(_participantIndex < participants.length, "Participant does not exist");
612 
613         address participant = participants[_participantIndex];
614         address token = tokenByParticipant[participant];
615 
616         delete isParticipant[participant];
617         participants[_participantIndex] = participants[participants.length - 1];
618         participants.length--;
619         delete offerByToken[token];
620         delete tokenByParticipant[participant];
621 
622         emit RemoveParty(participant);
623     }
624 
625     /**
626      * @dev Confirm swap parties
627      */
628     function confirmParties() external onlyOwner canConfirmParties {
629         address[] memory newOwners = new address[](participants.length + 1);
630 
631         for (uint256 i = 0; i < participants.length; i++) {
632             newOwners[i] = participants[i];
633         }
634 
635         newOwners[newOwners.length - 1] = owner;
636         transferOwnershipWithHowMany(newOwners, newOwners.length - 1);
637         _changeStatus(Status.WaitingDeposits);
638         emit ConfirmParties();
639     }
640 
641     /**
642      * @dev Confirm swap.
643      */
644     function confirmSwap() external canConfirmSwap onlyManyOwners {
645         emit ConfirmSwap();
646         _changeStatus(Status.SwapConfirmed);
647         _startLockup();
648     }
649 
650     /**
651      * @dev Cancel swap.
652      */
653     function cancelSwap() external canCancelSwap onlyManyOwners {
654         emit CancelSwap();
655         _changeStatus(Status.SwapCanceled);
656     }
657 
658     /**
659      * @dev Withdraw tokens
660      */
661     function withdraw() external onlyParticipant canWithdraw {
662         for (uint i = 0; i < participants.length; i++) {
663             address token = tokenByParticipant[participants[i]];
664             SwapOffer storage offer = offerByToken[token];
665 
666             if (offer.participant == msg.sender) {
667                 continue;
668             }
669 
670             uint256 tokenReceivers = participants.length - 1;
671             uint256 tokensAmount = _withdrawableAmount(offer).div(tokenReceivers);
672 
673             offer.token.safeTransfer(msg.sender, tokensAmount);
674             emit Withdraw(msg.sender, offer.token, tokensAmount);
675             offer.withdrawnTokensForSwap = offer.withdrawnTokensForSwap.add(tokensAmount);
676             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
677         }
678     }
679 
680     /**
681      * @dev Withdraw swap fee
682      */
683     function withdrawFee() external onlyOwner canWithdrawFee {
684         for (uint i = 0; i < participants.length; i++) {
685             address token = tokenByParticipant[participants[i]];
686             SwapOffer storage offer = offerByToken[token];
687 
688             uint256 tokensAmount = _withdrawableFee(offer);
689 
690             offer.token.safeTransfer(msg.sender, tokensAmount);
691             emit WithdrawFee(offer.token, tokensAmount);
692             offer.withdrawnFee = offer.withdrawnFee.add(tokensAmount);
693             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
694         }
695     }
696 
697     /**
698      * @dev Reclaim tokens if a participant has deposited too much or if the swap has been canceled.
699      */
700     function reclaim() external onlyParticipant canReclaim {
701         address token = tokenByParticipant[msg.sender];
702 
703         SwapOffer storage offer = offerByToken[token];
704         uint256 currentBalance = offer.token.balanceOf(address(this));
705         uint256 availableForReclaim = currentBalance
706         .sub(offer.tokensTotal.sub(offer.withdrawnTokensTotal));
707 
708         if (status == Status.SwapCanceled) {
709             availableForReclaim = currentBalance;
710         }
711 
712         offer.token.safeTransfer(offer.participant, availableForReclaim);
713         emit Reclaim(offer.participant, offer.token, availableForReclaim);
714     }
715 
716     // INTERNAL METHODS
717     /**
718      * @dev Initialize lockup period stages.
719      */
720     function _initializeLockupStages() internal {
721         _addLockupStage(LockupStage(0, 10));
722         _addLockupStage(LockupStage(10 minutes, 100));
723     }
724 
725     /**
726      * @dev Add lockup period stage
727      */
728     function _addLockupStage(LockupStage _stage) internal {
729         emit AddLockupStage(_stage.secondsSinceLockupStart, _stage.unlockedTokensPercentage);
730         lockupStages.push(_stage);
731     }
732 
733     /**
734      * @dev Validate lock-up period configuration.
735      */
736     function _validateLockupStages() internal view {
737         for (uint i = 0; i < lockupStages.length; i++) {
738             LockupStage memory stage = lockupStages[i];
739 
740             require(
741                 stage.unlockedTokensPercentage >= 0,
742                 "LockupStage.unlockedTokensPercentage must not be negative"
743             );
744             require(
745                 stage.unlockedTokensPercentage <= 100,
746                 "LockupStage.unlockedTokensPercentage must not be greater than 100"
747             );
748 
749             if (i == 0) {
750                 continue;
751             }
752 
753             LockupStage memory previousStage = lockupStages[i - 1];
754             require(
755                 stage.secondsSinceLockupStart > previousStage.secondsSinceLockupStart,
756                 "LockupStage.secondsSinceLockupStart must increase monotonically"
757             );
758             require(
759                 stage.unlockedTokensPercentage > previousStage.unlockedTokensPercentage,
760                 "LockupStage.unlockedTokensPercentage must increase monotonically"
761             );
762         }
763 
764         require(
765             lockupStages[0].secondsSinceLockupStart == 0,
766             "The first lockup stage must start immediately"
767         );
768         require(
769             lockupStages[lockupStages.length - 1].unlockedTokensPercentage == 100,
770             "The last lockup stage must unlock 100% of tokens"
771         );
772     }
773 
774     /**
775      * @dev Change swap status.
776      */
777     function _changeStatus(Status _newStatus) internal {
778         emit StatusUpdate(status, _newStatus);
779         status = _newStatus;
780     }
781 
782     /**
783      * @dev Check whether every participant has deposited enough tokens for the swap to be confirmed.
784      */
785     function _haveEveryoneDeposited() internal view returns(bool) {
786         for (uint i = 0; i < participants.length; i++) {
787             address token = tokenByParticipant[participants[i]];
788             SwapOffer memory offer = offerByToken[token];
789 
790             if (offer.token.balanceOf(address(this)) < offer.tokensTotal) {
791                 return false;
792             }
793         }
794 
795         return true;
796     }
797 
798     /**
799      * @dev Start lockup period
800      */
801     function _startLockup() internal {
802         startLockupAt = now;
803         emit StartLockup(startLockupAt);
804     }
805 
806     /**
807      * @dev Find amount of tokens ready to be withdrawn by a swap party.
808      */
809     function _withdrawableAmount(SwapOffer _offer) internal view returns(uint256) {
810         return _unlockedAmount(_offer.tokensForSwap).sub(_offer.withdrawnTokensForSwap);
811     }
812 
813     /**
814      * @dev Find amount of tokens ready to be withdrawn as the swap fee.
815      */
816     function _withdrawableFee(SwapOffer _offer) internal view returns(uint256) {
817         return _unlockedAmount(_offer.tokensFee).sub(_offer.withdrawnFee);
818     }
819 
820     /**
821      * @dev Find amount of unlocked tokens, including withdrawn tokens.
822      */
823     function _unlockedAmount(uint256 totalAmount) internal view returns(uint256) {
824         return totalAmount.mul(_getUnlockedTokensPercentage()).div(100);
825     }
826 
827     /**
828      * @dev Get percent of unlocked tokens
829      */
830     function _getUnlockedTokensPercentage() internal view returns(uint256) {
831         for (uint256 i = lockupStages.length; i > 0; i--) {
832             LockupStage storage stage = lockupStages[i - 1];
833             uint256 stageBecomesActiveAt = startLockupAt.add(stage.secondsSinceLockupStart);
834 
835             if (now < stageBecomesActiveAt) {
836                 continue;
837             }
838 
839             return stage.unlockedTokensPercentage;
840         }
841     }
842 }