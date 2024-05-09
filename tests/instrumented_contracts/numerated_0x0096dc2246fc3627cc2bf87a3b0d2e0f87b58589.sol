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
186     roll.blockn = uint40(block.number);
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
237       // Safely reduce contract balance by player profit
238       contractBalance = contractBalance.sub(profit);
239 
240       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
241 
242       // Update maximum profit
243       setMaxProfit();
244 
245       if (delete_it){
246         // Prevent re-entracy memes
247         delete playerRolls[target];
248       }
249 
250       // Transfer profit plus original bet
251       ZTHTKN.transfer(target, profit + roll.tokenValue);
252       
253       return result;
254 
255     } else {
256       /*
257       * Player has lost
258       * Update contract balance to calculate new max bet
259       */
260       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, false);
261 
262       /*
263       *  Safely adjust contractBalance
264       *  SetMaxProfit
265       */
266       contractBalance = contractBalance.add(roll.tokenValue);
267 
268       // No need to actually delete player roll here since player ALWAYS loses 
269       // Saves gas on next buy 
270 
271       // Update maximum profit
272       setMaxProfit();
273       
274       return result;
275     }
276   }
277 
278   // TKN struct
279   struct TKN {address sender; uint value;}
280 
281   // Token fallback to bet or deposit from bankroll
282   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool) {
283     require(msg.sender == ZTHTKNADDR);
284     if (_from == ZethrBankroll) {
285       // Update the contract balance
286       contractBalance = contractBalance.add(_value);
287 
288       // Update the maximum profit
289       uint oldMaxProfit = maxProfit;
290       setMaxProfit();
291 
292       emit MaxProfitChanged(oldMaxProfit, maxProfit);
293       return true;
294 
295     } else {
296       TKN memory _tkn;
297       _tkn.sender = _from;
298       _tkn.value = _value;
299       uint8 chosenNumber = uint8(_data[0]);
300       _playerRollDice(chosenNumber, _tkn);
301     }
302 
303     return true;
304   }
305 
306   /*
307   * Sets max profit
308   */
309   function setMaxProfit() internal {
310     emit CurrentContractBalance(contractBalance);
311     maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
312   }
313 
314   // Only owner adjust contract balance variable (only used for max profit calc)
315   function ownerUpdateContractBalance(uint newContractBalance) public
316   onlyOwner
317   {
318     contractBalance = newContractBalance;
319   }
320 
321   // Only owner address can set maxProfitAsPercentOfHouse
322   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
323   onlyOwner
324   {
325     // Restricts each bet to a maximum profit of 20% contractBalance
326     require(newMaxProfitAsPercent <= 200000);
327     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
328     setMaxProfit();
329   }
330 
331   // Only owner address can set minBet
332   function ownerSetMinBet(uint newMinimumBet) public
333   onlyOwner
334   {
335     minBet = newMinimumBet;
336   }
337 
338   // Only owner address can transfer ZTH
339   function ownerTransferZTH(address sendTo, uint amount) public
340   onlyOwner
341   {
342     // Safely update contract balance when sending out funds
343     contractBalance = contractBalance.sub(amount);
344 
345     // update max profit
346     setMaxProfit();
347     require(ZTHTKN.transfer(sendTo, amount));
348     emit LogOwnerTransfer(sendTo, amount);
349   }
350 
351   // Only owner address can set emergency pause #1
352   function ownerPauseGame(bool newStatus) public
353   onlyOwner
354   {
355     gamePaused = newStatus;
356   }
357 
358   // Only owner address can set bankroll address
359   function ownerSetBankroll(address newBankroll) public
360   onlyOwner
361   {
362     ZTHTKN.approve(ZethrBankroll, 0);
363     ZethrBankroll = newBankroll;
364     ZTHTKN.approve(newBankroll, MAX_INT);
365   }
366 
367   // Only owner address can set owner address
368   function ownerChangeOwner(address newOwner) public
369   onlyOwner
370   {
371     owner = newOwner;
372   }
373 
374   // Only owner address can selfdestruct - emergency
375   function ownerkill() public
376   onlyOwner
377   {
378     ZTHTKN.transfer(owner, contractBalance);
379     selfdestruct(owner);
380   }
381   
382   function dumpdivs() public{
383       ZethrBankroll.transfer(address(this).balance);
384   }
385 
386   function _zthToken(address _tokenContract) private view returns (bool) {
387     return _tokenContract == ZTHTKNADDR;
388     // Is this the ZTH token contract?
389   }
390 }
391 
392 /**
393  * @title SafeMath
394  * @dev Math operations with safety checks that throw on error
395  */
396 library SafeMath {
397 
398   /**
399   * @dev Multiplies two numbers, throws on overflow.
400   */
401   function mul(uint a, uint b) internal pure returns (uint) {
402     if (a == 0) {
403       return 0;
404     }
405     uint c = a * b;
406     assert(c / a == b);
407     return c;
408   }
409 
410   /**
411   * @dev Integer division of two numbers, truncating the quotient.
412   */
413   function div(uint a, uint b) internal pure returns (uint) {
414     // assert(b > 0); // Solidity automatically throws when dividing by 0
415     uint c = a / b;
416     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
417     return c;
418   }
419 
420   /**
421   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
422   */
423   function sub(uint a, uint b) internal pure returns (uint) {
424     assert(b <= a);
425     return a - b;
426   }
427 
428   /**
429   * @dev Adds two numbers, throws on overflow.
430   */
431   function add(uint a, uint b) internal pure returns (uint) {
432     uint c = a + b;
433     assert(c >= a);
434     return c;
435   }
436 }