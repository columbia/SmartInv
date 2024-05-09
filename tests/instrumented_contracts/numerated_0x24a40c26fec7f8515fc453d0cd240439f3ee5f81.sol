1 pragma solidity ^0.4.23;
2 /**
3  * @title TokenSwap
4  * This product is protected under license.  Any unauthorized copy, modification, or use without
5  * express written consent from the creators is prohibited.
6  */
7 
8 // File: Multiownable/contracts/Multiownable.sol
9 
10 contract Multiownable {
11 
12     // VARIABLES
13 
14     uint256 public ownersGeneration;
15     uint256 public howManyOwnersDecide;
16     address[] public owners;
17     bytes32[] public allOperations;
18     address internal insideCallSender;
19     uint256 internal insideCallCount;
20 
21     // Reverse lookup tables for owners and allOperations
22     mapping(address => uint) public ownersIndices; // Starts from 1
23     mapping(bytes32 => uint) public allOperationsIndicies;
24 
25     // Owners voting mask per operations
26     mapping(bytes32 => uint256) public votesMaskByOperation;
27     mapping(bytes32 => uint256) public votesCountByOperation;
28 
29     // EVENTS
30 
31     event OwnershipTransferred(address[] previousOwners, uint howManyOwnersDecide, address[] newOwners, uint newHowManyOwnersDecide);
32     event OperationCreated(bytes32 operation, uint howMany, uint ownersCount, address proposer);
33     event OperationUpvoted(bytes32 operation, uint votes, uint howMany, uint ownersCount, address upvoter);
34     event OperationPerformed(bytes32 operation, uint howMany, uint ownersCount, address performer);
35     event OperationDownvoted(bytes32 operation, uint votes, uint ownersCount,  address downvoter);
36     event OperationCancelled(bytes32 operation, address lastCanceller);
37 
38     // ACCESSORS
39 
40     function isOwner(address wallet) public constant returns(bool) {
41         return ownersIndices[wallet] > 0;
42     }
43 
44     function ownersCount() public constant returns(uint) {
45         return owners.length;
46     }
47 
48     function allOperationsCount() public constant returns(uint) {
49         return allOperations.length;
50     }
51 
52     // MODIFIERS
53 
54     /**
55     * @dev Allows to perform method by any of the owners
56     */
57     modifier onlyAnyOwner {
58         if (checkHowManyOwners(1)) {
59             bool update = (insideCallSender == address(0));
60             if (update) {
61                 insideCallSender = msg.sender;
62                 insideCallCount = 1;
63             }
64             _;
65             if (update) {
66                 insideCallSender = address(0);
67                 insideCallCount = 0;
68             }
69         }
70     }
71 
72     /**
73     * @dev Allows to perform method only after many owners call it with the same arguments
74     */
75     modifier onlyManyOwners {
76         if (checkHowManyOwners(howManyOwnersDecide)) {
77             bool update = (insideCallSender == address(0));
78             if (update) {
79                 insideCallSender = msg.sender;
80                 insideCallCount = howManyOwnersDecide;
81             }
82             _;
83             if (update) {
84                 insideCallSender = address(0);
85                 insideCallCount = 0;
86             }
87         }
88     }
89 
90     /**
91     * @dev Allows to perform method only after all owners call it with the same arguments
92     */
93     modifier onlyAllOwners {
94         if (checkHowManyOwners(owners.length)) {
95             bool update = (insideCallSender == address(0));
96             if (update) {
97                 insideCallSender = msg.sender;
98                 insideCallCount = owners.length;
99             }
100             _;
101             if (update) {
102                 insideCallSender = address(0);
103                 insideCallCount = 0;
104             }
105         }
106     }
107 
108     /**
109     * @dev Allows to perform method only after some owners call it with the same arguments
110     */
111     modifier onlySomeOwners(uint howMany) {
112         require(howMany > 0, "onlySomeOwners: howMany argument is zero");
113         require(howMany <= owners.length, "onlySomeOwners: howMany argument exceeds the number of owners");
114 
115         if (checkHowManyOwners(howMany)) {
116             bool update = (insideCallSender == address(0));
117             if (update) {
118                 insideCallSender = msg.sender;
119                 insideCallCount = howMany;
120             }
121             _;
122             if (update) {
123                 insideCallSender = address(0);
124                 insideCallCount = 0;
125             }
126         }
127     }
128 
129     // CONSTRUCTOR
130 
131     constructor() public {
132         owners.push(msg.sender);
133         ownersIndices[msg.sender] = 1;
134         howManyOwnersDecide = 1;
135     }
136 
137     // INTERNAL METHODS
138 
139     /**
140      * @dev onlyManyOwners modifier helper
141      */
142     function checkHowManyOwners(uint howMany) internal returns(bool) {
143         if (insideCallSender == msg.sender) {
144             require(howMany <= insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");
145             return true;
146         }
147 
148         uint ownerIndex = ownersIndices[msg.sender] - 1;
149         require(ownerIndex < owners.length, "checkHowManyOwners: msg.sender is not an owner");
150         bytes32 operation = keccak256(msg.data, ownersGeneration);
151 
152         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");
153         votesMaskByOperation[operation] |= (2 ** ownerIndex);
154         uint operationVotesCount = votesCountByOperation[operation] + 1;
155         votesCountByOperation[operation] = operationVotesCount;
156         if (operationVotesCount == 1) {
157             allOperationsIndicies[operation] = allOperations.length;
158             allOperations.push(operation);
159             emit OperationCreated(operation, howMany, owners.length, msg.sender);
160         }
161         emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);
162 
163         // If enough owners confirmed the same operation
164         if (votesCountByOperation[operation] == howMany) {
165             deleteOperation(operation);
166             emit OperationPerformed(operation, howMany, owners.length, msg.sender);
167             return true;
168         }
169 
170         return false;
171     }
172 
173     /**
174     * @dev Used to delete cancelled or performed operation
175     * @param operation defines which operation to delete
176     */
177     function deleteOperation(bytes32 operation) internal {
178         uint index = allOperationsIndicies[operation];
179         if (index < allOperations.length - 1) { // Not last
180             allOperations[index] = allOperations[allOperations.length - 1];
181             allOperationsIndicies[allOperations[index]] = index;
182         }
183         allOperations.length--;
184 
185         delete votesMaskByOperation[operation];
186         delete votesCountByOperation[operation];
187         delete allOperationsIndicies[operation];
188     }
189 
190     // PUBLIC METHODS
191 
192     /**
193     * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations
194     * @param operation defines which operation to delete
195     */
196     function cancelPending(bytes32 operation) public onlyAnyOwner {
197         uint ownerIndex = ownersIndices[msg.sender] - 1;
198         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0, "cancelPending: operation not found for this user");
199         votesMaskByOperation[operation] &= ~(2 ** ownerIndex);
200         uint operationVotesCount = votesCountByOperation[operation] - 1;
201         votesCountByOperation[operation] = operationVotesCount;
202         emit OperationDownvoted(operation, operationVotesCount, owners.length, msg.sender);
203         if (operationVotesCount == 0) {
204             deleteOperation(operation);
205             emit OperationCancelled(operation, msg.sender);
206         }
207     }
208 
209     /**
210     * @dev Allows owners to change ownership
211     * @param newOwners defines array of addresses of new owners
212     */
213     function transferOwnership(address[] newOwners) public {
214         transferOwnershipWithHowMany(newOwners, newOwners.length);
215     }
216 
217     /**
218     * @dev Allows owners to change ownership
219     * @param newOwners defines array of addresses of new owners
220     * @param newHowManyOwnersDecide defines how many owners can decide
221     */
222     function transferOwnershipWithHowMany(address[] newOwners, uint256 newHowManyOwnersDecide) public onlyManyOwners {
223         require(newOwners.length > 0, "transferOwnershipWithHowMany: owners array is empty");
224         require(newOwners.length <= 256, "transferOwnershipWithHowMany: owners count is greater then 256");
225         require(newHowManyOwnersDecide > 0, "transferOwnershipWithHowMany: newHowManyOwnersDecide equal to 0");
226         require(newHowManyOwnersDecide <= newOwners.length, "transferOwnershipWithHowMany: newHowManyOwnersDecide exceeds the number of owners");
227 
228         // Reset owners reverse lookup table
229         for (uint j = 0; j < owners.length; j++) {
230             delete ownersIndices[owners[j]];
231         }
232         for (uint i = 0; i < newOwners.length; i++) {
233             require(newOwners[i] != address(0), "transferOwnershipWithHowMany: owners array contains zero");
234             require(ownersIndices[newOwners[i]] == 0, "transferOwnershipWithHowMany: owners array contains duplicates");
235             ownersIndices[newOwners[i]] = i + 1;
236         }
237 
238         emit OwnershipTransferred(owners, howManyOwnersDecide, newOwners, newHowManyOwnersDecide);
239         owners = newOwners;
240         howManyOwnersDecide = newHowManyOwnersDecide;
241         allOperations.length = 0;
242         ownersGeneration++;
243     }
244 
245 }
246 
247 // File: zeppelin-solidity/contracts/math/SafeMath.sol
248 
249 /**
250  * @title SafeMath
251  * @dev Math operations with safety checks that throw on error
252  */
253 library SafeMath {
254 
255   /**
256   * @dev Multiplies two numbers, throws on overflow.
257   */
258   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
259     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
260     // benefit is lost if 'b' is also tested.
261     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
262     if (a == 0) {
263       return 0;
264     }
265 
266     c = a * b;
267     assert(c / a == b);
268     return c;
269   }
270 
271   /**
272   * @dev Integer division of two numbers, truncating the quotient.
273   */
274   function div(uint256 a, uint256 b) internal pure returns (uint256) {
275     // assert(b > 0); // Solidity automatically throws when dividing by 0
276     // uint256 c = a / b;
277     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
278     return a / b;
279   }
280 
281   /**
282   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
283   */
284   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
285     assert(b <= a);
286     return a - b;
287   }
288 
289   /**
290   * @dev Adds two numbers, throws on overflow.
291   */
292   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
293     c = a + b;
294     assert(c >= a);
295     return c;
296   }
297 }
298 
299 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
300 
301 /**
302  * @title Ownable
303  * @dev The Ownable contract has an owner address, and provides basic authorization control
304  * functions, this simplifies the implementation of "user permissions".
305  */
306 contract Ownable {
307   address public owner;
308 
309 
310   event OwnershipRenounced(address indexed previousOwner);
311   event OwnershipTransferred(
312     address indexed previousOwner,
313     address indexed newOwner
314   );
315 
316 
317   /**
318    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
319    * account.
320    */
321   constructor() public {
322     owner = msg.sender;
323   }
324 
325   /**
326    * @dev Throws if called by any account other than the owner.
327    */
328   modifier onlyOwner() {
329     require(msg.sender == owner);
330     _;
331   }
332 
333   /**
334    * @dev Allows the current owner to relinquish control of the contract.
335    */
336   function renounceOwnership() public onlyOwner {
337     emit OwnershipRenounced(owner);
338     owner = address(0);
339   }
340 
341   /**
342    * @dev Allows the current owner to transfer control of the contract to a newOwner.
343    * @param _newOwner The address to transfer ownership to.
344    */
345   function transferOwnership(address _newOwner) public onlyOwner {
346     _transferOwnership(_newOwner);
347   }
348 
349   /**
350    * @dev Transfers control of the contract to a newOwner.
351    * @param _newOwner The address to transfer ownership to.
352    */
353   function _transferOwnership(address _newOwner) internal {
354     require(_newOwner != address(0));
355     emit OwnershipTransferred(owner, _newOwner);
356     owner = _newOwner;
357   }
358 }
359 
360 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
361 
362 /**
363  * @title ERC20Basic
364  * @dev Simpler version of ERC20 interface
365  * @dev see https://github.com/ethereum/EIPs/issues/179
366  */
367 contract ERC20Basic {
368   function totalSupply() public view returns (uint256);
369   function balanceOf(address who) public view returns (uint256);
370   function transfer(address to, uint256 value) public returns (bool);
371   event Transfer(address indexed from, address indexed to, uint256 value);
372 }
373 
374 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
375 
376 /**
377  * @title ERC20 interface
378  * @dev see https://github.com/ethereum/EIPs/issues/20
379  */
380 contract ERC20 is ERC20Basic {
381   function allowance(address owner, address spender)
382     public view returns (uint256);
383 
384   function transferFrom(address from, address to, uint256 value)
385     public returns (bool);
386 
387   function approve(address spender, uint256 value) public returns (bool);
388   event Approval(
389     address indexed owner,
390     address indexed spender,
391     uint256 value
392   );
393 }
394 
395 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
396 
397 /**
398  * @title SafeERC20
399  * @dev Wrappers around ERC20 operations that throw on failure.
400  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
401  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
402  */
403 library SafeERC20 {
404   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
405     require(token.transfer(to, value));
406   }
407 
408   function safeTransferFrom(
409     ERC20 token,
410     address from,
411     address to,
412     uint256 value
413   )
414     internal
415   {
416     require(token.transferFrom(from, to, value));
417   }
418 
419   function safeApprove(ERC20 token, address spender, uint256 value) internal {
420     require(token.approve(spender, value));
421   }
422 }
423 
424 // File: contracts/TokenSwap.sol
425 
426 /**
427  * @title TokenSwap
428  * This product is protected under license.  Any unauthorized copy, modification, or use without
429  * express written consent from the creators is prohibited.
430  */
431 
432 
433 
434 
435 
436 
437 
438 contract TokenSwap is Ownable, Multiownable {
439 
440     // LIBRARIES
441 
442     using SafeERC20 for ERC20;
443     using SafeMath for uint256;
444 
445     // TYPES
446 
447     enum Status {AddParties, WaitingDeposits, SwapConfirmed, SwapCanceled}
448 
449     struct SwapOffer {
450         address participant;
451         ERC20 token;
452 
453         uint256 tokensForSwap;
454         uint256 withdrawnTokensForSwap;
455 
456         uint256 tokensFee;
457         uint256 withdrawnFee;
458 
459         uint256 tokensTotal;
460         uint256 withdrawnTokensTotal;
461     }
462 
463     struct LockupStage {
464         uint256 secondsSinceLockupStart;
465         uint8 unlockedTokensPercentage;
466     }
467 
468     // VARIABLES
469 
470     Status public status = Status.AddParties;
471 
472     uint256 internal startLockupAt;
473     LockupStage[] internal lockupStages;
474 
475     address[] internal participants;
476     mapping(address => bool) internal isParticipant;
477     mapping(address => address) internal tokenByParticipant;
478     mapping(address => SwapOffer) internal offerByToken;
479 
480     // EVENTS
481 
482     event AddLockupStage(uint256 secondsSinceLockupStart, uint8 unlockedTokensPercentage);
483     event StatusUpdate(Status oldStatus, Status newStatus);
484     event AddParty(address participant, ERC20 token, uint256 amount);
485     event RemoveParty(address participant);
486     event ConfirmParties();
487     event CancelSwap();
488     event ConfirmSwap();
489     event StartLockup(uint256 startLockupAt);
490     event Withdraw(address participant, ERC20 token, uint256 amount);
491     event WithdrawFee(ERC20 token, uint256 amount);
492     event Reclaim(address participant, ERC20 token, uint256 amount);
493 
494     // MODIFIERS
495 
496     modifier onlyParticipant {
497         require(
498             isParticipant[msg.sender] == true,
499             "Only swap participants allowed to call the method"
500         );
501         _;
502     }
503 
504     modifier canAddParty {
505         require(status == Status.AddParties, "Unable to add new parties in the current status");
506         _;
507     }
508 
509     modifier canRemoveParty {
510         require(status == Status.AddParties, "Unable to remove parties in the current status");
511         _;
512     }
513 
514     modifier canConfirmParties {
515         require(
516             status == Status.AddParties,
517             "Unable to confirm parties in the current status"
518         );
519         require(participants.length > 1, "Need at least two participants");
520         _;
521     }
522 
523     modifier canCancelSwap {
524         require(
525             status == Status.WaitingDeposits,
526             "Unable to cancel swap in the current status"
527         );
528         _;
529     }
530 
531     modifier canConfirmSwap {
532         require(status == Status.WaitingDeposits, "Unable to confirm in the current status");
533         require(
534             _haveEveryoneDeposited(),
535             "Unable to confirm swap before all parties have deposited tokens"
536         );
537         _;
538     }
539 
540     modifier canWithdraw {
541         require(status == Status.SwapConfirmed, "Unable to withdraw tokens in the current status");
542         require(startLockupAt != 0, "Lockup has not been started");
543         _;
544     }
545 
546     modifier canWithdrawFee {
547         require(status == Status.SwapConfirmed, "Unable to withdraw fee in the current status");
548         require(startLockupAt != 0, "Lockup has not been started");
549         _;
550     }
551 
552     modifier canReclaim {
553         require(
554             status == Status.SwapConfirmed || status == Status.SwapCanceled,
555             "Unable to reclaim in the current status"
556         );
557         _;
558     }
559 
560     // CONSTRUCTOR
561 
562     constructor() public {
563         _initializeLockupStages();
564         _validateLockupStages();
565     }
566 
567     // EXTERNAL METHODS
568 
569     /**
570      * @dev Add new party to the swap.
571      * @param _participant Address of the participant.
572      * @param _token An ERC20-compliant token which participant is offering to swap.
573      * @param _tokensForSwap How much tokens the participant wants to swap.
574      * @param _tokensFee How much tokens will be payed as a fee.
575      * @param _tokensTotal How much tokens the participant is offering (i.e. _tokensForSwap + _tokensFee).
576      */
577     function addParty(
578         address _participant,
579         ERC20 _token,
580         uint256 _tokensForSwap,
581         uint256 _tokensFee,
582         uint256 _tokensTotal
583     )
584         onlyOwner
585         canAddParty
586         external
587     {
588         require(_participant != address(0), "_participant is invalid address");
589         require(_token != address(0), "_token is invalid address");
590         require(_tokensForSwap > 0, "_tokensForSwap must be positive");
591         require(_tokensFee > 0, "_tokensFee must be positive");
592         require(_tokensTotal == _tokensForSwap.add(_tokensFee), "token amounts inconsistency");
593         require(
594             isParticipant[_participant] == false,
595             "Unable to add the same party multiple times"
596         );
597 
598         isParticipant[_participant] = true;
599         SwapOffer memory offer = SwapOffer({
600             participant: _participant,
601             token: _token,
602             tokensForSwap: _tokensForSwap,
603             withdrawnTokensForSwap: 0,
604             tokensFee: _tokensFee,
605             withdrawnFee: 0,
606             tokensTotal: _tokensTotal,
607             withdrawnTokensTotal: 0
608         });
609         participants.push(offer.participant);
610         offerByToken[offer.token] = offer;
611         tokenByParticipant[offer.participant] = offer.token;
612 
613         emit AddParty(offer.participant, offer.token, offer.tokensTotal);
614     }
615 
616     /**
617      * @dev Remove party.
618      * @param _participantIndex Index of the participant in the participants array.
619      */
620     function removeParty(uint256 _participantIndex) onlyOwner canRemoveParty external {
621         require(_participantIndex < participants.length, "Participant does not exist");
622 
623         address participant = participants[_participantIndex];
624         address token = tokenByParticipant[participant];
625 
626         delete isParticipant[participant];
627         participants[_participantIndex] = participants[participants.length - 1];
628         participants.length--;
629         delete offerByToken[token];
630         delete tokenByParticipant[participant];
631 
632         emit RemoveParty(participant);
633     }
634 
635     /**
636      * @dev Confirm swap parties
637      */
638     function confirmParties() onlyOwner canConfirmParties external {
639         address[] memory newOwners = new address[](participants.length + 1);
640 
641         for (uint256 i = 0; i < participants.length; i++) {
642             newOwners[i] = participants[i];
643         }
644 
645         newOwners[newOwners.length - 1] = owner;
646         transferOwnershipWithHowMany(newOwners, newOwners.length - 1);
647         _changeStatus(Status.WaitingDeposits);
648         emit ConfirmParties();
649     }
650 
651     /**
652      * @dev Confirm swap.
653      */
654     function confirmSwap() canConfirmSwap onlyManyOwners external {
655         emit ConfirmSwap();
656         _changeStatus(Status.SwapConfirmed);
657         _startLockup();
658     }
659 
660     /**
661      * @dev Cancel swap.
662      */
663     function cancelSwap() canCancelSwap onlyManyOwners external {
664         emit CancelSwap();
665         _changeStatus(Status.SwapCanceled);
666     }
667 
668     /**
669      * @dev Withdraw tokens
670      */
671     function withdraw() onlyParticipant canWithdraw external {
672         for (uint i = 0; i < participants.length; i++) {
673             address token = tokenByParticipant[participants[i]];
674             SwapOffer storage offer = offerByToken[token];
675 
676             if (offer.participant == msg.sender) {
677                 continue;
678             }
679 
680             uint256 tokenReceivers = participants.length - 1;
681             uint256 tokensAmount = _withdrawableAmount(offer).div(tokenReceivers);
682 
683             offer.token.safeTransfer(msg.sender, tokensAmount);
684             emit Withdraw(msg.sender, offer.token, tokensAmount);
685             offer.withdrawnTokensForSwap = offer.withdrawnTokensForSwap.add(tokensAmount);
686             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
687         }
688     }
689 
690     /**
691      * @dev Withdraw swap fee
692      */
693     function withdrawFee() onlyOwner canWithdrawFee external {
694         for (uint i = 0; i < participants.length; i++) {
695             address token = tokenByParticipant[participants[i]];
696             SwapOffer storage offer = offerByToken[token];
697 
698             uint256 tokensAmount = _withdrawableFee(offer);
699 
700             offer.token.safeTransfer(msg.sender, tokensAmount);
701             emit WithdrawFee(offer.token, tokensAmount);
702             offer.withdrawnFee = offer.withdrawnFee.add(tokensAmount);
703             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
704         }
705     }
706 
707     /**
708      * @dev Reclaim tokens if a participant has deposited too much or if the swap has been canceled.
709      */
710     function reclaim() onlyParticipant canReclaim external {
711         address token = tokenByParticipant[msg.sender];
712 
713         SwapOffer storage offer = offerByToken[token];
714         uint256 currentBalance = offer.token.balanceOf(address(this));
715         uint256 availableForReclaim = currentBalance
716             .sub(offer.tokensTotal.sub(offer.withdrawnTokensTotal));
717 
718         if (status == Status.SwapCanceled) {
719             availableForReclaim = currentBalance;
720         }
721 
722         offer.token.safeTransfer(offer.participant, availableForReclaim);
723         emit Reclaim(offer.participant, offer.token, availableForReclaim);
724     }
725 
726     // INTERNAL METHODS
727 
728     /**
729      * @dev Initialize lockup period stages.
730      */
731     function _initializeLockupStages() internal {
732         _addLockupStage(LockupStage(0, 10));
733         _addLockupStage(LockupStage(30 days, 25));
734         _addLockupStage(LockupStage(60 days, 40));
735         _addLockupStage(LockupStage(90 days, 55));
736         _addLockupStage(LockupStage(120 days, 70));
737         _addLockupStage(LockupStage(150 days, 85));
738         _addLockupStage(LockupStage(180 days, 100));
739     }
740 
741     /**
742      * @dev Add lockup period stage
743      */
744     function _addLockupStage(LockupStage _stage) internal {
745         emit AddLockupStage(_stage.secondsSinceLockupStart, _stage.unlockedTokensPercentage);
746         lockupStages.push(_stage);
747     }
748 
749     /**
750      * @dev Validate lock-up period configuration.
751      */
752     function _validateLockupStages() internal view {
753         for (uint i = 0; i < lockupStages.length; i++) {
754             LockupStage memory stage = lockupStages[i];
755 
756             require(
757                 stage.unlockedTokensPercentage >= 0,
758                 "LockupStage.unlockedTokensPercentage must not be negative"
759             );
760             require(
761                 stage.unlockedTokensPercentage <= 100,
762                 "LockupStage.unlockedTokensPercentage must not be greater than 100"
763             );
764 
765             if (i == 0) {
766                 continue;
767             }
768 
769             LockupStage memory previousStage = lockupStages[i - 1];
770             require(
771                 stage.secondsSinceLockupStart > previousStage.secondsSinceLockupStart,
772                 "LockupStage.secondsSinceLockupStart must increase monotonically"
773             );
774             require(
775                 stage.unlockedTokensPercentage > previousStage.unlockedTokensPercentage,
776                 "LockupStage.unlockedTokensPercentage must increase monotonically"
777             );
778         }
779 
780         require(
781             lockupStages[0].secondsSinceLockupStart == 0,
782             "The first lockup stage must start immediately"
783         );
784         require(
785             lockupStages[lockupStages.length - 1].unlockedTokensPercentage == 100,
786             "The last lockup stage must unlock 100% of tokens"
787         );
788     }
789 
790     /**
791      * @dev Change swap status.
792      */
793     function _changeStatus(Status _newStatus) internal {
794         emit StatusUpdate(status, _newStatus);
795         status = _newStatus;
796     }
797 
798     /**
799      * @dev Check whether every participant has deposited enough tokens for the swap to be confirmed.
800      */
801     function _haveEveryoneDeposited() internal view returns(bool) {
802         for (uint i = 0; i < participants.length; i++) {
803             address token = tokenByParticipant[participants[i]];
804             SwapOffer memory offer = offerByToken[token];
805 
806             if (offer.token.balanceOf(address(this)) < offer.tokensTotal) {
807                 return false;
808             }
809         }
810 
811         return true;
812     }
813 
814     /**
815      * @dev Start lockup period
816      */
817     function _startLockup() internal {
818         startLockupAt = now;
819         emit StartLockup(startLockupAt);
820     }
821 
822     /**
823      * @dev Find amount of tokens ready to be withdrawn by a swap party.
824      */
825     function _withdrawableAmount(SwapOffer _offer) internal view returns(uint256) {
826         return _unlockedAmount(_offer.tokensForSwap).sub(_offer.withdrawnTokensForSwap);
827     }
828 
829     /**
830      * @dev Find amount of tokens ready to be withdrawn as the swap fee.
831      */
832     function _withdrawableFee(SwapOffer _offer) internal view returns(uint256) {
833         return _unlockedAmount(_offer.tokensFee).sub(_offer.withdrawnFee);
834     }
835 
836     /**
837      * @dev Find amount of unlocked tokens, including withdrawn tokens.
838      */
839     function _unlockedAmount(uint256 totalAmount) internal view returns(uint256) {
840         return totalAmount.mul(_getUnlockedTokensPercentage()).div(100);
841     }
842 
843     /**
844      * @dev Get percent of unlocked tokens
845      */
846     function _getUnlockedTokensPercentage() internal view returns(uint256) {
847         for (uint256 i = lockupStages.length; i > 0; i--) {
848             LockupStage storage stage = lockupStages[i - 1];
849             uint256 stageBecomesActiveAt = startLockupAt.add(stage.secondsSinceLockupStart);
850 
851             if (now < stageBecomesActiveAt) {
852                 continue;
853             }
854 
855             return stage.unlockedTokensPercentage;
856         }
857     }
858 }