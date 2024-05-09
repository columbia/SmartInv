1 pragma solidity ^0.4.23;
2 
3 /*
4 * Zethroll.
5 *
6 * Adapted from PHXRoll, written in March 2018 by TechnicalRise:
7 *   https://www.reddit.com/user/TechnicalRise/
8 *
9 * Gas golfed by Etherguy
10 * Audited & commented by Klob
11 */
12 
13 contract ZTHReceivingContract {
14   /**
15    * @dev Standard ERC223 function that will handle incoming token transfers.
16    *
17    * @param _from  Token sender address.
18    * @param _value Amount of tokens.
19    * @param _data  Transaction metadata.
20    */
21   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
22 }
23 
24 
25 contract ZTHInterface {
26   function getFrontEndTokenBalanceOf(address who) public view returns (uint);
27   function transfer(address _to, uint _value) public returns (bool);
28   function approve(address spender, uint tokens) public returns (bool);
29 }
30 
31 contract Zethroll is ZTHReceivingContract {
32   using SafeMath for uint;
33 
34   // Makes sure that player profit can't exceed a maximum amount,
35   //  that the bet size is valid, and the playerNumber is in range.
36   modifier betIsValid(uint _betSize, uint _playerNumber) {
37      require( calculateProfit(_betSize, _playerNumber) < maxProfit
38              && _betSize >= minBet
39              && _playerNumber > minNumber
40              && _playerNumber < maxNumber);
41     _;
42   }
43 
44   // Requires game to be currently active
45   modifier gameIsActive {
46     require(gamePaused == false);
47     _;
48   }
49 
50   // Requires msg.sender to be owner
51   modifier onlyOwner {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   // Constants
57   uint constant private MAX_INT = 2 ** 256 - 1;
58   uint constant public maxProfitDivisor = 1000000;
59   uint constant public maxNumber = 100;
60   uint constant public minNumber = 2;
61   uint constant public houseEdgeDivisor = 1000;
62 
63   // Configurables
64   bool public gamePaused;
65 
66   address public owner;
67   address public ZethrBankroll;
68   address public ZTHTKNADDR;
69 
70   ZTHInterface public ZTHTKN;
71 
72   uint public contractBalance;
73   uint public houseEdge;
74   uint public maxProfit;
75   uint public maxProfitAsPercentOfHouse;
76   uint public minBet = 0;
77 
78   // Trackers
79   uint public totalBets;
80   uint public totalZTHWagered;
81 
82   // Events
83 
84   // Logs bets + output to web3 for precise 'payout on win' field in UI
85   event LogBet(address sender, uint value, uint rollUnder);
86 
87   // Outputs to web3 UI on bet result
88   // Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send
89   event LogResult(address player, uint result, uint rollUnder, uint profit, uint tokensBetted, bool won);
90 
91   // Logs owner transfers
92   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
93 
94   // Logs changes in maximum profit
95   event MaxProfitChanged(uint _oldMaxProfit, uint _newMaxProfit);
96 
97   // Logs current contract balance
98   event CurrentContractBalance(uint _tokens);
99   
100   constructor (address zthtknaddr, address zthbankrolladdr) public {
101     // Owner is deployer
102     owner = msg.sender;
103 
104     // Initialize the ZTH contract and bankroll interfaces
105     ZTHTKN = ZTHInterface(zthtknaddr);
106     ZTHTKNADDR = zthtknaddr;
107 
108     // Set the bankroll
109     ZethrBankroll = zthbankrolladdr;
110 
111     // Init 990 = 99% (1% houseEdge)
112     houseEdge = 990;
113 
114     // The maximum profit from each bet is 10% of the contract balance.
115     ownerSetMaxProfitAsPercentOfHouse(10000);
116 
117     // Init min bet (1 ZTH)
118     ownerSetMinBet(1e18);
119 
120     // Allow 'unlimited' token transfer by the bankroll
121     ZTHTKN.approve(zthbankrolladdr, MAX_INT);
122   }
123 
124   function() public payable {} // receive zethr dividends
125 
126   // Returns a random number using a specified block number
127   // Always use a FUTURE block number.
128   function maxRandom(uint blockn, address entropy) public view returns (uint256 randomNumber) {
129     return uint256(keccak256(
130         abi.encodePacked(
131         blockhash(blockn),
132         entropy)
133       ));
134   }
135 
136   // Random helper
137   function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
138     return maxRandom(blockn, entropy) % upper;
139   }
140 
141   // Calculate the maximum potential profit
142   function calculateProfit(uint _initBet, uint _roll)
143     private
144     view
145     returns (uint)
146   {
147     return ((((_initBet * (101 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
148   }
149 
150   // I present a struct which takes only 20k gas
151   struct playerRoll{
152     uint200 tokenValue; // Token value in uint 
153     uint48 blockn;      // Block number 48 bits 
154     uint8 rollUnder;    // Roll under 8 bits
155   }
156 
157   // Mapping because a player can do one roll at a time
158   mapping(address => playerRoll) public playerRolls;
159 
160   function _playerRollDice(uint _rollUnder, TKN _tkn) private
161     gameIsActive
162     betIsValid(_tkn.value, _rollUnder)
163   {
164     require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
165     require(block.number < ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint48
166 
167     // Note that msg.sender is the Token Contract Address
168     // and "_from" is the sender of the tokens
169 
170     // Check that this is a ZTH token transfer
171     require(_zthToken(msg.sender));
172 
173     playerRoll memory roll = playerRolls[_tkn.sender];
174 
175     // Cannot bet twice in one block 
176     require(block.number != roll.blockn);
177 
178     // If there exists a roll, finish it
179     if (roll.blockn != 0) {
180       _finishBet(false, _tkn.sender);
181     }
182 
183     // Set struct block number, token value, and rollUnder values
184     roll.blockn = uint40(block.number);
185     roll.tokenValue = uint200(_tkn.value);
186     roll.rollUnder = uint8(_rollUnder);
187 
188     // Store the roll struct - 20k gas.
189     playerRolls[_tkn.sender] = roll;
190 
191     // Provides accurate numbers for web3 and allows for manual refunds
192     emit LogBet(_tkn.sender, _tkn.value, _rollUnder);
193                  
194     // Increment total number of bets
195     totalBets += 1;
196 
197     // Total wagered
198     totalZTHWagered += _tkn.value;
199   }
200 
201   // Finished the current bet of a player, if they have one
202   function finishBet() public
203     gameIsActive
204   {
205     _finishBet(true, msg.sender);
206   }
207 
208   /*
209    * Pay winner, update contract balance
210    * to calculate new max bet, and send reward.
211    */
212   function _finishBet(bool delete_it, address target) private {
213     playerRoll memory roll = playerRolls[target];
214     require(roll.tokenValue > 0); // No re-entracy
215 
216     // If the block is more than 255 blocks old, we can't get the result
217     // Also, if the result has already happened, fail as well
218     uint result;
219     if (block.number - roll.blockn > 255) {
220       result = 1000; // Cant win 
221     } else {
222       // Grab the result - random based ONLY on a past block (future when submitted)
223       result = random(100, roll.blockn, target) + 1;
224     }
225 
226     uint rollUnder = roll.rollUnder;
227 
228     if (result < rollUnder) {
229       // Player has won!
230 
231       // Safely map player profit
232       uint profit = calculateProfit(roll.tokenValue, rollUnder);
233 
234       // Safely reduce contract balance by player profit
235       contractBalance = contractBalance.sub(profit);
236 
237       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
238 
239       // Update maximum profit
240       setMaxProfit();
241 
242       if (delete_it){
243         // Prevent re-entracy memes
244         delete playerRolls[target];
245       }
246 
247       // Transfer profit plus original bet
248       ZTHTKN.transfer(target, profit + roll.tokenValue);
249 
250     } else {
251       /*
252       * Player has lost
253       * Update contract balance to calculate new max bet
254       */
255       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, false);
256 
257       /*
258       *  Safely adjust contractBalance
259       *  SetMaxProfit
260       */
261       contractBalance = contractBalance.add(roll.tokenValue);
262 
263       // No need to actually delete player roll here since player ALWAYS loses 
264       // Saves gas on next buy 
265 
266       // Update maximum profit
267       setMaxProfit();
268     }
269   }
270 
271   // TKN struct
272   struct TKN {address sender; uint value;}
273 
274   // Token fallback to bet or deposit from bankroll
275   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool) {
276     if (_from == ZethrBankroll) {
277       // Update the contract balance
278       contractBalance = contractBalance.add(_value);
279 
280       // Update the maximum profit
281       uint oldMaxProfit = maxProfit;
282       setMaxProfit();
283 
284       emit MaxProfitChanged(oldMaxProfit, maxProfit);
285       return true;
286 
287     } else {
288       TKN memory _tkn;
289       _tkn.sender = _from;
290       _tkn.value = _value;
291       uint chosenNumber = uint(_data[0]);
292       _playerRollDice(chosenNumber, _tkn);
293     }
294 
295     return true;
296   }
297 
298   /*
299   * Sets max profit
300   */
301   function setMaxProfit() internal {
302     emit CurrentContractBalance(contractBalance);
303     maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
304   }
305 
306   // Only owner adjust contract balance variable (only used for max profit calc)
307   function ownerUpdateContractBalance(uint newContractBalance) public
308   onlyOwner
309   {
310     contractBalance = newContractBalance;
311   }
312 
313   // Only owner address can set maxProfitAsPercentOfHouse
314   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
315   onlyOwner
316   {
317     // Restricts each bet to a maximum profit of 20% contractBalance
318     require(newMaxProfitAsPercent <= 200000);
319     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
320     setMaxProfit();
321   }
322 
323   // Only owner address can set minBet
324   function ownerSetMinBet(uint newMinimumBet) public
325   onlyOwner
326   {
327     minBet = newMinimumBet;
328   }
329 
330   // Only owner address can transfer ZTH
331   function ownerTransferZTH(address sendTo, uint amount) public
332   onlyOwner
333   {
334     // Safely update contract balance when sending out funds
335     contractBalance = contractBalance.sub(amount);
336 
337     // update max profit
338     setMaxProfit();
339     require(ZTHTKN.transfer(sendTo, amount));
340     emit LogOwnerTransfer(sendTo, amount);
341   }
342 
343   // Only owner address can set emergency pause #1
344   function ownerPauseGame(bool newStatus) public
345   onlyOwner
346   {
347     gamePaused = newStatus;
348   }
349 
350   // Only owner address can set bankroll address
351   function ownerSetBankroll(address newBankroll) public
352   onlyOwner
353   {
354     ZTHTKN.approve(ZethrBankroll, 0);
355     ZethrBankroll = newBankroll;
356     ZTHTKN.approve(newBankroll, MAX_INT);
357   }
358 
359   // Only owner address can set owner address
360   function ownerChangeOwner(address newOwner) public
361   onlyOwner
362   {
363     owner = newOwner;
364   }
365 
366   // Only owner address can selfdestruct - emergency
367   function ownerkill() public
368   onlyOwner
369   {
370     ZTHTKN.transfer(owner, contractBalance);
371     selfdestruct(owner);
372   }
373   
374   function dumpdivs() public{
375       ZethrBankroll.transfer(address(this).balance);
376   }
377 
378   function _zthToken(address _tokenContract) private view returns (bool) {
379     return _tokenContract == ZTHTKNADDR;
380     // Is this the ZTH token contract?
381   }
382 }
383 
384 /**
385  * @title SafeMath
386  * @dev Math operations with safety checks that throw on error
387  */
388 library SafeMath {
389 
390   /**
391   * @dev Multiplies two numbers, throws on overflow.
392   */
393   function mul(uint a, uint b) internal pure returns (uint) {
394     if (a == 0) {
395       return 0;
396     }
397     uint c = a * b;
398     assert(c / a == b);
399     return c;
400   }
401 
402   /**
403   * @dev Integer division of two numbers, truncating the quotient.
404   */
405   function div(uint a, uint b) internal pure returns (uint) {
406     // assert(b > 0); // Solidity automatically throws when dividing by 0
407     uint c = a / b;
408     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
409     return c;
410   }
411 
412   /**
413   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
414   */
415   function sub(uint a, uint b) internal pure returns (uint) {
416     assert(b <= a);
417     return a - b;
418   }
419 
420   /**
421   * @dev Adds two numbers, throws on overflow.
422   */
423   function add(uint a, uint b) internal pure returns (uint) {
424     uint c = a + b;
425     assert(c >= a);
426     return c;
427   }
428 }