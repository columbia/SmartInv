1 pragma solidity 0.4.25;
2 
3 /*
4  * 0xBtcnnRoll.
5  */
6 
7 contract BTCNNInterface {
8   function getFrontEndTokenBalanceOf(address who) public view returns(uint);
9 
10   function transfer(address _to, uint _value) public returns(bool);
11 
12   function approve(address spender, uint tokens) public returns(bool);
13 }
14 
15 contract BtcnnRoll {
16   using SafeMath
17   for uint;
18 
19   // Makes sure that player profit can't exceed a maximum amount,
20   //  that the bet size is valid, and the playerNumber is in range.
21   modifier betIsValid(uint _betSize, uint _playerNumber) {
22     require(calculateProfit(_betSize, _playerNumber) < maxProfit &&
23       _betSize >= minBet &&
24       _playerNumber > minNumber &&
25       _playerNumber < maxNumber);
26     _;
27   }
28 
29   // Requires game to be currently active
30   modifier gameIsActive {
31     require(gamePaused == false);
32     _;
33   }
34 
35   // Requires msg.sender to be owner
36   modifier onlyOwner {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   // Constants
42   uint constant private MAX_INT = 2 ** 256 - 1;
43   uint constant public maxProfitDivisor = 1000000;
44   uint constant public maxNumber = 99;
45   uint constant public minNumber = 2;
46   uint constant public houseEdgeDivisor = 1000;
47 
48   // Configurables
49   bool public gamePaused;
50 
51   address public owner;
52   address public BTCNNBankroll;
53   address public BTCNNTKNADDR;
54 
55   BTCNNInterface public BTCNNTKN;
56 
57   uint public contractBalance;
58   uint public houseEdge;
59   uint public maxProfit;
60   uint public maxProfitAsPercentOfHouse;
61   uint public minBet = 0;
62 
63   // Trackers
64   uint public totalBets;
65   uint public totalBTCNNWagered;
66 
67   // Events
68 
69   // Logs bets + output to web3 for precise 'payout on win' field in UI
70   event LogBet(address sender, uint value, uint rollUnder);
71 
72   // Outputs to web3 UI on bet result
73   // Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send
74   event LogResult(address indexed player, uint result, uint rollUnder, uint profit, uint tokensBetted, bool won);
75 
76   // Logs owner transfers
77   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
78 
79   // Logs changes in maximum profit
80   event MaxProfitChanged(uint _oldMaxProfit, uint _newMaxProfit);
81 
82   // Logs current contract balance
83   event CurrentContractBalance(uint _tokens);
84 
85   constructor(address btcnntknaddr, address btcnnbankrolladdr) public {
86     // Owner is deployer
87     owner = msg.sender;
88 
89     // Initialize the BTCNN contract and bankroll interfaces
90     BTCNNTKN = BTCNNInterface(btcnntknaddr);
91     BTCNNTKNADDR = btcnntknaddr;
92 
93     // Set the bankroll
94     BTCNNBankroll = btcnnbankrolladdr;
95 
96     // Init 990 = 99% (1% houseEdge)
97     houseEdge = 990;
98 
99     // The maximum profit from each bet is 10% of the contract balance.
100     ownerSetMaxProfitAsPercentOfHouse(10000);
101 
102     // Init min bet (1 BTCNN)
103     ownerSetMinBet(1e18);
104 
105     // Allow 'unlimited' token transfer by the bankroll
106     BTCNNTKN.approve(btcnnbankrolladdr, MAX_INT);
107   }
108 
109   function () public {
110     revert();
111   }
112 
113   // Returns a random number using a specified block number
114   // Always use a FUTURE block number.
115   function maxRandom(uint blockn, address entropy) public view returns(uint256 randomNumber) {
116     return uint256(keccak256(
117       abi.encodePacked(
118         blockhash(blockn),
119         entropy)
120     ));
121   }
122 
123   // Random helper
124   function random(uint256 upper, uint256 blockn, address entropy) internal view returns(uint256 randomNumber) {
125     return maxRandom(blockn, entropy) % upper;
126   }
127 
128   // Calculate the maximum potential profit
129   function calculateProfit(uint _initBet, uint _roll)
130   private
131   view
132   returns(uint) {
133     return ((((_initBet * (100 - (_roll.sub(1)))) / (_roll.sub(1)) + _initBet)) * houseEdge / houseEdgeDivisor) - _initBet;
134   }
135 
136   // I present a struct which takes only 20k gas
137   struct playerRoll {
138     uint200 tokenValue; // Token value in uint
139     uint48 blockn; // Block number 48 bits
140     uint8 rollUnder; // Roll under 8 bits
141   }
142 
143   // Mapping because a player can do one roll at a time
144   mapping(address => playerRoll) public playerRolls;
145 
146   function _playerRollDice(uint _rollUnder, TKN _tkn) private
147   gameIsActive
148   betIsValid(_tkn.value, _rollUnder) {
149     require(_tkn.value < ((2 ** 200) - 1)); // Smaller than the storage of 1 uint200;
150     require(block.number < ((2 ** 48) - 1)); // Current block number smaller than storage of 1 uint48
151 
152     // Note that msg.sender is the Token Contract Address
153     // and "_from" is the sender of the tokens
154 
155     // Check that this is a BTCNN token transfer
156     require(_btcnnToken(msg.sender));
157 
158     playerRoll memory roll = playerRolls[_tkn.sender];
159 
160     // Cannot bet twice in one block
161     require(block.number != roll.blockn);
162 
163     // If there exists a roll, finish it
164     if (roll.blockn != 0) {
165       _finishBet(false, _tkn.sender);
166     }
167 
168     // Set struct block number, token value, and rollUnder values
169     roll.blockn = uint48(block.number);
170     roll.tokenValue = uint200(_tkn.value);
171     roll.rollUnder = uint8(_rollUnder);
172 
173     // Store the roll struct - 20k gas.
174     playerRolls[_tkn.sender] = roll;
175 
176     // Provides accurate numbers for web3 and allows for manual refunds
177     emit LogBet(_tkn.sender, _tkn.value, _rollUnder);
178 
179     // Increment total number of bets
180     totalBets += 1;
181 
182     // Total wagered
183     totalBTCNNWagered += _tkn.value;
184   }
185 
186   // Finished the current bet of a player, if they have one
187   function finishBet() public
188   gameIsActive
189   returns(uint) {
190     return _finishBet(true, msg.sender);
191   }
192 
193   /*
194    * Pay winner, update contract balance
195    * to calculate new max bet, and send reward.
196    */
197   function _finishBet(bool delete_it, address target) private returns(uint) {
198     playerRoll memory roll = playerRolls[target];
199     require(roll.tokenValue > 0); // No re-entracy
200     require(roll.blockn != block.number);
201     // If the block is more than 255 blocks old, we can't get the result
202     // Also, if the result has already happened, fail as well
203     uint result;
204     if (block.number - roll.blockn > 255) {
205       result = 1000; // Cant win
206     } else {
207       // Grab the result - random based ONLY on a past block (future when submitted)
208       result = random(99, roll.blockn, target) + 1;
209     }
210 
211     uint rollUnder = roll.rollUnder;
212 
213     if (result < rollUnder) {
214       // Player has won!
215 
216       // Safely map player profit
217       uint profit = calculateProfit(roll.tokenValue, rollUnder);
218 
219       if (profit > maxProfit) {
220         profit = maxProfit;
221       }
222 
223       // Safely reduce contract balance by player profit
224       contractBalance = contractBalance.sub(profit);
225 
226       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, true);
227 
228       // Update maximum profit
229       setMaxProfit();
230 
231 
232       // Prevent re-entracy memes
233       playerRolls[target] = playerRoll(uint200(0), uint48(0), uint8(0));
234 
235 
236       // Transfer profit plus original bet
237       BTCNNTKN.transfer(target, profit + roll.tokenValue);
238 
239       return result;
240 
241     } else {
242       /*
243        * Player has lost
244        * Update contract balance to calculate new max bet
245        */
246       emit LogResult(target, result, rollUnder, profit, roll.tokenValue, false);
247 
248       /*
249        *  Safely adjust contractBalance
250        *  SetMaxProfit
251        */
252       contractBalance = contractBalance.add(roll.tokenValue);
253 
254       playerRolls[target] = playerRoll(uint200(0), uint48(0), uint8(0));
255       // No need to actually delete player roll here since player ALWAYS loses
256       // Saves gas on next buy
257 
258       // Update maximum profit
259       setMaxProfit();
260 
261       return result;
262     }
263   }
264 
265   // TKN struct
266   struct TKN {
267     address sender;
268     uint value;
269   }
270 
271   // Token fallback to bet or deposit from bankroll
272   function tokenFallback(address _from, uint _value, bytes _data) public returns(bool) {
273     require(msg.sender == BTCNNTKNADDR);
274     if (_from == BTCNNBankroll) {
275       // Update the contract balance
276       contractBalance = contractBalance.add(_value);
277 
278       // Update the maximum profit
279       uint oldMaxProfit = maxProfit;
280       setMaxProfit();
281 
282       emit MaxProfitChanged(oldMaxProfit, maxProfit);
283       return true;
284 
285     } else {
286       TKN memory _tkn;
287       _tkn.sender = _from;
288       _tkn.value = _value;
289       uint8 chosenNumber = uint8(_data[0]);
290       _playerRollDice(chosenNumber, _tkn);
291     }
292 
293     return true;
294   }
295 
296   /*
297    * Sets max profit
298    */
299   function setMaxProfit() internal {
300     emit CurrentContractBalance(contractBalance);
301     maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
302   }
303 
304   // Only owner adjust contract balance variable (only used for max profit calc)
305   function ownerUpdateContractBalance(uint newContractBalance) public
306   onlyOwner {
307     contractBalance = newContractBalance;
308   }
309 
310   // Only owner address can set maxProfitAsPercentOfHouse
311   function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
312   onlyOwner {
313     // Restricts each bet to a maximum profit of 20% contractBalance
314     require(newMaxProfitAsPercent <= 200000);
315     maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
316     setMaxProfit();
317   }
318 
319   // Only owner address can set minBet
320   function ownerSetMinBet(uint newMinimumBet) public
321   onlyOwner {
322     minBet = newMinimumBet;
323   }
324 
325   // Only owner address can transfer BTCNN
326   function ownerTransferBTCNN(address sendTo, uint amount) public
327   onlyOwner {
328     // Safely update contract balance when sending out funds
329     contractBalance = contractBalance.sub(amount);
330 
331     // update max profit
332     setMaxProfit();
333     require(BTCNNTKN.transfer(sendTo, amount));
334     emit LogOwnerTransfer(sendTo, amount);
335   }
336 
337   // Only owner address can set emergency pause #1
338   function ownerPauseGame(bool newStatus) public
339   onlyOwner {
340     gamePaused = newStatus;
341   }
342 
343   // Only owner address can set bankroll address
344   function ownerSetBankroll(address newBankroll) public
345   onlyOwner {
346     BTCNNTKN.approve(BTCNNBankroll, 0);
347     BTCNNBankroll = newBankroll;
348     BTCNNTKN.approve(newBankroll, MAX_INT);
349   }
350 
351   // Only owner address can set owner address
352   function ownerChangeOwner(address newOwner) public
353   onlyOwner {
354     owner = newOwner;
355   }
356 
357   // Only owner address can selfdestruct - emergency
358   function ownerkill() public
359   onlyOwner {
360     BTCNNTKN.transfer(owner, contractBalance);
361     selfdestruct(owner);
362   }
363 
364   function dumpdivs() public {
365 
366     BTCNNTKN.transfer(BTCNNBankroll, BTCNNTKN.getFrontEndTokenBalanceOf(this));
367   }
368 
369   function _btcnnToken(address _tokenContract) private view returns(bool) {
370     return _tokenContract == BTCNNTKNADDR;
371     // Is this the BTCNN token contract?
372   }
373 }
374 
375 /**
376  * @title SafeMath
377  * @dev Math operations with safety checks that throw on error
378  */
379 library SafeMath {
380 
381   /**
382    * @dev Multiplies two numbers, throws on overflow.
383    */
384   function mul(uint a, uint b) internal pure returns(uint) {
385     if (a == 0) {
386       return 0;
387     }
388     uint c = a * b;
389     assert(c / a == b);
390     return c;
391   }
392 
393   /**
394    * @dev Integer division of two numbers, truncating the quotient.
395    */
396   function div(uint a, uint b) internal pure returns(uint) {
397     // assert(b > 0); // Solidity automatically throws when dividing by 0
398     uint c = a / b;
399     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
400     return c;
401   }
402 
403   /**
404    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
405    */
406   function sub(uint a, uint b) internal pure returns(uint) {
407     assert(b <= a);
408     return a - b;
409   }
410 
411   /**
412    * @dev Adds two numbers, throws on overflow.
413    */
414   function add(uint a, uint b) internal pure returns(uint) {
415     uint c = a + b;
416     assert(c >= a);
417     return c;
418   }
419 }