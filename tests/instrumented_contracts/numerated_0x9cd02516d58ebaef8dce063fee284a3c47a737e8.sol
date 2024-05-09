1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 /**
93  * @title Claimable
94  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
95  * This allows the new owner to accept the transfer.
96  */
97 contract Claimable is Ownable {
98   address public pendingOwner;
99 
100   /**
101    * @dev Modifier throws if called by any account other than the pendingOwner.
102    */
103   modifier onlyPendingOwner() {
104     require(msg.sender == pendingOwner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to set the pendingOwner address.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) onlyOwner public {
113     pendingOwner = newOwner;
114   }
115 
116   /**
117    * @dev Allows the pendingOwner address to finalize the transfer.
118    */
119   function claimOwnership() onlyPendingOwner public {
120     OwnershipTransferred(owner, pendingOwner);
121     owner = pendingOwner;
122     pendingOwner = address(0);
123   }
124 }
125 
126 
127 /**
128  * @title Pausable
129  * @dev Base contract which allows children to implement an emergency stop mechanism.
130  */
131 contract Pausable is Ownable {
132   event Pause();
133   event Unpause();
134 
135   bool public paused = false;
136 
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is not paused.
140    */
141   modifier whenNotPaused() {
142     require(!paused);
143     _;
144   }
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is paused.
148    */
149   modifier whenPaused() {
150     require(paused);
151     _;
152   }
153 
154   /**
155    * @dev called by the owner to pause, triggers stopped state
156    */
157   function pause() onlyOwner whenNotPaused public {
158     paused = true;
159     Pause();
160   }
161 
162   /**
163    * @dev called by the owner to unpause, returns to normal state
164    */
165   function unpause() onlyOwner whenPaused public {
166     paused = false;
167     Unpause();
168   }
169 }
170 
171 
172 /**
173  * @title ERC20Basic
174  * @dev Simpler version of ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/179
176  */
177 contract ERC20Basic {
178   function totalSupply() public view returns (uint256);
179   function balanceOf(address who) public view returns (uint256);
180   function transfer(address to, uint256 value) public returns (bool);
181   event Transfer(address indexed from, address indexed to, uint256 value);
182 }
183 
184 
185 /**
186  * @title ERC20 interface
187  * @dev see https://github.com/ethereum/EIPs/issues/20
188  */
189 contract ERC20 is ERC20Basic {
190   function allowance(address owner, address spender) public view returns (uint256);
191   function transferFrom(address from, address to, uint256 value) public returns (bool);
192   function approve(address spender, uint256 value) public returns (bool);
193   event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 
197 /**
198  * @title SafeERC20
199  * @dev Wrappers around ERC20 operations that throw on failure.
200  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
201  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
202  */
203 library SafeERC20 {
204   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
205     assert(token.transfer(to, value));
206   }
207 
208   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
209     assert(token.transferFrom(from, to, value));
210   }
211 
212   function safeApprove(ERC20 token, address spender, uint256 value) internal {
213     assert(token.approve(spender, value));
214   }
215 }
216 
217 
218 /**
219  * @title Contracts that should be able to recover tokens
220  * @author SylTi
221  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
222  * This will prevent any accidental loss of tokens.
223  */
224 contract CanReclaimToken is Ownable {
225   using SafeERC20 for ERC20Basic;
226 
227   /**
228    * @dev Reclaim all ERC20Basic compatible tokens
229    * @param token ERC20Basic The address of the token contract
230    */
231   function reclaimToken(ERC20Basic token) external onlyOwner {
232     uint256 balance = token.balanceOf(this);
233     token.safeTransfer(owner, balance);
234   }
235 
236 }
237 
238 
239 /// @dev Implements access control to the Chronos contract.
240 contract ChronosAccessControl is Claimable, Pausable, CanReclaimToken {
241     address public cfoAddress;
242     
243     function ChronosAccessControl() public {
244         // The creator of the contract is the initial CFO.
245         cfoAddress = msg.sender;
246     }
247     
248     /// @dev Access modifier for CFO-only functionality.
249     modifier onlyCFO() {
250         require(msg.sender == cfoAddress);
251         _;
252     }
253 
254     /// @dev Assigns a new address to act as the CFO. Only available to the current contract owner.
255     /// @param _newCFO The address of the new CFO.
256     function setCFO(address _newCFO) external onlyOwner {
257         require(_newCFO != address(0));
258 
259         cfoAddress = _newCFO;
260     }
261 }
262 
263 
264 /// @dev Defines base data structures for Chronos.
265 contract ChronosBase is ChronosAccessControl {
266     using SafeMath for uint256;
267     
268     /// @notice Time windows in seconds from the start of the week
269     /// when new games can be started.
270     uint256[] public activeTimesFrom;
271     uint256[] public activeTimesTo;
272     
273     /// @notice Whether the game can start once outside of active times.
274     bool public allowStart;
275     
276     /// @notice Boolean indicating whether a game is live.
277     bool public gameStarted;
278     
279     /// @notice The last player to have entered.
280     address public lastPlayer;
281     
282     /// @notice The timestamp the last wager times out.
283     uint256 public lastWagerTimeoutTimestamp;
284 
285     /// @notice The number of seconds before the game ends.
286     uint256 public timeout;
287     
288     /// @notice The number of seconds before the game ends -- setting
289     /// for the next game.
290     uint256 public nextTimeout;
291     
292     /// @notice The final number of seconds before the game ends.
293     uint256 public finalTimeout;
294     
295     /// @notice The final number of seconds before the game ends --
296     /// setting for the next game.
297     uint256 public nextFinalTimeout;
298     
299     /// @notice The number of wagers required to move to the
300     /// final timeout.
301     uint256 public numberOfWagersToFinalTimeout;
302     
303     /// @notice The number of wagers required to move to the
304     /// final timeout -- setting for the next game.
305     uint256 public nextNumberOfWagersToFinalTimeout;
306     
307     /// @notice The index of the current game.
308     uint256 public gameIndex = 0;
309     
310     /// @notice The index of the the current wager in the game.
311     uint256 public wagerIndex = 0;
312     
313     /// @notice Every nth wager receives 2x their wager.
314     uint256 public nthWagerPrizeN = 3;
315     
316     /// @notice A boolean indicating whether a new game can start,
317     /// based on the active times.
318     function canStart() public view returns (bool) {
319         // Get the time of the week in seconds.
320         // There are 7 * 24 * 60 * 60 = 604800 seconds in a week,
321         // and unix timestamps started counting from a Thursday,
322         // so subtract 4 * 24 * 60 * 60 = 345600 seconds, as
323         // (0 - 345600) % 604800 = 259200, i.e. the number of
324         // seconds in a week until Thursday 00:00:00.
325         uint256 timeOfWeek = (block.timestamp - 345600) % 604800;
326         
327         uint256 windows = activeTimesFrom.length;
328         
329         if (windows == 0) {
330             // No start times configured, any time is allowed.
331             return true;
332         }
333         
334         for (uint256 i = 0; i < windows; i++) {
335             if (timeOfWeek >= activeTimesFrom[i] && timeOfWeek <= activeTimesTo[i]) {
336                 return true;
337             }
338         }
339         
340         return false;
341     }
342     
343     /// @notice Calculate the current game's timeout.
344     function calculateTimeout() public view returns(uint256) {
345         if (wagerIndex >= numberOfWagersToFinalTimeout || numberOfWagersToFinalTimeout == 0) {
346             return finalTimeout;
347         } else {
348             if (finalTimeout <= timeout) {
349                 // The timeout decreases over time.
350             
351                 // This cannot underflow, as timeout is guaranteed to be
352                 // greater than or equal to finalTimeout.
353                 uint256 difference = timeout - finalTimeout;
354                 
355                 // Calculate the decrease in timeout, based on the number of wagers performed.
356                 uint256 decrease = difference.mul(wagerIndex).div(numberOfWagersToFinalTimeout);
357                 
358                 // This subtraction cannot underflow, as decrease is guaranteed to be less than or equal to timeout.            
359                 return (timeout - decrease);
360             } else {
361                 // The timeout increases over time.
362             
363                 // This cannot underflow, as timeout is guaranteed to be
364                 // smaller than finalTimeout.
365                 difference = finalTimeout - timeout;
366                 
367                 // Calculate the increase in timeout, based on the number of wagers performed.
368                 uint256 increase = difference.mul(wagerIndex).div(numberOfWagersToFinalTimeout);
369                 
370                 // This addition cannot overflow, as timeout + increase is guaranteed to be less than or equal to finalTimeout.
371                 return (timeout + increase);
372             }
373         }
374     }
375 }
376 
377 
378 /**
379  * @title PullPayment
380  * @dev Base contract supporting async send for pull payments. Inherit from this
381  * contract and use asyncSend instead of send.
382  */
383 contract PullPayment {
384   using SafeMath for uint256;
385 
386   mapping(address => uint256) public payments;
387   uint256 public totalPayments;
388 
389   /**
390   * @dev withdraw accumulated balance, called by payee.
391   */
392   function withdrawPayments() public {
393     address payee = msg.sender;
394     uint256 payment = payments[payee];
395 
396     require(payment != 0);
397     require(this.balance >= payment);
398 
399     totalPayments = totalPayments.sub(payment);
400     payments[payee] = 0;
401 
402     assert(payee.send(payment));
403   }
404 
405   /**
406   * @dev Called by the payer to store the sent amount as credit to be pulled.
407   * @param dest The destination address of the funds.
408   * @param amount The amount to transfer.
409   */
410   function asyncSend(address dest, uint256 amount) internal {
411     payments[dest] = payments[dest].add(amount);
412     totalPayments = totalPayments.add(amount);
413   }
414 }
415 
416 
417 /// @dev Defines base finance functionality for Chronos.
418 contract ChronosFinance is ChronosBase, PullPayment {
419     /// @notice The developer fee in 1/1000th of a percentage.
420     uint256 public feePercentage = 2500;
421     
422     /// @notice The percentage of a wager that goes to the next prize pool.
423     uint256 public nextPoolPercentage = 7500;
424     
425     /// @notice The wager price.
426     uint256 public price;
427     
428     /// @notice The wager price -- setting for the next game.
429     uint256 public nextPrice;
430     
431     /// @notice The current prize pool (in wei).
432     uint256 public prizePool;
433     
434     /// @notice The next prize pool (in wei).
435     uint256 public nextPrizePool;
436     
437     /// @notice The current nth wager pool (in wei).
438     uint256 public wagerPool;
439     
440     /// @notice Sets a new fee percentage.
441     /// @param _feePercentage The new fee percentage.
442     function setFeePercentage(uint256 _feePercentage) external onlyCFO {
443         // Fee percentage must be 4% at the most.
444         require(_feePercentage <= 4000);
445         
446         feePercentage = _feePercentage;
447     }
448     
449     /// @notice Sets a new next pool percentage.
450     /// @param _nextPoolPercentage The new next pool percentage.
451     function setNextPoolPercentage(uint256 _nextPoolPercentage) external onlyCFO {
452         nextPoolPercentage = _nextPoolPercentage;
453     }
454     
455     /// @dev Send funds to a beneficiary. If sending fails, assign
456     /// funds to the beneficiary's balance for manual withdrawal.
457     /// @param beneficiary The beneficiary's address to send funds to
458     /// @param amount The amount to send.
459     function _sendFunds(address beneficiary, uint256 amount) internal {
460         if (!beneficiary.send(amount)) {
461             // Failed to send funds. This can happen due to a failure in
462             // fallback code of the beneficiary, or because of callstack
463             // depth.
464             // Send funds asynchronously for manual withdrawal by the
465             // beneficiary.
466             asyncSend(beneficiary, amount);
467         }
468     }
469     
470     /// @notice Withdraw (unowed) contract balance.
471     function withdrawFreeBalance() external onlyCFO {
472         // Calculate the free (unowed) balance.
473         uint256 freeBalance = this.balance.sub(totalPayments).sub(prizePool).sub(wagerPool);
474         
475         cfoAddress.transfer(freeBalance);
476     }
477 }
478 
479 
480 /// @dev Defines core Chronos functionality.
481 contract ChronosCore is ChronosFinance {
482     
483     function ChronosCore(uint256 _price, uint256 _timeout, uint256 _finalTimeout, uint256 _numberOfWagersToFinalTimeout) public {
484         nextPrice = _price;
485         nextTimeout = _timeout;
486         nextFinalTimeout = _finalTimeout;
487         nextNumberOfWagersToFinalTimeout = _numberOfWagersToFinalTimeout;
488         NextGame(nextPrice, nextTimeout, nextFinalTimeout, nextNumberOfWagersToFinalTimeout);
489     }
490     
491     event ActiveTimes(uint256[] from, uint256[] to);
492     event AllowStart(bool allowStart);
493     event NextGame(uint256 price, uint256 timeout, uint256 finalTimeout, uint256 numberOfWagersToFinalTimeout);
494     event Start(uint256 indexed gameIndex, address indexed starter, uint256 timestamp, uint256 price, uint256 timeout, uint256 finalTimeout, uint256 numberOfWagersToFinalTimeout);
495     event End(uint256 indexed gameIndex, uint256 wagerIndex, address indexed winner, uint256 timestamp, uint256 prize, uint256 nextPrizePool);
496     event Play(uint256 indexed gameIndex, uint256 indexed wagerIndex, address indexed player, uint256 timestamp, uint256 timeoutTimestamp, uint256 newPrizePool, uint256 nextPrizePool);
497     event SpiceUpPrizePool(uint256 indexed gameIndex, address indexed spicer, uint256 spiceAdded, string message, uint256 newPrizePool);
498     
499     /// @notice Participate in the game.
500     /// @param _gameIndex The index of the game to play on.
501     /// @param startNewGameIfIdle Start a new game if the current game is idle.
502     function play(uint256 _gameIndex, bool startNewGameIfIdle) external payable {
503         // Check to see if the game should end. Process payment.
504         _processGameEnd();
505         
506         if (!gameStarted) {
507             // If the game is not started, the contract must not be paused.
508             require(!paused);
509             
510             if (allowStart) {
511                 // We're allowed to start once outside of active times.
512                 allowStart = false;
513             } else {
514                 // This must be an active time.
515                 require(canStart());
516             }
517             
518             // If the game is not started, the player must be willing to start
519             // a new game.
520             require(startNewGameIfIdle);
521             
522             // Set the price and timeout.
523             price = nextPrice;
524             timeout = nextTimeout;
525             finalTimeout = nextFinalTimeout;
526             numberOfWagersToFinalTimeout = nextNumberOfWagersToFinalTimeout;
527             
528             // Start the game.
529             gameStarted = true;
530             
531             // Emit start event.
532             Start(gameIndex, msg.sender, block.timestamp, price, timeout, finalTimeout, numberOfWagersToFinalTimeout);
533         }
534         
535         // Check the game index.
536         if (startNewGameIfIdle) {
537             // The given game index must be the current game index, or the previous
538             // game index.
539             require(_gameIndex == gameIndex || _gameIndex.add(1) == gameIndex);
540         } else {
541             // Only play on the game indicated by the player.
542             require(_gameIndex == gameIndex);
543         }
544         
545         // Enough Ether must be supplied.
546         require(msg.value >= price);
547         
548         // Calculate the fees and next pool percentage.
549         uint256 fee = price.mul(feePercentage).div(100000);
550         uint256 nextPool = price.mul(nextPoolPercentage).div(100000);
551         uint256 wagerPoolPart;
552         
553         if (wagerIndex % nthWagerPrizeN == nthWagerPrizeN - 1) {
554             // Give the wager prize every nth wager.
555             
556             // Calculate total nth wager prize.
557             uint256 wagerPrize = price.mul(2);
558             
559             // Calculate the missing wager pool part (equal to price.mul(2).div(nthWagerPrizeN) plus a few wei).
560             wagerPoolPart = wagerPrize.sub(wagerPool);
561         
562             // Give the wager prize to the sender.
563             msg.sender.transfer(wagerPrize);
564             
565             // Reset the wager pool.
566             wagerPool = 0;
567         } else {
568             // On every non-nth wager, increase the wager pool.
569             
570             // Calculate the wager pool part.
571             wagerPoolPart = price.mul(2).div(nthWagerPrizeN);
572             
573             // Add funds to the wager pool.
574             wagerPool = wagerPool.add(wagerPoolPart);
575         }
576         
577         // Calculate the timeout.
578         uint256 currentTimeout = calculateTimeout();
579         
580         // Set the last player, timestamp, timeout timestamp, and increase prize.
581         lastPlayer = msg.sender;
582         lastWagerTimeoutTimestamp = block.timestamp + currentTimeout;
583         prizePool = prizePool.add(price.sub(fee).sub(nextPool).sub(wagerPoolPart));
584         nextPrizePool = nextPrizePool.add(nextPool);
585         
586         // Emit event.
587         Play(gameIndex, wagerIndex, msg.sender, block.timestamp, lastWagerTimeoutTimestamp, prizePool, nextPrizePool);
588         
589         // Increment the wager index. This won't overflow before the heat death of the universe.
590         wagerIndex++;
591         
592         // Refund any excess Ether sent.
593         // This subtraction never underflows, as msg.value is guaranteed
594         // to be greater than or equal to price.
595         uint256 excess = msg.value - price;
596         
597         if (excess > 0) {
598             msg.sender.transfer(excess);
599         }
600     }
601     
602     /// @notice Spice up the prize pool.
603     /// @param _gameIndex The index of the game to add spice to.
604     /// @param message An optional message to be sent along with the spice.
605     function spiceUp(uint256 _gameIndex, string message) external payable {
606         // Check to see if the game should end. Process payment.
607         _processGameEnd();
608         
609         // Check the game index.
610         require(_gameIndex == gameIndex);
611     
612         // Game must be live or unpaused.
613         require(gameStarted || !paused);
614         
615         // Funds must be sent.
616         require(msg.value > 0);
617         
618         // Add funds to the prize pool.
619         prizePool = prizePool.add(msg.value);
620         
621         // Emit event.
622         SpiceUpPrizePool(gameIndex, msg.sender, msg.value, message, prizePool);
623     }
624     
625     /// @notice Set the parameters for the next game.
626     /// @param _price The price of wagers for the next game.
627     /// @param _timeout The timeout in seconds for the next game.
628     /// @param _finalTimeout The final timeout in seconds for
629     /// the next game.
630     /// @param _numberOfWagersToFinalTimeout The number of wagers
631     /// required to move to the final timeout for the next game.
632     function setNextGame(uint256 _price, uint256 _timeout, uint256 _finalTimeout, uint256 _numberOfWagersToFinalTimeout) external onlyCFO {
633         nextPrice = _price;
634         nextTimeout = _timeout;
635         nextFinalTimeout = _finalTimeout;
636         nextNumberOfWagersToFinalTimeout = _numberOfWagersToFinalTimeout;
637         NextGame(nextPrice, nextTimeout, nextFinalTimeout, nextNumberOfWagersToFinalTimeout);
638     } 
639     
640     /// @notice End the game. Pay prize.
641     function endGame() external {
642         require(_processGameEnd());
643     }
644     
645     /// @dev End the game. Pay prize.
646     function _processGameEnd() internal returns(bool) {
647         if (!gameStarted) {
648             // No game is started.
649             return false;
650         }
651     
652         if (block.timestamp <= lastWagerTimeoutTimestamp) {
653             // The game has not yet finished.
654             return false;
655         }
656         
657         // Calculate the prize. Any leftover funds for the
658         // nth wager prize is added to the prize pool.
659         uint256 prize = prizePool.add(wagerPool);
660         
661         // The game has finished. Pay the prize to the last player.
662         _sendFunds(lastPlayer, prize);
663         
664         // Emit event.
665         End(gameIndex, wagerIndex, lastPlayer, lastWagerTimeoutTimestamp, prize, nextPrizePool);
666         
667         // Reset the game.
668         gameStarted = false;
669         lastPlayer = 0x0;
670         lastWagerTimeoutTimestamp = 0;
671         wagerIndex = 0;
672         wagerPool = 0;
673         
674         // The next pool is any leftover balance minus outstanding balances.
675         prizePool = nextPrizePool;
676         nextPrizePool = 0;
677         
678         // Increment the game index. This won't overflow before the heat death of the universe.
679         gameIndex++;
680         
681         // Indicate ending the game was successful.
682         return true;
683     }
684     
685     /// @notice Set the active times.
686     function setActiveTimes(uint256[] _from, uint256[] _to) external onlyCFO {
687         require(_from.length == _to.length);
688     
689         activeTimesFrom = _from;
690         activeTimesTo = _to;
691         
692         // Emit event.
693         ActiveTimes(_from, _to);
694     }
695     
696     /// @notice Allow the game to start once outside of active times.
697     function setAllowStart(bool _allowStart) external onlyCFO {
698         allowStart = _allowStart;
699         
700         // Emit event.
701         AllowStart(_allowStart);
702     }
703 }