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
94     uint public jpPercentage = 40; // = 4%
95     uint public jpPercentageDivisor = 1000;
96     uint public jpMinBet = 10000000000000000; // = 0.01 Eth
97 
98     // TEMP
99     uint tempDiceSum;
100     bool tempJp;
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
154         /* init 960 = 96% (4% houseEdge)*/
155         ownerSetHouseEdge(960);
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
318             /*
319             * send win - external call to an untrusted contract
320             * if send fails map reward value to playerPendingWithdrawals[address]
321             * for withdrawal later via playerWithdrawPendingTransactions
322             */
323             if (!playerTempAddress[diceRollHash].send(playerTempReward[diceRollHash])) {
324                 LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
325                     playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
326                     playerTempReward[diceRollHash], salt, 2);
327 
328                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
329                 playerPendingWithdrawals[playerTempAddress[diceRollHash]] =
330                 safeAdd(playerPendingWithdrawals[playerTempAddress[diceRollHash]], playerTempReward[diceRollHash]);
331             }
332 
333             return;
334 
335         } else {
336             /*
337             * no win
338             * update contract balance to calculate new max bet
339             */
340 
341             LogResult(playerBetDiceRollHash[diceRollHash], playerTempAddress[diceRollHash],
342                 playerMinRollLimit[diceRollHash], playerMaxRollLimit[diceRollHash], playerRollResult[diceRollHash],
343                 playerTempBetValue[diceRollHash], salt, 0);
344 
345             /*
346             *  safe adjust contractBalance
347             */
348             contractBalance = safeAdd(contractBalance, (playerTempBetValue[diceRollHash]));
349 
350             return;
351         }
352 
353     }
354 
355     /*
356     * public function
357     * in case of a failed refund or win send
358     */
359     function playerWithdrawPendingTransactions() public
360     payoutsAreActive
361     returns (bool)
362     {
363         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
364         playerPendingWithdrawals[msg.sender] = 0;
365         /* external call to untrusted contract */
366         if (msg.sender.call.value(withdrawAmount)()) {
367             return true;
368         } else {
369             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
370             /* player can try to withdraw again later */
371             playerPendingWithdrawals[msg.sender] = withdrawAmount;
372             return false;
373         }
374     }
375 
376     /* check for pending withdrawals  */
377     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
378         return playerPendingWithdrawals[addressToCheck];
379     }
380 
381     /*
382     * owner address only functions
383     */
384     function()
385     payable
386     onlyOwner
387     {
388         /* safely update contract balance */
389         contractBalance = safeAdd(contractBalance, msg.value);
390     }
391 
392 
393     /* only owner adjust contract balance variable (only used for max profit calc) */
394     function ownerUpdateContractBalance(uint newContractBalanceInWei) public
395     onlyOwner
396     {
397         contractBalance = newContractBalanceInWei;
398     }
399 
400     /* only owner address can set houseEdge */
401     function ownerSetHouseEdge(uint newHouseEdge) public
402     onlyOwner
403     {
404         houseEdge = newHouseEdge;
405     }
406 
407     /* only owner address can set maxProfit*/
408     function ownerSetMaxProfit(uint newMaxProfit) public
409     onlyOwner
410     {
411         maxProfit = newMaxProfit;
412     }
413 
414     /* only owner address can set minBet */
415     function ownerSetMinBet(uint newMinimumBet) public
416     onlyOwner
417     {
418         minBet = newMinimumBet;
419     }
420 
421     /* only owner address can set jpMinBet */
422     function ownerSetJpMinBet(uint newJpMinBet) public
423     onlyOwner
424     {
425         jpMinBet = newJpMinBet;
426     }
427 
428     /* only owner address can transfer ether */
429     function ownerTransferEther(address sendTo, uint amount) public
430     onlyOwner
431     {
432         /* safely update contract balance when sending out funds*/
433         contractBalance = safeSub(contractBalance, amount);
434         if (!sendTo.send(amount)) throw;
435         LogOwnerTransfer(sendTo, amount);
436     }
437 
438     /* only owner address can do manual refund
439     * used only if bet placed + server error had a place
440     * filter LogBet by address and/or diceRollHash
441     * check the following logs do not exist for diceRollHash and/or playerAddress[diceRollHash] before refunding:
442     * LogResult or LogRefund
443     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions
444     */
445     function ownerRefundPlayer(bytes32 diceRollHash, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public
446     onlyOwner
447     {
448         /* safely reduce pendingPayouts by playerProfit[rngId] */
449         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
450         /* send refund */
451         if (!sendTo.send(originalPlayerBetValue)) throw;
452         /* log refunds */
453         LogRefund(diceRollHash, sendTo, originalPlayerBetValue);
454     }
455 
456     /* only owner address can set emergency pause #1 */
457     function ownerPauseGame(bool newStatus) public
458     onlyOwner
459     {
460         gamePaused = newStatus;
461     }
462 
463     /* only owner address can set emergency pause #2 */
464     function ownerPausePayouts(bool newPayoutStatus) public
465     onlyOwner
466     {
467         payoutsPaused = newPayoutStatus;
468     }
469 
470     /* only owner address can set casino address */
471     function ownerSetCasino(address newCasino) public
472     onlyOwner
473     {
474         casino = newCasino;
475     }
476 
477     /* only owner address can set owner address */
478     function ownerChangeOwner(address newOwner) public
479     onlyOwner
480     {
481         owner = newOwner;
482     }
483 
484     /* only owner address can suicide - emergency */
485     function ownerkill() public
486     onlyOwner
487     {
488         suicide(owner);
489     }
490 }