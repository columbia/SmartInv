1 pragma solidity ^0.4.25;
2 
3 // 12/11
4 
5 contract CommunityFunds {
6     event MaxOut (address investor, uint256 times, uint256 at);
7     
8     uint256 public constant ONE_DAY = 86400;
9     address private admin;
10     uint256 private depositedAmountGross = 0;
11     uint256 private paySystemCommissionTimes = 1;
12     uint256 private payDailyIncomeTimes = 1;
13     uint256 private lastPaySystemCommission = now;
14     uint256 private lastPayDailyIncome = now;
15     uint256 private contractStartAt = now;
16     uint256 private lastReset = now;
17    
18     address private operationFund = 0xe707EF0F76172eb2ed2541Af344acb2dB092406a;
19     address private developmentFund = 0x319bC822Fb406444f9756929DdC294B649A01b2E;
20     address private reserveFund = 0xa04DE4366F6d06b84a402Ed0310360E1d554d8Fc;
21     address private emergencyAccount = 0x6DeC2927cC604D1bE364C1DaBDE8f8597D5f4387;
22     bool private emergencyMode = false;
23     mapping (address => Investor) investors;
24     address[] public investorAddresses;
25     mapping (bytes32 => Investment) investments;
26     mapping (bytes32 => Withdrawal) withdrawals;
27     bytes32[] private investmentIds;
28     bytes32[] private withdrawalIds;
29     
30     uint256 maximumMaxOutInWeek = 4;
31     
32     struct Investment {
33         bytes32 id;
34         uint256 at;
35         uint256 amount;
36         address investor;
37     }
38 
39     struct Withdrawal {
40         bytes32 id;
41         uint256 at;
42         uint256 amount;
43         address investor;
44         address presentee;
45         uint256 reason;
46         uint256 times;
47     }
48 
49  
50 
51     struct Investor {
52         string email;
53         address parent;
54         address leftChild;
55         address rightChild;
56         address presenter;
57         uint256 generation;
58         address[] presentees;
59         uint256 depositedAmount;
60         uint256 withdrewAmount;
61         bool isDisabled;
62         uint256 lastMaxOut;
63         uint256 maxOutTimes;
64         uint256 maxOutTimesInWeek;
65         uint256 totalSell;
66         uint256 sellThisMonth;
67         bytes32[] investments;
68         bytes32[] withdrawals;
69         uint256 rightSell;
70         uint256 leftSell;
71         uint256 reserveCommission;
72         uint256 dailyIncomeWithrewAmount;
73     }
74 
75     constructor () public { admin = msg.sender; }
76     
77     modifier mustBeAdmin() { require(msg.sender == admin); _; }    
78     
79     function () payable public { deposit(); }
80     
81 
82     function deposit() payable public {
83         require(msg.value >= 0.2 ether);
84         Investor storage investor = investors[msg.sender];
85 
86         require(investor.generation != 0);
87         require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
88      
89     
90         require(investor.maxOutTimes == 0 || now - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
91         depositedAmountGross += msg.value;
92         bytes32 id = keccak256(abi.encodePacked(block.number, now, msg.sender, msg.value));
93         uint256 investmentValue = investor.depositedAmount + msg.value <= 10 ether ? msg.value : 10 ether - investor.depositedAmount;
94         if (investmentValue == 0) return;
95         Investment memory investment = Investment({ id: id, at: now, amount: investmentValue, investor: msg.sender });
96         investments[id] = investment;
97         processInvestments(id);
98         investmentIds.push(id);
99     }
100     
101     function processInvestments(bytes32 investmentId) internal {
102         Investment storage investment = investments[investmentId];
103         uint256 amount = investment.amount;
104         Investor storage investor = investors[investment.investor];
105         investor.investments.push(investmentId);
106         investor.depositedAmount += amount;
107         
108         addSellForParents(investment.investor, amount);
109         address presenterAddress = investor.presenter;
110         Investor storage presenter = investors[presenterAddress];
111         if (presenterAddress != 0) {
112             presenter.totalSell += amount;
113             presenter.sellThisMonth += amount;
114         }
115         if (presenter.depositedAmount >= 0.2 ether && !presenter.isDisabled) {
116             sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
117         }
118     }
119 
120     function addSellForParents(address investorAddress, uint256 amount) internal {
121         Investor memory investor = investors[investorAddress];
122         address currentParentAddress = investor.parent;
123         address currentInvestorAddress = investorAddress;
124         uint256 loopCount = investor.generation - 1;
125         for(uint256 i = 0; i < loopCount; i++) {
126             Investor storage parent = investors[currentParentAddress];
127             if (parent.leftChild == currentInvestorAddress) parent.leftSell += amount;
128             else parent.rightSell += amount;
129             uint256 incomeTilNow = getAllIncomeTilNow(currentParentAddress);
130             if (incomeTilNow > 3 * parent.depositedAmount) {
131                 payDailyIncomeForInvestor(currentParentAddress, 0);
132                 paySystemCommissionInvestor(currentParentAddress, 0);
133             }
134             currentInvestorAddress = currentParentAddress;
135             currentParentAddress = parent.parent;
136         }
137     }
138 
139     function sendEtherForInvestor(address investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
140         if (value == 0 || investorAddress == 0) return;
141         Investor storage investor = investors[investorAddress];
142         if (investor.reserveCommission > 0) {
143             bool isPass = investor.reserveCommission >= 3 * investor.depositedAmount;
144             uint256 reserveCommission = isPass ? investor.reserveCommission + value : investor.reserveCommission;
145             investor.reserveCommission = 0;
146             sendEtherForInvestor(investorAddress, reserveCommission, 4, 0, 0);
147             if (isPass) return;
148         }
149         uint256 withdrewAmount = investor.withdrewAmount;
150         uint256 depositedAmount = investor.depositedAmount;
151         uint256 amountToPay = value;
152         if (withdrewAmount + value >= 3 * depositedAmount) {
153             amountToPay = 3 * depositedAmount - withdrewAmount;
154             investor.reserveCommission = value - amountToPay;
155             if (reason != 2) investor.reserveCommission += getDailyIncomeForUser(investorAddress);
156             if (reason != 3) investor.reserveCommission += getUnpaidSystemCommission(investorAddress);
157             investor.maxOutTimes++;
158             investor.maxOutTimesInWeek++;
159             investor.depositedAmount = 0;
160             investor.withdrewAmount = 0;
161             investor.lastMaxOut = now;
162             investor.dailyIncomeWithrewAmount = 0;
163             emit MaxOut(investorAddress, investor.maxOutTimes, now);
164         } else {
165             investors[investorAddress].withdrewAmount += amountToPay;
166         }
167         if (amountToPay != 0) {
168             investorAddress.transfer(amountToPay / 100 * 90);
169             operationFund.transfer(amountToPay / 100 * 4);
170             developmentFund.transfer(amountToPay / 100 * 1);
171             reserveFund.transfer(amountToPay / 100 * 5);
172             bytes32 id = keccak256(abi.encodePacked(block.difficulty, now, investorAddress, amountToPay, reason));
173             Withdrawal memory withdrawal = Withdrawal({ id: id, at: now, amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
174             withdrawals[id] = withdrawal;
175             investor.withdrawals.push(id);
176             withdrawalIds.push(id);
177         }
178     }
179 
180 
181     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
182         Investor memory investor = investors[investorAddress];
183         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
184         uint256 withdrewAmount = investor.withdrewAmount;
185         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
186         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
187         return allIncomeNow;
188     }
189 
190 
191 
192     function getContractInfo() public view returns (address _admin, uint256 _depositedAmountGross, address _developmentFund, address _operationFund, address _reserveFund, address _emergencyAccount, bool _emergencyMode, address[] _investorAddresses, uint256 balance, uint256 _paySystemCommissionTimes, uint256 _maximumMaxOutInWeek) {
193         return (admin, depositedAmountGross, developmentFund, operationFund, reserveFund, emergencyAccount, emergencyMode, investorAddresses, address(this).balance, paySystemCommissionTimes, maximumMaxOutInWeek);
194     }
195     
196     function getContractTime() public view returns(uint256 _contractStartAt, uint256 _lastReset, uint256 _oneDay, uint256 _lastPayDailyIncome, uint256 _lastPaySystemCommission) {
197         return (contractStartAt, lastReset, ONE_DAY, lastPayDailyIncome, lastPaySystemCommission);
198     }
199     
200     function getInvestorRegularInfo(address investorAddress) public view returns (string email, uint256 generation, uint256 rightSell, uint256 leftSell, uint256 reserveCommission, uint256 depositedAmount, uint256 withdrewAmount, bool isDisabled) {
201         Investor memory investor = investors[investorAddress];
202         return (
203             investor.email,
204             investor.generation,
205             investor.rightSell,
206             investor.leftSell,
207             investor.reserveCommission,
208             investor.depositedAmount,
209             investor.withdrewAmount,
210             investor.isDisabled
211         );
212     }
213     
214     function getInvestorAccountInfo(address investorAddress) public view returns (uint256 maxOutTimes, uint256 maxOutTimesInWeek, uint256 totalSell, bytes32[] investorIds, uint256 dailyIncomeWithrewAmount, uint256 unpaidSystemCommission, uint256 unpaidDailyIncome) {
215         Investor memory investor = investors[investorAddress];
216         return (
217             investor.maxOutTimes,
218             investor.maxOutTimesInWeek,
219             investor.totalSell,
220             investor.investments,
221             investor.dailyIncomeWithrewAmount,
222             getUnpaidSystemCommission(investorAddress),
223             getDailyIncomeForUser(investorAddress)
224         ); 
225     }
226     
227     function getInvestorTreeInfo(address investorAddress) public view returns (address leftChild, address rightChild, address parent, address presenter, uint256 sellThisMonth, uint256 lastMaxOut) {
228         Investor memory investor = investors[investorAddress];
229         return (
230             investor.leftChild,
231             investor.rightChild,
232             investor.parent,
233             investor.presenter,
234             investor.sellThisMonth,
235             investor.lastMaxOut
236         );
237     }
238     
239     function getWithdrawalsByTime(address investorAddress, uint256 start, uint256 end)public view returns(bytes32[] ids, uint256[] ats, uint256[] amounts, address[] presentees, uint256[] reasons, uint256[] times, bytes32[] emails) {
240         ids = new bytes32[](withdrawalIds.length);
241         ats = new uint256[](withdrawalIds.length);
242         amounts = new uint256[](withdrawalIds.length);
243         emails = new bytes32[](withdrawalIds.length);
244         presentees = new address[](withdrawalIds.length);
245         reasons = new uint256[](withdrawalIds.length);
246         times = new uint256[](withdrawalIds.length);
247         uint256 index = 0;
248         for (uint256 i = 0; i < withdrawalIds.length; i++) {
249             bytes32 id = withdrawalIds[i];
250             if (withdrawals[id].at < start || withdrawals[id].at > end) continue;
251             if (investorAddress != 0 && withdrawals[id].investor != investorAddress) continue;
252             ids[index] = id; 
253             ats[index] = withdrawals[id].at;
254             amounts[index] = withdrawals[id].amount;
255             emails[index] = stringToBytes32(investors[withdrawals[id].investor].email);
256             reasons[index] = withdrawals[id].reason;
257             times[index] = withdrawals[id].times;
258             presentees[index] = withdrawals[id].presentee;
259             index++;
260         }
261         return (ids, ats, amounts, presentees, reasons, times, emails);
262     }
263     
264     function getInvestmentsByTime(address investorAddress, uint256 start, uint256 end)public view returns(bytes32[] ids, uint256[] ats, uint256[] amounts, bytes32[] emails) {
265         ids = new bytes32[](investmentIds.length);
266         ats = new uint256[](investmentIds.length);
267         amounts = new uint256[](investmentIds.length);
268         emails = new bytes32[](investmentIds.length);
269         uint256 index = 0;
270         for (uint256 i = 0; i < investmentIds.length; i++) {
271             bytes32 id = investmentIds[i];
272             if (investorAddress != 0 && investments[id].investor != investorAddress) continue;
273             if (investments[id].at < start || investments[id].at > end) continue;
274             ids[index] = id;
275             ats[index] = investments[id].at;
276             amounts[index] = investments[id].amount;
277             emails[index] = stringToBytes32(investors[investments[id].investor].email);
278             index++;
279         }
280         return (ids, ats, amounts, emails);
281     }
282 
283     function getNodesAddresses(address rootNodeAddress) internal view returns(address[]){
284         uint256 maxLength = investorAddresses.length;
285         address[] memory nodes = new address[](maxLength);
286         nodes[0] = rootNodeAddress;
287         uint256 processIndex = 0;
288         uint256 nextIndex = 1;
289         while (processIndex != nextIndex) {
290             Investor memory currentInvestor = investors[nodes[processIndex++]];
291             if (currentInvestor.leftChild != 0) nodes[nextIndex++] = currentInvestor.leftChild;
292             if (currentInvestor.rightChild != 0) nodes[nextIndex++] = currentInvestor.rightChild;
293         }
294         return nodes;
295     }
296 
297     function stringToBytes32(string source) internal pure returns (bytes32 result) {
298         bytes memory tempEmptyStringTest = bytes(source);
299         if (tempEmptyStringTest.length == 0) return 0x0;
300         assembly { result := mload(add(source, 32)) }
301     }
302 
303     function getInvestorTree(address rootInvestor) public view returns(address[] nodeInvestors, bytes32[] emails, uint256[] leftSells, uint256[] rightSells, address[] parents, uint256[] generations, uint256[] deposits){
304         nodeInvestors = getNodesAddresses(rootInvestor);
305         uint256 length = nodeInvestors.length;
306         leftSells = new uint256[](length);
307         rightSells = new uint256[](length);
308         emails = new bytes32[] (length);
309         parents = new address[] (length);
310         generations = new uint256[] (length);
311         deposits = new uint256[] (length);
312         for (uint256 i = 0; i < length; i++) {
313             Investor memory investor = investors[nodeInvestors[i]];
314             parents[i] = investor.parent;
315             string memory email = investor.email;
316             emails[i] = stringToBytes32(email);
317             leftSells[i] = investor.leftSell;
318             rightSells[i] = investor.rightSell;
319             generations[i] = investor.generation;
320             deposits[i] = investor.depositedAmount;
321         }
322         return (nodeInvestors, emails, leftSells, rightSells, parents, generations, deposits);
323     }
324 
325     function getListInvestor() public view returns (address[] nodeInvestors, bytes32[] emails, uint256[] unpaidSystemCommissions, uint256[] unpaidDailyIncomes, uint256[] depositedAmounts, uint256[] withdrewAmounts, bool[] isDisableds) {
326         uint256 length = investorAddresses.length;
327         unpaidSystemCommissions = new uint256[](length);
328         unpaidDailyIncomes = new uint256[](length);
329         emails = new bytes32[] (length);
330         depositedAmounts = new uint256[] (length);
331         unpaidSystemCommissions = new uint256[] (length);
332         isDisableds = new bool[] (length);
333         unpaidDailyIncomes = new uint256[] (length); 
334         withdrewAmounts = new uint256[](length);
335         for (uint256 i = 0; i < length; i++) {
336             Investor memory investor = investors[investorAddresses[i]];
337             depositedAmounts[i] = investor.depositedAmount;
338             string memory email = investor.email;
339             emails[i] = stringToBytes32(email);
340             withdrewAmounts[i] = investor.withdrewAmount;
341             isDisableds[i] = investor.isDisabled;
342             unpaidSystemCommissions[i] = getUnpaidSystemCommission(investorAddresses[i]);
343             unpaidDailyIncomes[i] = getDailyIncomeForUser(investorAddresses[i]);
344         }
345         return (investorAddresses, emails, unpaidSystemCommissions, unpaidDailyIncomes, depositedAmounts, withdrewAmounts, isDisableds);
346     }
347     
348    
349 
350     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, string presenteeEmail, bool isLeft) public mustBeAdmin {
351         Investor storage presenter = investors[presenterAddress];
352         Investor storage parent = investors[parentAddress];
353         if (investorAddresses.length != 0) {
354             require(presenter.generation != 0);
355             require(parent.generation != 0);
356             if (isLeft) {
357                 require(parent.leftChild == 0); 
358             } else {
359                 require(parent.rightChild == 0); 
360             }
361         }
362         
363         if (presenter.generation != 0) presenter.presentees.push(presenteeAddress);
364         Investor memory investor = Investor({
365             email: presenteeEmail,
366             parent: parentAddress,
367             leftChild: 0,
368             rightChild: 0,
369             presenter: presenterAddress,
370             generation: parent.generation + 1,
371             presentees: new address[](0),
372             depositedAmount: 0,
373             withdrewAmount: 0,
374             isDisabled: false,
375             lastMaxOut: now,
376             maxOutTimes: 0,
377             maxOutTimesInWeek: 0,
378             totalSell: 0,
379             sellThisMonth: 0,
380             investments: new bytes32[](0),
381             withdrawals: new bytes32[](0),
382             rightSell: 0,
383             leftSell: 0,
384             reserveCommission: 0,
385             dailyIncomeWithrewAmount: 0
386         });
387         investors[presenteeAddress] = investor;
388        
389         investorAddresses.push(presenteeAddress);
390         if (parent.generation == 0) return;
391         if (isLeft) {
392             parent.leftChild = presenteeAddress;
393         } else {
394             parent.rightChild = presenteeAddress;
395         }
396     }
397 
398   
399 
400     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
401         Investor memory investor = investors[investorAddress];
402         uint256 investmentLength = investor.investments.length;
403         uint256 dailyIncome = 0;
404         for (uint256 i = 0; i < investmentLength; i++) {
405             Investment memory investment = investments[investor.investments[i]];
406             if (investment.at < investor.lastMaxOut) continue; 
407             if (now - investment.at >= ONE_DAY) {
408                 uint256 numberOfDay = (now - investment.at) / ONE_DAY;
409                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
410                 dailyIncome = totalDailyIncome + dailyIncome;
411             }
412         }
413         return dailyIncome - investor.dailyIncomeWithrewAmount;
414     }
415     
416     function payDailyIncomeForInvestor(address investorAddress, uint256 times) public mustBeAdmin {
417         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
418         if (investors[investorAddress].isDisabled) return;
419         investors[investorAddress].dailyIncomeWithrewAmount += dailyIncome;
420         sendEtherForInvestor(investorAddress, dailyIncome, 2, 0, times);
421     }
422     
423     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
424         require(from >= 0 && to < investorAddresses.length);
425         for(uint256 i = from; i <= to; i++) {
426             payDailyIncomeForInvestor(investorAddresses[i], payDailyIncomeTimes);
427         }
428     }
429     
430   
431     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
432         if (totalSell < 30 ether) return 0;
433         if (totalSell < 60 ether) return 1;
434         if (totalSell < 90 ether) return 2;
435         if (totalSell < 120 ether) return 3;
436         if (totalSell < 150 ether) return 4;
437         return 5;
438     }
439     
440     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
441         if (sellThisMonth < 2 ether) return 0;
442         if (sellThisMonth < 4 ether) return 1;
443         if (sellThisMonth < 6 ether) return 2;
444         if (sellThisMonth < 8 ether) return 3;
445         if (sellThisMonth < 10 ether) return 4;
446         return 5;
447     }
448     
449     function getDepositLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
450         if (sellThisMonth < 2 ether) return 0;
451         if (sellThisMonth < 4 ether) return 1;
452         if (sellThisMonth < 6 ether) return 2;
453         if (sellThisMonth < 8 ether) return 3;
454         if (sellThisMonth < 10 ether) return 4;
455         return 5;
456     }
457     
458     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
459         uint256 totalSellLevel = getTotalSellLevel(totalSell);
460         uint256 depLevel = getDepositLevel(depositedAmount);
461         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
462         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
463         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
464         return minLevel * 2;
465     }
466 
467     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
468         Investor memory investor = investors[investorAddress];
469         uint256 depositedAmount = investor.depositedAmount;
470         uint256 totalSell = investor.totalSell;
471         uint256 leftSell = investor.leftSell;
472         uint256 rightSell = investor.rightSell;
473         uint256 sellThisMonth = investor.sellThisMonth;
474         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
475         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
476         return commission;
477     }
478     
479     function paySystemCommissionInvestor(address investorAddress, uint256 times) public mustBeAdmin {
480         Investor storage investor = investors[investorAddress];
481         if (investor.isDisabled) return;
482         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
483         if (paySystemCommissionTimes > 3 && times != 0) {
484             investor.rightSell = 0;
485             investor.leftSell = 0;
486         } else if (investor.rightSell >= investor.leftSell) {
487             investor.rightSell = investor.rightSell - investor.leftSell;
488             investor.leftSell = 0;
489         } else {
490             investor.leftSell = investor.leftSell - investor.rightSell;
491             investor.rightSell = 0;
492         }
493         if (times != 0) investor.sellThisMonth = 0;
494         sendEtherForInvestor(investorAddress, systemCommission, 3, 0, times);
495     }
496 
497     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
498          require(from >= 0 && to < investorAddresses.length);
499         // change 1 to 30
500         if (now <= 30 * ONE_DAY + contractStartAt) return;
501         for(uint256 i = from; i <= to; i++) {
502             paySystemCommissionInvestor(investorAddresses[i], paySystemCommissionTimes);
503         }
504      }
505 
506 
507     function finishPayDailyIncome() public mustBeAdmin {
508         lastPayDailyIncome = now;
509         payDailyIncomeTimes++;
510     }
511     
512     function finishPaySystemCommission() public mustBeAdmin {
513         lastPaySystemCommission = now;
514         paySystemCommissionTimes++;
515     }
516 
517 
518     function turnOnEmergencyMode() public mustBeAdmin { emergencyMode = true; }
519 
520     function cashOutEmergencyMode() public {
521         require(msg.sender == emergencyAccount);
522         msg.sender.transfer(address(this).balance);
523     }
524     
525  
526     
527     function resetGame(address[] yesInvestors, address[] noInvestors) public mustBeAdmin {
528         lastReset = now;
529         uint256 yesInvestorsLength = yesInvestors.length;
530         for (uint256 i = 0; i < yesInvestorsLength; i++) {
531             address yesInvestorAddress = yesInvestors[i];
532             Investor storage yesInvestor = investors[yesInvestorAddress];
533             if (yesInvestor.maxOutTimes > 0 || (yesInvestor.withdrewAmount >= yesInvestor.depositedAmount && yesInvestor.withdrewAmount != 0)) {
534                 yesInvestor.lastMaxOut = now;
535                 yesInvestor.depositedAmount = 0;
536                 yesInvestor.withdrewAmount = 0;
537                 yesInvestor.dailyIncomeWithrewAmount = 0;
538             }
539             yesInvestor.reserveCommission = 0;
540             yesInvestor.rightSell = 0;
541             yesInvestor.leftSell = 0;
542             yesInvestor.totalSell = 0;
543             yesInvestor.sellThisMonth = 0;
544         }
545         uint256 noInvestorsLength = noInvestors.length;
546         for (uint256 j = 0; j < noInvestorsLength; j++) {
547             address noInvestorAddress = noInvestors[j];
548             Investor storage noInvestor = investors[noInvestorAddress];
549             if (noInvestor.maxOutTimes > 0 || (noInvestor.withdrewAmount >= noInvestor.depositedAmount && noInvestor.withdrewAmount != 0)) {
550                 noInvestor.isDisabled = true;
551                 noInvestor.reserveCommission = 0;
552                 noInvestor.lastMaxOut = now;
553                 noInvestor.depositedAmount = 0;
554                 noInvestor.withdrewAmount = 0;
555                 noInvestor.dailyIncomeWithrewAmount = 0;
556             }
557             noInvestor.reserveCommission = 0;
558             noInvestor.rightSell = 0;
559             noInvestor.leftSell = 0;
560             noInvestor.totalSell = 0;
561             noInvestor.sellThisMonth = 0;
562         }
563     }
564 
565     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
566         require(percent <= 50);
567         require(from >= 0 && to < investorAddresses.length);
568         for (uint256 i = from; i <= to; i++) {
569             address investorAddress = investorAddresses[i];
570             Investor storage investor = investors[investorAddress];
571             if (investor.maxOutTimes > 0) continue;
572             if (investor.isDisabled) continue;
573             uint256 depositedAmount = investor.depositedAmount;
574             uint256 withdrewAmount = investor.withdrewAmount;
575             if (withdrewAmount >= depositedAmount / 2) continue;
576             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, 0, 0);
577         }
578     }
579     
580     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = now; }
581 
582     function getInvestor(address user, uint256 totalSell, uint256 sellThisMonth, uint256 rightSell, uint256 leftSell) public mustBeAdmin {
583         Investor storage investor = investors[user];
584         require(investor.generation > 0);
585         investor.totalSell = totalSell;
586         investor.sellThisMonth = sellThisMonth;
587         investor.rightSell = rightSell;
588         investor.leftSell = leftSell;
589     }
590 
591     function getPercentToMaxOut(address investorAddress) public view returns(uint256) {
592         uint256 depositedAmount = investors[investorAddress].depositedAmount;
593         if (depositedAmount == 0) return 0;
594         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
595         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
596         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
597         uint256 percent = 100 * (unpaidSystemCommissions + unpaidDailyIncomes + withdrewAmount) / depositedAmount;
598         return percent;
599     }
600 
601     function payToReachMaxOut(address investorAddress) public mustBeAdmin{
602         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
603         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
604         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
605         uint256 depositedAmount = investors[investorAddress].depositedAmount;
606         uint256 reserveCommission = investors[investorAddress].reserveCommission;
607         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
608         investors[investorAddress].reserveCommission = 0;
609         sendEtherForInvestor(investorAddress, reserveCommission, 4, 0, 0);
610         payDailyIncomeForInvestor(investorAddress, 0);
611         paySystemCommissionInvestor(investorAddress, 0);
612     }
613 
614     function getMaxOutUser() public view returns (address[] nodeInvestors, uint256[] unpaidSystemCommissions, uint256[] unpaidDailyIncomes, uint256[] depositedAmounts, uint256[] withdrewAmounts, uint256[] reserveCommissions, bool[] isDisableds) {
615         uint256 length = investorAddresses.length;
616         unpaidSystemCommissions = new uint256[](length);
617         unpaidDailyIncomes = new uint256[](length);
618         depositedAmounts = new uint256[] (length);
619         unpaidSystemCommissions = new uint256[] (length);
620         reserveCommissions = new uint256[] (length);
621         unpaidDailyIncomes = new uint256[] (length); 
622         withdrewAmounts = new uint256[](length);
623         isDisableds = new bool[](length);
624         for (uint256 i = 0; i < length; i++) {
625             Investor memory investor = investors[investorAddresses[i]];
626             depositedAmounts[i] = investor.depositedAmount;
627             withdrewAmounts[i] = investor.withdrewAmount;
628             reserveCommissions[i] = investor.reserveCommission;
629             unpaidSystemCommissions[i] = getUnpaidSystemCommission(investorAddresses[i]);
630             unpaidDailyIncomes[i] = getDailyIncomeForUser(investorAddresses[i]);
631             isDisableds[i] = investor.isDisabled;
632         }
633         return (investorAddresses, unpaidSystemCommissions, unpaidDailyIncomes, depositedAmounts, withdrewAmounts, reserveCommissions, isDisableds);
634     }
635 
636     function getLazyInvestor() public view returns (bytes32[] emails, address[] addresses, uint256[] lastDeposits, uint256[] depositedAmounts, uint256[] sellThisMonths, uint256[] totalSells, uint256[] maxOuts) {
637         uint256 length = investorAddresses.length;
638         emails = new bytes32[] (length);
639         lastDeposits = new uint256[] (length);
640         addresses = new address[](length);
641         depositedAmounts = new uint256[] (length);
642         sellThisMonths = new uint256[] (length);
643         totalSells = new uint256[](length);
644         maxOuts = new uint256[](length);
645         uint256 index = 0;
646         for (uint256 i = 0; i < length; i++) {
647             Investor memory investor = investors[investorAddresses[i]];
648             if (investor.withdrewAmount > investor.depositedAmount) continue;
649             lastDeposits[index] = investor.investments.length != 0 ? investments[investor.investments[investor.investments.length - 1]].at : 0;
650             emails[index] = stringToBytes32(investor.email);
651             addresses[index] = investorAddresses[i];
652             depositedAmounts[index] = investor.depositedAmount;
653             sellThisMonths[index] = investor.sellThisMonth;
654             totalSells[index] = investor.totalSell;
655             maxOuts[index] = investor.maxOutTimes;
656             index++;
657         }
658         return (emails, addresses, lastDeposits, depositedAmounts, sellThisMonths, totalSells, maxOuts);
659     }
660   
661     function resetMaxOutInWeek() public mustBeAdmin {
662         uint256 length = investorAddresses.length;
663         for (uint256 i = 0; i < length; i++) {
664             address investorAddress = investorAddresses[i];
665             investors[investorAddress].maxOutTimesInWeek = 0;
666         }
667     }
668     
669     function setMaximumMaxOutInWeek(uint256 maximum) public mustBeAdmin{ maximumMaxOutInWeek = maximum; }
670 
671     function disableInvestor(address investorAddress) public mustBeAdmin {
672         Investor storage investor = investors[investorAddress];
673         investor.isDisabled = true;
674     }
675     
676     function enableInvestor(address investorAddress) public mustBeAdmin {
677         Investor storage investor = investors[investorAddress];
678         investor.isDisabled = false;
679     }
680     
681     function donate() payable public { depositedAmountGross += msg.value; }
682 }