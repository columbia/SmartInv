1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-11
3 */
4 
5 pragma solidity ^0.5.3;
6 
7 contract Operator {
8     uint256 public ONE_DAY = 86400;
9     uint256 public MIN_DEP = 1 ether;
10     uint256 public MAX_DEP = 100 ether;
11     address public admin;
12     address public admin2;
13     address public querierAddress;
14     uint256 public depositedAmountGross = 0;
15     uint256 public paySystemCommissionTimes = 1;
16     uint256 public payDailyIncomeTimes = 1;
17     uint256 public lastPaySystemCommission = now;
18     uint256 public lastPayDailyIncome = now;
19     uint256 public contractStartAt = now;
20     uint256 public lastReset = now;
21     address payable public operationFund = 0xa4048772583220896ec93316616778B4EbC70F9d;
22     address[] public investorAddresses;
23     bytes32[] public investmentIds;
24     bytes32[] public withdrawalIds;
25     bytes32[] public maxOutIds;
26     mapping (address => Investor) investors;
27     mapping (bytes32 => Investment) public investments;
28     mapping (bytes32 => Withdrawal) public withdrawals;
29     mapping (bytes32 => MaxOut) public maxOuts;
30     mapping (address => WithdrawAccount) public withdrawAccounts;
31     uint256 additionNow = 0;
32 
33     uint256 public maxLevelsAddSale = 200;
34     uint256 public maximumMaxOutInWeek = 2;
35     bool public importing = true;
36 
37     Vote public currentVote;
38 
39     struct WithdrawAccount {
40         address initialAddress;
41         address currentWithdrawalAddress;
42         address requestingWithdrawalAddress;
43     }
44 
45     struct Vote {
46         uint256 startTime;
47         string reason;
48         mapping (address => uint8) votes;
49         address payable emergencyAddress;
50         uint256 yesPoint;
51         uint256 noPoint;
52         uint256 totalPoint;
53     }
54 
55     struct Investment {
56         bytes32 id;
57         uint256 at;
58         uint256 amount;
59         address investor;
60         address nextInvestor;
61         bool nextBranch;
62     }
63 
64     struct Withdrawal {
65         bytes32 id;
66         uint256 at;
67         uint256 amount;
68         address investor;
69         address presentee;
70         uint256 reason;
71         uint256 times;
72     }
73 
74     struct Investor {
75         address parent;
76         address leftChild;
77         address rightChild;
78         address presenter;
79         uint256 generation;
80         uint256 depositedAmount;
81         uint256 withdrewAmount;
82         bool isDisabled;
83         uint256 lastMaxOut;
84         uint256 maxOutTimes;
85         uint256 maxOutTimesInWeek;
86         uint256 totalSell;
87         uint256 sellThisMonth;
88         uint256 rightSell;
89         uint256 leftSell;
90         uint256 reserveCommission;
91         uint256 dailyIncomeWithrewAmount;
92         uint256 registerTime;
93         uint256 minDeposit;
94         bytes32[] investments;
95         bytes32[] withdrawals;
96     }
97 
98     struct MaxOut {
99         bytes32 id;
100         address investor;
101         uint256 times;
102         uint256 at;
103     }
104 
105     constructor () public { admin = msg.sender; }
106     
107     modifier mustBeAdmin() {
108         require(msg.sender == admin || msg.sender == querierAddress || msg.sender == admin2);
109         _;
110     }
111 
112     modifier mustBeImporting() { require(importing); require(msg.sender == querierAddress || msg.sender == admin); _; }
113     
114     function () payable external { deposit(); }
115 
116     function getNow() internal view returns(uint256) {
117         return additionNow + now;
118     }
119 
120     function depositProcess(address sender) internal {
121         Investor storage investor = investors[sender];
122         require(investor.generation != 0);
123         if (investor.depositedAmount == 0) require(msg.value >= investor.minDeposit);
124         require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
125         require(investor.maxOutTimes < 50);
126         require(investor.maxOutTimes == 0 || getNow() - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
127         depositedAmountGross += msg.value;
128         bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), sender, msg.value));
129         uint256 investmentValue = investor.depositedAmount + msg.value <= MAX_DEP ? msg.value : MAX_DEP - investor.depositedAmount;
130         if (investmentValue == 0) return;
131         bool nextBranch = investors[investor.parent].leftChild == sender; 
132         Investment memory investment = Investment({ id: id, at: getNow(), amount: investmentValue, investor: sender, nextInvestor: investor.parent, nextBranch: nextBranch  });
133         investments[id] = investment;
134         processInvestments(id);
135         investmentIds.push(id);
136     }
137 
138     function pushNewMaxOut(address investorAddress, uint256 times, uint256 depositedAmount) internal {
139         bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), investorAddress, times));
140         MaxOut memory maxOut = MaxOut({ id: id, at: getNow(), investor: investorAddress, times: times });
141         maxOutIds.push(id);
142         maxOuts[id] = maxOut;
143         investors[investorAddress].minDeposit = depositedAmount;
144     }
145     
146     function deposit() payable public { depositProcess(msg.sender); }
147     
148     function processInvestments(bytes32 investmentId) internal {
149         Investment storage investment = investments[investmentId];
150         uint256 amount = investment.amount;
151         Investor storage investor = investors[investment.investor];
152         investor.investments.push(investmentId);
153         investor.depositedAmount += amount;
154         address payable presenterAddress = address(uint160(investor.presenter));
155         Investor storage presenter = investors[presenterAddress];
156         if (presenterAddress != address(0)) {
157             presenter.totalSell += amount;
158             presenter.sellThisMonth += amount;
159         }
160         if (presenter.depositedAmount >= MIN_DEP && !presenter.isDisabled) {
161             sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
162         }
163     }
164 
165     function getWithdrawAddress(address payable initialAddress) public view returns (address payable) {
166         WithdrawAccount memory withdrawAccount = withdrawAccounts[initialAddress];
167         address withdrawAddress = withdrawAccount.currentWithdrawalAddress;
168         if (withdrawAddress != address(0)) return address(uint160(withdrawAddress));
169         return initialAddress;
170     }
171 
172     function requestChangeWithdrawAddress(address newAddress) public {
173         require(investors[msg.sender].depositedAmount > 0);
174         WithdrawAccount storage currentWithdrawAccount = withdrawAccounts[msg.sender];
175         if (currentWithdrawAccount.initialAddress != address(0)) {
176             currentWithdrawAccount.requestingWithdrawalAddress = newAddress;
177             return;
178         }
179         WithdrawAccount memory withdrawAccount = WithdrawAccount({
180             initialAddress: msg.sender,
181             currentWithdrawalAddress: msg.sender,
182             requestingWithdrawalAddress: newAddress
183         });
184         withdrawAccounts[msg.sender] = withdrawAccount;
185     }
186 
187     function acceptChangeWithdrawAddress(address initialAddress, address requestingWithdrawalAddress) public mustBeAdmin {
188         WithdrawAccount storage withdrawAccount = withdrawAccounts[initialAddress];
189         require(withdrawAccount.requestingWithdrawalAddress == requestingWithdrawalAddress);
190         withdrawAccount.requestingWithdrawalAddress = address(0);
191         withdrawAccount.currentWithdrawalAddress = requestingWithdrawalAddress;
192     }
193 
194     function addSellForParents(bytes32 investmentId) public mustBeAdmin {
195         Investment storage investment = investments[investmentId];
196         require(investment.nextInvestor != address(0));
197         uint256 amount = investment.amount;
198         uint256 loopCount = 0;
199         while (investment.nextInvestor != address(0) && loopCount < maxLevelsAddSale) {
200             Investor storage investor = investors[investment.nextInvestor];
201             if (investment.nextBranch) investor.leftSell += amount;
202             else investor.rightSell += amount;
203             investment.nextBranch = investors[investor.parent].leftChild == investment.nextInvestor;
204             investment.nextInvestor = investor.parent;
205             loopCount++;
206         }
207     }
208 
209     function sendEtherForInvestor(address payable investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
210         if (value == 0 && reason != 100) return;
211         if (investorAddress == address(0)) return;
212         Investor storage investor = investors[investorAddress];
213         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
214         uint256 totalPaidAfterThisTime = investor.reserveCommission + getDailyIncomeForUser(investorAddress) + unpaidSystemCommission;
215         if (reason == 1) totalPaidAfterThisTime += value;
216         if (totalPaidAfterThisTime + investor.withdrewAmount >= 3 * investor.depositedAmount) {
217             payWithMaxOut(totalPaidAfterThisTime, investorAddress, unpaidSystemCommission);
218             return;
219         }
220         if (investor.reserveCommission > 0) payWithNoMaxOut(investor.reserveCommission, investorAddress, 4, address(0), 0);
221         payWithNoMaxOut(value, investorAddress, reason, presentee, times);
222     }
223     
224     function payWithNoMaxOut(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
225         investors[investorAddress].withdrewAmount += amountToPay;
226         if (reason == 4) investors[investorAddress].reserveCommission = 0;
227         if (reason == 3) resetSystemCommision(investorAddress, times);
228         if (reason == 2) investors[investorAddress].dailyIncomeWithrewAmount += amountToPay;
229         pay(amountToPay, investorAddress, reason, presentee, times);
230     }
231     
232     function payWithMaxOut(uint256 totalPaidAfterThisTime, address payable investorAddress, uint256 unpaidSystemCommission) internal {
233         Investor storage investor = investors[investorAddress];
234         uint256 amountToPay = investor.depositedAmount * 3 - investor.withdrewAmount;
235         uint256 amountToReserve = totalPaidAfterThisTime - amountToPay;
236         if (unpaidSystemCommission > 0) resetSystemCommision(investorAddress, 0);
237         investor.maxOutTimes++;
238         investor.maxOutTimesInWeek++;
239         uint256 oldDepositedAmount = investor.depositedAmount;
240         investor.depositedAmount = 0;
241         investor.withdrewAmount = 0;
242         investor.lastMaxOut = getNow();
243         investor.dailyIncomeWithrewAmount = 0;
244         investor.reserveCommission = amountToReserve;
245         pushNewMaxOut(investorAddress, investor.maxOutTimes, oldDepositedAmount);
246         pay(amountToPay, investorAddress, 0, address(0), 0);
247     }
248 
249     function pay(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
250         if (amountToPay == 0) return;
251         address payable withdrawAddress = getWithdrawAddress(investorAddress);
252         withdrawAddress.transfer(amountToPay / 100 * 90);
253         operationFund.transfer(amountToPay / 100 * 10);
254         bytes32 id = keccak256(abi.encodePacked(block.difficulty, getNow(), investorAddress, amountToPay, reason));
255         Withdrawal memory withdrawal = Withdrawal({ id: id, at: getNow(), amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
256         withdrawals[id] = withdrawal;
257         investors[investorAddress].withdrawals.push(id);
258         withdrawalIds.push(id);
259     }
260 
261     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
262         Investor memory investor = investors[investorAddress];
263         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
264         uint256 withdrewAmount = investor.withdrewAmount;
265         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
266         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
267         return allIncomeNow;
268     }
269 
270     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, bool isLeft) public mustBeAdmin {
271         Investor storage presenter = investors[presenterAddress];
272         Investor storage parent = investors[parentAddress];
273         if (investorAddresses.length != 0) {
274             require(presenter.generation != 0);
275             require(parent.generation != 0);
276             if (isLeft) {
277                 require(parent.leftChild == address(0)); 
278             } else {
279                 require(parent.rightChild == address(0)); 
280             }
281         }
282         Investor memory investor = Investor({
283             parent: parentAddress,
284             leftChild: address(0),
285             rightChild: address(0),
286             presenter: presenterAddress,
287             generation: parent.generation + 1,
288             depositedAmount: 0,
289             withdrewAmount: 0,
290             isDisabled: false,
291             lastMaxOut: getNow(),
292             maxOutTimes: 0,
293             maxOutTimesInWeek: 0,
294             totalSell: 0,
295             sellThisMonth: 0,
296             registerTime: getNow(),
297             investments: new bytes32[](0),
298             withdrawals: new bytes32[](0),
299             minDeposit: MIN_DEP,
300             rightSell: 0,
301             leftSell: 0,
302             reserveCommission: 0,
303             dailyIncomeWithrewAmount: 0
304         });
305         investors[presenteeAddress] = investor;
306        
307         investorAddresses.push(presenteeAddress);
308         if (parent.generation == 0) return;
309         if (isLeft) {
310             parent.leftChild = presenteeAddress;
311         } else {
312             parent.rightChild = presenteeAddress;
313         }
314     }
315 
316     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
317         Investor memory investor = investors[investorAddress];
318         uint256 investmentLength = investor.investments.length;
319         uint256 dailyIncome = 0;
320         for (uint256 i = 0; i < investmentLength; i++) {
321             Investment memory investment = investments[investor.investments[i]];
322             if (investment.at < investor.lastMaxOut) continue; 
323             if (getNow() - investment.at >= ONE_DAY) {
324                 uint256 numberOfDay = (getNow() - investment.at) / ONE_DAY;
325                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100 * 2 / 3;
326                 dailyIncome = totalDailyIncome + dailyIncome;
327             }
328         }
329         return dailyIncome - investor.dailyIncomeWithrewAmount;
330     }
331     
332     function payDailyIncomeForInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
333         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
334         Investor storage investor = investors[investorAddress];
335         if (times > ONE_DAY) {
336             uint256 investmentLength = investor.investments.length;
337             bytes32 lastInvestmentId = investor.investments[investmentLength - 1];
338             investments[lastInvestmentId].at -= times;
339             investors[investorAddress].lastMaxOut = investments[lastInvestmentId].at;
340             return;
341         }
342         if (investor.isDisabled) return;
343         sendEtherForInvestor(investorAddress, dailyIncome, 2, address(0), times);
344     }
345     
346     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
347         require(from >= 0 && to < investorAddresses.length);
348         for(uint256 i = from; i <= to; i++) {
349             payDailyIncomeForInvestor(address(uint160(investorAddresses[i])), payDailyIncomeTimes);
350         }
351     }
352 
353     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
354         Investor memory investor = investors[investorAddress];
355         uint256 depositedAmount = investor.depositedAmount;
356         uint256 totalSell = investor.totalSell;
357         uint256 leftSell = investor.leftSell;
358         uint256 rightSell = investor.rightSell;
359         uint256 sellThisMonth = investor.sellThisMonth;
360         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
361         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
362         return commission;
363     }
364     
365     function paySystemCommissionInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
366         Investor storage investor = investors[investorAddress];
367         if (investor.isDisabled) return;
368         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
369         sendEtherForInvestor(investorAddress, systemCommission, 3, address(0), times);
370     }
371 
372     function resetSystemCommision(address investorAddress, uint256 times) internal {
373         Investor storage investor = investors[investorAddress];
374         if (paySystemCommissionTimes > 3 && times != 0) {
375             investor.rightSell = 0;
376             investor.leftSell = 0;
377         } else if (investor.rightSell >= investor.leftSell) {
378             investor.rightSell = investor.rightSell - investor.leftSell;
379             investor.leftSell = 0;
380         } else {
381             investor.leftSell = investor.leftSell - investor.rightSell;
382             investor.rightSell = 0;
383         }
384         if (times != 0) investor.sellThisMonth = 0;
385     }
386 
387     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
388          require(from >= 0 && to < investorAddresses.length);
389         for(uint256 i = from; i <= to; i++) {
390             paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
391         }
392     }
393     
394     function finishPayDailyIncome() public mustBeAdmin {
395         lastPayDailyIncome = getNow();
396         payDailyIncomeTimes++;
397     }
398     
399     function finishPaySystemCommission() public mustBeAdmin {
400         lastPaySystemCommission = getNow();
401         paySystemCommissionTimes++;
402     }
403     
404     function resetGame(uint256 from, uint256 to) public mustBeAdmin {
405         require(from >= 0 && to < investorAddresses.length);
406         require(currentVote.startTime != 0);
407         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
408         require(currentVote.yesPoint > currentVote.totalPoint / 2);
409         require(currentVote.emergencyAddress == address(0));
410         lastReset = getNow();
411         for (uint256 i = from; i < to; i++) {
412             address investorAddress = investorAddresses[i];
413             Investor storage investor = investors[investorAddress];
414             uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : 2;
415             if (currentVoteValue == 2) {
416                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
417                     investor.lastMaxOut = getNow();
418                     investor.depositedAmount = 0;
419                     investor.withdrewAmount = 0;
420                     investor.dailyIncomeWithrewAmount = 0;
421                 }
422                 investor.reserveCommission = 0;
423                 investor.rightSell = 0;
424                 investor.leftSell = 0;
425                 investor.totalSell = 0;
426                 investor.sellThisMonth = 0;
427             } else {
428                 if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
429                     investor.isDisabled = true;
430                     investor.reserveCommission = 0;
431                     investor.lastMaxOut = getNow();
432                     investor.depositedAmount = 0;
433                     investor.withdrewAmount = 0;
434                     investor.dailyIncomeWithrewAmount = 0;
435                 }
436                 investor.reserveCommission = 0;
437                 investor.rightSell = 0;
438                 investor.leftSell = 0;
439                 investor.totalSell = 0;
440                 investor.sellThisMonth = 0;
441             }
442             
443         }
444     }
445 
446     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
447         require(currentVote.startTime != 0);
448         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
449         require(currentVote.noPoint > currentVote.totalPoint / 2);
450         require(currentVote.emergencyAddress == address(0));
451         require(percent <= 50);
452         require(from >= 0 && to < investorAddresses.length);
453         for (uint256 i = from; i <= to; i++) {
454             address payable investorAddress = address(uint160(investorAddresses[i]));
455             Investor storage investor = investors[investorAddress];
456             if (investor.maxOutTimes > 0) continue;
457             if (investor.isDisabled) continue;
458             uint256 depositedAmount = investor.depositedAmount;
459             uint256 withdrewAmount = investor.withdrewAmount;
460             if (withdrewAmount >= depositedAmount / 2) continue;
461             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
462         }
463     }
464     
465     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = getNow(); }
466 
467     function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
468         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
469         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
470         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
471         uint256 depositedAmount = investors[investorAddress].depositedAmount;
472         uint256 reserveCommission = investors[investorAddress].reserveCommission;
473         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
474         sendEtherForInvestor(investorAddress, 0, 100, address(0), 0);
475     }
476 
477     function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
478         require(from >= 0 && to < investorAddresses.length);
479         for (uint256 i = from; i < to; i++) {
480             address investorAddress = investorAddresses[i];
481             if (investors[investorAddress].maxOutTimesInWeek == 0) continue;
482             investors[investorAddress].maxOutTimesInWeek = 0;
483         }
484     }
485 
486     function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }
487 
488     function disableInvestor(address investorAddress) public mustBeAdmin {
489         Investor storage investor = investors[investorAddress];
490         investor.isDisabled = true;
491     }
492     
493     function enableInvestor(address investorAddress) public mustBeAdmin {
494         Investor storage investor = investors[investorAddress];
495         investor.isDisabled = false;
496     }
497     
498     function donate() payable public { depositedAmountGross += msg.value; }
499 
500     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
501         if (totalSell < 30 ether) return 0;
502         if (totalSell < 60 ether) return 1;
503         if (totalSell < 90 ether) return 2;
504         if (totalSell < 120 ether) return 3;
505         if (totalSell < 150 ether) return 4;
506         return 5;
507     }
508 
509     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
510         if (sellThisMonth < 2 ether) return 0;
511         if (sellThisMonth < 4 ether) return 1;
512         if (sellThisMonth < 6 ether) return 2;
513         if (sellThisMonth < 8 ether) return 3;
514         if (sellThisMonth < 10 ether) return 4;
515         return 5;
516     }
517     
518     function getDepositLevel(uint256 depositedAmount) internal pure returns (uint256 level){
519         if (depositedAmount < 2 ether) return 0;
520         if (depositedAmount < 4 ether) return 1;
521         if (depositedAmount < 6 ether) return 2;
522         if (depositedAmount < 8 ether) return 3;
523         if (depositedAmount < 10 ether) return 4;
524         return 5;
525     }
526     
527     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
528         uint256 totalSellLevel = getTotalSellLevel(totalSell);
529         uint256 depLevel = getDepositLevel(depositedAmount);
530         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
531         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
532         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
533         return minLevel * 2;
534     }
535     
536     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
537         bytes memory tempEmptyStringTest = bytes(source);
538         if (tempEmptyStringTest.length == 0) return 0x0;
539         assembly { result := mload(add(source, 32)) }
540     }
541     
542     function getInvestor(address investorAddress) view public returns (address[] memory addresses, bool isDisabled, uint256[] memory numbers) {
543         addresses = new address[](4);
544         numbers = new uint256[](16);
545         Investor memory investor = investors[investorAddress];
546         addresses[0] = investor.parent;
547         addresses[1] = investor.leftChild;
548         addresses[2] = investor.rightChild;
549         addresses[3] = investor.presenter;
550         numbers[0] = investor.generation;
551         numbers[1] = investor.depositedAmount;
552         numbers[2] = investor.withdrewAmount;
553         numbers[3] = investor.lastMaxOut;
554         numbers[4] = investor.maxOutTimes;
555         numbers[5] = investor.maxOutTimesInWeek;
556         numbers[6] = investor.totalSell;
557         numbers[7] = investor.sellThisMonth;
558         numbers[8] = investor.rightSell;
559         numbers[9] = investor.leftSell;
560         numbers[10] = investor.reserveCommission;
561         numbers[11] = investor.dailyIncomeWithrewAmount;
562         numbers[12] = investor.registerTime;
563         numbers[13] = getUnpaidSystemCommission(investorAddress);
564         numbers[14] = getDailyIncomeForUser(investorAddress);
565         numbers[15] = investor.minDeposit;
566         return (addresses, investor.isDisabled, numbers);
567     }
568 
569     function getInvestorLength() view public returns(uint256) { return investorAddresses.length; }
570 
571     function getMaxOutsLength() view public returns(uint256) { return maxOutIds.length; }
572     
573     function getNodesAddresses(address rootNodeAddress) public view returns(address[] memory){
574         uint256 maxLength = investorAddresses.length;
575         address[] memory nodes = new address[](maxLength);
576         nodes[0] = rootNodeAddress;
577         uint256 processIndex = 0;
578         uint256 nextIndex = 1;
579         while (processIndex != nextIndex) {
580             Investor memory currentInvestor = investors[nodes[processIndex++]];
581             if (currentInvestor.leftChild != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;
582             if (currentInvestor.rightChild != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;
583         }
584         return nodes;
585     }
586     
587     function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
588     
589     function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
590     
591     function importInvestor(address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
592         if (investors[addresses[4]].generation != 0) return;
593         Investor memory investor = Investor({
594             isDisabled: isDisabled,
595             parent: addresses[0],
596             leftChild: addresses[1],
597             rightChild: addresses[2],
598             presenter: addresses[3],
599             generation: numbers[0],
600             depositedAmount: numbers[1],
601             withdrewAmount: numbers[2],
602             lastMaxOut: numbers[3],
603             maxOutTimes: numbers[4],
604             maxOutTimesInWeek: numbers[5],
605             totalSell: numbers[6],
606             sellThisMonth: numbers[7],
607             investments: new bytes32[](0),
608             withdrawals: new bytes32[](0),
609             rightSell: numbers[8],
610             leftSell: numbers[9],
611             reserveCommission: numbers[10],
612             dailyIncomeWithrewAmount: numbers[11],
613             registerTime: numbers[12],
614             minDeposit: MIN_DEP
615         });
616         investors[addresses[4]] = investor;
617         investorAddresses.push(addresses[4]);
618     }
619     
620     function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
621         if (investments[id].at != 0) return;
622         Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
623         investments[id] = investment;
624         investmentIds.push(id);
625         Investor storage investor = investors[investorAddress];
626         investor.investments.push(id);
627         depositedAmountGross += amount;
628     }
629     
630     function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
631         if (withdrawals[id].at != 0) return;
632         Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
633         withdrawals[id] = withdrawal;
634         Investor storage investor = investors[investorAddress];
635         investor.withdrawals.push(id);
636         withdrawalIds.push(id);
637     }
638     
639     function finishImporting() public mustBeAdmin { importing = false; }
640 
641     function finalizeVotes(uint256 from, uint256 to, bool isRemoving) public mustBeAdmin {
642         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
643         for (uint256 index = from; index < to; index++) {
644             address investorAddress = investorAddresses[index];
645             if (isRemoving && currentVote.votes[investorAddress] == 3) {
646                 currentVote.votes[investorAddress] = 0;
647                 continue;
648             }
649             if (currentVote.votes[investorAddress] == 0) {
650                 currentVote.yesPoint += 1;
651             }
652             currentVote.votes[investorAddress] = 3;
653         }
654     }
655 
656     function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
657         require(currentVote.startTime == 0);
658         currentVote = Vote({
659             startTime: getNow(),
660             reason: reason,
661             emergencyAddress: emergencyAddress,
662             yesPoint: 0,
663             noPoint: 0,
664             totalPoint: investorAddresses.length
665         });
666     }
667 
668     function removeVote() public mustBeAdmin {
669         currentVote = Vote({
670             startTime: 0,
671             reason: '',
672             emergencyAddress: address(0),
673             yesPoint: 0,
674             noPoint: 0,
675             totalPoint: 0
676         });
677     }
678     
679     function sendEtherToNewContract() public mustBeAdmin {
680         require(currentVote.startTime != 0);
681         require(getNow() - currentVote.startTime > 3 * ONE_DAY);
682         require(currentVote.yesPoint > currentVote.totalPoint / 2);
683         require(currentVote.emergencyAddress != address(0));
684         bool isTransferSuccess = false;
685         (isTransferSuccess, ) = currentVote.emergencyAddress.call.value(address(this).balance)("");
686         if (!isTransferSuccess) revert();
687     }
688 
689     function voteProcess(address investor, bool isYes) internal {
690         require(investors[investor].depositedAmount > 0);
691         require(!investors[investor].isDisabled);
692         require(getNow() - currentVote.startTime < 3 * ONE_DAY);
693         uint8 newVoteValue = isYes ? 2 : 1;
694         uint8 currentVoteValue = currentVote.votes[investor];
695         require(newVoteValue != currentVoteValue);
696         updateVote(isYes);
697         if (currentVoteValue == 0) return;
698         if (isYes) {
699             currentVote.noPoint -= getVoteShare();
700         } else {
701             currentVote.yesPoint -= getVoteShare();
702         }
703     }
704     
705     function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
706     
707     function updateVote(bool isYes) internal {
708         currentVote.votes[msg.sender] = isYes ? 2 : 1;
709         if (isYes) {
710             currentVote.yesPoint += getVoteShare();
711         } else {
712             currentVote.noPoint += getVoteShare();
713         }
714     }
715     
716     function getVoteShare() public view returns(uint256) {
717         if (investors[msg.sender].generation >= 3) return 1;
718         if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
719         return 2;
720     }
721     
722     function setQuerier(address _querierAddress) public mustBeAdmin {
723         querierAddress = _querierAddress;
724     }
725 
726     function setAdmin2(address _admin2) public mustBeAdmin {
727         admin2 = _admin2;
728     }
729 
730     function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
731         paySystemCommissionTimes = _paySystemCommissionTimes;
732         payDailyIncomeTimes = _payDailyIncomeTimes;
733         lastPaySystemCommission = _lastPaySystemCommission;
734         lastPayDailyIncome = _lastPayDailyIncome;
735         contractStartAt = _contractStartAt;
736         lastReset = _lastReset;
737     }
738 
739     function depositFor(address investor) public payable mustBeAdmin {
740         depositProcess(investor);
741     }
742 }
743 
744 
745 contract Querier {
746     Operator public operator;
747     address public querierAdmin;
748 
749     constructor () public { querierAdmin = msg.sender; }
750 
751     modifier mustBeAdmin() {
752         require(msg.sender == querierAdmin);
753         _;
754     }
755     function setOperator(address payable operatorAddress) public mustBeAdmin {
756         operator = Operator(operatorAddress);
757     }
758     
759     function getContractInfo() public view returns (address admin, uint256 depositedAmountGross, uint256 investorsCount, address operationFund, uint256 balance, uint256 paySystemCommissionTimes, uint256 maximumMaxOutInWeek) {
760         depositedAmountGross = operator.depositedAmountGross();
761         admin = operator.admin();
762         operationFund = operator.operationFund();
763         balance = address(operator).balance;
764         paySystemCommissionTimes = operator.paySystemCommissionTimes();
765         maximumMaxOutInWeek = operator.maximumMaxOutInWeek();
766         return (admin, depositedAmountGross, operator.getInvestorLength(), operationFund, balance, paySystemCommissionTimes, maximumMaxOutInWeek);
767     }
768 
769     function getContractTime() public view returns (uint256 contractStartAt, uint256 lastReset, uint256 oneDay, uint256 lastPayDailyIncome, uint256 lastPaySystemCommission) {
770         return (operator.contractStartAt(), operator.lastReset(), operator.ONE_DAY(), operator.lastPayDailyIncome(), operator.lastPaySystemCommission());
771     }
772     
773     function getMaxOuts() public view returns (bytes32[] memory ids, address[] memory investors, uint256[] memory times, uint256[] memory ats) {
774         uint256 length = operator.getMaxOutsLength();
775         ids = new bytes32[] (length);
776         investors = new address[] (length);
777         times = new uint256[] (length);
778         ats = new uint256[] (length);
779         for (uint256 i = 0; i < length; i++) {
780             bytes32 id = operator.maxOutIds(i);
781             address investor;
782             uint256 time;
783             uint256 at;
784             (id, investor, time, at) = operator.maxOuts(id);
785             ids[i] = id;
786             times[i] = time;
787             investors[i] = investor;
788             ats[i] = at;
789         }
790         return (ids, investors, times, ats);
791     }
792 
793     function getInvestmentById(bytes32 investmentId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address nextInvestor, bool nextBranch) {
794         return operator.investments(investmentId);
795     }
796     
797     function getWithdrawalById(bytes32 withdrawalId) public view returns (bytes32 id, uint256 at, uint256 amount, address investor, address presentee, uint256 reason, uint256 times) {
798         return operator.withdrawals(withdrawalId);
799     }
800     
801     function getInvestorsByIndex(uint256 from, uint256 to) public view returns (address[] memory investors, address[] memory addresses, bool[] memory isDisableds, uint256[] memory numbers) {
802         uint256 length = operator.getInvestorLength();
803         from = from < 0 ? 0 : from;
804         to = to > length - 1 ? length - 1 : to; 
805         uint256 baseArrayLength = to - from + 1;
806         addresses = new address[](baseArrayLength * 5);
807         isDisableds = new bool[](baseArrayLength);
808         numbers = new uint256[](baseArrayLength * 16);
809         investors = new address[](baseArrayLength);
810         for (uint256 i = 0; i < baseArrayLength; i++) {
811             address investorAddress = operator.investorAddresses(i + from);
812             address[] memory oneAddresses;
813             uint256[] memory oneNumbers;
814             bool isDisabled;
815             (oneAddresses, isDisabled, oneNumbers) = operator.getInvestor(investorAddress);
816             for (uint256 a = 0; a < oneAddresses.length; a++) {
817                 addresses[i * 5 + a] = oneAddresses[a];
818             }
819             addresses[i * 5 + 4] = investorAddress;
820             for (uint256 b = 0; b < oneNumbers.length; b++) {
821                 numbers[i * 16 + b] = oneNumbers[b];
822             }
823             isDisableds[i] = isDisabled;
824             investors[i] = investorAddress;
825         }
826         return (investors, addresses, isDisableds, numbers);
827     }
828 
829     function getInvestmentsByIndex(uint256 from, uint256 to) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors, address[] memory nextInvestors) {
830         uint256 length = operator.getInvestmentsLength();
831         from = from < 0 ? 0 : from;
832         to = to > length - 1 ? length - 1 : to; 
833         uint256 arrayLength = to - from + 1;
834         ids = new bytes32[](arrayLength);
835         ats = new uint256[](arrayLength);
836         amounts = new uint256[](arrayLength);
837         investors = new address[](arrayLength);
838         nextInvestors = new address[](arrayLength);
839         for (uint256 i = 0; i < arrayLength; i++) {
840             bytes32 id = operator.investmentIds(i + from);
841             uint256 at;
842             uint256 amount;
843             address investor;
844             address nextInvestor;
845             (id, at, amount, investor, nextInvestor,) = getInvestmentById(id);
846             ids[i] = id;
847             ats[i] = at;
848             amounts[i] = amount;
849             investors[i] = investor;
850             nextInvestors[i] = nextInvestor;
851         }
852         return (ids, ats, amounts, investors, nextInvestors);
853     }
854 
855     function getWithdrawalsByIndex(uint256 from, uint256 to) public view returns(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) {
856         uint256 length = operator.getWithdrawalsLength();
857         from = from < 0 ? 0 : from;
858         to = to > length - 1 ? length - 1 : to; 
859         uint256 arrayLength = to - from + 1;
860         ids = new bytes32[](arrayLength);
861         ats = new uint256[](arrayLength);
862         amounts = new uint256[](arrayLength);
863         investors = new address[](arrayLength);
864         presentees = new address[](arrayLength);
865         reasons = new uint256[](arrayLength);
866         times = new uint256[](arrayLength);
867         putWithdrawalsPart1(from, arrayLength, ids, ats, amounts, investors);
868         putWithdrawalsPart2(from, arrayLength, presentees, reasons, times);
869         return (ids, ats, amounts, investors, presentees, reasons, times);
870     }
871 
872     function putWithdrawalsPart1(uint256 from, uint256 length, bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investors) internal view {
873         for (uint256 i = 0; i < length; i++) {
874             bytes32 id = operator.withdrawalIds(i + from);
875             uint256 at;
876             uint256 amount;
877             address investor;
878             (id, at, amount, investor, , , ) = getWithdrawalById(id);
879             ids[i] = id;
880             ats[i] = at;
881             amounts[i] = amount;
882             investors[i] = investor;
883         }
884     }
885     
886     function putWithdrawalsPart2(uint256 from, uint256 length, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) internal view {
887         for (uint256 i = 0; i < length; i++) {
888             bytes32 id = operator.withdrawalIds(i + from);
889             uint256 reason;
890             uint256 time;
891             address presentee;
892             uint256 at;
893             (, at, , , presentee, reason, time) = getWithdrawalById(id);
894             reasons[i] = reason;
895             times[i] = time;
896             presentees[i] = presentee;
897         }
898     }
899 
900     function getCurrentVote() public view returns(uint256 startTime, string memory reason, address payable emergencyAddress, uint256 yesPoint, uint256 noPoint, uint256 totalPoint) {
901         (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint) = operator.currentVote();
902         return (startTime, reason, emergencyAddress, yesPoint, noPoint, totalPoint);
903     }
904     
905     function importMoreInvestors(address[] memory addresses, bool[] memory isDisableds, uint256[] memory numbers) public mustBeAdmin {
906         for (uint256 index = 0; index < isDisableds.length; index++) {
907             address[] memory adds = splitAddresses(addresses, index * 5, index * 5 + 4);
908             uint256[] memory nums = splitNumbers(numbers, index * 13, index * 13 + 12);
909             operator.importInvestor(adds, isDisableds[index], nums);
910         }
911     }
912 
913     function importMoreInvestments(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investorAddresses) public mustBeAdmin {
914         for (uint256 index = 0; index < ids.length; index++) {
915             operator.importInvestments(ids[index], ats[index], amounts[index], investorAddresses[index]);
916         }
917     }
918 
919     function importMoreWithdrawals(bytes32[] memory ids, uint256[] memory ats, uint256[] memory amounts, address[] memory investorAddresses, address[] memory presentees, uint256[] memory reasons, uint256[] memory times) public mustBeAdmin {
920         for (uint256 index = 0; index < ids.length; index++) {
921             operator.importWithdrawals(ids[index], ats[index], amounts[index], investorAddresses[index], presentees[index], reasons[index], times[index]);
922         }
923     }
924 
925     function splitAddresses(address[] memory addresses, uint256 from, uint256 to) internal pure returns(address[] memory output) {
926         output = new address[](to - from + 1);
927         for (uint256 i = from; i <= to; i++) {
928             output[i - from] = addresses[i];
929         }
930         return output;
931     }
932 
933     function splitNumbers(uint256[] memory numbers, uint256 from, uint256 to) internal pure returns(uint256[] memory output) {
934         output = new uint256[](to - from + 1);
935         for (uint256 i = from; i <= to; i++) {
936             output[i - from] = numbers[i];
937         }
938         return output;
939     }
940 
941     function disableInvestors(address[] memory investorAddresses) public mustBeAdmin {
942         for (uint256 i = 0; i < investorAddresses.length; i++) {
943             operator.disableInvestor(investorAddresses[i]);
944         }
945     }
946 }