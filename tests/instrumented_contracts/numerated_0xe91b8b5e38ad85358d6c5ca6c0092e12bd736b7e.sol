1 pragma solidity ^0.5.3;
2 
3 contract Operator {
4     uint256 public ONE_DAY = 86400;
5     uint256 public MIN_DEP = 1 ether;
6     uint256 public MAX_DEP = 100 ether;
7     address public admin;
8     address public admin2;
9     address public querierAddress;
10     uint256 public depositedAmountGross = 0;
11     uint256 public paySystemCommissionTimes = 1;
12     uint256 public payDailyIncomeTimes = 1;
13     uint256 public lastPaySystemCommission = now;
14     uint256 public lastPayDailyIncome = now;
15     uint256 public contractStartAt = now;
16     uint256 public lastReset = now;
17     address payable public operationFund = 0x4357DE4549a18731fA8bF3c7b69439E87FAff8F6;
18     address[] public investorAddresses;
19     bytes32[] public investmentIds;
20     bytes32[] public withdrawalIds;
21     bytes32[] public maxOutIds;
22     mapping (address => Investor) investors;
23     mapping (bytes32 => Investment) public investments;
24     mapping (bytes32 => Withdrawal) public withdrawals;
25     mapping (bytes32 => MaxOut) public maxOuts;
26     uint256 additionNow = 0;
27 
28     uint256 public maxLevelsAddSale = 200;
29     uint256 public maximumMaxOutInWeek = 2;
30     bool public importing = true;
31 
32     Vote public currentVote;
33 
34     struct Vote {
35         uint256 startTime;
36         string reason;
37         mapping (address => uint8) votes;
38         address payable emergencyAddress;
39         uint256 yesPoint;
40         uint256 noPoint;
41         uint256 totalPoint;
42     }
43 
44     struct Investment {
45         bytes32 id;
46         uint256 at;
47         uint256 amount;
48         address investor;
49         address nextInvestor;
50         bool nextBranch;
51     }
52 
53     struct Withdrawal {
54         bytes32 id;
55         uint256 at;
56         uint256 amount;
57         address investor;
58         address presentee;
59         uint256 reason;
60         uint256 times;
61     }
62 
63     struct Investor {
64         address parent;
65         address leftChild;
66         address rightChild;
67         address presenter;
68         uint256 generation;
69         uint256 depositedAmount;
70         uint256 withdrewAmount;
71         bool isDisabled;
72         uint256 lastMaxOut;
73         uint256 maxOutTimes;
74         uint256 maxOutTimesInWeek;
75         uint256 totalSell;
76         uint256 sellThisMonth;
77         uint256 rightSell;
78         uint256 leftSell;
79         uint256 reserveCommission;
80         uint256 dailyIncomeWithrewAmount;
81         uint256 registerTime;
82         uint256 minDeposit;
83         bytes32[] investments;
84         bytes32[] withdrawals;
85     }
86 
87     struct MaxOut {
88         bytes32 id;
89         address investor;
90         uint256 times;
91         uint256 at;
92     }
93 
94     constructor () public { admin = msg.sender; }
95     
96     modifier mustBeAdmin() {
97         require(msg.sender == admin || msg.sender == querierAddress || msg.sender == admin2);
98         _;
99     }
100 
101     modifier mustBeImporting() { require(importing); require(msg.sender == querierAddress || msg.sender == admin); _; }
102     
103     function () payable external { deposit(); }
104 
105     function getNow() internal view returns(uint256) {
106         return additionNow + now;
107     }
108 
109     function depositProcess(address sender) internal {
110         Investor storage investor = investors[sender];
111         require(investor.generation != 0);
112         if (investor.depositedAmount == 0) require(msg.value >= investor.minDeposit);
113         require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
114         require(investor.maxOutTimes < 50);
115         require(investor.maxOutTimes == 0 || getNow() - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
116         depositedAmountGross += msg.value;
117         bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), sender, msg.value));
118         uint256 investmentValue = investor.depositedAmount + msg.value <= MAX_DEP ? msg.value : MAX_DEP - investor.depositedAmount;
119         if (investmentValue == 0) return;
120         bool nextBranch = investors[investor.parent].leftChild == sender; 
121         Investment memory investment = Investment({ id: id, at: getNow(), amount: investmentValue, investor: sender, nextInvestor: investor.parent, nextBranch: nextBranch  });
122         investments[id] = investment;
123         processInvestments(id);
124         investmentIds.push(id);
125     }
126 
127     function pushNewMaxOut(address investorAddress, uint256 times, uint256 depositedAmount) internal {
128         bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), investorAddress, times));
129         MaxOut memory maxOut = MaxOut({ id: id, at: getNow(), investor: investorAddress, times: times });
130         maxOutIds.push(id);
131         maxOuts[id] = maxOut;
132         investors[investorAddress].minDeposit = depositedAmount;
133     }
134     
135     function deposit() payable public { depositProcess(msg.sender); }
136     
137     function processInvestments(bytes32 investmentId) internal {
138         Investment storage investment = investments[investmentId];
139         uint256 amount = investment.amount;
140         Investor storage investor = investors[investment.investor];
141         investor.investments.push(investmentId);
142         investor.depositedAmount += amount;
143         address payable presenterAddress = address(uint160(investor.presenter));
144         Investor storage presenter = investors[presenterAddress];
145         if (presenterAddress != address(0)) {
146             presenter.totalSell += amount;
147             presenter.sellThisMonth += amount;
148         }
149         if (presenter.depositedAmount >= MIN_DEP && !presenter.isDisabled) {
150             sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
151         }
152     }
153 
154     function addSellForParents(bytes32 investmentId) public mustBeAdmin {
155         Investment storage investment = investments[investmentId];
156         require(investment.nextInvestor != address(0));
157         uint256 amount = investment.amount;
158         uint256 loopCount = 0;
159         while (investment.nextInvestor != address(0) && loopCount < maxLevelsAddSale) {
160             Investor storage investor = investors[investment.nextInvestor];
161             if (investment.nextBranch) investor.leftSell += amount;
162             else investor.rightSell += amount;
163             investment.nextBranch = investors[investor.parent].leftChild == investment.nextInvestor;
164             investment.nextInvestor = investor.parent;
165             loopCount++;
166         }
167     }
168 
169     function sendEtherForInvestor(address payable investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
170         if (value == 0 && reason != 100) return; // value only equal zero when pay to reach max out
171         if (investorAddress == address(0)) return;
172         Investor storage investor = investors[investorAddress];
173         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
174         uint256 totalPaidAfterThisTime = investor.reserveCommission + getDailyIncomeForUser(investorAddress) + unpaidSystemCommission;
175         if (reason == 1) totalPaidAfterThisTime += value; // gioi thieu truc tiep
176         if (totalPaidAfterThisTime + investor.withdrewAmount >= 3 * investor.depositedAmount) { // max out
177             payWithMaxOut(totalPaidAfterThisTime, investorAddress, unpaidSystemCommission);
178             return;
179         }
180         if (investor.reserveCommission > 0) payWithNoMaxOut(investor.reserveCommission, investorAddress, 4, address(0), 0);
181         payWithNoMaxOut(value, investorAddress, reason, presentee, times);
182     }
183     
184     function payWithNoMaxOut(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
185         investors[investorAddress].withdrewAmount += amountToPay;
186         if (reason == 4) investors[investorAddress].reserveCommission = 0;
187         if (reason == 3) resetSystemCommision(investorAddress, times);
188         if (reason == 2) investors[investorAddress].dailyIncomeWithrewAmount += amountToPay;
189         pay(amountToPay, investorAddress, reason, presentee, times);
190     }
191     
192     function payWithMaxOut(uint256 totalPaidAfterThisTime, address payable investorAddress, uint256 unpaidSystemCommission) internal {
193         Investor storage investor = investors[investorAddress];
194         uint256 amountToPay = investor.depositedAmount * 3 - investor.withdrewAmount;
195         uint256 amountToReserve = totalPaidAfterThisTime - amountToPay;
196         if (unpaidSystemCommission > 0) resetSystemCommision(investorAddress, 0);
197         investor.maxOutTimes++;
198         investor.maxOutTimesInWeek++;
199         uint256 oldDepositedAmount = investor.depositedAmount;
200         investor.depositedAmount = 0;
201         investor.withdrewAmount = 0;
202         investor.lastMaxOut = getNow();
203         investor.dailyIncomeWithrewAmount = 0;
204         investor.reserveCommission = amountToReserve;
205         pushNewMaxOut(investorAddress, investor.maxOutTimes, oldDepositedAmount);
206         pay(amountToPay, investorAddress, 0, address(0), 0);
207     }
208 
209     function pay(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
210         if (amountToPay == 0) return;
211         investorAddress.transfer(amountToPay / 100 * 90);
212         operationFund.transfer(amountToPay / 100 * 10);
213         bytes32 id = keccak256(abi.encodePacked(block.difficulty, getNow(), investorAddress, amountToPay, reason));
214         Withdrawal memory withdrawal = Withdrawal({ id: id, at: getNow(), amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
215         withdrawals[id] = withdrawal;
216         investors[investorAddress].withdrawals.push(id);
217         withdrawalIds.push(id);
218     }
219 
220     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
221         Investor memory investor = investors[investorAddress];
222         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
223         uint256 withdrewAmount = investor.withdrewAmount;
224         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
225         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
226         return allIncomeNow;
227     }
228 
229     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, bool isLeft) public mustBeAdmin {
230         Investor storage presenter = investors[presenterAddress];
231         Investor storage parent = investors[parentAddress];
232         if (investorAddresses.length != 0) {
233             require(presenter.generation != 0);
234             require(parent.generation != 0);
235             if (isLeft) {
236                 require(parent.leftChild == address(0)); 
237             } else {
238                 require(parent.rightChild == address(0)); 
239             }
240         }
241         Investor memory investor = Investor({
242             parent: parentAddress,
243             leftChild: address(0),
244             rightChild: address(0),
245             presenter: presenterAddress,
246             generation: parent.generation + 1,
247             depositedAmount: 0,
248             withdrewAmount: 0,
249             isDisabled: false,
250             lastMaxOut: getNow(),
251             maxOutTimes: 0,
252             maxOutTimesInWeek: 0,
253             totalSell: 0,
254             sellThisMonth: 0,
255             registerTime: getNow(),
256             investments: new bytes32[](0),
257             withdrawals: new bytes32[](0),
258             minDeposit: MIN_DEP,
259             rightSell: 0,
260             leftSell: 0,
261             reserveCommission: 0,
262             dailyIncomeWithrewAmount: 0
263         });
264         investors[presenteeAddress] = investor;
265        
266         investorAddresses.push(presenteeAddress);
267         if (parent.generation == 0) return;
268         if (isLeft) {
269             parent.leftChild = presenteeAddress;
270         } else {
271             parent.rightChild = presenteeAddress;
272         }
273     }
274 
275     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
276         Investor memory investor = investors[investorAddress];
277         uint256 investmentLength = investor.investments.length;
278         uint256 dailyIncome = 0;
279         for (uint256 i = 0; i < investmentLength; i++) {
280             Investment memory investment = investments[investor.investments[i]];
281             if (investment.at < investor.lastMaxOut) continue; 
282             if (getNow() - investment.at >= ONE_DAY) {
283                 uint256 numberOfDay = (getNow() - investment.at) / ONE_DAY;
284                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
285                 dailyIncome = totalDailyIncome + dailyIncome;
286             }
287         }
288         return dailyIncome - investor.dailyIncomeWithrewAmount;
289     }
290     
291     function payDailyIncomeForInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
292         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
293         Investor storage investor = investors[investorAddress];
294         if (times > ONE_DAY) {
295             uint256 investmentLength = investor.investments.length;
296             bytes32 lastInvestmentId = investor.investments[investmentLength - 1];
297             investments[lastInvestmentId].at -= times;
298             investors[investorAddress].lastMaxOut = investments[lastInvestmentId].at;
299             return;
300         }
301         if (investor.isDisabled) return;
302         sendEtherForInvestor(investorAddress, dailyIncome, 2, address(0), times);
303     }
304     
305     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
306         require(from >= 0 && to < investorAddresses.length);
307         for(uint256 i = from; i <= to; i++) {
308             payDailyIncomeForInvestor(address(uint160(investorAddresses[i])), payDailyIncomeTimes);
309         }
310     }
311 
312     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
313         Investor memory investor = investors[investorAddress];
314         uint256 depositedAmount = investor.depositedAmount;
315         uint256 totalSell = investor.totalSell;
316         uint256 leftSell = investor.leftSell;
317         uint256 rightSell = investor.rightSell;
318         uint256 sellThisMonth = investor.sellThisMonth;
319         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
320         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
321         return commission;
322     }
323     
324     function paySystemCommissionInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
325         Investor storage investor = investors[investorAddress];
326         if (investor.isDisabled) return;
327         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
328         sendEtherForInvestor(investorAddress, systemCommission, 3, address(0), times);
329     }
330 
331     function resetSystemCommision(address investorAddress, uint256 times) internal {
332         Investor storage investor = investors[investorAddress];
333         if (paySystemCommissionTimes > 3 && times != 0) {
334             investor.rightSell = 0;
335             investor.leftSell = 0;
336         } else if (investor.rightSell >= investor.leftSell) {
337             investor.rightSell = investor.rightSell - investor.leftSell;
338             investor.leftSell = 0;
339         } else {
340             investor.leftSell = investor.leftSell - investor.rightSell;
341             investor.rightSell = 0;
342         }
343         if (times != 0) investor.sellThisMonth = 0;
344     }
345 
346     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
347          require(from >= 0 && to < investorAddresses.length);
348         // change 1 to 30
349         if (getNow() <= 30 * ONE_DAY + contractStartAt) return;
350         for(uint256 i = from; i <= to; i++) {
351             paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
352         }
353     }
354     
355     function finishPayDailyIncome() public mustBeAdmin {
356         lastPayDailyIncome = getNow();
357         payDailyIncomeTimes++;
358     }
359     
360     function finishPaySystemCommission() public mustBeAdmin {
361         lastPaySystemCommission = getNow();
362         paySystemCommissionTimes++;
363     }
364     
365     function resetGame(uint256 from, uint256 to) public mustBeAdmin {
366         require(from >= 0 && to < investorAddresses.length);
367         require(currentVote.startTime != 0);
368         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
369         require(currentVote.yesPoint > currentVote.totalPoint / 2);
370         require(currentVote.emergencyAddress == address(0));
371         lastReset = getNow();
372         for (uint256 i = from; i < to; i++) {
373             address investorAddress = investorAddresses[i];
374             Investor storage investor = investors[investorAddress];
375             uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : 2;
376             if (currentVoteValue == 2) {
377                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
378                     investor.lastMaxOut = getNow();
379                     investor.depositedAmount = 0;
380                     investor.withdrewAmount = 0;
381                     investor.dailyIncomeWithrewAmount = 0;
382                 }
383                 investor.reserveCommission = 0;
384                 investor.rightSell = 0;
385                 investor.leftSell = 0;
386                 investor.totalSell = 0;
387                 investor.sellThisMonth = 0;
388             } else {
389                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
390                     investor.isDisabled = true;
391                     investor.reserveCommission = 0;
392                     investor.lastMaxOut = getNow();
393                     investor.depositedAmount = 0;
394                     investor.withdrewAmount = 0;
395                     investor.dailyIncomeWithrewAmount = 0;
396                 }
397                 investor.reserveCommission = 0;
398                 investor.rightSell = 0;
399                 investor.leftSell = 0;
400                 investor.totalSell = 0;
401                 investor.sellThisMonth = 0;
402             }
403             
404         }
405     }
406 
407     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
408         require(currentVote.startTime != 0);
409         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
410         require(currentVote.noPoint > currentVote.totalPoint / 2);
411         require(currentVote.emergencyAddress == address(0));
412         require(percent <= 50);
413         require(from >= 0 && to < investorAddresses.length);
414         for (uint256 i = from; i <= to; i++) {
415             address payable investorAddress = address(uint160(investorAddresses[i]));
416             Investor storage investor = investors[investorAddress];
417             if (investor.maxOutTimes > 0) continue;
418             if (investor.isDisabled) continue;
419             uint256 depositedAmount = investor.depositedAmount;
420             uint256 withdrewAmount = investor.withdrewAmount;
421             if (withdrewAmount >= depositedAmount / 2) continue;
422             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
423         }
424     }
425     
426     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = getNow(); }
427 
428     function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
429         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
430         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
431         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
432         uint256 depositedAmount = investors[investorAddress].depositedAmount;
433         uint256 reserveCommission = investors[investorAddress].reserveCommission;
434         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
435         sendEtherForInvestor(investorAddress, 0, 100, address(0), 0);
436     }
437 
438     function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
439         require(from >= 0 && to < investorAddresses.length);
440         for (uint256 i = from; i < to; i++) {
441             address investorAddress = investorAddresses[i];
442             if (investors[investorAddress].maxOutTimesInWeek == 0) continue;
443             investors[investorAddress].maxOutTimesInWeek = 0;
444         }
445     }
446 
447     function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }
448 
449     function disableInvestor(address investorAddress) public mustBeAdmin {
450         Investor storage investor = investors[investorAddress];
451         investor.isDisabled = true;
452     }
453     
454     function enableInvestor(address investorAddress) public mustBeAdmin {
455         Investor storage investor = investors[investorAddress];
456         investor.isDisabled = false;
457     }
458     
459     function donate() payable public { depositedAmountGross += msg.value; }
460 
461     // Utils helpers
462     
463     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
464         if (totalSell < 30 ether) return 0;
465         if (totalSell < 60 ether) return 1;
466         if (totalSell < 90 ether) return 2;
467         if (totalSell < 120 ether) return 3;
468         if (totalSell < 150 ether) return 4;
469         return 5;
470     }
471 
472     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
473         if (sellThisMonth < 2 ether) return 0;
474         if (sellThisMonth < 4 ether) return 1;
475         if (sellThisMonth < 6 ether) return 2;
476         if (sellThisMonth < 8 ether) return 3;
477         if (sellThisMonth < 10 ether) return 4;
478         return 5;
479     }
480     
481     function getDepositLevel(uint256 depositedAmount) internal pure returns (uint256 level){
482         if (depositedAmount < 2 ether) return 0;
483         if (depositedAmount < 4 ether) return 1;
484         if (depositedAmount < 6 ether) return 2;
485         if (depositedAmount < 8 ether) return 3;
486         if (depositedAmount < 10 ether) return 4;
487         return 5;
488     }
489     
490     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
491         uint256 totalSellLevel = getTotalSellLevel(totalSell);
492         uint256 depLevel = getDepositLevel(depositedAmount);
493         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
494         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
495         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
496         return minLevel * 2;
497     }
498     
499     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
500         bytes memory tempEmptyStringTest = bytes(source);
501         if (tempEmptyStringTest.length == 0) return 0x0;
502         assembly { result := mload(add(source, 32)) }
503     }
504     
505     // query investor helpers
506 
507     function getInvestor(address investorAddress) view public returns (address[] memory addresses, bool isDisabled, uint256[] memory numbers) {
508         addresses = new address[](4);
509         numbers = new uint256[](16);
510         Investor memory investor = investors[investorAddress];
511         addresses[0] = investor.parent;
512         addresses[1] = investor.leftChild;
513         addresses[2] = investor.rightChild;
514         addresses[3] = investor.presenter;
515         numbers[0] = investor.generation;
516         numbers[1] = investor.depositedAmount;
517         numbers[2] = investor.withdrewAmount;
518         numbers[3] = investor.lastMaxOut;
519         numbers[4] = investor.maxOutTimes;
520         numbers[5] = investor.maxOutTimesInWeek;
521         numbers[6] = investor.totalSell;
522         numbers[7] = investor.sellThisMonth;
523         numbers[8] = investor.rightSell;
524         numbers[9] = investor.leftSell;
525         numbers[10] = investor.reserveCommission;
526         numbers[11] = investor.dailyIncomeWithrewAmount;
527         numbers[12] = investor.registerTime;
528         numbers[13] = getUnpaidSystemCommission(investorAddress);
529         numbers[14] = getDailyIncomeForUser(investorAddress);
530         numbers[15] = investor.minDeposit;
531         return (addresses, investor.isDisabled, numbers);
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
560     function importInvestor(address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
561         if (investors[addresses[4]].generation != 0) return;
562         Investor memory investor = Investor({
563             isDisabled: isDisabled,
564             parent: addresses[0],
565             leftChild: addresses[1],
566             rightChild: addresses[2],
567             presenter: addresses[3],
568             generation: numbers[0],
569             depositedAmount: numbers[1],
570             withdrewAmount: numbers[2],
571             lastMaxOut: numbers[3],
572             maxOutTimes: numbers[4],
573             maxOutTimesInWeek: numbers[5],
574             totalSell: numbers[6],
575             sellThisMonth: numbers[7],
576             investments: new bytes32[](0),
577             withdrawals: new bytes32[](0),
578             rightSell: numbers[8],
579             leftSell: numbers[9],
580             reserveCommission: numbers[10],
581             dailyIncomeWithrewAmount: numbers[11],
582             registerTime: numbers[12],
583             minDeposit: MIN_DEP
584         });
585         investors[addresses[4]] = investor;
586         investorAddresses.push(addresses[4]);
587     }
588     
589     function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
590         if (investments[id].at != 0) return;
591         Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
592         investments[id] = investment;
593         investmentIds.push(id);
594         Investor storage investor = investors[investorAddress];
595         investor.investments.push(id);
596         depositedAmountGross += amount;
597     }
598     
599     function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
600         if (withdrawals[id].at != 0) return;
601         Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
602         withdrawals[id] = withdrawal;
603         Investor storage investor = investors[investorAddress];
604         investor.withdrawals.push(id);
605         withdrawalIds.push(id);
606     }
607     
608     function finishImporting() public mustBeAdmin { importing = false; }
609 
610     function finalizeVotes(uint256 from, uint256 to) public mustBeAdmin {
611         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
612         for (uint256 index = from; index < to; index++) {
613             address investorAddress = investorAddresses[index];
614             if (currentVote.votes[investorAddress] != 0) continue;
615             currentVote.votes[investorAddress] = 2;
616             currentVote.yesPoint += 1;
617         }
618     }
619 
620     function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
621         require(currentVote.startTime == 0);
622         currentVote = Vote({
623             startTime: getNow(),
624             reason: reason,
625             emergencyAddress: emergencyAddress,
626             yesPoint: 0,
627             noPoint: 0,
628             totalPoint: investorAddresses.length
629         });
630     }
631 
632     function removeVote() public mustBeAdmin {
633         currentVote.startTime = 0;
634         currentVote.reason = '';
635         currentVote.emergencyAddress = address(0);
636         currentVote.yesPoint = 0;
637         currentVote.noPoint = 0;
638     }
639     
640     function sendEtherToNewContract() public mustBeAdmin {
641         require(currentVote.startTime != 0);
642         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
643         require(currentVote.yesPoint > currentVote.totalPoint / 2);
644         require(currentVote.emergencyAddress != address(0));
645         bool isTransferSuccess = false;
646         (isTransferSuccess, ) = currentVote.emergencyAddress.call.value(address(this).balance)("");
647         if (!isTransferSuccess) revert();
648     }
649 
650     function voteProcess(address investor, bool isYes) internal {
651         require(investors[investor].depositedAmount > 0);
652         require(!investors[investor].isDisabled);
653         require(getNow() - currentVote.startTime < 3 * ONE_DAY);
654         uint8 newVoteValue = isYes ? 2 : 1;
655         uint8 currentVoteValue = currentVote.votes[investor];
656         require(newVoteValue != currentVoteValue);
657         updateVote(isYes);
658         if (currentVoteValue == 0) return;
659         if (isYes) {
660             currentVote.noPoint -= getVoteShare();
661         } else {
662             currentVote.yesPoint -= getVoteShare();
663         }
664     }
665     
666     function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
667     
668     function updateVote(bool isYes) internal {
669         currentVote.votes[msg.sender] = isYes ? 2 : 1;
670         if (isYes) {
671             currentVote.yesPoint += getVoteShare();
672         } else {
673             currentVote.noPoint += getVoteShare();
674         }
675     }
676     
677     function getVoteShare() public view returns(uint256) {
678         if (investors[msg.sender].generation >= 3) return 1;
679         if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
680         return 2;
681     }
682     
683     function setQuerier(address _querierAddress) public mustBeAdmin {
684         querierAddress = _querierAddress;
685     }
686 
687     function setAdmin2(address _admin2) public mustBeAdmin {
688         admin2 = _admin2;
689     }
690 
691     function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
692         paySystemCommissionTimes = _paySystemCommissionTimes;
693         payDailyIncomeTimes = _payDailyIncomeTimes;
694         lastPaySystemCommission = _lastPaySystemCommission;
695         lastPayDailyIncome = _lastPayDailyIncome;
696         contractStartAt = _contractStartAt;
697         lastReset = _lastReset;
698     }
699 }
700 
701 
702 contract Querier {
703     Operator public operator;
704     
705     function setOperator(address payable operatorAddress) public {
706         operator = Operator(operatorAddress);
707     }
708     
709     function getContractInfo() public view returns (address admin, uint256 depositedAmountGross, uint256 investorsCount, address operationFund, uint256 balance, uint256 paySystemCommissionTimes, uint256 maximumMaxOutInWeek) {
710         depositedAmountGross = operator.depositedAmountGross();
711         admin = operator.admin();
712         operationFund = operator.operationFund();
713         balance = address(operator).balance;
714         paySystemCommissionTimes = operator.paySystemCommissionTimes();
715         maximumMaxOutInWeek = operator.maximumMaxOutInWeek();
716         return (admin, depositedAmountGross, operator.getInvestorLength(), operationFund, balance, paySystemCommissionTimes, maximumMaxOutInWeek);
717     }
718 
719     function getContractTime() public view returns (uint256 contractStartAt, uint256 lastReset, uint256 oneDay, uint256 lastPayDailyIncome, uint256 lastPaySystemCommission) {
720         return (operator.contractStartAt(), operator.lastReset(), operator.ONE_DAY(), operator.lastPayDailyIncome(), operator.lastPaySystemCommission());
721     }
722     
723     function getMaxOuts() public view returns (bytes32[] memory ids, address[] memory investors, uint256[] memory times, uint256[] memory ats) {
724         uint256 length = operator.getMaxOutsLength();
725         ids = new bytes32[] (length);
726         investors = new address[] (length);
727         times = new uint256[] (length);
728         ats = new uint256[] (length);
729         for (uint256 i = 0; i < length; i++) {
730             bytes32 id = operator.maxOutIds(i);
731             address investor;
732             uint256 time;
733             uint256 at;
734             (id, investor, time, at) = operator.maxOuts(id);
735             ids[i] = id;
736             times[i] = time;
737             investors[i] = investor;
738             ats[i] = at;
739         }
740         return (ids, investors, times, ats);
741     }
742 
743     function getInvestmentById(bytes32 investmentId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address nextInvestor, bool nextBranch) {
744         return operator.investments(investmentId);
745     }
746     
747     function getWithdrawalById(bytes32 withdrawalId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address presentee, uint256 reason, uint256 times) {
748         return operator.withdrawals(withdrawalId);
749     }
750     
751     function getInvestorsByIndex(uint256 from, uint256 to) public view returns (address[] memory investors, address[] memory addresses, bool[] memory isDisableds, uint256[] memory numbers) {
752         uint256 length = operator.getInvestorLength();
753         from = from < 0 ? 0 : from;
754         to = to > length - 1 ? length - 1 : to; 
755         uint256 baseArrayLength = to - from + 1;
756         addresses = new address[](baseArrayLength * 5);
757         isDisableds = new bool[](baseArrayLength);
758         numbers = new uint256[](baseArrayLength * 16);
759         investors = new address[](baseArrayLength);
760         for (uint256 i = 0; i < baseArrayLength; i++) {
761             address investorAddress = operator.investorAddresses(i + from);
762             address[] memory oneAddresses;
763             uint256[] memory oneNumbers;
764             bool isDisabled;
765             (oneAddresses, isDisabled, oneNumbers) = operator.getInvestor(investorAddress);
766             for (uint256 a = 0; a < oneAddresses.length; a++) {
767                 addresses[i * 5 + a] = oneAddresses[a];
768             }
769             addresses[i * 5 + 4] = investorAddress;
770             for (uint256 b = 0; b < oneNumbers.length; b++) {
771                 numbers[i * 16 + b] = oneNumbers[b];
772             }
773             isDisableds[i] = isDisabled;
774             investors[i] = investorAddress;
775         }
776         return (investors, addresses, isDisableds, numbers);
777     }
778 
779     function getInvestmentsByIndex(uint256 from, uint256 to) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors, address[] memory nextInvestors) {
780         uint256 length = operator.getInvestmentsLength();
781         from = from < 0 ? 0 : from;
782         to = to > length - 1 ? length - 1 : to; 
783         uint256 arrayLength = to - from + 1;
784         ids = new bytes32[](arrayLength);
785         ats = new uint256[](arrayLength);
786         amounts = new uint256[](arrayLength);
787         investors = new address[](arrayLength);
788         nextInvestors = new address[](arrayLength);
789         for (uint256 i = 0; i < arrayLength; i++) {
790             bytes32 id = operator.investmentIds(i + from);
791             uint256 at;
792             uint256 amount;
793             address investor;
794             address nextInvestor;
795             (id, at, amount, investor, nextInvestor,) = getInvestmentById(id);
796             ids[i] = id;
797             ats[i] = at;
798             amounts[i] = amount;
799             investors[i] = investor;
800             nextInvestors[i] = nextInvestor;
801         }
802         return (ids, ats, amounts, investors, nextInvestors);
803     }
804 
805     function getWithdrawalsByIndex(uint256 from, uint256 to) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) {
806         uint256 length = operator.getWithdrawalsLength();
807         from = from < 0 ? 0 : from;
808         to = to > length - 1 ? length - 1 : to; 
809         uint256 arrayLength = to - from + 1;
810         ids = new bytes32[](arrayLength);
811         ats = new uint256[](arrayLength);
812         amounts = new uint256[](arrayLength);
813         investors = new address[](arrayLength);
814         presentees = new address[](arrayLength);
815         reasons = new uint256[](arrayLength);
816         times = new uint256[](arrayLength);
817         putWithdrawalsPart1(from, arrayLength, ids, ats, amounts, investors);
818         putWithdrawalsPart2(from, arrayLength, presentees, reasons, times);
819         return (ids, ats, amounts, investors, presentees, reasons, times);
820     }
821 
822     function putWithdrawalsPart1(uint256 from, uint256 length, bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors) internal view {
823         for (uint256 i = 0; i < length; i++) {
824             bytes32 id = operator.withdrawalIds(i + from);
825             uint256 at;
826             uint256 amount;
827             address investor;
828             (id, at, amount, investor, , , ) = getWithdrawalById(id);
829             ids[i] = id;
830             ats[i] = at;
831             amounts[i] = amount;
832             investors[i] = investor;
833         }
834     }
835     
836     function putWithdrawalsPart2(uint256 from, uint256 length, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) internal view {
837         for (uint256 i = 0; i < length; i++) {
838             bytes32 id = operator.withdrawalIds(i + from);
839             uint256 reason;
840             uint256 time;
841             address presentee;
842             uint256 at;
843             (, at, , , presentee, reason, time) = getWithdrawalById(id);
844             reasons[i] = reason;
845             times[i] = time;
846             presentees[i] = presentee;
847         }
848     }
849 
850     function getCurrentVote() public view returns(uint256 startTime, string memory reason, address payable emergencyAddress, uint256 yesPoint, uint256 noPoint, uint256 totalPoint) {
851         (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint) = operator.currentVote();
852         return (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint);
853     }
854     
855     function importMoreInvestors(address[] memory addresses, bool[] memory isDisableds, uint256[] memory numbers) public {
856         for (uint256 index = 0; index < isDisableds.length; index++) {
857             address[] memory adds = splitAddresses(addresses, index * 5, index * 5 + 4);
858             uint256[] memory nums = splitNumbers(numbers, index * 13, index * 13 + 12);
859             operator.importInvestor(adds, isDisableds[index], nums);
860         }
861     }
862 
863     function importMoreInvestments(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investorAddresses) public {
864         for (uint256 index = 0; index < ids.length; index++) {
865             operator.importInvestments(ids[index], ats[index], amounts[index], investorAddresses[index]);
866         }
867     }
868 
869     function importMoreWithdrawals(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investorAddresses, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) public {
870         for (uint256 index = 0; index < ids.length; index++) {
871             operator.importWithdrawals(ids[index], ats[index], amounts[index], investorAddresses[index], presentees[index], reasons[index], times[index]);
872         }
873     }
874 
875     function splitAddresses(address[] memory addresses, uint256 from, uint256 to) internal pure returns(address[] memory output) {
876         output = new address[](to - from + 1);
877         for (uint256 i = from; i <= to; i++) {
878             output[i - from] = addresses[i];
879         }
880         return output;
881     }
882 
883     function splitNumbers(uint256[] memory numbers, uint256 from, uint256 to) internal pure returns(uint256[] memory output) {
884         output = new uint256[](to - from + 1);
885         for (uint256 i = from; i <= to; i++) {
886             output[i - from] = numbers[i];
887         }
888         return output;
889     }
890 }