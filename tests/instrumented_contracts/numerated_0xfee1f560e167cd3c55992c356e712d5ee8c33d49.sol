1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4     address public aOwner;
5     address public coOwner1;
6     address public coOwner2;
7 
8     constructor() public {
9         aOwner = msg.sender;
10         coOwner1 = msg.sender;
11         coOwner2 = msg.sender;
12     }
13 
14     /* Modifiers */
15     modifier onlyOwner {
16         require(msg.sender == aOwner || msg.sender == coOwner1 || msg.sender == coOwner2);
17         _;
18     }
19 
20     function setCoOwner1(address _coOwner) public onlyOwner {
21       coOwner1 = _coOwner;
22     }
23 
24     function setCoOwner2(address _coOwner) public onlyOwner {
25       coOwner2 = _coOwner;
26     }
27 }
28 
29 
30 contract XEther is Owned {
31     /* Structurs and variables */
32     uint256 public totalInvestmentAmount = 0;
33     uint256 public ownerFeePercent = 50; // 5%
34     uint256 public investorsFeePercent = 130; // 13%
35 
36     uint256 public curIteration = 1;
37 
38     uint256 public depositsCount = 0;
39     uint256 public investorsCount = 1;
40 
41     uint256 public bankAmount = 0;
42     uint256 public feeAmount = 0;
43 
44     uint256 public toGwei = 1000000000; // or 1e9, helper vars
45     uint256 public minDepositAmount = 20000000; // minimum deposit
46     uint256 public minLotteryAmount = 100000000; // minimum to participate in lottery
47     uint256 public minInvestmentAmount = 5 ether; // min for investment
48 
49     bool public isWipeAllowed = true; // wipe only if bank almost became empty
50     uint256 public investorsCountLimit = 7; // maximum investors
51     uint256 public lastTransaction = now;
52 
53     // Stage variables
54     uint256 private stageStartTime = now;
55     uint private currentStage = 1;
56     uint private stageTime = 86400; // time of stage in minutes
57     uint private stageMin = 0;
58     uint private stageMax = 72;
59 
60     // lottery
61     uint256 public jackpotBalance = 0;
62     uint256 public jackpotPercent = 20; // 2%
63 
64     uint256 _seed;
65 
66     // Deposits mapping
67     mapping(uint256 => address) public depContractidToAddress;
68     mapping(uint256 => uint256) public depContractidToAmount;
69     mapping(uint256 => bool) public depContractidToLottery;
70 
71     // Investors mapping
72     mapping(uint256 => address) public investorsAddress;
73     mapping(uint256 => uint256) public investorsInvested;
74     mapping(uint256 => uint256) public investorsComissionPercent;
75     mapping(uint256 => uint256) public investorsEarned;
76 
77     /* Events */
78     event EvDebug (
79         uint amount
80     );
81 
82     /* New income transaction*/
83     event EvNewDeposit (
84         uint256 iteration,
85         uint256 bankAmount,
86         uint256 index,
87         address sender,
88         uint256 amount,
89         uint256 multiplier,
90         uint256 time
91     );
92 
93     /* New investment added */
94     event EvNewInvestment (
95         uint256 iteration,
96         uint256 bankAmount,
97         uint256 index,
98         address sender,
99         uint256 amount,
100         uint256[] investorsFee
101     );
102 
103     /* Collect investors earned, when some one get payment */
104     event EvInvestorsComission (
105         uint256 iteration,
106         uint256[] investorsComission
107     );
108 
109     /* Bank amount increased */
110     event EvUpdateBankAmount (
111         uint256 iteration,
112         uint256 deposited,
113         uint256 balance
114     );
115 
116     /* Payout for deposit */
117     event EvDepositPayout (
118         uint256 iteration,
119         uint256 bankAmount,
120         uint256 index,
121         address receiver,
122         uint256 amount,
123         uint256 fee,
124         uint256 jackpotBalance
125     );
126 
127     /* newIteration */
128     event EvNewIteration (
129         uint256 iteration
130     );
131 
132     /* No more funds in the bank, need actions (e.g. new iteration) */
133     event EvBankBecomeEmpty (
134         uint256 iteration,
135         uint256 index,
136         address receiver,
137         uint256 payoutAmount,
138         uint256 bankAmount
139     );
140 
141     /* Investor get payment */
142     event EvInvestorPayout (
143         uint256 iteration,
144         uint256 bankAmount,
145         uint256 index,
146         uint256 amount,
147         bool status
148     );
149 
150     /* Investors get payment */
151     event EvInvestorsPayout (
152         uint256 iteration,
153         uint256 bankAmount,
154         uint256[] payouts,
155         bool[] statuses
156     );
157 
158     /* New stage - time of withdraw is tapered */
159     event EvStageChanged (
160         uint256 iteration,
161         uint timeDiff,
162         uint stage
163     );
164 
165     /* Lottery numbers */
166     event EvLotteryWin (
167         uint256 iteration,
168         uint256 contractId,
169         address winer,
170         uint256 amount
171     );
172 
173     /* Check address with code*/
174     event EvConfimAddress (
175         address sender,
176         bytes16 code
177     );
178 
179     /* Lottery numbers */
180     event EvLotteryNumbers (
181         uint256 iteration,
182         uint256 index,
183         uint256[] lotteryNumbers
184     );
185 
186     /* Manually update Jackpot amount */
187     event EvUpdateJackpot (
188         uint256 iteration,
189         uint256 amount,
190         uint256 balance
191     );
192 
193     /*---------- constructor ------------*/
194     constructor() public {
195         investorsAddress[0] = aOwner;
196         investorsInvested[0] = 0;
197         investorsComissionPercent[0] = 0;
198         investorsEarned[0] = 0;
199     }
200 
201     /*--------------- public methods -----------------*/
202     function() public payable {
203         require(msg.value > 0 && msg.sender != address(0));
204 
205         uint256 amount = msg.value / toGwei; // convert to gwei
206 
207         if (amount >= minDepositAmount) {
208             lastTransaction = block.timestamp;
209             newDeposit(msg.sender, amount);
210         }
211         else {
212             bankAmount += amount;
213         }
214     }
215 
216     function newIteration() public onlyOwner {
217         require(isWipeAllowed);
218 
219         payoutInvestors();
220 
221         investorsInvested[0] = 0;
222         investorsCount = 1;
223 
224         totalInvestmentAmount = 0;
225         bankAmount = 0;
226         feeAmount = 0;
227         depositsCount = 0;
228 
229         // Stage vars update
230         currentStage = 1;
231         stageStartTime = now;
232         stageMin = 0;
233         stageMax = 72;
234 
235         curIteration += 1;
236 
237         emit EvNewIteration(curIteration);
238 
239         uint256 realBalance = address(this).balance - (jackpotBalance * toGwei);
240         if (realBalance > 0) {
241           aOwner.transfer(realBalance);
242         }
243     }
244 
245     function updateBankAmount() public onlyOwner payable {
246         require(msg.value > 0 && msg.sender != address(0));
247 
248         uint256 amount = msg.value / toGwei;
249 
250         isWipeAllowed = false;
251 
252         bankAmount += amount;
253         totalInvestmentAmount += amount;
254 
255         emit EvUpdateBankAmount(curIteration, amount, bankAmount);
256 
257         recalcInvestorsFee(msg.sender, amount);
258     }
259 
260     function newInvestment() public payable {
261         require(msg.value >= minInvestmentAmount && msg.sender != address(0));
262 
263         address sender = msg.sender;
264         uint256 investmentAmount = msg.value / toGwei; // convert to gwei
265 
266         addInvestment(sender, investmentAmount);
267     }
268 
269     /* Payout */
270     function depositPayout(uint depositIndex, uint pAmount) public onlyOwner returns(bool) {
271         require(depositIndex < depositsCount && depositIndex >= 0 && depContractidToAmount[depositIndex] > 0);
272         require(pAmount <= 5);
273 
274         uint256 payoutAmount = depContractidToAmount[depositIndex];
275         payoutAmount += (payoutAmount * pAmount) / 100;
276 
277         if (payoutAmount > bankAmount) {
278             isWipeAllowed = true;
279             // event payment not enaught bank amount
280             emit EvBankBecomeEmpty(curIteration, depositIndex, depContractidToAddress[depositIndex], payoutAmount, bankAmount);
281             return false;
282         }
283 
284         uint256 ownerComission = (payoutAmount * ownerFeePercent) / 1000;
285         investorsEarned[0] += ownerComission;
286 
287         uint256 addToJackpot = (payoutAmount * jackpotPercent) / 1000;
288         jackpotBalance += addToJackpot;
289 
290         uint256 investorsComission = (payoutAmount * investorsFeePercent) / 1000;
291 
292         uint256 payoutComission = ownerComission + addToJackpot + investorsComission;
293 
294         uint256 paymentAmount = payoutAmount - payoutComission;
295 
296         bankAmount -= payoutAmount;
297         feeAmount += ownerComission + investorsComission;
298 
299         emit EvDepositPayout(curIteration, bankAmount, depositIndex, depContractidToAddress[depositIndex], paymentAmount, payoutComission, jackpotBalance);
300 
301         updateInvestorsComission(investorsComission);
302 
303         depContractidToAmount[depositIndex] = 0;
304 
305         paymentAmount *= toGwei; // get back to wei
306         depContractidToAddress[depositIndex].transfer(paymentAmount);
307 
308         if (depContractidToLottery[depositIndex]) {
309             lottery(depContractidToAddress[depositIndex], depositIndex);
310         }
311 
312         return true;
313     }
314 
315     /* Payout to investors */
316     function payoutInvestors() public {
317         uint256 paymentAmount = 0;
318         bool isSuccess = false;
319 
320         uint256[] memory payouts = new uint256[](investorsCount);
321         bool[] memory statuses = new bool[](investorsCount);
322 
323         uint256 mFeeAmount = feeAmount;
324         uint256 iteration = curIteration;
325 
326         for (uint256 i = 0; i < investorsCount; i++) {
327             uint256 iEarned = investorsEarned[i];
328             if (iEarned == 0) {
329                 continue;
330             }
331             paymentAmount = iEarned * toGwei; // get back to wei
332 
333             mFeeAmount -= iEarned;
334             investorsEarned[i] = 0;
335 
336             isSuccess = investorsAddress[i].send(paymentAmount);
337             payouts[i] = iEarned;
338             statuses[i] = isSuccess;
339 
340 
341         }
342         emit EvInvestorsPayout(iteration, bankAmount, payouts, statuses);
343 
344         feeAmount = mFeeAmount;
345     }
346 
347     /* Payout to investor */
348     function payoutInvestor(uint256 investorId) public {
349         require (investorId < investorsCount && investorsEarned[investorId] > 0);
350 
351         uint256 paymentAmount = investorsEarned[investorId] * toGwei; // get back to wei
352         feeAmount -= investorsEarned[investorId];
353         investorsEarned[investorId] = 0;
354 
355         bool isSuccess = investorsAddress[investorId].send(paymentAmount);
356 
357         emit EvInvestorPayout(curIteration, bankAmount, investorId, paymentAmount, isSuccess);
358     }
359 
360     /* Helper function to check sender */
361     function confirmAddress(bytes16 code) public {
362         emit EvConfimAddress(msg.sender, code);
363     }
364 
365     /* Show depositers and investors info */
366     function depositInfo(uint256 contractId) view public returns(address _address, uint256 _amount, bool _participateInLottery) {
367       return (depContractidToAddress[contractId], depContractidToAmount[contractId] * toGwei, depContractidToLottery[contractId]);
368     }
369 
370     /* Show investors info by id */
371     function investorInfo(uint256 contractId) view public returns(
372         address _address, uint256 _invested, uint256 _comissionPercent, uint256 earned
373     )
374     {
375       return (investorsAddress[contractId], investorsInvested[contractId] * toGwei,
376         investorsComissionPercent[contractId], investorsEarned[contractId] * toGwei);
377     }
378 
379     function showBankAmount() view public returns(uint256 _bankAmount) {
380       return bankAmount * toGwei;
381     }
382 
383     function showInvestorsComission() view public returns(uint256 _investorsComission) {
384       return feeAmount * toGwei;
385     }
386 
387     function showJackpotBalance() view public returns(uint256 _jackpotBalance) {
388       return jackpotBalance * toGwei;
389     }
390 
391     function showStats() view public returns(
392         uint256 _ownerFeePercent, uint256 _investorsFeePercent, uint256 _jackpotPercent,
393         uint256 _minDepositAmount, uint256 _minLotteryAmount,uint256 _minInvestmentAmount,
394         string info
395       )
396     {
397       return (ownerFeePercent, investorsFeePercent, jackpotPercent,
398         minDepositAmount * toGwei, minLotteryAmount * toGwei, minInvestmentAmount,
399         'To get real percentages divide them to 10');
400     }
401 
402     /* Function to change variables */
403     function updateJackpotBalance() public onlyOwner payable {
404         require(msg.value > 0 && msg.sender != address(0));
405         jackpotBalance += msg.value / toGwei;
406         emit EvUpdateJackpot(curIteration, msg.value, jackpotBalance);
407     }
408 
409     /* Allow withdraw jackpot only if there are no transactions more then month*/
410     function withdrawJackpotBalance(uint amount) public onlyOwner {
411         require(jackpotBalance >= amount / toGwei && msg.sender != address(0));
412         // withdraw jacpot if no one dont play more then month
413         require(now - lastTransaction > 4 weeks);
414 
415         uint256 tmpJP = amount / toGwei;
416         jackpotBalance -= tmpJP;
417 
418         // Lottery payment
419         aOwner.transfer(amount);
420         emit EvUpdateJackpot(curIteration, amount, jackpotBalance);
421     }
422 
423     /*--------------- private methods -----------------*/
424     function newDeposit(address _address, uint depositAmount) private {
425         uint256 randMulti = random(100) + 200;
426         uint256 rndX = random(1480);
427         uint256 _time = getRandomTime(rndX);
428 
429         // Check is depositer hit the bonus number. Else return old multiplier.
430         randMulti = checkForBonuses(rndX, randMulti);
431 
432         uint256 contractid = depositsCount;
433 
434         depContractidToAddress[contractid] = _address;
435         depContractidToAmount[contractid] = (depositAmount * randMulti) / 100;
436         depContractidToLottery[contractid] = depositAmount >= minLotteryAmount;
437 
438         depositsCount++;
439 
440         bankAmount += depositAmount;
441 
442         emit EvNewDeposit(curIteration, bankAmount, contractid, _address, depositAmount, randMulti, _time);
443     }
444 
445     function addInvestment(address sender, uint256 investmentAmount) private {
446         require( (totalInvestmentAmount < totalInvestmentAmount + investmentAmount) && (bankAmount < bankAmount + investmentAmount) );
447         totalInvestmentAmount += investmentAmount;
448         bankAmount += investmentAmount;
449 
450         recalcInvestorsFee(sender, investmentAmount);
451     }
452 
453     function recalcInvestorsFee(address sender, uint256 investmentAmount) private {
454         uint256 investorIndex = 0;
455         bool isNewInvestor = true;
456         uint256 investorFeePercent = 0;
457         uint256[] memory investorsFee = new uint256[](investorsCount+1);
458 
459         for (uint256 i = 0; i < investorsCount; i++) {
460             if (investorsAddress[i] == sender) {
461                 investorIndex = i;
462                 isNewInvestor = false;
463                 investorsInvested[i] += investmentAmount;
464             }
465 
466             investorFeePercent = percent(investorsInvested[i], totalInvestmentAmount, 3);
467             investorsComissionPercent[i] = investorFeePercent;
468             investorsFee[i] = investorFeePercent;
469         }
470 
471         if (isNewInvestor) {
472             if (investorsCount > investorsCountLimit) revert(); // Limit investors count
473 
474             investorFeePercent = percent(investmentAmount, totalInvestmentAmount, 3);
475             investorIndex = investorsCount;
476 
477             investorsAddress[investorIndex] = sender;
478             investorsInvested[investorIndex] = investmentAmount;
479             investorsComissionPercent[investorIndex] = investorFeePercent;
480 
481             investorsEarned[investorIndex] = 0;
482             investorsFee[investorIndex] = investorFeePercent;
483 
484             investorsCount++;
485         }
486 
487         emit EvNewInvestment(curIteration, bankAmount, investorIndex, sender, investmentAmount, investorsFee);
488     }
489 
490     function updateInvestorsComission(uint256 amount) private {
491         uint256 investorsTotalIncome = 0;
492         uint256[] memory investorsComission = new uint256[](investorsCount);
493 
494         for (uint256 i = 1; i < investorsCount; i++) {
495             uint256 investorIncome = (amount * investorsComissionPercent[i]) / 1000;
496 
497             investorsEarned[i] += investorIncome;
498             investorsComission[i] = investorsEarned[i];
499 
500             investorsTotalIncome += investorIncome;
501         }
502 
503         investorsEarned[0] += amount - investorsTotalIncome;
504 
505         emit EvInvestorsComission(curIteration, investorsComission);
506     }
507 
508     function percent(uint numerator, uint denominator, uint precision) private pure returns(uint quotient) {
509         uint _numerator = numerator * 10 ** (precision+1);
510         uint _quotient = ((_numerator / denominator) + 5) / 10;
511 
512         return (_quotient);
513     }
514 
515     function random(uint numMax) private returns (uint256 result) {
516         _seed = uint256(keccak256(abi.encodePacked(
517             _seed,
518             blockhash(block.number - 1),
519             block.coinbase,
520             block.difficulty
521         )));
522 
523         return _seed % numMax;
524     }
525 
526     function getRandomTime(uint num) private returns (uint256 result) {
527         uint rndHours = random(68) + 4;
528         result = 72 - (2 ** ((num + 240) / 60) + 240) % rndHours;
529         checkStageCondition();
530         result = numStageRecalc(result);
531 
532         return (result < 4) ? 4 : result;
533     }
534 
535     function checkForBonuses(uint256 number, uint256 multiplier) private pure returns (uint256 newMultiplier) {
536         if (number == 8) return 1000;
537         if (number == 12) return 900;
538         if (number == 25) return 800;
539         if (number == 37) return 700;
540         if (number == 42) return 600;
541         if (number == 51) return 500;
542         if (number == 63 || number == 65 || number == 67) {
543             return 400;
544         }
545 
546         return multiplier;
547     }
548 
549     /*
550     * Check for time of current stage, in case of timeDiff bigger then stage time
551     * new stage states set.
552     */
553     function checkStageCondition() private {
554         uint timeDiff = now - stageStartTime;
555 
556         if (timeDiff > stageTime && currentStage < 3) {
557             currentStage++;
558             stageMin += 10;
559             stageMax -= 10;
560             stageStartTime = now;
561             emit EvStageChanged(curIteration, timeDiff, currentStage);
562         }
563     }
564 
565     /*
566     * Recalculate hours regarding current stage and counting chance of bonus.
567     */
568     function numStageRecalc(uint256 curHours) private returns (uint256 result) {
569         uint chance = random(110) + 1;
570         if (currentStage > 1 && chance % 9 != 0) {
571             if (curHours > stageMax) return stageMax;
572             if (curHours < stageMin) return stageMin;
573         }
574 
575         return curHours;
576     }
577 
578     /*
579     * Lottery main function
580     */
581     function lottery(address sender, uint256 index) private {
582         bool lotteryWin = false;
583         uint256[] memory lotteryNumbers = new uint256[](7);
584 
585         (lotteryWin, lotteryNumbers) = randomizerLottery(blockhash(block.number - 1), sender);
586 
587         emit EvLotteryNumbers(curIteration, index, lotteryNumbers);
588 
589         if (lotteryWin) {
590           emit EvLotteryWin(curIteration, index, sender, jackpotBalance);
591           uint256 tmpJP = jackpotBalance * toGwei; // get back to wei
592           jackpotBalance = 0;
593 
594           // Lottery payment
595           sender.transfer(tmpJP);
596         }
597     }
598 
599     /*
600     * Lottery generator numbers by given hash.
601     */
602     function randomizerLottery(bytes32 hash, address sender) private returns(bool, uint256[] memory) {
603         uint256[] memory lotteryNumbers = new uint256[](7);
604         bytes32 userHash  = keccak256(abi.encodePacked(
605             hash,
606             sender,
607             random(999)
608         ));
609         bool win = true;
610 
611         for (uint i = 0; i < 7; i++) {
612             uint position = i + random(1);
613             bytes1 charAtPos = charAt(userHash, position);
614             uint8 firstNums = getLastN(charAtPos, 4);
615             uint firstNumInt = uint(firstNums);
616 
617             if (firstNumInt > 9) {
618                 firstNumInt = 16 - firstNumInt;
619             }
620 
621             lotteryNumbers[i] = firstNumInt;
622 
623             if (firstNums != 7) {
624                 win = false;
625             }
626         }
627 
628         return (win, lotteryNumbers);
629     }
630 
631     function charAt(bytes32 b, uint char) private pure returns (bytes1) {
632         return bytes1(uint8(uint(b) / (2**((31 - char) * 8))));
633     }
634 
635     function getLastN(bytes1 a, uint8 n) private pure returns (uint8) {
636         uint8 lastN = uint8(a) % uint8(2) ** n;
637         return lastN;
638     }
639 }