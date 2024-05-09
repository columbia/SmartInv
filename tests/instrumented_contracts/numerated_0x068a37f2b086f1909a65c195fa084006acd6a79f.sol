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
277     /// @notice The timestamp of the last play.
278     uint256 public lastPlayTimestamp;
279 
280     /// @notice The number of seconds before the game ends.
281     uint256 public timeout = 120;
282     
283     /// @notice The wager index of the the current wager in the game.
284     uint256 public wagerIndex = 0;
285 }
286 
287 
288 /**
289  * @title PullPayment
290  * @dev Base contract supporting async send for pull payments. Inherit from this
291  * contract and use asyncSend instead of send.
292  */
293 contract PullPayment {
294   using SafeMath for uint256;
295 
296   mapping(address => uint256) public payments;
297   uint256 public totalPayments;
298 
299   /**
300   * @dev withdraw accumulated balance, called by payee.
301   */
302   function withdrawPayments() public {
303     address payee = msg.sender;
304     uint256 payment = payments[payee];
305 
306     require(payment != 0);
307     require(this.balance >= payment);
308 
309     totalPayments = totalPayments.sub(payment);
310     payments[payee] = 0;
311 
312     assert(payee.send(payment));
313   }
314 
315   /**
316   * @dev Called by the payer to store the sent amount as credit to be pulled.
317   * @param dest The destination address of the funds.
318   * @param amount The amount to transfer.
319   */
320   function asyncSend(address dest, uint256 amount) internal {
321     payments[dest] = payments[dest].add(amount);
322     totalPayments = totalPayments.add(amount);
323   }
324 }
325 
326 
327 /// @dev Defines base finance functionality for Chronos.
328 contract ChronosFinance is ChronosBase, PullPayment {
329     /// @notice The dev fee in 1/1000th
330     /// of a percentage.
331     uint256 public feePercentage = 2500;
332     
333     /// @notice The game starter fee.
334     uint256 public gameStarterDividendPercentage = 1000;
335     
336     /// @notice The price to play.
337     uint256 public price = 0.005 ether;
338     
339     /// @notice The current prize pool (in wei).
340     uint256 public prizePool;
341     
342     /// @notice The current 7th wager pool (in wei).
343     uint256 public wagerPool;
344     
345     /// @dev Send funds to a beneficiary. If sending fails, assign
346     /// funds to the beneficiary's balance for manual withdrawal.
347     /// @param beneficiary The beneficiary's address to send funds to
348     /// @param amount The amount to send.
349     function _sendFunds(address beneficiary, uint256 amount) internal {
350         if (!beneficiary.send(amount)) {
351             // Failed to send funds. This can happen due to a failure in
352             // fallback code of the beneficiary, or because of callstack
353             // depth.
354             // Send funds asynchronously for manual withdrawal by the
355             // beneficiary.
356             asyncSend(beneficiary, amount);
357         }
358     }
359     
360     /// @notice Withdraw (unowed) contract balance.
361     function withdrawFreeBalance() external onlyCFO {
362         // Calculate the free (unowed) balance.
363         uint256 freeBalance = this.balance.sub(totalPayments).sub(prizePool).sub(wagerPool);
364         
365         cfoAddress.transfer(freeBalance);
366     }
367 }
368 
369 
370 /// @dev Defines core Chronos functionality.
371 contract ChronosCore is ChronosFinance {
372     function ChronosCore(uint256 _price, uint256 _timeout) public {
373         price = _price;
374         timeout = _timeout;
375     }
376     
377     event Start(address indexed starter, uint256 timestamp);
378     event End(address indexed winner, uint256 timestamp, uint256 prize);
379     event Play(address indexed player, uint256 timestamp, uint256 timeoutTimestamp, uint256 wagerIndex, uint256 newPrizePool);
380     
381     /// @notice Participate in the game.
382     /// @param startNewGameIfIdle Start a new game if the current game is idle.
383     function play(bool startNewGameIfIdle) external payable {
384         // Check to see if the game should end. Process payment.
385         _processGameEnd();
386         
387         // Enough Ether must be supplied.
388         require(msg.value >= price);
389         
390         if (!gameStarted) {
391             // If the game is not started, the contract must not be paused.
392             require(!paused);
393             
394             // If the game is not started, the player must be willing to start
395             // a new game.
396             require(startNewGameIfIdle);
397             
398             // Start the game.
399             gameStarted = true;
400             
401             // Set the game starter.
402             gameStarter = msg.sender;
403             
404             // Emit start event.
405             Start(msg.sender, block.timestamp);
406         }
407         
408         // Calculate the fees and dividends.
409         uint256 fee = price.mul(feePercentage).div(100000);
410         uint256 dividend = price.mul(gameStarterDividendPercentage).div(100000);
411         uint256 wagerPoolPart = price.mul(2).div(7);
412         
413         // Set the last player and block, increase prize.
414         lastPlayer = msg.sender;
415         lastPlayTimestamp = block.timestamp;
416         prizePool = prizePool.add(price.sub(fee).sub(dividend).sub(wagerPoolPart));
417         
418         // Emit event.
419         Play(msg.sender, block.timestamp, block.timestamp + timeout, wagerIndex, prizePool);
420         
421         // Send the game starter dividend.
422         _sendFunds(gameStarter, dividend);
423         
424         // Give the wager price every 7th wager.
425         if (wagerIndex > 0 && (wagerIndex % 7) == 0) {
426             // Give the wager prize to the sender.
427             msg.sender.transfer(wagerPool);
428             
429             // Reset the wager pool.
430             wagerPool = 0;
431         }
432         
433         // Add funds to the wager pool.
434         wagerPool = wagerPool.add(wagerPoolPart);
435         
436         // Increment the wager index.
437         wagerIndex = wagerIndex.add(1);
438         
439         // Refund any excess Ether sent.
440         // This subtraction never underflows, as msg.value is guaranteed
441         // to be greater than or equal to price.
442         uint256 excess = msg.value - price;
443         
444         if (excess > 0) {
445             msg.sender.transfer(excess);
446         }
447     }
448     
449     /// @notice End the game. Pay prize.
450     function endGame() external {
451         require(_processGameEnd());
452     }
453     
454     /// @dev End the game. Pay prize.
455     function _processGameEnd() internal returns(bool) {
456         if (!gameStarted) {
457             // No game is started.
458             return false;
459         }
460     
461         if (block.timestamp <= lastPlayTimestamp + timeout) {
462             // The game has not yet finished.
463             return false;
464         }
465         
466         // The game has finished. Pay the prize to the last player.
467         _sendFunds(lastPlayer, prizePool);
468         
469         // Emit event.
470         End(lastPlayer, lastPlayTimestamp, prizePool);
471         
472         // Reset the game.
473         gameStarted = false;
474         gameStarter = 0x0;
475         lastPlayer = 0x0;
476         lastPlayTimestamp = 0;
477         wagerIndex = 0;
478         prizePool = 0;
479         wagerPool = 0;
480         
481         // Indicate ending the game was successful.
482         return true;
483     }
484 }