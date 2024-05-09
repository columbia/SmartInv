1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6  * Web              - https://winethfree.com
7  * Twitter          - https://twitter.com/winethfree
8  * Telegram_channel - https://t.me/winethfree
9  * Telegram_group   - https://t.me/wef_group
10  *
11  * __          ___         ______ _______ _    _   ______
12  * \ \        / (_)       |  ____|__   __| |  | | |  ____|
13  *  \ \  /\  / / _ _ __   | |__     | |  | |__| | | |__ _ __ ___  ___
14  *   \ \/  \/ / | | '_ \  |  __|    | |  |  __  | |  __| '__/ _ \/ _ \
15  *    \  /\  /  | | | | | | |____   | |  | |  | | | |  | | |  __/  __/
16  *     \/  \/   |_|_| |_| |______|  |_|  |_|  |_| |_|  |_|  \___|\___|
17  */
18 
19 contract WinEthFree{
20 
21     // investor gets 2% interest per day to return.
22     struct Investor {
23         uint waveNum;      // wave Num
24         uint investment;    // investment gets 2% interest per day
25         uint payableInterest;  // payable interest until last pay time
26         uint paidInterest;   // interest already paid
27         uint payTime;
28     }
29 
30     // Lottery ticket number from beginNum to endNum.
31     struct LotteryTicket {
32         address player;
33         uint beginNum;
34         uint endNum;
35         bool conservative; // winner would not return interest for conservative wager.
36     }
37 
38     enum WagerType { Conservative, Aggressive, Interest }
39 
40     Leverage private leverage;
41 
42     modifier onlyLeverage() {
43         require(msg.sender == address(leverage), "access denied");
44         _;
45     }
46 
47     event LogNextWave();
48     event LogNextBet();
49     event LogWithdrawInterest(address, uint);
50     event LogInvestChange(address, uint, uint, uint);
51     event LogBet(WagerType, address, uint, uint, uint, uint);
52     event LogPayWinnerPrize(address, uint, uint);
53 
54     address private admin;
55     uint private constant commissionPercent = 10;
56 
57     uint private constant ratePercent = 2;
58     uint private constant ratePeriod = 24 hours;
59     uint private constant minInvestment = 10 finney;  //       0.01 ETH
60 
61     uint private constant leverageMultiple = 10;
62     uint private constant minInterestWager = minInvestment / leverageMultiple;
63     uint private constant prize1st = 1 ether;
64     uint private constant prize2nd = 20 finney;
65     uint private constant winnerNum = 11;
66     uint private constant minPrizePool = prize1st + prize2nd * (winnerNum - 1);   // 1 + 0.02 * 10 ETH
67     uint private constant prizePercent = 50;
68 
69     uint private waveNum;
70 
71     mapping (address => Investor) private investors;
72 
73     uint private activeTicketSlotSum;
74     LotteryTicket[] private lotteryTickets;
75     uint private ticketSum;
76     uint private prizePool;
77     uint private roundStartup;
78 
79     function isInvestor(address addr) private view returns (bool) {
80         return investors[addr].waveNum == waveNum;
81     }
82 
83     function resetInvestor(address addr) private {
84         investors[addr].waveNum--;
85     }
86 
87     function calcInterest(address addr) private returns (uint) {
88 
89         if (!isInvestor(addr)) {
90             return 0;
91         }
92 
93         uint investment = investors[addr].investment;
94         uint paidInterest = investors[addr].paidInterest;
95 
96         if (investment <= paidInterest) {
97             // investment decreases when player wins prize, could be less than paid interest.
98             resetInvestor(addr);
99 
100             emit LogInvestChange(addr, 0, 0, 0);
101 
102             return 0;
103         }
104 
105         uint payableInterest = investors[addr].payableInterest;
106         uint payTime = investors[addr].payTime;
107 
108         uint interest = investment * ratePercent / 100 * (now - payTime) / ratePeriod;
109         interest += payableInterest;
110 
111         uint restInterest = investment - paidInterest;
112 
113         if (interest > restInterest) {
114             interest = restInterest;
115         }
116 
117         return interest;
118     }
119 
120     function takeInterest(address addr) private returns(uint) {
121         uint interest = calcInterest(addr);
122 
123         if (interest < minInterestWager) {
124             return 0;
125         }
126 
127         // round down to FINNEY
128         uint interestRoundDown = uint(interest / minInterestWager) * minInterestWager;
129 
130         investors[addr].payableInterest = interest - interestRoundDown;
131         investors[addr].paidInterest += interestRoundDown;
132         investors[addr].payTime = now;
133 
134         emit LogInvestChange(
135             addr, investors[addr].payableInterest,
136             investors[addr].paidInterest, investors[addr].investment
137             );
138 
139         return interestRoundDown;
140     }
141 
142     function withdrawInterest(address addr) private {
143         uint interest = takeInterest(addr);
144 
145         if (interest == 0) {
146             return;
147         }
148 
149         uint balance = address(this).balance - prizePool;
150         bool outOfBalance;
151 
152         if (balance <= interest) {
153             outOfBalance = true;
154             interest = balance;
155         }
156 
157         addr.transfer(interest);
158 
159         emit LogWithdrawInterest(addr, interest);
160 
161         if (outOfBalance) {
162             nextWave();
163         }
164     }
165 
166     // new investment or add more investment
167     function doInvest(address addr, uint value) private {
168 
169         uint interest = calcInterest(addr);
170 
171         if (interest > 0) {
172             // update payable Interest from last pay time.
173             investors[addr].payableInterest = interest;
174         }
175 
176         if (isInvestor(addr)) {
177             // add more investment
178             investors[addr].investment += value;
179             investors[addr].payTime = now;
180         } else {
181             // new investment
182             investors[addr].waveNum = waveNum;
183             investors[addr].investment = value;
184             investors[addr].payableInterest = 0;
185             investors[addr].paidInterest = 0;
186             investors[addr].payTime = now;
187         }
188 
189         emit LogInvestChange(
190             addr, investors[addr].payableInterest,
191             investors[addr].paidInterest, investors[addr].investment
192             );
193     }
194 
195     // Change to not return interest if the player wins a prize.
196     function WinnerNotReturn(address addr) private {
197 
198         // investment could be less than wager, if nextWave() triggered.
199         if (investors[addr].investment >= minInvestment) {
200             investors[addr].investment -= minInvestment;
201 
202             emit LogInvestChange(
203                 addr, investors[addr].payableInterest,
204                 investors[addr].paidInterest, investors[addr].investment
205                 );
206         }
207     }
208 
209     // wageType: 0 for conservative, 1 for aggressive, 2 for interest
210     function doBet(address addr, uint value, WagerType wagerType) private returns(bool){
211         uint ticketNum;
212         bool conservative;
213 
214         if (wagerType != WagerType.Interest) {
215             takeCommission(value);
216         }
217 
218         if (value >= minInvestment) {
219             // take 50% wager as winner's prize pool
220             prizePool += value * prizePercent / 100;
221         }
222 
223         if (wagerType == WagerType.Conservative) {
224             // conservative, 0.01 ETH for 1 ticket
225             ticketNum = value / minInvestment;
226             conservative = true;
227         } else if (wagerType == WagerType.Aggressive) {
228             // aggressive
229             ticketNum = value * leverageMultiple / minInvestment;
230         } else {
231             // interest
232             ticketNum = value * leverageMultiple / minInvestment;
233         }
234 
235         if (activeTicketSlotSum == lotteryTickets.length) {
236             lotteryTickets.length++;
237         }
238 
239         uint slot = activeTicketSlotSum++;
240         lotteryTickets[slot].player = addr;
241         lotteryTickets[slot].conservative = conservative;
242         lotteryTickets[slot].beginNum = ticketSum;
243         ticketSum += ticketNum;
244         lotteryTickets[slot].endNum = ticketSum - 1;
245 
246         emit LogBet(wagerType, addr, value, lotteryTickets[slot].beginNum, lotteryTickets[slot].endNum, prizePool);
247 
248         if (prizePool >= minPrizePool) {
249 
250             if (address(this).balance - prizePool >= minInvestment) {
251                 // last one gets extra 0.01 ETH award.
252                 addr.transfer(minInvestment);
253             }
254 
255             drawLottery();
256             nextBet();
257         }
258     }
259 
260     function drawLottery() private {
261         uint[] memory luckyTickets = getLuckyTickets();
262 
263         payTicketsPrize(luckyTickets);
264     }
265 
266     function random(uint i) private view returns(uint) {
267         // take last block hash as random seed
268         return uint(keccak256(abi.encodePacked(blockhash(block.number - 1), i)));
269     }
270 
271     function getLuckyTickets() private view returns(uint[] memory) {
272 
273         // lucky ticket number, 1 for first prize(1 ETH), 10 for second prize(0.02 ETH)
274         uint[] memory luckyTickets = new uint[](winnerNum);
275 
276         uint num;
277         uint k;
278 
279         for (uint i = 0;; i++) {
280             num = random(i) % ticketSum;
281             bool duplicate = false;
282             for (uint j = 0; j < k; j++) {
283                 if (num == luckyTickets[j]) {
284                     // random seed may generate duplicated lucky numbers.
285                     duplicate = true;
286                     break;
287                 }
288             }
289 
290             if (!duplicate) {
291                 luckyTickets[k++] = num;
292 
293                 if (k == winnerNum)
294                     break;
295             }
296         }
297 
298         return luckyTickets;
299     }
300 
301     function sort(uint[] memory data) private {
302         if (data.length == 0)
303             return;
304         quickSort(data, 0, data.length - 1);
305     }
306 
307     function quickSort(uint[] memory arr, uint left, uint right) private {
308         uint i = left;
309         uint j = right;
310         if(i == j) return;
311         uint pivot = arr[uint(left + (right - left) / 2)];
312         while (i <= j) {
313             while (arr[i] < pivot) i++;
314             while (pivot < arr[j]) j--;
315             if (i <= j) {
316                 (arr[i], arr[j]) = (arr[j], arr[i]);
317                 i++;
318                 j--;
319             }
320         }
321         if (left < j)
322             quickSort(arr, left, j);
323         if (i < right)
324             quickSort(arr, i, right);
325     }
326 
327     function payTicketsPrize(uint[] memory luckyTickets) private {
328 
329         uint j;
330         uint k;
331         uint prize;
332 
333         uint prize1st_num = luckyTickets[0];
334 
335         sort(luckyTickets);
336 
337         for (uint i = 0 ; i < activeTicketSlotSum; i++) {
338             uint beginNum = lotteryTickets[i].beginNum;
339             uint endNum = lotteryTickets[i].endNum;
340 
341             for (k = j; k < luckyTickets.length; k++) {
342                 uint luckyNum = luckyTickets[k];
343 
344                 if (luckyNum == prize1st_num) {
345                     prize = prize1st;
346                 } else {
347                     prize = prize2nd;
348                 }
349 
350                 if (beginNum <= luckyNum && luckyNum <= endNum) {
351                     address winner = lotteryTickets[i].player;
352                     winner.transfer(prize);
353 
354                     emit LogPayWinnerPrize(winner, luckyNum, prize);
355 
356                     // winner would not get the interest(2% per day)
357                     // for conservative wager
358                     if (lotteryTickets[i].conservative) {
359                         WinnerNotReturn(winner);
360                     }
361 
362                     // found luckyTickets[k]
363                     j = k + 1;
364                 } else {
365                     // break on luckyTickets[k]
366                     j = k;
367                     break;
368                 }
369             }
370 
371             if (j == luckyTickets.length) {
372                 break;
373             }
374         }
375     }
376 
377     constructor(address addr) public {
378         admin = addr;
379 
380         // create Leverage contract instance
381         leverage = new Leverage();
382 
383         nextWave();
384         nextBet();
385     }
386 
387     function nextWave() private {
388         waveNum++;
389         emit LogNextWave();
390     }
391 
392     function nextBet() private {
393 
394         prizePool = 0;
395         roundStartup = now;
396 
397         activeTicketSlotSum = 0;
398         ticketSum = 0;
399 
400         emit LogNextBet();
401     }
402 
403     function() payable public {
404 
405         if (msg.sender == address(leverage)) {
406             // from Leverage Contract
407             return;
408         }
409 
410         // value round down
411         uint value = uint(msg.value / minInvestment) * minInvestment;
412 
413 
414         if (value < minInvestment) {
415             withdrawInterest(msg.sender);
416 
417         } else {
418             doInvest(msg.sender, value);
419 
420             doBet(msg.sender, value, WagerType.Conservative);
421         }
422     }
423 
424     function takeCommission(uint value) private {
425         uint commission = value * commissionPercent / 100;
426         admin.transfer(commission);
427     }
428 
429     function doLeverageBet(address addr, uint value) public onlyLeverage {
430         if (value < minInvestment) {
431 
432             uint interest = takeInterest(addr);
433 
434             if (interest > 0)
435                 doBet(addr, interest, WagerType.Interest);
436 
437         } else {
438             doBet(addr, value, WagerType.Aggressive);
439         }
440     }
441 
442     function getLeverageAddress() public view returns(address) {
443         return address(leverage);
444     }
445 
446 }
447 
448 contract Leverage {
449 
450     WinEthFree private mainContract;
451     uint private constant minInvestment = 10 finney;
452 
453     constructor() public {
454         mainContract = WinEthFree(msg.sender);
455     }
456 
457     function() payable public {
458 
459         uint value = msg.value;
460         if (value > 0) {
461             address(mainContract).transfer(value);
462         }
463 
464         // round down
465         value = uint(value / minInvestment) * minInvestment;
466 
467         mainContract.doLeverageBet(msg.sender, value);
468     }
469 
470 }