1 pragma solidity 0.4.25;
2 
3 /**
4 *
5 * Get your 7,77% every day profit with ETH777.io 
6 * 
7 */ 
8 
9 
10 library Math {
11   function min(uint a, uint b) internal pure returns(uint) {
12     if (a > b) {
13       return b;
14     }
15     return a;
16   }
17 }
18 
19 
20 library Zero {
21   function requireNotZero(address addr) internal pure {
22     require(addr != address(0), "require not zero address");
23   }
24 
25   function requireNotZero(uint val) internal pure {
26     require(val != 0, "require not zero value");
27   }
28 
29   function notZero(address addr) internal pure returns(bool) {
30     return !(addr == address(0));
31   }
32 
33   function isZero(address addr) internal pure returns(bool) {
34     return addr == address(0);
35   }
36 
37   function isZero(uint a) internal pure returns(bool) {
38     return a == 0;
39   }
40 
41   function notZero(uint a) internal pure returns(bool) {
42     return a != 0;
43   }
44 }
45 
46 
47 library Percent {
48   struct percent {
49     uint num;
50     uint den;
51   }
52   
53   function mul(percent storage p, uint a) internal view returns (uint) {
54     if (a == 0) {
55       return 0;
56     }
57     return a*p.num/p.den;
58   }
59 
60   function div(percent storage p, uint a) internal view returns (uint) {
61     return a/p.num*p.den;
62   }
63 
64   function sub(percent storage p, uint a) internal view returns (uint) {
65     uint b = mul(p, a);
66     if (b >= a) {
67       return 0;
68     }
69     return a - b;
70   }
71 
72   function add(percent storage p, uint a) internal view returns (uint) {
73     return a + mul(p, a);
74   }
75 
76   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
77     return Percent.percent(p.num, p.den);
78   }
79 
80   function mmul(percent memory p, uint a) internal pure returns (uint) {
81     if (a == 0) {
82       return 0;
83     }
84     return a*p.num/p.den;
85   }
86 
87   function mdiv(percent memory p, uint a) internal pure returns (uint) {
88     return a/p.num*p.den;
89   }
90 
91   function msub(percent memory p, uint a) internal pure returns (uint) {
92     uint b = mmul(p, a);
93     if (b >= a) {
94       return 0;
95     }
96     return a - b;
97   }
98 
99   function madd(percent memory p, uint a) internal pure returns (uint) {
100     return a + mmul(p, a);
101   }
102 }
103 
104 
105 library Address {
106   function toAddress(bytes source) internal pure returns(address addr) {
107     assembly { addr := mload(add(source,0x14)) }
108     return addr;
109   }
110 
111   function isNotContract(address addr) internal view returns(bool) {
112     uint length;
113     assembly { length := extcodesize(addr) }
114     return length == 0;
115   }
116 }
117 
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that revert on error
122  */
123 library SafeMath {
124 
125   /**
126   * @dev Multiplies two numbers, reverts on overflow.
127   */
128   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
129     if (_a == 0) {
130       return 0;
131     }
132 
133     uint256 c = _a * _b;
134     require(c / _a == _b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
143     require(_b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = _a / _b;
145     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
154     require(_b <= _a);
155     uint256 c = _a - _b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
164     uint256 c = _a + _b;
165     require(c >= _a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 
181 contract Accessibility {
182   address private owner;
183   modifier onlyOwner() {
184     require(msg.sender == owner, "access denied");
185     _;
186   }
187 
188   constructor() public {
189     owner = msg.sender;
190   }
191 
192   function disown() internal {
193     delete owner;
194   }
195 }
196 
197 
198 contract Rev1Storage {
199   function investorShortInfo(address addr) public view returns(uint value, uint refBonus); 
200 }
201 
202 
203 contract Rev2Storage {
204   function investorInfo(address addr) public view returns(uint investment, uint paymentTime); 
205 }
206 
207 
208 library PrivateEntrance {
209   using PrivateEntrance for privateEntrance;
210   using Math for uint;
211   struct privateEntrance {
212     Rev1Storage rev1Storage;
213     Rev2Storage rev2Storage;
214     uint investorMaxInvestment;
215     uint endTimestamp;
216     mapping(address=>bool) hasAccess;
217   }
218 
219   function isActive(privateEntrance storage pe) internal view returns(bool) {
220     return pe.endTimestamp > now;
221   }
222 
223   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
224     if (!pe.hasAccess[investorAddr]) {
225       return 0;
226     }
227 
228     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
229     if (maxInvestment == 0) {
230       return 0;
231     }
232     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
233 
234     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
235     
236     if (currInvestment >= maxInvestment) {
237       return 0;
238     }
239 
240     return maxInvestment-currInvestment;
241   }
242 
243   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
244     for (uint16 i; i < addrs.length; i++) {
245       pe.hasAccess[addrs[i]] = true;
246     }
247   }
248 }
249 
250 
251 contract InvestorsStorage is Accessibility {
252   struct Investor {
253     uint investment;
254     uint paymentTime;
255   }
256   uint public size;
257 
258   mapping (address => Investor) private investors;
259 
260   function isInvestor(address addr) public view returns (bool) {
261     return investors[addr].investment > 0;
262   }
263 
264   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
265     investment = investors[addr].investment;
266     paymentTime = investors[addr].paymentTime;
267   }
268 
269   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
270     Investor storage inv = investors[addr];
271     if (inv.investment != 0 || investment == 0) {
272       return false;
273     }
274     inv.investment = investment;
275     inv.paymentTime = paymentTime;
276     size++;
277     return true;
278   }
279 
280   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
281     if (investors[addr].investment == 0) {
282       return false;
283     }
284     investors[addr].investment += investment;
285     return true;
286   }
287 
288   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
289     if (investors[addr].investment == 0) {
290       return false;
291     }
292     investors[addr].paymentTime = paymentTime;
293     return true;
294   }
295 
296   function disqalify(address addr) public onlyOwner returns (bool) {
297     if (isInvestor(addr)) {
298       investors[addr].investment = 0;
299     }
300   }
301 }
302 
303 
304 library RapidGrowthProtection {
305   using RapidGrowthProtection for rapidGrowthProtection;
306   
307   struct rapidGrowthProtection {
308     uint startTimestamp;
309     uint maxDailyTotalInvestment;
310     uint8 activityDays;
311     mapping(uint8 => uint) dailyTotalInvestment;
312   }
313 
314   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
315     uint day = rgp.currDay();
316     if (day == 0 || day > rgp.activityDays) {
317       return 0;
318     }
319     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
320       return 0;
321     }
322     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
323   }
324 
325   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
326     uint day = rgp.currDay();
327     return day != 0 && day <= rgp.activityDays;
328   }
329 
330   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
331     uint day = rgp.currDay();
332     if (day == 0 || day > rgp.activityDays) {
333       return false;
334     }
335     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
336       return false;
337     }
338     rgp.dailyTotalInvestment[uint8(day)] += investment;
339     return true;
340   }
341 
342   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal { 
343     rgp.startTimestamp = timestamp;
344 
345     // restart
346     for (uint8 i = 1; i <= rgp.activityDays; i++) {
347       if (rgp.dailyTotalInvestment[i] != 0) {
348         delete rgp.dailyTotalInvestment[i];
349       }
350     }
351   }
352 
353   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
354     if (rgp.startTimestamp > now) {
355       return 0;
356     }
357     day = (now - rgp.startTimestamp) / 24 hours + 1; 
358   }
359 }
360 
361 contract Revolution2 is Accessibility {
362   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
363   using PrivateEntrance for PrivateEntrance.privateEntrance;
364   using Percent for Percent.percent;
365   using SafeMath for uint;
366   using Math for uint;
367 
368   // easy read for investors
369   using Address for *;
370   using Zero for *; 
371   
372   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
373   PrivateEntrance.privateEntrance private m_privEnter;
374   mapping(address => bool) private m_referrals;
375   InvestorsStorage private m_investors;
376 
377   // automatically generates getters
378   uint public constant minInvesment = 10 finney; 
379   uint public constant maxBalance = 333e5 ether; 
380   address public advertisingAddress;
381   address public adminsAddress;
382   uint public investmentsNumber;
383   uint public waveStartup;
384 
385   // percents 
386   Percent.percent private m_5_percent = Percent.percent(777,10000);            // 777/10000 *100% = 7.77%
387   Percent.percent private m_6_percent = Percent.percent(9,100);            // 9/100 *100% = 9%
388   Percent.percent private m_7_percent = Percent.percent(10,100);            // 10/100 *100% = 10%
389   Percent.percent private m_8_percent = Percent.percent(8,100);            // 8/100 *100% = 8%
390   Percent.percent private m_9_percent = Percent.percent(9,100);            // 9/100 *100% = 9%
391   Percent.percent private m_10_percent = Percent.percent(10,100);          // 10/100 *100% = 10%
392   Percent.percent private m_11_percent = Percent.percent(11,100);            // 11/100 *100% = 11%
393   Percent.percent private m_12_percent = Percent.percent(12,100);            // 12/100 *100% = 12%
394   Percent.percent private m_referal_percent = Percent.percent(5,100);        // 5/100 *100% = 5%
395   Percent.percent private m_referrer_percent = Percent.percent(7,100);       // 7/100 *100% = 7%
396   Percent.percent private m_referrer_percentMax = Percent.percent(10,100);   // 10/100 *100% = 10%
397   Percent.percent private m_adminsPercent = Percent.percent(55, 1000);       //   55/100  *100% = 5.5%
398   Percent.percent private m_advertisingPercent = Percent.percent(95, 1000);// 95/1000  *100% = 9.5%
399 
400   // more events for easy read from blockchain
401   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
402   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
403   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
404   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
405   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
406   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
407   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
408   event LogPayDividends(address indexed addr, uint when, uint dividends);
409   event LogNewInvestor(address indexed addr, uint when);
410   event LogBalanceChanged(uint when, uint balance);
411   event LogNextWave(uint when);
412   event LogDisown(uint when);
413 
414 
415   modifier balanceChanged {
416     _;
417     emit LogBalanceChanged(now, address(this).balance);
418   }
419 
420   modifier notFromContract() {
421     require(msg.sender.isNotContract(), "only externally accounts");
422     _;
423   }
424 
425   constructor() public {
426     adminsAddress = msg.sender;
427     advertisingAddress = msg.sender;
428     nextWave();
429   }
430 
431   function() public payable {
432     // investor get him dividends
433     if (msg.value.isZero()) {
434       getMyDividends();
435       return;
436     }
437 
438     // sender do invest
439     doInvest(msg.data.toAddress());
440   }
441 
442   function disqualifyAddress(address addr) public onlyOwner {
443     m_investors.disqalify(addr);
444   }
445 
446   function doDisown() public onlyOwner {
447     disown();
448     emit LogDisown(now);
449   }
450 
451   function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
452     // init Rapid Growth Protection
453     m_rgp.startTimestamp = timestamp + 1;
454     m_rgp.maxDailyTotalInvestment = 500 ether;
455     m_rgp.activityDays = 21;
456     emit LogRGPInit(
457       now, 
458       m_rgp.startTimestamp,
459       m_rgp.maxDailyTotalInvestment,
460       m_rgp.activityDays
461     );
462 
463 
464     // init Private Entrance
465     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
466     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
467     m_privEnter.investorMaxInvestment = 50 ether;
468     m_privEnter.endTimestamp = timestamp;
469     emit LogPEInit(
470       now, 
471       address(m_privEnter.rev1Storage), 
472       address(m_privEnter.rev2Storage), 
473       m_privEnter.investorMaxInvestment, 
474       m_privEnter.endTimestamp
475     );
476   }
477 
478   function setAdvertisingAddress(address addr) public onlyOwner {
479     addr.requireNotZero();
480     advertisingAddress = addr;
481   }
482 
483   function setAdminsAddress(address addr) public onlyOwner {
484     addr.requireNotZero();
485     adminsAddress = addr;
486   }
487 
488   function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
489     m_privEnter.provideAccessFor(addrs);
490   }
491 
492   function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
493     investment = m_rgp.maxInvestmentAtNow();
494   }
495 
496   function investorsNumber() public view returns(uint) {
497     return m_investors.size();
498   }
499 
500   function balanceETH() public view returns(uint) {
501     return address(this).balance;
502   }
503 
504   function advertisingPercent() public view returns(uint numerator, uint denominator) {
505     (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
506   }
507 
508   function adminsPercent() public view returns(uint numerator, uint denominator) {
509     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
510   }
511 
512   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
513     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
514     isReferral = m_referrals[investorAddr];
515   }
516 
517   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
518     dividends = calcDividends(investorAddr);
519   }
520 
521   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
522     Percent.percent memory p = dailyPercent();
523     (numerator, denominator) = (p.num, p.den);
524   }
525 
526   function getMyDividends() public notFromContract balanceChanged {
527     // calculate dividends
528     
529     //check if 1 day passed after last payment
530     require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
531 
532     uint dividends = calcDividends(msg.sender);
533     require (dividends.notZero(), "cannot to pay zero dividends");
534 
535     // update investor payment timestamp
536     assert(m_investors.setPaymentTime(msg.sender, now));
537 
538     // check enough eth - goto next wave if needed
539     if (address(this).balance <= dividends) {
540       nextWave();
541       dividends = address(this).balance;
542     } 
543 
544     // transfer dividends to investor
545     msg.sender.transfer(dividends);
546     emit LogPayDividends(msg.sender, now, dividends);
547   }
548 
549   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
550     uint investment = msg.value;
551     uint receivedEther = msg.value;
552     require(investment >= minInvesment, "investment must be >= minInvesment");
553     require(address(this).balance <= maxBalance, "the contract eth balance limit");
554 
555     if (m_rgp.isActive()) { 
556       // use Rapid Growth Protection if needed
557       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
558       rpgMaxInvest.requireNotZero();
559       investment = Math.min(investment, rpgMaxInvest);
560       assert(m_rgp.saveInvestment(investment));
561       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
562       
563     } else if (m_privEnter.isActive()) {
564       // use Private Entrance if needed
565       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
566       peMaxInvest.requireNotZero();
567       investment = Math.min(investment, peMaxInvest);
568     }
569 
570     // send excess of ether if needed
571     if (receivedEther > investment) {
572       uint excess = receivedEther - investment;
573       msg.sender.transfer(excess);
574       receivedEther = investment;
575       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
576     }
577 
578     // commission
579     advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
580     adminsAddress.send(m_adminsPercent.mul(receivedEther));
581 
582     bool senderIsInvestor = m_investors.isInvestor(msg.sender);
583 
584     // ref system works only once and only on first invest
585     if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
586       referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
587       
588       m_referrals[msg.sender] = true;
589       // add referral bonus to investor`s and referral`s investments
590       uint referrerBonus = m_referrer_percent.mmul(investment);
591       if (investment > 10 ether) {
592         referrerBonus = m_referrer_percentMax.mmul(investment);
593       }
594       
595       uint referalBonus = m_referal_percent.mmul(investment);
596       assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
597       investment += referalBonus;                                    // add referral bonus
598       emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
599     }
600 
601     // automatic reinvest - prevent burning dividends
602     uint dividends = calcDividends(msg.sender);
603     if (senderIsInvestor && dividends.notZero()) {
604       investment += dividends;
605       emit LogAutomaticReinvest(msg.sender, now, dividends);
606     }
607 
608     if (senderIsInvestor) {
609       // update existing investor
610       assert(m_investors.addInvestment(msg.sender, investment));
611       assert(m_investors.setPaymentTime(msg.sender, now));
612     } else {
613       // create new investor
614       assert(m_investors.newInvestor(msg.sender, investment, now));
615       emit LogNewInvestor(msg.sender, now);
616     }
617 
618     investmentsNumber++;
619     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
620   }
621 
622   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
623     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
624     return InvestorsStorage.Investor(investment, paymentTime);
625   }
626 
627   function calcDividends(address investorAddr) internal view returns(uint dividends) {
628     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
629 
630     // safe gas if dividends will be 0
631     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
632       return 0;
633     }
634     
635     // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
636     Percent.percent memory p = dailyPercent();
637     dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
638   }
639 
640   function dailyPercent() internal view returns(Percent.percent memory p) {
641     uint balance = address(this).balance;
642 
643     if (balance < 500 ether) { 
644       p = m_5_percent.toMemory(); 
645     } else if ( 500 ether <= balance && balance <= 1500 ether) {
646       p = m_6_percent.toMemory();    
647     } else if ( 1500 ether <= balance && balance <= 5000 ether) {
648       p = m_7_percent.toMemory();   
649     } else if ( 5000 ether <= balance && balance <= 10000 ether) {
650       p = m_8_percent.toMemory();  
651     } else if ( 10000 ether <= balance && balance <= 20000 ether) {
652       p = m_9_percent.toMemory();    
653     } else if ( 20000 ether <= balance && balance <= 30000 ether) {
654       p = m_10_percent.toMemory();  
655     } else if ( 30000 ether <= balance && balance <= 50000 ether) {
656       p = m_11_percent.toMemory();   
657     } else {
658       p = m_12_percent.toMemory();    
659     } 
660   }
661 
662   function nextWave() private {
663     m_investors = new InvestorsStorage();
664     investmentsNumber = 0;
665     waveStartup = now;
666     m_rgp.startAt(now);
667     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
668     emit LogNextWave(now);
669   }
670 }