1 pragma solidity ^0.4.24;
2 
3 /*
4 * XYZethroll.
5 *
6 * Adapted from PHXRoll, written in March 2018 by TechnicalRise:
7 *   https://www.reddit.com/user/TechnicalRise/
8 *
9 */
10 
11 contract ZTHReceivingContract {
12   /**
13    * @dev Standard ERC223 function that will handle incoming token transfers.
14    *
15    * @param _from  Token sender address.
16    * @param _value Amount of tokens.
17    * @param _data  Transaction metadata.
18    */
19   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
20 }
21 
22 
23 contract ZTHInterface {
24   function getFrontEndTokenBalanceOf(address who) public view returns (uint);
25   function transfer(address _to, uint _value) public returns (bool);
26   function approve(address spender, uint tokens) public returns (bool);
27 }
28 
29 contract Zethroll is ZTHReceivingContract {
30   using SafeMath for uint;
31 
32   // Makes sure that player profit can't exceed a maximum amount,
33   //  that the bet size is valid, and the playerNumber is in range.
34   modifier betIsValid(uint _betSize, uint _playerNumber) {
35      require( calculateProfit(_betSize, _playerNumber) < maxProfit
36              && _betSize >= minBet
37              && _playerNumber > minNumber
38              && _playerNumber < maxNumber);
39     _;
40   }
41 
42   // Requires game to be currently active
43   modifier gameIsActive {
44     require(gamePaused == false);
45     _;
46   }
47 
48   // Requires msg.sender to be owner
49   modifier onlyOwner {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   // Constants
55   uint constant private MAX_INT = 2 ** 256 - 1;
56   uint constant public maxProfitDivisor = 1000000;
57   uint constant public maxNumber = 99;
58   uint constant public minNumber = 2;
59   uint constant public houseEdgeDivisor = 1000;
60 
61   // Configurables
62   bool public gamePaused;
63 
64   address public owner;
65   address public ZethrBankroll;
66   address public ZTHTKNADDR;
67 
68   ZTHInterface public ZTHTKN;
69 
70   uint public contractBalance;
71   uint public houseEdge;
72   uint public maxProfit;
73   uint public maxProfitAsPercentOfHouse;
74   uint public minBet = 0;
75 
76   // Trackers
77   uint public totalBets;
78   uint public totalZTHWagered;
79 
80   // Events
81 
82   // Logs bets + output to web3 for precise 'payout on win' field in UI
83   event LogBet(address sender, uint value, uint rollUnder);
84 
85   // Outputs to web3 UI on bet result
86   // Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send
87   event LogResult(address player, uint result, uint rollUnder, uint profit, uint tokensBetted, bool won);
88 
89   // Logs owner transfers
90   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
91 
92   // Logs changes in maximum profit
93   event MaxProfitChanged(uint _oldMaxProfit, uint _newMaxProfit);
94 
95   // Logs current contract balance
96   event CurrentContractBalance(uint _tokens);
97   
98   constructor (address zthtknaddr, address zthbankrolladdr) public {
99     // Owner is deployer
100     owner = msg.sender;
101 
102     // Initialize the ZTH contract and bankroll interfaces
103     ZTHTKN = ZTHInterface(zthtknaddr);
104     ZTHTKNADDR = zthtknaddr;
105 
106     // Set the bankroll
107     ZethrBankroll = zthbankrolladdr;
108 
109     // Init 990 = 99% (1% houseEdge)
110     houseEdge = 990;
111 
112     // The maximum profit from each bet is 10% of the contract balance.
113     ownerSetMaxProfitAsPercentOfHouse(10000);
114 
115     // Init min bet (1 ZTH)
116     ownerSetMinBet(1e18);
117 
118     // Allow 'unlimited' token transfer by the bankroll
119     ZTHTKN.approve(zthbankrolladdr, MAX_INT);
120   }
121 
122   function() public payable {} // receive zethr dividends
123 
124   // Returns a random number using a specified block number
125   // Always use a FUTURE block number.
126   function maxRandom(uint blockn, address entropy) public view returns (uint256 randomNumber) {
127     return uint256(keccak256(
128         abi.encodePacked(
129         blockhash(blockn),
130         entropy)
131       ));
132   }
133 
134   // Random helper
135   function random(uint256 upper, uint256 blockn, address entropy) internal view returns (uint256 randomNumber) {
136     return maxRandom(blockn, entropy) % upper;
137   }
138 
139   // Calculate the maximum potential profit
140   function calculateProfit(uint _initBet, uint _roll)
141     private
142     view
143     returns (uint)
144   {
145     return ((((_initBet * (100 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
146   }
147 
148   // I present a struct which takes only 20k gas
149   struct playerRoll{
150     uint200 tokenValue; // Token value in uint 
151     uint48 blockn;      // Block number 48 bits 
152     uint8 rollUnder;    // Roll under 8 bits
153   }
154 
155   // Mapping because a player can do one roll at a time
156   mapping(address => playerRoll) public playerRolls;
157 
158   function _playerRollDice(uint _rollUnder, TKN _tkn) private
159     gameIsActive
160     betIsValid(_tkn.value, _rollUnder)
161   {
162     require(_tkn.value < ((2 ** 200) - 1));   // Smaller than the storage of 1 uint200;
163     require(block.number < ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint48
164 
165     // Note that msg.sender is the Token Contract Address
166     // and "_from" is the sender of the tokens
167 
168     // Check that this is a ZTH token transfer
169     require(_zthToken(msg.sender));
170 
171     playerRoll memory roll = playerRolls[_tkn.sender];
172 
173     // Cannot bet twice in one block 
174     require(block.number != roll.blockn);
175 
176     // If there exists a roll, finish it
177     if (roll.blockn != 0) {
178       _finishBet(false, _tkn.sender);
179     }
180 
181     // Set struct block number, token value, and rollUnder values
182     roll.blockn = uint48(block.number);
183     roll.tokenValue = uint200(_tkn.value);
184     roll.rollUnder = uint8(_rollUnder);
185 
186     // Store the roll struct - 20k gas.
187     playerRolls[_tkn.sender] = roll;
188 
189     // Provides accurate numbers for web3 and allows for manual refunds
190     emit LogBet(_tkn.sender, _tkn.value, _rollUnder);
191                  
192     // Increment total number of bets
193     totalBets += 1;
194 
195     // Total wagered
196     totalZTHWagered += _tkn.value;
197   }
198 
199   // Finished the current bet of a player, if they have one
200   function finishBet() public
201     gameIsActive
202     returns (uint)
203   {
204     return _finishBet(true, msg.sender);
205   }
206 
207   /*
208    * Pay winner, update contract balance
209    * to calculate new max bet, and send reward.
210    */
211   function _finishBet(bool delete_it, address target) private returns (uint){
212     playerRoll memory roll = playerRolls[target];
213     require(roll.tokenValue > 0); // No re-entracy
214     require(roll.blockn != block.number);
215     // If the block is more than 255 blocks old, we can't get the result
216     // Also, if the result has already happened, fail as well
217     uint result;
218     if (block.number - roll.blockn > 255) {
219       result = 1000; // Cant win 
220     } else {
221       // Grab the result - random based ONLY on a past block (future when submitted)
222       result = random(99, roll.blockn, target) + 1;
223     }
224 
225     uint rollUnder = roll.rollUnder;
226 
227     if (result < rollUnder) {
228       // Player has won!
229 
230       // Safely map player profit
231       uint profit = calculateProfit(roll.tokenValue, rollUnder);
232       
233         if (profit > maxProfit){
234             profit = maxProfit;
235         }
236 
237       // Safely reduce contract balance by player profit
238       contractBalance = contractBalance.sub(profit);
239 
240       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
241 
242       // Update maximum profit
243       setMaxProfit();
244 
245 
246         // Prevent re-entracy memes
247         playerRolls[target] = playerRoll(uint200(0), uint48(0), uint8(0));
248 
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
268         playerRolls[target] = playerRoll(uint200(0), uint48(0), uint8(0));
269       // No need to actually delete player roll here since player ALWAYS loses 
270       // Saves gas on next buy 
271 
272       // Update maximum profit
273       setMaxProfit();
274       
275       return result;
276     }
277   }
278 
279   // TKN struct
280   struct TKN {address sender; uint value;}
281 
282   // Token fallback to bet or deposit from bankroll
283   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool) {
284     require(msg.sender == ZTHTKNADDR);
285     if (_from == ZethrBankroll) {
286       // Update the contract balance
287       contractBalance = contractBalance.add(_value);
288 
289       // Update the maximum profit
290       uint oldMaxProfit = maxProfit;
291       setMaxProfit();
292 
293       emit MaxProfitChanged(oldMaxProfit, maxProfit);
294       return true;
295 
296     } else {
297       TKN memory _tkn;
298       _tkn.sender = _from;
299       _tkn.value = _value;
300       uint8 chosenNumber = uint8(_data[0]);
301       _playerRollDice(chosenNumber, _tkn);
302     }
303 
304     return true;
305   }
306 
307   /*
308   * Sets max profit
309   */
310   function setMaxProfit() internal {
311     emit CurrentContractBalance(contractBalance);
312     maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
313   }
314 
315   // Only owner adjust contract balance variable (only used for max profit calc)
316   function ownerUpdateContractBalance(uint newContractBalance) public
317   onlyOwner
318   {
319     contractBalance = newContractBalance;
320   }
321 
322   // Only owner address can set maxProfitAsPercentOfHouse
323   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
324   onlyOwner
325   {
326     // Restricts each bet to a maximum profit of 20% contractBalance
327     require(newMaxProfitAsPercent <= 200000);
328     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
329     setMaxProfit();
330   }
331 
332   // Only owner address can set minBet
333   function ownerSetMinBet(uint newMinimumBet) public
334   onlyOwner
335   {
336     minBet = newMinimumBet;
337   }
338 
339   // Only owner address can transfer ZTH
340   function ownerTransferZTH(address sendTo, uint amount) public
341   onlyOwner
342   {
343     // Safely update contract balance when sending out funds
344     contractBalance = contractBalance.sub(amount);
345 
346     // update max profit
347     setMaxProfit();
348     require(ZTHTKN.transfer(sendTo, amount));
349     emit LogOwnerTransfer(sendTo, amount);
350   }
351 
352   // Only owner address can set emergency pause #1
353   function ownerPauseGame(bool newStatus) public
354   onlyOwner
355   {
356     gamePaused = newStatus;
357   }
358 
359   // Only owner address can set bankroll address
360   function ownerSetBankroll(address newBankroll) public
361   onlyOwner
362   {
363     ZTHTKN.approve(ZethrBankroll, 0);
364     ZethrBankroll = newBankroll;
365     ZTHTKN.approve(newBankroll, MAX_INT);
366   }
367 
368   // Only owner address can set owner address
369   function ownerChangeOwner(address newOwner) public
370   onlyOwner
371   {
372     owner = newOwner;
373   }
374 
375   // Only owner address can selfdestruct - emergency
376   function ownerkill() public
377   onlyOwner
378   {
379     ZTHTKN.transfer(owner, contractBalance);
380     selfdestruct(owner);
381   }
382   
383   function dumpdivs() public{
384       ZethrBankroll.transfer(address(this).balance);
385   }
386 
387   function _zthToken(address _tokenContract) private view returns (bool) {
388     return _tokenContract == ZTHTKNADDR;
389     // Is this the ZTH token contract?
390   }
391 }
392 
393 /**
394  * @title SafeMath
395  * @dev Math operations with safety checks that throw on error
396  */
397 library SafeMath {
398 
399   /**
400   * @dev Multiplies two numbers, throws on overflow.
401   */
402   function mul(uint a, uint b) internal pure returns (uint) {
403     if (a == 0) {
404       return 0;
405     }
406     uint c = a * b;
407     assert(c / a == b);
408     return c;
409   }
410 
411   /**
412   * @dev Integer division of two numbers, truncating the quotient.
413   */
414   function div(uint a, uint b) internal pure returns (uint) {
415     // assert(b > 0); // Solidity automatically throws when dividing by 0
416     uint c = a / b;
417     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
418     return c;
419   }
420 
421   /**
422   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
423   */
424   function sub(uint a, uint b) internal pure returns (uint) {
425     assert(b <= a);
426     return a - b;
427   }
428 
429   /**
430   * @dev Adds two numbers, throws on overflow.
431   */
432   function add(uint a, uint b) internal pure returns (uint) {
433     uint c = a + b;
434     assert(c >= a);
435     return c;
436   }
437 }