1 pragma solidity ^0.4.23;
2 
3 /*
4 * Zethroll.
5 *
6 * Adapted from PHXRoll, written in March 2018 by TechnicalRise:
7 *   https://www.reddit.com/user/TechnicalRise/
8 *
9 * Gas golfed by Etherguy
10 */
11 
12 contract ZTHReceivingContract {
13   /**
14    * @dev Standard ERC223 function that will handle incoming token transfers.
15    *
16    * @param _from  Token sender address.
17    * @param _value Amount of tokens.
18    * @param _data  Transaction metadata.
19    */
20   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool);
21 }
22 
23 
24 contract ZTHInterface {
25   function getFrontEndTokenBalanceOf(address who) public view returns (uint);
26   function transfer(address _to, uint _value) public returns (bool);
27   function approve(address spender, uint tokens) public returns (bool);
28 }
29 
30 contract Zethroll is ZTHReceivingContract {
31   using SafeMath for uint;
32 
33   /*
34    * checks player profit, bet size and player number is within range
35   */
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
67   address public bankroll;
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
78   // Events
79 
80   // Logs bets + output to web3 for precise 'payout on win' field in UI
81   event LogBet(address sender, uint value, uint rollUnder);
82 
83   // Outputs to web3 UI on bet result
84   // Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send
85 
86   event LogResult(address player, uint result, uint rollUnder, uint profit, uint tokensBetted, bool won);
87 
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
98   address ZethrBankroll;
99 
100   constructor (address zthtknaddr, address zthbankrolladdr) public {
101     // Owner is deployer
102     owner = msg.sender;
103 
104     // Initialize the ZTH contract and bankroll interfaces
105     ZTHTKN = ZTHInterface(zthtknaddr);
106     ZTHTKNADDR = zthtknaddr;
107 
108     ZethrBankroll = zthbankrolladdr;
109 
110     // Init 990 = 99% (1% houseEdge)
111     houseEdge = 990;
112 
113     // The maximum profit from each bet is 1% of the contract balance.
114     ownerSetMaxProfitAsPercentOfHouse(10000);
115 
116     // Init min bet (1 ZTH)
117     ownerSetMinBet(1e18);
118 
119     // Allow 'unlimited' token transfer by the bankroll
120     ZTHTKN.approve(zthbankrolladdr, MAX_INT);
121 
122     // Set the bankroll
123     bankroll = zthbankrolladdr;
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
143   /*
144    * TODO comment this Norsefire, I have no idea how it works
145    */
146   function calculateProfit(uint _initBet, uint _roll)
147     private
148     view
149     returns (uint)
150   {
151     return ((((_initBet * (101 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
152   }
153 
154   /*
155    * public function
156    * player submit bet
157    * only if game is active & bet is valid
158   */
159   event Debug(uint a, string b);
160 
161   // i present a struct which takes only 20k gas
162   struct playerRoll{
163     uint200 tokenValue; // token value in uint 
164     //address player; // dont need to save this get this from msg.sender OR via mapping 
165     uint48 blockn; // block number 48 bits 
166     uint8 rollUnder; // roll under 8 bits
167   }
168 
169   mapping(address => playerRoll) public playerRolls;
170 
171   function _playerRollDice(uint _rollUnder, TKN _tkn) private
172     gameIsActive
173     betIsValid(_tkn.value, _rollUnder)
174   {
175     require(_tkn.value < ((2 ** 200) - 1)); // smaller than the storage of 1 uint200;
176     //require(_rollUnder < 255); // smaller than the storage of 1 uint8 [max roll under 100, checked in betIsValid]
177     require(block.number < ((2 ** 48) - 1)); // current block number smaller than storage of 1 uint48
178     // Note that msg.sender is the Token Contract Address
179     // and "_from" is the sender of the tokens
180 
181     // Check that this is a non-contract sender 
182     // contracts btfo we use next block need 2 tx 
183     // russian hackers can use their multisigs too 
184    // require(_humanSender(_tkn.sender));
185 
186     // Check that this is a ZTH token transfer
187     require(_zthToken(msg.sender));
188 
189     playerRoll memory roll = playerRolls[_tkn.sender];
190 
191     // Cannot bet twice in one block 
192     require(block.number != roll.blockn);
193 
194     if (roll.blockn != 0) {
195       _finishBet(false, _tkn.sender);
196     }
197 
198     // Increment rngId dont need this saves 5k gas 
199     //rngId++;
200 
201     // Map bet id to this wager 
202     // one bet per player dont need this  5k gas 
203     //playerBetId[rngId] = rngId;
204 
205     // Map player lucky number
206     // save _rollUnder twice? no. 
207     //  5k gas 
208     //playerNumber[rngId] = _rollUnder;
209 
210     // Map value of wager
211     // not necessary we already save _tkn; 10k save
212     //playerBetValue[rngId] = _tkn.value;
213 
214     // Map player address
215     // dont need this  5k gas 
216     //playerAddress[rngId] = _tkn.sender;
217 
218     // Safely map player profit
219     // dont need this  5k gas 
220     //playerProfit[rngId] = 0;
221 
222     roll.blockn = uint40(block.number);
223     roll.tokenValue = uint200(_tkn.value);
224     roll.rollUnder = uint8(_rollUnder);
225 
226     playerRolls[_tkn.sender] = roll; // write to storage. 20k 
227 
228     // Provides accurate numbers for web3 and allows for manual refunds
229     emit LogBet(_tkn.sender, _tkn.value, _rollUnder);
230                  
231     // Increment total number of bets
232     // dont need this  5k gas 
233     //totalBets += 1;
234 
235     // Total wagered
236     // dont need this 5k gas 
237     //totalZTHWagered += playerBetValue[rngId];
238   }
239 
240   function finishBet() public
241     gameIsActive
242   {
243     _finishBet(true, msg.sender);
244   }
245 
246   /*
247    * Pay winner, update contract balance
248    * to calculate new max bet, and send reward.
249    */
250   function _finishBet(bool delete_it, address target) private {
251     playerRoll memory roll = playerRolls[target];
252     require(roll.tokenValue > 0); // no re-entracy
253     // If the block is more than 255 blocks old, we can't get the result
254     // Also, if the result has alread happened, fail as well
255     uint result;
256     if (block.number - roll.blockn > 255) {
257       // dont need this; 5k
258       //playerDieResult[_rngId] = 1000;
259       result = 1000; // cant win 
260       // Fail
261     } else {
262       // dont need this; 5k;
263       //playerDieResult[_rngId] = random(100, playerBlock[_rngId]) + 1;
264       result = random(100, roll.blockn, target) + 1;
265     }
266 
267     // Null out this bet so it can't be used again.
268     //playerBlock[_rngId] = 0;
269 
270    // emit Debug(playerDieResult[_rngId], 'LuckyNumber');
271 
272 
273     uint rollUnder = roll.rollUnder;
274 
275     if (result < rollUnder) {
276       // Player has won!
277 
278       // Safely map player profit
279       // dont need this; 5k
280       //playerProfit[_rngId] = calculateProfit(_tkn.value, _rollUnder);
281       uint profit = calculateProfit(roll.tokenValue, rollUnder);
282       // Safely reduce contract balance by player profit
283       contractBalance = contractBalance.sub(profit);
284 
285       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
286 
287       // Update maximum profit
288       setMaxProfit();
289 
290       if (delete_it){
291         // prevent re-entracy memes;
292         delete playerRolls[target];
293       }
294 
295 
296       // Transfer profit plus original bet
297       ZTHTKN.transfer(target, profit + roll.tokenValue);
298 
299     } else {
300       /*
301       * Player has lost
302       * Update contract balance to calculate new max bet
303       */
304       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, false);
305 
306       /*
307       *  Safely adjust contractBalance
308       *  SetMaxProfit
309       */
310       contractBalance = contractBalance.add(roll.tokenValue);
311 
312       // no need to actually delete player roll here since player ALWAYS loses 
313       // saves gas on next buy 
314 
315       // Update maximum profit
316       setMaxProfit();
317     }
318 
319     //result = playerDieResult[_rngId];
320     //return result;
321   }
322 
323   struct TKN {address sender; uint value;}
324   function tokenFallback(address _from, uint _value, bytes _data) public returns (bool) {
325     if (_from == bankroll) {
326       // Update the contract balance
327       contractBalance = contractBalance.add(_value);
328 
329       // Update the maximum profit
330       uint oldMaxProfit = maxProfit;
331       setMaxProfit();
332 
333       emit MaxProfitChanged(oldMaxProfit, maxProfit);
334       return true;
335 
336     } else {
337       TKN memory _tkn;
338       _tkn.sender = _from;
339       _tkn.value = _value;
340       uint chosenNumber = uint(_data[0]);
341       _playerRollDice(chosenNumber, _tkn);
342     }
343     return true;
344   }
345 
346   /*
347   * Sets max profit
348   */
349   function setMaxProfit() internal {
350     emit CurrentContractBalance(contractBalance);
351     maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
352   }
353 
354   // Only owner adjust contract balance variable (only used for max profit calc)
355   function ownerUpdateContractBalance(uint newContractBalance) public
356   onlyOwner
357   {
358     contractBalance = newContractBalance;
359   }
360 
361   // Only owner address can set maxProfitAsPercentOfHouse
362   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
363   onlyOwner
364   {
365     // Restricts each bet to a maximum profit of 1% contractBalance
366     require(newMaxProfitAsPercent <= 10000);
367     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
368     setMaxProfit();
369   }
370 
371   // Only owner address can set minBet
372   function ownerSetMinBet(uint newMinimumBet) public
373   onlyOwner
374   {
375     minBet = newMinimumBet;
376   }
377 
378   // Only owner address can transfer ZTH
379   function ownerTransferZTH(address sendTo, uint amount) public
380   onlyOwner
381   {
382     // Safely update contract balance when sending out funds
383     contractBalance = contractBalance.sub(amount);
384 
385     // update max profit
386     setMaxProfit();
387     require(ZTHTKN.transfer(sendTo, amount));
388     emit LogOwnerTransfer(sendTo, amount);
389   }
390 
391   // Only owner address can set emergency pause #1
392   function ownerPauseGame(bool newStatus) public
393   onlyOwner
394   {
395     gamePaused = newStatus;
396   }
397 
398 
399 
400   // Only owner address can set bankroll address
401   function ownerSetBankroll(address newBankroll) public
402   onlyOwner
403   {
404     ZTHTKN.approve(bankroll, 0);
405     bankroll = newBankroll;
406     ZTHTKN.approve(newBankroll, MAX_INT);
407   }
408 
409   // Only owner address can set owner address
410   function ownerChangeOwner(address newOwner) public
411   onlyOwner
412   {
413     owner = newOwner;
414   }
415 
416   // Only owner address can selfdestruct - emergency
417   function ownerkill() public
418   onlyOwner
419   {
420     ZTHTKN.transfer(owner, contractBalance);
421     selfdestruct(owner);
422   }
423   
424   function dumpdivs() public{
425       ZethrBankroll.transfer(address(this).balance);
426   }
427 
428   function _zthToken(address _tokenContract) private view returns (bool) {
429     return _tokenContract == ZTHTKNADDR;
430     // Is this the ZTH token contract?
431   }
432 }
433 
434 /**
435  * @title SafeMath
436  * @dev Math operations with safety checks that throw on error
437  */
438 library SafeMath {
439 
440   /**
441   * @dev Multiplies two numbers, throws on overflow.
442   */
443   function mul(uint a, uint b) internal pure returns (uint) {
444     if (a == 0) {
445       return 0;
446     }
447     uint c = a * b;
448     assert(c / a == b);
449     return c;
450   }
451 
452   /**
453   * @dev Integer division of two numbers, truncating the quotient.
454   */
455   function div(uint a, uint b) internal pure returns (uint) {
456     // assert(b > 0); // Solidity automatically throws when dividing by 0
457     uint c = a / b;
458     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
459     return c;
460   }
461 
462   /**
463   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
464   */
465   function sub(uint a, uint b) internal pure returns (uint) {
466     assert(b <= a);
467     return a - b;
468   }
469 
470   /**
471   * @dev Adds two numbers, throws on overflow.
472   */
473   function add(uint a, uint b) internal pure returns (uint) {
474     uint c = a + b;
475     assert(c >= a);
476     return c;
477   }
478 }