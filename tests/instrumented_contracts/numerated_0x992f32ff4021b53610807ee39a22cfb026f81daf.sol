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
17     address payable public operationFund = 0xa4048772583220896ec93316616778B4EbC70F9d;
18     address[] public investorAddresses;
19     bytes32[] public investmentIds;
20     bytes32[] public withdrawalIds;
21     bytes32[] public maxOutIds;
22     mapping (address => Investor) investors;
23     mapping (bytes32 => Investment) public investments;
24     mapping (bytes32 => Withdrawal) public withdrawals;
25     mapping (bytes32 => MaxOut) public maxOuts;
26     mapping (address => WithdrawAccount) public withdrawAccounts;
27     uint256 additionNow = 0;
28 
29     uint256 public maxLevelsAddSale = 200;
30     uint256 public maximumMaxOutInWeek = 2;
31     bool public importing = true;
32 
33     Vote public currentVote;
34 
35     struct WithdrawAccount {
36         address initialAddress;
37         address currentWithdrawalAddress;
38         address requestingWithdrawalAddress;
39     }
40 
41     struct Vote {
42         uint256 startTime;
43         string reason;
44         mapping (address => uint8) votes;
45         address payable emergencyAddress;
46         uint256 yesPoint;
47         uint256 noPoint;
48         uint256 totalPoint;
49     }
50 
51     struct Investment {
52         bytes32 id;
53         uint256 at;
54         uint256 amount;
55         address investor;
56         address nextInvestor;
57         bool nextBranch;
58     }
59 
60     struct Withdrawal {
61         bytes32 id;
62         uint256 at;
63         uint256 amount;
64         address investor;
65         address presentee;
66         uint256 reason;
67         uint256 times;
68     }
69 
70     struct Investor {
71         address parent;
72         address leftChild;
73         address rightChild;
74         address presenter;
75         uint256 generation;
76         uint256 depositedAmount;
77         uint256 withdrewAmount;
78         bool isDisabled;
79         uint256 lastMaxOut;
80         uint256 maxOutTimes;
81         uint256 maxOutTimesInWeek;
82         uint256 totalSell;
83         uint256 sellThisMonth;
84         uint256 rightSell;
85         uint256 leftSell;
86         uint256 reserveCommission;
87         uint256 dailyIncomeWithrewAmount;
88         uint256 registerTime;
89         uint256 minDeposit;
90         bytes32[] investments;
91         bytes32[] withdrawals;
92     }
93 
94     struct MaxOut {
95         bytes32 id;
96         address investor;
97         uint256 times;
98         uint256 at;
99     }
100 
101     constructor () public { admin = msg.sender; }
102     
103     modifier mustBeAdmin() {
104         require(msg.sender == admin || msg.sender == querierAddress || msg.sender == admin2);
105         _;
106     }
107 
108     modifier mustBeImporting() { require(importing); require(msg.sender == querierAddress || msg.sender == admin); _; }
109     
110     function () payable external { deposit(); }
111 
112     function getNow() internal view returns(uint256) {
113         return additionNow + now;
114     }
115 
116     function depositProcess(address sender) internal {
117         Investor storage investor = investors[sender];
118         require(investor.generation != 0);
119         if (investor.depositedAmount == 0) require(msg.value >= investor.minDeposit);
120         require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
121         require(investor.maxOutTimes < 50);
122         require(investor.maxOutTimes == 0 || getNow() - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
123         depositedAmountGross += msg.value;
124         bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), sender, msg.value));
125         uint256 investmentValue = investor.depositedAmount + msg.value <= MAX_DEP ? msg.value : MAX_DEP - investor.depositedAmount;
126         if (investmentValue == 0) return;
127         bool nextBranch = investors[investor.parent].leftChild == sender; 
128         Investment memory investment = Investment({ id: id, at: getNow(), amount: investmentValue, investor: sender, nextInvestor: investor.parent, nextBranch: nextBranch  });
129         investments[id] = investment;
130         processInvestments(id);
131         investmentIds.push(id);
132     }
133 
134     function pushNewMaxOut(address investorAddress, uint256 times, uint256 depositedAmount) internal {
135         bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), investorAddress, times));
136         MaxOut memory maxOut = MaxOut({ id: id, at: getNow(), investor: investorAddress, times: times });
137         maxOutIds.push(id);
138         maxOuts[id] = maxOut;
139         investors[investorAddress].minDeposit = depositedAmount;
140     }
141     
142     function deposit() payable public { depositProcess(msg.sender); }
143     
144     function processInvestments(bytes32 investmentId) internal {
145         Investment storage investment = investments[investmentId];
146         uint256 amount = investment.amount;
147         Investor storage investor = investors[investment.investor];
148         investor.investments.push(investmentId);
149         investor.depositedAmount += amount;
150         address payable presenterAddress = address(uint160(investor.presenter));
151         Investor storage presenter = investors[presenterAddress];
152         if (presenterAddress != address(0)) {
153             presenter.totalSell += amount;
154             presenter.sellThisMonth += amount;
155         }
156         if (presenter.depositedAmount >= MIN_DEP && !presenter.isDisabled) {
157             sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
158         }
159     }
160 
161     function getWithdrawAddress(address payable initialAddress) public view returns (address payable) {
162         WithdrawAccount memory withdrawAccount = withdrawAccounts[initialAddress];
163         address withdrawAddress = withdrawAccount.currentWithdrawalAddress;
164         if (withdrawAddress != address(0)) return address(uint160(withdrawAddress));
165         return initialAddress;
166     }
167 
168     function requestChangeWithdrawAddress(address newAddress) public {
169         require(investors[msg.sender].depositedAmount > 0);
170         WithdrawAccount storage currentWithdrawAccount = withdrawAccounts[msg.sender];
171         if (currentWithdrawAccount.initialAddress != address(0)) {
172             currentWithdrawAccount.requestingWithdrawalAddress = newAddress;
173             return;
174         }
175         WithdrawAccount memory withdrawAccount = WithdrawAccount({
176             initialAddress: msg.sender,
177             currentWithdrawalAddress: msg.sender,
178             requestingWithdrawalAddress: newAddress
179         });
180         withdrawAccounts[msg.sender] = withdrawAccount;
181     }
182 
183     function acceptChangeWithdrawAddress(address initialAddress, address requestingWithdrawalAddress) public mustBeAdmin {
184         WithdrawAccount storage withdrawAccount = withdrawAccounts[initialAddress];
185         require(withdrawAccount.requestingWithdrawalAddress == requestingWithdrawalAddress);
186         withdrawAccount.requestingWithdrawalAddress = address(0);
187         withdrawAccount.currentWithdrawalAddress = requestingWithdrawalAddress;
188     }
189 
190     function addSellForParents(bytes32 investmentId) public mustBeAdmin {
191         Investment storage investment = investments[investmentId];
192         require(investment.nextInvestor != address(0));
193         uint256 amount = investment.amount;
194         uint256 loopCount = 0;
195         while (investment.nextInvestor != address(0) && loopCount < maxLevelsAddSale) {
196             Investor storage investor = investors[investment.nextInvestor];
197             if (investment.nextBranch) investor.leftSell += amount;
198             else investor.rightSell += amount;
199             investment.nextBranch = investors[investor.parent].leftChild == investment.nextInvestor;
200             investment.nextInvestor = investor.parent;
201             loopCount++;
202         }
203     }
204 
205     function sendEtherForInvestor(address payable investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
206         if (value == 0 && reason != 100) return;
207         if (investorAddress == address(0)) return;
208         Investor storage investor = investors[investorAddress];
209         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
210         uint256 totalPaidAfterThisTime = investor.reserveCommission + getDailyIncomeForUser(investorAddress) + unpaidSystemCommission;
211         if (reason == 1) totalPaidAfterThisTime += value;
212         if (totalPaidAfterThisTime + investor.withdrewAmount >= 3 * investor.depositedAmount) {
213             payWithMaxOut(totalPaidAfterThisTime, investorAddress, unpaidSystemCommission);
214             return;
215         }
216         if (investor.reserveCommission > 0) payWithNoMaxOut(investor.reserveCommission, investorAddress, 4, address(0), 0);
217         payWithNoMaxOut(value, investorAddress, reason, presentee, times);
218     }
219     
220     function payWithNoMaxOut(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
221         investors[investorAddress].withdrewAmount += amountToPay;
222         if (reason == 4) investors[investorAddress].reserveCommission = 0;
223         if (reason == 3) resetSystemCommision(investorAddress, times);
224         if (reason == 2) investors[investorAddress].dailyIncomeWithrewAmount += amountToPay;
225         pay(amountToPay, investorAddress, reason, presentee, times);
226     }
227     
228     function payWithMaxOut(uint256 totalPaidAfterThisTime, address payable investorAddress, uint256 unpaidSystemCommission) internal {
229         Investor storage investor = investors[investorAddress];
230         uint256 amountToPay = investor.depositedAmount * 3 - investor.withdrewAmount;
231         uint256 amountToReserve = totalPaidAfterThisTime - amountToPay;
232         if (unpaidSystemCommission > 0) resetSystemCommision(investorAddress, 0);
233         investor.maxOutTimes++;
234         investor.maxOutTimesInWeek++;
235         uint256 oldDepositedAmount = investor.depositedAmount;
236         investor.depositedAmount = 0;
237         investor.withdrewAmount = 0;
238         investor.lastMaxOut = getNow();
239         investor.dailyIncomeWithrewAmount = 0;
240         investor.reserveCommission = amountToReserve;
241         pushNewMaxOut(investorAddress, investor.maxOutTimes, oldDepositedAmount);
242         pay(amountToPay, investorAddress, 0, address(0), 0);
243     }
244 
245     function pay(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
246         if (amountToPay == 0) return;
247         address payable withdrawAddress = getWithdrawAddress(investorAddress);
248         withdrawAddress.transfer(amountToPay / 100 * 90);
249         operationFund.transfer(amountToPay / 100 * 10);
250         bytes32 id = keccak256(abi.encodePacked(block.difficulty, getNow(), investorAddress, amountToPay, reason));
251         Withdrawal memory withdrawal = Withdrawal({ id: id, at: getNow(), amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
252         withdrawals[id] = withdrawal;
253         investors[investorAddress].withdrawals.push(id);
254         withdrawalIds.push(id);
255     }
256 
257     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
258         Investor memory investor = investors[investorAddress];
259         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
260         uint256 withdrewAmount = investor.withdrewAmount;
261         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
262         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
263         return allIncomeNow;
264     }
265 
266     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, bool isLeft) public mustBeAdmin {
267         Investor storage presenter = investors[presenterAddress];
268         Investor storage parent = investors[parentAddress];
269         if (investorAddresses.length != 0) {
270             require(presenter.generation != 0);
271             require(parent.generation != 0);
272             if (isLeft) {
273                 require(parent.leftChild == address(0)); 
274             } else {
275                 require(parent.rightChild == address(0)); 
276             }
277         }
278         Investor memory investor = Investor({
279             parent: parentAddress,
280             leftChild: address(0),
281             rightChild: address(0),
282             presenter: presenterAddress,
283             generation: parent.generation + 1,
284             depositedAmount: 0,
285             withdrewAmount: 0,
286             isDisabled: false,
287             lastMaxOut: getNow(),
288             maxOutTimes: 0,
289             maxOutTimesInWeek: 0,
290             totalSell: 0,
291             sellThisMonth: 0,
292             registerTime: getNow(),
293             investments: new bytes32[](0),
294             withdrawals: new bytes32[](0),
295             minDeposit: MIN_DEP,
296             rightSell: 0,
297             leftSell: 0,
298             reserveCommission: 0,
299             dailyIncomeWithrewAmount: 0
300         });
301         investors[presenteeAddress] = investor;
302        
303         investorAddresses.push(presenteeAddress);
304         if (parent.generation == 0) return;
305         if (isLeft) {
306             parent.leftChild = presenteeAddress;
307         } else {
308             parent.rightChild = presenteeAddress;
309         }
310     }
311 
312     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
313         Investor memory investor = investors[investorAddress];
314         uint256 investmentLength = investor.investments.length;
315         uint256 dailyIncome = 0;
316         for (uint256 i = 0; i < investmentLength; i++) {
317             Investment memory investment = investments[investor.investments[i]];
318             if (investment.at < investor.lastMaxOut) continue; 
319             if (getNow() - investment.at >= ONE_DAY) {
320                 uint256 numberOfDay = (getNow() - investment.at) / ONE_DAY;
321                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
322                 dailyIncome = totalDailyIncome + dailyIncome;
323             }
324         }
325         return dailyIncome - investor.dailyIncomeWithrewAmount;
326     }
327     
328     function payDailyIncomeForInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
329         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
330         Investor storage investor = investors[investorAddress];
331         if (times > ONE_DAY) {
332             uint256 investmentLength = investor.investments.length;
333             bytes32 lastInvestmentId = investor.investments[investmentLength - 1];
334             investments[lastInvestmentId].at -= times;
335             investors[investorAddress].lastMaxOut = investments[lastInvestmentId].at;
336             return;
337         }
338         if (investor.isDisabled) return;
339         sendEtherForInvestor(investorAddress, dailyIncome, 2, address(0), times);
340     }
341     
342     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
343         require(from >= 0 && to < investorAddresses.length);
344         for(uint256 i = from; i <= to; i++) {
345             payDailyIncomeForInvestor(address(uint160(investorAddresses[i])), payDailyIncomeTimes);
346         }
347     }
348 
349     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
350         Investor memory investor = investors[investorAddress];
351         uint256 depositedAmount = investor.depositedAmount;
352         uint256 totalSell = investor.totalSell;
353         uint256 leftSell = investor.leftSell;
354         uint256 rightSell = investor.rightSell;
355         uint256 sellThisMonth = investor.sellThisMonth;
356         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
357         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
358         return commission;
359     }
360     
361     function paySystemCommissionInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
362         Investor storage investor = investors[investorAddress];
363         if (investor.isDisabled) return;
364         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
365         sendEtherForInvestor(investorAddress, systemCommission, 3, address(0), times);
366     }
367 
368     function resetSystemCommision(address investorAddress, uint256 times) internal {
369         Investor storage investor = investors[investorAddress];
370         if (paySystemCommissionTimes > 3 && times != 0) {
371             investor.rightSell = 0;
372             investor.leftSell = 0;
373         } else if (investor.rightSell >= investor.leftSell) {
374             investor.rightSell = investor.rightSell - investor.leftSell;
375             investor.leftSell = 0;
376         } else {
377             investor.leftSell = investor.leftSell - investor.rightSell;
378             investor.rightSell = 0;
379         }
380         if (times != 0) investor.sellThisMonth = 0;
381     }
382 
383     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
384          require(from >= 0 && to < investorAddresses.length);
385         if (getNow() <= 30 * ONE_DAY + contractStartAt) return;
386         for(uint256 i = from; i <= to; i++) {
387             paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
388         }
389     }
390     
391     function finishPayDailyIncome() public mustBeAdmin {
392         lastPayDailyIncome = getNow();
393         payDailyIncomeTimes++;
394     }
395     
396     function finishPaySystemCommission() public mustBeAdmin {
397         lastPaySystemCommission = getNow();
398         paySystemCommissionTimes++;
399     }
400     
401     function resetGame(uint256 from, uint256 to) public mustBeAdmin {
402         require(from >= 0 && to < investorAddresses.length);
403         require(currentVote.startTime != 0);
404         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
405         require(currentVote.yesPoint > currentVote.totalPoint / 2);
406         require(currentVote.emergencyAddress == address(0));
407         lastReset = getNow();
408         for (uint256 i = from; i < to; i++) {
409             address investorAddress = investorAddresses[i];
410             Investor storage investor = investors[investorAddress];
411             uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : 2;
412             if (currentVoteValue == 2) {
413                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
414                     investor.lastMaxOut = getNow();
415                     investor.depositedAmount = 0;
416                     investor.withdrewAmount = 0;
417                     investor.dailyIncomeWithrewAmount = 0;
418                 }
419                 investor.reserveCommission = 0;
420                 investor.rightSell = 0;
421                 investor.leftSell = 0;
422                 investor.totalSell = 0;
423                 investor.sellThisMonth = 0;
424             } else {
425                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
426                     investor.isDisabled = true;
427                     investor.reserveCommission = 0;
428                     investor.lastMaxOut = getNow();
429                     investor.depositedAmount = 0;
430                     investor.withdrewAmount = 0;
431                     investor.dailyIncomeWithrewAmount = 0;
432                 }
433                 investor.reserveCommission = 0;
434                 investor.rightSell = 0;
435                 investor.leftSell = 0;
436                 investor.totalSell = 0;
437                 investor.sellThisMonth = 0;
438             }
439             
440         }
441     }
442 
443     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
444         require(currentVote.startTime != 0);
445         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
446         require(currentVote.noPoint > currentVote.totalPoint / 2);
447         require(currentVote.emergencyAddress == address(0));
448         require(percent <= 50);
449         require(from >= 0 && to < investorAddresses.length);
450         for (uint256 i = from; i <= to; i++) {
451             address payable investorAddress = address(uint160(investorAddresses[i]));
452             Investor storage investor = investors[investorAddress];
453             if (investor.maxOutTimes > 0) continue;
454             if (investor.isDisabled) continue;
455             uint256 depositedAmount = investor.depositedAmount;
456             uint256 withdrewAmount = investor.withdrewAmount;
457             if (withdrewAmount >= depositedAmount / 2) continue;
458             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
459         }
460     }
461     
462     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = getNow(); }
463 
464     function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
465         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
466         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
467         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
468         uint256 depositedAmount = investors[investorAddress].depositedAmount;
469         uint256 reserveCommission = investors[investorAddress].reserveCommission;
470         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
471         sendEtherForInvestor(investorAddress, 0, 100, address(0), 0);
472     }
473 
474     function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
475         require(from >= 0 && to < investorAddresses.length);
476         for (uint256 i = from; i < to; i++) {
477             address investorAddress = investorAddresses[i];
478             if (investors[investorAddress].maxOutTimesInWeek == 0) continue;
479             investors[investorAddress].maxOutTimesInWeek = 0;
480         }
481     }
482 
483     function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }
484 
485     function disableInvestor(address investorAddress) public mustBeAdmin {
486         Investor storage investor = investors[investorAddress];
487         investor.isDisabled = true;
488     }
489     
490     function enableInvestor(address investorAddress) public mustBeAdmin {
491         Investor storage investor = investors[investorAddress];
492         investor.isDisabled = false;
493     }
494     
495     function donate() payable public { depositedAmountGross += msg.value; }
496 
497     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
498         if (totalSell < 30 ether) return 0;
499         if (totalSell < 60 ether) return 1;
500         if (totalSell < 90 ether) return 2;
501         if (totalSell < 120 ether) return 3;
502         if (totalSell < 150 ether) return 4;
503         return 5;
504     }
505 
506     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
507         if (sellThisMonth < 2 ether) return 0;
508         if (sellThisMonth < 4 ether) return 1;
509         if (sellThisMonth < 6 ether) return 2;
510         if (sellThisMonth < 8 ether) return 3;
511         if (sellThisMonth < 10 ether) return 4;
512         return 5;
513     }
514     
515     function getDepositLevel(uint256 depositedAmount) internal pure returns (uint256 level){
516         if (depositedAmount < 2 ether) return 0;
517         if (depositedAmount < 4 ether) return 1;
518         if (depositedAmount < 6 ether) return 2;
519         if (depositedAmount < 8 ether) return 3;
520         if (depositedAmount < 10 ether) return 4;
521         return 5;
522     }
523     
524     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
525         uint256 totalSellLevel = getTotalSellLevel(totalSell);
526         uint256 depLevel = getDepositLevel(depositedAmount);
527         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
528         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
529         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
530         return minLevel * 2;
531     }
532     
533     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
534         bytes memory tempEmptyStringTest = bytes(source);
535         if (tempEmptyStringTest.length == 0) return 0x0;
536         assembly { result := mload(add(source, 32)) }
537     }
538     
539     function getInvestor(address investorAddress) view public returns (address[] memory addresses, bool isDisabled, uint256[] memory numbers) {
540         addresses = new address[](4);
541         numbers = new uint256[](16);
542         Investor memory investor = investors[investorAddress];
543         addresses[0] = investor.parent;
544         addresses[1] = investor.leftChild;
545         addresses[2] = investor.rightChild;
546         addresses[3] = investor.presenter;
547         numbers[0] = investor.generation;
548         numbers[1] = investor.depositedAmount;
549         numbers[2] = investor.withdrewAmount;
550         numbers[3] = investor.lastMaxOut;
551         numbers[4] = investor.maxOutTimes;
552         numbers[5] = investor.maxOutTimesInWeek;
553         numbers[6] = investor.totalSell;
554         numbers[7] = investor.sellThisMonth;
555         numbers[8] = investor.rightSell;
556         numbers[9] = investor.leftSell;
557         numbers[10] = investor.reserveCommission;
558         numbers[11] = investor.dailyIncomeWithrewAmount;
559         numbers[12] = investor.registerTime;
560         numbers[13] = getUnpaidSystemCommission(investorAddress);
561         numbers[14] = getDailyIncomeForUser(investorAddress);
562         numbers[15] = investor.minDeposit;
563         return (addresses, investor.isDisabled, numbers);
564     }
565 
566     function getInvestorLength() view public returns(uint256) { return investorAddresses.length; }
567 
568     function getMaxOutsLength() view public returns(uint256) { return maxOutIds.length; }
569     
570     function getNodesAddresses(address rootNodeAddress) public view returns(address[] memory){
571         uint256 maxLength = investorAddresses.length;
572         address[] memory nodes = new address[](maxLength);
573         nodes[0] = rootNodeAddress;
574         uint256 processIndex = 0;
575         uint256 nextIndex = 1;
576         while (processIndex != nextIndex) {
577             Investor memory currentInvestor = investors[nodes[processIndex++]];
578             if (currentInvestor.leftChild != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;
579             if (currentInvestor.rightChild != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;
580         }
581         return nodes;
582     }
583     
584     function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
585     
586     function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
587     
588     function importInvestor(address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
589         if (investors[addresses[4]].generation != 0) return;
590         Investor memory investor = Investor({
591             isDisabled: isDisabled,
592             parent: addresses[0],
593             leftChild: addresses[1],
594             rightChild: addresses[2],
595             presenter: addresses[3],
596             generation: numbers[0],
597             depositedAmount: numbers[1],
598             withdrewAmount: numbers[2],
599             lastMaxOut: numbers[3],
600             maxOutTimes: numbers[4],
601             maxOutTimesInWeek: numbers[5],
602             totalSell: numbers[6],
603             sellThisMonth: numbers[7],
604             investments: new bytes32[](0),
605             withdrawals: new bytes32[](0),
606             rightSell: numbers[8],
607             leftSell: numbers[9],
608             reserveCommission: numbers[10],
609             dailyIncomeWithrewAmount: numbers[11],
610             registerTime: numbers[12],
611             minDeposit: MIN_DEP
612         });
613         investors[addresses[4]] = investor;
614         investorAddresses.push(addresses[4]);
615     }
616     
617     function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
618         if (investments[id].at != 0) return;
619         Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
620         investments[id] = investment;
621         investmentIds.push(id);
622         Investor storage investor = investors[investorAddress];
623         investor.investments.push(id);
624         depositedAmountGross += amount;
625     }
626     
627     function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
628         if (withdrawals[id].at != 0) return;
629         Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
630         withdrawals[id] = withdrawal;
631         Investor storage investor = investors[investorAddress];
632         investor.withdrawals.push(id);
633         withdrawalIds.push(id);
634     }
635     
636     function finishImporting() public mustBeAdmin { importing = false; }
637 
638     function finalizeVotes(uint256 from, uint256 to, bool isRemoving) public mustBeAdmin {
639         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
640         for (uint256 index = from; index < to; index++) {
641             address investorAddress = investorAddresses[index];
642             if (isRemoving && currentVote.votes[investorAddress] == 3) {
643                 currentVote.votes[investorAddress] = 0;
644                 continue;
645             }
646             if (currentVote.votes[investorAddress] == 0) {
647                 currentVote.yesPoint += 1;
648             }
649             currentVote.votes[investorAddress] = 3;
650         }
651     }
652 
653     function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
654         require(currentVote.startTime == 0);
655         currentVote = Vote({
656             startTime: getNow(),
657             reason: reason,
658             emergencyAddress: emergencyAddress,
659             yesPoint: 0,
660             noPoint: 0,
661             totalPoint: investorAddresses.length
662         });
663     }
664 
665     function removeVote() public mustBeAdmin {
666         currentVote = Vote({
667             startTime: 0,
668             reason: '',
669             emergencyAddress: address(0),
670             yesPoint: 0,
671             noPoint: 0,
672             totalPoint: 0
673         });
674     }
675     
676     function sendEtherToNewContract() public mustBeAdmin {
677         require(currentVote.startTime != 0);
678         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
679         require(currentVote.yesPoint > currentVote.totalPoint / 2);
680         require(currentVote.emergencyAddress != address(0));
681         bool isTransferSuccess = false;
682         (isTransferSuccess, ) = currentVote.emergencyAddress.call.value(address(this).balance)("");
683         if (!isTransferSuccess) revert();
684     }
685 
686     function voteProcess(address investor, bool isYes) internal {
687         require(investors[investor].depositedAmount > 0);
688         require(!investors[investor].isDisabled);
689         require(getNow() - currentVote.startTime < 3 * ONE_DAY);
690         uint8 newVoteValue = isYes ? 2 : 1;
691         uint8 currentVoteValue = currentVote.votes[investor];
692         require(newVoteValue != currentVoteValue);
693         updateVote(isYes);
694         if (currentVoteValue == 0) return;
695         if (isYes) {
696             currentVote.noPoint -= getVoteShare();
697         } else {
698             currentVote.yesPoint -= getVoteShare();
699         }
700     }
701     
702     function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
703     
704     function updateVote(bool isYes) internal {
705         currentVote.votes[msg.sender] = isYes ? 2 : 1;
706         if (isYes) {
707             currentVote.yesPoint += getVoteShare();
708         } else {
709             currentVote.noPoint += getVoteShare();
710         }
711     }
712     
713     function getVoteShare() public view returns(uint256) {
714         if (investors[msg.sender].generation >= 3) return 1;
715         if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
716         return 2;
717     }
718     
719     function setQuerier(address _querierAddress) public mustBeAdmin {
720         querierAddress = _querierAddress;
721     }
722 
723     function setAdmin2(address _admin2) public mustBeAdmin {
724         admin2 = _admin2;
725     }
726 
727     function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
728         paySystemCommissionTimes = _paySystemCommissionTimes;
729         payDailyIncomeTimes = _payDailyIncomeTimes;
730         lastPaySystemCommission = _lastPaySystemCommission;
731         lastPayDailyIncome = _lastPayDailyIncome;
732         contractStartAt = _contractStartAt;
733         lastReset = _lastReset;
734     }
735 
736     function depositFor(address investor) public payable mustBeAdmin {
737         depositProcess(investor);
738     }
739 
740     function setInvestorTestInfo(address investorAddress, uint256 totalSell, uint256 sellThisMonth, uint256 rightSell, uint256 leftSell) public mustBeAdmin {
741         Investor storage investor = investors[investorAddress];
742         require(investor.generation > 0);
743         investor.totalSell = totalSell;
744         investor.sellThisMonth = sellThisMonth;
745         investor.rightSell = rightSell;
746         investor.leftSell = leftSell;
747     }
748 }
749 contract Querier {
750     Operator public operator;
751     
752     function setOperator(address payable operatorAddress) public {
753         operator = Operator(operatorAddress);
754     }
755     
756     function getContractInfo() public view returns (address admin, uint256 depositedAmountGross, uint256 investorsCount, address operationFund, uint256 balance, uint256 paySystemCommissionTimes, uint256 maximumMaxOutInWeek) {
757         depositedAmountGross = operator.depositedAmountGross();
758         admin = operator.admin();
759         operationFund = operator.operationFund();
760         balance = address(operator).balance;
761         paySystemCommissionTimes = operator.paySystemCommissionTimes();
762         maximumMaxOutInWeek = operator.maximumMaxOutInWeek();
763         return (admin, depositedAmountGross, operator.getInvestorLength(), operationFund, balance, paySystemCommissionTimes, maximumMaxOutInWeek);
764     }
765 
766     function getContractTime() public view returns (uint256 contractStartAt, uint256 lastReset, uint256 oneDay, uint256 lastPayDailyIncome, uint256 lastPaySystemCommission) {
767         return (operator.contractStartAt(), operator.lastReset(), operator.ONE_DAY(), operator.lastPayDailyIncome(), operator.lastPaySystemCommission());
768     }
769     
770     function getMaxOuts() public view returns (bytes32[] memory ids, address[] memory investors, uint256[] memory times, uint256[] memory ats) {
771         uint256 length = operator.getMaxOutsLength();
772         ids = new bytes32[] (length);
773         investors = new address[] (length);
774         times = new uint256[] (length);
775         ats = new uint256[] (length);
776         for (uint256 i = 0; i < length; i++) {
777             bytes32 id = operator.maxOutIds(i);
778             address investor;
779             uint256 time;
780             uint256 at;
781             (id, investor, time, at) = operator.maxOuts(id);
782             ids[i] = id;
783             times[i] = time;
784             investors[i] = investor;
785             ats[i] = at;
786         }
787         return (ids, investors, times, ats);
788     }
789 
790     function getInvestmentById(bytes32 investmentId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address nextInvestor, bool nextBranch) {
791         return operator.investments(investmentId);
792     }
793     
794     function getWithdrawalById(bytes32 withdrawalId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address presentee, uint256 reason, uint256 times) {
795         return operator.withdrawals(withdrawalId);
796     }
797     
798     function getInvestorsByIndex(uint256 from, uint256 to) public view returns (address[] memory investors, address[] memory addresses, bool[] memory isDisableds, uint256[] memory numbers) {
799         uint256 length = operator.getInvestorLength();
800         from = from < 0 ? 0 : from;
801         to = to > length - 1 ? length - 1 : to; 
802         uint256 baseArrayLength = to - from + 1;
803         addresses = new address[](baseArrayLength * 5);
804         isDisableds = new bool[](baseArrayLength);
805         numbers = new uint256[](baseArrayLength * 16);
806         investors = new address[](baseArrayLength);
807         for (uint256 i = 0; i < baseArrayLength; i++) {
808             address investorAddress = operator.investorAddresses(i + from);
809             address[] memory oneAddresses;
810             uint256[] memory oneNumbers;
811             bool isDisabled;
812             (oneAddresses, isDisabled, oneNumbers) = operator.getInvestor(investorAddress);
813             for (uint256 a = 0; a < oneAddresses.length; a++) {
814                 addresses[i * 5 + a] = oneAddresses[a];
815             }
816             addresses[i * 5 + 4] = investorAddress;
817             for (uint256 b = 0; b < oneNumbers.length; b++) {
818                 numbers[i * 16 + b] = oneNumbers[b];
819             }
820             isDisableds[i] = isDisabled;
821             investors[i] = investorAddress;
822         }
823         return (investors, addresses, isDisableds, numbers);
824     }
825 
826     function getInvestmentsByIndex(uint256 from, uint256 to) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors, address[] memory nextInvestors) {
827         uint256 length = operator.getInvestmentsLength();
828         from = from < 0 ? 0 : from;
829         to = to > length - 1 ? length - 1 : to; 
830         uint256 arrayLength = to - from + 1;
831         ids = new bytes32[](arrayLength);
832         ats = new uint256[](arrayLength);
833         amounts = new uint256[](arrayLength);
834         investors = new address[](arrayLength);
835         nextInvestors = new address[](arrayLength);
836         for (uint256 i = 0; i < arrayLength; i++) {
837             bytes32 id = operator.investmentIds(i + from);
838             uint256 at;
839             uint256 amount;
840             address investor;
841             address nextInvestor;
842             (id, at, amount, investor, nextInvestor,) = getInvestmentById(id);
843             ids[i] = id;
844             ats[i] = at;
845             amounts[i] = amount;
846             investors[i] = investor;
847             nextInvestors[i] = nextInvestor;
848         }
849         return (ids, ats, amounts, investors, nextInvestors);
850     }
851 
852     function getWithdrawalsByIndex(uint256 from, uint256 to) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) {
853         uint256 length = operator.getWithdrawalsLength();
854         from = from < 0 ? 0 : from;
855         to = to > length - 1 ? length - 1 : to; 
856         uint256 arrayLength = to - from + 1;
857         ids = new bytes32[](arrayLength);
858         ats = new uint256[](arrayLength);
859         amounts = new uint256[](arrayLength);
860         investors = new address[](arrayLength);
861         presentees = new address[](arrayLength);
862         reasons = new uint256[](arrayLength);
863         times = new uint256[](arrayLength);
864         putWithdrawalsPart1(from, arrayLength, ids, ats, amounts, investors);
865         putWithdrawalsPart2(from, arrayLength, presentees, reasons, times);
866         return (ids, ats, amounts, investors, presentees, reasons, times);
867     }
868 
869     function putWithdrawalsPart1(uint256 from, uint256 length, bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors) internal view {
870         for (uint256 i = 0; i < length; i++) {
871             bytes32 id = operator.withdrawalIds(i + from);
872             uint256 at;
873             uint256 amount;
874             address investor;
875             (id, at, amount, investor, , , ) = getWithdrawalById(id);
876             ids[i] = id;
877             ats[i] = at;
878             amounts[i] = amount;
879             investors[i] = investor;
880         }
881     }
882     
883     function putWithdrawalsPart2(uint256 from, uint256 length, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) internal view {
884         for (uint256 i = 0; i < length; i++) {
885             bytes32 id = operator.withdrawalIds(i + from);
886             uint256 reason;
887             uint256 time;
888             address presentee;
889             uint256 at;
890             (, at, , , presentee, reason, time) = getWithdrawalById(id);
891             reasons[i] = reason;
892             times[i] = time;
893             presentees[i] = presentee;
894         }
895     }
896 
897     function getCurrentVote() public view returns(uint256 startTime, string memory reason, address payable emergencyAddress, uint256 yesPoint, uint256 noPoint, uint256 totalPoint) {
898         (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint) = operator.currentVote();
899         return (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint);
900     }
901     
902     function importMoreInvestors(address[] memory addresses, bool[] memory isDisableds, uint256[] memory numbers) public {
903         for (uint256 index = 0; index < isDisableds.length; index++) {
904             address[] memory adds = splitAddresses(addresses, index * 5, index * 5 + 4);
905             uint256[] memory nums = splitNumbers(numbers, index * 13, index * 13 + 12);
906             operator.importInvestor(adds, isDisableds[index], nums);
907         }
908     }
909 
910     function importMoreInvestments(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investorAddresses) public {
911         for (uint256 index = 0; index < ids.length; index++) {
912             operator.importInvestments(ids[index], ats[index], amounts[index], investorAddresses[index]);
913         }
914     }
915 
916     function importMoreWithdrawals(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investorAddresses, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) public {
917         for (uint256 index = 0; index < ids.length; index++) {
918             operator.importWithdrawals(ids[index], ats[index], amounts[index], investorAddresses[index], presentees[index], reasons[index], times[index]);
919         }
920     }
921 
922     function splitAddresses(address[] memory addresses, uint256 from, uint256 to) internal pure returns(address[] memory output) {
923         output = new address[](to - from + 1);
924         for (uint256 i = from; i <= to; i++) {
925             output[i - from] = addresses[i];
926         }
927         return output;
928     }
929 
930     function splitNumbers(uint256[] memory numbers, uint256 from, uint256 to) internal pure returns(uint256[] memory output) {
931         output = new uint256[](to - from + 1);
932         for (uint256 i = from; i <= to; i++) {
933             output[i - from] = numbers[i];
934         }
935         return output;
936     }
937 }