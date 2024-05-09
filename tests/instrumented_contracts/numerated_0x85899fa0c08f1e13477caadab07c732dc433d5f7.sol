1 pragma solidity 0.4.25;
2 
3 
4 /**
5 *
6 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 1.0
7 * Web              - https://fortune333.online
8 * GitHub           - https://github.com/fortune333/Fortune333
9 * Email:             mailto:support(at sign)fortune333token
10 * 
11 * 
12 *  - GAIN 3,33% - 1% PER 24 HOURS (interest is charges in equal parts every 10 min)
13 *  - Life-long payments
14 *  - Unprecedentedly reliable
15 *  - Bringer Fortune
16 *  - Minimal contribution 0.01 eth
17 *  - Currency and payment - ETH
18 *  - Contribution allocation schemes:
19 *    -- 87,5% payments
20 *    --  7,5% marketing
21 *    --  5,0% technical support
22 *
23 *   ---About the Project
24 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
25 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
26 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
27 *  freely accessed online. In order to insure our investors' complete security, full control over the 
28 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
29 *  system's permanent autonomous functioning.
30 * 
31 * ---How to use:
32 *  1. Send from ETH wallet to the smart contract address 
33 *     any amount from 0.01 ETH.
34 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
35 *     of your wallet.
36 *  3a. Claim your profit by sending 0 ether transaction (every 10 min, every day, every week, i don't care unless you're 
37 *      spending too much on GAS)
38 *  OR
39 *  3b. For reinvest, you need to deposit the amount that you want to reinvest and the 
40 *      accrued interest automatically summed to your new contribution.
41 *  
42 * RECOMMENDED GAS LIMIT: 200000
43 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
44 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
45 *
46 * ---Refferral system:
47 *     from 0 to 10.000 ethers in the fund - remuneration to each contributor is 3.33%, 
48 *     from 10.000 to 100.000 ethers in the fund - remuneration will be 2%, 
49 *     from 100.000 ethers in the fund - each contributor will get 1%.
50 *
51 * ---It is not allowed to transfer from exchanges, ONLY from your personal ETH wallet, for which you 
52 * have private keys.
53 * 
54 * Contracts reviewed and approved by pros!
55 * 
56 * Main contract - Fortune. Scroll down to find it.
57 */ 
58 
59 
60 library Math {
61   function min(uint a, uint b) internal pure returns(uint) {
62     if (a > b) {
63       return b;
64     }
65     return a;
66   }
67 }
68 
69 
70 library Zero {
71   function requireNotZero(address addr) internal pure {
72     require(addr != address(0), "require not zero address");
73   }
74 
75   function requireNotZero(uint val) internal pure {
76     require(val != 0, "require not zero value");
77   }
78 
79   function notZero(address addr) internal pure returns(bool) {
80     return !(addr == address(0));
81   }
82 
83   function isZero(address addr) internal pure returns(bool) {
84     return addr == address(0);
85   }
86 
87   function isZero(uint a) internal pure returns(bool) {
88     return a == 0;
89   }
90 
91   function notZero(uint a) internal pure returns(bool) {
92     return a != 0;
93   }
94 }
95 
96 
97 library Percent {
98   // Solidity automatically throws when dividing by 0
99   struct percent {
100     uint num;
101     uint den;
102   }
103   
104   // storage
105   function mul(percent storage p, uint a) internal view returns (uint) {
106     if (a == 0) {
107       return 0;
108     }
109     return a*p.num/p.den;
110   }
111 
112   function div(percent storage p, uint a) internal view returns (uint) {
113     return a/p.num*p.den;
114   }
115 
116   function sub(percent storage p, uint a) internal view returns (uint) {
117     uint b = mul(p, a);
118     if (b >= a) {
119       return 0;
120     }
121     return a - b;
122   }
123 
124   function add(percent storage p, uint a) internal view returns (uint) {
125     return a + mul(p, a);
126   }
127 
128   function toMemory(percent storage p) internal view returns (Percent.percent memory) {
129     return Percent.percent(p.num, p.den);
130   }
131 
132   // memory 
133   function mmul(percent memory p, uint a) internal pure returns (uint) {
134     if (a == 0) {
135       return 0;
136     }
137     return a*p.num/p.den;
138   }
139 
140   function mdiv(percent memory p, uint a) internal pure returns (uint) {
141     return a/p.num*p.den;
142   }
143 
144   function msub(percent memory p, uint a) internal pure returns (uint) {
145     uint b = mmul(p, a);
146     if (b >= a) {
147       return 0;
148     }
149     return a - b;
150   }
151 
152   function madd(percent memory p, uint a) internal pure returns (uint) {
153     return a + mmul(p, a);
154   }
155 }
156 
157 
158 library Address {
159   function toAddress(bytes source) internal pure returns(address addr) {
160     assembly { addr := mload(add(source,0x14)) }
161     return addr;
162   }
163 
164   function isNotContract(address addr) internal view returns(bool) {
165     uint length;
166     assembly { length := extcodesize(addr) }
167     return length == 0;
168   }
169 }
170 
171 
172 /**
173  * @title SafeMath
174  * @dev Math operations with safety checks that revert on error
175  */
176 library SafeMath {
177 
178   /**
179   * @dev Multiplies two numbers, reverts on overflow.
180   */
181   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
182     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183     // benefit is lost if 'b' is also tested.
184     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
185     if (_a == 0) {
186       return 0;
187     }
188 
189     uint256 c = _a * _b;
190     require(c / _a == _b);
191 
192     return c;
193   }
194 
195   /**
196   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
197   */
198   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
199     require(_b > 0); // Solidity only automatically asserts when dividing by 0
200     uint256 c = _a / _b;
201     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
202 
203     return c;
204   }
205 
206   /**
207   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
208   */
209   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
210     require(_b <= _a);
211     uint256 c = _a - _b;
212 
213     return c;
214   }
215 
216   /**
217   * @dev Adds two numbers, reverts on overflow.
218   */
219   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
220     uint256 c = _a + _b;
221     require(c >= _a);
222 
223     return c;
224   }
225 
226   /**
227   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
228   * reverts when dividing by zero.
229   */
230   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231     require(b != 0);
232     return a % b;
233   }
234 }
235 
236 
237 contract Accessibility {
238   address private owner;
239   modifier onlyOwner() {
240     require(msg.sender == owner, "access denied");
241     _;
242   }
243 
244   constructor() public {
245     owner = msg.sender;
246   }
247 
248   function disown() internal {
249     delete owner;
250   }
251 }
252 
253 
254 contract Rev1Storage {
255   function investorShortInfo(address addr) public view returns(uint value, uint refBonus); 
256 }
257 
258 
259 contract Rev2Storage {
260   function investorInfo(address addr) public view returns(uint investment, uint paymentTime); 
261 }
262 
263 
264 library PrivateEntrance {
265   using PrivateEntrance for privateEntrance;
266   using Math for uint;
267   struct privateEntrance {
268     Rev1Storage rev1Storage;
269     Rev2Storage rev2Storage;
270     uint investorMaxInvestment;
271     uint endTimestamp;
272     mapping(address=>bool) hasAccess;
273   }
274 
275   function isActive(privateEntrance storage pe) internal view returns(bool) {
276     return pe.endTimestamp > now;
277   }
278 
279   function maxInvestmentFor(privateEntrance storage pe, address investorAddr) internal view returns(uint) {
280     // check if investorAddr has access
281     if (!pe.hasAccess[investorAddr]) {
282       return 0;
283     }
284 
285     // get investor max investment = investment from revolution 1
286     (uint maxInvestment, ) = pe.rev1Storage.investorShortInfo(investorAddr);
287     if (maxInvestment == 0) {
288       return 0;
289     }
290     maxInvestment = Math.min(maxInvestment, pe.investorMaxInvestment);
291 
292     // get current investment from revolution 2
293     (uint currInvestment, ) = pe.rev2Storage.investorInfo(investorAddr);
294     
295     if (currInvestment >= maxInvestment) {
296       return 0;
297     }
298 
299     return maxInvestment-currInvestment;
300   }
301 
302   function provideAccessFor(privateEntrance storage pe, address[] addrs) internal {
303     for (uint16 i; i < addrs.length; i++) {
304       pe.hasAccess[addrs[i]] = true;
305     }
306   }
307 }
308 
309 
310 contract InvestorsStorage is Accessibility {
311   struct Investor {
312     uint investment;
313     uint paymentTime;
314   }
315   uint public size;
316 
317   mapping (address => Investor) private investors;
318 
319   function isInvestor(address addr) public view returns (bool) {
320     return investors[addr].investment > 0;
321   }
322 
323   function investorInfo(address addr) public view returns(uint investment, uint paymentTime) {
324     investment = investors[addr].investment;
325     paymentTime = investors[addr].paymentTime;
326   }
327 
328   function newInvestor(address addr, uint investment, uint paymentTime) public onlyOwner returns (bool) {
329     Investor storage inv = investors[addr];
330     if (inv.investment != 0 || investment == 0) {
331       return false;
332     }
333     inv.investment = investment;
334     inv.paymentTime = paymentTime;
335     size++;
336     return true;
337   }
338 
339   function addInvestment(address addr, uint investment) public onlyOwner returns (bool) {
340     if (investors[addr].investment == 0) {
341       return false;
342     }
343     investors[addr].investment += investment;
344     return true;
345   }
346 
347   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
348     if (investors[addr].investment == 0) {
349       return false;
350     }
351     investors[addr].paymentTime = paymentTime;
352     return true;
353   }
354 }
355 
356 
357 library RapidGrowthProtection {
358   using RapidGrowthProtection for rapidGrowthProtection;
359   
360   struct rapidGrowthProtection {
361     uint startTimestamp;
362     uint maxDailyTotalInvestment;
363     uint8 activityDays;
364     mapping(uint8 => uint) dailyTotalInvestment;
365   }
366 
367   function maxInvestmentAtNow(rapidGrowthProtection storage rgp) internal view returns(uint) {
368     uint day = rgp.currDay();
369     if (day == 0 || day > rgp.activityDays) {
370       return 0;
371     }
372     if (rgp.dailyTotalInvestment[uint8(day)] >= rgp.maxDailyTotalInvestment) {
373       return 0;
374     }
375     return rgp.maxDailyTotalInvestment - rgp.dailyTotalInvestment[uint8(day)];
376   }
377 
378   function isActive(rapidGrowthProtection storage rgp) internal view returns(bool) {
379     uint day = rgp.currDay();
380     return day != 0 && day <= rgp.activityDays;
381   }
382 
383   function saveInvestment(rapidGrowthProtection storage rgp, uint investment) internal returns(bool) {
384     uint day = rgp.currDay();
385     if (day == 0 || day > rgp.activityDays) {
386       return false;
387     }
388     if (rgp.dailyTotalInvestment[uint8(day)] + investment > rgp.maxDailyTotalInvestment) {
389       return false;
390     }
391     rgp.dailyTotalInvestment[uint8(day)] += investment;
392     return true;
393   }
394 
395   function startAt(rapidGrowthProtection storage rgp, uint timestamp) internal { 
396     rgp.startTimestamp = timestamp;
397 
398     // restart
399     for (uint8 i = 1; i <= rgp.activityDays; i++) {
400       if (rgp.dailyTotalInvestment[i] != 0) {
401         delete rgp.dailyTotalInvestment[i];
402       }
403     }
404   }
405 
406   function currDay(rapidGrowthProtection storage rgp) internal view returns(uint day) {
407     if (rgp.startTimestamp > now) {
408       return 0;
409     }
410     day = (now - rgp.startTimestamp) / 24 hours + 1; // +1 for skip zero day
411   }
412 }
413 
414 
415 
416 
417 
418 
419 
420 
421 contract Fortune is Accessibility {
422   using RapidGrowthProtection for RapidGrowthProtection.rapidGrowthProtection;
423   using PrivateEntrance for PrivateEntrance.privateEntrance;
424   using Percent for Percent.percent;
425   using SafeMath for uint;
426   using Math for uint;
427 
428   // easy read for investors
429   using Address for *;
430   using Zero for *; 
431   
432   RapidGrowthProtection.rapidGrowthProtection private m_rgp;
433   PrivateEntrance.privateEntrance private m_privEnter;
434   mapping(address => bool) private m_referrals;
435   InvestorsStorage private m_investors;
436 
437   // automatically generates getters
438   uint public constant minInvesment = 10 finney; //       0.01 eth
439   uint public constant maxBalance = 333e5 ether; // 33 300 000 eth
440   address public advertisingAddress;
441   address public adminsAddress;
442   uint public investmentsNumber;
443   uint public waveStartup;
444 
445   // percents 
446   Percent.percent private m_1_percent = Percent.percent(1, 100);           //   1/100  *100% = 1%
447   Percent.percent private m_2_percent = Percent.percent(2, 100);           //   2/100  *100% = 2%
448   Percent.percent private m_3_33_percent = Percent.percent(333, 10000);    // 333/10000*100% = 3.33%
449   Percent.percent private m_adminsPercent = Percent.percent(5, 100);       //   5/100  *100% = 5%
450   Percent.percent private m_advertisingPercent = Percent.percent(75, 1000);// 75/1000  *100% = 7.5%
451 
452   // more events for easy read from blockchain
453   event LogPEInit(uint when, address rev1Storage, address rev2Storage, uint investorMaxInvestment, uint endTimestamp);
454   event LogSendExcessOfEther(address indexed addr, uint when, uint value, uint investment, uint excess);
455   event LogNewReferral(address indexed addr, address indexed referrerAddr, uint when, uint refBonus);
456   event LogRGPInit(uint when, uint startTimestamp, uint maxDailyTotalInvestment, uint activityDays);
457   event LogRGPInvestment(address indexed addr, uint when, uint investment, uint indexed day);
458   event LogNewInvesment(address indexed addr, uint when, uint investment, uint value);
459   event LogAutomaticReinvest(address indexed addr, uint when, uint investment);
460   event LogPayDividends(address indexed addr, uint when, uint dividends);
461   event LogNewInvestor(address indexed addr, uint when);
462   event LogBalanceChanged(uint when, uint balance);
463   event LogNextWave(uint when);
464   event LogDisown(uint when);
465 
466 
467   modifier balanceChanged {
468     _;
469     emit LogBalanceChanged(now, address(this).balance);
470   }
471 
472   modifier notFromContract() {
473     require(msg.sender.isNotContract(), "only externally accounts");
474     _;
475   }
476 
477   constructor() public {
478     adminsAddress = msg.sender;
479     advertisingAddress = msg.sender;
480     nextWave();
481   }
482 
483   function() public payable {
484     // investor get him dividends
485     if (msg.value.isZero()) {
486       getMyDividends();
487       return;
488     }
489 
490     // sender do invest
491     doInvest(msg.data.toAddress());
492   }
493 
494   function doDisown() public onlyOwner {
495     disown();
496     emit LogDisown(now);
497   }
498 
499   function init(address rev1StorageAddr, uint timestamp) public onlyOwner {
500     // init Rapid Growth Protection
501     m_rgp.startTimestamp = timestamp + 1;
502     m_rgp.maxDailyTotalInvestment = 500 ether;
503     m_rgp.activityDays = 21;
504     emit LogRGPInit(
505       now, 
506       m_rgp.startTimestamp,
507       m_rgp.maxDailyTotalInvestment,
508       m_rgp.activityDays
509     );
510 
511 
512     // init Private Entrance
513     m_privEnter.rev1Storage = Rev1Storage(rev1StorageAddr);
514     m_privEnter.rev2Storage = Rev2Storage(address(m_investors));
515     m_privEnter.investorMaxInvestment = 50 ether;
516     m_privEnter.endTimestamp = timestamp;
517     emit LogPEInit(
518       now, 
519       address(m_privEnter.rev1Storage), 
520       address(m_privEnter.rev2Storage), 
521       m_privEnter.investorMaxInvestment, 
522       m_privEnter.endTimestamp
523     );
524   }
525 
526   function setAdvertisingAddress(address addr) public onlyOwner {
527     addr.requireNotZero();
528     advertisingAddress = addr;
529   }
530 
531   function setAdminsAddress(address addr) public onlyOwner {
532     addr.requireNotZero();
533     adminsAddress = addr;
534   }
535 
536   function privateEntranceProvideAccessFor(address[] addrs) public onlyOwner {
537     m_privEnter.provideAccessFor(addrs);
538   }
539 
540   function rapidGrowthProtectionmMaxInvestmentAtNow() public view returns(uint investment) {
541     investment = m_rgp.maxInvestmentAtNow();
542   }
543 
544   function investorsNumber() public view returns(uint) {
545     return m_investors.size();
546   }
547 
548   function balanceETH() public view returns(uint) {
549     return address(this).balance;
550   }
551 
552   function percent1() public view returns(uint numerator, uint denominator) {
553     (numerator, denominator) = (m_1_percent.num, m_1_percent.den);
554   }
555 
556   function percent2() public view returns(uint numerator, uint denominator) {
557     (numerator, denominator) = (m_2_percent.num, m_2_percent.den);
558   }
559 
560   function percent3_33() public view returns(uint numerator, uint denominator) {
561     (numerator, denominator) = (m_3_33_percent.num, m_3_33_percent.den);
562   }
563 
564   function advertisingPercent() public view returns(uint numerator, uint denominator) {
565     (numerator, denominator) = (m_advertisingPercent.num, m_advertisingPercent.den);
566   }
567 
568   function adminsPercent() public view returns(uint numerator, uint denominator) {
569     (numerator, denominator) = (m_adminsPercent.num, m_adminsPercent.den);
570   }
571 
572   function investorInfo(address investorAddr) public view returns(uint investment, uint paymentTime, bool isReferral) {
573     (investment, paymentTime) = m_investors.investorInfo(investorAddr);
574     isReferral = m_referrals[investorAddr];
575   }
576 
577   function investorDividendsAtNow(address investorAddr) public view returns(uint dividends) {
578     dividends = calcDividends(investorAddr);
579   }
580 
581   function dailyPercentAtNow() public view returns(uint numerator, uint denominator) {
582     Percent.percent memory p = dailyPercent();
583     (numerator, denominator) = (p.num, p.den);
584   }
585 
586   function refBonusPercentAtNow() public view returns(uint numerator, uint denominator) {
587     Percent.percent memory p = refBonusPercent();
588     (numerator, denominator) = (p.num, p.den);
589   }
590 
591   function getMyDividends() public notFromContract balanceChanged {
592     // calculate dividends
593     uint dividends = calcDividends(msg.sender);
594     require (dividends.notZero(), "cannot to pay zero dividends");
595 
596     // update investor payment timestamp
597     assert(m_investors.setPaymentTime(msg.sender, now));
598 
599     // check enough eth - goto next wave if needed
600     if (address(this).balance <= dividends) {
601       nextWave();
602       dividends = address(this).balance;
603     } 
604 
605     // transfer dividends to investor
606     msg.sender.transfer(dividends);
607     emit LogPayDividends(msg.sender, now, dividends);
608   }
609 
610   function doInvest(address referrerAddr) public payable notFromContract balanceChanged {
611     uint investment = msg.value;
612     uint receivedEther = msg.value;
613     require(investment >= minInvesment, "investment must be >= minInvesment");
614     require(address(this).balance <= maxBalance, "the contract eth balance limit");
615 
616     if (m_rgp.isActive()) { 
617       // use Rapid Growth Protection if needed
618       uint rpgMaxInvest = m_rgp.maxInvestmentAtNow();
619       rpgMaxInvest.requireNotZero();
620       investment = Math.min(investment, rpgMaxInvest);
621       assert(m_rgp.saveInvestment(investment));
622       emit LogRGPInvestment(msg.sender, now, investment, m_rgp.currDay());
623       
624     } else if (m_privEnter.isActive()) {
625       // use Private Entrance if needed
626       uint peMaxInvest = m_privEnter.maxInvestmentFor(msg.sender);
627       peMaxInvest.requireNotZero();
628       investment = Math.min(investment, peMaxInvest);
629     }
630 
631     // send excess of ether if needed
632     if (receivedEther > investment) {
633       uint excess = receivedEther - investment;
634       msg.sender.transfer(excess);
635       receivedEther = investment;
636       emit LogSendExcessOfEther(msg.sender, now, msg.value, investment, excess);
637     }
638 
639     // commission
640     advertisingAddress.transfer(m_advertisingPercent.mul(receivedEther));
641     adminsAddress.transfer(m_adminsPercent.mul(receivedEther));
642 
643     bool senderIsInvestor = m_investors.isInvestor(msg.sender);
644 
645     // ref system works only once and only on first invest
646     if (referrerAddr.notZero() && !senderIsInvestor && !m_referrals[msg.sender] &&
647       referrerAddr != msg.sender && m_investors.isInvestor(referrerAddr)) {
648       
649       m_referrals[msg.sender] = true;
650       // add referral bonus to investor`s and referral`s investments
651       uint refBonus = refBonusPercent().mmul(investment);
652       assert(m_investors.addInvestment(referrerAddr, refBonus)); // add referrer bonus
653       investment += refBonus;                                    // add referral bonus
654       emit LogNewReferral(msg.sender, referrerAddr, now, refBonus);
655     }
656 
657     // automatic reinvest - prevent burning dividends
658     uint dividends = calcDividends(msg.sender);
659     if (senderIsInvestor && dividends.notZero()) {
660       investment += dividends;
661       emit LogAutomaticReinvest(msg.sender, now, dividends);
662     }
663 
664     if (senderIsInvestor) {
665       // update existing investor
666       assert(m_investors.addInvestment(msg.sender, investment));
667       assert(m_investors.setPaymentTime(msg.sender, now));
668     } else {
669       // create new investor
670       assert(m_investors.newInvestor(msg.sender, investment, now));
671       emit LogNewInvestor(msg.sender, now);
672     }
673 
674     investmentsNumber++;
675     emit LogNewInvesment(msg.sender, now, investment, receivedEther);
676   }
677 
678   function getMemInvestor(address investorAddr) internal view returns(InvestorsStorage.Investor memory) {
679     (uint investment, uint paymentTime) = m_investors.investorInfo(investorAddr);
680     return InvestorsStorage.Investor(investment, paymentTime);
681   }
682 
683   function calcDividends(address investorAddr) internal view returns(uint dividends) {
684     InvestorsStorage.Investor memory investor = getMemInvestor(investorAddr);
685 
686     // safe gas if dividends will be 0
687     if (investor.investment.isZero() || now.sub(investor.paymentTime) < 10 minutes) {
688       return 0;
689     }
690     
691     // for prevent burning daily dividends if 24h did not pass - calculate it per 10 min interval
692     // if daily percent is X, then 10min percent = X / (24h / 10 min) = X / 144
693 
694     // and we must to get numbers of 10 min interval after investor got payment:
695     // (now - investor.paymentTime) / 10min 
696 
697     // finaly calculate dividends = ((now - investor.paymentTime) / 10min) * (X * investor.investment)  / 144) 
698 
699     Percent.percent memory p = dailyPercent();
700     dividends = (now.sub(investor.paymentTime) / 10 minutes) * p.mmul(investor.investment) / 144;
701   }
702 
703   function dailyPercent() internal view returns(Percent.percent memory p) {
704     uint balance = address(this).balance;
705 
706     // (3) 3.33% if balance < 1 000 ETH
707     // (2) 2% if 1 000 ETH <= balance <= 33 333 ETH
708     // (1) 1% if 33 333 ETH < balance
709 
710     if (balance < 1000 ether) { 
711       p = m_3_33_percent.toMemory(); // (3)
712     } else if ( 1000 ether <= balance && balance <= 33333 ether) {
713       p = m_2_percent.toMemory();    // (2)
714     } else {
715       p = m_1_percent.toMemory();    // (1)
716     }
717   }
718 
719   function refBonusPercent() internal view returns(Percent.percent memory p) {
720     uint balance = address(this).balance;
721 
722     // (1) 1% if 100 000 ETH < balance
723     // (2) 2% if 10 000 ETH <= balance <= 100 000 ETH
724     // (3) 3.33% if balance < 10 000 ETH   
725     
726     if (balance < 10000 ether) { 
727       p = m_3_33_percent.toMemory(); // (3)
728     } else if ( 10000 ether <= balance && balance <= 100000 ether) {
729       p = m_2_percent.toMemory();    // (2)
730     } else {
731       p = m_1_percent.toMemory();    // (1)
732     }          
733   }
734 
735   function nextWave() private {
736     m_investors = new InvestorsStorage();
737     investmentsNumber = 0;
738     waveStartup = now;
739     m_rgp.startAt(now);
740     emit LogRGPInit(now , m_rgp.startTimestamp, m_rgp.maxDailyTotalInvestment, m_rgp.activityDays);
741     emit LogNextWave(now);
742   }
743 }