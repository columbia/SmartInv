1 pragma solidity 0.4.25;
2 
3 /**
4 * Category         - PROFITS FROM THE SALE OF CARS
5 * Web              - https://www.bit-c.co/           
6 */ 
7 
8 
9 library Math {
10   function min(uint a, uint b) internal pure returns(uint) {
11     if (a > b) {
12       return b;
13     }
14     return a;
15   }
16 }
17 
18 
19 library Zero {
20   function requireNotZero(address addr) internal pure {
21     require(addr != address(0), "require not zero address");
22   }
23 
24   function requireNotZero(uint val) internal pure {
25     require(val != 0, "require not zero value");
26   }
27 
28   function notZero(address addr) internal pure returns(bool) {
29     return !(addr == address(0));
30   }
31 
32   function isZero(address addr) internal pure returns(bool) {
33     return addr == address(0);
34   }
35 
36   function isZero(uint a) internal pure returns(bool) {
37     return a == 0;
38   }
39 
40   function notZero(uint a) internal pure returns(bool) {
41     return a != 0;
42   }
43 }
44 
45 
46 library Percent {
47   struct percent {
48     uint num;
49     uint den;
50   }
51   
52   function mul(percent storage p, uint a) internal view returns (uint) {
53     if (a == 0) {
54       return 0;
55     }
56     return a*p.num/p.den;
57   }
58 
59   function div(percent storage p, uint a) internal view returns (uint) {
60     return a/p.num*p.den;
61   }
62 
63   function sub(percent storage p, uint a) internal view returns (uint) {
64     uint b = mul(p, a);
65     if (b >= a) {
66       return 0;
67     }
68     return a - b;
69   }
70 
71   function add(percent storage p, uint a) internal view returns (uint) {
72     return a + mul(p, a);
73   }
74 
75   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
76     return Percent.percent(p.num, p.den);
77   }
78 
79   function mmul(percent memory p, uint a) internal pure returns (uint) {
80     if (a == 0) {
81       return 0;
82     }
83     return a*p.num/p.den;
84   }
85 
86   function mdiv(percent memory p, uint a) internal pure returns (uint) {
87     return a/p.num*p.den;
88   }
89 
90   function msub(percent memory p, uint a) internal pure returns (uint) {
91     uint b = mmul(p, a);
92     if (b >= a) {
93       return 0;
94     }
95     return a - b;
96   }
97 
98   function madd(percent memory p, uint a) internal pure returns (uint) {
99     return a + mmul(p, a);
100   }
101 }
102 
103 
104 library Address {
105   function toAddress(bytes source) internal pure returns(address addr) {
106     assembly { addr := mload(add(source,0x14)) }
107     return addr;
108   }
109 
110   function isNotContract(address addr) internal view returns(bool) {
111     uint length;
112     assembly { length := extcodesize(addr) }
113     return length == 0;
114   }
115 }
116 
117 
118 /**
119  * @title SafeMath
120  * @dev Math operations with safety checks that revert on error
121  */
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, reverts on overflow.
126   */
127   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
128     if (_a == 0) {
129       return 0;
130     }
131 
132     uint256 c = _a * _b;
133     require(c / _a == _b);
134 
135     return c;
136   }
137 
138   /**
139   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
140   */
141   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
142     require(_b > 0); // Solidity only automatically asserts when dividing by 0
143     uint256 c = _a / _b;
144     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
145 
146     return c;
147   }
148 
149   /**
150   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
151   */
152   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
153     require(_b <= _a);
154     uint256 c = _a - _b;
155 
156     return c;
157   }
158 
159   /**
160   * @dev Adds two numbers, reverts on overflow.
161   */
162   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
163     uint256 c = _a + _b;
164     require(c >= _a);
165 
166     return c;
167   }
168 
169   /**
170   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
171   * reverts when dividing by zero.
172   */
173   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174     require(b != 0);
175     return a % b;
176   }
177 }
178 
179 
180 contract Accessibility {
181   address private owner;
182   modifier onlyOwner() {
183     require(msg.sender == owner, "access denied");
184     _;
185   }
186 
187   constructor() public {
188     owner = msg.sender;
189   }
190 
191   function disown() internal {
192     delete owner;
193   }
194 }
195 
196 
197 contract Rev1Storage {
198   function investorShortInfo(address addr) public view returns(uint value, uint refBonus); 
199 }
200 
201 
202 contract Rev2Storage {
203   function investorInfo(address addr) public view returns(uint investment, uint paymentTime); 
204 }
205 
206 
207 library PrivateEntrance {
208   using PrivateEntrance for privateEntrance;
209   using Math for uint;
210   struct privateEntrance {
211     Rev1Storage rev1Storage;
212     Rev2Storage rev2Storage;
213     uint investorMaxInvestment;
214     uint endTimestamp;
215     mapping(address=>bool) hasAccess;
216   }
217 
218   function isActive(privateEntrance storage pe) internal view returns(bool) {
219     return pe.endTimestamp > now;
220   }
221 
222   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
223     if (!pe.hasAccess[investorAddr]) {
224       return 0;
225     }
226 
227     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
228     if (maxInvestment == 0) {
229       return 0;
230     }
231     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
232 
233     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
234     
235     if (currInvestment >= maxInvestment) {
236       return 0;
237     }
238 
239     return maxInvestment-currInvestment;
240   }
241 
242   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
243     for (uint16 i; i < addrs.length; i++) {
244       pe.hasAccess[addrs[i]] = true;
245     }
246   }
247 }
248 
249 
250 contract InvestorsStorage is Accessibility {
251   struct Investor {
252     uint investment;
253     uint paymentTime;
254   }
255   uint public size;
256 
257   mapping (address => Investor) private investors;
258 
259   function isInvestor(address addr) public view returns (bool) {
260     return investors[addr].investment > 0;
261   }
262 
263   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
264     investment = investors[addr].investment;
265     paymentTime = investors[addr].paymentTime;
266   }
267 
268   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
269     Investor storage inv = investors[addr];
270     if (inv.investment != 0 || investment == 0) {
271       return false;
272     }
273     inv.investment = investment;
274     inv.paymentTime = paymentTime;
275     size++;
276     return true;
277   }
278 
279   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
280     if (investors[addr].investment == 0) {
281       return false;
282     }
283     investors[addr].investment += investment;
284     return true;
285   }
286 
287   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
288     if (investors[addr].investment == 0) {
289       return false;
290     }
291     investors[addr].paymentTime = paymentTime;
292     return true;
293   }
294 
295   function disqalify(address addr) public onlyOwner returns (bool) {
296     if (isInvestor(addr)) {
297       investors[addr].investment = 0;
298     }
299   }
300 }
301 
302 
303 library RapidGrowthProtection {
304   using RapidGrowthProtection for rapidGrowthProtection;
305   
306   struct rapidGrowthProtection {
307     uint startTimestamp;
308     uint maxDailyTotalInvestment;
309     uint8 activityDays;
310     mapping(uint8 => uint) dailyTotalInvestment;
311   }
312 
313   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
314     uint day = rgp.currDay();
315     if (day == 0 || day > rgp.activityDays) {
316       return 0;
317     }
318     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
319       return 0;
320     }
321     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
322   }
323 
324   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
325     uint day = rgp.currDay();
326     return day != 0 && day <= rgp.activityDays;
327   }
328 
329   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
330     uint day = rgp.currDay();
331     if (day == 0 || day > rgp.activityDays) {
332       return false;
333     }
334     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
335       return false;
336     }
337     rgp.dailyTotalInvestment[uint8(day)] += investment;
338     return true;
339   }
340 
341   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal { 
342     rgp.startTimestamp = timestamp;
343 
344     // restart
345     for (uint8 i = 1; i <= rgp.activityDays; i++) {
346       if (rgp.dailyTotalInvestment[i] != 0) {
347         delete rgp.dailyTotalInvestment[i];
348       }
349     }
350   }
351 
352   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
353     if (rgp.startTimestamp > now) {
354       return 0;
355     }
356     day = (now - rgp.startTimestamp) / 24 hours + 1; 
357   }
358 }
359 
360 contract BitCar is Accessibility {
361   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
362   using PrivateEntrance for PrivateEntrance.privateEntrance;
363   using Percent for Percent.percent;
364   using SafeMath for uint;
365   using Math for uint;
366 
367   // easy read for investors
368   using Address for *;
369   using Zero for *; 
370   
371   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
372   PrivateEntrance.privateEntrance private m_privEnter;
373   mapping(address => bool) private m_referrals;
374   InvestorsStorage private m_investors;
375 
376   // automatically generates getters
377   uint public constant minInvesment = 10 finney; 
378   uint public constant maxBalance = 500e5 ether; 
379   address public advertisingAddress;
380   address public adminsAddress;
381   uint public investmentsNumber;
382   uint public waveStartup;
383 
384   // percents 
385   Percent.percent private m_5_percent = Percent.percent(2,100);
386   Percent.percent private m_6_percent = Percent.percent(3,100);
387   Percent.percent private m_7_percent = Percent.percent(35,1000);
388   Percent.percent private m_8_percent = Percent.percent(4,100);
389   Percent.percent private m_9_percent = Percent.percent(45,1000);
390   Percent.percent private m_10_percent = Percent.percent(5,100);
391   Percent.percent private m_11_percent = Percent.percent(5,100);
392   Percent.percent private m_12_percent = Percent.percent(5,100);
393   Percent.percent private m_referal_percent = Percent.percent(2,100);
394   Percent.percent private m_referrer_percent = Percent.percent(3,100);
395   Percent.percent private m_referrer_percentMax = Percent.percent(6,100);
396   Percent.percent private m_adminsPercent = Percent.percent(15,100);
397   Percent.percent private m_advertisingPercent = Percent.percent(35,100);
398 
399   // more events for easy read from blockchain
400   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
401   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
402   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
403   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
404   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
405   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
406   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
407   event LogPayDividends(address indexed addr, uint when, uint dividends);
408   event LogNewInvestor(address indexed addr, uint when);
409   event LogBalanceChanged(uint when, uint balance);
410   event LogNextWave(uint when);
411   event LogDisown(uint when);
412 
413 
414   modifier balanceChanged {
415     _;
416     emit LogBalanceChanged(now, address(this).balance);
417   }
418 
419   modifier notFromContract() {
420     require(msg.sender.isNotContract(), "only externally accounts");
421     _;
422   }
423 
424   constructor() public {
425     adminsAddress = msg.sender;
426     advertisingAddress = msg.sender;
427     nextWave();
428   }
429 
430   function() public payable {
431     // investor get him dividends
432     if (msg.value.isZero()) {
433       getMyDividends();
434       return;
435     }
436 
437     // sender do invest
438     doInvest(msg.data.toAddress());
439   }
440 
441   function disqualifyAddress(address addr) public onlyOwner {
442     m_investors.disqalify(addr);
443   }
444 
445   function doDisown() public onlyOwner {
446     disown();
447     emit LogDisown(now);
448   }
449 
450   function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
451     // init Rapid Growth Protection
452     m_rgp.startTimestamp = timestamp + 1;
453     m_rgp.maxDailyTotalInvestment = 500 ether;
454     m_rgp.activityDays = 21;
455     emit LogRGPInit(
456       now, 
457       m_rgp.startTimestamp,
458       m_rgp.maxDailyTotalInvestment,
459       m_rgp.activityDays
460     );
461 
462 
463     // init Private Entrance
464     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
465     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
466     m_privEnter.investorMaxInvestment = 50 ether;
467     m_privEnter.endTimestamp = timestamp;
468     emit LogPEInit(
469       now, 
470       address(m_privEnter.rev1Storage), 
471       address(m_privEnter.rev2Storage), 
472       m_privEnter.investorMaxInvestment, 
473       m_privEnter.endTimestamp
474     );
475   }
476 
477   function setAdvertisingAddress(address addr) public onlyOwner {
478     addr.requireNotZero();
479     advertisingAddress = addr;
480   }
481 
482   function setAdminsAddress(address addr) public onlyOwner {
483     addr.requireNotZero();
484     adminsAddress = addr;
485   }
486 
487   function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
488     m_privEnter.provideAccessFor(addrs);
489   }
490 
491   function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
492     investment = m_rgp.maxInvestmentAtNow();
493   }
494 
495   function investorsNumber() public view returns(uint) {
496     return m_investors.size();
497   }
498 
499   function balanceETH() public view returns(uint) {
500     return address(this).balance;
501   }
502 
503   function advertisingPercent() public view returns(uint numerator, uint denominator) {
504     (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
505   }
506 
507   function adminsPercent() public view returns(uint numerator, uint denominator) {
508     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
509   }
510 
511   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
512     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
513     isReferral = m_referrals[investorAddr];
514   }
515 
516   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
517     dividends = calcDividends(investorAddr);
518   }
519 
520   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
521     Percent.percent memory p = dailyPercent();
522     (numerator, denominator) = (p.num, p.den);
523   }
524 
525   function getMyDividends() public notFromContract balanceChanged {
526     // calculate dividends
527     
528     //check if 1 day passed after last payment
529     require(now.sub(getMemInvestor(msg.sender).paymentTime) > 24 hours);
530 
531     uint dividends = calcDividends(msg.sender);
532     require (dividends.notZero(), "cannot to pay zero dividends");
533 
534     // update investor payment timestamp
535     assert(m_investors.setPaymentTime(msg.sender, now));
536 
537     // check enough eth - goto next wave if needed
538     if (address(this).balance <= dividends) {
539       nextWave();
540       dividends = address(this).balance;
541     } 
542 
543     // transfer dividends to investor
544     msg.sender.transfer(dividends);
545     emit LogPayDividends(msg.sender, now, dividends);
546   }
547 
548   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
549     uint investment = msg.value;
550     uint receivedEther = msg.value;
551     require(investment >= minInvesment, "investment must be >= minInvesment");
552     require(address(this).balance <= maxBalance, "the contract eth balance limit");
553 
554     if (m_rgp.isActive()) { 
555       // use Rapid Growth Protection if needed
556       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
557       rpgMaxInvest.requireNotZero();
558       investment = Math.min(investment, rpgMaxInvest);
559       assert(m_rgp.saveInvestment(investment));
560       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
561       
562     } else if (m_privEnter.isActive()) {
563       // use Private Entrance if needed
564       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
565       peMaxInvest.requireNotZero();
566       investment = Math.min(investment, peMaxInvest);
567     }
568 
569     // send excess of ether if needed
570     if (receivedEther > investment) {
571       uint excess = receivedEther - investment;
572       msg.sender.transfer(excess);
573       receivedEther = investment;
574       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
575     }
576 
577     // commission
578     advertisingAddress.send(m_advertisingPercent.mul(receivedEther));
579     adminsAddress.send(m_adminsPercent.mul(receivedEther));
580 
581     bool senderIsInvestor = m_investors.isInvestor(msg.sender);
582 
583     // ref system works only once and only on first invest
584     if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
585       referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
586       
587       m_referrals[msg.sender] = true;
588       // add referral bonus to investor`s and referral`s investments
589       uint referrerBonus = m_referrer_percent.mmul(investment);
590       if (investment > 10 ether) {
591         referrerBonus = m_referrer_percentMax.mmul(investment);
592       }
593       
594       uint referalBonus = m_referal_percent.mmul(investment);
595       assert(m_investors.addInvestment(referrerAddr, referrerBonus)); // add referrer bonus
596       investment += referalBonus;                                    // add referral bonus
597       emit LogNewReferral(msg.sender, referrerAddr, now, referalBonus);
598     }
599 
600     // automatic reinvest - prevent burning dividends
601     uint dividends = calcDividends(msg.sender);
602     if (senderIsInvestor && dividends.notZero()) {
603       investment += dividends;
604       emit LogAutomaticReinvest(msg.sender, now, dividends);
605     }
606 
607     if (senderIsInvestor) {
608       // update existing investor
609       assert(m_investors.addInvestment(msg.sender, investment));
610       assert(m_investors.setPaymentTime(msg.sender, now));
611     } else {
612       // create new investor
613       assert(m_investors.newInvestor(msg.sender, investment, now));
614       emit LogNewInvestor(msg.sender, now);
615     }
616 
617     investmentsNumber++;
618     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
619   }
620 
621   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
622     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
623     return InvestorsStorage.Investor(investment, paymentTime);
624   }
625 
626   function calcDividends(address investorAddr) internal view returns(uint dividends) {
627     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
628 
629     // safe gas if dividends will be 0
630     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
631       return 0;
632     }
633     
634     // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
635     Percent.percent memory p = dailyPercent();
636     dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
637   }
638 
639   function dailyPercent() internal view returns(Percent.percent memory p) {
640     uint balance = address(this).balance;
641 
642     if (balance < 5 ether) { 
643       p = m_5_percent.toMemory(); 
644     } else if ( 5 ether <= balance && balance <= 10 ether) {
645       p = m_6_percent.toMemory();    
646     } else if ( 10 ether <= balance && balance <= 20 ether) {
647       p = m_7_percent.toMemory();   
648     } else if ( 20 ether <= balance && balance <= 50 ether) {
649       p = m_8_percent.toMemory();  
650     } else if ( 50 ether <= balance && balance <= 100 ether) {
651       p = m_9_percent.toMemory();    
652     } else if ( 100 ether <= balance && balance <= 300 ether) {
653       p = m_10_percent.toMemory();  
654     } else if ( 300 ether <= balance && balance <= 500 ether) {
655       p = m_11_percent.toMemory();   
656     } else {
657       p = m_12_percent.toMemory();    
658     } 
659   }
660 
661   function nextWave() private {
662     m_investors = new InvestorsStorage();
663     investmentsNumber = 0;
664     waveStartup = now;
665     m_rgp.startAt(now);
666     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
667     emit LogNextWave(now);
668   }
669 }