1 pragma solidity 0.4.25;
2 
3 
4 /**
5 *
6 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 2.0
7 * Web              - https://eth-smart.com
8 
9 *
10 *
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
53   // Solidity automatically throws when dividing by 0
54   struct percent {
55     uint num;
56     uint den;
57   }
58 
59   // storage
60   function mul(percent storage p, uint a) internal view returns (uint) {
61     if (a == 0) {
62       return 0;
63     }
64     return a*p.num/p.den;
65   }
66 
67   function div(percent storage p, uint a) internal view returns (uint) {
68     return a/p.num*p.den;
69   }
70 
71   function sub(percent storage p, uint a) internal view returns (uint) {
72     uint b = mul(p, a);
73     if (b >= a) {
74       return 0;
75     }
76     return a - b;
77   }
78 
79   function add(percent storage p, uint a) internal view returns (uint) {
80     return a + mul(p, a);
81   }
82 
83   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
84     return Percent.percent(p.num, p.den);
85   }
86 
87   // memory
88   function mmul(percent memory p, uint a) internal pure returns (uint) {
89     if (a == 0) {
90       return 0;
91     }
92     return a*p.num/p.den;
93   }
94 
95   function mdiv(percent memory p, uint a) internal pure returns (uint) {
96     return a/p.num*p.den;
97   }
98 
99   function msub(percent memory p, uint a) internal pure returns (uint) {
100     uint b = mmul(p, a);
101     if (b >= a) {
102       return 0;
103     }
104     return a - b;
105   }
106 
107   function madd(percent memory p, uint a) internal pure returns (uint) {
108     return a + mmul(p, a);
109   }
110 }
111 
112 
113 library Address {
114   function toAddress(bytes source) internal pure returns(address addr) {
115     assembly { addr := mload(add(source,0x14)) }
116     return addr;
117   }
118 
119   function isNotContract(address addr) internal view returns(bool) {
120     uint length;
121     assembly { length := extcodesize(addr) }
122     return length == 0;
123   }
124 }
125 
126 
127 /**
128  * @title SafeMath
129  * @dev Math operations with safety checks that revert on error
130  */
131 library SafeMath {
132 
133   /**
134   * @dev Multiplies two numbers, reverts on overflow.
135   */
136   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
137     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138     // benefit is lost if 'b' is also tested.
139     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
140     if (_a == 0) {
141       return 0;
142     }
143 
144     uint256 c = _a * _b;
145     require(c / _a == _b);
146 
147     return c;
148   }
149 
150   /**
151   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
152   */
153   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
154     require(_b > 0); // Solidity only automatically asserts when dividing by 0
155     uint256 c = _a / _b;
156     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
157 
158     return c;
159   }
160 
161   /**
162   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
163   */
164   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
165     require(_b <= _a);
166     uint256 c = _a - _b;
167 
168     return c;
169   }
170 
171   /**
172   * @dev Adds two numbers, reverts on overflow.
173   */
174   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
175     uint256 c = _a + _b;
176     require(c >= _a);
177 
178     return c;
179   }
180 
181   /**
182   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
183   * reverts when dividing by zero.
184   */
185   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186     require(b != 0);
187     return a % b;
188   }
189 }
190 
191 
192 contract Accessibility {
193   address private owner;
194   modifier onlyOwner() {
195     require(msg.sender == owner, "access denied");
196     _;
197   }
198 
199   constructor() public {
200     owner = msg.sender;
201   }
202 
203   function disown() internal {
204     delete owner;
205   }
206 }
207 
208 
209 contract Rev1Storage {
210   function investorShortInfo(address addr) public view returns(uint value, uint refBonus);
211 }
212 
213 
214 contract Rev2Storage {
215   function investorInfo(address addr) public view returns(uint investment, uint paymentTime);
216 }
217 
218 
219 library PrivateEntrance {
220   using PrivateEntrance for privateEntrance;
221   using Math for uint;
222   struct privateEntrance {
223     Rev1Storage rev1Storage;
224     Rev2Storage rev2Storage;
225     uint investorMaxInvestment;
226     uint endTimestamp;
227     mapping(address=>bool) hasAccess;
228   }
229 
230   function isActive(privateEntrance storage pe) internal view returns(bool) {
231     return pe.endTimestamp > now;
232   }
233 
234   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
235     // check if investorAddr has access
236     if (!pe.hasAccess[investorAddr]) {
237       return 0;
238     }
239 
240     // get investor max investment = investment from revolution 1
241     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
242     if (maxInvestment == 0) {
243       return 0;
244     }
245     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
246 
247     // get current investment from revolution 2
248     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
249 
250     if (currInvestment >= maxInvestment) {
251       return 0;
252     }
253 
254     return maxInvestment-currInvestment;
255   }
256 
257   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
258     for (uint16 i; i < addrs.length; i++) {
259       pe.hasAccess[addrs[i]] = true;
260     }
261   }
262 }
263 
264 
265 contract InvestorsStorage is Accessibility {
266   struct Investor {
267     uint investment;
268     uint paymentTime;
269   }
270   uint public size;
271 
272   mapping (address => Investor) private investors;
273 
274   function isInvestor(address addr) public view returns (bool) {
275     return investors[addr].investment > 0;
276   }
277 
278   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
279     investment = investors[addr].investment;
280     paymentTime = investors[addr].paymentTime;
281   }
282 
283   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
284     Investor storage inv = investors[addr];
285     if (inv.investment != 0 || investment == 0) {
286       return false;
287     }
288     inv.investment = investment;
289     inv.paymentTime = paymentTime;
290     size++;
291     return true;
292   }
293 
294   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
295     if (investors[addr].investment == 0) {
296       return false;
297     }
298     investors[addr].investment += investment;
299     return true;
300   }
301 
302   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
303     if (investors[addr].investment == 0) {
304       return false;
305     }
306     investors[addr].paymentTime = paymentTime;
307     return true;
308   }
309 }
310 
311 
312 library RapidGrowthProtection {
313   using RapidGrowthProtection for rapidGrowthProtection;
314 
315   struct rapidGrowthProtection {
316     uint startTimestamp;
317     uint maxDailyTotalInvestment;
318     uint8 activityDays;
319     mapping(uint8 => uint) dailyTotalInvestment;
320   }
321 
322   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
323     uint day = rgp.currDay();
324     if (day == 0 || day > rgp.activityDays) {
325       return 0;
326     }
327     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
328       return 0;
329     }
330     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
331   }
332 
333   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
334     uint day = rgp.currDay();
335     return day != 0 && day <= rgp.activityDays;
336   }
337 
338   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
339     uint day = rgp.currDay();
340     if (day == 0 || day > rgp.activityDays) {
341       return false;
342     }
343     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
344       return false;
345     }
346     rgp.dailyTotalInvestment[uint8(day)] += investment;
347     return true;
348   }
349 
350   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal {
351     rgp.startTimestamp = timestamp;
352 
353     // restart
354     for (uint8 i = 1; i <= rgp.activityDays; i++) {
355       if (rgp.dailyTotalInvestment[i] != 0) {
356         delete rgp.dailyTotalInvestment[i];
357       }
358     }
359   }
360 
361   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
362     if (rgp.startTimestamp > now) {
363       return 0;
364     }
365     day = (now - rgp.startTimestamp) / 24 hours + 1; // +1 for skip zero day
366   }
367 }
368 
369 
370 
371 
372 
373 
374 
375 
376 contract Revolution2 is Accessibility {
377   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
378   using PrivateEntrance for PrivateEntrance.privateEntrance;
379   using Percent for Percent.percent;
380   using SafeMath for uint;
381   using Math for uint;
382 
383   // easy read for investors
384   using Address for *;
385   using Zero for *;
386 
387   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
388   PrivateEntrance.privateEntrance private m_privEnter;
389   mapping(address => bool) private m_referrals;
390   InvestorsStorage private m_investors;
391 
392   // automatically generates getters
393   uint public constant minInvesment = 10 finney; //       0.01 eth
394   uint public constant maxBalance = 333e5 ether; // 33 300 000 eth
395   address public advertisingAddress;
396   address public adminsAddress;
397   uint public investmentsNumber;
398   uint public waveStartup;
399 
400   // percents
401   Percent.percent private m_1_percent = Percent.percent(1, 100);           //   1/100  *100% = 1%
402   Percent.percent private m_2_percent = Percent.percent(2, 100);           //   2/100  *100% = 2%
403   Percent.percent private m_3_33_percent = Percent.percent(333, 10000);    // 333/10000*100% = 3.33%
404   Percent.percent private m_adminsPercent = Percent.percent(3, 100);       //   3/100  *100% = 3%
405   Percent.percent private m_advertisingPercent = Percent.percent(120, 1000);// 120/1000  *100% = 12%
406 
407   // more events for easy read from blockchain
408   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
409   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
410   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
411   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
412   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
413   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
414   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
415   event LogPayDividends(address indexed addr, uint when, uint dividends);
416   event LogNewInvestor(address indexed addr, uint when);
417   event LogBalanceChanged(uint when, uint balance);
418   event LogNextWave(uint when);
419   event LogDisown(uint when);
420 
421 
422   modifier balanceChanged {
423     _;
424     emit LogBalanceChanged(now, address(this).balance);
425   }
426 
427   modifier notFromContract() {
428     require(msg.sender.isNotContract(), "only externally accounts");
429     _;
430   }
431 
432   constructor() public {
433     adminsAddress = msg.sender;
434     advertisingAddress = msg.sender;
435     nextWave();
436   }
437 
438   function() public payable {
439     // investor get him dividends
440     if (msg.value.isZero()) {
441       getMyDividends();
442       return;
443     }
444 
445     // sender do invest
446     doInvest(msg.data.toAddress());
447   }
448 
449   function doDisown() public onlyOwner {
450     disown();
451     emit LogDisown(now);
452   }
453 
454   function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
455     // init Rapid Growth Protection
456     m_rgp.startTimestamp = timestamp + 1;
457     m_rgp.maxDailyTotalInvestment = 500 ether;
458     m_rgp.activityDays = 21;
459     emit LogRGPInit(
460       now,
461       m_rgp.startTimestamp,
462       m_rgp.maxDailyTotalInvestment,
463       m_rgp.activityDays
464     );
465 
466 
467     // init Private Entrance
468     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
469     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
470     m_privEnter.investorMaxInvestment = 50 ether;
471     m_privEnter.endTimestamp = timestamp;
472     emit LogPEInit(
473       now,
474       address(m_privEnter.rev1Storage),
475       address(m_privEnter.rev2Storage),
476       m_privEnter.investorMaxInvestment,
477       m_privEnter.endTimestamp
478     );
479   }
480 
481   function setAdvertisingAddress(address addr) public onlyOwner {
482     addr.requireNotZero();
483     advertisingAddress = addr;
484   }
485 
486   function setAdminsAddress(address addr) public onlyOwner {
487     addr.requireNotZero();
488     adminsAddress = addr;
489   }
490 
491   function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
492     m_privEnter.provideAccessFor(addrs);
493   }
494 
495   function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
496     investment = m_rgp.maxInvestmentAtNow();
497   }
498 
499   function investorsNumber() public view returns(uint) {
500     return m_investors.size();
501   }
502 
503   function balanceETH() public view returns(uint) {
504     return address(this).balance;
505   }
506 
507   function percent1() public view returns(uint numerator, uint denominator) {
508     (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
509   }
510 
511   function percent2() public view returns(uint numerator, uint denominator) {
512     (numerator, denominator) = (m_2_percent.num, m_2_percent.den);
513   }
514 
515   function percent3_33() public view returns(uint numerator, uint denominator) {
516     (numerator, denominator) = (m_3_33_percent.num, m_3_33_percent.den);
517   }
518 
519   function advertisingPercent() public view returns(uint numerator, uint denominator) {
520     (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
521   }
522 
523   function adminsPercent() public view returns(uint numerator, uint denominator) {
524     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
525   }
526 
527   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
528     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
529     isReferral = m_referrals[investorAddr];
530   }
531 
532   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
533     dividends = calcDividends(investorAddr);
534   }
535 
536   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
537     Percent.percent memory p = dailyPercent();
538     (numerator, denominator) = (p.num, p.den);
539   }
540 
541   function refBonusPercentAtNow() public view returns(uint numerator, uint denominator) {
542     Percent.percent memory p = refBonusPercent();
543     (numerator, denominator) = (p.num, p.den);
544   }
545 
546   function getMyDividends() public notFromContract balanceChanged {
547     // calculate dividends
548     uint dividends = calcDividends(msg.sender);
549     require (dividends.notZero(), "cannot to pay zero dividends");
550 
551     // update investor payment timestamp
552     assert(m_investors.setPaymentTime(msg.sender, now));
553 
554     // check enough eth - goto next wave if needed
555     if (address(this).balance <= dividends) {
556       nextWave();
557       dividends = address(this).balance;
558     }
559 
560     // transfer dividends to investor
561     msg.sender.transfer(dividends);
562     emit LogPayDividends(msg.sender, now, dividends);
563   }
564 
565   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
566     uint investment = msg.value;
567     uint receivedEther = msg.value;
568     require(investment >= minInvesment, "investment must be >= minInvesment");
569     require(address(this).balance <= maxBalance, "the contract eth balance limit");
570 
571     if (m_rgp.isActive()) {
572       // use Rapid Growth Protection if needed
573       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
574       rpgMaxInvest.requireNotZero();
575       investment = Math.min(investment, rpgMaxInvest);
576       assert(m_rgp.saveInvestment(investment));
577       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
578 
579     } else if (m_privEnter.isActive()) {
580       // use Private Entrance if needed
581       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
582       peMaxInvest.requireNotZero();
583       investment = Math.min(investment, peMaxInvest);
584     }
585 
586     // send excess of ether if needed
587     if (receivedEther > investment) {
588       uint excess = receivedEther - investment;
589       msg.sender.transfer(excess);
590       receivedEther = investment;
591       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
592     }
593 
594     // commission
595     advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
596     adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
597 
598     bool senderIsInvestor = m_investors.isInvestor(msg.sender);
599 
600     // ref system works only once and only on first invest
601     if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
602       referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
603 
604       m_referrals[msg.sender] = true;
605       // add referral bonus to investor`s and referral`s investments
606       uint refBonus = refBonusPercent().mmul(investment);
607       assert(m_investors.addInvestment(referrerAddr, refBonus)); // add referrer bonus
608       investment += refBonus;                                    // add referral bonus
609       emit LogNewReferral(msg.sender, referrerAddr, now, refBonus);
610     }
611 
612     // automatic reinvest - prevent burning dividends
613     uint dividends = calcDividends(msg.sender);
614     if (senderIsInvestor && dividends.notZero()) {
615       investment += dividends;
616       emit LogAutomaticReinvest(msg.sender, now, dividends);
617     }
618 
619     if (senderIsInvestor) {
620       // update existing investor
621       assert(m_investors.addInvestment(msg.sender, investment));
622       assert(m_investors.setPaymentTime(msg.sender, now));
623     } else {
624       // create new investor
625       assert(m_investors.newInvestor(msg.sender, investment, now));
626       emit LogNewInvestor(msg.sender, now);
627     }
628 
629     investmentsNumber++;
630     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
631   }
632 
633   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
634     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
635     return InvestorsStorage.Investor(investment, paymentTime);
636   }
637 
638   function calcDividends(address investorAddr) internal view returns(uint dividends) {
639     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
640 
641     // safe gas if dividends will be 0
642     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
643       return 0;
644     }
645 
646     // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
647     // if daily percent is X, then 10min percent = X / (24h / 10 min) = X / 144
648 
649     // and we must to get numbers of 10 min interval after investor got payment:
650     // (now - investor.paymentTime) / 10min
651 
652     // finaly calculate dividends = ((now - investor.paymentTime) / 10min) * (X * investor.investment)  / 144)
653 
654     Percent.percent memory p = dailyPercent();
655     dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
656   }
657 
658   function dailyPercent() internal view returns(Percent.percent memory p) {
659     uint balance = address(this).balance;
660 
661     // (3) 3.33% if balance < 1 000 ETH
662     // (2) 2% if 1 000 ETH <= balance <= 33 333 ETH
663     // (1) 1% if 33 333 ETH < balance
664 
665     if (balance < 1000 ether) {
666       p = m_3_33_percent.toMemory(); // (3)
667     } else if ( 1000 ether <= balance && balance <= 33333 ether) {
668       p = m_2_percent.toMemory();    // (2)
669     } else {
670       p = m_1_percent.toMemory();    // (1)
671     }
672   }
673 
674   function refBonusPercent() internal view returns(Percent.percent memory p) {
675     uint balance = address(this).balance;
676 
677     // (1) 1% if 100 000 ETH < balance
678     // (2) 2% if 10 000 ETH <= balance <= 100 000 ETH
679     // (3) 3.33% if balance < 10 000 ETH
680 
681     if (balance < 10000 ether) {
682       p = m_3_33_percent.toMemory(); // (3)
683     } else if ( 10000 ether <= balance && balance <= 100000 ether) {
684       p = m_2_percent.toMemory();    // (2)
685     } else {
686       p = m_1_percent.toMemory();    // (1)
687     }
688   }
689 
690   function nextWave() private {
691     m_investors = new InvestorsStorage();
692     investmentsNumber = 0;
693     waveStartup = now;
694     m_rgp.startAt(now);
695     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
696     emit LogNextWave(now);
697   }
698 }