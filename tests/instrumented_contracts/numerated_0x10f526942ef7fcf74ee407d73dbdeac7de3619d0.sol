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
253   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
254     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
255     // benefit is lost if 'b' is also tested.
256     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
257     if (_a == 0) {
258       return 0;
259     }
260 
261     c = _a * _b;
262     assert(c / _a == _b);
263     return c;
264   }
265 
266   /**
267   * @dev Integer division of two numbers, truncating the quotient.
268   */
269   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
270     // assert(_b > 0); // Solidity automatically throws when dividing by 0
271     // uint256 c = _a / _b;
272     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
273     return _a / _b;
274   }
275 
276   /**
277   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
278   */
279   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
280     assert(_b <= _a);
281     return _a - _b;
282   }
283 
284   /**
285   * @dev Adds two numbers, throws on overflow.
286   */
287   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
288     c = _a + _b;
289     assert(c >= _a);
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
330    * @notice Renouncing to ownership will leave the contract without an owner.
331    * It will not be possible to call the functions with the `onlyOwner`
332    * modifier anymore.
333    */
334   function renounceOwnership() public onlyOwner {
335     emit OwnershipRenounced(owner);
336     owner = address(0);
337   }
338 
339   /**
340    * @dev Allows the current owner to transfer control of the contract to a newOwner.
341    * @param _newOwner The address to transfer ownership to.
342    */
343   function transferOwnership(address _newOwner) public onlyOwner {
344     _transferOwnership(_newOwner);
345   }
346 
347   /**
348    * @dev Transfers control of the contract to a newOwner.
349    * @param _newOwner The address to transfer ownership to.
350    */
351   function _transferOwnership(address _newOwner) internal {
352     require(_newOwner != address(0));
353     emit OwnershipTransferred(owner, _newOwner);
354     owner = _newOwner;
355   }
356 }
357 
358 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
359 
360 /**
361  * @title ERC20Basic
362  * @dev Simpler version of ERC20 interface
363  * See https://github.com/ethereum/EIPs/issues/179
364  */
365 contract ERC20Basic {
366   function totalSupply() public view returns (uint256);
367   function balanceOf(address _who) public view returns (uint256);
368   function transfer(address _to, uint256 _value) public returns (bool);
369   event Transfer(address indexed from, address indexed to, uint256 value);
370 }
371 
372 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
373 
374 /**
375  * @title ERC20 interface
376  * @dev see https://github.com/ethereum/EIPs/issues/20
377  */
378 contract ERC20 is ERC20Basic {
379   function allowance(address _owner, address _spender)
380     public view returns (uint256);
381 
382   function transferFrom(address _from, address _to, uint256 _value)
383     public returns (bool);
384 
385   function approve(address _spender, uint256 _value) public returns (bool);
386   event Approval(
387     address indexed owner,
388     address indexed spender,
389     uint256 value
390   );
391 }
392 
393 // File: contracts/BadERC20Aware.sol
394 
395 library BadERC20Aware {
396     using SafeMath for uint;
397 
398     function isContract(address addr) internal view returns(bool result) {
399         // solium-disable-next-line security/no-inline-assembly
400         assembly {
401             result := gt(extcodesize(addr), 0)
402         }
403     }
404 
405     function handleReturnBool() internal pure returns(bool result) {
406         // solium-disable-next-line security/no-inline-assembly
407         assembly {
408             switch returndatasize()
409             case 0 { // not a std erc20
410                 result := 1
411             }
412             case 32 { // std erc20
413                 returndatacopy(0, 0, 32)
414                 result := mload(0)
415             }
416             default { // anything else, should revert for safety
417                 revert(0, 0)
418             }
419         }
420     }
421 
422     function asmTransfer(ERC20 _token, address _to, uint256 _value) internal returns(bool) {
423         require(isContract(_token));
424         // solium-disable-next-line security/no-low-level-calls
425         require(address(_token).call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
426         return handleReturnBool();
427     }
428 
429     function safeTransfer(ERC20 _token, address _to, uint256 _value) internal {
430         require(asmTransfer(_token, _to, _value));
431     }
432 }
433 
434 // File: contracts/TokenSwap.sol
435 
436 /**
437  * @title TokenSwap
438  * This product is protected under license.  Any unauthorized copy, modification, or use without
439  * express written consent from the creators is prohibited.
440  */
441 
442 
443 
444 
445 
446 
447 
448 contract TokenSwap is Ownable, Multiownable {
449 
450     // LIBRARIES
451 
452     using BadERC20Aware for ERC20;
453     using SafeMath for uint256;
454 
455     // TYPES
456 
457     enum Status {AddParties, WaitingDeposits, SwapConfirmed, SwapCanceled}
458 
459     struct SwapOffer {
460         address participant;
461         ERC20 token;
462 
463         uint256 tokensForSwap;
464         uint256 withdrawnTokensForSwap;
465 
466         uint256 tokensFee;
467         uint256 withdrawnFee;
468 
469         uint256 tokensTotal;
470         uint256 withdrawnTokensTotal;
471     }
472 
473     struct LockupStage {
474         uint256 secondsSinceLockupStart;
475         uint8 unlockedTokensPercentage;
476     }
477 
478     // VARIABLES
479     Status public status = Status.AddParties;
480 
481     uint256 internal startLockupAt;
482     LockupStage[] internal lockupStages;
483 
484     address[] internal participants;
485     mapping(address => bool) internal isParticipant;
486     mapping(address => address) internal tokenByParticipant;
487     mapping(address => SwapOffer) internal offerByToken;
488 
489     // EVENTS
490     event AddLockupStage(uint256 secondsSinceLockupStart, uint8 unlockedTokensPercentage);
491     event StatusUpdate(Status oldStatus, Status newStatus);
492     event AddParty(address participant, ERC20 token, uint256 amount);
493     event RemoveParty(address participant);
494     event ConfirmParties();
495     event CancelSwap();
496     event ConfirmSwap();
497     event StartLockup(uint256 startLockupAt);
498     event Withdraw(address participant, ERC20 token, uint256 amount);
499     event WithdrawFee(ERC20 token, uint256 amount);
500     event Reclaim(address participant, ERC20 token, uint256 amount);
501 
502     // MODIFIERS
503     modifier onlyParticipant {
504         require(
505             isParticipant[msg.sender] == true,
506             "Only swap participants allowed to call the method"
507         );
508         _;
509     }
510 
511     modifier canAddParty {
512         require(status == Status.AddParties, "Unable to add new parties in the current status");
513         _;
514     }
515 
516     modifier canRemoveParty {
517         require(status == Status.AddParties, "Unable to remove parties in the current status");
518         _;
519     }
520 
521     modifier canConfirmParties {
522         require(
523             status == Status.AddParties,
524             "Unable to confirm parties in the current status"
525         );
526         require(participants.length > 1, "Need at least two participants");
527         _;
528     }
529 
530     modifier canCancelSwap {
531         require(
532             status == Status.WaitingDeposits,
533             "Unable to cancel swap in the current status"
534         );
535         _;
536     }
537 
538     modifier canConfirmSwap {
539         require(status == Status.WaitingDeposits, "Unable to confirm in the current status");
540         require(
541             _haveEveryoneDeposited(),
542             "Unable to confirm swap before all parties have deposited tokens"
543         );
544         _;
545     }
546 
547     modifier canWithdraw {
548         require(status == Status.SwapConfirmed, "Unable to withdraw tokens in the current status");
549         require(startLockupAt != 0, "Lockup has not been started");
550         _;
551     }
552 
553     modifier canWithdrawFee {
554         require(status == Status.SwapConfirmed, "Unable to withdraw fee in the current status");
555         require(startLockupAt != 0, "Lockup has not been started");
556         _;
557     }
558 
559     modifier canReclaim {
560         require(
561             status == Status.SwapConfirmed || status == Status.SwapCanceled,
562             "Unable to reclaim in the current status"
563         );
564         _;
565     }
566 
567     // CONSTRUCTOR
568     constructor() public {
569         _initializeLockupStages();
570         _validateLockupStages();
571     }
572 
573     // EXTERNAL METHODS
574     /**
575      * @dev Add new party to the swap.
576      * @param _participant Address of the participant.
577      * @param _token An ERC20-compliant token which participant is offering to swap.
578      * @param _tokensForSwap How much tokens the participant wants to swap.
579      * @param _tokensFee How much tokens will be payed as a fee.
580      * @param _tokensTotal How much tokens the participant is offering (i.e. _tokensForSwap + _tokensFee).
581      */
582     function addParty(
583         address _participant,
584         ERC20 _token,
585         uint256 _tokensForSwap,
586         uint256 _tokensFee,
587         uint256 _tokensTotal
588     )
589         external
590         onlyOwner
591         canAddParty
592     {
593         require(_participant != address(0), "_participant is invalid address");
594         require(_token != address(0), "_token is invalid address");
595         require(_tokensForSwap > 0, "_tokensForSwap must be positive");
596         require(_tokensFee > 0, "_tokensFee must be positive");
597         require(_tokensTotal == _tokensForSwap.add(_tokensFee), "token amounts inconsistency");
598         require(
599             isParticipant[_participant] == false,
600             "Unable to add the same party multiple times"
601         );
602 
603         isParticipant[_participant] = true;
604         SwapOffer memory offer = SwapOffer({
605             participant: _participant,
606             token: _token,
607             tokensForSwap: _tokensForSwap,
608             withdrawnTokensForSwap: 0,
609             tokensFee: _tokensFee,
610             withdrawnFee: 0,
611             tokensTotal: _tokensTotal,
612             withdrawnTokensTotal: 0
613         });
614         participants.push(offer.participant);
615         offerByToken[offer.token] = offer;
616         tokenByParticipant[offer.participant] = offer.token;
617 
618         emit AddParty(offer.participant, offer.token, offer.tokensTotal);
619     }
620 
621     /**
622      * @dev Remove party.
623      * @param _participantIndex Index of the participant in the participants array.
624      */
625     function removeParty(uint256 _participantIndex) external onlyOwner canRemoveParty {
626         require(_participantIndex < participants.length, "Participant does not exist");
627 
628         address participant = participants[_participantIndex];
629         address token = tokenByParticipant[participant];
630 
631         delete isParticipant[participant];
632         participants[_participantIndex] = participants[participants.length - 1];
633         participants.length--;
634         delete offerByToken[token];
635         delete tokenByParticipant[participant];
636 
637         emit RemoveParty(participant);
638     }
639 
640     /**
641      * @dev Confirm swap parties
642      */
643     function confirmParties() external onlyOwner canConfirmParties {
644         address[] memory newOwners = new address[](participants.length + 1);
645 
646         for (uint256 i = 0; i < participants.length; i++) {
647             newOwners[i] = participants[i];
648         }
649 
650         newOwners[newOwners.length - 1] = owner;
651         transferOwnershipWithHowMany(newOwners, newOwners.length - 1);
652         _changeStatus(Status.WaitingDeposits);
653         emit ConfirmParties();
654     }
655 
656     /**
657      * @dev Confirm swap.
658      */
659     function confirmSwap() external canConfirmSwap onlyManyOwners {
660         emit ConfirmSwap();
661         _changeStatus(Status.SwapConfirmed);
662         _startLockup();
663     }
664 
665     /**
666      * @dev Cancel swap.
667      */
668     function cancelSwap() external canCancelSwap onlyManyOwners {
669         emit CancelSwap();
670         _changeStatus(Status.SwapCanceled);
671     }
672 
673     /**
674      * @dev Withdraw tokens
675      */
676     function withdraw() external onlyParticipant canWithdraw {
677         for (uint i = 0; i < participants.length; i++) {
678             address token = tokenByParticipant[participants[i]];
679             SwapOffer storage offer = offerByToken[token];
680 
681             if (offer.participant == msg.sender) {
682                 continue;
683             }
684 
685             uint256 tokenReceivers = participants.length - 1;
686             uint256 tokensAmount = _withdrawableAmount(offer).div(tokenReceivers);
687 
688             offer.token.safeTransfer(msg.sender, tokensAmount);
689             emit Withdraw(msg.sender, offer.token, tokensAmount);
690             offer.withdrawnTokensForSwap = offer.withdrawnTokensForSwap.add(tokensAmount);
691             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
692         }
693     }
694 
695     /**
696      * @dev Withdraw swap fee
697      */
698     function withdrawFee() external onlyOwner canWithdrawFee {
699         for (uint i = 0; i < participants.length; i++) {
700             address token = tokenByParticipant[participants[i]];
701             SwapOffer storage offer = offerByToken[token];
702 
703             uint256 tokensAmount = _withdrawableFee(offer);
704 
705             offer.token.safeTransfer(msg.sender, tokensAmount);
706             emit WithdrawFee(offer.token, tokensAmount);
707             offer.withdrawnFee = offer.withdrawnFee.add(tokensAmount);
708             offer.withdrawnTokensTotal = offer.withdrawnTokensTotal.add(tokensAmount);
709         }
710     }
711 
712     /**
713      * @dev Reclaim tokens if a participant has deposited too much or if the swap has been canceled.
714      */
715     function reclaim() external onlyParticipant canReclaim {
716         address token = tokenByParticipant[msg.sender];
717 
718         SwapOffer storage offer = offerByToken[token];
719         uint256 currentBalance = offer.token.balanceOf(address(this));
720         uint256 availableForReclaim = currentBalance;
721 
722         if (status != Status.SwapCanceled) {
723             uint256 lockedTokens = offer.tokensTotal.sub(offer.withdrawnTokensTotal);
724             availableForReclaim = currentBalance.sub(lockedTokens);
725         }
726 
727         if (availableForReclaim > 0) {
728             offer.token.safeTransfer(offer.participant, availableForReclaim);
729         }
730 
731         emit Reclaim(offer.participant, offer.token, availableForReclaim);
732     }
733 
734     // PUBLIC METHODS
735     /**
736      * @dev Standard ERC223 function that will handle incoming token transfers.
737      *
738      * @param _from  Token sender address.
739      * @param _value Amount of tokens.
740      * @param _data  Transaction metadata.
741      */
742     function tokenFallback(address _from, uint256 _value, bytes _data) public {
743 
744     }
745 
746     // INTERNAL METHODS
747     /**
748      * @dev Initialize lockup period stages.
749      */
750     function _initializeLockupStages() internal {
751         _addLockupStage(LockupStage(0, 10));
752         _addLockupStage(LockupStage(30 days, 20));
753         _addLockupStage(LockupStage(60 days, 30));
754         _addLockupStage(LockupStage(90 days, 40));
755         _addLockupStage(LockupStage(120 days, 50));
756         _addLockupStage(LockupStage(150 days, 60));
757         _addLockupStage(LockupStage(180 days, 70));
758         _addLockupStage(LockupStage(210 days, 80));
759         _addLockupStage(LockupStage(240 days, 90));
760         _addLockupStage(LockupStage(270 days, 100));
761     }
762 
763     /**
764      * @dev Add lockup period stage
765      */
766     function _addLockupStage(LockupStage _stage) internal {
767         emit AddLockupStage(_stage.secondsSinceLockupStart, _stage.unlockedTokensPercentage);
768         lockupStages.push(_stage);
769     }
770 
771     /**
772      * @dev Validate lock-up period configuration.
773      */
774     function _validateLockupStages() internal view {
775         for (uint i = 0; i < lockupStages.length; i++) {
776             LockupStage memory stage = lockupStages[i];
777 
778             require(
779                 stage.unlockedTokensPercentage >= 0,
780                 "LockupStage.unlockedTokensPercentage must not be negative"
781             );
782             require(
783                 stage.unlockedTokensPercentage <= 100,
784                 "LockupStage.unlockedTokensPercentage must not be greater than 100"
785             );
786 
787             if (i == 0) {
788                 continue;
789             }
790 
791             LockupStage memory previousStage = lockupStages[i - 1];
792             require(
793                 stage.secondsSinceLockupStart > previousStage.secondsSinceLockupStart,
794                 "LockupStage.secondsSinceLockupStart must increase monotonically"
795             );
796             require(
797                 stage.unlockedTokensPercentage > previousStage.unlockedTokensPercentage,
798                 "LockupStage.unlockedTokensPercentage must increase monotonically"
799             );
800         }
801 
802         require(
803             lockupStages[0].secondsSinceLockupStart == 0,
804             "The first lockup stage must start immediately"
805         );
806         require(
807             lockupStages[lockupStages.length - 1].unlockedTokensPercentage == 100,
808             "The last lockup stage must unlock 100% of tokens"
809         );
810     }
811 
812     /**
813      * @dev Change swap status.
814      */
815     function _changeStatus(Status _newStatus) internal {
816         emit StatusUpdate(status, _newStatus);
817         status = _newStatus;
818     }
819 
820     /**
821      * @dev Check whether every participant has deposited enough tokens for the swap to be confirmed.
822      */
823     function _haveEveryoneDeposited() internal view returns(bool) {
824         for (uint i = 0; i < participants.length; i++) {
825             address token = tokenByParticipant[participants[i]];
826             SwapOffer memory offer = offerByToken[token];
827 
828             if (offer.token.balanceOf(address(this)) < offer.tokensTotal) {
829                 return false;
830             }
831         }
832 
833         return true;
834     }
835 
836     /**
837      * @dev Start lockup period
838      */
839     function _startLockup() internal {
840         startLockupAt = now;
841         emit StartLockup(startLockupAt);
842     }
843 
844     /**
845      * @dev Find amount of tokens ready to be withdrawn by a swap party.
846      */
847     function _withdrawableAmount(SwapOffer _offer) internal view returns(uint256) {
848         return _unlockedAmount(_offer.tokensForSwap).sub(_offer.withdrawnTokensForSwap);
849     }
850 
851     /**
852      * @dev Find amount of tokens ready to be withdrawn as the swap fee.
853      */
854     function _withdrawableFee(SwapOffer _offer) internal view returns(uint256) {
855         return _unlockedAmount(_offer.tokensFee).sub(_offer.withdrawnFee);
856     }
857 
858     /**
859      * @dev Find amount of unlocked tokens, including withdrawn tokens.
860      */
861     function _unlockedAmount(uint256 totalAmount) internal view returns(uint256) {
862         return totalAmount.mul(_getUnlockedTokensPercentage()).div(100);
863     }
864 
865     /**
866      * @dev Get percent of unlocked tokens
867      */
868     function _getUnlockedTokensPercentage() internal view returns(uint256) {
869         for (uint256 i = lockupStages.length; i > 0; i--) {
870             LockupStage storage stage = lockupStages[i - 1];
871             uint256 stageBecomesActiveAt = startLockupAt.add(stage.secondsSinceLockupStart);
872 
873             if (now < stageBecomesActiveAt) {
874                 continue;
875             }
876 
877             return stage.unlockedTokensPercentage;
878         }
879     }
880 }