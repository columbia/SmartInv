1 pragma solidity ^0.4.24;
2 
3 // Zethr Token Bankroll interface
4 contract ZethrTokenBankroll{
5     // Game request token transfer to player 
6     function gameRequestTokens(address target, uint tokens) public;
7 }
8 
9 // Zether Main Bankroll interface
10 contract ZethrMainBankroll{
11     function gameGetTokenBankrollList() public view returns (address[7]);
12 }
13 
14 // Zethr main contract interface
15 contract ZethrInterface{
16     function withdraw() public;
17 }
18 
19 // Library for figuring out the "tier" (1-7) of a dividend rate
20 library ZethrTierLibrary{
21     uint constant internal magnitude = 2**64;
22     function getTier(uint divRate) internal pure returns (uint){
23         // Tier logic 
24         // Returns the index of the UsedBankrollAddresses which should be used to call into to withdraw tokens 
25         
26         // We can divide by magnitude
27         // Remainder is removed so we only get the actual number we want
28         uint actualDiv = divRate; 
29         if (actualDiv >= 30){
30             return 6;
31         } else if (actualDiv >= 25){
32             return 5;
33         } else if (actualDiv >= 20){
34             return 4;
35         } else if (actualDiv >= 15){
36             return 3;
37         } else if (actualDiv >= 10){
38             return 2; 
39         } else if (actualDiv >= 5){
40             return 1;
41         } else if (actualDiv >= 2){
42             return 0;
43         } else{
44             // Impossible
45             revert(); 
46         }
47     }
48 }
49  
50 // Contract that contains the functions to interact with the bankroll system
51 contract ZethrBankrollBridge{
52     // Must have an interface with the main Zethr token contract 
53     ZethrInterface Zethr;
54    
55     // Store the bankroll addresses 
56     // address[0] is main bankroll 
57     // address[1] is tier1: 2-5% 
58     // address[2] is tier2: 5-10, etc
59     address[7] UsedBankrollAddresses; 
60 
61     // Mapping for easy checking
62     mapping(address => bool) ValidBankrollAddress;
63     
64     // Set up the tokenbankroll stuff 
65     function setupBankrollInterface(address ZethrMainBankrollAddress) internal {
66         // Instantiate Zethr
67         Zethr = ZethrInterface(0xb9ab8eed48852de901c13543042204c6c569b811);
68         // Get the bankroll addresses from the main bankroll
69         UsedBankrollAddresses = ZethrMainBankroll(ZethrMainBankrollAddress).gameGetTokenBankrollList();
70         for(uint i=0; i<7; i++){
71             ValidBankrollAddress[UsedBankrollAddresses[i]] = true;
72         }
73     }
74     
75     // Require a function to be called from a *token* bankroll 
76     modifier fromBankroll(){
77         require(ValidBankrollAddress[msg.sender], "msg.sender should be a valid bankroll");
78         _;
79     }
80     
81     // Request a payment in tokens to a user FROM the appropriate tokenBankroll 
82     // Figure out the right bankroll via divRate 
83     function RequestBankrollPayment(address to, uint tokens, uint userDivRate) internal {
84         uint tier = ZethrTierLibrary.getTier(userDivRate);
85         address tokenBankrollAddress = UsedBankrollAddresses[tier];
86         ZethrTokenBankroll(tokenBankrollAddress).gameRequestTokens(to, tokens);
87     }
88 }
89 
90 // Contract that contains functions to move divs to the main bankroll
91 contract ZethrShell is ZethrBankrollBridge{
92     
93     // Dump ETH balance to main bankroll 
94     function WithdrawToBankroll() public {
95         address(UsedBankrollAddresses[0]).transfer(address(this).balance);
96     }
97     
98     // Dump divs and dump ETH into bankroll 
99     function WithdrawAndTransferToBankroll() public {
100         Zethr.withdraw();
101         WithdrawToBankroll();
102     }
103 }
104 
105 // Zethr game data setup
106 // Includes all necessary to run with Zethr 
107 contract Zethroll is ZethrShell {
108   using SafeMath for uint;
109 
110   // Makes sure that player profit can't exceed a maximum amount,
111   //  that the bet size is valid, and the playerNumber is in range.
112   modifier betIsValid(uint _betSize, uint _playerNumber, uint divRate) {
113      require(  calculateProfit(_betSize, _playerNumber) < getMaxProfit(divRate)
114              && _betSize >= minBet
115              && _playerNumber >= minNumber
116              && _playerNumber <= maxNumber);
117     _;
118   }
119 
120   // Requires game to be currently active
121   modifier gameIsActive {
122     require(gamePaused == false);
123     _;
124   }
125 
126   // Requires msg.sender to be owner
127   modifier onlyOwner {
128     require(msg.sender == owner);
129     _;
130   }
131 
132   // Constants
133   uint constant private MAX_INT = 2 ** 256 - 1;
134   uint constant public maxProfitDivisor = 1000000;
135   uint public maxNumber = 90;
136   uint public minNumber = 10;
137   uint constant public houseEdgeDivisor = 1000;
138 
139   // Configurables
140   bool public gamePaused;
141   bool public canMining = true;
142   uint public miningProfit = 100;
143   uint public minBetMining = 1e18;
144   address public owner;
145 
146   mapping (uint => uint) public contractBalance;
147   mapping (uint => uint) public maxProfit;
148   uint public houseEdge;
149   uint public maxProfitAsPercentOfHouse;
150   uint public minBet = 0;
151 
152   // Trackers
153   uint public totalBets;
154   uint public totalZTHWagered;
155 
156   // Events
157 
158   // Logs bets + output to web3 for precise 'payout on win' field in UI
159   event LogBet(address sender, uint value, uint rollUnder);
160 
161   // Outputs to web3 UI on bet result
162   // Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send
163   event LogResult(address player, uint result, uint rollUnder, uint profit, uint tokensBetted, bool won);
164 
165   // Logs owner transfers
166   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
167 
168   // Logs changes in maximum profit
169   event MaxProfitChanged(uint _oldMaxProfit, uint _newMaxProfit);
170 
171   // Logs current contract balance
172   event CurrentContractBalance(uint _tokens);
173   
174   constructor (address ZethrMainBankrollAddress) public {
175     setupBankrollInterface(ZethrMainBankrollAddress);
176 
177     // Owner is deployer
178     owner = msg.sender;
179 
180     // Init 990 = 99% (1% houseEdge)
181     houseEdge = 990;
182 
183     // The maximum profit from each bet is 10% of the contract balance.
184     ownerSetMaxProfitAsPercentOfHouse(200000);
185 
186     // Init min bet (1 ZTH)
187     ownerSetMinBet(1e18);
188     
189     canMining = false;
190     miningProfit = 100;
191     minBetMining = 1e18;
192   }
193 
194   // Returns a random number using a specified block number
195   // Always use a FUTURE block number.
196   function maxRandom(uint blockn, address entropy) public view returns (uint256 randomNumber) {
197     return uint256(keccak256(
198         abi.encodePacked(
199         blockhash(blockn),
200         entropy)
201       ));
202   }
203 
204   // Random helper
205   function random(uint256 upper, uint256 blockn, address entropy) public view returns (uint256 randomNumber) {
206     return maxRandom(blockn, entropy) % upper;
207   }
208 
209   // Calculate the maximum potential profit
210   function calculateProfit(uint _initBet, uint _roll)
211     private
212     view
213     returns (uint)
214   {
215     return ((((_initBet * (100 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
216   }
217 
218   // I present a struct which takes only 20k gas
219   struct playerRoll{
220     uint192 tokenValue; // Token value in uint 
221     uint48 blockn;      // Block number 48 bits 
222     uint8 rollUnder;    // Roll under 8 bits
223     uint8 divRate;      // Divrate, 8 bits 
224   }
225 
226   // Mapping because a player can do one roll at a time
227   mapping(address => playerRoll) public playerRolls;
228 
229   // The actual roll function
230   function _playerRollDice(uint _rollUnder, TKN _tkn, uint userDivRate) private
231     gameIsActive
232     betIsValid(_tkn.value, _rollUnder, userDivRate)
233   {
234     require(_tkn.value < ((2 ** 192) - 1));   // Smaller than the storage of 1 uint192;
235     require(block.number < ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint48
236     require(userDivRate < (2 ** 8 - 1)); // This should never throw 
237     // Note that msg.sender is the Token Contract Address
238     // and "_from" is the sender of the tokens
239 
240     playerRoll memory roll = playerRolls[_tkn.sender];
241 
242     // Cannot bet twice in one block 
243     require(block.number != roll.blockn);
244 
245     // If there exists a roll, finish it
246     if (roll.blockn != 0) {
247       _finishBet(_tkn.sender);
248     }
249 
250     // Set struct block number, token value, and rollUnder values
251     roll.blockn = uint48(block.number);
252     roll.tokenValue = uint192(_tkn.value);
253     roll.rollUnder = uint8(_rollUnder);
254     roll.divRate = uint8(userDivRate);
255 
256     // Store the roll struct - 20k gas.
257     playerRolls[_tkn.sender] = roll;
258 
259     // Provides accurate numbers for web3 and allows for manual refunds
260     emit LogBet(_tkn.sender, _tkn.value, _rollUnder);
261                  
262     // Increment total number of bets
263     totalBets += 1;
264 
265     // Total wagered
266     totalZTHWagered += _tkn.value;
267     
268     // game mining
269     if(canMining && roll.tokenValue >= minBetMining){
270         uint miningAmout = SafeMath.div(SafeMath.mul(roll.tokenValue, miningProfit) , 10000);
271         RequestBankrollPayment(_tkn.sender, miningAmout, roll.divRate);
272     }
273   }
274 
275   // Finished the current bet of a player, if they have one
276   function finishBet() public
277     gameIsActive
278     returns (uint)
279   {
280     return _finishBet(msg.sender);
281   }
282 
283   /*
284    * Pay winner, update contract balance
285    * to calculate new max bet, and send reward.
286    */
287   function _finishBet(address target) private returns (uint){
288     playerRoll memory roll = playerRolls[target];
289     require(roll.tokenValue > 0); // No re-entracy
290     require(roll.blockn != block.number);
291     // If the block is more than 255 blocks old, we can't get the result
292     // Also, if the result has already happened, fail as well
293     uint result;
294     if (block.number - roll.blockn > 255) {
295       result = 1000; // Cant win 
296     } else {
297       // Grab the result - random based ONLY on a past block (future when submitted)
298       result = random(100, roll.blockn, target) + 1;
299     }
300 
301     uint rollUnder = roll.rollUnder;
302 
303     if (result < rollUnder) {
304       // Player has won!
305 
306       // Safely map player profit
307       uint profit = calculateProfit(roll.tokenValue, rollUnder);
308       uint mProfit = getMaxProfit(roll.divRate);
309         if (profit > mProfit){
310             profit = mProfit;
311         }
312 
313       // Safely reduce contract balance by player profit
314       subContractBalance(roll.divRate, profit);
315 
316       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
317 
318       // Update maximum profit
319       setMaxProfit(roll.divRate);
320 
321       // Prevent re-entracy memes
322       playerRolls[target] = playerRoll(uint192(0), uint48(0), uint8(0), uint8(0));
323 
324       // Transfer profit plus original bet
325       RequestBankrollPayment(target, profit + roll.tokenValue, roll.divRate);
326       return result;
327 
328     } else {
329       /*
330       * Player has lost
331       * Update contract balance to calculate new max bet
332       */
333       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, false);
334 
335       /*
336       *  Safely adjust contractBalance
337       *  SetMaxProfit
338       */
339       addContractBalance(roll.divRate, roll.tokenValue);
340      
341       playerRolls[target] = playerRoll(uint192(0), uint48(0), uint8(0), uint8(0));
342       // No need to actually delete player roll here since player ALWAYS loses 
343       // Saves gas on next buy 
344 
345       // Update maximum profit
346       setMaxProfit(roll.divRate);
347       
348       return result;
349     }
350   }
351 
352   // TKN struct
353   struct TKN {address sender; uint value;}
354 
355   // Token fallback to bet or deposit from bankroll
356   function execute(address _from, uint _value, uint userDivRate, bytes _data) public fromBankroll gameIsActive returns (bool) {
357       TKN memory _tkn;
358       _tkn.sender = _from;
359       _tkn.value = _value;
360       uint8 chosenNumber = uint8(_data[0]);
361       _playerRollDice(chosenNumber, _tkn, userDivRate);
362 
363     return true;
364   }
365 
366   // Sets max profit
367   function setMaxProfit(uint divRate) internal {
368     //emit CurrentContractBalance(contractBalance);
369     maxProfit[divRate] = (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
370   }
371  
372   // Gets max profit 
373   function getMaxProfit(uint divRate) public view returns (uint){
374       return (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
375   }
376  
377   // Subtracts from the contract balance tracking var 
378   function subContractBalance(uint divRate, uint sub) internal {
379       contractBalance[divRate] = contractBalance[divRate].sub(sub);
380   }
381  
382   // Adds to the contract balance tracking var 
383   function addContractBalance(uint divRate, uint add) internal {
384       contractBalance[divRate] = contractBalance[divRate].add(add);
385   }
386 
387   // Only owner adjust contract balance variable (only used for max profit calc)
388   function ownerUpdateContractBalance(uint newContractBalance, uint divRate) public
389   onlyOwner
390   {
391     contractBalance[divRate] = newContractBalance;
392   }
393   function ownerUpdateMinMaxNumber(uint newMinNumber, uint newMaxNumber) public
394   onlyOwner
395   {
396     minNumber = newMinNumber;
397     maxNumber = newMaxNumber;
398   }
399   // Only owner adjust contract balance variable (only used for max profit calc)
400   function updateContractBalance(uint newContractBalance) public
401   onlyOwner
402   {
403     contractBalance[2] = newContractBalance;
404     setMaxProfit(2);
405     contractBalance[5] = newContractBalance;
406     setMaxProfit(5);
407     contractBalance[10] = newContractBalance;
408     setMaxProfit(10);
409     contractBalance[15] = newContractBalance;
410     setMaxProfit(15);
411     contractBalance[20] = newContractBalance;
412     setMaxProfit(20);
413     contractBalance[25] = newContractBalance;
414     setMaxProfit(25);
415     contractBalance[33] = newContractBalance;
416     setMaxProfit(33);
417   }  
418   // An EXTERNAL update of tokens should be handled here 
419   // This is due to token allocation 
420   // The game should handle internal updates itself (e.g. tokens are betted)
421   function bankrollExternalUpdateTokens(uint divRate, uint newBalance) public fromBankroll {
422       contractBalance[divRate] = newBalance;
423       setMaxProfit(divRate);
424   }
425 
426   // Only owner address can set maxProfitAsPercentOfHouse
427   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
428   onlyOwner
429   {
430     // Restricts each bet to a maximum profit of 20% contractBalance
431     require(newMaxProfitAsPercent <= 200000);
432     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
433     setMaxProfit(2);
434     setMaxProfit(5);
435     setMaxProfit(10);
436     setMaxProfit(15);
437     setMaxProfit(20);
438     setMaxProfit(25);
439     setMaxProfit(33);
440   }
441 
442   // Only owner address can set minBet
443   function ownerSetMinBet(uint newMinimumBet) public
444   onlyOwner
445   {
446     minBet = newMinimumBet;
447   }
448 
449   // Only owner address can set emergency pause #1
450   function ownerSetupBankrollInterface(address ZethrMainBankrollAddress) public
451   onlyOwner
452   {
453     setupBankrollInterface(ZethrMainBankrollAddress);
454   }
455   function ownerPauseGame(bool newStatus) public
456   onlyOwner
457   {
458     gamePaused = newStatus;
459   }
460   function ownerSetCanMining(bool newStatus) public
461   onlyOwner
462   {
463     canMining = newStatus;
464   }
465   function ownerSetMiningProfit(uint newProfit) public
466   onlyOwner
467   {
468     miningProfit = newProfit;
469   }
470   function ownerSetMinBetMining(uint newMinBetMining) public
471   onlyOwner
472   {
473     minBetMining = newMinBetMining;
474   }  
475   // Only owner address can set owner address
476   function ownerChangeOwner(address newOwner) public 
477   onlyOwner
478   {
479     owner = newOwner;
480   }
481 
482   // Only owner address can selfdestruct - emergency
483   function ownerkill() public
484   onlyOwner
485   {
486 
487     selfdestruct(owner);
488   }
489 }
490 
491 /**
492  * @title SafeMath
493  * @dev Math operations with safety checks that throw on error
494  */
495 library SafeMath {
496 
497   /**
498   * @dev Multiplies two numbers, throws on overflow.
499   */
500   function mul(uint a, uint b) internal pure returns (uint) {
501     if (a == 0) {
502       return 0;
503     }
504     uint c = a * b;
505     assert(c / a == b);
506     return c;
507   }
508 
509   /**
510   * @dev Integer division of two numbers, truncating the quotient.
511   */
512   function div(uint a, uint b) internal pure returns (uint) {
513     // assert(b > 0); // Solidity automatically throws when dividing by 0
514     uint c = a / b;
515     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
516     return c;
517   }
518 
519   /**
520   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
521   */
522   function sub(uint a, uint b) internal pure returns (uint) {
523     assert(b <= a);
524     return a - b;
525   }
526 
527   /**
528   * @dev Adds two numbers, throws on overflow.
529   */
530   function add(uint a, uint b) internal pure returns (uint) {
531     uint c = a + b;
532     assert(c >= a);
533     return c;
534   }
535 }