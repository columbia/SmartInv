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
76     uint constant public houseEdgeDivisor = 1000;
77     uint constant public maxNumber = 30;
78     uint constant public minNumber = 5;
79     bool public gamePaused;
80     address public owner;
81     bool public payoutsPaused;
82     address public casino;
83     uint public contractBalance;
84     uint public houseEdge;
85     uint public maxProfit;
86     uint public minBet;
87     int public totalBets;
88     uint public maxPendingPayouts;
89     uint public totalWeiWon = 0;
90     uint public totalWeiWagered = 0;
91 
92     // JP
93     uint public jackpot = 0;
94     uint public jpPercentage = 9; // = 0.9%
95     uint public jpPercentageDivisor = 1000;
96     uint public jpMinBet = 10000000000000000; // = 0.01 Eth
97 
98     // TEMP
99     uint tempDiceSum;
100     uint tempJpCounter;
101     uint tempDiceValue;
102     bytes tempRollResult;
103     uint tempFullprofit;
104     bytes32 tempBetHash;
105 
106     /*
107      * player vars
108     */
109     mapping(bytes32 => address) public playerAddress;
110     mapping(bytes32 => address) playerTempAddress;
111     mapping(bytes32 => bytes32) playerBetDiceRollHash;
112     mapping(bytes32 => uint) playerBetValue;
113     mapping(bytes32 => uint) playerTempBetValue;
114     mapping(bytes32 => uint) playerRollResult;
115     mapping(bytes32 => uint) playerMaxRollLimit;
116     mapping(bytes32 => uint) playerMinRollLimit;
117     mapping(address => uint) playerPendingWithdrawals;
118     mapping(bytes32 => uint) playerProfit;
119     mapping(bytes32 => uint) playerToJackpot;
120     mapping(bytes32 => uint) playerTempReward;
121 
122     /*
123      * events
124     */
125     /* log bets + output to web3 for precise 'payout on win' field in UI */
126     event LogBet(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint ProfitValue, uint ToJpValue,
127         uint BetValue, uint minRollLimit, uint maxRollLimit);
128 
129     /* output to web3 UI on bet result*/
130     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
131     event LogResult(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint minRollLimit, uint maxRollLimit,
132         uint DiceResult, uint Value, string Salt, int Status);
133 
134     /* log manual refunds */
135     event LogRefund(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint indexed RefundValue);
136 
137     /* log owner transfers */
138     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);
139 
140     // jp logging
141     // Status: 0=win JP, 1=failed send
142     event LogJpPayment(bytes32 indexed DiceRollHash, address indexed PlayerAddress, uint DiceResult, uint JackpotValue,
143         int Status);
144 
145 
146     /*
147      * init
148     */
149     function LuckyDice() {
150 
151         owner = msg.sender;
152         casino = msg.sender;
153 
154         /* init 990 = 99% (1% houseEdge)*/
155         ownerSetHouseEdge(990);
156 
157         /* 0.5 ether  */
158         ownerSetMaxProfit(500000000000000000);
159 
160         /* init min bet (0.1 ether) */
161         ownerSetMinBet(100000000000000000);
162     }
163 
164     /*
165      * public function
166      * player submit bet
167      * only if game is active & bet is valid
168     */
169     function playerMakeBet(uint minRollLimit, uint maxRollLimit, bytes32 diceRollHash, uint8 v, bytes32 r, bytes32 s) public
170     payable
171     gameIsActive
172     betIsValid(msg.value, minRollLimit, maxRollLimit)
173     {
174         /* checks if bet was already made */
175         if (playerBetDiceRollHash[diceRollHash] != 0x0 || diceRollHash == 0x0) throw;
176 
177         /* checks bet sign */
178         tempBetHash = sha256(diceRollHash, byte(minRollLimit), byte(maxRollLimit), msg.sender);
179         if (casino != ecrecover(tempBetHash, v, r, s)) throw;
180 
181         tempFullprofit = getFullProfit(msg.value, minRollLimit, maxRollLimit);
182         playerProfit[diceRollHash] = getProfit(msg.value, tempFullprofit);
183         if (playerProfit[diceRollHash] > maxProfit)
184             throw;
185 
186         playerToJackpot[diceRollHash] = getToJackpot(msg.value);
187         jackpot = safeAdd(jackpot, playerToJackpot[diceRollHash]);
188         contractBalance = safeSub(contractBalance, playerToJackpot[diceRollHash]);
189 
190         /* map bet id to serverSeedHash */
191         playerBetDiceRollHash[diceRollHash] = diceRollHash;
192         /* map player limit to serverSeedHash */
193         playerMinRollLimit[diceRollHash] = minRollLimit;
194         playerMaxRollLimit[diceRollHash] = maxRollLimit;
195         /* map value of wager to serverSeedHash */
196         playerBetValue[diceRollHash] = msg.value;
197         /* map player address to serverSeedHash */
198         playerAddress[diceRollHash] = msg.sender;
199         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
200         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[diceRollHash]);
201 
202 
203         /* check contract can payout on win */
204         if (maxPendingPayouts >= contractBalance)
205             throw;
206 
207         /* provides accurate numbers for web3 and allows for manual refunds in case of any error */
208         LogBet(diceRollHash, playerAddress[diceRollHash], playerProfit[diceRollHash], playerToJackpot[diceRollHash],
209             playerBetValue[diceRollHash], playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash]);
210     }
211 
212     function getFullProfit(uint _betSize, uint minRollLimit, uint maxRollLimit) internal returns (uint){
213         uint probabilitySum = 0;
214         for (uint i = minRollLimit + 1; i < maxRollLimit; i++)
215         {
216             probabilitySum += rollSumProbability[i];
217         }
218 
219         return _betSize * safeSub(probabilityDivisor * 100, probabilitySum) / probabilitySum;
220     }
221 
222     function getProfit(uint _betSize, uint fullProfit) internal returns (uint){
223         return (fullProfit + _betSize) * houseEdge / houseEdgeDivisor - _betSize;
224     }
225 
226     function getToJackpot(uint _betSize) internal returns (uint){
227         return _betSize * jpPercentage / jpPercentageDivisor;
228     }
229 
230     function withdraw(bytes32 diceRollHash, string rollResult, string salt) public
231     payoutsAreActive
232     {
233         /* player address mapped to query id does not exist */
234         if (playerAddress[diceRollHash] == 0x0) throw;
235 
236         /* checks hash */
237         bytes32 hash = sha256(rollResult, salt);
238         if (diceRollHash != hash) throw;
239 
240         /* get the playerAddress for this query id */
241         playerTempAddress[diceRollHash] = playerAddress[diceRollHash];
242         /* delete playerAddress for this query id */
243         delete playerAddress[diceRollHash];
244 
245         /* map the playerProfit for this query id */
246         playerTempReward[diceRollHash] = playerProfit[diceRollHash];
247         /* set  playerProfit for this query id to 0 */
248         playerProfit[diceRollHash] = 0;
249 
250         /* safely reduce maxPendingPayouts liability */
251         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[diceRollHash]);
252 
253         /* map the playerBetValue for this query id */
254         playerTempBetValue[diceRollHash] = playerBetValue[diceRollHash];
255         /* set  playerBetValue for this query id to 0 */
256         playerBetValue[diceRollHash] = 0;
257 
258         /* total number of bets */
259         totalBets += 1;
260 
261         /* total wagered */
262         totalWeiWagered += playerTempBetValue[diceRollHash];
263 
264         tempDiceSum = 0;
265         tempJpCounter = 0;
266         tempRollResult = bytes(rollResult);
267         for (uint i = 0; i < 5; i++) {
268             tempDiceValue = uint(tempRollResult[i]) - 48;
269             tempDiceSum += tempDiceValue;
270             playerRollResult[diceRollHash] = playerRollResult[diceRollHash] * 10 + tempDiceValue;
271 
272             if (tempDiceValue == 5) {
273                 tempJpCounter++;
274             }
275         }
276 
277         /*
278         * CONGRATULATIONS!!! SOMEBODY WON JP!
279         */
280         if (playerTempBetValue[diceRollHash] >= jpMinBet && tempJpCounter >= 4) {
281             LogJpPayment(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
282                 playerRollResult[diceRollHash], jackpot, 0);
283 
284             uint jackpotTmp = jackpot;
285             jackpot = 0;
286 
287             if (!playerTempAddress[diceRollHash].send(jackpotTmp)) {
288                 LogJpPayment(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
289                     playerRollResult[diceRollHash], jackpotTmp, 1);
290 
291                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
292                 playerPendingWithdrawals[playerTempAddress[diceRollHash]] =
293                 safeAdd(playerPendingWithdrawals[playerTempAddress[diceRollHash]], jackpotTmp);
294             }
295         }
296 
297         /*
298         * pay winner
299         * update contract balance to calculate new max bet
300         * send reward
301         * if send of reward fails save value to playerPendingWithdrawals
302         */
303         if (playerMinRollLimit[diceRollHash] < tempDiceSum && tempDiceSum < playerMaxRollLimit[diceRollHash]) {
304             /* safely reduce contract balance by player profit */
305             contractBalance = safeSub(contractBalance, playerTempReward[diceRollHash]);
306 
307             /* update total wei won */
308             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[diceRollHash]);
309 
310             /* safely calculate payout via profit plus original wager */
311             playerTempReward[diceRollHash] = safeAdd(playerTempReward[diceRollHash], playerTempBetValue[diceRollHash]);
312 
313             LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
314                 playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
315                 playerTempReward[diceRollHash], salt, 1);
316 
317             /*
318             * send win - external call to an untrusted contract
319             * if send fails map reward value to playerPendingWithdrawals[address]
320             * for withdrawal later via playerWithdrawPendingTransactions
321             */
322             if (!playerTempAddress[diceRollHash].send(playerTempReward[diceRollHash])) {
323                 LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
324                     playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
325                     playerTempReward[diceRollHash], salt, 2);
326 
327                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
328                 playerPendingWithdrawals[playerTempAddress[diceRollHash]] =
329                 safeAdd(playerPendingWithdrawals[playerTempAddress[diceRollHash]], playerTempReward[diceRollHash]);
330             }
331 
332             return;
333 
334         } else {
335             /*
336             * no win
337             * update contract balance to calculate new max bet
338             */
339 
340             LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
341                 playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
342                 playerTempBetValue[diceRollHash], salt, 0);
343 
344             /*
345             *  safe adjust contractBalance
346             */
347             contractBalance = safeAdd(contractBalance, (playerTempBetValue[diceRollHash]));
348 
349             return;
350         }
351 
352     }
353 
354     /*
355     * public function
356     * in case of a failed refund or win send
357     */
358     function playerWithdrawPendingTransactions() public
359     payoutsAreActive
360     returns (bool)
361     {
362         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
363         playerPendingWithdrawals[msg.sender] = 0;
364         /* external call to untrusted contract */
365         if (msg.sender.call.value(withdrawAmount)()) {
366             return true;
367         } else {
368             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
369             /* player can try to withdraw again later */
370             playerPendingWithdrawals[msg.sender] = withdrawAmount;
371             return false;
372         }
373     }
374 
375     /* check for pending withdrawals  */
376     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
377         return playerPendingWithdrawals[addressToCheck];
378     }
379 
380     /*
381     * owner address only functions
382     */
383     function()
384     payable
385     onlyOwner
386     {
387         /* safely update contract balance */
388         contractBalance = safeAdd(contractBalance, msg.value);
389     }
390 
391 
392     /* only owner adjust contract balance variable (only used for max profit calc) */
393     function ownerUpdateContractBalance(uint newContractBalanceInWei) public
394     onlyOwner
395     {
396         contractBalance = newContractBalanceInWei;
397     }
398 
399     /* only owner address can set houseEdge */
400     function ownerSetHouseEdge(uint newHouseEdge) public
401     onlyOwner
402     {
403         houseEdge = newHouseEdge;
404     }
405 
406     /* only owner address can set maxProfit*/
407     function ownerSetMaxProfit(uint newMaxProfit) public
408     onlyOwner
409     {
410         maxProfit = newMaxProfit;
411     }
412 
413     /* only owner address can set minBet */
414     function ownerSetMinBet(uint newMinimumBet) public
415     onlyOwner
416     {
417         minBet = newMinimumBet;
418     }
419 
420     /* only owner address can set jpMinBet */
421     function ownerSetJpMinBet(uint newJpMinBet) public
422     onlyOwner
423     {
424         jpMinBet = newJpMinBet;
425     }
426 
427     /* only owner address can transfer ether */
428     function ownerTransferEther(address sendTo, uint amount) public
429     onlyOwner
430     {
431         /* safely update contract balance when sending out funds*/
432         contractBalance = safeSub(contractBalance, amount);
433         if (!sendTo.send(amount)) throw;
434         LogOwnerTransfer(sendTo, amount);
435     }
436 
437     /* only owner address can do manual refund
438     * used only if bet placed + server error had a place
439     * filter LogBet by address and/or diceRollHash
440     * check the following logs do not exist for diceRollHash and/or playerAddress[diceRollHash] before refunding:
441     * LogResult or LogRefund
442     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions
443     */
444     function ownerRefundPlayer(bytes32 diceRollHash, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public
445     onlyOwner
446     {
447         /* safely reduce pendingPayouts by playerProfit[rngId] */
448         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
449         /* send refund */
450         if (!sendTo.send(originalPlayerBetValue)) throw;
451         /* log refunds */
452         LogRefund(diceRollHash, sendTo, originalPlayerBetValue);
453     }
454 
455     /* only owner address can set emergency pause #1 */
456     function ownerPauseGame(bool newStatus) public
457     onlyOwner
458     {
459         gamePaused = newStatus;
460     }
461 
462     /* only owner address can set emergency pause #2 */
463     function ownerPausePayouts(bool newPayoutStatus) public
464     onlyOwner
465     {
466         payoutsPaused = newPayoutStatus;
467     }
468 
469     /* only owner address can set casino address */
470     function ownerSetCasino(address newCasino) public
471     onlyOwner
472     {
473         casino = newCasino;
474     }
475 
476     /* only owner address can set owner address */
477     function ownerChangeOwner(address newOwner) public
478     onlyOwner
479     {
480         owner = newOwner;
481     }
482 
483     /* only owner address can suicide - emergency */
484     function ownerkill() public
485     onlyOwner
486     {
487         suicide(owner);
488     }
489 }