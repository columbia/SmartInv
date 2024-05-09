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
433     function resetMaxOutInWeek() public mustBeAdmin {
434         uint256 length = investorAddresses.length;
435         for (uint256 i = 0; i < length; i++) {
436             address investorAddress = investorAddresses[i];
437             investors[investorAddress].maxOutTimesInWeek = 0;
438         }
439     }
440 
441     function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }
442 
443     function disableInvestor(address investorAddress) public mustBeAdmin {
444         Investor storage investor = investors[investorAddress];
445         investor.isDisabled = true;
446     }
447     
448     function enableInvestor(address investorAddress) public mustBeAdmin {
449         Investor storage investor = investors[investorAddress];
450         investor.isDisabled = false;
451     }
452     
453     function donate() payable public { depositedAmountGross += msg.value; }
454 
455     // Utils helpers
456     
457     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
458         if (totalSell < 30 ether) return 0;
459         if (totalSell < 60 ether) return 1;
460         if (totalSell < 90 ether) return 2;
461         if (totalSell < 120 ether) return 3;
462         if (totalSell < 150 ether) return 4;
463         return 5;
464     }
465 
466     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
467         if (sellThisMonth < 2 ether) return 0;
468         if (sellThisMonth < 4 ether) return 1;
469         if (sellThisMonth < 6 ether) return 2;
470         if (sellThisMonth < 8 ether) return 3;
471         if (sellThisMonth < 10 ether) return 4;
472         return 5;
473     }
474     
475     function getDepositLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
476         if (sellThisMonth < 2 ether) return 0;
477         if (sellThisMonth < 4 ether) return 1;
478         if (sellThisMonth < 6 ether) return 2;
479         if (sellThisMonth < 8 ether) return 3;
480         if (sellThisMonth < 10 ether) return 4;
481         return 5;
482     }
483     
484     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
485         uint256 totalSellLevel = getTotalSellLevel(totalSell);
486         uint256 depLevel = getDepositLevel(depositedAmount);
487         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
488         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
489         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
490         return minLevel * 2;
491     }
492     
493     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
494         bytes memory tempEmptyStringTest = bytes(source);
495         if (tempEmptyStringTest.length == 0) return 0x0;
496         assembly { result := mload(add(source, 32)) }
497     }
498     
499     // query investor helpers
500 
501     function getInvestorPart1(address investorAddress) view public returns (bytes32 email, address parent, address leftChild, address rightChild, address presenter) {
502         Investor memory investor = investors[investorAddress];
503         return (stringToBytes32(investor.email), investor.parent, investor.leftChild, investor.rightChild, investor.presenter);
504     }
505     
506     function getInvestorPart2(address investorAddress) view public returns (uint256 generation, uint256 depositedAmount, uint256 withdrewAmount, bool isDisabled) {
507         Investor memory investor = investors[investorAddress];
508         return (investor.generation, investor.depositedAmount, investor.withdrewAmount, investor.isDisabled);
509     }
510     
511     function getInvestorPart3(address investorAddress) view public returns (uint256 lastMaxOut, uint256 maxOutTimes, uint256 maxOutTimesInWeek, uint256 totalSell, uint256 sellThisMonth) {
512         Investor memory investor = investors[investorAddress];
513         return (investor.lastMaxOut, investor.maxOutTimes, investor.maxOutTimesInWeek, investor.totalSell, investor.sellThisMonth);
514     }
515 
516     function getInvestorPart4(address investorAddress) view public returns (uint256 rightSell, uint256 leftSell, uint256 reserveCommission, uint256 dailyIncomeWithrewAmount, uint256 registerTime) {
517         Investor memory investor = investors[investorAddress];
518         return (investor.rightSell, investor.leftSell, investor.reserveCommission, investor.dailyIncomeWithrewAmount, investor.registerTime);
519     }
520 
521     function getInvestorPart5(address investorAddress) view public returns (uint256 unpaidSystemCommission, uint256 unpaidDailyIncome, uint256 minDeposit) {
522         return (
523             getUnpaidSystemCommission(investorAddress),
524             getDailyIncomeForUser(investorAddress),
525             investors[investorAddress].minDeposit
526         ); 
527     }
528 
529     function getInvestorPart6(address investorAddress) view public returns (address[] memory presentees, bytes32[] memory _investments, bytes32[] memory _withdrawals) {
530         Investor memory investor = investors[investorAddress];
531         return (investor.presentees, investor.investments ,investor.withdrawals);
532     }
533 
534     function getInvestorLength() view public returns(uint256) { return investorAddresses.length; }
535 
536     function getMaxOutsLength() view public returns(uint256) { return maxOutIds.length; }
537     
538     function getNodesAddresses(address rootNodeAddress) public view returns(address[] memory){
539         uint256 maxLength = investorAddresses.length;
540         address[] memory nodes = new address[](maxLength);
541         nodes[0] = rootNodeAddress;
542         uint256 processIndex = 0;
543         uint256 nextIndex = 1;
544         while (processIndex != nextIndex) {
545             Investor memory currentInvestor = investors[nodes[processIndex++]];
546             if (currentInvestor.leftChild != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;
547             if (currentInvestor.rightChild != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;
548         }
549         return nodes;
550     }
551     
552     // query investments and withdrawals helpers
553     
554     function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
555     
556     function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
557     
558     // import helper
559 
560     function importInvestor(string memory email, address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
561         Investor memory investor = Investor({
562             email: email,
563             isDisabled: isDisabled,
564             parent: addresses[0],
565             leftChild: addresses[1],
566             rightChild: addresses[2],
567             presenter: addresses[3],
568             generation: numbers[0],
569             presentees: new address[](0),
570             depositedAmount: numbers[1],
571             withdrewAmount: numbers[2],
572             lastMaxOut: numbers[3],
573             maxOutTimes: numbers[4],
574             maxOutTimesInWeek: numbers[5],
575             totalSell: numbers[6],
576             sellThisMonth: numbers[7],
577             investments: new bytes32[](0),
578             withdrawals: new bytes32[](0),
579             rightSell: numbers[8],
580             leftSell: numbers[9],
581             reserveCommission: numbers[10],
582             dailyIncomeWithrewAmount: numbers[11],
583             registerTime: numbers[12],
584             minDeposit: MIN_DEP
585         });
586         investors[addresses[4]] = investor;
587         investorAddresses.push(addresses[4]);
588         if (addresses[3] == address(0)) return; 
589         Investor storage presenter = investors[addresses[3]];
590         presenter.presentees.push(addresses[4]);
591     }
592     
593     function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
594         Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
595         investments[id] = investment;
596         investmentIds.push(id);
597         Investor storage investor = investors[investorAddress];
598         investor.investments.push(id);
599         depositedAmountGross += amount;
600     }
601     
602     function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
603         Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
604         withdrawals[id] = withdrawal;
605         Investor storage investor = investors[investorAddress];
606         investor.withdrawals.push(id);
607         withdrawalIds.push(id);
608     }
609     
610     function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
611         paySystemCommissionTimes = _paySystemCommissionTimes;
612         payDailyIncomeTimes = _payDailyIncomeTimes;
613         lastPaySystemCommission = _lastPaySystemCommission;
614         lastPayDailyIncome = _lastPayDailyIncome;
615         contractStartAt = _contractStartAt;
616         lastReset = _lastReset;
617     }
618     
619     function finishImporting() public mustBeAdmin { importing = false; }
620 
621     function finalizeVotes(uint256 from, uint256 to) public mustBeAdmin {
622         require(now - currentVote.startTime > ONE_DAY);
623         uint8 rootVote = currentVote.votes[investorAddresses[0]];
624         require(rootVote != 0);
625         for (uint256 index = from; index < to; index++) {
626             address investorAddress = investorAddresses[index];
627             if (investors[investorAddress].depositedAmount == 0) continue;
628             if (currentVote.votes[investorAddress] != 0) continue;
629             currentVote.votes[investorAddress] = rootVote;
630             if (rootVote == 1) currentVote.noPoint += 1;
631             else currentVote.yesPoint += 1;
632         }
633     }
634 
635     function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
636         require(currentVote.startTime == 0);
637         uint256 totalPoint = getAvailableToVote();
638         currentVote = Vote({
639             startTime: now,
640             reason: reason,
641             emergencyAddress: emergencyAddress,
642             yesPoint: 0,
643             noPoint: 0,
644             totalPoint: totalPoint
645         });
646     }
647 
648     function removeVote() public mustBeAdmin {
649         currentVote.startTime = 0;
650         currentVote.reason = '';
651         currentVote.emergencyAddress = address(0);
652         currentVote.yesPoint = 0;
653         currentVote.noPoint = 0;
654     }
655     
656     function sendEtherToNewContract() public mustBeAdmin {
657         require(currentVote.startTime != 0);
658         require(now - currentVote.startTime > 3 * ONE_DAY);
659         require(currentVote.yesPoint > currentVote.totalPoint / 2);
660         require(currentVote.emergencyAddress != address(0));
661         currentVote.emergencyAddress.transfer(address(this).balance);
662     }
663 
664     function voteProcess(address investor, bool isYes) internal {
665         require(investors[investor].depositedAmount > 0);
666         require(now - currentVote.startTime < ONE_DAY);
667         uint8 newVoteValue = isYes ? 2 : 1;
668         uint8 currentVoteValue = currentVote.votes[investor];
669         require(newVoteValue != currentVoteValue);
670         updateVote(isYes);
671         if (currentVoteValue == 0) return;
672         if (isYes) {
673             currentVote.noPoint -= getVoteShare();
674         } else {
675             currentVote.yesPoint -= getVoteShare();
676         }
677     }
678     
679     function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
680     
681     function updateVote(bool isYes) internal {
682         currentVote.votes[msg.sender] = isYes ? 2 : 1;
683         if (isYes) {
684             currentVote.yesPoint += getVoteShare();
685         } else {
686             currentVote.noPoint += getVoteShare();
687         }
688     }
689     
690     function getVoteShare() public view returns(uint256) {
691         if (investors[msg.sender].generation >= 3) return 1;
692         if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
693         return 2;
694     }
695 
696     function getAvailableToVote() public view returns(uint256) {
697         uint256 count = 0;
698         for (uint256 i = 0; i < investorAddresses.length; i++) {
699             Investor memory investor = investors[investorAddresses[i]];
700             if (investor.depositedAmount > 0) count++; 
701         }
702         return count;
703     }
704     
705     function setEnv(uint256 _maxLevelsAddSale) public {
706         maxLevelsAddSale = _maxLevelsAddSale;
707         
708     }
709  
710 }