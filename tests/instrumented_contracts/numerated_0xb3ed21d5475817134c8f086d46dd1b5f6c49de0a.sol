1 /*
2   Zethr | https://zethr.io
3   (c) Copyright 2018 | All Rights Reserved
4   This smart contract was developed by the Zethr Dev Team and its source code remains property of the Zethr Project.
5 */
6 
7 pragma solidity ^0.4.24;
8 
9 // File: contracts/Libraries/SafeMath.sol
10 
11 library SafeMath {
12   function mul(uint a, uint b) internal pure returns (uint) {
13     if (a == 0) {
14       return 0;
15     }
16     uint c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal pure returns (uint) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal pure returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal pure returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 // File: contracts/Libraries/ZethrTierLibrary.sol
41 
42 library ZethrTierLibrary {
43   uint constant internal magnitude = 2 ** 64;
44 
45   // Gets the tier (1-7) of the divs sent based off of average dividend rate
46   // This is an index used to call into the correct sub-bankroll to withdraw tokens
47   function getTier(uint divRate) internal pure returns (uint8) {
48 
49     // Divide the average dividned rate by magnitude
50     // Remainder doesn't matter because of the below logic
51     uint actualDiv = divRate / magnitude;
52     if (actualDiv >= 30) {
53       return 6;
54     } else if (actualDiv >= 25) {
55       return 5;
56     } else if (actualDiv >= 20) {
57       return 4;
58     } else if (actualDiv >= 15) {
59       return 3;
60     } else if (actualDiv >= 10) {
61       return 2;
62     } else if (actualDiv >= 5) {
63       return 1;
64     } else if (actualDiv >= 2) {
65       return 0;
66     } else {
67       // Impossible
68       revert();
69     }
70   }
71 
72   function getDivRate(uint _tier)
73   internal pure
74   returns (uint8)
75   {
76     if (_tier == 0) {
77       return 2;
78     } else if (_tier == 1) {
79       return 5;
80     } else if (_tier == 2) {
81       return 10;
82     } else if (_tier == 3) {
83       return 15;
84     } else if (_tier == 4) {
85       return 20;
86     } else if (_tier == 5) {
87       return 25;
88     } else if (_tier == 6) {
89       return 33;
90     } else {
91       revert();
92     }
93   }
94 }
95 
96 // File: contracts/ERC/ERC223Receiving.sol
97 
98 contract ERC223Receiving {
99   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
100 }
101 
102 // File: contracts/ZethrMultiSigWallet.sol
103 
104 /* Zethr MultisigWallet
105  *
106  * Standard multisig wallet
107  * Holds the bankroll ETH, as well as the bankroll 33% ZTH tokens.
108 */ 
109 contract ZethrMultiSigWallet is ERC223Receiving {
110   using SafeMath for uint;
111 
112   /*=================================
113   =              EVENTS            =
114   =================================*/
115 
116   event Confirmation(address indexed sender, uint indexed transactionId);
117   event Revocation(address indexed sender, uint indexed transactionId);
118   event Submission(uint indexed transactionId);
119   event Execution(uint indexed transactionId);
120   event ExecutionFailure(uint indexed transactionId);
121   event Deposit(address indexed sender, uint value);
122   event OwnerAddition(address indexed owner);
123   event OwnerRemoval(address indexed owner);
124   event WhiteListAddition(address indexed contractAddress);
125   event WhiteListRemoval(address indexed contractAddress);
126   event RequirementChange(uint required);
127   event BankrollInvest(uint amountReceived);
128 
129   /*=================================
130   =             VARIABLES           =
131   =================================*/
132 
133   mapping (uint => Transaction) public transactions;
134   mapping (uint => mapping (address => bool)) public confirmations;
135   mapping (address => bool) public isOwner;
136   address[] public owners;
137   uint public required;
138   uint public transactionCount;
139   bool internal reEntered = false;
140   uint constant public MAX_OWNER_COUNT = 15;
141 
142   /*=================================
143   =         CUSTOM CONSTRUCTS       =
144   =================================*/
145 
146   struct Transaction {
147     address destination;
148     uint value;
149     bytes data;
150     bool executed;
151   }
152 
153   struct TKN {
154     address sender;
155     uint value;
156   }
157 
158   /*=================================
159   =            MODIFIERS            =
160   =================================*/
161 
162   modifier onlyWallet() {
163     if (msg.sender != address(this))
164       revert();
165     _;
166   }
167 
168   modifier isAnOwner() {
169     address caller = msg.sender;
170     if (isOwner[caller])
171       _;
172     else
173       revert();
174   }
175 
176   modifier ownerDoesNotExist(address owner) {
177     if (isOwner[owner]) 
178       revert();
179       _;
180   }
181 
182   modifier ownerExists(address owner) {
183     if (!isOwner[owner])
184       revert();
185     _;
186   }
187 
188   modifier transactionExists(uint transactionId) {
189     if (transactions[transactionId].destination == 0)
190       revert();
191     _;
192   }
193 
194   modifier confirmed(uint transactionId, address owner) {
195     if (!confirmations[transactionId][owner])
196       revert();
197     _;
198   }
199 
200   modifier notConfirmed(uint transactionId, address owner) {
201     if (confirmations[transactionId][owner])
202       revert();
203     _;
204   }
205 
206   modifier notExecuted(uint transactionId) {
207     if (transactions[transactionId].executed)
208       revert();
209     _;
210   }
211 
212   modifier notNull(address _address) {
213     if (_address == 0)
214       revert();
215     _;
216   }
217 
218   modifier validRequirement(uint ownerCount, uint _required) {
219     if ( ownerCount > MAX_OWNER_COUNT
220       || _required > ownerCount
221       || _required == 0
222       || ownerCount == 0)
223       revert();
224     _;
225   }
226 
227 
228   /*=================================
229   =         PUBLIC FUNCTIONS        =
230   =================================*/
231 
232   /// @dev Contract constructor sets initial owners and required number of confirmations.
233   /// @param _owners List of initial owners.
234   /// @param _required Number of required confirmations.
235   constructor (address[] _owners, uint _required)
236     public
237     validRequirement(_owners.length, _required)
238   {
239     // Add owners
240     for (uint i=0; i<_owners.length; i++) {
241       if (isOwner[_owners[i]] || _owners[i] == 0)
242         revert();
243       isOwner[_owners[i]] = true;
244     }
245 
246     // Set owners
247     owners = _owners;
248 
249     // Set required
250     required = _required;
251   }
252 
253   /** Testing only.
254   function exitAll()
255     public
256   {
257     uint tokenBalance = ZTHTKN.balanceOf(address(this));
258     ZTHTKN.sell(tokenBalance - 1e18);
259     ZTHTKN.sell(1e18);
260     ZTHTKN.withdraw(address(0x0));
261   }
262   **/
263 
264   /// @dev Fallback function allows Ether to be deposited.
265   function()
266     public
267     payable
268   {
269 
270   }
271     
272   /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
273   /// @param owner Address of new owner.
274   function addOwner(address owner)
275     public
276     onlyWallet
277     ownerDoesNotExist(owner)
278     notNull(owner)
279     validRequirement(owners.length + 1, required)
280   {
281     isOwner[owner] = true;
282     owners.push(owner);
283     emit OwnerAddition(owner);
284   }
285 
286   /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
287   /// @param owner Address of owner.
288   function removeOwner(address owner)
289     public
290     onlyWallet
291     ownerExists(owner)
292     validRequirement(owners.length, required)
293   {
294     isOwner[owner] = false;
295     for (uint i=0; i<owners.length - 1; i++)
296       if (owners[i] == owner) {
297         owners[i] = owners[owners.length - 1];
298         break;
299       }
300 
301     owners.length -= 1;
302     if (required > owners.length)
303       changeRequirement(owners.length);
304     emit OwnerRemoval(owner);
305   }
306 
307   /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
308   /// @param owner Address of owner to be replaced.
309   /// @param owner Address of new owner.
310   function replaceOwner(address owner, address newOwner)
311     public
312     onlyWallet
313     ownerExists(owner)
314     ownerDoesNotExist(newOwner)
315   {
316     for (uint i=0; i<owners.length; i++)
317       if (owners[i] == owner) {
318         owners[i] = newOwner;
319         break;
320       }
321 
322     isOwner[owner] = false;
323     isOwner[newOwner] = true;
324     emit OwnerRemoval(owner);
325     emit OwnerAddition(newOwner);
326   }
327 
328   /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
329   /// @param _required Number of required confirmations.
330   function changeRequirement(uint _required)
331     public
332     onlyWallet
333     validRequirement(owners.length, _required)
334   {
335     required = _required;
336     emit RequirementChange(_required);
337   }
338 
339   /// @dev Allows an owner to submit and confirm a transaction.
340   /// @param destination Transaction target address.
341   /// @param value Transaction ether value.
342   /// @param data Transaction data payload.
343   /// @return Returns transaction ID.
344   function submitTransaction(address destination, uint value, bytes data)
345     public
346     returns (uint transactionId)
347   {
348     transactionId = addTransaction(destination, value, data);
349     confirmTransaction(transactionId);
350   }
351 
352   /// @dev Allows an owner to confirm a transaction.
353   /// @param transactionId Transaction ID.
354   function confirmTransaction(uint transactionId)
355     public
356     ownerExists(msg.sender)
357     transactionExists(transactionId)
358     notConfirmed(transactionId, msg.sender)
359   {
360     confirmations[transactionId][msg.sender] = true;
361     emit Confirmation(msg.sender, transactionId);
362     executeTransaction(transactionId);
363   }
364 
365   /// @dev Allows an owner to revoke a confirmation for a transaction.
366   /// @param transactionId Transaction ID.
367   function revokeConfirmation(uint transactionId)
368     public
369     ownerExists(msg.sender)
370     confirmed(transactionId, msg.sender)
371     notExecuted(transactionId)
372   {
373     confirmations[transactionId][msg.sender] = false;
374     emit Revocation(msg.sender, transactionId);
375   }
376 
377   /// @dev Allows anyone to execute a confirmed transaction.
378   /// @param transactionId Transaction ID.
379   function executeTransaction(uint transactionId)
380     public
381     notExecuted(transactionId)
382   {
383     if (isConfirmed(transactionId)) {
384       Transaction storage txToExecute = transactions[transactionId];
385       txToExecute.executed = true;
386       if (txToExecute.destination.call.value(txToExecute.value)(txToExecute.data))
387         emit Execution(transactionId);
388       else {
389         emit ExecutionFailure(transactionId);
390         txToExecute.executed = false;
391       }
392     }
393   }
394 
395   /// @dev Returns the confirmation status of a transaction.
396   /// @param transactionId Transaction ID.
397   /// @return Confirmation status.
398   function isConfirmed(uint transactionId)
399     public
400     constant
401     returns (bool)
402   {
403     uint count = 0;
404     for (uint i=0; i<owners.length; i++) {
405       if (confirmations[transactionId][owners[i]])
406         count += 1;
407       if (count == required)
408         return true;
409     }
410   }
411 
412   /*=================================
413   =        OPERATOR FUNCTIONS       =
414   =================================*/
415 
416   /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
417   /// @param destination Transaction target address.
418   /// @param value Transaction ether value.
419   /// @param data Transaction data payload.
420   /// @return Returns transaction ID.
421   function addTransaction(address destination, uint value, bytes data)
422     internal
423     notNull(destination)
424     returns (uint transactionId)
425   {
426     transactionId = transactionCount;
427 
428     transactions[transactionId] = Transaction({
429         destination: destination,
430         value: value,
431         data: data,
432         executed: false
433     });
434 
435     transactionCount += 1;
436     emit Submission(transactionId);
437   }
438 
439   /*
440    * Web3 call functions
441    */
442   /// @dev Returns number of confirmations of a transaction.
443   /// @param transactionId Transaction ID.
444   /// @return Number of confirmations.
445   function getConfirmationCount(uint transactionId)
446     public
447     constant
448     returns (uint count)
449   {
450     for (uint i=0; i<owners.length; i++)
451       if (confirmations[transactionId][owners[i]])
452         count += 1;
453   }
454 
455   /// @dev Returns total number of transactions after filers are applied.
456   /// @param pending Include pending transactions.
457   /// @param executed Include executed transactions.
458   /// @return Total number of transactions after filters are applied.
459   function getTransactionCount(bool pending, bool executed)
460     public
461     constant
462     returns (uint count)
463   {
464     for (uint i=0; i<transactionCount; i++)
465       if (pending && !transactions[i].executed || executed && transactions[i].executed)
466         count += 1;
467   }
468 
469   /// @dev Returns list of owners.
470   /// @return List of owner addresses.
471   function getOwners()
472     public
473     constant
474     returns (address[])
475   {
476     return owners;
477   }
478 
479   /// @dev Returns array with owner addresses, which confirmed transaction.
480   /// @param transactionId Transaction ID.
481   /// @return Returns array of owner addresses.
482   function getConfirmations(uint transactionId)
483     public
484     constant
485     returns (address[] _confirmations)
486   {
487     address[] memory confirmationsTemp = new address[](owners.length);
488     uint count = 0;
489     uint i;
490     for (i=0; i<owners.length; i++)
491       if (confirmations[transactionId][owners[i]]) {
492         confirmationsTemp[count] = owners[i];
493         count += 1;
494       }
495 
496       _confirmations = new address[](count);
497 
498       for (i=0; i<count; i++)
499         _confirmations[i] = confirmationsTemp[i];
500   }
501 
502   /// @dev Returns list of transaction IDs in defined range.
503   /// @param from Index start position of transaction array.
504   /// @param to Index end position of transaction array.
505   /// @param pending Include pending transactions.
506   /// @param executed Include executed transactions.
507   /// @return Returns array of transaction IDs.
508   function getTransactionIds(uint from, uint to, bool pending, bool executed)
509     public
510     constant
511     returns (uint[] _transactionIds)
512   {
513     uint[] memory transactionIdsTemp = new uint[](transactionCount);
514     uint count = 0;
515     uint i;
516 
517     for (i=0; i<transactionCount; i++)
518       if (pending && !transactions[i].executed || executed && transactions[i].executed) {
519         transactionIdsTemp[count] = i;
520         count += 1;
521       }
522 
523       _transactionIds = new uint[](to - from);
524 
525     for (i=from; i<to; i++)
526       _transactionIds[i - from] = transactionIdsTemp[i];
527   }
528 
529   function tokenFallback(address /*_from*/, uint /*_amountOfTokens*/, bytes /*_data*/)
530   public
531   returns (bool)
532   {
533     return true;
534   }
535 }
536 
537 // File: contracts/Bankroll/Interfaces/ZethrTokenBankrollInterface.sol
538 
539 // Zethr token bankroll function prototypes
540 contract ZethrTokenBankrollInterface is ERC223Receiving {
541   uint public jackpotBalance;
542   
543   function getMaxProfit(address) public view returns (uint);
544   function gameTokenResolution(uint _toWinnerAmount, address _winnerAddress, uint _toJackpotAmount, address _jackpotAddress, uint _originalBetSize) external;
545   function payJackpotToWinner(address _winnerAddress, uint payoutDivisor) public;
546 }
547 
548 // File: contracts/Bankroll/Interfaces/ZethrBankrollControllerInterface.sol
549 
550 contract ZethrBankrollControllerInterface is ERC223Receiving {
551   address public jackpotAddress;
552 
553   ZethrTokenBankrollInterface[7] public tokenBankrolls; 
554   
555   ZethrMultiSigWallet public multiSigWallet;
556 
557   mapping(address => bool) public validGameAddresses;
558 
559   function gamePayoutResolver(address _resolver, uint _tokenAmount) public;
560 
561   function isTokenBankroll(address _address) public view returns (bool);
562 
563   function getTokenBankrollAddressFromTier(uint8 _tier) public view returns (address);
564 
565   function tokenFallback(address _from, uint _amountOfTokens, bytes _data) public returns (bool);
566 }
567 
568 // File: contracts/Bankroll/ZethrGame.sol
569 
570 /* Zethr Game Interface
571  *
572  * Contains the necessary functions to integrate with
573  * the Zethr Token bankrolls & the Zethr game ecosystem.
574  *
575  * Token Bankroll Functions:
576  *  - execute
577  *
578  * Player Functions:
579  *  - finish
580  *
581  * Bankroll Controller / Owner Functions:
582  *  - pauseGame
583  *  - resumeGame
584  *  - set resolver percentage
585  *  - set controller address
586  *
587  * Player/Token Bankroll Functions:
588  *  - resolvePendingBets
589 */
590 contract ZethrGame {
591   using SafeMath for uint;
592   using SafeMath for uint56;
593 
594   // Default events:
595   event Result (address player, uint amountWagered, int amountOffset);
596   event Wager (address player, uint amount, bytes data);
597 
598   // Queue of pending/unresolved bets
599   address[] pendingBetsQueue;
600   uint queueHead = 0;
601   uint queueTail = 0;
602 
603   // Store each player's latest bet via mapping
604   mapping(address => BetBase) bets;
605 
606   // Bet structures must start with this layout
607   struct BetBase {
608     // Must contain these in this order
609     uint56 tokenValue;    // Multiply by 1e14 to get tokens
610     uint48 blockNumber;
611     uint8 tier;
612     // Game specific structures can add more after this
613   }
614 
615   // Mapping of addresses to their *position* in the queue
616   // Zero = they aren't in the queue
617   mapping(address => uint) pendingBetsMapping;
618 
619   // Holds the bankroll controller info
620   ZethrBankrollControllerInterface controller;
621 
622   // Is the game paused?
623   bool paused;
624 
625   // Minimum bet should always be >= 1
626   uint minBet = 1e18;
627 
628   // Percentage that a resolver gets when he resolves bets for the house
629   uint resolverPercentage;
630 
631   // Every game has a name
632   string gameName;
633 
634   constructor (address _controllerAddress, uint _resolverPercentage, string _name) public {
635     controller = ZethrBankrollControllerInterface(_controllerAddress);
636     resolverPercentage = _resolverPercentage;
637     gameName = _name;
638   }
639 
640   /** @dev Gets the max profit of this game as decided by the token bankroll
641     * @return uint The maximum profit
642     */
643   function getMaxProfit()
644   public view
645   returns (uint)
646   {
647     return ZethrTokenBankrollInterface(msg.sender).getMaxProfit(address(this));
648   }
649 
650   /** @dev Pauses the game, preventing anyone from placing bets
651     */
652   function ownerPauseGame()
653   public
654   ownerOnly
655   {
656     paused = true;
657   }
658 
659   /** @dev Resumes the game, allowing bets
660     */
661   function ownerResumeGame()
662   public
663   ownerOnly
664   {
665     paused = false;
666   }
667 
668   /** @dev Sets the percentage of the bets that a resolver gets when resolving tokens.
669     * @param _percentage The percentage as x/1,000,000 that the resolver gets
670     */
671   function ownerSetResolverPercentage(uint _percentage)
672   public
673   ownerOnly
674   {
675     require(_percentage <= 1000000);
676     resolverPercentage = _percentage;
677   }
678 
679   /** @dev Sets the address of the game controller
680     * @param _controllerAddress The new address of the controller
681     */
682   function ownerSetControllerAddress(address _controllerAddress)
683   public
684   ownerOnly
685   {
686     controller = ZethrBankrollControllerInterface(_controllerAddress);
687   }
688 
689   // Every game should have a name
690   /** @dev Sets the name of the game
691     * @param _name The name of the game
692     */
693   function ownerSetGameName(string _name)
694   ownerOnly
695   public
696   {
697     gameName = _name;
698   }
699 
700   /** @dev Gets the game name
701     * @return The name of the game
702     */
703   function getGameName()
704   public view
705   returns (string)
706   {
707     return gameName;
708   }
709 
710   /** @dev Resolve expired bets in the queue. Gives a percentage of the house edge to the resolver as ZTH
711     * @param _numToResolve The number of bets to resolve.
712     * @return tokensEarned The number of tokens earned
713     * @return queueHead The new head of the queue
714     */
715   function resolveExpiredBets(uint _numToResolve)
716   public
717   returns (uint tokensEarned_, uint queueHead_)
718   {
719     uint mQueue = queueHead;
720     uint head;
721     uint tail = (mQueue + _numToResolve) > pendingBetsQueue.length ? pendingBetsQueue.length : (mQueue + _numToResolve);
722     uint tokensEarned = 0;
723 
724     for (head = mQueue; head < tail; head++) {
725       // Check the head of the queue to see if there is a resolvable bet
726       // This means the bet at the queue head is older than 255 blocks AND is not 0
727       // (However, if the address at the head is null, skip it, it's already been resolved)
728       if (pendingBetsQueue[head] == address(0x0)) {
729         continue;
730       }
731 
732       if (bets[pendingBetsQueue[head]].blockNumber != 0 && block.number > 256 + bets[pendingBetsQueue[head]].blockNumber) {
733         // Resolve the bet
734         // finishBetfrom returns the *player* profit
735         // this will be negative if the player lost and the house won
736         // so flip it to get the house profit, if any
737         int sum = - finishBetFrom(pendingBetsQueue[head]);
738 
739         // Tokens earned is a percentage of the loss
740         if (sum > 0) {
741           tokensEarned += (uint(sum).mul(resolverPercentage)).div(1000000);
742         }
743 
744         // Queue-tail is always the "next" open spot, so queue head and tail will never overlap
745       } else {
746         // If we can't resolve a bet, stop going down the queue
747         break;
748       }
749     }
750 
751     queueHead = head;
752 
753     // Send the earned tokens to the resolver
754     if (tokensEarned >= 1e14) {
755       controller.gamePayoutResolver(msg.sender, tokensEarned);
756     }
757 
758     return (tokensEarned, head);
759   }
760 
761   /** @dev Finishes the bet of the sender, if it exists.
762     * @return int The total profit (positive or negative) earned by the sender
763     */
764   function finishBet()
765   public
766   hasNotBetThisBlock(msg.sender)
767   returns (int)
768   {
769     return finishBetFrom(msg.sender);
770   }
771 
772   /** @dev Resturns a random number
773     * @param _blockn The block number to base the random number off of
774     * @param _entropy Data to use in the random generation
775     * @param _index Data to use in the random generation
776     * @return randomNumber The random number to return
777     */
778   function maxRandom(uint _blockn, address _entropy, uint _index)
779   private view
780   returns (uint256 randomNumber)
781   {
782     return uint256(keccak256(
783         abi.encodePacked(
784           blockhash(_blockn),
785           _entropy,
786           _index
787         )));
788   }
789 
790   /** @dev Returns a random number
791     * @param _upper The upper end of the range, exclusive
792     * @param _blockn The block number to use for the random number
793     * @param _entropy An address to be used for entropy
794     * @param _index A number to get the next random number
795     * @return randomNumber The random number
796     */
797   function random(uint256 _upper, uint256 _blockn, address _entropy, uint _index)
798   internal view
799   returns (uint256 randomNumber)
800   {
801     return maxRandom(_blockn, _entropy, _index) % _upper;
802   }
803 
804   // Prevents the user from placing two bets in one block
805   modifier hasNotBetThisBlock(address _sender)
806   {
807     require(bets[_sender].blockNumber != block.number);
808     _;
809   }
810 
811   // Requires that msg.sender is one of the token bankrolls
812   modifier bankrollOnly {
813     require(controller.isTokenBankroll(msg.sender));
814     _;
815   }
816 
817   // Requires that the game is not paused
818   modifier isNotPaused {
819     require(!paused);
820     _;
821   }
822 
823   // Requires that the bet given has max profit low enough
824   modifier betIsValid(uint _betSize, uint _tier, bytes _data) {
825     uint divRate = ZethrTierLibrary.getDivRate(_tier);
826     require(isBetValid(_betSize, divRate, _data));
827     _;
828   }
829 
830   // Only an owner can call this method (controller is always an owner)
831   modifier ownerOnly()
832   {
833     require(msg.sender == address(controller) || controller.multiSigWallet().isOwner(msg.sender));
834     _;
835   }
836 
837   /** @dev Places a bet. Callable only by token bankrolls
838     * @param _player The player that is placing the bet
839     * @param _tokenCount The total number of tokens bet
840     * @param _divRate The dividend rate of the player
841     * @param _data The game-specific data, encoded in bytes-form
842     */
843   function execute(address _player, uint _tokenCount, uint _divRate, bytes _data) public;
844 
845   /** @dev Resolves the bet of the supplied player.
846     * @param _playerAddress The address of the player whos bet we are resolving
847     * @return int The total profit the player earned, positive or negative
848     */
849   function finishBetFrom(address _playerAddress) internal returns (int);
850 
851   /** @dev Determines if a supplied bet is valid
852     * @param _tokenCount The total number of tokens bet
853     * @param _divRate The dividend rate of the bet
854     * @param _data The game-specific bet data
855     * @return bool Whether or not the bet is valid
856     */
857   function isBetValid(uint _tokenCount, uint _divRate, bytes _data) public view returns (bool);
858 }
859 
860 // File: contracts/Games/ZethrDice.sol
861 
862 /* The actual game contract.
863  *
864  * This contract contains the actual game logic,
865  * including placing bets (execute), resolving bets,
866  * and resolving expired bets.
867 */
868 contract ZethrDice is ZethrGame {
869 
870   /****************************
871    * GAME SPECIFIC
872    ****************************/
873 
874   // Slots-specific bet structure
875   struct Bet {
876     // Must contain these in this order
877     uint56 tokenValue;
878     uint48 blockNumber;
879     uint8 tier;
880     // Game specific
881     uint8 rollUnder;
882     uint8 numRolls;
883   }
884 
885   /****************************
886    * FIELDS
887    ****************************/
888 
889   uint constant private MAX_INT = 2 ** 256 - 1;
890   uint constant public maxProfitDivisor = 1000000;
891   uint constant public maxNumber = 100;
892   uint constant public minNumber = 2;
893   uint constant public houseEdgeDivisor = 1000;
894   uint constant public houseEdge = 990;
895   uint constant public minBet = 1e18;
896 
897   /****************************
898    * CONSTRUCTOR
899    ****************************/
900 
901   constructor (address _controllerAddress, uint _resolverPercentage, string _name)
902   ZethrGame(_controllerAddress, _resolverPercentage, _name)
903   public
904   {
905   }
906 
907   /****************************
908    * USER METHODS
909    ****************************/
910 
911   /** @dev Retrieve the results of the last roll of a player, for web3 calls.
912     * @param _playerAddress The address of the player
913     */
914   function getLastRollOutput(address _playerAddress)
915   public view
916   returns (uint winAmount, uint lossAmount, uint[] memory output)
917   {
918     // Cast to Bet and read from storage
919     Bet storage playerBetInStorage = getBet(_playerAddress);
920     Bet memory playerBet = playerBetInStorage;
921 
922     // Safety check
923     require(playerBet.blockNumber != 0);
924 
925     (winAmount, lossAmount, output) = getRollOutput(playerBet.blockNumber, playerBet.rollUnder, playerBet.numRolls, playerBet.tokenValue.mul(1e14), _playerAddress);
926 
927     return (winAmount, lossAmount, output);
928   }
929 
930     event RollResult(
931         uint    _blockNumber,
932         address _target,
933         uint    _rollUnder,
934         uint    _numRolls,
935         uint    _tokenValue,
936         uint    _winAmount,
937         uint    _lossAmount,
938         uint[]  _output
939     );
940 
941   /** @dev Retrieve the results of the spin, for web3 calls.
942     * @param _blockNumber The block number of the spin
943     * @param _numRolls The number of rolls of this bet
944     * @param _tokenValue The total number of tokens bet
945     * @param _target The address of the better
946     * @return winAmount The total number of tokens won
947     * @return lossAmount The total number of tokens lost
948     * @return output An array of all of the results of a multispin
949     */
950   function getRollOutput(uint _blockNumber, uint8 _rollUnder, uint8 _numRolls, uint _tokenValue, address _target)
951   public
952   returns (uint winAmount, uint lossAmount, uint[] memory output)
953   {
954     output = new uint[](_numRolls);
955     // Where the result sections start and stop
956 
957     // If current block for the first spin is older than 255 blocks, ALL rolls are losses
958     if (block.number - _blockNumber > 255) {
959       lossAmount = _tokenValue.mul(_numRolls);
960     } else {
961       uint profit = calculateProfit(_tokenValue, _rollUnder);
962 
963       for (uint i = 0; i < _numRolls; i++) {
964         // Store the output
965         output[i] = random(100, _blockNumber, _target, i) + 1;
966 
967         if (output[i] < _rollUnder) {
968           // Player has won!
969           winAmount += profit + _tokenValue;
970         } else {
971           lossAmount += _tokenValue;
972         }
973       }
974     }
975     emit RollResult(_blockNumber, _target, _rollUnder, _numRolls, _tokenValue, winAmount, lossAmount, output);
976     return (winAmount, lossAmount, output);
977   }
978 
979   /** @dev Retrieve the results of the roll, for contract calls.
980     * @param _blockNumber The block number of the roll
981     * @param _numRolls The number of rolls of this bet
982     * @param _rollUnder The number the roll has to be under to win
983     * @param _tokenValue The total number of tokens bet
984     * @param _target The address of the better
985     * @return winAmount The total number of tokens won
986     * @return lossAmount The total number of tokens lost
987     */
988   function getRollResults(uint _blockNumber, uint8 _rollUnder, uint8 _numRolls, uint _tokenValue, address _target)
989   public
990   returns (uint winAmount, uint lossAmount)
991   {
992     // If current block for the first spin is older than 255 blocks, ALL rolls are losses
993     if (block.number - _blockNumber > 255) {
994       lossAmount = _tokenValue.mul(_numRolls);
995     } else {
996       uint profit = calculateProfit(_tokenValue, _rollUnder);
997 
998       for (uint i = 0; i < _numRolls; i++) {
999         // Store the output
1000         uint output = random(100, _blockNumber, _target, i) + 1;
1001 
1002         if (output < _rollUnder) {
1003           winAmount += profit + _tokenValue;
1004         } else {
1005           lossAmount += _tokenValue;
1006         }
1007       }
1008     }
1009 
1010     return (winAmount, lossAmount);
1011   }
1012 
1013   /****************************
1014    * OWNER METHODS
1015    ****************************/
1016 
1017   /****************************
1018    * INTERNALS
1019    ****************************/
1020 
1021   // Calculate the maximum potential profit
1022   function calculateProfit(uint _initBet, uint _roll)
1023   internal view
1024   returns (uint)
1025   {
1026     return ((((_initBet * (100 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
1027   }
1028 
1029   /** @dev Returs the bet struct of a player
1030     * @param _playerAddress The address of the player
1031     * @return Bet The bet of the player
1032     */
1033   function getBet(address _playerAddress)
1034   internal view
1035   returns (Bet storage)
1036   {
1037     // Cast BetBase to Bet
1038     BetBase storage betBase = bets[_playerAddress];
1039 
1040     Bet storage playerBet;
1041     assembly {
1042     // tmp is pushed onto stack and points to betBase slot in storage
1043       let tmp := betBase_slot
1044 
1045     // swap1 swaps tmp and playerBet pointers
1046       swap1
1047     }
1048     // tmp is popped off the stack
1049 
1050     // playerBet now points to betBase
1051     return playerBet;
1052   }
1053 
1054   /****************************
1055    * OVERRIDDEN METHODS
1056    ****************************/
1057 
1058   /** @dev Resolves the bet of the supplied player.
1059     * @param _playerAddress The address of the player whos bet we are resolving
1060     * @return totalProfit The total profit the player earned, positive or negative
1061     */
1062   function finishBetFrom(address _playerAddress)
1063   internal
1064   returns (int /*totalProfit*/)
1065   {
1066     // Memory vars to hold data as we compute it
1067     uint winAmount;
1068     uint lossAmount;
1069 
1070     // Cast to Bet and read from storage
1071     Bet storage playerBetInStorage = getBet(_playerAddress);
1072     Bet memory playerBet = playerBetInStorage;
1073 
1074     // Safety check
1075     require(playerBet.blockNumber != 0);
1076     playerBetInStorage.blockNumber = 0;
1077 
1078     // Iterate over the number of rolls and calculate totals:
1079     //  - player win amount
1080     //  - bankroll win amount
1081     (winAmount, lossAmount) = getRollResults(playerBet.blockNumber, playerBet.rollUnder, playerBet.numRolls, playerBet.tokenValue.mul(1e14), _playerAddress);
1082 
1083     // Figure out the token bankroll address
1084     address tokenBankrollAddress = controller.getTokenBankrollAddressFromTier(playerBet.tier);
1085     ZethrTokenBankrollInterface bankroll = ZethrTokenBankrollInterface(tokenBankrollAddress);
1086 
1087     // Call into the bankroll to do some token accounting
1088     bankroll.gameTokenResolution(winAmount, _playerAddress, 0, address(0x0), playerBet.tokenValue.mul(1e14).mul(playerBet.numRolls));
1089 
1090     // Grab the position of the player in the pending bets queue
1091     uint index = pendingBetsMapping[_playerAddress];
1092 
1093     // Remove the player from the pending bets queue by setting the address to 0x0
1094     pendingBetsQueue[index] = address(0x0);
1095 
1096     // Delete the player's bet by setting the mapping to zero
1097     pendingBetsMapping[_playerAddress] = 0;
1098 
1099     emit Result(_playerAddress, playerBet.tokenValue.mul(1e14), int(winAmount) - int(lossAmount));
1100 
1101     // Return all bet results + total *player* profit
1102     return (int(winAmount) - int(lossAmount));
1103   }
1104 
1105   /** @dev Places a bet. Callable only by token bankrolls
1106     * @param _player The player that is placing the bet
1107     * @param _tokenCount The total number of tokens bet
1108     * @param _tier The div rate tier the player falls in
1109     * @param _data The game-specific data, encoded in bytes-form
1110     */
1111   function execute(address _player, uint _tokenCount, uint _tier, bytes _data)
1112   isNotPaused
1113   bankrollOnly
1114   betIsValid(_tokenCount, _tier, _data)
1115   hasNotBetThisBlock(_player)
1116   public
1117   {
1118     Bet storage playerBet = getBet(_player);
1119 
1120     // Check for a player bet and resolve if necessary
1121     if (playerBet.blockNumber != 0) {
1122       finishBetFrom(_player);
1123     }
1124 
1125     uint8 rolls = uint8(_data[0]);
1126     uint8 rollUnder = uint8(_data[1]);
1127 
1128     // Set bet information
1129     playerBet.tokenValue = uint56(_tokenCount.div(rolls).div(1e14));
1130     playerBet.blockNumber = uint48(block.number);
1131     playerBet.tier = uint8(_tier);
1132     playerBet.rollUnder = rollUnder;
1133     playerBet.numRolls = rolls;
1134 
1135     // Add player to the pending bets queue
1136     pendingBetsQueue.length ++;
1137     pendingBetsQueue[queueTail] = _player;
1138     queueTail++;
1139 
1140     // Add the player's position in the queue to the pending bets mapping
1141     pendingBetsMapping[_player] = queueTail - 1;
1142 
1143     // Emit event
1144     emit Wager(_player, _tokenCount, _data);
1145   }
1146 
1147   /** @dev Determines if a supplied bet is valid
1148     * @param _tokenCount The total number of tokens bet
1149     * @param _data The game-specific bet data
1150     * @return bool Whether or not the bet is valid
1151     */
1152   function isBetValid(uint _tokenCount, uint /*_divRate*/, bytes _data)
1153   public view
1154   returns (bool)
1155   {
1156     uint8 rollUnder = uint8(_data[1]);
1157 
1158     return (calculateProfit(_tokenCount, rollUnder) < getMaxProfit()
1159     && _tokenCount >= minBet
1160     && rollUnder >= minNumber
1161     && rollUnder <= maxNumber);
1162   }
1163 }