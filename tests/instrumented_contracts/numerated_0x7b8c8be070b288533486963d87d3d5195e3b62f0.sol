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
460         uint256 tokensTotal;
461         uint256 withdrawnTokensTotal;
462     }
463 
464     struct LockupStage {
465         uint256 secondsSinceLockupStart;
466         uint8 unlockedTokensPercentage;
467     }
468 
469     // VARIABLES
470     Status public status = Status.AddParties;
471 
472     address[] internal participants;
473     mapping(address => bool) internal isParticipant;
474     mapping(address => address) internal tokenByParticipant;
475     mapping(address => SwapOffer) internal offerByToken;
476 
477     uint256 internal startLockupAt;
478     mapping(address => LockupStage[]) internal lockupStagesByToken;
479 
480     address[] internal receivers;
481     mapping(address => bool) internal isReceiver;
482     mapping(address => bool) internal isTokenAllocated;
483     mapping(address => mapping(address => uint256)) internal allocatedTokens;
484     mapping(address => mapping(address => uint256)) internal withdrawnTokens;
485 
486     // EVENTS
487     event StatusUpdate(Status oldStatus, Status newStatus);
488     event AddParty(address participant, ERC20 token, uint256 tokensTotal);
489     event AddTokenAllocation(ERC20 token, address receiver, uint256 amount);
490     event AddLockupStage(
491         ERC20 token,
492         uint256 secondsSinceLockupStart,
493         uint8 unlockedTokensPercentage
494     );
495     event ConfirmParties();
496     event CancelSwap();
497     event ConfirmSwap();
498     event StartLockup(uint256 startLockupAt);
499     event Withdraw(address participant, ERC20 token, uint256 amount);
500     event WithdrawFee(ERC20 token, uint256 amount);
501     event Reclaim(address participant, ERC20 token, uint256 amount);
502     event SoftEmergency(ERC20 token, address receiver, uint256 amount);
503     event HardEmergency(ERC20 token, address receiver, uint256 amount);
504 
505     // MODIFIERS
506     modifier onlyParticipant {
507         require(
508             isParticipant[msg.sender] == true,
509             "Only swap participants allowed to call the method"
510         );
511         _;
512     }
513 
514     modifier onlyReceiver {
515         require(
516             isReceiver[msg.sender] == true,
517             "Only token receivers allowed to call the method"
518         );
519        _;
520     }
521 
522     modifier canTransferOwnership {
523         require(status == Status.AddParties, "Unable to transfer ownership in the current status");
524         _;
525     }
526 
527     modifier canAddParty {
528         require(status == Status.AddParties, "Unable to add new parties in the current status");
529         _;
530     }
531 
532     modifier canAddLockupPeriod {
533         require(status == Status.AddParties, "Unable to add lockup period in the current status");
534         _;
535     }
536 
537     modifier canAddTokenAllocation {
538         require(
539             status == Status.AddParties,
540             "Unable to add token allocation in the current status"
541         );
542         _;
543     }
544 
545     modifier canConfirmParties {
546         require(
547             status == Status.AddParties,
548             "Unable to confirm parties in the current status"
549         );
550         require(participants.length > 1, "Need at least two participants");
551         require(_doesEveryTokenHaveLockupPeriod(), "Each token must have lockup period");
552         require(_isEveryTokenFullyAllocated(), "Each token must be fully allocated");
553         _;
554     }
555 
556     modifier canCancelSwap {
557         require(
558             status == Status.WaitingDeposits,
559             "Unable to cancel swap in the current status"
560         );
561         _;
562     }
563 
564     modifier canConfirmSwap {
565         require(status == Status.WaitingDeposits, "Unable to confirm in the current status");
566         require(
567             _haveEveryoneDeposited(),
568             "Unable to confirm swap before all parties have deposited tokens"
569         );
570         _;
571     }
572 
573     modifier canWithdraw {
574         require(status == Status.SwapConfirmed, "Unable to withdraw tokens in the current status");
575         require(startLockupAt != 0, "Lockup has not been started");
576         _;
577     }
578 
579     modifier canReclaim {
580         require(
581             status == Status.SwapConfirmed || status == Status.SwapCanceled,
582             "Unable to reclaim in the current status"
583         );
584         _;
585     }
586 
587     // EXTERNAL METHODS
588     /**
589      * @dev Add new party to the swap.
590      * @param _participant Address of the participant.
591      * @param _token An ERC20-compliant token which participant is offering to swap.
592      * @param _tokensTotal How much tokens the participant is offering.
593      */
594     function addParty(
595         address _participant,
596         ERC20 _token,
597         uint256 _tokensTotal
598     )
599         external
600         onlyOwner
601         canAddParty
602     {
603         require(_participant != address(0), "_participant is invalid address");
604         require(_token != address(0), "_token is invalid address");
605         require(_tokensTotal > 0, "Positive amount of tokens is required");
606         require(
607             isParticipant[_participant] == false,
608             "Unable to add the same party multiple times"
609         );
610 
611         isParticipant[_participant] = true;
612         SwapOffer memory offer = SwapOffer({
613             participant: _participant,
614             token: _token,
615             tokensTotal: _tokensTotal,
616             withdrawnTokensTotal: 0
617         });
618         participants.push(offer.participant);
619         offerByToken[offer.token] = offer;
620         tokenByParticipant[offer.participant] = offer.token;
621 
622         emit AddParty(offer.participant, offer.token, offer.tokensTotal);
623     }
624 
625     /**
626      * @dev Add lockup period stages for one of the tokens.
627      * @param _token A token previously added via addParty.
628      * @param _secondsSinceLockupStart Array of starts of the stages of the lockup period.
629      * @param _unlockedTokensPercentages Array of percentages of the unlocked tokens.
630      */
631     function addLockupPeriod(
632         ERC20 _token,
633         uint256[] _secondsSinceLockupStart,
634         uint8[] _unlockedTokensPercentages
635     )
636         external
637         onlyOwner
638         canAddLockupPeriod
639     {
640         require(_token != address(0), "Invalid token");
641         require(
642             _secondsSinceLockupStart.length == _unlockedTokensPercentages.length,
643             "Invalid lockup period"
644         );
645         require(
646             lockupStagesByToken[_token].length == 0,
647             "Lockup period for this token has been added already"
648         );
649         require(
650             offerByToken[_token].token != address(0),
651             "There is no swap offer with this token"
652         );
653 
654         for (uint256 i = 0; i < _secondsSinceLockupStart.length; i++) {
655             LockupStage memory stage = LockupStage(
656                 _secondsSinceLockupStart[i], _unlockedTokensPercentages[i]
657             );
658             lockupStagesByToken[_token].push(stage);
659 
660             emit AddLockupStage(
661                 _token, stage.secondsSinceLockupStart, stage.unlockedTokensPercentage
662             );
663         }
664 
665         _validateLockupStages(_token);
666     }
667 
668     /**
669      * @dev Add token allocation.
670      * @param _token A token previously added via addParty.
671      * @param _receivers Who receives tokens.
672      * @param _amounts How much tokens will each receiver get.
673      */
674     function addTokenAllocation(
675         ERC20 _token,
676         address[] _receivers,
677         uint256[] _amounts
678     )
679         external
680         onlyOwner
681         canAddTokenAllocation
682     {
683         require(_token != address(0), "Invalid token");
684         require(_receivers.length == _amounts.length, "Invalid arguments' lengths");
685         require(offerByToken[_token].token != address(0), "There is no swap offer with this token");
686         require(!isTokenAllocated[_token], "Token has been allocated already");
687 
688         uint256 totalAllocation = 0;
689         uint256 i;
690 
691         for (i = 0; i < _receivers.length; i++) {
692             require(_receivers[i] != address(0), "Invalid receiver");
693             require(_amounts[i] > 0, "Positive amount is required");
694             require(
695                 allocatedTokens[_token][_receivers[i]] == 0,
696                 "Tokens for this receiver have been allocated already"
697             );
698 
699             if (!isReceiver[_receivers[i]]) {
700                 receivers.push(_receivers[i]);
701                 isReceiver[_receivers[i]] = true;
702             }
703 
704             allocatedTokens[_token][_receivers[i]] = _amounts[i];
705             totalAllocation = totalAllocation.add(_amounts[i]);
706 
707             emit AddTokenAllocation(_token, _receivers[i], _amounts[i]);
708         }
709 
710         require(totalAllocation == offerByToken[_token].tokensTotal, "Invalid allocation");
711         require(isReceiver[owner], "Swap fee hasn't been allocated");
712 
713         for (i = 0; i < participants.length; i++) {
714             if (tokenByParticipant[participants[i]] == address(_token)) {
715                 continue;
716             }
717             require(isReceiver[participants[i]], "Tokens for a participant haven't been allocated");
718         }
719 
720         isTokenAllocated[_token] = true;
721     }
722 
723     /**
724      * @dev Confirm swap parties
725      */
726     function confirmParties() external onlyOwner canConfirmParties {
727         address[] memory newOwners = new address[](participants.length + 1);
728 
729         for (uint256 i = 0; i < participants.length; i++) {
730             newOwners[i] = participants[i];
731         }
732 
733         newOwners[newOwners.length - 1] = owner;
734         transferOwnershipWithHowMany(newOwners, newOwners.length - 1);
735         _changeStatus(Status.WaitingDeposits);
736         emit ConfirmParties();
737     }
738 
739     /**
740      * @dev Confirm swap.
741      */
742     function confirmSwap() external canConfirmSwap onlyManyOwners {
743         emit ConfirmSwap();
744         _changeStatus(Status.SwapConfirmed);
745         _startLockup();
746     }
747 
748     /**
749      * @dev Cancel swap.
750      */
751     function cancelSwap() external canCancelSwap onlyManyOwners {
752         emit CancelSwap();
753         _changeStatus(Status.SwapCanceled);
754     }
755 
756     /**
757      * @dev Withdraw tokens
758      */
759     function withdraw() external onlyReceiver canWithdraw {
760         for (uint i = 0; i < participants.length; i++) {
761             address token = tokenByParticipant[participants[i]];
762             SwapOffer storage offer = offerByToken[token];
763 
764             if (offer.participant == msg.sender) {
765                 continue;
766             }
767 
768             uint256 tokensAmount = _withdrawableAmount(offer.token, msg.sender);
769 
770             if (tokensAmount > 0) {
771                 withdrawnTokens[offer.token][msg.sender] =
772                     withdrawnTokens[offer.token][msg.sender].add(tokensAmount);
773                 offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
774                 offer.token.safeTransfer(msg.sender, tokensAmount);
775                 emit Withdraw(msg.sender, offer.token, tokensAmount);
776             }
777         }
778     }
779 
780     /**
781      * @dev Reclaim tokens if a participant has deposited too much or if the swap has been canceled.
782      */
783     function reclaim() external onlyParticipant canReclaim {
784         address token = tokenByParticipant[msg.sender];
785 
786         SwapOffer storage offer = offerByToken[token];
787         uint256 currentBalance = offer.token.balanceOf(address(this));
788         uint256 availableForReclaim = currentBalance;
789 
790         if (status != Status.SwapCanceled) {
791             uint256 lockedTokens = offer.tokensTotal.sub(offer.withdrawnTokensTotal);
792             availableForReclaim = currentBalance.sub(lockedTokens);
793         }
794 
795         if (availableForReclaim > 0) {
796             offer.token.safeTransfer(offer.participant, availableForReclaim);
797         }
798 
799         emit Reclaim(offer.participant, offer.token, availableForReclaim);
800     }
801 
802     /**
803      * @dev Transfer tokens back to owners.
804      */
805     function softEmergency() external onlyOwner {
806         for (uint i = 0; i < participants.length; i++) {
807             address token = tokenByParticipant[participants[i]];
808             SwapOffer storage offer = offerByToken[token];
809             uint256 tokensAmount = offer.token.balanceOf(address(this));
810 
811             require(offer.withdrawnTokensTotal == 0, "Unavailable after the first withdrawal.");
812 
813             if (tokensAmount > 0) {
814                 offer.token.safeTransfer(offer.participant, tokensAmount);
815                 emit SoftEmergency(offer.token, offer.participant, tokensAmount);
816             }
817         }
818     }
819 
820     /**
821      * @dev A way out if nothing else is working.
822      */
823     function hardEmergency(
824         ERC20[] _tokens,
825         address[] _receivers,
826         uint256[] _values
827     )
828         external
829         onlyAllOwners
830     {
831         require(_tokens.length == _receivers.length, "Invalid lengths.");
832         require(_receivers.length == _values.length, "Invalid lengths.");
833 
834         for (uint256 i = 0; i < _tokens.length; i++) {
835             _tokens[i].safeTransfer(_receivers[i], _values[i]);
836             emit HardEmergency(_tokens[i], _receivers[i], _values[i]);
837         }
838     }
839 
840     // PUBLIC METHODS
841     /**
842      * @dev Standard ERC223 function that will handle incoming token transfers.
843      *
844      * @param _from  Token sender address.
845      * @param _value Amount of tokens.
846      * @param _data  Transaction metadata.
847      */
848     function tokenFallback(address _from, uint256 _value, bytes _data) public {
849 
850     }
851 
852     /**
853      * @dev Transfer ownership.
854      * @param _newOwner Address of the new owner.
855      */
856     function transferOwnership(address _newOwner) public onlyOwner canTransferOwnership {
857         require(_newOwner != address(0), "_newOwner is invalid address");
858         require(owners.length == 1, "Unable to transfer ownership in presence of multiowners");
859         require(owners[0] == owner, "Unexpected multiowners state");
860 
861         address[] memory newOwners = new address[](1);
862         newOwners[0] = _newOwner;
863 
864         Ownable.transferOwnership(_newOwner);
865         Multiownable.transferOwnership(newOwners);
866     }
867 
868     // INTERNAL METHODS
869     /**
870      * @dev Validate lock-up period configuration.
871      */
872     function _validateLockupStages(ERC20 _token) internal view {
873         LockupStage[] storage lockupStages = lockupStagesByToken[_token];
874 
875         for (uint i = 0; i < lockupStages.length; i++) {
876             LockupStage memory stage = lockupStages[i];
877 
878             require(
879                 stage.unlockedTokensPercentage >= 0,
880                 "LockupStage.unlockedTokensPercentage must not be negative"
881             );
882             require(
883                 stage.unlockedTokensPercentage <= 100,
884                 "LockupStage.unlockedTokensPercentage must not be greater than 100"
885             );
886 
887             if (i == 0) {
888                 continue;
889             }
890 
891             LockupStage memory previousStage = lockupStages[i - 1];
892             require(
893                 stage.secondsSinceLockupStart > previousStage.secondsSinceLockupStart,
894                 "LockupStage.secondsSinceLockupStart must increase monotonically"
895             );
896             require(
897                 stage.unlockedTokensPercentage > previousStage.unlockedTokensPercentage,
898                 "LockupStage.unlockedTokensPercentage must increase monotonically"
899             );
900         }
901 
902         require(
903             lockupStages[lockupStages.length - 1].unlockedTokensPercentage == 100,
904             "The last lockup stage must unlock 100% of tokens"
905         );
906     }
907 
908     /**
909      * @dev Change swap status.
910      */
911     function _changeStatus(Status _newStatus) internal {
912         emit StatusUpdate(status, _newStatus);
913         status = _newStatus;
914     }
915 
916     /**
917      * @dev Check if every token has lockup period.
918      */
919     function _doesEveryTokenHaveLockupPeriod() internal view returns(bool) {
920         for (uint256 i = 0; i < participants.length; i++) {
921             address token = tokenByParticipant[participants[i]];
922 
923             if (lockupStagesByToken[token].length == 0) {
924                 return false;
925             }
926         }
927 
928         return true;
929     }
930 
931     /**
932      * @dev Check if every token has been fully allocated.
933      */
934     function _isEveryTokenFullyAllocated() internal view returns(bool) {
935         for (uint256 i = 0; i < participants.length; i++) {
936             if (!isTokenAllocated[tokenByParticipant[participants[i]]]) {
937                 return false;
938             }
939         }
940         return true;
941     }
942 
943     /**
944      * @dev Check whether every participant has deposited enough tokens for the swap to be confirmed.
945      */
946     function _haveEveryoneDeposited() internal view returns(bool) {
947         for (uint i = 0; i < participants.length; i++) {
948             address token = tokenByParticipant[participants[i]];
949             SwapOffer memory offer = offerByToken[token];
950 
951             if (offer.token.balanceOf(address(this)) < offer.tokensTotal) {
952                 return false;
953             }
954         }
955 
956         return true;
957     }
958 
959     /**
960      * @dev Start lockup period
961      */
962     function _startLockup() internal {
963         startLockupAt = now;
964         emit StartLockup(startLockupAt);
965     }
966 
967     /**
968      * @dev Find amount of tokens ready to be withdrawn.
969      */
970     function _withdrawableAmount(
971         ERC20 _token,
972         address _receiver
973     )
974         internal
975         view
976         returns(uint256)
977     {
978         uint256 allocated = allocatedTokens[_token][_receiver];
979         uint256 withdrawn = withdrawnTokens[_token][_receiver];
980         uint256 unlockedPercentage = _getUnlockedTokensPercentage(_token);
981         uint256 unlockedAmount = allocated.mul(unlockedPercentage).div(100);
982 
983         return unlockedAmount.sub(withdrawn);
984     }
985 
986     /**
987      * @dev Get percent of unlocked tokens
988      */
989     function _getUnlockedTokensPercentage(ERC20 _token) internal view returns(uint256) {
990         for (uint256 i = lockupStagesByToken[_token].length; i > 0; i--) {
991             LockupStage storage stage = lockupStagesByToken[_token][i - 1];
992             uint256 stageBecomesActiveAt = startLockupAt.add(stage.secondsSinceLockupStart);
993 
994             if (now < stageBecomesActiveAt) {
995                 continue;
996             }
997 
998             return stage.unlockedTokensPercentage;
999         }
1000     }
1001 }