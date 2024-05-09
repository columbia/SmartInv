1 pragma solidity ^0.4.23;
2 
3 /*
4 * Zethroll.
5 *
6 * Adapted from PHXRoll, written in March 2018 by TechnicalRise:
7 *   https://www.reddit.com/user/TechnicalRise/
8 *
9 * Adapted for Zethr by Norsefire and oguzhanox.
10 *
11 * Gas golfed by Etherguy
12 * Audited & commented by Klob
13 */
14 
15 contract ZTHReceivingContract {
16   /**
17    * @dev Standard ERC223 function that will handle incoming token transfers.
18    *
19    * @param _from  Token sender address.
20    * @param _value Amount of tokens.
21    * @param _data  Transaction metadata.
22    */
23   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
24 }
25 
26 
27 contract ZTHInterface {
28   function getFrontEndTokenBalanceOf(address who) public view returns (uint);
29   function transfer(address _to, uint _value) public returns (bool);
30   function approve(address spender, uint tokens) public returns (bool);
31 }
32 
33 contract Zethroll is ZTHReceivingContract {
34   using SafeMath for uint;
35 
36   // Makes sure that player profit can't exceed a maximum amount,
37   //  that the bet size is valid, and the playerNumber is in range.
38   modifier betIsValid(uint _betSize, uint _playerNumber) {
39      require( calculateProfit(_betSize, _playerNumber) < maxProfit
40              && _betSize >= minBet
41              && _playerNumber > minNumber
42              && _playerNumber < maxNumber);
43     _;
44   }
45 
46   // Requires game to be currently active
47   modifier gameIsActive {
48     require(gamePaused == false);
49     _;
50   }
51 
52   // Requires msg.sender to be owner
53   modifier onlyOwner {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   // Constants
59   uint constant private MAX_INT = 2 ** 256 - 1;
60   uint constant public maxProfitDivisor = 1000000;
61   uint constant public maxNumber = 99;
62   uint constant public minNumber = 2;
63   uint constant public houseEdgeDivisor = 1000;
64 
65   // Configurables
66   bool public gamePaused;
67 
68   address public owner;
69   address public ZethrBankroll;
70   address public ZTHTKNADDR;
71 
72   ZTHInterface public ZTHTKN;
73 
74   uint public contractBalance;
75   uint public houseEdge;
76   uint public maxProfit;
77   uint public maxProfitAsPercentOfHouse;
78   uint public minBet = 0;
79 
80   // Trackers
81   uint public totalBets;
82   uint public totalZTHWagered;
83 
84   // Events
85 
86   // Logs bets + output to web3 for precise 'payout on win' field in UI
87   event LogBet(address sender, uint value, uint rollUnder);
88 
89   // Outputs to web3 UI on bet result
90   // Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send
91   event LogResult(address player, uint result, uint rollUnder, uint profit, uint tokensBetted, bool won);
92 
93   // Logs owner transfers
94   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
95 
96   // Logs changes in maximum profit
97   event MaxProfitChanged(uint _oldMaxProfit, uint _newMaxProfit);
98 
99   // Logs current contract balance
100   event CurrentContractBalance(uint _tokens);
101   
102   constructor (address zthtknaddr, address zthbankrolladdr) public {
103     // Owner is deployer
104     owner = msg.sender;
105 
106     // Initialize the ZTH contract and bankroll interfaces
107     ZTHTKN = ZTHInterface(zthtknaddr);
108     ZTHTKNADDR = zthtknaddr;
109 
110     // Set the bankroll
111     ZethrBankroll = zthbankrolladdr;
112 
113     // Init 990 = 99% (1% houseEdge)
114     houseEdge = 990;
115 
116     // The maximum profit from each bet is 10% of the contract balance.
117     ownerSetMaxProfitAsPercentOfHouse(10000);
118 
119     // Init min bet (1 ZTH)
120     ownerSetMinBet(1e18);
121 
122     // Allow 'unlimited' token transfer by the bankroll
123     ZTHTKN.approve(zthbankrolladdr, MAX_INT);
124   }
125 
126   function() public payable {} // receive zethr dividends
127 
128   // Returns a random number using a specified block number
129   // Always use a FUTURE block number.
130   function maxRandom(uint blockn, address entropy) public view returns (uint256 randomNumber) {
131     return uint256(keccak256(
132         abi.encodePacked(
133         blockhash(blockn),
134         entropy)
135       ));
136   }
137 
138   // Random helper
139   function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
140     return maxRandom(blockn, entropy) % upper;
141   }
142 
143   // Calculate the maximum potential profit
144   function calculateProfit(uint _initBet, uint _roll)
145     private
146     view
147     returns (uint)
148   {
149     return ((((_initBet * (100 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
150   }
151 
152   // I present a struct which takes only 20k gas
153   struct playerRoll{
154     uint200 tokenValue; // Token value in uint 
155     uint48 blockn;      // Block number 48 bits 
156     uint8 rollUnder;    // Roll under 8 bits
157   }
158 
159   // Mapping because a player can do one roll at a time
160   mapping(address => playerRoll) public playerRolls;
161 
162   function _playerRollDice(uint _rollUnder, TKN _tkn) private
163     gameIsActive
164     betIsValid(_tkn.value, _rollUnder)
165   {
166     require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
167     require(block.number < ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint48
168 
169     // Note that msg.sender is the Token Contract Address
170     // and "_from" is the sender of the tokens
171 
172     // Check that this is a ZTH token transfer
173     require(_zthToken(msg.sender));
174 
175     playerRoll memory roll = playerRolls[_tkn.sender];
176 
177     // Cannot bet twice in one block 
178     require(block.number != roll.blockn);
179 
180     // If there exists a roll, finish it
181     if (roll.blockn != 0) {
182       _finishBet(false, _tkn.sender);
183     }
184 
185     // Set struct block number, token value, and rollUnder values
186     roll.blockn = uint48(block.number);
187     roll.tokenValue = uint200(_tkn.value);
188     roll.rollUnder = uint8(_rollUnder);
189 
190     // Store the roll struct - 20k gas.
191     playerRolls[_tkn.sender] = roll;
192 
193     // Provides accurate numbers for web3 and allows for manual refunds
194     emit LogBet(_tkn.sender, _tkn.value, _rollUnder);
195                  
196     // Increment total number of bets
197     totalBets += 1;
198 
199     // Total wagered
200     totalZTHWagered += _tkn.value;
201   }
202 
203   // Finished the current bet of a player, if they have one
204   function finishBet() public
205     gameIsActive
206     returns (uint)
207   {
208     return _finishBet(true, msg.sender);
209   }
210 
211   /*
212    * Pay winner, update contract balance
213    * to calculate new max bet, and send reward.
214    */
215   function _finishBet(bool delete_it, address target) private returns (uint){
216     playerRoll memory roll = playerRolls[target];
217     require(roll.tokenValue > 0); // No re-entracy
218     require(roll.blockn != block.number);
219     // If the block is more than 255 blocks old, we can't get the result
220     // Also, if the result has already happened, fail as well
221     uint result;
222     if (block.number - roll.blockn > 255) {
223       result = 1000; // Cant win 
224     } else {
225       // Grab the result - random based ONLY on a past block (future when submitted)
226       result = random(99, roll.blockn, target) + 1;
227     }
228 
229     uint rollUnder = roll.rollUnder;
230 
231     if (result < rollUnder) {
232       // Player has won!
233 
234       // Safely map player profit
235       uint profit = calculateProfit(roll.tokenValue, rollUnder);
236       
237         if (profit > maxProfit){
238             profit = maxProfit;
239         }
240 
241       // Safely reduce contract balance by player profit
242       contractBalance = contractBalance.sub(profit);
243 
244       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
245 
246       // Update maximum profit
247       setMaxProfit();
248 
249       if (delete_it){
250         // Prevent re-entracy memes
251         delete playerRolls[target];
252       }
253 
254       // Transfer profit plus original bet
255       ZTHTKN.transfer(target, profit + roll.tokenValue);
256       
257       return result;
258 
259     } else {
260       /*
261       * Player has lost
262       * Update contract balance to calculate new max bet
263       */
264       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, false);
265 
266       /*
267       *  Safely adjust contractBalance
268       *  SetMaxProfit
269       */
270       contractBalance = contractBalance.add(roll.tokenValue);
271 
272       // No need to actually delete player roll here since player ALWAYS loses 
273       // Saves gas on next buy 
274 
275       // Update maximum profit
276       setMaxProfit();
277       
278       return result;
279     }
280   }
281 
282   // TKN struct
283   struct TKN {address sender; uint value;}
284 
285   // Token fallback to bet or deposit from bankroll
286   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool) {
287     require(msg.sender == ZTHTKNADDR);
288     if (_from == ZethrBankroll) {
289       // Update the contract balance
290       contractBalance = contractBalance.add(_value);
291 
292       // Update the maximum profit
293       uint oldMaxProfit = maxProfit;
294       setMaxProfit();
295 
296       emit MaxProfitChanged(oldMaxProfit, maxProfit);
297       return true;
298 
299     } else {
300       TKN memory _tkn;
301       _tkn.sender = _from;
302       _tkn.value = _value;
303       uint8 chosenNumber = uint8(_data[0]);
304       _playerRollDice(chosenNumber, _tkn);
305     }
306 
307     return true;
308   }
309 
310   /*
311   * Sets max profit
312   */
313   function setMaxProfit() internal {
314     emit CurrentContractBalance(contractBalance);
315     maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
316   }
317 
318   // Only owner adjust contract balance variable (only used for max profit calc)
319   function ownerUpdateContractBalance(uint newContractBalance) public
320   onlyOwner
321   {
322     contractBalance = newContractBalance;
323   }
324 
325   // Only owner address can set maxProfitAsPercentOfHouse
326   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
327   onlyOwner
328   {
329     // Restricts each bet to a maximum profit of 20% contractBalance
330     require(newMaxProfitAsPercent <= 200000);
331     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
332     setMaxProfit();
333   }
334 
335   // Only owner address can set minBet
336   function ownerSetMinBet(uint newMinimumBet) public
337   onlyOwner
338   {
339     minBet = newMinimumBet;
340   }
341 
342   // Only owner address can transfer ZTH
343   function ownerTransferZTH(address sendTo, uint amount) public
344   onlyOwner
345   {
346     // Safely update contract balance when sending out funds
347     contractBalance = contractBalance.sub(amount);
348 
349     // update max profit
350     setMaxProfit();
351     require(ZTHTKN.transfer(sendTo, amount));
352     emit LogOwnerTransfer(sendTo, amount);
353   }
354 
355   // Only owner address can set emergency pause #1
356   function ownerPauseGame(bool newStatus) public
357   onlyOwner
358   {
359     gamePaused = newStatus;
360   }
361 
362   // Only owner address can set bankroll address
363   function ownerSetBankroll(address newBankroll) public
364   onlyOwner
365   {
366     ZTHTKN.approve(ZethrBankroll, 0);
367     ZethrBankroll = newBankroll;
368     ZTHTKN.approve(newBankroll, MAX_INT);
369   }
370 
371   // Only owner address can set owner address
372   function ownerChangeOwner(address newOwner) public
373   onlyOwner
374   {
375     owner = newOwner;
376   }
377 
378   // Only owner address can selfdestruct - emergency
379   function ownerkill() public
380   onlyOwner
381   {
382     ZTHTKN.transfer(owner, contractBalance);
383     selfdestruct(owner);
384   }
385   
386   function dumpdivs() public{
387       ZethrBankroll.transfer(address(this).balance);
388   }
389 
390   function _zthToken(address _tokenContract) private view returns (bool) {
391     return _tokenContract == ZTHTKNADDR;
392     // Is this the ZTH token contract?
393   }
394 }
395 
396 /**
397  * @title SafeMath
398  * @dev Math operations with safety checks that throw on error
399  */
400 library SafeMath {
401 
402   /**
403   * @dev Multiplies two numbers, throws on overflow.
404   */
405   function mul(uint a, uint b) internal pure returns (uint) {
406     if (a == 0) {
407       return 0;
408     }
409     uint c = a * b;
410     assert(c / a == b);
411     return c;
412   }
413 
414   /**
415   * @dev Integer division of two numbers, truncating the quotient.
416   */
417   function div(uint a, uint b) internal pure returns (uint) {
418     // assert(b > 0); // Solidity automatically throws when dividing by 0
419     uint c = a / b;
420     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
421     return c;
422   }
423 
424   /**
425   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
426   */
427   function sub(uint a, uint b) internal pure returns (uint) {
428     assert(b <= a);
429     return a - b;
430   }
431 
432   /**
433   * @dev Adds two numbers, throws on overflow.
434   */
435   function add(uint a, uint b) internal pure returns (uint) {
436     uint c = a + b;
437     assert(c >= a);
438     return c;
439   }
440 }