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
66         // Get the bankroll addresses from the main bankroll
67         UsedBankrollAddresses = ZethrMainBankroll(ZethrMainBankrollAddress).gameGetTokenBankrollList();
68         for(uint i=0; i<7; i++){
69             ValidBankrollAddress[UsedBankrollAddresses[i]] = true;
70         }
71     }
72     
73     // Require a function to be called from a *token* bankroll 
74     modifier fromBankroll(){
75         require(ValidBankrollAddress[msg.sender], "msg.sender should be a valid bankroll");
76         _;
77     }
78     
79     // Request a payment in tokens to a user FROM the appropriate tokenBankroll 
80     // Figure out the right bankroll via divRate 
81     function RequestBankrollPayment(address to, uint tokens, uint userDivRate) internal {
82         uint tier = ZethrTierLibrary.getTier(userDivRate);
83         address tokenBankrollAddress = UsedBankrollAddresses[tier];
84         ZethrTokenBankroll(tokenBankrollAddress).gameRequestTokens(to, tokens);
85     }
86 }
87 
88 // Contract that contains functions to move divs to the main bankroll
89 contract ZethrShell is ZethrBankrollBridge{
90     
91     // Dump ETH balance to main bankroll 
92     function WithdrawToBankroll() public {
93         address(UsedBankrollAddresses[0]).transfer(address(this).balance);
94     }
95     
96     // Dump divs and dump ETH into bankroll 
97     function WithdrawAndTransferToBankroll() public {
98         Zethr.withdraw();
99         WithdrawToBankroll();
100     }
101 }
102 
103 // Zethr game data setup
104 // Includes all necessary to run with Zethr 
105 contract Zethroll is ZethrShell {
106   using SafeMath for uint;
107 
108   // Makes sure that player profit can't exceed a maximum amount,
109   //  that the bet size is valid, and the playerNumber is in range.
110   modifier betIsValid(uint _betSize, uint _playerNumber, uint divRate) {
111      require(  calculateProfit(_betSize, _playerNumber) < getMaxProfit(divRate)
112              && _betSize >= minBet
113              && _playerNumber >= minNumber
114              && _playerNumber <= maxNumber);
115     _;
116   }
117 
118   // Requires game to be currently active
119   modifier gameIsActive {
120     require(gamePaused == false);
121     _;
122   }
123 
124   // Requires msg.sender to be owner
125   modifier onlyOwner {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   // Constants
131   uint constant private MAX_INT = 2 ** 256 - 1;
132   uint constant public maxProfitDivisor = 1000000;
133   uint constant public maxNumber = 100;
134   uint constant public minNumber = 2;
135   uint constant public houseEdgeDivisor = 1000;
136 
137   // Configurables
138   bool public gamePaused;
139 
140   address public owner;
141 
142   mapping (uint => uint) public contractBalance;
143   mapping (uint => uint) public maxProfit;
144   uint public houseEdge;
145   uint public maxProfitAsPercentOfHouse;
146   uint public minBet = 0;
147 
148   // Trackers
149   uint public totalBets;
150   uint public totalZTHWagered;
151 
152   // Events
153 
154   // Logs bets + output to web3 for precise 'payout on win' field in UI
155   event LogBet(address sender, uint value, uint rollUnder);
156 
157   // Outputs to web3 UI on bet result
158   // Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send
159   event LogResult(address player, uint result, uint rollUnder, uint profit, uint tokensBetted, bool won);
160 
161   // Logs owner transfers
162   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
163 
164   // Logs changes in maximum profit
165   event MaxProfitChanged(uint _oldMaxProfit, uint _newMaxProfit);
166 
167   // Logs current contract balance
168   event CurrentContractBalance(uint _tokens);
169   
170   constructor (address ZethrMainBankrollAddress) public {
171     setupBankrollInterface(ZethrMainBankrollAddress);
172 
173     // Owner is deployer
174     owner = msg.sender;
175 
176     // Init 990 = 99% (1% houseEdge)
177     houseEdge = 990;
178 
179     // The maximum profit from each bet is 10% of the contract balance.
180     ownerSetMaxProfitAsPercentOfHouse(10000);
181 
182     // Init min bet (1 ZTH)
183     ownerSetMinBet(1e18);
184   }
185 
186   // Returns a random number using a specified block number
187   // Always use a FUTURE block number.
188   function maxRandom(uint blockn, address entropy) public view returns (uint256 randomNumber) {
189     return uint256(keccak256(
190         abi.encodePacked(
191         blockhash(blockn),
192         entropy)
193       ));
194   }
195 
196   // Random helper
197   function random(uint256 upper, uint256 blockn, address entropy) public view returns (uint256 randomNumber) {
198     return maxRandom(blockn, entropy) % upper;
199   }
200 
201   // Calculate the maximum potential profit
202   function calculateProfit(uint _initBet, uint _roll)
203     private
204     view
205     returns (uint)
206   {
207     return ((((_initBet * (100 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
208   }
209 
210   // I present a struct which takes only 20k gas
211   struct playerRoll{
212     uint192 tokenValue; // Token value in uint 
213     uint48 blockn;      // Block number 48 bits 
214     uint8 rollUnder;    // Roll under 8 bits
215     uint8 divRate;      // Divrate, 8 bits 
216   }
217 
218   // Mapping because a player can do one roll at a time
219   mapping(address => playerRoll) public playerRolls;
220 
221   // The actual roll function
222   function _playerRollDice(uint _rollUnder, TKN _tkn, uint userDivRate) private
223     gameIsActive
224     betIsValid(_tkn.value, _rollUnder, userDivRate)
225   {
226     require(_tkn.value < ((2 ** 192) - 1));   // Smaller than the storage of 1 uint192;
227     require(block.number < ((2 ** 48) - 1));  // Current block number smaller than storage of 1 uint48
228     require(userDivRate < (2 ** 8 - 1)); // This should never throw 
229     // Note that msg.sender is the Token Contract Address
230     // and "_from" is the sender of the tokens
231 
232     playerRoll memory roll = playerRolls[_tkn.sender];
233 
234     // Cannot bet twice in one block 
235     require(block.number != roll.blockn);
236 
237     // If there exists a roll, finish it
238     if (roll.blockn != 0) {
239       _finishBet(_tkn.sender);
240     }
241 
242     // Set struct block number, token value, and rollUnder values
243     roll.blockn = uint48(block.number);
244     roll.tokenValue = uint192(_tkn.value);
245     roll.rollUnder = uint8(_rollUnder);
246     roll.divRate = uint8(userDivRate);
247 
248     // Store the roll struct - 20k gas.
249     playerRolls[_tkn.sender] = roll;
250 
251     // Provides accurate numbers for web3 and allows for manual refunds
252     emit LogBet(_tkn.sender, _tkn.value, _rollUnder);
253                  
254     // Increment total number of bets
255     totalBets += 1;
256 
257     // Total wagered
258     totalZTHWagered += _tkn.value;
259   }
260 
261   // Finished the current bet of a player, if they have one
262   function finishBet() public
263     gameIsActive
264     returns (uint)
265   {
266     return _finishBet(msg.sender);
267   }
268 
269   /*
270    * Pay winner, update contract balance
271    * to calculate new max bet, and send reward.
272    */
273   function _finishBet(address target) private returns (uint){
274     playerRoll memory roll = playerRolls[target];
275     require(roll.tokenValue > 0); // No re-entracy
276     require(roll.blockn != block.number);
277     // If the block is more than 255 blocks old, we can't get the result
278     // Also, if the result has already happened, fail as well
279     uint result;
280     if (block.number - roll.blockn > 255) {
281       result = 1000; // Cant win 
282     } else {
283       // Grab the result - random based ONLY on a past block (future when submitted)
284       result = random(100, roll.blockn, target) + 1;
285     }
286 
287     uint rollUnder = roll.rollUnder;
288 
289     if (result < rollUnder) {
290       // Player has won!
291 
292       // Safely map player profit
293       uint profit = calculateProfit(roll.tokenValue, rollUnder);
294       uint mProfit = getMaxProfit(roll.divRate);
295         if (profit > mProfit){
296             profit = mProfit;
297         }
298 
299       // Safely reduce contract balance by player profit
300       subContractBalance(roll.divRate, profit);
301 
302       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
303 
304       // Update maximum profit
305       setMaxProfit(roll.divRate);
306 
307       // Prevent re-entracy memes
308       playerRolls[target] = playerRoll(uint192(0), uint48(0), uint8(0), uint8(0));
309 
310       // Transfer profit plus original bet
311       RequestBankrollPayment(target, profit + roll.tokenValue, roll.divRate);
312       return result;
313 
314     } else {
315       /*
316       * Player has lost
317       * Update contract balance to calculate new max bet
318       */
319       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, false);
320 
321       /*
322       *  Safely adjust contractBalance
323       *  SetMaxProfit
324       */
325       addContractBalance(roll.divRate, roll.tokenValue);
326      
327       playerRolls[target] = playerRoll(uint192(0), uint48(0), uint8(0), uint8(0));
328       // No need to actually delete player roll here since player ALWAYS loses 
329       // Saves gas on next buy 
330 
331       // Update maximum profit
332       setMaxProfit(roll.divRate);
333       
334       return result;
335     }
336   }
337 
338   // TKN struct
339   struct TKN {address sender; uint value;}
340 
341   // Token fallback to bet or deposit from bankroll
342   function execute(address _from, uint _value, uint userDivRate, bytes _data) public fromBankroll gameIsActive returns (bool) {
343       TKN memory _tkn;
344       _tkn.sender = _from;
345       _tkn.value = _value;
346       uint8 chosenNumber = uint8(_data[0]);
347       _playerRollDice(chosenNumber, _tkn, userDivRate);
348 
349     return true;
350   }
351 
352   // Sets max profit
353   function setMaxProfit(uint divRate) internal {
354     //emit CurrentContractBalance(contractBalance);
355     maxProfit[divRate] = (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
356   }
357  
358   // Gets max profit 
359   function getMaxProfit(uint divRate) public view returns (uint){
360       return (contractBalance[divRate] * maxProfitAsPercentOfHouse) / maxProfitDivisor;
361   }
362  
363   // Subtracts from the contract balance tracking var 
364   function subContractBalance(uint divRate, uint sub) internal {
365       contractBalance[divRate] = contractBalance[divRate].sub(sub);
366   }
367  
368   // Adds to the contract balance tracking var 
369   function addContractBalance(uint divRate, uint add) internal {
370       contractBalance[divRate] = contractBalance[divRate].add(add);
371   }
372 
373   // Only owner adjust contract balance variable (only used for max profit calc)
374   function ownerUpdateContractBalance(uint newContractBalance, uint divRate) public
375   onlyOwner
376   {
377     contractBalance[divRate] = newContractBalance;
378   }
379   
380   // An EXTERNAL update of tokens should be handled here 
381   // This is due to token allocation 
382   // The game should handle internal updates itself (e.g. tokens are betted)
383   function bankrollExternalUpdateTokens(uint divRate, uint newBalance) public fromBankroll {
384       contractBalance[divRate] = newBalance;
385       setMaxProfit(divRate);
386   }
387 
388   // Only owner address can set maxProfitAsPercentOfHouse
389   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
390   onlyOwner
391   {
392     // Restricts each bet to a maximum profit of 20% contractBalance
393     require(newMaxProfitAsPercent <= 200000);
394     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
395     setMaxProfit(2);
396     setMaxProfit(5);
397     setMaxProfit(10);
398     setMaxProfit(15);
399     setMaxProfit(20);
400     setMaxProfit(25);
401     setMaxProfit(33);
402   }
403 
404   // Only owner address can set minBet
405   function ownerSetMinBet(uint newMinimumBet) public
406   onlyOwner
407   {
408     minBet = newMinimumBet;
409   }
410 
411   // Only owner address can set emergency pause #1
412   function ownerPauseGame(bool newStatus) public
413   onlyOwner
414   {
415     gamePaused = newStatus;
416   }
417 
418   // Only owner address can set owner address
419   function ownerChangeOwner(address newOwner) public 
420   onlyOwner
421   {
422     owner = newOwner;
423   }
424 
425   // Only owner address can selfdestruct - emergency
426   function ownerkill() public
427   onlyOwner
428   {
429 
430     selfdestruct(owner);
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