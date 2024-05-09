1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * Finplether is a financial hedging instrument to mitigate any cryptocurrency risks.
6 * Finplether operates at the unique Ethereum Smart Contract.
7 * Finplether are assets that can be traded, or they can also be seen as packages of capital
8 * that may be traded. Most types of financial instruments provide efficient flow 
9 * and transfer of capital all throughout the world's investors. 
10 * www.finplether.com 
11 * 
12 */ 
13 
14 
15 library Math {
16   function min(uint a, uint b) internal pure returns(uint) {
17     if (a > b) {
18       return b;
19     }
20     return a;
21   }
22 }
23 
24 
25 library Zero {
26   function requireNotZero(address addr) internal pure {
27     require(addr != address(0), "require not zero address");
28   }
29 
30   function requireNotZero(uint val) internal pure {
31     require(val != 0, "require not zero value");
32   }
33 
34   function notZero(address addr) internal pure returns(bool) {
35     return !(addr == address(0));
36   }
37 
38   function isZero(address addr) internal pure returns(bool) {
39     return addr == address(0);
40   }
41 
42   function isZero(uint a) internal pure returns(bool) {
43     return a == 0;
44   }
45 
46   function notZero(uint a) internal pure returns(bool) {
47     return a != 0;
48   }
49 }
50 
51 
52 library Percent {
53   struct percent {
54     uint num;
55     uint den;
56   }
57   
58   function mul(percent storage p, uint a) internal view returns (uint) {
59     if (a == 0) {
60       return 0;
61     }
62     return a*p.num/p.den;
63   }
64 
65   function div(percent storage p, uint a) internal view returns (uint) {
66     return a/p.num*p.den;
67   }
68 
69   function sub(percent storage p, uint a) internal view returns (uint) {
70     uint b = mul(p, a);
71     if (b >= a) {
72       return 0;
73     }
74     return a - b;
75   }
76 
77   function add(percent storage p, uint a) internal view returns (uint) {
78     return a + mul(p, a);
79   }
80 
81   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
82     return Percent.percent(p.num, p.den);
83   }
84 
85   function mmul(percent memory p, uint a) internal pure returns (uint) {
86     if (a == 0) {
87       return 0;
88     }
89     return a*p.num/p.den;
90   }
91 
92   function mdiv(percent memory p, uint a) internal pure returns (uint) {
93     return a/p.num*p.den;
94   }
95 
96   function msub(percent memory p, uint a) internal pure returns (uint) {
97     uint b = mmul(p, a);
98     if (b >= a) {
99       return 0;
100     }
101     return a - b;
102   }
103 
104   function madd(percent memory p, uint a) internal pure returns (uint) {
105     return a + mmul(p, a);
106   }
107 }
108 
109 
110 library Address {
111   function toAddress(bytes source) internal pure returns(address addr) {
112     assembly { addr := mload(add(source,0x14)) }
113     return addr;
114   }
115 
116   function isNotContract(address addr) internal view returns(bool) {
117     uint length;
118     assembly { length := extcodesize(addr) }
119     return length == 0;
120   }
121 }
122 
123 
124 /**
125  * @title SafeMath
126  * @dev Math operations with safety checks that revert on error
127  */
128 library SafeMath {
129 
130   /**
131   * @dev Multiplies two numbers, reverts on overflow.
132   */
133   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
134     if (_a == 0) {
135       return 0;
136     }
137 
138     uint256 c = _a * _b;
139     require(c / _a == _b);
140 
141     return c;
142   }
143 
144   /**
145   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
146   */
147   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
148     require(_b > 0); // Solidity only automatically asserts when dividing by 0
149     uint256 c = _a / _b;
150     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
151 
152     return c;
153   }
154 
155   /**
156   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
157   */
158   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
159     require(_b <= _a);
160     uint256 c = _a - _b;
161 
162     return c;
163   }
164 
165   /**
166   * @dev Adds two numbers, reverts on overflow.
167   */
168   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
169     uint256 c = _a + _b;
170     require(c >= _a);
171 
172     return c;
173   }
174 
175   /**
176   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
177   * reverts when dividing by zero.
178   */
179   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180     require(b != 0);
181     return a % b;
182   }
183 }
184 
185 
186 contract Accessibility {
187   address private owner;
188   modifier onlyOwner() {
189     require(msg.sender == owner, "access denied");
190     _;
191   }
192 
193   constructor() public {
194     owner = msg.sender;
195   }
196 
197   function disown() internal {
198     delete owner;
199   }
200 }
201 
202 
203 contract Rev1Storage {
204   function investorShortInfo(address addr) public view returns(uint value, uint refBonus); 
205 }
206 
207 
208 contract Rev2Storage {
209   function investorInfo(address addr) public view returns(uint investment, uint paymentTime); 
210 }
211 
212 
213 library PrivateEntrance {
214   using PrivateEntrance for privateEntrance;
215   using Math for uint;
216   struct privateEntrance {
217     Rev1Storage rev1Storage;
218     Rev2Storage rev2Storage;
219     uint investorMaxInvestment;
220     uint endTimestamp;
221     mapping(address=>bool) hasAccess;
222   }
223 
224   function isActive(privateEntrance storage pe) internal view returns(bool) {
225     return pe.endTimestamp > now;
226   }
227 
228   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
229     if (!pe.hasAccess[investorAddr]) {
230       return 0;
231     }
232 
233     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
234     if (maxInvestment == 0) {
235       return 0;
236     }
237     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
238 
239     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
240     
241     if (currInvestment >= maxInvestment) {
242       return 0;
243     }
244 
245     return maxInvestment-currInvestment;
246   }
247 
248   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
249     for (uint16 i; i < addrs.length; i++) {
250       pe.hasAccess[addrs[i]] = true;
251     }
252   }
253 }
254 
255 
256 contract InvestorsStorage is Accessibility {
257   struct Investor {
258     uint investment;
259     uint paymentTime;
260   }
261   uint public size;
262 
263   mapping (address => Investor) private investors;
264 
265   function isInvestor(address addr) public view returns (bool) {
266     return investors[addr].investment > 0;
267   }
268 
269   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
270     investment = investors[addr].investment;
271     paymentTime = investors[addr].paymentTime;
272   }
273 
274   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
275     Investor storage inv = investors[addr];
276     if (inv.investment != 0 || investment == 0) {
277       return false;
278     }
279     inv.investment = investment;
280     inv.paymentTime = paymentTime;
281     size++;
282     return true;
283   }
284 
285   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
286     if (investors[addr].investment == 0) {
287       return false;
288     }
289     investors[addr].investment += investment;
290     return true;
291   }
292 
293   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
294     if (investors[addr].investment == 0) {
295       return false;
296     }
297     investors[addr].paymentTime = paymentTime;
298     return true;
299   }
300 
301   function disqalify(address addr) public onlyOwner returns (bool) {
302     if (isInvestor(addr)) {
303       investors[addr].investment = 0;
304     }
305   }
306 }
307 
308 
309 library RapidGrowthProtection {
310   using RapidGrowthProtection for rapidGrowthProtection;
311   
312   struct rapidGrowthProtection {
313     uint startTimestamp;
314     uint maxDailyTotalInvestment;
315     uint8 activityDays;
316     mapping(uint8 => uint) dailyTotalInvestment;
317   }
318 
319   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
320     uint day = rgp.currDay();
321     if (day == 0 || day > rgp.activityDays) {
322       return 0;
323     }
324     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
325       return 0;
326     }
327     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
328   }
329 
330   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
331     uint day = rgp.currDay();
332     return day != 0 && day <= rgp.activityDays;
333   }
334 
335   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
336     uint day = rgp.currDay();
337     if (day == 0 || day > rgp.activityDays) {
338       return false;
339     }
340     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
341       return false;
342     }
343     rgp.dailyTotalInvestment[uint8(day)] += investment;
344     return true;
345   }
346 
347   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal { 
348     rgp.startTimestamp = timestamp;
349 
350     // restart
351     for (uint8 i = 1; i <= rgp.activityDays; i++) {
352       if (rgp.dailyTotalInvestment[i] != 0) {
353         delete rgp.dailyTotalInvestment[i];
354       }
355     }
356   }
357 
358   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
359     if (rgp.startTimestamp > now) {
360       return 0;
361     }
362     day = (now - rgp.startTimestamp) / 24 hours + 1; 
363   }
364 }
365 
366 contract Finplether is Accessibility {
367   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
368   using PrivateEntrance for PrivateEntrance.privateEntrance;
369   using Percent for Percent.percent;
370   using SafeMath for uint;
371   using Math for uint;
372 
373   // easy read for investors
374   using Address for *;
375   using Zero for *; 
376   
377   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
378   PrivateEntrance.privateEntrance private m_privEnter;
379   mapping(address => bool) private m_referrals;
380   InvestorsStorage private m_investors;
381 
382   // automatically generates getters
383   uint public constant minInvesment = 10 finney; 
384   uint public constant maxBalance = 333e5 ether; 
385   address public advertisingAddress;
386   address public adminsAddress;
387   uint public investmentsNumber;
388   uint public waveStartup;
389 
390   // percents 
391   Percent.percent private m_5_percent = Percent.percent(525,10000);            // 525/10000 *100% = 5.25%
392   Percent.percent private m_6_percent = Percent.percent(9,100);            // 7/100 *100% = 7%
393   Percent.percent private m_7_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
394   Percent.percent private m_8_percent = Percent.percent(8,100);            // 8/100 *100% = 8%
395   Percent.percent private m_9_percent = Percent.percent(9,100);            // 9/100 *100% = 9%
396   Percent.percent private m_10_percent = Percent.percent(10,100);          // 10/100 *100% = 10%
397   Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
398   Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
399   Percent.percent private m_referal_percent = Percent.percent(10,100);        // 10/100 *100% = 10%
400   Percent.percent private m_referrer_percent = Percent.percent(10,100);       // 10/100 *100% = 10%
401   Percent.percent private m_referrer_percentMax = Percent.percent(15,100);   // 15/100 *100% = 15%
402   Percent.percent private m_adminsPercent = Percent.percent(5, 100);       //   5/100  *100% = 5%
403   Percent.percent private m_advertisingPercent = Percent.percent(5, 100);// 5/100  *100% = 5%
404 
405   // more events for easy read from blockchain
406   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
407   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
408   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
409   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
410   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
411   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
412   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
413   event LogPayDividends(address indexed addr, uint when, uint dividends);
414   event LogNewInvestor(address indexed addr, uint when);
415   event LogBalanceChanged(uint when, uint balance);
416   event LogNextWave(uint when);
417   event LogDisown(uint when);
418 
419 
420   modifier balanceChanged {
421     _;
422     emit LogBalanceChanged(now, address(this).balance);
423   }
424 
425   modifier notFromContract() {
426     require(msg.sender.isNotContract(), "only externally accounts");
427     _;
428   }
429 
430   constructor() public {
431     adminsAddress = msg.sender;
432     advertisingAddress = msg.sender;
433     nextWave();
434   }
435 
436   function() public payable {
437     // investor get him dividends
438     if (msg.value.isZero()) {
439       getMyDividends();
440       return;
441     }
442 
443     // sender do invest
444     doInvest(msg.data.toAddress());
445   }
446 
447   function disqualifyAddress(address addr) public onlyOwner {
448     m_investors.disqalify(addr);
449   }
450 
451   function doDisown() public onlyOwner {
452     disown();
453     emit LogDisown(now);
454   }
455 
456   function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
457     // init Rapid Growth Protection
458     m_rgp.startTimestamp = timestamp + 1;
459     m_rgp.maxDailyTotalInvestment = 500 ether;
460     m_rgp.activityDays = 21;
461     emit LogRGPInit(
462       now, 
463       m_rgp.startTimestamp,
464       m_rgp.maxDailyTotalInvestment,
465       m_rgp.activityDays
466     );
467 
468 
469     // init Private Entrance
470     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
471     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
472     m_privEnter.investorMaxInvestment = 50 ether;
473     m_privEnter.endTimestamp = timestamp;
474     emit LogPEInit(
475       now, 
476       address(m_privEnter.rev1Storage), 
477       address(m_privEnter.rev2Storage), 
478       m_privEnter.investorMaxInvestment, 
479       m_privEnter.endTimestamp
480     );
481   }
482 
483   function setAdvertisingAddress(address addr) public onlyOwner {
484     addr.requireNotZero();
485     advertisingAddress = addr;
486   }
487 
488   function setAdminsAddress(address addr) public onlyOwner {
489     addr.requireNotZero();
490     adminsAddress = addr;
491   }
492 
493   function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
494     m_privEnter.provideAccessFor(addrs);
495   }
496 
497   function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
498     investment = m_rgp.maxInvestmentAtNow();
499   }
500 
501   function investorsNumber() public view returns(uint) {
502     return m_investors.size();
503   }
504 
505   function balanceETH() public view returns(uint) {
506     return address(this).balance;
507   }
508 
509   function advertisingPercent() public view returns(uint numerator, uint denominator) {
510     (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
511   }
512 
513   function adminsPercent() public view returns(uint numerator, uint denominator) {
514     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
515   }
516 
517   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
518     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
519     isReferral = m_referrals[investorAddr];
520   }
521 
522   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
523     dividends = calcDividends(investorAddr);
524   }
525 
526   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
527     Percent.percent memory p = dailyPercent();
528     (numerator, denominator) = (p.num, p.den);
529   }
530 
531   function getMyDividends() public notFromContract balanceChanged {
532     // calculate dividends
533     
534     //check if 1 day passed after last payment
535     require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
536 
537     uint dividends = calcDividends(msg.sender);
538     require (dividends.notZero(), "cannot to pay zero dividends");
539 
540     // update investor payment timestamp
541     assert(m_investors.setPaymentTime(msg.sender, now));
542 
543     // check enough eth - goto next wave if needed
544     if (address(this).balance <= dividends) {
545       nextWave();
546       dividends = address(this).balance;
547     } 
548 
549     // transfer dividends to investor
550     msg.sender.transfer(dividends);
551     emit LogPayDividends(msg.sender, now, dividends);
552   }
553 
554   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
555     uint investment = msg.value;
556     uint receivedEther = msg.value;
557     require(investment >= minInvesment, "investment must be >= minInvesment");
558     require(address(this).balance <= maxBalance, "the contract eth balance limit");
559 
560     if (m_rgp.isActive()) { 
561       // use Rapid Growth Protection if needed
562       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
563       rpgMaxInvest.requireNotZero();
564       investment = Math.min(investment, rpgMaxInvest);
565       assert(m_rgp.saveInvestment(investment));
566       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
567       
568     } else if (m_privEnter.isActive()) {
569       // use Private Entrance if needed
570       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
571       peMaxInvest.requireNotZero();
572       investment = Math.min(investment, peMaxInvest);
573     }
574 
575     // send excess of ether if needed
576     if (receivedEther > investment) {
577       uint excess = receivedEther - investment;
578       msg.sender.transfer(excess);
579       receivedEther = investment;
580       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
581     }
582 
583     // commission
584     advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
585     adminsAddress.send(m_adminsPercent.mul(receivedEther));
586 
587     bool senderIsInvestor = m_investors.isInvestor(msg.sender);
588 
589     // ref system works only once and only on first invest
590     if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
591       referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
592       
593       m_referrals[msg.sender] = true;
594       // add referral bonus to investor`s and referral`s investments
595       uint referrerBonus = m_referrer_percent.mmul(investment);
596       if (investment > 10 ether) {
597         referrerBonus = m_referrer_percentMax.mmul(investment);
598       }
599       
600       uint referalBonus = m_referal_percent.mmul(investment);
601       assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
602       investment += referalBonus;                                    // add referral bonus
603       emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
604     }
605 
606     // automatic reinvest - prevent burning dividends
607     uint dividends = calcDividends(msg.sender);
608     if (senderIsInvestor && dividends.notZero()) {
609       investment += dividends;
610       emit LogAutomaticReinvest(msg.sender, now, dividends);
611     }
612 
613     if (senderIsInvestor) {
614       // update existing investor
615       assert(m_investors.addInvestment(msg.sender, investment));
616       assert(m_investors.setPaymentTime(msg.sender, now));
617     } else {
618       // create new investor
619       assert(m_investors.newInvestor(msg.sender, investment, now));
620       emit LogNewInvestor(msg.sender, now);
621     }
622 
623     investmentsNumber++;
624     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
625   }
626 
627   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
628     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
629     return InvestorsStorage.Investor(investment, paymentTime);
630   }
631 
632   function calcDividends(address investorAddr) internal view returns(uint dividends) {
633     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
634 
635     // safe gas if dividends will be 0
636     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
637       return 0;
638     }
639     
640     // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
641     Percent.percent memory p = dailyPercent();
642     dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
643   }
644 
645   function dailyPercent() internal view returns(Percent.percent memory p) {
646     uint balance = address(this).balance;
647 
648     if (balance < 500 ether) { 
649       p = m_5_percent.toMemory(); 
650     } else if ( 500 ether <= balance && balance <= 1500 ether) {
651       p = m_6_percent.toMemory();    
652     } else if ( 1500 ether <= balance && balance <= 5000 ether) {
653       p = m_7_percent.toMemory();   
654     } else if ( 5000 ether <= balance && balance <= 10000 ether) {
655       p = m_8_percent.toMemory();  
656     } else if ( 10000 ether <= balance && balance <= 20000 ether) {
657       p = m_9_percent.toMemory();    
658     } else if ( 20000 ether <= balance && balance <= 30000 ether) {
659       p = m_10_percent.toMemory();  
660     } else if ( 30000 ether <= balance && balance <= 50000 ether) {
661       p = m_11_percent.toMemory();   
662     } else {
663       p = m_12_percent.toMemory();    
664     } 
665   }
666 
667   function nextWave() private {
668     m_investors = new InvestorsStorage();
669     investmentsNumber = 0;
670     waveStartup = now;
671     m_rgp.startAt(now);
672     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
673     emit LogNextWave(now);
674   }
675 }