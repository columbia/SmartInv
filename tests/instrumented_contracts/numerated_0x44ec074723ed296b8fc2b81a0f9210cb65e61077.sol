1 pragma solidity ^0.4.18;
2 
3 contract DSSafeAddSub {
4     function safeToAdd(uint a, uint b) internal returns (bool) {
5         return (a + b >= a);
6     }
7 
8     function safeAdd(uint a, uint b) internal returns (uint) {
9         if (!safeToAdd(a, b)) throw;
10         return a + b;
11     }
12 
13     function safeToSubtract(uint a, uint b) internal returns (bool) {
14         return (b <= a);
15     }
16 
17     function safeSub(uint a, uint b) internal returns (uint) {
18         if (!safeToSubtract(a, b)) throw;
19         return a - b;
20     }
21 }
22 
23 
24 contract LuckyDice is DSSafeAddSub {
25 
26     /*
27      * bet size >= minBet, minNumber < minRollLimit < maxRollLimit - 1 < maxNumber
28     */
29     modifier betIsValid(uint _betSize, uint minRollLimit, uint maxRollLimit) {
30         if (_betSize < minBet || maxRollLimit < minNumber || minRollLimit > maxNumber || maxRollLimit - 1 <= minRollLimit) throw;
31         _;
32     }
33 
34     /*
35      * checks game is currently active
36     */
37     modifier gameIsActive {
38         if (gamePaused == true) throw;
39         _;
40     }
41 
42     /*
43      * checks payouts are currently active
44     */
45     modifier payoutsAreActive {
46         if (payoutsPaused == true) throw;
47         _;
48     }
49 
50 
51     /*
52      * checks only owner address is calling
53     */
54     modifier onlyOwner {
55         if (msg.sender != owner) throw;
56         _;
57     }
58 
59     /*
60      * checks only treasury address is calling
61     */
62     modifier onlyCasino {
63         if (msg.sender != casino) throw;
64         _;
65     }
66 
67     /*
68      * probabilities
69     */
70     uint[] rollSumProbability = [0, 0, 0, 0, 0, 128600, 643004, 1929012, 4501028, 9002057, 16203703, 26363168, 39223251, 54012345, 69444444, 83719135, 94521604, 100308641, 100308641, 94521604, 83719135, 69444444, 54012345, 39223251, 26363168, 16203703, 9002057, 4501028, 1929012, 643004, 128600];
71     uint probabilityDivisor = 10000000;
72 
73     /*
74      * game vars
75     */
76     uint constant public maxProfitDivisor = 1000000;
77     uint constant public houseEdgeDivisor = 1000;
78     uint constant public maxNumber = 30;
79     uint constant public minNumber = 5;
80     bool public gamePaused;
81     address public owner;
82     bool public payoutsPaused;
83     address public casino;
84     uint public contractBalance;
85     uint public houseEdge;
86     uint public maxProfit;
87     uint public maxProfitAsPercentOfHouse;
88     uint public minBet;
89     int public totalBets;
90     uint public maxPendingPayouts;
91     uint public totalWeiWon = 0;
92     uint public totalWeiWagered = 0;
93 
94     // JP
95     uint public jackpot = 0;
96     uint public jpPercentage = 40; // = 4%
97     uint public jpPercentageDivisor = 1000;
98     uint public jpMinBet = 10000000000000000; // = 0.01 Eth
99 
100     // TEMP
101     uint tempDiceSum;
102     bool tempJp;
103     uint tempDiceValue;
104     bytes tempRollResult;
105     uint tempFullprofit;
106 
107     /*
108      * player vars
109     */
110     mapping(bytes32 => address) public playerAddress;
111     mapping(bytes32 => address) playerTempAddress;
112     mapping(bytes32 => bytes32) playerBetDiceRollHash;
113     mapping(bytes32 => uint) playerBetValue;
114     mapping(bytes32 => uint) playerTempBetValue;
115     mapping(bytes32 => uint) playerRollResult;
116     mapping(bytes32 => uint) playerMaxRollLimit;
117     mapping(bytes32 => uint) playerMinRollLimit;
118     mapping(address => uint) playerPendingWithdrawals;
119     mapping(bytes32 => uint) playerProfit;
120     mapping(bytes32 => uint) playerToJackpot;
121     mapping(bytes32 => uint) playerTempReward;
122 
123     /*
124      * events
125     */
126     /* log bets + output to web3 for precise 'payout on win' field in UI */
127     event LogBet(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint ProfitValue, uint ToJpValue,
128         uint BetValue, uint minRollLimit, uint maxRollLimit);
129 
130     /* output to web3 UI on bet result*/
131     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
132     event LogResult(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint minRollLimit, uint maxRollLimit,
133         uint DiceResult, uint Value, string Salt, int Status);
134 
135     /* log manual refunds */
136     event LogRefund(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint indexed RefundValue);
137 
138     /* log owner transfers */
139     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
140 
141     // jp logging
142     // Status: 0=win JP, 1=failed send
143     event LogJpPayment(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint DiceResult, uint JackpotValue,
144         int Status);
145 
146 
147     /*
148      * init
149     */
150     function LuckyDice() {
151 
152         owner = msg.sender;
153         casino = msg.sender;
154 
155         /* init 960 = 96% (4% houseEdge)*/
156         ownerSetHouseEdge(960);
157 
158         /* 10,000 = 1%; 55,556 = 5.5556%  */
159         ownerSetMaxProfitAsPercentOfHouse(55556);
160 
161         /* init min bet (0.1 ether) */
162         ownerSetMinBet(100000000000000000);
163     }
164 
165     /*
166      * public function
167      * player submit bet
168      * only if game is active & bet is valid
169     */
170     function playerMakeBet(uint minRollLimit, uint maxRollLimit, bytes32 diceRollHash, uint8 v, bytes32 r, bytes32 s) public
171     payable
172     gameIsActive
173     betIsValid(msg.value, minRollLimit, maxRollLimit)
174     {
175         /* checks if bet was already made */
176         if (playerAddress[diceRollHash] != 0x0) throw;
177 
178         /* checks hash sign */
179         if (casino != ecrecover(diceRollHash, v, r, s)) throw;
180 
181         tempFullprofit = getFullProfit(msg.value, minRollLimit, maxRollLimit);
182         playerProfit[diceRollHash] = getProfit(msg.value, tempFullprofit);
183         playerToJackpot[diceRollHash] = getToJackpot(msg.value, tempFullprofit);
184         if (playerProfit[diceRollHash] - playerToJackpot[diceRollHash] > maxProfit)
185             throw;
186 
187         /* map bet id to serverSeedHash */
188         playerBetDiceRollHash[diceRollHash] = diceRollHash;
189         /* map player limit to serverSeedHash */
190         playerMinRollLimit[diceRollHash] = minRollLimit;
191         playerMaxRollLimit[diceRollHash] = maxRollLimit;
192         /* map value of wager to serverSeedHash */
193         playerBetValue[diceRollHash] = msg.value;
194         /* map player address to serverSeedHash */
195         playerAddress[diceRollHash] = msg.sender;
196         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
197         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[diceRollHash]);
198 
199 
200         /* check contract can payout on win */
201         if (maxPendingPayouts >= contractBalance)
202             throw;
203 
204         /* provides accurate numbers for web3 and allows for manual refunds in case of any error */
205         LogBet(diceRollHash, playerAddress[diceRollHash], playerProfit[diceRollHash], playerToJackpot[diceRollHash],
206             playerBetValue[diceRollHash], playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash]);
207     }
208 
209     function getFullProfit(uint _betSize, uint minRollLimit, uint maxRollLimit) internal returns (uint){
210         uint probabilitySum = 0;
211         for (uint i = minRollLimit + 1; i < maxRollLimit; i++)
212         {
213             probabilitySum += rollSumProbability[i];
214         }
215 
216         return _betSize * safeSub(probabilityDivisor * 100, probabilitySum) / probabilitySum;
217     }
218 
219     function getProfit(uint _betSize, uint fullProfit) internal returns (uint){
220         return (fullProfit + _betSize) * houseEdge / houseEdgeDivisor - _betSize;
221     }
222 
223     function getToJackpot(uint _betSize, uint fullProfit) internal returns (uint){
224         return (fullProfit + _betSize) * jpPercentage / jpPercentageDivisor;
225     }
226 
227     function withdraw(bytes32 diceRollHash, string rollResult, string salt) public
228     payoutsAreActive
229     {
230         /* player address mapped to query id does not exist */
231         if (playerAddress[diceRollHash] == 0x0) throw;
232 
233         /* checks hash */
234         bytes32 hash = sha256(rollResult, salt);
235         if (diceRollHash != hash) throw;
236 
237         /* get the playerAddress for this query id */
238         playerTempAddress[diceRollHash] = playerAddress[diceRollHash];
239         /* delete playerAddress for this query id */
240         delete playerAddress[diceRollHash];
241 
242         /* map the playerProfit for this query id */
243         playerTempReward[diceRollHash] = playerProfit[diceRollHash];
244         /* set  playerProfit for this query id to 0 */
245         playerProfit[diceRollHash] = 0;
246 
247         /* safely reduce maxPendingPayouts liability */
248         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[diceRollHash]);
249 
250         /* map the playerBetValue for this query id */
251         playerTempBetValue[diceRollHash] = playerBetValue[diceRollHash];
252         /* set  playerBetValue for this query id to 0 */
253         playerBetValue[diceRollHash] = 0;
254 
255         /* total number of bets */
256         totalBets += 1;
257 
258         /* total wagered */
259         totalWeiWagered += playerTempBetValue[diceRollHash];
260 
261         tempDiceSum = 0;
262         tempJp = true;
263         tempRollResult = bytes(rollResult);
264         for (uint i = 0; i < 5; i++) {
265             tempDiceValue = uint(tempRollResult[i]) - 48;
266             tempDiceSum += tempDiceValue;
267             playerRollResult[diceRollHash] = playerRollResult[diceRollHash] * 10 + tempDiceValue;
268 
269             if (tempRollResult[i] != tempRollResult[1]) {
270                 tempJp = false;
271             }
272         }
273 
274         /*
275         * CONGRATULATIONS!!! SOMEBODY WON JP!
276         */
277         if (playerTempBetValue[diceRollHash] >= jpMinBet && tempJp) {
278             LogJpPayment(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
279                 playerRollResult[diceRollHash], jackpot, 0);
280 
281             uint jackpotTmp = jackpot;
282             jackpot = 0;
283 
284             if (!playerTempAddress[diceRollHash].send(jackpotTmp)) {
285                 LogJpPayment(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
286                     playerRollResult[diceRollHash], jackpotTmp, 1);
287 
288                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
289                 playerPendingWithdrawals[playerTempAddress[diceRollHash]] =
290                 safeAdd(playerPendingWithdrawals[playerTempAddress[diceRollHash]], jackpotTmp);
291             }
292         }
293 
294         /*
295         * pay winner
296         * update contract balance to calculate new max bet
297         * send reward
298         * if send of reward fails save value to playerPendingWithdrawals
299         */
300         if (playerMinRollLimit[diceRollHash] < tempDiceSum && tempDiceSum < playerMaxRollLimit[diceRollHash]) {
301             /* safely reduce contract balance by player profit */
302             contractBalance = safeSub(contractBalance, playerTempReward[diceRollHash]);
303 
304             /* update total wei won */
305             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[diceRollHash]);
306 
307             // adding JP percentage
308             playerTempReward[diceRollHash] = safeSub(playerTempReward[diceRollHash], playerToJackpot[diceRollHash]);
309             jackpot = safeAdd(jackpot, playerToJackpot[diceRollHash]);
310 
311             /* safely calculate payout via profit plus original wager */
312             playerTempReward[diceRollHash] = safeAdd(playerTempReward[diceRollHash], playerTempBetValue[diceRollHash]);
313 
314             LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
315                 playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
316                 playerTempReward[diceRollHash], salt, 1);
317 
318             /* update maximum profit */
319             setMaxProfit();
320 
321             /*
322             * send win - external call to an untrusted contract
323             * if send fails map reward value to playerPendingWithdrawals[address]
324             * for withdrawal later via playerWithdrawPendingTransactions
325             */
326             if (!playerTempAddress[diceRollHash].send(playerTempReward[diceRollHash])) {
327                 LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
328                     playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
329                     playerTempReward[diceRollHash], salt, 2);
330 
331                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
332                 playerPendingWithdrawals[playerTempAddress[diceRollHash]] =
333                 safeAdd(playerPendingWithdrawals[playerTempAddress[diceRollHash]], playerTempReward[diceRollHash]);
334             }
335 
336             return;
337 
338         } else {
339             /*
340             * no win
341             * update contract balance to calculate new max bet
342             */
343 
344             LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
345                 playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
346                 playerTempBetValue[diceRollHash], salt, 0);
347 
348             /*
349             *  safe adjust contractBalance
350             *  setMaxProfit
351             */
352             contractBalance = safeAdd(contractBalance, (playerTempBetValue[diceRollHash]));
353 
354             /* update maximum profit */
355             setMaxProfit();
356 
357             return;
358         }
359 
360     }
361 
362     /*
363     * public function
364     * in case of a failed refund or win send
365     */
366     function playerWithdrawPendingTransactions() public
367     payoutsAreActive
368     returns (bool)
369     {
370         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
371         playerPendingWithdrawals[msg.sender] = 0;
372         /* external call to untrusted contract */
373         if (msg.sender.call.value(withdrawAmount)()) {
374             return true;
375         } else {
376             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
377             /* player can try to withdraw again later */
378             playerPendingWithdrawals[msg.sender] = withdrawAmount;
379             return false;
380         }
381     }
382 
383     /* check for pending withdrawals  */
384     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
385         return playerPendingWithdrawals[addressToCheck];
386     }
387 
388     /*
389     * internal function
390     * sets max profit
391     */
392     function setMaxProfit() internal {
393         maxProfit = (contractBalance * maxProfitAsPercentOfHouse) / maxProfitDivisor;
394     }
395 
396     /*
397     * owner address only functions
398     */
399     function()
400     payable
401     onlyOwner
402     {
403         /* safely update contract balance */
404         contractBalance = safeAdd(contractBalance, msg.value);
405         /* update the maximum profit */
406         setMaxProfit();
407     }
408 
409 
410     /* only owner adjust contract balance variable (only used for max profit calc) */
411     function ownerUpdateContractBalance(uint newContractBalanceInWei) public
412     onlyOwner
413     {
414         contractBalance = newContractBalanceInWei;
415     }
416 
417     /* only owner address can set houseEdge */
418     function ownerSetHouseEdge(uint newHouseEdge) public
419     onlyOwner
420     {
421         houseEdge = newHouseEdge;
422     }
423 
424     /* only owner address can set maxProfitAsPercentOfHouse */
425     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public
426     onlyOwner
427     {
428         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
429         setMaxProfit();
430     }
431 
432     /* only owner address can set minBet */
433     function ownerSetMinBet(uint newMinimumBet) public
434     onlyOwner
435     {
436         minBet = newMinimumBet;
437     }
438 
439     /* only owner address can set jpMinBet */
440     function ownerSetJpMinBet(uint newJpMinBet) public
441     onlyOwner
442     {
443         jpMinBet = newJpMinBet;
444     }
445 
446     /* only owner address can transfer ether */
447     function ownerTransferEther(address sendTo, uint amount) public
448     onlyOwner
449     {
450         /* safely update contract balance when sending out funds*/
451         contractBalance = safeSub(contractBalance, amount);
452         /* update max profit */
453         setMaxProfit();
454         if (!sendTo.send(amount)) throw;
455         LogOwnerTransfer(sendTo, amount);
456     }
457 
458     /* only owner address can do manual refund
459     * used only if bet placed + server error had a place
460     * filter LogBet by address and/or diceRollHash
461     * check the following logs do not exist for diceRollHash and/or playerAddress[diceRollHash] before refunding:
462     * LogResult or LogRefund
463     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions
464     */
465     function ownerRefundPlayer(bytes32 diceRollHash, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public
466     onlyOwner
467     {
468         /* safely reduce pendingPayouts by playerProfit[rngId] */
469         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
470         /* send refund */
471         if (!sendTo.send(originalPlayerBetValue)) throw;
472         /* log refunds */
473         LogRefund(diceRollHash, sendTo, originalPlayerBetValue);
474     }
475 
476     /* only owner address can set emergency pause #1 */
477     function ownerPauseGame(bool newStatus) public
478     onlyOwner
479     {
480         gamePaused = newStatus;
481     }
482 
483     /* only owner address can set emergency pause #2 */
484     function ownerPausePayouts(bool newPayoutStatus) public
485     onlyOwner
486     {
487         payoutsPaused = newPayoutStatus;
488     }
489 
490     /* only owner address can set casino address */
491     function ownerSetCasino(address newCasino) public
492     onlyOwner
493     {
494         casino = newCasino;
495     }
496 
497     /* only owner address can set owner address */
498     function ownerChangeOwner(address newOwner) public
499     onlyOwner
500     {
501         owner = newOwner;
502     }
503 
504     /* only owner address can suicide - emergency */
505     function ownerkill() public
506     onlyOwner
507     {
508         suicide(owner);
509     }
510 }