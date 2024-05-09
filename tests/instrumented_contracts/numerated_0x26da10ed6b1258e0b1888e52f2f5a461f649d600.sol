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
287     /// @notice The minimum number of seconds before the game ends.
288     uint256 public minimumTimeout;
289     
290     /// @notice The minmum number of seconds before the game ends --
291     /// setting for the next game.
292     uint256 public nextMinimumTimeout;
293     
294     /// @notice The number of wagers required to move to the
295     /// minimum timeout.
296     uint256 public numberOfWagersToMinimumTimeout;
297     
298     /// @notice The number of wagers required to move to the
299     /// minimum timeout -- setting for the next game.
300     uint256 public nextNumberOfWagersToMinimumTimeout;
301     
302     /// @notice The wager index of the the current wager in the game.
303     uint256 public wagerIndex = 0;
304     
305     /// @notice Calculate the current game's timeout.
306     function calculateTimeout() public view returns(uint256) {
307         if (wagerIndex >= numberOfWagersToMinimumTimeout || numberOfWagersToMinimumTimeout == 0) {
308             return minimumTimeout;
309         } else {
310             // This cannot underflow, as timeout is guaranteed to be
311             // greater than or equal to minimumTimeout.
312             uint256 difference = timeout - minimumTimeout;
313             
314             // Calculate the decrease in timeout, based on the number of wagers performed.
315             uint256 decrease = difference.mul(wagerIndex).div(numberOfWagersToMinimumTimeout);
316             
317             // This subtraction cannot underflow, as decrease is guaranteed to be less than or equal to timeout.            
318             return (timeout - decrease);
319         }
320     }
321 }
322 
323 
324 /**
325  * @title PullPayment
326  * @dev Base contract supporting async send for pull payments. Inherit from this
327  * contract and use asyncSend instead of send.
328  */
329 contract PullPayment {
330   using SafeMath for uint256;
331 
332   mapping(address => uint256) public payments;
333   uint256 public totalPayments;
334 
335   /**
336   * @dev withdraw accumulated balance, called by payee.
337   */
338   function withdrawPayments() public {
339     address payee = msg.sender;
340     uint256 payment = payments[payee];
341 
342     require(payment != 0);
343     require(this.balance >= payment);
344 
345     totalPayments = totalPayments.sub(payment);
346     payments[payee] = 0;
347 
348     assert(payee.send(payment));
349   }
350 
351   /**
352   * @dev Called by the payer to store the sent amount as credit to be pulled.
353   * @param dest The destination address of the funds.
354   * @param amount The amount to transfer.
355   */
356   function asyncSend(address dest, uint256 amount) internal {
357     payments[dest] = payments[dest].add(amount);
358     totalPayments = totalPayments.add(amount);
359   }
360 }
361 
362 
363 /// @dev Defines base finance functionality for Chronos.
364 contract ChronosFinance is ChronosBase, PullPayment {
365     /// @notice The dev fee in 1/1000th
366     /// of a percentage.
367     uint256 public feePercentage = 2500;
368     
369     /// @notice The game starter fee.
370     uint256 public gameStarterDividendPercentage = 1000;
371     
372     /// @notice The wager price.
373     uint256 public price;
374     
375     /// @notice The wager price -- setting for the next game.
376     uint256 public nextPrice;
377     
378     /// @notice The current prize pool (in wei).
379     uint256 public prizePool;
380     
381     /// @notice The current 7th wager pool (in wei).
382     uint256 public wagerPool;
383     
384     /// @notice Sets a new game starter dividend percentage.
385     /// @param _gameStarterDividendPercentage The new game starter dividend percentage.
386     function setGameStarterDividendPercentage(uint256 _gameStarterDividendPercentage) external onlyCFO {
387         // Game started dividend percentage must be 0.5% at least and 4% at the most.
388         require(500 <= _gameStarterDividendPercentage && _gameStarterDividendPercentage <= 4000);
389         
390         gameStarterDividendPercentage = _gameStarterDividendPercentage;
391     }
392     
393     /// @dev Send funds to a beneficiary. If sending fails, assign
394     /// funds to the beneficiary's balance for manual withdrawal.
395     /// @param beneficiary The beneficiary's address to send funds to
396     /// @param amount The amount to send.
397     function _sendFunds(address beneficiary, uint256 amount) internal {
398         if (!beneficiary.send(amount)) {
399             // Failed to send funds. This can happen due to a failure in
400             // fallback code of the beneficiary, or because of callstack
401             // depth.
402             // Send funds asynchronously for manual withdrawal by the
403             // beneficiary.
404             asyncSend(beneficiary, amount);
405         }
406     }
407     
408     /// @notice Withdraw (unowed) contract balance.
409     function withdrawFreeBalance() external onlyCFO {
410         // Calculate the free (unowed) balance.
411         uint256 freeBalance = this.balance.sub(totalPayments).sub(prizePool).sub(wagerPool);
412         
413         cfoAddress.transfer(freeBalance);
414     }
415 }
416 
417 
418 /// @dev Defines core Chronos functionality.
419 contract ChronosCore is ChronosFinance {
420     
421     function ChronosCore(uint256 _price, uint256 _timeout, uint256 _minimumTimeout, uint256 _numberOfWagersToMinimumTimeout) public {
422         require(_timeout >= _minimumTimeout);
423         
424         nextPrice = _price;
425         nextTimeout = _timeout;
426         nextMinimumTimeout = _minimumTimeout;
427         nextNumberOfWagersToMinimumTimeout = _numberOfWagersToMinimumTimeout;
428         NextGame(nextPrice, nextTimeout, nextMinimumTimeout, nextNumberOfWagersToMinimumTimeout);
429     }
430     
431     event NextGame(uint256 price, uint256 timeout, uint256 minimumTimeout, uint256 numberOfWagersToMinimumTimeout);
432     event Start(address indexed starter, uint256 timestamp, uint256 price, uint256 timeout, uint256 minimumTimeout, uint256 numberOfWagersToMinimumTimeout);
433     event End(address indexed winner, uint256 timestamp, uint256 prize);
434     event Play(address indexed player, uint256 timestamp, uint256 timeoutTimestamp, uint256 wagerIndex, uint256 newPrizePool);
435     event SpiceUpPrizePool(address indexed spicer, uint256 spiceAdded, string message, uint256 newPrizePool);
436     
437     /// @notice Participate in the game.
438     /// @param startNewGameIfIdle Start a new game if the current game is idle.
439     function play(bool startNewGameIfIdle) external payable {
440         // Check to see if the game should end. Process payment.
441         _processGameEnd();
442         
443         if (!gameStarted) {
444             // If the game is not started, the contract must not be paused.
445             require(!paused);
446             
447             // If the game is not started, the player must be willing to start
448             // a new game.
449             require(startNewGameIfIdle);
450             
451             // Set the price and timeout.
452             price = nextPrice;
453             timeout = nextTimeout;
454             minimumTimeout = nextMinimumTimeout;
455             numberOfWagersToMinimumTimeout = nextNumberOfWagersToMinimumTimeout;
456             
457             // Start the game.
458             gameStarted = true;
459             
460             // Set the game starter.
461             gameStarter = msg.sender;
462             
463             // Emit start event.
464             Start(msg.sender, block.timestamp, price, timeout, minimumTimeout, numberOfWagersToMinimumTimeout);
465         }
466         
467         // Enough Ether must be supplied.
468         require(msg.value >= price);
469         
470         // Calculate the fees and dividends.
471         uint256 fee = price.mul(feePercentage).div(100000);
472         uint256 dividend = price.mul(gameStarterDividendPercentage).div(100000);
473         uint256 wagerPoolPart;
474         
475         if (wagerIndex % 7 == 6) {
476             // Give the wager prize every 7th wager.
477             
478             // Calculate total 7th wager prize.
479             uint256 wagerPrize = price.mul(2);
480             
481             // Calculate the missing wager pool part (equal to price.mul(2).div(7) plus a few wei).
482             wagerPoolPart = wagerPrize.sub(wagerPool);
483         
484             // Give the wager prize to the sender.
485             msg.sender.transfer(wagerPrize);
486             
487             // Reset the wager pool.
488             wagerPool = 0;
489         } else {
490             // On every non-7th wager, increase the wager pool.
491             
492             // Calculate the wager pool part.
493             wagerPoolPart = price.mul(2).div(7);
494             
495             // Add funds to the wager pool.
496             wagerPool = wagerPool.add(wagerPoolPart);
497         }
498         
499         // Calculate the timeout.
500         uint256 currentTimeout = calculateTimeout();
501         
502         // Set the last player, timestamp, timeout timestamp, and increase prize.
503         lastPlayer = msg.sender;
504         lastWagerTimeoutTimestamp = block.timestamp + currentTimeout;
505         prizePool = prizePool.add(price.sub(fee).sub(dividend).sub(wagerPoolPart));
506         
507         // Emit event.
508         Play(msg.sender, block.timestamp, lastWagerTimeoutTimestamp, wagerIndex, prizePool);
509         
510         // Send the game starter dividend.
511         _sendFunds(gameStarter, dividend);
512         
513         // Increment the wager index.
514         wagerIndex = wagerIndex.add(1);
515         
516         // Refund any excess Ether sent.
517         // This subtraction never underflows, as msg.value is guaranteed
518         // to be greater than or equal to price.
519         uint256 excess = msg.value - price;
520         
521         if (excess > 0) {
522             msg.sender.transfer(excess);
523         }
524     }
525     
526     /// @notice Spice up the prize pool.
527     /// @param message An optional message to be sent along with the spice.
528     function spiceUp(string message) external payable {
529         // Game must be live or unpaused.
530         require(gameStarted || !paused);
531         
532         // Funds must be sent.
533         require(msg.value > 0);
534         
535         // Add funds to the prize pool.
536         prizePool = prizePool.add(msg.value);
537         
538         // Emit event.
539         SpiceUpPrizePool(msg.sender, msg.value, message, prizePool);
540     }
541     
542     /// @notice Set the parameters for the next game.
543     /// @param _price The price of wagers for the next game.
544     /// @param _timeout The timeout in seconds for the next game.
545     /// @param _minimumTimeout The minimum timeout in seconds for
546     /// the next game.
547     /// @param _numberOfWagersToMinimumTimeout The number of wagers
548     /// required to move to the minimum timeout for the next game.
549     function setNextGame(uint256 _price, uint256 _timeout, uint256 _minimumTimeout, uint256 _numberOfWagersToMinimumTimeout) external onlyCFO {
550         require(_timeout >= _minimumTimeout);
551     
552         nextPrice = _price;
553         nextTimeout = _timeout;
554         nextMinimumTimeout = _minimumTimeout;
555         nextNumberOfWagersToMinimumTimeout = _numberOfWagersToMinimumTimeout;
556         NextGame(nextPrice, nextTimeout, nextMinimumTimeout, nextNumberOfWagersToMinimumTimeout);
557     } 
558     
559     /// @notice End the game. Pay prize.
560     function endGame() external {
561         require(_processGameEnd());
562     }
563     
564     /// @dev End the game. Pay prize.
565     function _processGameEnd() internal returns(bool) {
566         if (!gameStarted) {
567             // No game is started.
568             return false;
569         }
570     
571         if (block.timestamp <= lastWagerTimeoutTimestamp) {
572             // The game has not yet finished.
573             return false;
574         }
575         
576         // Calculate the prize. Any leftover funds for the
577         // 7th wager prize is added to the prize pool.
578         uint256 prize = prizePool.add(wagerPool);
579         
580         // The game has finished. Pay the prize to the last player.
581         _sendFunds(lastPlayer, prize);
582         
583         // Emit event.
584         End(lastPlayer, lastWagerTimeoutTimestamp, prize);
585         
586         // Reset the game.
587         gameStarted = false;
588         gameStarter = 0x0;
589         lastPlayer = 0x0;
590         lastWagerTimeoutTimestamp = 0;
591         wagerIndex = 0;
592         prizePool = 0;
593         wagerPool = 0;
594         
595         // Indicate ending the game was successful.
596         return true;
597     }
598 }