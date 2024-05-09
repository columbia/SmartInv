1 pragma solidity ^0.5.3;
2 
3 contract Operator {
4     uint256 public ONE_DAY = 86400;
5     uint256 public MIN_DEP = 1 ether;
6     uint256 public MAX_DEP = 100 ether;
7     address public admin;
8     uint256 public depositedAmountGross = 0;
9     uint256 public paySystemCommissionTimes = 1;
10     uint256 public payDailyIncomeTimes = 1;
11     uint256 public lastPaySystemCommission = now;
12     uint256 public lastPayDailyIncome = now;
13     uint256 public contractStartAt = now;
14     uint256 public lastReset = now;
15     address payable public operationFund = 0xe1483B2b28643D424235D0E5920bD48A563A9737;
16     address[] public investorAddresses;
17     bytes32[] public investmentIds;
18     bytes32[] public withdrawalIds;
19     bytes32[] public maxOutIds;
20     mapping (address => Investor) investors;
21     mapping (bytes32 => Investment) public investments;
22     mapping (bytes32 => Withdrawal) public withdrawals;
23     mapping (bytes32 => MaxOut) public maxOuts;
24 
25     uint256 public maxLevelsAddSale = 200;
26     uint256 public maximumMaxOutInWeek = 2;
27     bool public importing = true;
28 
29     Vote public currentVote;
30 
31     struct Vote {
32         uint256 startTime;
33         string reason;
34         mapping (address => uint8) votes; // 1 means no, 2 means yes, 3 mean non
35         address payable emergencyAddress;
36         uint256 yesPoint;
37         uint256 noPoint;
38         uint256 totalPoint;
39     }
40 
41     struct Investment {
42         bytes32 id;
43         uint256 at;
44         uint256 amount;
45         address investor;
46         address nextInvestor;
47         bool nextBranch;
48     }
49 
50     struct Withdrawal {
51         bytes32 id;
52         uint256 at;
53         uint256 amount;
54         address investor;
55         address presentee;
56         uint256 reason;
57         uint256 times;
58     }
59 
60     struct Investor {
61         // part 1
62         string email;
63         address parent;
64         address leftChild;
65         address rightChild;
66         address presenter;
67         // part 2
68         uint256 generation;
69         uint256 depositedAmount;
70         uint256 withdrewAmount;
71         bool isDisabled;
72         // part 3
73         uint256 lastMaxOut;
74         uint256 maxOutTimes;
75         uint256 maxOutTimesInWeek;
76         uint256 totalSell;
77         uint256 sellThisMonth;
78         // part 4
79         uint256 rightSell;
80         uint256 leftSell;
81         uint256 reserveCommission;
82         uint256 dailyIncomeWithrewAmount;
83         uint256 registerTime;
84         uint256 minDeposit;
85         // part 5
86         address[] presentees;
87         bytes32[] investments;
88         bytes32[] withdrawals;
89     }
90 
91     struct MaxOut {
92         bytes32 id;
93         address investor;
94         uint256 times;
95         uint256 at;
96     }
97 
98     constructor () public { admin = msg.sender; }
99     
100     modifier mustBeAdmin() { require(msg.sender == admin); _; }
101     
102     modifier mustBeImporting() { require(msg.sender == admin); require(importing); _; }
103     
104     function () payable external { deposit(); }
105 
106     function depositProcess(address sender) internal {
107         Investor storage investor = investors[sender];
108         require(investor.generation != 0);
109         if (investor.depositedAmount == 0) require(msg.value >= investor.minDeposit);
110         require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
111         require(investor.maxOutTimes < 50);
112         require(investor.maxOutTimes == 0 || now - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
113         depositedAmountGross += msg.value;
114         bytes32 id = keccak256(abi.encodePacked(block.number, now, sender, msg.value));
115         uint256 investmentValue = investor.depositedAmount + msg.value <= MAX_DEP ? msg.value : MAX_DEP - investor.depositedAmount;
116         if (investmentValue == 0) return;
117         bool nextBranch = investors[investor.parent].leftChild == sender; 
118         Investment memory investment = Investment({ id: id, at: now, amount: investmentValue, investor: sender, nextInvestor: investor.parent, nextBranch: nextBranch  });
119         investments[id] = investment;
120         processInvestments(id);
121         investmentIds.push(id);
122     }
123 
124     function pushNewMaxOut(address investorAddress, uint256 times, uint256 depositedAmount) internal {
125         bytes32 id = keccak256(abi.encodePacked(block.number, now, investorAddress, times));
126         MaxOut memory maxOut = MaxOut({ id: id, at: now, investor: investorAddress, times: times });
127         maxOutIds.push(id);
128         maxOuts[id] = maxOut;
129         investors[investorAddress].minDeposit = depositedAmount;
130     }
131     
132     function deposit() payable public { depositProcess(msg.sender); }
133     
134     function processInvestments(bytes32 investmentId) internal {
135         Investment storage investment = investments[investmentId];
136         uint256 amount = investment.amount;
137         Investor storage investor = investors[investment.investor];
138         investor.investments.push(investmentId);
139         investor.depositedAmount += amount;
140         address payable presenterAddress = address(uint160(investor.presenter));
141         Investor storage presenter = investors[presenterAddress];
142         if (presenterAddress != address(0)) {
143             presenter.totalSell += amount;
144             presenter.sellThisMonth += amount;
145         }
146         if (presenter.depositedAmount >= MIN_DEP && !presenter.isDisabled) {
147             sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
148         }
149     }
150 
151     function addSellForParents(bytes32 investmentId) public mustBeAdmin {
152         Investment storage investment = investments[investmentId];
153         require(investment.nextInvestor != address(0));
154         uint256 amount = investment.amount;
155         uint256 loopCount = 0;
156         while (investment.nextInvestor != address(0) && loopCount < maxLevelsAddSale) {
157             Investor storage investor = investors[investment.nextInvestor];
158             if (investment.nextBranch) investor.leftSell += amount;
159             else investor.rightSell += amount;
160             investment.nextBranch = investors[investor.parent].leftChild == investment.nextInvestor;
161             investment.nextInvestor = investor.parent;
162             loopCount++;
163         }
164     }
165 
166     function sendEtherForInvestor(address payable investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
167         if (value == 0 && reason != 4) return;
168         if (investorAddress == address(0)) return;
169         Investor storage investor = investors[investorAddress];
170         uint256 totalPaidAfterThisTime = investor.reserveCommission + investor.withdrewAmount + getDailyIncomeForUser(investorAddress) + getUnpaidSystemCommission(investorAddress);
171         if (reason == 1) totalPaidAfterThisTime += value;
172         if (totalPaidAfterThisTime >= 3 * investor.depositedAmount) { //max out
173             payWithMaxOut(totalPaidAfterThisTime, investorAddress);
174             return;
175         }
176         if (investor.reserveCommission > 0) payWithNoMaxOut(investor.reserveCommission, investorAddress, 4, address(0), 0);
177         payWithNoMaxOut(value, investorAddress, reason, presentee, times);
178     }
179     
180     function payWithNoMaxOut(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
181         investors[investorAddress].withdrewAmount += amountToPay;
182         pay(amountToPay, investorAddress, reason, presentee, times);
183     }
184     
185     function payWithMaxOut(uint256 totalPaidAfterThisTime, address payable investorAddress) internal {
186         Investor storage investor = investors[investorAddress];
187         uint256 amountToPay = investor.depositedAmount * 3 - investor.withdrewAmount;
188         uint256 amountToReserve = totalPaidAfterThisTime - amountToPay;
189         investor.maxOutTimes++;
190         investor.maxOutTimesInWeek++;
191         uint256 oldDepositedAmount = investor.depositedAmount;
192         investor.depositedAmount = 0;
193         investor.withdrewAmount = 0;
194         investor.lastMaxOut = now;
195         investor.dailyIncomeWithrewAmount = 0;
196         investor.reserveCommission = amountToReserve;
197         pushNewMaxOut(investorAddress, investor.maxOutTimes, oldDepositedAmount);
198         pay(amountToPay, investorAddress, 0, address(0), 0);
199     }
200 
201     function pay(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
202         if (amountToPay == 0) return;
203         investorAddress.transfer(amountToPay / 100 * 90);
204         operationFund.transfer(amountToPay / 100 * 10);
205         bytes32 id = keccak256(abi.encodePacked(block.difficulty, now, investorAddress, amountToPay, reason));
206         Withdrawal memory withdrawal = Withdrawal({ id: id, at: now, amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
207         withdrawals[id] = withdrawal;
208         investors[investorAddress].withdrawals.push(id);
209         withdrawalIds.push(id);
210     }
211 
212     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
213         Investor memory investor = investors[investorAddress];
214         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
215         uint256 withdrewAmount = investor.withdrewAmount;
216         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
217         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
218         return allIncomeNow;
219     }
220 
221     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, string memory presenteeEmail, bool isLeft) public mustBeAdmin {
222         Investor storage presenter = investors[presenterAddress];
223         Investor storage parent = investors[parentAddress];
224         if (investorAddresses.length != 0) {
225             require(presenter.generation != 0);
226             require(parent.generation != 0);
227             if (isLeft) {
228                 require(parent.leftChild == address(0)); 
229             } else {
230                 require(parent.rightChild == address(0)); 
231             }
232         }
233         
234         if (presenter.generation != 0) presenter.presentees.push(presenteeAddress);
235         Investor memory investor = Investor({
236             email: presenteeEmail,
237             parent: parentAddress,
238             leftChild: address(0),
239             rightChild: address(0),
240             presenter: presenterAddress,
241             generation: parent.generation + 1,
242             presentees: new address[](0),
243             depositedAmount: 0,
244             withdrewAmount: 0,
245             isDisabled: false,
246             lastMaxOut: now,
247             maxOutTimes: 0,
248             maxOutTimesInWeek: 0,
249             totalSell: 0,
250             sellThisMonth: 0,
251             registerTime: now,
252             investments: new bytes32[](0),
253             withdrawals: new bytes32[](0),
254             minDeposit: MIN_DEP,
255             rightSell: 0,
256             leftSell: 0,
257             reserveCommission: 0,
258             dailyIncomeWithrewAmount: 0
259         });
260         investors[presenteeAddress] = investor;
261        
262         investorAddresses.push(presenteeAddress);
263         if (parent.generation == 0) return;
264         if (isLeft) {
265             parent.leftChild = presenteeAddress;
266         } else {
267             parent.rightChild = presenteeAddress;
268         }
269     }
270 
271     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
272         Investor memory investor = investors[investorAddress];
273         uint256 investmentLength = investor.investments.length;
274         uint256 dailyIncome = 0;
275         for (uint256 i = 0; i < investmentLength; i++) {
276             Investment memory investment = investments[investor.investments[i]];
277             if (investment.at < investor.lastMaxOut) continue; 
278             if (now - investment.at >= ONE_DAY) {
279                 uint256 numberOfDay = (now - investment.at) / ONE_DAY;
280                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
281                 dailyIncome = totalDailyIncome + dailyIncome;
282             }
283         }
284         return dailyIncome - investor.dailyIncomeWithrewAmount;
285     }
286     
287     function payDailyIncomeForInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
288         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
289         Investor memory investor = investors[investorAddress];
290         if (times > ONE_DAY) {
291             uint256 investmentLength = investor.investments.length;
292             bytes32 lastInvestmentId = investor.investments[investmentLength - 1];
293             investments[lastInvestmentId].at -= times;
294             investors[investorAddress].lastMaxOut = investments[lastInvestmentId].at;
295             return;
296         }
297         if (investor.isDisabled) return;
298         investor.dailyIncomeWithrewAmount += dailyIncome;
299         sendEtherForInvestor(investorAddress, dailyIncome, 2, address(0), times);
300     }
301     
302     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
303         require(from >= 0 && to < investorAddresses.length);
304         for(uint256 i = from; i <= to; i++) {
305             payDailyIncomeForInvestor(address(uint160(investorAddresses[i])), payDailyIncomeTimes);
306         }
307     }
308 
309     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
310         Investor memory investor = investors[investorAddress];
311         uint256 depositedAmount = investor.depositedAmount;
312         uint256 totalSell = investor.totalSell;
313         uint256 leftSell = investor.leftSell;
314         uint256 rightSell = investor.rightSell;
315         uint256 sellThisMonth = investor.sellThisMonth;
316         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
317         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
318         return commission;
319     }
320     
321     function paySystemCommissionInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
322         Investor storage investor = investors[investorAddress];
323         if (investor.isDisabled) return;
324         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
325         if (paySystemCommissionTimes > 3 && times != 0) {
326             investor.rightSell = 0;
327             investor.leftSell = 0;
328         } else if (investor.rightSell >= investor.leftSell) {
329             investor.rightSell = investor.rightSell - investor.leftSell;
330             investor.leftSell = 0;
331         } else {
332             investor.leftSell = investor.leftSell - investor.rightSell;
333             investor.rightSell = 0;
334         }
335         if (times != 0) investor.sellThisMonth = 0;
336         sendEtherForInvestor(investorAddress, systemCommission, 3, address(0), times);
337     }
338 
339     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
340          require(from >= 0 && to < investorAddresses.length);
341         // change 1 to 30
342         if (now <= 30 * ONE_DAY + contractStartAt) return;
343         for(uint256 i = from; i <= to; i++) {
344             paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
345         }
346     }
347     
348     function finishPayDailyIncome() public mustBeAdmin {
349         lastPayDailyIncome = now;
350         payDailyIncomeTimes++;
351     }
352     
353     function finishPaySystemCommission() public mustBeAdmin {
354         lastPaySystemCommission = now;
355         paySystemCommissionTimes++;
356     }
357     
358     function resetGame(uint256 from, uint256 to) public mustBeAdmin {
359         require(from >= 0 && to < investorAddresses.length);
360         require(currentVote.startTime != 0);
361         require(now - currentVote.startTime > 3 * ONE_DAY);
362         require(currentVote.yesPoint > currentVote.totalPoint / 2);
363         require(currentVote.emergencyAddress == address(0));
364         uint256 rootVote = currentVote.votes[investorAddresses[0]];
365         require(rootVote != 0);
366         lastReset = now;
367         for (uint256 i = from; i < to; i++) {
368             address investorAddress = investorAddresses[i];
369             Investor storage investor = investors[investorAddress];
370             uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : rootVote;
371             if (currentVoteValue == 2) {
372                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
373                     investor.lastMaxOut = now;
374                     investor.depositedAmount = 0;
375                     investor.withdrewAmount = 0;
376                     investor.dailyIncomeWithrewAmount = 0;
377                 }
378                 investor.reserveCommission = 0;
379                 investor.rightSell = 0;
380                 investor.leftSell = 0;
381                 investor.totalSell = 0;
382                 investor.sellThisMonth = 0;
383             } else {
384                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
385                     investor.isDisabled = true;
386                     investor.reserveCommission = 0;
387                     investor.lastMaxOut = now;
388                     investor.depositedAmount = 0;
389                     investor.withdrewAmount = 0;
390                     investor.dailyIncomeWithrewAmount = 0;
391                 }
392                 investor.reserveCommission = 0;
393                 investor.rightSell = 0;
394                 investor.leftSell = 0;
395                 investor.totalSell = 0;
396                 investor.sellThisMonth = 0;
397             }
398             
399         }
400     }
401 
402     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
403         require(currentVote.startTime != 0);
404         require(now - currentVote.startTime > 3 * ONE_DAY);
405         require(currentVote.noPoint > currentVote.totalPoint / 2);
406         require(currentVote.emergencyAddress == address(0));
407         require(percent <= 60);
408         require(from >= 0 && to < investorAddresses.length);
409         for (uint256 i = from; i <= to; i++) {
410             address payable investorAddress = address(uint160(investorAddresses[i]));
411             Investor storage investor = investors[investorAddress];
412             if (investor.maxOutTimes > 0) continue;
413             if (investor.isDisabled) continue;
414             uint256 depositedAmount = investor.depositedAmount;
415             uint256 withdrewAmount = investor.withdrewAmount;
416             if (withdrewAmount >= depositedAmount / 2) continue;
417             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
418         }
419     }
420     
421     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = now; }
422 
423     function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
424         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
425         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
426         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
427         uint256 depositedAmount = investors[investorAddress].depositedAmount;
428         uint256 reserveCommission = investors[investorAddress].reserveCommission;
429         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
430         sendEtherForInvestor(investorAddress, 0, 4, address(0), 0);
431     }
432 
433     function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
434         require(from >= 0 && to < investorAddresses.length);
435         for (uint256 i = from; i < to; i++) {
436             address investorAddress = investorAddresses[i];
437             if (investors[investorAddress].maxOutTimesInWeek == 0) return;
438             investors[investorAddress].maxOutTimesInWeek = 0;
439         }
440     }
441 
442     function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }
443 
444     function disableInvestor(address investorAddress) public mustBeAdmin {
445         Investor storage investor = investors[investorAddress];
446         investor.isDisabled = true;
447     }
448     
449     function enableInvestor(address investorAddress) public mustBeAdmin {
450         Investor storage investor = investors[investorAddress];
451         investor.isDisabled = false;
452     }
453     
454     function donate() payable public { depositedAmountGross += msg.value; }
455 
456     // Utils helpers
457     
458     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
459         if (totalSell < 30 ether) return 0;
460         if (totalSell < 60 ether) return 1;
461         if (totalSell < 90 ether) return 2;
462         if (totalSell < 120 ether) return 3;
463         if (totalSell < 150 ether) return 4;
464         return 5;
465     }
466 
467     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
468         if (sellThisMonth < 2 ether) return 0;
469         if (sellThisMonth < 4 ether) return 1;
470         if (sellThisMonth < 6 ether) return 2;
471         if (sellThisMonth < 8 ether) return 3;
472         if (sellThisMonth < 10 ether) return 4;
473         return 5;
474     }
475     
476     function getDepositLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
477         if (sellThisMonth < 2 ether) return 0;
478         if (sellThisMonth < 4 ether) return 1;
479         if (sellThisMonth < 6 ether) return 2;
480         if (sellThisMonth < 8 ether) return 3;
481         if (sellThisMonth < 10 ether) return 4;
482         return 5;
483     }
484     
485     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
486         uint256 totalSellLevel = getTotalSellLevel(totalSell);
487         uint256 depLevel = getDepositLevel(depositedAmount);
488         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
489         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
490         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
491         return minLevel * 2;
492     }
493     
494     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
495         bytes memory tempEmptyStringTest = bytes(source);
496         if (tempEmptyStringTest.length == 0) return 0x0;
497         assembly { result := mload(add(source, 32)) }
498     }
499     
500     // query investor helpers
501 
502     function getInvestorPart1(address investorAddress) view public returns (bytes32 email, address parent, address leftChild, address rightChild, address presenter) {
503         Investor memory investor = investors[investorAddress];
504         return (stringToBytes32(investor.email), investor.parent, investor.leftChild, investor.rightChild, investor.presenter);
505     }
506     
507     function getInvestorPart2(address investorAddress) view public returns (uint256 generation, uint256 depositedAmount, uint256 withdrewAmount, bool isDisabled) {
508         Investor memory investor = investors[investorAddress];
509         return (investor.generation, investor.depositedAmount, investor.withdrewAmount, investor.isDisabled);
510     }
511     
512     function getInvestorPart3(address investorAddress) view public returns (uint256 lastMaxOut, uint256 maxOutTimes, uint256 maxOutTimesInWeek, uint256 totalSell, uint256 sellThisMonth) {
513         Investor memory investor = investors[investorAddress];
514         return (investor.lastMaxOut, investor.maxOutTimes, investor.maxOutTimesInWeek, investor.totalSell, investor.sellThisMonth);
515     }
516 
517     function getInvestorPart4(address investorAddress) view public returns (uint256 rightSell, uint256 leftSell, uint256 reserveCommission, uint256 dailyIncomeWithrewAmount, uint256 registerTime) {
518         Investor memory investor = investors[investorAddress];
519         return (investor.rightSell, investor.leftSell, investor.reserveCommission, investor.dailyIncomeWithrewAmount, investor.registerTime);
520     }
521 
522     function getInvestorPart5(address investorAddress) view public returns (uint256 unpaidSystemCommission, uint256 unpaidDailyIncome, uint256 minDeposit) {
523         return (
524             getUnpaidSystemCommission(investorAddress),
525             getDailyIncomeForUser(investorAddress),
526             investors[investorAddress].minDeposit
527         ); 
528     }
529 
530     function getInvestorPart6(address investorAddress) view public returns (address[] memory presentees, bytes32[] memory _investments, bytes32[] memory _withdrawals) {
531         Investor memory investor = investors[investorAddress];
532         return (investor.presentees, investor.investments ,investor.withdrawals);
533     }
534 
535     function getInvestorLength() view public returns(uint256) { return investorAddresses.length; }
536 
537     function getMaxOutsLength() view public returns(uint256) { return maxOutIds.length; }
538     
539     function getNodesAddresses(address rootNodeAddress) public view returns(address[] memory){
540         uint256 maxLength = investorAddresses.length;
541         address[] memory nodes = new address[](maxLength);
542         nodes[0] = rootNodeAddress;
543         uint256 processIndex = 0;
544         uint256 nextIndex = 1;
545         while (processIndex != nextIndex) {
546             Investor memory currentInvestor = investors[nodes[processIndex++]];
547             if (currentInvestor.leftChild != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;
548             if (currentInvestor.rightChild != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;
549         }
550         return nodes;
551     }
552     
553     // query investments and withdrawals helpers
554     
555     function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
556     
557     function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
558     
559     // import helper
560 
561     function importInvestor(string memory email, address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
562         if (investors[addresses[4]].generation != 0) return;
563         Investor memory investor = Investor({
564             email: email,
565             isDisabled: isDisabled,
566             parent: addresses[0],
567             leftChild: addresses[1],
568             rightChild: addresses[2],
569             presenter: addresses[3],
570             generation: numbers[0],
571             presentees: new address[](0),
572             depositedAmount: numbers[1],
573             withdrewAmount: numbers[2],
574             lastMaxOut: numbers[3],
575             maxOutTimes: numbers[4],
576             maxOutTimesInWeek: numbers[5],
577             totalSell: numbers[6],
578             sellThisMonth: numbers[7],
579             investments: new bytes32[](0),
580             withdrawals: new bytes32[](0),
581             rightSell: numbers[8],
582             leftSell: numbers[9],
583             reserveCommission: numbers[10],
584             dailyIncomeWithrewAmount: numbers[11],
585             registerTime: numbers[12],
586             minDeposit: MIN_DEP
587         });
588         investors[addresses[4]] = investor;
589         investorAddresses.push(addresses[4]);
590         if (addresses[3] == address(0)) return; 
591         Investor storage presenter = investors[addresses[3]];
592         presenter.presentees.push(addresses[4]);
593     }
594     
595     function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
596         if (investments[id].at != 0) return;
597         Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
598         investments[id] = investment;
599         investmentIds.push(id);
600         Investor storage investor = investors[investorAddress];
601         investor.investments.push(id);
602         depositedAmountGross += amount;
603     }
604     
605     function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
606         if (withdrawals[id].at != 0) return;
607         Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
608         withdrawals[id] = withdrawal;
609         Investor storage investor = investors[investorAddress];
610         investor.withdrawals.push(id);
611         withdrawalIds.push(id);
612     }
613     
614     function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
615         paySystemCommissionTimes = _paySystemCommissionTimes;
616         payDailyIncomeTimes = _payDailyIncomeTimes;
617         lastPaySystemCommission = _lastPaySystemCommission;
618         lastPayDailyIncome = _lastPayDailyIncome;
619         contractStartAt = _contractStartAt;
620         lastReset = _lastReset;
621     }
622     
623     function finishImporting() public mustBeAdmin { importing = false; }
624 
625     function finalizeVotes(uint256 from, uint256 to) public mustBeAdmin {
626         require(now - currentVote.startTime > ONE_DAY);
627         uint8 rootVote = currentVote.votes[investorAddresses[0]];
628         require(rootVote != 0);
629         for (uint256 index = from; index < to; index++) {
630             address investorAddress = investorAddresses[index];
631             if (investors[investorAddress].depositedAmount == 0) continue;
632             if (currentVote.votes[investorAddress] != 0) continue;
633             currentVote.votes[investorAddress] = rootVote;
634             if (rootVote == 1) currentVote.noPoint += 1;
635             else currentVote.yesPoint += 1;
636         }
637     }
638 
639     function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
640         require(currentVote.startTime == 0);
641         uint256 totalPoint = getAvailableToVote();
642         currentVote = Vote({
643             startTime: now,
644             reason: reason,
645             emergencyAddress: emergencyAddress,
646             yesPoint: 0,
647             noPoint: 0,
648             totalPoint: totalPoint
649         });
650     }
651 
652     function removeVote() public mustBeAdmin {
653         currentVote.startTime = 0;
654         currentVote.reason = '';
655         currentVote.emergencyAddress = address(0);
656         currentVote.yesPoint = 0;
657         currentVote.noPoint = 0;
658     }
659     
660     function sendEtherToNewContract() public mustBeAdmin {
661         require(currentVote.startTime != 0);
662         require(now - currentVote.startTime > 3 * ONE_DAY);
663         require(currentVote.yesPoint > currentVote.totalPoint / 2);
664         require(currentVote.emergencyAddress != address(0));
665         currentVote.emergencyAddress.transfer(address(this).balance);
666     }
667 
668     function voteProcess(address investor, bool isYes) internal {
669         require(investors[investor].depositedAmount > 0);
670         require(now - currentVote.startTime < ONE_DAY);
671         uint8 newVoteValue = isYes ? 2 : 1;
672         uint8 currentVoteValue = currentVote.votes[investor];
673         require(newVoteValue != currentVoteValue);
674         updateVote(isYes);
675         if (currentVoteValue == 0) return;
676         if (isYes) {
677             currentVote.noPoint -= getVoteShare();
678         } else {
679             currentVote.yesPoint -= getVoteShare();
680         }
681     }
682     
683     function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
684     
685     function updateVote(bool isYes) internal {
686         currentVote.votes[msg.sender] = isYes ? 2 : 1;
687         if (isYes) {
688             currentVote.yesPoint += getVoteShare();
689         } else {
690             currentVote.noPoint += getVoteShare();
691         }
692     }
693     
694     function getVoteShare() public view returns(uint256) {
695         if (investors[msg.sender].generation >= 3) return 1;
696         if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
697         return 2;
698     }
699     function getAvailableToVote() public view returns(uint256) {
700         uint256 count = 0;
701         for (uint256 i = 0; i < investorAddresses.length; i++) {
702             Investor memory investor = investors[investorAddresses[i]];
703             if (investor.depositedAmount > 0) count++; 
704         }
705         return count;
706     }
707     function setEnv(uint256 _maxLevelsAddSale) public {
708         maxLevelsAddSale = _maxLevelsAddSale;
709     }
710 }
711 contract Querier {
712     Operator public operator;
713     
714     function setOperator(address payable operatorAddress) public {
715         operator = Operator(operatorAddress);
716     }
717     
718     function getContractInfo() public view returns (address admin, uint256 depositedAmountGross, uint256 investorsCount, address operationFund, uint256 balance, uint256 paySystemCommissionTimes, uint256 maximumMaxOutInWeek) {
719         depositedAmountGross = operator.depositedAmountGross();
720         admin = operator.admin();
721         operationFund = operator.operationFund();
722         balance = address(operator).balance;
723         paySystemCommissionTimes = operator.paySystemCommissionTimes();
724         maximumMaxOutInWeek = operator.maximumMaxOutInWeek();
725         return (admin, depositedAmountGross, operator.getInvestorLength(), operationFund, balance, paySystemCommissionTimes, maximumMaxOutInWeek);
726     }
727 
728     function getContractTime() public view returns (uint256 contractStartAt, uint256 lastReset, uint256 oneDay, uint256 lastPayDailyIncome, uint256 lastPaySystemCommission) {
729         return (operator.contractStartAt(), operator.lastReset(), operator.ONE_DAY(), operator.lastPayDailyIncome(), operator.lastPaySystemCommission());
730     }
731     
732     function getInvestor(address investorAddress) public view returns(bytes32 email, address[] memory addresses, bool isDisabled, uint256[] memory numbers) {
733         addresses = new address[](4);
734         numbers = new uint256[](16);
735         (email, addresses[0], addresses[1], addresses[2], addresses[3]) = operator.getInvestorPart1(investorAddress);
736         (numbers[0], numbers[1], numbers[2], isDisabled) = operator.getInvestorPart2(investorAddress);
737         (numbers[3], numbers[4], numbers[5], numbers[6], numbers[7]) = operator.getInvestorPart3(investorAddress);
738         (numbers[8], numbers[9], numbers[10], numbers[11], numbers[12]) = operator.getInvestorPart4(investorAddress);
739         (numbers[13], numbers[14], numbers[15]) = operator.getInvestorPart5(investorAddress);
740         return (email, addresses, isDisabled, numbers);
741     }
742 
743     function getMaxOuts() public view returns (bytes32[] memory ids, address[] memory investors, uint256[] memory times, uint256[] memory ats) {
744         uint256 length = operator.getMaxOutsLength();
745         ids = new bytes32[] (length);
746         investors = new address[] (length);
747         times = new uint256[] (length);
748         ats = new uint256[] (length);
749         for (uint256 i = 0; i < length; i++) {
750             bytes32 id = operator.maxOutIds(i);
751             address investor;
752             uint256 time;
753             uint256 at;
754             (id, investor, time, at) = operator.maxOuts(id);
755             ids[i] = id;
756             times[i] = time;
757             investors[i] = investor;
758             ats[i] = at;
759         }
760         return (ids, investors, times, ats);
761     }
762     
763     function getInvestorTree(address rootInvestor) public view returns(address[] memory nodeInvestors, bytes32[] memory emails, uint256[] memory leftSells, uint256[] memory rightSells, address[] memory parents, uint256[] memory generations, uint256[] memory deposits){
764         nodeInvestors = operator.getNodesAddresses(rootInvestor);
765         uint256 length = nodeInvestors.length;
766         leftSells = new uint256[](length);
767         rightSells = new uint256[](length);
768         emails = new bytes32[] (length);
769         parents = new address[] (length);
770         generations = new uint256[] (length);
771         deposits = new uint256[] (length);
772         for (uint256 i = 0; i < length; i++) {
773             (emails[i], parents[i], leftSells[i], rightSells[i], generations[i], deposits[i]) = getOneNode(nodeInvestors[i]);
774         }
775         return (nodeInvestors, emails, leftSells, rightSells, parents, generations, deposits);
776     }
777     
778     function getOneNode(address investorAddress) internal view returns(bytes32 email, address parent, uint256 leftSell, uint256 rightSell, uint256 generation, uint256 deposit) {
779         (email, parent, , ,) = operator.getInvestorPart1(investorAddress);
780         (generation, deposit, ,) = operator.getInvestorPart2(investorAddress);
781         (rightSell, leftSell, , ,) = operator.getInvestorPart4(investorAddress);
782         return (email, parent, leftSell, rightSell, generation, deposit);
783     }
784     
785     function getListInvestorPart1() public view returns (address[] memory investors, bytes32[] memory emails, address[] memory parents, address[] memory leftChilds, address[] memory rightChilds, address[] memory presenters) {
786         uint256 length = operator.getInvestorLength();
787         investors = new address[] (length);
788         emails = new bytes32[] (length);
789         emails = new bytes32[] (length);
790         parents = new address[] (length);
791         leftChilds = new address[] (length);
792         rightChilds = new address[] (length);
793         presenters = new address[] (length);
794         for (uint256 i = 0; i < length; i++) {
795             address investorAddress = operator.investorAddresses(i);
796             bytes32 email;
797             address parent;
798             address leftChild;
799             address rightChild;
800             address presenter;
801             (email, parent, leftChild, rightChild, presenter) = operator.getInvestorPart1(investorAddress);
802             investors[i] = investorAddress;
803             emails[i] = email;
804             parents[i] = parent;
805             leftChilds[i] = leftChild;
806             rightChilds[i] = rightChild;
807             presenters[i] = presenter;
808         }
809         return (investors, emails, parents, leftChilds, rightChilds, presenters);
810     }
811 
812     function getListInvestorPart2() public view returns (address[] memory investors, uint256[] memory generations, uint256[] memory depositedAmounts, uint256[] memory withdrewAmounts, bool[] memory isDisableds) {
813         uint256 length = operator.getInvestorLength();
814         investors = new address[] (length);
815         generations = new uint256[] (length);
816         depositedAmounts = new uint256[] (length);
817         withdrewAmounts = new uint256[] (length);
818         isDisableds = new bool[] (length);
819         for (uint256 i = 0; i < length; i++) {
820             address investorAddress = operator.investorAddresses(i);
821             uint256 depositedAmount;
822             uint256 withdrewAmount;
823             bool isDisabled;
824             uint256 generation;
825             (generation, depositedAmount, withdrewAmount, isDisabled) = operator.getInvestorPart2(investorAddress);
826             investors[i] = investorAddress;
827             depositedAmounts[i] = depositedAmount;
828             withdrewAmounts[i] = withdrewAmount;
829             isDisableds[i] = isDisabled;
830             generations[i] = generation;
831         }
832         return (investors, generations, depositedAmounts, withdrewAmounts, isDisableds);
833     }
834     
835     function getListInvestorPart3() public view returns (address[] memory investors, uint256[] memory lastMaxOuts, uint256[] memory maxOutTimes, uint256[] memory maxOutTimesInWeeks, uint256[] memory totalSells, uint256[] memory sellThisMonths) {
836         uint256 length = operator.getInvestorLength();
837         investors = new address[] (length);
838         lastMaxOuts = new uint256[] (length);
839         maxOutTimes = new uint256[] (length);
840         maxOutTimesInWeeks = new uint256[] (length);
841         totalSells = new uint256[] (length);
842         sellThisMonths = new uint256[] (length);
843         for (uint256 i = 0; i < length; i++) {
844             address investorAddress = operator.investorAddresses(i);
845             uint256 lastMaxOut;
846             uint256 maxOutTime;
847             uint256 maxOutTimesInWeek;
848             uint256 totalSell;
849             uint256 sellThisMonth;
850             (lastMaxOut, maxOutTime, maxOutTimesInWeek, totalSell, sellThisMonth) = operator.getInvestorPart3(investorAddress);
851             investors[i] = investorAddress;
852             lastMaxOuts[i] = maxOutTime;
853             maxOutTimes[i] = maxOutTimesInWeek;
854             maxOutTimesInWeeks[i] = maxOutTimesInWeek;
855             totalSells[i] = totalSell;
856             sellThisMonths[i] = sellThisMonth;
857         }
858         return (investors, lastMaxOuts, maxOutTimes, maxOutTimesInWeeks, totalSells, sellThisMonths);
859     }
860     
861     function getListInvestorPart4() public view returns (address[] memory investors, uint256[] memory rightSells, uint256[] memory leftSells, uint256[] memory reserveCommissions, uint256[] memory dailyIncomeWithrewAmounts, uint256[] memory registerTimes) {
862         uint256 length = operator.getInvestorLength();
863         investors = new address[] (length);
864         rightSells = new uint256[] (length);
865         leftSells = new uint256[] (length);
866         reserveCommissions = new uint256[] (length);
867         dailyIncomeWithrewAmounts = new uint256[] (length);
868         registerTimes = new uint256[] (length);
869         for (uint256 i = 0; i < length; i++) {
870             address investorAddress = operator.investorAddresses(i);
871             uint256 rightSell;
872             uint256 leftSell;
873             uint256 reserveCommission;
874             uint256 dailyIncomeWithrewAmount;
875             uint256 registerTime;
876             (rightSell, leftSell, reserveCommission, dailyIncomeWithrewAmount, registerTime) = operator.getInvestorPart4(investorAddress);
877             investors[i] = investorAddress;
878             rightSells[i] = rightSell;
879             leftSells[i] = leftSell;
880             reserveCommissions[i] = reserveCommission;
881             dailyIncomeWithrewAmounts[i] = dailyIncomeWithrewAmount;
882             registerTimes[i] = registerTime;
883         }
884         return (investors, rightSells, leftSells, reserveCommissions, dailyIncomeWithrewAmounts, registerTimes);
885     }
886     
887     function getListInvestorPart5() public view returns (address[] memory investors, uint256[] memory unpaidSystemCommissions, uint256[] memory unpaidDailyIncomes, uint256[] memory minDeposits) {
888         uint256 length = operator.getInvestorLength();
889         investors = new address[] (length);
890         unpaidSystemCommissions = new uint256[] (length);
891         unpaidDailyIncomes = new uint256[] (length);
892         minDeposits = new uint256[] (length);
893         for (uint256 i = 0; i < length; i++) {
894             address investorAddress = operator.investorAddresses(i);
895             uint256 unpaidDailyIncome;
896             uint256 unpaidSystemCommission;
897             uint256 minDeposit;
898             (unpaidSystemCommission, unpaidDailyIncome, minDeposit) = operator.getInvestorPart5(investorAddress);
899             investors[i] = investorAddress;
900             unpaidSystemCommissions[i] = unpaidSystemCommission;
901             unpaidDailyIncomes[i] = unpaidDailyIncome;
902             minDeposits[i] = minDeposit;
903         }
904         return (investors, unpaidSystemCommissions, unpaidDailyIncomes, minDeposits);
905     }
906     
907     function getInvestmentById(bytes32 investmentId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address nextInvestor, bool nextBranch) {
908         return operator.investments(investmentId);
909     }
910     
911     function getWithdrawalById(bytes32 withdrawalId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address presentee, uint256 reason, uint256 times) {
912         return operator.withdrawals(withdrawalId);
913     }
914     
915     function getEmailByAddress(address investorAddress) public view returns (bytes32) {
916         bytes32 email;
917         (email,,,,) = operator.getInvestorPart1(investorAddress);
918         return email;
919     }
920     
921     function getInvestments(address investorAddress, uint256 start, uint256 end) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, bytes32[] memory emails) {
922         uint256 length = operator.getInvestmentsLength();
923         ids = new bytes32[](length);
924         ats = new uint256[](length);
925         amounts = new uint256[](length);
926         emails = new bytes32[](length);
927         uint256 index = 0;
928         for (uint256 i = 0; i < length; i++) {
929             bytes32 id = operator.investmentIds(i);
930             uint256 at;
931             uint256 amount;
932             address investor;
933             (id, at, amount, investor,,) = getInvestmentById(id);
934             if (investorAddress != address(0) && investor != investorAddress) continue;
935             if (at < start || at > end) continue;
936             ids[index] = id;
937             ats[index] = at;
938             amounts[index] = amount;
939             emails[index] = getEmailByAddress(investor);
940             index++;
941         }
942         return (ids, ats, amounts, emails);
943     }
944     
945     function getIncompletedInvestments() public view returns(bytes32[] memory ids, address[] memory nextInvestors, uint256[] memory amounts, bytes32[] memory emails) {
946         uint256 length = operator.getInvestmentsLength();
947         ids = new bytes32[](10);
948         nextInvestors = new address[](10);
949         amounts = new uint256[](10);
950         emails = new bytes32[](10);
951         uint256 index = 0;
952         for (uint256 i = 0; i < length; i++) {
953             bytes32 id = operator.investmentIds(i);
954             uint256 amount;
955             address investor;
956             address nextInvestor;
957             (id, , amount, investor, nextInvestor, ) = getInvestmentById(id);
958             if (nextInvestor == address(0)) continue;
959             ids[index] = id;
960             nextInvestors[index] = nextInvestor;
961             amounts[index] = amount;
962             emails[index] = getEmailByAddress(investor);
963             index++;
964         }
965         return (ids, nextInvestors, amounts, emails);
966     }
967     
968     function getWithdrawals(address investorAddress, uint256 start, uint256 end) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, bytes32[] memory emails, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) {
969         uint256 length = operator.getWithdrawalsLength();
970         ids = new bytes32[](length);
971         ats = new uint256[](length);
972         amounts = new uint256[](length);
973         emails = new bytes32[](length);
974         presentees = new address[](length);
975         reasons = new uint256[](length);
976         times = new uint256[](length);
977         putWithdrawalsPart1(investorAddress, start, end, length, ids, ats, amounts, emails);
978         putWithdrawalsPart2(investorAddress, start, end, length, presentees, reasons, times);
979         return (ids, ats, amounts, emails, presentees, reasons, times);
980     }
981     
982     function putWithdrawalsPart1(address investorAddress, uint256 start, uint256 end, uint256 length, bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, bytes32[] memory emails) internal view {
983         uint256 index = 0;
984         for (uint256 i = 0; i < length; i++) {
985             bytes32 id = operator.withdrawalIds(i);
986             uint256 at;
987             uint256 amount;
988             address investor;
989             (id, at, amount, investor, , , ) = getWithdrawalById(id);
990             if (investorAddress != address(0) && investor != investorAddress) continue;
991             if (at < start || at > end) continue;
992             ids[index] = id;
993             ats[index] = at;
994             amounts[index] = amount;
995             emails[index] = getEmailByAddress(investor);
996             index++;
997         }
998     }
999     
1000     function putWithdrawalsPart2(address investorAddress, uint256 start, uint256 end, uint256 length, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) internal view {
1001         uint256 index = 0;
1002         for (uint256 i = 0; i < length; i++) {
1003             bytes32 id = operator.withdrawalIds(i);
1004             uint256 reason;
1005             uint256 time;
1006             address presentee;
1007             address investor;
1008             uint256 at;
1009             (, at, , , presentee, reason, time) = getWithdrawalById(id);
1010             if (investorAddress != address(0) && investor != investorAddress) continue;
1011             if (at < start || at > end) continue;
1012             reasons[index] = reason;
1013             times[index] = time;
1014             presentees[index] = presentee;
1015             index++;
1016         }
1017     }
1018 
1019     function getCurrentVote() public view returns(uint256 startTime, string memory reason, address payable emergencyAddress, uint256 yesPoint, uint256 noPoint, uint256 totalPoint) {
1020         (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint) = operator.currentVote();
1021         return (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint);
1022     }
1023 }