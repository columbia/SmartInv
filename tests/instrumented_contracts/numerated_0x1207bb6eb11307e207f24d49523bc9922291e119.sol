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
479     mapping(address => LockupStage[]) internal lockupStagesByToken;
480 
481     address[] internal participants;
482     mapping(address => bool) internal isParticipant;
483     mapping(address => address) internal tokenByParticipant;
484     mapping(address => SwapOffer) internal offerByToken;
485 
486     // EVENTS
487     event StatusUpdate(Status oldStatus, Status newStatus);
488     event AddParty(
489         address participant,
490         ERC20 token,
491         uint256 tokensForSwap,
492         uint256 tokensFee,
493         uint256 tokensTotal
494     );
495     event AddLockupStage(
496         ERC20 token,
497         uint256 secondsSinceLockupStart,
498         uint8 unlockedTokensPercentage
499     );
500     event ConfirmParties();
501     event CancelSwap();
502     event ConfirmSwap();
503     event StartLockup(uint256 startLockupAt);
504     event Withdraw(address participant, ERC20 token, uint256 amount);
505     event WithdrawFee(ERC20 token, uint256 amount);
506     event Reclaim(address participant, ERC20 token, uint256 amount);
507 
508     // MODIFIERS
509     modifier onlyParticipant {
510         require(
511             isParticipant[msg.sender] == true,
512             "Only swap participants allowed to call the method"
513         );
514         _;
515     }
516 
517     modifier canTransferOwnership {
518         require(status == Status.AddParties, "Unable to transfer ownership in the current status");
519         _;
520     }
521 
522     modifier canAddParty {
523         require(status == Status.AddParties, "Unable to add new parties in the current status");
524         _;
525     }
526 
527     modifier canAddLockupPeriod {
528         require(status == Status.AddParties, "Unable to add lockup period in the current status");
529         _;
530     }
531 
532     modifier canConfirmParties {
533         require(
534             status == Status.AddParties,
535             "Unable to confirm parties in the current status"
536         );
537         require(participants.length > 1, "Need at least two participants");
538         require(_doesEveryTokenHaveLockupPeriod(), "Each token must have lockup period");
539         _;
540     }
541 
542     modifier canCancelSwap {
543         require(
544             status == Status.WaitingDeposits,
545             "Unable to cancel swap in the current status"
546         );
547         _;
548     }
549 
550     modifier canConfirmSwap {
551         require(status == Status.WaitingDeposits, "Unable to confirm in the current status");
552         require(
553             _haveEveryoneDeposited(),
554             "Unable to confirm swap before all parties have deposited tokens"
555         );
556         _;
557     }
558 
559     modifier canWithdraw {
560         require(status == Status.SwapConfirmed, "Unable to withdraw tokens in the current status");
561         require(startLockupAt != 0, "Lockup has not been started");
562         _;
563     }
564 
565     modifier canWithdrawFee {
566         require(status == Status.SwapConfirmed, "Unable to withdraw fee in the current status");
567         require(startLockupAt != 0, "Lockup has not been started");
568         _;
569     }
570 
571     modifier canReclaim {
572         require(
573             status == Status.SwapConfirmed || status == Status.SwapCanceled,
574             "Unable to reclaim in the current status"
575         );
576         _;
577     }
578 
579     // EXTERNAL METHODS
580     /**
581      * @dev Add new party to the swap.
582      * @param _participant Address of the participant.
583      * @param _token An ERC20-compliant token which participant is offering to swap.
584      * @param _tokensForSwap How much tokens the participant wants to swap.
585      * @param _tokensFee How much tokens will be payed as a fee.
586      * @param _tokensTotal How much tokens the participant is offering (i.e. _tokensForSwap + _tokensFee).
587      */
588     function addParty(
589         address _participant,
590         ERC20 _token,
591         uint256 _tokensForSwap,
592         uint256 _tokensFee,
593         uint256 _tokensTotal
594     )
595         external
596         onlyOwner
597         canAddParty
598     {
599         require(_participant != address(0), "_participant is invalid address");
600         require(_token != address(0), "_token is invalid address");
601         require(_tokensForSwap > 0, "_tokensForSwap must be positive");
602         require(_tokensFee > 0, "_tokensFee must be positive");
603         require(_tokensTotal == _tokensForSwap.add(_tokensFee), "token amounts inconsistency");
604         require(
605             isParticipant[_participant] == false,
606             "Unable to add the same party multiple times"
607         );
608 
609         isParticipant[_participant] = true;
610         SwapOffer memory offer = SwapOffer({
611             participant: _participant,
612             token: _token,
613             tokensForSwap: _tokensForSwap,
614             withdrawnTokensForSwap: 0,
615             tokensFee: _tokensFee,
616             withdrawnFee: 0,
617             tokensTotal: _tokensTotal,
618             withdrawnTokensTotal: 0
619         });
620         participants.push(offer.participant);
621         offerByToken[offer.token] = offer;
622         tokenByParticipant[offer.participant] = offer.token;
623 
624         emit AddParty(
625             offer.participant,
626             offer.token,
627             offer.tokensForSwap,
628             offer.tokensFee,
629             offer.tokensTotal
630         );
631     }
632 
633     /**
634      * @dev Add lockup period stages for one of the tokens.
635      * @param _token A token previously added via addParty.
636      * @param _secondsSinceLockupStart Array of starts of the stages of the lockup period.
637      * @param _unlockedTokensPercentages Array of percentages of the unlocked tokens.
638      */
639     function addLockupPeriod(
640         ERC20 _token,
641         uint256[] _secondsSinceLockupStart,
642         uint8[] _unlockedTokensPercentages
643     )
644         external
645         onlyOwner
646         canAddLockupPeriod
647     {
648         require(_token != address(0), "Invalid token");
649         require(
650             _secondsSinceLockupStart.length == _unlockedTokensPercentages.length,
651             "Invalid lockup period"
652         );
653         require(
654             lockupStagesByToken[_token].length == 0,
655             "Lockup period for this token has been added already"
656         );
657         require(
658             offerByToken[_token].token != address(0),
659             "There is no swap offer with this token"
660         );
661 
662         for (uint256 i = 0; i < _secondsSinceLockupStart.length; i++) {
663             _addLockupStage(
664                 _token,
665                 LockupStage(_secondsSinceLockupStart[i], _unlockedTokensPercentages[i])
666             );
667         }
668 
669         _validateLockupStages(_token);
670     }
671 
672     /**
673      * @dev Confirm swap parties
674      */
675     function confirmParties() external onlyOwner canConfirmParties {
676         address[] memory newOwners = new address[](participants.length + 1);
677 
678         for (uint256 i = 0; i < participants.length; i++) {
679             newOwners[i] = participants[i];
680         }
681 
682         newOwners[newOwners.length - 1] = owner;
683         transferOwnershipWithHowMany(newOwners, newOwners.length - 1);
684         _changeStatus(Status.WaitingDeposits);
685         emit ConfirmParties();
686     }
687 
688     /**
689      * @dev Confirm swap.
690      */
691     function confirmSwap() external canConfirmSwap onlyManyOwners {
692         emit ConfirmSwap();
693         _changeStatus(Status.SwapConfirmed);
694         _startLockup();
695     }
696 
697     /**
698      * @dev Cancel swap.
699      */
700     function cancelSwap() external canCancelSwap onlyManyOwners {
701         emit CancelSwap();
702         _changeStatus(Status.SwapCanceled);
703     }
704 
705     /**
706      * @dev Withdraw tokens
707      */
708     function withdraw() external onlyParticipant canWithdraw {
709         for (uint i = 0; i < participants.length; i++) {
710             address token = tokenByParticipant[participants[i]];
711             SwapOffer storage offer = offerByToken[token];
712 
713             if (offer.participant == msg.sender) {
714                 continue;
715             }
716 
717             uint256 tokenReceivers = participants.length - 1;
718             uint256 tokensAmount = _withdrawableAmount(offer).div(tokenReceivers);
719 
720             if (tokensAmount > 0) {
721                 offer.withdrawnTokensForSwap = offer.withdrawnTokensForSwap.add(tokensAmount);
722                 offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
723                 offer.token.safeTransfer(msg.sender, tokensAmount);
724                 emit Withdraw(msg.sender, offer.token, tokensAmount);
725             }
726         }
727     }
728 
729     /**
730      * @dev Withdraw swap fee
731      */
732     function withdrawFee() external onlyOwner canWithdrawFee {
733         for (uint i = 0; i < participants.length; i++) {
734             address token = tokenByParticipant[participants[i]];
735             SwapOffer storage offer = offerByToken[token];
736 
737             uint256 tokensAmount = _withdrawableFee(offer);
738 
739             if (tokensAmount > 0) {
740                 offer.withdrawnFee = offer.withdrawnFee.add(tokensAmount);
741                 offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
742                 offer.token.safeTransfer(msg.sender, tokensAmount);
743                 emit WithdrawFee(offer.token, tokensAmount);
744             }
745         }
746     }
747 
748     /**
749      * @dev Reclaim tokens if a participant has deposited too much or if the swap has been canceled.
750      */
751     function reclaim() external onlyParticipant canReclaim {
752         address token = tokenByParticipant[msg.sender];
753 
754         SwapOffer storage offer = offerByToken[token];
755         uint256 currentBalance = offer.token.balanceOf(address(this));
756         uint256 availableForReclaim = currentBalance;
757 
758         if (status != Status.SwapCanceled) {
759             uint256 lockedTokens = offer.tokensTotal.sub(offer.withdrawnTokensTotal);
760             availableForReclaim = currentBalance.sub(lockedTokens);
761         }
762 
763         if (availableForReclaim > 0) {
764             offer.token.safeTransfer(offer.participant, availableForReclaim);
765         }
766 
767         emit Reclaim(offer.participant, offer.token, availableForReclaim);
768     }
769 
770     // PUBLIC METHODS
771     /**
772      * @dev Standard ERC223 function that will handle incoming token transfers.
773      *
774      * @param _from  Token sender address.
775      * @param _value Amount of tokens.
776      * @param _data  Transaction metadata.
777      */
778     function tokenFallback(address _from, uint256 _value, bytes _data) public {
779 
780     }
781 
782     /**
783      * @dev Transfer ownership.
784      * @param _newOwner Address of the new owner.
785      */
786     function transferOwnership(address _newOwner) public onlyOwner canTransferOwnership {
787         require(_newOwner != address(0), "_newOwner is invalid address");
788         require(owners.length == 1, "Unable to transfer ownership in presence of multiowners");
789         require(owners[0] == owner, "Unexpected multiowners state");
790 
791         address[] memory newOwners = new address[](1);
792         newOwners[0] = _newOwner;
793 
794         Ownable.transferOwnership(_newOwner);
795         Multiownable.transferOwnership(newOwners);
796     }
797 
798     // INTERNAL METHODS
799     /**
800      * @dev Add lockup period stage
801      */
802     function _addLockupStage(ERC20 _token, LockupStage _stage) internal {
803         emit AddLockupStage(
804             _token, _stage.secondsSinceLockupStart, _stage.unlockedTokensPercentage
805         );
806         lockupStagesByToken[_token].push(_stage);
807     }
808 
809     /**
810      * @dev Validate lock-up period configuration.
811      */
812     function _validateLockupStages(ERC20 _token) internal view {
813         LockupStage[] storage lockupStages = lockupStagesByToken[_token];
814 
815         for (uint i = 0; i < lockupStages.length; i++) {
816             LockupStage memory stage = lockupStages[i];
817 
818             require(
819                 stage.unlockedTokensPercentage >= 0,
820                 "LockupStage.unlockedTokensPercentage must not be negative"
821             );
822             require(
823                 stage.unlockedTokensPercentage <= 100,
824                 "LockupStage.unlockedTokensPercentage must not be greater than 100"
825             );
826 
827             if (i == 0) {
828                 continue;
829             }
830 
831             LockupStage memory previousStage = lockupStages[i - 1];
832             require(
833                 stage.secondsSinceLockupStart > previousStage.secondsSinceLockupStart,
834                 "LockupStage.secondsSinceLockupStart must increase monotonically"
835             );
836             require(
837                 stage.unlockedTokensPercentage > previousStage.unlockedTokensPercentage,
838                 "LockupStage.unlockedTokensPercentage must increase monotonically"
839             );
840         }
841 
842         require(
843             lockupStages[lockupStages.length - 1].unlockedTokensPercentage == 100,
844             "The last lockup stage must unlock 100% of tokens"
845         );
846     }
847 
848     /**
849      * @dev Change swap status.
850      */
851     function _changeStatus(Status _newStatus) internal {
852         emit StatusUpdate(status, _newStatus);
853         status = _newStatus;
854     }
855 
856     /**
857      * @dev Check if every token has lockup period.
858      */
859     function _doesEveryTokenHaveLockupPeriod() internal view returns(bool) {
860         for (uint256 i = 0; i < participants.length; i++) {
861             address token = tokenByParticipant[participants[i]];
862 
863             if (lockupStagesByToken[token].length == 0) {
864                 return false;
865             }
866         }
867 
868         return true;
869     }
870 
871     /**
872      * @dev Check whether every participant has deposited enough tokens for the swap to be confirmed.
873      */
874     function _haveEveryoneDeposited() internal view returns(bool) {
875         for (uint i = 0; i < participants.length; i++) {
876             address token = tokenByParticipant[participants[i]];
877             SwapOffer memory offer = offerByToken[token];
878 
879             if (offer.token.balanceOf(address(this)) < offer.tokensTotal) {
880                 return false;
881             }
882         }
883 
884         return true;
885     }
886 
887     /**
888      * @dev Start lockup period
889      */
890     function _startLockup() internal {
891         startLockupAt = now;
892         emit StartLockup(startLockupAt);
893     }
894 
895     /**
896      * @dev Find amount of tokens ready to be withdrawn by a swap party.
897      */
898     function _withdrawableAmount(SwapOffer _offer) internal view returns(uint256) {
899         return _unlockedAmount(
900             _offer.token,
901             _offer.tokensForSwap
902         ).sub(
903             _offer.withdrawnTokensForSwap
904         );
905     }
906 
907     /**
908      * @dev Find amount of tokens ready to be withdrawn as the swap fee.
909      */
910     function _withdrawableFee(SwapOffer _offer) internal view returns(uint256) {
911         return _unlockedAmount(
912             _offer.token,
913             _offer.tokensFee
914         ).sub(
915             _offer.withdrawnFee
916         );
917     }
918 
919     /**
920      * @dev Find amount of unlocked tokens, including withdrawn tokens.
921      */
922     function _unlockedAmount(ERC20 _token, uint256 _totalAmount) internal view returns(uint256) {
923         return _totalAmount.mul(_getUnlockedTokensPercentage(_token)).div(100);
924     }
925 
926     /**
927      * @dev Get percent of unlocked tokens
928      */
929     function _getUnlockedTokensPercentage(ERC20 _token) internal view returns(uint256) {
930         for (uint256 i = lockupStagesByToken[_token].length; i > 0; i--) {
931             LockupStage storage stage = lockupStagesByToken[_token][i - 1];
932             uint256 stageBecomesActiveAt = startLockupAt.add(stage.secondsSinceLockupStart);
933 
934             if (now < stageBecomesActiveAt) {
935                 continue;
936             }
937 
938             return stage.unlockedTokensPercentage;
939         }
940     }
941 }