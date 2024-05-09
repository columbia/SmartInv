1 pragma solidity 0.4.25;
2 
3 library Math {
4     function min(uint a, uint b) internal pure returns(uint) {
5         if (a > b) {
6             return b;
7     }
8         return a;
9     }
10 }
11 
12 
13 library Zero {
14     function requireNotZero(address addr) internal pure {
15         require(addr != address(0), "require not zero address");
16     }
17 
18     function requireNotZero(uint val) internal pure {
19         require(val != 0, "require not zero value");
20     }
21 
22     function notZero(address addr) internal pure returns(bool) {
23         return !(addr == address(0));
24     }
25 
26     function isZero(address addr) internal pure returns(bool) {
27         return addr == address(0);
28     }
29 
30     function isZero(uint a) internal pure returns(bool) {
31         return a == 0;
32     }
33 
34     function notZero(uint a) internal pure returns(bool) {
35         return a != 0;
36     }
37 }
38 
39 
40 library Percent {
41     struct percent {
42       uint num;
43       uint den;
44     }
45 
46     // storage
47     function mul(percent storage p, uint a) internal view returns (uint) {
48       if (a == 0) {
49         return 0;
50       }
51       return a*p.num/p.den;
52     }
53 
54     function div(percent storage p, uint a) internal view returns (uint) {
55       return a/p.num*p.den;
56     }
57 
58     function sub(percent storage p, uint a) internal view returns (uint) {
59       uint b = mul(p, a);
60       if (b >= a) {
61         return 0;
62       }
63       return a - b;
64     }
65 
66     function add(percent storage p, uint a) internal view returns (uint) {
67       return a + mul(p, a);
68     }
69 
70     function toMemory(percent storage p) internal view returns (Percent.percent memory) {
71       return Percent.percent(p.num, p.den);
72     }
73 
74     // memory
75     function mmul(percent memory p, uint a) internal pure returns (uint) {
76       if (a == 0) {
77         return 0;
78       }
79       return a*p.num/p.den;
80     }
81 
82     function mdiv(percent memory p, uint a) internal pure returns (uint) {
83       return a/p.num*p.den;
84     }
85 
86     function msub(percent memory p, uint a) internal pure returns (uint) {
87       uint b = mmul(p, a);
88       if (b >= a) {
89         return 0;
90       }
91       return a - b;
92     }
93 
94     function madd(percent memory p, uint a) internal pure returns (uint) {
95       return a + mmul(p, a);
96     }
97 }
98 
99 
100 library Address {
101     function toAddress(bytes source) internal pure returns(address addr) {
102       assembly { addr := mload(add(source,0x14)) }
103       return addr;
104     }
105 
106     function isNotContract(address addr) internal view returns(bool) {
107       uint length;
108       assembly { length := extcodesize(addr) }
109       return length == 0;
110     }
111 }
112 
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that revert on error
117  */
118 library SafeMath {
119 
120     /**
121     * @dev Multiplies two numbers, reverts on overflow.
122     */
123     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
124       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125       // benefit is lost if 'b' is also tested.
126       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
127         if (_a == 0) {
128           return 0;
129         }
130 
131         uint256 c = _a * _b;
132         require(c / _a == _b);
133 
134         return c;
135     }
136 
137     /**
138     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
139     */
140     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
141         require(_b > 0); // Solidity only automatically asserts when dividing by 0
142         uint256 c = _a / _b;
143         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
150     */
151     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
152         require(_b <= _a);
153         uint256 c = _a - _b;
154 
155         return c;
156     }
157 
158     /**
159     * @dev Adds two numbers, reverts on overflow.
160     */
161     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
162       uint256 c = _a + _b;
163       require(c >= _a);
164 
165       return c;
166     }
167 
168     /**
169     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
170     * reverts when dividing by zero.
171     */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         require(b != 0);
174         return a % b;
175     }
176 }
177 
178 
179 contract Accessibility {
180     address private owner;
181     modifier onlyOwner() {
182         require(msg.sender == owner, "Access denied");
183         _;
184     }
185 
186     constructor() public {
187       owner = msg.sender;
188     }
189 
190     function disown() internal {
191       delete owner;
192     }
193 }
194 
195 contract InvestorsStorage is Accessibility {
196     using SafeMath for uint;
197     struct Investor {
198         uint investment;
199         uint paymentTime;
200         uint maxPayout; 
201         bool exit;
202     }
203 
204     uint public size;
205 
206     mapping (address => Investor) private investors;
207 
208     function isInvestor(address addr) public view returns (bool) {
209       return investors[addr]. investment > 0;
210     }
211 
212     function investorInfo(address addr) public view returns(uint investment, uint paymentTime,uint maxPayout,bool exit) {
213         investment = investors[addr].investment;
214         paymentTime = investors[addr].paymentTime;
215         maxPayout = investors[addr].maxPayout;
216         exit = investors[addr].exit;
217     }
218 
219     function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
220         // initialize new investor to investment and maxPayout = 2x investment
221         Investor storage inv = investors[addr];
222         if (inv.investment != 0 || investment == 0) {
223             return false;
224         }
225         inv.exit = false;
226         inv.investment = investment; 
227         inv.maxPayout = investment.mul(2); 
228         inv.paymentTime = paymentTime;
229         size++;
230         return true;
231     }
232 
233     function addInvestment(address addr, uint investment,uint dividends) public onlyOwner returns (bool) {
234         if (investors[addr].investment == 0) {
235             return false;
236         }
237         investors[addr].investment += investment;
238 
239         // Update maximum payout exlude dividends
240         investors[addr].maxPayout += (investment-dividends).mul(2);
241         return true;
242     }
243 
244     function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
245         if(investors[addr].exit){
246             return true;
247         }
248         if (investors[addr].investment == 0) {
249             return false;
250         }
251         investors[addr].paymentTime = paymentTime;
252         return true;
253     }
254     function investorExit(address addr)  public onlyOwner returns (bool){
255         investors[addr].exit = true;
256         investors[addr].maxPayout = 0;
257         investors[addr].investment = 0;
258     }
259     function payout(address addr, uint dividend) public onlyOwner returns (uint) {
260         uint dividendToPay = 0;
261         if(investors[addr].maxPayout <= dividend){
262             dividendToPay = investors[addr].maxPayout;
263             investorExit(addr);
264         } else{
265             dividendToPay = dividend;
266             investors[addr].maxPayout -= dividend;
267       }
268         return dividendToPay;
269     }
270 }
271 
272 
273 library RapidGrowthProtection {
274   using RapidGrowthProtection for rapidGrowthProtection;
275 
276   struct rapidGrowthProtection {
277     uint startTimestamp;
278     uint maxDailyTotalInvestment;
279     uint8 activityDays;
280     mapping(uint8 => uint) dailyTotalInvestment;
281   }
282 
283   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
284     uint day = rgp.currDay();
285     if (day == 0 || day > rgp.activityDays) {
286       return 0;
287     }
288     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
289       return 0;
290     }
291     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
292   }
293 
294     function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
295         uint day = rgp.currDay();
296         return day != 0 && day <= rgp.activityDays;
297     }
298 
299   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
300     uint day = rgp.currDay();
301     if (day == 0 || day > rgp.activityDays) {
302       return false;
303     }
304     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
305       return false;
306     }
307     rgp.dailyTotalInvestment[uint8(day)] += investment;
308     return true;
309   }
310 
311   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
312     rgp.startTimestamp = timestamp;
313 
314     // restart
315     for (uint8 i = 1; i <= rgp.activityDays; i++) {
316       if (rgp.dailyTotalInvestment[i] != 0) {
317         delete rgp.dailyTotalInvestment[i];
318       }
319     }
320   }
321 
322   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
323     if (rgp.startTimestamp > now) {
324       return 0;
325     }
326     day = (now - rgp.startTimestamp) / 24 hours + 1; // +1 for skipping zero day
327   }
328 }
329 
330 
331 library BonusPool {
332     using BonusPool for bonusPool;
333     struct bonusLevel {
334         uint bonusAmount;
335         bool triggered;
336         uint triggeredTimestamp; 
337         bool bonusSet;
338     }
339 
340     struct bonusPool {
341         uint8 nextLevelToTrigger;
342         mapping(uint8 => bonusLevel) bonusLevels;
343     }
344 
345     function setBonus(bonusPool storage self,uint8 level,uint amount) internal {
346         require(!self.bonusLevels[level].bonusSet,"Bonus already set");
347         self.bonusLevels[level].bonusAmount = amount;
348         self.bonusLevels[level].bonusSet = true;
349         self.bonusLevels[level].triggered = false;
350     }
351     
352     function hasMetBonusTriggerLevel(bonusPool storage self) internal returns(bool){
353         bonusLevel storage nextBonusLevel = self.bonusLevels[self.nextLevelToTrigger];
354         if(address(this).balance >= nextBonusLevel.bonusAmount){
355             if(nextBonusLevel.triggered){
356                 self.goToNextLevel();
357                 return false;
358             }
359             return true;
360         }
361         return false;
362     }
363 
364     function prizeToPool(bonusPool storage self) internal returns(uint){
365         return self.bonusLevels[self.nextLevelToTrigger].bonusAmount;
366     }
367 
368     function goToNextLevel(bonusPool storage self) internal {
369         self.bonusLevels[self.nextLevelToTrigger].triggered = true;
370         self.nextLevelToTrigger += 1;
371     }
372 }
373 
374 
375 
376 
377 
378 contract Myethsss is Accessibility {
379     using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
380     using BonusPool for BonusPool.bonusPool;
381     using Percent for Percent.percent;
382     using SafeMath for uint;
383     using Math for uint;
384 
385     // easy read for investors
386     using Address for *;
387     using Zero for *;
388 
389     RapidGrowthProtection.rapidGrowthProtection private m_rgp;
390     BonusPool.bonusPool private m_bonusPool;
391     mapping(address => bool) private m_referrals;
392     InvestorsStorage private m_investors;
393     uint totalRealBalance;
394     // automatically generates getters
395     uint public constant minInvesment = 0.1 ether; //       0.1 eth
396     uint public constant maxBalance = 366e5 ether; // 36 600 000 eth
397     address public advertisingAddress;
398     address public adminsAddress;
399     address public riskAddress;
400     address public bonusAddress;
401     uint public investmentsNumber;
402     uint public waveStartup;
403 
404   // percents
405     Percent.percent private m_1_percent = Percent.percent(1, 100);           //   1/100  *100% = 1%
406     Percent.percent private m_1_66_percent = Percent.percent(166, 10000);           //   166/10000*100% = 1.66%
407     Percent.percent private m_2_66_percent = Percent.percent(266, 10000);    // 266/10000*100% = 2.66%
408     Percent.percent private m_6_66_percent = Percent.percent(666, 10000);    // 666/10000*100% = 6.66% refer bonus
409     Percent.percent private m_adminsPercent = Percent.percent(5, 100);       //   5/100  *100% = 5%
410     Percent.percent private m_advertisingPercent = Percent.percent(5, 100); // 5/1000  *100% = 5%
411     Percent.percent private m_riskPercent = Percent.percent(5, 100); // 5/1000  *100% = 5%
412     Percent.percent private m_bonusPercent = Percent.percent(666, 10000);           //   666/10000  *100% = 6.66%
413 
414     modifier balanceChanged {
415         _;
416     }
417 
418     modifier notFromContract() {
419         require(msg.sender.isNotContract(), "only externally accounts");
420         _;
421     }
422 
423     constructor() public {
424         adminsAddress = msg.sender;
425         advertisingAddress = msg.sender;
426         riskAddress=msg.sender;
427         bonusAddress = msg.sender;
428         nextWave();
429     }
430 
431     function() public payable {
432         if (msg.value.isZero()) {
433             getMyDividends();
434             return;
435         }
436         doInvest(msg.data.toAddress());
437     }
438 
439     function doDisown() public onlyOwner {
440         disown();
441     }
442 // uint timestamp
443     function init() public onlyOwner {
444         m_rgp.startTimestamp = now + 1;
445         m_rgp.maxDailyTotalInvestment = 5000 ether;
446         m_rgp.activityDays = 21;
447         // Set bonus pool tier
448         m_bonusPool.setBonus(0,3000 ether);
449         m_bonusPool.setBonus(1,6000 ether);
450         m_bonusPool.setBonus(2,10000 ether);
451         m_bonusPool.setBonus(3,15000 ether);
452         m_bonusPool.setBonus(4,20000 ether);
453         m_bonusPool.setBonus(5,25000 ether);
454         m_bonusPool.setBonus(6,30000 ether);
455         m_bonusPool.setBonus(7,35000 ether);
456         m_bonusPool.setBonus(8,40000 ether);
457         m_bonusPool.setBonus(9,45000 ether);
458         m_bonusPool.setBonus(10,50000 ether);
459         m_bonusPool.setBonus(11,60000 ether);
460         m_bonusPool.setBonus(12,70000 ether);
461         m_bonusPool.setBonus(13,80000 ether);
462         m_bonusPool.setBonus(14,90000 ether);
463         m_bonusPool.setBonus(15,100000 ether);
464         m_bonusPool.setBonus(16,150000 ether);
465         m_bonusPool.setBonus(17,200000 ether);
466         m_bonusPool.setBonus(18,500000 ether);
467         m_bonusPool.setBonus(19,1000000 ether);
468 
469 
470 
471 
472     }
473 
474     function getBonusAmount(uint8 level) public view returns(uint){
475         return m_bonusPool.bonusLevels[level].bonusAmount;
476         
477     }
478     function doBonusPooling() public onlyOwner {
479         require(m_bonusPool.hasMetBonusTriggerLevel(),"Has not met next bonus requirement");
480         bonusAddress.transfer(m_bonusPercent.mul(m_bonusPool.prizeToPool()));
481         m_bonusPool.goToNextLevel();
482     }
483 
484     function setAdvertisingAddress(address addr) public onlyOwner {
485         addr.requireNotZero();
486         advertisingAddress = addr;
487     }
488 
489     function setAdminsAddress(address addr) public onlyOwner {
490         addr.requireNotZero();
491         adminsAddress = addr;
492     }
493 
494     function setRiskAddress(address addr) public onlyOwner{
495         addr.requireNotZero();
496         riskAddress=addr;
497     }
498 
499     function setBonusAddress(address addr) public onlyOwner {
500         addr.requireNotZero();
501         bonusAddress = addr;
502     }
503 
504 
505     function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
506         investment = m_rgp.maxInvestmentAtNow();
507     }
508 
509     function investorsNumber() public view returns(uint) {
510         return m_investors.size();
511     }
512 
513     function balanceETH() public view returns(uint) {
514         return address(this).balance;
515     }
516 
517     function percent1() public view returns(uint numerator, uint denominator) {
518         (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
519     }
520 
521     function percent2() public view returns(uint numerator, uint denominator) {
522         (numerator, denominator) = (m_1_66_percent.num, m_1_66_percent.den);
523     }
524 
525     function percent3_33() public view returns(uint numerator, uint denominator) {
526         (numerator, denominator) = (m_2_66_percent.num, m_2_66_percent.den);
527     }
528 
529     function advertisingPercent() public view returns(uint numerator, uint denominator) {
530         (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
531     }
532 
533     function adminsPercent() public view returns(uint numerator, uint denominator) {
534         (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
535     }
536     function riskPercent() public view returns(uint numerator, uint denominator) {
537         (numerator, denominator) = (m_riskPercent.num, m_riskPercent.den);
538     }
539 
540     function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime,uint maxPayout,bool exit, bool isReferral) {
541         (investment, paymentTime,maxPayout,exit) = m_investors.investorInfo(investorAddr);
542         isReferral = m_referrals[investorAddr];
543     }
544 
545     function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
546         dividends = calcDividends(investorAddr);
547     }
548 
549     function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
550         Percent.percent memory p = dailyPercent();
551         (numerator, denominator) = (p.num, p.den);
552     }
553 
554     function refBonusPercentAtNow() public view returns(uint numerator, uint denominator) {
555         Percent.percent memory p = refBonusPercent();
556         (numerator, denominator) = (p.num, p.den);
557     }
558 
559     function getMyDividends() public notFromContract balanceChanged {
560       // calculate dividends
561         uint dividends = calcDividends(msg.sender);
562         require (dividends.notZero(), "cannot pay zero dividends");
563         // deduct payout from max
564         dividends = m_investors.payout(msg.sender,dividends);
565             // update investor payment timestamp
566         assert(m_investors.setPaymentTime(msg.sender, now));
567       // check enough eth - goto next wave if needed
568         if (address(this).balance <= dividends) {
569                 // nextWave();
570             dividends = address(this).balance;
571         }
572 
573       // transfer dividends to investor
574         msg.sender.transfer(dividends);
575     }
576 
577     function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
578         uint investment = msg.value;
579         uint receivedEther = msg.value;
580         require(investment >= minInvesment, "investment must be >= minInvesment");
581         require(address(this).balance <= maxBalance, "the contract eth balance limit");
582 
583         if (m_rgp.isActive()) {
584         // use Rapid Growth Protection if needed
585             uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
586             rpgMaxInvest.requireNotZero();
587             investment = Math.min(investment, rpgMaxInvest);
588             assert(m_rgp.saveInvestment(investment));
589 
590       } 
591 
592       // send excess of ether if needed
593         if (receivedEther > investment) {
594             uint excess = receivedEther - investment;
595             msg.sender.transfer(excess);
596             receivedEther = investment;
597       }
598 
599       // commission
600         advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
601         adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
602         riskAddress.transfer(m_riskPercent.mul(receivedEther));
603 
604         bool senderIsInvestor = m_investors.isInvestor(msg.sender);
605 
606       // ref system works only once and only on first invest
607         if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
608             referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
609 
610             m_referrals[msg.sender] = true;
611             // add referral bonus to referee's investments and pay investor's refer bonus
612             uint refBonus = refBonusPercent().mmul(investment);
613             // Investment increase 2.66%
614             uint refBonuss = refBonusPercentt().mmul(investment);
615             // ADD referee bonus to referee investment and maxinvestment
616             investment += refBonuss;
617             // PAY referer refer bonus directly
618             referrerAddr.transfer(refBonus);                                    
619             // emit LogNewReferral(msg.sender, referrerAddr, now, refBonus);
620         }
621 
622       // automatic reinvest - prevent burning dividends
623         uint dividends = calcDividends(msg.sender);
624         if (senderIsInvestor && dividends.notZero()) {
625             investment += dividends;
626         }
627 
628         if (senderIsInvestor) {
629                 // update existing investor
630             assert(m_investors.addInvestment(msg.sender, investment, dividends));
631             assert(m_investors.setPaymentTime(msg.sender, now));
632         } else {
633             // create new investor
634             assert(m_investors.newInvestor(msg.sender, investment, now));
635         }
636 
637         investmentsNumber++;
638     }
639 
640     function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
641         (uint investment, uint paymentTime,uint maxPayout,bool exit) = m_investors.investorInfo(investorAddr);
642         return InvestorsStorage.Investor(investment, paymentTime,maxPayout,exit);
643     }
644 
645     function calcDividends(address investorAddr) internal view returns(uint dividends) {
646         InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
647 
648       // safe gas if dividends will be 0,  
649         if (investor.investment.isZero()
650         // || now.sub(investor.paymentTime) < 1 minutes
651         ) {
652             return 0;
653         }
654 
655         // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
656         // if daily percent is X, then 10min percent = X / (24h / 10 min) = X / 144
657 
658         // and we must to get numbers of 10 min interval after investor got payment:
659         // (now - investor.paymentTime) / 10min
660 
661         // finaly calculate dividends = ((now - investor.paymentTime) / 10min) * (X * investor.investment)  / 144)
662         Percent.percent memory p = dailyPercent();
663         // dividends = ((now - investor.paymentTime) / 10 minutes) * (p.mmul(investor.investment) / 144);
664         dividends = ((now - investor.paymentTime) / 10 minutes) * (p.mmul(investor.investment) / 144);
665       //  dividends =  p.mmul(investor.investment);
666     }
667 
668     function dailyPercent() internal view returns(Percent.percent memory p) {
669         uint balance = address(this).balance;
670 
671       // (2) 1.66% if balance < 50 000 ETH
672     
673       // (1) 1% if >50 000 ETH
674 
675         if (balance < 50000 ether) {
676             p = m_1_66_percent.toMemory();    // (2)
677         } else {
678             p = m_1_percent.toMemory();    // (1)
679         }
680     }
681 
682     function refBonusPercent() internal view returns(Percent.percent memory p) {
683       //fix refer bonus payment to 6.66%
684       p = m_6_66_percent.toMemory();
685     }
686 
687 function refBonusPercentt() internal view returns(Percent.percent memory p) {
688       //fix refer bonus to 2.66%
689       p = m_2_66_percent.toMemory();
690     }
691 
692     function nextWave() private {
693         m_investors = new InvestorsStorage();
694         investmentsNumber = 0;
695         waveStartup = now;
696         m_rgp.startAt(now);
697     }
698 }