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
321                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100 * 2 / 3;
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
385         for(uint256 i = from; i <= to; i++) {
386             paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
387         }
388     }
389     
390     function finishPayDailyIncome() public mustBeAdmin {
391         lastPayDailyIncome = getNow();
392         payDailyIncomeTimes++;
393     }
394     
395     function finishPaySystemCommission() public mustBeAdmin {
396         lastPaySystemCommission = getNow();
397         paySystemCommissionTimes++;
398     }
399     
400     function resetGame(uint256 from, uint256 to) public mustBeAdmin {
401         require(from >= 0 && to < investorAddresses.length);
402         require(currentVote.startTime != 0);
403         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
404         require(currentVote.yesPoint > currentVote.totalPoint / 2);
405         require(currentVote.emergencyAddress == address(0));
406         lastReset = getNow();
407         for (uint256 i = from; i < to; i++) {
408             address investorAddress = investorAddresses[i];
409             Investor storage investor = investors[investorAddress];
410             uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : 2;
411             if (currentVoteValue == 2) {
412                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
413                     investor.lastMaxOut = getNow();
414                     investor.depositedAmount = 0;
415                     investor.withdrewAmount = 0;
416                     investor.dailyIncomeWithrewAmount = 0;
417                 }
418                 investor.reserveCommission = 0;
419                 investor.rightSell = 0;
420                 investor.leftSell = 0;
421                 investor.totalSell = 0;
422                 investor.sellThisMonth = 0;
423             } else {
424                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
425                     investor.isDisabled = true;
426                     investor.reserveCommission = 0;
427                     investor.lastMaxOut = getNow();
428                     investor.depositedAmount = 0;
429                     investor.withdrewAmount = 0;
430                     investor.dailyIncomeWithrewAmount = 0;
431                 }
432                 investor.reserveCommission = 0;
433                 investor.rightSell = 0;
434                 investor.leftSell = 0;
435                 investor.totalSell = 0;
436                 investor.sellThisMonth = 0;
437             }
438             
439         }
440     }
441 
442     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
443         require(currentVote.startTime != 0);
444         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
445         require(currentVote.noPoint > currentVote.totalPoint / 2);
446         require(currentVote.emergencyAddress == address(0));
447         require(percent <= 50);
448         require(from >= 0 && to < investorAddresses.length);
449         for (uint256 i = from; i <= to; i++) {
450             address payable investorAddress = address(uint160(investorAddresses[i]));
451             Investor storage investor = investors[investorAddress];
452             if (investor.maxOutTimes > 0) continue;
453             if (investor.isDisabled) continue;
454             uint256 depositedAmount = investor.depositedAmount;
455             uint256 withdrewAmount = investor.withdrewAmount;
456             if (withdrewAmount >= depositedAmount / 2) continue;
457             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
458         }
459     }
460     
461     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = getNow(); }
462 
463     function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
464         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
465         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
466         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
467         uint256 depositedAmount = investors[investorAddress].depositedAmount;
468         uint256 reserveCommission = investors[investorAddress].reserveCommission;
469         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
470         sendEtherForInvestor(investorAddress, 0, 100, address(0), 0);
471     }
472 
473     function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
474         require(from >= 0 && to < investorAddresses.length);
475         for (uint256 i = from; i < to; i++) {
476             address investorAddress = investorAddresses[i];
477             if (investors[investorAddress].maxOutTimesInWeek == 0) continue;
478             investors[investorAddress].maxOutTimesInWeek = 0;
479         }
480     }
481 
482     function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }
483 
484     function disableInvestor(address investorAddress) public mustBeAdmin {
485         Investor storage investor = investors[investorAddress];
486         investor.isDisabled = true;
487     }
488     
489     function enableInvestor(address investorAddress) public mustBeAdmin {
490         Investor storage investor = investors[investorAddress];
491         investor.isDisabled = false;
492     }
493     
494     function donate() payable public { depositedAmountGross += msg.value; }
495 
496     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
497         if (totalSell < 30 ether) return 0;
498         if (totalSell < 60 ether) return 1;
499         if (totalSell < 90 ether) return 2;
500         if (totalSell < 120 ether) return 3;
501         if (totalSell < 150 ether) return 4;
502         return 5;
503     }
504 
505     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
506         if (sellThisMonth < 2 ether) return 0;
507         if (sellThisMonth < 4 ether) return 1;
508         if (sellThisMonth < 6 ether) return 2;
509         if (sellThisMonth < 8 ether) return 3;
510         if (sellThisMonth < 10 ether) return 4;
511         return 5;
512     }
513     
514     function getDepositLevel(uint256 depositedAmount) internal pure returns (uint256 level){
515         if (depositedAmount < 2 ether) return 0;
516         if (depositedAmount < 4 ether) return 1;
517         if (depositedAmount < 6 ether) return 2;
518         if (depositedAmount < 8 ether) return 3;
519         if (depositedAmount < 10 ether) return 4;
520         return 5;
521     }
522     
523     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
524         uint256 totalSellLevel = getTotalSellLevel(totalSell);
525         uint256 depLevel = getDepositLevel(depositedAmount);
526         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
527         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
528         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
529         return minLevel * 2;
530     }
531     
532     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
533         bytes memory tempEmptyStringTest = bytes(source);
534         if (tempEmptyStringTest.length == 0) return 0x0;
535         assembly { result := mload(add(source, 32)) }
536     }
537     
538     function getInvestor(address investorAddress) view public returns (address[] memory addresses, bool isDisabled, uint256[] memory numbers) {
539         addresses = new address[](4);
540         numbers = new uint256[](16);
541         Investor memory investor = investors[investorAddress];
542         addresses[0] = investor.parent;
543         addresses[1] = investor.leftChild;
544         addresses[2] = investor.rightChild;
545         addresses[3] = investor.presenter;
546         numbers[0] = investor.generation;
547         numbers[1] = investor.depositedAmount;
548         numbers[2] = investor.withdrewAmount;
549         numbers[3] = investor.lastMaxOut;
550         numbers[4] = investor.maxOutTimes;
551         numbers[5] = investor.maxOutTimesInWeek;
552         numbers[6] = investor.totalSell;
553         numbers[7] = investor.sellThisMonth;
554         numbers[8] = investor.rightSell;
555         numbers[9] = investor.leftSell;
556         numbers[10] = investor.reserveCommission;
557         numbers[11] = investor.dailyIncomeWithrewAmount;
558         numbers[12] = investor.registerTime;
559         numbers[13] = getUnpaidSystemCommission(investorAddress);
560         numbers[14] = getDailyIncomeForUser(investorAddress);
561         numbers[15] = investor.minDeposit;
562         return (addresses, investor.isDisabled, numbers);
563     }
564 
565     function getInvestorLength() view public returns(uint256) { return investorAddresses.length; }
566 
567     function getMaxOutsLength() view public returns(uint256) { return maxOutIds.length; }
568     
569     function getNodesAddresses(address rootNodeAddress) public view returns(address[] memory){
570         uint256 maxLength = investorAddresses.length;
571         address[] memory nodes = new address[](maxLength);
572         nodes[0] = rootNodeAddress;
573         uint256 processIndex = 0;
574         uint256 nextIndex = 1;
575         while (processIndex != nextIndex) {
576             Investor memory currentInvestor = investors[nodes[processIndex++]];
577             if (currentInvestor.leftChild != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;
578             if (currentInvestor.rightChild != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;
579         }
580         return nodes;
581     }
582     
583     function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
584     
585     function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
586     
587     function importInvestor(address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
588         if (investors[addresses[4]].generation != 0) return;
589         Investor memory investor = Investor({
590             isDisabled: isDisabled,
591             parent: addresses[0],
592             leftChild: addresses[1],
593             rightChild: addresses[2],
594             presenter: addresses[3],
595             generation: numbers[0],
596             depositedAmount: numbers[1],
597             withdrewAmount: numbers[2],
598             lastMaxOut: numbers[3],
599             maxOutTimes: numbers[4],
600             maxOutTimesInWeek: numbers[5],
601             totalSell: numbers[6],
602             sellThisMonth: numbers[7],
603             investments: new bytes32[](0),
604             withdrawals: new bytes32[](0),
605             rightSell: numbers[8],
606             leftSell: numbers[9],
607             reserveCommission: numbers[10],
608             dailyIncomeWithrewAmount: numbers[11],
609             registerTime: numbers[12],
610             minDeposit: MIN_DEP
611         });
612         investors[addresses[4]] = investor;
613         investorAddresses.push(addresses[4]);
614     }
615     
616     function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
617         if (investments[id].at != 0) return;
618         Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
619         investments[id] = investment;
620         investmentIds.push(id);
621         Investor storage investor = investors[investorAddress];
622         investor.investments.push(id);
623         depositedAmountGross += amount;
624     }
625     
626     function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
627         if (withdrawals[id].at != 0) return;
628         Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
629         withdrawals[id] = withdrawal;
630         Investor storage investor = investors[investorAddress];
631         investor.withdrawals.push(id);
632         withdrawalIds.push(id);
633     }
634     
635     function finishImporting() public mustBeAdmin { importing = false; }
636 
637     function finalizeVotes(uint256 from, uint256 to, bool isRemoving) public mustBeAdmin {
638         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
639         for (uint256 index = from; index < to; index++) {
640             address investorAddress = investorAddresses[index];
641             if (isRemoving && currentVote.votes[investorAddress] == 3) {
642                 currentVote.votes[investorAddress] = 0;
643                 continue;
644             }
645             if (currentVote.votes[investorAddress] == 0) {
646                 currentVote.yesPoint += 1;
647             }
648             currentVote.votes[investorAddress] = 3;
649         }
650     }
651 
652     function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
653         require(currentVote.startTime == 0);
654         currentVote = Vote({
655             startTime: getNow(),
656             reason: reason,
657             emergencyAddress: emergencyAddress,
658             yesPoint: 0,
659             noPoint: 0,
660             totalPoint: investorAddresses.length
661         });
662     }
663 
664     function removeVote() public mustBeAdmin {
665         currentVote = Vote({
666             startTime: 0,
667             reason: '',
668             emergencyAddress: address(0),
669             yesPoint: 0,
670             noPoint: 0,
671             totalPoint: 0
672         });
673     }
674     
675     function sendEtherToNewContract() public mustBeAdmin {
676         require(currentVote.startTime != 0);
677         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
678         require(currentVote.yesPoint > currentVote.totalPoint / 2);
679         require(currentVote.emergencyAddress != address(0));
680         bool isTransferSuccess = false;
681         (isTransferSuccess, ) = currentVote.emergencyAddress.call.value(address(this).balance)("");
682         if (!isTransferSuccess) revert();
683     }
684 
685     function voteProcess(address investor, bool isYes) internal {
686         require(investors[investor].depositedAmount > 0);
687         require(!investors[investor].isDisabled);
688         require(getNow() - currentVote.startTime < 3 * ONE_DAY);
689         uint8 newVoteValue = isYes ? 2 : 1;
690         uint8 currentVoteValue = currentVote.votes[investor];
691         require(newVoteValue != currentVoteValue);
692         updateVote(isYes);
693         if (currentVoteValue == 0) return;
694         if (isYes) {
695             currentVote.noPoint -= getVoteShare();
696         } else {
697             currentVote.yesPoint -= getVoteShare();
698         }
699     }
700     
701     function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
702     
703     function updateVote(bool isYes) internal {
704         currentVote.votes[msg.sender] = isYes ? 2 : 1;
705         if (isYes) {
706             currentVote.yesPoint += getVoteShare();
707         } else {
708             currentVote.noPoint += getVoteShare();
709         }
710     }
711     
712     function getVoteShare() public view returns(uint256) {
713         if (investors[msg.sender].generation >= 3) return 1;
714         if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
715         return 2;
716     }
717     
718     function setQuerier(address _querierAddress) public mustBeAdmin {
719         querierAddress = _querierAddress;
720     }
721 
722     function setAdmin2(address _admin2) public mustBeAdmin {
723         admin2 = _admin2;
724     }
725 
726     function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
727         paySystemCommissionTimes = _paySystemCommissionTimes;
728         payDailyIncomeTimes = _payDailyIncomeTimes;
729         lastPaySystemCommission = _lastPaySystemCommission;
730         lastPayDailyIncome = _lastPayDailyIncome;
731         contractStartAt = _contractStartAt;
732         lastReset = _lastReset;
733     }
734 
735     function depositFor(address investor) public payable mustBeAdmin {
736         depositProcess(investor);
737     }
738 }