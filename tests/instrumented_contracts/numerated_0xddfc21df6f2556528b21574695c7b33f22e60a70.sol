1 pragma solidity 0.4.25;
2 
3 /**
4 * Инновационный проект по распределению криптовалюты ETH с ежедневными выплатами до 12% в день!
5 * An innovative Blockchain Ethereum project with open source up to 12% per day! 
6 * ежедневные выплаты, навечно. инновационная надежность. до 12% в день, до 360% в месяц. 
7 * валюта вклада и выплаты — ETH, минимальный взнос — 0,01 ETH
8 * Daily payments forever. The innovative reliability. up to 12% per day, up to 360% per month. 
9 * Currency and payment — ETH. Minimal contribution 0.01 eth
10 * https://www.eth777.io/
11 */ 
12 
13 
14 library Math {
15   function min(uint a, uint b) internal pure returns(uint) {
16     if (a > b) {
17       return b;
18     }
19     return a;
20   }
21 }
22 
23 
24 library Zero {
25   function requireNotZero(address addr) internal pure {
26     require(addr != address(0), "require not zero address");
27   }
28 
29   function requireNotZero(uint val) internal pure {
30     require(val != 0, "require not zero value");
31   }
32 
33   function notZero(address addr) internal pure returns(bool) {
34     return !(addr == address(0));
35   }
36 
37   function isZero(address addr) internal pure returns(bool) {
38     return addr == address(0);
39   }
40 
41   function isZero(uint a) internal pure returns(bool) {
42     return a == 0;
43   }
44 
45   function notZero(uint a) internal pure returns(bool) {
46     return a != 0;
47   }
48 }
49 
50 
51 library Percent {
52   struct percent {
53     uint num;
54     uint den;
55   }
56   
57   function mul(percent storage p, uint a) internal view returns (uint) {
58     if (a == 0) {
59       return 0;
60     }
61     return a*p.num/p.den;
62   }
63 
64   function div(percent storage p, uint a) internal view returns (uint) {
65     return a/p.num*p.den;
66   }
67 
68   function sub(percent storage p, uint a) internal view returns (uint) {
69     uint b = mul(p, a);
70     if (b >= a) {
71       return 0;
72     }
73     return a - b;
74   }
75 
76   function add(percent storage p, uint a) internal view returns (uint) {
77     return a + mul(p, a);
78   }
79 
80   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
81     return Percent.percent(p.num, p.den);
82   }
83 
84   function mmul(percent memory p, uint a) internal pure returns (uint) {
85     if (a == 0) {
86       return 0;
87     }
88     return a*p.num/p.den;
89   }
90 
91   function mdiv(percent memory p, uint a) internal pure returns (uint) {
92     return a/p.num*p.den;
93   }
94 
95   function msub(percent memory p, uint a) internal pure returns (uint) {
96     uint b = mmul(p, a);
97     if (b >= a) {
98       return 0;
99     }
100     return a - b;
101   }
102 
103   function madd(percent memory p, uint a) internal pure returns (uint) {
104     return a + mmul(p, a);
105   }
106 }
107 
108 
109 library Address {
110   function toAddress(bytes source) internal pure returns(address addr) {
111     assembly { addr := mload(add(source,0x14)) }
112     return addr;
113   }
114 
115   function isNotContract(address addr) internal view returns(bool) {
116     uint length;
117     assembly { length := extcodesize(addr) }
118     return length == 0;
119   }
120 }
121 
122 
123 /**
124  * @title SafeMath
125  * @dev Math operations with safety checks that revert on error
126  */
127 library SafeMath {
128 
129   /**
130   * @dev Multiplies two numbers, reverts on overflow.
131   */
132   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
133     if (_a == 0) {
134       return 0;
135     }
136 
137     uint256 c = _a * _b;
138     require(c / _a == _b);
139 
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
145   */
146   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
147     require(_b > 0); // Solidity only automatically asserts when dividing by 0
148     uint256 c = _a / _b;
149     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
150 
151     return c;
152   }
153 
154   /**
155   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
158     require(_b <= _a);
159     uint256 c = _a - _b;
160 
161     return c;
162   }
163 
164   /**
165   * @dev Adds two numbers, reverts on overflow.
166   */
167   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
168     uint256 c = _a + _b;
169     require(c >= _a);
170 
171     return c;
172   }
173 
174   /**
175   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
176   * reverts when dividing by zero.
177   */
178   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179     require(b != 0);
180     return a % b;
181   }
182 }
183 
184 
185 contract Accessibility {
186   address private owner;
187   modifier onlyOwner() {
188     require(msg.sender == owner, "access denied");
189     _;
190   }
191 
192   constructor() public {
193     owner = msg.sender;
194   }
195 
196   function disown() internal {
197     delete owner;
198   }
199 }
200 
201 
202 contract Rev1Storage {
203   function investorShortInfo(address addr) public view returns(uint value, uint refBonus); 
204 }
205 
206 
207 contract Rev2Storage {
208   function investorInfo(address addr) public view returns(uint investment, uint paymentTime); 
209 }
210 
211 
212 library PrivateEntrance {
213   using PrivateEntrance for privateEntrance;
214   using Math for uint;
215   struct privateEntrance {
216     Rev1Storage rev1Storage;
217     Rev2Storage rev2Storage;
218     uint investorMaxInvestment;
219     uint endTimestamp;
220     mapping(address=>bool) hasAccess;
221   }
222 
223   function isActive(privateEntrance storage pe) internal view returns(bool) {
224     return pe.endTimestamp > now;
225   }
226 
227   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
228     if (!pe.hasAccess[investorAddr]) {
229       return 0;
230     }
231 
232     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
233     if (maxInvestment == 0) {
234       return 0;
235     }
236     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
237 
238     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
239     
240     if (currInvestment >= maxInvestment) {
241       return 0;
242     }
243 
244     return maxInvestment-currInvestment;
245   }
246 
247   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
248     for (uint16 i; i < addrs.length; i++) {
249       pe.hasAccess[addrs[i]] = true;
250     }
251   }
252 }
253 
254 
255 contract InvestorsStorage is Accessibility {
256   struct Investor {
257     uint investment;
258     uint paymentTime;
259   }
260   uint public size;
261 
262   mapping (address => Investor) private investors;
263 
264   function isInvestor(address addr) public view returns (bool) {
265     return investors[addr].investment > 0;
266   }
267 
268   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
269     investment = investors[addr].investment;
270     paymentTime = investors[addr].paymentTime;
271   }
272 
273   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
274     Investor storage inv = investors[addr];
275     if (inv.investment != 0 || investment == 0) {
276       return false;
277     }
278     inv.investment = investment;
279     inv.paymentTime = paymentTime;
280     size++;
281     return true;
282   }
283 
284   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
285     if (investors[addr].investment == 0) {
286       return false;
287     }
288     investors[addr].investment += investment;
289     return true;
290   }
291 
292   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
293     if (investors[addr].investment == 0) {
294       return false;
295     }
296     investors[addr].paymentTime = paymentTime;
297     return true;
298   }
299 
300   function disqalify(address addr) public onlyOwner returns (bool) {
301     if (isInvestor(addr)) {
302       investors[addr].investment = 0;
303     }
304   }
305 }
306 
307 
308 library RapidGrowthProtection {
309   using RapidGrowthProtection for rapidGrowthProtection;
310   
311   struct rapidGrowthProtection {
312     uint startTimestamp;
313     uint maxDailyTotalInvestment;
314     uint8 activityDays;
315     mapping(uint8 => uint) dailyTotalInvestment;
316   }
317 
318   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
319     uint day = rgp.currDay();
320     if (day == 0 || day > rgp.activityDays) {
321       return 0;
322     }
323     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
324       return 0;
325     }
326     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
327   }
328 
329   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
330     uint day = rgp.currDay();
331     return day != 0 && day <= rgp.activityDays;
332   }
333 
334   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
335     uint day = rgp.currDay();
336     if (day == 0 || day > rgp.activityDays) {
337       return false;
338     }
339     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
340       return false;
341     }
342     rgp.dailyTotalInvestment[uint8(day)] += investment;
343     return true;
344   }
345 
346   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal { 
347     rgp.startTimestamp = timestamp;
348 
349     // restart
350     for (uint8 i = 1; i <= rgp.activityDays; i++) {
351       if (rgp.dailyTotalInvestment[i] != 0) {
352         delete rgp.dailyTotalInvestment[i];
353       }
354     }
355   }
356 
357   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
358     if (rgp.startTimestamp > now) {
359       return 0;
360     }
361     day = (now - rgp.startTimestamp) / 24 hours + 1; 
362   }
363 }
364 
365 contract Revolution2 is Accessibility {
366   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
367   using PrivateEntrance for PrivateEntrance.privateEntrance;
368   using Percent for Percent.percent;
369   using SafeMath for uint;
370   using Math for uint;
371 
372   // easy read for investors
373   using Address for *;
374   using Zero for *; 
375   
376   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
377   PrivateEntrance.privateEntrance private m_privEnter;
378   mapping(address => bool) private m_referrals;
379   InvestorsStorage private m_investors;
380 
381   // automatically generates getters
382   uint public constant minInvesment = 10 finney; 
383   uint public constant maxBalance = 333e5 ether; 
384   address public advertisingAddress;
385   address public adminsAddress;
386   uint public investmentsNumber;
387   uint public waveStartup;
388 
389   // percents 
390   Percent.percent private m_5_percent = Percent.percent(5,100);            // 5/100 *100% = 5%
391   Percent.percent private m_6_percent = Percent.percent(6,100);            // 6/100 *100% = 6%
392   Percent.percent private m_7_percent = Percent.percent(7,100);            // 7/100 *100% = 7%
393   Percent.percent private m_8_percent = Percent.percent(8,100);            // 8/100 *100% = 8%
394   Percent.percent private m_9_percent = Percent.percent(9,100);            // 9/100 *100% = 9%
395   Percent.percent private m_10_percent = Percent.percent(10,100);          // 10/100 *100% = 10%
396   Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
397   Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
398   Percent.percent private m_referal_percent = Percent.percent(5,100);        // 5/100 *100% = 5%
399   Percent.percent private m_referrer_percent = Percent.percent(7,100);       // 7/100 *100% = 7%
400   Percent.percent private m_referrer_percentMax = Percent.percent(10,100);   // 10/100 *100% = 10%
401   Percent.percent private m_adminsPercent = Percent.percent(55, 1000);       //   55/100  *100% = 5.5%
402   Percent.percent private m_advertisingPercent = Percent.percent(95, 1000);// 95/1000  *100% = 9.5%
403 
404   // more events for easy read from blockchain
405   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
406   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
407   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
408   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
409   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
410   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
411   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
412   event LogPayDividends(address indexed addr, uint when, uint dividends);
413   event LogNewInvestor(address indexed addr, uint when);
414   event LogBalanceChanged(uint when, uint balance);
415   event LogNextWave(uint when);
416   event LogDisown(uint when);
417 
418 
419   modifier balanceChanged {
420     _;
421     emit LogBalanceChanged(now, address(this).balance);
422   }
423 
424   modifier notFromContract() {
425     require(msg.sender.isNotContract(), "only externally accounts");
426     _;
427   }
428 
429   constructor() public {
430     adminsAddress = msg.sender;
431     advertisingAddress = msg.sender;
432     nextWave();
433   }
434 
435   function() public payable {
436     // investor get him dividends
437     if (msg.value.isZero()) {
438       getMyDividends();
439       return;
440     }
441 
442     // sender do invest
443     doInvest(msg.data.toAddress());
444   }
445 
446   function disqualifyAddress(address addr) public onlyOwner {
447     m_investors.disqalify(addr);
448   }
449 
450   function doDisown() public onlyOwner {
451     disown();
452     emit LogDisown(now);
453   }
454 
455   function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
456     // init Rapid Growth Protection
457     m_rgp.startTimestamp = timestamp + 1;
458     m_rgp.maxDailyTotalInvestment = 500 ether;
459     m_rgp.activityDays = 21;
460     emit LogRGPInit(
461       now, 
462       m_rgp.startTimestamp,
463       m_rgp.maxDailyTotalInvestment,
464       m_rgp.activityDays
465     );
466 
467 
468     // init Private Entrance
469     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
470     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
471     m_privEnter.investorMaxInvestment = 50 ether;
472     m_privEnter.endTimestamp = timestamp;
473     emit LogPEInit(
474       now, 
475       address(m_privEnter.rev1Storage), 
476       address(m_privEnter.rev2Storage), 
477       m_privEnter.investorMaxInvestment, 
478       m_privEnter.endTimestamp
479     );
480   }
481 
482   function setAdvertisingAddress(address addr) public onlyOwner {
483     addr.requireNotZero();
484     advertisingAddress = addr;
485   }
486 
487   function setAdminsAddress(address addr) public onlyOwner {
488     addr.requireNotZero();
489     adminsAddress = addr;
490   }
491 
492   function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
493     m_privEnter.provideAccessFor(addrs);
494   }
495 
496   function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
497     investment = m_rgp.maxInvestmentAtNow();
498   }
499 
500   function investorsNumber() public view returns(uint) {
501     return m_investors.size();
502   }
503 
504   function balanceETH() public view returns(uint) {
505     return address(this).balance;
506   }
507 
508   function advertisingPercent() public view returns(uint numerator, uint denominator) {
509     (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
510   }
511 
512   function adminsPercent() public view returns(uint numerator, uint denominator) {
513     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
514   }
515 
516   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
517     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
518     isReferral = m_referrals[investorAddr];
519   }
520 
521   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
522     dividends = calcDividends(investorAddr);
523   }
524 
525   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
526     Percent.percent memory p = dailyPercent();
527     (numerator, denominator) = (p.num, p.den);
528   }
529 
530   function getMyDividends() public notFromContract balanceChanged {
531     // calculate dividends
532     
533     //check if 1 day passed after last payment
534     require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
535 
536     uint dividends = calcDividends(msg.sender);
537     require (dividends.notZero(), "cannot to pay zero dividends");
538 
539     // update investor payment timestamp
540     assert(m_investors.setPaymentTime(msg.sender, now));
541 
542     // check enough eth - goto next wave if needed
543     if (address(this).balance <= dividends) {
544       nextWave();
545       dividends = address(this).balance;
546     } 
547 
548     // transfer dividends to investor
549     msg.sender.transfer(dividends);
550     emit LogPayDividends(msg.sender, now, dividends);
551   }
552 
553   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
554     uint investment = msg.value;
555     uint receivedEther = msg.value;
556     require(investment >= minInvesment, "investment must be >= minInvesment");
557     require(address(this).balance <= maxBalance, "the contract eth balance limit");
558 
559     if (m_rgp.isActive()) { 
560       // use Rapid Growth Protection if needed
561       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
562       rpgMaxInvest.requireNotZero();
563       investment = Math.min(investment, rpgMaxInvest);
564       assert(m_rgp.saveInvestment(investment));
565       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
566       
567     } else if (m_privEnter.isActive()) {
568       // use Private Entrance if needed
569       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
570       peMaxInvest.requireNotZero();
571       investment = Math.min(investment, peMaxInvest);
572     }
573 
574     // send excess of ether if needed
575     if (receivedEther > investment) {
576       uint excess = receivedEther - investment;
577       msg.sender.transfer(excess);
578       receivedEther = investment;
579       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
580     }
581 
582     // commission
583     advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
584     adminsAddress.send(m_adminsPercent.mul(receivedEther));
585 
586     bool senderIsInvestor = m_investors.isInvestor(msg.sender);
587 
588     // ref system works only once and only on first invest
589     if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
590       referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
591       
592       m_referrals[msg.sender] = true;
593       // add referral bonus to investor`s and referral`s investments
594       uint referrerBonus = m_referrer_percent.mmul(investment);
595       if (investment > 10 ether) {
596         referrerBonus = m_referrer_percentMax.mmul(investment);
597       }
598       
599       uint referalBonus = m_referal_percent.mmul(investment);
600       assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
601       investment += referalBonus;                                    // add referral bonus
602       emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
603     }
604 
605     // automatic reinvest - prevent burning dividends
606     uint dividends = calcDividends(msg.sender);
607     if (senderIsInvestor && dividends.notZero()) {
608       investment += dividends;
609       emit LogAutomaticReinvest(msg.sender, now, dividends);
610     }
611 
612     if (senderIsInvestor) {
613       // update existing investor
614       assert(m_investors.addInvestment(msg.sender, investment));
615       assert(m_investors.setPaymentTime(msg.sender, now));
616     } else {
617       // create new investor
618       assert(m_investors.newInvestor(msg.sender, investment, now));
619       emit LogNewInvestor(msg.sender, now);
620     }
621 
622     investmentsNumber++;
623     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
624   }
625 
626   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
627     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
628     return InvestorsStorage.Investor(investment, paymentTime);
629   }
630 
631   function calcDividends(address investorAddr) internal view returns(uint dividends) {
632     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
633 
634     // safe gas if dividends will be 0
635     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
636       return 0;
637     }
638     
639     // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
640     Percent.percent memory p = dailyPercent();
641     dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
642   }
643 
644   function dailyPercent() internal view returns(Percent.percent memory p) {
645     uint balance = address(this).balance;
646 
647     if (balance < 500 ether) { 
648       p = m_5_percent.toMemory(); 
649     } else if ( 500 ether <= balance && balance <= 1500 ether) {
650       p = m_6_percent.toMemory();    
651     } else if ( 1500 ether <= balance && balance <= 5000 ether) {
652       p = m_7_percent.toMemory();   
653     } else if ( 5000 ether <= balance && balance <= 10000 ether) {
654       p = m_8_percent.toMemory();  
655     } else if ( 10000 ether <= balance && balance <= 20000 ether) {
656       p = m_9_percent.toMemory();    
657     } else if ( 20000 ether <= balance && balance <= 30000 ether) {
658       p = m_10_percent.toMemory();  
659     } else if ( 30000 ether <= balance && balance <= 50000 ether) {
660       p = m_11_percent.toMemory();   
661     } else {
662       p = m_12_percent.toMemory();    
663     } 
664   }
665 
666   function nextWave() private {
667     m_investors = new InvestorsStorage();
668     investmentsNumber = 0;
669     waveStartup = now;
670     m_rgp.startAt(now);
671     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
672     emit LogNextWave(now);
673   }
674 }