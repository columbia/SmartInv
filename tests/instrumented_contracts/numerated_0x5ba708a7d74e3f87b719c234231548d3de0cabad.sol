1 pragma solidity ^0.4.18;
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
268     /// @notice Boolean indicating whether a game is live.
269     bool public gameStarted;
270     
271     /// @notice The player who started the game.
272     address public gameStarter;
273     
274     /// @notice The last player to have entered.
275     address public lastPlayer;
276     
277     /// @notice The timestamp the last wager times out.
278     uint256 public lastWagerTimeoutTimestamp;
279 
280     /// @notice The number of seconds before the game ends.
281     uint256 public timeout;
282     
283     /// @notice The number of seconds before the game ends -- setting
284     /// for the next game.
285     uint256 public nextTimeout;
286     
287     /// @notice The final number of seconds before the game ends.
288     uint256 public finalTimeout;
289     
290     /// @notice The final number of seconds before the game ends --
291     /// setting for the next game.
292     uint256 public nextFinalTimeout;
293     
294     /// @notice The number of wagers required to move to the
295     /// final timeout.
296     uint256 public numberOfWagersToFinalTimeout;
297     
298     /// @notice The number of wagers required to move to the
299     /// final timeout -- setting for the next game.
300     uint256 public nextNumberOfWagersToFinalTimeout;
301     
302     /// @notice The index of the current game.
303     uint256 public gameIndex = 0;
304     
305     /// @notice The index of the the current wager in the game.
306     uint256 public wagerIndex = 0;
307     
308     /// @notice Calculate the current game's timeout.
309     function calculateTimeout() public view returns(uint256) {
310         if (wagerIndex >= numberOfWagersToFinalTimeout || numberOfWagersToFinalTimeout == 0) {
311             return finalTimeout;
312         } else {
313             if (finalTimeout <= timeout) {
314                 // The timeout decreases over time.
315             
316                 // This cannot underflow, as timeout is guaranteed to be
317                 // greater than or equal to finalTimeout.
318                 uint256 difference = timeout - finalTimeout;
319                 
320                 // Calculate the decrease in timeout, based on the number of wagers performed.
321                 uint256 decrease = difference.mul(wagerIndex).div(numberOfWagersToFinalTimeout);
322                 
323                 // This subtraction cannot underflow, as decrease is guaranteed to be less than or equal to timeout.            
324                 return (timeout - decrease);
325             } else {
326                 // The timeout increases over time.
327             
328                 // This cannot underflow, as timeout is guaranteed to be
329                 // smaller than finalTimeout.
330                 difference = finalTimeout - timeout;
331                 
332                 // Calculate the increase in timeout, based on the number of wagers performed.
333                 uint256 increase = difference.mul(wagerIndex).div(numberOfWagersToFinalTimeout);
334                 
335                 // This addition cannot overflow, as timeout + increase is guaranteed to be less than or equal to finalTimeout.
336                 return (timeout + increase);
337             }
338         }
339     }
340 }
341 
342 
343 /**
344  * @title PullPayment
345  * @dev Base contract supporting async send for pull payments. Inherit from this
346  * contract and use asyncSend instead of send.
347  */
348 contract PullPayment {
349   using SafeMath for uint256;
350 
351   mapping(address => uint256) public payments;
352   uint256 public totalPayments;
353 
354   /**
355   * @dev withdraw accumulated balance, called by payee.
356   */
357   function withdrawPayments() public {
358     address payee = msg.sender;
359     uint256 payment = payments[payee];
360 
361     require(payment != 0);
362     require(this.balance >= payment);
363 
364     totalPayments = totalPayments.sub(payment);
365     payments[payee] = 0;
366 
367     assert(payee.send(payment));
368   }
369 
370   /**
371   * @dev Called by the payer to store the sent amount as credit to be pulled.
372   * @param dest The destination address of the funds.
373   * @param amount The amount to transfer.
374   */
375   function asyncSend(address dest, uint256 amount) internal {
376     payments[dest] = payments[dest].add(amount);
377     totalPayments = totalPayments.add(amount);
378   }
379 }
380 
381 
382 /// @dev Defines base finance functionality for Chronos.
383 contract ChronosFinance is ChronosBase, PullPayment {
384     /// @notice The developer fee in 1/1000th of a percentage.
385     uint256 public feePercentage = 2500;
386     
387     /// @notice The game starter fee.
388     uint256 public gameStarterDividendPercentage = 2500;
389     
390     /// @notice The wager price.
391     uint256 public price;
392     
393     /// @notice The wager price -- setting for the next game.
394     uint256 public nextPrice;
395     
396     /// @notice The current prize pool (in wei).
397     uint256 public prizePool;
398     
399     /// @notice The current 7th wager pool (in wei).
400     uint256 public wagerPool;
401     
402     /// @notice Sets a new fee percentage.
403     /// @param _feePercentage The new fee percentage.
404     function setFeePercentage(uint256 _feePercentage) external onlyCFO {
405         // Fee percentage must be 4% at the most.
406         require(_feePercentage <= 4000);
407         
408         feePercentage = _feePercentage;
409     }
410     
411     /// @notice Sets a new game starter dividend percentage.
412     /// @param _gameStarterDividendPercentage The new game starter dividend percentage.
413     function setGameStarterDividendPercentage(uint256 _gameStarterDividendPercentage) external onlyCFO {
414         // Game starter dividend percentage must be 0.5% at least and 5% at the most.
415         require(500 <= _gameStarterDividendPercentage && _gameStarterDividendPercentage <= 5000);
416         
417         gameStarterDividendPercentage = _gameStarterDividendPercentage;
418     }
419     
420     /// @dev Send funds to a beneficiary. If sending fails, assign
421     /// funds to the beneficiary's balance for manual withdrawal.
422     /// @param beneficiary The beneficiary's address to send funds to
423     /// @param amount The amount to send.
424     function _sendFunds(address beneficiary, uint256 amount) internal {
425         if (!beneficiary.send(amount)) {
426             // Failed to send funds. This can happen due to a failure in
427             // fallback code of the beneficiary, or because of callstack
428             // depth.
429             // Send funds asynchronously for manual withdrawal by the
430             // beneficiary.
431             asyncSend(beneficiary, amount);
432         }
433     }
434     
435     /// @notice Withdraw (unowed) contract balance.
436     function withdrawFreeBalance() external onlyCFO {
437         // Calculate the free (unowed) balance.
438         uint256 freeBalance = this.balance.sub(totalPayments).sub(prizePool).sub(wagerPool);
439         
440         cfoAddress.transfer(freeBalance);
441     }
442 }
443 
444 
445 /// @dev Defines core Chronos functionality.
446 contract ChronosCore is ChronosFinance {
447     
448     function ChronosCore(uint256 _price, uint256 _timeout, uint256 _finalTimeout, uint256 _numberOfWagersToFinalTimeout) public {
449         nextPrice = _price;
450         nextTimeout = _timeout;
451         nextFinalTimeout = _finalTimeout;
452         nextNumberOfWagersToFinalTimeout = _numberOfWagersToFinalTimeout;
453         NextGame(nextPrice, nextTimeout, nextFinalTimeout, nextNumberOfWagersToFinalTimeout);
454     }
455     
456     event NextGame(uint256 price, uint256 timeout, uint256 finalTimeout, uint256 numberOfWagersToFinalTimeout);
457     event Start(uint256 indexed gameIndex, address indexed starter, uint256 timestamp, uint256 price, uint256 timeout, uint256 finalTimeout, uint256 numberOfWagersToFinalTimeout);
458     event End(uint256 indexed gameIndex, uint256 wagerIndex, address indexed winner, uint256 timestamp, uint256 prize);
459     event Play(uint256 indexed gameIndex, uint256 indexed wagerIndex, address indexed player, uint256 timestamp, uint256 timeoutTimestamp, uint256 newPrizePool);
460     event SpiceUpPrizePool(uint256 indexed gameIndex, address indexed spicer, uint256 spiceAdded, string message, uint256 newPrizePool);
461     
462     /// @notice Participate in the game.
463     /// @param _gameIndex The index of the game to play on.
464     /// @param startNewGameIfIdle Start a new game if the current game is idle.
465     function play(uint256 _gameIndex, bool startNewGameIfIdle) external payable {
466         // Check to see if the game should end. Process payment.
467         _processGameEnd();
468         
469         if (!gameStarted) {
470             // If the game is not started, the contract must not be paused.
471             require(!paused);
472             
473             // If the game is not started, the player must be willing to start
474             // a new game.
475             require(startNewGameIfIdle);
476             
477             // Set the price and timeout.
478             price = nextPrice;
479             timeout = nextTimeout;
480             finalTimeout = nextFinalTimeout;
481             numberOfWagersToFinalTimeout = nextNumberOfWagersToFinalTimeout;
482             
483             // Start the game.
484             gameStarted = true;
485             
486             // Set the game starter.
487             gameStarter = msg.sender;
488             
489             // Emit start event.
490             Start(gameIndex, msg.sender, block.timestamp, price, timeout, finalTimeout, numberOfWagersToFinalTimeout);
491         }
492         
493         // Check the game index.
494         if (startNewGameIfIdle) {
495             // The given game index must be the current game index, or the previous
496             // game index.
497             require(_gameIndex == gameIndex || _gameIndex.add(1) == gameIndex);
498         } else {
499             // Only play on the game indicated by the player.
500             require(_gameIndex == gameIndex);
501         }
502         
503         // Enough Ether must be supplied.
504         require(msg.value >= price);
505         
506         // Calculate the fees and dividends.
507         uint256 fee = price.mul(feePercentage).div(100000);
508         uint256 dividend = price.mul(gameStarterDividendPercentage).div(100000);
509         uint256 wagerPoolPart;
510         
511         if (wagerIndex % 7 == 6) {
512             // Give the wager prize every 7th wager.
513             
514             // Calculate total 7th wager prize.
515             uint256 wagerPrize = price.mul(2);
516             
517             // Calculate the missing wager pool part (equal to price.mul(2).div(7) plus a few wei).
518             wagerPoolPart = wagerPrize.sub(wagerPool);
519         
520             // Give the wager prize to the sender.
521             msg.sender.transfer(wagerPrize);
522             
523             // Reset the wager pool.
524             wagerPool = 0;
525         } else {
526             // On every non-7th wager, increase the wager pool.
527             
528             // Calculate the wager pool part.
529             wagerPoolPart = price.mul(2).div(7);
530             
531             // Add funds to the wager pool.
532             wagerPool = wagerPool.add(wagerPoolPart);
533         }
534         
535         // Calculate the timeout.
536         uint256 currentTimeout = calculateTimeout();
537         
538         // Set the last player, timestamp, timeout timestamp, and increase prize.
539         lastPlayer = msg.sender;
540         lastWagerTimeoutTimestamp = block.timestamp + currentTimeout;
541         prizePool = prizePool.add(price.sub(fee).sub(dividend).sub(wagerPoolPart));
542         
543         // Emit event.
544         Play(gameIndex, wagerIndex, msg.sender, block.timestamp, lastWagerTimeoutTimestamp, prizePool);
545         
546         // Send the game starter dividend.
547         _sendFunds(gameStarter, dividend);
548         
549         // Increment the wager index. This won't overflow before the heat death of the universe.
550         wagerIndex++;
551         
552         // Refund any excess Ether sent.
553         // This subtraction never underflows, as msg.value is guaranteed
554         // to be greater than or equal to price.
555         uint256 excess = msg.value - price;
556         
557         if (excess > 0) {
558             msg.sender.transfer(excess);
559         }
560     }
561     
562     /// @notice Spice up the prize pool.
563     /// @param _gameIndex The index of the game to add spice to.
564     /// @param message An optional message to be sent along with the spice.
565     function spiceUp(uint256 _gameIndex, string message) external payable {
566         // Check to see if the game should end. Process payment.
567         _processGameEnd();
568         
569         // Check the game index.
570         require(_gameIndex == gameIndex);
571     
572         // Game must be live or unpaused.
573         require(gameStarted || !paused);
574         
575         // Funds must be sent.
576         require(msg.value > 0);
577         
578         // Add funds to the prize pool.
579         prizePool = prizePool.add(msg.value);
580         
581         // Emit event.
582         SpiceUpPrizePool(gameIndex, msg.sender, msg.value, message, prizePool);
583     }
584     
585     /// @notice Set the parameters for the next game.
586     /// @param _price The price of wagers for the next game.
587     /// @param _timeout The timeout in seconds for the next game.
588     /// @param _finalTimeout The final timeout in seconds for
589     /// the next game.
590     /// @param _numberOfWagersToFinalTimeout The number of wagers
591     /// required to move to the final timeout for the next game.
592     function setNextGame(uint256 _price, uint256 _timeout, uint256 _finalTimeout, uint256 _numberOfWagersToFinalTimeout) external onlyCFO {
593         nextPrice = _price;
594         nextTimeout = _timeout;
595         nextFinalTimeout = _finalTimeout;
596         nextNumberOfWagersToFinalTimeout = _numberOfWagersToFinalTimeout;
597         NextGame(nextPrice, nextTimeout, nextFinalTimeout, nextNumberOfWagersToFinalTimeout);
598     } 
599     
600     /// @notice End the game. Pay prize.
601     function endGame() external {
602         require(_processGameEnd());
603     }
604     
605     /// @dev End the game. Pay prize.
606     function _processGameEnd() internal returns(bool) {
607         if (!gameStarted) {
608             // No game is started.
609             return false;
610         }
611     
612         if (block.timestamp <= lastWagerTimeoutTimestamp) {
613             // The game has not yet finished.
614             return false;
615         }
616         
617         // Calculate the prize. Any leftover funds for the
618         // 7th wager prize is added to the prize pool.
619         uint256 prize = prizePool.add(wagerPool);
620         
621         // The game has finished. Pay the prize to the last player.
622         _sendFunds(lastPlayer, prize);
623         
624         // Emit event.
625         End(gameIndex, wagerIndex, lastPlayer, lastWagerTimeoutTimestamp, prize);
626         
627         // Reset the game.
628         gameStarted = false;
629         gameStarter = 0x0;
630         lastPlayer = 0x0;
631         lastWagerTimeoutTimestamp = 0;
632         wagerIndex = 0;
633         prizePool = 0;
634         wagerPool = 0;
635         
636         // Increment the game index. This won't overflow before the heat death of the universe.
637         gameIndex++;
638         
639         // Indicate ending the game was successful.
640         return true;
641     }
642 }