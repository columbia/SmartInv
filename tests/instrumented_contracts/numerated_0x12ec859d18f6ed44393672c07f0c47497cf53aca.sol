1 pragma solidity 0.4.25;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that revert on error
6 */
7 library SafeMath {
8   
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19     
20     uint256 c = a * b;
21     require(c / a == b);
22     
23     return c;
24   }
25   
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     
34     return c;
35   }
36   
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43     
44     return c;
45   }
46   
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53     
54     return c;
55   }
56   
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract BMRoll {
68   using SafeMath for uint256;
69   /*
70   * checks player profit, bet size and player number is within range
71   */
72   modifier betIsValid(uint _betSize, uint _playerNumber) {
73     require(_betSize >= minBet && _playerNumber >= minNumber && _playerNumber <= maxNumber && (((((_betSize * (100-(_playerNumber.sub(1)))) / (_playerNumber.sub(1))+_betSize))*houseEdge/houseEdgeDivisor)-_betSize <= maxProfit));
74     _;
75   }
76   
77   /*
78   * checks game is currently active
79   */
80   modifier gameIsActive {
81     require(gamePaused == false);
82     _;
83   }
84   
85   /*
86   * checks payouts are currently active
87   */
88   modifier payoutsAreActive {
89     require(payoutsPaused == false);
90     _;
91   }
92   /*
93   * checks only owner address is calling
94   */
95   modifier onlyOwner {
96     require(msg.sender == owner);
97     _;
98   }
99   
100   /*
101   * checks only treasury address is calling
102   */
103   modifier onlyTreasury {
104     require (msg.sender == treasury);
105     _;
106   }
107   
108   /*
109   * game vars
110   */
111   uint constant public maxProfitDivisor = 1000000;
112   uint constant public houseEdgeDivisor = 1000;
113   uint constant public maxNumber = 99;
114   uint constant public minNumber = 2;
115   bool public gamePaused;
116   address public owner;
117   address public server;
118   bool public payoutsPaused;
119   address public treasury;
120   uint public contractBalance;
121   uint public houseEdge;
122   uint public maxProfit;
123   uint public maxProfitAsPercentOfHouse;
124   uint public minBet;
125   
126   uint public totalBets = 0;
127   uint public totalSunWon = 0;
128   uint public totalSunWagered = 0;
129   
130   address[100] lastUser;
131   
132   /*
133   * player vars
134   */
135   mapping (uint => address) playerAddress;
136   mapping (uint => address) playerTempAddress;
137   mapping (uint => uint) playerBetValue;
138   mapping (uint => uint) playerTempBetValue;
139   mapping (uint => uint) playerDieResult;
140   mapping (uint => uint) playerNumber;
141   mapping (address => uint) playerPendingWithdrawals;
142   mapping (uint => uint) playerProfit;
143   mapping (uint => uint) playerTempReward;
144   
145   /*
146   * events
147   */
148   /* output to web3 UI on bet result*/
149   /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
150   event LogResult(uint indexed BetID, address indexed PlayerAddress, uint PlayerNumber, uint DiceResult, uint ProfitValue, uint BetValue, int Status);
151   /* log owner transfers */
152   event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
153   
154   /*
155   * init
156   */
157   constructor() public {
158     
159     owner = msg.sender;
160     treasury = msg.sender;
161     /* init 980 = 98% (2% houseEdge)*/
162     ownerSetHouseEdge(980);
163     /* init 50,000 = 5% */
164     ownerSetMaxProfitAsPercentOfHouse(50000);
165     /* init min bet (0.1 eth) */
166     ownerSetMinBet(100000000000000000);   
167   }
168   
169   /*
170   * public function
171   * player submit bet
172   * only if game is active & bet is valid can rollDice
173   */
174   function playerRollDice(uint rollUnder) public
175   payable
176   gameIsActive
177   betIsValid(msg.value, rollUnder)
178   {
179     /* total number of bets */
180     
181     lastUser[totalBets % 100] = msg.sender;
182     totalBets += 1;
183     
184     /* map player lucky number to totalBets */
185     playerNumber[totalBets] = rollUnder;
186     /* map value of wager to totalBets */
187     playerBetValue[totalBets] = msg.value;
188     /* map player address to totalBets */
189     playerAddress[totalBets] = msg.sender;
190     /* safely map player profit to totalBets */
191     playerProfit[totalBets] = ((((msg.value * (100-(rollUnder.sub(1)))) / (rollUnder.sub(1))+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;
192     
193     //rand result
194     uint256 random1 = uint256(blockhash(block.number-1));
195     uint256 random2 = uint256(lastUser[random1 % 100]);
196     uint256 random3 = uint256(block.coinbase) + random2;
197     uint256 result = uint256(keccak256(abi.encodePacked(random1 + random2 + random3 + now + totalBets))) % 100 + 1; // this is an efficient way to get the uint out in the [0, maxRange] range;
198     
199     /* map random result to player */
200     playerDieResult[totalBets] = result;
201     /* get the playerAddress for this query id */
202     playerTempAddress[totalBets] = playerAddress[totalBets];
203     /* delete playerAddress for this query id */
204     delete playerAddress[totalBets];
205     
206     /* map the playerProfit for this query id */
207     playerTempReward[totalBets] = playerProfit[totalBets];
208     /* set playerProfit for this query id to 0 */
209     playerProfit[totalBets] = 0;
210     
211     /* map the playerBetValue for this query id */
212     playerTempBetValue[totalBets] = playerBetValue[totalBets];
213     /* set playerBetValue for this query id to 0 */
214     playerBetValue[totalBets] = 0;
215     
216     /* total wagered */
217     totalSunWagered += playerTempBetValue[totalBets];
218     
219     /*
220     * pay winner
221     * update contract balance to calculate new max bet
222     * send reward
223     * if send of reward fails save value to playerPendingWithdrawals
224     */
225     if(playerDieResult[totalBets] < playerNumber[totalBets]){
226       
227       /* safely reduce contract balance by player profit */
228       contractBalance = contractBalance.sub(playerTempReward[totalBets]);
229       
230       /* update total sun won */
231       totalSunWon = totalSunWon.add(playerTempReward[totalBets]);
232       
233       /* safely calculate payout via profit plus original wager */
234       playerTempReward[totalBets] = playerTempReward[totalBets].add(playerTempBetValue[totalBets]);
235       
236       emit LogResult(totalBets, playerTempAddress[totalBets], playerNumber[totalBets], playerDieResult[totalBets], playerTempReward[totalBets], playerTempBetValue[totalBets],1);
237       
238       /* update maximum profit */
239       setMaxProfit();
240       
241       /*
242       * send win - external call to an untrusted contract
243       * if send fails map reward value to playerPendingWithdrawals[address]
244       * for withdrawal later via playerWithdrawPendingTransactions
245       */
246       if(!playerTempAddress[totalBets].send(playerTempReward[totalBets])){
247         emit LogResult(totalBets, playerTempAddress[totalBets], playerNumber[totalBets], playerDieResult[totalBets], playerTempReward[totalBets], playerTempBetValue[totalBets], 2);
248         /* if send failed let player withdraw via playerWithdrawPendingTransactions */
249         playerPendingWithdrawals[playerTempAddress[totalBets]] = playerPendingWithdrawals[playerTempAddress[totalBets]].add(playerTempReward[totalBets]);
250       }
251       
252       return;
253       
254     }
255     
256     /*
257     * no win
258     * send 1 sun to a losing bet
259     * update contract balance to calculate new max bet
260     */
261     if(playerDieResult[totalBets] >= playerNumber[totalBets]){
262       
263       emit LogResult(totalBets, playerTempAddress[totalBets], playerNumber[totalBets], playerDieResult[totalBets], 0, playerTempBetValue[totalBets], 0);
264       
265       /*
266       * safe adjust contractBalance
267       * setMaxProfit
268       * send 1 sun to losing bet
269       */
270       contractBalance = contractBalance.add((playerTempBetValue[totalBets]-1));
271       
272       /* update maximum profit */
273       setMaxProfit();
274       
275       /*
276       * send 1 sun - external call to an untrusted contract
277       */
278       if(!playerTempAddress[totalBets].send(1)){
279         /* if send failed let player withdraw via playerWithdrawPendingTransactions */
280         playerPendingWithdrawals[playerTempAddress[totalBets]] = playerPendingWithdrawals[playerTempAddress[totalBets]].add(1);
281       }
282       
283       return;
284       
285     }
286   }
287   
288   /*
289   * public function
290   * in case of a failed refund or win send
291   */
292   function playerWithdrawPendingTransactions() public
293   payoutsAreActive
294   returns (bool)
295   {
296     uint withdrawAmount = playerPendingWithdrawals[msg.sender];
297     playerPendingWithdrawals[msg.sender] = 0;
298     /* external call to untrusted contract */
299     if (msg.sender.call.value(withdrawAmount)()) {
300       return true;
301       } else {
302         /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
303         /* player can try to withdraw again later */
304         playerPendingWithdrawals[msg.sender] = withdrawAmount;
305         return false;
306       }
307     }
308     
309     /* check for pending withdrawals */
310     function playerGetPendingTxByAddress(address addressToCheck) public view returns (uint) {
311       return playerPendingWithdrawals[addressToCheck];
312     }
313     
314     /* get game status */
315     function getGameStatus() public view returns(uint, uint, uint, uint, uint, uint) {
316       return (minBet, minNumber, maxNumber, houseEdge, houseEdgeDivisor, maxProfit);
317     }
318     
319     /*
320     * internal function
321     * sets max profit
322     */
323     function setMaxProfit() internal {
324       maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;
325     }
326     
327     /*
328     * owner/treasury address only functions
329     */
330     function ()
331         payable public
332         onlyTreasury
333     {
334       /* safely update contract balance */
335       contractBalance = contractBalance.add(msg.value);
336       /* update the maximum profit */
337       setMaxProfit();
338     }
339     
340     /* only owner adjust contract balance variable (only used for max profit calc) */
341     function ownerUpdateContractBalance(uint newContractBalanceInSun) public
342     onlyOwner
343     {
344       contractBalance = newContractBalanceInSun;
345     }
346     
347     /* only owner address can set houseEdge */
348     function ownerSetHouseEdge(uint newHouseEdge) public
349     onlyOwner
350     {
351       houseEdge = newHouseEdge;
352     }
353     
354     /* only owner address can set maxProfitAsPercentOfHouse */
355     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
356     onlyOwner
357     {
358       /* restrict each bet to a maximum profit of 5% contractBalance */
359       require(newMaxProfitAsPercent <= 50000);
360       maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
361       setMaxProfit();
362     }
363     
364     /* only owner address can set minBet */
365     function ownerSetMinBet(uint newMinimumBet) public
366     onlyOwner
367     {
368       minBet = newMinimumBet;
369     }
370     
371     /* only owner address can transfer eth */
372     function ownerTransferEth(address sendTo, uint amount) public
373     onlyOwner
374     {
375       /* safely update contract balance when sending out funds*/
376       contractBalance = contractBalance.sub(amount);
377       /* update max profit */
378       setMaxProfit();
379       if(!sendTo.send(amount)) revert();
380       emit LogOwnerTransfer(sendTo, amount);
381     }
382     
383     
384     /* only owner address can set emergency pause #1 */
385     function ownerPauseGame(bool newStatus) public
386     onlyOwner
387     {
388       gamePaused = newStatus;
389     }
390     
391     /* only owner address can set emergency pause #2 */
392     function ownerPausePayouts(bool newPayoutStatus) public
393     onlyOwner
394     {
395       payoutsPaused = newPayoutStatus;
396     }
397     
398     /* only owner address can set treasury address */
399     function ownerSetTreasury(address newTreasury) public
400     onlyOwner
401     {
402       treasury = newTreasury;
403     }
404     
405     /* only owner address can set owner address */
406     function ownerChangeOwner(address newOwner) public
407     onlyOwner
408     {
409       require(newOwner != 0);
410       owner = newOwner;
411     }
412     
413     /* only owner address can suicide - emergency */
414     function ownerkill() public
415     onlyOwner
416     {
417       selfdestruct(owner);
418     }
419     
420     
421   }