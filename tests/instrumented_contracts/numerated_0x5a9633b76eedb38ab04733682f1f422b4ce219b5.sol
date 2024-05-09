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
390 // File: contracts/BadERC20Aware.sol
391 
392 library BadERC20Aware {
393     using SafeMath for uint;
394 
395     function isContract(address addr) internal view returns(bool result) {
396         // solium-disable-next-line security/no-inline-assembly
397         assembly {
398             result := gt(extcodesize(addr), 0)
399         }
400     }
401 
402     function handleReturnBool() internal pure returns(bool result) {
403         // solium-disable-next-line security/no-inline-assembly
404         assembly {
405             switch returndatasize()
406             case 0 { // not a std erc20
407                 result := 1
408             }
409             case 32 { // std erc20
410                 returndatacopy(0, 0, 32)
411                 result := mload(0)
412             }
413             default { // anything else, should revert for safety
414                 revert(0, 0)
415             }
416         }
417     }
418 
419     function asmTransfer(ERC20 _token, address _to, uint256 _value) internal returns(bool) {
420         require(isContract(_token));
421         // solium-disable-next-line security/no-low-level-calls
422         require(address(_token).call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
423         return handleReturnBool();
424     }
425 
426     function safeTransfer(ERC20 _token, address _to, uint256 _value) internal {
427         require(asmTransfer(_token, _to, _value));
428     }
429 }
430 
431 // File: contracts/TokenSwap.sol
432 
433 /**
434  * @title TokenSwap
435  * This product is protected under license.  Any unauthorized copy, modification, or use without
436  * express written consent from the creators is prohibited.
437  */
438 
439 
440 
441 
442 
443 
444 
445 contract TokenSwap is Ownable, Multiownable {
446 
447     // LIBRARIES
448 
449     using BadERC20Aware for ERC20;
450     using SafeMath for uint256;
451 
452     // TYPES
453 
454     enum Status {AddParties, WaitingDeposits, SwapConfirmed, SwapCanceled}
455 
456     struct SwapOffer {
457         address participant;
458         ERC20 token;
459 
460         uint256 tokensForSwap;
461         uint256 withdrawnTokensForSwap;
462 
463         uint256 tokensFee;
464         uint256 withdrawnFee;
465 
466         uint256 tokensTotal;
467         uint256 withdrawnTokensTotal;
468     }
469 
470     struct LockupStage {
471         uint256 secondsSinceLockupStart;
472         uint8 unlockedTokensPercentage;
473     }
474 
475     // VARIABLES
476     Status public status = Status.AddParties;
477 
478     uint256 internal startLockupAt;
479     LockupStage[] internal lockupStages;
480 
481     address[] internal participants;
482     mapping(address => bool) internal isParticipant;
483     mapping(address => address) internal tokenByParticipant;
484     mapping(address => SwapOffer) internal offerByToken;
485 
486     // EVENTS
487     event AddLockupStage(uint256 secondsSinceLockupStart, uint8 unlockedTokensPercentage);
488     event StatusUpdate(Status oldStatus, Status newStatus);
489     event AddParty(address participant, ERC20 token, uint256 amount);
490     event RemoveParty(address participant);
491     event ConfirmParties();
492     event CancelSwap();
493     event ConfirmSwap();
494     event StartLockup(uint256 startLockupAt);
495     event Withdraw(address participant, ERC20 token, uint256 amount);
496     event WithdrawFee(ERC20 token, uint256 amount);
497     event Reclaim(address participant, ERC20 token, uint256 amount);
498 
499     // MODIFIERS
500     modifier onlyParticipant {
501         require(
502             isParticipant[msg.sender] == true,
503             "Only swap participants allowed to call the method"
504         );
505         _;
506     }
507 
508     modifier canAddParty {
509         require(status == Status.AddParties, "Unable to add new parties in the current status");
510         _;
511     }
512 
513     modifier canRemoveParty {
514         require(status == Status.AddParties, "Unable to remove parties in the current status");
515         _;
516     }
517 
518     modifier canConfirmParties {
519         require(
520             status == Status.AddParties,
521             "Unable to confirm parties in the current status"
522         );
523         require(participants.length > 1, "Need at least two participants");
524         _;
525     }
526 
527     modifier canCancelSwap {
528         require(
529             status == Status.WaitingDeposits,
530             "Unable to cancel swap in the current status"
531         );
532         _;
533     }
534 
535     modifier canConfirmSwap {
536         require(status == Status.WaitingDeposits, "Unable to confirm in the current status");
537         require(
538             _haveEveryoneDeposited(),
539             "Unable to confirm swap before all parties have deposited tokens"
540         );
541         _;
542     }
543 
544     modifier canWithdraw {
545         require(status == Status.SwapConfirmed, "Unable to withdraw tokens in the current status");
546         require(startLockupAt != 0, "Lockup has not been started");
547         _;
548     }
549 
550     modifier canWithdrawFee {
551         require(status == Status.SwapConfirmed, "Unable to withdraw fee in the current status");
552         require(startLockupAt != 0, "Lockup has not been started");
553         _;
554     }
555 
556     modifier canReclaim {
557         require(
558             status == Status.SwapConfirmed || status == Status.SwapCanceled,
559             "Unable to reclaim in the current status"
560         );
561         _;
562     }
563 
564     // CONSTRUCTOR
565     constructor() public {
566         _initializeLockupStages();
567         _validateLockupStages();
568     }
569 
570     // EXTERNAL METHODS
571     /**
572      * @dev Add new party to the swap.
573      * @param _participant Address of the participant.
574      * @param _token An ERC20-compliant token which participant is offering to swap.
575      * @param _tokensForSwap How much tokens the participant wants to swap.
576      * @param _tokensFee How much tokens will be payed as a fee.
577      * @param _tokensTotal How much tokens the participant is offering (i.e. _tokensForSwap + _tokensFee).
578      */
579     function addParty(
580         address _participant,
581         ERC20 _token,
582         uint256 _tokensForSwap,
583         uint256 _tokensFee,
584         uint256 _tokensTotal
585     )
586         external
587         onlyOwner
588         canAddParty
589     {
590         require(_participant != address(0), "_participant is invalid address");
591         require(_token != address(0), "_token is invalid address");
592         require(_tokensForSwap > 0, "_tokensForSwap must be positive");
593         require(_tokensFee > 0, "_tokensFee must be positive");
594         require(_tokensTotal == _tokensForSwap.add(_tokensFee), "token amounts inconsistency");
595         require(
596             isParticipant[_participant] == false,
597             "Unable to add the same party multiple times"
598         );
599 
600         isParticipant[_participant] = true;
601         SwapOffer memory offer = SwapOffer({
602             participant: _participant,
603             token: _token,
604             tokensForSwap: _tokensForSwap,
605             withdrawnTokensForSwap: 0,
606             tokensFee: _tokensFee,
607             withdrawnFee: 0,
608             tokensTotal: _tokensTotal,
609             withdrawnTokensTotal: 0
610         });
611         participants.push(offer.participant);
612         offerByToken[offer.token] = offer;
613         tokenByParticipant[offer.participant] = offer.token;
614 
615         emit AddParty(offer.participant, offer.token, offer.tokensTotal);
616     }
617 
618     /**
619      * @dev Remove party.
620      * @param _participantIndex Index of the participant in the participants array.
621      */
622     function removeParty(uint256 _participantIndex) external onlyOwner canRemoveParty {
623         require(_participantIndex < participants.length, "Participant does not exist");
624 
625         address participant = participants[_participantIndex];
626         address token = tokenByParticipant[participant];
627 
628         delete isParticipant[participant];
629         participants[_participantIndex] = participants[participants.length - 1];
630         participants.length--;
631         delete offerByToken[token];
632         delete tokenByParticipant[participant];
633 
634         emit RemoveParty(participant);
635     }
636 
637     /**
638      * @dev Confirm swap parties
639      */
640     function confirmParties() external onlyOwner canConfirmParties {
641         address[] memory newOwners = new address[](participants.length + 1);
642 
643         for (uint256 i = 0; i < participants.length; i++) {
644             newOwners[i] = participants[i];
645         }
646 
647         newOwners[newOwners.length - 1] = owner;
648         transferOwnershipWithHowMany(newOwners, newOwners.length - 1);
649         _changeStatus(Status.WaitingDeposits);
650         emit ConfirmParties();
651     }
652 
653     /**
654      * @dev Confirm swap.
655      */
656     function confirmSwap() external canConfirmSwap onlyManyOwners {
657         emit ConfirmSwap();
658         _changeStatus(Status.SwapConfirmed);
659         _startLockup();
660     }
661 
662     /**
663      * @dev Cancel swap.
664      */
665     function cancelSwap() external canCancelSwap onlyManyOwners {
666         emit CancelSwap();
667         _changeStatus(Status.SwapCanceled);
668     }
669 
670     /**
671      * @dev Withdraw tokens
672      */
673     function withdraw() external onlyParticipant canWithdraw {
674         for (uint i = 0; i < participants.length; i++) {
675             address token = tokenByParticipant[participants[i]];
676             SwapOffer storage offer = offerByToken[token];
677 
678             if (offer.participant == msg.sender) {
679                 continue;
680             }
681 
682             uint256 tokenReceivers = participants.length - 1;
683             uint256 tokensAmount = _withdrawableAmount(offer).div(tokenReceivers);
684 
685             offer.token.safeTransfer(msg.sender, tokensAmount);
686             emit Withdraw(msg.sender, offer.token, tokensAmount);
687             offer.withdrawnTokensForSwap = offer.withdrawnTokensForSwap.add(tokensAmount);
688             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
689         }
690     }
691 
692     /**
693      * @dev Withdraw swap fee
694      */
695     function withdrawFee() external onlyOwner canWithdrawFee {
696         for (uint i = 0; i < participants.length; i++) {
697             address token = tokenByParticipant[participants[i]];
698             SwapOffer storage offer = offerByToken[token];
699 
700             uint256 tokensAmount = _withdrawableFee(offer);
701 
702             offer.token.safeTransfer(msg.sender, tokensAmount);
703             emit WithdrawFee(offer.token, tokensAmount);
704             offer.withdrawnFee = offer.withdrawnFee.add(tokensAmount);
705             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
706         }
707     }
708 
709     /**
710      * @dev Reclaim tokens if a participant has deposited too much or if the swap has been canceled.
711      */
712     function reclaim() external onlyParticipant canReclaim {
713         address token = tokenByParticipant[msg.sender];
714 
715         SwapOffer storage offer = offerByToken[token];
716         uint256 currentBalance = offer.token.balanceOf(address(this));
717         uint256 availableForReclaim = currentBalance
718             .sub(offer.tokensTotal.sub(offer.withdrawnTokensTotal));
719 
720         if (status == Status.SwapCanceled) {
721             availableForReclaim = currentBalance;
722         }
723 
724         if (availableForReclaim > 0) {
725             offer.token.safeTransfer(offer.participant, availableForReclaim);
726         }
727 
728         emit Reclaim(offer.participant, offer.token, availableForReclaim);
729     }
730 
731     // PUBLIC METHODS
732     /**
733      * @dev Standard ERC223 function that will handle incoming token transfers.
734      *
735      * @param _from  Token sender address.
736      * @param _value Amount of tokens.
737      * @param _data  Transaction metadata.
738      */
739     function tokenFallback(address _from, uint256 _value, bytes _data) public {
740 
741     }
742 
743     // INTERNAL METHODS
744     /**
745      * @dev Initialize lockup period stages.
746      */
747     function _initializeLockupStages() internal {
748         _addLockupStage(LockupStage(0, 10));
749         _addLockupStage(LockupStage(60 days, 25));
750         _addLockupStage(LockupStage(120 days, 40));
751         _addLockupStage(LockupStage(180 days, 60));
752         _addLockupStage(LockupStage(240 days, 80));
753         _addLockupStage(LockupStage(300 days, 100));
754     }
755 
756     /**
757      * @dev Add lockup period stage
758      */
759     function _addLockupStage(LockupStage _stage) internal {
760         emit AddLockupStage(_stage.secondsSinceLockupStart, _stage.unlockedTokensPercentage);
761         lockupStages.push(_stage);
762     }
763 
764     /**
765      * @dev Validate lock-up period configuration.
766      */
767     function _validateLockupStages() internal view {
768         for (uint i = 0; i < lockupStages.length; i++) {
769             LockupStage memory stage = lockupStages[i];
770 
771             require(
772                 stage.unlockedTokensPercentage >= 0,
773                 "LockupStage.unlockedTokensPercentage must not be negative"
774             );
775             require(
776                 stage.unlockedTokensPercentage <= 100,
777                 "LockupStage.unlockedTokensPercentage must not be greater than 100"
778             );
779 
780             if (i == 0) {
781                 continue;
782             }
783 
784             LockupStage memory previousStage = lockupStages[i - 1];
785             require(
786                 stage.secondsSinceLockupStart > previousStage.secondsSinceLockupStart,
787                 "LockupStage.secondsSinceLockupStart must increase monotonically"
788             );
789             require(
790                 stage.unlockedTokensPercentage > previousStage.unlockedTokensPercentage,
791                 "LockupStage.unlockedTokensPercentage must increase monotonically"
792             );
793         }
794 
795         require(
796             lockupStages[0].secondsSinceLockupStart == 0,
797             "The first lockup stage must start immediately"
798         );
799         require(
800             lockupStages[lockupStages.length - 1].unlockedTokensPercentage == 100,
801             "The last lockup stage must unlock 100% of tokens"
802         );
803     }
804 
805     /**
806      * @dev Change swap status.
807      */
808     function _changeStatus(Status _newStatus) internal {
809         emit StatusUpdate(status, _newStatus);
810         status = _newStatus;
811     }
812 
813     /**
814      * @dev Check whether every participant has deposited enough tokens for the swap to be confirmed.
815      */
816     function _haveEveryoneDeposited() internal view returns(bool) {
817         for (uint i = 0; i < participants.length; i++) {
818             address token = tokenByParticipant[participants[i]];
819             SwapOffer memory offer = offerByToken[token];
820 
821             if (offer.token.balanceOf(address(this)) < offer.tokensTotal) {
822                 return false;
823             }
824         }
825 
826         return true;
827     }
828 
829     /**
830      * @dev Start lockup period
831      */
832     function _startLockup() internal {
833         startLockupAt = now;
834         emit StartLockup(startLockupAt);
835     }
836 
837     /**
838      * @dev Find amount of tokens ready to be withdrawn by a swap party.
839      */
840     function _withdrawableAmount(SwapOffer _offer) internal view returns(uint256) {
841         return _unlockedAmount(_offer.tokensForSwap).sub(_offer.withdrawnTokensForSwap);
842     }
843 
844     /**
845      * @dev Find amount of tokens ready to be withdrawn as the swap fee.
846      */
847     function _withdrawableFee(SwapOffer _offer) internal view returns(uint256) {
848         return _unlockedAmount(_offer.tokensFee).sub(_offer.withdrawnFee);
849     }
850 
851     /**
852      * @dev Find amount of unlocked tokens, including withdrawn tokens.
853      */
854     function _unlockedAmount(uint256 totalAmount) internal view returns(uint256) {
855         return totalAmount.mul(_getUnlockedTokensPercentage()).div(100);
856     }
857 
858     /**
859      * @dev Get percent of unlocked tokens
860      */
861     function _getUnlockedTokensPercentage() internal view returns(uint256) {
862         for (uint256 i = lockupStages.length; i > 0; i--) {
863             LockupStage storage stage = lockupStages[i - 1];
864             uint256 stageBecomesActiveAt = startLockupAt.add(stage.secondsSinceLockupStart);
865 
866             if (now < stageBecomesActiveAt) {
867                 continue;
868             }
869 
870             return stage.unlockedTokensPercentage;
871         }
872     }
873 }