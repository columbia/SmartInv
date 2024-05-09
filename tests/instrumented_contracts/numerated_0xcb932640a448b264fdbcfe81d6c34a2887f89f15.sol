1 pragma solidity ^0.4.21;
2 
3 // File: contracts/Bankroll.sol
4 
5 interface Bankroll {
6 
7     //Customer functions
8 
9     /// @dev Stores ETH funds for customer
10     function credit(address _customerAddress, uint256 amount) external returns (uint256);
11 
12     /// @dev Debits address by an amount
13     function debit(address _customerAddress, uint256 amount) external returns (uint256);
14 
15     /// @dev Withraws balance for address; returns amount sent
16     function withdraw(address _customerAddress) external returns (uint256);
17 
18     /// @dev Retrieve the token balance of any single address.
19     function balanceOf(address _customerAddress) external view returns (uint256);
20 
21     /// @dev Stats of any single address
22     function statsOf(address _customerAddress) external view returns (uint256[8]);
23 
24 
25     // System functions
26 
27     // @dev Deposit funds
28     function deposit() external payable;
29 
30     // @dev Deposit on behalf of an address; it is not a credit
31     function depositBy(address _customerAddress) external payable;
32 
33     // @dev Distribute house profit
34     function houseProfit(uint256 amount)  external;
35 
36 
37     /// @dev Get all the ETH stored in contract minus credits to customers
38     function netEthereumBalance() external view returns (uint256);
39 
40 
41     /// @dev Get all the ETH stored in contract
42     function totalEthereumBalance() external view returns (uint256);
43 
44 }
45 
46 // File: contracts/SessionQueue.sol
47 
48 /// A FIFO queue for storing addresses
49 contract SessionQueue {
50 
51     mapping(uint256 => address) private queue;
52     uint256 private first = 1;
53     uint256 private last = 0;
54 
55     /// @dev Push into queue
56     function enqueue(address data) internal {
57         last += 1;
58         queue[last] = data;
59     }
60 
61     /// @dev Returns true if the queue has elements in it
62     function available() internal view returns (bool) {
63         return last >= first;
64     }
65 
66     /// @dev Returns the size of the queue
67     function depth() internal view returns (uint256) {
68         return last - first + 1;
69     }
70 
71     /// @dev Pops from the head of the queue
72     function dequeue() internal returns (address data) {
73         require(last >= first);
74         // non-empty queue
75 
76         data = queue[first];
77 
78         delete queue[first];
79         first += 1;
80     }
81 
82     /// @dev Returns the head of the queue without a pop
83     function peek() internal view returns (address data) {
84         require(last >= first);
85         // non-empty queue
86 
87         data = queue[first];
88     }
89 }
90 
91 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     if (a == 0) {
104       return 0;
105     }
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return a / b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148 
149 
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   constructor() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     require(newOwner != address(0));
175     emit OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
182 
183 /**
184  * @title Whitelist
185  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
186  * @dev This simplifies the implementation of "user permissions".
187  */
188 contract Whitelist is Ownable {
189   mapping(address => bool) public whitelist;
190 
191   event WhitelistedAddressAdded(address addr);
192   event WhitelistedAddressRemoved(address addr);
193 
194   /**
195    * @dev Throws if called by any account that's not whitelisted.
196    */
197   modifier onlyWhitelisted() {
198     require(whitelist[msg.sender]);
199     _;
200   }
201 
202   /**
203    * @dev add an address to the whitelist
204    * @param addr address
205    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
206    */
207   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
208     if (!whitelist[addr]) {
209       whitelist[addr] = true;
210       emit WhitelistedAddressAdded(addr);
211       success = true;
212     }
213   }
214 
215   /**
216    * @dev add addresses to the whitelist
217    * @param addrs addresses
218    * @return true if at least one address was added to the whitelist,
219    * false if all addresses were already in the whitelist
220    */
221   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
222     for (uint256 i = 0; i < addrs.length; i++) {
223       if (addAddressToWhitelist(addrs[i])) {
224         success = true;
225       }
226     }
227   }
228 
229   /**
230    * @dev remove an address from the whitelist
231    * @param addr address
232    * @return true if the address was removed from the whitelist,
233    * false if the address wasn't in the whitelist in the first place
234    */
235   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
236     if (whitelist[addr]) {
237       whitelist[addr] = false;
238       emit WhitelistedAddressRemoved(addr);
239       success = true;
240     }
241   }
242 
243   /**
244    * @dev remove addresses from the whitelist
245    * @param addrs addresses
246    * @return true if at least one address was removed from the whitelist,
247    * false if all addresses weren't in the whitelist in the first place
248    */
249   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
250     for (uint256 i = 0; i < addrs.length; i++) {
251       if (removeAddressFromWhitelist(addrs[i])) {
252         success = true;
253       }
254     }
255   }
256 
257 }
258 
259 // File: contracts/Dice.sol
260 
261 /*
262  * Visit: https://p4rty.io
263  * Discord: https://discord.gg/7y3DHYF
264  * P4RTY DICE
265  * Provably Fair Variable Chance DICE game
266  * Roll Under  2 to 99
267  * Play with ETH and play using previous winnings; withdraw anytime
268  * Upgradable and connects to P4RTY Bankroll
269  */
270 
271 
272 
273 
274 
275 contract Dice is Whitelist, SessionQueue {
276 
277     using SafeMath for uint;
278 
279     /*
280     * checks player profit, bet size and player number is within range
281    */
282     modifier betIsValid(uint _betSize, uint _playerNumber) {
283         bool result = ((((_betSize * (100 - _playerNumber.sub(1))) / (_playerNumber.sub(1)) + _betSize)) * houseEdge / houseEdgeDivisor) - _betSize > maxProfit || _betSize < minBet || _playerNumber < minNumber || _playerNumber > maxNumber;
284         require(!result);
285         _;
286     }
287 
288     /*
289      * checks game is currently active
290     */
291     modifier gameIsActive {
292         require(!gamePaused);
293         _;
294     }
295 
296 
297     /**
298      *
299      * Events
300     */
301 
302     event  onSessionOpen(
303         uint indexed id,
304         uint block,
305         uint futureBlock,
306         address player,
307         uint wager,
308         uint rollUnder,
309         uint profit
310     );
311 
312     event onSessionClose(
313         uint indexed id,
314         uint block,
315         uint futureBlock,
316         uint futureHash,
317         uint seed,
318         address player,
319         uint wager,
320         uint rollUnder,
321         uint dieRoll,
322         uint payout,
323         bool timeout
324     );
325 
326     event onCredit(address player, uint amount);
327     event onWithdraw(address player, uint amount);
328 
329     /**
330      *
331      * Structs
332     */
333 
334     struct Session {
335         uint id;
336         uint block;
337         uint futureBlock;
338         uint futureHash;
339         address player;
340         uint wager;
341         uint dieRoll;
342         uint seed;
343         uint rollUnder;
344         uint profit;
345         uint payout;
346         bool complete;
347         bool timeout;
348 
349     }
350 
351     struct Stats {
352         uint rolls;
353         uint wagered;
354         uint profit;
355         uint wins;
356         uint loss;
357     }
358 
359     /*
360      * game vars
361     */
362     uint constant public maxProfitDivisor = 1000000;
363     uint constant public houseEdgeDivisor = 1000;
364     uint constant public maxNumber = 99;
365     uint constant public minNumber = 2;
366     uint constant public futureDelta = 2;
367     uint internal  sessionProcessingCap = 3;
368     bool public gamePaused;
369     bool public payoutsPaused;
370     uint public houseEdge;
371     uint public maxProfit;
372     uint public maxProfitAsPercentOfHouse;
373     uint maxPendingPayouts;
374     uint public minBet;
375     uint public totalSessions;
376     uint public totalBets;
377     uint public totalWon;
378     uint public totalWagered;
379     uint private seed;
380 
381     /*
382     * player vars
383    */
384 
385     mapping(address => Session) sessions;
386     mapping(address => Stats) stats;
387 
388     mapping(bytes32 => bytes32) playerBetId;
389     mapping(bytes32 => uint) playerBetValue;
390     mapping(bytes32 => uint) playerTempBetValue;
391     mapping(bytes32 => uint) playerDieResult;
392     mapping(bytes32 => uint) playerNumber;
393     mapping(address => uint) playerPendingWithdrawals;
394     mapping(bytes32 => uint) playerProfit;
395     mapping(bytes32 => uint) playerTempReward;
396 
397     //The House
398     Bankroll public bankroll;
399 
400 
401 
402     constructor() public {
403         /* init 990 = 99% (1% houseEdge)*/
404         ownerSetHouseEdge(990);
405         /* init 10,000 = 1%  */
406         ownerSetMaxProfitAsPercentOfHouse(10000);
407         /* init min bet (0.01 ether) */
408         ownerSetMinBet(10000000000000000);
409     }
410 
411     /**
412      *
413      *Update BankRoll address
414      */
415     function updateBankrollAddress(address bankrollAddress) onlyOwner public {
416         bankroll = Bankroll(bankrollAddress);
417         setMaxProfit();
418     }
419 
420     function contractBalance() internal view returns (uint256){
421         return bankroll.netEthereumBalance();
422     }
423 
424     /**
425     *
426     *Play with ETH
427     */
428 
429     function play(uint rollUnder) payable public {
430 
431         //Fund the bankroll; a player wins back profit on a wager (not a credit, just deposit)
432         bankroll.depositBy.value(msg.value)(msg.sender);
433 
434         //Roll
435         rollDice(rollUnder, msg.value);
436     }
437 
438 
439     /**
440     *
441     *Play with balance
442     */
443 
444     function playWithVault(uint rollUnder, uint wager) public {
445         //A player can play with a previous win which is store in their vault first
446         require(bankroll.balanceOf(msg.sender) >= wager);
447 
448         //Reduce credit
449         bankroll.debit(msg.sender, wager);
450 
451         //Roll
452         rollDice(rollUnder, wager);
453     }
454 
455 
456     /*
457     * private
458     * player submit bet
459     * only if game is active & bet is valid
460    */
461     function rollDice(uint rollUnder, uint wager) internal gameIsActive betIsValid(wager, rollUnder)
462     {
463 
464         //Complete previous sessions
465         processSessions();
466 
467         Session memory session = sessions[msg.sender];
468 
469         //Strictly cannot wager twice in the same block
470         require(block.number != session.block, "Only one roll can be played at a time");
471 
472         // If there exists a roll, it must be completed
473         if (session.block != 0 && !session.complete) {
474             require(completeSession(msg.sender), "Only one roll can be played at a time");
475         }
476 
477         //Increment Sessions
478         totalSessions += 1;
479 
480         //Invalidate passive session components so it is processed
481         session.complete = false;
482         session.timeout = false;
483         session.payout = 0;
484 
485         session.block = block.number;
486         session.futureBlock = block.number + futureDelta;
487         session.player = msg.sender;
488         session.rollUnder = rollUnder;
489         session.wager = wager;
490 
491         session.profit = profit(rollUnder, wager);
492 
493         session.id = generateSessionId(session);
494 
495         //Save new session
496         sessions[msg.sender] = session;
497 
498         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
499         maxPendingPayouts = maxPendingPayouts.add(session.profit);
500 
501         /* check contract can payout on win
502 
503         */
504         require(maxPendingPayouts < contractBalance(), "Reached maximum wagers supported");
505 
506         /* total number of bets */
507         totalBets += 1;
508 
509         /* total wagered */
510         totalWagered += session.wager;
511 
512 
513         /* Queue session, can be processed by another player */
514         queueSession(session);
515 
516         /* Stats */
517         stats[session.player].rolls += 1;
518         stats[session.player].wagered += session.wager;
519 
520         /* provides accurate numbers for listeners */
521         emit  onSessionOpen(session.id, session.block, session.futureBlock, session.player, session.wager, session.rollUnder, session.profit);
522     }
523 
524     /// @dev Queue up dice session so that it can be processed by others
525     function queueSession(Session session) internal {
526         enqueue(session.player);
527 
528     }
529 
530     /// @dev Process sessions in bulk
531     function processSessions() internal {
532         uint256 count = 0;
533         address session;
534 
535         while (available() && count < sessionProcessingCap) {
536 
537             //If the session isn't able to be completed because of the block none added later will be
538             session = peek();
539 
540             if (sessions[session].complete || completeSession(session)) {
541                 dequeue();
542                 count++;
543             } else {
544                 break;
545             }
546         }
547     }
548 
549 
550     /*
551         @dev Proceses the session if possible by the given player
552     */
553     function closeSession() public {
554 
555         Session memory session = sessions[msg.sender];
556 
557         // If there exists a roll, it must be completed
558         if (session.block != 0 && !session.complete) {
559             require(completeSession(msg.sender), "Only one roll can be played at a time");
560         }
561     }
562 
563 
564 
565 
566     /**
567     *
568     * Random num
569     */
570     function random(Session session) private returns (uint256, uint256, uint256){
571         uint blockHash = uint256(blockhash(session.futureBlock));
572         seed = uint256(keccak256(abi.encodePacked(seed, blockHash, session.id)));
573         return (seed, blockHash, seed % maxNumber);
574     }
575 
576     function profit(uint rollUnder, uint wager) public view returns (uint) {
577 
578         return ((((wager * (100 - (rollUnder.sub(1)))) / (rollUnder.sub(1)) + wager)) * houseEdge / houseEdgeDivisor) - wager;
579     }
580 
581     /**
582     *
583     *Generates a unique sessionId and adds entropy to the overall random calc
584     */
585     function generateSessionId(Session session) private view returns (uint256) {
586         return uint256(keccak256(abi.encodePacked(seed, blockhash(block.number - 1), totalSessions, session.player, session.wager, session.rollUnder, session.profit)));
587     }
588 
589 
590     /*
591      * Process roll
592      */
593     function completeSession(address _customer) private returns (bool)
594     {
595 
596         Session memory session = sessions[_customer];
597 
598 
599         //A future block is not available until one after
600         if (!(block.number > session.futureBlock)) {
601             return false;
602         }
603 
604 
605         //If player does not claim it is a forefeit
606         //The roll is automatically 100 which is invalid
607         if (block.number - session.futureBlock > 256) {
608             session.timeout = true;
609             session.dieRoll = 100;
610         } else {
611             (session.seed, session.futureHash, session.dieRoll) = random(session);
612             session.timeout = false;
613         }
614 
615         //Decrement maxPendingPayouts
616         maxPendingPayouts = maxPendingPayouts.sub(session.profit);
617 
618 
619         /*
620         * pay winner
621         * update contract balance to calculate new max bet
622         * send reward
623         * if send of reward fails save value to playerPendingWithdrawals
624         */
625         if (session.dieRoll < session.rollUnder) {
626 
627             /* update total wei won */
628             totalWon = totalWon.add(session.profit);
629 
630             /* safely calculate payout via profit plus original wager */
631             session.payout = session.profit.add(session.wager);
632 
633             /* Stats */
634             stats[session.player].profit += session.profit;
635             stats[session.player].wins += 1;
636 
637 
638             /*
639             * Award Player
640             */
641 
642             bankroll.credit(session.player, session.payout);
643 
644         }
645 
646         /*
647         * no win
648         * update contract balance to calculate new max bet
649         * session.dieRoll >= session.rollUnder || session.timeout (but basically anything not winning
650         */
651         else {
652 
653             /*
654             * ON LOSS
655             * No need to debit the player; wager is paid to contract, not as a credit
656             * Instruct bankroll to distribute profit to the house in realtime
657             */
658 
659             bankroll.houseProfit(session.wager);
660 
661             /* Stats */
662             stats[session.player].loss += 1;
663 
664         }
665 
666         /* update maximum profit */
667         setMaxProfit();
668 
669         //Close the session
670         closeSession(session);
671 
672         return true;
673 
674     }
675 
676     /// @dev Closes a session and fires event for audit
677     function closeSession(Session session) internal {
678 
679         session.complete = true;
680 
681         //Save the last session info
682         sessions[session.player] = session;
683         emit onSessionClose(session.id, session.block, session.futureBlock, session.futureHash, session.seed, session.player, session.wager, session.rollUnder, session.dieRoll, session.payout, session.timeout);
684 
685     }
686 
687     /// @dev Returns true if there is an active session
688 
689     function isMining() public view returns (bool) {
690         Session memory session = sessions[msg.sender];
691 
692         //A future block is not available until one after
693         return session.block != 0 && !session.complete && block.number <= session.futureBlock;
694     }
695 
696     /*
697     * public function
698     * Withdraw funds for current player
699     */
700     function withdraw() public
701     {
702 
703         //OK to fail if a roll is happening; save gas
704         closeSession();
705         bankroll.withdraw(msg.sender);
706     }
707 
708     /*
709     * Return the balance of a given player
710     *
711     */
712     function balanceOf(address player) public view returns (uint) {
713         return bankroll.balanceOf(player);
714     }
715 
716     /// @dev Stats of any single address
717     function statsOf(address player) public view returns (uint256[5]){
718         Stats memory s = stats[player];
719         uint256[5] memory statArray = [s.rolls, s.wagered, s.profit, s.wins, s.loss];
720         return statArray;
721     }
722 
723     /// @dev Returns the last roll of a complete session for an address
724     function lastSession(address player) public view returns (address, uint[7], bytes32[3], bool[2]) {
725         Session memory s = sessions[player];
726         return (s.player, [s.block, s.futureBlock, s.wager, s.dieRoll, s.rollUnder, s.profit, s.payout], [bytes32(s.id), bytes32(s.futureHash), bytes32(s.seed)], [s.complete, s.timeout]);
727     }
728 
729     /*
730     * internal function
731     * sets max profit
732     */
733     function setMaxProfit() internal {
734         if (address(bankroll) != address(0)) {
735             maxProfit = (contractBalance() * maxProfitAsPercentOfHouse) / maxProfitDivisor;
736         }
737     }
738 
739 
740     /* only owner address can set houseEdge */
741     function ownerSetHouseEdge(uint newHouseEdge) public
742     onlyOwner
743     {
744         houseEdge = newHouseEdge;
745     }
746 
747     /* only owner address can set maxProfitAsPercentOfHouse */
748     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
749     onlyOwner
750     {
751         /* restrict each bet to a maximum profit of 1% contractBalance */
752         require(newMaxProfitAsPercent <= 10000, "Maximum bet exceeded");
753         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
754         setMaxProfit();
755     }
756 
757     /* only owner address can set minBet */
758     function ownerSetMinBet(uint newMinimumBet) public
759     onlyOwner
760     {
761         minBet = newMinimumBet;
762     }
763 
764     /// @dev Set the maximum amount of sessions to be processed
765     function ownerSetProcessingCap(uint cap) public onlyOwner {
766         sessionProcessingCap = cap;
767     }
768 
769     /* only owner address can set emergency pause #1 */
770     function ownerPauseGame(bool newStatus) public
771     onlyOwner
772     {
773         gamePaused = newStatus;
774     }
775 
776 }