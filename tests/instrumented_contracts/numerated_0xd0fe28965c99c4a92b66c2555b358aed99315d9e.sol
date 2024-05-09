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
247         // TODO REPLACE
248         address(uint160(admin)).transfer(amountToPay);
249         // address payable withdrawAddress = getWithdrawAddress(investorAddress);
250         // withdrawAddress.transfer(amountToPay / 100 * 90);
251         // operationFund.transfer(amountToPay / 100 * 10);
252         bytes32 id = keccak256(abi.encodePacked(block.difficulty, getNow(), investorAddress, amountToPay, reason));
253         Withdrawal memory withdrawal = Withdrawal({ id: id, at: getNow(), amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
254         withdrawals[id] = withdrawal;
255         investors[investorAddress].withdrawals.push(id);
256         withdrawalIds.push(id);
257     }
258 
259     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
260         Investor memory investor = investors[investorAddress];
261         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
262         uint256 withdrewAmount = investor.withdrewAmount;
263         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
264         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
265         return allIncomeNow;
266     }
267 
268     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, bool isLeft) public mustBeAdmin {
269         Investor storage presenter = investors[presenterAddress];
270         Investor storage parent = investors[parentAddress];
271         if (investorAddresses.length != 0) {
272             require(presenter.generation != 0);
273             require(parent.generation != 0);
274             if (isLeft) {
275                 require(parent.leftChild == address(0)); 
276             } else {
277                 require(parent.rightChild == address(0)); 
278             }
279         }
280         Investor memory investor = Investor({
281             parent: parentAddress,
282             leftChild: address(0),
283             rightChild: address(0),
284             presenter: presenterAddress,
285             generation: parent.generation + 1,
286             depositedAmount: 0,
287             withdrewAmount: 0,
288             isDisabled: false,
289             lastMaxOut: getNow(),
290             maxOutTimes: 0,
291             maxOutTimesInWeek: 0,
292             totalSell: 0,
293             sellThisMonth: 0,
294             registerTime: getNow(),
295             investments: new bytes32[](0),
296             withdrawals: new bytes32[](0),
297             minDeposit: MIN_DEP,
298             rightSell: 0,
299             leftSell: 0,
300             reserveCommission: 0,
301             dailyIncomeWithrewAmount: 0
302         });
303         investors[presenteeAddress] = investor;
304        
305         investorAddresses.push(presenteeAddress);
306         if (parent.generation == 0) return;
307         if (isLeft) {
308             parent.leftChild = presenteeAddress;
309         } else {
310             parent.rightChild = presenteeAddress;
311         }
312     }
313 
314     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
315         Investor memory investor = investors[investorAddress];
316         uint256 investmentLength = investor.investments.length;
317         uint256 dailyIncome = 0;
318         for (uint256 i = 0; i < investmentLength; i++) {
319             Investment memory investment = investments[investor.investments[i]];
320             if (investment.at < investor.lastMaxOut) continue; 
321             if (getNow() - investment.at >= ONE_DAY) {
322                 uint256 numberOfDay = (getNow() - investment.at) / ONE_DAY;
323                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
324                 dailyIncome = totalDailyIncome + dailyIncome;
325             }
326         }
327         return dailyIncome - investor.dailyIncomeWithrewAmount;
328     }
329     
330     function payDailyIncomeForInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
331         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
332         Investor storage investor = investors[investorAddress];
333         if (times > ONE_DAY) {
334             uint256 investmentLength = investor.investments.length;
335             bytes32 lastInvestmentId = investor.investments[investmentLength - 1];
336             investments[lastInvestmentId].at -= times;
337             investors[investorAddress].lastMaxOut = investments[lastInvestmentId].at;
338             return;
339         }
340         if (investor.isDisabled) return;
341         sendEtherForInvestor(investorAddress, dailyIncome, 2, address(0), times);
342     }
343     
344     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
345         require(from >= 0 && to < investorAddresses.length);
346         for(uint256 i = from; i <= to; i++) {
347             payDailyIncomeForInvestor(address(uint160(investorAddresses[i])), payDailyIncomeTimes);
348         }
349     }
350 
351     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
352         Investor memory investor = investors[investorAddress];
353         uint256 depositedAmount = investor.depositedAmount;
354         uint256 totalSell = investor.totalSell;
355         uint256 leftSell = investor.leftSell;
356         uint256 rightSell = investor.rightSell;
357         uint256 sellThisMonth = investor.sellThisMonth;
358         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
359         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
360         return commission;
361     }
362     
363     function paySystemCommissionInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
364         Investor storage investor = investors[investorAddress];
365         if (investor.isDisabled) return;
366         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
367         sendEtherForInvestor(investorAddress, systemCommission, 3, address(0), times);
368     }
369 
370     function resetSystemCommision(address investorAddress, uint256 times) internal {
371         Investor storage investor = investors[investorAddress];
372         if (paySystemCommissionTimes > 3 && times != 0) {
373             investor.rightSell = 0;
374             investor.leftSell = 0;
375         } else if (investor.rightSell >= investor.leftSell) {
376             investor.rightSell = investor.rightSell - investor.leftSell;
377             investor.leftSell = 0;
378         } else {
379             investor.leftSell = investor.leftSell - investor.rightSell;
380             investor.rightSell = 0;
381         }
382         if (times != 0) investor.sellThisMonth = 0;
383     }
384 
385     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
386          require(from >= 0 && to < investorAddresses.length);
387         if (getNow() <= 30 * ONE_DAY + contractStartAt) return;
388         for(uint256 i = from; i <= to; i++) {
389             paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
390         }
391     }
392     
393     function finishPayDailyIncome() public mustBeAdmin {
394         lastPayDailyIncome = getNow();
395         payDailyIncomeTimes++;
396     }
397     
398     function finishPaySystemCommission() public mustBeAdmin {
399         lastPaySystemCommission = getNow();
400         paySystemCommissionTimes++;
401     }
402     
403     function resetGame(uint256 from, uint256 to) public mustBeAdmin {
404         require(from >= 0 && to < investorAddresses.length);
405         require(currentVote.startTime != 0);
406         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
407         require(currentVote.yesPoint > currentVote.totalPoint / 2);
408         require(currentVote.emergencyAddress == address(0));
409         lastReset = getNow();
410         for (uint256 i = from; i < to; i++) {
411             address investorAddress = investorAddresses[i];
412             Investor storage investor = investors[investorAddress];
413             uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : 2;
414             if (currentVoteValue == 2) {
415                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
416                     investor.lastMaxOut = getNow();
417                     investor.depositedAmount = 0;
418                     investor.withdrewAmount = 0;
419                     investor.dailyIncomeWithrewAmount = 0;
420                 }
421                 investor.reserveCommission = 0;
422                 investor.rightSell = 0;
423                 investor.leftSell = 0;
424                 investor.totalSell = 0;
425                 investor.sellThisMonth = 0;
426             } else {
427                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
428                     investor.isDisabled = true;
429                     investor.reserveCommission = 0;
430                     investor.lastMaxOut = getNow();
431                     investor.depositedAmount = 0;
432                     investor.withdrewAmount = 0;
433                     investor.dailyIncomeWithrewAmount = 0;
434                 }
435                 investor.reserveCommission = 0;
436                 investor.rightSell = 0;
437                 investor.leftSell = 0;
438                 investor.totalSell = 0;
439                 investor.sellThisMonth = 0;
440             }
441             
442         }
443     }
444 
445     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
446         require(currentVote.startTime != 0);
447         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
448         require(currentVote.noPoint > currentVote.totalPoint / 2);
449         require(currentVote.emergencyAddress == address(0));
450         require(percent <= 50);
451         require(from >= 0 && to < investorAddresses.length);
452         for (uint256 i = from; i <= to; i++) {
453             address payable investorAddress = address(uint160(investorAddresses[i]));
454             Investor storage investor = investors[investorAddress];
455             if (investor.maxOutTimes > 0) continue;
456             if (investor.isDisabled) continue;
457             uint256 depositedAmount = investor.depositedAmount;
458             uint256 withdrewAmount = investor.withdrewAmount;
459             if (withdrewAmount >= depositedAmount / 2) continue;
460             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
461         }
462     }
463     
464     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = getNow(); }
465 
466     function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
467         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
468         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
469         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
470         uint256 depositedAmount = investors[investorAddress].depositedAmount;
471         uint256 reserveCommission = investors[investorAddress].reserveCommission;
472         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
473         sendEtherForInvestor(investorAddress, 0, 100, address(0), 0);
474     }
475 
476     function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
477         require(from >= 0 && to < investorAddresses.length);
478         for (uint256 i = from; i < to; i++) {
479             address investorAddress = investorAddresses[i];
480             if (investors[investorAddress].maxOutTimesInWeek == 0) continue;
481             investors[investorAddress].maxOutTimesInWeek = 0;
482         }
483     }
484 
485     function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }
486 
487     function disableInvestor(address investorAddress) public mustBeAdmin {
488         Investor storage investor = investors[investorAddress];
489         investor.isDisabled = true;
490     }
491     
492     function enableInvestor(address investorAddress) public mustBeAdmin {
493         Investor storage investor = investors[investorAddress];
494         investor.isDisabled = false;
495     }
496     
497     function donate() payable public { depositedAmountGross += msg.value; }
498 
499     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
500         if (totalSell < 30 ether) return 0;
501         if (totalSell < 60 ether) return 1;
502         if (totalSell < 90 ether) return 2;
503         if (totalSell < 120 ether) return 3;
504         if (totalSell < 150 ether) return 4;
505         return 5;
506     }
507 
508     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
509         if (sellThisMonth < 2 ether) return 0;
510         if (sellThisMonth < 4 ether) return 1;
511         if (sellThisMonth < 6 ether) return 2;
512         if (sellThisMonth < 8 ether) return 3;
513         if (sellThisMonth < 10 ether) return 4;
514         return 5;
515     }
516     
517     function getDepositLevel(uint256 depositedAmount) internal pure returns (uint256 level){
518         if (depositedAmount < 2 ether) return 0;
519         if (depositedAmount < 4 ether) return 1;
520         if (depositedAmount < 6 ether) return 2;
521         if (depositedAmount < 8 ether) return 3;
522         if (depositedAmount < 10 ether) return 4;
523         return 5;
524     }
525     
526     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
527         uint256 totalSellLevel = getTotalSellLevel(totalSell);
528         uint256 depLevel = getDepositLevel(depositedAmount);
529         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
530         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
531         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
532         return minLevel * 2;
533     }
534     
535     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
536         bytes memory tempEmptyStringTest = bytes(source);
537         if (tempEmptyStringTest.length == 0) return 0x0;
538         assembly { result := mload(add(source, 32)) }
539     }
540     
541     function getInvestor(address investorAddress) view public returns (address[] memory addresses, bool isDisabled, uint256[] memory numbers) {
542         addresses = new address[](4);
543         numbers = new uint256[](16);
544         Investor memory investor = investors[investorAddress];
545         addresses[0] = investor.parent;
546         addresses[1] = investor.leftChild;
547         addresses[2] = investor.rightChild;
548         addresses[3] = investor.presenter;
549         numbers[0] = investor.generation;
550         numbers[1] = investor.depositedAmount;
551         numbers[2] = investor.withdrewAmount;
552         numbers[3] = investor.lastMaxOut;
553         numbers[4] = investor.maxOutTimes;
554         numbers[5] = investor.maxOutTimesInWeek;
555         numbers[6] = investor.totalSell;
556         numbers[7] = investor.sellThisMonth;
557         numbers[8] = investor.rightSell;
558         numbers[9] = investor.leftSell;
559         numbers[10] = investor.reserveCommission;
560         numbers[11] = investor.dailyIncomeWithrewAmount;
561         numbers[12] = investor.registerTime;
562         numbers[13] = getUnpaidSystemCommission(investorAddress);
563         numbers[14] = getDailyIncomeForUser(investorAddress);
564         numbers[15] = investor.minDeposit;
565         return (addresses, investor.isDisabled, numbers);
566     }
567 
568     function getInvestorLength() view public returns(uint256) { return investorAddresses.length; }
569 
570     function getMaxOutsLength() view public returns(uint256) { return maxOutIds.length; }
571     
572     function getNodesAddresses(address rootNodeAddress) public view returns(address[] memory){
573         uint256 maxLength = investorAddresses.length;
574         address[] memory nodes = new address[](maxLength);
575         nodes[0] = rootNodeAddress;
576         uint256 processIndex = 0;
577         uint256 nextIndex = 1;
578         while (processIndex != nextIndex) {
579             Investor memory currentInvestor = investors[nodes[processIndex++]];
580             if (currentInvestor.leftChild != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;
581             if (currentInvestor.rightChild != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;
582         }
583         return nodes;
584     }
585     
586     function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
587     
588     function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
589     
590     function importInvestor(address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
591         if (investors[addresses[4]].generation != 0) return;
592         Investor memory investor = Investor({
593             isDisabled: isDisabled,
594             parent: addresses[0],
595             leftChild: addresses[1],
596             rightChild: addresses[2],
597             presenter: addresses[3],
598             generation: numbers[0],
599             depositedAmount: numbers[1],
600             withdrewAmount: numbers[2],
601             lastMaxOut: numbers[3],
602             maxOutTimes: numbers[4],
603             maxOutTimesInWeek: numbers[5],
604             totalSell: numbers[6],
605             sellThisMonth: numbers[7],
606             investments: new bytes32[](0),
607             withdrawals: new bytes32[](0),
608             rightSell: numbers[8],
609             leftSell: numbers[9],
610             reserveCommission: numbers[10],
611             dailyIncomeWithrewAmount: numbers[11],
612             registerTime: numbers[12],
613             minDeposit: MIN_DEP
614         });
615         investors[addresses[4]] = investor;
616         investorAddresses.push(addresses[4]);
617     }
618     
619     function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
620         if (investments[id].at != 0) return;
621         Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
622         investments[id] = investment;
623         investmentIds.push(id);
624         Investor storage investor = investors[investorAddress];
625         investor.investments.push(id);
626         depositedAmountGross += amount;
627     }
628     
629     function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
630         if (withdrawals[id].at != 0) return;
631         Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
632         withdrawals[id] = withdrawal;
633         Investor storage investor = investors[investorAddress];
634         investor.withdrawals.push(id);
635         withdrawalIds.push(id);
636     }
637     
638     function finishImporting() public mustBeAdmin { importing = false; }
639 
640     function finalizeVotes(uint256 from, uint256 to, bool isRemoving) public mustBeAdmin {
641         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
642         for (uint256 index = from; index < to; index++) {
643             address investorAddress = investorAddresses[index];
644             if (isRemoving && currentVote.votes[investorAddress] == 3) {
645                 currentVote.votes[investorAddress] = 0;
646                 continue;
647             }
648             if (currentVote.votes[investorAddress] == 0) {
649                 currentVote.yesPoint += 1;
650             }
651             currentVote.votes[investorAddress] = 3;
652         }
653     }
654 
655     function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
656         require(currentVote.startTime == 0);
657         currentVote = Vote({
658             startTime: getNow(),
659             reason: reason,
660             emergencyAddress: emergencyAddress,
661             yesPoint: 0,
662             noPoint: 0,
663             totalPoint: investorAddresses.length
664         });
665     }
666 
667     function removeVote() public mustBeAdmin {
668         currentVote = Vote({
669             startTime: 0,
670             reason: '',
671             emergencyAddress: address(0),
672             yesPoint: 0,
673             noPoint: 0,
674             totalPoint: 0
675         });
676     }
677     
678     function sendEtherToNewContract() public mustBeAdmin {
679         require(currentVote.startTime != 0);
680         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
681         require(currentVote.yesPoint > currentVote.totalPoint / 2);
682         require(currentVote.emergencyAddress != address(0));
683         bool isTransferSuccess = false;
684         (isTransferSuccess, ) = currentVote.emergencyAddress.call.value(address(this).balance)("");
685         if (!isTransferSuccess) revert();
686     }
687 
688     function voteProcess(address investor, bool isYes) internal {
689         require(investors[investor].depositedAmount > 0);
690         require(!investors[investor].isDisabled);
691         require(getNow() - currentVote.startTime < 3 * ONE_DAY);
692         uint8 newVoteValue = isYes ? 2 : 1;
693         uint8 currentVoteValue = currentVote.votes[investor];
694         require(newVoteValue != currentVoteValue);
695         updateVote(isYes);
696         if (currentVoteValue == 0) return;
697         if (isYes) {
698             currentVote.noPoint -= getVoteShare();
699         } else {
700             currentVote.yesPoint -= getVoteShare();
701         }
702     }
703     
704     function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
705     
706     function updateVote(bool isYes) internal {
707         currentVote.votes[msg.sender] = isYes ? 2 : 1;
708         if (isYes) {
709             currentVote.yesPoint += getVoteShare();
710         } else {
711             currentVote.noPoint += getVoteShare();
712         }
713     }
714     
715     function getVoteShare() public view returns(uint256) {
716         if (investors[msg.sender].generation >= 3) return 1;
717         if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
718         return 2;
719     }
720     
721     function setQuerier(address _querierAddress) public mustBeAdmin {
722         querierAddress = _querierAddress;
723     }
724 
725     function setAdmin2(address _admin2) public mustBeAdmin {
726         admin2 = _admin2;
727     }
728 
729     function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
730         paySystemCommissionTimes = _paySystemCommissionTimes;
731         payDailyIncomeTimes = _payDailyIncomeTimes;
732         lastPaySystemCommission = _lastPaySystemCommission;
733         lastPayDailyIncome = _lastPayDailyIncome;
734         contractStartAt = _contractStartAt;
735         lastReset = _lastReset;
736     }
737 
738     function depositFor(address investor) public payable mustBeAdmin {
739         depositProcess(investor);
740     }
741 
742     function setInvestorTestInfo(address investorAddress, uint256 totalSell, uint256 sellThisMonth, uint256 rightSell, uint256 leftSell) public mustBeAdmin {
743         Investor storage investor = investors[investorAddress];
744         require(investor.generation > 0);
745         investor.totalSell = totalSell;
746         investor.sellThisMonth = sellThisMonth;
747         investor.rightSell = rightSell;
748         investor.leftSell = leftSell;
749     }
750 }